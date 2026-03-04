# Executive Summary / Resumen Ejecutivo

## ES — Contexto y objetivo

Este proyecto analiza el comportamiento temprano (primeras 72h) en un ecommerce (GA4 sample) para entender qué explica la **activación temprana**.

* **Cohorte:** `first_date >= 2020-11-25`
* **Ventana temprana:** `first_date` → `first_date + 3 days`
* **Métrica principal:** **Add-to-cart rate (72h)** (usuarios únicos)

## ES — Qué encontramos

1. **Cuello de botella en descubrimiento**

* En usuarios que usan búsqueda, el mayor drop del funnel es **Search → View item**.
* El segmento `searcher_only_72h` muestra un comportamiento crítico: casi no llega a páginas de producto.

2. **Engagement en PDP importa**

* `product_viewer_scroll_72h` activa significativamente más que `product_viewer_no_scroll_72h`.
* Esto sugiere que mejorar experiencia en PDP (contenido, layout, velocidad) puede aumentar activación.

3. **Calidad (post-72h)**

* Los usuarios activados tienden a mostrar mayor actividad post-72h (D4–D30), usado como métrica secundaria sin solapamiento.

## ES — Acciones recomendadas (prioridad)

**P1 — Mejorar Search → View item**

* Relevancia y ranking, sugerencias, fallback en “0 results”, módulos de productos relacionados.

**P2 — Mejorar PDP para elevar scroll/engagement**

* CTA visible (sticky), info clave arriba, optimización de performance, recomendaciones.

**P3 — Priorización con propensión**

* Usar deciles del modelo para priorizar experimentos y personalización (sin necesidad de “deploy” productivo).

## ES — Cómo medir impacto

* Add-to-cart rate (72h)
* Search → Product View rate (sesión)
* Distribución de segmentos (¿baja `searcher_only_72h`? ¿sube viewer?)
* Funnel drop-offs (Search → View item y View item → Add to cart)

---

## EN — Context and goal

This project analyzes early behavior (first 72h) in an ecommerce dataset (GA4 sample) to understand **early activation** drivers.

* **Cohort:** `first_date >= 2020-11-25`
* **Early window:** `first_date` → `first_date + 3 days`
* **North-star metric:** **Add-to-cart rate (72h)** (unique users)

## EN — What we found

1. **Discovery bottleneck**

* For search users, the main funnel drop is **Search → View item**.
* The `searcher_only_72h` segment is critical: users rarely reach product pages.

2. **PDP engagement matters**

* `product_viewer_scroll_72h` activates far more than `product_viewer_no_scroll_72h`.
* This suggests PDP UX/performance improvements can lift activation.

3. **Quality (post-72h)**

* Activated users tend to show higher post-72h activity (D4–D30), used as a non-overlapping secondary metric.

## EN — Recommended actions (priority)

**P1 — Improve Search → View item**

* Relevance/ranking, suggestions, “0 results” fallback, related items modules.

**P2 — Improve PDP to lift scroll/engagement**

* Visible CTA (sticky), key info above the fold, performance, recommendations.

**P3 — Propensity-based prioritization**

* Use model deciles to prioritize experiments/personalization (no production deployment required).

## EN — How to measure impact

* Add-to-cart rate (72h)
* Search → Product View rate (session-level)
* Segment distribution shifts (down `searcher_only_72h`, up viewer segments)
* Funnel drop-offs (Search → View item and View item → Add to cart)
