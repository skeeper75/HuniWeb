# 하드커버책자072 내지(PRD_000284) 디지털인쇄 페이지가 설계 — Track B (2026-06-29)

생성: hpe-engine-designer · 읽기전용 분석 + 라이브 실측 + codex high 독립 교차 · **DB 미적재**(DRY-RUN까지·실 COMMIT은 인간 승인) · 권위[HARD]=가격표260527 booklet·상품마스터260610 · 이전사이트=보강 오라클 · 단가 verbatim(날조 0)

---

## ★★ 핵심 판정 (directive 기대와 다름 — 정직 보고)

> directive는 "포토북 내지 동형(추가2P당 고정 단가형 .01)"을 기대했으나, **072 내지는 포토북과 본질적으로 다른 모델**이다. 분석·codex 교차 결과 **포토북식 단순 단가형으로는 verbatim 재현 불가**이며, **디지털인쇄 합가형(용지비 + 인쇄비, 출력매수/판수 기준)** 이 정답 모델이다.

| | 포토북 내지(101·COMMIT됨) | 하드커버072 내지(284) |
|---|---|---|
| 내지종이 | **1종 고정**(몽블랑130) | **여러 종이 선택**(`*별도설정`·백색모조 등) |
| 수량할인 | **없음**(per-2page 고정) | **있음 72~73%**(per-book q1=12,400 → q100/book=3,531) |
| 가격축 | 사이즈별 추가2P당 고정 | 페이지수 × 부수 × 출력매수 → 판수밴드+용지비 |
| 표현 모델 | 단가형 .01(고정) | **디지털 합가형**(용지비 절가×출력매수 + 인쇄비 판수밴드×판수) |
| 엔진 표현 | 가능(우회) | 가능(`derive_inner_sheets`+`plate_qty` 존재) **단 차원 충전 선결** |

**왜 포토북식이 불가한가 [HARD 입증]**: 포토북식 .01 고정단가형이면 per-book(책 1권당 내지가)가 부수와 무관해야 한다. 그러나 라이브 실측 내지 per-book가 page30에서 `q1=12,400 → q10=7,740 → q100=3,531`로 **수량할인 72%**가 존재한다. 고정 단가형으로는 이 수량할인을 담을 수 없다(증명: §1.2).

---

## 0. 한눈 요약

| 항목 | 값 |
|---|---|
| 대상 | PRD_000284 하드커버책자-내지(반제품 PRD_TYPE.02·세트 072의 disp_seq2 구성원·min_cnt24/max300/incr2=페이지) |
| 현 상태 | **가격요소 완전 공백** — 출력판형0·자재0·사이즈0·인쇄옵션0·공식0 → 견적 0원 |
| 정답 모델 | **디지털인쇄 합가형 B** = COMP_PAPER(내지종이 절가×출력매수) + COMP_PRINT_DIGITAL_S1(판수밴드×판수) |
| 엔진 능력 | ✅ `derive_inner_sheets(copies,pages,pansu,sides)`(pricing.py:820)·`plate_qty(qty,pansu)`(:215)·`fn_calc_pansu` DB함수 = 출력매수/판수 앱계산 **이미 존재** |
| 위젯 계약 | 내지 member qty = `derive_inner_sheets(부수, page, pansu)` = 부수×⌈page/(판걸이수×면수)⌉ (뷰/위젯이 산출해 전달) |
| **선결(BLOCKED)** | 내지 출력판형(국4절 등 plt_siz)·내지종이 자재·내지사이즈·인쇄옵션 **차원 충전 = dbmap 트랙**·인간 승인 |
| 이 SQL이 하는 것 | 공식 바인딩(PRF_DGP_INNER) + 내지종이 COMP_PAPER 단가행 검증 + formula_components. **차원 충전 후라야 견적 산출** |
| DRY-RUN | BEGIN/ROLLBACK·멱등·PK충돌0 (단가행은 COMP_PAPER 기존 verbatim 재사용·신규 mint 최소) |
| codex high | **수렴(divergence 0)** — A 탈락·B 정답·inferred print unit(N=300→345≈밴드350) 디지털밴드 일치 입증 |

---

## 1. 권위·라이브 실측 — 내지 가격구조 분해

### 1.1 라이브 이전사이트 내지(p01) 격자 (pcode=40·A4세로·백색모조100g·gstack 읽기전용)
출처: `hc072-cover-probe-260629.csv` §내지 격자. ASP가 `price_01`=내지 분해 노출.

| page \ qty | qty1 | qty10 | qty100 |
|---|---|---|---|
| page30 | 12,400 | 77,400 | 353,100 |
| page60 | 21,500 | 112,700 | 586,200 |
| page100 | 35,800 | 147,700 | 977,000 |

### 1.2 ★포토북식 단순 단가형 불가 — 수량할인 입증 [HARD]
per-book(÷qty):

| page | q1 | q10/book | q100/book | 수량할인 |
|---|---|---|---|---|
| 30 | 12,400 | 7,740 | 3,531 | **72%** |
| 60 | 21,500 | 11,270 | 5,862 | **73%** |
| 100 | 35,800 | 14,770 | 9,770 | **73%** |

→ 포토북식(.01 고정단가)이면 per-book가 부수 무관해야 함. 실제 72~73% 수량할인 → **A(포토북 동형) 탈락 확정**.

### 1.3 디지털 합가형 재구성 (codex high inferred print unit)
A4 2up 국4절 가정 → 출력매수 N = page × qty / 2. 용지비(N×30.73) 빼고 N으로 나눈 inferred 인쇄단가:

| page/qty | N(출력매수) | inferred 인쇄단가 | 라이브 디지털밴드 |
|---|---|---|---|
| 60p q10 | 300 | ~345 | 밴드 N300=270... (근접) |
| 100p q10 | 500 | ~265 | 밴드 N500≈270 (근접) |

→ inferred 인쇄단가가 디지털인쇄 판수밴드(`500/350/270/...`) 흐름과 **근접 일치**(codex). **B(디지털 합가형) = 정답 모델**. 단 정확 verbatim엔 임포지션(up수)·rounding·전체 밴드 추가 확정 필요(§5).

### 1.4 권위 가격표 booklet 구조 (price-table-formula-structure-map.md §책자)
- 책자 = 세트조합(제본합산): **내지인쇄(합가) + 표지(합가) + 제본[13] + 면지**.
- ★내지인쇄 = **"합가"**(L1 디지털인쇄비+용지비를 페이지×수량으로 합산) — 포토북식 단순 단가표 아님. 권위 구조 자체가 디지털 합가형을 가리킴.

---

## 2. 디지털 합가형 설계 (search-before-mint)

### 2.1 재사용 우선 — 기존 디지털 그릇 활용

| 빌딩블록 | 재사용? | 처리 |
|---|---|---|
| 인쇄비 COMP_PRINT_DIGITAL_S1 (판수밴드·use_dims=[proc_cd,plt_siz_cd,print_opt_cd,min_qty]) | ✅ 재사용 | 내지인쇄=단면 → S1. 국4절 plt_siz·POPT_000001(단면) 단가행 기존 실재 |
| 용지비 COMP_PAPER (절가·use_dims=[plt_siz_cd,mat_cd]) | ✅ 재사용 | 내지종이 mat_cd(백색모조100g=MAT_000072 등)·국4절 plt_siz. **백색모조100g 국4절 단가행=30.73 실재**(verbatim) |
| 디지털 합가 공식 PRF_DGP_A | △ 재사용 가능하나 과다 comp | A는 귀돌이/오시/미싱/가변텍스트 7+comp. 내지엔 인쇄+용지만 → **슬림 내지 공식 신규(PRF_DGP_INNER) 권장** |
| 출력매수 앱계산 derive_inner_sheets | ✅ 엔진 기존 | 위젯/뷰가 호출(코드 외부 계약) |

★ **search-before-mint 결론**: 단가행·구성요소(COMP_PAPER·COMP_PRINT_DIGITAL_S1)·앱계산 로직 **전부 재사용**. 신규 mint는 **슬림 내지 공식 1개(PRF_DGP_INNER)** 또는 PRF_DGP_A 직접 바인딩 중 택. 신규 단가행은 **내지종이 중 라이브에 없는 종이만**(백색모조100g은 30.73 실재 → 0 mint).

### 2.2 슬림 내지 공식 vs PRF_DGP_A 직접 바인딩 (트레이드오프)

| | (a) PRF_DGP_A 직접 바인딩 | **(b) PRF_DGP_INNER 슬림 신규 (권장)** |
|---|---|---|
| 신규 mint | 0(공식 재사용) | 공식1+formula_components2 |
| comp 노이즈 | 귀돌이·오시·미싱·가변 등 미선택 시 자동 제외(addtn_yn) — 안전하나 시뮬 meta 혼탁 | 인쇄비+용지비만 = 깔끔·내지 의미 명확 |
| 의미 정합 | "엽서·상품권" 공식을 책 내지에 = 의미 부정합 | "책자 내지" 전용 = 명확 |
| 채택 | 폴백 | **권장**(의미 명확·시뮬 입력축 최소) |

→ **본 설계 = (b) PRF_DGP_INNER**(인쇄비 S1 + 용지비 COMP_PAPER 2 comp). 단가행은 둘 다 기존 재사용.

### 2.3 공식 구조 (PRF_DGP_INNER)
```
PRF_DGP_INNER  "디지털인쇄 책자 내지(인쇄비+용지비·출력매수 기준)"
  disp_seq 1: COMP_PRINT_DIGITAL_S1  addtn_yn Y  (인쇄비·판수밴드×판수·use_dims plt_siz_cd 기존)
  disp_seq 2: COMP_PAPER             addtn_yn Y  (용지비·절가×출력매수·use_dims [plt_siz_cd,mat_cd] 기존)
  바인딩: PRD_000284 ← PRF_DGP_INNER
```
- 엔진: 내지 member qty(=총내지매수 derive_inner_sheets)로 evaluate_price 호출.
- COMP_PRINT_DIGITAL_S1은 plt_siz_cd 차원 → 엔진이 `plate_qty(qty, pansu)`로 판수 재환산(국4절 판걸이수). COMP_PAPER는 출력매수 그대로 절가×qty.

---

## 3. ★선결 차원 충전 (BLOCKED-INNER-DIM·dbmap 트랙)

디지털 합가형이 **견적을 산출하려면** 284에 아래 차원이 충전돼야 한다(현재 전부 0개·이 가격설계로 불가·dbmap 위임):

| 차원 | 현재 | 필요 | 권위 |
|---|---|---|---|
| 출력판형 plt_siz | 0 | 국4절(SIZ_000499) 등 내지 출력용지규격 | 상품마스터 내지파일사양·디지털 동형 |
| 내지종이 자재 mat_cd | 0 | 백색모조100g(MAT_000072)·120g·기타 `*별도설정` 목록 | 가격표 booklet 내지종이 컬럼 |
| 내지사이즈 siz_cd | 0 | A5·A4(완제 사이즈·판걸이수 fn_calc_pansu 인자) | 상품마스터 사이즈 |
| 인쇄옵션 print_opt | 0 | 단면(POPT_000001)·양면 | 상품마스터 내지인쇄(단면) |
| COMP_PAPER 단가행 | 백색모조100g 국4절=30.73 ✅ | `*별도설정` 다른 종이의 국4절 절가 | 가격표 디지털 종이비 verbatim |

→ **이 가격설계(SQL)는 공식+배선+바인딩만**. 차원 충전 없이 바인딩만 COMMIT하면 여전히 0원(plt_siz/mat 미선택 → 매칭0). **차원 충전(dbmap)이 선결**.

---

## 4. 위젯/엔진 계약 (OI-INNER)

- 내지 member qty = `derive_inner_sheets(부수, page, pansu, sides)` = 부수 × ⌈page / (판걸이수 × 면수)⌉.
  - pansu = fn_calc_pansu(국4절 plt_siz, 내지 siz_cd) — 뷰 레이어가 DB 함수 호출(pricing.py:815 주석).
  - sides = 내지인쇄 면수(단면1). page=면(쪽).
- evaluate_set_price가 내지 구성원을 `selections={siz_cd, plt_siz_cd, mat_cd(내지종이), print_opt_cd}`, qty=총내지매수로 호출.
- page≤24(기본) 처리: 포토북과 달리 072 내지는 **전 페이지가 유료**(기본24P 무료 개념 없음 — 가격표 booklet에 "기본Np 포함" 컬럼 부재·내지 전량 디지털 출력). page는 min_cnt24~max300 자체가 전량 과금. (포토북의 "기본24P+추가2P" 2-레이어와 **다름** — 072는 단일 레이어 디지털 합가).

---

## 5. verbatim 정확성 잔여 (C트랙·컨펌큐)

| ID | 사안 | 라우팅 |
|---|---|---|
| **DIM-INNER** | 내지 plt_siz·자재·사이즈·인쇄옵션 차원 충전 + `*별도설정` 종이별 COMP_PAPER 단가행 | dbmap·인간 승인 |
| **IMPO-INNER** | 임포지션(A4 국4절 2up?)·면수·낱장 반올림 — fn_calc_pansu 판걸이수가 격자와 일치하는지 | 라이브 fn_calc_pansu 실측 + C트랙 |
| **ROUND-INNER** | 금액 rounding(1/10/100원 절사·반올림) | C트랙·골든 실측 |
| **BAND-FULL** | 디지털인쇄비 전체 판수밴드 + band 선택규칙(floor/ceil) | 기존 단가행 재사용(검증만) |
| **CONFIRM-INNER-PAPER** | `*별도설정` 내지종이 목록·각 종이 국4절 절가 권위 추출 | authority·실무진 |

→ 본 설계는 **모델 방향(디지털 합가형 B) 확정 + 공식/배선 설계 + 재사용 입증**까지. **verbatim 견적 산출은 차원 충전(dbmap) + 임포지션/rounding C트랙 확정 후** post-COMMIT 골든 검증(simulate_set).

### 5.1 DRY-RUN 실행 결과 (psql -f · RC=0 · ROLLBACK)
`hardcover072-inner-260629-dryrun.sql` 실측:
- 재사용 단가행 확인: 인쇄비(국4절 단면)=53행 · 용지비(백모조100g 국4절)=1행(=30.73) — **신규 단가행 0**.
- BLOCKED 차원 스냅샷: 284 출력판형0·내지종이0·사이즈0 (= 차원 미충전 = 견적 선결 조건 가시화).
- INSERT: INNER공식1 · 배선2(인쇄+용지) · 284바인딩1 → 검증 SELECT 1/2/1 정확.
- **멱등 검증**: INSERT 블록 2회 → 1차 `INSERT 0 1`×4 · 2차 `INSERT 0 0`×4(NOT EXISTS 가드) · PK충돌0.
- 최종 ROLLBACK(라이브 무변경).

---

## 6. 077/082/088 동형 전파
- **077 레더하드커버·082 하드커버링·088 레더링바인더 내지도 전부 동일 디지털 합가형**(booklet-l1: 내지종이=`*별도설정`·페이지룰 24~300/2 또는 8~100/2). PRF_DGP_INNER 공유 바인딩 + 각 내지 prd_cd 차원 충전으로 동형 전파 가능(082 링책자는 page 8~100·incr2). 표지/제본은 각 세트공식 별도(072 표지+제본 선례).

---

## 7. 안전 / 위상
- 라이브 읽기전용 SELECT + DRY-RUN(BEGIN/ROLLBACK)만. 실 COMMIT/DDL·webadmin 코드수정 0. git 0.
- 권위 엑셀 절대. 내지 격자=이전사이트 보강 오라클(probe csv 명시·과신 금지·CONFIRM-INNER-PAPER). 단가=COMP_PAPER 30.73 등 verbatim(날조 0).
- ★directive 기대(포토북 동형)와 실제(디지털 합가형) 불일치를 정직 보고 — relitigate 아닌 모델 정정.
- 미상(임포지션·rounding·`*별도설정` 종이목록)=BLOCKED/C트랙 명시.
