# 박류 동형 전파 적재본 독립 검증 게이트 — 6상품 (대형 5 + 펄명함034 소형)

> dbm-validator (독립 검증자·생성≠검증) · 2026-06-30 · **라이브 읽기전용 + 롤백전용 DRY-RUN만 · 실 COMMIT 0**
> 대상: `03_design/propagation/foil-prop-{body,load,dryrun,undo}.sql` · `gen_foil_prop.py` · `foil-prop.provenance.csv`
> 범위: PRD_000034 펄명함(소형·재사용)·029/027 접지카드·042 쿠폰·069 무선책자·070 PUR책자.
> 권위 재대조: `06_extract/price-foil-large-l1.csv`(verbatim 원천·독립 재파싱) · 라이브 t_prc_*/t_proc_* ·
> `raw/webadmin/catalog/pricing.py` · `03_design/engine-design-foil.md` REV4 · 파일럿 선례 `pilot-foil-validation-gate.md`.
>
> **방법: 빌더의 산출·주장을 신뢰하지 않고 전수 재측정.** 단가는 권위 CSV 셀을 직접 파싱해 **독립 재-flatten**
> (빌더의 하드코딩 dict·golden_recalc_large.py 미사용)하고 body SQL 7,168행과 **전수 diff**. 골든은 pricing.py
> 의미를 밑바닥부터 재구현해 적재본 행 위에서 재계산. DRY-RUN은 라이브 BEGIN…ROLLBACK 실제 실행.

---

## 최종 평결: **GO** (실 COMMIT은 인간 승인 후 — load.sql COMMIT 주석 해제)

전 게이트 PASS. **단가 7,168행 전수 독립 재-flatten 결과 불일치 0·날조 0·누락 0·초과 0**, provenance 7,168행
1:1 정합, FK/NOT NULL/UNIQUE/PK 무결성 확인, base 공식 클론 라이브 충실(5/5 정확 일치), 형제 공유공식 미영향
(PRF_DGP_A 9형제·PRF_DGP_E 미니접지카드028·PRF_NAMECARD_PEARL 외 0), 골든 10/10 독립 재계산 일치, search-before-mint
충족(LARGE 3 comp·5 분기공식 라이브 0건). **빌더와 권위/라이브 사이 불일치 0건. 결함 없음.**

> DRY-RUN(R1) 라이브 멱등 실측: **IDEMPOTENT: PASS · 카운트 512/3328/3328 · delta 전부 0 · ROLLBACK 무변경**
> (`/tmp/dryrun_final.txt` 완주). 첫 두 시도는 동시 psql 프로세스 잠금 경합으로 중단됐으나(데이터 변경 0·전부
> ROLLBACK), 단일 클린 실행에서 완주 PASS. 상세 §R1.

---

## 게이트별 결과

### R1 멱등성 — **PASS** (라이브 DRY-RUN 실측·완주)

`foil-prop-dryrun.sql`을 라이브에 BEGIN…body 2회…delta 판정…ROLLBACK으로 실제 실행:
- **PASS 1**(신규 삽입): 전 INSERT 성공(`INSERT 0 1` 전건)·FK/NOT NULL/CHECK/UNIQUE 위반 0. 카운트 실측:
  `COMP_FOIL_SETUP_LARGE 512 · COMP_FOIL_PROC_LARGE_STD 3328 · COMP_FOIL_PROC_LARGE_SPECIAL 3328` = **7,168** (설계 정확 일치).
  comps 3 · formulas 5 · formula_components 38 · bindings 6.
- **PASS 2**(재적용): `d_prices=0 · d_comps=0 · d_formulas=0 · d_fc=0 · d_bindings=0` → **`IDEMPOTENT: PASS`**.
- 종료 **ROLLBACK** — 사후 라이브 재조회 `COMP_FOIL_%LARGE%` = **0행**(커밋 누출 0 재확인).
- NOT EXISTS NULL-safe 가드 정합: 라이브 `ux_t_prc_comp_prices_nat_key`는 평범한 btree UNIQUE(NULLS DISTINCT 기본)
  → 박 단가행(siz_cd/mat_cd/opt_cd/clr_cd NULL)은 ON CONFLICT가 안 잡힘. ∴ `IS NOT DISTINCT FROM` 가드가 정답
  (재실행 0행·false-skip 0). body 내부 자연키 중복 0건(7,168 unique) 독립 확인.
- 운영 주의: 본문이 7,220 가드 INSERT × 2패스 × 원격 프록시라 1패스 ~30분대. **동시에 2개 psql을 띄우면 잠금 경합으로
  "idle in transaction" 스톨** — 단일 프로세스로 실행해야 함(검증 중 경합 txn 2건은 pg_terminate_backend로 정리, 전부
  롤백·데이터 변경 0). 실 적재 시에도 단일 트랜잭션·단일 세션 권장.

### R2 제약(FK/NOT NULL/CHECK/PK/UNIQUE) — **PASS** (라이브 스키마 독립 재측정)

- **FK proc_cd → t_proc_processes**: 037~044 8종 전부 라이브 실재(실측). body의 단가행은 STD={038,039,041,043}·
  SPECIAL={037,040,042,044}·SETUP=8색 union — 전부 037~044 범위 → **고아 0**. 금지색(045/046/047/048/049) 단가행 0건(전수 diff 확인).
- **NOT NULL**: component_prices NOT NULL = `comp_price_id`(IDENTITY)·`comp_cd`·`apply_ymd`·`reg_dt`(DEFAULT now()) 뿐.
  `min_qty·siz_width·siz_height·proc_cd·unit_price·note` 전부 nullable → 동판비 행(min_qty NULL) **합법**, 가공비 행
  min_qty(band 하한) 충전 확인. price_components NOT NULL = comp_cd·comp_nm·use_yn·reg_dt·del_yn('N' DEFAULT)
  (comp_typ_cd·prc_typ_cd·use_dims nullable) → INSERT 전부 충전. **NOT NULL 위반 0.**
- **CHECK**: component_prices에 CHECK 제약 없음 — 위반 대상 부재.
- **PK/UNIQUE**: `comp_price_id` IDENTITY BY DEFAULT(미지정 자동채번)·formula_components PK 충족·
  **binding PK=(prd_cd, apply_bgn_ymd)** (frm_cd 비포함) — 가드 `WHERE NOT EXISTS(... prd_cd=X AND apply_bgn_ymd='2026-07-01')`가
  PK와 정확 일치. 6상품 모두 2026-07-01 행 라이브 0건 → 1회 삽입·재실행 무동작. **무결성 OK.**
- 코드값 `PRICE_TYPE.03`·`PRC_COMPONENT_TYPE.01`·`PRC_COMPONENT_TYPE.05` 라이브 t_prc_price_components에서 실사용 중
  → FK 타깃 유효·코드 선적재 불요.

### R3 단가 verbatim — **PASS** (권위 CSV 독립 재-flatten·7,168행 전수 diff)

빌더의 하드코딩 dict를 **쓰지 않고** `price-foil-large-l1.csv` 셀을 직접 파싱:
- B01 동판비 8×8(가로×세로), B02/B04 면적격자 8×8→등급, B03/B05 등급단가표 13밴드×5등급을 독립 재구성
  → 격자 완전성 64/64/64·13밴드×5등급 전부 채움·**누락 셀 0**.
- flatten 재-join((proc_cd, w, h, min_qty)→단가) 후 body SQL 7,168행과 **전수 비교**:
  **VALUE MISMATCH 0 · MISSING 0 · EXTRA 0 · FORBIDDEN COLOR 0 · grade-in-note 실패 0.**
  커버리지: SETUP 8색×64셀=512·STD 4색×64×13=3328·SPECIAL 4색×64×13=3328 — 누락/초과 0.
- **grade=note 추적용만 확인**: 적재행 차원은 proc_cd·siz_width·siz_height·min_qty 뿐, siz_cd/clr_cd/opt_cd/mat_cd NULL.
  grade(A~E)는 note 텍스트에만(`등급{g}`) → 엔진 매칭 비사용. **dim_vals empty 확인.**
- **등록색상 필터 정합**: 미등록 048/049/046/047 단가행 0건(6상품 전수 product_processes 실측 = 037~044만 등록).

12 독립 샘플(일반/특수 혼합·등급경계·코너·off-band) 재-flatten ↔ build 대조(전부 OK):

| comp | proc | 면적 | 수량 | 등급 | indep | build |
|---|---|---|---|---|---|---|
| SETUP | 038 | 30×30 | — | — | 11,000 | 11,000 |
| SETUP | 042 | 170×170 | — | — | 64,000 | 64,000 |
| SETUP | 041 | 90×90 | — | — | 18,000 | 18,000 |
| STD | 038 | 30×30 | 10 | A | 55,000 | 55,000 |
| STD | 043 | 170×170 | 10000 | E | 2,000,000 | 2,000,000 |
| STD | 039 | 90×90 | 1000 | C | 120,000 | 120,000 |
| STD | 041 | 110×110 | 2000 | D | 320,000 | 320,000 |
| STD | 038 | 90×90 | 500(off-band) | C | 100,000 | 100,000 |
| SPECIAL | 037 | 30×30 | 10 | A | 65,000 | 65,000 |
| SPECIAL | 040 | 170×170 | 10000 | E | 2,500,000 | 2,500,000 |
| SPECIAL | 044 | 130×170 | 3000 | E | 750,000 | 750,000 |
| SPECIAL | 042 | 70×90 | 200 | B | 103,000 | 103,000 |

**provenance.csv 정합**: 7,168행 1:1(body rows missing 0·price mismatch 0·extra 0) — 각 단가행이 권위 셀
(`B01 동판비[가로w][세로h]` / `B03/B05[등급g][수량mq] + 면적격자[w][h]→g`)로 역추적 가능.

### R4 골든 독립 재계산 — **PASS** (pricing.py 의미 재구현·적재본 행 위에서)

`match_component`(siz_width/height=UPPER '이하' ceiling=min{t≥주문값}·min_qty=LOWER '이상'=max{t≤qty}·
proc_cd=NON_QTY_DIMS 정확매칭) + `component_subtotal`(.03 FLAT → `return up,up`·×qty 0)을 독립 재구현해
**body SQL에서 파싱한 실제 단가행**을 가격원천으로 재계산(빌더 golden 미재사용):

| 케이스 | 입력 | 동판비 | 박가공비 | 합계 | 권위 | 판정 |
|---|---|---|---|---|---|---|
| G-F1 | STD 038 90×90 q1000 | 18,000 | 120,000(C) | **138,000** | 138,000 | PASS |
| G-F2 | SPECIAL 037 90×90 q1000 | 18,000 | 150,000(C) | **168,000** | 168,000 | PASS |
| G-F3 | STD 039 30×30 q10 | 11,000 | 55,000(A) | **66,000** | 66,000 | PASS |
| G-F7 | SPECIAL 040 170×170 q1000 | 64,000 | 250,000(E) | **314,000** | 314,000 | PASS |
| G-F6 off-grid | STD 038 75×85→ceil 90×90 q1000 | 18,000 | 120,000(C) | **138,000** | 138,000 | PASS |
| G-F10 off-band | STD 038 90×90 q1500→band1000 | 18,000 | 120,000 | **138,000** | 138,000 | PASS |
| q899 회귀 | STD 038 90×90 q899→band500 | 18,000 | 100,000 | **118,000** | 118,000 | PASS |
| 미등록 백박046 | direct q1000 | no_match | no_match | **0** | 0 | PASS |
| 미등록 금무광048 | direct q1000 | no_match | no_match | **0** | 0 | PASS |
| 박 미선택(proc_cd None) | q1000 | no_match | no_match | **0** | 0 | PASS |

- **off-grid ceiling**: 75×85 → 가로 min{t≥75}=90·세로 min{t≥85}=90 → 90×90 셀(각 축 독립·아크릴 동형 `pricing.py:165-171`). 비대칭 ceiling 정확.
- **off-band .03 FLAT**: q1500→band1000·q899→band500, 곱셈 없음(`pricing.py:203-204`). `.02`였다면 q899=100000÷500×899=179,800 과청구
  → `.03 FLAT`이 회귀 가드 통과. **REV4 C-2(.02→.03) 교정이 옳음을 독립 확인.**
- **proc_cd 게이트**(REV3 R-FOIL-CDX1): 동판비·박가공비 단가행 전부 proc_cd 충전 → 박 미선택/미등록색상 = no_match → 0.
  명함박 SETUP=`["min_qty"]`(게이트 없음) 답습 안 함을 확인(7상품 박은 선택적이라 게이트 필수).
- **G-F7 백박046 주의**: 권위 골든의 백박046은 6상품 미등록 → 단가행 미생성. 동일 SPECIAL E단가(등록색 먹유광040)로
  314,000 재현(단가는 색상 무관·등급/수량만·B05 검증). 백박046 직접호출은 의도대로 0.
- **상한 초과 가드**: 90×180(세로>170) → `ERR_ABOVE_MAX`(엔진 차단·CONFIRM Q-FOIL-SIZE2와 정합).

### R5 공식 분기 무결성 — **PASS** (라이브 base 재조회 대조)

- **base 클론 충실(5/5 정확 일치)**: 라이브 formula_components를 재조회해 빌더 BASE_COMPONENTS와 전수 대조 —
  PRF_NAMECARD_PEARL(2)·PRF_DGP_E(9)·PRF_DGP_A(10)·PRF_BIND_MUSEON(1)·PRF_BIND_PUR(1) **disp_seq·addtn_yn·NULL
  까지 정확 일치**(PRF_DGP_A의 COAT_GLOSSY/MATTE disp_seq=NULL·PP_CORNER_RIGHT addtn_yn=NULL 보존 포함).
  분기 공식 = base 클론 + 박 comp 3행 append(소형은 SMALL 3·대형은 LARGE 3·base 최대 seq 뒤). formula_components
  합계 38(5+12+13+4+4)·orphan 0.
- **분기 공식 5종**(027·029 공유 PRF_DGP_E_FOIL 1벌 = 정확). frm 라이브 0건(search-before-mint).
- **재바인딩 = 신규 시계열 행**(apply_bgn_ymd=2026-07-01). 6상품 모두 현재 base 바인딩만 보유(029/027/042/069/070
  = 2026-06-01·034 = 2026-06-27) — 2026-07-01 라이브 0건 → 신규 1건씩·이중바인딩 0·base 미터치.
- **형제 공유공식 보호(라이브 실측)**:
  - **PRF_DGP_A 공유 10상품**(016~022·026·041·042) — 042만 재바인딩, **나머지 9 base 유지**.
  - **PRF_DGP_E 공유 3상품**(027·028·029) — 027/029만 재바인딩, **028 미니접지카드 base 유지**.
  - PRF_NAMECARD_PEARL = 034 단독. PRF_BIND_MUSEON/PUR = 069/070 단독.
  전부 박 노출 0·박 비대상 형제 가격 미변동.

### R6 독립성/무날조 — **PASS**

- 검증자(나)는 빌더가 아님. 단가는 권위 CSV 셀 직접 파싱으로 **독립 재-flatten**(빌더 dict·golden_recalc_large.py
  미재사용), 골든은 pricing.py 의미 재구현, base 클론은 라이브 재조회로 대조. 모든 값을 권위 셀 또는 라이브 행으로 역추적.
- **search-before-mint 재확인**: LARGE 3 comp·5 분기공식·LARGE 단가행 라이브 **전부 0건**(실측).
- **빌더가 주장했으나 재현 못한 값 = 0건.** README §9 카운트(512/3328/3328)·골든 10/10·멱등 PASS·provenance·등록색 필터
  전부 독립 실측으로 재확인.

---

## 적재 가능성 집계

| 분류 | 행수 | 비고 |
|---|---|---|
| 즉시적재(INSERTABLE) | **7,220** | comps 3·단가행 7,168·formulas 5·formula_components 38·bindings 6 |
| 차단(BLOCKED) | 0 | proc_cd 부모·코드값·base 공식 전부 라이브 실재 |
| GAP(에스컬레이션) | 0 | flatten으로 면적→등급 C트랙 소멸·신규 테이블/코드 0 |

## 결함 목록
**없음.** (BLOCKER 0 · MAJOR 0 · MINOR 0)

## 잔여 / 인간 결정 큐
- **실 COMMIT**: 인간 승인 후 `foil-prop-load.sql`의 `COMMIT` 주석 해제 1회(현재 COMMIT 0). **단일 세션·단일 트랜잭션 권장**(잠금 경합 회피).
- **박영역 상한 CONFIRM (Q-FOIL-SIZE2·실무·★적재 비차단)**: 027(170×220)·069/070(A4 210×297)은 트림이 대형격자(≤170)
  초과. 박영역(실제 박 크기)이 ≤170이면 단가/골든 정확. >170 박영역 가능 시 엔진 ERR_ABOVE_MAX → 위젯 박영역 입력 상한
  캡(트림 or 170). >170 박이 실제 가능하면 권위 가격표에 데이터 없음(별도 escalation). **단가·적재·골든 무관·돈크리티컬 아님.**
- **post-COMMIT 라이브 시뮬레이터 e2e**: 적재 후 webadmin price-simulator로 본체+박 합계 1회 확인 권장(현재 행 미적재라 순수함수 재계산이 대행).

## 검증 환경
- DB: railway (PostgreSQL·비표준 포트·읽기전용 SELECT + 롤백전용 DRY-RUN). 자격증명 `.env.local RAILWAY_DB_*`(미노출).
- 실 COMMIT 0 · 파괴적 쓰기 0 · DRY-RUN 사후 라이브 재조회로 무변경 확증.
