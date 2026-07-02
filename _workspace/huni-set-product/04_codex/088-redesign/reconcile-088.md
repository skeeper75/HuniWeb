# reconcile — 088 레더 링바인더 재설계 · Claude 설계 ↔ codex 독립 판정

- 작성 2026-07-02 · hsp-codex-verifier · §23 Phase 3(088 단일)
- codex 가용: **YES**(gpt-5.5·effort high·read-only·rc=0) → Claude 단독 폴백 불요.
- 방법: codex에 Claude 판정 비노출(독립성)·설계+권위 데이터만 제공 → codex 독립 판정 수신 → Claude 설계와 대조 → 불일치·codex 신규 리스크는 라이브 읽기전용 SELECT로 3자 판정.
- ★codex 주장=가설 원칙: codex의 "확인 필요" 리스크를 라이브로 확증한 뒤에만 사실로 채택.

---

## 1. 합의/불일치 요약표

| 항목 | Claude 설계 | codex 독립 | 판정 |
|---|---|---|---|
| Q1 골든 1/10/100 (39,000/290,000/1,800,000) | GO(§7 골든) | GO(독립 재계산 3건 일치) | **합의** |
| Q1 밴드 lookup(10부=20000·100부=9000) | 하한 매칭 | `min_qty<=copies` 최대밴드 | **합의**(동일 규칙) |
| Q2 오구성(표지1+면지4·내지없음·전원 .02) | GO | GO(완제품 혼입0·누락0) | **합의** |
| Q3(a) 이중합산(표지=member089만·제본=부모만) | 이중합산 가드 0 | 이중합산 없음 | **합의** |
| Q3(b) COVERBIND 배선 제거 정당성 | 폐기(component 보존) | 정당(분리모델 필수) | **합의** |
| Q3(b) 부모공식 잔여 component | 단일(COVERBIND뿐→교체) | ★"확인 필요"(제공데이터로 미확인) | **불일치→3자 판정(§2-1)** |
| Q3(c) 싸바리 6밴드 verbatim | 일치 | 일치 | **합의**(라이브 재확인 §2-1) |
| Q3(d) 밴드 경계 해석 | 밴드10=20000/부 | 하한 매칭 정합 | **합의** |
| Q3(e) 표지 flat 단일밴드 100부=900,000 | 정상 | 정상(권위 단일가) | **합의** |
| Q4 복합PK·멱등·ON CONFLICT | GO | 대체로 타당(CONDITIONAL) | **합의**(조건 §2-2/2-3) |
| Q4 comp_price_id=MAX+1 동시성 | (명시 안 함) | ★Medium 리스크 | **불일치→3자 판정(§2-2)** |
| Q4 undo FK 대칭성 | 대칭 | Low(향후 참조 시) | **합의**(조건부·§2-3) |
| Q4 FK 고아(089·088·PROC098·SSABARI 실재) | 전제 실재 | 전제로 수용 | **합의**(라이브 재확인 §2-1) |
| Q5 false-positive(면지4·flat·proc격리·고아) | 가드 명시 | 동일 4건 정당 판정 | **합의** |
| 종합 | 설계 지지(GO·게이트 인계) | 설계 지지(조건부 사후검증) | **합의**(수렴) |

**합의 = 13항 · 불일치(조사 큐) = 2항** — 둘 다 라이브로 3자 판정 완료(아래).

---

## 2. 불일치·codex 신규 리스크 → 라이브 3자 판정 (읽기전용 SELECT 2026-07-02)

### 2-1. [codex High] 부모공식 잔여 component 확인 → ★RESOLVED (설계 지지)

- codex 우려: apply 후 `PRF_LEATHER_RINGBINDER_SET`에 `COMP_BIND_SSABARI` 외 잔여 가격 component가 남으면 오염(제공 데이터로는 미확인이라 "확인 필요" 표시).
- **라이브 실측**:
  ```
  t_prc_formula_components WHERE frm_cd='PRF_LEATHER_RINGBINDER_SET'
  → COMP_HC_MUSEON_COVERBIND | disp_seq 1 | addtn_yn Y   (단 1행)
  ```
- 판정: 부모공식 현 배선 = **COMP_HC_MUSEON_COVERBIND 단독 1행**. apply #6(COVERBIND DELETE) + #7(SSABARI INSERT) 후 = **COMP_BIND_SSABARI 단독 1행**. 잔여 오염 component **없음**.
- 3자 결론: codex 가설은 예방적 확인 요청이었고, 라이브가 **잔여 0을 확증** → Claude 설계(단일 교체) **지지**. 배선 오염 리스크 CLOSED.

- 부속 재확인(codex 전제·Claude 전제 라이브 대조):
  | 사실 | 라이브 결과 | 판정 |
  |---|---|---|
  | COMP_BIND_SSABARI 배선(고아) | 0건 | ✅ 고아 확증(이번에 부모 연결) |
  | COMP_BIND_SSABARI @ PROC_000098 밴드 | 30000/25000/20000/15000/9000/7000 | ✅ 권위 싸바리 grid verbatim 일치 |
  | PRD_000089 공식 바인딩 | 0건 | ✅ 신규 바인딩 안전 |
  | PRD_000088 proc | 0건 | ✅ PROC_000098 신규·격리 안전 |
  | COMP_LEATHER_RINGBINDER_COVER / PRF_LEATHER_RINGBINDER_COVER | 부재 | ✅ mint 필요(중복 0) |
  | PROC_000098 실재 | 싸바리바인더·use_yn=Y·del_yn=N | ✅ FK 안전 |
  | PRD_000088 셋트공식 바인딩 | PRF_LEATHER_RINGBINDER_SET | ✅ shell 재사용 대상 실재 |

### 2-2. [codex Medium] comp_price_id=MAX+1 동시성 → 저위험(수용·load-executor 조건)

- codex 우려: `MAX+1` 채번은 병렬 실행 시 PK 충돌 위험.
- 3자 판정: 본 트랙은 `t_prc_component_prices`에 IDENTITY/sequence 없음(기존 관례·메모리 [[dbmap-digitalprint-atomic-formula-unbuilt]] IDENTITY setval 함정) → MAX+1이 표준 패턴. 적재는 **hsp-load-execution 단일 트랜잭션 래핑·인간 승인 후 단독 실행**(병렬 적재 없음) → 실질 동시성 위험 **낮음**. NOT EXISTS 가드가 멱등 재실행도 보호.
- 결론: **비블로커**. 단 load-executor가 단일 세션·트랜잭션 내 실행 보장(관례 준수)만 조건.

### 2-3. [codex Low] undo FK 대칭 → 현 스코프 대칭(수용)

- codex 우려: apply 후 표지 component에 다른 참조가 생기면 undo의 component DELETE가 FK에 막힘.
- 3자 판정: undo는 표지 component 삭제(1역) 전에 배선(4역)·단가행(2역)·공식바인딩(5역)을 먼저 제거하는 역순 → 현 8행 스코프 내 **완전 대칭**. "향후 다른 상품이 COMP_LEATHER_RINGBINDER_COVER를 참조"하는 시나리오는 본 적재 스코프 밖(표지 전용 mint). 결론: **비블로커**(현 설계 대칭 확인).

---

## 3. Claude(codex-verifier) 추가 관측 — 게이트 인계 (codex 미지적·설계 미명시)

> codex 프롬프트엔 use_dims 전문이 요약만 담겨 codex가 못 본 지점. 라이브 실측으로 발견 → S-게이트 실증 인계(설계 결함 아님·"게이트에서 반드시 실증할 항목").

- **COMP_BIND_SSABARI use_dims = `["proc_cd","min_qty","proc_grp:PROC_000017"]`** (라이브 실측). 즉 이 component는 **3개 proc 밴드(무선/트윈링/싸바리)를 동시 보유**하며 `proc_cd` 차원으로 분기한다(라이브 18행 = 6밴드×3proc 확인).
  - → 설계 §2.5 옵션 오염 가드(**088 proc=PROC_000098 단독 선언**)가 **기능상 필수**임을 라이브가 뒷받침: 088에 PROC_000023(무선)·PROC_000024(트윈링)가 섞이면 잘못된 밴드가 silent 매칭될 수 있다. 현 라이브 088 proc=0 + apply #8 PROC_000098 단독 → 싸바리 밴드로만 매칭 = **설계 의도대로**.
  - ★단 use_dims의 **`proc_grp:PROC_000017` 차원**이 evaluate_set_price 실호출 시 어떻게 해석되는지(088에 proc_grp 선언이 별도로 필요한지)는 **정적 대조로 단정 불가** → **S-게이트가 evaluate_set_price 실재계산(webadmin 가격시뮬레이터 실화면 "제외 0·PRICE≠0" + 골든 39,000/290,000/1,800,000 재현)으로 반드시 실증**. 이게 최종 진실 게이트(정적 배선 GO ≠ 런타임 발현 GO).

---

## 4. 최종 의견

**설계 지지 (GO) — 게이트 실증 조건부.**

- codex와 Claude 설계가 **전 실질 항목 합의**(13/13 substantive), codex 신규 리스크 2건은 라이브 3자 판정으로 **전부 해소/비블로커**.
- 골든 3케이스 codex 독립 재계산이 사용자 기대와 정확 일치, 오구성·이중합산·배선 오염 **결함 0**, false-positive 오판 **0**(codex도 면지4·flat·proc격리·고아를 정당으로 확인).
- 라이브 실측이 codex의 유일 High 리스크(부모공식 잔여 component)를 **잔여 0으로 확증** → 설계의 단일 교체가 clean.

**게이트(hsp-set-gate S1~S8)에 인계할 미해소 실증 항목**(설계 수정 불요·런타임 실증만):
1. evaluate_set_price 실재계산으로 골든 39,000/290,000/1,800,000 재현 — 특히 `proc_grp:PROC_000017` 차원이 PROC_000098 단독 선언으로 싸바리 밴드에 정상 발현하는지(§3).
2. webadmin 가격시뮬레이터 실화면 "제외 0·PRICE≠0"[HARD·CLAUDE.md §1].
3. (관례) load-executor 단일 트랜잭션·단독 세션 실행(comp_price_id MAX+1 동시성 가드).

- ★codex 주장 채택 원칙 준수: codex의 모든 "확인 필요"는 라이브 확증 후에만 사실로 반영. 미확증분(런타임 proc_grp)은 게이트 실측 큐로 라우팅(pending 금지·본 verifier는 판정 아님).
