-- Purpose: Activation (add_to_cart within 72h) by early behavior segment (no circular definitions)
-- Scope: users with first_date >= 2020-11-25
-- Dataset: bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*

WITH first_seen AS (
  SELECT
    user_pseudo_id,
    MIN(PARSE_DATE('%Y%m%d', event_date)) AS first_date
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  GROUP BY user_pseudo_id
  HAVING first_date >= DATE '2020-11-25'
),
events_72h AS (
  SELECT
    e.user_pseudo_id,
    f.first_date,
    e.event_name
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` e
  JOIN first_seen f
    ON f.user_pseudo_id = e.user_pseudo_id
  WHERE PARSE_DATE('%Y%m%d', e.event_date)
        BETWEEN f.first_date AND DATE_ADD(f.first_date, INTERVAL 3 DAY)
),
user_features AS (
  SELECT
    user_pseudo_id,
    first_date,

    -- early behavior flags (72h window)
    MAX(CASE WHEN event_name = 'view_search_results' THEN 1 ELSE 0 END) AS search_72h,
    MAX(CASE WHEN event_name = 'view_item' THEN 1 ELSE 0 END) AS view_item_72h,
    MAX(CASE WHEN event_name = 'begin_checkout' THEN 1 ELSE 0 END) AS begin_checkout_72h,
    MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS purchase_72h,
    MAX(CASE WHEN event_name = 'scroll' THEN 1 ELSE 0 END) AS scroll_72h,

    -- target metric (activation)
    MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS add_to_cart_72h

  FROM events_72h
  GROUP BY user_pseudo_id, first_date
),
segments AS (
  SELECT
    user_pseudo_id,
    first_date,
    add_to_cart_72h,
    CASE
      WHEN purchase_72h = 1 THEN 'buyer_72h'
      WHEN begin_checkout_72h = 1 THEN 'checkout_intent_72h'
      WHEN view_item_72h = 1 AND scroll_72h = 1 THEN 'product_viewer_scroll_72h'
      WHEN view_item_72h = 1 AND scroll_72h = 0 THEN 'product_viewer_no_scroll_72h'
      WHEN search_72h = 1 AND view_item_72h = 0 THEN 'searcher_only_72h'
      ELSE 'low_engagement_72h'
    END AS segment_72h
  FROM user_features
)
SELECT
  segment_72h,
  COUNT(*) AS users_total,
  SUM(add_to_cart_72h) AS users_activated_72h,
  SAFE_DIVIDE(SUM(add_to_cart_72h), COUNT(*)) AS activation_rate_72h
FROM segments
GROUP BY segment_72h
ORDER BY users_total DESC;