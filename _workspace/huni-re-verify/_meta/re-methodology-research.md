# RE-Verify Methodology Research — "Does the reverse-engineered code actually run and reproduce RedPrinting?"

> Research lead report for a new harness (`huni-re-verify`) that reverse-engineers the RedPrinting
> web-ordering widget/SDK **and then proves the reconstruction is behaviorally equivalent to the
> live system.** Target: `productRedWidgetSDK.js` (33KB jQuery bridge), `widget.js` (438KB
> minified Vue 3 + Pinia, Shadow DOM, stores config/product/order/exterior), `RedEditorSDK.min.js`
> (45 prototype methods, Edicus), server APIs (`get_digital_product_info`,
> `get_ajax_price_vTmpl`, `/api/aws/presigned`). Plaintext JSON, session-cookie auth, no client crypto.
>
> **Scope note (research, not implementation):** this is the methodology stack + gates + pitfalls.
> Author: research lead. Date: 2026-06-22.

---

## (a) Inventory of reusable existing assets — REUSE, do not rebuild

The single most important finding: **most of the verification substrate already exists.** This
harness should be ~80% reuse, ~20% new (the differential/equivalence harness layer + gates).

### A1. `_workspace/huni-widget/` (§6 harness) — the RE'd reconstruction already exists and is partly proven
- **`07_parity/`** — code-level structure parity work. Red reverse-engineered source (`deob_05/06/07/editor_sdk`) was treated as the **authority** and mapped against a React-in-Shadow-DOM reconstruction. Contains `red-code-map-05/06/07/08`, `structure-map`, `parity-matrix-P1/D1~D4`, `parity-gap-map`, `crossverify-findings`, `crossverify-round2-findings`. This is a **prior art differential-parity audit** — reuse its gap taxonomy (BLOCKER/MAJOR) and its "characterization test" pattern.
- **`04_build/`** — the actual reconstruction: React-in-Shadow-DOM widget + Red adapter (`src/adapters/red`), normalized contract, fixtures, **vitest 150 green**, tsc clean, vite build OK. `04_build/fixtures/` holds ~25 product fixtures (PRBKYPR, AIPPCUT, STPADPN, GSBGRDY, CLSTSHS, ACPDSTD, etc.).
- **`05_qa/`** — equivalence-gate work: `gate-completeness`, `compare`, `captures`. **A live equivalence gate already passed** (4 dimensions × 4 models vs Red live). Reuse the gate structure.
- **`HANDOFF.md` / `CHANGELOG.md`** — encode hard-won invariants (see A4).

### A2. `raw/widget_monitor/local/` — THE live verification ground-truth substrate (critical)
- **`server.js`** (Express :3001) — read-only proxy that injects login session cookies into `https://www.redprinting.co.kr` (`/rp-api`), widget-api, and `makers.redprinting.net` (Edicus). **This is the oracle producer** — it lets you replay any captured price-calc request against the live engine and get the real answer. Has working token+cookie refresh (`/refresh-token`, `loadSessionCookies()`), fixed in §6.
- **`extract-cookies.cjs`** — Playwright headless login → `cookies.json` (session = price authority).
- **Capture scripts (Playwright/.cjs):** `hw-runtime-capture.cjs` (editor open → from-edicus event timeline), `qtysweep.cjs` (quantity sweep price capture), `coverage-scan.cjs` / `coverage-phaseB.cjs` (catalog-wide mount/option-structure classification), `s2/s3/s5/s6-*-capture.cjs` (per-category), `major-capture.cjs`, `e2e-editor-test.cjs`. **These already record golden fixtures** — they are the record half of record-and-replay.
- **Live widget assets symlinked:** `widget.js` (587KB live copy), `widget.css`, `RedEditorSDK.min.js`, `catalog.json` (479 products / 26 categories). `index.html` = "Precision Analyzer" with 5 tabs.
- **`api-log.json` / `body-log.json`** — captured request/response logs (golden master seeds).

### A3. `docs/reversing/` — the RE source-of-truth
- **`RedPrinting_SDK_Deep_Analysis_Report.html` / `RedPrinting_Widget_Analysis_Report.html`** — the documented contracts: full `get_ajax_price_vTmpl` request/response **field dictionary** (PDT_CD, CUT/WRK_WDT/HGH, PRN_CNT, PAGE_CNT, CVR/INN_CLR_CNT, CVR/INN_MTRL_CD, PCS_INFO[], price_gbn, mb_cust_cod → result[].PCS_CD/PRICE/PRICE_VAT/PRICE_MALL + result_sum), the 4 Pinia stores, 17 bridge functions, 45 editor prototype methods, network sequence (info → price), CDN map.
- **`red_reverse_engineer/03_deobfuscated/`** (per §6 handoff) — the 4 deobfuscated modules used as code-parity authority.

### A4. Hard-won invariants from §6 to carry forward (auto-memory) — these ARE prior verification findings
- **`PRICE=0 is impossible from Red`** (HARD): RedPrinting never legitimately returns PRICE=0; a 0 is always our-side defect (session/field/spec). Use as a built-in oracle sanity assertion.
- **`result_sum.PRICE` is the single price authority** — per-line `result[].PRICE` of a bundle component is legitimately 0; reading per-line yields false PRICE=0.
- **`fixture masks serialization shape`** — fixtures bypassing HTTP silently hide adapter request-body shape defects; field-for-field compare against captures is mandatory; never silent-fallback, throw.
- **`dataJson.ORD_INFO[0]` needs both ORD_CNT and PRN_CNT** — omission = silent 0.
- **Token vs cookie lifetimes differ** — editor JWT (~1h) vs price session cookie; price capture needs a fresh server restart.
- **Shadow DOM Tailwind pitfall** — `--tw` variable-chain utilities (shadow/ring) die in Shadow DOM; static analysis passes, real render fails → style must be explicitly injected.

> **Net:** the new harness does NOT re-do reverse engineering or rebuild the testbed. It adds a
> **systematic differential/equivalence verification layer** on top of A1–A3, formalizes the ad-hoc
> §6 gates into named methodologies, and closes the gaps §6 left open (HTTP-path shape regression,
> combinatorial divergence search, editor-bridge behavioral assertion).

---

## (b) Recommended methodology stack — ordered, tool-named, source-cited

The core question is **"does the RE'd code actually run and reproduce the real system?"** The
established answer is **reference-oriented differential / equivalence testing**: the original
(live RedPrinting) is the reference oracle; the reconstruction is run on the same inputs and outputs
are diffed ([Differential testing — arXiv 2212.01748](https://arxiv.org/pdf/2212.01748);
[Characterization test — Wikipedia](https://en.wikipedia.org/wiki/Characterization_test)).
The stack below is ordered from "make the RE'd code legible" → "pin the real behavior" → "prove
equivalence" → "hunt for divergence" → "guard regressions."

### Stage 0 — Make the minified bundle legible (so RE claims are checkable) — WELL-ESTABLISHED
- **Sourcemap recovery first.** Probe `widget.js`/`RedEditorSDK.min.js` for `sourceMappingURL` and a sibling `.map`; if present, reconstruct original tree with **`unwebpack-sourcemap`** / **`reverse-sourcemap`** ([rarecoil/unwebpack-sourcemap](https://github.com/rarecoil/unwebpack-sourcemap); [davidkevork/reverse-sourcemap](https://github.com/davidkevork/reverse-sourcemap); [rarecoil — un-Webpacking source maps](https://medium.com/@rarecoil/spa-source-code-recovery-by-un-webpacking-source-maps-ef830fc2351d)). RedPrinting ships from CloudFront — maps are often left on; check before any manual deobfuscation.
- **If no maps: AST-level deobfuscation with Babel** — rename/restructure at AST so transforms are provably equivalence-preserving, not string edits; use **`ast-grep`** for structural search across the 631 minified functions ([0xdevalias deobfuscation notes](https://gist.github.com/0xdevalias/d8b743efb82c0e9406fc69da0d6c6581); [0xdevalias Webpack RE notes](https://gist.github.com/0xdevalias/8c621c5d09d780b1d321bfdb86d67cdd)).
- **Runtime inspection over guessing** — Vue/Pinia state is observable at runtime; extract the 4 stores (config/product/order/exterior) live in the testbed (A2) rather than inferring from minified code. This is the §6 lesson re-stated: **code/runtime > capture sample > inference.**

### Stage 1 — Pin the real behavior into golden masters (record) — WELL-ESTABLISHED
- **Record-and-replay of network traffic → golden fixtures.** Capture live sessions as **HAR** (every request/response: headers, cookies, body, timing) ([Approaches to HAR Recording — Steve Kinney](https://stevekinney.com/courses/self-testing-ai-agents/approaches-to-har-recording); [Playwright Mock APIs](https://playwright.dev/docs/mock)). Reuse A2 capture scripts to seed these; standardize on Playwright **`--save-har` / `recordHar`** so golden fixtures are versionable.
- **Golden Master / characterization tests** — record the live system's outputs for a fixed input set; the recorded "master" is the correctness reference for the reconstruction ([Golden Master — Codurance](https://www.codurance.com/publications/2012/11/11/testing-legacy-code-with-golden-master); [Refactoring with a Golden Master — codecentric](https://www.codecentric.de/en/knowledge-hub/blog/refactoring-algorithmic-code-using-golden-master-record)). For an opaque server price engine you cannot reconstruct internally, golden-master IS the verification.
- **One HAR = one session, not an accumulation** — keep separate HAR per scenario/product ([Steve Kinney](https://stevekinney.com/courses/self-testing-ai-agents/approaches-to-har-recording)).

### Stage 2 — Prove the reconstruction reproduces the real behavior (replay + assert equivalence) — WELL-ESTABLISHED
- **API black-box equivalence (the price engine):** feed identical inputs to (i) the live engine via the A2 proxy and (ii) the reconstruction's adapter+client; diff responses. This is reference-oriented differential testing with the original as oracle ([arXiv 2212.01748](https://arxiv.org/pdf/2212.01748)).
- **Replay with Playwright `routeFromHAR`** in strict mode: it matches **URL + HTTP method strictly, and for POST matches the POST payload strictly** ([Playwright Mock APIs](https://playwright.dev/docs/mock)). Strict POST-payload matching is exactly what catches the §6 "fixture masks serialization shape" defect — if the reconstruction's request body diverges from the captured golden by one field, replay aborts/misses. **This is the single highest-leverage technique for this target.**
- **Assert request bodies with `page.route()`** before serving the mock — validates the reconstruction *emits* the right request, not just that it *consumes* the right response ([Playwright Mock APIs](https://playwright.dev/docs/mock); [Recording/replaying — Michał Kuncio](https://michalkuncio.com/recording-and-replaying-network-requests-with-playwright/)).
- **Headless-browser behavioral assertions (the widget UI):** drive the reconstruction in Playwright through option cascades; assert resulting state + emitted price requests against goldens. Handle Shadow DOM via Playwright locators (pierce by default) and iframes via FrameLocator ([Playwright iFrame & Shadow DOM — Automate The Planet](https://www.automatetheplanet.com/playwright-tutorial-iframe-and-shadow-dom-automation/)).

### Stage 3 — Hunt for divergence the fixed goldens miss (fuzz / property / metamorphic) — ESTABLISHED, higher-effort
- **Differential fuzzing of option combinations:** generate many valid option tuples (size × material × dosu × process × quantity), run each through live engine and reconstruction, assert identical `result_sum.PRICE`. Differential testing has a **strong oracle** (two outputs compared) vs plain fuzzing (only crashes) ([arXiv 2212.01748](https://arxiv.org/pdf/2212.01748)).
- **Property-based testing** to shrink any divergence to a minimal counter-example ([Property-based testing — Antithesis](https://antithesis.com/docs/resources/property_based_testing/); [PBT is fuzzing — nelhage](https://blog.nelhage.com/post/property-testing-is-fuzzing/)). Tool: **fast-check** (JS/TS) generating option tuples constrained by `product.baseInfo`.
- **Metamorphic testing** for cases where you lack a per-input oracle: encode relations like *"more quantity ⇒ non-decreasing PRICE"*, *"adding a finishing process ⇒ PRICE strictly increases"*, *"identical inputs ⇒ identical output"* ([Metamorphic testing — Wikipedia](https://en.wikipedia.org/wiki/Metamorphic_testing); [PBT for metamorphic testing — arXiv 2211.12003](https://arxiv.org/pdf/2211.12003)). The §6 qty-sweep (PRICE linear in PRN_CNT) is already a metamorphic relation in disguise — formalize it.

### Stage 4 — Verify the editor bridge (postMessage / Edicus lifecycle) — ESTABLISHED pattern
- **Mock the bridge, assert the protocol.** You cannot (and should not) drive a real order/editor backend for behavioral verification. Stand up a **mock postMessage peer** that plays the Edicus/RedEditorSDK role: validate `event.origin` (allowlist) and `event.data` shape on both directions; assert the reconstruction's lifecycle calls (createProject → open → from-edicus events → save/checkOrderable → prepareOrder) match the 45-method contract ([mock-bridge (Shopify App Bridge mock)](https://github.com/ctrlaltdylan/mock-bridge); [Cross-boundary communication — DEV](https://dev.to/eelcolos/cross-boundary-communication-between-desktop-and-web-575n)).
- **Drive + assert with Playwright FrameLocator** for the iframe editor; assert message sequence and payload shapes rather than backend effects ([Testing iframes — Debbie Codes](https://debbie.codes/blog/testing-iframes-with-playwright/); [Third-party integrations & iFrames — Testrig](https://testrig.medium.com/testing-third-party-integrations-and-iframes-with-playwright-64e3b334953b)). The §6 `hw-runtime-capture.cjs` already captures the real from-edicus event timeline — use it as the golden the mock peer replays/asserts against.

### Stage 5 — Lock it down as a regression gate — WELL-ESTABLISHED
- Wire Stages 2–4 into the existing **vitest** suite (150 green baseline) + a Playwright project. Golden HARs versioned in git. Any reconstruction change that diverges from a golden fails CI. This converts the one-shot §6 equivalence gate into a standing characterization-test gate ([Characterization test — Wikipedia](https://en.wikipedia.org/wiki/Characterization_test)).

### Cross-cutting — LLM-assisted RE with anti-hallucination guardrails — EMERGING, use with discipline
LLMs help summarize/rename minified code but **hallucinate functions/structures that don't exist** and make off-by-one arithmetic errors that silently change semantics ([CASCADE — arXiv 2507.17691](https://arxiv.org/pdf/2507.17691); [Talos — LLM as RE sidekick](https://blog.talosintelligence.com/using-llm-as-a-reverse-engineering-sidekick/); [Deconstructing Obfuscation — arXiv 2505.19887](https://arxiv.org/html/2505.19887v1); [Can LLMs Recover Program Semantics? — arXiv 2511.19130](https://arxiv.org/pdf/2511.19130)).
- **Adopt CASCADE's hybrid pattern: never trust an LLM pass — execution-validate it.** CASCADE (Google) pairs LLM analysis with static checkers + **execution-based behavioral-equivalence validation**, running both versions and comparing traces; the verification pipeline is what makes it production-safe ([CASCADE — arXiv 2507.17691](https://arxiv.org/pdf/2507.17691)).
- **Every LLM-derived claim about RedPrinting code is a hypothesis until checked against the deobfuscated source (file:line), live runtime state, or a captured response.** This is exactly the §6 lesson: a prior "RESOLVED" gate was found to cite **non-existent deobfuscated lines** (G-1 ATTB fabrication) — a real hallucination caught only by cross-verification. Carry the §6 rule: **generation ≠ verification; the verifier re-measures against ground truth and does not trust generator claims.**
- **codex-cli as the independent 2nd opinion** (the project's standing pattern): run the same work-spec read-only through Codex; reconcile (agreement = high-confidence, disagreement = investigate). Codex claims are also hypotheses — never adopt before live/authority check ([7 guardrails for LLM hallucinations — Medium](https://medium.com/@Nexumo_/7-guardrails-that-reduce-llm-hallucinations-78facbb0d560)).

---

## (c) Verification gates this harness should adopt

Three subsystems, each with a hard GO/NO-GO gate. Single FAIL = NO-GO (per project convention).

### V-PRICE — price-calc API equivalence gate (the money path)
- **VP-1 Golden replay (strict):** for the fixture set, the reconstruction's emitted `get_ajax_price_vTmpl` request matches the captured golden **byte-for-byte on `dataJson` (ORD_INFO + PCS_INFO + price_gbn + mb_cust_cod)** under Playwright `routeFromHAR` strict POST-payload matching. (Closes §6 G-INT-0 / shape-masking.)
- **VP-2 Live differential:** identical option selections through live engine (A2 proxy) and reconstruction yield identical `result_sum.PRICE` and `PRICE_VAT`. Oracle = live.
- **VP-3 Oracle sanity:** no test path yields `result_sum.PRICE == 0` against live; a 0 fails the gate as a defect signal (§6 HARD invariant), not a pass.
- **VP-4 Authority reading:** price read from `result_sum.PRICE`, never per-line `result[].PRICE` (false-zero guard).
- **VP-5 Combinatorial divergence:** fast-check / differential fuzz over ≥N valid option tuples per product family finds zero PRICE divergence vs live; metamorphic relations (qty↑⇒price non-decreasing; +process⇒price↑) hold.
- **VP-6 Field-dictionary conformance:** every field the reconstruction sends/reads exists in the documented dictionary (docs/reversing) AND in a real captured response — no invented fields.

### V-WIDGET — widget UI behavioral gate
- **VW-1 Cascade equivalence:** driving option cascades in the reconstruction reproduces the live store transitions (sizes→dosu→paper→weight→process visibility) — diff Pinia/extracted state vs live.
- **VW-2 Emit-on-change:** every option change emits the correct price request (assert via `page.route()`), matching the live request count and shape.
- **VW-3 Shadow DOM render parity:** options render in Shadow DOM with explicit-injected styles (Tailwind variable-chain pitfall guard); computed-style + screenshot diff vs live within tolerance.
- **VW-4 isReadyToOrder / order-data assembly:** `sdkCreatePot`-equivalent order payload assembles identically to live for completed selections.
- **VW-5 Coverage:** every catalog option-structure class (from `coverage-scan.cjs`) has at least one passing behavioral fixture; un-fixtured classes are explicitly listed as dormant, not silently passed.

### V-EDITOR — editor/SDK bridge gate
- **VE-1 Protocol shape:** all postMessage to/from the mock Edicus peer validate origin allowlist + data shape; no message leaks secrets (token/JWT/presigned redacted).
- **VE-2 Lifecycle sequence:** reconstruction's editor calls match the captured from-edicus timeline (`hw-runtime-capture.cjs` golden): init → createProject/openProject → editor events → save/saveThenClose → checkOrderable → prepareOrder.
- **VE-3 Price callback:** editor `setPrice`/price-callback path is wired (not no-op) — closes §6 G-2.
- **VE-4 Upload path:** `/api/aws/presigned` request shape matches golden; presigned URL never asserted against real S3 (mock), secrets redacted.
- **VE-5 No-backend isolation:** the entire editor gate runs against the mock peer with zero live order/editor backend writes.

### Meta-gates (all subsystems)
- **VM-1 Generation ≠ verification:** the agent/pass that built the reconstruction does not self-approve; an independent verifier re-measures against live/captures.
- **VM-2 codex reconcile:** Codex independent 2nd opinion run; agreements high-confidence, disagreements investigated before GO; Codex unavailable ⇒ explicit "Claude-only" fallback (no pending).
- **VM-3 No-fabrication:** every code claim cites deobfuscated `file:line`, a captured response, or live runtime state; unverifiable claim ⇒ NO-GO.

---

## (d) Key pitfalls

1. **Fixture/mock masks serialization-shape defects (the #1 trap, already bitten in §6).** Tests that inject canned responses without exercising the real HTTP request body let a wrong request shape pass silently. Mitigation: Playwright `routeFromHAR` strict POST-payload matching + `page.route()` request-body assertions; never silent-fallback — throw.
2. **PRICE=0 read as legitimate.** Two sub-traps: (i) treating a live 0 as a valid datum (it's always our defect — session/field/spec); (ii) reading per-line `result[].PRICE` (bundle components are legitimately 0) instead of `result_sum.PRICE`. Bake both into oracle assertions.
3. **Session/token lifetime drift produces false negatives.** Expired cookie ⇒ silent PRICE=0; editor JWT (~1h) ≠ price session cookie; in-process refresh that doesn't reload the cookie. Always restart the proxy fresh for price capture; verify session before a differential run.
4. **LLM/Codex hallucinated code facts.** Inventing functions, mis-citing deobfuscated lines, off-by-one arithmetic that silently changes semantics ([CASCADE — arXiv 2507.17691](https://arxiv.org/pdf/2507.17691); [arXiv 2505.19887](https://arxiv.org/html/2505.19887v1)). The §6 G-1 "RESOLVED" gate cited non-existent lines. Mitigation: execution/behavioral validation of every claim; generation ≠ verification; cite file:line or capture.
5. **Sample fixtures ≠ behavioral coverage.** A handful of product fixtures pass while whole option-structure classes (size-linked radius, synthetic ATTB, apparel DIR_MTR, field-axis swaps) are dormant/untested. Use `coverage-scan.cjs` classes as the coverage denominator; list dormant classes explicitly.
6. **Shadow DOM / Tailwind variable-chain utilities die silently.** `shadow-*`/`ring-*` (`--tw` chains) pass static analysis but fail to render inside Shadow DOM. Verify with real computed-style/screenshot, not static checks; inject styles explicitly.
7. **HAR over-accumulation & non-strict matching.** One HAR per scenario; keep strict URL+method+payload matching or you get false "equivalence" from loose response reuse ([Steve Kinney](https://stevekinney.com/courses/self-testing-ai-agents/approaches-to-har-recording); [Playwright Mock APIs](https://playwright.dev/docs/mock)).
8. **Verifying against the wrong authority.** The opaque server price engine is the reference oracle; do NOT "fix" the reconstruction to match an internal re-derivation of Red's pricing (the §6 rule: Red price logic is analysis-only, never ported). Live response is truth; reconstruction conforms to it.
9. **Driving real order/editor backends during verification.** Writes against live order/Edicus backends are unsafe and non-reproducible. Editor verification must run against a mock postMessage peer; live access stays read-only (read proxy, redacted secrets).
10. **Secret leakage in captures/screenshots.** Editor JWT, presigned URLs, cookies must be `[REDACTED]` in any committed golden/HAR/screenshot (`_workspace` is git-tracked); credentials live only in `.env`/`.env.local`.

---

## Sources
- [Differential Testing of a Verification Framework (arXiv 2212.01748)](https://arxiv.org/pdf/2212.01748)
- [Characterization test — Wikipedia](https://en.wikipedia.org/wiki/Characterization_test)
- [Testing legacy code with Golden Master — Codurance](https://www.codurance.com/publications/2012/11/11/testing-legacy-code-with-golden-master)
- [Refactoring Algorithmic Code using a Golden Master Record — codecentric](https://www.codecentric.de/en/knowledge-hub/blog/refactoring-algorithmic-code-using-golden-master-record)
- [Mock APIs / routeFromHAR — Playwright](https://playwright.dev/docs/mock)
- [Recording and replaying network requests with Playwright — Michał Kuncio](https://michalkuncio.com/recording-and-replaying-network-requests-with-playwright/)
- [Approaches to HAR Recording — Steve Kinney](https://stevekinney.com/courses/self-testing-ai-agents/approaches-to-har-recording)
- [Playwright iFrame & Shadow DOM Automation — Automate The Planet](https://www.automatetheplanet.com/playwright-tutorial-iframe-and-shadow-dom-automation/)
- [Testing iframes with Playwright — Debbie Codes](https://debbie.codes/blog/testing-iframes-with-playwright/)
- [Testing Third-Party Integrations and iFrames with Playwright — Testrig](https://testrig.medium.com/testing-third-party-integrations-and-iframes-with-playwright-64e3b334953b)
- [mock-bridge (Shopify App Bridge mock) — GitHub](https://github.com/ctrlaltdylan/mock-bridge)
- [Cross-boundary communication between desktop and web — DEV](https://dev.to/eelcolos/cross-boundary-communication-between-desktop-and-web-575n)
- [unwebpack-sourcemap — GitHub (rarecoil)](https://github.com/rarecoil/unwebpack-sourcemap)
- [reverse-sourcemap — GitHub (davidkevork)](https://github.com/davidkevork/reverse-sourcemap)
- [SPA source code recovery by un-Webpacking source maps — rarecoil](https://medium.com/@rarecoil/spa-source-code-recovery-by-un-webpacking-source-maps-ef830fc2351d)
- [Reverse engineering / deobfuscating web app code notes — 0xdevalias](https://gist.github.com/0xdevalias/d8b743efb82c0e9406fc69da0d6c6581)
- [Reverse engineering Webpack apps notes — 0xdevalias](https://gist.github.com/0xdevalias/8c621c5d09d780b1d321bfdb86d67cdd)
- [Metamorphic testing — Wikipedia](https://en.wikipedia.org/wiki/Metamorphic_testing)
- [Application of property-based testing tools for metamorphic testing (arXiv 2211.12003)](https://arxiv.org/pdf/2211.12003)
- [Property-based testing — Antithesis](https://antithesis.com/docs/resources/property_based_testing/)
- [Property-Based Testing Is Fuzzing — nelhage](https://blog.nelhage.com/post/property-testing-is-fuzzing/)
- [CASCADE: LLM-Powered JavaScript Deobfuscator at Google (arXiv 2507.17691)](https://arxiv.org/pdf/2507.17691)
- [Deconstructing Obfuscation: evaluating LLM assembly deobfuscation (arXiv 2505.19887)](https://arxiv.org/html/2505.19887v1)
- [Can LLMs Recover Program Semantics? (arXiv 2511.19130)](https://arxiv.org/pdf/2511.19130)
- [Using LLMs as a reverse engineering sidekick — Cisco Talos](https://blog.talosintelligence.com/using-llm-as-a-reverse-engineering-sidekick/)
- [7 Guardrails That Reduce LLM Hallucinations — Medium](https://medium.com/@Nexumo_/7-guardrails-that-reduce-llm-hallucinations-78facbb0d560)
