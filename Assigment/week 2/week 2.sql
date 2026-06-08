/*Question 1 — Top Revenue-Generating Accounts
Business Problem*/

select count(*) from orders

select 
  top 10 
  b.name, 
  sum(a.total_amt_usd) as total_revenue 
from 
  orders a 
  join accounts b on a.account_id = b.id 
group by 
  b.name 
order by 
  total_revenue desc;

/* Question 2 — Monthly Revenue Trend
Business Problem*/

select 
  concat(
    monthname(occurred_at), 
    ' ', 
    year(occurred_at)
  ) as mm_yy, 
  sum(total_amt_usd) as total_revenue 
from 
  orders
  group by mm_yy
  order by mm_yy desc;

/*Question 3 — Customer Segmentation by Revenue
Business Problem*/

select 
    a.name,
    ceil(sum(b.total_amt_usd)) as total_amount,
    case
        when ceil(sum(b.total_amt_usd)) >= 200000 then 'Enterprise'
        when ceil(sum(b.total_amt_usd)) >= 100000
             and ceil(sum(b.total_amt_usd)) < 200000 then 'Mid-Market'
        else 'Small Business'
    end as customer_segment_by_revenue
from accounts a
join orders b
    on a.id = b.account_id
group by
    a.name
order by
    total_amount desc;

/*Question 4 — Most Effective Marketing Channel*/

select
    channel,
    count(*) as occurance
from web_events
group by
    channel
order by
    occurance desc
limit 1;


/*Question 5 — Average Order Value by Region
Business Problem*/

select
    d.name,
    round(avg(a.total_amt_usd), 2) as avg_order_value
from orders a
join accounts b
    on a.account_id = b.id
join sales_reps c
    on b.sales_rep_id = c.id
join region d
    on c.region_id = d.id
group by d.name
order by avg_order_value desc;

/*Question 6 — Sales Rep Performance Ranking
Business Problem*/

select 
  c.name, 
  sum(a.total_amt_usd) as revenue 
from 
  orders a 
  join accounts b on a.account_id = b.id 
  join sales_reps c on b.sales_rep_id = c.id 
group by 
  c.name 
order by 
  revenue desc;

/*Question 7 — Detect High-Value Orders
Business Problem*/

select 
  b.name, 
  sum(total_amt_usd) as revenue
from 
  orders a 
  join accounts b on a.account_id = b.id 
group by 
  b.name 
order by 
  revenue desc;

/*Question 8 — Customer Purchase Frequency
Business Problem*/

select 
  b.name, 
  count(a.account_id) as number_of_order
from 
  orders a 
  join accounts b on a.account_id = b.id 
group by 
  b.name 
order by 
  number_of_order desc;

/*Question 9 — Revenue Contribution Percentage*/

set 
  saleamount = (
    select 
      sum(total_amt_usd) 
    from 
      orders
  );
select 
  b.name, 
  sum(total_amt_usd) as revenue, 
  sum(total_amt_usd)/ $saleamount * 100 as precentage_contribution 
from 
  orders a 
  join accounts b on a.account_id = b.id 
group by 
  b.name 
order by 
  precentage_contribution desc;

/*Question 10 — Identify Inactive Customers
Business Problem*/

select
  concat(monthname(a.occurred_at),' ',day(a.occurred_at)) as date,
  b.name,
  sum(a.total) as total_qty 
from 
  orders a 
  join accounts b on a.account_id = b.id 
group by
  date,
  b.name 
having
    total_qty <= 0
order by 
  date desc;

/*Question 11 — Rolling 3-Month Revenue Trend
Business Problem*/

select
  monthname(a.occurred_at) as date,
  b.name,
  sum(a.total) as total_qty 
from 
  orders a 
  join accounts b on a.account_id = b.id 
group by
  date,
  b.name 
order by 
  date desc;





  









