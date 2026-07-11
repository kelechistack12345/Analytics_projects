select id as web_events_id,
              account_id, 
              occurred_at,
              channel
from {{source('raw','web_events')}}