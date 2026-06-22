# divergence 최종 판가름 — 메인 오케스트레이터 직접 라이브 재측정 (2026-06-18)

> hrv-validator가 "codex 3/3 승·기존 premium-postcard 검증 날조"로 판정한 건에 대해, 메인이 라이브 원천을 직접 재측정해 종결.
> ★결정적 도구 = `upd_dt`(라이브 변경 시각). 라이브 읽기전용 SELECT만.

## 종결 판정: 라이브 드리프트(작업 중 변경)·"날조" 규정은 오류

### 사실 1 — S2 배선: 라이브가 오늘 변경됨 (둘 다 시점엔 맞음)
- **메인 초반 측정(이번 세션 초)**: `t_prc_formula_components` JOIN 조회 → PRF_DGP_A에 S1(seq1)+**S2(seq2,addtn_yn=Y)** 배선. recompute baseline 26,250(S1 8,750+S2 17,500)은 이 스냅샷에 충실.
- **현재 재측정(종결)**: PRF_DGP_A formula_components = S1(seq0)·SPOT_WHITE(1)·PAPER(2)·CORNER(3)·CREASE·PERF·VARTEXT·VARIMG·COAT — **S2 없음**. disp_seq 전면 재번호(1,2,3,13→0,1,2,3).
- **★진원 = `t_prc_formula_components` WHERE frm_cd='PRF_DGP_A' upd_dt = 2026-06-18 21:11(오늘)**. 두 측정 사이 라이브 PRF_DGP_A 배선이 실제 편집됨(S2 제거·재배치). COMP_PRINT_DIGITAL_S2 del_yn=Y(B/C/F에만 배선).
- → codex auditor·hrv-validator는 **현재 상태**를 정확히 측정. 메인 초반 측정은 **이전 상태**를 정확히 측정. 모순 아님 = **라이브 드리프트**(메모리 [[dbmap-acrylic-price-chain-link]] "라이브 부분 진화" 패턴 재확인).

### 사실 2 — S1 단가값: 날조 아님 (불변 확인)
- hrv-validator는 "S1 단가 450/350/130 = 라이브 부재·날조"로 규정. **오류.**
- 현재 재측정 S1@SIZ_000499 = POPT_000001: 450/400/350/130 · POPT_000002: 900/850/800/310 — **초반 측정과 byte 동일**(upd_dt 2026-06-17, 불변). 라이브 실재값·날조 아님.
- → validator가 "값 부재=날조"로 과잉 규정. 실제는 값 실재 + 배선만 드리프트.

### 사실 3 — F-1 print_opt 축 의미 충돌: STANDS (유효)
- 상품 PRD_000016 print_opt: POPT_000001=단면·POPT_000002=양면(면). 가격 S1 단가행: POPT_000001=흑백단면B값·POPT_000002=칼라단면D값. → 같은 코드가 상품=면·가격데이터=도수 충돌. **F-1 유효**(validator도 "POPT=면" 동의 — 충돌의 한 변).

## premium-postcard 결론에 대한 영향 (정정)
- **F-1(축 의미 충돌)·교정 모델(단일 칼라 comp·골든 800×25=20,000) = 유효 유지.** 현재 라이브가 이미 S1 단독(S2 del_yn=Y)이므로 F-2 교정과 정합 방향으로 라이브 자가 진화.
- **F-2(S1+S2 이중배선) = 측정 시점엔 사실, 현재 라이브선 이미 해소**(S2 제거·del_yn=Y, 오늘 편집). → premium-postcard verdict는 "날조"가 아니라 **freshness 갱신 필요**(스냅샷 시점 명기). recompute baseline 26,250은 이전 스냅샷 기준이라 STALE.
- hrv-validator의 "기존 검증 전부 무효·날조" = **과잉**. 정정: 일부(F-2 배선)는 라이브 드리프트로 현재 무효, 핵심(F-1·골든 교정)은 유효.

## ★하네스 운영 교훈 (durable)
1. **라이브 DB는 작업 중에도 변하는 움직이는 표적** — 스냅샷(comp_prices.json export)은 세션 내에도 stale 가능. PRF_DGP_A는 오늘 21:11 편집됨.
2. **upd_dt 필수 체크** — 결함/배선 판정 전 대상 행의 upd_dt로 freshness 확인. 드리프트 vs 날조 구분의 유일 수단.
3. **검증자도 비신뢰** — hrv-validator(독립)조차 "드리프트"를 "날조"로 오인. 최종 권위 = 라이브 원천 재측정 + upd_dt. 생성≠검증의 한 단계 위 = 메인의 원천 재측정.

## 하네스 파일럿 판정
huni-recipe-viz 디지털인쇄 파일럿 = **GO(운영 검증)**. codex 생성(레시피·viz·연결진단) → Claude 검증 → 메인 원천 재측정의 3중 사슬이 **실제 라이브 드리프트를 적발**. 하네스 신뢰성 입증. hrv-validation 스킬에 upd_dt freshness 게이트 추가 권장(진화).
