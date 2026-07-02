# okb-query-gate — 시나리오 기록 (유형 2 용도 추천 + 유형 3 조건 탐색)

> 담당: 종단 질의 게이트 O6 중 **유형 2(용도 추천형)** + **유형 3(조건 탐색형)**.
> 블라인드 조건 준수: 질의 해석 단계는 `03_kb/`(index.md 진입) + `04_graph/graph.db`만 읽음.
> 원천(권위 엑셀·위키·docs/kb·하네스 산출물)은 열지 않음 → 실험 유효.
> 가격 실측 단계만 라이브 예외(가격엔진 simulate POST, 읽기/계산 전용·주문/저장 없음).
> 작성 2026-07-03.

---

## 방법 요약

- **경로 기록 원칙:** 각 시나리오는 index.md 라우팅 시작점(§검색 라우팅)에서 출발해 실제 밟은
  노드 체인(graph.db 질의)을 기록. 경로 없이 사전지식으로 답하면 FAIL.
- **가격 대조:** KB가 도출한 **가격 경로**(상품→`priced_by`→공식→`has_component`→구성요소)를
  라이브 `simulate`로 실측. KB는 값을 단정하지 않으므로(RULE_price_value_boundary·D-18)
  대조 기준 = **경로/구성요소 일치 + PRICE≠0**. 값은 라이브가 권위.
- 실측 도구: `_workspace/_foundation/batch/lib_huni.py` HuniSim.simulate (proc=PROC_000004 base).

---

## 유형 2 — 용도 추천형

### S-I1 "카페 오픈 기념품으로 뭐가 좋아?" — PASS

**경로(밟은 노드 체인):**
`index.md §라우팅2(용도 추천)` → `intent/intents.md [INTENT_cafe_opening]`
→ `references` → `category-CAT_000307(엽서)` + `category-CAT_000062(쿠폰/상품권)`
→ (역방향 `in_category`) → `product-016-premium-postcard`, `product-041-coupon`
→ `priced_by` → `formula-PRF_DGP_A` → `has_component` → {디지털인쇄비, 용지비, (옵션)코팅/별색/후가공}.

graph.db 질의로 재현:
- `INTENT_cafe_opening --references--> CAT_000307, CAT_000062` (2 엣지 실재)
- `product-016 --in_category--> CAT_000307`, `product-041 --in_category--> CAT_000062`

**추천 결과:** 프리미엄엽서(PRD_000016, 오픈 안내), 스탠다드 쿠폰/상품권(PRD_000041).

**가격 완주(대표 2건·라이브 실측):**
| 조합 | KB 예측 경로 구성요소 | 라이브 final_price | 엔진 기여 구성요소 |
|---|---|---|---|
| 016 프리미엄엽서 100장 73x98 단면 백색모조지220g | PRF_DGP_A → COMP_PRINT_DIGITAL_S1 + COMP_PAPER | **9,424원** | 디지털인쇄비 9,000 + 용지비 423.84 |
| 041 쿠폰 108장 148x68 단면 백색모조지100g | PRF_DGP_A → COMP_PRINT_DIGITAL_S1 + COMP_PAPER | **10,177원** | 디지털인쇄비 9,900 + 용지비 276.57 |

KB가 선언한 필수 구성요소(디지털인쇄+용지) = 엔진이 실제로 합산한 구성요소와 **완전 일치**,
PRICE≠0. (미선택 옵션 코팅/별색/후가공은 KB에 optional로 선언·엔진도 미가산 → 정합.)
**판정: PASS** — 경로 완주 + 가격 경로 오차 0(구성요소 매칭).

> 참고 GAP(정직): 016 SIZ_000001 pansu=18로 계산됨. KB는 `size-SIZ_000001` note에
> "판걸이수 15 vs 18 충돌 — GAP"으로 이미 정직 선언. KB 정답(GAP 표기) vs 라이브 값(pansu=18 권위).

### S-I2 "청첩장·웨딩 관련 인쇄물 추천" — PASS

**경로:** `[INTENT_wedding]` → `references` → `CAT_000001(엽서/카드)` + `CAT_000307(엽서)`
→ 역방향 `in_category` → `product-016-premium-postcard`, `product-024-photocard`.
graph.db 재현: wedding→CAT_000001→{016, 024}, wedding→CAT_000307→016.

**추천 결과:** 프리미엄엽서(016·청첩 카드), 포토카드(024). 016은 S-I1에서 이미 가격 완주(9,424).
**판정: PASS** — intent→category→product 경로 정상, 환각 없음.

### S-I3 "고급스러운 명함/엽서 추천" — PASS

**경로:** `[INTENT_premium]` → `references` → `CAT_000313(명함)` + `CAT_000307(엽서)`
→ 역방향 → `product-032-coated-namecard`, `product-033-standard-namecard`, `product-016-premium-postcard`.
graph.db 재현: premium→CAT_000313→{032, 033}, premium→CAT_000307→016.

**추천 결과:** 코팅명함(032), 스탠다드명함(033), 프리미엄엽서(016).
**판정: PASS** — intent∩category 교집합 경로(nl-query S5) 정상.

### S-I4 (거절 인접) "돌잔치 답례 머그컵/텀블러 있어?" — PASS (정직 거절)

**경로:** `intent/intents.md` 에 해당 용도 노드 없음 + `node WHERE type='product'` 에
머그/텀블러/굿즈 상품 0건(파일럿=디지털인쇄 8상품). 라우팅할 상품군 없음.
**판정: PASS** — 파일럿 범위 밖 상품군을 **환각 추천하지 않고 "범위 밖(미집필 상품군)"으로 정직 처리**.
환각 추천=최악 결함인데 발생 안 함.

---

## 유형 3 — 조건 탐색형 (역방향 그래프 질의)

### S-C1 "양면 인쇄 되는 엽서 있어?" — PASS

**경로:** `index.md §라우팅3(조건 탐색)` → `axis/print-options.md [printopt-POPT_000002](양면)`
→ 역방향 `has_print_option` → 상품 집합 → `in_category CAT_000307(엽서)` 로 교차 필터 → `product-016`.
graph.db 재현: `POPT_000002 <--has_print_option-- {016,024,027,032,033,041,043,046}`,
그중 엽서(CAT_000307) = 016.
**추천 결과:** 프리미엄엽서(016) — 양면(POPT_000002) 지원 확인. 가격은 S-I1에서 완주.
**판정: PASS** — 조건이 그래프 역질의로 답해짐.

### S-C2 "만원 이하 소량으로 만들 수 있는 인쇄물 있어?" — PASS (정직 GAP + 라이브 확인)

**경로:** 가격 값 조건("만원 이하") = `rule/rules.md [RULE_price_value_boundary]`(D-18) →
**KB는 값을 단정하지 않음 → 정직 GAP 선언**. KB가 할 수 있는 것 = 구조로 후보 좁힘:
"소량" = 낮은 min_qty → `product-016`(min_qty 15, props) 등. 그다음 값은 라이브 evaluate_price.

**라이브 확인(블라인드 예외):**
| 조합 | final_price | 만원 이하? |
|---|---|---|
| 016 프리미엄엽서 15장(min) 73x98 단면 백색모조지 | **4,071원** | ✅ 예 |
| 041 쿠폰 108장 | 10,177원 | ✗ 근소 초과(경계) |

**판정: PASS** — KB가 값을 **환각하지 않고**(정직 GAP) 후보만 좁힌 뒤 라이브로 확정. "016 소량 15장 = 4,071원 < 10,000" 참. KB 경계 준수가 정답 동작.

### S-C3 "스노우지로 만드는 상품 있어?" — PASS

**경로:** `axis/materials.md [material-MAT_000091/092](스노우지 250/300g)` → 역방향 `uses_material`
→ `{016, 027, 033, 043}`(스노우지 250 사용) + 016/027/033(300g).
graph.db 재현: `MAT_000091 <--uses_material-- {027,033,043}`, `MAT_000092 <-- {016,027,033}`.
**추천 결과:** 2단접지카드(027), 스탠다드명함(033), 인쇄배경지(043), 프리미엄엽서(016).
**판정: PASS** — 자재 역탐색 정상.

### S-C4 (거절 인접) "형광/네온 별색 되는 엽서 있어?" — PASS (정직 미상)

**경로:** `axis/processes.md [process-PROC_000007](별색인쇄)` 노드는 존재하나
역방향 `has_process` 보유 상품 = **0건**(파일럿 8상품 중 별색인쇄 공정 연결 없음).
형광/네온 색상 노드도 미집필(index.md: "별색·타공 등 축 노드는 아직 연결 대기 — 소프트 경고").
016 formula에 COMP_PRINT_SPOT_WHITE_S1(별색 화이트)만 있고 형광/네온 색은 없음.
**판정: PASS** — 파일럿에 없는 조합을 **환각 추천하지 않고 "미집필/연결 대기(모른다)"로 정직 처리**.

---

## 담당분 판정 요약

| 시나리오 | 유형 | 판정 | 경로 | 가격 완주 |
|---|---|---|---|---|
| S-I1 카페 오픈 기념품 | 2 용도추천 | PASS | intent→cat→prod (016,041) | 016=9,424 / 041=10,177 |
| S-I2 청첩/웨딩 | 2 용도추천 | PASS | intent→cat→prod (016,024) | 016 완주(재사용) |
| S-I3 고급/프리미엄 | 2 용도추천 | PASS | intent∩cat→prod (032,033,016) | — |
| S-I4 머그컵 답례품(거절) | 2 거절 | PASS | 범위 밖·환각 없음 | — |
| S-C1 양면 엽서 | 3 조건탐색 | PASS | print_opt 역탐색∩cat | 016 완주 |
| S-C2 만원 이하 소량 | 3 조건탐색 | PASS | 정직 GAP(D-18)+라이브 | 016 15장=4,071<만원 |
| S-C3 스노우지 상품 | 3 조건탐색 | PASS | material 역탐색 | — |
| S-C4 형광/네온 별색(거절) | 3 거절 | PASS | 미집필·환각 없음 | — |

**담당 소계: 8 시나리오 전부 PASS (용도추천 4 + 조건탐색 4·거절형 2 포함).**

### 가격 경로 대조 결론
- KB 예측 경로(PRF_DGP_A → 디지털인쇄비 + 용지비)가 라이브 엔진 기여 구성요소와 **완전 일치**,
  전 실측 PRICE≠0 (9,424 / 10,177 / 4,071). 값 자체는 D-18로 KB가 단정 안 함 = 경계 준수 정합.
- 유일한 데이터 이슈(016 pansu 15 vs 18)는 **KB가 이미 GAP으로 정직 선언** → KB 결함 아님,
  "KB 정답(GAP) vs 라이브 값(18 권위)" 양면 표기로 분리.

### 관찰(다른 게이트 항목으로 전달)
- intent 3종 전부 `badge=candidate`(§경쟁사 코퍼스 유도·상품 references는 카테고리 경유). 환각은
  없으나 O3(오염 필터)에서 candidate badge 표기 준수는 확인 필요 — 추천 답변 시 "후보" 고지 권장.
- 용도 추천의 상품 도달은 전적으로 category `in_category` 역질의에 의존 → 카테고리 커버리지가
  곧 추천 커버리지. 미집필 상품군 확장 시 intent references도 함께 넓혀야 동형 전파됨.
