# 상품 준비도 평가 루브릭 (Huni-Product-Readiness §29)

> 권위 문서. "한 상품이 실제로 **가격계산·위젯까지 갈 준비가 됐는가**"를 재는 **자(尺)**.
> 자 만들기 = 본 문서(rubric-curator). 자로 재기 = hpr-readiness-evaluator. 자의 충실성 검증 = hpr-scorecard-gate.
> 작성 2026-06-30. 재사용 우선[HARD] — 기존 채점·정합 산출을 증거로 매핑(`reuse-evidence-map.csv`), 처음부터 다시 채점 금지.

## 0. 평가 프레이밍 (사용자 확정 권위)
- **가격계산 방식 = 상품구성요소 + 가격구성요소를 토대로 계산.** 권위 = 상품마스터(260610) + 인쇄상품 가격표(260527).
- 따라서 평가의 **핵심 단위** = 각 상품의 **「예상 구성요소(권위 기준) vs 라이브 실제 적재」를 차원별로 대조**한 결과. 이 대조 데이터가 최종 웹 대시보드의 **상세 패널**이 된다.
- 채점 대상 = **권위 충실도**(자유 구성 탐색 아님). 9축 값은 권위 엑셀이 given(SOT·탐색 금지). 단 "어느 **구현 모델**이 PR=100 AND OC=100을 동시 만족하는가"는 채점 가치(5모델 셰이크아웃·[[price-model-decision-tree-sim-gate]]).
- **돈 크리티컬**: 셀 1% 틀려도 ×1000 밴드총액이면 치명. 허용오차 0(`money_delta` 1급 지표).

---

## 1. 평가 차원 D1~D11

각 차원은 **권위가 무엇을 요구하는가(needed)** → **라이브가 그것을 담았는가(filled)** → **PASS/WARN/FAIL** 순으로 판정한다.
needed=N(권위가 그 축을 요구하지 않음)인 차원은 **N/A**(분모에서 제외·완성률 재정규화).

| 차원 | 무엇을 재나 | 권위 원천 | 라이브 대상 t_* | PASS | WARN | FAIL |
|------|-------------|-----------|-----------------|------|------|------|
| **D1 구성요소 요건** | 자재·공정·사이즈·도수 BOM이 상품 정체에 맞게 갖춰졌나 | 상품마스터 시트(차원 경계) | t_prd_product_{materials,sizes,processes}·도수 | 권위 요구 요소 전부 존재 | 보조요소 1~2 누락(가격 무관) | 핵심 BOM 요소 누락(가격 영향) |
| **D2 가격공식 바인딩** | 상품-공식(frm_cd) 연결 + formula_components 배선 | 계산공식집초안 27블록·[[price-formula-collection-keystone-260629]] | 상품-공식 바인딩·t_prc_formula_components | 공식 연결 + 전 구성요소 배선 | 공식 연결됐으나 구성요소 1개 미배선 | 공식 미바인딩(frm None=UNBOUND) |
| **D3 가격구성요소·단가행** | price_components·component_prices 단가행 충전(빈칸=sparse) | 가격표 단가블록(L1) | t_prc_price_components·t_prc_component_prices | 격자 빈칸 0(전 셀 충전) | 일부 셀 미적재(부분 계산) | 단가행 0행(PRICED-0 결함) |
| **D4 차원 충전** | use_dims ↔ 단가행 ↔ 권위 3원 일치(누락 차원=손님 선택불가) | 가격표 차원축(사이즈·자재·도수·수량구간) | component_prices.use_dims·차원행 | 3원 일치·누락 차원 0 | 차원 1개 부분 충전 | 권위 가격축이 라이브 use_dims에 없음 |
| **D5 계산 가능성 [키스톤]** | evaluate_price 실산출 PRICE≠0 + 권위 골든 정합(오차 0) | 권위 골든(엑셀/이전사이트 동조건) | `evaluate_price`/시뮬레이터 POST | 전 케이스 PRICE≠0 AND 골든 일치(money_delta=0) | PRICE≠0이나 골든 mismatch(조사신호) | PRICE=0(PRICED-0) 또는 골든 대비 저/과청구 |
| **D6 기초마스터 적재** | mat/siz/proc/clr 코드가 상품에 맞게 정합(공유 마스터) | 권위 코드 도메인 | t_mat_materials·t_siz_sizes·t_prc·기초코드 | 상품 BOM↔마스터 코드 정합 | 표시명/내부값 경미 불일치 | 코드 오매핑(다른 자재·치수 환원) |
| **D7 옵션 적재** | option_groups/options/option_items(택1/택N) 손님 선택축 | 권위 옵션성 속성 | t_prd_product_option_{groups,items} | 권위 요구 옵션축 전부 손님 선택 가능 | 옵션 일부만 등록 | 손님 선택 엔티티 부재(주문 불가축) |
| **D8 추가상품 템플릿** | product_addons/templates 묶음 | 권위 추가상품 | t_prd_product_addons·templates | 권위 요구 추가상품 묶음 적재 | 일부 누락 | always-add 가드 위반·미적재 |
| **D9 제약조건** | JSONLogic constraints(동시불가·min/max) | 권위 제약(사이즈→추가상품/박 min·max) | t_prd_product_constraints | 권위 요구 제약 전부 적재 | 일부 제약 누락 | 제약 부정합(잘못된 조합 허용) |
| **D10 판형 매핑 [HARD·종이류만]** | 종이류면 plate_sizes 정합 / 비종이=N/A | 상품마스터 출력용지규격 | t_prd_product_plate_sizes | 종이류 판형 정합(best-plate 매칭) | 판형 일부 미매핑 | 종이류인데 판형 미/오매핑(견적 0·[[transparent-postcard-price-fix-260629]]) |
| **D11 매핑 정합** | 오매핑·이중배선·고아·차원 미스매치·silent 합산 | 권위 차원 경계(시트 SOT) | formula_components 배선 전수 | silent 합산 0·차원 미스매치 0·오염 0 | 경미 오염 1건(가격 영향 미미) | 시트 밖 구성요소 silent 합산(돈크리티컬·[[bandtotal-x-qty-overcharge-260628]]) |

### 판정 규칙 보충
- **D5는 키스톤**: PRICE=0이면 상품은 사실상 견적 불가 → L3 진입 차단(아래 등급 사다리). 자동주입 없는 엔진 입력 그대로 채점(필수공정 `mand_proc_yn`·기본자재 `dflt_yn` 미주입)해 위젯/API 실제 경로 재현 — 엔진 갭이 점수로 스스로 드러남(SCORING-FRAMEWORK §1 G1/G2).
- **WARN = 절반 점수**(부분 크레딧). PASS=만점·WARN=0.5·FAIL=0·N/A=분모 제외.
- **차원 간 종속**: D2 FAIL이면 D3·D4·D5 자동 FAIL(공식 없으면 단가행·차원·계산 불가). D3 FAIL이면 D5 FAIL(단가행 0=PRICED-0). 평가는 D1→D11 순으로 진행하되 상위 FAIL이 하위를 cap.

---

## 2. 준비도 등급 사다리 L0~L4 (게이팅 마일스톤)

등급 = **이진 게이팅 차원**으로 결정(연속 완성률과 별개). 완성률(%)은 등급 안/사이의 미세 진척.

| 등급 | 정의 | 게이팅 조건 | 완성률 밴드(참고) |
|------|------|-------------|-------------------|
| **L0 미적재** | 상품/구성요소 없음 | D1 FAIL | 0~20% |
| **L1 구성요소만** | BOM 있으나 가격 미바인딩 | D1 PASS AND D2 FAIL | 20~40% |
| **L2 공식 바인딩(불완전)** | 공식 연결됐으나 단가행/차원 빈칸 → 계산 0/부분 | D2 PASS AND D5 ≠ PASS | 40~70% |
| **L3 계산 가능** | evaluate_price 정상·골든 정합 | **D5 PASS**(PRICE≠0 AND 골든 일치) | 70~90% |
| **L4 위젯 준비** | 옵션·제약·추가상품 적재 → 손님 선택→계산까지 | D5 PASS AND (D7~D9 of needed axes 충족) AND D10(종이류) PASS | 90~100% |

- **등급은 보수적**: 하나라도 게이팅 미달이면 그 아래 등급. 예: D5 PASS여도 손님이 못 고르는 needed 옵션축이 있으면 L3(주문 불가 cap·OC_score 이진 게이트 우선).
- **C트랙 플래그**: 엔진 코드결함(fn_calc_pansu 판수 과다·필수공정 자동주입 등)으로 데이터만으로 L4 불가한 상품은 `C트랙_blocked=Y` 명시 → "개발팀 배포 없이는 100% 불가"를 가시화(영원히 92% 무한꼬리 차단·SCORING-FRAMEWORK §4).

---

## 3. 완성률(%) 산정식

```
가중합 = Σ (차원 점수 × 차원 가중)        # PASS=1·WARN=0.5·FAIL=0
적용가중 = Σ (차원 가중)                   # N/A 차원 제외
완성률(%) = 가중합 / 적용가중 × 100
```

### 차원 가중 (합 100 — 가격계산 토대 70 / CPQ·주문 20 / 정합 10)

| 묶음 | 차원 | 가중 | 근거 |
|------|------|------|------|
| **가격계산 토대 (70)** | D1 구성요소 요건 | 10 | BOM이 모든 것의 입력 |
| | D2 가격공식 바인딩 | 12 | 공식 없으면 계산 자체 불가 |
| | D3 단가행 | 12 | 단가 0=PRICED-0 결함 |
| | D4 차원 충전 | 12 | 차원 누락=손님 선택불가/엔진 미환원 |
| | **D5 계산 가능성** | **16** | **키스톤·종단 검증의 자(최대 단일)** |
| | D6 기초마스터 | 8 | 공유 코드 정합 |
| **CPQ·주문 (20)** | D7 옵션 | 8 | 손님 선택축 |
| | D8 추가상품 템플릿 | 6 | 묶음 적재 |
| | D9 제약 | 6 | 동시불가·min/max |
| **정합 (10)** | D10 판형(종이류) | 4 | 종이류 한정(비종이 N/A→재정규화) |
| | D11 매핑 정합 | 6 | silent 합산=돈크리티컬 |

- **N/A 재정규화**: 비종이 상품은 D10(4) 제외 → 적용가중 96으로 나눔. 옵션/추가상품/제약을 권위가 요구 안 하면 D7~D9도 needed=N→N/A 제외. 단순상품(엽서 등)은 D7~D10이 대부분 N/A → 토대 6차원 중심으로 재정규화되어 가격 정확성에 집중.
- **완성률 vs 등급 = 상보**: 등급 = "어느 마일스톤까지 왔나"(이진), 완성률 = "그 안에서 몇 % 채웠나"(연속). 대시보드는 둘 다 표기.

---

## 4. 위젯 복잡도 클래스 (일정용·등급과 별개 축)

위젯/제약 구현 일정 산정용. **가격 모델**이 위젯 UX·구현 난이도를 결정([[price-model-decision-tree-sim-gate]]). 상품은 복수 클래스 보유 가능 — **지배 모델**이 주 클래스(일정 견적의 기준).

| 클래스 | 가격 모델 | 위젯 UX | 난이도 | 대표 |
|--------|-----------|---------|--------|------|
| **W-FIX 고정가 by-siz** | siz_cd별 고정단가 | 사이즈 드롭다운→고정가 | 낮음 | 스티커·고정가 굿즈 |
| **W-AREA 면적입력** | nonspec_yn=Y·가로×세로×면적격자 | 치수 입력→면적 계산(off-grid ceiling) | 중 | 아크릴·실사·현수막 |
| **W-CASCADE 옵션캐스케이드** | 원자합산(sizes→dosu→paper→weight→process) | 단계 의존 드롭다운 캐스케이드 | 중상 | 디지털인쇄·명함 |
| **W-SET 셋트조립** | t_prd_product_sets(구성원 합산+셋트공식) | 구성원 선택+수량(page-step) | 높음 | 책자·포토북·엽서북 |
| **W-ADDON addon템플릿** | product_addons/templates 가산 | 본체+부속 토글 | 중상 | 아크릴 키링(고리·볼체인)·각종 부속 |

- **★addon은 반드시 템플릿 모델**: opt_cd 가산형으로 짜면 라이브 미작동(PRICE 오염·[[addon-optcd-model-broken-live]]) → 위젯 클래스는 W-ADDON으로 강제.
- 복합 예: 아크릴 키링 = W-AREA(본체) + W-ADDON(고리) → 일정은 두 클래스 합산.

---

## 5. 재사용 커버리지 요약 (상세 = `reuse-evidence-map.csv`)

| 차원 | 주 재사용 산출물 | 라이브 실측 필요? |
|------|------------------|-------------------|
| D1 구성요소 요건 | §21 conformance-checklist(자재·공정·사이즈·도수·묶음수·페이지룰 축)·round-11 BOM | 보강(구조는 재사용·셀은 확인) |
| D2 공식 바인딩 | formula-block-map-260629·price-formula-master·batch CALC(UNBOUND 분류) | 부분(바인딩 존재는 batch가 확인) |
| D3 단가행 | §26 무결성(미적재 셀·sparse grid)·batch PRICED-0 | **필요**(셀 단위 라이브) |
| D4 차원 충전 | §26 무결성(차원 누락)·§13 engine-contract(use_dims 매칭) | **필요** |
| D5 계산 가능성 | **batch score_batch.py(CALC/PR)**·product-scoreboard·pr_score | **필수**(시뮬레이터 POST 실호출) |
| D6 기초마스터 | §21 checklist(자재/사이즈/도수 축)·basedata-dedup | 보강 |
| D7 옵션 | §21 checklist(옵션그룹·인쇄옵션 축)·OC_score | **필요**(gstack product-viewer/sim-meta) |
| D8 추가상품 템플릿 | §21 checklist(추가상품·템플릿 축) | 부분 |
| D9 제약 | §21 checklist(제약규칙 축) | 부분 |
| D10 판형 | §21 checklist(판형 축)·platesize 메모리 | **필요**(종이류 plate_sizes) |
| D11 매핑 정합 | batch R1 오염·§26 정합 불일치·conformance-oversplit-audit | **필요** |

→ **라이브 실측 필수 차원 = D5**(엔진 실호출). **권장 라이브 = D3·D4·D7·D10·D11**(셀/CPQ/판형/배선). **구조 재사용 가능 = D1·D2·D6·D8·D9**(다만 STALE 경고 하 확인).

---

## 6. STALE 경고
- **§21 conformance-checklist(2026-06-23)** = 존재 위주 스캐폴드(상품×축 needed 플래그). "누락 0의 자" 프레임으로는 유효하나 **셀 단위 라이브 값은 그 시점**. 적재가 그 후 변동(아크릴 R3 156셀·제본비 복원 등 다수 COMMIT) → evaluator가 D3·D4·D5는 batch 재실행으로 갱신. K6(HUNI_ADMIN_PW stale) 잔존.
- **product-scoreboard.csv(2026-06-28)** = 프리미엄엽서 등 일부만 채워진 초기본 → 전수 아님(evaluator가 batch로 확대).
- **§13 engine-contract(2026-06-18)** = **코드 파생이라 STABLE**(evaluate_price 알고리즘). 단 부록 A의 UNVERIFIED 항목은 라이브 확인 후 인용.
- **v03 마이그레이션·STALE 인용 금지**(round-13 진단 freshness 권위). 라이브 오적재(round-13)는 "현재값 vs 정답" 양면 표기.

## 7. 한계
- 본 루브릭은 **자(尺)**만 정의 — 실제 차원별 PASS/WARN/FAIL 채점은 evaluator가 batch·라이브로 수행. 완성률 가중은 **합리적 제안**(돈크리티컬 D5·D2·D3·D4 상위)이며 사용자 피드백으로 조정 가능.
- D7~D9(CPQ)·D10(판형) needed 판정은 권위 엑셀의 옵션성 속성 유무에 의존 — 권위가 모호한 상품은 evaluator가 도메인 렌즈로 needed 확정(§21 domain-lens 재사용).
- 위젯 클래스는 **현재 지배 모델** 기준 — 모델이 미확정(미바인딩)인 상품은 "TBD(설계 후 확정)"로 표기.
