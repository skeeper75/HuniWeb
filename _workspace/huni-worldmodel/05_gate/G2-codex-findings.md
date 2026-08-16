# G2 렌즈(가격·돈) — codex 독립 교차검증 결과

> 트랙 `huni-worldmodel/05_gate` · 렌즈 **G2 = 가격이 틀릴 수 있는 경로 / LLM↔결정론 책임 경계 / 오류 검출·되돌리기**
> 검증자: **codex-cli `gpt-5.5`, `model_reasoning_effort=xhigh`, `-s read-only`** (독립 반증자)
> 심사 대상: `_workspace/huni-worldmodel/04_design/design-FINAL.md`
> 사전등록 루브릭: `_workspace/huni-worldmodel/04_design/evaluation-rubric.md` v1.0 (RULE-01~18)
> 원문: `05_gate/_codex/G2-verdict.txt` (전체 전사 15,286줄 / 최종 판정 발췌 `_codex/G2-verdict-final.txt`)
> 프롬프트: `05_gate/_codex/G2-prompt.txt` — **우리 판정·점수·승자 정보 비노출**(독립성 담보)
>
> **[HARD] 이 문서의 성격**: 나(Claude)는 판정자가 아니다. codex 의 지적을 받아 적고, codex 가 인용한
> `파일:라인`을 **원본에서 직접 재확인**한 결과를 함께 적는다. codex 출력은 재확인 전까지 **가설**이며 사실이 아니다.
> 최종 등급 판정(REJECT/AMEND/NOTE)은 이 문서가 내리지 않는다 — 루브릭 §3·§4 절차에 따라 게이트가 내린다.

---

## 0. 실행 기록

| 항목 | 값 |
|---|---|
| 실행 커맨드 | `.claude/skills/hqv-codex-cross-verify/scripts/codex-review.sh G2-prompt.txt gpt-5.5 /Users/innojini/Dev/HuniWeb xhigh` |
| 종료코드 | **0 (정상)** — `codex_available = true`, Claude 단독 폴백 불필요 |
| `G2.err` | **0 byte** (경고·폴백 없음) |
| codex 소비 토큰 | 400,931 |
| 제기 지적 총건 | **4건** (BLOCKER 2 · MAJOR 2) |
| codex 자백한 미확인 | 라이브 DB/HTTP 미호출 · `simcore` 구현 파일 부재(설계 문서 주장 기준 판단) · 내장 렌더러는 금액을 숨긴다는 점을 스스로 명시 |

---

## 1. 지적 요약표 (재확인 결과 포함)

| ID | RULE | codex 주장 등급 | 요지 | 근거 재확인 | 심리요건 5항 |
|---|---|---|---|---|---|
| OBJ-01 | RULE-01 | BLOCKER | LLM Actor 가 `qty`·`budget_krw`를 **숫자 값으로** 산출하고, 결정론 재파싱 규정이 없다 | **인용 전건 실재 확인** | 충족 (규칙 해석 쟁점 있음) |
| OBJ-02 | RULE-04 | BLOCKER | `Outcome.price.amount`가 **공급가/청구액(VAT 포함) 구분 없이** 정의됨 → 예산 판정·고객 문구가 공급가 기준, 서명액은 VAT 포함가 | **인용 전건 실재 확인** | 충족 (RULE-ID 매핑 쟁점 있음) |
| OBJ-03 | RULE-06 | MAJOR | 재사용 선언한 live `/price`는 `price_gap` 차단 시에도 금액 필드를 지우지 않아 `huni:state.price.total`로 호스트에 새어나감 | **인용 전건 실재 확인** | 충족 (J-3 경계 쟁점 있음) |
| OBJ-04 | RULE-13 | MAJOR | `PREMISE_FAIL`이 `sim_escalation.esc_kind` 허용 집합·`route_to` 표에 없다(문서 내부 불일치) | **인용 전건 실재 확인** | 충족 (등급 쟁점 있음) |

**근거 오인용(FP-2 후보) 0건** — codex 가 인용한 8개 파일의 라인을 전수 재확인했고, 전부 인용 내용을 실제로 담고 있었다.

---

## 2. 지적별 상세 — codex 원문 + 나의 재확인

### OBJ-01 · RULE-01 (BLOCKER 주장) — LLM 이 수량·예산을 값으로 만든다

**codex 원문(발췌)**

> 설계는 LLM Actor 가 `qty`와 `budget_krw`를 숫자 값으로 담은 `Intent`를 만들게 한다. `IntentValidator`는 타입·도메인·원문 span 대조만 적고, 숫자 재파싱 권위를 결정론 파서에 둔다는 규정이 없다.
> 실패 시나리오: 입력 = "명함 500장, 고급스럽게, 예산 5만원" / 기대 = 결정론 파서가 원문에서 `qty=500`을 산출하거나 불일치 시 되묻기 / 실제(예상) = Actor 가 `qty=5000`을 내면 int 검증을 통과하고 `evaluate_price(..., qty)`가 그 수량으로 가격을 계산한다.
> 내가 틀렸다면: 설계에 `utterance_span`을 결정론 숫자 파서가 재해석하고 불일치 시 fail-closed 한다는 절이 있으면 철회.

**나의 재확인 (원본 대조)**

| codex 인용 | 재확인 결과 |
|---|---|
| `evaluation-rubric.md:57-59` | **실재.** RULE-01 violation_test (a) = *"LLM 출력이 금액·수량·코드값을 **직접 값으로** 산출하는 경로가 존재한다"* (`evaluation-rubric.md:59`) |
| `design-FINAL.md:243-256` | **실재.** `"qty": int \| UNKNOWN`(`:245`), `"budget_krw": int \| None`(`:255`) — Intent 필드가 숫자 값 그대로다 |
| `design-FINAL.md:260-263` | **실재.** 검증 항목은 ①도메인 출처 ②UNKNOWN 센티널 ③`IntentValidator` 1지점. `:263`은 *"`utterance_span`… LLM 이 없는 값을 만들어냈는지 **원문 대조**로 잡는다"* — **span 존재 대조이지 숫자 재파싱이 아니다.** codex 의 자기반증조건(결정론 숫자 재파서 절)은 **문서에 없음을 확인** |
| `design-FINAL.md:469-479` | **실재.** T0 `qty: 500`·`budget_krw: 50000`이 Actor 산출물이고, T1 검증은 *"`qty=500`이 int 인지"*(`:479`)까지다 |
| `pricing.py:428-451` | **실재.** `def evaluate_price(target, selections, qty, …)` — `qty`가 그대로 가격 계산 입력 |

**쟁점(오판 후보 FP-4 · §4.2)**: RULE-01 은 violation_test 에 **판정 절차**를 함께 규정한다 — *"LLM 노드의 출력 화살표 도착지를 전수 추적한다. 도착지가 `evaluate_price`/제약엔진/**스키마 검증기**가 아닌 것이 1건이라도 있으면 위반"*(`evaluation-rubric.md:59`). 설계에서 Actor 의 화살표 도착지는 `IntentValidator`(스키마 검증기)이므로 **이 절차로는 통과**한다. codex 는 절차가 아니라 **선행 문언 (a)** 를 적용했다. 루브릭 §5-2 가 *"`violation_test`의 기계 판정성은 균일하지 않다… 해석이 갈리면 다수결이 아니라 규칙 문언 해석으로 결정하며, 해석이 갈린 사실 자체를 기록에 남긴다"*(`evaluation-rubric.md:321`)고 규정했으므로 **해석 분기 사실을 여기 기록한다.**

**돈 렌즈에서의 실질**: 등급 다툼과 무관하게, *"LLM 이 만든 수량이 타입 검사만 통과하면 그대로 과금 수량이 된다"*는 경로는 **실재**한다. 설계 §12-14(`design-FINAL.md:788`)는 *"LLM 에게 금액·가능여부·판걸이수 판정 권한을 주지 않는다"*고 선언했으나 **수량은 그 목록에 없다.**

---

### OBJ-02 · RULE-04 (BLOCKER 주장) — 공급가/청구액(VAT) 미분리

**codex 원문(발췌)**

> 설계의 `price.amount`는 `evaluate_price.final_price`인지, 고객 청구액(VAT 포함)인지 정의하지 않는다. live widget 은 `evaluate_price` 결과를 공급가로 보고 VAT 10%를 더해 `payload.total`을 서명한다. 공급가 기준 예산 통과가 청구액 기준 예산 초과가 되는 돈 오류 경로다.
> 실패 시나리오: `final_price` 49,000원 후보 / 기대 = 고객이 실제 낼 53,900원 기준 예산 초과 판정 / 실제(예상) = 설계는 49,000원으로 `budget_penalty`와 "예산 안입니다" 문구를 만들고 `/handoff`는 53,900원을 서명한다.

**나의 재확인 (원본 대조)**

| codex 인용 | 재확인 결과 |
|---|---|
| `design-FINAL.md:284-286` | **실재.** `"price": { "amount": int\|None, "confidence": …}` — **VAT 포함 여부 정의 없음** |
| `design-FINAL.md:366-368` | **실재.** Scorer ③ `budget_penalty(price, intent.budget_krw)` — 기준 금액이 `price.amount` |
| `design-FINAL.md:508-513` | **실재.** T5 `"{opt_label}이면 {amount:,}원이고 예산 안입니다."` → *"무광코팅이면 44,300원이고 예산 안입니다."* — **고객에게 보이는 문구가 `amount` 기준** |
| `widget_api.py:1150-1157` | **실재.** `VAT_RATE = Decimal("0.1")` + 주석 *"저장 단가=공급가(부가세 별도), 청구액=공급가+VAT (G1)"* (`widget_api.py:1150`) |
| `widget_api.py:1855-1859` | **실재.** `/handoff`: `supply = total; vat = _vat(supply); total = supply + vat` + 주석 *"서명 total 을 부가세 포함가로 맞춰 화면 합계(=청구액)와 서명가를 일치(언더차지 방지)"* |
| `widget_api.py:1942-1944` | **실재.** 서명 payload 에 `"supply"`, `"vat"`, `"total"`(=청구액) 3필드 |

추가로 내가 직접 확인한 것: `_filter_single`(`widget_api.py:1195-1219`)이 `ok`일 때만 `out["supply"], out["vat"], out["total_with_vat"]`를 채운다(`widget_api.py:1216-1219`). 즉 **라이브 계약은 공급가/부가세/청구액 3분리가 이미 확립되어 있고, 설계의 `Outcome.price`만 1필드다.**

**쟁점(FP-4 후보)**: RULE-04 violation_test 는 (a) *"`evaluate_price` **외의 경로**가 확정 금액을 산출"* (b) 온톨로지·KB 가 가격 값 계산 (c) `raw/webadmin`·`pricing.py` 수정 — 세 가지다. 설계의 `price.amount`는 `evaluate_price` 반환값의 전재이므로 세 문언 어디에도 **직접** 걸리지 않는다. 다만 같은 규칙의 단서 *"화면 노출 시 확정가와 구분 표기해야 함 — 미구분이면 위반"*(`evaluation-rubric.md:88`)이 **공급가를 확정가처럼 노출하는 이 경로에 유추 적용 가능한지**가 해석 쟁점이다. **등급은 게이트 소관이며, 이 문서는 근거 실재만 확정한다.**

**돈 렌즈에서의 실질**: 이 지적은 4건 중 **금전 오차가 가장 크고 가장 구체적**이다 — 고객 대면 문장이 실제 청구액보다 **정확히 10% 낮게** 나가는 경로이며, 설계 어디에도 이를 재는 게이트가 없다(G4 는 권위 격자 금액 대조, G6 는 422/통과 대조이지 **VAT 정합 대조가 아니다** — `design-FINAL.md:572,574` 재확인).

---

### OBJ-03 · RULE-06 (MAJOR 주장) — 차단된 조합의 금액이 호스트로 새어나간다

**codex 원문(발췌)**

> simcore `Outcome`은 막힌 조합에 금액이 없게 되어 있지만, 그대로 재사용하겠다는 live `/price` 경로는 `price_gap` 발생 후에도 이미 만든 금액 필드를 지우지 않는다. 내장 렌더러는 `ok:false`에서 금액을 숨기지만, 공개 `huni:state`/`getStatus()`는 실패 응답의 `price.total`을 호스트 페이지로 내보낼 수 있다.

**나의 재확인 (원본 대조)**

| codex 인용 | 재확인 결과 |
|---|---|
| `design-FINAL.md:306` | **실재.** 성질 1 — *"`feasible != "PROVEN_OK"`이면 `price.amount`는 스키마상 반드시 `None`"* |
| `design-FINAL.md:434-443` | **실재.** §5.3 *"`POST /price` 그대로 둔다. 확정 금액은 여전히 위젯이 라이브 재계산"* |
| `widget_api.py:1195-1219` | **실재.** `_filter_single`이 `total`/`supply`/`vat`/`total_with_vat` 채움 |
| `widget_api.py:1296-1303` | **실재.** `_gaps = _price_gap_errors(res, prd_cd)` → `out["ok"] = False; out["code"] = "price_gap"` — **금액 필드는 지우지 않는다**(nulling 코드 없음, 직접 확인) |
| `widget.js:241-246` | **실재.** `el._lastPrice = { ok: !!d.ok && supply != null, total: total, supply: supply, vat: vat }` — `ok:false`여도 `total` 보존 |
| `widget.js:345-351` | **실재.** `_statePayload()` → `{canOrder, reasons, price: this._lastPrice \|\| null}` (huni:state · getStatus · canOrder 공용) |
| `widget_renderer.js:3378-3382` | **실재.** `if (!norm \|\| !norm.ok \|\| norm.total == null) { … "— 원" }` — **내장 화면은 숨긴다**(codex 스스로 이 반례를 명시했다 — 정직성 가점) |

**쟁점(J-3 · 하네스 경계)**: 결함의 소재는 **설계가 신설한 코드가 아니라 기존 위젯 경로**다. 설계 §12-12 는 *"위젯 렌더러/클라이언트 캐스케이드를 건드리지 않는다(P-21, 위젯 트랙 소유)"*(`design-FINAL.md:786`)를 명시적 비목표로 선언했고, 루브릭 §2.3 J-3 은 *"다른 트랙이 소유한 작업을 이 설계가 안 했다는 지적"*을 자동 각하한다(`evaluation-rubric.md:189`). **다만 codex 의 지적은 "고쳐라"가 아니라 "설계의 P-03 해결 주장(`design-FINAL.md:41`)이 simcore 내부에 한정됨을 문서가 밝히지 않았다"는 주장 범위 비판**으로 읽을 수 있다. 설계는 실제로 `:41`에서 **"해결(우리 층 안에서)"** 이라고 한정 표기했으므로, 이 부분은 설계 측 취하 사유(§3.4)가 될 소지가 있다. **판단은 게이트 소관.**

---

### OBJ-04 · RULE-13 (MAJOR 주장) — `PREMISE_FAIL`이 스키마에 없다

**codex 원문(발췌)**

> 설계는 G0/G0.5/G0.9 전제 감시 실패를 `sim_escalation(esc_kind='PREMISE_FAIL')`로 남긴다고 하지만, `esc_kind` 허용 집합과 `route_to` 매핑에는 `PREMISE_FAIL`이 없다.

**나의 재확인 (원본 대조)**

| codex 인용 | 재확인 결과 |
|---|---|
| `design-FINAL.md:386-399` | **실재.** `:389` — `esc_kind ∈ {PRICE_ROW_MISSING, TMPL_COMBO_UNREGISTERED, PANSU_PROVISIONAL, ANCHOR_MISSING, AFFECT_UNDEFINED, REACH_UNKNOWN}`. `:394-399` route_to 매핑표에도 **PREMISE_FAIL 없음** |
| `design-FINAL.md:467` | **실재.** T-1 — *"그 사실이 `sim_escalation(esc_kind='PREMISE_FAIL')`로 남는다"* |
| `design-FINAL.md:565-568` | **실재.** G0/G0.5/G0.9 게이트 정의 |
| `design-FINAL.md:613-618` | **실재.** fail-closed 전수표 #2·#3·#4(G0/G0.5/G0.9) — **동작은 fail-closed 로 명시돼 있다** |

**쟁점(등급)**: RULE-13 ①은 *"신규 평가 지점에서 예외 시 동작이 명시되지 않았거나 '통과/무시'이면 위반"*(`evaluation-rubric.md:127`)이다. 설계는 `:616-618`에서 세 센서 전부 **"즉시 중단 / 빌드 FAIL / 판정 거부"** 로 명시했으므로 ①은 충족된다. codex 가 짚은 것은 **동작이 아니라 기록 채널의 enum 누락**이다 — 실질은 문서 내부 정합성 결함이며 **금전 오류 경로는 아니다.** MAJOR 주장은 과대일 수 있으나(오판 FP-4 후보), 지적 자체는 사실이고 교정안도 제시되어 §2.2 5요건은 충족한다.

---

## 3. codex 가 기록한 "설계가 규칙을 잘 만족하는 지점" (대칭 규율)

codex 원문 4건 — 나의 재확인 결과 **4건 전부 인용 실재 확인**.

1. **RULE-04 / §5.1~§5.3** — `pricing.py` 무수정·import only + `mode="strict"` 호출 규약 명시. 라이브 `/price`·`/handoff`도 실제로 `evaluate_price(..., mode="strict")`를 호출함을 codex 가 코드로 확인(`widget_api.py:1291-1293`, `:1831-1841` — 나도 직접 재확인, 두 지점 모두 `mode="strict"` 실재).
2. **RULE-06 / §4.2 + G2** — simcore `Outcome` 자료구조 자체에서 `feasible != PROVEN_OK → price.amount=None`이고, 이를 `jq` 기계 검증(G2, `design-FINAL.md:570`)으로 못 박은 점.
3. **RULE-13 / §8-1** — 신규 평가 지점 10개 fail-closed 전수표. 특히 #8 *"`evaluate_price` 예외 시 0원 대체 절대 금지"*(`design-FINAL.md:622`).
4. **RULE-14 / §6 T6 + §12** — 루프가 스스로 주문을 확정하지 않고 `/handoff` + 인간 확인으로 넘기는 경계(`design-FINAL.md:513`, `:787-789`).

---

## 4. codex 가 정당한 설계를 결함으로 오판했다고 판단되는 건 (오판 후보 · 루브릭 §4.2)

> **[HARD] 이 절은 "각하 확정"이 아니라 "오판 후보 기록"이다.** 최종 FP 집계는 게이트가 §4.3 절차로 수행한다.

| ID | 오판 유형 후보 | 사유 |
|---|---|---|
| OBJ-01 | **FP-4** (다른 기준 적용) | RULE-01 의 명시 **판정 절차**(LLM 출력 화살표 도착지 추적 → 도착지가 스키마 검증기면 통과)를 적용하지 않고 선행 문언 (a)만 적용했다. 설계의 Actor 화살표 도착지는 `IntentValidator`(스키마 검증기)이므로 규정된 절차로는 통과한다(`evaluation-rubric.md:59` vs `design-FINAL.md:262`). **단, 규칙 문언 (a)는 codex 해석도 지지하므로 §5-2 해석 분기로 기록** |
| OBJ-02 | **FP-4 부분** | RULE-04 의 세 violation_test 문언 (a)(b)(c) 어디에도 직접 걸리지 않는다(설계는 `evaluate_price` 반환값을 전재할 뿐이다). BLOCKER 등급의 근거는 규칙 문언이 아니라 결함의 심각도다 — §3.2 *"등급은 규칙 위반의 심각도로 결정"* 과 §3.3 MAJOR→BLOCKER 승격 요건(**교정 불가능성 논증**)을 codex 는 제시하지 않았다. **결함 사실은 실재하므로 각하가 아니라 등급 재조정 후보** |
| OBJ-03 | **J-3 자동 각하 후보** | 결함 소재가 설계 신설물이 아니라 기존 위젯 트랙 자산이다(`design-FINAL.md:786` 비목표 12번, `evaluation-rubric.md:189` J-3). 설계는 P-03 을 이미 **"해결(우리 층 안에서)"** 로 한정 표기(`design-FINAL.md:41`) → §3.4 취하 사유 성립 소지 |
| OBJ-04 | **등급 강등 후보 (MAJOR→MINOR)** | RULE-13 ①이 요구하는 **예외 시 동작 명시**는 `design-FINAL.md:616-618`에 존재한다. 지적 실질은 escalation enum 의 문서 내부 불일치이며 금전 오류 경로가 아니다 |

**FP-2(근거 오인용) 0건** — codex 가 인용한 라인은 전부 실제 내용을 담고 있었다. 이 라운드에서 codex 의 **근거 인용 정확도는 100%(8/8 파일)** 다.

---

## 5. 이 렌즈에서 codex 가 다루지 **않은** 축 (커버리지 공백 · 나의 관측)

> **[HARD] 아래는 codex 의 지적이 아니라 재확인 과정에서 내가 관측한 것이다.** 반증으로 제기하지 않고 **관측 기록**으로만 남긴다 — 게이트가 채택 여부를 판단할 안건이다.

- **`as_of` 핀 ↔ 위젯 재계산 시점 불일치**: 설계 §5.1 은 `as_of`를 **세션 시작 시각으로 핀 고정**한다(`design-FINAL.md:421`). 반면 라이브 `/price`·`/handoff`는 `as_of` 인자를 **넘기지 않는다**(직접 실측 — `widget_api.py:1291-1293`, `:1831-1833`, 기본값 `as_of=None`). 단가 적용일(`apply_ymd`) 경계를 세션이 넘어가면 **루프 표시가와 서명가가 갈릴 수 있다.** G6 은 `422`/통과만 대조하고 **금액 일치는 대조하지 않는다**(`design-FINAL.md:574`). 관련 규칙 후보: RULE-13 ③(스냅샷 신뢰 금지, `evaluation-rubric.md:127`) · N-13(`problem-ledger.md:456`).
- codex 는 **부작용 0 / 롤백 / undo 축**(RULE-13 ②)에 대해 별도 지적을 내지 않았다 — 설계가 라이브 write 0 이므로 공허 충족이라는 설계 주장(`design-FINAL.md:600`)을 반박하지 않았다.

---

## 6. codex 자백 (한계 · 원문 그대로)

- 라이브 DB/HTTP 호출은 하지 않았다. 특정 실상품의 현재 단가 재현은 **not found**.
- `simcore/gates/` 또는 `_workspace/huni-simcore/` 구현 파일은 저장소 검색에서 **not found**. 따라서 게이트는 실행 검증이 아니라 **설계 문서 주장 기준**으로만 판단했다.
- 내장 위젯 화면이 `price_gap` 금액을 표시한다는 주장은 하지 않았다. 실제 렌더러는 `ok:false`에서 금액을 숨긴다. 문제는 공개 `huni:state`/`getStatus()` 금액 노출 경로로 한정된다.

---

## 7. 미확인 · 한계 (이 문서의)

1. **라이브 DB 미조회.** 나도 codex 도 Railway 라이브에 SELECT 하지 않았다. OBJ-02 의 VAT 오차 규모(실제 세션에서 몇 건, 얼마)는 **미측정**이며, `verification-claim-integrity.md` §1.1 surface 3 에 따라 **현 상태는 코드 구조상 가능한 경로이지 실측된 결함이 아니다**.
2. **등급 판정 미수행.** 이 문서는 REJECT/AMEND/NOTE 를 정하지 않는다. 루브릭 §3.5·§4.3(정밀도 기록 의무)은 게이트 산출물에서 충족되어야 한다 — **정밀도가 기록되지 않은 검증 결과는 무효**(`evaluation-rubric.md:302`).
3. **다른 렌즈와의 중복 병합 미수행.** 같은 위반을 다른 렌즈가 지적했으면 §3.2 에 따라 **위반 1건**으로 병합해야 한다.
4. **웹 검색 미사용.** 본 문서는 저장소 내부 파일과 codex 출력만을 근거로 하므로 `Sources:` 절을 두지 않는다.

---

## 8. 산출물 경로

| 파일 | 내용 |
|---|---|
| `_workspace/huni-worldmodel/05_gate/_codex/G2-prompt.txt` | codex 에 준 프롬프트(우리 판정 비노출) |
| `_workspace/huni-worldmodel/05_gate/_codex/G2-verdict.txt` | codex 전체 전사(15,286줄, 1.15MB) |
| `_workspace/huni-worldmodel/05_gate/_codex/G2-verdict-final.txt` | 최종 판정 발췌(47줄) |
| `_workspace/huni-worldmodel/05_gate/_codex/G2.err` | 0 byte(오류 없음) |
| `_workspace/huni-worldmodel/05_gate/G2-codex-findings.md` | 본 문서 |
