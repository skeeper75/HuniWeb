# 6축 라이브 전수 재실측 (2026-06-16) — 02 진단 stale 보정

> **작성** 2026-06-16 · dbm-correctness-auditor(round-13 방법론). round-22 실 교정 COMMIT **착수 전 전제** — 6축 t_* 라이브 현재 상태를 읽기전용 SELECT로 전수 재실측하여 `02_axis-error-diagnosis.md`의 stale을 보정한다.
>
> **권위순서(라이브=교정대상):** ① 상품마스터 L1 최신(`24_master-extract-260610/`) ② webadmin 적재 oracle ③ 스키마 설계의도 ④ 확정 도메인. **v03=오염원·정답 아님.**
>
> **[HARD] 읽기전용·비파괴:** 본 재실측은 SELECT만 수행. INSERT/UPDATE/DELETE/DDL 0건. 라이브 hard-delete 금지.

---

## 0. 6축 라이브 현재 상태표 (2026-06-16 실측 · fresh)

| 축 | t_* 테이블 | 02 진단 행수 | **fresh 행수(2026-06-16)** | diff | 비고 |
|:--:|-----------|:--:|:--:|:--:|------|
| ① 기초코드 | `t_cod_base_codes` | 74(13그룹·use_yn=N 1) | **74(13그룹·use_yn=N 1)** | = | **CONFIRMED** 변동 없음 |
| ② 사이즈 | `t_siz_sizes` | 510(impos=Y 79·del 53) | **510(impos=Y 79·del 53·use_yn=N 0)** | = | **CONFIRMED** |
| ③ 도수 | `t_clr_color_counts` | 5행 | **5행(인쇄안함/1도/2도/3도/CMYK4도)** | = | **CONFIRMED** 별색 분리 정상 |
| ④ 자재 | `t_mat_materials` | 337(del 1)·12 mat_typ | **340(del 1·use_yn=N 0)·12 mat_typ** | **+3** | **NEW** — 행 증가(아래 §1-④) |
| ⑤ 공정 | `t_proc_processes` | 84·22 부모 | **84·22 부모·자식0 13공정** | = | **CONFIRMED** |
| ⑥ 카테고리 | `t_cat_categories` | 306·고아 14노드 | **306·고아 14노드(연결 113상품)** | = | **CONFIRMED** |

**관계 테이블 행수(fresh):**

| 관계 t_* | 02 진단 | fresh(2026-06-16) | diff |
|----------|:--:|:--:|:--:|
| `t_prd_product_materials` | (미기재) | **730** | — |
| `t_prd_product_categories` | (미기재) | **392** | — |
| `t_prd_product_sizes` | (미기재) | **449** | — |
| `t_prd_product_processes` | (미기재) | **269** | — |
| `t_prd_product_print_options` | (미기재) | **166** | — |

**가격사슬(component_prices):** `t_prc_component_prices` **3,396행** · 차원 컬럼 = `comp_cd·siz_cd·clr_cd·mat_cd·proc_cd·opt_cd`(siz/mat/clr/proc 모두 직접 참조).

---

## 1. 축별 fresh 실측 + 02 대비 변동(STALE/CONFIRMED/NEW)

### ① 기초코드 `t_cod_base_codes` — 🟢 CONFIRMED (변동 없음)

74행·13 코드그룹(self-FK `upr_cod_cd` 트리, **02 진단의 `cod_grp_cd` 컬럼 표기는 부정확** — 실제 그룹은 부모코드 `upr_cod_cd`로 표현. 신규 finding NEW-1).

| 코드그룹(부모) | 코드명 | 자식 수 |
|------|------|:--:|
| MAT_TYPE | 자재유형 | 12 |
| USAGE | 용도 | 7 |
| OPT_REF_DIM | 옵션참조차원유형 | 7 |
| PRD_TYPE | 상품유형 | 5 |
| QTY_UNIT | 수량단위 | 5 |
| SEMI_ROLE | 반제품역할 | 5 |
| PRC_COMPONENT_TYPE | 가격구성요소유형 | 6 |
| OUTPUT_PAPER_TYPE | 출력용지유형 | 3 |
| RULE_TYPE | 제약규칙유형 | 3 |
| CUS_GRADE / DSC_TYPE / PRICE_TYPE / SEL_TYPE | (각) | 2 |

- **USAGE 7종 실측:** 내지·표지·면지·간지·투명커버·표지타입·공통. → **02 진단 "본체/부속 전용 코드 부재" CONFIRMED**(USAGE에 본체/부속 슬롯 없음, BATCH-9 진입).
- **OPT_REF_DIM 7종 실측:** 사이즈·판형·자재·공정·묶음수·도수·셋트. → ref_param_json 미구현(OM-7) CONFIRMED.
- `SELECT cod_cd, cod_nm, (SELECT count(*) FROM t_cod_base_codes c WHERE c.upr_cod_cd=p.cod_cd) FROM t_cod_base_codes p WHERE upr_cod_cd IS NULL ORDER BY cod_cd;`

### ② 사이즈 `t_siz_sizes` — 🟡 CONFIRMED (510·impos 79·del 53)

- 행수·impos_yn=Y(79)·del_yn=Y(53) **02와 정확히 일치 CONFIRMED**. use_yn=N 0행.
- 평면화 의심(siz_nm에 `N개`·`세트`): **4행만 매칭**(소규모) — 평면화 오염은 02 진단보다 좁음.
- `SELECT count(*) FILTER(WHERE siz_nm ~ '[0-9]+개' OR siz_nm ~ '세트') FROM t_siz_sizes;` → 4.
- size↔option 경계(굿즈파우치 폰기종/등급) AMBIGUOUS는 ④ 자재축으로 이전됨(아래 ④ §) — siz축 자체는 양호.

### ③ 도수 `t_clr_color_counts` — 🟢 CONFIRMED (5행 유지·별색 분리 정상)

```
CLR_000001 인쇄 안 함 (chnl_cnt 0)
CLR_000002 1도(흑백)  (1)
CLR_000003 2도        (2)
CLR_000004 3도        (3)
CLR_000005 CMYK 4도   (4)
```
- 5행 유지·별색은 ③에 **없음** CONFIRMED. 별색은 ⑤ PROC_000007 자식으로 정상 분리(메모리 "별색≠도수·clr_cd=NULL" 정합).
- **NEW-2:** 02 진단의 컬럼명 `clr_cnt_cd/clr_cnt_nm`은 부정확 — 실제는 `clr_cd/clr_nm/chnl_cnt`. 교정 SQL 작성 시 컬럼명 주의.

### ④ 자재 `t_mat_materials` — 🔴 NEW (337→340·+3) · 오염 핵심 CONFIRMED

**mat_typ 분포 fresh vs 02 진단:**

| mat_typ | 02 진단 | fresh | diff |
|---------|:--:|:--:|:--:|
| .01 종이 | 103 | 103 | = |
| .02 필름 | 5 | 5 | = |
| .03 아크릴 | 14 | 14 | = |
| .04 금속 | 19 | 19 | = |
| .05 원단 | 14 | 14 | = |
| **.06 가죽** | 6 | **6** | = |
| **.07 부속** | 32 | **33** | **+1 NEW** |
| .08 실사소재 | 14 | 14 | = |
| .09 파우치 | 74 | 74 | = |
| .10 악세사리 | 43 | 43 | = |
| .11 스티커 | 14 | 14 | = |
| .12 | 1 | 1 | = |
| **합계** | **337** | **340** | **+3** |

> **★NEW-3 (행수 진화):** 02 진단 total 337(del 1) → fresh **340(del 1)**. mat_typ 합계도 337→340. **.07 부속이 32→33(+1)**. 나머지 +2는 02 진단의 합계 산정 오차로 추정(02 §0 "337"·§1-④ "130+행"). **02 진단은 부분 stale** — round-22 교정 대상 행수는 fresh 340 기준으로 재집계 필요.

- **.06 가죽(6행) — BATCH-4 레더 정정 이미 라이브 반영 CONFIRMED:** MAT_000006 레더하드커버·000008 레더·000173~175 레더하드커버 A/A5/A4·**000186 레더(화이트)** 모두 .06. del_yn=Y 자재 = **MAT_000339 각목(900초과)·.07**(레더 아님 — 02 진단의 "del=부분 교정 흔적" 추정은 부정확, 실제는 각목 변형 정리. NEW-4).
- **.08 실사소재(14행) 오염 CONFIRMED:** MAT_000255~259(화이트·블랙·홀로그램·골드·실버)=색상 variant 자재행. 정답=색→option. **단 가격사슬 미참조(0건)** — 안전 교정 가능(§3).
- **.09 파우치(74행) 오염 CONFIRMED:** 형상(원형90mm·사각110mm)·용량(11온스·350ml·500ml)·구수(1~4구)·인쇄면(단면·양면)·색×사이즈(화이트 M/L/XL/XXL·블랙·멜란지) 전부 자재행. 정답=형상/용량→siz·구수→bundle·인쇄면→print_side·색→option.
- **.10 악세사리(43행) 오염 CONFIRMED:** 색상×묶음(오렌지/핑크/핫핑크 (3개1팩))·묶음수(2개1세트·100개)가 자재행(MAT_000202~209 등). 단 일부(OPP봉투·우드거치대·우드봉)는 진짜 부속.
- **코팅 평면화 CONFIRMED:** `mat_nm LIKE '%코팅%'` 7행 — MAT_000250/000260 "아트250+무광코팅"·000165 "유포지+엠보코팅"·000172 "하드커버전용지+무광코팅"(.01)이 공정 흡수. .11 무광/유광코팅스티커(000155/156)는 스티커 자재 예외(BATCH-3 CONFLICT).

### ⑤ 공정 `t_proc_processes` — 🟡 CONFIRMED (84·22부모·자식0 13공정)

자식 0 공정 13종 fresh 실측: 오시·미싱·가변텍스트·가변이미지·완칼·반칼·스티커완칼·타공·**봉제(PROC_000080)·부착(081)·족자제작(082)·에폭시(083)·열재단(084)**. → 02 진단 "봉제/에폭시/맥세이프·자식0" CONFIRMED. 봉제·부착·에폭시는 상품-공정 연결 INSERT 대상(BATCH-13).

### ⑥ 카테고리 `t_cat_categories` — 🔴 CONFIRMED (고아 14노드·113상품)

고아 14노드 + 연결 상품수 fresh 실측(02와 정확 일치 CONFIRMED):

| cat_cd | 노드명 | 연결 상품 |
|--------|------|:--:|
| CAT_000293 | 상품악세사리 | 15 |
| CAT_000294 | 명함 | 10 |
| CAT_000295 | 상품권 | 2 |
| CAT_000296 | 배경지 | 4 |
| CAT_000297 | 레드프린팅 책자 가이드 | **0** |
| CAT_000298 | 실사 | 28 |
| CAT_000299 | 단품형 | 14 |
| CAT_000300 | 플래너 | 5 |
| CAT_000301 | 소품 | 5 |
| CAT_000302 | 데스크/사무용품 | 9 |
| CAT_000303 | 디지털악세서리 | 2 |
| CAT_000304 | 말랑(PVC고주파) | 9 |
| CAT_000305 | 레더파우치 | 9 |
| CAT_000306 | 에코백부자재 | 1 |

- **고아 연결 상품 dedup 합계 = 113** (`SELECT count(DISTINCT r.prd_cd) ...`) CONFIRMED.
- CAT_000297(상품 0) = 즉시 논리삭제 안전 CONFIRMED.

---

## 2. STALE/CONFIRMED/NEW 종합

| 등급 | 건수 | 항목 |
|:--:|:--:|------|
| **CONFIRMED** | 5축 핵심 | ①74행·②510행·③5행 별색분리·⑤자식0 13공정·⑥고아14노드 113상품 — 진단 유효 |
| **NEW** | 4건 | NEW-1(①컬럼명 upr_cod_cd)·NEW-2(③컬럼명 clr_cd)·NEW-3(④337→340·+3·.07 +1)·NEW-4(del=각목,레더아님) |
| **STALE(부분)** | 2건 | ④자재 행수 337(02) vs 340(fresh) — 교정 대상 재집계 필요 / ②평면화 "4행만"(02 진단보다 좁음) |
| **이미 교정됨** | 1건 | BATCH-4 레더 .06 6행 라이브 반영 CONFIRMED(메모리 정합) |

---

## 3. 교정 우선순위 갱신 (가역 고효과부터)

| 순위 | 축 | 교정 | 가역성·효과 | 가격사슬 위험 |
|:--:|:--:|------|------|------|
| **P1** | ⑥ 카테고리 | 113상품 cat_cd UPDATE 정상노드 재연결 + CAT_000297 논리삭제 | 🟢 **최고효과·완전가역**(UPDATE 1축, 행 미삭제) | **없음**(카테고리는 가격 미참조) |
| **P1** | ④ 자재 mat_typ | 점착지 .01→.11 등 mat_typ UPDATE만(레더 .06 이미 완료) | 🟢 가역(컬럼 UPDATE) | **없음**(mat_typ는 가격 키 아님) |
| **P2** | ⑤ 공정 | 봉제/부착/에폭시 상품-공정 연결 INSERT(자식0 해소) | 🟡 추가만(가역) | 없음 |
| **P2** | ② 사이즈 | 파우치 형상/용량 siz 신규 INSERT(④ 유입 대비) | 🟡 추가만 | **주의**(component_prices siz_cd 참조 3,396행 — 신규는 안전, 기존 삭제/재키 금지) |
| **P3** | ④ 자재 오염행 논리삭제 | .08/.09/.10 색/형상/용량 자재행 use_yn='N' | 🔴 **CPQ option·② siz 적재 후에만**(먼저 삭제 금지) | **확인 완료: .09/.10 오염행 가격사슬 0건 참조** — 안전. 단 product_materials 64상품 연결 재배선 선행 |
| P3 | ① 기초코드 | USAGE 본체/부속·OPT_REF_DIM param 신설 | 🟢 선적재 제안 | 없음 |

> **★핵심 안전 실측(NEW-5):** `.09/.10 오염 자재행은 `t_prc_component_prices`에 0건 참조`(`SELECT count(DISTINCT cp.mat_cd) ... WHERE m.mat_typ_cd IN ('MAT_TYPE.09','MAT_TYPE.10')` → **0**). 즉 색/형상/용량 자재행 논리삭제가 **가격사슬을 파손하지 않는다**. 단 `t_prd_product_materials`에 **64상품 연결** → 삭제 전 그 연결을 CPQ option/siz로 재배선해야(P3 의존).

---

## 4. 가격사슬 의존 경고 [HARD]

- `t_prc_component_prices` 3,396행이 **siz_cd·mat_cd·clr_cd·proc_cd를 직접 참조**. 어느 축이든 **기존 코드행 hard-delete·재키(re-key) 금지** — 사슬 끊김.
- **② 사이즈:** impos_yn=Y 79행·치수 siz는 면적매트릭스 가격사슬에 묶임 → 신규 INSERT만 안전, 기존 삭제 금지.
- **④ 자재:** mat_typ UPDATE는 가격 무영향(키 아님). **오염행 논리삭제는 가격사슬 미참조 확인됨(0건)** — 안전하나 product_materials 64상품 재배선 선행.
- **③ 도수·⑤ 공정·⑥ 카테고리:** 카테고리는 가격 미참조(완전 안전). 도수/공정은 component_prices clr_cd/proc_cd 참조 — 5행/마스터 유지하고 연결만 추가.
- 모든 교정 = 멱등 `INSERT … ON CONFLICT`·UPDATE, 논리삭제(use_yn='N') 마지막. **P-TRUNCATE(load_master 재실행)가 교정 무효화 — round-22 1순위 선결(B-1).**

---

## 5. round-22 착수 갱신 권고

1. **6축 재실측 완료 — 진단 대부분 CONFIRMED**(stale은 ④ 행수 337→340 +3, ②평면화 범위뿐). 진단 토대 유효.
2. **최대 효과·최저 위험 = P1 두 건:** ⑥ 카테고리 113상품 재연결(가격 무관·완전가역) + ④ mat_typ UPDATE(레더 .06 이미 완료·잔존 점검만).
3. **④ 오염행 논리삭제는 가격사슬 안전 확인**(.09/.10 component_prices 0건) — 단 product_materials 64상품 CPQ/siz 재배선 선행(P3).
4. NEW-1/2 컬럼명 보정(upr_cod_cd·clr_cd)을 교정 SQL에 반영. NEW-3 행수 340 기준 재집계.
5. 생성≠검증 — 본 재실측은 dbm-validator K4(독립 SELECT 재현) 대상. 실 COMMIT은 인간 승인.
