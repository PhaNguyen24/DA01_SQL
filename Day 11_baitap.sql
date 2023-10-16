--BÀI 1
SELECT b.continent, FLOOR(AVG(a.population))
FROM city as a
JOIN country as b
ON b.code = a.countrycode
GROUP BY b.continent;

--BÀI 2
SELECT 
ROUND(CAST(SUM(CASE 
   WHEN t.signup_action='Confirmed' THEN 1 ELSE 0
END)AS DECIMAL)/COUNT(*),2) AS confirm_rate
FROM emails AS e
LEFT JOIN texts AS t ON e.email_id = t.email_id
WHERE signup_action IS NOT NULL;

--BÀI 3
SELECT b.age_bucket,
ROUND(100.0*SUM(CASE WHEN a.activity_type = 'send' THEN a.time_spent 
ELSE 0 END)/SUM(a.time_spent),2) as send_perc,
ROUND(100*SUM(CASE WHEN a.activity_type = 'open' THEN a.time_spent
ELSE 0 END)/SUM(a.time_spent),2) as open_per
FROM 
activities a JOIN age_breakdown b ON a.user_id=b.user_id
WHERE a.activity_type IN ('send','open')
GROUP BY b.age_bucket;

--BÀI 4
SELECT Customer_id
FROM customer_contracts as a
LEFT JOIN products as b ON a.product_id	=b.product_id	
GROUP BY customer_id
HAVING COUNT(DISTINCT product_category)=3;

--BÀI 5
SELECT e1.reports_to as employee_id, 
e2.name,
COUNT(e1.reports_to) as reports_count,
ROUND(AVG(e1.age),0) as average_age
 FROM
Employees AS e1
JOIN Employees  AS e2 ON e1.reports_to = e2.employee_id
GROUP BY e1.reports_to
ORDER BY employee_id;

--BÀI 6
SELECT p.product_name,
SUM(o.unit) AS unit    
FROM Products p
LEFT JOIN Orders o
ON p.product_id = o.product_id
WHERE EXTRACT(month from order_date) = '02'
AND EXTRACT(year from order_date) = '2020'
GROUP BY p.product_name
HAVING  SUM(unit)>=100;

--BÀI 7
SELECT p.page_id
FROM pages as p LEFT JOIN page_likes as l  ON p.page_id=l.page_id
GROUP BY p.page_id
HAVING COUNT(l.page_id) = 0
ORDER BY page_id; 
