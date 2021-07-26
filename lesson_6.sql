--смотрим разницу между агрегатными функциями и аналитическими
select department_id, sum(salary) sum_sal
from employees
group by department_id;

select department_id, 
        sum(salary) over(partition by department_id) sum_sal
from employees;

--посчитать сколько стоят отдельно все овощи и фрукты
select distinct (type_name), 
        sum(price) over(partition by goods.type_id)
from goods 
join goods_type gt on goods.type_id = gt.type_id;

--то же самое, сортировав по стоимости и наложением окна от первого в группе до текущего
select type_name, 
        sum(price) 
        over(partition by goods.type_id order by goods.price
        rows between unbounded preceding and current row)
from goods
join goods_type gt on goods.type_id = gt.type_id;

--нашли минимульную стоимость среди овощей и фруктов, используя аналитическую функцию
select distinct (type_name), 
        first_value(price) 
        over(partition by goods.type_id
        order by goods.type_id)
from goods 
join goods_type gt on goods.type_id = gt.type_id

--суммировать зарплаты и найти максимальную по департаменту и менеджеру
select distinct(department_id), manager_id,
        sum(salary) over(partition by manager_id, department_id) sum_sal,
        max(salary) over(partition by manager_id, department_id) max_sal
from employees
order by department_id;

--то же самое без учета самих менеджеров
select distinct(department_id), manager_id,
        sum(salary) over(partition by manager_id, department_id) sum_sal,
        max(salary) over(partition by manager_id, department_id) max_sal
from employees
where employee_id not in (select manager_id from employees)
order by department_id;

--суммирование по строкам в обратном порядке зарплат по департаменту и менеджеру, упорядочив по дате приема на работу
select hire_date, department_id, manager_id, salary,
        sum(salary) 
        over(partition by manager_id, department_id
        order by hire_date
        rows between current row and unbounded following) sum_sal
from employees;

--найти, кто принял больше всего товара
with table1 as
    (select emp.first_name fName, emp.last_name lName, sum(gd.quantity) sumQ
    from goods_delivery gd
    join employees emp
    on gd.employee_id = emp.employee_id
    group by emp.first_name, emp.last_name)    

select fName, lName, sumQ
from table1
where sumQ = (select max(sumQ) from table1)


