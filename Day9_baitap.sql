--BÀI 1
SELECT 
SUM(CASE
  WHEN device_type = 'laptop' THEN 1
  ELSE 0
END) AS laptop_views,

SUM(CASE
  WHEN device_type <> 'laptop' THEN 1
  ELSE 0
END) AS mobile_views
--hoặc dùng hàm này
/*SUM(CASE
  WHEN device_type = 'tablet' OR device_type = 'phone' THEN 1
  ELSE 0
END) AS mobile_view */

FROM viewership;

--BÀI  2
SELECT *,
CASE
  WHEN x+y>z AND x+z>y AND y+z>x THEN 'Yes'
  ELSE 'No'
END AS triangle
 FROM Triangle;

--BÀI 3-- KO BIẾT SAO MÀ CHẠY KO RA, hic
SELECT 
ROUND(CAST(SUM(CASE
  WHEN call_category is null OR call_category ='n/a' THEN 1
  ELSE 0
END)/COUNT(*)*100 AS DECIMAL),1) AS call_percentage
FROM callers;


--BÀI 4
--Solution #1
SELECT name FROM Customer
WHERE referee_id <> 2 OR referee_id IS NULL;

--Solution #2
SELECT
CASE
  WHEN referee_id is null or referee_id <>2 THEN name
END as name
FROM Customer
WHERE CASE
  WHEN referee_id is null or referee_id <>2 THEN name
END is not null;

--BÀI 5
select survived,
SUM(CASE WHEN pclass = 1 THEN 1 ELSE 0 END) AS first_class,

SUM(CASE WHEN pclass = 2 THEN 1 ELSE 0 END) AS second_class,

SUM(CASE WHEN pclass = 3 THEN 1 ELSE 0 END) AS third_class

FROM titanic
GROUP BY survived;
