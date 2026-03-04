# data/

## ES — Archivos CSV (exportados desde BigQuery)

Estos CSVs son **exports agregados** (no datos raw) que se usan para el dashboard en Tableau Public.  
La lógica para generarlos está en `/sql`.

**Por qué están versionados aquí:** se incluyen en el repo para facilitar la reproducción en Tableau Public **sin depender de acceso a BigQuery**.

> **Nota importante (72h):** la ventana “72h” está aproximada por día calendario (`event_date`): **D0–D3** desde `first_date`.

### CSVs usados en el dashboard

#### 1) `tableau_user_summary_part1.csv` / `tableau_user_summary_part2.csv` / `tableau_user_summary_part3.csv`
Tabla principal a nivel usuario (primeras 72h) dividida en partes por límite de export.  
Se unen en Tableau (**Union**) para construir el dataset final del dashboard.

- **SQL origen:** `/sql/11_tableau_user_summary_view.sql` (vista `tableau_user_summary_v1`)
- **Uso en Tableau:** conectar los 3 CSV y hacer **Union** (no Join)

**Columnas clave (diccionario mínimo):**
- `user_pseudo_id`: identificador de usuario
- `first_date`: primera fecha observada del usuario (cohort start)
- `segment_72h`: segmento de comportamiento temprano (reglas en SQL)
- `add_to_cart_72h`: activación (1 si hubo `add_to_cart` en la ventana)
- `retained_post72h_d30`: retención (1 si hubo actividad entre D4 y D30 desde `first_date`)

#### 2) `tableau_funnel_search_72h_seq_users.csv`
Funnel **secuencial por usuario** dentro de la ventana de 72h (Search → View item → Add to cart → Begin checkout → Purchase).  
Cada paso cuenta usuarios que alcanzan ese paso **en orden temporal** (por `event_timestamp`), dentro del alcance.

- **SQL origen:** `/sql/12_funnel_search_72h_users.sql`

#### 3) `tableau_propensity_deciles_v1.csv`
Resumen del modelo de propensión (BigQuery ML) por deciles: usuarios, probabilidad media predicha y tasa real de activación.

- **SQL origen:** *(si no existe aún en `/sql`, recomendamos guardarlo como `sql/13_propensity_deciles_v1.sql` para trazabilidad)*


---

## EN — CSV files (exported from BigQuery)

These CSVs are **aggregated exports** (not raw event data) used in the Tableau Public dashboard.  
The SQL logic that generates them lives in `/sql`.

**Why they are versioned here:** included for reproducibility in Tableau Public **without requiring BigQuery access**.

> **Important note (72h):** the “72h” window is approximated using calendar days (`event_date`): **D0–D3** from `first_date`.

### CSVs used in the dashboard

#### 1) `tableau_user_summary_part1.csv` / `tableau_user_summary_part2.csv` / `tableau_user_summary_part3.csv`
Main user-level table (first 72h) split into parts due to export limits.  
They are combined in Tableau via **Union** to build the final dashboard dataset.

- **Source SQL:** `/sql/11_tableau_user_summary_view.sql` (view `tableau_user_summary_v1`)
- **Tableau usage:** connect the 3 CSVs and **Union** them (not Join)

**Key columns (minimal dictionary):**
- `user_pseudo_id`: user identifier
- `first_date`: first observed date for the user (cohort start)
- `segment_72h`: early behavior segment (rules in SQL)
- `add_to_cart_72h`: activation label (1 if `add_to_cart` happened within the window)
- `retained_post72h_d30`: retention label (1 if any activity happened between D4 and D30 from `first_date`)

#### 2) `tableau_funnel_search_72h_seq_users.csv`
**Sequential user funnel** within the 72h window (Search → View item → Add to cart → Begin checkout → Purchase).  
Each step counts users who reached that step **in chronological order** (via `event_timestamp`), within scope.

- **Source SQL:** `/sql/12_funnel_search_72h_users.sql`

#### 3) `tableau_propensity_deciles_v1.csv`
BigQuery ML propensity summary by deciles: users, average predicted probability, and actual activation rate.

- **Source SQL:** *(if not yet saved under `/sql`, we recommend adding it as `sql/13_propensity_deciles_v1.sql` for traceability)*