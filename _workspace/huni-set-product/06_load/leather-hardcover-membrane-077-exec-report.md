# 077 레더 하드커버책자 면지 통합 재설계 — 적재 실행 리포트 (COMMIT 완료)

> §23 Huni-Set-Product · hsp-load-executor · 2026-07-03 · **라이브 COMMIT 성공**
> 실행 전제: 게이트 S1~S8 GO + codex reconcile 합의(072 per-set 전파 4항 독립 CLOSE) + 인간 승인(077 "이어서 전파") — 3조건 충족.

## 결과: **COMMIT 성공** · 사후 골든/webadmin 4항 전부 PASS · undo 불필요

## 실행 순서 (안전 프로토콜)
1. FK 선행 확인 — 6상품(077/078/079/080/081/285) 전부 t_prd_products 실재·077=TYPE.01·나머지 TYPE.02. 080/081 전역 역참조=077 단독(은퇴 안전).
2. 물리 백업 — `bak_*_setbuild077_20260703_0353` 6테이블(products4·sets5·materials3·optgrp1·options3·optitems3).
3. 롤백전용 DRY-RUN(`BEGIN…ROLLBACK`) — 카운트 정확·트리거 fn_chk_opt_item_ref 통과·2회 apply delta 0(멱등)·COVERBIND 골든 불변·FK 고아 0·롤백 후 비영속(079 mat=0) 확인.
4. 트랜잭션 래핑 COMMIT — apply-077.sql(8스텝) \i 인라인 → 사후 자체검증 가드(\if all_ok) PASS → COMMIT.
5. 사후 독립 재실측 + evaluate_set_price 골든 무손상 + webadmin 실화면 4항.

## COMMIT 행수 (apply-077.sql 8스텝)
| 스텝 | 연산 | 행수 |
|---|---|---|
| [1] 079 리네이밍(→"레더 하드커버책자-면지") | UPDATE | 1 |
| [2] 079 면지자재 3종 이관(MAT_382/383/384 USAGE.03) | INSERT | 3 |
| [3] 079 옵션그룹 OPT_065 이관 | INSERT | 1 |
| [4] 079 옵션 화/블/그(OPV_437/438/439) 이관 | INSERT | 3 |
| [5] 079 옵션아이템(자재 ref OPT_REF_DIM.03) 이관 | INSERT | 3 |
| [6] 부모 077 OPT_065 은퇴(items3+opts3+grp1) | UPDATE | 3+3+1 |
| [7] 부모 077 면지자재 USAGE.03 은퇴 | UPDATE | 3 |
| [8] 080/081 셋트링크 은퇴 | UPDATE | 2 |
| [8b] 080/081 상품마스터 use_yn=N | UPDATE | 2 |

순서 [HARD] 준수: 자재[2] → 옵션[3~5] → 부모옵션은퇴[6] → 부모자재은퇴[7] (fn_chk_opt_item_ref 트리거 선행조건 충족·DRY-RUN·COMMIT 둘 다 통과).
신규 mint 0 (전 코드 라이브 기존 참조). 물리 DELETE 0 (전부 논리삭제 del_yn/use_yn).

## 게이트 결과
- S1~S8 전부 PASS(GO) — `05_gate/leather-hardcover-membrane-260703/077/gate-report.md`.
- codex reconcile: 072 DISAGREE 0 + per-set 전파 요건 4항(079/080/081 base=0·역참조 스윕 0·USAGE.07 077 해당없음·088 무충돌) 게이트 독립 재실측 CLOSE.

## 사후 검증 요약
- DB 재실측: 079 자재3/옵션3/그룹1/아이템3 활성·077 USAGE.03·OPT_065 은퇴·080/081 은퇴·FK 고아 0·복합PK 중복 0.
- 가격 무손상: evaluate_set_price 라이브 실호출 34,100/159,100/796,900(apply 전=후 일치·제외 0·PRICE≠0·이중합산 0·warnings 0).
- webadmin 실화면 4항 PASS(제외0·PRICE골든·079 화/블/그 드롭다운 기본화이트·080/081 미노출). 상세=post-verify.md.
- 이전 077 동작화(COVERBIND 티어·내지285 자재9종) 보존 확인.

## 산출물 (06_load/)
- `leather-hardcover-membrane-077-backup.sql` — 물리 백업(시점 스냅샷 문서).
- `leather-hardcover-membrane-077-dryrun.sql` — 롤백전용 DRY-RUN.
- `leather-hardcover-membrane-077-apply-wrapped.sql` — 트랜잭션 래핑 COMMIT본(가드 \if all_ok).
- `leather-hardcover-membrane-077-undo.sql` — 역연산(이전상태 환원).
- `leather-hardcover-membrane-077-post-verify.md` — 사후 재실측·evaluate_set_price 무손상.
- (원본 적재본=`03_design/leather-hardcover-membrane-redesign-260703/077/apply-077.sql`·`undo-077.sql`)

## 백업명
`bak_t_prd_products_setbuild077_20260703_0353` 외 5테이블(동일 접미사 `setbuild077_20260703_0353`).

## 계열 전파 상태
- **077 면지 통합 COMMIT 완료** (072 파일럿 → 077 동형 전파 완주).
- **082**(하드커버 링): 별도 인간 승인 필요 — 미실행. ★082 부모 USAGE.07 자재 불가침 이슈(072/077과 달리 표지자재 보유) 존재 → 재설계·게이트 별도 트랙. 077 COMMIT이 082 무변경 확인(활성멤버 6 불변).
- **088**(레더 링바인더): 별도 재설계 트랙(9,000/부 표지 member + 싸바리 배선)·별도 승인 — 미실행. 088 무변경 확인(활성멤버 5 불변).
- 전파 시 재사용: 본 apply-077.sql 8스텝 패턴(자재→옵션→부모은퇴 순서·복합PK 멱등·빈멤버 은퇴) 동형. 단 082는 USAGE.07 은퇴 금지 가드 추가 필요.
