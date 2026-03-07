-- ES
-- Propósito: Calcular el KPI principal: activación temprana D0–D3
--            (usuarios con add_to_cart dentro de la ventana temprana).
-- Alcance: usuarios con first_date >= 2020-11-25 (ver docs/data_notes.md).
-- Ventana (v1): aproximación por día calendario con event_date (D0–D3 desde first_date).
-- Grano: usuario (1 fila agregada final).
-- Output: users_total, users_activated_early, activation_rate_early.

-- EN
-- Purpose: Compute the primary KPI: early activation D0–D3
--          (users with add_to_cart within the early window).
-- Scope: users with first_date >= 2020-11-25 (see docs/data_notes.md).
-- Window (v1): calendar-day approximation using event_date (D0–D3 from first_date).
-- Grain: user-level (final output is a single aggregated row).
-- Output: users_total, users_activated_early, activation_rate_early.

WITH first_seen AS (
  SELECT
    user_pseudo_id,
    MIN(PARSE_DATE("%Y%m%d", event_date)) AS first_date
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  GROUP BY user_pseudo_id
  HAVING first_date >= DATE '2020-11-25'
),
events_early AS (
  SELECT
    e.user_pseudo_id,
    e.event_name
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` e
  JOIN first_seen f
    ON f.user_pseudo_id = e.user_pseudo_id
  WHERE PARSE_DATE("%Y%m%d", e.event_date)
        BETWEEN f.first_date AND DATE_ADD(f.first_date, INTERVAL 3 DAY)
),
user_activation AS (
  SELECT
    user_pseudo_id,
    MAX(CASE WHEN event_name = "add_to_cart" THEN 1 ELSE 0 END) AS activated_add_to_cart_early
  FROM events_early
  GROUP BY user_pseudo_id
)
SELECT
  COUNT(*) AS users_total,
  SUM(activated_add_to_cart_early) AS users_activated_early,
  SAFE_DIVIDE(SUM(activated_add_to_cart_early), COUNT(*)) AS activation_rate_early
FROM user_activation;