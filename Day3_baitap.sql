--BÀI TẬP 1
select name from city
where population > 120000
and countrycode ='USA';

---BÀI TẬP 2
select * from city
where countrycode = 'JPN';

--BÀI TẬP 3
select city,state from station;

--BÀI TẬP 4
SELECT DISTINCT city FROM station
WHERE city LIKE 'A%' OR city LIKE 'E%' OR city LIKE 'I%' OR city LIKE 'O%' OR city LIKE 'U%';

--BÀI TẬP 5
SELECT DISTINCT city FROM station
WHERE city LIKE '%a' OR city LIKE '%e' OR city LIKE '%i' OR city LIKE '%o' OR city LIKE '%u';

--BÀI TẬP 6
SELECT DISTINCT city FROM station
WHERE city NOT LIKE 'A%' AND city NOT LIKE 'E%' AND city NOT LIKE 'I%' AND city NOT LIKE 'O%' AND city NOT LIKE 'U%';

--BÀI TẬP 7
SELECT name FROM employee
ORDER BY name;

--BÀI TẬP 8
SELECT name FROM employee
where salary > 2000 and months < 10
ORDER BY employee_id;

-- BÀI TẬP 9
SELECT product_id FROM Products
WHERE low_fats = 'Y' and recyclable = 'Y';

--BÀI TẬP 10
SELECT name FROM Customer
WHERE referee_id <> 2 OR referee_id IS NULL;

--BÀI TẬP 11

SELECT name, population, area FROm world
WHERE area >=3000000 or population >=25000000;

--BÀI TẬP 12
SELECT DISTINCT author_id as id FROM views
WHERE author_id = viewer_id
ORDER BY author_id;

--BÀI TẬP 13
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date IS NULL;

--BÀI TẬP 14
SELECT * FROM lyft_drivers
WHERE yearly_salary <= 30000 OR yearly_salary >= 70000;

--BÀI TẬP 15
select advertising_channel from uber_advertising
WHERE money_spent >100000
and year = 2019;

