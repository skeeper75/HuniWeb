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
  "관리자 계정의 사용자 이름과 비밀번호를 입력해주세요"(인증 실패). CLAUDE.md note "test1234"도 불일치.
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
