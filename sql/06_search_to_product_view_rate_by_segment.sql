-- Purpose: Search -> Product View rate within sessions, broken down by early behavior segment
-- Scope: users with first_date >= 2020-11-25

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
    MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS purchase_72h
  FROM events_72h
  GROUP BY user_pseudo_id
),
segments AS (
  SELECT
    user_pseudo_id,
    CASE
      WHEN purchase_72h = 1 THEN 'buyer_72h'
      WHEN begin_checkout_72h = 1 THEN 'checkout_intent_72h'
      WHEN view_item_72h = 1 AND scroll_72h = 1 THEN 'product_viewer_scroll_72h'
      WHEN view_item_72h = 1 AND scroll_72h = 0 THEN 'product_viewer_no_scroll_72h'
      WHEN search_72h = 1 AND view_item_72h = 0 THEN 'searcher_only_72h'
      ELSE 'low_engagement_72h'
    END AS segment_72h
  FROM user_features
),
events_scoped AS (
  SELECT
    e.user_pseudo_id,
    (SELECT ep.value.int_value
     FROM UNNEST(e.event_params) ep
     WHERE ep.key = 'ga_session_id') AS ga_session_id,
    e.event_name
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` e
  JOIN first_seen f
    ON f.user_pseudo_id = e.user_pseudo_id
  WHERE e.event_name IN ('view_search_results', 'view_item')
),
session_flags AS (
  SELECT
    user_pseudo_id,
    ga_session_id,
    MAX(CASE WHEN event_name = 'view_search_results' THEN 1 ELSE 0 END) AS has_search,
    MAX(CASE WHEN event_name = 'view_item' THEN 1 ELSE 0 END) AS has_view_item
  FROM events_scoped
  WHERE ga_session_id IS NOT NULL
  GROUP BY user_pseudo_id, ga_session_id
),
session_with_segment AS (
  SELECT
    s.segment_72h,
    sf.has_search,
    sf.has_view_item
  FROM session_flags sf
  JOIN segments s
    ON sf.user_pseudo_id = s.user_pseudo_id
)
SELECT
  segment_72h,
  COUNTIF(has_search = 1) AS sessions_with_search,
  COUNTIF(has_search = 1 AND has_view_item = 1) AS sessions_search_and_view_item,
  SAFE_DIVIDE(
    COUNTIF(has_search = 1 AND has_view_item = 1),
    COUNTIF(has_search = 1)
  ) AS search_to_view_item_rate
FROM session_with_segment
GROUP BY segment_72h
ORDER BY sessions_with_search DESC;