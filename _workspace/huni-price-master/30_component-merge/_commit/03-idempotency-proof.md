# 03 · 롤백전용 DRY-RUN 멱등 실증 결과 (라이브 실행·2026-07-04)

> **방법:** 각 군 COMMIT SQL 본문을 **한 트랜잭션 안에서 2회 연속 적용 → ROLLBACK**(영속 없음).
> 2회차에도 사전·사후 게이트가 전부 통과하면 **멱등(재실행 0변경)+실행가능(R3)+제약위반0(R5)** 증명.
> **실행 스크립트:** `03-dryrun-idem/*.sql` (생성기 `build_idem.py`가 `02-commit/*.sql`에서 자동 파생).
> **자격증명:** `.env.local` `RAILWAY_DB_*` 읽기(값 미노출). psql read/rollback. **실 COMMIT 0.**

## 결과 종합 — 9군 전건 PASS (FAIL 0)

| 군 | 2회적용→ROLLBACK | 사전게이트①③ | 사후게이트②+구조골든 | 제약위반 |
|---|---|---|---|---|
| MC-01 PCB | **PASS** | halt(안전상태)·혼재0·충돌0 | 멤버fc0·정본468·S1_20P잔존0·nat_key유일 | 0 |
| MC-02 PREMIUM | **PASS** | 혼재0·충돌0 | 멤버fc0·정본28·잔존0·유일 | 0 |
| MC-03 FOIL | **PASS** | 혼재0·충돌0 | 멤버fc0·정본36·잔존0·유일 | 0 |
| MC-04 WHITE | **PASS** | 혼재0·충돌0 | 멤버fc0·정본4·잔존0·유일 | 0 |
| MC-05 STD | **PASS** | 혼재0·충돌0 | 멤버fc0·정본10·잔존0·유일 | 0 |
| MC-06 COAT | **PASS** | 혼재0·충돌0 | 멤버fc0·정본4·잔존0·유일 | 0 |
| MC-07 PEARL | **PASS** | 혼재0·충돌0 | 멤버fc0·정본8·잔존0·유일 | 0 |
| MC-08 SHAPE | **PASS** | 혼재0·충돌0 | 멤버fc0·정본2·잔존0·유일 | 0 |
| MC-09 MINISHAPE | **PASS** | 혼재0·충돌0 | 멤버fc0·정본2·잔존0·유일 | 0 |

## 멱등 증거 (대표 실측 · verbose 행수)

**MC-05 (2공식):**
```
=== PASS 1 ===  INSERT 0 1 · UPDATE 10 · DELETE 4 · INSERT 0 2 · UPDATE(bystander) 1·1·1
=== PASS 2 ===  INSERT 0 1 · UPDATE 0  · DELETE 0 · INSERT 0 2 · UPDATE(bystander) 1·1·1
```
- 핵심 뮤테이션(단가행 이관 UPDATE·멤버 fc DELETE)이 **PASS2에서 0행** → 재실행 무변경(멱등).
- INSERT는 `ON CONFLICT DO UPDATE`(멱등). bystander disp_seq UPDATE는 **동일값 재기입**(net 변경 0·가격 무관·무해). 정본 단가행수=10 불변(이중적용 아님).

**MC-01 (배치B·halt):**
```
=== PASS 1 ===  DELETE 1(PRF_PCB_FIXED 멤버배선) · INSERT 0 1(정본배선) · 단가행 UPDATE 468
=== PASS 2 ===  DELETE 0 · INSERT 0 1 · 단가행 UPDATE 0
```
- PASS2에서 DELETE 0·단가행 UPDATE 0 → 멱등.
- ★halt 게이트 = **안전상태만 통과**로 설계: (첫실행 S1_20P=468) 또는 (이미적용 COMP_PCB=468&S1_20P=0). PASS2(이미적용 상태)도 통과 = 재실행 안전. 스냅샷상태(각117 회귀) 시 즉시 RAISE 중단(부분이관 언더차지 방어) — 초기 검증에서 실제 발동 확인 후 멱등 안전으로 정정.

## 게이트 4종 = 트랜잭션 내 하드어서션(RAISE→abort)로 내장
- ① 정본+멤버 혼재 0 (반쯤적용 방어·codex D1) · ③ nat_key(15열) 충돌 0 — **사전** DO 블록.
- ② 멤버 comp formula 참조 0 · 구조적 골든 등가(정본 단가행수=기대 AND 정본 내부 nat_key 유일) — **사후** DO 블록(COMMIT 전).
- ④ 골든 재계산 0오차 = 행수준(백업 대비 unit_price 불변, `05-post-remeasure.sql` ⑥) + **엔진레벨은 webadmin 시뮬레이터**(`06`)로 사후 확정. evaluate_price는 DB 함수 아님(앱 pricing.py)이라 트랜잭션 내 어서션 불가.
- ★MC-01 추가: `COMP_PCB_S1_20P=468` COMMIT-halt 하드게이트(≠안전상태 즉시중단).

**결론:** 9군 전건 멱등·실행가능·제약위반0(라이브 롤백전용 실증). 실 COMMIT 0.
