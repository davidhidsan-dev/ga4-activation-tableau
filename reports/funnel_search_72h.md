# Funnel — Search (72h)

## ES — Qué mide este funnel
Este funnel está construido con **usuarios únicos** (`user_pseudo_id`) y usando únicamente eventos dentro de las **primeras 72 horas** desde el `first_date` de cada usuario.

### Alcance
- **Cohorte:** usuarios cuyo `first_date` es **≥ 25/11/2020**.
- **Ventana (72h):** eventos entre `first_date` y `first_date + 3 días` (aprox. 72h).
- **Población:** usuarios que realizaron al menos un evento de búsqueda `view_search_results` dentro de esa ventana.
- **Unidad:** **usuarios únicos** (no sesiones).

### Pasos del funnel (eventos GA4)
1) **Búsqueda** (`view_search_results`)
2) **Ver producto** (`view_item`)
3) **Añadir al carrito** (`add_to_cart`)
4) **Iniciar checkout** (`begin_checkout`)
5) **Compra** (`purchase`)

### Nota importante (interpretación correcta)
Este funnel mide **alcance por hito** dentro de 72h:  
- Cuenta usuarios que llegaron **al menos una vez** a cada paso.
- **No garantiza** que el usuario haya seguido los pasos en orden exacto dentro de una sola sesión (no es “funnel por sesión”).

---

## EN — What this funnel measures
This funnel is built on **unique users** (`user_pseudo_id`) using only events within each user’s **first 72 hours** since `first_date`.

### Scope
- **Cohort:** users whose `first_date` is **≥ 2020-11-25**.
- **Window (72h):** events between `first_date` and `first_date + 3 days` (~72h).
- **Population:** users who performed at least one search event `view_search_results` within that window.
- **Unit:** **unique users** (not sessions).

### Funnel steps (GA4 events)
1) **Search** (`view_search_results`)
2) **View item** (`view_item`)
3) **Add to cart** (`add_to_cart`)
4) **Begin checkout** (`begin_checkout`)
5) **Purchase** (`purchase`)

### Important note (correct interpretation)
This is a **milestone reach** funnel within 72h:  
- Users are counted if they reached each step at least once.
- It does **not** enforce strict step ordering within a single session (not session-level).

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

## Interpretación / Interpretation
- Mayor caída: **Search → View item** (cuello de botella de descubrimiento).
- Enfoque de acción: mejorar **relevancia de búsqueda**, **sugerencias**, y **resultados** para aumentar “View item” tras una búsqueda.
- Métrica de seguimiento: **Search → View item rate** y **Add-to-cart rate (72h)**.