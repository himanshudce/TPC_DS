-- start query 22 in stream 0 using template query22.tpl
select * from 
(select  i_product_name
,i_brand
,i_class
,i_category
,avg(inv_quantity_on_hand) qoh
from inventory
,date_dim
,item
where inv_date_sk=d_date_sk
and inv_item_sk=i_item_sk
and d_month_seq between 1200 and 1200 + 11
group by i_product_name,i_brand,i_class ,i_category with rollup ) rolled_up_inv
order by rolled_up_inv.qoh, rolled_up_inv.i_product_name, rolled_up_inv.i_brand, rolled_up_inv.i_class, rolled_up_inv.i_category
limit 100;

-- end query 22 in stream 0 using template query22.tpl
