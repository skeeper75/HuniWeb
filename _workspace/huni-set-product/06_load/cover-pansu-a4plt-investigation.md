# 072 하드커버책자 표지 돈 CONFIRM 2건 심층조사 — 표지 출력매수(판수) 차원 · A4 표지 3절 절가

생성: hsp-set-designer · 2026-06-25 · 라이브 읽기전용 SELECT(fn_calc_pansu 함수정의·t_siz_sizes·t_prc_component_prices·t_prc_price_components·t_mat_materials) + 가격표(260527 판걸이수/출력소재 원셀) + 상품마스터(260610 booklet-l1) + webadmin pricing.py 코드 실측 · **단가/판수 verbatim·날조 0** · **DB 미적재**(COMMIT/INSERT/DDL 0·설계까지만)

> 대상: **CFM-HC-COVER-PANSU**(표지 출력매수 차원·돈 크리티컬)·**CFM-COVER-A4PLT**(A4 표지 3절 절가행)
> 결론 한 줄: ① 표지 출력매수의 **돈 결함을 코드에서 확증**(evaluate_price가 완제 siz_cd로 pansu 계산 → 하드커버 표지에선 출력매수 과소 → 표지 3비목 과소청구) ② **A4 표지 3절 절가는 가격표 verbatim 확보(아트150 3절=89.54)·라이브 단가행은 부재 = BLOCKED** ③ A5(국4절)는 바인딩 가능·**A4(3절)는 절가행 적재 + 표지 펼침 사이즈코드 신설 전까지 BLOCKED**

---

## ★0. 결론 요약 (한눈에)

| 질문 | 규명 결과 | 상태 |
|---|---|---|
| **fn_calc_pansu 로직?** | `(p_plate_siz_cd, p_item_siz_cd)` → 판형 작업영역(work−margin) ÷ 아이템 작업사이즈, 정상/90°회전 중 큰 n-up. 라이브 함수정의 verbatim 확보 | 🟢 규명 |
| **게이트가 본 `fn_calc_pansu('SIZ_000499','SIZ_000170')=4`?** | 국4절(작업영역 306×457) × **완제 A5(148×210)** = 4-up. **완제 사이즈** 기준 계산(표지 펼침 아님) | 🟢 규명 |
| **표지 출력매수의 정합 기준?** | 하드커버 표지는 **펼침면(390×268 A5/532×355 A4)**을 출력. 펼침을 국4절에 넣으면 **1-up**(rotate=1·normal=0), A4 532×355는 3절에 1-up | 🟢 규명 |
| **돈 결함 실재?** | 🔴 **실재(코드 확증)**. evaluate_price는 fn_calc_pansu에 `selections.siz_cd`(완제 A5)를 넣음 → 표지 3비목(인쇄·코팅·용지)이 **pansu=4**를 받아 출력매수 ⌈50/4⌉=**13판**. 표지 실제 출력매수=**50판**(펼침 1-up) → **약 4배 과소청구** | 🔴 돈 크리티컬 |
| **표지 펼침 사이즈코드 라이브 존재?** | ❌ **부재**(390×268·532×355 = work/cut 0행). selections.siz_cd로 줄 표지 펼침 코드 자체가 미등록 | 🔴 신설 필요 |
| **A4 표지 3절 절가 존재?** | 🟡 **가격표 verbatim 존재**(아트지150g(3절) row51 = **89.54**·전지 4×6(1091×788)·연당 134310) · 🔴 **라이브 COMP_PAPER 단가행 0**(MAT_000083 = 0행) = **BLOCKED** | 🟡/🔴 |
| **국4절 절가(A5)는?** | 🟢 라이브 존재(MAT_000078·SIZ_000499·**46.65**·56자재 전부 국4절 1행 모델) | 🟢 READY |
| **072 바인딩 가능 사이즈 범위?** | **A5만 조건부 가능**(국4절 절가 있음·단 표지 펼침 pansu 정합 선결)·**A4는 BLOCKED**(3절 절가행 부재 + 표지 펼침 코드 부재) | 🟡 |

---

## 1. CFM-HC-COVER-PANSU — fn_calc_pansu 로직 + 표지 출력매수 정합 (돈 크리티컬)

### 1.1 fn_calc_pansu 라이브 함수정의 (verbatim·읽기전용)

```sql
-- pg_get_functiondef(fn_calc_pansu) 2026-06-25 실측
CREATE OR REPLACE FUNCTION public.fn_calc_pansu(
    p_plate_siz_cd varchar,   -- 판형(출력판형) 사이즈코드
    p_item_siz_cd  varchar)   -- 아이템(출력할 한 장) 사이즈코드
RETURNS integer LANGUAGE plpgsql STABLE AS $$
DECLARE pw,ph numeric;  -- 판 실제영역(작업 − 여백)
        iw,ih numeric;  -- 아이템 작업사이즈(여분포함)
        n_normal, n_rotate integer;
BEGIN
  -- 판형: work − margin(4방) = 인쇄 실제영역
  SELECT work_width  - COALESCE(margin_lft,0) - COALESCE(margin_rgt,0),
         work_height - COALESCE(margin_top,0) - COALESCE(margin_bot,0)
    INTO pw,ph FROM t_siz_sizes WHERE siz_cd = p_plate_siz_cd;
  -- 아이템: work(여분포함) = 한 장이 차지하는 자리
  SELECT work_width, work_height INTO iw,ih FROM t_siz_sizes WHERE siz_cd = p_item_siz_cd;
  IF (치수 NULL/≤0) THEN RETURN NULL; END IF;   -- 계산불가
  n_normal := floor(pw/iw) * floor(ph/ih);       -- 정상 배치
  n_rotate := floor(pw/ih) * floor(ph/iw);       -- 90° 회전 배치
  RETURN GREATEST(n_normal, n_rotate);           -- 더 많이 앉는 쪽
END; $$
```

- ★**인자 의미**: `p_plate_siz_cd`=출력판형(국4절 등), `p_item_siz_cd`=**출력할 한 장(아이템)의 작업사이즈**. 판수=한 판에 앉는 아이템 개수.
- ★**계산은 work·margin 실측**: 판형은 work−margin(인쇄 실제영역), 아이템은 work(여분포함). 두 사이즈코드의 `t_siz_sizes` 치수가 있어야 동작(없으면 NULL=계산불가).

### 1.2 게이트가 본 `fn_calc_pansu('SIZ_000499','SIZ_000170')=4`의 의미 (실측 재현)

라이브 치수(verbatim):

| siz_cd | siz_nm | work_w | work_h | margin(4방) | 실제영역 |
|---|---|---|---|---|---|
| SIZ_000499 | 316x467(국4절) | 316 | 467 | 5/5/5/5 | **306 × 457** |
| SIZ_000170 | A5(148x210mm) | 148 | 210 | 0 | 148 × 210 |
| SIZ_000475 | 330x660(3절) | 330 | 660 | 5/5/5/5 | 320 × 650 |

- `fn_calc_pansu('SIZ_000499','SIZ_000170')`: normal=⌊306/148⌋×⌊457/210⌋=2×2=**4** · rotate=⌊306/210⌋×⌊457/148⌋=1×3=3 → GREATEST=**4**.
- ★즉 이 값은 **완제 A5(148×210)를 국4절에 4-up** 한 것 = **완제품 사이즈 기준**. **표지 펼침면(390×268)을 넣은 게 아니다.** ← 결함의 진원.

### 1.3 표지 출력매수의 권위 = 표지 펼침면 (판걸이수 시트 verbatim)

가격표 260527 **판걸이수 시트** 원셀 실측(read_only·data_only):

| row | 사이즈옵션명 | 재단사이즈(=표지펼침) | 블리드 | 디지털인쇄(국4절) | 디지털인쇄(3절) | 판걸이(F열) |
|---|---|---|---|---|---|---|
| 64 | 하드커버무선책자 A5 | **390x268** | 0 | **316x467** | — | (공란) |
| 65 | 하드커버무선책자 A4 | **532x355** | 0 | — | **330x660** | (공란) |

- ★표지의 "출력할 한 장"은 **완제 A5(148×210)가 아니라 펼침면(390×268)** = 앞표지+책등+뒤표지가 펼쳐진 한 장. A5/A4는 **완제 책 사이즈**일 뿐, 표지는 그 2배+책등을 펼쳐 1장으로 출력.
- 상품마스터 booklet-l1 권위: 072 하드커버책자 표지작업사이즈 = **`*책등에따라다름`**(병합셀·고정값 없음) → 판걸이수 시트 r64/r65가 표지 출력 사이즈의 1차 권위.
- 판걸이(F) 공란 = 표지는 정수 판걸이 미기입(펼침 1장=1판 의도 또는 fn_calc_pansu 런타임 계산 의도). 블리드 0 = 재단사이즈가 곧 출력 한 장 크기.

### 1.4 표지 펼침을 판형에 fn_calc_pansu 시뮬레이션 (돈영향 산정)

```
A5 표지펼침 390x268 on 국4절 실제영역 306x457:
   normal=⌊306/390⌋×⌊457/268⌋ = 0×1 = 0
   rotate=⌊306/268⌋×⌊457/390⌋ = 1×1 = 1   → pansu = 1  (정확히 1-up)
A4 표지펼침 532x355 on 3절 실제영역 320x650:
   normal=⌊320/532⌋×⌊650/355⌋ = 0×1 = 0
   rotate=⌊320/355⌋×⌊650/532⌋ = 0×1 = 0   → pansu = 0  (★3절에 안 들어감·아래 §1.6)
```

- ★A5 표지: 펼침 390×268은 국4절에 **1-up**(회전). 즉 표지 출력매수 = ⌈주문수량 ÷ 1⌉ = **주문수량 그대로**.

### 1.5 돈 결함 확증 — evaluate_price가 표지 출력매수를 과소 계산 (코드 실측)

webadmin `catalog/pricing.py` _evaluate_formula (line 559~581) verbatim:

```python
needs_plate = any("plt_siz_cd" in (c["comp_cd__use_dims"] or []) for c in comps)
plate    = selections.get("plt_siz_cd")   # 출력판형
item_siz = selections.get("siz_cd")        # ★완제품 사이즈(= A5 SIZ_000170)
pansu    = _calc_pansu(plate, item_siz)     # fn_calc_pansu(판형, 완제품)
...
if "plt_siz_cd" in non_qty:
    pq = plate_qty(qty, pansu)              # ⌈주문수량 ÷ pansu⌉
    comp_qty = pq
```

- ★**코드는 fn_calc_pansu에 `selections.siz_cd`(완제품 사이즈)를 무조건 넣는다.** 표지 비목도 예외 없음.
- 표지 3비목 use_dims 라이브 실측 — **셋 다 plt_siz_cd 포함** = 전부 판수 환산 대상:

  | comp_cd | comp_nm | use_dims |
  |---|---|---|
  | COMP_PAPER | 용지비(종이별 절가) | `["plt_siz_cd","mat_cd"]` |
  | COMP_COAT_MATTE | 무광코팅비 | `["proc_cd","plt_siz_cd","coat_side_cnt","min_qty","proc_grp:PROC_000013"]` |
  | COMP_PRINT_DIGITAL_S1 | 디지털인쇄비 | `["proc_cd","plt_siz_cd","print_opt_cd","min_qty","proc_grp:PROC_000001"]` |

- **결함 폭 (A5·50권 케이스)**:
  - 코드 현재: pansu=fn_calc_pansu(국4절, 완제A5)=**4** → 표지 출력매수=⌈50/4⌉=**13판**
  - 정합(표지 펼침): pansu=fn_calc_pansu(국4절, 표지펼침390x268)=**1** → 표지 출력매수=⌈50/1⌉=**50판**
  - → 표지인쇄·표지코팅·표지용지비가 **13/50 ≈ 0.26배**로 청구 = **약 3.8배 과소청구**(돈 크리티컬). 게이트 골든 부분합 470,106(pansu=4) vs 499,832(pansu=1) 차이의 진원.

### 1.6 정합 주입 명세 — 표지 비목에 올바른 siz_cd/plt_siz_cd

evaluate_price가 표지 출력매수를 옳게 받으려면 **selections에 표지 펼침 사이즈코드**가 들어가야 한다. 그러나 현 코드는 `item_siz = selections.get("siz_cd")` **단일 완제 사이즈만** fn_calc_pansu에 넣으므로, 같은 공식 안에서 내지(완제 A5)와 표지(펼침)가 **다른 item_siz를 쓸 수 없다**(상품당 pansu 1회 계산·line 564).

| 정합 경로 | 내용 | 트랙 |
|---|---|---|
| **경로 A — 표지 펼침 사이즈코드 신설 + comp별 siz_cd 분리** | ① t_siz_sizes에 표지펼침 390×268(A5)·532×355(A4) 신설 ② evaluate_price가 표지 comp는 표지펼침 siz_cd로, 내지 comp는 완제 siz_cd로 fn_calc_pansu 호출하도록 **comp별 item_siz 분기** 필요 | DDL(siz 신설=dbmap) + 코드(pricing.py=webadmin 별도·본 하네스 밖) |
| **경로 B — 표지 comp의 plt_siz_cd 환산을 우회**(표지는 펼침 1-up 고정) | 표지 펼침이 국4절/3절에 항상 1-up이면, 표지 비목 출력매수=주문수량(권 수)로 직결. comp use_dims에서 plt_siz_cd 제거하거나 표지 전용 comp로 분리 | 설계 결정 필요·코드 영향 |
| **현 모델로는** | selections.siz_cd 단일값으로 표지/내지 동일 pansu 적용 → 표지 과소청구 **불가피** | 🔴 결함 |

- ★**핵심 정합 결론**: 하드커버 표지 비목은 plt_siz_cd 판수 환산을 **완제 siz_cd로 하면 항상 과소청구**. selections에 줘야 할 표지 item_siz = **표지 펼침 사이즈코드**(390×268/532×355)이며, 이 코드는 **라이브 미등록**(신설 선결). 또한 evaluate_price의 단일 pansu 모델로는 표지/내지 분리 불가 → 코드 변경 or 표지 전용 comp/공식 분리 필요(webadmin 트랙·본 범위 밖). **본 하네스는 결함 확증 + 정합 명세까지**(실 수정은 인간 승인 후 §18/dbmap/webadmin).

---

## 2. CFM-COVER-A4PLT — A4 표지 3절 절가행 존재 여부

### 2.1 가격표 출력소재 시트 실측 — 국4절/3절 2컬럼 모델

가격표 출력소재(IMPORT) 시트 헤더: `... 가격(국4절)[I열] · 가격(3절)[J열] ...` (3절 컬럼 **존재**).

| row | 종이명 | 평량 | 전지 | 연당가 | 가격(국4절·I) | 가격(3절·J) | 종이사이즈 |
|---|---|---|---|---|---|---|---|
| 9 | 아트지 150g | 150 | 국전(939×636) | 93,300 | **46.65** | (공란) | 316x467 |
| **51** | **아트지 150g (3절)** | 150 | **4×6(1091×788)** | 134,310 | (공란) | **89.54** | **330x660** |
| 98 | 하드커버전용지+무광코팅 | X | — | — | `계산식` | (공란) | — |

- ★**아트지150g 국4절(row9)과 3절(row51)은 별도 행**. 국4절은 국전(939×636)에서, 3절은 4×6전지(1091×788)에서 자른다(연당가·절가 상이).
- ★**아트지 150g (3절) 절가 = 89.54 (verbatim 확보)**. 전지 4×6(1091×788)·연당 1500매·연당가 134,310.
- 전체 출력소재: 국4절 절가 기입 **74행** vs 3절 절가 기입 **5행**(아트150·스노우250·몽블랑130/190/240) — 3절은 소수 종이만.

### 2.2 라이브 — 3절 절가행 부재(BLOCKED) · (3절) 자재는 마스터 등록됨

```sql
-- t_prc_component_prices(COMP_PAPER) plt_siz_cd 분포 (2026-06-25)
plt_siz_cd=SIZ_000499(316x467 국4절): 56행 / 56자재   ← 전부 국4절 1판형 모델
3절(SIZ_000475 등) 절가행: 0행
-- 아트지150 자재 2종
MAT_000078 아트지 150g        → COMP_PAPER: 국4절 46.65 1행
MAT_000083 아트지 150g (3절)  → COMP_PAPER: 0행 (★단가행 부재)
-- (3절) 자재 5종 전부 COMP_PAPER 0행
MAT_000083/093/110/111/112 (아트150·스노우250·몽블랑130/190/240 3절) = paper_rows 0
```

- ★**라이브 COMP_PAPER는 국4절 단일판형 모델**(56자재 × 국4절 1행). 3절 절가는 **자재 마스터(MAT_000083 등)는 있으나 단가행 0** = **A4 표지 용지비 BLOCKED**.
- search-before-mint: 단가 신규 mint **불요**(가격표 row51 verbatim 89.54 존재) — **적재만 하면 해소**. mat_cd=MAT_000083·plt_siz_cd=SIZ_000475(330x660 3절)·unit_price=89.54·min_qty=1.

### 2.3 표지 출력판형 결정 규칙 (완제 사이즈 → 출력판형)

판걸이수 시트 r64/r65 권위 매핑:

| 완제 사이즈 | 표지 펼침(재단) | 출력판형 | 라이브 판형 코드 | 절가 원천 |
|---|---|---|---|---|
| **A5** | 390×268 | **국4절(316×467)** | SIZ_000499 (impos_yn=Y) | 아트150 국4절 **46.65** (라이브 존재 🟢) |
| **A4** | 532×355 | **3절(330×660)** | SIZ_000475 (★impos_yn=**N**) | 아트150(3절) **89.54** (라이브 단가행 🔴 부재) |

- ★**추가 결함**: 3절(SIZ_000475)은 라이브에서 **impos_yn=N**(출력판형으로 미마킹)이며, fn_calc_pansu에 넣으면 표지 펼침 532×355가 3절 실제영역(320×650)에 **0-up**(가로 532 > 320)으로 계산불가(NULL). 즉 A4 표지는 ① 3절 절가행 부재 ② 3절 impos_yn=N ③ 532×355가 3절에 물리적으로 1-up 불가(margin 적용 시) — **3중 미비**. 가격표는 "3절"로 표기하나 532×355 펼침이 330×660 판에 들어가려면 margin·회전 정의 재확인 필요(가격표 의도는 1장 출력으로 보이나 현 라이브 치수로는 0).

---

## 3. 두 CONFIRM 해소/잔여 + 072 바인딩 가능 사이즈 범위

### 3.1 해소 가능분 (verbatim·출처 명시)

| 항목 | 해소 내용 | 출처 |
|---|---|---|
| fn_calc_pansu 로직·인자 의미 | 🟢 완전 규명(판형 work−margin ÷ 아이템 work·정상/회전 max) | 라이브 함수정의 verbatim |
| 게이트 `=4`의 의미 | 🟢 완제 A5 4-up(표지 펼침 아님) | 실측 재현 |
| 표지 출력매수 권위 | 🟢 표지 펼침면(390×268/532×355)·A5 국4절 1-up | 판걸이수 r64/r65 |
| 돈 결함 실재·폭 | 🟢 확증(완제 siz_cd 주입 → 표지 약 3.8배 과소청구) | pricing.py 559~581 + use_dims 실측 |
| A4 3절 절가 단가값 | 🟢 verbatim 89.54(아트150 3절·4×6전지·연당134,310) | 가격표 row51 |
| A5 국4절 절가 | 🟢 라이브 46.65 존재 | COMP_PAPER MAT_000078 |

### 3.2 잔여 실무진/타 트랙 필요분

| ID | 미해소 | 영향 | 라우팅 |
|---|---|---|---|
| **CFM-HC-COVER-PANSU (코드)** | evaluate_price가 표지 item_siz를 완제 siz_cd로 고정 → 표지 펼침 출력매수 반영 불가. comp별 item_siz 분기 or 표지 전용 comp/공식 분리 결정 | 🔴 표지 3비목 약 3.8배 과소청구 | webadmin pricing.py(코드·본 범위 밖)·인간 승인 |
| **표지 펼침 사이즈코드 신설** | t_siz_sizes에 390×268(A5)·532×355(A4) 표지펼침 미등록 → fn_calc_pansu에 줄 item_siz 부재 | 🔴 표지 판수 계산 불가 | dbmap(siz 신설·search-before-mint) |
| **CFM-COVER-A4PLT (적재)** | 아트150 3절 절가 89.54 라이브 COMP_PAPER 단가행 부재(MAT_000083·SIZ_000475) | 🔴 A4 표지 용지비 미산출 | dbmap 적재(단가 verbatim·신규 mint 0)·인간 승인 |
| **3절 판형 정합(A4)** | SIZ_000475 impos_yn=N·표지펼침 532×355가 3절 실제영역 320×650에 0-up | 🔴 A4 표지 판수 NULL | dbmap(siz 속성)·실무진(3절 출력 정의·margin/회전) |
| CFM-COVER-MAT | 표지 용지비 자재코드 = MAT_000078(아트150) vs MAT_000246(전용지) | 돈영향 0(단가 동일 46.65) | 적재 시 1개 선택 |
| CFM-COVER-COAT / SONJI | 코팅 비목 경계·손지 +5장 | 이중계상/소액 | 실무진(직전 산출 §5/§6) |

### 3.3 072 바인딩 가능 사이즈 범위 판정

| 완제 사이즈 | 표지 용지비 | 표지 출력매수(판수) | 바인딩 판정 |
|---|---|---|---|
| **A5** | 🟢 아트150 국4절 46.65(라이브) | 🟡 펼침 390×268 → 국4절 1-up(정합), 단 **현 코드는 완제 A5로 4-up 과소** | 🟡 **조건부 가능** — 용지비 단가는 있으나, ① 표지 펼침 siz_cd 신설 ② evaluate_price 표지 item_siz 정합(or 표지 전용 comp) 선결. 미선결 시 표지 3비목 과소청구 |
| **A4** | 🔴 아트150 3절 89.54 단가행 부재(BLOCKED) | 🔴 3절 impos_yn=N·펼침 532×355 0-up | 🔴 **BLOCKED** — 3절 절가 적재 + 표지펼침 코드 신설 + 3절 판형 정합 3건 선결 |

- ★**바인딩 가능 범위 결론**: **A5만 (조건부) 바인딩 후보**, **A4는 BLOCKED**. 단 A5도 표지 출력매수 정합(펼침 siz_cd·코드/comp 분리)이 선결되지 않으면 **표지 3비목 과소청구**라 무조건 바인딩 금지(돈 크리티컬). 안전하게는 **표지 비목 정합 선결 전까지 A5·A4 모두 바인딩 보류** 권고(게이트 기존 BLOCKED 가드 유지).

---

## 4. 출처 (날조 0)

- **라이브(2026-06-25 읽기전용 SELECT)**:
  - `pg_get_functiondef(fn_calc_pansu)` 함수정의 verbatim(인자 p_plate_siz_cd/p_item_siz_cd·work−margin÷work·GREATEST(normal,rotate)).
  - `t_siz_sizes`: SIZ_000499(316x467 work·margin5·impos_yn=Y)·SIZ_000475(330x660 work·margin5·impos_yn=**N**)·SIZ_000170(A5 148x210 margin0). 표지펼침 390×268/532×355 = work/cut **0행**(미등록).
  - `t_prc_price_components`: COMP_PAPER/COMP_COAT_MATTE/COMP_PRINT_DIGITAL_S1 use_dims(셋 다 plt_siz_cd 포함).
  - `t_prc_component_prices(COMP_PAPER)`: plt_siz_cd 분포 = SIZ_000499 56행 단일판형·MAT_000078 국4절 46.65·MAT_000083(아트150 3절)/093/110/111/112 = paper_rows **0**.
  - `t_mat_materials`: MAT_000078(아트지 150g)·MAT_000083(아트지 150g (3절)) 별도 자재 등록.
- **가격표 260527**(openpyxl read_only·data_only):
  - 판걸이수 시트 r64(하드커버무선책자 A5·재단390x268·블리드0·디지털인쇄 국4절 316x467·판걸이 공란)·r65(A4·재단532x355·블리드0·3절 330x660·판걸이 공란).
  - 출력소재(IMPORT) 헤더(가격(국4절)[I]·가격(3절)[J] 2컬럼)·row9(아트지150g 국4절 46.65·국전939x636·연당93,300·3절 공란)·**row51(아트지 150g (3절)·3절가 89.54·4x6전지1091x788·연당134,310·330x660)**·row98(하드커버전용지+무광코팅·국4절"계산식").
- **상품마스터 260610**: booklet-l1.csv 하드커버책자 표지작업사이즈=`*책등에따라다름`(병합·고정값 없음)·표지종이=전용지·표지코팅=무광코팅(단면).
- **webadmin pricing.py**(코드 실측): line 20~22(판형기준 use_dims plt_siz_cd→판수 ⌈수량÷판걸이수⌉·fn_calc_pansu(판형,완제품))·line 199~213(plate_qty ceil)·line 265~277(_calc_pansu)·line 559~581(needs_plate·item_siz=selections.siz_cd·pansu 상품당 1회·plt_siz comp는 plate_qty 환산).
- **직전 산출**: cover-paper-calc-derivation.md(표지 전용지="계산식"=seq9 용지비 공통산식·아트150 46.65)·price-pilot-hc072-gate.md §5(fn_calc_pansu('SIZ_000499','SIZ_000170')=4·CFM-HC-COVER-PANSU 제기·pansu=1 vs 4 골든차).
