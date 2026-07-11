select id as orders_id,
          account_id,
          occurred_at,
          standard_qty,
          gloss_qty,
          poster_qty,
          total,
          standard_amt_usd,
          gloss_amt_usd,
          poster_amt_usd,
          total_amt_usd
from {{source('raw','orders_ma')}}