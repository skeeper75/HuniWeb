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
  업데이트/보완', '특정 시트만 무결성 진단', '무결성 진단 다시', '가격테이블 배치 빌드', '매트릭스 결정론 diff',
  '권위 스냅샷 비교', '토큰 절약 가격 분석', '시트 적재본 자동생성', '차원 정합 진단', '차원 누락 진단',
  'use_dims 정합', '돈 새는 차원', '옵션 차원 단가행 정합', '가격구성요소 차원 누락', '봉투제작 차원',
  'dim conformance'. 가격공식 설계 자체는 §18, 전 상품 12축 종단 정합은
  §21, 표시명 중복은 §17, 라이브 정합 교정 실행은 §7 dbmap. 단순 질문은 직접 응답.
---

# 권위 가격테이블 적재 무결성 진단 — 오케스트레이터

## 목적
권위 엑셀의 가격 데이터·차원이 라이브에 **이 빠짐 없이·정확히** 적재됐는지 시트별 정밀 진단 → 결함 보드 + 교정 명세. 이 진단의 GO가 가격공식·구성요소 설계의 신뢰 기반이다(불완전 적재 위에 설계하면 정확값 불가).

**실행 모드:** 하이브리드 — 추출(서브) → ★**결정론 배치 diff**(matrix-batch-builder·권위CSV↔스냅샷CSV·토큰0) + 검사 보강(서브) → codex(서브) → 게이트(서브). 모든 Agent 호출 `model:"opus"`.

**★[HARD·토큰 경제·사용자 directive] AI 셀 분석 금지.** 권위도 CSV(24_master-extract)·라이브도 CSV(live-snapshot 스냅샷)이므로 무결성 대조는 **결정론 스크립트 diff**가 정답이다(AI가 19시트×수천 셀을 자연어로 읽으면 토큰 폭발). 에이전트는 시트 1개의 파서+diff 규칙을 코드화(토큰 1회)하고, 스크립트가 전 셀·전 시트를 처리(토큰 0)한다. 상품마스터 배치 적재(`dbm-batch-load`)와 동형. → 라이브 실측 환경 = `_workspace/_foundation/live-snapshot/`(snapshot.sh·db-check.sh).

## Phase 0: 컨텍스트 확인
- `_workspace/huni-price-table-integrity/` 존재 + 부분 수정 요청 → 해당 시트 에이전트만 재호출.
- 존재 + 새 입력 → 기존을 `_workspace_prev/`로 이동 후 새 실행.
- 미존재 → 초기 실행. **파일럿=아크릴**(방금 실증된 sparse grid)부터, 검증 후 동형 전파.

## Phase 1: 권위 격자 추출 (기준점)
`hpti-authority-extractor` — 시트별 정답 격자(차원+전 셀) + 차원 의미. ★기존 06_extract·24_master-extract 재사용. → `01_authority/<sheet>-grid.csv`·`-dims.md`.

**★[HARD·사용자 directive 2026-06-28] 상품별 가격 차원 정밀 배치 + 라이브 off-grid 공식확정** (`_workspace/_foundation/price-dimension-layout-method.md`). 권위=엑셀(값 1순위)·**라이브=격자 밖 수량/사이즈 계산방식의 권위**. 상품 1개=차원 매트릭스 1개: ① 차원 인벤토리(use_dims+엑셀 축) ② 엑셀 권위 격자 ③ 라이브 probe(격자점=값 정합·격자밖 수량 95/97/전밴드=계산방식·격자밖 사이즈=면적/견적) ④ 우리 DB 엔진 대조 ⑤ 공식 실증 확정(가정 금지). ★스팟 대조 금지·블랭킷 가정 금지. 실증례: 명함 선형 35/매→.02(단일밴드 충분)·봉투 밴드총액→.02(전밴드 필수). 무결성 진단은 이 차원배치 위에서.

**★[HARD·신설 2026-06-28] 단가/합가 계층 분류 먼저.** 격자 추출 전 그 시트가 어느 계층인지 분류(권위=`_workspace/_foundation/price-table-formula-structure-map.md/.csv`·가격표 19시트 전수):
- **L1 단가 블록**(출력소재·디지털인쇄비·코팅·접지·인쇄후가공·커팅타공·박·제본·아크릴·박대형) = 합산 대상 atomic 단가. 무결성=각 단가 셀 verbatim 적재.
- **L2 선조립 합가표**(스티커·도무송·봉투·명함포토카드·엽서북떡메·포스터사인) = 상품가가 이미 합쳐짐. ★권위 셀=라이브 정확 일치 실증(봉투·명함 4/4) → **verbatim 적재면 오차 0**. 대칭전개·재계산 금지.
- **L3 modifier**(판걸이수=판수·굿즈파우치=구간할인율) = 곱/환산. 가격 아님(별도 검사).
→ 시트 분류가 틀리면 무결성 판정이 틀린다(L2를 L1처럼 분해하면 이중합산·L1을 L2로 보면 합산 누락).

## Phase 2: 라이브 적재 대조 (결정론 배치 1차 + AI 보강)
**★결정론 배치 우선(토큰 0).** `hpti-matrix-batch-builder`(스킬 `hpti-matrix-batch-build`) — 권위 격자 CSV ↔ 라이브 스냅샷 CSV(`live-snapshot/latest/`)를 grid-diff 스크립트로 비교해 3종 결함(미적재·차원누락·불일치)+prc_typ 오타이핑+transpose를 **셀 단위 자동 검출**하고 결함보드·교정 적재본(권위 verbatim UPSERT+dryrun)을 산출. 시트 1개 파일럿→어댑터로 전 시트 전파. → `_batch/<sheet>-defect-board.csv`·`-load-dryrun.sql`·`scripts/`.
**AI는 보강만.** `hpti-load-inspector` — 스크립트가 못 잡는 의미·예외(시트 구조 해석·차원 의미 확정·경계 케이스)만 판단(시트 팬아웃·라이브 읽기전용). ★전수 셀 대조는 배치 빌더가 한다(load-inspector가 매 셀 자연어 대조 = 토큰 폭발·금지). → `02_load/<sheet>-defects.csv`.

## Phase 2b: 차원 정합 적대적 진단 (3자 조인·전 상품 전수)
Phase 2가 "권위 셀 ↔ 라이브 셀"(시트 내부)을 본다면, Phase 2b는 **"가격구성요소가 손님 선택을 단가로 환원하는가"**(상품×component×차원)를 본다 — 셀이 다 적재돼도 차원이 어긋나면 손님 선택이 단가행에 닿지 못해 돈이 샌다.
`hpti-dimension-conformance-inspector`(스킬 `hpti-dimension-conformance-audit`) — 결정론 `dim_conformance.py`(토큰0)로 **Face A(use_dims 선언) ↔ Face B(component_prices 충전) ↔ Face C(상품 옵션 선택수단+polymorphic ref_dim 환원)** 3자를 union 분담 흡수로 조인. 산출:
- **MISSING**(손님 선택가능한데 어느 component에도 단가행 0=저청구/견적불가) · **UNDECLARED**(단가행은 차원 구분하는데 use_dims 미선언=silent 가산/무시).
- 신뢰도 태깅: mat/siz/plt/bdl=HIGH(전담), proc/opt/print_opt=REVIEW(분담 잔여).
- → `_batch/dim-conformance-fullscan-<date>.tsv` + HIGH 결함보드(재현쿼리·돈영향·dbmap 라우팅).
★봉투제작처럼 사이즈에 못 넣는 종류(티켓/소/자켓/대봉투)를 옵션그룹으로 두고 `ref_dim_cd=OPT_REF_DIM.01`(사이즈) 환원하는 패턴은 정합으로 인정(옵션→차원 환원되면 use_dims에 opt_cd 없어도 OK). 검증 골든=봉투 MAT_169 누락·명함032 코팅 UNDECLARED(메모리 기존 결함 독립 재발견).

## Phase 3: codex 독립 2차
`hpti-codex-verifier` — `hqv-codex-cross-verify` 재사용. 놓친 gap·false-positive 발굴·reconcile. codex 주장=가설. → `03_codex/<sheet>-reconcile.md`.

## Phase 4: 무결성 게이트 (검증)
`hpti-integrity-gate` — 라이브 독립 재실측·I1~I7·GO/NO-GO·교정 명세(dbmap 라우팅·인간 승인). → `04_gate/<sheet>-verdict.md`·`remediation-spec.md`.

**★[신설] 단가/합가 오차 3유형 점검 + 라이브 고객사이트 교차검증.** 게이트는 적재 무결성(셀/차원)에 더해 **합가 조립 오차**를 본다:
1. **이중합산(과대)** — L2 선조립표인데 L1 단가를 또 더함(명함 S1/S2·책자 제본·always-add opt_cd 와일드카드).
2. **미바인딩/부분합산(과소)** — 합가 사슬 일부만 배선(아크릴 고리 미배선·최소셀 고정·option_items 단가행 결손).
3. **차원 미스매치** — 도수×면·소재·판수·page 키 불일치(견적불가/오가격).
- **라이브 교차검증(권위 보강):** 가족 대표를 라이브 `goods.asp`(`HUNI_LIVE_GOODS_URL`+pcode)로 구동→권위 셀/우리 적재와 대조. ★L2 가족은 권위=라이브 일치라 빠른 확증, **L1 합가 조립 가족에 우선 투입**(오차 위험 집중). 헬퍼=`remediation/_huni_live_crosscheck.md`·인덱스=`_huni_live_pcode-index.csv`. 차이=조사신호(자동교정 금지·권위 절대).
- **★off-grid 공식 역확인(합가 정답 확정):** 가격표에 없는 수량(95·97)·임의 사이즈를 라이브에 입력해 실제 공식 확정(`price-formula-live-confirmation.md`). 확정 규칙: 자유수량=단가×수량(선형)·per-unit 합가=base+옵션 가산(이중합산0)·면적=격자 lookup(off-grid=견적·보간 아님)·밴드수량=밴드 lookup(×qty 아님). **합가 오류 3근원**=밴드를 ×qty로/L2에 L1 또 더함(이중합산)/면적 연속보간. 게이트가 이 3종을 라이브로 반증.
- **★[HARD·실증 2026-06-28] prc_typ_cd 밴드총액 점검 (×qty 과대청구 결함 클래스).** 엔진 `.01 단가형 = unit_price × 수량`(나눗셈 없음)·NULL=.01 기본. **"완제품가"(L2 선조립=밴드 총액) component가 min_qty>1인데 `prc_typ_cd=.01`이면 = 총액×주문수량 = 밴드크기 배수 과대청구**(투명명함 13,500×100=1,350,000 시뮬레이터 실증·봉투/합판=×1000). 게이트 SQL: `완제품가 + min(min_qty)>1 + prc_typ in(NULL,.01)` 적발 → **.02(합가형=총액÷min_qty×수량)** 교정. 단, unit_price가 per-unit(장당·권당·스티커 min_qty=1)이면 .01 정상(false-positive 가드=라이브 단위기준 대조). `FINDING-bandtotal-x-qty-overcharge.md`.

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
