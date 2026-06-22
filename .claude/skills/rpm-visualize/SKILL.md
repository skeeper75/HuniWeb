---
name: rpm-visualize
description: >
  RedPrinting 카테고리별 리버싱/메타모델/갭 분석 자료를 codex-image로 한눈에 보는 다이어그램 이미지로 만드는 방법론
  (후니 RP-Meta 하네스). 시각화 4종(옵션 구성 트리·메타모델 축 매핑·갭 히트맵·BOM)·분석 충실 도해(없는 사실 금지)·
  spec→prompt→render 절차·codex 가용성 사전점검·폴백 ladder(codex-image→gpt-image2→mermaid 자동 폴백·pending 아님)·렌더 검증.
  트리거: RP 시각화, 카테고리 시각화, 메타모델 다이어그램, 갭 히트맵 이미지, 옵션구조 도해, codex-image 시각화, 시각화 다시.
  이미지 생성 명령 상세는 codex-image, 분석 생성은 rpm-live-reverse/rpm-metamodel-design/rpm-gap-vessel.
---

# rpm-visualize — Per-Category Visualization Method

Render a category's analysis into diagram PNGs that a human can grasp at a glance. Images **depict** the
analysis — they never author new structure.

## Why this method

The pipeline produces dense markdown (axes, verdicts, BOMs). A diagram compresses it for fast human review and
for spotting structure errors the prose hides. But an image that adds unsourced detail is worse than none — it
fabricates confidence. So the discipline is: extract a precise spec from the analysis, render exactly that.

## Standard diagram set (per category)

| Diagram | Source | Content |
|---------|--------|---------|
| `option-tree.png` | reverse.md | axes → choices → cascade/disable, price-affecting flags marked |
| `axis-map.png` | 02_metamodel | which of the 15 management axes this category exercises + how (distinct/facet) |
| `gap-heatmap.png` | 03_gap/gap-matrix | per-axis PASS/WEAK/GAP, color legend 🟢/🟡/🔴 |
| `bom.png` | reverse.md (when present) | body material + usage slots + processes |

Skip a diagram whose source is absent (e.g. no BOM) — note why in summary.md, don't invent it.

## Workflow

1. **Read the source.** Open reverse.md + the category's metamodel/gap rows. Build a *text spec* for each
   diagram: nodes, edges, labels, colors — exactly what the analysis states. This spec is the contract.
2. **Prompt from the spec.** Write a codex-image prompt per diagram describing a clean technical diagram
   (tree/matrix/heatmap), legible KO/EN labels, fixed legend (🟢PASS/🟡WEAK/🔴GAP). No decorative elements.
3. **Pre-flight codex + model fallback (HARD).** Two traps: `codex login status` falsely reports "Logged in"
   on an *expired* token, AND a codex deadlock is often a *model* problem, not a token one (gpt-5-codex/gpt-5
   are `400 not supported` on a ChatGPT account; gpt-5.5 works). So never equate "ping failed" with "token
   stale". Run `scripts/codex-preflight.sh` (pings supported model candidates, gpt-5.5 first) — it prints:
   - `AVAILABLE model=<m>` → raster is on; render with `-m <m>` (step 4).
   - `DEADLOCK` (codex present, all model candidates 400) → **mermaid fallback** (Rules) — NOT pending.
   - `AUTH_STALE` (401/expired) → real auth issue: ask user to re-run `codex login`; meanwhile **mermaid fallback**.
   - `UNAVAILABLE` (codex not installed) → **mermaid fallback**.
   Only `AUTH_STALE` is an auth problem; every other non-AVAILABLE result still yields diagrams via mermaid.
   Never fake a PNG.
4. **Render via codex-image (model from preflight).** Load the `codex-image` skill and follow it: `codex exec
   -m <model> --sandbox workspace-write --skip-git-repo-check --cd categories/{CAT}/viz "<prompt>"` (use the
   `<m>` from `AVAILABLE model=<m>`), `run_in_background: true`, batch the category's 3–4 diagrams in parallel
   (N≤5), distinct output filenames. Don't mix categories per batch.
5. **Verify outputs.** After the batch, confirm each expected PNG exists (`ls`). A missing PNG → retry once →
   else mark `viz pending` in summary.md. Never claim an image that isn't on disk.
6. **Embed in summary.** Create/update `categories/{CAT}/summary.md` with each PNG (relative path) + a one-line
   caption tying it to the source section.

## Rules

- **Depict, don't author** — the diagram must match the analysis; unsourced structure is a defect.
- **Stable names** — `option-tree.png` / `axis-map.png` / `gap-heatmap.png` / `bom.png` so re-runs overwrite
  cleanly and summary links never break.
- **Fallback ladder (codex-image → gpt-image2 → mermaid)** — codex-image is primary; `gpt-image2` for 2K+/
  precise text. If preflight returns `DEADLOCK`/`AUTH_STALE`/`UNAVAILABLE` (raster blocked), **mermaid is the
  automatic default fallback, not an optional last resort** — write `viz/<name>.mmd` (mermaid source) and embed
  the block in summary.md. Mermaid renders in viewers/GitHub, has zero hallucination (text = exactly the
  analysis), needs no external model, and satisfies the comprehension goal — so a category is **never left
  without a diagram on a codex outage**. Note which renderer was used; regenerate as PNG once preflight returns
  `AVAILABLE`. These are technical diagrams (tree/matrix/heatmap) — mermaid expresses them well.
- **Pending is last-ditch only** — with mermaid always available, `viz pending` applies ONLY when the source
  spec itself is missing (nothing to draw). A codex outage alone never yields pending — it yields mermaid. Never fake.

## Outputs
- `_workspace/huni-rpmeta/categories/{CAT}/viz/*.png` (codex-image/gpt-image2) — or `*.mmd` (mermaid fallback).
- `_workspace/huni-rpmeta/categories/{CAT}/summary.md` (viz section: PNG embeds, or mermaid code blocks + renderer note).

## Done when
Each applicable diagram exists on disk, matches its source spec, and is embedded in summary.md with a caption;
skipped/pending diagrams are noted with the reason.
