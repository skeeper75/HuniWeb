# G2 렌즈 판정 — 가격·돈 (Claude)

> 대상: `_workspace/huni-worldmodel/04_design/design-FINAL.md` (2026-08-15)
> 잣대: `_workspace/huni-worldmodel/04_design/evaluation-rubric.md` v1.0 (사전등록)
> 렌즈: G2 — 가격이 틀릴 수 있는 경로 · LLM과 결정론 엔진의 책임 경계 · 오류 검출과 되돌리기
> [HARD] 규율: 5요건 미달 지적은 제출하지 않았다. 억지 개수 채우기 없음. 라이브 DB·`raw/webadmin` 읽기 전용(수정 0).

---

## 0. 요약

| 항목 | 값 |
|---|---|
| 제기 총건 | 3 |
| 확정 위반 주장 | MAJOR 1 · MINOR 2 |
| BLOCKER 주장 | **0** |
| 자동 각하한 자체 후보 | 1건 (§4 — 재현 실패로 스스로 철회) |
| 이 렌즈의 판정 후보 | **AMEND** (BLOCKER 없음, MAJOR 1건) |

가격 권위 경계(RULE-04), 제약×가격 결합(RULE-06), 사람 승인 게이트(RULE-14 ②)는 이 렌즈에서 **깨지지 않았다**(§3 대칭 규율). 유일한 MAJOR는 "돈 구멍을 어떤 관측으로 잡는가"의 **판정 입력 선택**에 있다.

---

## 1. OBJ-G2-01 · `zero_reason` 이분류가 실제 언더차지 경로 1종을 `TRUE_ZERO`로 오분류한다

- **위반 RULE-ID**: RULE-09 (불확실성의 가시화) · 주장 등급 **MAJOR**
- **겨냥 대상**: 설계 §4.3 `zero_reason` 판정표 (`design-FINAL.md:322-326`) 및 그것을 근거로 한 §8 RULE-09 충족 주장 (`design-FINAL.md:596`)

### (b) 실패 시나리오

- **입력**: 파일럿 상품 1종, 전 슬롯 확정. 그 상품의 가격공식에 **`dim_vals`(공정 상세 파라미터) 또는 `opt_grp:` 접두 차원으로만 구분되는 구성요소**가 1개 포함(예: 별색인쇄비 — 단가행이 `dim_vals={"spot_color_cnt":"2"}`만 보유). 고객이 그 축에서 단가행이 없는 값(예: 별색 3도)을 선택.
- **기대 결과**: 그 구성요소는 "단가행이 없어서 0원"이므로 `zero_reason=MISSING_PRICE_ROW`로 표시되고 `sim_escalation(PRICE_ROW_MISSING)`으로 라우팅된다(설계 §4.3 마지막 문단의 취지).
- **실제(예상) 결과**: 엔진은 `no_match`로 빠지고 `_no_match_detail`이 그 축을 보지 않으므로 `data_gap == []`이 된다(근거 (c)-1,2). 따라서
  1. 설계 §4.3 표 첫 행이 그대로 적용되어 `zero_reason = TRUE_ZERO` — **정당한 0원으로 라벨링**되고,
  2. `error`가 없으므로 `_FATAL_ERRORS`에 걸리지 않아 `mode="strict"`도 차단하지 않으며(근거 (c)-3),
  3. 차단 권위인 `_price_gap_errors`도 `data_gap`을 순회하므로 아무것도 잡지 않는다(근거 (c)-4).
  결과: `feasible=PROVEN_OK`, `price.confidence=CONFIRMED`, `zero_reason=TRUE_ZERO`인 **언더차지 금액**이 후보 1위로 제시되고, 어떤 플래그·큐·게이트에도 남지 않는다. G4(권위 격자 대조)가 그 셀을 커버하는 경우에만 사후 발견된다.

### (c) 근거

1. `raw/webadmin/webadmin/catalog/pricing.py:106-108` — `_row_matches`는 `NON_QTY_DIMS` 외에 **행의 `dim_vals` 키도 전량 일치**를 요구한다(와일드카드 없음). 즉 `dim_vals` 불일치가 `no_match`의 정당한 원인이다.
2. `pricing.py:599-614` — `_no_match_detail`은 `for d in use_dims: if d not in NON_QTY_DIMS: continue` (`:605-607`)로 **`NON_QTY_DIMS`에 없는 축을 전부 건너뛴다.** 또한 `:611-612`는 그 축의 행 값이 전부 NULL이면 갭으로 보지 않는다. → `data_gap`이 빈 `no_match`가 구조적으로 존재한다.
3. `pricing.py:651-659` — `m["row"] is None`(no_match) 경로는 `gap`이 비면 `data_gap`도 `note`도 채우지 않고 `error=None`인 채 반환한다. `pricing.py:69-76`의 `_FATAL_ERRORS`(6종)는 `no_match`(error=None)를 포함하지 않으므로 `pricing.py:528`(`if strict and fatal:`)의 strict 차단에 걸리지 않는다.
4. `raw/webadmin/webadmin/catalog/widget_api.py:489-490` — `_price_gap_errors`는 `for c in comps: for g in (c.get("data_gap") or [])` 로만 순회한다. `data_gap`이 비면 차단 후보가 생성되지 않는다. 이 함수의 docstring이 스스로 이 결함군을 *"아크릴 머리끈 500원 사고(260802)"* 로 명명하며(`widget_api.py:460`), **`data_gap`의 포괄 범위 한계를 직접 적어 두었다** — *"data_gap 은 '행이 실제로 구분하는 차원에 선택값이 있는데 그 값의 행이 없음'만 담는다 (미선택·와일드카드 차원은 애초에 안 잡힘 — pricing._no_match_detail)"*(`widget_api.py:462-463`). 즉 **엔진 소유자 자신이 `data_gap`을 "0원의 원인 판별기"로 쓰면 안 된다고 문서화해 두었고, 설계 §4.3은 정확히 그 용도로 쓰고 있다.**
5. 설계 `design-FINAL.md:322-326` — 판정표가 `data_gap`의 공/비공 이분으로만 구성되어 위 경로에 `TRUE_ZERO`를 할당한다. `design-FINAL.md:596`은 이 표를 근거로 RULE-09 ②를 "충족"으로 선언한다.

### (d) 자기 반증조건

- 설계 문서(또는 부속 명세)에 **`matched_row is None`인데 `data_gap`이 빈 경우**를 별도 값/플래그로 처리한다는 기술이 존재하면 이 지적은 철회된다.
- 또는 파일럿 상품 전수 스윕(G8/G4)에서 `included=False and data_gap==[] and error is None`인 구성요소가 **0건**으로 실측되면, 이 경로는 우리 데이터에서 실현되지 않으므로 지적을 NOTE로 강등한다. (현재 이 값은 **미측정**이며, 나는 라이브 조회를 하지 않았다 — 본 지적은 **엔진 계약과 설계 판정표 사이의 정합 결함**에 대한 주장이지 라이브 발생 규모에 대한 주장이 아니다.)

### (e) 교정 방향 (RULE-09를 어떻게 만족시키는가)

판정 입력을 `data_gap`의 공/비공 **이분**에서 `matched_row`의 존재 여부를 1차 축으로 하는 **삼분**으로 바꾼다. 우리 층 안에서만 끝나며 엔진 수정 0:

| 관측 (엔진 반환값) | `zero_reason` |
|---|---|
| `included=True` and `subtotal == 0` | `TRUE_ZERO` (실제 0원 단가행 매칭) |
| `matched_row is None` and `data_gap` 비어 있지 않음 | `MISSING_PRICE_ROW` |
| **`matched_row is None` and `data_gap` 비어 있음 and `error is None`** | **`UNMATCHED_NO_GAP`** (신규 — 매칭 실패 원인 미상) |
| `error in _FATAL_ERRORS` | 기존대로 `blockers[ENGINE_ERROR]` (strict가 차단) |

`UNMATCHED_NO_GAP`은 `sim_escalation(esc_kind='PRICE_ROW_MISSING')`로 라우팅하고, **`price.confidence`를 `PROVISIONAL`로 강등**한다(값은 여전히 엔진 것, 플래그만 우리 것 — RULE-04 불변). 추가로 G8의 분모에 "0원 구성요소의 `zero_reason` 분류 정확성"을 넣어 이 삼분류 자체를 기계 판정 대상으로 만든다.

---

## 2. OBJ-G2-02 · `as_of` 세션 핀은 G0.9 다이제스트가 감지할 수 없는 신선도 축이다

- **위반 RULE-ID**: RULE-13 ③ (판정 입력 신선도) · 주장 등급 **MINOR**
  - 등급을 MINOR로 두는 이유: RULE-13 ③의 `violation_test` 문언("라이브 재조회 규정이 없으면")은 설계 §8(`design-FINAL.md:600`)의 "확정 직전 라이브 재-SELECT" 규정으로 **문언상 충족**된다. 내가 지적하는 것은 규정의 부재가 아니라 **센서의 사각지대**이므로 위반 확정이 아니라 기록 대상으로 제출한다.

### (b) 실패 시나리오

- **입력**: 세션이 2026-08-15 23:50에 시작(`as_of`를 그 시각으로 핀 — `design-FINAL.md:421`). `t_prc_component_prices`에 `apply_ymd='2026-08-16'` 단가행이 **이미 적재되어 있다**(적재는 세션 이전에 끝났으므로 세션 중 행수·`max(upd_dt)` 변화 0).
- **기대 결과**: 00:05에 루프가 제시하는 금액과 위젯 `/price`가 계산하는 금액이 같다.
- **실제(예상) 결과**: 루프는 핀된 `as_of='2026-08-15'`로 굴려 구 단가 기준 금액(예 44,300원)을 제시한다. 고객이 확정하면 위젯 `/price`는 `as_of` 기본값 `date.today()='2026-08-16'`로 재계산해 신 단가(예 46,000원)를 낸다. **고객이 본 금액과 서명 금액이 갈린다.** G0.9는 `(행수, max(upd_dt))` 해시만 보므로(`design-FINAL.md:353`) 달력 경과를 원리적으로 감지하지 못한다 — 해시는 완전히 동일하다.

### (c) 근거

- `pricing.py:444` — `as_of = as_of or date.today().isoformat()` (위젯 경로의 기본값은 오늘).
- `pricing.py:147` — `if (r.get("apply_ymd") or "") <= as_of` : `as_of`가 단가행 유효집합을 직접 가른다.
- `design-FINAL.md:421` — `as_of` 핀을 "세션 시작 시각으로 고정"으로 명시(의도된 설계).
- `design-FINAL.md:353` — G0.9의 감시 대상은 `(행수, max(upd_dt))` 해시. 시각 자체는 입력이 아니다.
- `design-FINAL.md:574` — G6은 `/validate`·`/handoff` 리플레이로 **feasible/422 갈림만** 측정한다. 금액 갈림은 게이트 분모에 없다.

### (d) 자기 반증조건

- G0.9의 다이제스트 입력에 `as_of`(또는 판정 시각)가 포함된다는 기술이 설계 어딘가에 있으면 철회한다.
- 또는 `state_hash`가 `as_of`를 포함하고 날짜 경과 시 캐시가 무효화된다는 규정이 확인되면 철회한다(현행 `state_hash` 정의 `design-FINAL.md:269`는 `(prd_cd, selections, qty, opt_sels, proc_sels)`만 포함하며 `as_of`는 별도 필드 `:270`이다).

### (e) 교정 방향

G0.9 다이제스트 입력에 `as_of`를 넣고, `as_of != date.today()`가 되는 순간을 다이제스트 불일치와 동일하게 **판정 거부 + 재핀 + 재계산**으로 처리한다. 또는 G6 리플레이의 판정 항목에 "예측 금액 vs `/price` 재계산 금액 불일치 건수 = 0"을 추가해 갈림을 측정 대상으로 승격한다(현재 G4는 권위 격자 대조이지 위젯 경로 대조가 아니다).

---

## 3. OBJ-G2-03 · "금액 문장은 LLM을 아예 통과하지 않는다"는 자기 흐름도와 어긋난다

- **위반 RULE-ID**: RULE-01 (판정권 심볼릭 독점) · 주장 등급 **MINOR**
  - 등급 근거: RULE-01의 `violation_test`는 "LLM 노드 출력 화살표의 **도착지**"를 본다. `EXP`의 도착지는 `RG`(RenderGuard, 결정론 검증기)이므로 **위반판정 절차상 위반이 아니다.** 그러나 설계가 스스로 내건 더 강한 문장이 도면과 불일치하므로 기록한다.

### (b) 실패 시나리오

- **입력**: T5에서 `PhraseRenderer`가 `"무광코팅이면 44,300원이고 예산 안입니다."`를 생성.
- **기대 결과**(설계 §3 읽는 법 2, `design-FINAL.md:203`): 이 문장은 LLM을 통과하지 않고 화면에 도달한다.
- **실제(예상) 결과**: 도면상 경로는 `PICK --> PR --> EXP --> RG --> CUST`(`design-FINAL.md:178`)이므로 렌더된 금액 문장이 Explainer LLM의 입력·출력 구간을 지난다. LLM이 `44,300` → `43,300`으로 변형하면 RenderGuard가 서버 토큰 대조에서 걸러(`:129` fail-closed) **금액 오류는 발생하지 않지만**, 정당한 후보가 화면에 도달하지 못하는 오차단이 발생한다. 즉 손해는 금전이 아니라 가용성이다.

### (c) 근거

- `design-FINAL.md:178` — `PICK --> PR --> EXP --> RG --> CUST(["고객 화면"])` (직렬 체인).
- `design-FINAL.md:203` — *"금액이 들어간 문장은 LLM을 아예 통과하지 않는다"*.
- `design-FINAL.md:509-511` — T5 서술은 두 문장이 **분리**되어 있음을 전제(PhraseRenderer 금액 문장 / Explainer 비금액 문장)로 읽힌다. 즉 도면과 산문 중 하나가 부정확하다.

### (d) 자기 반증조건

도면의 `PR --> EXP` 간선이 "문자열 전달"이 아니라 "슬롯 분리 후 병렬 렌더"임을 명시하는 기술(또는 `PR --> RG` 직결 간선)이 설계에 있으면 철회한다.

### (e) 교정 방향

도면을 `PICK --> PR --> RG` 와 `PICK --> EXP --> RG` 두 갈래로 분리하고, RenderGuard 규약에 "금액 토큰은 PR 출력에서만 유래하며 EXP 출력 문자열에 숫자가 포함되면 그 자체로 fail"을 명문화한다. 이렇게 하면 §3의 강한 문장이 도면과 일치하고, RULE-01 방어선이 도면 수준에서 자명해진다.

---

## 4. 스스로 각하한 후보 (오판 방지 기록)

| 후보 | 각하 사유 |
|---|---|
| "Scorer 정렬 키가 `price.amount = None`(차단 후보)과 `int`(가능 후보)를 섞어 `TypeError`를 낸다 → RULE-13 ① 미명시 예외 지점" | **재현 실패(FP-3 자기 적용).** 정렬 키 튜플의 첫 원소가 `feasible` 이분(`design-FINAL.md:363`)이라 가능/차단 후보는 index 0에서 이미 갈리고 index 5(`price.amount`)까지 비교가 내려가지 않는다. 차단 후보끼리는 양쪽 모두 `None`이므로 `==` 비교로 통과한다. 실패 시나리오가 성립하지 않아 제출하지 않는다. |

이 기록을 남기는 이유는 루브릭 §4(오판 감사 의무)가 검증자도 측정 대상으로 삼기 때문이다.

---

## 5. 대칭 규율 — 설계가 규칙을 잘 만족하는 지점

### S1. 확정 금액 권위가 실제로 단일하다 (RULE-04)

설계는 루프의 산출물을 "selections 집합"으로 한정하고 확정 금액은 위젯 `/price` 라이브 재계산 + `/handoff` 인간 확인에 남긴다(`design-FINAL.md:439-443`). 나아가 §12-3(`:777`)이 *"금액에 산술 연산을 하지 않는다"* 를 명문화했고, C 원안이 what-if에 쓰겠다던 `only_comps` 부분 합산 금액의 고객 노출을 **철회**했다(`:422`). 이것이 중요한 이유는 부분 합산이야말로 두 번째 금액 권위가 생기는 전형적 경로이기 때문이다 — 설계가 그 유혹을 스스로 잘라냈다. `evaluate_price` 시그니처(`pricing.py:436`)에 `only_comps`가 실재함을 확인했으므로 이 절제는 실효적이다.

### S2. `_price_gap_errors`를 재구현하지 않고 호출만 한다 (RULE-04 · RULE-12)

설계 §2.3(`:110`)과 §5.3(`:438`)은 A안의 `t_wm_support_tuples`(price_gap 판정기 외부 재구현)를 명시적으로 기각하고 호출만 한다. 나는 그 근거를 직접 확인했다 — `widget_api.py:456-477`의 docstring은 `proc_cd` 제외 사유와 **가족형 쌍 면제(260805 오리지널박명함)** 규칙을 함수 본문 주석으로만 보유하며, 마지막 줄이 *"한쪽만 고치면 미리보기·임베드가 갈린다"* 라고 적고 있다. 이 도메인 지식은 밖에서 재현 불가능하다. 설계의 판단이 코드 사실과 정확히 일치한다.

### S3. 제약 위반 조합의 가격이 **자료구조상** 존재하지 않는다 (RULE-06)

`design-FINAL.md:306` — `feasible != "PROVEN_OK"` ⇒ `price.amount`가 스키마상 `None`. 경고를 붙이는 방식이 아니라 필드를 없애는 방식이며, G2(`:570`)가 `jq 'select(.feasible!="PROVEN_OK" and .price.amount!=null)'`로 그 성질을 **기계 판정**한다. 임계가 0건이고 분모가 명시돼 있다. 돈 렌즈에서 이것이 가장 단단한 지점이다.

### S4. 실패 시 "무엇을 버리는가" 열이 게이트표에 있다 (RULE-05)

`design-FINAL.md:563-577` 게이트표의 마지막 열은 임계 미달 시 재설정이 아니라 **폐기 대상**을 지정한다 — G7 p95 > 2s면 §6 종단 시나리오 폐기(`:575`), G4 엔진 오차면 전면 중단(`:572`), G5 실패면 confidence 축 폐기(`:573`). 종료 척도가 "개선하겠다"가 아니라 "여기서 죽는다"로 쓰인 설계는 드물다.

### S5. `mode="strict"` 고정의 근거가 코드 사실과 일치한다 (RULE-09 · RULE-13)

설계는 `evaluate_price`의 기본값이 `lenient`임을 근거로 호출 규약에서 strict를 강제한다(`:420`). 나는 `pricing.py:428`에서 기본값 `mode="lenient"`를, `pricing.py:69-71`에서 `_FATAL_ERRORS = {ambiguous_combo, duplicate_rows, below_min_qty, above_max_size, no_tier_row, no_plate}`를, `pricing.py:528`(`if strict and fatal:`)에서 strict 차단 분기를 직접 확인했다. 즉 strict 고정으로 **6종 언더차지 경로가 실제로 차단된다** — 설계의 P-06/P-07 대응은 실효적이다. OBJ-G2-01은 이 6종이 아니라 그 **바깥의 1종**(error 없는 no_match)에 대한 지적이며, 그 구분을 흐리지 않기 위해 여기 명시한다.

### S6. 8번 항목 — `evaluate_price` 예외 시 0원 대체 금지의 명문화 (RULE-13 ①)

`design-FINAL.md:622` — 엔진 예외 시 `price.amount=None`을 강제하고 *"0원 대체 절대 금지"* 를 못 박았다. 예외를 0으로 흡수하는 것이 이 도메인 언더차지 사고의 공통 형태(`widget_api.py:458-461`)이므로, fail-open을 승계하지 않겠다는 선언이 구체적 금지 문언으로 착지한 것은 정확한 조치다.

---

## 6. 이 판정의 한계

1. **라이브 DB를 조회하지 않았다.** OBJ-G2-01의 발생 규모(해당 구성요소가 288 상품 중 몇 개인가)는 미측정이다. 본 지적은 엔진 계약과 설계 판정표 사이의 정합에 대한 주장이며, 라이브 발생 건수에 대한 주장이 아니다(루브릭 §2.3 J-5 회피).
2. **웹 검색 미사용** — 저장소 내부 파일만 근거로 했으므로 `Sources:` 절을 두지 않는다.
3. **G2 렌즈 범위 밖은 판정하지 않았다** — 조합폭발 기법의 작동성(RULE-08), 층 귀속(RULE-18), 선행 자산 정합(RULE-15)은 다른 렌즈 소관으로 남긴다.

---

## 7. 판정 기록

```
설계안: 04_design/design-FINAL.md (2026-08-15)
루브릭: 04_design/evaluation-rubric.md v1.0
렌즈:   G2 (가격·돈) / Claude
제기:   3건 (자체 각하 1건 별도 기록)
확정 위반 주장: BLOCKER 0 · MAJOR 1 (RULE-09) · MINOR 2 (RULE-13 ③, RULE-01)
이 렌즈 판정 후보: AMEND
```
