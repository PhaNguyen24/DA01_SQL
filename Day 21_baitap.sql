--II
--1. Thống kê tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng ( Từ 1/2019-4/2022)
SELECT 
FORMAT_DATE('%Y-%m', DATE (created_at)) as month_year,
COUNT(distinct user_id) as  total_user, COUNT(order_id) as total_order
FROM bigquery-public-data.thelook_ecommerce.orders
WHERE FORMAT_DATE('%Y-%m', DATE (created_at)) BETWEEN '2019-01' AND '2022-04'
AND status ='Complete'
GROUP BY 1
ORDER BY month_year

--2. Thống kê giá trị đơn hàng trung bình và tổng số người dùng khác nhau mỗi tháng ( Từ 1/2019-4/2022)
SELECT 
FORMAT_DATE('%Y-%m', DATE (created_at)) as month_year,
COUNT(distinct user_id) as distinct_users, 
ROUND(AVG(sale_price),2) as average_order_value
FROM bigquery-public-data.thelook_ecommerce.order_items
WHERE FORMAT_DATE('%Y-%m', DATE (created_at)) BETWEEN '2019-01' AND '2022-04'
GROUP BY 1
ORDER BY month_year

--3. Tìm các khách hàng có trẻ tuổi nhất và lớn tuổi nhất theo từng giới tính ( Từ 1/2019-4/2022)
CREATE TEMP TABLE temp_youngest_oldesr_customer AS (
SELECT first_name, last_name, gender, 
(SELECT MIN(age) FROM bigquery-public-data.thelook_ecommerce.users) as age,'youngest' as tag
FROM bigquery-public-data.thelook_ecommerce.users
GROUP BY first_name, last_name, gender

UNION ALL

SELECT first_name, last_name, gender,
(SELECT MAX(age) FROM bigquery-public-data.thelook_ecommerce.users) as age, 'oldest' as tag
FROM bigquery-public-data.thelook_ecommerce.users
GROUP BY first_name, last_name, gender
ORDER BY age);

SELECT gender,age,COUNT(*)
 FROM cte
 GROUP BY gender, age

--BÀI 4
--Thống kê top 5 sản phẩm có lợi nhuận cao nhất từng tháng (xếp hạng cho từng sản phẩm). 
SELECT * FROM
(SELECT 
FORMAT_DATE('%Y-%m', DATE (a.created_at)) as month_year,
a.product_id,
b.name as product_name,
a.sale_price as sales,
b.cost,
a.sale_price-b.cost as profit,
DENSE_RANK() OVER(PARTITION BY FORMAT_DATE('%Y-%m', DATE (a.created_at)) ORDER BY a.sale_price-b.cost DESC ) as rank_per_month

FROM bigquery-public-data.thelook_ecommerce.order_items a
LEFT JOIN bigquery-public-data.thelook_ecommerce.products b
ON a.product_id = b.id
)
WHERE rank_per_month <6
ORDER BY month_year

--BÀI 5
--Thống kê tổng doanh thu theo ngày của từng danh mục sản phẩm (category) trong 3 tháng qua ( giả sử ngày hiện tại là 15/4/2022)

SELECT *
 FROM (
SELECT 
DATE(a.created_at) as dates ,
b.category as product_categories,
SUM(a.sale_price) OVER (PARTITION BY b.category ORDER BY DATE(a.created_at)) as revenue

FROM bigquery-public-data.thelook_ecommerce.order_items a
LEFT JOIN bigquery-public-data.thelook_ecommerce.products b
ON a.product_id = b.id
)
WHERE DATE_DIFF(DATE '2022-04-15',dates, DAY) BETWEEN 0 AND 90
--WHERE dates BETWEEN DATE_ADD(DATE '2022-04-15', INTERVAL -3 MONTH) AND '2022-04-15'
GROUP BY dates,product_categories, revenue
ORDER BY dates
