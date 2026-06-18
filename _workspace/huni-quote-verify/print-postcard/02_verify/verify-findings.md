# 프린트엽서 — 3축 검증 결과 (Claude 1차 실측)

> **hqv-quote-verifier** · 2026-06-18 · `huni-quote-verify` / `print-postcard`
> 대상 = 엽서 group · 대표 PRD_000016 프리미엄엽서 · 공식 PRF_DGP_A.
> 권위[HARD] = 상품마스터 260610 + 인쇄상품 가격표 260527. 라이브 = 읽기전용 SELECT 실측(2026-06-18).
> 엔진 계약 = `huni-price-quote/01_engine/engine-contract.md`(pricing.py 570줄 권위).
> **codex 결과 미참조 — 자기 실측 근거 독립 판정.** 추정 0 — 전 결함 재현 SQL + 셀/file:line.

---

## 0. 한 줄 결론

프린트엽서는 **현재 라이브 데이터로는 권위 가격이 산출되지 않는다 (NO-GO).**
3축 중 **축1 부분 FAIL · 축2 FAIL · 축3 FAIL.** 골든 재계산 불일치(전 케이스).
가격사슬은 "발화는 하나 권위와 어긋난 값"을 낸다 — 침묵 0원이 아니라 **틀린 값**이라 더 위험.

| 축 | 판정 | 핵심 결함 |
|----|:--:|------|
| 축1 SOT 일치 | 🟡 부분 FAIL | 권위 엑셀 내부는 정합(✅). 라이브가 권위와 어긋남: 인쇄비 도수축 붕괴·용지비 산식·코팅 산식 |
| 축2 공식↔구성요소 매핑 | 🔴 FAIL | S1+S2 동일값 이중배선(인쇄비 2배)·유광코팅 고아(0행)·줄수/개수 comp 다중 |
| 축3 차원 매칭 | 🔴 FAIL | **도수(흑백/칼라) 차원 완전 드롭**·면축↔도수축 혼동 적재·plate↔work 사이즈 축 단절 |
| 골든 재계산 | 🔴 불일치 | 인쇄비 권위 20,000 vs 라이브 78,000(이중)·용지비 ×qty(권위 ×출력매수) |

---

## 축1 — SOT 일치 (상품마스터 ↔ 가격표 ↔ 라이브)

### A1-결과 요약

| # | 검사 | 권위 엑셀 내부 | 라이브 정합 | 판정 |
|---|------|:--:|:--:|:--:|
| A1-1 | 사이즈 7종 ↔ 판걸이수 | ✅ | ✅ work size 7종 등록 | PASS |
| A1-2 | 종이 ↔ 출력소재 단가 | ✅ 220g=70.64 | ✅ 70.64 일치 | PASS |
| A1-3 | **도수×면 2D 매트릭스** | ✅ 6도수×2면 | ❌ **도수축 부재** | **FAIL** |
| A1-4 | 코팅 무광/유광 매트릭스 | ✅ | 🟡 무광만(유광 0행) | 부분 |
| A1-5 | 엽서 group ↔ PRF_DGP_A scope | ✅ | ✅ 바인딩 일치 | PASS |

### A1-1 사이즈↔판걸이수 (PASS)
- 라이브 PRD_000016 등록 사이즈 = SIZ_000001~007 (73x98 ~ A5) = work size 7종. 권위 7종과 1:1.
- 재현: `SELECT ps.siz_cd,s.siz_nm FROM t_prd_product_sizes ps JOIN t_siz_sizes s ON s.siz_cd=ps.siz_cd WHERE ps.prd_cd='PRD_000016';` → 7행.

### A1-2 용지비 단가 (PASS·골든 정합)
- 백색모조지220g(MAT_000074) 국4절(SIZ_000499) = **70.64** = 권위 출력소재 I6 verbatim.
- 재현: `SELECT unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_PAPER' AND siz_cd='SIZ_000499' AND mat_cd='MAT_000074';` → 70.64.

### ★ A1-3 도수축 — 권위는 도수×면 2D, 라이브는 도수축 없음 (FAIL · D-COLOR 진짜 원인 규명)
**권위 가격표 디지털인쇄비 B01(국4절) 매트릭스** (`price-digital-print-price-l1.csv` B01):
열 = 도수(흑백1도/칼라CMYK/별색 6종) **× 면(단면/양면)**, 행 = 수량.

| 수량 | 흑백단면(B) | 흑백양면(C) | 칼라단면(D) | 칼라양면(E) |
|:--:|:--:|:--:|:--:|:--:|
| 15 | 450 | 900 | 900 | 1800 |
| 20 | 400 | 800 | 850 | 1700 |
| 25 | 350 | 700 | 800 | 1600 |
| 200 | 130 | 260 | 310 | 620 |

**라이브 COMP_PRINT_DIGITAL_S1 @ SIZ_000499** (재현 SQL):
```sql
SELECT plt_siz_cd, print_opt_cd, min_qty, unit_price
FROM t_prc_component_prices
WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND plt_siz_cd='SIZ_000499'
  AND min_qty IN (15,20,25,200) ORDER BY print_opt_cd, min_qty;
```
| print_opt_cd | min_qty=15 | 20 | 25 | 200 | = 권위 어느 열? |
|:--:|:--:|:--:|:--:|:--:|:--:|
| POPT_000001 (단면) | 450 | 400 | 350 | 130 | = **흑백단면(B)** |
| POPT_000002 (양면) | 900 | 850 | 800 | 310 | = **칼라단면(D)** |

**라이브 print_opt 의미 재실측** (재현 SQL):
```sql
SELECT print_opt_cd, print_side, front_colrcnt_cd, back_colrcnt_cd
FROM t_prd_product_print_options WHERE prd_cd='PRD_000016';
```
| print_opt_cd | print_side | front | back |
|:--:|:--:|:--:|:--:|
| POPT_000001 | 단면 | CLR_000005(CMYK4도) | CLR_000001(인쇄안함) |
| POPT_000002 | 양면 | CLR_000005(CMYK4도) | CLR_000005(CMYK4도) |

→ **PRD_000016은 도수 옵션이 칼라(CMYK4도) 단/양면 2종뿐 — 흑백 옵션 자체가 없다.**
그런데 단가행은 POPT_000001(단면)에 **흑백단면(B열)** 값을, POPT_000002(양면)에 **칼라단면(D열)** 값을 실었다.
즉 적재가 면축(단/양면)을 도수×면 매트릭스의 두 열(흑백단면/칼라단면)에 잘못 1:1 매핑했다.
use_dims에 도수 차원(clr_cd/front_colrcnt_cd) 부재 → **도수가 가격에 반영될 통로가 구조적으로 없음.**

**★work-spec D-COLOR 명제 정정:** work-spec은 "350=흑백·칼라900 누락"으로 봤으나, 실측 결과
라이브 단면(350)은 흑백열, 양면(800·실은 칼라단면)은 칼라열이다 → **면축 자체가 도수열에 오매핑됨.**
PRD_000016의 정답 단면칼라(권위 800@25)는 라이브 어디에도 매핑되지 않았다. (work-spec보다 결함이 깊음)

### A1-4 코팅 (부분 FAIL)
- COMP_COAT_MATTE 92행(무광·SIZ_000077/499×coat 1/2) 정상. COMP_COAT_GLOSSY **0행**(유광 미적재 = V-4).
- 재현: `SELECT comp_cd,count(*) FROM t_prc_component_prices WHERE comp_cd IN ('COMP_COAT_MATTE','COMP_COAT_GLOSSY') GROUP BY 1;` → MATTE 92 · GLOSSY 0.

---

## 축2 — 공식↔구성요소 매핑 정합 (배선)

### A2-결과: PRF_DGP_A 18 comp 배선 (재현 SQL)
```sql
SELECT fc.disp_seq, fc.comp_cd, pc.prc_typ_cd, pc.use_dims
FROM t_prc_formula_components fc JOIN t_prc_price_components pc ON pc.comp_cd=fc.comp_cd
WHERE fc.frm_cd='PRF_DGP_A' ORDER BY fc.disp_seq;
```
18행 전부 addtn_yn='Y'(엔진 미참조 P2-4). 엽서 시트 차원경계 내 comp = **전부 정당 귀속**(오시·미싱·귀돌이·가변·별색 = 엽서 후가공이 맞음). **시트 밖 silent 합산 comp 없음** → 축2의 "오배선=시트밖" 항목은 PASS.

### ★ A2-FAIL-1 인쇄비 S1+S2 동일값 이중배선 (🔴 돈크리티컬)
- COMP_PRINT_DIGITAL_S1 use_dims=`[proc_cd, plt_siz_cd, print_opt_cd, min_qty, proc_grp:PROC_000001]`
- COMP_PRINT_DIGITAL_S2 use_dims=`[proc_cd, siz_cd, print_opt_cd, min_qty, proc_grp:PROC_000001]`
- **둘 다 SIZ_000499에 동일 단가 적재** (S1은 plt_siz_cd, S2는 siz_cd 키). 둘 다 PRF_DGP_A에 배선(seq 1·2).
- 호출측이 `plt_siz_cd=SIZ_000499` **그리고** `siz_cd=SIZ_000499`를 같이 주면 **S1·S2가 둘 다 매칭 → 인쇄비 2배 합산.**
- 재계산 입증(`_recompute/recompute.py`): 단면 국4절 200매 → S1 sub=26,000 + S2 sub=52,000 = **78,000** (인쇄비 단일이어야 정상).
- 재현 SQL:
```sql
SELECT 'S1' c, plt_siz_cd, siz_cd, print_opt_cd, min_qty, unit_price FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S1' AND plt_siz_cd='SIZ_000499' AND min_qty=200
UNION ALL
SELECT 'S2', plt_siz_cd, siz_cd, print_opt_cd, min_qty, unit_price FROM t_prc_component_prices
  WHERE comp_cd='COMP_PRINT_DIGITAL_S2' AND siz_cd='SIZ_000499' AND min_qty=200;
```
→ S1(plt=SIZ_000499,siz=NULL) + S2(plt=NULL,siz=SIZ_000499) 동일 단가. _combo_key 다름(plt vs siz)이라 ERR_AMBIGUOUS도 안 걸리고 **둘 다 included.**
> 의도 추정: S1=국4절판형(plate) 경로 / S2=작업사이즈 경로 = **상호배타 택1**이어야 하나, 배선·데이터 어디에도 택1 장치 없음. (work-spec V-5/D-5 = 실재 확정)

### A2-FAIL-2 유광코팅 고아 (V-4 확정)
- COMP_COAT_GLOSSY 배선(seq 13)됐으나 단가행 **0**. 유광 선택 시 0원 침묵 합산(엔진 no-match → 자연 제외이므로 0원이나, "유광=무료"로 오인 위험). 재현: count(*)=0.

### A2-관찰 줄수/개수 comp 다중배선 (정당·엔진 dim_vals 분기로 무해)
- CREASE_1L/2L/3L·VARTEXT/VARIMG 1/2/3EA·CORNER_RIGHT/ROUND가 각각 별 comp로 18개 배선.
- 엔진은 proc_sels 다중평가(P8-1) + dim_vals 정확매칭(P3-3)으로 선택된 것만 매칭 → 이중매칭 위험은 **proc_sels에 동일 proc_grp 복수 항목을 주지 않는 한** 없음. 데이터 결함 아님(설계상 comp 분리).

---

## 축3 — 차원 매칭 (use_dims ↔ component_prices 충전 ↔ 권위 가격축)

### ★ A3-FAIL-1 도수축 드롭 (1순위·축1 A1-3과 동근)
| 3원 | 내용 |
|------|------|
| 권위 가격축 | 도수(흑백/칼라/별색6) **× 면(단/양)** 2D |
| use_dims(S1/S2) | proc_cd · plt_siz_cd(또는 siz_cd) · **print_opt_cd(=면)** · min_qty — **도수 차원 0** |
| component_prices 충전 | print_opt_cd 2값(단/양면)에 도수 2열(흑백단면/칼라단면) 오매핑 |
- → 칼라/흑백을 가르는 차원이 use_dims·단가행 어디에도 없음. **도수 선택은 가격을 못 바꾼다**(구조적). FAIL.

### ★ A3-FAIL-2 plate(plt_siz_cd) ↔ work(siz_cd) 사이즈 축 단절 (신규 발견·돈크리티컬)
- 인쇄비 S1은 **plate size**(SIZ_000499=316x467 국4절 / SIZ_000077=300x625 3절)에 키.
  COMP_PAPER·COMP_COAT_MATTE·S2도 siz_cd footprint = **SIZ_000077/499(plate)뿐** (work size 0).
  재현: `SELECT DISTINCT siz_cd FROM t_prc_component_prices WHERE comp_cd='COMP_PAPER';` → SIZ_000499만.
  `SELECT DISTINCT siz_cd FROM t_prc_component_prices WHERE comp_cd='COMP_PRINT_DIGITAL_S2';` → SIZ_000077,SIZ_000499만.
- 그러나 **상품 등록 사이즈는 work size**(SIZ_000001~007). 손님이 선택하는 건 work size(100x150 등).
- → 손님 선택(work siz)을 그대로 엔진에 넣으면 **인쇄비·용지비·코팅비 전부 no-match → 0원**(재계산 입증: PC-2-naive-worksize final=0).
- 가격이 나오려면 호출측이 work→plate 환산(국4절/3절 판별 = 임포지션/판걸이수 앱계산)을 해서 `plt_siz_cd`·`siz_cd`에 **plate code**를 넣어줘야 함 — 이 환산 장치는 엔진·데이터에 없음(앱 책임이나 미명세). **현 데이터만으로는 견적 불성립.**

### ★ A3-FAIL-3 출력매수(판수) 미적용 — 단가형 ×qty (산식 위반·돈크리티컬)
- 권위 산정식: 인쇄비/코팅비 = [수량행 단가] **× 출력매수**(=ceil(주문수량/판걸이수)), 용지비 = 단가 × (출력매수+5).
- 라이브 comp는 전부 단가형(PRICE_TYPE.01) = 단가 **× qty(주문수량)**. min_qty 티어도 qty로 선택.
- 재계산 입증: 용지비 = 70.64 × **200** = 14,128 (권위 = 70.64 × (25+5) = 2,119.2). 코팅비 = 300 × 200 = 60,000 (권위 = 800 × 25 = 20,000).
- → **출력매수 환원 차원이 가격사슬에 없음.** 엔진은 주문수량을 그대로 곱한다 → 권위와 대량 괴리.

### A3-PASS 용지비 차원 (단가 자체는 정합)
- use_dims=[siz_cd,mat_cd]. SIZ_000499+MAT_000074=70.64 ✅(단가는 권위 일치). 단 siz=plate·×qty 문제(A3-FAIL-2/3).

### A3-관찰 동시매칭/판별차원/시계열
- ERR_AMBIGUOUS: 단일 comp 내부에선 미발생(S1/S2는 별 comp). 판별차원없음 경고: 인쇄비 use_dims에 비수량 차원(plt_siz/print_opt) 있고 단가행 충전됨 → 해당 없음. 미래 apply_ymd 행 0(C8 clean·재현: `... AND apply_ymd>'2026-06-18'` → 0행).

---

## 결함 보드 (교정 라우팅 = dbm-price-arbiter)

| ID | 결함 | comp/대상 | 증거(재현 SQL/셀) | 심각도 | 라우팅 |
|----|------|------|------|:--:|------|
| F-1 도수축 드롭 | 도수(흑백/칼라) 차원 부재·면축↔도수열 오매핑·칼라단면 정답 미매핑 | S1/S2 use_dims·print_opt | A1-3 매트릭스 대조 | 🔴 High | dbm-price-arbiter |
| F-2 인쇄비 이중 | S1(plt)+S2(siz) 동일값 둘다 매칭=인쇄비2배 | S1·S2 배선 | A2-FAIL-1 재계산 78,000 | 🔴 High | dbm-price-arbiter |
| F-3 출력매수 미적용 | 단가형 ×qty(권위 ×출력매수) — 판수 환원 부재 | 전 단가형 comp | A3-FAIL-3 14,128 vs 2,119 | 🔴 High | dbm-price-arbiter |
| F-4 plate↔work 단절 | 가격 siz=plate뿐·상품 등록=work·환산장치 부재→work선택시 0원 | PAPER·COAT·S1·S2 | A3-FAIL-2 naive=0 | 🔴 High | dbm-price-arbiter |
| F-5 유광코팅 고아 | COMP_COAT_GLOSSY 0행(유광 무료 침묵) | COMP_COAT_GLOSSY | count=0 | 🟡 Med | dbm-price-arbiter |
| F-6 투명엽서 바인딩 결손 | PRD_000019 PRF 미바인딩(검증불가) | PRD_000019 | t_prd_product_price_formulas 0행 | 🟡 Med | 컨펌큐/arbiter |

---

## 컨펌큐 (추정 금지 — 사용자/도메인)

| ID | 미지 | 영향 |
|----|------|------|
| Q-COLOR-INTENT | PRD_000016이 칼라전용(흑백옵션 부재)인 게 의도인가. 그렇다면 단면=칼라단면 단가여야 하는데 흑백단가가 실림 = 명백 오적재 | F-1 방향 |
| Q-S1S2-EXCL | S1(plate)/S2(work) 중 어느 경로가 정답인가(택1 설계 의도) — 하나는 use_yn=N 처리 대상 | F-2 |
| Q-PANSU-ENGINE | 출력매수(판수) 환원을 엔진이 할지 앱(위젯/호출측)이 할지 — 현재 둘 다 안 함 | F-3·F-4 |
| Q-PLATE-RESOLVE | work size→plate(국4절/3절) 환산 책임 위치(앱 임포지션 계산) 명세 | F-4 |
| Q-BIND-투명 | 투명엽서 미바인딩 = 미출시(의도)인가 누락인가 | F-6 |
