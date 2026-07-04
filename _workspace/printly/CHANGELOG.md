# CHANGELOG — 프린틀리(Printly)

> 최신이 위(PREPEND). 프린틀리 = 다중 벤더 소상공인 AI 인쇄 에이전트(§35 런타임 실현체).

## 2026-07-04 — 빌드 착수 (Step0~1 + 전반부 + WebToProduct/특허 분석)

- **지니 빌드 지침 수령**(PART 0~4): 온톨로지 기반 인쇄 견적·생산 에이전트. 5대 원칙[HARD](온톨로지=진실원본·3추론 분리·AI 값판단 금지·node_id 근거·소단위 확인). 참조=tykimos ANA/ANL·uEngine Ontology Studio.
- **Step0 개념 정규화**(`00_step0-concept-normalization.md`): 프린틀리 7엔티티→§33/§35 매핑(4재사용·3신규). ★지니 게이트 3확정: §33/§35 코퍼스 재사용·업종=intent 확장·마케팅 아키타입 우선.
- **Step1 엔티티**(`01_step1-entities.md`): 7종 그릇+속성(①업종=intent확장 ②홍보물=§33 product ③사양=§33 4축 ④장비=§35 capability ⑤인쇄소=§35 supplier ⑥파일포맷=신규 ⑦배송=신규).
- **리서치 파이프라인 정렬 분해**(A/B/C 대체): 전반부 R1업종/R2홍보물사양/R3후가공견적 · 브릿지 R4잡티켓 · 후반부 R5장비/R6파일포맷/R7프리플라이트임포지션/R8라우팅배송. ★지니 확정="전반부 먼저".
- **전반부 명세**(`02_front-half-spec.md`): 업종→추천→사양→견적. ★R3=evaluate_price가 후가공까지 이미 견적함 확인(§27 formula_components).
- **리서치 산출**: industry-classification(소진공 업종8·원자기능8)·print-production-standards(CIP4 외 7기관 5층·장비5종×파일포맷)·delivery-research(리드타임 2분해).
- **★WebToProduct 원본 덱 분석**(`research/webtoproduct-analysis.md`·RED 133p 완독): 20단계 파이프라인·잡티켓 데이터계약·장비별 파일변환 매트릭스(JDF/ZCC/GPGL/PLT…)·후가공 공정 축. 프린틀리 PART2 런타임루프와 거의 1:1.
- **★특허 분석·통합**(`research/patent-analysis.md`·5p): ★지니 본인 발명·등재=프린틀리 자산(경쟁사 제약 아님·IP 재작성). 4청구항 전부 결정론 엔진(원칙3 실증)=C1 생산시간예측·C2 커팅 프리플라이트·C3 장비가상화·C4 무센서커팅(범위밖). 개선/보완/확장/수정/추가 정리.
- **★정체 정정 + 특허 통합**(Step1 §1-C): 프린틀리 = **다중 벤더 브로커**(후니·와우·레드 엔진 연결)=§35 런타임. ⑤인쇄소=벤더/브랜드·견적=벤더별 엔진(§35 D-18). ⑥파일포맷=논리/가상 2층 교정(C3). 신규 엔진 production_time_function(C1·리드타임)·커팅 preflight(C2)·다중주문 imposition(C1).
- 상태: Step0~1+전반부 완료·미커밋분 커밋 대기. 다음=전반부 관계정의(Step2)/잡티켓/실화면점검(지니 확정). §36 정식화 미정.
