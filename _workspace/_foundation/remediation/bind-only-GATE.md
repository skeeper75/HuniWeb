# bind-only-GATE — BIND_ONLY 16건 독립 검증 게이트 (생성≠검증)

검증일 2026-06-26 · hsp-set-gate(검증자) · 라이브 읽기전용 SELECT + 롤백전용 DRY-RUN만 · 생성가 주장 비신뢰·16건 전수 직접 재실측.
대상 = PRF_CLR_ACRYL 15(147·148·149·150·151·152·155·156·157·158·159·160·161·162·166) + PRF_COROTTO_ACRYL 1(164).

## 종합 결론

**생성가 "전건 covered(전 사이즈 PRICE≠0)" 주장 = REFUTED.** 16건 중 10건이 **자기 등록 차원(nonspec 범위 또는 siz_cd)의 일부에서 PRICE=0**(본체 comp 매칭 실패 = no_tier_row). 단, 결함 성격은 **희소 매트릭스(sparse grid) 홀**이며 **이미 라이브에 배포된 동형 선례 PRD_000146(아크릴키링)과 동일**(146 커버율 65%·35% 홀). off-grid(ERR_ABOVE_MAX·자재 미등록)는 **0건** — 즉 "매트릭스 밖" 상품은 없고, 전부 매트릭스 안쪽 격자 누락.

- **GO (6건)** — 등록 사이즈(siz_cd)가 단가행에 ceiling 매칭: **157·158·159·160·161·162**.
- **CONDITIONAL-GO / 강등 (10건)** — 자기 차원 일부 미커버(PRICE=0 구간 존재): **147·148·149·150·151·152·155·156·164·166**. 바인딩 자체는 무해·멱등·안전(아래 S1/S3/S6 PASS)이나, "전건 견적가능" 보장 불가 → **부분커버 고지 하 바인딩 or 매트릭스 격자 보강(§18) 후 바인딩** 택일(인간/자율 판정).
- **CONFIRM** — 164 apply_bgn_ymd: COROTTO 기존 바인딩 0(고아공식) 확정 → 2026-06-15 가정 적정(단가행 2026-06-01 ≤ 2026-06-15, 활성). **PASS**.

## S1~S7 게이트 (16건 공통 + 개별)

| 게이트 | 판정 | 재실측 근거 |
|--------|------|------------|
| S1 공식 실재·comp 배선 | **PASS** | PRF_CLR_ACRYL·PRF_COROTTO_ACRYL 둘 다 t_prc_price_formulas use_yn=Y 실재. fc 배선 각 1행(CLR→COMP_ACRYL_CLEAR3T·COROTTO→COMP_ACRYL_COROTTO). FK frm_cd 고아 0 |
| S2 prd 유형 | **PASS** | 16건 전부 PRD_TYPE.01(완제품)·del_yn=N. 단일 완제품(셋트 구성원 아님) |
| S3 무결성(이중합산·PK·FK) | **PASS** | 16건 전부 t_prd_product_sets 부모 아님(is_set_parent=0)→이중합산 0. 기존 바인딩 0(멱등 baseline clean). PK=(prd_cd,apply_bgn_ymd) |
| **S4 가격 e2e [HARD]** | **부분 FAIL** | 본체 comp는 면적매트릭스(use_dims=[siz_width,siz_height(,mat_cd)]). pricing.py ceiling 재현 결과 **6건 GO·10건 자기차원 일부 PRICE=0**(no_tier_row). 상세 = `price-e2e-trace.md` |
| S5 경쟁사 흡수 | **N/A(PASS)** | 신규 naming/codes 유입 없음. 기존 공식·기존 단가행 재사용(날조 0·단가값 무수정) |
| S6 적재 가능성 DRY-RUN | **PASS** | BEGIN→+16→멱등 +0→ROLLBACK 실증. 라이브 무변경(사후 16건 바인딩 여전히 0). 제약위반 0 |
| S7 생성≠검증 독립성 | **PASS** | 생성가 "전건 covered" 인용 안 함. pricing.py 순수함수 verbatim 이식 harness + 라이브 단가행 JSON 덤프로 16건 전수 재계산. 생성가 주장 적극 반증함 |

## S4 차원 커버리지 — 16건 전수 재측정 (핵심)

매칭 규칙(pricing.py:122 `match_component`): 사이즈는 '주문값 이상 임계 중 최소'(ceiling), 미존재 시 ERR_ABOVE_MAX. ceiling된 (w,h) 쌍에 행이 없으면 **no_tier_row → matched_row=None → 본체 PRICE=0**(line 444 경고, error 아님). mat_cd=NULL 행은 와일드카드(line 87-88)라 자재 매칭은 통과.

★엔진 입력 경로: 시뮬레이터는 **nonspec_yn=Y일 때만** siz_width/siz_height를 selections에 주입(price_simulator.html:360). nonspec=N(siz_cd 선택형)은 siz_cd만 전달 → 엔진에 w/h 미주입(엔진 한계). 아래 표는 nonspec=N도 등록 사이즈의 cut_width/height를 공급한 보수적(상품에 유리한) 가정.

| prd | nonspec | 판정 | 미커버 증거(ceiling 매칭 실패) |
|-----|---------|------|------------------------------|
| 147 아크릴마그넷 | Y(20-80²) | NO-GO | 80x20·격자169점 미커버60(64%). 비대칭/희소홀 |
| 148 아크릴뱃지 | Y(30-80²) | NO-GO | 30x80·격자121 미커버38(69%) |
| 149 아크릴집게 | Y(30-60²) | NO-GO | 60x30·격자49 미커버14(71%) |
| 150 아크릴스마트톡 | Y(50-80²) | NO-GO | 50x80·격자49 미커버12(76%) |
| 151 맥세이프스마트톡 | Y(50-80²) | NO-GO | 50x80·격자49 미커버12(76%) |
| 152 아크릴명찰 | Y(60-80×20-50) | NO-GO | 60x50·80x20·격자35 미커버20(43%·최악) |
| 155 아크릴볼펜 | Y(20-40²) | NO-GO | 40x20·격자25 미커버8(68%) |
| 156 아크릴지비츠 | Y(15-35²) | NO-GO | 35x15·격자25 미커버8(68%) |
| **157 아크릴네임택** | N(siz_cd) | **GO** | 등록 2사이즈 전건 ceiling 행 실재 |
| **158 아크릴포카키링** | N | **GO** | 등록 1사이즈(55x86) covered |
| **159 아크릴코스터** | N | **GO** | 등록 2사이즈 covered |
| **160 아크릴자유형스탠드** | N | **GO** | 등록 5사이즈 covered |
| **161 판아크릴** | N | **GO** | 등록 2사이즈 covered |
| **162 아크릴포카스탠드** | N | **GO** | 등록 1사이즈(68x103) covered |
| 164 아크릴코롯토 | Y(30-80²) | NO-GO | 30x80·격자121 미커버50(59%). COROTTO 21행 매트릭스 |
| 166 아크릴카라비너 | N(siz_cd) | NO-GO | 등록 사이즈 43x71(하트자물쇠)→ceil 50x80 행없음 |

**선례 parity 입증:** 이미 라이브 바인딩된 PRD_000146(아크릴키링·nonspec 20-100²·dflt MAT_043·동일 매트릭스) = 격자289 미커버100(커버율 65%). 즉 sparse-grid 홀은 16건이 만든 신규 결함이 아니라 **운영 중 동형 상품의 기존 특성**.

## CONFIRM / DRY-RUN delta

- **DRY-RUN(`bind-only-dryrun.sql`)**: before=0 → after_1st=16(INSERT 0 15 + 0 1) → after_2nd_idempotent=16(INSERT 0 0·멱등) → ROLLBACK. 사후 라이브 16건 바인딩 = 0(무변경 재확인). **S6 PASS**.
- **CONFIRM-164-ymd**: PRF_COROTTO_ACRYL 기존 바인딩 COUNT=0(고아) 확정. apply_bgn_ymd 2026-06-15 가정 = 단가행 2026-06-01 이후·동군(146) 2026-06-15 정합 → **적정**.
- **apply_bgn_ymd 정합(전 16건)**: 단가행 apply_ymd 전부 2026-06-01 ≤ 바인딩 2026-06-15 → 매칭 성립. PASS.

## 재현 자산

- `_workspace/_foundation/remediation/_gate_harness.py` — pricing.py 매칭 verbatim 이식 + 라이브 단가행/상품차원 JSON 입력. 재실행으로 16건 + 146 선례 전수 재계산.
- 라이브 덤프(/tmp): clr3t_rows.json·corotto_rows.json·prods.json(휘발).
