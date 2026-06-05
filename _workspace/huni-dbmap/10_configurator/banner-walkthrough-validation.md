# banner-walkthrough.md 적대 검증 보고서

> 검증 2026-06-06 · `dbm-validator` 독립 적대 검증 · 대상 `10_configurator/banner-walkthrough.md` (+ `cpq-design.md` 정합).
> 방법: 인용된 모든 실코드·값·도메인 주장을 권위 소스에 char-단위 대조(grep/awk/python CSV 파싱) + JSONLogic 손계산. DB read-only(쓰기 0).
> 권위 순서: 라이브(존재 판정) > 엑셀/ref(값 권위) > silsa.md(도메인) > 설계문서.
> 식별자/코드/SQL/JSON = English, 설명 = Korean.

---

## 0. 판정 요약 (verdict table)

### 0.1 오케스트레이터 지정 6대 고위험 체크

| # | 체크 | 판정 | 증명 소스 라인 |
|---|---|---|---|
| 1 | nonspec 범위 (가로 500~1750, 세로 500~5000) | **VERIFIED** | silsa-l1.csv row_seq 109: col[12]`비규격_가로`=`500~1750`, col[13]`비규격_세로`=`500~5000`. 우려된 `3000/4000/5000`은 col[28]`price(V)`(가공별 단가)로 **사이즈 컬럼 아님** — 오독 없음 |
| 2 | 부착(PROC_000081) `대상` enum에 `끈` 존재 | **VERIFIED** | ref-processes.csv: `{"대상": enum, "values":["라벨","맥세이프","끈","테입"]}` — `끈` literal 존재. G-SL-4 process측 논거 성립 |
| 3 | `ref_param_json` provenance (설계 미존재 의혹) | **VERIFIED (정합, scope drift 아님)** | cpq-design.md line 71/75/153/171에 `ref_param_json (jsonb, 신규 제안)` **명시 존재**. 오케스트레이터 전제("설계에 없다")가 오류. 워크스루는 설계와 일관 |
| 4 | JSONLogic 정확성(손계산) | **VERIFIED** | 컴파일 JSON 직접 평가: 4000×900→**FALSE**(width>1750), 1500×900→**TRUE**. R-GAKMOK-HEIGHT: LE900·height900→valid, GT900·height900→invalid. 논리 역전 없음 |
| 5 | `[CONFIRM]` 정직성 | **VERIFIED (정직)** | ref-products.csv: 각목 0행·큐방 0행·실내/실외 배너거치대 0행 — 전부 실부재. 발명 대신 `[CONFIRM]` 정당. 실재 코드(우드거치대 PRD_000012)는 실코드 사용 |
| 6 | 설계 발견(§5) 무결성 | **VERIFIED (건전, 일부 보강 권고)** | silsa.md G-SL-4/5와 정합. 단 누락 발굴 3건(§4 참조) |

### 0.2 테이블별 실코드 대조 (per-table code verification)

| 차원/주장 | 워크스루 값 | 라이브/ref 실값 | 판정 |
|---|---|---|---|
| PRD_000138 prd_nm | 일반현수막 | ref-products.csv `일반현수막` | VERIFIED |
| prd_typ_cd | PRD_TYPE.04 (디자인상품) | `PRD_TYPE.04` | VERIFIED |
| nonspec_yn / w·h min·max | Y / NULL | `Y` / 전부 공백(NULL) | VERIFIED (G-SL-6) |
| min/max/incr qty | 1 / 10000 / 1 | `1 / 10000 / 1` | VERIFIED |
| qty_unit_typ_cd | NULL | 공백(NULL) | VERIFIED (G-SL-9) |
| constraint_json | NULL(현재) | 공백 | VERIFIED |
| SIZ_000322 | 5000x900, work=cut=5000×900, dflt=Y | `5000x900` 5000/900/5000/900, dflt_yn=Y | VERIFIED |
| MAT_000182 | 현수막천, MAT_TYPE.08, USAGE.07, dflt=Y | `현수막천` MAT_TYPE.08 / usage USAGE.07 / dflt Y | VERIFIED |
| process 079/080/081 | 적재·mand=N·excl 공백 | 079/080/081 전부 mand_proc_yn=N·excl_grp_cd 공백 | VERIFIED (G-SL-5 MATCH) |
| PROC_000079 타공 param | `{구수 int 1~8 개}` | `{"구수","max":8,"min":1,"integer","unit":"개"}` | VERIFIED |
| PROC_000080 봉제 param | `{유형 enum[오버로크,말아박기,봉미싱], 폭 mm}` | 동일 enum + 폭 number mm | VERIFIED (봉미싱 ∈ enum) |
| PROC_000081 부착 param | `{대상 enum[라벨,맥세이프,끈,테입]}` | 동일 | VERIFIED |
| PROC_000053 완칼 | `{모양 string}` | `{"모양","string","required":false}` | VERIFIED |
| plate SIZ_000322 / JPG | output JPG | dflt_plt_yn=Y / output_file_typ=JPG | VERIFIED |
| PRD_000138 addon 0행 | 미적재 (G-SL-4) | ref-product-addons.csv에 PRD_000138 부재 | VERIFIED |
| 우드거치대/봉/행거 012/013/014 | 존재 | 3종 모두 PRD_TYPE.03 상품 존재 | VERIFIED |
| AS-IS addon shape | (prd_cd, addon_prd_cd) | 헤더 `prd_cd,addon_prd_cd,disp_seq,note,...` | VERIFIED |
| PRD_000133→PRD_000014 우드행거 | 직접링크 예시 | `PRD_000133,PRD_000014,1,우드행거+면끈 포함` | VERIFIED |
| PRD_000016→PRD_000001 OPP봉투 | "OPP접착봉투 110x160 50장" | `OPP접착봉투 110x160 mm 50장` | VERIFIED |
| 메쉬배너 거치대 실내+10000/실외+23000 | row 104~106 | row105 실내용배너거치대 10000 / row106 실외용배너거치대 23000 | VERIFIED |
| `set` 차원 / t_prd_product_sets | 각목=set 후보 | ref-product-sets.csv 존재(sub_prd_cd 구조) | VERIFIED (차원 실재) |
| SEL_TYPE.01 단일 / .02 다중 | 인용 | code-values.md line 54 동일 | VERIFIED |
| 가공 6값 / 추가 5값 | §3.2 열거 | L1 row108~113 가공 6 / 추가 5 char-단위 일치 | VERIFIED |

**MISMATCH/INVENTED 발견 건수: 0건.** 인용된 모든 실코드·값·도메인 주장이 권위 소스와 일치.

---

## 1. MISMATCH / INVENTED 상세

**해당 없음.** 적대 검증 결과 char-단위 불일치·발명값 0건. 워크스루의 `[CONFIRM]` 마커는 전부 진짜 미지값(라이브 실부재)으로, 알 수 있는데 숨긴 값은 없었다.

특히 오케스트레이터가 가장 의심한 두 지점이 **모두 워크스루가 옳고 의심 전제가 틀린** 것으로 판명:
- **#1 nonspec 범위:** `3000/4000/5000`은 `price(V)` 컬럼(col 28, 가공별 단가)이지 사이즈가 아니다. 아키텍트는 col 12/13(비규격_가로/세로)을 정확히 읽었다. R-SIZE-NONSPEC·§4 트레이스의 `4000>1750 FALSE`는 올바른 값 위에 서 있다.
- **#3 ref_param_json:** 설계(cpq-design.md)에 4곳(line 71/75/153/171) 명시돼 있다. "설계에 없는 컬럼"이라는 의혹 자체가 사실과 다르다. 정당한 설계 컬럼이다.

---

## 2. 설계 정합성 (cpq-design.md ↔ banner-walkthrough.md)

| 항목 | 설계(cpq-design) | 워크스루 인스턴스 | 정합 |
|---|---|---|---|
| option_groups PK·컬럼 | (prd_cd,opt_grp_cd) + sel_typ_cd/min/max_sel_cnt/mand_yn/disp_seq/use_yn | §3.1 동일 컬럼 사용 | OK |
| options PK·컬럼 | (prd_cd,opt_cd) + opt_grp_cd/opt_nm/dflt_yn/disp_seq/use_yn | §3.2 동일 | OK |
| option_items PK·컬럼 | (prd_cd,opt_cd,item_seq) + ref_dim_cd/ref_key1/ref_key2/**ref_param_json**/qty | §3.3 동일(ref_param_json 포함) | OK |
| templates | tmpl_cd + base_prd_cd/tmpl_nm/dflt_qty/price/use_yn/note | §3.4 동일 | OK |
| template_selections | (tmpl_cd,seq) + 옵션/차원 참조 | §3.4 (ref_dim_cd/ref_key1/value/qty) | OK (경미: 설계는 "opt_cd 또는 차원", 워크스루는 ref_dim_cd 슬롯 — 동형) |
| product_addons 변경 | addon_prd_cd→tmpl_cd, PK(prd_cd,tmpl_cd) | §3.5 동일 + 마이그레이션 규약 | OK |
| constraints | (prd_cd,rule_cd) + rule_typ(compatible/forbidden/required)/logic/err_msg | §3.6 동일 3 rule | OK |
| SEL_TYPE 재사용 | .01 단일/.02 다중 | §3.1 SEL_TYPE.01 | OK |
| OPT_REF_DIM | 신규 base-code 제안(잠정) | §1.3·§5.3 "잠정·신설 권고" | OK (양쪽 모두 미확정 명시) |

**정합성 결론: 워크스루는 설계의 충실한 인스턴스화.** 컬럼/키 불일치 없음. 단 아래 경미 노트:
- 설계 line 153은 공정 스키마 출처를 `t_proc_processes.prcs_dtl_opt`로 표기하나 ref CSV/워크스루는 `ref-processes.csv`/`prcs_dtl_opt`로 표기 — 물리 테이블명 `t_proc_processes`는 설계가 "잠정"으로 명시한 범위 내. 충돌 아님.
- `rule_typ` 값(compatible/forbidden/required)이 JSONLogic 평가 의미와 무관하게 분류 라벨로만 쓰임 — §4 평가는 logic만 사용하므로 라벨 오용 위험 없음. 단 라벨↔logic 의미 결합 규약은 양쪽 문서 모두 미정(권고: 명문화).

---

## 3. JSONLogic 손계산 상세 (체크 #4)

컴파일된 `constraint_json`(워크스루 §3.6 line 240~248)을 독립 평가기로 직접 실행:

| 입력 | R-SIZE-NONSPEC | R-GAKMOK-HEIGHT | R-BONGJE | 전체 | 워크스루 주장 | 일치 |
|---|---|---|---|---|---|---|
| nonspec 4000×900, chuga=LE900 | FALSE (4000>1750) | (LE900,900≤900) true | (gagong≠봉미싱) true | **FALSE** | "4000>1750 FALSE" | ✓ |
| nonspec 1500×900, chuga=LE900 | TRUE | TRUE | TRUE | **TRUE/PASS** | "정정 후 PASS" | ✓ |
| nonspec 1500×900, chuga=GT900 | TRUE | FALSE (900 not >900) | TRUE | **FALSE** | (암시) GT900은 height>900 필요 | ✓ |

- **구문 유효성:** JSONLogic 표준 연산자(and/or/!=/==/>=/<=/>/if)만 사용 — 유효.
- **논리 역전 없음:** `if[cond, then, true]` 패턴이 "해당 옵션 아니면 무조건 통과"를 정확히 구현. forbidden 라벨이지만 logic은 "유효할 때 true" 반환 — §4가 logic 직접 평가하므로 일관.
- R-SIZE-NONSPEC의 `or[size_mode≠nonspec, 범위검사]`도 규격 선택 시 무조건 통과를 정확히 표현.

**결론: JSONLogic 3 rule + 컴파일 JSON 전부 워크스루가 주장한 결과를 실제로 계산한다.**

---

## 4. 누락 발굴 (아키텍트가 놓친 설계 약점)

워크스루는 정직하고 정확하나, 배너 1종이 *행사하지 않은* 설계 케이스에서 다음 약점이 드러난다.

### GAP-1 [MAJOR] pick-N / max-N 옵션그룹이 배너에서 미검증
- §3.1 두 그룹 모두 SEL_TYPE.01(택일, min=max=1 또는 0/1)뿐. 설계 D-2/§5는 "pick-N(SEL_TYPE.02)+max_sel_cnt=N"을 핵심 일반화로 내세우나 **배너 인스턴스가 이를 한 번도 행사하지 않는다.**
- 영향: 일반화의 절반(다중선택·max-N)이 미실증. 실증 완전성을 위해 SEL_TYPE.02를 쓰는 silsa 상품(예: 자재 sel_typ_cd=다중인 케이스, MAT_000182는 sel_typ 공백) 또는 다른 시트 상품으로 보조 인스턴스 권고.

### GAP-2 [MAJOR] process_excl_groups 마이그레이션이 실제로 작동하는지 미검증
- 설계 §3.1/§3.4는 기존 `t_prd_product_process_excl_groups`(process 전용 택일)를 옵션그룹으로 "흡수/마이그레이션"한다고 주장. 그러나 **일반현수막은 excl_grp_cd가 전부 공백(0행)** — 마이그레이션 원천이 없는 상품이다(silsa.md §③: 전 28상품 택일그룹 부재).
- 영향: 워크스루 §5.1 "택일그룹 일반화 성공"은 *공백에서 새로 만든 것*이지 *기존 excl-group 변환*이 아니다. 실제 excl_grp_cd가 채워진 상품(예: 제본 GRP-BOOK류 — silsa 밖)으로 변환을 실증해야 마이그레이션 주장이 입증된다. 현 워크스루는 마이그레이션을 "동형"이라 단언하나 미실행.

### GAP-3 [MINOR] template_selections가 빈약 — 복합 add-on 미실증
- §3.4 거치대 template은 selections가 사실상 0행(수량만). 설계가 자랑하는 "OPP봉투+사이즈+50장 freeze"의 진짜 가치는 미실증. 워크스루 스스로 "최소 사례"라 인정하나, 복합 selections 1건(예: PRD_000016 OPP봉투 체인)을 곁들였으면 template 메커니즘 실증이 완전했을 것.

### GAP-4 [MINOR] 양면테입→`{"대상":"테입"}`은 아키텍트 해석(엑셀 명시 아님)
- L1 가공값은 `양면테입`이고 부착 enum값은 `테입`. 둘의 동일시는 합리적 추론이나 **엑셀 명시 매핑이 아니다.** §3.3은 이를 `[CONFIRM]` 없이 단정. 발명은 아니나(테입 enum 실재), "엑셀 명시값=권위" 원칙상 이 1:1 동일시는 도메인 해석임을 표기 권고. (큐방은 `[CONFIRM]` 했으면서 양면테입은 안 한 비대칭.)

### GAP-5 [MINOR] 열재단 PROC_000053 매핑의 근거 부재
- §3.3 열재단→PROC_000053 완칼 `[CONFIRM]` 표기는 정직하나, **PRD_000138 적재 공정은 079/080/081뿐이며 053은 미적재**(ref-product-processes.csv 확인). 즉 열재단은 차원 행이 없어 옵션 등록 시 트리거(설계 §4 EXISTS 검사)에 걸린다 → "이미 등록된 차원만 참조" 규약과 충돌. 영향: 열재단 옵션은 053 적재 선행 필요(또는 "가공 없음" 센티넬 처리). 워크스루가 이 트리거 충돌을 명시하지 않음.

### GAP-6 [참고] gp/calendar류 비치수·공정택일 케이스를 배너가 행사 안 함
- 배너는 단일 size·단순 process로 gp(비치수 마스터모델링 미정)·calendar(택일 PARTIAL) 같은 round-3 BLOCKER 케이스를 전혀 자극하지 않는다. CPQ 설계가 그 난제까지 커버하는지는 본 워크스루로 입증 불가 — 별도 인스턴스 필요(범위 밖이나 "종단 실증" 표현은 배너 1종 한정임을 명시 권고).

---

## 5. §5 설계 발견 무결성 재검토

| 워크스루 주장 | 검증 |
|---|---|
| 5.1 polymorphic 3축 통일 | 정확. set 차원 실재(ref-product-sets.csv), process/material 차원 실재 |
| 5.1 타공 4/6/8 = 공정1행+param 재사용 | 정확. PROC_000079 1행 + `{구수:N}`. **G-SL-5가 "param 미적재" 명시** → ref_param_json 필요성 입증 강화 |
| 5.1 택일그룹 일반화 | 부분 과장 — GAP-2 참조(공백 신규생성이지 변환 실증 아님) |
| 5.2(a) 끈=process/각목=set 귀속 규약 | silsa.md G-SL-4와 char-단위 정합("끈/각목/큐방=부착 성격, 거치대=완제 addon") |
| 5.2(e)#1 공정 param 1급 시민·ref_param_json 필수 | 정확·강. G-SL-5 "공정행은 있으나 세부옵션 미확인"이 직접 뒷받침 |
| 5.2(e)#4 L1 데이터 모순(규격5000 vs 사용자입력1750) | 실재 모순. row108 규격 5000×900 vs row109 비규격 가로 500~1750 — CPQ가 검증시점 노출. 단 이는 "가로/세로 축 혼동" 가능성도 있음(규격 5000=가로, 비규격 가로 상한 1750) → 마스터 정합 필요 신호로는 타당 |
| 5.3 권고 7건 | 전부 건전. 단 GAP-1·2·5를 권고에 추가 필요 |

---

## 6. 최종 판정

### **CONDITIONAL-GO** — 신뢰할 수 있는 CPQ 설계 실증으로 인정하되, 실증 *완전성* 보강 조건부.

**근거:**
- 사실 정확성(fact-fidelity): **완벽.** 인용 실코드·값·도메인 주장 MISMATCH 0·INVENTED 0. 오케스트레이터가 가장 의심한 #1(nonspec)·#2(끈 enum)·#3(ref_param_json) 3건이 모두 워크스루가 옳고 의심 전제가 틀림.
- JSONLogic: 손계산 전건 일치, 논리 역전 없음.
- `[CONFIRM]` 정직성: 라이브 실부재 기반으로 정당, 숨긴 값 없음.
- 설계 정합: 컬럼/키 불일치 0.

**must-fix (순위):**
1. **[MAJOR·GAP-2]** "process_excl_groups 마이그레이션"은 배너가 0행이라 미실증 — §5.1 "일반화 성공" 표현을 "공백에서 신규 표현(변환 미실증)"으로 정정하고, excl_grp_cd가 실재하는 상품으로 변환 실증을 별도 추가.
2. **[MAJOR·GAP-1]** pick-N/max-N(SEL_TYPE.02 + max_sel_cnt)이 배너에서 미행사 — 일반화 절반 미실증. SEL_TYPE.02 케이스 보조 인스턴스 추가.
3. **[MINOR·GAP-5]** 열재단→PROC_000053은 미적재 차원 → 설계 §4 EXISTS 트리거와 충돌. 053 선적재 또는 센티넬 처리 명시(현재 `[CONFIRM]`만으로는 트리거 위반 미노출).

추가 권고(비차단): GAP-3(복합 selections 실증), GAP-4(양면테입 해석 표기), GAP-6("종단 실증"이 배너 1종 한정임 명시).

---

## 부록 — 적대 검증에 사용한 권위 소스 라인

- silsa-l1.csv row_seq 108~114 (python CSV 파서, col 11/12/13/23/28/29/31/33~35)
- ref-processes.csv: PROC_000053/079/080/081 `prcs_dtl_opt`
- ref-products.csv: PRD_000138 + 각목/큐방/거치대 부재 count
- ref-product-sizes.csv·ref-sizes.csv: SIZ_000322
- ref-product-materials.csv·ref-materials.csv: MAT_000182
- ref-product-processes.csv: PRD_000138 = 079/080/081
- ref-product-addons.csv: PRD_000138 부재·AS-IS shape·PRD_000133/016 링크
- ref-product-plate-sizes.csv: SIZ_000322 JPG
- ref-product-sets.csv: set 차원 실재
- code-values.md line 54: SEL_TYPE.01/.02
- silsa.md G-SL-4(line132)·G-SL-5(line140)·G-SL-6·G-SL-9: 도메인 권위
- JSONLogic: 독립 평가기 손계산(4000×900→FALSE, 1500×900→TRUE)
