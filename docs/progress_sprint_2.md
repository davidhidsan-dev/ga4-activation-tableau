# Progress — Sprint 2 / Progreso — Sprint 2

## ES — Qué hicimos
**Objetivo del sprint**
- Entender *por qué* no se alcanza `add_to_cart` en las primeras 72h y detectar palancas accionables.

**Segmentación temprana (72h)**
Creamos segmentos basados en comportamiento temprano (sin usar `add_to_cart` para definirlos):
- `buyer_72h`
- `checkout_intent_72h`
- `product_viewer_scroll_72h`
- `product_viewer_no_scroll_72h`
- `searcher_only_72h`
- `low_engagement_72h`

**Hallazgos clave**
1) **Descubrimiento de producto (búsqueda)**
- Global: Search → Product View **a nivel sesión** (usuarios en scope) ≈ **46.9%**.
- Segmento crítico searcher_only_72h: Search → Product View **a nivel sesión** (usuarios en scope) ≈ **0.32%** (casi nadie llega a producto).

2) **Enganche en página de producto (scroll)**
- `product_viewer_scroll_72h` activa mucho más que `product_viewer_no_scroll_72h`:
  - ~**19.9%** vs ~**8.0%** de `add_to_cart` en 72h.

**Estimaciones de impacto (what-if, no causal)**
- Si conseguimos mover un **10%** de `product_viewer_no_scroll` a `product_viewer_scroll`, estimamos **~+130** `add_to_cart` extra (aprox.).
- Si conseguimos que un **10%** de `searcher_only` pase a comportarse como “viewer”, estimamos **~+87** `add_to_cart` extra (benchmark ponderado de viewers).

**Siguiente paso**
- Preparar una tabla final para Tableau con: usuario, `first_date`, segmento, flags/métricas 72h y KPIs.

---

## EN — What we did
**Sprint goal**
- Understand *why* users do not reach `add_to_cart` within 72h and identify actionable levers.

**Early segmentation (72h)**
We created early behavior segments (without using `add_to_cart` to define segments):
- `buyer_72h`
- `checkout_intent_72h`
- `product_viewer_scroll_72h`
- `product_viewer_no_scroll_72h`
- `searcher_only_72h`
- `low_engagement_72h`

**Key findings**
1) **Product discovery (search)**
- Overall: session-level Search → Product View (scoped users) ≈ **46.9%**.
- Critical segment searcher_only_72h: session-level Search → Product View (scoped users) ≈ **0.32%** (almost no product views).

2) **Product page engagement (scroll)**
- `product_viewer_scroll_72h` activates far more than `product_viewer_no_scroll_72h`:
  - ~**19.9%** vs ~**8.0%** `add_to_cart` within 72h.

**Impact estimates (what-if, non-causal)**
- Shifting **10%** of `product_viewer_no_scroll` to `product_viewer_scroll` estimates **~+130** extra `add_to_cart` (approx.).
- Moving **10%** of `searcher_only` toward “viewer-like” behavior estimates **~+87** extra `add_to_cart` (weighted viewer benchmark).

**Next step**
- Build the Tableau-ready dataset with: user, `first_date`, segment, 72h flags/features, and KPIs.