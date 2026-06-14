# 실사 — 정규화·오염 방지 가드 (normalization-guard)

> **작성** 2026-06-14 · round-13. 사용자 기준 6번 = "정정으로 들어가는 모든 값이 임의 판단 아닌 화이트리스트 안에 있음을 입증".
> **3중 화이트리스트:** ① table-spec 도메인값(`docs/huni/table-spec_260610.html`) ② webadmin `sql/` FK·제약·트리거 ③ 260610 L1 엑셀 명시값(`24_master-extract-260610/silsa-l1.csv`).
> **목표:** 화이트리스트 밖 값 0 보장. apply.sql이 적재/변경하는 모든 코드값을 3축으로 검증.

---

## 1. 즉시적용분 적재값 화이트리스트 입증 (apply.sql 실행분)

### S-01 카테고리 재연결 (28상품)

| 적재 컬럼 | 적재값 | ① table-spec 도메인 | ② webadmin FK/제약 | ③ 260610 L1 엑셀 | 안? |
|-----------|--------|---------------------|--------------------|--------------------|:--:|
| `t_prd_product_categories.cat_cd` | CAT_000067~099 (28노드) | 카테고리 코드(상품명별 노드) | FK→`t_cat_categories` (28노드 라이브 실재·upr=004포스터/005사인) | 구분=포스터(004)/사인(005)·상품명 1:1 | ✅ |
| `prd_cd` | PRD_000118~145 | 상품코드 | FK→`t_prd_products` 실재 | L1 prd_nm 매칭(28상품) | ✅ |
| `main_cat_yn` | 'Y' / 'N' | YN 플래그(Y/N) | NOT NULL·CHECK(Y/N) | — (메타) | ✅ |
| `reg_dt`/`upd_dt` | now() | 타임스탬프 | NOT NULL(reg_dt default now()) | — | ✅ |
| `note` | "정정 2026-06-14: …" | 자유 메모(nullable) | nullable | — (변경이력) | ✅ |

**라이브 실재 입증 SELECT (재현·2026-06-14 실측):**
```sql
SELECT count(*) FROM t_cat_categories
 WHERE cat_cd BETWEEN 'CAT_000067' AND 'CAT_000099'
   AND upr_cat_cd IN ('CAT_000004','CAT_000005')          -- lvl2
    OR upr_cat_cd IN (SELECT cat_cd FROM t_cat_categories  -- lvl3(패브릭/보드액자/시트커팅/POP 하위)
                       WHERE upr_cat_cd IN ('CAT_000004','CAT_000005'));
-- → 33노드(067~099 연속) 전수 실재. 신규 카테고리 코드 mint 0.
```

### S-04a 원단 소재 종류코드 (.08→.05)

| 적재 컬럼 | 적재값 | ① table-spec 도메인 | ② webadmin FK/제약 | ③ 260610 L1 엑셀 | 안? |
|-----------|--------|---------------------|--------------------|--------------------|:--:|
| `t_mat_materials.mat_typ_cd` | MAT_TYPE.05 (원단) | 자재유형 도메인 "원단" 실재 | FK→`t_cod_base_codes`(MAT_TYPE.05 use_yn=Y) | 소재명=그래픽천/린넨/캔버스/현수막천/타이벡/메쉬(L1 명시) → product-bom §146 원단 분류 | ✅ |
| 대상 mat_cd | 181/182/183/184/185/187/188 | — | t_mat_materials PK 실재 | L1 소재명 1:1 | ✅ |

**라이브 도메인 실재 입증 (2026-06-14 실측):**
```sql
SELECT cod_cd,cod_nm FROM t_cod_base_codes WHERE cod_cd='MAT_TYPE.05';
-- → MAT_TYPE.05 | 원단   (use_yn=Y)
```

> **화이트리스트 밖 값 = 0.** 즉시적용분이 쓰는 모든 코드값(CAT_000067~099·MAT_TYPE.05)은 라이브 마스터/도메인에 이미 실재. 신규 mint 0 — search-before-mint 준수. DRY-RUN(BEGIN…ROLLBACK) 제약위반 0(INSERT 0 4·UPDATE 28·UPDATE 7·ROLLBACK·exit0).

---

## 2. 컨펌대기/신규적재분 적재 후보값 화이트리스트 (실행 전 사전 검증)

| 적재 컬럼 | 후보값 | ① table-spec | ② webadmin FK/트리거 | ③ 260610 L1 | 안? | 비고 |
|-----------|--------|--------------|----------------------|--------------|:--:|------|
| 부속 소재(S-08) | MAT_000215 천정고리·223 우드거치대·225 우드봉·229 우드행거 | 자재(악세사리 MAT_TYPE.10) | FK→t_mat_materials 실재 | L1 부속 명시 | ✅ | **선행조건**: option_items(자재 ref)는 트리거상 t_prd_product_materials(prd,mat,usage) 먼저 필요 |
| 봉제/족자 공정(S-06) | PROC_000080 봉제·PROC_000082 족자제작 | 공정 코드 | FK→t_proc_processes 실재(라이브 연결됨) | L1 봉제/족자 세부 다수 | ✅ | 부모 공정 실재·세부 variant 칸만 부재(Q-SL-2) |
| option ref_dim_cd | OPT_REF_DIM.03 자재·.04 공정 | 옵션참조차원 7종 | enum FK + 트리거 fn_chk_opt_item_ref | — | ✅ | 일반현수막 선례 동일 패턴 |
| 보드마운팅 공정(S-07) | (신규 PROC 코드) | 공정 코드 도메인 | **마스터 부재(0건)** | L1 보드가공 명시 | ❌ | **신규 공정 mint → 인간 승인(Q-SL-3·ddl-proposer)** |
| 수량 보완값(S-11) | min=1/max=10000/incr=1 | 정수 | NOT NULL 아님 | **L1 빈값** | ❌ | **엑셀 원본 빈값 → 보완은 "원본 누락 추정"·컨펌(Q-SL-5)** |
| 보드/우드 본체소재(S-12) | (신규 MAT 코드) | 자재 도메인 | **소재 미존재(빈값)** | **L1 소재 빈값** | ❌ | **원본 미명시 채움 → 컨펌(Q-SL-6)** |

> **화이트리스트 밖(❌) 3건을 정직하게 보류:** 보드마운팅 공정(마스터 부재)·수량 보완값(L1 빈값)·보드/우드 소재(L1 빈값). 임의 mint/추정 삽입 금지 → apply.sql에서 주석 처리(실행 안 함). "화이트리스트 밖 값을 억지로 넣지 않음"이 곧 정규화 가드 준수.

---

## 3. 오염 방지 — 무엇을 하지 않았나 (round-13 교훈 반영)

| 오염 패턴 | 본 정정이 회피한 방식 |
|-----------|----------------------|
| 색/형상/사이즈를 자재로 오적재 (MAT_TYPE.08~10 오염) | 패브릭은 자재명 정확 → 종류코드만 .08→.05 교정. 형상/봉제 세부는 자재 아닌 **공정 variant(CPQ 옵션)** 로 분리 — 자재 테이블 미오염 |
| 부속을 잘못된 테이블에 연결 | 기존 manifest C-08의 "t_prd_product_addons + sub_prd_cd" 연결법 **폐기**(addons는 tmpl_cd NOT NULL·해당 template 0건). 일반현수막 선례대로 **CPQ option_items(자재+공정 묶음)** 경로로 재설계 |
| 트리거 무결성 위반 적재 | option_items(자재 ref) 적재 전 t_prd_product_materials 선행 INSERT 필수임을 명시(fn_chk_opt_item_ref CASE 03) — 위반 적재 시도 안 함 |
| 신규 카테고리/소재 코드 남발 | 정상 노드 067~099·MAT_TYPE.05 **재사용**(search-before-mint), 신규 mint 0 |
| 고아행 hard-delete | 고아 298 연결은 **논리강등(main_cat_yn='N'+note)** — DELETE 안 함 |
| 적재처/원본 없는 값 억지 삽입 | 보드마운팅 공정·수량 보완·보드소재는 **주석 보류**(컨펌) — NULL 강제/추정 삽입 안 함 |
| 이미 정답인 값 재오염 | 레더(MAT_000186) 이미 .06 가죽 → S-04a 대상에서 제외(재변경 0). 멱등 WHERE 가드로 중복 적용 차단 |

---

## 4. 가드 결론

- **즉시적용분(S-01 카테고리 28상품 + S-04a 원단 소재 7건): 화이트리스트 밖 값 0.** 전 코드값 3중 화이트리스트 안 + 라이브 실재 입증 + 멱등 DRY-RUN 통과(제약위반 0·exit0).
- **컨펌대기/신규적재분: 화이트리스트 밖 3건(보드마운팅 공정·수량 보완·보드소재)을 정직하게 보류** — 억지 삽입 0.
- 임의 판단 0: 모든 적재값이 ① 엑셀 명시(260610 L1) 또는 도메인 확정(product-bom GO) ② 라이브 FK/도메인 대상 실재 ③ table-spec 도메인 셋을 동시 충족하거나, 못 충족 시 보류.
