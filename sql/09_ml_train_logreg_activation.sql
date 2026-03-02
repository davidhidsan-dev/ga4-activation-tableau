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