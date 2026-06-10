---
name: dbm-change-tracking
description: >
  후니프린팅 상품마스터·가격표 엑셀의 **버전 간 변경분을 추적하고 라이브 t_* DB에 델타로 적용**하는
  방법론 스킬 (round-10). 두 버전(이전 baseline → 신규)을 키 기반(prd_nm/prd_cd)으로 cell-level
  diff 하여 ADDED/REMOVED/MODIFIED/UNCHANGED로 분류하고, 각 변경을 영향 t_* 엔티티/컬럼/라이브 행에
  매핑하고, 사람이 읽는 변경 매니페스트(행 단위 diff 감사본) + 멱등 델타 UPSERT(ON CONFLICT, upd_dt
  변경로그 반영) + 롤백전용 라이브 DRY-RUN을 산출한다. 3-way(baseline/new/라이브) 정합으로 적용분을
  결정하고, REMOVED는 hard-delete 금지(논리삭제 제안·escalate), 신규 코드값은 선적재 제안, 실 COMMIT은
  인간 승인. '변경 추적', '버전 diff', '버전 비교', '변경분 적용', '신규 버전 적용', '상품마스터 업데이트',
  '가격표 업데이트', '변경 매니페스트', '델타 적재', '엑셀 변경 추적', '260527 260610', 'change tracking',
  'round-10', '변경 추적 다시', '델타 다시', '변경 추적 업데이트' 작업 시 반드시 이 스킬을 사용. 단일 스냅샷
  매핑 설계는 dbm-mapping/dbm-price-formula, 적재본 조립·실행은 dbm-load-readiness/dbm-load-execution,
  이미 적재된 DB↔엑셀 단건 정합은 dbm-mapping-audit이 담당하므로 그 작업에는 트리거하지 않는다.
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, TodoWrite, Skill
metadata:
  version: "1.0.0"
  category: "domain"
  status: "active"
  updated: "2026-06-10"
  tags: "change-tracking, version-diff, delta-load, upsert, audit-trail, round-10"
---

# dbm-change-tracking — Versioned Change Tracking & Delta Apply (round-10)

[HARD] 산출 문서(.md/.csv 매니페스트·게이트)는 한국어로 작성한다(language.yaml). 식별자·테이블/컬럼명·코드값·CSV 헤더·SQL은 영어. 비밀값은 산출물·stdout에 절대 비노출.

## 무엇이 다른가 (vs 기존 라운드)

기존 라운드는 **단일 스냅샷** 엑셀을 매핑·적재했다. round-10은 **두 버전의 차이**를 다룬다. 핵심 통찰:

- **적용할 델타 ≠ (신규 − 이전).** 권위 상태는 라이브 DB다([[dbmap-no-db-load-file-first]]: "등록/NULL/존재 판정은 라이브 권위"). 이전 버전(baseline)은 *운영자가 소스에서 무엇을 바꿨는지(의도)*를 알려주고, 라이브는 *실제 무엇이 적재돼 있는지(현실)*를 알려준다. 둘은 다를 수 있다(적재 중 교정·GO/차단 분리·placeholder 제외·siz 권위정정). 따라서 **3-way diff**가 필수다.
- **추적성이 1급 산출물이다.** "무엇이 왜 바뀌었나"를 행 단위 감사본으로 남기는 것이 사용자 요구의 절반이다. 매핑·적재는 나머지 절반.

## 3-way 모델 (반드시 이 프레임으로 사고)

```
  baseline xlsx (260527)  ──[엑셀 diff]──>  new xlsx (260610)
        │                                          │
   (현 라이브 적재의 소스)                    (목표 상태의 권위)
        │                                          │
        └──────────> live t_* DB <─────────────────┘
              (실제 현재 상태 = 적용 정합의 권위)
```

- **엑셀 diff (baseline→new)** = 변경 *의도* 분류 (무엇이 추가/삭제/수정됐나).
- **new↔live 정합** = 적용할 *실제 델타* 결정 (멱등 UPSERT가 라이브를 목표 상태로 수렴시킴).
- baseline은 분류·추적의 닻이지 적용의 직접 소스가 아니다.

## 운영 원칙

1. **키 기반 매칭, 위치 기반 금지 (V1).** 엑셀 행은 재정렬·삽입·삭제된다. 위치로 비교하면 유령 diff가 생긴다(아크릴 −24행이 전부 "수정"으로 오분류). 시트별 **안정 비즈니스 키**(JOIN KEY=`prd_nm`; `prd_cd` 있으면 우선 — [[railway-db-access]])로 `{key→행}` 맵을 양 버전에 만들고 키 집합 연산으로 분류한다. 키 중복/공백은 차단 신호로 표기(조용히 첫 행 선택 금지).
2. **변경 분류 4종 (V2).** key가 new에만=**ADDED**, baseline에만=**REMOVED**, 양쪽+셀差=**MODIFIED**(셀별 전→후), 양쪽+동일=**UNCHANGED**(매니페스트 제외). MODIFIED는 *어느 셀이* 바뀌었는지까지 분해해야 영향 매핑이 가능하다.
3. **REMOVED는 비파괴 (V3·HARD).** 엑셀에서 행이 사라졌다고 라이브 행을 hard-delete 하지 않는다 — 주문·FK 참조를 깰 수 있다. **논리삭제(use_yn=N / del 플래그) 제안 + escalate**로 처리하고, 실제 처리는 인간 결정. 아크릴 −24행이 진짜 단종인지, 통합·재명명인지는 키 매칭 후에도 사람이 판단(재명명이면 ADDED+REMOVED 쌍이 사실은 rename).
4. **셀→엔티티 영향 매핑 (V4).** 각 MODIFIED 셀을 영향 t_* 엔티티/컬럼에 매핑한다. 기존 지식 재사용: 9속성 렌즈(`dbm-mapping-audit` — 사이즈/자재/인쇄옵션/공정/공정택일/판형/묶음수/페이지룰/추가상품)·가격(`dbm-price-formula`)·CPQ 옵션(`dbm-cpq-option-mapping`). 한 셀이 여러 엔티티에 영향 가능(예: 사이즈 변경 → `t_prd_product_sizes` + 면적 가격 `t_prc_component_prices`). 매핑 불가 셀은 GAP으로 정직 분류(추측 금지).
5. **멱등 델타 적용 (V5).** new↔live 정합으로 도출한 변경분만 `INSERT … ON CONFLICT (natural key) DO UPDATE SET … , upd_dt = now()`. 충돌키=라이브 PK/UNIQUE 실측(추측 금지). 이미 라이브=목표인 행은 no-op(DRY-RUN 2회차 delta 0이 멱등 증거). 적재 메커니즘·SQL 패턴은 `dbm-load-execution`(ON CONFLICT·단일 트랜잭션·롤백 로더) 재사용 — 본 스킬은 *무엇을* 바꿀지, load-execution은 *어떻게* 실행할지.
6. **변경 로그 반영 (V6).** 사용자 추적 요구 ② = upd_dt 갱신. 모든 UPDATE는 `upd_dt = now()`(또는 버전일자). 전용 변경이력 테이블이 없으면 매니페스트가 감사 권위이고, DB 레벨 이력 테이블은 `dbm-ddl-proposer` 제안(GAP, 선택). reg_dt NOT NULL DEFAULT 함정 주의([[dbmap-round5-load-execution]]).
7. **추적성 = 행 단위 매니페스트 (V7).** 모든 변경을 `{시트·키(prd_nm)·분류·컬럼·전값→후값·영향 t_* 엔티티/컬럼·영향 라이브 행(prd_cd)·적용분류(INSERT/UPDATE/논리삭제제안/escalate/GAP)·provenance(셀 좌표)}`로 기록. CSV(기계) + MD 요약(사람). 이것이 "변경 추적 가능"의 핵심 산출물.
8. **비파괴·인간 승인 (HARD).** COMMIT 금지·DDL 적용 금지·hard-delete 금지. 라이브는 읽기전용 정합만(롤백전용 DRY-RUN은 lead 승인 1회). 신규 코드값=선적재 제안. 실 적재는 본 트랙 종착점 너머.

## 워크플로우

산출 루트 = `_workspace/huni-dbmap/14_change-tracking/`. 버전쌍별 하위(예: `260527-to-260610/`).

### Phase 1 — 버전쌍 정규화 추출
양 버전(baseline·new)을 동일 추출기로 L1 정규화(`dbm-excel-parse`). 시트별 키 컬럼 식별(`prd_nm`/`prd_cd`), 8 정보축 보존, 의미코드(행숨김=비활성 등) 라벨. → `_extract/<version>/<sheet>-l1.csv`. 동일 추출 파이프라인이어야 diff가 셀 단위로 정합(추출 방식 차이가 false diff를 만든다 — [[dbmap-l1-l2-extraction-first]]).

### Phase 2 — 키 기반 3-way diff
`diff_versions.py`(references/diff-engine.md 패턴)로 시트별 `{key→row}` 맵 양 버전 구성 → 키 집합 연산 → ADDED/REMOVED/MODIFIED/UNCHANGED. MODIFIED는 셀별 전→후 분해. 키 무결성(중복·공백·rename 의심쌍) 플래그. → `diff/<sheet>-changes.csv` + `diff/_diff-summary.md`(시트별 4분류 카운트).

### Phase 3 — t_* 영향 매핑 + 라이브 정합
각 변경 셀을 영향 t_* 엔티티/컬럼에 매핑(9속성·가격·CPQ 렌즈). 라이브 읽기전용(`dbm-schema-extract`)으로 영향 행(prd_cd)의 현재값 실측 → new 목표값과 대조해 적용분류 결정(이미 일치=no-op·차이=UPDATE·신규=INSERT·삭제=논리삭제제안). → `impact/<entity>-impact.csv` + GAP/escalate 분리.

### Phase 4 — 변경 매니페스트 + 델타 적용본
V7 매니페스트(행 단위 감사본, CSV+MD) + 멱등 델타 UPSERT(`dbm-load-execution` 패턴: `_delta/<NN>_<table>.sql`·`apply.sql`·롤백 로더, FK 위상정렬, upd_dt) + 코드행 선적재 제안 + 논리삭제/GAP 분리. → `14_change-tracking/260527-to-260610/`.

### Phase 5 — 검증 게이트 (V1~V8) + 보고
`dbm-validator`가 적대적 게이트: V1 키매칭 정합·V2 분류 완전성(누락0)·V3 REMOVED 비파괴·V4 영향매핑 정확성·V5 멱등성(DRY-RUN 2회 delta 0)·V6 upd_dt 반영·V7 매니페스트 추적성(전 변경 1:1)·V8 라이브 정합(UPSERT 후 목표 수렴). 생성(tracker)과 게이트(validator) 분리 = V8 독립성. → `03_validation/change-tracking-gate.md` GO/NO-GO. **NEVER COMMIT.**

## 게이트 V1~V8 (증거 기반 PASS/FAIL)

| Gate | 검사 | 증거 |
|------|------|------|
| V1 | 키 기반 매칭(위치 아님)·키 무결성 | 시트별 키 컬럼·중복/공백/rename 플래그 |
| V2 | 분류 완전성(셀 단위 누락 0) | 양 버전 셀 총수 = UNCHANGED+변경 셀 합 |
| V3 | REMOVED 비파괴(hard-delete 0) | 삭제 SQL 부재·논리삭제/escalate로만 처리 |
| V4 | 셀→t_* 영향 매핑 정확성 | 표본 변경의 영향 엔티티/컬럼 라이브 대조 |
| V5 | 멱등성 | 롤백 DRY-RUN 2회차 delta 0·전부 ON CONFLICT |
| V6 | 변경로그 반영 | 전 UPDATE에 upd_dt·provenance |
| V7 | 추적성 | 매니페스트 행 ↔ diff 변경 1:1(누락0) |
| V8 | 라이브 수렴(독립) | UPSERT 적용 시 라이브가 new 목표와 일치(별도 에이전트 검증) |

## 산출물

```
14_change-tracking/260527-to-260610/
├── _extract/{260527,260610}/<sheet>-l1.csv      # 양 버전 정규화 추출
├── diff/<sheet>-changes.csv + _diff-summary.md   # 키 기반 3-way diff (4분류)
├── impact/<entity>-impact.csv                    # 셀→t_* 영향 + 라이브 정합
├── change-manifest.md + change-manifest.csv      # ★ 행 단위 추적 감사본 (V7)
├── _delta/<NN>_<table>.sql + apply.sql + apply.sh # 멱등 델타 UPSERT (롤백 기본)
├── code-row-preload.md                           # 신규 코드값 선적재 제안
└── logical-delete-and-gaps.md                    # REMOVED 논리삭제 제안 + GAP/escalate
03_validation/change-tracking-gate.md             # V1~V8 GO/NO-GO
```

## 재호출
버전쌍 산출물이 있으면 재diff하지 말고 변경분만 갱신. 새 버전쌍(예: 260610→다음)이면 새 하위 디렉토리 생성, 직전 쌍 보존. validator FAIL이면 해당 게이트가 가리킨 단계만(diff/매핑/SQL) 재실행, PASS 단계 보존.

상세 diff 엔진 스크립트 패턴·매니페스트 스키마는 `references/diff-engine.md` 참조.
