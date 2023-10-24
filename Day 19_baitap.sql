--Câu 1
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

--ALTER TABLE public.sales_dataset_rfm_prj
--ALTER COLUMN orderdate TIMESTAMP USING 'dd/mm/yyyy hh:mm'::TIMESTAMP;

ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN msrp TYPE numeric USING msrp::numeric;

--Câu 2
SELECT ordernumber,quantityordered,priceeach,orderlinenumber, sales, orderdate
FROM sales_dataset_rfm_prj
WHERE ordernumber IS NULL
OR quantityordered is null
OR priceeach is null
OR orderlinenumber is null
OR sales is null
OR orderdate is null

--Câu 3
ALTER TABLE sales_dataset_rfm_prj
ADD column contactfirstname VARCHAR(50)

ALTER TABLE sales_dataset_rfm_prj
ADD column contactlastname VARCHAR(50)


