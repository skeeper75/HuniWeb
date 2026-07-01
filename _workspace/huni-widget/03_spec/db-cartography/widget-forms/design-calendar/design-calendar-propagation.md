# design-calendar-propagation.md — 디자인 캘린더 동형 전파 (경량)

> 파이프라인 ③' 컨버전 선행 · 경량 전파(동형판정+델타+대표+갭, 전체 재유도 금지·코드 0줄).
> **지시 클래스** = C2(goods·단순+추가상품) 대비 전파.
> **외형 권위** = `docs/design/11가지상품옵션/product-design-calendar-option/Configurator.jsx`(185줄·5필드+addon — 사이즈·종이·페이지·제작수량·캘린더봉투 addon·트윈링제본·에디터 전용).
> **데이터 권위** = 라이브 스냅샷(`_foundation/live-snapshot/latest/`, 2026-07-01) + readiness 산출.
> **대표 명세(상속 후보)** = C2 `../goods/goods-form-spec.md`(PRD_000146 아크릴키링·구간할인+addon). ※ 부분 동형 — 사유 §1.
> **가격 권위** = 서버 `pricing.py:evaluate_price`(:394). PRICE=0=결함.
> 대표 상품 = **PRD_000108 탁상형캘린더** (캘린더군 데이터 최완비 baseline·자재 8종·인쇄 양면·공정 PROC_000076).
> ★ **주의: 캘린더군은 라이브 가격공식 미바인딩(PRICE=0·DESIGN_BLOCKED)** — 주문가능 차단(§5).

---

## 1. 동형 판정 — **C2 부분 동형 △ (addon축은 동형·가격모델·구간할인 깨짐)**

지시는 C2(goods) 전파. 라이브 캘린더군 실측 결과 **addon(캘린더봉투)·옵션 다값 선택축은 C2와 동형이나, 가격모델(구간할인 없음·공식 미바인딩)이 깨진다.** + 캘린더는 트윈링제본 책자(페이지 보유)라 C5 셋트 성격도 일부 겸한다.

### 1.1 C2(goods·PRD_000146) 동형 대조
| C2(goods·PRD_000146) 동형 기준 | design-calendar(PRD_000108 탁상형) 라이브 | 동형 |
|----------------------------------|--------------------------------------------|:---:|
| prd_typ = 완제품 단일 | PRD_TYPE.01 완제품 단일(셋트 아님·sets 0행) | ⭕ |
| 다값 옵션 선택축(사이즈·자재·인쇄) | ⭕ 사이즈 2종·자재 8종(MAT_000090 dflt 외)·인쇄 양면 | ⭕ |
| **추가상품 addon(볼체인)** | △ **캘린더봉투 addon** = 템플릿 존재(TMPL-000040/041)이나 **product_addons 미연결(0행)** | △ |
| **구간할인 Slider(DSC_*)** | ❌ 캘린더 discount 0행(DSC 없음). 디자인 폼도 구간할인 Slider 없음 | ❌(둘 다 없음·차이) |
| 가격모델 = evaluate_price(면적/단가 lookup·PRICE≠0) | ❌ **가격공식 미바인딩**(price_formulas 0행)·readiness pfm=DESIGN_BLOCKED·PRICE=0 | ❌ |
| editor/CTA | 둘 다 editor 측면 상이(146=PDF / 108=에디터 전용 디자인 JSX) | △ |
| 자재 클린(오염 제거됨) | ❌ **자재오염 잔존**(MAT_000252 삼각대·MAT_000253 링 = 부품·readiness mismapped WARN) | ❌ |

→ **C2 동형 3/7(부분).** addon 축·다값 선택축은 C2 매핑 규칙 상속 가능하나, **구간할인 없음·가격공식 미바인딩·자재오염·페이지(책자) 보유**로 C2 깨짐.

### 1.2 클래스 귀속 결론
design-calendar는 **C2 단독 동형이 아니다**. 실제 형상 = **C5(셋트조립·book) + C2(addon) 하이브리드의 미완성 형태**:
- 트윈링제본·페이지(14P/30P 디자인) = 책자(C5) 성격(단 라이브 캘린더는 셋트 미구성·page_rule 0행).
- 캘린더봉투 addon = C2(goods) addon 축.
- 가격모델은 **둘 다 미작동**(공식 미바인딩).

→ **동형 판정 = △ 부분(C2 addon/선택축만 상속).** book-form-spec(C5·페이지/제본) + goods-form-spec(C2·addon) 양쪽 매핑 규칙을 **부분 차용**. 단 **현 라이브 데이터로는 어느 클래스도 주문가능 미달**(가격공식·셋트·page_rule·addon연결 전부 미적재). **isomorphism-classes.md 갱신 권고: design-calendar = C5/C2 하이브리드·DESIGN_BLOCKED(주문가능화 전 대량 (C) 선행).**

---

## 2. 그룹 델타 — C2 대표(146)에 없는/다른 옵션만 추가 매핑

| 델타 항목 | design-calendar 라이브(108 또는 디자인) | 계약 필드 | componentType | DB 출처 | C2(146) 대비 |
|----------|------------------------------------------|-----------|---------------|---------|--------------|
| **페이지(page-counter)** | 디자인 14P(7개월)/30P(13개월) 2택 · 라이브 page_rule **0행** | `OptionGroup`(2값) 또는 `page-counter-input` | option-button / page-counter-input | **부재**(page_rules 0행) — (C) | **신규 델타** — 146엔 페이지 없음. C5 book의 page-counter 규칙 차용. 라이브 미적재(C) |
| **종이(자재 select)** | 디자인 스노우200/몽블랑190/랑데뷰250(+5천) · 라이브 자재 8종 | `OptionGroup(multiple=false)` | `select-box` | product_materials ⋈ mat_materials | 변이 — 146은 투명아크릴 2종, 108은 종이류 8종(★오염 MAT_000252/253 섞임·C) |
| **캘린더봉투 addon** | 디자인 봉투 240x230 10장 +1,100원 + 수량(1/2/3) · 라이브 TMPL-000040(240x230)/041(150x310) | addon `select-box` + 수량 `counter-input` | select-box | t_prd_templates(TMPL-000040/041) — **product_addons 미연결**(C) | 변이 — 146 볼체인(TMPL-000018)과 동형 경로(W-ADDON)이나 **연결 끊김**(C) + 수량 파라미터 부재(GAP-PARAM·146과 동일) |
| 사이즈 | 디자인 220x145/130x220 2종 · 라이브 108=SIZ_000069/070 2종 | `OptionGroup` | option-button | product_sizes ⋈ siz_sizes | 동형(직매핑·단 디자인≠DB 치수) |
| 제작수량 | 디자인 min10/step10/max2000 · 라이브 min1/max10000/incr1 | InputSpec | counter-input | products qty | 동형(★디자인≠DB·DB 권위) |
| 제본(트윈링) | 디자인 "고리형트윈링제본" 고정 표시 · 라이브 PROC_000076(108 공정·mand_proc_yn=N) | hidden/summary | finish-button/hidden | product_processes | 변이 — 146엔 제본 없음. 캘린더=링제본 고정(손님 미선택·어댑터 자동 또는 표시) |
| (146에 있던) 구간할인 Slider | **없음**(캘린더 DSC 0행·디자인도 없음) | — | — | — | **델타 음수** — 캘린더는 구간할인 없음 |
| 에디터 CTA | 디자인 "에디터로 디자인하기" 단독 · 라이브 editor_yn=Y | `cta.designEditor` | — | editor_yn | 변이 — 146은 PDF, 108은 에디터 전용 |

**델타 요약:** 146 대비 **추가 3(페이지·종이select·캘린더봉투 다른 템플릿)·제거 1(구간할인)·변이 다수**. 페이지·캘린더봉투 연결·종이오염은 전부 **(C) DB 미적재/오적재** — 어댑터 흡수 불가(데이터 부재). 계약 슬롯은 전부 기보유(page-counter-input·select-box·addon).

---

## 3. 라이브 대표 상품 — PRD_000108 탁상형캘린더 (캘린더군 최완비, 단 BLOCKED)

라이브에 "디자인 캘린더" 명칭 상품 **부재**. 캘린더군 = 108 탁상형/109 미니탁상/110 엽서/111 벽걸이/112 와이드벽걸이(전부 코드 007-000X). 데이터 완비도(readiness):
- 108 탁상형 = **L1 33.0%**·자재 8종·인쇄 양면·공정 PROC_000076 — 캘린더군 중 자재/구성 최완비 → 대표.
- 전 캘린더 `pfm=DESIGN_BLOCKED`·`calc=UNBOUND-PRICE-IN-SHEET`(공식 미바인딩·견적 불가).

**라이브 실측 PRD_000108(스냅샷 2026-07-01):**
```
PRD_000108 탁상형캘린더 (PRD_TYPE.01 완제품·단일·editor_yn=Y·min1/max10000/incr1·QTY_UNIT.01 개)
sizes(2): SIZ_000069 / SIZ_000070
materials(8·USAGE.07): MAT_000090(dflt)·113·114·115·116·123·127 + ★MAT_000252(삼각대싸바리·부품오염)·253(링·부품오염)
print(1): POPT_000002 양면(CLR_000005) · processes(1): PROC_000076(mand_proc_yn=N)
price_formula: 0행(미바인딩) · option_groups: 0행 · page_rule: 0행 · constraints: 0행 · addons: 0행
캘린더봉투 템플릿: TMPL-000040(240x230 10장)·041(150x310 10장) — PRD_000005 캘린더봉투(기성)·product_addons 미연결
```

---

## 4. evaluate_price 골든 (PRICE≠0) — ❌ **재현 불가 (BLOCKED)**

캘린더군은 **가격공식 미바인딩**(price_formulas 0행)이라 evaluate_price가 매칭할 공식·단가행이 없다 → **PRICE=0(견적 불가)**.

| 케이스 | 결과 |
|--------|------|
| 108 탁상형·기본·1개 | **PRICE=0** — frm 미바인딩·`calc=UNBOUND-PRICE-IN-SHEET`·readiness `DESIGN_BLOCKED`(§18 정찰가 역산 비정수 의도적 보류) |

❌ **PRICE≠0 게이트 미통과(BLOCKED).** [HARD] PRICE=0=결함 신호. 캘린더 가격공식 설계(§18)→적재(§7) 선행 없이는 골든 도출 불가. **이는 라이브 기존 상태(신규 회귀 아님)**이며 §18에서 "정찰가 역산 비정수→의도적 BLOCKED 보류"로 식별됨. 디자인 폼의 가격(75,000 더미)은 가짜식·폐기.

> 대표 PRICE 값 = **0(BLOCKED)**. C2 goods(146·PRICE≠0 2,700~1,020,000)와 결정적으로 다름 — 캘린더는 가격 자체가 미작동.

---

## 5. 갭 (A)/(B)/(C) + 주문가능 4조건

### 5.1 갭 집계
- **(A) 어댑터 흡수 — 계약/위젯 무변경 (5)**: A1 사이즈/수량 직매핑(디자인≠DB→DB 권위)·A2 자재 select-box(오염 제외 후)·A3 트윈링제본 자동/표시(손님 미선택)·A4 에디터 CTA(editor_yn=Y)·A5 캘린더봉투 addon 토글→수량 visible(addon 연결 후·VisibilityRule·146 동형).
- **(B) 계약 변경 필요 (0)**: 위젯 계약(page-counter-input·select-box·addon·OptionGroup·counter-input·cta.designEditor)이 캘린더 폼을 **전부 기존 슬롯 수용** → 0건. 페이지·addon 모두 기보유 슬롯.
- **(C) DB 작성·교정 — §18/§7 인간 승인 (6·대량)**:
  - **C-1 가격공식 미바인딩** (🔴 돈크리티컬·차단): 캘린더 5상품 PRF 0행·단가행 0 → PRICE=0. §18 캘린더 가격공식 설계(정찰가 역산 BLOCKED 해소)→§7 적재 필수. **주문가능 최대 병목**.
  - **C-2 페이지 page_rule 미적재** (🔴): 디자인 14P/30P 분기 = page_rules 0행. 캘린더=월별 페이지(7개월/13개월) → page_rule 또는 옵션그룹 적재.
  - **C-3 캘린더봉투 addon 미연결** (🟡): TMPL-000040/041 존재하나 product_addons에 캘린더 상품 연결 0행 + addon 수량 파라미터 부재(GAP-PARAM·146과 동일).
  - **C-4 자재오염** (🔴 돈크리티컬): MAT_000252 삼각대·MAT_000253 링 = 부품(MAT_TYPE)이 종이 자재축에 오적재(readiness mismapped WARN·[[goods-material-contamination-260630]] 유형). 삼각대/링 = addon화 또는 제거. 146(아크릴키링 고리 제거 완료)와 동일 패턴 미교정분.
  - **C-5 종이/인쇄 옵션그룹 미생성** (🟡): 디자인 "종이 select" = product_materials는 있으나 option_groups 미생성(자재 직접 vs CPQ 그룹 결정).
  - **C-6 셋트 미구성 검토** (🟡): 트윈링제본 책자=잠재 셋트(표지/내지)이나 라이브 단일상품. C5 셋트로 갈지 단일 가격공식으로 갈지 §18/§23 설계 결정.

### 5.2 주문가능 4조건 (PRD_000108 현재)
| 조건 | 충족 | 근거 |
|------|:--:|------|
| ⓐ 옵션 라이브 구동 | **부분** | 사이즈·자재·인쇄·수량 라이브 구동 ✅ / 페이지·캘린더봉투 addon·종이옵션그룹 미적재(C) ❌ / 자재오염(삼각대·링) ⚠ |
| ⓑ 제약 6종 강제 | **부분** | ⑥필수·④size·②quantity 강제 ✅ / page_rule·addon토글·택1 옵션그룹 미적재(C) ❌ |
| ⓒ PRICE≠0 | **미충족(BLOCKED)** | 가격공식 미바인딩·PRICE=0 ❌ — **결함 신호·주문 불가** |
| ⓓ 유효 페이로드 | **부분** | 사이즈/자재/수량 페이로드 조립 가능하나 가격 0·페이지/addon 누락으로 불완전 |

**판정: 주문 불가(NOT ORDER-CAPABLE·BLOCKED).** C2 goods(146·PARTIAL·PRICE≠0)와 달리 **캘린더는 가격공식 자체가 미바인딩(PRICE=0)** + 페이지·addon·자재오염 미교정 → 주문가능 미달. 위젯/계약/어댑터는 준비 완료(B 0건)이나 **DB (C) 6건(돈크리티컬 3: 가격공식·페이지·자재오염) 선행 필수**. 동형 전파의 가치 = "캘린더가 C2처럼 보이나 라이브는 미완성"임을 정직 적발한 것.

**다음 권고:** ① §18 캘린더 가격공식 설계(정찰가 역산 BLOCKED 해소·트윈링제본 단가) → §7 적재(C-1) → ② page_rule/옵션그룹 적재(C-2·C-5) → ③ 자재오염 정리(삼각대/링 addon화·C-4·146 패턴 재사용) → ④ 캘린더봉투 product_addons 연결+수량(C-3) → ⑤ 적재 후 어댑터 재조립+골든 hw-qa. **현 단계 주문가능화 전 §18/§7/§23 대량 선행** — C2 goods 형제(146)와 달리 즉시 주문가능 아님. 코드 구현은 (C) 해소+승인 후.
