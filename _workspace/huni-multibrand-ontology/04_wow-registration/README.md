# 04 · 와우프레스 전 상품 온톨로지 등록 (devshop 전량)

> 작성: 2026-07-05 · 트리거 = 지니: "Printly가 어댑터로 여러 인쇄소 연결·주문·**권위는 후니 최상, 나머지 인쇄소로 전환**. devshop.wowpress.co.kr **전 상품군을 온톨로지 등록**해 구성요소·제약으로 상품 구성 요소를 **맥락에서 파악**. 실제 gstack browse로 접근."
> 방법 = catalog(devshop API 덤프 324상품) 결정론 배치 전사(`printly/data/_scripts/wow_ontology_register.py`) + **gstack browse 라이브 대조**.
> **[HARD]** 앵커=`catalog:products/<id>.json#raw.prod_info` · 값 미수집 · 생성≠검증 · LLM 손전사 금지(스크립트 파싱).

---

## 0. 아키텍처 맥락 (지니 확정)

- **Printly = 어댑터 브로커**: 여러 인쇄소를 연결하고 주문까지. 파일 변환 = 논리파일 1개 + 벤더 어댑터(08·특허 C3).
- **권위 서열**: **후니프린팅 = 권위 최상**(정본 참조 모델·§33). 와우/레드 = 후니에 **매핑·전환(fallback)** 대상.
  - 즉 와우 등록 = 후니(§33)·상위개념(§35)에 `same_family_as`/`instance_of`로 걸어 **후니를 기준으로 정렬**.
  - 추천: 후니 우선 → 후니 미보유/미가용 시 **다른 인쇄소로 전환**(연결-앵커 08·비대칭 케이스).
- **이 등록의 역할**: 와우 전 상품을 후니와 **같은 개념 격자**에 올려, "무엇으로 구성되나·무엇이 공유·제약되나"를 맥락에서 답하게.

---

## 1. 규모 (결정론 전사)

| 구분 | 수 | 앵커 |
|---|---|---|
| 상품 | **324** | `catalog:products/*.json` (326 중 3 = selType=None GAP 제외) |
| dedup 재질(paper) | 504 | `wow-components.json#paper` |
| dedup 규격(size) | 919 | `#size` |
| dedup 도수(color) | 115 | `#color` |
| **dedup 인쇄방식(prsjob)** | **12** | `#prsjob` ★전 상품이 12방식으로 수렴 |
| dedup 후가공(awkjob) | 474 | `#awkjob` |
| dedup 부자재(prodadd) | 32 | `#prodadd` |

산출: `wow-products.json`(상품별 구성요소 id + 제약) · `wow-components.json`(dedup + `used_by` 공유) · `wow-registration-summary.md`.

---

## 2. 구성요소를 맥락에서 — 공유(used_by)

★온톨로지 등록의 핵심 = 구성요소를 dedup해 **여러 상품이 공유**하는 구조를 드러냄:

- **인쇄방식 12 백본**: `3120` 합판디지털(106상품)·`3110` 합판옵셋(47)·`3130` 합판UV(17)·`3221` 독판인디고(7)·`3210` 독판옵셋(5)·`3230` 독판UV(5)·`3140` 합판마스터(4). (`30` 분류 133 = 카테고리 플레이스홀더·실 인쇄방식 아님·데이터 주의).
- **공유 재질**: 아트지무코팅80g(32상품)·스노우지250g(31)·모조지백색80g(26)·랑데뷰210g(25)…
- **공유 후가공**: 전체라운딩(38)·타공2개6mm(34)·미싱 가로/세로(각 33)…
- **공유 부자재**: 종이/반투명/프리미엄 명함케이스(27~28상품 — 명함군 공통)·큐방·엽서봉투…

→ "스노우지250g는 어떤 상품들에 쓰이나" "합판옵셋으로 찍는 상품군은" 같은 질의를 이 그래프가 답한다.

---

## 3. 제약을 맥락에서 — req_/rst_ 그래프

축 간 필수(`req_`)·제약(`rst_`)이 상품 구성 규칙:

| 제약 | 건수 | 뜻 |
|---|---|---|
| paper.rst_prsjob | 758 | 이 재질은 특정 인쇄방식 제약 |
| paper.rst_awkjob | 713 | 이 재질은 특정 후가공 제약 |
| **color.req_prsjob** | **484** | 이 도수는 특정 인쇄방식 필수(대표 제약) |
| size.rst_awkjob | 146 | 규격이 후가공 제약 |
| size.req_width/height | 105 | 비규격 시 W×H 필수 |
| color.rst_prsjob | 48 · size.rst_ordqty 34 · color.rst_opt 24 · size.req_awkjob 14 | 기타 |

예(도수→인쇄방식): "PP홀더 단면칼라4도 → UV인쇄 필수" · "소량독판전단 양면8도 → 옵셋인쇄 필수".
→ CN-1~6(§31 제약) 및 feasibility(06) 판정의 1차 원천.

---

## 4. 라이브 대조 (gstack browse·요청대로)

- devshop.wowpress.co.kr `/maint` 홈에서 전 상품 `/prodt/<prodno>` 링크 전수 추출.
- **라이브 292 vs catalog 326**: /maint 퀵리스트는 활성/노출분(292)·catalog은 전량 API 덤프(326).
- ★**라이브 신규 4상품**(catalog 부재·2025-10-14 이후): `40086` 기성 탁상용캘린더(2026)·`40617` 특수초강접스티커(도무송)·`40618` 특수초강접스티커(사각)·`40625` 접착 포스터 → **catalog refresh/API fetch로 등록 필요**(GAP).
- **catalog-only 다수**: /maint 미노출(비활성 or 카테고리 접힘) — 삭제 단정 아님.

---

## 5. §35 스키마 정합 (search-before-mint)

| 등록 요소 | §35 개체/관계 |
|---|---|
| 상품(324) | E1 `product`(brand=wowpress) |
| 규격/재질/도수/인쇄방식/후가공/부자재 | E3 size·E4 material·E5 print_option·E18 print_method·E6 process·E1(addon) |
| used_by(공유) | R? 상품→구성요소 참조(has_*) |
| req_/rst_ 제약 | E12 `constraint`(CN-1~6) |
| 상위개념 정렬 | X-1 `instance_of` → U-3~U-8·U-18(브랜드-중립) |
| 후니 교차 | X-3 `same_family_as`(A-1~16) · 후니=권위 최상 |

## 6. GAP · 다음

- **GAP-REG-1**: 라이브 신규 4상품 미등록(catalog 부재) → API/catalog refresh.
- **GAP-REG-2**: selType=None 3상품(40078·40089·40297_TEST) 제외.
- **GAP-REG-3**: catalog 2025-10-14 노후 → 의심분 라이브 재확인(재질 드리프트 실측: 엽서 40346 띤또레또순백 라이브 추가).
- **다음**: ① 구성요소별 `instance_of` 상위개념 배선(feasibility 척추) ② 후니 §33과 same_family_as 전 상품 정렬(현재 대표만) ③ 라이브 신규 4 fetch ④ 이 등록을 build_graph(§35)에 편입(아키텍처 결정 후).

## 파일
- `wow-products.json` · `wow-components.json` · `wow-registration-summary.md`
- 스크립트: `_workspace/printly/data/_scripts/wow_ontology_register.py`(재현)
- 라이브 목록: `/tmp/wow_live_prods.txt`(292·재추출 가능)
