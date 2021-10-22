-- Since the execution time for query 95 too much (more than 1 day for 1gb), we did indexing for query 95 to execute it in realtime 
ALTER TABLE `customer_address` ADD INDEX `customer_address_idx_ca_state_ca_sk` (`ca_state`,`ca_address_sk`);
ALTER TABLE `date_dim` ADD INDEX `date_dim_idx_d_sk_d_date` (`d_date_sk`,`d_date`);
ALTER TABLE `web_returns` ADD INDEX `web_returns_idx_wr_number` (`wr_order_number`);
ALTER TABLE `web_sales` ADD INDEX `web_sales_idx_ws_sk_ws_sk_ws_sk_ws_numb` (`ws_ship_date_sk`,`ws_ship_addr_sk`,`ws_web_site_sk`,`ws_order_number`);
ALTER TABLE `web_sales` ADD INDEX `web_sales_idx_ws_number_ws_sk` (`ws_order_number`,`ws_warehouse_sk`);
ALTER TABLE `web_site` ADD INDEX `web_site_idx_web_name_web_sk` (`web_company_name`,`web_site_sk`);

