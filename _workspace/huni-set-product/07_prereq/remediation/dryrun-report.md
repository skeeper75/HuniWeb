# DRY-RUN 리포트 — 자재 교정(롤백전용 2회) · material-remediation

실행: 2026-06-24 · 라이브 Railway DB(db railway) · **전 트랜잭션 ROLLBACK**(라이브 무변경) · 비밀값 비노출
대상: apply.sql 즉시 실행 10행(MAT_000246 전용지 부활 + 종이 root 9 부활). CONFIRM 보류분 미포함.

> **판정: GO(apply.sql 인간 승인 후 COMMIT 가능).** 제약위반 0·멱등 delta 0·FK 고아 정합(64→23)·undo round-trip 정확·CONFIRM 범위 무손상.

---

## PASS 1 — apply + 멱등/제약/FK 검증 (BEGIN…ROLLBACK)

| 단계 | 측정 | 기대 | 결과 | 판정 |
|---|---|---|---|---|
| PRE 대상 사멸수 | targets del_yn='Y' | 10 | **10** | OK |
| PRE FK 고아(자식 활성·부모 사멸) | orphans | 64 | **64** | 기준선 |
| APPLY P2-A | affected | 1 | **1** | OK(전용지 부활) |
| APPLY P3-A | affected | 9 | **9** | OK(종이 root 9 부활) |
| POST 대상 활성수 | targets del_yn='N' | 10 | **10** | OK |
| POST FK 고아 | orphans | 23 | **23** | OK(9 root 자식 41건 정합·64→23) |
| **멱등 재실행 delta** | affected | 0 | **0** | ✅ 멱등(WHERE IS DISTINCT FROM 가드 작동) |
| CHECK 위반(del_yn/use_yn 도메인) | count | 0 | **0** | ✅ 제약위반 없음 |
| ROLLBACK 후 라이브 | still del_yn='Y' | 10 | **10** | ✅ 라이브 원상복구 |

해석: FK 고아 64→23 감소 = 부활한 종이 root 9개의 활성 자식 41건이 살아있는 부모를 가리키게 됨. 잔여 23 = **비종이 root(P3-B·CONFIRM)** 와 자식0 root 산하 — apply 범위 밖(의도적으로 미부활). 이는 누락이 아니라 CONFIRM 분리.

---

## PASS 2 — apply→undo round-trip + CONFIRM 격리 (BEGIN…ROLLBACK)

| 단계 | 측정 | 기대 | 결과 | 판정 |
|---|---|---|---|---|
| BACKUP 스냅샷 | 10행·전부 Y | 10/10 | **10/10** | OK |
| AFTER APPLY | del_yn='N' | 10 | **10** | OK |
| AFTER UNDO(백업복원) | del_yn='Y' | 10 | **10** | ✅ undo round-trip 정확 |
| CONFIRM 격리: 면지 4종 | 여전히 활성(N) | 4 | **4** | ✅ apply가 면지 미접촉 |
| CONFIRM 격리: 면지 배선행 | product_materials 행수 | 14 | **14** | ✅ 배선 미접촉 |

해석: backup.sql→apply.sql→undo.sql 사슬이 완전 가역. CONFIRM 보류분(면지 자재·배선·NO_ROOT)은 apply.sql이 **절대 건드리지 않음** 실증 — 권위 미특정 영역 무손상.

---

## 게이트 종합

| 게이트 | 결과 |
|---|---|
| 제약위반 0 (CHECK·FK·PK) | ✅ |
| 예상 delta = 10 UPDATE (1+9) | ✅ |
| 멱등(재실행 delta 0) | ✅ |
| FK 고아 정합(64→23, 부활분 자식 복구) | ✅ |
| undo round-trip 정확(백업복원) | ✅ |
| CONFIRM 범위 무손상(면지·배선·NO_ROOT) | ✅ |
| search-before-mint 위반(신규 mint) | **0** ✅ |
| 돈 영향(component_prices 신규/변경) | **0원** ✅ |
| 물리 DELETE / DDL | **0** ✅ |
| 라이브 변경(전 트랜잭션 ROLLBACK) | **0** ✅ |

**최종: apply.sql GO** — 인간 승인 후 dbm-load-execution이 BEGIN/COMMIT 래핑하여 적용. backup.sql 선실행 권장(undo 방식1 정확복원 기반).
</content>
