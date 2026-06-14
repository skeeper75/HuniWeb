# 상품악세사리 — CPQ 옵션/템플릿/제약 반영 설계 (cpq-plan)

> **작성** 2026-06-14 · round-13. 사용자 기준 5번 = "기초데이터(size/자재/공정/도수/판형/묶음수)만이 아니라 option/template/constraint까지 묶어 설계".
> **라이브 CPQ 스키마(2026-06-14 실측):** `t_prd_product_option_groups`(opt_grp_cd·sel_typ_cd·min/max_sel_cnt·mand_yn) → `t_prd_product_option_items`(prd_cd·opt_cd·item_seq·ref_dim_cd polymorphic·ref_key1/2·qty·use_yn/del_yn) → `t_prd_product_constraints`(rule_typ_cd·logic JSONLogic·err_msg).
> **[HARD] 설계까지** — 실제 CPQ 적재는 인간 승인. 차원행 미적재면 "L1 선적재 BLOCKED" 정직 표기.
> **상품악세사리 특수성:** 색상 variant가 CPQ 핵심(볼체인 8색·리필잉크 7색)·봉투 세트는 디지털인쇄 Q-ID-A의 봉투 원천.

---

## 1. 상품악세사리 CPQ 귀속 대상 (정체 기반)

| 속성 | 어느 상품 | 기초데이터 적재? | CPQ 레이어 |
|------|-----------|------------------|------------|
| 색상 variant | 볼체인(006)·와이어링(007)·행택끈(010)·리필잉크(015) | **자재 오염 적재(MAT_TYPE.10 21행)** | **option_group(택1·색상) + option_items + 자재행 논리삭제** |
| 봉투/케이스 세트 | 배경지OPP(043)·케이스(044) ← 봉투 부자재(001/002/009) | 세트 0행(봉투 상품·template 실재) | **sets + constraint(사이즈매칭)** |
| 우드 길이 variant | 우드봉(013)·우드행거(014) | 전부 0(siz·material·option) | **option_group(택1·길이) 또는 siz(치수형)** — Q-PA-G |
| 묶음수 | 볼체인·천정고리·행택끈 | bundle 일부만 | (CPQ 아님 — bundle_qtys 기초데이터) |
| 카드봉투 색상+이중등록 | 카드봉투(004)·281/282 | 004=siz 합성·281/282=별 PRD | **option_group(색상) 일원화 — Q-PA-D** |

---

## 2. 색상 variant — option_group(택1) + 자재 오염 정리 (Q-PA-B 귀속·핵심)

**문제:** 볼체인 8색·와이어링 3색·행택끈 3종·리필잉크 7색이 전부 `t_mat_materials`에 **MAT_TYPE.10(자재 오염)**으로 적재(라이브 21행 실측). 정규화 권위(메모리 dbmap-material-option-normalization)는 "색상≠자재". 색상은 선택옵션이어야 함. 게다가 색상명에 묶음/용량("3개1팩"·"100개"·"5cc")이 합성돼 있음.

**설계(볼체인 006 기준·8색):**

```
[기초데이터 정리] t_prd_product_materials: 오염 자재행(MAT_000202~209) 논리삭제(use_yn='N')
                  묶음수("3개1팩") → t_prd_product_bundle_qtys(bdl_qty=3, QTY_UNIT.05 팩)로 분리
[option_group] OG-006-COLOR (색상)
  sel_typ_cd=택1 · mand_yn=Y · min=1 max=1
  [option_items] ref_dim_cd=색상(또는 OPT_REF_DIM.색상) · ref_key1=색상명
    오렌지 / 핑크 / 핫핑크 / 민트그린 / 블루 / 바이올렛 / 블랙 / 화이트
[가격] 색상 무관 고정가 1000원(L1 전 색상 동일가) → t_prc_component_prices 단일행
```

**L1 선적재 BLOCKED 점검:**
- option_groups/items 테이블 **실재**(ddl 불요). 색상명은 polymorphic ref_key1 문자열로 저장 → 차원행 선적재 불요.
- **BLOCKED 아님** — 단 Q-PA-B(색상=옵션 vs 별SKU vs 자재유지) 모델결정 + 오염 자재행 논리삭제가 선행. 라이브 색상=옵션 0행이라 신규 INSERT.
- **2차 오염 주의:** 색상을 옵션으로 옮기되 묶음/용량은 자재명에서 분리(bundle/siz) — 옵션 ref_key1에 "오렌지 (3개1팩)" 통째로 넣으면 묶음수가 옵션에 또 오염. ref_key1="오렌지"만.

---

## 3. 봉투/케이스 세트 — sets + 사이즈매칭 constraint (Q-ID-A 귀속·디지털인쇄 인계)

**문제:** 배경지(043/044)는 "배경지 카드 + **사이즈 맞춘** 봉투/케이스" 세트(site goods_view_102). 봉투 부자재(PRD_000001/002/009)·봉투 template(TMPL-000004~006/009)은 **이미 라이브 실재**. 배경지가 참조 안 하는 것이 결함.

**설계(배경지OPP 043 기준):**

```
[sets] t_prd_product_sets: prd_cd=배경지043 · sub_prd_cd=봉투상품(PRD_000001/002/009) · sub_prd_qty=1
       (봉투=독립상품 PRD_TYPE.03 → sub_prd_cd 참조가 addon tmpl_cd보다 정체 부합)
[constraint] CON-043-SIZEMATCH
  rule_typ_cd=캐스케이드(배경지 사이즈 → 봉투 사이즈)
  logic(JSONLogic): {"==":[{"var":"siz_cd"},{"var":"env.match_siz"}]}
  err_msg: "선택한 배경지 사이즈에 맞는 봉투만 선택 가능합니다"
```

**L1 선적재 의존성(BLOCKED 점검):**
- 봉투 상품 PRD_000001/002/009 **실재**(sets sub_prd_cd 재사용 가능). sets 테이블 28행 정상 작동.
- 봉투 template은 **110x160 등 일부 사이즈만** 라이브 적재 — 배경지 6사이즈 전부 매칭 봉투 template은 **미적재 가능성** → 사이즈매칭 constraint의 봉투 측 사이즈 풀 확인 필요.
- **결론:** sets 연결(봉투=상품 참조)은 **BLOCKED 아님**(봉투 상품 실재). 사이즈매칭 constraint는 봉투 사이즈 풀 보강 후. Q-ID-A 모델(sets vs addon) 컨펌 후 적재.

---

## 4. 우드 길이 variant — option_group(택1) 또는 siz (Q-PA-G 귀속)

**문제:** 우드봉(270/360/480mm)·우드행거(230/320/440mm)+면끈 → 라이브 siz·material·option 전부 0(미분해). 길이를 size로 볼지 옵션으로 볼지 미결.

**설계(우드행거 014 기준):**

```
(a) 옵션 모델:
[option_group] OG-014-LENGTH (길이) sel_typ_cd=택1 mand_yn=Y
  [option_items] ref_dim_cd=사이즈 또는 OPT_REF_DIM.길이 · ref_key1=230mm/320mm/440mm
[가격] 길이별 고정가(16000/18000/20000원) → 옵션 선택가 또는 component_prices
(b) siz 모델:
[siz] t_prd_product_sizes: 230x?/320x?/440x?(치수형 siz) · 가격=siz별 격자
```

**적재처 결정(Q-PA-G):**
- 길이가 "같은 상품의 규격 선택"이면 siz(치수형) 권장 — 가격이 길이별로 다름(16000/18000/20000)이라 siz 격자가 자연스러움.
- 단 우드거치대(012)는 길이 1종(120mm)+홈 가공 → 본체가공 분기(domain-research PA-4·캘린더 CL-2)와 일괄 결정.
- **L1 선적재 BLOCKED 아님:** siz/option 테이블 실재. 적재처(siz vs option) 결정 대기.

---

## 5. 카드봉투 색상·이중등록 일원화 (Q-PA-D 귀속)

**문제:** 카드봉투 004(기성·색상 siz_nm 합성 "화이트165x115/블랙165x115") vs 281 카드봉투(화이트)·282 카드봉투(블랙)(추가 PRD_TYPE.05·별 PRD·template base). **색상 처리가 한 상품에서 둘로 갈림**.

**설계:**
- **이중등록 자체는 의도**(09_delete_dup 삭제 제외 입증·OTC 권위) — 281/282/283은 추가상품 SKU로 유지(CORRECT).
- 단 004(기성)의 색상을 siz_nm 합성에서 **option_group(색상 택1)로 일원화** 권장 — 281/282(별 SKU)와 역할 분리: 004=독립판매(옵션으로 색상)·281/282=배경지 addon용 색상별 template base.
- Q-PA-D 컨펌 후.

---

## 6. CPQ 적재 준비 상태 요약

| CPQ 항목 | 기초데이터 선적재 | CPQ 적재 가능? | BLOCKER |
|----------|-------------------|:--:|---------|
| 색상 옵션(볼체인/와이어링/행택끈/리필잉크) | 자재 오염 21행(정리 대상) | 부분 | 모델결정(Q-PA-B) + 오염 자재 논리삭제 선행 |
| 봉투 세트(배경지043/044) | 봉투 상품 실재·template 일부 | 부분 | 모델결정(Q-ID-A) + 봉투 사이즈 풀 보강 |
| 우드 길이(우드봉/행거) | siz·option 0 | 부분 | 적재처 결정(Q-PA-G·siz vs option) |
| 카드봉투 색상 일원화 | 004 siz 합성·281/282 별 PRD | 부분 | 일원화 결정(Q-PA-D) |
| 묶음수(볼체인/천정고리/행택끈) | bundle 일부만 | ✅(기초데이터) | 단위 통일(Q-PA-E) — CPQ 아님 |

> **종착(비파괴):** 본 산출은 CPQ **설계까지**. option_groups/items/sets/constraints 실 적재는 ① 기초데이터(오염 자재 정리·봉투 사이즈 풀) 선행 ② Q-PA-B/D/G·Q-ID-A 컨펌 후 인간 승인. L1 선적재 BLOCKED는 없음(전 테이블 실재) — 전부 "모델결정 대기"가 BLOCKER. 색상 옵션 이전 시 묶음/용량 2차 오염 주의(ref_key1=색상명만).
