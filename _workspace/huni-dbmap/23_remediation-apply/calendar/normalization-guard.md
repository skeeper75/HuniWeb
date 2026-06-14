# 캘린더 — 정규화·오염 방지 가드 (normalization-guard)

> **작성** 2026-06-14 · round-13. 사용자 기준 6번 = "정정으로 들어가는 모든 값이 임의 판단 아닌 화이트리스트 안에 있음을 입증".
> **3중 화이트리스트:** ① table-spec 도메인값(`docs/huni/table-spec_260610.html`) ② webadmin sql/ FK·제약 ③ 260610 L1 엑셀 명시값(`calendar-l1.csv`·`design-calendar-l1.csv`).
> **목표:** 화이트리스트 밖 값 0 보장. apply.sql이 적재/변경하는 모든 코드값을 3축으로 검증.

---

## 1. 즉시적용분 적재값 화이트리스트 입증 (apply.sql 실행분 = MES 채움)

| 적재 컬럼 | 적재값 | ① table-spec 도메인 | ② webadmin FK/제약 | ③ 260610 L1 엑셀 | 화이트리스트 안? |
|-----------|--------|---------------------|--------------------|--------------------|:--:|
| `t_prd_products.MES_ITEM_CD` (108) | 007-0001 | MES 품목코드(자유 varchar·NULL 허용) | UNIQUE 제약 **부재**(실측) → 중복 위반 불가 | L1 MES칸 탁상형=007-0001 (1:1) | ✅ |
| `MES_ITEM_CD` (109) | 007-0002 | 동일 | 동일 | L1 미니탁상형=007-0002 | ✅ |
| `MES_ITEM_CD` (110) | 007-0003 | 동일 | 동일 | L1 엽서캘린더=007-0003 | ✅ |
| `MES_ITEM_CD` (111) | 007-0004 | 동일 | 동일 | L1 벽걸이캘린더=007-0004 | ✅ |
| `MES_ITEM_CD` (112) | 007-0005 | 동일 | 동일 | L1 와이드벽걸이=007-0005 | ✅ |
| `upd_dt` | now() | 타임스탬프(nullable) | nullable timestamp | — (변경이력) | ✅ |

> **화이트리스트 밖 값 = 0.** 즉시적용분이 쓰는 값(007-0001~5)은 전부 ① 엑셀 L1 MES칸 명시 ② 전역에서 아무 상품도 안 쓰는 번호(중복 0 실측) ③ UNIQUE 제약 부재라 위반 불가. 신규 코드/임의값 mint 0.

**라이브 실재·무중복 입증 SELECT (재현, 비밀값 비노출):**
```sql
-- (1) 5상품 현재 MES = NULL (적재 대상)
SELECT prd_cd, COALESCE("MES_ITEM_CD",'NULL') FROM t_prd_products
 WHERE prd_cd IN ('PRD_000108','PRD_000109','PRD_000110','PRD_000111','PRD_000112');
-- → 전부 NULL

-- (2) 007-% MES를 쓰는 행 = 0 (중복 없음 → 채움 안전)
SELECT "MES_ITEM_CD", count(*) FROM t_prd_products WHERE "MES_ITEM_CD" LIKE '007-%' GROUP BY 1;
-- → 0행

-- (3) MES_ITEM_CD UNIQUE 제약 부재
SELECT tc.constraint_type FROM information_schema.table_constraints tc
 JOIN information_schema.key_column_usage kcu ON tc.constraint_name=kcu.constraint_name
 WHERE tc.table_name='t_prd_products' AND kcu.column_name='MES_ITEM_CD';
-- → 0행 (UNIQUE 없음)
```

**DRY-RUN(롤백전용) 입증:** BEGIN→5 UPDATE(`UPDATE 1`×5)→멱등 재실행(`UPDATE 0`×2)→중복 검사 0행→ROLLBACK→라이브 다시 NULL. 제약위반 0·완전 무동작 멱등·읽기전용 무손실 실증.

---

## 2. 신규적재/컨펌대기분 적재 후보값 화이트리스트 (실행 전 사전 검증)

| 적재 컬럼 | 후보값 | ① table-spec | ② webadmin FK | ③ 260610 L1 | 안? | 비고 |
|-----------|--------|--------------|---------------|--------------|:--:|------|
| `t_prd_products.editor_yn` (디자인 surface) | 'Y' | YN 플래그(Y/N·NOT NULL) | NOT NULL char | design-l1 편집기=Y | ✅ | 같은 상품 surface 정책 컨펌(C-10) |
| `t_prd_product_materials.del_yn` (링/삼각대 잉여) | 'Y' | YN 논리삭제 | YN·NOT NULL | — (제거 메타) | ✅ | hard-delete 아님 |
| `t_prd_product_processes.proc_cd` (트윈링 링칼라 param) | PROC_000021 | 공정 코드(트윈링제본) | FK→`t_proc_processes` 실재 | 캘린더가공=고리형트윈링제본 | ✅ | 이미 적재된 공정·param만 추가 |
| `t_prd_product_materials.mat_cd` (우드거치대) | MAT_000223 / MAT_000034 | 자재 코드(우드거치대) | FK→`t_mat_materials` **실재**(둘 다) | 추가상품=우드거치대 | ✅ | search-before-mint HIT·신규 mint 0 |
| `t_prd_product_addons.tmpl_cd` (캘린더봉투) | (사이즈매칭 봉투 template) | template 코드 | FK→`t_prd_templates` | 추가상품=캘린더봉투(★사이즈선택) | ❌ | **PRD_000005 기준 template 0건 → 봉투 template 선적재 선행** |
| `t_proc_processes.proc_cd` (삼각대 거치) | (신규) | 공정 코드 | **마스터 부재(0행 실측)** | 캘린더가공=삼각대 거치 | ❌ | **삼각대 거치 공정 마스터 0 → mint 선행(ddl-proposer·CL-A)** |
| 장수 옵션값(4(8P)/8(16P)…) | — | CPQ option_items | option 로더 부재(load_master) | L1 장수칸 명시 | ❌ | **CPQ option 적재 경로 부재 → round-6 L2(CL-D)** |
| 디자인 고정가(4000~24000) | — | `t_prd_product_prices` | FK 실재(테이블 존재) | design-l1 가격칸 명시 | ❌ | **가격 트랙 별도(round-2/16)** |

> **신규적재/컨펌대기에서 화이트리스트 밖(❌) 4건:** 봉투 template(0건)·삼각대 거치 공정(마스터 0)·장수 옵션(적재경로 부재)·디자인 고정가(가격 트랙). 이 넷은 임의 mint/엉뚱한 칸 삽입 금지 — 데이터/스키마/가격 신설 결정이 인간 승인 대상이므로 apply.sql에서 주석 처리(실행 안 함). "화이트리스트 밖 값을 억지로 넣지 않음"이 곧 정규화 가드 준수.
> **반대로 우드거치대(C-09)는 ✅:** 자재 마스터(MAT_000223·MAT_000034)가 실재 → 신규 mint 0·기존 행 재사용(search-before-mint 준수).

---

## 3. 오염 방지 — 무엇을 하지 않았나 (round-13 교훈 반영)

| 오염 패턴 | 본 정정이 회피한 방식 |
|-----------|----------------------|
| 부속(삼각대/링)을 자재로 오적재 (MAT_TYPE.07 부속을 본체 종이 슬롯에 평면화) | 삼각대 거치·링칼라를 **공정(+param)** 으로 분리 설계(자재 테이블 미오염). 단 공정 mint는 컨펌 — 억지 자재 유지 안 함 |
| 색/형상을 자재로 오적재 (MAT_TYPE.08~10 오염) | 삼각대색·링칼라=공정 param(옵션)으로 분리 — 색을 자재행으로 두지 않음 |
| 장수를 page_rule(책자 내지)에 기계적 삽입 | 장수=캘린더 고유 **고객옵션+가격공식**(Q12)으로 분류. page_rule에 넣지 않음(schema-intent OM 정합) |
| 신규 자재/공정 코드 남발 | 우드거치대=기존 MAT_000223/034 **재사용**(search-before-mint HIT). 삼각대 거치 공정만 마스터 부재 입증 후 mint(컨펌) |
| 고아행·잉여행 hard-delete | 링/삼각대 잉여 자재 연결은 **논리삭제(del_yn='Y')** — DELETE 안 함·provenance 보존 |
| 적재처 없는 값 억지 삽입 | 봉투 template·삼각대 거치 공정·장수 옵션·고정가는 적재처 부재/별 트랙으로 **주석 보류**(컨펌) — NULL 강제/엉뚱한 칸 삽입 안 함 |
| MES 중복 위반 위험 무시 | MES 채움 전 전역 중복 0·UNIQUE 부재 **실측 입증** 후에만 즉시적용 |

---

## 4. 가드 결론

- **즉시적용분(MES 채움 5상품): 화이트리스트 밖 값 0.** 전 값(007-0001~5) 3중 화이트리스트 안 + 라이브 무중복 실측 + 멱등 DRY-RUN 통과(제약위반 0·완전 무동작 멱등).
- **신규적재/컨펌대기분: 화이트리스트 밖 4건(봉투 template·삼각대 거치 공정·장수 옵션·고정가)을 정직하게 보류** — 억지 삽입 0. 우드거치대(자재 마스터 실재)만 화이트리스트 안.
- 임의 판단 0: 모든 적재값이 ① 엑셀 명시(260610 L1) ② 라이브 FK 대상 실재 ③ table-spec 도메인 중 셋을 동시 충족하거나, 못 충족 시 보류.
