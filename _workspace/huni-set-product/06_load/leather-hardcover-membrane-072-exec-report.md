# 072 하드커버책자 면지 통합 재설계 — 적재 실행 리포트 (COMMIT 완료)

> §23 Huni-Set-Product · hsp-load-executor · 2026-07-03 · **라이브 COMMIT 성공**
> 실행 전제: 게이트 S1~S8 GO + codex reconcile 합의(DISAGREE 0) + 인간 승인(072만 우선) — 3조건 충족.

## 결과: **COMMIT 성공** · 사후 골든/webadmin 4항 전부 PASS · undo 불필요

## 실행 순서 (안전 프로토콜)
1. FK 선행 확인 — 6상품(072/073/074/075/076/284) 전부 t_prd_products 실재·072=TYPE.01·나머지 TYPE.02.
2. 물리 백업 — `bak_*_setbuild072_20260703_0312` 6테이블(products4·sets5·materials3·optgrp1·options3·optitems3).
3. 롤백전용 DRY-RUN(`BEGIN…ROLLBACK`) — 카운트 정확·트리거 fn_chk_opt_item_ref 통과·2회 apply delta 0(멱등)·골든 불변·롤백 후 비영속 확인.
4. 트랜잭션 래핑 COMMIT — apply.sql(8스텝) \i 인라인 → 사후 자체검증 가드(\if all_ok) PASS → COMMIT.
5. 사후 독립 재실측 + webadmin 실화면 4항.

## COMMIT 행수 (apply.sql 8스텝)
| 스텝 | 연산 | 행수 |
|---|---|---|
| [1] 074 리네이밍 | UPDATE | 1 |
| [2] 074 면지자재 3종 이관 | INSERT | 3 |
| [3] 074 옵션그룹 OPT_064 이관 | INSERT | 1 |
| [4] 074 옵션 화/블/그 이관 | INSERT | 3 |
| [5] 074 옵션아이템(자재 ref) 이관 | INSERT | 3 |
| [6] 부모 072 OPT_064 은퇴(items3+opts3+grp1) | UPDATE | 3+3+1 |
| [7] 부모 072 면지자재 USAGE.03 은퇴 | UPDATE | 3 |
| [8] 075/076 셋트링크 은퇴 | UPDATE | 2 |
| [8b] 075/076 상품마스터 use_yn=N | UPDATE | 2 |

순서 [HARD] 준수: 자재[2] → 옵션[3~5] → 부모옵션은퇴[6] → 부모자재은퇴[7] (fn_chk_opt_item_ref 트리거 선행조건 충족).
신규 mint 0 (전 코드 라이브 기존 참조). 물리 DELETE 0 (전부 논리삭제 del_yn/use_yn).

## 게이트 결과
- S1~S8 전부 PASS(GO) — `05_gate/leather-hardcover-membrane-260703/gate-report.md`.
- codex reconcile: DISAGREE 0.

## 사후 검증 요약
- DB 재실측: 074 자재3/옵션3/그룹1/아이템3 활성·072 USAGE.03·OPT_064 은퇴·075/076 은퇴·FK 고아 0·복합PK 중복 0.
- 가격 무손상: evaluate_set_price 라이브 실호출 34,100/159,100/796,900(골든 일치·제외 0·PRICE≠0·이중합산 0).
- webadmin 실화면 4항 PASS(제외0·PRICE골든·074 화/블/그 드롭다운 기본화이트·075/076 미노출). 상세=post-verify.md.

## 산출물 (06_load/)
- `leather-hardcover-membrane-072-dryrun.sql` — 롤백전용 DRY-RUN.
- `leather-hardcover-membrane-072-apply-wrapped.sql` — 트랜잭션 래핑 COMMIT본(가드 \if).
- `leather-hardcover-membrane-072-undo.sql` — 역연산(백업 이전상태 환원).
- `leather-hardcover-membrane-072-post-verify.md` — 사후 재실측·evaluate_set_price 무손상.
- (원본 적재본=`03_design/leather-hardcover-membrane-redesign-260703/apply.sql`·`undo.sql`)

## 백업명
`bak_t_prd_products_setbuild072_20260703_0312` 외 5테이블(동일 접미사 `setbuild072_20260703_0312`).

## 계열 전파 준비
- 072 파일럿 COMMIT 완료 → 077/082/088 동형 전파는 **별도 인간 승인 필요**(본 실행 범위 밖·미실행).
- 077(레더 하드커버)·082(하드커버 링): 이전 COMMIT분(§23)과 정합 확인 후 동형 면지 통합 적용 가능. 088=별도 재설계 트랙.
- 전파 시 재사용: 본 apply.sql 8스텝 패턴(자재→옵션→부모은퇴 순서·복합PK 멱등·빈멤버 은퇴) 동형.
