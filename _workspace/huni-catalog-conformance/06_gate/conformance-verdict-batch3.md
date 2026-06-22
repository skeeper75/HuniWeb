# conformance-verdict-batch3.md — 배치3(sticker·acrylic·silsa) 독립 검증 게이트 K1~K8

> **Phase 4 — hcc-conformance-gate(생성≠검증)** · 2026-06-23 · §21 배치3
> 인스펙터·codex 주장 **비신뢰** — 게이트가 라이브 읽기전용 SELECT + evaluate_price 재계산으로 **직접 재실측**.
> 라이브 65 prd(스티커16: PRD_000052~067 / 실사28: 118~145 / 아크릴21: 146~166). DB 미적재·단가 verbatim 불변.

## 종합 판정: **NO-GO** (K4 FAIL — 돈크리티컬 과대청구 신규 확정 + 아크릴 20 차단)

단일 FAIL=NO-GO. K4가 **2종 결함**으로 FAIL: ① 아크릴 147~166 미바인딩 20(차단) ② **실사 면적그리드 A-사이즈 프리셋 과대청구**(게이트가 R-B3-2를 "조건부"→"확정·신규 더 큰 노출"로 격상). K6 BLOCKED(인증 stale·정직 사유)=CONDITIONAL 사유이나 NO-GO 드라이버 아님.

## K1~K8 판정표

| 게이트 | 판정 | 재실측 증거(직접) |
|--------|------|------------------|
| **K1** 커버리지 누락 0 | **PASS** | basedata 520·cpq 260·price 65 = **845 셀 빈 verdict 0**(awk). checklist 배치3 65 prd 전수(diff: cells⊆checklist, 누락 0). |
| **K2** 기초데이터 정합 | **PASS(+BUNDLE 결함 비준)** | BUNDLE 4(148/149/152/154): mat 등록·attach proc 누락 라이브 재현(148=mat 1구자석/원형핀 등록, proc=UV만). 인스펙터 MISSING 4 정합. |
| **K3** CPQ 연결 무결성 | **PASS** | 옵션→차원 polymorphic **고아 0** 직접 재측정: OPT_REF_DIM.03(자재 115행)·.04(공정 61행) NOT EXISTS 가드=**0 orphan**. NULL ref_dim_cd 0. dead-link 0. MISMATCH 2 재현(아래). |
| **K4** 가격엔진 정합 | **FAIL** | ① 아크릴 147~166 bind=**20/20 zero**(직접 카운트). ② **R-B3-2 격상=확정 과대청구**(아래 ★). |
| **K5** 종단 e2e 추적 | **PASS** | G-1=7,000·G-2=2,000 **오차 0** 재현. G-3 banner 2-comp 배선 확인. G-4 PRD_000147 bind=0 끊김 시연. H1/H2 가설 기각(아래). |
| **K6** 라이브 화면 대조 | **BLOCKED→CONDITIONAL** | HUNI_ADMIN 로그인 probe=403·CSRF 취득 불가(stale 3연속). 추측 로그인 금지. 갱신 후 일괄 재실행 큐. |
| **K7** codex reconcile 수렴 | **PASS(미해결 0)** | 합의 6·불일치 0. codex 가설 2건(H1/H2) 게이트 라이브 재실측으로 **전부 기각**. TMPL-000013 EXTRA·dead-link 0 합의 재현. |
| **K8** 생성≠검증 독립성 | **PASS** | 전 판정 게이트 자체 psql 재현(인스펙터 셀 인용 아님). ★게이트가 **인스펙터·codex 미적발 신규결함**(A1 +8,000) 독립 발굴=독립성 입증. |

## ★ K4 핵심: R-B3-2 격상 — 실사 A-사이즈 프리셋 과대청구 (확정·신규 노출)

인스펙터·codex는 "조건부(+5,000, A3/A2, sub-600 주문 허용 시에만)"로 보류. **게이트 독립 재실측 결과 = 확정 결함이며 노출이 더 크다.**

**재현 사슬(evaluate_price off-grid ceiling, pricing.py L49-50 TIER_UPPER '이하 상한'):**
- 영향 상품: **118·120·121·123** (4상품, 공유공식 PRF_POSTER_{ARTPRINT/WATERPROOF/ADH_WP/ARTFABRIC}, comp=COMP_POSTER_ARTPRINT_PHOTO use_dims=[siz_width,siz_height,min_qty]).
- 그리드 최소행=**600×600=12,000**, sub-600 행 0(라이브 재측정). 4상품 각 **A3·A2·A1 프리셋이 selectable**(t_prd_product_sizes 등록 확인).
- 제약(constraint)은 width/height **≥200**(118/120/121) 또는 ≥500(139)만 강제 → **A3(297×420)/A2(420×594)/A1(594×841 width 594<600) 전부 그리드 하한 미달 → off-grid ceiling 상향**.

| 프리셋 | 입력(mm) | 엔진 ceiling 가격 | 권위(silsa-l1 260610) | 차이 |
|--------|----------|------------------|----------------------|------|
| A3 | 297×420 | **12,000** | 7,000 | **+5,000** |
| A2 | 420×594 | **12,000** | 7,000 | **+5,000** |
| **A1** | 594×841 | **20,000** | 12,000 | **+8,000 ★인스펙터·codex 미적발** |
| 사용자입력 | (≥600) | 20,000 | 20,000 | 0(정합) |

- **돈영향**: 4상품 × 3프리셋 과대청구. A1 +8,000은 generation-side가 "A1=on-grid 12,000"으로 오판해 놓친 **신규 결함**(게이트 독립 발굴=K8 입증).
- **근본원인**: 그리드 적재 시 A3/A2/A1 **고정가 프리셋 행(7,000/7,000/12,000) 미적재** — 사용자입력 ≥600 연속티어만 적재됨. authority `price` 컬럼이 사이즈 프리셋별 고정가인데 면적매트릭스로만 평면화.
- **권위 정답**: 면적그리드 = 사용자입력(nonspec) 전용. A3/A2/A1 = 고정가 프리셋(siz_cd 매칭행). 두 모드 분리 필요.

## codex 가설 2건 — 라이브 재실측으로 **전부 기각**

| 가설 | 재실측 SQL | 결과 | 판정 |
|------|-----------|------|------|
| **H1** 스티커 comp use_dims tuple 중복(동시매칭 ERR_AMBIGUOUS) | `(siz_cd,mat_cd,min_qty) GROUP BY HAVING count>1` for COMP_STK_PRINT/TATTOO/GANGPAN | **0·0·0** | **기각** — 동시매칭/중복합산 불가 |
| **H2** 실사 4공식 COMP_POSTER_ARTPRINT_PHOTO formula_components 중복연결(double-count) | `(frm_cd,comp_cd) GROUP BY HAVING count>1` 전 배치3-bound 공식 | **0** (5공식 각 1행) | **기각** — double-count 불가 |

codex 환각 0(인용 근거 전건 라이브 실재). 두 가설 정직히 0 → 신규결함 승격 없음. **단, codex가 놓친 A1 +8,000은 게이트가 잡음.**

## K2/K3 표본 재현 비준

- **K3 MISMATCH-1**(PET배너 PRD_000136 거치대): OPV-000019 실내용=item 1, **OPV-000020 실외용=item 0**(비대칭 반쪽 dead link 재현). 실외용 선택 시 자재환원 실패.
- **K3 MISMATCH-2**(PRD_000146 고리): opt_grp OPT-000012 `sel_typ_cd` NULL·min/max NULL(택1/택N 미정 재현).
- **K3 MISSING 재현**: 아크릴 160~166 templates=0행·146/158 addons=0행. 인스펙터 보드 정합.
- **K7 EXTRA**: TMPL-000013(base PRD_000136 PET배너)=테스트 잔재 재현. ★부수발견: TMPL-000001/002/003(base PRD_000002)도 "테스트 템플릿"이나 배치3 스코프 외(별 배치 정리 큐).

## K6 BLOCKED 상세 (정직 보고·추측 금지)
- HUNI_ADMIN_* 자격증명 존재하나 로그인 probe **403·CSRF 미취득**(디지털+배치1+배치2에 이어 3연속 stale).
- 추측 로그인 금지(안전 [HARD]). product-viewer 3원 대조(엑셀↔DB↔화면)는 **엑셀↔DB 2원까지 완결**(권위 silsa-l1 ↔ 라이브 단가행 직접 대조). 화면축만 미완 → CONDITIONAL.
- 갱신 후 디지털+배치1+배치2+배치3 누적 일괄 재실행 큐.

## 안전·메서드
- 라이브 읽기전용 SELECT만(`.env.local RAILWAY_DB_*`). DB 미적재·교정명세까지. 단가 verbatim 불변. 비밀값 비노출.
- 생성≠검증: 전 게이트 판정=게이트 자체 psql 재현(인스펙터 셀 신뢰 아님). A1 +8,000 신규발굴이 독립성 산증.
- 이전 06_gate(배치1·2) 유효분 이월. 배치3은 신규.
