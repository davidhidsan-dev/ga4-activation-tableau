-- ES
-- Propósito: Descomponer la activación temprana en D0 vs D1–D3 para entender si el add_to_cart ocurre el mismo día de first_date o en días posteriores dentro de la ventana temprana.
-- Alcance: usuarios con first_date >= 2020-11-25 (ver docs/data_notes.md).
-- Ventana (v1): aproximación por día calendario usando event_date (D0–D3 desde first_date).
-- Grano: usuario (1 fila por user_pseudo_id con flags por sub-ventana).
-- Output: users_total, users_activated_d0, activation_rate_d0, users_activated_d1_d3, activation_rate_d1_d3, users_activated_d0_d3, activation_rate_d0_d3.

-- EN
-- Purpose: Split early activation into D0 vs D1–D3 to understand whether add_to_cart happens on the same day as first_date or on later days within the early window.
-- Scope: users with first_date >= 2020-11-25 (see docs/data_notes.md).
-- Window (v1): calendar-day approximation using event_date (D0–D3 from first_date).
-- Grain: user-level (one row per user_pseudo_id with sub-window flags).
-- Output: users_total, users_activated_d0, activation_rate_d0, users_activated_d1_d3, activation_rate_d1_d3, users_activated_d0_d3, activation_rate_d0_d3.

WITH first_seen AS (
  SELECT
    user_pseudo_id,
    MIN(PARSE_DATE('%Y%m%d', event_date)) AS first_date
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  GROUP BY user_pseudo_id
  HAVING first_date >= DATE '2020-11-25'
),

add_to_cart_days AS (
  SELECT
    e.user_pseudo_id,
    f.first_date,
    PARSE_DATE('%Y%m%d', e.event_date) AS event_dt
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` e
  JOIN first_seen f
    ON f.user_pseudo_id = e.user_pseudo_id
  WHERE e.event_name = 'add_to_cart'
    AND PARSE_DATE('%Y%m%d', e.event_date)
        BETWEEN f.first_date AND DATE_ADD(f.first_date, INTERVAL 3 DAY)
),

user_activation AS (
  SELECT
    f.user_pseudo_id,

    -- D0 only
    MAX(CASE
          WHEN a.event_dt = f.first_date THEN 1 ELSE 0
        END) AS activated_d0,

    -- D1–D3 (excludes D0)
    MAX(CASE
          WHEN a.event_dt BETWEEN DATE_ADD(f.first_date, INTERVAL 1 DAY)
                             AND DATE_ADD(f.first_date, INTERVAL 3 DAY)
          THEN 1 ELSE 0
        END) AS activated_d1_d3,

    -- D0–D3 (full early window)
    MAX(CASE
          WHEN a.event_dt BETWEEN f.first_date
                             AND DATE_ADD(f.first_date, INTERVAL 3 DAY)
          THEN 1 ELSE 0
        END) AS activated_d0_d3

  FROM first_seen f
  LEFT JOIN add_to_cart_days a
    ON a.user_pseudo_id = f.user_pseudo_id
  GROUP BY f.user_pseudo_id
)

SELECT
  COUNT(*) AS users_total,

  SUM(activated_d0) AS users_activated_d0,
  SAFE_DIVIDE(SUM(activated_d0), COUNT(*)) AS activation_rate_d0,

  SUM(activated_d1_d3) AS users_activated_d1_d3,
  SAFE_DIVIDE(SUM(activated_d1_d3), COUNT(*)) AS activation_rate_d1_d3,

  SUM(activated_d0_d3) AS users_activated_d0_d3,
  SAFE_DIVIDE(SUM(activated_d0_d3), COUNT(*)) AS activation_rate_d0_d3
FROM user_activation;