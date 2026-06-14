# 스티커 Tier A 4상품 CPQ 옵션레이어 — 적재 매니페스트

> **상태/이력** 작성 2026-06-14 · `dbm-option-mapper` 산출 · round-6 Tier A 스티커. **DB 미적재**(DRY-RUN 롤백전용 실증·실 COMMIT 인간 승인).
> 권위 설계 = `10_configurator/tierA/sticker-option-layer.md`. 멱등 SQL 패턴 = `09_load/_exec_silsa_cpq` 모방.

## 1. 대상·차원행 전제 (라이브 실측 2026-06-14)

| prd_cd | prd_nm | siz | mat | prn | proc | plt | 기존옵션 | 차원행 BLOCKED |
|---|---|:--:|:--:|:--:|:--:|:--:|---|:--:|
| PRD_000052 | 반칼 자유형 스티커 | 3 | 5 | 1 | 1(반칼 PROC_000054) | 3 | 없음 | 0 |
| PRD_000053 | 반칼 자유형 투명스티커 | 3 | 1 | 1 | 2(화이트008·반칼054) | 3 | 없음 | 0 |
| PRD_000055 | 낱장 자유형 스티커 | 3 | 1 | 1 | 1(완칼 PROC_000053) | 3 | 없음 | 0 |
| PRD_000066 | 합판도무송스티커 | 37 | 6 | 1 | 1(완칼 PROC_000055) | 26 | OPT-000004(del Y)·OPV-000006(고아) | 0 |

> **전 차원행 라이브 적재 → BLOCKED 0**. (postcard/digitalprint 와 달리 스티커는 mint 불요.)

## 2. 적재 SQL 인덱스 (FK 위상정렬)

| 파일 | 테이블 | 행 | 멱등 가드 |
|---|---|:--:|---|
| `00_preload_markers.sql` | (마커) | 0 | — |
| `05_t_prd_product_option_groups.sql` | option_groups | 12 | (prd_cd, opt_grp_nm, del_yn='N') |
| `06_t_prd_product_options.sql` | options | 22 | (prd_cd, opt_nm, opt_grp resolve, del_yn='N') |
| `07_t_prd_product_option_items.sql` | option_items | 21 | (prd_cd, opt_cd resolve, item_seq) |
| `08_t_prd_product_constraints.sql` | constraints | 0 | (sel_typ 로 충족) |
| `_cleanup_dummy.sql` | options(고아) | (인간승인) | 066 OPV-000006 소프트삭제 |

**코드 채번:** option_groups = 라이브 MAX `OPT-000005`+1 → `OPT_000006`~`OPT_000017`(separator `_` 통일). options = 라이브 MAX `OPV_000016`+1 → `OPV_000017`~`OPV_000038`.

## 3. 적재 가능성 집계

| 테이블 | 행 | INSERTABLE | BLOCKED |
|---|:--:|:--:|:--:|
| option_groups | 12 | 12 | 0 |
| options | 22 | 22 | 0 |
| option_items | 21 | 21 | 0 |
| constraints | 0 | 0 | 0 |
| **합계** | **55** | **55** | **0** |

option_items 내역: 052[종이5·인쇄1·반칼1=7] · 053[종이1·인쇄1·화이트1·반칼1=4] · 055[종이1·인쇄1·완칼1=3] · 066[종이6·인쇄1=7] = **21**.

## 4. 폴리모픽 디스패치 검증 (트리거 슬롯)

| ref_dim_cd | 슬롯 | 본 적재 사용 | 트리거 검사 대상 |
|---|---|---|---|
| `.03` 자재 | ref_key1=mat_cd, ref_key2=`USAGE.07` | 종이 12행(052×5·053×1·055×1·066×6, minus dup → 13 mat refs) | t_prd_product_materials EXISTS |
| `.06` 도수 | ref_key1=`1`(opt_id::int) | 인쇄 4행(단면) | t_prd_product_print_options(opt_id=1) EXISTS |
| `.04` 공정 | ref_key1=proc_cd | 커팅 3행(052/053 반칼054·055 완칼053)·화이트별색 1행(008) | t_prd_product_processes EXISTS |

> **opt_id=`1`(NOT clr_cd)** — MISMATCH-1 정정 정합. 별색=공정(.04 PROC_000008·clr_cd NULL) — attribute-map "별색=공정" 정합.

## 5. DRY-RUN 결과 (라이브 롤백전용 2026-06-14)

| 검사 | 결과 | 증거 |
|---|---|---|
| **PASS-1 트리거 통과** | ✅ INSERT 0 1 × 55 (REJECT 0) | apply.sh dryrun — 21 option_items 전건 fn_chk_opt_item_ref 통과 |
| **트랜잭션 내 카운트** | groups 12 · options 23(=22신규+1 기존고아) · items 21 | apply.sql post-check |
| **PASS-2 멱등** | ✅ delta 0 (PASS-2 INSERT 0 1 = 0건, 전건 NOT EXISTS skip) | 2-pass 단일 트랜잭션: PASS1=55 inserted, PASS2=0 inserted |
| **ROLLBACK 영구변경 0** | ✅ post-DRYRUN 라이브 items_4prod=0·new OPV_=0 | 라이브 read-only 재확인 — 4상품 option_items 여전히 0행 |

> `OPT-000004`(원형·del_yn=Y·reg_dt 2026-06-10)는 본 작업 이전 죽은 stub — DRY-RUN 이 만든 행 아님(영구변경 0 확정).

## 6. 미적재 사유·다음 단계

- **NEVER COMMIT** — 본 산출은 빌드(DRY-RUN 실증)까지. 실 COMMIT·066 고아 정리(`_cleanup_dummy.sql`)·GAP DDL = 인간 승인.
- GO/NO-GO 판정 = `dbm-validator`(생성자≠검증자). 본 산출은 자가 승인 안 함.
- 적재 시 순서: `./apply.sh commit`(단일 트랜잭션·인간 승인). 백업·undo 권장.
</content>
