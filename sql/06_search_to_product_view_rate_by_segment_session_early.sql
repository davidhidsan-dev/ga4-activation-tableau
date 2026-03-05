-- ES
-- Propósito: Search -> Product View rate por segmento temprano, restringido a sesiones dentro de D0–D3.
-- Alcance: usuarios con first_date >= 2020-11-25 (ver docs/data_notes.md).
-- Segmentación (v1): se calcula con eventos en D0–D3 (aprox por día calendario con event_date).
-- Métrica de búsqueda: grano sesión (user_pseudo_id + ga_session_id) usando SOLO eventos en D0–D3.
-- Output: segment_early, sessions_with_search, sessions_search_and_view_item, search_to_view_item_rate.

-- EN
-- Purpose: Session-level Search -> Product View rate by early segment, restricted to sessions within D0–D3.
-- Scope: users with first_date >= 2020-11-25 (see docs/data_notes.md).
-- Segmentation (v1): computed using events in D0–D3 (calendar-day approximation via event_date).
-- Search metric: session grain (user_pseudo_id + ga_session_id) using ONLY events in D0–D3.
-- Output: segment_early, sessions_with_search, sessions_search_and_view_item, search_to_view_item_rate.

WITH first_seen AS (
  SELECT
    user_pseudo_id,
    MIN(PARSE_DATE('%Y%m%d', event_date)) AS first_date
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  GROUP BY user_pseudo_id
  HAVING first_date >= DATE '2020-11-25'
),

-- Early-window events (D0–D3) for BOTH segmentation and session metric
events_early AS (
  SELECT
    e.user_pseudo_id,
    f.first_date,
    e.event_name,
    (SELECT ep.value.int_value
     FROM UNNEST(e.event_params) ep
     WHERE ep.key = 'ga_session_id') AS ga_session_id
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` e
  JOIN first_seen f
    ON f.user_pseudo_id = e.user_pseudo_id
  WHERE PARSE_DATE('%Y%m%d', e.event_date)
        BETWEEN f.first_date AND DATE_ADD(f.first_date, INTERVAL 3 DAY)
    AND e.event_name IN ('view_search_results', 'view_item', 'scroll', 'begin_checkout', 'purchase')
),

-- Segmentation from early-window behavior
user_features_early AS (
  SELECT
    user_pseudo_id,
    MAX(CASE WHEN event_name = 'view_search_results' THEN 1 ELSE 0 END) AS has_search_early,
    MAX(CASE WHEN event_name = 'view_item' THEN 1 ELSE 0 END) AS has_view_item_early,
    MAX(CASE WHEN event_name = 'scroll' THEN 1 ELSE 0 END) AS has_scroll_early,
    MAX(CASE WHEN event_name = 'begin_checkout' THEN 1 ELSE 0 END) AS has_begin_checkout_early,
    MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS has_purchase_early
  FROM events_early
  GROUP BY user_pseudo_id
),

segments AS (
  SELECT
    user_pseudo_id,
    CASE
      WHEN has_purchase_early = 1 THEN 'buyer_early'
      WHEN has_begin_checkout_early = 1 THEN 'checkout_intent_early'
      WHEN has_view_item_early = 1 AND has_scroll_early = 1 THEN 'product_viewer_scroll_early'
      WHEN has_view_item_early = 1 AND has_scroll_early = 0 THEN 'product_viewer_no_scroll_early'
      WHEN has_search_early = 1 AND has_view_item_early = 0 THEN 'searcher_only_early'
      ELSE 'low_engagement_early'
    END AS segment_early
  FROM user_features_early
),

-- Session flags restricted to early-window sessions (D0–D3)
session_flags_early AS (
  SELECT
    user_pseudo_id,
    ga_session_id,
    MAX(CASE WHEN event_name = 'view_search_results' THEN 1 ELSE 0 END) AS has_search,
    MAX(CASE WHEN event_name = 'view_item' THEN 1 ELSE 0 END) AS has_view_item
  FROM events_early
  WHERE ga_session_id IS NOT NULL
    AND event_name IN ('view_search_results', 'view_item')
  GROUP BY user_pseudo_id, ga_session_id
),

session_with_segment AS (
  SELECT
    s.segment_early,
    sf.has_search,
    sf.has_view_item
  FROM session_flags_early sf
  JOIN segments s
    ON sf.user_pseudo_id = s.user_pseudo_id
)

SELECT
  segment_early,
  COUNTIF(has_search = 1) AS sessions_with_search,
  COUNTIF(has_search = 1 AND has_view_item = 1) AS sessions_search_and_view_item,
  SAFE_DIVIDE(
    COUNTIF(has_search = 1 AND has_view_item = 1),
    COUNTIF(has_search = 1)
  ) AS search_to_view_item_rate
FROM session_with_segment
GROUP BY segment_early
ORDER BY sessions_with_search DESC;