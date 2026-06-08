# price211-direct — DIRECT-PRICE 트랙 매핑 설계서 (Phase-1 slice B)

| 항목 | 값 |
|------|----|
| 담당 | dbm-mapping-designer |
| 일자 | 2026-06-07 |
| 성격 | **GENERATION ONLY** — 매핑 설계 + 적재 실행본(SQL/CSV) + DRY-RUN *계획*. **DB 쓰기·INSERT·DDL·COMMIT·git 커밋 없음.** 검증은 dbm-validator 별도. |
| 대상 | 211 무가격 중 직접가(B) 후보 family: **F1**(굿즈/파우치/에코백/라이프) · **F6**(캘린더) · **F7**(봉투/추가상품) · **F8**(엽서/홍보물/접지카드) |
| 타깃 | `t_prd_product_prices` (직접가 경로 B) · F8은 `t_prd_product_price_formulas` 바인딩 |
| 권위 | 가격표/상품마스터 엑셀 명시값 > `06_extract` L1 > 설계 · **라이브 존재/바인딩 = 라이브 권위** · DDL=`00_schema/price-engine-ddl.md` C-1~C-9 |
| 결론 | **INSERTABLE 73행**(direct price). F8 바인딩 INSERTABLE = **0**(전부 차단). |

---

## 0. 라이브 ground truth (read-only 실측, 2026-06-07)

```
t_prd_products = 275 · 공식 바인딩 64 distinct prd_cd · 직접가 0행 → 무가격 211 (계획과 정합)
```

본 트랙 73 INSERTABLE prd_cd 전건에 대해 read-only FK 체크 통과:
- 73/73 `t_prd_products` 선존재 · 73/73 `t_prd_product_prices` 미존재(중복0) · 73/73 공식 바인딩 미존재. (`_live/_fkcheck.sql` 결과 공집합)

---

## 1. 스키마 타깃 — `t_prd_product_prices` (적재 권위)

| 컬럼 | 타입 | NULL | DEFAULT | 적재 규칙 |
|------|------|:----:|---------|-----------|
| `prd_cd` | varchar(50) | NO | — | PK1. prd_nm JOIN으로 해소(MES_ITEM_CD 전부 NULL). FK→t_prd_products |
| `apply_ymd` | varchar(10) | NO | — | PK2. **`'2026-06-01'`** 고정(C-1, round-1/2 정합, `yyyy-MM-dd`) |
| `unit_price` | numeric(12,2) | YES | — | 엑셀 명시 정수가 verbatim |
| `note` | varchar(500) | YES | — | `[family] prd_nm 직접단가(엑셀 명시값)` |
| `reg_dt` | timestamp | **NO** | **now()** | **INSERT 컬럼목록에서 OMIT → DEFAULT 발화**(round-5 트랩: 명시 NULL은 DEFAULT 미발화하여 NOT NULL 위반) |
| `upd_dt` | timestamp | YES | — | UPSERT 갱신 시 now() |

- PK=(prd_cd, apply_ymd). 한 상품에 단가 1개 → INSERTABLE. **한 상품에 옵션변형 다중가 → PK 충돌(직접가 불가)** → §3 트랩.
- NULL 규약: 본 트랙은 unit_price 전건 실값. note 전건 실값. 공란 컬럼 없음(reg_dt만 OMIT).

---

## 2. family별 매핑 + per-family 카운트

### F1 굿즈/파우치/에코백/라이프 (123 = 라이브 카테고리 권위)
SOURCE: 상품마스터 `굿즈파우치(가격포함)`=`06_extract/goods-pouch-l1.csv`(303행/103 prd_nm) + `상품악세사리(가격포함)`=`product-accessory-l1.csv`(15 prd_nm).
- 매핑: prd_nm 그룹별 `가격` 컬럼 distinct 값 분석 → **§3 트랩 3분류**.
- **123 prd_cd 정확 정산**(누락0·과적0): INSERTABLE 65 + BLOCKED-DECISION 43 + BLOCKED-DATA(prd_cd有) 15 = 123. + 미등록(prd_cd無) 5건 별도.
  - goods-pouch 출처: single 59 + variant 34 + gap 5 + 미등록 5
  - accessory 출처(PRD_000001~015): single 6 + variant 9
  - 노트/플래너(PRD_000172~181, 10건): 본 슬라이스 source 밖 → BLOCKED-DATA(out-of-source)

### F6 캘린더 (5)
SOURCE: `디자인캘린더(가격포함)`=`design-calendar-l1.csv`. 상품행당 inline `가격` 단일값.
- 5상품 전건 **direct 고정가**(상품마스터 단일 가격행, 공식 미바인딩):
  탁상형 10400 · 미니탁상형 6500 · 엽서캘린더 4000 · 벽걸이캘린더 9900 · 와이드벽걸이 24000.
- **계획의 "벽걸이/엽서캘린더=책자형 formula 가능" 판정 → 부정.** 근거: source가 페이지/수량 무관 단일가 1개씩 제시 → 직접가가 정확한 타깃(가격이 차원별로 갈리지 않음). **5건 전부 INSERTABLE.**

### F7 봉투/추가상품 (3 = PRD_TYPE.05 추가상품)
SOURCE: `product-accessory-l1.csv` 카드봉투(화이트 1000/블랙 1500) + 트래싱지 카드봉투(160x110 20장=6000).
- **라이브 권위 발견(계획 갱신)**: 카드봉투의 색상 옵션변형(.03 PRD_000004 = 화이트1000/블랙1500, PK 충돌)을 **라이브가 이미 .05 분할**로 해소 — `PRD_000281 카드봉투(화이트)`=1000, `PRD_000282 카드봉투(블랙)`=1500. 각 prd_cd 단일가 → INSERTABLE.
- `PRD_000283 트레싱지봉투`(.05) = 6000(트래싱지 카드봉투 160x110 20장 cell, 디지털인쇄 추가상품 컬럼이 "트레싱지봉투 160x110 mm 20장"으로 명시 참조). **3건 INSERTABLE.**
- 주의: `.03` 일반판 PRD_000003(트래싱지 카드봉투, size×수량 matrix)·PRD_000004(카드봉투, 색상변형)는 **본 트랙 INSERTABLE 아님** → BLOCKED-DECISION(matrix/variant). 동명 .03↔.05 혼동 금지.

### F8 엽서/홍보물/접지카드 (3) — **전건 BLOCKED-OTHER-TRACK**
대상: `PRD_000019 투명엽서`(엽서) · `PRD_000030 지그재그엽서`(접지카드) · `PRD_000049 와이드 접지리플렛`(인쇄홍보물).
- 계획="PRF_DGP 바인딩만". 그러나 **digital-print-engine 트랙이 이미 이 3건을 BLOCKED_siz로 분류** + 라이브 plate 실측이 차단 확증:
  - PRD_000019 투명: plate SIZ_000113/114/115/118 ↔ 디지털인쇄비 커버 {SIZ_000077, SIZ_000499} = **0/4**
  - PRD_000030 3절: plate SIZ_000142/143 ↔ 3절 인쇄비 SIZ_000077 = **0/2**
  - PRD_000049 3절: plate SIZ_000186/188/190 ↔ 커버 **0/3**
- **바인딩만 하면 공식이 단가 0건 룩업 → 가격 NULL(침묵 실패).** PRF_DGP 공식은 존재하나(F8 의도공식: 019→A, 030→E, 049→E) component_prices가 사이즈를 안 덮음.
- **판정: F8 바인딩 INSERTABLE=0. 3건 전부 BLOCKED-OTHER-TRACK(digital-print-engine 3절/투명 차단)** = `BLOCKED_OTHER_TRACK_F8.csv`. 이 트랙(직접가)에서 적재 금지.

---

## 3. F1 PK-충돌 트랩 처리 (핵심 — 절대 강행 금지)

`t_prd_product_prices` PK=(prd_cd, apply_ymd). 한 prd_cd에 옵션별 가격 다수 = 적재 불가.

### 3.1 분류 규칙 (prd_nm 블록별 `가격` distinct 값)
| 분류 | 조건 | 처리 |
|------|------|------|
| (a) SINGLE-DIRECT | distinct 가격 1개(사이즈 여러 행이어도 동일가 포함), 선택옵션가 없음 | → `t_prd_product_prices` INSERTABLE |
| (b) OPTION-VARIANT | distinct 가격 ≥2 OR 선택옵션별 가격 | → **BLOCKED-DECISION**(Phase-0 DDL 대기). 직접가 강행 금지 |
| (c) DATA-GAP | 전 행 가격 공란(품절/준비중 그레이밴딩) | → **BLOCKED-DATA**(후니 input). 발명 금지 |

### 3.2 트랩 적발 실증 — 머그컵·사각손거울
- `머그컵`(PRD_000193): 화이트 6500 / 반투명 7500 / 투명 7500 = 3 source 행 2가 → **BLOCKED-DECISION**. (계획 §5 R-옵션변형의 표본 — 직접가로 넣으면 PK 충돌/데이터손실.)
- `사각손거울`(PRD_000186): S/M/L = 5000/5500/6000 → **BLOCKED-DECISION**.
- 반례(SINGLE 정당): `레더코스터`(PRD_000188): 원형90mm 행이 2개지만 둘 다 3300 단일가 → INSERTABLE 1행. `볼체인`(PRD_000006): 8색 행 전부 1000 → INSERTABLE 1행.

### 3.3 BLOCKED-DECISION 라우트(Phase-0 DDL, 컨텍스트 확정·미적용)
- **본체색/투명도 변형**(머그컵·핀버튼·폰스트랩 등) → 본체색=재질 합성(`.03` mat_cd) → component_prices(mat_cd) + 공식
- **용량/사이즈 변형**(워터북보틀·손거울·파우치 size) → 비치수 size 마스터 차원 → component_prices(siz_cd) + 공식
- **잉크색/선택옵션 변형** → CPQ option_item 가격(GAP-OPT)
- BLOCKED-DECISION = goods 변형 34 + accessory 변형 9 = **43행**(카드봉투 1건은 .05 분할로 해소 메모) = `BLOCKED_DECISION_option_variant.csv`.

---

## 4. 적재 순서 (FK 위상정렬)

```
[0] (선존재, 검증만) t_prd_products (73 prd_cd 전건 라이브 확인)
[1] t_prd_product_prices  ← 본 트랙 73행 (FK 부모 prd_cd 선존재). 단일 테이블, 단일 트랜잭션.
```
F8 바인딩은 `t_prd_product_price_formulas`(부모=prd_cd+frm_cd)이나 **차단으로 적재 0** → 적재순서 무관.

---

## 5. 적재 실행본 (멱등 UPSERT)

`load.sql`: 단일 `BEGIN … ROLLBACK`(인간 승인 시 COMMIT 교체). `INSERT … ON CONFLICT (prd_cd, apply_ymd) DO UPDATE SET unit_price, note, upd_dt=now()`. **reg_dt 컬럼 OMIT → DEFAULT now()**. VALUES 73행 = `load/t_prd_product_prices.csv`와 1:1 무드리프트(자동 대조 PERFECT).
- 멱등: 2-pass 시 1패스 INSERT 73 → 2패스 동일값 UPDATE(실변경 0). PK 자연키라 surrogate/IDENTITY 시퀀스 없음(round-5 setval 트랩 N/A).

---

## 6. C-1~C-9 준수 + 제약

| 게이트 | 상태 |
|--------|------|
| C-1 apply_ymd `yyyy-MM-dd` | PASS — 73행 전건 `2026-06-01` |
| C-9 NULL≠'' | PASS — 본 트랙 공란 컬럼 없음(reg_dt OMIT) |
| PK 유니크(CSV 내) | PASS — 73 distinct (prd_cd,apply_ymd), dup 0 |
| FK prd_cd 선존재 | PASS — 73/73 라이브 확인 |
| unit_price numeric | PASS — 73행 전건 정수 |
| reg_dt NOT NULL | PASS(설계) — OMIT으로 DEFAULT now() 발화 |
| dedup | PASS — INSERTABLE 73 distinct prd_cd, BLOCKED 버킷과 교집합 0 |

C-2~C-8(component_prices/formula 차원·코드)은 본 트랙(직접가 단일 테이블) 비해당.

---

## 7. 설계 결정 / 확인 필요 (침묵 처리 금지)

| # | 항목 | 내용 | 권고 |
|---|------|------|------|
| **FLAG-F7** | 트레싱지봉투 단가 | PRD_000283(.05) 단가 source가 "트래싱지 카드봉투"(.03, 명칭 상이 트래싱↔트레싱)의 160x110 20장 cell=6000. 디지털인쇄 추가상품 컬럼이 "트레싱지봉투 160x110 mm 20장"을 명시 참조 → 6000 채택하되 명칭·기준사이즈 후니 확인 | 6000 채택 + 확인 |
| **FLAG-F8** | F8 바인딩 전건 차단 | 계획="바인딩만"이나 라이브 plate↔인쇄비 커버 0 → 바인딩 시 가격 NULL 침묵. 본 트랙 0적재, digital-print-engine 3절/투명 차단 트랙 귀속 | 바인딩 보류(타 트랙) |
| **FLAG-F6** | 캘린더 책자형 여부 | 계획="벽걸이/엽서=책자형 가능". source 단일가 1개씩 → 직접가 채택. 후니가 페이지수별 단가 운영이면 재논의(현 source엔 단일가만) | 직접가 채택 |
| **DEC-VAR** | F1 옵션변형 52건(43+9) | Phase-0 DDL(본체색=재질/용량=size/잉크=CPQ) 미적용 → 직접가 불가. BLOCKED-DECISION 보류, 라우트 명기 | DDL 적용 후 별도 트랙 |
| **DEC-GAP** | 가격 공란 5 + 미등록 5 + 노트/플래너 10 | source 미가격(품절/준비중)·라이브 prd_cd 부재·source 슬라이스 밖 → 후니 input/상품등록/추가추출 | BLOCKED-DATA, 발명 금지 |

---

## 8. 라이브-vs-계획 모순 (능동 surface)

| # | 계획(price-211-track-plan.md) | 라이브/source 실측 | 처리 |
|---|------|------|------|
| M-1 | "F7 = 카드봉투(블랙/화이트), 트레싱지봉투 (3, 카테고리 링크 없음)" | .03 일반판(PRD_000003/004)과 **.05 분할판(PRD_000281/282/283)이 공존**. 계획의 3건 = .05 분할판에 정확 대응 | F7 INSERTABLE = .05 3건. .03판은 변형/matrix → BLOCKED |
| M-2 | "F8 → PRF_DGP 바인딩만(공식 존재 확인)" | 공식 존재하나 component_prices가 plate siz 0커버 → **바인딩만으로는 가격 NULL**. digital-print-engine이 이미 BLOCKED_siz로 분류 | F8 INSERTABLE 0, BLOCKED-OTHER-TRACK |
| M-3 | "F1 123 = goods-pouch 시트" | goods-pouch에 **103 prd_nm뿐**. 15건은 accessory 시트, 10건(노트/플래너)은 **두 시트 모두 밖** | accessory 흡수 + 노트/플래너 out-of-source BLOCKED |
| M-4 | "F1 22 blank 옵션변형/품절" | 실측: 진짜 무가격 공란 5 + 미등록(prd_cd부재) 5 — 22보다 적음(나머지는 옵션변형으로 가격이 다른 행에 존재) | 공란 5·미등록 5 정직 분리 |
