OPTIONS (SKIP=1)
LOAD DATA
CHARACTERSET UTF8
INFILE 'insert_employees.csv'
BADFILE 'insert_employees.bad'
DISCARDFILE 'insert_employees.dsc'
TRUNCATE
INTO TABLE USERNAME.EMPLOYEES
FIELDS TERMINATED BY ';'
OPTIONALLY ENCLOSED BY '"'
TRAILING NULLCOLS
( 
  employee_id,
  first_name,
  last_name,
  email,
  phone_number,
  hire_date DATE "dd.mm.yyyy",
  manager_id,
  salary,
  department_id
)