# Limitations & Next Steps / Limitaciones y Siguientes Pasos

## ES — Limitaciones

- **Ventana temprana basada en fecha:** se usa `event_date` (día calendario), no un corte exacto por horas.  
  En este proyecto, la ventana temprana se define como **D0–D3** desde `first_date`.
- **Dataset sample/obfuscado:** no representa 1:1 un ecommerce real; es un dataset público pensado para práctica/metodología.
- **What-if no causal:** los escenarios de uplift son descriptivos; para atribuir efecto habría que validar con experimentos (A/B tests).
- **Tableau Public:** sin conexión directa a BigQuery y con límites de export; por eso se usan CSVs en partes.

## ES — Siguientes pasos (si fuera un caso “empresa”)

1) **Funnel secuencial a nivel sesión con timestamps**
- Replicar el funnel, pero restringiendo a **una misma sesión** (`ga_session_id`) y usando `event_timestamp` para validar ordering real (search → view_item → add_to_cart).

2) **Análisis por canal y dispositivo**
- Añadir dimensiones como `source/medium` y `device` para ver si el drop Search → View item o la activación cambian por segmento de adquisición.

3) **Instrumentación / eventos intermedios**
- Incluir eventos como `add_shipping_info` y `add_payment_info` para medir fricción en checkout con más detalle.

4) **Experimentación**
- Definir hipótesis y tests (mejoras de búsqueda, módulos de recomendación, cambios en PDP, performance), y medir impacto con métricas definidas.

5) **Modelo de propensión más rico**
- Probar más features (recuentos de eventos, variedad de interacción, señales de engagement) y una validación más estricta (p. ej., por tiempo/cohortes).

---

## EN — Limitations

- **Early window is date-based:** uses `event_date` (calendar days), not an exact hour-based cutoff.  
  Here, the early window is defined as **D0–D3** from `first_date`.
- **Obfuscated/sample dataset:** not a 1:1 representation of a real business; it’s a public dataset meant for learning/methodology.
- **Non-causal what-if:** uplift scenarios are descriptive; causality would require experiments (A/B tests).
- **Tableau Public constraints:** no direct BigQuery connection and export limits, so CSV splits are used.

## EN — Next steps (if this were an “enterprise” case)

1) **Timestamp-based sequential funnel at session level**
- Rebuild the funnel restricted to a **single session** (`ga_session_id`) and use `event_timestamp` to validate true ordering (search → view_item → add_to_cart).

2) **Channel/device analysis**
- Add dimensions like `source/medium` and `device` to see whether the Search → View item drop or activation changes by acquisition/device segments.

3) **Instrumentation / intermediate checkout events**
- Include steps such as `add_shipping_info` and `add_payment_info` to diagnose checkout friction with finer granularity.

4) **Experimentation**
- Define hypotheses and tests (search, recommendations, PDP changes, performance) and measure impact with the defined metrics.

5) **Richer propensity modeling**
- Add more features (event counts, interaction variety, engagement signals) and use stricter validation (e.g., time-based splits/cohorts).