-- ES
-- Propósito: Comparar activación (add_to_cart) según comportamiento en PDP:
--            viewer + scroll vs viewer sin scroll vs no viewer.
-- Alcance: usuarios con first_date >= 2020-11-25 (ver docs/data_notes.md).
-- Ventana temprana (v1): aproximación por día calendario con event_date (D0–D3 desde first_date).
-- Grano: usuario (flags 0/1 por usuario dentro de la ventana).
-- Output: pdp_scroll_group, users, activated_users, activation_rate.

-- EN
-- Purpose: Compare activation (add_to_cart) by PDP behavior:
--          viewer + scroll vs viewer no scroll vs non-viewer.
-- Scope: users with first_date >= 2020-11-25 (see docs/data_notes.md).
-- Early window (v1): calendar-day approximation using event_date (D0–D3 from first_date).
-- Grain: user-level (0/1 flags per user within the window).
-- Output: pdp_scroll_group, users, activated_users, activation_rate.

WITH first_seen AS (
  SELECT
    user_pseudo_id,
    MIN(PARSE_DATE('%Y%m%d', event_date)) AS first_date
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
  WHERE PARSE_DATE('%Y%m%d', e.event_date)
        BETWEEN f.first_date AND DATE_ADD(f.first_date, INTERVAL 3 DAY)
),

user_flags AS (
  SELECT
    user_pseudo_id,
    MAX(CASE WHEN event_name = 'view_item'   THEN 1 ELSE 0 END) AS view_item_early,
    MAX(CASE WHEN event_name = 'scroll'      THEN 1 ELSE 0 END) AS scroll_early,
    MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS add_to_cart_early
  FROM events_early
  GROUP BY user_pseudo_id
)

SELECT
  CASE
    WHEN view_item_early = 1 AND scroll_early = 1 THEN 'viewer_scroll'
    WHEN view_item_early = 1 AND scroll_early = 0 THEN 'viewer_no_scroll'
    ELSE 'non_viewer'
  END AS pdp_scroll_group,
  COUNT(*) AS users,
  SUM(add_to_cart_early) AS activated_users,
  SAFE_DIVIDE(SUM(add_to_cart_early), COUNT(*)) AS activation_rate
FROM user_flags
GROUP BY pdp_scroll_group
ORDER BY users DESC;