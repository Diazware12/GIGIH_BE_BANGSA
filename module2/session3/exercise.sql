1) select 
	i.id, 
	i.name as item_name,
    i.price as item_price,
    c.name as category_name
from items as i 
join item_categories as ic on i.id = ic.item_id
join categories as c on ic.category_id = c.id;

2) select 
	i.id, 
	i.name as item_name,
    i.price as item_price
from items as i 
join item_categories as ic on i.id = ic.item_id
join categories as c on ic.category_id = c.id
where c.name = 'main dish';

3) select 
	i.id, 
	i.name as item_name,
    i.price as item_price
from items as i 
join item_categories as ic on i.id = ic.item_id
join categories as c on ic.category_id = c.id
where c.name = 'main dish' and i.price > 30000;

4) select 
	i.id, 
	i.name as item_name,
    i.price as item_price
from items as i 
join item_categories as ic on i.id = ic.item_id
where ic.category_id is null;

5) select 
	i.id, 
	group_concat(i.name separator ', ') as item_name,
    i.price as item_price,
    c.name as category_name
from items as i 
join item_categories as ic on i.id = ic.item_id
join categories as c on ic.category_id = c.id
group by c.id;