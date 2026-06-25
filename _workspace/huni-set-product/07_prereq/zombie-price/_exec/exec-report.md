# 실행 리포트 — 좀비 자재 2건 부활 라이브 COMMIT

방법론: dbm-load-execution (안전 적재 프로토콜). 사용자 승인 완료.
DB: `railway`(PostgreSQL) · `.env.local RAILWAY_DB_*`(읽기전용 외 2 UPDATE 한정·비밀 비노출).
정명 테이블: `t_prc_component_prices`. 단가값 verbatim·날조 0.

## 결과 한눈
- **부활 2건 COMMIT 완료** — `t_mat_materials` `del_yn 'Y'→'N'`: MAT_000159(모조 120g)·MAT_000119(리브스디자인 250g). UPDATE 2.
- **NO-OP 아님** (실행 전 둘 다 del_yn='Y' 재확인 → 부활 필요).
- **청구 불변 입증 6/6 PASS** — 단가행·배선 일절 미변경, 견적 골든 byte-identical.
- 단가행(t_prc_component_prices)·배선(t_prd_product_materials) **0건 변경**.

## 프로토콜 단계별

| 단계 | 내용 | 결과 |
|---|---|---|
| 1 FK/전제 | 159·119 현재 del_yn 재조회 | 둘 다 'Y' → 부활 진행(NO-OP 아님) |
| | 스키마 실측 | 컬럼=`mat_typ_cd`(문서 `mat_typ` 오기 정정)·PK=mat_cd·CHECK del_yn∈{Y,N}·FK 5개 플립 무관·BEFORE UPDATE 트리거 upd_dt 자동 |
| 2 물리백업 | `bak_t_mat_materials_zombie_20260624_1250` | 2행·부활 전 del_yn='Y'/del_dt 보존 |
| 3 DRY-RUN | BEGIN; UPDATE×2(1차)+UPDATE×2(2차 멱등); ROLLBACK | 1차 UPDATE 2·2차 UPDATE 0(멱등)·제약위반 0·지문 불변·롤백 후 라이브 무변경 |
| 3b APPLY | BEGIN; UPDATE; COMMIT | UPDATE 2 COMMIT |
| 5 사후검증 | 6항목 | 6/6 PASS (post-verify.md) |
| 6 undo | 보유·미실행 | 불일치 0 |

## 산출물 (이 디렉토리)
- `backup.sql` — 물리 백업(실행됨)
- `dryrun.sql` — 롤백전용 멱등+제약 실증(실행됨)
- `apply.sql` — 부활 COMMIT 래핑본(실행됨)
- `undo.sql` — 역연산(미실행·보유)
- `post-verify.md` — 사후검증 6항목
- `exec-report.md` — 본 리포트
- `_golden_{A,B}_{before,after}.tsv` — 견적 불변 골든 증거(diff 0)

## 멱등성·재실행
재실행 안전: 멱등 가드 `WHERE del_yn='Y'`. 이미 부활됨 → 재-DRYRUN UPDATE 0(POST-⑥).

## 범위 엄수
2행 한정 광역 쓰기 없음. 권고2(죽은 배선 정리)·CONFIRM(159=073 통합·119 root)은 이번 실행 제외(요청대로).
