---
name: hbd-load-execution
description: >
  후니프린팅 기초데이터 표시중복 정리 하네스의 승인 후 안전 적재 실행 방법론. 승인+codex 합의+가격비종속
  행만 라이브 t_*에 정리(정본+논리삭제+재배선)·정규화·신규 적재로 COMMIT. 물리 백업→롤백전용 DRY-RUN
  (멱등·제약위반0·delta 실증)→최종 승인→COMMIT→사후 재실측→undo 보유. dryrun/apply 분리(내장 BEGIN/COMMIT
  금지), BLOCKED·divergence 미실행, 멱등 가드, NO-OP. 트리거: 안전 적재, 정리 실행, 멱등 UPSERT,
  논리삭제 재배선, DRY-RUN, 백업, 사후검증, 적재 다시.
license: Apache-2.0
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, TodoWrite
metadata:
  version: "1.0.0"
  category: "domain"
  status: "active"
  updated: "2026-06-19"
  tags: "load, commit, idempotent, backup, dry-run, basedata"
---

# hbd-load-execution — 승인 후 안전 적재 방법론

## 원칙

잘못 적재되지 않는 것이 최우선. 승인·합의·가격비종속 세 조건을 모두 만족한 행만 실행하고, 백업·DRY-RUN·사후 재실측으로 무손상을 입증한다.

## 절차

1. **실행 대상 필터 [HARD]**. mapping 행이 (a) 사용자 승인 (b) codex reconcile 합의 (c) `price_dependent=N` 또는 가격비종속 신규 — 셋 다 만족하는 행만. 하나라도 불충족이면 제외·보고.
2. **물리 백업**. 영향 테이블 영향 행을 `bak_<table>_basedata_dedup_<YYYYMMDD_HHMM>`로 복제. 백업 행수 기록.
3. **dryrun/apply 분리 [HARD]**. apply SQL에 BEGIN/COMMIT 내장 금지. 먼저 `BEGIN; ... ROLLBACK;` 으로 멱등(2회 delta 0)·제약위반0·예상 INSERT/UPDATE/DELETE 카운트 실증. 별도 단계에서만 COMMIT.
4. **멱등 가드**:
   - 신규: `INSERT ... WHERE NOT EXISTS` 또는 `ON CONFLICT DO NOTHING`, 채번 MAX+1·separator '_'
   - 정규화(표시명): `UPDATE ... WHERE <col> <> <new> AND del_yn='N'`
   - 통합(논리삭제): `UPDATE ... SET del_yn='Y' WHERE <member> AND del_yn='N'` + 참조 재배선(바인딩·단가행 정본 지시)
5. **무손실**. 물리 DELETE 금지. 단가행 값 보존. 통합은 정본 채택 + 멤버 논리삭제 + 재배선(권위 del_yn: [[dbmap-del-yn-soft-delete-authority]]).
6. **사후검증**. COMMIT 후 라이브 재실측: ① 예상 delta 일치 ② FK 고아 0 ③ 멱등(재-dryrun delta 0) ④ component_prices 영향 0. 불일치 시 undo 복구.
7. **undo·통과**. 역연산(백업 복원) 스크립트 보유. 실행 대상 0건이면 COMMIT 없이 "통과(NO-OP)" 보고.

## 산출물

`_workspace/huni-basedata-dedup/<axis>/_exec/`: `backup.sql`·`dryrun.sql`·`apply.sql`·`undo.sql`·`post-verify.md`·`exec-report.md`.

## 하지 말 것

- 승인/합의/가격비종속 미충족 행 실행.
- apply SQL에 BEGIN/COMMIT 내장(비인가 COMMIT).
- 통합을 물리 DELETE로.
- 백업·DRY-RUN 없이 COMMIT.
