# Methodology / Metodología

## ES — Ventanas temporales

* `first_date`: primer día con actividad del usuario (parseado desde `event_date`).
* Ventana 72h (aprox por día calendario): `first_date` … `first_date + 3 days`.
* Calidad (sin solapamiento): retención post-72h = actividad entre `first_date + 4` … `first_date + 30`.

## ES — Por qué “usuario” vs “sesión”

* **Métricas por usuario**: cada usuario cuenta 1 vez (evita sesgo si alguien repite eventos muchas veces).
* **Métricas por sesión**: útil para medir eficiencia del flujo en una visita (ej. Search → View item por sesión).
* En este proyecto:

  * Activación (`add_to_cart_72h`) se evalúa **por usuario**.
  * Search → Product View se evalúa **por sesión** (mide calidad del buscador).

## ES — Alcance temporal (filtro 2020-11-25)

Al detectar días con casi cero `add_to_cart`, restringimos a `first_date >= 2020-11-25` para evitar cohortes con “cero oportunidad”.

## ES — Limitaciones

* Las “72h” están aproximadas por **fecha** (día), no por timestamp exacto.
* Los “what-if” son estimaciones descriptivas (no prueban causalidad).
* Dataset es un sample obfuscado de GA4: no representa un negocio real 1:1.

---

## EN — Time windows

* `first_date`: user's first active day (parsed from `event_date`).
* 72h window (calendar-day approximation): `first_date` … `first_date + 3 days`.
* Quality metric (non-overlapping): post-72h retention = activity in `first_date + 4` … `first_date + 30`.

## EN — Why “user” vs “session”

* **User-level**: each user counted once (reduces bias from repeated events).
* **Session-level**: useful to measure efficiency within a visit (e.g., Search → View item per session).
* In this project:

  * Activation (`add_to_cart_72h`) is **user-level**.
  * Search → Product View is **session-level**.

## EN — Scope filter (2020-11-25)

We observed days with near-zero `add_to_cart`, so we restricted to `first_date >= 2020-11-25` to avoid “no-opportunity” cohorts.

## EN — Limitations

* “72h” is approximated using date-level data (not exact timestamps).
* What-if scenarios are descriptive, not causal.
* GA4 public dataset is obfuscated/sample data.
