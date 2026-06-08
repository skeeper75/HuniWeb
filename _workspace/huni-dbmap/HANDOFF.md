# Huni-DBMap — HANDOFF (다음 세션 재시작 포인터)

> 작성 2026-06-08(최신). 권위 = 본 문서 + 메모리 `dbmap-l2-requires-l1-price-table`·`dbmap-live-admin-product-viewer`·`dbmap-cpq-option-layer-mapping`·`dbmap-silsa-price-via-poster-sign`. 본 문서 + 메모리를 읽으면 재발견 0으로 재개. 이전 트랙(round-2 가격·round-4/5 적재·plate·디지털인쇄·CPQ 초기) 상세는 `CHANGELOG.md`·메모리에 보존.

## 한 줄 현황
**round-6 일반현수막(PRD_000138) 가격표 권위 재정합 완료(검증 GO).** 라이브 admin product-viewer 실접속으로 t_* 엔티티 역할을 UI ground-truth로 고정하고, **silsa 옵션 레이어가 인쇄상품 가격표(포스터/사인 B26)를 미대조해 사이즈를 비치수 연속범위로 오판·옵션 추가가격을 누락**한 근본 결함을 발견·재정합. 사이즈=이산 5×16 면적매트릭스, 옵션=추가가격 보유(가격트랙 분리), 제약 재작성. DB 미적재(실 적재·siz등록·코드행·DDL=인간 승인).

## 이번 세션 핵심 결정·발견 (재논의 금지)
- **라이브 admin product-viewer = t_* 역할 ground-truth** — 12 편집탭=12 t_prd_product_* 테이블, 제약 var 7키(siz_cd·opt_id·mat_cd__usage_cd 등). **L2(옵션/제약/SKU) 전 상품 미적재** = cpq-schema "13행 적재"는 stale로 정정(admin+psql count 이중확증). ref_param_json 부재·constraints.logic NOT NULL·templates=t_prd_templates 직접확증. 권위=`10_configurator/live-admin-groundtruth.md`.
- **가격표 권위 누락 = silsa 근본결함** — 일반현수막 사이즈/옵션가/제약 권위는 상품마스터-실사 시트가 아니라 **포스터/사인 가격표 B26**. 사이즈=이산 5×16 매트릭스(가로{900,1000,1200,1500,1750}×세로 16규격{900~5000}), 가공/추가 옵션=추가가격 보유. 권위=`10_configurator/silsa-price-table-gap.md`. → 메모리 `dbmap-l2-requires-l1-price-table`(L2는 L1 가격표 필수 대조).
- **사용자 확정 4건(HARD)** — off-grid=가로·세로 각각 한 단계 큰 규격 ceiling(앱) / 가로하한 900(500~900 주문불가) / 각목 900기준=세로(높이)변 / sel_typ 단일·다중이 컨피규레이터 존재이유.
- **재정합 결과(검증 GO 조건부)** — A 가격엔진 `PRF_BANNER_NORMAL`(즉시 26행) + B 옵션 레이어(즉시 22행). R-SIZE-NONSPEC·products nonspec 컬럼 폐기, R-GAKMOK=각목↔세로변900 재작성. F-1(R-GAKMOK "폼빌더 표현가능" over-claim)→정정(jsonb저장가능·폼빌더 배열입력 미검증 GAP-DEFER). 엽서 파일럿은 동형결함 없음(디지털인쇄 inline 정합).
- **작업 방식 교훈(메모리화)** — ① L2 설계는 L1 가격표 필수 대조 ② 애매분은 인쇄 도메인지식+경쟁사 벤치마킹/리서치로 자가확보 후 질의(추측 금지). 검증이 over-claim을 적발해 재확인.

## 다음 시작점 (정확한 다음 행동 — 택1)
1. **[실 적재 — 인간 승인] 일반현수막 CPQ+가격 적재** — GO 적재본 A 26행(`02_mapping/silsa-price-engine/load/`)+B 22행(`10_configurator/load_silsa/`). 선행: ① siz 76규격 등록(SIZ_000538~618, 가격트랙 채번) ② 각목 sub_prd_cd + sets 등록 ③ 열재단 PROC_000084 신설 ④ R-GAKMOK 폼빌더 입력방식 확정 ⑤ sel_typ 복수가공 `[CONFIRM-MULTI]` 확정. dbm-load-builder로 멱등 적재본 조립 후 인간 승인.
2. **[권장·확장] 다른 상품군 동일 방법(가격표 대조) 적용** — silsa에서 확립한 "L2는 L1 가격표 필수 대조" 방법으로 아크릴/포스터사인 나머지 상품·책자(excl_group 마이그 GAP-2)·캘린더로 확장. 각 상품군 가격표(`06_extract/price-*.csv`) 먼저 식별·대조.
3. **[GAP 닫기] dbm-ddl-proposer** — `cpq-option-gaps.md` + 신규: GAP-PARAM(ref_param_json — 타공 구수·각목 규격, `11_ddl_proposals/ref-param-json-proposal` 초안 있음)·GAP-SIZ-REG(siz 76규격)·GAP-BOARD. search-before-mint 제안서.

## 미해결 / 블로커
- **일반현수막 적재 선행 5건(인간 승인)** — siz 76규격 등록·각목 sub_prd_cd+sets·열재단 PROC_000084 신설·R-GAKMOK 폼빌더 입력방식(배열 1행 vs 75 단일행)·sel_typ 복수가공 [CONFIRM-MULTI].
- **CPQ/가격 적재 = 인간 승인 대기** — 모든 옵션 레이어·가격 INSERT·차원행 선적재·코드행·DDL은 인간 승인(설계·검증 문서까지만).
- **R-GAKMOK 폼빌더 입력 미검증(F-1)** — DB jsonb(logic) 저장 가능하나 라이브 admin 폼빌더의 배열-멤버십(in+75 siz_cd) 입력 지원 미검증. 적재 시점 라이브 폼빌더 직접 확인 필요.
- **이전 트랙 잔존**(CHANGELOG): 디지털인쇄 잔존 차단(3절/투명/박/048/019·030·049 plate교정)·excl_group 마이그(GAP-2)·미해결 설계결정(잉크색·머그용량·면지/바인더링·보드종류).

## 건드리지 말 것 (확정·검증 완료)
- `10_configurator/live-admin-groundtruth.md` — 라이브 admin 실측 ground-truth(t_* 역할·var 7키·L2 미적재).
- `10_configurator/silsa-price-table-gap.md` — 가격표 B26 실측 권위.
- `04_audit/banner-domain-competitor-research.md` — 도메인+경쟁사 리서치(A~D 자가확보).
- `10_configurator/silsa-option-layer.md` §5 재정합(2026-06-08-B) — 검증 GO, F-1~3 정정 완료.
- `02_mapping/silsa-price-engine/` — A 가격엔진 GO.
- 검증 GO 게이트: `03_validation/silsa-price-option-reconcile-gate.md`·`cpq-option-validation-silsa-live.md`·`silsa-design-conformance-audit.md`·`pilot-pricetable-recheck.md`.
- 이전 GO·라이브 COMMIT분(디지털인쇄 308행·상품마스터·가격 등 CHANGELOG 보존).
