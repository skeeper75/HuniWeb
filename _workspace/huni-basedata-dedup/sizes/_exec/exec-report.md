# exec-report — 사이즈 축 D-1 안전 적재 실행 보고

실행: 2026-06-19 / hbd-load-executor (hbd-load-execution 방법론)
대상: **D-1 단 1건** — SIZ_000105(카드봉투 사이즈 화면 중복) → 정본 SIZ_000104 무손실 통합
명세: `apply-plan.md` (verbatim 준수) / 권위: 라이브 t_* 직접 재실측 + del_yn 논리삭제 권위

## 실행 대상 필터 (hbd-load-execution §1)

| 조건 | 충족 | 근거 |
|---|:---:|---|
| (a) 사용자 승인 | ✓ | "D-1 적재 승인(백업→DRY-RUN→COMMIT)" |
| (b) 합의 | ✓ | dedup-report §D-1 재판정 GO·codex-verdict 정합 |
| (c) price_dependent=N | ✓ | component_prices(SIZ_000105)=0 실측 |

→ D-1 1건만 실행. D-2(A3 174/315)·D-3(A2 197/317) pd=Y BLOCKED·경로 Y, SIZ_000499, 잔존 충돌그룹 = 미실행(명세 제외 준수).

## 안전 프로토콜 이행

1. 자격증명 `.env.local RAILWAY_DB_*` (PG* env, stdout 비노출).
2. 물리 백업: `bak_siz_basedata_dedup_20260619_0800`(**2행**)·`bak_prdsiz_basedata_dedup_20260619_0800`(**2행**).
3. dryrun/apply 분리 [HARD]: apply.sql 본문 BEGIN/COMMIT 무내장. 롤백전용 DRY-RUN 2-pass(delta 1/1·제약위반 0·no-drift) → 별도 COMMIT.
4. 멱등 가드: (a) `WHERE … del_yn='N'` · (b) `WHERE del_yn='N'`. 재-dryrun delta 0,0.
5. 무손실: 물리 DELETE 0(바인딩행은 명세상 물리 제거 — 정본 104가 이미 바인딩되어 무손실·재배선 불필요). 단가행 보존(영향 0).
6. undo: `undo.sql` 보유.

## COMMIT 결과

| 변경 | 테이블 | delta | 백업 |
|---|---|:---:|---|
| 멤버 바인딩 제거 | t_prd_product_sizes | DELETE 1 | bak_prdsiz_basedata_dedup_20260619_0800 |
| 멤버 논리삭제 (del_yn Y) | t_siz_sizes | UPDATE 1 | bak_siz_basedata_dedup_20260619_0800 |

총 교정 = 2 (= D-1 merge 1건). INSERT 0·물리 DELETE 1(바인딩행). 가격행·정본·타 상품 무영향.

## 사후검증 (전건 GO — 상세 post-verify.md)

V1 멤버 논리삭제·정본 활성 GO / V2 PRD_000004 사이즈 단일(중복 해소) GO / V3 멤버 외부참조 0 GO / V4 FK 고아 0 GO / V5 멱등 재-dryrun delta 0 GO.

★ **카드봉투(PRD_000004) 사이즈 화면 중복 해소 확인** — `165x115mm(10장)` 중복 2행 → 정본 SIZ_000104 단일(dflt_yn=Y) 유지.

## 산출물 (`_exec/`)

`backup.sql` · `dryrun.sql` · `apply.sql` · `undo.sql` · `post-verify.md` · `exec-report.md`

## 잔여 (미실행 — 컨펌/경로 Y)

- D-2 A3(174/315)·D-3 A2(197/317): pd=Y → 경로 Y(개발자 v03 재적재). 라이브 직접 금지.
- SIZ_000499 판형 모델링 컨펌 큐(실행영향 0).
- 나머지 28 충돌그룹 멤버별 가드 1:1 재검(다음 라운드).

## 정리 참고

- 백업 테이블 `bak_siz_basedata_dedup_20260619_0800`·`bak_prdsiz_basedata_dedup_20260619_0800`는 undo 안전망 — GO 확정 안정화 후 사용자 승인 하에 DROP(undo.sql §B).
