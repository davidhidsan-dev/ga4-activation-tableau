-- ES
-- Propósito: Calcular Search -> Product View rate a nivel sesión (proxy de calidad de búsqueda).
-- Alcance: sesiones de usuarios con first_date >= 2020-11-25 (ver docs/data_notes.md).
-- Definición: entre sesiones con view_search_results, % que también tienen al menos un view_item.
-- Grano: sesión (user_pseudo_id + ga_session_id), usando flags por sesión.
-- Output: sessions_with_search, sessions_search_and_view_item, search_to_view_item_rate.
-- Nota: métrica por sesión a propósito (mide eficiencia dentro de una visita).

-- EN
-- Purpose: Compute session-level Search -> Product View rate (proxy for search quality).
-- Scope: sessions from users with first_date >= 2020-11-25 (see docs/data_notes.md).
-- Definition: among sessions with view_search_results, % that also include at least one view_item.
-- Grain: session (user_pseudo_id + ga_session_id), using boolean flags per session.
-- Output: sessions_with_search, sessions_search_and_view_item, search_to_view_item_rate.
-- Note: session-level on purpose (measures efficiency within a visit).

WITH first_seen AS (
  SELECT
    user_pseudo_id,
    MIN(PARSE_DATE('%Y%m%d', event_date)) AS first_date
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  GROUP BY user_pseudo_id
  HAVING first_date >= DATE '2020-11-25'
),
events_scoped AS (
  SELECT
    e.user_pseudo_id,
    (SELECT ep.value.int_value
     FROM UNNEST(e.event_params) ep
     WHERE ep.key = 'ga_session_id') AS ga_session_id,
    e.event_name
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` e
  JOIN first_seen f
    ON f.user_pseudo_id = e.user_pseudo_id
  WHERE e.event_name IN ('view_search_results', 'view_item')
),
session_flags AS (
  SELECT
    user_pseudo_id,
    ga_session_id,
    MAX(CASE WHEN event_name = 'view_search_results' THEN 1 ELSE 0 END) AS has_search,
    MAX(CASE WHEN event_name = 'view_item' THEN 1 ELSE 0 END) AS has_view_item
  FROM events_scoped
  WHERE ga_session_id IS NOT NULL
  GROUP BY user_pseudo_id, ga_session_id
)
SELECT
  COUNTIF(has_search = 1) AS sessions_with_search,
  COUNTIF(has_search = 1 AND has_view_item = 1) AS sessions_search_and_view_item,
  SAFE_DIVIDE(
    COUNTIF(has_search = 1 AND has_view_item = 1),
    COUNTIF(has_search = 1)
  ) AS search_to_view_item_rate
FROM session_flags;