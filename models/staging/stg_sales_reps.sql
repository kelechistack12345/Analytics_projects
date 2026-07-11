select id as sales_reps_id,
              name as sales_reps_name,
              region_id 
from {{source('raw','sales_reps_ma')}}

