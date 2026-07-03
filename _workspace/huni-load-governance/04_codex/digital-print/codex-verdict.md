# 디지털인쇄 옵션 판정 — codex 독립 2차 교차검증 (codex-verdict)

> §34 Huni-Load-Governance · Phase 3 · hlg-codex-verifier · 2026-07-03
> 검증자: **codex gpt-5.5** (`codex exec -s read-only`, reasoning effort=high)
> 헬퍼: `.claude/skills/hqv-codex-cross-verify/scripts/codex-review.sh` (preflight=AVAILABLE model=gpt-5.5)
> 독립성: codex에 Claude의 결론을 채점시키지 않고, **원자료(규범 2 + board CSV 325행 + spec)** 를 주고 독립 판정 후 reconcile.
> 원출력 전문: `codex-raw-output.txt` (이 디렉토리) · 세션 id 019f23b6-20b9-7122-801b-1bf355f85e46
> ★[HARD] codex 주장 = 가설. 아래 판정은 reconcile.md에서 board 원자료 재확인으로 검증됨.

---

## 0. codex 총평 (원문)

- **Overall: AGREE 2 / DISAGREE 2 / UNCERTAIN 1.**
- codex가 짚은 "Claude가 가장 크게 놓친 것": **`ref target exists`(트리거 정합)를 `semantic ref correct`(의미 정합)로 착각**.
  특히 `PRD_042` KEEP 판정은 board 내부 증거만으로도 깨진다.

---

## 1. 5개 적대 과제별 codex 판정 (원문 요지)

| # | 과제 | codex VERDICT | 핵심 근거(codex) |
|---|------|---------------|------------------|
| 1 | MOVE-기준정보=0 공격 (단일항목 024/026 포함) | **AGREE** | 4파일 안에 "기준정보만 남겨도 mat_cd 선택/가격 성립" 증거 없음. 옵션→ref_dim_cd 환원이 CPQ 정규 경로 → MOVE 근거 부족 |
| 2 | EXTEND 21 적정성 (특히 무옵션 9상품) | **UNCERTAIN** | 보강류 EXTEND는 타당. 단 9개 무옵션 상품 근거가 전부 `§21 cpq-defect-board 기대옵션` 인용 → 4파일만으로 260702 권위/base-only 충분성 검증 불가. KEEP/RETIRE 교정 증거도 없어 보류가 맞다 |
| 3 | BLOCKED miss / PRD_037 박종류 | **DISAGREE** | 가격축이 opt_cd인데 .03자재+.04공정 BUNDLE 대체가 가격 보존한다는 증거 없음 → criteria §4상 **BLOCKED(또는 EXTEND-BLOCKED)** 로 분리해야 |
| 4 | 환각/근거부족 (비-AMBIG 판정) | **DISAGREE** | ★`PRD_042 종이` KEEP인데 board ref해소가 `스타드림(실버)→MAT_000128(면끈)`·`골드→MAT_000129(아크릴키링고리)`·`다이아→MAT_000240(보드스탠딩)`·`로츠쿼츠→MAT_000241(핀버튼)` = **의미 오매핑**. 트리거 정합≠의미 정합 → KEEP 아니라 **EXTEND+가격검증 게이트** |
| 5 | EXTEND 오분류/선택지손실 위험 | **AGREE** | Claude가 "missing 자재 삭제"라 하진 않음(선택지손실 유발 안 함). 단 `PRD_047`은 "1종 미실재"만 보강하면 부족 — 잘못 해소된 자재 ref(실버→면끈·골드→키링고리·로즈쿼츠→네오디움자석)도 함께 교정 필요 |

---

## 2. codex 단독 주장 (미검증 가설 — 사실 채택 금지)

codex 자신이 "4파일만으로 검증 불가"로 분류한 항목(reconcile에서 §21/라이브 위임 큐로만 처리):

1. `PRD_034/035/036/039/043/044/045/048/049`(무옵션 9상품)가 **base-info only로 충분**할 수 있다 → 미검증 가설.
2. `PRD_037` `.03+.04 BUNDLE` 재배선이 **가격을 보존**한다 → 미검증 가설(그래서 codex도 BLOCKED 권고).

이 둘은 reconcile에서 라이브/권위(§21·evaluate_price)로 검증되기 전까지 **사실로 채택하지 않는다**.
