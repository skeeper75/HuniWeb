# 굿즈파우치 — 적재 로직 재구성 (loadlogic-notes · round-13 C1)

> **작성** 2026-06-11 · round-13. `raw/webadmin/tools/load_master.py`(527줄) + `sql/`로 굿즈파우치 엑셀 칼럼이 t_*로 어떻게 변환·적재되도록 코딩됐는지 재구성하고, 발견된 적재 로직 결함을 file:line으로 명시.
> **[HARD] oracle = `sql/` + `tools/`. `catalog/models.py`(inspectdb 거울)는 적재 로직 아님.**

---

## 0. 적재 입력 경로 — [부분 불명] **load_master는 상품마스터 시트가 아닌 v03 마이그레이션본을 읽는다**

`load_master.py:39` → `XLSX = "data/raw/prdmaster_full_migration_v03_20260518.xlsx"`. 즉 로더는 **상품마스터 `굿즈파우치(가격포함)` 시트를 직접 읽지 않는다.** 읽는 시트는 v03 마이그레이션본의 정규화 시트 — `read_sheet(wb, "10_상품정보")`·`"11_상품별카테고리"`·`"13_상품별사이즈"`·`"14_상품별자재"`·`"15_상품별공정"` 등(`MASTERS`/`RELATIONS` 리스트, line 461~481).

- **함의:** 굿즈파우치 행이 `굿즈파우치(가격포함)` 시트 → v03 정규화 시트로 변환되는 단계는 **별도 마이그레이션 스크립트**(레포 미동봉)가 수행했고, `load_master.py`는 그 산출(v03)을 t_*로 옮긴다. 본 round-13은 v03 입력 파일을 직접 검증 불가(`raw/webadmin/data/raw/` 부재·`.venv` 부재 — `find . -name "*.xlsx"` → 0건).
- **[적재 경로 부분 불명 = finding]** 굿즈의 본체색×사이즈 폭증(F-ID-2)·형상/잉크색 자재행화(F-ID-3)·카테고리 고아(F-ID-1)가 **(a) v03 마이그레이션 단계에서 생성**됐는지 **(b) load_master 변환 단계에서 생성**됐는지는 v03 원본 없이 단정 불가. 단, load_master 코드가 v03의 자재/사이즈/카테고리 행을 **거의 무변환 통과**(아래 §1~§3)시키므로, **F-ID-2/3/1의 1차 원인은 v03 마이그레이션 단계(상품마스터→정규화)이고 load_master는 그 결함을 충실히 전파**한 것으로 판정(추정 아님 — 코드가 변환을 안 하므로 결함을 만들 수 없음을 §별로 입증).

---

## 1. 자재 적재 로직 (`load_rel_materials` line 318~333 + `load_materials` 227~247)

```
# load_rel_materials (14_상품별자재 → t_prd_product_materials)
usage = enum_code("USAGE", r["용도"] or "공통", ...)   # line 324: 빈 용도 → USAGE.공통
params.append((MAPS["PRD"][prd], MAPS["MAT"][자재코드], usage, _yn(기본여부), _int(표시순서)))
```

- **무변환 통과:** 로더는 v03 `14_상품별자재` 행을 1:1로 `t_prd_product_materials`에 넣는다. **본체색·형상·잉크색을 자재로 분류하거나 폭증시키는 로직은 load_master에 없다** — v03이 이미 "화이트 M/블랙 XL/원형 58mm/청보라" 같은 자재행을 들고 있었고 로더는 그대로 적재. (F-ID-2/3의 1차 원인 = v03, line 326 무변환 전파.)
- **usage 기본값:** `r["용도"] or "공통"`(line 324) → 빈 용도가 전부 `USAGE.07(공통)`. 라이브 실측 일치(반팔티셔츠·머그·핀버튼·만년스탬프 전부 USAGE.07). **이 부분은 정당** — round-11 CONFIRM-GP-5 가설("USAGE.01 본체")은 틀렸고, USAGE.01=내지·USAGE.07=공통이므로 굿즈 낱장 본체에 공통이 합리적.
- **자재유형(`mat_typ_cd`):** `load_materials` line 237~239 = `enum_code("MAT_TYPE", r["자재구분"])`. v03 `05_자재정보`의 `자재구분` 값을 MAT_TYPE.NN으로 변환. 라이브에서 티셔츠/핀버튼/만년스탬프 자재가 전부 `MAT_TYPE.09(파우치)` → **v03의 `자재구분`이 "파우치"로 잘못 채워졌음을 의미**(로더는 라벨→코드 충실 변환). MAT_TYPE.09 오염 = v03 결함의 전파.

---

## 2. 사이즈 적재 로직 (`load_rel_sizes` 307~315 + `load_sizes` 194~207 + `fix_size_dims.py`)

```
# load_rel_sizes (13_상품별사이즈 → t_prd_product_sizes) — 무변환 1:1
INSERT INTO t_prd_product_sizes (prd_cd, siz_cd, dflt_yn, disp_seq)
```

- **무변환 통과:** 로더는 v03 `13_상품별사이즈` 행만 size로 적재. **옵션형 사이즈(폰기종·M/L/XL)를 option_items로 재분류하는 로직 없음** — load_master는 CPQ 옵션 레이어(`t_prd_product_option_groups/options/option_items`)를 **전혀 적재하지 않는다**(RELATIONS 리스트에 옵션 로더 부재, line 469~481). → F-ID-4(option_groups=0)의 직접 원인: **CPQ 옵션 레이어가 load_master 범위 밖**. round-10 size→option 재분류 의도는 적재 파이프라인에 반영된 적 없음.
- **fix_size_dims.py:** size명에서 치수 파싱해 NULL work/cut 채움(line 1~30). 사각손거울 S(75x130mm) 등 치수형 22행이 정상 work/cut 보유(라이브 실측 일치) = 이 스크립트 효과. **굿즈 특화 변형 없음**(grep "굿즈|파우치|형상|옵션" → 0건). 치수형 size는 정당 적재.

---

## 3. 카테고리 적재 로직 (`load_categories` 164~178 + `load_rel_categories` 282~291)

```
# load_categories: cat 마스터 적재 + upr_cat_cd 2-pass UPDATE
INSERT ... upr_cat_cd=NULL ...                                  # line 170: 1-pass 전부 NULL
updates = [(m[상위카테고리코드], m[카테고리코드]) for r in rows if _norm(r["상위카테고리코드"])]  # line 175
cur.executemany("UPDATE t_cat_categories SET upr_cat_cd=%s WHERE cat_cd=%s;", updates)  # line 177
```

- **무변환 통과:** 카테고리 부모는 v03 `01_카테고리`의 `상위카테고리코드`로만 채워진다(line 175). **상위카테고리코드가 빈 행은 upr_cat_cd=NULL로 남는다**(line 170 초기값 유지). → F-ID-1: 고아 노드 14개(CAT_000293~306·전부 lvl3·upr NULL)는 **v03 카테고리 시트에서 `상위카테고리코드`가 비어있던 행**. 로더는 빈 부모를 채우지 않으므로 NULL 그대로 적재. **상품-카테고리 연결(`load_rel_categories` line 288)도 v03 `11_상품별카테고리`를 1:1 전파** — 상품이 고아 노드에 연결된 것은 v03가 그렇게 연결한 것.
- **결함 원인 정합:** digital-print loadlogic-notes와 동일 — load_master는 카테고리 트리 무결성을 검증하지 않는다(고아 노드를 정상 노드로 재연결하거나 부모를 추론하는 로직 없음). v03가 시트 `구분` 라벨을 별 카테고리 행으로 만들면서 부모를 비워두면 그대로 고아가 된다.

---

## 4. 공정 적재 로직 (`load_rel_processes` 404~421 + `load_processes` 210~224)

```
# load_rel_processes (15_상품별공정 → t_prd_product_processes) — 무변환 1:1
params.append((MAPS["PRD"][prd], MAPS["PROC"][공정코드], eg, _yn(필수공정여부), _int(표시순서)))
```

- **무변환 통과:** v03 `15_상품별공정` 행만 적재. 라이브 굿즈 공정 6행(전부 캔버스류 PROC_000081 부착) = v03가 그 6행만 들고 있었음을 의미. **봉제(PROC_000080)·에폭시(PROC_000083)·맥세이프를 자동 도출하는 로직 없음** → F-ID-5(공정 누락·봉제→부착 오적재)의 원인: v03 `15_상품별공정`에 굿즈 공정이 거의 비어있었고(캔버스 6행만, 그것도 봉제 아닌 부착), load_master는 빈 것을 만들지 않는다.
- **excl_grp_cd 고아 가드:** line 412~414 = 18(택일그룹)에 없는 그룹 참조는 NULL+inspect. 굿즈 가공 택일그룹(GRP-GP-가공)은 18 시트에 없으므로 설사 v03에 있었어도 NULL 처리됐을 것. 단 `sql/23_drop_columns.sql`이 `t_prd_product_processes.excl_grp_cd`를 **삭제**(라이브 실측: "column pp.excl_grp_cd does not exist") → 현재 스키마엔 택일그룹 컬럼 자체가 없음.

---

## 5. 추가상품·도수·세트 — 로더는 적재하나 v03 입력이 비어있음

- **addons(`load_rel_addons` 436~444):** v03 `20_상품별추가상품` → `t_prd_product_addons(addon_prd_cd)`. 볼체인(PRD_000006)·리필잉크(PRD_000015)는 **별 상품으로 라이브 실재**(F-ID-5)하나 굿즈 상품의 addon 링크는 0행 → v03 `20` 시트에 굿즈 addon 행 부재.
- **print_options(`load_rel_print_options` 352~382):** **아크릴 UV 변형 3종 전개 로직**(line 359 ACRYLIC = 배면양면/풀빼다/투명테두리) 보유 — 이건 아크릴 굿즈 전용. 굿즈파우치 면(단/양면) 도수는 v03 `16_상품별인쇄옵션`에 행이 있어야 적재되는데 라이브 0행 → v03 입력 부재. (만년스탬프 잉크색=도수도 도수가 아닌 자재로 들어감 — F-ID-3.)
- **sets(`load_rel_sets` 424~433):** v03 `19_상품셋트정보` → `t_prd_product_sets`. 굿즈 sets=0행(굿즈는 세트 아님 — 정당).

---

## 6. 적재 로직 결함 요약 (file:line)

| # | 결함 | 위치 | 라이브 증상 | 1차 원인 |
|---|------|------|-------------|----------|
| L-GP-1 | 자재 무변환 전파(본체색×사이즈 폭증·자재유형 오염) | `load_rel_materials:326`·`load_materials:237` | 티셔츠 8행·핀버튼 형상·만년스탬프 잉크색 전부 자재(MAT_TYPE.09) | v03 마이그레이션(상품마스터→정규화)에서 발생, 로더가 충실 전파 |
| L-GP-2 | CPQ 옵션 레이어 미적재 | RELATIONS 리스트 `461~481`(옵션 로더 부재) | option_groups=0(굿즈 전체) | load_master 범위 밖 — round-10 size→option 의도 미반영 |
| L-GP-3 | 카테고리 부모 무추론(고아 NULL 잔존) | `load_categories:170·175` | 고아 노드 14개·상품 35개 오연결 | v03 카테고리 시트 빈 상위코드, 로더 무검증 |
| L-GP-4 | 공정 무도출(봉제/에폭시/맥세이프 누락) | `load_rel_processes:415` | 공정 6행뿐(캔버스 부착만) | v03 `15` 시트 굿즈 공정 부재, 로더가 없는 행 안 만듦 |
| L-GP-5 | 도수/추가상품 입력 부재 | `load_rel_print_options`·`load_rel_addons` | print_options=0·addons=0(볼체인 별상품 실재하나 미링크) | v03 `16`/`20` 시트 굿즈 행 부재 |
| L-GP-6 | (정당) usage 기본 USAGE.07·치수형 size·sets 0 | `load_rel_materials:324`·`fix_size_dims` | 정상 적재 | round-11 가정(USAGE.01) 정정 — USAGE.07 공통이 맞음 |

> **핵심:** load_master는 굿즈에 대해 **거의 순수 전파기**다. 결함의 1차 진원은 **상품마스터 → v03 마이그레이션 정규화 단계**(레포 미동봉)이고, load_master는 그 결함을 무검증 전파한다. 따라서 교정은 (a) v03 입력 재생성보다 (b) **라이브 t_* 직접 교정**(상품마스터 260610 L1 권위로)이 실효적 — round-5/10 델타 트랙. CPQ 옵션(L-GP-2)은 애초에 적재된 적 없으므로 round-6 트랙 신규 적재.
