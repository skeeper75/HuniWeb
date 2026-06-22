---
name: hec-flow-validation
description: 후니 Edicus 코드맵 하네스(Huni-Edicus-Codemap)의 독립 검증 게이트 방법론(생성≠검증). API 계약·코드맵·mermaid 문서를 원본(Edicus PDF·edicus.man src·환경변수)으로 독립 재실측해 C1~C6(API 계약 충실성·코드맵 정확성·코드↔API 배선 정합·다이어그램 렌더가능성·아키텍처 완전성·비밀값 비노출)로 GO/NO-GO를 낸다. 생성자 주장 비신뢰·직접 원본 대조·근거 없으면 NO-GO·비밀 노출 시 즉시 NO-GO·읽기전용. 트리거: 코드맵 검증, C1 C6 게이트, API 계약 검증, 코드 배선 검증, mermaid 정합 검증, 비밀 노출 점검, 검증 다시. 생성은 각 hec 생성 스킬 담당.
---

# hec-flow-validation — C1~C6 독립 검증 게이트

## 목적
생성 산출(API 계약·코드맵·mermaid)이 원본에 충실한지 **독립 재실측**으로 판정.

## C-게이트 (전부 PASS여야 GO)
- **C1 API 계약 충실성** — 카탈로그의 `PDF p.N` 인용 표본을 Read(pages)로 직접 확인. 시그니처·config·이벤트명 정확, 날조 0.
- **C2 코드맵 정확성** — `code-facts.csv`·배선의 `파일:라인` 표본 재실측. 없는 심볼·잘못된 경로 적발.
- **C3 코드↔API 배선 정합[핵심]** — 코드가 실제 호출하는 Edicus 메서드/이벤트(grep 확인)와 배선도 일치. 누락·환각·불일치 표기 여부.
- **C4 다이어그램 렌더가능성** — mermaid 펜스 균형·노드/엣지 문법 린트.
- **C5 아키텍처 완전성** — 주요 레이어(라우트·hooks·types·상태·미들웨어·외부연동)·Edicus 핵심 메서드/이벤트/토큰 빠짐없이 반영.
- **C6 비밀값 비노출[HARD]** — 산출 전체에 `.env.local` 실제 값(시크릿·비밀번호) 노출 0. 키 이름만. 노출 시 즉시 NO-GO.

## 절차
1. 표본 선정(핵심=C3 배선·C1 PDF 근거).
2. 직접 재실측: Read(PDF pages)·Grep·python.
3. 게이트별 PASS/FAIL+근거.
4. 종합 GO/NO-GO/CONDITIONAL + 수정 라우팅(C1=api-cartographer, C2/C3=code-cartographer·flow-author, C4=flow-author, C6=해당 산출자).

## 핵심 규칙
- 직접 재실측(생성 산출만 읽고 판정 금지).
- dodge-hunt: 누락·얼버무림 적발.
- C6 비밀 노출은 무조건 차단.

## 비밀 노출 점검 스크립트
산출 디렉토리에서 `.env.local` 값과의 일치를 검사(값 자체를 출력하지 말고 일치 여부만):
```
# 예: env 값이 산출물에 새어나왔는지 (값은 출력 안 함)
while IFS='=' read -r k v; do [ -n "$v" ] && grep -rqF "$v" _workspace/huni-edicus-codemap/0[1-3]_* 2>/dev/null && echo "LEAK risk: $k"; done < .env.local
```

## 산출
`_workspace/huni-edicus-codemap/04_validation/gate-verdict.md`
