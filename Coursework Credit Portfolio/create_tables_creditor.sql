create table client
    ( id			number(15)
	,	constraint  client_id_pk   primary key (id)
    , cl_name		varchar2(100)
    , date_birth	date
    ) ;
	
create table plan_oper
    ( collection_id	number(15)
	,	constraint  plan_oper_collect_id_pk   primary key (collection_id)
    , p_date		date
    , p_summa		number
	, type_oper		varchar2(40)
    ) ;
	
create table fact_oper
    ( collection_id	number(15)
	,	constraint  fact_oper_collect_id_pk   primary key (collection_id)
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
	,	constraint	pr_cred_collect_plan_fk   foreign key (collect_plan)
                                    references plan_oper (collection_id)
	, collect_fact	number(15)
	,	constraint	pr_cred_collect_fact_fk   foreign key (collect_fact)
                                    references fact_oper (collection_id)
    ) ;