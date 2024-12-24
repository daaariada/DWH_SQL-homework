-- Заполнение таблицы d_craftsmans
INSERT INTO dwh.d_craftsmans (craftsman_id, craftsman_name, craftsman_address, craftsman_birthday, craftsman_email, load_dttm)
OVERRIDING SYSTEM VALUE
SELECT 
    craftsman_id,
    craftsman_name,
    craftsman_address,
    craftsman_birthday,
    craftsman_email,
    load_dttm
FROM (
    SELECT DISTINCT ON (craftsman_id)
        craftsman_id, craftsman_name, craftsman_address, craftsman_birthday, craftsman_email, load_dttm
    FROM (
        SELECT craftsman_id, craftsman_name, craftsman_address, craftsman_birthday, craftsman_email, NOW() AS load_dttm, 1 AS priority
        FROM source1.craft_market_wide
        UNION ALL
        SELECT craftsman_id, craftsman_name, craftsman_address, craftsman_birthday, craftsman_email, NOW() AS load_dttm, 2 AS priority
        FROM source2.craft_market_masters_products
        UNION ALL
        SELECT craftsman_id, craftsman_name, craftsman_address, craftsman_birthday, craftsman_email, NOW() AS load_dttm, 3 AS priority
        FROM source3.craft_market_craftsmans
    ) prioritized_data
    ORDER BY craftsman_id, priority
) resolved_data
ON CONFLICT (craftsman_id) DO UPDATE
SET
    craftsman_name = EXCLUDED.craftsman_name,
    craftsman_address = EXCLUDED.craftsman_address,
    craftsman_birthday = EXCLUDED.craftsman_birthday,
    craftsman_email = EXCLUDED.craftsman_email,
    load_dttm = EXCLUDED.load_dttm;


-- Заполнение таблицы d_customers
INSERT INTO dwh.d_customers (customer_id, customer_name, customer_address, customer_birthday, customer_email, load_dttm)
OVERRIDING SYSTEM VALUE
SELECT 
    customer_id,
    customer_name,
    customer_address,
    customer_birthday,
    customer_email,
    load_dttm
FROM (
    SELECT DISTINCT ON (customer_id)
        customer_id, customer_name, customer_address, customer_birthday, customer_email, load_dttm
    FROM (
        SELECT customer_id, customer_name, customer_address, customer_birthday, customer_email, NOW() AS load_dttm, 1 AS priority
        FROM source1.craft_market_wide
        UNION ALL
        SELECT customer_id, customer_name, customer_address, customer_birthday, customer_email, NOW() AS load_dttm, 2 AS priority
        FROM source2.craft_market_orders_customers
        UNION ALL
        SELECT customer_id, customer_name, customer_address, customer_birthday, customer_email, NOW() AS load_dttm, 3 AS priority
        FROM source3.craft_market_customers
    ) prioritized_data
    ORDER BY customer_id, priority
) resolved_data
ON CONFLICT (customer_id) DO UPDATE
SET
    customer_name = EXCLUDED.customer_name,
    customer_address = EXCLUDED.customer_address,
    customer_birthday = EXCLUDED.customer_birthday,
    customer_email = EXCLUDED.customer_email,
    load_dttm = EXCLUDED.load_dttm;

-- Заполнение таблицы d_products
INSERT INTO dwh.d_products (product_id, product_name, product_description, product_type, product_price, load_dttm)
OVERRIDING SYSTEM VALUE
SELECT 
    product_id,
    product_name,
    product_description,
    product_type,
    product_price,
    load_dttm
FROM (
    SELECT DISTINCT ON (product_id)
        product_id, product_name, product_description, product_type, product_price, load_dttm
    FROM (
        SELECT product_id, product_name, product_description, product_type, product_price, NOW() AS load_dttm, 1 AS priority
        FROM source1.craft_market_wide
        UNION ALL
        SELECT product_id, product_name, product_description, product_type, product_price, NOW() AS load_dttm, 2 AS priority
        FROM source2.craft_market_masters_products
        UNION ALL
        SELECT product_id, product_name, product_description, product_type, product_price, NOW() AS load_dttm, 3 AS priority
        FROM source3.craft_market_orders
    ) prioritized_data
    ORDER BY product_id, priority
) resolved_data
ON CONFLICT (product_id) DO UPDATE
SET
    product_name = EXCLUDED.product_name,
    product_description = EXCLUDED.product_description,
    product_type = EXCLUDED.product_type,
    product_price = EXCLUDED.product_price,
    load_dttm = EXCLUDED.load_dttm;

-- Заполнение таблицы f_orders
INSERT INTO dwh.f_orders (order_id, product_id, craftsman_id, customer_id, order_created_date, order_completion_date, order_status, load_dttm)
OVERRIDING SYSTEM VALUE
SELECT 
    order_id,
    product_id,
    craftsman_id,
    customer_id,
    order_created_date,
    order_completion_date,
    order_status,
    load_dttm
FROM (
    SELECT DISTINCT ON (order_id)
        order_id, product_id, craftsman_id, customer_id, order_created_date, order_completion_date, order_status, load_dttm
    FROM (
        SELECT order_id, product_id, craftsman_id, customer_id, order_created_date, order_completion_date, order_status, NOW() AS load_dttm, 1 AS priority
        FROM source1.craft_market_wide
        UNION ALL
        SELECT order_id, product_id, craftsman_id, customer_id, order_created_date, order_completion_date, order_status, NOW() AS load_dttm, 2 AS priority
        FROM source2.craft_market_orders_customers
        UNION ALL
        SELECT order_id, product_id, craftsman_id, customer_id, order_created_date, order_completion_date, order_status, NOW() AS load_dttm, 3 AS priority
        FROM source3.craft_market_orders
    ) prioritized_data
    ORDER BY order_id, priority
) resolved_data
ON CONFLICT (order_id) DO UPDATE
SET
    order_created_date = EXCLUDED.order_created_date,
    order_completion_date = EXCLUDED.order_completion_date,
    order_status = EXCLUDED.order_status,
    load_dttm = EXCLUDED.load_dttm;
