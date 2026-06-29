# gate-verdict-foil-rev3.md — 박류(foil) 설계 REV3 최종 확인 게이트 (R-FOIL-CDX1 해소 검증)

> hpe-validator(Claude) 독립 재게이트 · 2026-06-30 · 라이브 읽기전용 SELECT 실측 · 생성자 주장 비신뢰(코드/권위 직접 재확인).
> 대상: `03_design/{design-decisions-foil-rev3.md, engine-design-foil.md(REV3), golden-cases-foil.md}`.
> codex 적발: `05_codex/codex-reconcile-foil.md`(R-FOIL-CDX1 동판비 proc_cd 게이트 누락·돈크리티컬).
> 권위[HARD]: 인쇄상품 가격표 박(대형/소형) 시트 절대 · 라이브 코드 = 동작 권위 · DB 미적재.
> 이전 게이트(`gate-verdict-foil.md` E4 CONDITIONAL) carry-forward, REV3 변경분(동판비 게이트)만 재게이트 + 골든 전수 재대조.

---

## 0. 단일 결정점 — R-FOIL-CDX1 해소 여부

**판정: 해소됨(PASS).** designer REV3가 codex 적발 동판비 proc_cd 게이트 누락을 정확히 보정했고, Claude가 라이브 코드 + 권위 CSV + 라이브 스키마로 독립 재확인했다(생성자 주장 무비판 수용 아님).

---

## 1. 확인 초점 5건 — 독립 재실측 결과

### 초점 1 — 동판비 comp use_dims proc_cd 추가됐나 (PASS)

`engine-design-foil.md` REV3 본문 직접 재확인:
- **C-1 COMP_FOIL_SETUP_LARGE** use_dims = `["proc_cd","siz_width","siz_height"]` ✅ (engine-design-foil.md:145)
- **C-2 COMP_FOIL_SETUP_SMALL** use_dims = `["proc_cd"]` ✅ (engine-design-foil.md:159)
- 단가행 proc_cd 충전 설계 명기 ✅ — "동판비는 박색상 무관 동일값(면적만 좌우)이라 박 그룹 전 색상 PROC_000034~049에 같은 값 곱셈 충전" (C-1 단가행 행·147, C-2 단가행·160). proc_cd가 NULL이 아니어야 게이트가 걸린다고 명시.

REV2 → REV3 변경표(design-decisions-foil-rev3.md:69-72)도 C-1=`[siz_w,siz_h]`→`[proc_cd,siz_w,siz_h]`·C-2=`[]`→`[proc_cd]`로 정확 보정.

### 초점 2 — 라이브 코드 재확인: proc_cd 게이트 동형 성립하나 (PASS·코드 직접 추적)

`pricing.py` 직접 재확인(`raw/webadmin/webadmin/catalog/pricing.py`):

- **`_row_matches` (99-111)**: `for d in NON_QTY_DIMS: rv = row.get(d); if rv is None: continue # 와일드카드 — 어떤 선택값이든 통과`. proc_cd ∈ NON_QTY_DIMS(line 30-31 실측: `NON_QTY_DIMS=("siz_cd","plt_siz_cd","print_opt_cd","mat_cd","proc_cd","opt_cd","coat_side_cnt","bdl_qty")`).
- **`match_component` (133-145)**: `cand = [r for r in rows if (apply_ymd ≤ as_of) and _row_matches(r, selections)]`.

**상시 과금 메커니즘(REV2 결함) 코드 추적 — codex 적발 확정:**
- 동판비 단가행이 `proc_cd=NULL, siz_width=X, siz_height=Y`(REV2)일 때, 박 미선택 주문(selections에 proc_cd 없음) → `_row_matches`에서 proc_cd가 NULL이라 `continue`(와일드카드 통과) → siz_width/height는 TIER_DIMS(상한·line 41)라 주문 사이즈가 매칭 → **cand 비지 않음 → 동판비 행 매칭 → PRICE_TYPE.03이라 `component_subtotal`(196-200)이 그 금액(5,000~64,000) 그대로 청구**(수량 무관). = 박 미선택 주문 상시 과금(silent 과청구) **확정**.

**REV3 보정 후 게이트 성립 코드 추적:**
- 동판비 단가행에 `proc_cd=<박색상>` 충전 → 박 미선택 주문에서 `_row_matches`의 `if _norm(selections.get("proc_cd")) != _norm(rv): return False` → no_match → cand 비어 `{"row":None,"error":None,"reason":"no_match"}`(line 144) → 합산 제외 → **동판비 0** ✅. 박가공비(C-3~C-6 use_dims에 proc_cd 보유)와 **동형 게이트 성립** 확정.

∴ codex 신규 결함은 가설이 아니라 라이브 코드로 재확인된 실 돈크리티컬 결함이며, REV3 보정이 그 결함을 닫는다 — **코드 정합 PASS**.

### 초점 3 — 명함박 SETUP 답습 안 하고 proc_cd 충전으로 갔나 (PASS·라이브 SELECT 실측)

라이브 직접 재실측(2026-06-30·`.env.local RAILWAY_DB_*`·읽기전용):
```sql
SELECT comp_cd, comp_typ_cd, prc_typ_cd, use_dims
FROM t_prc_price_components WHERE comp_cd LIKE 'COMP_NAMECARD_FOIL%';
```
| comp_cd | comp_typ | prc_typ | use_dims |
|---|---|---|---|
| COMP_NAMECARD_FOIL_SETUP_S1_STD | .05 | PRICE_TYPE.03 | `["min_qty"]` |
| COMP_NAMECARD_FOIL_SETUP_S2_STD | .05 | PRICE_TYPE.03 | `[]` |

- 명함박 SETUP use_dims에 **proc_cd 없음** 확인 — designer 주장 일치.
- 명함박은 박을 **항상 거는 전용 상품**(PRF_NAMECARD_FOIL이 동판비+박가공비를 박 선택 무관 무조건 합산·박 미선택 주문 자체가 없음)이라 게이트 불요 = 정합.
- designer REV3가 "7상품엔 답습 금지·proc_cd 충전 필수"로 정확히 분기 ✅ (engine-design-foil.md:153·159·276).

**동형 게이트 패턴 라이브 실증 — 접지카드 PRF_DGP_E:**
```sql
SELECT fc.comp_cd, pc.use_dims FROM t_prc_formula_components fc
JOIN t_prc_price_components pc ON pc.comp_cd=fc.comp_cd WHERE fc.frm_cd='PRF_DGP_E';
```
후가공 comp 전건 use_dims에 proc_cd 보유(COMP_COAT_GLOSSY·COMP_FOLD_LEAF_3FOLD 등). 단가행 실측:
```sql
SELECT comp_cd, proc_cd, min_qty, unit_price FROM t_prc_component_prices
WHERE comp_cd='COMP_FOLD_LEAF_3FOLD' ORDER BY min_qty LIMIT 8;
→ COMP_FOLD_LEAF_3FOLD | PROC_000060 | 1~8 | 6000~1100  (proc_cd 실 충전·NULL 아님)
```
박 선택형 상품의 후가공 comp가 proc_cd를 단가행에 **실 충전**해 박 미선택 시 0이 되는 동형이 라이브로 실증됨. 동판비도 이 패턴으로 가야 한다는 designer 설계가 라이브 선례로 뒷받침됨 ✅.

### 초점 4 — R-FOIL-CDX2(표 .02 정정)·R-FOIL-CDX3(proc_grp 표기) 반영 (PASS)

- **R-FOIL-CDX2**: C-3·C-5 본문 표 prc_typ_cd가 **`.02`(합가형)**으로 정정됨 ✅ (engine-design-foil.md:167·181 — "★[REV3·R-FOIL-CDX2 정정]·이전 표 .01은 stale" 명기). §4-가드 결론(.02+min_qty 작업1건 고정)과 표가 일치 → 구현자가 표만 봐도 ×qty 폭발 회피.
- **R-FOIL-CDX3**: use_dims 표기에서 proc_grp를 "박 그룹 식별 메타·코드상 차단 차원 아님" 명기, 실 게이트력=proc_cd·dim_vals로 일원화 ✅ (engine-design-foil.md:70·168·182·264). 코드 정합 확인: `_row_matches`(99-111)는 NON_QTY_DIMS와 dim_vals만 매칭 차단력을 갖고 proc_grp는 코드에 없음(use_dims의 `proc_grp:PROC_XXX`는 라이브 표기상 메타·라이브 PRF_DGP_E도 동일 표기). **proc_grp만 두고 proc_cd 비우면 게이트 안 걸림**이라는 정밀화가 코드와 정합.

### 초점 5 — 골든 8/8 불변·B-FOIL-2 C트랙 분리 유지 (PASS)

골든 8/8 권위 CSV verbatim 전수 재대조(`huni-dbmap/06_extract/price-foil-{large,small}-l1.csv`·아래 §2). **전건 허용오차 0 일치**. REV3 proc_cd 게이트 추가는 use_dims 차원 변경이며 골든은 박을 **선택한** 케이스만 다루므로 proc_cd 매칭 후 동일 행이 선택됨 → 산술값 불변이 정합(dodge-hunt: 설계값으로 골든을 만든 순환 아님 — 골든은 권위 CSV 셀 직접 추출이고 Claude가 독립 추출로 재확인).

B-FOIL-2(면적→등급 환산 엔진 미지원) C트랙 분리 유지 확인:
- `pricing.py:30-41` 실측: NON_QTY_DIMS·TIER_DIMS에 **grade 없음** → 면적값→등급 변환 엔진 미지원 확정.
- `_row_matches`의 dim_vals 매칭(108-110)은 grade를 **정확매칭** 차원으로만 처리(`if _norm(selections.get(k)) != _norm(v): return False`) — 앱이 grade를 selection으로 넘겨야 매칭. 고정사이즈 상품=단일등급 collapse로 현 엔진 작동·가변상품=C트랙 종속 = designer §3-1·5-3 정합. 데이터 설계 결함 아님·엔진 능력 미확정(개발팀 C트랙) ✅.

---

## 2. 골든 8/8 권위 verbatim 재대조 (recompute — 허용오차 0)

전 골든값 = 동판비(B01) + 박가공비(B03 일반/B05 특수) 권위 셀 합산. Claude 독립 CSV 추출 대조:

| 케이스 | 구성 | 권위 셀 (file:line) | 권위값 | designer 골든 | 일치 |
|---|---|---|---|---|---|
| G-F1 | 대형 일반 90×90 1000 | 동판 E6=18000 (large:43) + C등급1000 N15헤더=120000 (large:99) | 138,000 | 138,000 | ✅ |
| G-F2 | 대형 특수 90×90 1000 | 동판 18000 + 특수 C등급1000 N39=150000 (large:326) | 168,000 | 168,000 | ✅ |
| G-F3 | 대형 일반 30×30 10 | 동판 B3=11000 (large:13) + A등급10 L15헤더=55000 (large:97) | 66,000 | 66,000 | ✅ |
| G-F4 | 소형 일반 40×80(E) 1000 | 동판 B3=5000 (small:6) + 일반 E등급1000 M18=64000 (small:92) | 69,000 | 69,000 | ✅ |
| G-F5 | 소형 특수 10×10(A) 200 | 동판 5000 + 특수 A등급200 I33=14300 (small:167) | 19,300 | 19,300 | ✅ |
| G-F6 | 대형 일반 75×85→90×90 ceiling | 동판 18000 + C등급1000 120000 (G-F1 동격자) | 138,000 | 138,000 | ✅ |
| G-F7 | 대형 특수 170×170(E) 1000 | 동판 I10=64000 (large:83) + 특수 E등급1000 P39=250000 (large:328) | 314,000 | 314,000 | ✅ |
| G-F8 | 소형 일반 40×40(D) 500 | 동판 5000 + 일반 D등급500 L13=32500 (small:61) | 37,500 | 37,500 | ✅ |

**8/8 권위 verbatim 일치(허용오차 0).** 날조 0. 등급격자(90×90=C·40×80=E·40×40=D)·일반/특수 시트별 그룹(먹유광=소형 일반/대형 특수)도 권위 verbatim 일치(large:91·small:9·large:326 그룹제목). 자세한 재계산 로그는 `recompute-log.md`(아래) 참조.

---

## 3. E1~E7 게이트 재판정 (REV3 carry-forward + 동판비 게이트 재게이트)

| 게이트 | 판정 | 근거 |
|---|---|---|
| **E1** 공식 추출 충실성 | **PASS** | 권위 박(대형/소형) 셀 8건 + 격자 verbatim 직접 재대조 일치(§2). 날조/누락 0. v03 인용 없음 |
| **E2** 구성요소 분해 정합 | **PASS** | 동판비/박가공비 박 시트 차원경계 안. ★REV3로 동판비 proc_cd 게이트 추가 → silent 과청구(시트 밖 오배선) 차단. 일반/특수 동시합산 가드(proc_cd 그룹 1행만 활성·§2-2) |
| **E3** 경쟁사 흡수 타당성 | **PASS** | comp_nm 후니 표준 용어(박·형압 동판셋업비)·naming 유입 0. 박 자식공정 16종·proc_cd 그릇 재사용(후니 표현력 내) |
| **E4** 엔진 설계 건전성 | **PASS** ★(REV2 CONDITIONAL → REV3 해소) | proc_cd 게이트 코드 정합 재확인(§1 초점2). search-before-mint 충족(신규 5 comp·박 자식공정 재사용 0 mint). 합가형 min_qty=구간하한 NOT NULL 가드. addon 부결(template_prices 단일단가·×qty 폭발). ERR_AMBIGUOUS 회피(proc_cd+면적 1행) |
| **E5** 세트 조합 정합 | **N/A(carry)** | 박은 후가공 comp·본체 공식 직접 합산(세트 아님). 책자(무선/PUR) 표지 박은 세트 트랙(§23)이 별도 — 박 데이터 그릇 자체는 무모순 |
| **E6** 골든 재현 | **PASS** | 8/8 권위 verbatim 허용오차 0(§2). REV3 proc_cd 게이트는 박 선택 케이스 산술 불변 |
| **E7** 생성-검증 독립성 | **PASS** | Claude가 코드(_row_matches 99-111·NON_QTY_DIMS 30)·라이브 SELECT(명함박/PRF_DGP_E use_dims·단가행)·권위 CSV를 직접 재실측. designer/codex 주장 무비판 수용 아님. dodge-hunt: 골든 순환참조 없음(권위 셀 직접 추출 대조) |

**전건 PASS → E4 최종판정 = PASS.**

---

## 4. 박 설계 종합 위상

### 데이터 설계 = GO (인간 승인 후 dbmap 적재)

- **박 가격모델 추출·골든 산술·본체 공식 합산·박가공비 .02+min_qty·동판비 proc_cd 게이트** = 전건 PASS. codex↔validator 9축 수렴(8축 합의 + R-FOIL-CDX1 보정 해소).
- **돈크리티컬 게이트 닫힘**: ① 박 0원(7상품 박 comp 신설로 매출 누락 해소) ② 박 미선택 상시 과금(동판비 proc_cd 게이트로 차단) ③ ×qty 폭발(.02+min_qty·.03 수량무관) — 3건 모두 설계로 해소.
- **적재 시 [HARD] 필수**: C-1 use_dims=`["proc_cd","siz_width","siz_height"]`·C-2=`["proc_cd"]`·**동판비 단가행에 proc_cd 실 충전**(박 그룹 색상별). 박가공비 C-3~C-6 prc_typ=.02·min_qty=구간하한 NOT NULL. 명함박 SETUP use_dims `["min_qty"]` **답습 금지**.

### 잔여 C트랙 (개발팀·데이터 설계 GO와 별개)

| ID | 항목 | 트랙 | 우선도 |
|---|---|---|---|
| Q-FOIL-CODE1 (B-FOIL-2) | 면적→등급(grade) 환산 엔진 미지원(NON_QTY/TIER_DIMS에 grade 없음·pricing.py:30-41). 가변사이즈 상품(접지카드·책자 표지)만 종속·고정사이즈(명함/펄명함)는 collapse로 현 엔진 작동 | 코드트랙 C(개발팀·dbm-price-arbiter 심의) | High |

### 잔여 CONFIRM 큐 (실무진)

| ID | 항목 | 위상 |
|---|---|---|
| Q-FOIL-SIZE1 | 대형/소형 경계(권위 면적임계 없음·범위겹침)·상품별 시트 고정·프리미엄쿠폰(42) 소속 | Medium |
| Q-FOIL-SETUP1 | 소형 동판비 명함박 SETUP 공유 vs 신설(신설 권장·proc_cd 게이트 필요로 강화) | Low |
| Q-FOIL-FACE1 | 권위 면 차원 없음·실무진 컨펌 | Medium |
| Q-FOIL-G6 | 명함박 1000구간 63,000 vs 권위 64,000 1셀 오적재(명함박 라이브 교정 후보·7상품은 권위 64,000 verbatim·답습 금지) | Medium |

---

## 5. 결론

**R-FOIL-CDX1 해소 = PASS. E4 최종판정 = PASS. 박 데이터 설계 = GO**(인간 승인 후 dbmap 적재).

- codex가 validator E4 CONDITIONAL이 놓친 동판비 proc_cd 게이트 누락(돈크리티컬·박 미선택 상시 과금)을 적발했고, designer REV3가 정확히 보정(C-1/C-2 proc_cd 추가·단가행 충전·명함박 답습 금지)했으며, Claude가 라이브 코드(_row_matches NULL 와일드카드 vs proc_cd 충전 게이트)·라이브 SELECT(명함박/PRF_DGP_E)·권위 CSV(골든 8/8)로 독립 재확인해 해소를 확정한다 = **생성≠검증·독립 2차 교차의 가치 입증**.
- R-FOIL-CDX2(표 .02 정정)·R-FOIL-CDX3(proc_grp 표기 일원화) 반영 확인. 골든 8/8 불변·B-FOIL-2 C트랙 분리 유지.
- 적재는 인간 승인 후 dbmap 위임(DB 미적재). B-FOIL-2 면적→등급 환산은 개발팀 C트랙(데이터 GO와 별개).

> 안전: 라이브 읽기전용 SELECT만(DB 쓰기 0)·각 결함 코드/셀 출처 명기(file:line)·권위 엑셀 절대·생성자 주장 비신뢰(코드 직접 재확인)·비밀값 비노출.
