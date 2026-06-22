---
name: hpe-codex-validate
description: >
  후니프린팅 가격엔진 설계를 Codex(gpt-5.5)로 독립 2차 교차검증하고 hpe-validator(Claude) 판정과 reconcile하는
  방법론(Phase 5.5). codex exec 읽기전용으로 designer 설계+지도+흡수후보+golden을 넘겨 가격계산 가능성·흡수 타당성·
  골든 재현을 독립 판정·합의/불일치 reconcile. Codex 주장=가설·환각 경계(검증 전 채택 금지)·validator 판정 비노출(독립성)·
  미가용 시 Claude 단독 폴백(pending 금지)·읽기전용.
  트리거: codex 설계검증, codex 교차검증, 설계 2nd opinion, E게이트 독립 재판정, reconcile, codex 검증 다시.
  설계 생성은 hpe-engine-design, Claude측 E게이트 검증은 hpe-design-validation.
metadata:
  version: "1.0.0"
  category: "domain"
  status: "active"
  updated: "2026-06-20"
---

# hpe-codex-validate — Codex 독립 2차 교차검증 방법론 (Phase 5.5)

hpe-validator(Claude)의 E1~E7 결론과 designer 설계를 외부 모델(Codex gpt-5.5)로 독립 재판정한 뒤 reconcile한다.

## 왜 Codex 병행인가

가격은 돈 크리티컬이고 단일 모델은 "그럴듯하지만 틀린" 판정을 한다. 독립 외부 모델이 같은 증거를 독립 판정하면 한 모델이 합리화한 설계 오류를 잡는다. 후니 codex=ChatGPT 구독(OAuth)이라 API 종량과금 없음 → 병행이 비용 효율적.

## ★핵심 경계 [HARD] — 환각 방지

Codex 제안은 **외부 의견·가설**이다. 라이브 후니 스키마·권위 엑셀·경쟁사 라이브로 검증 전엔 사실로 채택 금지(rpm-deepcheck/hqv 계승). codex가 "X 설계가 틀렸다"고 해도 라이브 실재 확인 전엔 "codex 주장(미검증)"으로 분류. 환각을 결론으로 올리면 잘못 설계된다. codex의 라이브 인용은 환각 가능 → 직접 재측정 또는 validator 라우팅.

## 절차

### 1. preflight (가용성 판정)
`hqv-codex-cross-verify/scripts/codex-review.sh`가 내부에서 `codex-preflight.sh` 호출:
- `AVAILABLE model=X` → 진행. `AUTH_STALE` → 인증 만료(codex login) → "Claude 단독" 명시.
- `DEADLOCK/UNAVAILABLE` → 폴백(gpt-5) 1회 후 미가용 시 "Claude 단독". 미가용=폴백이지 pending 아님(검증 안 멈춤). codex-review.sh가 내부 preflight 백그라운드 행(exit 144/127) 시 `codex exec -m gpt-5.5 --sandbox read-only --skip-git-repo-check --output-last-message` foreground 직접 호출로 우회.

### 2. 프롬프트 구성 (독립성·보안)
- codex 프롬프트엔 **설계(engine-design·set-product-design)+지도(formula-map)+흡수후보(absorption-candidates)+golden-cases**만. ★hpe-validator 판정(gate-verdict)은 넣지 않음(독립성·echo 방지).
- 질문: "이 가격공식+구성요소 설계가 상품을 실제 가격계산 가능하게 하는가? 빠진 구성요소(견적 결과 안 나옴)·오배선·차원 미스매치·세트 이중계상은? 경쟁사 흡수가 답습/overfit인가? golden-cases가 설계 공식으로 권위값을 재현하는가? 근거와 함께 독립 판정. 모르면 모른다고."
- ★비밀값·자격증명·라이브 접속정보·`.env.local` 절대 프롬프트 비노출. workdir=`_workspace/huni-price-engine-design/` 또는 프로젝트 루트(codex가 산출물 읽도록). `/tmp` trusted-dir 미인정 시 `--skip-git-repo-check`+stdin 우회.

### 3. reconcile
codex 판정 ↔ hpe-validator 판정(`04_validation/gate-verdict-<sheet>.md`·너만 읽음) 대조:
- **합의** = 고신뢰 확정. **불일치(divergence)** = 조사 신호(어느 쪽이 라이브/권위에 맞는지 판별·재측정 또는 라우팅). codex 단독 주장 = "미검증 가설"(채택 보류).
- 충돌 시 라이브 우선·codex에 맞춰 자동 flip 금지.

## 출력
`05_codex/`: `codex-verdict-<sheet>.md`(원문·각 주장 `미검증` 태그)·`codex-reconcile-<sheet>.md`(합의[고신뢰]/불일치[조사·해소·소유자] 매트릭스 + codex 가용성 노트).

## 안전 [HARD]
codex `-s read-only`·비밀값 비노출·주장=가설(환각 경계)·미가용=정직 명시(거짓 GO·pending 위장 금지)·라이브 우선·자동 flip 금지.
