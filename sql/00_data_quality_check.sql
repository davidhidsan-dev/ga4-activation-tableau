SELECT
  COUNT(*) AS rows_total,
  COUNTIF(user_pseudo_id IS NULL) AS null_user_pseudo_id,
  COUNTIF(event_date IS NULL) AS null_event_date,
  COUNTIF(event_name IS NULL) AS null_event_name,
  COUNTIF(SAFE.PARSE_DATE('%Y%m%d', event_date) IS NULL) AS event_date_parse_fail
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE PARSE_DATE('%Y%m%d', event_date) BETWEEN DATE '2020-11-25' AND DATE '2021-01-31';