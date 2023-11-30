create database if not exists trade;


create table if not exists trade_data(
HSCode INT,
commodity VARCHAR(255),
value DECIMAL(10, 2),
country VARCHAR(255),
year INT
);

-- answering business questions

-- 1.What are the distinct commodities present in the dataset
select count(distinct commodity) from export_data

-- 2.How many unique countries are included in the dataset
select count(distinct country) from export_data

-- 3.What are the unique HSCode values in the dataset?
select count(distinct HSCode) from export_data

-- 4.What is the total trade value for each country in a specific year?
select country,year,sum(value)as trade_value from export_data
group by 1,2

-- 5.What is the average trade value for each commodity across all year?
select commodity,year,avg(value) from export_data
group by 1,2

-- 6.Which country has the highest total trade value?
select country,sum(value)as trade_value from export_data
group by 1
order by trade_value desc 

-- 7.What is the total trade value for a specific commodity in a given year?
select commodity,year,sum(value) from export_data
group by 1,2

-- 8.identify the top 5 commodities with the highest trade value for each country?
select country,commodity,highest_value from
(select country,commodity,sum(value) as highest_value ,rank() over(partition by country order by sum(value) desc)as rnk from export_data
group by 1,2)export_data
where rnk <=5

-- Are there any commodities with zero export values
select * from export_data
where value = 0

-- How many commodities have missing values for the 'value' column
select count(*) from export_data
where value = 0

--  what is the total value of exports in the year 2010 for each country
select country,sum(value) from export_data
where year = 2010
group by 1

-- Which commodity has the highest export value globally
select commodity,sum(value) from export_data
group by 1
order by sum(value) desc
limit 1

-- What are the top 5 countries with the highest total export values
select country,sum(value) total_value from export_data
group by 1 
order by total_value desc limit 5 

-- Which countries have the lowest total export values?
select country,sum(value) total_value from export_data
group by 1
order by total_value

-- How many commodities have export values greater than 10
select count(*) from export_data
where value > 10

-- What is the average trade value for each year?
select year,avg(value) from export_data
group by 1

-- Which commodities have the highest and lowest trade values overall?
select commodity, sum(value) as highest from export_data
group by 1
order by highest desc
select commodity, sum(value) as lowest from export_data
group by 1
order by lowest 

-- Calculate the average trade value for each HSCode category
select HSCode,avg(value) from export_data
group by 1

-- What is the percentage share of each country in the total trade value?
select country,(sum(value) / (select sum(value) from export_data)) * 100 as percent from export_data
group by 1
order by percent desc

-- Calculate the year-over-year growth rate for the total trade value of a specific country.
select year,total_revenue,prev_year,((total_revenue-prev_year)/prev_year)* 100 from 
(select year,sum(value) as total_revenue,lag(sum(value)) over(order by year) as prev_year from export_data
group by 1) export_data

-- Identify the commodities that have shown significant growth in trade value over the years.
select year,commodity,avg(growth_rate) from 
(select year,commodity,value,((value-prev_value)/prev_value) * 100 as growth_rate from 
(select year,commodity,value,lag(value) over(partition by commodity order by year) as prev_value from export_data) export_data) export_data
group by 1,2
order by avg(growth_rate) desc

-- Analyze the trade distribution for a specific commodity over different years.
select year,sum(value) from export_data
where commodity = 'MEAT AND EDIBLE MEAT OFFAL.'
group by 1

-- Calculate the percentage contribution of each commodity to the total trade value in a specific year (suppose 2010)
select commodity, (sum(value) / (select sum(value) from export_data where year = 2010)) * 100 as percent from export_data
where year = 2010
group by 1
order by percent desc


