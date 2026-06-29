# 하드커버책자072 내지(PRD_000284) 차원 충전 명세 — DIM-FILL (2026-06-29)

생성: dbm-option-mapper · 라이브 읽기전용 실측 + search-before-mint + DRY-RUN까지 · **DB 미적재**(실 COMMIT 인간 승인) · 권위[HARD]=상품마스터260610 booklet-l1·가격표260527 COMP_PAPER · 단가 verbatim(날조 0)

---

## 0. 배경 (Track B 후속 — 차원 충전 트랙)

- Track B(`hardcover072-inner-page-design-260629.md`)에서 **페이지가 공식 PRF_DGP_INNER**(COMP_PRINT_DIGITAL_S1 인쇄비 + COMP_PAPER 용지비) 바인딩까지 DRY-RUN 완료(ROLLBACK·미적재).
- 그러나 **PRD_000284에 차원이 전부 0개**(사이즈·출력판형·내지종이 자재·인쇄옵션 0) → 공식 바인딩만으론 plt_siz/mat 미선택 → 매칭 0 → **여전히 견적 0원**.
- 이 트랙 = **284 차원 충전**으로 종단 견적 가능화. Track B 공식/바인딩(SQL §1~3)은 본 SQL에 **함께 포함**(둘 다 미적재 상태 — 한 번에 충전하는 것이 깔끔).

---

## 1. 라이브 실측 — 현 상태(BLOCKED 가시화)

| 차원 | 284 현재 | 형제(101 포토북내지·095 엽서북내지·098 떡메내지) |
|---|---|---|
| 정체 | `PRD_000284 하드커버책자-내지` · prd_typ=PRD_TYPE.02(반제품) · use_yn Y·del_yn N | 동일 prd_typ.02 |
| t_prd_product_sizes | **0** | 전부 0 |
| t_prd_product_plate_sizes | **0** | 전부 0 |
| t_prd_product_materials | **0** | 전부 0 |
| t_prd_product_print_options | **0** | 전부 0 |
| t_prd_product_processes | **0** | 전부 0 |
| t_prd_product_price_formulas | **0** | 101=PRF_PHOTOBOOK_INNER · 095/098=0 |

→ **형제 내지(101/095/098)도 차원 전부 공백** = 책자류 내지 구성원 공통 미충전 상태. 101 포토북내지는 공식만 바인딩(차원 0)인데도 포토북식 .01 고정단가형이라 plt_siz/mat 무관하게 가격 산출 가능했음. **072 내지는 디지털 합가형(plt_siz/mat 의존)이라 차원 충전이 필수**(형제와 모델이 다름 — Track B §핵심판정).

### 072 세트(PRD_000072) 멤버십 (라이브 실측 — 284는 disp_seq2 내지 구성원)
```
PRD_000072 ← PRD_000073(표지)  disp_seq1  qty1
PRD_000072 ← PRD_000284(내지)  disp_seq2  qty1  min24/max300/incr2   ← 본 트랙 대상
PRD_000072 ← PRD_000074/075/076(면지 화이트/블랙/그레이)  disp_seq3~5
```

---

## 2. 권위 — 상품마스터 booklet-l1 (하드커버책자 row38·39)

| 속성 | A5 행 | A4 행 |
|---|---|---|
| 사이즈(필수) | **A5 (148 x 210 mm)** | **A4 (210 x 297 mm)** |
| 내지파일 재단사이즈 | 148 x 210 | 210 x 297 |
| 내지종이(필수) | **`*별도설정`** (손님 택N) | (A5와 동일 — ffill) |
| 내지인쇄(필수) | **단면** | **양면** |
| 내지페이지 | 24 ~ 300 / incr 2 | 24 ~ 300 / incr 2 |
| 출력파일 | PDF | PDF |

★ 077 레더하드커버·082 하드커버링·088 레더링바인더 내지도 **동일 패턴**(A5단면/A4양면·`*별도설정`·082/088은 page 8~100). §6 동형.

---

## 3. 충전 차원 명세 (search-before-mint — 전부 기존 코드 재사용·신규 mint 0)

### 3.1 사이즈 (t_prd_product_sizes) — 정본 A-시리즈 (중복본 금지)
권위=A5(단면)·A4(양면). 정본 A-시리즈[메모리 교훈 174/197/172/170/293]:

| siz_cd | siz_nm | 근거 | dflt_yn | disp_seq |
|---|---|---|---|---|
| **SIZ_000170** | A5(148x210mm) | 권위 A5·정본(중복 SIZ_000007 "A5 (148X210)" 회피) | Y | 1 |
| **SIZ_000172** | A4(210x297mm) | 권위 A4·정본(중복 SIZ_000050/258/520 회피) | N | 2 |

### 3.2 출력판형 (t_prd_product_plate_sizes) — 국4절 (디지털 출력용지규격)
016 프리미엄엽서·디지털 동형과 동일 plate. **신규 mint 0**(SIZ_000499 실재).

| siz_cd | siz_nm | dflt_plt_yn | output_paper_typ_cd | 근거 |
|---|---|---|---|---|
| **SIZ_000499** | 316x467 (국4절) | N | OUTPUT_PAPER_TYPE.01 | 016 plate_sizes verbatim·COMP_PAPER/COMP_PRINT_DIGITAL_S1 국4절 단가행 보유 |

> dflt_plt_yn=N = 016 라이브 패턴 그대로(엔진이 best-plate 매칭). 단일 plate이므로 N이어도 매칭됨.

### 3.3 내지종이 자재 (t_prd_product_materials) — `*별도설정` → 책자 내지 택N 목록
usage_cd=**USAGE.07**(016 내지종이 usage와 동일). `*별도설정`을 **책자 내지 표준 종이 8종**으로 구체화. **선택 기준 = ① 책자 내지 적합 경량지(모조/스노우/아트/몽블랑 100~130g) ② COMP_PAPER 국4절 단가행 보유(견적0 방지) — 8종 전부 보유 확인.**

| disp_seq | mat_cd | mat_nm | 국4절 절가(verbatim) | dflt_yn |
|---|---|---|---|---|
| 1 | **MAT_000072** | 백색모조지 100g | 30.73 | **Y** (라이브 probe 오라클 백색모조100g=기본·Track B §1.1) |
| 2 | MAT_000073 | 백색모조지 120g | 36.88 | N |
| 3 | MAT_000086 | 스노우지 100g | 30.57 | N |
| 4 | MAT_000087 | 스노우지 120g | 36.68 | N |
| 5 | MAT_000076 | 아트지 100g | 30.57 | N |
| 6 | MAT_000077 | 아트지 120g | 36.68 | N |
| 7 | MAT_000104 | 몽블랑 100g | 59.25 | N |
| 8 | MAT_000105 | 몽블랑 130g | 77.03 | N |

> ★ 8종 전부 COMP_PAPER 국4절 단가행 보유(라이브 확인) → **신규 단가행 mint 0** · 어느 종이를 골라도 견적>0.
> ★ **CONFIRM-INNER-PAPER**: `*별도설정` 실제 손님 노출 목록은 실무진 권위 미회신 — 본 8종은 "책자 내지 적합 경량지 + 국4절 단가행 보유" 도메인 기준 선별(보수적·견적0 방지). 실무진 회신 시 가감(추가/제거)은 후속.

### 3.4 인쇄옵션 (t_prd_product_print_options) — 단면+양면 (016 패턴)
권위: A5=단면·A4=양면. 인쇄옵션은 상품 단위(사이즈 조건부 아님)이므로 **둘 다 등록**(016 동일). 위젯/제약이 사이즈에 맞춰 선택. 기본=단면(A5 primary).

| opt_id | print_side | front_colrcnt_cd | back_colrcnt_cd | print_opt_cd | dflt_yn | disp_seq |
|---|---|---|---|---|---|---|
| 1 | 단면 | CLR_000005(컬러) | CLR_000001 | **POPT_000001** | **Y** | 1 |
| 2 | 양면 | CLR_000005 | CLR_000005 | **POPT_000002** | N | 2 |

> colrcnt 코드=016 print_opts verbatim. POPT_000001(단면)/POPT_000002(양면)은 t_prt_print_options 실재.

### 3.5 공정 (t_prd_product_processes)
- **충전 없음**(빈칸). 내지는 디지털 출력만 — 제본/코팅/박은 **세트 완제품(072) 또는 표지(073)**의 공정. 내지 구성원에 공정 부여 시 이중계상 위험. 내지=출력(인쇄+용지)만 = PRF_DGP_INNER 2 comp로 충분.

### 3.6 가격공식 (Track B 재포함)
- PRF_DGP_INNER 공식1 + formula_components2(COMP_PRINT_DIGITAL_S1·COMP_PAPER) + 284 바인딩1. 라이브 실측: PRF_DGP_INNER **미존재 확인**(Track B ROLLBACK) → 본 SQL이 신설.

---

## 4. FK 위상 적재 순서

```
(이미 존재) PRD_000284 · SIZ_000170/172/499 · MAT_000072/073/086/087/076/077/104/105 · POPT_000001/002 · COMP_* · PRF 부모
1. t_prc_price_formulas         PRF_DGP_INNER (공식 그릇)
2. t_prc_formula_components      PRF_DGP_INNER ← COMP_PRINT_DIGITAL_S1, COMP_PAPER
3. t_prd_product_sizes          284 ← SIZ_000170(A5·dflt), SIZ_000172(A4)
4. t_prd_product_plate_sizes    284 ← SIZ_000499(국4절)
5. t_prd_product_materials      284 ← MAT 8종(USAGE.07)
6. t_prd_product_print_options  284 ← POPT_000001(단면·dflt), POPT_000002(양면)
7. t_prd_product_price_formulas 284 ← PRF_DGP_INNER
```
전부 멱등 NOT EXISTS 가드. 모든 참조 코드 라이브 실재 확인(신규 mint 0).

---

## 5. 검증 — 충전 후 데이터-로직 입증

본 SQL은 **DRY-RUN(BEGIN/ROLLBACK)** — 미COMMIT 상태에선 엔진(simulate_set)이 충전분을 못 봄(트랜잭션 격리). 따라서:
- **DRY-RUN 검증**: INSERT 후 같은 트랜잭션 내 SELECT로 차원 행수 확인(sizes2·plate1·mat8·popt2·공식1·배선2·바인딩1).
- **post-COMMIT 검증**(인간 승인 후 별도): `sim.sim_meta('PRD_000072')`에 내지 차원(siz/plt/mat/popt) 노출 확인 → `sim.simulate_set('PRD_000072', copies, members=[{prd_cd:284, qty:총내지매수, selections:{siz_cd,plt_siz_cd,mat_cd,print_opt_cd}}])`로 내지 member 가격>0 확인.
  - 내지 member qty = `derive_inner_sheets(부수, page, pansu, sides)`(위젯/뷰 계약·Track B §4).

---

## 6. 077/082/088 동형 차원 충전 패턴

| 세트 | 내지 prd_cd | 사이즈 | 내지인쇄 | 페이지룰 | 차원 충전 |
|---|---|---|---|---|---|
| 072 하드커버책자 | PRD_000284 | A5(170)/A4(172) | 단면/양면 | 24~300/2 | **본 트랙** |
| 077 레더하드커버 | (내지 멤버 확인 필요) | A5(170)/A4(172) | 단면/양면 | 24~300/2 | 072 SQL의 prd_cd만 교체·**plt 국4절·종이8종·POPT 동일** |
| 082 하드커버링책자 | (내지 멤버 확인 필요) | A5(170)/A4(172) | 단면/양면 | **8~100/2** | 페이지룰만 다름(세트 min/max는 t_prd_product_sets — 본 트랙 무관)·차원 동일 |
| 088 레더링바인더 | (내지 멤버 확인 필요) | A5(170)/A4(172) | 단면/양면 | 8~100/2 | 082 동형 |

> **동형 공유**: 공식 PRF_DGP_INNER + 출력판형 SIZ_000499 + 내지종이 8종 + POPT 단면/양면은 **4 세트 전부 공통**. 각 세트의 내지 prd_cd만 교체. 단 077/082/088 내지 구성원 prd_cd는 라이브 set 멤버십 추가 실측 필요(072=284 확정). 082/088은 page 8~100(세트 t_prd_product_sets min/max·차원 충전과 별개).

---

## 7. BLOCKED / 인간 승인 필요 / C트랙

| ID | 사안 | 상태 |
|---|---|---|
| **CONFIRM-INNER-PAPER** | `*별도설정` 손님 노출 종이 정확 목록 — 본 8종은 도메인 선별(견적0 방지·보수적). 실무진 권위 회신 시 가감 | 인간 승인·후속 |
| **IMPO-INNER** | A5 국4절 임포지션(up수·판걸이수) fn_calc_pansu가 격자(Track B §1.1)와 일치하는지 | C트랙·post-COMMIT 골든 |
| **ROUND-INNER** | 금액 rounding(절사/반올림 자릿수) | C트랙·골든 실측 |
| **A4 양면 verbatim** | A4(172)+양면(POPT_000002)의 가격 격자 — Track B 격자는 A5 단면 위주. A4 양면 검증 | post-COMMIT 골든 |
| **077/082/088 내지 멤버 실측** | 동형 전파 전 각 세트 내지 구성원 prd_cd 라이브 확인 | 후속 트랙 |

---

## 8. 안전 / 위상
- 라이브 읽기전용 SELECT + DRY-RUN(BEGIN/ROLLBACK)만. 실 COMMIT/DDL·webadmin 코드수정 0. git 0.
- 신규 mint 0(사이즈/판형/자재/인쇄옵션/단가행 전부 재사용). 정본 siz_cd(170/172) 사용·중복본 회피.
- 권위 엑셀 절대(booklet-l1 row38/39). 내지종이 8종=`*별도설정` 도메인 선별(CONFIRM-INNER-PAPER 명시·과신 금지).
- 단가=COMP_PAPER 30.73 등 라이브 verbatim(날조 0).
