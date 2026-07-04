# 다음 세션 플레이북 — 와우프레스를 후니처럼 채우기

> 준비: 2026-07-04 · 지니 지시 = "다음 세션에서 와우프레스를 후니처럼 더 채우도록 정리."
> 목표: 와우 상품·구성요소·옵션·가격공식·제약을 **후니와 같은 recipe 그릇**에 채우고, **브랜드-중립 상위 개념**으로 후니와 연결.

## 0. 한 줄 목표

후니가 이미 있는 것(613 소재·상품별 연결·셋트·가격) 을 **와우도 같은 그릇에** 채워, "카페 오픈 홍보물"을 물으면 **후니·와우 견적을 나란히 비교**할 수 있게.

## 1. 와우 원천은 어디 있나 (재조사 금지·재사용)

| 자산 | 위치 | 무엇 |
|---|---|---|
| 상품 catalog | `docs/wowpress/catalog/` (326 products JSON·2025-10-14) | 상품·구성요소·옵션 원천 |
| API·가격 스펙 | `docs/wowpress/{wowpress-api-document.txt · products_spec · price_order_spec PDF}` | jobcost 가격 계약 |
| 구조 분석 | `§35 01_analysis/{wowpress-structure · -catalog-map · -price-mechanism}.md` | 6+2축·가격 메커니즘 해부(완료) |
| 후니 정렬 | `§35 02_crossbrand/{family-alignment(16쌍) · difference-matrix · crossbrand-edges}.md` | 같은 상품군 대응·차이 |
| 상위 온톨로지 | `§35 03_upper_ontology/upper-ontology-schema.md §4` | instance_of 매핑표(U-1~U-22) |

## 2. 와우가 후니와 다른 점 (채울 때 유의)

| 축 | 후니(§33) | 와우(§35) |
|---|---|---|
| 저장 앵커 | 라이브 `t_prd_*` (DB) | **catalog JSON**(`catalog:products/<id>.json#…`)·DB 없음 |
| 구성요소 축 | 4축(size·material·print_option·process) | **6+2축**(+prsjob 인쇄방식·prodadd 부자재·selType·pjoin) |
| 인쇄방식 | print_option에 접힘 | **prsjob=1급 축**(합판디지털106·합판옵셋47·UV17·INDIGO·옵셋·윤전 16종) |
| 가격 | `evaluate_price`(venv 직접 호출 가능·실증) | **jobcost API**(`POST /std/prod/jobcost`→`ordcost_bill`)·정적표 0·전량 configuration·내역 은닉 |
| 가격 검증 | 로컬 엔진 호출 | ★**라이브 API 연동 필요**(후니처럼 로컬 호출 불가) |

## 3. 채우는 절차 (후니와 동형·와우 특화)

1. **파일럿 상품 선정** — `family-alignment.md` 16쌍에서 후니와 대응되는 와우 상품 하나(예: 명함).
2. **구성요소 추출** — catalog JSON에서 스크립트로 전사(★LLM 손전사 금지·수치는 파싱). 6+2축 값 추출.
3. **recipe 그릇 채움** — `recipes/wow/<상품>.json`(후니와 같은 6부류 템플릿·와우 앵커 `catalog:…`).
4. **상위 개념 연결** — 각 와우 노드 →`instance_of`→ 상위 개념(§35 U-1~U-22). 인쇄방식은 U-4 PrintMethodIntent.
5. **후니와 교차 연결** — 같은 상품군 →`same_family_as`→ 후니 상품(16쌍). 가격 모델 차이=`price_model_differs`.
6. **가격** — jobcost API 호출(값=엔진·후니 evaluate_price와 동형 경계). API 연동은 이 단계에서 결정.
7. **검증** — 종단(와우 추천→레시피→jobcost 견적) + 후니와 나란히 비교(same_family_as 경유).

## 4. [HARD] 원칙 (채울 때)

- **§33/§35 골든 무손상**·재조사 금지(위 산출 재사용). 와우 catalog=2025-10-14 → 의심분만 라이브(gstack 읽기전용) 재확인.
- **와우 앵커 3유형**만(catalog:/wowpress-api:/wowpress-pdf:)·모든 노드 실 앵커 or GAP(지어내기 차단).
- **값=jobcost API 경계**(후니 D-18 동형)·LLM 값 추정 금지.
- **브랜드-중립 상위 개념 재사용**(새 축 mint 금지·search-before-mint).

## 5. 완료 판정 (와우가 "후니처럼" 됐다)

- 와우 파일럿 상품군이 recipe 그릇에 6부류 채워짐 + 상위 개념·후니 same_family_as 연결됨.
- "카페 오픈 홍보물"류 질의에서 **후니·와우 견적이 나란히** 뜸(브랜드-중립 추천 → 벤더별 엔진).
- 동형 전파: 파일럿 상품군 틀을 나머지 와우 상품군으로.

## 시작점 (다음 세션)
1. 이 문서 + `printshops/wow.json` + `§35 02_crossbrand/family-alignment.md` 읽기.
2. 16쌍 중 파일럿 1개(권장=명함류·후니 이미 실동) 선정.
3. catalog JSON 파싱 스크립트로 구성요소 추출 → `recipes/wow/` 채움.
