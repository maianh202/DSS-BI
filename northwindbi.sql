
  select location_id, product_id,  sum(quantity) from fact_sales group by location_id, product_id

select * from fact_sales where product_id = 54 and location_id = 9

select * from fact_sales where product_id = 55

select distinct date_id, location_id, customer_id, product_id, unit_price, revenue, quantity, discount  from fact_sales 
---------------------------------------------------------
select     count( distinct day  ), dim_date.year, customer_id,  month from fact_sales join dim_date on fact_sales.date_id=dim_date.date_key  group by  year, month, customer_id

select    dim_customer.customer_id, count( distinct day  ), dim_date.year, dim_customer.customer_key,  month from  dim_date join fact_sales on fact_sales.date_id=dim_date.date_key
join dim_customer on fact_sales.customer_id=dim_customer.customer_key   group by  year, month, dim_customer.customer_key 

select year, month,coalesce( count(*), 0) as count_holiday from dim_date where is_holiday = '1'
group by year, month





select  c.customer_id,c.customer_key, month,a.year, count( distinct date  )
from  dim_date a  join fact_sales b on b.date_id=a.date_key
right outer join dim_customer c on b.customer_id=c.customer_key     group by  year, month, c.customer_id,c.customer_key 


select b.customer_id, c.customer_key, month, year
from  fact_sales b 
right outer join dim_customer c on b.customer_id=c.customer_key where  month = 7 and year = 1996 and customer_key not in
( select  customer_id from fact_sales join dim_date on dim_date.date_key = fact_sales.date_id where month = 7 and year = 1996)

ALTER TABLE fact_sales
  ADD CONSTRAINT customer_id FOREIGN KEY (customer_id) REFERENCES dim_customer (customer_key);
ALTER TABLE fact_sales
  ADD CONSTRAINT date_id FOREIGN KEY (date_id) REFERENCES dim_date (date_key);
ALTER TABLE fact_sales
  ADD CONSTRAINT product_id FOREIGN KEY (product_id) REFERENCES dim_products (product_key);

-- lấy ra Kh k có đơn
select *
from  dim_customer where customer_key not in
( select  customer_id from fact_sales join dim_date on dim_date.date_key = fact_sales.date_id where month = 7 and year = 1996)

COPY students to 'C:\Export\student_data_full.csv' DELIMITER ',' CSV HEADER;

--




---------------------------------------------------------------
select distinct date_id  from fact_sales where customer_id = 9 group by  date_id

select date_id, count(distinct date_id) , customer_id from fact_sales where date_id=19960720 group by date_id, customer_id 


------------------------------------------------------------------------------------------------------------

WITH AllMonths AS (
    SELECT DISTINCT
        YEAR(date) AS year,
        MONTH(date) AS month
    FROM
        dim_date
)
SELECT
    m.year,
    m.month,
    COALESCE(COUNT(d.date), 0) AS holiday_count
FROM
    AllMonths m
LEFT JOIN
    dim_date d ON m.year = YEAR(d.date) AND m.month = MONTH(d.date) AND d.is_holiday = 1
GROUP BY
    m.year,
    m.month
ORDER BY
    m.year,
    m.month;