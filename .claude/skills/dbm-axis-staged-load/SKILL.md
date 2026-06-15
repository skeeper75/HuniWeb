---
name: dbm-axis-staged-load
description: >
  후니프린팅 상품마스터를 6개 기초데이터 축(① 기초코드 t_cod_base_codes · ② 사이즈 t_siz_sizes ·
  ③ 도수 t_clr_color_counts · ④ 자재 t_mat_materials · ⑤ 공정 t_proc_processes · ⑥ 카테고리
  t_cat_categories) 기준으로 단계별 교정·적재하는 round-22 방법론 스킬. 이미 라이브에 적재됐으나 매핑
  오류가 있는 상태(자재축에 색/형상/사이즈 오염·도수↔별색 혼동·카테고리 고아·prd_typ 오귀속)를, 인쇄도메인
  + 경쟁사(WowPress/RedPrinting/CIP4) 권위로 정립한 6축 정답 규칙과 축별 교정 의사결정 트리로 교정한다.
  핵심 전제 [HARD] = ① P-TRUNCATE 재실행 가드(load_master가 6축 전부 TRUNCATE CASCADE 후 무변환 재적재
  → 가드 없으면 모든 교정 무효) ② 착수 전 6축 라이브 전수 재실측(라이브 부분 진화로 진단 stale). FK 위상
  staged 순서(기초코드 SEED → ②~⑥ 병렬 마스터 → 상품 → 연결행 → CPQ → 가격) + 멱등 UPSERT + 롤백전용
  DRY-RUN(X1~X6 게이트)까지 산출. DB 직접 쓰기·실 COMMIT/DDL/논리삭제는 인간 승인. '6축 적재', '6축 교정',
  '기초데이터 단계 적재', '기초코드 사이즈 도수 자재 공정 카테고리', '축별 매핑 교정', '상품마스터 단계별 적재',
  '매핑 오류 교정', '라이브 6축 재실측', '축 우선 종단', 'round-22', '6축 적재 다시', '특정 축만 교정',
  '자재 오염 교정', '카테고리 재연결', 'P-TRUNCATE 가드', '6축 staged 적재 업데이트' 작업 시 반드시 이 스킬을
  사용. 단일 스냅샷 매핑 설계는 dbm-mapping, 라이브 정합 교정 일반은 dbm-correctness-audit, 적재본 조립·실행은
  dbm-load-readiness/dbm-load-execution, CPQ 옵션 레이어는 dbm-cpq-option-mapping이 담당하므로 그 단독 작업에는
  트리거하지 않는다. 본 스킬은 그것들을 6축 staged 렌즈로 조율·교정하는 메타 트랙이다.
license: Apache-2.0
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, TodoWrite, Skill
metadata:
  version: "1.0.0"
  category: "domain"
  status: "active"
  updated: "2026-06-16"
  tags: "huni-dbmap, round-22, 6축, 기초데이터, staged-load, 매핑교정, axis"
  related-skills: "huni-dbmap-orchestrator, dbm-correctness-audit, dbm-load-execution, dbm-cpq-option-mapping"
---

# dbm-axis-staged-load — 6축 기초데이터 staged 교정·적재 (round-22)

[HARD] 산출물(`_workspace/huni-dbmap/32_axis-staged-load/` 하위 .md·CSV·SQL)은 **한국어**로 쓴다. 식별자·t_*·컬럼·코드값·SQL·CSV 헤더는 English. 스폰하는 모든 에이전트에 동일 지시.

## 목적·범위

상품마스터 엑셀을 **6개 기초데이터 축** 기준으로 라이브 `t_*` DB에 단계별 교정·적재한다. 이미 적재됐지만 매핑 오류가 있는 상태를 인쇄도메인 + 경쟁사 권위로 정립한 정답 규칙으로 교정하는 것이 핵심이다. **설계+검증+롤백전용 DRY-RUN까지** 산출하고, 실 COMMIT·DDL·논리삭제는 인간 승인이다(기존 하네스 원칙).

**왜 6축인가:** 이 6축은 webadmin `raw/webadmin/tools/load_master.py`가 상품마스터 시트를 라이브에 적재하는 **실제 단위**다(SEED 기초코드 → L1 마스터 5축 → 상품 → 관계테이블). 매핑 오류의 진원이 이 적재 로직에 있으므로, 같은 축으로 조망해야 결함을 정확히 짚고 교정한다.

## 권위 산출 (단일 진실원 — 복제 금지, 항상 이 파일을 먼저 읽어라)

- `_workspace/huni-dbmap/32_axis-staged-load/01_axis-authority-rules.md` — **6축 매핑 정답 규칙**: 각 축의 정의·경계(오염 패턴)·권위 컬럼·도메인 판별·경쟁사 흡수 판정·정규화·FK 위상 + 경계 충돌 15케이스 + 통합 5단계 적재 순서 + 컨펌 AX-1~7.
- `_workspace/huni-dbmap/32_axis-staged-load/02_axis-error-diagnosis.md` — **6축 횡단 오류 진단 + 축별 교정 의사결정 트리**: 라이브 실측 오류 보드·축별 판정 플로우·staged 교정 6단계·차단 B-1~13.

이 스킬 본문은 그 두 산출의 **운영 규칙 요약 + 게이트**다. 상세 규칙·근거·케이스는 위 두 파일이 권위다.

## 6축 ↔ t_* 대응

| 축 | 마스터 t_* | 관계 t_* | 코드 prefix | 비고 |
|----|-----------|----------|-------------|------|
| ① 기초코드 | `t_cod_base_codes` | (참조 enum) | `<그룹>.NN` 의미코드 | self-ref·13 코드그룹·SEED 완료 |
| ② 사이즈 | `t_siz_sizes` | `t_prd_product_sizes`·`_plate_sizes` | `SIZ_` | 작업/재단 이중축·impos_yn |
| ③ 도수 | `t_clr_color_counts` | `t_prd_product_print_options` | `CLR_` | chnl_cnt 0~4·5행 고정 |
| ④ 자재 | `t_mat_materials` | `t_prd_product_materials` | `MAT_` | mat_typ_cd·usage_cd·self-ref |
| ⑤ 공정 | `t_proc_processes` | `t_prd_product_processes` | `PROC_` | self-ref family·prcs_dtl_opt JSON |
| ⑥ 카테고리 | `t_cat_categories` | `t_prd_product_categories` | `CAT_` | self-ref 트리·cat_lvl 1~3 |

공통 원리: 6축 모두 **마스터(공유 사전) ↔ 상품연결행** 2계층. 같은 값을 잘못된 축에 넣지 않는 것이 핵심(기계적 매핑 금지·`schema-design-intent-map`).

## [HARD] 두 절대 전제 (착수 전 무조건)

### 전제 1 — P-TRUNCATE 재실행 가드 (1순위 선결, B-1)
`load_master.py`는 6축 load 함수가 **전부 `TRUNCATE … CASCADE` 후 무변환 재INSERT**다(:168 cat·:185 clr·:198 siz·:214 proc·:231 mat·:253 prd). `--all` 재실행 시 **모든 라이브 교정이 소멸**한다. 따라서 어떤 축을 교정하든, **재실행 금지 정책 또는 교정 보존 로직이 결정되기 전에는 staged 적재가 무의미**하다. 이것을 가장 먼저 인간 승인 큐에 올린다.

### 전제 2 — 6축 라이브 전수 재실측 (stale 방지)
라이브는 **부분 진화**한다(예: 레더 MAT_TYPE .08→.06 이미 교정됨·del_yn=Y 흔적). 진단 문서(02)는 작성 시점 스냅샷이라 stale 위험이 있다. 착수 시 6축 t_* 행수·코드값 분포·오염 의심 행을 **읽기전용 SELECT로 전수 재실측**하고 02를 갱신한 뒤 교정에 들어간다. "문서가 그렇다"로 진행 금지 — 라이브가 권위.

## 6축 경계 정답 규칙 (오염 0 재발 — 01 §충돌표 요약)

- **별색 ≠ 도수** → 별색은 **공정**(`PROC_000007` family·clr_cd=NULL). 도수축(③)은 CMYK 채널수만.
- **색·형상·사이즈·용량·구수·인쇄면 ≠ 자재** → 자재축(④) 오염 핵심. 색→옵션/도수·형상→사이즈(칼틀 1:1) 또는 공정·용량/사이즈→사이즈·구수→묶음수·인쇄면→print_side. 단 **본체색(2~3종)=재질행 합성은 정답**(과분할 아님).
- **두께 = 자재**(아크릴 1.5/3/8mm = 별 mat_cd). 단일 평면화로 두께 소실 금지(반대 오염).
- **코팅·박 = 공정**. 복합표기 `아트250+무광코팅` = 자재(아트250)+공정(무광) 분해.
- **UV 변형 = 공정 param**(`PROC_000002`). print_side 오적재 금지.
- **판걸이수(판수) = 앱 런타임 계산·DB 미저장**. siz/가격 컬럼 매핑 금지(note 보존만).
- **출력판형 = 판형축**(`t_prd_product_plate_sizes`). 완성품 사이즈와 별 연결축.
- **시트 `구분` ≠ 카테고리**. 판매분류는 `t_cat_categories`(별개).
- 모호·판정 불가 → 🔴 escalate(추측 금지). 컨펌은 AX-1~7(01) / B-1~13(02).

## 6축 staged 교정·적재 단계 (FK 위상)

순서 = **기초코드 → 사이즈 → 도수 → 자재 → 공정 → 카테고리**(사용자 지정 축 우선). 단 FK 위상·"논리삭제는 항상 마지막" 원칙상 실제 실행은 마스터→연결→논리삭제로 재배열된다(각 단계에 명시). 각 단계 = 멱등 `INSERT … ON CONFLICT DO UPDATE`(키=자연키·upd_dt 변경로그) + 롤백전용 DRY-RUN 절차.

1. **① 기초코드** — 신규 코드그룹/코드 선적재 제안(USAGE 본체/부속·OPT_REF_DIM param). 직접 INSERT 금지·인간 승인.
2. **② 사이즈** — 형상/용량 유입분 신규 siz·평면화 정정 UPDATE. **가격사슬 의존**(component_prices.siz_cd CASCADE) — 삭제·재키 전 사슬 영향 확인. 기계삭제 금지.
3. **③ 도수** — 축 자체 변경 거의 없음(5행 고정). ④에서 재귀속될 잉크색 판정만. 별색이 ⑤공정에 남아있는지 확인.
4. **④ 자재** (최대 교정) — (a) mat_typ UPDATE(점착지 .11·잔존 레더 .06) (b) 비소재 자재행(색/형상/용량/구수/인쇄면)은 **정확 축 적재 검증 후** use_yn='N' 논리삭제 (c) 코팅 평면화 분해. 색→option은 CPQ(6단계) 선행 의존 → **논리삭제는 6단계 이후**.
5. **⑤ 공정** — 신규 공정 mint(미싱제본·보드마운팅·삼각대거치 — search-before-mint·선적재 제안) + 상품-공정 연결 INSERT(봉제/에폭시 등 자식0) + mand_proc_yn 정정.
6. **⑥ 카테고리 + CPQ + 논리삭제 일괄** — 113상품 cat_cd UPDATE 의미매칭 재연결(기계순 금지) + CPQ option_items 적재(④색·②폰기종 유입) + **재연결·재적재 검증 후** 빈 고아노드·오염 자재행·page 잡음 use_yn='N' 논리삭제(항상 마지막).

**FK 적용 실행순서:** [0] 신규 마스터 mint → [1] 마스터 UPDATE → [2] 카테고리 재연결 → [3] 상품-공정 연결 → [4] CPQ option_items → [5] 가격(범위 외·round-2/16) → [6] 논리삭제 일괄.

축별 교정 의사결정 트리(이 행이 이 축에 맞는가? 아니면 어느 축?)는 `02 §2`가 권위 — 자재/카테고리/공정/사이즈 각 플로우를 그대로 적용한다.

## 검증 게이트 (X1~X6 — dbm-validator 독립 판정, 생성≠검증)

| 게이트 | 검사 | 통과 기준 |
|--------|------|-----------|
| X1 | **P-TRUNCATE 가드** | 재실행 가드(정책/보존로직) 결정·문서화. 미결정이면 NO-GO(전제 1) |
| X2 | **6축 라이브 freshness** | 착수 전 6축 전수 재실측·02 갱신. stale 인용 0 |
| X3 | **경계 정답 규칙 정합** | 별색=공정·색≠자재 등 오염 0 재발(교정 후 재오염 없음) |
| X4 | **멱등성** | 2-pass DRY-RUN delta 0·`ON CONFLICT` 키 정확 |
| X5 | **라이브 DRY-RUN** | 단일 트랜잭션 BEGIN…ROLLBACK·제약위반 0·FK 고아 0·COMMIT 0 |
| X6 | **비파괴·독립성** | hard-delete 0(논리삭제만)·search-before-mint·생성자≠검증자 |

게이트는 round-13 K1~K6·round-5 R1~R6를 6축 staged 관점으로 특화한 것. 적재본 자체 게이트(G/R)는 dbm-load-execution이, 정합 근거(K)는 dbm-correctness-audit이 담당 — 본 게이트는 6축 staged 고유 위험(P-TRUNCATE·freshness·경계오염)을 추가로 검사한다.

## 산출 구조

```
_workspace/huni-dbmap/32_axis-staged-load/
├── 01_axis-authority-rules.md     (정답 규칙 — 권위·완성)
├── 02_axis-error-diagnosis.md     (오류 진단·교정 DT — 권위·착수 시 재실측 갱신)
├── _exec_<axis>/                  (축별 멱등 SQL·로더·DRY-RUN 로그)
└── _gate/<axis>-gate.md           (X1~X6 GO/NO-GO·dbm-validator)
```

## 에이전트 매핑 (재사용 — 신규 에이전트 0)

| 작업 | 에이전트 | 스킬 |
|------|----------|------|
| 6축 정답 규칙·도메인·경쟁사 | `dbm-domain-researcher` | dbm-mapping-research / dbm-column-domain |
| 6축 오류 진단·교정 의사결정 | `dbm-correctness-auditor` | dbm-correctness-audit |
| 축별 멱등 SQL·로더·DRY-RUN | `dbm-load-builder` | dbm-load-execution |
| 신규 코드/공정/siz DDL 제안 | `dbm-ddl-proposer` | dbm-load-execution |
| X1~X6 독립 게이트 | `dbm-validator` | (본 스킬 게이트) |
| 색→옵션 CPQ 적재(6단계) | `dbm-option-mapper` | dbm-cpq-option-mapping |

생성(builder/auditor/researcher)과 검증(validator)은 항상 분리한다 — 그 분리 자체가 X6.

## 컨펌 큐 (인간 승인 — 자동 진행 금지)

- **정책:** B-1 P-TRUNCATE 재실행 가드(1순위·전제) · 실 COMMIT/DDL/논리삭제.
- **도메인:** AX-1 잉크색 귀속 · AX-2 size→option 사슬 보존 · AX-7 캐스케이드 제약 신설 · B-3 자재 분리 · B-6 size↔option 경계 · B-7 신규 공정 신설 등. 미결정은 BLOCKED로 분리하고 중단 없이 다음 축 진행.

## 후속 실행 (재실행·부분 교정)

- `_workspace/huni-dbmap/32_axis-staged-load/` 존재 + "특정 축만" → 해당 축 단계만 재실행(전제 2 재실측 먼저).
- 라이브 변경 후 "6축 재실측"/"매핑 오류 다시" → 전제 2부터 전 축 freshness 재확인.
- 가격축(STAGE 5)은 본 스킬 범위 밖 — round-2/16/18로 라우팅.

ARGUMENTS: $ARGUMENTS
