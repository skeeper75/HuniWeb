# B군 — CPQ 옵션 레이어 엔티티 admin 입력 명세

**목적:** round-7 입체 커버리지에서 가장 큰 미적재 갭(`option_items` 전역 0행, CPQ 사슬 미완)을 사람이 라이브 admin에 직접 채울 수 있도록, product-viewer·catalog 화면의 **모든 항목**을 빠짐없이 정의한다. 누락 0.

> **컬럼 최종 권위 = 라이브 information_schema** (table-spec_260608.html은 보조 — `tags` 등 컬럼 누락 가능; 라이브 미대조 시 침묵 누락 위험. 2026-06-08 보정: options/templates에 `tags jsonb NULL` 실재 확정 반영).

**권위 출처:**
- CPQ 설계 의도: `docs/huni/2026-06-05-product-configurator-design.md`
- 컬럼 스펙(보조): `docs/huni/table-spec_260608.html` — **최종 권위는 라이브 information_schema** (table-spec에 tags 미기재됨)
- catalog add 폼 필드: `13_admin-ui-spec/_raw/forms/tprdtemplates.json`
- product-viewer 섹션 표시구조: `_raw/PRD_000138_text.txt`(현수막), `_raw/PRD_000016_text.txt`(엽서)
- 코드값·실측·트리거: 라이브 DB read-only psql (2026-06-08 조회)
- 미적재 갭: `12_coverage/gap-board.md` §2, `relationship-integrity.md` R3/R7

**커버 엔티티(7):** `t_prd_product_option_groups` · `t_prd_product_options` · `t_prd_product_option_items` · `t_prd_product_constraints` · `t_prd_product_addons`(product-viewer 섹션) / `t_prd_templates` · `t_prd_template_selections`(catalog 화면).

**라이브 코드값(2026-06-08 실측, t_cod_base_codes 계층 upr_cod_cd):**

| 그룹 | 코드 | 코드명 |
|---|---|---|
| SEL_TYPE(선택유형) | `SEL_TYPE.01` | 단일(택1) |
| | `SEL_TYPE.02` | 다중(택N) |
| OPT_REF_DIM(옵션참조차원유형) | `OPT_REF_DIM.01` | 사이즈 |
| | `OPT_REF_DIM.02` | 판형 |
| | `OPT_REF_DIM.03` | 자재 |
| | `OPT_REF_DIM.04` | 공정 |
| | `OPT_REF_DIM.05` | 묶음수 |
| | `OPT_REF_DIM.06` | 도수 |
| | `OPT_REF_DIM.07` | 셋트 |
| RULE_TYPE(제약규칙유형) | `RULE_TYPE.01` | 호환 |
| | `RULE_TYPE.02` | 금지 |
| | `RULE_TYPE.03` | 필수동반 |

**라이브 적재 실측(2026-06-08):** option_groups=2 · options=5 · **option_items=0** · constraints=4 · addons=1 · templates=9 · template_selections=9. → `option_items`만 전역 0행 = 채워야 할 핵심 갭.

---

## 1. `t_prd_product_option_groups` — 상품 옵션그룹

**입력 화면:** product-viewer 상품 상세 → "옵션그룹" 섹션 → `pvEdit()` 팝업(CRUD). 헤드리스 add-form 덤프 없음 → 컬럼은 table-spec 기준, 입력 위젯은 설계 §4 "그룹 CRUD(택1/택N/최대N)" + 기존 섹션 팝업 패턴.

| UI 라벨 | 컬럼(col) | 위젯 | 필수 | 타입/제약(table-spec) | 코드값 도메인(라이브 DB) | 미적재 시 입력법 | 입력 화면 |
|---|---|---|---|---|---|---|---|
| 상품코드 | `prd_cd` | (컨텍스트 고정) | Y(PK) | varchar(50), N, FK→t_prd_products | — | 현재 상품 PK 자동주입(팝업 컨텍스트) | 옵션그룹 섹션 팝업 |
| 옵션그룹코드 | `opt_grp_cd` | input/text | Y(PK) | varchar(50), N | — | `OPT-NNNNNN` 시퀀스(라이브 예: `OPT-000001`,`OPT-000002`) | 옵션그룹 섹션 팝업 |
| 옵션그룹명 | `opt_grp_nm` | input/text | Y | varchar(100), N | — | 엑셀/실사 시트의 옵션 묶음명(예 "각목추가","제본방식") | 옵션그룹 섹션 팝업 |
| 선택유형 | `sel_typ_cd` | select/select-one | N | varchar(50), Y, FK→t_cod_base_codes | SEL_TYPE: `.01`단일 / `.02`다중 | 택1=`.01`, 택N=`.02`(설계 §2 "택1/택N") | 옵션그룹 섹션 팝업 |
| 최소선택수 | `min_sel_cnt` | input/number | N | integer, Y | — | 필수그룹이면 1, 선택가능이면 0 | 옵션그룹 섹션 팝업 |
| 최대선택수 | `max_sel_cnt` | input/number | N | integer, Y | — | 택1=1, 택N=허용 최대(설계 "최대N") | 옵션그룹 섹션 팝업 |
| 필수여부 | `mand_yn` | select/select-one(Y/N) | N | char(1), Y | — | 반드시 선택해야 하는 그룹=Y(현수막 각목추가=Y 실측) | 옵션그룹 섹션 팝업 |
| 표시순서 | `disp_seq` | input/number | N | integer, Y | — | 섹션 내 정렬 순번 | 옵션그룹 섹션 팝업 |
| 사용여부 | `use_yn` | select/select-one(Y/N) | Y | char(1), N | — | 활성=Y | 옵션그룹 섹션 팝업 |
| 삭제여부 | `del_yn` | (시스템) | Y | char(1), N | — | 신규=N (소프트삭제 플래그) | 시스템 |
| 삭제일시 | `del_dt` | (시스템) | N | timestamp, Y | — | 신규=NULL | 시스템 |
| 비고 | `note` | input/text | N | varchar(500), Y | — | 자유 메모 | 옵션그룹 섹션 팝업 |
| 등록일시 | `reg_dt` | (시스템) | Y | timestamp, N | — | now()(NOT NULL — DEFAULT 또는 명시 now() 필요) | 시스템 |
| 수정일시 | `upd_dt` | (시스템) | N | timestamp, Y | — | 수정 시 갱신 | 시스템 |

**라이브 실측 행:** `PRD_000002 / OPT-000001 / 제본방식 / SEL_TYPE.02(다중) / min0 / max1 / mand N`, `PRD_000138 / OPT-000002 / 각목추가 / SEL_TYPE.01(단일) / min·max NULL / mand Y`.

---

## 2. `t_prd_product_options` — 상품 옵션

**입력 화면:** product-viewer "옵션그룹" 섹션 팝업 내부 옵션 CRUD(그룹에 종속).

| UI 라벨 | 컬럼(col) | 위젯 | 필수 | 타입/제약(table-spec) | 코드값 도메인(라이브 DB) | 미적재 시 입력법 | 입력 화면 |
|---|---|---|---|---|---|---|---|
| 상품코드 | `prd_cd` | (컨텍스트 고정) | Y(PK) | varchar(50), N, FK→t_prd_products | — | 현재 상품 PK 자동주입 | 옵션그룹 섹션 팝업 |
| 옵션코드 | `opt_cd` | input/text | Y(PK) | varchar(50), N | — | `OPV-NNNNNN` 시퀀스(라이브 예: `OPV-000003`) | 옵션그룹 섹션 팝업 |
| 소속 옵션그룹코드 | `opt_grp_cd` | select/select-one | Y | varchar(50), N, FK→t_prd_product_option_groups | (해당 상품의 opt_grp_cd 목록) | 부모 그룹 PK(예 `OPT-000002`) | 옵션그룹 섹션 팝업 |
| 옵션명 | `opt_nm` | input/text | Y | varchar(100), N | — | 사용자 선택지 라벨(예 "각목 - 세로폭기준") | 옵션그룹 섹션 팝업 |
| 기본값여부 | `dflt_yn` | select/select-one(Y/N) | N | char(1), Y | — | 그룹 초기 선택 옵션=Y | 옵션그룹 섹션 팝업 |
| 표시순서 | `disp_seq` | input/number | N | integer, Y | — | 옵션 정렬 순번 | 옵션그룹 섹션 팝업 |
| 사용여부 | `use_yn` | select/select-one(Y/N) | Y | char(1), N | — | 활성=Y | 옵션그룹 섹션 팝업 |
| 삭제여부 | `del_yn` | (시스템) | Y | char(1), N | — | 신규=N | 시스템 |
| 삭제일시 | `del_dt` | (시스템) | N | timestamp, Y | — | 신규=NULL | 시스템 |
| 비고 | `note` | input/text | N | varchar(500), Y | — | 자유 메모 | 옵션그룹 섹션 팝업 |
| 등록일시 | `reg_dt` | (시스템) | Y | timestamp, N | — | now() | 시스템 |
| 수정일시 | `upd_dt` | (시스템) | N | timestamp, Y | — | 수정 시 갱신 | 시스템 |
| 태그 | `tags` | textarea(jsonb) | N | jsonb NULL (라이브 information_schema 실측 — table-spec 미기재) | 자유 jsonb(SKU/검색 태그 메타) | 미사용 시 공란 | product-viewer 옵션 섹션 |

**라이브 실측 행(PRD_000138 각목추가 그룹):** `OPV-000003 각목 - 세로폭기준(dflt Y)`, `OPV-000004 각목 - 가로폭기준(dflt Y)`, `OPV-000005 각목 - 세로폭기준(dflt N)`. 이 5개 옵션은 **모두 option_items 0** → 사슬 미완(R7 FAIL).

---

## 3. `t_prd_product_option_items` — 상품 옵션항목 (★ 최대 갭, 전역 0행)

**입력 화면:** product-viewer "옵션그룹" 섹션 팝업 내부, 각 옵션의 "구성요소" 입력. 설계 §4: "구성요소(자재/공정/사이즈를 그 상품 등록분에서 선택)". 폴리모픽 참조이므로 `ref_dim_cd` 선택 후 그에 맞는 차원행을 `ref_key1`(/`ref_key2`)로 지정.

| UI 라벨 | 컬럼(col) | 위젯 | 필수 | 타입/제약(table-spec) | 코드값 도메인(라이브 DB) | 미적재 시 입력법 | 입력 화면 |
|---|---|---|---|---|---|---|---|
| 상품코드 | `prd_cd` | (컨텍스트 고정) | Y(PK) | varchar(50), N, FK→t_prd_product_options | — | 현재 상품 PK 자동주입 | 옵션 구성요소 팝업 |
| 옵션코드 | `opt_cd` | (컨텍스트 고정) | Y(PK) | varchar(50), N, FK→t_prd_product_options | (부모 옵션) | 부모 옵션 PK 자동주입 | 옵션 구성요소 팝업 |
| 항목순서 | `item_seq` | input/number | Y(PK) | integer, N | — | 1부터 증가(복합옵션은 2,3…) | 옵션 구성요소 팝업 |
| 참조차원유형 | `ref_dim_cd` | select/select-one | Y | varchar(50), N, FK→t_cod_base_codes | **OPT_REF_DIM: `.01`사이즈/`.02`판형/`.03`자재/`.04`공정/`.05`묶음수/`.06`도수/`.07`셋트** | 구성요소가 가리키는 차원 유형 선택 | 옵션 구성요소 팝업 |
| 참조키1 | `ref_key1` | input/text 또는 차원 select | Y | varchar(50), N | (선택한 ref_dim의 해당 차원행 키 — 아래 키슬롯 표) | ref_dim별 자연키(예 공정→`proc_cd`) | 옵션 구성요소 팝업 |
| 참조키2 | `ref_key2` | input/text 또는 select | N | varchar(50), Y | (자재일 때만 `usage_cd`) | 자재=ref_key2 필수(usage_cd), 그 외 NULL | 옵션 구성요소 팝업 |
| 수량 | `qty` | input/number | N | integer, Y | — | BOM 차감수량 여지(미정이면 NULL/1) | 옵션 구성요소 팝업 |
| 사용여부 | `use_yn` | select/select-one(Y/N) | Y | char(1), N | — | 활성=Y | 옵션 구성요소 팝업 |
| 삭제여부 | `del_yn` | (시스템) | Y | char(1), N | — | 신규=N | 시스템 |
| 삭제일시 | `del_dt` | (시스템) | N | timestamp, Y | — | 신규=NULL | 시스템 |
| 등록일시 | `reg_dt` | (시스템) | Y | timestamp, N | — | now() | 시스템 |
| 수정일시 | `upd_dt` | (시스템) | N | timestamp, Y | — | 수정 시 갱신 | 시스템 |

> **GAP-PARAM(round-7):** 설계 의도와 달리 `t_prd_product_option_items`에 **`ref_param_json` 컬럼이 없다**(table-spec 전 12컬럼에 부재). 파라미터형 옵션(예: 각목 세로폭/가로폭 같은 "기준축" 메타)을 담을 슬롯이 스키마에 없음 → 발명 금지. 현 스키마에서는 차원행 참조(ref_key)만 표현 가능하고, "기준축" 의미는 `opt_nm`(옵션명 텍스트)로만 구분된다. 파라미터 필요 시 ALTER 제안 대상(인간 승인).

### 3-1. 폴리모픽 참조 정의 — ref_dim_cd별 키슬롯 매핑

라이브 트리거 `fn_chk_opt_item_ref`(2026-06-08 소스 실측)가 `ref_dim_cd`별로 **"그 상품에 등록된 차원행만"**을 강제한다. 키슬롯은 다음과 같다:

| ref_dim_cd | 차원 | 검증 대상 테이블 | ref_key1 | ref_key2 | 트리거 정합 규칙(라이브 소스) |
|---|---|---|---|---|---|
| `OPT_REF_DIM.01` | 사이즈 | `t_prd_product_sizes` | `siz_cd` | (미사용) | `EXISTS(prd_cd, siz_cd=ref_key1)` |
| `OPT_REF_DIM.02` | 판형 | `t_prd_product_plate_sizes` | `siz_cd` | (미사용) | `EXISTS(prd_cd, siz_cd=ref_key1)` |
| `OPT_REF_DIM.03` | 자재 | `t_prd_product_materials` | `mat_cd` | `usage_cd` | `EXISTS(prd_cd, mat_cd=ref_key1 AND usage_cd=ref_key2)` — **ref_key2 필수** |
| `OPT_REF_DIM.04` | 공정 | `t_prd_product_processes` | `proc_cd` | (미사용) | `EXISTS(prd_cd, proc_cd=ref_key1)` |
| `OPT_REF_DIM.05` | 묶음수 | `t_prd_product_bundle_qtys` | `bdl_qty`(정수문자열) | (미사용) | `EXISTS(prd_cd, bdl_qty=CAST(ref_key1 AS integer))` |
| `OPT_REF_DIM.06` | 도수 | `t_prd_product_print_options` | `opt_id`(정수문자열) | (미사용) | `EXISTS(prd_cd, opt_id=CAST(ref_key1 AS integer))` |
| `OPT_REF_DIM.07` | 셋트 | `t_prd_product_sets` | `sub_prd_cd` | (미사용) | `EXISTS(prd_cd, sub_prd_cd=ref_key1)` |

**정합 규칙 요약:** ① 사이즈·판형이 둘 다 자연키 `siz_cd`이지만 `ref_dim_cd`(`.01` vs `.02`)와 검증 테이블(sizes vs plate_sizes)로 구분 — 폴리모픽 충돌을 코드가 자연 흡수. ② **자재만 2키슬롯**(`mat_cd`+`usage_cd`); 나머지는 ref_key1 단일. ③ 묶음수·도수는 ref_key1을 정수로 CAST하므로 숫자 문자열만 허용. ④ 미지원 ref_dim_cd 입력 시 트리거가 EXCEPTION → 반드시 위 7종만.

### 3-2. round-7 미적재 채움 가이드 — 현수막 "각목추가" 사슬 완결

**현황(gap-board §2 line 44 + R7):** `PRD_000138` 일반현수막의 옵션그룹 `OPT-000002`(각목추가)와 옵션 3개(`OPV-000003`/`004`/`005`)는 적재됐으나 **option_items 0행** → 사슬이 group→option 에서 끊김.

**PRD_000138 라이브 차원행(실측, option_items가 참조 가능한 후보):**
- 공정 3종: `PROC_000079`=타공, `PROC_000080`=봉제, `PROC_000081`=부착 (t_prd_product_processes)
- 자재 1: `MAT_000182` / usage_cd `USAGE.07`
- 사이즈 1: `SIZ_000322`

**채움 설계(설계 §2 "옵션 = 상품에 등록된 차원행 참조" + 메모리 [[dbmap-option-material-process-bundle]] "옵션=자재+공정 BUNDLE" 인용):**
각목추가 옵션은 "각목"이라는 **자재(우드봉)** 의미 + "부착/봉제" **공정** 의미를 함께 갖는다(round-6 v2 모델). 따라서 각 `OPV-*` 옵션에 BUNDLE로 option_items를 넣어야 사슬이 완결된다. 단, **현 PRD_000138 라이브에는 각목 전용 자재(.03)가 mint되어 있지 않음**(materials에 MAT_000182만, 이는 현수막천) → 각목 자재행은 BLOCKED-MINT(인간 승인 자재 신설 후 입력). 공정 측은 즉시 입력 가능:

예) 옵션 `OPV-000003`(각목 - 세로폭기준) 사슬 완결 입력안:
```
-- 공정 측(즉시 가능, PROC 라이브 존재): 부착 공정
(prd_cd=PRD_000138, opt_cd=OPV-000003, item_seq=1,
 ref_dim_cd='OPT_REF_DIM.04', ref_key1='PROC_000081' /*부착*/, ref_key2=NULL, qty=NULL, use_yn='Y')
-- 자재 측(BLOCKED-MINT): 각목 우드봉 자재 — 라이브 .03 부재 → 자재 신설 승인 후
-- (item_seq=2, ref_dim_cd='OPT_REF_DIM.03', ref_key1='<각목 mat_cd>', ref_key2='USAGE.??')
```
> 트리거 정합: ref_dim_cd=.04 이면 ref_key1(`PROC_000081`)이 `t_prd_product_processes(PRD_000138, proc_cd)`에 존재해야 통과 → 라이브 실측상 존재하므로 즉시 OK. 자재 BUNDLE은 자재행 mint(인간 승인)가 선행되어야 트리거 통과.

**일반 채움 절차:** 갭보드 §2의 상품군별 옵션 컬럼(별색인쇄·코팅·후가공·캘린더가공·조각수 등)을 → 해당 상품의 라이브 차원행(공정/자재/도수/사이즈)으로 환원 → ref_dim_cd+ref_key 입력. 환원 대상 차원행이 라이브에 없으면 MINT/BLOCKED 표기(발명 금지).

---

## 4. `t_prd_product_constraints` — 상품 제약규칙

**입력 화면:** product-viewer "제약 규칙" 섹션 → 친화 편집기(호환표/금지쌍/필수동반)가 내부적으로 JSONLogic 생성(설계 §4). 행단위 CRUD·on/off.

| UI 라벨 | 컬럼(col) | 위젯 | 필수 | 타입/제약(table-spec) | 코드값 도메인(라이브 DB) | 미적재 시 입력법 | 입력 화면 |
|---|---|---|---|---|---|---|---|
| 상품코드 | `prd_cd` | (컨텍스트 고정) | Y(PK) | varchar(50), N, FK→t_prd_products | — | 현재 상품 PK 자동주입 | 제약 규칙 섹션 팝업 |
| 규칙코드 | `rule_cd` | input/text | Y(PK) | varchar(50), N | — | `RULE_NNN`(라이브 예 `RULE_001`) | 제약 규칙 섹션 팝업 |
| 규칙명 | `rule_nm` | input/text | Y | varchar(200), N | — | 규칙 설명 라벨 | 제약 규칙 섹션 팝업 |
| 규칙유형 | `rule_typ_cd` | select/select-one | N | varchar(50), Y, FK→t_cod_base_codes | RULE_TYPE: `.01`호환/`.02`금지/`.03`필수동반 | 의미에 맞는 유형 선택 | 제약 규칙 섹션 팝업 |
| JSONLogic 규칙 | `logic` | textarea(친화편집기→JSON) | Y | jsonb, N | — | JSONLogic 객체(아래 예시) | 제약 규칙 섹션 팝업 |
| 위반시 오류메시지 | `err_msg` | input/text | N | varchar(500), Y | — | 위반 시 사용자 노출 문구 | 제약 규칙 섹션 팝업 |
| 표시순서 | `disp_seq` | input/number | N | integer, Y | — | 규칙 정렬 순번 | 제약 규칙 섹션 팝업 |
| 사용여부 | `use_yn` | select/select-one(Y/N) | Y | char(1), N | — | 활성=Y(컴파일 대상) | 제약 규칙 섹션 팝업 |
| 삭제여부 | `del_yn` | (시스템) | Y | char(1), N | — | 신규=N | 시스템 |
| 삭제일시 | `del_dt` | (시스템) | N | timestamp, Y | — | 신규=NULL | 시스템 |
| 등록일시 | `reg_dt` | (시스템) | Y | timestamp, N | — | now() | 시스템 |
| 수정일시 | `upd_dt` | (시스템) | N | timestamp, Y | — | 수정 시 갱신 | 시스템 |

### 4-1. JSONLogic 입력 — var 키슬롯 + 라이브 실측 예시

`logic`의 `{"var": "<키>"}`는 옵션항목 키슬롯과 동일 자연키를 쓴다(라이브 실측). 자재는 복합키 `mat_cd__usage_cd`(언더스코어 2개), 판형은 `plt_siz_cd`, 사이즈 `siz_cd`, 묶음수 `bdl_qty`(정수).

**라이브 실측 4행(권위 예시):**

| 유형 의도 | logic(라이브 실측) | err_msg |
|---|---|---|
| 금지(AND 조합 차단) | `{"!":{"and":[{"===":[{"var":"siz_cd"},"SIZ_000078"]},{"===":[{"var":"bdl_qty"},50]}]}}` | (없음) |
| 금지(OR 차단) | `{"!":{"or":[{"===":[{"var":"siz_cd"},"SIZ_000078"]},{"===":[{"var":"bdl_qty"},50]}]}}` | 앵앵앵앵 |
| 금지(자재+판형 복합) | `{"!":{"or":[{"and":[{"===":[{"var":"siz_cd"},"SIZ_000012"]},{"===":[{"var":"mat_cd__usage_cd"},"MAT_000178__USAGE.07"]}]},{"===":[{"var":"plt_siz_cd"},"SIZ_000120"]}]}}` | 앵앵앵앵 |

**입력 가이드(설계 §4 친화편집기 → JSONLogic):**
- **금지(RULE_TYPE.02):** "A와 B를 동시에 고르면 안 됨" → `{"!": {"and": [<A동등>, <B동등>]}}` (logic 전체가 true=통과 의미).
- **호환(RULE_TYPE.01):** "A이면 B만 허용" → `{"or": [{"!": <A>}, <B>]}` (A→B implies; A 아니거나 B여야 통과).
- **필수동반(RULE_TYPE.03):** "A를 고르면 C도 반드시" → `{"or": [{"!": <A>}, <C>]}` (A이면 C 필수).
- 동등 비교: `{"===": [{"var":"<키>"}, "<코드값>"]}`. 키는 위 키슬롯(siz_cd/plt_siz_cd/mat_cd__usage_cd/proc_cd/bdl_qty/opt_id/sub_prd_cd) 사용.

> RedPrinting 캐스케이드 6종 → 위 호환/금지/필수동반 JSONLogic으로 변환(메모리 [[dbmap-cpq-option-layer-mapping]]). gap-board §2 line 108: 스티커/책자/캘린더 constraints 미적재 → 커팅/표지옵션/캘린더가공 캐스케이드를 이 형식으로 입력.

---

## 5. `t_prd_product_addons` — 상품별 추가상품

**입력 화면:** product-viewer "추가상품" 섹션 팝업. `addon_prd_cd`가 아니라 **`tmpl_cd`(구성 템플릿/SKU) 참조**로 변경됨(설계 §1, table-spec FK→t_prd_templates 실측 확인).

| UI 라벨 | 컬럼(col) | 위젯 | 필수 | 타입/제약(table-spec) | 코드값 도메인(라이브 DB) | 미적재 시 입력법 | 입력 화면 |
|---|---|---|---|---|---|---|---|
| 상품코드 | `prd_cd` | (컨텍스트 고정) | Y(PK) | varchar(50), N, FK→t_prd_products | — | 현재(부모) 상품 PK 자동주입 | 추가상품 섹션 팝업 |
| 템플릿코드 | `tmpl_cd` | select/select-one(select2) | Y(PK) | varchar(50), N, FK→t_prd_templates | (catalog의 tmpl_cd 목록) | 연결할 구성 템플릿 PK(예 `TMPL-000005`) | 추가상품 섹션 팝업 |
| 표시순서 | `disp_seq` | input/number | N | integer, Y | — | 추가상품 정렬 순번 | 추가상품 섹션 팝업 |
| 비고 | `note` | input/text | N | varchar(500), Y | — | 자유 메모 | 추가상품 섹션 팝업 |
| 등록일시 | `reg_dt` | (시스템) | Y | timestamp, N | — | now() | 시스템 |
| 수정일시 | `upd_dt` | (시스템) | N | timestamp, Y | — | 수정 시 갱신 | 시스템 |

**라이브 실측:** `PRD_000016`(엽서) → `TMPL-000005`(OPP접착봉투 110x160 50장) 1행. PRD_000016_text.txt "추가상품(1)" 표시와 일치. **주의:** 이 테이블엔 use_yn/del_yn 컬럼이 없음(table-spec 6컬럼만) — addons는 소프트삭제 슬롯 부재.

---

## 6. `t_prd_templates` — 구성 템플릿(SKU) [catalog 화면]

**입력 화면:** catalog 별도 관리 화면 "구성 템플릿(SKU)" add-form(헤드리스 덤프 `tprdtemplates.json` 실측). base 상품 선택 → 인라인으로 template_selections 구성.

| UI 라벨 | 컬럼(col) | 위젯(폼 덤프) | 필수 | 타입/제약(table-spec) | 코드값 도메인(라이브 DB) | 미적재 시 입력법 | 입력 화면 |
|---|---|---|---|---|---|---|---|
| 템플릿코드 | `tmpl_cd` | input/text | N(폼)·Y(PK) | varchar(50), N | — | `TMPL-NNNNNN`(라이브 예 `TMPL-000005`) | catalog 템플릿 add-form |
| 기준상품코드 | `base_prd_cd` | select/select-one | Y | varchar(50), N, FK→t_prd_products | 폼 opts: OPP비접착봉투/하드커버책자-표지·면지(화이트/블랙/그레이) 등 상품 목록 | base 상품 선택 | catalog 템플릿 add-form |
| 템플릿명 | `tmpl_nm` | input/text | Y | varchar(200), N | — | SKU 명(예 "OPP접착봉투 110x160 mm 50장") | catalog 템플릿 add-form |
| 기본수량 | `dflt_qty` | input/number | N | integer, Y | — | 기본 판매수량(라이브 예 50) | catalog 템플릿 add-form |
| 사용여부 | `use_yn` | select/select-one(Y/N) | N(폼) | char(1), N | — | 활성=Y | catalog 템플릿 add-form |
| 삭제여부 | `del_yn` | select/select-one(Y/N) | N | char(1), N | — | 신규=N | catalog 템플릿 add-form |
| 삭제일시 | `del_dt` | input/text(_0 날짜·_1 시각) | N | timestamp, Y | — | 신규 공란 | catalog 템플릿 add-form |
| 비고 | `note` | input/text | N | varchar(500), Y | — | 자유 메모 | catalog 템플릿 add-form |
| 태그 | `tags` | textarea(jsonb) | N | jsonb NULL (라이브 information_schema 실측 — table-spec 미기재) | 자유 jsonb(SKU/검색 태그 메타) | 미사용 시 공란 | catalog 템플릿 add-form |
| 등록일시 | `reg_dt` | input/text(_0·_1) | Y | timestamp, N | — | now() | catalog 템플릿 add-form |
| 수정일시 | `upd_dt` | input/text(_0·_1) | N | timestamp, Y | — | 수정 시 갱신 | catalog 템플릿 add-form |

> **note(tags 확정, 2026-06-08 보정):** add-form 덤프의 `tags`(textarea)는 라이브 information_schema에서 `tags jsonb NULL`로 **실재 확정**(table-spec_260608.html에만 미기재). GAP 아님 — DDL 제안 불요. 날짜형(reg_dt/upd_dt/del_dt)은 폼에서 `_0`(날짜)·`_1`(시각) 2분할 위젯.

**라이브 실측 9행:** TMPL-000001~009. base 상품 PRD_000001/000002/000281/000282/000283. dflt_qty 50 또는 20.

---

## 7. `t_prd_template_selections` — 템플릿 선택값 [catalog 인라인]

**입력 화면:** catalog 템플릿 add-form의 인라인 formset(`tprdtemplateselections_set-__prefix__-*` 실측). base 상품의 옵션(opt_cd) 또는 차원(ref_dim_cd+ref_key) 선택값을 박제.

| UI 라벨 | 컬럼(col) | 위젯(폼 덤프) | 필수 | 타입/제약(table-spec) | 코드값 도메인(라이브 DB) | 미적재 시 입력법 | 입력 화면 |
|---|---|---|---|---|---|---|---|
| 템플릿코드 | `tmpl_cd` | (부모 FK) | Y(PK) | varchar(50), N, FK→t_prd_templates | — | 부모 템플릿 PK 자동주입 | 템플릿 인라인 |
| 선택순서 | `sel_seq` | input/number | Y(PK) | integer, N | — | 1부터 증가 | 템플릿 인라인 |
| 참조차원유형 | `ref_dim_cd` | select/select-one | N | varchar(50), Y, FK→t_cod_base_codes | OPT_REF_DIM 7종(§3-1 동일) | 차원 선택(예 `.01`사이즈/`.05`묶음수) | 템플릿 인라인 |
| 참조키1 | `ref_key1` | input/text | N | varchar(50), Y | (ref_dim별 자연키 — §3-1 키슬롯) | 예 사이즈→`SIZ_000080` | 템플릿 인라인 |
| 참조키2 | `ref_key2` | input/text | N | varchar(50), Y | (자재일 때 usage_cd) | 자재만 사용 | 템플릿 인라인 |
| 옵션코드 | `opt_cd` | input/text | N | varchar(50), Y | (base 상품 옵션) | 옵션 선택 박제 시 사용 | 템플릿 인라인 |
| 선택값 | `sel_val` | input/text | N | varchar(100), Y | — | 자유 선택값(차원/옵션 외) | 템플릿 인라인 |
| 수량 | `qty` | input/number | N | integer, Y | — | 선택 수량(라이브 예 50/20) | 템플릿 인라인 |
| 사용여부 | `use_yn` | input/text(폼)·char(1)(table) | N(폼)·N(table) | char(1), N | — | 활성=Y | 템플릿 인라인 |
| 삭제여부 | `del_yn` | input/text(폼) | N(폼)·N(table) | char(1), N | — | 신규=N | 템플릿 인라인 |
| 삭제일시 | `del_dt` | input/text(_0·_1) | N | timestamp, Y | — | 신규 공란 | 템플릿 인라인 |
| 등록일시 | `reg_dt` | (시스템) | Y | timestamp, N | — | now() | 시스템 |
| 수정일시 | `upd_dt` | (시스템) | N | timestamp, Y | — | 수정 시 갱신 | 시스템 |

> **note:** add-form formset에는 `use_yn`/`del_yn`이 input/text로 노출(table-spec은 char(1) NOT NULL) — 폼 위젯 느슨함. table-spec NOT NULL 충족 위해 Y/N 명시 입력 권장. add-form formset에 `reg_dt`/`upd_dt` 필드는 없음(시스템 처리).

**라이브 실측 9행:** 대부분 `OPT_REF_DIM.01`(사이즈, ref_key1=SIZ_*) + 일부 `OPT_REF_DIM.05`(묶음수, ref_key1=숫자). opt_cd/sel_val은 전부 공란 → 현 SKU들은 차원값 박제형(옵션 박제 미사용).

---

## 8. 옵션 레이어 입력 순서 (FK 위상정렬)

CPQ는 FK 의존이 깊어 **반드시 차원행 先 → 옵션 레이어 後**. 트리거(`fn_chk_opt_item_ref`)가 차원행 부재 시 EXCEPTION을 던지므로 순서 위반은 즉시 실패한다.

| 단계 | 엔티티 | admin 화면 | 선행조건(FK/트리거) |
|---|---|---|---|
| 0 | (차원행) sizes·plate_sizes·materials·processes·bundle_qtys·print_options·sets | product-viewer 각 차원 섹션 | option_items가 참조할 행이 **먼저** 존재해야 트리거 통과 |
| 1 | `t_prd_product_option_groups` | 옵션그룹 섹션 팝업 | prd_cd FK(상품 존재) |
| 2 | `t_prd_product_options` | 옵션그룹 섹션 팝업(그룹 종속) | opt_grp_cd FK(그룹 존재) |
| 3 | `t_prd_product_option_items` | 옵션 구성요소 팝업 | opt_cd FK(옵션 존재) + **ref 차원행 존재**(트리거) |
| 4 | `t_prd_product_constraints` | 제약 규칙 섹션 | prd_cd FK; logic의 var 키는 0단계 차원행과 정합 |
| 5(별도) | `t_prd_templates` → `t_prd_template_selections` | catalog 템플릿 화면 | base_prd_cd FK; selections는 tmpl_cd FK |
| 6(별도) | `t_prd_product_addons` | 추가상품 섹션 | tmpl_cd FK(5단계 템플릿 존재) |

---

## 9. 누락 점검 — table-spec 전 컬럼 = 1행 매핑

각 엔티티 table-spec 컬럼 수와 본 문서 정의 행 수 일치 확인(누락 0):

| 엔티티 | table-spec 컬럼 수 | 본 문서 정의 행 | 일치 |
|---|---|---|---|
| t_prd_product_option_groups | 14 (prd_cd, opt_grp_cd, opt_grp_nm, sel_typ_cd, min_sel_cnt, max_sel_cnt, mand_yn, disp_seq, use_yn, del_yn, del_dt, note, reg_dt, upd_dt) | 14 | ✅ |
| t_prd_product_options | 13 (prd_cd, opt_cd, opt_grp_cd, opt_nm, dflt_yn, disp_seq, use_yn, del_yn, del_dt, note, reg_dt, upd_dt, tags) | 13 | ✅ (tags jsonb 라이브 실측 추가) |
| t_prd_product_option_items | 12 (prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, del_yn, del_dt, reg_dt, upd_dt) | 12 | ✅ (ref_param_json 부재=GAP-PARAM) |
| t_prd_product_constraints | 12 (prd_cd, rule_cd, rule_nm, rule_typ_cd, logic, err_msg, disp_seq, use_yn, del_yn, del_dt, reg_dt, upd_dt) | 12 | ✅ |
| t_prd_product_addons | 6 (prd_cd, disp_seq, note, reg_dt, upd_dt, tmpl_cd) | 6 | ✅ |
| t_prd_templates | 11 (tmpl_cd, base_prd_cd, tmpl_nm, dflt_qty, use_yn, del_yn, del_dt, note, reg_dt, upd_dt, tags) | 11 | ✅ (tags jsonb 라이브 실측 확정) |
| t_prd_template_selections | 13 (tmpl_cd, sel_seq, ref_dim_cd, ref_key1, ref_key2, opt_cd, sel_val, qty, use_yn, del_yn, del_dt, reg_dt, upd_dt) | 13 | ✅ |

**합계: 81 컬럼 / 81 정의 행 — 누락 0.** (2026-06-08 보정: options 12→13·templates 10→11, `tags jsonb` 라이브 실측 반영 — 79→81)

> **근본 교훈:** 컬럼 권위 = 라이브 information_schema (table-spec은 보조, `tags` 등 누락 가능). 권위 문서만 보고 라이브 미대조 시 침묵 누락 발생 → 명세 컬럼은 반드시 information_schema로 교차확인.

### GAP 목록(발명 금지, 표기만)
- **GAP-PARAM:** option_items에 `ref_param_json` 부재(설계 의도엔 있었음). "기준축"류 파라미터 슬롯 없음 → opt_nm 텍스트로만 구분. ALTER 제안 대상(인간 승인).
- ~~**GAP-TAGS**~~ **해소(2026-06-08):** t_prd_templates·t_prd_product_options의 `tags`는 라이브 information_schema에서 `jsonb NULL`로 실재 확정. GAP 아님 — DDL 제안 불요.
- **BLOCKED-MINT(현수막 각목):** 각목 자재(.03 OPT_REF_DIM)가 PRD_000138 라이브에 미존재 → 자재행 mint(인간 승인) 선행해야 자재 BUNDLE option_item 입력 가능. 공정 측(부착/봉제/타공)은 즉시 입력 가능.
- **DB 미적재 원칙:** 본 문서는 명세만. 실제 INSERT/COMMIT·DDL·자재 mint·코드행 등록은 인간 승인.
