# Data Notes / Notas de Datos

## ES — Sanity check temporal (add_to_cart)

Al analizar la activación por cohorte (`first_date`), observamos muchos días con tasa 0%.
Para validar si era un problema de la métrica o del dataset, contamos eventos `add_to_cart` por día (`event_date`).

**Resultado:** el dataset tiene días (especialmente a inicios de noviembre 2020) con muy pocos o cero eventos `add_to_cart`.
Esto provoca cohortes con “cero oportunidad” real de activar y distorsiona comparaciones por fecha.

**Decisión:** para un análisis comparable, restringimos el alcance a usuarios con:

* `first_date >= 2020-11-25`

**Impacto:** los KPIs (activación, segmentos y funnel) se vuelven más estables y comparables entre cohortes, evitando sesgo por días sin volumen de activación.

**Trazabilidad (SQL):**

* Activación por cohorte: `02_activation_add_to_cart_early_by_cohort.sql`
* Conteo de eventos por día (sanity): `00b_sanity_add_to_cart_volume_by_day.sql`

---

## EN — Time sanity check (add_to_cart)

When analyzing activation by cohort (`first_date`), many days showed 0% activation.
To validate whether this was a metric issue or a dataset issue, we counted `add_to_cart` events by day (`event_date`).

**Result:** the dataset contains days (especially early Nov 2020) with very low or zero `add_to_cart` volume.
This creates “no-opportunity” cohorts and makes time comparisons misleading.

**Decision:** to ensure comparable analysis, we restrict scope to users with:

* `first_date >= 2020-11-25`

**Impact:** KPIs (activation, segments, funnel) become more stable and cohort comparisons more meaningful by avoiding near-zero activation days.

**Traceability (SQL):**

* Cohort activation: `02_activation_add_to_cart_early_by_cohort.sql`
* Daily event volume check (sanity): `00b_sanity_add_to_cart_volume_by_day.sql`