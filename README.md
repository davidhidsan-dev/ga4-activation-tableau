# GA4 — 72h Activation Diagnostics (BigQuery + Tableau)

## ES — Resumen ejecutivo
**Objetivo de negocio:** aumentar la **activación temprana** (usuarios que añaden al carrito en sus primeras 72h) e identificar **dónde se pierde** el usuario en el journey de búsqueda.

**Dataset:** GA4 public sample ecommerce (BigQuery).  
**Cohorte:** `first_date >= 25/11/2020`.  
**Ventana temprana:** eventos en D0–D3 desde first_date (aprox. “72h” por día calendario).

**Métrica principal:** **Add-to-cart rate (72h)** (usuarios únicos).  
**Métricas de diagnóstico:** Search → Product View rate (session-level, para usuarios en scope), funnel de búsqueda, activación por segmentos (72h), y calibración de un modelo de propensión.
**Nota:** el proxy de búsqueda se calcula por sesión y no se limita a la ventana temprana.

**Insights clave (high-level):**
- La mayor caída ocurre en **Search → View item** (bottleneck de descubrimiento).
- Señales de engagement temprano (ver producto + scroll) se asocian a mayor activación.
- El modelo de propensión ordena usuarios por probabilidad de activación y sirve para priorizar tests.

**Acciones recomendadas (prioridad):**
1) Mejorar **Search → View item** (relevancia, sugerencias, ranking, UX “no results”).  
2) Aumentar engagement en PDP (scroll/related items) para elevar add-to-cart.  
3) Usar deciles de propensión para priorizar experimentos/personalización.

---

## ES — Entregables
- **Dashboard en Tableau** (resumen + diagnósticos)
- **Catálogo de SQL** (BigQuery): cohorte, segmentación, funnel, escenarios de uplift, ML
- **Reportes cortos** en `/reports` con definiciones e interpretación

## ES — Datos y definiciones (high-level)
- **first_date:** primera fecha observada por usuario (`MIN(event_date)`).
- **Ventana temprana (72h):** `first_date` → `first_date + 3 días` (D0–D3, por día calendario).
- **Activación (72h):** usuario con al menos un `add_to_cart` dentro de 72h.
- **Searchers:** usuarios con al menos un `view_search_results` dentro de 72h.
- **Segmentos (72h):** reglas basadas en comportamiento temprano (ver SQL).


## ES — Estructura del repositorio
- `/sql` → todas las queries de BigQuery usadas en el proyecto
- `/reports` → interpretaciones escritas (ej. reporte del funnel)
- `/docs` → notas / brief del proyecto (opcional)

## ES — Cómo reproducir (rápido)
1) Ejecutar las queries en BigQuery (ver `/sql`).
2) Exportar salidas “BI-ready” como CSV para Tableau Public (teniendo en cuenta límites de filas).
3) Construir el dashboard en Tableau usando las tablas exportadas.

## ES — Dashboard
- Dashboard (Tableau Public): https://public.tableau.com/app/profile/david.hidalgo.s.nchez/viz/Libro1_17724829569200/Dashboard1?publish=yes

---

## EN — Executive summary
**Business goal:** increase **early activation** (users adding to cart within first 72h) and identify **where users drop** in the search journey.

**Dataset:** GA4 public sample ecommerce (BigQuery).  
**Cohort:** `first_date >= 2020-11-25`.  
**Early window:** events in D0–D3 from first_date (calendar-day “72h” approximation).

**North-star metric:** **Add-to-cart rate (72h)** (unique users).  
**Diagnostic metrics:** Search → Product View rate (session-level, scoped users), search funnel, activation by 72h segments, and propensity model calibration.
**Note:** the search proxy is computed at session level and is not restricted to the early window.

**Key insights (high-level):**
- The largest drop occurs at **Search → View item** (discovery bottleneck).
- Early engagement signals (product view + scroll) correlate with higher activation.
- The propensity model ranks users by activation likelihood and helps prioritize experiments.

**Recommended actions (priority):**
1) Improve **Search → View item** (relevance, suggestions, ranking, “no results” UX).  
2) Increase PDP engagement (scroll/related items) to lift add-to-cart.  
3) Use propensity deciles to prioritize experiments/personalization.

---

## EN — Deliverables
- **Tableau dashboard** (summary + diagnostics)
- **SQL catalog** (BigQuery): cohorting, segmentation, funnel, uplift scenarios, ML
- **Short reports** in `/reports` with definitions and interpretation

## EN — Data & definitions (high-level)
- **first_date:** first observed event date per user (`MIN(event_date)`).
- **Early window (approx. 72h):** `first_date` → `first_date + 3 days` (D0-D3, calendar day).
- **Activation (72h):** user has at least one `add_to_cart` event within 72h.
- **Searchers:** users with at least one `view_search_results` within 72h.
- **Segments (72h):** rule-based categories from early behavior (see SQL).

**Note:** the “72h” window is approximated by calendar day (event_date): D0–D3 from first_date.

## EN — Repository structure
- `/sql` → all BigQuery queries used in the project
- `/reports` → written interpretations (e.g., funnel report)
- `/docs` → notes / project brief (optional)

## EN — How to reproduce (quick)
1) Run SQL queries in BigQuery (see `/sql`).
2) Export BI-ready outputs as CSV for Tableau Public (row limits considered).
3) Build the dashboard in Tableau using the exported tables.

## EN — Dashboard
- Dashboard (Tableau Public): https://public.tableau.com/app/profile/david.hidalgo.s.nchez/viz/Libro1_17724829569200/Dashboard1?publish=yes