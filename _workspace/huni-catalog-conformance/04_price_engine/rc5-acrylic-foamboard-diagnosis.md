# RC-5 진단 — 실사 아크릴/폼보드 단가 교정 전 선행 (CONFIRM-2 별색옵션 혼동 배제)

> dbm-price-arbiter · 2026-06-23 · §21. 라이브 읽기전용 SELECT만(파괴적 쓰기 0)·DB 미적재·단가 verbatim·날조 0.
> 권위[HARD]=silsa-l1(260610). 라이브=교정 대상. 생성자(arbiter)≠검증자 — 본 진단은 dbm-load-builder 적재본 설계의 입력이며 dbm-validator 독립 게이트로 비준.
> 대상: PRD_000142 유광아크릴스티커 · PRD_000143 미러아크릴스티커 · PRD_000129 폼보드.

---

## 0. 진단 핵심 질문 (CONFIRM-2)

silsa-l1에 "화이트별색(옵션)" 컬럼(col 26)이 실재한다. 라이브의 어긋난 단가가 사실은 **본체 단가가 아니라 별색옵션(추가요금) 등 다른 정당한 차원에 붙은 값을 오인**한 것이라면, 권위 본체단가로 덮으면 정상 데이터를 파손한다. → 이 가능성을 라이브 가격사슬 실측 + 권위 컬럼 대조로 **배제/확정**한다.

**결론: 3상품 전부 PASS (별색옵션 혼동 아님·본체 단가 단순 오적재 확정·덮어도 안전).** 근거는 §2~§3.

---

## 1. 권위 verbatim 추출 (silsa-l1.csv · 깨끗한 컬럼만)

추출 SQL/스크립트: `silsa-l1.csv` 49컬럼 중 col 11(사이즈)·23(소재)·24(price)·25(price_vat)·26(화이트별색옵션)·27(코팅)·28(price_V)·29~32(가공/추가 옵션가).

### 유광아크릴스티커 (ID 14587)
| 사이즈(필수) | 소재 | price(본체) | price_vat | 화이트별색(옵션) col26 |
|---|---|---|---|---|
| 290 x 90 mm | 화이트 | **12000** | 13200 | (공란) |
| 290 x 190 mm | 블랙 | **18000** | 19800 | (공란) |
| 390 x 290 mm | — | **28000** | 30800 | (공란) |
| 590 x 390 mm | — | **47000** | 51700 | (공란) |

### 미러아크릴스티커 (ID 14588)
| 사이즈(필수) | 소재 | price(본체) | price_vat | 화이트별색(옵션) col26 |
|---|---|---|---|---|
| 290 x 90 mm | 골드 | **15000** | 16500 | (공란) |
| 290 x 190 mm | 실버 | **22000** | 24200 | (공란) |
| 390 x 290 mm | — | **36000** | 39600 | (공란) |
| 590 x 390 mm | — | **62000** | 68200 | (공란) |

### 폼보드 (ID 14575)
| 사이즈(필수) | price(본체) | price_vat | 화이트별색(옵션) col26 |
|---|---|---|---|
| A3 (297 x 420 mm) | **6000** | 6600 | (공란) |
| A2 (420 x 594 mm) | **12000** | 13200 | (공란) |
| A1 (594 x 841 mm) | **20000** | 22000 | (공란) |
| 사용자입력 | — | 52800(vat) | (공란) |

**권위 핵심 사실 ①: 화이트별색(옵션) 컬럼이 3상품 전 행에서 공란.** 권위 측에는 별색 추가요금 단가가 **존재하지 않는다.** (소재 컬럼의 "화이트/블랙/골드/실버"는 사이즈별 행의 소재 라벨이고, 별색옵션 가산값이 아님 — col 26과 별개.)

**권위 핵심 사실 ②: 모든 단가는 본체 price(col 24)에 사이즈축별로 1:1로 붙어 있음.**

---

## 2. 라이브 가격사슬 전수 실측 (읽기전용 SELECT)

### 2.1 상품→공식 바인딩 (1:1 전용·사슬 단절 없음)
```sql
SELECT b.prd_cd, b.frm_cd, f.frm_nm, f.use_yn, b.apply_bgn_ymd
FROM t_prd_product_price_formulas b
JOIN t_prc_price_formulas f ON f.frm_cd = b.frm_cd
WHERE b.prd_cd IN ('PRD_000129','PRD_000142','PRD_000143');
```
| prd_cd | frm_cd | frm_nm | apply_bgn_ymd |
|---|---|---|---|
| PRD_000129 | PRF_POSTER_FOAMBOARD | 폼보드 완제품가(면적/규격 단가) | 2026-06-01 |
| PRD_000142 | PRF_POSTER_ACRYLSTK_GLOSS | 유광아크릴스티커 완제품가 | 2026-06-01 |
| PRD_000143 | PRF_POSTER_ACRYLSTK_MIRROR | 미러아크릴스티커 완제품가 | 2026-06-01 |

### 2.2 공식→구성요소 (각 공식 **단일 comp**·별색 comp 없음)
```sql
SELECT fc.frm_cd, fc.disp_seq, fc.addtn_yn, fc.comp_cd, pc.comp_nm, pc.prc_typ_cd, pc.use_dims, pc.use_yn, pc.del_yn
FROM t_prc_formula_components fc
JOIN t_prc_price_components pc ON pc.comp_cd = fc.comp_cd
WHERE fc.frm_cd IN ('PRF_POSTER_FOAMBOARD','PRF_POSTER_ACRYLSTK_GLOSS','PRF_POSTER_ACRYLSTK_MIRROR');
```
| frm_cd | comp_cd | comp_nm | prc_typ_cd | use_dims |
|---|---|---|---|---|
| PRF_POSTER_ACRYLSTK_GLOSS | COMP_POSTER_ACRYLSTK_GLOSS | 유광아크릴스티커 완제품가 | PRICE_TYPE.01 | `["siz_cd"]` |
| PRF_POSTER_ACRYLSTK_MIRROR | COMP_POSTER_ACRYLSTK_MIRROR | 미러아크릴스티커 완제품가 | PRICE_TYPE.01 | `["siz_cd"]` |
| PRF_POSTER_FOAMBOARD | COMP_POSTER_FOAMBOARD_WHITE | 폼보드(화이트) 완제품가 | PRICE_TYPE.01 | `["siz_cd"]` |

→ **각 공식에 comp가 1개뿐.** 별색옵션을 위한 별도 comp가 formula에 바인딩돼 있지 않다. use_dims=`["siz_cd"]` (사이즈축 단가형).

### 2.3 단가행 전수 (component_prices · 전 행 siz_cd로만 구분)
```sql
SELECT comp_cd, comp_price_id, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty,
       unit_price, dim_vals, opt_cd, proc_cd, siz_width, siz_height, note
FROM t_prc_component_prices
WHERE comp_cd IN ('COMP_POSTER_ACRYLSTK_GLOSS','COMP_POSTER_ACRYLSTK_MIRROR','COMP_POSTER_FOAMBOARD_WHITE')
ORDER BY comp_cd, unit_price;
```
| comp_cd | comp_price_id | siz_cd | siz_nm | clr_cd | opt_cd | proc_cd | dim_vals | unit_price |
|---|---|---|---|---|---|---|---|---|
| COMP_POSTER_ACRYLSTK_GLOSS | 4792 | SIZ_000324 | 290x90 | (NULL) | (NULL) | (NULL) | (NULL) | 9000 |
| COMP_POSTER_ACRYLSTK_GLOSS | 4793 | SIZ_000325 | 290x190 | (NULL) | (NULL) | (NULL) | (NULL) | 14000 |
| COMP_POSTER_ACRYLSTK_GLOSS | 4794 | SIZ_000326 | 390x290 | (NULL) | (NULL) | (NULL) | (NULL) | 32000 |
| COMP_POSTER_ACRYLSTK_GLOSS | 4795 | SIZ_000327 | 590x390 | (NULL) | (NULL) | (NULL) | (NULL) | 37000 |
| COMP_POSTER_ACRYLSTK_MIRROR | 4796 | SIZ_000324 | 290x90 | (NULL) | (NULL) | (NULL) | (NULL) | 11000 |
| COMP_POSTER_ACRYLSTK_MIRROR | 4797 | SIZ_000325 | 290x190 | (NULL) | (NULL) | (NULL) | (NULL) | 18000 |
| COMP_POSTER_ACRYLSTK_MIRROR | 4798 | SIZ_000326 | 390x290 | (NULL) | (NULL) | (NULL) | (NULL) | 29000 |
| COMP_POSTER_ACRYLSTK_MIRROR | 4799 | SIZ_000327 | 590x390 | (NULL) | (NULL) | (NULL) | (NULL) | 50000 |
| COMP_POSTER_FOAMBOARD_WHITE | 4780 | SIZ_000315 | A3 | (NULL) | (NULL) | (NULL) | (NULL) | 7000 |
| COMP_POSTER_FOAMBOARD_WHITE | 4781 | SIZ_000317 | A2 | (NULL) | (NULL) | (NULL) | (NULL) | 12000 |

집계 확인:
```sql
SELECT comp_cd, count(*) total, count(clr_cd) clr_rows, count(opt_cd) opt_rows, count(dim_vals) dim_rows
FROM t_prc_component_prices WHERE comp_cd IN (3개) GROUP BY comp_cd;
```
→ 3 comp 모두 `clr_rows=0, opt_rows=0, dim_rows=0`. **별색/옵션/공정상세 차원이 붙은 단가행 0건.**

### 2.4 CPQ 옵션 레이어 (별색옵션 부재 교차 확인)
```sql
SELECT prd_cd, opt_grp_cd, opt_grp_nm FROM t_prd_product_option_groups
WHERE prd_cd IN ('PRD_000129','PRD_000142','PRD_000143');  -- → 0 rows
```
→ 3상품 모두 **옵션그룹 0개.** 별색옵션이 CPQ 레이어에도 없다.

### 2.5 엔진 코드 경로 (clr_cd 비-가격차원 확인)
`raw/webadmin/webadmin/catalog/pricing.py` L42 `NON_QTY_DIMS = ("siz_cd","plt_siz_cd","print_opt_cd","mat_cd","proc_cd","opt_cd", ...)` — **clr_cd 미포함.** 엔진은 use_dims=`["siz_cd"]`만으로 단가행을 매칭하므로 본체 사이즈 단가만 가산되고, 별색 가산 경로 자체가 코드에 없다.

---

## 3. 별색옵션 혼동 판정 (3중 교차 배제)

| 점검축 | 결과 | 의미 |
|---|---|---|
| 권위 col26 화이트별색(옵션) | 3상품 전행 공란 | 권위에 별색 단가 자체가 없음 |
| 단가행 clr_cd / opt_cd / dim_vals | 전 10행 NULL(0건) | 라이브 단가가 별색차원에 붙어있지 않음 |
| CPQ 옵션그룹 | 0개 | 별색옵션이 CPQ에도 없음 |
| 엔진 NON_QTY_DIMS | clr_cd 미포함 | 별색 가산 경로 구조적 부재 |

**판정 결과:**
| 상품 | 판정 | 근거 |
|---|---|---|
| 유광아크릴(142) | **PASS** (오적재 확정·덮어도 안전) | 단가 4행 전부 siz_cd 본체 단가형·별색차원 0·CPQ 0 |
| 미러아크릴(143) | **PASS** (오적재 확정·덮어도 안전) | 단가 4행 전부 siz_cd 본체 단가형·별색차원 0·CPQ 0 |
| 폼보드(129) | **PASS** (오적재 확정+A1 누락 확정) | 단가 2행 본체 siz_cd 단가형·A1행 자체 부재·별색차원 0·CPQ 0 |

→ 라이브 어긋난 단가는 **(a) 본체 단가 단순 오적재**이며 (b) 별색옵션/다른 차원 정당값 오인이 아니다. CONFIRM-2 해소: **권위 본체단가로 덮어도 정상 데이터 파손 없음.** (진원=상류 v03 입력 엑셀의 본체 단가 오기로 추정 — round-22 load_master 무변환 전파 모델과 일치.)

---

## 4. 교정 매핑 명세 (권위 단가축 ↔ 라이브 단가행 1:1 · UPDATE/INSERT)

> 기초코드 마스터(t_siz 등) 불변. t_prd 상품별 구성요소(component_prices)만. search-before-mint: siz_cd 전부 기존재(A1=SIZ_000294 포함)·신규 채번 0.

### 4.1 유광아크릴(142) — COMP_POSTER_ACRYLSTK_GLOSS · UPDATE 4행
| comp_price_id | siz_cd(siz_nm) | 현재 unit_price | → 권위 verbatim |
|---|---|---|---|
| 4792 | SIZ_000324 (290x90) | 9000 | **12000** |
| 4793 | SIZ_000325 (290x190) | 14000 | **18000** |
| 4794 | SIZ_000326 (390x290) | 32000 | **28000** |
| 4795 | SIZ_000327 (590x390) | 37000 | **47000** |

### 4.2 미러아크릴(143) — COMP_POSTER_ACRYLSTK_MIRROR · UPDATE 4행
| comp_price_id | siz_cd(siz_nm) | 현재 unit_price | → 권위 verbatim |
|---|---|---|---|
| 4796 | SIZ_000324 (290x90) | 11000 | **15000** |
| 4797 | SIZ_000325 (290x190) | 18000 | **22000** |
| 4798 | SIZ_000326 (390x290) | 29000 | **36000** |
| 4799 | SIZ_000327 (590x390) | 50000 | **62000** |

### 4.3 폼보드(129) — COMP_POSTER_FOAMBOARD_WHITE · UPDATE 1행 + INSERT 1행
| 작업 | comp_price_id | siz_cd(siz_nm) | 현재 | → 권위 verbatim |
|---|---|---|---|---|
| UPDATE | 4780 | SIZ_000315 (A3) | 7000 | **6000** |
| (변경없음) | 4781 | SIZ_000317 (A2) | 12000 | 12000 (PASS·권위 일치) |
| **INSERT** | (신규) | SIZ_000294 (A1 594x841) | (행 부재) | **20000** |

INSERT 신규행 컬럼 명세 (기존 폼보드 행과 동형):
- comp_cd=`COMP_POSTER_FOAMBOARD_WHITE`, siz_cd=`SIZ_000294`, unit_price=`20000`
- clr_cd/mat_cd/coat_side_cnt/bdl_qty/min_qty/dim_vals/opt_cd/proc_cd/print_opt_cd/plt_siz_cd/siz_width/siz_height = NULL (기존 4780/4781 행과 동일 패턴)
- apply_ymd = 기존 폼보드 행과 동일값 사용(실측 후 dbm-load-builder가 verbatim 승계), note 예: `폼보드/화이트보드/A1 완제품가[출력+코팅+가공 포함가]`
- comp_price_id = IDENTITY 시퀀스 채번(setval stale 주의 — round-6 교훈 참조)

**A1 siz_cd 선택 근거:** 폼보드 본체 단가행은 세로형 사이즈(A3=297x420, A2=420x594)를 사용 → A1은 594x841(SIZ_000294)이 정합. 841x594(SIZ_000302)는 가로형이라 부적합. (dbm-validator가 product-viewer/위젯 사이즈 옵션으로 교차 확인 권장.)

**합계: UPDATE 9행 + INSERT 1행 = 10행.** 전부 단가 verbatim(권위 price col24, vat 제외 본체단가). 면적 ceiling/별색/옵션 미관여.

---

## 5. 잔여 CONFIRM (실무진/인간 확정)

- **CONFIRM-2: 해소(본 진단).** 별색옵션 혼동 아님·본체 오적재 확정. dbm-validator 독립 재실측으로 비준 후 적재.
- **CONFIRM-5a (apply_ymd 정합):** 폼보드 A1 INSERT 행의 apply_ymd는 기존 폼보드 단가행(4780/4781)과 동일 적용일을 승계할지, 신규 적용일을 둘지 — dbm-load-builder가 기존 행 apply_ymd 실측 후 verbatim 승계 권고. (apply_ymd 분기 시 이중계상 함정 — `dbmap-live-load-transition-260615` 경계.)
- **CONFIRM-5b (폼보드 사용자입력 행):** 권위에 "사용자입력 52800(vat)" 행 존재(=커스텀 면적형). 현 라이브 폼보드 공식은 siz_cd 단가형만. 커스텀 사이즈 입력 경로는 RC-1(면적 프리셋) 트랙과 연동 — 본 RC-5 범위 밖, 별도 CONFIRM(C5 일반현수막 본체 면적행 권위 트랙과 함께).
- **소재 라벨 주의:** 권위 290x90 행 소재="화이트"(유광)/"골드"(미러)지만, 라이브 comp는 소재 무관 단일 본체 comp(note에 "화이트/블랙", "골드/실버" 병기). 별색 분기 아님 — 소재는 가격차원 아님 확인됨(NON_QTY_DIMS에 mat_cd 있으나 단가행 mat_cd=NULL이라 무관). 교정은 단가값만, 소재 차원 신설 불요.

---

## 6. 판정 종합

**RC-5 진단 GO (분석·명세까지).** 142/143/129 전부 별색옵션 혼동 배제(PASS)·본체 단가 오적재 확정. 교정 명세=UPDATE 9 + INSERT 1(폼보드 A1)·단가 verbatim·search-before-mint(신규 siz 0)·기초코드 마스터 불변. 적재 전 dbm-validator 독립 재실측(특히 A1 siz_cd=SIZ_000294 정합·apply_ymd 승계) 후 dbm-load-execution(인간 승인).

> 본 진단의 라이브 실측 SQL은 §2에 근거로 보존. 실 UPDATE/INSERT는 본 문서가 아닌 dbm-load-builder 적재본에서 수행(인간 승인).
