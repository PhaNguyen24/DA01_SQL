--BÀI 1
SELECT name
FROM students
WHERE marks >75
ORDER BY right(name,3),id;

--BÀI 2
SELECT user_id,
CONCAT(UPPER(LEFT(name,1)),
LOWER(SUBSTRING(name FROM 2 FOR LENGTH(name)))) as name
FROM users
ORDER BY user_id;

--BÀI 3
SELECT manufacturer,
'$'||ROUND(SUM(total_sales)/1000000,0)||' million' AS sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC, manufacturer ASC;

--BÀI 4
SELECT 
EXTRACT(month FROM submit_date) AS mth,
product_id,
ROUND(AVG(stars),2) AS avg_stars
FROM reviews
GROUP BY EXTRACT(month FROM submit_date),product_id
ORDER BY mth,product_id;

--BÀI 5
SELECT sender_id,
COUNT (message_id) AS message_count
FROM messages
WHERE EXTRACT(MONTH FROM sent_date) = 8 AND EXTRACT (YEAR FROM sent_date)=2022
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2;

--BÀI 6
SELECT tweet_id FROM Tweets
WHERE LENGTH(content)>15;

--BÀI 7
SELECT 
activity_date AS day,
COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27'
 GROUP BY activity_date;

--BÀI 8
select COUNT(id) AS count_id
from employees
WHERE EXTRACT(month FROM joining_date) BETWEEN 1 AND 7
AND EXTRACT(year FROM joining_date)=2022;

--BÀI 9
select 
POSITION ('a' IN first_name)
from worker
WHERE first_name = 'Amitah';

--BÀI 10
select 
title,
SUBSTRING(title FROM POSITION(' 'IN title)+1 FOR 4)
from winemag_p2
WHERE country = 'Macedonia';

