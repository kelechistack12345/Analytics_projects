 select id as account_id,
          name as account_name,
          website,
          lat,
          long,
          primary_poc,
          sales_rep_id 
from {{source('raw','accounts_ma')}}
