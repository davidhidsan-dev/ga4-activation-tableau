# Methodology / Metodología

## ES — Ventanas temporales

* `first_date`: primer día con actividad del usuario (parseado desde `event_date`).
* **Ventana temprana (v1):** aproximación por día calendario: `first_date` a `first_date + 3 days` (incluye D0–D3).
* **Calidad (sin solapamiento):** retención post-ventana = actividad entre `first_date + 4` … `first_date + 30`.

## ES — Por qué “usuario” vs “sesión”

* **Métricas por usuario:** cada usuario cuenta 1 vez (evita sesgo si alguien repite eventos muchas veces).
* **Métricas por sesión:** útil para medir eficiencia del flujo dentro de una visita (ej. Search → View item por sesión).

En este proyecto:

* **Activación (add_to_cart en ventana temprana):** se evalúa **por usuario**.
* **Search → Product View:** se evalúa **por sesión** (proxy de calidad del buscador).

**Importante (proxy de búsqueda):**
Search → Product View es **session-level** y se calcula sobre **todas las sesiones** de usuarios en scope (`first_date >= 2020-11-25`), **no** solo dentro de D0–D3.
Esto evita perder señal al limitarlo a la ventana temprana, pero debe interpretarse como métrica de **calidad de búsqueda**, no como comportamiento “temprano” estrictamente.

## ES — Alcance temporal (filtro 2020-11-25)

Al detectar días con casi cero `add_to_cart`, restringimos a `first_date >= 2020-11-25` para evitar cohortes con “cero oportunidad”.

## ES — Limitaciones

* La ventana temprana está aproximada por **fecha** (día), no por timestamp exacto.
* Los “what-if” son estimaciones descriptivas (no prueban causalidad).
* El dataset es un sample obfuscado de GA4: no representa un negocio real 1:1.

---

## EN — Time windows

* `first_date`: user's first active day (parsed from `event_date`).
* **Early window (v1):** calendar-day approximation: `first_date` to `first_date + 3 days` (includes D0–D3).
* **Quality (non-overlapping):** post-window retention = activity in `first_date + 4` … `first_date + 30`.

## EN — Why “user” vs “session”

* **User-level:** each user counted once (reduces bias from repeated events).
* **Session-level:** useful to measure funnel efficiency within a visit (e.g., Search → View item per session).

In this project:

* **Activation (add_to_cart in the early window):** computed at **user-level**.
* **Search → Product View:** computed at **session-level** (proxy for search quality).

**Important (search proxy):**
Search → Product View is **session-level** and is computed across **all sessions** from scoped users (`first_date >= 2020-11-25`), **not** only within D0–D3.
This preserves signal, but it should be interpreted as a **search quality** metric, not strictly “early behavior”.

## EN — Scope filter (2020-11-25)

We observed days with near-zero `add_to_cart`, so we restricted to `first_date >= 2020-11-25` to avoid “no-opportunity” cohorts.

## EN — Limitations

* The early window is approximated using date-level data (not exact timestamps).
* What-if scenarios are descriptive, not causal.
* The GA4 public dataset is obfuscated/sample data.