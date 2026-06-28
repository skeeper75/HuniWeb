# 포토북(PRD_000100) 완제품가 가격공식 설계 — 094 엽서북 동형

작성: 2026-06-29 · 읽기전용 분석 + DRY-RUN 완료 · 실 COMMIT/DDL 0
산출 SQL: `photobook-price-260629-dryrun.sql`(검증 완료) · `photobook-price-260629-fix.sql`(COMMIT 준비·★사람 검토용)

---

## 0. 한눈 요약

| 항목 | 값 |
|---|---|
| 부모 상품 | PRD_000100 (셋트 완제품) — 현재 완제품가 공식 미바인딩 → 견적 0 |
| 신규 공식 | `PRF_PHOTOBOOK_FIXED` (1) |
| 신규 구성요소 | `COMP_PHOTOBOOK_BASE` (1) · comp_typ=.06 · prc_typ=.01(단가형) |
| use_dims | `["siz_cd", "opt_cd", "min_qty"]` |
| 신규 단가행 | 11 (권위 11조합 verbatim) |
| 신규 바인딩 | PRD_000100 ← PRF_PHOTOBOOK_FIXED (1) |
| 표지타입 차원 | **opt_cd** (CVR_HARD / CVR_LHARD / CVR_SOFT) — opt_cd는 FK 없음 |
| ★page 모델 | **옵션D — 기본24P만 정확. page추가가 미반영(BLOCKED·저청구·열린 이슈)** |
| DRY-RUN | RC=0 · PK충돌 0 · 단가행 11 · 멱등(2차 재실행 0행) |

---

## 1. 권위 매트릭스 (출처: `huni-dbmap/24_master-extract-260610/photobook-l1.csv` "포토북(가격포함)", verbatim)

가격공식 = `(기본24P가 + ⌈(page−24)/2⌉ × 추가2P당) × copies(부수)`. page 24~150, 증가 2.

| 사이즈 | siz_cd | 표지타입 | opt_cd(설계) | 기본24P | 추가2P당 |
|---|---|---|---|---|---|
| 8×8 200×200 | SIZ_000269 | 하드커버 | CVR_HARD | 15000 | 500 |
| 8×8 | SIZ_000269 | 레더하드커버 | CVR_LHARD | 23000 | 500 |
| 8×8 | SIZ_000269 | 소프트커버 | CVR_SOFT | 12000 | 500 |
| 10×10 250×250 | SIZ_000274 | 하드커버 | CVR_HARD | 22000 | 1000 |
| 10×10 | SIZ_000274 | 레더하드커버 | CVR_LHARD | 32000 | 1000 |
| 10×10 | SIZ_000274 | 소프트커버 | — | **빈칸=미제공(단가행 없음·BLOCKED)** | — |
| A5 148×210 | SIZ_000170 | 하드커버 | CVR_HARD | 12000 | 300 |
| A5 | SIZ_000170 | 레더하드커버 | CVR_LHARD | 19000 | 300 |
| A5 | SIZ_000170 | 소프트커버 | CVR_SOFT | 10000 | 300 |
| A4 210×297 | SIZ_000172 | 하드커버 | CVR_HARD | 16000 | 600 |
| A4 | SIZ_000172 | 레더하드커버 | CVR_LHARD | 26000 | 600 |
| A4 | SIZ_000172 | 소프트커버 | CVR_SOFT | 13000 | 600 |

→ 가격 있는 조합 = **11개**(단가행 생성). 10×10 소프트커버는 권위 빈칸 → 생성 금지.
사이즈 4 siz_cd는 부모 t_prd_product_sizes 등록값과 1:1 정확 대응(실측 확인).

---

## 2. 094 동형 설계 (공식 · 구성요소 · 단가행 · 바인딩)

### 2.1 094 레퍼런스 (라이브 실측)
- 공식 `PRF_PCB_FIXED` ← `COMP_PCB_S1_20P`(seq1) + `COMP_PCB_S2_20P`(seq2), 둘 다 addtn_yn=Y.
- comp_typ=`PRC_COMPONENT_TYPE.06`(완제품가), prc_typ=`PRICE_TYPE.01`(단가형).
- use_dims=`["siz_cd","min_qty","print_opt_cd"]`. print_opt_cd로 단면/양면 component를 갈랐다.
- 단가형 .01 → engine `component_subtotal`: **unit_price × qty(=copies)**. (094: per_item 6900 × copies 10 = 69000 검증됨)
- set_eval = `evaluate_price({"prd_cd":set_prd}, set_selections, copies)` → 094는 set_eval 하나로 완제품가 전체 산출.

### 2.2 포토북 설계 (동형 + 표지타입 축 추가)

```
PRF_PHOTOBOOK_FIXED  "포토북 사이즈/표지타입별 기본가(24P)"
  └─ COMP_PHOTOBOOK_BASE (disp_seq 1, addtn_yn Y)
        comp_typ_cd = PRC_COMPONENT_TYPE.06   (094 완제품가 동일)
        prc_typ_cd  = PRICE_TYPE.01           (단가형 → unit_price × copies)
        use_dims    = ["siz_cd", "opt_cd", "min_qty"]
        단가행 11 = (siz_cd × opt_cd[표지타입]) 정확매칭 + min_qty=1 단일밴드
바인딩: PRD_000100 ← PRF_PHOTOBOOK_FIXED  (apply_bgn_ymd 2026-06-06)
```

094와의 차이: 094는 표지타입 같은 3분기 축이 없어 component를 분리(S1/S2)했지만, 포토북은 표지타입을 **opt_cd 단일 차원**으로 가른다(아래 §과제1 근거). 따라서 component는 1개로 충분.

### 2.3 엔진 계약 정합 (pricing.py 실측)
- set_eval이 set_selections를 selections로 그대로 받는다 → 위젯이 `{siz_cd, opt_cd}`를 set_selections에 넣으면 단가행 NON_QTY_DIMS 정확매칭.
- `match_component`: siz_cd·opt_cd는 NON_QTY_DIMS(정확매칭, 행값 NULL=와일드카드). min_qty는 TIER(하한). 11행 중 손님의 (siz, 표지타입) 하나만 매칭 → 단일행 → ERR_AMBIGUOUS 없음.
- 손님이 opt_cd 미선택 시 11행 전부 매칭 후보 → combos 2개 이상 → ERR_AMBIGUOUS. 즉 **표지타입 필수**(위젯 계약). 094도 print_opt 미선택 시 양 component 모두 no-match=0이었던 것과 같은 "필수 선택" 성격.

---

## 3. ★page 선형증가 모델 결정 (최대 난제·돈크리티컬)

### 3.1 엔진 한계 (구조적 사실, pricing.py 정독)
`component_subtotal(prc_typ, unit_price, tier_min_qty, qty)`의 곱셈 인자는 **오직 `qty(=copies)`와 `tier_min_qty`** 둘뿐이다. page는 어디에도 곱해질 수 없다.
- selections에 page를 넣어도 → NON_QTY_DIMS/dim_vals **정확매칭**으로만 쓰임(곱셈 아님).
- min_qty(TIER)는 `_tier_order_val`에서 **qty(copies)에 고정** — page를 티어로 못 쓴다.
- evaluate_set_price 시그니처는 copies 하나만 qty로 받는다 → page를 별도 곱셈 수량으로 못 넘긴다.

### 3.2 옵션별 판정

| 옵션 | 가능? | 판정 |
|---|---|---|
| A: 기본가 comp + page추가 comp | △ | page추가를 곱하는 메커니즘 부재. page추가 comp를 둬도 `× copies`만 됨(× page-step 불가) → 잘못된 곱 |
| B: page-step을 copies처럼 별도 호출 | ✗ | evaluate_set_price는 copies 1개만 qty. page-step 주입 시그니처 없음 |
| C: page를 dim_vals/min_qty 트릭 | ✗ | dim_vals=정확매칭(곱셈 아님). min_qty=copies 고정. page 64값 enumerate는 비현실+선형증가 본질 안 맞음 |
| **D: 기본24P만 적재·page추가 BLOCKED** | ✓ | **채택**. 기본24P(page=24)는 정확. page>24는 미반영 |

### 3.3 ★결정 = 옵션D + 명시적 저청구 경고
- **기본24P 단가행 11개만 적재**(권위 verbatim). page=24일 때 100% 정확.
- **page>24 추가가는 엔진 단일호출로 표현 불가** → 미반영 = **저청구**.
  - 예: A4 하드커버 page=50 copies=1 → 권위 = 16000 + ⌈(50-24)/2⌉×600 = 16000 + 13×600 = 23800. 엔진 산출 = 16000. **차액 7800 저청구**.
  - page=150(최대)이면 ⌈126/2⌉=63 step → A4 하드커버 16000+63×600=53800 vs 엔진 16000. **차액 37800 저청구**(돈크리티컬).
- 이 한계는 **엔진/위젯 확장 과제**(열린 이슈 §6). 값 날조·억지 배선으로 가짜 정합을 만들지 않는다.

### 3.4 page 추가가 해결 경로(권고·미구현)
page 선형증가는 본질적으로 "기본 + 단위×수량" 2-term 가격이다. 엔진 단일호출로 풀려면 둘 중:
1. **위젯/시뮬레이터 선계산**: page-step 수를 copies처럼 별도 qty로 받는 `page_add` 구성요소 + 엔진 시그니처 확장(C트랙·개발팀). 가장 정석.
2. **page 구간 enumerate**: page 24~150을 dim_vals로 64값 단가행(조합당 64행 × 11조합 = 704행). 엔진 변경 없으나 데이터 폭증+증가2 본질 왜곡. 비권장.
→ §6 열린 이슈로 등록. 현 설계는 (1)을 권고하되 미구현이므로 기본24P만 정확.

---

## 4. 표지타입 차원 결정 (과제1)

### 4.1 후보 비교
| 후보 | 방식 | 판정 |
|---|---|---|
| (a) opt_cd 차원 | set_selections.opt_cd=표지타입코드, NON_QTY_DIM 정확매칭 | **채택** |
| (b) 094식 component 분리 | 표지타입마다 COMP_PHOTOBOOK_HARD/LEATHER/SOFT 3개 | 비채택(comp 3개+배선 3개 과다·단가행 분산) |
| (c) 표지 sub_prd_cd 신호 | 표지 구성원 코드로 분기 | 비채택(엔진은 set_selections만 봄·sub_prd_cd는 set_eval에 안 들어감) |

### 4.2 채택 근거
- **search-before-mint**: opt_cd는 component_prices의 NON_QTY_DIMS 정식 차원(094 같은 단가형이 print_opt_cd를 쓴 것과 동형). 표지타입 = 사이즈와 직교하는 비-수량 선택축 → opt_cd가 자연.
- **★opt_cd는 FK 제약이 없다**(실측: siz_cd/mat_cd/clr_cd/proc_cd/print_opt_cd/plt_siz_cd만 FK). 따라서 표지타입 코드값을 자유롭게 부여 가능 → 별도 코드마스터 DDL 불요.
- 표지타입 전용 기존 opt_cd 코드값은 **부재**(search 완료) → 신규 의미값 `CVR_HARD`/`CVR_LHARD`/`CVR_SOFT` mint. 의미식별자라 진단·가독성 우수.
- 단일 component(b 대비)라 단가행이 한 곳에 모이고 ERR_AMBIGUOUS 없음(siz_cd×opt_cd 조합이 11행 모두 유니크).

### 4.3 위젯 계약 (열린 이슈 — CPQ 연결)
- 위젯/시뮬레이터가 표지타입을 set_selections에 `opt_cd=CVR_HARD` 형태로 보내야 한다.
- 현재 부모 PRD_000100은 옵션그룹 미설정(손님이 표지 구성원을 members에 넣어 선택). 위젯이 "표지 구성원 선택"을 set_selections.opt_cd로도 매핑해야 가격이 맞는다 → **CPQ 옵션 레이어 연결 필요**(t_prd_product_option_items에 표지타입→opt_cd 매핑). §6 열린 이슈.
- 대안(dim_vals `cover_type` 키)도 가능하나, opt_cd가 엔진 1급 차원이라 진단·CPQ 정합이 우월 → opt_cd 채택. dim_vals는 백업안.

---

## 5. 수기 검산표 (설계 단가행 ↔ 권위 11조합, copies=1·page=24 기준)

prc_typ .01 단가형: `subtotal = unit_price × copies`. min_qty=1 단일밴드 → copies≥1이면 unit_price 그대로(per_item).
page=24(기본)일 때 권위 = 기본24P. copies=1이면 set_eval contribution = unit_price.

| # | siz_cd | opt_cd | 설계 unit_price | 권위 기본24P | copies=1 산출 | 일치 |
|---|---|---|---|---|---|---|
| 1 | SIZ_000269 | CVR_HARD | 15000 | 15000 | 15000 | ✅ |
| 2 | SIZ_000269 | CVR_LHARD | 23000 | 23000 | 23000 | ✅ |
| 3 | SIZ_000269 | CVR_SOFT | 12000 | 12000 | 12000 | ✅ |
| 4 | SIZ_000274 | CVR_HARD | 22000 | 22000 | 22000 | ✅ |
| 5 | SIZ_000274 | CVR_LHARD | 32000 | 32000 | 32000 | ✅ |
| — | SIZ_000274 | (소프트) | — 미생성 | 빈칸 | (매칭0) | ✅ BLOCKED |
| 6 | SIZ_000170 | CVR_HARD | 12000 | 12000 | 12000 | ✅ |
| 7 | SIZ_000170 | CVR_LHARD | 19000 | 19000 | 19000 | ✅ |
| 8 | SIZ_000170 | CVR_SOFT | 10000 | 10000 | 10000 | ✅ |
| 9 | SIZ_000172 | CVR_HARD | 16000 | 16000 | 16000 | ✅ |
| 10 | SIZ_000172 | CVR_LHARD | 26000 | 26000 | 26000 | ✅ |
| 11 | SIZ_000172 | CVR_SOFT | 13000 | 13000 | 13000 | ✅ |

**11/11 권위 일치(page=24·copies=1).** copies=N이면 ×N(예: A4 하드 copies 10 = 160000).
※ page>24는 §3.3대로 저청구(설계 한계·열린 이슈).

검산 2(copies 곱): A4 하드 copies 10 page 24 → 권위 16000×10=160000, 엔진 unit_price 16000 ×copies 10 = 160000 ✅.

---

## 6. DRY-RUN 결과 (psql -f 실행 검증)

```
BEGIN
INSERT 0 1   (공식)
INSERT 0 1   (구성요소)
INSERT 0 1   (배선)
INSERT 0 11  (단가행)
INSERT 0 1   (바인딩)
--- 단가행 카운트: 11 ---
ROLLBACK    (실제 변경 0)
```
- **PK충돌 0** · 단가행 정확 11행(10×10 소프트커버 제외) · 권위 verbatim 일치.
- **멱등 검증**: INSERT 블록 2회 실행 → 1차 1/1/1/11/1, 2차 전부 INSERT 0 0(NOT EXISTS 가드) → 최종 카운트 formula1/component1/wiring1/dprice11/binding1. 중복 0.
- ★IDENTITY 시퀀스 stale 발견(last_value 40329 < MAX 40332). DRY-RUN은 comp_price_id 명시부여로 회피, **fix.sql은 setval 동기화 정석** 사용.

---

## 7. 열린 이슈 (BLOCKED / 위젯·엔진 확장 과제)

| # | 이슈 | 영향 | 경로 |
|---|---|---|---|
| OI-1 | **page 추가가 미반영 = 저청구** | page>24에서 차액(page150 A4하드 −37800) | 엔진 시그니처 확장(page_add qty 별도) C트랙·개발팀. dbm-price-arbiter 심의 |
| OI-2 | 10×10 소프트커버 미제공 | 손님이 선택 시 매칭0(견적불가) | 권위 빈칸=정상. 위젯이 해당 조합 비활성화 필요 |
| OI-3 | 표지타입 → opt_cd CPQ 연결 부재 | 위젯이 set_selections.opt_cd를 보내야 가격 매칭 | t_prd_product_option_items에 표지타입→opt_cd 매핑(dbmap CPQ 트랙) |
| OI-4 | 실 simulate_set 가격검증 미수행 | DRY-RUN은 미COMMIT이라 시뮬레이터(별 connection)서 안 보임 | COMMIT 후 사람이 simulate_set 실호출 검증(§fix.sql 주석) |

---

## 8. 안전 준수
- 읽기전용 SELECT + DRY-RUN(BEGIN/ROLLBACK)만. 실 COMMIT/DDL/INSERT-COMMIT 0. webadmin 코드수정 0. git 커밋 0.
- 단가 = 권위 가격표(260610) verbatim(날조 0). 10×10 소프트커버 미제공 = BLOCKED 명시.
- search-before-mint: opt_cd 차원 재사용(신규 코드값만 mint·FK 없음 확인). 094 패턴 채번(PRF_<X>_FIXED, COMP_<X>_BASE).
- fix.sql은 ★사람 검토용·자동 실행 금지(ROLLBACK 기본값).
