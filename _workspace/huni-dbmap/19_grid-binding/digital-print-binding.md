# 디지털인쇄 — 생산형태 × 그릇 × 선택→견적 binding (round-15)

> **작성** 2026-06-13 · round-15. 굿즈파우치 파일럿(`goods-pouch-binding.md`)과 동일한 A~E 구조. 두 번째 시트.
> **목적:** 시트의 각 컬럼이 ① 어떤 생산형태 상품의 ② 어떤 그릇에 담겨 ③ 고객 선택→견적까지 어떻게 이어지는지 + ④ 경쟁사 대조 + ⑤ 현재 고려/GAP을 한 판에.
> **입력 권위(재유도 0·인용):** `15_domain-spec/digital-print/`(mapping-info·column-dictionary·product-bom·domain-research-notes) · `16_mapping-research/digital-print/mapping-final.md`(R12-1~7·M1~M6) · `17_correctness/digital-print/`(product-identity "7상품=실은 36상품"·배경지=포장재 오분류) · `00_schema/schema-design-intent-map.md`(삼중바인딩 ③·OM-1~7·가격공식 4종) · `production-form-grid-matrix.md`(§1.2 진단·§2 원칙·§3 직교) · `accessory-option-research.md`(2축·경쟁사 6그릇) · 가격 소스 = 인쇄상품 가격표 엑셀(디지털인쇄비 시트)·원자합산형([[dbmap-digitalprint-atomic-formula-unbuilt]]).
> **DB 일부 적재(308행 COMMIT) — 매핑/조망 전용, 잔존 적재는 인간 승인.**

---

## A. 상품군 성격 (생산형태 + 정체)

| 항목 | 내용 |
|------|------|
| **도메인 생산형태** | **완제품**(낱장 인쇄 완성품) — 후니가 인쇄·가공해 단일 완성품으로 출고. prd_cd 단위 도메인 판정(`production-form-grid-matrix §1.0`). C 완제품/단일(`mapping-info` 공통·BOM §생산구조). |
| **라이브 `prd_typ_cd` 실측** | **`.04 디자인상품` 위주 + `.01 완제품` 3건 중 1(엽서 대표)** — editor 표시·매입성 혼합 기준이라 도메인 생산형태와 **불일치(라이브 오모델)**. [실측: 디지털인쇄군 = `.01`×일부(명함/엽서/상품권 대표) + `.04`×다수(엽서·명함·배경지·단품형·접지카드·포토카드·인쇄홍보물)]. 라이브 `prd_typ_cd`는 "생산형태"가 아니라 editor 여부 등 혼합 = OM-신규(`§1.0`). editor 상품을 `.04`로 적재하고 `.01 완제품`은 대표 1개만 남긴 결과. |
| **정체** | **36 distinct 상품** · **7 구분(시트 편의 그룹)** = 엽서8·포토카드3·접지카드4·명함10·상품권2·배경지4·인쇄홍보물5. ("7상품"은 7 구분의 오표기 — round-11이 구분별 대표 1상품만 BOM 분석한 것이 누적 전파, `product-identity §0` 정정.) |
| **직교 속성** | **에디터 일부**(`editor_yn` — 포토카드 Y·엽서 N 실측 R12). 디자인 입력 방식 ≠ 생산형태. |
| **공통 인쇄방식** | **디지털 단일**(`PROC_000004` 토너) — 전 36상품. 굿즈파우치의 7혼합과 반대로 균일. 공통 백본 = `디지털출력 → (코팅) → 재단 → 후가공 → 포장`. |
| **MES** | 디지털 5상품 전수 NULL(MES 미연동, `"MES_ITEM_CD"` 대문자 quoted 컬럼·값 NULL 정상, R12-1). |
| **가격 소스** | **인쇄상품 가격표 엑셀(디지털인쇄비 시트)·원자합산형** — 굿즈(상품마스터 내장 고정가)와 다름. `PRF_DGP_A~F` + 용지비 `COMP_PAPER`, siz_cd=**출력판형**(국4절/3절). **라이브 308행 적재됨**([[dbmap-digitalprint-atomic-formula-unbuilt]]). |

> ⚠️ **시트 내 정체 분기:** 36상품 중 **배경지 4종(043~046)은 카테고리 012 "포장" 상품**(배경지 카드+봉투/케이스 세트 또는 라벨/택 단품)으로, round-11/12가 일반 인쇄물로 오분류(`product-identity F-ID-1/2`). 생산형태는 prd_cd 단위 — 대부분 완제품이나 배경지는 **세트성(봉투 동봉)** 보강 필요.

---

## B. 실무진이 준비한 그릇 (스키마 인벤토리)

`§2 매트릭스 완제품 열` 기준, 디지털인쇄에 실제 쓰이는 그릇:

> **실무진 표시용 쉬운 라벨**(`§1.0-b` HARD): 적재 시 `note`/`tags`/admin 라벨에는 개발 코드 대신 아래 "쉬운 라벨"을 푼다. 특히 `PRD_TYPE.04`는 "디자인상품 = 생산형태는 완제품, 단지 에디터로 디자인" 식으로 풀어 실무진 혼동 방지.

| 그릇 (t_*) | 디지털인쇄에서 담는 것 | 엑셀 컬럼 | 실무진 표시용 쉬운 라벨 | 비고 |
|-----------|---------------------|----------|---------------------|------|
| `t_prd_products` | 상품정체·MES·수량(min/max/incr)·qty_unit·업로드/편집기 | C3·C4·C14·C15·C26~29 | "상품"·"수량 단위(매)" / `PRD_TYPE.04`→"디자인상품(에디터로 디자인)" | 멱등키=prd_nm·`"MES_ITEM_CD"` quoted |
| `t_siz_sizes`+`_sizes` | **재단=작업=출력판형 3축 분리**(이산 치수형) | C5/C9(재단)·C8(작업)·C7(블리드 도출) | "재단 사이즈"·"작업 사이즈"·"출력판형" | OM 깨끗(별 컬럼 명시) |
| `t_prd_product_plate_sizes` | **출력판형(전지규격)** = 원자합산형 가격 siz | C10 | "출력판형(전지)" | "316x467"→OUTPUT_PAPER_TYPE.01 |
| `t_mat_materials`+`_materials` | 종이(평량) **usage=USAGE.07 공통**(R12-2·.01 본체 아님) | C16 | "종이(용지)" | `*별도설정`=공통풀 IMPORT |
| `t_prd_product_print_options` | 단/양면 도수(front/back colrcnt) | C17 | "인쇄 도수(단면/양면)" | **별색 제외**(공정) |
| `t_proc_processes`+`_processes` | 별색(007 root)·코팅(013)·완칼(053)·접지(056)·박(033)·형압(050)·모서리(026)·오시(029)·미싱(030)·가변(031/032) | C18~25·C30~37 | "별색인쇄"·"코팅"·"커팅"·"박"·"형압" 등 후가공 | 박색 16종=박 자식 |
| `t_prd_product_addons`+`t_prd_templates` | 봉투류(엽서봉투·OPP·카드봉투·트레싱지) | C38 | "추가상품(봉투)" | tmpl_cd(하이픈 `TMPL-NNNNNN`) |
| `t_prc_price_formulas`+`_price_formulas` | 원자합산 공식 PRF_DGP_A~F + COMP_PAPER 용지비 | C40 | `PRF_DGP_A`→"디지털인쇄비 공식"·`COMP_PAPER`→"용지비" | **라이브 적재**(전역 `price_formulas` 63·디지털 PRF_DGP_*) |
| `t_prd_product_categories` | 시트 구분→판매 카테고리 | C1 | "판매 카테고리" | 배경지 고아노드 296 교정 대기 |
| `t_prd_product_constraints` | ★180g 코팅·★사이즈선택 접지/박 캐스케이드 | (도출 C23/C25/C36/C38) | "선택 제한(무효조합)" | constraint_json |
| `t_prd_product_option_*` (CPQ) | 별색 다중선택·코팅 캐스케이드 | C18~22·C23 | "고객이 고르는 옵션" | OM-6 횡단 미적재(전역 `option_items` 25=엽서7+현수막18) |

→ **그릇은 다 갖춰져 있고 디지털인쇄는 그릇이 가장 잘 맞는 시트**(의미축이 별 컬럼으로 깨끗하게 분리). 문제는 ③선택(CPQ)·④가격 변형 일부가 라이브 미적재(D-1).

---

## C. 선택 → 견적 end-to-end 목표 매핑 (★핵심·원자합산형 가격)

고객이 견적 화면에서 **고르는 순서**대로, 각 선택이 어느 그릇→가격으로 이어지는지:

| 단계 | 고객 선택 | 담기는 그릇 | UI(componentType) | 가격 기여 |
|:--:|----------|-----------|------------------|----------|
| 1 | **상품군/상품** | products+categories | (카탈로그) | 공식 결정(PRF_DGP_*) |
| 2 | **사이즈** (이산 치수) | `sizes`(재단/작업) + `plate_sizes`(출력판형) | `option-button`(≤6)/`select-box` | 출력판형→**판걸이수(앱 임포지션, DB 미저장)** |
| 3 | **종이** | `materials`(usage=USAGE.07 공통) | `select-box`/`image-chip` | **용지비 COMP_PAPER**(원자합산 항) |
| 4 | **인쇄(단/양면 도수)** | `print_options`(front/back colrcnt) | `option-button` | 인쇄비(공식 항) |
| 5 | **별색** (화이트/클리어/핑크/금/은) | `processes`(PROC_000007 root→008~012) + prcs_dtl_opt(면) | `large-color-chip`(택N) | 후가공비(공식 항) |
| 6 | **코팅·후가공** (코팅/커팅/접지/모서리/오시/미싱/가변/박/형압) | `processes` + prcs_dtl_opt(param) | `finish-button` | 후가공비(공식 항) |
| 7 | **추가상품** (봉투) | `addons`+`templates` | (addon 선택) | 추가가격(C39 빈값 GAP) |
| 8 | **수량** | products(min/max/incr·QTY_UNIT.02 매) | `counter-input` | × 수량, − 구간할인(round-1) |
| → | **견적 = Σ(인쇄비 + 용지비 + 후가공비 + 코팅비) ÷ 판걸이수 × 수량 − 구간할인** | `t_prc_price_formulas` PRF_DGP_A~F + `t_prc_component_prices`(COMP_PAPER) | `summary` | ④ 가격 사슬 |

**가격 소스 확정:** 디지털인쇄 가격은 **인쇄상품 가격표 엑셀(디지털인쇄비 시트)의 원자합산형** — 굿즈파우치(상품마스터 내장 고정가)와 근본적으로 다름. 공식 6종 PRF_DGP_A(엽서·상품권)·B(모양엽서·라벨택)·C(배경지·헤더택)·D(전단지)·E(접지카드)·F(썬캡 미출시) + 용지비 COMP_PAPER가 **이미 라이브 적재(디지털인쇄 단가행은 `comp_prices`에 실재 — DIGITAL_S1/S2 등)** — 4레이어 중 ④가격이 부분 완결([[dbmap-digitalprint-atomic-formula-unbuilt]]). **분모=판걸이수는 앱 임포지션 런타임 계산(C6, DB 미저장).** 잔존 차단=3절/투명/박/048(plate 교정 대기).

> **라이브 실측 기준(전역, `production-form-grid-matrix §1.2` 정정 인용):** `option_items` 25행(전역 0 아님) · `comp_prices` 3,481행 · `product_prices` 0(직접 고정가 없음) · `price_formulas` 63 바인딩. 디지털인쇄 가격 단가행은 `comp_prices`에 **실재 적재**(DIGITAL_S1/S2 등). 따라서 E섹션 "라이브 ❌"는 **전역 행수 0이 아니라 "상품군별 공식 바인딩 충족률"**(36상품 중 미바인딩분)을 가리킴.

> **2축 도출 적용(셀 내부):** "별색" → ①BOM축: 공정(PROC_000007 clr_cd=NULL) · ②판매축: option_items 택N(ref_dim_cd=04). "박색" → ①공정(PROC_000033 자식 16종) · ②택1 옵션. 매트릭스 셀이 1차, 2축이 2차. **디지털인쇄는 "색"이 자재 아닌 공정·도수로 깨끗하게 갈림**(OM-1 색=siz 재발 0).

---

## D. 경쟁사 대조 (생산형태=완제품 인쇄물 관점)

| 쟁점 | 경쟁사 패턴 | 후니 정합 | 출처 |
|------|-----------|----------|------|
| 잉크색/별색 | WowPress: 인쇄색=colorinfo(도수)+prsjobinfo, 본체색만 자재 | ✅ 후니 별색=공정(PROC_000007)·도수=print_options 분리(OM-5) | `accessory-option-research` §3 Q3 |
| 후가공(코팅·박) | WowPress awkjob / 실무진 Q2·Q9=공정 | ✅ 후니 코팅/박=공정(PROC_000013/033) | 〃 §3 결정표 |
| 공정 파라미터(커팅 형상·박 크기·오시 줄수) | 표준은 param 보존(SKU 폭증 회피) | 🟡 prcs_dtl_opt 보존, `ref_param_json` 미구현(OM-7/GAP-2) | 〃 §6 GAP-2 |
| 봉투(기성+추가 이중) | Lasso: 물리 SKU 1, 판매 listing 2 | base PRD + `t_prd_templates` 참조(카드봉투 OM-1) | 〃 §4 Q5 |
| 무효조합(★180g 코팅) | rule + 가격엔진 판정(enumerate 금지) | constraint_json/JSONLogic 캐스케이드 | 〃 §1.1-4 |

→ **후니 그릇이 경쟁사 표현력 흡수**(답습 불요). 디지털인쇄 특화: 의미축이 이미 별 컬럼으로 깨끗해 **변형 폭증 위험이 가장 낮은 시트**(별색/도수, 재단/작업/출력판형 명시 분리). 실 GAP은 횡단 2건(line item property 각인텍스트=GAP-1 — 디지털인쇄엔 가변데이터 VDP가 유사·공정으로 보유 / ref_param_json=GAP-2)뿐.

---

## E. 현재 고려 여부 + GAP (사슬 끊긴 곳)

| 레이어 | 상태 | GAP/조치 |
|--------|------|---------|
| ①골격 | ✅ 적재(products 36·categories 36) | 배경지 고아노드 296→273/274/275/283 재연결(F-ID-3) |
| ②차원그릇 | 🟡 부분(sizes 33/36·materials 35/36·processes 23/36) | D-1 변형 미적재(엽서 사이즈 13종 중 7·별색/코팅/커팅 마스터 실재·상품연결 미적재) |
| **③선택(CPQ)** | ❌ **디지털인쇄 상품군 미적재**(전역 `option_items` 25행은 엽서7+현수막18 — 전역 0 아님) | option_groups→options→option_items 적재(round-6) — 별색 택N·코팅 캐스케이드. **사슬 끊긴 핵심**(디지털인쇄군 옵션 레이어 미흡) |
| **④가격** | 🟡 **상품군별 공식 바인딩 충족률 부분**(디지털 단가행은 `comp_prices`에 실재 적재) | 전역 `comp_prices` 3,481·`price_formulas` 63 적재됨 — ❌는 행수 0 아닌 36상품 중 미바인딩분. 잔존 차단=3절/투명/박/048 plate 교정 |

**잔존 컨펌(인간 결정·`domain-research-notes`·`mapping-final §5`):**
- 🔴 DP-A(=Q-DP-A) C39 봉투 추가가격 — 디지털인쇄 시트 전부 빈값. template 추가가격(미구현 GAP·ddl-proposer) vs base_prd 흡수 vs 합산 안 함.
- 🔴 DP-B(=Q-DP-B·CONFLICT-1) C38 tmpl_cd separator — 라이브 하이픈(`TMPL-000005`) vs 코드전략 `_` 통일. 기존 유지 vs 마이그레이션.
- 🔴 DP-C(=Q-ID-A) 배경지 봉투 세트 귀속 — `sets`(배경지+봉투 사이즈매칭) vs `addons`(tmpl_cd 엽서동형) vs CPQ 옵션. 사이트는 "세트" 판매.
- 🟡 DP-D 배경지 4종 카테고리 296 고아 재연결(F-ID-3·search-before-mint).
- 🟡 DP-E 배경지 전용 커팅 형상 18종(타공형/핀고정형/스마트톡형) prcs_dtl_opt 도메인 의미.

> **횡단 수렴:** DP-1~5 round-11 컨펌은 라이브 실측으로 **전부 RESOLVED**(박칼라=공정 R12-5·파일명/폴더=Q1 견적제외·블리드=Q14 도출·별색 family R12-6·건수=QTY_UNIT.02 R12-3). 잔존 DP-A/B는 **template 가격·코드전략 횡단 결정**, DP-C/D/E는 **배경지 정체(포장세트) 교정**으로 수렴 — 디지털인쇄 고유 케이스 컨펌이 아니라 **횡단 원칙(§2 매트릭스 #8 추가상품성·#10 가격·#3 카테고리)** 으로 환원됨. round-15 목표(케이스→원칙 치환) 입증.

---

## 한 줄 현황

**파일럿 2번째 GO 대기:** 디지털인쇄를 A(도메인 생산형태=완제품 / 라이브 `prd_typ_cd`=.04 위주+.01 1건=오모델 병기·36상품/7구분·디지털 균일·배경지 포장세트 분기)·B(그릇 11종+실무진 쉬운 라벨, 의미축 가장 깨끗)·C(선택→견적 8단계·가격=인쇄상품 가격표 원자합산형 PRF_DGP_A~F+COMP_PAPER **`comp_prices`에 실재 적재**·판걸이수=앱계산)·D(경쟁사 흡수·별색/도수/박색 깨끗 분리)·E(③디지털인쇄군 CPQ 미적재[전역 opt_items 25=엽서/현수막]·④상품군 공식 바인딩 충족률 부분·DP-A~E). **가격 소스 규명: 인쇄상품 가격표 엑셀(굿즈=상품마스터 내장과 대비)·라이브 단가행 광범위 적재.** **라이브 ❌=전역 0 아닌 상품군별 충족률**(`§1.2` 정정). **DB 일부 적재, 잔존은 인간 승인.**
