# 스티커 — 정답 추출규칙 (extraction-plan · round-13 C2)

> **작성** 2026-06-11 · round-13. 각 상품 × 5속성축(size·자재·공정·도수·인쇄옵션)을 **엑셀 원본 L1 + 스키마 의도 + 확정 도메인**에 비춰 어떻게 추출·변환해 어느 t_*.컬럼에 넣어야 정확한지 확정. C1(실제 적재 규칙·loadlogic-notes)과 나란히 놓는다(실제 vs 정답).
>
> **권위:** ① 상품 정체(product-identity) ② 엑셀 L1(`06_extract/sticker-l1.csv`) ③ 스키마 의도(`00_schema/schema-design-intent-map.md` OM-1~7) ④ 도메인(round-11 column-dictionary/product-bom·round-12 Q1~Q15 ★). 추정 0.
> **round-13 정답 기준 [HARD]:** v03 미참조. 정답=상품마스터 L1. load_master/라이브는 피고.

---

## 0. 스티커 family 공통 추출 원칙 (16상품 공유)

1. **인쇄방식 5분기(C13 폴더)는 상품 root 공정으로 표현** — 디지털(PROC_000004 토너)·실사(PROC_000006 잉크젯)·전사 등. 단 Q1=폴더 자체는 견적 제외. 인쇄방식은 공정 백본 게이팅 단서(CONFIRM-ST-D).
2. **커팅=스티커 핵심 공정** — 반칼(PROC_000054 Kiss Cut)·완칼(PROC_000053 Die Cut)·스티커완칼(PROC_000055). 자유형 모양=prcs_dtl_opt.모양, 조각수=prcs_dtl_opt.조각수. **mand_proc_yn=Y**(커팅은 스티커 필수 공정 — 라이브 N은 의심).
3. **코팅 = Q9★ 공정** — round-12 확정. 단 가격모델/round-11 자재 variant와 CONFLICT(CONFIRM-ST-A). 정답 우변=PROC_000013 코팅(매핑), 라이브 자재 정리는 컨펌.
4. **화이트 별색 = 공정(PROC_000008)** — 투명/홀로그램/투명전용지 베이스 도메인 필수(G-SK-1). print_side 아님.
5. **형상** — 합판도무송(066)=칼틀 1:1·size 유지(Q7★). 규격형(058~062)=형상이 자유 선택축 → prcs_dtl_opt.모양 권위이나 스키마 저장처 부재(OM-7·CONFIRM-ST-C).
6. **조각수 = Q8★ 둘 다** — bundle_qty(묶음수=권/세트) + prcs_dtl_opt.조각수(판당 개수). `*최대N`=상한.
7. **자재유형 = MAT_TYPE.11 스티커 단일** — 스티커 점착지는 전부 .11(라이브 .01/.11 혼재는 오염).
8. **판수(C6)·EA면적계산 = 앱 런타임**(DB 미저장).

---

## 1. 상품별 × 속성축 정답 추출규칙

### 그룹 A — 반칼 자유형 (052·053·054) · 소량(064)

| 상품 | 속성축 | 엑셀 출처(L1) | 정답 추출/변환 규칙 | 목표 t_*.컬럼 | oracle 근거 | 실제(라이브) vs 정답 |
|------|--------|---------------|---------------------|---------------|-------------|---------------------|
| 052 반칼자유형 | size | C5/C8/C9 (A6~400x600 6종) | 규격/자유 치수=siz_cd, work/cut 슬롯 | t_siz_sizes.cut/work_* + product_sizes | column-dict C8/C9 | 라이브 3행(=정답, 정합) |
| 052 | 자재 | C16 (유포·비코팅·미색·**무광/유광코팅**) | 점착지 5종 → mat_cd + usage=USAGE.07. **무광/유광코팅=Q9 코팅 공정으로 분리**(비코팅+코팅) | t_mat_materials(.11) + product_materials | Q9★·column-dict C16 | 라이브: 코팅 2종이 자재(MIS) |
| 052 | 공정(커팅) | C24=`반칼(자유형)` | PROC_000054 반칼·**mand=Y**·prcs_dtl_opt{모양:자유형,조각수} | product_processes(PROC_000054) | product-bom §1·db-domain | 라이브 PROC_000054 1줄·mand=N(MIS) |
| 052 | 공정(코팅) | C16 무광/유광코팅 신호 | PROC_000013 코팅 연결(Q9) | product_processes(PROC_000013) | Q9★ | 라이브: 공정 없음(자재로)(MIS) |
| 052 | 도수 | C17=단면 | print_side=단면·front=CLR_000005(4도)·back=CLR_000001(0도) | print_options | column-dict C17 | 라이브 단면/4도/0도(=정답) |
| 052 | 인쇄옵션(조각수) | C25=`*최대20조각`·`*최대40조각` | bundle_qty(상한) + prcs_dtl_opt.조각수 | bundle_qtys + (OM-7 param) | Q8★ | 라이브 0행(MISSING) |
| 053 반칼자유형투명 | 자재 | C16=투명스티커 | MAT_000162 투명스티커·.11·usage.07 | product_materials | column-dict C16 | 라이브 1행(=정답) |
| 053 | 공정(별색) | C18=`화이트인쇄(단면)` | PROC_000008 화이트·mand=Y(투명 underbase 필수) | product_processes(PROC_000008) | G-SK-1·Q—·product-bom §2 | 라이브 PROC_000008 연결(=정답) |
| 053 | 공정(커팅) | C24=`반칼(자유형)` | PROC_000054 반칼·mand=Y | product_processes | product-bom §2 | 라이브 PROC_000054(mand=N) |
| 054 반칼자유형홀로그램 | 자재/공정 | C16=홀로그램·C18=화이트·C24=반칼 | MAT_000163 + PROC_000008 + PROC_000054 | (동상) | product-bom §3 | 라이브 정합(mand=N만) |
| 064 소량자유형 | 인쇄옵션(조각수) | C25=`*1조각` | bundle_qty=1(소량) | bundle_qtys | product-bom §13 | 라이브 0행(MISSING) |
| 064 | 자재 | C16=점착지 5종(코팅 포함) | 코팅 분리(052 동일) | product_materials/processes | Q9★ | 라이브 코팅 자재(MIS) |

### 그룹 B — 완칼/실사 (055·057) · 화이트인쇄 완칼(056)

| 상품 | 속성축 | 엑셀 출처(L1) | 정답 추출/변환 규칙 | 목표 t_*.컬럼 | oracle 근거 | 실제 vs 정답 |
|------|--------|---------------|---------------------|---------------|-------------|--------------|
| 055 낱장자유형 | 자재 | C16=`유포지+엠보코팅` | 자재명 **완전 보존**("유포지+엠보코팅", 실사 점착소재)·.11·usage.07 | t_mat_materials.mat_nm | column-dict C16·product-bom §4 | 라이브="유포지"(엠보 절단, MIS L-ST-H) |
| 055 | 공정(인쇄방식) | C13=실사출력 | (root 공정 PROC_000006 잉크젯 — CONFIRM-ST-D) | product_processes(root) | product-bom §4 | 라이브: root 미적재 |
| 055 | 공정(커팅) | C24=`완칼(자유형)` | PROC_000053 완칼·mand=Y·prcs_dtl_opt{모양} | product_processes(PROC_000053) | product-bom §4·db-domain | 라이브 PROC_000053(mand=N) |
| 055 | 인쇄옵션(조각수) | C25=`5~10조각`·`*최소크기 30x30/10조각이내` | bundle_qty(5~10) + 최소면적 제약(constraint) | bundle_qtys + constraint | Q8★ | 라이브 0행(MISSING) |
| 056 낱장자유형투명 | 공정 | C18=화이트·C24=완칼 | PROC_000008 + PROC_000053·둘 다 mand=Y | product_processes | product-bom §5 | 라이브 화이트+완칼(mand=N) |
| 056 | 자재 | C16=투명전용지 | MAT_000243·.11(라이브 .01 오염, F-ST 자재유형)·usage.07 | product_materials | column-dict C16 | 라이브 투명전용지(.01, mat_typ MIS) |
| 057 대형자유형 | 자재 | C16=`유포지+엠보코팅` | 완전 보존(055 동일) | t_mat_materials.mat_nm | product-bom §6 | 라이브="유포지"(절단, MIS) |
| 057 | 공정(커팅) | C24=`완칼(자유형)` | PROC_000053 완칼·mand=Y | product_processes | product-bom §6 | 라이브 PROC_000053(mand=N) |

### 그룹 C — 규격형 (058 원형·059 정사각·060 직사각·061 띠지·062 팬시·063 팬시투명)

| 상품 | 속성축 | 엑셀 출처(L1) | 정답 추출/변환 규칙 | 목표 t_*.컬럼 | oracle 근거 | 실제 vs 정답 |
|------|--------|---------------|---------------------|---------------|-------------|--------------|
| 058 반칼원형 | size | C5 (A4/A5 규격) | 규격사이즈=siz_cd | product_sizes | column-dict C5 | 라이브 A4/A5 2행(=정답·규격만) |
| 058 | 공정(커팅+형상) | C24=`원형 25mm (24ea)`~`원형 90mm (6ea)`·★사이즈선택 | PROC_000054 반칼(모양 param 보유)·prcs_dtl_opt{모양:원형,조각수:EA}. ★종속=constraint_json(규격→형상EA 캐스케이드) | product_processes(PROC_000054) + prcs_dtl_opt + constraint | benchmark §2·Q7·CONFIRM-ST-C | 라이브 **PROC_000055(모양 param 없음)** → 형상 저장처 부재(F-ST-5 MISSING) |
| 058 | 자재 | C16=점착지 5종(코팅 포함) | 코팅 분리·.11 | product_materials/processes | Q9★ | 라이브 5행(코팅 자재 MIS) |
| 059 반칼정사각 | 공정(형상) | C24=`30x30mm (20ea)`~`90x90mm`·★종속 | PROC_000054·정사각·EA·★캐스케이드 | (동상) | product-bom §8 | 라이브 PROC_000055(형상 부재) |
| 060 반칼직사각 | 공정(형상) | C24=직사각 25종 `20x40mm (20ea)`~ | PROC_000054·직사각·EA | (동상) | product-bom §9 | 라이브 PROC_000055(형상 부재) |
| 061 반칼띠지 | 공정(형상) | C24=띠지 17종 `10x190mm (9ea)`~ | PROC_000054·띠지·EA | (동상) | product-bom §10 | 라이브 PROC_000055(형상 부재) |
| 062 반칼팬시 | 공정(형상) | C24=`하트 36mm`·`사각분할`·`원형 32mm`·★종속 | PROC_000054·팬시형상·★캐스케이드 | (동상) | product-bom §11 | 라이브 PROC_000055(형상 부재) |
| 063 반칼팬시투명 | 공정(별색) | C18=`화이트인쇄(단면)`·`화이트인쇄(없음)` 택1 | PROC_000008 화이트(택1·투명 베이스) | product_processes(PROC_000008) | G-SK-1·product-bom §12 | **라이브 화이트 미연결(F-ST-3 MISSING)** |
| 063 | 자재 | C16=투명스티커 | MAT_000162·.11 | product_materials | column-dict C16 | 라이브 투명스티커(=정답) |

### 그룹 D — 합판/팩/전사 (066 합판도무송·065 스티커팩·067 타투)

| 상품 | 속성축 | 엑셀 출처(L1) | 정답 추출/변환 규칙 | 목표 t_*.컬럼 | oracle 근거 | 실제 vs 정답 |
|------|--------|---------------|---------------------|---------------|-------------|--------------|
| 066 합판도무송 | size(형상=칼틀) | C24=`원형 10mm (8EA)`~ 37형상 | **형상=칼틀 1:1·siz_nm에 형상+치수+EA 인코딩·size 유지(Q7★)** | t_siz_sizes.siz_nm + product_sizes(37행) | **Q7★**·live-crosscheck §5 가격격자 | 라이브 37행(`정사각30x30mm(2EA)`)(=정답·Q7 정합) |
| 066 | 공정(커팅) | (도무송=완칼계열) | PROC_000055 스티커완칼·**커팅에 형상 중복 입력 안 함**(Q7 — siz_cd가 칼틀 식별자)·mand=Y | product_processes(PROC_000055) 1줄 | Q7★·live-crosscheck §3 | 라이브 PROC_000055 1줄·형상 중복 없음(=정답·mand=N만) |
| 066 | 자재 | C16=유포·비코팅·**무광/유광코팅**·투명/은데드롱 6종 | 코팅 분리(Q9)·데드롱(합판 전용)·.11 | product_materials/processes | product-bom §15·Q9 | 라이브 6행(코팅 자재 MIS) |
| 066 | 인쇄옵션(조각수) | (형상별 EA=조각수) | bundle_qty(1/2/3/6/8 EA) — **EA=조각수≠묶음수** | bundle_qtys | Q8★·live-crosscheck §3 | 라이브 5행(1/2/3/6/8·QTY_UNIT.01 EA)(부분 정합·의미 혼입) |
| 065 스티커팩 | 구성(세트) | 팩=여러 스티커 시트째 묶음 | **세트 구성**(sub_prd 또는 set 정의)·커팅 없음 | t_prd_product_sets | product-bom §14 | 라이브 sets=0(MISSING·CONFIRM-ST-E) |
| 065 | 자재 | C16=비코팅·미색 2종 | .01/.11 통일 | product_materials | column-dict C16 | 라이브 2행(.01·mat_typ 혼재) |
| 067 타투 | 자재/공정 | C16=타투전용지·C13=전사·커팅 없음 | MAT_000167 타투전용지·전사 root·커팅 0 | product_materials | product-bom §16 | 라이브 1자재·공정 0(=정답·커팅 없음 정합) |
| 067 | MES | C3=002-0014 | MES_ITEM_CD=002-0014(원형 보존) | t_prd_products.MES_ITEM_CD | column-dict C3·D-05 | 라이브 NULL(MISSING L-ST-A) |

---

## 2. 횡단 속성축 — 5축 × 16상품 커버리지

| 속성축 | 정답 t_* | 적용 상품 | 라이브 상태 요약 |
|--------|----------|-----------|-------------------|
| **size** | t_siz_sizes + product_sizes | 16상품 전부 | 052/064 등 정합·066 형상=size(Q7 정합)·058~062 규격만(형상 부재 F-ST-5) |
| **자재** | t_mat_materials(.11) + product_materials(usage.07) | 16상품 | 코팅 2종 자재 오적재(F-ST-2·8상품)·자재유형 .01/.11 혼재(F-ST-F)·055/057 자재명 절단(L-ST-H) |
| **공정(커팅)** | product_processes(PROC_53/54/55) | 052~064·066(065/067 제외) | 커팅 연결됨이나 mand=N(필수성 결함)·규격형 형상 param 부재·코팅 공정 미적재 |
| **공정(별색)** | product_processes(PROC_000008) | 053/054/056/063 | 053/054/056 정합·063 화이트 MISSING(F-ST-3) |
| **도수** | print_options(print_side·front/back) | 16상품 | 단면/4도/0도 정합(검토 표본 052=정답) |
| **인쇄옵션(조각수)** | bundle_qtys + (OM-7 param) | 052/055/057/058~062/064 등 | 066만 적재·나머지 MISSING(F-ST-4·Q8 미실현) |

> **N/A 사유:** 후가공 가변(VDP)·추가상품·클리어/핑크/금/은 별색 = 스티커 전 상품 빈값(L1 실측) → 적재 안 함이 정답(라이브 정합).

---

## 3. 정답 vs 라이브 핵심 격차 (extraction-plan → correction-manifest 연결)

| 격차 | 상품 범위 | 정답 | 라이브 | manifest ID |
|------|-----------|------|--------|-------------|
| 코팅=공정 | 052/058~062/064/066 (8) | PROC_000013 + 비코팅 자재 | MAT_000155/156 자재 | C-ST-04 |
| 조각수 미적재 | 052/055/057/058~064 (~12) | bundle_qty + param | 066만 | C-ST-05 |
| 규격형 형상 부재 | 058~062 (5) | PROC_000054 + prcs_dtl_opt.모양 | PROC_000055(param 없음) | C-ST-06 |
| 063 화이트 누락 | 063 (1) | PROC_000008 | 없음 | C-ST-07 |
| MES NULL | 16상품 | 002-0001~0016 | NULL | C-ST-08 |
| 자재유형 혼재 | 다수 | MAT_TYPE.11 통일 | .01/.11 | C-ST-09 |
| 자재명 절단 | 055/057 | 유포지+엠보코팅 | 유포지 | C-ST-10 |
| 카테고리 root | 16상품 | 개별 노드 030~047 | CAT_000002 root | C-ST-02 |
| 커팅 mand=N | 052~066 커팅상품 | mand=Y | mand=N | C-ST-11 |
| 066 빈 옵션그룹 | 066 | (없어야) | OPT-000004 빈 | C-ST-12 |
| 스티커팩 세트 | 065 | sets 구성 | 0 | C-ST-13 |
