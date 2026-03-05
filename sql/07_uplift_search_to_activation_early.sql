-- ES
-- Propósito: Estimación “what-if” (no causal) del uplift en add_to_cart si mejoras Search -> Product View
--           para el segmento searcher_only_early.
-- Alcance: usuarios con first_date >= 2020-11-25 (ver docs/data_notes.md).
-- Ventana (v1): ventana temprana aproximada por día calendario con event_date (D0–D3 desde first_date).
-- Supuesto: una fracción de searcher_only_early pasa a comportarse como “viewer” tras mejorar búsqueda.
-- Benchmark: tasa viewer ponderada entre product_viewer_scroll_early y product_viewer_no_scroll_early.
-- Método: uplift = moved_users * (viewer_rate - searcher_rate),
--         moved_users = searcher_users * scenario_move_to_viewer_pct.
-- Output: scenario_move_to_viewer_pct, searcher_users, searcher_activation_rate, viewer_activation_rate_weighted,
--         rate_diff, expected_extra_add_to_cart.
-- Nota: priorización descriptiva; validar con experimento (A/B).

-- EN
-- Purpose: Non-causal “what-if” uplift estimate in add_to_cart by improving Search -> Product View
--          for the searcher_only_early segment.
-- Scope: users with first_date >= 2020-11-25 (see docs/data_notes.md).
-- Window (v1): early window approximated using calendar-day event_date (D0–D3 from first_date).
-- Assumption: a fraction of searcher_only_early users transitions to “viewer-like” behavior after search improvements.
-- Benchmark: weighted viewer activation rate across viewer segments (scroll + no_scroll).
-- Method: uplift = moved_users * (viewer_rate - searcher_rate),
--         moved_users = searcher_users * scenario_move_to_viewer_pct.
-- Output: scenario_move_to_viewer_pct, searcher_users, searcher_activation_rate, viewer_activation_rate_weighted,
--         rate_diff, expected_extra_add_to_cart.
-- Note: descriptive prioritization; validate via experiment (A/B test).

WITH base AS (
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
      MAX(CASE WHEN event_name = 'view_search_results' THEN 1 ELSE 0 END) AS search_early,
      MAX(CASE WHEN event_name = 'view_item' THEN 1 ELSE 0 END) AS view_item_early,
      MAX(CASE WHEN event_name = 'scroll' THEN 1 ELSE 0 END) AS scroll_early,
      MAX(CASE WHEN event_name = 'begin_checkout' THEN 1 ELSE 0 END) AS begin_checkout_early,
      MAX(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS purchase_early,
      MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS add_to_cart_early
    FROM events_early
    GROUP BY user_pseudo_id
  ),
  segments AS (
    SELECT
      user_pseudo_id,
      add_to_cart_early,
      CASE
        WHEN purchase_early = 1 THEN 'buyer_early'
        WHEN begin_checkout_early = 1 THEN 'checkout_intent_early'
        WHEN view_item_early = 1 AND scroll_early = 1 THEN 'product_viewer_scroll_early'
        WHEN view_item_early = 1 AND scroll_early = 0 THEN 'product_viewer_no_scroll_early'
        WHEN search_early = 1 AND view_item_early = 0 THEN 'searcher_only_early'
        ELSE 'low_engagement_early'
      END AS segment_early
    FROM user_features
  )
  SELECT * FROM segments
),
rates AS (
  SELECT
    segment_early,
    COUNT(*) AS users,
    SUM(add_to_cart_early) AS activated_users,
    SAFE_DIVIDE(SUM(add_to_cart_early), COUNT(*)) AS activation_rate
  FROM base
  WHERE segment_early IN ('searcher_only_early', 'product_viewer_scroll_early', 'product_viewer_no_scroll_early')
  GROUP BY segment_early
),
pivot AS (
  SELECT
    MAX(IF(segment_early='searcher_only_early', users, NULL)) AS searcher_users,
    MAX(IF(segment_early='searcher_only_early', activation_rate, NULL)) AS searcher_activation_rate,

    -- weighted average activation rate across BOTH viewer segments
    SAFE_DIVIDE(
      SUM(IF(segment_early IN ('product_viewer_scroll_early','product_viewer_no_scroll_early'), activated_users, 0)),
      SUM(IF(segment_early IN ('product_viewer_scroll_early','product_viewer_no_scroll_early'), users, 0))
    ) AS viewer_activation_rate_weighted

  FROM rates
)
SELECT
  scenario_move_to_viewer_pct,
  searcher_users,
  searcher_activation_rate,
  viewer_activation_rate_weighted,
  (viewer_activation_rate_weighted - searcher_activation_rate) AS rate_diff,
  ROUND(searcher_users * scenario_move_to_viewer_pct * (viewer_activation_rate_weighted - searcher_activation_rate)) AS expected_extra_add_to_cart
FROM pivot,
UNNEST([0.05, 0.10, 0.20]) AS scenario_move_to_viewer_pct
ORDER BY scenario_move_to_viewer_pct;