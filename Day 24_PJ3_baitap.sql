--- 1. Doanh thu theo từng ProductLine, Year  và DealSize
SELECT * FROM (
SELECT 
productline, year_id, dealsize,
SUM(sales) OVER(PARTITION BY productline, year_id, dealsize ORDER BY year_id) as revenue
FROM public.sales_dataset_rfm_prj_clean ) as a
GROUP BY 1,2,3,4
ORDER BY productline, year_id, dealsize

---2. Tháng bán tốt nhất mỗi năm
SELECT month_id, SUM(sales) as revenue, COUNT(ordernumber) as order_number
FROM public.sales_dataset_rfm_prj_clean
GROUP BY month_id
ORDER BY SUM(sales) DESC

--3. Product line nào được bán nhiều ở tháng 11

SELECT month_id, productline, SUM(sales) as revenue, COUNT(ordernumber) as order_number
FROM public.sales_dataset_rfm_prj_clean
WHERE month_id = 11
GROUP BY month_id, productline
ORDER BY revenue DESC

--4. Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? 
--Xếp hạng các các doanh thu đó theo từng năm.
  
SELECT year_id, productline, SUM(sales) as revenue,
RANK() OVER(PARTITION BY year_id ORDER BY SUM(sales) DESC) as ranking
FROM public.sales_dataset_rfm_prj_clean
WHERE country = 'UK'
GROUP BY year_id, productline

--5. Ai là khách hàng tốt nhất, phân tích dựa vào RFM 
WITH cte as (
SELECT customername,
current_date-MAX(new_orderdate) as R,
COUNT(DISTINCT ordernumber) as F,
SUM(sales) as M
FROM public.sales_dataset_rfm_prj_clean
GROUP BY customername )

,cte2 as (
SELECT customername,
ntile(5) OVER(ORDER BY R DESC) as r_score,
ntile(5) OVER(ORDER BY F ) as f_score,
ntile(5) OVER(ORDER BY M) as m_score
FROM cte)

,rfm_final as (
SELECT customername,
cast(r_score as varchar)||cast(f_score as varchar)||cast(m_score as varchar) as rfm_score
FROM cte2)

SELECT segment,COUNT(*) FROM
(SELECT a. customername,
b.segment
FROM rfm_final a
JOIN public.segment_score b
ON a.rfm_score = b.scores) c
GROUP BY segment
ORDER BY COUNT(*)





