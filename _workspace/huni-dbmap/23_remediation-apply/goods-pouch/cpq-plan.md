# 굿즈파우치 — CPQ 옵션/템플릿/제약 반영 설계 (cpq-plan)

> **작성** 2026-06-14 · round-13. 사용자 기준 5 = "기초데이터만이 아니라 option/template/constraint까지 묶어 설계". **이 시트의 핵심 = size→option 재분류**(round-10 448셀·OM-2).
> **라이브 CPQ 스키마(2026-06-14 실측·information_schema):**
> - `t_prd_product_option_groups`(prd_cd·opt_grp_cd·opt_grp_nm·**sel_typ_cd**·min/max_sel_cnt·mand_yn·use_yn·usr_def_nm)
> - `t_prd_product_option_items`(prd_cd·opt_cd·item_seq·**ref_dim_cd** polymorphic·**ref_key1/2**·qty·use_yn)
> - `t_prd_product_constraints`(prd_cd·rule_cd·rule_nm·**rule_typ_cd**·**logic** JSONLogic·err_msg·use_yn)
> - `t_prd_product_sizes`(prd_cd·siz_cd·dflt_yn·disp_seq·**del_yn**·del_dt) — use_yn 부재·**del_yn 존재**(논리삭제 가능).
> **[HARD] 설계까지** — 실제 CPQ 적재는 인간 승인. 차원행 미적재면 "L1 선적재 BLOCKED" 정직 표기.
> **polymorphic ref_dim_cd(OPT_REF_DIM 7종):** 사이즈·판형·자재·공정·묶음수·도수·셋트.

---

## 0. 굿즈파우치 CPQ의 중심 문제 = size→option 재분류 (★)

round-10 변경추적이 굿즈파우치 `사이즈(필수)` 448셀(224쌍·58상품)을 `상품(옵션)`으로 재분류했다. 이는 **"고정 사이즈" → "고객이 고르는 옵션"이라는 판매모델 전환**이다(OM-2). 그러나 라이브엔 **여전히 옛 방식대로 `t_prd_product_sizes`에 size로 적재**돼 있다.

**라이브 실측(2026-06-14):**
- 클립보드(PRD_000215): `SIZ_000413 A5용(164x230mm)`·`SIZ_000415 A4용(230x330mm)` = size행 2건.
- 레더라벨제작(PRD_000280): `SIZ_000492 레더15x30`·`SIZ_000494 레더20x40`·`SIZ_000496 레더30x50` = size행 3건.
- 굿즈 option_groups = **0행**(전역 7행은 엽서·현수막, 굿즈 무관).
- **이 size행들에 물린 가격(`t_prc_component_prices.siz_cd`) = 0건** (재현: `SELECT count(*) FROM t_prc_component_prices WHERE siz_cd IN ('SIZ_000492',...)` → 0). 굿즈 가격은 고정가형(`product_prices`)이며 전역 0(미적재).

> **함의:** size→option은 **데이터모델 의도 전환**이라 자동 적용 불가(BATCH-6·intent-map 의존). 단 **가격 직접 물림이 0건**이라는 실측은 "size행 논리삭제 시 즉시 파손되는 가격사슬은 현재 없음"을 의미 → 양면 결정의 핵심 근거(§2-C).

---

## 1. 굿즈파우치 CPQ 귀속 대상 (정체 기반)

| 속성 | 어느 상품 | 기초데이터 현황 | CPQ 레이어 |
|------|-----------|------------------|------------|
| **옵션형 사이즈**(폰기종·M/L/XL·방향·구수·면·A5/A4·레더15x30) | size→option 58상품 | size행으로 적재(option 0) | **option_group(택1) + option_items(ref_dim_cd=사이즈)** ★ |
| 본체색 | 티셔츠·파우치 등 | 재질행에 합성(색×규격 폭증) | **option_group(택1·색) — 재질행 합성 유지·색만 option** |
| 색×규격 복합("블랙 XL") | 티셔츠 등 | 8행 직교 폭증 | **2축 분리**: 재질(색)×option(규격) |
| 가공(라벨/에폭시/맥세이프) | 말랑·폰케이스·패브릭 | 공정 0~6행 | option_group(택1) + process 연결 |
| 추가상품(볼체인/리필잉크) | 키링·만년스탬프 | addon 0행 | addon + template (대상 PRD 실재) |
| 치수형 사이즈(22행) | 거울 S/M/L 등 | size 정상 | (size 유지 — CPQ 불요) |

---

## 2. ★ size→option 재분류 설계 (W-G04·Q-GP-1·BATCH-6 귀속)

### 2-A. CPQ 옵션 설계 (레더라벨제작 PRD_000280 기준)

```
[option_group] OG-280-SIZE (사이즈선택)
  opt_grp_nm="사이즈" · sel_typ_cd=택1 · mand_yn=Y · min_sel_cnt=1 · max_sel_cnt=1
  [option_items] ref_dim_cd=사이즈(OPT_REF_DIM 사이즈)
    item1: ref_key1=SIZ_000492 (레더15x30)
    item2: ref_key1=SIZ_000494 (레더20x40)
    item3: ref_key1=SIZ_000496 (레더30x50)
```

> **핵심 설계 결정:** option_items의 `ref_key1`이 **기존 siz_cd를 그대로 참조**(polymorphic ref_dim_cd=사이즈). 즉 **size행을 삭제하지 않고도** 옵션으로 노출 가능 — size행은 "치수 정의 마스터"로 남고, option_items가 그것을 "고객 선택지"로 참조. 이것이 OM-2 size→option의 비파괴 구현 경로.

**클립보드(PRD_000215) 동형:** OG-215-SIZE → item1=SIZ_000413(A5)·item2=SIZ_000415(A4).

### 2-B. 폰기종 등 — 차원행 선적재 BLOCKED 점검

| 옵션 유형 | siz_cd 실재? | option_items 적재 가능? |
|----------|:--:|:--:|
| 레더라벨 15x30/20x40/30x50 | ✅ SIZ_000492/494/496 실재 | ✅ ref_key1 참조 가능 |
| 클립보드 A5/A4 | ✅ SIZ_000413/415 실재 | ✅ 가능 |
| 폰기종(아이폰15프로맥스 등) | 🔴 siz_cd 미적재(자재행 흡수 또는 누락) | **BLOCKED** — siz_cd(또는 옵션 전용 코드) 선적재 필요 |
| 사이즈등급 M/L/XL | 🔴 재질행에 흡수(F-ID-2) | **BLOCKED** — 차원행 분리 선적재 필요 |

> **L1 선적재 BLOCKED 정직 표기:** 이미 siz_cd로 실재하는 옵션형(레더라벨·클립보드 등)은 option_items 즉시 적재 가능. 폰기종·M/L/XL은 **차원행 자체가 미적재/오적재**라 선적재 선행 필요(round-6 트랙).

### 2-C. 적재된 size행 처리 — 양면 제시 (★ 인간 결정 Q-GP-1)

| 안 | 처리 | 장점 | 단점 | 가격사슬 영향 |
|----|------|------|------|--------------|
| **(가) 유지(이중표현)** | size행 그대로 두고 option_items가 ref_key1로 참조 | 비파괴·가격사슬 0파손·OM-2 비파괴 구현 | size·option 이중 노출 가능성(UI에서 size 숨김 필요) | **0** (size행 보존) |
| **(나) 논리삭제 후 option 전환** | size행 `del_yn='Y'` + option_items 신규 | 데이터모델 깔끔(순수 option) | 가격이 siz 기반이면 파손 위험 | 현재 **0건 물림**(실측) → 위험 낮으나 향후 고정가 바인딩 시 재검토 |

> **권장(잠정):** **(가) 유지** — `t_prd_product_sizes`에 use_yn 없고 del_yn만 있어 논리삭제는 가능하나, **size행을 마스터로 두고 option_items가 참조**하는 이중표현이 OM-2를 가장 안전하게 구현(가격사슬 0파손). 단 굿즈 가격이 고정가형으로 적재될 때 "사이즈별 단가"를 size가 아닌 option_items 기준으로 물릴지 재검토 → **Q-GP-1 인간 결정**.
>
> **[HARD] 본 트랙은 size행 0건 변경** — apply.sql 즉시적용분에 size 손대지 않음. (나) 논리삭제는 CPQ option 적재 + 가격 재바인딩 검증 통과 후에만.

---

## 3. 본체색 — 재질행 합성 + 색 option_group (W-G05·Q-GP-2)

**문제:** 반팔티셔츠 = "화이트 M/L/XL/XXL·블랙 M/L/XL/XXL" 8 재질행 폭증(색2×규격4 직교).

**설계(2축 분리):**
```
[t_mat_materials] 본체색 = 재질행 합성 — 색만 2행 (화이트 원단·블랙 원단), mat_typ_cd=.05 원단
[option_group] OG-206-COLOR (본체색)  sel_typ_cd=택1 · ref_dim_cd=자재
  item: 화이트 / 블랙  (ref_key1=mat_cd, ref_key2=usage_cd 형식)
[option_group] OG-206-SIZE (사이즈등급)  sel_typ_cd=택1 · ref_dim_cd=사이즈 또는 옵션전용
  item: M / L / XL / XXL
```
> **과분할 금지(OM 핵심·huni-goods §2.1):** 색×규격 곱집합(8행)을 자재행으로 만들지 않음. 재질행=색(2), 규격=별 option_group. **경쟁사(Printful) variant=color×size도 무효조합만 rule, 곱집합 행 폭증 안 함.** 자재유형 .09 파우치→.05 원단 정정은 소재판정 컨펌(Q-GP-6) 후.

---

## 4. 가공(라벨/에폭시/맥세이프) — option_group(택1) + process (W-G08/09·Q-GP-3)

```
[기초데이터] t_prd_product_processes: 봉제(PROC_000080)·에폭시(PROC_000083)·맥세이프 연결 ← apply.sql 컨펌블록
[option_group] OG-가공  sel_typ_cd=택1 · ref_dim_cd=공정
  item: 라벨부착 / 에폭시 / 맥세이프
```
> **택일그룹 주의:** `excl_grp_cd` 컬럼이 `sql/23`에서 삭제됨 → 택일은 **option_group sel_typ_cd=택1 + constraints(JSONLogic)** 로 표현(레거시 excl_grp 아님). Q-GP-3 = 신규 택일그룹 vs 상품별 단순공정 결정.

---

## 5. 추가상품(볼체인/리필잉크) — addon + template (W-G11)

```
[t_prd_product_addons] (PRD_000217 만년스탬프, addon=리필잉크 PRD_000015)
                       (키링상품, addon=볼체인 PRD_000006·9색은 option)
```
> **search-before-mint:** 볼체인 PRD_000006·리필잉크 PRD_000015 **실재**(라이브 확인) → 재연결만(mint 0). 볼체인 9색은 addon 하위 option_group(택1).

---

## 6. CPQ 적재 준비 상태 요약

| CPQ 항목 | 기초데이터 선적재 | CPQ 적재 가능? | BLOCKER |
|----------|-------------------|:--:|---------|
| size→option(레더라벨·클립보드) | siz_cd 실재 | ✅ 가능(ref_key1 참조) | Q-GP-1 모델 결정(유지 vs 논리삭제) |
| size→option(폰기종·M/L/XL) | 차원행 미적재/오적재 | **BLOCKED** | 차원행 선적재(round-6) |
| 본체색 2축 분리 | 재질행 폭증 | 부분 | 자재유형 정정 + 규격 option(Q-GP-2) |
| 가공 택일 | 공정 0~6행 | 부분 | 공정 연결 + 택일 표현(Q-GP-3) |
| 추가상품 | 대상 PRD 실재 | ✅ 가능 | addon 컬럼명 확인 후 |

> **종착(비파괴):** 본 산출은 CPQ **설계까지**. 실 적재는 ① 기초데이터(공정·차원행) 선적재 ② Q-GP-1/2/3 컨펌 후 인간 승인. **size→option은 BATCH-6·schema-design-intent-map 의존** — 적재된 size행은 본 트랙에서 0건 변경(보존). L1 선적재 BLOCKED 2건(폰기종·M/L/XL 차원행) 정직 표기.
