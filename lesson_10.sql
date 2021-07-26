create or replace procedure empFirstLastName(
    n in number default 0)
as 
    emp_name varchar2(50);
begin
    select first_name || ' ' || last_name into emp_name
    from employees
    where employee_id = n;
    
    dbms_output.put_line(emp_name); 
exception
    when no_data_found then
    dbms_output.put_line('No data found!');
end;
/

begin    
    empFirstLastName(1);
end;
/

---------------------------------------------------------------

create or replace function arithmetic(
    x in number default 0,
    y in number default 0,
    z in number default 0)
    return number
is 
    result number := 0;
begin
    result := (x + y) ** 2 - z; 
return result;
end;
/

declare
   a number := 1;
   b number := 2;
   c number := 4;
begin
   dbms_output.put_line(arithmetic(a, b, c));   
end;
/

-----------------------------------------------------------------
--возвращает последние 2 цифры номера телефона сотрудника
create or replace function last_number_phone_number(
    phone_numb in varchar2)
    return varchar2
is
begin
    return substr(phone_numb, length(phone_numb) - 1, 2);
end;
/

select last_number_phone_number(phone_number)
from employees
where employee_id = 2;

-----------------------------------------------------------------

create or replace NONEDITIONABLE package employee_actions as
    procedure empFirstLastName(n in number default 0);
    function arithmetic(
        x in number default 0,
        y in number default 0,
        z in number default 0)
    return number;
    function arithmetic(
        n in number default 0,
        m in number default 0)
    return number;
    function last_number_phone_number(phone_numb in varchar2)
    return varchar2;
end;
/

create or replace NONEDITIONABLE package body employee_actions as
    procedure empFirstLastName(
        n in number default 0)
    as 
        emp_name varchar2(50);
    begin
        select first_name || ' ' || last_name into emp_name
        from employees
        where employee_id = n;

        dbms_output.put_line(emp_name); 
    exception
        when no_data_found then
        dbms_output.put_line('No data found!');
    end;

    function arithmetic(
        x in number default 0,
        y in number default 0,
        z in number default 0)
        return number
    is 
        result number := 0;
    begin
        result := (x + y) ** 2 - z; 
    return result;
    end;
    
    function arithmetic(
        n in number default 0,
        m in number default 0)
        return number
    is 
        result number := 0;
    begin
        result := n * m; 
    return result;
    end;

    function last_number_phone_number(
        phone_numb in varchar2)
        return varchar2
    is
    begin
        return substr(phone_numb, length(phone_numb) - 1, 2);
    end;
end;
/

--пример вызова процедуры и функции из пакета
begin
    employee_actions.empfirstlastname(78);
end;
/

select employee_actions.last_number_phone_number(phone_number)
from employees
where employee_id = 5;

begin
    dbms_output.put_line(employee_actions.arithmetic(n => 2, m => 3));
end;
/