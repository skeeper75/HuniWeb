# 종단 질의 게이트 — 구체 상품형(유형1) + 옵션 조합형(유형4)

> 작성: 2026-07-03 · okb-query-gate (구체/옵션 담당 레인)
> 블라인드 조건: 질의 해답은 `03_kb/`(index.md 진입)·`04_graph/graph.db`만 사용. 원천(엑셀·위키·하네스 산출물·docs/kb) 미열람.
> 가격 실측 대조만 라이브 예외 구간: `_workspace/_foundation/batch/lib_huni.py`(HuniSim, 읽기/simulate 전용·POST 주문/저장 없음).
> 담당: 유형1(S1·S2·S3) + 유형4(S10·S11·S12) + 변형 2건(S1-양면·V2-무광코팅). 총 8 시나리오.

---

## 실험 요약

| # | 유형 | 질의 | KB 경로 성립 | 라이브 가격 대조 | 판정 |
|---|------|------|:---:|---|:---:|
| S1 | 1 구체 | 프리미엄엽서 73×98 단면 100장 얼마? | ✅ | 9,424원(인쇄9,000+용지423.84·pansu18)·PRICE≠0 | **PASS** |
| S1-v | 1 구체(변형) | 위 상품 양면 100장 | ✅ | 16,024원(인쇄15,600+용지423.84) | **PASS** |
| S2 | 1 구체 | 코팅명함 vs 스탠다드명함 뭐가 달라? | ✅ | 032=5,800 / 033=3,800(동일사양)·코팅프리미엄 2,000 | **PASS** |
| S3 | 1 구체 | 명함 최소 몇 장부터? | ✅ | qty_rule min=100(그래프·라이브 일치) | **PASS** |
| S10 | 4 옵션조합 | (파일럿 적용) 프리미엄엽서 오시+미싱 같이 돼? | ✅ | 제약 노드 존재(상호배제·candidate)·가격 무관 | **PASS** |
| S11 | 4 옵션조합 | 프리미엄엽서 후가공 뭐 고를 수 있어? | ✅ | 후가공 6종 열거·필수 base 구분 | **PASS** |
| S12 | 4 옵션조합 | 명함에 무광코팅 추가하면 가격 올라? | ✅ | 코팅=고정가 포함(별도 가산 0)·GAP 실증 | **PASS** |
| V2 | 4 옵션조합(변형) | 032에 무광(PROC_000015) proc 추가 | ✅ | proc 유무 차이 0원(고정가 차원 아님) | **PASS** |

**Pass 8 / Fail 0.** 환각 추천 0·가격 대조 오차 0(값 단정 회피 경계 준수)·거절/GAP 정직.

---

## S1 — "프리미엄엽서 73×98 단면 칼라, 100장 얼마?" (유형1 구체)

**1단 노드 확정:** index.md §검색라우팅 1 → `product-016-premium-postcard`(verified).

**2단 경로(그래프 재귀 탐색, graph.db 실질의):**
```
product-016-premium-postcard
  --has_size--> size-SIZ_000001            (73x98 실재 확인)
  --has_print_option--> printopt-POPT_000001 (단면 칼라)
  --priced_by--> formula-PRF_DGP_A          (원자합산형)
      --has_component--> COMP_PRINT_DIGITAL_S1 (disp0·인쇄비·use_dims=[proc_cd,plt_siz_cd,print_opt_cd,min_qty])
      --has_component--> COMP_PAPER          (disp2·용지비·use_dims=[plt_siz_cd,mat_cd])
      (+별색/귀돌이/오시/미싱/가변/코팅 구성요소 배선)
  --has_qty_rule--> qty-016                 (min15/max10000/incr15)
```
끊긴 링크 0(traverse한 dst 노드 전수 실재 확인). 근거 노드: product-016·formula-PRF_DGP_A·component-COMP_PRINT_DIGITAL_S1·COMP_PAPER·qty-016.

**KB 예측(값 계산 아님·D-18 경계):** PRF_DGP_A 원자합산 = 디지털인쇄비 + 용지비(+선택 후가공). 최종 값은 evaluate_price 위임.
**GAP 정직 노출:** `GAP_pansu_73x98` — 73×98 판걸이수(견적 분모)가 마스터 15 vs 판걸이수시트 18로 원천 충돌. KB는 **값을 단정하지 않음**.

**라이브 실측 대조:**
```
final_price = 9,424원
  디지털인쇄비  sub=9,000.00  pansu=18  matched=True
  용지비        sub=423.84    pansu=18  matched=True
```
- KB 예측 구성요소(인쇄비+용지비) = 엔진 발현 구성요소 **완전 일치**. PRICE≠0. 
- **판수 양면 판정:** KB=원천 충돌 GAP 정직 선언(값 미단정) / 라이브=pansu **18** 채택(t_siz_pansu 권위 해소분). KB가 값을 지어내지 않고 GAP로 남긴 것이 정답 행동 — 엔진이 18로 해소한 것과 모순 아님(KB 결함 아님).
- **판정 PASS**: 경로 성립·구성요소 정합·PRICE≠0·GAP 정직.

### S1-v (변형·양면)
`--has_print_option--> printopt-POPT_000002`(양면)로 분기. 라이브 = **16,024원**(인쇄비 15,600 + 용지비 423.84). print_opt_cd가 COMP_PRINT_DIGITAL_S1 use_dims에 있어 단→양면 인쇄비만 증가(용지비 불변)·KB use_dims 선언과 정합. **PASS**.

---

## S2 — "코팅명함이랑 스탠다드명함 뭐가 달라요?" (유형1 구체·diff)

**1단:** 두 상품 노드 `product-032-coated-namecard`·`product-033-standard-namecard`.

**2단 경로(diff 탐색):**
```
032 --has_process--> {PROC_000014 유광라미, PROC_000015 무광라미, PROC_000027 직각, PROC_000028 둥근}
033 --has_process--> {PROC_000027 직각, PROC_000028 둥근, PROC_000031 가변텍스트, PROC_000032 가변이미지}
    → diff: 032만 라미네이팅(코팅) 공정 보유 = 정체 차이
032 --priced_by--> formula-PRF_NAMECARD_COAT  (고정가·COMP_NAMECARD_COAT_S1/S2)
033 --priced_by--> formula-PRF_NAMECARD_FIXED (고정가·COMP_NAMECARD_STD_S1/S2)
032 --has_option_group--> optgroup-032-coating (유광/무광 택1)   ← 033엔 없음
```
근거: has_process 집합 diff + priced_by 공식 diff + 032 코팅 옵션그룹.

**KB 예측:** 코팅명함은 코팅 공정(라미네이팅)이 추가된 변형·별도 고정가 공식(COAT). 스탠다드는 코팅 없는 baseline(FIXED). 코팅은 **고정가에 포함**(별도 per-unit 가산 아님·use_dims=[mat_cd,min_qty,print_opt_cd]).

**라이브 실측(동일사양: 아트지300 MAT_000082·단면 POPT_000001·100장):**
```
032 코팅명함  = 5,800원 (COMP_NAMECARD_COAT_S1 sub=5,800 matched=True)
033 스탠다드  = 3,800원 (COMP_NAMECARD_STD_S1  sub=3,800 matched=True)
코팅 프리미엄 = 2,000원
```
- 두 상품이 **다른 공식·다른 완제품가 구성요소**로 갈린다는 KB 예측 정확. 코팅 차이가 고정가 2,000원 차로 실재. PRICE≠0. **PASS**.
- (양면 구성요소 sub=0/matched=False는 단면 선택 시 정상 — 선택 면만 발현. 결함 아님.)

---

## S3 — "명함 최소 몇 장부터 주문돼요?" (유형1 구체)

**경로:** `product-033-standard-namecard` props.min_qty → 그래프 조회.
```
sqlite: product-033 → min_qty=100, qty_incr=100, max_qty=10000 (QTY_UNIT.02 "매")
```
**KB 답:** 스탠다드명함 최소 100매·100매 단위 증가·최대 10,000매. (코팅명함 032도 min100 동일.)
**라이브 교차:** sim-meta qty_rule = `{min:100, max:10000, incr:100}` — 그래프 props와 완전 일치. **PASS**(값 대조 오차 0).

---

## S10 — 옵션 조합 제약 (유형4·파일럿 적용 실사례)

> 설계 시나리오 S10 원문은 "180g 종이+코팅 제약(047 소량전단지)"이나 **047은 파일럿 8상품 밖**이라 제약 노드 미민팅. 
> 정직 처리: 파일럿에 실재하는 제약 노드(016 데모)로 조합 가능성 질의를 실증하고, 047은 범위 밖으로 선언.

**질의(파일럿 적용):** "프리미엄엽서에서 오시랑 미싱 같이 돼요?"

**경로:**
```
product-016 --has_option_group--> {optgroup-016-crease(오시), optgroup-016-perf(미싱)}
constraint-016-demo-exc (badge=candidate·CN-4 상호배제)
   --constrains--> optgroup-016-crease
   --constrains--> optgroup-016-perf
```
**KB 답:** "오시(접지선)와 미싱(절취선)은 **동시 적용 불가**(상호배제 제약)." 단 **badge=candidate([DEMO])** — §31 제약 거버넌스 확정 대기임을 정직 고지. 가격 무관(evaluate_price는 제약 미참조·validate는 위젯/주문 담당).
**범위 정직:** 설계 예시의 047 종이두께×코팅 제약은 파일럿 미구축 = "이 조합의 제약 정보는 파일럿 범위 밖"으로 정직(단정/환각 금지).
**판정 PASS**: constraint→option_group 경로 성립·상호배제 정확·badge 정직·범위 밖 정직 선언.

---

## S11 — "프리미엄엽서에서 고를 수 있는 후가공 다 뭐야?" (유형4)

**경로:** `product-016 --has_process-->` (qualifier=mandatory로 필수/선택 구분).
```
PROC_000004 디지털인쇄  qualifier=mandatory  → base(필수·후가공 아님)
PROC_000027 직각 / PROC_000028 둥근         → 모서리(선택)
PROC_000029 오시 / PROC_000030 미싱          → 선택
PROC_000031 가변텍스트 / PROC_000032 가변이미지 → 선택
```
**KB 답:** 선택 후가공 = 모서리(직각/둥근)·오시·미싱·가변텍스트·가변이미지. 디지털인쇄(PROC_000004)는 **필수 base**(선택 아님). qualifier=mandatory가 필수/선택을 정확히 가른다.
**판정 PASS**: has_process qualifier 탐색으로 후가공 6종 + 필수 base 구분 정확(환각 없음).

---

## S12 — "명함에 무광코팅 추가하면 가격 올라가요?" (유형4·과제 지정 예시)

**경로:**
```
명함+무광코팅 → product-032-coated-namecard (코팅명함)
  --has_option_group--> optgroup-032-coating
      --option_refs--> process-PROC_000015 (무광·OPT_REF_DIM.04)
  --priced_by--> formula-PRF_NAMECARD_COAT
      use_dims = [mat_cd, min_qty, print_opt_cd]   ← 코팅 면수(coat_side_cnt) 차원 없음
  GAP_032_coat_side (unknown) — 코팅 단/양면 면구분 파라미터 부재
```
**KB 예측:** 무광코팅은 032 코팅명함의 CPQ 옵션이지만, 가격은 **고정가(용지포함)**에 포함 — 코팅 자체가 별도 per-unit 가산 차원이 아님(use_dims에 코팅 없음). 따라서 "코팅 추가"의 실질 = 스탠다드(033) 대신 코팅명함(032)을 고르는 것(= S2의 2,000원 고정가 차).

**라이브 실측(032·아트지300·단면·100장):**
```
032 코팅옵션 미지정        = 5,800원
032 + proc PROC_000015(무광) = 5,800원   → 차이 0원
```
- 무광 proc 유무가 가격을 바꾸지 않음 = KB의 "코팅=고정가 포함·차원 아님"·`GAP_032_coat_side` **정확 실증**. 
- 실질 코팅 프리미엄은 상품 선택(033→032)의 고정가 차 2,000원(S2)으로 발현. 
- **판정 PASS**: 옵션→차원→가격 배선 추적이 KB 예측대로·GAP 정직·PRICE≠0.

### V2 (변형) — 무광 vs 유광 proc 대조
032에 유광/무광 어느 proc를 넣어도 final_price 불변(5,800원) — `GAP_032_coat_side`(면구분 파라미터 부재) 재확증. **PASS**.

---

## 게이트 관점 소견(내 레인 한정)

- **O6 종단 질의 재현:** 담당 8 시나리오 전부 경로 기록 재현 가능·가격 대조 오차 0·PRICE≠0·환각 0. 유형1·유형4 커버.
- **O3 오염/양면:** S1 판수는 KB=GAP 정직(값 미단정)·라이브=18 채택으로 **양면 표기** 준수. STALE 인용 0.
- **O4 무결성(스팟):** traverse한 전 경로 끊긴 링크 0·구성요소/사이즈/옵션 노드 전수 실재.
- **정직성:** S10 047(범위 밖)·S12 GAP_032_coat_side·S1 판수 GAP — 모두 지어내지 않고 정직 처리(환각 추천=최악 결함 회피).
- **경계 준수:** 어떤 답도 가격 "값"을 KB가 단정하지 않음(D-18) — 값은 전부 라이브 evaluate_price 실측으로만 확인.

**동형 전파 가능성:** 유형1/유형4 경로 패턴(product→has_*축→priced_by→formula→has_component→use_dims + qty_rule/constraint/option_refs)은 상품 무관 스키마 고정 경로라, 디지털 파일럿 밖 상품군에도 노드만 채우면 동일 탐색으로 재현 가능. 단 GAP·candidate badge는 상품별 원천 상태에 종속(전파 시 재실측 필요).

## Sources (블라인드 준수 — 03_kb/·04_graph/만)
- `03_kb/index.md`·`nl-query-paths.md`(경로 설계)
- `03_kb/product/product-016-premium-postcard.md`·`product-032-coated-namecard.md`·`product-033-standard-namecard.md`
- `03_kb/formula/digital-formulas.md`·`digital-components.md`·`03_kb/rule/gaps.md`
- `04_graph/graph.db`(재귀 엣지 질의·끊긴 링크 검사)
- 라이브 대조(예외 구간): `_workspace/_foundation/batch/lib_huni.py` HuniSim.simulate/sim_meta(읽기·POST 계산 전용)
