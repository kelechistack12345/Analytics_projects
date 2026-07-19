{{config(materalized='table',schema='MARTS')}}

select * 
from {{ref('stg_region')}}


