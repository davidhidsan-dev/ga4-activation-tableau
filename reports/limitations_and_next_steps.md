# Limitations & Next Steps / Limitaciones y Siguientes Pasos

## ES — Limitaciones

* **Ventana 72h aproximada por fecha:** se usa `event_date` (día calendario), no timestamp exacto.
* **Dataset sample/obfuscado:** no representa 1:1 un ecommerce real, pero sirve para metodología.
* **What-if no causal:** los escenarios de uplift son descriptivos; validar con A/B tests.
* **Tableau Public:** limita conexión directa a BigQuery y tamaño de exports (se usan CSVs en partes).

## ES — Siguientes pasos (si fuera una empresa)

1. **Embudo estrictamente secuencial por sesión + timestamp**

* Validar ordering real (search → view_item → add_to_cart) con timestamps y `ga_session_id`.

2. **Análisis por canal/dispositivo**

* Añadir dimensiones (source/medium, device) y ver diferencias en Search → View.

3. **Experimentación**

* Definir hipótesis y diseñar tests (p.ej. mejoras de búsqueda, módulos de recomendación, layout PDP).

4. **Modelo de propensión más rico**

* Incluir más features (p.ej., recuentos de eventos, diversidad de categorías, señales de engagement) y calibración.

---

## EN — Limitations

* **72h window is date-based:** uses `event_date` (calendar days), not exact timestamps.
* **Obfuscated/sample dataset:** not a 1:1 representation of a real business, but suitable for methodology.
* **Non-causal what-if:** uplift scenarios are descriptive; validate via A/B tests.
* **Tableau Public constraints:** no direct BigQuery connection and export row limits (CSV splits used).

## EN — Next steps (enterprise-ready)

1. **Strict sequential session-level funnel using timestamps**

* Validate true ordering (search → view_item → add_to_cart) with timestamps and `ga_session_id`.

2. **Channel/device analysis**

* Add dimensions (source/medium, device) to check differences in Search → View.

3. **Experimentation**

* Define hypotheses and run tests (search improvements, recommendation modules, PDP layout).

4. **Richer propensity modeling**

* Add more features (event counts, category diversity, engagement signals) and improve calibration.
