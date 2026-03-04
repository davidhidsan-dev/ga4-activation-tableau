# Segment Rules (72h) / Reglas de Segmentación (72h)

## ES — Definición

Segmentación basada SOLO en comportamiento temprano dentro de las primeras 72h desde `first_date`.
Regla: **un usuario pertenece a 1 solo segmento** (prioridad de arriba a abajo).

## ES — Prioridad (tie-breaker)

1. `buyer_72h`: hizo `purchase` en 72h
2. `checkout_intent_72h`: hizo `begin_checkout` en 72h
3. `product_viewer_scroll_72h`: vio producto (`view_item`) y tuvo `scroll` en 72h
4. `product_viewer_no_scroll_72h`: vio producto (`view_item`) pero NO tuvo `scroll` en 72h
5. `searcher_only_72h`: buscó (`view_search_results`) pero NO llegó a ver producto (`view_item=0`)
6. `low_engagement_72h`: resto

> Nota: Los segmentos se definen sin usar `add_to_cart` para evitar “auto-explicarse” la métrica objetivo.

## EN — Definition

Segmentation uses ONLY early behavior within the first 72h from `first_date`.
Rule: **each user belongs to exactly one segment** (priority top-down).

## EN — Priority (tie-breaker)

1. `buyer_72h`: `purchase` within 72h
2. `checkout_intent_72h`: `begin_checkout` within 72h
3. `product_viewer_scroll_72h`: `view_item` + `scroll` within 72h
4. `product_viewer_no_scroll_72h`: `view_item` + no `scroll` within 72h
5. `searcher_only_72h`: `view_search_results` but no `view_item`
6. `low_engagement_72h`: everyone else
