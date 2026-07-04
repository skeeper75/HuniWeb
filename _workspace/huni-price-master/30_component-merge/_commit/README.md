# 가격구성요소 병합 9군 · 라이브 COMMIT 배치 준비 (dbm-load-execution · 2026-07-04)

> **상태: 인간 승인 대기.** 실 COMMIT / DELETE / UPDATE 영속 반영 **0건 수행**. 라이브에는 읽기전용 SELECT + 롤백전용 DRY-RUN(BEGIN…게이트…ROLLBACK)만 실행했다.
> **명명:** clean mint(정본 base 신규·멤버 논리삭제·단가행 562 재지정·fc 34→12). **엔진 무변경·DDL 불요.**

## 판정 요약
- **배치 A (8군·무조건 GO):** MC-02~09 (명함 8종). 양측 검증 GO + 라이브 사전실측 게이트 전건 통과.
- **배치 B (MC-01·조건부 GO):** 엽서북 PCB. 468 halt 하드게이트 + 옵션(a) 재명명 **별도 인간 승인** 필요.

## 사전 SELECT 실측 결과 (게이트 통과여부 · `00-prestate-verify.sql` 실행 2026-07-04)

| 게이트 | 실측 | 판정 |
|---|---|---|
| ① 정본 9종 사전부재 (혼재 0 뿌리) | 9종 전건 **부재**(clean mint 정당) | **PASS** |
| ③ nat_key(15열) 충돌 (MC-02~09) | 전군 **0** | **PASS** |
| 멤버 단가행수 (이관 기대 대조) | 28·36·4·10·4·8·2·2 = 명함 94 · PCB 468+117×3 → **562 재지정 정합** | **PASS** |
| ② 멤버 fc 참조 (재배선 대상) | PREMIUM/STD/PEARL=2, 그외=1, PCB_S1_20P=1 → 재배선 후 0 목표 | 기준 확보 |
| ★MC-01 S1_20P 행수 (468 halt) | **468 / 4콤보** | **PASS(안전상태)** |
| 12 PRF 영향공식 실재 | **12/12 존재** | **PASS** |
| 3테이블 PK/제약 | components(comp_cd)·formula(frm_cd,comp_cd)·prices(comp_price_id)+nat_key unique idx | 확인 |

## 멱등 실증 (`03-idempotency-proof.md` · 라이브 롤백전용)
- 9군 전건 **2회 적용→ROLLBACK PASS** (멱등·실행가능·제약위반0). 핵심 뮤테이션 PASS2=0행.

## 산출물 (`_workspace/huni-price-master/30_component-merge/_commit/`)
| # | 파일 | 용도 | 실행시점 |
|---|---|---|---|
| 0 | `00-prestate-verify.sql` / `00b-schema-probe.sql` | 사전 상태·제약 실측(read-only) | 승인 전(완료) |
| 1 | `01-backup.sql` | 물리 백업(3테이블·CREATE TABLE AS) | **COMMIT 직전** |
| 2 | `02-commit/mc-0{1..9}-*-commit.sql` | 게이트4종 하드어서션 내장 COMMIT SQL | **군별 인간 승인+webadmin 후** |
| 3 | `03-idempotency-proof.md` · `03-dryrun-idem/*.sql` | 롤백전용 멱등 실증(결과+스크립트) | 완료 |
| 4 | `04-undo.sql` | 백업 복원(회귀) | 실패 시 |
| 5 | `05-post-remeasure.sql` | 사후 재실측(무손상·FK고아0·혼재0·골든등가) | **COMMIT 후** |
| 6 | `06-webadmin-checklist.md` | 실화면 확인(제외0·PRICE≠0·판형·단양면·골든) | **COMMIT 후·다음군 전** |
| - | `gen_commit_sql.py` · `build_idem.py` | 결정론 생성기(provenance) | — |

## 실행 순서 (인간 승인 후·군별 원자 단계)
1. `01-backup.sql` 실행(백업 3테이블 생성·행수 26/913/48 확인).
2. 해당 군 `02-commit/mc-0X-*-commit.sql`에서 **맨 끝 `COMMIT;` 유지** → 실행(게이트 통과 시 영속, 위반 시 RAISE→자동 abort).
3. `06` 체크리스트로 webadmin 실화면 확인(제외0·PRICE≠0·병합 전후 동일가).
4. `05-post-remeasure.sql`로 무손상 재실측. 이상 시 `04-undo.sql`(COMMIT) 복원.
5. 다음 군 반복. 배치 A 순서 = MC-05→06→08→09→02→07→03→04. 배치 B(MC-01)는 최후·별도 승인.

## ★인간 승인 대기 지점 (여기서 정지)
- **[승인-A]** 배치 A 8군 COMMIT 개시 승인 (군별 또는 일괄).
- **[승인-B]** 배치 B MC-01 **옵션(a) 재명명**(S1_20P→COMP_PCB) 승인 + 468 halt 통과 확인.
- **[게이트]** 각 군 COMMIT 후 webadmin 실화면 GO 확인 없이는 다음 군 진행 금지.

**확인: 이 준비 단계에서 실 COMMIT/DDL/영속 변경은 하지 않았다.** 라이브 = 읽기전용 SELECT + 롤백전용 DRY-RUN만.
