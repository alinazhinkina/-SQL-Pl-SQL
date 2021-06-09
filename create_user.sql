alter session set "_ORACLE_SCRIPT"=true;

create user username IDENTIFIED by 111;

grant create session to username;
grant create table to username;
grant create procedure to username;
grant create trigger to username;
grant create view to username;
grant create sequence to username;
grant alter any table to username;
grant alter any procedure to username;
grant alter any trigger to username;
grant alter profile to username;
grant delete any table to username;
grant drop any table to username;
grant drop any procedure to username;
grant drop any trigger to username;
grant drop any view to username;
grant drop profile to username;

grant select on sys.v_$session to username;
grant select on sys.v_$sesstat to username;
grant select on sys.v_$statname to username;
grant SELECT ANY DICTIONARY to username;