-- start query 95 in stream 0 using template query95.tpl
WITH ws_wh AS (SELECT
        ws1.ws_order_number,
        ws1.ws_warehouse_sk wh1,
        ws2.ws_warehouse_sk wh2 
    FROM
        web_sales ws1,
        web_sales ws2 
    WHERE
        ws1.ws_order_number = ws2.ws_order_number 
        AND ws1.ws_warehouse_sk <> ws2.ws_warehouse_sk) SELECT
        count(DISTINCT ws1.ws_order_number) AS 'order count',
        sum(ws1.ws_ext_ship_cost) AS 'total shipping cost',
        sum(ws1.ws_net_profit) AS 'total net profit' 
    FROM
        web_sales ws1,
        date_dim,
        customer_address,
        web_site 
    WHERE
        date_dim.d_date BETWEEN '2001-4-01' AND date_add(CAST('2001-4-01' AS date), INTERVAL 60 day) 
        AND ws1.ws_ship_date_sk = date_dim.d_date_sk 
        AND ws1.ws_ship_addr_sk = customer_address.ca_address_sk 
        AND customer_address.ca_state = 'VA' 
        AND ws1.ws_web_site_sk = web_site.web_site_sk 
        AND web_site.web_company_name = 'pri' 
        AND ws1.ws_order_number IN (
            SELECT
                ws1.ws_order_number 
            FROM
                ws_wh
        ) 
        AND ws1.ws_order_number IN (
            SELECT
                web_returns.wr_order_number 
            FROM
                web_returns,
                ws_wh 
            WHERE
                web_returns.wr_order_number = ws_wh.ws_order_number
        ) 
    ORDER BY
        count(DISTINCT ws1.ws_order_number) LIMIT 100;
-- end query 95 in stream 0 using template query95.tpl
