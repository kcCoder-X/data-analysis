create database if not exists sql_projects;
use sql_projects;
select *
from user_events
order by event_id asc
limit 20;
with funnel_stages as(
    select count(
            distinct case
                when event_type = "page_view" then user_id
            end
        ) as stage_1_views,
        count(
            distinct case
                when event_type = "add_to_cart" then user_id
            end
        ) as stage_2_cart,
        count(
            distinct case
                when event_type = "checkout_start" then user_id
            end
        ) as stage_3_checkout,
        count(
            distinct case
                when event_type = "payment_info" then user_id
            end
        ) as stage_4_payment,
        count(
            distinct case
                when event_type = "purchase" then user_id
            end
        ) as stage_5_purchase
    from user_events
    where event_date >= (date_sub(now(), interval 30 DAY))
)
select stage_1_views,
    stage_2_cart,
    round(stage_2_cart * 100 / stage_1_views) as view_to_cart_rate,
    stage_3_checkout,
    round(stage_3_checkout * 100 / stage_2_cart) as cart_to_checkout_rate,
    stage_4_payment,
    round(stage_4_payment * 100 / stage_3_checkout) as checkout_to_payment_rate,
    stage_5_purchase,
    round(stage_5_purchase * 100 / stage_4_payment) as overall_conversion_rate
from funnel_stages;
-- funnel by source
with source_funnel as(
    select traffic_source,
        count(
            distinct case
                when event_type = "page_view" then user_id
            end
        ) as views,
        count(
            distinct case
                when event_type = "add_to_cart" then user_id
            end
        ) as carts,
        count(
            distinct case
                when event_type = "purchase" then user_id
            end
        ) as purchases
    from user_events
    where event_date >= (date_sub(now(), interval 30 DAY))
    group by traffic_source
)
select traffic_source,
    views,
    carts,
    purchases,
    round(carts * 100 / views) as cart_conversion_rate,
    round(purchases * 100 / views) as puchases_conversion_rate,
    round(purchases * 100 / carts) as cart_to_purchase_conversion_rate
from source_funnel
order by purchases asc;
-- time to conversion analysis
WITH user_journey AS (
    SELECT user_id,
        MIN(
            CASE
                WHEN event_type = "page_view" THEN event_date
            END
        ) AS view_time,
        MIN(
            CASE
                WHEN event_type = "add_to_cart" THEN event_date
            END
        ) AS cart_time,
        MIN(
            CASE
                WHEN event_type = "purchase" THEN event_date
            END
        ) AS purchase_time
    FROM user_events
    WHERE event_date >= DATE_SUB(NOW(), INTERVAL 30 DAY)
    GROUP BY user_id
    HAVING purchase_time IS NOT NULL
)
SELECT COUNT(*) AS converted_users,
    ROUND(
        AVG(TIMESTAMPDIFF(MINUTE, view_time, cart_time)),
        2
    ) AS avg_view_to_cart_minutes,
    ROUND(
        AVG(TIMESTAMPDIFF(MINUTE, cart_time, purchase_time)),
        2
    ) AS avg_cart_to_purchase_minutes,
    ROUND(
        AVG(TIMESTAMPDIFF(MINUTE, view_time, purchase_time)),
        2
    ) AS avg_total_journey_minutes
FROM user_journey;
--- revenue funnel analysis
WITH revenue_funnel AS (
    SELECT COUNT(
            CASE
                WHEN event_type = 'page_view' THEN event_date
            END
        ) AS total_visitors,
        COUNT(
            DISTINCT CASE
                WHEN event_type = 'purchase' THEN user_id
            END
        ) AS total_buyers,
        COUNT(
            CASE
                WHEN event_type = 'purchase' THEN amount
            END
        ) AS total_orders,
        SUM(
            CASE
                WHEN event_type = 'purchase' THEN amount
                ELSE 0
            END
        ) AS total_revenue
    FROM user_events
    WHERE event_date >= DATE_SUB(NOW(), INTERVAL 30 DAY)
)
SELECT total_visitors,
    total_buyers,
    total_orders,
    total_revenue,
    total_revenue / total_orders as avg_order_value,
    total_revenue / total_buyers as revenue_per_buyer,
    total_revenue / total_visitors as revenue_per_visitor
FROM revenue_funnel;