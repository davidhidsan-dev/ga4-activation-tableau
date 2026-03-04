-- ES
-- Propósito: Calcular activación 72h por segmento de comportamiento temprano (sin definiciones circulares).
-- Alcance: usuarios con first_date >= 2020-11-25 (ver docs/data_notes.md).
-- Ventana (v1): aproximación por día calendario con event_date (D0–D3 desde first_date).
-- Segmentación: reglas por prioridad (buyer > checkout > viewer_scroll > viewer_no_scroll > searcher_only > low_engagement).
-- Grano: usuario (1 fila por usuario) agregada a segmento.
-- Output: segment_72h, users_total, users_activated_72h, activation_rate_72h.

-- EN
-- Purpose: Compute 72h activation by early behavior segment (no circular segment definitions).
-- Scope: users with first_date >= 2020-11-25 (see docs/data_notes.md).
-- Window (v1): calendar-day approximation using event_date (D0–D3 from first_date).
-- Segmentation: priority-based rules (buyer > checkout > viewer_scroll > viewer_no_scroll > searcher_only > low_engagement).
-- Grain: user-level (one row per user) aggregated to segment.
-- Output: segment_72h, users_total, users_activated_72h, activation_rate_72h.

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