# GA4 — Early Activation Diagnostics (BigQuery + Tableau)

## ES — Resumen ejecutivo
**Objetivo de negocio:** aumentar la **activación temprana** (usuarios que añaden al carrito en su primera ventana de comportamiento) e identificar **dónde se pierde** el usuario en el journey de búsqueda.

**Dataset:** GA4 public sample ecommerce (BigQuery).  
**Cohorte (scope):** `first_date >= 2020-11-25`.  
**Ventana temprana (v1):** aproximación por día calendario con `event_date`: **D0–D3** desde `first_date`.

**Métrica principal:** **Add-to-cart rate (early window)** (usuarios únicos).  
**Métricas de diagnóstico:** Search → Product View rate (session-level), funnel secuencial de búsqueda, activación por segmentos tempranos y calibración de un modelo de propensión (BigQuery ML).

**Insights clave (high-level):**
- La mayor caída del funnel ocurre en **Search → View item** (bottleneck de descubrimiento).
- Señales de engagement en PDP (view_item + scroll) se asocian a mayor activación.
- El modelo de propensión ordena usuarios por probabilidad de activación y sirve para priorizar tests (no causal).

**Acciones recomendadas (prioridad):**
1) Mejorar **Search → View item** (relevancia, sugerencias, ranking, UX “no results”).  
2) Aumentar engagement en PDP (layout, performance, CTA visible, recomendaciones).  
3) Usar deciles de propensión para priorizar experimentos/personalización.

---

## ES — Arquitectura del proyecto / Data Flow
Flujo general del proyecto:

GA4 Public Dataset (BigQuery)  
↓  
SQL transformations (cohort definition, feature engineering, segmentación)  
↓  
BI-ready tables (user-level summaries, funnel tables, propensity deciles)  
↓  
Export a CSV (por límites de Tableau Public)  
↓  
Dashboard en Tableau Public

El procesamiento principal se realiza en BigQuery utilizando SQL.  
Las tablas finales se exportan como datasets agregados para visualización en Tableau.

---

## ES — Modelo de datos (simplificado)
Las tablas analíticas principales se construyen a **nivel usuario** usando `user_pseudo_id`.

Tabla conceptual (features early window, D0–D3):

| Campo | Descripción |
|------|-------------|
| user_pseudo_id | Identificador de usuario |
| first_date | Primera fecha observada |
| search_early | Usuario realizó búsqueda en ventana temprana |
| view_item_early | Usuario vio producto |
| scroll_early | Usuario hizo scroll en PDP |
| add_to_cart_early | Usuario añadió al carrito (métrica objetivo) |
| sessions_early | Nº de sesiones (por `ga_session_id`) en la ventana temprana |
| view_item_events_early | Nº de eventos `view_item` en la ventana temprana |
| segment_early | Segmento por reglas (buyer, checkout_intent, viewer_scroll, …) |
| retained_post_window_d30 | Actividad en D4–D30 (métrica de “calidad”) |

Estas features se usan para:
- segmentación temprana
- análisis de funnel
- entrenamiento del modelo de propensión
- dataset final para Tableau

---

## ES — Modelo de propensión (overview)
Se entrena un modelo baseline de **regresión logística** usando BigQuery ML para:

**Objetivo:** predecir la probabilidad de que un usuario haga `add_to_cart` durante la ventana temprana (D0–D3).  
**Features:** flags de comportamiento (search, view_item, scroll, checkout/purchase), contadores ligeros (sesiones, eventos).  
**Evaluación / lectura:** se generan **deciles de propensión** (`NTILE(10)`) sobre la probabilidad predicha para observar:
- ranking de usuarios por probabilidad de activación
- calibración entre probabilidad predicha y tasa real de activación

El modelo se usa como **herramienta de priorización**, no como sistema predictivo en producción.

---

## ES — Métricas clave (snapshot)
Ejemplo de métricas observadas (scope: `first_date >= 2020-11-25`):

| Métrica | Valor |
|---|---:|
| Add-to-cart rate (early window, D0–D3) | ~4.93% |
| Search → Product View rate (session-level, global) | ~46.88% |
| Funnel: Search → View item (user-level, secuencial) | ~23.89% |
| Funnel: View item → Add to cart (user-level, secuencial) | ~35.48% |
| Post-window retention (D4–D30) — activados | ~14.80% |
| Post-window retention (D4–D30) — no activados | ~3.55% |

Esto sugiere que el principal bottleneck está en **descubrimiento de producto** (Search → View item) y que activar en ventana temprana se asocia a **mayor “calidad”** post-ventana.

---

## ES — Entregables
- **Dashboard en Tableau** (resumen + diagnósticos)
- **Catálogo de SQL** (BigQuery): cohorte, segmentación, funnel, “what-if”, ML
- **Reportes** en `/reports` con definiciones e interpretación

## ES — Estructura del repositorio
- `/sql` → queries de BigQuery usadas en el proyecto
- `/data` → CSVs agregados exportados para Tableau Public
- `/docs` → metodología, guía del dashboard, brief
- `/reports` → narrativa y resultados

## ES — Cómo reproducir (rápido)
1) Ejecutar las queries en BigQuery (ver `/sql`).
2) Exportar salidas “BI-ready” a CSV para Tableau Public (considerando límites de filas).
3) Construir el dashboard en Tableau usando los CSV exportados.

## ES — Dashboard
- Dashboard (Tableau Public): https://public.tableau.com/views/EarlyActivationEarlyBehaviorGA4EcommerceD0D3/Dashboard1?:language=es-ES&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link

---

## ES — Skills demostradas en el proyecto
- SQL analítico (BigQuery)
- Análisis de producto (cohortes, funnels, segmentación)
- Feature engineering a nivel usuario
- Modelado básico de ML (BigQuery ML)
- Visualización y storytelling (Tableau)
- Documentación técnica y trazabilidad
- Diagnóstico de métricas de producto

## ES — Aprendizajes del proyecto
- Definición de métricas de activación y ventanas temporales
- Diagnóstico de funnels de usuario y puntos de fricción
- Uso de proxies (session-level vs user-level)
- Diferencia entre correlación y causalidad (what-if no causal)
- Importancia de documentar limitaciones analíticas

## ES — Nota de transparencia (IA)
Este es uno de mis primeros proyectos end-to-end de analítica de producto.  
He utilizado **ChatGPT/IA como apoyo** para iterar sobre documentación, naming y estructura de queries (manteniendo yo la ejecución, validación de resultados y decisiones analíticas).

---

## EN — Executive summary
**Business goal:** increase **early activation** (users adding to cart within the first behavior window) and identify **where users drop** in the search journey.

**Dataset:** GA4 public sample ecommerce (BigQuery).  
**Scope cohort:** `first_date >= 2020-11-25`.  
**Early window (v1):** calendar-day approximation using `event_date`: **D0–D3** from `first_date`.

**North-star metric:** **Add-to-cart rate (early window)** (unique users).  
**Diagnostic metrics:** session-level Search → Product View rate, sequential search funnel, activation by early segments, and a BigQuery ML propensity model calibration.

**Key insights (high-level):**
- The largest funnel drop is **Search → View item** (discovery bottleneck).
- PDP engagement signals (view_item + scroll) correlate with higher activation.
- The propensity model ranks users by activation likelihood to help prioritize tests (non-causal).

**Recommended actions (priority):**
1) Improve **Search → View item** (relevance, suggestions, ranking, “no results” UX).  
2) Increase PDP engagement (layout, performance, visible CTA, recommendations).  
3) Use propensity deciles to prioritize experiments/personalization.

---

## EN — Project architecture / Data Flow
Overall pipeline:

GA4 Public Dataset (BigQuery)  
↓  
SQL transformations (cohorting, feature engineering, segmentation)  
↓  
BI-ready tables (user-level summaries, funnel tables, propensity deciles)  
↓  
Export to CSV (due to Tableau Public limits)  
↓  
Tableau Public dashboard

Core processing happens in BigQuery using SQL.  
Final outputs are exported as aggregated datasets for visualization in Tableau.

---

## EN — Data model (simplified)
Core analytical tables are built at **user level** using `user_pseudo_id`.

Conceptual early-window feature table (D0–D3):

| Field | Description |
|------|-------------|
| user_pseudo_id | User identifier |
| first_date | First observed date |
| search_early | Search in early window |
| view_item_early | Product view |
| scroll_early | PDP scroll |
| add_to_cart_early | Added to cart (target) |
| sessions_early | # sessions (by `ga_session_id`) in early window |
| view_item_events_early | # `view_item` events in early window |
| segment_early | Rule-based segment (buyer, checkout_intent, viewer_scroll, …) |
| retained_post_window_d30 | Activity in D4–D30 (quality metric) |

These features power:
- early segmentation
- funnel diagnostics
- propensity model training
- the Tableau-ready dataset

---

## EN — Propensity model (overview)
A baseline **logistic regression** model is trained using BigQuery ML.

**Goal:** predict the probability a user triggers `add_to_cart` during the early window (D0–D3).  
**Features:** behavior flags (search, view_item, scroll, checkout/purchase) + light counts (sessions, events).  
**Evaluation/reading:** **propensity deciles** (`NTILE(10)`) are built from predicted probabilities to observe:
- user ranking by activation likelihood
- calibration between predicted probability and actual activation

This model is used as a **prioritization tool**, not a production predictor.

---

## EN — Key metrics (snapshot)
Example observed metrics (scope: `first_date >= 2020-11-25`):

| Metric | Value |
|---|---:|
| Add-to-cart rate (early window, D0–D3) | ~4.93% |
| Search → Product View rate (session-level, global) | ~46.88% |
| Funnel: Search → View item (user-level, sequential) | ~23.89% |
| Funnel: View item → Add to cart (user-level, sequential) | ~35.48% |
| Post-window retention (D4–D30) — activated | ~14.80% |
| Post-window retention (D4–D30) — not activated | ~3.55% |

This suggests the main bottleneck is **product discovery** (Search → View item), and early activation correlates with higher post-window “quality”.

---

## EN — Deliverables
- **Tableau dashboard** (summary + diagnostics)
- **SQL catalog** (BigQuery): cohorting, segmentation, funnel, what-if, ML
- **Reports** in `/reports` with definitions and interpretation

## EN — Repository structure
- `/sql` → BigQuery queries used in the project
- `/data` → exported aggregated CSVs for Tableau Public
- `/docs` → methodology, dashboard guide, brief
- `/reports` → narrative and results

## EN — How to reproduce (quick)
1) Run the SQL queries in BigQuery (see `/sql`).
2) Export BI-ready outputs to CSV for Tableau Public (row limits considered).
3) Build the dashboard in Tableau using the exported CSVs.

## EN — Dashboard
- Dashboard (Tableau Public): https://public.tableau.com/views/EarlyActivationEarlyBehaviorGA4EcommerceD0D3/Dashboard1?:language=es-ES&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link

---

## EN — Skills demonstrated
- Analytical SQL (BigQuery)
- Product analytics (cohorts, funnels, segmentation)
- User-level feature engineering
- Basic ML modeling (BigQuery ML)
- Data visualization & storytelling (Tableau)
- Technical documentation & traceability
- Product metric diagnostics

## EN — Learning outcomes
- Defining activation metrics and time windows
- Diagnosing user funnels and friction points
- Using proxies (session-level vs user-level)
- Distinguishing correlation vs causality (non-causal what-if)
- Documenting analytical limitations clearly

## EN — Transparency note (AI)
This is one of my first end-to-end product analytics portfolio projects.  
I used **ChatGPT/AI as support** to iterate on documentation, naming, and query structure (while I executed the work, validated results, and made the analytical decisions).