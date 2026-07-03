# PRD_072 하드커버책자 셋트 — codex 독립 2차 교차검증 판정

> §34 Huni-Load-Governance · Phase 3 · hlg-codex-verifier · 2026-07-03
> codex-cli(gpt-5.5·`-s read-only`·high effort) 독립 판정 · 헬퍼=`hqv-codex-cross-verify/scripts/codex-review.sh`
> preflight AVAILABLE(gpt-5.5) · 환각 테이블/컬럼 0(참조어 전부 실재) · **codex 주장=가설**(reconcile에서 라이브/규범으로 판정)
> 프롬프트 원본=`_codex-prompt.md`(원자료=규범+라이브 인벤토리 실측, Claude 처분 결론 비노출·독립 재도출 요청)

---

## 0. codex 판정 요약 (AGREE/DISAGREE 4가설)

| 가설 | codex 판정 | 요지 |
|------|-----------|------|
| **1** 삼중표현 중복 부정 | **부분 AGREE** | OPT_064 KEEP·MAT_382/383/384 KEEP(중복 아님·필수 ref 백킹)은 합의. 단 멤버 074/075/076을 "완전 정상"으로 본 것은 안일 → **빈 멤버 오배치/latent RETIRE 후보** |
| **2** 가격종속 N 오류 | **AGREE** | component_prices 0·opt 참조 component 0 → 면지색은 evaluate_set_price에 기여 경로 없음. BLOCKED 불필요. 단 가격 아닌 선택/생산 축이라 삭제 금지 |
| **3** O-2 부모 print_opt | **DISAGREE** | 부모 072 POPT_001/002 활성 = **규범 §3-4 실질 위반 후보**. "이중청구 없음"은 가격 무손상 근거일 뿐 "부모 보유 정당" 근거 아님. 1차의 Low는 과소평가. 처분은 UI 전파 계약 확인 전 BLOCKED |
| **4** O-1 지금 처분? | **부분 AGREE** | 지금 가격결함은 아님(합의)·즉시 삭제는 오차단 0 위반. 그러나 Low 컨펌큐보다 강한 **명시 차단 규칙/구조정리 필요** |

**총평**: codex는 옵션/자재 레이어(가설1·2)에서는 Claude의 KEEP·가격종속 N·중복 아님에 **합의**하고, RETIRE/MOVE 처리를 오히려 **FP로 경고**했다. 불일치는 오직 **관찰 2건(O-1·O-2)의 심각도 등급**에 집중 — codex는 둘 다 "Low보다 실질적"이라며 격상을 주장한다.

## 1. codex FN 후보 (1차가 놓쳤을 수 있는 것)
- 부모 072 print_options 활성 보유는 1차가 본 것보다 실질적 §3-4 위반 후보(가격 이중청구 없어도 위반은 남음).
- 면지 멤버 074/075/076 = "중복"보다 "**조건부 멤버 모델 미완성**". 존재시킬 거면 옵션 선택↔멤버 포함이 연결돼야 하고, 아니면 set member에서 제외돼야 함.
- OPT_064가 **실제 생산 작업지시(work-order)에 전달되는지** 근거 없음. 가격 무영향이어도 U-3 생산전달 용도면 work-order 경로 검증 필요.

## 2. codex FP 경고 (과잉 처분 오판 방지)
- OPT_064+MAT_382/383/384를 기준정보 중복으로 몰아 MOVE 처리 = **FP**(.03 자재 ref는 필수 백킹·가격 0·selector 역할 실재).
- 면지색 옵션을 "가격 미사용 잡음"으로 RETIRE = **FP**(가격축 아니나 고객 선택·생산 전달 축).

→ codex의 FP 경고는 Claude의 "전건 KEEP·RETIRE/MOVE 0건" 판정과 **동일 방향**이다(둘 다 처분 반대).

## 3. codex 원출력 경로
- 프롬프트: `_workspace/huni-load-governance/04_codex/hardcover-072/_codex-prompt.md`
- 세션 id: 019f23b8-242e-78a0-a41e-e65366367261 · tokens 29,061 · exit 0
- (원문 판정 전문은 본 문서 §0~§2에 축약 인용 — verbatim 원출력은 codex-review.sh stdout)
