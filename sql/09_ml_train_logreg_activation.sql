-- ES
-- Propósito: Entrenar un modelo baseline (regresión logística) para predecir add_to_cart_72h.
-- Objeto: CREATE OR REPLACE MODEL ga4-retention-segmentation.analytics.model_activation_72h_logreg_v1
-- Datos de entrenamiento: ga4-retention-segmentation.analytics.ml_activation_training_v1 (ver sql/08).
-- Label: add_to_cart_72h (binaria).
-- Features: search_72h, view_item_72h, scroll_72h, begin_checkout_72h, purchase_72h, sessions_72h, view_item_events_72h.
-- Split: RANDOM con 20% para evaluación (data_split_eval_fraction = 0.2).
-- Output: modelo BQML (usar ML.EVALUATE / ML.PREDICT).
-- Nota: usado para ranking/propensión (no deployment productivo).

-- EN
-- Purpose: Train a baseline model (logistic regression) to predict add_to_cart_72h.
-- Object: CREATE OR REPLACE MODEL ga4-retention-segmentation.analytics.model_activation_72h_logreg_v1
-- Training data: ga4-retention-segmentation.analytics.ml_activation_training_v1 (see sql/08).
-- Label: add_to_cart_72h (binary).
-- Features: search_72h, view_item_72h, scroll_72h, begin_checkout_72h, purchase_72h, sessions_72h, view_item_events_72h.
-- Split: RANDOM with 20% evaluation fraction (data_split_eval_fraction = 0.2).
-- Output: BigQuery ML model (use ML.EVALUATE / ML.PREDICT).
-- Note: used for propensity ranking (not production deployment).

CREATE OR REPLACE MODEL `ga4-retention-segmentation.analytics.model_activation_72h_logreg_v1`
OPTIONS(
  model_type = 'logistic_reg',
  input_label_cols = ['add_to_cart_72h'],
  data_split_method = 'RANDOM',
  data_split_eval_fraction = 0.2
) AS
SELECT
  search_72h,
  view_item_72h,
  scroll_72h,
  begin_checkout_72h,
  purchase_72h,
  sessions_72h,
  view_item_events_72h,
  add_to_cart_72h
FROM `ga4-retention-segmentation.analytics.ml_activation_training_v1`;