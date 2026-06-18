# 가격 클러스터: 통합/폐기/유지 제안 + STALE 정리

감사일: 2026-06-18 · **상태: 제안까지(실행·수정·삭제 금지).** 각 제안 = 근거 + 트레이드오프 + 영향(산출물·메모리·정의 파일).

원칙(사용자 directive): 이들은 사용자가 의도적으로 만든 레이어 → **통합은 신중**. 상보면 유지+경계 명확화, **진짜 중복만** 통합 제안.

---

## A. STALE 정리 (통합과 무관 — 노후 정정. 최우선)

### A-1. 🔴 [HIGH] dbm-price-engine-verify(스킬) + dbm-price-engine-verifier(에이전트) — 핵심 전제 STALE

- **STALE 내용**: 둘 다 "[HARD] 라이브 `evaluate_price` **미구현**·`raw/webadmin`에 `pricing.py` **부재**·ROADMAP Phase 11 미완 → 호출할 엔진이 없으므로 **명세 기반 재계산기 재구현**이 핵심"을 존재 명분으로 박음.
- **현재 사실(실측)**:
  - `raw/webadmin/webadmin/catalog/pricing.py` **실재**(26,951 bytes·2026-06-18 수정).
  - §13 메모리: "★엔진 라이브 직접 호출 성공(검증자가 임시 venv Django 부트스트랩→라이브 evaluate_price 자체 실행) → 'evaluate_price 미구현' **완전 STALE**·P1 동치입증 불요."
  - §15 메모리: hqv-quote-verifier가 "evaluate_price 실호출" 골든 재계산.
  - 출처: 메모리 `dbmap-price-engine-verify-round18.md`(Jun 14, 3일 전·시스템이 "outdated 가능" 경고)가 이 STALE 전제의 발원지.
- **권고**: **repurpose 또는 deprecate.** 두 경로:
  - (권장) **Repurpose → 전 상품군 사슬 완전성 실측 전용**으로 축소. "재계산기 재구현" 책무를 삭제하고, 재계산이 필요하면 §13 gate-validator/§15 quote-verifier의 **실호출**에 위임. 즉 C3(사슬 완전성·배선/단가행 실측)만 남기고 C8(독립 재계산)은 양보.
  - (대안) **Deprecate** — §13(대표 파일럿)·§15(단일 상품)가 사슬 실측+실호출을 모두 커버하면 별도 verifier 불요.
- **트레이드오프**: repurpose는 "전 상품군 횡단 실측"이라는 §7만의 너비(§13은 대표만·§15는 단일만)를 보존 → 권장. deprecate는 너비 상실 위험.
- **영향**: 정의 파일 2개(`dbm-price-engine-verify/SKILL.md`·`agents/huni-dbmap/dbm-price-engine-verifier.md`) · 메모리 `dbmap-price-engine-verify-round18.md`(STALE 표시 갱신) · 산출 `_workspace/huni-dbmap/26_price-engine-verify/`(기존 산출은 재계산 결과 포함 → 보존하되 "엔진 실호출로 대체됨" 헤더). dbm-validator PE1~PE6 게이트도 함께 조정.

### A-2. 🟡 [MED] prcx01-pricing-model.md / pricing-erd.md 인용 — 설계산출물 STALE

- **STALE 내용**: prcx01(LOCKED 260527)·pricing-erd는 **8차원·clr_cd·frm_typ_cd** 시절. 실제 = 14차원 진화(§14 메모리 F-1 [HARD]).
- **인용 현황(grep)**:
  - ✅ **FRESH(STALE 인지·가드 있음)**: `hpq-engine-cartography`("frm_typ 폐기됨·인용 금지") · `hqv-quote-verification`("v03/STALE(prcx01·pricing-erd) 인용 금지"·"도수=print_opt_cd, clr_cd dead") · `hped-mechanism-research`(prcx01을 `[확정·설계산출물]`로 분리·"코드 미확인 시 코드 확인 필요") · `dbm-price-formula-audit`("frm_typ_cd 라이브 부재 전제 vs price_views.py 실사용 모순 → 라이브 실측으로 결판" — 모순을 정면으로 다룸).
  - 🟡 **STALE 잔재(권위처럼 인용)**: `dbm-price-engine-verify`("계산 모델 = 11-CONTEXT + prcx01") · `dbm-price-engine-verifier`(동일) — A-1과 묶여 정정.
- **권고**: A-1 정정 시 함께 해소. 다른 §7 스킬은 이미 라이브 우선 가드 보유 → 손대지 말 것(scope discipline).

### A-3. 🟡 [MED] frm_typ_cd를 라이브 컬럼으로 단정 — 부분 STALE(미묘)

- **현황**: `dbm-price-import-prep`이 `t_prc_price_formulas`의 10-자연키에 `frm_typ_cd(.01 합산형/.02 단순형)` + `clr_cd`를 권위 컬럼으로 나열. `dbm-price-formula`도 `frm_typ_cd`를 적재 컬럼으로 사용.
- **사실의 미묘함**: §13 메모리 "frm_typ 폐기됨(공식=항상 합산)" vs `dbm-price-formula-audit`이 적발한 "price_views.py:234가 `frm_cd__frm_typ_cd == 'FRM_TYPE.01'`을 **실제 사용**" — **컬럼은 라이브에 실재하나 엔진 계약상 의미는 폐기 방향**. 즉 단순 STALE 아님(라이브 실측 필요한 모순).
- **권고**: **단독 정정하지 말 것.** `dbm-price-formula-audit`이 이미 "라이브 실측으로 결판" 책무를 가짐 → 그 결판 결과를 import-prep/formula에 반영하는 순서. 지금 임의 정정은 또 다른 오류 위험.
- **clr_cd**: import-prep의 10키에 `clr_cd` 잔존(§14 F-2: clr_cd=dead 0행·도수=print_opt_cd). 단 component_prices 자연키 컬럼으로는 라이브에 실재할 수 있음 → A-3과 동일하게 audit 결판 후 반영.

> ⚠️ CPQ 옵션 레이어의 "도수=opt_id (NOT clr_cd)"(dbm-cpq-option-mapping·dbm-option-mapper)는 **STALE 아님** — 가격엔진 도수(print_opt_cd)와 별개의 CPQ 옵션 축(fn_chk_opt_item_ref.06). 혼동 금지. 손대지 말 것.

---

## B. 통합/폐기/유지 후보

### B-1. ⛔ 유지 (통합 금지) — 검증 3종의 레이어 분화

| 하네스 | 유지 근거 | 고유 역량(다른 곳에 없음) |
|--------|----------|--------------------------|
| §14 hped | 검증조차 오판한 사건에서 태어난 선행 이해 레이어(F-2 도수축 오해) | C10 5장치 역할 원리 · C11 코드↔DB 속성 진단 · C12 아는것/모르는것 · C13 binding-validity |
| §13 hpq | 가격산정 4구조 동형 커버리지 게이트(P1~P7·생성≠검증) | C6 사이즈 중복 · 동형 확대 프레임 · 4구조 대표 파일럿 |
| §15 hqv | 단일 상품 온디맨드 진입점 + Codex 독립 교차 | C19 명령 해독 · C20 Codex 2nd opinion · reconcile |

- **트레이드오프(통합 시)**: 4구조 커버리지·온디맨드 UX·Codex 병행·선행 이해를 한 하네스에 합치면 단일 거대 하네스가 되어 "냉철한 생성≠검증 분리"가 무너짐(자기승인 위험). 사용자가 명시적으로 분리한 의도 역행.
- **결론**: **통합 비권장.** 대신 B-2(경계 명문화)로 중첩 해소.

### B-2. 📝 [MED] 경계 명문화 (정의 파일 description 보강 — 통합 아님)

진짜 중복은 아니나 산출 내용이 겹치는 두 쌍에 "내가 안 하는 것" 한 줄을 추가 제안:

| 대상 | 추가할 경계 문구(취지) | 근거 |
|------|----------------------|------|
| §13 hpq-engine-cartographer ↔ §14 hped-mechanism-researcher | cartographer="evaluate_price **계약 추출**(검증의 자)"·mechanism="장치 **역할 원리·왜·미지**(이해)". 서로 산출 복제 금지·인용만 | 쌍 A 겹침(C1/C10 30~50% 중첩) |
| §13 hpq(대표 파일럿) ↔ §15 hqv(단일 상품) | hpq="**동형 클래스 커버리지** 게이트"·hqv="**임의 단일 상품 온디맨드** + Codex". hqv는 hpq 미커버 상품 진입점 | 쌍 B 겹침 최대(C3/C5/C8/C13) |

- **트레이드오프**: description은 트리거 라우팅에 영향 → 문구 과하면 자동 호출 혼선. 최소 한 줄로.
- **영향**: 정의 파일 description만(본문 로직 무변경). 메모리 무영향.

### B-3. ✅ 유지 (모범 — 손대지 말 것)

- **dbm-price-arbiter 단일 심의 SOT**: §13·§15가 공유 도구로 호출(C18). 정립 심의를 한 에이전트에 모은 모범. 유지.
- **dbm-option-mapper(설계) ↔ hpq-option-constraint-mapper(검사)**: 생성≠검증 정석. 유지.
- **§7 dbm-price-formula-auditor / import-builder / formula**: 검증 하네스에 대응물 없는 정적정리·그릇분해·매핑설계(C15~C17). 완전 상보. 유지.

### B-4. ℹ️ 관찰 (조치 없음·기록만)

- **dbm-price-formula(round-2)** vs **dbm-price-import-prep(round-16)**: 둘 다 가격표→t_prc_* 평면화. round-16이 round-2를 "stale"로 명시 대체(import-prep description). 이미 자체 deprecate 관계 선언됨 → 별도 조치 불요. 단 A-3(frm_typ/clr_cd) 정정 시 둘 다 대상.

---

## C. 실행 우선순위 (제안만 — 실행 인간 승인)

| 순위 | 항목 | 유형 | 위험 | 효과 |
|------|------|------|------|------|
| 1 | A-1 dbm-price-engine-verify/verifier STALE 정정(repurpose→사슬실측 전용) | STALE+중복 | 중(메모리·산출 연쇄) | 高(핵심 노후 제거·D-2 중복 해소) |
| 2 | A-2 prcx01 인용 정정(A-1에 종속) | STALE | 저 | 중 |
| 3 | B-2 §13↔§15·§13↔§14 경계 명문화 | 중첩 명확화 | 저(description만) | 중(중복 검증 방지) |
| 4 | A-3 frm_typ/clr_cd — **dbm-price-formula-audit 결판 후** import-prep/formula 반영 | 부분 STALE | 중(섣부른 정정 위험) | 중 |

미실행 보류: B-1(통합 금지) · B-3(유지) · B-4(자체 deprecate).

---

## D. 한 줄 결론

가격 클러스터는 **의도적 상보 레이어**(이해 §14 → 게이트 §13 → 온디맨드 §15 → 적재 §7)로, 통합할 진짜 중복은 **단 하나** — `dbm-price-engine-verifier`(엔진 부재 전제 STALE → 실호출로 대체됨). 이것만 repurpose/deprecate하고, 나머지는 **경계 명문화 + STALE 토큰 정정**(prcx01·frm_typ는 이미 audit이 결판 책무 보유)으로 충분하다. 검증 3종 통합은 생성≠검증 원칙을 무너뜨리므로 비권장.
