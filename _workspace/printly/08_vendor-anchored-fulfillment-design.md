# 08 · 벤더-앵커 추천 + 파일 변환 파이프라인 설계

> 작성: 2026-07-04 · 트리거 = 지니 3점:
> **(1)** 프린틀리와 **연결된 인쇄회사 기준으로 먼저 추천**.
> **(2)** 고객에게 상품 선택 **가이드** → 주문용 **인쇄(디자인) 파일 생성** → 선택된 **인쇄소 인쇄룰에 맞춰 파일 변환**까지.
> **(3)** 그러면 **인쇄소마다 주문 룰이 있어 거기 맞게 파일을 제작해야 하는 상황** 발생(난제 제기).
> 관계: 06(벤더 선택 2~3층)·07(추천 1층)을 **연결·파일·주문**까지 확장. PART2 fulfillment 진입.

---

## 0. 결론 — point 3의 문제는 이미 지니 특허 C3가 푼다

- 순진한 방식(벤더 N × 각 인쇄룰 = 파일 N개 수작업)은 **폭발**한다 — 지니가 point 3에서 우려한 그것.
- 해법은 **이미 우리 자산에 있다**: 지니 본인 특허 **C3 장비가상화** = **논리 파일 1개 → 벤더별 가상 드라이버(어댑터) → 각 인쇄룰 변환**. 벤더 추가 = 어댑터 1개(선형·author once). `research/patent-analysis.md` 수정-P1이 이미 "N×M 매트릭스 → 논리 API+장비가상화로 교정"이라 결론.

---

## 1. 추천은 "연결된 벤더" 앵커 (point 1)

추천 후보 = **연결(connected) AND 가능(feasible)** 벤더만. 06의 2층(가능여부) 위에 **0층=연결여부**를 얹는다.

**추천 4단 필터**:
```
0. 연결(connection)   : 프린틀리에 연결된 벤더인가?      ← point 1 (신규 선행)
1. 가능(feasibility)  : 이 사양 전체를 만들 수 있나?     ← 06 2층
2. 가격/납기(rank)    : 되는 곳 중 어디가 나은가?        ← 06 3층
   + 이유(1층)        : 왜 이 홍보물인가(출처+등급)      ← 07
```

**현재 연결 상태**(`printshops/*.json#connection`):
| 벤더 | status | level | 근거 |
|---|---|---|---|
| 후니 | connected | **full** | 라이브 DB + evaluate_price 실호출 |
| 와우 | connected | **price_api** | jobcost 가격조회 실증·주문 API 미실증 |
| 레드 | 미연결 | — | 데이터 편입 후속(지니 WebToProduct 엔진 생산) |

→ **오늘 추천 후보 = {후니, 와우}**. 레드는 연결 후 후보 진입(instance_of만 붙이면 §35 교차 자동).

---

## 2. 종단 플로우 (point 2)

```
[상품 선택 가이드]        [파일 생성]         [벤더 룰 변환]        [주문]
 추천 3층(07·06)     →   디자인 파일     →   선택 벤더 인쇄룰   →  잡티켓 주문
 업종→기능→홍보물         (논리 파일)         맞춰 변환             (E24)
 +연결·가능·가격          canonical           = 어댑터(C3)          +변환파일
```

- 앞 절반(상품 선택 가이드) = PART1 추천(이미 파일럿 실동·reason_demo).
- 뒤 절반(파일 생성 → 변환 → 주문) = **PART2 fulfillment** 진입. 잡티켓(E24·05_part2-bridge)·§35 routing(E22~E25) 재사용.

---

## 3. 크럭스 (point 3) — "인쇄룰"이 구체적으로 뭔가

벤더마다 다른 **주문 인쇄룰** (실 근거 병기):

| 룰 축 | 뜻 | 실 근거(현재) |
|---|---|---|
| **파일 포맷** | 허용 확장자 | 와우=상품별 filetype(40073=AI,EPS,…·catalog 앵커). 후니=GAP |
| **재단 여백(bleed)·안전선** | 재단 물림/안전 영역 | 벤더 입고규정·GAP |
| **해상도·컬러 프로파일** | dpi·CMYK/별색 | C3 속성(dpi 254/500/1016)·GAP |
| **판형/임포지션** | 판걸이·합판 배치 | 후니=fn_calc_pansu·fn_best_plate / 와우=pjoin(합판9/독판0) |
| **후가공 레이어 분리** | 박·오시·도무송 별도 파일 | RED 20단계=후가공별 파일분리 |
| **cutline(칼선 path)** | 도무송/반칼 경로 | C2 커팅 프리플라이트 대상 |
| **파일명·업로드 spec** | 명명 규칙·주문 API | 와우=6.5 주문 API·price_order_spec / 후니=GAP |

→ 이 룰이 벤더마다 달라, **같은 명함이라도 후니용 파일 ≠ 와우용 파일**. point 3의 "파일 제작 상황."

---

## 4. 해법 — 장비가상화 (C3): 논리 파일 1개 + 벤더 어댑터

```
[논리 파일 1개]              [벤더별 가상 드라이버(어댑터)]        [벤더 인쇄룰 충족 파일]
 logical_output_contract  →   device_virtual_driver(후니)     →  후니 룰 파일
 (장비·벤더 무관·1회 저작)      device_virtual_driver(와우)     →  와우 룰 파일
                              device_virtual_driver(레드)     →  레드 룰 파일(지니 엔진)
```

- **author once**: 고객 디자인 = 논리 파일 1개. 벤더 추가 = 어댑터 1개(전 변환 재배선 X).
- **C3 장비가상화** = 지니 특허(논리데이터→가상드라이버→dpi/회전/커터/포트/오프셋교정→출력·단일 API). + **C2**(cutline 프리플라이트·중복/초소형/예각/커팅순) + **C1**(생산시간).
- **어댑터 두께는 벤더마다 다름**: 벤더가 자체 변환 엔진 보유(레드=지니 WebToProduct)면 얇게(위임), 없으면 프린틀리 어댑터가 두껍게(직접 변환).

**[HARD] 경계(원칙3·D-18 동형)**:
- **온톨로지** = 벤더 룰 SPEC(선언·`printshops/<v>.json#print_rules`) + 연결상태. 축·룰까지만.
- **엔진** = 파일 변환·프리플라이트·시간예측(결정론·C1~C3·각 벤더 엔진 호출).
- **AI** = 견적/프리플라이트/변환을 **판단 안 함**(반드시 엔진 호출·LLM 값추정=버그).

---

## 5. 데이터 그릇 (search-before-mint)

| 그릇 | 무엇 | 상태 |
|---|---|---|
| `printshops/<v>.json#connection` | 벤더 연결 상태·레벨 | ★배선됨(후니 full·와우 price_api) |
| `printshops/<v>.json#print_rules` | 벤더 인쇄룰 SPEC(포맷·bleed·color·imposition·cutline·upload) | ★축 배선·값 다수 GAP(후속) |
| `logical_output_contract`(신규) | 논리·장비무관 파일 모델(patent-analysis 개선-P1) | 미설계(후속) |
| `device_profile`(벤더별) | dpi/회전/방식/포트/변환규칙(C3) | 미설계(후속) |
| 잡티켓(E24) | 변환 파일 + 주문정보 담체 | 05_part2-bridge 설계됨 |

- 신규 엔티티 최소: `connection`·`print_rules`=속성(그릇 내)·`logical_output_contract`/`device_profile`=논리/가상 2층(patent-analysis 개선-P1·CIP4 DeviceCapabilities 정합).

---

## 6. 확정 (지니 2026-07-04)

| # | 결정 | ★확정 |
|---|---|---|
| **Q1** | 파일 변환 소유 | **하이브리드** — 프린틀리가 논리 파일 + 벤더별 어댑터 소유(C3). 어댑터 두께 벤더별(레드=지니 WebToProduct 엔진 위임·후니/와우=필요분 직접 변환). |
| **Q2** | 착수 순서 | **후니 1벤더 end-to-end 먼저** — 추천→파일→후니룰 변환→주문 한 바퀴. 단 구조는 canonical(논리파일)+adapter로 저작(확장 시 재작업 0). |

**확정 함의(실행 계획)**:
1. 후니 파일럿 트랙 = 이미 실동하는 명함(추천·evaluate_price 견적)에 **파일 생성 → 후니 어댑터 → 주문** 붙이기.
2. 논리 파일 모델(`logical_output_contract`)은 처음부터 벤더-무관하게 저작 → 와우/레드 어댑터는 나중에 append만.
3. 어댑터 = 결정론 엔진(C1~C3). AI는 변환 판단 안 함(원칙3).

---

## 7. 경계·다음

- **경계**: 이 문서 = 설계. 실 파일 변환 엔진(C1~C3)·논리 파일 모델 구현은 후속(벤더 룰 값 GAP 해소 선행).
- **다음**:
  1. 지니 Q1·Q2 확정.
  2. `print_rules` 값 GAP 해소(후니 webadmin 업로드규정·와우 order/products spec PDF 추출).
  3. `logical_output_contract` + `device_profile` 2층 설계(patent-analysis 개선-P1 구체화·CIP4 정합).
  4. 후니 1벤더 파일 플로우 파일럿(명함=이미 추천·견적 실동 → 파일 변환 붙이기).
  5. §35 routing(E22~E25)·잡티켓(E24)와 접합.

## 근거
- `research/patent-analysis.md`(C1~C3·개선-P1 논리/가상 2층·수정-P1 매트릭스→가상화) · `05_part2-bridge-jobticket.md`(잡티켓 E24) · `06/07`(추천 층) · `printshops/{huni,wow}.json`(connection·print_rules) · §35 routing-layer-schema(E22~E25) · CIP4 JDF/DeviceCapabilities(표준 병행·search-before-mint).
