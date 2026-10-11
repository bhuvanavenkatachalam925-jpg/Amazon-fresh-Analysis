CREATE DATABASE Amazon;
USE Amazon;

-- basic check
select * from customers;
select * from products;
select * from orders;
select * from order_details;
select * from suppliers;
select * from reviews;

-- task 2: keys
show keys from customers where key_name='PRIMARY';
show keys from products where key_name='PRIMARY';
show keys from orders where key_name='PRIMARY';
show keys from suppliers where key_name='PRIMARY';
show keys from reviews where key_name='PRIMARY';

-- task 3
select * from customers where city="Meganfort";
select * from products where category="Fruits";

-- task 4
alter table customers modify age int not null;
alter table customers add constraint chk_age check (age>18);
alter table customers add constraint unique_name unique(name);

-- task 5
SET SQL_SAFE_UPDATES = 0;
UPDATE customers
SET age = 19
WHERE age < 18;
SET SQL_SAFE_UPDATES = 1;

-- task 6
SET SQL_SAFE_UPDATES = 0;
UPDATE products
SET StockQuantity = 500
WHERE ProductID = 'p1001';

-- task 7
delete from suppliers where city="South Tyler";

-- task 8
ALTER TABLE reviews
DROP CHECK chk_rating;

ALTER TABLE reviews
ADD CONSTRAINT chk_rating
CHECK (rating BETWEEN 1 AND 5);

-- task 9
select * from orders where orderdate > '2024-01-01';

select productid, avg(rating) from reviews
group by productid
having avg(rating)>4;

select productid, sum(quantity) from order_details
group by productid
order by sum(quantity) desc;

-- task 10
select customerid, sum(orderamount) as total
from orders
group by customerid
order by total desc;

select customerid, sum(orderamount) as total
from orders
group by customerid
having total>5000;

-- task 11
select o.orderid, sum(od.quantity*od.unitprice) as revenue
from orders o
join order_details od on o.orderid=od.orderid
group by o.orderid;

select c.customerid, c.name, count(o.orderid) as totalorders
from customers c
join orders o on c.customerid=o.customerid
where o.orderdate between '2024-01-01' and '2025-12-31'
group by c.customerid, c.name
order by totalorders desc
limit 5;

select supplierid, sum(stockquantity) as totalstock
from products
group by supplierid
order by totalstock desc
limit 1;

-- task 12
CREATE TABLE IF NOT EXISTS categories (
    categoryid INT AUTO_INCREMENT PRIMARY KEY,
    categoryname VARCHAR(50)
);

INSERT INTO categories (categoryname)
SELECT DISTINCT category
FROM products;

UPDATE products p
JOIN categories c ON p.category = c.categoryname
SET p.categoryid = c.categoryid;

SET SQL_SAFE_UPDATES = 1;

-- task 13
select productid, totalrevenue from (
  select productid, sum(quantity*unitprice) as totalrevenue
  from order_details
  group by productid
) as sales
order by totalrevenue desc
limit 3;

select customerid, name from customers
where customerid not in (select customerid from orders);

-- task 14
select city, count(*) as primemembers
from customers
where primemember="yes"
group by city
order by primemembers desc
limit 5;

select p.category, count(od.productid) as totalorders
from products p
join order_details od on p.productid=od.productid
group by p.category
order by totalorders desc
limit 3;