# _codex-prompt-goods-pouch.md — codex 독립 2차 교차검증 프롬프트 (굿즈/파우치·verdict 비노출)

> Phase 5.5 독립성[HARD] 입증용. codex(gpt-5.5·effort high)에 전송한 프롬프트 전문.
> ★hpe-validator의 E1~E7 결론·GO/NO-GO·gate-verdict는 **일절 포함하지 않음**(echo 방지).
> codex에는 설계 산출물 5파일(engine-design·golden-cases·formula-map·absorption-candidates·design-decisions 굿즈절) + 엔진 계약 사실만 제공.
> 호출: `cat _prompt.md 설계5파일 | codex exec -m gpt-5.5 --sandbox read-only --skip-git-repo-check -c model_reasoning_effort=high --output-last-message ...`

---

당신은 후니프린팅 인쇄 자동견적 시스템의 **가격계산 엔진 설계를 독립 심사**하는 외부 검토자입니다. 다른 사람의 판정 결과는 주어지지 않았습니다 — 당신 스스로의 독립 판단을 내려야 합니다.

# 배경 (엔진 계약 사실)

후니 가격엔진은 `evaluate_price` 단일 알고리즘(`pricing.py`)입니다. 핵심 계약(사실):
- 가격 소스 우선순위: TEMPLATE → PRODUCT_PRICE(`t_prd_product_prices`) → FORMULA.
- PRODUCT_PRICE 경로: `t_prd_product_prices`는 `prd_cd·apply_ymd(PK)·unit_price·note` 컬럼만 보유(차원 컬럼 없음). `base_amount = unit_price × qty`.
- 공식(FORMULA)은 항상 `formula_components`의 구성요소(comp)를 **합산**(Σ). 엔진은 `frm_typ_cd`(공식유형)를 참조하지 않음(그 컬럼 부재).
- 구성요소 단가 매칭은 고정 상수 `NON_QTY_DIMS`(= siz_cd, plt_siz_cd, print_opt_cd, mat_cd, proc_cd, opt_cd, coat_side_cnt, bdl_qty)를 순회하며 단가행 컬럼과 손님 선택값을 대조. 행 컬럼이 NULL이면 와일드카드(항상 통과). 손님 선택값이 NULL인데 행 컬럼이 non-NULL이면 불일치(no_match).
- 한 공식에 같은 comp_cd가 두 번 배선되거나 판별차원이 겹치면 `_combo_key` 충돌 → ERR_AMBIGUOUS 또는 silent 합산 위험.
- 단가형(prc_typ=.01): `subtotal = unit_price × qty` (÷min_qty 미발생).
- 합가형(prc_typ=.02): `subtotal = unit_price ÷ tier_min_qty × qty` (min_qty NULL이면 ValueError).
- min_qty TIER 매칭은 '이상' 하한(주문수량 이하 최대 임계 행 선택).
- 수량구간할인: `t_prd_product_discount_tables`의 prd_cd→dsc_tbl_cd 링크 → `t_dsc_discount_tables`(헤더·dsc_typ_cd) → `t_dsc_discount_details`(min_qty≤qty≤max_qty 구간 rate%) → 정률 `amount×(1−rate/100)`. 링크 누락 시 할인 0.
- 모델 매니저는 기본 Manager로, del_yn 같은 논리삭제 컬럼을 자동 필터하는지는 명시되지 않음(당신이 코드 동작을 추론·가정 명시).
- `t_prd_product_option_items` 컬럼: prd_cd, opt_cd, item_seq, ref_dim_cd, ref_key1, ref_key2, qty, use_yn, del_yn, ..., dtl_opt (add_price/amt 컬럼 없음).

# 심사 대상: 굿즈/파우치 상품군 가격엔진 설계

첨부 설계 산출물 5개: formula-map / absorption-candidates / engine-design / golden-cases / design-decisions(굿즈/파우치 절).

상품군 특성(설계 산출물에서 확인): 계산방식은 단일 "고정가형"(면적매트릭스/원자합산/세트조합/출력매수 곱셈 전부 없음). 86 distinct 상품(라이브 활성 88). 라이브 가격본체(product_prices) 0행·공식 바인딩 0·CPQ option_items 0. 단 수량구간할인 바인딩 82·자재 BOM 다수 적재. 두 서브유형: GP-1 단일고정가(55) / GP-2 변형고정가(31·옵션 variant별 다른 고정가 S5000/M5500/L6000 등).

# 당신이 독립으로 판정할 핵심 질문 (정답 미제공 — 스스로 추론)

각 질문에 GO/CONDITIONAL/NO-GO + 근거. 설계가 옳은지 스스로 판단하고 틀렸거나 위험하면 명확히 지적.

- **Q1. GP-1 단일고정가 그릇** — 단일 고정가 55상품을 `t_prd_product_prices` 직접 경로(공식/comp 없이)로 두는 것이 타당한가, 아니면 명함식 통합 comp 공식이 필요한가? 과설계/미설계 판단.
- **Q2. GP-2 변형고정가 그릇** — variant별 자기 고정가(S/M/L·용량·면)를 담을 그릇을 (a)variant별 별 prd_cd / (b)variant-매트릭스 formula(comp 1개·use_dims=[opt_cd or siz_cd]) / (c)option_items add_price 신규 컬럼 중 무엇으로 해야 하는가? 신규 테이블이 필요한가, 기존 component_prices 1축 재사용으로 충분한가? 스스로 결정.
- **Q3. variant 평탄화 오청구 위험** — GP-2 variant 단가를 단일 평탄 unit_price로 적재 시 M 주문에 S가격(또는 L가격) 오청구 위험이 실재하는가? 산술로 입증·방지책 판단.
- **Q4. 고정가형 ×qty 폭발·silent 합산** — 고정가형(개당단가)에 ×qty 폭발(묶음총액을 단가형 오적재)·silent 합산(use_dims=[]/NULL 와일드카드) 위험이 있는가 없는가? 다른 상품군(인쇄면 합산·타공 합산)과 대조하며 독립 판단.
- **Q5. 구간할인 4타입 체계** — 굿즈 "수량별구간할인 타입" 4종(GOODSA/B·FABRIC·SQUISHY) 택1 체계가 타당한가? 단일 할인테이블 대비 의미가 있는가? 같은 qty에 타입별 다른 rate가 정당한가 위험인가?
- **Q6. 본체 소재/색/형상/구수 오염 정리를 가격엔진 밖(데이터 정리 트랙)에 위임** — 본체 소재가 단일 고정가에 baked-in이라 가격축이 아니라는 판단, 그래서 자재오염 정리를 가격엔진이 아닌 별도 데이터 트랙에 위임하는 게 타당한가? 가격엔진 스코프 경계가 맞는가?
- **Q7. 신규 가격축/그릇 필요 여부** — 기존 그릇(고정가형 PRODUCT_PRICE·component_prices opt_cd/siz_cd 차원·min_qty·t_dsc)으로 닫히는가? 경쟁사 흡수가 overfit/답습 아닌가? 신규 테이블/가격축이 진짜 필요한가?
- **Q8. 골든 정합 + 추가 위험 발굴** — GC-GP1~12 직접 계산 재현(허용오차 0 확인)·평탄화 양면(5500 vs 5000/6000)이 맞는가? 차원 미스매치·이중계상·오배선 등 독립 지적.

# 출력 형식

Q1~Q8별 판정(GO/CONDITIONAL/NO-GO)+근거(산술 직접 계산), 마지막에 종합 판정+돈크리티컬 위험 요약. 한국어. 설계 결론 echo 금지·스스로 도출한 판단.
