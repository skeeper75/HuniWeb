---
name: dbm-axis-staged-load
description: >
  후니프린팅 상품마스터를 6개 기초데이터 축(① 기초코드 t_cod_base_codes · ② 사이즈 t_siz_sizes ·
  ③ 도수 t_clr_color_counts · ④ 자재 t_mat_materials · ⑤ 공정 t_proc_processes · ⑥ 카테고리
  t_cat_categories) 기준으로 단계별 교정·적재하는 round-22 방법론 스킬. 라이브에 이미 적재됐으나 매핑
  오류가 있는 상태(자재축 색/형상/사이즈 오염·도수↔별색 혼동·카테고리 고아·prd_typ 오귀속)를 교정한다.
  **★핵심 판정(03 분석): 6축 오류 진원은 전부 ⓐ(입력 v03 엑셀) — webadmin load_master는 무변환 전파기로
  도메인 변환 없이 v03 셀값을 TRUNCATE 후 그대로 INSERT.** 따라서 교정 = 라이브 직접 SQL(경로 X·임시·재적재
  시 소멸)이 아니라 **입력 v03을 권위(상품마스터/인쇄상품가격표)로 바로잡은 교정 입력 엑셀을 재적재(경로 Y·근본·
  P-TRUNCATE 안전)**가 정답. [HARD] webadmin 소스 코드 수정 금지(개발자 GitHub 배포·read-only oracle).
  권위=상품마스터+인쇄상품가격표(v03 배제). 6축 정답 규칙은 인쇄도메인+경쟁사(WowPress/RedPrinting/CIP4)
  흡수 판정으로 정립. 경로 Y 3조건(시트명/헤더 v03 동일·행순/surrogate 코드 보존[삭제=use_yn N·신규=말미
  append]·개발자가 입력파일 교체+재적재). 산출=교정 입력 엑셀 + 검증(롤백 DRY-RUN/라이브 대조) + 개발자
  ⓑ 코드 백로그(C-1~C-6). X1~X6 게이트. 실 재적재는 개발자 협업·실 COMMIT 인간 승인. '6축 적재', '6축 교정',
  '기초데이터 단계 적재', '기초코드 사이즈 도수 자재 공정 카테고리', '축별 매핑 교정', '상품마스터 단계별 적재',
  '매핑 오류 교정', '교정 엑셀', 'webadmin 재적재', '경로 X 경로 Y', 'v03 교정', '라이브 6축 재실측',
  '축 우선 종단', 'round-22', '6축 적재 다시', '특정 축만 교정', '자재 오염 교정', '카테고리 재연결',
  'P-TRUNCATE 가드' 작업 시 반드시 이 스킬을 사용. 단일 스냅샷 매핑 설계는 dbm-mapping, 라이브 정합 교정
  일반은 dbm-correctness-audit, 적재본 조립·실행은 dbm-load-readiness/dbm-load-execution, CPQ 옵션 레이어는
  dbm-cpq-option-mapping이 담당하므로 그 단독 작업에는 트리거하지 않는다. 본 스킬은 그것들을 6축 staged·
  교정엑셀 재적재 렌즈로 조율하는 메타 트랙이다.
license: Apache-2.0
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, TodoWrite, Skill
metadata:
  version: "2.0.0"
  category: "domain"
  status: "active"
  updated: "2026-06-16"
  tags: "huni-dbmap, round-22, 6축, 기초데이터, staged-load, 매핑교정, 교정엑셀, 경로Y, axis"
  related-skills: "huni-dbmap-orchestrator, dbm-correctness-audit, dbm-loadspec-extract, dbm-load-execution, dbm-cpq-option-mapping"
---

# dbm-axis-staged-load — 6축 기초데이터 staged 교정·적재 (round-22, v2 경로 Y)

[HARD] 산출물(`_workspace/huni-dbmap/32_axis-staged-load/` 하위 .md·xlsx·CSV·SQL)은 **한국어**로 쓴다. 식별자·t_*·컬럼·코드값·SQL·시트명·헤더는 원본(주로 한글 시트명 + English 코드) 보존. 스폰하는 모든 에이전트에 동일 지시.

## 목적·범위

상품마스터 엑셀을 **6개 기초데이터 축** 기준으로 라이브 `t_*` DB에 단계별 교정·적재한다. 이미 적재됐지만 매핑 오류가 있는 상태를, 인쇄도메인 + 경쟁사 권위로 정립한 정답 규칙으로 교정한다. **설계+검증+DRY-RUN/대조까지** 산출하고, 실 적재(개발자 재적재) + 코드 백로그는 인간 승인·협업이다.

## ★핵심 판정 — 왜 "교정 엑셀 재적재(경로 Y)"인가 (03 분석)

webadmin `tools/load_master.py`는 **무변환 전파기**다 — v03 엑셀 시트 셀값을 `TRUNCATE … CASCADE` 후 그대로 INSERT하며 도메인 의미를 변환하지 않는다(유일한 코드 교정은 `ENUM_ALIAS`/`MAT_TYP_OVERRIDE` 라벨 사전뿐). 따라서:

- **6축 오류 진원 = 전부 ⓐ(입력 v03 엑셀).** 자재축 색/형상 오염·카테고리 고아 모두 **v03 시트가 그렇게 인코딩한 것을 무변환 전파**한 결과이지, 코드 결함(ⓑ)이 아니다. 순수 ⓑ 없음.
- 그러므로 라이브 행만 SQL로 고치는 **경로 X는 증상 교정**이고, 개발자가 `load_master --all` 재실행하면 `TRUNCATE`로 **전부 소멸**한다.
- **경로 Y = 진원 v03 입력을 권위로 바로잡은 교정 입력 엑셀을 재적재** → 근본 교정 + 재적재에도 영속(P-TRUNCATE 안전). **이것이 정답.**

> 이 판정이 round-22 v1(라이브 직접 SQL + P-TRUNCATE 가드)을 대체한다. 권위 = `03_webadmin-load-path-analysis.md`.

## [HARD] 두 절대 제약

1. **webadmin 소스 코드 수정 금지.** `raw/webadmin`(HuniProductPrice2)은 개발자가 GitHub로 배포하는 라이브 코드. `load_master.py`·`sql/`를 우리가 **고칠 수 없다**(read-only oracle). 코드 수정이 불가피한 영역은 개발자 백로그(C-1~C-6)로 분리·요청.
2. **권위 = 상품마스터 + 인쇄상품가격표 엑셀. v03 엑셀은 오염원 — 정답 아님.** 6축 필요 정보가 모호하면 인쇄도메인 지식 + 경쟁사 리서치(WowPress/RedPrinting/CIP4)로 확정한다. v03 인용·참조 금지.

## 권위 산출 (단일 진실원 — 항상 먼저 읽어라)

- `01_axis-authority-rules.md` — 6축 정답 규칙(경계 충돌 15케이스·정규화·FK 위상).
- `02_axis-error-diagnosis.md` — 6축 횡단 오류 진단·축별 교정 의사결정 트리.
- `03_webadmin-load-path-analysis.md` — **경로 X/Y 판정·진원 ⓐ/ⓑ·load_master 입력 메커니즘·ⓑ 백로그**(v2 핵심).
- `04_live-remeasure-260616.md` — 착수 전 6축 라이브 전수 재실측(fresh 행수·가격사슬 안전 실측).

## 6축 ↔ t_* + v03 입력 시트

| 축 | 마스터 t_* | v03 입력 시트 | loader(file:line) | 관계 t_* |
|----|-----------|--------------|-------------------|----------|
| ① 기초코드 | `t_cod_base_codes` | (SEED `sql/05_seed.sql`) | — | (참조 enum) |
| ② 사이즈 | `t_siz_sizes` | 04_사이즈정보 | `load_sizes:194` | product_sizes·plate_sizes |
| ③ 도수 | `t_clr_color_counts` | 03_도수정보 | `load_color_counts:181` | product_print_options |
| ④ 자재 | `t_mat_materials` | 05_자재정보 | `load_materials:227` | product_materials |
| ⑤ 공정 | `t_proc_processes` | 06_공정정보 | `load_processes:210` | product_processes |
| ⑥ 카테고리 | `t_cat_categories` | 01_카테고리 | `load_categories:164` | product_categories |

입력 엑셀 경로 = `load_master.py:39` 상수 `XLSX="data/raw/prdmaster_full_migration_v03_…xlsx"` (하드코딩·`main`은 경로 인자 미수신).

## 두 교정 경로 (경로 Y 우선)

| | 경로 Y (교정 엑셀 재적재) — **1순위·근본** | 경로 X (라이브 직접 SQL) — 보조 |
|--|------------------------------------------|-------------------------------|
| 방식 | v03을 권위로 바로잡은 교정 입력 엑셀을 개발자가 재적재 | 우리가 라이브 t_* UPDATE/INSERT |
| 코드 수정 | 0 (입력 파일만 교체) | 0 |
| P-TRUNCATE | 🟢 안전(교정이 입력에 영속) | 🔴 재적재 시 소멸 |
| 적용 주체 | 개발자(load_master 실행) | 우리(인간 승인 후) |
| 용도 | 전 축 근본 교정 | 긴급·개발자 부재 시 임시(소멸 전제 명시) |

기본은 경로 Y. 경로 X는 "다음 재적재 전까지만 유효"를 명시할 때만, 그리고 가역 UPDATE(카테고리 재연결·mat_typ 정정)에 한해 보조적으로.

## [HARD] 경로 Y 3조건 (교정 엑셀 빌드 규칙)

1. **시트 구조 v03 동일** — 시트명·헤더 컬럼명·코드 컬럼을 v03과 1바이트도 다르지 않게. `read_sheet`(`:55`)가 `wb[시트명]`·`dict(zip(헤더,행))`로 읽으므로 다르면 KeyError 실패.
2. **행순·surrogate 코드 보존** — `issue`(`:152`)가 엑셀 **행순**으로 `CAT/SIZ/MAT/PROC` surrogate를 재발급한다. 행 추가/삭제/재정렬 시 기존 라이브 PK(SIZ_000xxx 등)와 어긋나 **가격사슬(component_prices.siz_cd/mat_cd)·관계행 파손**. 따라서 **기존 행순·코드 보존 / 삭제=`use_yn='N'`(행 제거 아님) / 신규=말미 append**. (PRD는 `identity=True`·`:252`라 재적재해도 PK 불변·안전.)
3. **개발자 재적재** — 입력 경로가 `:39` 하드코딩이라 우리가 주입 불가. 개발자가 교정 엑셀을 v03 자리에 교체 + `load_master --all`. 코드 수정 0.

## 6축 경계 정답 규칙 (오염 0 재발 — 01 §충돌표 요약)

별색=공정(PROC_000007·clr_cd=NULL, 도수 아님) · 색/형상/사이즈/용량/구수/인쇄면≠자재(단 본체색 2~3종=재질행 합성은 정답) · 두께=자재(평면화 금지) · 코팅/박=공정 · UV변형=공정 param(print_side 아님) · 판걸이수=앱 런타임(DB 미저장) · 출력판형=판형축(plate_sizes) · 시트 `구분`≠카테고리. 모호·판정 불가 → 🔴 escalate(추측 금지·컨펌 AX-1~7/B-1~13).

## 6축 staged 교정 순서 (교정 엑셀 시트별)

순서 = **기초코드 → 사이즈 → 도수 → 자재 → 공정 → 카테고리**(축 우선). 각 축은 해당 v03 시트의 교정본을 만든다(경로 Y). 가역 고효과(04 재실측 권장)부터:

1. **⑥ 카테고리(P1·최고효과·완전가역)** — `01_카테고리` 고아 14노드의 `상위카테고리코드` 채움 + `11_상품별카테고리` 113상품 페어를 정상 잎노드로 재연결. 가격 무관.
2. **④ 자재 mat_typ 정정(P1·가역)** — `05_자재정보` mat_typ 정정(레더 .06 등은 `MAT_TYP_OVERRIDE` 이미 커버·잔존 점검). 색/형상/용량/구수 비소재 행은 `use_yn='N'` + 정확 축(색→option·형상→siz) 적재 **후** 비활성. **04 재실측: 오염 자재행은 component_prices 0건 참조 → 가격사슬 안전, 단 product_materials 64상품 연결 → CPQ/siz 재배선 선행.**
3. **② 사이즈** — `04_사이즈정보`·`13_상품별사이즈` 평면화 정정·경계(size↔option) 결정분. **기계 size 삭제 금지(가격사슬)**.
4. **③ 도수** — 변경 거의 없음(5행 고정·별색 분리 정상). ④에서 재귀속될 잉크색 판정만.
5. **⑤ 공정** — `06_공정정보`·`14_상품별자재` 누락 공정/연결 행 **말미 append**(봉제/보드/삼각대/미싱). 신규 공정 mint는 ①(SEED) 동반.
6. **① 기초코드** — 신규 코드그룹/코드는 SEED(`sql/05_seed.sql`) 또는 교정 엑셀. 코드 수정 영역이면 C-1~C-6 백로그.

## 검증 게이트 X1~X6 (dbm-validator 독립 판정, 생성≠검증)

| 게이트 | 검사 | 통과 기준 |
|--------|------|-----------|
| X1 | **권위 정합** | 교정이 상품마스터/가격표 권위 기반·v03 미참조·인쇄도메인/경쟁사 근거 |
| X2 | **6축 freshness** | 착수 전 라이브 전수 재실측(04 갱신)·stale 인용 0 |
| X3 | **경계오염 0** | 별색=공정·색≠자재 등 정답 규칙 재발 0 |
| X4 | **교정 엑셀 구조 보존** | 시트명/헤더 v03 동일·행순/surrogate 보존(삭제=use_yn N·신규=append)·KeyError 0 |
| X5 | **재적재 검증** | 교정 엑셀 롤백전용 DRY-RUN 또는 라이브 대조 — surrogate 라이브 동일 매핑·제약위반0·FK고아0 |
| X6 | **비파괴·독립·코드불변** | webadmin 코드 수정 0·hard-delete 0(use_yn)·생성자≠검증자 |

## 산출 구조

```
_workspace/huni-dbmap/32_axis-staged-load/
├── 01_axis-authority-rules.md      02_axis-error-diagnosis.md (권위·완성)
├── 03_webadmin-load-path-analysis.md  04_live-remeasure-260616.md (경로판정·재실측)
├── _corrected_xlsx/<sheet>/        (교정 입력 엑셀·v03 시트 미러·내용 권위 교정)
├── _verify/<axis>/                 (롤백 DRY-RUN·라이브 대조 로그)
├── _gate/<axis>-gate.md            (X1~X6 GO/NO-GO·dbm-validator)
└── _backlog/developer-code-changes.md (C-1~C-6 개발자 협업 요청)
```

## 실 적재 (경로 Y — 개발자 협업)

우리 산출 = **교정 입력 엑셀 + 검증(X1~X6 GO) + 개발자 백로그**. 실제 라이브 변경 = 개발자가 교정 엑셀을 `data/raw/` v03 자리에 교체 + `load_master --all` 재적재(코드 수정 0). 재적재 후 라이브 6축 재실측으로 발효 확인. **실 재적재·코드 백로그 적용 = 인간 승인·개발자 협업.** 경로 X(직접 SQL)를 보조로 쓸 때만 우리가 라이브를 직접 변경하되, 다음 재적재 시 소멸함을 명시하고 가역 UPDATE에 한한다.

## 개발자 ⓑ 코드 백로그 (C-1~C-6 — 교정 엑셀로 못 닫는 코드 강제 영역)

C-1 MES_ITEM_CD NULL 강제(`:261`) · C-2 qty_unit NULL(`:269`) · C-3 constraint_json 폐기(`:270`) · C-4 입력 엑셀 경로 하드코딩(`:39`·`:517`·`main`에 경로 인자 추가 권장) · C-5 P-TRUNCATE 재실행 가드(경로 X 채택 시만 필수) · C-6 ENUM_ALIAS/MAT_TYP_OVERRIDE 확장(교정 엑셀 대안). 상세=`03 §5`. **개발자에게 요청·우리가 코드 수정 안 함.**

## 에이전트 매핑 (재사용 — 신규 에이전트 0)

| 작업 | 에이전트 | 스킬 |
|------|----------|------|
| 6축 정답 규칙·도메인·경쟁사 | `dbm-domain-researcher` | dbm-mapping-research |
| 6축 오류 진단·교정 의사결정 | `dbm-correctness-auditor` | dbm-correctness-audit |
| webadmin 적재경로·loadspec | `dbm-loadspec-extractor` | dbm-loadspec-extract |
| 교정 엑셀 빌드·검증 SQL | `dbm-load-builder` | dbm-load-execution |
| 신규 코드/공정/siz DDL 제안 | `dbm-ddl-proposer` | dbm-load-execution |
| X1~X6 독립 게이트 | `dbm-validator` | (본 스킬 게이트) |
| 색→옵션 CPQ 적재 | `dbm-option-mapper` | dbm-cpq-option-mapping |

생성과 검증은 항상 분리(X6).

## 컨펌 큐 (인간 승인 — 자동 진행 금지)

- **개발자 협업:** 교정 엑셀 재적재(경로 Y) · ⓑ 백로그 C-1~C-6 코드 수정 · 경로 X 직접 SQL.
- **도메인:** AX-1 잉크색 귀속 · AX-2 size→option 사슬 보존 · B-3 자재 분리 · B-6 size↔option 경계 · B-7 신규 공정. 미결정은 BLOCKED로 분리·중단 없이 다음 축.

## 후속 실행

- `_corrected_xlsx/` 존재 + "특정 축만" → 해당 시트 교정본만 갱신(04 재실측 먼저).
- "6축 재실측"/"매핑 오류 다시" → 04 재실측부터 전 축 freshness 재확인.
- 가격축(STAGE 5)은 범위 밖 — round-2/16/18로 라우팅.

ARGUMENTS: $ARGUMENTS
