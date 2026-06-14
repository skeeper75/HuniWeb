# 캘린더 — CPQ 옵션/템플릿/제약 반영 설계 (cpq-plan)

> **작성** 2026-06-14 · round-13. 사용자 기준 5번 = "기초데이터(size/자재/공정/도수/판형/장수)만이 아니라 option/template/constraint까지 묶어 설계".
> **라이브 CPQ 스키마(2026-06-14 실측):** `t_prd_product_option_groups`(opt_grp_cd·sel_typ_cd·min/max_sel_cnt·mand_yn) → `t_prd_product_option_items`(opt_cd·ref_dim_cd polymorphic·ref_key1/2·qty) → `t_prd_product_constraints`(rule_typ_cd·logic JSONLogic·err_msg).
> **[HARD] 설계까지** — 실제 CPQ 적재는 인간 승인. 차원행 미적재면 "L1 선적재 BLOCKED" 정직 표기.
> **polymorphic ref_dim_cd(OPT_REF_DIM 7종):** 사이즈·판형·자재·공정·묶음수·도수·셋트.
> **캘린더 특수성:** 장수=고객선택+가격공식(Q12)·캘린더가공=택일그룹(excl_grp_cd 삭제됨→SEL_TYPE.01 흡수)·삼각대색/링칼라=공정 param·봉투=사이즈매칭 template.

---

## 1. 캘린더 CPQ 귀속 대상 (정체 기반)

| 속성 | 어느 상품 | 기초데이터 적재? | CPQ 레이어 |
|------|-----------|------------------|------------|
| 장수(낱장 매수) | 캘린더 5종 | 미적재(page_rules 0·option 0) | **option_group(택1·장수) + option_items + 가격공식 바인딩** |
| 캘린더가공 택일 | 캘린더 5종 | 공정만 따로(option_groups 0·택일 묶음 없음) | **option_group(택1·SEL_TYPE.01) + 가공별 추가가격(C20)** |
| 삼각대 색 | 탁상(108)·미니(109) | 자재 오적재(MAT_000252/254) | **option_items(공정 param)** — 삼각대 거치 공정 mint 후 |
| 링칼라 | 벽걸이(111)·와이드(112) | 자재 오적재(MAT_000253)·트윈링 공정 실재 | **option_items(공정 param)** — ★고리형트윈링제본 선택시만(constraint) |
| 봉투 세트(사이즈매칭) | 엽서(110)·디자인 | addon 0·봉투 template 0 | **template + constraint(사이즈매칭)** |
| 우드거치대 | 엽서(110)·디자인 | 미적재(자재 마스터 실재) | (자재 — CPQ 불요·기초데이터 연결) |
| 단면/양면 도수 | 캘린더 5종 | print_options 적재됨 | (적재 완료 — CPQ 불요) |

---

## 2. 장수(낱장 매수) — option_group(택1) + 가격공식 바인딩 (Q12·CL-D)

**문제:** 장수는 캘린더 고유 옵션축이다(Q12: 고객 선택 + 가격 계산공식). page_rule(책자 내지)도 bundle(떡제본 권)도 아니다. 라이브 page_rules 0·option_groups 0·prices 0 = 완전 미적재.

**설계(탁상 108 기준, L1 장수=4(8P)/8(16P)/12(24P)/16(32P)):**

```
[option_group] OG-108-PAGES (장수)
  sel_typ_cd=택1(SEL_TYPE.01) · mand_yn=Y · min=1 max=1
  [option_items]
    item1: 4장(8P)    (ref_key1=장수 4 / P수 8)
    item2: 8장(16P)
    item3: 12장(24P)
    item4: 16장(32P)
[가격] 장수별 가격 = 캘린더 가격공식(수량×장수 계수)
  → round-2 디지털 가격엔진과 합산 방식 컨펌(CL-D)
```

**L1 선적재 의존성(BLOCKED 점검):**
- CPQ option 로더가 load_master에 **부재**(RELATIONS L469-481에 option_groups/items 로더 없음·loadlogic F-4) → CPQ option 적재 경로 자체가 없음. **L1 선적재 BLOCKED**(round-6 L2 적재 경로 필요).
- 가격공식 바인딩(장수별 가격)은 round-2/16 가격 트랙. 캘린더는 공식엔진(디자인캘린더는 고정가 §C-DC) — 합산 방식 컨펌.

> **결론:** 장수 CPQ는 ① round-6 CPQ option 적재 경로 ② 가격공식 합산 방식(CL-D) 컨펌이 선행. **page_rule에 넣지 말 것**(schema-intent OM·Q12).

---

## 3. 캘린더가공 택일그룹 + 삼각대색/링칼라 공정 param (CL-A/CL-B/CL-D)

**문제:** 캘린더가공(C19)은 6멤버(가공없음/우드거치대/1구타공+끈/2구타공+끈/고리형트윈링제본/제본없음) 중 하나 택일. 라이브는 공정행만 따로 떠 있고(트윈링021·타공079 등) **택일 묶음(option_group) 0**. excl_groups 테이블은 Phase11에 삭제 → option_groups 흡수가 정답.

**설계(벽걸이 111 기준):**

```
[option_group] OG-111-FINISH (캘린더가공)
  sel_typ_cd=택1(SEL_TYPE.01) · mand_yn=Y
  [option_items] ref_dim_cd=공정
    가공없음(재단만)        (추가가격 0)
    2구타공+끈              (ref_key1=PROC_000079 / 추가가격 1000~1500·C20)
    고리형트윈링제본         (ref_key1=PROC_000021 / 추가가격 2000)
       └ [하위 param] 링칼라=블랙   ← 트윈링 선택시만(constraint 캐스케이드)

[constraint] CON-111-RINGCOLOR
  rule_typ_cd=캐스케이드(가공→링칼라)
  logic(JSONLogic): {"if":[{"==":[{"var":"finish"},"트윈링제본"]}, {"show":"링칼라"}, {"hide":"링칼라"}]}
  err_msg: "트윈링제본 선택 시에만 링 색상을 고를 수 있습니다"
```

**삼각대색(탁상/미니):**
```
[기초데이터] (ddl-proposer) 삼각대 거치 공정 mint → product_processes 연결(apply.sql 주석블록)
[option_group] OG-108-STAND (삼각대색)
  sel_typ_cd=택1 · ref_dim_cd=공정(삼각대 거치)
  [option_items] 삼각대(그레이) / 삼각대(블랙)   ← 현 자재 MAT_000252/254를 param으로 이전
```

**적재처 결정(CL-A/CL-B):**
- 삼각대 거치 공정 마스터 **부재(0행 실측)** → mint 선행(ddl-proposer·CL-A). 마스터 부재 입증: 트윈링021·타공079·수축포장075/076·하드커버트윈링024는 존재, "삼각대거치/거치/받침"은 0행.
- 링칼라=트윈링제본(PROC_000021) 실재 공정의 param → mint 불요·param 적재처(option_items ref_key 또는 ref_param_json) 결정.
- **자재 오적재 정리:** MAT_000252/254(삼각대)·MAT_000253(링) 자재 연결행은 공정/param 이전 후 del_yn='Y' 논리삭제(apply.sql 주석블록). 탁상/미니 링(MAT_000253)은 트윈링 아닌데 붙은 잉여(C-03)라 무조건 논리삭제 후보.

> **L1 선적재:** 택일그룹·링칼라=공정 param은 PROC_000021/079 실재로 부분 가능. 삼각대색은 공정 mint 후. 가공별 추가가격(C20)은 옵션 가격(round-6 L2).

---

## 4. 봉투 세트(사이즈매칭) — template + constraint (C-08)

**문제:** 엽서·디자인 캘린더 추가상품=캘린더봉투(★사이즈선택). 봉투는 캘린더 사이즈에 맞춰 골라야 함(사이즈매칭). 단순 addon으론 "어느 봉투가 어느 사이즈에 매칭"을 표현 못 함 → constraint 필요.

**설계(엽서 110 기준):**

```
[option_group] OG-110-ENV (봉투선택)
  sel_typ_cd=택1 · mand_yn=N
  [option_items] ref_dim_cd=셋트(또는 template 참조)
    봉투(캘린더 사이즈별 매칭 SKU)

[constraint] CON-110-SIZEMATCH
  rule_typ_cd=캐스케이드(사이즈→봉투)
  logic(JSONLogic): {"==":[{"var":"siz_cd"},{"var":"env.match_siz"}]}
  err_msg: "선택한 캘린더 사이즈에 맞는 봉투만 선택 가능합니다"
```

**L1 선적재 의존성(BLOCKED 점검):**
- 캘린더봉투 SKU=PRD_000005(기성상품) **실재**. 단 **PRD_000005 기준 봉투 template 0건**(라이브 templates 9행은 다른 봉투 SKU) → **L1 선적재 BLOCKED**(사이즈별 봉투 template 신설 선행·데이터, ddl 아님).
- addons 컬럼=`tmpl_cd`(Phase7 전환) — load_master는 `addon_prd_cd` INSERT라 현 스키마와 drift(F-3). 봉투 template 선적재 후 product_addons(prd_cd·tmpl_cd) 연결.

> **결론:** 봉투 세트 CPQ는 사이즈별 봉투 template 선적재가 선행. 현재 미충족 → 봉투 template 선적재 + 사이즈매칭 constraint 후 CPQ 적재 가능.

---

## 5. CPQ 적재 준비 상태 요약

| CPQ 항목 | 기초데이터 선적재 | CPQ 적재 가능? | BLOCKER |
|----------|-------------------|:--:|---------|
| 캘린더가공 택일그룹 | 트윈링021·타공079 실재 | 부분 | option 로더 부재(round-6)·가공 추가가격 |
| 링칼라 공정 param | 트윈링021 실재 | 부분 | param 적재처 결정 + 자재행 논리삭제 |
| 삼각대색 공정 param | **삼각대 거치 공정 0** | **BLOCKED** | 삼각대 거치 공정 mint 선행(CL-A) |
| 장수 옵션 | option 0·page_rules 0 | **BLOCKED** | CPQ option 적재 경로(round-6) + 가격공식 합산(CL-D) |
| 봉투 세트(엽서/디자인) | 봉투 template 0(PRD_000005 기준) | **BLOCKED** | 사이즈별 봉투 template 선적재 |
| 우드거치대 | 자재 마스터 실재(MAT_000223/034) | (자재·CPQ 불요) | 권위 MAT 선택(C-12류) |

> **종착(비파괴):** 본 산출은 CPQ **설계까지**. option_groups/items/constraints 실 적재는 ① 기초데이터(삼각대 거치 공정·봉투 template) 선적재 ② CL-A/CL-D 컨펌 ③ round-6 CPQ option 적재 경로 후 인간 승인. L1 선적재 BLOCKED 3건(삼각대색·장수·봉투 template) 정직 표기.
