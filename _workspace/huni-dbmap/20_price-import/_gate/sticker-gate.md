# 스티커 가격표 import 준비 — 독립 검증 게이트 (P1~P6)

> **재게이트 2026-06-13(2차)**: F1·F2 BLOCKER 보정 후 P1·P5 재검 → **둘 다 PASS, 종합 GO**. 상세는 맨 아래 "재게이트(2차)" 절. 1차 NO-GO 본문은 이력으로 보존.

> **검증자** dbm-validator · **2026-06-13** · round-16 파일럿. 생성자(인라인 오케스트레이터)≠검증자.
> **대상** `_workspace/huni-dbmap/20_price-import/sticker/{sticker-structure.md, sticker-decomposition.md, sticker-import.xlsx, sticker-mapping-flow.md}`
> **권위** 가격표 원본 `docs/huni/..._260527.xlsx` 시트 `스티커`(openpyxl data_only) · 라이브 `t_prc_*` information_schema(읽기전용 SELECT 실측) · `11-CONTEXT.md` Phase11 규칙 · `18_schema-change/impact-diagnosis.md` · round-2 `02_mapping/price211-sticker-namecard/mapping.md`.
> **방법** 라이브 컬럼 실측 + openpyxl 원본↔그릇 행/중복/값 실측. "맞아 보임" 금지.

---

## 종합 평결: **NO-GO** (BLOCKER 2 · MAJOR 2)

716행 그릇의 **값 충실도는 대체로 양호**하나, ① 1_price_formulas 시트가 라이브 `t_prc_price_formulas` 실제 컬럼과 **전혀 일치하지 않고**(P1 BLOCKER), ② 4_component_prices에 **240행/120키의 자연키 중복**(Phase11 "동시매칭=데이터 오류", 라이브 UNIQUE 인덱스 위반)이 있어(P5 BLOCKER) 현 상태로 webadmin 복붙/적재 불가. 근본 원인은 round-2가 이미 **BLOCKED 판정**한 4개 미적재 사이즈(B4·B3·100*148·90*110)를 `siz_cd=NULL`로 강제 포함시킨 회귀(P2).

| 게이트 | 결과 | 핵심 |
|--------|------|------|
| P1 그릇 정합 | **FAIL** | 1_price_formulas 4컬럼(prd_cd·frm_cd·frm_typ_cd·apply_bgn_ymd) 중 frm_cd만 실재. 라이브엔 frm_typ_cd·prd_cd·apply_bgn_ymd 컬럼 **부존재** |
| P2 stale 차단 | **FAIL(부분)** | Phase11 신규 차원(prc_typ_cd·use_dims·proc_cd·opt_cd)은 반영됐으나, round-2 BLOCKED 사이즈 4종을 NULL로 회귀 포함 |
| P3 분해 무손실 | **PASS(조건부)** | B01 648·B02 30·B03 30·B04 6 = 714 값보존 round-trip ✓. 단 타투 기본가 2000(A80) **드롭**(Q-STK-1 미해소·정직 플래그) |
| P4 단가/합가 정당 | **PASS** | B05 "3장마다 4000"(C79)·B06 "54장 1세트"(A86) 합가형 근거 원본 실재. B01~B04 단가형 수량↑단가↓ 거동 확인. 추정 0 |
| P5 동시매칭 0 | **FAIL(BLOCKER)** | 120 자연키 × 2 = **240 중복행**. siz_cd=NULL 4사이즈 쌍 충돌 |
| P6 엔진 시뮬레이션 | **PASS(데이터 한정)** | 매핑된 행 손계산 일치. 단 NULL siz 행은 엔진 동시매칭 오류로 계산불가 |

---

## P1 그릇 정합 — FAIL (BLOCKER)

라이브 information_schema 실측(읽기전용):

**`t_prc_price_formulas`** 실제 컬럼 = `frm_cd, frm_nm, note, use_yn, reg_dt, upd_dt`. (ordinal_position 3 결번 — drop 흔적)
**그릇 1_price_formulas** 컬럼 = `prd_cd, frm_cd, frm_typ_cd, apply_bgn_ymd`.

| 그릇 컬럼 | 라이브 실재? | 판정 |
|-----------|-------------|------|
| `prd_cd` | ❌ 부존재 | 잉여(상품↔공식 바인딩은 `t_prd_product_price_formulas`에 별도) |
| `frm_cd` | ✅ | OK |
| `frm_typ_cd` | ❌ 부존재 | **잉여(치명)** — 공식유형 컬럼은 라이브에 없음 |
| `apply_bgn_ymd` | ❌ 부존재 | 잉여 |
| (누락) `frm_nm` | ✅ NOT NULL | **그릇에 없음** → 적재 시 NOT NULL 위반 |
| (누락) `use_yn` | ✅ NOT NULL | **그릇에 없음** → NOT NULL 위반 |

→ 1_price_formulas는 라이브 4단 그릇 중 **첫 테이블부터 컬럼이 1:1 아님**. 생성자가 `decomposition §0`에서 `price_formulas(prd_cd, frm_cd, frm_typ_cd, apply_bgn_ymd)`로 그린 grain 다이어그램이 **라이브 스키마가 아니라 Phase11 CONTEXT의 개념 모델**을 그대로 옮긴 것. frm_typ_cd(FRM_TYPE)는 Phase11에서 "공식유형 2가지"로 논의됐으나 **라이브에 컬럼으로 적재되지 않음**(price_formulas는 frm_nm/note/use_yn만). 공식유형 구분은 실제로는 `price_components.prc_typ_cd`(단가/합가) + formula_components 구성요소 수로 표현됨.

나머지 3시트는 1:1 양호:
- **2_formula_components** `frm_cd, comp_cd, disp_seq, addtn_yn` = 라이브 ✅(라이브엔 +reg_dt/upd_dt 감사컬럼, 적재 시 DEFAULT — OK).
- **3_price_components** `comp_cd, comp_nm, prc_typ_cd, use_dims` = 라이브 ✅(라이브 +comp_typ_cd·use_yn·note. use_yn NOT NULL → 그릇 누락, 적재 시 보강 필요·MINOR).
- **4_component_prices** 11 DB컬럼 `comp_cd·siz_cd·clr_cd·mat_cd·proc_cd·coat_side_cnt·opt_cd·bdl_qty·min_qty·apply_ymd·unit_price` = 라이브 ✅ **10차원 자연키와 정확히 일치**(+note·comp_price_id·reg_dt/upd_dt는 자동). 컬럼 순서 차이(proc_cd가 라이브선 14번)는 복붙 헤더매칭이라 무해. `[참고]siz_label·mat_label` 보조열은 적재 제외 명시 — OK.

**라우팅 → dbm-load-builder(그릇)**: 1_price_formulas 시트를 라이브 컬럼(`frm_cd·frm_nm·note·use_yn`)으로 재작성. frm_typ_cd/prd_cd/apply_bgn_ymd 제거. 상품바인딩은 별도 `t_prd_product_price_formulas` 시트 신설.

---

## P2 stale 차단 — FAIL(부분)

Phase11 신규(impact-diagnosis I-1·I-2·I-3 기준):
- `prc_typ_cd`(단가/합가) ✅ 3_price_components에 반영(PRICE_TYPE.01).
- `use_dims` jsonb ✅ 반영(`["siz_cd","mat_cd","min_qty"]` 등).
- `proc_cd`·`opt_cd` 차원 ✅ 4_component_prices에 컬럼 존재(현재 NULL·코팅전환 컨펌 대기 — 정당).
- round-2 "8차원 암묵 단가형" 잔재 → 단가/합가 축 명시로 해소 ✅.

**그러나 stale 차단 실패 1건**: round-2 mapping.md는 B4·B3(L162·L168 `[HARD] 신규 siz mint 금지·search-before-mint`)와 100*148·90*110(L217·L229 D-4 미적재·스코프 밖)을 **명시적으로 BLOCKED 판정**했다. round-16 그릇은 이 4 사이즈를 `siz_cd=NULL`로 **그릇에 포함**시켜 BLOCKED 결정을 회귀시킴. 생성자 structure.md §3·decomposition §6 Q-STK-4가 "라이브 미적재"를 참고로만 적고 실제 그릇에선 NULL로 적재 → **정직 분리 실패**(round-2 권위와 충돌).

→ round-2 §6 패턴대로 이 4 사이즈 행(216+24=240행)은 `*_BLOCKED` 분리 또는 siz 선적재 제안 후 적재해야.

---

## P3 분해 무손실 — PASS(조건부)

원본 단가셀 실측(openpyxl) vs 716 그릇행 round-trip:

| 블록 | 원본 셀 | 그릇 행 | 판정 |
|------|---------|---------|------|
| B01 반칼 매트릭스(rows5-40 × colsB-S) | 648 | 648 (COMP_STK_PRINT 매트릭스) | ✅ |
| B02 낱장 완칼(5siz×6qty) | 30 | 30 (완칼) | ✅ |
| B03 투명 완칼(5siz×6qty) | 30 | 30 (COMP_STK_PRINT_CLEAR) | ✅ |
| B04 대형(1×6) | 6 | 6 (대형완칼) | ✅ |
| B05 타투 | 3 (기본가2000·4000·4000) | 1 (min3=4000만) | ⚠️ basic 2000 드롭·dup4000 흡수 |
| B06 스티커팩 | 2 (4000·4000) | 1 (4000) | ✅ dup흡수 정당 |
| **합** | **719** | **716** | Δ3 = 타투basic−1·타투dup−1·팩dup−1 |

부유셀(노트/"~까지") 오포함 **0** 확인(`T3 종이+인쇄+커팅`은 구성요소 명시로 정당 분리, "3장마다 4000"·"판걸이수 상관없음" 노트는 단가행 미포함). unit_price NULL **0**. 값 보존: B01 18열×36행 모두 셀값 = 그릇 unit_price 동일.

⚠️ **타투 기본가 2000(A80) 드롭**: decomposition Q-STK-1로 정직 플래그됨(base 구성요소 별도? 1~2장 최소가?). 합가형 1행(min3=4000)만으로는 "기본가 2000"의 의미를 담지 못함 — **값 손실 1셀**. 컨펌 전까지 무손실 아님(MAJOR가 아닌 정직 flag로 분류, round-2도 D-1/D-2 BLOCKED).

---

## P4 단가/합가 정당 — PASS

원본 단위표기 실재 확인:
- **B05 타투**: C79 = `'3장마다 4000원이라는 의미'` ✅ 실재. C78=`'단가'`. A80 기본가 2000·A81=3장 4000·A82=1000장 4000. → 합가형(.02) 근거 충분(bdl_qty=3).
- **B06 스티커팩**: A86 = `'스티커팩 (54장 1세트) '` ✅ 실재. B88·B89 모두 4000(1~1000 동일=세트총액). → 합가형 근거 충분.
- **B01~B04 단가형(.01)**: 수량↑ → 단가↓ 거동 실측(B01 유포 A5: 1장=6000 → 3장=5900 → 500장=4000 / B02 A4: 1=4000 → 300=3200). 장당단가 구간차등 = 단가형 정당.

추정 0. (단 합가형 환산 단위 Q-STK-3[÷54 장당 vs 세트당]는 미해소 — 정직 컨펌.)

---

## P5 동시매칭 0 — FAIL (BLOCKER)

716행에서 자연키 `(comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, proc_cd, opt_cd, coat_side_cnt, bdl_qty, min_qty)` 중복 실측:

- **중복 키 120개 × 각 2행 = 240 중복행.**
- 원인: B01의 `100*148(8판)`·`90*110(12판)` 두 사이즈가 **둘 다 `siz_cd=NULL`** → `(COMP_STK_PRINT, NULL siz, MAT_xxx, min_qty)`가 두 사이즈에서 동일 키로 충돌. 예:
  - row15 `100*148` min1 mat153 = 6700 / row18 `90*110` min1 mat153 = 6700 → **같은 NULL키, 가격은 같거나(이 경우) 다름.**
- siz_cd NULL 분포: `100*148(8판)`108행·`90*110(12판)`108행·`B4`12행·`B3`12행 = 240행.

라이브 `ux_t_prc_comp_prices_nat_key`(10컬럼 UNIQUE) 실측 존재 → 적재 시 **두 번째 행마다 UNIQUE 위반으로 INSERT 실패**. Phase11 11-CONTEXT.md L28 = "동시 매칭 = 항상 데이터 오류, 흡수 금지". 엔진은 이 행들을 **에러/경고**로 취급.

추가로 `use_dims` 위반: COMP_STK_PRINT의 use_dims=`["siz_cd","mat_cd","min_qty"]`인데 228행이 siz_cd=NULL → **선언한 차원을 채우지 않음**(엔진 차원검증 실패).

**라우팅 → dbm-load-builder(행) + dbm-mapping-designer(siz 매핑)**: 4 미적재 사이즈는 (a) 라이브 siz 선적재 제안(100x148·90x110·B4·B3 신규 siz) 후 실코드 부여하거나 (b) round-2처럼 `*_BLOCKED` 분리. NULL 강제 금지.

---

## P6 엔진 시뮬레이션 — PASS(데이터 한정)

그릇으로 손계산 → 원본 기지값 대조:
- **단가형 B01** (siz=A5/124x186=SIZ_000059, mat=유포 MAT_000153, 수량 100): 그릇 unit_price = 5200(B25=5200 ✅). 엔진 `5200 × 100 = 520,000`. 단가형 거동 일치.
- **단가형 B02** (A4=완칼, 수량 100): 그릇 unit_price = 3600(B50=3600 ✅). `3600×100=360,000`(mapping-flow §2 예시와 일치).
- **합가형 B05 타투** (수량 9): 그릇 `min_qty=3, bdl_qty=3, unit_price=4000, prc_typ_cd=.02` → `4000÷3=1333/장 × 9 = 12,000`. 논리 정합(단 "기본가 2000"은 미반영 — P3 참조).

⚠️ NULL-siz 행(100*148·90*110·B4·B3)은 엔진에서 siz 선택 시 동시매칭 오류로 **계산불가** → 해당 사이즈 상품은 가격조회 실패. P5 해소 전 부분 시뮬레이션만 PASS.

---

## 보정 라우팅 요약

| # | 게이트 | 결함 | 심각도 | 라우팅 |
|---|--------|------|--------|--------|
| F1 | P1 | 1_price_formulas 컬럼이 라이브와 불일치(frm_typ_cd·prd_cd·apply_bgn_ymd 부존재, frm_nm·use_yn 누락) | **BLOCKER** | dbm-load-builder: 그릇을 라이브 컬럼으로 재작성 + 상품바인딩 별도 시트 |
| F2 | P5/P2 | 미적재 4사이즈(100*148·90*110·B4·B3) siz_cd=NULL → 240 중복행·UNIQUE 위반·round-2 BLOCKED 회귀 | **BLOCKER** | dbm-mapping-designer(siz 선적재 제안) + dbm-load-builder(BLOCKED 분리) |
| F3 | P3 | 타투 기본가 2000 드롭(합가 1행으로 표현 불가) | MAJOR(정직flag) | dbm-mapping-designer: Q-STK-1 컨펌 후 base 구성요소 모델 |
| F4 | P1 | 3_price_components use_yn NOT NULL 누락 | MINOR | dbm-load-builder: use_yn='Y' 보강 |

추가 관찰(차단 아님): B01 `A4(2판)→SIZ_000172`, `A3(1판)→SIZ_000174`는 라이브 기존 적재와 동일하나 SIZ_000172=`A4(210x297mm)`라 **임포지션 판수 라벨과 표시사이즈 의미 충돌 소지**. round-2 §2.1 "siz=임포지션 키" 권위 보존이므로 본 게이트는 무판정(라이브 현행 답습)이나, 가격모델 정합 시 designer 재검토 권고.

---

**1차 평결(이력): NO-GO** — 값 충실도는 양호하나 P1·P5 2 BLOCKER로 적재 불가. 보정 후 재게이트 요함.

---

## 재게이트 (2차) — F1·F2 보정 후 P1·P5 재검 · 2026-06-13

> **범위** P1·P5만 재검(생성자 요청대로). P3/P4/P6는 1차 PASS 보존(보정이 그릇 분리·컬럼명만 손대고 값·블록 구조 미변경 — 캐리포워드). F3(타투 base 2000)은 Q-STK-1 컨펌 대기 = 차단 아님(유지).
> **방법** 라이브 information_schema 6테이블 재실측 + openpyxl로 6시트(1·1b·2·3·4·4b) 헤더·main 476행 중복·4b 240행 권위 정합 재측정.

### P1 그릇 정합 — **PASS**

라이브 재실측 vs 보정 그릇 6시트 1:1 대조:

| 그릇 시트 | 라이브 테이블 | 라이브 컬럼(실측) | 그릇 ROW1 | 판정 |
|-----------|--------------|-------------------|-----------|------|
| `1_price_formulas` | `t_prc_price_formulas` | frm_cd, frm_nm, note, use_yn (+reg_dt/upd_dt 자동) | `frm_cd·frm_nm·note·use_yn` | ✅ **1:1** (F1 해소 — frm_typ_cd·prd_cd·apply_bgn_ymd 제거 확인) |
| `1b_product_price_formulas` | `t_prd_product_price_formulas` | prd_cd, frm_cd, apply_bgn_ymd (+note/reg_dt/upd_dt 자동) | `prd_cd·frm_cd·apply_bgn_ymd` | ✅ **1:1** (바인딩 분리 정확) |
| `2_formula_components` | `t_prc_formula_components` | frm_cd, comp_cd, disp_seq, addtn_yn | `frm_cd·comp_cd·disp_seq·addtn_yn` | ✅ |
| `3_price_components` | `t_prc_price_components` | comp_cd, comp_nm, prc_typ_cd, use_dims, **use_yn**(NOT NULL) | `comp_cd·comp_nm·prc_typ_cd·use_dims·use_yn` | ✅ (F4 해소 — use_yn='Y' 보강 확인) |
| `4_component_prices` | `t_prc_component_prices` | 10차원 자연키 11컬럼 | `comp_cd…unit_price` 11 + `[참고]` 2 | ✅ (보조열 적재제외 명시) |
| `4b_component_prices_BLOCKED` | (적재 안 함·차단분리) | — | 4_와 동일 + `blk_reason` | ✅ 분리 시트(적재 대상 아님) |

→ **1_price_formulas(공식정의)와 1b(상품바인딩) 분리가 라이브 권위와 정확히 일치.** frm_typ_cd가 라이브에 없다는 1차 핵심 결함 해소. NOT NULL 컬럼(frm_nm·use_yn) 모두 그릇에 존재. P1 **PASS**.

### P5 동시매칭 0 — **PASS**

independent openpyxl 재측정:

- **main `4_component_prices` = 476행**: NULL siz_cd **0**(1차 228 → 0), 자연키 `(comp,apply,siz,clr,mat,proc,opt,coat,bdl,min)` 중복 **0**(1차 120키/240행 → 0), NULL unit_price **0**. comp_cd 분포 STK_PRINT 456·CLEAR 18·TATTOO 1·PACK 1. → 라이브 `ux_t_prc_comp_prices_nat_key` 위반 0, use_dims(siz_cd) 차원 충족. **F2 해소.**
- **`4b_component_prices_BLOCKED` = 240행**: siz_cd 전부 NULL(차단분리·적재 안 함), siz_label = `100*148(8판)`108·`90*110(12판)`108·`B4`12·`B3`12 = **round-2 BLOCKED 4사이즈와 정확히 일치**(mapping.md L162 B4/B3 search-before-mint·L217·L229 D-4 100x148/90x110 미적재). blk_reason 2종 모두 round-2 권위 인용("round-2 BLOCKED·선적재 대기" / "B4/B3 라이브 부재·round-2 BLOCKED"). unit_price 보존(NULL 0). → **NULL 강제가 아닌 정직 분리** — round-2 §6 패턴 준수.
- **무손실 확인**: main 476 + BLOCKED 240 = **716** = 1차 그릇 총행과 동일. 보정은 분리만 했고 행 드롭 0·값 변경 0. P5 **PASS**.

### F3(타투 base 2000) — 차단 아님 확인

Q-STK-1(타투 "기본가 2000" base 구성요소 모델) 컨펌 대기로 유지. round-2도 D-1/D-2 BLOCKED로 동일 처리 → 정직 분리, 본 게이트 차단 사유 아님. (※ 주의: B05 타투 "기본가 2000"은 4b_BLOCKED와 별개로 main/blocked 어디에도 없음 — Q-STK-1 컨펌 시 base comp 추가 필요. 적재 차단 아니나 미해소 추적 유지.)

### 재게이트 평결

| 게이트 | 1차 | 2차 재검 | 증거 |
|--------|-----|---------|------|
| P1 그릇 정합 | FAIL | **PASS** | 6시트 ↔ 라이브 6테이블 information_schema 1:1·공식/바인딩 분리 정확·NOT NULL 충족 |
| P5 동시매칭 0 | FAIL | **PASS** | main 476행 중복 0·NULL siz 0·4b 240행 round-2 권위 정합·716 무손실 |
| P3/P4/P6 | PASS | 보존 | 값·블록 구조 미변경 캐리포워드 |

---

**최종 한 줄 평결(2차): GO — F1·F2 BLOCKER 보정 검증 완료. P1(6시트 라이브 1:1·공식/바인딩 분리 정확)·P5(main 476행 중복0·4b 240행 round-2 정직분리·716 무손실) 모두 PASS. main 476행 webadmin 복붙·적재 가능, 4b 240행은 siz 선적재 후 별 트랙, 타투 base 2000은 Q-STK-1 컨펌 대기.**
