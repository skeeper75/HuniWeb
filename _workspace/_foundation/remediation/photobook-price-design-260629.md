# 포토북(PRD_000100) 완제품가 가격공식 설계 — 094 엽서북 동형

작성: 2026-06-29 · 읽기전용 분석 + DRY-RUN 완료 · 실 COMMIT/DDL 0
산출 SQL: `photobook-price-260629-dryrun.sql`(검증 완료) · `photobook-price-260629-fix.sql`(COMMIT 준비·★사람 검토용)

---

## ★★ 재설계 보강 (2026-06-29·사용자 지적 반영) — 페이지 추가가 해소(OI-1 폐기)

> 사용자 지적: "기본24P + 추가2P당이 상품마다 정해져 있는데 왜 추가2P를 안 다뤘나?" → 정당.
> 초기 설계는 포토북을 **부모 1개 공식**으로만 봐 `× 부수`만 가능 → page 미반영(OI-1 BLOCKED)으로 오판.
> ★정정: 포토북은 **세트**. 엔진 `evaluate_set_price`는 **구성원마다 자기 qty로 가격** → page를
> 내지 구성원 qty로 곱할 수 있다. OI-1(page BLOCKED·저청구)은 **오판이었고, 아래 2-레이어로 해소**.

**최종 2-레이어 설계 (권위 photobook-l1 verbatim·총가 = 부수 × (기본24P[siz·표지] + 추가2P당[siz] × ⌈(page−24)/2⌉)):**
- ① 부모 세트공식 `PRF_PHOTOBOOK_FIXED ← COMP_PHOTOBOOK_BASE`(기본24P·siz_cd×opt_cd[표지타입]·단가행 11) × 부수.
- ② 내지 구성원 `PRD_000101 ← PRF_PHOTOBOOK_INNER ← COMP_PHOTOBOOK_PAGE`(추가2P당·siz_cd·단가행 4: 8x8=500·10x10=1000·A5=300·A4=600·표지타입 무관) × 내지qty. prc_typ .01(unit×qty).
- 위젯 계약(OI-PAGE): 내지 구성원 `qty_mode='manual', qty = 부수 × ⌈(page−24)/2⌉`(page≤24→0=기본만)·`selections={siz_cd}`.

**검산(권위 정확 일치):**
- A4(SIZ_000172) 하드(OPV_000484) page50 copies1: 부모 16,000×1 + 내지 600×(1×⌈26/2⌉=13)=7,800 → **23,800** = 권위(16,000+13×600) ✅.
- page24 copies N: 내지 step0 → 기본24P×N만(기존 11행 검산 유지) ✅.

**DRY-RUN 재검증(현 DB 대조):** FIXED공식1·INNER공식1·BASE구성요소1·PAGE구성요소1·BASE단가행11·PAGE단가행4·바인딩2 · PK충돌0 · 멱등 · ROLLBACK.

**남은 OI:** ① **OI-PAGE**(위젯이 내지 qty=부수×페이지스텝 전달·시뮬/위젯 계약) ② **OI-3**(표지타입→opt_cd: PRD_000100 옵션그룹+OPV_000484~486 등록=dbmap CPQ 선결, 미등록 시 ERR_AMBIGUOUS). ★OI-1(page 저청구)은 **해소됨**.
**★기존 094 엽서북도 동일 결함**(내지095 무공식 → 추가페이지 미반영) — 책자 세트 공통(별도 적용 권고).

> 아래 §3(이하)는 초기(부모-only) 분석 이력 — OI-1 BLOCKED 판정은 위 재설계로 **폐기**됨(이력 보존).

---

## 0. 한눈 요약

| 항목 | 값 |
|---|---|
| 부모 상품 | PRD_000100 (셋트 완제품) — 현재 완제품가 공식 미바인딩 → 견적 0 |
| 신규 공식 | `PRF_PHOTOBOOK_FIXED`(부모 기본가) + `PRF_PHOTOBOOK_INNER`(내지 추가2P당) = **2** |
| 신규 구성요소 | `COMP_PHOTOBOOK_BASE` + `COMP_PHOTOBOOK_PAGE` = **2** · comp_typ=.06 · prc_typ=.01(단가형) |
| use_dims | BASE `["siz_cd","opt_cd","min_qty"]` · PAGE `["siz_cd","min_qty"]` |
| 신규 단가행 | **15** = 기본24P 11(siz×표지) + 추가2P당 4(siz별·표지무관) |
| 신규 바인딩 | PRD_000100 ← FIXED, PRD_000101(내지) ← INNER = **2** |
| 표지타입 차원 | **opt_cd** (OPV_000484 하드 / OPV_000485 레더하드 / OPV_000486 소프트) — 라이브 OPV 컨벤션·MAX 483+1 |
| ★page 모델 | **해결 — 내지 구성원(PRD_000101) 단가형 추가2P당 × 내지qty(=copies×page-step). page 선형증가 정확** |
| DRY-RUN | RC=0 · PK충돌 0 · 공식2/구성요소2/배선2/단가행15/바인딩2 · 멱등(2차 0행) |

---

## 1. 권위 매트릭스 (출처: `huni-dbmap/24_master-extract-260610/photobook-l1.csv` "포토북(가격포함)", verbatim)

가격공식 = `(기본24P가 + ⌈(page−24)/2⌉ × 추가2P당) × copies(부수)`. page 24~150, 증가 2.

| 사이즈 | siz_cd | 표지타입 | opt_cd(설계) | 기본24P | 추가2P당 |
|---|---|---|---|---|---|
| 8×8 200×200 | SIZ_000269 | 하드커버 | OPV_000484 | 15000 | 500 |
| 8×8 | SIZ_000269 | 레더하드커버 | OPV_000485 | 23000 | 500 |
| 8×8 | SIZ_000269 | 소프트커버 | OPV_000486 | 12000 | 500 |
| 10×10 250×250 | SIZ_000274 | 하드커버 | OPV_000484 | 22000 | 1000 |
| 10×10 | SIZ_000274 | 레더하드커버 | OPV_000485 | 32000 | 1000 |
| 10×10 | SIZ_000274 | 소프트커버 | — | **빈칸=미제공(단가행 없음·BLOCKED)** | — |
| A5 148×210 | SIZ_000170 | 하드커버 | OPV_000484 | 12000 | 300 |
| A5 | SIZ_000170 | 레더하드커버 | OPV_000485 | 19000 | 300 |
| A5 | SIZ_000170 | 소프트커버 | OPV_000486 | 10000 | 300 |
| A4 210×297 | SIZ_000172 | 하드커버 | OPV_000484 | 16000 | 600 |
| A4 | SIZ_000172 | 레더하드커버 | OPV_000485 | 26000 | 600 |
| A4 | SIZ_000172 | 소프트커버 | OPV_000486 | 13000 | 600 |

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
[부모 세트공식] (set_eval — qty=copies)
PRF_PHOTOBOOK_FIXED  "포토북 사이즈/표지타입별 기본가(24P)"
  └─ COMP_PHOTOBOOK_BASE (disp_seq 1, addtn_yn Y)
        comp_typ .06 · prc_typ .01(단가형 → unit_price × copies)
        use_dims = ["siz_cd", "opt_cd", "min_qty"]
        단가행 11 = (siz_cd × opt_cd[표지타입]) 정확매칭 + min_qty=1
  바인딩: PRD_000100 ← PRF_PHOTOBOOK_FIXED  (apply_bgn_ymd 2026-06-06)

[내지 구성원] (member eval — qty=내지qty=copies×⌈(page−24)/2⌉)   ★신규(page 해결)
PRF_PHOTOBOOK_INNER  "포토북 내지 추가2P당(사이즈별)"
  └─ COMP_PHOTOBOOK_PAGE (disp_seq 1, addtn_yn Y)
        comp_typ .06 · prc_typ .01(단가형 → unit_price × 내지qty)
        use_dims = ["siz_cd", "min_qty"]   (opt_cd 불요=표지무관)
        단가행 4 = siz_cd별 추가2P당(500/1000/300/600) + min_qty=1
  바인딩: PRD_000101 ← PRF_PHOTOBOOK_INNER  (apply_bgn_ymd 2026-06-06)
```

094와의 차이: 094는 표지타입 같은 3분기 축이 없어 component를 분리(S1/S2)했지만, 포토북은 표지타입을 **opt_cd 단일 차원**으로 가른다(§4 근거). page 추가가는 094도 미해결이었으나(내지 무공식) 본 설계가 내지 구성원 단가형으로 해결(§3).

### 2.3 엔진 계약 정합 (pricing.py 실측)
- set_eval이 set_selections를 selections로 그대로 받는다 → 위젯이 `{siz_cd, opt_cd}`를 set_selections에 넣으면 단가행 NON_QTY_DIMS 정확매칭.
- `match_component`: siz_cd·opt_cd는 NON_QTY_DIMS(정확매칭, 행값 NULL=와일드카드). min_qty는 TIER(하한). 11행 중 손님의 (siz, 표지타입) 하나만 매칭 → 단일행 → ERR_AMBIGUOUS 없음.
- 손님이 opt_cd 미선택 시 11행 전부 매칭 후보 → combos 2개 이상 → ERR_AMBIGUOUS. 즉 **표지타입 필수**(위젯 계약). 094도 print_opt 미선택 시 양 component 모두 no-match=0이었던 것과 같은 "필수 선택" 성격.

---

## 3. ★page 선형증가 모델 — 내지 구성원으로 해결(완성)

### 3.0 ★이전 BLOCKED 판정 정정(해소)
초안에서 "page추가가는 엔진으로 표현 불가(OI-1 BLOCKED·저청구)"로 단정했으나 **오판이었다**. 그 분석은 **부모 set_eval 단일호출**만 봤고, evaluate_set_price의 **구성원별 evaluate_price 합산**(member qty 자유도)을 놓쳤다. 동료 검증으로 정정·해소.

### 3.1 해결 메커니즘 (pricing.py:844 evaluate_set_price 재정독)
evaluate_set_price는 부모 set_eval 외에 **구성원마다** `evaluate_price({"prd_cd":sub_cd}, mb["selections"], mqty_i)`를 호출하고 `contribution = res["base"]["amount"]`를 `base_total`에 합산한다(pricing.py:904~910). **mqty_i = 호출자(시뮬레이터/위젯)가 산출해 넘긴 자유 qty** — copies와 독립.
→ 내지 구성원에 **추가2P당을 단가형(.01)**으로 실으면 내지 qty만큼 곱해진다(`component_subtotal: unit_price × mqty_i`).
→ 위젯이 **내지 qty = copies × ⌈(page−24)/2⌉**로 넘기면 `추가2P당 × copies × page-step` = **page 선형증가 정확 산출**.
→ page≤24 → step=0 → 내지 qty=0 → member 루프 `mqty_i < 1` 가드로 **기여 0(included=False·경고만)** → 기본24P만. 권위 정확.

### 3.2 ★확정 설계 (2-레이어)
```
[부모 세트공식] PRD_000100 ← PRF_PHOTOBOOK_FIXED ← COMP_PHOTOBOOK_BASE
    기본24P[siz_cd × opt_cd 표지타입] × copies. 단가행 11. (기존 유지)
[내지 구성원]   PRD_000101 ← PRF_PHOTOBOOK_INNER ← COMP_PHOTOBOOK_PAGE   ★신규
    추가2P당[siz_cd] × 내지qty. prc_typ .01(단가형). use_dims=["siz_cd","min_qty"].
    단가행 4(사이즈별·표지타입 무관·opt_cd NULL): 8x8=500/10x10=1000/A5=300/A4=600.
    바인딩 PRD_000101 ← PRF_PHOTOBOOK_INNER (apply_bgn_ymd 2026-06-06).
```
- **추가2P당 권위 재확인(날조 0)**: photobook-l1.csv 직접 재추출 → 사이즈별 동일·**표지타입 무관**(8x8=500/10x10=1000/A5=300/A4=600, 표지 3종 전부 같은 값). → opt_cd 불요·siz_cd 단일 차원·4행으로 충분.
- **search-before-mint**: PRF_PHOTOBOOK_INNER·COMP_PHOTOBOOK_PAGE 기존 부재 확인(라이브 count 0) → 신규 mint. 094 패턴 채번.

### 3.3 위젯/시뮬레이터 계약 (OI-PAGE)
- 내지 구성원(PRD_000101)을 `qty_mode='manual'`, `qty = copies × ⌈(page−24)/2⌉`, `selections={siz_cd}`(부모와 동일 사이즈)로 members에 넣는다.
- page≤24면 step=0 → 내지 qty=0 → 내지 기여 0(경고 발생하나 가격 정확). ★깔끔하게는 page=24일 때 내지 member를 빼거나 위젯이 step≥1만 전달(경고 회피) — OI-PAGE로 명기.

### 3.4 ★094 엽서북 동일 구조 관찰 (사실만)
094 내지 PRD_000095도 무공식(바인딩 0)이라 동일 구조다. 단 094 page_rule은 부모(PRD_000094) 20~30·증가10으로 범위가 좁고 셋트라 영향 제한적 — page 추가가 미반영 가능성은 **사실로 기록**하되, 별도 검증 없이 과한 결함 단정은 하지 않는다(094는 본 설계 범위 밖·별도 점검 대상).

---

## 4. 표지타입 차원 결정 (과제1)

### 4.1 후보 비교
| 후보 | 방식 | 판정 |
|---|---|---|
| (a) opt_cd 차원 | set_selections.opt_cd=표지타입코드, NON_QTY_DIM 정확매칭 | **채택** |
| (b) 094식 component 분리 | 표지타입마다 COMP_PHOTOBOOK_HARD/LEATHER/SOFT 3개 | 비채택(comp 3개+배선 3개 과다·단가행 분산) |
| (c) 표지 sub_prd_cd 신호 | 표지 구성원 코드로 분기 | 비채택(엔진은 set_selections만 봄·sub_prd_cd는 set_eval에 안 들어감) |

### 4.2 채택 근거
- **search-before-mint**: opt_cd는 component_prices의 NON_QTY_DIMS 정식 차원이며 DIM_META에 `("옵션코드","text",...)`로 등록된 시뮬레이터 1급 입력 차원. 094 같은 단가형이 print_opt_cd를 쓴 것과 동형. 표지타입 = 사이즈와 직교하는 비-수량 선택축 → opt_cd가 자연.
- **코드값 컨벤션 = OPV_NNNNNN(라이브 표준)**. component_prices.opt_cd에 등장하는 코드값은 **100% OPV 패턴**(43개 전부 OPV·다른 prefix 0). 표지타입 전용 기존 OPV는 **부재**(search 완료: 커버 OPV는 유광/무광투명커버·린넨커버·엽서북-표지 등 타상품 타의미라 verbatim 재사용 불가) → **신규 채번 OPV_000484(하드)/OPV_000485(레더하드)/OPV_000486(소프트)** (전역 OPV MAX=483 → MAX+1). ★초안의 `CVR_*`는 라이브 컨벤션 위반이라 폐기.
- opt_cd는 component_prices에 FK 없음(실측: siz_cd/mat_cd/clr_cd/proc_cd/print_opt_cd/plt_siz_cd만 FK) → 단가행 적재에 코드마스터 DDL 불요. 단, 코드값 자체는 OPV 네임스페이스(t_prd_product_options) 표준을 따른다.
- 단일 component(b 대비)라 단가행이 한 곳에 모이고 ERR_AMBIGUOUS 없음(siz_cd×opt_cd 조합이 11행 모두 유니크).

### 4.3 ★OI-3 — 표지타입을 set_selections로 보내는 경로 (위젯 계약·미해결)
동료 검증의 핵심 지적: **set_eval은 부모 자기공식이라 members(어느 표지 구성원을 넣었는지)와 무관**하다. 표지타입이 부모 단가행에 도달하려면 **반드시 set_selections.opt_cd가 채워져야** 한다. 라이브 코드로 그 경로를 확정했다:

- **시뮬레이터**: `_build_sim_meta`가 공식 use_dims의 opt_cd 차원을 입력으로 노출하고, opt_cd 드롭다운은 `_opt_cd_options` = **`TPrdProductOptions.objects.filter(prd_cd=prd_cd)`** 에서 채운다(price_views.py:1361). 즉 **부모 PRD_000100에 opt_cd 옵션이 등록돼 있어야** 시뮬레이터가 표지타입을 set_selections.opt_cd로 띄울 수 있다.
- **현재 상태**: PRD_000100 옵션/옵션그룹/옵션아이템 **전부 0개**(실측). → 단가행만 적재하면 **시뮬레이터가 표지타입을 set_selections로 못 보낸다** → 표지타입 미선택 시 11행 동시매칭 → **ERR_AMBIGUOUS(가격 안 나옴)**.
- **선결 과제(dbmap CPQ 트랙)**: PRD_000100에 "표지타입" 옵션그룹 + 옵션값 OPV_000484~486을 등록(t_prd_product_options) + option_items 매핑. 094 엽서북 선례 = "셋트구성" 옵션그룹(OPT_000037)이 내지/표지 구성원을 OPT_REF_DIM.07(셋트)로 가른 패턴. ★단 OPT_REF_DIM 체계엔 범용 opt_cd 차원이 없다(.01사이즈/.02판형/.03자재/.04공정/.05묶음수/.06도수/.07셋트뿐) → 표지타입을 opt_cd 단가행 차원으로 보내려면 위젯/CPQ가 표지타입 옵션값을 set_selections.opt_cd로 직접 매핑하는 계약이 필요(OPT_REF_DIM.08 신설 또는 위젯 직매핑 — dbmap CPQ 심의).
- **대안(dim_vals `cover_type` 키)**: 코드값 mint 없이 의미값 매칭 가능하나, opt_cd가 엔진/시뮬레이터 1급 차원이라 진단·CPQ 정합이 우월 → opt_cd 채택. dim_vals는 백업안.

→ **결론**: 단가행 설계(이 SQL)는 정확하나, 표지타입 가격이 실제 견적에 나오려면 OI-3(옵션그룹 등록 + 위젯 set_selections.opt_cd 계약)이 **선결**. 이 SQL만 COMMIT하면 단가행은 준비되나 시뮬레이터/위젯에서 표지타입 선택 경로가 비어 가격 미산출(또는 ERR_AMBIGUOUS).

---

## 5. 수기 검산표 (설계 단가행 ↔ 권위 11조합, copies=1·page=24 기준)

prc_typ .01 단가형: `subtotal = unit_price × copies`. min_qty=1 단일밴드 → copies≥1이면 unit_price 그대로(per_item).
page=24(기본)일 때 권위 = 기본24P. copies=1이면 set_eval contribution = unit_price.

| # | siz_cd | opt_cd | 설계 unit_price | 권위 기본24P | copies=1 산출 | 일치 |
|---|---|---|---|---|---|---|
| 1 | SIZ_000269 | OPV_000484 | 15000 | 15000 | 15000 | ✅ |
| 2 | SIZ_000269 | OPV_000485 | 23000 | 23000 | 23000 | ✅ |
| 3 | SIZ_000269 | OPV_000486 | 12000 | 12000 | 12000 | ✅ |
| 4 | SIZ_000274 | OPV_000484 | 22000 | 22000 | 22000 | ✅ |
| 5 | SIZ_000274 | OPV_000485 | 32000 | 32000 | 32000 | ✅ |
| — | SIZ_000274 | (소프트) | — 미생성 | 빈칸 | (매칭0) | ✅ 미제공 |
| 6 | SIZ_000170 | OPV_000484 | 12000 | 12000 | 12000 | ✅ |
| 7 | SIZ_000170 | OPV_000485 | 19000 | 19000 | 19000 | ✅ |
| 8 | SIZ_000170 | OPV_000486 | 10000 | 10000 | 10000 | ✅ |
| 9 | SIZ_000172 | OPV_000484 | 16000 | 16000 | 16000 | ✅ |
| 10 | SIZ_000172 | OPV_000485 | 26000 | 26000 | 26000 | ✅ |
| 11 | SIZ_000172 | OPV_000486 | 13000 | 13000 | 13000 | ✅ |

**11/11 권위 일치(page=24·copies=1).** copies=N이면 ×N(예: A4 하드 copies 10 = 160000).
검산 2(copies 곱): A4 하드 copies 10 page 24 → 권위 16000×10=160000, 엔진 unit_price 16000 ×copies 10 = 160000 ✅.

### 5.1 ★page>24 검산표 (기본가 + 내지 추가2P당 합산 = 권위 정확)
공식: `총가 = copies × (기본24P[siz×표지] + 추가2P당[siz] × ⌈(page−24)/2⌉)`.
내지 qty = copies × ⌈(page−24)/2⌉. set_eval(base) + 내지 contribution(추가2P당 × 내지qty).

| siz | 표지 | page | copies | step=⌈(p-24)/2⌉ | base(기본×copies) | 내지(추가2P당×내지qty) | 합 | 권위 | 일치 |
|---|---|---|---|---|---|---|---|---|---|
| A4 SIZ_000172 | 하드 OPV_000484 | 50 | 1 | 13 | 16000×1=16000 | 600×(1×13)=7800 | 23800 | 16000+13×600=23800 | ✅ |
| 8x8 SIZ_000269 | 하드 OPV_000484 | 40 | 2 | 8 | 15000×2=30000 | 500×(2×8)=8000 | 38000 | 2×(15000+8×500)=38000 | ✅ |
| 10x10 SIZ_000274 | 레더 OPV_000485 | 100 | 1 | 38 | 32000×1=32000 | 1000×(1×38)=38000 | 70000 | 32000+38×1000=70000 | ✅ |
| A5 SIZ_000170 | 소프트 OPV_000486 | 24 | 5 | 0 | 10000×5=50000 | 0(내지 qty0·기여0) | 50000 | 5×10000=50000 | ✅ |
| A4 SIZ_000172 | 하드 OPV_000484 | 150 | 1 | 63 | 16000 | 600×63=37800 | 53800 | 16000+63×600=53800 | ✅ |

→ 사이즈별·page 케이스 전부 권위 정확 일치(이전 초안의 −37800 저청구는 내지 구성원으로 **해소**).
page=24(A5 5부) 케이스 = step0 → 내지 qty0 → 기여0 → 기본가만(권위 정확). ✅

---

## 6. DRY-RUN 결과 (psql -f 실행 검증)

```
BEGIN ... (10 INSERT: 공식2·구성요소2·배선2·단가행11+4·바인딩2) ... ROLLBACK
검증 카운트: FIXED공식1 / INNER공식1 / BASE구성요소1 / PAGE구성요소1
             / BASE단가행11 / PAGE단가행4 / 바인딩2
```
- **PK충돌 0** · 통합 카운트 = **공식2·구성요소2·배선2·단가행15·바인딩2**(권위 verbatim 일치).
  - 기본24P 11행(10×10 소프트커버 제외) + 추가2P당 4행(500/1000/300/600·opt_cd NULL).
- **멱등 검증**: INSERT 블록 2회 실행 → 1차 정상, 2차 전부 INSERT 0 0(NOT EXISTS 가드) → 카운트 불변. 중복 0.
- ★IDENTITY 시퀀스 stale(last_value 40329 < MAX 40332). DRY-RUN은 comp_price_id 명시부여로 회피, **fix.sql은 setval 동기화 정석** 사용.

---

## 7. 열린 이슈 (위젯 계약 / CPQ 연결)

| # | 이슈 | 영향 | 경로 |
|---|---|---|---|
| ~~OI-1~~ | ~~page 추가가 미반영 = 저청구~~ → **해소(내지 구성원 PRD_000101 단가형 추가2P당)**. page 선형증가 정확 산출. | — | 닫힘 |
| OI-PAGE | 내지 qty 위젯 계약 | page-step 산식(copies×⌈(page−24)/2⌉)은 **위젯이 계산해 내지 member qty로 전달**. page=24면 step0→내지 빼거나 qty≥1만 전달(경고 회피). 내지 selections={siz_cd}(부모 사이즈와 동일) | 위젯 구현 계약(코드 외부·데이터는 적재 완료) |
| OI-2 | 10×10 소프트커버 미제공 | 손님이 선택 시 매칭0(견적불가) | 권위 빈칸=정상. 위젯이 해당 조합 비활성화 필요 |
| OI-3 | **표지타입 → opt_cd CPQ 연결 부재(선결)** | PRD_000100 옵션 0개 → 시뮬레이터가 표지타입을 set_selections.opt_cd로 못 보냄 → 미선택 시 ERR_AMBIGUOUS(가격 안 나옴) | PRD_000100에 "표지타입" 옵션그룹+OPV_000484~486 등록(t_prd_product_options) + 위젯 set_selections.opt_cd 매핑 계약. OPT_REF_DIM에 opt_cd 차원 부재 → .08 신설 또는 위젯 직매핑(dbmap CPQ 심의). ★단가행 COMMIT만으론 불충분 |
| OI-4 | 실 simulate_set 가격검증 미수행 | DRY-RUN은 미COMMIT이라 시뮬레이터(별 connection)서 안 보임 | COMMIT 후 사람이 simulate_set 실호출 검증(§fix.sql 주석) |

---

## 8. 안전 준수
- 읽기전용 SELECT + DRY-RUN(BEGIN/ROLLBACK)만. 실 COMMIT/DDL/INSERT-COMMIT 0. webadmin 코드수정 0. git 커밋 0.
- 단가 = 권위 가격표(260610) verbatim(날조 0). 10×10 소프트커버 미제공 = BLOCKED 명시.
- search-before-mint: opt_cd 차원 재사용(표지타입 전용 OPV 부재 확인 → 신규 OPV_000484~486만 mint·전역 OPV MAX 483 기준). 094 패턴 채번(PRF_<X>_FIXED, COMP_<X>_BASE). 코드값=라이브 OPV_NNNNNN 컨벤션 준수(CVR_* 폐기).
- fix.sql은 ★사람 검토용·자동 실행 금지(ROLLBACK 기본값).
