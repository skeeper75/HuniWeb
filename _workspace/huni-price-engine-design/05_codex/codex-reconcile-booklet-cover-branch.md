# codex-reconcile-booklet-cover-branch.md — Codex ↔ hpe-validator(E1~E7) reconcile

> **hpe-codex-validate Phase 5.5.** Codex 독립 판정(`codex-verdict-booklet-cover-branch.md`)과
> hpe-validator E1~E7(`04_validation/gate-verdict-booklet-cover-branch.md`)을 항목별 대조.
> ★독립성: codex 프롬프트에 우리 E1~E7 판정 **미노출**(설계 사실+엔진계약+골든만) → codex가 독립 재도달.
> ★충돌 시 라이브/권위 우선·codex에 맞춰 자동 flip 금지. codex 단독주장=`미검증 가설`(채택 보류).

## codex 가용성 노트
**AVAILABLE · gpt-5.5 · read-only · effort=high · exit 0 · 토큰 31,323.** Claude 단독 폴백 아님.

---

## A. 합의 (고신뢰 확정) — 두 모델 독립 일치

| # | 항목 | hpe-validator(E1~E7) | Codex | 합의 결론 |
|---|------|---------------------|-------|-----------|
| **A1** | **표지 부모공식 직배선 단일 qty 충돌** | E4 CONDITIONAL·D-CB-3 High: "표지를 부모공식에 둠→단일 qty 충돌·표지 member 재설계가 엔진정합" | Q2 FAIL·"가장 큰 결함"·copies면 표지 절반 저청구/cover_sheets면 제본 2배 과청구 | ★**고신뢰 확정**. evaluate_price 단일 qty가 표지(cover_sheets)·제본(copies) 다른 qty를 동시 처리 못 함. **두 모델 독립 도달**(검증가=plate_qty ÷pansu 실측·codex=계약 추론). |
| **A2** | **cover_sheets가 tier 조회까지 변경(저청구 위험)** | E4 보정#2: "매수만 곱 아니라 tier도 cover_sheets로 조회·550 vs 350" | Q3 FAIL/돈크리티컬: "×2만이 아니라 tier 자체 변함·수량↑단가↓면 저청구" | ★**고신뢰 확정**. cover_sheets=100 적용 시 표지 단가 tier가 copies=50 기준과 달라짐. 권위 표지단가 tier 기준(부수 vs 출력매수) 대조 필요. |
| **A3** | **077/082 부모공식 0행=견적 0원(내지보다 선행 결함)** | E6 PARTIAL·D-CB-2 Critical: "표지+제본 전액 미산정·견적 0원·내지 누락만 강조는 부정확" | Q4 FAIL: "부모공식 0행이 1차 결함·내지는 2차·G-077 796,900 재현 불가" | ★**고신뢰 확정**. 077/082는 표지/제본/내지/부모공식 전부 0 → 견적 0원. 설계자 "내지 누락" 프레이밍을 두 모델 동일하게 교정. |
| **A4** | **068~071 부모공식=제본비만=저청구** | E2 PASS·D-CB-1 High: "제본비 comp 1개만 실측·표지/내지/용지 누락" | Q6 FAIL: "제본비만 청구·표지/내지 5비목 전부 누락 저청구" | ★**고신뢰 확정**. 라이브 실측. |
| **A5** | **TWINRING proc_cd 미주입 다중매칭 silent 합산** | E4 PASS·D-CB-4 Med: "4 proc_cd×8 tier=32행 실측·미주입 silent 다중매칭 위험 실재" | Q5-3: "4행 매칭·엔진 다중합산하면 4종 제본비 전부 붙는 silent overcharge·C6 필수" | ★**고신뢰 확정**. proc_cd=PROC_000021(082=024) 고정주입 선결. |
| **A6** | **분해형 표지 ×2는 이중계상 아님(단가 1매 기준 전제)** | E5 PASS·이중합산 0 | Q5-1: "단가 1매 기준 권위 맞으면 이중계상 아님" | **합의(조건부)**. 단 통합형 COVERBIND 혼용 시 double-count(A-divergence B2). |
| **A7** | **골든 068A/068B/071 주값 verbatim 정합** | E6 PASS: 158,688·+85,000·164,665 허용오차 0 | Q-D: G-071 정답의도 164,665 인정·산식 동일 | **합의**. 단가·산술 정합. |

## B. 불일치 (divergence) — 조사·해소·소유자

| # | 항목 | hpe-validator | Codex | 어느 쪽이 라이브/권위에 맞나 | 해소·소유자 |
|---|------|--------------|-------|------------------------------|-------------|
| **B1** | **COMP_PAPER 표지/내지 충돌** | E5 PASS: "frm_cd 분리(PRF_BIND_*_SET vs PRF_DGP_INNER) 실측→combo_key 충돌 없음" | Q5-2: "같은 공식 같은 COMP_PAPER 두 용도면 silent 합산/누락 위험" | ★**검증가 맞음(라이브 우선).** codex는 frm_cd 분리를 프롬프트에서 못 받아 일반론 위험을 제기. 라이브 실측=다른 frm_cd→같은 공식 2회 배선 아님→충돌 없음. **codex 위험은 라이브 사실에 반박됨.** | 자동 flip 금지·검증가 PASS 유지. codex 우려는 "표지/내지를 같은 frm_cd에 배선하지 말라"는 가드로 흡수(이미 설계가 분리). |
| **B2** | **072 double-count 가능성** | D-CB-6 Low·Q-CB-082: COVERBIND ×2 여부만 미결(072 자체는 정답 템플릿) | Q1-072 PARTIAL: "COVERBIND 표지포함인데 표지 별도배선하면 double-count" | **미결(권위 대조 필요).** 072는 COVERBIND 단일배선이라 현재 double-count 없음(검증가). codex 우려는 "표지를 추가배선하지 말라" 경고로 유효. | designer: 072/077/082 통합형에 분해형 표지 comp **추가배선 금지** 명시(이미 §2.1 ◆통합 표기). Q-CB-082 권위 대조로 해소. |
| **B3** | **종합 판정 라벨** | **조건부 GO(CONDITIONAL)** — 단일 FAIL 없음·E4/E6 보정 후 GO | **NO-GO/FAIL** — C2 그대로는 구현 불가 | ★**판정 프레임 차이지 사실 충돌 아님**(아래 §C). 두 모델 같은 결함을 봤으나 라벨 기준이 다름. | §C 해소: codex NO-GO를 채택해 **종합을 NO-GO(설계 데이터는 GO·엔진계약은 BLOCKED)로 격상**하는 것이 돈크리티컬에 안전. |

## C. ★종합 판정 라벨 divergence 해소 (B3)

- **검증가**: "단일 게이트 FAIL 없음 → NO-GO 아님 → 조건부 GO." E4를 CONDITIONAL로 분류하고 cover_mult를
  "C트랙(price_views.py) 정직 분류"로 봐서 설계 방향 건전 판정.
- **codex**: 동일 결함(단일 qty 충돌)을 보되 **"C2 그대로는 가격계산 가능 설계가 아니다 → NO-GO"**로 단정.
  codex는 "현행 엔진 계약으로 그대로 먹는가"를 더 엄격히 적용.
- **★해소 (라이브/엔진계약 우선·돈크리티컬 안전쪽)**:
  - 두 모델 모두 **cover_mult ×2가 현행 evaluate_price에서 그대로 작동 안 함**에 합의(A1).
  - 차이는 "이걸 보정 가능한 CONDITIONAL로 볼지 / 현 설계로는 불가한 NO-GO로 볼지"의 프레임뿐.
  - **권고: 데이터 설계(공식 바인딩·단가·골든)는 GO 유지하되, cover_mult ×2 실행은 NO-GO/BLOCKED로 명확히
    분리 격상.** codex가 "조건부 GO"의 모호함을 깨고 "C2는 못 먹는다"를 단정해준 것은 **돈크리티컬 가드 강화**.
    조건부 GO의 "보정하면 됨" 뉘앙스가 cover_mult ×2를 그대로 적재하게 두면 071/082 저·과청구 실재화.
  - **divergence 0 아님(라벨 1건)** — 단 사실 충돌 아닌 엄격도 차이. codex 쪽(더 엄격)을 채택해 안전.

## D. codex 신규 돈크리티컬 적발 (검증가 대비 추가)

| 신규# | codex 적발 | 신규성 | 채택 권고 |
|-------|-----------|--------|-----------|
| **N-CB-1** | **C2 부모공식 직배선은 "보정"이 아니라 "구현 불가"** — 해법 2택(엔진계약 확장 / 표지·제본·내지를 별 evaluate_price 호출로 분리) | 검증가는 "C트랙 or 표지 member 재설계"로 라우팅(보정 가능 뉘앙스)·codex는 직배선 C2 자체 불가 단정+분리 해법 명시 | ★**채택.** designer 폐루프로 "표지를 부모공식 직배선이 아닌 별도 단위(표지 member.qty=cover_sheets 또는 별 evaluate_price 호출)로 재설계" 명문화. |
| **N-CB-2** | tier 기준 혼동(copies tier vs cover_sheets tier)이 표지 단가 오선택→저청구 | 검증가 E4 보정#2와 같은 각도이나 codex가 "저청구 방향" 명시 | 합의(A2)에 포함·권위 표지단가 tier 기준 대조 컨펌큐 추가. |

**codex 신규 순수 적발(검증가 0건 누락) = 0건.** 검증가 E1~E7이 모든 돈크리티컬 경로를 이미 커버.
codex 기여 = ① 독립 합치로 5개 결함(A1~A5) **고신뢰 격상** ② 종합 라벨을 NO-GO로 끌어 cover_mult ×2
실행 BLOCKED를 명확화(N-CB-1).

---

## E. designer 폐루프 라우팅 (Phase 6)

1. **[Critical] cover_mult ×2 = 엔진계약 위반·현행 미지원** (A1·A2·N-CB-1) — designer가 C2(표지 부모공식
   직배선)를 **표지를 별 단위로 분리**(표지 member.qty=cover_sheets 주입 또는 별 evaluate_price 호출)로
   재설계. tier 조회 기준(부수 vs 출력매수)은 권위 표지단가 대조로 확정. → **종합 NO-GO(엔진계약 트랙)**.
2. **[Critical] 077/082 부모공식 0행** (A3) — "내지 누락" 프레이밍을 "부모공식 미바인딩(표지/제본/내지 전액 0=견적 0원)"으로 정정. dbmap mint(공식 바인딩+내지 member)·인간 승인.
3. **[High] 068~071 부모공식 표지/내지/용지 배선** (A4) — dbmap mint·인간 승인.
4. **[Med] 071/082 proc_cd 고정 주입** (A5) — AD-CB3 유지·선결 가드.
5. **[Low] 072/077/082 통합형에 분해형 표지 comp 추가배선 금지 명시** (B2) — double-count 가드.
6. **[가드 유지] COMP_PAPER 표지/내지 frm_cd 분리** (B1) — codex 우려에 대해 검증가 실측(frm_cd 분리) 유지·자동 flip 금지.

## F. 안전
codex `-s read-only`·비밀값 비노출·라이브 쓰기 0. codex 주장 = 가설(B1은 라이브 실측에 반박·자동 flip 안 함).
실 적용(부모공식 신설·내지 member mint·cover_mult 코드)은 DB 미적재·인간 승인 후 dbmap/§18/개발팀(price_views.py C트랙) 위임.
