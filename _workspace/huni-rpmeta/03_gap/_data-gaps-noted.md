# 데이터 갭 노트 (범위 외 — dbmap 라우팅)

> rpm-gap-analyst. **그릇은 존재하나 데이터가 미적재/오염된 축** — 본 RP-Meta 하네스(vessel 설계) **범위 외**.
> huni-dbmap 적재/교정 트랙으로 라우팅. vessel-gap과 명확히 구분(스키마 표현력 OK = 여기, 표현력 부재 = `vessel-needs.md`).
> [HARD] "테이블 있고 비어있음"·"행 잘못 채움" = data-gap. 그릇 신설 아님.
> **버전:** v1.0(BN §1~§3 보존) + v2.0(GS §4 굿즈 data-gap·라이브 2026-06-17 실측) + v3.0(TP §6 디자인 입력 data-gap·라이브 2026-06-17) + v4.0(PR §7 책자/다면 data-gap·라이브 2026-06-17) + v7.0(AC §8 아크릴 가격사슬/CPQ data-gap·라이브 + dbmap 31_acrylic 대조 2026-06-17) + v8.0(PD §9 완제 구조물 내재BOM data-gap·라이브 2026-06-17) + **v9.0(PH §10 거치 캐스케이드/완제 액자 SKU/다중분류 data-gap·★directive 최대 관전·라이브 2026-06-17)**.

---

## 1. 라이브 적재로 이미 닫힌 data-gap (2026-06-17 실측 — 스냅샷 대비 정정)

스냅샷(`00_schema/`, round-22 이전)이 "0행/미적재"로 본 것이 라이브에선 적재됨. **이미 닫힌 갭 — 재라우팅 불요:**

| 축/테이블 | 스냅샷 | 라이브 | 상태 |
|---|---:|---:|---|
| `t_prd_product_option_items` | 0 | **469** | ✅ 닫힘 (round-7 "전역 0행" 진단 stale) |
| `t_prd_product_option_groups` | 13 | **134** | ✅ 닫힘 |
| `t_prd_product_options` | 0 | **494** | ✅ 닫힘 |
| `t_prd_product_constraints` | 0 | **10** | 🟡 부분(아래 §2) |
| `t_prd_template_selections` | 0 | **14** | 🟡 부분(아래 §2) |
| `t_prc_price_formulas` | 0 | **17** | ✅ 닫힘 |
| `t_prc_component_prices` | 0 | **3,416** | ✅ 닫힘 |
| `t_cat_categories` 고아 | 14노드/113상품 | **0** | ✅ 닫힘 (round-22 ⑥ DELETE 111) |

→ **하네스 입력 정정:** rpm-metamodel·gap 판정은 라이브를 권위로. round-7/round-22 stale 진단 인용 시 주의.

---

## 2. 잔존 data-gap (부분 적재 — dbmap 적재 트랙)

| 축/테이블 | 라이브 | 갭 | dbmap 라우팅 |
|---|---:|---|---|
| `t_prd_product_constraints` | 10행 | 교차 제약 JSONLogic 룰 대부분 미투입(설계 검증분 미적재) | `dbmap-cpq-option-mapping`·round-6 |
| `t_prd_template_selections` | 14행 | 적재된 templates 12행의 구성 내용 부분만 | `cpq-schema §5`·round-6 |
| `t_prd_products.constraint_json` | non-null 0 | compile 캐시 미생성 | 가격/제약 엔진 배포 시 |
| 가격 사슬 배선 | formula 17·comp_prices 3,416 | **단가행 존재≠배선 완결**(round-16/21 가격사슬 단절·212/275 상품 가격원천0) | `dbmap-price-chain-dwire`·가격 트랙 |

---

## 3. data 오염 (행 잘못 채움 — dbmap 교정 트랙, vessel 아님)

그릇은 표현력 충분, **행이 잘못된 축에 들어감** = 교정(UPDATE/축이동) 대상. vessel 신설 아님.

| 오염 | 라이브 실측 | 정답(dbmap) | 라우팅 |
|---|---|---|---|
| 자재 오염 | `MAT_TYPE.09`(파우치) 69행이 색(검정/노랑)·형상(사각/원형/하트)·인쇄면(단면/양면/배면만 인쇄)·구수(1구/2구)·사이즈(100mm/11인치) 보유. `.08`(실사) 17·`.10`(악세사리) 43 동형 | 색→CPQ option·형상→siz·구수→bundle·인쇄면→print_side | round-22 ④자재 **B-3 설계 GO·라이브 적용 0** (`dbmap-axis-staged-load-round22`) |
| 생산형태 오모델 | `prd_typ_cd`(PRD_TYPE.01~04) | prd_typ_cd≠생산형태(굿즈/문구=.03 기성 등 오귀속) | `dbmap-grid-binding-round15` |

> ※ 자재 ①은 **양면**: 분해축 *그릇* 부재(=`vessel-needs.md` V-3) + 행 오염(=여기 §3). vessel은 V-3, data 교정은 round-22 B-3. 중복 계상 안 함.

---

## 4. ★굿즈(GS) data-gap — 라이브 실측 2026-06-17 (v2.0)

GS 정밀 실측이 드러낸 굿즈 전용 data-gap. **그릇은 있고 굿즈가 미적재/미생성** = dbmap 라우팅(vessel 아님).

| 굿즈 data-gap | 라이브 실측 | 상태 | dbmap 라우팅 |
|---|---|---|---|
| **굿즈 CPQ 옵션 레이어** | `PRD_TYPE.03`(기성=굿즈) 124상품 중 **option_groups 보유 = 2상품뿐**. 134 option_groups는 디지털/스티커 등 타군에. | **data-gap**(CPQ 그릇 PASS·굿즈 미적재) | round-6 CPQ·`dbmap-tierA-cpq-option-load`(현수막/합판 제외 35상품 설계분)·굿즈 확대 |
| **완제 SKU 개당가** | `t_prd_template_prices`(tmpl_cd·apply_ymd·unit_price) **0행**. 텀블러 45000·장패드 10000 등 tmpl/vTmpl 개당가 미적재. | **data-gap**(가격 그릇 발견·미적재) | 가격 트랙·round-16 가격 import. **★vessel 아님(BN ④ WEAK 정정)** |
| **굿즈 본체소재 행(미생성)** | 레더/린넨/아크릴 코스터=본체소재 행 있음(round-22 41 COMMIT) / **우드·코르크·규조토 코스터=본체소재 행 0**(형상행만). | **data-gap**(소재 행 미생성·신규 mint 필요) | round-22 GPM-4·BLOCKED 신규mint(우드/규조토/코르크/벨벳·`ddl-proposer`) |
| **tiered 가격(구간)** | GSTGMIC tiered_price = 수량구간. `t_dsc_*`(round-1 구간할인) 그릇 존재. 굿즈 tiered 미적재. | **data-gap** | round-1 구간할인·가격 트랙 |

> ★굿즈 본체자재 3분류(사용자 질의 직답): ① 본체소재 *링크 그릇*=PASS(있음) ② *분해축 컬럼*=**vessel-gap**(`vessel-needs.md` V-3, 본 하네스 산출) ③ *미적재 소재 행·CPQ·개당가*=**data-gap**(위 표·dbmap). 오염(.09/.10 형상/색/구수)=**data 오염**(§3 B-3).

---

## 6. ★TP 디자인 입력 data-gap — 라이브 실측 2026-06-17 (v3.0)

> ★주의: TP의 핵심(#16 디자인 입력 채널)은 **vessel-gap**(`vessel-needs.md` V-10) — 그릇 자체 부재라 data-gap 아님. 아래는 *그릇은 있으나 TP 관련 데이터가 미적재*인 항목만(vessel-gap V-10/V-11과 명확 구분).

| TP data-gap | 라이브 실측 | 상태 | dbmap 라우팅 |
|---|---|---|---|
| **완제SKU 개당가(TP 완제)** | `t_prd_template_prices`(tmpl_cd·apply_ymd·unit_price) **0행**. TP 완제 템플릿(봉투류 등) 개당가 미적재. | **data-gap**(가격 그릇 존재·미적재·GS와 동일) | 가격 트랙·round-16. ★vessel 아님 |
| **템플릿 구성(template_selections)** | `t_prd_template_selections` 14행 = 적재 templates 12행 구성 부분만. 봉투 OTC 구성만·TP 완제 구성 확대 미적재 | **data-gap** | round-6·`cpq-schema §5` |
| **페이지룰(캘린더 월수·북 대수)** | `t_prd_product_page_rules` 11행 — 캘린더/북 INN_PAGE(월수/대수·min/max/step) 적재 일부만(TP 23상품 대비 희소) | **data-gap**(page_rules 그릇 PASS·TP 미적재) | round-6·수량모델 트랙 |
| **에디터 사용 플래그(editor_yn)** | editor_yn=Y 107상품 적재됨(불리언). | **적재됨(불리언 한계)** — 단 *어느 에디터·리소스·VDP*는 그릇 부재(vessel-gap V-10). editor_yn 자체는 data 존재. | — (불리언은 적재·세부는 V-10 vessel) |

> ★TP 핵심 구분(directive): **#16 디자인 입력 채널 = vessel-gap(V-10·그릇 부재)** — `editor_yn` 불리언은 적재됐으나 RP item_gbn/에디터종류/리소스ID/VDP를 담을 그릇이 없음 = data 문제 아님. 위 §6 표는 *그릇 있는데 미적재*(개당가·구성·page_rules)만 data-gap으로 분리. **혼동 금지: 디자인 입력 채널 갭은 dbmap 적재로 안 닫힘(vessel 설계 선결).**

---

## 7. ★PR 책자/다면 data-gap — 라이브 실측 2026-06-17 (v4.0)

> PR facet 6항 중 PASS 4건(표지/내지 usage·접지/제본 공정·page_rule·면지 bundle)은 **그릇 PASS** — 일부는 breadth가 미적재(data-gap). vessel-gap 아님(그릇 표현력 OK). WEAK/GAP 2건(digital_price·인쇄방식 게이팅)은 기존 #11/#12 = vessel 영역(여기 아님).

| PR data-gap | 라이브 실측 | 상태 | dbmap 라우팅 |
|---|---|---|---|
| **책자 표지/내지 인쇄비 component** | `price_components`에 `COMP_BIND_*` 제본비 11행은 적재·**표지인쇄비/내지인쇄비 명명 component 행 0**(book2025 책자 가격 미적재). cover/inner 분리 그릇(comp_cd 무한 분리·use_dims)은 PASS. | **data-gap**(가격 component 그릇 PASS·책자 cover/inner 행 미적재) | 가격 트랙·round-16·`dbmap-price-chain-dwire` |
| **책자/캘린더 page_rule breadth** | `t_prd_product_page_rules` 11행 — PR 책자(19상품)+TP 캘린더 대비 희소(INN_PAGE min/max/incr 적재 일부만). 그릇(page_min/max/incr) PASS. | **data-gap**(page_rule 그릇 PASS·다면 상품 미적재) | round-6·수량모델 트랙 |
| **접지/제본 공정 product-link** | 공정 행(접지 19·제본 9·오시 2)은 실재 — `t_prd_product_processes` PR 책자/리플렛 링크 breadth는 별도 적재(book2025 책자 옵션 레이어) | **data-gap**(공정 행 PASS·PR 상품 link 부분) | round-6 CPQ·가격 트랙 |
| **면지 자재 link breadth** | USAGE.03 면지 15행(MAT_000001~004) 적재 — PR 책자 면지 옵션 link 일부(PRD_000072/077/082 등). 그릇 PASS. | **data-gap**(면지 자재행 PASS·PR 책자 link 부분) | round-6·round-22 자재 트랙 |

> ★PR 핵심 구분(directive): PR facet 6건 = **PASS 4(그릇 보유·일부 breadth data-gap=위 §7)·WEAK 1(digital_price=#11 vessel V-7)·GAP 1(인쇄방식 자재풀 게이팅=#12 vessel V-2)**. **신규 vessel-gap 0**(distinct 신축 0). 위 §7은 *그릇 있는데 PR 상품 미적재*만 = dbmap. **혼동 금지: PR이 새로 연 갭 = 없음**(WEAK/GAP 2건은 기존 BN #11·#12 재확인·dbmap 가격/인쇄방식 트랙 아닌 vessel V-2/V-7).

---

## 8. ★AC 아크릴 가격사슬/CPQ data-gap — 라이브 + dbmap 31_acrylic 대조 2026-06-17 (v7.0)

> AC facet 6항 중 PASS 2(받침 부속물·인쇄면/화이트)·WEAK 4(두께·surface-finish·부자재 횡단공유·acrylic2025)는 vessel 영역(기존 §I-1/§III-11·V-3/V-7). 아래는 **dbmap 31_acrylic가 명시한 가격사슬/CPQ data·가격 결함** — 본 RP-Meta 하네스 범위 외(가격/적재 트랙). 그릇은 있고 데이터/배선이 미완·미정.

| AC data-gap | 라이브 실측 + dbmap 31_acrylic | 상태 | dbmap 라우팅 |
|---|---|---|---|
| **acrylic2025 prc_typ .02 정합(Q-ACR-7)** | CLEAR3T prc_typ `PRICE_TYPE.02`·use_dims `["siz_cd","mat_cd","min_qty"]`·84행 라이브 확증. 면적 개당단가는 단가형(.01) 원칙인데 .02(합가형) — 엔진 evaluate_price가 .02를 수량 곱하나 총액으로 보나 미확정(돈-크리티컬·엔진 미구현이라 실청구 0) | **data/가격 결함**(가격 그릇 PASS·계산법 미확정) | `dbmap-acrylic-price-chain-link` Q-ACR-7·webadmin Phase11 엔진 |
| **미러/코롯토/카라비너 가격공식 미신설** | `PRF_CLR_ACRYL`(투명) 1행만·MIRROR3T(37행)/코롯토(0행)/카라비너(0행) 공식·배선·바인딩 전무(GAP-CHAIN-MIRROR/COROTTO/CARABINER) | **data-gap**(가격 그릇 PASS·소재계열별 공식 미적재) | `dbmap-acrylic-price-chain-link` GAP-CHAIN·round-2/16 가격 트랙 |
| **아크릴 22상품 미바인딩** | PRD_000146(키링)만 PRF_CLR_ACRYL 바인딩·나머지 22 아크릴 상품 product_price_formulas 0(GAP-BIND-22) | **data-gap**(바인딩 그릇 PASS·미적재) | `dbmap-acrylic-price-chain-link` GAP-BIND-22·round-5 적재 |
| **아크릴 CPQ 옵션 레이어 전무** | 아크릴 23상품 option_groups/options/items 0(GAP-CPQ-ZERO·사이즈/자재/후가공/도수 미노출) | **data-gap**(CPQ 그릇 PASS·굿즈 §4와 동형 미적재) | round-6 `dbm-option-mapper`·`dbmap-cpq-option-mapping` |
| **후가공 추가단가 comp** | 고리/자석/받침 후가공 추가단가(은색고리1100·금색1200·1구자석1000) comp(`COMP_ACRYL_FINISH`) 부재(GAP-FINISH-COMP·Q-ACR-1 opt_cd 연결 미확정) | **data-gap**(가격 그릇 PASS·후가공 comp 미적재) | `dbmap-acrylic-price-chain-link` GAP-FINISH-COMP·round-16/6 |
| **부자재 버킷 분산/중복(D링 3중복)** | 고리/받침/자석/와이어링이 MAT_TYPE.04/.07/.10/.02 분산·D링 .02/.04/.07 3중복 행 | **data 오염/중복**(버킷 오라벨·행 중복) | round-22 ④자재·단일 부자재 마스터 통합(V-3 버킷 재정의 선결) |

> ★AC 핵심 구분(directive): AC facet 6건 = **PASS 2(받침=addon·화이트=PROC_000008 그릇 보유·조치 0)·WEAK 4(두께·surface-finish·부자재 횡단공유=#1 V-3·acrylic2025=#11 V-7)**. **신규 vessel-gap 0**(가공방식 그룹핑 #18 부결·distinct 신축 0). 위 §8은 *그릇 있는데 가격사슬/CPQ 미완·미정*만 = dbmap 31_acrylic Q-ACR/GAP-ID 라우팅. **혼동 금지: AC가 새로 연 vessel-gap = 없음**(WEAK 4건은 기존 #1·#11 재확인·dbmap 가격 트랙 또는 V-3/V-7 vessel). ★dbmap 31_acrylic 라이브 산출과 본 갭분석 **구조 동형 확증**(CLEAR3T mat_cd 통합=두께 자재차원·MIRROR3T 별 comp=소재계열 가격엔진#11·화이트=공정·받침=부속물) — RP 메타모델 vs 후니 실적재 정합.

---

## 9. ★PD 완제 구조물 내재BOM data-gap — 라이브 실측 2026-06-17 (v8.0·directive 핵심)

> ★directive 핵심 판정: PD-4 완제 구조물 내재BOM(다리/받침/논슬립·솜/지퍼)은 **data-gap이지 vessel-gap 아님** — metamodel 예측을 라이브 실측이 확정. 그릇(부속물#8·자재 usage)은 실재하고, RP가 마케팅 카피로만 둔 *데이터를 미적재*한 것. 본 RP-Meta 하네스(vessel 설계) **범위 외** — dbmap 적재 트랙. PD facet 5항 중 GAP 1(봉제=#14)·WEAK 2(직물/밑창=#1)는 vessel 영역(기존 §V-14·§I-1·V-8/V-3·여기 아님).

| PD data-gap | 라이브 실측 | 상태 | dbmap 라우팅 |
|---|---|---|---|
| **★완제 구조물 내재BOM(다리/받침/논슬립)** | `t_prd_product_addons`(prd_cd·tmpl_cd·disp_seq·note·FK→products/templates) **그릇 실재**(addon→template SKU·BN 거치대 D-1·AC 받침 동형·#8 부속물 PASS) — 스툴 다리/계단 받침/논슬립 패드 = 완제 부속 **미적재**(RP는 [live:SSR-marketing] 카피로만) | **data-gap**(부속물#8 그릇 PASS·내재BOM 미적재·축 부재 아님) | round-22 GPM-4·굿즈 본체 BOM·`dbm-ddl-proposer`(신규 부속 mint 필요 시)·완제 구조물 취급 시 |
| **★솜 충전/지퍼/논슬립 원단(sub_mtrl)** | `t_prd_product_materials.usage_cd .07 공통`(639행 적재 중) **슬롯 실재** — 솜/지퍼/논슬립 원단 = 본체 결합 sub_mtrl 담을 usage 슬롯 보유(USAGE enum 7종)·PD 봉제 구조물 솜/지퍼 **미적재** | **data-gap**(자재 usage 슬롯 PASS·sub_mtrl 미적재) | round-22 ④자재·굿즈 본체 BOM·자재 트랙 |
| **밑창 sole 자재코드(SLB*/SLW* 12-variant)** | SUB_MTR 밑창색×사이즈 12-variant(SLB01~06 검정·SLW01~06 흰색·MTRL_COD SBSLP/SWSLP230~280)·`t_mat_materials`+usage 또는 addon→tmpl_cd 그릇 보유 — 밑창 sole 자재행·2D 페어링(`option_items.ref_key1/ref_key2`) **미적재** | **data-gap**(자재/부속물 그릇 PASS·밑창 variant 미적재) | round-22 ④자재·round-6 CPQ(2D 페어링)·reverse SUB_MTR 정정본 검증 후 |
| **PD CPQ 옵션 레이어·완제 개당가** | PD 3상품(스툴/슬리퍼/계단) `price_gbn=tmpl_price`(완제 템플릿)·`t_prd_template_prices`(0행) 개당가·option_groups 미적재(굿즈 §4 동형) | **data-gap**(CPQ·가격 그릇 PASS·PD 미적재) | round-6 CPQ·가격 트랙·`t_prd_template_prices` |

> ★PD 핵심 구분(directive 직답): PD facet 5건 = **PASS 1(단수/형상=#13 사이즈 1:1 흡수·조치 0)·WEAK 2(직물/PU=#1 V-3·밑창 SUB_MTR=#8/#1 V-3)·GAP 1(봉제/제품가공=#14 V-8)·★data-gap 1(완제 내재BOM=위 §9)**. **신규 vessel-gap 0**(완제 구조물 내재BOM #18 부결·distinct 신축 0). 위 §9는 *그릇 있는데 PD 내재BOM/sub_mtrl/밑창/CPQ 미적재*만 = dbmap. **★혼동 금지: PD-4 완제 구조물 내재BOM은 data-gap(부속물#8 addon→tmpl_cd 그릇·usage_cd .07 슬롯 실재·후니 KB addl_product/usage/생산방식 1급 모델링) — ST 형상(KB G-SK-2 "어느 축에도 없음" vessel-gap)과 정반대.** 후니가 완제 구조물(스툴/슬리퍼/반려동물용품) 취급 시 = 기존 부속물#8·자재 usage 그릇 채우기(새 그릇 신설 불요). ★directive metamodel 예측(data-gap) 라이브 실측 확정(그릇 3-레벨 실재: addons 테이블·usage_cd .07 639행·USAGE enum 7종).

---

## 10. ★PH 거치 캐스케이드/완제 액자 SKU/다중분류 data-gap — 라이브 실측 2026-06-17 (v9.0·directive 최대 관전)

> ★directive 최대 관전 판정: PH-1/PH-2 완제 액자 프레임(인쇄물 사후 끼우는 2-파트 빈 그릇)·마운팅/거치(탁상용/벽걸이)는 **data-gap이지 vessel-gap 아님** — §0.5 client-render 재캡처로 거치 OBSERVED(미싱데이터 실재)했으나, 옵션#3 캐스케이드 상위 차원 + 완제SKU#4 variant로 무손실 구현. 그릇(옵션#3·제약#5·완제SKU#4·자재#1 프레임재질)은 실재하고, RP가 적재해야 할 *데이터를 미적재*한 것. 본 RP-Meta 하네스(vessel 설계) **범위 외** — dbmap CPQ 옵션레이어/적재 트랙. PH facet 6항 중 WEAK 3(완제 액자 SKU=#4·인화지×마감=#1·set 단위=#10)은 vessel 영역(기존 §I-1·§I-4·§III-10·V-3/V-11·여기 아님).

| PH data-gap | 라이브 실측 | 상태 | dbmap 라우팅 |
|---|---|---|---|
| **★거치방식(탁상용/벽걸이) 캐스케이드** | `t_prd_product_option_groups`(SEL_TYPE.01 택1·134행)→`t_prd_product_option_items`(469행·OPT_REF_DIM polymorphic)→`t_prd_product_constraints.logic` jsonb(10행·JSONLogic) **그릇 실재**(AC 명찰 cascade·ST disable·BN 어깨띠 §I-5 PASS 동형) — 거치→마감→사이즈 풀 교체 cascade(§0.5 OBSERVED) **미적재**(액자 11종 옵션레이어 미적재) | **data-gap**(옵션#3/제약#5 그릇 PASS·거치 cascade 미적재·축 부재 아님) | round-6 CPQ 옵션레이어·`dbm-cpq-option-mapping`(거치=옵션 택1→cascade constraints.logic) |
| **★완제 액자 SKU(거치+마감+사이즈 인코딩)** | `t_prd_templates`(tmpl_cd·base_prd_cd·dflt_qty·tags·**12행**)+`t_prd_template_selections`(14행) **그릇 실재**(AC 두께/소재 variant·GS 완제SKU §I-4 동형) — 거치×마감×사이즈 조합 폭(combobox 완제 SKU breadth) **미적재** | **data-gap**(완제SKU#4 그릇 PASS·액자 SKU breadth 미적재) | round-6 CPQ template_selections·`dbm-tierA-cpq-option-load`·완제 액자 취급 시 |
| **인화지×마감 surface-finish 합성** | `t_mat_materials`(mat_cd·mat_nm·...) — surface/finish/glitter 컬럼 0건(mat_nm 융합·WEAK·V-3) — 인화지(캐논전용지/스노우/홀로그램)×마감(유광/반광) 자재행 **미적재**(PHPTPRM 외) | **data-gap**(자재 그릇 보유·인화지 매체행 미적재)·*분해축은 vessel V-3* | round-22 ④자재·`dbm-material-option-normalization`(surface_finish 합성 차원) |
| **PHMG/PHPO 다중분류(출력매체 PH ⊥ 컵&홀더)** | `t_prd_product_categories`(PK=(prd_cd,cat_cd)·`main_cat_yn`)·2카테고리 8상품 **라이브 실재** — PHMG/PHPO를 PH + 컵&홀더 다중분류 행 적재 = **정책 결정**(GS G-2 코스터 동형) | **정책 결정**(다중분류 그릇 PASS·귀속 정책·메타모델/vessel 판정 아님) | round-22 ⑥카테고리 다중분류·실무 정책 |
| **set 단위(600매/4sheets/5sheets)·포토북 제본** | `t_prd_product_bundle_qtys`(28행)+`qty_unit_typ_cd` 그릇 보유·포토북 제본=#14(PR 책자 동형·`PROC` 제본행) — set base_quant·포토북 면수/제본 **미적재** | **data-gap**(수량/공정 그릇 보유·미적재)·*제본 GAP은 #14 vessel* | round-22 ②사이즈/기초코드·#14 본체형태가공(제본=PR 책자 동형) |

> ★PH 핵심 구분(directive 최대 관전 직답): PH facet 6건 = **PASS 3(거치 캐스케이드=옵션#3/제약#5·형태 비율=#13·다중분류=#7·조치 0[그릇 PASS])·WEAK 3(완제 액자 SKU=#4 V-11·인화지×마감=#1 V-3·set 단위=#10)**. **신규 vessel-gap 0**(완제 액자 그릇/마운팅 #18 부결·distinct 신축 0). 위 §10은 *그릇 있는데 PH 거치 cascade/완제 액자 SKU breadth/인화지 매체행/다중분류/set 미적재*만 = dbmap. **★혼동 금지: PH-1/PH-2 완제 액자/거치 마운팅(directive 최대 관전)은 data-gap/facet(옵션#3 option_groups 134/items 469 그릇·제약#5 constraints.logic 10행·완제SKU#4 templates 12/selections 14 실재·후니 KB 옵션/완제SKU/자재 1급 모델링) — ST 형상(KB G-SK-2 "어느 축에도 없음" vessel-gap)과 정반대.** 거치(탁상용/벽걸이)=§0.5 OBSERVED(전용 슬롯 ✅)·후니 KB 결함 없음(❌·옵션 일반 cascade 무왜곡 표현)=둘 중 ①만 충족→distinct #18 부결(ST 형상은 둘 다 충족→승격·결정적 분기). 후니가 액자(완제 출력매체) 취급 시 = 기존 옵션#3/완제SKU#4/자재#1 그릇 채우기(새 그릇 신설 불요). ★directive metamodel 예측(distinct 0·facet/data-gap) 라이브 실측 확정(그릇 실재: option_groups 134·constraints.logic 10·templates 12·다중분류 2카테고리 8상품).

---

## 11. ★FS 타일링/면직물 자재/완제 부자재 data-gap — 라이브 실측 2026-06-19 (v10.0·directive 1순위)

> ★directive 1순위 판정: FS-1 타일링(TILL_WH_GBN 없음/세로/가로)은 **data-gap이지 vessel-gap 아님** — 전 9 카테고리 미관측 전용 라디오 슬롯이 5상품 전수 OBSERVED(승격 ① 충족)되었으나, 공정#2 인쇄 배치 파라미터#9(`prcs_dtl_opt` jsonb)로 무손실 흡수(후니 KB 결함 부재·승격 ② 불충족). 그릇(공정 파라미터 jsonb·봉제/별색 공정 행·addons·MAT_TYPE.09)은 실재하고, RP가 적재해야 할 *데이터를 미적재*한 것. 본 RP-Meta 하네스(vessel 설계) **범위 외** — dbmap round-22 ③공정/④자재 트랙. FS facet 8항 중 WEAK 3(면직물 measure_type=#1·봉제/제품가공=#14·가격모델=#11)은 vessel 영역(기존 §I-1·§V-14·§XI·V-3/V-8·여기 아님).

| FS data-gap | 라이브 실측 | 상태 | dbmap 라우팅 |
|---|---|---|---|
| **★타일링(TILL_WH_GBN 없음/세로/가로)** | `t_proc_processes.prcs_dtl_opt` jsonb **라이브 활성**(오시 줄수·미싱 줄수·코팅 면 enum·제본 방향·박 크기) — 타일링(없음/세로/가로)=`{"key":"타일링","type":"enum","values":[...]}` 무손실 적재 가능 그릇 실재 — 직물 풀프린팅 반복 배치 선택 **미적재** | **data-gap**(공정#2 #9 그릇 PASS·반복배치 enum 미적재·축 부재 아님) | round-22 ③도수/공정·공정 파라미터 jsonb 적재·`dbmap-compute-in-app-db-stores-lookup`(타일링=입력 등재·판걸이수=앱계산 등재 금지 경계) |
| **★완제 부자재(솜 TN001/끈/자석/라벨/포켓)** | `t_prd_product_addons`(prd_cd·tmpl_cd·disp_seq) **그릇 실재**(PD-4 내재BOM·AC 받침 동형·#8)·**MAT_TYPE.09 봉제부자재 버킷 실재**(자재행 0건)=솜/끈/라벨/자석 자재 귀속처·선택형 노출(솜 선택안함)=옵션#3 택1 — 솜/끈/자석 자재행·addon 행·옵션 선택 노출 **미적재** | **data-gap**(자재#1 MAT_TYPE.09·부속물#8 addons·옵션#3 선택 노출 그릇 PASS·미적재·축 부재 아님) | round-22 ④자재(MAT_TYPE.09 솜/끈/라벨/자석 행)·GPM-4(완제 부속 적재)·round-6 CPQ(선택형 부자재 옵션 노출 view_yn=Y) |
| **면직물 본체 자재(면사 수 PXFBW0NN)** | `t_mat_materials`(weight/depth numeric 컬럼 실재하나 measure_type 판별자 0건·면사 수 mat_nm 융합)·MAT_TYPE에 직물 PTT 본체 버킷 부재 — 면10/20/40/60수 화이트 본체 자재행 **미적재**(round-22 굿즈 본체소재 부재 결함 동근) | **data-gap**(자재 그릇 보유·면직물 본체 행 미적재)·*measure_type 분해축은 vessel V-3* | round-22 ④자재·`dbm-material-option-normalization`(measure_type 평량/두께/oz/번수 구분·V-3 합류) |
| **마감봉제(SEW_FBR)·제품가공(PDT_WRK 상품별)** | `PROC_000080 봉제`·`PROC_000084 열재단`·`PROC_000007 별색인쇄` 공정 행 **라이브 실재**·PDT_WRK=동일 PCS 슬롯+상품별 인스턴스(쿠션가공/에코백가공)·SEW_FBR=봉제 family(오버로크/말아박기/벨크로) — 직물 굿즈별 봉제 완제 공정 인스턴스·단가 **미적재** | **data-gap**(봉제/별색/재단 공정 행 PASS·상품별 가공 인스턴스 미적재)·*본체 형태가공#14는 vessel V-8* | round-22 ⑤공정·#14 본체형태가공(봉제=PD-1 동형 V-8) |
| **타일링/마감봉제/솜 단가(infoCall)** | PDT_WRK/SUB_MTR/SEW_FBR/타일링 상세 enum·단가는 infoCall AJAX 후행·SSR 미노출 — 가격 가산 규칙·면적함수(real_price↔real_calc_price) **unobserved** | **data-gap**(가격 그릇 보유·infoCall 단가 미캡처)·*축/vessel 판정 무영향* | round-22 가격 트랙·infoCall 캡처(node monitor)·가격검증 |

> ★FS 핵심 구분(directive 1순위 직답): FS facet 8건 = **PASS 3(방향=사이즈#13·별색=공정#2 PROC_000007·완제 부자재=부속물#8/MAT_TYPE.09/옵션#3·조치 0[그릇 PASS])·WEAK 3(면직물 measure_type=#1 V-3·봉제/제품가공=#14 V-8·가격모델=#11)·GAP 1(타일링=#9 공정파라미터 V-1)·unobserved 1(infoCall)**. **신규 vessel-gap 0**(타일링 TILL_WH_GBN #18 부결·distinct 신축 0). 위 §11은 *그릇 있는데 FS 타일링 반복배치/완제 부자재(솜/끈/자석)/면직물 본체 행/봉제 인스턴스/infoCall 단가 미적재*만 = dbmap. **★혼동 금지: FS-1 타일링(directive 1순위)은 data-gap(공정#2 #9 `prcs_dtl_opt` jsonb 인쇄배치 1급 그릇 실재·후니 KB plate_size/공정 파라미터가 인쇄 배치 이미 1급 모델링·결함 명시 없음) — ST 형상(KB G-SK-2 "어느 축에도 없음" vessel-gap)과 정반대.** 타일링(TILL_WH_GBN)=전용 슬롯 OBSERVED(✅·5상품 전수)·후니 KB 결함 없음(❌·공정 파라미터 jsonb 무왜곡 표현)=둘 중 ①만 충족→distinct #18 부결(ST 형상은 둘 다 충족→승격·결정적 분기). ★**타일링≠판걸이수(HARD)**: 타일링=고객 입력 파라미터(공정#9 등재)·판걸이수=앱 계산 파생값(DB 미저장·등재 금지). 후니가 직물 굿즈 취급 시 = 기존 공정#2/자재#1/부속물#8/옵션#3 그릇 채우기(새 그릇 신설 불요). ★directive metamodel 예측(distinct 0·공정#2 #9 data-gap) 라이브 실측 확정(그릇 실재: prcs_dtl_opt jsonb·PROC_000080 봉제/000007 별색/000084 열재단·t_prd_product_addons·MAT_TYPE.09 봉제부자재).

---

## 5. 라우팅 요약

- **닫힌 갭(§1)**: 조치 불요 — 하네스 입력 권위만 라이브로 갱신.
- **부분 적재(§2)**: huni-dbmap round-6(CPQ)·가격 트랙 — 적재 진행.
- **오염(§3)**: huni-dbmap round-22 B-3 축이동 — 단, vessel(V-3 분해축) 선결 후 목적지로 이동.
- **굿즈 data-gap(§4)**: huni-dbmap round-6(굿즈 CPQ)·가격 트랙(template_prices·tiered)·round-22 GPM-4(미적재 소재 행). **굿즈 CPQ·개당가는 그릇 있고 미적재 = data, vessel 신설 불요.**
- **TP data-gap(§6)**: 완제 개당가·template_selections 구성·TP page_rules = 그릇 있고 미적재 = dbmap 가격/round-6 트랙. **★단 #16 디자인 입력 채널은 data 아님 = vessel-gap V-10(그릇 부재·dbmap으로 안 닫힘).**
- **AC data-gap(§8)**: huni-dbmap 31_acrylic Q-ACR-7(.02 엔진계산)·GAP-CHAIN(미러/코롯토/카라비너 공식)·GAP-BIND-22(상품 바인딩)·GAP-CPQ-ZERO(아크릴 CPQ)·GAP-FINISH-COMP(후가공 단가)·round-6/가격 트랙. **★전부 가격사슬/CPQ data 결함 = 그릇 있고 미완·dbmap 가격 트랙. AC vessel-gap = 0(가공방식 그룹핑 #18 부결·distinct 신축 0).** 부자재 버킷 분산/D링 3중복 = V-3 버킷 재정의(주로 data·round-22 ④자재 조율).
- **PD data-gap(§9)**: huni-dbmap round-22 GPM-4(내재BOM 다리/받침/논슬립 부속물#8 적재·솜/지퍼 자재 usage)·round-6 CPQ(PD 옵션·밑창 2D 페어링)·가격 트랙(template_prices 완제 개당가)·`dbm-ddl-proposer`(신규 부속 mint). **★전부 그릇 있고 미적재 = data. PD vessel-gap = 0(완제 구조물 내재BOM #18 부결·distinct 신축 0). ★PD-4 내재BOM = data-gap not vessel-gap 라이브 확정(부속물#8 addon→tmpl_cd 그릇·usage_cd .07 슬롯 실재·후니 KB 1급 모델링·ST 형상 G-SK-2와 정반대).**
- **PH data-gap(§10)**: huni-dbmap round-6 CPQ(거치방식 택1→cascade constraints.logic·완제 액자 SKU template_selections)·round-22 ④자재(인화지×마감 매체행)·⑥카테고리(PHMG/PHPO 다중분류=정책)·②사이즈/기초코드(set base_quant)·#14(포토북 제본=PR 책자 동형). **★전부 그릇 있고 미적재 = data. PH vessel-gap = 0(완제 액자 그릇/마운팅 #18 부결·distinct 신축 0). ★PH-1/PH-2 거치/완제 액자(directive 최대 관전) = data-gap/facet not vessel-gap 라이브 확정(옵션#3 option_groups 134/items 469·제약#5 constraints.logic 10·완제SKU#4 templates 12/selections 14 그릇 실재·거치 §0.5 OBSERVED했으나 옵션 일반 cascade 무왜곡 표현·후니 KB 결함 없음·ST 형상 G-SK-2와 정반대).**
- **FS data-gap(§11)**: huni-dbmap round-22 ③도수/공정(타일링 `prcs_dtl_opt` jsonb 반복배치 enum 적재)·④자재(MAT_TYPE.09 솜/끈/라벨/자석 행·면직물 본체 행·measure_type)·⑤공정(봉제 PROC_000080 상품별 인스턴스)·round-6 CPQ(선택형 부자재 옵션 노출 view_yn=Y)·가격 트랙(infoCall 단가). **★전부 그릇 있고 미적재 = data. FS vessel-gap = 0(타일링 TILL_WH_GBN #18 부결·distinct 신축 0). ★FS-1 타일링(directive 1순위) = data-gap not vessel-gap 라이브 확정(공정#2 #9 `prcs_dtl_opt` jsonb 인쇄배치 1급 그릇 실재·PROC_000080 봉제/000007 별색 행·MAT_TYPE.09 봉제부자재 버킷·후니 KB plate_size/공정 파라미터 인쇄 배치 1급 모델링·타일링≠판걸이수 HARD·ST 형상 G-SK-2와 정반대).**
- **본 하네스(RP-Meta) 산출**: `vessel-needs.md`의 V-1~V-12(vessel-gap)만 — **TP 핵심 = V-10 디자인 입력 채널(★directive 1순위·신규)·V-11 TemplateAsset 분리** · ST 핵심 = V-12 형상 축(신규) · GS 핵심 = V-3 굿즈 분해축·V-8 형태가공. **★AC/CL/PR/PD/PH/FS = 신규 vessel 0(17축 재포화·10 카테고리)** — AC facet은 V-3(두께 measure_type·surface_finish·단일 부자재 마스터 3차원)·V-7(acrylic2025 frm_typ)·V-10/V-11(ACTPKEY)에·PH facet은 V-3(인화지×마감 surface_finish)·V-11(완제 액자 SKU↔디자인시안 이중의미)에·**FS facet은 V-3(면직물 measure_type 번수·면사 수)·V-8(봉제 SEW_FBR/제품가공 PDT_WRK family)·V-1(타일링 enum 공정 파라미터)에** 흡수. data는 전부 dbmap.
