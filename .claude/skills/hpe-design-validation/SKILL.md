---
name: hpe-design-validation
description: >
  후니프린팅 가격계산 엔진 설계의 Claude측 독립 검증 게이트 방법론(생성≠검증). engine-designer 설계(공식+구성요소+세트)를
  라이브 t_prc_*·권위 엑셀로 독립 재실측해 E1~E7 게이트로 GO/NO-GO(공식 추출 충실성·구성요소 분해 정합·경쟁사 흡수 타당성·
  엔진 설계 건전성·세트 조합 정합·골든 재현 허용오차 0·생성검증 독립성). 단일 FAIL=NO-GO·생성자 주장 비신뢰·라이브 읽기전용·
  DB 미적재. 트리거: 가격엔진 설계 검증, E1 E7 게이트, 골든 재현 검증, 설계 교차검증, search-before-mint 검증, 검증 게이트 다시.
  설계 생성은 hpe-engine-design, codex 2차 교차는 hpe-codex-validate가 담당.
metadata:
  version: "1.0.0"
  category: "domain"
  status: "active"
  updated: "2026-06-20"
---

# hpe-design-validation — 가격엔진 설계 독립 검증 게이트 방법론

engine-designer의 설계를 독립으로 깬다. 돈 크리티컬이라 "그럴듯하지만 틀린" 설계를 잡는 게 임무다.

## 왜 독립 검증인가

가격은 단일 모델이 합리화한 오류가 들어가기 쉽다(검증자조차 도수축 오판·dormant 위반 실증). 생성자 주장을 신뢰하지 말고 라이브·권위 엑셀로 **직접 재실측**한다. 같은 컨텍스트에서 self-approve 금지.

## E 게이트 (전건 통과=GO·단일 FAIL=NO-GO)

| 게이트 | 검사 | 적발 대상 |
|--------|------|----------|
| **E1** 공식 추출 충실성 | cartographer 지도가 상품마스터 공식·가격표 차원 충실 반영 | 셀 재대조·날조/누락·v03 인용 |
| **E2** 구성요소 분해 정합 | 설계 구성요소가 시트 차원경계(SOT 1) 안 | silent 합산 오배선·의미축 이중 인코딩·완제품/반제품 오구분 |
| **E3** 경쟁사 흡수 타당성 | 흡수≠답습 | 권위 덮어쓰기·naming/codes 유입·후니 표현력 초과 mint |
| **E4** 엔진 설계 건전성 | evaluate_price 계약 정합 | search-before-mint 위반(불필요 mint)·채번 오류·FK 위상·차원 자동매칭 |
| **E5** 세트(반제품) 조합 정합 | 세트 가격 합성 무모순 | 이중계상·구성품 누락·번들 할인 오류 |
| **E6** 골든 재현 | 설계 공식으로 golden-cases 실제 재계산 | 권위값 수치 대조 허용오차 0·갈린 구성요소/차원 지목 |
| **E7** 생성-검증 독립성 | 자기 재유도 안 함 | self-approve·dodge-hunt·생성자 주장 무비판 수용 |

## E6 골든 재현 (판정의 자)

라이브 evaluate_price를 **실제 호출**(임시 venv Django 부트스트랩 또는 동치 재구현·동치 입증 선행)해 golden-cases의 대표 케이스+수량을 재계산하고 권위 가격표 골든값과 수치 대조(허용오차 0). 불일치=어느 구성요소/차원에서 갈렸는지 recompute-log로 지목.

## dodge-hunt
설계가 "GO처럼 보이게" 골든을 순환 참조(설계값으로 골든 만들고 그걸로 재현)하지 않았나·off-grid/판걸이수 같은 런타임 계산을 단가행으로 위장하지 않았나 적극 추적.

## 출력
`04_validation/`: `gate-verdict-<sheet>.md`(E1~E7·증거 SQL·결함)·`recompute-log.md`(골든 재계산·대조·갈린 지점)·`validation-summary.md`(종합 GO/조건부/NO-GO·보정 요구·컨펌큐).

## 안전 [HARD]
라이브 읽기전용 SELECT만·DB 쓰기 0·각 결함 재현 SQL/셀·추정 금지(실측)·권위 엑셀 절대·생성자 주장 비신뢰·비밀값 비노출.
