# PRF_BIND_SUM 제본 다종-1배선 교정 (A2 C4-D01 · codex CONFIRMED)

> 작성 2026-06-26 · 권위[HARD]=인쇄상품 가격표 260527 제본비 표(`06_extract/price-binding-l1.csv` B01) verbatim.
> 라이브 읽기전용 SELECT 실측 · DB 미적재(설계·DRY-RUN까지·실 COMMIT은 인간 승인).
> 선례 계승 = `28_price-arbitration/PRF_BIND_SUM/remediation-plan.md`(round-18+ 2026-06-15, A안 권고).
> 산출 짝 = `bind-sum-fix.sql`(멱등 교정) · `bind-sum-dryrun.sql`(ROLLBACK 검증).

---

## 0. 한 줄 결론

`PRF_BIND_SUM` 공유공식에 **중철 제본 comp(`COMP_BIND_JUNGCHEOL`, proc=PROC_000018) 1개만 배선** → 무선/PUR/트윈링 책자는 자기 제본 proc(019/020/021)로 단가행을 못 찾아 **제본비 0원 silent drop**(과소청구). 교정 = **A안(제본방식별 공식 분리)** — 책자별 자기 제본공식 1:1 바인딩. 단가행은 이미 verbatim 정확 → **공식/배선/바인딩만** 교정(단가 불변·DDL 0).

---

## 1. 결함 근본원인 (라이브 실측)

### 1-1. 현재 배선 (실측)
```
t_prc_price_formulas:        PRF_BIND_SUM (제본 합산형) use_yn=Y
t_prc_formula_components:    PRF_BIND_SUM ← COMP_BIND_JUNGCHEOL (disp_seq 1, addtn_yn Y)   ← 이게 유일
t_prd_product_price_formulas: PRD_000068·069·070·071  전부 → PRF_BIND_SUM
```
4책자가 같은 공식을 공유하는데 그 공식엔 **중철 comp 1개뿐**.

### 1-2. 상품-공정 배선 (실측 — 제본방식은 상품별 1고정)
| 상품 | 제본방식 | 바인딩 공정(t_prd_product_processes) | 올바른 제본 comp |
|---|---|---|---|
| PRD_000068 중철책자 | 중철 | PROC_000018(중철제본) | COMP_BIND_JUNGCHEOL |
| PRD_000069 무선책자 | 무선 | PROC_000019(무선제본) | COMP_BIND_MUSEON |
| PRD_000070 PUR책자 | PUR | PROC_000020(PUR제본) | COMP_BIND_PUR |
| PRD_000071 트윈링책자 | 트윈링 | PROC_000021(트윈링제본) | COMP_BIND_TWINRING |

→ **각 책자에 제본공정은 정확히 1개**(상품 정체에 제본방식이 고정). 런타임 택1 아님.

### 1-3. 엔진 거동으로 본 진짜 결과 = "1500 과소청구"가 아니라 **"0원 누락"**
`evaluate_price`(`raw/webadmin/.../pricing.py`) 매칭 규칙:
- `COMP_BIND_JUNGCHEOL.use_dims = ["proc_cd","min_qty","proc_grp:PROC_000017"]` → **`proc_cd`는 NON_QTY_DIMS 정확매칭 차원**(pricing.py:42·82 `_row_matches`).
- 이 comp의 단가행은 전부 `proc_cd=PROC_000018`.
- 무선책자(PRD_000069)는 selections에 `proc_cd=PROC_000019`가 주입됨(proc_sels) → `_norm('PROC_000019') != 'PROC_000018'` → **no_match** → `m["row"] is None` → `included=False`(pricing.py:518) → **subtotal=0**.
- lenient 모드: 0원 합산(경고만), strict 모드: "매칭 0건" 경고. 어느 쪽이든 **제본비가 청구에서 사라짐**.

> 정정: 결함 브리핑의 "PUR이 중철값 1500으로 과소청구(~3.3배)"는 **엔진 실거동과 다름**. proc_cd 정확매칭이라 중철 단가가 PUR에 새지 않는다 — PUR은 1500도 못 받고 **0원**이 된다(누락=더 심한 과소청구). 068 중철만 정상.

### 1-4. 근본원인 = 스키마 설계의도 위반 (1공유공식 ↔ 상품별 1고정 미스매치)
제본방식은 **상품 정체(정적·1고정)**인데, 4상품이 하나의 공식을 공유하면 그 공식엔 제본 comp가 1개만 들어갈 수밖에 없다(여러 개 넣으면 §4 동시매칭 4중 합산). 즉 "1공유공식" 자체가 "상품별 1고정 제본방식"과 구조적으로 충돌. → **상품→공식 1:1 분리**가 데이터 현실 정합.

---

## 2. 권위 제본단가 verbatim 적재 확인 (단가 교정 불요)

가격표 260527 제본비 표(B01) ↔ 라이브 `t_prc_component_prices` 대조 — **4 comp 전부 verbatim 일치**:

| min_qty | 중철(권위/라이브 JUNGCHEOL@018) | 무선(권위/라이브 MUSEON@019) | 트윈링(권위/라이브 TWINRING@021) | PUR(권위/라이브 PUR@020) |
|---|---|---|---|---|
| 1 | 3000 / 3000 | 3000 / 3000 | 4000 / 4000 | 5000 / 5000 |
| 4 | 2000 / 2000 | 2000 / 2000 | 3000 / 3000 | 5000 / 5000 |
| 10 | 1500 / 1500 | 1000 / 1000 | 2000 / 2000 | 5000 / 5000 |
| 30 | 1000 / 1000 | 700 / 700 | 1500 / 1500 | 4000 / 4000 |
| 50 | 1000 / 1000 | 700 / 700 | 1500 / 1500 | 3000 / 3000 |
| 70 | 700 / 700 | 500 / 500 | 1300 / 1300 | 2500 / 2500 |
| 100 | 700 / 700 | 500 / 500 | 1300 / 1300 | 2000 / 2000 |
| 1000 | 500 / 500 | 500 / 500 | 1000 / 1000 | 1500 / 1500 |

→ **단가행 교정 0**. `component_prices` 손대지 않음. 결함은 순수 **배선(formula↔component↔product)** 문제.

> 데이터 위생 관찰(비블로킹): `COMP_BIND_TWINRING`은 proc_cd 018/019/020/021 행을 다 가짐(타 제본방식 cross-table 잔재). 트윈링책자는 proc_cd=PROC_000021만 선택하므로 `_row_matches`가 정확히 격리(021 행만 생존·dim_vals 공란이라 동시매칭 없음). 청구엔 무해하나 **잔재 행(018/019/020)은 향후 정리 후보**(별 트랙·본 교정 범위 외).

---

## 3. 교정 구조 — A안 vs B안 트레이드오프 (★핵심 심의)

### A안 — 제본방식별 공식 분리 (PRF_BIND_<방식> + 상품 1:1 정적 바인딩) **[권고]**

- **구조**: 기존 `PRF_BIND_SUM`을 **중철 전용으로 의미 명확화**(frm_nm/note 갱신, comp 배선 그대로) + 무선·PUR·트윈링 **3공식 신설**. 각 공식 `formula_components`에 자기 제본 comp 1행만. `product_price_formulas` 바인딩을 069→PRF_BIND_MUSEON·070→PRF_BIND_PUR·071→PRF_BIND_TWINRING으로 교정(068은 PRF_BIND_SUM 유지).
- **장점**: ① 데이터 현실 정합(제본방식=상품 1고정→공식 1:1) ② **동시매칭 0**(공식당 comp 1개) ③ D-2(.08 옵션 멤버십) 우회—횡단 인프라 불요 ④ DDL 0(그릇 기존: frm_cd/frm_nm/note/use_yn뿐), INSERT 3공식+3배선·UPDATE 3바인딩.
- **단점**: 공식 +3개. 단 제본방식 수만큼이라 의미상 자연(round-17 가독성 기준엔 오히려 부합—"무선책자→무선 제본공식"). 향후 한 상품이 제본방식 런타임 택1하면 그 상품만 B안 전환 필요.

### B안 — 1공식 유지 + 제본방식을 CPQ 옵션(opt_cd .08)으로 멤버십 분기

- **구조**: PRF_BIND_SUM에 4 comp 모두 배선 + 제본방식 option_items에 OPT_REF_DIM.08(가격comp 참조)로 선택 시 1개만 활성화.
- **치명 단점**: ① **정적 사실을 런타임 옵션으로 오인코딩(과설계)** — 선택지 1개뿐인 "택1"을 만드는 셈 ② .08 base_code + `fn_chk_opt_item_ref` 트리거 보강 의존(횡단 인프라) ③ .08 적용 **전**까지 4 comp 배선만 하면 **동시매칭 4중 합산**(068이 무선/PUR/트윈링까지 다 더해짐)이라 적용 과도기에 더 위험 ④ 070 PUR 옵션 0행 → L2 적재 선행 필요(의존 사슬 김).

### 권고 = **A안**
1. **데이터 현실(최우선)**: 제본방식=상품 1고정 → 정적 바인딩이 의미 정합. B안은 정적 사실을 런타임으로 오인코딩.
2. **돈-크리티컬 안전**: A안 즉시 동시매칭 0. B안은 .08 적용 전까지 4중 합산 위험.
3. **의존 최소**: A안 자기완결(.08·트리거·PUR L2 불요).
4. **PRF_DGP_A 가설A와 비모순**: PRF_DGP_A는 *한 상품 내 다중 택1*(엽서 단/양면)이라 .08이 정답. BIND은 *상품별 1고정*이라 공식분리가 정답. **멤버십 구조가 다르므로 해법이 다른 게 정합**.
> 보존: 향후 "책자가 제본방식 런타임 택1" 요건 생기면 그 상품만 B안(.08) 전환. A↔B 배타 아님. 현 4상품 전부 A안 적격. 본 권고는 28_price-arbitration round-18+ BIND-C1 A안과 동일(독립 재실측으로 재확증).

---

## 4. 교정 후 evaluate_price 재계산 (골든 · qty=100)

제본비 comp prc_typ=PRICE_TYPE.01(단가형) → subtotal = unit_price(min_qty=100 tier) × qty. (※ 본 공식은 제본비 항만 — 완제품가는 인쇄/용지/표지 등 타 공식 적재 후. 여기선 제본비 항의 정/오만 판정.)

| 책자 | 교정 전(현 라이브) | 교정 후(A안) | 권위(가격표 qty100×100) |
|---|---|---|---|
| 068 중철 | 70,000 ✓ | 70,000 ✓ | 700×100 = 70,000 |
| 069 무선 | **0 (누락)** 🔴 | **50,000** ✓ | 500×100 = 50,000 |
| 070 PUR | **0 (누락)** 🔴 | **200,000** ✓ | 2000×100 = 200,000 |
| 071 트윈링 | **0 (누락)** 🔴 | **130,000** ✓ | 1300×100 = 130,000 |

→ 교정 전 3/4 책자 제본비 0원(전손) → 교정 후 4/4 자기 제본단가 정확 청구.

---

## 5. 정립 트랙 · §23 셋트 책자 경계

| 순서 | 작업 | 대상 t_* | 행 | 비고 |
|---|---|---|---|---|
| ① 공식 신설 | PRF_BIND_MUSEON·PUR·TWINRING + PRF_BIND_SUM 의미명확화 | t_prc_price_formulas | INSERT 3 (+UPDATE 1 note) | DDL 0 |
| ② 배선 | 각 신공식 ← 자기 comp 1행(addtn_yn Y·disp_seq 1) | t_prc_formula_components | INSERT 3 | |
| ③ 바인딩 교정 | 069→MUSEON·070→PUR·071→TWINRING | t_prd_product_price_formulas | UPDATE 3 | 068 불변 |
| ④ DEFERRED | 070 PUR 옵션 레이어(L2) | t_prd_product_option_* | round-6 | 가격 무영향 |

### ★ §23 셋트 책자(072 하드커버 등) 경계 — 본 교정 범위 외
- **072 하드커버책자**는 별도 제본 comp(`COMP_BIND_HC_MUSEON`·`COMP_BIND_HC_TWINRING`·`COMP_BIND_SSABARI`, 권위 표 B02 — 30000~6000원대·"표지비용 따로 계산"). **본 교정은 단일 책자 068~071의 일반 제본비(표 B01)에 한정**.
- 072는 §23 셋트 하이브리드 모델(구성원별 공식 + 셋트 제본공식)로 별도 진행 중 — HC_* comp·표지비 그릇은 §23 트랙. **본 SQL은 072·HC_*·CAL_*·SSABARI를 일절 건드리지 않음**.
- 캘린더 제본 comp(`COMP_BIND_CAL_*`, 표 B03)도 본 범위 외(캘린더 상품 바인딩 트랙).

---

## 6. 영향분석 · 멱등성 · 안전

- **영향 범위**: t_prc_price_formulas +3행, t_prc_formula_components +3행, t_prd_product_price_formulas 3행 UPDATE(frm_cd 교체). 068·072·HC/CAL/SSABARI 불변. component_prices·단가값 불변.
- **멱등**: 공식/배선은 `ON CONFLICT DO NOTHING`(PK=frm_cd / (frm_cd,comp_cd)). 바인딩은 `WHERE frm_cd='PRF_BIND_SUM'` 조건부 UPDATE라 재실행 시 이미 교체됐으면 0행(멱등). 신규 mint 0(공식코드는 명명규칙 신설이나 새 엔티티 타입 아님·comp 전부 기존 재사용=search-before-mint 충족).
- **롤백**: `bind-sum-dryrun.sql`은 BEGIN…ROLLBACK으로 감싸 적재 가능성·재계산만 실증하고 원복. 실 COMMIT은 인간 승인 후 `bind-sum-fix.sql`(트랜잭션 래핑).
- **재검증 게이트(적용 후)**: ① formula_components 각 공식 1행(4공식=4행)·미배선 0 ② 각 상품 활성 comp=자기 제본 1개(동시매칭 0) ③ 재계산 골든 4/4 재현(§4) ④ 단가행 32셀 불변.

---

## 7. 컨펌 큐

- **BIND-C1 [핵심·권고 A안]**: 공식 모델 = A안(제본방식별 공식 분리 + 상품 1:1). round-18+ BIND-C1 A안 승계·재확증. 실 COMMIT 승인 요청.
- **BIND-DATA-1 [비블로킹]**: `COMP_BIND_TWINRING`의 cross-proc 잔재 행(proc 018/019/020) 정리 여부 — 청구 무해, 별 트랙.
- **BIND-C2 [범위 외]**: 캘린더(CAL_*)·하드커버(HC_*/SSABARI) 제본 comp 바인딩 — 본 교정 외(§23·캘린더 트랙).
