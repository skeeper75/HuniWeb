# 지식맵 — 아는 것 / 모르는 것 (knowledge-map)

> Phase 1 — hped-mechanism-researcher. **이 하네스의 존재 이유.** 미지를 확정으로 위장 금지.
> 검증·결론 금지(이해까지만). 라이브 실측일 2026-06-18. 라이브 읽기전용.

---

## A. 아는 것 (확정 — 검증·적재가 신뢰할 토대)

### A1. 엔진 골격 `[확정·코드근거]`
- 단일 권위 알고리즘은 `pricing.py:evaluate_price` **하나** (위젯·주문 재검증 동일 재사용) — pricing.py:1-5,247.
- 가격 우선순위: **템플릿단가 → 상품 직접단가 → 상품공식 → 없음** — pricing.py:13,285-328.
- 공식 = **항상 구성요소 합산** (frm_typ 유형 분기 폐기) — pricing.py:8,346-352.
- 합산 = included 구성요소 subtotal 단순 합 — pricing.py:346.
- 할인 = base 후처리, 수량구간 → 등급 **순차** 적용 — pricing.py:359-368.
- 최종가 = running 원 단위 ROUND_HALF_UP — pricing.py:63-65,369.

### A2. 차원 매칭 규칙 `[확정·코드근거]`
- 비수량 정확매칭 차원 `NON_QTY_DIMS` = siz_cd, plt_siz_cd, print_opt_cd, mat_cd, proc_cd, opt_cd, coat_side_cnt, bdl_qty — pricing.py:38-39.
- 티어 차원 = siz_width/siz_height(**'이하' 상한**, 담는 최소 구간), min_qty(**'이상' 하한**, 이하 중 최대) — pricing.py:45-46,144-162.
- 차원 컬럼 NULL = 와일드카드(무관) — pricing.py:16,82-84.
- 공정 상세 = dim_vals jsonb, 키별 정확매칭(와일드카드 없음) — pricing.py:87-89.
- 동시매칭(차원조합 2개↑) = `ERR_AMBIGUOUS` 데이터 오류, 흡수 거부 — pricing.py:20-21,136-138.
- 동일 (조합·구간·적용일) 중복행 = `ERR_DUPLICATE` — pricing.py:169-173.
- 시계열 = apply_ymd 오늘(as_of) 이하 최신 — pricing.py:23,232-235.

### A3. 단가형/합가형 환산 `[확정·코드근거]`
- 단가형(PRICE_TYPE.01) = unit_price 장당가 → ×수량 — pricing.py:48,191-192.
- 합가형(PRICE_TYPE.02) = unit_price 구간총액 → ÷min_qty=장당가 → ×수량; min_qty≤0이면 ValueError — pricing.py:49,185-190.

### A4. 장치 역할 경계 `[확정·코드근거]`
- 뷰어/다이어그램 = 적재 확인(읽기), 계산 안 함 — price_views.py:212-218,377-518.
- 시뮬레이터 = 입력→evaluate_price 위임, 자기 계산 로직 없음 — price_views.py:1296-1297.
- 할인 = base를 만들지 않고 깎기만 — pricing.py:478-537.

### A5. 라이브 데이터 현황 (적재량) `[확정·데이터 2026-06-18]`
| 테이블 | 행수 | 의미 |
|--------|------|------|
| t_prc_price_formulas | 48 | 공식 |
| t_prc_price_components | 146 (단가형143/합가형3) | 구성요소 |
| t_prc_formula_components | 301 | 배선 |
| t_prc_component_prices | 7,293 | 단가행 |
| t_prd_product_price_formulas | 76 | 상품-공식 바인딩 |
| **t_prd_product_prices** | **0** | 직접단가 미적재 |
| **t_prd_template_prices** | **0** | 템플릿단가 미적재 |
| t_dsc_discount_tables / details | 7 / 35 | 수량구간 할인 |
| t_prd_product_discount_tables | 102 | 상품-할인 연결 |
| **t_dsc_grade_discount_rates** | **0** | 등급할인율 미적재 |

→ **확정 사실**: 현재 라이브에서 base는 **항상 공식 경로**(직접단가·템플릿단가 0행), **등급할인은 미발화**(rates 0행). 수량구간 할인은 데이터 존재.

---

## B. 모르는 것 (미지·추정 — 컨펌큐로 닫아야 함)

각 항목: 무엇을 모르나 · 왜 중요한가(잘못 적재 위험) · **누가 답하나**.

### Q1. clr_cd vs print_opt_cd — 도수는 어느 차원으로 매칭되나 `[미지·리서치필요]`
- **무엇**: 스키마·PRCX-01은 도수를 `clr_cd`로 정의 `[설계산출물 prcx01:42]`. 그러나 `pricing.py NON_QTY_DIMS`에 clr_cd 없음 — 매칭은 `print_opt_cd`(앞/뒷면 도수 묶음) `[코드 pricing.py:38]`. 단가행에 clr_cd 값이 들어가도 엔진은 그 컬럼으로 매칭하지 않는다.
- **왜 중요**: 도수를 clr_cd에 적재해온 라운드가 있으면 **엔진이 안 읽는 차원에 적재** = 가격 미반영 위험. "컬럼 존재 ≠ 엔진 사용"의 핵심.
- **누가 답하나**: ⓐ 코드실측(**code-schema-auditor 확인 대상** — 라이브 단가행에서 clr_cd 충전 vs print_opt_cd 충전 분포·실제 매칭 가능 여부) ⓑ 사용자/도메인(도수 인코딩 의도: 단일 도수 vs 앞뒤 묶음).

### Q2. 라이브 단가행이 use_dims 선언대로 차원을 채웠나 `[미지·리서치필요]`
- **무엇**: 구성요소 use_dims 선언 ↔ 단가행 실제 충전 차원 ↔ 권위 가격축의 3원 정합. (예: use_dims에 mat_cd 있는데 단가행 mat_cd 전부 NULL이면 '판별차원 없음'=항상 매칭=오염 `[코드 pricing.py:412-415]`.)
- **왜 중요**: 판별차원 없는 구성요소·동시매칭 유발 행은 가격 오류. 엔진이 경고("판별차원 없음")까지 만든다.
- **누가 답하나**: ⓐ **code-schema-auditor 확인 대상**(use_dims↔단가행 충전 전수 대조·`price_dup_check`/`price_comp_usage` 진단뷰 재실행).

### Q3. `addtn_yn`의 런타임 효과 `[미지·리서치필요]`
- **무엇**: 배선 `addtn_yn`(Y=합산). 다이어그램은 "⊕"로 표시 `[코드 price_views.py:500]`. 그러나 `_evaluate_formula`는 addtn_yn을 분기에 쓰지 않고 매칭된 전 구성요소 합산 `[코드 pricing.py:457-474]`.
- **왜 중요**: addtn_yn=N 구성요소가 있다면 — 표시만 다른가? 합산에서 빠져야 하는가? 빠져야 한다면 현재 엔진은 그걸 무시(전부 합산) = 잠재 과대합산.
- **누가 답하나**: ⓐ 코드실측(라이브 formula_components에 addtn_yn='N' 행 존재 여부 — **code-schema-auditor**) ⓑ 사용자/도메인(addtn_yn 의도: 표시용 vs 합산 제어).

### Q4. 합가형 3구성요소·면적 매트릭스가 어느 상품에 바인딩되나 `[미지·리서치필요 일부]`
- **무엇**: 합가형 구성요소가 라이브 3개뿐 `[데이터]`. 어느 공식→어느 상품에 쓰이는지, min_qty 충전(÷환산 안전)이 모두 됐는지.
- **왜 중요**: 합가형 min_qty=0/NULL이면 견적 시 ValueError(계산불가) `[코드 pricing.py:187-188]`. 메모(dbmap-acrylic A5)에 실제 그 사고 기록.
- **누가 답하나**: ⓐ 코드실측(**code-schema-auditor** — 합가형 3구성요소의 단가행 min_qty NULL 점검 + 바인딩 경로).

### Q5. 등급할인·직접단가·템플릿단가 0행은 의도인가 미적재인가 `[추정·도메인]`
- **무엇**: rates·product_prices·template_prices 전부 0행. 엔진은 3경로 구현했으나 데이터 없음.
- **추정**: 현재 단계가 "공식 기반 적재 우선"이라 직접단가/템플릿/등급은 후속 — 메모·CLAUDE.md 정합. 하지만 **확정 아님**.
- **왜 중요**: 0행을 "결함"으로 오판하면 불필요 적재 트리거. "의도된 미적재"면 검증 범위에서 제외.
- **누가 답하나**: 사용자(로드맵 의도) + 도메인(템플릿단가=SKU 끼워팔기 정책 시점).

### Q6. `proc_grp:` 스코프와 다중 공정 평가의 라이브 정합 `[추정·도메인]`
- **무엇**: use_dims의 `proc_grp:PROC_xxxxxx`가 공정 그룹 스코프 `[코드 pricing.py:413,460-462]`. proc_sels로 공정마다 개별평가. 라이브 공정 단가행 dim_vals 구조가 이 평가와 정합하는지.
- **왜 중요**: 공정 상세(dim_vals) 키 불일치 시 no_match=후가공비 누락.
- **누가 답하나**: ⓐ 코드실측(**code-schema-auditor** — 공정 구성요소 단가행 dim_vals 키 vs proc_param_cols).

---

## C. code-schema-auditor 확인 대상 큐 (병렬 협업)

미지 항목 중 **코드/스키마 실측으로 풀리는 것**을 짝 에이전트에 라우팅:
- **CSA-1** ← Q1: 라이브 단가행 clr_cd vs print_opt_cd 충전 분포 + 도수 매칭 실가능성.
- **CSA-2** ← Q2: 전 구성요소 use_dims 선언 ↔ 단가행 충전 차원 3원 대조(판별차원 없음·NULL 차원 적발).
- **CSA-3** ← Q3: formula_components addtn_yn='N' 행 존재 여부 + 엔진 무시 영향.
- **CSA-4** ← Q4: 합가형 3구성요소 단가행 min_qty NULL/0 점검 + 바인딩 경로.
- **CSA-6** ← Q6: 공정 구성요소 dim_vals 키 vs proc_param_cols 정합.

→ code-schema-auditor 산출(`02_code_schema/`)이 나오면 위 항목 확신도를 `[미지]`→`[확정·코드근거]`로 격상하고 본 지식맵 재배치.

## D. 사용자/도메인 컨펌 큐
- **U-1** ← Q1: 도수 인코딩 의도(단일 clr_cd vs 앞뒤 묶음 print_opt_cd) — 어느 게 정답 차원인가.
- **U-2** ← Q3: addtn_yn 의도(표시용 vs 합산 제어).
- **U-3** ← Q5: 직접단가·템플릿단가·등급할인율 0행 = 의도된 미적재인가.

---

## C-RESOLVED. code-schema-auditor 교차참조 (02_code_schema/ 수신 2026-06-18)

짝 에이전트 산출이 도착해 아래 미지 항목 확신도를 격상한다. **단, 의도(WHY)는 여전히 사용자 컨펌**(사실 격상 ≠ 의도 확정).

- **CSA-1 ← Q1 [미지 → 확정·코드근거+데이터]**: clr_cd는 **dead** — NON_QTY_DIMS 미포함 + 라이브 충전 **0/7293행**(sql/28이 clr_cd 행 424개 DELETE, print_opt_cd로 이관). print_opt_cd는 **1431/7293행** 충전·정상 매칭. 즉 도수 매칭 차원은 print_opt_cd로 확정. (clr_cd 컬럼·FK·unique 멤버는 잔존 — dead vestige.) → impl-gap-board G-3. **남는 컨펌 U-1: 이 폐기가 의도인가(설계 prcx01 LOCKED와 충돌).**
- **CSA-3 ← Q3 [미지 → 확정·코드근거+데이터]**: addtn_yn은 **dead** — `_evaluate_formula`가 SELECT·참조 0회(pricing.py:452 values 미포함). 라이브 301행 전부 채워졌으나 엔진 무시 → **차감(N) 구성요소 표현 불가, 공식=항상 전 합산**. → G-4. **남는 컨펌 U-2: addtn_yn='N' 행이 라이브에 있나·있다면 과대합산인가.**
- **CSA-2 ← Q2 [부분 격상]**: 차원 충전 분포 실측 = `siz_cd 4157·mat_cd 3342·proc_cd 1901·print_opt_cd 1431·plt_siz_cd 1219·siz_w/h 922·min_qty 6503·dim_vals 310·opt_cd 5·clr_cd 0`. **opt_cd 사실상 미사용**(린넨 마감 1 comp 5행) → CPQ 옵션→가격 연결 라이브 부재(round-7 발견과 정합). 개별 구성요소 use_dims↔충전 판별차원 없음 적발은 검증 트랙 몫.
- **CSA-신규 G-2 ← Q6 인접 [발견]**: `proc_grp:` 스코프 토큰을 pricing.py **두 곳이 비대칭 처리** — `_match_entry`(:412)는 `opt_grp:`만 스트립, `_evaluate_formula`(:460)는 `:` 일반 스트립. proc_grp 보유 comp 36개. "판별차원 없음" 라벨 오부착 가능성 → 검증 트랙 추가 추적.

> 이로써 device-roles §discrepancy 보드 D-2(clr_cd)·D-4(addtn_yn)는 **"코드/라이브 = dead, 설계 문서 stale"로 사실 확정**. 의도 판정만 사용자 큐(U-1·U-2)에 남는다.

## F. ★SOT 반영 — 미지의 해소·재배치 (2026-06-18 사용자 7 SOT 권위)

사용자가 준 7 SOT(`sot-definitions.md`)가 아래 미지를 **해소/추인/승격**한다. SOT는 `[확정·사용자SOT]` — 추정으로 덮지 않음.

### F1. SOT가 해소·추인한 미지

| 미지 | SOT | 변화 |
|------|-----|------|
| **Q1/U-1** 도수 clr_cd vs print_opt_cd | SOT 3b | **추인.** 10차원에 clr_cd 없음·print_opt_cd(③인쇄옵션) 있음 → 도수=print_opt_cd 폐기가 **SOT 권위로 확정 방향**. (prcx01 LOCKED 문서 형식충돌은 문서 갱신 백로그.) |
| **Q3/U-2** addtn_yn 효과 | SOT 4 | **재해석.** 핵심은 차감(N)이 아니라 **배선 레벨 제약 부재**(SOT 4). addtn_yn은 합산/차감 토글일 뿐, "이 comp가 이 상품에 허용되나" 제약이 아님. addtn_yn 자체의 dead 여부는 여전히 U-2(코드실측). |
| **opt_cd near-dead(G-7)·CPQ→가격 단절(round-7)** | SOT 3a | **해소.** 옵션그릇=가격 없음(add_price 컬럼 부재 실측)·자재/공정 BUNDLE 환원축. opt_cd 5행은 **결함 아니라 설계 정합**(옵션은 보통 가격축 아님). |
| **U-6 일부** 수량×단가 귀속 | SOT 6 | **부분 해소·부분 승격.** 추가상품(a)=별도 SKU 재귀평가로 확정. 부자재(b)=10차원 흡수로 확정. 단 "수량 축"은 미해소(아래 U-6 승격). |

### F2. SOT가 새로 던지는 미지 (컨펌큐 추가)

| # | 미지 항목 | 왜 모르나 | 누가 답하나 |
|---|----------|----------|------------|
| **U-7** | **배선 레벨 제약 장치를 어떻게 설계하나**(SOT 4) | comp↔상품 허용 검사가 라이브 부재(가격 6엔티티 제약 트리거 0건). 시트(SOT 1) 허용 차원을 배선에 강제할 장치 미존재 | **사용자/설계 + 검증 트랙** (신규 설계 — 가격 그릇 경계 제약) |
| **U-6(승격)** | 부자재 수량×단가의 **"수량"이 주문수량 / BOM소요량(option_items.qty) / 출력매수 중 무엇인가** | SOT 6 (b)로 10차원 흡수 확정됐으나 수량 축 미확정. 직전 N-1b(임포지션 변환 부재)와 직결 | **사용자/도메인** |
| **U-8** | 추가상품 SKU 단가를 `template_prices`(0행)에 적재할 것인가, base_prd_cd 공식사슬로 둘 것인가(SOT 6 a) | template_prices 0행이 의도된 미적재인지·SKU 고정단가 정책 시점 불명 | **사용자(로드맵)** |
| **U-9** | SOT 3b가 min_qty를 10차원에서 제외 — **수량을 "차원"이 아닌 "주문 축"으로 보는 개념이 옳은가**(코드는 min_qty도 티어 차원) | SOT의 차원 개념 ↔ 엔진의 차원 컬럼 개념 정합은 양립으로 읽히나 명시 확인 안 됨 | **사용자/도메인** |

### F3. SOT가 못박은 오적재 근본 (가장 중요)

**SOT 1(시트=허용 차원 경계) + SOT 4(배선 레벨 제약 부재) = 직전 D-1/2/3 이중합산·D-6 현수막별색의 단일 병인.**
- F-3(엔진 무차별 합산)은 **증상**, SOT 4(제약 부재)가 **병인**, SOT 1이 **올바른 경계의 권위**.
- → 검증·적재 전에 "comp↔상품 허용"(SOT 1 경계)을 어디서 어떻게 강제할지(U-7)를 닫는 것이 오적재 재발 방지의 핵심.

---

## E. 한 줄 요약
**확정**: 엔진은 evaluate_price 단일 알고리즘, 공식=구성요소 합산, 차원은 단가행이 책임(정확매칭/티어), 단가형/합가형 환산, 할인 후처리 — 전부 코드 근거. **SOT 추가확정(2026-06-18)**: 시트=허용 차원 경계(SOT 1)·결합/독립 구성요소(SOT 2)·10차원(SOT 3b·min_qty는 주문축)·옵션/추가상품=가격 없음(SOT 3a·6). **오적재 근본 = SOT 1+4(시트 경계 + 배선 제약 부재), F-3은 증상.** **잔존 미지**: 배선 레벨 제약 설계(U-7·신규)·수량 축 정체(U-6 승격)·SKU 단가 적재 정책(U-8)·addtn_yn dead 확인(U-2). 미지를 확정으로 적재하면 가격 오류로 직결되므로 닫기 전 적재·검증 금지.
