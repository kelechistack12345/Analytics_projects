/*Question 1 – Key Revenue Drivers
Which customers contribute the most revenue to the business, and how frequently do they
purchase?*/



with 
  cte as (
    select 
      b.name, 
      sum(a.total_amt_usd) as revenue, 
      count(a.account_id) as order_count 
    from 
      orders a 
      join accounts b on a.account_id = b.id 
    group by 
      b.name 
    order by 
      revenue desc
  ) 
select 
  * 
from 
  cte 
limit 
  1;

/*Question 2 – Sales Portfolio Performance
Which sales representatives oversee the most valuable customer portfolios, and how does their
performance compare to their peers?*/

with 
  cte as(
    select 
      b.name, 
      sum(a.total_amt_usd) as revenue 
    from 
      orders a 
      join accounts b on a.account_id = b.id 
      join sales_reps c on b.sales_rep_id = c.id
    group by 
      b.name 
    order by 
      revenue desc
    limit 1
  ) 

   select 
      b.name, 
      sum(a.total_amt_usd) - cte.revenue  as revenue_diff
    from 
      orders a 
      join accounts b on a.account_id = b.id 
      join sales_reps c on b.sales_rep_id = c.id
      cross join cte
    group by 
      b.name, cte.revenue 
    order by 
    cte.revenue desc;

/*Question 3 – Regional Business Review
Which regions are performing best in terms of revenue generation, customer acquisition, and
average order value?*/

select 
  d.name,
  sum(a.total_amt_usd) as revenue,
  count(a.id) as no_sales ,
  round(avg(a.total),2) as avg_order_value 
from 
  orders a 
  join accounts b on a.account_id = b.id 
  join sales_reps c on b.sales_rep_id = c.id 
  join region d on c.region_id = d.id
 group by
 d.name
 order by no_sales desc;

 /*Question 4 – Strategic Customer Identification
Identify customers that should be considered strategic accounts based on their revenue
contribution to the business.*/

set 
  total_value = (
    select 
      sum(total_amt_usd) 
    from 
      orders
  );
select 
  b.name, 
  sum(total_amt_usd)/ $total_value * 100 as _revenue_share 
from 
  orders a 
  join accounts b on a.account_id = b.id 
group by 
  b.name 
order by 
  _revenue_share desc;

/*Question 5 – Customer Segmentation
Develop a customer tiering framework that categorizes customers into meaningful business
segments based on their spending behavior.*/

select 
  b.name, 
  count(a.id) as no_purchase, 
  case when count(a.id) >= 30 then 'Gold customer' when count(a.id) < 30 
  and count(a.id) >= 20 then 'Silver customer' else 'Bronze customer' end as customer_tier
from 
  orders a 
  join accounts b on a.account_id = b.id 
group by 
  b.name 
order by 
  no_purchase desc;

 /*Question 6 – Above-Average Customers
Which customers are outperforming the average customer in terms of revenue generated?*/   

with customer_revenue as (
    select
        a.id as customer_id,
        a.name as customer_name,
        sum(o.total_amt_usd) as total_revenue
    from accounts a
    join orders o
        on a.id = o.account_id
    group by a.id, a.name
),
avg_revenue as (
    select avg(total_revenue) as avg_rev
    from customer_revenue
)
select
    cr.customer_id,
    cr.customer_name,
    cr.total_revenue
from customer_revenue cr
cross join avg_revenue ar
where cr.total_revenue > ar.avg_rev
order by cr.total_revenue desc;



  
/*Question 7 – Customer Engagement Assessment
Which customers appear to be the most digitally engaged based on their interactions across
marketing channels?*/

select 
c.channel,
b.name,
count(c.id) no_customers
from 
  orders a 
  join accounts b on a.account_id = b.id 
  join web_events c on b.id = c.account_id
  where c.channel not in ('direct', 'banner')
group by 
b.name,
c.channel
order by
no_customers
desc;

