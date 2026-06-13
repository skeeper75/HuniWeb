# 엽서북떡메 그릇 import 독립검증 게이트 (postcard-book-memo-gate) — round-16

> **검증자** dbm-validator(생성자≠검증자) · 2026-06-13 · round-16 (A) 엽서북떡메.
> **방법** 라이브 `t_prc_*` information_schema + 행데이터 read-only SELECT 직접 실측 + 원본 가격표 openpyxl `data_only` 직접 카운트. **빌더 psv 덤프 불신·라이브를 재실측.** DB 미적재.
> **대상** `20_price-import/postcard-book-memo/{structure, decomposition, import.xlsx, mapping-flow}`.

---

## 종합 평결: **GO** (P1~P6 전건 PASS)

빌더 주장(580 무손실·전건 단가형·단절 2건·BLOCKED 0)이 **라이브 실측으로 전건 재현 확인**. 뒤집힌 항목 0. 단, P1에서 **그릇 컬럼 누락 4개(자동/메타 컬럼)에 대한 명시 부재**를 MINOR로 적출(복붙 시 무해하나 문서화 권장).

---

## P1~P6 게이트 표

| 게이트 | 판정 | 핵심 근거(직접 실측) |
|--------|------|---------------------|
| **P1 그릇 정합** | ✅ PASS (MINOR 1) | 라이브 `t_prc_price_formulas` 컬럼=`frm_cd,frm_nm,note,use_yn,reg_dt,upd_dt` — **frm_typ_cd·prd_cd 부존재 확인**(스티커 P1 BLOCKER 재발 0). `t_prd_product_price_formulas`(별 테이블) 분리 정확. import.xlsx 각 _RU 시트 DB컬럼 행이 라이브와 1:1. |
| **P2 stale 차단** | ✅ PASS | `t_prc_component_prices` 라이브=10차원(siz/clr/mat/coat_side_cnt/bdl_qty/min_qty/proc_cd/opt_cd + comp_cd/apply_ymd). proc_cd·opt_cd 신설 반영. 8차원 stale 회귀 0. BLOCKED분 NULL 회귀 포함 0(BLOCKED 자체 0). |
| **P3 분해 무손실** | ✅ PASS | openpyxl 직접 카운트: B1 엽서북 39행×12열=**468**(holes 0) + B2 떡메 28행×4열=**112**(holes 0) = **580**. 라이브 component_prices 580행(S1/S2×20P/30P 각 117 + TTEOKME 112). import.xlsx 580행. **3원 set 비교 차이 0**(in-live-not-sheet 0·in-sheet-not-live 0). |
| **P4 단가/합가 정당** | ✅ PASS | 라이브 5 comp 전건 `prc_typ_cd=PRICE_TYPE.01`. 원본 colB 단가열 두 블록 전건 monotone non-increasing(엽서북 11000→2200·떡메 3000→850, 수량↑단가↓). **"합가형 세트"(구간총액÷환산) 거동 부재** — 빌더 가설 반증이 데이터로 옳음. |
| **P5 동시매칭 0** | ✅ PASS | 자연키 (comp_cd,siz_cd,bdl_qty,min_qty) GROUP BY HAVING count>1 = **0행**. siz_cd=NULL 강제 없음(엽서북 siz 3종·떡메 siz 2종 전부 실값). |
| **P6 엔진 시뮬+가격사슬** | ✅ PASS | **단절1 실재**: `t_prc_formula_components` PRF_PCB_FIXED 배선=S1_20P(seq1)·S2_20P(seq2)만 — S1_30P·S2_30P 배선 **0행**. **단절2 실재**: `t_prd_product_price_formulas` PRD_000097 바인딩 **0행**(PRD_000094만 존재). 교정 시트 정합(8_FIX +2행·9_FIX +1행, DDL 불요·기존행 무손상). 사이즈 5종 라이브 전건 실재. |

---

## 직접 실측 인용 (라이브 + openpyxl)

### P1 — 라이브 컬럼 (information_schema, 2026-06-13)
```
t_prc_price_formulas:  frm_cd, frm_nm, note, use_yn, reg_dt, upd_dt   ← frm_typ_cd·prd_cd 없음 ✅
t_prd_product_price_formulas: prd_cd, frm_cd, apply_bgn_ymd, note, reg_dt, upd_dt  ← 별 테이블 ✅
t_prc_formula_components: frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt, upd_dt
t_prc_price_components: comp_cd, comp_nm, comp_typ_cd, note, use_yn, reg_dt, upd_dt, prc_typ_cd, use_dims(jsonb)
t_prc_component_prices: comp_price_id(PK bigint), comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd,
                        coat_side_cnt, bdl_qty, min_qty, unit_price, note, reg_dt, upd_dt, proc_cd, opt_cd
```

### P3 — openpyxl 원본 직접 카운트 (빌더 psv 불신·재현)
```
엽서북 헤더 행2 사이즈: 100*150 / 150*100 / 135*135
       행3 인쇄: 단면 / 양면      행4 페이지: 20P / 30P
B1: qty rows 39 (2.0~3000.0), data cells 468, holes 0
B2: qty rows 28 (6.0~600.0),  data cells 112, holes 0   (행48 "장수/수량": 50장1권/100장1권)
TOTAL 580 = 라이브 580 = import.xlsx 580 (set diff 0)
```

### P4 — 단가형 거동 (원본 colB)
```
엽서북 S1_20P 100x150: 11000 → 9100 → 7300 → 7100 → 6900 ... 2250 → 2230 → 2200  (monotone ↓ True)
떡메   90x90 50장:     3000 → 2300 → 2200 → 2100 → 2000 ...  900 →  900 →  850  (monotone ↓ True)
라이브 spot 일치: S1_20P 100x150 (2→11000, 4→9100, 6→7300) · TTEOKME 90x90 bdl50 (6→3000, 12→2300)
```

### P6 — 가격사슬 단절 라이브 실측
```
wiring (PRF_PCB_FIXED):  COMP_PCB_S1_20P|1|Y · COMP_PCB_S2_20P|2|Y   ← S1_30P/S2_30P 0행 = 단절1 ✅
wiring (PRF_TTEOKME_FIXED): COMP_TTEOKME|1|Y                          ← 배선 정상
binding: PRD_000094|PRF_PCB_FIXED|2026-06-01                          ← PRD_000097 0행 = 단절2 ✅
size:    SIZ_000003=100x150 · SIZ_000124=150x100 · SIZ_000004=135x135 · SIZ_000119=90x90 · SIZ_000266=70x120 (전건 실재)
clr/proc/opt/mat/coat NOT NULL count = 0/0/0/0/0  (전건 NULL 와일드카드 확인)
```

---

## 빌더 주장 대비 검증 결과 표

| 빌더 주장 | 검증 결과 | 판정 |
|-----------|----------|------|
| 데이터셀 580 (468+112) 무손실 | openpyxl 직접 카운트 468+112=580·홀 0·라이브 set diff 0 | ✅ 확인 |
| 두 블록 전건 PRICE_TYPE.01 단가형 | 라이브 5 comp prc_typ_cd 전건 .01 + 원본 monotone ↓ | ✅ 확인 |
| "합가형 세트" 가설 반증 | 구간총액÷환산 거동 데이터 부재·권당 단가형 | ✅ 확인 |
| 단절1: 30P 2개 미배선 | wiring 라이브 S1_20P/S2_20P만(30P 0행) | ✅ 확인(실재) |
| 단절2: PRD_000097 바인딩 0행 | binding 라이브 PRD_000094만 | ✅ 확인(실재) |
| BLOCKED 사이즈 0 (5 siz 실재) | siz 5종 라이브 전건 실재 | ✅ 확인 |
| frm_typ_cd/prd_cd 부존재 컬럼 미포함 | 라이브 formulas 컬럼에 둘 다 없음·시트 미포함 | ✅ 확인(스티커 BLOCKER 재발 0) |
| 교정 INSERT DDL 불요·기존행 무손상 | 8_FIX 4컬럼/2행·9_FIX 4컬럼/1행, 기존 PK 무충돌 | ✅ 확인 |

**뒤집힌 항목: 없음.** 빌더 산출은 라이브 실측 권위와 전건 정합.

---

## MINOR 적출 (GO 유지·보정 권장)

| ID | 내용 | 영향 | 라우팅 |
|----|------|------|--------|
| **M-PCB-1** | `4_component_prices_RU` 시트 컬럼 11개에 라이브 자동/메타 컬럼 4개(`comp_price_id` IDENTITY PK·`note`·`reg_dt`·`upd_dt`) 미포함. 빌더는 RU(대조용·재적재 금지)라 의도적 제외이나, 그릇 자체에 "이 4컬럼은 자동/생략" 명시가 README에 없음. | 실무진이 _FIX(실 INSERT 대상) 적재 시 `reg_dt`(NOT NULL) 누락 위험. 단 8_FIX/9_FIX는 component_prices가 아니라 무관. round-5 reg_dt NOT NULL DEFAULT 함정 교훈 상기 차원. | `dbm-price-import-builder` — README에 "자동 컬럼(comp_price_id/reg_dt) 제외·복붙 비대상" 한 줄 추가 권장. |

> M-PCB-1은 GO를 막지 않는다(RU는 재적재 금지·대조 전용이고, 실 INSERT는 FIX 2시트뿐이며 그 둘은 component_prices를 건드리지 않음). 차단/결정분이 아니라 문서 보강 권장.

---

## 미해소 컨펌 (빌더 §7 승계 — 인간 결정)

| ID | 컨펌 | 검증자 의견 |
|----|------|------------|
| Q-PCB-1 | 8_FIX 30P 배선 disp_seq 3·4·addtn_yn=Y 적정? | 엽서북 20P 패턴(seq1/2·Y) 답습으로 정합. 라이브 addtn_yn 전건 Y 확인 — 일관. |
| Q-PCB-2 | 9_FIX 떡메 바인딩 apply_bgn_ymd=2026-06-01 적정? | 엽서북 바인딩(PRD_000094=2026-06-01)·단가행 apply_ymd(2026-06-01)와 동일 — 추정 아닌 라이브 일관값. 다른 의도면만 컨펌. |

---

## 한 줄 평결

엽서북떡메 그릇 import **GO** — P1~P6 전건 PASS, 빌더 주장 라이브 실측 전건 재현(뒤집힘 0). 580 무손실(set diff 0)·전건 단가형(.01)·가격사슬 단절 2건 실재·교정 시트 정합·사이즈 BLOCKED 0. MINOR 1건(자동컬럼 명시·문서 보강)·컨펌 2건(적용일). 실 INSERT(8_FIX·9_FIX)는 인간 승인 대기.
