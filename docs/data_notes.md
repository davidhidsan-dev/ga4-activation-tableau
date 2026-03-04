# Data Notes / Notas de Datos

## ES — Sanity check temporal (add_to_cart)
Al analizar la activación por cohorte (`first_date`), observamos muchos días con tasa 0%.  
Para validar si era un problema de la métrica o del dataset, contamos eventos `add_to_cart` por día (`event_date`).

**Resultado:** el dataset tiene días (especialmente a inicios de noviembre 2020) con muy pocos o cero eventos `add_to_cart`.  
Esto provoca cohortes con “cero oportunidad” real de activar y distorsiona comparaciones por fecha.

**Decisión:** para análisis comparable, restringimos el alcance a usuarios con:
- `first_date >= 2020-11-25`

Este filtro se aplicará en los KPIs principales y en el dataset para Tableau.

---

## EN — Time sanity check (add_to_cart)
When analyzing activation by cohort (`first_date`), many days showed 0% activation.  
To validate whether this was a metric issue or a dataset issue, we counted `add_to_cart` events by day (`event_date`).

**Result:** the dataset contains days (especially early Nov 2020) with very low or zero `add_to_cart` volume.  
This creates cohorts with little “opportunity” to activate and makes time comparisons misleading.

**Decision:** to ensure comparable analysis, we restrict scope to users with:
- `first_date >= 2020-11-25`

This filter will be applied to core KPIs and the Tableau-ready dataset.