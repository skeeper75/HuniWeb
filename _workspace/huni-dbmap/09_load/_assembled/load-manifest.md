# 적재 매니페스트 — round-4 상품마스터 통합 번들 (실행=인간 승인 대상, 본 하네스는 산출까지)

> **권위:** `docs/goal-2026-06-06-01.md`(GOAL) · `09_load/_load-dashboard.md`(round-3 전수 대시보드) · `HANDOFF-audit.md`(K-1~5 결정).
> **조립 원칙(HARD):** 매핑 재도출 0 — 11시트 검증된 `load/*.csv`를 **조립·순서화·갭격리**만. DB 쓰기·DDL 0. 추정 0(전 행 `_provenance`).
> **재현성(G8):** 본 번들은 `_assembled/compose_bundle.py` + `compose_aux.py`로 재생성(멱등). 손편집 0.
> **작성** 2026-06-06 · 식별자/테이블/컬럼/코드/SQL 영어, 설명 한국어.

---

## 0. 한 줄 현황

11시트 검증 적재본을 **FK 위상정렬 단일 번들**로 조립 완료. 즉시 적재가능 **384행**(materials 316·processes 62·bundle_qtys 6) + UPDATE-set **314행** + 코드선적재 제안 **11행**(레이저커팅 proc 1·sticker 원형 siz 10) + 차단 **36행**(레이저커팅 의존 14·template 부재 addon 4·디자인캘린더 신규 18) + GAP **2건**(goods-pouch 비치수 size·박 미해당) + conditional 보류 **9행**(라이브 재확인). **전 대상 테이블 `t_*` 화이트리스트 내(G1 충족).** **조립 중 실결함 2건 적발**(addon 스키마 모델 불일치·레이저커팅 코드 의존) — §6. **검증 게이트 보정 2건 반영**(원형35x35=라이브 SIZ_000422 재사용으로 siz 11→10·LIVE_TEMPLATES 전수 11개).

---

## 1. 적재 순서 (FK 위상정렬)

라이브 FK 그래프(read-only `information_schema` 조회, 2026-06-06)로 위상정렬. 부모 → 자식.

| 단계 | 대상 t_* 테이블 | 소스 | 적재 행수 | 이 위치를 강제하는 FK 엣지 |
|------|----------------|------|----------|---------------------------|
| **00a** | `t_proc_processes` (코드선적재 제안) | `load/00_proc_laser.csv` | 1 (제안) | `t_prd_product_processes.proc_cd → t_proc_processes.proc_cd` (레이저커팅 신설=14 완칼행 FK 부모) |
| **00b** | `t_siz_sizes` (코드선적재 제안) | `load/00_siz_sticker_circle.csv` | 10 신설 (+1 재사용 SIZ_000422) | `t_prd_product_sizes.siz_cd → t_siz_sizes.siz_cd` (sticker 066 원형; 35mm는 라이브 SIZ_000422 재사용) |
| **03** | `t_prd_products` (디자인캘린더 신규) | `blocked/design-calendar-newprod/t_prd_products.csv` | 5 (차단) | (모든 `t_prd_product_*`의 부모 `prd_cd`. placeholder=후니 실번호 부여 대기) |
| **04** | `t_prd_product_sizes` | (즉시분 0) · `blocked/design-calendar-newprod/...sizes.csv` 5(차단) | 0 / 5차단 | `siz_cd → t_siz_sizes`, `prd_cd → t_prd_products` |
| **05** | `t_prd_product_materials` | `load/05_t_prd_product_materials.csv` | **316** | `mat_cd → t_mat_materials`, `usage_cd → t_cod_base_codes`, `dep_proc_cd → t_proc_processes`, `prd_cd → t_prd_products` |
| **06** | `t_prd_product_processes` | `load/06_t_prd_product_processes.csv` | **62** | `proc_cd → t_proc_processes`, `prd_cd → t_prd_products` |
| **07** | `t_prd_product_print_options` | (즉시분 0) · `blocked/design-calendar-newprod/...print_options.csv` 5(차단) | 0 / 5차단 | `front/back_colrcnt_cd → t_clr_color_counts`, `prd_cd → t_prd_products` |
| **08** | `t_prd_product_page_rules` | (즉시분 0) · `blocked/design-calendar-newprod/...page_rules.csv` 5(차단) | 0 / 5차단 | `prd_cd → t_prd_products` |
| **09** | `t_prd_product_bundle_qtys` | `load/09_t_prd_product_bundle_qtys.csv` | **6** | `bdl_unit_typ_cd → t_cod_base_codes`, `prd_cd → t_prd_products` |
| **10** | `t_prd_product_addons` | (즉시분 0) · `blocked/relation-rows-blocked.csv` addon 4(차단) | 0 / 4차단 | `tmpl_cd → t_prd_templates`, `prd_cd → t_prd_products` |

> **단계 01·02 부재 사유:** round-4 상품마스터 10시트는 **마스터·상품(`t_prd_products`) 무변경**(라이브 prd_cd 실재 확인) — 신규 상품 등록은 디자인캘린더 5종(단계 03, 차단)뿐. `t_prd_product_categories`·`_plate_sizes`·`_sets`·`_print_options`(디자인캘린더 외)는 round-3 적재 변경 0(no-op).
> **UPDATE-set은 INSERT 아님** — 해당 단계 내 컬럼 갱신으로 별도 lane(`update-set/`). 적재 순서상 대상 행이 이미 존재해야 하므로 INSERT 단계 이후 적용.

## 2. 적재 분류 집계 (대시보드 총량 정합 — G7, 행 소실 0)

### 즉시 적재가능 (`load/<NN>_<table>.csv`) — 384행

| 대상 테이블 | 행수 | 시트 내역 |
|------------|------|----------|
| `t_prd_product_materials` | 316 | digital-print 180 · booklet 83 · calendar 43 · acrylic 10 |
| `t_prd_product_processes` | 62 | digital-print 26 · booklet 4 · stationery 13 · sticker 3 · silsa 1 · acrylic UV 14+부착 1=15 |
| `t_prd_product_bundle_qtys` | 6 | acrylic 6 |
| **합계** | **384** | |

### UPDATE-set (`update-set/<table>_update.csv`) — 314행

| 산출 | 행수 | 시트 |
|------|------|------|
| `t_prd_products` qty_unit_typ_cd 갱신 | 244 | 전 10시트 |
| `t_prd_products` nonspec 갱신 | 25 | acrylic 13 · silsa 12 |
| `t_prd_product_materials` 두께 정정 | 20 | acrylic |
| `t_prd_product_print_options` UV/print_side 정정 | 20 | acrylic |
| `t_prd_product_processes` excl_grp_cd 택일연결 | 4 | calendar |
| `t_prd_product_process_excl_groups` note 갱신 | 1 | calendar |
| **합계** | **314** | |

### 코드선적재 제안 (`load/00_*.csv` — 후니 등록 대기) — 11행

| 제안 | 행수 | 의존 적재행 |
|------|------|------------|
| `t_proc_processes` 레이저커팅(PROC_000084) | 1 | 아크릴 완칼 14행 (차단) |
| `t_siz_sizes` sticker 원형 신설 10종(SIZ_000501~510) | 10 | sticker 066 원형 size link 11행(신설 10 + 라이브 SIZ_000422 재사용 1, 현재 BLOCKED) |

### 차단 (후니 등록 대기) — 36행 → `blocked-and-gaps.md`

| 차단 | 행수 | 해소 조건 |
|------|------|----------|
| 아크릴 완칼 → 레이저커팅 의존(K-2) | 14 | 단계 00a PROC_000084 등록 |
| addon template 부재(PRD_000003·008·015) | 4 | 후니가 해당 template 등록 |
| 디자인캘린더 5신규상품 전 연결행 | 18 | 후니 prd_cd 실번호 부여(Q-DC-0) — products 5·sizes 5·materials 5·processes 2·print_options 5·page_rules 5·addons 2 중 prd_cd 의존 합산(중복 prd_cd 제외 연결 18) |

### GAP (무손실 표현 불가 — 에스컬레이션) — 2건 → `blocked-and-gaps.md`

| GAP | 규모 | 사유 |
|-----|------|------|
| goods-pouch 비치수 size | 47상품(125 reference행) | 비치수 라벨(원형90mm·11온스·M/L 등) 마스터 모델링 미정(D-1) |
| (박 2단룩업) | 해당 없음 | round-4 상품마스터엔 박류 미포함(round-2 가격트랙 GAP) |

### conditional 보류 (적재 직전 라이브 재확인) — 9행 → `blocked-and-gaps.md`

| 항목 | 행수 | 상태 |
|------|------|------|
| digital-print 016 process | 4 | DROP 확정(라이브 27~32 실재) |
| calendar material 4 | 4 | PK충돌(라이브 기적재) |
| acrylic 151 부착 | 1 | PK충돌(맥세이프 부착 기적재) |

### deferred (출시/소스부재 — 적재 대상 아님, 기록만)

acrylic processes 15(use_yn=N 12 + over-reach 3) · acrylic materials 4 · **booklet 내지자재 6(소스 부재=K-1 차단)** · silsa board 7 · silsa addon flag 9 · 기타 시트별. 비활성=미출시(C-1)·소스부재=발명 금지. 출시/실무정보 입력 시 처리.

## 3. `t_*` 화이트리스트 검증 (G1)

본 번들의 전 대상 테이블 = `t_proc_processes`·`t_siz_sizes`(마스터 코드선적재) · `t_prd_products` · `t_prd_product_{materials,processes,bundle_qtys,sizes,print_options,page_rules,addons}`. **전부 GOAL §5 화이트리스트 내. 비-`t_`/Django 테이블 적재행 0.** ✅

## 4. 검증 인계 (G9 — 자기승인 금지)

- **입력:** 본 매니페스트 + `load/*.csv` + `update-set/*.csv` + `code-row-preload.md` + `blocked-and-gaps.md` + 재현 스크립트(`compose_bundle.py`·`compose_aux.py`).
- **게이트:** `dbm-validator`가 G1~G9 + 롤백전용 DRY-RUN → `03_validation/load-readiness-gate.md` (GO/NO-GO).
- **빌더는 자기 승인하지 않는다.** 조립 중 적발한 실결함 2건(§6)은 검증자 재확인 + 사용자 에스컬레이션 대상.

## 5. 적재 직전 HARD 조건 (대시보드 §5 계승)

1. **[HARD] 라이브 export로 `verify_expected.py` 재실행** — round-3 게이트는 stale ref(2026-06-04) 기준. 적재 직전 라이브 기반 1회 재실행으로 기적재·중복PK 격차 닫기(calendar PK충돌 4행이 실증).
2. **conditional 9행 라이브 SELECT 재확인** — 부재 확인 시 active 승격, 실재 시 폐기.
3. **FK 순서 준수** — 본 §1 표 순서(00 코드 → 03 products → 05 materials → 06 processes → 09 bundle → 10 addon). UPDATE-set은 해당 INSERT 단계 이후.

## 6. 조립 중 적발 실결함 (검증자 확인 + 사용자 에스컬레이션 대상)

1. **addon 스키마 모델 불일치 (G4/G5).** round-3 addon `load/*.csv`는 컬럼 `addon_prd_cd`(상품 참조)를 쓰나, **라이브 `t_prd_product_addons`에는 `addon_prd_cd` 컬럼이 없고 `tmpl_cd → t_prd_templates` FK 모델**이다. `addon_prd_cd=PRD_xxxxxx → tmpl_cd=TMPL-PRD_xxxxxx` 결정적 변환으로 조립(라이브 컨벤션 실증). 변환 후 **template 실재 분기**: PRD_000005·012는 template 실재(디자인캘린더 addon, 단 신규상품이라 prd_cd 차단)·PRD_000003·008·015는 template 부재 → 4행 차단. round-3 설계가 라이브 addon 모델 미반영.
2. **레이저커팅 코드 의존 (K-2).** acrylic active processes는 완칼 14행에 `PROC_000053`(종이/스티커 완칼) 차용. K-2 결정=레이저커팅 proc_cd 신설·053 차용 중단. 14행을 신규 `PROC_000084`(레이저커팅, 단계 00a 제안)로 재지정 → 코드 등록 전까지 차단. (053 차용본을 그대로 즉시적재하면 K-2 위반·의미 부정확.)
