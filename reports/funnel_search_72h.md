# Funnel — Search → Purchase (Early Window)

## ES — Qué mide este funnel
Este funnel está construido con **usuarios únicos** (`user_pseudo_id`) usando eventos dentro de la **ventana temprana D0–D3** desde el `first_date` de cada usuario (aproximación por día calendario).

Además, es un funnel **secuencial**: para cada usuario se toma el **primer `event_timestamp`** de cada paso y se exige orden estricto (**Search < View item < Add to cart < Begin checkout < Purchase**).

### Alcance
- **Cohorte:** usuarios cuyo `first_date` es **≥ 25/11/2020**.
- **Ventana temprana (D0–D3):** eventos entre `first_date` y `first_date + 3 días` (por día calendario).
- **Población:** usuarios que realizaron al menos un evento de búsqueda `view_search_results` dentro de esa ventana.
- **Unidad:** **usuarios únicos** (no sesiones).

### Pasos del funnel (eventos GA4)
1) **Búsqueda** (`view_search_results`)
2) **Ver producto** (`view_item`)
3) **Añadir al carrito** (`add_to_cart`)
4) **Iniciar checkout** (`begin_checkout`)
5) **Compra** (`purchase`)

### Nota importante (interpretación correcta)
Este funnel mide **progresión secuencial por usuario** dentro de la ventana temprana:  
- Cuenta usuarios que alcanzan cada paso **en orden** (según `event_timestamp`).
- No es un funnel por sesión: la progresión puede ocurrir en múltiples sesiones, siempre que el orden se cumpla.

---

## EN — What this funnel measures
This funnel is built on **unique users** (`user_pseudo_id`) using events within the **early window D0–D3** from `first_date` (calendar-day approximation).

It is also a **sequential** funnel: for each user we take the **first `event_timestamp`** of each step and enforce strict ordering (**Search < View item < Add to cart < Begin checkout < Purchase**).

### Scope
- **Cohort:** users whose `first_date` is **≥ 2020-11-25**.
- **Early window (D0–D3):** events between `first_date` and `first_date + 3 days` (calendar-day).
- **Population:** users who performed at least one search event `view_search_results` within that window.
- **Unit:** **unique users** (not sessions).

### Funnel steps (GA4 events)
1) **Search** (`view_search_results`)
2) **View item** (`view_item`)
3) **Add to cart** (`add_to_cart`)
4) **Begin checkout** (`begin_checkout`)
5) **Purchase** (`purchase`)

### Important note (correct interpretation)
This funnel measures **user-level sequential progression** within the early window:  
- Users are counted if they reach each step **in order** (based on `event_timestamp`).
- It is not session-level: progression may happen across multiple sessions as long as ordering holds.

---

## Resultados / Results (latest run)

| Paso / Step | Usuarios / Users |
|---|---:|
| Search | 10088 |
| View item | 2410 |
| Add to cart | 855 |
| Begin checkout | 153 |
| Purchase | 84 |

---

## ES — Interpretación
- Mayor caída: **Search → View item** (cuello de botella de descubrimiento).
- Enfoque de acción: mejorar **relevancia de búsqueda**, **sugerencias**, y **UX de resultados** para aumentar “View item” tras una búsqueda.
- Métricas de seguimiento: **Search → View item rate (a nivel sesión)** y **Add-to-cart rate (ventana temprana D0–D3)**.

## EN — Interpretation
- Largest drop: **Search → View item** (discovery bottleneck).
- Action focus: improve **search relevance**, **suggestions**, and **results UX** to increase “View item” after a search.
- Tracking metrics: **Search → View item rate (session-level)** and **Add-to-cart rate (early window D0–D3)**.