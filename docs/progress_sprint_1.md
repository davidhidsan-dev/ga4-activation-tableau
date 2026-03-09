# Progress — Sprint 1 / Progreso — Sprint 1

## ES — Qué hicimos
**Objetivo del sprint**
- Definir y calcular la métrica principal: **activación temprana = % de usuarios con `add_to_cart` dentro de la ventana temprana (D0–D3)** desde `first_date`.

**Decisiones de alcance**
- Vimos que había días (al inicio del periodo) con volumen muy bajo o cero de `add_to_cart`.
- Para que las cohortes fueran comparables, acotamos el análisis a: **`first_date >= 2020-11-25`**.

**Calidad de datos (validación mínima)**
- Verificamos que, en el alcance elegido, no hay nulos ni problemas de parseo en:
  - `user_pseudo_id`, `event_date`, `event_name`.

**Entregables (SQL)**
- KPI global de activación en ventana temprana (D0–D3).
- Activación por cohorte (por `first_date`).

**Resultado clave**
- Activación global (ventana temprana D0–D3) en el periodo filtrado: ~**4.93%**.

---

## EN — What we did
**Sprint goal**
- Define and compute the primary metric: **early activation = % of users with `add_to_cart` within the early window (D0–D3)** since `first_date`.

**Scope decisions**
- We saw days (early in the period) with very low or zero `add_to_cart` volume.
- To make cohorts comparable, we restricted scope to: **`first_date >= 2020-11-25`**.

**Data quality (minimal validation)**
- We checked that, within the chosen scope, there are no nulls or date parsing issues for:
  - `user_pseudo_id`, `event_date`, `event_name`.

**Deliverables (SQL)**
- Global early-window activation KPI (D0–D3).
- Cohort activation by `first_date`.

**Key result**
- Global activation (early window D0–D3) in the filtered period: ~**4.93%**.