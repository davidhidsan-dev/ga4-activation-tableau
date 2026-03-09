# GA4 — Early Activation Diagnostics (BigQuery + Tableau)

> Versión en español: [README.md](README.md)

## Quick navigation
- Public dashboard: https://public.tableau.com/views/EarlyActivationEarlyBehaviorGA4EcommerceD0D3/Dashboard1?:language=es-ES&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link
- Methodology: [`docs/methodology.md`](docs/methodology.md)
- Project brief: [`docs/project_brief.md`](docs/project_brief.md)
- SQL catalog: [`docs/sql_catalog.md`](docs/sql_catalog.md)
- Dashboard guide: [`docs/dashboard_guide.md`](docs/dashboard_guide.md)
- Executive summary: [`reports/executive_summary.md`](reports/executive_summary.md)
- Limitations & next steps: [`reports/limitations_and_next_steps.md`](reports/limitations_and_next_steps.md)

## How to read this repo
If you want a quick pass:
1. Read this README
2. Open the dashboard
3. Skim the executive summary
4. Use methodology + SQL catalog for the technical details

---

## Summary
This project looks at **early user behavior** in a GA4 ecommerce sample dataset to understand what signals are associated with **activation** (triggering `add_to_cart`) and where the **search → product** journey shows the biggest drop-offs.

**Dataset:** GA4 public sample ecommerce (BigQuery).  
**Scope cohort:** `first_date >= 2020-11-25`.  
**Early window (v1):** calendar-day approximation using `event_date`: **D0–D3** from `first_date`.

**North-star metric:** **Add-to-cart rate (early window)** (unique users).  
**Diagnostic metrics:** session-level Search → Product View rate, sequential search funnel, activation by early segments, and BigQuery ML propensity model calibration.

**Main observations (high level):**
- In the search funnel, the largest drop is at **Search → View item**.
- PDP engagement signals (e.g., `view_item` + `scroll`) correlate with higher activation.
- The propensity model ranks users by activation likelihood; it’s used as a baseline for prioritization (non-causal).

**Hypotheses to validate:**
1) Explore improvements to **Search → View item** (relevance, ranking, suggestions, “no results” UX).  
2) Explore PDP changes (layout, performance, visible CTA, recommendations).  
3) Use propensity deciles to prioritize analysis/experiments (not causal).

---

## Project architecture / Data Flow
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

## Feature table (simplified)
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
| retained_post_window_d30 | Activity in D4–D30 (post-window metric) |

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
**Reading:** **propensity deciles** (`NTILE(10)`) are built from predicted probabilities to observe:
- user ranking by activation likelihood
- relationship between predicted probability and actual activation rate

This model is used as a **baseline for analysis/prioritization**, not a production predictor.

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

Conservative read: the main drop is in **product discovery** (Search → View item). Early activation is associated with higher post-window activity (this does not imply causality).

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

---

## Skills demonstrated
- Analytical SQL (BigQuery)
- Cohorts, funnels, and behavior-based segmentation
- User-level feature engineering
- Baseline ML modeling (BigQuery ML)
- Data visualization (Tableau)
- Technical documentation & traceability

## Learning outcomes
- Defining metrics and time windows
- User-level vs session-level trade-offs
- Sequential funnels and drop-off reading
- Correlation vs causality (non-causal what-if)
- Clear scoping and limitations

## Possible technical improvements (v2)
- Rebuild the early window using `event_timestamp` (instead of `event_date`) and compare against the D0–D3 approximation.
- Make the separation between observation window (features) vs outcome window (label) more explicit.
- Add device/channel breakdowns (if available) to compare behavior patterns.
- Benchmark one more BQML baseline (e.g., boosted trees) and evaluate with a time-based split (not only random).

---

## Transparency note (AI)
This is one of my first end-to-end product analytics portfolio projects.  
I used **ChatGPT/AI as support** to iterate on documentation, naming, and query structure (while I executed the work, validated results, and made the analytical decisions).

---

## Dashboard
[![Dashboard preview](docs/images/dashboard.png)](https://public.tableau.com/views/EarlyActivationEarlyBehaviorGA4EcommerceD0D3/Dashboard1?:language=es-ES&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)