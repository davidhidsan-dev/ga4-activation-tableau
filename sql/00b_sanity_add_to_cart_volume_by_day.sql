-- ES
-- Propósito: Sanity check del dataset para explicar por qué algunas cohortes (first_date) tienen activación ~0.
-- Qué hace: cuenta el volumen diario de eventos add_to_cart por event_date (día calendario).
-- Uso: detectar días con volumen 0 o muy bajo de add_to_cart (posibles “no-opportunity days”).
-- Output: event_date, add_to_cart_events.

-- EN
-- Purpose: Dataset sanity check to explain why some first_date cohorts show ~0 activation.
-- What it does: counts daily add_to_cart event volume by event_date (calendar day).
-- Use: detect days with zero / very low add_to_cart volume (“no-opportunity days”).
-- Output: event_date, add_to_cart_events.

SELECT
  PARSE_DATE('%Y%m%d', event_date) AS event_date,
  COUNT(*) AS add_to_cart_events
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE event_name = 'add_to_cart'
GROUP BY event_date
ORDER BY event_date;