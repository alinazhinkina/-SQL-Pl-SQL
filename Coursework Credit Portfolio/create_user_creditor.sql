alter session set "_ORACLE_SCRIPT"=true;
create user creditor IDENTIFIED by 111;

grant create session to creditor;
grant create table to creditor;
grant create procedure to creditor;
grant create trigger to creditor;
grant create view to creditor;
grant create sequence to creditor;
grant alter any table to creditor;
grant alter any procedure to creditor;
grant alter any trigger to creditor;
grant alter profile to creditor;
grant delete any table to creditor;
grant drop any table to creditor;
grant drop any procedure to creditor;
grant drop any trigger to creditor;
grant drop any view to creditor;
grant drop profile to creditor;

grant select on sys.v_$session to creditor;
grant select on sys.v_$sesstat to creditor;
grant select on sys.v_$statname to creditor;
grant SELECT ANY DICTIONARY to creditor;

--предоставили неограниченную квоту на табличное пространство users
alter user creditor quota unlimited on users;