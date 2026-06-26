# C6 — 미바인딩 197 상품 root cause 전수 진단 + (가격포함) 5시트 견적불가 검증

작성 2026-06-26 · A2 축2 클러스터 C6 · §23 셋트상품 하네스. 라이브 읽기전용 SELECT·DB 미적재·검증+결함 보드까지(교정은 인간 승인). 생성≠검증 — 모든 수치는 라이브 쿼리/권위 셀 근거.

권위: 상품마스터 260610 (가격포함) 5시트 추출본 `_workspace/huni-dbmap/24_master-extract-260610/<slug>-l1.csv` + §18 price-engine-design `03_design/`(설계 권위·**DB 미적재**).

---

## 0. 핵심 결론 (한 줄)

미바인딩 197 = **완제품 22 + 반제품 29 + 기성상품 108 + 디자인상품 38**. **root cause의 압도적 진원 = §18이 11시트 전수 설계했으나 라이브 DB에 안 들어감(설계됨 ≠ 적재됨)**. (가격포함) 5시트(포토북·디자인캘린더·문구·굿즈파우치·상품악세사리)는 **권위에 가격이 명문 inline으로 있으나 라이브 t_prc_*/t_prd_*에 단가행·공식·바인딩이 전무 → 견적불가 HIGH**. 단 디자인캘린더·일반캘린더는 §18이 "정찰가 BLOCKED(공식화 불가·추측 단가 INSERT 금지)"로 결판한 **설계상 보류**라 단순 누락과 구분.

---

## 1. 미바인딩 197 전수 분류 (라이브 실측)

### 1.1 총량 게이트 (재현 쿼리)
```sql
SELECT
  (SELECT count(*) FROM t_prd_products WHERE COALESCE(del_yn,'N')='N') total,            -- 275
  (SELECT count(DISTINCT prd_cd) FROM t_prd_product_price_formulas) bound,                -- 78
  (SELECT count(*) FROM t_prd_products p WHERE COALESCE(p.del_yn,'N')='N'
     AND NOT EXISTS(SELECT 1 FROM t_prd_product_price_formulas f WHERE f.prd_cd=p.prd_cd)) unbound; -- 197
```
→ **275 active · 78 bound · 197 unbound** 확정.

### 1.2 prd_typ_cd 분포 — ★결정적 패턴
| prd_typ_cd | 의미 | bound | unbound |
|---|---|---|---|
| PRD_TYPE.01 | 완제품 | 18 | **22** |
| PRD_TYPE.02 | 반제품 | 0 | **29** |
| PRD_TYPE.03 | 기성상품 | 0 | **108** |
| PRD_TYPE.04 | 디자인상품 | 60 | **38** |

- **기성상품(03) 108 = 전부 미바인딩**. §23 정의상 기성상품=제조불필요 → 가격공식이 의도적으로 없을 수 있음(단 inline 가격 보유분은 견적불가).
- **반제품(02) 29 = 전부 미바인딩**. 셋트 구성원(면지·표지·내지)이라 자체 바인딩 불요할 수 있으나 부모 셋트도 미바인딩이면 견적불가.
- **완제품(01) 22 미바인딩 = 견적 대상인데 못 함 → 진짜 결함 후보**.
- 디자인상품(04)은 bound 60 / unbound 38 혼재 — 라이브 적재가 일부만 진행됨.

### 1.3 L1 카테고리 분포 (재귀 upr_cat 추적·합 197)
| L1 | unbound | (참고)bound |
|---|---|---|
| 에코백 | 51 | 0 |
| 라이프 | 38 | 1 |
| 책자 | 29 | 4 |
| 아크릴 | 25 | 1 |
| 문구 | 20 | 1 |
| 포장 | 18 | 4 |
| 인쇄홍보물 | 8 | 8 |
| 캘린더 | 5 | 0 |
| 엽서/카드 | 3 | 15 |
| (포스터/스티커/사인) | 0 | 18/16/10 |

바인딩된 78은 포스터·스티커·엽서/카드·사인(=§18 디지털/실사/스티커 종단이 적재된 영역)에 집중. **미바인딩은 에코백·라이프·책자·아크릴·문구·포장 = §18 설계만 되고 미적재된 영역**과 정확히 일치.

---

## 2. root cause 4분류 (브리프 a/b/c/d)

| code | root cause | 해당 상품군 | 견적가능? |
|---|---|---|---|
| **A** | 권위에 가격 있으나 정찰가 BLOCKED(공식화 불가·§18 결판) | 디자인캘린더·일반캘린더 | NO(설계상 보류) |
| **B** | 라이브에 공식 자체가 없음(설계만 §18·DB 미적재) | 포토북·굿즈파우치GP-2 | NO=HIGH |
| **C** | 단가행 comp 일부 있으나 공식 미설계+comp 고아 | 캘린더(COMP_BIND_CAL_* 42행 미배선) | NO=HIGH |
| **D** | 공식·단가행 完備(또는 PRODUCT_PRICE 경로)인데 바인딩/INSERT만 안 됨 | 문구본체9·떡메·굿즈GP-1·악세사리 | NO=HIGH(쉬운 fix) |
| **E** | 셋트 구성원 자체 바인딩 불요(부모셋트 귀속) | 책자/포토북 반제품 29 | 부모 바인딩 시 가능 |
| **F** | 기성상품(제조불필요)=가격공식 의도적 부재 가능 | 기성상품03 중 무가격분 | N/A(정상) |

---

## 3. (가격포함) 5시트 — 권위 가격 vs 라이브 흔적 대조 (★핵심)

각 시트는 권위에 **명문 inline 가격**이 있다. 라이브 흔적을 전수 대조한 결과:

### 3.1 포토북 (책자·완제품1+반제품6 / B형 HIGH)
- 권위: `포토북(가격포함)` 14행, `가격_기본(24P)`=10000~32000 + `가격_추가(2P)당`=300~1000 (row17 명문 산식 `상품단가+페이지당단가적용`).
- 라이브: **PHOTOBOOK 공식 0건 · COMP_PHOTO* comp 0건 · 바인딩 0 · product_prices 0**. (포토북 키워드 상품 8개 전부 미바인딩 0/8.)
- §18: `engine-design-photobook.md` G-PB-1·G-PB-2 WIRE 결함 확정. **설계 완료·DB 미적재**. → root cause **B**, 견적불가 **HIGH**.

### 3.2 디자인캘린더 (캘린더·디자인상품5 / A형 HIGH·BLOCKED)
- 권위: `디자인캘린더(가격포함)` 10행 inline 정찰가(탁상 10400/9700·미니 6500·엽서 4000·벽걸이 9900·와이드 24000).
- 라이브: PRF_CAL_*/PRF_DCAL_* **부존재**·바인딩 0·product_prices 0(전체 테이블 0행).
- §18: `engine-design-design-calendar.md` — **정찰가 BLOCKED 결판[HARD]**: 유효판수 역산이 비정수(1.313/0.486/1.285/1.574/6.104)·페이지 정수배수 무관 → 단가행 산식으로 재현 불가 → **추측 단가 INSERT 금지**. cartographer+validator+codex 3원 독립 역산 합의. → root cause **A**, 견적불가 **HIGH**이나 **공식화 불가능한 보류**(정찰가 SKU 적재가 유일 경로·인간 승인 필요).

### 3.3 일반캘린더 (캘린더 / C형 HIGH·고아 comp)
- 권위: `캘린더` 20행(별도설정·추가가격만·0차 정찰).
- 라이브: PRF_CAL_* **부존재** · COMP_BIND_CAL_DESK130/220/MINI/WALL **42행 실재하나 어느 공식에도 배선 안 됨(고아)** · 바인딩 0.
  ```sql
  SELECT fc.frm_cd FROM t_prc_formula_components fc WHERE fc.comp_cd LIKE 'COMP_BIND_CAL%'; -- 0행
  ```
- §18: `engine-design-calendar.md` — 원자합산형(디지털 PRF_DGP 직계 동형)·PRF_CAL_* 신설+COMP_BIND_CAL 배선 필요. → root cause **C**(단가행만 적재·공식 미설계), 견적불가 **HIGH**.

### 3.4 문구 (문구·완제품/반제품 / D+E형)
- 권위: `문구(가격포함)` 15행 inline 고정가(2500~15000) + "문구 구간할인".
- 라이브: 본체 9 = product_prices 0행·바인딩 0·DSC 링크 6/9. 떡메(097/098) = PRF_TTEOKME_FIXED **공식·COMP_TTEOKME 112행·단가행 完備·바인딩만 0**.
- §18: `engine-design-stationery.md` — 본체 9 = PRODUCT_PRICE 경로(공식 불요)·고정가 INSERT(verbatim)+DSC 3 보완. 떡메 = **바인딩만**(신규 mint 0). → root cause **D**(바인딩/INSERT만 누락·가장 쉬운 fix), 견적불가 **HIGH**(본체)·**MED**(떡메).

### 3.5 굿즈파우치 (라이프/포장/에코백 / B+D형 HIGH)
- 권위: `굿즈파우치(가격포함)` 303행 inline 가격(틴거울 3000 등)+선택가+가공가.
- 라이브: 공식 0·comp 0·바인딩 0(파우치 0/23·에코백 0/6·틴거울 0/1·볼체인 0/1).
- §18: `engine-design-goods-pouch.md` — GP-1 단일고정가 55=PRODUCT_PRICE 경로(product_prices INSERT)·GP-2 변형고정가 31=formula 바인딩(★GP-2는 product_prices INSERT 금지=PRODUCT_PRICE 선점 가드). → root cause **B/D**, 견적불가 **HIGH**.

### 3.6 상품악세사리 (포장·부자재 / D형 HIGH·6종단 최저)
- 권위: `상품악세사리(가격포함)` 67행 inline 가격(I열 600~32000).
- 라이브: PRODUCT_PRICE·TEMPLATE_PRICE **양 경로 모두 0행**(6종단 통틀어 가격사슬 완성도 최저). 봉투제작 PRF_ENV_MAKING만 bound1.
- §18: `engine-design-accessory.md` — AC-1/AC-2 product_prices INSERT(★G-AC-2 .01 팩단가 강제·"(50장)" 묶음을 합가형 .02로 오적용 시 가격 붕괴)+봉투 addon TEMPLATE_PRICE. → root cause **D**, 견적불가 **HIGH**.

### 3.7 MAP·calendar 인덱스 — 가격 없음
- MAP 시트 = L1 12카테고리 대표 상품 인덱스(가격 컬럼 없음). 견적 대상 아님.

---

## 4. "설계됨 vs 적재됨" 경계 (★§18 직접 인용)

§18 price-engine-design은 **11시트 전수 종단 설계 완료**(CHANGELOG 2026-06-22 "상품마스터 11시트 전수 완주")하나 **전 시트 산출 헤더에 `DB 미적재`(실 적용 인간 승인 후 dbmap 위임) 명시**. 즉:

| 시트 | §18 설계 | 라이브 적재 | C6 판정 |
|---|---|---|---|
| 포토북 | DONE(per2p 선형세트) | NONE(공식0·바인딩0) | 미적재=견적불가 HIGH |
| 디자인캘린더 | DONE(정찰가 BLOCKED 결판) | NONE | 공식화불가·인간승인 필요 |
| 일반캘린더 | DONE(PRF_CAL_* 신설안) | comp 42행만(고아) | 공식 미적재 HIGH |
| 문구 | DONE(본체9 PRODUCT_PRICE) | NONE(product_prices0) | 미적재=견적불가 HIGH |
| 굿즈파우치 | DONE(GP-1/GP-2) | NONE | 미적재=견적불가 HIGH |
| 상품악세사리 | DONE(AC-1/AC-2+addon) | NONE(양경로0) | 미적재=견적불가 HIGH |

**핵심[HARD]: 미바인딩 197의 주 root cause는 "설계 부재"가 아니라 "§18 설계가 라이브에 안 들어감(적재 단계 미수행)".** 디자인캘린더/일반캘린더만 "공식화 자체가 막힌(BLOCKED) 설계상 보류"로 별도.

---

## 5. 미바인딩 완제품(01) 22·반제품(02) 29 명세

- **완제품 22**: 포토북(100)·하드커버책자(072)·하드커버링책자(082)·레더하드커버책자(077)·레더링바인더(088)·레더파우치/백 11종·미니CD앨범(204)·슬로건(208)·블랙사각손거울(187)·미니우치와키링(227)·메쉬토트백(278)·레더숄더/토트백(263/264)·레더라벨제작(280). → 전부 §18 책자·굿즈·악세사리 설계 대상·미적재.
- **반제품 29**: 책자/포토북/링바인더의 면지·표지·내지(073~107)+떡메내지(098)+엽서북 내지/표지(095/096). → 셋트 구성원(root cause E)·부모 셋트 바인딩 시 evaluate_set_price 귀속. §23 set-product 트랙 관할.

---

## 6. 판정 + 라우팅

- **종합 판정: NO-GO(견적불가 광범위)**. 미바인딩 197 중 견적불가 직결 HIGH = (가격포함) 5시트 권위 가격 보유분이 라이브에 전무.
- **fix route**: (가격포함) 5시트 = §18 설계 산출물(`03_design/engine-design-*.md`)을 dbmap 적재 트랙으로 실행(인간 승인). 디자인캘린더/일반캘린더 정찰가는 BLOCKED라 인간 컨펌 후 정찰가 SKU 적재. 반제품 29 = §23 set-product 부모 셋트 바인딩 우선.
- **돈크리티컬 가드 계승**: GP-2/AC product_prices 선점 가드·.01 팩단가 강제(합가형 오적용 시 가격 붕괴) — 적재 시점 박제 필수.

---

## 7. 재현 쿼리 모음

```sql
-- 미바인딩 prd_typ 분포
SELECT prd_typ_cd, count(*) FROM t_prd_products p WHERE COALESCE(del_yn,'N')='N'
  AND NOT EXISTS(SELECT 1 FROM t_prd_product_price_formulas f WHERE f.prd_cd=p.prd_cd) GROUP BY 1;
-- 50 공식 + use_yn
SELECT frm_cd, use_yn FROM t_prc_price_formulas ORDER BY frm_cd;
-- 캘린더 comp 고아 확인(0행=미배선)
SELECT * FROM t_prc_formula_components WHERE comp_cd LIKE 'COMP_BIND_CAL%';
-- 바인딩0 공식
SELECT f.frm_cd, f.use_yn,
  (SELECT count(DISTINCT pf.prd_cd) FROM t_prd_product_price_formulas pf WHERE pf.frm_cd=f.frm_cd) bound
FROM t_prc_price_formulas f WHERE f.frm_cd IN ('PRF_COROTTO_ACRYL','PRF_POSTER_FIXED','PRF_PHOTOCARD_FIXED');
```
