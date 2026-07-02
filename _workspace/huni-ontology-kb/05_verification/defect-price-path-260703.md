# 결함 보드 — 가격경로 연결 완전성 + 라이브 실재 대조 (검증 라운드 1)

> 대상: 03_kb v(빌드 20260703·노드204/엣지420) · 원천: live-snapshot/latest(snap_20260702_1119) · 작성: 2026-07-03
> 배정 축: ① 8상품 가격경로 그래프 탐색 ② priced_by·has_component·option_refs 라이브 전수 대조 ③ 8상품 밖 참조 dead-link ④ GAP 15 반증
> 재현 스크립트: `05_verification/scripts/{price_path_traverse,wiring_vs_live,option_refs_and_extras,product_axis_vs_live}.py` (전부 재실행 가능)
> ★생성자(builder)·빌드 리포트 비신뢰 — 전부 직접 재실측.

## 반증 실패 = 생존(통과) 항목

- **priced_by 9쌍 전수 라이브 일치** — KB(prd→frm) ↔ t_prd_product_price_formulas: KB-only 0·LIVE-only 0. 8상품 모두 가격공식 배선 존재(027=2공식).
- **has_component 10공식 전수 일치** — KB(frm→comp) ↔ t_prc_formula_components: 10/10 공식 comp 집합 완전 일치. 인용 component 중 라이브 del_yn=Y/use_yn=N/부재 = 0.
- **option_refs 70건 전수 실재** — dst(material30/process29/print_option11) 전부 라이브(t_mat/t_proc/t_prt)에 실재. 부재 0.
- **8상품 밖 addon 참조 = dead-link 0** — addon 대상 봉투/기성 상품(PRD_000001/002/004/283) KB 노드 부재 + has_addon 엣지 0. 조용한 dead-link 없이 4 GAP(gap-016-addon-target·gap-024-addon-envelope·gap-027-addon-envelope·GAP_envelope_set_model)로 정직 선언.
- **043 option_group 0 = 라이브 일치** — PRD_000043 라이브 option_group 0건. KB의 has_option_group=0은 조용한 누락 아님.
- **GAP 정직성** — GAP_043_perf(PRF_DGP_C에 타공/접지비 있으나 043은 base공정만→조건부 미발현) 실재 확인. 멱등성 자체검사(build --idem) 해시 2회 동일 = TRUE.

## 결함

| ID | 노드/엣지 | 축 | 결함 | 심각도 | 라우팅 |
|----|-----------|-----|------|--------|--------|
| V1-01 | product-016 has_process / gap-016-process-nodes | ⑤연결완전성·⑥반증(이력) | 016 라이브 활성공정 7 중 4(027/028/031/032) has_process 미배선. gap이 선언은 하나 사유("4공정 미민팅→배선불가")가 사실과 다름 — 4공정 모두 이미 민팅+타상품 배선됨 | Medium | builder(+gap 사유 curator) |
| V1-02 | product-041 has_process→process-PROC_000085 | ②권위정합·③오염(환각관계) | 라이브 PRD_000041 t_prd_product_processes = 004/029/030/031/032. KB는 라이브에 없는 PROC_000085를 배선(자식 031/032를 부모로 접음). 문서화된 의도이나 사유("031/032 미등재")가 stale=둘 다 민팅됨 | Medium | builder(+anchor검사 architect) |
| V1-03 | product-016 uses_material / optgroup-016-paper | ⑤연결완전성 | 라이브 016 활성자재 21 vs 그래프 배선 4(uses_material 4+option_refs 동일 4종). 17자재 그래프 미배선(7은 노드 존재·미연결/10 미민팅). 본문 BOM표에 21종 전사·"대표" 주석 disclose하나 형식 GAP 노드 없음 → 그래프 탐색 시 17종 조용한 누락. 형제상품(027 14/14·033 5/5)은 전수 | Medium | builder/architect |
| V1-04 | 04_graph/edges.jsonl · build-report | ④그래프무결성 | 리포트 "엣지 425" ≠ 실제 그래프 420. edges.jsonl에 중복 5행(src,rel,dst)이 SQLite PK로 병합됨. 본문 [[ ]] 중복 등장이 원인. 하드실패 아니나 카운트 과대보고+jsonl 중복행 | Low | builder |
| V1-05 | 01_curation/pack-digital-print.md §193 | ①출처실재성·③오염(stale) | 팩이 016 봉투 addon을 TMPL-000005/006/009/**010/011**로 서술하나 라이브=005/006/009/**038/039**. gap-016-addon-target가 정확히 flag했으나 팩 원문 미교정(stale 잔재) | Low | curator |

## 증거(재현)

### V1-01
```
$ python3 05_verification/scripts/product_axis_vs_live.py   # PRD_000016
  has_process: DIFF KB=3 LIVE=7  라이브에만(미배선)=['PROC_000027','PROC_000028','PROC_000031','PROC_000032']
# 4공정 노드 실재+타상품 배선 확인:
process-PROC_000027 → has_process← 024/032/033, option_refs← optgroup-032-corner/033-corner/OPT_000020 (verified·민팅됨)
```
gap-016-process-nodes 원문: "…4공정이 공유 [[axis/processes]]에 미민팅 — has_process·option_refs 배선 불가" → **민팅 상태 사실과 불일치**.
교정: 016 has_process에 027/028/031/032 배선; gap 사유 갱신 또는 gap 해소.

### V1-02
```
라이브 t_prd_product_processes PRD_000041: PROC_000004(mand=Y),029,030,031,032   # 085 없음
KB product-041 has_process: PROC_000004,029,030,085                              # 031/032 없음, 085 있음
process-PROC_000085(가변데이타) 라이브 t_proc_processes 실재=True(anchor 통과) → 상품-공정 바인딩만 원천 미존재
```
product-041.md L64 문서: "…031/032는 공유 axis/processes.md 미등재…041은 부모 PROC_000085로 접어 연결" → 사유 stale(031/032 민팅 확인). anchor L-17은 전역 proc 존재만 검사(상품↔공정 바인딩 미검) → 검사 사각.
교정: 041 has_process→PROC_000031+PROC_000032(라이브 부합), PROC_000085 fold 제거 또는 부모접기 정책 명문화.

### V1-03
```
라이브 PRD_000016 t_prd_product_materials 활성 21행(전부 USAGE.07)
KB uses_material 4(MAT_000074/082/092/101) + optgroup-016-paper option_refs 동일 4
미배선 17 = MAT_000109/123/124/347~360 (그중 7 노드존재·미연결, 10 미민팅)
```
product-016.md L22 note "대표(활성 21종 중)"·L128 "uses_material은 공유 축 노드가 있는 4종" — disclose는 있으나 형식 GAP 노드 없음.
교정: 잔여 자재 노드 민팅+배선, 또는 GAP_016_material 신설(정직 선언). 파일럿 "대표만" 정책이면 위키계승 규칙에 그래프 완전성 기준 명문화.

### V1-04
```
$ python3 -c "중복 (src,rel,dst) 검출"
DUP x2: product-016 references DEC_qty_audit_260702
DUP x2: product-016 references gap-016-addon-target
DUP x2: product-016 references gap-016-process-nodes
DUP x2: product-033 references gap-033-vardata-param
DUP x2: product-043 references RULE_price_value_boundary
# edges.jsonl=425행 · graph.db edge=420 · 리포트=425
```
교정: add_edge 시 (src,rel,dst) dedup 또는 리포트에 unique 엣지수 표기.

### V1-05
```
pack-digital-print.md:193 "016 봉투 addon = TMPL-000005/006/009/010/011 5행 적재"
라이브 t_prd_product_addons PRD_000016: TMPL-000005/006/009/038/039
```
교정: 팩 §193 tmpl 코드 038/039로 갱신(gap-016-addon-target가 이미 지적).

## 검증 범위·한계(정직)

- **전수:** priced_by(9)·has_component(10공식)·option_refs(70)·8상품×4축(process/material/print_option/size) KB↔라이브 diff — 스크립트 전수.
- **표본/미확인:** ① evaluate_price 실호출 가격 오차 대조는 미수행(라이브 DB 미접속·이 라운드는 배선 실재까지). 실제 가격값 오차 0 여부는 별도 라운드 필요. ② has_size의 사이즈 차원값(가로/세로 수치)·단가행(component_prices 22,996행) 값 정합은 미대조(배선 존재만 확인). ③ option_group의 semantic 그룹(016/032/033/041/046)은 anchor가 product코드라 opt_grp_cd 코드 대조 불가 — 모델링 선택으로 두고 미판정. ④ 8상품 외 나머지 카탈로그·비디지털 시트 미검(파일럿 범위).
- 결함 0 아님 — "무결" 단정 불가. 위 5건 교정 후 재실측 필요(특히 V1-01/02/03은 그래프 탐색 답변 정확도 직접 영향).
