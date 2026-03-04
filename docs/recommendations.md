# Recommendations / Recomendaciones

## ES — Insight 1: “Searcher-only” es el cuello de botella

* Segmento `searcher_only_72h` casi no llega a `view_item` (Search → Product View ~0.32% por sesión).
* Si el usuario no ve producto, es imposible que llegue a carrito.

**Acción recomendada**

* Mejorar búsqueda: relevancia, ranking, sugerencias, “productos relacionados”, fallback cuando no hay resultados.

**Métrica a seguir**

* Search → Product View rate (por sesión) y % de usuarios que pasan de `searcher_only` a `product_viewer`.

---

## ES — Insight 2: scroll en PDP se asocia a mayor activación

* `product_viewer_scroll_72h` activa mucho más que `product_viewer_no_scroll_72h` (~19.9% vs ~8.0%).

**Acción recomendada**

* Mejorar PDP para “no-scroll”: contenido clave arriba (precio, CTA visible, shipping info), velocidad, layout, “sticky add to cart”.

**Métrica a seguir**

* Activación 72h por segmento viewer + tasa de scroll en PDP.

---

## ES — Calidad (check)

* Activar en 72h está asociado a más retención post-72h (D4–D30).
  Usar esto como señal de “calidad” del usuario.

---

## ES — Nota sobre estimaciones

Los escenarios “what-if” son descriptivos y sirven para priorizar hipótesis, pero no prueban causalidad. Validar con A/B tests.

---

## EN — Recommendations

(English mirror of the sections above.)
