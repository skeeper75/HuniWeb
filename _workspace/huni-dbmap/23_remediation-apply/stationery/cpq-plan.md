# 문구(stationery) — CPQ 옵션/템플릿/제약 반영 설계 (cpq-plan)

> **작성** 2026-06-14 · round-13. 사용자 기준 5번 = "기초데이터(size/자재/공정/도수/판형/묶음수)만이 아니라 option/template/constraint까지 묶어 설계".
> **라이브 CPQ 스키마(2026-06-14 실측):** `t_prd_product_option_groups`(opt_grp_cd·sel_typ_cd·min/max_sel_cnt·mand_yn) → `t_prd_product_option_items`(opt_cd·ref_dim_cd polymorphic·ref_key1/2·qty) → `t_prd_product_constraints`(rule_typ_cd·logic JSONLogic·err_msg).
> **[HARD] 설계까지** — 실제 CPQ 적재는 인간 승인. 차원행 미적재면 "L1 선적재 BLOCKED" 정직 표기.
> **polymorphic ref_dim_cd(OPT_REF_DIM 7종):** 사이즈·판형·자재·공정·묶음수·도수·셋트.
> **문구 특수성:** booklet(006) 구조 동형(내지+표지+제본). 박/형압 블록 없음. 가격포함 시트(가격은 round-2 트랙).

---

## 1. 문구 CPQ 귀속 대상 (정체 기반)

| 속성 | 어느 상품 | 기초데이터 적재? | CPQ 레이어 |
|------|-----------|------------------|------------|
| 커버타입(소프트/하드/레더하드/레더소프트) | 만년다이어리 4종 | 현재 별상품 4 적재(별 prd_cd) | **별상품 유지 vs 1상품+커버타입 option_group(택1)** — ST2-2 컨펌 |
| 면지 색(화이트/블랙/그레이) | 만년다이어리 하드(173)·레더하드(174) | 면지 0행(미적재) | **option_group(택1·면지색) + option_items(ref_dim_cd=자재)** |
| 링 색(실버링) | 스프링노트(177)·수첩(178) | 실버링 0행(고아 MAT_000016) | **자재 연결 vs 트윈링 링색 param** — Q-ST-I |
| 떡메모지 묶음수(50/100권) | 떡메모지(097) | bundle 2행 적재(둘 다 dflt=Y) | **option_group(택1·묶음수) + size 종속 constraint** |
| 단면/양면 도수 | 먼슬리(양면+단면) 등 | print_options 적재됨 | (적재 완료 — CPQ 불요) |

---

## 2. 커버타입 — 별상품 vs option_group (ST2-2 / Q-ST-B 연계)

**현황:** 라이브 = 만년다이어리 4종을 별 prd_cd(172~175)·별 MES(008-0020~0023)·별 카테고리 노드(119~122)로 적재. round-11 가설(A) 별상품 모델 정합.

**2안:**
- **(a) 별상품 유지(현 상태):** 4종 각각 독립 상품. CPQ option 불요. 카테고리만 정상 노드로 재연결(W-ST-01·apply.sql 즉시적용).
- **(b) 1상품 + 커버타입 option_group(택1):** 4종을 1상품으로 통합하고 커버타입을 option_group으로. 단 별 MES·별 가격(9000/12000/15000/15000)이라 통합 시 가격/MES 분기 constraint 필요.

> **권장:** (a) 별상품 유지 — 별 MES·별 가격이 별상품을 강하게 시사. CPQ 통합은 운영 복잡도 증가. **인간 컨펌(ST2-2).** 본 라운드 apply.sql은 (a) 전제(카테고리 재연결만).

---

## 3. 면지 색 — option_group(택1) + option_items (Q-ST-H 귀속)

**문제:** 만년다이어리 하드(173)·레더하드(174)는 `하드커버(면지?)` — 면지가 안 들어감(미적재). 면지 마스터 실재(실측 §12): 화이트 MAT_000001·블랙 002·그레이 003·인쇄 004(.01 종이).

**설계(173 기준):**

```
[기초데이터] t_prd_product_materials: (173, MAT_000001 화이트면지, USAGE.03) 연결  ← apply.sql 신규적재 블록
[option_group] OG-173-ENDPAPER (면지색)
  sel_typ_cd=택1 · mand_yn=N
  [option_items] ref_dim_cd=자재
    화이트(MAT_000001) / 블랙(MAT_000002) / 그레이(MAT_000003)
```

> **L1 선적재 BLOCKED 아님:** 면지 자재 마스터 실재 → 자재 연결 즉시 가능(apply.sql 신규적재 블록). 색 3종 variant 처리 방식만 컨펌(Q-ST-H). USAGE.03(면지) table-spec 코드 확인 동반.

---

## 4. 링 색(실버링) — 자재 vs param (Q-ST-I=BK-3 귀속)

**문제:** 스프링노트(177)·수첩(178) `실버링` — 미적재. 실버링 마스터 MAT_000016(.04 금속·라이브 0상품 연결=고아·실측 §12).

**2안(booklet BK-3 통합):**
- **(a) 부속 자재 연결:** materials에 MAT_000016 USAGE.07 연결(고아 재활용·search-before-mint).
- **(b) 트윈링 공정 param:** 트윈링제본(PROC_000021)의 prcs_dtl_opt 링컬러 param으로.

> **권장:** (a) 부속 자재 — 실버링은 물리 자재(금속 링). 단 색상 옵션이면 (b) param 병행. **컨펌(Q-ST-I=BK-3).** L1 선적재 BLOCKED 아님(MAT_000016 실재).

---

## 5. 떡메모지 묶음수 — option_group(택1) + size 종속 constraint (Q-ST-M 귀속)

**문제:** 떡메모지(097) bundle 50권·100권 둘 다 dflt_yn=Y(실측 §7b). 택1인데 기본 2개. L1: 90x90→50장1권·70x120→100장1권 (size별 묶음).

**설계:**

```
[기초데이터] t_prd_product_bundle_qtys: bdl_qty 50·100 (적재됨)
[option_group] OG-097-BUNDLE (묶음수)
  sel_typ_cd=택1 · mand_yn=Y
  [option_items] ref_dim_cd=묶음수
    50권(bdl_qty=50) / 100권(bdl_qty=100)
[constraint] CON-097-SIZEBUNDLE (size→묶음수)
  rule_typ_cd=캐스케이드
  logic(JSONLogic): {"if":[{"==":[{"var":"siz_cd"},"90x90"]},"50권","100권"]}
  err_msg: "선택한 사이즈에 맞는 묶음수만 선택 가능합니다"
```

> **dflt 중복 정리(W-ST-15):** size별 정합이면 dflt 2개도 정합(size 종속) → 유지. 아니면 1개만 Y(apply.sql 컨펌블록). **size별 묶음 매칭이 진짜 구조** → constraint로 표현.

---

## 6. CPQ 적재 준비 상태 요약

| CPQ 항목 | 기초데이터 선적재 | CPQ 적재 가능? | BLOCKER |
|----------|-------------------|:--:|---------|
| 커버타입(만년다이어리) | 별상품 4 적재 | (a 유지=불요) | ST2-2 모델 결정 |
| 면지 색(하드/레더하드) | 면지 마스터 실재·연결 0 | 부분 | 자재 연결 후(apply.sql) + USAGE.03 확인 |
| 링 색(스프링) | 실버링 마스터 실재(고아) | 부분 | 자재 vs param 결정(Q-ST-I) |
| 떡메모지 묶음수 | bundle 2행 적재 | ✅ 가능 | size 종속 constraint 설계 |

> **종착(비파괴):** 본 산출은 CPQ **설계까지**. option_groups/items/constraints 실 적재는 ① 기초데이터(면지·실버링) 선적재 ② ST2-2/Q-ST-H/Q-ST-I/Q-ST-M 컨펌 후 인간 승인. 미싱제본(W-ST-06)은 공정 마스터 신설(ddl) 선행 — CPQ 전 단계.
