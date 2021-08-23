create or replace package creditor_actions as
    procedure loan_issuing(             cl_id in number,
                                        amount in number default 0,
                                        date_beg in date);

    procedure contract_opening(         cl_id in number,
                                        amount in number default 0,
                                        date_b in date,
                                        loan_period_mon in number default 0,
                                        interest_rate  in number default 0);

    procedure loan_repayment(           cl_id in number,
                                        amount in number default 0,
                                        date_beg in date);
                                        
    procedure loan_portfolio_state_at_date;

    function balance_debt_date(         cl_id in number,
                                        num_dogovor in varchar2,
                                        spec_date in date)
    return number;

    function upcoming_interest_amount(  cl_id in number,
                                        num_dogovor in varchar2,
                                        spec_date in date)
    return number;                                
end;
/

create or replace package body creditor_actions as
    procedure loan_issuing( cl_id in number,
                            amount in number default 0,
                            date_beg in date)
    as  
        col_fact number := 0;
    begin
        select collect_fact into col_fact
        from pr_cred
        where id_client = cl_id
            and to_date(date_begin, 'dd.mm.yy') = to_date(date_beg, 'dd.mm.yy');
    
        insert into fact_oper (collection_id, f_summa, type_oper)
        values (col_fact, amount, 'Выдача кредита');
    
    exception
        when no_data_found then
            raise_application_error(-20000,'No data found!');
    end;

    procedure contract_opening(cl_id in number,
                amount in number default 0,
                date_b in date,
                loan_period_mon in number default 0,    --срок кредита в месяцах
                interest_rate  in number default 0)     --процентная ставка
    as  
        new_num_dog varchar2(20);
        rep_loan number := 0;                   --погашение кредита
        debt_amount number := 0;                --остаток задолженности
        rep_interest number := 0;               --погашение процентов
    begin
        select  substr(num_dog, 0, 5) || 
                to_char(to_number(substr(num_dog, -2)) + 1) into new_num_dog
        from pr_cred
        where id = (select max(id)
                    from pr_cred);
    
        insert into pr_cred 
                (num_dog,
                summa_dog,
                date_begin,
                date_end,
                id_client,
                collect_plan,
                collect_fact)
        values  (new_num_dog,
                amount,
                date_b,
                add_months(date_b, loan_period_mon),
                cl_id,
                seq_plan_oper_collect_id.nextval,
                seq_fact_oper_collect_id.nextval);
    
        insert into plan_oper
        values (seq_plan_oper_collect_id.currval,
                date_b,
                amount,
                'Выдача кредита');
    
        rep_loan := amount/loan_period_mon;
    
        for mon in 1..loan_period_mon
        loop
            debt_amount := amount - (rep_loan * (mon-1));
            rep_interest := debt_amount * (interest_rate/100) / 12;
    
            insert into plan_oper
            values (seq_plan_oper_collect_id.currval,
                add_months(date_b, mon),
                round(rep_loan, 2),
                'Погашение кредита');
            insert into plan_oper
            values (seq_plan_oper_collect_id.currval,
                add_months(date_b, mon),
                round(rep_interest, 2),
                'Погашение процентов');
        end loop;
    
    exception
        when no_data_found then
            raise_application_error(-20010,'No data found!');
    end;

    procedure loan_repayment(   cl_id in number,
                                amount in number default 0,
                                date_beg in date)
    as  
        col_fact number := 0;
    begin
        select collect_fact into col_fact
        from pr_cred
        where id_client = cl_id
            and to_date(date_begin, 'dd.mm.yy') = to_date(date_beg, 'dd.mm.yy');
    
        insert into fact_oper (collection_id, f_summa, type_oper)
        values (col_fact, amount, 'Погашение кредита');
    
    exception
        when no_data_found then
            raise_application_error(-20020,'No data found!');
    end;
    
    procedure loan_portfolio_state_at_date
    as
        fHandle UTL_FILE.FILE_TYPE;
    begin
        /* Открыть файл для записи и получить его файловый дескриптор */
        fHandle := UTL_FILE.FOPEN('UTL_FILE_DIR',
                                    'output' || sysdate || '.csv' ,'w');
        UTL_FILE.PUT_LINE(fHandle,'NUM_DOG;'||'CL_NAME;'||'SUMMA_DOG;'||'DATE_BEGIN;'
                            ||'DATE_END;'||'BALANCE_DEPT;'||'UPCOMING_AMOUNT;'||'REPORT_DT');
        
        /* Запись в файл*/
        for row in (select *
                    from loan_portfolio_state_at_date)
        loop
            UTL_FILE.PUT_LINE(fHandle,convert(row.num_dog ||';' || row.cl_name || ';' || 
                                row.summa_dog || ';' || row.date_begin || ';' || 
                                row.date_end || ';' || row.balance_dept || ';' || 
                                row.upcoming_amount || ';' || row.report_dt, 
                                'CL8MSWIN1251'));
        end loop;
        /* Закрыть файл*/
        UTL_FILE.FCLOSE(fHandle);
        /* Блок обработки исключений для ошибок UTL_File */
    exception
        when utl_file.invalid_path then
        raise_application_error(-20100,'Неверный путь');
        when utl_file.invalid_mode then
        raise_application_error(-20101,'Неверный режим');
        when utl_file.invalid_operation then
        raise_application_error(-20102,'Неверная операция');
        when utl_file.invalid_filehandle then
        raise_application_error(-20103,'Неверный файловый дескриптор');
        when utl_file.write_error then
        raise_application_error(-20104,'Ошибка записи');
        when utl_file.read_error then
        raise_application_error(-20105,'Ошибка чтения');
        when utl_file.internal_error then
        raise_application_error(-20106,'Внутренняя ошибка');
        when others then
        utl_file.fclose(fhandle);
    end;

    function balance_debt_date(
                    cl_id in number,
                    num_dogovor in varchar2,
                    spec_date in date)
        return number
    is
        result number := 0;
    begin
        with sum_table as
        (select p.num_dog num, sum(f.f_summa) repayment
        from fact_oper f, pr_cred p
        where 1=1
            and f.collection_id = p.collect_fact
            and f.type_oper = 'Погашение кредита'
            and f.f_date <= to_date(spec_date)
            --and f.f_date <= sysdate
        group by p.num_dog)
    
        select f.f_summa - s.repayment into result
            from fact_oper f, pr_cred p, sum_table s
            where 1=1
                and f.collection_id = p.collect_fact
                and p.num_dog = s.num
                and f.type_oper = 'Выдача кредита'
                and f.f_date <= to_date(spec_date)
                --and f.f_date <= sysdate
                and p.id_client = cl_id
                and p.num_dog = num_dogovor;
        return result;
    exception
        when no_data_found then
            raise_application_error(-20030,'No data found!');   
    end;

    function upcoming_interest_amount(
                        cl_id in number,
                        num_dogovor in varchar2,
                        spec_date in date)
        return number
    is
        plan_repayment number := 0;
        fact_repayment number := 0;
    begin
        select sum(po.p_summa) into plan_repayment
        from plan_oper po, pr_cred pc
        where 1=1
            and po.collection_id = pc.collect_plan
            and po.type_oper = 'Погашение процентов'
            and po.p_date <= to_date(spec_date)
            --and po.p_date <= sysdate
            and pc.id_client = cl_id
            and pc.num_dog = num_dogovor
        group by pc.num_dog;
    
        select sum(f.f_summa) into fact_repayment
        from fact_oper f, pr_cred p
        where 1=1
            and f.collection_id = p.collect_fact
            and f.type_oper = 'Погашение процентов'
            and f.f_date <= to_date(spec_date)
            --and f.f_date <= sysdate
            and p.id_client = cl_id
            and p.num_dog = num_dogovor
        group by p.num_dog;
    
        return (plan_repayment - fact_repayment);
    exception
        when no_data_found then
            raise_application_error(-20040,'No data found!');   
    end;
end;
/
