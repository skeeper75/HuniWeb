# 경쟁사 적재정책 벤치마킹 — 상품 옵션·공정·variant 처리 패턴 (B3/B5/B6/B8 + variant/제본/자재/별색)

> **목적:** huni-dbmap이 미해소 세부정책(B3 형상/커팅 enum · B5 페이지/장수/책등 · B6 묶음수/조각수 · B8 봉제/타공 param · variant 분해)을 처리할 때 참고할 경쟁사 적재/옵션 구성 패턴을 수집한다.
> **권위 원칙(HARD):** 경쟁사 패턴은 **참고**. **후니 엔티티(`t_proc_processes.prcs_dtl_opt` JSON·`t_cod_base_codes`·`t_prd_product_*`)가 최종 권위.** "후니 적용 시 관리 용이성" 관점으로만 권고한다.
> **출처표기:** `[RP-live]` RedPrinting 라이브 / `[RP-rev]` RedPrinting 역공학 / `[WP-doc]` WowPress API 문서 / `[WP-cat]` WowPress catalog JSON / `[BS]` buysangsang / `[huni]` 후니 DB 라이브 규명.
> **작성** 2026-06-05 (pq-researcher) · 식별자/컬럼/코드/SQL 영어, 설명 한국어.
> **벤치마킹 대상:** RedPrinting(redprinting.co.kr, **사용자 본인 설계 시스템** — 역공학 자료 풍부) · WowPress(devshop/api.wowpress.co.kr) · buysangsang(보조).

---

## 0. 출처 인벤토리 및 라이브 크롤 수행 여부

| 출처 | 자산 | 활용 |
|------|------|------|
| `[RP-rev]` | `_workspace/huni-widget/01_reverse/option-schema-catalog.json`+`.md`, `s2-sticker-capture.md`, `s3-poster-capture.md`, `docs/reversing/red_reverse_engineer/05_code_pattern_transfer_analysis.md` | **주력** — 라이브 캡처 기반 옵션트리·가격계약 |
| `[RP-live]` | WebFetch 1건(STTHCIC 원형스티커) — `benchmark-evidence/2026-06-05/redprinting-STTHCIC-live.md` | 형상enum 라이브 재확인(역공학과 정합) |
| `[WP-doc]` | `docs/wowpress/wowpress-api-document.txt` (§7.1~7.4 sizeinfo/colorinfo/awkjobinfo) | API 도메인 모델(규격/도수/후가공 제약) |
| `[WP-cat]` | `docs/wowpress/catalog/products/*.json` (326 상품) | 책자 페이지/coverTypes 구조 |
| `[BS]` | (라이브 미수행) | buysangsang은 WP+Woo+Elementor라 상품옵션이 variation/add-on에 분산, 본 B3~B8 적재정책 관점 신호 약함 → 보조 1절로 한정 |
| `[huni]` | `07_domain/db-domain-structure-live.md` §2-4(`prcs_dtl_opt`), §3(코드그룹), §4(택일그룹) · `08_remediation/{sticker,acrylic,booklet,...}.md` | **권위 기준** |

**라이브 크롤 수행:** RedPrinting 1건(WebFetch, 안전모드 read-only·주문/결제/장바구니 미진입). 역공학 자료가 라이브 캡처 기반으로 이미 풍부하여 신규 라이브 트래픽 최소화(저트래픽 원칙). WowPress는 API 문서·catalog JSON(오프라인 자산)으로 충분. buysangsang은 적재정책 신호가 약해 라이브 생략.

---

## 1. 두 경쟁사의 적재정책 "철학" 대비 (먼저 큰 그림)

| 축 | RedPrinting `[RP-rev]` | WowPress `[WP-doc]` | 후니 현재 `[huni]` |
|----|------------------------|----------------------|---------------------|
| **옵션 표현 위치** | 상품 productInfo에 **옵션트리 전개**(pdt_size_info/pdt_pcs_info/option_info) — 클라가 전 옵션·제약을 받아 캐스케이드 렌더 | catalog는 **불투명 프리셋 ID**(jobPresetNo/sizeNo/colorNo)만, 옵션 디테일은 `prod_info`(sizeinfo/colorinfo/awkjobinfo) 별도 조회 + 가격은 `/std/prod/jobcost` 위임 | 정규화 테이블(`t_prd_product_*`) + 공정 `prcs_dtl_opt` JSON |
| **형상/모양** | **후가공 PCS**로 표현(THO_DFT/THO_CUT 모양커팅, 도형 17~37종을 PCS_DTL_CD) | **사이즈의 `non_standard` 플래그**(0:규격/1:비규격, ex.스티커 원형) | **공정 `prcs_dtl_opt.모양`**(완칼/반칼/족자) — RP와 동축 |
| **페이지/장수** | `MIN_PAGE`/`MAX_PAGE` + 내지 `inner_pdt_*` 분리 데이터셋 | `coverTypes[].pageConstraints{min,max,interval}` | 제본 `prcs_dtl_opt.책등` + (page_rule 별도) |
| **묶음/조각수** | 재단 PCS 하위옵션(묶음/개별재단) + (조각수=별도 신호 약함) | 후가공 `unit`(주문수량단위) | **공정 `prcs_dtl_opt.조각수`**(반칼/스티커완칼) — RP/WP보다 명시적 |
| **세부공정 param** | PCS_DTL_COD + ESN_YN/VIEW_YN/QTY_INPUT_YN 메타 | awkjob `namestep1`/`namestep2`(2단계 하위옵션) + `req_joboption` | **`prcs_dtl_opt` JSON**(타공 구수/봉제 유형·폭) |
| **variant 차원** | material/size/dosu/pcs **별도 축**으로 분리 유지 + 캐스케이드 제약(`disable_pcs`) | sizeno×paperno×colorno×optno 조합 + 조합체크 에러 | (현재 평면화 결함 — acrylic 두께 192 일괄) |

**핵심 통찰:** **후니의 `prcs_dtl_opt` JSON 구조는 RedPrinting의 PCS_DTL + QTY_INPUT_YN 메타와 WowPress의 awkjob namestep 2단계를 이미 흡수한 설계**다. 즉 후니 스키마는 경쟁사 대비 **세부정책 표현력이 부족하지 않다.** 후니의 진짜 결함은 "스키마 부재"가 아니라 "엑셀 옵션 → 상품 연결행 미적재"(`08_remediation` 공통 진단)이다. 벤치마킹의 가치는 **"어느 축에 담을지"(형상=공정 vs 사이즈 vs 신규테이블)의 의사결정 참조**에 있다.

---

## 2. B3 — 형상/커팅 enum (스티커 도형·완칼/반칼/도무송)

### 2.1 경쟁사 처리 패턴

| 항목 | RedPrinting `[RP-rev]`·`[RP-live]` | WowPress `[WP-doc]`·`[WP-cat]` |
|------|-----------------------------------|-------------------------------|
| **모양 enum 담는 곳** | **후가공 PCS** — `PCS_COD=THO_DFT`(원형스티커)/`THO_CUT`(굿즈), 도형 17~37종을 `PCS_DTL_COD`(CL001 원형10X10…CLFRE 자유원형). 별도 `option_info.shape_info`로 모양 **그룹 선택축**도 둠(2중) | **사이즈의 `non_standard` 플래그** — sizeinfo에 `non_standard:0(규격)/1(비규격, ex.스티커 원형)`. 도형은 별도 enum 테이블 아님, 사이즈 행에 내포 |
| **반칼/완칼/도무송 구분** | productCode 자체로 분기(STCUXXX 사각반칼·STTHCIC 원형반칼·도무송계열). 커팅방식은 상품 정체성 | 상품명/slug로 분기(광택스티커(도무송)). API상 후가공 jobgroup |
| **재단단위(묶음/개별)** | `CUT_DFT` PCS 하위(묶음재단 A5~A4 / 개별재단 낱장) `[RP-live]` | 후가공 awkjob `unit`(주문수량단위) |
| **자유형 치수** | `사이즈직접입력` + MIN/MAX_CUT 슬롯 검증 | `non_standard=1` → `req_width`/`req_height`(min/max 필수조건 object) |

### 2.2 후니 권위 대비 (B3)

후니 `[huni]`는 형상을 **공정 `prcs_dtl_opt`**에 담는다: `PROC_000053 완칼{모양 string}` · `PROC_000054 반칼{모양 string, 조각수 int}` · `PROC_000055 스티커완칼{조각수 int}` · `PROC_000082 족자제작{모양 enum:사각/원형}`. 결함은 sticker 상품의 **도형·치수 enum이 사이즈 축에서 드롭**(G-SK-2: 058~063 반칼 도형 25~90mm, 066 합판도무송 37종)된 것.

**→ 후니 적용 권고 (관리 용이성):**
1. **형상 enum은 후니 기존 축(공정 `prcs_dtl_opt.모양`)을 권위로 유지하라.** RP처럼 "모양=후가공 PCS"로 재배치하거나 WP처럼 "사이즈 non_standard 플래그"로 옮길 이유 없음 — 후니는 이미 완칼/반칼이 root 공정으로 분리돼 있어 RP/WP보다 **모델이 명확**하다.
2. **단, 도형별 "치수 프리셋"(원형 25~90mm 등)은 사이즈 축(`t_prd_product_sizes`)에 적재하되 `prcs_dtl_opt.모양`과 짝지어라.** RP의 2중 표현(PCS 모양 + shape_info 그룹)이 시사하는 건, **모양(공정)과 치수(사이즈)는 별 축이되 캐스케이드로 연동**해야 한다는 점. 후니는 모양=공정, 치수=사이즈로 자연 분리되므로 RP보다 단순.
3. **자유형(non_standard) 치수 범위**는 WP `req_width/req_height` + RP `MIN/MAX_CUT`처럼 **min/max를 별도 컬럼**으로(후니 `nonspec_width/height_min/max` — 현재 전 상품 NULL이 결함, G-AC-6/G-SL-6). **이건 경쟁사 둘 다 명시 슬롯을 두므로 후니도 채워야 함.**
4. **반칼↔스티커완칼 코드 정합**(G-SK-6 컨펌)은 후니 내부 결정 — 경쟁사는 productCode로 분기하므로 참조가치 낮음.

---

## 3. B5 — 페이지/장수/책등 (책자·캘린더·포토북)

### 3.1 경쟁사 처리 패턴

| 항목 | RedPrinting `[RP-rev]` | WowPress `[WP-cat]`·`[WP-doc]` |
|------|------------------------|-------------------------------|
| **페이지 min/max/증가** | `pdt_prn_cnt_info`/내지 데이터셋에 `MIN_PAGE`/`MAX_PAGE`(책자 10~300). 수량은 `FIR`/`INC`/`STEP` | `coverTypes[].pageConstraints{min,max,interval}` (예 표지 min4 max4 interval1). **표지/내지(coverTypes)별로 page 제약 분리** |
| **표지/내지 분리** | **내지 `inner_pdt_*` 별도 데이터셋**(inner_pdt_mtrl_info 내지자재, inner page 별도) — 표지/내지 완전 분리 구조 | `coverTypes` 배열(code/name=표지·내지, pages[], pageConstraints) — 표지내지 통합 구분 `covercd` |
| **책등** | (역공학 캡처상 명시 신호 약함 — 제본방향 BIND_DIRECTION PCS) | (catalog 명시 약함) |
| **장수(캘린더)** | (포스터/캘린더는 FixedUnit·시트 단위 `FIR=1`) | coverType pages 배열 |

### 3.2 후니 권위 대비 (B5)

후니 `[huni]`: 제본 `PROC_000017 prcs_dtl_opt{방향:좌철/상철, 묶음단위, 책등(mm), 고리형:bool}`. 즉 **책등을 제본 공정 param으로 이미 보유**(RP/WP보다 명시적). 페이지룰은 별도(page_rule min/max/interval). 결함은 booklet 내지/표지 종이 IMPORT 미적재(B1)·page_rule 일부 잡음(G-BK-5)이지 스키마 부재 아님.

**→ 후니 적용 권고 (관리 용이성):**
1. **표지/내지 분리는 후니 `t_prd_product_materials.usage_cd`(USAGE.01 내지/.02 표지)로 이미 표현 — RP의 inner_pdt 별도 데이터셋, WP의 coverTypes 배열과 동일 효과.** 후니가 더 정규화돼 있음. 유지.
2. **page_rule(min/max/interval)은 RP `MIN/MAX_PAGE`·WP `pageConstraints{min,max,interval}`와 1:1 대응** — 후니도 interval(증가단위) 컬럼을 명시하라. 두 경쟁사 모두 interval을 둠. (후니 page_rule에 interval 누락 시 보강.)
3. **책등은 후니가 이미 제본 param(`책등 mm`)으로 보유 — 경쟁사보다 우위. 유지.** 단 photobook 책등(G-PB-4)은 제본 param으로 채워라(현재 미적재).
4. **캘린더 장수**는 후니 결정(G-CL-5). RP는 시트 FixedUnit, WP는 pages 배열 — **후니는 "장수=수량(매)" vs "장수=page_rule" 택1.** 관리 용이성 측면: 캘린더 장수가 가격에 비선형이면 page_rule, 단순 매수면 qty가 단순. 후니 가격엔진(round-2) 형식에 맞춰 결정 권고.

---

## 4. B6 — 묶음수/조각수 (명함 건수·아크릴 조각수·묶음 단위)

### 4.1 경쟁사 처리 패턴

| 항목 | RedPrinting `[RP-rev]`·`[RP-live]` | WowPress `[WP-doc]`·`[WP-cat]` |
|------|-----------------------------------|-------------------------------|
| **명함 건수/묶음** | `pdt_prn_cnt_info`(수량밴드 FIR/INC). 묶음은 `CUT_DFT` 재단 PCS(묶음/개별) | orderQuantities minimum/maximum(모양명함 96~960). 묶음 신호는 unit=매 |
| **아크릴 조각수** | (역공학상 조각수 명시 신호 약함 — 굿즈는 단순 개 단위) | unit=개 |
| **묶음 단위(unit)** | `unit`(권/개/장/매) — 상품 메타 | `meta.unit`(부/매/개/세트) + 후가공 awkjob `unit` |

### 4.2 후니 권위 대비 (B6) — 후니가 경쟁사보다 우위

후니 `[huni]`: **조각수를 공정 param으로 명시 보유** — `PROC_000054 반칼{조각수 int≥1}`·`PROC_000055 스티커완칼{조각수 int≥1}`. acrylic은 자유형스탠드 2~6조각·미니파츠 10조각(G-AC-2). 후니 결정(과업 명시): **조각수=묶음수 차원 + 위젯 표시 조각수.** 묶음단위는 제본 `prcs_dtl_opt.묶음단위`도 보유.

**→ 후니 적용 권고 (관리 용이성):**
1. **조각수는 RP/WP 어느 쪽도 명시 슬롯이 없다 — 후니의 `prcs_dtl_opt.조각수`가 가장 명시적.** 경쟁사 답습 불요. **후니 기존 축 유지가 정답.** (RP/WP는 조각수를 가격표/SKU에 흡수해 옵션으로 노출 안 함.)
2. **단위(unit)는 후니 `QTY_UNIT`(.01 EA/.02 매/.03 권/.04 세트) 코드그룹 보유** — RP/WP unit과 대응. **272 전상품 NULL(B7)을 일괄 부여하라**(글로벌 갭). 두 경쟁사 모두 unit을 상품 필수 메타로 두므로 후니도 필수화.
3. **묶음수(명함 건수 등)**: RP는 재단 PCS+수량밴드, WP는 qty min/max로 처리. **후니는 "조각수=묶음수 차원"으로 통합 결정 — 이 통합이 RP의 분산(재단PCS+수량)보다 관리 단순.** 단 위젯 표시용 조각수와 적재 묶음수가 1:1이도록 매핑 일관성만 확보.

---

## 5. B8 — 봉제/타공 등 공정 세부 param (구수/유형/모양/폭)

### 5.1 경쟁사 처리 패턴

| 항목 | RedPrinting `[RP-rev]` | WowPress `[WP-doc]` |
|------|------------------------|----------------------|
| **세부 param 담는 곳** | PCS 항목 필드: `PCS_DTL_COD`(상세) + `QTY_INPUT_YN`(수량입력 여부) + `SUB_MTRL_YN`(하위자재) | awkjob `namestep1`/`namestep2`(**1·2단계 하위옵션**) + `req_joboption`(필수조건) + `unit` |
| **필수/표시 제어** | `ESN_YN`(필수)/`VIEW_YN`(표시) 3분류(hidden=자동적용/visible/essential) | type=`select`(선택)/`radio`(필수)/`checkbox`(복수) |
| **규격 연동 제약** | `pdt_disable_pcs_info`(자재→후가공 disable 캐스케이드) | `rst_awkjob`(규격관련 후가공 제약)·`req_jobsize`·`ck_page`(전후면) |

### 5.2 후니 권위 대비 (B8) — 후니 스키마가 가장 표현력 높음

후니 `[huni]` `prcs_dtl_opt` JSON이 세부 param을 **타입·제약과 함께** 명시 보유:
- `PROC_000079 타공{구수 int 1~8}` · `PROC_000080 봉제{유형 enum:오버로크/말아박기/봉미싱, 폭 mm}` · `PROC_000081 부착{대상 enum:라벨/맥세이프/끈/테입}` · `PROC_000029 오시/030 미싱{줄수 int 0~3}` · `PROC_000031 가변텍스트{개수 int 0~3}` · `PROC_000033 박/051·052 형압{크기 number mm}` · `PROC_000014~16 코팅{면 enum:단면/양면}` · `PROC_000002 UV{변형 enum}`.
- silsa 시트(G-SL-5) 검증: 봉제/타공/족자/부착/코팅 param 실제 **정합 적재(모범)** — 후니가 이미 구현 가능 입증.

**→ 후니 적용 권고 (관리 용이성):**
1. **후니 `prcs_dtl_opt` JSON은 RP의 PCS_DTL+QTY_INPUT_YN 메타와 WP의 namestep 2단계를 한 구조에 흡수. 경쟁사 대비 부족 없음 — 기존 축 유지가 정답.** B8은 "새 패턴 도입"이 아니라 "기존 JSON 스키마를 빠짐없이 채우기".
2. **단, 후니가 경쟁사에서 보강할 한 가지: 캐스케이드 제약(자재→후가공 disable).** RP `disable_pcs_info`·WP `rst_awkjob`는 **둘 다 "규격/자재 선택 시 특정 후가공 비활성"을 데이터로 표현**한다(예 모조지80g→코팅 disable). 후니는 이 제약 테이블이 약함(constraint_json 272 전상품 미연결, §P8). **위젯 옵션 캐스케이드 정확도를 위해 후니에 "자재/사이즈 → 공정 disable" 제약 데이터를 신설 권고.** — 이건 경쟁사 둘 다 갖춘, 후니가 보강해야 할 패턴.
3. **필수/표시 제어**: RP ESN_YN/VIEW_YN, WP type(radio/select/checkbox). 후니는 택일그룹(`sel_typ_cd`·`mand_yn`)으로 일부 표현 — 공정행 레벨 "필수/숨김/자동적용" 플래그를 `prcs_dtl_opt`에 보강하면 RP 3분류와 동등.

---

## 6. variant — 색상×사이즈×두께 분해 vs 통합

### 6.1 경쟁사 처리 패턴

| 항목 | RedPrinting `[RP-rev]` | WowPress `[WP-doc]`·`[WP-cat]` |
|------|------------------------|-------------------------------|
| **차원 분해 방식** | **축별 독립 데이터셋** — material(pdt_mtrl_info)·size(pdt_size_info)·dosu(도수)·pcs 각각 별도 배열. 조합폭발 없이 축별 선택 + `disable_pcs` 캐스케이드로 불가조합 차단 | sizeno×paperno×colorno×optno **조합 키**, 가격조회 시 "옵션조합 체크 에러(인쇄 불가 조합)"로 무효조합 거름 |
| **두께/색상** | 두께=자재(material) 코드 변형, 색상=도수(dosu) 또는 별색 PCS | paperno(자재)·colorno(도수) 별 키 |
| **무효 조합 처리** | 클라 캐스케이드(disable) — 선제 차단 | 서버 가격조회 시 에러 반환 — 사후 차단 |

### 6.2 후니 권위 대비 (variant)

후니 `[huni]`: 자재=`t_prd_product_materials`(+두께 MAT_000042~044 코드), 사이즈=`t_prd_product_sizes`, 색상/별색=공정(PROC_000007 별색 자식). **축은 이미 분리 설계.** 결함은 적재 평면화 — acrylic 두께(1.5/3/8mm)를 192 단일 일괄(G-AC-3), goods-pouch 색상×사이즈 material 평면화(G-GP-3). 후니 결정(B2): **variant를 material vs size로 분리하는 일관기준 필요.**

**→ 후니 적용 권고 (관리 용이성):**
1. **RedPrinting의 "축별 독립 + 캐스케이드 disable" 모델을 채택하라(WowPress 조합키 모델보다 우월).** 이유: ① 조합폭발 없음(축별 N개 → N×M×... 행 불요) ② 무효조합을 **선제 차단**(WP는 가격조회 후 에러 — 사용자 경험·트래픽 열위) ③ 후니가 이미 축 분리 설계라 정합. **후니는 RP와 동일 철학이므로, 평면화된 적재만 풀면(두께→자재축, 색상→도수/별색축) RP 수준 도달.**
2. **두께는 자재축(material)으로, 색상은 도수/별색축으로 분해**하라(현재 평면화가 결함). MAT_000042~044(두께 코드)가 이미 있으므로 192 일괄을 풀면 됨(G-AC-3 해소).
3. **캐스케이드 disable 데이터(§5 권고2와 동일)** — variant 무효조합 차단에도 동일 제약 테이블 활용. RP `disable_pcs`가 자재→후가공뿐 아니라 자재↔사이즈 조합 제약에도 쓰임. 후니 신설 제약 데이터를 variant·후가공 양쪽에 공유 설계 권고.
4. **product-accessory(G-PA-1)는 size↔material 분기가 이미 정상** — 후니 내부에 모범 사례 존재. 이 패턴을 acrylic/goods-pouch에 전파.

---

## 7. 일반 패턴 — 제본/자재(종이)/별색/후가공

| 옵션군 | RedPrinting `[RP-rev]` | WowPress `[WP-doc]` | 후니 권위 + 권고 |
|--------|------------------------|----------------------|------------------|
| **제본** | BIND_DIRECTION(제본방향) PCS + 표지/내지 분리 | coverTypes + 후가공 jobgroup | `[huni]` 제본=공정 택일그룹(GRP-BOOK-제본, 8종 중철~레이플랫) + `prcs_dtl_opt{방향,묶음단위,책등,고리형}`. **후니가 가장 구조화 — 유지.** stationery 제본 미적재(G-ST-1)만 채우면 됨 |
| **자재(종이)** | pdt_mtrl_info(표지)+inner_pdt_mtrl_info(내지) 코드 직접 | sizeinfo·colorinfo와 별도 paperno | `[huni]` `t_prd_product_materials`+IMPORT(출력소재). **`*별도설정`→IMPORT 매핑(B1)이 결함**(digital-print 9·booklet 12·calendar). RP는 자재코드 직접명이라 IMPORT 우회 — **후니도 직접명 가능 자재는 직접 적재, 가격연동 자재만 IMPORT 포인터**(stationery/sticker/silsa는 이미 직접명 정상) |
| **별색(화이트인쇄 등)** | 별색=PCS(PRT_WHT 화이트인쇄) 또는 도수 | colorinfo addtype | `[huni]` 별색=**공정**(PROC_000007 부모 + 화이트008 등 자식, SEL_TYPE.02 다중). sticker 투명/홀로그램 화이트별색 미적재(G-SK-1)·silsa(G-SL-2)만 채우면 됨. **후니의 "별색=공정 분기"가 RP의 "별색=PCS 또는 도수 혼재"보다 일관** — 유지 |
| **후가공 필수/선택** | ESN_YN/VIEW_YN 3분류 | type radio/select/checkbox | §5 권고3 — 후니 `prcs_dtl_opt`에 필수/표시 플래그 보강 시 동등 |
| **수량단위** | unit(권/개/장/매) 필수 메타 | meta.unit 필수 | `[huni]` QTY_UNIT 272 NULL → **일괄 부여(B7)**. 경쟁사 둘 다 필수화 |

---

## 8. buysangsang 보조 관찰 `[BS]`

buysangsang은 후니프린팅 자체 운영 WP+Woo+Elementor 사이트(리뉴얼 대상). 상품 옵션이 **WooCommerce variation / Product Add-ons / 커스텀 견적 폼에 분산**되어 있어, 본 문서의 B3~B8 적재정책(정규화 공정/사이즈 축) 관점에서는 **신호가 약하다.** RP/WP가 옵션을 구조화 데이터로 노출하는 반면 buysangsang은 빌더 위젯·variation 매트릭스로 표현 → "후니 정규화 DB로 어떻게 담을지"의 직접 참조가치 낮음. **결론: B3~B8 적재정책은 RedPrinting(축 분리·공정 param) + WowPress(제약 조건 모델)를 권위 참조로, buysangsang은 제외.** (이는 메모리 `shopby-excluded-from-scope`·As-Is 역공학 3목적 게이트와 정합 — 답습용 전수수집 금지.)

---

## 9. 종합 — 후니 세부정책별 최종 권고 (관리 용이성 우선)

| 정책 | 경쟁사 핵심 패턴 | **후니 권고 (권위=후니 엔티티)** | 우선순위 |
|------|-----------------|----------------------------------|:--------:|
| **B3 형상/커팅** | RP: 모양=PCS+shape_info 2중 / WP: 사이즈 non_standard 플래그 | **모양=공정 `prcs_dtl_opt.모양`(기존 유지) + 치수=사이즈축, 둘을 캐스케이드 연동. 자유형 min/max 슬롯 채우기.** 경쟁사 답습 불요(후니가 더 명확) | High |
| **B5 페이지/책등** | RP: MIN/MAX_PAGE+inner분리 / WP: pageConstraints{min,max,interval} | **page_rule에 interval 명시(경쟁사 둘 다 보유). 표지/내지=usage_cd 유지. 책등=제본 param(이미 보유) 채우기.** | Medium |
| **B6 묶음/조각수** | RP/WP **명시 슬롯 없음**(가격표 흡수) | **후니 `prcs_dtl_opt.조각수`가 가장 명시적 — 기존 축 유지. unit 일괄부여(B7).** | Medium |
| **B8 봉제/타공 param** | RP: PCS_DTL+QTY_INPUT_YN / WP: namestep 2단계 | **후니 `prcs_dtl_opt` JSON이 이미 흡수 — 빠짐없이 채우기. 신규 도입 불요.** | Medium |
| **variant 분해** | RP: 축별 독립+disable캐스케이드(우월) / WP: 조합키+사후에러 | **RP의 축 독립 모델 채택(후니와 동일 철학). 평면화 해소(두께→자재축, 색상→도수축).** | High |
| **(보강) 캐스케이드 제약** | RP `disable_pcs` / WP `rst_awkjob` — **둘 다 보유** | **후니 약점 — "자재/사이즈→공정 disable" 제약 데이터 신설 권고(위젯 옵션 정확도). variant·후가공 공유.** | High |
| **제본/별색** | RP: 혼재 / WP: 혼재 | **후니 "제본=택일그룹+param", "별색=공정 분기"가 가장 일관 — 유지, 미적재만 채우기.** | High |

**한 줄 요약:** 후니 DB 스키마(`prcs_dtl_opt` JSON·공정 트리·코드그룹·택일그룹)는 **RedPrinting·WowPress의 세부정책 표현력을 이미 흡수했거나 능가**한다. 벤치마킹 결론은 "경쟁사 패턴을 후니에 이식"이 아니라 **"후니 기존 축을 권위로 유지하고 미적재 행을 채우되, 단 한 가지 — 캐스케이드 제약(자재/사이즈→공정 disable)만은 경쟁사(RP disable_pcs·WP rst_awkjob)에서 보강하라"**이다. variant는 RedPrinting의 "축 독립 + 선제 disable" 철학(후니와 동일)을 따르고 WowPress의 조합키 모델은 채택하지 말 것.

---

## 부록 — 출처 라인 인덱스

- `[RP-rev]` option-schema-catalog.json: 책자 MIN_PAGE/MAX_PAGE(L99-100), inner분리(L19-22 .md), 아크릴 option_info(L680-699), disable_pcs(L662-678). s2-sticker-capture.md: THO_DFT 모양커팅 17종·CUT_DFT 묶음/개별·FixedUnit 시트단위. 05_code_pattern_transfer: 캐스케이드 disable·debounce.
- `[RP-live]` benchmark-evidence/2026-06-05/redprinting-STTHCIC-live.md (WebFetch 1건, read-only).
- `[WP-doc]` wowpress-api-document.txt: §7.1 sizeinfo non_standard/req_width/rst_awkjob(L2837-2918), §7.2 colorinfo(L2921+), §7.4 awkjobinfo namestep1/2·req_joboption·rst_awkjob(L3176-3355).
- `[WP-cat]` catalog/products: 40200 책자 coverTypes/pageConstraints{min4,max4,interval1}, 40017 도무송스티커 non_standard sizeNo.
- `[huni]` db-domain-structure-live.md §2-4 prcs_dtl_opt(L153-172)·§3 코드그룹(L186-201)·§4 택일그룹(L208-225). 08_remediation: sticker.md(형상enum G-SK-2)·acrylic.md(조각수 G-AC-2·두께 G-AC-3)·_summary.md(B1~B9 통합주제).
- **새 라이브 SELECT 0(huni DB)** — huni 권위는 기존 라이브 규명 문서 인용. RedPrinting 라이브 1건만 신규(저트래픽).
