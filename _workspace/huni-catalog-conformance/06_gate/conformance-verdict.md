# conformance-verdict.md — K1~K8 독립 검증 게이트 판정 (디지털인쇄 36상품)

> **Phase 6 — hcc-conformance-gate (생성≠검증)** · 2026-06-22 · `huni-catalog-conformance/06_gate`
> 생성측(인스펙터·codex) 산출을 **신뢰하지 않고 직접 재실측**(라이브 psql 읽기전용 + evaluate_price 재계산 + gstack)해 GO/NO-GO.
> 권위[HARD]=두 엑셀(상품마스터 260610·인쇄상품 가격표 260527). 라이브=교정 대상. 생성자 주장 인용만으로 PASS 금지.
> 라이브 재실측 일시 2026-06-22. 모든 수치는 게이트가 직접 SELECT/계산한 값(verbatim).

---

## 0. 종합 판정 — **NO-GO** (조건부 BLOCKED 1건 포함)

| 게이트 | 판정 | 한 줄 근거(독립 재실측) |
|--------|------|------------------------|
| K1 커버리지 누락 0 | **PASS** | 모집단 36 재실측·468셀(288+144+36) 산술 정합·빈 셀 0 |
| K2 기초데이터 정합 | **PASS(결함 입증)** | 별색 family 링크 0·판형 오매칭·자재 0 표본 전건 재실측 일치 — 결함 실재 확정 |
| K3 CPQ 연결 무결성 | **PASS** | 264 ref 전건 해소(MAT143·PROC96·inline25)·dead_link 0·template 5/5 — 무결성 건강 입증 |
| K4 가격엔진 정합 | **FAIL** | 미바인딩 10·D-A(COAT 미배선)·D-B(STD 이중합산)·유광 0행 전건 라이브 재현 — 돈크리티컬 결함 실재 |
| K5 종단 e2e 추적 | **FAIL** | 명함 골든 재계산: 단면 = (STD_S1+STD_S2)×qty 이중합산·COAT 0원 또는 STD 오매칭 — 견적 미달 |
| K6 라이브 화면 대조 | **BLOCKED** | `.env.local HUNI_ADMIN_PW`로 로그인 실패(인증오류·추측 금지) → 3원 대조 불가. 조건부 |
| K7 codex reconcile 수렴 | **PASS(미해결 0으로 수렴)** | X1~X5·N1~N2·FP 3건 전건 라이브 최종 판정 완료 |
| K8 생성≠검증 독립성 | **PASS** | 전 셀 게이트 자체 SQL·evaluate_price 재계산·스키마 직접 확인(주장 인용 0) |

**단일 FAIL = NO-GO.** K4·K5 두 게이트 FAIL → **종합 NO-GO.** K6은 정직한 자격증명 BLOCKED(CONDITIONAL).
NO-GO의 본질 = 라이브 적재 미완(미바인딩·옵션그룹/별색/제약/추가상품 미적재) + 명함 공식 배선 결함(돈크리티컬).
이는 "검사가 틀렸다"가 아니라 **라이브가 권위 엑셀에 아직 못 미친다**는 의미(라이브=교정 대상, round-13 역전 원칙).

---

## K1 — 커버리지 누락 0 · **PASS**

**재실측:**
```sql
SELECT count(*) FROM t_prd_products
WHERE prd_cd BETWEEN 'PRD_000016' AND 'PRD_000051' AND COALESCE(del_yn,'N')='N';  -- 36
SELECT min(prd_cd),max(prd_cd) FROM ... ;  -- PRD_000016 ~ PRD_000051 (연속)
```
- 모집단 36 = 엑셀 권위 distinct 36 = 라이브 36, 1:1. prd_cd 연속 확인.
- 셀 합계 36×13축 = 468 (basedata 288 + cpq 144 + price 36). 산술 정합.
- 빈 셀: 생성측 cells 3종 + checklist 빈 칸 0(생성측 주장)을 게이트가 모집단·축 수로 교차 검산 → 누락 없음.
- **주의(codex Q4 수용):** 468은 **축 단위** 커버리지. 옵션값 cardinality·MISSING option_group 내부 미생성
  option_item·constraint 상품별 근거는 별도 행으로 펼쳐야 보임. "빈 셀 0"은 PASS이나 "세부 선택지까지 누락 0"은 아님(K7 X3 참조).

## K2 — 기초데이터 정합 · **PASS(결함 입증)**

표본을 라이브 psql로 재실측해 생성측 판정과 대조. **전건 일치 = 결함 실재 확정.**

| 표본 | 생성측 판정 | 게이트 재실측 | 일치 |
|------|------------|--------------|:--:|
| 별색 family PROC_000007~012 마스터 존재 | 존재 | `별색인쇄/화이트/클리어/핑크/금색/은색` 6행 실재 | ✅ |
| 별색 product_processes 링크(36상품) | 0 | `count=0` (디지털 전 스코프) | ✅ |
| 020/021/022/023 인쇄옵션 | MISSING | processes_count 전부 0 | ✅ |
| 019/024/025/039/040 인쇄옵션 | MISMATCH(별색 미적재) | procs=[직각·둥근](024는+유광·무광)·별색 0 | ✅ |
| 030 판형 (권위 330x660) | MISMATCH | 라이브 work 604x154·154x604 | ✅ |
| 049 판형 (권위 330x660) | MISMATCH | 라이브 635x303·644x303·646x303 | ✅ |
| 019 판형 EXTRA | EXTRA | SIZ_000114/115/118(102x152·137x137·150x212) typ=NULL 완성품 혼입 + SIZ_000522(315x467) 정상판형 공존 | ✅ |
| 038 자재 | MISSING | `t_prd_product_materials` 0행 | ✅ (재현쿼리 실행) |

→ basedata 결함 보드 표본 **전건 재실측 일치.** 인쇄옵션 별색 미적재(견적 가산 누락)가 가장 무거운 basedata 결함.

## K3 — CPQ 연결 무결성 · **PASS**

생성측 "264/264·dead_link 0"을 게이트가 polymorphic 해소까지 직접 재실측(주장 인용 아님).

**핵심: ref_dim_cd는 타입 판별자, 실제 차원코드는 ref_key1.** (생성측 보드가 "264 해소"라 했으나 메커니즘 미서술 → 게이트가 직접 규명)
```sql
SELECT ref_dim_cd, split_part(ref_key1,'_',1), count(*) FROM t_prd_product_option_items
WHERE prd_cd BETWEEN 'PRD_000016' AND 'PRD_000051' AND del_yn='N' GROUP BY 1,2;
-- OPT_REF_DIM.03→MAT 143 · OPT_REF_DIM.04→PROC 96 · OPT_REF_DIM.06→inline 1/2 (25)
```
- MAT 143 → t_mat_materials 143/143 해소. PROC 96 → t_proc_processes 96/96 해소. inline 25 = 인쇄면 스칼라값(FK 아님·dangling 불가).
- **264/264 해소·dead_link 0 독립 확인.** ref_dim_cd NULL 0건.
- 옵션그룹 0행 상품 21건(MISSING 21) 재현 — 단 이는 **dead_link이 아니라 not-yet-loaded**(연결할 대상 자체 미적재).
- template→addon: PRD_000016 addon 5건 전부 유효 tmpl_cd 참조(tmpl_exists=1×5), 스코프 내 addon은 016만(5/5). 끊긴 묶음 0.
- **결론:** "이미 적재된 것에 한한 연결 무결성"은 건강(PASS). 광범위 미적재 갭은 K4 가격·후속 적재 이슈로 분리.

## K4 — 가격엔진 정합 · **FAIL** (돈크리티컬)

evaluate_price 계약(`raw/webadmin/webadmin/catalog/pricing.py`)을 직접 읽고 단가행을 재실측해 결함을 재현.

### K4-a 미바인딩 10상품 (MISSING·견적 0원·차단)
```sql
SELECT p.prd_cd FROM t_prd_products p
WHERE p.prd_cd BETWEEN 'PRD_000016' AND 'PRD_000051' AND COALESCE(p.del_yn,'N')='N'
  AND NOT EXISTS (SELECT 1 FROM t_prd_product_price_formulas b WHERE b.prd_cd=p.prd_cd);  -- 10 rows
```
→ 019·030·034·035·036·037·038·039·040·049. 큐레이터 단서 10건과 1:1. pricing.py L329-335: source=NONE → lenient 0원/strict 차단. **PRICE=0=우리측 결함([[huni-widget-red-price-never-zero]] 위반).**

### K4-b D-A 명함 COAT 미배선 (MISMATCH·과소/0원)
```sql
SELECT * FROM t_prc_formula_components WHERE frm_cd='PRF_NAMECARD_FIXED';
-- COMP_NAMECARD_STD_S1 (seq1,addtn_yn=Y) · COMP_NAMECARD_STD_S2 (seq2,addtn_yn=Y) 만 배선
```
- 031·032 둘 다 PRF_NAMECARD_FIXED 바인딩. COAT/PREMIUM variant comp는 **orphan**: COMP_NAMECARD_COAT_S1(MAT_000081=5,500·MAT_000082=5,800) 실재하나 공식에 미배선.
- 코팅명함(032)이 MAT_000081 선택 시 STD comp엔 MAT_000081 행 자체가 없음 → **0원 no-match**(보드의 "STD 3,500 misfire"보다 더 나쁨). MAT_000082 선택 시만 STD 오매칭.

### K4-c D-B STD 이중합산 (MISMATCH·과대)
```sql
SELECT use_dims::text FROM t_prc_price_components WHERE comp_cd='COMP_NAMECARD_STD_S1';
-- ["mat_cd","min_qty"]  (print_opt_cd 부재!)
SELECT comp_cd,print_opt_cd,mat_cd,min_qty,unit_price FROM t_prc_component_prices
WHERE comp_cd IN ('COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2');
-- 전 행 print_opt_cd=NULL
```
- use_dims에 print_opt_cd 없음 + 단가행 print_opt_cd 전부 NULL → 단면 선택해도 S1·S2 둘 다 매칭. pricing.py `_evaluate_formula`(L457-474)는 전 component를 순회 합산(addtn_yn 무관) → **silent 이중합산.**

### K4-d COMP_COAT_GLOSSY 0행 (MISSING·유광 과소·0원 침묵)
```sql
SELECT comp_cd,count(*) FROM t_prc_component_prices WHERE comp_cd IN ('COMP_COAT_GLOSSY','COMP_COAT_MATTE') GROUP BY 1;
-- GLOSSY 0 · MATTE 92
SELECT DISTINCT frm_cd FROM t_prc_formula_components WHERE comp_cd='COMP_COAT_GLOSSY';  -- PRF_DGP_A/D/E
```
→ 유광이 3개 디지털 공식에 배선됐으나 단가행 0 → 유광 선택분 0원(과소). MATTE는 92행 정상.

**K4 FAIL: 위 4결함 전건 라이브 재현.** 돈크리티컬(차단·과소·과대·0원침묵).

## K5 — 종단 e2e 추적 · **FAIL** (상세 = e2e-golden-trace.md)

대표 상품에 옵션→차원→단가행→final_price를 게이트가 직접 재계산.
- **성공 경로(018 스탠다드엽서·PRF_DGP_A):** 출력판형 SIZ_000499·POPT_000002·MAT_000074·무광1면·수량 → 인쇄(plt_siz_cd 키)·용지(70.64)·코팅(매칭) 전부 환원 → 비-0 final. ✅ 원자합산형 종단 성립.
- **끊긴 경로(032 코팅명함·PRF_NAMECARD_FIXED):** 단면 100매 = **(STD_S1+STD_S2)×100 이중합산** (MAT_000082: (3,800+4,800)×100 = **860,000**) vs 정답 단면 COAT 580,000. MAT_000081 선택 시 STD 0원. 견적이 **틀린 값으로 성립**(깨지지 않아 더 위험).
- **미바인딩 10상품:** ④ source=NONE → final 0원/None.

→ 고정가형 명함 + 미바인딩 = 종단 미달. **K5 FAIL.**

## K6 — 라이브 화면 대조 · **BLOCKED (CONDITIONAL)**

- gstack browse로 `https://huni-admin-production.up.railway.app/admin/login/` 접속 성공.
- `.env.local HUNI_ADMIN_ID`(=admin) + `HUNI_ADMIN_PW`(13자) 입력 → POST 200(302 아님) + Django 오류
  "관리자 계정의 사용자 이름과 비밀번호를 입력해주세요"(인증 실패). CLAUDE.md note "[REDACTED]"도 불일치.
- **[HARD] 추측 로그인 금지** → product-viewer 12편집탭 진입 불가 → 엑셀↔DB↔화면 3원 대조 미수행.
- 증거: `captures/K6-login-blocked.png`(비밀번호 필드 마스킹·비밀값 비노출 확인).
- **정직한 자격증명 BLOCKED** = CONDITIONAL(접근 불가 사유 명시). K6은 NO-GO 사유로 가중하지 않되 미해소 추적.
- **인계:** 유효 HUNI_ADMIN_PW 갱신 후 재실행 시 우선 대상 = 별색 미적재 엽서(020~022)·명함 D-A/D-B(031·032)·미바인딩(019·034~040)·판형 혼입(019)·옵션그룹 0(21상품) → product-viewer에서 화면 부재/오표시 확인.

## K7 — codex reconcile 수렴 · **PASS (미해결 0)**

reconcile.md 큐 전건을 게이트가 라이브 최종 판정:

| 큐 | 게이트 라이브 최종 판정 |
|----|------------------------|
| **X1** 037/050/051 판형 | 라이브 plate output_paper_typ_cd **전부 NULL**(037=SIZ_000008·050=4행·051=SIZ_000195). 권위 비판형 needed=N → **050·051 EXTRA 확정**(codex 채택)·**037 CONFIRM 유지**(박명함 비판형 미명시). needed 재판정 큐(remediation R-X1). |
| **X2** 024/025 화이트인쇄 | 024(유광·무광·직각·둥근)·025(직각·둥근) — 양쪽 **별색/화이트 process·option_item 0 재확인**. 화이트인쇄는 진짜 MISSING(권위 요구·라이브 0). 단 보드 라벨 "MISMATCH"는 부정확(값 불일치 아닌 옵션 미적재) → **MISSING으로 정정**(codex "과판정/CONFIRM" 부분 수용: 라벨 정정·결함은 실재). |
| **X3** constraints 34 | `count=0` 재확인(전역 t_prd_product_constraints 스코프 0). **단 "34 전건 needed=Y"는 게이트가 검증 불가**(상품별 별표/블리드/박크기/가변 근거 미전개=생성측 미상세). → **결함 후보는 실재(미적재 0), needed 상품수는 CONFIRM**(codex 채택). remediation R-X3=권위 별표 재추출 후 상품별 needed 확정. |
| **X4** 페이지룰 5 | page_rules 스코프 **0행** 재확인. domain-lens [HARD] "판수=앱런타임 DB미저장"과 충돌 실재 → **CONFIRM으로 강등**(codex 채택). 낱장 엽서 page_rule은 결함 아님(잡음). 접지카드 027만 별도 검토. |
| **X5** D-A/D-B 금액규모 | 전 명함 comp prc_typ_cd=**PRICE_TYPE.01(단가형)**·use_dims [mat_cd,min_qty]·min_qty=100 보유 재확인. 단가형은 unit×qty(pricing.py L177-188) → 100매 묶음가를 장당가로 ×qty 시 ×100 위험 실재 → **부호 유지·금액규모 CONFIRM**(codex 채택, DEF-PE-05 심의 합산). |
| **N1** D-A/D-B 합성 부호 | 게이트 골든 재계산으로 입증: 032/MAT_000082 단면 = 860,000(과대·이중합산) AND COAT 미배선(과소). **상품별 최종 부호는 합성**(codex 가설 → 라이브 재계산으로 확정). |
| **N2** E2E 견적 돈영향 | 별색/커팅/접지 옵션경로 부재 상품(020~023·028·043~046·048)은 basedata(별색 MISSING)+cpq(옵션그룹 MISSING)에 이미 등재. price 보드 단독 집계엔 누락 사실. **cross-board 돈영향=실재**(codex 가설 채택, remediation에 cross-board 집계). |
| FP 후보(포토카드 별색 과판정·constraints 34 근거) | X2·X3에서 라벨 정정·needed CONFIRM으로 흡수. **codex 환각 0 재확인**(인용 prd_cd 전부 실재). |

→ 큐 7건+FP 전건 라이브 최종 판정. **미해결 0 = K7 PASS.** codex 가설은 게이트 재실측 후에만 채택(채택 항목 표기).

## K8 — 생성≠검증 독립성 · **PASS**

- K1~K5·K7 전 판정을 게이트가 **직접 SQL 실행·evaluate_price 알고리즘 직독·use_dims JSON 파싱·골든 수계산**으로 재현.
- 생성측이 서술하지 않은 메커니즘을 게이트가 독자 규명: ① ref_dim_cd=타입판별자/ref_key1=실코드(K3) ② COMP_PRINT는 siz_cd 아닌 plt_siz_cd 키(K5) ③ STD use_dims에 print_opt_cd 부재가 이중합산 진원(K4-c) ④ 032/MAT_000081은 STD에 행 자체 부재로 0원(보드보다 무거움).
- 생성측 스키마 참조 오류 적발: cpq 보드 "constraint_json 캐시" → `t_prd_products`에 해당 컬럼 **부재**(constraints count=0 결론은 유효하나 캐시 근거는 무효). 보드 옵션 컬럼명(opt_item_nm) 라이브 스키마 불일치.
- **생성자 주장 인용만으로 PASS한 게이트 0건.** 독립성 확보.

---

## 부록 — 라이브 스키마 정정(게이트 발견·후속 반영 필요)

| 위치 | 생성측 표기 | 라이브 실제 | 영향 |
|------|------------|-------------|------|
| cpq 보드 §1.3 | `t_prd_products.constraint_json` 캐시 비어있음 | 컬럼 부재 | 결론(constraints 0) 유효·근거 문구 수정 |
| basedata 재현쿼리 | `bdl_unit_typ_cd` | 컬럼명 상이(`bdl_qty`만) | 재현 시 컬럼 확인 |
| option_items | `opt_item_nm` | 컬럼 부재(`dtl_opt`·`ref_key1`) | 재현 쿼리 보정 |
| price 보드 D-B | print_opt_cd 차원 충전으로 해소 | use_dims에 print_opt_cd 등재 **선행 필수**(현재 부재) | 교정 명세 R-K4c 반영 |

---

# 배치1 — 포토북(PRD_000100~107)·캘린더(PRD_000108~112) K1~K8 독립 검증

> **Phase 6 배치1 — hcc-conformance-gate (생성≠검증)** · 2026-06-22 · 13상품·169셀(13×13축).
> 라이브 psql 읽기전용 직접 SELECT(2026-06-22)·gstack 로그인 시도·생성자 주장 비신뢰. 모든 수치 verbatim.

## B1.0 종합 판정 — **NO-GO** (조건부 BLOCKED 1건·구조 CONFIRM 동반)

| 게이트 | 판정 | 한 줄 근거(게이트 직접 재실측) |
|--------|------|------------------------------|
| K1 커버리지 누락 0 | **PASS** | checklist 169행(13×13) 빈 셀 0(needed/target/axis 전건 채움)·needed Y93/N76·python CSV 정합 |
| K2 기초데이터 정합 | **PASS(결함 입증)** | 112판형 304x629(SIZ_000292 작업판)·캘린더 삼각대/링 USAGE.07 자재오염·page_rule 108~112=0·101~107 역할축 전건 0행 — 결함 실재 확정 |
| K3 CPQ 연결 무결성 | **PASS(vacuous)** | 13상품 전 grp/opt/item/constr/addon/tmpl=0·option_item 0행 → 해소 대상 0 = DEAD_LINK 0(연결 이전·"건강" 아님) |
| K4 가격엔진 정합 | **FAIL** | 6 prd(100·108~112) bind_cnt=0·prodprice=0·PRF_PHOTOBOOK*/PRF_CAL* 공식 라이브 0행 — 견적 0원 차단 6건 실재(돈크리티컬) |
| K5 종단 e2e 추적 | **BLOCKED(구조)** | 13/13 prd 공식 바인딩 0 → 옵션→차원→단가행→final_price 재현 불가(재현할 final_price 부재). 디지털 K5 FAIL과 달리 "틀린 값"이 아닌 "값 자체 부재" |
| K6 라이브 화면 대조 | **BLOCKED** | `.env.local HUNI_ADMIN_PW` 로그인 재시도 실패(LOGIN_ERROR·여전히 /login·추측 금지) → 3원 대조·B-N4 반제품 고객노출 확인 불가. 조건부 |
| K7 codex reconcile 수렴 | **PASS(미해결 0)** | 4쟁점 전건 합의·불일치 0·B-N2(111/112 링 공정) 라이브로 정정 후 기각·B-N1/B-N4 게이트 판정 완료 |
| K8 생성≠검증 독립성 | **PASS** | 전 셀 게이트 자체 psql·information_schema 직접 확인(주장 인용 0)·codex 가설 라이브 재실측 후 채택/기각 |

**단일 FAIL = NO-GO.** K4 FAIL → **종합 NO-GO.** K5는 구조적 BLOCKED(공식 부재로 e2e 불성립), K6은 정직한
자격증명 BLOCKED(CONDITIONAL). NO-GO의 본질 = 포토북·캘린더 6 prd **공식 전무**(디지털 미바인딩보다 깊은
full WIRE 미충족) + CPQ 옵션 레이어 전(全) 미적재 + 세트 역할축 비대칭(superset). "검사 오류"가 아니라
**라이브가 권위 엑셀에 아직 못 미침**(round-13 역전·라이브=교정 대상).

## B1.1 K1 — 커버리지 누락 0 · **PASS**
- python csv 파싱(임베드 콤마 안전): batch1 169행 = 13상품 × 13축. 빈 needed/target_table/axis = **0**.
- needed Y=93·N=76. 13 distinct 축. `constraint_json` target 13행(전부 제약규칙 축) → 디지털 36 + 배치1 13 = **49행**(reconcile B-A2 정합).
- cells.csv 127셀 emit(basedata 69·cpq 52·price 6) + N/A-closed = checklist needed 정합(반제품은 역할 외 축 N/A 축소).

## B1.2 K2 — 기초데이터 정합 · **PASS(결함 입증)** (게이트 직접 SELECT)
| 표본 | 인스펙터 주장 | 게이트 재실측 | 일치 |
|------|--------------|--------------|:--:|
| 112 판형 | 304x629 작업판(SIZ_000292)·정답 330x660(SIZ_000475) | `SIZ_000292·OUTPUT_PAPER_TYPE.03·work 304x629`·`SIZ_000475=330x660 실재` | ✅ |
| 캘린더 자재오염 | 108/109/111/112 삼각대·링 USAGE.07 혼입 | 108=삼각대(그레이)MAT_000252+링블랙253·109=삼각대(블랙)254+링253·111=링253·112=링253 전부 USAGE.07 | ✅ |
| 캘린더 공정 | 108/109 링/삼각대 공정 미등록 | 108=수축포장만·109=수축포장만(보드 "109=0행"은 부정확하나 **링 공정 누락은 일치**) | ✅(부분정정) |
| page_rule | 108~112 미적재(0행)·100=24/150/2·101=0 | 108~112 전건 0행·100=24/150/2·101=0행 | ✅ |
| 반제품 역할축 | 101~107 도수/판형/공정/자재 전건 0(본체 superset) | 101~107 po/plate/proc/mat 전부 0·본체 100=2/11/2/7 | ✅ |
- **게이트 정정(인스펙터 미세 오류)**: 보드 "109 processes=0행"은 실측 **수축포장 1행**. 결함 본질(링/삼각대 공정 누락)은 불변 → 판정 영향 없음. basedata-cells 109 공정 evidence 문구만 보정 권고.
- **110 타공 EXTRA(D-CAL-PROC-EXTRA-110)**: 110=PROC_000079(타공) 실재·권위 캘린더가공 빈칸. 111도 타공 보유 → 엽서캘/벽걸이 고리타공 도메인 정당 가능성 높음. **CONFIRM 유지**(결함 단정 안 함).

## B1.3 K3 — CPQ 연결 무결성 · **PASS(vacuous clean)**
- 13상품 전 prd: grp/opt/item/constr/addon/tmpl 모두 0행(직접 SELECT). option_items batch1 전체 0행.
- 해소할 polymorphic ref 0건 → DEAD_LINK 0이나 **"연결 이전"**(codex B-N3 정합·"건강 아님"). 적재 후 fn_chk_opt_item_ref 재검증 필수(게이트 노트).

## B1.4 K4 — 가격엔진 정합 · **FAIL** (돈크리티컬 차단 6건)
- 6 prd(100·108·109·110·111·112) `bind_cnt=0·prodprice_cnt=0`(직접 SELECT)·`PRF_PHOTOBOOK*/PRF_CAL*` 공식 **라이브 0행**.
- evaluate_price source=NONE → lenient 0원·strict None → **견적 0원 차단**([[huni-widget-red-price-never-zero]] 위반). 6건 전건 라이브 재현.
- **디지털과 차이(깊이↑)**: 디지털 10건은 comp orphan 실재(공식 신설+바인딩)였으나, 배치1은 **공식 자체 0행** → 공식 신설 + (일부)comp 신설 + 단가행 충전 + 바인딩 full WIRE. 단 재사용 comp 단가행은 충전 확인(비결함):
  COMP_BIND_CAL_DESK130/220/MINI=각 6·WALL=24·BIND_PUR=8·COAT_MATTE=92·PAPER=56·PRINT_DIGITAL_S1=212(직접 SELECT) → mint 범위 축소.

## B1.5 K5 — 종단 e2e 추적 · **BLOCKED(구조적)**
- 13/13 prd 공식 바인딩 0(직접 count) → `옵션→차원→단가행→final_price`에서 **final_price 산출 경로 자체 부재**.
- 디지털 K5(FAIL=틀린 값으로 성립)와 본질 다름: 배치1은 **재현할 살아있는 가격이 없음**(차단). 골든은 "설계 명세상 기대값"만 추적 가능(e2e-golden-trace.md 배치1 섹션). 라이브 정합 e2e는 공식 적재 후 재실행.

## B1.6 K6 — 라이브 화면 대조 · **BLOCKED (CONDITIONAL)**
- gstack browse로 `/admin/login/` 접속(200)·`HUNI_ADMIN_ID`+`HUNI_ADMIN_PW` 입력 후 클릭 → **여전히 /login·LOGIN_ERROR**(인증 실패 재확인). HUNI_ADMIN_PW stale(memory `catalog-conformance-remediation-scope` 일치).
- **[HARD] 추측 로그인 금지** → product-viewer 12편집탭·B-N4(101~107 반제품 고객노출) 3원 대조 미수행.
- 증거: `captures/B1-K6-login-blocked.png`(pw input type=password 마스킹 확인·비밀값 비노출).
- **정직한 자격증명 BLOCKED = CONDITIONAL**(NO-GO 가중 안 함·미해소 추적). 인계: 유효 PW 갱신 후 우선 = 112판형 화면·캘린더 자재슬롯(삼각대/링 표시)·반제품 101~107 고객노출 여부.

## B1.7 K7 — codex reconcile 수렴 · **PASS(미해결 0)**
- 4쟁점(B-A1~B-A4d) 전건 합의·불일치 0. 게이트 라이브 최종 판정:
  - **B-N2(111/112 링 공정 누락 후보)** → 라이브 재실측 **111=타공+트윈링제본·112=트윈링제본** → codex 가설 **기각**(링 공정 누락은 108/109 국한). codex의 검증자-제공-사실(S4) 한계發 부분오판·환각 아님.
  - **B-N1(역할 스코프 전역부착)** → 본체 100 공정 무광+PUR 혼재 확정 → Q-PB-SUPERSET 합류(구조 의도 CONFIRM·교정 아닌 판정 선행).
  - **B-N4(반제품 고객노출 dead-catalog)** → 101~107 use_yn=Y/del_yn=N(논리 active)이나 **고객노출 여부=K6 BLOCKED로 미확인** → 유효 PW 후 product-viewer 확인 큐.
- codex 환각 0건. 가설은 라이브 검증 전 사실 병합 안 함.

## B1.8 K8 — 생성≠검증 독립성 · **PASS**
- 전 게이트 셀을 게이트 자체 psql/information_schema로 직접 재실측(인스펙터·codex 주장 인용 0). GATE-1(constraint_json 부재)·6 prd 미바인딩·공식 0행·자재오염·판형·역할축·page_rule·CPQ 0행·comp 단가행 전부 직접 SELECT verbatim.

## B1.9 횡단 정정 — GATE-1 (constraint_json 컬럼 부재) · 처리 완료
- 게이트 직접 확인: `information_schema` `t_prd_products`=**24컬럼·constraint 없음**. 제약 권위=`t_prd_product_constraints.logic`(실재).
- checklist `target_table`의 `t_prd_products.constraint_json` 표기는 **스키마 오류**(데이터 결함 아님). 디지털 36 + 배치1 13 = **49행** 횡단 정정 대상.
- **처리**: 49행 target_table을 `t_prd_product_constraints.logic`(또는 `(prd_cd,rule_cd) 신규행`)으로 정정 권고 → remediation-spec R-GATE1(인간 승인·dbm-correctness-audit). 본 게이트는 명세까지(checklist 직접 수정 보류=권위 산출물·인간 확인).

---

# 배치2 — 책자10·문구9·악세15 (34상품) K1~K8 독립 검증

> **Phase 6 배치2 — hcc-conformance-gate (생성≠검증)** · 2026-06-23 · 34상품·442셀(34×13축).
> 게이트가 라이브 psql + pricing.py 직접 재실측(인스펙터/codex 주장 비신뢰). 라이브 읽기전용 SELECT·DB 미적재.
> 대상 prd: 책자 068·069·070·071·072·077·082·088·094·097 / 문구 172~179·181 / 악세 001~015.

## B2.K — K1~K8 판정표

| 게이트 | 판정 | 게이트 직접 재실측 증거 |
|--------|------|-------------------------|
| **K1 커버리지 누락 0** | ✅ **PASS** | 3 cells.csv 배치2 부분 = basedata 272(8축)+cpq 136(4축)+price 34(1축) = **442 = 34×13**. 빈 verdict 0(awk 검사). checklist 배치2 442행·축별 34 균일. |
| **K2 기초데이터 정합** | ✅ **PASS** | 표본 재실측 일치: 070 PUR책자 materials=0(형제 068=26·069=13·071=49·072=4 대비 결함 확정·돈크리)·008 천정고리 use_yn=N(EXCLUDED 정당)·악세 006~015 sizes=0·materials N(USAGE.07 변형). 인스펙터 판정과 100% 일치. |
| **K3 CPQ 연결 무결성** | ✅ **PASS** | DEAD_LINK 5건 직접 재현: 068×1(SIZ_000170 del=Y)·069×1(170)·071×3(170/253/255 전부 del=Y)·SIZ_000172(del=N)=정상공존. 094=3 size item·dead 0. 고아 참조 정확히 5건. |
| **K4 가격엔진 정합** | ❌ **FAIL(NO-GO 사유)** | ① 094 PRF_PCB_FIXED=S1_20P+S2_20P 둘 다 print_opt_cd=NULL·use_dims=[siz_cd,min_qty]→silent 이중합산 라이브+코드 실증. ② pricing.py del_yn **0회**(L239·L450 필터 부재)→COMP_BIND_JUNGCHEOL(del=Y)이 PRF_BIND_SUM 유일 배선=068~071 합산 misfire 코드 실증. ③ MISSING 28 bind=0·pp=0 견적차단. |
| **K5 종단 e2e 추적** | ❌ **FAIL(돈크리 입증)** | 094 evaluate_price 합산로직 독립 재계산(오차0): SIZ_000003@min2 단면 정답 11,000 vs 엔진 22,500=**+11,500/장**·양면 정답 11,500 vs 22,500=**+11,000/장**. 양방향 과대청구 silent. (MISSING 28은 BLOCKED=재현할 값 없음) |
| **K6 라이브 화면 대조** | ⛔ **BLOCKED(자격증명)** | `.env.local HUNI_ADMIN_PW` stale — gstack 로그인 거부("사용자 이름/비밀번호 오류"). 배치1과 동일. 추측 로그인 금지(HARD)→정직 BLOCKED. 동일 자격증명 BLOCKED 증거=captures/B1-K6-login-blocked.png(배치2도 같은 stale 키·로그인 거부 화면 동일). |
| **K7 codex reconcile 수렴** | △ **CONDITIONAL** | 합의 4/5 고신뢰(094·DEAD_LINK·JUNGCHEOL·Q-PA-ADDON 전부 라이브/코드 실증)·codex 환각 0·신규B(양면 +11,000) 라이브 채택·신규A(del_yn 공통결함) 1건 노출로 범위축소. **미해결 1=쟁점4 축귀속**(K6 의존). |
| **K8 생성≠검증 독립성** | ✅ **PASS** | 전 핵심 결함 게이트 자체 SQL/코드/재계산으로 재현(인용 아님): 094 wiring·unit_price·del_yn grep·DEAD_LINK join·evaluate_price 합산 재현 모두 본 세션 직접 실측. |

## B2.종합 판정 — **NO-GO** (K4·K5 FAIL)

- **단일 FAIL = NO-GO.** K4(가격엔진)·K5(종단)가 FAIL → 배치2 종단 정합 **NO-GO**.
- BLOCKED 1(K6 자격증명·정직)·CONDITIONAL 1(K7 축귀속 K6 의존). NO-GO 주사유는 K4/K5의 확정 결함.
- **NO-GO ≠ 작업 실패.** 게이트가 돈크리티컬 silent 과대청구(094 양방향)와 misfire(JUNGCHEOL)를 라이브+코드로 독립 비준 = 게이트 역할 정상 수행. 이 결함들이 교정 명세로 라우팅됨.

## B2.확정 결함 요약 (게이트 비준)

| ID | 결함 | 판정 | 돈영향 | 클래스 | 증거 |
|----|------|------|--------|--------|------|
| DEF-PE-10 | 094 엽서북 silent 이중합산 | 확정 | **과대 +11,500/장(단면)·+11,000/장(양면)** | A→B 경계* | 라이브 wiring+코드+재계산 |
| DEF-PE-08 | 068~071 PRF_BIND_SUM JUNGCHEOL(del=Y) misfire | 확정 | 과소/미완성가 | **B(공유 comp/공식)** | 코드 del_yn 부재+배선 |
| B2-DL(5) | 책자 사이즈 옵션→삭제 siz dead link | 확정 | 차단(견적불가) | A(상품별 option_item) | join 재현 5건 |
| DEF-PE-09/11/12/13/14 | MISSING 28(미바인딩/미가격) | 확정 | 차단(견적0원) | A 다수+B 일부 | bind=0·pp=0 |
| K2-070 | PUR책자 자재 MISSING | 확정 | 차단(용지비 누락) | A(상품별 materials) | 형제 대비 0행 |

> *094 교정=print_opt_cd 충전(comp 단가행 UPDATE)은 공유 comp(COMP_PCB_*)를 건드리나 단가값 불변·차원 충전만. use_dims는 comp 마스터(공유)→클래스 B 경계. 상품별이 아니라 comp 차원 정의 변경이므로 인간 승인+공유영향 검토 필요.

## B2.미해결 (K6 의존)
- **쟁점4(b) 책자 071/082/088 링/투명커버 materials 귀속**: 라이브 USAGE.05(투명커버 유광/무광)·USAGE.07(링 화이트/블랙/메탈·D링)=종이(USAGE.01/02/03)와 분리 슬롯 확인. **자재오염 vs 정당 옵션슬롯 확정은 product-viewer 화면에서 USAGE.05/07이 옵션처럼 쓰이는지 봐야 함 → K6 BLOCKED로 미해결.**
- **쟁점4(a) 악세 006~015 변형 sizes vs materials**: 라이브 006=8 색상변형(볼체인 오렌지~화이트 '3개1팩')·materials USAGE.07·sizes 0 확정. 방향=결함(색상=판매변형축≠소재사양)·정답축(sizes vs 신규 옵션축) 확정은 화면 확인 권장 → K6 의존.
