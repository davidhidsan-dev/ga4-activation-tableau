# Limitations & Next Steps / Limitaciones y Siguientes Pasos

## ES — Limitaciones

* **Ventana temprana aproximada por fecha:** se usa `event_date` (día calendario), no timestamp exacto.  
  La ventana temprana se define como **D0–D3** desde `first_date`.
* **Dataset sample/obfuscado:** no representa 1:1 un ecommerce real, pero sirve para practicar metodología y diseño de análisis.
* **What-if no causal:** los escenarios de uplift son descriptivos; validar con experimentos (A/B tests).
* **Tableau Public:** limita conexión directa a BigQuery y tamaño de exports (se usan CSVs en partes).

## ES — Siguientes pasos (si fuera una empresa)

1. **Embudo secuencial por sesión con timestamps**
   - Validar ordering real (search → view_item → add_to_cart) usando `event_timestamp` y `ga_session_id` (funnel session-level).

2. **Análisis por canal y dispositivo**
   - Añadir dimensiones (source/medium, device) para ver diferencias en Search → View item y en activación.

3. **Instrumentación / eventos intermedios**
   - Incorporar pasos como `add_shipping_info` y `add_payment_info` para entender fricción en checkout y drop-offs más finos.

4. **Experimentación**
   - Definir hipótesis y diseñar tests (mejoras de búsqueda, módulos de recomendación, layout/CTA en PDP, performance).

5. **Modelo de propensión más rico**
   - Incluir más features (recuentos de eventos, diversidad de categorías, engagement) y mejorar calibración/validación.

---

## EN — Limitations

* **Early window is date-based:** uses `event_date` (calendar days), not exact timestamps.  
  The early window is defined as **D0–D3** from `first_date`.
* **Obfuscated/sample dataset:** not a 1:1 representation of a real business, but suitable for learning methodology and analysis design.
* **Non-causal what-if:** uplift scenarios are descriptive; validate via experiments (A/B tests).
* **Tableau Public constraints:** no direct BigQuery connection and export row limits (CSV splits used).

## EN — Next steps (enterprise-ready)

1. **Sequential session-level funnel using timestamps**
   - Validate true ordering (search → view_item → add_to_cart) with `event_timestamp` and `ga_session_id` (session-level funnel).

2. **Channel/device analysis**
   - Add dimensions (source/medium, device) to check differences in Search → View item and activation.

3. **Instrumentation / intermediate checkout events**
   - Include steps such as `add_shipping_info` and `add_payment_info` to diagnose checkout friction with finer drop-offs.

4. **Experimentation**
   - Define hypotheses and run tests (search improvements, recommendation modules, PDP layout/CTA, performance).

5. **Richer propensity modeling**
   - Add more features (event counts, category diversity, engagement signals) and improve calibration/validation.