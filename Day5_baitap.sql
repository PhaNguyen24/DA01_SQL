--BÀI 1
SELECT DISTINCT city from station
WHERE MOD(ID,2) = 0;

--BÀI 2
SELECT count(*)-count(DISTINCT(city)) from station;

--BÀI 3 --- HÀM CHƯA HỌC
--SELECT CEILING(AVG(salary) - AVG(REPLACE(salary,0,''))) FROM employees;

--BÀI 4 -- KHÔNG BIẾT BỊ LỖI Ở ĐÂU NHƯNG KHI CHÈN ROUND VÀO THÌ KO CHẠY RA, HIC
SELECT ROUND(CAST(SUM(item_count * order_occurrences)/sum(order_occurrences) AS DECIMAL),1) AS mean
FROM items_per_order;

--BÀI 5
SELECT candidate_id FROM candidates
WHERE skill in ('Python','Tableau','PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill)=3
ORDER BY candidate_id;

--BÀI 6
SELECT user_id,
MAX(DATE(post_date))-MIN(DATE(post_date)) AS days_between
FROM posts
WHERE post_date BETWEEN '2021-01-01' AND '2022-01-01'
GROUP BY user_id
HAVING COUNT(post_id)>=2 

--BÀI 7
SELECT card_name,
MAX(issued_amount)-MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC;

--BÀI 8
SELECT manufacturer,
COUNT(drug) AS drug_count,
ABS(SUM(total_sales - cogs)) AS total_loss
FROM pharmacy_sales
WHERE total_sales < cogs
GROUP BY manufacturer
ORDER BY total_loss DESC;

-BÀI 9
SELECT * FROM cinema
WHERE id%2 <>0 and description NOT LIKE '%boring%'
ORDER BY rating DESC;

--BÀI 10
SELECT teacher_id,
COUNT(DISTINCT subject_id) AS cnt
FROM teacher
GROUP BY teacher_id;

--BÀI 11
SELECT user_id,
COUNT(follower_id) AS followers_count
FROM followers
GROUP BY user_id
ORDER BY user_id;

--BÀI 12
SELECT class FROM courses
GROUP BY class
HAVING COUNT(student)>=5;
