# 프린틀리 전반부 명세 — 업종 → 추천 → 사양 → 견적 (R1~R3 통합)

> 작성: 2026-07-04 · 지니 확정="전반부(추천→견적) 먼저". WebToProduct 20단계 중 ①주문접수~③결제 앞단(고객 대면).
> 근거: `research/industry-classification.md`(R1)·§33 KB(R2)·§27/§18 가격 배선(R3)·`research/webtoproduct-analysis.md`(후가공 포함 견적).
> [HARD] 이 문서는 전반부 흐름 명세까지. 값 계산=evaluate_price 권위(원칙 3). 근거 node_id 인용·지어내기 금지.

---

## 0. 전반부 흐름 (WebToProduct 전단 = 고객 대면)

```
[업종/맥락] → (추천) 홍보물 → (사양 선택) 규격·색·후가공·용지 → (견적) 인쇄+후가공 포함 → [결제로]
   R1              R2                    R2(사양 4축)                R3(evaluate_price)
```
- 온톨로지 순회로 후보 산출, 값은 엔진 호출(경계). 잡티켓(브릿지)에 확정 사양이 실려 후반부(생산)로 넘어감.

## 1. R1 — 업종 (완료·재사용)

- **분류**: 소진공 상권정보(대10/중75/소247) + KSIC 백본. 파일럿 **업종 8**(카페·음식점·미용·학원·병원·부동산·소매·꽃집).
- **추천 기준 = 원자 마케팅 기능 8**: IDENTITY(명함)·ACQUIRE(전단/배너/현수막)·RETAIN(쿠폰/스탬프/상품권)·DISPLAY(메뉴판/포스터/리플렛)·BRAND(스티커/패키징)·EVENT(오픈고지)·SIGN(안내사인)·FORM(봉투/서식).
- **온톨로지**: §33 `intent` 축에 `intent_kind=industry` + 원자 기능. `INTENT_BIZ_*` 8후보(candidate·N≥3 승격). → `01_step1-entities.md` ① 참조.

## 2. R2 — 홍보물·사양 (§33 순수 재사용·조사 불필요)

- **홍보물** = §33 `product`/`category`/`product_family`. 마케팅 아키타입 부분집합(명함·전단·배너·스티커·메뉴판·쿠폰·현수막·리플렛).
- **사양 4축** = §33 그대로: `size`(규격)·`print_option`(색·도수·인쇄방식)·`process`(후가공)·`material`(용지·소재).
- **추천→홍보물 연결**: 원자 기능(R1) → `references`(R19) → 홍보물 상품군. 브랜드-무관은 §35 `same_family_as`(후속·후니 우선).
- **매핑만 필요**(재조사 0). 실 node_id는 §33 03_kb에 실재.

## 3. R3 — 견적: 인쇄 + 후가공 포함 (★핵심 확인)

- **WebToProduct 요구**: "Quote on printing **as well as** finishing"(인쇄뿐 아니라 후가공까지 견적).
- **후니 현황 = 이미 정합**: evaluate_price의 가격 구성요소(`formula_components`)에 **공정·후가공(process) 기여가 포함**됨(§27/§18 배선 작업에서 확립·후가공 단가행 실재). 즉 후가공 포함 견적은 이미 라이브 작동.
- **경계(원칙 3)**: 온톨로지·에이전트는 "어떤 축(사양·후가공)으로 견적이 달라지나"까지. **값 계산=evaluate_price 단일 권위**(LLM 추정 금지·D-18).
- **점검 필요분(후속)**: 파일럿 홍보물 8종의 후가공(코팅·박·오시 등)이 실제로 견적에 반영되는지 실화면 확인(webadmin 가격시뮬레이터·시스템 로드맵 Stage 0과 연계).

## 4. 전반부 온톨로지 순회 경로 (예)

```
"미용실 오픈, 단골 관리용 뭐가 좋아?"
 업종:미용 [intent_kind=industry] → 원자기능 RETAIN 지배
   → references → 홍보물{쿠폰·스탬프적립카드·쿠폰명함}
   → 각 홍보물 → uses → 사양(규격·용지·후가공)
   → priced_by → formula → (evaluate_price 호출: 인쇄+후가공 포함) → 견적 후보
```
- 답: 미용실 단골관리 홍보물 후보 + 각 사양 + **엔진 견적**(값=서버). 근거 node_id 병기. 그래프에 없으면 GAP.

## 5. 다음 확인받을 것 (PART 4 규칙 3)

**만든 것**: 전반부 흐름 명세(R1 완료·R2 재사용·R3 후가공 포함 견적 정합 확인).
**다음 후보**:
- (a) 전반부 **관계 정의(Step 2)** — 업종→홍보물→사양→견적 엣지 정형화(추천 랭킹·되묻기 정책 포함).
- (b) **브릿지(잡티켓)** 설계 — 전반부 확정 사양을 후반부로 넘기는 데이터 계약.
- (c) R3 **실화면 점검** — 파일럿 8종 후가공 견적 반영 확인.

## GAP
- G-FRONT-1: 원자 기능→홍보물 references는 §33 intent 코퍼스 기준(와우/레드 미보강·후니 우선).
- G-FRONT-2: 추천 랭킹·되묻기 N 정책 미정(PART 3 지니 확정 대기).
- G-FRONT-3: R3 후가공 견적 반영은 파일럿 실화면 확인 후 확정(현재=구조 정합까지).

## Sources
- `research/industry-classification.md`·`research/webtoproduct-analysis.md`·`01_step1-entities.md`·`00_step0-concept-normalization.md`
- §33 `_workspace/huni-ontology-kb/`(product/intent/process/formula)·§27/§18 가격 배선(formula_components 후가공 포함)
