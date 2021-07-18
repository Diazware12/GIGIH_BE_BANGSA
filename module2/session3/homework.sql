-- create
    -- customer
    CREATE TABLE customers (
        id int AUTO_INCREMENT PRIMARY KEY not null,
        customer_name varchar(255) NOT NULL,
        customer_phone varchar(255) NOT NULL unique, 
        constraint chk_phone CHECK (SUBSTRING(customer_phone, 1, 3) = '+62' and CHAR_LENGTH(customer_phone) = 11)
    );

    -- transactions
    CREATE TABLE transactions (
        id int AUTO_INCREMENT PRIMARY KEY not null,
        customer_id int not null,
        item_id int not null,
        index (customer_id),
        index (item_id),
        foreign key (customer_id) REFERENCES customers(id) on update cascade,
        foreign key (item_id) REFERENCES items(id) on update cascade,
        transaction_date date not null
    );

-- insert
    insert into customers (customer_name,customer_phone)values
    ('Diaz Ganteng', '+6218273645'),
    ('Diaz Ganteng', '+6218795445'),
    ('Diaz Keren', '+6297545445'),
    ('Diaz Gans Pars', '+6297544445'),
    ('Diaz Cool', '+6282554445');

    insert into transactions (customer_id,item_id,transaction_date)values
    (1, 1, curdate()),
    (1, 2, curdate()),
    (1, 3, curdate()),
    (1, 4, curdate()),
    (2, 7, curdate()),
    (2, 8, curdate()),
    (2, 9, curdate()),
    (2, 10, curdate()),
    (2, 11, curdate()),
    (3, 7, curdate()),
    (3, 6, curdate()),
    (3, 2, curdate()),
    (3, 1, curdate()),
    (3, 5, curdate()),
    (4, 6, curdate()),
    (4, 7, curdate()),
    (4, 2, curdate()),
    (5, 3, curdate()),
    (5, 1, curdate()),
    (5, 4, curdate());



-- select data
SELECT 0 INTO @x;
select 
	(@x:=@x+1) as order_id,
    t.transaction_date as order_date,
	c.customer_name,
    c.customer_phone,
    sum(i.price) as total,
    group_concat(i.name separator ', ') as item_name
from customers as c
join transactions as t on c.id = t.customer_id
join items as i on i.id = t.item_id
group by c.id

