# Recommendations / Recomendaciones

## ES — Insight 1: `searcher_only_early` concentra el problema de descubrimiento

- El segmento `searcher_only_early` casi no llega a `view_item` (Search → Product View ~0.32% por sesión).
- Si un usuario no llega a ver producto, es poco probable que termine en `add_to_cart` dentro de la ventana temprana.

**Qué podría probarse**

- Ajustes en búsqueda: relevancia y ranking, sugerencias/autocompletado, módulos de “productos relacionados” y un fallback útil cuando no hay resultados.

**Métricas a seguir**

- Search → Product View rate (session-level).
- % de usuarios que pasan de `searcher_only_early` a un comportamiento “viewer” (ver producto) dentro de la ventana temprana (D0–D3).

---

## ES — Insight 2: el scroll en PDP se asocia con mayor `add_to_cart`

- Entre usuarios que ven producto, los que hacen `scroll` (`viewer_scroll`) activan bastante más que los que no hacen scroll (`viewer_no_scroll`).
  - Ejemplo observado: ~**28.8%** vs ~**11.7%** de `add_to_cart` (ventana temprana).

**Qué podría probarse**

- Cambios en PDP para reducir el “no-scroll”:
  - Información clave arriba (precio, CTA visible, envío/devoluciones).
  - Mejoras de performance y layout (carga, estabilidad, jerarquía).
  - “Sticky add to cart” y recomendaciones cerca del CTA.

**Métricas a seguir**

- Activación por grupo `viewer_scroll` vs `viewer_no_scroll`.
- Tasa de scroll en PDP y/o profundidad de scroll (si está disponible).

---

## ES — Insight 3: la activación se concentra en D0

- La mayoría de usuarios que activan `add_to_cart` lo hacen en **D0** (mismo día que `first_date`).
  - Ejemplo observado: D0 ~**4.60%** vs D1–D3 ~**0.55%** (usuarios únicos).

**Qué podría probarse**

- Mejoras enfocadas en la primera visita:
  - Reducir fricción hasta `add_to_cart` (UX, claridad de la oferta, señales de confianza, performance).
  - Descubrimiento rápido (búsqueda + recomendaciones).
  - CTA y selección de variantes (talla/color) lo más “sin esfuerzo” posible en móvil.

**Métricas a seguir**

- Activación D0 vs activación D1–D3 (usuarios únicos).
- Caídas del funnel secuencial (por usuario) dentro de la ventana temprana.

---

## ES — Calidad (check)

- Activar `add_to_cart` en la ventana temprana se asocia con mayor retención post-ventana (D4–D30).
  - Se puede usar como señal de “calidad” sin solapar con D0–D3.

---

## ES — Nota sobre estimaciones

Los escenarios “what-if” son **descriptivos**: ayudan a priorizar hipótesis, pero **no** prueban causalidad. Para validar, harían falta experimentos (A/B tests).

---

# EN — Recommendations

## EN — Insight 1: `searcher_only_early` concentrates the discovery issue

- Segment `searcher_only_early` almost never reaches `view_item` (Search → Product View ~0.32% per session).
- If a user does not reach a product view, reaching `add_to_cart` within the early window becomes unlikely.

**What could be tested**

- Search improvements: relevance and ranking, suggestions/autocomplete, related products modules, and a useful “no results” fallback.

**Metrics to track**

- Search → Product View rate (session-level).
- % of users shifting from `searcher_only_early` to “viewer-like” behavior (product views) within the early window (D0–D3).

---

## EN — Insight 2: PDP scroll correlates with higher `add_to_cart`

- Among product viewers, users who scroll (`viewer_scroll`) activate much more than viewers with no scroll (`viewer_no_scroll`).
  - Observed example: ~**28.8%** vs ~**11.7%** `add_to_cart` (early window).

**What could be tested**

- PDP changes to reduce the “no-scroll” group:
  - Key info above the fold (price, visible CTA, shipping/returns).
  - Performance/layout improvements (load, stability, hierarchy).
  - Sticky add-to-cart + relevant recommendations near the CTA.

**Metrics to track**

- Activation by `viewer_scroll` vs `viewer_no_scroll`.
- PDP scroll rate and/or scroll depth (if available).

---

## EN — Insight 3: activation is concentrated on D0

- Most users who trigger `add_to_cart` do it on **D0** (same day as `first_date`).
  - Observed example: D0 ~**4.60%** vs D1–D3 ~**0.55%** (unique users).

**What could be tested**

- Changes focused on the first visit:
  - Reduce friction to `add_to_cart` (UX clarity, trust signals, performance).
  - Faster discovery (search + recommendations).
  - Make CTA + variant selection (size/color) as low-effort as possible on mobile.

**Metrics to track**

- D0 activation vs D1–D3 activation (unique users).
- Drop-offs in the sequential (user-level) funnel within the early window.

---

## EN — Quality check

- Early-window `add_to_cart` is associated with higher post-window retention (D4–D30).
  - Can be used as a “quality” signal without overlapping D0–D3.

---

## EN — Note on estimates

“What-if” scenarios are **descriptive**: useful for prioritization, but **not causal**. Validation requires experiments (A/B tests).