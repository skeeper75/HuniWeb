# 가격 매핑 최종 종합 검증 — 면적 3시트 + 전 15시트 적재 준비 (round-2 final)

검증자: dbm-validator (설계자 독립, 적대적 자세) · 권위: dbm-price-formula SKILL 규칙 1~10 + L1 무손실 원본(`06_extract/price-*-l1.csv`) + 라이브 DB(read-only SELECT만)
검증 대상: `02_mapping/load_price/t_prc_component_prices.csv` **4805행** + 공식배선(price_formulas 10·price_components 143·formula_components 13·product binding 45·cod_base_codes)
신규 검증: **면적 3시트**(포스터사인 785행·아크릴 M-1 정정·박 GAP). 비면적 7시트·파일럿 5시트는 누적 검증(wave2·pilot) 결과 종합.
[HARD] 본 검증 중 DB 쓰기(INSERT/UPDATE/DDL) **0건**. 라이브는 read-only SELECT만. 비밀번호 stdout 미노출.
검증 스크립트: `03_validation/scripts/_final_poster.py`·`_final_poster2.py`·`_final_constraints.py`(재현 가능).

---

## 0. 최종 판정 (요약)

### NO-GO (조건부) — 매핑 무결성은 GO, 적재는 1 BLOCKER 보정 + 후니 등록 선행 필요

| 차원 | 판정 | 핵심 |
|------|------|------|
| **면적 3시트 적대검증** | **PASS(보정 1건)** | 포스터 완전성 100%(L1 785셀=적재 785, 누락0·발명0)·아크릴 M-1 정정 정확(DIRECT 47 라이브 확증)·박 GAP 정당 에스컬레이션(억지평면화 0). **단 comp_cd varchar(50) 초과 2종 BLOCKER 신규 적발** |
| **매핑 변환 무결성** | **GO** | C-1~7 위반 0·자연키8 중복 0·고아 comp 0·날조 0·침묵드롭 0·과소적재 0·발명 0 |
| **적재 가능성** | **NO-GO(조건부)** | 즉시 적재가능 2108행 / placeholder FK 차단 2697행 / +comp_typ.06 코드행 미등록 / +comp_cd 길이초과 2행 |

**즉시 보정 필요 BLOCKER**: **B-FINAL-1** comp_cd varchar(50) 초과 2종(현수막 각목옵션) — 적재 시 INSERT 실패(코드 단축 필요).
**적재 선행 조건(후니 등록 = blocker이나 설계 정당)**: ① siz_cd placeholder 2697행 후니 등록 ② `PRC_COMPONENT_TYPE.06` 코드행 선적재 ③ 박 GAP 모델링 후니 결정.

---

## (A) 면적 3시트 적대검증

### A-1. 포스터사인 (785행) — PASS (완전성·날조·발명 무결)

**핵심: 떡메모지式 블록 통째 누락 재발 0. L1 셀단위 multiset 완전 일치.**

#### A-1-1. 전수 완전성 (블록 누락 점검 — 떡메모지 전례)
검증 절차(`_final_poster2.py`): L1 `price-poster-sign-l1.csv`의 A열 제외 전 숫자셀을 헤더 echo·0원 baseline·실가격으로 분류 → 적재 785행과 multiset 대조.

| L1 숫자셀 분해 | 셀수 | 처리 | 판정 |
|---------------|------|------|------|
| 헤더 echo(가로/세로·사이즈/수량 헤더행) | 0 | — | 식별 정확(A열 제외로 이미 걸러짐) |
| **0원 baseline 셀** | **11** | 적재 제외(메인포함=추가없음/재단만) | **정당**(잉여 방지). B17/B19/B21/B23 거치대없음·B26/B27 추가없음 N246=0 등 |
| **실가격 셀(>0)** | **785** | 적재 785행 | **완전 일치** |
| **합계** | **796** | = 11 + 785 | — |

- **multiset 대조**: 실가격셀 785 vs 적재 785 → **과소적재 0·과다적재(발명) 0**(`_final_poster2.py` 출력: 부족 0·초과 0).
- **31블록 전수 점검**: 22개 가격블록(B01~B11·B13~B31의 SIZEQTY/현수막) 전건 가격값 적재됨(저커버 블록 0). LABEL 블록(B12/B14/B16…)은 메타라 가격셀 0 — 정당.
- **떡메모지式 누락 0**: 설계자 self-check "L1 785 = 적재 785"가 **독립 재현으로 확증**. 블록 통째 누락 재발 없음.

#### A-1-2. 실무진 메모 해석 정확성·날조 (L1 원본 셀텍스트 대조, ≥8셀)
| 항목 | 적재 | L1 원본 셀 | 판정 |
|------|------|-----------|------|
| 족자 천정형고리 | 6500 / **bdl_qty=2** | B17 K213=6500, **L213="*2개 1세트"** | **PASS** — 세트단위 2 날조 아님(원문 실재) |
| 현수막 각목(900이하)+끈 | 4000 | B26 M249="각목(900mm이하)+끈(4개)", N249=**4000** | PASS — 이하/초과 조건분리 정확 |
| 현수막 각목(900초과)+끈 | 8000 | B26 M250="각목(900mm 초과)+끈(4개)", N250=**8000** | PASS — 침묵충돌 방지 슬러그 분리 |
| 현수막 타공 4/6/8 | 3000/4000/5000 | B26 K247/K248/K249 | PASS |
| 현수막 열재단·양면테잎·봉미싱·큐방·끈 | 3000·3000·4000·3000·4000 | B26 K246/K250/K251·N247/N248 | PASS |
| 배너거치대 실내/실외단면/실외양면 | 7000/23000/25000 | B23 K232/K233/K234 | PASS |
| 우드행거+면끈 A4/A3/A2 | 16000/18000/20000 | B19 K219/L219/M | PASS(siz=A4/A3/A2 라이브 확증) |
| 우드봉+면끈 A4/A3/A2 | 7000/9800/12000 | B21 K225/L226/M | PASS |
| 메인=포함가 | .06 완제품비 통가격 | B01 F1 "코팅포함가"·B11 "출력+코팅+가공 포함가"·B16 "출력+코팅+가공 포함가" | PASS — 분해 안 함(규칙④⑩) |

**날조 0**: 포함항목("출력+코팅+가공")·세트단위("2개1세트")·이하/초과 조건 전건 L1 원본 실재. 없는 의미 발명 0.

#### A-1-3. FK 부모 (라이브 read-only SELECT)
| FK | 검증 | 결과 |
|----|------|------|
| product binding 28 prd_cd | PRD_000118~145 | **28/28 라이브 실존**·prd_nm 정합(아트프린트포스터/폼보드/족자포스터/일반현수막/유광아크릴스티커) |
| 포스터 실코드 siz_cd 15종 | SIZ_000028/258/315/317… | **15/15 실존**·의미 정합(258=A4·315=A3·317=A2 추가옵션 사이즈) |
| clr_cd | 전건 NULL | 규칙① 준수(통가격·별색없음) |
| comp_typ_cd | 전건 `.06` 완제품비 | **.06 라이브 미등록**(단계0 blocker, 아래 B 참조) |

판정: **포스터 PASS** — 완전성·날조·발명·FK 전부 무결. (단 길이초과 2행은 §B-FINAL-1.)

---

### A-2. 아크릴 M-1 정정 검증 — PASS (DIRECT 47 라이브 확증·dodge 해소 정확)

설계자 정정(`price-code-proposals.md §14`): DIRECT 47=실코드 교체, REVERSED 21+NONE 128=placeholder 유지.
적재 현황: ACRYL 358행 = **실코드 121행(47 distinct siz_cd) + placeholder 237행(149 distinct)**.

#### A-2-1. 매칭표 자체 정합 (`_acryl_siz_match.csv` 196 좌표)
- DIRECT 47: **live_siz_nm == WxH 정방향 전건 일치**(불일치 0).
- REVERSED 21: **live_siz_nm == HxW 역방향 전건 일치**(불일치 0).
- 적재 실코드 47 distinct == 매칭표 DIRECT 47 (차집합 0 양방향).
- placeholder 149 distinct == REVERSED 21 + NONE 128 (정확).

#### A-2-2. 라이브 권위 대조 (read-only SELECT)
| 검증 | 결과 | 판정 |
|------|------|------|
| DIRECT 47 siz_cd 라이브 실존 | **47/47** (20x20=SIZ_000336·30x30=SIZ_000330·100x100=SIZ_000113·90x50=SIZ_000008·70x70=SIZ_000211·50x30=SIZ_000493) | **PASS** — 정방향 siz_nm 정확·발명 0 |
| REVERSED 21 **정방향(WxH)** 라이브 실존 | **0/21** | **PASS** — 정방향 부재 확증, 역방향만 존재 → placeholder 유지 정당(의미축 HxW 위험, under-match dodge 아님) |
| NONE 128 표본 20종 라이브 실존 | **0건** | **PASS** — 정당 부재(등록대기, 발명 금지) |

판정: **아크릴 M-1 정정 PASS**. wave1/pilot의 "전수 placeholder dodge" 결함이 정확히 해소(47 실코드 재사용). 또 다른 부분 dodge 재발 0. 149 placeholder = 진짜 라이브 부재(REVERSED 정방향 21 + NONE 128).

---

### A-3. 박(소형/대형) GAP — PASS (정당 에스컬레이션, 억지평면화·침묵드롭 0)

검증: 박 시트(`foil-small`/`foil-large`)의 component_prices·formula·binding 적재 여부.

| 항목 | 적재 | 판정 |
|------|------|------|
| COMP_FOIL_* (박 가공비/동판비) | **0행** | 통째 미산출 |
| price_formulas FOIL | 0 | 미배선 |
| product binding FOIL | 0 | 미바인딩 |

**판정: 정당 에스컬레이션(BLOCKED-LEGIT)**.
- 박 가공비는 진짜 2단 룩업(면적→분류A~E→가격)이라 6차원 직접 평면화 시 중간키(분류 A~E) 슬롯 부재 → 의미 왜곡. 설계자가 **억지 평면화하지 않고** 3안(mat_cd차용/면적직접/2테이블) + 사용자 결정 에스컬레이션(`schema-fitgap-price.md §4-3`)으로 처리. **억지 평면화 0·침묵드롭 0·발명 0**.
- **단 미검증 정직 표기**: 동판비(B01, 가로×세로→단가 2D)는 아크릴형 ADEQUATE라 즉시 처리 가능 후보였으나 **이번 미산출**(GAP 결정 선결). `COMP_NAMECARD_FOIL_*`(명함 박, 별개 시트)는 적재됨(.06 38행) — 박 *시트*와 혼동 금지. 작업지시의 "COMP_FOIL 38행"은 사실상 **명함박(NAMECARD_FOIL)이며 박 시트(foil-small/large)는 0행**.

박 GAP은 후니 결정(분류등급 입력 UI vs 면적입력 UI) 전 적재 보류가 정당.

---

## (B) 전 15시트 적재 준비 종합

### B-1. 적재 순서 (FK 위상)

`price-engine-ddl.md §3` 기준 적재 단계:

| 단계 | 대상 | 내용 | 현 상태 |
|------|------|------|---------|
| **0. 부모코드** | `t_cod_base_codes` | `PRC_COMPONENT_TYPE.06` 완제품비 코드행 INSERT(부모 PRC_COMPONENT_TYPE 존재) | **라이브 미등록 → 선적재 필수** |
| **0. 후니 siz 등록** | `t_siz_sizes` | placeholder 2697행분 siz_cd(군별, 아래 B-2) | **미등록 → 적재 차단** |
| **1. 공식·구성요소** | `t_prc_price_formulas`(10) · `t_prc_price_components`(143) | frm_cd·comp_cd 카탈로그 | CSV 산출 완료 |
| **2. 단가·배선** | `t_prc_component_prices`(4805) · `t_prc_formula_components`(13) | 단가행·공식↔구성요소 | CSV 산출 완료(단 길이초과 2행·placeholder FK) |
| **3. 상품 바인딩** | `t_prd_product_price_formulas`(45) | prd_cd↔frm_cd | CSV 산출 완료(전건 라이브 prd 실존) |

FK 위상 정합: 단계0 → 1 → 2 → 3 순서가 모든 FK 의존(comp_typ←components, comp←component_prices·formula_components, frm←formula_components·binding, siz/mat/clr←component_prices)을 충족.

### B-2. 후니 등록 필요 목록 (적재 blocker — 설계 정당, 발명 금지)

| 군(placeholder) | 행수 | distinct | 내용 | 후니 등록 시 해소 |
|----------------|------|----------|------|------------------|
| `SIZ_PENDING_GUK4` | 870 | 1 | 국4절 출력판형(코팅·디지털·완칼) | 출력판형 siz 등록 |
| `SIZ_PENDING_POSTER` | 680 | 113 | 대형 포스터 면적좌표(600mm~·A1·inch액자·REVERSED) | 면적좌표 siz 등록 or 면적함수 결정 |
| `SIZ_PENDING_STK` | 456 | — | 스티커 판수규격(A4_1P 등)·B3/B4·100x148 | 판수결합·B규격 siz 등록 |
| `SIZ_PENDING_3JEOL` | 304 | 1 | 3절 출력판형 | 출력판형 siz 등록 |
| `SIZ_PENDING_ACRYL` | 237 | 149 | 아크릴 면적(REVERSED 21·NONE 128) | 면적좌표 siz 등록 or 면적함수 결정 |
| `SIZ_PENDING_GP`(원형) | 110 | 11 | 합판도무송 원형 직경 | 직경 siz 등록(의미축 별도) |
| `SIZ_PENDING_ENV` | 40 | 4 | 봉투종류(티켓/소/자켓/대봉투) | 봉투규격 siz 등록 |
| **siz 소계** | **2697** | — | — | — |
| `PRC_COMPONENT_TYPE.06` | (전 .06 comp 간접) | 1 | 완제품비 코드행 | 코드마스터 INSERT |

### B-3. 적재 가능 vs 차단 행수

| 구분 | 행수 | 근거 |
|------|------|------|
| **즉시 적재가능** (실코드 siz 1313 + NULL siz 795) | **2108** | FK siz/mat/clr 전건 라이브 실존 확증 |
| └ 단, comp_cd 길이초과로 차단되는 분 | **−2** | B-FINAL-1(현수막 각목 2행) |
| └ 실질 즉시 적재가능 | **2106** | — |
| **placeholder siz_cd FK 차단** | **2697** | 후니 siz 등록 후 해소 |
| 합계 | **4805** | — |

### B-4. C-1~9 제약 + FK (전수 4805행)

| 제약 | 결과 | 증거 |
|------|------|------|
| C-1 comp_price_id 중복 | **0** | 4805행 유니크 |
| C-2 자연키8 중복 | **0** | (comp,apply,siz,clr,mat,coat,bdl,min) 전건 유니크 — 면적분 포함 재검 |
| C-3 apply_ymd 통일 | **0 위반** | 전건 `2026-06-01`(규칙⑦) |
| C-4 unit_price 비숫자/공란 | **0** | 전건 numeric |
| C-5 comp_cd/apply_ymd NOT NULL | **0 위반** | 전건 충족 |
| C-6 별색/포스터 clr_cd 위반 | **0** | SPOT/POSTER comp 전건 clr=NULL(규칙①) |
| **C-7 varchar 길이** | **위반 2(comp_cd)** | comp_cd 최장 **55자 > 컬럼 varchar(50)** → **B-FINAL-1 BLOCKER**. siz_cd 28≤50·clr_cd 10≤50·mat_cd 10≤50·note 124≤500 OK |
| C-8 고아 comp | **0** | component_prices 141 distinct comp_cd 전건 price_components(143) 정의 |
| FK siz_cd(실코드 99 distinct) | **0 부재** | 라이브 t_siz_sizes 99/99 |
| FK mat_cd(12) | **0 부재** | 라이브 t_mat_materials 12/12 |
| FK clr_cd(CLR_000002/000005) | 실존 | t_clr_color_counts(1도흑백·CMYK4도) |
| FK comp_typ `.06` | **부재** | 라이브 .01~.05만(.05 박형압비 존재) → 단계0 등록 |

### B-5. 15시트 종합 대시보드

도메인별 행수/실코드/placeholder/NULL (component_prices 4805행 전수):

| 도메인(시트) | 행수 | 실코드siz | placeholder | NULLsiz | 즉시적재 | blocker | 검증 |
|-------------|------|----------|------------|---------|---------|---------|------|
| POSTER(main) | 760 | 80 | 680 | 0 | 80 | siz 등록 | **A-1 PASS** |
| POSTER(opt) | 25 | 6 | 0 | 19 | 25 | **길이초과 2** | **A-1 PASS(보정1)** |
| ACRYL | 358 | 121 | 237 | 0 | 121 | siz 등록 | **A-2 PASS** |
| STICKER | 716 | 260 | 456 | 0 | 260 | siz 등록 | wave2 PASS |
| SPOT(별색) | 530 | 0 | 530 | 0 | 0 | siz 등록 | pilot PASS |
| PCB(엽서북+떡메) | 468 | 468 | 0 | 0 | 468 | — | wave2 PASS(B-1해소) |
| DIGITAL | 424 | 0 | 424 | 0 | 0 | siz 등록 | pilot PASS |
| GANGPAN | 370 | 260 | 110(원형) | 0 | 260 | siz 등록(원형) | wave2 PASS(dodge해소) |
| FOLDING | 336 | 0 | 0 | 336 | 336 | — | wave2 PASS |
| POSTPROC(후가공) | 216 | 0 | 0 | 216 | 216 | — | pilot PASS |
| COATING | 184 | 0 | 184 | 0 | 0 | siz 등록 | pilot PASS |
| TTEOKME(떡메) | 112 | 112 | 0 | 0 | 112 | — | wave2 PASS(B-1) |
| CUTTING | 77 | 0 | 36 | 41 | 41 | siz 등록(36) | wave2 PASS |
| BINDING | 74 | 0 | 0 | 74 | 74 | — | wave2 PASS |
| NAMECARD(+박) | 63 | 4 | 0 | 59 | 63 | — | wave2 PASS(B-2) |
| PHOTOCARD | 52 | 2 | 0 | 50 | 52 | — | wave2 PASS(B-2) |
| ENVELOPE(봉투) | 40 | 0 | 40 | 0 | 0 | siz 등록 | pilot PASS |
| **합계** | **4805** | **1313** | **2697** | **795** | **2108** | — | — |
| ~~FOIL(박 시트)~~ | **0** | — | — | — | — | **GAP 에스컬레이션** | **A-3 정당보류** |

---

## (C) 결함 목록 (severity)

### BLOCKER
- **B-FINAL-1 (신규 적발) comp_cd varchar(50) 초과 2종**:
  `COMP_POSTEROPT_BANNER_NORMAL_ADD_GAKMOK_STRING_900_4_LE`(55자)·`_GT`(55자). 컬럼 `t_prc_component_prices.comp_cd`·`t_prc_price_components.comp_cd` 모두 **varchar(50)** → 적재 시 `value too long` INSERT 실패. price_components 카탈로그엔 부모 `..._GAKMOK_STRING_900_4`(51자)도 초과 3종. **수정**: 코드 단축(예: `..._GAKMOK_900LE`/`_900GT` 또는 `GKM`). component_prices·price_components·formula_components 동시 갱신.

### 적재 선행 조건 (설계 정당 — blocker이나 결함 아님)
- **comp_typ `PRC_COMPONENT_TYPE.06` 라이브 미등록**: 전 .06 완제품비 comp의 FK 부모. 단계0 코드행 선적재(라이브 .05까지만 확증). `t_cod_base_codes.csv` 산출됨.
- **siz_cd placeholder 2697행 FK 차단**: 후니 siz 등록 대기(B-2 군별). 발명 금지 준수 — 정당.
- **박 GAP 적재 보류(BLOCKED-LEGIT)**: 면적→분류 중간 룩업표 정착지 후니 결정 선결(A-3).

### MAJOR
- (없음 — wave2 M-1 GANGPAN dodge·M-2 STK dodge·아크릴 부분 dodge 전건 보정 완료 확증)

### MINOR
- **formula_components 부분 배선**: 포스터=대표 COMP_POSTER_ARTPRINT_PHOTO 1배선(단순형 직접 룩업이라 정당). 단순형 시트의 component 전체 조합은 상품 매핑 단계 위임 — 의존성 문서화됨.
- **박 동판비 미산출**: B01 동판비(2D 매트릭스)는 ADEQUATE라 즉시 처리 가능했으나 GAP 결정 선결로 미산출. 정직 표기.
- **가산규칙 메모 미반영**: CUT "1구는 100장당 1000원씩"·PCB "3000개 초과 마지막구간 곱" 등 가격로직 메모는 공식외부 처리 위치 명시 필요(누적 MINOR 유지).

---

## (D) 최종 GO/NO-GO

### 매핑 설계물 무결성: **GO**
역대조 면적 3시트 100%(포스터 785셀 multiset 완전·아크릴 DIRECT 47 라이브 확증)·C-1~8 위반 0(길이초과 제외)·자연키8 중복 0·고아 comp 0·날조 0·침묵드롭 0·과소적재 0·발명 0·dodge 재발 0. wave2 BLOCKER(떡메 B-1·포토카드 B-2) 해소 확증(112+2행).

### 적재: **NO-GO (조건부)**
적재 게이트(순서대로):
1. **[즉시 보정]** B-FINAL-1 comp_cd 길이초과 2종 단축(50자 이내).
2. **[후니 등록]** `PRC_COMPONENT_TYPE.06` 코드행 선적재.
3. **[후니 등록]** placeholder siz_cd 2697행 후니 siz 등록(군별 B-2) → FK 해소.
4. **[후니 결정]** 박 GAP 모델링 택일(또는 동판비만 우선) 후 박 시트 적재.

**현 상태 즉시 적재가능 행수 = 2106행**(실코드 1313 + NULL 795 − 길이초과 2). 나머지 2697행은 후니 siz 등록 후, 박 시트는 GAP 결정 후.

1번(길이초과 2종 단축)만 보정하면 **매핑물 자체는 GO 전환**. 적재 전량 GO는 후니 등록(2·3) + 박 결정(4) 충족 시.

---

## (E) 미검증 항목 (정직 표기)

- **DRY-RUN 트랜잭션 적재**: 미수행(lead 미승인 + B-FINAL-1·placeholder FK로 위반 자명). 로컬 제약 검증 + 라이브 FK 전수 조회로 대체.
- **포스터 LABEL+SIZEQTY 쌍의 LABEL 상속 정확성**: 가격값 multiset은 완전 일치 확인했으나, 각 SIZEQTY 블록이 올바른 LABEL(소재)에 귀속됐는지 1:1 쌍 매핑은 미정밀(블록 인접성 기반 — 값 일치로 간접 확증).
- **박 동판비 좌표↔라이브 siz 매칭표**: 미추출(GAP 결정 선결로 박 시트 자체 미산출).
- **상품 바인딩 실효성**: prd_cd 라이브 실존·prd_nm 정합까지(상품 옵션·MES 연계 미검증).
- **가격 recompute(주문 시나리오)**: 면적분은 단순형 직접 룩업이라 component_prices 값 자체가 최종가 — 합산 recompute 불요. 합산형(접지/제본)은 상품 매핑 단계 의존.
