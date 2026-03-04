# Dashboard Guide / Guía del Dashboard

## ES — Link

Enlace Tableau Public:
Pega aquí tu link final (ejemplo):

* Dashboard: https://public.tableau.com/app/profile/david.hidalgo.s.nchez/viz/Libro1_17724829569200/Dashboard1?publish=yes

## ES — Qué contiene (vistas)

1. **KPIs (arriba)**

* **Users (unique)**: número de usuarios únicos en el rango de `first_date` seleccionado.
* **Add-to-cart rate (72h)**: % usuarios con `add_to_cart_72h=1`.
* **Post-72h retention (D4–D30)**: % usuarios con actividad entre día 4 y día 30.
* **Search → Product View (72h)**: rate por sesión de búsqueda a vista de producto.

2. **Activation by Segment**

* Barras horizontales: activación 72h por `segment_72h`.
* **Cómo leerlo:** identifica segmentos con mejor/peor conversión a carrito.

3. **Users by Segment**

* Barras horizontales: tamaño (usuarios únicos) por segmento.
* **Cómo leerlo:** prioriza “impacto”: un segmento pequeño puede convertir mucho pero aportar poco volumen.

4. **Activation among Searchers**

* Igual que “Activation by Segment” pero filtrando usuarios con `search_72h=1`.
* **Cómo leerlo:** enfocado en usuarios que usan búsqueda (donde hay una palanca clara: Search → Product View).

5. **Funnel – Search (72h) (Users)**

* Funnel secuencial por usuario desde Search hasta Purchase.
* **Cómo leerlo:** cuantifica el “drop” en cada paso.

6. **Quality: Post-72h Retention**

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
* **segment_72h (multi-select):** filtra por segmentos.

> Recomendación: por defecto deja `first_date` en el rango completo del proyecto y permite segment filtrar.

---

## EN — Link

Tableau Public link:
Paste your final link here (example):

* Dashboard: https://public.tableau.com/app/profile/david.hidalgo.s.nchez/viz/Libro1_17724829569200/Dashboard1?publish=yes

## EN — What’s inside (views)

1. **KPIs (top)**

* **Users (unique):** number of unique users in the selected `first_date` range.
* **Add-to-cart rate (72h):** % users with `add_to_cart_72h=1`.
* **Post-72h retention (D4–D30):** % users with activity between day 4 and day 30.
* **Search → Product View (72h):** session-level rate from search to product view.

2. **Activation by Segment**

* Horizontal bars: 72h activation by `segment_72h`.
* **How to read:** spot segments with best/worst add-to-cart conversion.

3. **Users by Segment**

* Horizontal bars: segment size (unique users).
* **How to read:** prioritize by impact: a tiny segment can convert well but drive low volume.

4. **Activation among Searchers**

* Same as “Activation by Segment” but filtered to `search_72h=1`.
* **How to read:** focuses on search users (key lever: Search → Product View).

5. **Funnel – Search (72h) (Users)**

* User-level sequential funnel from Search to Purchase.
* **How to read:** quantifies drop-offs at each step.

6. **Quality: Post-72h Retention**

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
* **segment_72h (multi-select):** segment filtering.

> Recommendation: keep `first_date` as full project range by default and allow segment filtering.
