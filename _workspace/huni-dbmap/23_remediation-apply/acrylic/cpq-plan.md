# 아크릴 — CPQ 옵션/템플릿/제약 반영 설계 (cpq-plan)

> **작성** 2026-06-14 · round-13. 사용자 기준 5번 = "기초데이터(size/자재/공정/도수/판형/묶음수)만이 아니라 option/template/constraint까지 묶어 설계".
> **라이브 CPQ 스키마(2026-06-14 실측):**
> `t_prd_product_option_groups`(opt_grp_cd·opt_grp_nm·sel_typ_cd·min/max_sel_cnt·mand_yn·use_yn·del_yn) → `t_prd_product_option_items`(opt_cd·item_seq·**ref_dim_cd polymorphic**·ref_key1/2·qty) → `t_prd_product_constraints`(rule_typ_cd·logic JSONLogic·err_msg).
> **아크릴 CPQ 적재 현황(실측):** option_groups **0** · constraints **0** (아크릴 23상품 CPQ 옵션 전면 미적재 — binding §E ③선택 0 일치).
> **[HARD] 설계까지** — 실제 CPQ 적재는 인간 승인. 차원행 미적재면 "L1 선적재 BLOCKED" 정직 표기.
> **polymorphic ref_dim_cd(OPT_REF_DIM 7종):** 사이즈·판형·자재·공정·묶음수·도수·셋트.

---

## 1. 아크릴 CPQ 귀속 대상 (정체 기반 — UV 굿즈 단품)

| 속성 | 어느 상품 | 기초데이터 적재? | CPQ 레이어 |
|------|-----------|------------------|------------|
| UV 변형(배면양면/풀빼다/투명테두리/단면인쇄) | UV 보유 20상품 | print_side에 오적재(AW-M1) | **option_group(택1·UV변형) + 공정 PROC_000002 재정렬** |
| 완칼 형상(모양) | 형상 굿즈 17상품 | 공정 0행(완칼 미연결·AW-X1) | **option_group(택1·모양) + option_items(형상값)** |
| 두께(자재 variant) | 미니파츠1.5/코롯토8/나머지3mm | 두께별 mat_cd 적재됨(AW-C1) | (자재행으로 표현 — 단일 상품 내 단일 두께면 CPQ 불요) |
| 부속(고리/자석/핀/집게/바디/끈) | 부착성 부속 상품 | 부속 자재 적재됨(AW-C2)·부착공정 부분(AW-X2) | **option_group(택1·부속) + 부착공정 2축** |
| 볼펜색6·지비츠타입(스핀/투명) | 볼펜155·지비츠156 | 본체만(AW-A3) | **option_group(택1·색/타입 variant)** |
| 조각수(2~6/10) | 자유형160·미니파츠163 | bundle_qty 적재됨(AW-C4) | **option_group(택1·조각수·ref_dim=묶음수)** |
| 볼체인 9색 addon | 키링146·포카키링158 | addon 0행(AW-R1 소실) | **template + 색 variant option** |
| 카라비너 고리 7색 | 카라비너166 | 부속 미연결(AW-X4) | **option_group(택1·고리색)** |

> **아크릴 미사용(N/A):** 박/형압·코팅·제본·오시·미싱·별색·page_rule·process_excl_group — 아크릴 무(extraction-plan §4). 디지털인쇄의 박색 8종 같은 옵션 없음.

---

## 2. UV 변형 — option_group(택1) + 공정 재정렬 (CONFIRM-AC-4 귀속)

**문제:** UV 변형(배면양면/풀빼다/투명테두리)이 인쇄면(print_side) 칸에 오적재(AW-M1·load_master:359 하드코딩). UV 출력은 풀컬러 단일이라 도수/인쇄면 슬롯 부적합. 게다가 20상품 동일 3종(상품별 실제 변형 무시).

**설계(마그넷147 기준·L1 변형=단면인쇄/투명테두리/풀빼다):**

```
[기초데이터] t_prd_product_processes: (PRD_000147, PROC_000002 UV) 연결  ← apply.sql 컨펌블록
[option_group] OG-147-UVVAR (UV변형)
  opt_grp_nm="UV인쇄 변형" · sel_typ_cd=택1 · mand_yn=Y · min=1 max=1
  [option_items] ref_dim_cd=공정(PROC_000002) · ref_key1=변형값
    단면인쇄 / 투명테두리 / 풀빼다   ← 상품별 L1 distinct(하드코딩 아님)
```

**상품별 변형 차이(L1 정답·하드코딩 대체):** 키링=배면양면만·마그넷=단면인쇄/투명테두리/풀빼다·뱃지=투명테두리/풀빼다·스마트톡=투명테두리만·명찰=풀빼다만·네임택/포카키링/스탠드류=배면양면.

**적재처 결정(CONFIRM-AC-4):**
- (a) **CPQ option_items의 ref_key1에 변형명 문자열**로 저장(권장 — prcs_dtl_opt 테이블 부재 회피, polymorphic 활용).
- (b) `prcs_dtl_opt` 신규 테이블(ddl) — 공정 세부 변형 정식 모델.
- 기존 print_side 3행은 **즉시 삭제 금지** — UV process + 변형 option 적재·검증 후 논리 보류/정정.

> **L1 선적재 BLOCKED 아님:** UV PROC_000002 마스터 실재 → 공정 연결 즉시 가능. 변형 param 적재처만 결정 대기.

---

## 3. 완칼 형상 — option_group(택1) + option_items (CONFIRM-AC-1 귀속)

**문제:** 완칼(PROC_000053) 아크릴 전 상품 0건(AW-X1·BLOCKER급). 형상 굿즈 die-cut 필수인데 전무. 형상 모양값(코스터 원형/사각·카라비너 4형상 등)을 담을 prcs_dtl_opt 부재.

**설계(코스터159 기준·L1 형상=원형/사각):**

```
[기초데이터] t_prd_product_processes: (PRD_000159, PROC_000053 완칼) 연결  ← apply.sql 컨펌블록(159는 use_yn=N)
[option_group] OG-159-SHAPE (완칼 모양)
  opt_grp_nm="완칼 모양" · sel_typ_cd=택1 · mand_yn=Y
  [option_items] ref_dim_cd=공정(PROC_000053 완칼) · ref_key1=모양값
    원형 / 사각   ← L1 형상(라이브 siz_nm에도 보존됨)
```

**도무송 형상=size 칼틀 1:1 메모리 권위와의 정합:** 코스터/카라비너는 "같은 종류에 모양만 다름"이라 라이브가 siz_nm에 형상 보존(100x100mm원형/사각). 완칼 모양 option은 **그 형상 굿즈의 die-cut 공정 측면**을 표현(형상=siz, 완칼=공정 — 2축 병존, 충돌 아님).

**판/입체류 제외(over-reach 보정):** 판아크릴161(단순 판재)·입체코롯토168·입체블럭169는 완칼 미적용(round-3 G-AC-1 보정).

> **L1 선적재 BLOCKED 아님:** 완칼 PROC_000053 마스터 실재 → 공정 연결 즉시 가능(apply.sql 컨펌블록). 모양 param 적재처(option_items ref_key1)만 결정 대기.

---

## 4. 부속 + 부착공정 2축 — option + 공정 (CONFIRM-AC-3 귀속)

**문제:** 부속(고리/자석/핀/집게/바디/끈)은 ① 주문 선택(자재 옵션) + ② 생산 BOM(부착 공정) 두 의미(메모리 `dbmap-option-material-process-bundle`). 부속 자재는 적재됨(AW-C2)이나 부착공정 부분(AW-X2)·일부 부속 미연결(AW-X4 카라비너 고리·AW-X5 네임택).

**설계(뱃지148 기준·핀/자석 부속):**

```
[기초데이터] t_prd_product_materials: 원형핀047·1구자석048 (적재됨)
            t_prd_product_processes: (PRD_000148, PROC_000081 부착) 연결  ← apply.sql 컨펌블록
[option_group] OG-148-ATTACH (부속)
  opt_grp_nm="부속(핀/자석)" · sel_typ_cd=택1 · mand_yn=N
  [option_items] ref_dim_cd=자재 · ref_key1=mat_cd · ref_key2=usage_cd
    원형핀(MAT_000047) / 1구자석(MAT_000048)
[constraint] CON-148-ATTACHPROC (부속 선택 시 부착공정 동반)
  rule_typ_cd=캐스케이드 · logic: {"if":[{"var":"부속"},{"requires":"PROC_000081"}]}
```

**variant 분기(AW-A3):** 볼펜대 6색·지비츠 스핀/투명·스마트톡 바디는 부착 부속(자재+공정 2축)이 아니라 **색/타입 선택값(variant)** → option_group(택1·variant)만(부착공정 무). CONFIRM-AC-3로 분기 결정.

**부착 대상 enum 확장(AW-X2):** PROC_000081 대상 enum=[라벨,맥세이프,끈,테입]에 **핀/자석/집게 부재** → enum 확장 컨펌 필요.

---

## 5. 볼체인 addon·조각수·카라비너 고리

| CPQ 항목 | 설계 | BLOCKER |
|----------|------|---------|
| 볼체인 9색(키링146/포카키링158·AW-R1) | template(볼체인 신설) + 색 9종 option. PRD_000006 master 건재(재연결) | **template 신설 선행**(t_prd_templates 봉투류만·볼체인 template 0건) |
| 조각수(자유형160 2~6·미니파츠163 10·AW-C4) | option_group(택1·조각수·ref_dim_cd=묶음수·ref_key1=bdl_qty). bundle_qty 적재됨 | 없음(bundle 실재) — 완칼 조각수 param은 AW-X1 연동 |
| 카라비너 고리 7색(166·AW-X4) | option_group(택1·고리색). 실버≈은051·골드≈금052 재사용 + 5색 코드 신설 | **5색 부속 코드 신설 선행**(레드/블랙/핑크/하늘/화이트) |

---

## 6. CPQ 적재 준비 상태 요약

| CPQ 항목 | 기초데이터 선적재 | CPQ 적재 가능? | BLOCKER |
|----------|-------------------|:--:|---------|
| UV 변형(20상품) | UV PROC_000002 14상품 적재·6상품 미연결 | 부분 | 변형 param 적재처 결정(CONFIRM-AC-4) + UV 6상품 연결(AW-X3) |
| 완칼 형상(17상품) | 완칼 PROC_000053 **0건** | 부분 | 완칼 공정 연결(apply 컨펌블록) + 모양 param 적재처(CONFIRM-AC-1) |
| 부속+부착(부착성 상품) | 부속 자재 적재·부착공정 부분 | 부분 | 부착 enum 확장(CONFIRM-AC-3) |
| 조각수(자유형/미니파츠) | bundle_qty 실재 | ✅ 가능 | 없음 |
| 볼체인 addon(키링/포카키링) | addon **0행**(소실) | **BLOCKED** | 볼체인 template 신설(AW-R1) |
| 카라비너 고리(166) | 부속 일부만 | **BLOCKED** | 5색 부속 코드 신설(AW-X4) |
| 라미10T(입체블럭169) | 192 폴백 | **BLOCKED** | 라미 자재 신설(AW-A1) |

> **종착(비파괴):** 본 산출은 CPQ **설계까지**. option_groups/items/constraints 실 적재는 ① 기초데이터(완칼·UV·부착 공정) 선적재 ② CONFIRM-AC-1/3/4/6/A1 컨펌 후 인간 승인. L1 선적재 BLOCKED 3건(볼체인 template·카라비너 5색·라미10T) 정직 표기. 아크릴 CPQ 옵션 전면 미적재(option_groups 0) 상태이므로, 본 설계가 아크릴 첫 CPQ 적재 청사진.
