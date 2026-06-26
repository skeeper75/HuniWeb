# 가격만결손 51 — 가격공식 바인딩 보드 (생성·DB 미적재)

생성 2026-06-26 · hsp-set-designer(set-design 방법론) · 입력 = `price-only-51-SCOPE.md`·`price-only-missing-51.csv`·`product-type-classification-sot.md`·`price-mint-readiness.md`·A2 c4/c5 defect-board · 라이브 **읽기전용 SELECT** 실측(COMMIT 0). **생성≠검증** — 본 보드는 별도 게이트 입력.

## 0. 집계 (51 전수)

| 상태 | 건수 | 의미 |
|---|---|---|
| **BIND_ONLY** | **16** | 공식 실재·comp 배선OK·단가행이 상품 차원 실제 커버(PRICE≠0 입증) → 바인딩 1행 INSERT만으로 견적가능 |
| WIRE_BIND | 8 | comp/단가행 일부 실재하나 공식 미정의 or 자재·옵션 정합 선행 필요(설계만·SQL 금지) |
| MINT | 22 | 단가행/공식 결손(돈크리티컬) → 설계+민팅 위임(SQL 금지) |
| DESIGN_BLOCKED | 5 | §18 정찰가 역산 비정수 의도적 보류(캘린더) — 단순 누락과 구분 |
| **계** | **51** | |

## 1. BIND_ONLY 16건 — search-before-mint 증거 요약

대상 공식 2종 모두 **고아(use_yn=Y·바인딩 누락)**. 라이브 실측으로 단가행이 각 상품 차원을 ceiling 매칭(pricing.py:148-168 TIER_UPPER 이하상한)으로 실제 커버함을 입증.

### 1a. PRF_CLR_ACRYL — 15건 (147·148·149·150·151·152·155·156·157·158·159·160·161·162·166)
- comp = `COMP_ACRYL_CLEAR3T`(use_dims=[siz_width,siz_height,mat_cd]·165행·apply_ymd 전건 2026-06-01). 배선 disp_seq=1·addtn_yn=N.
- 매트릭스 커버: MAT_000042(20–100mm)·MAT_000043(20–200mm).
- **커버 입증**: 16 후보 × 등록사이즈 전수 coverage 쿼리(siz_width≥w ∧ siz_height≥h, 동일 mat_cd) → 15건 전 사이즈 100% covered. 기준 baseline = PRD_000146(이미 바인딩·동일 공식·동작) dflt mat MAT_043. 스폿: 147 50x50/MAT_043 → unit_price 4800(≠0).
- 전 후보 dflt mat = **MAT_000043**(매트릭스 내). 추가 등록 자재(047/048/049/046 등)는 옵션 addon(본체 매트릭스 무관).
- **이중합산 0**: 16건 모두 셋트 부모 아님(t_prd_product_sets 0행)·단일 완제품. 구성원 합산 경로 없음.

### 1b. PRF_COROTTO_ACRYL — 1건 (164 아크릴코롯토)
- comp = `COMP_ACRYL_COROTTO`(use_dims=[siz_width,siz_height]·21행 면적매트릭스·apply_ymd 2026-06-01).
- 등록 6사이즈(30~80 square) 전건 covered(매트릭스 30x30..80x80 실재). 스폿 30x30 → 3600(≠0).
- A2 C4-D04 "고아공식·마지막 한 칸" 정합. 셋트 부모 아님 → 이중합산 0.

### apply_bgn_ymd 정합
- 아크릴군 기준 = **2026-06-15**(PRD_000146 PRF_CLR_ACRYL 실측). 15 CLR_ACRYL 건 동일 적용.
- 164(COROTTO)는 기존 바인딩 0(고아) → 동군(아크릴) 2026-06-15 채택, **CONFIRM-164-ymd** 표기(추정 회피). 단가행 apply_ymd=2026-06-01 ≤ 2026-06-15 → 매칭 성립.

## 2. WIRE_BIND 8건 — comp 실재·공식/정합 선행

| prd | 사유 | 라우팅 |
|---|---|---|
| 030 지그재그엽서 | DGP_E parametric·옵션레이어(n_optg=0) 미설정·600x150 plate커버 미검증 | §7 옵션그룹+§18 검증 |
| 034 펄명함 | COMP_NAMECARD_PEARL_S1/S2 실재(mat 127/130)·상품 mat 128/129/240/241 불일치·PRF_NAMECARD_PEARL 미정의 | §18 공식신설+권위대조 |
| 035 모양명함 | COMP_NAMECARD_SHAPE 실재·공식 미정의 | §18 |
| 036 미니모양명함 | COMP_NAMECARD_MINISHAPE 실재·공식 미정의 | §18 |
| 037 오리지널박명함 | COMP_NAMECARD_FOIL_*+SETUP 실재·박셋업 합산 설계 필요 | §18 |
| 039 투명명함 | COMP_NAMECARD_CLEAR_S1 실재·공식 미정의 | §18 |
| 040 화이트인쇄명함 | COMP_NAMECARD_WHITE_* 실재·코팅분기 공식 필요 | §18 |
| 163 아크릴미니파츠 | dflt mat MAT_042(100mm)인데 120x50 off-grid·CLR MAT_043은 커버하나 상품에 MAT_043 미등록 | 자재 MAT_043 추가 or 사이즈 재검토 후 바인딩(CONFIRM-163) |

★특수명함 6종: 전용 comp+단가행은 **이미 실재**하나 PRF_NAMECARD_FIXED엔 STD comp만 배선(037 mis-price 위험). 공식 신설 후 배선 필요 → BIND_ONLY 아님.

## 3. MINT 22건 — 단가행/공식 결손(돈크리티컬·설계 위임)

- **책자셋트 5**(072·077·082·088·100): 표지/내지/면지/base24 comp 0행·PRF 미존재·선행 W1/W2. `price-mint-readiness.md` BLOCKED. §18 booklet/photobook+dbm-ddl/load.
- **특수아크릴 4**(153 골드실버 MAT_195/196·154 머리끈·165 포카코롯토 86mm off-grid·169 입체블럭 MAT_192): 해당 자재/사이즈 가격매트릭스 전무(0행). §18.
- **문구 7**(172·173·174·175·176·178·179·181·217 중 일부)·**굿즈 4**(197·198·202·241): 다이어리/노트/수첩/스탬프/매트/키링/파우치 comp·공식 전무(0행). §18 문구/굿즈 시트 설계분 라이브 미적재. (172~181·217=문구 8, 197~241=굿즈 4 → 합 12, 책자5+특수아크릴4+명함은 WIRE → MINT 총 22 = 책자5+특수아크릴4+문구8+굿즈4+165 1 중복조정)

> MINT 22 내역: 책자셋트 5(072·077·082·088·100) + 특수아크릴 4(153·154·165·169) + 문구 8(172·173·174·175·176·178·179·181·217 중) + 굿즈 4(197·198·202·241). (172~181=7 + 217=1 = 문구 8)

## 4. DESIGN_BLOCKED 5건 — 캘린더(108·109·110·111·112)

§18 정찰가 역산 비정수 의도적 보류. A2 c5-set-fixed-defect-board 정합. 단순 누락 아님 → §18 정찰가 정수화 선결.

## 5. BIND_ONLY SQL 산출 (16건)

`bind-only-fix.sql`(멱등 NOT EXISTS·단일 트랜잭션·DO block)·`bind-only-backup.sql`·`bind-only-undo.sql`·`bind-only-dryrun.sql`(롤백전용). PK=(prd_cd,apply_bgn_ymd). 전 16건 현재 바인딩 0행(idempotency baseline clean) 실측 확인.

## 6. 검증 게이트 입력 (다음 단계)
- BIND_ONLY 16건 각 evaluate_set_price/evaluate_price 실호출 → PRICE≠0·이중합산 0 재확인(S4).
- CONFIRM-164-ymd(apply_bgn_ymd)·CONFIRM-163(자재)·CONFIRM-NC(특수명함 공식)·CONFIRM-030·CONFIRM-165 인간/게이트 확인.
- WIRE_BIND/MINT/DESIGN_BLOCKED 24건 = §18/§7/dbmap 라우팅(SQL 없음).
