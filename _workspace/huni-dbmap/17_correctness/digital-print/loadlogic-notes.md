# 디지털인쇄 — 적재 로직 재구성 (round-13 C1)

> **작성** 2026-06-10 · round-13(라이브 정합 교정). 설명 한국어, 식별자/컬럼/코드/SQL 영어.
>
> **목적:** `raw/webadmin`이 라이브 t_*를 어떻게 채웠는지 재구성하고, 그 규칙이 만든 결함을 file:line으로 짚는다. 라이브=교정 대상(피고), oracle=정답.
>
> **프레임[HARD]:** round-12는 라이브를 권위로 봤다. round-13은 역전 — 라이브가 oracle(엑셀 L1·적재 SQL·적재 로직·도메인 확정)과 충돌하면 **라이브가 틀린 것**.

---

## 0. 적재 파이프라인 전모 (어떤 스크립트가 무엇을 적재했나)

| 단계 | 스크립트 | 입력 | 산물 | 디지털인쇄 영향 |
|------|----------|------|------|----------------|
| seed | `sql/05_seed.sql` | — | `t_cod_base_codes`(코드값) | USAGE.07 공통·OUTPUT_PAPER_TYPE.01 국전계열/.03 기타·QTY_UNIT.02 매 정의 |
| 마스터+관계 | `tools/load_master.py --all` | **`data/raw/prdmaster_full_migration_v03_20260518.xlsx`**(line 39) | 마스터(surrogate 발급)+관계 11종 | **핵심 적재기. 대부분 결함의 출처** |
| 치수 보정 | `tools/fix_size_dims.py --apply` | 라이브 `t_siz_sizes`(NULL 치수) | work/cut 치수 UPDATE | 사이즈명 파싱(73x98→w=h=cut=work) |
| Phase7 | `tools/migrate_phase7.py --all` | 라이브 | excl_groups→옵션레이어 흡수·addon PK→tmpl_cd 전환 | `t_prd_product_addons`를 `TMPL-`+addon_prd_cd(line 215·226)로 전환 → **하이픈 separator 출처** |

**[HARD] 적재원 엑셀 버전 격차** — load_master.py가 적재한 엑셀은 **`v03_20260518`(5월 18일자)**(line 39). round-13 oracle은 **`260610.xlsx`(6월 10일자)**. 두 버전 사이 변경분(round-10이 추적한 260527→260610 등)은 load_master가 본 적이 없다. 라이브에 v03 엑셀 파일은 레포에 부재(`raw/webadmin/data/` 자체가 없음·gitignore) → **적재원 1차 증거 직접 검증 불가**. v03↔260610 차이로 설명되지 않는 라이브 값은 "적재 경로 불명"으로 분류.

---

## 1. load_master.py 디지털인쇄 컬럼 변환 규칙 재구성

### 1-1. 상품 (`t_prd_products`, load_products line 250-275)

| 컬럼 | 적재 규칙(load_master) | line | 결함/주의 |
|------|------------------------|------|-----------|
| prd_cd | 엑셀 PRD_NNNNNN identity 보존 | 252 | 정상 |
| `"MES_ITEM_CD"` | **무조건 None 적재** | 261 | MES코드 7건이 14상품에 중복→부분 UNIQUE 위반 회피. 라이브 NULL 정상 |
| prd_nm | 그대로 | 262 | 멱등 키 |
| prd_typ_cd | `bcd_label`→enum_code(PRD_TYPE) | 263 | 정상 |
| qty_unit_typ_cd | **무조건 None 적재**(시트10 원천 컬럼 없음) | 269 | **🔴 결함: 라이브는 QTY_UNIT.02 매 — load_master 산물 아님(적재 경로 불명, §2-A)** |
| min/max/incr_qty | 정수 | 268 | 정상 |
| file_upload_yn/editor_yn | `_yn` | 267 | 정상 |

### 1-2. 사이즈 (`t_prd_product_sizes`, load_rel_sizes line 307-315 + masters load_sizes 194)

- 마스터 `t_siz_sizes`: `04_사이즈정보` 시트 행순 SIZ_NNNNNN 발급, work/cut/margin은 **엑셀 값 그대로**(line 203-205). 빈 치수는 fix_size_dims.py가 사후 파싱 보정.
- 관계 `t_prd_product_sizes`: `13_상품별사이즈` 시트의 (상품코드, 사이즈코드)를 그대로 연결(line 312).
- **규칙:** 사이즈 행수 = `13_상품별사이즈` 시트의 상품별 행수. 디지털인쇄 시트의 사이즈 세로 캐스케이드와 무관 — 별 시트.

### 1-3. 자재 (`t_prd_product_materials`, load_rel_materials line 318-333)

- usage_cd: `r["용도"] or "공통"` → **빈 용도는 USAGE.공통(=USAGE.07)으로 강제**(line 324). PK 멤버 NOT NULL 대응.
- **규칙:** 디지털인쇄 종이는 엑셀 `14_상품별자재` 용도 컬럼이 비어 있어 **전부 USAGE.07로 적재** → 라이브 21행(엽서) 전부 USAGE.07은 **이 규칙의 정상 산물**. (round-12 R12-2가 "라이브 권위"로 본 것이 실은 load_master의 default 강제).

### 1-4. 판형사이즈 (`t_prd_product_plate_sizes`, load_rel_plate_sizes line 336-349)

- **[HARD] output_paper_typ_cd: `316x467` 등 치수값이 들어오면 무조건 `OUTPUT_PAPER_TYPE.기타`(=`.03`)로 강제**(line 338,346). "출력용지유형코드는 용지 치수로 들어옴 → 전부 기타" 주석(line 340).
- siz_cd: `17_상품별판형사이즈` 시트의 사이즈코드 슬러그→MAPS["SIZ"](line 344).
- **🔴 결함: 라이브 plate에 `OUTPUT_PAPER_TYPE.01 국전계열` 32행 존재** — load_master는 `.01`을 절대 적재하지 않음(line 346은 `.03` 또는 NULL만). 엽서 PRD_000016 plate가 `.01`+SIZ_000499(순차 SIZ 범위 밖)인 것은 **load_master 산물 아님 → 적재 경로 불명/후속 손작업**(§2-B).

### 1-5. 인쇄옵션 (`t_prd_product_print_options`, load_rel_print_options line 352-382)

- opt_id: 엑셀 옵션ID(`{PRD}-PRINT-...` 문자열)는 정수 PK로 못 쓰므로 **상품별 행순 1,2,…로 재발급**(line 362-369).
- `*-PRINT-DEFAULT` 행은 **아크릴 UV 3종(배면양면/풀빼다/투명테두리)으로 하드코딩 전개**(line 359,366-369). **이건 아크릴 굿즈 전용 로직** — 디지털인쇄 print_options에 이 변형이 잘못 끼면 결함이나, 엽서 라이브는 단면/양면 2행 정상(§3 live-diff에서 확인).

### 1-6. 공정 (`t_prd_product_processes`, load_rel_processes line 404-421)

- `15_상품별공정` 시트의 (상품코드, 공정코드)를 그대로 연결(line 415). **변환 없음** — 시트가 가진 공정코드 슬러그를 MAPS["PROC"]로 치환만.
- **[HARD] 핵심: 라이브 공정 행 = 적재원 v03 엑셀 `15_상품별공정` 시트의 행을 그대로 반영.** 박칼라가 개별 공정 행으로, 박 본체·접지·형압이 누락된 것은 **적재원 시트 자체가 그렇게 구성**됐다는 의미(§2-C). load_master는 충실히 옮겼을 뿐 — 결함은 적재원 데이터에 있다.

### 1-7. 추가상품 (`t_prd_product_addons`)

- load_master(line 436-444): `20_상품별추가상품` (상품코드, 추가상품코드)를 addon_prd_cd로 적재.
- migrate_phase7(line 211-257): addon_prd_cd → `'TMPL-'||addon_prd_cd`(line 215,226) tmpl_cd로 전환. **하이픈 separator는 이 문자열 결합의 산물**(코드전략 `_`와 CONFLICT).

### 1-8. 가격공식 (`t_prd_product_price_formulas`)

- **load_master.py 미관여** — RELATIONS 목록(line 469-481)에 price_formula 없음. 라이브 PRF_DGP_A~F·PRF_PHOTOCARD_FIXED 등은 **dbm 하네스 round-2/디지털인쇄 가격엔진 트랙의 산물**(메모리 dbmap-digitalprint). webadmin 적재 oracle 밖.

---

## 2. 발견된 적재 로직 결함 (file:line)

| ID | 결함 | 근거(file:line) | 라이브 증상 | 분류 |
|----|------|-----------------|-------------|------|
| **L-A** | qty_unit_typ_cd 무조건 None 적재 | load_master.py:269 | 라이브 7상품 전부 QTY_UNIT.02(load_master 산물 아님) | 적재 경로 불명 |
| **L-B** | plate output_paper_typ_cd를 치수→무조건 `.03 기타`로 강제(`.01 국전계열` 발생 불가) | load_master.py:338,340,346 | 라이브 plate `.01` 32행 존재 | 적재 경로 불명(후속 손작업) |
| **L-C** | 공정을 `15_상품별공정` 시트 그대로 적재(변환 0) → 적재원 결함 그대로 통과 | load_master.py:404-421 | 박칼라 개별행만·박본체/접지/형압 누락 | MIS-LOADED(적재원 결함) |
| **L-D** | usage 빈값→USAGE.07 default 강제(설계상 의도) | load_master.py:324 | 라이브 USAGE.07 전건(정상이나 의미상 "본체" 아닌 "공통") | CORRECT(설계 의도)·도메인 주의 |
| **L-E** | addon `'TMPL-'`+addon_prd_cd 하이픈 결합 | migrate_phase7.py:215,226 | tmpl_cd 하이픈 separator(코드전략 `_`와 충돌) | AMBIGUOUS(컨펌) |
| **L-F** | 적재원 엑셀 v03(5/18) ≠ oracle 260610(6/10) | load_master.py:39 | 버전 격차로 일부 라이브 값이 현재 엑셀과 불일치 가능 | 구조적 한계 |

> **방법론 핵심[HARD]:** load_master는 `15_상품별공정`·`14_상품별자재` 등을 **변환 없이 충실히 옮긴다**. 따라서 공정/자재의 라이브 결함은 **적재원 v03 엑셀 시트 자체**에 있다(스크립트 버그 아님). 반대로 qty_unit·plate `.01`은 load_master가 적재할 수 없는 값이므로 **webadmin 밖 후속 손작업**(dbm 하네스 round-2/가격엔진)이 출처 = 적재 경로 webadmin oracle 밖.

---

## 3. round-13 보강 — 배경지 세트·카테고리 결손의 적재경로 (C-ID 정체 연계)

> 직전 산출(§0~2)에 더해, 배경지 정체(포장 세트, product-identity §F-ID-1)가 라이브에 왜 미적재됐는지 적재경로를 추가 규명.

### L-G [구조적 미적재 — 배경지 봉투 세트] 🔴 High
- **무엇:** 배경지(PRD_000043/044/045)는 "배경지 카드 + 사이즈매칭 봉투/케이스" 세트(site goods_view_102·product-master:380). 그러나 라이브 `t_prd_product_addons`=**전 DB에서 PRD_000016 1행뿐**(read-only 측정: `SELECT prd_cd,count(*) FROM t_prd_product_addons GROUP BY prd_cd` → PRD_000016|1). 배경지 addon=0·sets=0.
- **적재경로 근본원인:** 봉투 정보가 **디지털인쇄 시트 `추가상품` 칼럼(C38)에 자유텍스트**로만 존재("봉투 ★사이즈선택 : 76x100" + "OPP접착봉투 80x120 mm 50장"). load_rel_addons(load_master.py:436-444)는 **구조화된 별 시트 `20_상품별추가상품`만** 읽는다 — 디지털인쇄 시트 C38 자유텍스트는 파싱 안 함. v03 시트20에 배경지 봉투 행이 없었다면(엽서 1건만 들어감) 배경지 addon은 애초에 생성 불가.
- **migrate_phase7 무관:** migrate_phase7.py(:211-222)는 **기존 addon 행을** TMPL-로 전환할 뿐(행 보존), 없는 행을 만들지 않는다. 따라서 배경지 봉투는 어느 단계에서도 적재 안 됨 = **MISSING(적재 대상)**.
- **why 한 문장:** "봉투 세트가 구조화 시트(20)가 아닌 디지털인쇄 본 시트 C38 자유텍스트에 있어 load_rel_addons의 파싱 범위 밖 → 배경지 세트 전면 미적재."

### L-H [오적재 — 배경지/상품권 카테고리 orphan] 🟡 Med
- **무엇:** load_categories(load_master.py:164-178)는 `01_카테고리` 시트의 `카테고리코드`→surrogate, `상위카테고리코드`→upr_cat_cd UPDATE. 라이브 측정: CAT_000296 배경지·CAT_000295 상품권은 **upr_cat_cd=NULL·cat_lvl=3 고아**(`SELECT cat_cd,cat_nm,upr_cat_cd,cat_lvl FROM t_cat_categories WHERE ...`). 반면 CAT_000012 포장(lvl1)·CAT_000283 라벨/포장스티커(lvl2)는 정상 트리.
- **적재경로 근본원인:** `01_카테고리` 시트가 배경지/상품권을 lvl3로 정의하면서 상위코드를 비웠거나(시트 데이터 결함), 디지털인쇄 시트 `구분` 라벨에서 파생된 편의 그룹을 별 카테고리로 만든 것. load_master는 시트 그대로 적재 → 상위 NULL이면 고아.
- **함의:** 배경지(043/044/045)는 CAT_000296에 연결됐으나, 이 노드가 012 포장 트리에 미연결 → 판매 카테고리 위상 결손. mapping-final C1 비고("시트 편의 그룹≠판매 카테고리")의 실증.

> **L-G/L-H 종합:** 배경지 정체(포장 세트)를 모른 채 칼럼만 보면 봉투 세트·카테고리 위상이 보이지 않는다(round-11/12가 일반 인쇄물로 봐서 놓침). C-ID 선행이 두 적재경로 결함(L-G addon 파싱범위·L-H 카테고리 orphan)을 드러냄 = round-13 방법론(정체 선행 + 라이브=교정대상)의 입증.
