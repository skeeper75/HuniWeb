# 커버리지 보충 검증

> 작성 2026-08-15 · 트랙 `huni-worldmodel/05_gate`
> 대상: `04_design/design-FINAL.md` (804행) · 루브릭 `04_design/evaluation-rubric.md` v1.0 (버전 고정)
> 근거 조건: `05_gate/gate-report.md:231`(FIX-9) · `:233`(FIX-10) · `:374`(조건 ③ = U-5 선행 실측)
> 이 문서는 게이트가 스스로 **미검증**으로 분리한 RULE-03(BLOCKER)·RULE-17(MAJOR) 두 규칙의 보충 검증과, FIX-4의 선행 조건인 `/validate` 부작용 실측을 수행한다.
> [HARD] 모든 사실 주장에 `파일경로:라인`. 확인하지 않은 것은 `[추정]`/`미확인`으로 분리한다. 라이브 DB·`raw/webadmin` 은 읽기 전용으로만 접근했고 단 한 행도 수정하지 않았다.

---

## 0. 이 검증이 쓴 규율 (입증책임 · 오판 회피)

### 0.1 입증책임의 방향 [HARD]

루브릭 §2.1 — *"근거가 불충분할 때의 기본값은 '반증 성립'이 아니라 '각하'다"*(`evaluation-rubric.md:165`). 이 검증은 위반을 **찾으러** 간 것이 아니라 두 규칙의 `violation_test` 를 **적용하러** 갔다. 적용 결과 위반이 나오지 않으면 그것이 정상적인 결과이며, 억지로 결함을 만들지 않는다.

지적을 제기할 때 갖춰야 할 5요건(`evaluation-rubric.md:171-179`): ① 위반한 `violation_test` 항 지목 ② 구체적 실패 시나리오 ③ 원본 근거 ④ 자기 반증조건 ⑤ 교정안. **이 문서에서 5요건을 갖춘 새 위반 지적은 0건이다.**

### 0.2 회피 대상 오판 유형 — FP-4

`gate-report.md:313-336`(§5.4)이 진단한 지난 라운드 실패 패턴: **오판 12건 중 11건이 FP-4**(위반이라 주장한 규칙의 `violation_test` 를 적용하지 않고 **다른 기준**으로 판정, `evaluation-rubric.md:285`). 진단 원문 — *"검증자들은 코드 사실을 정확히 짚었으나 규칙 매핑에서 틀렸다"*(`gate-report.md:317`), *"test 가 재지 않는 것을 재면 오판이다"*(`:296`).

따라서 이 검증은 두 규칙에 대해 **루브릭 문언의 검사항만** 적용한다. 구체적으로 다음 셋을 의도적으로 **재지 않았다**:

| 재지 않은 것 | 왜 안 재는가 | 이미 어디에 있는가 |
|---|---|---|
| `_sim_dim_candidates` 5축 vs 선언 12축 격차 | RULE-03 은 후보 3개의 **결과 계산 경로**를 묻지 RULE-02 의 필드 도메인 출처를 묻지 않는다 | RULE-02 위반 확정(A7) · FIX-1 (`gate-report.md:149-154`) |
| G6 리플레이의 라이브 write | RULE-03(b)의 "그 계산"은 T4 롤아웃이지 **검증 게이트**가 아니다 | RULE-13②·RULE-14② 위반 확정(A2) · FIX-4 (`gate-report.md:173-180`) |
| `as_of` 달력 경계 갈림 | RULE-17 (a)(b)(c) 어느 항에도 해당하지 않는다 | NOTE N5 (`gate-report.md:247`) |

이 셋을 RULE-03/RULE-17 에 다시 걸면 (i) 루브릭 §3.2 중복 병합 위반(`evaluation-rubric.md:238`)이고 (ii) FP-4 오판 신설이다. 실체는 실재하나 **이 두 규칙이 재는 것이 아니다.**

### 0.3 이 검증이 실제로 실행한 것

`gate-report.md:254` — *"모든 게이트 판정은 문서 문언 대조이지 구현 검증이 아니다"*. 이 보충 검증은 그 한계를 **한 겹 넘겼다**: RULE-03(b)와 §3의 `/validate` 실측은 문서가 아니라 **호출 대상이 되는 라이브 파이썬·SQL 원본**을 직접 읽어 판정했다. 아래 표가 이 문서가 원본에서 직접 확인한 사실이다.

| # | 재실측 대상 | 결과 |
|---|---|---|
| **S-1** | `pricing.py` 전역 write 패턴 (`.save(`/`.create(`/`bulk_create`/`get_or_create`/`.delete()`/`cache.`/`lru_cache`/`open(`) | **0건.** 유일 매치 `pricing.py:667` `entry.update({...})` 는 **로컬 dict 갱신**(`entry` = 구성요소 결과 dict, `:667-673`) |
| **S-2** | `pricing.py` 원시 SQL 전수 | **1건뿐 · SELECT** — `pricing.py:307-308` `with connection.cursor() as cur: cur.execute("SELECT fn_calc_pansu(%s, %s)", ...)` |
| **S-3** | `fn_calc_pansu` 의 휘발성·DML | **STABLE · DML 0** — `sql/32_fn_calc_pansu.sql:24`(`CREATE OR REPLACE FUNCTION`) `:29`(`LANGUAGE plpgsql`) `:30`(`STABLE`). 파일 내 `INSERT`/`UPDATE`/`DELETE` 매치 0 |
| **S-4** | `price_views.py` write 위치 전수 | **전부 `:1235`~`:1544` 구간**(관리자 단가·할인 편집 뷰: `:1250` `TPrcComponentPrices.objects.create`, `:1344`·`:1385`·`:1526` `.delete()` 등). 설계가 import 하는 심볼(`:1615`·`:2223`·`:2513`·`:2683`·`:2701`)은 **전부 그 구간 밖** |
| **S-5** | `_sim_dim_candidates` 본문 | **읽기 전용** — `price_views.py:2683-2698`. 5모델 `.objects.filter(prd_cd=...)` + `del_yn="N"` + `.values_list()` → `return sorted({...})` (`:2698`). write 0 |
| **S-6** | `_sim_disallowed` 본문 | **읽기 전용** — `price_views.py:2701-2733`. `_sim_active_rules` + `TPrdProductMaterials.objects...values()` + 순수 `jsonLogic` 평가. write 0 |
| **S-7** | `_sim_active_rules` · `qty_rule_error` 본문 | **읽기 전용** — `:2513-2535`(`TPrdProductConstraints...values()` 만) · `:1615-1630`(순수 비교, DB 접근조차 없음) |
| **S-8** | `widget_api._price_gap_errors` 본문 | **읽기 전용** — `widget_api.py:455-500`. 이미 계산된 `res` dict 순회 + `PV.DIM_META` 조회. write 0 |
| **S-9** | `tmpl_combo.py` 전역 write 패턴 | **0건** (파일 전체 매치 없음). `resolve` (`tmpl_combo.py:245-290`)은 `combo_rows`/`opt_grp_map` 결과에 대한 순수 매칭 |
| **S-10** | `widget_api.py` 모듈 전역 mutation | **1건뿐** — `widget_api.py:2041` `global _PART_NO_CAP`, 함수 `_part_no_cap()` (`:2040`) 내부. S3 **멀티파트 업로드 조각수 상한** 지연계산이며 롤아웃 경로와 무관 |
| **S-11** | `/validate` 라우팅 | `config/urls.py:167` `path("api/w/v1/validate", wapi.api_validate, ...)` → `widget_api.py:1410` `def api_validate(request)` |
| **S-12** | `/validate` 부작용 | **있음 — DB UPDATE 1건 + 캐시 mutation** (§3에서 상술) |

---

## 1. RULE-03 판정 (BLOCKER · 커밋 전 시뮬레이션 루프)

### 1.0 적용한 검사 문언

- **norm**(`evaluation-rubric.md:75`): 비가역 행위 이전에 후보를 실행 없이 통과시키는 루프. 최소 5단계 — ① 후보 열거 ② 월드모델 통과(부작용 없음) ③ 채점 ④ 1개만 실행 ⑤ 관측 후 재계획.
- **violation_test**(`:76`): 시나리오 *"고객이 옵션 6개 중 5개를 고른 상태에서 6번째 옵션 후보 3개를 화면에 띄운다"* 에 대해 — (a) 3후보 각각의 결과(가능여부·가격·결손축)를 **선택 전에** 계산하는 경로가 문서에 없으면 위반, (b) 그 계산이 부작용(DB write·주문 상태 변경)을 동반하면 위반, 또한 "저장/커밋 후 검증"(사후 통보) 구조가 남아 있으면 위반.

### 1.1 (a) — 선택 전 계산 경로의 사슬 추적

시나리오를 `design-FINAL.md` §6 T4 에 그대로 적용했다. T4 는 루브릭 시나리오와 **같은 형상**이다 — `:491` *"5개 슬롯이 찼고 마지막 후가공만 남았다. `frontier()`가 도메인에서 후보 3개를 결정론 열거하고, `rollout()`이 3개를 **선택 전에** 굴린다."*

문서 좌표로 사슬을 끊김 없이 그린다.

| 단계 | 컴포넌트 | 무엇을 호출하는가 | 문서 좌표 | 라이브 좌표(설계가 인용, 내가 재실측) |
|---|---|---|---|---|
| **①** 후보 열거 | `loop.frontier()` (F4, worldmodel) | 차원별 후보값 도메인 결정론 추출 | `:218`, `:135`, `:491` | `price_views._sim_dim_candidates` (`:249`·`:430` 인용) → **S-5 재실측 `price_views.py:2683-2698`** |
| **②** 월드모델 통과 | `loop.rollout()` (F5) → `simcore.JointTransition.step()` (F1) | §4.4 (a)~(g) 6호출 조립 | `:219`, `:215`, `:331`, mermaid `:173-174` | — |
| ②-가능여부 | JointTransition (a)(b)(c)(e) | `qty_rule_error` / `_sim_disallowed` / `tmpl_combo.resolve`+`missing_axis_names` / `_price_gap_errors` | `:335`·`:336`·`:337`·`:339` | **S-7** `price_views.py:1615` · **S-6** `:2701` · **S-9** `tmpl_combo.py:245`,`:204` · **S-8** `widget_api.py:455` |
| ②-가격 | JointTransition (d) | `pricing.evaluate_price(..., mode="strict", as_of=pinned)` | `:338`, `:419-420` | `pricing.py:428` (기본 `mode="lenient"` 실측 확인 — 설계가 strict 로 덮음) |
| ②-결손축 | JointTransition (b)(c) 산출의 `Outcome` 착지 필드 | `blockers[].id`(`rule_cd`\|`comp_cd`\|`axis_name`), `blockers[].repairs[]`, `rejected[].first_diff_dim`, `reachability.dead_dim` | `:278`·`:281`·`:294`·`:299` | `_sim_disallowed` 가 `{차원: {불가값: 규칙명}}` 을 반환함을 **S-6 에서 본문 재실측**(`price_views.py:2731-2733` `out[dim] = dis`) |
| **③** 채점 | `loop.Scorer` (F6, symbolic) | 사전선언 사전식 6키 비용함수 | `:220`, `:359-375` | ⑥ 안정 tie-break 사상 근거 `pricing.py:288-291` |
| **④** 1개만 실행(제시) | PICK | Scorer 최상위 1건만 `PhraseRenderer`→`RenderGuard`→화면 | `:136`, `:177-178`, `:508-511` | — |
| **⑤** 관측 후 재계획 | RE + `sim_rollout`/`sim_observation` | 예측 전량 기록 + `/handoff` 응답 대조 | `:137`, `:515`, `:380-384` | — |

**5단계 전건 존재. 사슬에 끊기는 지점이 없다.**

T4 산출 예시(`:493-502`)가 3후보 각각에 대해 **선택 전에** 세 값을 모두 내놓는다는 것이 문서 자체에 실려 있다:

| 후보 | 가능여부 | 가격 | 결손축 |
|---|---|---|---|
| 1 (무광코팅) | `feasible=PROVEN_OK` (`:493`) | `price=44,300` (`:493`) | 없음 · `zero_reason=TRUE_ZERO` (`:494`) |
| 2 (박) | `feasible=PROVEN_BLOCKED` (`:495`) | `price=None` (`:498`) | `blockers=[{source:"RULE", id:"R_EXCL_...", kind:"FORBIDDEN", repairs:[{unset:["mat_cd"]},{or_set:[("mat_cd","MAT_xxx")]}]}]` (`:496-497`) |
| 3 (에폭시) | `feasible=PROVEN_BLOCKED` (`:499`) | `price=None` (`:501`) | `blockers=[{source:"TMPL_COMBO", kind:"UNREGISTERED"}]` (`:500`) + `sim_escalation` 라우팅 (`:502`) |

또한 시나리오의 6번째 축이 **후가공(`proc_cd`)** 이라는 점을 확인했다: `proc_cd` 는 `_sim_dim_candidates` 가 실제로 처리하는 5축(`price_views.py:2685-2691`: `siz_cd`·`plt_siz_cd`·`mat_cd`·`proc_cd`·`bdl_qty`) **안에 있다**(S-5). 즉 루브릭이 명시한 이 시나리오는 열거 경로가 실재하는 축 위에서 돈다.

> **[FP-4 회피 기록]** 게이트가 확정한 A7(선언 12축 vs 실제 처리 5축 격차, `gate-report.md:62`)은 RULE-03 의 검사항이 아니다. RULE-03(a)는 *"3후보 각각의 결과를 선택 전에 계산하는 경로가 문서에 있는가"* 를 묻고, A7 은 RULE-02 ①(필드별 도메인 출처 선언)을 직격한 것으로 이미 확정·FIX-1 배정됐다(`gate-report.md:103`·`:149-154`). 같은 사실을 RULE-03 에 다시 거는 것은 §3.2 중복 병합 위반이자 FP-4 신설이다.

**(a) 판정: 위반 없음.**

### 1.2 (b) — 부작용 0

두 층에서 확인했다.

**층 1 — 설계 명세.**

| 근거 | 좌표 |
|---|---|
| 롤아웃의 기계적 부작용 0 보장: `transaction.atomic()` + `SET TRANSACTION READ ONLY` + `SET LOCAL statement_timeout` + **무조건 롤백 예외** (`assistant_tools.py:689-701` 재사용) | `:345` |
| §0 고정 선언 "라이브 write **0건** (사이드카 저장소만 사용)" | `:17` |
| 비목표 2번 "라이브 DB에 단 한 행도 쓰지 않는다. 테이블 신설 0, DDL 0, UPDATE 0" | `:776` |
| T4 말미 "**DB write 0건. 주문 상태 변경 0건.**" | `:506` |
| G1 기계 검증: 스윕 전후 라이브 46테이블 `count(*)`+`max(upd_dt)` 해시 비교, 임계 "완전 일치·변경 행 0", 실패 시 **설계 즉시 폐기** | `:568` |
| F5 `loop.rollout()` = "후보 배치 부작용 0 실행" | `:219` |

**층 2 — 호출 대상 라이브 코드 실측 (S-1 ~ S-10).** 롤아웃이 실제로 부르는 것은 §4.4 (a)~(g) 6개 심볼이다. 전건을 원본에서 읽었다.

| 호출 | 라이브 위치 | write / 로그 / 캐시 | 근거 |
|---|---|---|---|
| (a) `qty_rule_error` | `price_views.py:1615-1630` | **없음** — DB 접근 자체가 없는 순수 비교 | S-7 |
| (b) `_sim_disallowed` | `price_views.py:2701-2733` | **없음** — `.values()` 조회 + `jsonLogic` 순수 평가 | S-6 |
| (b') `_sim_active_rules` | `price_views.py:2513-2535` | **없음** — `.values()` 만 | S-7 |
| (b'') `_sim_dim_candidates` | `price_views.py:2683-2698` | **없음** — `.values_list()` → `sorted({...})` | S-5 |
| (c) `tmpl_combo.resolve` | `tmpl_combo.py:245-290` | **없음** — 파일 전체 write 패턴 매치 0 | S-9 |
| (d) `pricing.evaluate_price` | `pricing.py:428` 이하 | **없음** — 전역 write 매치 0(유일 매치 `:667` 은 로컬 dict). 원시 SQL 1건은 `SELECT fn_calc_pansu` (`:308`)이고 그 함수는 `STABLE`·DML 0 | S-1·S-2·S-3 |
| (e) `_price_gap_errors` | `widget_api.py:455-500` | **없음** — 이미 계산된 `res` dict 순회 | S-8 |
| (f) `t_siz_pansu` 존재 조회 | 설계상 `SELECT` (`:340`) | **없음** — 선언 자체가 존재 조회 | `:340` |
| (g) `components[].data_gap` 판독 | `pricing.py:655-660` 산출물 판독 | **없음** — 반환 dict 판독 | S-1 |

캐시 오염 축도 별도 확인했다: 위 6심볼에 `lru_cache`·`cache.set`·`cache.delete` 매치 0, 모듈 전역 mutation은 `widget_api.py:2041`(S3 업로드 조각수 상한) 1건뿐이며 롤아웃 경로와 무관(S-10).

> **[FP-4 회피 기록 · 경계 명시]** G6(`:574`)은 스윕 조합을 `/validate`·`/handoff` 로 **리플레이**하며, §3에서 실측한 대로 `/validate` 는 부작용을 갖는다. 그러나 G6 은 **롤아웃이 아니라 검증 게이트**다 — RULE-03(b)의 "그 계산"은 T4 의 후보 3개 계산 경로를 가리키고, 그 경로에 `/validate`·`/handoff` 호출은 없다(§4.4 (a)~(g) 어디에도 없음). G6 의 라이브 write 는 이미 A2 로 RULE-13②·RULE-14② 직격이 확정되어 FIX-4 가 배정됐다(`gate-report.md:57`·`:173-180`). 이를 RULE-03 에 재차 거는 것은 규칙이 재지 않는 것을 재는 FP-4 다.

**(b) 판정: 위반 없음.** 설계 명세와 호출 대상 라이브 코드 양쪽에서 부작용 0.

### 1.3 (c) — 사후통보 구조 잔존 여부

| 검사 | 결과 | 근거 |
|---|---|---|
| 조합템플릿 미등록을 **선택 후 주문 단계**에서 통보하는 구조가 남았는가 | **아니오** — `tmpl_combo.resolve` 를 게이트로 앞당겨 **선택 단계**에서 `UNREGISTERED` 로 예고 | `:58`(P-20 대응), `:447`, T4 후보3 `:499-502` |
| 제약 위반 조합의 가격을 보여준 뒤 나중에 막는 구조가 남았는가 | **아니오** — 후보 2·3은 "가격이 계산되지도, 표시되지도 않는다". `feasible != PROVEN_OK ⇒ price.amount = None` 이 **스키마 강제** | `:504`, `:306`, `:284` |
| 막다른 상품을 끝까지 고르게 한 뒤 통보하는 구조가 남았는가 | **아니오** — 설계가 현행 사후통보를 명시적으로 지목하고 제거함: *"B는 **여기서 사라진다.** 현행 구조라면 고객이 B를 끝까지 고른 뒤 주문 단계 422를 맞는다."* | `:487` (T2, `:484` `PROVEN_DEAD`) |
| 우리 층 신규 평가 지점에 "실패 시 통과" 경로가 남았는가 | **아니오** — 신규 평가 지점 **10개 전건 fail-closed 전수표** | `:609-624` (특히 `:622` "0원 대체 절대 금지") |
| 확정 경로가 "커밋 후 검증"인가 | **아니오 — 검증이 커밋에 선행한다.** 위젯 `/price` 라이브 재계산 → **사람 확인 버튼** → `/handoff` 서명 | `:513` (T6), `:443` |

**잔존 `/handoff` 422 의 취급 [HARD]** — 라이브 `/handoff` 가 여전히 422 를 낼 수 있다는 사실은 남는다. 그러나 이것은 RULE-03(c) 위반이 아니다. 두 이유:

1. **심사 대상 밖.** 루브릭 §0.4 — *"라이브 DB·`raw/webadmin` 코드·이미 등록된 제약규칙은 심사 대상이 아니라 **설계가 보존해야 할 제약**이다"*(`evaluation-rubric.md:39`). `/handoff` 의 422 는 라이브 webadmin 소유다.
2. **구조상 커밋 前 검증이다.** 422 는 `/handoff` 가 서명을 **거부**하는 것이지 서명 후 통보가 아니다. 커밋이 일어나지 않는다.

나아가 설계는 이 잔여 갈림을 은폐하지 않았다 — 주장 4 의 반증 조건(`:656` *"예측 PROVEN_OK인데 `/handoff` 422 … 1건이라도 나오면 … 부분 반증된다"*), G6 의 계측 대상화(`:574` 임계 "갈림 0건"), §11-4 정직 기록(`:745-747` *"G6은 그것을 측정할 뿐 봉합하지 못한다"*)까지 셋을 스스로 걸었다.

**(c) 판정: 위반 없음.**

### 1.4 RULE-03 종합

```
RULE-03 (BLOCKER · 커밋 전 시뮬레이션 루프)
  norm 5단계 존재:  ①②③④⑤ 전건 확인 (§1.1)
  (a) 선택 전 계산 경로:  추적 완결 · 끊김 0        → 위반 없음
  (b) 부작용 0:           명세 + 라이브 코드 양측 확인 → 위반 없음
  (c) 사후통보 잔존:      5검사 전건 부정             → 위반 없음
  ─────────────────────────────────────────────
  판정: 위반 없음 (BLOCKER 위반 0건)
  새로 제기한 위반: 0건 · 회피한 FP-4 후보: 2건 (A7 재차용 · G6 재차용)
```

---

## 2. RULE-17 판정 (MAJOR · 재현 결정론)

### 2.0 적용한 검사 문언

- **norm**(`evaluation-rubric.md:80`): 같은 의도를 k회 반복 입력했을 때 **같은 최종 상태(선택 옵션 집합 + 최종가)** 가 나오는지를 게이트로 삼고, 결정론을 모델이 아니라 **엔진 쪽**에서 확보한다.
- **violation_test**(`:81`): (a) 재현성 측정 방법(무엇을 몇 회 돌려 무엇을 비교하는가)이 없거나, (b) 비교 대상이 **최종 상태가 아니라 대화 텍스트**이거나, (c) 확보 수단이 "temperature 0" 등 **모델 설정에만** 의존하면 위반.

대상 명세: G3 (`design-FINAL.md:571`) + §8 대응행 (`:602`).

> **[FP-4 회피 · 문언 확인]** 과제 지시문은 (b)를 "중간 산출물끼리 비교"로 풀어썼으나, 루브릭 문언은 *"대화 텍스트"* 다. 루브릭 §0.2 — *"`violation_test` 는 심사자가 실행할 수 있는 절차여야 하며"*(`evaluation-rubric.md:31`). 규칙 문언을 적용한다. 두 해석 모두에서 결과는 같으므로 아래에 양쪽을 병기한다.

### 2.1 (a) — 재현성을 어떻게 측정하는가

G3 명세(`:571`)를 4요소로 분해했다. 루브릭 RULE-05 가 요구하는 4항(측정 대상·도구·임계·분모, `evaluation-rubric.md:98`)이 G3 에도 그대로 채워져 있다.

| 요소 | G3 의 값 | 좌표 |
|---|---|---|
| ① 측정 대상 | 재현 결정론 (RULE-17 명시 지목) | `:571` |
| ② 도구 | `gates/repeat_k.py` | `:571` |
| ③ 비교 단위 | **최종 상태**(선택 옵션 집합 + `final_price`) | `:571`, `:602` |
| ④ 반복 횟수 k | **k = 8** | `:571` |
| ⑤ 임계 | **8/8 일치 = 100%** · 금액 **허용오차 0** | `:571` |
| ⑥ 분모 | **20 의도 × 8 = 160회** (골든 의도 20건) | `:571` |
| ⑦ 실패 시 후퇴 | LLM 영향분(Scorer ④)의 결정론 테이블 하강 → 그래도 불가 시 **뉴로 계층 폐기, 관리자 도구로 강등** | `:571` |

*"무엇을 몇 회 돌려 무엇을 비교하는가"* 세 항이 모두 답해져 있다 — 골든 의도 20건을, 각 8회, 최종 상태로. 방향 서술("재현성을 높인다")이 아니라 수치와 분모다.

**(a) 판정: 위반 없음.**

### 2.2 (b) — 비교 대상이 최종 상태인가

`:571` 원문 — *"골든 의도 20건 × k=8, **최종 상태**(선택 옵션 집합 + `final_price`) 비교"*.
`:602` 원문 — *"비교 대상은 **최종 상태**(선택 옵션 집합 + `final_price`)이며 **대화 텍스트가 아니다**"*.

루브릭 norm 문언은 *"같은 최종 상태(선택 옵션 집합 + 최종가)"*(`evaluation-rubric.md:80`)다. 설계의 표현은 이 문구와 **축자 일치**한다(`선택 옵션 집합` 동일 어휘, `최종가` ↔ `final_price`).

- **루브릭 문언 기준**(비교 대상이 대화 텍스트인가): 아니오. `:602` 가 명시적으로 부정.
- **과제 지시문 기준**(중간 산출물끼리 비교인가): 아니오. `final_price` 는 `evaluate_price` 의 최종 반환 금액이고(`pricing.py:428` 계약), `선택 옵션 집합` 은 루프가 위젯에 넘기는 **종단 산출물**(`:443` *"루프의 산출물은 '전 슬롯이 확정된 selections 집합'"*)이다. 중간 산출물(`rollout_ms`·`cache_hit`·후보별 중간 Outcome)은 비교 대상에 들어 있지 않다.

**(b) 판정: 위반 없음.**

### 2.3 (c) — 확보 수단이 모델 설정에만 의존하는가

`:602` 원문 — *"결정론 확보 수단은 **모델 설정이 아니라 엔진 쪽** — 후보 도메인의 결정론 열거 + 사전선언 사전식 채점 + ⑥ 안정 tie-break(`pricing.py:288-291` 사상 승계)"*.
`:571` 원문 — *"불일치 시 처방은 **temperature가 아니라** LLM 영향분(Scorer ④)의 결정론 테이블 하강"*.

문서 전체에서 `temperature` 는 **부정 문맥 1회**(`:571`)만 등장하며, 결정론의 근거로 제시된 적이 없다. 실제 결정론 담지자 4개를 각각 추적했다.

| # | 결정론 장치 | 문서 좌표 | 라이브 근거 (내가 재실측) |
|---|---|---|---|
| 1 | **후보 도메인의 결정론 열거** | `:249`, `:430`, `:491` | **S-5** — `_sim_dim_candidates` 는 `return sorted({str(v) for v in ...})` (`price_views.py:2698`). 집합을 **정렬**해 반환하므로 호출 순서·쿼리 플랜과 무관하게 동일 리스트. 열거 자체가 엔진 쪽 결정론 |
| 2 | **사전선언 사전식 채점** | `:359-375` | Scorer key 6튜플이 문서에 전개되어 있고, LLM 은 ④ `pref_score` 가중치에만 들어간다(`:368`, `:375` *"LLM은 순서에만 영향을 주고 ①~③을 뒤집을 수 없다"*) |
| 3 | **⑥ 안정 tie-break** | `:369`, `:373` | 사상 근거 `pricing.py:288-291` (`_component_rows_bulk` 의 행 내용 기반 타이브레이크). 동률 시에도 후보 선택이 고정 |
| 4 | **`as_of` 세션 핀** | `:421`, `:271` | `pricing.py:428` 시그니처의 `as_of` 인자. 세션 중 시계열 변경이 후보 비교를 무너뜨리지 못하게 고정 — 시간축까지 결정론화 |

네 장치 전부 **엔진·심볼릭 쪽**이며 모델 설정(temperature/seed/top_p)은 하나도 없다. 나아가 §7 S1~S2 는 LLM 없이 진행하고 S3 에서야 뉴로를 부착하므로(`:553`), 결정론 층의 재현성은 LLM 부착 **이전에** 확정된다.

**(c) 판정: 위반 없음.**

### 2.4 위반은 아니나 기록하는 것 (NOTE 급 · 등급 없음)

루브릭 §3.1 NOTE 정의 — *"위반은 아니나 기록할 위험이 있다"*(`evaluation-rubric.md:230`). 다음 둘은 `violation_test` 어느 항에도 해당하지 않으므로 **위반으로 세지 않는다.**

1. **`gates/repeat_k.py` 는 미래 산출물이다.** 저장소에 실재하지 않으며(게이트가 U-4 로 이미 등재, `gate-report.md:79`), 이 판정은 **문언 대조**다. 다만 (c)의 4개 결정론 장치 중 1·3·4 는 라이브 코드에서 실재를 확인했으므로(위 표), 문언이 허공에 뜬 것은 아니다.
2. **골든 의도 20건의 선정 기준이 명세되지 않았다.** `violation_test` (a)는 *"무엇을 몇 회 돌려 무엇을 비교하는가"* 만 묻고 *"표본을 어떻게 고르는가"* 는 묻지 않으므로 위반이 아니다. 다만 편향된 20건은 k=8 을 쉽게 통과시킬 수 있다. 설계는 파일럿 편향에 대해 이미 자기 방어를 걸어 두었으므로(`:541` 6번째 선정 조건, `:543` 완화 순서 고정) 같은 규율을 G3 골든 표본에도 적용하는 것이 정합적이다 — **권고이지 요구가 아니다.**
3. **N5(`as_of` 달력 경계)는 여기 걸지 않는다.** `gate-report.md:247` 이 이미 NOTE 로 등재했고, RULE-17 (a)(b)(c) 어느 항에도 해당하지 않는다. 재차 거는 것은 FP-4 다.

### 2.5 RULE-17 종합

```
RULE-17 (MAJOR · 재현 결정론)
  (a) 측정 방법·분모·임계:  7요소 전건 존재 (20의도 × k=8 = 160회, 허용오차 0) → 위반 없음
  (b) 비교 대상 = 최종 상태: 루브릭 문언과 축자 일치 · 대화 텍스트 부정 명시    → 위반 없음
  (c) 엔진 쪽 확보:          결정론 장치 4개 전부 엔진·심볼릭 · temperature 0   → 위반 없음
  ─────────────────────────────────────────────
  판정: 위반 없음
  새로 제기한 위반: 0건 · 기록만: 3건(구현 미실재 · 골든 표본 기준 · N5 중복 회피)
```

---

## 3. `/validate` 부작용 실측 (U-5 · FIX-4 선행 조건)

### 3.1 왜 확정적으로 답해야 하는가

`gate-report.md:80` (U-5) — *"`/validate` 의 부작용 유무 … 명시 미확인. A2 교정안 1)이 이 경로를 오라클로 쓰므로 **S1 착수 전 실측 필수**"*.
`gate-report.md:374` (조건 ③) — *"U-5 실측. 부작용 있으면 FIX-4 의 `/validate` 경로도 폐기 · 미충족 시 **fail-open 도입(RULE-13 (a) 위반)**"*.

즉 미확인 상태로 오라클을 채택하면 그 자체가 RULE-13 (a) 위반이다. 아래는 추론이 아니라 원본 라인 실측이다.

### 3.2 라우팅과 핸들러

| 항목 | 값 | 좌표 |
|---|---|---|
| URL 바인딩 | `path("api/w/v1/validate", wapi.api_validate, name="wapi_validate")` | `raw/webadmin/webadmin/config/urls.py:167` |
| 핸들러 | `def api_validate(request)` (데코레이터 `@api_endpoint(("POST",))` `:1409`) | `raw/webadmin/webadmin/catalog/widget_api.py:1410` |
| 본문 범위 | `:1411-1440` | 동일 파일 |

### 3.3 판정: **부작용 있음** — 정확한 발생 라인

부작용은 핸들러 본문이 아니라 **모든 위젯 API 가 공유하는 공통 게이트 `_gate`** 에서 발생한다. 호출 사슬:

```
api_validate            widget_api.py:1410
  └─ _gate(request, body)   ← widget_api.py:1414 에서 호출
       ├─ _rate_ok(site.site_cd)   widget_api.py:218   →  캐시 mutation
       └─ _touch_used(w, request)  widget_api.py:226   →  DB UPDATE
```

**(A) DB WRITE — `t_wgt_widgets` UPDATE**

`widget_api.py:122` `def _touch_used(w, request)` 내부:

| 라인 | 코드 |
|---|---|
| `:133` | `.filter(pk=w.pk)` |
| `:135` | `.update(last_used_dt=timezone.now(), last_used_org=org)` |

- 대상 모델: `M.TWgtWidgets` (라이브 `t_wgt_widgets`)
- 호출부: `widget_api.py:226` — `_touch_used(w, request)   # 최근사용 기록(1시간 1회)`
- 스로틀: `widget_api.py:119` `USE_TOUCH_SEC = 3600` + `:134` 의 `Q(last_used_dt__isnull=True) | Q(last_used_dt__lt=cutoff)` 조건 → **위젯당 최대 1시간 1행**
- 단, **조건 불일치여도 `UPDATE` 문 자체는 DB로 발행**된다(`.filter(...).update(...)` 는 항상 SQL 을 보내고 0 rows affected 로 끝날 뿐)
- 실패 무해 설계: `:136-137` `except Exception: pass`

**(B) 캐시 mutation — rate limit 카운터**

`widget_api.py:191` `def _rate_ok(site_cd)` 내부:

| 라인 | 코드 |
|---|---|
| `:195` | `n = cache.get_or_set(key, 0, timeout=120)` |
| `:196` | `cache.incr(key)` |

- 호출부: `widget_api.py:218` — `if not _rate_ok(site.site_cd)`
- **스로틀 없음 — 매 요청 실행**
- 무효 `site_key` 경로에는 `_rate_ok_ip` (`:159`)가 동일 패턴으로 작동(`:165` `cache.get_or_set`, `:166` `cache.incr`)
- 상한 상수: `:140` `RATE_LIMIT_PER_MIN = 240   # 사이트별 분당 요청 상한 (LocMem — 프로세스 단위)`

### 3.4 `/handoff` 로깅 계층은 타지 않는다 (명확)

게이트가 재실측한 `/handoff` 의 DB 로그(`M.TWgtHandoffLogs.objects.create`, `gate-report.md:33` R-2)는 `/validate` 경로에서 **실행되지 않는다.**

| 근거 | 내용 |
|---|---|
| `_log_handoff` 호출부 | `widget_api.py:1963` — `api_handoff` 내부, **유일** |
| `_should_log` 호출부 | `widget_api.py:1629` — `_log_handoff` 내부, **유일** |
| 로깅 데코레이터 존재 여부 | **없음.** 파일 내 데코레이터 전수는 `@api_endpoint(...)` / `@csrf_exempt` 뿐 |
| `api_endpoint` 자체 | `widget_api.py:230-254` — csrf_exempt + CORS 헤더 부착만. DB/파일/캐시 미접촉 |

즉 `/validate` 의 부작용은 `/handoff` 대비 **훨씬 가볍다**. 그러나 **0 은 아니다.**

### 3.5 나머지 호출 함수 — 전부 write-free

`api_validate` 가 `_gate` 이후 호출하는 것들을 전수 확인했다. 각 함수 본문 구간에 write 패턴(`.save(`/`.create(`/`.update(`/`.delete(`/`bulk_create`/`get_or_create`/`cursor`/`cache.`/`lru_cache`/`open(`/`global `) 매치 0.

| 함수 | 위치 | 판정 |
|---|---|---|
| `_body` | `widget_api.py:79-91` | `json.loads` 만 |
| `_prep_selections` | `:424-432` | dict 조립 + `PV._select_default_plate` |
| └ `PV._select_default_plate` | `price_views.py:2223-` | read-only (S-4 로 write 구간 밖 확인) |
| `_check_dim_precision` | `:442-452` | 순수 문자열 검사 |
| `_prep_proc_sels` | `:589-638` | read-only (`_allowed_procs` `:520`, `PV.product_proc_ranges`·`proc_side_sel_map`·`apply_pos_names`·`proc_detail_inputs` 전부 조회) |
| `_eval_violations` | `:1313-1406` | read-only (`.values()` + `jsonLogic`) |
| └ `PV._sim_active_rules` | `price_views.py:2513-` | **S-7** read-only |
| └ `PV._sim_selection_to_constraint_data` | `price_views.py:2627-` | read-only |

### 3.6 이 실측이 FIX-4 에 미치는 파급 (새 위반 주장 아님)

`gate-report.md:374` 조건 ③의 발동 조건이 **충족되었다.** 따라서:

| FIX-4 항목 | 현 상태 | 필요한 조치 |
|---|---|---|
| *"라이브 환경: 오라클을 `/validate` 단독으로 축소"* (`gate-report.md:174`) | **성립 불가** — `/validate` 도 라이브 write(§3.3 A)를 유발 | 이 경로 **폐기**. 조건 ③ 원문 그대로 *"부작용이 있으면 이 경로도 폐기(미확인 통과 금지 — RULE-13 (a) fail-open 금지)"* |
| *"`/handoff` 축: 폐기 가능한 clone DB 전용"* (`:175`) | 유지 | G6 오라클은 **clone 환경 리플레이 단일 경로**로 남는다 |
| G1 분모 정정 + G1.1 서브게이트 (`:177`) | **대상 확대 필요** | 현행 문안은 `t_wgt_handoff_logs` 제외만 다룬다. `/validate` 리플레이도 `t_wgt_widgets.last_used_dt` 를 갱신하므로 G1 의 `max(upd_dt)` 해시(`design-FINAL.md:568`)를 흔든다. 제외 대상에 **`t_wgt_widgets` 를 추가**하고 동일하게 대체 계측을 한 쌍으로 문서화 |
| 캐시 축 | 신규 인지 | `_rate_ok` 카운터(`:195-196`)는 라이브 DB 밖(LocMem, `:140`)이라 G1 46테이블 분모에 안 잡힌다. **G1 이 구조적으로 못 보는 부작용 축**임을 §11 감수 위험에 기록 |

> **[등급 기록]** 위 4행은 **새 루브릭 위반 주장이 아니다.** RULE-13②·RULE-14② 위반은 이미 A2 로 확정되어 FIX-4 가 배정됐고(`gate-report.md:57`), 이 실측은 그 FIX-4 의 **선행 조건을 채우고 교정 내용을 확정**한 것이다. 새 위반 건수 0.

### 3.7 미확인 (회색지대 · 정직 기록)

| # | 미확인 항목 | 왜 미확인인가 | 판정 영향 |
|---|---|---|---|
| V-1 | `RssLogMiddleware` 본문 | `config/middleware.py` 미독해. `config/settings.py:253-264` 상 `DEBUG_RSS=1` 일 때만 활성 | **없음** — 프로덕션 기본 비활성 [추정]. 활성이어도 §3.3 의 두 부작용은 이미 확정이므로 판정이 뒤집히지 않는다 |
| V-2 | 캐시 백엔드 실체 (LocMem vs Redis) | `REDIS_URL` 실환경 설정 미확인. `widget_api.py:140` 주석은 LocMem 표기 | **부작용의 *성격*만 갈린다** — LocMem이면 프로세스 로컬, Redis면 공유 외부 상태. 유무 판정은 불변 |
| V-3 | `ATOMIC_REQUESTS` 설정 | 미확인 | 켜져 있으면 `_touch_used` UPDATE 가 요청 트랜잭션에 묶인다. **유무 판정 불변** |

세 항목 모두 **"부작용 있음"이라는 결론을 뒤집지 않는다.** 결론은 §3.3 의 두 라인(`widget_api.py:135`, `:195-196`)에 직접 근거한다.

---

## 4. 종합 — 위반 확정 / 위반 없음 / 미확정 분류

### 4.1 판정표

| 항목 | 검사항 | 판정 | 근거 요지 |
|---|---|---|---|
| **RULE-03** (BLOCKER) | (a) 선택 전 계산 경로 | **위반 없음** | frontier→rollout→JointTransition (a)~(g)→Outcome→Scorer→PICK→관측 사슬 완결(§1.1). T4(`:491-506`)가 3후보 각각의 가능여부·가격·결손축을 선택 전에 산출 |
| | (b) 부작용 0 | **위반 없음** | 명세 6근거(`:17`·`:345`·`:506`·`:568`·`:776`·`:219`) + 호출 대상 6심볼 라이브 실측 전건 write/캐시/로그 0 (S-1~S-10) |
| | (c) 사후통보 잔존 | **위반 없음** | 5검사 전건 부정(§1.3). 잔존 `/handoff` 422 는 루브릭 §0.4 심사 대상 밖 + 구조상 커밋 前 거부 |
| **RULE-17** (MAJOR) | (a) 측정 방법 | **위반 없음** | G3(`:571`) 7요소 — 20의도 × k=8 = 160회, 임계 8/8·허용오차 0 |
| | (b) 최종 상태 비교 | **위반 없음** | `:571`·`:602` 가 루브릭 norm(`:80`)과 축자 일치. 대화 텍스트 부정 명시 |
| | (c) 엔진 쪽 확보 | **위반 없음** | 결정론 장치 4개 전부 엔진·심볼릭(§2.3). temperature 는 부정 문맥 1회뿐 |
| **`/validate` 부작용** | U-5 | **부작용 있음 (확정)** | `widget_api.py:135` DB UPDATE(`t_wgt_widgets`, 1h 스로틀) + `:195-196` 캐시 incr(매 요청). 사슬 `:1410`→`:1414`→`_gate:218`,`:226` |

### 4.2 집계

```
커버리지 보충 검증 — RULE-03 · RULE-17 · U-5

  적용한 violation_test:  6항 (RULE-03 a/b/c · RULE-17 a/b/c)
  확정 위반:              0건
  위반 없음:              6항 전건
  미확정:                 0건  (두 규칙 모두 판정 가능한 근거를 확보)
  새로 제기한 위반:       0건
  회피한 FP-4 후보:       3건  (A7 재차용 · G6 재차용 · N5 재차용)
  기록만(NOTE 급, 등급없음): 3건 (§2.4)

  선행 실측(U-5):         해소 — /validate 부작용 **있음** 확정
  그에 따른 조건 ③ 발동:   FIX-4 의 /validate 오라클 경로 폐기 확정 (§3.6)

  오판 감사 (루브릭 §4.3):
    제기 총건: 0
    심리:      0    (각하: 0)
    확정 위반: 0
    오판:      0
    정밀도:    해당 없음 — 이 라운드는 반증 제기 라운드가 아니라
               **미적용 violation_test 의 적용 라운드**다.
               제기 0건이므로 R/P 는 정의되지 않으며, 이는 정밀도 미기록이 아니라
               분모 부재다(루브릭 §4.3 무효 조항의 취지는 "제기했는데 안 세는 것"의 금지).
```

### 4.3 커버리지 갱신 — `gate-report.md:123-131` 대비

```
전 18규칙 (본 보충 검증 반영 후)
  검증됨:      14  (기존 12 + RULE-03 · RULE-17)
  검증됨(약식): 2  (RULE-08 · 16 — 변동 없음)
  부분검증:     2  (RULE-10 · 18 — 이 문서의 범위 밖, 여전히 미해소)
  미검증:       0  ← 기존 2 (RULE-03 · RULE-17) 해소

BLOCKER 5개 전건 검증 완료 — 커버리지 80% → 100%
```

**CONDITIONAL_GO 조건표(`gate-report.md:370-379`) 대비:**

| 조건 | 상태 |
|---|---|
| ⑥ 커버리지 보충 (FIX-9 · FIX-10) | **충족** — 두 규칙 모두 독립 검증 완료, 위반 없음 |
| ③ 선행 실측 (U-5) | **충족(실측 완료)** — 단, 결과가 "부작용 있음"이므로 **FIX-4 문안 교정이 남는다**(§3.6). 실측 의무는 끝났고 교정 의무가 시작됐다 |
| ①②④⑤⑦⑧ | 이 문서의 범위 밖. 변동 없음 |

### 4.4 이 판정의 성격 — 무엇을 뜻하고 무엇을 뜻하지 않는가

**뜻하는 것**: 설계의 **중심 논지**(주장 C1 "빠진 것은 루프다")를 재는 유일한 BLOCKER 규칙 RULE-03 이, 이번에 루브릭 시나리오로 실제 실행되어 **통과**했다. `gate-report.md:135` 가 *"이 라운드에서 가장 큰 구조적 공백"* 이라 부른 것이 메워졌고, `:387` 의 *"이 라운드는 설계의 중심 논지를 검증하지 않았다"* 는 더 이상 참이 아니다.

**뜻하지 않는 것**(루브릭 §5-5, `evaluation-rubric.md:327`): *"18개 규칙을 모두 통과한 설계가 우아하거나 최선이라는 뜻이 아니다. 규칙은 하한선이다."* RULE-03·RULE-17 통과는 이 두 규칙의 하한선을 넘었다는 뜻이며, 설계가 좋다는 뜻이 아니다. 그리고 A1·A2·A4·A7·A8 의 확정 위반 5건과 FIX-1~FIX-8 은 그대로 남아 있다 — 이 문서는 그것들을 건드리지 않았다.

---

## 5. 이 검증이 하지 못한 것

1. **구현 검증이 아니다.** `simcore/*`·`gates/*.py`(`repeat_k.py`·`dim_parity.py`·`sideeffect.sh` 등)는 미래 산출물이며 저장소에 실재하지 않는다(게이트 U-4, `gate-report.md:79`). RULE-03(a)와 RULE-17 (a)(b)(c)의 판정은 **설계 문서 문언 대조**다. RULE-03(b)와 §3 만이 라이브 원본 실측이다.

2. **라이브 DB를 조회하지 않았다.** Railway 라이브에 `SELECT` 를 보내지 않았다. `/validate` 부작용 판정은 **정적 코드 추적**(호출 사슬 + ORM 호출 라인)이며, 실제 요청을 보내 `t_wgt_widgets.last_used_dt` 가 갱신되는 것을 관측한 것이 아니다. 다만 `.update(...)` 는 Django ORM 이 무조건 `UPDATE` SQL 을 발행하는 API 이므로(조건 불일치 시 0 rows), 이 추론은 코드 계약 수준에서 닫힌다.

3. **`_gate` 이외의 미들웨어 층을 전수하지 않았다.** §3.7 V-1~V-3 (RssLogMiddleware 본문 · 캐시 백엔드 실체 · `ATOMIC_REQUESTS`)은 미확인이다. 셋 다 "부작용 있음" 결론을 뒤집지 않지만, 부작용의 **범위와 성격**을 완전히 규정하지는 못한다.

4. **RULE-10 · RULE-18 의 부분검증은 해소하지 않았다.** `gate-report.md:111`(RULE-10 "박과 에폭시 동시 선택" 시나리오 미실행)·`:119`(RULE-18 미표기 구성물 전수 대조 미실행)는 이 문서의 조건(FIX-9·FIX-10)에 포함되지 않았으므로 손대지 않았다. 두 규칙은 여전히 **부분검증** 상태다.

5. **G3 골든 의도 20건의 실제 내용을 보지 못했다.** 아직 존재하지 않기 때문이다(§2.4-2). 따라서 "20건이 재현성을 실제로 변별하는 표본인가"는 판정 불가이며, RULE-17 통과는 **명세의 통과**이지 측정의 통과가 아니다.

6. **G6 의 clone DB 경로 실현 가능성을 검증하지 않았다.** §3.6 이 "clone 환경 리플레이 단일 경로로 남는다"고 정리했으나, clone 생성·폐기 절차와 clone↔라이브 동일성 검사(`gate-report.md:175`)가 실제로 가능한지는 인프라 사실이며 이 문서가 확인하지 않았다.

7. **웹 검색을 사용하지 않았다.** 모든 근거는 저장소 내부 `파일경로:라인` 이며 외부 URL 인용이 없으므로 검증된 URL 목록 절을 두지 않는다.
