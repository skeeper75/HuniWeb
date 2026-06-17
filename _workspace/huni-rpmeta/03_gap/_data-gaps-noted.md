# 데이터 갭 노트 (범위 외 — dbmap 라우팅)

> rpm-gap-analyst. **그릇은 존재하나 데이터가 미적재/오염된 축** — 본 RP-Meta 하네스(vessel 설계) **범위 외**.
> huni-dbmap 적재/교정 트랙으로 라우팅. vessel-gap과 명확히 구분(스키마 표현력 OK = 여기, 표현력 부재 = `vessel-needs.md`).
> [HARD] "테이블 있고 비어있음"·"행 잘못 채움" = data-gap. 그릇 신설 아님.
> **버전:** v1.0(BN §1~§3 보존) + v2.0(GS §4 굿즈 data-gap·라이브 2026-06-17 실측) + v3.0(TP §6 디자인 입력 data-gap·라이브 2026-06-17) + **v4.0(PR §7 책자/다면 data-gap·라이브 2026-06-17)**.

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

## 5. 라우팅 요약

- **닫힌 갭(§1)**: 조치 불요 — 하네스 입력 권위만 라이브로 갱신.
- **부분 적재(§2)**: huni-dbmap round-6(CPQ)·가격 트랙 — 적재 진행.
- **오염(§3)**: huni-dbmap round-22 B-3 축이동 — 단, vessel(V-3 분해축) 선결 후 목적지로 이동.
- **굿즈 data-gap(§4)**: huni-dbmap round-6(굿즈 CPQ)·가격 트랙(template_prices·tiered)·round-22 GPM-4(미적재 소재 행). **굿즈 CPQ·개당가는 그릇 있고 미적재 = data, vessel 신설 불요.**
- **TP data-gap(§6)**: 완제 개당가·template_selections 구성·TP page_rules = 그릇 있고 미적재 = dbmap 가격/round-6 트랙. **★단 #16 디자인 입력 채널은 data 아님 = vessel-gap V-10(그릇 부재·dbmap으로 안 닫힘).**
- **본 하네스(RP-Meta) 산출**: `vessel-needs.md`의 V-1~V-11(vessel-gap)만 — **TP 핵심 = V-10 디자인 입력 채널(★directive 1순위·신규)·V-11 TemplateAsset 분리** · GS 핵심 = V-3 굿즈 분해축·V-8 형태가공. data는 전부 dbmap.
