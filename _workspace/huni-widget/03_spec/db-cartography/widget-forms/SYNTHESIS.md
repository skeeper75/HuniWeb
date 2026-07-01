# SYNTHESIS.md — 5 복잡도 클래스 위젯 폼 종단 명세 종합 + 통합 (C) DB 백로그

> 입력: 11 Figma 상품군 폼 → 5 복잡도 클래스 대표 종단 명세(폼-계약-DB-제약-가격-주문).
> 각 클래스 명세: `widget-forms/<class>/<group>-form-spec.md`. 접근 분석: `widget-forms-approach.md`.
> [HARD] 분석·명세까지. 실 적재/구현은 사용자 승인 후(§7 dbmap / 04_build).

---

## 0. 한 줄 결론

**위젯 코어·정규화 계약·어댑터는 5개 복잡도 클래스 전부를 변경 0으로 수용한다((B)=0). 주문가능화의 유일한 병목은 라이브 DB 쪽 (C) — CPQ 옵션·제약 데이터 미적재 + 데이터 결함(자재 오염·인쇄비 0·sparse grid).** 2클래스는 이미 주문가능, 3클래스는 (C) 선행.

---

## 1. 클래스별 결과 매트릭스

| 클래스 | 대표 상품 | 주문가능 | (A) 어댑터 | (B) 계약 | (C) DB | 가격 골든(PRICE≠0) |
|--------|----------|:---:|:---:|:---:|:---:|------|
| **C1 고정가-단순** (accessories) | PRD_000055 낱장 스티커 | ✅ **ORDER-CAPABLE** | 9 | **0** | **0** | 4,000~16,000 (단가형) |
| **C2 단순+추가상품** (goods) | PRD_000146 아크릴키링¹ | △ PARTIAL | 10 | 0 | 7 | 2,700~1,020,000 (구간할인) |
| **C3 면적입력** (arrylic) | PRD_000146 아크릴키링¹ | △ PARTIAL | 10 | 0 | 6 | 면적격자 3,840~6,900/단위 |
| **C4 캐스케이드+박** (print) | PRD_000042 프리미엄쿠폰 | △ PARTIAL | 12 | 0 | 11+ | 307~12,814 (⚠인쇄비0) |
| **C5 셋트조립** (book) | PRD_000069 무선책자 | ✅ **ORDER-CAPABLE** | 15 | 0~1 | 8 | 138,688 (evaluate_set_price·이중합산0) |
| **합계** | | **2 ✅ / 3 △** | 56 | **0~1** | **32+** | 전 클래스 PRICE≠0 통과 |

¹ C2 goods·C3 arrylic 대표가 PRD_000146으로 겹침(아크릴이 두 성격 겸함). C2는 Slider/추가상품, C3는 면적입력 초점이라 명세는 유효하나, **더 깨끗한 C2 대표는 비면적 굿즈(예: 키링류 외 패드/문구굿즈) 권장** — 동형 전파 시 재선정.

---

## 2. 횡단 결론 (5클래스 공통)

### ★ (B) 위젯 계약 변경 = 0 (전 클래스)
정규화 계약(`data-contract.md` + `04_build/src/contract`)이 5개 복잡도 클래스를 **이미 전부 표현**한다:
- 14 componentType로 모든 폼 렌더(신규 0). area-input·page-counter-input·color-chip·finish-button·counter-input·option-button·select-box 등 기존 슬롯.
- **Slider(조각수·볼체인·구간할인)** = 신규 componentType 불요 → `summary`/`price-slider`(read-only) 어댑터 흡수. 입력축 아님(서버가 qty 기반 자동 할인).
- **면별(C5 표지/내지/면지/투명커버)** = 기존 `ProductSide[default,inner]` + §23 set-product 모델. evaluate_set_price 이중합산 0.
- **area-input(C3)·colorHex(박색·삼각대)·VisibilityRule(박 토글)·InputSpec.axis2(범위)** 모두 계약 기보유.
→ **위젯/어댑터는 준비 완료.** 주문가능화는 "위젯 만들기"가 아니라 "DB 채우기".

### ★ 병목 = (C) DB 작성·교정 32+건 (통합 백로그 §3)
모든 PARTIAL의 원인은 동일: **가격공식엔 단가행이 있는데 CPQ 옵션그룹·제약이 라이브에 미생성** → 위젯이 고를 수단이 없음. + 데이터 결함.

### ★ 가격 = evaluate_price 서버 권위, 전 클래스 PRICE≠0
디자인 가짜 계산식 전부 폐기. 단가형(C1)·구간할인(C2)·면적격자(C3)·캐스케이드(C4)·셋트(C5 evaluate_set_price) 모두 라이브 엔진 골든 PRICE≠0 확인. ⚠ 결함: C4 인쇄비0(PROC_000004 미충전)·C3 sparse grid 홀·C2/C3 자재 오염.

---

## 3. 통합 (C) DB 백로그 — §7 dbmap 인간 승인 트랙 (우선순위)

| # | 항목 | 클래스 | 유형 | 돈크리티컬 |
|---|------|--------|------|:---:|
| C-1 | 종이 자재 오염(OPT_000056 8종 중 5종 비종이 굿즈자재) | C4 | 오교정 | 🔴 |
| C-2 | 인쇄비 0 — base 공정 PROC_000004 단가행 미충전 | C4 | 결함교정 | 🔴 |
| C-3 | 아크릴 자재 활성정합(3mm vs 1.5mm)·156셀 면적격자 미적재(§26) | C2/C3 | 결함교정 | 🔴 |
| C-4 | 별색5·코팅·커팅·접지 CPQ 옵션그룹 생성 | C4 | 옵션적재 | |
| C-5 | 박(앞/뒤) on-off·크기·칼라 CPQ + 제약 | C4/C5 | 옵션+제약 | |
| C-6 | 봉투·볼체인 추가상품 템플릿 del_yn=Y 복원 + 수량 파라미터 | C2/C4 | 복원 | |
| C-7 | 조각수 CPQ 옵션그룹 미적재 | C2/C3 | 옵션적재 | |
| C-8 | colorHex 컬럼 적용(added-schema-260701.sql §7 적용) | C2/C4/C5 | 스키마 | |
| C-9 | 제본방식(상철/링/중철/PUR) 멀티상품 폼 전략 + 투명커버·면지 | C5 | 설계+옵션 | |
| C-10 | 후가공 개수 파라미터(오시/미싱/가변 줄수)·형압크기 GAP-PARAM | C4/C5 | 옵션적재 | |
| C-11 | editor_yn 라이브↔디자인 불일치 정합 | 전 | 정합 | |

→ 돈크리티컬 3건(C-1·C-2·C-3) 우선. 전부 §7 dbmap / §26 무결성 트랙 인간 승인. 일부(C-1·C-2·C-3)는 §27 가격 종단 파이프라인에 이미 식별됨(중복 처리 회피).

---

## 4. 권고 진행 순서

1. **즉시 주문가능 2클래스 입증** — C1 accessories·C5 book(069 무선)은 (C) 없이 주문가능. 04_build 어댑터 구현으로 **end-to-end 주문 파이프 최초 입증**(가장 빠른 가치).
2. **돈크리티컬 (C-1·C-2·C-3) §7 교정** — 자재 오염·인쇄비0·아크릴 격자. 저청구/오과금 직결.
3. **CPQ 옵션 적재 (C-4~C-10)** — print/goods/arrylic 풀스펙 주문가능화. §7 dbmap.
4. **동형 전파** — 5 대표 → 나머지 6 상품군(photobook→C1·calendar/sticker→C4·signposter→C3·stationery/design-calendar→C5/C2). 매핑 규칙만 전파.

---

## 5-bis. 전 11 상품군 동형 전파 결과 (full · 라이브 권위 정정 포함)

5 대표 + 6 전파 = 전 11 상품군. 라이브 실측이 디자인-추정 클래스를 정정함(라이브 권위):

| 상품군 | 디자인 추정 | **라이브 권위 클래스** | 주문가능 | 대표 prd_cd | 가격 |
|--------|:---:|:---:|:---:|---|------|
| accessories | C1 | C1 고정가 | ✅ | PRD_000055 | 단가형 ≠0 |
| **photobook** | C1 | **C5 셋트** (정정) | ✅ 조건부 | PRD_000100 | set ≠0(이중합산검증1) |
| signposter | C3 | C3 면적(합가) | ✅ | PRD_000138 | 합가격자 ≠0 |
| book | C5 | C5 셋트 | ✅ | PRD_000069 | set 138,688 |
| goods | C2 | C2 추가상품 | △ | PRD_000146¹ | 구간할인 ≠0 |
| arrylic | C3 | C3 면적 | △ | PRD_000146¹ | 면적격자 ≠0 |
| print | C4 | C4 캐스케이드 | △ | PRD_000042 | ≠0(⚠인쇄비0) |
| sticker | C4 | C4 고정가by-siz | △ | PRD_000052 | 단가표 ≠0(ref_key1 함정) |
| **stationery** | C5 | **C5+C1 하이브리드** (정정) | △ | PRD_000097셋트+178단일 | set ≠0·이중합산0 |
| **calendar** | C4 | **C4 BLOCKED** 🔴 | ❌ | PRD_000108 | **PRICE=0 가격공식미설계** |
| **design-calendar** | C2 | **C5/C2 BLOCKED** 🔴 | ❌ | PRD_000108계열 | **PRICE=0 가격공식미설계** |

¹ goods·arrylic 대표 겹침(아크릴키링) — goods는 비면적 굿즈로 재선정 권장.

### 3-tier 병목 (주문가능화 우선순위)
- **TIER-0 BLOCKED — 가격공식 미설계 (2)**: calendar·design-calendar. `pfm=DESIGN_BLOCKED`·product_price_formulas 0행 → PRICE=0. **§18 가격공식 설계 선행**(calendar 형제 108~112 공통)→§7 적재. 가장 심각(위젯 이전에 가격이 없음).
- **TIER-1 PARTIAL — CPQ 옵션 미적재 (5)**: goods·arrylic·print·sticker·stationery. 가격공식·단가행은 있으나 CPQ 옵션그룹/제약 미생성 → §7 dbmap 적재. + 돈크리티컬 결함(자재오염·인쇄비0·156셀).
- **TIER-2 ORDER-CAPABLE — 즉시 (4)**: accessories·book(069)·photobook(조건부)·signposter. (C) 없이/최소로 주문가능 → 04_build 어댑터 구현으로 즉시 입증.

### 정정 사항 (라이브 권위)
- **photobook = C5 셋트**(C1 아님): PRD_000100 부모 7구성원·evaluate_set_price. set-product(2026-06-28) "BLOCKED·comp0행" 보고는 **STALE**(§18/§7 적재완료).
- **stationery directive 정정**: 문구폼 직대응은 **단일상품**(178 스프링수첩=evaluate_price 고정가), 셋트는 떡메모지 097(완제품 부모+member1, book 면별2와 다름). 어댑터 단일arm+셋트arm 분기 필요.
- **calendar 류 BLOCKED**: 전 형제 L1·가격공식 미바인딩 → §18 달력 가격공식 설계가 클래스 선행.
- **(B) 위젯 계약 변경 = 0 — 전 11 상품군 유지.**

## 5. 미해결/확인 (다음 세션)

- C2 대표 PRD_000146 겹침 → 비면적 굿즈로 재선정(동형 전파 시).
- C5 제본방식 멀티상품 폼: 단일상품 비노출(가) vs 상품스위처(나) — hw-architect 결정(유일한 잠재 (B)).
- 11 디자인 상품군 ↔ 라이브 상품군 ↔ §29 클래스 1:1 정합 최종 확인(부록 대상).
- added-schema-260701.sql 실재 확인됨(앞선 에이전트 "부재" 보고는 경로 혼동·정상 존재).
