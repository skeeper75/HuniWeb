# 포토북 — CPQ 옵션/템플릿/제약 반영 설계 (cpq-plan)

> **작성** 2026-06-14 · round-13. 사용자 기준 5번 = "기초데이터(size/자재/공정/도수/페이지)만이 아니라 option/template/constraint까지 묶어 설계".
> **라이브 CPQ 스키마(2026-06-14 실측):** `t_prd_product_option_groups`(opt_grp_cd·sel_typ_cd·min/max_sel_cnt·mand_yn) → `t_prd_product_option_items`(opt_cd·ref_dim_cd polymorphic·ref_key1/2·qty) → `t_prd_product_constraints`(rule_typ_cd·logic JSONLogic·err_msg).
> **[HARD] 설계까지** — 실제 CPQ 적재는 인간 승인. 차원행 미적재면 "L1 선적재 BLOCKED" 정직 표기.
> **polymorphic ref_dim_cd(OPT_REF_DIM 7종):** 사이즈·판형·자재·공정·묶음수·도수·셋트.

---

## 1. 포토북 CPQ 귀속 대상 (정체 기반)

포토북은 **1상품 + variant(size 4 × 표지타입 3)** 다. variant 차이는 size 차원·표지 sub_prd·페이지·가격으로 흡수하되, **고객 선택축**은 CPQ 옵션으로 노출해야 한다.

| 속성 | 선택축? | 기초데이터 적재? | CPQ 레이어 |
|------|:--:|------------------|------------|
| 사이즈(8x8·10x10·A5·A4) | ✅ 택1 | sizes 4행 적재됨 | **option_group(택1·size 참조)** |
| 표지타입(하드/소프트/레더…) | ✅ 택1 | sub_prd(표지 5종) 적재됨 | **option_group(택1·셋트/자재 참조)** |
| 페이지(책등) | ✅ 가변 | page_rule 1행(하드 기준) | **표지타입별 차등 → option 종속(Q-PB-1)** |
| 무광코팅 공정 | 표지 종속(자동) | 공정 0행→W-01 연결 | (표지타입 종속·고객 직접선택 아님) |
| PUR제본 | 고정(필수) | 공정 적재됨·W-02 필수화 | (필수·옵션 아님) |
| 도수(내지양면/표지단면) | 고정 | print_options 2행 적재됨 | (적재 완료·CPQ 불요) |

---

## 2. 표지타입 ↔ 페이지(책등) 차등 — option_group + constraint (Q-PB-1 귀속)

**문제(L1 권위·2026-06-14 재파싱):** 표지타입별로 책등(=페이지 범위)이 다르다 —
- 하드커버/레더하드커버: 책등 **10/12/14/16** (페이지 24~150·2씩)
- 소프트커버: 책등 **4/6/8/10/12/14** (페이지 범위 다름)

라이브 `t_prd_product_page_rules` PK=prd_cd(상품당 1행)라 표지타입별 차등을 **한 테이블에 못 담음** → 라이브는 하드 기준 24/150/2 단일행만. 표지타입을 CPQ 옵션으로 두고 옵션 선택에 페이지 범위를 종속시켜야 차등 표현 가능.

**설계(포토북 PRD_000100 기준):**

```
[option_group] OG-100-COVER (표지타입)
  sel_typ_cd=택1 · mand_yn=Y · min=1 max=1
  [option_items] ref_dim_cd=셋트(표지 sub_prd 참조)
    item1: 하드커버    (ref_key1=PRD_000102) → 페이지 24~150·2 / 책등 10·12·14·16
    item2: 소프트커버   (ref_key1=PRD_000107) → 페이지 범위 소프트 / 책등 4·6·8·10·12·14
    item3: 레더하드커버  (ref_key1=PRD_000105) → 책등 10·12·14·16
    item4: 레더        (ref_key1=PRD_000106)
    item5: 아트250종이표지(ref_key1=PRD_000103)

[constraint] CON-100-PAGEBYCOVER
  rule_typ_cd=캐스케이드(표지타입→페이지범위)
  logic(JSONLogic): {"if":[{"==":[{"var":"cover"},"soft"]},
                          {"in":[{"var":"page"},[4,6,8,10,12,14,...]]},
                          {"in":[{"var":"page"},[24..150 step 2]]}]}
  err_msg: "선택한 표지타입에 맞는 페이지 범위만 선택 가능합니다"
```

> **L1 선적재 의존성:** 표지 sub_prd(102/103/105/106/107) **실재**(라이브 sets 7행 확인). size 4 + 표지 sub_prd 5 모두 적재됨 → option_items 참조 대상 실재. **L1 선적재 BLOCKED 아님** — Q-PB-1(페이지 차등 모델: page_rule 1행 유지 vs CPQ 옵션 종속) 결정 후 CPQ 적재 가능.

---

## 3. 사이즈 — option_group(택1) (적재 완료·CPQ 재구성만)

**문제:** 사이즈 4종(8x8·10x10·A5·A4)은 `t_prd_product_sizes` 4행 적재됨. CPQ 레이어로 노출하려면 option_group으로 재구성.

```
[option_group] OG-100-SIZE (사이즈)
  sel_typ_cd=택1 · mand_yn=Y
  [option_items] ref_dim_cd=사이즈
    8x8(SIZ_000269) / 10x10(SIZ_000274) / A5(SIZ_000170) / A4(SIZ_000172)
```

> **소프트 10x10 비활성 constraint:** L1 가격 매트릭스에서 **소프트커버 × 10x10 조합은 가격 공란(row 8)** = 비활성(활성 11조합). CPQ constraint로 "소프트커버 선택 시 10x10 비활성" 표현 필요.
> ```
> [constraint] CON-100-SOFT10X10
>   logic: {"!":{"and":[{"==":[{"var":"cover"},"soft"]},{"==":[{"var":"size"},"10x10"]}]}}
>   err_msg: "소프트커버는 10x10 사이즈를 지원하지 않습니다"
> ```
> 근거: L1 row 8(소프트 10x10) 가격_기본·책등 전부 공란 = 판매 안 함.

---

## 4. CPQ 적재 준비 상태 요약

| CPQ 항목 | 기초데이터 선적재 | CPQ 적재 가능? | BLOCKER |
|----------|-------------------|:--:|---------|
| 사이즈 택1 | sizes 4행 실재 | ✅ 가능 | 모델 결정만 |
| 표지타입 택1 | 표지 sub_prd 5 실재 | ✅ 가능 | 모델 결정(Q-PB-1) |
| 페이지 차등(표지 종속) | page_rule 1행(하드) | 부분 | 차등 적재처 = CPQ 옵션 종속 결정(Q-PB-1) |
| 소프트 10x10 비활성 | 가격 매트릭스(미적재) | 부분 | 가격 적재(W-05) 후 constraint 확정 |
| 무광코팅(표지 종속) | W-01 후 공정 실재 | ✅ | 표지타입 종속(고객 직접선택 아님) |

> **종착(비파괴):** 본 산출은 CPQ **설계까지**. option_groups/items/constraints 실 적재는 ① 기초데이터(공정 W-01) 선적재 ② Q-PB-1(페이지 차등 모델)·Q-PB-3(가격) 컨펌 후 인간 승인. L1 선적재 BLOCKED 0건(사이즈·표지 sub_prd 전부 실재) — 디지털인쇄(봉투 template BLOCKED)와 달리 포토북은 차원행 선적재가 충족돼 모델 결정만 남음.
