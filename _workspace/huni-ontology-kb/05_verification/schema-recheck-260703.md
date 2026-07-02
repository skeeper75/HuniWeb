# 스키마 교정 재검증 — Huni-Ontology-KB (260703)

> 검증자: okb-adversarial-verifier · 2026-07-03 (2차·교정 재검증)
> 대상: `02_ontology/` 4문서 v1.0.1 (교정본) — `ontology-schema.md`·`file-format-spec.md`·`graph-build-spec.md`·`nl-query-paths.md`
> 근거 결함 보드: `05_verification/schema-review-260703.md` F-1~F-9
> 자세: **생성자(교정자) 주장 비신뢰.** 변경이력의 "해소했다"는 서술을 믿지 않고, 4문서 본문을 직접 grep/Read하고 라이브 스냅샷(`_foundation/live-snapshot/latest/`)으로 컬럼 소속을 반증 실측해 판정.
> 방법: 개수(17종/19종)·lint 화이트리스트·질의 SQL·mermaid·라이브 헤더를 전수 기계 대조. 교정이 **새 모순**을 만들지 않았는지 교차 확인.
>
> **읽는 법(비전문가용):** 1차 리뷰에서 잡은 9개 결함(F-1~F-9)을 설계자가 고쳤다고 해서, 진짜 고쳤는지·고치면서 다른 데를 깨뜨리진 않았는지 트집 잡아 다시 확인한 결과다.

---

## 0. 종합 판정: **승인 가능 (Approve)**

F-1~F-9 **9건 전부 해소**됐다. 빌드/질의를 실제로 깨뜨리던 High 2건(F-1·F-2)이 4문서 전반에 일관되게 반영됐고, 라이브 컬럼 소속 오귀속(F-3·F-4·F-6)은 라이브 헤더 실측으로 교정이 **정확함**을 확인했다. 개수(17종·19종)·lint 화이트리스트·질의 SQL·고아 예외 목록이 4문서 상호 일관하다.

**단 1건 잔여(비차단):** mermaid ERD의 `option_refs` 카디널리티가 R11 표 교정(N:M)과 어긋난 채 남아 있다(다이어그램=N:1). 그러나 mermaid는 문서 스스로 "개념 구조도(RDF 아님)"로 못박았고 `build_graph.py`가 파싱하는 대상이 아니라(정본=`03_kb` frontmatter+`[[ ]]`뿐) **빌드·lint·질의를 깨지 않는다.** 표기 잔여(Low)일 뿐 승인 차단 사유 아님 — 다음 편집 시 함께 정정 권고.

**전수/표본:** 4문서 전문 grep 전수·라이브 헤더 5테이블 실측·PRF_DGP_A 구성요소 라이브 카운트 전수. **미검증(1차와 동일):** 실제 KB 노드(`03_kb/` 미존재)·`build_graph.py` 실코드 미존재(명세만)·codex 2차 미수행(Claude 단독·단 F-1~F-6은 결정론 grep/CSV로 확증).

---

## 1. 항목별 재실측 (F-1~F-9)

### F-1 [High] `references` R19 정식 등재 — **해소 ✅**
- **재실측:** 4문서 전수 grep. `references`가 폐쇄 목록에 R19로 등재됐고, 개수가 4문서 모두 **"관계 19종"**으로 통일.
  - `ontology-schema.md`: §0(L15) "관계 유형 19종 = …+약참조 1종(references, R19)"·§2.2 R19 정의(any→any·`[[ ]]` 자동추출)·§7 정합표 "19종 폐쇄(R1~R18+R19)"·mermaid L285 `intent }o--o{ product : references` 추가.
  - `file-format-spec.md`: §3.1(L86) "관계 19종 중 하나만(L-14·R19 포함)"·§3.2 `[[ ]]`→references(R19·I-3 예외)·L-14 화이트리스트 "19종".
  - `graph-build-spec.md`: §3.2 origin 매핑 "R13~R16·R19=doc"·I-3(L144) "스키마 19종에 존재…R19는 any→any 타입검사 예외"·§4.2(b) intent 질의 `e.rel IN ('references')`가 이제 등재 관계.
  - `nl-query-paths.md`: S4 2단(L47)·§2 커버리지표(L135)에 "references=R19 정식 등재"·"✅ 스키마 충분" 판정이 이제 실제 성립.
- **잔존 "18종":** 3문서 변경이력 서술에만 존재(과거→현재 대비). 규칙 본문엔 0건.
- **판정:** 유형 2(용도 추천) 경로 구멍·L-14/I-3의 자기모순 FAIL 모두 제거. **해소.**

### F-2 [High] 개체 유형 15→17종·gap·intent 화이트리스트 — **해소 ✅**
- **재실측:** "15종" 규칙 본문 잔존 0(변경이력 서술 3건뿐). "17종"이 4문서 일관.
  - `ontology-schema.md` §0(L14)·§1.2 헤더 **"KB 전용 레이어 개체 (5종)"**(3종→5종)·§7 일탈표 "총 17종".
  - `file-format-spec.md` §2.1 type 주석 "17종 중 하나(L-4·gap·intent 포함)"·L-4 "17종(앵커12+term·rule·decision3+gap·intent2)…화이트리스트 대조(gap·intent 포함)".
  - `graph-build-spec.md` I-3(L145) "node.type이 17종에 존재…화이트리스트에 gap·intent 포함".
- **판정:** `type: gap`·`type: intent` 노드가 L-4/I-3에서 FAIL되던 위험 제거. lint 화이트리스트가 실제 사용 type와 일치. **해소.**

### F-3 [Med] `ref_dim_cd` 오귀속·옵션 다형참조 — **해소 ✅ (mermaid 잔여 1건)**
- **라이브 반증 실측:**
  - `t_prd_product_option_groups` 헤더 = `prd_cd,opt_grp_cd,…,mand_yn,disp_seq,use_yn,…` → **ref 계열 컬럼 없음**(교정 주장 정확).
  - `t_prd_product_option_items` 헤더 = `prd_cd,opt_cd,item_seq,ref_dim_cd,ref_key1,ref_key2,…` → **ref_dim_cd 실재**(item 단위 확인).
- **문서 재실측:** E11(L51) 속성표에서 `ref_dim_cd` 제거, "이 노드 속성 아님 — option_items 컬럼이므로 R11 엣지 한정자로 표기"로 이동. R11(L120) 카디널리티 **N:1→N:M**·`ref_key1`/`ref_key2` 한정자·item별 엣지 1개·option_item 노드 승격은 파일럿 후 재검토 명시.
- **⚠ 새 모순(Low·비차단):** mermaid ERD L278-279가 `option_group }o--|| material : option_refs`(=N:1)로 남아 R11 표(N:M)와 어긋남. F-3 교정이 R11 표만 N:M으로 바꾸고 mermaid 크로우풋을 안 고침. **단 mermaid는 §5 말미(L312)에서 "개념 구조도(RDF 아님)"로 선언·빌더 미파싱** → 기계 검증 무영향. 표기 잔여.
- **판정:** 핵심 오귀속·다형참조 소실 **해소.** mermaid 카디널리티는 다음 편집 시 `}o--o{`로 정정 권고(Low).

### F-4 [Med] `addtn_yn` 오귀속 — **해소 ✅**
- **라이브 반증 실측:**
  - `t_prc_price_components` 헤더 = `comp_cd,comp_nm,comp_typ_cd,note,use_yn,reg_dt,upd_dt,prc_typ_cd,use_dims,del_yn,del_dt` → **addtn_yn 없음**(교정 정확).
  - `t_prc_formula_components` 헤더 = `frm_cd,comp_cd,disp_seq,addtn_yn,reg_dt,upd_dt` → **addtn_yn 실재**(배선 엣지 컬럼).
- **문서 재실측:** E10(L50)에서 `addtn_yn` 제거→"R9 has_component 엣지 한정자로 표기"·`prc_typ`→`prc_typ_cd` 교정. 예시 4.2(L216-218) addtn을 엣지 qualifier로 배치(문서 내부 일치). mermaid에 `price_formula_component_edge` 블록 신설(L303-305, addtn_yn=엣지 속성)·price_component 블록(L298-302)엔 prc_typ_cd·use_dims만.
- **판정:** 한 구성요소가 여러 공식에 다른 가산으로 배선되는 모델이 엣지 속성으로 정확 표현. **해소.**

### F-5 [Low] PRF_DGP_A 8→10 구성요소 — **해소 ✅**
- **라이브 실측:** `t_prc_formula_components.csv` `^PRF_DGP_A,` = **10행.** 목록=COMP_PRINT_SPOT_WHITE_S1(disp_seq1)·COMP_PAPER·COMP_PP_CORNER_RIGHT·COMP_PP_CREASE_1L·COMP_PP_PERF_1L·COMP_PP_VARTEXT_1EA·COMP_PP_VARIMG_1EA·COMP_COAT_GLOSSY·COMP_COAT_MATTE·COMP_PRINT_DIGITAL_S1.
- **문서 재실측:** 예시 4.2(L217-226)가 **10개 전부 나열**(별색화이트 disp_seq=1·무광코팅 포함)·"총 10구성요소(live 실측·스크립트 전사 권위)" 주석. 문서=라이브 정합.
- **판정:** **해소.**

### F-6 [Low] `incr_qty`→`qty_incr` — **해소 ✅**
- **라이브 실측:** `t_prd_products` 헤더 수량 컬럼 = `min_qty,max_qty,qty_incr,dflt_qty,qty_unit_typ_cd`.
- **문서 재실측:** E1(L41) `min_qty/max_qty/qty_incr`로 정정. 규칙 본문 `incr_qty` 잔존 0(변경이력 서술 1건뿐). **해소.**

### F-7 [Low~Med] R14 `has_addon` 템플릿 경유 — **해소 ✅**
- **재실측:** R14(L128)에 "실 배선=product→template(`tmpl_cd`)→`t_prd_templates`.base_prd_cd 경유(§1.1 template 노드 미신설로 문서 접기)·파일럿 후 승격 재검토" 명시. §1.1(L56)도 정합. **해소.**

### F-8 [Low] 고아 예외 목록 두 문서 불일치 — **해소 ✅**
- **재실측(교차):** `graph-build-spec.md` I-1(L138) = "term·rule·decision·intent은 독립 허용" ↔ `file-format-spec.md` L-19(L151) = "term·rule·decision·intent은 예외 허용(graph-build I-1과 통일)". **두 판본 동일.**
- 참고: `ontology-schema.md`엔 고아 예외 목록이 없어 변경 불요(F-8은 나머지 2문서 소관·정상). **해소.**

### F-9 [Low] E3 "판수(UP)" 오귀속 — **해소 ✅**
- **재실측:** E3(L43) 핵심 속성에서 "판수(UP)" 제거→"판걸이수는 사이즈 컬럼 아님 — 파생 `derived_from`·엔진 `fn_calc_pansu` 계산". 예시 4.3 gap이 `derived_from`으로 모델(L246)·R17 정의(L137)와 정합. **해소.**

---

## 2. 새 모순 유입 검사 (교정이 다른 곳을 깼는가)

| 교차 검사 축 | 방법 | 결과 |
|-------------|------|------|
| 개체 개수 일관 | 4문서 "15종/17종" grep | 규칙 본문 17종 통일·15종 잔존=변경이력뿐 ✅ |
| 관계 개수 일관 | 4문서 "18종/19종" grep | 규칙 본문 19종 통일·18종 잔존=변경이력뿐 ✅ |
| lint 화이트리스트 | L-4·I-3·L-14 대조 | 유형 17·관계 19·gap/intent/references 명시 포함 ✅ |
| 질의 SQL 정합 | graph-build §4.2(b) `references` | 이제 등재 관계 → nl-query S4 경로 성립 ✅ |
| 고아 예외 통일 | I-1 ↔ L-19 | term·rule·decision·intent 동일 ✅ |
| mermaid vs 표 | option_refs 카디널리티 | **N:1(mermaid) vs N:M(R11) 불일치 — Low·비차단**(개념도·미파싱) ⚠ |
| mermaid vs 표 | addtn_yn·prc_typ_cd | 엣지 블록 신설·price_component 블록 정합 ✅ |
| 라이브 컬럼 소속 | 5테이블 헤더 실측 | ref_dim_cd=items·addtn_yn=formula_components·qty_incr=products 전부 교정 정확 ✅ |

**신규 모순 = mermaid 카디널리티 1건(Low·비차단).** 그 외 교정이 새 결함을 유입하지 않았다.

---

## 3. 검증 범위·한계 (결함 0 아님·정직 선언)

- **검증함:** 4문서 v1.0.1 전문 grep·라이브 스냅샷 5테이블 헤더 실측·PRF_DGP_A 구성요소 라이브 전수 카운트·F-1~F-9 개별 재실측·4문서 상호 일관 교차.
- **미검증(표본 밖):** ① 실제 KB 노드(`03_kb/` 미존재) — 스키마 문서만 재검증. ② `build_graph.py` 실코드 미존재 — lint/멱등은 명세 텍스트만(실행 검증 불가). ③ `blocklist.md`·`_glossary.md`·`standards-mapping.md` 등 참조 파일 미존재분. ④ codex 독립 2차 미수행(Claude 단독) — F-1~F-6은 결정론 grep/CSV로 확증, F-3 mermaid 판단은 단일 검증자.
- **잔여 1건:** mermaid `option_refs` 카디널리티 N:1(다이어그램) vs N:M(R11 표). 비차단(개념도·빌더 미파싱). "무결" 단정 안 함.

## 4. 라우팅
- **F-1~F-9:** 전부 스키마 문서(02_ontology) 내부 교정으로 해소 — 라이브 데이터 결함·상위 보고 없음.
- **mermaid 잔여(Low):** architect — 다음 편집 시 L278-279를 `option_group }o--o{ material : option_refs`로 정정(선택·비차단).

## 5. 최종 판정
**승인 가능 (Approve).** F-1~F-9 9건 전부 해소·빌드/질의 성립 조건(F-1·F-2) 충족·라이브 컬럼 소속 교정 정확. mermaid 카디널리티 1건은 표기 잔여(Low·비차단)로 승인을 막지 않으며 후속 편집 큐에만 등재. **KB 노드 적재 단계 진행 가능.**

## Sources
- 재실측 대상: `02_ontology/{ontology-schema,file-format-spec,graph-build-spec,nl-query-paths}.md` v1.0.1
- 라이브 실측: `_workspace/_foundation/live-snapshot/latest/` — t_prc_price_components·t_prc_formula_components(PRF_DGP_A 10행)·t_prd_product_option_groups·t_prd_product_option_items·t_prd_products 헤더
- 근거 보드: `05_verification/schema-review-260703.md`(F-1~F-9)
