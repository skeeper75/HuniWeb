# 파일럿 큐레이션 팩 — 실사(silsa)

> **작성:** okb-source-curator · 2026-07-03 (첫 작성 — 이전 팩 없음)
> **대상:** 실사 상품군 = 상품마스터 260702 **실사 시트**(카테고리 004 포스터 + 005 사인 대형 실사 출력물).
>   **라이브 등록 28상품**(`PRD_000118`~`PRD_000145`·전량 `del_yn=N`·`use_yn=Y`·`PRD_TYPE.01` 완제품). L1 29 = +투명포스터★(라이브 부재·정당 비활성).
> **목적:** 지식 구축가(okb-knowledge-builder)가 이 상품군을 온톨로지에 넣을 때, **축(axis)마다
>   어느 파일의 어느 절이 정답 소스이고, 무엇이 함정(STALE)이며, 원천이 없어 못 닫는 GAP이 무엇인지**를 못박는다.
> **선행 입력(정독 완료):** 같은 폴더의 `source-registry.md`(등급·§8 STALE 금지목록·260702 접근규칙)·
>   `pack-digital-print.md`·`pack-sticker.md`(형식) · `_workspace/print-kb/wiki/recipes/silsa.md`(REVERIFY 대조) ·
>   `_workspace/huni-dbmap/17_correctness/silsa/`(product-identity·correction-manifest 등) ·
>   `_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md`(면적 13/고정 16) ·
>   `_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md`(실사=포스터/사인 매트릭스·비종이류 판형없음) · `live-snapshot/latest`(=snap_20260702_1119 실측).
> **선행 팩 계승:** `_workspace/print-kb/wiki/_curation/pack-silsa.md`(있으면 역사 기록으로 둠)를 260702 권위 +
>   6월 중순~7월 초 라이브 교정 이력으로 **갱신·확장**한 것.

---

## 0. 이 팩을 읽는 법 (쉬운 말)

- **정답 소스** = "이 축의 사실은 여기서 가져와라"의 1순위 파일·절·캐시.
- **보조 소스** = 정답을 교차 확인하거나 값을 채우는 2순위.
- **STALE 함정** = "그럴듯하지만 인용하면 틀리는" 오래된 원천. **왜** 틀린지와 **대체 소스**를 함께 적었다.
- **GAP(원천 부재)** = 어느 문서에도 정답이 없어서 지금은 못 닫는 것. 실무진 답변·인간 승인 대기.
- 표기: `tier`(A 절대권위 / B 정본문서 / C 하네스산출·최신우선 / D 역공학·경쟁사 보조),
  `freshness`(FRESH / PARTIAL-STALE(어느 축이 낡음) / STALE=인용금지).
- **수치 손전사 금지:** 아래 표의 모든 숫자·상태값은 결정론 스크립트 전사(transcribed-by)다.
  라이브 = `live-snapshot/latest` awk 전사 · 면적셀 = `02_mapping/silsa-poster-area-matrix/mapping.md` §1.2 전사.
- **KB 답변 범위(사용자 확정·relitigate 금지):** 상품·구성요소·옵션·가격 차원·제약까지만.
  **주문·배송·회원·쿠폰은 범위 밖** — 이 팩도 그 축은 다루지 않는다(거절형 응답 경계).

**★실사 파일럿의 4대 특성(다른 상품군과 다른 점):**
1. **소재가 상품을 가른다.** 실사 = 카테고리 004+005 **일반 인쇄물(대형 실사 출력물)** — 13 소재군(종이/방수/투명/패브릭/특수소재/보드/액자/행잉족자/배너/현수막/시트커팅/아크릴스티커/스탠딩)이 상품 정체를 결정. 인쇄방식은 **실사 대형 잉크젯 `PROC_000006` 단일**(아크릴스티커 142/143만 UV `PROC_000002` 예외).
2. **가격 = 2 모델 공존.** **면적매트릭스형 13상품**(포스터사인 [가로×세로] 셀단가·off-grid=한 단계 큰 규격 ceiling) + **고정가형 15상품**([수량×규격] 블록·수량축 보유). 단일 공식 아님 — 상품별 분기(§3.10·§3.11). ★[HARD·HARNESS-DOMAIN-RULES] 실사 시트 자체 inline price(R/S/V 컬럼)는 가격 권위 아님 — 권위는 인쇄상품 가격표 "포스터사인" 시트.
3. **★비종이류라 판형(plate_size)이 없다.** 실사는 **대형 롤 출력**이라 절수 기반 전지(원지) 규격이 무의미(`output_paper_typ_cd=.기타`). **종이류 상품의 판형(fn_best_plate·fn_calc_pansu 판걸이수)과 혼동 금지**(§3.8). 스티커/디지털인쇄 판형 로직을 실사에 이식하면 오모델.
4. **부속붙는 8상품.** 133/134/135/136/137(부속 addon/set) + 131/132(액자 귀속 미결) + 138/139(현수막 CPQ 옵션) — "단품+부속" 정체. 부속 PRD·자재 전수 실재(search-before-mint 충족·재연결만) but **라이브 addon=0·set=0 잔존**(§3.12).

---

## 1. 실사 정답 소스 요약 (한 눈에)

| 계열 | 경로 | tier | freshness | 역할 |
|------|------|------|-----------|------|
| **정체·정합 진단(round-13)** | `_workspace/huni-dbmap/17_correctness/silsa/`(product-identity.md §0~2·correction-manifest.md C-01~14·loadlogic-notes.md·live-diff.md) | C13 | **PARTIAL-STALE** — 정체/의미 FRESH, 결함 상태값(카테고리 고아·레더 .08·부속 0행)은 6~7월 라이브 교정으로 낡음(§1.1·§4) | 28상품 정체·소재 13군·면적/고정 분기·오적재 진단의 골격 |
| **면적매트릭스 매핑(전수 셀)** | `_workspace/huni-dbmap/02_mapping/silsa-poster-area-matrix/mapping.md`(§1.1 13면적/16고정·§1.2 B01~B27 prd_cd↔comp_cd·687셀) + `06_extract/price-poster-sign-l1.csv` | C/A | FRESH(면적모델) | ★면적매트릭스 13상품 정확 지목·셀단가 1순위 |
| **고정가형 매핑** | `_workspace/huni-dbmap/02_mapping/silsa-price-engine/price-mapping-spec.md`·`dsc-code-proposals.md` | C | PARTIAL-STALE(고정가 상세) | 고정가 16상품(수량×규격) 모델 |
| **차원 L1 무손실 캐시(구버전)** | `_workspace/huni-dbmap/06_extract/silsa-l1.csv`(115행) + `silsa-l1-report.md` | A | PARTIAL-STALE(260702 diff 해당 셀만) | 사이즈·소재·공정·수량 원본 셀값. 실사 시트는 260702 diff 무영향(§4) |
| **라이브 현재 상태** | `_workspace/_foundation/live-snapshot/latest/`(=snap_20260702_1119, t_* CSV+_manifest) | A(현재값) | FRESH(07-02 11:19) | "지금 DB에 뭐가 들었나". ★"현재값"이지 "정답" 아님 — 권위와 다르면 양면 표기 |
| **가격엔진 코드(단일 권위)** | `raw/webadmin/webadmin/catalog/pricing.py`(evaluate_price) | A | FRESH | 가격 계산 방식의 유일 알고리즘 권위 |
| **도메인 규칙 12항 정본(SOT)** | `_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md` | B | FRESH | ★실사=포스터/사인 면적매트릭스·종이류만 판형·차원형vs수량단가 |
| **CPQ 옵션(일반현수막 파일럿)** | `_workspace/huni-dbmap/10_configurator/silsa-option-layer-v2.md`·`silsa-live-reconciliation.md` | C/A | FRESH | 끈/각목 자재+공정 BUNDLE·라이브 표준 var 7종 |
| **제약규칙(§31)** | `_workspace/huni-constraint-rules/`(CN-1~CN-6·폼빌더 정형 shape) + live `t_prd_product_constraints.csv` | C | FRESH | ★실사 7상품 constraints 신규 발현(§1.1·§3.9) |
| 위키 레시피 | `_workspace/print-kb/wiki/recipes/silsa.md`(SL-ID/DIM/BOM/PRC/CPQ/DEF 블록) | C | PARTIAL-STALE | REVERIFY 대조용 — 7절 결함표(SL-DEF-001~007)를 "현재 결함"으로 인용 금지(§2 T-6·§4) |

### 1.1 ★라이브 교정 신사실 (round-13 → 현재) — 위키 🔴이 이미 교정됨

> 이 절이 실사 팩의 최대 임무다. round-13 위키가 🔴 교정대기로 표기한 결함 다수가 **6월 중순~7월 초 라이브 COMMIT으로 이미 해소**됐다. {전부 transcribed-by `awk live-snapshot/latest`}

- **[교정됨] 카테고리 고아 SL-DEF-001 → 해소.** `CAT_000298 실사`는 **`del_yn=Y` 논리삭제됨(2026-06-18)**. 실사 28상품은 정상 카테고리 노드로 재연결됨: `CAT_000004`(포스터 12)·`CAT_000005`(사인 3)·`CAT_000072`(2)·`CAT_000076`(3)·`CAT_000080`(7)·`CAT_000092`(4)·`CAT_000097`(2)·`CAT_000314`(6)·`CAT_000315`(4). {transcribed-by `awk t_prd_product_categories.csv`} → round-13 "전부 CAT_000298 고아" 서술은 **STALE**. 단 일부가 root 직결(004/005)·신규 노드(314/315)라 leaf 귀속 정밀도는 확인 대상(현재값 라벨).
- **[교정됨·라벨 STALE] 레더 자재유형 SL-DEF-002 → .08→.05 교정.** `MAT_000186 레더` = 현재 **`MAT_TYPE.05`**(upd 2026-06-27·구 `.08 실사소재`에서 이동). 패브릭류도 혼재 교정: `MAT_000184 린넨`·`185 캔버스`·`187/188 타이벡` = `.05` / `181 그래픽천`·`182 현수막천`·`183 메쉬` = 아직 `.08` / `189 시트커팅지` = `.19` / `190 카드거울` = `.12`. {transcribed-by `awk t_mat_materials.csv`}
  ★**MAT_TYPE 코드 도메인이 개편됨**(전 코드 upd 2026-06-19): 현재 라이브 = **`.05 특수소재`·`.06 도장부자재`·`.08 실사소재`**. 즉 **round-13 correction-manifest의 목표 라벨 ".05 원단"·".06 가죽"은 STALE**(코드 의미가 바뀜). {transcribed-by `awk t_cod_base_codes.csv`} → 레더가 지금 `.05 특수소재`인 게 현재값이며, "레더=.06 가죽" 목표는 코드 개편으로 무효.
- **[잔존] MAT_000186 레더 crosscut 범위 = 라이브 4상품**(`PRD_000100`·`126` 레더아트프린트·`296`·`298`). {transcribed-by `grep ,MAT_000186, t_prd_product_materials.csv`} → 위키/과거 "6상품 횡단"과 델타(현재 4행). 레더 1행이 실사(126) + 책자/기타(100/296/298) 횡단 = MAT_TYPE 오염축([[../huni/materials#MAT-005/006]]).
- **[신규 발현] constraints SL-CPQ-003 → 7상품 1행씩.** 실사 constraints = 현재 **`PRD_000118`·`120`·`121`·`122`·`124`·`125`·`139` 각 1행**(총 7). {transcribed-by `awk t_prd_product_constraints.csv`} → 위키 "constraints 0행" 서술은 **낡음**(단 138 일반현수막은 여전히 0행·139 메쉬현수막이 1행). 제약 shape는 live `t_prd_product_constraints.logic` 재측정으로 확인.
- **[잔존·미교정] 부속 addon/set SL-DEF-005 → 여전히 0행.** 실사 118~145 `t_prd_product_addons`=0·`t_prd_product_sets`(부모)=0. {transcribed-by awk} → 부속 미적재는 **현재도 잔존**(위키 🔴 유효). 부속 PRD_000008/012/013/014 재연결 대기.
- **[불변] CPQ 옵션 레이어 SL-DEF-006 → 일반현수막138 og=3·oi=18만.** {transcribed-by `awk $1==PRD_000138 t_prd_product_option_items.csv`} → 나머지 27 실사 여전히 옵션 0행(위키 일치·FRESH).

---

## 2. STALE 함정 목록 (실사 국한 — 인용 시 lint FAIL)

> 전역 금지목록은 `source-registry.md` §8. 아래는 **실사 작업에서 특히 밟기 쉬운** 함정만.

| # | 함정 원천 | 왜 틀리는가 | 대체 소스 |
|---|-----------|-------------|-----------|
| T-1 | round-13 SL-DEF-001 **"실사 28상품 전부 CAT_000298 고아"** | CAT_000298=`del_yn=Y` 논리삭제·28상품 정상노드 재연결됨(§1.1) | live `t_prd_product_categories.csv`·`t_cat_categories.csv` |
| T-2 | round-13 correction **"레더=.06 가죽·패브릭=.05 원단"** 목표 라벨 | MAT_TYPE 코드 개편(현재 `.05 특수소재`·`.06 도장부자재`·`.08 실사소재`)으로 라벨 무효·레더는 이미 `.05` 교정됨(§1.1) | live `t_cod_base_codes.csv`(MAT_TYPE) + `t_mat_materials.csv` |
| T-3 | 위키 SL-CPQ-003/SL-DEF-006 **"실사 constraints 전부 0행"** | 7상품(118/120/121/122/124/125/139) 1행씩 신규 발현(§1.1) | live `t_prd_product_constraints.csv` + §31 |
| T-4 | `price-engine-ddl.md`(면적=FRM_TYPE·좌표 회귀) / `prcx01-pricing-model.md` | 좌표 회귀·8차원 구설계 — 후니 권위공식=매트릭스 룩업(§8-2/3). mapping.md가 DDL을 인용하나 **본 팩은 룩업 모델만 승계** | pricing.py 직접 + live `t_prc_*` + mapping.md §1.2 |
| T-5 | round-2 **"28 포스터를 단일 `PRF_POSTER_FIXED`+sparse 대표셀(1~2셀)로 적재"** | 매트릭스 소실(2~6%만 적재)·round-2 면적-좌표 오모델. 정정=명시 매트릭스 셀 전건+ceiling | `02_mapping/silsa-poster-area-matrix/mapping.md` §2·§1.2 |
| T-6 | 위키 `recipes/silsa.md` **7절 결함표(SL-DEF-001~007)를 "현재 결함"으로 인용** | 6~7월 COMMIT으로 카테고리 고아·레더 .08·일부 constraints가 해소/변화 — 시점이 낡음 | 각 행을 §1.1 + §4 + live-snapshot으로 "해소/잔존" 재판정 |
| T-7 | 실사에 **판형(plate_size)·판걸이수(fn_calc_pansu) 적용** | 실사=비종이류 대형 롤 → 판형 무의미(`.기타`). 종이류 상품 로직 이식 금지(§3.8·HARNESS-DOMAIN-RULES) | `HARNESS-DOMAIN-RULES-260701.md` + `loadlogic-notes.md` §1 |
| T-8 | `silsa-option-layer.md`(v1) **끈/각목=공정만 반쪽 매핑** | v2가 자재+공정 BUNDLE으로 재정합(v1 인용 금지) | `10_configurator/silsa-option-layer-v2.md` |
| T-9 | `load_master.py`의 **입력 v03 xlsx**(prdmaster_full_migration_v03) | 실사 결함 거의 전부 v03 마이그레이션 단계 진원(자재 .08 평면화·카테고리 고아·param 손실·부속 미생성) | 260702 엑셀(§1 캐시) + 06_extract silsa-l1. **load_master는 로직(전파기)만 oracle** |

---

## 3. 축별 큐레이션 (정답 → 보조 → STALE 함정 → GAP) — 12축

> 각 축의 "위키 재검증 대조 소스"는 `recipes/silsa.md`의 해당 블록 ID를 명시해 **REVERIFY(재검증 후 승계)** 대상을 구체 지목한다.

### 3.1 정체(identity) — 무엇인가

- **정답 소스:** `17_correctness/silsa/product-identity.md` §0·§1·§2(28상품 정체표·소재 13군·인쇄방식 실사 단일·prd_typ 실측). {tier C13 · 의미 FRESH}
- **보조:** `06_extract/silsa-l1.csv`(prd_nm 원본 115행) · live `t_prd_products.csv`(prd_cd 실재·prd_typ·use_yn·del_yn).
- **핵심 사실(승계):** **라이브 28상품**(`PRD_000118`~`145`) 전량 `PRD_TYPE.01`(완제품)·`use_yn=Y`·`del_yn=N`. {transcribed-by `awk t_prd_products.csv`}. 카테고리 004 포스터+005 사인 일반 인쇄물 — 굿즈/포장재 아님(정체 오분류 위험 없음·product-master 권위0이 일관 확정). **투명포스터★**(L1 29번째)는 라이브 부재·정당 비활성(방수포스터와 MES 004-0003 공유+PM "신규/검토중"). 에디터 상품 3종(`edit=Y`): `132` 레더아트액자·`133` 캔버스행잉·`134` 린넨우드봉족자.
- **위키 REVERIFY 대조:** `[SL-ID-001]`(포스터+사인·소재기반)·`[SL-ID-002]`(28상품·부속 8) → 의미 INHERIT. prd_typ=`.01` 확증.
- **STALE 함정:** T-6.
- **GAP:** 상품 수 집계 기준(191/243/280 미통일 — source-registry §9 GAP-6). 실사 28은 확정.

### 3.2 차원 — 사이즈(size)

- **정답 소스:** `17_correctness/silsa/correction-manifest.md` C-02(size CORRECT·연속범위 오판 부재) + `_gate/silsa-gate.md` K4(검증자 독립 SELECT 재현) + `02_mapping/silsa-poster-area-matrix/mapping.md` §2.1(매트릭스 셀 구조). {tier C13/C · FRESH}
- **보조:** `06_extract/silsa-l1.csv`(이산 SIZ + nonspec 범위) · live `t_prd_product_sizes.csv`·`t_siz_sizes.csv`.
- **핵심 사실(★실사 특유):** size = **이산 규격 SIZ(A3/A2/A1 등) + 비규격(nonspec_*) 연속범위 + 사용자입력**. ★**비규격 범위는 입력 UX 한계일 뿐 가격격자가 아니다** — 유효 가격 권위 = 포스터사인 면적매트릭스 셀(§3.10). off-grid = 가로·세로 각 한 단계 큰 규격 ceiling(앱 계산). round-9가 우려한 "비치수 연속범위 오판"이 라이브에 없음을 round-13이 검증자 독립 SELECT로 반증(CORRECT). 실사 nonspec_yn: 포스터/현수막류(118~128·138·139)=`Y`·보드/액자/시트커팅/아크릴/스탠딩/배너(129~137·140~145)=`N`. {transcribed-by awk}
- **위키 REVERIFY 대조:** `[SL-DIM-001]`(이산 면적매트릭스+nonspec·입력UX≠가격격자) INHERIT.
- **STALE 함정:** T-6.
- **GAP:** 없음(size CORRECT 반증 완료).

### 3.3 차원 — 도수(색상 수) + 화이트 별색(underbase)

- **정답 소스:** `15_domain-spec/silsa/product-bom.md` §3(화이트 별색) + `17_correctness/silsa/product-identity.md` §2 + `_gate/silsa-gate.md` K6(접착투명122 PROC_000008 재현). {tier C11/C13 · FRESH}
- **핵심 사실(★도메인 [HARD]):** 실사는 **도수(칼라/흑백) 컬럼 자체가 없다**(대형 잉크젯 풀컬러·정당·po=0). **화이트 underbase(`PROC_000008`, 부모 `PROC_000007 별색`)는 도수가 아니라 공정**(투명/반사 소재 위 불투명 백색 받침·`clr_cd=NULL`). 도메인 필수 = 접착투명포스터122·투명포스터★·홀로그램시트커팅141. 접착투명122 라이브 PROC_000008 1행 적재됨(CORRECT).
- **위키 REVERIFY 대조:** `[SL-BOM-004]`(화이트 underbase=공정) INHERIT.
- **STALE 함정:** T-4(도수를 clr_cd/좌표로).
- **GAP:** 홀로그램141 화이트 underbase 연결 여부 live 재측정(투명 소재만 확증됨).

### 3.4 차원 — 수량규칙(bundle/qty)

- **정답 소스:** `17_correctness/silsa/correction-manifest.md` C-11(수량 NULL=L1 원본 빈값 정합) + `_foundation/batch/qty_rule_audit_260702.py`(수량 UI 권위=상품/사이즈 수량규칙). {tier C13/C · FRESH}
- **보조:** `06_extract/silsa-l1.csv`(수량 원본 빈값) · live `t_prd_products`(min/max/qty_incr)·`t_prd_product_sizes`(수량규칙 행).
- **핵심 사실:** **면적매트릭스 13상품은 수량축 없음**(min_qty=NULL·매트릭스 셀=완제품 통가격). **고정가 15상품은 [수량×규격] 블록**이라 수량축 보유. 일부 실사 수량 L1 빈값(메쉬현수막/홀로그램/유광아크릴)=원본 미명시 정합(정정·GAP-SL-8).
- **위키 REVERIFY 대조:** `[SL-DIM-001]` 부수·C-11 정합 서술 INHERIT. 수량규칙 행수는 live 재측정.
- **STALE 함정:** "bundle_qtys 0행=미적재"를 현재값으로 단정. T-6.
- **GAP:** **[GAP-SL-8]** 메쉬현수막/홀로그램/유광아크릴 수량 L1 빈값(유지 vs 동류값 보완) — Q-SL-5·6.

### 3.5 자재(materials)

- **정답 소스:** `17_correctness/silsa/correction-manifest.md` C-03(usage=USAGE.07 낱장 단일 CORRECT)·C-04(자재유형 .08 평면화) + `15_domain-spec/silsa/product-bom.md` §0. {tier C13/C11 · 의미 FRESH·상태값 §1.1로 재조준}
- **보조:** live `t_mat_materials.csv`(mat_typ_cd 현재값) · `t_prd_product_materials.csv` · `t_cod_base_codes.csv`(MAT_TYPE 코드 도메인).
- **핵심 사실:** 실사 자재 = **소재별 본체 자재 단일**(낱장 완제품·내지/표지 없음). 자재 모델 = **parent + usage_cd**(낱장 C단일·USAGE.07 공통). 소재 정체 정확(인화지/매트지/PET/PVC/린넨/캔버스/레더/타이벡/메쉬/현수막천/시트지/아크릴).
  ★**자재유형 교정 진행(현재값 §1.1):** 레더 MAT_000186·린넨184·캔버스185·타이벡187/188 = `.05`(교정됨·06-27) / 그래픽천181·현수막천182·메쉬183 = 아직 `.08` / 시트커팅지189=`.19` / 카드거울190=`.12`. **round-13의 ".05 원단/.06 가죽" 목표 라벨은 MAT_TYPE 코드 개편으로 STALE**(현재 `.05 특수소재`·`.06 도장부자재`).
- **위키 REVERIFY 대조:** `[SL-BOM-001]`(parent+usage_cd·USAGE.07) INHERIT · `[SL-DEF-002]`(자재유형 .08 평면화) = **REVERIFY**(§1.1 교정 반영·잔존분 3소재만·목표 라벨 STALE 주의).
- **STALE 함정:** T-2(레더=.06 가죽 목표 라벨)·T-9(v03 소재 평면화). ★[HARD 사용자지적] **실무진이 IMPORT 시트로 등록한 자재는 "배선 안 됐다"고 삭제 금지**.
- **GAP:** 그래픽천/현수막천/메쉬 잔여 .08 정정 목표유형 확정(개편된 코드 도메인 기준)·보드/우드 5상품 소재 L1 빈값(원본 미명시 정당·AMBIGUOUS).

### 3.6 공정(processes) — 후가공(봉제·타공·족자·열재단·보드마운팅)

- **정답 소스:** `15_domain-spec/silsa/product-bom.md` §4·§8·§9·§10 + `17_correctness/silsa/correction-manifest.md` C-05(코팅 CORRECT)·C-06/C-07(param·보드 MISSING). {tier C11/C13 · FRESH}
- **핵심 사실(★소재가 완성형태):** 패브릭=**봉제 `PROC_000080`**(param 오버로크/말아박기/봉미싱·폭)·배너=**4구타공 `PROC_000079`**(param 구수)·족자=**족자제작 `PROC_000082`**(param 모양)·현수막=**열재단 `PROC_000084`**(round-9 CPQ mint)·보드=**보드마운팅**(마스터 부재·신설 필요)·코팅=유광 `PROC_000014`/무광 `PROC_000015`(코팅=공정 Q9 CORRECT). 순수공정(열재단/재단)은 자재 없음.
- **위키 REVERIFY 대조:** `[SL-BOM-003]`(후가공=소재별) INHERIT · `[SL-DEF-003]`(봉제/족자 param 손실)·`[SL-DEF-004]`(보드마운팅 마스터 0개) = REVERIFY(live `t_proc_processes`·`t_prd_product_processes` 재측정으로 잔존 확인).
- **STALE 함정:** T-6·T-9. dep_proc_cd oracle 소멸(source-registry §8-5).
- **GAP:** **[GAP-SL-2]** 봉제/족자 variant 적재 위치(CPQ option_items vs prcs_dtl_opt param·Q-SL-2) · **[GAP-SL-3]** 보드마운팅 공정 마스터 신설(라이브 0개·ddl-proposer·Q-SL-3).

### 3.7 인쇄옵션(print_options) — 인쇄 방식

- **정답 소스:** `15_domain-spec/silsa/product-bom.md` §0 인쇄방식 + `17_correctness/silsa/product-identity.md` §2 F-ID-4(아크릴스티커 UV 라우팅). {tier C11/C13 · FRESH}
- **핵심 사실:** 인쇄방식 = **실사 대형 잉크젯 `PROC_000006` 단일**. **예외: 유광아크릴스티커142·미러아크릴스티커143은 폴더=레이저커팅 → UV `PROC_000002` 라인**(소재 아크릴). 라이브엔 인쇄방식 공정 행 자체가 전 실사 부재(po=0·실사는 도수 컬럼 없음·정당). 실사는 도수/인쇄옵션 축이 얕음(§3.3).
- **위키 REVERIFY 대조:** `[SL-BOM-002]`(PROC_000006·아크릴 UV PROC_000002) INHERIT.
- **STALE 함정:** T-4.
- **GAP:** 아크릴스티커 UV 라우팅 공정 행 추가 여부(Q-SL-A·영향 작음).

### 3.8 판형(plate size) — ★실사는 없음(비종이류)

- **정답 소스:** `17_correctness/silsa/loadlogic-notes.md` §1·§3(load_master:340 `.기타` 무조건·실사 대형롤 전지 무의미) + `_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md`(종이류만 판형). {tier C13/B · FRESH}
- **핵심 사실(★도메인 [HARD] — 혼동 금지):** 실사 판형(`output_paper_typ_cd`) = **전부 `.기타`** — 실사는 **대형 롤 출력**이라 절수 기반 전지 규격이 무의미(낱장 임포지션 없음). **판형(fn_best_plate)·판걸이수(fn_calc_pansu·t_siz_pansu)는 종이류 전용 로직 → 실사에 적용 금지.** `output_file_typ`(JPG/AI)만 정확. 박/면적 등 앱 런타임 계산 없음(가격 룩업만).
- **위키 REVERIFY 대조:** `[SL-DIM-002]`(판형=.기타·대형롤) INHERIT.
- **STALE 함정:** **T-7(실사에 판형/판걸이수 이식)** — 스티커/디지털 팩의 판형 SOT(fn_calc_pansu)를 실사에 그대로 옮기면 오모델.
- **GAP:** 없음(실사 판형 무의미 정합).

### 3.9 옵션그룹/제약(CPQ·constraints)

- **정답 소스:** `10_configurator/silsa-option-layer-v2.md`(자재+공정 BUNDLE·§0~3)·`silsa-live-reconciliation.md`(라이브 표준 var 7종·LV-1~5) + `_workspace/huni-constraint-rules/`(CN-1~CN-6·폼빌더 정형 shape·§31) + live `t_prd_product_constraints.csv`. {tier C/A · FRESH}
- **보조:** live `t_prd_product_option_groups/options/option_items.csv`.
- **핵심 사실(★[HARD]):** 옵션축(코팅·봉제유형/타공구수/족자모양·부속) → 4엔티티 매핑. `option_items`는 polymorphic `ref_dim_cd`로 L1 차원행 참조·무결성 트리거 `fn_chk_opt_item_ref`(차원행 선적재 필수). **옵션=자재+공정 BUNDLE**(한 옵션 두 의미). 제약은 **폼빌더에서 읽고 조정 가능한 정형 shape로만**(raw JSONLogic escape hatch 금지·CLAUDE.md §31).
  - **★일반현수막138 파일럿 = og=3·oi=18행 COMMIT 실재**(라이브 최초 옵션 레이어 사례·열재단 PROC_000084 mint·끈=자재 MAT_000070+부착 PROC_000081 BUNDLE). {transcribed-by awk}
  - **★constraints 신규 발현(현재값·§1.1):** 실사 7상품(118/120/121/122/124/125/139) 각 1행. **단 138 일반현수막은 여전히 0행**(비치수 수치 범위 표현 불가 GAP 잔존). 제약 shape는 live `t_prd_product_constraints.logic` 재측정.
- **위키 REVERIFY 대조:** `[SL-CPQ-001]`(속성→4엔티티)·`[SL-CPQ-002]`(일반현수막 BUNDLE oi=18) INHERIT · `[SL-CPQ-003]`(constraints 0행 GAP) = **REVERIFY**(7상품 1행 신규 발현으로 갱신·§1.1·T-3).
- **STALE 함정:** T-3(constraints 전부 0행)·T-8(v1 반쪽 매핑)·constraint_json 컬럼(삭제·§8-5).
- **GAP:** **[GAP-SL-6]** CPQ 옵션 레이어 일괄 적재(27 실사 미적재·BATCH-6) · **[GAP-SL-7]** 비치수 수치 범위 검증처(R-SIZE-NONSPEC/R-GAKMOK — products 범위 컬럼+앱 vs 비표준 var vs 앱 런타임·Q-SL-7).

### 3.10 가격공식(price formula) — ★면적매트릭스 13 vs 고정가 15

- **정답 소스:** `raw/webadmin/webadmin/catalog/pricing.py`(evaluate_price=단일 권위) + `02_mapping/silsa-poster-area-matrix/mapping.md` §1.1·§1.2·§5(면적 13/고정 16 분류·B01~B27 prd_cd↔comp_cd) + `06_extract/price-poster-sign-l1.csv`. {tier A/C · 면적모델 FRESH}
- **핵심 사실(★실사 2 모델 공존 — 정확 지목):**
  - **면적매트릭스형 13상품** = 포스터사인 [가로(col)×세로(row)] 셀단가(코팅포함가). {transcribed-by mapping.md §1.2}:
    B01 아트프린트118·B02 아트페이퍼119·B03 방수120·B04 접착방수121·B05 접착투명122·B06 아트패브릭123·B07 린넨124·B08 캔버스125·B09 레더126·B10 타이벡127·B11 메쉬128 + **B26 일반현수막138·B27 메쉬현수막139**. clr/mat/coat/bdl/min=NULL(면적매트릭스는 도수·자재·코팅면·묶음·수량 무관·코팅포함 통가격). off-grid=한 단계 큰 치수 ceiling(앱 계산·DB는 룩업행). 총 687셀.
  - **고정가형 15상품(라이브 활성)** = [수량(행)×규격(A3/A2/A1, 열)] 블록(포스터사인 B12~B25·B28~B31)·수량축 보유:
    폼보드129·포맥스보드130·프레임리스우드액자131·레더아트액자132·캔버스행잉133·린넨우드봉족자134·족자포스터135·PET배너136·메쉬배너137·무광시트커팅140·홀로그램시트커팅141·유광아크릴스티커142·미러아크릴스티커143·미니보드스탠딩144·미니배너145. (+투명포스터★=L1 16번째 고정가·비활성).
  - ★**구간할인(t_dsc_*)**은 고정가형 수량축에 `dsc-code-proposals.md`로 제안(적재 별도).
- **★가격 경계(방법론):** 온톨로지는 **use_dims 차원 선언까지만** — 계산 로직은 evaluate_price 권위(KB 밖). 실사 시트 inline price(R/S/V)는 가격 권위 아님 [HARD].
- **위키 REVERIFY 대조:** `[SL-PRC-001]`(면적매트릭스·실사 inline 금지)·`[SL-PRC-002]`(면적 13+고정 16) INHERIT. **좌표 회귀·round-2 sparse 대표셀 인용부 DROP**(T-4·T-5).
- **STALE 함정:** T-4(price-engine-ddl 좌표 회귀·FRM_TYPE)·T-5(round-2 sparse). ★"29 실사 전부 면적매트릭스로 일괄" = round-2 오모델 재발(적대적 주의·고정가 15는 BLOCKED-OUT-OF-SCOPE).
- **GAP:** 롤 소재 가격 계산 로직(엑셀 미기재 암묵지·source-registry §9 GAP-2 — 실사 전체 영향).

### 3.11 가격구성요소(price components) + 단가행 차원(component prices)

- **정답 소스:** `02_mapping/silsa-poster-area-matrix/mapping.md` §1.2(13 comp_cd↔687셀)·§4(D-WIRE GAP) + live `t_prc_price_components.csv`·`t_prc_component_prices.csv`(COMP_POSTER_* 실측). {tier C/A · FRESH}
- **핵심 사실:**
  - 면적 13상품 = comp_cd 13개(`COMP_POSTER_ARTPRINT_PHOTO`~`COMP_POSTER_BANNER_MESH`), (siz_cd=치수조합, unit_price) long-form 687셀. **매트릭스 비대칭**((600,1000)≠(1000,600)) — 각 (가로,세로) 순서쌍이 고유 셀·고유 siz_cd.
  - **★round-2 D-WIRE GAP:** round-2가 28상품을 단일 comp(`COMP_POSTER_ARTPRINT_PHOTO`)에 바인딩·매트릭스 2~6%만 적재 → 나머지 27상품 comp 미배선(가격조회 사슬 단절). 정정=명시 매트릭스 셀 전건+ceiling(mapping.md §2).
  - 고정가 15 = 수량×규격 단가행(별도 comp).
- **★단가행 접기(방법론):** 단가행은 노드로 펼치지 않고 **가격구성요소 노드의 속성/집계로 접는 것이 기본값**. 면적매트릭스 적재 구조는 **아크릴 면적매트릭스와 동형**(`09_load/_migrate_areamatrix/`·[[recipes/acrylic#AC-PRC-002]]).
- **위키 REVERIFY 대조:** `[SL-PRC-001]`/`[SL-PRC-002]`(component_prices 면적셀) INHERIT · 좌표 회귀 인용부 DROP.
- **STALE 함정:** T-4·T-5.
- **GAP:** 108 면적치수 siz 신규등록(제안 SIZ_000511~618·매트릭스 670행 차단 해소 전제·인간 승인).

### 3.12 추가상품/템플릿(addons/templates) — ★부속붙는 8상품

- **정답 소스:** `17_correctness/silsa/correction-manifest.md` C-08(부속 MISSING·PRD 실재)·C-14(액자 귀속 AMBIGUOUS) + `15_domain-spec/silsa/product-bom.md` §7·§8·§9. {tier C13/C11 · FRESH}
- **핵심 사실:** 부속붙는 8상품(우드행거·우드봉·천정고리·거치대·끈/각목)="단품+부속" 정체. **부속 PRD `PRD_000008`(천정고리·use_yn=N)·`012`(우드거치대)·`013`(우드봉)·`014`(우드행거) + 자재 MAT_000223~229 전수 실재**(search-before-mint 충족·재연결만). **★라이브 addon=0·set=0 잔존(현재값·§1.1)** — 일반현수막138만 CPQ 옵션으로 부속 표현. 재연결 대상: 캔버스행잉133→우드행거014·린넨우드봉족자134→우드봉013·족자포스터135→천정고리008(활성화 선행)·PET배너136/메쉬배너137→우드거치대012. 액자 131/132는 공정(액자가공) vs 부속(프레임 별매) 미결(AMBIGUOUS).
- **위키 REVERIFY 대조:** `[SL-BOM-005]`(부속=addon/set)·`[SL-DEF-005]`(부속 0행)·`[SL-DEF-007]`(액자 귀속) = REVERIFY(addon/set 여전히 0행 확증·미교정 잔존).
- **STALE 함정:** T-6.
- **GAP:** **[GAP-SL-4]** 부속·액자 귀속(우드류=기존 PRD addon 연결·천정고리 활성화 선행·액자=공정 vs 부속·Q-SL-4) · **[GAP-SL-5]** 끈/각목 BUNDLE 자재 mint·각목 2규격 모델(silsa-option-layer-v2 D-1/D-2).

---

## 4. ★핵심 임무 — 위키 🔴 결함 "해소/잔존" 재조준표

> 위키(round-13) 7절 결함표(SL-DEF-001~007)를 그대로 옮기면 T-6 오염. 아래는 **각 결함의 현재 상태**를 live-snapshot 실측으로 재판정한 것(§1.1 요약의 표 버전). {전부 transcribed-by `awk live-snapshot/latest`}

| 위키 ID | round-13 결함(라이브 현재값→정답) | **현재 상태(07-02 실측)** | 판정 |
|---------|-----------------------------------|---------------------------|------|
| SL-DEF-001 | 카테고리 전부 CAT_000298 고아 | CAT_000298 `del_yn=Y`(06-18 삭제)·28상품 정상노드 재연결(004/005/072/076/080/092/097/314/315) | **해소**(REVERIFY→INHERIT 정상연결·leaf 정밀도만 확인) |
| SL-DEF-002 | 레더/패브릭 전부 .08 실사소재 | 레더186·린넨184·캔버스185·타이벡187/188=`.05`(06-27 교정)·그래픽천/현수막천/메쉬=아직 `.08`·MAT_TYPE 코드 개편(.05 특수소재/.06 도장부자재) | **부분 해소**(3소재 잔존·round-13 목표 라벨 STALE) |
| SL-DEF-003 | 봉제/족자 param 손실 | live `t_prd_product_processes` 재측정 필요(param 인스턴스 경로 스키마 확인) | **잔존 추정**(GAP-SL-2·재측정) |
| SL-DEF-004 | 보드마운팅 공정 마스터 0개 | live `t_proc_processes` 재측정 필요 | **잔존 추정**(GAP-SL-3·ddl-proposer) |
| SL-DEF-005 | 부속 addon/set 0행 | addon=0·set=0 **여전히 0행** | **잔존**(미교정·재연결 대기) |
| SL-DEF-006 | CPQ 옵션 일반현수막138만(oi=18) | og=3·oi=18 그대로·나머지 27 실사 0행 | **불변**(INHERIT·BATCH-6 대기) |
| SL-DEF-007 | 액자 귀속 미결(131/132) | AMBIGUOUS 유지 | **미결**(GAP-SL-4) |
| SL-CPQ-003 | constraints 0행 | 7상품(118/120/121/122/124/125/139) 1행씩·138은 0행 | **신규 발현**(위키 "0행" 낡음·REVERIFY) |

> **원장 경로:** 카테고리 재연결 = huni-dbmap round-24 격상 183건 junction COMMIT(`huni-dbmap` CHANGELOG). 자재유형 교정 = 06-27 자재 마스터 UPDATE(live upd_dt). 실사 실 교정 COMMIT은 round-5/10 트랙 인간 승인 대기분(부속/param/보드)은 **DB 미적재 유지**.

---

## 5. 지식 구축가 인계 메모 (실사 파일럿 착수 시)

1. **정체·소재 13군·면적/고정 분기 의미**는 `17_correctness/silsa/` + `02_mapping/silsa-poster-area-matrix/mapping.md`가 정답(FRESH). 단 **결함 상태값은 §1.1·§4로 전부 재조준** — 위키 🔴을 그대로 옮기면 T-6 오염(특히 카테고리 고아·레더 .08은 이미 해소).
2. **가격 = 면적매트릭스 13 + 고정가 15(2 모델)** — "29 전부 면적매트릭스" 일괄 금지(round-2 오모델 재발·§3.10). 면적 13 = 118~128+138+139(mapping.md §1.2 verbatim). 고정 15 = 129~137+140~145.
3. **★비종이류라 판형 없음**(§3.8·T-7) — 스티커/디지털 팩의 판형(fn_calc_pansu·t_siz_pansu) 로직을 실사에 이식 금지. 실사 판형=`.기타`(대형 롤).
4. **레더 crosscut(§1.1):** MAT_000186=현재 `.05`(교정됨)·라이브 4상품(100/126/296/298) 횡동. round-13 "6상품·.06 가죽" 목표는 STALE — MAT_TYPE 코드 개편(.06=도장부자재) 반영.
5. **수치**는 실사 시트가 260702 diff 무영향(§4·source-registry §2.2)이라 `06_extract/silsa-l1.csv`·`price-poster-sign-l1.csv` = 260702값. **엑셀 원본 반복 Read 금지**.
6. **양면 표기 대상:** 카테고리(현재 정상연결 vs round-13 고아)·레더유형(현재 .05 vs round-13 .06 목표)·constraints(현재 7행 vs 위키 0행)·부속(현재 0행=결함 잔존). 라이브 현재값과 권위/정답 둘 다 보존.
7. **범위 밖 거절:** 주문·배송·회원·쿠폰 질의는 KB 범위 밖(사용자 확정). 실사 노드에도 그 축은 만들지 않는다.
8. **인용 전 §2 STALE 함정 + source-registry §8 통과 필수.**

### 미확정/사용자·실무진 확인 필요 (실사)

- **[GAP-SL-2] 봉제/족자 variant 적재 위치(Q-SL-2)** — CPQ option_items vs prcs_dtl_opt param 인스턴스.
- **[GAP-SL-3] 보드마운팅 공정 마스터 신설(Q-SL-3)** — 라이브 0개·ddl-proposer.
- **[GAP-SL-4] 부속·액자 귀속(Q-SL-4)** — 우드류=기존 PRD addon 재연결(천정고리008 활성화 선행)·액자=공정 vs 부속.
- **[GAP-SL-5] 끈/각목 BUNDLE 자재 mint·각목 2규격 모델** — 큐방/각목/봉제사 신규 자재·각목 900이하/초과.
- **[GAP-SL-6] CPQ 옵션 레이어 일괄 적재(BATCH-6)** — 27 실사 미적재.
- **[GAP-SL-7] 비치수 수치 범위 검증처(Q-SL-7)** — R-SIZE-NONSPEC/R-GAKMOK products 범위 컬럼+앱 vs 비표준 var vs 앱 런타임.
- **[GAP-SL-8] 수량 빈값 보완·아크릴스티커 UV 라우팅(Q-SL-5/6/A)** — 메쉬현수막/홀로그램/유광아크릴 수량 L1 빈값.
- **롤 소재 가격 계산 로직(source-registry §9 GAP-2)** — 엑셀 미기재 암묵지·실사 전체 영향·실무진.
