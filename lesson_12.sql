set serveroutput on;

create or replace procedure type_goods_name(
    n in number default 0)
as 
    type_goods_name varchar2(50);
begin
    select gt.type_name into type_goods_name
    from goods, goods_type gt
    where goods.type_id = gt.type_id
        and goods.goods_id = n;
		
    if type_goods_name = 'овощи'
    then
        dbms_output.put_line(UPPER(type_goods_name)); 
    elsif type_goods_name = 'фрукты'
    then
        dbms_output.put_line(UPPER(type_goods_name));
    else
        dbms_output.put_line(UPPER('Возможно ягоды'));
    end if;
exception
    when no_data_found then
    dbms_output.put_line('No data found!');
end;
/

begin    
    type_goods_name(30);
end;
/

--------------------------------------------------------------------------

create or replace procedure deliv_depart(
    gname in varchar2 default '')
as 
    type deliv is record (
                deliv_depart varchar2(50),
                deliv_date date
                );
    deliv_rec deliv;
begin
    select emp.department_id, 
            gd.delivery_date into deliv_rec
    from goods_delivery gd, employees emp, goods
    where gd.employee_id = emp.employee_id
        and goods.goods_id = gd.goods_id
        and goods.goods_name = gname
        and rownum = 1;
        
    case deliv_rec.deliv_depart
        when 1 then 
                dbms_output.put_line(deliv_rec.deliv_date || ' принимал первый отдел');
        when 2 then 
                dbms_output.put_line(deliv_rec.deliv_date || ' принимал второй отдел');
        when 3 then 
                dbms_output.put_line(deliv_rec.deliv_date || ' принимал третий отдел');
        when 4 then 
                dbms_output.put_line(deliv_rec.deliv_date || ' принимал четвертый отдел');
        when 5 then 
                dbms_output.put_line(deliv_rec.deliv_date || ' принимал пятый отдел');
        end case;    
    
exception
    when no_data_found then
    dbms_output.put_line('No data found!');
end;
/

begin
    deliv_depart('яблоко');
end;
/

------------------------------------------------------------------------------
--считает кол-во дней (без выходных) в каждом месяце заданного года
create or replace procedure count_mon_days (
    c_year in number default 2014)    
as
    days_in_mon number;
    day_number number;
    count_mon_days number;
begin
    for count_months in 1..12
    loop
        select to_char(last_day(to_date('01.' || 
                to_char(count_months) || '.' ||
                to_char(c_year), 'dd.mm.yyyy')), 'dd') into days_in_mon
        from dual;
        
        count_mon_days := 0;
        for count_days in 1..days_in_mon
        loop
            select to_char(to_date(to_char(count_days) || '.' || 
                to_char(count_months) || '.' ||
                to_char(c_year), 'dd.mm.yyyy'), 'd') into day_number
            from dual;
            
            if day_number in (1, 2, 3, 4, 5) then
                count_mon_days := count_mon_days + 1;
            end if;
        end loop;
        
        
        dbms_output.put_line(to_char(to_date(count_months, 'mm'), 'month') || '   ' || count_mon_days);
    end loop;
end;
/

begin
    count_mon_days();
end;

-----------------------------------------------------------------------------

create or replace procedure add_employee (
    f_name in varchar2, 
    s_name in varchar2, 
    f_name_eng in varchar2, 
    s_name_eng in varchar2,
    dep in number)    
as
    row_emp employees%rowtype;
begin
     select * into row_emp
     from employees
     where department_id = dep
            --and rownum = 1;
            and employee_id = 12;
            
    insert into employees
    values (seq_employees_id.nextval, f_name, s_name, f_name_eng || s_name_eng || '@email.com',
            regexp_replace(row_emp.phone_number,'.$','2'), sysdate, row_emp.manager_id, row_emp.salary, dep);
        
    dbms_output.put_line(row_emp.first_name);
end;
/

begin
    add_employee('Татьяна', 'Двенад', 'Tatijana', 'Dvenad', 2);
end;
/