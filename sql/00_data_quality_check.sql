-- ES
-- Propósito: Validación básica de calidad de datos antes de KPIs/segmentación.
-- Dataset: bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*
-- Qué revisa: recuento de filas, nulos en claves principales y fallos al parsear event_date.
-- Output: 1 fila con rows_total, null_user_pseudo_id, null_event_date, null_event_name, event_date_parse_fail.

-- EN
-- Purpose: Basic data quality checks before KPI/segmentation work.
-- Dataset: bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*
-- Checks: row count, nulls on key fields, and event_date parsing failures.
-- Output: 1 row with rows_total, null_user_pseudo_id, null_event_date, null_event_name, event_date_parse_fail.

SELECT
  COUNT(*) AS rows_total,
  COUNTIF(user_pseudo_id IS NULL) AS null_user_pseudo_id,
  COUNTIF(event_date IS NULL) AS null_event_date,
  COUNTIF(event_name IS NULL) AS null_event_name,
  COUNTIF(SAFE.PARSE_DATE('%Y%m%d', event_date) IS NULL) AS event_date_parse_fail
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;