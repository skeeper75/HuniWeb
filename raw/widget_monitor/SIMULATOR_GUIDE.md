# RedPrinting Widget Precision Analyzer -- Usage Guide

## Startup

```bash
cd _workspace/widget_monitor/local
npm install          # first time only (express, http-proxy-middleware, dotenv)
node server.js       # starts on http://localhost:3001
```

Prerequisites:
- `cookies.json` -- session cookies (run `node extract-cookies.cjs` to generate)
- `.env` with `RP_EDITOR_TOKEN` -- editor JWT (auto-refreshed if expired)
- `widget.js` -- RedPrinting widget SDK
- `RedEditorSDK.min.js` -- Edicus editor SDK
- `catalog.json` -- product catalog

## 5-Tab Analysis Platform

### Tab 1: Widget Monitor

Displays the live Pinia store state from the widget's Shadow DOM.

- **Diff highlighting**: On each refresh, changes from the previous snapshot are shown at the top:
  - Green = newly added keys
  - Yellow = changed values
  - Red = removed keys
- **Auto-refresh toggle**: Click "Auto 2s" button in the toolbar to enable/disable 2-second auto-refresh
- **Store history**: Last 50 snapshots are retained in memory for session export

### Tab 2: Editor Flow

Captures and displays the full Edicus editor lifecycle.

- **Lifecycle state machine**: Horizontal bar showing progression through:
  `init -> ready-to-listen -> doc-changed -> project-id-created -> save-doc-report:start -> save-doc-report:end -> goto-cart/close`
  The current state is highlighted green; past states are dimmed.
- **Event Timeline**: Chronological list of all `from-edicus` postMessage events. Click any event to expand its full `info` payload.
- **goto-cart Payload**: When the editor completes, shows the final `{projectID, tnUrlList, totalPageCount}` data.
- **Store Delta**: After editor closes, shows diff between pre-editor and post-editor Pinia snapshots.

### Tab 3: Network Inspector

Enhanced API request log with timing and waterfall visualization.

- **Live table**: timestamp | method | path | status | duration(ms) | waterfall bar
- **Click to expand**: Click any row to see full request headers and response body (JSON pretty-printed)
- **Waterfall bars**: CSS-only proportional bars showing relative request duration
- **Export**: "Session JSON Download" button exports the complete session (network log, events, store snapshots, editor payload) as a single JSON file

### Tab 4: Comparison

Side-by-side analysis of current session vs captured data from other products or platforms.

- **Left panel**: Current session's API calls and postMessage events
- **Right panel**: Load comparison data from pre-captured files:
  - Click any capture button (v2_GSTGMIC, v2_PRBKORD, etc.)
  - Or use the file input to load a local JSON file
- **Diff view**: Highlights matching vs diverging API endpoints between sessions
- **Key Differences**: Auto-generated summary of what is in one session but not the other

Available capture files served from `/captures/`:
- `v2_GSTGMIC_capture.json` -- Goods/acrylic product
- `v2_PRBKORD_capture.json` -- Book/print product (standard)
- `v2_ACNTHAP_capture.json` -- Acrylic product
- `v2_PRBKOPR_capture.json`, `v2_PRBKOST_capture.json`, `v2_PRBKYPR_capture.json` -- Book variants
- `monitor_summary_v2.json` -- Aggregated summary

### Tab 5: Insights

Analysis insights for Huni platform development, seeded with static observations.

- **Categories**: UX Flow | API Design | Pricing Model | Editor Integration
- **Columns**: Category | Platform | Observation | Huni Recommendation
- **Dynamic insights**: When comparison data is loaded in Tab 4, additional insights are auto-generated (e.g., unique endpoint count, price-related API detection)

## Server Routes

| Route | Target |
|---|---|
| `/rp-api/*` | `https://www.redprinting.co.kr` |
| `/widget-api/*` | `https://widget-api.redprinting.co.kr` |
| `/makers-api/*` | `https://makers.redprinting.net` |
| `/wow-proxy/*` | `https://print.wowpress.co.kr` |
| `/captures/*` | Static files from `_workspace/widget_monitor/` (parent dir) |
| `/api-log.json` | Live API request log (last 100 entries) |
| `/body-log.json` | Full request/response body log (last 50 entries) |
| `/token-status` | Editor JWT status check |
| `/refresh-token` | Trigger Playwright-based token refresh |
| `/get-editor-token` | Get current editor JWT value |

## Session Capture Workflow

1. Select a product from the sidebar
2. Interact with the widget (change options, open editor, complete editing)
3. Monitor real-time state in Tab 1 (Widget Monitor) and Tab 2 (Editor Flow)
4. Review all API calls in Tab 3 (Network Inspector)
5. Click "Session JSON Download" in Tab 3 to export the full session
6. Load the exported JSON in Tab 4 (Comparison) for future reference

## Offline Usage

The simulator works fully offline once started. No external CDN dependencies are used -- all CSS and JavaScript are inline. The only network requirement is the proxy connections to RedPrinting/WowPress APIs.

## Known Limitations

- Network duration timing is computed client-side via fetch wrapper; XHR requests do not have duration tracking
- Store diff only shows top-level changes; deeply nested array mutations may appear as full-object changes
- Comparison tab requires capture files to have `apiCalls`, `api_calls`, `networkLog`, or `requests` array fields for API matching
- The wow-proxy route requires the WowPress server to be accessible from the local machine
