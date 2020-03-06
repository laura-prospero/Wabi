select
t.id
,case when type='payment' then json_extract_path_text(jsonb_array_element_text(JSONb_EXTRACT_PATH(jsonb_extract_path(stripe_response,'charges'),'data'),0)::json,'balance_transaction')
when type='refund' then jsonb_extract_path_text(stripe_response,'balance_transaction') 
end as "TXN_ID"
--,case when jsonb_extract_path_text(stripe_response,'balance_transaction')  is not null then jsonb_extract_path(stripe_response,'balance_transaction') end as txn_id_1
--,json_extract_path_text(jsonb_array_element_text(JSONb_EXTRACT_PATH(jsonb_extract_path(stripe_response,'charges'),'data'),0)::json,'balance_transaction')
--as  txn_id 
,Bill_id as "Bill_ID"
,t.subscriber_id as "Subscriber_ID"
,first_name||' '||last_name as "Subscriber Name"
,sub.id as "Subscription_ID"
,"start"::date as "Subscription Start"
,"end"::date as "Subscription End"
,sub.duration as "Duration"
,replace(text(ROUND(((sub.rate_rate/100.00)/7)*duration,2)),'.',',') as "Subscription Fees"
,l.city as "City"
,m.state as "State"
,d.legal_id as "Dealer Taxcode"
from public.transactions t
join public.bills b 
on t.bill_id=b.id and b.subscriber_id=t.subscriber_id
join public.subscriptions SUB 
on sub.id=b.subscription_id and sub.subscriber_id=t.subscriber_id
join public.subscribers s 
on s.id=sub.subscriber_id and t.subscriber_id=s.id
join public.locations l 
on l.id=sub.pickup_location_id
join public.dealers d
on d.id=l.dealer_id
join public.markets m
on l.market_id=m.id


