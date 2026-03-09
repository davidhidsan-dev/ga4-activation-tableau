# Executive Summary / Resumen Ejecutivo

## ES — Contexto y objetivo

Este proyecto analiza comportamiento temprano (**early window: D0–D3**) en un ecommerce (GA4 sample) para ver qué señales se asocian con **activación temprana** (add to cart).

- **Cohorte (scope):** `first_date >= 2020-11-25`
- **Ventana temprana:** D0–D3 desde `first_date` (aprox. por día calendario con `event_date`)
- **Métrica principal:** **Add-to-cart rate (early window)** (usuarios únicos)

## ES — Qué observamos

1) **Problema de descubrimiento (búsqueda)**  
- En usuarios que usan búsqueda, la mayor caída del funnel aparece en **Search → View item**.  
- El segmento `searcher_only` es especialmente extremo: casi no llega a páginas de producto.

2) **Señales de engagement en PDP**  
- `product_viewer_scroll` activa bastante más que `product_viewer_no_scroll`.  
- Una lectura posible es que cambios en PDP (contenido “above the fold”, layout, performance, CTA visible) podrían influir en la probabilidad de `add_to_cart` (esto no implica causalidad).

3) **Calidad (post-window)**  
- Los usuarios activados tienden a tener más actividad post-window (D4–D30).  
- Se usa como métrica secundaria sin solapar con la ventana temprana.

## ES — Qué podría probarse (hipótesis)

- **Búsqueda (Search → View item):** relevancia/ranking, sugerencias/autocompletado, fallback en “0 results”, módulos de productos relacionados.  
- **PDP (scroll/engagement):** CTA visible (sticky), info clave arriba, mejoras de performance, recomendaciones cerca del CTA.  
- **Propensión (ML):** usar deciles para priorizar análisis/segmentación de usuarios y definir tests (no es un sistema productivo).

## ES — Cómo medir cambios

- Add-to-cart rate (early window)
- Search → Product View rate (session-level)
- Distribución de segmentos (¿baja `searcher_only`? ¿suben viewers?)
- Funnel drop-offs (Search → View item y View item → Add to cart)

---

## EN — Context and goal

This project analyzes early behavior (**early window: D0–D3**) in an ecommerce dataset (GA4 sample) to understand which signals correlate with **early activation** (add to cart).

- **Cohort (scope):** `first_date >= 2020-11-25`
- **Early window:** D0–D3 from `first_date` (calendar-day approximation using `event_date`)
- **North-star metric:** **Add-to-cart rate (early window)** (unique users)

## EN — What we observed

1) **Discovery issue (search)**  
- For search users, the largest funnel drop appears at **Search → View item**.  
- The `searcher_only` segment is particularly extreme: users rarely reach product pages.

2) **PDP engagement signals**  
- `product_viewer_scroll` activates much more than `product_viewer_no_scroll`.  
- One possible reading is that PDP changes (above-the-fold content, layout, performance, visible CTA) could affect `add_to_cart` likelihood (this is not causal).

3) **Quality (post-window)**  
- Activated users tend to show higher post-window activity (D4–D30).  
- This is used as a secondary, non-overlapping quality metric.

## EN — What could be tested (hypotheses)

- **Search (Search → View item):** relevance/ranking, suggestions/autocomplete, “0 results” fallback, related items modules.  
- **PDP (scroll/engagement):** visible CTA (sticky), key info above the fold, performance improvements, recommendations near the CTA.  
- **Propensity (ML):** use deciles to prioritize analysis/targeting and define tests (not a production system).

## EN — How to measure changes

- Add-to-cart rate (early window)
- Search → Product View rate (session-level)
- Segment distribution shifts (down `searcher_only`, up viewer segments)
- Funnel drop-offs (Search → View item and View item → Add to cart)