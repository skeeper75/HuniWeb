# 등록 명세 스캐폴드 — 나머지 4축 (사이즈·도수·인쇄옵션·공정)

> **하네스** hbg Phase 3 설계가. **작성** 2026-06-18.
> **지위:** 1순위(자재·카테고리)는 `regspec-material.md`·`regspec-category.md` 전수. 본 문서는 나머지 4축 **명세 틀**(scaffold) — 진단 스캐폴드(`diagnosis-scaffold.md`) 윤곽 + 자재 축이동 수신 정합. 전수 등록 명세는 후속 회차.
> **공통 채번/적재경로 규약:** `regspec-material.md §0` 인용.

---

## 0. 4축 라이브 행수 (진단 스캐폴드 §0 인용·2026-06-18)

| 축 | t_* | 라이브 행수 | 등록 명세 상태 |
|----|-----|:--:|------|
| ② 사이즈 | `t_siz_sizes` | 520 | 자재 축이동 29행 수신 그릇(틀) |
| ③ 도수 | `t_clr_color_counts` | 5(SEED 폐쇄) | 신규/교정 0(틀만) |
| 인쇄옵션 | `t_prd_product_print_options` | 166 | 자재 print_side 14행 수신 그릇(틀) |
| ⑤ 공정 | `t_proc_processes` | 102 | 신규 공정 등록 틀(코팅 분해·봉제) |

---

## ② 사이즈 등록 명세 틀 (`t_siz_sizes`)

| 명세 단위 | 내용(틀) |
|-----------|---------|
| **대상 t_* + 코드값** | `t_siz_sizes` siz_cd=`SIZ_NNNNNN`(MAX+1) · 비치수=`t_siz_nonspec_sizes` nsiz_cd=`NSIZ_NNNNNN`(신규 마스터·goods-pouch-nondim-size DDL) |
| **올바른 의미** | 물리 치수만(작업/재단 이중축). 색·형상·수량·출력판형 인코딩 금지(OM-1). |
| **수신(자재 축이동)** | 자재 .09 shape 18 + size 11 = **29행 수신**(regspec-material §3.1/§3.2). 치수보유→siz·비치수→nondim 마스터·형상 분류→shape_cd(SHAPE 코드). |
| **search-before-mint** | 치수 siz=기존 그릇. 비치수=신규 마스터 정당(work/cut NULL 라벨 0건 입증·goods-pouch-nondim-size §2). 형상=shape_cd 컬럼(기존 junction 재사용·테이블 0). |
| **FK 위상** | 비치수 = NONDIM_SIZE_KIND 코드행 → t_siz_nonspec_sizes·연결 DDL → 라벨/연결 적재. SHAPE = 코드행 + shape_cd 컬럼 DDL 선행. |
| **적재경로** | `pvEdit(prd_cd, sizes)`. 비치수/형상 컬럼 = **DDL 적용 후 catalog 모델 노출(현재 미상)**. |
| **영향분석** | **★기계적 size 삭제 금지**(component_prices 116siz 2,601행 CASCADE·전부 가격종속·round-22 ② CORRECT 반증). 자재 수신은 신규 추가(기존 siz 무손상). nonspec NULL=data-gap(GAP-MAT-1). |
| **컨펌** | AX-2(size→option 사슬 보존)·AX-3(실사 비규격 좌표 vs 면적함수). |

---

## ③ 도수 등록 명세 틀 (`t_clr_color_counts`) 🟢

| 명세 단위 | 내용(틀) |
|-----------|---------|
| **대상 t_* + 코드값** | `t_clr_color_counts` — **5행 폐쇄 SEED**(CLR_000001~005·0~4도). 신규 발급 없음. |
| **올바른 의미** | 잉크 채널수 0~4. 별색=공정(PROC_000007·clr_cd=NULL)으로 분리(정상). |
| **수신(자재 축이동)** | 자재 .10 잉크색 8행 = **수신 여부 컨펌(AX-1)**. 도수=CMYK 채널수 SEED라 잉크색 7종 부적합 가능 → 별색공정/자유옵션 유력. |
| **search-before-mint** | SEED 폐쇄 — 신규 코드행 0. 잉크색은 도수 아닐 가능성(채널수≠색). |
| **FK 위상** | 신규 0. |
| **적재경로** | (해당 시) — 잉크색은 도수 칸 부적합 → regspec-material §4.3 별색공정/옵션 분기 우선. |
| **영향분석** | 결함 없음(🟢). 별색 분리 정상(라이브 SEED 무변형 실측). |
| **컨펌** | AX-1(잉크색 귀속·도수 부적합 판단). |

---

## (인쇄옵션) 등록 명세 틀 (`t_prd_product_print_options`)

| 명세 단위 | 내용(틀) |
|-----------|---------|
| **대상 t_* + 코드값** | `t_prd_product_print_options`(opt_id PK·print_side 5종 도메인·166행). OPT_REF_DIM.06(도수=opt_id NOT clr_cd). |
| **올바른 의미** | 인쇄면 도수(단/양면·앞뒷면 color count). **별색/UV는 print_side 금지**(OM-5). |
| **수신(자재 축이동)** | 자재 .09 print_side 14행 = **수신**(regspec-material §3.4). 단면/양면/가로형/세로형 → print_side. |
| **search-before-mint** | 기존 그릇 PASS(print_side 5종·166행). 신규 0. "양면유광"의 유광=코팅(공정) 분해 검토. |
| **FK 위상** | print_option 등록 → 자재 BOM 재배선 → .09 print_side use_yn='N'. |
| **적재경로** | `pvEdit(prd_cd, print_options)`. |
| **영향분석** | UV/별색 위치 교정(round-13 아크릴 print_side에 UV 오적재 전역). 자재 수신은 즉시 가능(컨펌 무관). |
| **컨펌** | OM-5(UV/별색 위치)·CONFIRM-DP-4(별색 proc_cd 정합). |

---

## ⑤ 공정 등록 명세 틀 (`t_proc_processes`) 🟡

| 명세 단위 | 내용(틀) |
|-----------|---------|
| **대상 t_* + 코드값** | `t_proc_processes` proc_cd=`PROC_NNNNNN`(라이브 MAX 102·MAX+1). self-ref PROC_000001(인쇄방식)·별색 PROC_000007·prcs_dtl_opt JSON param. |
| **올바른 의미** | 공정+인쇄방식+별색+param. 봉제/보드/삼각대/미싱제본 자식 공정 누락 지배. |
| **수신(자재)** | 자재명 코팅 흡수 분해(regspec-material §5): `아트250+무광코팅`→자재+⑤공정(무광 PROC_000015). 코팅=공정. |
| **신규 등록** | 봉제/보드/미싱 신규 공정(round-22 ⑤ 일부 진행·에폭시 PRD_000169 COMMIT·봉제↔부착 6 경로Y·신규 mint 3 BLOCKED). 캐스케이드 제약(GAP-MAT-4·constraints 빈칸). |
| **search-before-mint** | 신규 공정 코드행=PROC mint(정당·누락). 열재단 PROC_000084 등 기제안(heat-cut-process-proposal). param=prcs_dtl_opt JSON 슬롯(컬럼 재사용). 캐스케이드=constraints.logic JSONLogic(기존 그릇). |
| **FK 위상** | base_codes → proc(self-ref 부모 먼저) → product_processes. |
| **적재경로** | `pvEdit(prd_cd, processes)`. 신규 공정 코드는 `tcodbasecodes`/공정 마스터. |
| **영향분석** | MIS-LOADED 소수(봉제→부착 오연결 GP-C-06·코팅=자재 오적재 스티커 8상품·삼각대=자재→공정). |
| **컨펌** | AX-5(param 저장처)·AX-6(PUR)·AX-7(캐스케이드)·B-7(신규 공정). |

---

## 후속 회차 주의 (전 축)

1. **라이브 재실측 필수** — ⑤공정 84→102·②사이즈 510→520 진화. 후속 진단 착수 시 stale 위험.
2. **자재 축이동 수신 정합** — ②(29행)·print_side(14행)·⑤(코팅)·③(잉크색 AX-1)이 자재 보드 라우팅의 목적지. 등록 명세 시 수신분 FK 위상(본체 선적재 → 목적지 적재 → 오염 use_yn='N') 준수.
3. **추정 0** — 권위 침묵분은 가설+컨펌ID 분리.
