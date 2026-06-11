# 캘린더 + 디자인캘린더 — 교정 매니페스트 (round-13 C4)

> **작성** round-13 Phase 2c. 각 diff를 분류(CORRECT/MIS-LOADED/MISSING/EXTRA/AMBIGUOUS) + why(oracle 근거 + 적재로직 원인) + how(비파괴 교정 제안) + 심각도 + 라우팅. **비파괴 [HARD]:** 제안까지만(COMMIT/DDL/DELETE 0). EXTRA/REMOVED=논리삭제 제안. search-before-mint. 빈칸 0.
> **라우팅:** 교정직접=값 UPDATE 제안 / ddl-proposer=신규 엔티티·컬럼 / load-execution=미적재 적재본 / 컨펌=인간 결정.
> **[HARD] v03:** 진원이 상류 v03인 오적재는 "정답=상품마스터 L1"로 교정(v03 재참조 금지). load_master=순수 전파기.

---

## 0. 분류 분포 요약

| 분류 | 건수 | 비고 |
|------|:---:|------|
| CORRECT(의심 반증 포함) | 7 | size·도수·plate값·카테고리 고아 0·변형커버리지·prd_typ·디자인=같은상품 |
| MIS-LOADED | 3 | 삼각대=자재·링=자재·plate 적재경로(F-1) |
| MISSING | 7 | 장수·캘린더가공 택일그룹·삼각대거치 공정·봉투 addon·우드거치대 자재·디자인 고정가·MES |
| EXTRA | 1 | 탁상/미니 "링 블랙" 자재(트윈링 아닌데 부착) |
| AMBIGUOUS | 2 | 미니 카테고리(CAT_000112 vs 113)·자재 usage 슬롯(.07 공통 vs .01 본체) |
| **합계** | **20** | calendar 14 + design-calendar 6 |

> calendar/design-calendar 구분: C-CAL-* = 캘린더 공통, C-DC-* = 디자인캘린더 surface 고유.

---

## 1. 교정 매니페스트 표

| ID | 상품 | 속성 | 분류 | 라이브 현재값 | 정답값 | why (oracle + 적재로직 원인) | how (비파괴 교정 제안) | 심각도 | 라우팅 |
|----|------|------|------|---------------|--------|------------------------------|------------------------|:------:|--------|
| **C-CAL-01** | 108/109 | 삼각대=자재 | **MIS-LOADED** | MAT_000252/254 삼각대(MAT_TYPE.07 부속)·usage USAGE.07·dflt Y | 삼각대 거치=**공정**(`t_prd_product_processes` + 삼각대컬러 param) | oracle: schema-intent §3 #6(후가공=공정)·bom.md §1·Q5. 진원: 상류 v03 14시트(자재)에 거치부속 평면화. load_master 전파(L318-333) | ① 삼각대거치 공정 mint(마스터 부재·아래 C-CAL-09) ② `t_prd_product_processes`에 삼각대거치 공정행 + 삼각대컬러 param ③ MAT_000252/254 자재행은 논리삭제 제안(del_yn) — hard-delete 금지 | High | ddl-proposer(공정 mint)+load-execution+컨펌 |
| **C-CAL-02** | 111/112 | 링=자재 | **MIS-LOADED** | MAT_000253 링 블랙(MAT_TYPE.07)·usage USAGE.07 | 링칼라=트윈링제본(PROC_000021) **공정 param** | oracle: schema-intent §3 #7(제본=공정)·bom.md §4. **트윈링 공정(PROC_000021)은 이미 적재됨** → 링은 그 공정의 param(링칼라 블랙). 자재행 잉여. 진원: v03 14시트 | ① PROC_000021 트윈링제본 행에 링칼라=블랙 param 부여(prcs_dtl_opt/ref_param_json) ② MAT_000253 자재 연결행은 논리삭제 제안(벽걸이/와이드만) | High | 교정직접(param)+컨펌 |
| **C-CAL-03** | 108/109 | 링 블랙 잉여 | **EXTRA** | 108/109에 MAT_000253 링 블랙 연결 | 탁상/미니는 **트윈링 제본 아님**(삼각대 거치) → 링 부착 자체가 오류 | oracle: bom.md §1/§2(탁상/미니=삼각대 거치, 트윈링 없음). 엑셀 캘린더가공=삼각대(그레이/블랙). 진원: v03 14시트가 링을 전 캘린더에 일괄 부착 | MAT_000253↔108/109 연결행 **논리삭제 제안**(use_yn=N). hard-delete 금지·provenance 보존 | Medium | 교정직접(논리삭제 제안)+컨펌 |
| **C-CAL-04** | 전 5상품 | plate 적재경로 | **MIS-LOADED**(경로) | output_paper_typ=.01/.03(값 정답) | 값 유지, **적재경로 정합화** | oracle: F-1. `load_rel_plate_sizes`(L338,346)는 전부 .03 기타 적재 → 라이브 .01은 현 코드 재현 불가(이전 plate 교정 c722c24). **재적재 시 .01→.03 퇴행 위험** | load_master `load_rel_plate_sizes`에 치수→계열 매핑(316x467→.01·330x660→.03) 추가 제안. 라이브 값은 정답이므로 **현 행 무수정**, 코드만 정합화 | Medium | ddl-proposer/load-execution(코드 정합)+컨펌 |
| **C-CAL-05** | 전 5상품 | 장수(낱장) | **MISSING** | page_rules 0·option 0 | 고객선택 옵션 + 가격공식(`option_groups`/options/items + 가격엔진) | oracle: **Q12 확정**·schema-intent §2.3(낱장 page_rule ✗). 진원: load_master에 CPQ option 로더 부재(RELATIONS L469-481). 장수 적재경로 자체 없음 | 장수 옵션그룹(SEL_TYPE.02 다중? 단일 택1) + 항목(4(8P)/8(16P)…) + 가격공식 바인딩. **page_rule에 넣지 말 것** | High | load-execution(round-6 L2)+컨펌(가격공식) |
| **C-CAL-06** | 전 5상품 | 캘린더가공 택일그룹 | **MISSING** | option_groups 0(processes만 적재) | GRP-CAL-가공(SEL_TYPE.01 단일·mand_yn=Y) 6멤버 택일 | oracle: round-12 §A C19·schema-intent §2.4(option_groups=excl 흡수)·07_domain §1 #5. excl_groups 테이블 부재(Phase11 삭제) | `t_prd_product_option_groups`(GRP-CAL-가공) + options(가공없음·우드거치·타공·트윈링…) + 가공별 추가가격(C20) | High | load-execution(round-6)+컨펌 |
| **C-CAL-07** | 108/109 | 삼각대거치 공정 | **MISSING** | proc=수축포장만(거치 없음) | 삼각대 거치 공정 + 삼각대컬러 param | oracle: bom.md §1(출력→재단→삼각대거치→포장). **삼각대거치 공정 마스터 부재**(SELECT 0행) | `t_proc_processes`에 "삼각대거치" 공정 mint(search-before-mint: 트윈링021/타공079/포장075/076 존재, 거치 없음) → product_processes 연결 | High | ddl-proposer(공정 mint)+컨펌 |
| **C-CAL-08** | 110/엽서·디자인 | 봉투 addon | **MISSING** | addons 0·캘린더봉투 template 0 | 캘린더봉투(PRD_000005)→addon(tmpl_cd)·★사이즈선택 캐스케이드 | oracle: round-12 §A C26·schema-intent §3 #8. **캘린더봉투 SKU template 부재**(templates에 PRD_000005 기준 0). load_master addon은 addon_prd_cd INSERT(L440)인데 현 스키마=tmpl_cd(F-3 drift) | ① 캘린더봉투 template(base_prd=PRD_000005) mint ② `t_prd_product_addons`(prd_cd·tmpl_cd) 연결 ③ ★사이즈선택 constraint_json | Medium | load-execution+ddl-proposer(template) |
| **C-CAL-09** | 110/엽서·디자인 | 우드거치대 | **MISSING** | 미적재 | **자재**(Q13: 가공컬럼에 있으나 자재) | oracle: **Q13 확정**·schema-intent §4.3.1. round-11 CL-2(OPTION vs TEMPLATE) 철회 → 자재 단일귀속 | 우드거치대 자재 search-before-mint(기존 MAT 재사용 우선) → `t_prd_product_materials`(엽서·디자인) 부속 슬롯 | Medium | load-execution+컨펌 |
| **C-DC-10** | 디자인 5 | editor_yn | **MISSING**(MISMATCH) | editor_yn=N | editor_yn=Y(디자인=에디터 surface·같은 prd_cd) | oracle: mapping-final §B B1·Q6(1상품+에디터 템플릿). 라이브가 캘린더(업로드) surface만 반영 | 5상품 editor_yn=Y로 UPDATE 제안(file_upload_yn=Y 유지·2채널) | Medium | 교정직접(UPDATE)+컨펌 |
| **C-DC-11** | 디자인 5 | 고정가 | **MISSING** | prices 0(전역) | 고정가형 직접단가(사이즈/페이지별 4000~24000) | oracle: **★Q15**·mapping-final §B.1·schema-intent §3.1(고정가형). 진원: 가격 미적재(가격 트랙 별도). round-14 Phase11=가격엔진 차원 변경 영향 | `t_prd_product_prices`(prd_cd·apply_ymd·price) 고정가 적재. 디자인캘린더 가격=고정가형(캘린더=공식엔진과 대비) | High | load-execution(round-2 가격)+컨펌 |
| **C-DC-12** | 디자인 5 | 종이 명시 | **AMBIGUOUS** | 캘린더판 `*별도설정`(IMPORT 포인터) | 디자인판은 `몽블랑 190g` 명시(확정 종이) | oracle: design-l1 R3(몽블랑190g)·캘린더-l1 O(*별도설정). 같은 상품의 두 surface가 종이 확정도 다름 — 어느 것이 자재 권위? | 디자인 surface 명시 종이(몽블랑190g)를 자재 권위로 쓸지, 업로드판 `*별도설정`(종이군 선택) 유지할지 컨펌 | Low | 컨펌 |
| **C-CAL-13** | 전 5상품 | MES_ITEM_CD | **MISSING** | NULL | 007-0001~5 | oracle: 엑셀 C3·product-master L333-337. load_master L261 None 하드코딩(중복 UNIQUE 회피). 캘린더는 5상품 1:1(중복 없음)→채울 수 있음 | 5상품 MES_ITEM_CD UPDATE 제안(007-0001~5). 중복 없음 입증 후 | Low | 교정직접(UPDATE)+컨펌 |
| **C-CAL-14** | 109 미니 | 카테고리 | **AMBIGUOUS** | CAT_000112(탁상형캘린더) | CAT_000113(미니탁상형캘린더 전용 노드 존재) | oracle: 엑셀 구분=`탁상형캘린더`(L1 row6)이나 마스터에 CAT_000113 전용 노드 존재·미연결. 엑셀 구분 따름 vs 전용 카테고리 | 미니를 CAT_000113로 재연결할지(전용 노드), CAT_000112 유지할지(엑셀 구분) 컨펌 | Low | 컨펌 |

---

## 2. CORRECT (의심 반증 포함 — 라이브 유지)

| ID | 상품 | 속성 | 분류 | 근거 |
|----|------|------|------|------|
| OK-1 | 전 5상품 | size 변형 커버리지 | CORRECT | 엽서 6/6 변형 정합. **round-12 D-1 "SIZ_000007 불일치" 오탐 반증**(엑셀 row16 실재) |
| OK-2 | 전 5상품 | 도수(print_options) | CORRECT | 단/양면·CLR_000005(4도)/CLR_000001(0도) 엑셀 정합. 별색 없음(OM-5 무관) |
| OK-3 | 전 5상품 | plate 값(국전/기타) | CORRECT | 316x467=.01 국전계열·304x629=.03 기타 = 도메인 정답(경로는 F-1로 별도) |
| OK-4 | 전 5상품 | 카테고리 고아 | CORRECT | **고아 0**(디지털 043~046→CAT_000296 같은 문제 없음). 전부 lvl2 정상 노드 |
| OK-5 | 전 5상품 | prd_typ_cd | CORRECT | PRD_TYPE.04 디자인상품 = 정체(디자인 제공·에디터) 정합 |
| OK-6 | 디자인 | 같은 상품 surface | CORRECT | 디자인캘린더=별 상품 아님(같은 PRD_000108~112). CL-1 해소 재확인 |
| OK-7 | 111/112 | 트윈링/타공 공정 | CORRECT | PROC_000021 트윈링·PROC_000079 타공 = bom.md 정합(자재 링 문제는 C-CAL-02 별도) |

---

## 3. 잔존 컨펌 (인간 결정 대기)

| 컨펌 ID | 질문 | 관련 manifest |
|---------|------|---------------|
| **CL-A** | 삼각대 거치를 신규 공정으로 mint할까요(현 자재 MAT_000252/254 논리삭제), 아니면 부속 자재 유지할까요? (Q5 시트별 귀속·schema-intent §3 #6 충돌) | C-CAL-01·07 |
| **CL-B** | 트윈링 링(MAT_000253)을 공정 param으로 옮기고 자재행 논리삭제할까요? 탁상/미니의 링 부착(EXTRA)은 논리삭제 확정인가요? | C-CAL-02·03 |
| **CL-C** | plate output_paper_typ .01 적재경로 정합화 — load_master에 치수→계열 매핑 추가(재적재 퇴행 방지)에 동의하시나요? | C-CAL-04 |
| **CL-D** | 장수(C17)를 CPQ 옵션그룹(SEL_TYPE)으로 적재 — 택1(단일)인가요 자유선택인가요? 가격공식 바인딩은 round-2 디지털 가격엔진과 어떻게 합산? | C-CAL-05 |
| **CL-E** | 디자인캘린더 종이 권위 — 명시 `몽블랑190g`(디자인판) vs `*별도설정`(업로드판), 같은 상품의 자재 권위는? | C-DC-12 |
| **CL-F** | 미니탁상(109) 카테고리 — CAT_000113(전용 노드) 재연결 vs CAT_000112(엑셀 구분) 유지? | C-CAL-14 |
| **CL-G** | MES_ITEM_CD 5상품 채움(007-0001~5) — 중복 없으니 UPDATE 진행? | C-CAL-13 |

---

## K5/K6 게이트 자기점검

- **비파괴 [HARD]:** 전 교정=제안(COMMIT/DDL/DELETE 0). EXTRA(C-CAL-03)=논리삭제 제안(use_yn/del_yn·hard-delete 금지). MISSING=적재본 제안.
- **search-before-mint:** 삼각대거치 공정(C-CAL-07)·우드거치대 자재(C-CAL-09)·캘린더봉투 template(C-CAL-08) 모두 기존 행 재사용 우선 검사 후 mint(삼각대거치=마스터 부재 입증·우드거치대=기존 MAT 재사용 우선).
- **오모델 정합(K6):** C-CAL-01/02(부속=공정 not 자재)=schema-intent §3 #6/#7 정합·OM-4/5류(자재 오염). C-CAL-05(장수≠page_rule)=schema-intent OM 정합·Q12. C-DC-11(고정가형)=§3.1 정합. 색≠siz·size↔option 경계 위반 없음.
- **oracle 인용 실재(K2):** 각 why가 엑셀 L1 셀·Q번호·schema-intent §·load_master file:line 인용. F-1(plate 코드)·F-2(자재 전파) 적재로직 원인 재구성 또는 "적재경로 불명" 정직 표기(K3).
