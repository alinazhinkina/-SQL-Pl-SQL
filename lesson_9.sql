--включает вывод сообщение в output (SQL*Plus)
set serveroutput on;

declare
    h_w varchar2(50) := 'Hello world!';
begin
    dbms_output.put_line(h_w);
end;
/

create table deliv_table
    ( goods_id       number(6)
    , quantity          number(8,2)     
    , emp_id       number(6)
    ) ;
	
declare
    delivery deliv_table%rowtype;
begin
    select goods_id, quantity, employee_id into delivery
    from goods_delivery
    where goods_id = 30
        and quantity =110;
    
    dbms_output.put_line('ID ' || delivery.goods_id);
    dbms_output.put_line('QUANTITY ' ||delivery.quantity);
end;
/