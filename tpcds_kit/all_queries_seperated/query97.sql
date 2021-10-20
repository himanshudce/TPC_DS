-- start query 97 in stream 0 using template query97.tpl

select sum(C.store_only) as store_only, sum(C.catalog_only) as catalog_only, avg(C.store_and_catalog) as store_and_catalog from

(select * from
(select  sum(case when ssci.customer_sk is not null and csci.customer_sk is null then 1 else 0 end) store_only
,sum(case when ssci.customer_sk is null and csci.customer_sk is not null then 1 else 0 end) catalog_only
,sum(case when ssci.customer_sk is not null and csci.customer_sk is not null then 1 else 0 end) store_and_catalog
from (
select ss_customer_sk customer_sk
,ss_item_sk item_sk
from store_sales,date_dim
where ss_sold_date_sk = d_date_sk
and d_month_seq between 1199 and 1199 + 11
group by ss_customer_sk
,ss_item_sk
) as ssci 
right join 
(select cs_bill_customer_sk customer_sk
,cs_item_sk item_sk
from catalog_sales,date_dim
where cs_sold_date_sk = d_date_sk
and d_month_seq between 1199 and 1199 + 11
group by cs_bill_customer_sk
,cs_item_sk) as csci 
on (ssci.customer_sk=csci.customer_sk and ssci.item_sk = csci.item_sk)) A

union

select * from

(select  sum(case when ssci.customer_sk is not null and csci.customer_sk is null then 1 else 0 end) store_only
,sum(case when ssci.customer_sk is null and csci.customer_sk is not null then 1 else 0 end) catalog_only
,sum(case when ssci.customer_sk is not null and csci.customer_sk is not null then 1 else 0 end) store_and_catalog
from (
select ss_customer_sk customer_sk
,ss_item_sk item_sk
from store_sales,date_dim
where ss_sold_date_sk = d_date_sk
and d_month_seq between 1199 and 1199 + 11
group by ss_customer_sk
,ss_item_sk
) as ssci 
left join 
(select cs_bill_customer_sk customer_sk
,cs_item_sk item_sk
from catalog_sales,date_dim
where cs_sold_date_sk = d_date_sk
and d_month_seq between 1199 and 1199 + 11
group by cs_bill_customer_sk
,cs_item_sk) as csci 
on (ssci.customer_sk=csci.customer_sk and ssci.item_sk = csci.item_sk)) B) C
limit 100;

-- end query 97 in stream 0 using template query97.tpl
