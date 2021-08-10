create or replace function balance_debt_date(
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
    dbms_output.put_line('No data found!');   
end;
/



create or replace function upcoming_interest_amount(
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
    dbms_output.put_line('No data found!');   
end;
/

create or replace view loan_portfolio_state_at_date as
    select  p.num_dog, 
            c.cl_name, 
            p.summa_dog, 
            p.date_begin, 
            p.date_end, 
            balance_debt_date(c.id, p.num_dog, sysdate) balance_dept,
            upcoming_interest_amount(c.id, p.num_dog, sysdate) upcoming_amount,
            to_char(sysdate, 'dd.mm.yy hh24:mi:ss') report_dt 
    from pr_cred p, client c
    where 1=1
        and p.id_client = c.id;
        
select *
from loan_portfolio_state_at_date;