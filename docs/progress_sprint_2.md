# Progress — Sprint 2 / Progreso — Sprint 2

## ES — Qué hicimos
**Objetivo del sprint**
- Entender *por qué* no se alcanza `add_to_cart` en la **ventana temprana (D0–D3)** y detectar palancas accionables.

**Segmentación temprana (early window)**
Creamos segmentos basados en comportamiento temprano (sin usar `add_to_cart` para definirlos):
- `buyer_early`
- `checkout_intent_early`
- `product_viewer_scroll_early`
- `product_viewer_no_scroll_early`
- `searcher_only_early`
- `low_engagement_early`

**Hallazgos clave**
1) **Descubrimiento de producto (búsqueda)**
- Global: Search → Product View **a nivel sesión** (usuarios en scope) ≈ **46.9%**.
- Segmento crítico `searcher_only_early`: Search → Product View **a nivel sesión** ≈ **0.32%** (casi nadie llega a producto).

2) **Enganche en página de producto (scroll en PDP)**
- Los usuarios `viewer_scroll` activan mucho más que `viewer_no_scroll` dentro de la ventana temprana:
  - **~28.8% vs ~11.7%** de `add_to_cart` (PDP scroll vs no scroll).
- Además, el grupo `non_viewer` prácticamente no activa (casi nadie llega a `add_to_cart` sin `view_item`).

**Estimaciones de impacto (what-if, no causal)**
- Si conseguimos mover un **10%** de `product_viewer_no_scroll` a `product_viewer_scroll`, estimamos un aumento en `add_to_cart` proporcional a la diferencia de tasas (ver query de uplift).
- Si conseguimos que un **10%** de `searcher_only` pase a comportarse como “viewer”, estimamos `add_to_cart` extra usando como benchmark la tasa ponderada de “viewers”.

**Siguiente paso**
- Preparar/actualizar la tabla final para Tableau con: usuario, `first_date`, `segment_early`, flags/métricas de ventana temprana y KPIs (incl. retención post-ventana).

---

## EN — What we did
**Sprint goal**
- Understand *why* users do not reach `add_to_cart` in the **early window (D0–D3)** and identify actionable levers.

**Early segmentation (early window)**
We created early behavior segments (without using `add_to_cart` to define segments):
- `buyer_early`
- `checkout_intent_early`
- `product_viewer_scroll_early`
- `product_viewer_no_scroll_early`
- `searcher_only_early`
- `low_engagement_early`

**Key findings**
1) **Product discovery (search)**
- Overall: session-level Search → Product View (scoped users) ≈ **46.9%**.
- Critical segment `searcher_only_early`: session-level Search → Product View ≈ **0.32%** (almost no product views).

2) **Product page engagement (PDP scroll)**
- `viewer_scroll` users activate far more than `viewer_no_scroll` within the early window:
  - **~28.8% vs ~11.7%** `add_to_cart` (PDP scroll vs no scroll).
- The `non_viewer` group barely activates (almost no `add_to_cart` without `view_item`).

**Impact estimates (what-if, non-causal)**
- Shifting **10%** of `product_viewer_no_scroll` to `product_viewer_scroll` yields a proportional increase in `add_to_cart` based on the observed rate gap (see uplift query).
- Moving **10%** of `searcher_only` toward “viewer-like” behavior estimates extra `add_to_cart` using the weighted “viewer” benchmark activation rate.

**Next step**
- Prepare/update the Tableau-ready dataset with: user, `first_date`, `segment_early`, early-window flags/features and KPIs (incl. post-window retention).