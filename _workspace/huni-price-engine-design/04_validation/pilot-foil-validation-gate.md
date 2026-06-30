# 박류 파일럿 적재본 독립 검증 게이트 — 프리미엄명함 PRD_000031 (소형)

> dbm-validator (독립 검증자·생성≠검증) · 2026-06-30 · **라이브 읽기전용 + 롤백전용 DRY-RUN만 · 실 COMMIT 0**
> 대상: `03_design/pilot-load/foil-pilot-namecard031-{load,body,dryrun,undo}.sql` + `gen_foil_pilot.py`
> 권위 재대조: `06_extract/price-foil-small-l1.csv`(verbatim 원천) · 라이브 t_prc_*/t_proc_* · `raw/webadmin/catalog/pricing.py`
>
> **방법: 빌더의 산출·주장을 신뢰하지 않고 전수 재측정.** 단가는 권위 CSV에서 **독립 재-flatten**(빌더의
> 하드코딩 dict 미사용·원천 CSV 셀을 직접 파싱)해 body SQL과 diff. 골든은 pricing.py 의미를 **밑바닥부터
> 재구현**해 빌더 숫자 미재사용. DRY-RUN은 라이브 BEGIN…ROLLBACK 실제 실행.

---

## 최종 평결: **GO** (실 COMMIT은 인간 승인 후 — load.sql COMMIT 주석 해제)

전 게이트 PASS. 단가 2,168행 전수 독립 재flatten 결과 **불일치 0·날조 0**, DRY-RUN 멱등 PASS,
골든 6/6 독립 재계산 일치, 형제 032/033 미영향, FK·NOT NULL·UNIQUE 무결성 확인. **빌더와 권위/라이브
사이 불일치 0건.** 결함 없음.

---

## 게이트별 결과

### R1 멱등성 — **PASS** (라이브 DRY-RUN 실측)
`foil-pilot-namecard031-dryrun.sql` 를 라이브에 BEGIN…ROLLBACK 으로 실제 실행(exit 0):
- **PASS 1**(신규 삽입): 전 INSERT 성공 — FK·NOT NULL·CHECK 위반 0. 카운트 실측:
  `SETUP 8 · PROC_STD 1620 · PROC_SPECIAL 540 · components 3 · formula 1 · formula_components 5 · binding(2026-07-01) 1` — 설계와 정확 일치.
- **PASS 2**(재적용): `d_comp_prices=0 · d_components=0 · d_formula_comps=0 · d_binding=0` → **`IDEMPOTENT: PASS`**.
- 종료 ROLLBACK. **사후 라이브 재조회 = 전부 0행**(커밋 누출 없음 확인).
- NOT EXISTS NULL-safe 가드 정합성: 라이브 `ux_t_prc_comp_prices_nat_key` 가 `indnullsnotdistinct=f`
  = **NULLS DISTINCT**(NULL≠NULL) → 박 단가행(siz_cd/mat_cd/opt_cd/clr_cd NULL)은 ON CONFLICT 가 안 잡힘.
  ∴ `IS NOT DISTINCT FROM` 14컬럼 자연키 가드가 정답(중복 위험 0·false-skip 0). **가드 정합 확인.**

### R2 제약(FK/NOT NULL/CHECK/PK) — **PASS** (라이브 스키마 독립 재측정)
- **FK proc_cd**: `fk_comp_prices_proc → t_proc_processes(proc_cd)` 존재. 037~044 전부 라이브 실재
  (use_yn=Y·del_yn=N): 037홀로그램·038금유광·039은유광·040먹유광·041동박·042적박·043청박·044트윙클. **고아 0.**
- **NOT NULL**: component_prices 의 NOT NULL = `comp_price_id`(IDENTITY 자동)·`comp_cd`·`apply_ymd`·`reg_dt`(DEFAULT now()) 뿐.
  `min_qty·siz_width·siz_height·proc_cd·unit_price` 전부 nullable → 동판비 행(siz/min_qty NULL) **합법**.
  가공비 행은 min_qty(band 하한) NOT NULL 충전 확인. **NOT NULL 위반 0.**
- **CHECK**: component_prices 에 CHECK 제약 **없음** — 위반 대상 자체 부재.
- **PK/IDENTITY**: `comp_price_id` 미지정(IDENTITY BY DEFAULT 자동채번). formula_components PK=(frm_cd,comp_cd)·
  binding PK=(prd_cd,apply_bgn_ymd)·formula FK·comp FK 전부 적재 위상순서로 충족. **무결성 OK.**
- 코드 `PRICE_TYPE.03`(고정금액)·`PRC_COMPONENT_TYPE.05`(박형압비)·`.01`(인쇄비) 전부 라이브 실재 → 코드 선적재 불요.

### R3 단가 verbatim — **PASS** (권위 CSV 독립 재-flatten·전수 diff)
빌더의 하드코딩 dict 을 **쓰지 않고** `price-foil-small-l1.csv` 셀을 직접 파싱해 면적격자(B02/B04)×
등급단가(B03/B05)를 재 join → body SQL 의 2,168행과 전수 비교:
- **PROC 행 2,160 전수: VALUE MISMATCH 0 · MISSING 0 · EXTRA 0.**
- **SETUP 행 8: 전부 5000**(B01 동판비 verbatim).
- 행수 분해 독립 확인: STD = 6색×15면적셀×18밴드 = **1620** · SPECIAL = 2색×15×18 = **540** · SETUP 8 = **2168**.
- **grade=note 추적용만**(매칭 비사용) 확인: 적재행의 dim 은 `proc_cd·siz_width·siz_height·min_qty` 뿐,
  siz_cd/clr_cd/opt_cd/mat_cd NULL. grade(A~E)는 `note` 텍스트에만 존재 → 엔진 매칭에 미사용. **크기상세 dim_vals empty 확인.**

샘플 10셀 독립 CSV 룩업 ↔ build 대조(전부 OK):

| comp | proc | 면적 | 수량 | 등급 | 권위 | build |
|---|---|---|---|---|---|---|
| STD | 038금유광 | 40×80 | 1000 | E | 64,000 | 64,000 |
| STD | 038금유광 | 40×80 | 800 | E | 52,800 | 52,800 |
| STD | 040먹유광 | 40×40 | 500 | D | 32,500 | 32,500 |
| SPECIAL | 044트윙클 | 10×10 | 200 | A | 14,300 | 14,300 |
| SPECIAL | 037홀로그램 | 40×80 | 400 | E | 41,600 | 41,600 |
| STD | 041동박 | 20×60 | 300 | C | 20,600 | 20,600 |
| STD | 043청박 | 10×20 | 200 | A | 12,200 | 12,200 |
| STD | 042적박 | 20×80 | 10000 | D | 498,000 | 498,000 |
| SPECIAL | 044트윙클 | 20×40 | 2000 | B | 113,900 | 113,900 |
| STD | 039은유광 | 40×60 | 5000 | E | 288,000 | 288,000 |

> **(10,10) 코너 검증**: 원천 CSV 의 (가로10,세로10) 셀은 병합 상삼각 표시로 **시각상 공란**이나, 헤더
> band_header_path 가 `10mm > A`(세로10mm 열=등급A) 로 규칙을 명시 → 그래서 등급 A 가 **강제됨**(인접
> 세로10 열 전체 A·가로10 행 인접 전부 A 와도 정합). 빌더의 (10,10)=A 는 **정답**(날조 아님). 초기 파서가
> 공란을 0으로 읽어 144행을 flag 했으나, 헤더 규칙 적용 후 재diff = **불일치 0**.

### R4 골든 독립 재계산 — **PASS** (pricing.py 의미 밑바닥 재구현·빌더 숫자 미재사용)
`match_component`(siz_width/height=UPPER '이하'·min_qty=LOWER '이상'·proc_cd=정확매칭) +
`component_subtotal`(.03 FLAT → `up,up` ×qty 0)을 독립 재구현해 내 re-flatten 행 위에서 재계산:

| 케이스 | 입력 | 동판비 | 박가공비 | 박 합계 | 권위 | 판정 |
|---|---|---|---|---|---|---|
| G-F4 | STD 금유광 40×80 q1000 | 5,000 | 64,000(E) | **69,000** | 69,000 | PASS |
| G-F5 | SPECIAL 트윙클 10×10 q200 | 5,000 | 14,300(A) | **19,300** | 19,300 | PASS |
| G-F8 | STD 먹유광 40×40 q500 | 5,000 | 32,500(D) | **37,500** | 37,500 | PASS |
| off-band q850 | STD 금유광 40×80 **q850** | 5,000 | 52,800(E@band800) | **57,800** | 57,800 | PASS |
| off-band q899 회귀 | STD 금유광 40×80 **q899** | 5,000 | 52,800(E@band800) | **57,800** | 57,800 | PASS |
| GATE0 펄박045(미등록) | q1000 | — | no_match | **박 0** | 0 | PASS |
| 박 미선택(proc_cd None) | q1000 | no_match | no_match | **박 0** | 0 | PASS |

- **.03 FLAT ×qty 폭발 가드**: q800=q850=q899=52,800(전부 E@800 밴드 floor·곱셈 없음). `.02`였다면
  off-band 과청구 발생 — REV3 교정(.02→.03) 이 옳음을 독립 확인.
- **proc_cd 게이트**: 045/박미선택 → 동판비·박가공비 둘 다 no_match → 박 0(사용 불가 색상·미선택 과금 0).
  (045 펄박·046 백박은 PRD_000031 미등록 → 단가행 자체 미생성 = 게이트의 1차 방어.)

### R5 공식 분기 무결성 — **PASS**
- 라이브 `PRF_NAMECARD_FIXED`(031·032·033 공유)는 본체 comp **정확히 2개**(`COMP_NAMECARD_STD_S1` seq1·
  `COMP_NAMECARD_STD_S2` seq2)임을 라이브 재조회로 확인 → 클론 원천 충실.
- 신규 `PRF_NAMECARD_FIXED_FOIL` formula_components = **정확히 5행**: 본체 S1(1)·S2(2) + 박 SETUP(3)·
  STD(4)·SPECIAL(5). 추가/누락 0·orphan formula_component 0.
- 재바인딩: `t_prd_product_price_formulas` 신규 **시계열 행**(prd=031·apply_bgn_ymd=2026-07-01).
  기존 **2026-06-01 행은 미터치**(라이브 재조회로 보존 확인) → PK=(prd,apply_bgn_ymd) 공존·엔진 최신 선택.
- **형제 032/033**: 둘 다 `PRF_NAMECARD_FIXED@2026-06-01` 그대로(라이브 확인) → **미영향**. 박 노출 0.
- 이중 바인딩 없음(031 의 2026-07-01 행은 신규 1건뿐).

### R6 독립성/무날조 — **PASS**
- 검증자(나)는 빌더가 아님. 단가는 권위 CSV 셀 직접 파싱으로 **독립 재flatten**, 골든은 pricing.py
  의미 **재구현**(빌더 `golden_recalc.py`·하드코딩 dict 미재사용). 모든 값을 권위 셀 또는 라이브 행으로 역추적.
- **빌더가 주장했으나 재현 못한 값 = 0건.** 빌더 README §8 의 카운트·골든·멱등 주장 전부 독립 실측으로 재확인됨.

---

## 결함 목록
**없음.** (BLOCKER 0 · MAJOR 0 · MINOR 0)

## 잔여 / 인간 결정 큐
- **실 COMMIT**: 인간 승인 후 `load.sql` 의 `COMMIT` 주석 해제 1회. (현재 COMMIT 0·검증까지만.)
- **post-COMMIT 라이브 시뮬레이터 실호출**: 행 적재 후 webadmin price-simulator 로 G-F4/F5/F8 본체+박
  합계 e2e 1회 확인 권장(현재는 행 미적재라 순수함수 재계산이 대행 — 본 게이트가 그 대행을 독립 재수행).
- **동형 전파**(범위 외): 대형 comp·다른 6상품·명함박(PRF_NAMECARD_FOIL)·박영역 상한>170 정책(Q-FOIL-SIZE2)은 별 파일럿/실무 컨펌.

## 검증 환경
- DB: railway (PostgreSQL 18.4·비표준 포트·읽기전용 SELECT + 롤백전용 DRY-RUN). 자격증명 `.env.local RAILWAY_DB_*`(미노출).
- 실 COMMIT 0 · 파괴적 쓰기 0 · DRY-RUN 사후 라이브 재조회로 무변경 확증.
