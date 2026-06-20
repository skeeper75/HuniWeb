# _codex-prompt-booklet.md — codex 독립 2차 교차검증 프롬프트 (책자·verdict 비노출)

> Phase 5.5 독립성[HARD] 입증용. codex(gpt-5.5·effort high)에 전송한 프롬프트 전문.
> ★hpe-validator의 E1~E7 결론·GO/NO-GO·gate-verdict는 **일절 포함하지 않음**(echo 방지).
> codex에는 설계 산출물 5파일(engine-design·golden-cases·formula-map·absorption-candidates·design-decisions 책자 절) + 엔진 계약 사실만 제공.
> 호출: `cat _prompt.md 설계5파일 | codex exec -m gpt-5.5 --sandbox read-only --skip-git-repo-check -c model_reasoning_effort=high --output-last-message ...`

---

당신은 후니프린팅 인쇄 자동견적 시스템의 **가격계산 엔진 설계를 독립 심사**하는 외부 검토자입니다. 다른 사람의 판정 결과는 주어지지 않았습니다 — 당신 스스로의 독립 판단을 내려야 합니다.

# 배경 (엔진 계약 사실)

후니 가격엔진은 `evaluate_price` 단일 알고리즘(`pricing.py`)입니다. 핵심 계약(사실):
- 가격 소스 우선순위: TEMPLATE → PRODUCT_PRICE → FORMULA.
- 공식(FORMULA)은 항상 `formula_components`의 구성요소(comp)를 **합산**(Σ). 엔진은 `frm_typ_cd`(공식유형)를 참조하지 않음(그 컬럼 부재).
- 구성요소 단가 매칭은 고정 상수 `NON_QTY_DIMS`(= siz_cd, plt_siz_cd, print_opt_cd, mat_cd, proc_cd, opt_cd, coat_side_cnt, bdl_qty)를 순회하며 단가행 컬럼과 손님 선택값을 대조. 행 컬럼이 NULL이면 와일드카드(항상 통과). 손님 선택값이 NULL인데 행 컬럼이 non-NULL이면 불일치(no_match).
- 한 공식에 같은 comp_cd가 두 번 배선되거나 판별차원이 겹치면 `_combo_key` 충돌 → ERR_AMBIGUOUS 또는 silent 합산 위험.
- 단가형(prc_typ=.01): `subtotal = unit_price × qty` (÷min_qty 미발생).
- 합가형(prc_typ=.02): `subtotal = unit_price ÷ tier_min_qty × qty` (min_qty NULL이면 ValueError).
- min_qty TIER 매칭은 '이상' 하한(주문수량 이하 최대 임계 행 선택).
- 모델 매니저는 기본 Manager로, del_yn 같은 논리삭제 컬럼을 자동 필터하는지는 명시되지 않음(당신이 코드 동작을 추론·가정 명시).

# 심사 대상: 책자(반제품 세트) 상품군 가격엔진 설계

첨부 설계 산출물 5개: formula-map / absorption-candidates / engine-design / golden-cases / design-decisions(책자 절).

# 당신이 독립으로 판정할 핵심 질문 (정답 미제공 — 스스로 추론)

각 질문에 GO/CONDITIONAL/NO-GO + 근거. 설계가 옳은지 스스로 판단하고 틀렸거나 위험하면 명확히 지적.

- **Q1. 두 갈래 구조 타당성** — (A)단일 prd 제본비형 vs (B)세트 부모 부품 합산형 분리가 타당한가, 과분할인가?
- **Q2. 제본비 단일항 vs 부품 합산** — 책자 가격이 제본비 한 항목인가 표지+내지+인쇄+제본 합산인가? 증거로 독립 판단.
- **Q3. 제본비 .01 단가형 정당성** — 단가가 부당(권당)인가 묶음총액인가? 단가 추이로 판단·÷min_qty 필요한가?
- **Q4. 삭제(del_yn='Y') comp 가격 포함 + 중철 단가행 오염** — 결함인가·과청구 유발하는가?
- **Q5. 골든 정합** — GC-BK1~6 직접 계산 재현·corrupt/corrected 양면이 맞는가?
- **Q6. 이중수량(부수×페이지)·페이지/책등 앱계산** — 옳은가?
- **Q7. 신규 가격축/그릇 필요 여부** — 기존 그릇으로 닫히는가·흡수가 overfit 아닌가?
- **Q8. 추가 위험 발굴** — 차원 미스매치·이중계상·silent 합산·오배선 등 독립 지적.

# 출력 형식

Q1~Q8별 판정+근거(산술 직접 계산), 마지막에 종합 판정+돈크리티컬 위험 요약. 한국어. 설계 결론 echo 금지·스스로 도출한 판단.
