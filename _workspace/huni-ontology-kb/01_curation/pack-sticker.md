# 파일럿 큐레이션 팩 — 스티커(sticker)

> **작성:** okb-source-curator · 2026-07-03 (첫 작성 — 이전 팩 없음)
> **대상:** 스티커 상품군 = 상품마스터 260702 **스티커 시트**. **16 distinct 상품**(라이브 `PRD_000052`~`PRD_000067`),
>   L1 154 데이터행(형상/사이즈×자재 variant 평면화). 인쇄방식 5분기(디지털·실사·화이트·합판·전사).
> **목적:** 지식 구축가(okb-knowledge-builder)가 이 상품군을 온톨로지에 넣을 때, **축(axis)마다
>   어느 파일의 어느 절이 정답 소스이고, 무엇이 함정(STALE)이며, 원천이 없어 못 닫는 GAP이 무엇인지**를 못박는다.
> **선행 입력(정독 완료):** 같은 폴더의 `source-registry.md`(등급·§8 STALE 금지목록·260702 접근규칙)·
>   `pack-digital-print.md`(형식 참고) · `_workspace/print-kb/wiki/recipes/sticker.md`(REVERIFY 대조) ·
>   `_workspace/huni-dbmap/17_correctness/sticker/`(product-identity·correction-manifest 등) ·
>   `_workspace/huni-dbmap/26_change-tracking-260702/`(연당가 diff) · `live-snapshot/latest`(=snap_20260702_1119 실측).
> **선행 팩 계승:** `_workspace/print-kb/wiki/_curation/pack-sticker.md`(2026-06-12·round-13 기준)를 260702 권위 +
>   6월 말~7월 초 라이브 교정 이력으로 **갱신·확장**한 것. 원본 팩은 그대로 둔다(역사 기록).

---

## 0. 이 팩을 읽는 법 (쉬운 말)

- **정답 소스** = "이 축의 사실은 여기서 가져와라"의 1순위 파일·절·캐시.
- **보조 소스** = 정답을 교차 확인하거나 값을 채우는 2순위.
- **STALE 함정** = "그럴듯하지만 인용하면 틀리는" 오래된 원천. **왜** 틀린지와 **대체 소스**를 함께 적었다.
- **GAP(원천 부재)** = 어느 문서에도 정답이 없어서 지금은 못 닫는 것. 실무진 답변·인간 승인 대기.
- 표기: `tier`(A 절대권위 / B 정본문서 / C 하네스산출·최신우선 / D 역공학·경쟁사 보조),
  `freshness`(FRESH / PARTIAL-STALE(어느 축이 낡음) / STALE=인용금지).
- **수치 손전사 금지:** 아래 표의 모든 숫자는 결정론 diff/스냅샷 스크립트 전사(transcribed-by)다.
  260702 소재 단가 = `26_change-tracking-260702/price-diff-260527-260702.csv` 전사 · 라이브 = `live-snapshot/latest` awk 전사.
- **KB 답변 범위(사용자 확정·relitigate 금지):** 상품·구성요소·옵션·가격 차원·제약까지만.
  **주문·배송·회원·쿠폰은 범위 밖** — 이 팩도 그 축은 다루지 않는다(거절형 응답 경계).

**★스티커 파일럿의 3대 특성(다른 상품군과 다른 점):**
1. **형상(칼틀)이 곧 사이즈(size)다.** 합판도무송 066은 원형/정사각/직사각류 형상을 `siz_nm`으로 흡수한다(예 `정사각30x30mm(2EA)`).
   가격표가 형상별 격자라 형상=size가 정답(Q7 실무진 확정). 형상을 자재/옵션으로 오판 금지.
2. **가격 = 형상×치수×코팅 격자 = 완제품가(시트가격) 고정가 룩업.** 스티커는 원자합산형이 **아니다** —
   `COMP_STK_PRINT`(6,498행)·`COMP_GANGPAN_PRINT`(1,110행)에 (siz_cd, mat_cd, min_qty)로 완제품가가 통째로 저장된다.
   ★그래서 **소재 연당가(원자재 원가)는 스티커 가격사슬에 직접 노드로 존재하지 않는다**(§4 핵심).
3. **코팅 자재 오적재(BATCH-3 CONFLICT)가 살아있다.** 무광/유광코팅스티커가 자재(MAT_TYPE.11)로 적재(8상품)됐는데
   실무진 Q9는 코팅=공정(PROC_000013). 단 가격표가 비코팅/무광/유광 3컬럼(코팅=가격축)이라 CONFLICT 미해소 — 양면 표기만.

---

## 1. 스티커 정답 소스 요약 (한 눈에)

| 계열 | 경로 | tier | freshness | 역할 |
|------|------|------|-----------|------|
| **정체·정합 진단(round-13)** | `_workspace/huni-dbmap/17_correctness/sticker/`(product-identity.md §0~2·correction-manifest.md C-ST-01~17·loadlogic-notes.md·live-diff.md) | C13 | **PARTIAL-STALE** — 정체/의미 FRESH, 결함 상태값·prd_typ은 라이브 재분류로 낡음(§1.1·§4) | 16상품 정체·인쇄방식 5분기·오적재 8종 진단의 골격 |
| **차원 L1 무손실 캐시(구버전)** | `_workspace/huni-dbmap/06_extract/sticker-l1.csv`(154행)·`price-sticker-price-l1.csv`·`price-gangpan-sticker-l1.csv`·`import-paper-l1.csv`(출력소재) | A | PARTIAL-STALE(260702 diff 해당 셀만) | 사이즈·형상·자재·조각수 원본 셀값. diff에 없으면 곧 260702값 |
| **260702 델타 diff(결정론)** | `_workspace/huni-dbmap/26_change-tracking-260702/`(price-diff-260527-260702.csv·change-manifest-260702.md §C) | A | FRESH | ★소재 연당가/국4절 변경 15+1행 = 연당가 실측 1순위(§4) |
| **라이브 현재 상태** | `_workspace/_foundation/live-snapshot/latest/`(=snap_20260702_1119, t_* CSV+_manifest) | A(현재값) | FRESH(07-02 11:19) | "지금 DB에 뭐가 들었나". ★"현재값"이지 "정답" 아님 — 권위와 다르면 양면 표기 |
| **가격엔진 코드(단일 권위)** | `raw/webadmin/webadmin/catalog/pricing.py`(evaluate_price) | A | FRESH | 가격 계산 방식의 유일 알고리즘 권위 |
| **스티커 가격 완제품가 노드** | live `t_prc_price_components.csv`(COMP_STK_PRINT·COMP_STK_PACK·COMP_STK_TATTOO·COMP_GANGPAN_PRINT) + `t_prc_component_prices.csv` | A | FRESH | 형상×치수×코팅 격자 = 완제품가 룩업(§3.10·§3.11) |
| **제약규칙(§31)** | `_workspace/huni-constraint-rules/`(CN-1~CN-6·폼빌더 정형 shape) + live `t_prd_product_constraints.csv` | C | FRESH | 투명 베이스→화이트 requires 등 제약 shape |
| **배선 수렴(§27)** | `_workspace/_foundation/batch/wiring/HANDOFF.md`(round22)·`CONFIRM-QUEUE-260701.md` | C | FRESH | ★스티커 4상품 사이즈 재키잉 파손 복구 COMMIT(§4-C) |
| 위키 레시피 | `_workspace/print-kb/wiki/recipes/sticker.md`(STK-ID/DIM/BOM/PRC/CPQ/ST 블록) | C | PARTIAL-STALE | REVERIFY 대조용 — 결함표(7절)를 "현재 결함"으로 인용 금지(§2 T-6) |

### 1.1 ★라이브 재분류 신사실 (round-13 → 현재)

- **prd_typ_cd 재분류:** round-13 product-identity.md §0은 스티커 16상품 "전량 `prd_typ_cd=PRD_TYPE.04(디자인상품)`"이라 했으나,
  **live-snapshot 실측(07-02) = 전량 `PRD_TYPE.01`(완제품)**. SOT(디자인상품 .04 폐기→재분류)대로 교정 완료됨. round-13 .04 서술은 **STALE**.
  {transcribed-by `awk t_prd_products.csv`} → 온톨로지 정체 노드는 `PRD_TYPE.01`으로.
- **use_yn:** 063(반칼팬시투명)·064(소량자유형)만 `use_yn=N`(비활성). 나머지 14상품 `Y`. (round-13과 일치·FRESH)

---

## 2. STALE 함정 목록 (스티커 국한 — 인용 시 lint FAIL)

> 전역 금지목록은 `source-registry.md` §8. 아래는 **스티커 작업에서 특히 밟기 쉬운** 함정만.

| # | 함정 원천 | 왜 틀리는가 | 대체 소스 |
|---|-----------|-------------|-----------|
| T-1 | round-13 product-identity **"전량 prd_typ_cd=PRD_TYPE.04(디자인상품)"** | 라이브 재분류로 **PRD_TYPE.01(완제품)**이 현재값(§1.1) | live-snapshot `t_prd_products.csv` |
| T-2 | 위키 `[STK-PRC-002]`/recipe **"`pricing_dims`/`use_dims`=구설계·price-engine-ddl"** 인용 | `price-engine-ddl.md`는 STALE(§8-2). 차원=live `t_prc_price_components.use_dims` JSON | live `t_prc_price_components.csv`(use_dims) + pricing.py |
| T-3 | 위키 `[STK-CPQ-002]` **constraint_json 컬럼** | Phase10/11 삭제(실체 소멸). 제약=`t_prd_product_constraints.logic`(폼빌더 shape) | live `t_prd_product_constraints.csv` + §31 |
| T-4 | round-13 **"코팅=자재 오적재는 미해소 결함"을 단정** | Q9(코팅=공정) vs round-11 §44(자재 variant 정당)+가격표 3컬럼 = **CONFLICT 미해소·양면만**(BATCH-3) | correction-manifest C-ST-04·Q-ST-A + §31 (단정 금지) |
| T-5 | `load_master.py`의 **입력 v03 xlsx**(prdmaster_full_migration_v03) | round-13 오적재 진원(코팅·063화이트·자재유형/명 5건 상류 결함) | 260702 엑셀(§1 캐시) + 06_extract sticker-l1. **load_master는 로직(전파기)만 oracle** |
| T-6 | 위키 `recipes/sticker.md` **7절 결함표(STK-ST-001~010)를 "현재 결함"으로 인용** | 6월 말~7월 초 COMMIT으로 상당수 해소/변화(자재유형 정정·사이즈 재키잉 복구·prd_typ 재분류) — 시점이 낡음 | 각 행을 §4 + live-snapshot으로 "해소/잔존" 재판정 |
| T-7 | 위키 `[STK-DIM-002]`/`[STK-ST-005]` **"판수=앱 계산·DB 미저장"(PE-010 참조)** | 2026-07-01 반증: 판걸이수=DB 함수 `fn_calc_pansu`+`t_siz_pansu` lookup 신설 | `HARNESS-DOMAIN-RULES-260701.md` + `DEV-REQUEST-fn-calc-pansu-260701.md` |
| T-8 | 구 260527 소재 **연당가/국4절가의 무대조 인용**(투명스 130k·홀로 360k·크라프 156k 등) | 260702가 대체 — 15+1행 diff(§4). 특히 **연당가는 스티커 완제품가와 별개 축**(§4 혼동 금지) | `26_change-tracking-260702/price-diff-…csv` 먼저 |

---

## 3. 축별 큐레이션 (정답 → 보조 → STALE 함정 → GAP) — 12축

> 각 축의 "위키 재검증 대조 소스"는 `recipes/sticker.md`의 해당 블록 ID를 명시해 **REVERIFY(재검증 후 승계)** 대상을 구체 지목한다.

### 3.1 정체(identity) — 무엇인가

- **정답 소스:** `17_correctness/sticker/product-identity.md` §0 시트구조표·§1 16상품 정체확정표. {tier C13 · 의미 FRESH}
- **보조:** `06_extract/sticker-l1.csv`(prd_nm 원본 154행) · live `t_prd_products.csv`(prd_cd 실재·prd_typ·use_yn).
- **핵심 사실(승계):** 16 distinct 상품·**단일 카테고리(스티커)**·**인쇄방식 5분기**(디지털 토너 PROC_000004·실사 잉크젯 PROC_000006·화이트인쇄·합판·전사 열전사). 정체 오분류 0(비전형 상품 없음 — 굿즈파우치/배경지와 달리 전부 명백한 스티커). 스티커팩 065만 세트(sets).
- **위키 REVERIFY 대조:** `[STK-ID-001]`(16상품·5분기)·`[STK-ID-002]`(prd_cd 목록) → 의미 INHERIT. 단 **`prd_typ_cd`는 PRD_TYPE.01로 갱신**(§1.1·T-1). `[STK-ST-002]` 카테고리 root 거침 = §3.9 REVERIFY.
- **STALE 함정:** T-1(prd_typ .04)·T-6(결함표 시점).
- **GAP:** 상품 수 집계 기준(191/243/280 미통일 — source-registry §9 GAP-6). 스티커 16은 확정.

### 3.2 차원 — 사이즈(size) + 형상(칼틀)

- **정답 소스:** `17_correctness/sticker/product-identity.md` §1(형상=size)·correction-manifest.md **C-ST-01**(size L1 정합 CORRECT)·**C-ST-03**(합판형상=size Q7 종결). {tier C13 · FRESH}
- **보조:** `06_extract/sticker-l1.csv`(형상+치수 원본) · live `t_prd_product_sizes.csv`·`t_siz_sizes.csv`(siz_nm에 형상+치수 인코딩).
- **핵심 사실(★스티커 특유):** **형상(칼틀) = size 1:1**(합판도무송 066은 원형/정사각/직사각류 37 형상행을 `siz_nm`으로 흡수). 가격표가 형상별 격자라 형상=size가 정답. round-11 "형상 size 흡수=오모델" 가설은 **반증·철회**(C-ST-03).
- **위키 REVERIFY 대조:** `[STK-DIM-001]`(형상=칼틀 066) INHERIT(Q7 종결).
- **STALE 함정:** T-6.
- **GAP:** **[GAP-ST-3] 규격형 058~062 형상 저장처** — 규격원형/정사각/직사각/띠지/팬시(058~062)는 형상이 size에도(058 size=A4/A5뿐) prcs_dtl_opt에도 없음(F-ST-5·C-ST-06). 066(형상=size)과 동일 family인데 형상 모델 불일치 → Q-ST-C 실무진 대기.

### 3.3 차원 — 도수(색상 수) + 화이트 별색

- **정답 소스:** `17_correctness/sticker/correction-manifest.md` C-ST-14(화이트 053/054/056 CORRECT)·C-ST-07(063 화이트 누락) + `product-identity.md` F-ST-3. {tier C13 · FRESH}
- **핵심 사실(★도메인 [HARD]):** **화이트 underbase(PROC_000008)는 도수가 아니라 공정**(투명/홀로그램 베이스 위 인쇄 가시화·`clr_cd=NULL`). 별색/화이트=공정이지 print_side 슬롯 아님. 도수(칼라/흑백)는 `print_opt_cd`(인쇄옵션).
- **위키 REVERIFY 대조:** `[STK-BOM-002]`(화이트=공정) INHERIT. 053/054/056 연결 CORRECT.
- **STALE 함정:** T-2(clr_cd로 도수 인코딩).
- **GAP:** **[GAP-ST(화이트)] 063 화이트 underbase MISSING** — 반칼팬시투명(063, 자재=투명스티커)에 PROC_000008 미연결(053/054/056만). 도메인 필수 위반(G-SK-1). 진원=v03 15시트 063 화이트 행 부재. search-before-mint 충족(마스터 실재)이나 **미교정 잔존** — live `t_prd_product_processes` 재측정으로 확인. ★단 063은 `use_yn=N`(§1.1) → 출시 우선순위 Low.

### 3.4 차원 — 수량규칙(조각수·묶음수·bundle/qty)

- **정답 소스:** `17_correctness/sticker/correction-manifest.md` C-ST-05(조각수 066만 5행)·`product-identity.md` F-ST-4 + `_workspace/_foundation/batch/qty_rule_audit_260702.py`(수량 UI 권위=상품/사이즈 수량규칙). {tier C13/C · FRESH}
- **보조:** `06_extract/sticker-l1.csv` C25 `조각수(옵션)`(`*최대20조각`·`5~10조각`·`*1조각` 등 원본) · live `t_prd_product_bundle_qtys.csv`.
- **핵심 사실:** 조각수(판당 개수+제한)와 묶음수(권/세트)는 **다른 축**. 라이브 `bundle_qtys` = **합판도무송 066만 5행**(형상별 EA), 나머지 15상품 0행. Q8=둘 다 기록이 정답이나 조각수의 공정 param 저장처(`prcs_dtl_opt.조각수`)가 스키마 부재(OM-7) → 미실현.
- **위키 REVERIFY 대조:** `[STK-DIM-002]`·`[STK-ST-005]`(조각수 부분 GAP) → **"판수=앱 계산"(PE-010) 부분만 DROP**(§3.8·T-7). bundle_qtys 행수는 live 재측정.
- **STALE 함정:** T-7("판수=앱 계산·DB 미저장"). "bundle_qtys 0행=미적재"를 현재값으로 단정.
- **GAP:** **[GAP-ST-2] 조각수 저장처(Q-ST-B·OM-7)** — prcs_dtl_opt.조각수 상품레벨 저장처 부재·ref_param_json 미구현 선결.

### 3.5 자재(materials)

- **정답 소스:** `17_correctness/sticker/correction-manifest.md` C-ST-09(자재유형 .01↔.11)·C-ST-10(055/057 자재명 엠보) + `loadlogic-notes.md` L-ST-F. {tier C13 · FRESH}
- **보조:** live `t_mat_materials.csv`(유포/코팅/투명/홀로그램/데드롱 점착지) · `t_prd_product_materials.csv` · 260702 자재 diff=`26_change-tracking-260702/price-diff-…csv`(§4).
- **핵심 사실:** 스티커 자재 = 점착지(유포·코팅·투명·홀로그램·데드롱). 자재 모델 = **parent + usage_cd 단일 슬롯**. 정답 자재유형 = **MAT_TYPE.11(스티커)**.
  ★**라이브 재분류 진행:** MAT_000162(투명스티커)·084(비코팅)·242(미색)·243(투명커버) 등에 `note`에 "정정 2026-06-14: 종이(.01)→스티커(.11) 점착지" 마킹 실재 → **C-ST-09 자재유형 오염 상당수 교정됨**(round-13 "혼재" 서술은 부분 STALE).
- **위키 REVERIFY 대조:** `[STK-BOM-003]`(자재=점착지 parent+usage_cd) INHERIT · `[STK-ST-004]`(자재유형 .01/.11 혼재) = **REVERIFY**(6-14 정정 note 반영·live 재측정으로 잔존분만).
- **STALE 함정:** T-5(v03 자재 누락). ★[HARD 사용자지적] **실무진이 IMPORT 시트로 등록한 자재는 "배선 안 됐다"고 삭제 금지**(배선/단가 채울 갭 — 메모리 `formula-components-wiring-subtrack-260701`).
- **GAP:** 055/057 자재명 "유포지+엠보코팅" 복원(C-ST-10·멱등키 영향·컨펌). 타투전용지(전사·067)=종이(.01) 정당 가능(표본 컨펌).

### 3.6 공정(processes) — 커팅(반칼/완칼/도무송)

- **정답 소스:** `17_correctness/sticker/product-identity.md` §1·`loadlogic-notes.md` §1(커팅 C24) + correction-manifest C-ST-14/07. {tier C13 · FRESH}
- **핵심 사실(★스티커 정체 공정):** 커팅 = **반칼 Kiss Cut `PROC_000054`**(모양 input+조각수)·**완칼 Die Cut**·**스티커완칼(도무송) `PROC_000055`**(조각수만). 디지털=반칼·실사/화이트=완칼·합판=도무송. **타투(067)·스티커팩(065)=커팅 0행**(순수 인쇄물). 화이트 underbase(PROC_000008)·코팅(PROC_000013 정답)도 공정.
- **위키 REVERIFY 대조:** `[STK-BOM-001]`(커팅 공정) INHERIT · `[STK-BOM-002]`(화이트=공정) INHERIT.
- **STALE 함정:** T-3(dep_proc_cd oracle 소멸)·T-4(코팅=자재 미해소를 단정).
- **GAP:** **[GAP-ST-1] 코팅=공정 통일(Q-ST-A·BATCH-3)** — §3.9 상세.

### 3.7 인쇄옵션(print_options) — 도수·인쇄 방식

- **정답 소스:** live `t_prd_product_print_options.csv` · `t_prt_print_options`(도수 코드값) + pricing.py(인쇄비 계산). {tier A · FRESH}
- **핵심 사실:** 도수(칼라/흑백)=인쇄옵션 코드(§3.3). 인쇄방식 5분기가 root 공정으로 갈리므로 스티커 인쇄옵션은 상품별 단순. 인쇄옵션 FK=`t_prt_print_options`.
- **위키 REVERIFY 대조:** `[STK-ID-002]`의 인쇄방식 root → live `t_prd_product_processes`/`print_options` 재측정.
- **STALE 함정:** T-2(도수를 clr_cd로).
- **GAP:** 없음(스티커 인쇄옵션 축 단순·배선 결함 0 — 배선 HANDOFF round22).

### 3.8 판형(plate size) — 출력용지규격·판걸이수

- **정답 소스(★7월 정본화):** `_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md`(12규칙 SOT·판형/판걸이수) + `_workspace/huni-price-table-integrity/_batch/DEV-REQUEST-fn-calc-pansu-260701.md`. {tier B/C · FRESH}
- **보조:** `06_extract/import-paper-l1.csv`(출력소재·국전계열) · live `t_prd_product_plate_sizes.csv`·`t_siz_pansu.csv`(신설).
- **핵심 사실(★도메인 [HARD]):** 판형=**출력용지규격**(작업사이즈 아님)·**고객이 안 고름**→`fn_best_plate`가 판수>0 자동선택·판걸이수(UP수)=DB 함수 `fn_calc_pansu`(`t_siz_pansu` lookup 우선→기하 폴백)·**종이류에만 판형 유효**. 스티커 점착지=종이류→판형 대상.
- **위키 REVERIFY 대조(★DROP 확정):** `[STK-DIM-002]`/`[STK-ST-005]`의 **"판수=앱 계산·DB 미저장"(PE-010)은 DROP** — 대체=위 SOT + t_siz_pansu.
- **STALE 함정:** T-7(판수=앱 계산).
- **GAP:** 없음(디지털인쇄 판수 15 vs 18 GAP은 스티커 시트 외). 단 형상=size인 규격형은 판걸이수 산정 시 §3.2 GAP과 얽힐 수 있음(확인).

### 3.9 옵션그룹/제약(CPQ·constraints)

- **정답 소스:** `_workspace/huni-constraint-rules/`(CN-1~CN-6·폼빌더 정형 shape·§31) + live `t_prd_product_constraints.csv`. {tier C · FRESH}
- **보조:** `16_mapping-research/sticker/mapping-final.md`(속성→4엔티티) · live `t_prd_product_option_groups/options/option_items.csv`.
- **핵심 사실(★[HARD]):** 제약은 **폼빌더에서 읽고 조정 가능한 정형 shape로만**(raw JSONLogic escape hatch 금지·CLAUDE.md §31). 스티커 캐스케이드 제약 예 = 투명 베이스 → 화이트 underbase requires. 옵션=자재+공정 BUNDLE. 옵션참조(ref_dim_cd)는 같은 부모 prd_cd에 실재 필수(`fn_chk_opt_item_ref` 트리거).
- **★코팅 CONFLICT(BATCH-3·GAP-ST-1):** 라이브 코팅=자재(MAT_000155/156·8상품 052·058~062·064·066) vs Q9 권위 코팅=공정(PROC_000013). round-11 §44는 "코팅=자재 variant 정당"·가격표는 비코팅/무광/유광 3컬럼(코팅=가격축·§3.11). **양립 곤란·미해소** → 위키는 양면 표기만, 단정 금지.
- **위키 REVERIFY 대조:** `[STK-CPQ-001]`(속성→4엔티티)·`[STK-CPQ-002]`(constraints.logic 단일경로) → constraint_json(T-3) DROP. `[STK-ST-006]` CPQ 옵션 레이어 전면 미적재(BATCH-6) = live `option_items` 재측정.
- **STALE 함정:** T-3(constraint_json)·T-4(코팅 단정).
- **GAP:** **[GAP-ST-1] 코팅=공정 통일(Q-ST-A)** · **[GAP-ST-6] CPQ 옵션 레이어 일괄 적재(BATCH-6)** · 066 빈 옵션그룹(OPT-000004·option_items 0행) 논리삭제 제안(C-ST-12·hard-delete 금지).

### 3.10 가격공식(price formula) — 완제품가 격자

- **정답 소스:** `raw/webadmin/webadmin/catalog/pricing.py`(evaluate_price=단일 권위) + live `t_prc_price_components.csv`(COMP_STK_PRINT·COMP_STK_PACK·COMP_STK_TATTOO·COMP_GANGPAN_PRINT). {tier A · FRESH}
- **핵심 사실(★스티커 특유 — 원자합산형 아님):**
  - 스티커 = **완제품가(시트가격) 고정가 룩업**. `COMP_STK_PRINT` use_dims=`[siz_cd, mat_cd, min_qty]`(PRICE_TYPE.01)·`COMP_GANGPAN_PRINT`=`[siz_cd, mat_cd, min_qty]`(.02)·`COMP_STK_PACK`(팩)·`COMP_STK_TATTOO`(3장세트). {transcribed-by `awk t_prc_price_components.csv`}
  - 가격 = **형상×치수×코팅 격자**(코팅=비코팅/무광/유광 가격컬럼축). 면적매트릭스 아님·구간할인(t_dsc_*) **비대상**.
  - ★**소재 연당가(원자재 원가)는 이 완제품가 격자에 직접 들어가지 않는다** — 연당가는 상류 원가 참조(§4). 완제품 시트가격은 스티커 가격표(price-sticker/gangpan-sticker L1)에서 verbatim 적재.
- **★가격 경계(방법론):** 온톨로지는 **use_dims 차원 선언까지만** — 계산 로직은 evaluate_price 권위(KB 밖).
- **위키 REVERIFY 대조:** `[STK-PRC-001]`(형상×치수×코팅 격자·고정가형) INHERIT · `[STK-PRC-002]`(차원=live 실측)에서 **price-engine-ddl/use_dims 구설계 인용부 DROP**(T-2).
- **STALE 함정:** T-2(price-engine-ddl 8차원).
- **GAP:** 없음(공식 골격 확정·완제품가 모델).

### 3.11 가격구성요소(price components) + 단가행 차원(component prices)

- **정답 소스:** live `t_prc_price_components.csv`·`t_prc_component_prices.csv`(COMP_STK_* 실측) + `16_mapping-research/sticker/live-crosscheck.md` §5(Q7 가격표). {tier A/C12 · FRESH}
- **핵심 사실(실측·transcribed-by awk):**
  - COMP_STK_PRINT **6,498행**·COMP_GANGPAN_PRINT **1,110행**·COMP_STK_TATTOO **666행**·COMP_STK_PACK **1행**(54장1세트). 단가행=완제품 시트가격(예 SIZ_000170·MAT_000155 무광코팅·수량구간별 7,000→6,200→5,800원).
  - ★**연당가는 여기에 없다** — COMP_PAPER(용지비·use_dims=[plt_siz_cd, mat_cd])에 스티커 소재 mat_cd(162/163/164/372) **0행**(실측). 즉 스티커는 원가(연당가)를 절가 노드로 펼치지 않고 완제품가로 통째 저장(§4 결론).
- **★단가행 접기(방법론):** 단가행(스티커만 8,275행)은 노드로 펼치지 않고 **가격구성요소 노드의 속성/집계로 접는 것이 기본값**.
- **위키 REVERIFY 대조:** `[STK-PRC-001]`(component_prices 격자) INHERIT · `[STK-PRC-002]` 차원 = live 실측 권위.
- **STALE 함정:** T-8(구 연당가 무대조 인용). "가격 = 연당가 원자합산" 오모델(스티커는 완제품가).
- **GAP:** 없음(구조 확정). 단 §4 연당가 재적재 대기가 원가↔완제품가 정합의 열린 질문.

### 3.12 추가상품/템플릿(addons/templates)

- **정답 소스:** live `t_prd_product_addons.csv` · `17_correctness/sticker/`(스티커 addon 서술 소량). {tier A/C13 · FRESH}
- **핵심 사실:** 스티커는 addon 축이 상대적으로 얕음(단품 인쇄물). 스티커팩 065=세트(sets) — 구성품 데이터 필요(GAP). always-add 가드(use_dims에 opt_cd 미포함→silent 가산) 적용.
- **위키 REVERIFY 대조:** 스티커 레시피에 addon 전용 블록 없음 → live `t_prd_product_addons` 재측정 후 신규 등재(빈 축이면 GAP 표기).
- **STALE 함정:** T-6.
- **GAP:** **[GAP-ST-4] 스티커팩 065 세트 구성(Q-ST-E)** — sets=0(미적재). 구성품 데이터 필요.

---

## 4. ★핵심 임무 — 소재 연당가 260702 실측 대조 (돈-크리티컬)

> 260702 diff(§C)에서 **돈-크리티컬 1순위 = 출력소재(IMPORT) 시트 스티커 소재 연당가/국4절가 대개편**.
> 아래는 `26_change-tracking-260702/price-diff-260527-260702.csv` 전사(transcribed-by) + `live-snapshot/latest` awk 실측 대조.

### 4-A. 260702 권위 연당가/국4절가 변경 (price-diff 전사)

| 소재(260702 명) | live mat_cd | 연당가 260527→260702 | 국4절가 260527→260702 | 평량 260527→260702 |
|-----------------|-------------|----------------------|------------------------|---------------------|
| 투명스티커(백색후지) | MAT_000162(parent)·MAT_000371(child) | **130,000 → 149,500** | **1,300 → 499** | 105 → 50 |
| 홀로그램스티커 | MAT_000163·MAT_000590 | **360,000 → 253,700** | **936 → 846** | 50(무변) |
| 크라프트 스티커 | MAT_000164·MAT_000591 | **156,000 → 81,500** | **312 → 272** | 57(무변) |
| 투명스티커(투명후지) **[신규행]** | MAT_000372 | (신규) **222,000** | (신규) **740** | 50 |

> (부수·가격무관 라벨) 반투명 구매정보·아이보리 중분류 `특수지→특수가공지`·투명 구매정보 등 — 단가 무영향.
> {transcribed-by `Read price-diff-260527-260702.csv` L19~33}

### 4-B. 라이브 현재 상태 실측 (연당가가 어디 저장돼 있나)

**결론: 연당가(원자재 원가)는 라이브 스티커 가격사슬에 "가격노드"로 저장되지 않는다.** 실측 근거:
1. **t_mat_materials에 가격 컬럼 없음** — 소재 마스터는 `weight`(평량)만 저장, 연당가/국4절가 없음. {awk header 실측}
2. **COMP_PAPER(용지비)에 스티커 소재 mat_cd 0행** — 162/163/164/372/371 전부 COMP_PAPER 미등록(디지털 등 종이류만 COMP_PAPER 절가 보유). {awk `$2==COMP_PAPER` 실측}
3. **스티커 가격 = 완제품가(COMP_STK_PRINT 등)** — 소재 원가가 아닌 스티커 가격표(price-sticker/gangpan) verbatim. **그 가격표는 260702에서 무변경**(change-manifest §1 항목2: N2 라벨만 변경) → 완제품 retail 노드는 260702와 **일치**.

**단 라이브 소재 마스터 속성이 부분 stale:**
- **MAT_000162(투명스티커):** live 명=`투명스티커`·평량=`105.00`·upd=`2026-06-03`. 260702 권위=`투명스티커(백색후지)`·평량 50. → **명/평량 STALE**(부모 미갱신).
- **신규 소재코드 mint됨:** MAT_000371(백색후지)·MAT_000372(투명후지) 06-27 생성·MAT_000590(홀로 50g)·MAT_000591(크라프트 57g) 06-30 생성. 코드 축은 진행됐으나 **연당가/국4절가는 어디에도 미반영**(저장처 부재). {awk `t_mat_materials.csv` 실측}

### 4-C. 배선 수렴(§27)에서의 스티커 교정 이력 (원장 경로)

- **정리 문서:** `_workspace/_foundation/batch/wiring/HANDOFF.md`(round22)·`CONFIRM-QUEUE-260701.md` + 메모리 `formula-components-wiring-subtrack-260701`.
- **요약:** **스티커 4상품(052/053/058/055) 사이즈 재키잉 파손 복구 COMMIT**(정규코드 del_yn 복원+아트611/쿨코팅593 grp1단가 클론+A6=100x148·webadmin 8/8 PRICE≠0). 포토카드/투명포토카드 무료 확정·스티커=시트가격 확인. **스티커 몫 배선 결함 0**(round22 잔여 6건은 전부 아크릴 TBD).

### 4-D. price_dual_needed 판정 = **TRUE** (단, 양면 노드는 원가/속성 축 국한)

**판정 근거·builder 지침:**
- **양면(defect) 노드 필요 O — 소재 원가/속성 축:** 260702 연당가/국4절가(§4-A)가 라이브에 충실히 반영되지 않았다(연당가 저장처 부재 + MAT_000162 명/평량 stale). 이 4소재를 **양면 노드(current_value / authority_value·badge=defect)**로 만들어라. 이 노드들이 곧 **"연당가 재적재 워크리스트"**다.
  - 예: `투명스티커 소재 원가` → authority_value(260702)=연당가 149,500/국4절 499/평량 50/명 "백색후지" · current_value(라이브)=연당가 원가 미저장·MAT_000162 평량 105·명 "투명스티커"(구값) · badge=defect(High 재적재 대기).
  - 신규행 `투명스티커(투명후지)`(MAT_000372) = authority 222,000/740 · current 코드만 존재·단가 미반영 → 양면 defect.
- **양면 노드 필요 X — 완제품가(retail) 축:** 스티커 완제품 가격표(COMP_STK_PRINT 등)는 260702에서 무변경 → 라이브 retail=권위 일치. **retail 가격 노드는 dual 금지**(false-defect 방지). 다만 원가 급락(투명스 국4절 1,300→499·크라프 156k→81.5k)이 완제품가로 전파돼야 하는지는 **열린 질문**(재적재 후속·§5 GAP).
- **어느 쪽도 삭제 금지** — current(라이브 구값/미저장)와 authority(260702) 둘 다 보존해 재적재 추적.

---

## 5. 지식 구축가 인계 메모 (스티커 파일럿 착수 시)

1. **정체·형상=size·인쇄방식 5분기 의미**는 `17_correctness/sticker/`가 정답(FRESH). 단 **prd_typ은 PRD_TYPE.01로 갱신**(§1.1·T-1)·**결함 상태값은 §4/§3 각 축 REVERIFY로 재조준**(위키 🔴 직접 이관 시 T-6 오염).
2. **가격 모델은 완제품가(고정가 by siz×mat×qty)** — 원자합산형으로 오모델 금지(§3.10). 소재 연당가는 완제품가와 **별개 축**(§4).
3. **수치**는 `26_change-tracking-260702/price-diff-…csv` diff 먼저 → 없으면 `06_extract` L1 = 260702값. **엑셀 원본 반복 Read 금지**.
4. **★연당가 양면 노드(§4-D):** 4소재(투명스 백색후지·홀로그램·크라프트·투명 투명후지)를 defect 양면 노드로 — 재적재 워크리스트. **완제품 retail 노드는 dual 금지**(가격표 무변경).
5. **코팅 CONFLICT(BATCH-3·§3.9)·063 화이트 누락·조각수 OM-7·규격형 형상 저장처**는 미결 GAP — 단정 금지·양면/GAP 표기.
6. **범위 밖 거절:** 주문·배송·회원·쿠폰 질의는 KB 범위 밖(사용자 확정). 스티커 노드에도 그 축은 만들지 않는다.
7. **인용 전 §2 STALE 함정 + source-registry §8 통과 필수.**

### 미확정/사용자·실무진 확인 필요 (스티커)

- **[GAP-ST-1] 코팅=공정 통일(Q-ST-A·BATCH-3)** — 자재(라이브) vs 공정(Q9) vs 가격표 3컬럼. 양립 곤란·미해소.
- **[GAP-ST-2] 조각수 저장처(Q-ST-B·OM-7)** — prcs_dtl_opt.조각수 상품레벨 부재·ref_param_json 미구현 선결.
- **[GAP-ST-3] 규격형 058~062 형상 저장처(Q-ST-C)** — PROC_000055→054 교체+param vs siz_nm 통일.
- **[GAP-ST-4] 스티커팩 065 세트 구성(Q-ST-E)** — sets=0.
- **[GAP-ST(연당가)] 소재 원가 재적재(§4-D·돈-크리티컬)** — 260702 연당가/국4절 급변이 완제품 시트가격으로 전파돼야 하는지·소재 원가 저장처 신설 여부. 실무진+인간 승인.
- **[GAP-ST(화이트)] 063 화이트 underbase MISSING** — 미교정 잔존(단 063 use_yn=N·Low).
