# round-2 가격 적재 검증 보고 — 평면화 파일럿 5시트

검증자: dbm-validator (독립·적대적). 권위: dbm-price-formula 규칙 1~10 · `00_schema/price-engine-ddl.md` · L1 무손실 원본(`06_extract/price-*-l1.csv`) · **라이브 DB(read-only SELECT만, 쓰기 0)**.
검증 대상: `02_mapping/load_price/*.csv` — component_prices(1752행)·price_components(32)·price_formulas(1)·formula_components(1)·product_price_formulas(1)·cod_base_codes(1).
[HARD] 본 검증 중 DB 쓰기(INSERT/UPDATE/DDL) 0건. 라이브는 read-only SELECT 2회만. 비밀번호 stdout 미노출.

---

## ① 최종 판정: CONDITIONAL-GO (조건부 GO)

매핑 변환 자체는 **무결**(역대조 5시트 100%, recompute 일치, 제약 위반 0, 발명·침묵드롭·과소적재 0). 그러나 **현 상태 그대로 적재 시 1536행 FK 위반**. 적재 게이트:
- (전제1) 후니 `t_siz_sizes`에 국4절/3절/봉투4종 siz 등록 + 아크릴 면적 좌표 결정 후 placeholder 치환.
- (전제2) `PRC_COMPONENT_TYPE.06` 코드행 선적재(라이브 미등록 확증).

전제 충족 전에는 **NO-GO(적재)**, 매핑 설계물로서는 **GO(무결)**. 즉시 적재 가능 행은 후가공 216행뿐.

---

## ② siz_cd placeholder 군별 판정표 (a/b/c)

placeholder 정확 집계(`02_mapping/load_price/t_prc_component_prices.csv` 전수, csv 파서):
- 전체 1752행 중 placeholder **1536행(87.7%)**, NULL siz 216행(후가공), **실코드 siz 0행**.
- 분포: `SIZ_PENDING_GUK4` 834 · `SIZ_PENDING_3JEOL` 304 · `SIZ_PENDING_ACRYL_*` 358행(유니크 좌표 196종) · `SIZ_PENDING_ENV_*` 40(4종).

| 군 | 적재행 | 유니크 | 라이브 실재(SELECT 결과) | **판정** | 근거(파일:행/라이브) |
|----|--------|--------|--------------------------|----------|----------------------|
| **GUK4 (국4절)** | 834 | 1 | **0행** — t_siz_sizes(500행)에 siz_nm/note "절/국전/국4/46전" 일치 0 | **(a) 정당 blocker** | L1 `06_extract/price-coating-l1.csv:1`("코팅(국4절)"=블록 **title**), `:5`(row_key="수량(국4절)"=출력매수). 라이브 SELECT: 국4절/3절 siz 0행. dodge 아님 |
| **3JEOL (3절)** | 304 | 1 | **0행** | **(a) 정당 blocker** | L1 `price-coating-l1-meta.csv` B02 title="코팅(3절)" · `price-digital-print-price-l1-meta.csv` B02 title="...출력비(3절)". 라이브 0행. F2 노트 "3절 별색 상품 없음" 정합(별색 leaf 부재) |
| **ACRYL (아크릴 면적)** | 358 | 196 | **47/196 실재** (예: 20x20=SIZ_000336, 100x100=SIZ_000113, 30x30=SIZ_000330) | **(b) 부분 dodge + (c) 모델링 의심** | `t_prc_component_prices.csv:1139`(SIZ_PENDING_ACRYL_20x20=2500). 라이브 SELECT: 196 좌표 중 47종이 siz_nm=NNxNN으로 실존. 아래 ④ 상술 |
| **ENV (봉투종류)** | 40 | 4 | **0행** — "봉투/티켓/자켓" siz 0 | **(a) 정당 blocker** | `t_prc_component_prices.csv:1713~1752`(ENV_TICKET/SMALL/JACKET/LARGE). 봉투종류=siz 차원 적정(소재=mat 정확). 라이브 0행 |

> 작업지시의 "ACRYL 202종"은 실제 **196 유니크 좌표**(placeholder 행수 358=투명3T 196+투명1.5T 81+미러3T 81). 수치 정정 필요(MINOR).

---

## ③ 국4절/3절 = siz_cd인가 plate_size인가 판정

**판정: 출력판형(plate context)이지 완성품 규격(siz_cd 본래 의미)이 아니다. 단 후니 스키마상 plate도 결국 t_siz_sizes.siz_cd로 표현되므로, siz_cd 차원 귀속 자체는 "차원 오용"은 아니나 "출력판형용 siz 미등록"이 본질.**

근거:
- `00_schema/ref-product-plate-sizes.csv:1` 헤더 = `prd_cd,siz_cd,dflt_plt_yn,output_paper_typ_cd,...` → **`t_prd_product_plate_sizes`는 별도 사이즈 테이블이 아니라 `siz_cd`(=t_siz_sizes)를 재사용**한다. 즉 "출력판형"도 siz_cd로 표현됨(예: PRD_000016이 SIZ_000112~118을 plate로 보유).
- L1 `06_extract/price-coating-l1.csv:1`·`price-digital-print-price-l1.csv` 헤더행에서 "국4절/3절"은 **블록 title**이며 수량행 라벨은 "수량(국4절)"=출력매수(print-sheet count, `price-engine-ddl.md:116` 정합).
- 따라서 국4절/3절은 "완성품 1매 규격"이 아니라 **출력 1판(판형) 단위 규격**이고, 단가시트의 단가는 "판당 단가 × 출력매수"로 곱해진다(`schema-fitgap-price.md:36` (4) 코팅비 공식).
- `00_schema/ref-sizes.csv`에는 국4절/3절 siz 부재(전부 73x98 등 cut 치수 + "판걸이=N / 전지=316x467" 메타). 라이브 SELECT도 0행.

**결론**: 국4절/3절을 siz_cd 차원에 두는 것은 **표현 가능**(plate도 siz_cd 재사용 스키마). 단 ref-sizes에 해당 출력판형 siz가 미등록 → **(a) 정당 blocker**. 설계자의 M-4(국4절/3절=siz_cd placeholder)는 차원 오용 아님. 다만 후니 등록 시 siz_nm을 "국4절(316x467 전지 기준 출력판형)" 형태로 명시하고, 완성품 규격 siz와 의미 혼동 없도록 note 권고.

---

## ④ 아크릴 면적 196 siz_cd 적정성 (ADEQUATE vs GAP 재판정)

설계자 분류: ADEQUATE-WITH-PROPOSALS(P-1 에스컬레이션). **재판정: ADEQUATE-WITH-PROPOSALS 유지하되, "부분 dodge(MAJOR)"를 명시 추가.**

검증 사실:
- L1 `06_extract/price-acrylic-price-l1.csv:2` 헤더가 transposed 인코딩(B2 셀 band_header_path="20mm > 2500.0 > 2700.0 > ..."). 적재 CSV `t_prc_component_prices.csv:1139`(20x20=2500)·`:1140`(30x20=2700)와 디코드 일치 → **역대조 PASS**.
- 미러=투명×2: `:1416`(미러20x20=5000=투명2500×2 data_only값 그대로) — 파생 동적계산 안 함, L1 value 변조 0(규칙 준수).
- **부분 dodge(MAJOR)**: 라이브 SELECT 결과 196 좌표 중 **47종이 이미 siz_nm=NNxNN으로 실존**(20x20=SIZ_000336, 100x100=SIZ_000113…). 설계자는 196 전수를 `SIZ_PENDING_ACRYL_*`로 일괄 발명 — **siz_nm 정확매칭 탐색을 안 한 dodge**. 47종은 placeholder가 아니라 기존 siz_cd 재사용 가능했음.
- **(c) 의미 함정**: 그 47 실재 siz는 대부분 **다른 상품 용도**로 등록됨(라이브 note "적용=반칼스티커/인쇄해더택/명함/라벨택"). 같은 치수라도 아크릴 면적과 의미축이 달라 단순 재사용은 위험.

판정 종합:
- **6차원 표현 가능성 = ADEQUATE**(siz_cd 차원으로 면적 좌표 표현 가능, GAP 아님). 박 시트(foil)의 "면적→분류 A~E 2단 룩업" 같은 차원 슬롯 부재는 아크릴엔 없음.
- 그러나 **(b)+(c)로 "현 placeholder 적재"는 부적정**: 47종은 실코드 재사용 검토, 149종은 신규 등록 또는 면적함수 모델 결정 필요. "직접입력형"(사용자 가로/세로 입력) 특성상 196 고정좌표 등록보다 면적함수가 적합할 수 있어 **P-1 에스컬레이션 정당** — 단 "47종 기존재" 사실을 명시하지 않고 일괄 placeholder로 가린 것이 결함.

**수정제안**: ① 아크릴 196 좌표 ↔ 라이브 siz_nm 정확매칭표 추출(47 재사용 후보 식별, 발명 회피) → ② 의미 검토(아크릴 전용 필요 여부) → ③ 면적함수 모델 vs 좌표 등록 후니 결정. 현 placeholder는 "결정 보류 표식"으로만 유효.

---

## ⑤ 엑셀↔long-format 역대조 (시트별 일치율 + 샘플 인용)

| 시트 | 적재행 | 떠본 셀(L1 → 적재) | 일치율 | 결과 |
|------|--------|---------------------|--------|------|
| **코팅** | 184 | `coating-l1.csv` B4=2000→`comp_prices.csv:1`(MATTE,coat=1,min=1,2000) · C4=4000→`:2`(coat=2) · B5=1500→`:5`(min=2) · B34=3000(3절무광단면q1)→3절 블록 | **100%** | coat_side_cnt 1/2 정확, 밴드 leaf·forward-fill 정합 |
| **디지털인쇄** | 954 | `digital-print-l1.csv` 4행(q1) **14 leaf 전수**: 흑백단면3000→`:185`(S1/CLR_000002) · 칼라양면6000→`:188`(S2/CLR_000005) · 별색화이트양면6000→`:190`(SPOT_WHITE_S2/clr=NULL) | **100%** | 칼라양면6000≠8000(양면≠단면×2, M-3) · 별색5종 clr=NULL(규칙①) · 도수=clr_cd 정확 |
| **아크릴** | 358 | `acrylic-l1.csv` 20mm열 인코딩 20x20=2500→`:1139` · 30x20=2700→`:1140` · 미러20x20=5000→`:1416` | **100%(값)** | transposed 헤더 정확 디코드 · 미러 data_only값 그대로 |
| **인쇄후가공** | 216 | `post-process-l1.csv` B3(직각q1)=0→`:1497`(CORNER_RIGHT,min=1,0) · C3(둥근q1)=2000→`:1498`(CORNER_ROUND,2000) | **100%** | M-1 옵션흡수로 자연키 충돌 회피 · unit_price=0(직각 무료) 변조 없이 적재 |
| **봉투제작** | 40 | `envelope-l1.csv` **전수 40행 대조**: 티켓모조q1000=96000→`:1713` · 대봉투레자크q5000=760000→`:1752` | **100%(전수)** | 1셀=1행, 누락/중복/오축 0 |

축 뒤바뀜·드롭·중복 **0건**. 5시트 전부 무손실.

---

## ⑥ recompute check (샘플 ≥3)

| # | 샘플 | L1 원본 | 적재 unit_price | 결과 |
|---|------|---------|-----------------|------|
| 1 | 봉투 PRD_000050 티켓/모조120g/q1000 | `envelope-l1.csv` B4=96000 | `comp_prices.csv:1713`=96000 | ✓ 일치 |
| 2 | 봉투 대봉투/레자크/q5000 | `envelope-l1.csv` I8=760000 | `:1752`=760000 | ✓ 일치 |
| 3 | 디지털 칼라(CMYK)/양면/국4절/q1 | `digital-print-l1.csv` E4=6000 | `:188`=6000 (단면 `:187`=4000, ≠×2) | ✓ 일치 (양면≠단면×2) |
| 4 | 아크릴 투명3T 20x20 / 미러20x20 | 2500 / 5000(=2500×2) | `:1139`=2500 / `:1416`=5000 | ✓ 일치 |

수량구간(min_qty 상향개방) 단가도 봉투 q1000/2000/3000/4000/5000 전 구간 재현 일치(`:1713~1752`).

---

## ⑦ FK 부모 선존재/부재 목록 (라이브 SELECT 권위)

| FK | 값 | 라이브 | 판정 |
|----|----|--------|------|
| clr_cd | CLR_000002, CLR_000005 | 존재 | **PASS** |
| mat_cd | MAT_000159(모조120g), 168(레자크체크백색110g), 169(레자크줄무늬백색110g) | 존재 | **PASS** (mat_nm 라이브 확인) |
| comp_typ .01/.02/.04 | 인쇄비/코팅비/후가공비 | 존재 | **PASS** |
| frm_typ FRM_TYPE.02 | 단순형 | 존재 | **PASS** (.01 합산형도 존재) |
| prd_cd PRD_000050 | 봉투제작 | 존재 | **PASS** |
| 신규 frm/comp 네이밍 충돌 | PRF_ENV_MAKING, COMP_* | 라이브 부재 | **PASS** (신규 안전, 충돌 0) |
| 고아 comp_cd | component_prices의 comp가 카탈로그에 정의? | 고아 0 (comm -23 결과 공집합) | **PASS** |
| **comp_typ `PRC_COMPONENT_TYPE.06`** | 완제품비 | **부재** (라이브 .05 박형압비까지만, .06 없음. 부모그룹 PRC_COMPONENT_TYPE는 존재) | **BLOCKER** — 봉투 COMP_ENV_MAKING 40행 FK 부모 미등록. `t_cod_base_codes.csv:1`로 산출됐으나 적재 선행 필수 |
| **siz_cd placeholder** | SIZ_PENDING_* 1536행 | **부재** (t_siz_sizes에 placeholder 0) | **BLOCKER** — 1536행 FK 위반(국4절834+3절304+아크릴358+봉투40) |

---

## ⑧ 공식배선 누락 판정 (formula 1개 = 의도 vs 누락)

**판정: 의도(설계 누락 아님). 단 경계 명문화 권고(MINOR).**

근거:
- `t_prc_price_formulas.csv` = 봉투만 1행(PRF_ENV_MAKING), `t_prc_formula_components.csv` = COMP_ENV_MAKING 1행, `t_prd_product_price_formulas.csv` = PRD_000050 1행.
- 디지털/코팅/아크릴/후가공 30 comp는 어떤 formula에도 미배선(formula_components의 comp_cd=COMP_ENV_MAKING 단 1종).
- 이는 `price-code-proposals.md:70` 각주·`schema-fitgap-price.md:170`("코팅·디지털·아크릴·후가공의 component_prices는 상위 상품 원자합산형 공식이 참조 — 개별 공식 미부여 = 시트단위 구성요소 단가")와 정합. 공식·상품바인딩은 상품마스터 계산공식집초안 평면화(다음 단계) 몫. 봉투만 `[고정가형/단순형]`(`schema-fitgap-price.md:97`)이라 자기완결.

**수정제안**: 이 경계("component 단가 적재 ↔ formula·binding은 상품 매핑 단계")를 fit-gap §6 또는 본 검증 게이트에 검증 가능한 1줄로 격상. 현재 각주 수준이라 "누락"으로 오인될 소지.

---

## ⑨ BLOCKER / MAJOR / MINOR + 수정제안

| 등급 | ID | 내용 | 증거 | 수정제안 |
|------|----|------|------|----------|
| **BLOCKER** | B-1 | siz_cd placeholder 1536행 FK 위반 — 후니 siz 미등록 | `t_prc_component_prices.csv` siz=SIZ_PENDING_* 1536행, 라이브 t_siz_sizes 0행 | 후니 siz 등록(국4절/3절 출력판형 · 봉투4종 규격 · 아크릴 좌표 결정) 후 placeholder 치환. 등록 전 적재 차단 |
| **BLOCKER** | B-2 | `PRC_COMPONENT_TYPE.06` 라이브 미등록 — 봉투 comp FK 부모 부재 | 라이브 SELECT: comp_typ .06 없음(.05까지). `t_cod_base_codes.csv:1` 산출됨 | 적재 순서상 .06 코드행 선적재(부모 PRC_COMPONENT_TYPE 존재 → INSERT만). 봉투 comp보다 선행 |
| **MAJOR** | M-1 | 아크릴 면적 부분 dodge — 196 좌표 중 47종이 라이브 NNxNN siz로 실재하나 전수 placeholder 발명 | 라이브 SELECT: 196 중 47 실재(20x20=SIZ_000336 등). 적재는 전부 SIZ_PENDING_ACRYL_* | 196↔라이브 siz_nm 정확매칭표 추출 → 47 재사용 후보 식별(발명 회피) → 의미 검토 후 면적함수 vs 좌표등록 결정. "47 기존재" 명시 |
| **MINOR** | m-1 | 공식배선 경계 미명문화 — 의도이나 게이트 미격상 | formula 1개(봉투), 30 comp 미배선. 각주 수준 | 경계를 검증 게이트로 1줄 격상 |
| **MINOR** | m-2 | fit-gap "아크릴 202종" 표기 — 실제 196 유니크 좌표 | `schema-fitgap-price.md:79` "358행" 정확, "202/196" 혼선 | 수치 정정(196 유니크 좌표, 358 적재행) |

**무결 입증(반증 시도 결과)**: 역대조 5시트 100% · recompute 4샘플 일치 · 제약 C-1~9 위반 0(자연키8 중복 0, apply_ymd 전건 2026-06-01, use_yn/addtn_yn 전건 Y, unit_price 전건 numeric, varchar 최장 25자) · 발명 0(네이밍 충돌 0, 고아 comp 0) · 침묵드롭 0(레자크 2종 동일단가 note 명시) · 과소적재 0. 결함은 전부 **FK 부모 미등록(적재 순서)** 과 **아크릴 실코드 미탐색(dodge)** 에 국한 — 매핑 변환 로직 자체는 적재가능.

---

## 적재불가 행수 격리 (현 상태 적재 시)

| 차단 사유 | 행수 | 해소 조건 |
|-----------|------|-----------|
| siz_cd placeholder FK 위반 | **1536** | 후니 siz 등록 + 아크릴 좌표 결정 후 치환 |
| comp_typ .06 부모 부재 | (봉투 40행 간접) | `.06` 코드행 선적재 |
| **즉시 적재 가능** | **216** (후가공, siz=NULL · 실코드 FK 전부 존재) | 없음 |

---

## 미검증 항목 (정직 표기)

- **나머지 10시트**(접지·제본·커팅·스티커·합판·명함·엽서북·포스터·박소형·박대형): 본 검증은 **평면화 파일럿 5시트 한정**. 10시트는 fit-gap verdict만 있고 적재 CSV 미산출 → 검증 대상 아님(미검증).
- **DRY-RUN 트랜잭션 적재**: 미수행(lead 미승인 + B-1/B-2로 FK 위반 자명). 로컬 제약 검증 + 라이브 FK 조회로 대체.
- **아크릴 196↔라이브 siz 정확매칭표**: 47종 실재는 확인했으나 좌표별 1:1 매핑표는 미추출(M-1 후속 작업).
- **상품바인딩 실효성**(PRD_000050 봉투제작이 실제 봉투 상품인지 추가 의미검증): prd_nm="봉투제작" 라이브 확인까지만(상품 옵션·MES 연계 미검증).

---

검증 권위 입력: `02_mapping/load_price/`(적재) · `06_extract/price-*-l1.csv`(역대조 원본) · `00_schema/`(DDL·ref-*) · 라이브 DB(read-only). 라이브 SELECT 2회만 사용(쓰기 0).
