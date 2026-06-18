# Axis Pack — price-engine (가격공식 엔진)

> freshness 권위: `18_schema-change/impact-diagnosis.md`(I-1·I-2·I-3·I-4·I-7). **이 축은 가장 stale 위험이 크다.**
> 핵심 [HARD]: `00_schema/price-engine-ddl.md`(C-PRICEENG)는 **STALE — 인용 금지**(6차원/8컬럼·단가형/합가형 부재·template_prices 누락·구 PK). 가격엔진 구조 인용은 **§0 신규 FRESH 원천 우선**.
>
> ★ **델타 갱신 2026-06-18 — 가격엔진을 라이브 실측으로 재확정한 두 신규 하네스가 이 축의 최상위 FRESH 원천.** 아래 §0 참조.
> ★ **권위 반전 [HARD]:** 기존 §정답소스가 FRESH로 등급했던 `raw/webadmin/docs/prcx01-pricing-model.md`·`pricing-erd.md`는 **STALE로 강등**(8차원·clr_cd 시절·`frm_typ_cd` 시절). 이제 가격엔진 **구조·차원·단가유형 인용 금지** — 의도 배경(왜 두 가지 가격소스를 두나 등)만 참고. 대체 = §0 신규 하네스 + `pricing.py` 직접.

---

## 0. ★신규 FRESH 원천 (2026-06-18 라이브 information_schema + pricing.py 실측) — 최우선 권위

> 이 두 하네스는 라이브 `evaluate_price`(pricing.py 570줄)와 라이브 t_prc_* 스키마/데이터를 방금 실측했다. 가격 축 집필의 **1차 권위**. 기존 §아래 round-2 매핑 산출(tier C)보다 우선한다(구조·차원·엔진 거동 한정).

### 0a. 가격엔진 이해·진단 하네스 (`huni-price-engine-diag/`) — tier A·FRESH

| 파일 | tier | freshness | 다룰 토픽(위키 가격 축) |
|------|------|-----------|----------------------|
| `01_mechanism/sot-definitions.md` | A | FRESH·**최상위 권위(사용자 7 SOT)** | **상품마스터 11시트=상품군 그릇=허용 차원 경계(SOT 1)** · 결합형/독립형 구성요소 도출 원리(SOT 2) · **10차원 정의(SOT 3b)** · 옵션=자재/공정 BUNDLE·가격 없음(SOT 3a) · **제약 장치 부재=오적재 근본(SOT 4)** · 직접단가 vs 공식 3-우선순위(SOT 5) · 수량×단가 두 갈래(완제SKU 재귀 vs 부자재 10차원 흡수, SOT 6) |
| `01_mechanism/device-roles.md` | A | FRESH | 5개 가격 장치(①공식 ②구성요소3테이블 ③할인 ④뷰어 ⑤시뮬레이터) 역할·입출력·연결·경계. SOT 반영판 |
| `01_mechanism/combination-mechanism.md` | A | FRESH | 결합/독립 구성요소가 단가행 차원으로 합쳐지고 쪼개지는 메커니즘 |
| `01_mechanism/knowledge-map.md` | A | FRESH | 가격엔진 지식 전체 지도(장치↔SOT↔코드 연결) |
| `02_code_schema/code-schema-matrix.md` | A | FRESH | 코드(pricing.py 상수·로직)↔라이브 스키마 컬럼 정합 매트릭스. NON_QTY_DIMS/TIER_DIMS↔단가행 컬럼 |
| `02_code_schema/price-source-intent.md` | A | FRESH | 가격소스 우선순위(템플릿→직접→공식→없음) 코드 의도 |
| `02_code_schema/constraint-mechanism-gap.md` | A | FRESH | **공식↔구성요소 배선 레벨 제약 장치 라이브 부재(SOT 4 실증)**·CPQ 제약과 별개 |
| `02_code_schema/impl-gap-board.md` | A | FRESH | 코드 있으나 데이터 0행(직접단가·템플릿단가·등급할인) 등 구현 갭 보드 |
| `02_code_schema/design-artifact-trace.md` | A | FRESH | **prcx01/pricing-erd 설계 문서가 STALE임을 코드 추적으로 확정**(8차원·clr_cd·frm_typ) |
| `03_synthesis/known-vs-unknown.md` | A | FRESH | **K-1~8 확정 / U-1~6 미지 / C-1~3 컨펌큐** 분리(미지를 결론으로 위장 금지) |
| `03_synthesis/sot-reconciliation.md` | A | FRESH | SOT가 직전 진단(F/K/U)을 어떻게 확정/해소/수정하는가 |
| `03_synthesis/engine-comprehension.md` | A | FRESH | 엔진 종합 이해(검증 트랙 핸드오프 기준) |

### 0b. 가격검증 하네스 (`huni-price-quote/`) — tier A·FRESH

| 파일 | tier | freshness | 다룰 토픽(위키 가격 축) |
|------|------|-----------|----------------------|
| `01_engine/engine-contract.md` | A | FRESH·**엔진 거동 권위(검증의 자)** | **`evaluate_price` 권위 계약** — 시그니처·반환·가격우선순위·공식=구성요소 합산·차원 자동매칭(NON_QTY/TIER)·단가형/합가형 환산·시계열·할인 순차곱·lenient/strict·C1~C9 검증명제. **모든 규칙 pricing.py:line 인용.** 가격공식 사슬 설명의 1차 소스 |
| `01_engine/price-flow-map.md` | A | FRESH | 선택값+수량→evaluate_price→최종가 흐름도 |
| `01_engine/widget-price-contract.md` | A | FRESH | 엔진↔위젯 가격 계약(strict 모드=실서비스 재검증). widget-contract 축 교차참조 |
| `02_authority/authority-golden.md`·`golden-cases.md` | A/B | FRESH | **골든 케이스**(실사 1000×1000=20,000·off-grid·아크릴 3T/1.5T 등 권위 엑셀 기대값) |
| `02_authority/authority-gaps.md` | A | FRESH | 권위 엑셀 대비 적재 갭 |
| `03_chain/dimension-mapping-matrix.md` | A | FRESH | 10차원↔라이브 단가행 컬럼↔엔진 매칭 3원 대조(독립 재실측) |
| `03_chain/chain-defect-board.md` | A | FRESH | **가격사슬 결함보드 D-1~D-7·E계열**(이중합산·침묵0원·유광 0행 등 정량 발화) |
| `03_chain/size-dedup-report.md` | A | FRESH | 사이즈 이산↔구간 무중복 점검 |
| `04_option/option-bundle-board.md`·`process-json-report.md`·`template-constraint-board.md` | A | FRESH | 옵션 BUNDLE 무결성·공정 dim_vals·템플릿/제약 정합(cpq-options 축 교차참조) |
| `05_gate/gate-verdict.md` | A | FRESH·**검증 판정** | **P1~P7 게이트 CONDITIONAL-GO** — 면적매트릭스(실사·아크릴) GO·합산형(엽서) NO-GO(가격 미완성 N-1). 데이터 결함 정량 확정 |
| `05_gate/arbiter-deliberation-N1.md` | A | FRESH | arbiter 심의(엽서 가격사슬 미완성 N-1 근본) |
| `05_gate/confirmed-defects.md`·`recompute-log.md` | A | FRESH | 확정 결함·라이브 재계산 로그(엔진 직접 호출 재현) |

### 0c. ★신규 원천이 못박은 핵심 사실 (위키 가격 축이 반드시 반영) [HARD]

1. **단일 권위 알고리즘 = `pricing.py:evaluate_price` 하나** (시뮬레이터·위젯·주문 동일 호출). 메모리 [[huni-price-quote-harness]]의 "evaluate_price 미구현(round-18)"은 **STALE — 정정됨**(현재 라이브 구현·호출 가능, gate-verdict P1 입증).
2. **차원 = 10개 (8 아님)**: NON_QTY_DIMS 8(siz_cd·plt_siz_cd·print_opt_cd·mat_cd·proc_cd·opt_cd·coat_side_cnt·bdl_qty) + TIER siz_width·siz_height(이하 상한 ceiling) + min_qty(이상 하한). **SOT 3b 상품요소 10차원 = 위 중 min_qty 제외(수량은 주문 입력축).**
3. **도수 = `print_opt_cd`(1431행), `clr_cd`는 dead(0행)** — SOT 3b가 clr_cd를 차원으로 세지 않음 = 폐기 의도 추인. prcx01의 clr_cd는 STALE.
4. **공식 = 항상 구성요소 단순 합산**: `frm_typ_cd`·`addtn_yn` 엔진 미참조(C7). 단가형(.01 장당가×수량)/합가형(.02 구간총액÷min_qty). **합가형 min_qty NULL/0 = 견적 ValueError(C3 위험지점)**.
5. **옵션·추가상품은 가격장치가 아니다**: option_items에 add_price 컬럼 부재 → 옵션=자재/공정 BUNDLE 환원, 가격은 항상 구성요소 사슬. 추가상품=SKU 재귀 evaluate_price 평가(별도 장치). opt_cd near-dead(5행)·CPQ→가격 단절은 결함이 아니라 **설계 정합**(이전 round-7 "결함" 판정 정정).
6. **오적재 근본 = 제약 장치 부재(SOT 4)**: 시트 밖 차원(현수막 별색)이 배선돼도 엔진이 막지 못함. F-3(엔진 무차별 합산)=증상, SOT 4=병인. 배선 레벨 제약 장치는 라이브 부재(CPQ 옵션 제약과 별개).
7. **현재 발화 경로 = FORMULA + 수량구간할인만**: 직접단가·템플릿단가·등급할인 = 라이브 0행(코드만 존재).

## 정답 소스 (구조)

| 항목 | 정답 소스(file:§) | tier | freshness |
|------|-------------------|------|-----------|
| t_prc_* 4단 구조 + 차원(**10차원**/자연키) | **§0a `02_code_schema/code-schema-matrix.md` + §0b `01_engine/engine-contract.md` §3** (1차) · `raw/webadmin/sql/21_pricing_dims.sql`(proc_cd·opt_cd·prc_typ_cd) + `sql/22_use_dims.sql` (보조 DDL) | A | FRESH(§0 신규) |
| 단가유형(prc_typ_cd: 01 단가형=장당가 / 02 합가형=구간총액÷환산) | `sql/21_pricing_dims.sql` + impact-diagnosis I-2·§3 백필(144행 전부 .01) | A | FRESH |
| 가격공식 PK(prd_cd, apply_bgn_ymd) | `sql/18_unify_price_keys.sql`(I-7) | A | FRESH |
| template 직접단가(t_prd_template_prices) | `sql/20_template_prices.sql`(I-4·0행) | A | FRESH(스키마만) |
| use_dims 백필 로직 | `raw/webadmin/tools/init_use_dims.py` | A | FRESH |
| 라이브 적재값(component_prices 3,504행 등) | `00_schema/ref-*.csv`(price 관련) + 라이브 psql 실측 | A | PARTIAL(06-04 스냅샷·신규 차원 컬럼 0행) |

## 정답 소스 (공식 유형 — 후니 권위)

| 공식유형 | 정답 소스 | tier | freshness | 메모 |
|----------|-----------|------|-----------|------|
| 원자합산형(디지털인쇄) PRF_DGP_A~F + 용지비 | `02_mapping/digital-print-engine/` | C | PARTIAL-STALE(I-1·I-2) — 공식사슬 FRESH | 라이브 적재 308행 COMMIT |
| 면적매트릭스형(실사·현수막·아크릴·포스터사인) [세로][가로]+ceiling | `02_mapping/silsa-poster-area-matrix/` + `09_load/_migrate_areamatrix/` + 메모리 dbmap-price-formula-types-authority | C | FRESH | off-grid=한단계 큰 크기 |
| 고정가형(수량×옵션) | `09_load/_migrate_fixedprice/` + `02_mapping/price211-fixedgrid/` | C | FRESH | round-2 28포스터 오모델 교정분 |
| 구간형(수량구간 할인) | `00_schema/discount-domain-detail.md` + `raw/webadmin/tools/load_discounts.py` | A/C | PARTIAL-STALE(I-7 PK) | round-1 t_dsc_* |
| 상품별 공식 PRF_<X>(가격사슬 단절 해소) | `02_mapping/dwire-poster-formula-remodel/`·`dwire-bind-namecard-photocard-remodel/` | C | FRESH | broken 4(포스터/제본/명함/포토카드) |

## 보조 소스

- `05_method/F2-price-sheet-structures.md` — 15 가격시트 구조 카탈로그(블록·축). FRESH.
- `06_extract/price-<slug>-l1.csv` — 가격표 L1 정답값. tier B FRESH.
- `06_extract/pangeori-l1.csv` — 판걸이수=판형 마진 권위. tier B FRESH.
- 메모리: dbmap-round2-price-engine(PARTIAL-STALE I-1·I-2)·dbmap-compute-in-app-db-stores-lookup(판수=앱 계산·박 등급=앱·FRESH)·dbmap-output-plate-mapping(출력판형=판형 매핑·FRESH).

## stale 함정 (인용 금지/주의) — [HARD] writer가 절대 인용하면 안 되는 대상

1. **`00_schema/price-engine-ddl.md` 전체 — STALE.** "6차원/8컬럼 자연키"는 사실 10차원(I-1). 단가형/합가형 개념 전무(I-2). template_prices 누락(I-4). 구 PK(I-7). → 대체: **§0 신규 하네스** + sql/21·22.
2. **★`raw/webadmin/docs/prcx01-pricing-model.md`·`pricing-erd.md` — STALE(델타 강등).** 8차원·`clr_cd`(도수)·`frm_typ_cd`(공식유형) 시절 설계 문서. 신규 하네스 `02_code_schema/design-artifact-trace.md`가 코드 추적으로 **엔진 미참조·라이브 컬럼 부재** 확정. → **구조·차원·단가유형·도수 인용 금지.** 허용 = "왜 두 가지 가격소스(직접단가/공식)를 두나" 같은 **의도 배경 only**(SOT 5 참조). 가격엔진 구조는 §0b `engine-contract.md` + `pricing.py` 직접.
3. **v03 마이그레이션 — 인용 금지 [HARD].** `prdmaster_full_migration_v03_*.xlsx` 계열 산출. 정답=상품마스터 L1(B-L1-PM) > webadmin 적재 oracle. (FORBID-V03)
4. **단가형 가정 함정(I-2).** 우리 모든 단가 매핑이 암묵 "장당가×수량"=단가형. 합가형(구간총액÷min_qty 환산) 상품을 단가형으로 오매핑 위험. **신규 정정:** 라이브 합가형 3건 확정 = `COMP_ACRYL_CLEAR3T`·`COMP_STK_PACK`·`COMP_STK_TATTOO`(engine-contract §4·P4-3). **합가형 단가행 min_qty NULL/0 = 견적 ValueError로 깨짐**(C3 위험지점). 위키는 단가형/합가형을 양면 기술.
5. **round-2 포스터 면적-좌표 오모델(메모리 dbmap-price-formula-types-authority).** 28 포스터를 전부 면적-좌표 회귀로 오모델 → 15개는 고정가형. 교정분(`_migrate_fixedprice/`) 권위.
6. **"evaluate_price 미구현" 진술 — STALE.** 메모리 [[huni-price-quote-harness]] Phase0 표현. **현재 라이브 구현·호출 가능**(gate-verdict P1 입증). 위키에 "미구현"으로 쓰지 말 것.
7. **round-7 "CPQ→가격 단절 결함"·"opt_cd near-dead 결함" 판정 — 정정됨.** 신규 SOT 3a로 **설계 정합**(옵션은 가격축 아닌 자재/공정 환원축)으로 재해석. 결함으로 인용 금지.

## 미해결 GAP

기존:
- 합가형(prc_typ_cd=02) 상품 식별 절차 부재 → **부분 해소**: 라이브 합가형 3 comp 확정(engine-contract §4). 전수 식별은 잔존. [GAP-PE-1]
- 평면화 차원집합 ↔ 라이브 use_dims 대조 절차 미신설(I-3) → **신규 부분 해소**: `03_chain/dimension-mapping-matrix.md`가 파일럿 3상품군 3원 대조. 전수는 잔존. [GAP-PE-2]
- 포토북·디자인캘린더·문구·부자재 가격 미적재(prices 0행). [GAP-PE-3]
- 박: 면적→등급=앱 계산, DB는 등급별 가격만. 박 가격 GAP 잔존. [GAP-PE-4]
- 3절/투명/048/019 등 plate 교정 대기 가격 차단. [GAP-PE-5]

신규(신규 하네스 known-vs-unknown U-1~6·컨펌큐 — 원천 부재 GAP):
- **[GAP-PE-6] 도수 clr_cd→print_opt_cd 폐기가 의도된 설계 변경인가**(prcx01 LOCKED 문서와 충돌·U-1/C-1). 코드는 print_opt_cd, 설계문서는 clr_cd. 최종 의도 문서 부재 → **🔴 사용자/도메인 컨펌 필요**.
- **[GAP-PE-7] 합산형(엽서) 가격사슬 미완성(N-1)**: 골든 엽서 인쇄비 20,000 ≠ 라이브 11,750(gate-verdict P2 FAIL·arbiter N1). 면적매트릭스는 완전 재현·합산형은 NO-GO. 위키는 엽서 가격 "검증 미완"으로 표기.
- **[GAP-PE-8] 수량×단가의 수량 = 출력매수(판수) vs 주문수량 vs BOM소요량**(U-6/C-3). 부자재 10차원 흡수(SOT 6b)의 선결 미지 → **🔴 사용자/도메인 컨펌 필요**.
- **[GAP-PE-9] 배선 레벨 제약 장치 신규 설계 필요(SOT 4)**: 공식↔구성요소 배선이 시트 허용 차원 안인지 강제하는 제약 장치 라이브 부재. 신규 설계 미지(knowledge-map U-신규).
- **[GAP-PE-10] addtn_yn='N'(차감) 행 처리**(U-2/C-2): 엔진 미참조 → 차감 의도 행이 합산되면 과대합산. 필요 시 개발자 백로그(코드 수정), 불필요 시 dead 컬럼.
