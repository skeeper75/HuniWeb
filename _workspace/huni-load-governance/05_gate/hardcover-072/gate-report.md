# PRD_072 하드커버책자 셋트 — 옵션 거버넌스 독립 검증 게이트 (LG1~LG7)

> §34 Huni-Load-Governance · Phase 5 · hlg-governance-gate · 2026-07-03
> 방법론: `hlg-governance-gate-validation`(생성측 주장 비신뢰·직접 라이브 재실측·단일 FAIL=NO-GO)
> 라이브 읽기전용 SELECT + evaluate_set_price 실호출(2026-07-03) · DB 미적재 · COMMIT 범위 밖
> 재실측 스크립트: `_meta/_tmp/lg_remeasure.py`·`lg_remeasure2.py`(psql 읽기전용 + simulate-set POST)

---

## 0. 최종 판정 — **GO** (NO-GO 0건)

072 셋트 옵션 레이어는 **전건 KEEP·NO-OP**. 게이트가 생성측 주장을 신뢰하지 않고 라이브에서 직접
재실측한 결과 판정과 일치. LG1~LG7 전부 PASS 또는 N/A. **처분 실행 큐 0건.** 관찰 3건(O-1·O-2·OPT_064)만
후속 라우팅. 어느 게이트도 FAIL 없음.

| 게이트 | 판정 | 요지 |
|--------|------|------|
| LG1 규범 충실성 | **PASS** | 면지색 U-3·KEEP이 criteria/vessel-norm §4 072 예와 일치·상품유형 SOT 무모순 |
| LG2 판정 근거 실재 | **PASS** | 처분(RETIRE/MOVE/EXTEND) 대상 0건 → 무근거 처분 0. KEEP 근거(ref 백킹·무가격) 전건 재현 일치 |
| LG3 오차단 0 [최우선] | **PASS** | 제거/이관 0 → 선택지 손실 0(면지 3색·내지 용지9/도수2/사이즈3 라이브 존치 확인) |
| LG4 가격 무손상 | **PASS** | evaluate_set_price PRICE≠0(34,100/159,100/796,900)·이중합산 0·면지색 무가격→BLOCKED 불필요 확증 |
| LG5 셋트 정합 | **PASS** | 부모=제본공식·표지/면지 member 배치 규범 §4 일치·set_eval 단독기여 이중합산 0 |
| LG6 문서 재현성 | **N/A** | dev-doc 없음(Phase 4 NO-OP·코드결함 신규 0) — `03_devdoc/hardcover-072/` 부재 확인 |
| LG7 독립성·수렴 | **PASS** | 생성≠검증(auditor≠gate)·codex divergence 0(옵션)·불일치 2건 조사 종결·단독주장 1건 후속큐 |

---

## 1. LG1 규범 충실성 — PASS

vessel-norm·option-usage-criteria 각 항목을 SOT·라이브와 대조. 모순 0.

- **면지색 KEEP 판정 ↔ criteria §1 U-3**: 옵션 item 3개가 `OPT_REF_DIM.03`(자재)로 MAT_382/383/384 참조
  (라이브 §C 확인). "선택→생산 BOM 자재 전달" = U-3 정의 부합. KEEP 자격 정합.
- **MAT 부모 유지 ↔ vessel-norm §3-1 예외[HARD]**: "옵션이 참조하는 ref_dim_cd.03 자재는 부모에 실재해야"
  — 라이브 §F에서 MAT_382/383/384 부모 072 실재(del=N) 확인. `fn_chk_opt_item_ref` 백킹 성립.
  MOVE-기준정보 아님 = 정합.
- **상품유형 SOT relitigate 금지 무위반**: 072=.01 셋트 부모(t_prd_product_sets 부모 등록·§A 5구성원),
  073/284/074/075/076=.02 반제품. 보드 표기와 SOT 분류 일치. 역방향 재분류 0.
- **셋트 배치 ↔ vessel-norm §4 072 적용 예**: 부모=제본/조립 본체공식(PRF_HC_MUSEON_SET·sim_meta 확증),
  표지073=구성원(전용지 MAT_246+판형 SIZ_250/252 member), 면지074/075/076=구성원(색상 자재·제본비 포함
  무가격). 보드 배치 = 규범 예시와 verbatim 일치.
- **O-2 print_opt tension 정직 표기**: 규범 §3-4(셋트 부모 도수/인쇄옵션 **금지**) 문언과 라이브(부모 072가
  POPT_001/002 보유)는 literal tension이나, **보드는 이를 결함으로 은폐하지 않고 관찰로 표면화**(옵션 처분
  대상 아님·print_opt=기준정보 레이어). 규범 위반을 조용히 통과시키지 않았으므로 LG1 규범 충실성 위반 아님
  → O-2는 규범 §3-4 예외조항 보강 라우팅(LG7·handoff).

## 2. LG2 판정 근거 실재 — PASS

처분 대상(RETIRE/MOVE-기준정보/MOVE-제약/MOVE-템플릿/EXTEND/BLOCKED) = **0건**(보드 §4 처분 집계).
→ 재실행할 처분 근거 쿼리 없음 = 무근거 처분 0(위장 처분 없음). KEEP 근거는 전건 직접 재현:

| 보드 주장 | 게이트 재실행 결과 | 일치 |
|-----------|-------------------|------|
| 옵션그룹 정확히 1개(누락 0·잔재 0) | §B: 6 prd_cd 전수(del 필터 없이) → OPT_000064 1건뿐, 나머지 0 | ✓ |
| 3옵션 전부 .03 자재 단일축 | §C: OPV_434/435/436 각 item_seq 1 · ref .03 · MAT_382/383/384 | ✓ (U-1 bundle 아님 확증) |
| MAT 부모 실재(ref 백킹) | §F: MAT_382/383/384 072 실재 del=N | ✓ |
| 면지 자재 무가격 | §D2: component_prices 0행 | ✓ |
| opt 가격 미참여 | §E2: OPT_000064 참조 price_component 0행 | ✓ |

## 3. LG3 오차단 0 [최우선] — PASS

처분이 전건 KEEP이므로 제거/이관 대상 = 0 → **"정리 후 손님이 같은 선택을 할 수 없게 되는" 경로 원천 부재.**
라이브에서 손님 선택지 존치 재확인:
- 면지 색 3종: OPT_000064 use=Y·del=N, OPV_434/435/436 3옵션 활성(§B·§C).
- 내지 선택: PRD_284 자재 9종·print_opt 2(단면/양면)·사이즈 3(A5/B5/A4) 존치(§G·sim_meta set_members).
- 표지 선택: PRD_073 전용지 MAT_246·판형 2종 존치.
→ 선택지 손실 1건도 없음. 매출 차단 위험 0.

## 4. LG4 가격 무손상 — PASS

처분 NO-OP(면지색 정리 안 함)이므로 가격에 손댈 것이 없으나, 게이트가 **직접 evaluate_set_price 실호출**로
무손상 재확인(생성측 "PRICE≠0" 주장 비신뢰):

| copies | evaluate_set_price(라이브 simulate-set) | 판정 |
|--------|------------------------------------------|------|
| 1 | **34,100** | PRICE≠0 ✓ |
| 10 | **159,100** | PRICE≠0 ✓ |
| 100 | **796,900** | PRICE≠0 ✓ |

- **이중합산 0**: 전 copies에서 member 5종 contribution=0, set_eval(부모 COVERBIND 공식) 단독 기여.
  중복 매칭·이중청구 없음.
- **가격종속 옵션 → BLOCKED 판정 정합**: 면지색은 (a) 자재 component_prices 0행(§D2) (b) OPT 참조
  price_component 0행(§E2) → evaluate_set_price 금액에 무영향 = 가격사슬 미참여. 가격종속 N이 실측으로 확증
  → BLOCKED 미분리가 아니라 **BLOCKED 불필요**(criteria §4). 가격종속인데 BLOCKED 누락한 옵션 = 0건.
- **부모 print_opt(O-2) 가격 무해 확증**: 부모 POPT_001/002 보유하나 796,900이 순수 COVERBIND tier(제본만) →
  print_opt-구동 component 추가청구 없음. 부모 print_opt로 인한 이중합산 0.

★ 관찰(§34 NO-GO 아님): member(내지 284) contribution=0. 이는 §23 셋트 트랙의 "072 내지 반제품 승격
= 그릇 GO·적재 대기"(내지 페이지곱 기여 미적재) **기존 pending 상태**이지 본 옵션 거버넌스가 유발한 결함이
아니다. §34 잣대(PRICE≠0·이중합산 0)는 충족. 내지 기여 완전성은 §23 골든 소관 → handoff 교차참조.

## 5. LG5 셋트 정합 — PASS (셋트라 핵심)

- **그릇 배치 ↔ 규범/권위 대조**: sim_meta 실측 — is_set=true, 부모 frm=PRF_HC_MUSEON_SET(표지+제본 합산가
  세트 부모), 부모 component=COMP_HC_MUSEON_COVERBIND(단가형·수량이상). 구성원 5종(표지073 has_formula=false=
  부모 COVERBIND가 표지+제본 담당·내지284 자기공식·면지074/075/076 빈 껍데기 무가격). vessel-norm §4 072
  적용 예와 배치 일치.
- **evaluate_set_price 골든 무손상**: PRICE≠0(§4)·set_eval 단독기여로 이중합산 0. 072 동작 검증 셋트의
  가격 행태를 옵션 거버넌스가 깨지 않음(전건 KEEP).
- **FP 가드 준수**: 동작 검증된 정상 배치(면지 무가격 member·표지 has_formula=false)를 결함으로 오판하지
  않음. 면지 멤버 빈 껍데기(§G: 074/075/076 mat/proc/siz/plt/optg/print_opt 전부 0)는 규범상 "색상 자재·
  제본비 포함 무가격" 정상 배치.

## 6. LG6 개발자 문서 재현성 — N/A

Phase 4(hlg-dev-doc-writer) 산출 없음 — 072 옵션 레이어에서 재현 가능한 코드결함 신규 발굴 0(NO-OP).
`03_devdoc/hardcover-072/` 디렉토리 부재 확인. 재현할 DEV-REQUEST 없음 → N/A(반송 대상 없음).

## 7. LG7 독립성·수렴 — PASS

- **생성≠검증**: 판정 생성=hlg-option-usage-auditor(`02_audit/`), 게이트=hlg-governance-gate(본 산출).
  게이트는 보드를 만들지 않고 라이브 원자료로 독립 재도출. 위반 0.
- **codex reconcile 수렴**: 옵션 레이어 divergence 0(전건 KEEP×3 = codex+Claude+라이브 3자 합의,
  reconcile §1). RETIRE/MOVE codex "FP 경고" = Claude "전건 KEEP" 동일 방향.
- **불일치 2건 조사 종결**:
  - O-2(부모 print_opt): codex 격상 지적 → 라이브/규범 판정으로 조사 종결(§3-4 literal tension 인정·단
    "BLOCKED" 용어 부정확 정정=print_opt는 옵션 아님·기준정보). Low→Medium 격상 채택 + 규범 §3-4 예외조항
    보강 + 셋트 UI print_opt 전파 계약 확인으로 라우팅. **미조사 잔존 아님.** 게이트 독립 재확인: 라이브
    §H에서 부모·내지 284 양쪽 print_opt 보유 → siz_cd 전파 동형 가설 지지·가격 무해(§4).
  - O-1(면지 멤버 빈 껍데기): codex 격상 → 범위 정정으로 조사 종결(074/075/076은 셋트 구성원이지 옵션
    아님 → 옵션 감사 "해당없음" 정확·구조 결함은 §23 소관). Low→Medium + §23 셋트 트랙 택일 라우팅.
    **미조사 잔존 아님.** 게이트 재확인: §G 멤버 3종 완전 빈 껍데기 사실 확증.
- **codex 단독 주장 1건(OPT_064 work-order 전달경로)**: 불일치(disagreement) 아님 — 양측 KEEP 합의 하의
  U-3 최종 소비점 검증 항목. 라이브에서 옵션 ref→자재 환원 구조는 확인됨(§C item .03=MAT_382~384), DB로
  확인 불가한 것은 작업지시서/SKU 코드 소비점뿐. 처분에 무영향 → webadmin 후속 확인 큐(handoff). 미조사
  불일치 잔존이 아니라 특성화 종결된 후속 검증 항목 → LG7 NO-GO 아님.

---

## 8. NO-GO 라우팅 — 없음

FAIL 게이트 0. 반송 대상 에이전트 없음. 옵션 처분 실행 큐 0건.

## 9. 게이트 인계 관찰 큐 (처분 아님·후속 라우팅)

| # | 관찰 | 심각도(수렴) | 라우팅 | 처분 |
|---|------|-------------|--------|------|
| O-1 | 면지 색 이중표현(옵션 3옵션 + 멤버 074/075/076 빈 껍데기·latent 합산 위험) | Medium | §23 셋트 트랙(멤버↔옵션 연결 or 멤버 제거·색은 옵션 전담 택일) | 지금 삭제 금지(오차단 0·동작 셋트) |
| O-2 | 부모 072 print_opt POPT_001/002 보유(규범 §3-4 literal tension) | Medium | 규범 §1(§3-4 예외조항 보강) + §23(셋트 UI print_opt 전파 계약 확인) | 즉시 제거 금지(단면/양면 매출·가격 무해) |
| OPT_064 | 면지색 옵션의 work-order/SKU 실제 전달경로 미확인(U-3 최종 소비점) | 후속 검증 | webadmin 주문/작업지시 코드 확인 큐 | KEEP 불변(환각 아님·기각 아님) |
| §23-inner | 내지 284 contribution=0(내지 페이지곱 미기여) | 기존 pending | §23 "072 내지 반제품 승격 적재 대기"(본 §34 유발 아님·교차참조) | §34 NO-GO 아님 |

→ 상세 인계 = `handoff-spec.md`.
