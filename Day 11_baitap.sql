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

