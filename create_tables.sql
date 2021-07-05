create table goods_type
    ( type_id       number(6)
	,	constraint  goods_type_type_id_pk   
                    primary key (type_id)
    , type_name     varchar2(20)
        constraint  goods_type_type_name_nn   NOT NULL
    ) ;
    
create table goods
    ( goods_id       number(6)
	,	constraint  goods_goods_id_pk   primary key (goods_id)
    , goods_name     varchar2(20)
        constraint  goods_name_nn   NOT NULL
    , type_id        number(4)
        constraint  goods_type_id_nn   not null  
	,	constraint  goods_type_id_fk   foreign key (type_id)
                                    references goods_type (type_id)
    , price          number(8,2)
        constraint  goods_price_min   check (price > 0)
    ) ;

create table employees
    ( employee_id    number(6)
    , constraint     emp_emp_id_pk
                       primary key (employee_id)
    , first_name     varchar2(20)
        constraint     emp_first_name_nn  not null
    , last_name      varchar2(25)
        constraint     emp_last_name_nn  not null
    , email          varchar2(25)
        constraint     emp_email_nn  not null
    ,   constraint     emp_email_uk
                     unique (email)
    , phone_number   varchar2(20)
    , hire_date      date
        constraint     emp_hire_date_nn  not null
    , manager_id     number(6)
        constraint     emp_manager_id_nn  not null
	,	constraint	   emp_manager_id_fk   foreign key (manager_id)
                                    references employees (employee_id)
    , salary         number(8,2)
        constraint     emp_salary_min
                     check (salary > 0)
    , department_id  number(4)
    ) ;
	
	

create table goods_delivery
    ( delivery_id       number(6)
    ,   constraint  deliv_deliv_id_pk   primary key (delivery_id)
	,	goods_id       number(6)
        constraint  deliv_goods_id_nn   NOT NULL
	,	constraint  deliv_goods_id_fk   foreign key (goods_id)
                                    references goods (goods_id)
    , delivery_date     DATE
        constraint  deliv_deliv_date_nn   NOT NULL
    , quantity          number(8,2)
        constraint  deliv_quantity_nn   not null        
    , employee_id       number(6)
        constraint  deliv_emp_id_nn   not null
    ,	constraint  deliv_emp_id_fk   foreign key (employee_id)
                                    references employees (employee_id)
    ) ;
    

alter table goods_delivery 
MODIFY delivery_date default sysdate;

alter table employees 
MODIFY hire_date default sysdate;

create sequence seq_employees_id
minvalue 1
start with 1
increment by 1;

create sequence seq_goods_id
minvalue 1
start with 1
increment by 1;

create sequence seq_goods_deliv_id
minvalue 1
start with 1
increment by 1;

create sequence seq_good_type_id
minvalue 1
start with 1
increment by 1;