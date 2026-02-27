WITH first_seen AS (
  SELECT 
    user_pseudo_id,
    MIN(PARSE_DATE("%Y%m%d", event_date)) AS first_date
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  GROUP BY user_pseudo_id
),
events_72h AS (
  SELECT
    e.user_pseudo_id,
    f.first_date,
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
    first_date,
    MAX(CASE WHEN event_name = "add_to_cart" THEN 1 ELSE 0 END) AS activated_add_to_cart_72h
  FROM events_72h
  GROUP BY user_pseudo_id, first_date
)
SELECT
  first_date,
  COUNT(*) AS users_total,
  SUM(activated_add_to_cart_72h) AS users_activated_72h,
  SAFE_DIVIDE(SUM(activated_add_to_cart_72h), COUNT(*)) AS activation_rate_72h
FROM user_activation
GROUP BY first_date
ORDER BY first_date;