# 디자인캘린더 — CPQ 옵션/템플릿/제약 반영 설계 (cpq-plan)

> **작성** 2026-06-14 · round-13. 사용자 기준 5번 = "기초데이터(size/자재/공정/도수/판형/묶음수)만이 아니라 option/template/constraint까지 묶어 설계".
> **라이브 CPQ 스키마(2026-06-14 실측):** `t_prd_product_option_groups`(opt_grp_cd·sel_typ_cd·min/max_sel_cnt·mand_yn·use_yn·del_yn·note) → `t_prd_product_option_items`(opt_cd·ref_dim_cd polymorphic·ref_key1/2·qty) → `t_prd_products.constraint_json`(JSONLogic).
> **[HARD] 설계까지** — 실제 CPQ 적재는 인간 승인. 차원행 미적재면 "L1 선적재 BLOCKED" 정직 표기.
> **polymorphic ref_dim_cd(OPT_REF_DIM 7종):** 사이즈·판형·자재·공정·묶음수·도수·셋트.

---

## 1. 디자인캘린더 CPQ 귀속 대상 (정체 기반)

| 속성 | 어느 상품 | 기초데이터 적재? | CPQ 레이어 |
|------|-----------|------------------|------------|
| 페이지/장수 | 전 5상품 | option 0행 | **option_group(택1·페이지 고정)** + 가격 기여 |
| 캘린더가공 택1 | 전 5상품 | processes 일부·option_groups 0 | **option_group(택1·SEL_TYPE.01) — 삼각대/타공/트윈링/우드/없음** |
| 삼각대컬러 | 탁상(108)·미니(109) | 자재로 오적재(MAT_000252/254) | **공정 param**(삼각대거치 신규 공정의 색) |
| 링칼라 | 벽걸이(111)·와이드(112) | 자재로 오적재(MAT_000253) | **공정 param**(트윈링제본 PROC_000021의 색) + constraint(트윈링 선택시만) |
| 우드거치대 | 엽서(110) | 미적재(MAT_000034 재사용) | **추가상품(자재 단일귀속·Q13)** |
| 캘린더봉투 | 탁상(108)·디자인 surface | addons 0·template 0 | **template + constraint(★사이즈선택)** |
| 단/양면 도수 | 전 5상품 | print_options 적재됨 | (적재 완료 — CPQ 불요) |

---

## 2. 페이지/고정가 — option_group(택1) + 고정가 그릇 미결 (Q-DC-A 귀속)

**문제:** 디자인캘린더는 사이즈·페이지가 **고정**(디자인 확정)이고 가격도 **고정가**(4000~24000). 엑셀:

| 상품 | 페이지 | 가격(고정) |
|------|--------|-----------|
| 탁상형(220x145) | 30P | 10400 |
| 탁상형(130x220) | 30P | 9700 |
| 미니탁상형 | 26P | 6500 |
| 엽서 | 12P | 4000 |
| 벽걸이 | 13P | 9900 |
| 와이드벽걸이 | 13P | 24000 |

**그릇 미스매치(★Q-DC-A):** 라이브 `t_prd_product_prices` PK=`(prd_cd, apply_ymd)`·`unit_price` 단일 → **한 상품에 사이즈/페이지별 여러 고정가를 담을 칸이 없음**(탁상형이 220x145=10400, 130x220=9700 두 가격인데 prd_cd 같음).

**3안(컨펌):**
- (a) **가격 차원 그릇 확장(ddl):** `t_prd_product_prices`에 siz_cd 차원 추가 → 사이즈별 고정가.
- (b) **대표 단일가:** 상품당 1가만(탁상=10400) — 정보 손실(130x220 누락).
- (c) **가격엔진 component_prices:** 고정가를 comp_prices의 siz 차원으로 분해(round-2 가격 트랙).

> **L1 선적재 BLOCKED:** 사이즈/페이지별 다가는 현 단일가 그릇으로 표현 불가 → Q-DC-A 모델 결정 선행. 대표 단일가(b)만 즉시 가능하나 정보 손실이라 보류.

---

## 3. 캘린더가공 택1 + 공정 param (Q-DC-B/C 귀속)

**문제:** 캘린더가공=택1(삼각대/타공/트윈링/우드/없음). 라이브 option_groups 0행. 가공 선택에 따라 공정·param이 캐스케이드:

**설계(전 5상품 공통 그룹):**
```
[option_group] OG-CAL-FINISH (캘린더가공)
  sel_typ_cd=SEL_TYPE.01(택1) · mand_yn=Y · min=1 max=1
  [option_items] ref_dim_cd=공정
    삼각대거치(신규 PROC·D-05) / 타공(PROC_000079) / 트윈링제본(PROC_000021) / 우드거치(자재 MAT_000034) / 가공없음

[option_group] OG-CAL-TRICOLOR (삼각대컬러) — 삼각대 선택시만
  ref_key1=그레이/블랙   [constraint] 삼각대거치 선택시 노출
[option_group] OG-CAL-RINGCOLOR (링칼라) — 트윈링 선택시만
  ref_key1=블랙          [constraint_json] 트윈링제본 선택시만(엑셀 ★고리형트윈링제본선택시만)
```

**적재처 결정:**
- 삼각대거치 공정 마스터 **부재(0건)** → mint 선행(D-05·Q-DC-B). 그 전엔 option_items의 공정 참조 BLOCKED.
- 삼각대컬러/링칼라 param = option_items ref_key1(문자열) 또는 `prcs_dtl_opt`(라이브 부재) → option_items 경유 권장(신규 테이블 0).
- 조건부(트윈링시만 링칼라) = `t_prd_products.constraint_json` JSONLogic(평면화 금지).

> **L1 선적재 BLOCKED 1건:** 삼각대거치 공정 마스터 부재(타공·트윈링은 실재). 삼각대거치 mint 후 OG-CAL-FINISH 완결 가능.

---

## 4. 우드거치대·봉투 추가상품 (D-04·Q-DC-A)

- **우드거치대(엽서 110):** Q13=자재 단일귀속. MAT_000034 재사용 → `t_prd_product_materials` 부속 슬롯(D-04). CPQ 옵션 아닌 자재(추가상품 표면표기는 자재 선택 가리킴).
- **캘린더봉투:** PRD_000005(기성상품) 실재·★사이즈선택. 단 **봉투 template은 PRD_000005 base 0건**(라이브 template은 PRD_000001/002/281/282/283만) → **L1 선적재 BLOCKED**(캘린더봉투 사이즈별 template 신설 선행). addon=template 참조 모델(F-3 drift: load_master addon_prd_cd vs 현 tmpl_cd).

```
[template] 캘린더봉투(base_prd=PRD_000005) × 사이즈별  ← 미적재(BLOCKED)
[option_group/constraint] ★사이즈선택: 배경 사이즈 → 매칭 봉투만
  logic(JSONLogic): {"==":[{"var":"siz_cd"},{"var":"env.match_siz"}]}
```

---

## 5. CPQ 적재 준비 상태 요약

| CPQ 항목 | 기초데이터 선적재 | CPQ 적재 가능? | BLOCKER |
|----------|-------------------|:--:|---------|
| 페이지/고정가 | print_options 적재·가격 0 | **BLOCKED** | 사이즈/페이지별 다가 그릇(Q-DC-A) |
| 캘린더가공 택1 | 타공·트윈링 실재·삼각대거치 부재 | 부분 | 삼각대거치 공정 mint(Q-DC-B) |
| 삼각대컬러/링칼라 param | (param 적재처 부재) | 부분 | option_items ref_key1 경유 결정 |
| 우드거치대(엽서) | MAT_000034 실재 | ✅ 가능 | (자재 연결만·Q13) |
| 캘린더봉투 | template 0건(PRD_000005 base) | **BLOCKED** | 사이즈별 봉투 template 선적재 |

> **종착(비파괴):** 본 산출은 CPQ **설계까지**. option_groups/items/constraints 실 적재는 ① 기초데이터(삼각대거치 공정·봉투 template·고정가 그릇) 선적재 ② Q-DC-A/B/C/D 컨펌 후 인간 승인. L1 선적재 BLOCKED 3건(다가 그릇·삼각대거치 공정·봉투 template) 정직 표기.
