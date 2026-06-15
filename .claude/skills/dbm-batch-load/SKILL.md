---
name: dbm-batch-load
description: 후니프린팅 270 상품을 동형 클래스(동일 옵션구성×동일 가격계산방식) 단위로 묶어 결정적 스크립트로 배치 적재하는 방법론. 한 건씩 에이전트가 조립·검증·백업하던 비효율을 제거 — 상태 분류(출시/미출시/신규예정)·선결 게이트(컬럼 완정성)·배치 멱등 UPSERT·SQL 집계 전수 검증·백업은 위험 변경만. "배치 적재", "배치 처리", "동형 상품 묶음 적재", "대량 적재", "270 상품 일괄", "스크립트 배치", "효율 적재", "집계 검증", "배치 다시", "배치 재실행", "상품 분류 적재", "동일 옵션구성 적재" 작업 시 반드시 이 스킬을 사용. 단건 적재본 조립은 dbm-load-execution, 한 시트 매핑 설계는 dbm-mapping/dbm-price-formula가 담당하므로 그 작업에는 트리거하지 않는다.
---

# dbm-batch-load — 동형 클래스 배치 적재

## Why (한 건씩이 왜 안 되나)

270 상품을 에이전트가 하나씩 (엑셀 읽기→라이브 조회→SQL 조립→백업→DRY-RUN→검증→COMMIT) 처리하면 **상품 수에 비례해 토큰·시간이 폭증**한다(7행에 173K 토큰). 그런데 후니 상품은 대부분 **소수의 반복 패턴**(같은 옵션구성 + 같은 가격계산방식)을 공유한다. 한 패턴의 변환 규칙을 **결정적 스크립트로 한 번 고정**하면, 그 패턴의 전 상품을 **배치 한 번**으로 처리할 수 있다. 에이전트는 매번 조립하지 않고 스크립트를 **호출**하며, 예외·실패만 컨텍스트로 본다.

핵심 = **무거운 일은 Bash 스크립트(토큰 ~0), 에이전트는 분류·예외 판정·집계 검토만.**

## 5단계 파이프라인

### S1. 분류 (Classify) — 무엇을 배치할 수 있나
상품을 두 축으로 분류한다(`scripts/classify.py` — 라이브 + 엑셀 실측, 추측 0):

1. **상태축**: ① **정확등록가능**(컬럼 완정·기초데이터 정합 = 배치 대상) ② **신규출시예정**(컬럼 완정성 미확인 = 선결 필요) ③ **미출시**(use_yn=N·정체 미확정 = 제외).
2. **동형축**: **동일 옵션구성**(같은 option_groups/items 패턴) × **동일 가격계산방식**(같은 PRF_* 공식 클래스 = round-18+ 15클래스). 같은 (옵션패턴, 가격클래스) = 한 동형 클래스 = 한 배치.

산출 = 분류 매트릭스(`_workspace/huni-dbmap/3X_batch/classification.md`): 클래스ID × 소속 상품 × 상태 × 배치가능 여부.

> **[HARD] 동형 판정은 표면 시트가 아니라 (옵션구성, 가격계산방식) 실측.** 같은 시트라도 가격클래스가 다르면 다른 배치. 다른 시트라도 동형이면 같은 배치(예: 엽서·상품권 둘 다 PRF_DGP_A 합산형).

### S2. 선결 게이트 (Precondition) — 값이 먼저 제대로 등록됐나
배치 적재 **전에** 각 클래스의 엔티티/속성 값이 제대로 등록됐는지 검증한다(사용자 [HARD]: "값이 먼저 제대로 등록되어야 이후 안전"). round-19 `dbm-product-readiness`(컬럼 readiness)·round-13 `dbm-correctness-audit`(정합 교정) 재사용:
- 기초 차원(siz/mat/proc/clr) 적재·정합 · 출력용지규격 plate 정합([[dbmap-platesize-is-output-paper]]) · 가격사슬 배선 존재.
- **미달 클래스는 배치 제외** → 선결 트랙(plate 교정·siz 채번·correctness)으로 라우팅 후 재진입. 억지 배치 금지.

### S3. 배치 변환 (Transform) — 결정적 스크립트로 SQL 생성
동형 클래스 1개당 변환 규칙 1개. `scripts/gen_batch_upsert.py`가 엑셀 L1 CSV(또는 기존 `06_extract`·`02_mapping/scripts` 산출 재사용) → **멱등 UPSERT SQL 배치** 생성:
- **멱등 = NOT EXISTS NULL-safe 가드**(ON CONFLICT 금지 — 자연키 인덱스 `NULLS DISTINCT`라 NULL 차원서 미발화·[[dbmap-live-load-transition-260615]]).
- **apply_ymd = '2026-06-01' 고정**(단가행 적용일 분기 금지 = 가격 이중계상 방지).
- reg_dt 컬럼 생략(DEFAULT now())·IDENTITY PK 비명시·FK 위상 순서.
- 산출 = 클래스별 `batch_<class>.sql` + `provenance.csv`(행별 출처).

### S4. DRY-RUN + SQL 집계 검증 (한 번에)
`scripts/apply_batch.sh`(기본 DRY-RUN = BEGIN…ROLLBACK) + `scripts/verify_batch.sql`:
- **DRY-RUN 멱등 2-pass**: 1-pass delta = N신규 → 2-pass delta = 0(멱등 실증).
- **SQL 집계 전수 검증**(verify_batch.sql 파라미터화): 가격표↔라이브 전 행 diff · FK 고아 · NOT NULL 위반 · 자연키 중복 · 단가 권위값 불일치. **출력 = 통과 N · 실패 M · 예외 목록 CSV**(행별 토큰 0).
- 에이전트(dbm-validator 집계 모드)는 **실패·예외만** 검토(생성≠검증). 전건 PASS면 GO.

### S5. COMMIT (GO 후) — 배치 단위 1회
집계 GO 후 `apply_batch.sh commit` → 배치 전 상품 COMMIT(한 클래스 한 번). COMMIT 후 재집계(영속 행수·멱등 2회차 신규 0).

## 백업 정책 (사용자 확정 — 위험 변경만)
- **일상 멱등 UPSERT는 백업 불요** — 단일 트랜잭션 ROLLBACK + 멱등 재적재 + 국소 DELETE로 복구. 매 적재 `CREATE TABLE bak_*`는 **과한 프로세스**(폐기).
- **경량 안전망 = git-tracked baseline CSV**: 배치 전 영향 테이블 `SELECT … \copy` 읽기전용 덤프를 `_workspace`에 1회(git 추적). 되돌림은 멱등 재적재 또는 baseline diff.
- **DB 내부 백업(`CREATE TABLE bak_*`)은 위험 변경 직전 1회만**: DDL · 대량 DELETE · 비가역 UPDATE · 트랜잭션 롤백으로 못 되돌리는 변경. 일반 INSERT/UPSERT 배치는 해당 없음.

## 컨텍스트 최소화 원칙
- 대량 데이터·SQL은 파일/DB에 두고 Bash로 실행(스크립트 출력은 집계만 컨텍스트로).
- 에이전트 프롬프트엔 클래스 요약·예외 목록만(전 행 나열 금지).
- 스크립트는 재현성(손편집 금지·결정적)·재실행 가능. 기존 `02_mapping/scripts`·`06_extract/scripts`·`20_price-import/*/build_import_workbook.py` 자산 재사용(중복 작성 금지).

## 안전 불변 [HARD]
- 멱등 = NOT EXISTS NULL-safe(ON CONFLICT 신뢰 금지). apply_ymd=2026-06-01 고정. 단가행 적용일 분기 금지.
- 권위 = 가격표/상품마스터 엑셀 명시값(라이브는 교정 대상). 보정 하드코딩 0.
- 생성(gen)≠검증(verify). 집계 PASS 없이 COMMIT 금지. 실 COMMIT은 인간 승인(배치 GO 후).
- 미달 클래스 억지 배치 금지 — 선결 미충족은 제외·라우팅.

## scripts 번들
| 스크립트 | 역할 |
|----------|------|
| `scripts/classify.py` | 상태축×동형축 분류 → classification.md/csv |
| `scripts/gen_batch_upsert.py` | 클래스별 엑셀 L1 → 멱등 NOT EXISTS UPSERT SQL + provenance |
| `scripts/verify_batch.sql` | 집계 전수 검증(diff·FK·NULL·중복·멱등) → 통과/실패/예외 |
| `scripts/apply_batch.sh` | DRY-RUN(기본)·commit·baseline 덤프. 백업 위험시만 |

> 스크립트는 라이브 스키마·클래스별 매핑에 맞춰 적용 시 채운다(골격 제공). 상세 패턴은 `references/batch-patterns.md`.

## 테스트 시나리오
- 정상: 동형 클래스 1개(예: PRF_DGP_A 합산형 엽서+상품권) 분류 → 선결 PASS → gen → DRY-RUN 멱등 → 집계 GO → COMMIT → 재집계.
- 예외: 선결 미달(plate 미교정) 클래스 → 배치 제외·선결 트랙 라우팅 보고. / 집계 실패(가격 불일치 1행) → COMMIT 차단·예외 보고.
