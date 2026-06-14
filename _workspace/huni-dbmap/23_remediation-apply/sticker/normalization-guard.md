# 스티커 — 정규화·오염 방지 가드 (normalization-guard)

> **작성** 2026-06-14 · round-13. 사용자 기준 6번 = "정정으로 들어가는 모든 값이 임의 판단 아닌 화이트리스트 안에 있음을 입증".
> **3중 화이트리스트:** ① table-spec 도메인값(`docs/huni/table-spec_260610.html`) ② webadmin sql/ FK·제약 ③ 260610 L1 엑셀 명시값.
> **목표:** 화이트리스트 밖 값 0 보장. apply.sql이 적재/변경하는 모든 코드값을 3축으로 검증.
> **DRY-RUN 실증(2026-06-14):** BEGIN…ROLLBACK 결과 = `UPDATE 3`(자재)·`INSERT 0 1`(063 화이트)·`UPDATE 1`(066 옵션그룹)·ROLLBACK. 제약 위반 0·멱등(WHERE/ON CONFLICT 가드).

---

## 1. 즉시적용분 적재값 화이트리스트 입증 (apply.sql 실행분)

| 적재 컬럼 | 적재값 | ① table-spec 도메인 | ② webadmin FK/제약 | ③ 260610 L1 엑셀 | 화이트리스트 안? |
|-----------|--------|---------------------|--------------------|--------------------|:--:|
| `t_mat_materials.mat_typ_cd` (084/242/243) | MAT_TYPE.11 (스티커) | MAT_TYPE 코드 도메인(.11=스티커·라이브 실측) | enum 변환 대상 코드 | 종이칸=비코팅/미색/투명전용 점착지 | ✅ |
| `t_mat_materials.upd_dt` | now() | 타임스탬프 | nullable | — | ✅ |
| `t_mat_materials.note` | "정정 2026-06-14: …" | 자유 메모(nullable) | nullable text | — (변경이력) | ✅ |
| `t_prd_product_processes.proc_cd` (063) | PROC_000008 (화이트) | 공정 코드(화이트별색) | FK→`t_proc_processes` 실재 | 063 `화이트인쇄(단면)` 실재 | ✅ |
| `t_prd_product_processes.mand_proc_yn/disp_seq` (063) | 'N' / 2 | YN·정수 | NOT NULL | 형제 053/054/056 패턴 계승 | ✅ |
| `t_prd_product_processes.prd_cd` | PRD_000063 | 상품코드 | FK→`t_prd_products` 실재 | L1 반칼팬시투명스티커 매칭 | ✅ |
| `t_prd_product_option_groups.use_yn/del_yn` (066) | 'N' / 'Y' | YN 플래그 | NOT NULL·YN 도메인 | — (논리삭제 메타) | ✅ |

> **화이트리스트 밖 값 = 0.** 즉시적용분이 쓰는 코드값(MAT_TYPE.11·PROC_000008)은 전부 라이브 마스터에 이미 실재. 신규 코드 mint 0 — search-before-mint 준수.

**라이브 실재 입증 SELECT (재현·비밀값 없이):**
```sql
-- MAT_TYPE 코드 도메인
SELECT cod_cd,cod_nm FROM t_cod_base_codes WHERE cod_cd IN ('MAT_TYPE.01','MAT_TYPE.11');
-- → MAT_TYPE.01|종이 · MAT_TYPE.11|스티커
-- 화이트 공정 마스터 실재
SELECT proc_cd,proc_nm FROM t_proc_processes WHERE proc_cd='PROC_000008';
-- 정정 대상 자재 3종 현재 .01
SELECT mat_cd,mat_nm,mat_typ_cd FROM t_mat_materials WHERE mat_cd IN ('MAT_000084','MAT_000242','MAT_000243');
-- → 084 비코팅스티커 .01 · 242 미색스티커 .01 · 243 투명전용지 .01
```

---

## 2. 신규적재·컨펌대기분 적재 후보값 화이트리스트 (실행 전 사전 검증)

| 적재 컬럼 | 후보값 | ① table-spec | ② webadmin FK | ③ 260610 L1 | 안? | 비고 |
|-----------|--------|--------------|---------------|--------------|:--:|------|
| `t_prd_product_categories.cat_cd` (16상품) | CAT_000030~047 | 카테고리 코드 | FK→`t_cat_categories` 실재(lvl2/3) | 상품명 1:1 매칭 | ✅ | root→정상노드 INSERT, 신규 mint 0 |
| `t_prd_product_processes.proc_cd` (코팅 8상품) | PROC_000013 (코팅) | 공정 코드(코팅) | FK→t_proc_processes 실재 | 종이칸 무광/유광코팅스티커 | ✅ | **단 Q9 vs L1/라이브 자재 CONFLICT → 보류** |
| `t_prd_product_processes.proc_cd` (규격형 형상) | PROC_000054 (반칼·모양 param) | 공정 코드 | FK 실재 | C24 형상 `원형 25mm` 등 | ✅ | 형상 param 적재처(ref_param_json) 부재 → Q-ST-C |
| `t_prd_product_bundle_qtys.bdl_qty` (조각수) | L1 조각수값 | 묶음수 도메인 | FK 실재 | *최대20/40·5~10·*1조각 | 🟡 | *최대N(상한 범위) 저장형태 미결 → Q-ST-B |
| 조각수 공정 param | — | — | **적재처 테이블 부재(prcs_dtl_opt/ref_param_json 0건)** | C25 조각수 | ❌ | **OM-7 — ddl-proposer** |
| 규격형 형상 param | — | — | **적재처 부재** | C24 형상 | ❌ | **OM-7 — ddl-proposer** |
| `t_mat_materials.mat_nm` (055/057) | "유포지+엠보코팅" | 자유 텍스트 | 멱등키(mat_nm) | L1 "유포지+엠보코팅" | 🟡 | 멱등키 변경 위험 → Q-ST-D |
| `t_prd_products.MES_ITEM_CD` (16상품) | 002-0001~0016 | MES 코드 | UNIQUE 제약(중복 충돌) | L1 002-NNNN 실값 | 🟡 | MES 중복 → 정책 결정 Q-ST-MES |
| 타투전용지(167) mat_typ | MAT_TYPE.11? | 코드 도메인 | enum | 전사지=종이 가능 | 🟡 | 전사 분류 확인 → Q-ST-F |

> **화이트리스트 밖(❌) 2건:** 조각수·규격형 형상의 **공정 param 적재처 테이블이 부재**(OM-7/GAP-PARAM). 임의 mint 금지 — `ref_param_json` 신설은 ddl-proposer + 인간 승인 대상이므로 apply.sql에서 주석 처리(실행 안 함). "화이트리스트 밖 값을 억지로 넣지 않음"이 곧 정규화 가드 준수.
> **🟡 4건(코팅 공정·자재명·MES·타투지)은 화이트리스트 안이나 충돌/정책/멱등키 위험** → 컨펌 후 적용. 본 라운드는 즉시적용 3건만 실행.

---

## 3. 오염 방지 — 무엇을 하지 않았나 (round-13 교훈 반영)

| 오염 패턴 | 본 정정이 회피한 방식 |
|-----------|----------------------|
| 색/형상/사이즈를 자재로 오적재 (MAT_TYPE.08~10 오염) | 규격형 형상은 자재 아닌 **공정+param**으로 분리(보류) — 자재 테이블 미오염 |
| 코팅을 무비판 공정 전환 | 코팅=공정(Q9) vs 자재(L1/라이브/가격) **CONFLICT 정직 표기·보류** — Q9만 보고 자재행 파괴 안 함 |
| 별색(화이트)을 도수로 오적재 | 화이트=공정(PROC_000008), 도수칸(color_counts) 무침입 — 형제 053/054/056 패턴 그대로 |
| 신규 카테고리 코드 남발 | 정상노드 030~047 **재사용**(search-before-mint·16상품 1:1), 신규 mint 0 |
| 고아·빈행 hard-delete | 066 빈 옵션그룹은 **논리삭제(use_yn='N'·del_yn='Y'+note)** — DELETE 안 함. root 카테고리도 강등(보류) |
| 적재처 없는 값 억지 삽입 | 조각수·규격형 형상 param은 적재처 부재로 **주석 보류**(ddl) — NULL 강제/엉뚱한 칸 삽입 안 함 |
| 합판도무송 형상을 size에서 제거(round-10 교훈) | 형상=size(Q7 칼틀)는 **CORRECT 유지** — 기계적 size 삭제 금지(가격사슬·칼틀 파손) |

---

## 4. 가드 결론

- **즉시적용분(자재유형 3종·063 화이트·066 빈 옵션그룹): 화이트리스트 밖 값 0.** 전 코드값 3중 화이트리스트 안 + 라이브 실재 입증 + 멱등 DRY-RUN 통과(UPDATE 3·INSERT 0 1·UPDATE 1·제약 위반 0).
- **신규적재·컨펌대기분: 화이트리스트 밖 2건(조각수·형상 param 적재처 부재)을 정직하게 보류** — 억지 삽입 0. 🟡 4건은 충돌/정책/멱등키로 컨펌.
- 임의 판단 0: 모든 적재값이 ① 엑셀 명시(260610 L1) ② 라이브 FK 대상 실재 ③ table-spec 도메인 중 셋을 동시 충족하거나, 못 충족 시 보류.
