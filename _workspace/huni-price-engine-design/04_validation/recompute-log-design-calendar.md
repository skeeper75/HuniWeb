# recompute-log-design-calendar.md — 디자인캘린더 독립 재계산 로그 (hpe-validator·11번째 종단)

> **검증가(hpe-validator) 독립 실측 — 2026-06-22 라이브 읽기전용 SELECT + python 독립 역산 + 엔진 코드 직접 Read.**
> designer 주장 비신뢰·라이브/권위 verbatim으로 직접 재실측. codex 결과 비참조(독립성).
> 단가값=라이브/L1 verbatim 대조(designer 비정수 역산 날조 단가 없는지 적발). DB 쓰기 0.

---

## ★2차 재게이트 (2026-06-22) — codex D1/D2 적발의 독립 재검증 (1차 누락 시정)

> codex Phase5.5가 돈크리티컬 2건 적발·designer 보정 완료. **1차 검증이 놓친 부분**이므로 codex 판정 베끼지 말고 엔진계약·라이브 직접 재실측으로 재계산.

### D1 — 본체 정찰가 qty 의미 (엔진 코드 직접 Read·1차 누락 시정)

**1차 누락**: 1차 recompute §2.3에서 GC-DCAL-9=44,000을 "본체 정찰가(qty 무관)+우드 ×qty"로 **설계 자체값 재유도만** 했다. 본체를 qty 무관으로 본 것이 엔진계약 위반(저청구).

**엔진 코드 직접 확인(`raw/webadmin/webadmin/catalog/pricing.py:180-192`)**:
```python
# 단가형: unit_price(장당가) × 수량.  / 합가형: unit_price ÷ 구간 min_qty × 수량.
if prc_typ == PRC_TYPE_TOTAL:        # 합가형(.02)
    per_item = up / Decimal(base);  return per_item * q, per_item
# 기본 = 단가형(.01)
return up * q, up                    # ← .01 단가형 = unit_price × qty (min_qty 무관)
```
+ `widget-price-contract.md` W-3: `min_qty`는 티어 비교 키(`_tier_order_val(min_qty)=qty`)이지 **qty-불변 신호 아님**.
+ `price-flow-map.md:106` EV ④: "단가형×qty / 합가형÷min_qty×qty".

→ **`.01 단가형`은 min_qty=1이든 아니든 항상 `unit_price × qty`.** 본체 정찰가가 .01이면 **정찰가 × qty**(qty 무관 아님).

**독립 재계산(엔진 `up*q` 적용)**:

| 골든 | 본체 | 우드거치대 | **재계산값** | 1차 오류값 | 판정 |
|------|------|-----------|------------:|-----------:|------|
| GC-DCAL-1~7 (qty=1) | 정찰가×1 | — | 10400/9700/6500/6500/4000/9900/24000 | (동일) | ✅ **값 불변** |
| GC-DCAL-8 (qty=1) | 4,000×1 | 4,000×1 | **8,000** | (동일) | ✅ 불변 |
| GC-DCAL-9 (qty=10) | 4,000×10=40,000 | 4,000×10=40,000 | **80,000** | 44,000 | ✅ designer 교정 정합 |

★ GC-DCAL-9 = **80,000 정합**(본체 40,000+우드 40,000). 1차 44,000은 본체 qty-불변 가정 = **저청구 36,000원 누락**(codex D1 적발 정당). GC-DCAL-1(탁상)도 qty=10이면 104,000(10,400 고정 시 93,600 저청구). 신규 가드 G-DCAL-QTY로 명문화됨. **GC-DCAL-1~7/GC-DCAL-8(qty=1)은 ×1이라 값 불변**(정찰가 verbatim 보존).

### D2 — 엽서 editor_yn=N 라우팅 (라이브 직접 SELECT)

**라이브 재실측**:
```sql
SELECT prd_cd, editor_yn FROM t_prd_products WHERE "MES_ITEM_CD" LIKE '007-%';
-- 108=Y·109=Y·110(엽서)=N·111=Y·112=Y
```
→ **엽서 PRD_000110 editor_yn=N** 확인. 1차 설계 §3.1이 "editor_yn=Y → PRF_DCAL_* 라우팅"을 자연 키로 삼았으나 **엽서는 editor_yn=N이라 editor_yn=Y 단독 라우팅 시 엽서(가격포함 시트 등재·inline 4000) 누락**(내부 모순). codex D2 적발 정당.

**designer 교정 점검**: 라우팅 신호 = "가격포함 시트 등재 + 상품별 PRF_DCAL_* 명시 바인딩(엽서 포함 5상품)"·editor_yn 보조 → 엽서(110)도 PRF_DCAL_POSTCARD 명시 바인딩으로 닫힘(§5 바인딩표 110 행 실재). **엽서 누락 해소 확인**.

### 불변 확인 (보정이 qty/라우팅에 국한)

| 항목 | 1차 GO | 2차 재실측 | 불변? |
|------|--------|-----------|-------|
| inline 역산 비정수(BLOCKED) | 1.313/0.486/1.285/1.574/6.104 | 동일(§1) | ✅ |
| G-DCAL-DUAL 결판 | product_prices 0·바인딩 0·PRF 0 | 동일 | ✅ |
| G-PRODPRICE 가드 | product_prices 0행 | 동일 | ✅ |
| 정찰가 verbatim(qty=1) | 10400 등 | 동일 | ✅ |
| 신규 mint | 공식5+comp1 | 동일 | ✅ |

★ 보정은 **qty 의미(×qty)·라우팅 키(시트 등재+명시 바인딩)에 국한**·위 1차 GO 항목 전건 불변. 추가 결함 없음.

---

## 0. 재계산 입력 단가 (라이브 verbatim 실측·designer echo 금지)

라이브 `t_prc_component_prices` 직접 SELECT(2026-06-22):

| comp | 차원 | 라이브 단가 | designer 인용 | 일치 |
|------|------|------------:|--------------:|------|
| COMP_PRINT_DIGITAL_S1 | SIZ_000499(국4절)·단면 POPT_000001·q1 | **3,000** | 3,000 | ✅ |
| COMP_PRINT_DIGITAL_S1 | SIZ_000499(국4절)·양면 POPT_000002·q1 | **4,000** | 4,000 | ✅ |
| COMP_PAPER | MAT_000107(몽블랑190g)·SIZ_000499·q1 | **112.58** | 112.58 | ✅ |
| COMP_BIND_CAL_DESK220 | PROC_000100·q1 | **5,000** | 5,000 | ✅ |
| COMP_BIND_CAL_DESKMINI | PROC_000102·q1 | **4,500** | 4,500 | ✅ |
| COMP_BIND_CAL_WALL | PROC_000099·q1 | **5,000** | 5,000 | ✅ |

★ **designer가 역산에 쓴 단가는 전부 라이브 verbatim과 일치 — 비정수 역산으로 단가를 날조하지 않았음**(E1/E4 핵심 가드 통과).
재현 SQL:
```sql
SELECT print_opt_cd, plt_siz_cd, min_qty, unit_price FROM t_prc_component_prices
 WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND min_qty=1 AND print_opt_cd IN ('POPT_000001','POPT_000002');
SELECT mat_cd, plt_siz_cd, unit_price FROM t_prc_component_prices
 WHERE comp_cd='COMP_PAPER' AND unit_price BETWEEN 100 AND 120;  -- MAT_000107=112.58
SELECT comp_cd, proc_cd, min_qty, unit_price FROM t_prc_component_prices
 WHERE comp_cd LIKE 'COMP_BIND_CAL%' AND min_qty=1;
```

---

## 1. ★E4 핵심 — inline 역산 독립 재계산 (비정수 입증 → BLOCKED 정당)

산식: `유효판수 = (inline − 제본비) / (인쇄단가 + 112.58 용지)` — 라이브 단가 verbatim 대입·python 독립 산출(designer echo 아님).

| 상품(siz·면) | inline(L1) | 제본비 | 잔여 | per_plate | **유효판수(재계산)** | 페이지 | 정수? |
|--------------|-----------:|-------:|-----:|----------:|--------------------:|------:|------|
| 탁상220 양면 | 10,400 | 5,000 | 5,400 | 4,112.58 | **1.313** | 30 | ❌ |
| 미니 양면 | 6,500 | 4,500 | 2,000 | 4,112.58 | **0.486** | 26 | ❌ |
| 엽서 단면 | 4,000 | 0 | 4,000 | 3,112.58 | **1.285** | 12 | ❌ |
| 벽걸이 단면 | 9,900 | 5,000 | 4,900 | 3,112.58 | **1.574** | 13 | ❌ |
| 와이드 단면 | 24,000 | 5,000 | 19,000 | 3,112.58 | **6.104** | 13 | ❌ |

**판정 = BLOCKED 정당(designer 결론 지지)**:
- 유효판수 5건 **전부 비정수** — 검증가 독립 python 재산출이 designer inline-authority-evidence §1.3 값과 동일(1.313/0.486/1.285/1.574/6.104).
- 페이지수(30/26/12/13)와 정수 배수 관계 없음(미니 0.486판으로 26P 물리 불가).
- ∴ inline = 정찰가 스냅샷·단가행 합산 결과 아님 → 추측 단가 INSERT 금지 = **정직 BLOCKED**.
- ★**포토북 대비**: 포토북은 per2p가 imposition cost-driven 정수 선형(4-up=300<2-up=500/600<1-up=1000)으로 FORMULA 재현 성공. 디자인캘린더는 비정수 → 정찰가. **designer의 두 시트 분기(포토북=FORMULA·디자인캘린더=BLOCKED)는 독립 재계산으로 타당 확인**.

---

## 2. ★E6 골든 재현 — 정찰가 채택 ① 경로 (.03 가정·허용오차 0)

> ★전제: inline 정찰가 채택(G-DCAL-DUAL ①)을 인간이 비준할 경우의 골든. 본체 정찰가 = 사이즈 차원 룩업. 단가 = L1 CSV verbatim 직독.
> ★**[2차 재게이트 정정]** 아래 §2.1~2.3의 "qty 무관 고정가" 표현은 **D1 적발로 정정됨** — `.01 단가형`은 항상 `정찰가 × qty`(상단 2차 재게이트 §D1 참조). GC-DCAL-1~7/8은 qty=1 기준이라 값은 같으나, GC-DCAL-9(qty=10)는 **80,000**(44,000 아님).

### 2.1 본체 정찰가 골든 (GC-DCAL-1~7) — L1 verbatim vs 골든값

| 골든 | siz_cd | **L1 CSV verbatim** | 골든 기대값 | 재현(siz 룩업·qty 무관) | 대조 |
|------|--------|--------------------:|------------:|------------------------:|------|
| GC-DCAL-1 | 220x145 | 10,400 (row2) | 10,400 | 10,400 | ✅ 0 |
| GC-DCAL-2 | 130x220 | 9,700 (row3) | 9,700 | 9,700 | ✅ 0 |
| GC-DCAL-3 | 90x100 | 6,500 (row6) | 6,500 | 6,500 | ✅ 0 |
| GC-DCAL-4 | 148x60 | 6,500 (row7) | 6,500 | 6,500 | ✅ 0 |
| GC-DCAL-5 | 145x145 | 4,000 (row8) | 4,000 | 4,000 | ✅ 0 |
| GC-DCAL-6 | 210x297 | 9,900 (row10) | 9,900 | 9,900 | ✅ 0 |
| GC-DCAL-7 | 300x625 | 24,000 (row11) | 24,000 | 24,000 | ✅ 0 |

★ GC-DCAL-1 vs GC-DCAL-2(10,400 vs 9,700)가 **siz_cd 정찰가 분기 입증** — 단일가로 뭉개면 700원 오차(G-DCAL-SIZE-PRICE). L1 row2/row3 가격 칸이 실제로 서로 다른 값(10400≠9700)임을 CSV 직독으로 재확인.

### 2.2 ★G-PRODPRICE 가드 골든 (GC-DCAL-8) — 본체 + 우드거치대 합산

| 항목 | 값 | 출처 |
|------|----|------|
| 본체 COMP_DCAL_FIXED(145x145) | 4,000 | L1 row8 가격 verbatim |
| add-on 우드거치대 ×qty=1 | 4,000 | L1 row8 추가가격 verbatim |
| **골든 기대값(formula 합산)** | **8,000** | 4,000 + 4,000 |
| ★product_prices 직접적재 시 silent 우회 오답 | **4,000** | FORMULA 통째 스킵 → add-on 누락 |

**G-PRODPRICE 가드 재현(라이브 근거)**:
- 라이브 `t_prd_product_prices` **전체 0행·캘린더 0행** 실측 → 본체를 formula 바인딩으로 두면 선점 위험 0(현재). 그러나 정찰가를 product_prices에 INSERT하면 엔진 가격소스 우선순위 PRODUCT_PRICE→FORMULA로 FORMULA(=본체 정찰가 comp + 우드거치대 add-on Σ) 통째 우회 → 4,000만 출력(우드거치대 4,000 누락).
- ∴ **8,000(formula 정답) vs 4,000(product_prices 우회 오답)** = G-PRODPRICE 가드의 핵심 입증. designer "본체도 .03 고정가형 comp로 formula 바인딩·product_prices INSERT 금지" 결정이 이 가드를 정확히 충족.
- 재현 SQL: `SELECT count(*) FROM t_prd_product_prices;` → 0 (전체 테이블 비어있음 = 선점 가드 자동 충족 토대).

### 2.3 GC-DCAL-9 (우드거치대 ×qty=10·개당 가산 가설)

| 항목 | 값 |
|------|----|
| 본체(qty 무관 정찰가) | 4,000 |
| 우드거치대 4,000 × 10 | 40,000 |
| **기대값(개당 가산)** | **44,000** |

🟡 개당/주문당 컨펌(Q-DCAL-FIN) 미해소 — 골든 자체는 개당 가산 가설로 일관. 가설 의존이므로 CONDITIONAL(설계가 정직하게 가설 표기).

---

## 3. ★중대 적발 — 우드거치대 add-on 골든의 그릇(COMP_CALOPT_STAND) 라이브 부존재

골든 GC-DCAL-8/9가 의존하는 **COMP_CALOPT_STAND·우드거치대 단가행 4000은 라이브에 존재하지 않는다**(실측).

재현 SQL + 결과:
```sql
SELECT comp_cd FROM t_prc_price_components WHERE comp_cd='COMP_CALOPT_STAND';  -- 0행
SELECT * FROM t_prc_component_prices WHERE comp_cd='COMP_CALOPT_STAND';        -- 0행
-- 거치/우드 관련 comp 전수 → POSTER 계열만(COMP_POSTEROPT_*·캘린더용 거치 comp 없음)
SELECT comp_cd, comp_nm FROM t_prc_price_components
 WHERE comp_cd LIKE '%CALOPT%' OR comp_cd LIKE '%STAND%' OR comp_nm LIKE '%우드%' OR comp_nm LIKE '%거치%';
```
결과: COMP_CALOPT_STAND 0행. 거치 관련은 COMP_POSTER_FRAMELESS_WOOD·COMP_POSTEROPT_PET_BANNER_STAND_* 등 **포스터/배너 계열뿐 — 캘린더 우드거치대 comp·우드거치대 4000 단가행 부재**.

**진상**: COMP_CALOPT_STAND는 **캘린더 종단(engine-design-calendar §4 / golden-cases-calendar §2)이 "신규 mint comp"로 명시한 미적재 그릇**이다. 캘린더 종단도 아직 DB 미적재(인간 승인 후 dbmap 위임)이므로 라이브에 없는 것이 정상.

→ ∴ 골든 GC-DCAL-8(8,000)은 **"캘린더 종단의 COMP_CALOPT_STAND가 먼저 mint·우드거치대 4000 단가행 적재된 후"에만** 재현 가능. 현 라이브로는 우드거치대 단가행 자체가 0행이라 add-on 부분 재현 불가(본체 정찰가 부분은 L1 verbatim으로 재현 가능). **이는 단가값 오류가 아니라 의존 그릇 미적재(WIRE/MINT 선행 의존)** — recompute 가드로 명시(아래 §4).

---

## 4. 골든 재현 종합 (검증가 판정)

| 골든 | 대상 | 기대값 | 재현 방법 | 재현 상태(검증가) |
|------|------|-------:|-----------|-------------------|
| GC-DCAL-1~7 | 본체 정찰가 siz 룩업 | 10400/9700/6500/6500/4000/9900/24000 | L1 CSV verbatim 직독 | ✅ **허용오차 0**(정찰가 채택 ① 비준·.03 코드 신설 전제) |
| GC-DCAL-8 | 본체+우드거치대 formula 합산 | 8,000(=4000+4000) | .03 본체 + .01 add-on Σ | 🟡 **조건부**(본체 4000 verbatim 재현 OK·우드거치대 4000은 캘린더 COMP_CALOPT_STAND 신규 mint 선행 의존·현 라이브 0행) |
| GC-DCAL-9 | 우드거치대 ×qty=10 | 44,000 | .01 ×qty | 🟡 가설(Q-DCAL-FIN 개당/주문당 미해소) |
| inline 합산 산식 | inline을 인쇄+용지+제본 재구성 | (재현 불가) | — | ❌ **BLOCKED 정직**(§1 비정수 입증·추측 단가 0) |

**갈린 지점 지목**:
1. 본체 정찰가 골든(GC-DCAL-1~7)은 L1 verbatim 직독으로 허용오차 0 — 단가값 정합 완벽.
2. GC-DCAL-8 add-on 부분의 우드거치대 단가행이 라이브 0행 = **그릇 미적재(MINT 선행)** 이지 단가 오류 아님. 본체 정찰가 4000은 재현, 우드거치대 4000은 캘린더 종단 mint 후 재현 가능.
3. inline 산식 골든은 비정수로 재현 불가 = BLOCKED 정직(designer 날조 0).

---

## 5. 라이브 실측 종합 (G-DCAL-DUAL 결판 재확인)

| 검사 | 재현 SQL | 라이브 결과 | designer 주장 | 일치 |
|------|----------|------------|---------------|------|
| 5 prd_cd 존재·editor_yn | `SELECT prd_cd,editor_yn FROM t_prd_products WHERE "MES_ITEM_CD" LIKE '007-%'` | 108/109/111/112=Y·110=N·전부 PRD_TYPE.04·use_yn=Y·del_yn=N | 동일 | ✅ |
| product_prices 0행 | `SELECT count(*) FROM t_prd_product_prices` | 전체 0·캘린더 0 | 0행 | ✅ |
| 공식 바인딩 0건 | `SELECT count(*) FROM t_prd_product_price_formulas WHERE prd_cd IN (108~112)` | 0 | 0건 | ✅ |
| PRF_CAL_*/PRF_DCAL_* 부존재 | `SELECT count(*) FROM t_prc_price_formulas WHERE frm_cd LIKE 'PRF_CAL%' OR 'PRF_DCAL%'` + 이름 캘린더/달력 | 0건 | 부존재 | ✅ |
| 봉투 독립 PRD_000005 | `SELECT * FROM t_prd_products WHERE prd_cd='PRD_000005'` | 012-0008·캘린더봉투·PRD_TYPE.03·use_yn=Y | 실재 | ✅ |
| sets 캘린더 0행 | `SELECT count(*) FROM t_prd_product_sets WHERE prd_cd IN (108~112)` | 0 | 0행 | ✅ |
| option_groups 0행 | `SELECT count(*) FROM t_prd_product_option_groups WHERE prd_cd IN (108~112)` | 0 | 0행 | ✅ |

★ **G-DCAL-DUAL "이중 정의 충돌은 현 라이브엔 미존재"(둘 다 0)** = designer §2.2 주장이 라이브 직접 재실측으로 전건 확인. designer 결론을 베끼지 않고 독립 SELECT로 교차(E7 충족).

---

## 6. 검증가 독립성 진술 (E7)

- inline 역산을 designer echo가 아닌 **라이브 단가 verbatim python 독립 산출**(§1) — 입력 단가가 라이브와 일치함을 별도 SELECT로 확인 후 재계산.
- G-DCAL-DUAL 결판(product_prices 0·바인딩 0·PRF 부존재)을 **라이브 직접 SELECT 7건**으로 재실측(§5).
- ★독립 적발: COMP_CALOPT_STAND·.03 코드값 라이브 부존재(§3·아래 verdict E2) — designer가 "재사용·실재"로 표현한 그릇이 실은 캘린더 종단 미적재 신규 mint임을 라이브로 적발(designer 주장 무비판 수용 안 함).
- codex(Phase 5.5) 결과 비참조·자기 실측으로만 판정.
