III. Tạo metric trước khi dựng dashboard

  WITH cte AS 
(
SELECT * FROM (SELECT 
FORMAT_DATE('%Y-%m', DATE (a.created_at)) as month_year,
EXTRACT(year from a.created_at) as year,
b.category,
SUM(a.sale_price) OVER (PARTITION BY b.category ORDER BY FORMAT_DATE('%Y-%m', DATE (a.created_at))) as tpv,
COUNT(order_id) OVER (PARTITION BY b.category ORDER BY FORMAT_DATE('%Y-%m', DATE (a.created_at))) as tpo,
FORMAT_DATE('%Y-%m', DATE_ADD(DATE (a.created_at), interval 1 month)) as next_month,
SUM(b.cost) OVER (PARTITION BY b.category ORDER BY FORMAT_DATE('%Y-%m', DATE (a.created_at))) as total_cost

FROM bigquery-public-data.thelook_ecommerce.order_items a
LEFT JOIN bigquery-public-data.thelook_ecommerce.products b
ON a.product_id = b.id
WHERE a.status ='Complete')
GROUP BY 1,2,3,4,5,6,7
)
SELECT c.month_year, c.year, c.category, c.tpv, c.tpo, c.next_month,
COALESCE (d.tpv,0) as next_month_tpv,
COALESCE (d.tpo,0) as next_month_tpo,
ROUND(100.0*CAST((COALESCE (d.tpv,0) - c.tpv)/c.tpv as decimal),2)||'%' as Revenue_growth,
ROUND(100.0*CAST((COALESCE (d.tpo,0) - c.tpo)/c.tpo as decimal),2)||'%' as Order_growth,
c.total_cost,
c.tpv - c.total_cost    as total_profit,
ROUND((c.tpv - c.total_cost)/c.total_cost,2)   as Profit_to_cost_ratio,

 FROM cte c
 LEFT JOIN cte d
  ON c.next_month = d.month_year
  AND c.category = d.category


--COHORT ANALYSIS

WITH cte AS 
 (
 SELECT user_id,sale_price,
  FORMAT_DATE('%Y-%m', DATE (first_puchase_date)) as cohort_date,
  created_at,
  (extract(year from created_at)-extract(year from first_puchase_date))*12 
  + (extract(month from created_at)-extract(month from first_puchase_date))+ 1 as index
 FROM 
 (
 SELECT user_id,sale_price,
  MIN(created_at) OVER (PARTITION BY user_id) as first_puchase_date,
 created_at
 FROM bigquery-public-data.thelook_ecommerce.order_items
 WHERE status ='Complete'
)
 )

 ,cte2 as (
 SELECT cohort_date, index,
  COUNT(DISTINCT user_id) as cnt,
  SUM (sale_price) as revenue
 FROM cte
 WHERE index <=4
 GROUp BY 1,2
 ORDER BY cohort_date)

,customer_cohort AS (
 SELECT cohort_date,
 SUM(case when index = 1 then cnt else 0 end) as t1,
 SUM(case when index = 2 then cnt else 0 end) as t2,
 SUM(case when index = 3 then cnt else 0 end) as t3,
 SUM(case when index = 4 then cnt else 0 end) as t4
 FROM cte2
 GROUP BY cohort_date
 ORDER BY cohort_date
)

--retention cohort
, retention_cohort AS (
SELECT cohort_date,
ROUND(100.00* t1/t1,2)||'%' t1,
ROUND(100.00* t2/t1,2)||'%' t2,
ROUND(100.00* t3/t1,2)||'%' t3,
ROUND(100.00* t4/t1,2)||'%' t4
FROM customer_cohort)

--churn cohort
SELECT cohort_date,
(100-ROUND(100.00* t1/t1,2))||'%' t1,
(100 - ROUND(100.00* t2/t1,2))||'%' t2,
(100-ROUND(100.00* t3/t1,2))||'%' t3,
(100-ROUND(100.00* t4/t1,2))||'%' t4
FROM customer_cohort
