# Funnel — Search → Purchase (Early Window)

## ES — Qué mide este funnel
Este funnel está construido con **usuarios únicos** (`user_pseudo_id`) usando eventos dentro de la **ventana temprana D0–D3** desde el `first_date` de cada usuario (aproximación por día calendario).

Es un funnel **secuencial**: para cada usuario se toma el **primer `event_timestamp`** de cada paso y se exige orden estricto (**Search < View item < Add to cart < Begin checkout < Purchase**).

### Alcance
- **Cohorte:** usuarios con `first_date` **≥ 2020-11-25**.
- **Ventana temprana (D0–D3):** eventos entre `first_date` y `first_date + 3 días` (por día calendario).
- **Población:** usuarios que realizaron al menos una búsqueda (`view_search_results`) dentro de esa ventana.
- **Unidad:** **usuarios únicos** (no sesiones).

### Pasos del funnel (eventos GA4)
1) **Búsqueda** (`view_search_results`)
2) **Ver producto** (`view_item`)
3) **Añadir al carrito** (`add_to_cart`)
4) **Iniciar checkout** (`begin_checkout`)
5) **Compra** (`purchase`)

### Nota de interpretación
Este funnel mide **progresión secuencial por usuario** dentro de la ventana temprana:
- Cuenta usuarios que alcanzan cada paso **en orden** (según `event_timestamp`).
- No es un funnel por sesión: la progresión puede ocurrir en varias sesiones mientras se cumpla el orden.

---

## EN — What this funnel measures
This funnel is built on **unique users** (`user_pseudo_id`) using events within the **early window D0–D3** from `first_date` (calendar-day approximation).

It is a **sequential** funnel: for each user we take the **first `event_timestamp`** of each step and enforce strict ordering (**Search < View item < Add to cart < Begin checkout < Purchase**).

### Scope
- **Cohort:** users with `first_date` **≥ 2020-11-25**.
- **Early window (D0–D3):** events between `first_date` and `first_date + 3 days` (calendar-day).
- **Population:** users who performed at least one search (`view_search_results`) within that window.
- **Unit:** **unique users** (not sessions).

### Funnel steps (GA4 events)
1) **Search** (`view_search_results`)
2) **View item** (`view_item`)
3) **Add to cart** (`add_to_cart`)
4) **Begin checkout** (`begin_checkout`)
5) **Purchase** (`purchase`)

### Interpretation note
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
- La mayor caída ocurre entre **Search → View item**.
- Esto apunta a un problema de **descubrimiento tras buscar** (que una búsqueda termine llevando a una página de producto).
- Para seguirlo:
  - **Search → View item rate (session-level)** como proxy de calidad de búsqueda.
  - **Add-to-cart rate (early window D0–D3)** como métrica de activación.

## EN — Interpretation
- The largest drop is **Search → View item**.
- This points to a **post-search discovery** issue (a search not leading to a product page).
- To track it:
  - **Search → View item rate (session-level)** as a search-quality proxy.
  - **Add-to-cart rate (early window D0–D3)** as the activation metric.