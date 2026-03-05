# Dashboard Guide / Guía del Dashboard

## ES — Link

Enlace Tableau Public:

* Dashboard: https://public.tableau.com/views/EarlyActivationEarlyBehaviorGA4EcommerceD0D3/Dashboard1?:language=es-ES&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link

## ES — Qué contiene (vistas)

1. **KPIs (arriba)**

* **Users (unique)**: número de usuarios únicos en el rango de `first_date` seleccionado.
* **Add-to-cart rate (early window)**: % de usuarios con `add_to_cart_early=1`.
* **Post-window retention (D4–D30)**: % de usuarios con actividad entre el día 4 y el día 30.
* **Search → Product View (session-level)**: rate por sesión de búsqueda a vista de producto (proxy de calidad de búsqueda).

2. **Activation by Segment**

* Barras horizontales: activación en ventana temprana por `segment_early`.
* **Cómo leerlo:** identifica segmentos con mejor/peor conversión a carrito.

3. **Users by Segment**

* Barras horizontales: tamaño (usuarios únicos) por segmento.
* **Cómo leerlo:** prioriza “impacto”: un segmento pequeño puede convertir mucho pero aportar poco volumen.

4. **Activation among Searchers**

* Igual que “Activation by Segment” pero filtrando usuarios con `search_early=1`.
* **Cómo leerlo:** enfocado en usuarios que usan búsqueda (donde hay una palanca clara: Search → Product View).

5. **Funnel – Search → Purchase (early window, users)**

* Funnel secuencial por usuario desde Search hasta Purchase.
* **Cómo leerlo:** cuantifica el “drop” en cada paso.

6. **Quality: Post-window Retention**

* Comparación de retención (D4–D30) entre activados vs no activados.
* **Cómo leerlo:** valida si activar temprano se asocia con usuarios de mayor calidad.

7. **Propensity Deciles**

* Deciles del modelo (10 grupos):

  * barras = tasa real de activación
  * línea = probabilidad media predicha
* **Cómo leerlo:** si el modelo ordena bien, los deciles altos deben tener mayor tasa real.

---

## ES — Filtros (dashboard)

* **first_date (range):** limita cohortes de adquisición.
* **segment_early (multi-select):** filtra por segmentos.

> Recomendación: por defecto deja `first_date` en el rango completo del proyecto y permite filtrar por segmento.

---

## EN — Link

Tableau Public link:

* Dashboard: https://public.tableau.com/views/EarlyActivationEarlyBehaviorGA4EcommerceD0D3/Dashboard1?:language=es-ES&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link

## EN — What’s inside (views)

1. **KPIs (top)**

* **Users (unique):** number of unique users in the selected `first_date` range.
* **Add-to-cart rate (early window):** % users with `add_to_cart_early=1`.
* **Post-window retention (D4–D30):** % users with activity between day 4 and day 30.
* **Search → Product View (session-level):** session-level rate from search to product view (proxy for search quality).

2. **Activation by Segment**

* Horizontal bars: early-window activation by `segment_early`.
* **How to read:** spot segments with best/worst add-to-cart conversion.

3. **Users by Segment**

* Horizontal bars: segment size (unique users).
* **How to read:** prioritize by impact: a tiny segment can convert well but drive low volume.

4. **Activation among Searchers**

* Same as “Activation by Segment” but filtered to `search_early=1`.
* **How to read:** focuses on search users (key lever: Search → Product View).

5. **Funnel – Search → Purchase (early window, users)**

* User-level sequential funnel from Search to Purchase.
* **How to read:** quantifies drop-offs at each step.

6. **Quality: Post-window Retention**

* Compares retention (D4–D30) for activated vs non-activated users.
* **How to read:** checks whether early activation correlates with higher-quality users.

7. **Propensity Deciles**

* Model deciles (10 groups):

  * bars = actual activation rate
  * line = average predicted probability
* **How to read:** if ranking works, higher deciles should have higher actual activation.

---

## EN — Filters (dashboard)

* **first_date (range):** limits acquisition cohorts.
* **segment_early (multi-select):** segment filtering.

> Recommendation: keep `first_date` as full project range by default and allow segment filtering.
