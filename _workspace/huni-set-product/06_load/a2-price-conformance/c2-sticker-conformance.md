# C2 — 스티커·합판 가격테이블 적재정합 전수 검증

작성 2026-06-26 · A2 축2 클러스터 C2 · 라이브 읽기전용 SELECT 실측 · DB 미적재.
권위 = 인쇄상품 가격표 260527(스티커·합판도무송 시트) + 상품마스터 260610(sticker-l1).

## 0. 판정 요약

| 검증 축 | 결과 | 비고 |
|---|---|---|
| ① 단가행 값 정합 (verbatim) | **GO** | STK_PRINT 2,694행·GANGPAN 370행 전수 행수 일치, 샘플 verbatim 100% 일치(불일치 0원) |
| ② 배선 정합 (prc_typ·use_dims) | **GO** | 4공식→4comp 1:1 배선, prc_typ/use_dims 의도 정합 |
| ③ 바인딩 + root cause | **GO** | 스티커·합판 16상품 전수 바인딩(미바인딩 0) |

**C2 종합 = GO (정합).** HIGH 결함 0. MED 2(STK_PACK min_qty 단위 의미·B06 기본가 미적재 — 둘 다 가격값 오류 아님). LOW 1(대표소재 단일화 표기).

---

## 1. C2 공식·구성요소·배선 (라이브 실측)

| 공식 frm_cd | use_yn | comp_cd | comp prc_typ | use_dims | 바인딩수 |
|---|---|---|---|---|---|
| PRF_STK_FIXED | Y | COMP_STK_PRINT | PRICE_TYPE.01 (단가형) | [siz_cd, mat_cd, min_qty] | 13 |
| PRF_STK_PACK | Y | COMP_STK_PACK | PRICE_TYPE.02 (합가형) | [siz_cd, min_qty] | 1 |
| PRF_STK_TATTOO | Y | COMP_STK_TATTOO | PRICE_TYPE.02 (합가형) | [siz_cd, mat_cd, min_qty] | 1 |
| PRF_GANGPAN_FIXED | Y | COMP_GANGPAN_PRINT | PRICE_TYPE.01 (단가형) | [siz_cd, mat_cd, min_qty] | 1 |

- 배선 = 각 공식 1개 comp 1:1 (`t_prc_formula_components` disp_seq=1, addtn_yn=Y). 끊긴 배선·고아 comp·prc_typ 오적재 없음.
- comp_typ_cd 전부 PRC_COMPONENT_TYPE.06 (완제품가). 스티커는 "종이+인쇄+커팅" 통가격(authority B01 T3 헤더 명시) — 원자합산 아닌 완제품가 단일 comp가 도메인 정합.
- prc_typ: 매당 단가표(STK_PRINT/GANGPAN)=.01 단가형(unit×qty), 세트가(PACK 54장·TATTOO 3장)=.02 합가형(세트총액). 의도 정합.

---

## 2. 단가행 행수 정합 (전수 reconcile)

### COMP_STK_PRINT = 2,694행 (집계 전수 reconcile = 정확)

라이브 84 (siz×mat) 조합 × 단가행:
- **B01 반칼 자유형/규격 (36-qty ladder):** 13 siz × {5 or 7} mat × 36 qty = 2,628행
  - 5-mat siz(유포153/비코팅084/미색242/무광155/유광156, 투명·홀로 없음) 9종: 036·043·061·062·063·064·065·170·520 → 9×5×36 = 1,620
  - 7-mat siz(+투명162·홀로163) 4종: 059·060·518·519 → 4×7×36 = 1,008
- **B02/B03/B04 낱장·대형 (6-qty ladder):** 172·174·197·199·514·515 → 66행
- 합계 = 2,628 + 66 = **2,694 = 라이브 실측 2,694 (일치, 잉여·누락 0).**

### COMP_GANGPAN_PRINT = 370행 (전수 reconcile = 정확)
authority 합판도무송 3블록: 원형(11siz)·정사각(12siz)·직사각(14siz) = 37 siz × 2 matclass × 5 qty = 370 = 라이브 370 (일치).

### COMP_STK_PACK / COMP_STK_TATTOO = 각 1행
- STK_PACK: SIZ_068(75x110), min_qty=54, 4,000 = authority B07(스티커팩 75x110, 54장 1세트 4,000) ✓
- STK_TATTOO: SIZ_060(90x190), MAT_167(타투전용지), min_qty=3, 4,000 = authority B05(타투 90x190, 3장마다 4,000) ✓

---

## 3. 단가값 verbatim 대조 (샘플 — 불일치 0)

| comp | 차원 | qty 사다리 | authority | live | 판정 |
|---|---|---|---|---|---|
| STK_PRINT | SIZ_059(A5 4판/124x186) 유포153 | 전 36-qty | 6000,6000,5900,…,4000 | 동일 36값 | **전수 일치** |
| STK_PRINT | SIZ_059/060/518/519 q1 (유포/무광/투명) | q1 | 6000/7000/7000·6700/7700/7700 | 동일 | 일치 |
| STK_PRINT | SIZ_172 A4 유포153(B02) | 6-qty | 4000/3880/3800/3600/3400/3200 | 동일 | 일치 |
| STK_PRINT | SIZ_172 A4 투명162(B03) | 6-qty | 7000/6790/6650/6300/5950/5600 | 동일 | 일치 |
| STK_PRINT | SIZ_197 A2·514 B3·515 B4 (153·162) | 6-qty | B02/B03 전값 | 동일 | 일치 |
| STK_PRINT | SIZ_199 400x600 153(B04 대형) | 6-qty | 16000/15520/15200/14400/13600/12800 | 동일 | 일치 |
| GANGPAN | SIZ_212 정사각10x10 비코팅084 | 5-qty | 20000/30000/40000/50000/60000 | 동일 | 일치 |
| GANGPAN | SIZ_212 정사각10x10 유포153 | 5-qty | 26100/39200/52200/65300/78300 | 동일 | 일치 |

qty 사다리(1,2,3,4,5,6,8,10,15,20,25,30,38,40,50,60,70,75,80,90,100,120,125,140,150,160,175,180,200,250,300,350,400,450,500,100000) = authority B01 36단계와 동일.

---

## 4. 차원 매핑 해석 (정합 근거)

- **소재 클래스 → 대표 mat_cd 전개:** authority 1열이 "유포/비코팅/미색"(3소재 동일가), "무광코팅/유광코팅"(2), "투명/홀로그램"(2)을 묶음. 라이브는 이를 개별 mat_cd로 펼쳐 적재(동일 단가 복제) — STK_PRINT는 펼침(5~7 mat), GANGPAN은 대표 1소재만(084·153) 적재. 둘 다 가격값은 verbatim 동일.
- **자유형 소형 사이즈 = 규격 판수 가격 공유:** 라이브 STK_PRINT의 094x94·80x80·50x70·70x50·50x94·94x50·65x65·A5(170)·A4반칼(520) 등은 authority B01 6열 그리드에 명시 안 되나, 각 상품(반칼원형·반칼정사각·소량자유형 등)이 자기 판수(4판=6000 등) 가격대를 공유 — 마스터 sticker-l1이 상품별 사이즈·소재를 보유(반칼원형=A5/유포 확인). 가격값은 B01 판수 단가(6000/7000)와 동일이므로 잉여(EXTRA)가 아닌 정당한 상품 사이즈 변형.

---

## 5. 바인딩 정합 (전수 — 미바인딩 0)

스티커·합판 16상품 전부 C2 공식에 바인딩(`t_prd_product_price_formulas`):

| frm_cd | 바인딩 상품 |
|---|---|
| PRF_STK_FIXED (13) | 반칼띠지·반칼원형·반칼팬시·반칼정사각·반칼직사각·소량자유형·반칼팬시투명·낱장자유형·대형자유형·반칼자유형·낱장자유형투명·반칼자유형투명·반칼자유형홀로그램 |
| PRF_STK_PACK (1) | 스티커팩(PRD_065) |
| PRF_STK_TATTOO (1) | 타투스티커(PRD_067) |
| PRF_GANGPAN_FIXED (1) | 합판도무송스티커(PRD_066) |

(유광/미러 아크릴스티커 PRD_142/143은 PRF_POSTER_ACRYLSTK_*에 바인딩 — C3 포스터사인 클러스터 소관, C2 범위 외.)

---

## 6. MED/LOW 관찰 (가격값 결함 아님 — 운영 메모)

- **MED-1 STK_PACK min_qty=54 단위 의미:** 합가형 단가표가 min_qty=54 단일행. evaluate_price의 "주문수량 이하 최대 min_qty" 규칙상 주문 단위가 '장(sheet)'이면 1~53팩 미만 주문이 계산불가가 됨. 상품 주문 단위가 '팩(1팩=54장 세트)'이면 정상. 위젯/주문 단위가 '팩'으로 환원되는지 확인 필요(가격값 자체는 4,000 verbatim 정확).
- **MED-2 B06 기본가(2000/3장4000/1000장4000) 미적재:** authority B06 '기본가' 블록(원판 기본료 성격)에 대응하는 라이브 comp 없음. 스티커 완제품가가 이미 통가격이라 기본가가 별도 합산되지 않는 구조면 정상(중복가산 방지). 단 authority가 의도한 최소제작비 floor가 있다면 누락. 도메인 컨펌 필요(STK_FIXED 완제품가에 흡수됐는지).
- **LOW-1 GANGPAN 대표소재 단일화:** authority 합판도무송 소재 클래스 2종(비코팅류·유포류) 각각 대표 1 mat_cd(084·153)만 적재. STK_PRINT(클래스 내 전 소재 펼침)와 적재 패턴 비대칭. 가격 동일이라 결함 아니나 정합 패턴 표준화 메모.

---

## 7. 재현 쿼리 (핵심)

```sql
-- C2 공식·배선·comp
SELECT f.frm_cd,f.use_yn,fc.comp_cd,c.prc_typ_cd,c.use_dims
FROM t_prc_price_formulas f
JOIN t_prc_formula_components fc ON f.frm_cd=fc.frm_cd
JOIN t_prc_price_components c ON fc.comp_cd=c.comp_cd
WHERE f.frm_cd IN ('PRF_STK_FIXED','PRF_STK_PACK','PRF_STK_TATTOO','PRF_GANGPAN_FIXED');

-- STK_PRINT 행수 reconcile (siz×mat 조합별 qty)
SELECT siz_cd,mat_cd,count(*) FROM t_prc_component_prices
WHERE comp_cd='COMP_STK_PRINT' GROUP BY siz_cd,mat_cd;  -- 84조합, 합계 2694

-- verbatim: B01 A5(4판) 유포 36-qty 사다리
SELECT min_qty,unit_price FROM t_prc_component_prices
WHERE comp_cd='COMP_STK_PRINT' AND siz_cd='SIZ_000059' AND mat_cd='MAT_000153' ORDER BY min_qty;

-- 바인딩 전수
SELECT pf.frm_cd,count(*) FROM t_prd_product_price_formulas pf
WHERE pf.frm_cd LIKE 'PRF_STK%' OR pf.frm_cd='PRF_GANGPAN_FIXED' GROUP BY pf.frm_cd;
```
