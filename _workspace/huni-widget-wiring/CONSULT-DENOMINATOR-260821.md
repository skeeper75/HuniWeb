# 분모 전략 전문가 컨설트 (260821 · 카드 t1 선행 입력)

프로젝트: 위젯↔가격공식↔가격구성요소 배선 전면 진단·개선 (칸반 카드 t1, Class C)
결론: 새 전수 분석 불필요. 4수 전략으로 라이브 활성 266개 전 분모 토큰0 완주.

## ① 재사용 자산
- `_workspace/_foundation/batch/wiring_scan.py` — formula_components 배선 4결함(ORPHAN·DEAD_WIRE·DELETED_WIRE·NO_FORMULA) 전수, 토큰0. 가격 레이어만. 출력 batch/wiring/wiring-status.json
- `_workspace/_foundation/hdx/` — 9 Diagnoser 통합 배치(P1~P5 완료): wiring_dx·linkage_dx(E1~E4 양방향)·dim_conformance_dx·option_cpq_dx(옵션 dtl_opt→dim_vals param 단절=저청구)·qty_rule_dx·platesize_dx·price_grid_dx·calcability_dx·component_merge_dx·contribution_dx·registration_dx. foundation에 Snapshot/db/engine(pricing.py match_component verbatim)/Defect 공통 스키마.
- `_workspace/huni-webadmin-load/batch-scan/` — 전상품 배치스캐너(위젯 화면 드리프트), products.json 260개.
- `_workspace/_foundation/live-snapshot/latest/` — 전 t_* CSV 스냅샷(입력 자산·현재 stale).

## ② 미커버 배선 엣지 (신규 커버 대상 = 위젯 레이어)
1. 옵션 계층 무결성: product→option_groups→options→option_items 고아/빈그룹/dangling
2. ref_dim_cd polymorphic 해소 전수(옵션→차원행 실재; fn_chk_opt_item_ref 배치판)
3. 옵션선택→단가행 도달성 종단(선택 가능하지만 가격 0 조합 적발)
4. constraints(JSONLogic)↔옵션 코드 dangling
- E1(상품→공식 바인딩)·E2(공식→구성요소)는 기존 커버 — 신규 불필요.

## ③ 권장 전략 (4수)
1. 스냅샷 갱신(live-snapshot 재추출) — 필수 선행
2. hdx 통합 배치 as-is 재실행(가격 레이어 전수)
3. 신규 `widget_wiring_dx` 1개 작성(hdx Diagnoser 계약·foundation.Snapshot/Defect 재사용·~200줄·CSV 조인만·LLM 불개입) — 위 ②-1~4 커버
4. 상품별 wiring-health JSON 조립(기존 wiring-status.json+hdx Defect 보드 머지) → 인터랙티브 아티팩트 입력

## 산출 스키마(상품별)
{"prd_cd","prd_nm","layers":{"widget":{groups,options,items,defects[{edge:"OPT_REF_DANGLING",ref}]},"binding":{formulas,defects},"formula":{components,defects[{edge:"ORPHAN",comp_cd}]},"price":{price_rows,reachable_ratio,defects[{edge:"OPT_NO_PRICE_ROW"}]}},"verdict":"OK|BROKEN|WARN","broken_edges":["E4","W2"]}

## ④ 분모
- 라이브 실측: t_prd_products del_yn='N' AND use_yn='Y' = 266개 (260821)
- 스냅샷/products.json = 260개(stale·6개 증가) → 재스캔 전 갱신 필수
