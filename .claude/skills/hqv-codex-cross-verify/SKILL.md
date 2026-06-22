---
name: hqv-codex-cross-verify
description: >
  후니프린팅 가격계산 검증을 Codex(gpt-5.5)로 독립 교차검증(2nd opinion)하고 Claude 판정과 reconcile하는 방법론 스킬.
  codex exec 읽기전용 호출(scripts/codex-review.sh)로 work-spec·공식사슬·골든을 넘겨 독립 판정받고 합의/불일치 reconcile.
  ★[HARD] Codex 제안=외부 의견·가설(라이브/권위 검증 전 채택 금지·환각 경계). 미가용 시 "Claude 단독" 명시 폴백(pending 금지)·
  비밀값 프롬프트 비노출. 트리거: codex 교차검증, 독립 2nd opinion, codex 가격검증, codex 병행 검토, reconcile, 교차검증 다시.
  명령 해독은 hqv-product-decompose, Claude측 실측 검증은 hqv-quote-verification이 담당.
---

# hqv-codex-cross-verify — Codex 독립 교차검증 방법론

Claude 1차 검증과 독립으로 Codex(gpt-5.5) 2nd opinion을 받아 가격계산 검증 신뢰도를 올린다.

## 왜 Codex 병행인가

가격은 돈 크리티컬이고 단일 모델은 "그럴듯하지만 틀린" 판정을 한다(검증자 SIZ 오판·dormant 196 위반 실증). 독립 외부 모델이 같은 입력을 독립 판정하면 한 모델이 합리화한 오류를 잡는다. 후니 codex=ChatGPT 구독(OAuth)이라 API 종량과금 없음 → 병행이 비용 효율적.

## ★핵심 경계 [HARD] — 환각 방지

Codex 제안은 **외부 의견·가설**이다. 라이브 DB·권위 엑셀로 검증 전엔 사실로 채택 금지(rpm-deepcheck 계승). codex가 "X가 틀렸다"고 해도 라이브 실재 확인 전엔 "codex 주장(미검증)"으로 분류. 환각을 결론으로 올리면 잘못 교정된다.

## 절차

### 1. preflight (가용성 판정)
`scripts/codex-review.sh`가 내부에서 `rpm-visualize/scripts/codex-preflight.sh`를 호출해 판정:
- `AVAILABLE model=X` → 진행(가용 모델로).
- `AUTH_STALE` → 인증 만료(codex login 필요) → "codex 미가용·Claude 단독" 명시.
- `DEADLOCK/UNAVAILABLE` → 모델 데드락 → 폴백(gpt-5) 1회 후 미가용 시 "Claude 단독" 명시.
- 미가용은 **pending이 아니라 폴백**(검증을 멈추지 않음). 토큰문제 vs 모델데드락을 구분해 보고.

### 2. 프롬프트 구성 (독립성·보안)
- codex 프롬프트엔 **work-spec(product-spec·golden-cases·verify-workspec) + 공식사슬 요약 + 골든**만. ★Claude 판정(verdict-claude)은 넣지 않음(독립성).
- 질문: "이 상품이 가격공식으로 가격계산 되는가? 3축(SOT 일치/공식↔구성요소 매핑/차원 매칭)에서 깨지는 곳은? 근거와 함께 독립 판정. 모르면 모른다고."
- ★비밀값·자격증명·라이브 접속정보 절대 프롬프트 비노출.

### 3. codex exec 호출
`scripts/codex-review.sh <prompt_file> gpt-5.5 <workdir>`:
- `-s read-only` 강제(codex 파일 쓰기·DB 접속 없음).
- workdir = `_workspace/huni-quote-verify/<product>/` 또는 프로젝트 루트(codex가 산출물 읽도록).

### 4. reconcile
Claude 판정(`02_verify/verdict-claude.md`) ↔ codex 판정 대조:
- **합의** = 고신뢰 확정.
- **불일치(divergence)** = 조사 신호. 어느 쪽이 라이브/권위에 맞는지 판별(라이브 재실측 또는 컨펌큐).
- codex 단독 주장 = "미검증 가설"로 분류(채택 보류).

## 출력
- `codex-prompt.md`(감사) · `codex-verdict.md`(원문·가설 명시) · `reconciliation.md`(합의/불일치 매트릭스·divergence 조사·미검증 가설).

## 안전 [HARD]
- codex `-s read-only`·비밀값 비노출·주장=가설(환각 경계). 미가용=정직 명시(거짓 GO·pending 위장 금지).
