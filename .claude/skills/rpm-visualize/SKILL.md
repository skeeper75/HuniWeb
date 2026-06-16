---
name: rpm-visualize
description: RedPrinting 카테고리별 리버싱/메타모델/갭 분석 자료를 codex-image로 한눈에 보는 다이어그램 이미지로 만드는 방법론 스킬(후니 RP-Meta 하네스). 시각화 4종 표준(옵션 구성 트리·메타모델 축 매핑·갭 히트맵·자재/공정 BOM), 분석 충실 도해 원칙(없는 사실 그리기 금지), spec→prompt→render 절차, codex-image 위임(codex exec workspace-write·N≤5 병렬·run_in_background)·gpt-image2 폴백, 카테고리 폴더 출력(categories/{CAT}/viz/)·안정 파일명·summary.md 임베드, 렌더 검증·viz pending 정직 처리를 제공한다. 'RP 시각화', '카테고리 시각화', '리버싱 이미지', '메타모델 다이어그램', '갭 히트맵 이미지', '옵션구조 도해', 'codex-image 시각화', '시각화 다시', '시각화 보강' 작업 시 반드시 이 스킬을 사용. 실제 codex 이미지 생성 명령 상세는 codex-image 스킬이, 분석 자체 생성은 rpm-live-reverse/rpm-metamodel-design/rpm-gap-vessel이 담당한다.
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
3. **Pre-flight codex auth (HARD).** `codex login status` can falsely report "Logged in" on an *expired*
   OAuth refresh token. Ping first — `codex exec --sandbox read-only --output-last-message /tmp/codex-ping.md
   "reply OK"` — confirm real content. `401 Unauthorized`/empty → token stale: stop, ask the user to re-run
   `codex login`, mark diagrams `viz pending`. Never fake an image.
4. **Render via codex-image.** Load the `codex-image` skill and follow it: `codex exec --sandbox
   workspace-write --skip-git-repo-check --cd categories/{CAT}/viz "<prompt>"`, `run_in_background: true`,
   batch the category's 3–4 diagrams in parallel (N≤5), distinct output filenames. Don't mix categories per batch.
5. **Verify outputs.** After the batch, confirm each expected PNG exists (`ls`). A missing PNG → retry once →
   else mark `viz pending` in summary.md. Never claim an image that isn't on disk.
6. **Embed in summary.** Create/update `categories/{CAT}/summary.md` with each PNG (relative path) + a one-line
   caption tying it to the source section.

## Rules

- **Depict, don't author** — the diagram must match the analysis; unsourced structure is a defect.
- **Stable names** — `option-tree.png` / `axis-map.png` / `gap-heatmap.png` / `bom.png` so re-runs overwrite
  cleanly and summary links never break.
- **Fallback ladder** — codex-image is primary. If 2K+ resolution or precise text matters, use `gpt-image2`.
  If **both raster paths are blocked** (codex version/account deadlock, no OPENAI_API_KEY), fall back to
  **mermaid text diagrams** — write `viz/<name>.mmd` (mermaid source) and embed the block in summary.md.
  Mermaid renders in viewers/GitHub, has zero hallucination (text = exactly the analysis), and needs no
  external model. It satisfies the comprehension goal; regenerate as PNG once a raster path is available.
  Note which renderer was used. These are technical diagrams (tree/matrix/heatmap) — mermaid expresses them well.
- **Honest pending** — codex-image off (login/feature) or render fail after one retry → `viz pending`, never fake.

## Outputs
- `_workspace/huni-rpmeta/categories/{CAT}/viz/*.png` (codex-image/gpt-image2) — or `*.mmd` (mermaid fallback).
- `_workspace/huni-rpmeta/categories/{CAT}/summary.md` (viz section: PNG embeds, or mermaid code blocks + renderer note).

## Done when
Each applicable diagram exists on disk, matches its source spec, and is embedded in summary.md with a caption;
skipped/pending diagrams are noted with the reason.
