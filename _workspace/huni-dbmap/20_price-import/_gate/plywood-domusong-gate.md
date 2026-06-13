# 합판도무송스티커 import 준비 — 독립 검증 게이트 (plywood-domusong-gate) — round-16 (B)

> **검증** 2026-06-13 · `dbm-validator`(생성자 아님·빌더 의심·직접 실측). 권위 = 원본 시트 `합판도무송스티커`(openpyxl `data_only=True` 전수 카운트) + 라이브 `t_prc_*`·`t_mat_materials`·`t_siz_sizes` information_schema + 데이터 실측(`.env.local` `RAILWAY_DB_*` 읽기전용·`-d railway`). 빌더 산출 = `20_price-import/plywood-domusong/`(structure·decomposition·import.xlsx·mapping-flow).
>
> **종합 평결: GO (1차 통과).** P1~P6 전건 PASS. 빌더 주장 6대 핵심(370/1110 카운트·소재 6분해·투명데드롱=170·prc_typ .01→.02·siz 비연속·가격사슬 완결) **전부 라이브/원본 직접 실측으로 확정**. 뒤집힌 항목 0. 검증자 자가 오류 1건(축 혼동) 정정·철회.

---

## 0. 한 줄 평결

합판도무송 import 준비 = **밴드 단가표 3블록(원형11·정사각12·직사각14 = siz 37, BLOCKED 0)·6소재 개별분해(370셀→1110행)·합가형(.02) 정정·가격사슬 완결**. 빌더 주장과 독립 실측이 **전건 일치**. 라이브 결함(소재 2종 collapse·prc_typ .01 오적재)을 빌더가 정확히 포착·정정. 실 COMMIT/라이브 정정은 인간 승인.

---

## 1. 게이트 P1~P6 판정표

| 게이트 | 판정 | 근거(직접 실측) |
|--------|------|----------------|
| **P1 그릇=라이브 1:1** | ✅ PASS | import.xlsx 5시트 컬럼 = 라이브 5테이블 information_schema 정확 일치. `1_price_formulas`(frm_cd,frm_nm,note,use_yn)·`1b_product_price_formulas`(prd_cd,frm_cd,apply_bgn_ymd,note)·`2_formula_components`(frm_cd,comp_cd,disp_seq,addtn_yn)·`3_price_components`(+prc_typ_cd,use_dims)·`4_component_prices`(comp_cd…opt_cd). 날조 컬럼 0. |
| **P2 stale 차단** | ✅ PASS | `t_prc_price_formulas`에 `frm_typ_cd` 부재(information_schema count=0). 빌더가 개념설계 11-CONTEXT의 frm_typ_cd 미사용 = 정답. round-14 stale(8→10차원·단가/합가) 반영. |
| **P3 무손실** | ✅ PASS | 원본 openpyxl 전수: **370 데이터셀**(B1=11×2×5=110·B2=12×2×5=120·B3=14×2×5=140). import 4_component_prices = **1110 데이터행**(370셀×3소재/축). distinct siz **37**·mat **6**(각 185행)·min_qty **5**. **전수 1110행 cell-by-cell 대조 mismatch 0**. round-trip 1110÷3=370셀 복원. 부유/노트셀 0. |
| **P4 단가/합가 🔴** | ✅ PASS | 라이브 `COMP_GANGPAN_PRINT.prc_typ_cd=PRICE_TYPE.01`(단가형) **오적재 실측 확인**. 원본 거동 직접 판정: 원형10·비코팅축 20000/30000/40000/50000/60000 → 장당가 20/15/13.3/12.5/12원 **체감 = 셀값은 구간총액** → **합가형(.02) 정답**. .01이면 1000매×20000=2천만원 폭증. 빌더 .02 정정 정확. PRICE_TYPE.01=단가형·.02=합가형 라이브 코드 실재. |
| **P5 동시매칭0 + 소재** | ✅ PASS | import (siz,mat,min_qty) 중복 0(동시매칭 0). 라이브 사용 mat = **2종(MAT_000084·MAT_000153) collapse 실측** → 빌더 6분해(084·155·156·153·**170**·171). **6 mat_cd 전부 라이브 실재**. **투명데드롱=MAT_000170(투명데드롱스티커)·162=투명스티커(별개) 실측 — 메모리 권위 확인**. 형상 37 siz_cd 실재(원형35→SIZ_000422 비연속·직사각 짝수만 224·226…249). |
| **P6 가격사슬** | ✅ PASS | 라이브 직접 확인: `PRF_GANGPAN_FIXED`(공식·use_yn Y) → `t_prd_product_price_formulas` **PRD_000066 바인딩 존재** → `t_prc_formula_components` 배선(disp_seq 1·addtn_yn Y) → `COMP_GANGPAN_PRINT` → 370 단가행. **사슬 완결**(아크릴 단절과 대조). 결함은 데이터 정정(소재 collapse·prc_typ)이지 사슬 단절 아님. |

---

## 2. 빌더 주장 vs 독립 실측 (다른 점 적발 시도 → 전건 확정)

| 빌더 주장 | 독립 실측 결과 | 판정 |
|-----------|---------------|------|
| 370 데이터셀 (110+120+140) | openpyxl 전수: 110+120+140=**370** | ✅ 확정 |
| 6소재 분해 → 1110행 | import 4_component_prices 데이터 **1110행**·mat 6 각 185 | ✅ 확정 |
| 투명데드롱 = MAT_000170 (162 아님) | 라이브 170=투명데드롱스티커·162=투명스티커 별개 | ✅ 확정 |
| prc_typ .01→.02 (라이브 .01 오적재) | 라이브 .01 실측·원본 거동=구간총액 합가형 | ✅ 확정 |
| siz 비연속 (원형35→422·직사각 짝수) | SIZ_000422 실재·직사각 224·226·228…249 짝수만 | ✅ 확정 |
| 가격사슬 완결 (PRD_000066 바인딩·배선·370행) | binding·wiring·370행 라이브 실재 | ✅ 확정 |

**뒤집힌 항목: 0건.** 빌더 주장 전부 라이브/원본 직접 실측으로 확정.

---

## 3. 검증자 자가 보정 (정직)

| 항목 | 내용 | 처리 |
|------|------|------|
| **축 혼동 false MISMATCH** | 표본 대조 중 AC30(직사각90x80 **데드롱축**)을 코팅소재(155)로 조회 → MISMATCH 표시. 실제 AC25=유포/투명데드롱/은데드롱(데드롱축) → 올바른 축(171/170/153)으로 재조회 시 180100 일치. **빌더 결함 아님·검증자 조회 키 오류**. 전수 1110행 재대조 mismatch 0으로 철회. |

---

## 4. 잔존 컨펌(빌더 제기·게이트 무관·인간 결정)

빌더 decomposition §8 미해소 컨펌 — import 준비 GO와 독립(가격표 정리는 정확, 아래는 라이브 적용/도메인 결정 사안):

| ID | 컨펌 | 영향 |
|----|------|------|
| Q-GP-1 | 합가형 구간 사이 수량(1500매) 처리 — 환산식 vs 고정주문 전제 | prc_typ .02 엔진동작 |
| Q-GP-2 | 코팅축 = 자재 variant(현) vs 공정 전환(proc_cd) — 스티커 BATCH-3 연동 | 소재 6 vs 4+proc |
| Q-GP-3 | 라이브 prc_typ .01→.02 정정 시 기존 PRD_000066 가격조회 영향 | 라이브 정정 안전성 |
| Q-GP-4 | 비코팅(084) MAT_TYPE .01(❌)→.11 오적재 — 그릇은 정답코드, 교정은 round-13 | 데이터 정합 |

> 빌더가 자재 variant 해석(코팅=별 mat_cd·같은 단가)을 가격표 거동과 정합으로 채택 — 가격표 컬럼이 비코팅·무광·유광을 같은 단가로 묶으므로 공정 전환 시 코팅 +0원 모순 → 자재 해석이 정합. 단 Q-GP-2는 스티커 BATCH-3 최종 결정 의존(추정 금지·정직 보류).

---

## 5. insertable / BLOCKED / GAP 집계

| 분류 | 행수 | 비고 |
|------|------|------|
| **insertable (그릇 준비 완료)** | 1110 component_prices + 4 메타행(공식1·바인딩1·배선1·구성요소1) | 무손실·동시매칭0·prc_typ 정정 |
| BLOCKED (siz 미적재) | **0** | 37 siz 전부 라이브 등록 |
| GAP (mint 필요) | **0** | mat 6·siz 37 전부 라이브 실재·공식 재사용 신규 0 |

---

## 6. 한 줄 현황

합판도무송 import 준비 **GO(1차 통과)** — P1~P6 전건 PASS·빌더 주장 6대 핵심 전건 확정·뒤집힘 0. 무손실 1110행 cell-by-cell mismatch 0. 라이브 결함(소재 2→6 collapse·prc_typ .01→.02) 정확 포착·정정. 검증자 자가 축 혼동 1건 철회. 실 COMMIT·라이브 정정·Q-GP 컨펌은 인간 승인.
