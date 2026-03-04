-- ES
-- Propósito: Construir la vista de entrenamiento ML para predecir activación 72h (add_to_cart_72h) con señales tempranas.
-- Objeto: CREATE OR REPLACE VIEW ga4-retention-segmentation.analytics.ml_activation_training_v1
-- Alcance: usuarios con first_date >= 2020-11-25 (ver docs/data_notes.md).
-- Ventana (v1): aproximación por día calendario con event_date (D0–D3 desde first_date).
-- Features:
--   - Flags: search_72h, view_item_72h, scroll_72h, begin_checkout_72h, purchase_72h
--   - Conteos: sessions_72h (distinct ga_session_id), view_item_events_72h
-- Label: add_to_cart_72h (1 si hay add_to_cart en la ventana)
-- Grano: 1 fila por usuario (user_pseudo_id) con first_date.
-- Output: columnas de features + label para BQML.
-- Nota: baseline sin leakage fuera de la ventana temprana.

-- EN
-- Purpose: Build ML training view to predict 72h activation (add_to_cart_72h) from early behavior signals.
-- Object: CREATE OR REPLACE VIEW ga4-retention-segmentation.analytics.ml_activation_training_v1
-- Scope: users with first_date >= 2020-11-25 (see docs/data_notes.md).
-- Window (v1): calendar-day approximation using event_date (D0–D3 from first_date).
-- Features:
--   - Flags: search_72h, view_item_72h, scroll_72h, begin_checkout_72h, purchase_72h
--   - Counts: sessions_72h (distinct ga_session_id), view_item_events_72h
-- Label: add_to_cart_72h (1 if add_to_cart occurs within the window)
-- Grain: one row per user (user_pseudo_id) with first_date.
-- Output: feature columns + label for BigQuery ML.
-- Note: baseline dataset with no leakage beyond the early window.

CREATE OR REPLACE VIEW `ga4-retention-segmentation.analytics.ml_activation_training_v1` AS
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

    -- simple features (flags)
    MAX(CASE WHEN event_name = 'view_search_results' THEN 1 ELSE 0 END) AS search_72h,
    MAX(CASE WHEN event_name = 'view_item' THEN 1 ELSE 0 END) AS view_item_72h,
    MAX(CASE WHEN event_name = 'scroll' THEN 1 ELSE 0 END) AS scroll_72h,
    MAX(CASE WHEN event_name = 'begin_checkout' THEN 1 ELSE 0 END) AS begin_checkout_72h,
    MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS purchase_72h,

    -- light count features
    COUNT(DISTINCT ga_session_id) AS sessions_72h,
    SUM(CASE WHEN event_name = 'view_item' THEN 1 ELSE 0 END) AS view_item_events_72h,

    -- label
    MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS add_to_cart_72h
  FROM events_72h
  GROUP BY user_pseudo_id, first_date
)
SELECT
  user_pseudo_id,
  first_date,
  search_72h,
  view_item_72h,
  scroll_72h,
  begin_checkout_72h,
  purchase_72h,
  sessions_72h,
  view_item_events_72h,
  add_to_cart_72h
FROM user_features;