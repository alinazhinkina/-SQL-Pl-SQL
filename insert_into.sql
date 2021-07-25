--заполнять таблицы буду на русском языке, чтобы посмотреть, возникнут ли в дальнейшем проблемы
insert into goods_type
values (SEQ_GOOD_TYPE_ID.nextval, 'овощи');
insert into goods_type
values (SEQ_GOOD_TYPE_ID.nextval, 'фрукты');

insert into goods values (SEQ_GOODS_ID.nextval, 'огурец', 4, 20);
insert into goods values (SEQ_GOODS_ID.nextval, 'помидор', 4, 30);
insert into goods values (SEQ_GOODS_ID.nextval, 'кабачок', 4, 40);
insert into goods values (SEQ_GOODS_ID.nextval, 'яблоко', 5, 20);
insert into goods values (SEQ_GOODS_ID.nextval, 'апельсин', 5, 30);
insert into goods values (SEQ_GOODS_ID.nextval, 'груша', 5, 40);
insert into goods values (SEQ_GOODS_ID.nextval, 'банан', 5, 50);


insert into goods_delivery (delivery_id, goods_id, quantity, employee_id)
values (SEQ_GOODS_DELIV_ID.nextval, 30, 100, 3);
insert into goods_delivery (delivery_id, goods_id, quantity, employee_id)
values (SEQ_GOODS_DELIV_ID.nextval, 31, 80, 3);
insert into goods_delivery (delivery_id, goods_id, quantity, employee_id)
values (SEQ_GOODS_DELIV_ID.nextval, 32, 95, 3);
insert into goods_delivery (delivery_id, goods_id, quantity, employee_id)
values (SEQ_GOODS_DELIV_ID.nextval, 33, 65, 3);
insert into goods_delivery (delivery_id, goods_id, quantity, employee_id)
values (SEQ_GOODS_DELIV_ID.nextval, 34, 70, 3);
insert into goods_delivery (delivery_id, goods_id, quantity, employee_id)
values (SEQ_GOODS_DELIV_ID.nextval, 35, 100, 3);
insert into goods_delivery (delivery_id, goods_id, quantity, employee_id)
values (SEQ_GOODS_DELIV_ID.nextval, 36, 110, 3);

