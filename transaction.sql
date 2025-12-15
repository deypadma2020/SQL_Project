/*
1. Create a SQL code to:
a) Calculate: total_transactions, unique_users and total_transaction_amount for every date and hour combination.
*/
select 
    date_trunc('hour', t.date) as date_hour,
    count(t.transaction_id) as total_transactions,
    count(distinct t.user_id) as unique_users,
    sum(t.transaction_amount) as total_transaction_amount
from transactions t
group by date_trunc('hour', t.date)
order by t.date_hour;

/*
b) Calculate hour with highest transaction_amount for every date
*/
with hourly_data as (
					select 
						date(t.date) as txn_date,
						extract(hour from t.date) as txn_hour,
						sum(t.transaction_amount) as hour_total
					from transactions t
					group by date(t.date), extract(hour from t.date)
),
ranked_hours as (
				select *,
				rank() over (partition by hd.txn_date order by hd.hour_total desc) as hour_rank
				from hourly_data hd
)
select rh.txn_date, rh.txn_hour, rh.hour_total
from ranked_hours rh
where rh.hour_rank = 1;
