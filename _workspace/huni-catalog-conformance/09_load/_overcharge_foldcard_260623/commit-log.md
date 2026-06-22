# commit-log.md — §21 접지카드 과대청구 교정 라이브 COMMIT 기록

> §21 카탈로그 정합 · 2026-06-23 · **인간 승인 완료 → 라이브 운영 DB 실 COMMIT**.
> 대상: PRD_000027/028/029 (2단/미니/3단접지카드) · 공식 PRF_DGP_E · 4 FOLD_LEAF comp.
> 프로토콜: dbm-load-execution 안전 시퀀스(백업→채번 재실측→DRY-RUN→COMMIT→사후검증→undo 보유).

---

## 0. 실행 결과 한 줄

접지방식 4 comp가 판별축(proc_cd) 없이 **4개 접지비(25,000) silent 전부 합산**(과대청구)되던 결함을,
기초코드 2건 신규 등록 + 4 comp proc_cd 충전 + use_dims 토큰 등재로 **P8-1 택일 분리(25,000→6,000)**.
**단가값 0변경(verbatim)** · COMMIT 성공 · 멱등 확인 · undo 보유.

---

## 1. 안전 시퀀스 단계별 결과

| 단계 | 내용 | 결과 |
|------|------|------|
| 0. 물리 백업 | 변경 대상 행 현재값 timestamped SELECT 스냅샷 | `backup-20260623_012612.sql` (verbatim 기준선 192행/138,606 캡처) |
| 1. 채번 재실측 | MAX num 재확인(stale 방지) | **MAX=105 → 106/107 유효**. 동명 행 0(멱등 안전) |
| 2. Phase A (FK 선행) | PROC_000106·107 멱등 INSERT | **INSERT 2건** (ON CONFLICT (proc_cd) DO NOTHING) |
| 3. Phase B | 4 comp proc_cd 충전 + use_dims 토큰 | **UPDATE 192행 + use_dims 4건** (unit_price SET 0) |
| 4. DRY-RUN 재확인 | 기본 ROLLBACK·멱등·FK·verbatim | verbatim PASS·FK PASS·멱등 2회 0행·P8 25000→6000 |
| 5. ★COMMIT | apply.sql COMMIT 모드 | **COMMIT 성공 (exit 0)**·G-1/G-2 트랜잭션 내 PASS |
| 6. 사후검증 | 별도 연결 영속 확인 | 전 항목 PASS (§ post-verify.md) |
| 7. undo 보유 | 되돌리기 스크립트 | `undo.sql` (DRY-RUN 검증·미실행) |

## 2. 채번 재실측 (stale guard)

```
SELECT max(CAST(substring(proc_cd from 6) AS int)) FROM t_proc_processes WHERE proc_cd ~ '^PROC_[0-9]+$';
→ 105  (변동 없음 — 106/107 유효)
SELECT ... WHERE proc_cd IN ('PROC_000106','PROC_000107');  → 0행 (충돌 없음)
SELECT ... WHERE proc_nm IN ('4단대문접지','반접지');        → 0행 (동명 부재·멱등 INSERT 안전)
max(disp_seq) WHERE upr='PROC_000056'  → 18  (disp_seq 19·20 유효)
```

## 3. Phase A — 기초코드 마스터 2건 신규 (멱등 ON CONFLICT)

| proc_cd | proc_nm | upr_proc_cd | disp_seq | use_yn | del_yn | note |
|---------|---------|-------------|:--:|:--:|:--:|------|
| PROC_000106 | 4단대문접지 | PROC_000056(접지) | 19 | Y | N | (none) |
| PROC_000107 | 반접지 | PROC_000056(접지) | 20 | Y | N | 1폴드 2패널(2단접지 PROC_000059와 별개) |

- 4ACC = **PROC_000071(병풍접지) 재사용** (등록 액션 0).
- ★PROC_000059(2단접지) 무변경 — 반접지와 별개 공정 보존.

## 4. Phase B — 4 comp 단가행 proc_cd 충전 (verbatim 불변)

| comp_cd | proc_cd(충전) | 단가행 | sum_price(불변) | use_dims |
|---------|--------------|:--:|:--:|----------|
| COMP_FOLD_LEAF_3FOLD | PROC_000060(3단접지·기존) | 48 | 31,965.00 | `["proc_cd","min_qty","proc_grp:PROC_000056"]` |
| COMP_FOLD_LEAF_4ACC | PROC_000071(병풍·재사용) | 48 | 41,110.00 | 〃 |
| COMP_FOLD_LEAF_4GATE | PROC_000106(신규) | 48 | 41,110.00 | 〃 |
| COMP_FOLD_LEAF_HALF | PROC_000107(신규) | 48 | 24,421.00 | 〃 |

- **unit_price SET 구문 0개** (정적 보장) · 총계 138,606.00 불변(기준선 일치).
- 트랜잭션 내 G-1(verbatim)·G-2(FK 고아 0) 가드 모두 PASS.

## 5. COMMIT 명령 출력 (요약)

```
BEGIN → INSERT 0 1 / INSERT 0 1 → UPDATE 48×4 + use_dims 4
NOTICE: VERBATIM GUARD PASSED → NOTICE: FK GUARD PASSED → COMMIT  (exit 0)
```

## 6. 되돌리지 말 것 (메모리용)

- t_proc_processes **PROC_000106(4단대문접지)·PROC_000107(반접지)** 신규 행 — del_yn=N·use_yn=Y 보존.
- 4 comp 단가행 **proc_cd 충전**(3FOLD=060·4ACC=071·4GATE=106·HALF=107) + use_dims **proc_cd 토큰** 보존.
- 이 교정으로 PRD_000027/028/029 접지비 silent 합산 25,000 과대청구 해소(택일=6,000~7,000).
- 되돌릴 경우만 `undo.sql`(위상 역순: 단가행 NULL→use_dims 원복→신규코드 논리삭제).
