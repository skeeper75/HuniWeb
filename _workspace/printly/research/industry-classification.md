# 프린틀리 — 업종 분류 + 업종별 인쇄물 추천 기준 (리서치)

> 작성: 2026-07-04 · 지니 지시 1(업종 엔티티 ①·추천 진입점 근거) 리서치.
> [HARD] 실 출처 앵커·지어내기 금지·불명확=GAP·파일럿 우선(전 업종 망라 아님).
> §33 재사용(search-before-mint) — 업종=intent 축 확장(Step 0 Q1 확정)·마케팅 아키타입 우선(Step 0 Q2 확정).
> 검증 별도(생성≠검증). 값(가격) 계산 안 함 — 추천 축·기준까지만.

---

## 0. 핵심 요지 (한눈)

- **채택 공식 분류** = 소상공인시장진흥공단(소진공) **상권정보 업종분류**(KSIC 10차 기반·2023 개편 837→247). 대분류 10 / 중분류 75 / 소분류 247. 국가 정본은 통계청 KSIC(21 대분류)이나, **소상공인 실무 렌즈**로는 소진공 상권분류가 정본(생활밀접 업종·점포 단위).
- **파일럿 업종 8종** — 근거 강도 순: 카페/베이커리 · 음식점(외식) · 미용/뷰티 · 학원/교육 · 병원/의원(의료) · 부동산 중개 · 소매 일반 · (candidate) 꽃집/플라워.
- **추천 기준 = 원자 기능 분해(AliCoCo 패턴)** — 업종을 8개 브랜드-중립 원자 마케팅 기능으로 분해, 각 기능이 인쇄 아키타입을 가리킴. "왜 그 인쇄물인가"의 다리.
- **§33 매핑** — 업종을 `intent`(E-special·앵커 none) 축의 확장으로. 신규 `INTENT_BIZ_*` 후보 8개 + 원자 기능 8종(badge=candidate·근거 N≥3 시 verified 승격). 새 개체 유형 신설 안 함.
- **GAP 5건** — §0 하단·§4 정리.

---

## 1. 업종 분류표 (공식 기관 근거)

### 1-A. 3개 공식 체계 (권위 순위·출처)

| 체계 | 주관 | 구조 | 성격 | 프린틀리 채택 |
|---|---|---|---|---|
| **한국표준산업분류(KSIC)** | 통계청(국가데이터처) | 대분류 21(A~U 영문) / 중분류 77 / 소분류 234 / 세분류 501 / 세세분류 1,205 | 통계법 §22·UN ISIC 기반 **국가 정본** | 상위 정합 근거(백본) |
| **상권정보 업종분류** | 소상공인시장진흥공단 | **대분류 10 / 중분류 75 / 소분류 247** (2023 개편 837→247·KSIC 10차 기반) | **소상공인 점포 단위 생활밀접** 실무 분류 | **★채택(실무 정본)** |
| **100대 생활밀접업종** | 서울시(상권분석서비스) | 대분류 3(외식업·서비스업·소매업) / 100 세부 | 상권분석·매출·유동인구 렌즈 | 파일럿 그룹핑 참조 |

- KSIC 출처: [통계청 통계분류포털 kssc.kostat.go.kr](https://kssc.kostat.go.kr/) · [KSIC 구조(대21/중77/소234/세501/세세1205)](http://kssc.kostat.go.kr/ksscNew_web/kssc/common/ClassificationContent.do?gubun=1&strCategoryNameCode=001) · 법령: [한국표준산업분류 행정규칙](https://www.law.go.kr/%ED%96%89%EC%A0%95%EA%B7%9C%EC%B9%99/%ED%95%9C%EA%B5%AD%ED%91%9C%EC%A4%80%EC%82%B0%EC%97%85%EB%B6%84%EB%A5%98)
- 상권정보 분류 출처: [소상공인365 bigdata.sbiz.or.kr](https://bigdata.sbiz.or.kr/) · [상가(상권)정보 업종코드 20230228 (837→247 개편·대2/중4/소6자리)](https://www.data.go.kr/data/15067631/fileData.do) · [상가(상권)정보 데이터셋](https://www.data.go.kr/data/15083033/fileData.do)
- 100대 생활밀접업종 출처: [서울시 상권분석서비스 golmok.seoul.go.kr(외식업·서비스업·소매업 3분류)](https://golmok.seoul.go.kr/introduce2.do)

### 1-B. 소진공 상권정보 대분류 10 (실무 렌즈·채택)

> 출처: 소진공 상권정보 발달상권 정의에 열거된 업종대분류 + 100대 생활밀접업종 3분류 정합.
> 개별 대분류 코드/명칭 원본 CSV는 미열람(GAP-IND-1) — 아래는 발달상권 정의·개편 공지에서 확인된 대분류 어휘.

| # | 대분류(상권정보) | 대표 소상공인 업종(중·소분류 예) | 100대 매핑 |
|---|---|---|---|
| 1 | **음식(외식)** | 한식·분식·카페/베이커리·치킨/호프·배달음식 | 외식업 |
| 2 | **소매** | 편의점·의류·화장품·꽃집·정육/청과·문구 | 소매업 |
| 3 | **생활서비스** | 미용실/네일·세탁·수선·이사·인쇄/광고 | 서비스업 |
| 4 | **학문/교육** | 입시/보습학원·외국어·예체능·태권도장·음악/미술학원 | 서비스업 |
| 5 | **의료/복지** | 의원·치과·한의원·약국·동물병원·요양 | 서비스업 |
| 6 | **부동산** | 부동산중개·임대 | 서비스업 |
| 7 | **숙박** | 모텔·게스트하우스·펜션 | 서비스업 |
| 8 | **관광/여가/오락** | PC방·노래방·스크린골프·카페형여가 | 서비스업 |
| 9 | **스포츠** | 헬스/피트니스·요가·필라테스·태권도(체육) | 서비스업 |
| 10 | **(도매/금융/문화예술종교 등)** | 소상공인 비중 낮음·발달상권 정의에 열거 | — |

- 근거: [소진공 상권정보 발달상권 정의(도소매·음식·숙박·생활서비스·부동산·학문교육·의료복지·문화예술종교·관광여가오락 등 업종대분류)](https://golmok.seoul.go.kr/introduce3.do) · 100대 3분류(외식/서비스/소매) [golmok introduce2](https://golmok.seoul.go.kr/introduce2.do).
- 주의: 프린틀리 파일럿은 이 중 **인쇄 홍보물 수요가 크고 근거가 확인된 소상공인 대면업종**만 선별(전 대분류 망라 아님·Step 0 Q2 마케팅 아키타입 우선).

---

## 2. 업종별 인쇄물 추천 매트릭스 (업종 × 인쇄물 × 원자 기능 근거)

### 2-A. 원자 마케팅 기능 8종 (AliCoCo 패턴·브랜드-중립)

추천의 다리 = 업종을 "왜 그 인쇄물이 필요한가"의 **원자 기능**으로 분해(§35 구조 리서치 보완-1 키스톤 승계). 각 기능이 인쇄 아키타입을 가리킨다.

| 코드 | 원자 기능 | 정의(고객 니즈) | 가리키는 인쇄 아키타입 |
|---|---|---|---|
| **AF-IDENTITY** | 신원 제시·대면접객 | 매장/담당자 신원·연락처를 대면 전달 | 명함(쿠폰명함 포함) |
| **AF-ACQUIRE** | 신규고객 유입·가두홍보 | 지나가는/인근 잠재고객 시선 포착·방문 유도 | 전단지·A프레임/입간판·현수막·배너 |
| **AF-RETAIN** | 재방문 유도·단골화 | 재구매/재방문 보상·적립 | 쿠폰(도장)·스탬프 적립카드·상품권 |
| **AF-DISPLAY** | 메뉴/상품 노출 | 취급 품목·가격·정보 매장 내 제시 | 메뉴판·포스터·리플렛/브로슈어 |
| **AF-BRAND** | 브랜딩·패키징 | 브랜드 인지도·감도·포장 완성도 | 스티커·데칼·포장(라벨/쇼핑백) |
| **AF-EVENT** | 오픈/이벤트 고지 | 개업·시즌·프로모션 단발 고지 | 현수막·포스터·전단·A프레임 |
| **AF-SIGN** | 공간 안내·사인 | 내부 동선·진료/업무 안내 | 안내사인·입간판·데칼 |
| **AF-FORM** | 업무 서식 | 봉투·처방/영수 서식 등 운영 문서 | 봉투·처방봉투·서식류 |

- 근거: [AliCoCo (arXiv 2003.13230)](https://arxiv.org/abs/2003.13230) — 쇼핑 니즈를 "원자 개념"으로 분해("야외 바비큐"→그릴·숯·재료). §35 `structure-recommendations.md` 보완-1(intent 원자 분해·키스톤). 과분해 금지(수정-3): 대분류당 소수·수백 개로 안 쪼갬.

### 2-B. 파일럿 8업종 매트릭스

> ●=강 근거(전용 인쇄상품/체크리스트 실 출처) · ○=일반 근거(범용 홍보물 업체 목록) · △=추정/candidate(직접 출처 약함=GAP).

| 업종 | AF-IDENTITY 명함 | AF-ACQUIRE 전단/배너/현수막 | AF-RETAIN 쿠폰/적립/상품권 | AF-DISPLAY 메뉴판/포스터/리플렛 | AF-BRAND 스티커/패키징 | AF-EVENT 오픈고지 | AF-SIGN 사인 | AF-FORM 봉투/서식 |
|---|---|---|---|---|---|---|---|---|
| **카페/베이커리** | ● 명함(위치·SNS) | ● A프레임·포스터 | ● 도장쿠폰 | ● 메뉴판·카드(원두스토리) | ● 포장스티커·데칼 | ● 오픈행사 | ○ | ○ |
| **음식점(외식)** | ● 명함 | ● 전단(자석전단)·현수막 | ○ 쿠폰 | ● 메뉴판·배달스티커 | ● 배달스티커 | ○ | ○ | ○ |
| **미용/뷰티** | ● 쿠폰명함 | ○ 현수막·배너 | ● 스탬프 적립카드·상품권 | ○ 시술안내 | ○ 로고굿즈 | ● 개업 기념품 | ○ | ○ |
| **학원/교육** | ○ 명함 | ● 원생모집 전단·배너·현수막 | ○ | ● 설명회 리플렛(2단/3단)·특강 포스터 | ● 홍보 스티커·이름표 | ● 등록시즌 | ○ | ○ |
| **병원/의원(의료)** | ● 진료시간명함 | ○ 배너·전단 | ○ | ● 리플렛/브로슈어·포스터 | ○ | ● 개원 패키지 | ● 안내사인 | ● 처방/약봉투·서식류 |
| **부동산 중개** | ● 명함 | ● 매물전단·현수막·배너 | △ | ○ 매물안내 | △ | ○ | ○ | ○ |
| **소매 일반** | ○ 명함 | ○ 전단 | ○ 쿠폰/상품권 | ○ 가격표·포스터 | ○ 스티커·쇼핑백 | ○ | ○ | ○ 봉투 |
| **꽃집/플라워 △** | ○ 명함 | ○ 전단·현수막 | △ | ○ | △ 라벨/카드 | ○ | ○ | ○ |

**업종별 원자 기능 요지(대표):**
- **카페/베이커리** = {AF-IDENTITY + AF-ACQUIRE + AF-RETAIN + AF-DISPLAY + AF-BRAND + AF-EVENT}. 가장 풍부(오픈 체크리스트 8종 실 출처).
- **음식점** = {AF-DISPLAY(메뉴판) + AF-ACQUIRE(전단·자석전단) + AF-BRAND(배달스티커)} 중심.
- **미용/뷰티** = {AF-RETAIN(스탬프 적립·상품권) + AF-IDENTITY(쿠폰명함)} 중심 — 단골관리 축이 지배적.
- **학원/교육** = {AF-ACQUIRE(원생모집 전단·현수막) + AF-DISPLAY(설명회 리플렛·특강 포스터)} 중심 — 모집 시즌성.
- **병원/의원** = {AF-FORM(처방봉투·서식) + AF-SIGN(안내사인) + AF-DISPLAY(진료안내 리플렛) + AF-IDENTITY(진료시간명함)} — 운영 서식·신뢰 사인 비중.
- **부동산** = {AF-ACQUIRE(매물전단·현수막) + AF-IDENTITY(명함)} 중심.

**출처(업종별):**
- 카페: [오프린트미 카페 오픈 체크리스트 필수 홍보물(A프레임·포스터·명함·도장쿠폰·카드·포장스티커·데칼·메뉴판)](https://www.ohprint.me/blog/cafe-start-checklist-marketing-materials) · [비즈하우스 카페홍보](https://www.bizhows.com/cms/blog/%EB%8B%A8%EA%B3%A8%EC%9D%B4-%EB%AA%A8%EC%9D%B4%EB%8A%94-%EC%B9%B4%ED%8E%98%ED%99%8D%EB%B3%B4-%EC%9D%B4%EB%A0%87%EA%B2%8C-%ED%95%B4%EB%B3%B4%EC%84%B8%EC%9A%94/)
- 음식점: [비즈하우스 전단지 셀프홍보(배달앱 대비 전단 효과 3위·자석전단)](https://www.bizhows.com/cms/blog/%EC%88%98%EC%88%98%EB%A3%8C%EC%97%90-%EB%96%A8%EC%A7%80-%EB%A7%90%EA%B3%A0-%EC%A0%84%EB%8B%A8%EC%A7%80%EB%A1%9C-%EC%85%80%ED%94%84-%ED%99%8D%EB%B3%B4-%ED%95%98%EC%9E%90/) · [식당/배달 자석 메뉴전단](https://eyefeeling.co.kr/product/%EC%8B%9D%EB%8B%B9-%EB%B6%84%EC%8B%9D-%EC%B9%B4%ED%8E%98-%EB%B0%B0%EB%8B%AC%EC%9D%8C%EC%8B%9D-%EB%A9%94%EB%89%B4-%EC%9E%90%EC%84%9D-%EC%A0%84%EB%8B%A8%EC%A7%80-%EB%94%94%EC%9E%90%EC%9D%B8-%EC%9D%B8%EC%87%84-%EC%A0%9C%EC%9E%91-%EB%A7%8C%EB%93%A4%EA%B8%B0/112/)
- 미용/뷰티: [동신인쇄 헤어/미용실/네일 도장 쿠폰명함](https://dongsinp.co.kr/product/%ED%97%A4%EC%96%B4-%EB%AF%B8%EC%9A%A9%EC%8B%A4-%EB%84%A4%EC%9D%BC-%EB%B7%B0%ED%8B%B0-%EB%8F%84%EC%9E%A5-%EC%BF%A0%ED%8F%B0-%EB%AA%85%ED%95%A8/88/) · [립통 미용실 스탬프 적립카드](https://liptong.com/product/m-3045-%EB%AF%B8%EC%9A%A9%EC%8B%A4-%EC%8A%A4%ED%83%AC%ED%94%84-%EC%A0%81%EB%A6%BD%EC%B9%B4%EB%93%9C-%EB%AA%85%ED%95%A8-%ED%97%A4%EC%96%B4%EC%83%B5-%EB%8B%A8%EA%B3%A8-%EC%BF%A0%ED%8F%B0-%EB%94%94%EC%9E%90%EC%9D%B8-%EB%8F%84%EC%9E%A5%EC%BF%A0%ED%8F%B0/9631/) · [기프트헤븐 미용실 사은품/개업 굿즈](https://giftheaven.co.kr/gift/%EB%AF%B8%EC%9A%A9%EC%8B%A4-%EC%82%AC%EC%9D%80%ED%92%88/)
- 학원: [비즈하우스 학원 홍보(개학 대비 현수막/배너/입간판)](https://www.bizhows.com/cms/blog/%EB%93%B1%EA%B5%90%EA%B0%9C%ED%95%99-%EB%8C%80%EB%B9%84-%EB%8A%A6%EC%96%B4%EC%A7%84%EB%A7%8C%ED%81%BC-%EB%B9%A0%EB%A5%B8-%ED%95%99%EC%9B%90-%ED%99%8D%EB%B3%B4%ED%95%98%EC%84%B8%EC%9A%94/) · [미술북 학원홍보인쇄물(전단·리플렛·팜플렛·특강포스터·이름표스티커)](https://misulbook.com/category/%ED%95%99%EC%9B%90%ED%99%8D%EB%B3%B4%EC%9D%B8%EC%87%84%EB%AC%BC/158/)
- 병원/의원: [병원마켓 메디브랜드 의료진명함](https://www.medibrand.co.kr/goods/goods_list.php?cateCd=033006) · [업종별명함 병원/의료/건강(진료시간명함·리플렛·브로슈어·서식류·안내사인·개원패키지)](https://xn--7m2b57b2zpsobd70b.com/category/%EB%B3%91%EC%9B%90%EC%9D%98%EB%A3%8C%EA%B1%B4%EA%B0%95/285/)
- 부동산·소매·꽃집: [코리아기획(명함·전단·현수막·판촉·간판)](https://www.koreaad7.com/board/list.html?tb=board_8) · [인쇄코리아(명함·스티커·봉투·전단·서식)](https://printingkorea.net/) · [비즈팩토리 업종별 홍보물(카페·초대장·상품권 등)](https://www.bizfactory.co.kr/)

---

## 3. §33 intent 축 매핑 (업종=intent 확장·재사용)

### 3-A. 매핑 원칙 (search-before-mint)

- **재사용 대상** = §33 `intent`(E-special·`INTENT_` 접두·anchor=none+용어집/경쟁사 근거·R19 `references`로 상품군 연결). 기존 노드 3: `INTENT_cafe_opening`(이벤트)·`INTENT_wedding`·`INTENT_premium`.
- **결정적 구분** — 기존 intent = "용도·의도"(이벤트/오케이전, 예 카페 **오픈**). 프린틀리 업종 = "지속 사업체"(예 **카페 운영**). Step 0 Q1 확정: **새 축 신설 안 함 — intent 축을 업종으로 확장**.
- **구현 권고**(§35 구조 D1·§33 D-22 "속성 우선" 승계): 새 개체 유형 신설 대신 intent 노드에 **`intent_kind` 속성**(`occasion` | `industry`) + **`atomic_functions` 속성/references**로 접는다. 노드 폭증 방지.
- **관계**: 업종 intent → (R19 `references`) → 원자 기능 → 인쇄 아키타입/카테고리. Phase 3 방식대로 **카테고리로 시드 연결**, 상품 노드 references는 Phase 4 보강(기존 `intents.md` 패턴 동일).

### 3-B. 신규 INTENT_BIZ_* 후보 8종 (badge=candidate)

> 접두 `INTENT_BIZ_*` = 업종(industry) 서브네임스페이스(기존 이벤트형 `INTENT_cafe_opening`과 충돌 회피·D-5 접두 체계 내). 전부 anchor=none(+업종 협회/인쇄업계 근거). 승격 규칙: 원자 기능당 독립 근거 **N≥3 확보 시 verified**, 미만 candidate(§35 tykimos N+ 승계·Step1 승격 규칙).

| INTENT_BIZ_* 후보 | label | intent_kind | 원자 기능(atomic_functions) | 현 근거수 | badge |
|---|---|---|---|---|---|
| `INTENT_BIZ_cafe` | 카페/베이커리 운영 | industry | IDENTITY·ACQUIRE·RETAIN·DISPLAY·BRAND·EVENT | 2 | candidate |
| `INTENT_BIZ_restaurant` | 음식점(외식) 운영 | industry | DISPLAY·ACQUIRE·BRAND·IDENTITY | 2 | candidate |
| `INTENT_BIZ_beauty` | 미용/뷰티 운영 | industry | RETAIN·IDENTITY·EVENT | 3 | **verified 후보** |
| `INTENT_BIZ_academy` | 학원/교육 운영 | industry | ACQUIRE·DISPLAY·BRAND | 2 | candidate |
| `INTENT_BIZ_clinic` | 병원/의원 운영 | industry | FORM·SIGN·DISPLAY·IDENTITY | 2 | candidate |
| `INTENT_BIZ_realestate` | 부동산 중개 운영 | industry | ACQUIRE·IDENTITY | 1 | candidate |
| `INTENT_BIZ_retail` | 소매 점포 운영 | industry | IDENTITY·ACQUIRE·RETAIN·DISPLAY·BRAND | 1 | candidate |
| `INTENT_BIZ_flower` | 꽃집/플라워 운영 | industry | IDENTITY·BRAND·ACQUIRE | 0(△) | candidate |

> 현 근거수 = §2 매트릭스에서 각 업종에 붙은 독립 실 출처 개수(범용 목록 제외). 검증 층에서 재실측 필요(생성≠검증). `INTENT_BIZ_beauty`만 N=3(동신인쇄·립통·기프트헤븐) → verified 승격 후보.

### 3-C. 원자 기능 노드 8종 (재사용 다리·badge=candidate)

원자 기능은 업종-무관·브랜드-무관 재사용 노드(여러 업종이 공유). §2-A 표 그대로. intent(업종) → references → 원자 기능 → references → 상품 아키타입/카테고리.

- 승격 규칙 동일: 서로 다른 업종에서 근거 N≥3 확보 시 verified(예 AF-IDENTITY·AF-ACQUIRE·AF-RETAIN·AF-DISPLAY는 이미 4+ 업종 근거 → verified 후보).
- 기존 `INTENT_cafe_opening`(이벤트)은 `INTENT_BIZ_cafe`(업종)의 **AF-EVENT 원자 기능 하위**로 재배치 가능(이벤트=업종의 한 시점 기능). 재litigate 아님·확장.

### 3-D. 검증 라우팅(생성≠검증)

- 이 문서 = 생성(추천 축·기준). 채택 전 **okb-adversarial-verifier / mbo-verify-gate**로 ① 출처 실재성 ② 원자 기능↔인쇄 아키타입 매핑 타당 ③ INTENT_BIZ_* 후보 근거수 재실측 ④ §33 스키마 lint(L-4·I-3 화이트리스트에 intent 실재) 검증.
- 가격은 계산 안 함 — 상품 연결(references) 후 `evaluate_price`가 별도 담당(원칙 3 결정론 엔진).

---

## 4. GAP (불명확·미확보·후속)

| # | GAP | 내용 | 해소 경로 |
|---|---|---|---|
| **GAP-IND-1** | 상권정보 대분류 10 원본 코드/명칭 미열람 | data.go.kr 업종코드 CSV(15067631) 미다운로드 — §1-B 대분류 어휘는 발달상권 정의·100대 3분류에서 유도. 정확한 10 대분류 코드·명칭은 CSV 확인 필요 | CSV 다운로드 or 소상공인365 개편 공지 열람 |
| **GAP-IND-2** | 꽃집·소매 일반·부동산 원자 기능 근거 약함(△) | 전용 인쇄상품/체크리스트 실 출처 부족(범용 업체 목록만) — candidate 유지 | 업종 협회·판촉 자료 추가 리서치 |
| **GAP-IND-3** | 업종별 인쇄물 수요 **통계 수치** 부재 | "전단 광고효과 3위"(배달, 2018 조사·bizhows 인용) 외 정량 근거 없음 — 정성 근거 중심 | 인쇄업계 시장조사·소진공 실태조사 |
| **GAP-IND-4** | INTENT_BIZ_* 후보 상품(product) references 미연결 | Phase 3 방식대로 카테고리 시드만 — 실 상품 노드 연결은 Phase 4(기존 intents.md와 동일 상태) | §33 KB Phase 4 |
| **GAP-IND-5** | 스포츠(헬스/필라테스)·숙박·여가오락 업종 미조사 | 파일럿 8종에 미포함(과분해 금지) — 소상공인 대면업종 대표만 | 근거 확보 시 INTENT_BIZ_* 확장 |

---

## 5. 다음 확인받을 것

**만든 것:** 공식 3체계 분류표(KSIC·소진공 상권정보·100대) + 소진공 상권 대분류 10 실무 렌즈 채택 + 파일럿 8업종 × 원자 기능 8종 × 인쇄 아키타입 매트릭스(실 출처 앵커) + §33 `INTENT_BIZ_*` 후보 8 + 원자 기능 노드 8(badge=candidate·N≥3 승격 규칙) + GAP 5건.

**다음 확인받을 것(지니):**
1. 파일럿 8업종 선정 적정 여부(스포츠/숙박 추가할지 vs 8종 유지).
2. INTENT_BIZ_* 서브네임스페이스 채택 vs intent 노드 `intent_kind` 속성으로 접기(§3-A 권고=속성 우선).
3. GAP-IND-1(대분류 CSV 정밀 확인)·GAP-IND-3(수요 통계) 보강 우선순위.

## 근거 자산 (재사용·읽기)
- §33 `_workspace/huni-ontology-kb/03_kb/intent/intents.md`(기존 INTENT_* 3종·패턴)·`02_ontology/ontology-schema.md`(intent 축 E-special·R19 references·lint 화이트리스트)
- §35 `_workspace/huni-multibrand-ontology/00_research/structure/structure-recommendations.md`(보완-1 intent 원자 분해 키스톤·AliCoCo·수정-3 과분해 방지·N+ 승격)
- 프린틀리 `_workspace/printly/00_step0-concept-normalization.md`(Q1 업종=intent 확장·Q2 마케팅 아키타입 게이트 확정)·`01_step1-entities.md`(① 업종 그릇·승격 규칙)
- 공식/인쇄 출처: §1·§2 인라인 URL(통계청 KSIC·소진공 상권정보·서울시 상권분석·오프린트미·비즈하우스·미술북·병원마켓 등)
