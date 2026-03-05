# Recommendations / Recomendaciones

## ES — Insight 1: “Searcher-only” es el cuello de botella (descubrimiento)

* El segmento `searcher_only_early` casi no llega a `view_item` (Search → Product View ~0.32% por sesión).
* Si el usuario no ve producto, es muy difícil que llegue a `add_to_cart`.

**Acción recomendada**

* Mejorar búsqueda: relevancia, ranking, sugerencias/autocompletado, “productos relacionados” y un buen fallback cuando no hay resultados.

**Métricas a seguir**

* Search → Product View rate (session-level).
* % de usuarios que pasan de `searcher_only_early` a un comportamiento “viewer” (ver producto) dentro de la ventana temprana (D0–D3).

---

## ES — Insight 2: engagement en PDP (scroll) se asocia a mayor activación

* Los usuarios que ven producto **y** hacen `scroll` (`viewer_scroll`) activan mucho más que los que ven producto sin scroll (`viewer_no_scroll`).
  * Ejemplo observado: ~**28.8%** vs ~**11.7%** de `add_to_cart` (ventana temprana).

**Acción recomendada**

* Mejorar la PDP para “no-scroll”:
  * Contenido clave arriba (precio, CTA visible, info de envío/devoluciones).
  * Layout más claro y rápido (performance).
  * “Sticky add to cart” y recomendaciones relevantes cerca del CTA.

**Métricas a seguir**

* Activación por grupo `viewer_scroll` vs `viewer_no_scroll`.
* Tasa de scroll en PDP y/o “profundidad” de scroll (si está disponible).

---

## ES — Insight 3: la activación ocurre mayoritariamente en D0 (primer día)

* La gran mayoría de usuarios que activan `add_to_cart` lo hacen el **primer día (D0)**.
  * Ejemplo observado: activación D0 ~**4.60%** vs D1–D3 ~**0.55%** (usuarios únicos).

**Acción recomendada**

* Priorizar mejoras que impacten la **primera visita**:
  * Reducir fricción hasta `add_to_cart` (UX, claridad de oferta, confianza, performance).
  * Mejorar descubrimiento rápido (búsqueda + recomendaciones).
  * Asegurar que el CTA y la selección de variantes (talla/color) sean “sin esfuerzo” en móvil.

**Métricas a seguir**

* Activación D0 vs activación D1–D3 (usuarios únicos).
* Drop-offs en el funnel secuencial (por usuario) dentro de la ventana temprana.

---

## ES — Calidad (check)

* Activar `add_to_cart` dentro de la ventana temprana se asocia a mayor retención post-ventana (D4–D30).
  * Útil como señal de “calidad” sin mezclar el retorno inmediato del periodo temprano.

---

## ES — Nota sobre estimaciones

Los escenarios “what-if” son descriptivos (sirven para priorizar hipótesis), pero **no prueban causalidad**. Validar con experimentos (A/B tests).

---

# EN — Recommendations

## EN — Insight 1: “Searcher-only” is the discovery bottleneck

* Segment `searcher_only_early` almost never reaches `view_item` (Search → Product View ~0.32% per session).
* If users don’t see products, it’s very hard to reach `add_to_cart`.

**Recommended action**

* Improve search: relevance, ranking, suggestions/autocomplete, related products, and a strong “no results” fallback.

**Metrics to track**

* Search → Product View rate (session-level).
* % of users shifting from `searcher_only_early` to a “viewer-like” behavior (product views) within the early window (D0–D3).

---

## EN — Insight 2: PDP engagement (scroll) correlates with higher activation

* Users who view a product **and** scroll (`viewer_scroll`) activate far more than product viewers with no scroll (`viewer_no_scroll`).
  * Observed example: ~**28.8%** vs ~**11.7%** `add_to_cart` (early window).

**Recommended action**

* Improve the PDP for “no-scroll” users:
  * Put key info above the fold (price, visible CTA, shipping/returns).
  * Faster, cleaner layout (performance).
  * Sticky add-to-cart + relevant recommendations near the CTA.

**Metrics to track**

* Activation by `viewer_scroll` vs `viewer_no_scroll`.
* PDP scroll rate and/or scroll depth (if available).

---

## EN — Insight 3: activation happens mostly on D0 (first day)

* Most users who trigger `add_to_cart` do it on **day 0 (D0)**.
  * Observed example: D0 activation ~**4.60%** vs D1–D3 ~**0.55%** (unique users).

**Recommended action**

* Prioritize changes that impact the **first visit**:
  * Reduce friction to `add_to_cart` (UX clarity, trust signals, performance).
  * Improve fast discovery (search + recommendations).
  * Make CTA + variant selection effortless on mobile.

**Metrics to track**

* D0 activation vs D1–D3 activation (unique users).
* Drop-offs in the sequential (user-level) funnel within the early window.

---

## EN — Quality check

* Early-window `add_to_cart` is associated with higher post-window retention (D4–D30).
  * Useful as a quality signal without overlapping with the immediate early period.

---

## EN — Note on estimates

“What-if” scenarios are descriptive (good for prioritizing hypotheses) but **not causal**. Validate via experiments (A/B tests).