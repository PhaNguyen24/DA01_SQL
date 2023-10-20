--BÀI 1
SELECT 
EXTRACT(year FROM transaction_date) as year,
product_id,
spend as curr_year_spend,
LAG(spend) OVER(PARTITION BY product_id	ORDER BY EXTRACT(year FROM transaction_date)) as prev_year_spend,
ROUND((spend-LAG(spend) OVER(PARTITION BY product_id	ORDER BY EXTRACT(year FROM transaction_date)))
/LAG(spend) OVER(PARTITION BY product_id	ORDER BY EXTRACT(year FROM transaction_date))*100,2) as yoy_rate

FROM user_transactions
ORDER BY product_id;

--BÀI 2
SELECT DISTINCT card_name,
FIRST_VALUE(issued_amount) OVER(PARTITION BY card_name ORDER BY issue_year,issue_month) AS issued_amount
FROM monthly_cards_issued
ORDER BY issued_amount DESC

--BÀI 3
SELECT user_id, spend, transaction_date
FROM
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) as stt
FROM transactions) as new_table
WHERE stt = 3

-- BÀI 4

SELECT 
transaction_date,
user_id,
COUNT(*) as purchase_count
FROM
(SELECT *,
RANK() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) as rank
FROM user_transactions) as new_table
WHERE rank=1
GROUP BY transaction_date,
user_id
ORDER BY transaction_date;

--BÀI 5
WITH cte as 
(SELECT *,
ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY tweet_date) as row,
LAG(tweet_count) OVER (PARTITION BY user_id ORDER BY tweet_date) as d1,
LAG(tweet_count,2) OVER (PARTITION BY user_id ORDER BY tweet_date) as d2,
tweet_count + COALESCE(LAG(tweet_count) OVER (PARTITION BY user_id ORDER BY tweet_date),0)
+  COALESCE(LAG(tweet_count,2) OVER (PARTITION BY user_id ORDER BY tweet_date),0) as sum
FROM tweets) 
SELECT user_id,tweet_date,
CASE 
  WHEN row = 1 THEN ROUND(sum/1.0,2)
  WHEN row = 2 THEN ROUND(sum/2.0,2)
  ELSE ROUND(sum/3.0,2)
END as rolling_avg_3d
FROm cte

--BÀI 6
WITH cte as (
SELECT *,
ROW_NUMBER() OVER(PARTITION BY transaction_timestamp ORDER BY merchant_id,credit_card_id,amount) as row,
LEAD(transaction_timestamp) OVER(PARTITION BY merchant_id,credit_card_id, amount ORDER BY transaction_timestamp	) as next_transaction,
LEAD(transaction_timestamp) OVER(PARTITION BY merchant_id,credit_card_id, amount ORDER BY transaction_timestamp	)-transaction_timestamp as diff
FROM transactions
)
SELECT COUNT(*) payment_count
FROM cte 
WHERE (EXTRACT(hour from diff)*60 + EXTRACT(minute from diff)) <=10

--BÀI 7
WITH cte AS
(SELECT category,product,
SUM(spend)  as total_spend,
ROW_NUMBER()  OVER(PARTITION BY category ORDER BY SUM(spend) DESC) as rank

FROM product_spend
WHERE EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY category,product)

SELECT category,product,total_spend  FROM cte 
WHERE rank <=2
ORDER BY category, rank;

--BÀI 8
WITH cte as (SELECT c.artist_id,c.artist_name as artist_name,
COUNT(a.song_id) as count_song_id,
DENSE_RANK() OVER(ORDER BY count(a.song_id) DESC) as rank
FROM global_song_rank a
JOIN songs b ON a.song_id = b.song_id
JOIN artists c ON c.artist_id = b.artist_id
WHERE a.rank<=10
GROUP BY c.artist_id,c.artist_name )
SELECT artist_name,
rank as artist_rank
FROM cte 
WHERE rank <=5;
--
