# 디지털인쇄비 가격표 import 준비 — 독립 검증 게이트 (P1~P6)

> **검증자** dbm-validator · **2026-06-13** · round-16 파일럿. 생성자(dbm-price-import-builder)≠검증자.
> **대상** `_workspace/huni-dbmap/20_price-import/digital-print/{digital-print-structure.md, digital-print-decomposition.md, digital-print-import.xlsx(8시트), digital-print-mapping-flow.md}`
> **권위** 가격표 원본 `docs/huni/후니프린팅_인쇄상품_가격표_260527.xlsx` 시트 `디지털인쇄비`(openpyxl data_only) · 라이브 `t_prc_*`+`t_prd_product_price_formulas` information_schema(읽기전용 SELECT 실측 2026-06-13) · `11-CONTEXT.md` Phase11 규칙 · `18_schema-change/impact-diagnosis.md` · round-2 `02_mapping/digital-print-engine/`.
> **방법** 라이브 컬럼·기존 적재 행수 실측 + openpyxl 원본 954셀 전수 round-trip + 그릇 954행 자연키/NULL/값 실측 + 그릇↔라이브 954행 집합 동일성. "맞아 보임" 금지.

---

## 종합 평결: **GO** (BLOCKER 0 · MAJOR 0 · 정직 컨펌 2)

8시트 그릇이 라이브 `t_prc_*` 6테이블과 1:1 정합하고, 가격표 디지털인쇄비 954 데이터셀 ↔ 그릇 954행 ↔ 라이브 954행이 **3중 무손실(전수 mismatch 0·집합 완전 동일)**로 실증되었다. 스티커 1차의 F1(frm_typ_cd 잉여)·F2(NULL siz 회귀)가 디지털에서는 **선제적으로 회피**됨 — 1_price_formulas는 라이브 컬럼만 쓰고, 미적재분(3절 별색·BLOCKED 3상품)은 NULL 강제 없이 GAP/BLOCKED 시트로 정직 분리. "round-2 308행 재사용·신규 0" 주장은 라이브 실측으로 **거짓이 아님**(그릇=라이브 재현, 중복 적재 위험 0). 잔존 = 정직 컨펌 2건(단/양면 구성요소 정책 Q-DGP-1·3절 별색 GAP 처분 Q-DGP-2), 차단 아님.

| 게이트 | 결과 | 핵심 증거 |
|--------|------|----------|
| P1 그릇 정합 | **PASS** | 6시트 ↔ 라이브 6테이블 1:1. 1_price_formulas=frm_cd·frm_nm·use_yn·note(frm_typ_cd 부재 확인). component_prices 10차원·frm_typ_cd 부존재 반영 |
| P2 stale 차단 | **PASS** | Phase11 신설(prc_typ_cd·use_dims·proc_cd·opt_cd 컬럼) 전건 반영. round-2 "8차원" 잔재 0 |
| P3 분해 무손실 | **PASS** | 원본 954셀(742+212) ↔ 그릇 954행 **전수 round-trip mismatch 0**. 부유셀 "까지"(A57) 오포함 0. NULL unit_price 0 |
| P4 단가/합가 정당 | **PASS** | 세트/묶음/총액 키워드 0(합가형 지표 부재) → 전건 단가형(.01) 정당. 장당가 수량↑ 체감 실측 |
| P5 동시매칭 0 | **PASS** | 그릇 954행 10차원 자연키 중복 0 = 라이브 중복 0(실측). 별색 clr=NULL 분리 충돌 0 |
| P6 엔진 시뮬레이션 | **PASS** | E26(CMYK 양면 100매)=700 ↔ 라이브 DIGITAL_S2[499,005,100]=700. 별색 GOLD_S2 q1=6000 일치 |
| 추가: 재사용·신규 0 | **PASS(거짓 아님)** | 그릇 954행 == 라이브 954행(집합 완전 동일). binding 19·wiring 72·formula 6 전건 라이브 재현. 중복 적재 위험 0 |

---

## P1 그릇 정합 — PASS

라이브 information_schema 실측(읽기전용 2026-06-13):

| 그릇 시트 | 라이브 테이블 | 라이브 컬럼(실측) | 그릇 헤더 | 판정 |
|-----------|--------------|-------------------|-----------|------|
| `1_price_formulas_RU` | `t_prc_price_formulas` | frm_cd·frm_nm·note·use_yn(+reg_dt/upd_dt 자동) | frm_cd·frm_nm·use_yn·note | ✅ 1:1 (순서차 무해·복붙 헤더매칭) |
| `1b_product_price_formulas_RU` | `t_prd_product_price_formulas` | prd_cd·frm_cd·apply_bgn_ymd(+note/reg_dt/upd_dt) | prd_cd·frm_cd·apply_bgn_ymd | ✅ 1:1 (바인딩 분리 정확) |
| `2_formula_components_RU` | `t_prc_formula_components` | frm_cd·comp_cd·disp_seq·addtn_yn | 동일 | ✅ |
| `3_price_components_print_RU` | `t_prc_price_components` | comp_cd·comp_nm·comp_typ_cd·note·use_yn·prc_typ_cd·use_dims | comp_cd·comp_nm·comp_typ_cd·prc_typ_cd·use_dims·use_yn | ✅ (NOT NULL use_yn 존재) |
| `4_component_prices_print_RU` | `t_prc_component_prices` | comp_cd·apply_ymd·siz_cd·clr_cd·mat_cd·coat_side_cnt·bdl_qty·min_qty·unit_price·proc_cd·opt_cd (10차원 자연키) | 11컬럼 동일 | ✅ (proc_cd 라이브 14번·복붙 무해) |

- **핵심**: `t_prc_price_formulas`에 **frm_typ_cd 컬럼이 라이브에 부존재**(ordinal 3 결번=drop 흔적) — structure/decomposition이 "frm_typ_cd 없음(라이브 실측 확정)"이라 명시했고 그릇 1_price_formulas에 실제로 미포함. **스티커 1차 F1(frm_typ_cd 잉여 BLOCKER)를 디지털은 선제 회피**.
- 공식정의(1)·상품바인딩(1b) 분리가 라이브 권위와 정확 일치.
- `component_prices` 10차원(8→10, proc_cd·opt_cd 신설) 반영 확인.

---

## P2 stale 차단 — PASS

Phase11 신규(impact-diagnosis 기준) 전건 반영:
- `prc_typ_cd`(PRICE_TYPE.01 단가형) ✅ 3_price_components 12행 전건.
- `use_dims` jsonb ✅ DIGITAL=`["siz_cd","clr_cd","min_qty"]`·SPOT=`["siz_cd","min_qty"]` — 라이브 실측값과 byte 일치.
- `proc_cd`·`opt_cd` 신설 차원 ✅ 4_component_prices 컬럼 존재(인쇄비는 미사용 NULL — 정당).
- round-2 "8차원 암묵 단가형" 잔재 0 — 단가/합가 축 명시(.01)로 해소.

스티커 1차의 round-2 BLOCKED 회귀(NULL siz 적재) 같은 stale 차단 실패 **없음** — 디지털은 미적재분을 GAP/BLOCKED 시트로 분리(P5 참조).

---

## P3 분해 무손실 — PASS

openpyxl 원본 셀 전수 실측 ↔ 그릇 954행 round-trip:

| 블록 | 원본 데이터셀(none 0) | 그릇 행 | round-trip mismatch |
|------|----------------------|---------|---------------------|
| B01 국4절(rows4-56 × colsB-O) | 53×14 = **742** | 742(DIGITAL 424+SPOT 318) | **0** |
| B02 3절(rows64-116 × colsB-E) | 53×4 = **212** | 212(DIGITAL 212) | **0** |
| **합** | **954** | **954** | **0** |

- **전수 round-trip 954/954 mismatch 0**: 도수 7종×면 2종 분해 규칙(흑백/CMYK→clr_cd, 별색5→구성요소, 단/양→_S1/_S2)이 **모든 셀에서 정확**히 원본↔그릇 일치. 독립 재계산(원본 셀 좌표 직접 매핑)으로 검증.
- **부유셀 오포함 0**: `A57="까지"`는 데이터 범위(rows 4~56) 밖이라 미포함 확인. note 보존 표기.
- **값 보존**: NULL unit_price 0, B01 742셀 + B02 212셀 모두 원본 셀값 = 그릇 unit_price 동일.
- 수량축 53구간(1·2…1000000) B01·B02 동일 실측, min_qty distinct=53.

---

## P4 단가/합가 정당 — PASS

원본 거동 적대 실측:
- **합가형 지표 부재**: 원본 전 텍스트셀 스캔 — `세트·묶음·총액·장당·조당` 키워드 **0건**. 스티커(타투 "3장마다 4000"·팩 "54장 1세트")와 달리 디지털인쇄비는 세트 단위 표기 없음. → **합가형(.02) 0건 = 맞음**(원본 확인).
- **단가형 거동**: CMYK 양면 수량축 6000→4600→4300→3500→3000…290(장당가 수량↑ 체감). 대량 구간 평탄(290=290)은 단가형 정상 거동(세트 총액 일정이 아니라 장당 단가 바닥). 전건 `.01` 단가형 정당.
- 추정 0 — 가격표 수량축 "수량(국4절/3절)"이 곱셈 거동 근거.

---

## P5 동시매칭 0 — PASS

그릇 954행 10차원 자연키 `(comp_cd,apply_ymd,siz_cd,clr_cd,mat_cd,proc_cd,opt_cd,coat_side_cnt,bdl_qty,min_qty)` 중복 실측:
- **중복 키 0 · 중복 행 0**(그릇 직접 검산).
- 라이브 954행 동일 자연키 중복 실측 = **0**(라이브 `ux_t_prc_comp_prices_nat_key` 위반 0).
- 별색 SPOT 530행 clr_cd 전건 NULL → DIGITAL(clr 채움)과 comp_cd 분리되어 충돌 0. SPOT rows with non-null clr = 0.
- proc/opt/mat 전건 NULL(인쇄비 미사용 차원) — use_dims 선언과 정합.
- 스티커 1차의 NULL-siz 충돌(240 중복) 같은 결함 **없음** — 디지털 NULL siz_cd = 0.

---

## P6 엔진 시뮬레이션 — PASS

그릇 단가 ↔ 라이브 ↔ 원본 3중 대조(대표 + 별색 합산 1건):
- **016 프리미엄엽서 CMYK 양면 국4절 100매**(decomposition §8 검산): 그릇 DIGITAL_S2[SIZ_000499,CLR_000005,min_qty=100]=**700** ↔ 라이브 동일=700 ↔ 원본 E26=700. **3중 일치**. 엔진 `700 × 출력매수`(단가형) 정합.
- **별색 합산**: GOLD_S2[SIZ_000499,min_qty=1]=**6000** ↔ 라이브=6000 ↔ 원본 M4=6000. 합산형 공식 PRF_DGP_A에서 인쇄비(DIGITAL) + 별색(SPOT_GOLD) 별 구성요소로 Σ 합산(addtn_yn=Y) — 별색=공정 분리 정당.
- 3절 흑백 단면 q1: 그릇=3500 ↔ 라이브=3500 ↔ 원본 B64=3500.
- 동시매칭 0(자연키 유일)이라 min_qty 상향구간 매칭 1행만 — 계산 모호성 없음.

---

## 추가: "전건 재사용·신규 0" 주장 검증 — PASS(거짓 아님)

라이브 기존 적재 실측(읽기전용 2026-06-13):
- `PRF_DGP_A~F` 6공식 ✅ 라이브 실재(F=use_yn N 미출시).
- `formula_components` DGP 배선 = **72행** ✅(그릇 72 일치).
- `product_price_formulas` DGP 바인딩 = **19행** ✅(그릇 19 일치, PRD_000016~051).
- `component_prices` 인쇄비 = **954행** ✅(DIGITAL 212×2=424 + SPOT 53×10=530).
- **그릇 954행 == 라이브 954행 집합 완전 동일**(grid-only 0·live-only 0).

→ 그릇은 라이브 기존 적재의 **충실 재현(RU)**이지 신규 적재가 아님. webadmin 복붙 시 동일 자연키 UPSERT(멱등) — **중복 적재 위험 0**. "round-2 308행"의 "308"은 round-2 *디지털 3트랙 신규분* 카운트(디지털147+ENV40+GP121=308, 메모리 dbmap-digitalprint)이고, 이 시트의 인쇄비 954행은 그 중 디지털인쇄비 component_prices 부분 — round-16은 **재적재가 아니라 그릇 재현·정직표기**라는 산출 주장과 정합.

---

## GAP / BLOCKED 정직표기 검증 — PASS

| 시트 | 내용 | 라이브 실측 | 판정 |
|------|------|------------|------|
| `4b_..._GAP` (3절 별색 10행) | SIZ_000077 SPOT 5종×2면·unit_price=NULL "(가격표 부재)" | 라이브 3절 SPOT = **0행** | ✅ 가격표 B62에 별색 부재·라이브도 국4절만 → GAP 정상(NULL 강제 아님·미적재 자리) |
| `9_BLOCKED_binding` (3상품) | 019 투명엽서·030 지그재그·049 와이드리플렛 | 019/030/049 라이브 바인딩 = **부재** | ✅ siz 미채번/plate 결함 분리(round-2 D-2/D-5)·NULL 강제 0 |

siz 코드 실재: SIZ_000499(316x467 국4절)·SIZ_000077(300x625 3절) 라이브 실측 일치(siz_nm 정합). 발명 코드 0.

---

## 보정 라우팅 — 없음 (차단 0)

차단·MAJOR 결함 0. 라우팅 불필요. 잔존은 정직 컨펌(추적만):

| ID | 컨펌 | 심각도 | 라우팅(컨펌 시) |
|----|------|--------|----------------|
| Q-DGP-1 | 단/양면 별 구성요소(_S1/_S2) vs coat_side_cnt 통합 — 라이브 현행=별 구성요소. round-15 그릇 단순화 의도와 충돌 여부 | 정직 컨펌(차단 아님·라이브 현행 답습) | dbm-mapping-designer(정책 확정 시) |
| Q-DGP-2 | 3절 별색 영구 부재 vs 향후 추가 — GAP 시트 처분 | 정직 컨펌(차단 아님) | 사용자 결정 |
| Q-DGP-3(참고) | 019/030/049 siz 채번·plate 교정(round-2 컨펌 ③) | BLOCKED 분리(이 시트 범위 밖) | dbm-mapping-designer/인간 승인 |

---

## 게이트별 1줄 + 집계

- **P1 PASS** — 6시트 ↔ 라이브 6테이블 1:1, frm_typ_cd 부재 반영(스티커 F1 선제 회피)
- **P2 PASS** — Phase11 신설 차원 전건 반영, round-2 8차원 잔재 0
- **P3 PASS** — 원본 954셀 ↔ 그릇 954행 전수 round-trip mismatch 0, 부유셀 오포함 0
- **P4 PASS** — 합가형 키워드 0(전건 단가형 .01 정당), 장당가 체감 실측
- **P5 PASS** — 그릇·라이브 954행 자연키 중복 0, 별색 clr=NULL 분리 충돌 0
- **P6 PASS** — E26=700·GOLD q1=6000 그릇↔라이브↔원본 3중 일치
- **추가 PASS** — 그릇 954행 == 라이브 954행(집합 동일), 재사용·신규 0 거짓 아님, 중복 적재 위험 0

**삽입가능/차단/GAP 집계:**
- 삽입가능(=라이브 기존 재현·멱등): main **954행** + formula 6 + binding 19 + wiring 72 + components 12
- BLOCKED(siz/plate 결함, 별 트랙): **3 바인딩**(019/030/049)
- GAP(가격표·라이브 동시 부재·정직표기): **10행**(3절 별색)

---

**최종 한 줄 평결: GO** — 디지털인쇄비 8시트 그릇 독립 검증 완료. 원본 954셀 ↔ 그릇 954행 ↔ 라이브 954행 **3중 무손실**(전수 mismatch 0·집합 완전 동일). 라이브 6테이블 1:1(frm_typ_cd 부재 반영=스티커 F1 선제 회피)·10차원·단가형 전건(.01)·동시매칭 0. 미적재(3절 별색 GAP 10·BLOCKED 바인딩 3)는 NULL 강제 없이 정직 분리. "재사용·신규 0" 주장 거짓 아님(그릇=라이브 재현·중복 적재 위험 0). 잔존=정직 컨펌 2건(Q-DGP-1 단양면 정책·Q-DGP-2 3절 별색 처분), 차단 아님.
