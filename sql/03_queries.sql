-- ============================================================
-- RETAIL SALES & CUSTOMER INTELLIGENCE SYSTEM
-- 03_queries.sql — All Business KPI Queries
-- Run each query one at a time in Supabase SQL Editor
-- ============================================================


-- ============================================================
-- QUERY 1: Monthly Revenue Trend
-- ============================================================

SELECT
    DATE_TRUNC('month', o.order_date)     AS revenue_month,
    COUNT(DISTINCT o.order_id)            AS total_orders,
    COUNT(DISTINCT o.customer_id)         AS unique_customers,
    ROUND(SUM(
        oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0)
    ), 2)                                 AS gross_revenue,
    ROUND(SUM(
        oi.quantity * (oi.unit_price - p.cost_price) * (1 - oi.discount_pct / 100.0)
    ), 2)                                 AS gross_profit

FROM orders o
JOIN order_items oi ON o.order_id  = oi.order_id
JOIN products p     ON oi.product_id = p.product_id
WHERE o.status = 'Completed'
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY revenue_month;


-- ============================================================
-- QUERY 2: Revenue by Country
-- ============================================================

SELECT
    o.shipping_country,
    COUNT(DISTINCT o.customer_id)    AS customer_count,
    COUNT(DISTINCT o.order_id)       AS order_count,
    ROUND(SUM(
        oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0)
    ), 2)                            AS total_revenue,
    ROUND(AVG(
        oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0)
    ), 2)                            AS avg_order_value,
    ROUND(
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0))
        / SUM(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0)))
          OVER () * 100, 1
    )                                AS revenue_share_pct

FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'Completed'
GROUP BY o.shipping_country
ORDER BY total_revenue DESC;


-- ============================================================
-- QUERY 3: Top 20% Customers (Pareto Analysis)
-- ============================================================

WITH customer_revenue AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        c.segment,
        c.country,
        ROUND(SUM(
            oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0)
        ), 2)                              AS total_revenue,
        COUNT(DISTINCT o.order_id)         AS total_orders
    FROM customers c
    JOIN orders o       ON c.customer_id  = o.customer_id
    JOIN order_items oi ON o.order_id     = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY c.customer_id, c.first_name, c.last_name, c.segment, c.country
),

ranked AS (
    SELECT
        *,
        RANK()  OVER (ORDER BY total_revenue DESC) AS revenue_rank,
        NTILE(5) OVER (ORDER BY total_revenue DESC) AS revenue_quintile,
        ROUND(
            SUM(total_revenue) OVER (ORDER BY total_revenue DESC)
            / SUM(total_revenue) OVER () * 100, 1
        )                                          AS cumulative_revenue_pct
    FROM customer_revenue
)

SELECT
    customer_id,
    customer_name,
    segment,
    country,
    total_revenue,
    total_orders,
    revenue_rank,
    cumulative_revenue_pct,
    CASE revenue_quintile
        WHEN 1 THEN 'Top 20%'
        WHEN 2 THEN 'Next 20%'
        ELSE        'Standard'
    END                                            AS customer_tier
FROM ranked
ORDER BY revenue_rank;


-- ============================================================
-- QUERY 4: Repeat Purchase Rate
-- ============================================================

WITH order_counts AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders
    WHERE status = 'Completed'
    GROUP BY customer_id
)

SELECT
    COUNT(*)                                                AS total_customers,
    COUNT(CASE WHEN total_orders = 1 THEN 1 END)           AS one_time_buyers,
    COUNT(CASE WHEN total_orders > 1  THEN 1 END)          AS repeat_buyers,
    ROUND(
        COUNT(CASE WHEN total_orders > 1 THEN 1 END) * 100.0
        / COUNT(*), 1
    )                                                      AS repeat_purchase_rate_pct,
    ROUND(AVG(total_orders), 2)                            AS avg_orders_per_customer

FROM order_counts;


-- ============================================================
-- QUERY 5: Customer Lifetime Value (CLV)
-- ============================================================

WITH customer_stats AS (
    SELECT
        c.customer_id,
        c.first_name || ' ' || c.last_name  AS customer_name,
        c.segment,
        c.signup_date,
        COUNT(DISTINCT o.order_id)           AS total_orders,
        ROUND(SUM(
            oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100.0)
        ), 2)                                AS total_revenue,
        MIN(o.order_date)                    AS first_order_date,
        MAX(o.order_date)                    AS last_order_date,
        MAX(o.order_date) - MIN(o.order_date) AS lifespan_days
    FROM customers c
    JOIN orders o       ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id    = oi.order_id
    WHERE o.status = 'Completed'
    GROUP BY c.customer_id, c.first_name, c.last_name, c.segment, c.signup_date
)

SELECT
    customer_id,
    customer_name,
    segment,
    total_orders,
    total_revenue,
    first_order_date,
    last_order_date,
    lifespan_days,
    ROUND(total_revenue / total_orders, 2)       AS avg_order_value,
    CASE
        WHEN lifespan_days > 0
        THEN ROUND(total_orders * 1.0 / (lifespan_days / 30.0), 2)
        ELSE total_orders
    END                                          AS orders_per_month,
    ROUND(
        total_revenue / NULLIF(lifespan_days, 0) * 365, 2
    )                                            AS annualized_clv

FROM customer_stats
ORDER BY total_revenue DESC;


-- ============================================================
-- QUERY 6: Inventory Turnover
-- ============================================================

WITH units_sold AS (
    SELECT
        oi.product_id,
        SUM(oi.quantity)                   AS total_units_sold,
        SUM(oi.quantity * p.cost_price)    AS cost_of_goods_sold
    FROM order_items oi
    JOIN orders o   ON oi.order_id   = o.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.status = 'Completed'
    GROUP BY oi.product_id
),

inventory_value AS (
    SELECT
        i.product_id,
        SUM(i.stock_quantity)                          AS current_stock,
        SUM(i.stock_quantity * p.cost_price)           AS inventory_cost_value
    FROM inventory i
    JOIN products p ON i.product_id = p.product_id
    GROUP BY i.product_id
)

SELECT
    p.product_id,
    p.product_name,
    iv.current_stock,
    us.total_units_sold,
    ROUND(us.cost_of_goods_sold, 2)                    AS cogs,
    ROUND(iv.inventory_cost_value, 2)                  AS inventory_value,
    ROUND(
        us.cost_of_goods_sold / NULLIF(iv.inventory_cost_value, 0), 2
    )                                                  AS inventory_turnover_ratio,
    ROUND(
        365.0 / NULLIF(
            us.cost_of_goods_sold / NULLIF(iv.inventory_cost_value, 0)
        , 0), 0
    )                                                  AS days_to_sell_stock

FROM products p
LEFT JOIN units_sold      us ON p.product_id = us.product_id
LEFT JOIN inventory_value iv ON p.product_id = iv.product_id
WHERE p.is_active = TRUE
ORDER BY inventory_turnover_ratio DESC NULLS LAST;


-- ============================================================
-- QUERY 7: Stockout Risk Detection
-- ============================================================

SELECT
    p.product_id,
    p.product_name,
    s.store_name,
    s.country,
    i.stock_quantity,
    i.reorder_level,
    i.last_updated,

    CASE
        WHEN i.stock_quantity = 0                    THEN 'STOCKOUT'
        WHEN i.stock_quantity <= i.reorder_level     THEN 'LOW STOCK - Reorder Now'
        WHEN i.stock_quantity <= i.reorder_level * 2 THEN 'Watch - Stock Getting Low'
        ELSE                                              'OK'
    END                                              AS stock_status,

    i.stock_quantity - i.reorder_level               AS stock_buffer,

    COALESCE(
        ROUND(
            i.stock_quantity * 1.0
            / NULLIF((
                SELECT SUM(oi2.quantity) * 1.0 / 90
                FROM order_items oi2
                JOIN orders o2 ON oi2.order_id = o2.order_id
                WHERE oi2.product_id = p.product_id
                  AND o2.status      = 'Completed'
                  AND o2.order_date >= CURRENT_DATE - INTERVAL '90 days'
            ), 0)
        , 0), 0
    )                                                AS estimated_days_until_stockout

FROM inventory i
JOIN products p ON i.product_id = p.product_id
JOIN stores   s ON i.store_id   = s.store_id
WHERE p.is_active = TRUE
ORDER BY
    CASE
        WHEN i.stock_quantity = 0                THEN 1
        WHEN i.stock_quantity <= i.reorder_level THEN 2
        ELSE                                          3
    END,
    estimated_days_until_stockout ASC;
