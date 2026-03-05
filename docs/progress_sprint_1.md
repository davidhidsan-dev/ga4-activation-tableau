# Progress — Sprint 1 / Progreso — Sprint 1

## ES — Qué hicimos
**Objetivo del sprint**
- Definir y calcular la métrica principal: **Activación temprana = % de usuarios con `add_to_cart` dentro de la ventana temprana (D0–D3)** desde su `first_date`.

**Decisiones de alcance**
- Detectamos que en ciertos días tempranos casi no existían eventos `add_to_cart`.
- Para comparaciones justas, restringimos el análisis a: **`first_date >= 2020-11-25`**.

**Calidad de datos (validación mínima)**
- Comprobamos que en el periodo analizado no hay nulos ni errores de parseo en:
  - `user_pseudo_id`, `event_date`, `event_name`.

**Entregables (SQL)**
- Activación global en ventana temprana (D0–D3).
- Activación por cohorte (por `first_date`).

**Resultado clave**
- Activación global (ventana temprana D0–D3) en el periodo filtrado: ~**4.93%**.

---

## EN — What we did
**Sprint goal**
- Define and compute the primary metric: **Early activation = % of users with `add_to_cart` within the early window (D0–D3)** since `first_date`.

**Scope decisions**
- We observed early days with near-zero `add_to_cart` volume.
- To ensure fair comparisons, we restricted scope to: **`first_date >= 2020-11-25`**.

**Data quality (minimal validation)**
- Confirmed no nulls or parsing issues in-scope for:
  - `user_pseudo_id`, `event_date`, `event_name`.

**Deliverables (SQL)**
- Global early-window activation KPI (D0–D3).
- Cohort activation by `first_date`.

**Key result**
- Global activation (early window D0–D3) in filtered period: ~**4.93%**.