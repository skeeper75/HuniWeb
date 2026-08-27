# 우산 SPEC 리서치 — 게시 위젯 전량(위젯 194 / 상품 193) 0원·-원 제거

> 4개 렌즈(diagnosis-artifacts / webadmin-manual-surfaces / authority-excel-260822 / prior-SPEC-memory-backlog)를 결함 축으로 재조립한 통합 서사. 모든 사실 주장에 `파일경로:라인`. 추정은 `[추정]` 배지. 렌즈 간 충돌은 뒤 `### contradictions`에 전부 노출했고 본문에서 임의로 봉합하지 않았다.

---

## 1. 목표 재정의 — "0원이 안 나온다"는 두 층의 문제다

우산 SPEC의 종료 조건 "게시 위젯 전량에서 가격이 0원/-원 없이 나온다"는, 진단 산출물 상으로는 **두 개의 독립 층**으로 갈린다.

- **1차 = 배선(값이 나옴)**: 상품에 가격 소스가 아예 없거나(E1), 공식→구성요소 배선이 비었거나(E2), 조회한 단가행에 도달하지 못함(E4). 결과는 `final=0`.
- **2차 = 정확도**: 판수 환산 실패(E5)·수량 경계(Q1)·셋트 합산(S1)처럼 **0원이 아니라 저청구**로 새는 층. 돈영향 집계가 이를 뒷받침한다 — `undercharge 841 · overcharge 0 · unknown 578 · none 12`(`_workspace/huni-widget-wiring/out/wiring-health-index.json`, money_impact 실측). 전 방향이 저청구다.

선행 SPEC은 E5를 E4에 흡수하지 말라고 HARD로 못박았다(`/Users/innojini/Dev/HuniWeb/.moai/specs/SPEC-WIDGET-WIRING-001/spec.md:233-234`) — 이유가 정확히 이 2층 구분이다. 0원은 눈에 띄지만 저청구는 안 띈다. 우산 SPEC이 "1차=배선"만 종료 척도로 삼으면, E5/Q1/S1 잔량이 통과로 위장된다.

또 하나 계승할 원칙: **PRICE=0을 "정상 빈 상태"로 취급 금지**(memory `huni-widget-red-price-never-zero.md`). 다만 같은 메모리가 **가격 권위는 `result_sum.PRICE` 단일 출처이며 per-line `result[].PRICE=0`은 정상**이라고 명시한다 — 검증 스크립트가 per-line 0을 세면 대량 오탐이 난다.

---

## 2. 결함유형 분류체계(taxonomy) — 엣지 15종 × 결함코드 2축

정본은 코드 상수로 고정돼 있다.

```
_workspace/huni-widget-wiring/bin/build_wiring_health.py:27
EDGES = ["W1","W2","W3","W4","W5","W6","C1","E1","E2","E3","E4","E5","S1","Q1","G1"]
```

v0.1.0의 10종(`out/REPORT-260821.md:56`)에서 `CROSS-VERIFY-260822.md:38-47`(N-1~N-6)의 권고로 E5(판수환산)·S1(셋트)·Q1(수량경계)·W6(엔진오류)·G1(게시 기본값 stale)이 추가됐다. 의미 정본표는 `spec.md:212-231`(+ INFO-1 기본값 미지정).

### 렌즈 A(정적 어댑터, `out/defects/widget-defects.jsonl` 389행 실측)

| 엣지·코드 | 건수 | 상품수 |
|---|---|---|
| E4 ZERO_FINAL | 282 | 48 |
| E4 UNCOVERED | 18 | 18 |
| E4 PRICE_MISSING | 13 | 7 |
| E4 ENGINE_ERROR | 13 | 13 |
| E4 NO_SOURCE | 6 | 2 |
| W4 ANCHOR_DELETED | 28 | 10 |
| W4 ANCHOR_MISSING | 11 | 4 |
| W2 PARENT_DEAD | 12 | 6 |
| E1 NO_FORMULA | 2 | 2 |
| C1 RULE_DEAD_REF | 2 | 2 |
| E3 MISSING_DIM | 1 | 1 |
| W4 MASTER_DELETED | 1 | 1 |

엣지 합계 E4 332 · W4 40 · W2 12 · E1 2 · C1 2 · E3 1 = 389. 심각도 critical 318 · high 28 · medium 31 · low 12.

### 렌즈 B(게시 위젯 194 실호출, `out/defects/lens-b-defects.jsonl` 194상품/중첩 488건)

E4 ZERO_FINAL 200 · E4 PRICE_GAP 182 · **E1 NO_SOURCE 75** · S1 SET_MEMBER_NO_SOURCE 26 · Q1 BELOW_MIN_QTY 5. 상품 verdict: BROKEN 66 · OK 119 · WARN 2 · NOT_EVALUATED 6 · INFRA_FAIL 1.

### 그 밖

- G1 34건 전부 `WIDGET_DEFAULT_STALE`(high) — `out/defects/g1-defects.jsonl`.
- TRUNCATED 11행은 별도 파일(`out/defects/truncated.jsonl`) — **결함이 아니라 커버리지 고지**.
- 전역(상품 비귀속) 27건 — `wiring-health-index.json.global_defects`: E4 price_grid 6 · E4 ORPHAN_PROC_VALUE 8 · E4 UNMAPPED 5 · **E2 빈배선 6 · E2 고아구성요소 2**.
- 가격 레이어 승계 553건(`out/defects/price-defects.jsonl`)은 별도 taxonomy이고 `HANDOFF.md:81`에서 "hdx §26 트랙 소관 — 위젯 트랙과 분리"로 명시 분리됐다.

### v0.2.0 최종 verdict

`BROKEN 78 · WARN 92 · NOT_EVALUATED 38 · OK 58`(`out/REPORT-260822.md:6-12`, index 실측 동일). 게시 여부 교차: BROKEN 중 게시 71 / 미게시 7, NOT_EVALUATED 38은 **전부 미게시**. 치명 엣지별 상품수: E4 54 · E1 15 · S1 11 · W4 10.

> 우산 SPEC 분모(게시)에 실제로 걸리는 것은 **BROKEN 71건 + WARN 일부**다. NOT_EVALUATED 38은 전부 미게시라 1차 배선 목표의 분모 밖이다.

---

## 3. 상위(사업) 분류 — 가격모델 3버킷 × 실패태그 5종

`out/AUDIT-BUCKETS-260822.md:11-21` — 조립가격 71 · 단품가격 14 · 세트가격 11 · 판정불가 1 = **97 고유상품**. 실패태그별: 매칭 단가 없음 50 · 단가 미등록 28 · 가격공식/단가 미구성 15 · 셋트 계산 실패 11 · 계산 실패 7.

근본원인 패턴: **P1 아크릴 재키 14상품 · P2 판형미환산 20상품(고신뢰, "판수 환산 불가" 텍스트 정확 일치 `AUDIT-BUCKETS-260822.md:213`) · P3 가격소스 미연결 15상품**.

이 97건은 우산 SPEC의 작업 큐로 쓰기 가장 좋은 단위다 — 이유는 §9(오프라인 진단의 과소집계) 참조.

---

## 4. 결함유형 → webadmin 실화면 매핑 (수정 수단 확정)

권위는 `out/PRICE-ADMIN-MAP-260822.md §F`(코드 라인 근거 동봉)이고, webadmin 소스 렌즈가 URL·폼필드·저장 엔드포인트 계약으로 이를 실행 가능한 절차까지 내렸다.

| 결함유형 | 고치는 화면 | URL | 저장 엔드포인트 |
|---|---|---|---|
| E1 가격소스 없음 (P3) | **가격 뷰어** | `/admin/price-viewer/?prd=` | `POST /admin/price-viewer/<prd_cd>/source/` = `price_source_save` |
| E4 매칭 단가 없음 (P1 재키) | **가격구성요소(MD) → 단가표 편집** | `/admin/price-component-md/` → `/admin/price-viewer/comp/<comp_cd>/edit/` | `POST .../comp/<comp_cd>/save/` = `price_grid_save` |
| E4 단가 미등록(공식 전체 0원) | **가격공식(MD)**에서 배선 유무 확인 → 없으면 인라인 추가, 있으면 단가표 | `/admin/price-formula-md/` | admin changeform 인라인(전용 JSON 엔드포인트 없음, §5) |
| S1 셋트 계산 실패 | **셋트상품 관리** | `/admin/set-products/` | 구성원 각각을 위 두 경로로 |
| E4 ENGINE_ERROR / Q1 | **가격 시뮬레이터**로 원인 구성요소 특정 → 단가표 정리 | `/admin/price-simulator/` | `POST .../simulate/` (읽기·검증용) |

주의 2건:
- **상품 뷰어 `/admin/product-viewer/` 는 가격 등록 화면이 아니다** — `build_product_tree(with_price_badge=False)`, `PRICE-ADMIN-MAP-260822.md:119`.
- **엔진 소스 우선순위**: 직접단가 > 공식. 직접단가가 있으면 공식은 조회조차 되지 않는다(`raw/webadmin/webadmin/catalog/pricing.py:568-592`, `PRICE-ADMIN-MAP-260822.md:21-22,140`). 이것이 §7 오탐 57건의 뿌리다.

### 4.1 `price_source_save` 폼 계약 (배선 1차 수단)

`raw/webadmin/webadmin/catalog/price_views.py:1505-1513` — JSON body `{kind, action}` 4종:

- `kind:"price"` → `apply_ymd`, `unit_price` (직접단가, `t_prd_product_prices`)
- `kind:"formula"` → `apply_bgn_ymd`, `frm_cd` (**상품↔공식 바인딩 — 배선 1차 수단**)
- `kind:"discount"` → `apply_bgn_ymd`, `dsc_tbl_cd`, `comp_cd`(''=총액). `comp_cd` 지정 시 현재 공식에 그 구성요소가 있는지 서버 검증 → 없으면 422(`price_views.py:1563-1568`)
- `kind:"tmpl_price"` → `tmpl_cd`, `apply_ymd`, `unit_price`

전부 `update_or_create`/`filter().delete()` → **멱등**. 프런트 필드 id: `#src-kind`·`#src-ymd`·`#src-price`·`#src-frm`·`#dsc-ymd`·`#dsc-comp`·`#dsc-tbl`(`catalog/templates/catalog/price_viewer.html:229-234,263-264,379-397`).

### 4.2 `price_grid_save` 계약 — **full-sync 이므로 위험**

`price_views.py:1313-1327`: 자연키=(apply_ymd + 차원컬럼 + dim_vals). **DB에만 있고 그리드에 없는 키는 삭제된다.** 안전장치는 "유효행 0인데 기존 데이터 존재 시 422 거부"(`:1421-1424`) 하나뿐.

> 이 계약은 선행 SPEC의 R12(값 삭제 금지, `spec.md:310-315`)와 정면으로 맞닿는다. 단가표 화면 조작은 **행 추가만** 하고, 기존 행이 페이로드에서 빠지지 않게 전체 그리드를 로드한 상태에서 저장해야 한다. 우산 SPEC은 이걸 HARD 절차로 박아야 한다.

### 4.3 price_views.py 쓰기 surface 전수

```
price_views.py:1312 @require_POST / :1313 price_grid_save(request, comp_cd)
price_views.py:1505 @require_POST / :1506 price_source_save(request, prd_cd)
price_views.py:1657 @require_POST / :1658 discount_grid_save(request, dsc_tbl_cd)
```
계산(부작용 없음): `:3093 price_sim_constraints` · `:3105 price_simulate` · `:3219 price_simulate_set` · `:3238 simulate_set_core`(위젯 `widget_api`와 공용 권위 함수).

---

## 5. 매뉴얼 준수 — "/admin/manual/ 방식"의 실체

`/admin/manual/`·`/admin/widget-manual/`은 **Django 템플릿이 없다.** `docs/admin-manual.html`·`docs/widget-manual.html`을 읽어 그대로 뱉는다(`webadmin/config/urls.py:371,373`, `webadmin/catalog/views.py:842,865`). 따라서 매뉴얼 원고 = `raw/webadmin/tools/manual_content.py`(924줄)·`tools/widget_manual_content.py`(816줄), 렌더러 = `tools/gen_admin_manual.py`·`gen_widget_manual.py`.

이는 memory `webadmin-manual-first-260823.md`의 "webadmin 화면 의미는 앱 내장 매뉴얼이 1차 참조, `_workspace/huni-admin-manual/manual/*.md`는 Phase 11 이전 stale이므로 가격 영역에 쓰지 말 것"과 정확히 일치한다.

### 매뉴얼이 규정한 '올바른 등록 절차' (`tools/manual_content.py:820-830`, verbatim)

1. **기준정보 채우기** — 카테고리·사이즈·자재·도수·인쇄옵션·공정 먼저
2. **상품 만들기** — 상품정보 추가 → 상품 뷰어에서 옵션·사이즈·공정 연결
3. **가격 얹기** — 가격구성요소·단가표 생성 → **가격공식으로 묶고** → **가격 뷰어에서 상품에 연결**
4. **검증** — 가격 시뮬레이터에서 실조건 최종가 확인

부수 규칙:
- 시계열: 같은 종류라도 적용일자별 다건, **최신 적용분이 현재가**. 할인 순서 = 구성요소 → 총액 → 등급.
- **0원 진단 FAQ**(`manual_content.py:720-723`): 시뮬레이터로 어느 구성요소가 0인지 → 원인은 대개 ⓐ 단가표에 그 조건 행 없음(차원값 불일치) ⓑ **적용일자가 미래인 단가**. 추적은 가격뷰어 '가격 구조 보기'(`/admin/price-viewer/<prd_cd>/diagram/`).
- **시작가 실패사유→조치표**(`manual_content.py:469`): "가격 소스 없음 / 구성요소 매칭 없음(0원)" → 가격 관리에서 데이터를 채워야 함. "판수 환산 불가" → 상품 뷰어 판형 섹션.
- **게시하면 그 상품의 시작가가 자동 재계산된다**(`widget_manual_content.py:254-256`). 게시 직전 확인창 3종(상품 게시여부 N / 시작가 미산출 / 책등 규격표 불일치)은 막지 않고 확인만.
- 위젯빌더 **[가격 진단] `#wb-diag-btn`**(`widget_manual_content.py:232,235`) — 가격 소스·구성요소별 매칭/제외 사유·할인 단계·오류 전문. 이것이 백로그 t8의 근거 도구다.

### 5.1 배선 1차 목표의 실행 병목 — **E2를 고칠 전용 엔드포인트가 없다**

`t_prc_formula_components`(공식↔구성요소 배선)를 쓰는 엔드포인트는 `price_views.py`에 **없다**. 유일 UI 경로는 표준 admin changeform 인라인:

```
raw/webadmin/webadmin/catalog/admin.py:1546-1548
# t_prc_formula_components 는 복합PK(frm_cd+comp_cd) → 단독 admin skip 대상이므로 인라인 전용.
_FormulaComponentsInlineBase = _make_inline(M.TPrcFormulaComponents, fk="frm_cd")
admin.py:1560 class TPrcFormulaComponentsInline(...)
```

즉 `/admin/catalog/tprcpriceformulas/<frm_cd>/change/?_popup=1` iframe에서 CSRF + 폼셋 POST(management_form 포함)로만 가능하다. gstack 브라우저 조작으로는 가능하나 `price_source_save`류 JSON 호출보다 자동화 난도가 훨씬 높다. **E2 전역 결함 8건(빈배선 6 + 고아구성요소 2)과 t4③(책자 공식 인쇄비·용지비 부재)이 전부 이 경로를 탄다.**

---

## 6. 배선(1차) 관점의 DB 실측 — 결함은 "참조 깨짐"이 아니라 "차원값 미적재"

`out/PRICE-DB-STATE-260822.md` 실측:

```
:18-24  formulas 110 / components 202 / formula_components 232 / component_prices 23573
        product_price_formulas 178 / product_prices 60 / product_sets 47
:87-91  a_direct 57 · b_formula 140 · c_set 19 · d_none 50   (분모 266)
:115    고아 구성요소(어느 공식에도 미배선)  79 / 202
:116    고아 공식(어느 상품에도 미바인딩)    10 / 110
:117-122 FK/코드값 고아 참조 전부 0건
:164-168 PRD_TYPE.01 가격소스 전무 2건 = PRD_000038 형압명함 · PRD_000220 폰스트랩
```

핵심 함의 3가지:

1. **FK 무결성은 0건 결함.** 즉 배선 실패는 참조 깨짐이 아니라 **코드 층 재키(re-key) 드리프트**다(`spec.md:126-127` — use_dims vs 등록차원 422쌍 중 미충전 단 2건).
2. **고아 공식 10건**(아크릴뱃지·명찰·스마트톡·지비츠·쉐이커코롯토 등 TBD 포함, `:136-145`)은 **가격뷰어에서 상품↔공식 바인딩만 걸어도 배선이 살아나는 후보** — 1차 우선순위의 최고 ROI 지점.
3. **고아 구성요소 79/202**은 공식 인라인(§5.1) 경로로만 해소된다.

재키 드리프트의 교정 원리는 메모리에 이미 실증돼 있다 — `size-match-by-product-linked-sizes.md`: "재단치수가 같아도 사이즈코드가 다르면 0원. `PRD_000155` 아크릴볼펜 `SIZ_000330/333` → 상품 연결은 `SIZ_000216/218`. **코드만 이관하니 2,200/2,700 정상 산출**." 값 무변경·삭제 없음이 이 교정의 형태다.

그리고 `use-dims-is-not-matching-axis.md`의 HARD: 엔진은 `NON_QTY_DIMS` 9종 전체로 매칭하고 **행 값 NULL은 와일드카드**(`pricing.py:136-148 _row_matches`, `if rv is None: continue`). 따라서 `use_dims` 체크박스만 켜는 조치는 절반짜리이고, **실제 조치는 단가행의 해당 컬럼에 값을 채우는 것**이다. 안 채우면 `ERR_DUPLICATE` → row=None → 그 구성요소가 합산에서 조용히 빠진다(= 0원이 아니라 저청구).

---

## 7. 오탐 57건 — 처리 방침과 근거

`out/REVIEW-260822.md:13,18-22` — 461건 중 **확정 301 · 오탐 57 · 미판정 103**.

근거 3중:

1. **엔진 계약** — 1순위 가격 소스는 공식이 아니라 직접단가(`pricing.py:568-581`, `REVIEW-260822.md:37-44`; 시뮬레이터 메타도 동일 순서 `price_views.py:1894-1903`). 굿즈처럼 직접단가로 파는 상품은 공식 바인딩 부재가 **정상**.
2. **실측** — E1 59건 중 직접단가 보유 57 = 오탐, 둘 다 없음 2 = 진짜 결함(`PRD_000038` 형압명함 · `PRD_000220` 폰스트랩), `REVIEW-260822.md:52-71`.
3. **원본 센서 정책** — `verify_price_coverage.py:186`(NO_FORMULA는 DRIFT 아님) · `:191`(exit 0) · `:199`(무공식 별도 표기). 어댑터의 critical 승격은 SPEC이 스스로 금지한 판정 mint(`spec.md §1.1` HARD, R3) — **"심각도 정책도 판정의 일부"**(`REVIEW-260822.md:82-84`).

반영: 461 → 404, E1 잔존 2건(`HANDOFF.md:59`, `:22`). DB 실측 정합: `t_prd_product_prices` 60행 / 활성 266 중 `a_direct` 57(`PRICE-DB-STATE-260822.md:23,87`).

**우산 SPEC 방침**: 직접단가 보유 상품의 공식 부재는 결함 아님 — 재적발 금지. 이 판정을 재현하려면 `price_source_save`의 `kind:"price"` 존재 여부를 선행 확인한 뒤에만 E1을 올린다.

---

## 8. 미판정 103건 — 처리 방침과 근거

구성 = ZERO_FINAL 90(책자 5상품) + TRUNCATED 13 (`REVIEW-260822.md:141-181`).

### 90건 — 센서가 축을 못 뽑았다 (결함 확정 불가)

책자 5상품 공식은 제본 공정 구성요소 단일(`use_dims`에 `proc_cd`)인데, 센서는 축을 `prod_dims`의 `kind=="fk"`에서만 뽑고(`verify_zero_quote.py:90-98`), 공정은 mand 표시분만 자동 포함(`:111-120`). 스냅샷 실측 `t_prd_product_processes.mand_proc_yn`이 5상품 전 공정 전부 비어 있음 → `proc_sels=None` → 전 조합 0원. 전 건 detail이 `"매칭 구성요소 0개"`이고 합산제외 항목 0 — **단가행 미도달이 아니라 조회조차 안 됨**(`REVIEW-260822.md:146-154`).

부수 발견(→ 백로그 t2): 트윈링책자 `PRD_000071` 연결공정은 `PROC_000021`인데 `COMP_BIND_TWINRING` 단가행 32건 전부 `proc_cd=PROC_000019`(무선제본) — `REVIEW-260822.md:159-161`, `HANDOFF.md:52`. **§6의 사이즈 재키 드리프트와 완전 동형이며, 공정축 버전이다.**

### 13건 — 결함이 아니라 커버리지 고지

`verify_zero_quote.py:298-304`는 조합 절단을 **silent truncation 방지 로그**로 방출한다. 어댑터가 이를 `dimension=E4` Defect로 만들어 461에 포함시킨 분류 오류(`widget_wiring_dx.py:54`). 미검사 조합 합계 2,184 — 합판도무송스티커는 1,110조합 중 32조합(2.9%)만 검사하고 WARN이다. **"0원 없음"의 근거가 아니다**(`REVIEW-260822.md:166-181`).

방침: 분류 유지 · 라우팅 `review` · "0원 없음 근거 아님" 명시(`HANDOFF.md:62`). 전수화는 백로그 t4.

### NOT_EVALUATED verdict — 제3의 축

두 가격 센서 모두 완제품만 스캔(`verify_price_coverage.py:180`, `verify_zero_quote.py:275-277`)인데 `build_wiring_health.py:264`에 미검사 상태가 없어 결함 0 = OK로 위장됐다(`REVIEW-260822.md:216-230`). 교정으로 NOT_EVALUATED 51건 도입 → v0.2.0에서 38건(PRD_TYPE.02 36 · .03 2, 사유 "가격 센서 미지원 유형 — 렌즈 B로 대체 평가"). **기권이 옳았다는 증거**: 감사 막힘 97건 중 우리 NOT_EVALUATED 13건이 전부 실제 막힘(`CROSS-VERIFY-260822.md:24`).

---

## 9. 교정 라우팅 — `auto_data 0`은 의도된 결과다

`worklist.csv` 1,431행 실측: **needs_authority 694 · review 616 · needs_design 121 · auto_data 0**(`REPORT-260822.md:22`와 일치).

엣지×클래스: E4|needs_authority 694 · E4|review 392 · E1|needs_design 77 · E3|review 68 · Q1|review 61 · G1|review 34 · W4|review 29 · S1|needs_design 26 · W5|review 18 · W4|needs_design 11 · W2|review 12 · E4|needs_design 6 · C1|review 2 · E3|needs_design 1.

`auto_data 0`의 근거: ANCHOR_DELETED 28건의 `del_yn` 복구는 결정론 교정이 아니라 판단이 필요한 재배선 — `PRD_000042` 자재 실측표(`REVIEW-260822.md:192-203`), 복구 시 구코드 자재 부활 → 중복 노출 + 잘못된 단가. HARD 규칙으로 승격(`HANDOFF.md:43-46`).

**"과등록 조사" 문구 금지**: `widget_wiring_dx.py:132` 문구가 2026-07 0원 견적 사고 재현 경로(`verify_zero_quote.py:5-9` 파일 첫머리 사고 기록)다. v0.2.0 AC13 "과등록/삭제 지시 0 · ANCHOR_* auto_data 0" PASS(`REPORT-260822.md:53`).

> 우산 SPEC 함의: **needs_authority 694건이 최대 덩어리이며, 이것은 §10의 권위 엑셀 없이는 손댈 수 없다.** "1차=배선" 목표를 needs_authority에 적용하려면 값의 정확도를 미룬 채 배선만 살리는 절차가 따로 필요하다(예: 공식 바인딩 먼저, 단가행은 2차).

---

## 10. 권위 엑셀 260822_1 — 구조는 그대로, 추출 캐시는 전부 STALE

### 실측 구조 (openpyxl read_only, 셀값 미전사)

**가격표 `docs/huni/후니프린팅_인쇄상품_가격표_260822_1.xlsx`** — 19시트, 전부 visible.
mtime `2026-08-25T17:53:05` · size 624,860 · sha256 `f4a3e4cae4c9bb7530507a1f77ca8eaf80c1d0e2506904d962c0c0f92661c5a9`

```
판걸이수 1071×30 · 출력소재(IMPORT) 1001×26 · 디지털인쇄비 1031×27 · 코팅 56×5
접지옵션 857×16 · 인쇄후가공 741×26 · 커팅타공 66×8 · 스티커 728×21
합판도무송스티커 667×29 · 봉투제작 8×9 · 명함포토카드 1067×26 · 후가공_박(소형) 954×26
엽서북떡메 996×14 · 제본 994×25 · 후가공_박(대형) 992×70 · 아크릴 1054×22
포스터사인 996×26 · 굿즈파우치(구간할인) 898×24 · 후가공_박(백업) 1000×65
```

**상품마스터 `후니프린팅_상품마스터_260822_1.xlsx`** — 13시트, 전부 visible.
mtime `2026-08-24T01:29:09` · size 1,402,706 · sha256 `46225a1a730abb445753949622fc68ccad66f4aa18bacca95b497695c4d9e946`

```
계산공식집초안 1108×27 · MAP 1063×26 · 디지털인쇄 1029×44 · 스티커 1095×37
책자 1011×46 · 포토북(가격포함) 1076×56 · 캘린더 976×38 · 디자인캘린더(가격포함) 962×35
실사 882×41 · 아크릴 1049×38 · 문구(가격포함) 940×37 · 굿즈파우치(가격포함) 1066×32
상품악세사리(가격포함) 1009×9
```

**시트 집합 diff = 0** (가격표 260705↔260822_1, 마스터 260703↔260822_1 모두 `only in A: [] / only in B: []`). 기존 러너의 `SLUG`/`SHEET_SLUGS` 매핑을 그대로 재사용 가능.

### 캐시 신선도 판정 — **260822 기준 추출 캐시가 존재하지 않는다**

- `_workspace/huni-dbmap/` 하위 추출 캐시: `06_extract`(260527) · `24_master-extract-260610/-260702/-260703` · `24_price-extract-260702/-260705`. **`*-260822*` 0건.**
- `_workspace` 전체에서 `260822` 이름 항목은 `_workspace/huni-widget-wiring/CROSS-VERIFY-260822.md` 단 1건(추출 캐시 아님).
- mtime: 최신 캐시 두 개 모두 `2026-07-05 03:48` ↔ 권위 원본 `2026-08-24` / `2026-08-25` → **약 50일 stale**.
- `24_master-extract-260703/_master-extract-summary.json` → `"source_file": "후니프린팅_상품마스터_260703.xlsx"` (다른 파일에서 생성됨이 매니페스트에 명시).
- `24_price-extract-260705/_price-extract-summary.json` → `source_file: null` (파일명 추적 불가, 디렉터리명으로만 식별).

**해시 대조는 불가**: 어떤 캐시 매니페스트에도 원본 xlsx 해시 필드가 없다. 위 sha256 2개는 **향후 대조 기준점**으로만 성립한다. 현 판정 근거는 (a) 260822 캐시 부재 (b) mtime 역전 (c) `source_file` 불일치 3종.

이는 memory `read-source-not-ask-260706.md`의 HARD("최신본만 사용, stale 금지")를 직격한다 — **현재 `needs_authority` 694건은 stale 권위로는 판정할 수 없다.**

### 재추출 경로 (경로 상수 1줄 교체)

```
_workspace/huni-dbmap/_scripts/run_extract_master_260703.py   # XLSX / SOURCE_FILE / OUT / SLUG 13항목
_workspace/huni-dbmap/_scripts/run_extract_price_260705.py    # m.XLSX / m.OUT monkeypatch
_workspace/huni-dbmap/06_extract/scripts/extract_price_sheets.py:36,43  # XLSX, SHEET_SLUGS(16)
_workspace/huni-dbmap/06_extract/scripts/extract_l1.py        # extract_sheet, load_threaded_comments
```

권위 정본 시트는 **상품마스터 첫 시트 「계산공식집초안」**(memory `master-formula-draft-sheet-sot.md`) — 상품군 공식 유형(`원자합산형`/`고정가형`/`면적매트릭스형`)이 "셋트 구성원에 공식이 없는 것이 정상인가 결함인가"를 가른다. **라이브만으로는 못 가른다.** 예: 트윈링책자(r72~78) 판매가 = 내지인쇄비+표지인쇄비+표지코팅비+제본비+용지비+후가공비 → t4③(책자 공식 구성요소 부재) 판정의 정답표.

---

## 11. 재사용 가능한 결정론 스크립트 (LLM 셀 분석 0 = OUT-5 준수)

### 가격표 시트 ↔ 가격구성요소 매칭 (핵심)

`_workspace/huni-price-table-integrity/_batch/scripts/`:
- `matrix_parse.py` — 권위 L1 CSV → 정규 격자(NormCell: sheet/block_id/plt_grade/clr/side/min_qty/unit_price/prc_typ/src_ref), 시트별 `ADAPTERS`. 단가 verbatim.
- `grid_diff.py` — 권위 격자 ↔ 라이브 `component_prices` 셀 diff. 5종 결함: `missing_cell`/`transpose`/`mismatch`/`prc_typ_typo`/`dim_missing`.
- `run_all.py` — 19시트 배치 드라이버 + `SHEET_REGISTRY`(status: DIFFED/AREA_PENDING/L2_PENDING/OUT_OF_SCOPE/UNMAPPED).
- `build_load.py` — 결함보드 → verbatim UPSERT SQL + BEGIN…ROLLBACK dryrun (transpose/dim_missing은 BLOCKED).
- 보조: `dim_conformance.py` · `digital_griddiff.py` · `paper_import_match.py` · `paper_import_sql.py`.

**재사용 시 필수 수정 1곳**: `run_all.py`의
```
EXTRACT = os.path.abspath(os.path.join(HERE, "..","..","..","huni-dbmap","24_price-extract-260705"))
```
→ 260822 재추출 디렉터리로 교체해야 260822 기준 검증이 된다.

> 단, `build_load.py`는 **SQL 산출**이다. 우산 SPEC은 라이브 DB 직접 수정 금지이므로 이 스크립트의 출력은 **`price_grid_save` 화면 입력을 위한 값 명세**로만 쓰고 SQL을 실행하지 않는다.

### 배선 검증

`_workspace/_foundation/batch/wiring_scan.py` — `formula_components` 배선 4종 결함(ORPHAN / DEAD_WIRE / DELETED_WIRE / NO_FORMULA) 전수 검출, 토큰 0 진척 측도, 산출 `wiring/wiring-status.json`·`wiring-summary.json`. 종료 척도 = 배선 결함 0. **§5.1의 E2 병목과 정확히 같은 대상.**

### 위젯 트랙 본진

`_workspace/huni-widget-wiring/bin/` — 권위 엑셀을 입력으로 받지 않고 라이브 스냅샷/게시 cfg/센서 defects 기반:
- `lens_b_runner.py` — 게시 위젯 실호출 가격 스윕. 판정 mint 금지, `verify_zero_quote.py` import + `widget_api._prep_selections/_prep_proc_sels/_prep_set_body` + `pricing.evaluate_price`/`price_views.simulate_set_core` 재사용.
- `build_wiring_health.py` — 판정 재생산 금지·승계만. **`HDX_EDGE`에 `price_grid`/`dim_conformance`/`wiring`/`component_merge` 항목이 이미 있어, 위 price-table-integrity·wiring_scan 산출을 엣지로 흡수하는 접점이 정의돼 있다.**
- `build_artifact.py` · `harvest_publish_cfg.py` · `harvest_sim_meta.py`

### webadmin 읽기전용 verifier

- `raw/webadmin/tools/verify_zero_quote.py` — 0원 견적 전수 적발(ZERO_FINAL/NO_SOURCE/UNDERCHARGE/ENGINE_ERROR). **우산 SPEC의 "0원/-원 없음" 종료조건과 1:1 대응.**
- `verify_price_coverage.py` — 상품 등록 base코드 ≠ 가격 적재 base코드 드리프트(MISSING_DIM/UNCOVERED). 검사차원 siz_cd·mat_cd·print_opt_cd·opt_cd·bdl_qty (proc_cd·plt_siz_cd 보류 ← t2가 여기 걸린다).
- `audit_published_prices.py` — **게시 위젯 194개 전수 가격계산 점검**(활성 버전 cfg act_yn=Y, `collect_price_variants.js` 재사용, `--products/--limit/--workers`).
- 기타: `verify_option_ref_integrity.py` · `verify_load.py` · `verify_optcode_integrity.py` · `gen_price_audit_doc.py` · `_diag_price_gap.py`.

---

## 12. 백로그 t2~t8 흡수 매핑

| 카드 | 요지 | 흡수 위치 | 수정 화면 |
|---|---|---|---|
| **t2** | 트윈링책자 `PRD_000071` 연결공정 `PROC_000021`인데 `COMP_BIND_TWINRING` 단가행 32건 전부 `PROC_000019` | **E4 — 코드 재키 드리프트(공정축)**. 사이즈판 드리프트의 동형 | 단가표 편집(`price_grid_save`) — 값 무변경·코드 이관, 삭제 금지 |
| **t3** | 책자 5상품 `mand_proc_yn` 전건 NULL → 센서 공정축 미스윕, ZERO_FINAL 90건 미판정 | **진단 커버리지(NOT_EVALUATED 해소)** + 부수 E4. 렌즈 B 러너에 공정축 전개 추가 완료(`progress.md`) | 잔여 = 위젯 공정 필수선택 여부 + 필수공정 등록 판단(상품 뷰어) |
| **t4** | ① TRUNCATED 전수화 ② AC5 합집합 증거 무효 수정 ③ 책자 공식에 인쇄비·용지비 구성요소 부재 | ①② = 커버리지/증거 묶음(**progress §M2'에서 완료 기록**), ③ = **E2 공식→구성요소 배선 누락** | ③은 가격공식 MD 인라인(§5.1). 권위 = 「계산공식집초안」 트윈링 전개식 |
| **t5** | 아티팩트 표시결함(`use_dims` JSON 파싱·`code_of` 한글 첫 토큰·ZERO_FINAL dim/value null) | **결함유형 아님 — 진단 산출물 품질**. progress §M2'에서 완료(`parse_use_dims`·정규식) | 회귀 항목으로만 승계 |
| **t6** | 게시중 무가격 15상품(완제품 2 + 기성 13) 가격원천 0 | **E1 NO_SOURCE**. 렌즈 B E1 75건과 같은 묶음 | 가격뷰어 `price_source_save` — **수단이 이미 우산 SPEC 규정과 일치** |
| **t7** | `PRD_000010` 행택끈 · `PRD_000218` 타이벡북커버 — 게시중이나 `t_wgt_widgets` 0건 = 감사 분모 밖. `PRD_000218`은 권위 엑셀 굿즈파우치 row88 가격 셀 **공란** | **E1 + 분모 밖 별항**. `PRD_000218`은 `needs_authority`(권위 부재 → 교정 불가, 실무진 문항) | — |
| **t8** | 위젯빌더 「가격 진단」(WB-DIAG) 근거 게시본 194(상품 193) 전수 진단. 제외 3분류 (A)진짜 결함 (B)정상 미매칭「가족 분담 면제」(C)미선택 차원. `WGT_000262` 일반현수막 `PRD_000138` above_max_size → 3,000원 저청구 | **우산 SPEC의 직계 모체** — 분모·수단·오탐 3분류 골격이 그대로 온다. 유형은 **Q1(경계) + E4(단가행 부재)** | 시뮬레이터로 특정 → 단가표 편집 |

---

## 13. 계승해야 할 HARD 제약 (통합)

1. **`raw/webadmin/**` 과 라이브 DB는 읽기 전용**(`spec.md:24-26`). 어댑터는 호출·이식만.
2. **DB write·DDL·COMMIT·위젯 재게시 = 인간 승인 게이트**(OUT-2). t6/t8 카드도 "DB write 0 · COMMIT은 인간승인"을 본문에 박아 두었다.
3. **값 삭제 금지(R12, `spec.md:310-315`)** — `suggested_fix`/worklist에 "과등록 조사"·"삭제" 시사 문구 0건, `ANCHOR_*`를 `auto_data`로 분류 금지. 근거: 2026-07 0원 견적 사고(`verify_zero_quote.py:5-9`).
4. **알고리즘 mint 금지 / search-before-mint**(`spec.md §1.1·§1.6`, R8, AC12) — 판정은 기존 5센서 + `widget_api._prep_*` + `pricing.evaluate_price` 호출·조립만.
5. **원본 센서에 없는 심각도 신설 금지**(R3). 이를 어겨 오탐 57건이 났다.
6. **미평가를 통과로 표기 금지**(`spec.md §3.3`, AC11) — `NOT_EVALUATED` 정식 verdict, TRUNCATED는 `OK`를 만들지 못한다.
7. **E5를 E4에 흡수 금지**(`spec.md:233-234`, AC10).
8. **모든 사실 주장에 `파일경로:라인`, 추정은 `[추정]`. LLM 셀 단위 분석 0**(OUT-5).
9. **원본 먼저 읽기**(memory `read-source-not-ask-260706.md`, HARD 프로세스) — 재질문 전 엑셀 셀 + 실무진 코멘트(`_workspace/_foundation/extract_sheet_notes.py`) + `pricing.py`. 최신본만.
10. **권위 정본 = 상품마스터 「계산공식집초안」**(memory `master-formula-draft-sheet-sot.md`).
11. **webadmin 화면 의미는 앱 내장 매뉴얼이 1차**(`tools/manual_content.py`·`widget_manual_content.py`). `_workspace/huni-admin-manual/manual/*.md`는 가격 영역에 쓰지 말 것.
12. **`use_dims` ≠ 매칭 축**, NULL = 와일드카드. 체크박스가 아니라 단가행 컬럼 값을 채워야 한다. `use_dims`(12종, `admin.py:156`)와 `OPT_REF_DIM`(7종)은 다른 목록.
13. **사이즈 매칭 기준 = 상품에 연결된 사이즈코드.** 교정은 "연결된 코드로 이관(값 무변경)".
14. **가격축으로 쓰려면 위젯에 「차원」 컴포넌트(`WGT_SRC_TYPE.01`)로 배치.** `.02` 옵션그룹은 `sel_opts` 별개 키 → **가격에 안 걸린다.**
15. **PRICE=0을 정상 빈 상태로 취급 금지.** 가격 권위 = `result_sum.PRICE` 단일 출처, per-line 0에 속지 말 것.
16. **파급 상품 수(blast_radius) 필수 표기** — 공유 구성요소 최대 31상품(`COMP_PRINT_DIGITAL_S1` 31 · `COMP_PAPER` 31 · `COMP_GOODS_FIXED_SIZ` 30, `spec.md:119-121`). 단가표 1개 수정의 파급을 표기 후 인간 판단.
17. **게시 상태 코드값 하드코딩 금지**(`plan.md:53-54`). 실측: `WGT_STS_TYPE.02`=게시됨 · 01=작성중 · 03=게시중단.
18. **[신규·우산 SPEC 고유] `price_grid_save` full-sync 안전 절차** — 그리드 전체를 로드한 상태에서만 저장. 부분 페이로드 저장은 나머지 행 삭제 = R12 위반.

---

## 14. '정상이므로 고치면 안 되는' 케이스 (오탐 방지 목록)

1. **무지 내지의 사이즈 0건 · 판형 0건** — 인쇄가 없으면 작업/재단 축이 성립하지 않음. `PRD_000302`·`PRD_000304`·`PRD_000306`·`PRD_000308`. **단 "가격이 없어도 된다"는 뜻은 아니다** — 종이값 소재는 별개 문항. 대조군: `PRD_000311` 트윈링책자-내지는 사이즈축이 정상적으로 필요.
2. **`t_siz_sizes.margin_*` NULL** — 결손이 아니라 "블리드 0 = 작업치수가 곧 사이즈". 단 작업≠재단인데 margin NULL인 행은 모순(`SIZ_000250`·`SIZ_000252`·`SIZ_000256`).
3. **공식 바인딩 없음(직접단가 보유 상품)** — 엔진 1순위가 직접가. `NO_FORMULA`를 결함으로 올리면 오탐 57건 재발(§7).
4. **고정가형 상품군** — 「계산공식집초안」 `[고정가형: …]`(스프링노트 4500 · 스프링수첩 3000 · 메모패드 5000 · 중철노트 2500, 엽서북/떡메모지). 공식/구성요소 부재가 정상.
5. **셋트 구성원의 공식 부재** — 정상/결함은 라이브가 아니라 「계산공식집초안」 공식 유형으로 가른다.
6. **t8 (B) 「가족 분담 면제」** — 형제 구성요소가 명시행으로 커버하는 정상 미매칭.
7. **t8 (C) 미선택 차원** — 손님이 아직 안 고른 축.
8. **INFO-1 기본값 미지정(`dflt_val` 없음)** — 결함 아님·고지만. 실측 103위젯.
9. **`A−B`(등록됐으나 미게시)** — 결함 아님(런칭 대기). 반대로 **`B−A`(게시됐는데 상품 비활성)는 치명** — 1건 `PRD_000165` 아크릴포카코롯토(`use_yn=N`).
10. **분모 차이(266 vs 194)** — 결함이 아니라 정보(`spec.md §1.3`).
11. **TRUNCATED(조합 절단)** — 커버리지 고지. 단 그 상품을 `OK`로 만들 수 없다.
12. **`PARENT_DEAD` 대량(500 규모)** — 원본 정책 승계로 WARN, 분모 제외 금지(R-1, `spec.md:354`).
13. **다중 항목 동시 변경 조합 미검사** — 감사와 동일한 설계상 한계이며 절단이 아니다.
14. **E5 0건(판형 자동 도출)** — 서버 경로(`_prep_selections` → `_select_default_plate`)를 타면 정상. 외부 감사의 E5 다수는 감사 도구가 판형 도출 없이 조립한 아티팩트로 `[추정]`.
15. **`PRD_000108` 탁상형캘린더 · `PRD_000042`** — 렌즈 B 서버 경로 전 조합 정상가(`final=6063, error=None`). 감사 문구만 보고 처리하면 오탐.
16. **per-line `result[].PRICE = 0`** — 번들 구성요소 라인의 0은 정상. 권위는 `result_sum.PRICE`.

---

## 15. 이 진단본을 유일 근거로 쓰면 안 된다 (명시 경고)

감사 97 vs widget-defects 매칭: 있음 57 · **only_audit 40** · only_defect 20(`AUDIT-BUCKETS-260822.md:158-162`). only_audit 40 중 13건은 NOT_EVALUATED, **23건은 오프라인이 WARN/OK인데 라이브는 막힘**("기본화면+1변경" 조합 한계). 결론: **오프라인 404건은 실제 막힘을 과소 집계한다**(`:166-168`). 감사 HTML(INPUT A, `docs/huni/widget-price-audit-260822.html`) 막힘 판정을 1차 근거, defects/health를 보조 근거로(`:174`).

미해결 인계 5건(`REPORT-260822.md:59-63`): ① stale 기본값 해석(리드 판정 대기 — G1 34건 계상 방식에 직결) ② AC7 재스모크 ③ `PRD_000036` INFRA_FAIL ④ E5 발화 조합 실존 여부 ⑤ 감사 도구 원본 확보.

`PRICE-DB-STATE §6` 미검증 4건도 미해소: PRD_TYPE.04/05 부재 사유 · 고아 구성요소 79건의 가격 영향 여부 · 상품-차원 결합 검증 · formula 바인딩 178−140=38행의 성격.

---

## 16. NONE found — 정직한 공백

- **`t_prc_formula_components` 전용 JSON 저장 엔드포인트: 없음.** `price_views.py` 전수 확인(쓰기 `@require_POST` 3개뿐). admin 인라인 폼셋 POST의 정확한 필드 prefix(`tprcformulacomponents_set-TOTAL_FORMS` 등)는 **미확인**.
- **v0.2.0 기준의 오탐/미판정 재집계표: 어느 산출물에도 없음.** "확정 301 · 오탐 57 · 미판정 103"은 v0.1.0(snap_20260821_2319) 기준이다.
- **260822_1 기준 추출 캐시: 0건.** `_workspace` 전수 `find` 확인.
- **캐시 매니페스트의 원본 해시 필드: 없음.** 소급 해시 대조 불가.
- **권위 엑셀 260705/260703 ↔ 260822_1 셀 값 diff: 미수행**(OUT-5 준수). 시트 집합 불변만 확인. 구파일 `max_row`가 read_only에서 `None`이라 행수 비교조차 불성립 — 재측정 시 `calculate_dimension()` 필요.
- **t8 (B)「가족 분담 면제」 판정 알고리즘: 카드 본문 한 줄 외 문서 없음.** WB-DIAG(`widget_builder.html`) 실코드 확인 필요.
- **`run_all.py` `SHEET_REGISTRY` 19시트 각각의 현재 status: 미확인**(레지스트리 본문 미독). 260822 재고정 시 실 diff 커버리지 비율 별도 확인 필요.
- **감사 §① 94개 PRD vs `audit-blocked-prds.json` §① 82개의 12건 차이: 미검증**(코드 추출 실패분으로 `[추정]`).
- **`discount_grid_save`(price_views.py:1658) 본문 검증 규칙, `price_component_change_with_grid.html`/`price_formula_change.html` 내부 필드 id, `docs/admin-manual.html`의 빌드 시각 동기화 여부: 미확인.**
- **어떤 스크립트도 실행하지 않았다** — 재사용 가능성은 소스 정적 판독 기준이며 260822_1 입력에서의 실동작은 미검증.
- **memory `authority-grid-is-not-sales-range.md`**는 여러 파일이 상호참조하나 지시 범위 밖이라 읽지 않았다 — 오탐 방지에 직결 가능, 별도 확인 권장.

---

## contradictions

렌즈 간·문서 간 충돌을 전부 노출한다. 어느 쪽도 임의로 채택하지 않았다.

### C1. 결함 총 건수 — 461 / 404 / 389

- **`out/REVIEW-260822.md:13`(교정 전)**: 461
- **`HANDOFF.md:22` §2 및 `out/REPORT-260822.md` §2(승계)**: 404
- **diagnosis-artifacts 렌즈의 파일 실측**: `out/defects/widget-defects.jsonl` = **389행**

389 vs 404의 15건 차이는 규명되지 않았다. `[추정]` TRUNCATED 11건이 별도 파일로 빠진 것 + α. **우산 SPEC의 건수는 파일 실측 재집계 후 확정해야 한다.**

### C2. worklist 행수 — 925 vs 1,431

- **`HANDOFF.md` §2**: 925행
- **`REPORT-260822.md` §2 + 파일 실측**: 1,431행 (헤더 포함 1,432)

diagnosis 렌즈 판단: HANDOFF는 v0.1.0 시점 수치. 단 문서 자체가 정정되지 않았다.

### C3. 게시 위젯 수 193 vs 194, 그리고 "상품 193"의 정의

- **`wiring-health-index.json`**: `published_widgets: 193`
- **`out/REPORT-260822.md` AC9 + `lens-b-defects.jsonl`**: 194 (194 == 감사 194)
- **prior-SPEC 렌즈 / `progress.md:141-143`**: 게시 위젯 분모 **194** · A∩B = **193** · **B−A = 1: `PRD_000165`**(`use_yn=N`)
- **`AUDIT-BUCKETS-260822.md:150-152`**: 판정불가 1건

diagnosis 렌즈는 "어느 쪽이 위젯 수인지 산출물 내부에서 일관되지 않는다"고 명시했고, prior-SPEC 렌즈는 "상품 193이 `PRD_000165` 포함/제외 중 어느 쪽인지 두 출처가 어긋날 여지가 있다"고 명시했다. **우산 SPEC이 분모 정의를 1줄로 못박아야 한다.**

### C4. 백로그 t6·t7·t8의 존재 여부

- **diagnosis-artifacts 렌즈**: "`HANDOFF.md:52-55`에 t2~t5만 정의돼 있고, **t6~t8 카드는 이 워크스페이스 산출물 어디에도 정의돼 있지 않다.**"
- **prior-SPEC 렌즈**: `.moai/state/kanban/backlog.json`의 `items[]`에서 **t2~t8 7건 전부 본문 확인**(전부 `"state": "queued"`, `"spec_id": null`)

두 렌즈는 서로 다른 출처를 봤다. 워크스페이스 HANDOFF와 칸반 backlog가 동기화돼 있지 않다는 사실 자체가 결과다.

### C5. t4·t5의 처리 상태 — queued vs 완료

- **`backlog.json`**: t4·t5 모두 `"state": "queued"`
- **`progress.md:161-164`(§M2' 잔여 정정)**: TRUNCATED 분리 · `parse_use_dims` · `evaluated_by` 증거화 = **t4①②·t5 완료 기록**

prior-SPEC 렌즈 판단: 카드 상태 미갱신인지 부분 처리인지 판정 불가. 새 SPEC은 t4·t5를 "완료 확인 후 흡수"로 다뤄야 한다.

### C6. E1 건수 — 렌즈 A 2건 vs 렌즈 B 75건 vs 카드 15건

- **렌즈 A(정적, `widget-defects.jsonl`)**: E1 NO_FORMULA **2건**(오탐 57 제거 후)
- **렌즈 B(실호출, `lens-b-defects.jsonl`)**: E1 NO_SOURCE **75건**
- **`wiring-health-index.json` 치명 엣지별 상품수**: E1 **15**
- **백로그 t6 카드**: 게시중 무가격 **15상품**(완제품 2 + 기성 13)
- **`PRICE-DB-STATE-260822.md:87-91`**: `d_none`(가격소스 전무) **50건** / 분모 266, 그중 PRD_TYPE.01은 **2건**

같은 "가격 소스 없음"이 분모(266 전체 / 게시 194 / PRD_TYPE.01만)와 판정 층(정적 vs 실호출)에 따라 2 / 15 / 50 / 75로 갈린다. **한 숫자로 합칠 수 없다** — 우산 SPEC은 어느 분모의 E1을 종료조건으로 삼는지 명시해야 한다.

### C7. 수정 수단 — 선행 SPEC OUT-2 vs 우산 SPEC 지시

- **prior-SPEC 렌즈**: `spec.md` OUT-2가 **DB write·DDL·COMMIT·위젯 재게시를 전부 인간 승인 게이트**로 묶었다. `raw/webadmin/**`도 읽기 전용.
- **우산 SPEC 지시**: 수정 수단 = **webadmin 실화면(가격공식·가격구성요소·가격뷰어)** — 즉 화면 조작으로 DB를 바꾼다.

prior-SPEC 렌즈가 이 충돌을 직접 지적했다: "코드 읽기전용은 유지하되 **화면 조작은 별도 층**임을 명시해야 충돌이 없다." 또한 매뉴얼(webadmin lens)은 "**게시하면 그 상품의 시작가가 자동 재계산된다**"고 기록하므로, 화면 교정 후 재게시가 필요한 경우 OUT-2의 재게시 금지와 직접 충돌한다. **우산 SPEC이 명시 해제하지 않으면 실행 불가 조항이 남는다.**

### C8. `price_grid_save` full-sync 삭제 vs R12 값 삭제 금지

- **webadmin 렌즈**: `price_views.py:1313-1327` — "DB에만 있고 그리드에 없는 키는 **삭제**된다". 안전장치는 "유효행 0 + 기존 데이터 존재" 한 케이스뿐.
- **prior-SPEC 렌즈**: R12 [HARD] — "등록값 삭제 금지 … 2026-07 0원 견적 사고 재현 경로".

도구의 기본 동작이 HARD 제약을 위반할 수 있다. §13-18에 절차적 방어를 제안했으나, **이 충돌은 도구 계약 차원에서 해소되지 않았다.**

### C9. 권위 stale — memory HARD vs 실측 캐시 상태 vs 대량 라우팅

- **prior-SPEC 렌즈(memory `read-source-not-ask-260706.md`)**: "최신본만 사용(stale 금지)" = HARD 프로세스
- **authority-excel 렌즈 실측**: 260822 기준 추출 캐시 **0건**, 최신 캐시는 약 50일 stale, `run_all.py`가 `24_price-extract-260705` 하드코딩
- **diagnosis 렌즈**: `worklist.csv`의 최대 덩어리가 **needs_authority 694건**

세 사실을 합치면: **694건은 현재 권위로 판정 불가 상태다.** 재추출(경로 상수 교체) 없이 needs_authority를 진행하면 HARD 위반이다. 어느 렌즈도 이 결론을 명시하지 않았으므로 여기서 병치만 해둔다.

### C10. E5 — 엣지 신설 근거 vs 실측 0건

- **`CROSS-VERIFY-260822.md:38-47`(N-1~N-6)**: E5(판수환산) 신설 권고 → 채택
- **`spec.md:233-234` [HARD]**: E5를 E4에 흡수 금지
- **`progress.md:176-188` 실측**: **E5 0건**. 서버 경로(`_prep_selections` → `_select_default_plate`)를 타면 판형 자동 도출. "**결론[추정]**: 감사 도구는 `_prep_selections`를 거치지 않고 조립했다"
- **`AUDIT-BUCKETS-260822.md:213`**: 근본원인 P2 = **판형미환산 20상품**, "고신뢰 — 텍스트 그렙 정확 일치"

감사는 판수 환산 실패를 20상품 규모로 보고, 렌즈 B 실호출은 0건을 본다. 한쪽은 아티팩트일 수 있으나 **어느 쪽이 아티팩트인지 미확정**이며, `REPORT-260822.md:59-63`의 미해결 5건 중 "E5 발화 조합 실존 여부"로 남아 있다.

### C11. 오프라인 진단의 커버리지 — "404건" vs "과소 집계"

- **`HANDOFF.md`/`REPORT-260822.md`**: 결함 404건이 승계 수치
- **`AUDIT-BUCKETS-260822.md:166-168`**: only_audit 23건은 오프라인 WARN/OK인데 라이브는 막힘 → "**오프라인 404건은 실제 막힘을 과소 집계**"
- **`REVIEW-260822.md:172-181`**: 미검사 조합 2,184, 합판도무송스티커 2.9%만 검사

같은 워크스페이스 안에서 "404가 전량"과 "404는 과소"가 병존한다. `AUDIT-BUCKETS-260822.md:174`는 **감사 HTML을 1차 근거, defects/health를 보조**로 두라고 결론냈으나, 감사 HTML 원본 확보는 미해결 5건 중 하나다.

### C12. 매뉴얼 정본 경로 — 두 후보

- **webadmin 렌즈**: 매뉴얼은 Django 템플릿이 없고 `docs/admin-manual.html` 정적 서빙 → 원고는 `tools/manual_content.py`
- **prior-SPEC 렌즈(memory `webadmin-manual-first-260823.md`)**: 동일 결론 + "`_workspace/huni-admin-manual/manual/*.md`는 Phase 11 이전 **stale**이므로 가격 영역에 쓰지 말 것"

이 둘은 일치한다. 다만 webadmin 렌즈가 "`docs/admin-manual.html`이 현재 소스 원고와 동기화된 최신 빌드인지 **생성 시각 미확인**"이라고 남겼으므로, **화면에 실제로 뜨는 매뉴얼과 원고가 어긋날 가능성은 열려 있다**(미검증).