# Segment Rules (early window) / Reglas de Segmentación (ventana temprana)

## ES — Definición

Segmentación basada **solo** en comportamiento dentro de la **ventana temprana**:
**D0–D3 desde `first_date`** (aproximación por día calendario usando `event_date`).

Regla: **cada usuario pertenece a 1 único segmento** (prioridad de arriba a abajo).

## ES — Prioridad (tie-breaker)

1. `buyer`: hizo `purchase` en la ventana temprana
2. `checkout_intent`: hizo `begin_checkout` en la ventana temprana
3. `product_viewer_scroll`: vio producto (`view_item`) **y** tuvo `scroll` en la ventana temprana
4. `product_viewer_no_scroll`: vio producto (`view_item`) pero **no** tuvo `scroll` en la ventana temprana
5. `searcher_only`: buscó (`view_search_results`) pero **no** llegó a ver producto (`view_item = 0`)
6. `low_engagement`: resto

> Nota: los segmentos se definen **sin usar `add_to_cart`** para evitar “auto-explicar” la métrica objetivo.

---

## EN — Definition

Segmentation is based **only** on behavior within the **early window**:
**D0–D3 from `first_date`** (calendar-day approximation using `event_date`).

Rule: **each user belongs to exactly one segment** (top-down priority).

## EN — Priority (tie-breaker)

1. `buyer`: `purchase` in the early window
2. `checkout_intent`: `begin_checkout` in the early window
3. `product_viewer_scroll`: `view_item` **and** `scroll` in the early window
4. `product_viewer_no_scroll`: `view_item` but **no** `scroll` in the early window
5. `searcher_only`: `view_search_results` but no `view_item`
6. `low_engagement`: everyone else

> Note: segments are defined **without `add_to_cart`** to avoid “self-explaining” the target metric.