--BÀI 4
SELECT page_id
FROM pages
WHERE page_id NOT iN (SELECT page_id FROM page_likes)
ORDER BY page_id ;

--BÀI 5
--Solution 1
WITH month_6 AS
(SELECT user_id FROM user_actions
WHERE event_type in ('sign-in', 'like','comment')
AND EXTRACT(month FROM event_date) =6
AND EXTRACT(year FROM event_date)=2022),
month_7 AS
(SELECT user_id FROM user_actions
WHERE event_type in ('sign-in', 'like','comment')
AND EXTRACT(month FROM event_date) =7
AND EXTRACT(year FROM event_date)=2022)

SELECT 7 as mth,
COUNT(DISTINCT a.user_id) as monthly_active_users
FROM month_6 a
JOIN month_7 b ON a. user_id=b.user_id

--Solution 2
WITH cte AS
(SELECT user_id
FROM user_actions
WHERE EXTRACT(month from event_date) in (6,7) 
AND EXTRACT(year from event_date) = 2022
GROUP BY user_id
HAVING COUNT(DISTINCT EXTRACT(month from event_date)) = 2)

SELECT 7 mth,
count (*) as monthly_active_users 
FROM cte;

--BÀI 6
SELECT
DATE_FORMAT(trans_date, '%Y-%m') as month,
country,
COUNT(*) as trans_count,
SUM(case when state ='approved' THEN 1 ELSE 0 END) as approved_count,
SUM(amount) as trans_total_amount,
SUM(case when state ='approved' THEN amount ELSE 0 END) as approved_total_amount
FROM Transactions 
GROUP BY DATE_FORMAT(trans_date, '%Y-%m'),country

--BÀI 7
SELECT 
a.product_id,
a.year as first_year,
a.quantity,
a.price 
FROM Sales a
JOIN
(SELECT product_id,
 min(year) as year
  FROM Sales
  GROUP BY product_id) b
  ON b.product_id = a.product_id
  AND b.year = a.year

--BÀI 8
SELECT customer_id
FROM Customer
 GROUP BY customer_id
HAVING COUNT(DISTINCT product_key)=(SELECT COUNT(*) FROM Product);

--BÀI 9
SELECT employee_id
FROM Employees 
WHERE salary <30000
AND manager_id NOT IN (SELECT employee_id FROM Employees)
order by employee_id;

--BÀI 10
SELECT COUNT(*) as duplicate_companies
FROM
(SELECT company_id,title,description,
COUNT(job_id) as job_count
FROM job_listings
GROUP BY company_id,title,description) as new_table
WHERE job_count >=2;




