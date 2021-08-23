create or replace view loan_portfolio_state_at_date as
    select  p.num_dog, 
            c.cl_name, 
            p.summa_dog, 
            p.date_begin, 
            p.date_end, 
            creditor_actions.balance_debt_date(c.id, p.num_dog, sysdate) balance_dept,
            creditor_actions.upcoming_interest_amount(c.id, p.num_dog, sysdate) upcoming_amount,
            to_char(sysdate, 'dd.mm.yy hh24:mi:ss') report_dt 
    from pr_cred p, client c
    where 1=1
        and p.id_client = c.id;
		
select *
from loan_portfolio_state_at_date;