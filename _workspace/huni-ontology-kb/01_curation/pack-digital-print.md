# 파일럿 큐레이션 팩 — 디지털인쇄(digital-print)

> **작성:** okb-source-curator · 2026-07-03 (첫 작성 — 이전 팩 없음)
> **대상:** 디지털인쇄 상품군 = 상품마스터 260702 **시트2**(가장 복잡·별도설정 9건).
>   36 distinct 상품 / 7 구분 그룹(엽서·포토카드·접지카드·명함·상품권·배경지·인쇄홍보물).
> **목적:** 지식 구축가(okb-knowledge-builder)가 이 상품군을 온톨로지에 넣을 때, **축(axis)마다
>   어느 파일의 어느 절이 정답 소스이고, 무엇이 함정(STALE)이며, 원천이 없어 못 닫는 GAP이 무엇인지**를
>   못박는다. 이 팩을 통과하지 않은 인용은 STALE 오염 위험이 있다.
> **선행 입력(정독 완료):** 같은 폴더의 `source-registry.md`(등급·§8 STALE 금지목록·260702 접근규칙)·
>   `wiki-inheritance-map.md`(§9 위키 승계 판정)·`pilot-candidates.md`(디지털인쇄=1순위 근거).
>   방법론 = `../00_research/methodology-playbook.md`(7대 원칙·D-1~D-22).
> **선행 팩 계승:** `_workspace/print-kb/wiki/_curation/pack-digital-print.md`(2026-06-12·round-13 기준)를
>   260702 권위 + 7월 초 라이브 교정 이력으로 **갱신·확장**한 것. 원본 팩은 그대로 둔다(역사 기록).

---

## 0. 이 팩을 읽는 법 (쉬운 말)

- **정답 소스** = "이 축의 사실은 여기서 가져와라"의 1순위 파일·절·캐시.
- **보조 소스** = 정답을 교차 확인하거나 값을 채우는 2순위.
- **STALE 함정** = "그럴듯하지만 인용하면 틀리는" 오래된 원천. **왜** 틀린지와 **대체 소스**를 함께 적었다.
- **GAP(원천 부재)** = 어느 문서에도 정답이 없어서 지금은 못 닫는 것. 실무진 답변·인간 승인 대기.
- 표기: `tier`(A 절대권위 / B 정본문서 / C 하네스산출·최신우선 / D 역공학·경쟁사 보조),
  `freshness`(FRESH / PARTIAL-STALE(어느 축이 낡음) / STALE=인용금지).
- **KB 답변 범위(사용자 확정·relitigate 금지):** 상품·구성요소·옵션·가격 차원·제약까지만.
  **주문·배송·회원·쿠폰은 범위 밖** — 이 팩도 그 축은 다루지 않는다(거절형 응답 경계).

**★디지털인쇄 파일럿의 핵심 특성(pilot-candidates §2.1 근거):** 이 상품군은 후니에서 "가장 많이
다뤄지고 가장 많이 고쳐진" 군이다. 그래서 **위키(2026-06-12·round-13)의 결함 서술 상당수가
7월 초 라이브 COMMIT으로 이미 해소**됐다. 즉 위키의 🔴 결함을 "현재 결함"으로 인용하면 틀린다 —
이 팩의 최대 임무는 그 "해소 여부"를 정확한 최신 문서로 재조준하는 것이다(→ §3 축별 표의 STALE 열·§4 교정 이력).

---

## 1. 디지털인쇄 정답 소스 요약 (한 눈에)

| 계열 | 경로 | tier | freshness | 역할 |
|------|------|------|-----------|------|
| **정체·차원·자재·공정 결함진단(round-13)** | `_workspace/huni-dbmap/17_correctness/digital-print/`(product-identity.md·correction-manifest.md C-01~18) | C13 | **PARTIAL-STALE** — 정체/의미는 FRESH, 결함 상태값은 7월 교정으로 낡음 | 정체·구분·오적재 진단의 골격. 결함 "현재값"은 §4로 재조준 |
| **차원 L1 무손실 캐시(구버전)** | `_workspace/huni-dbmap/06_extract/digital-print-l1.csv`(+meta)·`price-digital-print-price-l1.csv` | A | PARTIAL-STALE(260702 diff 해당 셀만) | 사이즈·자재·공정·수량 원본 셀값. diff 65행에 없으면 곧 260702값 |
| **260702 델타 diff(결정론)** | `_workspace/huni-dbmap/26_change-tracking-260702/`(master-diff·price-diff·change-manifest) | A | FRESH | 구값→신값 대조 1순위. 엑셀 원본 재열람 대신 이걸 먼저 |
| **라이브 현재 상태** | `_workspace/_foundation/live-snapshot/latest/`(=snap_20260702_1119, t_* CSV+_manifest) | A(현재값) | FRESH(07-02 11:19) | "지금 DB에 뭐가 들었나". ★"현재값"이지 "정답" 아님 — 권위와 다르면 양면 표기 |
| **가격엔진 코드(단일 권위)** | `raw/webadmin/webadmin/catalog/pricing.py`(evaluate_price) | A | FRESH | 가격 계산 방식의 유일 알고리즘 권위 |
| **디지털 가격공식 설계** | `_workspace/print-kb/wiki/02_mapping/digital-print-engine/`(PRF_DGP_A~F·COMP_PAPER·BLOCKED csv) | C2 | 공식사슬 FRESH·차원컬럼 PARTIAL-STALE | 원자합산형 공식 6종 골격 |
| **★7월 가격구성요소 교정(§26)** | `_workspace/huni-price-table-integrity/_batch/`(digital-print-baseproc-260701.md 등) + `HANDOFF.md` | C | FRESH | base 공정 18건·완칼 교정·판걸이수 — §4 상세 |
| **★배선 수렴(§27)** | `_workspace/_foundation/batch/wiring/HANDOFF.md`(round22) | C | FRESH | 가격구성요소↔공식 배선 결함 0 달성 상태 |
| CPQ 옵션 파일럿 | `_workspace/print-kb/wiki/10_configurator/postcard-option-layer.md` | C6 | FRESH(설계) | 엽서 옵션 레이어 설계(미적재였음 — §3 재조준) |
| 위젯 계약 | `_workspace/huni-widget/03_spec/`(data-contract.md 등) + 5클래스 명세 메모리 | D | FRESH | 정규화 계약 일반형(범위상 KB 부차) |

---

## 2. STALE 함정 목록 (디지털인쇄 국한 — 인용 시 lint FAIL)

> 전역 금지목록은 `source-registry.md` §8. 아래는 **디지털인쇄 작업에서 특히 밟기 쉬운** 함정만.

| # | 함정 원천 | 왜 틀리는가 | 대체 소스 |
|---|-----------|-------------|-----------|
| T-1 | `16_*/digital-print/mapping-final.md` **"180g 코팅→constraint_json"** | constraint_json 컬럼은 Phase10/11에서 삭제됨(실체 소멸). 제약은 `t_prd_product_constraints.logic`(폼빌더 shape) | live-snapshot `t_prd_product_constraints.csv` + `_workspace/huni-constraint-rules/`(§31) |
| T-2 | `16_*/digital-print/mapping-final.md` **"엽서 13종"** | round-13 C-01에서 **7행**으로 반증(엑셀 L1 nonblank=라이브 일치) | `06_extract/digital-print-l1.csv` + live `t_prd_product_sizes` 재측정 |
| T-3 | `extraction-plan.md` L56 **dep_proc_cd oracle** | dep_proc_cd(자재→공정 게이팅) 컬럼 소멸. 대체경로=§31 제약규칙 | live-snapshot 컬럼 실측 + §31 |
| T-4 | `price-engine-ddl.md` 전체 / `prcx01-pricing-model.md`·`pricing-erd.md` | 8차원·clr_cd(도수를 색상코드로) 구설계 — 엔진 미참조·라이브 부재(§14 진단) | pricing.py 직접 + live `t_prc_*` |
| T-5 | `load_master.py:39` **입력 v03 xlsx**(prdmaster_full_migration_v03) | round-13 오적재 진원. 배경지 시트15 행 부재의 원인 | 260702 엑셀(§1 캐시) + 06_extract L1. **load_master는 로직(전파기)만 oracle** |
| T-6 | 위키 `recipes/digital-print.md` **§7 결함표(C-01~18)를 "현재 결함"으로 인용** | 7월 초 대량 COMMIT으로 상당수 해소(§4) — 시점이 낡음 | 각 행을 §4 교정 이력 + live-snapshot으로 "해소/잔존" 재판정 |
| T-7 | 위키 `[DGP-PR-001]`·`[DGP-DM-...]`의 **"판수=앱 계산·DB 미저장"(PE-010 참조)** | 2026-07-01 반증: 판걸이수=DB 함수 `fn_calc_pansu`+`t_siz_pansu` lookup 신설(§4-C) | `HARNESS-DOMAIN-RULES-260701.md` + `DEV-REQUEST-fn-calc-pansu-260701.md` |
| T-8 | 구 260610/260527 수치의 무대조 인용(디지털 시트 셀) | 260702가 대체 — 디지털 시트도 diff 대상일 수 있음 | `26_change-tracking-260702/master-diff-…csv`·`price-diff-…csv` 먼저 |

---

## 3. 축별 큐레이션 (정답 → 보조 → STALE 함정 → GAP)

> 각 축의 "위키 재검증 대조 소스"는 `recipes/digital-print.md`의 해당 블록 ID를 명시해
> **REVERIFY(재검증 후 승계)** 대상을 구체 지목한다(승계맵 §4 레시피 공통규칙 준수).

### 3.1 정체(identity) — 무엇인가

- **정답 소스:** `_workspace/huni-dbmap/17_correctness/digital-print/product-identity.md` §0(distinct 36 표·F-ID-0) + §1 정체확정표.
  {tier C13 · FRESH — 정체/의미는 시점 무관하게 유효}
- **보조:** `06_extract/digital-print-l1.csv`(prd_nm 원본) · live-snapshot `t_prd_products.csv`(prd_cd 실재 확인).
- **핵심 사실(승계 가능):** 36 distinct 상품 / **"7"은 상품 수가 아니라 7개 구분 그룹**(round-11/12 "7상품" 오표기 정정).
  배경지(043/044/045)=카테고리 012 **포장** 세트 상품(일반 인쇄물 아님)·라벨택(046)=포장 단품.
- **위키 REVERIFY 대조:** `[DGP-ID-001]`(36/7구분)·`[DGP-ID-002]`(구분별 prd_cd)·`[DGP-ID-003]`(배경지 포장세트)
  → **prd_cd 범위·개수만** live-snapshot `t_prd_products`로 1회 재측정하면 그대로 INHERIT 가능(의미는 안 바뀜).
  `[DGP-ST-001]` 카테고리 고아(041/042→CAT_000295·043/044/045/046→CAT_000296) = **7월 재연결 여부 라이브 확인 필요**(→ §4-D).
- **STALE 함정:** 위 T-6(결함표 시점).
- **GAP:** 상품 수 집계 기준(191/243/280 미통일 — source-registry §9 GAP-6). 디지털 36은 확정이나 전체 분모는 온톨로지 설계 시 정의 필요.

### 3.2 차원 — 사이즈(size)

- **정답 소스:** `_workspace/huni-dbmap/17_correctness/digital-print/correction-manifest.md` **C-01**(엽서 016=7행)·**C-12**(라벨택 046=3행) — 독립 SELECT로 엑셀 L1 nonblank와 라이브 일치(CORRECT). {tier C13 · FRESH}
- **보조:** `06_extract/digital-print-l1.csv`(사이즈 원본 셀) · live `t_prd_product_sizes.csv`.
- **핵심 사실:** 디지털 사이즈 = **이산(離散) 사이즈 행**(면적매트릭스 아님). 016=7행(73x98~148x210)·046=3행(40x80·50x50·25x110).
- **위키 REVERIFY 대조:** `[DGP-DM-001]` → C-01/C-12 그대로 유효(반증 완료). "엽서 13종"(T-2)은 DROP.
- **STALE 함정:** T-2("엽서 13종").
- **GAP:** **판수 불일치 — 마스터 디지털 판수 15 vs 판걸이수 시트 18(73×98)**(source-registry §9 GAP-1·KB_01 8장 #1). **견적 분모 직결**·실무진(신우진) 확인 대기. 사이즈 자체가 아니라 그 사이즈의 판걸이수(UP수) 권위 충돌.

### 3.3 차원 — 도수(색상 수)

- **정답 소스:** `_workspace/huni-dbmap/17_correctness/digital-print/correction-manifest.md` C-02(엽서 016 공정) + 축 페이지 `huni/processes` PRC-003. {tier C13 · FRESH}
- **핵심 사실(★도메인 [HARD]):** **도수 = `print_opt_cd`(인쇄옵션)이지 색상코드(clr_cd)가 아니다**(§14 진단·메모리 `huni-price-engine-diag-harness`).
  **별색(spot color)은 도수가 아니라 "공정"으로 들어온다**(clr_cd=NULL). 칼라/흑백 도수는 인쇄옵션 코드값(예 POPT_001/002=칼라·008/009=흑백 — 승계맵 §4 digital-print 3절).
- **위키 REVERIFY 대조:** `[DGP-BM-002]`(별색=공정)·`[DGP-PR-001]`(별색 합산) → 별색=공정은 INHERIT. 단 **통합별색 component**(COMP_PRINT_SPOT_WHITE_S1=5별색×단면양면 통합·개별 CLEAR/GOLD use=N — 메모리 `whiteprint-material-4color-unified-spot-component-260630`) 신사실 병합 필요.
- **STALE 함정:** T-4(clr_cd 8차원 구설계로 도수 인코딩).
- **GAP:** 없음(도수 프레임 확정).

### 3.4 차원 — 수량규칙(bundle/qty)

- **정답 소스(★7월 갱신):** `_workspace/_foundation/batch/qty_rule_audit_260702.py` 산출 + 메모리 `qty-system-audit-260702`(수량 UI 권위=상품/사이즈 수량규칙, 가격구간과 역할 분리). {tier C · FRESH}
- **보조:** `_workspace/huni-dbmap/17_correctness/digital-print/correction-manifest.md` C-15(bdl_unit_typ_cd=QTY_UNIT.02 "매"·값정답) · live `t_prd_product_bundle_qtys.csv`·`t_prd_product_sizes`(수량규칙 행).
- **핵심 사실(승계):** 016 프리미엄엽서 **수량 max 2행 교정 COMMIT**(07-02)·사이즈별 수량규칙 49행 충전(판형별 min 상이). 제안 min=max(권위, 가격표구간).
- **위키 REVERIFY 대조:** `[DGP-DM-004]`(묶음수 QTY_UNIT.02 "값정답·라이브 미적재") → **미적재 서술은 07-02 수량규칙 충전 COMMIT으로 갱신 필요**(live `t_prd_product_bundle_qtys`/사이즈 수량규칙 행수 재측정).
- **STALE 함정:** "bundle_qtys 0행=미적재"를 현재값으로 단정(07-02 이후 낡음).
- **GAP:** 미니 2상품(예 028 미니접지카드류) 수량축 컨펌 대기(pilot-candidates §2.1·배선 HANDOFF §3).

### 3.5 자재(materials)

- **정답 소스:** `_workspace/huni-dbmap/17_correctness/digital-print/correction-manifest.md` C-03(엽서 016 자재 21행=USAGE.07 공통·정당) + `15_domain-spec/digital-print/column-dictionary.md`·`product-bom.md`. {tier C11/C13 · FRESH}
- **보조:** live `t_prd_product_materials.csv` · `t_mat_materials.csv` · 260702 자재 diff는 `26_change-tracking-260702/master-diff-…csv`.
- **핵심 사실:** 낱장 단일 본문 자재 → 자재 모델 = **parent + usage_cd 단일 슬롯**(빈 용도→USAGE.07 default·정당). 종이 종류는 base/paper 참조.
- **위키 REVERIFY 대조:** `[DGP-BM-001]`(usage_cd 낱장) INHERIT · `[DGP-ST-004]` C-18(배경지 043 자재 스노우250 단일 vs 몽블랑240 누락 재확인) = REVERIFY(live 재측정).
- **STALE 함정:** T-5(v03 시트 자재 누락). ★[HARD 사용자지적] **실무진이 IMPORT 시트로 등록한 자재는 "배선 안 됐다"고 삭제 금지**(배선/단가 채울 갭 — 메모리 `formula-components-wiring-subtrack-260701`). 위키에 없는 신규 규칙.
- **GAP:** C-18 배경지 자재 목록 확정(실무진 확인).

### 3.6 공정(processes)

- **정답 소스:** `_workspace/huni-dbmap/17_correctness/digital-print/correction-manifest.md` C-02(엽서 공정 라우트) + 축 `huni/processes`. {tier C13 · FRESH}
- **★7월 대발견(최우선 신규 사실):** **base 인쇄공정 `PROC_000004`(디지털인쇄) 미바인딩 = 인쇄비 영구 0** → **18건 COMMIT**.
  정리 문서 = `_workspace/huni-price-table-integrity/_batch/digital-print-baseproc-260701.md`(+load/undo/backup SQL) · `HANDOFF.md` 라인 71~72(§4-A 상세). 위키에 **전혀 없음** — 새 KB 공정축 최상위 사실로 신규 등재.
- **핵심 사실:** 공정 라우트 = 디지털출력→별색→코팅→재단→커팅→후가공→포장. 016=모서리·오시·미싱·가변 6행(별색/코팅/커팅 없음=CORRECT). 별색·박·코팅·UV 전부 공정.
  **proc 이원화 systemic**(미싱제본 030↔086·오시 029↔090·캘린더제본 099 — 메모리 `contribution-scan-silent-zero-260701`).
- **위키 REVERIFY 대조:**
  - `[DGP-BM-002]`(공정 라우트) → base 공정 18건 반영해 "인쇄비 0" 해소로 갱신.
  - `[DGP-BM-003]` 배경지/라벨택 전용 커팅·접지 MISSING(PROC_000053 완칼·PROC_000056 접지) → live `t_prd_product_processes` 재측정으로 잔존 여부 확인(미출시 상품 다수).
  - `[DGP-BM-004]`·`[DGP-ST-004]` 박 부모 PROC_000033 vs 박색 8자식 AMBIGUOUS(C-06) → 미결 유지 여부 확인.
- **STALE 함정:** T-3(dep_proc_cd oracle). "인쇄비 0=결함 미해소"를 현재값으로 인용(07-01 COMMIT으로 해소).
- **GAP:** 박 부모/박색 8자식 옵션풀 여부(C-06·Q-DP-C) — 미결. 배경지 전용 커팅 미출시 상품 적재 우선순위.

### 3.7 인쇄옵션(print_options) — 도수·인쇄 방식

- **정답 소스:** live `t_prd_product_print_options.csv` · `t_prt_print_options`(도수 코드값) + pricing.py(인쇄비 계산). {tier A · FRESH}
- **핵심 사실:** 도수는 인쇄옵션 코드(§3.3). 020 화이트인쇄류는 **인쇄옵션 0건→SPOT 발현 교정**(07-02·배선 6~7세션 — 디지털 인접). 인쇄옵션 FK=`t_prt_print_options`(메모리 `catalog-conformance-foldcard-overcharge-260623`).
- **위키 REVERIFY 대조:** `[DGP-BM-002]`/`[DGP-PR-001]`의 인쇄비 항목 → base 공정(PROC_000004)+인쇄옵션 배선 상태 재측정.
- **STALE 함정:** T-4(도수를 clr_cd로).
- **GAP:** 없음(디지털 인쇄옵션은 배선 결함 0 — 배선 HANDOFF round22).

### 3.8 판형(plate size) — 출력용지규격·판걸이수

- **정답 소스(★7월 정본화):** `_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md`(12규칙 SOT·판형/판걸이수) + `_workspace/huni-price-table-integrity/_batch/DEV-REQUEST-fn-calc-pansu-260701.md` + `HANDOFF.md`(§4-C). {tier B/C · FRESH}
- **보조:** `06_extract/pangeori-l1.csv`(판걸이수 시트 권위) · live `t_prd_product_plate_sizes.csv`·`t_siz_pansu.csv`(신설).
- **핵심 사실(★도메인 [HARD]):**
  - 판형 = **출력용지규격**(작업사이즈 아님). 디지털 전 상품 = OUTPUT_PAPER_TYPE.01 국전계열(316x467).
  - 판형은 **고객이 안 고른다** → `fn_best_plate(prd,item)`가 판수>0 연결 자동선택.
  - 판걸이수(UP수) = DB 함수 `fn_calc_pansu`(`t_siz_pansu` lookup 우선 → 기하 폴백). **종이류에만 판형 유효**.
- **위키 REVERIFY 대조(★DROP 확정):** `[DGP-DM-003]`(출력판형 값정답·경로불명) → 판형 SOT로 확정 가능. **`[DGP-PR-001]`의 "판수=앱 계산·DB 미저장"(PE-010)은 DROP**(승계맵 D-1) — 대체=위 SOT + t_siz_pansu.
- **STALE 함정:** T-7(판수=앱 계산). load_master.py:340 무조건 .기타 적재 서술.
- **GAP:** **판수 불일치 15 vs 18**(§3.2 GAP 재게시·견적 분모 직결·실무진 대기). 투명엽서019 자재종속 판걸이수(C트랙 — fn_calc_pansu에 prd_cd 인자·개발팀, `DEV-REQUEST` §참조).

### 3.9 옵션그룹/제약(CPQ·constraints)

- **정답 소스:** `_workspace/huni-constraint-rules/`(CN-1~CN-6 분류·폼빌더 정형 shape 계약·§31) + live `t_prd_product_constraints.csv`. {tier C · FRESH}
- **보조:** `10_configurator/postcard-option-layer.md`(엽서 옵션 레이어 설계) · live `t_prd_product_option_groups/options/option_items.csv`.
- **핵심 사실(★[HARD]):** 제약은 **폼빌더(form builder)에서 읽고 조정 가능한 정형 shape로만**(raw JSONLogic escape hatch 금지·CLAUDE.md §31). 옵션=자재+공정 BUNDLE(메모리 `dbmap-option-material-process-bundle`). 옵션참조(ref_dim_cd)는 같은 부모 prd_cd에 실재 필수(`fn_chk_opt_item_ref` 트리거).
- **위키 REVERIFY 대조:** `[DGP-CPQ-001]`(엽서 옵션 미적재)·`[DGP-CPQ-003]`(봉투세트 적재모델 미결 Q-ID-A) → live `t_prd_product_option_items` 행수 재측정(위키 "18행 권위"는 DROP·승계맵 D-2). 047 소량전단지 코팅×종이두께 제약 COMMIT(07-02·§31 wave-3)이 디지털 소속.
- **STALE 함정:** T-1(constraint_json)·T-3(dep_proc_cd). "option_items 라이브 18행=위키 권위" 고정수치.
- **GAP:** 봉투/케이스 세트 적재모델(sets vs addons vs CPQ 옵션·Q-ID-A·GAP-DP-1) — 미결. 배경지 세트 CPQ 표현.

### 3.10 가격공식(price formula)

- **정답 소스:** `raw/webadmin/webadmin/catalog/pricing.py`(evaluate_price=단일 권위) + `02_mapping/digital-print-engine/`(원자합산형 PRF_DGP_A~F 설계). {tier A/C2 · 공식사슬 FRESH}
- **보조:** live `t_prc_price_formulas.csv`·`t_prc_formula_components.csv` · `_foundation/price-formula-master.{md,csv}`.
- **핵심 사실:** 디지털 = **원자합산형**(인쇄비 + 용지비 COMP_PAPER + 공정비). 공식 6종 PRF_DGP_A~F. 구간할인(t_dsc_*)은 **디지털 비대상**(아크릴/굿즈파우치/문구만). **판걸이수는 DB 함수로 계산**(앱 아님·§3.8).
- **★가격 경계(방법론 D-18):** 온톨로지는 **use_dims 차원 선언까지만** — 계산 로직은 evaluate_price 권위(KB 밖).
- **위키 REVERIFY 대조:** `[DGP-PR-001]`(원자합산형·판수=앱)에서 "판수=앱" 부분만 DROP·나머지 공식사슬 INHERIT. `[DGP-PR-003]`(구간할인 비대상) INHERIT.
- **STALE 함정:** T-4(price-engine-ddl). T-7(판수=앱).
- **GAP:** 없음(공식 골격 확정).

### 3.11 가격구성요소(price components) + 단가행 차원(component prices)

- **정답 소스(★7월 교정 집중):** `_workspace/huni-price-table-integrity/_batch/`(§4-A·B) + `_workspace/_foundation/batch/wiring/HANDOFF.md`(배선 결함 0·round22) + live `t_prc_price_components.csv`·`t_prc_component_prices.csv`. {tier C · FRESH}
- **핵심 사실:**
  - **base 공정 PROC_000004 인쇄비 0 → 18건 COMMIT**(§4-A).
  - **완칼 die-cut 단가형×판수 이중적용 과대청구 → COMP_CUT_FULL_DIECUT `.01→.03` 고정 COMMIT**(023 8.04M→120K·046 1.35M→50K·§4-B).
  - **모서리비 COMP_PP_CORNER_RIGHT 1건 고정 ×수량 100~1000배 과대청구 → .01→.03 교정**(260702·메모리 `bandtotal-x-qty-overcharge-260628`).
  - 가변 component(027/028/029) **정상 확인**(ambiguous 오진단 정정 — 메모리 `digital-print-base-proc-missing-260701`).
  - **단가행 존재 ≠ 배선 완료**([HARD] 교훈) — 명함 고아 component(032 코팅 저청구·031 견적0) 배선 COMMIT(메모리 `namecard-orphan-component-wiring-260630`)·프리미엄엽서 첫 완성(메모리 `premium-postcard-completion-method-260628`)·065 단가행 54→1 정리.
- **★단가행 접기(방법론 D-22):** 단가행(전 카탈로그 7,293행)은 노드로 펼치지 않고 **가격구성요소 노드의 속성/집계로 접는 것이 기본값**. 사슬 추적 부족이 실측되면 파일럿에서 재검토.
- **위키 REVERIFY 대조:** `[DGP-PR-001]`(COMP_PAPER 합산)·`[DGP-PR-002]`(가격차단 박/3절/투명/048/019 plate 교정 대기) → **인쇄비 0·완칼 과대청구는 해소됨**을 §4로 반영. 투명019·아크릴 잔여는 §4-E.
- **STALE 함정:** T-6(결함표 시점). "인쇄비 0"·"완칼 과대청구"를 현재값으로 인용.
- **GAP:** 투명엽서019 자재종속(C트랙)·완칼 023/046 예전사이트 골든 절대값 미검증(pcode 미상·§4-B).

### 3.12 추가상품/템플릿(addons/templates)

- **정답 소스:** `_workspace/huni-dbmap/17_correctness/digital-print/correction-manifest.md` C-04(엽서 016 봉투 addon=라이브 5행·교정 적용 완료) + live `t_prd_product_addons.csv`. {tier C13 · FRESH}
- **핵심 사실:** 016 봉투 addon = TMPL-000005/006/009/038/039 **5행 적재**(라이브 `t_prd_product_addons` 현재값·base_prd PRD_000001/002/283/004). "TMPL-000005 1행만(MIS-LOADED)" round-13 지적은 **교정 완료**(search-before-mint 재사용). ★이전 서술의 010/011은 교정 전 값(낡음) — 라이브 실측은 038/039(카드봉투 화이트/블랙)다. always-add 가드(use_dims에 opt_cd 미포함→silent 가산 — 메모리 `catalog-conformance-rc2-addon-260623`).
- **위키 REVERIFY 대조:** `[DGP-CPQ-002]`(봉투 addon 5행) INHERIT(라이브 5행 확증). `[DGP-CPQ-003]`(봉투세트 모델 미결) REVERIFY.
- **STALE 함정:** "봉투 addon 1행"(교정 전 값)·"tmpl_cd 010/011"(교정 전 값 — 현재 라이브=038/039).
- **GAP:** 봉투세트 적재모델 미결(§3.9 GAP 재게시). separator 하이픈 vs `_` 통일(C-17·GAP-DP-4).

---

## 4. ★최근 라이브 교정 이력 — 어느 문서에 정리돼 있나 (§26/§27)

> 위키(06-12) 이후 디지털인쇄에 실행된 라이브 COMMIT을 **원장 문서 경로**로 못박는다.
> 지식 구축가는 "위키에 결함이라 적힌 것"을 반드시 아래로 재조준할 것(그러지 않으면 T-6 오염).

### 4-A. base 공정 PROC_000004 미바인딩 → 인쇄비 0 → 18건 COMMIT (§26)
- **정리 문서:** `_workspace/huni-price-table-integrity/_batch/digital-print-baseproc-260701.md`
  (+ `digital-print-baseproc-260701-load.sql`·`-undo.sql`·`-backup.txt` / 019·023분 = `digital-print-baseproc-019-023-260701-load.sql`).
- **요약:** 16상품(017/018/021/022/026/027/028/029/041/042/043/044/045/046/047/284)에 PROC_000004 mand 공정 추가(016 미러) + 019(흰토너008+CMYK004 공존)·023(완칼123+CMYK004) = 총 18건. 인쇄비 27,000~71,200원/800매 정상화.
- **상위 진입점:** `_workspace/huni-price-table-integrity/HANDOFF.md` 라인 71~72 + 메모리 `digital-print-base-proc-missing-260701`.

### 4-B. 완칼 die-cut 단가형×판수 이중적용 과대청구 교정 (§26)
- **정리 문서:** `_workspace/huni-price-table-integrity/_batch/diecut-flat-fix-260701-load.sql`
  (+ `-dryrun.sql`·`-undo.sql` / backup=`diecut-019-023-260701-backup.txt`).
- **요약:** COMP_CUT_FULL_DIECUT prc_typ **.01→.03**(고정가). 023 8,040,000→120,000·046 1,350,000→50,000.
  구조 확정·**절대값 골든은 pcode 미상으로 미검증(대기)** — HANDOFF 라인 47·73.

### 4-C. 판걸이수 fn_calc_pansu 저청구 → t_siz_pansu 신설 (§26)
- **정리 문서:** `_workspace/huni-price-table-integrity/_batch/DEV-REQUEST-fn-calc-pansu-260701.md`
  (+ `pansu-fix-260701-schema.sql`(t_siz_pansu DDL)·`-data.sql`·`-undo.sql`·`-backup.txt`) + `_workspace/_foundation/remediation/CTRACK-fn-calc-pansu-authority-pansu.md`.
- **요약:** t_siz_pansu 신설(2인자 시그니처 유지·pricing.py 무수정·lookup 우선→기하 폴백·11행) + 판걸이수 11건 forward 교정 COMMIT(fn 11/11 통과). 커밋 `fef11a7`. 상위=HANDOFF 라인 4·19.

### 4-D. 배선 수렴(§27) — 디지털 인접 교정
- **정리 문서:** `_workspace/_foundation/batch/wiring/HANDOFF.md`(round22 — **데이터로 닫을 수 있는 배선 결함 0 달성**) + `wiring/CONFIRM-QUEUE-260701.md`.
- **요약:** 020 화이트인쇄 인쇄옵션 0건→SPOT 발현·모서리비 1000배 버그·고아 component 은퇴 등. **디지털인쇄 몫 잔여 결함 0**(잔여 6건은 전부 아크릴 TBD). 측도 스크립트=`_foundation/batch/wiring_scan.py`·`contribution_sim_scan.py`(재측정 시 재실행·새 코드 금지).
- **카테고리 고아 재연결:** 격상 183건 junction COMMIT(round-24·§7 — `huni-dbmap` CHANGELOG). `[DGP-ST-001]` 카테고리 오적재(041/042/043/044/045/046)의 해소 여부는 여기 + live `t_prd_product_categories`로 확인.

### 4-E. 잔여(디지털 관련·미마무리)
- **투명엽서019 자재종속 판걸이수 = C트랙**(fn_calc_pansu에 prd_cd 인자·개발팀 — `DEV-REQUEST-fn-calc-pansu-260701.md`, t_siz_pansu에 prd_cd 컬럼 예약).
- **완칼 023/046 골든 절대값 미검증**(pcode 매핑 후 — §4-B).
- 3절 라인 미출시 상품(112/049/030) 동형 처리 대기(HANDOFF 라인 27) — 디지털 인접.

---

## 5. 지식 구축가 인계 메모 (디지털인쇄 파일럿 착수 시)

1. **정체·차원 의미**는 `_workspace/huni-dbmap/17_correctness/digital-print/`가 정답(FRESH). 단 **결함 상태값(C-01~18)은 §4로 전부 재조준** — 위키 🔴을 그대로 옮기면 T-6 오염.
2. **수치(사이즈·수량·가격)**는 `26_change-tracking-260702/` diff 먼저 → 없으면 `06_extract` L1 = 260702값. **엑셀 원본 반복 Read 금지**(§32 캐시 원칙).
3. **라이브 현재값**은 `live-snapshot/latest/`(07-02 11:19). 권위와 다르면 **2필드 양면 표기**(방법론 D-16). 더 최신 필요 시 `snapshot.sh` 읽기전용 재촬영.
4. **판걸이수·판형·가격구성요소**는 07월 대량 교정으로 위키와 크게 달라짐 → **반드시 §4 문서 + live-snapshot로 재검증** 후 승계(REVERIFY).
5. **범위 밖 거절:** 주문·배송·회원·쿠폰 질의는 KB 범위 밖(사용자 확정). 디지털인쇄 노드에도 그 축은 만들지 않는다.
6. **인용 전 §2 STALE 함정 + source-registry §8 통과 필수.**

### 미확정/사용자·실무진 확인 필요 (디지털인쇄)
- 판수 불일치 15 vs 18(73×98) — 실무진(신우진) 확인. 견적 분모 직결.
- 봉투/케이스 세트 적재모델(sets vs addons vs CPQ·Q-ID-A) — 인간 승인.
- 박 부모 PROC_000033 vs 박색 8자식 옵션풀(C-06·Q-DP-C).
- 투명019 자재종속 판걸이수·완칼 023/046 골든(C트랙·pcode) — 개발팀.
- 파일럿 범위: 36상품 전체 vs 대표 6~8상품(명함·엽서·접지카드·라벨택) 축소 — 사용자 판단(pilot-candidates §4).
