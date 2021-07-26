--количество подчиненных сотрудников у менеджера
select count(employee_id)
from employees
where manager_id = 1;

--выбрать запись с наибольшим количеством доставки товара
select *
from goods_delivery
where quantity = (select max(quantity) from goods_delivery);

--кто принял товар с наибольшим количеством доставки
select emp.first_name, emp.last_name
from goods_delivery gd
	join employees emp
	on gd.employee_id = emp.employee_id
where quantity = (select max(quantity) from goods_delivery);

--кто, сколько принял в суммарном количестве товаров
select emp.first_name, emp.last_name, sum(gd.quantity)
from goods_delivery gd
	join employees emp
	on gd.employee_id = emp.employee_id
group by emp.first_name, emp.last_name;

--минимальное и максимальное количество поставки каждого товара 
--отсортировано в обратном порядке
select goods_id, max(quantity), min(quantity)
from goods_delivery
group by goods_id
order by goods_id desc