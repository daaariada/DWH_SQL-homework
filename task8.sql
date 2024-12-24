INSERT INTO dwh.craftsman_report_datamart (
    craftsman_id,
    craftsman_name,
    craftsman_address,
    craftsman_birthday,
    craftsman_email,
    craftsman_money,
    platform_money,
    count_order,
    avg_price_order,
    avg_age_customer,
    median_time_order_completed,
    top_product_category,
    count_order_created,
    count_order_in_progress,
    count_order_delivery,
    count_order_done,
    count_order_not_done,
    report_period
)
SELECT 
    c.craftsman_id,
    c.craftsman_name,
    c.craftsman_address,
    c.craftsman_birthday,
    c.craftsman_email,
    SUM(p.product_price * 0.9) AS craftsman_money,
    SUM(p.product_price * 0.1) AS platform_money,
    COUNT(o.order_id) AS count_order,
    AVG(p.product_price) AS avg_price_order,
    AVG(DATE_PART('year', AGE(cust.customer_birthday))) AS avg_age_customer,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY (o.order_completion_date - o.order_created_date)) 
        AS median_time_order_completed,
    (
        SELECT p2.product_type 
        FROM dwh.d_products p2
        JOIN dwh.f_orders o2 ON p2.product_id = o2.product_id
        WHERE o2.craftsman_id = c.craftsman_id
        GROUP BY p2.product_type
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) AS top_product_category,
    COUNT(CASE WHEN o.order_status = 'created' THEN 1 END) AS count_order_created,
    COUNT(CASE WHEN o.order_status = 'in progress' THEN 1 END) AS count_order_in_progress,
    COUNT(CASE WHEN o.order_status = 'delivery' THEN 1 END) AS count_order_delivery,
    COUNT(CASE WHEN o.order_status = 'done' THEN 1 END) AS count_order_done,
    COUNT(CASE WHEN o.order_status = 'not_done' THEN 1 END) AS count_order_not_done,
    TO_CHAR(DATE_TRUNC('month', MIN(o.order_created_date)), 'YYYY-MM') AS report_period
FROM 
    dwh.d_craftsmans c
    JOIN dwh.f_orders o ON c.craftsman_id = o.craftsman_id
    JOIN dwh.d_customers cust ON o.customer_id = cust.customer_id
    JOIN dwh.d_products p ON o.product_id = p.product_id
GROUP BY 
    c.craftsman_id, c.craftsman_name, c.craftsman_address, 
    c.craftsman_birthday, c.craftsman_email;

-- показывает когда была обновлена таблица сверху
INSERT INTO dwh.load_dates_craftsman_report_datamart (load_dttm)
VALUES (CURRENT_TIMESTAMP);