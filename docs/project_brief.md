# Project Brief / Resumen del Proyecto

## ES — Objetivo
Analizar el comportamiento temprano de usuarios en un ecommerce y ver qué señales se asocian con que algunos usuarios lleguen a intención de compra (proxy: `add_to_cart`) durante la ventana temprana.

## ES — Métricas
**Métrica principal**
- **Activación (ventana temprana) = Add to Cart**: % de usuarios que disparan `add_to_cart` dentro de la ventana **D0–D3** desde su primera actividad (`first_date`) (aproximación por día calendario).

**Métrica secundaria (calidad, sin solapamiento)**
- **Retención post-ventana (día 4–30)**: % de usuarios con actividad entre `first_date + 4` y `first_date + 30`.  
  *Nota:* se usa como proxy de “calidad” evitando solape con la ventana temprana (días 0–3).

**Métrica de diagnóstico (búsqueda)**
- **Search → Product View rate (session-level)**: % de **sesiones** con `view_search_results` que también incluyen `view_item` (usuarios en scope; no limitado a la ventana temprana).

**Preguntas a responder**
1) ¿Qué % de usuarios llega a `add_to_cart` en la ventana temprana (D0–D3)?
2) ¿Qué pasos previos (por ejemplo, búsqueda → ver producto) fallan y en qué tipos de usuarios?
3) ¿Qué segmentos tempranos (por comportamiento) muestran más probabilidad de llegar a carrito?
4) ¿Qué cambios de UX/merchandising podrían explorarse para mover esas métricas? *(no implica causalidad)*

**Datos**
- Fuente: `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` (GA4 sample ecommerce).
- Usuario: `user_pseudo_id`.
- Ventana temprana: `first_date` → `first_date + 3 days` (**D0–D3**, aproximación por día calendario).

**Entrega final**
- Dataset listo para Tableau.
- Dashboard con funnel y rendimiento por segmento.
- Recomendaciones basadas en lo observado en los datos.

---

## EN — Goal
Analyze early user behavior in an ecommerce dataset and see which signals are associated with users reaching purchase intent (proxy: `add_to_cart`) during the early window.

## EN — Metrics
**Primary metric**
- **Activation (early window) = Add to Cart**: % of users who trigger `add_to_cart` within the **D0–D3** window from `first_date` (calendar-day approximation).

**Secondary metric (quality, non-overlapping)**
- **Post-window retention (days 4–30)**: % of users with activity between `first_date + 4` and `first_date + 30`.  
  *Note:* used as a “quality” proxy without overlapping the early window (days 0–3).

**Diagnostic metric (search)**
- **Search → Product View rate (session-level)**: % of **sessions** with `view_search_results` that also include `view_item` (scoped users; not restricted to the early window).

**Questions to answer**
1) What % of users reaches `add_to_cart` within the early window (D0–D3)?
2) Which upstream steps (e.g., search → product view) fail, and for which user types?
3) Which early behavior segments are more likely to reach cart?
4) What UX/merchandising changes could be explored to move these metrics? *(non-causal)*

**Data**
- Source: `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` (GA4 sample ecommerce).
- User key: `user_pseudo_id`.
- Early window: `first_date` → `first_date + 3 days` (**D0–D3**, calendar-day approximation).

**Final deliverables**
- Tableau-ready dataset.
- Dashboard with funnel + segment performance.
- Recommendations grounded in observed data patterns.