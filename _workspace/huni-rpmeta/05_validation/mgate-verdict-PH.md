# PH(포토보드·액자·사진인화·포토북·포토굿즈) M1~M6 게이트 검증 — rpm-validator

> 후니 RP-Meta 하네스 경계면 교차 독립 검증(rpm-validator). PH = 9번째 종단 카테고리.
> **생성≠검증** — 생성자 주장 비신뢰, 라이브 read-only 재실측·캡처 재대조로 재도출.
> 권위 = 라이브 `information_schema`/실측(2026-06-17 read-only psql 직접 SELECT, 본 검증 세션) + §0.5 캡처 아티팩트 재확인.
> [HARD] 라이브 쓰기 0·RedPrinting 제출 0·자격증명 비노출.

## 종합 판정: **GO** (M1~M6 전건 PASS·NO-GO/CONDITIONAL 0)

PH가 1차 예측한 "distinct #18 부결·17축 재포화·신규 vessel 0"가 **내 독립 재실측으로 전건 재현**. 생성자가 인용한 라이브 카운트는 단 한 건의 과장/날조 없이 내 read-only psql 재조회와 **정확히 일치**. §0.5 client-render 캡처는 실제 아티팩트(스크린샷)로 재확인 — 거치(탁상용/벽걸이) OBSERVED는 진짜. deepcheck H-1/H-2/H-3은 `unverified`로 정직하게 carry-forward·채택 0·mint 0.

---

## 내 독립 재실측 vs 생성자 주장 (대조표)

| 측정 항목 | 생성자 주장 | **내 독립 재측(2026-06-17 psql)** | 일치 |
|---|---:|---:|:---:|
| `t_prd_product_option_groups` | 134 | **134** (SEL_TYPE.01=123·.02=11) | ✅ |
| `t_prd_product_options` | 494 | **494** | ✅ |
| `t_prd_product_option_items` | 469 | **469** (ref_dim .03=255·.04=156·.06=45·.01=11·.07=2) | ✅ |
| `t_prd_product_constraints` (logic jsonb) | 10 | **10** (logic=jsonb 컬럼 실재) | ✅ |
| `t_prd_templates` | 12 | **12** (tmpl_cd·base_prd_cd·tmpl_nm·dflt_qty·tags 실재) | ✅ |
| `t_prd_template_selections` | 14 | **14** | ✅ |
| `t_prd_product_bundle_qtys` | 28 | **28** | ✅ |
| `t_mat_materials` surface/finish/glitter/holo 컬럼 | 0 (WEAK) | **0** (mat_nm 융합) | ✅ |
| `t_siz_sizes` shape/form/ratio/aspect 컬럼 | 0 | **0** | ✅ |
| `t_prd_product_categories` 다중분류 | 2카테고리=8상품 | **2카테고리=8·1카테고리=265** | ✅ |
| `main_cat_yn` 분포 | Y=273·N=8 | **Y=273·N=8** | ✅ |
| `t_prd_product_addons` (A-3/PD-4 PASS 그릇) | 그릇 실재 | **실재(5행)** | ✅ |
| shape_cd / design_input_channel / editor_kind 컬럼 | mint 0 (미적용) | **0건** (V-12/V-10 미적용·search-before-mint 준수) | ✅ |
| SHAPE base_code 그룹 | 미적용 | **0건** | ✅ |
| PH 상품 라이브 적재 | (미적재·data) | **t_prd_products PH% = 0** (PH 자체 미적재·축/그릇은 타 상품으로 가동) | ✅ |

**핵심: 생성자가 인용한 라이브 카운트 14건 전부 byte-단위로 재현. 단 한 건의 인플레/날조 없음.** option_items ref_dim 5종 분포(255/156/45/11/2)·SEL_TYPE 분포(123/11)까지 정확 일치 — 생성자가 라이브를 *실제로* 조회했음의 강한 증거(추정/메모리 복사 아님).

---

## M1 — 추출 충실성: **PASS** ✅

§0.5 client-render 재캡처 데이터가 실제인지 캡처 아티팩트로 재대조.

- **§0.5 캡처 아티팩트 실재 확인:** `/tmp/ph_phfrdia_options.png`(2.2MB·2026-06-17 15:11 생성) 재열람 — **진짜 RedPrinting PHFRDIA "디아섹 아크릴액자" 상품 페이지 client-render 스크린샷**. 다음이 화면에 실재:
  - **거치 방식 토글 = 탁상용 / 벽걸이** (reverse §0.5 ① "거치 방식 버튼 토글 탁상용/벽걸이"와 field-for-field 일치)
  - 마감 combobox "디아섹 아크릴액자 (탁상용 유광...)"·사이즈 combobox·작업/재단 치수 spinbutton(127/177 작업)·수량 combobox·**PDF/에디터/편집하기 버튼**(디자인 입력#16)
  - "사이즈" 섹션의 탁상용/벽걸이용 탭 + 사이즈 표(reverse "거치 → 마감 → 완제SKU사이즈 캐스케이드"의 시각 증거)
  - "함께보면 좋은 제품" nav 블록 = reverse가 정직하게 "공유 카테고리 nav 블록(상품 고유 옵션 아님)"으로 분리한 그것
- **거치 OBSERVED = 진짜**(미싱데이터 해소 주장 검증 통과). 전면 보호재 별도 select 미관측·디아섹 전면재 상품 내재(스크린샷에 별도 glazing select 부재)도 화면과 일치.
- **`unobserved` 정직 표기 확인:** PHFRWOD/PHFRALU "스타일 진입형 미펼침"·전면재 다른 액자·포토북 면수/제본 = 전부 `unobserved`로 정직 표기(추정 승격 0). reverse §0.5 ④가 "원목/알루미늄 개별 미확인은 정직 표기"로 명시 — 날조 0.
- **레거시 SSR 실측(PHPTPRM 용지 select·flags pdt_gbn=edicus_item/price_gbn=tmpl_price 등)** 은 SSR 인라인 객체에서 직접 인용·출처 표기 일관.

**[Low 결함 D-PH-V1·게이트 무영향]** reverse §0.5·deepcheck가 인용한 gstack 바이너리 경로 `.claude/skills/gstack/browse/dist/browse`가 **현재 파일시스템에 부존재**(전 디렉터리 검색 0건). 그러나 ① 캡처 산출물(스크린샷)이 실재·진짜이고 ② `gstack`/`browse` 스킬은 환경에 등록되어 있어 — 경로 표기가 stale/부정확한 **문서 nit**이지 캡처 날조가 아님. 추출 충실성(데이터가 소스와 일치)은 캡처 아티팩트 재대조로 충족. 라우팅: reverse-engineer(경로 문구 정정·게이트 무영향).

→ **추출 충실성 PASS** — 캡처 데이터가 실제 소스(스크린샷)와 일치, unobserved 정직.

## M2 — 메타모델 정합: **PASS** ✅

- **축 도출 증거 기반·오버피팅 없음:** PH 6 fragment(PH-1~PH-6)가 전부 기존 17축으로 분해(완제SKU#4·자재#1·옵션#3·제약#5·기초코드#6·카테고리#7·부속물#8·수량#10·사이즈#13·생산형태#15·디자인입력#16). 단일상품 전용 신축 강요 0.
- **관계 무모순:** 거치 캐스케이드 = 옵션#3(option_groups SEL_TYPE.01 택1)→option_items(polymorphic ref_dim)→제약#5(constraints.logic JSONLogic) — FK/참조 체인이 라이브 그릇(134/469/10)과 정합. 완제 액자 SKU = templates(12)+template_selections(14)로 표현 — ERD 사전과 일치.
- **dictionary 정합:** discovered-axes는 D-1~D-12를 distinct로 두되 metamodel-dictionary가 "7 정적 + 4 관계/동역학 + 2 횡단 + GS 2 + TP 1 + ST 1 = **17 dictionaried 축**"으로 정리·D-8 제외 회계가 일관. PH가 dictionary 축 수 변동 0(17 유지).

→ **메타모델 정합 PASS.**

## M3 — 추가 메타모델 타당성: **PASS** ✅

#18 부결의 distinctness 재검·deepcheck carry-forward 점검.

- **#18 부결 건전:** HARD 승격 기준(① 전용 슬롯 라이브 실재 AND ② 후니 KB "어느 축에도 없음" 결함) 양방향 적용이 일관. 거치는 ①충족(§0.5 토글 OBSERVED·캡처로 내가 재확인)·②**불충족**(후니 KB에 거치/마운팅 결함 명시 없음 — 옵션#3/완제SKU#4/자재#1이 왜곡 없이 담음) → 부결. ST 형상#17(①②둘 다 충족·승격)과의 결정적 분기가 논리적으로 타당.
- **거치 = option-cascade-absorbed가 잘못 억압한 distinct가 아님:** 내가 라이브에서 옵션 캐스케이드 그릇(option_groups 134·constraints.logic jsonb 10)이 실재함을 재확인 — 거치(택1) + 거치→마감→사이즈 풀 교체(JSONLogic)를 담을 그릇이 실재. 거치가 "옵션 일반 cascade로 무왜곡 표현"된다는 판정이 그릇 실재로 뒷받침됨(억압 아님).
- **deepcheck H-1/H-2/H-3 = `unverified`·채택 0·mint 0 확인:** deepcheck.md가 16후보 전부 `unverified`·채택 0 명시. H-1(content-container 합성역할·#18 최강 적대 후보)조차 codex 결정 기준("재사용 라이브 슬롯 증거 없으면 승격 안 함")이 PH-1 data-gap 판정과 수렴 — 메타모델/갭/vessel 어디에도 silently 채택 안 됨. H-2(매팅)·H-3(aperture)·M-4(glazing)·M-6(포토북 페이지)는 §0.5 미캡처 영역으로 carry-forward(라이브 실측 대상). AC layer-stack·PD construction REFUTED 교훈("검증 전 distinct 신뢰 금지") 일관 적용.
- **미싱 축 점검:** 증거가 명백히 가리키는 *놓친* distinct 축 없음. H-2 매팅은 "분석 전무"였으나 §0.5 미캡처·`unverified`라 자동 FAIL 아님(갭으로 carry-forward·정직).

→ **추가 메타모델 타당성 PASS** — #18 부결 건전·거치 흡수 정당·deepcheck 미채택.

## M4 — 갭 판정 정확: **PASS** ✅

라이브 information_schema 양면 재실측(위 대조표 14건).

- **PASS 3 (거치 캐스케이드·형태 비율·다중분류) 재확인:** ① 거치=옵션#3 그릇(option_groups 134·items 469·constraints.logic 10) **라이브 실재 재측** ② 형태=사이즈#13(siz shape/form/ratio 컬럼 **0건 재측**·work/cut width·height 1:1 프리셋) ③ 다중분류=카테고리#7(`main_cat_yn` Y273/N8·2카테고리 8상품 **라이브 작동 재측**). 세 PASS 모두 그릇이 실재하고 가동 중임을 내가 재확인.
- **WEAK 3 (완제 액자 SKU·인화지×마감·set 단위) 재확인:** ① 완제 액자 SKU=templates 12+selections 14 그릇 보유하나 디자인시안↔완제SKU 이중의미(#4 WEAK·T-A) ② 인화지×마감=surface/finish 컬럼 **0건 재측**·mat_nm 융합(#1 WEAK·V-3) ③ set 단위=bundle_qtys 28 그릇 보유하나 set-as-base 모델 약함(#10 WEAK). 세 WEAK 모두 "그릇 있으나 미정규화/이중의미" 판정이 라이브와 정합.
- **GAP 0 정확:** PH 신규 GAP 0 — 포토북 제본=#14·디자인입력=#16은 기존 GAP 재확인이지 PH 신규 아님. PH가 새 GAP을 만들지 않음이 타당(거치/완제 액자는 그릇 실재).
- **존재하지 않는 컬럼 인용 PASS 0건·실재 그릇 GAP 판정 0건:** PASS가 인용한 컬럼(option_groups/constraints.logic/templates/main_cat_yn)은 전부 내 재측으로 실재 확인. WEAK가 인용한 "surface/finish 0건"도 실재 부재 재측. **양면 검증 통과.**
- **data-gap vs vessel-gap 구분 정확:** PH-1/PH-2 거치/완제 액자는 그릇 4-레벨 실재(옵션#3·제약#5·완제SKU#4·자재#1)·PH 상품 자체 미적재(PH% products=0 재측) → **data-gap**(`_data-gaps-noted §10`·dbmap 라우팅)이지 vessel-gap 아님. ST 형상(vessel-gap)과 정반대 구분이 라이브 그릇 실재 여부로 정당.

→ **갭 판정 정확 PASS** — PASS 3/WEAK 3/GAP 0이 라이브와 전건 일치.

## M5 — 그릇 건전성: **PASS** ✅

search-before-mint·신규 mint 0 재검.

- **신규 vessel/table/column/code = 0 (PH):** vessel-roadmap v9.0이 PH facet 6항 전부 기존 V-항목 흡수(완제 액자 SKU→V-11·인화지×마감→V-3·set 단위→#10·거치=옵션#3 PASS·형태=#13 PASS·다중분류=#7 PASS) 선언. 내가 라이브에서 **shape_cd/design_input_channel/editor_kind 컬럼 0건·SHAPE base_code 0건 재측** — V-1~V-12 미적용 상태 그대로(PH가 새 그릇 안 만듦). dbm-ddl-proposer 미호출 일관.
- **search-before-mint 상향 통과:** PH-3 인화지×마감 = surface/finish 컬럼 부재(내 재측)이나 → MAT_FACET 코드행(V-3 기존)으로 흡수·테이블 mint 0. "BN→GS→ST→AC→PD→PH 6카테고리째 V-3 합성-분해축에 차원 추가하나 코드행으로 닫힘(테이블 mint 0)" 사다리 정직성이 라이브 그릇 부재 재측으로 뒷받침.
- **완제 액자 SKU↔디자인시안 이중의미 = V-11(기존 TP mint)에 귀속·PH 신규 mint 0:** vessel-template-asset §9가 완제 액자 주문 SKU(완제SKU#4·templates)와 디자인 시안 자산(V-11·t_prd_template_assets)을 분리·PH는 새 수요 추가 0. 정규화 정당(이중의미 분리는 오염 방지).
- **★deepcheck H-1/H-2/H-3·M-4/M-6 = unobserved-pending·mint 0 확인:** vessel-roadmap v9.0 표 마지막 행 + §12.2 + template-asset §9 전부 "미관측·검증 전 그릇 제안 금지·라이브 실측 대상으로만 carry-forward" 명시. H-1 content-container를 그릇으로 굳히지 않음(AC layer-stack/PD construction REFUTED 교훈). **검증 전 silently 채택 0 — search-before-mint HARD 준수.**
- **컨벤션 정합·정규화:** 흡수 대상 그릇(V-11 templates·V-3 MAT_FACET·옵션#3 option_groups)이 전부 t_* 컨벤션·기존 라이브 구조. PH가 컨벤션 드리프트 도입 0.

→ **그릇 건전성 PASS** — PH 신규 그릇 0·search-before-mint 상향 통과·deepcheck mint 0·V-1~V-12 불변.

## M6 — 생성-검증 독립성: **PASS** ✅

- **자가 승인 없음:** 생성(reverse/metamodel/gap/vessel)과 본 검증은 분리 레인. 내가 라이브를 직접 재조회(생성자 카운트 echo 아님).
- **재도출 입증:** 위 대조표 14건은 내 read-only psql 직접 SELECT 결과. §0.5 캡처는 내가 스크린샷을 직접 재열람. 생성자 주장을 가설로 두고 전부 재현 시도 → 전건 재현.
- **Dodge-hunt (스테이지별 최고위험 주장 격파 시도):**
  - **reverse 최고위험 = "거치 OBSERVED(블로커 해소)":** gstack 바이너리 경로 부존재를 발견 → 캡처가 날조일 가능성 의심 → `/tmp/ph_phfrdia_options.png` 직접 열람으로 **진짜 PHFRDIA 캡처·탁상용/벽걸이 토글 실재 확인**. 날조 아님(경로 문구만 stale).
  - **gap 최고위험 = "라이브 카운트(134/469/10/12/14/28·다중분류 8)":** 내 독립 psql 재조회 → **전건 byte-일치**(ref_dim·SEL_TYPE 분포까지). 인플레/날조 0.
  - **metamodel 최고위험 = "#18 부결(거치가 distinct 아님)":** 거치 그릇(option_groups/constraints.logic) 라이브 실재 재측 + KB 결함 부재 논리 → 흡수 판정 정당(억압 아님).
  - **vessel 최고위험 = "신규 mint 0·V-12 미적용":** shape_cd/SHAPE/design_input_channel 컬럼 0건 라이브 재측 → mint 0 확정.
  - **deepcheck 최고위험 = "H-1 content-container 채택 누락":** deepcheck/metamodel/gap/vessel 전 산출 grep → H-1 전부 `unverified`·채택 0·mint 0 확인. silently 흡수 0.
- **거짓 GO 유혹 차단:** PH 상품 자체가 라이브 미적재(PH% products=0)임에도 생성자가 "PH 적재됨"으로 과장하지 않고 "그릇은 타 상품으로 가동·PH는 data-gap(미적재)"로 정직 — 내 재측과 일치.

→ **생성-검증 독립성 PASS** — 재도출 입증·dodge 전건 격파·자가 승인 0.

---

## 결함 목록 (라우팅)

| ID | 게이트 | 심각도 | 결함 | 라우팅 |
|---|---|:---:|---|---|
| D-PH-V1 | M1 | **Low (게이트 무영향)** | reverse §0.5·deepcheck 인용 gstack 바이너리 경로 `.claude/skills/gstack/browse/dist/browse` 파일시스템 부존재(캡처 산출물·스킬은 실재). 문서 경로 stale. | rpm-reverse-engineer (경로 문구 정정·캡처 진위 무영향) |

**NO-GO/CONDITIONAL 유발 결함 0건.** D-PH-V1은 캡처 진위(스크린샷 재확인)·추출 충실성과 무관한 문서 nit이라 M1 PASS 유지.

---

## 종합

| 게이트 | 판정 | 핵심 근거(내 독립 재측) |
|---|:---:|---|
| **M1 추출 충실성** | **PASS** ✅ | §0.5 캡처 `/tmp/ph_phfrdia_options.png` 재열람 = 진짜 PHFRDIA·탁상용/벽걸이 토글 실재·unobserved 정직(경로 nit=Low) |
| **M2 메타모델 정합** | **PASS** ✅ | PH 6 fragment 전부 기존 17축 분해·오버피팅 0·거치 캐스케이드 FK체인 라이브 정합·dictionary 17 불변 |
| **M3 추가 메타모델 타당성** | **PASS** ✅ | #18 부결 건전(HARD ②불충족)·거치=흡수 정당(그릇 실재)·deepcheck H-1/H-2/H-3 `unverified`·채택 0 |
| **M4 갭 판정 정확** | **PASS** ✅ | PASS 3/WEAK 3/GAP 0이 라이브 14건 전건 일치(byte-단위)·data-gap vs vessel-gap 구분 정당 |
| **M5 그릇 건전성** | **PASS** ✅ | shape_cd/SHAPE/design_input/editor_kind 컬럼 0건 재측=신규 mint 0·search-before-mint 통과·H-1~M-6 mint 0 |
| **M6 독립성** | **PASS** ✅ | 라이브 직접 재조회·캡처 재열람·dodge 5건 전건 격파·자가 승인 0 |

**최종 = GO** (PH 9번째 종단·distinct 0·17축 재포화·신규 vessel 0·directive 최대 관전[완제 액자/마운팅] 부결 정당).
