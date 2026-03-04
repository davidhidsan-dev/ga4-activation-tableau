# SQL Catalog / Catálogo de SQL

## ES — Qué hay en /sql

Este documento describe cada query y su objetivo.
Dataset fuente: `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`.

**Filtro de alcance (importante):**
La mayoría de análisis aplican `first_date >= 2020-11-25` (ver `docs/data_notes.md`) para evitar cohortes con “cero oportunidad” de activar (días con volumen casi nulo de `add_to_cart`).

**Grano (nivel) por defecto:**

* Activación (`add_to_cart_72h`): **usuario** (cada usuario cuenta 1 vez).
* Search → Product View: **sesión** (mide eficiencia de la búsqueda por visita).

---

## EN — What’s in /sql

This document describes each query and its purpose.
Source dataset: `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`.

**Scope filter (important):**
Most analyses apply `first_date >= 2020-11-25` (see `docs/data_notes.md`) to avoid “no-opportunity” cohorts (days with near-zero `add_to_cart` volume).

**Default grain (level):**

* Activation (`add_to_cart_72h`): **user-level** (each user counted once).
* Search → Product View: **session-level** (measures search efficiency per visit).

---

## 00_data_quality_check.sql

### ES

* **Qué hace:** sanity checks de calidad: nulos y parseo de fechas.
* **Por qué existe:** asegurar que `user_pseudo_id`, `event_name`, `event_date` están completos y bien formateados antes de calcular KPIs.
* **Output:** 1 fila con contadores de:

  * `rows_total`
  * `null_user_pseudo_id`
  * `null_event_date`
  * `null_event_name`
  * `event_date_parse_fail`

### EN

* **What it does:** basic data quality sanity checks: nulls and date parsing.
* **Why it exists:** ensure `user_pseudo_id`, `event_name`, `event_date` are present and parse correctly before computing KPIs.
* **Output:** 1 row with counts for:

  * `rows_total`
  * `null_user_pseudo_id`
  * `null_event_date`
  * `null_event_name`
  * `event_date_parse_fail`

---

## 01_activation_add_to_cart_72h.sql

### ES

* **Qué hace:** calcula el KPI global de activación en 72h.
* **Definición de activación:** usuario activa si hace `add_to_cart` dentro de la ventana 72h (aprox por día calendario) desde `first_date`.
* **Grano:** usuario (1 fila agregada final).
* **Output:**

  * `users_total`
  * `users_activated_72h`
  * `activation_rate_72h`

### EN

* **What it does:** computes the global 72h activation KPI.
* **Activation definition:** a user activates if they trigger `add_to_cart` within the 72h window (calendar-day approximation) from `first_date`.
* **Grain:** user (final aggregated output is a single row).
* **Output:**

  * `users_total`
  * `users_activated_72h`
  * `activation_rate_72h`

---

## 02_activation_add_to_cart_72h_by_cohort.sql

### ES

* **Qué hace:** activación 72h por cohorte de adquisición (`first_date`).
* **Uso:** ver si hay días “raros” (picos/ceros) y entender estabilidad temporal del KPI.
* **Output:** 1 fila por `first_date` con:

  * `users_total`
  * `users_activated_72h`
  * `activation_rate_72h`

### EN

* **What it does:** 72h activation by acquisition cohort (`first_date`).
* **Use case:** detect odd days (spikes/zeros) and check KPI stability over time.
* **Output:** 1 row per `first_date` with:

  * `users_total`
  * `users_activated_72h`
  * `activation_rate_72h`

---

## 03_activation_rate_by_segment_72h.sql

### ES

* **Qué hace:** crea segmentos tempranos (72h) basados en comportamiento, y calcula activación por segmento.
* **Nota importante:** los segmentos NO usan `add_to_cart` para definirse (evita “explicar” la métrica con sí misma).
* **Output:** por `segment_72h`:

  * `users_total`
  * `users_activated_72h`
  * `activation_rate_72h`

### EN

* **What it does:** builds early-behavior segments (72h) and computes activation rate by segment.
* **Important note:** segments are NOT defined using `add_to_cart` (avoids “self-explaining” the target metric).
* **Output:** per `segment_72h`:

  * `users_total`
  * `users_activated_72h`
  * `activation_rate_72h`

---

## 04_uplift_scroll_to_activation.sql

### ES

* **Qué hace:** estimación “what-if” (no causal) del impacto en `add_to_cart` si parte de usuarios cambia de:

  * `product_viewer_no_scroll_72h` → `product_viewer_scroll_72h`
* **Idea:** si la tasa de activación es mayor en “scroll”, ¿cuánto ganaríamos si movemos X%?
* **Output:** tabla por escenarios (p.ej. 5%, 10%, 20%) con:

  * `scenario_shift_pct`
  * `no_scroll_users`
  * `no_scroll_rate`
  * `scroll_rate`
  * `rate_diff`
  * `expected_extra_add_to_cart`

### EN

* **What it does:** non-causal “what-if” estimate of extra `add_to_cart` if we shift a share of users from:

  * `product_viewer_no_scroll_72h` → `product_viewer_scroll_72h`
* **Idea:** scroll users activate more; estimate uplift if X% behaves like scroll users.
* **Output:** scenarios table (e.g., 5%, 10%, 20%) with:

  * `scenario_shift_pct`
  * `no_scroll_users`
  * `no_scroll_rate`
  * `scroll_rate`
  * `rate_diff`
  * `expected_extra_add_to_cart`

---

## 05_search_to_product_view_rate.sql

### ES

* **Qué hace:** calcula el rate global de Search → Product View **por sesión** (72h).
* **Definición:** entre sesiones con `view_search_results`, % que también tienen `view_item`.
* **Output:**

  * `sessions_with_search`
  * `sessions_search_and_view_item`
  * `search_to_view_item_rate`

### EN

* **What it does:** computes global Search → Product View rate **per session** (72h).
* **Definition:** among sessions with `view_search_results`, % that also have `view_item`.
* **Output:**

  * `sessions_with_search`
  * `sessions_search_and_view_item`
  * `search_to_view_item_rate`

---

## 06_search_to_product_view_rate_by_segment.sql

### ES

* **Qué hace:** calcula Search → Product View rate por segmento.
* **Uso:** detectar segmentos “atascados” en la búsqueda (ej. `searcher_only_72h`).
* **Output:** por `segment_72h`:

  * `sessions_with_search`
  * `sessions_search_and_view_item`
  * `search_to_view_item_rate`

### EN

* **What it does:** computes Search → Product View rate by segment.
* **Use case:** detect segments stuck at search (e.g., `searcher_only_72h`).
* **Output:** per `segment_72h`:

  * `sessions_with_search`
  * `sessions_search_and_view_item`
  * `search_to_view_item_rate`

---

## 07_uplift_search_to_activation.sql

### ES

* **Qué hace:** estimación “what-if” (no causal) del impacto en `add_to_cart` si parte de usuarios:

  * `searcher_only_72h` pasa a comportarse como “viewer” (benchmark ponderado de viewers).
* **Output:** escenarios con:

  * `scenario_move_to_viewer_pct`
  * `searcher_users`
  * `searcher_activation_rate`
  * `viewer_activation_rate_weighted`
  * `rate_diff`
  * `expected_extra_add_to_cart`

### EN

* **What it does:** non-causal “what-if” estimate of extra `add_to_cart` if a share of:

  * `searcher_only_72h` users behaves like “viewers” (weighted viewer benchmark).
* **Output:** scenarios with:

  * `scenario_move_to_viewer_pct`
  * `searcher_users`
  * `searcher_activation_rate`
  * `viewer_activation_rate_weighted`
  * `rate_diff`
  * `expected_extra_add_to_cart`

---

## 08_ml_activation_training_view.sql

### ES

* **Qué hace:** crea el dataset de entrenamiento para ML:

  * features de comportamiento temprano (72h)
  * label = `add_to_cart_72h`
* **Output:** VIEW `ml_activation_training_v1`.

### EN

* **What it does:** creates the ML training dataset:

  * early behavior features (72h)
  * label = `add_to_cart_72h`
* **Output:** VIEW `ml_activation_training_v1`.

---

## 09_ml_train_logreg_activation.sql

### ES

* **Qué hace:** entrena un modelo de clasificación (regresión logística) en BigQuery ML para predecir `add_to_cart_72h`.
* **Output:** MODEL `model_activation_72h_logreg_v1` + métricas de evaluación (AUC, log_loss, etc.).

### EN

* **What it does:** trains a classification model (logistic regression) in BigQuery ML to predict `add_to_cart_72h`.
* **Output:** MODEL `model_activation_72h_logreg_v1` + evaluation metrics (AUC, log_loss, etc.).

---

## 10_quality_post72h_retention_by_activation.sql

### ES

* **Qué hace:** “quality check”: compara retención post-72h (D4–D30) entre:

  * activados (add_to_cart_72h=1) vs no activados.
* **Por qué:** validar que la activación temprana se asocia con usuarios de mayor calidad (sin solaparse con los primeros 3 días).
* **Output:** tasa de retención post-72h por grupo.

### EN

* **What it does:** “quality check”: compares post-72h retention (D4–D30) between:

  * activated (add_to_cart_72h=1) vs not activated.
* **Why:** validate that early activation correlates with higher-quality users (without overlapping the first 72h).
* **Output:** post-72h retention rate by group.

---

## 11_tableau_user_summary_view.sql

### ES

* **Qué hace:** crea una VIEW “BI-ready” a nivel usuario para Tableau.
* **Incluye:** `user_pseudo_id`, `first_date`, `segment_72h`, flags 72h, métricas y KPIs (activación y post-72h retention).
* **Output:** view exportable a CSV en partes para Tableau Public.

### EN

* **What it does:** builds a BI-ready, user-level view for Tableau.
* **Includes:** `user_pseudo_id`, `first_date`, `segment_72h`, 72h flags/features, and KPIs (activation + post-72h retention).
* **Output:** view exportable to CSV in parts for Tableau Public.

---

## 12_funnel_search_72h_users.sql

### ES

* **Qué hace:** funnel secuencial (usuarios) desde Search → View item → Add to cart → Begin checkout → Purchase.
* **Importante:** es **por usuario** (usuarios únicos), no por sesión.
* **Output:** tabla con:

  * `step_order`
  * `step_name`
  * `users`

### EN

* **What it does:** sequential funnel (users) from Search → View item → Add to cart → Begin checkout → Purchase.
* **Important:** **user-level** (unique users), not session-level.
* **Output:** table with:

  * `step_order`
  * `step_name`
  * `users`

---

## 13_tableau_propensity_deciles.sql

### ES

* **Qué hace:** puntúa usuarios con el modelo `model_activation_72h_logreg_v1` y los agrupa en **deciles de propensión** (1=baja, 10=alta) según `p_activate = P(add_to_cart_72h=1)`.
* **Importante:** es un resumen **agregado** para validar ranking/calibración (no es causal). Puede haber empates de probabilidad si hay pocos patrones de features.
* **Output:** tabla con:

  * `propensity_decile`
  * `users`
  * `avg_predicted_prob`
  * `actual_activation_rate`

### EN

* **What it does:** scores users using `model_activation_72h_logreg_v1` and bins them into **propensity deciles** (1=low, 10=high) based on `p_activate = P(add_to_cart_72h=1)`.
* **Important:** aggregated summary to check ranking/calibration (non-causal). Tied probabilities can happen if feature patterns are limited.
* **Output:** table with:

  * `propensity_decile`
  * `users`
  * `avg_predicted_prob`
  * `actual_activation_rate`