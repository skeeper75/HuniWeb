# 데이터 그릇 정의 (인쇄소 가기 전까지)

> 후니 먼저 쌓을 3그릇의 shape. 값=엔진·축=그릇(원칙 3). 슬롯마다 §33 앵커 재사용(원칙 6).

---

## 그릇 ① 추천 (업종 → 목적 → 홍보물)

위치: `../pilot/recommendation-layer.json` (이미 채움·8업종). shape:
- `industries`: 업종 → {마케팅 목적: dominance(primary/secondary)}
- `functions`: 마케팅 목적 → {홍보물: fit(primary/secondary)}
- `products`: 홍보물 node_id → {prd_cd, name}
- 근거: 업종/목적=소진공 분류·원자 기능 8 / product=라이브 prd_cd.
- 엣지: `references`(R19·§33). 순위 값=엔진(D-REC).

---

## 그릇 ② 홍보물 레시피 — 6부류 (핵심·채울 공간)

홍보물 1개 = 1 레시피 파일(`recipes/<상품>.json`). 음식 레시피처럼 "무엇으로 어떻게 만들고 어떻게 과금되나".

| 부류 | 담는 것 | 재사용 §33 앵커 | 값/경계 |
|---|---|---|---|
| **① 재료** | 용지·소재 / 규격 / 도수·인쇄방식 | `t_prd_product_materials`·`_sizes`·`_print_options` | 축 |
| **② 공정** | 인쇄·후가공(코팅·박·오시·커팅…)·제본 (RED 14종 별색 어휘) | `t_prd_product_processes`·`t_proc_processes` | 축·순서 |
| **③ 가격구성요소** | 재료·공정별 원가 + **계산클래스**(길이/면적/개수/수량) | `t_prc_formula_components`·`t_prc_price_components` | **값=evaluate_price** |
| **④ 옵션** | 손님 선택 축(옵션 타입) | `t_prd_product_option_groups` | 축 |
| **⑤ 제약** | 안 되는 조합(JSONLogic·CN-1~6) | `t_prd_product_constraints` | 축 |
| **⑥ 생산가능성** | 파일 조건·**칼선 복잡도(길이/경로)**·장비 능력 | (신규 축·RED 생산지식) | **값=엔진**(preflight/production_time) |

- ⑥은 §33에 없는 신규 축(RED 자동견적/커팅 특허 근거) — "이 주문이 실제 인쇄 가능한가"·"칼선 때문에 단가가 얼마나 드나"의 **축만**. 값은 엔진.
- 각 슬롯: `{ref: <prd_cd/코드>, label, source, badge}`. 근거 없으면 비움(GAP).

---

## 그릇 ③ 인쇄소 연결 (벤더 handoff·후니 먼저)

위치: `printshops/<벤더>.json`. §35 `E22 supplier` 재사용. shape:
- `id`·`brand`·`roles`(supplier/broker)·`name`·`region`
- `quote_engine`: 견적 엔진(후니=evaluate_price)
- `data_source`: 이 인쇄소 상품 데이터 원천(후니=§33 라이브)
- `capability_ref`: 생산 능력(§35 capability·후속)
- `handoff`: 주문이 넘어가는 접합점(잡티켓 = **다음 스텝**)

레시피의 `인쇄소 연결` 슬롯이 이 그릇을 가리킨다(후니 홍보물 → produced_by huni). 생산과정은 handoff 뒤 = 다음 스텝.

---

## 경계 (relitigate 금지)
- 이 공간 = **인쇄소 가기 전까지**. 생산(파일규칙·잡티켓 실행·장비·배송)은 **다음 스텝**·벤더/장비 데이터 대기.
- 값(가격·칼선·시간) = 엔진. 그릇은 축·연결·근거까지.
- 후니 먼저 → 같은 그릇으로 와우·레드 확장(브랜드-중립 상위 개념).
