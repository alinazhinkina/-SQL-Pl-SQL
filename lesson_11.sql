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

--triggers
create table goods_audit
    ( id        number(6)
    ,	constraint  goods_audit_id_pk
                    primary key (id)
    , goods_id  number(6)
    , username  varchar2(30)
    ) ;
	
create sequence seq_goods_audit_id
minvalue 1
start with 1
increment by 1;

create or replace trigger goods_after_insert
    after insert on goods
    for each row
declare
    username varchar2(30);
begin
    select user into username
    from dual;
    
    insert into goods_audit
    values (seq_goods_audit_id.nextval, :new.goods_id, username);
end;
/

insert into goods
values (seq_goods_id.nextval, 'морковь', 4, 40);

select *
from goods_audit;
