---
name: dbm-schema-change-tracking
description: >
  후니프린팅 라이브 DB의 스키마+적재 소스 오브 트루스인 raw/webadmin(HuniProductPrice2) 코드가 변경됐을 때,
  그 변경을 추적해 ① DB 스키마 구조 변경이력(테이블·컬럼·FK·트리거·인덱스·코드값·적재로직의 add/modify/drop
  타임라인)과 ② 그 변경이 우리 huni-dbmap 매핑 산출(round-2 가격·round-6 CPQ·round-11 loadspec/
  intent-map·round-12 mapping-final·round-13 correctness)을 얼마나 stale하게 만드는지 영향/갱신을 처리하는
  round-14 방법론 스킬. 핵심 = 3-way 정합(webadmin git 선언 / 라이브 information_schema 적용 / 우리 산출
  참조)을 대조하고, DDL 레벨(컬럼 존재)과 데이터 백필 레벨(행 채움)을 분리 추적("컬럼 존재 ≠ 적용 완료")한다.
  베이스라인↔HEAD git diff로 변경을 분류하고, 라이브 실측으로 적용 여부를 확인하고, 영향 매트릭스 + 갱신
  매니페스트를 산출한다. DB·webadmin·우리 산출 직접 수정은 하지 않는다(추적·영향·갱신 라우팅까지).
  'webadmin 변경 추적', '스키마 변경 추적', '스키마 변경이력', 'DB 구조 변경', 'webadmin 코드 변경',
  'sql 변경 추적', '스키마 버전 diff', '스키마 영향 분석', '매핑 stale 점검', 'round-14', '스키마 변경 다시',
  'webadmin 동기화', '스키마 변경 업데이트', 'Phase 변경 추적' 작업 시 반드시 이 스킬을 사용. 엑셀 상품마스터/
  가격표의 버전 변경 추적은 dbm-change-tracking(round-10), 라이브 데이터 적재 정확성 교정은
  dbm-correctness-audit(round-13)이 담당하므로 그 작업에는 트리거하지 않는다.
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, TodoWrite
metadata:
  version: "1.0.0"
  category: "domain"
  status: "active"
  updated: "2026-06-11"
---

# dbm-schema-change-tracking — round-14 webadmin 스키마 변경 추적

## 목적과 프레임 [HARD]

`raw/webadmin`(HuniProductPrice2)은 후니 라이브 DB의 **스키마 정의(`sql/`) + 적재 로직(`tools/`) 소스 오브
트루스**다. 살아있는 프로젝트라 계속 진화한다(Phase 10/11에서 가격엔진·CPQ 제약 재설계 — `constraint_json`
삭제·`use_dims`/`template_prices` 신설). webadmin이 바뀌면 ① 라이브 스키마 구조가 바뀌고 ② 그 구 스키마를
기반으로 만든 우리 매핑 산출이 **stale**해진다.

round-14는 이를 추적·처리한다. round-10(엑셀 상품마스터/가격표의 데이터 *행* 버전 변경)의 **스키마/코드 버전**
대응물이다 — 대상이 데이터 행이 아니라 **DDL 구조 + 적재 로직 + 코드값**이고, 영향 대상이 라이브 행이 아니라
**우리 dbmap 산출**이다.

## 권위·3-way 정합 [HARD]

변경의 진실은 **세 곳을 대조**해야 드러난다 — 하나만 보면 틀린다:

1. **선언된 변경 (webadmin git)** — `raw/webadmin/sql/`(DDL: 01a~NN, 신규 phase sql) + `tools/`(load_master.py·
   cfg_utils.py·deploy.py 등 적재/기대치) + `webadmin/catalog/`(models.py inspectdb 거울·basecodes.py 코드값).
   git diff(베이스라인↔HEAD)가 "무엇이 선언상 바뀌었나"의 권위.
2. **적용된 변경 (라이브 information_schema)** — 읽기전용 psql 실측. 선언이 라이브에 실제로 반영됐나.
   **[HARD] DDL 레벨(컬럼/테이블 존재)과 데이터 백필 레벨(행이 실제로 채워졌나)을 분리** — 신규 컬럼이
   존재해도 0행 채움이면 "선언만, 미적용"이다(Phase 11 교훈: `proc_cd`/`opt_cd` 컬럼 신설됐으나 0행·`prc_typ`
   전부 단가형·`template_prices` 0행). "컬럼 존재 ≠ 적용 완료".
3. **참조하는 우리 산출 (huni-dbmap)** — round-2/6/11/12/13 + `00_schema/`(price-engine-ddl·cpq-schema·
   schema-design-intent-map)·`15_domain-spec/_loadspec/`. 어느 산출이 *삭제·변경된* 스키마를 아직 참조하나.

세 축이 어긋나는 지점이 finding이다: 선언≠적용(백필 미완)·적용≠우리산출(stale)·선언≠우리산출(미인지).

## 베이스라인 식별 [HARD]

추적은 두 시점의 diff다. **베이스라인 = 우리 산출이 분석한 스키마 시점의 webadmin 커밋**(예: round-11
loadspec/intent-map이 본 `sql/01a~15`·`constraint_json` 존재 시점 = `d6026be` 06-09). HEAD = 현재. 베이스라인을
git log로 특정하되, 우리 산출이 인용한 sql 파일/컬럼의 존재 시점으로 교차검증(추측 금지). 이전 추적이 있으면
직전 HEAD가 다음 베이스라인(감사 체인).

## 절차 (S0~S4)

**S0 컨텍스트 확인** — `18_schema-change/<baseline>-to-<head>/` 존재로 초기/재추적 판별. 라이브 접속
`.env.local` `RAILWAY_DB_*`(비밀값 비노출). webadmin 레포는 읽기 전용(수정 금지).

**S1 스키마 변경 분류 (선언, git diff)** — 베이스라인↔HEAD의 `sql/`+`tools/`+`basecodes.py` diff를 분류:
테이블 add/drop · 컬럼 add/modify/drop · PK/FK/인덱스/트리거/제약 변경 · 코드값(seed/basecodes) enum 변경 ·
적재로직(load_master 등) 매핑 변경. 각 항목에 git 커밋 해시·파일:라인 근거. → `schema-change-log.md`.

**S2 라이브 적용 대조 (적용, 읽기전용 실측)** — 각 선언 변경을 라이브 `information_schema`로 실측:
컬럼/테이블 존재(DDL 레벨) + 행수/백필 상태(데이터 레벨). **DDL 갭(선언≠적용)과 백필 갭(컬럼만·0행)을 분리
표기.** → `live-apply-crosscheck.md`(선언·DDL적용·백필 3열).

**S3 우리 산출 영향 매핑 (핵심)** — 각 변경 → 우리 어느 산출의 어느 부분이 stale인지 Grep로 추적(예:
`constraint_json` 참조 파일 전수). 심각도 = CRITICAL(적재값 손상·매핑 무효·재작업)·MAJOR(모델/스펙 문서 stale·
부분 갱신)·MINOR(주석/명칭)·NONE. → `impact-matrix.md`(변경 → 영향 산출 → stale 부분 → 심각도 → 갱신 필요).

**S4 갱신 매니페스트 + 게이트** — 각 stale 항목의 갱신 방향(어느 파일 어느 줄을 무엇으로) 제안 → `update-manifest.md`.
실제 산출 갱신은 라우팅까지(이번 라운드는 추적·영향·제안). `dbm-validator`가 W1~W6 독립 게이트.

## 산출 (write to `_workspace/huni-dbmap/18_schema-change/<baseline>-to-<head>/`, 한국어)

- `schema-change-log.md` — 베이스라인↔HEAD 변경 타임라인 분류표(git 근거).
- `live-apply-crosscheck.md` — 선언/DDL적용/백필 3열 대조(라이브 실측, 비밀값 없이).
- `impact-matrix.md` — 변경 → 우리 산출 영향 매트릭스(심각도·stale 부분).
- `update-manifest.md` — stale 산출 갱신 제안(파일:라인 → 갱신 방향).
- 공유: `18_schema-change/_gate/<pair>-gate.md` — validator 게이트.

## 게이트 W1~W6 (dbm-validator 독립 수행)

| # | 게이트 | 기준 |
|---|--------|------|
| W1 | 베이스라인 정확 | 베이스라인 커밋이 우리 산출 분석 시점과 정합(인용 sql/컬럼 존재 시점 교차검증) |
| W2 | 변경 분류 완전 | git diff의 모든 sql/tools 변경이 schema-change-log에 분류(누락 0, 커밋 해시 실재) |
| W3 | 라이브 적용 대조 | 선언 변경의 DDL 적용 + 백필 상태를 독립 실측 재현(DDL≠백필 분리) |
| W4 | 영향 매핑 완전 | 각 변경의 우리 산출 영향이 Grep 전수로 식별(constraint_json 류 참조 누락 0) |
| W5 | DDL·백필 분리 | "컬럼 존재=적용완료" 오판 0 — 0행 백필을 미적용으로 정직 표기 |
| W6 | 갱신 라우팅 정합 | update-manifest의 갱신 방향이 현 스키마(HEAD)와 정합·기존 행/사슬 무손상 |

## 에러 핸들링·원칙

- **수정 없음 [HARD]** — 본 라운드는 추적·영향·갱신 제안까지. 우리 산출 실제 갱신은 별도(영향 매트릭스 라우팅 후)·webadmin/DB 수정 금지.
- 베이스라인 불명: git log + 우리 산출 인용 교차로 특정, 그래도 모호하면 후보 보고(추측 금지).
- 선언≠적용 갭: 삭제 안 됨/미적용을 finding으로(webadmin 팀 배포 누락 신호일 수 있음).
- 백필 미완: 신규 컬럼/테이블 0행을 "구조만 선언, 데이터 미적용"으로 분류(우리 적재 트랙 round-5 대상일 수 있음).
- 위임 시 인라인 한국어 선호(round-10 교훈). 산출 파일 직접 회수.
