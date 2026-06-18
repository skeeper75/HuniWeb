---
name: hbd-codex-cross-verify
description: >
  후니프린팅 기초데이터 표시중복 정리 하네스의 codex cli 2차 독립 교차검증 방법론. Claude가 설계한
  정리/적재 매핑(mapping.csv)·적재 명세(apply-plan.md)를 Codex(gpt-5.5)에 codex exec 읽기전용으로
  넘겨, 데이터를 잘못 적재하지 않는지 독립 2nd opinion을 받고 Claude 판정과 reconcile하는 절차를
  제공한다. 기존 codex-review.sh + codex-preflight.sh 재사용, 적대적 검토 질문(false-positive·
  가격사슬 파손·표시실제 오판·무손실 위반), codex 주장=가설(환각 경계), 미가용 시 Claude 단독 폴백을
  다룬다. 'codex 교차검증', '독립 2nd opinion', 'codex 적재검토', '오적재 방지', 'reconcile', '교차검증 다시'
  작업 시 사용.
license: Apache-2.0
allowed-tools: Read, Write, Edit, Grep, Glob, Bash, TodoWrite
metadata:
  version: "1.0.0"
  category: "domain"
  status: "active"
  updated: "2026-06-19"
  tags: "codex, cross-verify, reconcile, hallucination-guard, basedata"
---

# hbd-codex-cross-verify — codex 2차 교차검증 방법론

## 왜 codex인가

사용자 directive: "Claude에서 실행하되 오류가 있을 수 있으니 codex cli로 한번 더 검토해 데이터가 잘못 적재되지 않게." 같은 모델의 자기검증보다 **독립 모델(OpenAI gpt-5.5)** 의 2nd opinion이 오적재를 더 잘 잡는다. 단 codex 주장은 가설일 뿐(환각 경계) — 라이브/권위로 검증되기 전엔 채택하지 않는다.

## 절차

1. **work-spec 프롬프트 작성**. `codex-prompt.txt`에 ① 축·canonical 정의·검사 4축 ② 검토 대상(mapping.csv 요약·apply-plan) ③ 적대적 질문을 담는다. **비밀값(.env) 절대 금지**.
   적대적 질문 예: "통합 후보 중 의미가 다른(작업/재단/단위) 것이 섞였나? / 가격종속 코드를 건드려 component_prices가 깨지나? / 표시↔실제 불일치 판정이 맞나? / 통합이 단가행·바인딩을 잃나?" — 기본값을 '의심'으로.
2. **codex 호출(헬퍼 재사용)**:
   ```bash
   bash .claude/skills/hqv-codex-cross-verify/scripts/codex-review.sh \
     _workspace/huni-basedata-dedup/<axis>/codex-prompt.txt gpt-5.5 \
     _workspace/huni-basedata-dedup/<axis>
   ```
   - preflight가 가용성 판정. 종료코드 0=응답, 2=codex 미가용(데드락/인증).
   - workdir는 codex가 읽을 캐시·매핑이 있는 디렉토리.
3. **환각 경계 [HARD]**. codex가 인용한 근거(특정 코드·치수)가 실재하는지 캐시(`index.csv`)·라이브로 대조한다. 근거 없는 주장은 채택 보류.
4. **reconcile**. 매핑 행별로 {Claude 판정, codex 판정, 합의}를 표로. 합의=고신뢰(진행), 불일치=divergence(해소 전 적재 금지·dedup-analyst 반려).
5. **미가용 폴백 [HARD]**. 종료코드 2면 "codex 미가용 — Claude 단독 검증"을 명시하고, 적재는 보수적으로(고확신·가격비종속·표시정규화 한정) 권고. pending으로 멈추지 않는다.

## 산출물

`_workspace/huni-basedata-dedup/<axis>/`: `codex-prompt.txt`·`codex-verdict.md`(codex 원문 + 환각 주석)·`reconcile.md`(행별 합의표 + divergence + 진행 권고).

## 하지 말 것

- codex 주장을 라이브 검증 없이 사실로 채택.
- .env 비밀값을 프롬프트에 포함.
- codex 미가용을 pending으로 방치(폴백 명시 필수).
