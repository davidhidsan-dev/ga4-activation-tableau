-- Purpose: Quality check: Post-72h retention (D4–D30) by 72h activation (add_to_cart)
-- Scope: users with first_date >= 2020-11-25

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
activation AS (
  SELECT
    user_pseudo_id,
    first_date,
    MAX(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS activated_72h
  FROM events_72h
  GROUP BY user_pseudo_id, first_date
),
activity_by_day AS (
  SELECT DISTINCT
    user_pseudo_id,
    PARSE_DATE('%Y%m%d', event_date) AS activity_date
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
),
post72h_retention AS (
  SELECT
    a.user_pseudo_id,
    a.activated_72h,
    MAX(CASE
      WHEN abd.activity_date BETWEEN DATE_ADD(a.first_date, INTERVAL 4 DAY)
                                AND DATE_ADD(a.first_date, INTERVAL 30 DAY)
      THEN 1 ELSE 0 END) AS retained_post72h_d30
  FROM activation a
  LEFT JOIN activity_by_day abd
    ON abd.user_pseudo_id = a.user_pseudo_id
  GROUP BY a.user_pseudo_id, a.activated_72h
)
SELECT
  activated_72h,
  COUNT(*) AS users,
  AVG(retained_post72h_d30) AS retention_post72h_rate
FROM post72h_retention
GROUP BY activated_72h
ORDER BY activated_72h DESC;