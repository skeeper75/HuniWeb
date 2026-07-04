# HANDOFF — 프린틀리(Printly) · 2026-07-05 (5세션)

## ★다음 시작점 (5세션 종료 시점 · 재발견 0)

**이번 세션 = 벤더 배정(소싱) 정책 정립 + 정확성 축 + 와우 제약/가격 인프라.** 메커니즘은 다 갖춰졌고, 남은 건 **큐레이션·정렬** 2가지로 수렴한다.

- **정본 문서**: `09_vendor-sourcing-policy.md`(배정 정책·정체성·relitigate 금지) · `06/07/08`(추천 3층). 아래 섹션들은 근거 기록.
- **완성된 것**: ①배정 기준 3층(능력→납기→경제성)·가격정책(원가+마진)·정체성(경쟁자=대행사·무기=디자인자동화) ②정확성 축(A-1 price_basis·A-5 same_family 게이트·family-verdicts.json) ③24 상품군 서비스 커버리지(양벤더 18·와우단독 6·`wow-service-coverage-260705.md`) ④와우 제약 그래프 ~21,000(`wow-constraints.json`·feasibility 토대) ⑤jobcost API 직접 배치(`wow_price_fetch.py`·인증·payload 검증) ⑥후니 부가세 별도 확정.
- **★다음 (수렴 2트랙)**:
  1. **대표 큐레이션**(후니·와우 공통 관문) — 상품군별 대표 사양 짝맞춤(스티커=합판도무송·명함=일반명함). 이게 되면 24군 깔끔한 배정표(양쪽 기본구성 공급가 비교). 후니 스펙=`.first()`→dflt_yn 이미 착수·와우=폴백 비전형 교정.
  2. **제약 상위개념 정렬**(instance_of) — 후니↔와우 req/rst 제약(~21k)+구성요소를 브랜드-중립 상위개념에 걸어 **feasibility 질의**("어느 벤더가 이 조합 만드나") 실동. 착수 전: "미등록 vs 불가" 표식 분리(닫힌세계×노후catalog 오배제 방지).
- **미해결/블로커**: ①후니 반칼원형 작은 원형 사이즈 미등록+dflt_yn 3중복(지니 교정 영역) ②쿠폰 A-13 재앵커(40110/40038)·A-11→40292·A-8→40232/40210 ③표준 리드타임 미수집(후니 모델 납기필드 없음·v2=API/MCP 실시간) ④라이브 신규4 fetch(catalog 부재) ⑤★open API=기본구성가만(colorno/ordqty 불변·양면/수량배수는 devshop콘솔/주문엔진·D-18) ⑥배치 실패 3군(부자재/와우기획=인쇄축無·책자=402).
- **건드리지 말 것**: `wow-components.json`(§35 골든 dedup)·§33/§35 골든 자산·`09` 정책(지니 확정)·`.env.local`(WOWPRESS_AUTH 갱신됨·gitignored). 원칙3(AI 값판단 금지)·원칙4(node_id 근거).
- **재사용 실행법**: 와우 API=`raw/.venv/bin/python`으로 `/api/login/issue`(WOWPRESS_AUTH_UID/PW)→token→`/api/v1/ord/cjson_jobcost`(Bearer). 비규격=width/height 필수. 후니 견적=crossbrand_query.huni_repr_price(dflt_yn). 배정표=sourcing_table.py·커버리지=service_coverage.py.

---

## ★★5세션 재구성(260705·지니 확정) = 벤더 배정(소싱) 정책 — 소비자는 비교 안 본다

**정본=`09_vendor-sourcing-policy.md`(relitigate 금지).** 지니 4점 재구성: ①소비자는 인쇄소를 모르고 **프린틀리가 배정한 한 곳 가격 하나만** 본다(화이트라벨) ②소매/도매 차이는 소비자 노출 아님 ③상품군마다 "어디로 배정할지" 기준을 정하는 게 일 ④그래서 후니·와우 전 상품 선등록.
- **크로스벤더 비교(A-1)=소비자 기능 아님·지니 내부 소싱 결정 도구**로 재해석(06의 "소비자가 비교 본다" 프레임 교정).
- **벤더 관계**: 후니=공동사업 파트너(전권·기본 배정) · 와우=외부 도매 파트너(전환) · 레드 미연결.
- **★배정 기준 완성 v0.3 (3층)**: 1층 정적 능력(못 만들면 탈락) → 2층 동적 생산가능성·납기(장비 가동률·유휴로 납기 못 맞추면 전환·v1=표준 리드타임·v2=후니 서비스 API/MCP 실시간) → 3층 경제성·균형(후니 기본·상품 성격별 판단·최종=지니). 인쇄소=API/MCP 어댑터 1개(견적+납기).
- **가격 정책 확정**: 소비자가 = **원가(제휴 조건·기여도) + 지니 마진율**(+부가세). 부가세=후니 별도(공급가·이전사이트 "공급가:N원(부가세전)")·와우 포함(전=ordcost_sup). huni.json vat_included=false.
- **★정체성·포지셔닝 확정(relitigate 금지)**: 소비자는 벤더 가격 비교 안 함 → 후니/와우 배정=프린틀리 마진·안정성 문제. 경쟁자=디자인 대행사·크몽·숨고(직접주문 인쇄사이트 아님). 무기=AI 디자인→레이어 분리(qwenimagelayered)→인쇄소 규격 파일 자동생성(WebToProduct·특허 C2/C3)·대행 대비 ~1/5(측정 대기). "소비자 이득"=최저가 아니라 접근성·done-for-you.
- **★배정 검토표 파일럿 완료(260705)**: `data/_scripts/sourcing_table.py`→`data/sourcing/cafe-sourcing-table-260705.md`. 카페 7상품군 [능력·후니 공급가·와우 공급가·납기·추천배정]. 와우 ordcost_sup 레시피 실재(재수집 불필요). 실측: POP→와우 강제·명함 와우 82% 저(마진 검토)·쿠폰 와우 불신(재앵커)·스티커/현수막 후니 ⚠(스펙 정규화).
- **★스펙 정규화 착수(260705·v1.1)**: `.first()`→**기본값(dflt_yn)** + 상태(below_min/⚠사양) + **후니·와우 사양 표시**. 규명=**후니 엔진 정상·"비교 설정" 문제**(스티커 2백만=A5 반칼원형 기본≠와우 60x40 사각도무송 / 합판도무송 0원=최소 1000매 규칙[1000매=20,000원] / 현수막 5000x900 기본=off-grid). ★진짜 비교가능=**명함만**(양쪽 90x50 동일→와우 82% 저=실신호). 나머지=상품군별 대표상품·사이즈 큐레이션 필요(지니). 오라클=goods.asp(공급가) 대조 예정.
- **★제약 그래프 등록 + jobcost API 언블록(260705·병렬 2트랙)**: ①**와우 전체 req/rst 제약 그래프 등록**(신규 `04_wow-registration/wow-constraints.json`·6.6MB): 현 2종→**~21,000 제약**(노드엣지 19,927[req_awkjob 6972·rst_awkjob 6942·rst_paper 5546·rst_prsjob 186·req_color 141·req_prsjob 140] + 값-규칙 1,065[rst_jobqty 493·rst_size 416·수량/규격 범위]). 드리프트0·전 catalog 앵커·독립검증(40005 awkjob28001→req_awkjob 11345 truthful)·GAP 80엣지 정직기록. wow-components.json 무손상. = 배정 능력/feasibility 데이터 토대. ②**jobcost API 직접 배치 뚫음**(`wow_price_fetch.py`·`wow-group-prices-260705.json`·21/24군): 인증+payload 검증(40073 단면500=sup 3100 재현). ★API 한계 실증=colorno(단면/양면)·ordqty 불변·paper/size/ordcnt만 가격변동→**open API=기본구성가만·양면·수량배수는 devshop콘솔/주문엔진(D-18 정합)**. ★대표 큐레이션 이슈=폴백이 비전형 대표 선정(명함→레이저마킹·스티커→롤스티커)→군간 비교 아직 불가(후니 스펙정규화와 동일 테마). 실패 3군(부자재/와우기획=인쇄축無·책자=402 후가공).
- **★products_spec 분석**(`04_wow-registration/products-spec-ontology-mapping-260705.md`·커밋2c523215): 온톨로지=축·제약·규칙 / 엔진=가격값 / 런타임=배송지(D-18).
- **★24 상품군 서비스 커버리지 완성(260705·지니 "와우 전 상품 등록해 상품군수 확보")**: 와우 온톨로지는 **이미 324상품·24군 등록 완료**(4세션). `service_coverage.py`→`data/sourcing/wow-service-coverage-260705.md`. **프린틀리 확보 상품군=24개**(양벤더 정렬 16 · 와우단독/미정렬 8). 각 군=[상품수·와우 대표·후니 정렬(family-verdicts)·배정후보]. 미등록 catalog 3=selType/name None(제외 정당)·라이브 신규4만 fetch 남음.
- **★다음**: ①정렬 확장 후보 4군(팬시·서식·디지털인쇄·포토액자) 후니 매칭 조사→양벤더 승격 ②상품군별 와우 대표 가격 fetch(배정표 24군 확장) ③후니 스펙 정규화(사이즈 등록·dflt_yn 중복=지니 교정) ④goods.asp 오라클 대조 ⑤쿠폰 A-13 재앵커·표준 리드타임.
- **★후니 스티커 진단(참고·지니 교정 영역)**: 배정표 2백만원=엔진 정상·데이터 문제(반칼원형 058 기본 사이즈=A5 큰것·이전사이트 실측 원형32mm=333,000원). 새 DB에 작은 원형 사이즈 미등록+dflt_yn 3중복. webadmin 시뮬레이터=evaluate_price 래퍼(독립검증 아님)·독립 오라클=goods.asp.

## 정확성 축 완료(5세션·260705) → instance_of 배선(이제 견고한 위에서)

**A-1 price_basis + A-5 same_family_as 게이트가 배선됨** → 크로스벤더 추천이 이제 정직해졌다. instance_of는 이 위에서 착수.
- **A-1(price_basis 정규화·완료)**: `printshops/{huni,wow}.json`에 `price_basis` 추가(후니=retail·VAT 별도추정 / 와우=partner_billed·VAT 포함확정[ordcost_bill=공급가+부가세]). `crossbrand_query.py`가 basis 정합할 때만 순위 판정·다르면 **기권**(도매→소매 환산 발명 금지·원칙3). 실증: GO 쌍 전부 순위 기권·나란히 표시.
- **A-5(same_family_as 독립 게이트·완료)**: §35 mbo-verify-gate가 16쌍 재실측 → `02_crossbrand/family-alignment-VERIFY-260705.md` + `family-verdicts.json`(기계가독). 파이프라인이 verdict 소비: **NO_GO=추천 제외·DOWNGRADE=사양상이 경고**. GO 11 / DOWNGRADE 5(A-8·9·10·11·13). ★A-1·A-5가 **쿠폰(A-13) 결함에 독립 수렴**(앵커=행택40109 오류→NO_GO).
- **★재앵커 백로그(DOWNGRADE 5쌍·verdict JSON에 앵커 박힘)**: A-13 쿠폰→40110/40038 · A-11 폰→40292 스마트톡 · A-8 캘린더→40232/40210 · A-9 봉투 core만 · A-10 홀더 가격비교 금지.

### 그다음 = feasibility 척추 배선 (instance_of)
와우 전 상품이 온톨로지에 등록됐다(324상품·구성요소·제약). **구성요소별 `instance_of` 상위개념 배선**을 놓으면 06/08의 feasibility 필터("옵션 조합으로 어느 벤더가 만들 수 있나")가 돈다. ★단 착수 전: (a) "미등록 vs 불가" 표식 분리(닫힌세계×노후catalog=오배제 방지) (b) 동의어 정규화 false-merge/split 검증.

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

- **스펙 정규화 미완**(병목): 후니 auto-pick `.first()`가 면적매트릭스 상품 극단사이즈 선택(비대표·스티커 2백만원 실증). 질의 검증 신뢰도 위해 후니 대표사양 고정 필요.
- **basis 정합 데이터 부족**(A-1 GAP-BASIS-1~3): 후니 VAT 포함여부 미확정(별도 추정) · 와우 레시피에 `ordcost_sup`(VAT-excl) 미보존. 이 둘 확보 시 부가세축 정합 가능(채널 도매/소매는 동일채널 데이터 필요·환산 발명 금지). 현재는 순위 전면 기권 상태.
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
