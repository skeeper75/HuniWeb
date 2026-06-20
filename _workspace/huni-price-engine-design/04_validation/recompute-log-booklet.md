# recompute-log-booklet.md — 책자 골든 재계산 로그 (E6·허용오차 0)

> **hpe-validator 독립 재계산.** pricing.py(`component_subtotal`·`match_component` min_qty TIER·round_won) 충실 재구현으로 GC-BK1~8을 라이브 단가행 verbatim 위에서 재산출. designer 골든 신뢰 없이 직접 SELECT→재계산→byte 대조.
> 라이브 읽기전용 SELECT 2026-06-20(Railway `db railway`·psql). DB 쓰기 0.

---

## 0. 엔진 산식 (코드 라인 확정)

- `component_subtotal`(pricing.py:177-192): `.01 단가형` → `unit_price × qty`(÷min_qty 미발생). `.02 합가형` → `unit ÷ tier_min_qty × qty`(base<=0 ValueError).
- COMP_BIND 전건 `.01`·min_qty NULL 0건(Q15) → `.01 × qty` 분기만 발생·ValueError 위험 0.
- min_qty TIER 선택(:144-162): '이상' 하한 — 주문수량 이하 최대 임계 행. round_won=ROUND_HALF_UP.

## 1. 라이브 단가행 verbatim (SELECT 결과·E1 표와 동일)

```
COMP_BIND_TWINRING / PROC_000018(중철·현 라이브 오염): 1=4000 4=3000 10=2000 30=1500 50=1500 70=1300 100=1300 1000=1000
COMP_BIND_JUNGCHEOL(del='Y') / PROC_000018(중철·B01 정답):  1=3000 4=2000 10=1500 30=1000 50=1000 70=700 100=700 1000=500
COMP_BIND_TWINRING / PROC_000019(무선):  1=3000 4=2000 10=1000 30=700 50=700 70=500 100=500 1000=500
COMP_BIND_TWINRING / PROC_000020(PUR):   1=5000 4=5000 10=5000 30=4000 50=3000 70=2500 100=2000 1000=1500
COMP_BIND_TWINRING / PROC_000021(트윈링): 1=4000 4=3000 10=2000 30=1500 50=1500 70=1300 100=1300 1000=1000
COMP_BIND_SSABARI / PROC_000023(HC무선): 1=30000 4=20000 10=14000 50=9000 100=7000 1000=6000
COMP_BIND_SSABARI / PROC_000024(HC트윈링):1=30000 4=20000 10=15000 50=10000 100=8000 1000=7000
COMP_BIND_SSABARI / PROC_000098(싸바리):  1=30000 4=25000 10=20000 50=15000 100=9000 1000=7000
```

## 2. 재계산 (python 충실 재구현·실행 결과)

| GC | 입력 | TIER 선택(min_qty 이하 최대) | unit | unit×qty | 재계산 | 골든 | 일치 |
|----|------|------------------------------|------|----------|--------|------|------|
| **GC-BK1 corrected** | 중철 qty=4 | min_qty=4 (JUNGCHEOL) | 2000 | 2000×4 | **8,000** | 8,000 | ✓ |
| GC-BK1 corrupt(현 라이브) | 중철 qty=4 | min_qty=4 (TWINRING 오염) | 3000 | 3000×4 | 12,000 | (12,000·교정 전) | ✓ 양면 |
| **GC-BK2** | 무선 qty=100 | min_qty=100 | 500 | 500×100 | **50,000** | 50,000 | ✓ |
| **GC-BK3** | PUR qty=1000 | min_qty=1000 | 1500 | 1500×1000 | **1,500,000** | 1,500,000 | ✓ |
| **GC-BK4** | 트윈링 qty=10 | min_qty=10 | 2000 | 2000×10 | **20,000** | 20,000 | ✓ |
| **GC-BK5** | HC무선 qty=4 | min_qty=4 (SSABARI/023) | 20000 | 20000×4 | **80,000** | 80,000 | ✓ |
| **GC-BK6** | HC트윈링 qty=100 | min_qty=100 (SSABARI/024) | 8000 | 8000×100 | **800,000** | 800,000 | ✓ |

**python 실행 출력(verbatim):**
```
GC-BK1 중철 4부 corrected(JUNGCHEOL): 8000  expected 8000
GC-BK1 중철 4부 corrupt(현라이브):    12000  (12000 오염)
GC-BK2 무선 100부: 50000  expected 50000
GC-BK3 PUR 1000부: 1500000  expected 1500000
GC-BK4 트윈링 10부: 20000  expected 20000
GC-BK5 HC무선 4부: 80000  expected 80000(제본비)
GC-BK6 HC트윈링 100부: 800000  expected 800000(제본비)
```

**→ GC-BK1~6 전건 6/6 허용오차 0 일치.**

## 3. del_yn 필터 / proc_cd 주입 시나리오 (현 라이브 실제 산출·갈린 지점)

현 라이브 PRF_BIND_SUM→COMP_BIND_JUNGCHEOL(del='Y'·PROC_000018 8행만). 엔진 del_yn 필터 부재(pricing.py grep 0건·models 기본 매니저). 4상품 견적 시 실제 산출:

| 상품 | proc_cd 주입 | JUNGCHEOL 매칭 | 산출(제본비) | 판정 |
|------|-------------|----------------|--------------|------|
| 중철책자(068) | PROC_000018 | 매칭(8행) | 4부=2000×4=8,000 | 우연 정합(JUNGCHEOL=B01 중철 정답) |
| 중철책자(068) | 미주입(NULL) | 행 proc_cd non-NULL vs NULL 불일치 → no_match | **0원**(lenient 경고) | 침묵 |
| 무선책자(069) | PROC_000019 | JUNGCHEOL에 019 행 없음 → no_match | **0원** | misfire→0원 |
| PUR/트윈링(070/071) | PROC_000020/021 | no_match | **0원** | 0원 |

★ **갈린 지점**: 설계의 "del 필터 적용 시 0원 / 미적용 시 중철값 misfire" 두 가설 중 **del 필터 미적용이 실제**. 그러나 misfire 양상은 **proc_cd 종속** — 중철책자만 PROC_000018 주입 시 우연 정합(8,000), 무선/PUR/트윈링은 JUNGCHEOL에 해당 proc 행이 없어 0원(misfire 아닌 no_match). proc_cd 미주입이면 4상품 전부 0원. **결론(4상품 자기 제본비 정상 불가→W1 재배선 + Q-BK-PROC proc_cd 주입 필수)은 어느 시나리오든 불변.** 설계 결론 비준·"필터 적용 시 0원" 표현만 정밀화(LOW).

## 4. GC-BK7/8 구조 검증 (수치 골든 미산출·정직 보류)

- **GC-BK7(완성가 Σ)**: 표지/내지 comp 라이브 0행(Q7) → 수치 재계산 불가. 구조 검증만: ① 부품 comp addtn_yn=Y Σ ② 제본비=부수 차원만·내지비=부수×페이지(앱 2중 곱) ③ COMP_PAPER 2회 배선 시 mat_cd 분기로 combo_key 분리(동일 종이 시 ERR_AMBIGUOUS·E4) ④ 면지 sub_prd 비합산. 부품 단가값은 Q-BK-COVER(가격표 재대조) 후 골든 보강. **미확정을 정답으로 위장 안 함 = 정직.**
- **GC-BK8(이중수량)**: 내지 comp 0행 → 수치 불가. 구조: 페이지수=입력 차원(page_rules·SKU 베이크 금지)·제본비는 부수만·내지비만 부수×페이지·책등=앱 파생(DB 미저장). 두 수량 축 혼동 금지 가드 정합.

## 5. 결론

- **GC-BK1~6 허용오차 0 재현**(6/6). 단가행=라이브 verbatim·.01 산식 코드 충실.
- **양면 입증**: GC-BK1 corrupt 12,000(현 라이브 오염) vs corrected 8,000(W2 교정 후·B01 정답). 진원=라이브 단가행 오염이지 설계 골든값 오류 아님.
- **del_yn 필터 부재 코드 확정** → 설계 "검증 인계" 질문 결판·misfire/0원 분기는 proc_cd 종속이나 W1 재배선 필수 결론 불변.
- **GC-BK7/8 구조 전용 정당**(부품 comp 0행·Q-BK-COVER 후 수치 보강).
- DB 쓰기 0·라이브 읽기전용.
