# §9 위키 승계 맵 (wiki-inheritance-map)

> **작성:** okb-source-curator · 2026-07-03
> **대상:** `_workspace/print-kb/wiki/` 전 페이지
> **목적:** 옛 위키(§9 print-kb)의 어느 페이지·어느 절을 새 지식베이스(Huni-Ontology-KB)가
> 그대로 물려받아도 되는지(INHERIT), 다시 확인한 뒤 물려받아야 하는지(REVERIFY),
> 버려야 하는지(DROP)를 절 단위로 못박는 판정표.

---

## 0. 판정 기준·용어 (쉬운 말 풀이)

- **INHERIT(인헤리트, 그대로 승계)** — 지금도 참이라고 믿어도 되는 내용. 새 KB가 그대로 가져간다.
- **REVERIFY(리베리파이, 재검증 후 승계)** — 골격은 쓸 만하나, 위키가 쓰인 뒤(2026-06-18 이후)
  데이터가 바뀌었거나 권위 엑셀이 260702판으로 교체되어 **숫자·현황을 다시 대조해야** 하는 내용.
  대조가 끝나기 전에는 사실로 인용 금지.
- **DROP(드롭, 폐기)** — 이후 세션에서 틀렸다고 확정됐거나, 권위 지위를 잃은 내용. 새 KB에 넣지 않는다
  (단, "과거에 이렇게 오판했다"는 함정 기록으로는 남길 수 있음).

**판정 근거 4종(모든 판정에 출처 병기):**
1. 위키 자체 신호 — 각 페이지 badge(✅확정/🟡권장/🔴미결정·STALE/⚪명세)와 STALE 마킹.
   단, 에이전트 규칙대로 **badge는 1차 신호일 뿐 맹신하지 않았다.**
2. 위키 연대기 — `wiki/log.md`. **위키 마지막 집필/게이트 = 2026-06-18**(가격엔진 축 델타).
   정책 레이어는 2026-06-05, 레시피 대부분은 2026-06-12 집필.
3. 위키 이후의 교정 이력 — CLAUDE.md §17~§32 변경이력·프로젝트 메모리
   (2026-06-19 ~ 07-02 사이 라이브 DB에 수십 건의 교정 COMMIT이 실행됨).
4. 권위 기준일 — 위키 전체가 **구 권위(상품마스터 260610·가격표 260527)** 위에서 쓰였고,
   현재 권위는 **260702 엑셀 2종**(`docs/huni/후니프린팅_상품마스터_260702.xlsx` ·
   `후니프린팅_인쇄상품_가격표_260702.xlsx`)이다. → 구 권위 수치에 기대는 절은 **기본 REVERIFY**.

**실측 인벤토리(배정 문구와 실제 파일 차이 — 실제 기준으로 판정):**

| 구역 | 배정 문구 | 실제 | 비고 |
|---|---|---|---|
| base | 7 | **7** | 일치 |
| axes(huni/) | 7 | **7** | modeling-axioms 포함 |
| recipes | 11 | **10 파일** | 디자인캘린더가 calendar.md에 통합(팩 결정, log 2026-06-12) → 논리 11·파일 10 |
| policy | 8 | **10** | coupon·custom-dev·membership-auth·mypage·operations·order-mgmt·order-payment·product-pricing·review·shipping |
| 특수 | README·index | **README·index·log + sources/policy-checklist** | log·sources도 판정 대상에 포함 |

---

## 1. 판정 총괄표 (페이지 단위 한눈 요약)

| 페이지 | 판정(지배적) | 한 줄 사유 |
|---|---|---|
| base/* 7종 | **INHERIT** | 인쇄산업 일반 지식(외부 표준 검증). 260702 권위·라이브 변동과 무관 |
| huni/modeling-axioms | **INHERIT** | HMOD-01(인쇄방식≠최상위 축)이 현행 SOT와 정합 |
| huni/materials | REVERIFY | 결함현황 절이 2026-06-30~07-02 자재 정리 COMMIT들로 낡음 |
| huni/processes | REVERIFY | 공정 9건 논리삭제(06-19)·base 공정 PROC_000004 대발견(07-01) 미반영 |
| huni/price-engine | REVERIFY(+DROP 1) | 엔진 계약은 건재하나 §4 "판수=앱"이 반증됨·분포 수치 낡음 |
| huni/cpq-options | REVERIFY | "전면 미적재·option_items 18행" 현황이 이후 적재로 무효 |
| huni/widget-contract | REVERIFY | §6 컨버전 트랙(07-01)·5클래스 명세가 상위 원천으로 등장 |
| huni/load-path | INHERIT(방법론)+REVERIFY(현황) | FK 위상·멱등·v03 금지는 건재, 적재 현황 수치는 낡음 |
| recipes/* 10종 | **REVERIFY**(절 대부분) | 전부 구 권위(260610/260527)+round-13 기반 → 기본 REVERIFY 규칙 적용 |
| policy/* 10종 | REVERIFY(operations만 부분 INHERIT) | 06-05 작성. 이후 §24/§28에서 Shopby=백엔드 확정 등 결정 다수 |
| README.md | **INHERIT** | 위키 스키마·컨벤션(원자 블록·관계 그래프·8절 템플릿) — 방법론 자산 |
| index.md | REVERIFY | 카탈로그·badge 집계가 페이지 갱신에 종속(그 자체가 사실 아님) |
| log.md | **INHERIT** | append-only 연대기(역사 기록). 사실 원천으로는 쓰지 않음 |
| sources/policy-checklist.md | INHERIT(역사)+REVERIFY(현행성) | 원천 요약. 현행 정책 권위는 §28 산출로 이동 |

---

## 2. BASE 7페이지 — 페이지×절 판정

> base는 "인쇄산업 일반 지식"으로 후니 데이터(코드·가격·스키마)를 담지 않는다(README §1).
> 260702 엑셀 교체·라이브 DB 교정의 영향권 밖 → 전 페이지 INHERIT.
> **승계 시 조건:** 각 사실에 붙은 신뢰도 라벨([검증]=독립 출처 2개 이상 / [단일출처] / [추정])을
> **라벨째 승계**한다. [추정]·GAP 절을 사실로 승격하려면 새 외부 검증이 필요(이건 승계가 아니라 신규 작업).

| 페이지 | 절 | 판정 | 근거 |
|---|---|---|---|
| base/printing-methods | §1 5대 분류 · §2 디지털 · §3 선택 변수 | INHERIT | 전건 [검증](index.md L13, `_research/base-verification.md` 교차검증) |
| base/sizes | §1 크기 3축 · §2 블리드 · §3 임포지션 · §4 결방향 · §5 표준 | INHERIT | [검증] 다수. §3 임포지션은 일반론만 — 후니 판걸이수 구현은 huni측 사실(아래 price-engine §4 참조)이므로 base에 섞지 말 것 |
| base/paper | §1 결방향 | INHERIT | [검증] |
| base/paper | §2 평량/전지/종류 · §3 비종이 · GAP | INHERIT(라벨 유지) | [추정]/GAP로 정직 표기됨 — 라벨째 승계 |
| base/finishing | §1 프레임(CIP4) | INHERIT | [검증] |
| base/finishing | §2 코팅/박/형압 · GAP | INHERIT(라벨 유지) | [추정]/GAP 표기 |
| base/binding | §1 기반 | INHERIT | [검증] |
| base/binding | §2 제본방식 · GAP | INHERIT(라벨 유지) | [추정]/GAP 표기. 미싱제본 검증대기(GAP-BBD-3)는 여전히 미검증 |
| base/color | §1 CMYK/망점 | INHERIT | [검증] |
| base/color | §2 별색/도수/화이트 · GAP | INHERIT(라벨 유지) | [추정]/GAP 표기. **주의:** 후니의 "별색=공정, 도수=print_opt_cd" 사실은 huni 축 소관 |
| base/prepress-file | §1 임포지션/판걸이 · §2 출력규격 | INHERIT | [검증] |
| base/prepress-file | §3 파일포맷/해상도 · GAP | INHERIT(라벨 유지) | [추정]/GAP 표기 |

---

## 3. AXES(huni/) 7페이지 — 페이지×절 판정

### 3.1 huni/modeling-axioms — **INHERIT**
- HMOD-01(인쇄방식은 최상위 분기축이 아니다·시트=1차 단위): **INHERIT**.
  현행 정본과 정합 — 메모리 `dbmap-print-method-not-absolute-axis`(추정 금지 [HARD])·
  상품 유형 분류 SOT(`_workspace/_foundation/product-type-classification-sot.md`)와 충돌 없음.

### 3.2 huni/materials

| 절 | 판정 | 근거·재검증 대조 소스 |
|---|---|---|
| §1 자재 구조(t_mat_materials·parent+usage_cd) | INHERIT(앵커 확인 조건부) | 구조 자체는 안정. 컬럼 앵커는 `mat_typ_cd`로 이미 교정됨(log 06-18 F-AX-MAT-1). 대조: `live-snapshot/latest/t_mat_materials.csv` |
| §2 자재 유형·사용축 코드 도메인 | REVERIFY | 06-19 §17 공정 파일럿에 이어 기초코드 정리 지속. 대조: `live-snapshot/latest/t_cod_base_codes.csv` + `_workspace/huni-basedata-dedup/` |
| §3 결함 현황(round-13 양면표) | **REVERIFY(대부분 해소됨)** | 위키 이후 실제 교정 COMMIT: 굿즈 자재 오염 6상품 9매핑 정리(06-30, 메모리 `goods-material-contamination-260630`)·스티커 4상품 사이즈 재키잉 복구(07-02, 메모리 `formula-components-wiring-subtrack-260701`)·명함 자재 collapse(§26). 대조: `live-snapshot/latest/t_prd_product_materials.csv` + 각 트랙 undo/backup 파일 |
| §4 GAP(dep_proc_cd 대체경로 미확정 등) | REVERIFY | 자재→공정 게이팅의 대체경로가 **§31 제약규칙(t_prd_product_constraints·폼빌더)** 로 사실상 열림(07-02, 129/130/047 COMMIT). 대조: `_workspace/huni-constraint-rules/` |
| Sources·STALE 목록(loadspec L96 등) | INHERIT | STALE 함정 목록은 그대로 유효 — 함정표로 승계 |
| **신규 [HARD] 반영 필요(승계 밖 신규)** | — | "실무진이 IMPORT 시트로 등록한 자재는 배선 안 됐다고 **삭제 금지**(배선/단가 채울 갭)" — 사용자 지적(메모리 `formula-components-wiring-subtrack-260701`). 위키에 없음 |

### 3.3 huni/processes

| 절 | 판정 | 근거·재검증 대조 소스 |
|---|---|---|
| §1 공정 구조 | REVERIFY | §17 공정 파일럿에서 **9건 논리삭제 COMMIT**(06-19, CLAUDE.md §17 변경이력) — 행 구성 변동. 대조: `live-snapshot/latest/t_proc_processes.csv` |
| §2 별색=공정(clr_cd=NULL)·UV=PROC_000002 | INHERIT(핵심)+보강 | 라이브 확증 이력 다수(log 06-18 W3). 단 **통합별색 component**(COMP_PRINT_SPOT_WHITE_S1, 개별 CLEAR/GOLD use=N — 메모리 `whiteprint-material-4color-unified-spot-component-260630`) 신사실 병합 필요 |
| §3 결함 현황(코팅 CONFLICT BATCH-3 등) | REVERIFY | 코팅 문제는 §26에서 "032 코팅 독립재발견"(메모리 `dimension-conformance-3face-diagnosis-260630`)·047 코팅×종이두께 제약 COMMIT(§31, 07-02)으로 진행됨. 대조: `_workspace/huni-price-table-integrity/HANDOFF.md`·`_workspace/huni-constraint-rules/` |
| §4 GAP(excl_groups→option_groups 흡수·신규공정 BATCH-13) | REVERIFY | 골격 유지. 단 **미싱제본 proc 이원화(030↔086)·오시(029↔090)·캘린더제본(099)** 이 systemic으로 확정(메모리 `contribution-scan-silent-zero-260701`) — 위키의 "미싱제본 MISSING" 서술을 이원화 프레임으로 재검증 |
| Sources·STALE | INHERIT | extraction-plan L56·excl csv 등 함정 목록 유효 |
| **신규(승계 밖)** | — | **base 인쇄공정 PROC_000004 미바인딩=인쇄비 영구 0** 대발견·18건 COMMIT(07-01, 메모리 `digital-print-base-proc-missing-260701`) — 위키에 전혀 없음. 새 KB 공정 축의 최상위 사실로 신규 등재 |

### 3.4 huni/price-engine (321줄·최대 축 — 절별 세분)

| 절 | 판정 | 근거·재검증 대조 소스 |
|---|---|---|
| §0 SOT 1~7(차원경계·10차원·옵션=BUNDLE 등) | INHERIT(정의)+REVERIFY(수치) | 사용자 권위 정의라 골격 승계. 단 "상품마스터=차원경계"의 상품마스터가 260610→**260702로 교체**(33+32셀 diff, §23 변경이력) → 차원경계 값 재대조. 대조: `_workspace/huni-dbmap/26_change-tracking-260702/master-diff-260610-260702.csv`·`price-diff-260527-260702.csv` |
| §1 5장치(공식/구성요소/할인/뷰어/시뮬레이터=evaluate_price 단일 알고리즘) | INHERIT(+보강 1) | pricing.py=단일 권위는 불변(CLAUDE.md §13·§1 SOT). **보강:** 셋트 가격 `evaluate_set_price`(pricing.py:718 — 구성원 합산+부모 공식+할인, CLAUDE.md §23)가 위키에 없음 → 승계 시 추가. 대조: `raw/webadmin/webadmin/catalog/pricing.py` 직접 |
| §2 엔진 거동(단가형143/합가형3·C3 ValueError 등) | REVERIFY | 분포 수치는 06-18 스냅숏. 이후 prc_typ 교정 다수(**.01→.03 고정** 완칼 die-cut 023/046·모서리비, .01→.02 — 메모리 `bandtotal-x-qty-overcharge-260628`·`digital-print-base-proc-missing-260701`) → "2갈래" 서술을 **3유형(.01 단가/.02 합가/.03 고정)** 으로 재검증. **신규 거동:** 엔진 del_yn 미필터(메모리 `price-component-unify-vs-split-criterion-260630`)·always-add 가드(use_dims에 opt_cd 미포함→silent 가산, 메모리 `catalog-conformance-rc2-addon-260623`)·밴드 프로레이팅(메모리 `gangpan-band-prorate-golden-na-260630`). 대조: pricing.py + `live-snapshot/latest/t_prc_price_components.csv` |
| §3 공식 유형 4종·바인딩 76 등 | REVERIFY | 이후 공식 신설·배선 대량 실행: PRF_BOOK_COVER·PRF_HC_TWINRING_SET(메모리 `leather-hardcover-077-live-commit-260701`)·배선 서브트랙 7세션(§27 — **데이터 배선 결함 0 달성**, 07-02). "직접단가 0" 등 카운트 전면 재측정. 대조: `live-snapshot/latest/t_prc_price_formulas.csv`·`t_prc_formula_components.csv` + `_foundation/batch/wiring/wiring-status.json`·`wiring/HANDOFF.md` |
| §4 앱 계산 경계 — **"판수=앱 계산(DB 미저장)"(PE-010)** | **DROP** | 07-01에 반증·교체됨: 판걸이수는 DB 함수 `fn_calc_pansu`(기하 폴백) + **`t_siz_pansu` lookup 테이블 신설**로 라이브 DB에서 계산(CLAUDE.md §26 변경이력·메모리 `pansu-authority-fn-calc-pansu-260628`). 판형 자동선택도 `fn_best_plate`. 대체 정본: `_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md`(12규칙 SOT) + `_workspace/huni-price-table-integrity/DEV-REQUEST-fn-calc-pansu-260701.md` |
| §5 STALE(PE-STALE·PE-STALE2) | **INHERIT** | price-engine-ddl 전체·prcx01/pricing-erd(8차원·clr_cd) 인용 금지 — 현행 STALE 목록과 일치(에이전트 HARD 규칙과 동일). 함정표로 그대로 승계 |
| §6 GAP 10건 | REVERIFY(다수 해소) | PE-GAP-3(6상품군 가격 0행)→이후 대량 적재로 대부분 해소·PE-GAP-9(제약 장치 설계)→§31로 실행됨·PE-GAP-4(박·plate)→판형은 HARNESS-DOMAIN-RULES로 확정. 남은 GAP만 이관. 대조: `_workspace/_foundation/price-pipeline-rtm.csv`·`_workspace/huni-product-readiness/`(283상품 준비도) |

### 3.5 huni/cpq-options

| 절 | 판정 | 근거·재검증 대조 소스 |
|---|---|---|
| §1 옵션 레이어 구조(option_groups/options/items·polymorphic ref_dim_cd) | INHERIT(구조) | 스키마 구조 불변. 대조(형식 확인만): `live-snapshot/latest/t_prd_product_option_*.csv` |
| §2 매핑 원칙(BUNDLE=자재+공정·constraints.logic 단일경로) | INHERIT(+보강) | 원칙 유효(메모리 `dbmap-option-material-process-bundle` [HARD]). **보강:** 옵션참조는 같은 부모 prd_cd에 실재 필수(`fn_chk_opt_item_ref` 트리거, 메모리 `set-product-bom-role-reassignment-260701`)·제약은 **폼빌더 정형 shape만**(raw JSONLogic 금지, CLAUDE.md §31 [HARD]) |
| §3 현황("전면 미적재·option_items 18행=위키 권위") | **REVERIFY(현황 무효)** | 18행은 06-12 실측. 이후: RC-2 각목 12행 COMMIT(06-23, §21)·020 화이트인쇄 인쇄옵션 SPOT 발현(07-02, §27)·Tier A CPQ 적재(메모리 `dbmap-tierA-cpq-option-load`). "18행 권위" 지위는 **DROP**하고 라이브 스냅샷을 권위로. 대조: `live-snapshot/latest/t_prd_product_option_items.csv` 행수 재측정 |
| CPQ-STALE(constraint_json 삭제·RULE_TYPE 2종) | INHERIT | 함정 목록 유효. **보강:** §31에서 RULE_TYPE 운용 실례 확정(금지형 .02 전환 패턴 C-10, CLAUDE.md §31) |
| §4 GAP(BATCH-6 일괄 적재 등) | REVERIFY | 제약 0행 전제는 무효(§31 COMMIT들). 대조: `live-snapshot/latest/t_prd_product_constraints.csv` + `_workspace/huni-constraint-rules/03_rules/` |

### 3.6 huni/widget-contract

| 절 | 판정 | 근거·재검증 대조 소스 |
|---|---|---|
| §1 계약·어댑터 경계 | REVERIFY | 위키가 PARTIAL-STALE로 헤지한 `huni-db-mapping.md`는 이후 **정식 폐기(STALE) 확정**(메모리 `huni-widget-db-cartography-conversion-track-260701`) → 해당 참조는 DROP. 어댑터의 현행 원천=§6 컨버전 트랙(라이브 DB→정규화 계약 매핑·createHuniAdapter). 대조: `_workspace/huni-widget/`(03_spec 컨버전 산출)·CLAUDE.md §6 |
| §2 컴포넌트·상태·연동(14 componentType) | REVERIFY | 07-01 **위젯 5 복잡도 클래스 종단 명세**에서 "위젯 계약 변경=0 전 클래스"(area-input·ProductSide·Slider=어댑터 흡수) 확정(메모리 `widget-forms-5class-spec-260701`) — 14 componentType 서술을 이 명세와 대조 후 승계 |
| §3 WID-STALE(Red 가격값 후니 인용 금지·ATTB 날조 전례) | **INHERIT** | 함정표 유효. PRICE=0=우리측 결함 신호 [HARD](메모리 `huni-widget-red-price-never-zero`)·서버 가격권위(메모리 `huni-widget-price-strategy`)도 현행 SOT(HARNESS-DOMAIN-RULES 12규칙)와 정합 |
| §4 GAP | REVERIFY | 대조: `_workspace/huni-widget/HANDOFF.md`(오케 v1.5.0, 07-02 감사 반영) |

### 3.7 huni/load-path

| 절 | 판정 | 근거·재검증 대조 소스 |
|---|---|---|
| §1 적재 oracle(load_master=전파기·진원 v03) | INHERIT | round-13 확정 사실. 함정 구도 불변 |
| §2 FK 위상·멱등 UPSERT·search-before-mint | **INHERIT** | 이후 모든 적재 트랙(§7·§23·§27)이 같은 패턴으로 계속 실증(백업→DRY-RUN→COMMIT→사후검증·undo 보유) |
| §3 admin 입력경로·백필 분리 | REVERIFY | webadmin 화면·백필 진행 상황 변동. **보강 [HARD]:** "라이브 적재 전 webadmin 실화면 확인 필수(제외 0·PRICE≠0)"가 전 트랙 공통 규칙으로 승격됨(CLAUDE.md §1) — 위키에 없는 신규 절차 |
| §4 LP-STALE(v03 입력 금지·구 PK 충돌) | **INHERIT** | 현행 STALE 목록과 일치 |
| §5 GAP·"GO분 적재됨" 수치 | REVERIFY | 적재 수치(3,504행 등)는 06-12 시점. 이후 대량 COMMIT으로 낡음. 대조: `live-snapshot/latest/_manifest.csv`(스냅샷 행수 총람) |

---

## 4. RECIPES 10페이지 — 페이지×절 판정

> **공통 규칙:** 레시피 전부 구 권위(260610/260527)+round-13(2026-06-10 전후) 기반 →
> 에이전트 HARD 규칙("권위 기준일 260610/260527이면 기본 REVERIFY")에 따라
> **내용 절(0~7절)은 기본 REVERIFY**. 예외적으로 INHERIT하는 것은
> ① Sources의 STALE 함정 목록 ② CQ 헤더·관계 그래프 링크 구조 ③ 라이브와 무관한 방법론 서술.
>
> **공통 재검증 대조 소스(전 레시피):**
> - 정체·차원(0~1절): `26_change-tracking-260702/master-diff-260610-260702.csv`(변경 셀만 보면 되므로 경제적) + `24_master-extract-260610`(구 캐시) + 원본 260702 xlsx(diff에 걸린 시트만)
> - BOM·CPQ(2·4절): `live-snapshot/latest/`(snap_20260702_1119) 해당 t_* CSV
> - 가격사슬(3절): `live-snapshot/latest/t_prc_*.csv` + `_foundation/batch/wiring/`(배선 진척) + `_foundation/price-pipeline-rtm.csv` + `26_change-tracking-260702/price-diff-260527-260702.csv`
> - 위젯(5절): 메모리 `widget-forms-5class-spec-260701` + `_workspace/huni-widget/`
> - 적재(6절): huni/load-path 판정 준용
> - 결함(7절 양면표): 각 트랙 HANDOFF/undo 파일로 "해소 여부" 확인 — 해소된 행은 역사로 강등

| 레시피 | 절 | 판정 | 레시피 고유 사유(위키 이후 변동) |
|---|---|---|---|
| **digital-print** | 0~1 정체·차원 | REVERIFY | 016 수량 max 2행 교정(07-02, 메모리 `qty-system-audit-260702`) |
| | 2 BOM | REVERIFY | **base 공정 PROC_000004 미바인딩 18건 COMMIT**(07-01) — 인쇄비 0 결함 해소, BOM 서술 낡음 |
| | 3 가격사슬 | REVERIFY(高) | 완칼 die-cut ×판수 이중적용→.03 고정 COMMIT(023/046)·명함 고아 component 배선(032/031, 메모리 `namecard-orphan-component-wiring-260630`)·프리미엄엽서 완성(메모리 `premium-postcard-completion-method-260628`) |
| | 4 CPQ · 5 위젯 · 6 적재 | REVERIFY | 공통 규칙 |
| | 7 결함(C-01~18) | REVERIFY(高) | 카테고리 격상 183건 junction COMMIT(round-24, §7)으로 고아 서술 재확인 필요 |
| | Sources·STALE | INHERIT | mapping-final "180g→constraint_json"·"엽서 13종" 등 함정 목록 유효 |
| **sticker** | 0~1 | REVERIFY | **4상품(052/053/058/055) 사이즈 재키잉 파손→복구 COMMIT**(07-02, A6=100x148 등) |
| | 2 BOM | REVERIFY | 코팅 자재 오적재 8상품 — BATCH-3 이후 진행 재확인 |
| | 3 가격사슬 | REVERIFY | **스티커=고정가 by-siz_cd 확정**(메모리 `sticker-pipeline-260628`)·스티커 시트 전건 gap-0 종결(메모리 `gangpan-band-prorate-golden-na-260630`)·option_items.ref_key1 함정(시뮬이 option_items를 봄) |
| | 4~6 | REVERIFY | 공통 |
| | 7 결함 | REVERIFY(高) | 063 화이트 누락 등 — 260702 권위(★스티커 소재 연당가 변경=High 재적재 큐, §23)와 대조 필수 |
| | Sources·STALE | INHERIT | — |
| **booklet** | 0 정체(10완제품+21반제품·생산구조 3종) | REVERIFY(高) | §23에서 셋트 구조 전면 재설계: 072 내지 반제품 승격·**077/082/068/069/070 COMMIT**(0원→실가격, 메모리 `leather-hardcover-077-live-commit-260701`)·표지 member 분리(PRF_BOOK_COVER)·부모 공식=제본만(이중합산 방지) |
| | 1~2 차원·BOM | REVERIFY | 셋트 BOM 역할 재배치 원칙(표지/내지/면지 각 반제품에 판형·자재 재배치, 메모리 `set-product-bom-role-reassignment-260701`) |
| | 3 가격사슬 | REVERIFY(高) | 표지 펼침/개별 분기(cover_mult, §18 — 데이터 GO/×2 실행 BLOCKED C트랙)·책자표지 288/290/292 base proc COMMIT·**088 재설계 게이트 S1~S8 GO, 적재 승인 대기**(§23, 07-02 밤) — "088 BLOCKED" 서술은 상태 갱신 필요 |
| | 4~6 | REVERIFY | 공통 |
| | 7 결함(BK-1~8) | REVERIFY(高) | 몽블랑→레더(BK-2)·레더 .08→.06 등 교정 진행분 확인. 대조: `_workspace/huni-set-product/`(03_design·05_gate·06_load·HANDOFF.md) |
| | Sources·STALE | INHERIT | 떡메 "✓" 라이브 갭 은폐 함정 기록 유효 |
| **photobook** | 0~2 | REVERIFY | 셋트 3-tier 검증 모델(메모리 `set-semifinished-3tier-model-260629`)·레더 .06 횡단 교정 여부 |
| | 3 가격사슬("PRF_PBK_PAGEBAND 라이브 미적재 0행") | **REVERIFY(사실 뒤집힘)** | **포토북 100 page-band COMMIT 완료**(메모리 `book-set-page-pricing-inner-member-260629` — "기본24P+추가2P당" 내지 구성원 단가형) → "미적재" 서술 무효. PB-PRC-002(엽서북 혼동 차단)는 유효하나 094 엽서북도 셋트 수렴 완료(07-02, §23) |
| | 4~6 | REVERIFY | 셋트 UI siz_cd 미전파 코드 1점(094/097/100 공통, `_foundation/remediation/DEV-REQUEST-set-sim-sizcd-260702.md`) — 위젯·시뮬 서술에 직결 |
| | 7 결함 | REVERIFY | PB-M1(가격 0행)=해소로 강등. F-PB-1 oracle 날조 적발 기록은 함정표로 INHERIT |
| | Sources·STALE | INHERIT | — |
| **calendar** | 0~2 | REVERIFY | 삼각대/링 자재 오적재 교정 진행분·공정 mint 여부 확인 |
| | 3 가격사슬("캘린더 공식 미적재") | **REVERIFY(사실 뒤집힘)** | **110 엽서캘린더 PROC_000004 누락 교정 COMMIT(1,057→16,357원)**(07-02, §27 배선 7세션)·캘린더제본 proc 이원화(099, 메모리 `contribution-scan-silent-zero-260701`)·벽걸이 이중권위 통일(§27 6세션) |
| | 4 CPQ(가공 택일=option_groups 흡수) | REVERIFY | 골격 유효하나 §31 제약규칙 등장으로 택일 표현 수단 재정리 |
| | 5~6 | REVERIFY | 공통 |
| | 7 결함(C-CAL 14행) | REVERIFY(高) | 교정 COMMIT 반영해 해소/잔존 재분류 |
| | Sources·STALE | INHERIT | round-11 "USAGE.01 본체" 등 함정 유효 |
| **acrylic** | 0 정체(23등록 146~169) | REVERIFY | **168/169/170 use_yn=N 정리 COMMIT(미출시 확정)**(07-02, §31) — 등록 카운트 변동 |
| | 1~2 | REVERIFY | 공통 |
| | 3 가격사슬(면적매트릭스) | REVERIFY(高) | §26 파일럿에서 **156셀 미적재 적발→COMMIT**(메모리 `acrylic-integrity-260628`)·siz_cd×면적=코드버그 C트랙(메모리 `price-formula-master-completeness-260627`)·잔여 결함 6=전부 아크릴 `*_TBD` 실무진 BLOCKED(§27 round22) |
| | 4 CPQ(볼체인 addon 소실) | REVERIFY | RC-5 아크릴 단가교정(06-23, §21)·아크릴 5=미출시 확정(제약 안 만듦, §31) |
| | 5~6 | REVERIFY | 공통 |
| | 7 결함(UV print_side 20상품 등) | REVERIFY(高) | 교정 진행분 대조. 대조: `_workspace/huni-price-table-integrity/`·`_workspace/huni-catalog-conformance/` |
| | Sources·STALE | INHERIT | 좌표회귀 금지 등 유효 |
| **silsa** | 0~2 | REVERIFY | 자재 .08 평면화·레더 횡단 교정 진행분 |
| | 3 가격사슬(면적매트릭스 13+고정가 16) | REVERIFY | **실사=포스터/사인 가격 권위가 12규칙 SOT로 승격**(HARNESS-DOMAIN-RULES-260701 — 원칙은 INHERIT급) · 족자/타공8 단가 컨펌 잔여·PET HOLD-1(§21 잔여) |
| | 4 CPQ(일반현수막 og3/oi18 파일럿) | REVERIFY | RC-2 각목 12행 COMMIT(06-23, §21 — 택1 900이하/초과·세로가로 생산메타 분리) → oi 수치 낡음 |
| | 5~6 | REVERIFY | 타공 위젯 코드트랙 잔여(§21) |
| | 7 결함(SL-DEF 7행) | REVERIFY | 카테고리 고아 CAT_000298 재연결 여부 라이브 확인 |
| | Sources·STALE | INHERIT | — |
| **goods-pouch** | 0~1 | REVERIFY | 공통(260702 diff) |
| | 2 BOM(자재 폭증/오염 .09) | **REVERIFY(대부분 해소)** | **자재 오염 6상품 9매핑 정리 COMMIT**(06-30, 메모리 `goods-material-contamination-260630` — 거치대/키링고리/볼펜 등 비기재 오적재 정리·PEARL 단가행 오염 별도) |
| | 1절 내 plate 양면표기(GP-DIM-002) | REVERIFY(방향 확정) | **판형=종이류 출력소재만 [HARD]**(HARNESS-DOMAIN-RULES §1)·완제품 사이즈 오적재 127상품 plate 논리삭제 COMMIT(메모리 `platesize-paper-only-diagnosis-260630`) → "122행 적재됨 vs 미적재 정당" 양면은 SOT로 판정 가능해짐 |
| | 3 가격사슬(고정가+굿즈A/B 구간) | REVERIFY | 포맥스 5mm BOARD 동형확장 COMMIT(07-02, §27)·포맥스 A1/3mm 권위충돌 컨펌 잔여 |
| | 4~6 | REVERIFY | 공통 |
| | 7 결함 | REVERIFY(高) | 봉제→부착 오적재 등 교정 여부 대조 |
| | Sources·STALE | INHERIT | — |
| **product-accessory** | 0~1 | REVERIFY | 공통. 이중등록=의도(OTC) 판정은 유지 가능성 높음 — diff만 확인 |
| | 2 BOM(색상 4종 자재 오염) | REVERIFY | 기초데이터 정리 트랙(§17) 진행분 대조 |
| | 3 가격사슬("가격 0행") | REVERIFY | (가격포함)=직접단가 110상품 트랙(메모리 `catalog-price-3model-coverage-260629`)에서 부자재 적재 여부 재확인. RC-2 추가물 3상품 COMMIT(06-23)·always-add 가드 |
| | 4 CPQ(봉투세트 사이즈매칭) | REVERIFY | §31 제약규칙 프레임으로 재표현 후보(CN-3 필수동반) |
| | 5~7 | REVERIFY | 공통 |
| | Sources·STALE | INHERIT | — |
| **stationery** | 0 정체(prd_typ .03 기성 10·097=.04) | **REVERIFY(재분류 실행됨)** | 상품 유형 분류 SOT 확정(완.01/반.02/기성.03/**디자인.04 폐기→재분류**, CLAUDE.md §1)·실제 재분류 실행 흔적(`_foundation/realign-backup-prdtyp04-260626.csv`·`realign-undo-gisung88-260626.sql`) → ST-ID-001 코드 매핑 재실측 |
| | 1 차원 | REVERIFY | **097 떡메 min6 COMMIT·065 단가행 54→1·사이즈 수량규칙 49행 충전**(07-02, 메모리 `qty-system-audit-260702`) |
| | 2 BOM | REVERIFY | 문구 9셋트 전수감사(메모리 `set-product-bom-role-reassignment-260701` 18셋트 감사표) |
| | 3 가격사슬("C29 inline·prices 0행") | REVERIFY(高) | 097 떡메=§23 파일럿으로 진행·셋트 19개 가격레벨 전수 진단에서 18/19 PRICE≠0(메모리 `set-product-full-diagnosis-260702`) → "0행" 서술 낡음 |
| | 4~6 | REVERIFY | 공통 |
| | 7 결함(미싱제본 MISSING 등) | REVERIFY | 미싱제본은 proc 이원화(030↔086) 프레임으로 재판정(메모리 `contribution-scan-silent-zero-260701`) |
| | Sources·STALE | INHERIT | booklet "✓" 함정 기록 유효 |

**레시피 공통 INHERIT 자산(전 10페이지):**
- CQ 헤더·8절 템플릿 구조·관계 그래프([[링크]]+6동사)·역링크 슬롯 — 새 KB의 페이지 골격으로 승계.
- Sources 절의 STALE 함정 선언(v03·price-engine-ddl·constraint_json·dep_proc_cd 등) — 함정표로 승계.
- "라이브 현재값 ↔ 정답" 양면 표기 원칙 자체 — 방법론으로 승계(개별 행의 현재값은 REVERIFY).

---

## 5. POLICY 10페이지 — 판정

> 전부 2026-06-05 집필(원천=정책체크리스트 xlsx + 인터뷰). 위키 이후 §24(Shopby 통합 설계)·
> §28(1차 런칭 fit-gap: SOLVED 48/PARTIAL 53/CUSTOM 61)이 정책 결정의 현행 원천이 됨.
> **재검증 대조 소스(전 정책 공통):** `_workspace/huni-launch-scope/05_gate/후니프린팅_1차런칭_개발범위_Shopby갭_개발방안.md` + `_workspace/huni-launch-scope/02_gap/` + `docs/shopby/`(admin-analysis 방향: 주문/회원/정산/배송=Shopby 네이티브) + `_workspace/huni-shopby/`.

| 페이지 | 판정 | 사유 |
|---|---|---|
| policy/membership-auth | REVERIFY | 회원=Shopby 네이티브 방향 확정(§24)·회원 마이그레이션 설계(§28) 등장 — 🟡권장 5건의 결정 상태 변동 가능 |
| policy/mypage | REVERIFY | **프린팅머니=Shopby 적립금 재해석**(§28, 메모리 `huni-launch-scope-harness`) — 위키 서술과 프레임 자체가 바뀜 |
| policy/order-payment | REVERIFY | Shopby=백엔드 확정·**카트 동적가격 직접주입 불가=1차 최대 리스크**(§28) — 장바구니 항목 재판정 |
| policy/shipping | REVERIFY | 배송=Shopby 네이티브 방향(§24) — 🟡 4건 결정 상태 확인 |
| policy/coupon | REVERIFY | 쿠폰/적립 프레임이 Shopby 기능으로 이동 — 🟡 6건 전부 미확정 상태였음 |
| policy/review | REVERIFY | 동일(Shopby 네이티브 후보) |
| policy/product-pricing | REVERIFY | 상품·가격관리=커스텀 확정(§24 admin-analysis) + 가격 하네스 체계(§13~§27)가 실질 대체 — 위키 🔴 2건은 사실상 해소 경로 확정 |
| policy/order-mgmt | REVERIFY(✅ 3건은 조건부 INHERIT) | ✅(현행 운영) 3건은 현행 사실로 승계 후보. 단 주문관리=Shopby 네이티브+생산워크플로우=커스텀 분할(§24)로 문맥 재배치 |
| policy/operations | INHERIT(조건부) | ✅5(현행) — "지금 이렇게 운영한다"는 현행 기록. To-Be 결정은 별도(§28 로드맵과 병기) |
| policy/custom-dev | REVERIFY | "9 CUSTOM 필수개발"(🔴9)은 §28 fit-gap의 **CUSTOM 61건**으로 상위 대체됨 — 9종이 61건에 포섭되는지 매핑 후 흡수 |

- **index.md 정책 요약 행·"정책 합계 57항목·81% 미결정" 집계:** REVERIFY(§28 반영 후 재집계).

---

## 6. 특수 파일 판정

| 파일 | 판정 | 비고 |
|---|---|---|
| README.md(위키 스키마) | **INHERIT** | 3계층·원자 블록·badge 체계·관계 그래프 6동사·레시피 8절 템플릿·출처 권위 순서 — 새 KB 스키마의 출발점으로 그대로 승계(사실이 아니라 방법론) |
| index.md | REVERIFY | llms.txt 형식은 INHERIT. 각 행의 요약·badge 집계는 페이지 재검증 후 재생성(06-18에도 drift 지적 QA-PE-L1) |
| log.md | **INHERIT(역사)** | append-only 연대기 — 사실 원천 아님·이력 추적용으로 보존 |
| sources/policy-checklist.md | INHERIT(역사)+REVERIFY(현행성) | 원천 요약으로 보존. 현행 정책 권위는 §28 산출 |
| `_curation/`·`_qa/`·`_research/`(위키 내부 작업물) | INHERIT(도구·기록) | 큐레이션 팩 11종·게이트 판정서·linkcheck.py — 방법론 자산. 단 팩의 freshness 등급은 06-12 기준이라 **원천 등급은 새 source-registry가 대체**(팩 내용을 사실로 인용하려면 REVERIFY) |

---

## 7. DROP 확정 목록 (사유·대체 소스)

| # | 대상 | 사유 | 대체 소스 |
|---|---|---|---|
| D-1 | huni/price-engine §4 **PE-010 "판수=앱 계산·DB 미저장"** | 2026-07-01 반증: 판걸이수=DB 함수 `fn_calc_pansu`(+`t_siz_pansu` lookup 신설·기하 폴백), 판형 자동선택=`fn_best_plate` | `_workspace/_foundation/HARNESS-DOMAIN-RULES-260701.md`·`_workspace/huni-price-table-integrity/DEV-REQUEST-fn-calc-pansu-260701.md`·메모리 `pansu-authority-fn-calc-pansu-260628` |
| D-2 | huni/cpq-options §3 **"위키 권위=option_items 라이브 18행"(CONF-1)의 권위 지위** | 06-12 스냅숏 수치. 이후 CPQ 적재 다수(RC-2 각목 12행·020 인쇄옵션 등) — 고정 수치를 권위로 삼는 방식 자체 폐기 | `_workspace/_foundation/live-snapshot/latest/t_prd_product_option_items.csv`(항상 최신 스냅샷이 권위) |
| D-3 | huni/widget-contract §1의 **`huni-db-mapping.md`/`data-adapter.md`를 후니 t_* 매핑 소스로 쓰는 참조** | 위키는 PARTIAL-STALE로 헤지했으나 이후 **정식 폐기 확정**(가격/제약 미작성 전제) | §6 컨버전 트랙 산출(`_workspace/huni-widget/`)·메모리 `huni-widget-db-cartography-conversion-track-260701` |
| D-4 | 각 페이지의 **구 권위 표기 "상품마스터 260610·가격표 260527=현행 권위"라는 전제** | 권위 엑셀 260702로 교체(diff 33+32셀·스티커 소재 연당가 변경 등) | `docs/huni/*_260702.xlsx` + `_workspace/huni-dbmap/26_change-tracking-260702/` |
| D-5 | 레시피 7절 양면표 중 **이후 COMMIT으로 해소 확정된 행의 "교정대기" 상태값** | 예: photobook PB-M1 가격 0행(→적재됨)·calendar 110 인쇄비 0(→16,357원)·goods-pouch 자재 오염 6상품(→정리됨)·digital-print 인쇄비 0 18건(→COMMIT) | 각 행별 재검증에서 "해소(일자·undo 파일)"로 강등해 역사 기록으로만 보존 — §4 표의 레시피별 대조 소스 |

> 참고: `price-engine-ddl.md`·`prcx01/pricing-erd`·`v03 xlsx`·`constraint_json`·`dep_proc_cd` 등은
> 위키가 이미 STALE(인용 금지)로 격리해 놓았으므로 **"STALE 함정표"로서 INHERIT**한다(새로 DROP할 것 없음).

---

## 8. 위키에 없는 것 (승계 대상 아님 · 새 KB 신규 집필 큐)

승계 판정과 별개로, 위키 마감(06-18) 이후 생겨 **위키가 아예 모르는** 핵심 지식. okb-knowledge-builder가 신규 집필해야 할 목록:

1. **12규칙 도메인 SOT**(HARNESS-DOMAIN-RULES-260701) — 판걸이수·판형·종이류만 판형·면지 무가격·공식vs가격테이블·시뮬레이터 입증 등.
2. **상품 유형 분류 SOT** — 완.01/반.02/기성.03/디자인.04 폐기(CLAUDE.md §1 [HARD]).
3. **셋트상품 체계 전체**(§23) — t_prd_product_sets·evaluate_set_price·부모=그릇·BOM 역할 재배치·19셋트 전수 진단·088 재설계.
4. **배선(formula_components) 서브트랙**(§27) — 고아/빈배선/삭제오염 4결함·wiring_scan.py·데이터 결함 0 달성.
5. **제약규칙 거버넌스**(§31) — CN-1~CN-6 분류·폼빌더 정형 shape [HARD]·129/130/047 실등록.
6. **base 공정 PROC_000004·통합별색·proc 이원화** 등 07-01 공정축 대발견.
7. **§26 무결성 방법론**(정답격자·결정론 배치 diff·live-snapshot 체계) 및 **§29 준비도**(D1~D11·L0~L4·283상품).
8. **docs/kb 6문서**(260702 통화 기반 도메인 지식·엑셀 해부 방법론 등) — tier B 신규 원천.
9. **위젯 5클래스 명세·§6 컨버전 트랙**·Shopby 통합(§24)·1차 런칭 fit-gap(§28).

---

## 9. 재검증 실행 시 주의 (okb-knowledge-builder 인계 메모)

- **라이브 스냅샷은 "현재값"이지 "정답"이 아니다** — 반드시 260702 엑셀(권위)과 양면 대조.
  스냅샷 최신 = `_workspace/_foundation/live-snapshot/latest/`(= snap_20260702_1119, t_* 37종 CSV + `_manifest.csv`).
  더 최신이 필요하면 `snapshot.sh`로 재채취(읽기전용).
- **엑셀 반복 Read 금지** — 260702 대조는 `26_change-tracking-260702/`의 diff CSV(260610→260702 변경 셀만)부터.
  구조 변화는 같은 폴더 `structure-diff.md`·`change-manifest-260702.md`.
- 이 맵의 REVERIFY 판정 근거는 **세션 정본 기록(CLAUDE.md 변경이력·메모리)** 이며, 개별 행의
  라이브 재실측은 수행하지 않았다(그것이 REVERIFY 단계의 일). 즉 "뒤집혔다"고 적은 항목도
  승계 전에 스냅샷/엑셀로 1회 확정할 것.
- 판정 단위 원칙: 절 안에서도 블록별로 갈리면 **더 엄격한 쪽**(REVERIFY>INHERIT)을 절 판정으로 삼았다.
