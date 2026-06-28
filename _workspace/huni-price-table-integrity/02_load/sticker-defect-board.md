# 스티커 시트 — 라이브 적재 대조 결함 보드 (hpti-load-inspector)

> **권위 = 정답격자 1089셀(`01_authority/sticker-authority-grid.csv`) · 라이브 = 감사대상.**
> 라이브 읽기전용 SELECT 실측 **2026-06-27**(Railway `db railway`·psql). DB 미적재(교정=단계2 dbmap 위임).
> 생성측(판정은 integrity-gate가 독립 재실측). 날조 0·모든 결함 재현쿼리 첨부.
> 상품 = PRD_000052~067 16종 · 공식 4(PRF_STK_FIXED/PACK/GANGPAN_FIXED/TATTOO) · comp 4.

---

## 0. 종합 (결함 14건)

| 구분 | 건수 | 상품 |
|------|------|------|
| 🔴 견적불가(no_match·active 상품) | **9** | 052·053·054·055·056·057·062·063·066 |
| 🟠 저청구 | 1 | 052(SIZ_172 collision 4000 vs 5000) |
| 🟡 확인필요(권위 단가 부재·미적재 결함과 구분) | 4 | A6(052/053/054)·100x140(062/063)·타투 기본가(067) |
| 정상(견적 OK) | — | 058·059·060·061·064(전 소재 OK)·065 팩·067 본행 |

★**라이브 골격은 건강**(16/16 바인딩·공식당 comp 1개·use_dims 3축 정합·2694/370/1/1 행수 정합·수량 36티어 verbatim·mat 7종 전개). 결함은 전부 **siz_cd/mat_cd 바인딩 정합**(셀·차원)이지 공식·엔진·prc_typ 오류 아님.

---

## 1. 라이브 골격 확인 (정상 — false-positive 가드)

| 항목 | 권위 기대 | 라이브 실측 | 판정 |
|------|-----------|-------------|------|
| 바인딩 | 16상품 → 4공식 | 16/16 (052~064→FIXED·065→PACK·066→GANGPAN·067→TATTOO) | ✓ |
| 공식당 comp | 1개·addtn_yn=Y | 4공식 각 comp 1·이중합산 구조 부재 | ✓ |
| use_dims | [siz_cd,mat_cd,min_qty](.01) / [siz_cd,min_qty](팩) | 정합 | ✓ |
| COMP_STK_PRINT mat 7종 | 153/084/242/155/156/162/163 | 7종 실측(collapse 해소됨) | ✓ |
| 수량 36티어 | 1,2,3,4,5,6,8,10,...,500,100000 비대칭 | 36티어 verbatim 일치(보간 0) | ✓ |
| COMP_GANGPAN 행수 | 370(37형상×2그룹×5) | 37siz×mat{084,153}×5=370 | ✓ |
| siz_width 사용 | 0(이산 siz_cd) | 0행 | ✓ |
| 팩/타투 .02 | 4000(min54)/4000(min3) | verbatim | ✓ |
| 도수(clr_cd) 가격축 | NULL(도수 무관) | clr_cd 미사용 | ✓ 과적발 없음 |
| 스티커 addon 가격블록 | 0(상품마스터 verbatim) | 라이브 addon 0 | ✓ 과적발 없음 |

---

## 2. 🔴 견적불가 결함 상세 (돈크리티컬 순위)

### STK-D01 — 054 홀로그램 전건 no_match (★1순위·active 상품)
- **권위**: PRD_054는 siz{170/172/196}×mat163(홀로그램). grp3 단가표(투명/홀로 동일).
- **라이브**: mat163 단가행은 siz **{059,060,518,519}** 에만 존재. 054 바인딩 siz(170/172/196)에 mat163 **전건 0행**.
- **돈영향**: 견적불가(no_match) — **현재 active 상품인데 어느 사이즈를 골라도 가격이 안 나옴.**
- **재현**: `SELECT siz_cd FROM t_prc_component_prices WHERE comp_cd='COMP_STK_PRINT' AND mat_cd='MAT_000163';` → 059/060/518/519만.
- **라우팅**: mat163 단가행을 170/172/196에 적재(가격표 verbatim) 또는 바인딩을 059/060로 재정렬. A6(196)은 출처 컨펌(STK-D07).

### STK-D08 — 055 낱장 자재 오바인딩 (★2순위·신규 적발·active)
- **권위**: 낱장 자유형(B02)=유포지+엠보. PRD_055 사이즈 172/174/197.
- **라이브**: PRD_055 **상품자재 = MAT154(유포지)** 인데 COMP_STK_PRINT에 **mat154 단가행 0행**(낱장행은 mat153/084/242). → 전 사이즈 no_match.
- **돈영향**: 견적불가(전건) — active.
- **재현**: `SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_STK_PRINT' AND mat_cd='MAT_000154';` → 0. (`t_prd_product_materials` PRD_055=MAT154.)
- **라우팅**: 055 상품자재 MAT154→MAT153(유포스티커) 재바인딩. 낱장 172/174/197×153 = 4000/8000/16000 실재.

### STK-D09 — 056 낱장 투명 자재 오바인딩 (★3순위·신규·active)
- **권위**: 낱장 투명(B03). PRD_056 사이즈 172/174/197.
- **라이브**: PRD_056 **상품자재 = MAT243(투명커버)** 인데 COMP_STK_PRINT 투명=mat162. **mat243 0행** → 전건 no_match.
- **돈영향**: 견적불가(전건)·active.
- **재현**: `SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_STK_PRINT' AND mat_cd='MAT_000243';` → 0.
- **라우팅**: 056 상품자재 MAT243→MAT162 재바인딩(172/174/197×162=7000/14000/28000 실재). Q-STK-5 해소.

### STK-D10 — 057 대형 자재 오바인딩 (신규·active)
- **권위**: 대형(B04·400x600 SIZ_199)=유포지+엠보.
- **라이브**: PRD_057 상품자재 MAT154인데 SIZ_199엔 **mat153만**(16000)·mat154 0행 → no_match.
- **돈영향**: 견적불가·active.
- **재현**: `SELECT mat_cd,unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_STK_PRINT' AND siz_cd='SIZ_000199' AND min_qty=1;` → mat153=16000.
- **라우팅**: 057 상품자재 MAT154→MAT153 재바인딩.

### STK-D04 — 052 A4 5소재 중 4소재 no_match
- **권위**: 052 반칼 A4 = 5소재(084/153/155/156/242) 전부.
- **라이브**: 052는 A4를 **SIZ_172**(낱장키)에 바인딩. SIZ_172엔 **mat{153,162}만** → 084/155/156/242 선택 시 no_match.
- **돈영향**: 견적불가(A4 5소재 중 4 no_match). STK-D03과 동근(SIZ_172 오바인딩).
- **재현**: `SELECT mat_cd FROM t_prc_component_prices WHERE comp_cd='COMP_STK_PRINT' AND siz_cd='SIZ_000172' GROUP BY mat_cd;` → 153,162.
- **라우팅**: 052 A4 바인딩 SIZ_172→**SIZ_520**(5소재 36단 완비) 교체 — STK-D03·D04 동시 해소.

### STK-D02 — 053 투명 170/196 미적재
- **권위**: 053 투명 siz{170/196}×mat162.
- **라이브**: mat162 단가행이 SIZ_170/196에 **0행**(172=낱장6단만 매칭). → 170/196 no_match.
- **라우팅**: 053을 반칼 siz(059/060/520)로 재바인딩 또는 170/196에 mat162 36단 적재.

### STK-D11/D12 — 062/063 팬시 100x140 미적재
- **권위**: 반칼팬시 사이즈=100x140/124x186/90x190. 100x140=SIZ_058.
- **라이브**: **SIZ_058 = COMP_STK_PRINT 0행**(124x186=059·90x190=060만 OK). → 100x140 선택 시 전건 no_match.
- **재현**: `SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_STK_PRINT' AND siz_cd='SIZ_000058';` → 0.
- **라우팅**: 100x140 가격표 단가 **부재** → 확인필요(Q-STK-7·추측 적재 금지). 출처 컨펌 후 적재 또는 바인딩 제거.

### STK-D13 — 066 합판도무송 6소재 중 4소재 no_match (★자재 collapse·미오퍼 검증)
- **권위**: 합판도무송 grpA(비코팅084/무광155/유광156 동일단가)+grpB(유포153/투명데드롱170/은데드롱171 동일단가) = **6소재**. 37형상×6소재×5수량.
- **라이브**: COMP_GANGPAN_PRINT엔 **mat{084,153}만**(2 대표소재). 그러나 **PRD_066 상품자재는 6종**(084/153/155/156/170/171) 전부 오퍼.
- **★false-positive 가드 재판정**: 동일단가 collapse 자체는 정당하나, **상품이 155/156/170/171을 손님 선택지로 오퍼**하므로 그 4소재 선택 시 each-37형상 no_match. = 실 결함(견적불가).
- **돈영향**: 견적불가(155/156/170/171 선택 시).
- **재현**: `SELECT DISTINCT mat_cd FROM t_prc_component_prices WHERE comp_cd='COMP_GANGPAN_PRINT';` → {084,153} · `t_prd_product_materials PRD_066` → 6종.
- **라우팅**: grpA 단가(084)를 155/156에·grpB 단가(153)를 170/171에 **동일단가 복제 적재**(날조 0·verbatim) 또는 상품 오퍼를 2소재로 축소(실무 컨펌).

---

## 3. 🟠 저청구

### STK-D03 — 052 A4 = 낱장 4000 오청구 (정답 5000·돈크리티컬)
- **권위**: 반칼 A4 = SIZ_520 → qty1 **5000**.
- **라이브**: 052가 A4를 **SIZ_172**(낱장 완칼키·note="낱장(완칼) 자유형 스티커/A4")에 바인딩 → mat153 qty1 = **4000**(낱장가). 052는 반칼인데 낱장 단가로 청구.
- **돈영향**: **저청구 장당 -1000원**(4000 vs 5000). 낱장↔반칼 siz collision.
- **재현**: `SELECT siz_cd,min_qty,unit_price,note FROM t_prc_component_prices WHERE comp_cd='COMP_STK_PRINT' AND siz_cd='SIZ_000172' AND mat_cd='MAT_000153' AND min_qty=1;` → 4000(낱장) vs SIZ_520=5000.
- **라우팅**: 052 A4 바인딩 SIZ_172→SIZ_520(STK-D04와 동반 교정).

---

## 4. 🟡 확인필요 (권위 단가 부재 — 미적재 결함과 구분·추측 적재 금지)

| ID | 상품 | 차원 | 사유 | 컨펌 |
|----|------|------|------|------|
| STK-D05/06/07 | 052/053/054 | SIZ_196 A6 | A6 가격표 단가 권위 부재(라이브 0행·import xlsx 부재) | Q-STK-7: 바인딩 제거 vs 출처 컨펌 |
| STK-D11/12 | 062/063 | SIZ_058 100x140 | 100x140 가격표 단가 부재 | Q-STK-7: 동상 |
| STK-D14 | 067 | 기본가 2000 | 타투 "기본가 2000(A80)" vs "3장당 4000" 관계 미해소 | Q-STK-1: 3장미만 최소가 처리 |

이들은 **라이브 적재 결함이 아니라 권위 자체가 단가를 안 줌** → 임의단가 적재 금지(추측 가드). dbm-price-arbiter 심의 + 인간 컨펌.

---

## 5. 정상 (견적 OK·과적발 가드)

- **058 반칼원형·059 반칼정사각·060 반칼직사각·061 반칼띠지**: siz{170,520}×5소재 전건 OK(공유 B01 단가표 바인딩 정상·형상=비가격축).
- **062/063 팬시**: 124x186(059)·90x190(060) OK — 100x140(058)만 결함.
- **064 소량**: siz{036,043,061,062,063,064,065}×5소재 전건 OK(굿즈 siz 재사용이나 단가행 실재).
- **065 스티커팩·067 타투 본행**: .02 합가형 4000 verbatim.
- **066 합판도무송**: 37형상×2대표소재 전건 OK(6소재 오퍼 중 2만 — STK-D13).

---

## 6. integrity-gate 인계 (독립 재실측 포인트)

1. **STK-D01(054 홀로 전건 no_match·active)** = 최우선. evaluate_price 실호출로 no_match 재현.
2. **STK-D08/09/10(055/056/057 자재 오바인딩)** = 신규 적발(직전 설계 verdict는 mat154를 del_yn=Y·"153 재바인딩 권고"로 기록했으나, 라이브는 mat154 del_yn=**N**·상품이 active 오퍼 → 현재 견적불가 active). ★freshness 드리프트: MAT154 del_yn Y→N. gate가 재확인.
3. **STK-D03(052 저청구)·D04** = SIZ_172↔SIZ_520 collision. evaluate_price(052,A4,mat153,qty1)=4000 재계산 입증.
4. **STK-D13(합판 6소재 미오퍼)** = false-positive 가드 경계 — 상품 오퍼 6 vs comp 2 확인(상품자재 SELECT).
5. **확인필요 5건(A6·100x140·타투기본가)** = 권위 단가 부재 → 결함 아님 구분 유지(추측 적재 금지).

**근거 재현쿼리는 sticker-defect-cells.csv 각 행 repro_sql 컬럼.**
