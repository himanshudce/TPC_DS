-- start query 51 in stream 0 using template query51.tpl

select  *
from (
	select 
	item_sk
	,d_date
	,web_sales
	,store_sales
	,max(web_sales)
	over (partition by item_sk order by d_date rows between unbounded preceding and current row) web_cumulative
	,max(store_sales)
	over (partition by item_sk order by d_date rows between unbounded preceding and current row) store_cumulative

	from (
	
		select 
		case when x.item_sk_web is not null then x.item_sk_web else x.item_sk_store end item_sk
		,case when x.d_date_web is not null then x.d_date_web else x.d_date_store end d_date
		,x.cume_sales_web web_sales
		,x.cume_sales_store store_sales 

		from(
			select * from(
				(select
				ws_item_sk item_sk_web, d_date d_date_web,
				sum(sum(ws_sales_price))
				over (partition by ws_item_sk order by d_date rows between unbounded preceding and current row) cume_sales_web
				from web_sales
				,date_dim
				where ws_sold_date_sk=d_date_sk
				and d_month_seq between 1212 and 1212+11
				and ws_item_sk is not NULL
				group by ws_item_sk, d_date) web 

				left join 

				(select
				ss_item_sk item_sk_store, d_date d_date_store,
				sum(sum(ss_sales_price))
				over (partition by ss_item_sk order by d_date rows between unbounded preceding and current row) cume_sales_store
				from store_sales
				,date_dim
				where ss_sold_date_sk=d_date_sk
				and d_month_seq between 1212 and 1212+11
				and ss_item_sk is not NULL
				group by ss_item_sk, d_date) store 

				on (web.item_sk_web = store.item_sk_store and web.d_date_web = store.d_date_store)
			)

			union

			select * from(
				(select
				ws_item_sk item_sk_web, d_date d_date_web,
				sum(sum(ws_sales_price))
				over (partition by ws_item_sk order by d_date rows between unbounded preceding and current row) cume_sales_web
				from web_sales
				,date_dim
				where ws_sold_date_sk=d_date_sk
				and d_month_seq between 1212 and 1212+11
				and ws_item_sk is not NULL
				group by ws_item_sk, d_date) web 

				right join 

				(select
				ss_item_sk item_sk_store, d_date d_date_store,
				sum(sum(ss_sales_price))
				over (partition by ss_item_sk order by d_date rows between unbounded preceding and current row) cume_sales_store
				from store_sales
				,date_dim
				where ss_sold_date_sk=d_date_sk
				and d_month_seq between 1212 and 1212+11
				and ss_item_sk is not NULL
				group by ss_item_sk, d_date) store 

				on (web.item_sk_web = store.item_sk_store and web.d_date_web = store.d_date_store)
			)
		) x

	) y	 
) z



where web_cumulative > store_cumulative
order by item_sk
,d_date
limit 100;

-- end query 51 in stream 0 using template query51.tpl
