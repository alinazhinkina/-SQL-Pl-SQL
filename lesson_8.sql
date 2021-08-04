select first_name || ' ' || substr(last_name, 1, 1), 
        substr(email, instr(email, '@'), length(email))
from employees;

select *
from goods
where goods_name like '%а%';

select *
from goods
where regexp_like(goods_name,'а');

select rpad(lpad(quantity, 15), 25), delivery_date,
        case when to_date(delivery_date,'dd.mm.yy') = to_date('26.07.21','dd.mm.yy')
        then 'Yes' else to_char(to_date('26.07.21','dd.mm.yy')) end dat
from goods_delivery;

select nullif(employee_id, manager_id)
from employees;

select nvl(manager_id, 111)
from employees;

select manager_id, nvl2(manager_id, 1, 0)
from employees;

