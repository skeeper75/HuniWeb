# component-inventory-calendar.md — 캘린더 가격구성요소 통합 인벤토리

> 기준점 인벤토리(생성 입력). 캘린더 상품군이 가격에 쓰는 구성요소(자재·공정·사이즈·도수·옵션·수량)와 차원·단가소스·라이브 t_* 현황·재사용 후보.
> 산출자: hpe-formula-cartographer · 라이브 실측 2026-06-22 · 단가값 verbatim · 추정 0.

---

## 1. 구성요소 인벤토리 (차원·단가소스·라이브 현황)

| 비목 | 구성요소(comp 후보) | 차원(use_dims) | 단가 소스 | 라이브 현황 | 재사용 |
|------|---------------------|----------------|-----------|-------------|--------|
| **인쇄비** | COMP_PRINT_DIGITAL_S1 | [proc_cd, plt_siz_cd, print_opt_cd, min_qty, proc_grp:PROC_000001] | 가격표 `디지털인쇄비`(국4절/3절 수량행 × 인쇄면×색 열) | ✅ 212 단가행 실재 | **직계 재사용**(PRF_DGP 동형) |
| **용지비** | COMP_PAPER | [siz_cd, mat_cd] | 가격표 출력소재(IMPORT)·종이별 절가 | ✅ 다수 mat_cd(몽블랑·스노우지) | **직계 재사용** |
| **제본비(탁상220)** | COMP_BIND_CAL_DESK220 | [proc_cd, min_qty, proc_grp:PROC_000017] | 캘린더 제본 수량구간 | ✅ 6 단가행(PROC_000100) | **재사용** |
| **제본비(탁상130)** | COMP_BIND_CAL_DESK130 | [proc_cd, min_qty, proc_grp:PROC_000017] | 동상 | ✅ 6 단가행 | 재사용 |
| **제본비(탁상미니)** | COMP_BIND_CAL_DESKMINI | [proc_cd, min_qty, proc_grp:PROC_000017] | 동상 | ✅ 6 단가행 | 재사용 |
| **제본비(벽걸이)** | COMP_BIND_CAL_WALL | [proc_cd, min_qty, proc_grp:PROC_000017] | 동상(트윈링제본 포함) | ✅ 24 단가행(PROC_000099) | 재사용 |
| **캘린더가공 add-on** | 신규 COMP_CALOPT_*(우드거치대·1구타공끈·2구타공끈) | [opt_cd] 또는 고정 | 상품마스터 `추가가격` 칸 | ❌ 라이브 부재 | **신규 mint 후보** |
| 인쇄면(단/양) | (COMP_PRINT_DIGITAL의 print_opt_cd 차원) | — | 디지털인쇄비 열차원 | ✅ 흡수 | — |
| 색(흑백/CMYK) | (COMP_PRINT_DIGITAL의 proc_cd/print_opt_cd 차원) | — | 디지털인쇄비 열차원 | ✅ 흡수 | — |

★ 신규 mint 최소: 인쇄/용지/제본 comp 전부 재사용. mint = PRF_CAL_* 공식 4종(탁상220·탁상130·미니·벽걸이/와이드) + add-on 가공 comp 3종(우드거치대·타공+끈)뿐.

---

## 2. 차원 분해 — 사이즈(siz_cd) · 도수 · 자재(mat_cd)

### 2-A. 사이즈 (이산 siz_cd · 라이브 등록)

캘린더 사이즈는 이산 siz_cd(면적매트릭스 아님). 예 엽서캘린더(PRD_000110) 라이브 6 size:
- SIZ_000007 A5(148X210) · SIZ_000069 220x145 · SIZ_000070 130x220 · SIZ_000072 145x145 · SIZ_000073 220x130 · SIZ_000074 145x300.

product별 size 수(live): 탁상형 2 · 미니 2 · 엽서 6 · 벽걸이 3 · 와이드 1.
plt_siz_cd(판형): 국4절(SIZ_000499) 4상품 / 3절(SIZ_000077) 와이드 1상품. — 인쇄비 단가행을 가르는 판형 차원.
`확신도: 높음(라이브 t_prd_product_sizes)`

### 2-B. 도수(인쇄면×색) — print_opt_cd / proc_cd 차원으로 흡수

- 인쇄면: 단면/양면(상품마스터 `인쇄(필수)`). 디지털인쇄비 시트 열차원 = print_opt_cd(POPT_000001 단면 / POPT_000002 양면).
- 색: 흑백(1도)/칼라(CMYK)/별색. 디지털인쇄비 시트 다열. 캘린더는 주로 칼라.
- ★별도 도수 comp 분할 금지 — COMP_PRINT_DIGITAL_S1의 차원으로 흡수(별색=공정 동형, 디지털 §3 교훈).

### 2-C. 자재(mat_cd) — 종이

- 몽블랑 190g/240g(MAT_000072~097 계열)·스노우지 250g·스타드림 등. 상품마스터 `종이사양` 칸(`*별도설정` 또는 명시).
- COMP_PAPER siz_cd×mat_cd 차원. 와이드(3절)는 종이별 절가 다름.

---

## 3. 공정(proc_cd) 인벤토리 — 라이브 바인딩

| prd_cd | proc_cd | 공정명 | 가격축 여부 |
|--------|---------|--------|------------|
| PRD_000108·109 | PROC_000076 | 수축포장 | 옵션(개별포장)·가격 컨펌큐 |
| PRD_000110 | PROC_000079 | 타공 | 예(1구타공+끈 add-on) |
| PRD_000111 | PROC_000021·PROC_000079 | 트윈링제본·타공 | 예 |
| PRD_000112 | PROC_000021 | 트윈링제본 | 예 |
| (제본비 단가행 proc) | PROC_000099·PROC_000100 | 벽걸이/탁상캘린더제본 | 예(COMP_BIND_CAL_* 가격행 proc_cd) |
| (제본 그룹) | PROC_000017 | 제본 그룹(proc_grp) | use_dims 그룹키 |

출처: `t_prd_product_processes` + `t_proc_processes` + COMP_BIND_CAL_* 단가행 proc_cd (2026-06-22).
★ PROC_000021(트윈링제본·상품 바인딩) vs PROC_000099/100(제본비 단가행) 이원화 — designer 정합 점검 큐(같은 제본을 두 proc로 표현).

---

## 4. 수량(min_qty) 차원

- 제작수량: 최소 1·최대 10000·증가 1(전 상품 동일).
- 수량 효과 = 인쇄비(COMP_PRINT_DIGITAL min_qty tier 1/2/3…) + 제본비(COMP_BIND_CAL min_qty tier 1/4/10/50/100/1000) 단가행의 수량구간 하락으로 흡수.
- 별도 t_dsc_* 수량구간할인 **바인딩 없음**(굿즈와 차이).

---

## 5. 옵션 레이어(가격 무관) — option_items 후보

| 옵션 | 값 | 가격 영향 | t_* 후보 |
|------|-----|----------|----------|
| 링칼라 | 블랙 등(트윈링제본 선택시만) | 무료 | option_items |
| 삼각대컬러 | 그레이/블랙 | 무료(추가가격 0) | option_items |
| 개별포장 | 개별포장없음/수축포장 | 컨펌큐(수축포장 가격?) | option_items |
| 장수(페이지) | 4(8P)/8(16P)/… | **가격축(인쇄비 곱)** | 차원(option 아님) |

라이브 t_prd_product_option_groups 캘린더 0행 — 옵션 레이어 전면 미적재.

---

## 6. 전 상품군 재사용 후보 요약

| comp | 재사용 출처 | 캘린더 활용 |
|------|------------|------------|
| COMP_PRINT_DIGITAL_S1 | 디지털인쇄 PRF_DGP_A~F | 인쇄비(페이지수 곱만 추가) |
| COMP_PAPER | 디지털인쇄 | 용지비 |
| COMP_BIND_CAL_* | 캘린더 전용(라이브 선적재) | 제본비 |
| (신규) COMP_CALOPT_WOODSTAND·PUNCH1H_STR·PUNCH2H_STR | — | add-on 가공비 |

`확신도: 높음(라이브 t_prc_price_components 실측)`
