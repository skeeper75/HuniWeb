# CHANGELOG — 프린틀리(Printly)

> 최신이 위(PREPEND). 프린틀리 = 다중 벤더 소상공인 AI 인쇄 에이전트(§35 런타임 실현체).

## 2026-07-04 (2세션) — PART 1 완결(Step2·3) + PART 2 브릿지 + 라이브 실증

- **Step 2 관계 정의**(`03_step2-relations.md`): 전반부 엣지 체인 정형화 — **신규 엣지 0**(search-before-mint). H1업종→기능·H2기능→홍보물=`references`(R19·한정자 dominance/fit)·H3~H6=§33 has_size/print_option/process/material/priced_by/has_component·V1~V4 다중벤더=§35 same_family_as/can_produce/quote_from. 마케팅 기능 8종=§33 intent 노드화(`intent_kind=marketing_function`·신규 개체0·키스톤). 추천 랭킹=경계(D-REC·값=엔진)·되묻기=에이전트 절차.
- **지니 확정 3결정**(Step2 §9): ①기능 노드화 승인 ②recommendation_function 보류(경계 규칙만) ③Step3 진행. **라이브 길찾기로 실증**(생성≠검증).
- **★라이브 길찾기 실증**: "카페 오픈 나눠줄 거→프리미엄엽서" 종단 순회를 라이브 DB로 검증(PRD_000016·사양7·공정7·PRF_DGP_A·구성요소10 전부 실재) + **실엔진 견적**(evaluate_price·venv django5.2): 프리미엄엽서 100장=9,424원/500장=24,378원(source=FORMULA)·단골관리 후보 3종(쿠폰 10,177/10,913·만년스탬프 900,000). 후보 가격 격차(만원 vs 90만원)가 결정2(순위 계산기)·되묻기 근거 확증.
- **Step 3 제약 정의**(`04_step3-constraints.md`): 안 되는 조합=§33 E12 constraint·R12 constrains·JSONLogic·§31 CN-1~CN-6 재사용(**신규 0**·라이브 26건/15상품 실재). ★경계: evaluate_price 제약 미참조(검증=위젯/에이전트). ★오분류 방지: "90만원"=제약 아님(되묻기 사안)·제약 vs 능력(can_produce) vs 가격갭 vs 되묻기 층 분리. → PART 1(Step0~3) 완결.
- **★PART 2 (1) 브릿지=잡티켓 데이터 계약**(`05_part2-bridge-jobticket.md`): 잡티켓=§35 fulfillment_order(E24)의 런타임 실현(**신규 그릇 0**·G-ROUTE-3 접합점이 이 브릿지). 사양 담체=evaluate_price `selections` 실계약과 동형(라이브 접지). ★원칙3 필드분리: 견적·판수·리드타임 3칸=엔진 전용(AI 지어내기 금지)·나머지=온톨로지. 계약 연쇄=preflight(C2)→imposition(C1)→장비가상화(C3)→생산 후가공 10단계. 파일변환=논리/가상 2층(장비추가=가상드라이버1개). 다중벤더=routed_to/quote_from→벤더 엔진(레드=지니 WebToProduct 엔진).
- **지도 아티팩트**(`_map/master-map.html`): 목적+3지도(WebToProduct 20단계·6층·Stage0~6)+지금여기. PART1 완료·결정확정·라이브실증 반영 재배포(동일 URL).
- 상태: PART 1 완결·PART 2 브릿지 설계 완료·미커밋분 커밋 대기. 다음=PART 2-2 런타임 루프 or 잡티켓 정형 스키마 or Q5/6/7(파일포맷 원천·배송범위·엔진 인터페이스 지니 입력).

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
