# 디지털인쇄 — CPQ 옵션/템플릿/제약 반영 설계 (cpq-plan)

> **작성** 2026-06-14 · round-13. 사용자 기준 5번 = "기초데이터(size/자재/공정/도수/판형/묶음수)만이 아니라 option/template/constraint까지 묶어 설계".
> **라이브 CPQ 스키마(2026-06-14 실측):** `t_prd_product_option_groups`(opt_grp_cd·sel_typ_cd·min/max_sel_cnt·mand_yn) → `t_prd_product_option_items`(opt_cd·ref_dim_cd polymorphic·ref_key1/2·qty) → `t_prd_product_constraints`(rule_typ_cd·logic JSONLogic·err_msg).
> **[HARD] 설계까지** — 실제 CPQ 적재는 인간 승인. 차원행 미적재면 "L1 선적재 BLOCKED" 정직 표기.
> **polymorphic ref_dim_cd(OPT_REF_DIM 7종):** 사이즈·판형·자재·공정·묶음수·도수·셋트.

---

## 1. 디지털인쇄 CPQ 귀속 대상 (정체 기반)

| 속성 | 어느 상품 | 기초데이터 적재? | CPQ 레이어 |
|------|-----------|------------------|------------|
| 봉투/케이스 세트 | 배경지OPP(043)·케이스(044)·헤더택(045) | 미적재(addon=0·sets=0) | **template + constraint(사이즈매칭)** |
| 형상 커팅 | 배경지OPP(043)·라벨택(046) | 공정 0행(완칼 미연결) | **option_group(택1) + option_items(형상)** |
| 접지 형태 | 케이스(044) | 공정 0행 | option_group(택1) |
| 박색 8종 | 박 쓰는 8상품(027/031/042 등) | 자식 8종 연결·부모 박 없음 | **option_group(택1·박색 풀) — 이미 자식행 존재** |
| 단면/양면 도수 | 전 디지털 상품 | print_options 2행 적재됨 | (적재 완료 — CPQ 불요) |

---

## 2. 봉투/케이스 세트 — template + 사이즈매칭 constraint (Q-ID-A 귀속)

**문제:** 배경지는 "배경지 카드 + **사이즈 맞춘** 봉투" 세트(260610 L1: 76x100→봉투 76x100, 86x120→봉투 86x120 …). 단순 addon/sets로는 "어느 봉투가 어느 사이즈에 매칭되는지"를 표현 못 함 → constraint 필요.

**설계(배경지OPP 043 기준, 6사이즈):**

```
[option_group] OG-043-ENV (봉투선택)
  sel_typ_cd=택1 · mand_yn=Y · min=1 max=1
  [option_items] ref_dim_cd=셋트(또는 template 참조)
    item1: 봉투 76x100   (ref_key1=배경지 siz_cd 76x100)
    item2: 봉투 76x120
    ... 6종

[constraint] CON-043-SIZEMATCH
  rule_typ_cd=캐스케이드(사이즈→봉투)
  logic(JSONLogic): {"==":[{"var":"siz_cd"},{"var":"env.match_siz"}]}
  err_msg: "선택한 배경지 사이즈에 맞는 봉투만 선택 가능합니다"
```

**L1 선적재 의존성(BLOCKED 점검):**
- 봉투 SKU별 template: TMPL-000005(OPP접착)·TMPL-000006(OPP비접착) **실재**. 단 라이브 봉투 template은 **110x160 1종씩만** — 260610 L1의 6사이즈 매칭 봉투(80x120·90x120·100x100·70x200·110x160 등)는 **template 미적재** → **L1 선적재 BLOCKED**(사이즈별 봉투 template 신설 필요·데이터, ddl 아님).
- 케이스(044): PP투명케이스 template **0건**(검색 부재) → **L1 선적재 BLOCKED**(케이스 상품/template 신설 선행).

> **결론:** 봉투 세트 CPQ는 사이즈별 봉투 template 선적재가 선행 조건. 현재 미충족 → Q-ID-A 모델 결정 + 봉투 template 선적재 후 CPQ 적재 가능.

---

## 3. 형상 커팅 — option_group(택1) + option_items (Q-DP-D 귀속)

**문제:** 배경지OPP 커팅 형상 ~13종(기본형/타공형/핀고정형/북마크/스마트톡형/카드고정형/키링형/폰스트랩형 등)·라벨택 형상 8종(사각/라운딩/삼각/팔각/원형/사각리본/삼각리본/리본). 이 형상 세부값을 담을 `prcs_dtl_opt` 류 테이블이 **라이브 부재(0건)** → 공정 마스터(완칼 PROC_000053)만으로는 모양 구분 불가.

**설계(라벨택 046 기준):**

```
[기초데이터] t_prd_product_processes: (PRD_000046, PROC_000053 완칼) 연결  ← apply.sql 컨펌블록
[option_group] OG-046-SHAPE (커팅모양)
  sel_typ_cd=택1 · mand_yn=Y
  [option_items] ref_dim_cd=공정(PROC_000053 완칼) · ref_key1=형상값
    사각 / 라운딩 / 삼각 / 팔각 / 원형 / 사각리본 / 삼각리본 / 리본
```

**적재처 결정(Q-DP-D):**
- (a) **CPQ option_items의 ref_key1에 형상명 문자열**로 저장(권장 — 신규 테이블 0, polymorphic 활용).
- (b) `prcs_dtl_opt` 신규 테이블(ddl) — 공정 세부옵션 정식 모델.
- 도무송 형상=size 칼틀 1:1 메모리 권위와 충돌 주의: 라벨택 형상은 "같은 사이즈에 모양만 다름"이라 size 아닌 **공정 옵션**이 맞음(축③ 완칼 + 형상 param).

> **L1 선적재 BLOCKED 아님:** 완칼 PROC_000053 마스터 실재 → 공정 연결은 즉시 가능(apply.sql 컨펌블록). 형상 param만 적재처 결정 대기.

---

## 4. 박색 8종 — option_group(택1, 박색 풀) (Q-DP-C 귀속)

**문제:** 박 쓰는 8상품(027/029/031/034/037/042/069/070) 전부 박색 자식 8종(홀로그램~트윙클)을 **개별 공정 행**으로 연결, 부모 박(PROC_000033) 미연결. 라이브 전역 일관 패턴.

**설계(2안 — 컨펌):**
- **(a) 박색=CPQ 선택옵션:** 박색 8종을 option_group(택1)으로 묶고, 박 본체는 option_group의 존재 자체로 표현. 현재 자식 8행이 이미 적재돼 있으므로 option_items가 그 8행을 ref_dim_cd=공정으로 참조. **부모 박 미연결이 정합** — 이 경우 W-06은 결함 아님.
- **(b) 박 본체 공정 명시:** 부모 PROC_000033을 product_processes에 추가(8상품 일괄·apply.sql 컨펌블록) + 박색은 option.

```
[option_group] OG-042-BAKCOLOR (박색)
  sel_typ_cd=택1 · mand_yn=N (박 선택 시)
  [option_items] ref_dim_cd=공정
    홀로그램(037)/금유광(038)/은유광(039)/먹유광(040)/동박(041)/적박(042)/청박(043)/트윙클(044)
```

> **권장:** (a) — 박색 8종이 이미 자식 공정행으로 존재하므로 option_items로 묶으면 부모 박 추가 없이 CPQ 완결. 단 "박 공정 있음" 조회 시 부모 없으면 안 잡히는 문제 → 운영 관점에서 (b) 보강 가능. **인간 컨펌(Q-DP-C).**

---

## 5. CPQ 적재 준비 상태 요약

| CPQ 항목 | 기초데이터 선적재 | CPQ 적재 가능? | BLOCKER |
|----------|-------------------|:--:|---------|
| 형상 커팅(라벨택/배경지) | 완칼 PROC_000053 실재 | 부분 | 형상 param 적재처 결정(Q-DP-D) |
| 접지 형태(케이스) | 접지 PROC_000056 실재 | 부분 | 공정 연결 후 |
| 박색 8종 | 자식 8행 이미 적재 | ✅ 가능 | 모델 결정(Q-DP-C) |
| 봉투 세트(배경지OPP) | 봉투 template 일부만 | **BLOCKED** | 사이즈별 봉투 template 선적재 |
| 케이스 세트(044) | PP케이스 template 0건 | **BLOCKED** | 케이스 상품/template 신설 |

> **종착(비파괴):** 본 산출은 CPQ **설계까지**. option_groups/items/constraints 실 적재는 ① 기초데이터(공정·봉투 template) 선적재 ② Q-ID-A/Q-DP-C/Q-DP-D 컨펌 후 인간 승인. L1 선적재 BLOCKED 2건(봉투 사이즈매칭 template·PP케이스) 정직 표기.
