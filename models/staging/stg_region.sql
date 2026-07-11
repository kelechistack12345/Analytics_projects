select id as region_id,
          name as region_name
from {{source('raw','region_ma')}}

