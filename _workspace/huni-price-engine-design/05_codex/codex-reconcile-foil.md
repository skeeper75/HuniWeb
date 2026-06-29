# codex-reconcile-foil.md — codex ↔ Claude validator(E1~E7) reconcile (박류 Phase 5.5)

> codex 독립 판정(`codex-verdict-foil.md`) ↔ Claude validator 기준선(`04_validation/gate-verdict-foil.md`·design-decisions-foil-rev2.md 반영분)을 항목별 대조.
> ★[HARD] codex 주장 = **가설**. 라이브/권위 독립 재확인된 항목만 "확정"으로 격상. 충돌 시 라이브 우선·codex에 맞춰 자동 flip 금지.
> **codex 가용성:** ✅ `gpt-5.5`·read-only·high (preflight `AVAILABLE model=gpt-5.5`). Claude 단독 폴백 아님.

---

## 1. reconcile 매트릭스

| 항목 | codex 판정 | Claude validator 기준선 | 일치 | 위상 |
|---|---|---|---|---|
| **권위 가격모델 해석**(동판비+박가공비·대형 면적매트릭스/소형 고정) | 정합 GO | E1 PASS(권위 verbatim) | ✅ **합의** | 고신뢰 확정 |
| **골든 8/8 산술** | codex 독립 재계산 8/8 일치 | E6 PASS(8/8 verbatim) | ✅ **합의** | 고신뢰 확정 — 두 모델 독립 재계산이 같은 값 |
| **addon 템플릿 부결 → 본체 공식 합산** | 타당(템플릿가=unit×qty 폭발·pricing.py:441) | E4 보정 B-FOIL-1(REV2 채택) | ✅ **합의** | 고신뢰 확정 |
| **박가공비 .02+min_qty ×qty 폭발 0** | 정합(pricing.py:205) | REV2 §5-4 가드 | ✅ **합의** | 고신뢰 확정 |
| **박가공비 proc_cd 게이트 → 박 미선택 시 0** | 정합(proc_cd 단가행 한쪽만 매칭) | REV2 §5-2 U-7 가드 | ✅ **합의** | 고신뢰 확정 |
| **면적→등급 환산 엔진 미지원** | 확정(NON_QTY_DIMS/TIER_DIMS에 grade 없음·pricing.py:41) | E4 B-FOIL-2(C트랙·고정사이즈 collapse) | ✅ **합의** | 고신뢰 확정 — C트랙 선결 |
| **G6 명함박 1,000원 갭 = 1셀 오적재** | 타당(라이브 63,000 vs 권위 64,000) | REV2 §4 1셀 오적재 확정 | ✅ **합의** | 고신뢰 확정 |
| **★동판비 setup comp에 proc_cd 게이트 없음 → 박 미선택 상시 과금** | **신규 결함**(use_dims 대형=[siz_w,siz_h]·소형=[]·proc_cd 부재·NULL=와일드카드 상시매칭·pricing.py:675) | **REV2 미적시** — §5-2 미선택0 보장이 박가공비(proc_cd 보유)만 다룸·동판비는 미적시 | ❌ **불일치(codex 단독)** | ★**조사항목 → 라이브 재실측으로 확정** (아래 §2) |
| **C-3/C-5 표 `.01` stale 표기** | 신규(표=.01·가드=.02 모순·구현자 표만 보면 ×qty 폭발) | REV2 §4-가드가 `.01→.02 정정` 명기하나 **본문 표 자체는 미수정** | △ **부분 불일치** | 문서 정합 결함(저위험·교정 권고) |
| **전체 적재 verdict** | NO-GO(setup 결함)·고정등급 상품 조건부 GO | E4 CONDITIONAL | △ **근사 합의·codex가 더 보수적** | codex 신규결함 해소 시 수렴 |

---

## 2. ★불일치 핵심 = 동판비 setup proc_cd 게이트 (codex 신규·돈크리티컬)

### 2-1. codex 주장
본체 공식 합산 설계에서 동판비 comp(C-1 대형 `use_dims=["siz_width","siz_height"]`·C-2 소형 `use_dims=[]`)에 **proc_cd가 없다.** `_row_matches`는 행 차원이 NULL이면 와일드카드(어떤 선택값이든 통과). 박을 안 고른 주문도 그 주문의 실제 사이즈(siz_width/height)에 동판비 tier행이 매칭 → **박 미선택 주문에 동판비(소형 5,000·대형 면적별 11,000~64,000)가 상시 청구.**

### 2-2. Claude 라이브 재확인 (이 reconcile에서 즉시 checkable 검증) — ✔ **확정**
- 설계 본문 실측: C-1 use_dims=`["siz_width","siz_height"]`·C-2 use_dims=`[]` — **proc_cd 없음 확인**(engine-design-foil.md:143·155).
- `pricing.py:99-111` `_row_matches`: `for d in NON_QTY_DIMS: rv=row.get(d); if rv is None: continue # 와일드카드` — **동판비 행에 proc_cd가 NULL이면 박 미선택(selections에 proc_cd 없음)이어도 통과 확인.**
- 대조: 박가공비 comp(C-3~C-6)는 use_dims에 `proc_cd` 보유 → 박 미선택 시 selections.proc_cd 부재로 no_match(0). **동판비만 게이트 누락.**
- REV2 §5-2 "박 미선택 시 0 보장"은 proc_cd 차원을 근거로 하나, 이는 박가공비에만 성립하고 **동판비 comp는 그 논거가 적용 안 됨**(proc_cd 부재). REV2가 동판비 게이트를 명시하지 않은 누락.
- ∴ **codex 신규 결함은 가설이 아니라 라이브 코드+설계 본문으로 재확인된 실 결함**(돈크리티컬·박 미선택 주문 상시 과금).

### 2-3. 해소·소유자
- **소유자:** engine-designer (REV3 보정) — 동판비 comp use_dims에 **proc_cd 추가**(`["proc_cd","siz_width","siz_height","proc_grp:PROC_000033"]` 대형·`["proc_cd","proc_grp:PROC_000033"]` 소형) 또는 동판비를 박가공비와 동일 proc_cd 게이트로 묶어 박 선택 시만 매칭. 명함박 SETUP_S1_STD가 라이브서 박 미선택 시 어떻게 0이 되는지 재실측해 동형 패턴 채택 권고.
- **재검증:** validator E4 재게이트(동판비 게이트 반영 확인) + 라이브 시뮬레이터로 "박 미선택 주문 = 동판비 0" 실증.
- **위상:** validator·codex 합의 전까지 박 설계 = **CONDITIONAL(동판비 게이트 미해소 시 NO-GO)**. 골든·권위·박가공비 트랙은 고신뢰 확정.

---

## 3. 합의 = 고신뢰 확정 (오케스트레이터 보고)
두 모델 독립 수렴(8축):
1. 권위 가격모델 해석 정합. 2. 골든 8/8 독립 재계산 일치(codex가 권위 CSV 셀 직접 추출). 3. addon→본체 합산 전환 타당. 4. 박가공비 .02+min_qty ×qty 폭발 0. 5. 박가공비 proc_cd 게이트로 박 미선택 0. 6. 면적→등급 환산 엔진 미지원→C트랙 선결(고정사이즈 collapse만 현 엔진 작동). 7. G6 명함박 1셀 오적재. 8. addon 템플릿가=unit×qty 폭발 부결 근거.

★ 두 모델이 같은 증거로 같은 결론 = 답습·합리화 위험 낮음(독립성 유지).

## 4. 조사항목 = 불일치 (해소 필요)
| ID | 항목 | 위상 | 소유자 | 해소 |
|---|---|---|---|---|
| **R-FOIL-CDX1** | 동판비 setup proc_cd 게이트 없음 → 박 미선택 상시 과금 | ★돈크리티컬·**Claude 라이브 재확인 완료(가설→확정)** | engine-designer REV3 | 동판비 use_dims에 proc_cd 추가·명함박 SETUP 동형 재실측·validator 재게이트+시뮬레이터 실증 |
| R-FOIL-CDX2 | C-3/C-5 본문 표 `.01` stale(가드는 .02) | 저위험·문서 정합 | engine-designer | 본문 표 .01→.02 수정(구현자 혼동 방지) |
| R-FOIL-CDX3 | `proc_grp:PROC_000033`이 코드상 매칭 차원 아님(차단력=proc_cd·dim_vals만) | 설계 표기 정밀화 | engine-designer | use_dims 표기에서 proc_grp의 역할을 "차단 차원 아님" 명기·실제 게이트=proc_cd로 일원화 |

---

## 5. 최종 위상
- **골든·권위·박가공비·면적등급 트랙**: codex↔validator 합의 → **고신뢰 확정**.
- **동판비 게이트(R-FOIL-CDX1)**: codex 독립 발굴 + Claude 라이브 재확인 = **실 돈크리티컬 결함 확정** → 박 설계 전체 verdict = **CONDITIONAL**(REV3 동판비 게이트 보정 + 재게이트까지). codex가 Claude validator E4 CONDITIONAL이 놓친 결함을 적발 = **생성≠검증·독립 2차 교차의 가치 입증**.
- DB 미적재 유지(실 COMMIT/DDL 인간 승인 후 dbmap 위임).
