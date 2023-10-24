--CÂU 1
ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE integer USING ordernumber::integer;

ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN quantityordered TYPE integer USING quantityordered::integer;

ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN priceeach TYPE numeric USING priceeach::numeric;

ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN orderlinenumber TYPE integer USING orderlinenumber::integer;

ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN sales TYPE numeric USING sales::numeric;


ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN orderdate TIMESTAMP USING orderdate::TIMESTAMP;
--đoạn này ko chạy được, nhưng ko biết cách sửa, huhu

ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN msrp TYPE numeric USING msrp::numeric;

--CÂU 2
SELECT ordernumber,quantityordered,priceeach,orderlinenumber, sales, orderdate
FROM sales_dataset_rfm_prj
WHERE ordernumber IS NULL
OR quantityordered is null
OR priceeach is null
OR orderlinenumber is null
OR sales is null
OR orderdate is null

--CÂU 3
  --Thêm cột
ALTER TABLE sales_dataset_rfm_prj
ADD column contactfirstname VARCHAR(50)

ALTER TABLE sales_dataset_rfm_prj
ADD column contactlastname VARCHAR(50)

--Update data vào cột
UPDATE sales_dataset_rfm_prj
SET contactfirstname = UPPER(LEFT(contactfullname,1))||
LOWER(SUBSTRING(contactfullname,2,POSITION('-' IN contactfullname)-2))

UPDATE sales_dataset_rfm_prj
SET contactlastname = UPPER(SUBSTRING(contactfullname,POSITION('-' IN contactfullname)+1,1))||
LOWER(SUBSTRING(contactfullname,POSITION('-' IN contactfullname)+2,LENGTH(contactfullname)))

--CÂU 4
ALTER TABLE sales_dataset_rfm_prj
ADD column QTR_ID numeric(10)

ALTER TABLE sales_dataset_rfm_prj
ADD column MONTH_ID numeric(10)

ALTER TABLE sales_dataset_rfm_prj
ADD column YEAR_ID numeric(10)  


--Do orderdate ở Câu 1 chưa biết cách chuyển từ varchar về date nên chèn thêm 1 cột new_orderdate, rồi lấy dữ liệu quý, tháng, năm từ cột mới này
ALTER TABLE sales_dataset_rfm_prj
ADD column new_orderdate timestamp;
  
UPDATE sales_dataset_rfm_prj
SET new_orderdate = to_date(orderdate,'MM/DD/YYYY HH24:MI:SS');

--update dữ liệu vào  cột QTR_ID, MONTH_ID, YEAR_ID từ cột new_orderdate

UPDATE sales_dataset_rfm_prj
SET qtr_id = EXTRACT(quarter from new_orderdate) ;

UPDATE sales_dataset_rfm_prj
SET MONTH_ID = EXTRACT(month from new_orderdate) ;

UPDATE sales_dataset_rfm_prj
SET YEAR_ID = EXTRACT(YEAR from new_orderdate) ;


--CÂU 6
P1: TÌM OUTLIER
--CÁCH 1 - sử dụng boxplot
WITH cte AS (
SELECT Q1-1.5*IQR as min_value, Q3+1.5*IQR as max_value
FROM (
	SELECT 
percentile_cont(0.25) WITHIN GROUP (ORDER BY quantityordered) as Q1,
percentile_cont(0.75) WITHIN GROUP (ORDER BY quantityordered) as Q3,
percentile_cont(0.75) WITHIN GROUP (ORDER BY quantityordered)-
percentile_cont(0.25) WITHIN GROUP (ORDER BY quantityordered) as IQR
FROM sales_dataset_rfm_prj 
	) as a )
SELECT * FROM sales_dataset_rfm_prj 
WHERE quantityordered < (SELECT min_value FROM cte )
OR quantityordered > (SELECT max_value FROM cte )

--CÁCH 2 - sử dụng Z-score
WITH cte AS(
SELECT orderdate,
quantityordered,
(SELECT AVG(quantityordered)
FROM sales_dataset_rfm_prj) as avg,
(SELECT stddev(quantityordered)
FROM sales_dataset_rfm_prj ) as stddev
FROM sales_dataset_rfm_prj )

SELECT orderdate, quantityordered, (quantityordered-avg)/stddev as z_score
from cte
where abs((quantityordered-avg)/stddev) >3

P2: XỬ LÝ OUTLIER
-- XÓA
  --với lệnh DELETE ko nên chạy trước khi bài được review--> xóa sau vậy


--THAY THẾ BẰNG GIÁ TRỊ TRUNG BÌNH
WITH cte AS(
SELECT orderdate,
quantityordered,
(SELECT AVG(quantityordered)
FROM sales_dataset_rfm_prj) as avg,
(SELECT stddev(quantityordered)
FROM sales_dataset_rfm_prj ) as stddev
FROM sales_dataset_rfm_prj ),

cte_outliner as (
SELECT orderdate, quantityordered, (quantityordered-avg)/stddev as z_score
from cte
where abs((quantityordered-avg)/stddev) >3)

UPDATE sales_dataset_rfm_prj
SET quantityordered = (SELECT AVG(quantityordered) FROM sales_dataset_rfm_prj)
WHERE quantityordered IN (SELECT quantityordered FROM cte_outliner)


--CÂU 7
CREATE TABLE SALES_DATASET_RFM_PRJ_CLEAN AS 
SELECT * FROM sales_dataset_rfm_prj










