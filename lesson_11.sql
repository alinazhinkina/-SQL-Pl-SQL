--представления
create or replace view goods_with_a as
    select *
    from goods
    where goods_name like '%а%';
    
select *
from goods_with_a;

create or replace view how_much_accept_emp as
    select emp.first_name, emp.last_name, sum(gd.quantity) sumQ
    from goods_delivery gd, employees emp
    where gd.employee_id = emp.employee_id
    group by emp.first_name, emp.last_name;

select *
from how_much_accept_emp;

create or replace view cost_fruits_vegetables as
    select distinct (type_name) type_name, 
            sum(price) over(partition by goods.type_id) price
    from goods, goods_type gt
    where goods.type_id = gt.type_id;
    
select * 
from cost_fruits_vegetables;