# Progress — Sprint 2 / Progreso — Sprint 2

## ES — Qué hicimos
**Objetivo del sprint**
- Entender por qué muchos usuarios no llegan a `add_to_cart` en la **ventana temprana (D0–D3)** y localizar puntos del flujo donde se pierden.

**Segmentación temprana (early window)**
Creamos segmentos a partir de señales de comportamiento temprano (sin usar `add_to_cart` para definirlos):
- `buyer_early`
- `checkout_intent_early`
- `product_viewer_scroll_early`
- `product_viewer_no_scroll_early`
- `searcher_only_early`
- `low_engagement_early`

**Hallazgos clave**
1) **Descubrimiento de producto (búsqueda)**
- Global: Search → Product View **a nivel sesión** (usuarios en scope) ≈ **46.9%**.
- Segmento crítico `searcher_only_early`: Search → Product View **a nivel sesión** ≈ **0.32%** (casi ninguna sesión con búsqueda llega a `view_item`).

2) **Enganche en PDP (scroll)**
- Dentro de la ventana temprana, `viewer_scroll` activa bastante más que `viewer_no_scroll`:
  - **~28.8% vs ~11.7%** de `add_to_cart` (PDP scroll vs no scroll).
- El grupo `non_viewer` prácticamente no activa (casi no hay `add_to_cart` sin `view_item`).

**Estimaciones de impacto (what-if, no causal)**
- Si un **10%** de `product_viewer_no_scroll` pasara a comportarse como `product_viewer_scroll`, el uplift esperado en `add_to_cart` sería proporcional a la diferencia de tasas (ver query de uplift).
- Si un **10%** de `searcher_only` pasara a un comportamiento “viewer”, el uplift se estima usando como referencia la tasa ponderada de los segmentos “viewer”.

**Siguiente paso**
- Preparar/actualizar la tabla final para Tableau con: usuario, `first_date`, `segment_early`, flags/métricas de ventana temprana y KPIs (incl. retención post-ventana).

---

## EN — What we did
**Sprint goal**
- Understand why many users do not reach `add_to_cart` in the **early window (D0–D3)** and locate where they drop in the flow.

**Early segmentation (early window)**
We created segments from early behavior signals (without using `add_to_cart` to define them):
- `buyer_early`
- `checkout_intent_early`
- `product_viewer_scroll_early`
- `product_viewer_no_scroll_early`
- `searcher_only_early`
- `low_engagement_early`

**Key findings**
1) **Product discovery (search)**
- Overall: session-level Search → Product View (scoped users) ≈ **46.9%**.
- Critical segment `searcher_only_early`: session-level Search → Product View ≈ **0.32%** (almost no search sessions reach `view_item`).

2) **PDP engagement (scroll)**
- Within the early window, `viewer_scroll` activates much more than `viewer_no_scroll`:
  - **~28.8% vs ~11.7%** `add_to_cart` (PDP scroll vs no scroll).
- The `non_viewer` group barely activates (almost no `add_to_cart` without `view_item`).

**Impact estimates (what-if, non-causal)**
- If **10%** of `product_viewer_no_scroll` shifted to `product_viewer_scroll` behavior, the expected uplift in `add_to_cart` is proportional to the observed rate gap (see uplift query).
- If **10%** of `searcher_only` shifted toward “viewer-like” behavior, uplift is estimated using the weighted activation rate of “viewer” segments as the benchmark.

**Next step**
- Prepare/update the Tableau-ready dataset with: user, `first_date`, `segment_early`, early-window flags/features, and KPIs (incl. post-window retention).