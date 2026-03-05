-- ES
-- Propósito: Entrenar un modelo baseline (regresión logística) para predecir activación temprana (add_to_cart_early).
-- Objeto: CREATE OR REPLACE MODEL ga4-retention-segmentation.analytics.model_activation_early_logreg_v1
-- Datos de entrenamiento: ga4-retention-segmentation.analytics.ml_activation_training_early_v1 (ver sql/08).
-- Label: add_to_cart_early (binaria).
-- Features: search_early, view_item_early, scroll_early, begin_checkout_early, purchase_early, sessions_early, view_item_events_early.
-- Split: RANDOM con 20% para evaluación (data_split_eval_fraction = 0.2).
-- Output: modelo BQML (usar ML.EVALUATE / ML.PREDICT).
-- Nota: usado para ranking/propensión (no deployment productivo).

-- EN
-- Purpose: Train a baseline model (logistic regression) to predict early activation (add_to_cart_early).
-- Object: CREATE OR REPLACE MODEL ga4-retention-segmentation.analytics.model_activation_early_logreg_v1
-- Training data: ga4-retention-segmentation.analytics.ml_activation_training_early_v1 (see sql/08).
-- Label: add_to_cart_early (binary).
-- Features: search_early, view_item_early, scroll_early, begin_checkout_early, purchase_early, sessions_early, view_item_events_early.
-- Split: RANDOM with 20% evaluation fraction (data_split_eval_fraction = 0.2).
-- Output: BigQuery ML model (use ML.EVALUATE / ML.PREDICT).
-- Note: used for propensity ranking (not production deployment).

CREATE OR REPLACE MODEL `ga4-retention-segmentation.analytics.model_activation_early_logreg_v1`
OPTIONS(
  model_type = 'logistic_reg',
  input_label_cols = ['add_to_cart_early'],
  data_split_method = 'RANDOM',
  data_split_eval_fraction = 0.2
) AS
SELECT
  search_early,
  view_item_early,
  scroll_early,
  begin_checkout_early,
  purchase_early,
  sessions_early,
  view_item_events_early,
  add_to_cart_early
FROM `ga4-retention-segmentation.analytics.ml_activation_training_early_v1`;