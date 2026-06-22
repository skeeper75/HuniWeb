# reconcile.md — Claude 인스펙터 ↔ Codex 행별 reconcile

> **Phase 5 — hcc-codex-verifier** · 2026-06-22 · `huni-catalog-conformance/05_codex`
> 행별 {Claude 인스펙터 · codex · 합의/불일치 · 근거 실재성 대조 · 라우팅}.
> **합의=고신뢰** · **불일치=게이트 조사 큐** · **codex 신규=확인 필요 후보(hypothesis)**.
> codex 가용(AVAILABLE gpt-5.5). codex는 라이브 미접속 → 모든 codex 신규/이견은 게이트가 라이브 최종 판정.
> ★[HARD] codex 주장=가설. 본 reconcile은 채택이 아니라 라우팅. 최종 GO/NO-GO는 hcc-conformance-gate.

---

## 0. 한 줄 결론

- codex 총평 = "결함 보드 방향 대체로 동의, 일부 CONFIRM/범위축소 필요". **합의 다수(고신뢰)·불일치 5·codex 신규 2.**
- **codex 환각(근거 부재 허위 주장) = 0건.** codex 인용 prd_cd 전부 디지털 스코프 실재(라이브 tsv 대조 완료).
- codex가 적발한 **주요 false-positive 후보 2건**(포토카드 별색 과판정·constraints 34 전건 근거부족),
  **놓친 결함 신규 1건**(E2E 견적 돈영향: 공식 있어도 옵션경로 부재 상품), **부호 정밀화 1건**(D-A/D-B 합성).

---

## 1. 합의 (고신뢰 — 게이트 확정 우선)

| # | 항목 | Claude 인스펙터 판정 | codex | 근거 실재성 | 라우팅 |
|---|------|----------------------|-------|-------------|--------|
| A1 | basedata 별색 MISSING/MISMATCH 17건 (019~025·035·036·039·040·043~046·048) | 진짜 결함(HIGH·견적가산 누락) | [동의] 마스터 존재+링크 0이면 선택/가격가산 끊김 | ✅ PROC family·product_processes 링크 0은 boards 근거와 일치 | **고신뢰** — dbm-correctness-audit |
| A2 | 가격엔진 frm_cd 미바인딩 10상품 (019·030·034~040·049) | MISSING·견적 차단(0원) | [동의] 견적 차단/0원 위험 | ✅ 10 prd_cd 전부 디지털 스코프 실재 | **고신뢰** — engine-design 명세→dbm-load-execution |
| A3 | COMP_COAT_GLOSSY 단가행 0 | MISSING·유광 과소·0원 침묵 | [동의] 유광코팅비 과소 방향 맞음 | ✅ 메커니즘 정합 | **고신뢰** — dbm-load-execution |
| A4 | 옵션→차원 264/264·템플릿 5/5 = 끊긴 링크 아님 | 연결 무결성 건강·갭=not-yet-loaded | [동의] but "이미 적재된 것에 한한 무결성"임을 명시 강조 | ✅ 트리거 fn_chk_opt_item_ref 강제 정합 | **고신뢰**(단 표현 주의=A4-note) |
| A5 | 묶음수 MISSING 10(명함류 박스단위) | LOW 결함 | [동의] "건수 표기"면 결함 유지 타당 | ✅ bundles.tsv 031~040 0행 확인 | **고신뢰** — dbm-load-builder |
| A6 | 커버리지 468셀 빈 칸 0 | 빈 셀 0(288+144+36) | [동의] 36×13=468 산술 정합 | ✅ basedata-cells 288·cpq 144·price 36 실측 | **고신뢰** |
| A7 | DEF-PE-01~04 기본 메커니즘(orphan=과소·미바인딩=차단) | 명시 | [동의] isolated 부호 맞음 | ✅ | **고신뢰** |

> **A4-note**: codex가 "264/264·5/5을 CPQ 완성도 100%로 읽으면 안 됨"을 강조. 이는 Claude 보드도 이미 명시
> ("not-yet-loaded가 지배적 갭"). 합의이나 게이트 보고 시 오독 방지 표현 권장(불일치 아님).

---

## 2. 불일치 (게이트 조사 큐 — 라이브 재실측으로 최종 판정)

| # | 항목 | Claude 인스펙터 | codex 이견 | 근거 실재성 | 라우팅(게이트 조사) |
|---|------|-----------------|------------|-------------|---------------------|
| **X1** | PRD_000037·050·051 판형 | **CONFIRM 3건**(권위 빈값 vs 라이브 plate·needed 재판정) | **050·051은 EXTRA 후보가 더 강함**(권위 비판형 needed=N 명시)·037만 CONFIRM 유지 | ✅ 라이브 plate-sizes.tsv: 050(4행)·051(1행)·037(1행) **모두 output_paper_typ_cd=NULL** 확인 | **게이트 조사**: 050/051 EXTRA vs CONFIRM 판정. authority §4 needed=N + NULL-type plate → codex EXTRA 논거 실재. needed 재판정 큐 연계 |
| **X2** | 포토카드 024·025 화이트인쇄단면 | basedata는 **MISMATCH 확정**(인쇄옵션 미적재)·cpq는 C-VAR-WHITE **CONFIRM** | basedata 확정 MISMATCH는 **과판정**·CONFIRM이 안전(보드 내 판정 불일치) | ✅ 보드 내부 불일치 실재(basedata MISMATCH ↔ cpq/price CONFIRM 병존) | **게이트 조사**: 024/025 별색 단일판정 정합. sentinel vs 미적재 공정 라이브 재실측(option_item ref_dim) |
| **X3** | constraints MISSING 34(016~049 전부) | 전건 needed=Y·MISSING | 권위는 "표기 상품만 needed=Y" → **34 전건 확정 근거 부족**(상품별 별표/블리드/가변 근거 미전개) | ⚠️ 보드는 상품별 제약 근거 미상세(근거 펼침 부재 사실) | **게이트 조사**: 상품별 제약 표기(별표/블리드/박크기/가변) 권위 재추출 → needed 상품별 재판정 |
| **X4** | 페이지룰 MISSING 5(016~019·027) | LOW·MISSING 확정 | 도메인 렌즈 `[HARD] 판수=앱런타임 DB미저장`과 충돌 → **CONFIRM으로 낮춰야** | ✅ page-rules.tsv 0행(전 상품 미적재)·domain-lens §횡단 판수=앱계산 명문 충돌 실재 | **게이트 조사**: 페이지룰 needed 판정. 권위 §9 page_rules vs 렌즈 판수=앱계산 충돌 해소 |
| **X5** | DEF-PE-02/03 금액규모(D-A −200K·D-B +450K) | 금액 명시 | **부호 유지·금액 크기는 CONFIRM**(3,500/5,500이 100매 묶음 총액이면 단위가 −2K·+4.5K) | ⚠️ DEF-PE-05가 이미 prc_typ 장당가 vs 묶음가 모호를 CONFIRM 처리 → codex 지적과 정합 | **게이트 조사**: DEF-PE-05 prc_typ 심의와 합산. 금액 규모는 단가의미 확정 후 재계산 |

---

## 3. codex 신규 발굴 (확인 필요 후보 — hypothesis·채택 금지)

| # | codex 신규 | 내용 | 근거 실재성 | 라우팅 |
|---|------------|------|-------------|--------|
| **N1** | D-A/D-B 합성 부호 | 같은 명함 공식에 D-A(과소)+D-B(과대) 공존 시 **상품별 최종 부호는 합성 재계산 필요**(COAT 선택+양 STD 통과 시 800K vs 550K=과대) | ✅ 보드도 "어느 쪽 발화는 option→차원 주입 상태에 달림"이라 명시 → codex가 합성 시나리오로 정밀화 | **확인 필요**: 게이트 evaluate_price 재계산 시 상품별(032 등) 합성 최종가로 부호 확정. 가설 |
| **N2** | E2E 견적 돈영향 누락 | price 보드가 formula 중심 → **공식 있어도 옵션경로(별색/커팅/접지) 부재면 가산비 선택·계산 불가**한 상품(020~023·028·043~046·048) 돈영향이 price 집계에서 누락 | ⚠️ 부분 실재: 해당 상품은 basedata(인쇄옵션 MISSING)+cpq(옵션그룹 MISSING)에 이미 결함 등재. price 보드엔 미집계가 사실 | **확인 필요**: 게이트가 cross-board 돈영향 집계(basedata 별색 MISSING + cpq 옵션그룹 MISSING이 합쳐져야 E2E 견적 가산비 차단). 가설→cross-inspector 종합 |

> N1·N2 모두 **새 결함 창작이 아니라 기존 결함의 영향 재해석**(합성·cross-board). 게이트가 라이브 재계산·
> 보드 횡단 집계로 최종 판정. 라이브 검증 전 사실 채택 금지.

---

## 4. ★ 환각 경계 대조 (codex 인용 근거 실재성)

라이브 캐시(`02_basedata/_live/*.tsv`)·결함 보드로 codex 인용을 전수 대조:

| codex 인용 | 실재 여부 | 대조 출처 |
|-----------|-----------|-----------|
| PRD_000050·051·037 plate output_paper_typ NULL | ✅ 실재 | `_live/plate-sizes.tsv` (050 4행·051 1행·037 1행 전부 typ 빈값) |
| page_rules 전 상품 0행 | ✅ 실재 | `_live/page-rules.tsv` = 0행 |
| bundles 031~040 0행 | ✅ 실재 | `_live/bundles.tsv` 해당 prd_cd 부재 |
| 별색 PROC_000007 family·링크 0 | ✅ 실재 | basedata-coverage-note §2 + processes.tsv |
| 인용 prd_cd 전부(024·025·020~023·028·032·043~046·048) | ✅ 실재 | 전부 PRD_000016~051 디지털 스코프 내 |
| D-A/D-B 단가(3,500/4,500/5,500) | ✅ 실재(verbatim) | price-engine-defect-board DEF-PE-02/03 |

- **환각(근거 부재 허위 주장) = 0건.** codex는 라이브 미접속을 자기 명시했고, 추론 부분은 "추정/CONFIRM"으로
  표기. 허위 코드·없는 prd_cd·날조 치수 인용 없음.

---

## 5. 게이트 인계 (hcc-conformance-gate)

- **합의 7건(§1)** = 고신뢰. 게이트 NO-GO 사유 우선순위(별색·미바인딩·유광 0원·명함 misfire).
- **불일치 5건(§2)** = 게이트 조사 큐. 라이브 재실측 항목: X1(050/051 EXTRA vs CONFIRM)·X2(포토카드 별색
  단일판정)·X3(constraints 상품별 needed)·X4(페이지룰 needed 충돌)·X5(prc_typ 금액규모).
- **codex 신규 2건(§3)** = 확인 필요 후보. N1(D-A/D-B 합성 부호 재계산)·N2(cross-board E2E 돈영향 집계).
- 게이트는 위 큐를 라이브/권위로 최종 판정. codex 가설은 게이트 검증 전 결함 보드에 사실로 병합 금지.
