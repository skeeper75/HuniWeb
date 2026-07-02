# 후니프린팅 인쇄 자동견적 지식베이스 구축 가이드
## 제2권 — DB 스키마 · ERD · ETL 파이프라인

> **문서 성격**: 매뉴얼 + 지침 결합형. 제1권(엑셀 해부·접근방법론)의 규칙을 실제 데이터베이스 스키마와 적재 파이프라인으로 전개한다.
> **선행 문서**: `KB_01_엑셀해부_접근방법론.md`. 본 문서의 모든 테이블은 제1권의 장 번호를 근거로 참조한다.
> **용어 원칙**: 인쇄 통용 용어 우선. 스키마 식별자는 영문, 설명은 국문.

---

## 목차

- **1장. 설계 원칙 5계명**
- **2장. 전체 ERD 개관** — 6개 도메인 경계
- **3장. 상품·옵션 도메인** — product / option_group / option_item
- **4장. 가격 도메인** — price_component / 3 아키타입 테이블
- **5장. 조판 도메인** — imposition (판걸이수)
- **6장. 소재 도메인** — material (출력소재)
- **7장. 공정 도메인** — option_to_process (2계층)
- **8장. 제약 도메인** — constraint (JSONLogic)
- **9장. 견적 엔진** — 계산 파이프라인
- **10장. ETL 적재 지침** — 7단계 의존성 체인
- **11장. 검증 프레임워크**

---

## 1장. 설계 원칙 5계명

제1권에서 도출된 사실을 스키마 원칙으로 압축한다.

| # | 원칙 | 근거(제1권) |
|---|------|-----------|
| 1 | **상품마스터 = SSOT.** 모든 옵션·노출 규칙의 최종 권위 | 1장 |
| 2 | **아키타입 3종으로 가격 라우팅.** 상품마다 주계산 1개 + 애드온 N | 5장 |
| 3 | **옵션 2계층.** 고객 옵션 레이어 ↔ 생산 공정 레이어 분리 | 7장 |
| 4 | **판걸이수 = 공용 함수.** 출력매수·총내지매수의 단일 출처 | 6장 |
| 5 | **가격 출처 메타 필수.** 계산가 vs 협의가 구분 관리 | 5.2 |

> **지침 1-A**: 정규화를 기본으로 하되, 가격 테이블(matrix형)은 조회 성능을 위해 의도적 비정규화(wide table)를 허용한다. 원칙은 "의미 단위 분리, 조회 단위 결합".

---

## 2장. 전체 ERD 개관

### 2.1 6개 도메인 경계

```
┌─ 상품·옵션 도메인 ────────────────────────┐
│  product ──< option_group ──< option_item │
│     │                              │       │
│     └── product_archetype          │       │
└──────────────┼─────────────────────┼───────┘
               │                     │
┌─ 조판 도메인 ─┼──┐   ┌─ 공정 도메인 ─┼──────┐
│  imposition ─┘  │   │ option_to_process    │
│  (판걸이수)      │   │ production_process   │
└─────────────────┘   └──────────────────────┘
               │                     │
┌─ 가격 도메인 ─┼─────────────────────┼───────┐
│  price_component                            │
│   ├─ price_matrix   (인쇄비·박·아크릴·실사)  │
│   ├─ price_tier     (수량행 단가)            │
│   └─ price_fixed    (협의 고정가)            │
└─────────────────────┬───────────────────────┘
                       │
┌─ 소재 도메인 ─────────┴──┐  ┌─ 제약 도메인 ──────┐
│  material (출력소재)     │  │ constraint(JSONLogic)│
│  material_price          │  └──────────────────────┘
└──────────────────────────┘
```

### 2.2 도메인 간 조인 키

| 조인 | 키 | 근거 |
|------|-----|------|
| product ↔ imposition | 사이즈옵션명 | 제1권 6.2 |
| imposition ↔ 가격 | 출력용지규격 (316×467=국4절) | 제1권 6.1 |
| option_item ↔ material | 종이(소재코드) | 제1권 2.3 |
| option_item ↔ process | option_to_process | 제1권 7.2 |
| price_component ↔ 시트 | 참조시트명 (계산공식집) | 제1권 4.2 |

---

## 3장. 상품·옵션 도메인

### 3.1 product

```sql
CREATE TABLE product (
  product_id      VARCHAR PRIMARY KEY,   -- 상품마스터 ID열(B)
  mes_item_cd     VARCHAR,               -- MES ITEM_CD (C) — 94% 미완, 선행과제
  product_name    VARCHAR NOT NULL,      -- 상품명(D)
  group_cd        VARCHAR,               -- MAP 7대 그룹 (01엽서~07캘린더 등)
  category_cd     VARCHAR,               -- MAP 서브카테고리
  archetype       VARCHAR NOT NULL,      -- 'atomic_sum' | 'fixed_table' | 'area_matrix'
  is_set_product  BOOLEAN DEFAULT FALSE, -- 세트상품(책자·엽서북 등)
  price_included  BOOLEAN DEFAULT FALSE, -- 시트명 "(가격포함)" = display-only
  formula_ref     VARCHAR,               -- 계산공식집 참조 (예: 'R63')
  order_channel   VARCHAR,               -- 업로드/편집기 (주문방법 N)
  status          VARCHAR DEFAULT 'active' -- active/draft_new/draft_hold/cross_ref
);
```

> **지침 3-A**: `archetype`은 계산공식집의 `[원자합산형]/[고정가형]/[면적매트릭스형]` 태그에서 직접 파생한다(제1권 4.2). 파싱 규칙: 태그 대괄호 안의 상품명 목록 → 해당 product에 archetype 부여.

### 3.2 option_group / option_item

```sql
CREATE TABLE option_group (
  group_id      VARCHAR PRIMARY KEY,
  product_id    VARCHAR REFERENCES product,
  group_name    VARCHAR,               -- 사이즈/종이/인쇄/코팅/후가공...
  role          VARCHAR,               -- required|optional|internal (색상코드)
  usage_tag     VARCHAR,               -- ui_select|product_def|process_param|upsell
  display_order INT,                   -- 엑셀 열 순서 (제1권 2.3)
  ref_dim_cd    VARCHAR                -- 가격 조회 차원 코드
);

CREATE TABLE option_item (
  item_id       VARCHAR PRIMARY KEY,
  group_id      VARCHAR REFERENCES option_group,
  item_value    VARCHAR,               -- "단면"/"양면"/"73 x 98 mm"...
  ref_key1      VARCHAR,               -- 복합키 1 (가격표 조회)
  ref_key2      VARCHAR,               -- 복합키 2
  size_scope    VARCHAR,               -- ALL | 특정사이즈 (매핑규칙 302건)
  price_effect  VARCHAR                -- 'component'|'none'(display only)
);
```

> **지침 3-B**: `role`은 Row1 배경색으로 자동 판정(제1권 2.2): `FFE06666`→required, `FFF6B26B`→optional, `FFD9D9D9`→internal, `FFC4BD97`→(metadata, 그룹화 제외).

> **지침 3-C**: `size_scope`는 옵션-사이즈 매핑 규칙 302건(A_SIZE_FIXED/B_SIZE_VARIES/D_MIXED)으로 결정. 사이즈행 값이 전부 동일하면 ALL, 행마다 다르면 해당 사이즈 전용. 이 판정을 ETL에 규칙 함수로 내장한다.

### 3.3 수량 규칙 (위젯 테스트 검증분)

```sql
CREATE TABLE quantity_rule (
  product_id    VARCHAR,
  size_value    VARCHAR,      -- 사이즈별로 다름
  min_qty       INT,          -- 상품마스터 AA열 (최소)
  max_qty       INT,          -- AB열 (최대)
  step_qty      INT           -- AC열 (증가) = 판걸이수 배수 단위
);
```

> **위젯 근거**: 통화 P7에서 검증된 "73×98 → min15/step15/max1000". `step_qty`는 판걸이수와 연동(15장=판당 UP수)되므로, 신규 상품은 판걸이수에서 자동 도출 가능.

---

## 4장. 가격 도메인

### 4.1 price_component — 견적 항목의 통합 정의

계산공식집 35개 공식의 각 항목을 레코드화(제1권 4.3).

```sql
CREATE TABLE price_component (
  component_id  VARCHAR PRIMARY KEY,
  product_id    VARCHAR REFERENCES product,
  seq           INT,                   -- 합산 순서 (공식의 (1)(2)(3)...)
  comp_name     VARCHAR,               -- 인쇄비/코팅비/용지비/후가공비...
  calc_type     VARCHAR,               -- lookup_matrix|per_sheet|per_quantity|fixed
  ref_sheet     VARCHAR,               -- 참조 가격표 시트 (디지털인쇄비 등)
  formula_expr  TEXT,                  -- 원공식 문자열 (감사·추적용)
  multiplier    NUMERIC DEFAULT 1      -- 트윈링 ×2 등 계수
);
```

### 4.2 세 아키타입 물리 테이블

**(A) price_tier — per_quantity / per_sheet 수량행 단가**

```sql
CREATE TABLE price_tier (
  sheet_cd    VARCHAR,     -- 디지털인쇄비/코팅/접지옵션/인쇄후가공/제본
  qty         INT,         -- 수량행 (1,2,3,4,5,6...)
  col_key     VARCHAR,     -- 옵션열 (흑백1도_단면, CMYK_양면, 2단, 무선...)
  unit_price  NUMERIC
);
-- 예: (디지털인쇄비, 1, CMYK_단면, 4000), (디지털인쇄비, 6, CMYK_단면, 1500)
```

**(B) price_matrix — lookup_matrix (박·아크릴·실사)**

```sql
CREATE TABLE price_matrix (
  sheet_cd    VARCHAR,     -- 아크릴/포스터사인/후가공_박(소형/대형)
  row_key     VARCHAR,     -- 세로mm 또는 크기등급(A~E)
  col_key     VARCHAR,     -- 가로mm 또는 수량/칼라
  price       NUMERIC
);
-- 예: (아크릴, 20mm, 100mm, 4200), (포스터사인, 600mm, 1000mm, 20000)
```

**(C) price_fixed — 협의 고정가**

```sql
CREATE TABLE price_fixed (
  sheet_cd     VARCHAR,    -- 엽서북떡메/명함포토카드/봉투제작/스티커
  dim1         VARCHAR,    -- 사이즈
  dim2         VARCHAR,    -- 인쇄(단/양면)
  dim3         VARCHAR,    -- 페이지/소재
  qty          INT,
  price        NUMERIC,
  price_origin VARCHAR DEFAULT 'negotiated'  -- ★ 재계산 불가 표식
);
-- 예: (엽서북떡메, 100*150, 단면, 20P, 2, 11000, negotiated)
```

> **지침 4-A**: `price_origin='negotiated'`인 레코드는 원가 개정 시 자동 재계산에서 **제외**하고 수동 검토 큐로 보낸다(제1권 5.2 시장 역산가).

> **지침 4-B**: 박은 항상 `고정 동판비(price_tier) + 매트릭스 박비(price_matrix)` 2단 합산. 소형박 동판비 = 5,000원(제1권 3.2).

---

## 5장. 조판 도메인 (imposition)

```sql
CREATE TABLE imposition (
  size_option   VARCHAR PRIMARY KEY,   -- "73 x 98 mm"
  trim_size     VARCHAR,               -- 재단사이즈 73x98
  bleed         NUMERIC,               -- 블리드 1mm
  work_size     VARCHAR,               -- 작업사이즈 75x100 (=재단+블리드×2)
  products      VARCHAR,               -- "엽서 / 엽서북내지" (복수 공유)
  up_count      INT,                   -- 판걸이(UP수) 18
  base_sheet    VARCHAR,               -- 출력용지규격 316x467 (국4절)
  print_area    VARCHAR,               -- "사방 5mm제외" (그리퍼)
  cutmark_area  VARCHAR                -- 원형아이마크영역(완칼)
);
```

**공용 함수** (제1권 4.3 지침 4-B):

```python
def output_sheets(order_qty, up_count):
    """출력매수 = 주문수량 / 판걸이수 (올림)"""
    return math.ceil(order_qty / up_count)

def inner_sheets(copies, pages, up_count):
    """총내지매수 = 부수 × (페이지수 / 판걸이수)"""
    return copies * math.ceil(pages / up_count)
```

> **지침 5-A**: `work_size = trim_size + bleed×2` 검산 규칙을 ETL에 넣어 데이터 오류를 걸러낸다. 실측 73×98→75×100 정합 확인.

> **⚠️ 데이터 이슈**: 상품마스터 판수(15) vs 판걸이수 up_count(18) 불일치(제1권 8장 #1). **imposition 테이블을 권위로 삼되, 적재 전 신우진 확인 필수.**

---

## 6장. 소재 도메인 (출력소재 IMPORT)

```sql
CREATE TABLE material (
  material_cd   VARCHAR PRIMARY KEY,
  category_lv1  VARCHAR,     -- 대분류 (디지털인쇄)
  category_lv2  VARCHAR,     -- 중분류 (디지털인쇄용지)
  material_name VARCHAR,     -- 백색모조지 100g
  weight_gsm    INT,         -- 평량 100
  file_alias    VARCHAR,     -- 파일명약어 (백모조)
  base_paper    VARCHAR,     -- 전지 국전(939x636)
  ream_price    NUMERIC,     -- 연당가 61460
  price_k4      NUMERIC,     -- 가격(국4절) 30.73
  price_3jeol   NUMERIC,     -- 가격(3절)
  paper_size    VARCHAR      -- 종이사이즈 316x467
);
```

> **지침 6-A**: 상품마스터 종이열의 "*별도설정"(9건)은 소재를 상품·사이즈별로 별도 지정하는 플래그다. `material` 조인이 아니라 상품별 소재 매핑 테이블로 처리. 용지비 = `price_k4 × (출력매수 + 손지율 5장)`(제1권 4.2 R9).

---

## 7장. 공정 도메인 (2계층 핵심)

```sql
CREATE TABLE production_process (
  process_cd    VARCHAR PRIMARY KEY,  -- 오시/접지/도수변환/완칼...
  process_name  VARCHAR,
  mes_route     VARCHAR               -- MES 공정 라우트
);

CREATE TABLE option_to_process (
  item_id       VARCHAR REFERENCES option_item,
  process_seq   INT,                  -- 공정 순서
  process_cd    VARCHAR REFERENCES production_process,
  process_param VARCHAR               -- '9도'(양면), '5mm여백'...
);
-- 예: 2단가로접지 → (seq1, 오시) → (seq2, 접지)
--     아크릴양면   → (seq1, 도수변환, param=9도)
```

> **지침 7-A (최우선)**: 이 매핑 없이는 MES 작업지시 생성 불가. 근거는 시트 헤더에 직접 있음 — 접지옵션 "카드접지 단가(오시+접지)", 아크릴 "양면9도/단면7도"(제1권 7.1). MES_ITEM_CD 94% 미완성과 함께 P6 이전 해소.

---

## 8장. 제약 도메인 (JSONLogic)

```sql
CREATE TABLE constraint_rule (
  constraint_id VARCHAR PRIMARY KEY,
  product_id    VARCHAR,
  rule_json     JSONB,      -- JSONLogic 표현식
  effect        VARCHAR,    -- disable|require|set_param|hide
  target_group  VARCHAR
);
```

**위젯 테스트에서 검증된 발동조건**(통화 P7)을 JSONLogic으로:

```json
{
  "if": [
    {"==": [{"var": "size"}, "73x98"]},
    {"set": {"quantity": {"min": 15, "step": 15, "max": 1000}}}
  ]
}
```

> **지침 8-A**: 세 가지 제약 소스를 동일 JSONLogic 문법으로 수렴한다 — ① 위젯 발동조건, ② 엑셀 ★사이즈선택 마커(44건), ③ 레드프린팅 벤치마크 제약 패턴(경쟁분석 문서). 기존 제약 57건과 표현력 대조 필수.

> **1:1 결정 옵션 처리**: 위젯 테스트에서 "사이즈와 1:1로 결정되는 옵션은 삭제"한 결정(통화 P7)은 제약이 아니라 `option_group.role`을 internal로 승격하는 것으로 구현. 고객 비노출 + 내부 자동확정.

---

## 9장. 견적 엔진 — 계산 파이프라인

### 9.1 아키타입 라우팅

```python
def calculate_price(product, selections):
    imp = get_imposition(selections['size'])          # 5장
    if product.archetype == 'atomic_sum':             # 원자합산형
        base = sum(calc_component(c, selections, imp)  # 4.1 각 component
                   for c in product.components)
    elif product.archetype == 'fixed_table':          # 고정가형
        base = lookup_fixed(product.sheet, selections) # price_fixed
    elif product.archetype == 'area_matrix':          # 면적매트릭스형
        base = (lookup_matrix(product.sheet,
                    selections['h'], selections['w'])
                * qty_discount(selections['qty']))     # 4.2(B)
    addons = sum(calc_addon(a, selections, imp)        # 박·모서리 등
                 for a in product.addons)
    return base + addons
```

### 9.2 component 계산 (원자합산형 예: 엽서)

```python
def calc_component(c, sel, imp):
    sheets = output_sheets(sel['qty'], imp.up_count)   # 출력매수
    if c.calc_type == 'per_sheet':      # 인쇄비·코팅비
        return tier_price(c.ref_sheet, sel['qty'], c.col_key) * sheets
    if c.calc_type == 'per_quantity':   # 후가공·제본·접지
        return tier_price(c.ref_sheet, sel['qty'], c.col_key)
    if c.calc_type == 'lookup_matrix':  # 박
        return foil_price(sel)          # 동판비 + 매트릭스
    if c.calc_type == 'material':       # 용지비
        return material_k4(sel['paper']) * (sheets + 5)  # 손지율
```

> **지침 9-A**: 엔진 검증은 프리미엄엽서 1종으로 E2E 수직 슬라이스 먼저(제1권 9장 STEP 6). 30개 검증 케이스로 회귀 테스트.

---

## 10장. ETL 적재 지침 — 7단계 의존성 체인

기존 확정된 P0→P6 체인에 본 스키마를 대입.

| Phase | 적재 대상 | 소스 | 의존 |
|-------|----------|------|------|
| **P0** 기초코드 | 그룹/카테고리/공정코드/아키타입 enum | MAP, 계산공식집 태그 | — |
| **P1** 소재 | material, material_price | 출력소재(IMPORT) | P0 |
| **P2** 조판 | imposition | 판걸이수 | P0 |
| **P3** 단가 | price_tier, price_matrix, price_fixed | 가격표 17시트 | P0,P1 |
| **P4** 상품 | product, product_archetype | 상품마스터 11시트 | P0 |
| **P5** 옵션 | option_group, option_item, quantity_rule | 상품마스터 색상·열 | P4,P2,P3 |
| **P5b** 공정매핑 | option_to_process | 헤더 파싱 + 수기 | P5 |
| **P6** 제약 | constraint_rule | ★마커, 위젯, 벤치마크 | P5 |

> **지침 10-A**: 각 Phase 종료 시 검증 게이트. P3→P4 사이에 price_component를 계산공식집에서 생성(공식 파싱). P5b(공정매핑)는 자동 파싱 후 수기 보완 — 접지·아크릴 등 명시 헤더는 자동, 나머지는 도메인 확인.

> **지침 10-B**: `후가공_박(백업)` 시트 및 시트명 "(가격포함)" display-only 군은 별도 트랙. 굿즈파우치 86건은 P5에서 대량 배치.

### 10.1 파싱 함수 예시 (계산공식집 → price_component)

```python
def parse_formula_sheet(ws):
    """계산공식집초안에서 아키타입 태그와 공식을 추출"""
    current_archetype, current_products = None, []
    for row in ws:
        text = row[1]  # B열
        if text.startswith('['):
            # [원자합산형: 프리미엄엽서 / 코팅엽서 ...]
            archetype, products = parse_tag(text)
            assign_archetype(products, archetype)
        elif re.match(r'\(\d+\)', text):
            # (1) 인쇄비 = [수량행단가] × 출력매수  → 참조시트
            comp = parse_component(text, ref=row[2])  # C열=참조
            emit_price_component(current_products, comp)
```

---

## 11장. 검증 프레임워크

### 11.1 3단 검증

| 단계 | 검증 | 방법 |
|------|------|------|
| 스키마 | 조인 무결성 | FK 위반 0, 고아 레코드 0 |
| 값 | 조판 검산 | work_size = trim + bleed×2 전수 |
| 견적 | 가격 정확도 | 30개 레퍼런스 케이스 ±0원 |

### 11.2 레퍼런스 케이스 골든셋 (예시)

```
CASE-01 프리미엄엽서 73×98 단면 CMYK 100매
  → 출력매수 = ceil(100/18) = 6
  → 인쇄비 = tier(디지털인쇄비, 6, CMYK_단면=1500) × 6 = 9,000
  → 용지비 = k4(*별도설정) × (6+5)
  → + 코팅·후가공·추가상품
  기대 판매가 = [SSOT v0.4 대조값]
```

> **지침 11-A**: 판수 불일치(15 vs 18)가 미해결이면 CASE-01의 출력매수가 흔들린다. 검증 착수 전 반드시 확정.

---

## 부록. 스키마 요약 (12 테이블)

| 도메인 | 테이블 | 역할 |
|--------|--------|------|
| 상품·옵션 | product, option_group, option_item, quantity_rule | 정의·노출 |
| 가격 | price_component, price_tier, price_matrix, price_fixed | 단가 |
| 조판 | imposition | UP수 |
| 소재 | material | 용지 |
| 공정 | production_process, option_to_process | 2계층 |
| 제약 | constraint_rule | JSONLogic |

---

## 결어 — 두 엑셀 분석 가능성에 대한 최종 판단

**통화는 이 두 엑셀을 "읽을 수 있게" 만든 결정적 사건이다.** 통화 전에는 계산공식집의 "롤/계산식/가격포함"이 무의미한 문자열이었으나, 통화 후 이들은 명확한 로직 지시자가 되었다. 실측으로 통화의 모든 핵심 주장(출력매수 공식, 3아키타입, 2계층 옵션, 협의고정가, 조인키)이 셀 단위로 확인되었다.

**접근법의 요체**: 계산공식집(지도) → 판걸이수(뿌리 공식) → 가격표(단가) → 상품마스터(옵션·노출) 순서로 내려가며, 프리미엄엽서 1종으로 전 계층을 관통하는 수직 슬라이스를 먼저 완성한다. 이것이 통화가 가르쳐 준, 그리고 실측이 뒷받침하는 지식베이스 구축의 정도(正道)다.
