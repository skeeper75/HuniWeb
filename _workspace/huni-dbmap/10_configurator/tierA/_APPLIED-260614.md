# Tier A CPQ 옵션 레이어 — GO분 라이브 COMMIT 적용 기록 (2026-06-14)

> 사용자 "GO분 안전 적재 진행" 승인 → silsa 절차(백업→DRY-RUN→COMMIT→검증→멱등2회차)로 4 패키지 L2 옵션레이어 **1,026행 실 COMMIT 완료**. 라이브 운영 DB(`railway`) 쓰기. 비파괴(순수 INSERT·기존 행 무변경).

## 적용 결과

| 항목 | 적재 전(기준선) | 적재 후 | 증분 |
|---|:--:|:--:|:--:|
| `t_prd_product_option_groups` | 2 | **124** | +122 |
| `t_prd_product_options` | 5 | **465** | +460 |
| `t_prd_product_option_items` | 7 | **444** | +437 |
| `t_prd_product_constraints` | 1 | **8** | +7 |
| **합계** | 15 | **1,041** | **+1,026** |

(기준선 15 = 016 테스트 더미 og1·op4·oi7 + 025 더미 cst1 + 066 stub og1·op1 — 미정리, 인간 승인 큐 B/C)

## 검증 (적재 직후)

- **행수 정합**: 4 테이블 증분 = 설계 INSERTABLE 1,026행과 정확히 일치.
- **트리거 무결성**: option_items 공정 참조 고아 **0**(`fn_chk_opt_item_ref` 적재 시 전건 통과).
- **커버리지**: 35상품 전부 옵션그룹 보유.
- **멱등성**: 4 패키지 재실행(DRY-RUN 2회차) 신규 적재행 **0** — 이름/자연키 `WHERE NOT EXISTS` 가드 실증.

## 패키지별 COMMIT

| 패키지 | 단행 INSERT | 비고 |
|---|:--:|---|
| `_exec_tierA_digitalprint/` | 577 | 14상품(엽서·포토카드·접지카드·명함·상품권·전단지) |
| `_exec_tierA_sticker/` | 55 | 4상품(반칼·투명·낱장·합판066보강) |
| `_exec_tierA_booklet/` | 87 + multi-row | 4상품(중철·무선·트윈링·엽서북). 자재 라이브 SELECT 동적 전개로 일부 multi-row INSERT → 실제 item 312행 |
| `_exec_tierA_areaform/` | 82 | 13상품(포스터9·배너4). L2 순수(L1 LINK 분리) |

## 미적재 (이번 COMMIT 제외 — 인간 승인 큐 잔존)

- **BLOCKED 17**: 디지털 6(접지 공정 PROC_065~068·화이트 별색공정)·면적형 11(거치대 template·복합끈 — 차원/LINK 미링크).
- **L1 LINK 3**: 면적형 139 끈 BUNDLE(`_exec_tierA_areaform/_l1_link_preload.sql`, 인간 승인 — 차원 product-link).
- **테스트 더미 정리 미실행**: 016 후가공 더미·025 `RULE_001`·066 고아 `OPV-000006`(`_cleanup_dummy.sql`, 인간 승인).
- **GAP DDL**: `ref_param_json`·usage 분리·거치대 template·hidden → `dbm-ddl-proposer`.

## 롤백 안전망

- 적재 전 스냅샷: `09_load/_exec_tierA_backup_260614/pre_{option_groups,options,option_items,constraints}.csv`(35 prd_cd 적재 전 상태).
- 롤백 = 현재 35 prd_cd cpq 행 중 백업 CSV의 PK에 없는 행(=우리 적재분) DELETE → 기준선 15행으로 복원. 멱등이라 재적재 안전.

## 절차 증빙

백업(read-only COPY) → 4 패키지 DRY-RUN 재확인(ERROR/REJECT 0·ROLLBACK) → `apply.sh commit`(BEGIN…apply…COMMIT·`ON_ERROR_STOP=1`) → 행수/트리거/커버리지 검증 → 멱등 2회차. 비밀번호 stdout/_workspace 미노출. **huni-dbmap CPQ 레이어 첫 대량 라이브 적재**(이전 silsa 43행에 이은 1,026행).
