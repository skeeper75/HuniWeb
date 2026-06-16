---
name: rpm-live-reverse
description: RedPrinting 라이브 사이트의 주문옵션 구성을 "기초데이터 관리 렌즈"로 역공학하는 방법론 스킬(후니 RP-Meta 하네스). 대표 샘플링 전략(26 카테고리 대표 추출·답습 전수수집 금지), huni-widget 기존 역공학 자산 재사용 우선, raw/widget_monitor 캡처 도구·gstack 읽기전용 라이브 보강, 상품별 옵션 원자 추출 포맷(축·choices·캐스케이드·가격플래그), 7버킷 base-data 태깅(자재/공정/옵션/템플릿/제약/기초코드/카테고리), 모호 fragment 분리, 출처 강제·날조 금지를 제공한다. 'RedPrinting 역공학', 'RP 옵션 추출', '라이브 옵션 캡처', '대표 샘플 역공학', '현수막 옵션 분석', '상품군 옵션 추출', 'RP 역공학 다시', 'base-data 태깅' 작업 시 반드시 이 스킬을 사용. 위젯 런타임/가격엔진 구현 역공학은 huni-widget 하네스가 담당하므로 그 작업에는 트리거하지 않는다. 메타모델 추상화는 rpm-metamodel-design이 담당한다.
---

# rpm-live-reverse — RedPrinting Option Reverse-Engineering (base-data lens)

Extract *evidence* of how RedPrinting structures order options, tagged for base-data management. The output
feeds the metamodel architect — it is raw material, not a finished model.

## Why this method

RedPrinting is the user's own validated system. We don't copy it; we read how it *separates* the management
concerns (material vs process vs option vs template vs constraint vs code vs category) so 후니 can hold the
same expressive power. Census-scraping all 479 products wastes budget and risks 답습 — a representative
sample across categories reveals the *model* far cheaper than a mirror does.

## Workflow

### 1. Reuse inventory (always first)
Read before touching live:
- `_workspace/huni-widget/01_reverse/option-schema-catalog.json` + `.md` — already-extracted option schemas.
- `_workspace/huni-widget/01_reverse/price-engine-reversed.md`, `s2/s3_raw_captures/`, `captures/`.
- `raw/widget_monitor/redprinting_catalog.json` (479 products / 26 categories), existing `*_capture.json`.
Record what's already covered so live work targets only gaps.

### 2. Sampling plan
Take the orchestrator's per-category representative list. If absent, pick 1–3 representatives per category
spanning structural diversity (e.g. BN 현수막: BNBNFBL 현수막, BNSTDFT X배너, BNRLSLV 롤업, BNPTMAS 매쉬 —
different substrate/finish axes). Prioritize categories the user named (현수막/BN first) then breadth.

### 3. Live capture (read-only, only for gaps)
Use `raw/widget_monitor` node monitors (e.g. `run-monitor-v2.cjs`, `cascade-capture.cjs`) and gstack/chrome
for read-only navigation of the product option page + option API responses. Capture: option axes, choices
per axis, cascade/disable behavior, price-affecting flags, template/SKU presence.
**Safety [HARD]:** never submit orders/forms, never click 주문/결제/장바구니, keep traffic low, no credentials in output.

### 4. Atomic extraction format
Per product, one record:
```
product: <pdtCode> <name> (category)
source: <reuse file | live capture file:line | API field | url>
axes:
  - axis: <label>            # e.g. 사이즈, 소재, 도수, 후가공, 코팅
    choices: [<v1>, <v2>, …]
    cascade: <what it enables/disables>   # or "none"
    price_flag: <affects price? how>      # or "unknown"
    base_data_tag: 자재|공정|옵션|템플릿|제약|기초코드|카테고리   # hypothesis
    note: <observation>                   # or "unobserved"
```

### 5. Base-data tagging (hypothesis, not verdict)
Tag each axis with its likely management bucket. Use domain cues: 별색→공정, 본체색→자재(합성), 형상→사이즈/규격,
아일렛→자재+공정 bundle, 수량→옵션/가격. When a fragment doesn't fit cleanly, do NOT force it — log it in
`_ambiguous-fragments.md` for the architect to bucket.

### 6. Sourcing & honesty
Every fragment carries a source. Unobserved behavior is marked `unobserved`, never invented. A product not
in the catalog is reported, not fabricated.

## Outputs
- `_workspace/huni-rpmeta/01_reverse/rp-option-extract-<category>.md`
- `_workspace/huni-rpmeta/01_reverse/rp-extract-index.md` (coverage: category→products→axes→source)
- `_workspace/huni-rpmeta/01_reverse/_ambiguous-fragments.md`

## Done when
Sampled categories each have an extract with sourced atomic records, the index shows coverage vs reuse/live,
and ambiguous fragments are parked for the architect. Not a 479-product census — a model-revealing sample.
