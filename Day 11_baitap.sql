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
SELECT *
--Customer_id,
FROM customer_contracts as a
JOIN products as b ON a.product_id	=b.product_id	
WHERE product_category in (Analytics,Containers,Compute)
--GROUP BY customer_id	;
