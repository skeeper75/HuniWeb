## 2026-07-05 (5세션·빌드) — 카페 상품군 인쇄소 배정 검토표 파일럿

- **지니 "배정표 만들어줘"** → `data/_scripts/sourcing_table.py`(crossbrand_query 후니견적·게이트 재사용) → `data/sourcing/cafe-sourcing-table-260705.md`. 카페 7상품군 [능력(후니/와우)·후니 원가(공급가)·와우 원가(공급가)·표준납기·추천 배정·사유]. ★원가=부가세 전 공급가(후니 evaluate_price·와우 **ordcost_sup 레시피 실재**·재수집 불필요·A-1 basis 정합). 값=엔진(지어내기 0).
- **배정 로직 3층 실현**: 1층 능력(POP=후니 미대응→와우 강제) → 2층 납기(v1 표준·미수집=수집예정) → 3층 경제성(후니 공동사업 기본·와우 원가 30%+ 저면 검토 신호). 쿠폰 A-13 NO_GO=와우 데이터 불신(재앵커)→후니 유지.
- **실측 결과**: 엽서·전단=후니 기본(원가차 미미) / **명함=와우 82% 저→마진 관점 검토 신호**(★지니가 원한 결정지원) / POP=와우 강제 / 스티커·현수막=후니 ⚠(auto-pick 극단 2백만·견적불가=스펙 정규화 필요) / 쿠폰=후니 유지(와우 재앵커 전).
- **정직성**: 0원 견적=견적불가 정규화(현수막)·원가차 신호는 "스펙 정합 확인 전 방향 신호"로 표기(후니 auto-pick≠와우 대표스펙 가능성)·납기 미수집 명시.
- **파일럿이 드러낸 러프 엣지(다음)**: ①후니 스펙 정규화 ②표준 리드타임 수집 ③쿠폰 재앵커(40110) → 전 상품군 전파.
- 변경: 신규 `data/_scripts/sourcing_table.py`·`data/sourcing/cafe-sourcing-table-260705.md`·`09`·`HANDOFF.md`.

# CHANGELOG — 프린틀리(Printly)

> 최신이 위(PREPEND). 프린틀리 = 다중 벤더 소상공인 AI 인쇄 에이전트(§35 런타임 실현체).

## 2026-07-05 (5세션·후반) — ★재구성: 벤더 배정(소싱) 정책 + 후니 부가세 별도 확정

- **★지니 4점 재구성**(정본 `09_vendor-sourcing-policy.md`·relitigate 금지): 비전문가 관점서 "무엇을 해야 blind spot 해결?" 질문 → 방향 대전환. ①소비자는 크로스벤더 **가격비교를 안 본다**·프린틀리가 배정한 **한 곳 가격 하나**만 봄(화이트라벨·인쇄소 은닉) ②소매/도매 차이=소비자 노출 아님 ③상품군마다 "어디로 배정"하는 **기준을 정하는 게 일** ④후니·와우 전 상품 선등록 이유가 이것. → **크로스벤더 비교(A-1)=소비자 기능 아님·지니 내부 소싱 결정 도구로 재해석**(06의 소비자-비교 프레임 교정).
- **벤더 관계 확정**: 후니=**공동사업 파트너**(지니가 후니 자동견적서비스 전권 보유·기본 배정·원가=공급가) · 와우=외부 도매 파트너(전환·원가=devshop 도매가) · 레드 미연결. "후니 권위 최상→나머지 전환"이 이 관계 때문임이 규명.
- **배정 기준 뼈대 v0.2**: 1단계 능력 게이트(후니 미대응→자동 와우·POP 실증) → 2단계 경쟁력(후니 기본·와우 "확실히 나으면" 전환·최종=지니 균형 판단·자동최적화 아님).
- **★후니 부가세 별도 확정**(지니 "이전사이트 확인해줘"): huniprinting.com/product/goods.asp가 가격을 **"공급가 : N원(부가세 전)"**으로 표시(golden_fetch.py read_supply_price)·evaluate_price 부가세 미가산·새 스키마 VAT_RATE=0.1 별도. → `printshops/huni.json` price_basis.vat_included=**false**(unknown→확정·GAP-BASIS-1 해소). 원가 공정비교=후니 공급가↔와우 ordcost_sup(둘 다 부가세 전·와우 재수집 필요 GAP-BASIS-3).
- **★지니 입력 대기(배정표 빌드 게이트 2건)**: (a) "확실히 낫다" 잣대(가격/품질/납기·권장=상품 성격별) (b) 소비자 "한 가격" 매기는 법(원가+마진율/소매가 그대로/후니·와우 다르게). 지니 선택=**"기준부터 더 다듬기"**(빌드 보류). 정해지면 카페 7상품군 배정표 파일럿→전파.
- 변경: 신규 `09_vendor-sourcing-policy.md`·`printshops/huni.json`(vat 확정)·`HANDOFF.md`.

## 2026-07-05 (5세션) — 정확성 축 교정: price_basis 정규화(A-1) + same_family_as 독립 게이트(A-5)

- **트리거**: HANDOFF blind-spot 감사 → 지니 "정확성 축 먼저" 선택. 다음 시작점(instance_of)이 **이미 도는 층(가격 비교·상품군 정렬)의 정확성 미검증 위에** 쌓이는 것을 발견 → 토대부터 교정.
- **A-1 price_basis 정규화**(완료·실증): `crossbrand_query.py:108`이 후니 소매(evaluate_price) vs 와우 도매(ordcost_bill)를 **부등호로 직접 비교**(코드가 "참고용"이라 자백하면서도 순위 출력)하던 근본결함 교정. 근거 확보=§35 wowpress-price-mechanism §3.2로 `ordcost_bill=ordcost_sup(공급가)+ordcost_tax(부가세)` → 와우 **VAT 포함 확정** / 후니 pricing.py `final_price=round_won(running)`·부가세 가산 없음 → **VAT 별도 추정**. `printshops/{huni,wow}.json`에 `price_basis`(channel·vat_included·output_field·GAP) 추가, 스크립트가 basis 정합할 때만 순위·다르면 **기권**(★도매→소매 환산계수 발명 금지=원칙3). 지니 확정="순위 기권·basis 나란히". 실증: GO 7상품군 전부 순위 기권. ★부수: 정직한 기권이 숨은 결함 노출(스티커 후니 2백만원=auto-pick 극단사이즈·쿠폰 와우샘플=명함스펙).
- **A-5 same_family_as 독립 검증 게이트**(완료·실증): keystone 엣지(후니↔와우 상품군 정렬 16쌍)가 생성측(mbo-crossbrand-mapper) 자기등급 strong/partial뿐·독립검증 부재 → §35 mbo-verify-gate로 재실측(생성≠검증·파일앵커 결정론 재파싱). 산출 `02_crossbrand/family-alignment-VERIFY-260705.md` + `family-verdicts.json`(기계가독). **G-FAM-1~4**: GO 11 / DOWNGRADE 5(A-8캘린더·A-9봉투·A-10홀더·A-11폰·A-13쿠폰). 결정적 결함=대표앵커 3건 오류(A-13 행택40109≠쿠폰[진짜=40110/40038]·A-11 케이스본체≠스마트톡40292·A-8 기성품≠업로드형). **A-13은 재앵커 전 NO_GO**. `crossbrand_query.py`가 verdict 소비: NO_GO=추천제외·DOWNGRADE=사양상이 경고. 실증: 쿠폰이 `A-5=NO_GO`로 헤더 표시·크로스벤더 제외.
- **★교차확증**: A-1(basis 정직 출력)과 A-5(독립 게이트)가 **쿠폰 결함에 무관하게 수렴**=우연 아님(생성≠검증 성과).
- **재앵커 백로그**(verdict JSON에 앵커 박힘·다음): A-13→40110/40038·A-11→40292·A-8→40232/40210·A-9 봉투core·A-10 가격비교금지. GAP-BASIS-1~3(후니 VAT 확정·와우 ordcost_sup 재캡처).
- 변경: `printshops/{huni,wow}.json`·`data/_scripts/crossbrand_query.py`·`HANDOFF.md`·신규 `02_crossbrand/{family-alignment-VERIFY-260705.md,family-verdicts.json}`.

## 2026-07-04~05 (4세션) — 와우 채움(7종) + 추천 3층 설계 정립 + 근거 두껍게 + 와우 전 상품 온톨로지 등록

- **와우 파일럿 7종 레시피**(`data/recipes/wow/`): 명함40073(A-1)·스티커40008(A-2·커팅복잡도축 실증)·엽서40346(A-3·합판디지털·가격순위 역전)·전단40054(A-7·인쇄방식 옵셋/UV 선택축)·현수막40437(A-4·대형실사·면적)·매장용품POP40033(★후니 미대응 비대칭)·쿠폰40110(A-13·카페 RETAIN·미싱 절취). 6부류+상위개념 instance_of+후니 same_family_as+jobcost **라이브 실견적**(devshop 콘솔). = 카페 오픈 6기능 교차브랜드 완성.
- **와우 라이브 실증 방법 확립**: devshop.wowpress.co.kr=개발자 가격조회 콘솔·로그인=`.env.local` WOWPRESS_SITE_ID/PW·★click 미제출→**press Enter**·`/prodt/<prodno>` select→"가격조회"→`ordcost_bill`(읽기). catalog(2025-10-14)=라이브 대조 확인·드리프트(엽서 재질 라이브 추가). 블로커1(실호출 vs 캐시) 해소=캐시 봉쇄(catalog 가격0)→devshop 실호출 유일.
- **질의 검증 데모**(`data/_scripts/crossbrand_query.py`): "카페 오픈"→7상품군 same_family_as 순회→후니 evaluate_price∥와우 jobcost 나란히·값=엔진·지어내기0. ★교차 3케이스: ①양쪽보유=가격대조(순위 상품군마다 뒤집힘·명함 와우쌈·엽서 후니쌈) ②와우단독(POP)=와우강제(연결-앵커 비대칭) ③양벤더GAP=메뉴판(후니·와우 공통·프린트허브만 有).
- **추천 3층 설계 정립**(순서 고정 1→2→3): `06_crossvendor-recommendation-design.md`(어느 회사·가격·4단 필터 0.연결→1.가능→2.가격·옵션충돌 되묻기·가격값 온톨로지化 금지)·`07_recommendation-basis.md`(왜 이 홍보물·출처+등급 사슬·지니 기준 "출처+신뢰등급으로 충분")·`08_vendor-anchored-fulfillment-design.md`(파일변환=논리파일+어댑터 C3·지니 확정 하이브리드/후니 1벤더 먼저).
- **추천 근거 두껍게**(국내외 4슬라이스 병렬 리서치): `research/print-materials-evidence-base-260704.md`(교차확증·업종8→12+·홍보물9→50+·정량=매크로 광고비만·소상공인 세분 부재 확정)·`research/smb-product-taxonomy-miricanvas-260704.md`(미리캔버스/프린트허브 렌즈=상품군 3번째 축·10버킷·매장용품 신규). 추천 이유 배선=`recommendation-layer.json`(카페 evidence 블록·products.group)+`reason_demo.py`(등급 어조).
- **★와우 전 상품 온톨로지 등록**(`_workspace/huni-multibrand-ontology/04_wow-registration/`·스크립트 `wow_ontology_register.py`): catalog 324상품 결정론 전사·구성요소 dedup(인쇄방식12백본·재질504·규격919·도수115·후가공474·부자재32)+used_by(공유맥락)+제약그래프(paper.rst_prsjob758·color.req_prsjob484). gstack browse 라이브대조(292 vs 326·신규4 발견). ★아키텍처 확정=**후니 권위 최상→나머지 전환**·Printly 어댑터 브로커.
- **벤더 그릇 배선**: `printshops/{huni·wow}.json`에 `connection`(후니 full·와우 price_api)+`print_rules`(축만·값 GAP).

## 2026-07-04 (3세션) — 데이터 공간 준비 + 소상공인 채움 + 와우 채우기 정리

- **RED 문서 4군 정독**(자동화 시스템 기획서 50p·자동견적/파일처리 V8·자동조판 V1/V3/V4·자동커팅+상품제안 → `research/red-docs/` 5노트+종합): 인쇄물 배송 전 여정=16단계 무인 파이프라인·후가공 14종 별색 레이어·견적 과금=길이/면적/개수 계산클래스·자동조판(다중주문 통합·판수최소·큰사이즈 RIP시간)·자동커팅(오일러/Bezier·1·2차 재단선). ★핵심: 스펙 확정되면 7~16단계=결정론 엔진·벤더 소유(RED 무인운영 증명)→프린틀리=앞단+오케스트레이션+온톨로지.
- **소상공인 앞단 빈 공간 채움**(커밋 fa38b8c): 추천층 8업종(카페·음식점·미용·학원·병원·부동산·소매·꽃집·소진공 근거)×원자기능8×홍보물18(라이브 접지) + `opts` 모드(옵션 타입 3단계 실재). 새 업종 실견적 검증.
- **★데이터 쌓을 공간 준비**(커밋 023b1ce·지니 지시 "인쇄소 가기 전까지 그릇+인쇄소 연결·생산=다음·후니 먼저·공간만"): `data/{README·SCHEMA}`(그릇 3종=추천·홍보물 레시피 6부류[재료·공정·가격구성요소·옵션·제약·생산가능성]·인쇄소 연결)·`recipes/{_TEMPLATE·_INDEX 진척판}`·`printshops/huni.json`. 데이터 미채움(공간만).
- **온톨로지 실재 실증**(공상 아님 질의 답): 후니 소재 613개(17유형·평량·계층 저장)·하드커버책자 셋트→구성원(표지/내지9종/면지3색)→소재 연결 라이브 실측. "전체 소재 이해→저장→연결→세부 셋트로 좁혀 추천→가격" 뼈대=후니 실재·실동. 추천층만 얇음·와우/레드/생산 미착수.
- **★와우 채우기 정리**(다음 세션): `data/_WOW-FILL-PLAN.md`(와우 원천=catalog 326 JSON·§35 01_analysis/02_crossbrand·후니와 차이=catalog앵커/6+2축/jobcost API·채우는 절차 7단계·[HARD] 원칙)·`printshops/wow.json`. 파일럿=family-alignment 16쌍 중 명함류. ★차이: 와우 가격=jobcost API 라이브 연동 필요(후니는 venv 로컬).

## 2026-07-04 (2세션) — PART 1 완결(Step2·3) + PART 2 브릿지 + 라이브 실증

- **Step 2 관계 정의**(`03_step2-relations.md`): 전반부 엣지 체인 정형화 — **신규 엣지 0**(search-before-mint). H1업종→기능·H2기능→홍보물=`references`(R19·한정자 dominance/fit)·H3~H6=§33 has_size/print_option/process/material/priced_by/has_component·V1~V4 다중벤더=§35 same_family_as/can_produce/quote_from. 마케팅 기능 8종=§33 intent 노드화(`intent_kind=marketing_function`·신규 개체0·키스톤). 추천 랭킹=경계(D-REC·값=엔진)·되묻기=에이전트 절차.
- **지니 확정 3결정**(Step2 §9): ①기능 노드화 승인 ②recommendation_function 보류(경계 규칙만) ③Step3 진행. **라이브 길찾기로 실증**(생성≠검증).
- **★라이브 길찾기 실증**: "카페 오픈 나눠줄 거→프리미엄엽서" 종단 순회를 라이브 DB로 검증(PRD_000016·사양7·공정7·PRF_DGP_A·구성요소10 전부 실재) + **실엔진 견적**(evaluate_price·venv django5.2): 프리미엄엽서 100장=9,424원/500장=24,378원(source=FORMULA)·단골관리 후보 3종(쿠폰 10,177/10,913·만년스탬프 900,000). 후보 가격 격차(만원 vs 90만원)가 결정2(순위 계산기)·되묻기 근거 확증.
- **Step 3 제약 정의**(`04_step3-constraints.md`): 안 되는 조합=§33 E12 constraint·R12 constrains·JSONLogic·§31 CN-1~CN-6 재사용(**신규 0**·라이브 26건/15상품 실재). ★경계: evaluate_price 제약 미참조(검증=위젯/에이전트). ★오분류 방지: "90만원"=제약 아님(되묻기 사안)·제약 vs 능력(can_produce) vs 가격갭 vs 되묻기 층 분리. → PART 1(Step0~3) 완결.
- **★PART 2 (1) 브릿지=잡티켓 데이터 계약**(`05_part2-bridge-jobticket.md`): 잡티켓=§35 fulfillment_order(E24)의 런타임 실현(**신규 그릇 0**·G-ROUTE-3 접합점이 이 브릿지). 사양 담체=evaluate_price `selections` 실계약과 동형(라이브 접지). ★원칙3 필드분리: 견적·판수·리드타임 3칸=엔진 전용(AI 지어내기 금지)·나머지=온톨로지. 계약 연쇄=preflight(C2)→imposition(C1)→장비가상화(C3)→생산 후가공 10단계. 파일변환=논리/가상 2층(장비추가=가상드라이버1개). 다중벤더=routed_to/quote_from→벤더 엔진(레드=지니 WebToProduct 엔진).
- **지도 아티팩트**(`_map/master-map.html`): 목적+3지도(WebToProduct 20단계·6층·Stage0~6)+지금여기. PART1 완료·결정확정·라이브실증 반영 재배포(동일 URL).
- **★전반부 종단 파일럿**(`pilot/`·커밋 2141d89): `recommendation-layer.json`(추천 층 선언 데이터·업종3×기능5×홍보물12·라이브 prd_cd 접지·원칙1) + `run_front_half.py`(층 순회+evaluate_price 실견적+근거 node_id 경로+되묻기 게이트) + README. 업종→기능→홍보물→실견적 **자동 종단**(미용실/카페 실행). 시스템 Stage 2(질의 시뮬레이터) 크리티컬 패스 최소 실현체. ★파일럿이 **실 결함 자동 적발**: 프리미엄명함(PRD_000031)·펄명함(034) 견적 0원(미배선·source=FORMULA)=로드맵 G-DATA "프리미엄명함 견적0" 일치→추천 데모+커버리지 진단 이중효과. 만년스탬프 90만원=되묻기 사안(Step3 경계 실증). 순위=결정론 placeholder(최종=엔진·recommendation_function 보류).
- 커밋: 6f404ff(Step2/3+브릿지)·2141d89(파일럿). 상태: PART1 완결·PART2 브릿지·파일럿 실동. 다음=NL 입력 진입(권장)/견적0 결함 교정/PART 2-2 런타임 루프.

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
