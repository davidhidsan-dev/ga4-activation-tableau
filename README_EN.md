# GA4 — Early Activation Diagnostics (BigQuery + Tableau)

> Versión en español: [README.md](README.md)

## Executive summary
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

## Project architecture / Data Flow
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

## Data model (simplified)
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

## Propensity model (overview)
A baseline **logistic regression** model is trained using BigQuery ML.

**Goal:** predict the probability a user triggers `add_to_cart` during the early window (D0–D3).  
**Features:** behavior flags (search, view_item, scroll, checkout/purchase) + light counts (sessions, events).  
**Evaluation/reading:** **propensity deciles** (`NTILE(10)`) are built from predicted probabilities to observe:
- user ranking by activation likelihood
- calibration between predicted probability and actual activation

This model is used as a **prioritization tool**, not a production predictor.

---

## Key metrics (snapshot)
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

## Deliverables
- **Tableau dashboard** (summary + diagnostics)
- **SQL catalog** (BigQuery): cohorting, segmentation, funnel, what-if, ML
- **Reports** in `/reports` with definitions and interpretation

## Repository structure
- `/sql` → BigQuery queries used in the project
- `/data` → exported aggregated CSVs for Tableau Public
- `/docs` → methodology, dashboard guide, brief
- `/reports` → narrative and results

## How to reproduce (quick)
1) Run the SQL queries in BigQuery (see `/sql`).
2) Export BI-ready outputs to CSV for Tableau Public (row limits considered).
3) Build the dashboard in Tableau using the exported CSVs.

## Dashboard
- Dashboard (Tableau Public): https://public.tableau.com/views/EarlyActivationEarlyBehaviorGA4EcommerceD0D3/Dashboard1?:language=es-ES&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link

---

## Skills demonstrated
- Analytical SQL (BigQuery)
- Product analytics (cohorts, funnels, segmentation)
- User-level feature engineering
- Basic ML modeling (BigQuery ML)
- Data visualization & storytelling (Tableau)
- Technical documentation & traceability
- Product metric diagnostics

## Learning outcomes
- Defining activation metrics and time windows
- Diagnosing user funnels and friction points
- Using proxies (session-level vs user-level)
- Distinguishing correlation vs causality (non-causal what-if)
- Documenting analytical limitations clearly

## Transparency note (AI)
This is one of my first end-to-end product analytics portfolio projects.  
I used **ChatGPT/AI as support** to iterate on documentation, naming, and query structure (while I executed the work, validated results, and made the analytical decisions).

## Dashboard

[![Dashboard preview](docs/images/dashboard.png)](https://public.tableau.com/views/EarlyActivationEarlyBehaviorGA4EcommerceD0D3/Dashboard1?:language=es-ES&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)