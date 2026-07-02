# 표준 이름표 (standards) — 횡단 페이지 (자리표시)

> D-1·D-19: 각 개체·관계에 schema.org / XJDF / 구성 온톨로지 대응어를 붙인다(어휘만 차용·JDF/RDF 미도입).
> ★이 페이지는 노드 아님(참조 자리표시). 전량 매핑표는 `standards-mapping.md`로 승격 예정.
> 원본 = `../../00_research/product-ontology.md` ②-5.

| 개체 | schema.org | XJDF | 구성 온톨로지 |
|---|---|---|---|
| product | Product | — | component type |
| size | variesBy(size) | LayoutIntent FinishedDimensions | attribute value |
| material | variesBy(material) | MediaIntent | resource |
| print_option(도수) | — | ColorIntent | attribute |
| process | — | Process View / BindingIntent·FoldingIntent | function→process |
| price_formula/component | CompoundPriceSpecification(개념) | — | (값 계산=evaluate_price 권위) |
| constraint | — | — | constraint |
| intent | — | Product Intent(개념) | function |

(스키마 문서 `ontology-schema.md` §1 표의 "표준 이름표" 열이 1차 원천. 이 파일은 진입 링크용.)
