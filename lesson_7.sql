--смотрим планы выполнения запросов
explain plan for
    select count(employee_id)
    from employees
    where manager_id = 1;
    
select * from table(dbms_xplan.display(format => 'all'));

explain plan for
    select emp.first_name, emp.last_name
    from goods_delivery gd
        join employees emp
        on gd.employee_id = emp.employee_id
    where quantity = (select max(quantity) from goods_delivery);
    
select * from table(dbms_xplan.display(format => 'all'))

--использование подсказки в запросе
select /*+ LEADING(emp) */
    emp.first_name, emp.last_name, sum(gd.quantity)
from goods_delivery gd
	join employees emp
	on gd.employee_id = emp.employee_id
group by emp.first_name, emp.last_name;

explain plan for
    select /*+ PARALLEL(8) */
        goods_id, max(quantity), min(quantity)
        from goods_delivery
        group by goods_id
        order by goods_id desc;
        
select * from table(dbms_xplan.display(format => 'all'));

--смотрим статистику для таблицы
select *
from   dba_tab_statistics
where  table_name = 'GOODS'
       and owner = 'USERNAME';
	   
select owner,table_name,num_rows,sample_size,last_analyzed,tablespace_name
from dba_tables where owner='USERNAME'
order by owner