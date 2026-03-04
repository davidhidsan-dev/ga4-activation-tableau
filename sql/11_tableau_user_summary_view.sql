-- ES
-- Propósito: Vista BI-ready a nivel usuario para Tableau (1 fila por usuario) con comportamiento temprano + segmento + calidad.
-- Objeto: CREATE OR REPLACE VIEW ga4-retention-segmentation.analytics.tableau_user_summary_v1
-- Alcance: usuarios con first_date >= 2020-11-25 (ver docs/data_notes.md).
-- Ventanas (v1):
--   - Ventana temprana (“72h”): D0–D3 por aproximación de día calendario con event_date.
--   - Calidad (sin solape): retención post-72h en D4–D30 desde first_date.
-- Incluye:
--   - user_pseudo_id, first_date, segment_72h
--   - flags 72h y conteos ligeros
--   - retained_post72h_d30
-- Grano: 1 fila por user_pseudo_id.
-- Output: pensada para export a CSV (Tableau Public puede requerir splits).

-- EN
-- Purpose: BI-ready user-level view for Tableau (one row per user) combining early behavior, segment, and quality metric.
-- Object: CREATE OR REPLACE VIEW ga4-retention-segmentation.analytics.tableau_user_summary_v1
-- Scope: users with first_date >= 2020-11-25 (see docs/data_notes.md).
-- Windows (v1):
--   - Early window (“72h”): D0–D3 calendar-day approximation using event_date.
--   - Quality (non-overlapping): post-72h retention flag in D4–D30 from first_date.
-- Includes:
--   - user_pseudo_id, first_date, segment_72h
--   - 72h flags and light counts
--   - retained_post72h_d30
-- Grain: one row per user_pseudo_id.
-- Output: designed for CSV export (Tableau Public may require splitting).

CREATE OR REPLACE VIEW `ga4-retention-segmentation.analytics.tableau_user_summary_v1` AS
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
    e.event_name,
    (SELECT ep.value.int_value
     FROM UNNEST(e.event_params) ep
     WHERE ep.key = 'ga_session_id') AS ga_session_id
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

    -- flags
    MAX(CASE WHEN event_name = 'view_search_results' THEN 1 ELSE 0 END) AS search_72h,
    MAX(CASE WHEN event_name = 'view_item' THEN 1 ELSE 0 END) AS view_item_72h,
    MAX(CASE WHEN event_name = 'scroll' THEN 1 ELSE 0 END) AS scroll_72h,
    MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS add_to_cart_72h,
    MAX(CASE WHEN event_name = 'begin_checkout' THEN 1 ELSE 0 END) AS begin_checkout_72h,
    MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS purchase_72h,

    -- light counts
    COUNT(DISTINCT ga_session_id) AS sessions_72h,
    SUM(CASE WHEN event_name = 'view_item' THEN 1 ELSE 0 END) AS view_item_events_72h
  FROM events_72h
  GROUP BY user_pseudo_id, first_date
),
segments AS (
  SELECT
    *,
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
activity_by_day AS (
  SELECT DISTINCT
    user_pseudo_id,
    PARSE_DATE('%Y%m%d', event_date) AS activity_date
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
),
post72h_retention AS (
  SELECT
    s.user_pseudo_id,
    MAX(CASE
      WHEN a.activity_date BETWEEN DATE_ADD(s.first_date, INTERVAL 4 DAY)
                              AND DATE_ADD(s.first_date, INTERVAL 30 DAY)
      THEN 1 ELSE 0 END) AS retained_post72h_d30
  FROM segments s
  LEFT JOIN activity_by_day a
    ON a.user_pseudo_id = s.user_pseudo_id
  GROUP BY s.user_pseudo_id
)
SELECT
  s.user_pseudo_id,
  s.first_date,
  s.segment_72h,

  s.search_72h,
  s.view_item_72h,
  s.scroll_72h,
  s.add_to_cart_72h,
  s.begin_checkout_72h,
  s.purchase_72h,

  s.sessions_72h,
  s.view_item_events_72h,

  r.retained_post72h_d30
FROM segments s
JOIN post72h_retention r
  ON s.user_pseudo_id = r.user_pseudo_id;