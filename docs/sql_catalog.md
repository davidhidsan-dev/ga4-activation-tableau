# SQL Catalog / Catálogo de SQL

## ES — Qué hay en /sql

Este documento describe cada query y su objetivo.  
Dataset fuente: `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`.

**Filtro de alcance (importante):**  
La mayoría de análisis aplican `first_date >= 2020-11-25` (ver `docs/data_notes.md`) para evitar cohortes con “cero oportunidad” de activar (días con volumen casi nulo de `add_to_cart`).

**Ventana temprana (v1):**  
Se usa una aproximación por día calendario (`event_date`): **D0–D3** desde `first_date`.

**Grano (nivel) por defecto:**
- Activación temprana (`add_to_cart_early`): **usuario** (cada usuario cuenta 1 vez).
- Search → Product View: **sesión** (mide eficiencia de búsqueda por visita).  
  Hay dos variantes:
  - **early**: sesiones dentro de D0–D3
  - **global**: todas las sesiones del usuario en scope (no limitado a D0–D3)

---

## EN — What’s in /sql

This document describes each query and its purpose.  
Source dataset: `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`.

**Scope filter (important):**  
Most analyses apply `first_date >= 2020-11-25` (see `docs/data_notes.md`) to avoid “no-opportunity” cohorts (days with near-zero `add_to_cart` volume).

**Early window (v1):**  
Calendar-day approximation using `event_date`: **D0–D3** from `first_date`.

**Default grain (level):**
- Early activation (`add_to_cart_early`): **user-level** (each user counted once).
- Search → Product View: **session-level** (search efficiency per visit).  
  Two variants:
  - **early**: sessions within D0–D3
  - **global**: all sessions from scoped users (not restricted to D0–D3)

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

## 00b_sanity_add_to_cart_volume_by_day.sql

### ES

* **Qué hace:** cuenta el volumen diario de eventos `add_to_cart` por `event_date`.
* **Para qué sirve:** detectar días con volumen **cero o muy bajo** de `add_to_cart` (días “sin oportunidad”), que pueden distorsionar la activación por cohorte (`first_date`).
* **Output:** tabla con:

  * `event_date`
  * `add_to_cart_events`

### EN

* **What it does:** counts daily `add_to_cart` event volume by `event_date`.
* **Why it matters:** identifies days with **zero or very low** `add_to_cart` volume (“no-opportunity days”), which can distort activation-by-cohort (`first_date`) analysis.
* **Output:** table with:

  * `event_date`
  * `add_to_cart_events`

---

## 01_activation_add_to_cart_early.sql

### ES
* **Qué hace:** calcula el KPI global de activación en ventana temprana (D0–D3).
* **Definición de activación:** usuario activa si hace `add_to_cart` dentro de la ventana temprana.
* **Grano:** usuario (1 fila agregada final).
* **Output:**
  * `users_total`
  * `users_activated_early`
  * `activation_rate_early`

### EN
* **What it does:** computes the global early-window activation KPI (D0–D3).
* **Activation definition:** a user activates if they trigger `add_to_cart` within the early window.
* **Grain:** user (final aggregated output is a single row).
* **Output:**
  * `users_total`
  * `users_activated_early`
  * `activation_rate_early`

---

## 02_activation_add_to_cart_early_by_cohort.sql

### ES
* **Qué hace:** activación temprana por cohorte de adquisición (`first_date`).
* **Uso:** ver si hay días “raros” (picos/ceros) y entender estabilidad temporal del KPI.
* **Output:** 1 fila por `first_date` con:
  * `users_total`
  * `users_activated_early`
  * `activation_rate_early`

### EN
* **What it does:** early-window activation by acquisition cohort (`first_date`).
* **Use case:** detect odd days (spikes/zeros) and check KPI stability over time.
* **Output:** 1 row per `first_date` with:
  * `users_total`
  * `users_activated_early`
  * `activation_rate_early`

---

## 03_activation_rate_by_segment_early.sql

### ES
* **Qué hace:** crea segmentos tempranos (dentro de D0–D3) basados en comportamiento, y calcula activación por segmento.
* **Nota importante:** los segmentos NO usan `add_to_cart` para definirse (evita “explicar” la métrica con sí misma).
* **Output:** por `segment_early`:
  * `users_total`
  * `users_activated_early`
  * `activation_rate_early`

### EN
* **What it does:** builds early behavior segments (within D0–D3) and computes activation rate by segment.
* **Important note:** segments are NOT defined using `add_to_cart` (avoids “self-explaining” the target metric).
* **Output:** per `segment_early`:
  * `users_total`
  * `users_activated_early`
  * `activation_rate_early`

---

## 04_uplift_scroll_to_activation_early.sql

### ES
* **Qué hace:** estimación “what-if” (no causal) del impacto en `add_to_cart` si parte de usuarios cambia de:
  * `product_viewer_no_scroll` → `product_viewer_scroll`
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
  * `product_viewer_no_scroll` → `product_viewer_scroll`
* **Idea:** scroll users activate more; estimate uplift if X% behaves like scroll users.
* **Output:** scenarios table (e.g., 5%, 10%, 20%) with:
  * `scenario_shift_pct`
  * `no_scroll_users`
  * `no_scroll_rate`
  * `scroll_rate`
  * `rate_diff`
  * `expected_extra_add_to_cart`

---

## 05_search_to_product_view_rate_session_early.sql

### ES
* **Qué hace:** calcula el rate global de Search → Product View **por sesión** dentro de la ventana temprana (D0–D3).
* **Definición:** entre sesiones con `view_search_results`, % que también tienen `view_item`.
* **Grano:** sesión (`user_pseudo_id` + `ga_session_id`).
* **Output:**
  * `sessions_with_search`
  * `sessions_search_and_view_item`
  * `search_to_view_item_rate`

### EN
* **What it does:** computes global session-level Search → Product View rate within the early window (D0–D3).
* **Definition:** among sessions with `view_search_results`, % that also include `view_item`.
* **Grain:** session (`user_pseudo_id` + `ga_session_id`).
* **Output:**
  * `sessions_with_search`
  * `sessions_search_and_view_item`
  * `search_to_view_item_rate`

---

## 05b_search_to_product_view_rate_session_global.sql

### ES
* **Qué hace:** calcula el rate global de Search → Product View **por sesión** para usuarios en scope (NO limitado a D0–D3).
* **Cuándo usarlo:** como proxy más estable de “calidad de búsqueda” al aprovechar más sesiones.
* **Grano:** sesión (`user_pseudo_id` + `ga_session_id`).
* **Output:**
  * `sessions_with_search`
  * `sessions_search_and_view_item`
  * `search_to_view_item_rate`

### EN
* **What it does:** computes global session-level Search → Product View rate for scoped users (NOT restricted to D0–D3).
* **When to use:** as a more stable “search quality” proxy by leveraging more sessions.
* **Grain:** session (`user_pseudo_id` + `ga_session_id`).
* **Output:**
  * `sessions_with_search`
  * `sessions_search_and_view_item`
  * `search_to_view_item_rate`

---

## 06_search_to_product_view_rate_by_segment_session_early.sql

### ES
* **Qué hace:** Search → Product View rate **por sesión** desglosado por segmento temprano, usando solo sesiones en D0–D3.
* **Etiquetado:** cada sesión hereda el `segment_early` del usuario.
* **Output:** por `segment_early`:
  * `sessions_with_search`
  * `sessions_search_and_view_item`
  * `search_to_view_item_rate`

### EN
* **What it does:** session-level Search → Product View rate broken down by early segment, using only sessions in D0–D3.
* **Labeling:** each session inherits the user’s `segment_early`.
* **Output:** per `segment_early`:
  * `sessions_with_search`
  * `sessions_search_and_view_item`
  * `search_to_view_item_rate`

---

## 06b_search_to_product_view_rate_by_segment_session_global.sql

### ES
* **Qué hace:** Search → Product View rate **por sesión** por segmento temprano, usando **todas las sesiones** de usuarios en scope (NO limitado a D0–D3).
* **Importante:** el segmento se define con eventos de D0–D3, pero el rate Search → View se calcula con sesiones globales del usuario.
* **Uso:** detectar segmentos “atascados” en la búsqueda con más señal/estabilidad.
* **Output:** por `segment_early`:
  * `sessions_with_search`
  * `sessions_search_and_view_item`
  * `search_to_view_item_rate`

### EN
* **What it does:** session-level Search → Product View rate by early segment, using **all sessions** from scoped users (NOT restricted to D0–D3).
* **Important:** segments are derived from D0–D3 behavior, but the Search → View rate is computed using global sessions.
* **Use case:** detect segments stuck at search with more signal/stability.
* **Output:** per `segment_early`:
  * `sessions_with_search`
  * `sessions_search_and_view_item`
  * `search_to_view_item_rate`

---

## 07_uplift_search_to_activation_early.sql

### ES
* **Qué hace:** estimación “what-if” (no causal) del impacto en `add_to_cart` si parte de usuarios:
  * `searcher_only` pasa a comportarse como “viewer” (benchmark ponderado de viewers).
* **Output:** escenarios con:
  * `scenario_move_to_viewer_pct`
  * `searcher_users`
  * `searcher_activation_rate`
  * `viewer_activation_rate_weighted`
  * `rate_diff`
  * `expected_extra_add_to_cart`

### EN
* **What it does:** non-causal “what-if” estimate of extra `add_to_cart` if a share of:
  * `searcher_only` users behaves like “viewers” (weighted viewer benchmark).
* **Output:** scenarios with:
  * `scenario_move_to_viewer_pct`
  * `searcher_users`
  * `searcher_activation_rate`
  * `viewer_activation_rate_weighted`
  * `rate_diff`
  * `expected_extra_add_to_cart`

---

## 08_ml_activation_training_view_early.sql

### ES
* **Qué hace:** crea la vista de entrenamiento para ML con señales tempranas (D0–D3) y label de activación.
* **Output:** VIEW `ml_activation_training_v1`.

### EN
* **What it does:** creates the ML training view using early-window (D0–D3) features and the activation label.
* **Output:** VIEW `ml_activation_training_v1`.

---

## 09_ml_train_logreg_activation_early.sql

### ES
* **Qué hace:** entrena un modelo baseline (regresión logística) en BigQuery ML para predecir `add_to_cart` en ventana temprana.
* **Output:** MODEL `model_activation_..._v1` + métricas de evaluación (AUC, log_loss, etc.).

### EN
* **What it does:** trains a baseline BigQuery ML logistic regression model to predict early-window `add_to_cart`.
* **Output:** MODEL + evaluation metrics (AUC, log_loss, etc.).

---

## 10_quality_post_window_retention_by_activation.sql

### ES
* **Qué hace:** “quality check”: compara retención post-ventana (D4–D30) entre:
  * activados vs no activados en ventana temprana.
* **Por qué:** validar que la activación temprana se asocia con usuarios de mayor calidad (sin solaparse con D0–D3).
* **Output:** tasa de retención post-ventana por grupo.

### EN
* **What it does:** quality check: compares post-window retention (D4–D30) between:
  * activated vs non-activated users in the early window.
* **Why:** validate early activation correlates with higher-quality users (without overlapping D0–D3).
* **Output:** post-window retention rate by group.

---

## 11_tableau_user_summary_view.sql

### ES
* **Qué hace:** crea una VIEW “BI-ready” a nivel usuario para Tableau.
* **Incluye:** `user_pseudo_id`, `first_date`, `segment_early`, flags early, métricas y KPIs (activación + retención post-ventana).
* **Output:** view exportable a CSV (Tableau Public puede requerir split).

### EN
* **What it does:** builds a BI-ready user-level view for Tableau.
* **Includes:** `user_pseudo_id`, `first_date`, `segment_early`, early flags/features, and KPIs (activation + post-window retention).
* **Output:** view exportable to CSV (Tableau Public may require splitting).

---

## 12_funnel_search_early_users_seq.sql

### ES
* **Qué hace:** funnel secuencial por usuario desde Search → View item → Add to cart → Begin checkout → Purchase dentro de D0–D3.
* **Importante:** es **por usuario** (usuarios únicos), no por sesión.
* **Output:** tabla con:
  * `step_order`
  * `step_name`
  * `users`

### EN
* **What it does:** sequential user funnel from Search → View item → Add to cart → Begin checkout → Purchase within D0–D3.
* **Important:** **user-level** (unique users), not session-level.
* **Output:** table with:
  * `step_order`
  * `step_name`
  * `users`

---

## 13_tableau_propensity_deciles.sql

### ES
* **Qué hace:** puntúa usuarios con el modelo de propensión y los agrupa en **deciles** (1=baja, 10=alta) según `p_activate`.
* **Importante:** resumen **agregado** para validar ranking/calibración (no es causal).
* **Output:** tabla con:
  * `propensity_decile`
  * `users`
  * `avg_predicted_prob`
  * `actual_activation_rate`

### EN
* **What it does:** scores users with the propensity model and bins them into **deciles** (1=low, 10=high) based on `p_activate`.
* **Important:** aggregated summary to check ranking/calibration (non-causal).
* **Output:** table with:
  * `propensity_decile`
  * `users`
  * `avg_predicted_prob`
  * `actual_activation_rate`

---

## 14_activation_split_d0_vs_d1_d3.sql

### ES
* **Qué hace:** descompone activación en:
  * **D0** (mismo día que `first_date`)
  * **D1–D3** (días posteriores dentro de la ventana temprana)
* **Uso:** entender si la activación sucede mayoritariamente en primera visita vs retorno temprano.
* **Output:**
  * `users_total`
  * `users_activated_d0`, `activation_rate_d0`
  * `users_activated_d1_d3`, `activation_rate_d1_d3`
  * `users_activated_d0_d3`, `activation_rate_d0_d3`

### EN
* **What it does:** splits activation into:
  * **D0** (same day as `first_date`)
  * **D1–D3** (later days within the early window)
* **Use case:** understand whether activation happens mostly on first visit vs early return.
* **Output:**
  * `users_total`
  * `users_activated_d0`, `activation_rate_d0`
  * `users_activated_d1_d3`, `activation_rate_d1_d3`
  * `users_activated_d0_d3`, `activation_rate_d0_d3`

---

## 15_pdp_scroll_vs_activation_early.sql

### ES
* **Qué hace:** compara activación según comportamiento en PDP dentro de D0–D3:
  * `viewer_scroll` vs `viewer_no_scroll` vs `non_viewer`
* **Output:**
  * `pdp_scroll_group`
  * `users`
  * `activated_users`
  * `activation_rate`

### EN
* **What it does:** compares activation by PDP behavior within D0–D3:
  * `viewer_scroll` vs `viewer_no_scroll` vs `non_viewer`
* **Output:**
  * `pdp_scroll_group`
  * `users`
  * `activated_users`
  * `activation_rate`