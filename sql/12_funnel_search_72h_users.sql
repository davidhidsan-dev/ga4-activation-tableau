-- ES
-- Propósito: Funnel secuencial por usuario en la ventana temprana:
--           Search -> View item -> Add to cart -> Begin checkout -> Purchase.
-- Alcance: usuarios con first_date >= 2020-11-25 (ver docs/data_notes.md).
-- Ventana (v1): aproximación por día calendario con event_date (D0–D3 desde first_date).
-- Método:
--   - Para cada usuario, obtener el PRIMER event_timestamp de cada paso dentro de la ventana.
--   - Contar usuarios que cumplen orden estricto (ts_search < ts_view_item < ...).
-- Grano: usuario (usuarios únicos).
-- Output: step_order, step_name, users.
-- Nota: cuenta “usuarios que alcanzan el paso en orden” (no sesiones, no recuento de eventos).

-- EN
-- Purpose: User-level sequential funnel within the early window:
--          Search -> View item -> Add to cart -> Begin checkout -> Purchase.
-- Scope: users with first_date >= 2020-11-25 (see docs/data_notes.md).
-- Window (v1): calendar-day approximation using event_date (D0–D3 from first_date).
-- Method:
--   - For each user, compute the FIRST event_timestamp for each step within the window.
--   - Count users that satisfy strict ordering constraints (ts_search < ts_view_item < ...).
-- Grain: user-level (unique users).
-- Output: step_order, step_name, users.

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
    e.event_name,
    e.event_timestamp,
    f.first_date,
    PARSE_DATE('%Y%m%d', e.event_date) AS event_dt
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` e
  JOIN first_seen f
    ON f.user_pseudo_id = e.user_pseudo_id
  WHERE PARSE_DATE('%Y%m%d', e.event_date)
    BETWEEN f.first_date AND DATE_ADD(f.first_date, INTERVAL 3 DAY)
),

first_event_ts AS (
  SELECT
    user_pseudo_id,

    -- first time (timestamp) each event happens in the 72h window
    MIN(IF(event_name = 'view_search_results', event_timestamp, NULL)) AS ts_search,
    MIN(IF(event_name = 'view_item',          event_timestamp, NULL)) AS ts_view_item,
    MIN(IF(event_name = 'add_to_cart',        event_timestamp, NULL)) AS ts_add_to_cart,
    MIN(IF(event_name = 'begin_checkout',     event_timestamp, NULL)) AS ts_begin_checkout,
    MIN(IF(event_name = 'purchase',           event_timestamp, NULL)) AS ts_purchase

  FROM events_72h
  GROUP BY user_pseudo_id
),

base AS (
  -- users who searched (starting point of the funnel)
  SELECT *
  FROM first_event_ts
  WHERE ts_search IS NOT NULL
)

SELECT 1 AS step_order, 'Search' AS step_name,
       COUNT(*) AS users
FROM base

UNION ALL
SELECT 2, 'View item',
       COUNT(*)
FROM base
WHERE ts_view_item IS NOT NULL
  AND ts_search < ts_view_item

UNION ALL
SELECT 3, 'Add to cart',
       COUNT(*)
FROM base
WHERE ts_add_to_cart IS NOT NULL
  AND ts_search < ts_view_item
  AND ts_view_item < ts_add_to_cart

UNION ALL
SELECT 4, 'Begin checkout',
       COUNT(*)
FROM base
WHERE ts_begin_checkout IS NOT NULL
  AND ts_search < ts_view_item
  AND ts_view_item < ts_add_to_cart
  AND ts_add_to_cart < ts_begin_checkout

UNION ALL
SELECT 5, 'Purchase',
       COUNT(*)
FROM base
WHERE ts_purchase IS NOT NULL
  AND ts_search < ts_view_item
  AND ts_view_item < ts_add_to_cart
  AND ts_add_to_cart < ts_begin_checkout
  AND ts_begin_checkout < ts_purchase

ORDER BY step_order;