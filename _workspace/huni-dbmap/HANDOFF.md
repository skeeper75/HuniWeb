# Huni-DBMap — HANDOFF (다음 세션 재시작 포인터)

> 작성 2026-06-08(최신). 권위 = 본 문서 + `docs/goal-2026-06-08-01.md`(round-7) + 메모리 `dbmap-admin-ui-spec`·`dbmap-coverage-matrix-roundup`·`dbmap-live-admin-product-viewer`·`dbmap-l2-requires-l1-price-table`·`dbmap-option-material-process-bundle`. 본 문서 + 메모리를 읽으면 재발견 0으로 재개. 이전 트랙(round-2 가격·round-4/5 적재·plate·디지털인쇄·CPQ·round-6 현수막·round-7 커버리지) 상세는 `CHANGELOG.md`·메모리에 보존.

## 한 줄 현황
**round-8 admin UI 입력 명세 완료 — 독립 검증 GO(누락 0).** 라이브 admin product-viewer를 `gstack live`로 전수 분석, **34 t_* 엔티티 332컬럼의 모든 항목**을 {UI라벨·컬럼·위젯·필수·타입제약·코드값도메인·미적재입력법·입력화면}으로 정의(`13_admin-ui-spec/`). round-7 미적재 갭(CPQ 옵션·가격사슬·차원 PARTIAL)을 admin 입력 경로(FK 위상순서)로 환원. 사용자 directive("각 페이지 모든 항목 정의, 하나도 빠짐없이") 충족. **DB 미적재 — 명세/입력경로까지, 실 입력은 인간 승인.**

## 이번 세션 핵심 결정·발견 (재논의 금지)
- **[정정·사용자] 분석 대상 = admin product-viewer** (고객 사이트 www.huniprinting.com·IA.xlsx 배제). admin이 t_* 역할 UI ground-truth이자 데이터 넣는 화면이므로 각 필드 정의 = 미적재 해소 직접 명세.
- **[구조] 입력 화면 2종**: ① catalog Django admin change form(14모델 직접등록, 필드 전수 노출, `_raw/forms/*.json` 덤프) ② product-viewer pvEdit() 섹션(상품별 하위 12엔티티, headless 미재현 → table-spec 컬럼+표시구조로 정의).
- **[권위 교정] 컬럼 권위 = 라이브 `information_schema`** (table-spec_260608.html은 보조). table-spec에 `tags` jsonb 미기재 → 1차 명세가 침묵 누락 → 독립검증이 적발(NO-GO)→보정. **교훈: 명세 컬럼은 반드시 information_schema 교차확인.**
- **[검증] 독립 게이트 G1~G7 GO** — evaluator-active가 information_schema로 34엔티티 컬럼수 독립 재집계, 332컬럼 누락 0 확인. tags 2건 적발→보정→재판정 GO.
- **[미적재 채움 경로] FK 위상순서**: 마스터 코드 先 → 상품 → 차원행 → 가격(공식→구성요소→단가→바인딩) → CPQ(옵션그룹→옵션→옵션항목 polymorphic→제약→템플릿).

## 다음 시작점 (정확한 다음 행동 — 택1, 모두 인간 승인 적재)
1. **[최상위] CPQ 옵션 레이어 실 입력** — round-8 명세(B-cpq.md §3-2)대로 현수막 "각목추가" 그룹의 option_items 0행을 polymorphic ref_dim_cd+ref_key로 채워 CPQ 사슬 완결. admin product-viewer 옵션 섹션. 실 COMMIT = 인간 승인.
2. **[GAP-PARAM] DDL 제안** — `t_prd_product_option_items.ref_param_json` 부재(파라미터형 옵션 슬롯 없음) → `dbm-ddl-proposer` ALTER 제안(인간 승인).
3. **[가격 사슬] 미적재 6 상품군** — C-core-price.md §④(가) 입력순서대로 가격공식→구성요소→단가→바인딩. dbm-price-formula.
4. **[DOMAIN 결정] 기성품 사이즈** — 굿즈/악세사리 사이즈=차원행 vs 텍스트(머그컵 admin size 0). 사용자 결정 후 입력.
5. **[이월] round-6 일반현수막 실 적재** — siz 77·자재 mint·열재단 PROC·실 COMMIT(인간 승인). CHANGELOG 참조.

## 미해결 / 블로커
- **round-8은 명세/입력경로 전용 — 실제 데이터 입력(COMMIT) 없음**(인간 승인). admin product-viewer pvEdit() 팝업은 headless 미재현(필드는 table-spec+표시구조로 정의, 실제 입력 위젯 정밀화는 GAP).
- **GAP-PARAM**: option_items에 ref_param_json 부재 → 파라미터형 옵션은 opt_nm 텍스트로만 구분. ALTER 필요 시 인간 승인.
- **DB-ONLY 17셀 판별**(round-7): plate/discount/material 외부권위 vs 과적재 미판별.
- **이전 트랙 잔존**(CHANGELOG): 디지털인쇄 잔존 차단(3절/투명/박/048 등)·excl_group 마이그·설계결정 미정.

## 건드리지 말 것 (확정·검증 완료)
- `_workspace/huni-dbmap/13_admin-ui-spec/` — round-8 admin UI 명세(GO). admin-ui-spec.md(마스터)·entities/{A-dimensions,B-cpq,C-core-price}.md·_raw/(원천 덤프).
- `_workspace/huni-dbmap/03_validation/admin-ui-spec-gate.md` — 독립 검증 게이트(GO). 이번 세션 작성.
- `_workspace/huni-dbmap/12_coverage/` + `03_validation/coverage-matrix-gate.md` — round-7 커버리지(GO).
- `.env.local` `HUNI_ADMIN_*` — admin 자격증명(chmod 600·gitignored).
- 이전 GO·라이브 COMMIT분(CHANGELOG 보존).
