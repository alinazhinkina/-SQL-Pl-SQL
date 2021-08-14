create table client
    ( id			number(15)
	,	constraint  client_id_pk   primary key (id)
    , cl_name		varchar2(100)
    , date_birth	date
    ) ;
	
create table plan_oper
    ( collection_id	number(15)
	--,	constraint  plan_oper_collect_id_pk   primary key (collection_id)
    , p_date		date
    , p_summa		number
	, type_oper		varchar2(40)
    ) ;
	
create table fact_oper
    ( collection_id	number(15)
    , f_date		date
    , f_summa		number
	, type_oper		varchar2(40)
    ) ;
	
	
create table pr_cred
    ( id			number(15)
	,	constraint  pr_cred_id_pk   primary key (id)
	, num_dog		varchar2(20)
    , summa_dog		number
    , date_begin	date
    , date_end		date
	, id_client		number(15)
	,	constraint	pr_cred_id_client_fk   foreign key (id_client)
                                    references client (id)
	, collect_plan	number(15)
	, collect_fact	number(15)
	) ;
	
--alter table fact_oper
--add constraint fact_oper_pk primary key (collection_id, type_oper);

alter table pr_cred
add constraint pr_cred_col_plan_unique 
unique (collect_plan);

alter table pr_cred
add constraint pr_cred_col_fact_unique
unique (collect_fact);

/*alter table plan_oper
add constraint plan_oper_col_id_fk 
foreign key (collection_id) references pr_cred (collect_plan);

alter table fact_oper
add constraint fact_oper_col_id_fk 
foreign key (collection_id) references pr_cred (collect_fact);
*/

/*create table fact_oper_initial
as (select * from fact_oper);

create or replace trigger fact_oper_initial_after_insert
    after insert on fact_oper_initial
begin
    insert /*+ append */ 
	/*into fact_oper
    (select * from fact_oper_initial) 
    order by fact_oper_initial.f_date;
end;
/*/

--insert into tables
--sqlldr creditor/111 control=D:\Database\Oracle\scripts\Coursework_Credit_Portfolio\data\insert_client.ctl data=D:\Database\Oracle\scripts\Coursework_Credit_Portfolio\data\client.csv

--sqlldr creditor/111 control=D:\Database\Oracle\scripts\Coursework_Credit_Portfolio\data\insert_fact_oper.ctl data=D:\Database\Oracle\scripts\Coursework_Credit_Portfolio\data\fact_oper.csv

--sqlldr creditor/111 control=D:\Database\Oracle\scripts\Coursework_Credit_Portfolio\data\insert_plan_oper.ctl data=D:\Database\Oracle\scripts\Coursework_Credit_Portfolio\data\plan_oper.csv

--sqlldr creditor/111 control=D:\Database\Oracle\scripts\Coursework_Credit_Portfolio\data\insert_pr_cred.ctl data=D:\Database\Oracle\scripts\Coursework_Credit_Portfolio\data\pr_cred.csv

alter table plan_oper
add constraint plan_oper_col_id_fk 
foreign key (collection_id) references pr_cred (collect_plan);

alter table fact_oper
add constraint fact_oper_col_id_fk 
foreign key (collection_id) references pr_cred (collect_fact);

--create sequences
select max(id)
from client;

create sequence seq_client_id
minvalue 1
start with 6317144161625
increment by 1;

select max(id) 
from pr_cred;

create sequence seq_pr_cred_id
minvalue 1
start with 6446261209928
increment by 1;

select max(collection_id)
from fact_oper;

create sequence seq_fact_oper_collect_id
minvalue 1
start with 6446261209930
increment by 1;

select max(collection_id)
from plan_oper;

create sequence seq_plan_oper_collect_id
minvalue 1
start with 6446261209932
increment by 1;

--triggers
create or replace trigger pr_cred_before_insert
    before insert on pr_cred
    for each row
declare
begin
    :new.id := SEQ_PR_CRED_ID.nextval;
end;
/

create or replace trigger fact_oper_before_insert
    before insert on fact_oper
    for each row
declare
begin
    :new.f_date := sysdate;
end;
/