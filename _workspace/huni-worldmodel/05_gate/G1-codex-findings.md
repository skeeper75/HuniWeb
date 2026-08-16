# G1 렌즈 — codex 독립 교차검증 결과 (구조·실현)

> 작성 2026-08-15 · 트랙 `huni-worldmodel/05_gate`
> 렌즈 **G1 구조·실현** — 계층 책임분리 / 기존 webadmin 접합 실현성 / 조합폭발 대응의 실제 작동성
> 검증 대상 `04_design/design-FINAL.md` · 잣대 `04_design/evaluation-rubric.md` (v1.0 사전등록)

## 0. 실행 사실

| 항목 | 값 |
|---|---|
| 외부 모델 | `gpt-5.5` (codex exec · `-s read-only` · `model_reasoning_effort=xhigh`) |
| 프롬프트 | `05_gate/_codex/G1-prompt.txt` |
| 원문 출력 | `05_gate/_codex/G1-verdict.txt` (13,654줄 · 최종 답변 `:13588-13654`) |
| stderr | `05_gate/_codex/G1.err` (0줄 — 오류 없음) |
| 종료코드 | 0 (**codex 가용** — Claude 단독 대체 아님) |
| codex 소비 토큰 | 315,722 (`G1-verdict.txt:13587`) |
| 제기 총건 | 3 (전부 MAJOR 주장) |

독립성 담보: 프롬프트에 우리 측 심사 점수·승자·판정을 넣지 않았고, 파일 내용을 복사하지 않았다(codex 가 workdir 를 직접 읽었다). 비밀값(.env.local·토큰·쿠키)은 프롬프트에 포함되지 않았다.

[HARD] **codex 출력은 확증 전까지 사실이 아니라 가설이다.** 아래 §2 는 codex 가 인용한 `파일:라인` 을 내가 원본에서 전건 재확인한 결과다.

---

## 1. codex 원문 요지 (인용)

codex 는 3건을 제기했고 전부 MAJOR 로 주장했다. BLOCKER 주장은 0건이다.

| ID | 주장 RULE | 주장 등급 | 한 줄 요지 |
|---|---|---|---|
| OBJ-01 | RULE-12 (+RULE-05) | MAJOR | G0.5 게이트가 7축(`OPT_REF_DIM`) 우주와 12축(`DIM_META`) 우주를 뒤섞어 "5벌 전부 동일"을 재려 한다 — 분모가 측정 대상과 다르다 |
| OBJ-02 | RULE-07 (+RULE-14) | MAJOR | G8 임계가 `sim_escalation` 라우팅을 요구하는데 그 저장소는 S2 산출물이다 — S1 에서 만족 불가 |
| OBJ-03 | RULE-13 | MAJOR | G6 가 `/handoff` 리플레이를 oracle 로 쓰는데 `api_handoff` 는 `t_wgt_handoff_logs` 에 INSERT·DELETE 를 수행한다 — "라이브 write 0건" 선언과 충돌 |

codex 자신의 한계 선언 (`G1-verdict.txt:13651-13653`):
> "라이브 DB 쿼리와 Django 테스트 실행은 하지 않았다. 파일·SQL·문서 근거만으로 판정했다."
> "`gates/*.py`와 `simcore/*`는 설계상 미래 산출물이므로 실제 구현 검증은 불가했다."
> "필수 raw 파일과 §5 지목 파일은 모두 발견했다. 이번 심사에서 `not found` 파일/심볼은 없었다."

---

## 2. 근거 재확인 (내가 원본에서 직접 확인)

### 2.1 OBJ-01 근거 재확인 — **전건 확인**

| codex 인용 | 재확인 결과 |
|---|---|
| `design-FINAL.md:352` — G0.5 가 `views.py` 4표면 + DB trigger 축 집합 동일성 감시 | **확인.** `:352` = G0.5 행. 4표면 = `VAR_KEY_MAP`(:61-69) / `DIM_REF_MODELS`(:1882-1890) / `_DIM_LABEL_FIELDS`(:1893-1901) / `_IMPACT_SECTIONS`(:3670-3678) |
| `design-FINAL.md:566` — G0.5 분모 = "축 12종 (`price_views.py:31` `DIM_META` 기준)" | **확인.** 문언 그대로 |
| `price_views.py:31` — `DIM_META` 시작, 12축 | **확인.** `DIM_META = {` 가 :31. 항목 12개 (`siz_cd`·`plt_siz_cd`·`print_opt_cd`·`mat_cd`·`proc_cd`·`opt_cd`·`coat_side_cnt`·`spot_side_cnt`·`bdl_qty`·`siz_width`·`siz_height`·`min_qty`) |
| `views.py:61` — `VAR_KEY_MAP` 는 `OPT_REF_DIM.01~.07` 7축 | **확인.** `VAR_KEY_MAP = {` 가 :61, 항목 7개 |
| `sql/10_phase7_ddl.sql:192` — trigger 도 `OPT_REF_DIM` case 분기 | **확인.** `:189 CREATE OR REPLACE FUNCTION fn_chk_opt_item_ref()`, `:192 CASE NEW.ref_dim_cd` |
| `sql/73_spot_side_source.sql:56` — `spot_side_cnt` 가 별색 가격차원 | **부분 확인 (라인 드리프트).** 실제 `"price_dim":"spot_side_cnt"` 는 `:53`, 주석은 `:56-57`. **내용은 사실, 라인이 1~3줄 어긋남** |
| `D8-live-schema.md:102` — 라이브 가격행에 `spot_side_cnt` 532행 | **확인.** `\| spot_side_cnt \| 532 \| 2.3% \|` |

**추가로 내가 직접 확인한 것**(codex 가 인용하지 않았으나 판단에 필요): `views.py:1882-1890`·`:1893-1901`·`:3670-3678` 세 표면도 전부 `OPT_REF_DIM.01~.07` 7축이다. 즉 **G0.5 가 감시하는 5벌(4표면+trigger)은 전부 7축이며, 선언된 분모 12축과 축 우주가 다르다.**

### 2.2 OBJ-02 근거 재확인 — **전건 확인**

| codex 인용 | 재확인 결과 |
|---|---|
| `evaluation-rubric.md:147` — RULE-07 상태 그릇 요구 | **확인** (RULE-07 · 상태 그릇과 교정 루프 · MAJOR) |
| `evaluation-rubric.md:154` — RULE-14 고불확실 에스컬레이션 요구 | **확인** (RULE-14 · 사람 개입의 배치 · MAJOR) |
| `design-FINAL.md:533` — S1 에 Ledger 3테이블 미포함 선언 | **확인.** "**S1에 넣지 않는 것**: Actor LLM · Explainer · PhraseRenderer · RenderGuard · Ledger 3테이블 · ReachabilityProbe" |
| `design-FINAL.md:549` — Ledger 3테이블 + `sim_escalation` 은 S2 산출물 | **확인.** S2 절 문언 그대로 |
| `design-FINAL.md:541` — S1 파일럿 조건 6 = `use_dims` 빈 구성요소 최소 1개 | **확인** |
| `design-FINAL.md:576` — G8 임계 = 무반응 구성요소 전건이 `sim_escalation(AFFECT_UNDEFINED)` 라우팅 | **확인** |

**추가 확인(설계 측에 유리한 반대 증거도 기록):** `design-FINAL.md:547` **S1 종료 조건 = "G0·G0.5·G0.9·G1·G2 통과 + G4·G7·G8 실측치 기록"** — 즉 S1 은 G8 을 *통과*가 아니라 *실측치 기록*으로만 요구한다. 또 `§4.7`(`:377-390`)에 `sim_escalation` 스키마와 `route_to` 매핑이 **설계 수준에서는 명시**되어 있다(RULE-07 (a) 상태 그릇 위치는 존재). codex 의 지적은 "설계에 그릇이 없다"가 아니라 **"S1 단계에서 G8 임계 문언을 만족시킬 그릇이 없다"** 는 단계배치 정합 문제다.

### 2.3 OBJ-03 근거 재확인 — **전건 확인 (가장 강함)**

| codex 인용 | 재확인 결과 |
|---|---|
| `design-FINAL.md:17` — 라이브 write 0건 선언 | **확인.** "\| 라이브 write \| **0건** (사이드카 저장소만 사용) \| 본 설계 §4.7 \|" |
| `design-FINAL.md:574` — G6 가 `/validate`·`/handoff` 리플레이 사용 | **확인.** "스윕 조합을 `/validate`·`/handoff`(테스트 사이트키)로 리플레이" |
| `design-FINAL.md:776` — 라이브 DB 에 한 행도 쓰지 않는다 | **확인.** "**라이브 DB에 단 한 행도 쓰지 않는다.** 테이블 신설 0, DDL 0, UPDATE 0." |
| `widget_api.py:1477` — 핸드오프 로그는 부수 효과 주석 | **확인.** `:1477-1478` = "핸드오프 로그(t_wgt_handoff_logs) — 부수 효과, best-effort (D-06)" |
| `widget_api.py:1497` — 200/422/403/404/409 기록 대상 | **확인.** `_should_log` docstring — "그 외(200 · 403 site_mismatch/origin_not_allowed · 404 · 409 · 422 전부)는 기록한다" |
| `widget_api.py:1676` — `TWgtHandoffLogs.objects.create(**row)` | **부분 확인 (off-by-one).** 실제 `:1677`. 내용 사실 |
| `widget_api.py:1733` — purge DELETE | **확인.** `M.TWgtHandoffLogs.objects.filter(handoff_id__in=ids).delete()` |
| `sql/68_widget_handoff_logs.sql:46` — 테이블 정의 실재 | **확인.** `CREATE TABLE IF NOT EXISTS t_wgt_handoff_logs (` |

**추가 확인:** `widget_api.py:1959-1963` — `def api_handoff(request)` → `resp = _handoff_core(request, ctx)` → `_log_handoff(ctx, resp)`. 즉 **public `/handoff` 는 코어 실행 후 반드시 로그 기록 경로를 탄다.** codex 의 교정안(`_handoff_core` 를 직접 호출)이 실코드 구조상 성립한다는 것도 확인했다(`:1744 def _handoff_core`).

**설계 측에 유리한 반대 증거:** `design-FINAL.md:574` 는 "(테스트 사이트키)" 를 명기한다. 그러나 `_should_log`(`:1497`)는 **유효 site_key 의 200/422 를 기록 대상으로 명시**하므로, 테스트 사이트키라도 *같은 라이브 DB* 를 쓰는 한 write 는 발생한다. 별도 DB 를 쓴다는 진술은 설계 문서에서 **찾지 못했다**(not found). 따라서 이 반대 증거는 지적을 무력화하지 못한다.

---

## 3. 구조화된 지적표

| ID | 겨냥 | RULE | 등급 | 심리(5요건) | 근거 재확인 |
|---|---|---|---|---|---|
| OBJ-01 | §4.5 G0.5 · §7 게이트표 | RULE-05 ④분모 (+RULE-12) | MAJOR | 충족 | 전건 확인(1건 라인 드리프트) |
| OBJ-02 | §7 S1/S2 단계배치 · G8 | RULE-07 (+RULE-14) | MINOR~MAJOR | 충족 | 전건 확인 |
| OBJ-03 | §7 G6 oracle | RULE-13 (b) | MAJOR | 충족 | 전건 확인(1건 off-by-one) |

세 건 모두 §2.2 심리 요건 5항 (a)rule_id (b)실패시나리오 (c)근거 (d)자기반증조건 (e)교정안 을 **전부 갖췄다**. §2.3 자동 각하 사유(J-1~J-5) 에 걸리는 건은 **0건**이다 — 세 건 모두 기각목록 재제안이 아니고, N-20~N-30 을 결함으로 세우지 않았으며, 다른 트랙 소유 작업(P-08)을 요구하지 않았고, 실코드·실 SQL 을 열어 확인했다.

---

## 4. codex 가 정당한 설계를 결함으로 오판했다고 판단되는 건 (오판 감사 노출)

루브릭 §4.2 의 FP 유형 기준으로, 아래는 **오판 확정이 아니라 오판 노출(FP 위험)** 을 기록한 것이다. 확정 판정은 게이트 종합이 한다.

### 4.1 OBJ-01 의 RULE-12 다리 — FP-4 노출 (다른 기준 적용)

RULE-12 의 `violation_test` 는 "설계가 도입하는 각 **개념**에 정의가 사는 곳이 정확히 하나인가" + "**기존 5벌 병렬을 6벌로 늘리면** 자동 위반" 이다(`evaluation-rubric.md:110`). 설계는 `design-FINAL.md:780` 에서 "**차원 정의를 새로 만들지 않는다. import만 하며, 6벌째 목록을 만들지 않는다**" 를 선언하고, `§11-3`(`:741-744`) 에서 **"P-16(5벌 병렬)은 이 설계가 해결하지 않는다 · G0.5 는 센서이지 통합이 아니다"** 를 감수 위험으로 이미 자백했다. 따라서 5벌 병렬 자체를 결함으로 세우는 것은 J-3(다른 트랙 소유 — 통합은 webadmin 소유) 성격에 가깝다.

**살아남는 부분**: 5벌 병렬이 아니라 **G0.5 게이트 자신의 ①측정대상(7축)과 ④분모(12축) 불일치**다. 이것은 RULE-05 의 "④ 분모(몇 개 중 몇 개인가)" 항목에 대한 실질적 결함이다.

단, RULE-05 의 `violation_test` 문언은 "4항이 **모두 없으면** 위반"이다(`evaluation-rubric.md:98`). G0.5 행에는 4항이 **형식상 모두 존재**한다. 즉 **codex 는 RULE-05 의 문언 그대로의 검사를 적용한 것이 아니라, "4항이 서로 정합한가"라는 확장 기준을 적용했다** — 루브릭 §5-2 가 예고한 "기계 판정성이 균일하지 않다"에 해당한다. 이 해석 분기가 발생한 사실 자체를 기록한다(루브릭 §5-2 의무).

### 4.2 OBJ-02 — FP-1/FP-4 노출 (설계 문서 내 위치가 존재)

RULE-07 의 `violation_test` 는 "(a) 상태 그릇의 **위치**, (b) 예측↔관측 대조 절차 — 둘 중 하나라도 없으면 위반"이다. 설계는 (a) 를 `§4.7`(`:377-390`, 4테이블 + `route_to` 매핑)에, (b) 를 `§4.7` 예측-관측 대조 채널 O1/O2/O3 표(`:396-401`)에 **명시**한다. 즉 **설계 문서 수준에서는 RULE-07 의 두 항이 모두 충족**되며, codex 의 지적은 "설계에 없다"가 아니라 "S1 단계 산출물 목록에 없다"는 **단계배치 정합** 문제다.

또 `design-FINAL.md:547` 이 S1 종료조건을 G8 **통과가 아닌 실측치 기록**으로 낮춰 두었으므로, codex 가 상정한 "G8 이 S1 에서 통과 판정을 요구한다"는 전제는 부분적으로 성립하지 않는다.

→ 이 건은 **RULE-07 위반이라기보다 G8 임계 문언과 S1 산출물 목록 사이의 내부 불일치**로 재기술되는 것이 문언에 충실하다. 등급은 MAJOR 보다 **MINOR(기록·문언 정리)** 가 문언 정합적이며, §2.2(e) 교정안은 제시되었으므로 강등 사유는 아니다.

### 4.3 OBJ-03 — 오판 노출 없음

RULE-13 (b) 의 `violation_test` 는 "**라이브 write 를 수반하는 단계**에 백업·DRY-RUN·undo 중 하나라도 빠지면 위반" 이다(`evaluation-rubric.md:127`). G6 는 라이브 write 를 수반하며(실코드로 확인), 백업·DRY-RUN·undo 중 어느 것도 문서에 없다. **codex 는 해당 규칙의 violation_test 를 그대로 적용했다.** FP-4 노출 없음. 근거 라인도 1건 off-by-one 외 전건 실재(FP-2 없음). 실코드 대조로 재현 경로가 확정되었으므로 FP-3 위험도 낮다.

### 4.4 라인 인용 정확도 (FP-2 감사)

인용 라인 총 21건 중 **19건 정확 · 2건 드리프트**(`73_spot_side_source.sql:56`→실제 :53 부근, `widget_api.py:1676`→실제 :1677). 두 건 모두 **내용은 실재**하므로 FP-2(근거 오인용) 확정은 아니다. 루브릭 §4.4 의 "FP-2 2건 이상 시 전건 재확인" 트리거에는 미달한다(0건 확정).

---

## 5. 설계가 규칙을 잘 만족하는 지점 (대칭 규율 — codex 지목 + 내 재확인)

| RULE | codex 지목 | 내 재확인 |
|---|---|---|
| RULE-01 · 판정권 심볼릭 독점 (BLOCKER) | LLM 출력이 `IntentValidator`/`RenderGuard` 를 거친다 | **확인.** `design-FINAL.md:201` — "LLM 노드(ACT·EXP)의 출력 화살표는 예외 없이 결정론 검증기(IV·RG)로 들어간다. 고객·주문 시스템에 직접 닿는 LLM 화살표가 0개다". `:202` — "금액이 들어간 문장은 LLM을 아예 통과하지 않는다" |
| RULE-02 · 인터페이스 타입화 (BLOCKER) | Intent 스키마가 필드·도메인·UNKNOWN·검증지점을 가진다 | **확인.** `:238-246` — `UNKNOWN = "<unknown>"` 유일 미확정 표현 선언, 각 필드에 도메인 출처(`t_prd_products.prd_cd where del_yn='N'` 등) 병기. RULE-02 3항(①필드+도메인 ②unknown 표현 ③검증지점) 충족 |
| RULE-04 · 가격 단일권위 + 무수정 (BLOCKER) | `pricing.evaluate_price` 단일 권위 + raw 무수정 | **확인.** `:15` 가 `pricing.py:428` 을 직접 실측 인용하며, 내가 `pricing.py:428` 을 열어 `def evaluate_price(target, selections, qty, grade_cd=None, mode="lenient",` 실재를 확인했다. `:775` — "`raw/webadmin/**` 및 `pricing.py`를 수정하지 않는다" |
| RULE-08 · 조합폭발 대응 작동성 | 전수 사전계산을 비목표로 못박고 1상품 파일럿 측정항목 제시 | **확인.** `:781` — "전수 열거·사전계산 적재를 하지 않는다 (N-19)". `§7 기계 판정 게이트`(`:561-583`)가 G0~G9 각각에 ①측정대상 ②도구 ③임계 ④분모 + **실패 시 무엇을 버리는가** 를 표로 명시 |
| RULE-15 · 선행 자산 정합 | 권위 버전·상품 분모·범위 밖 트랙 단일 선언 | **확인.** `:13` 권위 엑셀 260705/260703 단일 선언, `:14` 상품 분모 288, `:16` P-08 은 §7/§18 트랙 소유로 명시적 배제 |

**내가 추가로 기록하는 강점**(codex 가 지목하지 않은 것):

- **자기 반증 게이트의 존재.** G9(`:577`)는 "루프 경로 vs 순수 SQL 대조군"을 두고 **"(가)=(나)이면 이 설계의 논지가 부분 반증된다"** 를 스스로 선언한다. RULE-05 의 정신(반증 가능한 종료 척도)을 게이트 하나로 제도화한 사례다.
- **실패 시 후퇴 경로의 명시.** 게이트표 마지막 열이 전 행에 "실패 시 무엇을 버리는가"를 담는다(예: G7 p95>2s → 고객 실시간 루프 폐기·관리자 도구로 강등). 임계 미달의 처방이 "재설정"이 아니라 "폐기"로 사전 고정된 것은 RULE-05 의 취지를 넘는다.
- **감수 위험의 선제 자백.** `§11-1~11-9` 가 관측 채널 빈약(11-1)·P-16 미해결(11-3)·판정 주체 증가(11-4)·private 심볼 의존(11-5)·G7 임계 [추정](11-7)·LLM 기여분 미미 가능성(11-8)을 스스로 적었다. 이는 반증자가 제기할 지적을 설계가 선점한 것으로, §0.1 ③(표면적 역선택)의 반대 방향 — 문서화가 방어로 작동한 사례다.

---

## 6. 미확인 · 한계

- **라이브 DB 를 조회하지 않았다.** 이 문서의 모든 판정은 저장소 내 파일(`design-FINAL.md`·`evaluation-rubric.md`·`raw/webadmin/**`·`sql/**`·선행 진단문서)만을 근거로 한다. `t_wgt_handoff_logs` 현재 행수, `spot_side_cnt` 532행 등은 `D8-live-schema.md` 의 선행 실측을 인용한 것이지 내가 재측정한 값이 아니다.
- **`gates/*.py`·`simcore/*` 는 미래 산출물이므로 구현 검증이 불가능하다.** 세 지적 모두 "문서 문언 vs 실코드 계약" 대조이지 "구현이 틀렸다"가 아니다.
- **G6 가 별도 DB(clone/test) 를 쓴다는 진술을 설계 문서에서 찾지 못했다(not found).** 만약 그런 진술이 다른 산출물에 있다면 OBJ-03 은 codex 자신의 자기반증조건에 의해 철회 대상이다.
- **웹 검색을 사용하지 않았다.** 따라서 `Sources:` 절을 두지 않는다. 모든 근거는 저장소 내부 파일경로:라인이다.
- **나는 판정하지 않았다.** 이 문서는 codex 의 지적을 받아 적고 근거를 재확인한 기록이다. REJECT/AMEND/NOTE 확정은 게이트 종합의 몫이다.
