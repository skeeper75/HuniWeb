# 프린트엽서 — evaluate_price 재계산 로그 + 골든 대조

> **hqv-quote-verifier** · 2026-06-18 · 대표 PRD_000016 · PRF_DGP_A.
> 재계산 방식 = **pricing.py(570줄)의 순수함수 verbatim 임포트** + 라이브 단가행 주입(동치 입증 선행).
> 하네스 = `_recompute/recompute.py` · 라이브 데이터 = `_recompute/{comp_prices.json,formula_comps.json}`(읽기전용 SELECT 추출).

---

## 0. 동치 입증 (재계산 = 라이브 엔진과 동일 알고리즘)

`recompute.py`는 `catalog.models`만 스텁하고 `pricing.py`를 실제 로드해
**`match_component`·`component_subtotal`·`_row_matches`·`_combo_key`·`_tier_val`·`_tier_order_val`·`round_won`를
무수정 그대로 호출**한다. ORM 의존부(`_component_rows`)만 라이브 JSON 딕셔너리 조회로 대체했고,
`_evaluate_formula`/`_match_entry` 로직(disp_seq순·proc_sels 다중평가·included 합산)을 동일 절차로 미러링했다.
→ 매칭·환산·티어선택·반올림이 라이브 FORMULA 경로와 동일. (직접/템플릿단가 0행이라 FORMULA만 발화 = C1 정합.)

실행: `python3 _workspace/huni-quote-verify/print-postcard/02_verify/_recompute/recompute.py`

---

## 1. 골든 앵커 대조표 (권위 vs 라이브 재계산)

> 권위 = golden-cases.md(가격표 verbatim × 권위 산정식). 허용오차 0.

| 케이스 | 항목 | 권위 골든 | 라이브 재계산 | 일치? | 갈린 지점 |
|--------|------|:--:|:--:|:--:|------|
| PC-2 (100x150 칼라단면 200매) | 인쇄비 소계 | **20,000** | **78,000**(S1 26,000+S2 52,000) | ❌ | F-2 이중 + F-3 ×qty + F-1 도수 |
| PC-2 | 용지비 | 2,119.2 | 14,128 | ❌ | F-3 ×qty(200), 권위 ×출력매수(30) |
| PC-2 | final(인쇄+용지) | ~22,119 | 92,128 | ❌ | 누적 |
| PC-4 (흑백단면 200매) | 인쇄비 소계 | 8,750 | (해당 옵션 부재) | ❌ | PRD_000016에 흑백옵션 없음 |
| PC-3 (무광단면코팅 200매) | 코팅비 소계 | 20,000 | 60,000 | ❌ | F-3 ×qty(300×200), 권위 800×25 |
| 단가 정합 | 용지비 단가 | 70.64 | 70.64 | ✅ | (단가 자체만 일치) |

→ **앵커 전건 불일치.** 단가행 "값"은 가격표 verbatim이나(예 용지비 70.64·코팅 300·인쇄 350/130),
**산정 구조(도수축·이중배선·출력매수·plate환산)가 무너져** 최종가가 권위와 대량 괴리.

---

## 2. 케이스별 재계산 상세 (recompute.py 출력)

### PC-2-naive (손님이 work size 그대로 선택: siz_cd=SIZ_000003 100x150, 단면, 200매)
```
included 0건 → base_amount = 0 → final_price = 0
```
- 갈린 지점 = **F-4**. 인쇄비(siz=plate키)·용지비(siz=plate키) 전부 work siz와 no-match → 0원.
- 함의: 위젯/호출측이 work→plate 환산 없이 선택값을 그대로 넣으면 **견적이 0원**(엔진 lenient 침묵).

### 인쇄비 발화 조건 (proc_cd=PROC_000004 공급 필요)
- S1/S2 단가행 proc_cd = **PROC_000004**(="인쇄" sub). use_dims에 proc_cd 선언.
- PRD_000016 등록 공정 = PROC_000027~032(직각/둥근/오시/미싱/가변텍스트/가변이미지)뿐 → **디지털인쇄 공정(PROC_000004) 미등록.**
- → 호출측이 selections 또는 proc_sels에 `proc_cd=PROC_000004`를 넣어야 인쇄비가 발화. 안 넣으면 인쇄비 0원.

### 단면 국4절 200매 (plt=siz=SIZ_000499, POPT_000001, +proc PROC_000004)
```
[INCL] COMP_PRINT_DIGITAL_S1  sub=26,000  per=130  (up=130, mq=200, popt=POPT_000001, plt=SIZ_000499)
[INCL] COMP_PRINT_DIGITAL_S2  sub=52,000  per=260  (up=260, mq=200, popt=POPT_000001, siz=SIZ_000499)
[INCL] COMP_PAPER             sub=14,128  per=70.64 (siz=SIZ_000499, mat=MAT_000074)
base_amount = 92,128
```
- 인쇄비 = S1 26,000 + S2 52,000 = **78,000** = F-2 이중배선(권위 인쇄비는 단일).
- 단가행 130/260 = 권위 **흑백단면(B열) 200행 130** / S2도 동일 200행이나 per_item 260(왜 2배? → S2 unit_price=260=권위 흑백양면(C열) 200행). 즉 S1=흑백단면·S2=흑백양면을 같은 단면선택에 둘 다 매칭 = 도수/면 혼선의 이중.
- ×200 = 출력매수(25) 아닌 qty(200) = F-3.
- 권위 정답(칼라단면 800@출력매수25행 × 25) = 20,000과 전혀 다름 = F-1.

### 양면 국4절 200매 (POPT_000002)
```
[INCL] S1 sub=62,000 per=310 (popt=POPT_000002)   # 310=권위 칼라단면 200행
[INCL] S2 sub=124,000 per=620 (popt=POPT_000002)  # 620=권위 칼라양면 200행
[INCL] PAPER sub=14,128
base_amount = 200,128
```
- POPT_000002(양면=칼라)에 S1=칼라단면(310)·S2=칼라양면(620)을 둘 다 매칭 → 또 이중. 면/도수 축이 print_opt 한 축에 뭉개져 S1/S2가 서로 다른 도수열을 끌어옴.

### PC-3 무광단면코팅 (coat_side_cnt=1, 200매, proc 미공급이라 인쇄비 제외)
```
[INCL] COMP_COAT_MATTE  sub=60,000  per=300  (up=300, mq=200, coat=1, siz=SIZ_000499)
[INCL] COMP_PAPER       sub=14,128
base_amount = 74,128
```
- 코팅비 = 300(권위 코팅 200행 단가) × **200** = 60,000. 권위 = 800(출력매수25행) × 25 = 20,000.
- 갈린 지점 = F-3(×qty 대신 ×출력매수) + 코팅 단가행 자체도 수량축이 주문수량 기준(200행)이라 출력매수(25) 행이 아닌 200행 단가(300)를 뽑음.

### anchor qty=25 (단가행 직접 읽기)
```
S1 per=350 (흑백단면 25행) · S2 per=700 (흑백양면 25행) · PAPER 70.64
```
- 라이브 단면 25행 단가 350 = 권위 **흑백단면 D열 아닌 B열 350** 확정(work-spec D-COLOR 재확인). 권위 칼라단면(D16)=800은 라이브 미보유.

---

## 3. 갈린 지점 종합 (어느 차원·구성요소에서 권위와 어긋났나)

| 갈린 지점 | 구성요소 | 권위 | 라이브 | 원인 결함 |
|----------|------|------|------|------|
| 도수 선택 무반영 | S1/S2 | 칼라단면 800@25 | 흑백단면 350@25 | F-1 (도수축 부재·면축에 흑백열 오매핑) |
| 인쇄비 2배 | S1+S2 | 단일 | 합산 | F-2 (plate/work 동일값 둘다 included) |
| ×qty vs ×출력매수 | 전 단가형 | ×ceil(qty/판걸이) | ×qty | F-3 (출력매수 환원 부재) |
| work선택→0원 | PAPER·S1·S2·COAT | work siz로 산출 | plate siz만 보유 | F-4 (plate↔work 단절) |
| 유광 0원 | COAT_GLOSSY | 유광 매트릭스 | 0행 | F-5 |

→ **단가 "값"은 verbatim 정합하나, 4개 구조축(도수·이중·출력매수·plate환산)이 동시에 무너져 최종가 산출 불가/오산.**
