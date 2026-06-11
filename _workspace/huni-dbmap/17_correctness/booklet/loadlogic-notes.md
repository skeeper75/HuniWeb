# 책자 — 적재 로직 재구성 (loadlogic-notes · round-13 C1)

> **작성** 2026-06-11. 적재 oracle = `raw/webadmin/tools/load_master.py`(엑셀→t_* 변환) + `raw/webadmin/sql/`(물리 스키마·제약).
> **[HARD] v03 진원 directive:** `load_master.py`는 **순수 전파기**다(XLSX `data/raw/prdmaster_full_migration_v03_20260518.xlsx`, L39). 적재 결함의 진원은 **상류 v03 정규화**이고 정답은 상품마스터 원본 L1(`06_extract/booklet-l1.csv`). load_master 코드 자체는 충실히 전파할 뿐. v03 파일 직접 참조 금지 — 라이브 vs L1 불일치로 v03 결함을 역추적.
> **models.py 주의:** `catalog/models.py`는 inspectdb 거울(`managed=False`)이라 적재 로직 아님. 적재 로직은 `tools/`+`sql/`.

---

## 0. 적재 파이프라인 골격 (load_master.py)

`run_all()`(L492) = 단일 트랜잭션: ① seed 재적재(GROUP.NN) ② masters(surrogate 발급) ③ relations(FK 치환). 멱등 = TRUNCATE 후 executemany 재삽입(L22·168 등). 책자는 **10_상품정보** 시트(완제품+sub_prd) + 14개 relation 시트(11~21)에서 적재.

| t_* 테이블 | load_master 함수 | v03 시트 | 책자 적재 컬럼 |
|-----------|------------------|----------|----------------|
| t_prd_products | `load_products` L250 | 10_상품정보 | prd_nm·prd_typ·semi_role·min/max/incr_qty·qty_unit·MES(전량 NULL) |
| t_prd_product_categories | `load_rel_categories` L282 | 11_상품별카테고리 | cat_cd·main_cat_yn |
| t_prd_product_bundle_qtys | `load_rel_bundle_qtys` L294 | 12_상품별묶음수 | bdl_qty·bdl_unit(QTY_UNIT) |
| t_prd_product_sizes | `load_rel_sizes` L307 | 13_상품별사이즈 | siz_cd·dflt |
| t_prd_product_materials | `load_rel_materials` L318 | 14_상품별자재 | mat_cd·**usage_cd**·dflt |
| t_prd_product_plate_sizes | `load_rel_plate_sizes` L336 | 17_상품별판형사이즈 | siz_cd·output_paper_typ·output_file_typ |
| t_prd_product_print_options | `load_rel_print_options` L352 | 16_상품별인쇄옵션 | print_side·front/back_colrcnt |
| t_prd_product_processes | `load_rel_processes` L404 | 15_상품별공정 | proc_cd·mand_proc_yn·excl_grp |
| t_prd_product_sets | `load_rel_sets` L424 | 19_상품셋트정보 | sub_prd_cd·sub_prd_qty |
| t_prd_product_page_rules | `load_rel_page_rules` L447 | 21_상품별페이지룰 | page_min/max/incr |

---

## 1. 핵심 변환 규칙 재구성 (책자 영향)

### LR-1 자재 usage 적재 — `load_rel_materials` L318~333
```python
usage = enum_code("USAGE", r["용도"] or "공통", ref=...)   # L324
```
- **규칙:** v03 14_상품별자재의 `용도` 컬럼 → USAGE.NN. **용도가 비면 "공통"(=USAGE.07)으로 적재**(L324, "usage_cd는 PK 멤버(NOT NULL); 빈 용도 → USAGE.공통, 사용자 결정 2026-06-03").
- **결함 진원:** v03이 한 자재를 **용도 명시 행 + 용도 빈 행 둘 다** 생성하면, 빈 행이 USAGE.07로 떨어진다. 책자 in-scope = **떡메모지(097) 백색모조지가 USAGE.01(내지) + USAGE.07(공통) 동일 mat 복제**(라이브 실측 §live-diff §2.1). load_master는 v03 행을 충실히 전파했을 뿐 — 진원은 v03이 097 내지 자재를 용도 빈 행으로 한 번 더 만든 것.
- **F-GATE-BK-3 정밀화 [횡단 일반화 과대 정정]:** `.01↔.07 동일 mat_cd 복제`는 전 DB **1건**(097만, validator `dup_rows=1`)이다. 직전에 "57상품·324행 같은 결함"이라 일반화했으나 **과대**다 — USAGE.07에 종이 자재가 든 324행(016 엽서 등)은 **.01 복제가 아니라 "용도-미지정 자재→USAGE.공통 풀"**이라는 별개의 약한/정당 가능 현상(별 family 소관, BK-1 결함 아님). **BK-1은 097 동일-mat 복제 1건으로 한정**(책자 family는 097만).
- **dep_proc_cd 폐기:** L328 "(dep_proc_cd 폐기 — sql/23)". Phase11이 종속공정코드 컬럼 DROP(sql/23). 책자 매핑 무영향.

### LR-2 자재유형 override — `load_materials` L227 + `MAT_TYP_OVERRIDE` L116
```python
MAT_TYP_OVERRIDE = {
  "MAT.레더하드커버 A": "가죽", "MAT.레더하드커버 A4": "가죽", "MAT.레더하드커버 A5": "가죽",
  "MAT.하드커버전용지+무광코팅": "종이", }   # L116~121
mat_typ = enum_code("MAT_TYPE", MAT_TYP_OVERRIDE[slug] if slug in OVERRIDE else r["자재구분"])  # L237
```
- **규칙:** 자재 마스터(05_자재정보) 적재 시 `자재구분`을 MAT_TYPE.NN으로 해석하되, 슬러그가 OVERRIDE면 강제 치환. **MAT.레더하드커버 A/A4/A5 → 가죽(.06)으로 명시 치환**(사용자 결정 2026-06-03).
- **결함 진원(CONFLICT-1):** OVERRIDE는 `MAT.레더하드커버 A*` 슬러그만 가죽으로 만든다. 그러나 책자가 **실제 연결한 표지 자재는 `레더(화이트)`(MAT_000186)** — 이는 OVERRIDE 대상이 아닌 별 슬러그라 `자재구분` 그대로 = **MAT_TYPE.08 실사소재**로 적재됨. 결과: 가죽(.06) 레더 자재 4행(MAT_000008/173~175)은 만들어졌으나 **상품 미연결 고아**, 책자는 .08 레더(화이트)로 연결. **진원 = v03 14_상품별자재가 책자 표지를 .06 가죽이 아닌 .08 실사소재 슬러그로 연결**. load_master OVERRIDE는 마스터 적재만 손대고 14의 연결 슬러그는 못 바꿈.

### LR-3 plate output_paper_typ — `load_rel_plate_sizes` L336~349
```python
other = ENUM["OUTPUT_PAPER_TYPE"]["기타"]   # L338
output_paper_typ_cd = other if r["출력용지유형코드"] is not None else None   # L346
```
- **규칙:** v03 17_상품별판형사이즈의 `출력용지유형코드`는 용지 치수(316x467 등)로 들어와서 **값이 있으면 전부 OUTPUT_PAPER_TYPE.기타, 없으면 NULL**(L340 주석 "전부 기타, 사용자 결정").
- **결함 진원(GAP-PAPER):** 책자 plate 32행 전부 output_paper_typ_cd NULL = **v03 17 시트의 출력용지유형코드가 책자 행에서 전부 빈값**. L1 C12/C23 폴더(책자/디지털/실사/특수인쇄)는 v03 17이 출력용지유형코드로 안 옮김 → 라이브 미적재. load_master는 "있으면 기타"라 NULL을 충실 전파. output_file_typ(C11/C22 PDF)은 일부만(32행 중 12행) 적재 = v03이 PDF를 일부 행에만 채움.

### LR-4 print_options 면 전개 — `load_rel_print_options` L352~382
```python
ACRYLIC = [("배면양면",c4,c4,"Y"),("풀빼다",c4,c0,"N"),("투명테두리",c4,c0,"N")]  # L359
if 옵션ID.endswith("DEFAULT"): 3행 전개(아크릴)  # L366
else: print_side·front/back_colrcnt 1행  # L373
```
- **규칙:** 옵션ID가 `-DEFAULT`로 끝나면 아크릴 UV 3종 전개, 아니면 정상 단/양면 1행. **책자는 옵션ID가 정상 단/양면이라 else 분기**(아크릴 무관). opt_id = 상품별 순번(L361, PK integer). front/back_colrcnt = 도수코드 매핑(단면=back CLR.0도).
- **책자 정합:** 068 양면(front/back 4도) + 단면(back 0도) 2행 = L1 내지인쇄 변형 정합. CORRECT.

### LR-5 제본 공정 + excl_group — `load_rel_processes` L404 + `load_rel_excl_groups` L390
```python
if eg and (prd,eg) not in groups: eg=None + INSPECTION  # L412 고아 excl_grp NULL화
mand_proc_yn = _yn(r["필수공정여부"])  # L415
```
- **규칙:** 15_상품별공정 → proc_cd·mand_proc_yn. 택일그룹코드가 18 시트에 없으면 NULL+inspect. **책자 제본 mand_proc_yn = v03이 전부 N**(라이브 9행 N 실측 정합). option_groups(택일그룹)는 load_master가 **다루지 않음**(15/18은 excl_groups만, t_prd_product_option_groups는 CPQ 레이어로 별 트랙) → 책자 option_groups 0행 = **적재 경로 자체 부재**(OM-6 CPQ 미적재).

### LR-6 sets — `load_rel_sets` L424
```python
INSERT sub_prd_cd, sub_prd_qty  # 19_상품셋트정보
```
- **규칙:** 19 시트 → 완제품↔sub_prd 연결. 책자 sets 21행 적재(하드커버/레더/하드링/레더바인더/엽서북/떡메모지). sub_prd 자체는 10_상품정보에 별 행(PRD_TYPE.02). **load_master는 sub_prd에 자재를 별도로 안 넣음** — sub_prd 자재는 14_상품별자재에 그 prd_cd 행이 있을 때만. 따라서 **078 sub_prd 자재 2행 = v03 14에 PRD_000078 자재 행이 실재**(잡음).

---

## 2. 발견된 적재 로직 결함 (file:line)

| ID | 결함 | load_master 위치 | 진원(v03 vs 코드) | 책자 영향 |
|----|------|-----------------|-------------------|-----------|
| LL-1 | 용도 빈 자재 → USAGE.07 떨굼 | L324 `r["용도"] or "공통"` | **v03 진원**(중복 행) — 코드는 정책대로 전파 | 떡메모지 백색모조지 .01↔.07 동일 mat 복제 **1건**(전 DB 097만, F-GATE-BK-3). 324행 종이-풀은 별개 현상 |
| LL-2 | 레더(화이트) .08 실사소재 적재 | L116 OVERRIDE 범위 밖 + L237 | **v03 진원**(14가 .08 슬러그 연결) — OVERRIDE는 마스터만 손댐 | 책자 레더 표지 .08(Q4 의도=가죽 .06) |
| LL-3 | output_paper_typ_cd 전량 NULL | L346 | **v03 진원**(17 출력용지유형코드 빈값) — 코드는 NULL 전파 | plate 폴더(C12/C23) 미적재 |
| LL-4 | 078 sub_prd 자재 2행(몽블랑130g) | L318 14 충실 전파 | **v03 진원**(14에 PRD_000078 자재 행 실재) | sub_prd 빈 껍데기 위반 |
| LL-5 | 088 공정 0행(수축포장 포함) | L404 15 충실 전파 | **v03 진원**(15에 PRD_000088 공정 행 없음) | 바인더 후공정 전무 |
| LL-6 | 떡메모지 카테고리 2중연결 main=Y×2 | L282 11 충실 전파 | **v03 진원**(11에 097 행 2건 main=Y) | 주카테고리 모순 |
| LL-7 | option_groups 미적재(택일그룹) | (load_master 미처리) | **적재 경로 부재** — CPQ 레이어 별 트랙 | 책자 1:1이라 현 모델 불요(GAP-OG) |

> **공통 진단:** LL-1~6은 전부 **load_master 코드 결함이 아니라 v03 정규화 결함**(directive 정합 — load_master는 순수 전파기). 정답은 상품마스터 L1. LL-7만 적재 경로 부재(미처리). **교정 = v03 행을 라이브에서 직접 정정하지 말고, 상품마스터 L1을 권위로 한 델타 제안**(round-5/6 + 인간 승인).
