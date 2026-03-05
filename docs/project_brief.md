# Project Brief / Resumen del Proyecto

## ES — Objetivo
Analizar el comportamiento temprano de usuarios en un ecommerce y detectar qué acciones explican por qué algunos usuarios avanzan hacia intención de compra.

## ES — Métricas
**Métrica principal (éxito):**
- **Activación (ventana temprana) = Add to Cart**: porcentaje de usuarios que realizan `add_to_cart` dentro de la ventana temprana **D0–D3** desde su primera actividad (`first_date`) (aproximación por día calendario).

**Métrica secundaria (calidad, sin solapamiento):**
- **Retención post-ventana (día 4–30)**: porcentaje de usuarios con actividad entre `first_date + 4` y `first_date + 30`.  
  *Nota:* se usa para evaluar “calidad” sin mezclar el retorno inmediato (días 1–3) con la ventana temprana.

**Métrica de diagnóstico (búsqueda):**
- **Search → Product View rate (session-level)**: porcentaje de **sesiones** con `view_search_results` que también incluyen `view_item` (usuarios en scope; no limitado a la ventana temprana).

**Preguntas que queremos responder:**
1) ¿Qué % de usuarios llega a `add_to_cart` en la ventana temprana (D0–D3)?
2) ¿Qué pasos previos (por ejemplo búsqueda → ver producto) están fallando y para qué tipo de usuarios?
3) ¿Qué segmentos tempranos (basados en comportamiento) tienen mejor avance hacia carrito?
4) ¿Qué acciones concretas (mejoras de UX/merchandising) aumentarían la activación?

**Datos**
- Fuente: `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` (GA4 sample ecommerce).
- Usuario: `user_pseudo_id`.
- Ventana temprana: `first_date` → `first_date + 3 days` (**D0–D3**, aproximación por día calendario).

**Entrega final**
- Dataset listo para Tableau.
- Dashboard con funnel y rendimiento por segmento.
- Recomendaciones accionables basadas en datos.

---

## EN — Goal
Analyze early user behavior in an ecommerce dataset to understand what drives users toward purchase intent and where the journey breaks.

## EN — Metrics
**Primary success metric:**
- **Activation (early window) = Add to Cart**: % of users who trigger `add_to_cart` within the early window **D0–D3** from `first_date` (calendar-day approximation).

**Secondary metric (quality, non-overlapping):**
- **Post-window retention (days 4–30)**: % of users with activity between `first_date + 4` and `first_date + 30`.  
  *Note:* used as a quality metric without mixing immediate return (days 1–3) into the early window.

**Diagnostic metric (search):**
- **Search → Product View rate (session-level)**: % of **sessions** with `view_search_results` that also include `view_item` (scoped users; not restricted to the early window).

**Questions we want to answer:**
1) What % of users reaches `add_to_cart` within the early window (D0–D3)?
2) Which upstream steps (e.g., search → product view) are failing, and for which users?
3) Which early behavior segments perform best on activation?
4) What concrete UX/merchandising actions would increase activation?

**Data**
- Source: `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` (GA4 sample ecommerce).
- User key: `user_pseudo_id`.
- Early window: `first_date` → `first_date + 3 days` (**D0–D3**, calendar-day approximation).

**Final deliverables**
- Tableau-ready dataset.
- Dashboard with funnel + segment performance.
- Data-driven, actionable recommendations.