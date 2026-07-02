# 스키마 단계 적대적 리뷰 — Huni-Ontology-KB (260703)

> 검증자: okb-adversarial-verifier · 2026-07-03
> 대상: `02_ontology/` 4산출 — `ontology-schema.md`·`file-format-spec.md`·`graph-build-spec.md`·`nl-query-paths.md`
> 자세: **모든 노드·주장은 틀렸다고 가정하고 반증 시도.** 반증에 실패한 것만 통과.
> 방법: 설계자 주장 비신뢰 — 라이브 스냅샷(`_foundation/live-snapshot/latest/` 22 CSV) 실측·플레이북 D-1~D-22 직접 대조·질의 경로 손추적. 기계 대조 가능분은 grep/스크립트로.
>
> **이 문서를 읽는 법(비전문가용):** "지식을 컴퓨터가 이해하게 정리하는 설계도(스키마)"가 실제 데이터와 규칙에 어긋나지 않는지 트집 잡아 확인한 결과다. 심각도 High=고치기 전엔 자동검사(lint)나 질의가 깨짐. Medium=문서가 실제 데이터와 어긋나 오해 유발. Low=사소한 표기.

---

## 0. 종합 판정: **교정 후 승인 (Conditional Approve)**

스키마 **골격은 건전**하다 — 앵커 22종 전부 라이브 실재, 폐쇄 세계·출처 강제·양면/GAP 패턴·가격 경계(값=엔진)·PE-010 도메인 정정 모두 정확히 반영됐다. **재설계 불요.**

단, **자동검사(lint)와 대표 질의를 실제로 깨뜨리는 내부 모순 2건(F-1·F-2)** 이 있어, 이를 고치기 전에는 빌드/질의가 성립하지 않는다. 이 2건은 스키마 문서 안 숫자·목록만 고치면 되는 **문서 정합 결함**(데이터 결함 아님)이라 교정 비용은 낮다. F-3·F-4(라이브 컬럼 소속 오귀속)는 집필자가 노드를 쓸 때 오도할 수 있어 함께 교정 권고.

**전수/표본 명시:** 앵커 실재성(축①)=22 테이블 전수 실측. 예시 노드(016/PRF_DGP_A)=전수 대조. 관계·타입·lint 규칙(축④⑤⑥)=4문서 전수 grep. **표본(안 본 곳):** 예시 외 다른 상품(032 코팅명함·047 제약 등)의 실제 노드는 아직 존재하지 않아(03_kb 비어 있음) 미검증 — 스키마 자체만 검증했고 실제 KB 노드 적재는 이후 단계다.

---

## 1. 결함 보드

### F-1 [High · 축③⑤⑥] `references` 관계가 폐쇄 18종에 없는데 핵심 질의가 그것에 의존

- **결함:** ontology-schema §2는 관계 어휘를 **폐쇄 18종(R1~R18)**으로 못박고 "문서에 없는 관계명 = lint FAIL"(§2.0)·L-14·I-3로 강제한다. 그런데 `references`는 18종에 **없다.** 동시에:
  - `nl-query-paths.md` S4·S5(용도 추천, 질의 유형 2)의 **유일한 연결 메커니즘**이 `INTENT_cafe_opening --references--> {상품}`.
  - `graph-build-spec.md` §3.2·§4.2(b)가 본문 `[[ ]]`를 전부 `references` 엣지로 자동 추출·질의(`e.rel IN ('references')`).
  - `file-format-spec.md` §3.2도 `[[ ]]`→`rel: references`.
- **증거(grep):**
  ```
  02_ontology/nl-query-paths.md:47  INTENT_cafe_opening --references--> {product-엽서·쿠폰류·스티커}
  02_ontology/graph-build-spec.md:66  본문 [[노드id]] | doc(references·약)
  02_ontology/graph-build-spec.md:113  WHERE e.src='INTENT_cafe_opening' AND e.rel IN ('references')
  02_ontology/ontology-schema.md §2  R1~R18 목록에 references 부재(확인)
  ```
- **영향:** ① 빌더가 `[[ ]]`에서 만든 `references` 엣지는 L-14(rel∈18종)·I-3(타입 위반)에서 **전부 FAIL** → 빌드 중단. ② 용도 추천(질의 유형 2 전체)이 선언 어휘로 **완결 불가** — nl-query-paths가 "S4 ✅ 스키마 충분"이라 표기했으나 실제로는 미선언 관계에 의존(경로 증명 구멍). ③ intent 노드가 `references`만 가지면 L-19 고아 검사에서도 걸림(L-19 예외는 term·rule뿐, intent 미포함).
- **반증 시도:** "references는 약한 관계라 예외일 것" → 반증 실패. §2.0은 예외를 두지 않고 "문서에 없는 관계명=FAIL"이라 명시. file-format-spec도 references를 "빌더가 추출"한다면서 L-14에서 걸리는 자기모순.
- **교정안:** `references`를 R19로 **정식 등재**(방향 any→any·유래 doc·"약한 참조·타입 없음" 정의)하고 §0 "관계 18종"→"19종"·L-14·I-3 반영. 또는 intent→상품 연결을 기존 어휘(예 `uses` 계열 신설 대신 `references` 승격이 최소 변경). **어느 쪽이든 문서에 등재해야 폐쇄 규칙과 정합.**
- **라우팅:** architect(스키마 문서 자체 결함).

### F-2 [High · 축②⑤⑥] 개체 유형 "15종"인데 `gap`·`intent`가 type 값으로 쓰여 실제 17종 — lint 화이트리스트 모순

- **결함:** §0·mermaid·L-4·graph-build I-3가 일관되게 "**개체 유형 15종**"(12 라이브 + 3 KB)이라 선언하고, lint L-4/I-3가 "type이 15종에 존재"를 화이트리스트로 검사한다. 그러나 `gap`과 `intent`는 실제 **type 값으로 사용**된다:
  - 예시 4.3 `type: gap`, L-10 "type=gap이면…", I-1/5.1 gap 노드.
  - §1.2 표에 `intent`(id 접두사 `INTENT_`)·S4~S6 `INTENT_cafe_opening` 노드, file-format-spec 디렉토리 `intent/`.
  → 실제 type는 **17종**(12 + term·rule·decision·gap·intent).
- **증거(grep):** `15종` 4곳(ontology-schema:14·file-format-spec:46,123·graph-build:145) 모두 15로 고정. §7 일탈표는 "intent·gap을 개체 유형 목록(1.2)에 명시 추가"라고 **일탈을 자인**했으나 **개수(15→17)·lint 화이트리스트를 갱신 안 함.**
- **영향:** L-4/I-3의 "15종 화이트리스트"를 문자 그대로 구현하면 `type: gap`·`type: intent` 노드가 **FAIL**(빌드 중단) — 정작 gap은 스키마의 자랑(정직한 미상 표기)인데 자기 lint에 걸림.
- **반증 시도:** "gap·intent는 패턴이지 type이 아닐 것" → 반증 실패. 예시 4.3이 명시적으로 `type: gap`, 질의가 INTENT_ 노드를 1급 노드로 탐색. 둘 다 type 값.
- **교정안:** "15종"→"17종"으로 통일(§0·L-4·I-3·file-format-spec §2.1 주석)하고, lint 화이트리스트에 gap·intent 명시 포함. §1.2 헤더 "3종"→"5종(term·rule·decision·gap·intent)".
- **라우팅:** architect.

### F-3 [Medium · 축①④⑤] `ref_dim_cd`를 E11 option_group 속성으로 오귀속 + 옵션 3층 접기의 다형참조 소실

- **결함:** E11은 `option_group` 핵심 속성에 **`ref_dim_cd`**를 넣고, R11 `option_refs`를 "option_group→(size|material|process|print_option) **N:1**"로 정의한다. 라이브 실측: `ref_dim_cd`(+`ref_key1`/`ref_key2`)는 **`t_prd_product_option_items`** 컬럼이지 option_groups 컬럼이 아니다. option_groups 헤더엔 ref 계열 컬럼이 **없다.**
- **증거(라이브):**
  ```
  t_prd_product_option_groups 헤더: ...sel_typ_cd,min_sel_cnt,max_sel_cnt,mand_yn... (ref 없음)
  t_prd_product_option_items 헤더: prd_cd,opt_cd,item_seq,ref_dim_cd,ref_key1,ref_key2,...
  ```
- **영향:** 스키마 §1.1이 groups+options+option_items 3테이블을 **E11 한 노드 유형으로 접었는데(fold)**, 실물 차원 참조(어느 자재/사이즈를 가리키나)는 **item 단위**다. 한 그룹의 N개 item이 서로 다른 차원을 가리키면 "option_group→dim N:1" 엣지로는 **어느 item이 무엇을 가리키는지 구분 불가**. 이는 질의 S9(자재→상품)·S12("이 옵션 고르면 가격↑?")의 옵션→차원→가격구성요소 배선 추적 정밀도를 떨어뜨린다(가격 인접 경로). L-18("option_refs 타깃이 같은 부모 product 실재")도 item 키(ref_key1/2) 없이는 정확 판정 어려움.
- **교정안:** ① E11 속성표에서 `ref_dim_cd`를 빼고 "option_item 단위 다형참조(ref_dim_cd+ref_key1/2)"로 설명 이동. ② R11 카디널리티를 **N:M**으로 정정하거나, option_item을 하위 앵커(블록)로 두어 item별 `option_refs` 엣지를 생성. 최소안=R11에 `ref_key` 한정자(qualifier)를 실어 타깃 실물을 특정.
- **라우팅:** architect.

### F-4 [Medium · 축①] `addtn_yn`을 E10 price_component 속성으로 오귀속 (실제=formula_components 엣지)

- **결함:** E10 `price_component` 핵심 속성에 "**addtn_yn(가산)**"을 넣었다. 라이브 실측: `addtn_yn`은 **`t_prc_formula_components`**(공식↔구성요소 배선 테이블) 컬럼이고, `t_prc_price_components`에는 없다(헤더: comp_cd,comp_nm,comp_typ_cd,note,use_yn,prc_typ_cd,use_dims,del_yn,del_dt).
- **증거(라이브):**
  ```
  t_prc_price_components 헤더: ...prc_typ_cd,use_dims... (addtn_yn 없음)
  t_prc_formula_components 헤더: frm_cd,comp_cd,disp_seq,addtn_yn,...
  ```
- **영향:** `addtn_yn`(가산 여부)은 같은 구성요소라도 **공식마다 다를 수 있는 엣지 속성**이다. E10 노드 속성으로 오귀속하면, 한 구성요소가 여러 공식에 다른 가산 여부로 배선될 때 모델이 깨진다. 다행히 예시 4.2는 addtn을 **R9 has_component 엣지 주석**으로 올바르게 배치했다(문서 내부 불일치). 가격 의미(가산=돈 영향)라 Medium.
- **교정안:** E10 속성표에서 `addtn_yn` 제거, R9 `has_component` 엣지의 한정자(qualifier: addtn)로 명시. `prc_typ`→정확 컬럼명 `prc_typ_cd`.
- **라우팅:** architect.

### F-5 [Low · 축⑦] 예시 4.2 PRF_DGP_A 구성요소 8개 나열, 라이브 실제 10개 (별색화이트·무광코팅 누락)

- **결함:** 예시 4.2는 PRF_DGP_A의 has_component를 8개(DIGITAL_S1·PAPER·CORNER_RIGHT·CREASE_1L·PERF_1L·VARTEXT·VARIMG·COAT_GLOSSY)로 나열. 라이브 `t_prc_formula_components` 실측=**10개** — 누락 2: **`COMP_PRINT_SPOT_WHITE_S1`(disp_seq=1, 목록의 첫 항목!)**·`COMP_COAT_MATTE`.
- **증거(라이브):** `grep "^PRF_DGP_A," t_prc_formula_components.csv` → 10행. 문서 Sources 자체도 "PRF_DGP_A **10구성요소**"라 적어 예시(8)와 불일치.
- **영향:** §4 서두가 "구조 예시(수치는 스크립트 전사 대상)"라 명시했으므로 실제 노드 적재 시 스크립트가 10개를 채우면 해소 → Low. 단 disp_seq=1 별색화이트 누락은 독자가 실제 구성으로 오해할 여지.
- **교정안:** 예시에 "…외 별색화이트·무광코팅 = 스크립트 전사(총 10)" 한 줄 추가, 또는 10개 완전 나열.
- **라우팅:** architect(예시만 보정).

### F-6 [Low · 축①] E1 수량 컬럼명 "min/max/incr_qty" — 실제 `qty_incr`

- **결함:** E1 핵심 속성 "min/max/**incr_qty**". 라이브 `t_prd_products` 실제 컬럼=`min_qty,max_qty,**qty_incr**`(순서 반대). file-format-spec 예시는 `min_qty`로 맞음.
- **영향:** 서술 문단의 축약 표기라 실해 없음. Low.
- **교정안:** `qty_incr`로 표기 통일.

### F-7 [Low~Medium · 축①④] R14 has_addon "product→product" — 실제는 템플릿(tmpl_cd) 경유

- **결함:** R14 `has_addon`을 product→product(예 product-016→product-envelope)로 모델. 라이브 `t_prd_product_addons` 헤더=`prd_cd,disp_seq,note,reg_dt,upd_dt,**tmpl_cd**` — 부속상품은 **직접 prd_cd 링크가 아니라 tmpl_cd→`t_prd_templates`.base_prd_cd** 경유다. §1.1이 템플릿 노드 유형을 안 만들기로 해(search-before-mint) 접었으나, 이 접기로 "엽서봉투 5행 TMPL"(template_selections)의 선택 상세가 소실된다.
- **영향:** R14를 §2.2 문서유래(doc)로 정직히 분류했고 addon은 가격 파생이 제한적이라 Low~Medium. 파일럿에서 addon 가격 추적이 필요하면 승격 재검토(§1.1 스스로 그 여지 명시).
- **교정안:** R14 정의에 "실 배선=product→template(tmpl_cd)→base_prd, 문서 접기"를 명시. 파일럿 실측 후 template 노드 승격 여부 판단.

### F-8 [Low · 축⑥] 고아 노드 예외 목록이 두 문서에서 불일치

- **결함:** graph-build I-1은 고아 허용을 "term·rule·**decision**"으로, file-format-spec L-19는 "term·rule"로 규정(decision 누락). 같은 규칙의 두 판본이 다르다.
- **영향:** decision 노드가 엣지 없이 존재할 때 한 lint는 통과·다른 lint는 경고 → 기계 검증 비결정. Low.
- **교정안:** 두 목록을 term·rule·decision·intent(F-1 연동)로 통일.

### F-9 [Low · 축①] E3 size 핵심 속성에 "판수(UP)" — 실제는 파생값(fn_calc_pansu)

- **결함:** E3가 "판수(UP)"를 size 핵심 속성처럼 나열. 도메인 규칙 12항·pack §3.8에 따르면 판걸이수는 **DB 함수 `fn_calc_pansu`(t_siz_pansu lookup→기하 폴백)** 계산값이지 사이즈 컬럼이 아니다(t_siz_sizes에 판수 컬럼 없음). 예시 4.3 gap은 이를 `derived_from`으로 올바르게 모델.
- **영향:** 집필자가 size props에 raw 판수 숫자를 넣어 D-9(수치 산문 금지)를 어길 유혹. Low.
- **교정안:** E3 속성에서 "판수(UP)"를 빼고 "판걸이수는 파생(derived_from·엔진 계산)"으로 주석.

---

## 2. 반증 실패 = 통과 항목 (적대적으로 의심했으나 정합 확인)

| 검사 | 의심(반증 가설) | 실측 결과 | 판정 |
|------|----------------|-----------|------|
| 축① 앵커 22종 실재 | "존재하지 않는 t_* 앵커가 있을 것" | 22 테이블 전부 live-snapshot에 실재 | ✅ 통과 |
| 예시 016 앵커 | "PRD_000016·PRF_DGP_A 날조" | PRD_000016 프리미엄엽서·PRD_TYPE.01·min_qty=15·PRF_DGP_A 바인딩·PROC_000004 mand=Y·MAT_000074 USAGE.07·POPT_000001/002 전부 실재 | ✅ 통과 |
| GAP 노드 정직성 | "판수 15 vs 18 충돌은 지어낸 것" | pack §3.7 GAP-1·source-registry §9·KB_01 §8 #1에 실재(견적 분모 직결) | ✅ 통과 |
| PE-010 정정 | "판수=앱 계산 낡은 서술 잔재" | 예시 4.2·T-7이 "fn_calc_pansu(앱 아님) 정정"을 정확 반영(승계맵 DROP D-1 정합) | ✅ 통과 |
| 축③ 거절 경계 | "'상품+가격만' 확정과 어긋날 것" | S13~S16이 주문·배송·회원·쿠폰·재고·경쟁사가격 전부 거절, RULE_scope_boundary 노드 선언 = 사용자 확정 범위와 **정확 일치**·날조 금지 명시 | ✅ 통과 |
| 축④ 도수 오모델 | "도수를 clr_cd로 오모델링(T-4 함정)" | E5 print_option이 clr_cd와 분리(front/back_colrcnt_cd·print_opt_cd) — 함정 회피 | ✅ 통과 |
| 축④ 어휘 재발명 | "uses/requires/priced_by 있는데 새 유형 남발" | §9 동사 6종 승계·derived_from/alias_of만 신설(정당)·단가행 접기(D-22) — 과잉 mint 없음 | ✅ 통과 |
| 축② 가격 경계 | "온톨로지가 가격 값 계산" | D-18 준수 — 배선까지만·값=evaluate_price 위임, 질의도 "최종 금액은 견적기" | ✅ 통과 |
| prd_typ_cd 값 | "존재 않는 유형 코드" | 라이브 .01(226)·.02(54)·.03(20) 실재. .05(추가)는 SOT 유효코드지만 현재 0행(디지털 파일럿엔 .01/.02/.03만) — 결함 아님 | ✅ 통과 |

---

## 3. 축별 통과율 요약

| 축 | 검사 내용 | 결과 |
|----|-----------|------|
| ① t_* 앵커 정확성 | 22 테이블 전수 실측 | 테이블 100% 실재. **컬럼 소속 오귀속 3건**(F-3 ref_dim_cd·F-4 addtn_yn·F-6 qty_incr)·F-9 판수 |
| ② D-1~D-22 위반 | 22 결정 대조 | D-7 위반 1건(F-1 개방 관계명 references)·§7 자인 일탈의 개수 미갱신(F-2). 나머지 정합 |
| ③ 질의 경로 증명 | 16 시나리오 손추적 | 유형 2(용도 추천) 경로가 미선언 `references`에 의존(F-1)=구멍. 거절 경계=확정 범위 정합 ✅ |
| ④ 어휘 재발명 | 관계·유형 mint 점검 | 과잉 없음. 단 옵션 3층 접기가 다형참조 소실(F-3) |
| ⑤ 폐쇄 스키마 구멍 | 유형·관계 폐쇄성 | F-1(references 미선언)·F-2(15 vs 17)로 폐쇄 목록 자체가 불완전 |
| ⑥ lint 기계검증성 | lint 규칙 실행가능성 | 대체로 결정론 검증 가능. F-1·F-2로 L-14·L-4·I-3가 실제로는 정상 노드를 FAIL·F-8 예외목록 불일치 |
| ⑦ 디지털 실물 적합성 | 예시 vs pack 원천 | 예시 앵커 정확. F-5 구성요소 8 vs 10 undercount(Low·구조 예시) |

---

## 4. 교정 우선순위 (architect 라우팅)

1. **선행(빌드/질의 성립 조건):** F-1(references 등재 또는 대체)·F-2(15→17·lint 화이트리스트). 이 둘 미해결 시 빌드 lint가 정상 노드를 FAIL → KB 적재 불가.
2. **집필 오도 차단:** F-3(ref_dim_cd·option 다형참조)·F-4(addtn_yn) — 노드 속성 위치가 실 스키마와 어긋나면 집필자가 잘못 쓴다.
3. **보정:** F-5~F-9(예시·표기·문서 정합).

전부 **스키마 문서(02_ontology) 내부 수정**으로 해소 가능 — 라이브 데이터 결함·상위 보고 대상 없음. 재설계 불요.

---

## 5. 검증 범위·한계 (결함 0 아님·정직 선언)

- **검증함:** 4문서 전문·앵커 22 테이블 전수·예시 노드 2종 라이브 대조·GAP/거절 원천 대조·플레이북 D-1~D-22·lint 규칙 텍스트.
- **미검증(표본 밖):** ① 실제 KB 노드(`03_kb/`)는 아직 미존재 — 스키마만 검증, 노드 적재 정합은 이후 단계. ② `standards-mapping.md`·`blocklist.md`·`_glossary.md` 등 참조 파일 미존재분은 미검증(스키마가 전제만 함). ③ build_graph.py 실코드 미존재 — 멱등성·lint는 명세만 검증(실행 검증 불가). ④ codex 독립 2차 미수행(Claude 단독) — F-1·F-2는 결정론 grep으로 확증했으나 F-3·F-7 설계 판단은 단일 검증자 의견.
- **결함 0 아님:** High 2·Medium 2·Low 5. "무결" 단정 안 함.

## Sources
- 라이브 실측: `_workspace/_foundation/live-snapshot/latest/` 22 CSV 헤더·PRD_000016·PRF_DGP_A(10구성요소)·prd_typ_cd 분포·t_prd_product_option_items(ref_dim_cd)·t_prc_formula_components(addtn_yn)
- 대상: `02_ontology/{ontology-schema,file-format-spec,graph-build-spec,nl-query-paths}.md`
- 대조: `00_research/methodology-playbook.md`(D-1~D-22)·`01_curation/pack-digital-print.md`(§3 축별·GAP-1)·`01_curation/wiki-inheritance-map.md`(PE-010 DROP)
