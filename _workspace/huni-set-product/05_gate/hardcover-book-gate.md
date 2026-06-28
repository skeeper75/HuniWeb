# 하드커버책자(PRD_000072) 셋트 독립 검증 게이트 — S1~S7 verdict

검증: hsp-set-gate(독립 재실측·생성자 주장 비신뢰) · 라이브 읽기전용 SELECT + 롤백전용 DRY-RUN(라이브 쓰기 0) · 2026-06-29
대상: `03_design/hardcover-book-{design.md,t_prd_product_sets.csv,t_prd_products.csv,apply.sql,blocked-board.csv}`
엔진: `raw/webadmin/webadmin/catalog/pricing.py`(evaluate_set_price:844 · evaluate_price:394 · component_subtotal:193 · derive_inner_sheets:820)

---

## 종합 판정 = **CONDITIONAL GO**

**셋트 구조 적재본(셋트 행 보정 + 내지 PRD_000284 신설)은 GO** → load-executor 적재 큐(인간 승인 후 COMMIT).
**가격 작동(PRICE≠0)은 BLOCKED** — 셋트공식 신설(PRF_BIND_HC_MUSEON)·구성원 PRF_DGP_A 바인딩·차원 충전이 dbmap/§18 트랙 인간 승인 선결. **정직한 BLOCKED**(공식 부재·신설 아닌 권위 전사)이므로 CONDITIONAL(가격 트랙만 제외·구조 적재는 진행).

단일 진성 FAIL 없음. 돈크리티컬(이중합산·band-total) 전부 안전 확증.

---

## S1~S7 게이트 판정표 (각 독립 재실측)

| 게이트 | 판정 | 재실측 증거 |
|--------|------|-------------|
| **S1 권위 충실성** | **PASS** | 셋트행 CSV(5행) ↔ 권위 booklet row38(표지1/내지필수24~300/+2/면지택1) 일치. 단가행 6개(30000/20000/14000/9000/7000/6000@PROC_000023) = 라이브 `COMP_BIND_HC_MUSEON` component_prices verbatim 일치(날조 0). |
| **S2 구성원 반제품 유형** | **PASS** | 라이브 실측: 072=PRD_TYPE.01(셋트 완제품)·073/074/075/076=PRD_TYPE.02(반제품)·내지 284 신설=.02. admin.py:1082 규칙(sub_prd_cd autocomplete=`PRD_TYPE.02`만·셋트 인라인=반제품 아닌 것에만) 정합. 완제품/기성/디자인 혼입 0. |
| **S3 복합PK/FK 무결성** | **PASS** | 현 072 셋트 복합PK 중복 0. DRY-RUN 후 5행 복합PK 유일·disp_seq 1~5 단조. FK 타겟 073~076 라이브 실재(del_yn=N). 내지 284 FK는 apply.sql 내 products INSERT 선행(2c~2e 전에 2b member, 1번 products INSERT가 최상단)으로 충족. min(1/24)≤sub_qty(1)·내지 24≤max300·incr2>0 정합. |
| **S4 가격 e2e [HARD]** | **BLOCKED(정당)** | ① 셋트공식 `PRF_BIND_HC_MUSEON` = 라이브 **미존재**(BIND 공식=MUSEON/PUR/SUM/TWINRING 4종만) → 셋트행만 적재 시 evaluate_price(072)=source NONE=0. ② 072·구성원 product-formula 바인딩 = 0행 → 현 PRICE=0. ③ **이중합산 0 확증**: PRF_DGP_A formula_components에 COMP_BIND_* 제본비 미포함(코팅/용지/인쇄/후가공만) → 제본비는 셋트공식에만. ④ prc_typ .01 ×qty 확증(component_subtotal:196 단가형=단가×수량, 셋트공식 qty=copies) → 제본비 권당×부수=의미상 정합(band-total false-positive 가드 정당). **판정: 공식 신설+차원 충전(인간 승인) 후 PRICE≠0 가능**. 부재는 진성 신설 1건이 아니라 **권위 단가행 실재·공식만 신설**(2층 구분 정확). |
| **S5 경쟁사/도메인 타당** | **PASS** | 하드커버무선 제본비 권당 9,000(수량50구간)·30000~6000 수량체감 = 권위 단가행 verbatim(경쟁사 흡수 아님·후니 권위 원천). naming/codes 외부 유입 0. |
| **S6 적재 가능성 DRY-RUN** | **PASS** | `BEGIN; \i apply.sql; ROLLBACK;` 제약위반 0. 멱등: 2회 적용 시 2nd pass 전부 `INSERT 0 0`(no-op UPDATE/DO NOTHING) delta 0. 예상 카운트 실증=INSERT 284(1)+set member 284(1)+UPDATE 073~076(disp_seq/min_max). ROLLBACK 후 284 미존재(라이브 쓰기 0). |
| **S7 생성≠검증 독립성** | **PASS** | 설계자 주장 인용 아닌 직접 재실측: 좀비자재(MAT_000002 아크릴 TYPE.20·MAT_000003 우드거치대 TYPE.17 라이브 바인딩 확인)·내지 284 미존재(MAX=PRD_000283)·이중합산 0(PRF_DGP_A comp 목록 직접 조회)·HC_MUSEON use_yn=Y(codex Q5 "논리삭제" 가설 라이브 반증 확증)·prc_typ.01(codex Q4 확증). codex reconcile 미해결 0(Q1~Q5 전부 라이브 확증/반증 종료). |

---

## 돈크리티컬 판정 (S4 상세)

- **이중합산 = 0 (안전)**: 제본비(COMP_BIND_HC_MUSEON)는 셋트공식에만, 인쇄/용지/코팅(PRF_DGP_A)은 구성원에만. PRF_DGP_A formula_components 라이브 조회로 제본 comp 부재 직접 확인. 같은 비목 중복 가산 없음.
- **band-total ×qty = false-positive (안전)**: 제본비 prc_typ=PRICE_TYPE.01(단가형). component_subtotal:196=단가×수량. 셋트공식 qty=copies(부수). 제본비 9,000×50권=450,000 → "권당 제본비×부수"가 의미상 정합. 메모리 bandtotal-x-qty-overcharge(명함/봉투 "완제품가" 밴드총액을 .01 오타이핑) 결함과 구조가 다름 — 제본비는 본질적으로 권당가이므로 .01 정상.
- **GUARD-1 면지 택1**: 면지 074/075/076 가격공식·차원 0 → 현 합산 오염 0. 단 향후 용지비 부여 시 3행 동시 members 평면합산 과대청구 위험 → 호출단 택1 1개 전달 계약 + CONFIRM-FACE 통합 권고 유지(설계 가드 타당).

## 확정 결함 → 교정 명세 (라우팅)

| 결함 | 권위 정답 | 교정 | 대상 t_* | 돈영향 | 라우팅 | 인간승인 |
|------|-----------|------|----------|--------|--------|----------|
| BLOCKED-FORMULA | 하드커버무선 제본비(단가행 6개 실재) | PRF_BIND_HC_MUSEON 공식 신설→COMP_BIND_HC_MUSEON 배선 | t_prc_price_formulas·formula_components | 제본비 0→정상 | §18/dbmap | Y |
| BLOCKED-INNER-DIM | 내지 디지털인쇄 PRF_DGP_A | 284에 PRF_DGP_A 바인딩+사이즈/공정/판형 차원 충전 | product_price_formulas·component_prices | 내지가 0→정상 | dbmap | Y |
| BLOCKED-COVER-DIM | 표지 PRF_DGP_A(전용지) | 073에 PRF_DGP_A 바인딩+차원 충전 | 동상 | 표지가 0→정상 | dbmap | Y |
| BLOCKED-MAT-REWIRE | 표지=전용지·면지=색지 | 좀비 MAT_000002/003 link 제거(마스터 삭제금지)+정자재 배선 | t_prd_product_materials | 무(견적 미관여)·정합 | dbmap/basecode | Y |
| CONFIRM-PAPER | 내지종이=별도설정(권위 공란) | 실무진 내지 종이 목록 확정 | — | 내지 용지비 권위 | human-실무진 | Y |
| CONFIRM-FACE | 면지 색상 택1 | 3행→1반제품+색상옵션 통합 여부 | t_prd_product_sets·option | GUARD-1 안전봉인 | human-정책 | Y |
| C-TRACK-ENGINE | — | S1/S2 silent 이중합산·band-total ×qty 코드결함(이 셋트엔 미적용·가드됨) | webadmin 코드 | 잠재 | 개발팀 | N |

## 적재 GO 큐 (load-executor·인간 승인 후 COMMIT)

`hardcover-book-apply.sql` (셋트 구조만):
1. t_prd_products INSERT PRD_000284 (내지 반제품·prd_typ.02).
2. t_prd_product_sets: 내지 284 member INSERT + 표지/면지 disp_seq·min/max UPDATE → 5행.

가격/자재/차원 트랙은 BLOCKED → dbmap/§18 별도 인간 승인.
