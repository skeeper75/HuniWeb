# 라이브 admin product-viewer ground-truth — 일반현수막(PRD_000138) + CPQ 편집 UI

> **상태/이력** 작성 2026-06-08 · 라이브 admin 실접속 캡처(orchestrator, gstack browse) · round-6 연장.
> **목적:** `https://huni-admin-production.up.railway.app/admin/product-viewer/` 를 실제 접속해 일반현수막 PRD_000138의 모든 편집 탭과 옵션/제약/SKU 편집 드릴다운 UI를 캡처하여, **라이브 `t_*` 엔티티 역할을 UI 관점 ground-truth로 고정**한다. 이전 라운드는 psql·엑셀만 봤고 관리자 편집 UI는 본 적이 없었다 — 본 문서가 그 공백을 채운다.
> **권위:** 라이브 admin 실측(스크린샷 `live_admin_capture/01~04`). 식별자/컬럼/코드 = English, 설명 = Korean.

---

## 0. 접속·범위

- URL: `/admin/product-viewer/` (Django admin 기반 커스텀 뷰어, 타이틀 "후니 상품·가격 DB 관리자 / Railway PostgreSQL").
- 로그인: Django admin (`admin`). 세션 유지.
- 좌측 메뉴 = 도메인 그룹: **상품**(상품 뷰어·상품정보·상품별페이지룰·구성 템플릿(SKU)) · **기준정보(마스터)**(카테고리·자재정보·사이즈정보·도수정보·공정정보·기초코드정보) · **가격**(가격공식·가격구성요소·구성요소 다차원 단가) · **할인·고객**(수량구간할인·고객).
- catalog Django admin 모델(직접 노출): `tprdproducts·tprdproductpagerules·tprdtemplates·tcatcategories·tmatmaterials·tsizsizes·tclrcolorcounts·tprocprocesses·tcodbasecodes·tprcpriceformulas·tprcpricecomponents·tprccomponentprices·tdscdiscounttables·tcuscustomers`. **option_groups/options/option_items/constraints는 Django admin에 미노출 — product-viewer 커스텀 드릴다운 UI로만 편집.**

---

## 1. 일반현수막 PRD_000138 상품정보 9섹션 (라이브 적재 실측)

product-viewer 상세 = 섹션 카드 9개, 각 섹션에 행 테이블 + "편집" 버튼. **각 섹션 = 1개 `t_prd_product_*` 테이블** (UI가 엔티티 역할을 직접 노출).

| # | UI 섹션 | 대응 t_* 테이블 | 라이브 행수 | 컬럼(헤더) | 실측 데이터 |
|---|---------|----------------|:----:|-----------|-------------|
| 1 | 카테고리 (1) | `t_prd_product_categories` | 1 | 카테고리코드·주카테고리여부·표시순서·비고 | **실사** · Y · 1 |
| 2 | 사이즈 (1) | `t_prd_product_sizes` | 1 | 사이즈코드·기본여부·표시순서 | **5000x900** · Y · 1 |
| 3 | 도수 / 인쇄옵션 (0) | `t_prd_product_print_options` | 0 | — | 없음 |
| 4 | 판형 (1) | `t_prd_product_plate_sizes` | 1 | 사이즈코드·출력파일유형·출력용지유형코드·기본판형여부 | **5000x900** · JPG · (공백) · Y |
| 5 | 자재 (1) | `t_prd_product_materials` | 1 | 자재코드·용도·종속공정코드·기본여부·표시순서 | **현수막천** · 공통 · (공백) · Y · 1 |
| 6 | 공정 (3) | `t_prd_product_processes` | 3 | 공정코드·필수공정여부·표시순서 | **타공**(N·1) · **부착**(N·1) · **봉제**(N·1) |
| 7 | 묶음수 (0) | `t_prd_product_bundle_qtys` | 0 | — | 없음 |
| 8 | 추가상품 (0) | `t_prd_product_addons` | 0 | — | 없음 |
| 9 | 페이지룰 (0) | `t_prd_product_page_rules` | 0 | — | 없음 |

**silsa-option-layer.md Step 0 차원행 전제와 전건 정합:**
- size 1행(5000x900=SIZ_000322) ✅ · material 1행(현수막천=MAT_000182, 용도=공통) ✅ · plate 1행(5000x900 JPG) ✅
- 공정 3행 = 타공(PROC_000079)·부착(PROC_000081)·봉제(PROC_000080), 전부 **필수공정여부=N** ✅ (silsa §1 "mand_proc_yn=N" 실측 확증)
- 도수·묶음수·추가상품·페이지룰 0행 ✅ (현수막=도수/묶음 미보유, 추가상품 거치대 부재 R6 확증)
- 자재 "용도=공통" = `usage_cd` 공통(silsa USAGE.07 매핑은 코드값 — UI는 라벨 "공통" 표시)

---

## 2. CPQ L2 레이어 — 편집 드릴다운 UI (핵심 신규 ground-truth)

상세 하단 3개 버튼: **옵션 편집** `/PRD_000138/options/` · **제약 규칙 편집** `/PRD_000138/constraints/` · **SKU 편집** `/PRD_000138/templates/`.

**[HARD 발견] L2 전 상품 미적재.** 일반현수막 = 옵션그룹 0·제약 0·SKU 0. 교차 확인한 중철책자(PRD_000068)·엽서북(PRD_000094)·프리미엄엽서(PRD_000016)·프리미엄명함(PRD_000031) **전부 옵션그룹 0개**. → 라이브 CPQ 옵션 레이어는 **현재 어떤 상품에도 적재돼 있지 않다**. round-6 설계(엽서·silsa 파일럿) 전부 미적재 = "DB 미적재·인간 승인" 원칙과 정합. `cpq-schema.md`가 인용한 "GRP-BOOK 선례"는 **코드값(SEL_TYPE 등) 선례이지 적재된 옵션그룹 행이 아님**(정정). → 일반현수막을 적재하면 **라이브 최초 옵션 레이어 사례 중 하나**가 된다.

### 2.1 옵션 편집 (`/options/`) — option_groups 폼 (스크린샷 02)

빈 상태 = "+ 그룹 추가" 점선 버튼 + 인라인 추가 폼. "열기 ›로 옵션 편집으로 이동"(그룹→옵션→옵션아이템 드릴다운, 0개라 진입 불가).

**옵션그룹 추가 폼 필드 → `t_prd_product_option_groups` 컬럼:**
| UI 필드 | 컬럼 | 값 형식 | silsa 설계 정합 |
|---------|------|---------|----------------|
| 옵션그룹명 ● | `opt_grp_nm` | text(필수) | ✅ |
| 선택유형코드 | `sel_typ_cd` | **단일 / 다중** (드롭다운) | ✅ SEL_TYPE.01(택1)/.02(택N) |
| 필수여부 | `mand_yn` | — / Y / N | ✅ |
| 최소선택수 | `min_sel_cnt` | int | ✅ |
| 최대선택수 | `max_sel_cnt` | int | ✅ |

> 옵션/옵션아이템 레벨 폼(ref_dim_cd 선택 방식·ref_param_json 필드)은 **그룹이 1개 이상 저장돼야 드릴다운 진입 가능** → 라이브 0개라 직접 미확인. 쓰기 금지(파괴적 쓰기 불가)라 그룹 생성 미수행. 단 §2.2 제약 폼의 표준 var 키가 ref_dim_cd→ref_key 슬롯을 간접 확증(아래).

### 2.4 라이브 DB 직접 SELECT 이중 확증 (read-only psql, 2026-06-08)

admin UI 캡처를 라이브 DB count로 이중 확증(읽기전용):

```
option_groups   | 0      ← 전 상품 0행
options         | 0
option_items    | 0
constraints     | 0
t_prd_templates | 1      ← (일반현수막 아님; PRD_000138 templates 0)
```

- **L2 전 상품 0행 = admin UI 캡처와 DB count 일치 확정.** `cpq-schema.md`의 "option_groups 13행 적재" 기록은 **라이브 실측과 불일치 → stale**(코드값 SEL_TYPE/OPT_REF_DIM 선례를 적재 행으로 오기). 라이브 권위로 정정.
- **`t_prd_product_option_items` 라이브 컬럼**: `prd_cd·opt_cd·item_seq·ref_dim_cd·ref_key1·ref_key2·qty·use_yn·del_yn·del_dt·reg_dt·upd_dt` — **`ref_param_json` 부재 확정**(LV-5 GAP-PARAM 직접 확증). 타공 구수·각목 규격 보존처 스키마에 없음.
- **`t_prd_product_constraints` 라이브 컬럼**: `prd_cd·rule_cd·rule_nm·rule_typ_cd·logic·err_msg·disp_seq·use_yn·...`. **`logic` = NOT NULL** → constraints GAP CSV가 `logic` 컬럼 없이 적재되면 즉시 실패(F-silsa-1 BLOCKER 정당). `rule_typ_cd·err_msg·disp_seq`는 nullable.
- templates 실제 테이블명 = **`t_prd_templates` / `t_prd_template_selections`**(`t_prd_product_templates` 아님 — 정정). admin links `tprdtemplates` 일치.

### 2.2 제약 규칙 편집 (`/constraints/`) — 폼빌더 + 표준 var 키 (스크린샷 03, 결정적)

**폼빌더 필드 → `t_prd_product_constraints` 컬럼:**
| UI 필드 | 컬럼 | 값 |
|---------|------|-----|
| 규칙명 ● | `rule_nm` | text |
| 규칙유형 ● | `rule_typ_cd` | **호환 / 금지 / 필수동반** = RULE_TYPE.01/.02/.03 ✅ |
| 조건 차원 ● + 값 | (logic) | 차원 드롭다운 + 해당 차원 값 |
| 결과 차원 ● + 값 | (logic) | 차원 드롭다운 + 해당 차원 값 |
| 오류 문구 | `err_msg` | text |
| 표시순서 | `disp_seq` | int(비우면 자동) |
| 사용여부 | `use_yn` | Y / N |
| 고급: 직접 JSONLogic 입력 | `logic`(jsonb) | 폼빌더로 안 되는 3+ AND/OR |

**차원 드롭다운(조건·결과 공통) = 7종**: 사이즈 · 판형 · 자재 · 공정 · 묶음수 · 도수 · 셋트.

**[결정적] 라이브 표준 JSONLogic var 키 (안내문 명시) — OPT_REF_DIM 7종 ↔ var 키:**
| 차원 | var 키 | OPT_REF_DIM | ref_key 슬롯 해석 |
|------|--------|:-----------:|------------------|
| 사이즈 | `siz_cd` | .01 | ref_key1 = siz_cd |
| 판형 | `plt_siz_cd` | .02 | ref_key1 = plt_siz_cd(=siz_cd) |
| 자재 | `mat_cd__usage_cd` | .03 | **복합키** ref_key1=mat_cd · ref_key2=usage_cd ✅ |
| 공정 | `proc_cd` | .04 | ref_key1 = proc_cd |
| 묶음수 | `bdl_qty` | .05 | ref_key1 = bdl_qty |
| **도수** | `opt_id` | .06 | ref_key1 = **opt_id** (NOT clr_cd) ✅ |
| 셋트 | `sub_prd_cd` | .07 | ref_key1 = sub_prd_cd |

> 이 var 키 표가 메모리 2건을 라이브로 확증: **① 도수=opt_id (NOT clr_cd)** · **② 자재=mat_cd+usage_cd 복합키슬롯**. silsa §4 디스패치(공정=.04 ref_key1=proc_cd, 셋트=.07 sub_prd_cd)와 일치.

**검증 미리보기**: 7차원 드롭다운(사이즈/판형/자재/공정/묶음수/도수/셋트) + "이 조합 검사" → 저장된 규칙으로 샘플 조합 통과 여부 테스트(JSONLogic 평가, POD 동일).

**[GAP 확증] 제약 폼빌더 = "차원값 ↔ 차원값" 2항 코드 관계만.** 조건/결과 모두 차원의 **코드값**(siz_cd 등)을 고른다. → 다음은 폼빌더 미지원:
- **연속 수치 범위**(가로 500~1750·세로 500~5000) — 표준 var에 `width`/`height` **없음**. 고급 JSONLogic으로도 비표준 var 필요.
- **차원-수치 혼합**(각목코드 ↔ 세로 수치 의존).
- **파라미터 의존**(봉미싱 선택 ↔ 사이즈>0).

→ silsa §5 constraint 3건(R-SIZE-NONSPEC·R-GAKMOK-HEIGHT·R-BONGJE-PARAM)은 **라이브 제약 메커니즘으로 표준 표현 불가** = 실 GAP. 특히 **비치수(nonspec) 사이즈 범위 검증은 constraint 차원 모델 밖**(siz_cd 코드 기준이지 width/height 수치 기준 아님). 이는 기존 GAP(비치수 size)·신규 GAP으로 정직 라우팅 대상.

### 2.3 SKU 구성템플릿 편집 (`/templates/`) — 폼 (스크린샷 04)

"+ 템플릿 추가" + "열기 ›로 선택값 편집으로 이동"(template → template_selections 드릴다운).

**템플릿 추가 폼 → `t_prd_product_templates` 컬럼:**
| UI 필드 | 컬럼 | 값 |
|---------|------|-----|
| 템플릿명 ● | `tmpl_nm` | text(필수) |
| 기본수량 | `base_qty` | int |
| 사용여부 ● | `use_yn` | Y / N |

> 일반현수막 SKU 0개(거치대 add-on 부재 R6). silsa 파일럿은 template 미산출 — 정합.

---

## 3. 라이브 UI → t_* 엔티티 역할 종합 (사용자 핵심 질문의 답)

| UI 편집 탭 | t_* 엔티티 | 역할 | 일반현수막 |
|-----------|-----------|------|-----------|
| 카테고리 | t_prd_product_categories | 상품↔카테고리(주/부) | 실사 |
| 사이즈 | t_prd_product_sizes | 규격 차원(siz_cd) | 5000x900 |
| 도수/인쇄옵션 | t_prd_product_print_options | 색상도수 차원(opt_id) | 0 |
| 판형 | t_prd_product_plate_sizes | 출력용지규격(plt_siz_cd)·출력파일유형 | 5000x900 JPG |
| 자재 | t_prd_product_materials | 소재 차원(mat_cd+usage_cd) | 현수막천/공통 |
| 공정 | t_prd_product_processes | 가공 공정 차원(proc_cd)·필수여부 | 타공·부착·봉제 |
| 묶음수 | t_prd_product_bundle_qtys | 묶음 차원(bdl_qty) | 0 |
| 추가상품 | t_prd_product_addons | 추가 완제 상품 | 0 |
| 페이지물 | t_prd_product_page_rules | 페이지 규칙 | 0 |
| **옵션** | t_prd_product_option_groups/options/option_items | **L2 — 차원행을 polymorphic ref로 묶는 선택지(sel_typ 단일/다중)** | 0(미적재) |
| **제약규칙** | t_prd_product_constraints | **L2 — 차원값 간 호환/금지/필수동반(JSONLogic, var=7키)** | 0(미적재) |
| **구성템플릿(SKU)** | t_prd_product_templates/template_selections | **L2 — 차원 조합 고정 SKU + 기본수량** | 0(미적재) |

**L1(상단 9탭)=차원 데이터 적재 / L2(하단 3탭)=차원을 참조·결합하는 옵션 레이어** — UI가 이 2층위를 물리적으로 분리(상단 카드 vs 하단 드릴다운 버튼). round-6 L1≠L2 원칙을 라이브 UI가 그대로 구현.

---

## 4. 검증/보강 라우팅 (다음 단계 입력)

| ID | 발견 | 영향 | 라우팅 |
|----|------|------|--------|
| **LV-1** | 제약 표준 var 키 7종 = 차원 코드 기반(siz_cd·plt_siz_cd·mat_cd__usage_cd·proc_cd·bdl_qty·opt_id·sub_prd_cd) | silsa §5 var 키(size_mode/width/height/gagong/chuga) 라이브 불일치 | silsa §5 정정 — 코드 기반 var로 재작성, 수치 var는 GAP |
| **LV-2** | 비치수 사이즈 범위·파라미터 제약 = 폼빌더 미지원, 표준 var에 수치 없음 | R-SIZE-NONSPEC·R-GAKMOK-HEIGHT·R-BONGJE-PARAM 표준 표현 불가 | GAP(비치수 size 검증) — ddl-proposer/도메인 결정 |
| **LV-3** | L2 전 상품 미적재(GRP-BOOK 선례=코드값) | 일반현수막=라이브 최초 옵션 레이어 사례 | 적재 우선순위·인간 승인 |
| **LV-4** | 도수=opt_id·자재=mat_cd__usage_cd 라이브 확증 | silsa 디스패치 정합 재확인 | 정합(보강 불요) |
| **LV-5** | ref_param_json 입력 필드 라이브 UI 어디에도 없음(옵션아이템 미확인이나 제약 폼도 파라미터 미수용) | GAP-PARAM(구수·각목규격) 강화 | 기존 GAP 유지·D-1 결정 |

> 옵션아이템 레벨 폼(ref_dim_cd 선택·ref_param_json)은 그룹 1개+ 저장 후에만 드릴다운 가능 → 쓰기 금지로 미확인. 적재 승인 시 최초 그룹 생성 직후 재캡처 권장.
