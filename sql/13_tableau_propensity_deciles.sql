-- ES
-- Propósito: crear tabla agregada por deciles de propensión (BigQuery ML)
-- Qué hace:
--   1) Puntúa usuarios con ML.PREDICT (logistic regression) para obtener p_activate = P(add_to_cart_72h=1)
--   2) Divide a los usuarios en 10 grupos (deciles) ordenados por p_activate (1=bajo, 10=alto)
--   3) Devuelve, por decil: #usuarios, prob. media predicha y tasa real de activación
-- Uso: exportar a CSV para Tableau y visualizar calibración/“lift” por decil.
-- Nota: puede haber muchas probabilidades repetidas (empates) por pocas combinaciones de features.

-- EN
-- Purpose: build a propensity-decile summary table (BigQuery ML)
-- What it does:
--   1) Scores users with ML.PREDICT to get p_activate = P(add_to_cart_72h=1)
--   2) Splits users into 10 groups (deciles) ordered by p_activate (1=low, 10=high)
--   3) Outputs, per decile: user count, avg predicted probability, and actual activation rate
-- Use: export to CSV for Tableau to visualize calibration / lift by decile.
-- Note: many tied probabilities can occur due to limited feature pattern variety.

CREATE OR REPLACE TABLE `ga4-retention-segmentation.analytics.tableau_propensity_deciles_v1` AS
WITH scored AS (
  SELECT
    user_pseudo_id,
    first_date,
    add_to_cart_72h,
    -- probabilidad predicha de clase 1 (add_to_cart_72h = 1)
    (SELECT prob
     FROM UNNEST(predicted_add_to_cart_72h_probs)
     WHERE label = 1) AS p_activate
  FROM ML.PREDICT(
    MODEL `ga4-retention-segmentation.analytics.model_activation_72h_logreg_v1`,
    (
      SELECT
        user_pseudo_id, first_date,
        search_72h, view_item_72h, scroll_72h,
        begin_checkout_72h, purchase_72h,
        sessions_72h, view_item_events_72h,
        add_to_cart_72h
      FROM `ga4-retention-segmentation.analytics.ml_activation_training_v1`
    )
  )
),
binned AS (
  SELECT
    *,
    NTILE(10) OVER (ORDER BY p_activate) AS propensity_decile
  FROM scored
)
SELECT
  propensity_decile,
  COUNT(*) AS users,
  AVG(p_activate) AS avg_predicted_prob,
  AVG(add_to_cart_72h) AS actual_activation_rate
FROM binned
GROUP BY propensity_decile
ORDER BY propensity_decile;