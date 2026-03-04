-- ES
-- Propósito: Estimación “what-if” (no causal) del uplift en add_to_cart si parte de usuarios cambia de
--           product_viewer_no_scroll_72h -> product_viewer_scroll_72h.
-- Alcance: usuarios con first_date >= 2020-11-25 (ver docs/data_notes.md).
-- Ventana (v1): aproximación por día calendario con event_date (D0–D3 desde first_date).
-- Método: uplift = moved_users * (scroll_rate - no_scroll_rate), con moved_users = no_scroll_users * scenario_shift_pct.
-- Output: scenario_shift_pct, no_scroll_users, no_scroll_rate, scroll_rate, rate_diff, expected_extra_add_to_cart.
-- Nota: priorización descriptiva; requiere experimento (A/B) para causalidad.

-- EN
-- Purpose: Non-causal “what-if” uplift estimate in add_to_cart if a share of users shifts
--          from product_viewer_no_scroll_72h -> product_viewer_scroll_72h.
-- Scope: users with first_date >= 2020-11-25 (see docs/data_notes.md).
-- Window (v1): calendar-day approximation using event_date (D0–D3 from first_date).
-- Method: uplift = moved_users * (scroll_rate - no_scroll_rate), where moved_users = no_scroll_users * scenario_shift_pct.
-- Output: scenario_shift_pct, no_scroll_users, no_scroll_rate, scroll_rate, rate_diff, expected_extra_add_to_cart.
-- Note: descriptive prioritization; requires A/B test to confirm causality.

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
    MAX(CASE WHEN event_name = 'view_item' THEN 1 ELSE 0 END) AS view_item_72h,
    MAX(CASE WHEN event_name = 'scroll' THEN 1 ELSE 0 END) AS scroll_72h,
    MAX(CASE WHEN event_name = 'begin_checkout' THEN 1 ELSE 0 END) AS begin_checkout_72h,
    MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS purchase_72h,
    MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS add_to_cart_72h
  FROM events_72h
  GROUP BY user_pseudo_id
),
seg AS (
  SELECT
    user_pseudo_id,
    add_to_cart_72h,
    CASE
      WHEN purchase_72h = 1 THEN 'buyer_72h'
      WHEN begin_checkout_72h = 1 THEN 'checkout_intent_72h'
      WHEN view_item_72h = 1 AND scroll_72h = 1 THEN 'product_viewer_scroll_72h'
      WHEN view_item_72h = 1 AND scroll_72h = 0 THEN 'product_viewer_no_scroll_72h'
      ELSE 'other'
    END AS segment_72h
  FROM user_features
),
rates AS (
  SELECT
    segment_72h,
    COUNT(*) AS users,
    SAFE_DIVIDE(SUM(add_to_cart_72h), COUNT(*)) AS activation_rate
  FROM seg
  WHERE segment_72h IN ('product_viewer_scroll_72h', 'product_viewer_no_scroll_72h')
  GROUP BY segment_72h
),
pivot AS (
  SELECT
    MAX(IF(segment_72h='product_viewer_no_scroll_72h', users, NULL)) AS no_scroll_users,
    MAX(IF(segment_72h='product_viewer_no_scroll_72h', activation_rate, NULL)) AS no_scroll_rate,
    MAX(IF(segment_72h='product_viewer_scroll_72h', activation_rate, NULL)) AS scroll_rate
  FROM rates
)
SELECT
  scenario_shift_pct,
  no_scroll_users,
  no_scroll_rate,
  scroll_rate,
  (scroll_rate - no_scroll_rate) AS rate_diff,
  ROUND(no_scroll_users * scenario_shift_pct * (scroll_rate - no_scroll_rate)) AS expected_extra_add_to_cart
FROM pivot,
UNNEST([0.05, 0.10, 0.20]) AS scenario_shift_pct
ORDER BY scenario_shift_pct;