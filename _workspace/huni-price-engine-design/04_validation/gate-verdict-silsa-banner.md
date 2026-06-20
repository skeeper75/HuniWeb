# gate-verdict-silsa-banner.md — 실사·현수막 면적매트릭스형 가격엔진 설계 E1~E7 게이트 판정

> hpe-validator 독립 검증 (2026-06-20·라이브 읽기전용 SELECT·DB 쓰기 0).
> 검증 대상: `03_design/engine-design-silsa-banner.md`·`golden-cases-silsa-banner.md`·`set-product-design.md`(§8)·`design-decisions.md`(실사·현수막 DS-1~6·Q-SB-*).
> 기준점: `01_formula/formula-map-silsa-banner.md`·`02_benchmark/absorption-candidates-silsa-banner.md`.
> **생성자 주장 비신뢰** — 라이브 t_prc_*·가격표260527·`pricing.py` 직접 재실측·재계산으로 교차. 재현 SQL/재계산 = `recompute-log-silsa-banner.md`.
> codex 2차(Phase 5.5) 결과 비참조(독립성).

---

## 종합 판정: **GO (조건부 컨펌큐 동반)** — E1~E7 전건 PASS

7개 게이트 전건 PASS. 본체(면적 13소재·고정가 13·수량구간 2)·골든 13건(+에러 2)은 라이브·가격표·코드로 무결 재현(허용오차 0). 핵심 갭 G-S1(후가공 미배선)·배너 후가공 silent 합산 위험은 designer가 정확히 식별하고 **판별차원 충전을 절대 선결로 명시**(미충전 배선 시 과청구 100% 실증). 신규 mint 0(후가공 opt_cd 채번만)·실 적용 전부 컨펌큐로 정직 분리·DB 미적재. 단가 결함·×qty 폭발·이중계상 0.

**적발한 결함 = LOW 2건(비차단)**: ① 배너 후가공 use_dims 라이브 이질성 under-statement(F-S-1) ② comp_typ .06 (E4 무영향). 둘 다 가격 무영향·컨펌큐 흡수.

---

## E1 — 공식 추출 충실성 · **PASS**

| 검사 | 라이브 실측 결과 |
|------|------------------|
| 3계산방식 분류 | calc-draft 행100 `[면적매트릭스형:실사,현수막]`·행103 `[고정가형:...]` + 라이브 use_dims 3분기(면적=`[siz_width,siz_height]`·고정가=`[siz_cd]`·수량구간=`[siz_cd,min_qty]`) 정합. ✅ |
| PRF_POSTER 공식 수 | 라이브 **29** = 28 바인딩 + `PRF_POSTER_FIXED`(고아). designer "28공식"은 바인딩 28 기준·FIXED 별도 표기(고아) → 정확(아래 E5). ✅ |
| 단가 verbatim(날조 0) | 캔버스37,800·아트프린트21,600·린넨17,000/32,400·접착투명59,400/16,000·미니배너[6500/4900/4200/3500/2800]·미니보드SIZ_000315[6500/6200/6100/5900/5500]·현수막900×900=8,000 = 라이브 SELECT verbatim 일치. **날조 0**. ✅ |
| 동형결합 13→7 | 라이브 정본A CANVAS_FABRIC←CANVAS/LEATHER_AP/TYVEK/MESH·정본B ARTPRINT_PHOTO←ARTPRINT/WATERPROOF/ADH_WP/ARTFABRIC(+FIXED) = formula_components 실측 일치. byte-identical 결합 정합. ✅ |
| v03 인용 차단 | 권위=상품마스터260610·가격표260527·라이브. v03 인용 없음. ✅ |

---

## E2 — 구성요소 분해 정합 · **PASS**

| 검사 | 라이브 실측 |
|------|------------|
| 공식당 본체 1 comp(disp_seq 1) | 라이브 29 PRF 전건 comp 1개·max(disp_seq)=1 = **multi-comp 공식 0건** → 구조적 silent 이중합산 불가(현 상태). ✅ |
| use_dims 면적축 권위 | 면적 본체 전건 `siz_cd=NULL·siz_width/siz_height numeric`(work 미사용). W=가로·H=세로 축 권위·비대칭 셀 회귀 재계산 확인(§recompute §2). ✅ |
| 의미축 이중 인코딩 | 도수·재단=면적단가 통합(별 축 없음)·소재=별 공식+동형결합(면적 comp mat_cd 차원 NULL·소재≠가격축). designer C-SB3 답습 금지 준수. ✅ |
| 완제품/반제품 구분 | 본체 1 comp=완제품가·세트조합 분해 없음(set §8). 거치/타공=후가공 add-on(별 SKU 합산 아님). ✅ |
| 시트 차원경계(SOT 1) | 각 PRF=자기 본체 1 comp(타 소재/디지털 comp 침입 0). 후가공 배선은 add-on(addtn_yn=Y)으로 시트 경계 안. ✅ |

---

## E3 — 경쟁사 흡수 타당성 · **PASS**

| 검사 | 결과 |
|------|------|
| 신규 가격축/테이블 mint | **0건** — 면적=siz_width/height 매트릭스 ceiling(C-SB1·이미 동형)·자유사이즈=nonspec_incr(C-SB2·라이브 백필 완료 실측)·소재=별 공식+동형결합(C-SB3)·거치=고정가 comp(C-SB4)·강제제약=round-6 CPQ(C-SB5). 신규 vessel 0. ✅ |
| 권위 덮어쓰기 0 | RedPrinting `real_price`/SizeMatrix2D 면적함수 흡수 부결(가격표=이산 매트릭스 권위 유지)·WowPress 미관측 정직 기록. ✅ |
| naming/codes 유입 0 | 라이브 poster comp/comp_nm에 `real_price`/`MTRL_CD`/`CDL_DFT`/`SizeMatrix`/`PXBO`/`GRP_OPTION` 토큰 **0건**(SELECT 확인). 후니 siz_width/siz_height/opt_cd/proc_cd 번역. ✅ |
| overfit(엔진 과분화) | 3계산방식=frm_typ 분기 아니라 comp use_dims 차이(DS-1)·면적함수 신설 부결·자재 그룹핑 슬롯 부결(C-SB6). overfit 0. ✅ |

---

## E4 — 엔진 설계 건전성 + ★min_qty 계약 · **PASS**

### min_qty / prc_typ 라이브 confirm (돈크리티컬·designer 주장 직접 반증 시도)

| comp | designer 주장 | **라이브 SELECT 실측** | 판정 |
|------|--------------|------------------------|------|
| 면적 본체 prc_typ | 전건 `.01 단가형` | 28 바인딩 comp 전건 `PRICE_TYPE.01` | ✅ 확정 |
| 면적 본체 min_qty | NULL 또는 1·÷ 미발생 | CANVAS/ARTPRINT/LINEN/ADH_CLEAR 단가행 min_qty **전건 NULL**·BANNER_NORMAL **전건 1** | ✅ 확정 |
| 직접단가 override | 부재(전 상품 공식기반) | PRD_000118~145 `t_prd_product_prices` **0행** = 전건 공식 경로 | ✅ 확정 |
| 코드 계약 | `.01`=unit×qty·÷ 미발생 | `component_subtotal`(pricing.py:191-192) `.01`→`up*q`·`.02`만 `÷tier_min_qty`(NULL→ValueError). 면적·고정가·수량구간 전건 `.01`이라 ÷ 구조적 미발생 | ✅ 확정 |

- **디지털 ×qty 결함과 정반대 confirm**: 디지털=단가가 묶음총액인데 prc_typ .01·min_qty=100이라 ×100 폭발. 실사·현수막=단가가 **1장당 완제품가**+prc_typ .01 → unit×qty가 곧 정답(캔버스 37,800×10=378,000 재계산 확인). **아크릴 .02 가드조차 불필요**(전건 .01) = designer 비동형점 주장 옳음.

### 기타 엔진 계약

| 계약 | 결과 |
|------|------|
| C7 frm_typ 미참조 | 면적/고정가/수량구간 모두 comp 합산형 표현·라이브 t_prc_price_formulas에 frm_typ 컬럼 부재(SELECT). ✅ |
| TIER_UPPER siz_width/height '이하' ceiling | 650×650→900×900 ceiling 재계산 확인·650×650 단가행 0건(런타임 계산·위장 룩업 아님). ✅ |
| TIER min_qty '이상' 하한(수량구간) | 미니배너 30개→mq19·100개→mq99 재계산 확인(siz '이하' ceiling과 방향 반대·designer 정확). ✅ |
| search-before-mint | 공식 29·comp 7정본+단독·후가공 comp 전부 실재 = 신규 mint 0. 작업=후가공 배선(formula_components INSERT)+배너 후가공 판별차원 충전(UPDATE)+opt_cd 채번(MAX+1)뿐. 불필요 mint 0. ✅ |
| FK 위상 | 후가공 배선 INSERT 대상 formula_components는 기존 PRF·기존 comp 참조(선존재). ✅ |
| comp_typ | 본체 전건 `PRC_COMPONENT_TYPE.06`(완제품비) 균일(아크릴 본체 .01과 다르나 후니 권위 정합·엔진 미참조). ✅(F-S-2 비결함) |

**결함(LOW·비차단) F-S-1 — 배너 후가공 use_dims 라이브 이질성 under-statement**:
- designer는 배너 후가공(PUNCH_4/6/8·QBANG·STRING·BONGSEW·CUTEDGE·DTAPE·STAND)을 **일괄 `use_dims=[]`** 으로 기술.
- 라이브 실측: 대부분 use_dims=[]이나 **3건은 비어있지 않음** — `COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_6`(`["proc_cd","min_qty","proc_grp:..."]`)·`COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4`(`["opt_cd","min_qty","opt_grp:..."]`)·`COMP_POSTEROPT_BANNER_MESH_PROC_OPT`(`["min_qty"]`).
- ★단 **이들 3건도 단가행의 proc_cd/opt_cd 컬럼은 NULL**(SELECT 확인) → `_row_matches` 와일드카드로 **여전히 silent 합산 위험**(use_dims만 채우고 행 컬럼 미충전 = 반쪽). 오히려 `_match_entry`(:414)가 use_dims non_qty_dims 비어있지 않다고 "판별차원 없음" note를 생략 → **거짓 안전감**(컬럼 NULL인데 안전한 줄 오인) 위험이 추가됨.
- **판정**: designer 처방(use_dims **+ 단가행 컬럼** 둘 다 충전)이 이 3건도 정확히 닫음 → 보정 방향 옳음. 단 라이브 이질성(부분 백필 잔류)을 "일괄 []"로 평탄화 기술한 것은 under-statement. **가격 무영향(배선 0=현 견적 미반영)·LOW·컨펌큐(Q-SB-PUNCH-DIM에 부분백필 3건 명시 추가)**.

---

## E5 — 세트/바인딩 + ★G-S1 후가공 배선 · **PASS**

| 검사 | 라이브 실측 |
|------|------------|
| 28상품 1:1 바인딩 | PRD_000118~145 전건 자기 PRF 1:1 바인딩 실재(SELECT)·use_yn=Y. ✅ designer 정확 |
| PRF_POSTER_FIXED 고아 | 바인딩 **0건** confirm(고아·use_yn=Y). designer "바인딩 0=고아" 정확 → 아크릴 G-A1(본체 미바인딩)과 정반대(본체 완성). 정리 컨펌큐 Q-SB-FIXED-LEGACY. ✅ |
| **G-S1 후가공 배선 0건** | 29 PRF 전건 comp 1개(disp_seq 2~ **0건**·SELECT) → 현 견적 시 후가공 선택해도 가격 반영 0. designer "핵심 갭 G-S1" 정확. ✅(갭 식별 정합) |
| 세트(반제품) 조합 | 명시 세트조합 부재(calc-draft 분해 없음)·본체 1 comp=완제품가·거치/타공=후가공 add-on. 이중계상·구성품 누락·번들할인 오류 대상 0(set §8). ✅ |
| 거치 부속 모델 | 거치대/우드행거=별 SKU 테이블 부결·고정가 add-on comp 합산(C-SB4·면적 차원 오모델 금지)·★1건당 vs ×수량 가드(§8-3·Q-SB-PROC-QTY 정직 미확정). ✅ |

**G-S1 silent 합산 가드 — designer 핵심 발견 검증**: 배너 후가공 use_dims=[]·전 컬럼 NULL → 미충전 배선 시 PUNCH_4/6/8 셋 다 와일드카드 매칭·합산(20,000 과청구) 재계산 실증(recompute §3). designer가 이를 정확히 식별하고 **판별차원 충전을 배선의 절대 선결로 명시**(미충전 배선 절대 금지) → 돈크리티컬 결함을 설계 단계에서 차단. ✅

---

## E6 — 골든 재현(허용오차 0) · **PASS**

골든 13건(+에러 2건) **engine 충실 재구현 재계산 전건 일치**(recompute-log §1):

| 골든 | 재계산 | 기대 | 판정 |
|------|--------|------|------|
| GC-S1 캔버스 600×1800 ×1/×10 | 37,800 / 378,000 | 37,800 / 378,000 | ✅ |
| GC-S2 아트프린트 600×1800 | 21,600 | 21,600 | ✅ |
| GC-S3 린넨 600×600 / 600×1800 | 17,000 / 32,400 | 17,000 / 32,400 | ✅ |
| GC-S4 접착투명 600×1800 / 600×600 | 59,400 / 16,000 | 59,400 / 16,000 | ✅ |
| GC-S5 현수막 650×650 ceiling / 6000 초과 | 8,000 / ERR_ABOVE_MAX | 8,000 / 거부 | ✅ |
| GC-S7 미니배너 30 / 4 / 100 / 3 | 147,000 / 26,000 / 350,000 / ERR_BELOW_MIN | 동일 | ✅ |
| GC-S8 미니보드 SIZ_000315 50 | 305,000 | 305,000 | ✅ |
| GC-S10 silent 합산: 미충전 / 충전 | 20,000 / 12,000 | 20,000 / 12,000 | ✅ |

- **순환참조 0**: 기대값=가격표 셀 verbatim·재계산=라이브 단가행+엔진 충실 재구현(설계 산출값 비참조).
- **dodge 0**: 현수막 650×650 단가행 0건 → ceiling 런타임 계산(위장 룩업 아님)·미니 100개=mq99 방향 재계산(혼동 시 틀림→정합).
- **양면표 불요 정합**: 디지털 ×qty 결함(설계 vs 라이브)이 실사·현수막엔 구조적 부재(.01·1장당가)·재계산이 입증.

---

## E7 — 생성-검증 독립성 · **PASS**

| 검사 | 결과 |
|------|------|
| 자기 재유도(self-approve) 없음 | designer 산출물 비참조로 라이브 SELECT 10여종 + 엔진 충실 재구현(`/tmp/recompute.py`)으로 독립 재계산. 설계 골든값을 그대로 안 씀(가격표 셀 독립 trace). ✅ |
| 생성자 주장 라이브 반증 시도 | prc_typ(.01 전건)·min_qty·바인딩 28·FIXED 고아·use_dims·off-grid·silent 합산·×qty 계약 전부 직접 SELECT/재계산 교차 → 대부분 반증 실패(주장 옳음). **단 배너 후가공 use_dims "일괄 []" 주장은 반증 성공**(부분 백필 3건·F-S-1). ✅ |
| dodge-hunt | 골든 순환참조·off-grid 위장 룩업·축 스왑·판별차원 위장 적극 추적 → 본체 dodge 0·F-S-1(설계 평탄화) 적발. ✅ |
| codex 결과 비참조 | Phase 5.5 codex 미확인(독립 자기 판정). ✅ |

---

## 결함 요약

| ID | 게이트 | 심각도 | 내용 | 차단? |
|----|--------|--------|------|-------|
| F-S-1 | E4/E7 | LOW | 배너 후가공 use_dims를 "일괄 []"로 기술하나 라이브 3건(MESH_PUNCH_6·NORMAL_QBANG_4·MESH_PROC_OPT)은 비어있지 않음(부분 백필)·단 단가행 컬럼은 NULL이라 여전히 silent 합산 위험. designer 처방(use_dims+컬럼 둘 다 충전)이 이 3건도 닫음·가격 무영향(배선 0) | 비차단 |
| F-S-2 | E4 | LOW(비결함) | 본체 comp_typ 전건 .06(완제품비)·균일(아크릴 본체 .01과 다르나 후니 권위 정합·엔진 미참조·가격 무영향) | 비차단 |

확정 결함(차단·NO-GO) **0건**. 양 LOW는 컨펌큐(가격 무영향).

---

## 컨펌큐 (designer 정직 표기 + 검증 추가)

designer 컨펌큐 8건(Q-SB-PROC-QTY·PUNCH-DIM·MINI-DSC·MINI-MIN·CH1·DIM1·NSPEC1·DSC1·FIXED-LEGACY) 전부 가격 정밀화·경계 확정용으로 GO를 막지 않음. 검증 추가:
- **Q-SB-PUNCH-DIM 보강**: 판별차원 충전 시 라이브 부분 백필 3건(MESH_PUNCH_6 등)도 단가행 proc_cd/opt_cd 컬럼 충전 동반(use_dims만 채운 잔류 상태가 거짓 안전감 유발·F-S-1).
- **Q-SB-PROC-QTY(돈크리티컬·우선)**: 거치대(PET거치 25,000·우드행거 20,000)는 1주문건당 통가격 가능성 높음→.01 ×qty 과청구 위험. 배선 전 prc_typ 의미 확정 필수(미확정 정직 표기·designer 확신도 중).

실 적용(후가공 배선 INSERT·판별차원 충전·opt_cd 채번)은 **DB 미적재·인간 승인 후 dbmap 위임**(dbm-axis-staged-load·dbm-load-execution·dbm-ddl-proposer·webadmin 코드 직접수정 금지).
