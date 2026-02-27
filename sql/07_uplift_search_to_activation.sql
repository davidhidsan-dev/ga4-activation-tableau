-- Purpose: Estimate potential uplift in add_to_cart by improving search -> product view for searcher_only users

-- Note: What-if estimate (not causal).
-- Assumption: A fraction of searcher_only users will behave like product viewers after search improvements.
-- Viewer benchmark uses WEIGHTED activation rate across viewer segments.

WITH base AS (
  -- Reuse the segments + activation flags at user level (72h)
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
      MAX(CASE WHEN event_name = 'view_search_results' THEN 1 ELSE 0 END) AS search_72h,
      MAX(CASE WHEN event_name = 'view_item' THEN 1 ELSE 0 END) AS view_item_72h,
      MAX(CASE WHEN event_name = 'scroll' THEN 1 ELSE 0 END) AS scroll_72h,
      MAX(CASE WHEN event_name = 'begin_checkout' THEN 1 ELSE 0 END) AS begin_checkout_72h,
      MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS purchase_72h,
      MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS add_to_cart_72h
    FROM events_72h
    GROUP BY user_pseudo_id
  ),
  segments AS (
    SELECT
      user_pseudo_id,
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
  SELECT * FROM segments
),
rates AS (
  SELECT
    segment_72h,
    COUNT(*) AS users,
    SUM(add_to_cart_72h) AS activated_users,
    SAFE_DIVIDE(SUM(add_to_cart_72h), COUNT(*)) AS activation_rate
  FROM base
  WHERE segment_72h IN ('searcher_only_72h', 'product_viewer_scroll_72h', 'product_viewer_no_scroll_72h')
  GROUP BY segment_72h
),
pivot AS (
  SELECT
    MAX(IF(segment_72h='searcher_only_72h', users, NULL)) AS searcher_users,
    MAX(IF(segment_72h='searcher_only_72h', activation_rate, NULL)) AS searcher_activation_rate,

    -- weighted average activation rate across BOTH viewer segments
    SAFE_DIVIDE(
      SUM(IF(segment_72h IN ('product_viewer_scroll_72h','product_viewer_no_scroll_72h'), activated_users, 0)),
      SUM(IF(segment_72h IN ('product_viewer_scroll_72h','product_viewer_no_scroll_72h'), users, 0))
    ) AS viewer_activation_rate_weighted

  FROM rates
)
SELECT
  scenario_move_to_viewer_pct,
  searcher_users,
  searcher_activation_rate,
  viewer_activation_rate_weighted,
  (viewer_activation_rate_weighted - searcher_activation_rate) AS rate_diff,
  ROUND(searcher_users * scenario_move_to_viewer_pct * (viewer_activation_rate_weighted - searcher_activation_rate)) AS expected_extra_add_to_cart
FROM pivot,
UNNEST([0.05, 0.10, 0.20]) AS scenario_move_to_viewer_pct
ORDER BY scenario_move_to_viewer_pct;