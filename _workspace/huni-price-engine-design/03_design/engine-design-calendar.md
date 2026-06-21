# engine-design-calendar.md — 캘린더 가격엔진 설계 (완제품·원자합산형)

> **핵심 설계가(hpe-engine-designer) 산출 — 캘린더 종단(9번째·디지털[원자합산+고정가]·아크릴[면적]·실사현수막[면적+거치]·문구[고정가+매트릭스]·책자[부품합산세트]·스티커[이산siz단가형+세트]·상품악세사리[inline고정가] 다음).**
> cartographer 지도(`formula-map-calendar.md`·`component-inventory-calendar.md`·`gap-board-calendar.md`)+benchmark 흡수(`absorption-candidates-calendar.md`·`competitor-pricing-models-calendar.md`·`set-pricing-patterns-calendar.md`)를 종합해,
> 캘린더 5 완제품의 **가격공식 + 가격구성요소 + t_prc_* 단가행 그릇 + 상품↔공식 바인딩**을 라이브 `evaluate_price` 단일 권위 알고리즘이 그대로 먹는 형태로 설계한다. **새 엔진 코드 아님 — t_prc_*/t_prd_* 데이터 그릇/배선/바인딩 설계.**
>
> 권위[HARD]: ① 상품마스터(260610) `캘린더`/`디자인캘린더(가격포함)` 시트 + 계산공식집초안(r94~98) > ② 인쇄상품 가격표(260527) `디지털인쇄비`·`제본` B03 > ③ 라이브 t_prc_*/t_prd_*(기준선) > ④ 역공학(캘린더 부재·내부권위 충분).
> 산출자: hpe-engine-designer · 라이브 읽기전용 SELECT 실측 2026-06-22 · 단가값=권위 verbatim(날조 0) · **DB 미적재**(실 적용 인간 승인 후 dbmap 위임·webadmin 코드 직접수정 금지).
> 디지털·아크릴·실사·문구·책자·스티커·악세사리 GO 설계와 동일 컨벤션·동일 engine-contract(pricing.py).

---

## 0. 설계 요약 — 라이브 baseline 대비 무엇을 하나 (WIRE-type 결함 · 디지털 PRF_DGP 직계 chassis)

라이브 실측(2026-06-22 읽기전용 SELECT)이 cartographer 지도를 **대체로 확인**했고, 결판 사안 3건을 라이브 권위로 종결했다.

| 라이브 실측 (2026-06-22) | 값 | 설계 함의 |
|--------------------------|----|-----------|
| **캘린더 5상품 공식 바인딩**(t_prd_product_price_formulas) | **0건** | WIRE 결함 확정 — 전 상품 견적 불가(source=NONE). PRF_CAL_* 신설+바인딩 필요 |
| **PRF_CAL_* 공식** | **부존재**(PRF_DGP_A~F만 실재) | 인쇄+용지+제본 조립 공식 신규 mint 필요 |
| **COMP_BIND_CAL_\* prc_typ** | **PRICE_TYPE.01 단가형**(4 comp 전부·use_dims=`["proc_cd","min_qty","proc_grp:PROC_000017"]`) | ★제본비 결판=**.01 단가형 ×qty(부당가)** — cartographer "수량구간형"=정확히는 .01+min_qty tier 룩업. .02 합가형 아님(아래 §3) |
| **COMP_BIND_CAL_\* del_yn** | DESK130/220/MINI=**del_yn='Y'(논리삭제)**·WALL=del_yn='N'(활성·4 proc 통합 42행) | ★DESK 3 comp 논리삭제 상태 — WALL이 99/100/101/102 전 제본방식 단가행 통합 보유. 배선 시 WALL 권위 / DESK 부활 여부=컨펌큐 Q-CAL-BIND-DELYN |
| **COMP_PRINT_DIGITAL_S1·COMP_PAPER** | 둘 다 실재·use_yn=Y·del_yn=N·.01 단가형 | 직계 재사용(PRF_DGP 동형·신규 mint 금지) |
| **t_prd_product_prices**(108~112) | **0행** | ★G-CAL-2 PRODUCT_PRICE 선점 가드 **자동 충족**(선점 우회 위험 0)·formula 바인딩만 |
| **option_groups·discount_tables**(108~112) | **0행** | 옵션 레이어 전면 미적재(가격 무관 옵션=분리·구간할인=단가행 tier 흡수) |
| **캘린더가공 add-on comp**(CALOPT/WOODSTAND/PUNCH) | **부재** | 신규 mint 후보(우드거치대·타공+끈) |
| **COMP_POSTEROPT_LINEN_FINISH** | use_dims=`["opt_cd","min_qty"]`·.01·min_qty NULL(×qty) | ★캘린더가공 add-on 그릇 **직계 선례**(opt_cd 차원·평탄화 가드 충족·dbmap round-23 린넨 COMMIT) |

**∴ 캘린더 설계의 핵심 5가지:**
1. **계산방식 = 원자합산형**(calc-draft r94 `[원자합산형: 캘린더]` 절대 권위). 디지털 PRF_DGP_A/E **직계 chassis 재사용** — 인쇄비·용지비 comp 그대로, 차이는 **페이지수(장수) 곱** 하나뿐.
2. **★제본비 prc_typ = .01 단가형 ×qty(부당가)** — 라이브 적재(.01)·가격표 B03('부당가' 라벨)·RedPrinting 실측(삼각대 297,000@500부=594원/부) 3원 정합. 디지털 명함의 ÷min_qty **합가형 함정과 결정적으로 다름**(캘린더 제본은 진짜 개당가·묶음총액 아님). 분모 ÷min_qty 적용 시 제본비 1/N 붕괴(돈크리티컬·G-CAL-BIND).
3. **★페이지수(장수) 곱 = 인쇄비·용지비의 load-bearing 차원** — 출력매수 = 주문수량 × 페이지수 / 판걸이수. 엽서(1장)와 캘린더(4~16장)를 가르는 곱. 누락 시 인쇄비·용지비 4~16배 과소청구(돈크리티컬·G-CAL-PAGE).
4. **캘린더가공 add-on = LINEN_FINISH 그릇 직계 재사용**(opt_cd 차원 .01 단가형). 우드거치대4000/1구타공+끈1000/2구타공+끈1500·use_dims=[opt_cd] 충전(평탄화 가드·G-CAL-1).
5. **★PRODUCT_PRICE 선점 가드 = product_prices 0행으로 자동 충족** — 본체 formula 바인딩만·product_prices INSERT 금지(GP-2 선례·codex 독립발견 동형). 단 적재 시 박제(G-CAL-2).

★ **9종단 동형 클래스 판정**: 캘린더 = **디지털 PRF_DGP 원자합산형 직계 동형 + 캘린더가공 add-on(LINEN_FINISH opt_cd 그릇) + 제본비 부당가 단가행(.01 tier)**. **신규 가격축·t_prc_* 테이블 = 0건**(benchmark·rpmeta 캘린더 부재·search-before-mint 9연속 통과). 신규 mint = **PRF_CAL_* 공식 + COMP_CALOPT_* add-on comp뿐**. 세트조합 레이어 **불요**(캘린더 본체 단일 prd·t_prd_product_sets 0행·book BOOKLET 부품합산과 결정적 다름).

---

## 1. 계산방식 — 원자합산형 (frm_typ 미참조·calc-draft 절대 권위)

calc-formula-draft-l1.csv r94~98(절대 권위):
- r94 `[원자합산형: 캘린더]`
- r95 `판매가 = 인쇄비 + 용지비 + (제본비 or 캘린더가공비)`
- r96 `(1) 인쇄비 = [총출력장수/판걸이수] × 인쇄비`  (총출력장수 = 주문수량 × **페이지수**)
- r97 `(2) 제본비 = [수량행][제본종류열]`  (= COMP_BIND_CAL_* .01 단가형 tier 룩업)
- r98 `(3) 캘린더가공비 = [가공비] × [제작수량]`  (= add-on opt_cd .01 단가형 ×qty)

| 계산방식 | 정의 | 캘린더 상품군 | 엔진 처리(engine-contract·pricing.py) |
|----------|------|--------------|---------------------------------------|
| **원자합산형** | 판매가 = Σ(구성요소 subtotal) | 캘린더 5 완제품 전부 | 공식=구성요소 합산(addtn_yn='Y' 항)·각 comp 단가형(.01) `unit×qty`(:191) |

★ **핵심[HARD]**: 엔진은 `frm_typ_cd`를 참조하지 않는다(engine-contract C7·pricing.py:8 "공식유형 frm_typ 폐기→공식은 항상 구성요소 합산"). 캘린더 원자합산형 = `formula_components` addtn_yn='Y' comp들의 Σ. 디지털 PRF_DGP_A/E §1과 동형.

---

## 2. 원자합산형 공식 설계 — PRF_CAL_* (신규 mint · 디지털 chassis 재사용)

> calc-draft r95: `판매가 = 인쇄비 + 용지비 + (제본비 or 캘린더가공비)`

### 2.1 공식 분할 — 제본방식(사이즈)별 전용 PRF (제본비 comp가 사이즈별로 다름)

제본비 comp가 사이즈별로 분리(DESK220/DESK130/DESKMINI/WALL)되어 있어, **한 공식에 4 제본비 comp를 다 배선하면 동시매칭**(같은 상품에 220/130/미니 제본비가 다 매칭) 위험. 디지털 명함 variant별 전용 PRF 교훈 동형 → **제본비 차원(상품의 사이즈/형태)별 전용 PRF**.

| 신설 공식(frm_cd) | frm_nm(한글 표준·코드노출 0) | 바인딩 상품 | 인쇄비 | 용지비 | 제본비 | 가공 add-on |
|------------------|------------------------------|-------------|--------|--------|--------|-------------|
| **PRF_CAL_DESK220** | 캘린더 원자합산 탁상형(220) | 탁상형캘린더 PRD_000108 (220x145·130x220) | COMP_PRINT_DIGITAL_S1 | COMP_PAPER | COMP_BIND_CAL_DESK220 | (삼각대 0·무료) |
| **PRF_CAL_DESKMINI** | 캘린더 원자합산 미니탁상형 | 미니탁상형캘린더 PRD_000109 (90x100·148x60) | COMP_PRINT_DIGITAL_S1 | COMP_PAPER | COMP_BIND_CAL_DESKMINI | (삼각대 0·무료) |
| **PRF_CAL_POSTCARD** | 캘린더 원자합산 엽서형 | 엽서캘린더 PRD_000110 (6규격·단면) | COMP_PRINT_DIGITAL_S1 | COMP_PAPER | (제본없음) | COMP_CALOPT_* (우드거치대/타공+끈) |
| **PRF_CAL_WALL** | 캘린더 원자합산 벽걸이 | 벽걸이캘린더 PRD_000111 (3규격) | COMP_PRINT_DIGITAL_S1 | COMP_PAPER | COMP_BIND_CAL_WALL | COMP_CALOPT_* (2구타공+끈) |
| **PRF_CAL_WALLWIDE** | 캘린더 원자합산 와이드벽걸이 | 와이드벽걸이캘린더 PRD_000112 (300x625·3절) | COMP_PRINT_DIGITAL_S1 | COMP_PAPER | COMP_BIND_CAL_WALL | (제본없음/트윈링) |

★ **DESK130 미분리 — 탁상형(108)이 220·130 두 사이즈를 보유**(siz_cd SIZ_000069 220x145·SIZ_000070 130x220). 그러나 제본비는 **siz_cd가 아니라 proc_cd(99~102)로 룩업**(use_dims=[proc_cd,...]). 같은 상품(탁상형)이 220/130 둘 다 가지면 어느 제본비 comp(DESK220 vs DESK130)가 매칭되는지가 문제 → **§3.4 사이즈→제본비 proc 매핑(옵션→차원 주입)으로 분기**. 설계 채택: 탁상형은 PRF_CAL_DESK220에 DESK220·DESK130 comp 둘 다 배선하되 **proc_cd 판별차원으로 동시매칭 회피**(아래 §3.4). 단순화 대안(컨펌큐 Q-CAL-DESK130): 130 사이즈를 별 상품/별 공식으로 분리.

### 2.2 formula_components 배선 명세 (PRF_CAL_DESK220 대표 — 다른 PRF 동형)

| disp_seq | comp_cd | 의미축 | prc_typ | use_dims | addtn_yn | 단가행 상태 |
|----------|---------|--------|---------|----------|----------|-------------|
| 0 | COMP_PRINT_DIGITAL_S1 | 인쇄(도수×면×판형×수량) | 단가형(.01) | proc_cd·plt_siz_cd·print_opt_cd·min_qty·proc_grp:PROC_000001 | **Y** | 재사용(212행 실재) |
| 1 | COMP_PAPER | 용지(판형×종이) | 단가형(.01) | siz_cd·mat_cd | **Y** | 재사용(몽블랑190g=112.58/판 실재) |
| 2 | COMP_BIND_CAL_DESK220 | 제본비(부당가×수량) | 단가형(.01) | proc_cd·min_qty·proc_grp:PROC_000017 | **Y** | 재사용(6행 tier·verbatim) |

★ **인쇄비·용지비 = 출력판형당 단가 × 총출력판수**(앱 임포지션 계산·DB 미저장·[[dbmap-compute-in-app-db-stores-lookup]]). 총출력판수 = 주문수량 × **페이지수** / 판걸이수. 페이지수 곱은 옵션→차원 주입 레이어(앱)에서 수량(min_qty·출력매수)에 반영 — comp 자체는 페이지수 차원 미보유(디지털 엽서와 동일 chassis·페이지수=수량 배수). ★G-CAL-PAGE: 앱이 출력매수 산식에 페이지수 곱을 누락하면 인쇄비·용지비 4~16배 과소청구(검증가 골든으로 입증).

### 2.3 ★디지털 PRF_DGP_A 와의 동형성 (search-before-mint 충족)

| 항목 | PRF_DGP_A(엽서류) | PRF_CAL_*(캘린더) | 차이 |
|------|-------------------|--------------------|------|
| 인쇄비 comp | COMP_PRINT_DIGITAL_S1 | **동일 재사용** | 0 |
| 용지비 comp | COMP_PAPER | **동일 재사용** | 0 |
| 출력매수 산식 | 주문수량 / 판걸이수 (×1장) | 주문수량 × **페이지수** / 판걸이수 | **페이지수 곱**(엽서=1·캘린더=4~16) |
| 후가공/제본 | 귀돌이/오시/미싱 add-on | **제본비 tier + 캘린더가공 opt_cd** | 비목 종류만 다름(둘 다 Σ) |
| 계산방식 | 원자합산형 | 원자합산형 | 0 |

→ **PRF_CAL_*는 PRF_DGP_A/E chassis의 캘린더 변형**(인쇄·용지 comp 100% 재사용·제본/가공 비목만 캘린더 전용). 신규 comp = 캘린더가공 add-on뿐.

---

## 3. ★제본비 prc_typ 결판 (.01 단가형 ×qty · 돈크리티컬 G-CAL-BIND)

### 3.1 라이브 실측 결판 (cartographer↔benchmark 충돌 종결)

| 원천 | 주장 | 라이브 실측 |
|------|------|-------------|
| cartographer formula-map §4 | "수량구간형"(min_qty tier) | ✅ 정확히는 **.01 단가형 + min_qty tier 룩업** |
| benchmark AC-1 | ".01 단가형(부당×수량)" | ✅ **라이브 prc_typ_cd=PRICE_TYPE.01 일치** |
| 라이브 COMP_BIND_CAL_* (실측 2026-06-22) | — | **PRICE_TYPE.01 (4 comp 전부)** |

**∴ 제본비 = PRICE_TYPE.01 단가형 ×qty. 단가 = 부당(권당) 단가·수량↑→단가밴드↓ 볼륨디스카운트.** min_qty(1/4/10/50/100/1000)는 **tier 룩업 키**이지 분모 아님.

### 3.2 단가행 그릇 (라이브 verbatim·재사용·DB 무변경)

```
COMP_BIND_CAL_DESK220 (proc=PROC_000100·탁상형캘린더제본(220)):
  min_qty 1→5000 · 4→4000 · 10→3000 · 50→2500 · 100→2300 · 1000→2000  (부당가)
COMP_BIND_CAL_DESK130 (proc=PROC_000101·탁상형캘린더제본(130)):
  min_qty 1→5000 · 4→4000 · 10→3000 · 50→2500 · 100→2300 · 1000→2000
COMP_BIND_CAL_DESKMINI (proc=PROC_000102·탁상형캘린더제본(미니)):
  min_qty 1→4500 · 4→3500 · 10→2500 · 50→2000 · 100→1800 · 1000→1600
COMP_BIND_CAL_WALL (proc=PROC_000099 벽걸이 + 100/101/102 통합·42행):
  벽걸이(99): 1→5000 · 4→4000 · 10→3000 · 50→2500 · 100→2000 · 1000→2000
```
★ 단가값 = 라이브 verbatim(가격표 B03 적재본·날조 0). **DB 단가행 무변경**(prc_typ 이미 .01·교정 불요). 설계 작업 = **공식 신설 + 배선 + 바인딩**(WIRE 결함 폐쇄)이지 단가 교정 아님.

### 3.3 ★돈크리티컬 가드 — 합가형(.02) 오적용 금지 (G-CAL-BIND)

디지털 명함은 prc_typ가 .01(단가형)로 **오적재**되어 ÷min_qty 합가형(.02)으로 **교정**이 필요했다(GC-1 3,500이 100매 묶음총액). **캘린더 제본비는 정반대 — .01이 정답이다**:
- 가격표 B03 = **부당(권당) 단가** verbatim(benchmark §4.2 "부당가·수량↑→단가↓").
- RedPrinting 실측 = 삼각대/제본이 **사이즈/수량 종속 단가**(297,000@500부=594원/부 ≈ 개당가×수량).
- ÷min_qty 합가형 오적용 시: qty=10 주문 제본비 = (3000÷10)×10 = 3,000 (개당 300원) → **개당 제본비 3,000→300 1/10 붕괴**(스티커 052/053·책자 W2 ÷분모 함정 역방향). **.01 단가형 ×qty 유지가 절대(검증가 골든으로 입증)**.

| qty | DESK220 tier단가(부당) | .01 단가형 ×qty (정답) | .02 합가형 ÷min×qty (오답) |
|-----|------------------------|------------------------|----------------------------|
| 1 | 5,000 | **5,000** | 5,000 (우연 정합·min=1) |
| 4 | 4,000 | **16,000** | 4,000 (÷4×4·붕괴) |
| 10 | 3,000 | **30,000** | 3,000 (÷10×10·붕괴) |
| 100 | 2,300 | **230,000** | 2,300 (붕괴) |

### 3.4 제본비 proc_cd 룩업 (use_dims 판별차원·이원화 정합)

★ **제본비 룩업 키 = proc_cd(99/100/101/102)** — 단가행 use_dims=[proc_cd, min_qty, proc_grp:PROC_000017]. 상품 공정 바인딩(PROC_000021 트윈링·PROC_000079 타공·PROC_000076 수축포장)과 **완전 별개**(GAP-5 이원화 확정·실측). 상품 바인딩 proc(21/79/76)=생산 BOM·MES, 제본비 단가행 proc(99~102)=가격 룩업 전용.
- ★옵션→차원 주입: 캘린더 상품의 사이즈/형태 선택이 제본비 proc_cd(99~102)로 매핑돼 단가행 매칭. 탁상형 220→PROC_000100·130→PROC_000101·미니→PROC_000102·벽걸이→PROC_000099. **이 매핑이 option_items로 적재돼야 자동주입 작동**(현재 option_groups 0행·컨펌큐 Q-CAL-PROC-INJECT).
- WALL comp가 4 proc 통합 보유 = 벽걸이/와이드가 어느 제본방식을 골라도 WALL comp 안에서 proc_cd로 분기(설계 권장: WALL을 PRF_CAL_WALL/WALLWIDE에 배선하되 proc_cd 주입으로 정확 1행 매칭).

### 3.5 del_yn 정합 (컨펌큐 Q-CAL-BIND-DELYN)

DESK130/220/MINI = **del_yn='Y'(논리삭제)**, WALL만 del_yn='N'(활성). WALL comp가 99/100/101/102 전 제본방식 단가행을 통합 보유(42행). → 설계 옵션 2:
- **(a) WALL 통합 comp 단독 사용**(권장): 전 캘린더 제본비를 COMP_BIND_CAL_WALL(활성·통합) 하나로 배선·proc_cd로 사이즈 분기. DESK130/220/MINI(del_yn=Y) 부활 불요.
- **(b) DESK130/220/MINI 부활**: del_yn='N' 전환 후 사이즈별 전용 comp 배선. 단가 동일(중복)·논리삭제 의도 역행 위험.
- ★ **권위 미확정 — 인간 컨펌**(WALL 통합이 의도인지 DESK 분리가 의도인지). 단가값은 양쪽 동일(verbatim) → 가격 결과 불변·배선 경로만 다름. dbm-price-arbiter 심의 라우팅.

---

## 4. 캘린더가공 add-on comp 설계 (신규 mint · LINEN_FINISH 그릇 직계)

> calc-draft r98: `캘린더가공비 = [가공비] × 제작수량` · 상품마스터 `캘린더가공_추가가격` 칸 verbatim

### 4.1 ★그릇 = COMP_POSTEROPT_LINEN_FINISH 직계 동형 (search-before-mint 충족)

LINEN_FINISH(라이브 실재·dbmap round-23 린넨 COMMIT): use_dims=`["opt_cd","min_qty"]`·prc_typ=.01·min_qty NULL(×qty)·OPV opt_cd로 가공별 단가(800/1000/2000원). **캘린더가공 add-on이 정확히 이 그릇** — opt_cd 차원으로 가공별 단가, .01 단가형 ×qty(개당 가산). 신규 테이블/가격축 0.

### 4.2 신규 comp 명세 (COMP_CALOPT_* mint · 의미코드 채번)

| comp_cd(신규·의미코드) | comp_nm(한글 표준) | prc_typ | use_dims | 단가행(opt_cd × unit_price·상품마스터 verbatim) |
|------------------------|---------------------|---------|----------|-------------------------------------------------|
| **COMP_CALOPT_STAND** | 캘린더 거치/제본 가공비 | 단가형(.01) | [opt_cd, min_qty] | 우드거치대→4000 · 1구타공+끈→1000 · 2구타공+끈→1500 · 가공없음/삼각대→0 |

★ **단일 comp + opt_cd 차원**(LINEN_FINISH 동형·가공 종류축=opt_cd). 우드거치대/타공+끈/가공없음을 각 opt_cd(OPV 채번 MAX+1)로 단가행. **트윈링제본(2000)은 제본비(COMP_BIND_CAL_WALL)로 분기**(가공 add-on 아님·제본방식이므로) — calc-draft r97/r98 분기 정합. 단순 거치/타공만 add-on comp.

★ **opt_cd 채번**: LINEN_FINISH가 OPV-000024~000027·OPV_000424 사용. 캘린더가공 opt_cd = OPV MAX+1 신규 채번(separator `_`). 가공없음(0원)도 opt_cd 1행(default 식별).

### 4.3 ★평탄화 가드 (G-CAL-1 · GP-2 G-GP-3 동형)

캘린더가공이 가공별 다른 고정가(우드4000 vs 타공1000)인데 **단일 평탄 적재 시 가공 선택과 무관하게 한 값 오청구**(우드 골랐는데 타공가). → **opt_cd 판별차원 use_dims 충전 필수**. 디지털 인쇄면 silent 합산·굿즈 GP-2 variant축·상품악세사리 AC-2 동류 가드. comp 단가행에 opt_cd 차원값 충전 + use_dims에 opt_cd 등재 둘 다(디지털 D-3 교훈).

### 4.4 add-on prc_typ — ×제작수량 (개당 가산·컨펌큐 Q-CAL-FIN)

calc-draft r98 명시 `[가공비] × 제작수량` = .01 단가형 ×qty(개당 가산). LINEN_FINISH min_qty NULL ×qty 동형. ★단 상품마스터에 "개당 가산 vs 주문당 정액" 명시 부족(굿즈 Q-GP-FIN1·악세사리 Q-AC-CEIL 동일 미해소) → **개당 가산 가설**(calc-draft 문자 권위)이나 인간 컨펌. RedPrinting 실측은 가공이 수량 종속(개당) 경향 → 가설 보강.

---

## 5. 상품↔공식 바인딩 설계 (product_price_formulas · WIRE 폐쇄)

미바인딩 5상품(실측 0건)에 PRF_CAL_* 바인딩. **신규 mint = 공식 5 + comp 1(CALOPT)뿐**(인쇄/용지/제본 comp 재사용).

| prd_cd | 상품(라이브 prd_nm) | 바인딩 공식 | 비고 |
|--------|---------------------|-------------|------|
| PRD_000108 | 탁상형캘린더 | **PRF_CAL_DESK220** | 220+130 사이즈(§3.4 proc 분기) |
| PRD_000109 | 미니탁상형캘린더 | **PRF_CAL_DESKMINI** | 90x100·148x60 |
| PRD_000110 | 엽서캘린더 | **PRF_CAL_POSTCARD** | 6규격·제본없음·CALOPT(우드/타공) |
| PRD_000111 | 벽걸이캘린더 | **PRF_CAL_WALL** | 트윈링제본(WALL)·2구타공(CALOPT) |
| PRD_000112 | 와이드벽걸이캘린더 | **PRF_CAL_WALLWIDE** | 3절·WALL 제본·SIZ_000077 인쇄비 룩업 |

★ **PRODUCT_PRICE 선점 가드 (G-CAL-2·자동 충족)**: product_prices 0행 실측 → 본체를 product_prices에 INSERT하면 FORMULA 통째 우회 silent(GP-2 선례). **캘린더 본체는 formula 바인딩만·product_prices INSERT 금지**(적재 시 박제). 현 0행이므로 선점 위험 0.

---

## 6. 단가행 그릇 (component_prices) — "재사용 + 신규 add-on만"

| 작업 | 대상 | 내용 | 트랙 |
|------|------|------|------|
| **재사용(무변경)** | COMP_PRINT_DIGITAL_S1·COMP_PAPER·COMP_BIND_CAL_* | 단가행 실재·verbatim·결손 아님 | — |
| **신규 단가행 INSERT** | COMP_CALOPT_STAND | opt_cd × unit_price(우드4000/타공1000/타공1500/0)·상품마스터 verbatim | dbmap·search-before-mint 후 |
| **신규 opt_cd 채번** | OPV_*(우드거치대/1구타공/2구타공/가공없음) | OPV MAX+1·separator `_` | dbmap |
| **공식·배선·바인딩 INSERT** | PRF_CAL_* 5 + formula_components 15(5공식×3comp) + product_price_formulas 5 | WIRE 폐쇄 | dbmap |
| **del_yn 결정(컨펌)** | COMP_BIND_CAL_DESK130/220/MINI | WALL 통합 사용(부활 불요) vs DESK 부활 | 인간 컨펌 Q-CAL-BIND-DELYN |

★ 단가값 = **전부 가격표/상품마스터 verbatim**(제본비 라이브 적재·가공비 상품마스터 칸·인쇄/용지 라이브). 설계는 값을 만들지 않는다(날조 0).

---

## 7. evaluate_price 계약 정합 체크 (설계 자기검증)

| 계약(engine-contract) | 설계 준수 |
|----------------------|-----------|
| C7 frm_typ 미참조·공식=합산 | ✅ PRF_CAL_*=addtn_yn='Y' comp Σ(원자합산형) |
| P4-1 단가형 ×qty | ✅ **제본비 .01 단가형 ×qty가 정답**(부당가·합가형 금지 G-CAL-BIND)·인쇄/용지/가공 전부 .01 |
| P4-3 합가형 min_qty 필수 | N/A(합가형 comp 0건·전 comp 단가형) |
| P3-8 ERR_AMBIGUOUS 금지 | ✅ 제본비 사이즈별 전용 PRF + proc_cd 판별차원(동시매칭 회피)·CALOPT opt_cd 판별 |
| P3-DEF 판별차원 없음 금지 | ✅ CALOPT use_dims=[opt_cd] 충전·제본비 proc_cd 충전(NULL 항상매칭 금지) |
| PRODUCT_PRICE 선점 | ✅ product_prices 0행·formula 바인딩만(G-CAL-2 자동 충족) |
| U-7 시트 차원경계(SOT 1) | ✅ 캘린더 공식=인쇄+용지+제본+가공 4비목만(타 상품군 comp 침입 0·시트경계 안) |
| 도수=print_opt_cd | ✅ 인쇄면 단/양=print_opt_cd(POPT_000001/002)·COMP_PRINT_DIGITAL 차원 흡수(별 도수 comp 분할 금지) |
| 면적=siz_width/height | N/A(캘린더=이산 siz_cd·면적매트릭스 아님) |
| search-before-mint | ✅ 신규 comp=CALOPT 1건(LINEN_FINISH 그릇)·인쇄/용지/제본 재사용·신규 가격축 0 |

---

## 8. designer 큐 잔여 (design-decisions·골든으로 이관)

- **제본비 del_yn 결정**(Q-CAL-BIND-DELYN): WALL 통합 vs DESK 부활 → §3.5·인간 컨펌.
- **사이즈→제본비 proc 주입**(Q-CAL-PROC-INJECT): option_items 0행 → proc_cd 자동주입 미연결(현재 충전 단독 매칭은 됨·주입 레이어 연결 시 발현).
- **add-on ×수량 여부**(Q-CAL-FIN): 캘린더가공 개당 가산 vs 주문당 정액 → §4.4·인간 컨펌.
- **DESK130 처리**(Q-CAL-DESK130): 탁상형 220/130 한 공식 proc 분기 vs 별 공식 분리.
- **디자인캘린더 inline 골든 재현 불가분**(Q-CAL-GOLDEN): inline 가격이 단가행 산식과 깨끗이 안 맞음(§golden-cases·BLOCKED 정직).
- **캘린더봉투(PRD_000005)**: addon vs 독립 → 봉투제작 트랙 위임(엽서 봉투 동형·set-product-design 캘린더 절).
