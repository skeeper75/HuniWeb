# 접지옵션 분해 설계 (folding-decomposition) — round-16

> **작성** 2026-06-13 · round-16. 입력 = `folding-structure.md` + 라이브 실측 + digital-print 참조. **분해 기준 = Phase11 `evaluate_price` 매칭 규칙.** **DB 미적재.**

---

## 1. 공식 매핑 (접지옵션 = 합산형 부품 공급)

접지옵션 시트는 **디지털인쇄 합산형 공식의 후가공 부품(접지비)**을 공급한다(디지털인쇄비와 동형). 라이브 배선:

| frm_cd | frm_nm | 접지 구성요소 배선 | use_yn |
|--------|--------|-------------------|:------:|
| **PRF_FOLD_SUM** | 접지 합산형(오시+접지 후가공 구성요소) | COMP_FOLD_CARD_2H (disp_seq 1) | Y |
| **PRF_DGP_C** | 디지털인쇄 합산형C 인쇄배경지·헤더택 | COMP_FOLD_CARD_2H (disp_seq 4) | Y |
| **PRF_DGP_E** | 디지털인쇄 합산형E 접지카드·접지리플렛 | COMP_FOLD_LEAF_HALF/3FOLD/4ACC/4GATE (disp_seq 6~9) | Y |

- **공식정의(price_formulas) ≠ 상품바인딩(product_price_formulas)** — 별 테이블(교훈②).
- 상품바인딩: 접지카드 27·미니접지카드 28(use_yn=N)·3단접지카드 29 → PRF_DGP_E / 인쇄배경지 43~45·헤더택 → PRF_DGP_C / 접지리플렛 48 → PRF_FOLD_SUM.

---

## 2. 🔴 단가형 / 합가형 판별 (Phase11 핵심)

| 구성요소 | prc_typ_cd | 근거 | 엔진 계산 |
|----------|-----------|------|----------|
| `COMP_FOLD_CARD_2H/3H/6CR` | **.01 단가형** | 셀=장당가. 2단 1매=5000→10매=700→100매=270→5000매=40(수량↑ 장당가↓ 체감) | `단가 × 주문수량` |
| `COMP_FOLD_LEAF_HALF/3FOLD/4GATE/4ACC` | **.01 단가형** | 동형(반접지 1매=5000→5000매=40) | `단가 × 주문수량` |

- **합가형(.02) 없음** — 추정 아님. 가격표 수량축이 "제작수량"이고 각 셀이 장당가로 곱셈 거동(수량↑ 장당가↓ 체감). 라이브 `prc_typ_cd` 전건 `.01` 실측 일치.

---

## 3. 🔴 접지옵션 개별분해 결정 (엔진 매칭 단위·collapse 금지·교훈③)

### 3-1. 헤더 "/" = 개별 접지옵션 (블록1)

가격표 한 단가컬럼이 2개 개별 접지옵션을 같은 단가로 묶음. 엔진 매칭 단위로 분해:

| 가격표 단가컬럼 | 개별 접지옵션 | 분해 그릇(proc_cd 차원) | 라이브 RU(collapse) |
|----------------|--------------|------------------------|---------------------|
| 2단(B) | 2단가로접지 | comp=CARD_2H, **proc_cd=PROC_000065** | comp=CARD_2H, proc_cd=NULL |
| 2단(B) | 2단세로접지 | comp=CARD_2H, **proc_cd=PROC_000066** | (동일 단가행에 흡수) |
| 3단(C) | 3단가로접지 | comp=CARD_3H, proc_cd=PROC_000067 | comp=CARD_3H, proc_cd=NULL |
| 3단(C) | 3단세로접지 | comp=CARD_3H, proc_cd=PROC_000068 | 〃 |
| 6단(D) | 6단오시접지 | comp=CARD_6CR, proc_cd=PROC_000073 | comp=CARD_6CR, proc_cd=NULL |
| 6단(D) | 6단미싱접지 | comp=CARD_6CR, proc_cd=PROC_000074 | 〃 |

### 3-2. 블록2 단일 접지옵션

| 가격표 컬럼 | 접지옵션 | comp | proc_cd |
|------------|----------|------|---------|
| 반접지(B) | 반접지 | LEAF_HALF | PROC_000056(접지) |
| 3단접지(C) | 3단접지 | LEAF_3FOLD | PROC_000060 |
| 4단병풍접지(D) | 병풍접지 | LEAF_4GATE | PROC_000071 |
| 4단대문접지(E) | 4단대문접지 | LEAF_4ACC | **NULL**(라이브 PROC 미등록·Q-FOLD-2) |

### 3-3. 단수(2/3/6단)는 차원인가 구성요소인가?

- **단수 = 구성요소 분기**(차원 아님). 라이브가 2H/3H/6CR을 **별 comp**로 적재(같은 단가표 안 차원이 아니라 별 단가표). 단수마다 수량-단가 곡선이 다름(2단 100매=270 vs 6단 100매=300) → 별 구성요소 정당.
- **가로/세로/오시/미싱 = proc_cd 차원**(같은 comp 안). 같은 단수는 가로·세로가 **동일 단가** → 한 comp 안에서 proc_cd로 분기(차원). 이것이 "/" collapse를 풀어내는 방식.

---

## 4. use_dims (구성요소별 차원 집합 — 라이브 실측 재현)

| comp_cd | use_dims (라이브 jsonb) | 안 쓰는 차원(NULL) |
|---------|------------------------|-------------------|
| `COMP_FOLD_CARD_2H/3H/6CR` | `["min_qty"]` | siz·clr·mat·proc·coat·opt·bdl |
| `COMP_FOLD_LEAF_HALF/3FOLD/4GATE/4ACC` | `["min_qty"]` | 〃 |

- **라이브 RU**: use_dims가 `["min_qty"]`만 = 라이브가 proc_cd를 차원으로 안 씀(collapse). 단가행 proc_cd 전건 NULL.
- **개별분해 그릇(4b) 제안 시**: use_dims를 `["proc_cd","min_qty"]`로 확장해야 엔진이 proc_cd 매칭. **현 라이브와 충돌** → 컨펌 Q-FOLD-1.

---

## 5. component_prices long-form 분해 규칙

```
RU(라이브 재현·collapse):
  블록 셀(수량 r, 단가컬럼 col) → comp_cd=라이브 comp, min_qty=r, unit_price=셀값, 나머지 NULL
  = 336행 (7 comp × 48구간)

DECOMP(개별분해·proc_cd 명시):
  블록1 셀 → 2 proc 복제: comp_cd=CARD_X, proc_cd={가로/세로 PROC}, min_qty=r, unit_price=셀값
  블록2 셀 → 1 proc: comp_cd=LEAF_X, proc_cd={PROC|NULL}, min_qty=r, unit_price=셀값
  = 480행 (블록1 6proc×48=288 + 블록2 4proc×48=192)
```

- **동시매칭 0 검증(Phase11)**: RU=같은 (comp,min_qty) 1행만(중복 0·검산 통과). DECOMP=같은 (comp,proc_cd,min_qty) 1행만(중복 0·검산 통과). **RU와 DECOMP를 동시 적재 금지**(같은 comp에 NULL행+proc행 공존=동시매칭). 택1.
- **무손실**: 가격표 336 데이터셀 ↔ RU 336행 round-trip(P3). DECOMP 480행은 336셀을 6/4 복제(원본셀 보존·역추적 가능).

---

## 6. 🔴 가격사슬 단절 발견 (HARD)

라이브 단가행은 7 comp 전건 적재됐으나 **배선이 일부만**:

| comp_cd | 단가행 | formula_components 배선 | 사슬 상태 |
|---------|:------:|------------------------|----------|
| COMP_FOLD_CARD_2H | 48행 | PRF_DGP_C(seq4)·PRF_FOLD_SUM(seq1) | ✅ 완결 |
| **COMP_FOLD_CARD_3H** | 48행 | **배선 0** | 🔴 **단절**(엔진 조회불가) |
| **COMP_FOLD_CARD_6CR** | 48행 | **배선 0** | 🔴 **단절** |
| COMP_FOLD_LEAF_HALF | 48행 | PRF_DGP_E(seq6) | ✅ |
| COMP_FOLD_LEAF_3FOLD | 48행 | PRF_DGP_E(seq7) | ✅ |
| COMP_FOLD_LEAF_4ACC | 48행 | PRF_DGP_E(seq8) | ✅ |
| COMP_FOLD_LEAF_4GATE | 48행 | PRF_DGP_E(seq9) | ✅ |

- **단절 함의**: 3단접지카드(PRD_000029)가 PRF_DGP_E에 바인딩됐으나, PRF_DGP_E엔 **LEAF(리플렛)만 배선**되고 CARD_3H/6CR(카드 3단/6단)은 미배선. 손님이 카드 3단/6단 접지 선택 시 **엔진이 단가 못 찾음**(단가행 적재 ≠ 공식 배선·교훈⑤).
- **처리**: 단가행 적재됐으므로 배선만 추가하면 복구(`formula_components`에 CARD_3H→PRF_DGP_E seq INSERT). **인간 승인·이 시트 범위 밖 마이그**(round-5). 본 산출은 단절 정직표기까지.

---

## 7. 미적재·갭 정직표기 (HARD)

| 항목 | 상태 | 처리 |
|------|------|------|
| 카드 3단/6단 배선 단절 | 단가행 O·배선 0 | §6 가격사슬 단절(인간 승인 배선) |
| 4단대문접지 PROC | 라이브 `t_proc_processes` 미등록 | DECOMP proc_cd=NULL·컨펌 Q-FOLD-2 |
| 미니접지카드(PRD_000028) | use_yn=N 미출시 | 라이브 상태 보존 |
| proc_cd 개별분해 vs RU collapse | 충돌(둘 다 적재 불가) | 택1 결정 컨펌 Q-FOLD-1 |

---

## 8. 미해소 컨펌 (추정 금지)

| ID | 컨펌 | 영향 |
|----|------|------|
| **Q-FOLD-1** | 접지옵션을 **RU(collapse·proc_cd 비움)** 유지 vs **DECOMP(개별 proc_cd 분해)** 채택. DECOMP는 use_dims에 proc_cd 추가 필요(라이브 충돌)·위젯이 가로/세로 구분 선택을 가격에 반영하려면 필수 | 단가행 336 vs 480·use_dims |
| **Q-FOLD-2** | 4단대문접지 PROC 미등록 — `t_proc_processes`에 신설(예: PROC_xxx 대문접지)할지, 4단병풍접지와 통합할지 | LEAF_4ACC proc_cd 매칭 |
| **Q-FOLD-3** | 카드 3단/6단 가격사슬 단절(§6) 복구 시점·배선 대상 공식(PRF_DGP_E 추가 vs 별 공식) | 카드접지 3/6단 가격 조회 |

---

## 9. 자체검산 (recompute sanity — P6 예비)

3단접지카드(PRD_000029) "2단가로접지" 500매 주문(RU 경로 가정):
```
접지비 = COMP_FOLD_CARD_2H[min_qty≤500 최대구간=500] × 주문수량
       = 80(가격표 B34·라이브 일치) × 출력수량
```
- 단, 손님이 카드 "3단"·"6단" 선택 시 PRF_DGP_E에 CARD_3H/6CR 미배선 → 조회불가(§6 단절). 2H만 PRF_DGP_C/FOLD_SUM 경유 가능.
- 단가 80 = 가격표 B34(450매=90, 500매=80) 일치 → 그릇 정합.

---

## 10. 한 줄 현황

접지옵션 분해 완료 — **합산형 부품 공급**(디지털 동형). **전건 단가형(.01)**·use_dims=[min_qty]. **헤더 "/" 6개 개별 접지옵션 = proc_cd 차원 개별분해(DECOMP 480행)**·라이브 collapse(RU 336행) 병기. **🔴 가격사슬 단절: CARD_3H·CARD_6CR 단가행 적재됐으나 배선 0**(카드 3/6단 접지 엔진 조회불가). 무손실 336셀 round-trip·자연키 중복 0. 컨펌 3건(collapse/decomp 택1·대문 PROC·단절 복구). 다음 = mapping-flow → validator P1~P6.
