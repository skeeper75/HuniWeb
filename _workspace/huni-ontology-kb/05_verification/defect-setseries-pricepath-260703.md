# 결함 보드 — 셋트 계열 Phase4 적대검증 · 축3 가격 경로 연결 완전성 (상품→가격)

> 검증자: okb-adversarial-verifier (생성≠검증) · 2026-07-03 · 축: **가격 경로 연결 완전성(product→priced_by→formula→has_component→component→단가행)**
> 원칙: 생성자 주장 비신뢰 · 직접 재실측(live-snapshot awk + cal_golden.py **라이브 실호출** + component_prices 실측) · 라이브 읽기전용.
> 범위: 셋트 부모 10(068/069/070/072/077/082/088/094/097/100) + 구성원 반제품 + 캘린더 5(108~112·단품).

## 판정 요약
- **High 0 · Medium 1 · Low 0** (격리 8건은 builder 교정 대상 아님·정직 표기 확인).
- 가격 경로는 **구조적으로 완전**: 10 부모 전부 priced_by→formula→has_component 사슬 무결·live 바인딩 정합·전 set-formula 구성요소가 실 component_prices 행으로 해소(silent-0 없음).

---

## 재실측 증거 (verified·결함 아님)

### E1. 부모 priced_by 사슬 = live 정합
graph priced_by → live `t_prd_product_price_formulas` 대조 전건 일치:
068→PRF_BIND_SUM · 069→PRF_BIND_MUSEON · 070→PRF_BIND_PUR · 072/077→PRF_HC_MUSEON_SET · 082→PRF_HC_TWINRING_SET · 088→PRF_LEATHER_RINGBINDER_SET · 094→PRF_PCB_FIXED · 097→PRF_TTEOKME_FIXED · 100→PRF_PHOTOBOOK_FIXED. {awk t_prd_product_price_formulas.csv}

### E2. set-formula 구성요소 → 실 단가행 해소 (silent-0 없음)
`t_prc_formula_components`(frm_cd) → `t_prc_component_prices`(comp_cd) 실측 행수:
COVERBIND 6 · HC_TWINRING 6 · JUNGCHEOL/MUSEON/PUR 8 · PCB_S1_20P/S1_30P/S2_20P/S2_30P 각 117 · TTEOKME 112 · PHOTOBOOK_BASE 11. 전부 >0 = 끊긴 가격 사슬 없음.

### E3. 면지 무가격(기여0) 정직 = live 실측 일치
면지 멤버 074/079/084/090 = `t_prd_product_prices` **0행** {grep}. KB "component_prices 0행·골든 무손상" 주장 확증. D링 자재(MAT_247/248/249 USAGE.07) 불가침 보존 배선 확인.

### E4. ★캘린더 5 = 라이브 실호출 독립 재계산 (cal_golden.py 직접 실행)
`lib_huni.HuniSim.simulate(...100부...)` 재실행값 = KB 노드 주장값 **전건 오차0**:
| prd | KB 주장 | 재실측(live) | 판정 |
|---|---|---|---|
| 108 | 271,555 | 271,555 | ✅ PRICE≠0 |
| 109 | 197,660 | 197,660 | ✅ |
| 110 | 21,555 | 21,555 | ✅(제본없음 인쇄+용지) |
| 111 | 231,032 | 231,032 | ✅ |
| 112 | 261,922 | 261,922 | ✅ |
캘린더 has_member 엣지 **0**(단품 완제품·셋트 아님) 확인. 110→PRF_DGP_INNER live 바인딩 정합.

### E5. 셋트 골든 양면 표기 정직 (set-price-full-diagnosis §3 대조)
094=450,000 · 097=135,000 · 100=1,500,000 = 진단 §3 실호출값 일치. 노드는 **엔진골든=가격사실 / 화면0원=코드 C트랙(gap-set-simulate-sizcd)**으로 분리·badge=verified 정당. 072/077/088 동일 796,900 = COVERBIND(use_dims=[min_qty]·자재무종속) 공유 component의 **예상된 동값**(레더 델타 C트랙·기 GAP).

### E6. 양면/GAP 격리 정직 (builder 교정 대상 아님)
- 088: `pending_authority_value` 1,800,000이 **현재값으로 오기 안 됨**(현재값 796,900·gap-set-088-redesign-pending 별도). ✅
- 069/070: 활성 priced_by=base(PRF_BIND_MUSEON/PUR)·_FOIL은 candidate gap(gap-set-069-070-foil). ✅
- 071: product 노드 없음·gap-071-set-notmembered만 존재(팬텀 가격 없음). ✅
- design-calendar 고정가·내지 페이지단가·인쇄면지비 = 각 gap 노드(가격 있는 것처럼 넣지 않음). ✅
- 은퇴 구성원(075/076/085/086/087/091/092/093) 노드 미생성·has_member 미참조. ✅

---

## 결함

### [M-1·Medium·PLAUSIBLE] 고정가형 구성원 095/096/098 = 부모공식 priced_by (live 미바인딩·동형 패턴 이탈)
- **노드:** product-095-postcard-book-inner · product-096-postcard-book-cover · product-098-tteok-memo-inner
- **유형:** 가격경로 모델링 불일치 (not-live-backed edge + isomorphism divergence)
- **증거:**
  - graph: `095 priced_by PRF_PCB_FIXED` · `096 priced_by PRF_PCB_FIXED` · `098 priced_by PRF_TTEOKME_FIXED`.
  - live 재실측: `awk t_prd_product_price_formulas.csv` → 095/096/098 = **바인딩 0행(NONE)**. 부모 all-in이 흡수하므로 live는 의도적으로 구성원 미바인딩(자식 분리 금지·pack §3.10).
  - 동형 대조: 같은 "부모 통가에 흡수·기여0" 상황인 073(표지)/074·104(면지)는 **derived_from 부모**로 모델링. 095/096/098만 priced_by 부모공식 = 상충.
- **영향(돈 아님):** 역방향 그래프 질의 "priced_by PRF_PCB_FIXED?" → 094+095+096 반환(3중 청구처럼 보임). 값 오류 없음(엔진은 부모 094 바인딩만 사용·골든 450k 정합). 노드 산문은 "부모 all-in 안 결정의 정직표기·O5 충족"으로 방어 — 설계 판단 여지 있음(PLAUSIBLE).
- **교정안:** 095/096/098 `priced_by 부모FIXED` → `derived_from 부모`(073/074/104 동형)로 통일. O5는 derived_from으로도 충족. 또는 architect 명시 규칙(고정가형 구성원 표현 규약) 확정.
- **라우팅:** builder(Stage C2 배선 교정) / architect(규약 확정). **격리 아님 — builder 교정 가능.**

---

## 격리(Isolation·builder 교정 대상 아님)
088-redesign pending 승인대기 · 069/070 _FOIL 정본화(인간승인) · 094/097/100 화면0원 siz_cd 미전파(코드 C트랙) · 068~070 코팅드롭·S1/S2 이중합산(엔진 C트랙) · 071 cover_mult×2(dev) · 레더델타 COVERBIND use_dims 한계(엔진) · design-calendar 고정가 미적재(실무진) — 전부 gap/양면 노드로 정직 표기 확인.

## 종합
가격 경로 연결 완전성 = **구조 무결·값 정직**. 유일 builder 결함 = M-1(고정가형 구성원 priced_by 방식 불일치·Medium·비돈영향). 나머지는 격리 정직 표기 정합.
