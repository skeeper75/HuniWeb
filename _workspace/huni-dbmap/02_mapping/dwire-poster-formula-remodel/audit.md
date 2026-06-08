# D-WIRE 전수 배선 감사 (full wiring audit) — 가격공식↔구성요소↔상품 사슬 단절

| 항목 | 값 |
|------|----|
| 생성 | dbm-mapping-designer (dbm-price-formula 스킬) |
| 일자 | 2026-06-07 |
| 권위 | **라이브 railway DB(pg18.4) 실측** (read-only SELECT, `BEGIN; SET TRANSACTION READ ONLY; … ROLLBACK;`) |
| DDL 권위 | `00_schema/price-engine-ddl.md` (4단 엔진 + 상품바인딩 2 + 보조 1) |
| 범위 | round-2 가격엔진 **전 공식**(poster 한정 아님 — 일반화 감사) |

## 0. 한 줄 결론
라이브 16 공식을 전수 감사한 결과 **4 공식이 가격조회 사슬 단절(broken-chain)** — `PRF_POSTER_FIXED`(28바인딩/1배선, 27상품 차단), `PRF_BIND_SUM`(4/1, 3상품 차단), `PRF_NAMECARD_FIXED`(3/2, 2상품 차단), `PRF_PHOTOCARD_FIXED`(2/2, **공유공식 라우팅 불가 = 2상품 모호차단**). 근본원인 공통 = **여러 상품이 1 공유공식에 묶였으나 `formula_components`는 공식당이라 상품별 comp 분기 불가**(라이브에 상품→comp 직결 테이블 **부재** 실증). 본 트랙은 그중 `PRF_POSTER_FIXED`(28상품)를 **상품별(=comp별 1:1) 공식 재모델**로 해소한다.

---

## 1. 사슬 구조 (price chain)

```
상품(prd_cd)
  → t_prd_product_price_formulas(prd_cd → frm_cd)          [상품→공식]
    → t_prc_formula_components(frm_cd → comp_cd[])          [공식→구성요소 — 공식당, 상품무관]
      → t_prc_component_prices(comp_cd, siz/clr/mat… → unit_price)  [구성요소→단가]
```

[HARD·실측] **상품→comp 직결 경로 부재.** `information_schema.columns` 조회: `comp_cd` 컬럼을 가진 `t_prd_*` 테이블 = **0행**. 즉 엔진은 `prd_cd → frm_cd → comp_cd[]` 로만 comp 를 찾으며, **공유공식의 comp_cd[] 를 상품별로 필터할 방법이 없다.** → 한 공식에 N개 "택일(select-one)" comp 를 배선하면 **모든 바인딩 상품이 N개 comp 전부를 보게 된다**(상품별 분기 불가). 이것이 D-WIRE 의 구조적 뿌리.

---

## 2. 전수 배선 감사 표 (16 공식)

`n_wired_comps` = `t_prc_formula_components` 의 해당 frm_cd 배선 수. `n_bound_products` = `t_prd_product_price_formulas` 바인딩 수. `n_broken` = 바인딩 상품 중 **자기 고유 comp 가 공식에 미배선**(또는 공유공식이라 라우팅 불가)으로 가격조회 불가한 상품 수.

| frm_cd | frm_typ | n_wired_comps | n_bound_products | n_broken | 분류 | 비고 |
|---|---|--:|--:|--:|---|---|
| `PRF_POSTER_FIXED` | .02 | **1** | **28** | **27** | **BROKEN** | comp 1개(ARTPRINT)만 배선, 27상품 각자 comp 미배선. **본 트랙 해소 대상** |
| `PRF_DGP_A` | .01 | 29 | 9 | 0 | OK(원자합산) | 디지털인쇄 합산형, 9상품 동일 공식 정당공유(공식=레시피) |
| `PRF_BIND_SUM` | .01 | 1 | 4 | **3** | **BROKEN** | JUNGCHEOL만 배선. 무선/PUR/트윈링 comp 존재+단가(8행) 미배선 |
| `PRF_DGP_C` | .01 | 5 | 3 | 0 | OK(원자합산) | |
| `PRF_DGP_E` | .01 | 10 | 3 | 0 | OK(원자합산) | |
| `PRF_NAMECARD_FIXED` | .02 | 2 | 3 | **2** | **BROKEN** | STD_S1/S2만 배선. 프리미엄/코팅 comp 존재+단가 미배선 |
| `PRF_STK_FIXED` | .02 | 1 | 3 | 0 | OK(정당공유) | 3상품(반칼/반칼투명/낱장) 모두 **단일 매트릭스** COMP_STK_PRINT(258행) 공유. 상품별 comp 부재가 정상 |
| `PRF_DGP_B` | .01 | 4 | 2 | 0 | OK(원자합산) | |
| `PRF_PHOTOCARD_FIXED` | .02 | 2 | 2 | **2** | **BROKEN(모호)** | SET+CLEAR_SET 둘 다 배선됐으나 **공유공식 = 두 상품이 두 comp 전부 봄**. 포토카드↔SET, 투명포토카드↔CLEAR_SET 라우팅 불가 |
| `PRF_DGP_D` | .01 | 20 | 1 | 0 | OK | 단일상품 |
| `PRF_DGP_F` | .01 | 4 | 1 | 0 | OK | 단일상품 |
| `PRF_ENV_MAKING` | .02 | 1 | 1 | 0 | OK | 단일상품·단일comp |
| `PRF_FOLD_SUM` | .01 | 1 | 1 | 0 | OK | 단일상품 |
| `PRF_GANGPAN_FIXED` | .02 | 1 | 1 | 0 | OK | 단일상품·단일comp |
| `PRF_PCB_FIXED` | .02 | 2 | 1 | 0 | OK | 단일상품, S1+S2(앞뒤 규격) 2comp = 동일상품 내 변형(정당) |
| `PRF_TTEOKME_FIXED` | .02 | 1 | 1 | 0 | OK | 단일상품·단일comp |
| **합계** | | | | **34 broken** | | broken 4공식 / 정상 12공식 |

> **`PRF_POSTER_FIXED` = 28 bound / 1 wired** 확정(과제 명세 일치). 배선 comp = `COMP_POSTER_ARTPRINT_PHOTO` 단 1행(disp_seq=1, addtn_yn='Y').

---

## 3. 공유공식 정당성 판정 (legitimately-shared vs broken)

핵심 판별 = **"바인딩 상품들이 동일 comp(들)를 진짜 공유하는가, 아니면 각자 다른 comp 가 필요한가."** 후자인데 공유공식에 묶이면 broken.

| frm_cd | 바인딩 상품의 comp 요구 | 판정 | 근거 |
|---|---|---|---|
| `PRF_STK_FIXED` | 3상품 전부 **동일 매트릭스** COMP_STK_PRINT(반칼 규격/사이즈 매트릭스) | **LEGIT-SHARED** | 가격구조가 완전 동일(컷형상만 상이, 가격 무관). 공유가 의도. rebind 불요 |
| `PRF_DGP_A~F` | 디지털인쇄 "레시피"(인쇄비+코팅비+용지비+…) 공식을 동일 카테고리 상품군이 공유, 상품별 차이는 component_prices 차원(siz/mat)으로 흡수 | **LEGIT-SHARED** | 원자합산형 = 공식이 곧 계산 레시피. 합산 comp 전부가 모든 상품에 적용됨(택일 아님) |
| `PRF_POSTER_FIXED` | 28상품 **각자 다른 완제품가 comp**(소재별 통가격) | **BROKEN** | ARTPRINT 가격을 메쉬현수막에 적용 불가. 택일형 comp 인데 공유공식이라 분기 불가 |
| `PRF_BIND_SUM` | 4상품 각자 다른 제본 comp(중철/무선/PUR/트윈링) | **BROKEN** | 제본종류=상품 정체성. 1 comp 만 배선 |
| `PRF_NAMECARD_FIXED` | 3상품 각자 다른 명함 comp(프리미엄/코팅/스탠다드) | **BROKEN** | 등급별 가격 상이. STD만 배선 |
| `PRF_PHOTOCARD_FIXED` | 2상품 각자 comp(일반세트/투명세트) | **BROKEN(모호)** | 둘 다 배선돼도 라우팅 불가(상품→comp 필터 부재) |

[적대적 주의] **"원자합산형(DGP) = 정당공유"와 "단순형 완제품가(POSTER/BIND/NAMECARD) = broken" 의 차이**: 원자합산형은 배선된 comp 가 **전부 합산**되어 모든 상품에 적용된다(택일 아님 → 공유 정당). 단순형 완제품가는 comp 가 **상품별 택일 단가**라서 공유공식에 묶으면 분기 불가. 즉 broken 여부 = `addtn_yn` 의미 + 상품군의 comp 동질성으로 판정해야지, `n_wired>1` 만으로 OK 판정하면 PHOTOCARD 를 놓친다.

---

## 4. 근본원인 (root cause) — 왜 공유공식이 단순형 완제품가에서 깨지나

1. `t_prc_formula_components` PK = `(frm_cd, comp_cd)` — **공식당** comp 목록. 상품 축 없음.
2. 상품→comp 직결 테이블 **부재**(§1 실측). → 엔진은 `prd_cd → frm_cd` 후 그 공식의 comp 전부를 본다.
3. 28상품을 1 `PRF_POSTER_FIXED` 에 묶으면:
   - **현재(1배선)**: 27상품이 comp 0개 조회 → **가격 NULL(사슬 단절)**.
   - **가정(28배선 전부, addtn_yn='Y')**: 모든 상품이 28 comp **전부 합산** → 메쉬현수막 가격에 아트프린트+족자+… 다 더해짐(**오가격**).
   - **가정(28배선 전부, addtn_yn='N' 택일)**: 엔진이 28 comp 중 **어느 것이 이 상품 것인지 알 수 없음**(상품→comp 필터 부재) → 라우팅 불가.
4. **유일 해법 = 상품별 1공식(per-product) 모델**: 각 상품이 자기 comp(들)만 가진 `PRF_POSTER_<X>` 를 갖고 거기 바인딩. 그러면 `prd_cd → PRF_POSTER_<X> → 자기 comp` 로 정확히 해소.

---

## 5. live-vs-doc 모순 (검증 결과)

| # | 문서 주장 | 라이브 실측 | 판정 |
|---|----------|------------|------|
| LD-1 | `silsa-poster-area-matrix/mapping.md` 초판 §4.3: "PRF_POSTER_FIXED ↔ 13 comp 배선 라이브 확인, 신규 INSERT 불요" | 배선 comp = **1개**(ARTPRINT)뿐 | **문서 over-claim 적발**(이미 동 문서가 2026-06-07 자가정정). 본 감사 재확증 |
| LD-2 | `price211-sticker-namecard/mapping.md`: NAMECARD 를 "shared formula `PRF_NAMECARD_FIXED` 에 7 comp wire(addtn_yn='N' 택일)" 로 설계 | 공유공식 + 택일 comp 다수 = **§1 라우팅 불가 구조** | **설계 모순.** 택일 comp 를 공유공식에 모으면 상품별 분기 불가 → 본 트랙의 per-product 모델이 정답. NAMECARD/PHOTOCARD/BIND 도 동일 재모델 필요(별도 트랙) |
| LD-3 | `price211-fixedgrid/mapping.md` §8 D-WIRE: "별도 배선 트랙 필요(17행+slice A 13행), 본 데이터 트랙 밖" | 30 base poster comp 존재, 28상품 바인딩 | **정합.** 본 트랙이 그 D-WIRE 를 per-product 재모델로 해소(배선만이 아니라 공식 분리까지) |

> [HARD] LD-2 는 중요 — 단순 "comp 를 공유공식에 더 배선"하는 fix 는 **틀렸다**(상품별 분기 불가). 올바른 fix = **상품별 공식 분리**. POSTER 외 BIND/NAMECARD/PHOTOCARD 도 같은 처방.
