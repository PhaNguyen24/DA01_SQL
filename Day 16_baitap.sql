--Bài 1
WITH cte AS
(SELECT * FROM
(SELECT *,
RANK() OVER(PARTITION BY customer_id ORDER BY order_date) as first_order
FROM Delivery) as new_table
WHERE first_order =1)
SELECT 
ROUND(SUM(100.0*CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 END)/COUNT(customer_id),2) as immediate_percentage
FROM cte;

--BÀI 2
--Solution 1 - Em xem giúp chị hàm này với nha, ko biết sao khi chạy thì Accepted nhưng khi Submit lại báo sai
SELECT 
ROUND(1.0*SUM(CASE WHEN diff = 1 THEN 1 ELSE 0 END)/COUNT(DISTINCT player_id),2) as fraction  
FROM(
SELECT *,
FIRST_VALUE(event_date) OVER(PARTITION BY player_id ORDER BY event_date ) as first_login,
event_date - FIRST_VALUE(event_date) OVER(PARTITION BY player_id ORDER BY event_date ) as diff
FROM Activity) as new_table;

--Solution 2
WITH cte AS 
(SELECT player_id, MIN(event_date) as first_login
FROM Activity
GROUP BY player_id)
  
SELECT ROUND(SUM(CASE WHEN DATEDIFF(event_date, first_login)=1 THEN 1 ELSE 0  END) / COUNT(DISTINCT cte.player_id), 2) as fraction
FROM Activity as a
JOIN cte 
ON a.player_id = cte.player_id;

--BÀI 3

SELECT 
(CASE
WHEN id%2 =0 THEN id-1 
WHEN id%2 <>0 AND id = (SELECT COUNT(distinct id) from Seat) THEN id 
ELSE id+1 END) as id,
student
FROM Seat
ORDER BY id

--BÀI 4
SELECT a.visited_on, sum(b.amount) amount, ROUND(SUM(b.amount)/7.0, 2) average_amount
FROM
(SELECT DISTINCT visited_on FROM customer
WHERE visited_on >= DATE_ADD((SELECT min(visited_on) FROM customer), INTERVAL 6 DAY)) a
LEFT JOIN
customer b
ON a.visited_on <= DATE_ADD(b.visited_on, INTERVAL 6 DAY) AND a.visited_on >= b.visited_on
  -- (Đoạn 'ON ....' này chị search solution trên google nhưng ko hiểu, hic)
GROUP BY a.visited_on

--BÀI 5
SELECT SUM(tiv_2016) as tiv_2016
FROM Insurance
WHERE 
tiv_2015 in (SELECT tiv_2015
FROM Insurance
GROUP BY tiv_2015
HAVING COUNT(*) >1)

AND 
(lat, lon) in (SELECT lat, lon
FROM Insurance
GROUP BY lat, lon
having count(*) = 1);

--BÀi 6

SELECT Department,Employee , Salary  
FROM (
SELECT b.name as Department, 
a.name  as Employee, 
a.salary as Salary,
DENSE_RANk() OVER(PARTITION BY a.departmentId ORDER BY Salary DESC ) as rank_deparment
FROM Employee a
LEFT JOIN Department b
ON a.departmentId= b.id) as X
WHERE rank_deparment <=3

--BÀI 7
SELECT person_name
FROM (
SELECT *,
SUM(weight) OVER(ORDER BY turn) as total_weight
FROM Queue ) as new_table
WHERE total_weight <= 1000
ORDER BY total_weight DESC
LIMIT 1

--BÀI 8
WITH t1 AS
(SELECT a.product_id,b.new_price
FROM
(SELECT product_id,max(change_date) as max_date  FROM Products 
WHERE change_date <='2019-08-16'
GROUP BY product_id) a
JOIN Products b
ON a.product_id = b.product_id
AND a.max_date = b.change_date),
t2 AS
(SELECT DISTINCT product_id FROM Products)

SELECT t2.product_id,coalesce(new_price,10) as price
FROM t2 LEFT JOIN t1
ON t2.product_id = t1.product_id;
