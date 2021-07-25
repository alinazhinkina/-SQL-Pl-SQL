--создаем синонимы к таблице goods схемы username
create synonym user_goods for username.goods;
select * from user_goods

--публичный синоним, доступ будет и у других пользователей
create public synonym user_goods_public for username.goods;

--команда для загрузки данных из файла с помощью SQL*Loader
--sqlldr username/111 control=D:\Database\Oracle\scripts\insert_employees.ctl data=D:\Database\Oracle\scripts\insert_employees.csv
