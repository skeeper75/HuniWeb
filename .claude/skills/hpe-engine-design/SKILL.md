---
name: hpe-engine-design
description: >
  후니프린팅 가격계산 엔진 설계의 핵심 생성 방법론. 가격공식 지도+경쟁사 흡수 후보를 종합해 각 상품군 완제품·반제품
  (세트상품)의 가격공식+가격구성요소+t_prc_* 그릇 매핑+세트 조합 가격 모델을 라이브 evaluate_price가 그대로 먹는
  형태로 설계 명세화. search-before-mint·evaluate_price 계약 정합(silent 합산 방지·U-7 계승)·단가값 verbatim(날조 0)·DB 미적재.
  트리거: 가격엔진 설계, 가격공식 설계, 가격구성요소 설계, t_prc 그릇 설계, 세트상품 가격 설계, 골든 케이스 도출, 엔진 설계 다시.
  공식 지도는 hpe-formula-cartography, 경쟁사 흡수는 hpe-competitor-benchmark, 설계 검증은 hpe-design-validation.
metadata:
  version: "1.0.0"
  category: "domain"
  status: "active"
  updated: "2026-06-20"
---

# hpe-engine-design — 가격계산 엔진 핵심 설계 방법론

cartographer 지도 + benchmark 흡수 후보를 종합해, 후니가 실제로 가격을 계산할 수 있는 가격공식+구성요소 설계 명세를 만든다.

## 무엇을 설계하나

각 상품군 완제품·반제품이 "어떤 가격구성요소를 토대로 공식을 만드는가"를 설계한다. **새 엔진 코드가 아니라**, 라이브 단일 권위 알고리즘(`pricing.py evaluate_price`)에 그대로 태울 t_prc_* 데이터 그릇 설계다(webadmin 코드 직접수정 금지).

## 설계 산출 구조 (상품군마다)

1. **price_formulas** — 계산식(원자합산/면적매트릭스/수량구간/고정가/세트조합). 공식명=후니 레거시 용어(코드 노출 금지)·유형·비고.
2. **formula_components → price_components** — 공식이 합산/조합하는 구성요소. 의미축(자재/공정/사이즈/도수/옵션)·prc_typ(단가형/합가형)·use_dims 차원.
3. **component_prices** — 차원별 단가 충전 설계(면적 siz_width/height·수량구간·고정). 값=가격표 verbatim.
4. **product_price_formulas** — 상품↔공식 바인딩.
5. **세트(반제품) 조합 모델** — 구성품 완제품 공식 재사용 + 조합 레이어(합·번들 할인·대표 SKU). 이중계상 금지.

## search-before-mint [HARD]

새 공식/구성요소 mint 전, 라이브 t_prc_*·기존 하네스 설계(§7/§13/§16)에 재사용 가능분을 먼저 찾는다. 동종 구성요소는 종류축(proc_cd 트리·dim_vals·mat_cd) 차원키로 그룹핑(comp_grp 신설 불요). 신규는 무손실 표현 불가 입증 후. 채번=MAX+1·separator `_`.

## evaluate_price 계약 정합 [HARD]

설계는 라이브 엔진이 먹을 수 있어야 유효하다:
- 차원 자동매칭·가격 우선순위·단가/합가·할인 적용(engine-contract 인용 `huni-price-quote/01_engine/`).
- **시트 차원경계(SOT 1) 안에서만 배선** — 엔진이 silent하게 시트 밖 구성요소를 합산하지 않도록(U-7 binding-validity `huni-price-engine-diag/04_binding_validity/` 계승). 판별차원 없는 구성요소(단가행 전부 NULL→항상매칭)·동시매칭(ERR_AMBIGUOUS) 금지.
- 도수=print_opt_cd(clr_cd 아님)·면적=siz_width/height 등 차원 정합(diag 결론 계승).

## 인쇄 도메인 현실 존중

상품=출력소재+색+부속물+가공(공유 comp/공식 재사용·한 공식 여러 상품·한 시트 여러 공식 혼재). 여러 가격산정방식(규격가/합가매트릭스/고정/면적)은 결함 아닌 도메인 현실 — 비효율로 단정 말고 안전 시스템화. 실무진이 상품마스터·가격표로 정리한 것 존중.

## 출력
`03_design/`: `engine-design-<sheet>.md`(공식+구성요소+단가행+바인딩)·`set-product-design.md`(세트 모델)·`design-decisions.md`(결정·흡수·search-before-mint·trade-off·컨펌큐)·`golden-cases.md`(대표 케이스+기대 골든값=검증가 재현 대상).

## 안전 [HARD]
DB 미적재·실 적용(COMMIT/DDL)은 인간 승인 후 dbmap 위임·단가=가격표 verbatim(날조 0)·권위 엑셀 절대·경쟁사 흡수 naming 유입 금지·라이브 읽기전용·비밀값 비노출.
