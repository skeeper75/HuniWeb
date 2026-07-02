# 자연어 질의 경로 증명 — Huni-Ontology-KB (v1.0)

> 작성: 2026-07-03 · okb-ontology-architect
> 상위: `ontology-schema.md`(개체·관계) · `graph-build-spec.md`(재귀 CTE) · `../00_research/methodology-playbook.md`(D-11 하이브리드 검색·D-17 CoVe·⑤Q4 범위).
> 목적: 대표 자연어 질의가 **스키마 위 어떤 탐색 경로로 답해지는지** 증명한다. 경로가 안 그려지는 시나리오 = 스키마 결함(설계 원칙 5). 범위 밖 질의의 거절 경로도 명시.
>
> **읽는 법:** "고객이 이렇게 물으면 지식베이스가 어떤 순서로 점·선을 따라가 답을 만드나"를 시나리오별로 보인다. 이게 그려져야 스키마가 실제로 쓸모 있다는 증거다. 답할 수 없는 질문(주문·배송 등)은 정직하게 거절하는 경로까지 설계했다.

---

## 0. 검색 라우팅 원리 (D-11 하이브리드 2단)
1. **1단 — 노드 확정:** 질의어 → `index.md`(진입점) 또는 용어집 alias → 시작 노드(intent·product·category)를 그래프에서 확정.
2. **2단 — 경로 탐색 + 정본 Read:** 시작 노드에서 관계 엣지를 재귀 CTE로 따라가 답 노드 집합 획득 → 각 노드의 `file_path`로 정본 markdown 구간 Read → badge·출처와 함께 합성.
- **가격 경계(D-18):** 가격 "값"은 온톨로지가 계산하지 않는다. KB는 "이 상품→이 공식→이 구성요소→이 차원"까지 잇고, **최종 값은 evaluate_price/시뮬레이터에 위임**한다("가격은 이 공식으로 계산되며, 최종 금액은 견적기가 계산합니다"라고 답).
- **badge 정직성:** ⚪(gap)·🟡(후보)·🔴(양면 결함)은 그대로 노출("확정 아님"·"교정 대기"로).

---

## 1. 대표 질의 시나리오 (5유형 × ≥12건)

각 시나리오: **질의 → 1단 노드 → 2단 경로(엣지) → 답 노드 → 답 형태 → 근거 노드**.

### 유형 1 — 구체 상품 질의 (상품명·사양이 명확)

**S1. "프리미엄엽서 73×98 단면 칼라, 100장 얼마?"**
- 1단: "프리미엄엽서" → `product-016-premium-postcard`.
- 2단: `--has_size--> size-016-73x98` (사이즈 실재 확인) → `--has_print_option--> printopt-016-single`(단면 POPT_000001) → `--priced_by--> formula-PRF_DGP_A` → `--has_component-->` {COMP_PRINT_DIGITAL_S1·COMP_PAPER·…}.
- 답: "프리미엄엽서 73×98 단면은 `PRF_DGP_A`(원자합산형: 출력+소재×수량/판걸이수+후가공)로 계산됩니다. 구성요소는 인쇄비·용지비·후가공비. **최종 금액은 견적기가 계산**합니다(수량 100·판걸이수 반영)." + ⚪ GAP 고지: "73×98 판걸이수는 마스터 15 vs 판걸이수시트 18로 확인 대기(견적 분모 영향)".
- 근거: product-016·formula-PRF_DGP_A·gap-digital-pansu-73x98. **스키마 충분** ✅ (단 판수 GAP 정직 노출).

**S2. "코팅명함이랑 스탠다드명함 뭐가 달라요?"**
- 1단: 두 상품 노드(`product-032-coated-namecard`·`product-033-standard-namecard`).
- 2단: 각각 `has_process`·`uses_material`·`priced_by` 엣지 집합을 diff. 032는 `--has_process--> process-coating` + `--priced_by--> formula-PRF_NAMECARD_COAT`.
- 답: "코팅명함은 코팅 공정이 추가되어 코팅 가격구성요소가 붙습니다(공식 PRF_NAMECARD_COAT). 스탠다드명함은 코팅 없음." + 근거 노드.
- **스키마 충분** ✅ (공정·공식 diff가 그래프 탐색으로 됨).

**S3. "명함 최소 몇 장부터 주문돼요?"**
- 1단: `product-033-standard-namecard`.
- 2단: `--has_qty_rule--> qty-033` → props.min_qty.
- 답: "스탠다드명함 최소 100장(증가 100단위)." 근거=qty 노드(src_id 명시).
- **스키마 충분** ✅.

### 유형 2 — 용도·의도 추천 (고객이 상품명을 모름, KB 전용 intent 레이어)

**S4. "카페 오픈 기념으로 나눠줄 거 만들고 싶어요."**
- 1단: 용어집 alias("카페 오픈"→`INTENT_cafe_opening`).
- 2단: `INTENT_cafe_opening --references--> {product-엽서·product-쿠폰류·product-스티커}` (intent→상품군 연결은 집필 층이 용어집·경쟁사 근거로 기록. `references`=R19 정식 등재 관계 — ontology-schema §2.2·any→any 약참조).
- 답: "카페 오픈에는 엽서·쿠폰·스티커가 많이 쓰입니다. 각 상품은…" + 각 상품 노드로 드릴다운.
- **스키마 충분(intent 레이어 덕분)** ✅. intent 노드가 없으면 이 질의 답 불가 → intent를 KB 전용 개체로 신설한 이유(ontology-schema §1.2).

**S5. "고급스러운 명함 추천해줘."**
- 1단: "고급"→용어집 → `INTENT_premium` + category-명함.
- 2단: category-명함 `--(역)in_category--> {명함 상품들}` 중 `INTENT_premium`이 references하는 노드(프리미엄명함·펄명함·박명함) 교집합.
- 답: "고급 마감으로는 프리미엄명함·펄명함·박명함이 있습니다(펄지·박 후가공)." + 각 상품의 `uses_material`·`has_process`로 근거.
- **스키마 충분** ✅ (intent∩category 교집합).

**S6. "청첩장에 어울리는 봉투도 같이 되나요?"**
- 1단: `INTENT_wedding` + product(엽서·카드류).
- 2단: 후보 상품 `--has_addon--> product-envelope` 존재 확인.
- 답: "엽서·카드에 봉투를 추가상품으로 함께 주문 가능합니다(예: 프리미엄엽서+엽서봉투 5종)." 근거=has_addon 엣지.
- **스키마 충분** ✅.

### 유형 3 — 조건 탐색 (속성 필터)

**S7. "양면 인쇄 되는 엽서 뭐 있어요?"**
- 1단: category-엽서.
- 2단: 역탐색 — `edge WHERE rel='has_print_option' AND dst LIKE 'printopt-%양면'` ∩ 엽서 상품.
- 답: 양면 print_option 가진 엽서 상품 목록. 근거=print_option 노드.
- **스키마 충분** ✅.

**S8. "박(호일) 넣을 수 있는 상품 다 보여줘."**
- 1단: `process-박`(process 노드) 또는 용어집 "호일"→"박".
- 2단: `SELECT src FROM edge WHERE rel='has_process' AND dst='process-foil'`.
- 답: 박 공정 가진 상품 목록(박명함·박 후가공 상품). 근거=has_process 역탐색.
- **스키마 충분** ✅ (자재→상품 역추적, graph-build §4.2d).

**S9. "몽블랑 용지 쓰는 상품 알려줘."**
- 1단: 용어집 "몽블랑"→`material-MAT_...`.
- 2단: `uses_material` 역탐색.
- 답: 해당 자재 쓰는 상품 목록. 근거=uses_material 엣지.
- **스키마 충분** ✅.

### 유형 4 — 옵션 조합·제약 (구성 가능성)

**S10. "180g 종이에 코팅도 같이 돼요?"**
- 1단: product 노드 + `option_group-종이두께`·`option_group-코팅`.
- 2단: `constraint --constrains--> {두 옵션그룹}` 존재 확인(CN-1~CN-6 유형). 예 047 소량전단지 코팅×종이두께 제약.
- 답: "이 상품은 180g+코팅 조합에 제약이 있습니다(제약규칙 존재)." 또는 "제약 없음". 근거=constraint 노드(폼빌더 shape·raw JSONLogic 미노출).
- **스키마 충분** ✅ (constraint→option_group 엣지).

**S11. "프리미엄엽서에서 고를 수 있는 후가공 다 뭐야?"**
- 1단: `product-016`.
- 2단: `--has_process--> {mand 제외 opt 공정}` + `--has_option_group-->`.
- 답: "모서리·오시·미싱·가변텍스트·가변이미지·코팅 선택 가능(디지털인쇄 base 공정 PROC_000004은 필수)." 근거=has_process(qualifier로 mand/opt 구분).
- **스키마 충분** ✅ (qualifier=mandatory가 필수/선택 구분).

**S12. "이 옵션 고르면 가격이 올라가요?"**
- 1단: option_group·option_item 노드.
- 2단: `option_refs --> (process/material)` → 그 실물이 `--(역)has_component`로 가격구성요소에 배선됐는지 확인(addtn_yn=가산).
- 답: "네, 이 옵션(예 코팅)은 가격구성요소(COMP_COAT_GLOSSY)에 배선되어 가산됩니다. **금액은 견적기 계산**." 근거=option_refs+has_component. 배선 안 됐으면(고아) 🔴 결함 신호로.
- **스키마 충분** ✅ (옵션→차원→구성요소 배선 추적 — §27 배선 계보가 그래프로).

### 유형 5 — 거절형 (범위 밖 — 정직 거절)

> 방법론 ⑤Q4·D-17: 1차 KB 범위 = **상품·구성요소·옵션·가격 차원·제약**. 주문·배송·회원·쿠폰은 범위 밖. 범위는 **노드로 선언**(`RULE_scope_boundary`)되어야 거절 게이트가 성립.

**S13. "이거 주문하면 언제 배송돼요?"**
- 1단: "배송"→용어집 → `RULE_scope_boundary`(out_of_scope: 주문·배송·회원·쿠폰).
- 2단: 범위 밖 판정 → 상품 노드로 라우팅 안 함.
- 답(거절 경로): "배송·주문 처리는 이 지식베이스 범위 밖입니다. 저는 상품 구성·옵션·가격 구성까지 안내합니다." **날조 금지**(배송일 지어내지 않음).
- **스키마 충분(거절 정확)** ✅.

**S14. "레드프린팅이랑 가격 비교해줘."**
- 1단: "가격 비교"+"레드프린팅" → `RULE_scope_boundary`(경쟁사 가격 비교=범위 밖 — 경쟁사는 구조 학습만·가격 복제 금지, docs/kb/03 §4.3).
- 답(거절): "경쟁사 가격 비교는 범위 밖입니다. 후니 상품의 가격 구성 방식은 안내할 수 있습니다."
- **스키마 충분** ✅.

**S15. "회원 등급 할인 얼마예요?"**
- 1단: "회원 등급"→`RULE_scope_boundary`(회원=범위 밖).
- 답(거절): "회원 등급·적립 정책은 범위 밖입니다."
- **스키마 충분** ✅.

**S16. "이 상품 재고 있어요?"** (경계 사례)
- 1단: "재고"→ 범위 밖(주문/운영 영역). 인쇄는 주문 제작이라 "재고" 개념 자체가 없음도 병기.
- 답(거절+안내): "인쇄물은 주문 제작이라 재고 개념이 없고, 재고·주문 상태는 범위 밖입니다."
- **스키마 충분** ✅.

---

## 2. 시나리오 커버리지 요약

| 유형 | 시나리오 | 필요 개체/관계 | 스키마 충분? |
|------|----------|---------------|-------------|
| 1 구체 상품 | S1·S2·S3 | product·size·print_option·formula·component·qty | ✅ (S1은 판수 GAP 정직 노출) |
| 2 용도 추천 | S4·S5·S6 | **intent(KB전용)**·category·`references`(R19)·has_addon | ✅ (intent 레이어 필수·references R19 등재로 경로 완결) |
| 3 조건 탐색 | S7·S8·S9 | print_option·process·material 역탐색 | ✅ |
| 4 옵션 조합 | S10·S11·S12 | option_group·constraint·option_refs·has_component | ✅ (배선 추적) |
| 5 거절형 | S13·S14·S15·S16 | **RULE_scope_boundary(노드로 선언)** | ✅ (거절 정확·날조 0) |

---

## 3. 답 못 하는 시나리오 (스키마 밖 — 명시)

| 시나리오 | 왜 못 하나 | 처리 |
|----------|-----------|------|
| "정확히 132,450원 맞죠?" (가격 값 단정) | 가격 값 계산은 온톨로지 밖(D-18) | "구성은 안내, 최종 금액은 견적기"로 위임. KB는 값 단정 안 함 |
| "73×98 판걸이수 정확히 몇?" | 마스터 15 vs 판걸이수 18 충돌(GAP-1) | ⚪ gap 노드로 "확인 대기" 정직 답변. 지어내지 않음 |
| "롤 소재 가격 어떻게 계산돼?" | 엑셀 미기재 암묵지(GAP-2) | gap 노드 — "원천 부재, 실무진 확인 대기" |
| "주문·배송·회원·쿠폰" 전반 | 범위 밖(⑤Q4) | RULE_scope_boundary 거절 경로 |
| "경쟁사 가격 비교" | 범위 밖·가격 복제 금지 | 거절 |
| "이 조합 실제로 만들 수 있어?"(물리 제약 미등록분) | 제약이 아직 노드화 안 된 상품 | constraint 없으면 "제약 정보 미등록"으로 정직(단정 금지) |

> **CoVe식 검증 질문(D-17):** 각 답변 초안에 대해 "이 답이 틀렸다면 어디서?"를 독립 확인 — ① 인용 노드가 blocklist에 없나(O2) ② 라이브 값을 "정답"으로 단정 안 했나(양면) ③ 범위 밖을 상품으로 답하지 않았나. 질의 게이트(okb-adversarial-gate)가 이 3점을 판정.

---

## 4. 스키마 결함 진단 결과 (경로 안 그려진 것)

| 검사 | 결과 |
|------|------|
| 5유형 12+ 시나리오 전부 경로가 그려지나 | ✅ 16/16 경로 성립 |
| 용도 추천(유형 2)이 라이브 축만으로 되나 | ❌ 안 됨 → **intent KB전용 레이어 신설로 해결**(ontology-schema §1.2). 라이브 t_*에 용도 축 없음을 스키마가 정직 반영 |
| 거절(유형 5)이 노드 기반으로 되나 | ✅ RULE_scope_boundary 노드로 범위를 선언해야 성립 — 신설 정당(⑤Q4) |
| 가격 값 질의가 경계를 지키나 | ✅ D-18 위임 경로로 값 단정 회피 |
| **경로 안 그려진 시나리오** | 없음. 단 유형 2·5는 KB전용 노드(intent·scope_boundary)에 의존 — 이 두 노드가 스키마의 필수 요구사항임을 증명 |

---

## Sources
- `ontology-schema.md` (개체17·관계19·intent/gap/scope 노드·references R19·양면/GAP 패턴)
- `graph-build-spec.md` (§4 재귀 CTE 질의 예시 a~d·역탐색)
- `../00_research/methodology-playbook.md` (D-11 하이브리드검색·D-17 CoVe·D-18 가격경계·⑤Q4 범위)
- `../01_curation/pack-digital-print.md` (§3 축별 사실·판수 GAP·047 제약·016 봉투 addon·거절 경계 §0)
- `../01_curation/source-registry.md` (§9 GAP-1 판수·GAP-2 롤소재·docs/kb/03 §4.3 경쟁사 가격복제 금지)

---

## 변경 이력

### v1.0.1 — 2026-07-03 (스키마 리뷰 교정 — `05_verification/schema-review-260703.md`)
> 스키마 실질 불변. 문서 정합 결함만 해소.

- **F-1 [High]** 유형 2(용도 추천) 유일 연결 메커니즘 `references`가 폐쇄 관계 목록에 없어 경로 증명에 구멍이 있던 것을, ontology-schema §2.2 R19 등재로 해소. S4 2단·§2 커버리지표·Sources에 "references=R19 정식 등재" 반영해 "스키마 충분 ✅" 판정을 실제로 성립시킴(등재 전에는 미선언 관계 의존).
