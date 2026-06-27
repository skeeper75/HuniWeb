---
name: huni-price-table-integrity-orchestrator
description: >-
  후니프린팅 권위 가격테이블 적재 무결성 진단 하네스 오케스트레이터. 두 권위 엑셀(상품마스터 가격표포함
  260610·인쇄상품 가격표 260527)의 각 시트 가격테이블 "차원 + 전 데이터셀"이 라이브 DB에 이 빠짐 없이·정확히
  적재됐는지 정밀 진단하고 보완/교정 명세를 낸다. 핵심: 권위=엑셀(절대)·라이브=감사 대상. 3종 결함 — ① 미적재 셀
  (sparse grid·이 빠진 것) ② 차원 누락(권위 가격축이 라이브에 없음) ③ 정합 불일치(값/자재/표시 오적재). 가격공식·
  구성요소(차원 포함) 설계(§18)·검증(§13/15)의 ★선행 신뢰 기반. 흐름: 권위 격자 추출(authority-extractor)
  → 라이브 적재 대조 검사(load-inspector·시트 팬아웃) → codex 독립 2차(codex-verifier) → I1~I7 게이트
  (integrity-gate). 생성≠검증·codex 주장=가설·라이브 읽기전용 SELECT만·DB 미적재(실 교정은 인간 승인 후 dbmap
  위임). 트리거: '가격테이블 무결성', '적재 무결성 진단', '권위 적재 정밀 진단', '이 빠진 적재', '미적재 셀 진단',
  '차원 누락 검사', '권위 라이브 적재 대조', '가격격자 빈칸', 'sparse grid 진단', '무결성 하네스 실행/재실행/
  업데이트/보완', '특정 시트만 무결성 진단', '무결성 진단 다시'. 가격공식 설계 자체는 §18, 전 상품 12축 종단 정합은
  §21, 표시명 중복은 §17, 라이브 정합 교정 실행은 §7 dbmap. 단순 질문은 직접 응답.
---

# 권위 가격테이블 적재 무결성 진단 — 오케스트레이터

## 목적
권위 엑셀의 가격 데이터·차원이 라이브에 **이 빠짐 없이·정확히** 적재됐는지 시트별 정밀 진단 → 결함 보드 + 교정 명세. 이 진단의 GO가 가격공식·구성요소 설계의 신뢰 기반이다(불완전 적재 위에 설계하면 정확값 불가).

**실행 모드:** 하이브리드 — 추출(서브) → 검사 팬아웃(서브/시트별 병렬) → codex(서브) → 게이트(서브). 모든 Agent 호출 `model:"opus"`.

## Phase 0: 컨텍스트 확인
- `_workspace/huni-price-table-integrity/` 존재 + 부분 수정 요청 → 해당 시트 에이전트만 재호출.
- 존재 + 새 입력 → 기존을 `_workspace_prev/`로 이동 후 새 실행.
- 미존재 → 초기 실행. **파일럿=아크릴**(방금 실증된 sparse grid)부터, 검증 후 동형 전파.

## Phase 1: 권위 격자 추출 (기준점)
`hpti-authority-extractor` — 시트별 정답 격자(차원+전 셀) + 차원 의미. ★기존 06_extract·24_master-extract 재사용. → `01_authority/<sheet>-grid.csv`·`-dims.md`.

## Phase 2: 라이브 적재 대조 (생성·시트 팬아웃)
`hpti-load-inspector` — 정답 격자 ↔ 라이브 셀/차원 대조 → 3종 결함 보드(미적재·차원누락·불일치)+돈영향+재현SQL. 시트별 병렬. 라이브 읽기전용. → `02_load/<sheet>-defects.csv`.

## Phase 3: codex 독립 2차
`hpti-codex-verifier` — `hqv-codex-cross-verify` 재사용. 놓친 gap·false-positive 발굴·reconcile. codex 주장=가설. → `03_codex/<sheet>-reconcile.md`.

## Phase 4: 무결성 게이트 (검증)
`hpti-integrity-gate` — 라이브 독립 재실측·I1~I7·GO/NO-GO·교정 명세(dbmap 라우팅·인간 승인). → `04_gate/<sheet>-verdict.md`·`remediation-spec.md`.

## 데이터 전달
파일 기반(`_workspace/huni-price-table-integrity/<phase>/`) + 반환값(요약). 중간 산출물 보존(감사).

## 에러 핸들링
- 라이브 조회 실패 1회 재시도 → 재실패 시 "미실측" 명시(누락 은폐 금지).
- codex 미가용 → "Claude 단독" 폴백(pending 금지).
- 추출 캐시 stale → 해당 시트만 재추출.
- 상충 데이터 삭제 금지·출처 병기.

## 경계 (재병합 금지)
- 가격공식/구성요소 설계 = §18 huni-price-engine-design.
- 전 상품 × 12축 종단 정합 = §21 huni-catalog-conformance(이건 가격테이블 셀·차원 적재 무결성에 집중·더 granular·설계 선행 게이트).
- 표시명 중복 = §17. 라이브 실 교정 적재 = §7 dbmap. 단일 상품 온디맨드 = §15.

## 테스트 시나리오
- **정상:** "아크릴 시트 가격테이블 무결성 진단" → 추출(면적격자)→대조(70×30 등 빈셀·등록사이즈 차원누락 적발)→codex→게이트 GO/NO-GO+교정명세.
- **에러:** codex 미가용 → Claude 단독 폴백 명시·게이트는 라이브 재실측으로 진행.
