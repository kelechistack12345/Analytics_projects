{{config(materalized='table',schema='MARTS')}}

select * 
from {{ref('stg_web_events')}}



