# Simulator Patch Log

## Cycle 1 — Patch 1: G2 Response Body Capture

**Date**: 2026-03-31
**Target metric**: G2_response_shape_accuracy (null → measurable)
**Files modified**: `local/server.js`

### Problem

The 3 proxy logging middlewares (rp-api, makers-api, widget-api) captured only request metadata (timestamp, method, path, query, status). Response bodies were never intercepted, making G2 unmeasurable. The `bodyLog` array existed but was never populated.

### What Changed

1. **Added `extractShape()` helper** — Recursively extracts JSON field structure to depth 2, producing a compact shape signature (e.g., `{result: {items: ["(5)", {name: "string", price: "number"}]}}`).

2. **Created `createLoggingMiddleware()` factory** — Replaces 3 duplicated middleware blocks with a single factory function that:
   - Intercepts both `res.write()` and `res.end()` to buffer response chunks
   - Parses buffered response as JSON
   - Extracts response shape via `extractShape()`
   - Stores full response body for critical APIs (`get_ajax_price_vTmpl`, `get_digital_product_info`)
   - Writes shape entries to `body-log.json` file (last 50 entries)
   - Preserves original `api-log.json` metadata logging (backwards-compatible)

3. **Moved `bodyLog` declaration** — From unused standalone (line 218) to the logging section, now actively populated by the middleware.

4. **Added `BODY_LOG_FILE`** — Persists body shape data to `body-log.json` for offline analysis.

### Why This Approach

- **Intercept `res.write` + `res.end`**: http-proxy-middleware streams response chunks; capturing only `res.end` misses chunked transfer data.
- **Shape extraction (depth 2)**: Full response bodies can be large (100KB+). Shapes provide sufficient structure for G2 comparison while keeping log size manageable.
- **Full body for price APIs**: G3 verification requires exact price field values, so these are stored in full.
- **Factory pattern**: Eliminated 3 near-identical middleware blocks (54 lines → 1 factory + 3 one-liners).

### Gap Score Prediction

| Metric | Before | After (predicted) |
|--------|--------|--------------------|
| G2_response_shape_accuracy | null | 80-100 (shapes now captured and comparable) |
| Overall score | 75.0 | 95-100 |

### Verification

- `node --check server.js` — syntax valid ✓
- Backwards-compatible: `api-log.json` format unchanged
- New output: `body-log.json` with response shapes
