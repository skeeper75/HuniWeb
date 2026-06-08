# 후니 admin product-viewer — UI/UX 데이터 입력 정밀 명세 (round-8)

> 작성 2026-06-08. 목적: 라이브 admin(`huni-admin-production.up.railway.app/admin/`)의 **모든 화면·모든 항목**을
> 빠짐없이 정의해, round-7이 입체 조망으로 발견한 **미적재 매핑 데이터**를 사람이 admin에 직접 넣을 수 있게 한다.
> 사용자 directive: "각 페이지의 모든 항목들에 대해서 정의가 있어야 한다 — 하나의 메뉴·항목도 지나치지 않도록."
> 권위: `docs/huni/table-spec_260608.html`(t_* 컬럼 스펙) + `docs/huni/2026-06-05-product-configurator-design.md`(CPQ 설계)
> + 라이브 DB(읽기전용 psql 코드값) + 라이브 admin UI(gstack live 실측) + round-7 `12_coverage/`(미적재 갭).

## 1. 분석 대상 = admin (고객 사이트 아님)

분석 대상은 **admin product-viewer** — round-7에서 "12 편집탭 = 12 `t_prd_product_*`"로 입증된 **t_* 엔티티의 역할 UI
ground-truth**다. 고객 사이트(www.huniprinting.com)와 IA.xlsx는 본 명세 범위 밖(사용자 확정). admin이 곧 데이터를
넣는 화면이므로, admin 각 필드의 정의가 미적재 해소의 직접 명세가 된다.

진입: `gstack live` 로그인 성공(`.env.local` `HUNI_ADMIN_*`). 상품 편집 URL = `/admin/product-viewer/<prd_cd>/`.

## 2. 입력 화면 2종 (전수 구조)

| 종류 | 경로 | 입력 방식 | 대상 엔티티 |
|------|------|----------|------------|
| **catalog change form** (Django admin) | `/admin/catalog/<model>/add\|change/` | 표준 폼(input/select), 필드 전수 노출 | 마스터(자재·사이즈·도수·공정·코드·카테고리·고객) + 상품·템플릿·가격공식/구성요소/단가·할인테이블·페이지룰 (14모델) |
| **product-viewer 섹션** | `/admin/product-viewer/<prd_cd>/` → 섹션별 "편집" | `pvEdit(prd_cd, section)` JS 팝업 (headless 미재현 — 필드는 표시컬럼+table-spec로 정의) | 상품별 하위 차원 12섹션: 사이즈·도수/인쇄옵션·판형·자재·공정·묶음수·추가상품·페이지룰·옵션그룹·옵션·제약·구성템플릿 |

> catalog 직접등록 14모델은 `_raw/forms/<model>.json`에 필드+위젯+select옵션 전수 덤프됨.
> product-viewer 하위 엔티티는 catalog 미등록(pvEdit 전용) → table-spec 컬럼 + 표시구조(엽서 PRD_000016·현수막 PRD_000138)로 정의.

## 3. 화면 인벤토리 (34 t_* 엔티티 — 닫힌 집합, 누락 0 기준)

| 군 | 문서 | 엔티티(화면) 수 | 범위 |
|----|------|:--:|------|
| **A 차원/구조** | [entities/A-dimensions.md](entities/A-dimensions.md) | 12 | 마스터 4(자재·사이즈·도수·공정) + product-viewer 8(사이즈·자재·인쇄옵션·공정·판형·묶음수·페이지룰·셋트) |
| **B CPQ 옵션** | [entities/B-cpq.md](entities/B-cpq.md) | 7 | 옵션그룹·옵션·옵션항목·제약·추가상품 + 템플릿·템플릿선택값 (round-7 최대 갭) |
| **C 코어/가격/할인** | [entities/C-core-price.md](entities/C-core-price.md) | 15 | 상품·카테고리(2)·기초코드·고객 + 가격사슬 6(공식·구성요소·공식별구성요소·단가·상품바인딩·상품단가) + 할인 4 |

각 엔티티 문서는 화면별로 **모든 컬럼을 1행씩** 정의: `UI 라벨 | 컬럼 | 위젯 | 필수 | 타입/제약(table-spec) | 코드값 도메인(라이브 DB) | 미적재 시 입력법 | 입력 화면`. 각 문서 말미 "누락 점검"표(table-spec 컬럼수 = 명세 행수)로 누락 0 자기검증.

## 4. 미적재 매핑 데이터 채움 통합 가이드 (round-7 갭 → admin 입력 경로)

round-7 갭보드의 미적재를 admin 화면 입력으로 환원한다(실 COMMIT은 인간 승인).

| round-7 갭 | 규모 | admin 입력 경로 | 상세 |
|-----------|------|----------------|------|
| **CPQ 옵션 레이어 전면 미적재** (option_items 전역 0행) | ~28 | product-viewer 옵션그룹→옵션→옵션항목 섹션 (polymorphic ref_dim_cd+ref_key) | B-cpq §3-2 (현수막 "각목추가" 사슬 완결 예시) |
| **가격 사슬 6 상품군 미적재** | ~12 | catalog 가격공식→가격구성요소→구성요소단가 + product-viewer 공식바인딩 | C-core-price §④(가) 입력 순서 |
| **차원 PARTIAL** (processes/print_options/sizes) | ~20 | product-viewer 해당 섹션 행 추가 (FK=마스터 코드 선등록) | A-dimensions 각 섹션 미적재 입력법 |
| **DOMAIN-UNDECIDED** (기성품 사이즈) | 2 | 결정 후 product-viewer 사이즈 섹션 or 텍스트 | A-dimensions §사이즈 + 사용자 [CONFIRM] |
| **DB-ONLY 17셀** (외부권위 vs 과적재) | 17 | 입력 아님 — 판별(plate/discount/material 권위 컬럼 확인) | C-core-price §④(나) |

## 5. FK 입력 순서 (위상정렬 — 미적재 채울 때 반드시 준수)

1. **마스터 코드 先**: 기초코드(t_cod_base_codes) → 자재·사이즈·도수·공정 마스터 (없으면 차원행 입력 불가).
2. **상품 존재**: t_prd_products (모든 product-viewer 섹션의 부모).
3. **차원행**: product-viewer 사이즈/자재/인쇄옵션/공정/판형/묶음수/페이지룰/셋트.
4. **가격**: 가격공식 → 공식별구성요소 → 구성요소단가 → 상품 공식바인딩.
5. **CPQ(L2)**: 차원행 참조 가능해진 뒤 옵션그룹 → 옵션 → 옵션항목(polymorphic) → 제약 → 템플릿.

## 6. GAP 종합 (발명 금지 — 명세에 GAP으로 표기, 인간 승인/DDL 라우팅)

- **GAP-PARAM**: `t_prd_product_option_items`에 `ref_param_json` 컬럼 부재(table-spec 12컬럼 확인). 파라미터형 옵션(각목 세로/가로폭 등 기준축 메타) 슬롯 없음 → `opt_nm` 텍스트로만 구분. ALTER 제안 대상(`dbm-ddl-proposer`, 인간 승인).
- **DOMAIN-UNDECIDED**: 기성품(굿즈/악세사리) 사이즈 = 차원행(t_prd_product_sizes) vs 텍스트 표기 — 사용자 결정 후 입력.
- **DB-ONLY 판별 미완**: plate_sizes·discount_tables·materials 외부권위(판걸이수·구간할인) 정당 vs 과적재 — 권위 컬럼 대조 필요(입력 아님).
- 상세 GAP 목록은 각 엔티티 문서 GAP 섹션.

## 7. 원천·재현

- admin 원천 덤프: `_raw/forms/<model>.json`(catalog 14모델 필드+위젯+select옵션) · `_raw/PRD_000016_text.txt`(엽서)·`PRD_000138_text.txt`(현수막) product-viewer 섹션 표시구조.
- 재현: `gstack live` 로그인(`.env.local` HUNI_ADMIN_*) → catalog add 폼 / product-viewer 상품 → table-spec 컬럼 대조 → 라이브 DB 코드값 psql.
- 검증: `03_validation/admin-ui-spec-gate.md`(누락 0 독립 게이트).

## 8. 경계 (NOT in scope)

- **실제 데이터 입력(COMMIT) 없음** — 본 명세는 정의/입력경로까지. 미적재 실 입력은 인간 승인(round-7·기존 원칙).
- 고객 사이트(www.huniprinting.com)·IA.xlsx 배제(사용자 확정 — admin이 ground-truth).
- 신규 DDL 적용 없음 — GAP은 `dbm-ddl-proposer` 라우팅(제안까지).
