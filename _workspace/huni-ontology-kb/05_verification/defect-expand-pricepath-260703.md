# 결함 보드 — 가격 경로 연결 완전성(전 36상품) · 확장분

- 날짜: 2026-07-03
- 검증가: okb-adversarial-verifier (Claude 단독 — codex 2차 미호출)
- 배정 축: 가격 경로 연결 완전성 (상품→차원→자재/공정→옵션→공식→구성요소)
- 대상: `03_kb/product/` 36 상품 노드 · `04_graph/graph.db` (node 466 / edge 1521)
- 방법: 결정론 재귀 실탐색(스크립트) 전 36상품 루프 + 형제 패턴 정합 표본 대조. 생성자 리포트/판정 비신뢰(직접 재실측).
- 재현 스크립트:
  - `05_verification/scripts/price_path_traverse.py` (기존 재사용)
  - `05_verification/scripts/expand_pricepath_completeness_260703.py` (신규 — 상품별 끊김을 SILENT/ORPHAN-GAP/DECLARED로 판정)

## 총평 (한 문장)

전 36상품 가격 경로에 **조용한(선언 없는) 끊김은 0** — 끊김은 모두 GAP으로 문서화됨. 단 **product-048 접지리플렛**의 끊김 3종(사이즈0·자재커버·공식불완전)은 마크다운엔 정직 선언됐으나 **그래프에서 product-048→gap 배선 엣지가 미작성되어 traversal로는 도달 불가**(형제 038은 배선함) = 가격영향 끊김이 그래프 질의에 안 보이는 High 결함 1건.

## 축별 판정 요약

| 판정 | 수 | 상품 |
|---|---|---|
| 완결(OK) | 32 | 016·017·018·020·021·022·023·024·025·026·027·028·029·030·031·032·033·034·035·036·037·039·040·041·042·043·044·045·046·047·049·050·051 |
| DECLARED(끊김·상품 배선 GAP 존재=정직) | 2 | 019(no-material)·038(no-formula+no-material) |
| ORPHAN-GAP(끊김·GAP 존재하나 상품 미배선=traversal 미도달) | 1 | **048(no-size + material + price-path-incomplete)** |
| SILENT(조용한 누락·GAP 전무) | 0 | — |

전역 orphan GAP(in=out=0·그래프 완전 고립): `GAP_product_count` · `GAP_roll_material_price` · `gap-048-material` · `gap-048-no-size`.

---

## D1 [HIGH] product-048 접지리플렛 — 가격 끊김 3종이 그래프에 미배선(traversal 미도달)

- 노드: `product-048-folded-leaflet`
- 결함 유형: 5 연결 완전성 (+ 4 그래프 무결성 — GAP 배선 누락)
- 증거(재현):
  - `product-048 has_size=0` (사이즈 엣지 0) → 바인딩 공식 `PRF_FOLD_SUM`은 접지비 1구성요소(COMP_FOLD_CARD_2H)만 → **견적=접지비만**(인쇄비 COMP_PRINT_DIGITAL_S1·용지비 COMP_PAPER·base공정 PROC_000004 미배선). 048 마크다운(`product-048-folded-leaflet.md` priced_by note, `-nodes.md` §176/§184/§192)이 이를 정직 서술.
  - GAP 3종이 KB 마크다운에 완전 선언됨(gap_what/gap_fill_from/src 3필드): `gap-048-price-path-incomplete`·`gap-048-no-size`·`gap-048-material`.
  - **그러나 그래프에서 product-048 → 이 gap들로 향하는 `references`/`derived_from` 엣지가 없음.**
    - `gap-048-no-size`: in=0 out=0 (완전 orphan)
    - `gap-048-material`: in=0 out=0 (완전 orphan)
    - `gap-048-price-path-incomplete`: out=2(references DEC/formula)뿐·**product-048 in-edge 0**
  - 대조군(정상 배선): `product-038-emboss-namecard.md` L24/26/27이 `rel: derived_from, target: gap-038-no-price-path` 등 GAP 엣지를 명시 작성 → gap-038-* 전부 traversal 도달(in≥1).
  - 형제 정합 반증: 접지/리플렛 계열 사이즈 보유 = 047(size=4)·049(size=1)·형제 접지카드 027(6)·029(3). **048만 size=0** = 이상치. → no-size는 048 고유 라이브 조건(t_prd_product_sizes 활성 0행, snap_20260702_1119 전사)이 실재하나, 그 사실이 그래프 질의에는 노출되지 않음.
- 심각도: **High** — 가격 영향(견적 불완전·접지비만) 끊김이 그래프 traversal(KB의 주 소비 경로)에서 안 보임. GAP 선언의 목적(정직 노출) 자체가 무력화.
- 교정안(라우팅=builder): product-048 노드에 GAP 엣지 3개 작성 후 `build_graph.py` 재실행 —
  `product-048 --references--> gap-048-price-path-incomplete` · `--references--> gap-048-no-size` · `--references--> gap-048-material` (038 패턴 동형). derived_from가 스키마상 적합하면 그것을 사용.
- 라우팅(원천분): **원천 자체 결함(source-confirm)** — 048의 실제 가격경로 미완(사이즈 축·완전 공식 재바인딩)은 권위 엑셀 260702(리플렛 사이즈열)+§18/§26/§7(인간 승인) 필요. 검증가 교정 불가·gap_owner=설계.

## D2 [MEDIUM] GAP_roll_material_price — 그래프 완전 고립(가격경로 경계 GAP·dead knowledge)

- 노드: `GAP_roll_material_price` (`rule/gaps.md` L17)
- 결함 유형: 4 그래프 무결성 / 5 연결 완전성
- 증거: in=0 out=0. gap_what="롤 소재(현수막 등) 가격 계산 로직 — 엑셀 미기재". `rel` 필드 미선언이라 build 시 어떤 엣지도 생성 안 됨. gaps.md 색인엔 존재하나 그래프 질의로는 도달 불가.
- 심각도: **Medium** — 가격 계산 로직 공백이나 디지털(낱장)엔 직접 영향 적은 경계 기록. 그래도 그래프에서 dead.
- 교정안(builder): 색인 전용이면 스키마 규약으로 명시(예: index-only 표기)하거나, 경계 카테고리/롤소재 축에 `references` 엣지로 최소 1개 앵커. 판정은 architect(스키마: gap 최소 배선 규칙 유무) 확인 권장.

## D3 [LOW] GAP_product_count — 그래프 완전 고립(메타/스코프 GAP·비가격)

- 노드: `GAP_product_count` (`rule/gaps.md` L49)
- 결함 유형: 4 그래프 무결성
- 증거: in=0 out=0. gap_what="전체 상품 수 분모(191/243/280) 미통일". 비가격·메타 스코프 GAP.
- 심각도: **Low** — 가격경로 무관. 색인 전용 GAP으로는 허용 가능하나 orphan 정책 명시 필요.
- 교정안(architect): "메타 GAP은 그래프 고립 허용" 규약을 스키마에 명문화하거나 온톨로지 루트에 앵커.

---

## 형제 패턴 정합 (배정 확장분 표본 대조 — 반증 결과)

모두 정합이거나 divergence가 배선된 GAP으로 정직 선언됨(048 제외).

| 그룹 | 상품·공식 | 판정 |
|---|---|---|
| 박(foil) | 027(DGP_E+E_FOIL)·028(**E only**·박공식 부재→`gap-028-foil-price-path` 배선)·029(E+E_FOIL)·031(PREMIUM+_FOIL)·037(FOIL)·042(A+박 gap) | 정합. 028 박공식 누락=배선 GAP으로 정직 선언(형제 divergence). |
| 별색(spot) | 020·021·022 전부 PRF_DGP_A | 정합. 022 optgroup=0(별색 미배선)=`gap-022-spotcolor-unwired` 배선. |
| 완칼(diecut) | 023(DGP_B)·035(NAMECARD_SHAPE)·036(NAMECARD_MINISHAPE) | 정합(엽서/명함 공식군 상이=정상). 035/036 diecut공정 부재=`gap-035/036-diecut-process*` 배선. |
| 투명 PET | 019(DGP_A·mat=0)·025(PHOTOCARD_CLEAR)·039(NAMECARD_CLEAR) | 정합. 019 자재0(PET용지 미적재·기지 결함)=`gap-019-material`+`GAP_transparent019_pansu` 배선. |
| 봉투제작 | 050(PRF_ENV_MAKING·proc0·printopt0) | 정합(봉투제작=무인쇄·정상 특수모델). GAP 불요. |
| 썬캡 | 051(PRF_DGP_F·size1 SIZ_000535 330×540·`gap-051-golden` 배선) | 정합(3절 이관 기지 상태와 일치). |
| 전단/리플렛 | 047(DGP_D·size4)·**048(FOLD_SUM·size0)**·049(DGP_E·size1) | **048만 이상치** → D1. 048 -nodes.md 자체가 PRF_DGP_E를 완전 공식 후보로 명기, 라이브는 sub-formula PRF_FOLD_SUM 단독 바인딩=불일치. |

---

## 검증 범위·한계 (무결 단정 금지)

- 전 36상품 축 연결(priced_by/has_size/uses_material/has_process/has_option_group)은 **전수 스크립트**로 판정. 끊김 판정 SILENT/ORPHAN-GAP/DECLARED는 재현 스크립트 산출.
- 공식→구성요소→차원(option_refs) 리프 해소는 `price_path_traverse.py`로 DEAD-DST=0 확인(구성요소 리프 실재). **단, 각 구성요소가 "가격적으로 옳은" 차원을 참조하는지(값 정합)는 본 축 밖**(권위 260702 diff·§26 무결성 소관).
- 라이브 재조회 미수행(그래프·마크다운 전사값 신뢰) — 048 no-size 등 라이브 조건 자체의 옳고그름은 원천/실무진 컨펌 대상(source-confirm).
- alias_of DEAD-SRC 19건(`aliaslabel:*` src 노드 부재)은 용어집 축 문제로 관찰됨 — 본 가격경로 축 밖이라 미채점(그래프 무결성 검증가에게 이관 권장).
- codex 2차 미호출(Claude 단독).
