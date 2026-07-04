# HANDOFF — 프린틀리(Printly) · 2026-07-05 (4세션)

## ★다음 시작점 = feasibility 척추 배선 (instance_of)

와우 전 상품이 온톨로지에 등록됐다(324상품·구성요소·제약). 이제 **구성요소별 `instance_of` 상위개념 배선**을 놓으면 06/08의 feasibility 필터("옵션 조합으로 어느 벤더가 만들 수 있나")가 실제로 돈다. = 질의 검증의 다음 depth.

1. **구성요소 → instance_of → 상위개념(U-3~U-8·U-18)** 배선 — `04_wow-registration/wow-components.json`의 dedup 구성요소(재질504·규격919·도수115·인쇄방식12·후가공474)를 브랜드-중립 상위개념에 건다. 후니 §33 구성요소도 같은 상위개념에.
2. 그 위에 **feasibility 질의** 데모: "홀로그램박 명함" → 어느 벤더가 그 후가공 보유? (06 하드필터·08 연결-앵커 실증).
3. 병행 후속: **스펙 정규화**(후니 auto-pick `.first()` 비대표 교정 — 스티커200만·현수막 견적불가·쿠폰28,591 과대) · **라이브 신규4 fetch**(catalog 부재·GAP-REG-1) · **후니 same_family_as 전 상품 정렬**(현재 대표만).

## ★프린틀리 정체·아키텍처 (지니 확정 · relitigate 금지)

**여러 벤더(후니·와우·레드) 엔진을 연결하는 소상공인 맞춤 AI 인쇄 에이전트(브로커).** = §35 다중브랜드 온톨로지+라우팅 런타임.
- **권위 서열(★260705 확정)**: **후니=권위 최상**(정본 참조모델 §33) → 와우/레드=후니에 매핑·**전환(fallback)**. 추천도 후니 우선→미보유/미가용 시 타 벤더 전환.
- **어댑터 브로커**: Printly가 논리파일 1개 + 벤더별 어댑터 소유(파일변환=특허 C3 장비가상화). 벤더 추가=어댑터 1개(선형).
- 견적=벤더별 엔진(D-18): 후니=evaluate_price(venv 로컬 실증)·와우=jobcost API(devshop 콘솔 실증)·레드=지니 WebToProduct 엔진.

## ★추천 3층 파이프라인 (순서 고정 1→2→3 · 이번 세션 정립)

- **1층 왜 이 홍보물**(`07_recommendation-basis.md`): 근거=소진공 분류+AliCoCo 원자기능8+셀별 출처·등급. 지니 확정 기준="출처+신뢰등급 표기로 충분"(verified 단정/candidate 완충/△ 미노출). 근거 두껍게=국내외 4슬라이스 리서치(`research/print-materials-evidence-base-260704.md`·업종8→12+·홍보물9→50+·교차확증). 상품군 축=`research/smb-product-taxonomy-miricanvas-260704.md`(프린트허브 10버킷·3축=업종/원자기능/상품군).
- **2~3층 어느 회사·가격**(`06_crossvendor-recommendation-design.md`): 4단 필터=**0.연결→1.가능(feasibility)→2.가격/납기→+이유**. 가격 값 온톨로지化 금지(경계+price_basis만). 옵션 충돌=상품 못 쪼갬→명시적 되묻기.
- **파일·주문**(`08_vendor-anchored-fulfillment-design.md`): 상품가이드→논리파일→벤더어댑터→벤더룰파일→잡티켓 주문. ★지니 확정: Q1 파일변환=하이브리드(프린틀리 논리+어댑터 소유·레드=지니엔진 위임) · Q2 착수=후니 1벤더 end-to-end 먼저.

## ★이번 세션(4) 산출·실증 (relitigate 금지)

- **와우 파일럿 7종 레시피**(`data/recipes/wow/`): 명함40073(A-1)·스티커40008(A-2)·엽서40346(A-3)·전단40054(A-7)·현수막40437(A-4)·매장용품POP40033(GAP)·쿠폰40110(A-13). 6부류+상위개념+same_family_as+jobcost 라이브 실견적. = **카페 오픈 6기능 교차브랜드 완성**.
- **질의 검증 데모**(`data/_scripts/crossbrand_query.py`): "카페 오픈"→7상품군 same_family_as 순회→후니 evaluate_price∥와우 jobcost 나란히. ★교차 3케이스 검증: ①양쪽보유=가격대조 ②와우단독(POP)=와우강제(비대칭) ③양벤더GAP=메뉴판.
- **추천 이유 배선**(`recommendation-layer.json`+`reason_demo.py`): 카페 파일럿 evidence 블록(등급·출처·이유)+products.group(진열대). 업종→기능→홍보물→이유(출처+등급)→진열대→엔진견적 종단.
- **★와우 전 상품 온톨로지 등록**(`_workspace/huni-multibrand-ontology/04_wow-registration/`): catalog 324상품 결정론 전사·구성요소 dedup(인쇄방식12백본·재질504·규격919·후가공474·부자재32)+used_by(공유맥락)+제약그래프(paper.rst_prsjob758·color.req_prsjob484). gstack browse 라이브대조(292 vs 326·신규4 발견).
- **실측 발견**: 가격순위 상품군마다 뒤집힘(명함 와우쌈·엽서 후니쌈)→나이브 비교 위험·price_basis 정규화 필요 / 커팅복잡도 축 실재(스티커 칼선N개·가성비 도무송 flat) / 인쇄방식 4종 U-4 포섭 / GAP-MENU=후니·와우 공통.

## 미해결 / 블로커

- **스펙 정규화 미완**(병목): 후니 auto-pick `.first()`가 면적매트릭스 상품 극단사이즈 선택(비대표). 질의 검증 신뢰도 위해 후니 대표사양 고정 필요.
- **GAP-REG-1**: 라이브 신규4(40086 2026캘린더·40617/40618 특수초강접스티커·40625 접착포스터) catalog 부재→API/refresh fetch.
- **catalog 노후**(2025-10-14): 의심분 라이브 재확인(재질 드리프트 실측: 엽서 띤또레또순백 라이브 추가).
- **견적0 결함**: 프리미엄명함031·펄명함034 미배선(가격 하네스 §13/§27 위임).
- **§36 정식 하네스화 미정**: 프린틀리 오케스트레이터+에이전트 정식화 여부.
- **지니 입력 대기**: Q5 파일포맷 원천·Q6 배송 범위·Q7 엔진 방식(신규 vs 래핑).

## 실행 방법 (재사용)

- **후니 실엔진 견적**: `raw/.venv/bin/python _workspace/printly/data/_scripts/crossbrand_query.py`(교차브랜드) · `reason_demo.py 카페 500`(추천 이유) · `compare_namecard.py`(명함).
- **와우 라이브 견적(devshop)**: gstack browse → `devshop.wowpress.co.kr/loginform`(`.env.local` WOWPRESS_SITE_ID/PW) → **★click 미제출·press Enter로 제출** → `/maint` → `/prodt/<prodno>` → 옵션 select → "가격조회" → `ordcost_bill`. 읽기(주문·결제 아님).
- **와우 축 전사**: `wow_extract.py <prodno>` · **전 상품 등록 재현**: `wow_ontology_register.py`.

## 건드리지 말 것

- §33/§35 골든 자산(읽기 재사용만·수정 금지). §35 build_graph·03_kb 정본.
- 원칙3 경계: AI/온톨로지가 견적·프리플라이트·파일변환 판단 금지(벤더 엔진 호출까지).
- 근거 없는 노드·가격·판정 생성 금지(원칙4). 가격 값은 엔진 관측만(지어내기 0).
- 5대 원칙[HARD]·매 단계 지니 확인(원칙5).

## 5대 원칙 [HARD]
1. 온톨로지=유일 진실원본(하드코딩 금지). 2. 3추론 분리(선언=온톨로지·절차=에이전트·결정론=엔진). 3. AI 값판단 금지(엔진 호출). 4. 모든 제안 node_id 근거. 5. 소단위·매 단계 지니 확인.

## 산출 인덱스 (`_workspace/printly/`)
- 설계: `00~05`(PART1~2)·`06 크로스벤더 추천`·`07 추천 근거`·`08 벤더앵커 파일변환`.
- research: industry-classification·**print-materials-evidence-base**·**smb-product-taxonomy-miricanvas**·webtoproduct-analysis·patent-analysis·red-docs.
- data: `recipes/{wow/*7종·_INDEX·_TEMPLATE}`·`printshops/{huni·wow}.json`(connection·print_rules)·`_scripts/{wow_extract·wow_ontology_register·crossbrand_query·reason_demo·compare_namecard·run_front_half}`·`recommendation-layer.json`(evidence·group 배선).
- §35 등록: `_workspace/huni-multibrand-ontology/04_wow-registration/{wow-products·wow-components·summary·README}`.
