# widget-forms-approach.md — 11 상품군 위젯 폼 ↔ 주문가능화 접근 분석

> 입력: `docs/design/11가지상품옵션/`(Figma 원본 기반 11 상품군 Configurator.jsx + 공유 디자인시스템 `_ds/`).
> 목적: 각 상품군 위젯의 형태를 확인하고, **고객이 상품별 제약조건을 토대로 주문 가능한 형태**를 만드는 접근을 정의.
> 연계: 본 분석은 `db-cartography/`(라이브 DB→정규화 계약 매핑)·`04_build`(동작 위젯 엔진)·data-contract 위에 선다.
> [HARD] 분석·접근 정의까지. 실제 구현/적재는 사용자 승인 후.

---

## 0. 이 11개 파일이 무엇인가 (정확히)

11개 `product-*-option/Configurator.jsx`는 **Figma `huni_product_option.fig`에서 재구성한 디자인 프로토타입**이다(`_ds/.../readme.md` 확인). 즉 **후니 위젯의 시각·UI 정본**이지만, 3가지가 "동작/주문"과 분리돼 있다:

| 측면 | 현재 프로토타입 상태 | 주문가능화에 필요한 전환 |
|------|---------------------|------------------------|
| **옵션 데이터** | 하드코딩 배열(`사이즈 7종`·`종이 5종` 등 JSX 리터럴) | 라이브 DB 구동 → `db-cartography` 매핑으로 `t_prd_product_*`에서 |
| **가격** | 가짜 로컬 계산식(`printCost = (sizeBase+paperAdd)*qty/20`·`finishCost 25000` 등) | 서버 권위 `evaluate_price` 결과만(불투명) — 가짜식 폐기 |
| **제약조건** | JSX 조건문에 묻힘(`bindDir==="top" && 링컬러`·`foilFrontOn==="on" && 박크기`·`spotOpts none/single/double`·placeholder `가로 30~125mm`) | **정규화 제약(`NormalizedConstraints`)으로 추출** → 기존 캐스케이드 엔진 구동 |

핵심: **외형(디자인)은 정본, 동작(데이터·가격·제약)은 미결**. 프로토타입의 제약은 "디자이너가 의도한 규칙"이고, 이를 데이터로 환원해야 고객이 잘못 주문할 수 없는 폼이 된다.

---

## 1. 세 자산의 수렴 (이미 가진 것 + 이 11개)

주문가능 위젯 = 세 자산의 결합이며, 셋 다 이미 하네스 안에 있다:

```
① 04_build 위젯 엔진      = 14 componentType + 캐스케이드 엔진 + 정규화 계약 + 어댑터  (동작 검증 GO)
② db-cartography 매핑      = 라이브 DB(t_prd_*·t_prc_*·CPQ·evaluate_price) → 정규화 계약  (방금 산출)
③ 이 11개 Figma 폼         = 후니 외형 + 상품군별 옵션·제약 인벤토리                    (← 이번 입력)
```

→ **주문가능화 = ③의 외형·제약을 ②의 데이터로 채워 ①의 엔진에 태운다.** ③은 hw-design-fidelity(§6 Phase 6 시각재현)의 정본이자, 상품별 제약 추출의 원천.

---

## 2. 11 상품군 폼 인벤토리 + 복잡도 분류

전수 추출(옵션 라벨·컴포넌트·조건부 제약 수):

| 상품군 | 옵션 필드 | 핵심 컴포넌트 | 제약(조건부) | 복잡도 클래스 |
|--------|----------|--------------|:---:|------|
| accessories 악세사리 | 사이즈·수량 | OptionButton·Stepper | 0 | **C1 고정가-단순** |
| photobook 포토북 | 사이즈·커버타입·제작수량 | OptionButton | 0 | **C1 고정가-단순** |
| design-calendar 디자인캘린더 | 사이즈·종이·페이지·수량·캘린더봉투 | Select·Stepper | 3 | **C2 단순+추가상품** |
| goods 굿즈 | 사이즈·옵션·가공·수량·볼체인 | Select·**Slider**·Stepper | 2 | **C2 단순+추가상품** |
| stationery 문구 | 사이즈·내지·종이·제본옵션·링컬러·수량·개별포장 | OptionButton·**Slider** | 4 | **C5 셋트조립(제본)** |
| signposter 실사/사인 | 사이즈·**직접입력**·소재·별색화이트·코팅·가공·추가·수량 | **TextField(area)**·OptionButton | 2 | **C3 면적입력** |
| arrylic 아크릴 | 사이즈·**크기직접입력**·소재·조각수·가공·수량·볼체인 | **TextField(area)**·**Slider**×2 | 2 | **C3 면적입력** |
| calendar 캘린더 | 사이즈·종이·인쇄·장수·삼각대컬러·캘린더가공·링컬러·수량·개별포장·캘린더봉투 | **ColorChip**×5·Select | 10 | **C4 캐스케이드+추가** |
| sticker 스티커 | 사이즈·종이·인쇄·별색화이트·커팅·조각수·수량·후가공(귀돌이·오시·미싱·가변텍스트·가변이미지) | **FinishSection**·OptionButton×9 | 2 | **C4 캐스케이드+후가공** |
| print 디지털인쇄 | 27필드(별색5·코팅·커팅·접지·건수·제작수량·후가공5·박앞뒤·형압·봉투) | FinishSection×2·OptionButton×18·**ColorChip**·**TextField**×6 | 7 | **C4 최대 — 캐스케이드+박+추가** |
| book 책자 | 20필드(제본·제본방향·링컬러·링선택·면지·내지[종이·인쇄·페이지]·표지[종이·인쇄·코팅]·투명커버·박·형압·개별포장) | FinishSection·ColorChip·TextField×4 | 16 | **C5 셋트조립(면별) — 최대 제약** |

**5개 복잡도 클래스(주문가능화 동형 단위):**
- **C1 고정가-단순** (accessories, photobook): 사이즈+수량만. 제약 0. 가장 쉬움.
- **C2 단순+추가상품** (design-calendar, goods): + 추가상품(봉투)·Slider. 제약 소.
- **C3 면적입력** (signposter, arrylic): area-input(직접입력 가로×세로) + 범위검증. 비규격.
- **C4 캐스케이드+후가공+박** (print, sticker, calendar): FinishSection·별색·박/형압·다단 cascade. 최다 필드.
- **C5 셋트조립** (book, stationery): 표지/내지 면별 분해 + 제본 cascade(링) → §23 set-product·evaluate_set_price.

> §29 복잡도 클래스·§23 셋트 모델과 정합. 동형 클래스이므로 클래스당 1개 파일럿 → 전파.

---

## 3. 제약조건 = 주문가능화의 핵심 (사용자 directive)

프로토타입의 제약은 5가지 형태로 JSX에 묻혀 있다. 이를 **정규화 제약(`NormalizedConstraints`)으로 추출**해 기존 캐스케이드 엔진에 태우는 것이 본 작업의 본질:

| # | 제약 형태 (프로토타입) | 실례 | 정규화 계약 매핑 | DB 출처(db-cartography) |
|---|----------------------|------|-----------------|------------------------|
| ① **선택→표시(visible cascade)** | `bindDir==="top" && 링컬러/링선택` | book 제본방향→링 | `OptionGroup.visible` 동적 | `t_prd_product_constraints`(JSONLogic) |
| ② **선택→비활성(disable)** | 자재 선택 시 특정 후가공 불가 | 코팅↔자재 | `DisableRule[]` | `excl_groups`·`materials.dep_proc_cd` |
| ③ **토글→하위필드(박 on/off)** | `foilFrontOn==="on" && 박크기/색상` | print·book 박 | `OptionGroup.visible` + 묶음 | 공정 `prcs_dtl_opt` |
| ④ **범위검증(area)** | placeholder `가로 30~125mm` | 박크기·비규격치수 | `InputSpec.{min,max}`·`BaseRule` | `nonspec_*_min/max`·`t_siz_sizes` |
| ⑤ **택1 패턴(none/single/double)** | `spotOpts` 별색 없음/단면/양면 | 별색인쇄 5종 | `OptionGroup(multiple=false)` | CPQ option_items |
| ⑥ **필수(required)** | "3개의 체크항목 완료" 게이트 | 주문 전 필수선택 | `OptionGroup.required` | `mand_proc_yn`·`mand_yn` |

**주문가능 정의(order-capable) [확정 기준]:** 한 상품군 위젯이 ⓐ 옵션이 라이브 DB 구동 + ⓑ 위 제약 6종이 데이터로 강제(잘못된 조합 차단/숨김) + ⓒ `evaluate_price` 실가 PRICE≠0 + ⓓ 유효 주문 페이로드(`NormalizedCartHandoff` + 에디터/업로드 artifact) 조립 — 4조건 충족.

---

## 4. 접근 방법 (상품군당 5단계 — 클래스 대표 파일럿→전파)

각 상품군을 다음 5단계로 주문가능화한다(클래스 대표 1개 완주 후 동형 전파):

1. **폼 인벤토리** — Configurator.jsx의 옵션 필드·컴포넌트·조건부 제약을 추출(본 문서 §2가 1차).
2. **옵션 데이터 바인딩** — 하드코딩 옵션 → `db-cartography` 매핑으로 라이브 `t_prd_product_*` 구동. componentType 14종 사상(대부분 기존, Slider=조각수/볼체인은 검토).
3. **제약 추출·정규화** — JSX 조건문(§3 6종) → `NormalizedConstraints`로 추출하고 라이브 `t_prd_product_constraints`와 대조(디자인 의도 ↔ DB 데이터 일치/갭). 엔진은 기존 캐스케이드 그대로.
4. **가격 결선** — 가짜 계산식 제거 → `NormalizedPriceRequest`(옵션 선택) → `evaluate_price`/`evaluate_set_price`(C5) → `NormalizedPriceBreakdown`. PRICE≠0 골든.
5. **주문 조립** — 후가공·추가상품·면별 artifact + 에디터/업로드 CTA → `NormalizedCartHandoff`. (커머스 바인딩은 §24 Shopby·UNDECIDED 경계)

**위젯 코어 불변[HARD]:** 04_build `src/widget`·`src/contract` 0줄 변경 목표. 신규는 어댑터+데이터+(정당 시)신규 leaf만. 외형 정합은 hw-design-fidelity가 Red 구조 보존+후니 스킨.

---

## 5. 신규 componentType / 갭 후보 (검토 필요)

- **Slider** (조각수 arrylic·볼체인 arrylic/goods·문구) — 계약 14종 중 `price-slider` 재사용 가능한지, 별도 count-slider인지 검토. (A 어댑터 흡수 우선)
- **면별 분해(C5)** — book 표지/내지/면지/투명커버 = `semi_role_cd` + `t_prd_product_sets`. §23 set-product 모델 재사용. `ProductSide[default,inner]` 계약 존재.
- **장수/페이지(calendar 장수·book 내지페이지)** — `page-counter-input` + `page_rules`.
- **삼각대컬러·링컬러(ColorChip)** — `color-chip` + 추가 스키마 `color_hex`(added-schema-260701).
- **추가상품(봉투·볼체인·개별포장)** — `t_prd_product_addons` + 템플릿. addon 경로.

→ 대부분 (A) 어댑터 흡수 / 기존 계약. (B) 위젯 계약 변경은 Slider 1건 가능성. (C) DB는 제약 데이터·color_hex(이미 added-schema 제안).

---

## 6. 진행 권고 (분석 후 다음 단계)

1. **파일럿 클래스 1개 완주** → 동형 전파. **C4 print(디지털인쇄)** 권장 — db-cartography 파일럿(PRD_000041)과 연속·최다 필드라 제약 패턴 최대 노출. 또는 **C1 accessories**(가장 단순)로 파이프 빠르게 입증 후 상향.
2. 산출(클래스당): `widget-forms/<class>/<group>-form-spec.md`(폼↔계약↔DB↔제약 매핑) + 제약 추출표 + evaluate_price 골든 + 주문 페이로드 예시.
3. 실행 주체: hw-architect(폼↔계약 명세) + hw-db-cartographer(데이터·제약 DB 대조) + hw-design-fidelity(외형 정합). 생성 후 hw-qa 독립 검증.
4. **미해결/확인 필요:** ⓐ 디자인 제약 ↔ 라이브 제약 데이터 갭(t_prd_product_constraints 충전도) ⓑ Slider componentType 처리 ⓒ C5 면별 분해의 set-product 정합 ⓓ 가짜 가격식과 실 evaluate_price 차이(저청구 결함 §26 연계).

---

## 부록: 상품군 ↔ 라이브 상품군 ↔ §29 클래스 정합 (확인 대상)

11 디자인 상품군이 라이브 DB 상품군·§29 준비도 클래스와 1:1인지 확인 필요(디자인 캘린더 vs 캘린더 분리 등). db-cartography `isomorphism-classes.md`와 교차.
