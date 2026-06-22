---
name: hpq-quote-gate-validation
description: >-
  생성측 결함 보드와 권위 골든값을 독립 재실측하고 라이브 가격엔진(evaluate_price)을 호출/재구현해 견적을
  재계산하여 P1~P7 게이트로 GO/NO-GO를 내는 냉철한 검증 방법론 스킬(가격계산 검증 하네스). P1 엔진계약 충실성·
  P2 골든 재현성(오차 0)·P3 차원매핑 정확성(use_dims↔단가행↔권위 3원)·P4 불필요분 실재성·P5 옵션/템플릿/제약/
  공정 정합·P6 사이즈 무중복·P7 생성-검증 독립성(dodge-hunt·날조 적발). evaluate_price 직접 호출 우선·재구현은
  P1 동치 입증 후만 신뢰·시뮬레이터/뷰어 3원 대조·하나라도 FAIL=NO-GO·거짓 GO 금지·검증 전용·실 교정 인간 승인.
  트리거: P1 P7, 가격 게이트, 독립 재계산, 견적 검증, 시뮬레이터 검증, GO NO-GO, 냉철한 평가, 골든 재현, 게이트
  다시. 가격사슬 생성 검사는 hpq-price-chain-inspection, 옵션/제약 생성 검사는 hpq-option-constraint-mapping이 담당.
---

# hpq-quote-gate-validation — 독립 재계산·냉철한 게이트 방법론

## 목적

사용자가 강조한 **"냉철한 평가와 검증"의 최종 관문**. 생성측 주장을 신뢰하지 않고 독립 재실측·재계산해
라이브 데이터가 정말 권위에 맞게 매핑됐는지 P1~P7로 판정한다. **검증 전용**(생성과 다른 에이전트).

## 핵심 자세 [HARD]
- **생성자 주장 비신뢰**: 결함 보드의 모든 주장을 재현 쿼리/케이스로 직접 재실행해 비준/기각. "보고서에
  있으니 사실" 금지. 거짓 GO·날조·인용 라인 부존재 적극 적발(dodge-hunt).
- **엔진을 권위로**: 가능하면 라이브 `evaluate_price`를 Django shell/스크립트로 직접 호출해 final_price와
  단계 내역을 얻는다. 호출 불가 시 pricing.py 충실 재구현하되 **P1에서 동치 입증(같은 입력 동일 출력)을
  선행**한 뒤에만 재구현값 신뢰.
- **돈 크리티컬 신중**: 의심스러우면 GO 주지 않는다. 정직한 CONDITIONAL(일부만 검증) 허용.

## P1~P7 게이트

| 게이트 | 판정 기준 | FAIL 시 |
|--------|----------|---------|
| **P1** 엔진계약 충실성 | 검증 방법이 evaluate_price 실제 로직과 일치(재구현=동치 입증) | 재구현값 신뢰 불가 → UNVERIFIED |
| **P2** 골든 재현성 | 대표 케이스 재계산 final_price = 엑셀 골든(오차 0) | 어느 단계(구성요소·차원·할인)에서 갈렸는지 지목 |
| **P3** 차원매핑 정확성 | use_dims↔단가행↔권위 3원 일치(생성측 매트릭스 독립 재실측) | 불일치 구성요소·차원 명시 |
| **P4** 불필요분 실재성 | 판별차원없음·동시매칭·고아·중복을 재현쿼리로 재실행해 실재 확인 | 거짓 결함 기각 / 실재 결함 비준 |
| **P5** 옵션/템플릿/제약/공정 | BUNDLE·JSONLogic·dim_vals·트리거 무결성 독립 재검 | 위반 항목 명시 |
| **P6** 사이즈 무중복 | siz_cd 중복·축혼동·비규격 정합 재실측 | 중복/혼동 행 명시 |
| **P7** 생성-검증 독립성 | 생성자 주장 비신뢰·라이브 직접 재실측·날조 적발 | 자기승인·날조 적발 시 전체 재검 |

**하나라도 FAIL → 전체 NO-GO.** 거짓 GO 금지.

## 재계산 절차
1. golden-cases의 대표 케이스(선택+수량+grade)를 입력으로 evaluate_price 호출(또는 재구현).
2. 결과 final_price·base.components·discounts를 권위 골든값과 대조(오차 0 기준).
3. 라이브 가격시뮬레이터·가격뷰어 화면값과 3원 대조(gstack 읽기 탐색만).
4. 불일치 시 단계 내역(recompute-log)으로 원인 단계 지목.

## 산출
`_workspace/huni-price-quote/05_gate/`: gate-verdict.md(P1~P7) · recompute-log.md · confirmed-defects.md

## 수렴·위임
- NO-GO → 막힌 게이트·보정안을 생성측에 피드백 → 보정 → 재게이트(수렴까지 폐루프).
- 비준된 결함만 **인간 승인 큐**(confirmed-defects)로. 실 교정/COMMIT/DDL은 본 스킬이 하지 않고 인간
  승인 후 dbmap 트랙(dbm-axis-staged-load·dbm-load-execution·dbm-price-arbiter) 위임.
- evaluate_price 호출 실패 시 재구현 폴백하되 P1 미입증이면 GO 금지(UNVERIFIED). 라이브 읽기전용·DB 쓰기 0.
