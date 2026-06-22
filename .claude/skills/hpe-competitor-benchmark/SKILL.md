---
name: hpe-competitor-benchmark
description: >
  후니프린팅 가격엔진 설계용 경쟁사 가격계산 방식 흡수 방법론. 와우프레스·레드프린팅이 가격을 어떤 구성요소 축·
  계산식 패턴·옵션 캐스케이드·세트 합성으로 만드는지 라이브 읽기전용 분석해 후니 t_prc_* 흡수 후보로 정리.
  흡수≠답습(naming/codes 유입 금지·권위 엑셀 덮어쓰기 금지). 라이브 읽기전용(주문/결제/POST 금지).
  트리거: 경쟁사 가격계산 방식, 와우프레스 가격 분석, 레드프린팅 가격 분석, 가격계산 벤치마크, 흡수 가능 방법, 세트 가격 패턴, 벤치마크 다시.
  내부 공식 지도는 hpe-formula-cartography, 엔진 설계는 hpe-engine-design, 가격차 합리성 대조는 dbm-competitor-benchmark.
metadata:
  version: "1.0.0"
  category: "domain"
  status: "active"
  updated: "2026-06-20"
---

# hpe-competitor-benchmark — 경쟁사 가격계산 방식 흡수 방법론

"와우프레스·레드가 가격을 *어떻게 계산하는가*"를 역공학해 후니 엔진 설계에 흡수할 방법을 추출한다.

## 이 벤치마크의 목적 (혼동 주의)

`dbm-competitor-benchmark`(§7)는 우리 산출 가격이 합리적인지 가격차로 판정한다. 본 스킬은 다르다 — 경쟁사의 **가격 모델 패턴 자체**(구성요소 축·계산식·캐스케이드·세트)를 흡수 후보로 정리해 designer에 공급한다.

## 두 원천 (기존 캡처 1차 재사용)

1. **와우프레스** — `_workspace/print-quote/`·`raw/widget_monitor/wow_capture/` 기존 캡처 우선. 보강은 공개 OpenAPI/라이브 가격조회(저트래픽 읽기전용). 옵션선택→가격응답 패턴.
2. **레드프린팅** — 사용자 본인 설계(검증된 참조). `raw/widget_monitor/red_captures/`·`docs/reversing/`·`_workspace/huni-rpmeta/`(메타모델) 1차 재사용. 라이브 보강=읽기전용 가격조회만.

## 흡수 렌즈

| 렌즈 | 무엇 | 후니 매핑 |
|------|------|----------|
| 구성요소 축 | 가격을 어떤 축(자재·인쇄방식·후가공·수량·면적·옵션)으로 분해 | t_prc_* 의미축 |
| 계산식 패턴 | 합산/곱셈/매트릭스/구간/기본가+가산·할인 순서 | price_formulas 유형 |
| 옵션 캐스케이드 | 상위 옵션→하위 단가표 전환 | rpmeta 캐스케이드·constraints |
| 세트/번들(반제품) | 구성품 조합 가격 합성 | 세트상품 설계 입력 |

## 흡수 vs 답습 [HARD]

메커니즘·표현력은 **흡수**, naming/codes는 **후니 유입 금지**, 권위 엑셀은 **덮어쓰지 않음**(경쟁사=갭헌팅·후니 권위 최종). RedPrinting=사용자 본인 설계라 흡수 정당하나, 후니 t_prc_* 컨벤션으로 번역. "외형이 이질적"이라고 새 축을 만들지 말고, 후니가 이미 담을 수 있으면 흡수 불요로 판정.

## 출력
`02_benchmark/`: `competitor-pricing-models.md`(모델 분석·출처)·`absorption-candidates.md`(흡수 후보·t_prc_* 매핑·trade-off·유입 가드)·`set-pricing-patterns.md`(세트 합성 패턴).

## 안전 [HARD]
라이브 읽기전용 가격조회·주문/결제/POST 금지·저트래픽(영향 0)·기존 캡처 우선·DB 쓰기 0·각 패턴 출처·naming 유입 금지·비밀값 비노출.
