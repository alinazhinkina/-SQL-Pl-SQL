--выдача кредита
create or replace procedure loan_issuing(
    cl_id in number,
    amount in number default 0)
as  
    col_fact number := 0;
begin
    select collect_fact into col_fact
    from pr_cred
    where id_client = cl_id;
    
    insert into fact_oper (collection_id, f_summa, type_oper)
    values (col_fact, amount, 'Выдача кредита');
    
exception
    when no_data_found then
    dbms_output.put_line('No data found!');
end;
/



create or replace procedure contract_opening(
    cl_id in number,
    amount in number default 0,
    date_b in date,
    loan_period_mon in number default 0,    --срок кредита в месяцах
    interest_rate  in number default 0)     --процентная ставка
as  
    new_num_dog varchar2(20);
    rep_loan number := 0;                   --погашение кредита
    debt_amount number := 0;    --остаток задолженности
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
        debt_amount
    end loop;
    
exception
    when no_data_found then
    dbms_output.put_line('No data found!');
end;
/