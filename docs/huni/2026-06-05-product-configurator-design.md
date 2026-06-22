# 상품 컨피규레이터(옵션·제약·추가상품 템플릿) 설계 — WIP

**상태:** ✅ 설계 합의 완료 — 사용자 리뷰 대기. 작성 2026-06-05.
**목표:** 현재 스키마(상품별 차원 나열)를 **상품 컨피규레이터(CPQ) 모델**로 확장 — 옵션/옵션그룹, 차원 간 제약조건, 구성형 추가상품 템플릿. 이후 GSD 새 Phase로 등록·플랜 → DDL 마이그레이션 + 관리자 UI 반영.

---

## 0. 시스템 경계 (확정)

- **이 시스템 = 상품·옵션 마스터 + 컨피규레이터 정의(+검증 규칙).**
- 주문/결제 = **POD 사이트**. 생산 = **MES**. POD ↔ MES 인터페이스(주문·상태·송장 등) 지속.
- **설계 제1원칙:** 화면에서 최종 선택된 구성은 반드시 **자재·공정으로 환원(resolve)** 되어 주문정보에 실려야 한다 → MES가 받아 생산. *모든 선택 가능한 옵션은 자재/공정으로 해석 가능해야 함.*
- **이번 범위 밖:** 주문 인스턴스 테이블, 가격 계산 엔진, 재고/BOM 차감 실행(consume 수량은 모델 여지만 남김).

## 1. 세 가지 축 (요구사항 요약)

**① 추가상품 = 구성형 템플릿**
- 단순 상품 링크(`t_prd_product_addons.addon_prd_cd`) ❌ → *상품 + 옵션(예: OPP봉투+사이즈+수량)* 을 박제한 "구성 템플릿"을 추가상품으로 등록.
- MES 전달 시 별도 주문상세번호 → 생산.
- 통찰: 이전 합의 **SKU(팔리는 조합=주문/재고 단위)** 개념과 동일선상.

**② 옵션 / 옵션그룹 (복합 옵션)** — 모델 1(하이브리드) 확정
- 타입별 차원 테이블(사이즈·묶음수·도수·자재·공정)은 그대로 + 그 위에 범용 **옵션·옵션그룹** 레이어.
- 옵션 = 이름 + 상품에 등록된 차원행(자재/공정/사이즈…)을 참조하는 묶음(단일/복합, 예 `끈2줄+끈가공`).
- 옵션그룹 = 옵션 모음 + 선택규칙(택1/택N/최대N) → **공정 택일그룹의 일반화**.
- 옵션 재료는 **그 상품에 등록된 차원 내에서만**.

**③ 차원 간 제약조건**
- 예: 사이즈 A↔셋트수 20만 / 자재 X↔공정 Y 금지.
- UI에서 설정 → **JSON 저장**(`t_prd_products.constraint_json` 기존 컬럼 활용 검토) → UI에서 선택 시 검증.

## 2. 결정 로그

- **2026-06-05** 시스템 경계 확정(위 §0). 주문=POD, 생산=MES.
- **2026-06-05** ② 옵션 모델 = **모델 1(하이브리드)** 확정 — 기존 차원 테이블 유지 + 범용 옵션 레이어 추가, 택일그룹 흡수/일반화.
- **2026-06-05** 옵션 구성요소 참조 = **폴리모픽**(ref_dim_cd+키슬롯)으로 변경(처음 타입형 FK 검토했으나, 참조 차원을 **카테고리 제외 전 차원**으로 넓혀 7종+이 되어 타입형은 비현실 → 폴리모픽 + 검증 트리거).
- **2026-06-05** ① 추가상품 = 재사용 구성 템플릿(=SKU) 카탈로그. ③ 제약 = JSONLogic 규칙 행 → 컴파일 단일 JSON.

## 3. 스키마 설계 (작성 중)

### ② 옵션 레이어 — 확정 (모델 1 + 타입형 FK)
상품별 3계층 신규 테이블 (공정 택일그룹의 일반화):

1. **`t_prd_product_option_groups`** (옵션그룹) — PK `(prd_cd, opt_grp_cd)`
   - `opt_grp_nm`, `sel_typ_cd`(기초코드 SEL_TYPE: 택1/택N), `min_sel_cnt`, `max_sel_cnt`, `mand_yn`, `disp_seq`
2. **`t_prd_product_options`** (옵션) — PK `(prd_cd, opt_cd)`
   - `opt_grp_cd`(소속 그룹 FK), `opt_nm`, `dflt_yn`, `disp_seq`, `use_yn`
3. **`t_prd_product_option_items`** (옵션 구성요소, 복합의 내부) — PK `(prd_cd, opt_cd, item_seq)`
   - **폴리모픽 참조** (참조 차원이 7종+로 넓어 타입형 FK 대신):
     - `ref_dim_cd` — 차원유형(기초코드 그룹, 가칭 OPT_REF_DIM): 사이즈/도수/판형/자재/공정/묶음수/셋트 (**카테고리만 제외, 나머지 상품 하위차원 전부**)
     - `ref_key1`, `ref_key2` (varchar) — 해당 차원행의 자연 하위키. 예) 사이즈→(siz_cd) / 자재→(mat_cd, usage_cd) / 공정→(proc_cd) / 묶음수→(bdl_qty) / 도수→(opt_id) / 판형→(siz_cd) / 셋트→(sub_prd_cd)
     - `qty`(수량/차감수량, 선택 — BOM 연계 여지)
   - **"그 상품에 등록된 차원행만"** = **검증 트리거**(ref_dim_cd별로 해당 상품 차원 테이블에 행 존재 확인) + 관리자/앱 검증. (DB FK는 폴리모픽이라 직접 불가 → 트리거로 대체. 이 프로젝트는 이미 트리거 사용 중)
   - 참고: 사이즈·판형이 둘 다 siz_cd라 ref_dim_cd로 구분됨 → 폴리모픽이 충돌 자연 흡수.

- **택일그룹 처리**: 기존 `t_prd_product_process_excl_groups`(공정 전용)는 이 일반 옵션그룹으로 **흡수/마이그레이션**(공정 옵션그룹으로 변환). [추후 마이그레이션 설계]
- **MES 환원**: 옵션 선택 → option_items의 자재/공정 행 → 주문정보 payload.

### ① 추가상품 템플릿 — 확정 (재사용 카탈로그 = SKU 통합)
- **`구성 템플릿`(신규, 가칭 t_prd_templates)** — `tmpl_cd` PK
  - `base_prd_cd`(FK→상품), `tmpl_nm`, `dflt_qty`, `use_yn`, `note`
  - = **SKU 후보** — 추가상품으로도, 향후 단독 판매로도 사용.
- **`템플릿 선택값`(신규, 가칭 t_prd_template_selections)** — `(tmpl_cd, seq)` PK
  - base 상품의 **옵션(opt_cd)** 또는 차원(siz_cd·bdl_qty…) 선택 + value/qty. (②·차원 재사용)
- **`t_prd_product_addons` 변경**: `addon_prd_cd` → **`tmpl_cd` 참조**(부모상품 → 구성 템플릿). [마이그레이션: 기존 addon_prd_cd를 base만 가진 템플릿으로 변환]
- MES: 템플릿 → 별도 주문상세번호 → 생산.

### ③ 제약조건 모델 — 확정 (JSONLogic + 규칙 행 → 컴파일 JSON)
- **대상 일반화**: 사이즈×셋트수 2축에 국한 ❌ → **임의 옵션/차원 조합 + 불리언 로직**(AND/OR/NOT, implies)으로 호환·금지·필수 표현.
- **표현식 언어 = JSONLogic 채택 방향** — 규칙이 순수 JSON, POD(JS: `json-logic-js`)·백엔드(Python: `json-logic-py`) **동일 평가**, 안전(부수효과 없음)·툴 친화. (대안: json-rules-engine=JS중심 풍부 / CEL=표현력↑·JS약함)
- **친화 작성 UI**: 호환표(매트릭스)·금지쌍·필수동반 같은 쉬운 편집기가 내부적으로 **JSONLogic을 생성**. (raw 빌더 아님)
- **저장 = A 확정**: 규칙 테이블 행 = {rule_nm, rule_typ, **logic jsonb(JSONLogic)**, err_msg, use_yn, disp_seq} → 관리자 행단위 CRUD/온오프 + **활성 규칙을 컴파일해 단일 JSON으로 POD에 제공**(`t_prd_products.constraint_json`을 컴파일 캐시로 활용 가능).
- **한계**: JSONLogic은 *검증*(이 조합 OK?)용. "선택 시 후보 자동 축소"는 후보값을 규칙으로 brute-force 필터(인쇄 옵션 공간이 작아 충분). 본격 제약전파(CSP)는 과함 → 제외.

### 신규/변경 테이블 요약 (가칭 — 최종 물리명은 naming-guide/Dictionary 확정)
| 테이블 | 역할 | 키 | 비고 |
|---|---|---|---|
| `t_prd_product_option_groups` | 옵션그룹 | (prd_cd, opt_grp_cd) | 신규. 택일그룹 일반화 |
| `t_prd_product_options` | 옵션 | (prd_cd, opt_cd) | 신규 |
| `t_prd_product_option_items` | 옵션 구성요소 | (prd_cd, opt_cd, item_seq) | 신규. 폴리모픽(ref_dim_cd+키슬롯)→차원행, 검증 트리거 |
| `t_prd_templates` | 구성 템플릿(=SKU) | tmpl_cd | 신규. base_prd_cd |
| `t_prd_template_selections` | 템플릿 선택값 | (tmpl_cd, seq) | 신규. 옵션/차원 참조 |
| `t_prd_product_constraints` | 제약 규칙 | (prd_cd, rule_cd) | 신규. logic jsonb(JSONLogic) |
| `t_prd_product_addons` | 추가상품 | (prd_cd, tmpl_cd) | **변경**: addon_prd_cd→tmpl_cd |
| `t_prd_product_process_excl_groups` | 공정 택일그룹 | - | **흡수/마이그레이션** → option_groups (플랜에서 상세) |
| `t_prd_products.constraint_json` | 컴파일된 제약 JSON 캐시 | - | 기존 컬럼 재활용 |

## 4. 관리자 UI 반영
- **옵션그룹/옵션/구성요소**: 상품 뷰어 섹션에 "옵션" 섹션 추가 — 그룹 CRUD(택1/택N/최대N) → 옵션 CRUD → 구성요소(자재/공정/사이즈를 그 상품 등록분에서 선택). 기존 섹션 팝업 패턴 재사용.
- **구성 템플릿(SKU)**: 별도 관리 화면(카탈로그) — base 상품 선택 → 옵션/차원 선택값 구성 → 저장. 추가상품 섹션에선 이 템플릿을 select2로 연결.
- **제약 규칙 빌더**: 상품별 제약 섹션 — 친화 편집기(호환표 매트릭스 / 금지쌍 / 필수동반)가 내부적으로 JSONLogic 생성. 규칙 행 CRUD·on/off. "저장 시 활성 규칙 컴파일→constraint_json".
- **검증 미리보기**(선택): 관리자에서 샘플 선택으로 규칙이 잘 막는지 테스트.

## 5. 마이그레이션 (플랜에서 상세화)
- 신규 테이블 DDL + FK(차원행 참조) + 트리거(upd_dt) + 인덱스 — 기존 sql/ 패턴 따름.
- `t_prd_product_addons`: addon_prd_cd → tmpl_cd. 기존 행은 "base만 가진 템플릿" 자동 생성 후 연결.
- `t_prd_product_process_excl_groups` → option_groups/options/items로 변환(소량). 흡수 vs 병존 최종 결정 포함.
- managed=False 모델 동기화(inspectdb 또는 수기), 관리자 등록.

## 6. 테스트/검증
- DDL 멱등 적용 + FK·CHECK 무결성(타입형 FK가 "등록된 차원만" 강제하는지).
- JSONLogic 규칙 평가: Python(json-logic-py)·JS 동일 결과 샘플 검증.
- 관리자 CRUD 라운드트립(옵션·템플릿·규칙) + constraint_json 컴파일 산출 확인.

## 7. 미해결/추후
- consume_qty(차감수량)·재고/BOM 실행 레이어: 모델 여지만, 실제는 후속 Phase.
- 가격 차원 매핑(옵션→가격) 연계: 후속.
- 물리명 확정(옵션/그룹/구성요소/템플릿/제약 = opt/grp/item/tmpl/rule 등) — Dictionary 대조 필요.
- excl_groups 흡수 vs 병존 최종 확정(마이그레이션 시).
- JSONLogic 후보값 brute-force 필터로 "선택 후보 자동 축소" 구현 범위.
