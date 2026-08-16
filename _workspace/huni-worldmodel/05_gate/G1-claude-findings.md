# G1 렌즈 검증 결과 — 구조·실현 (Claude)

> 렌즈 G1: **계층 책임분리 · 기존 webadmin 접합 실현성 · 조합폭발 대응의 실제 작동성**
> 심사 대상: `_workspace/huni-worldmodel/04_design/design-FINAL.md` (계측 롤아웃 루프)
> 잣대: `_workspace/huni-worldmodel/04_design/evaluation-rubric.md` v1.0 (사전등록, 18규칙)
> [HARD] 규율: 모든 지적에 `파일경로:라인` 근거. 5요건 미충족 지적은 제출하지 않았다. 웹 검색 미사용 → `Sources:` 절 없음.
> 라이브 DB·`raw/webadmin`은 읽기 전용으로만 열람했다(수정 0건).

---

## 0. 요약

| 항목 | 값 |
|---|---|
| 제기 총건 | 3 |
| 5요건 충족(심리 가능) | 2 |
| 자진 각하(요건 미달 · 참고 기록) | 1 |
| 주장 등급 | MAJOR 2 · MINOR(비심리) 1 |
| BLOCKER 주장 | **0건** |
| 강점 기록 | 5건 |

**BLOCKER를 1건도 주장하지 않는다.** 5개 BLOCKER 규칙(01·02·03·04·05)의 `violation_test`를 전수 적용한 결과, 구조가 틀렸다고 판정할 근거를 찾지 못했다. 아래 F-G1-01은 RULE-02(BLOCKER 규칙)의 위반판정 ①에 걸리지만, 교정이 **선언 추가**로 끝나므로 루브릭 §3.3의 역방향 규율(승격은 교정 불가능성 논증이 있을 때만)을 스스로에게 적용해 **MAJOR(AMEND) 수준으로만** 제출한다. 등급을 부풀리지 않는 것이 §0.1 ③(표면적 역선택) 방지의 대칭 의무다.

---

## 1. 심리 요건 충족 지적

### F-G1-01 · `selections` 값 도메인 선언이 12축 중 5축에서만 실재한다 — frontier 후보 열거가 print_opt_cd에서 성립하지 않는다

- **위반 RULE-ID**: RULE-02(인터페이스 타입화) 위반판정 ①. 파급 대상 주장 = **C1**
- **주장 등급**: **MAJOR** (RULE-02는 BLOCKER 규칙이나 위 사유로 등급 승격을 주장하지 않는다)

**(b) 실패 시나리오**

- 입력: 파일럿 상품 = 명함류 1종, `qty=500`. 5개 슬롯 확정 후 6번째 슬롯이 **`print_opt_cd`(인쇄옵션·도수)**. `frontier(state)`가 이 축의 후보를 열거한다.
- 기대: 설계 §3 ①과 §4.1 선언대로 `price_views._sim_dim_candidates(prd_cd, "print_opt_cd")`가 상품 보유 인쇄옵션 후보를 반환 → 3개 후보 롤아웃 → §6 T4 시나리오 성립.
- 실제(예상): `_sim_dim_candidates`의 매핑 dict에 `print_opt_cd` 키가 **없다**. `q = {...}.get(dim)` → `None` → `if not q: return []` (`raw/webadmin/webadmin/catalog/price_views.py:2686-2694`). 후보 **0개**. 결과는 둘 중 하나이며 둘 다 설계 목표를 깬다.
  1. 슬롯이 `UNKNOWN`으로 남는다 → §6 T6의 "전 슬롯 확정" 조건 미달 → 루프가 위젯 인계 지점에 도달하지 못한다.
  2. 고객이 발화로 도수를 명시해도 `IntentValidator`가 값 도메인(빈 집합) 밖으로 보고 fail-closed 반려(§8-1 #1) → 정상 입력이 거부된다.
- 동일 결함이 걸리는 축: 선언된 12축(`NON_QTY_DIMS` 9 + `TIER_DIMS` 3) 중 `_sim_dim_candidates`가 실제로 처리하는 것은 `siz_cd`·`plt_siz_cd`·`mat_cd`·`proc_cd`·`bdl_qty` **5축뿐**이며, `print_opt_cd`·`opt_cd`·`coat_side_cnt`·`spot_side_cnt`·`siz_width`·`siz_height`·`min_qty` **7축은 빈 집합**이다. (뒤 4축은 파생·티어 축이라 열거 대상이 아닐 수 있으나, 설계 문서가 그 구분을 하지 않고 12축을 한 줄로 묶어 선언한 것 자체가 ① 미충족의 형태다.)

**(c) 근거**

- 설계 선언: `04_design/design-FINAL.md:246-249` — *"dim 키 도메인 = pricing.NON_QTY_DIMS ∪ pricing.TIER_DIMS … 값 도메인 = price_views._sim_dim_candidates(prd_cd, dim) (py:2683)"* (단일 blanket 선언, 축별 `t_*` 출처 없음)
- 축 12개 실재: `raw/webadmin/webadmin/catalog/pricing.py:45-46`(`NON_QTY_DIMS` 9종), `pricing.py:52`(`TIER_DIMS` 3종)
- 후보 함수 커버리지 5축: `price_views.py:2683-2694` — dict 키가 `siz_cd`/`plt_siz_cd`/`mat_cd`/`proc_cd`/`bdl_qty` 5개, `if not q: return []`
- `print_opt_cd`가 1급 상품 축임: `price_views.py:33`(`DIM_META["print_opt_cd"] = ("인쇄옵션","fk","TPrtPrintOptions",…)`), `views.py:1888`(`OPT_REF_DIM.06 → TPrdProductPrintOptions`), `models.py:452-463`(`t_prd_product_print_options.print_opt_cd`, nullable)
- 참고: 설계 §5.2의 재사용 근거표도 `_sim_dim_candidates`를 "차원 도메인 열거"로 단일 지정한다(`design-FINAL.md:430`) — 대체 열거원이 문서 내 다른 곳에 없다.

**(d) 자기 반증조건**

설계 문서 어딘가에 (i) `print_opt_cd` 등 잔여 축의 별도 도메인 출처(`t_prd_product_print_options` 등)가 명시돼 있거나, (ii) `selections` 키를 실제 열거 대상 5축으로 좁힌다는 범위 선언이 있거나, (iii) `_sim_dim_candidates`가 이 축들을 반환하는 코드가 라이브에 존재하면 이 지적은 철회한다(FP-1).

**(e) 교정 방향**

RULE-02 ①을 축별로 만족시킨다 — `selections` 12축을 세 부류로 나눠 문서에 표기한다.
1. **열거축(5)**: `_sim_dim_candidates` 그대로.
2. **열거축(추가 필요)**: `print_opt_cd`는 `t_prd_product_print_options`(`prd_cd`, `del_yn='N'`)의 `print_opt_cd` distinct — 단 PK가 `(prd_cd, opt_id)`이고 `print_opt_cd`가 nullable이므로 NULL 행 처리 규약을 함께 선언해야 한다. `opt_cd`는 `t_prd_product_options` 소속으로 이미 `opt_sels`에 도메인이 있으므로 `selections` 키에서 제외할지 여부를 명시.
3. **파생축(비열거)**: `siz_width`/`siz_height`/`min_qty`는 `siz_cd`·`qty`에서 엔진이 환원하므로(`pricing._reduce_siz_dims` 정의 `pricing.py:315`, 호출 `pricing.py:446`) Intent 입력 축이 아님을 선언. `coat_side_cnt`/`spot_side_cnt`도 같은 판단이 필요.

이 교정은 새 규칙 작성이 아니라 **선언 보강**이므로 RULE-12(정의 증식)를 새로 위반하지 않는다. 다만 2번은 새 SELECT 1개를 요구하므로 **주장 C1의 반증조건("새 도메인 규칙을 1줄이라도 작성해야 하면 틀렸다")에 부분적으로 걸린다** — S1 착수 시 이 한 줄이 "조립"인지 "신규 작성"인지 판정 기록에 남길 것을 권고한다.

---

### F-G1-02 · G6(막다른 길 예측 게이트)와 O2 관측 채널이 라이브 write를 수반한다 — §0 "라이브 write 0건" 자기모순

- **위반 RULE-ID**: RULE-13(실패 검출·되돌리기) 위반판정 ②, RULE-14(사람 개입 배치) 위반판정 ②. 파급 대상 주장 = **C4**
- **주장 등급**: **MAJOR**

**(b) 실패 시나리오**

- 입력: S2 이후 G6 실행 — 파일럿 상품의 프론티어 스윕 조합(예: 40조합)을 설계 §7 게이트표 G6 지시대로 `/validate`·`/handoff`(테스트 사이트키)로 리플레이한다.
- 기대: 설계 §0 *"라이브 write 0건(사이드카 저장소만 사용)"* · §12-2 *"라이브 DB에 단 한 행도 쓰지 않는다"* 가 유지된다.
- 실제(예상): `api_handoff`(`widget_api.py:1959`)는 `_handoff_core` 실행 직후 **무조건** `_log_handoff(ctx, resp)`를 호출하고(`:1963`), 그 함수(`:1602`)는 성공·실패(400/403/404/409 게이트 실패 행 포함)를 가리지 않고 `M.TWgtHandoffLogs.objects.create(**row)`로 **라이브 `t_wgt_handoff_logs`에 INSERT**한다(`:1677`). 1단 실패 시에도 `_log_handoff_fallback`(`:1688`)이 최소 행 INSERT를 다시 시도한다(`:1692`). 이어서 `_purge_handoff_logs()`(호출 `:1683`, 정의 `:1707`)가 보존정책에 따라 기존 행을 **DELETE**할 수 있다(`:1733`). dry-run/preview 파라미터는 존재하지 않는다(`grep -n "dry_run|dryrun|preview" widget_api.py` → 해당 없음).
  → 40조합 리플레이 = 라이브 로그 테이블에 최대 40행 INSERT + purge DELETE 가능. 게다가 이 테이블은 현재 **0행**이므로(`02_diagnosis/D8-live-schema.md:66-68`, 설계 §11-1이 인용) 리플레이가 다른 트랙의 "0행" 판정 baseline 자체를 오염시킨다.
- 부수 결과: 같은 write가 **O2 관측 채널**(설계 §4.7 표 — 관측원 `widget_api /handoff` 실제 응답)에서도 상시 발생한다. 즉 1회성 게이트가 아니라 상시 채널이다.
- 규칙 적용: RULE-13 ② — 라이브 write를 수반하는 단계에 **백업·DRY-RUN·undo 중 하나라도 빠지면 위반**. G6/O2에 셋 다 없다(§7 게이트표·§13 미확인 목록 어디에도 없음). RULE-14 ② — 라이브 write에 인간 승인 게이트가 없는 것이 1건이라도 있으면 위반. G6/O2 실행에 승인 게이트가 없다(설계 §8 RULE-13 대응란은 *"라이브 write 0건이므로 (b)는 공허 충족"*이라고 적었는데, 그 전제가 성립하지 않는다).

**(c) 근거**

- 설계 자기선언: `design-FINAL.md:17`(§0 "라이브 write 0건"), `:776`(§12-2 "단 한 행도 쓰지 않는다"), `:600`(§8 RULE-13 대응 "공허 충족")
- 설계의 write 유발 지점: `design-FINAL.md:574`(G6 — *"스윕 조합을 `/validate`·`/handoff`(테스트 사이트키)로 리플레이"*), `:406`(O2 채널 = `/handoff` 실제 응답)
- 라이브 코드 실측: `raw/webadmin/webadmin/catalog/widget_api.py:1959`·`:1963`(`api_handoff` = core + `_log_handoff` 무조건 호출), `:1677`(`TWgtHandoffLogs.objects.create(**row)`), `:1688`·`:1692`(fallback INSERT), `:1683`·`:1733`(purge `.delete()`), `:1477`·`:1603`(주석 — "부수 효과, best-effort 기록")
- 기저 사실: `02_diagnosis/D8-live-schema.md:66-68`(`t_wgt_handoff_logs` 0행)

**(d) 자기 반증조건**

(i) G6 리플레이 대상이 라이브가 아닌 별도 스테이징/복제 인스턴스라는 명시가 설계 문서에 있거나, (ii) `/handoff`에 로그 기록을 건너뛰는 경로(파라미터·설정 플래그)가 라이브 코드에 존재하거나, (iii) `t_wgt_handoff_logs`가 라이브 46테이블 범위 밖의 사이드카로 이미 분류돼 있으면 이 지적은 철회한다. 특히 (ii)는 내가 `widget_api.py` 전수 grep으로 부재를 확인했으므로, 반례가 나오면 FP-2로 집계한다.

**(e) 교정 방향**

세 선택지 중 하나를 문서에 명시하면 RULE-13 ②·RULE-14 ②를 동시에 만족한다.
1. **G6 축소** — 리플레이를 `/validate`(write 없음으로 확인된 경우에 한함)로 한정하고, `/handoff` 대조는 실운영 발생분을 **사후 읽기**로만 수집한다. 이 경우 O2가 더 얇아지는 것을 §11-1에 정직하게 추가 기록.
2. **G6 격리** — 라이브 스냅샷 복제본에서 리플레이하고, 그 사실과 스냅샷 시점(`source_digest`와 동일 다이제스트)을 게이트 산출물에 남긴다.
3. **G6 유지 + 안전장치 명시** — §7 게이트표 G6 행에 (백업: 실행 전 `t_wgt_handoff_logs` 스냅샷 / DRY-RUN: 1건 선행 후 행 증가 확인 / undo: 리플레이 `handoff_id` 목록 보관 후 삭제 절차) 3항과 **인간 승인 게이트**를 추가하고, §0·§12-2의 "write 0건" 문구를 "고객·주문 데이터 write 0건, 게이트 로그 write는 승인·undo 하에 허용"으로 정정한다.

또한 G1(부작용 게이트)의 분모가 "라이브 46테이블 `count(*)` + `max(upd_dt)` 해시 완전 일치"이므로, 교정 없이 G6를 돌리면 **G6가 G1을 스스로 깨뜨린다**(설계 §7 G1 실패 시 후퇴 열 = *"부작용 발견 시 설계 즉시 폐기"*). 두 게이트의 상호작용을 문서에서 정리할 것을 함께 권고한다.

---

## 2. 자진 각하 — 루브릭 규칙에 해당하지 않는 실현성 기록

> 아래는 **반증이 아니다.** 18규칙 어느 `violation_test`도 실패하지 않으므로 설계를 흠집내지 않으며, 루브릭 §5-1이 정한 "규칙에 없는 결함 = 루브릭 개정 안건" 경로로만 기록한다. 요건 (a) RULE-ID 지목을 충족하지 못하므로 스스로 각하한다.

### N-G1-01 · G0.5(차원 파리티 린트)의 대조 집합이 키스페이스 불일치로 상시 FAIL할 소지

- 설계 G0.5는 *"`views.py`의 4개 표면(`VAR_KEY_MAP` :61-69 / `DIM_REF_MODELS` :1882-1890 / `_DIM_LABEL_FIELDS` :1893-1901 / `_IMPACT_SECTIONS` :3670-3678) + DB 트리거 `fn_chk_opt_item_ref`의 축 집합 동일성"* 을 재고, 분모를 *"축 12종(`price_views.py:31` `DIM_META` 기준)"*, 임계를 *"5벌 전부 동일. 불일치 1건이면 빌드 FAIL"* 로 선언한다(`design-FINAL.md:352`, `:566`).
- 실측: `views.py`의 4개 표면은 **`OPT_REF_DIM.01`~`.07` 7코드 키스페이스**다(`views.py:61-69`, `:1882-1890`, `:1893-1901`, `:3670-3678`), 트리거도 *"7개 CASE"* 다(`views.py:1881` 주석). 반면 `DIM_META`는 **가격 차원 컬럼명 12키**다(`price_views.py:31-43`). 두 집합은 원소 표기 체계가 다르고(코드값 vs 컬럼명), `OPT_REF_DIM.07 = sub_prd_cd`(셋트)는 `DIM_META`에 아예 없으며, `coat_side_cnt`·`spot_side_cnt`·`opt_cd`·`siz_width`·`siz_height`·`min_qty`는 7코드 쪽에 없다.
- 함의: 문언 그대로 구현하면 G0.5는 첫 실행부터 영구 FAIL이고, §8-1 #3의 fail-closed 규약("빌드 FAIL. 롤아웃 시작 금지")에 따라 S1이 시작되지 않는다. 다만 `design-FINAL.md:800`(§13-3)이 *"G0.5의 DB 트리거 대조 방법 미확정 … S1에서 확정한다"* 고 이미 미확정으로 표기했으므로 루브릭 J-4(원장·문서가 [추정]/미확인으로 표시한 사항을 확정 결함으로 올리는 것)의 취지에도 저촉된다. **각하 유지.**
- 권고(구속력 없음): S1에서 G0.5를 확정할 때 대조 대상을 두 층으로 분리 — (i) `OPT_REF_DIM` 7코드 파리티(views 4표면 + 트리거 CASE), (ii) `DIM_META` 12축 ↔ `NON_QTY_DIMS ∪ TIER_DIMS` 파리티. 분모를 하나로 합치지 않는 것이 실행 가능한 형태다.
- 자기 반증조건: S1 산출물에서 두 키스페이스를 잇는 매핑(예: `_SIM_DIM_CONSTRAINT`, `price_views.py:2480-2486` — 5축만 매핑)을 확장해 12↔7 대응을 정의하면 이 기록은 무효가 된다.

---

## 3. 대칭 규율 — 규칙을 잘 만족하는 지점 (독립 재실측 기반)

검증자 자신도 측정 대상이므로(루브릭 §4), 아래 5건은 **설계 문서를 믿지 않고 라이브 코드를 직접 열어 확인**한 결과다.

### S1. RULE-01(BLOCKER) — LLM 출력 화살표 전수 추적이 실제로 가능하다

설계 §3 mermaid에서 LLM 노드는 `ACT`·`EXP` 둘뿐이고, 화살표는 `ACT --> IV`(IntentValidator), `PR --> EXP --> RG`(RenderGuard)로 **모두 결정론 검증기에 도착**한다(`design-FINAL.md:172-184`). 루브릭 RULE-01의 판정 절차("도착지가 evaluate_price/제약엔진/스키마 검증기가 아닌 것이 1건이라도 있으면 위반")를 그대로 적용해 전수 추적했고 **위반 0건**이다. 특히 금액 문장을 LLM 생성 대상에서 아예 빼고 `PhraseRenderer` 템플릿 치환으로 옮긴 것(`:203`, `:509`)은 규칙이 요구하는 수준을 넘는 방어선이다. Scorer 사전식 키에서 `soft_prefs`가 ④에만 들어가 ①~③(가능성·신뢰도·도달성)을 뒤집을 수 없게 한 것(`:362-375`)도 문언이 아니라 자료구조로 보장된 형태다.

### S2. RULE-04(BLOCKER)·RULE-12 — 재사용 심볼 12종을 독립 재실측한 결과 **12/12 실재**

설계 §2.2 표(`design-FINAL.md:81-94`)의 심볼 위치를 하나씩 열어 확인했다.

| 심볼 | 설계 주장 | 재실측 결과 |
|---|---|---|
| `evaluate_price` | `pricing.py:428` | 확인 — `def evaluate_price(target, selections, qty, grade_cd=None, mode="lenient", as_of=None, only_comps=None, proc_sels=None, skip_plate=False)` (`pricing.py:428-429`). 설계가 쓰겠다는 5개 인자 전부 시그니처에 실재하며 기본값 `lenient`도 사실 |
| `NON_QTY_DIMS`/`TIER_DIMS` | `pricing.py:45`/`:52` | 확인(`:45-46`, `:52`) |
| `_component_rows_bulk` | `pricing.py:284` | 확인(`:284`) |
| `DIM_META` | `price_views.py:31` | 확인(`:31-43`, 12키) |
| `qty_rule_error` | `price_views.py:1615` | 확인(`:1615`) |
| `_select_default_plate` | `price_views.py:2223` | 확인(`:2223`, 5상태 분기 docstring 실재) |
| `_SIM_DIM_CONSTRAINT` | `price_views.py:2480` | 확인(`:2480`) |
| `_sim_active_rules` | `price_views.py:2513` | 확인(`:2513`) |
| `_sim_dim_candidates` | `price_views.py:2683` | 확인(`:2683`) — 단 커버리지는 F-G1-01 참조 |
| `_sim_disallowed` | `price_views.py:2701` | 확인(`:2701`) |
| `_price_gap_errors` | `widget_api.py:455` | 확인(`:455`, 시그니처 `(res, prd_cd)`) |
| `missing_axis_names`/`resolve` | `tmpl_combo.py:204`/`:245` | 확인(`:204`/`:245`) |

접합 방식이 전부 import/호출이고 `raw/webadmin/**` 수정 단계가 0건이라는 §5의 주장은 문서 내 모순 없이 유지된다. 차원 어휘를 새로 만들지 않으므로 `ref_dim` 5벌이 6벌이 되지 않는다는 RULE-12 ③ 충족도 성립한다.

### S3. RULE-09 — `zero_reason` 교정이 코드와 정확히 맞물린다 (C 원안 대비 실질 개선)

설계 §4.3이 판정 입력을 `_price_gap_errors`에서 엔진의 `components[].data_gap`으로 옮긴 것은 코드로 지지된다: `pricing.py:654-659`가 no-match 시 `entry["data_gap"] = [{"dim": d, "value": v} …]`를 채우고(`:656`), `widget_api.py:466-470`이 `proc_cd`를 명시적으로 제외하며(*"여기 포함하면 정상 주문 전부가 차단된다"*), `:472-477`이 가족형 쌍 면제를 함수 본문 주석으로만 보유한다. 즉 **엔진의 탐지폭 > 위젯의 차단폭**이라는 설계의 진단은 사실이고, 그 간격을 플래그로 표면화하되 차단 권위는 위젯에 남긴 분업(§4.4 (e)(g))은 재구현 드리프트를 만들지 않는 형태다.

### S4. 주장 3(G8 반사실 스윕)의 전제가 코드로 지지된다

`only_comps`는 `use_dims` 선언 유무와 무관하게 구성요소를 실제로 배제한다 — `pricing.py:660-661`이 `if only is not None and comp_cd not in only:` 에서 해당 구성요소를 `included=False`(초기값, `:625` 인접 entry 생성부)로 조기 반환한다. 따라서 "판별차원 0 구성요소를 on/off로 관측한다"는 G8의 기계적 전제는 최소한 배제 경로에서는 성립한다. 설계가 이 지점을 §13-4에서 *"`only_comps`의 정확한 의미론 미확인 — G8이 첫 실측 대상"* 으로 스스로 미확인 표기한 것도 정직하다.

### S5. RULE-08 — 조합폭발 대응이 "이론만"이 아니다

전수 열거·사전계산 적재 단계가 0건이고(N-19 회피), 채택 기법(1스텝 프론티어 롤아웃 + 재계획 + 예산 제한 도달성 프로브)에 대해 파일럿 실측 항목·임계·분모·**실패 시 무엇을 버리는가**가 G7에 명시돼 있다(`design-FINAL.md:575`). 특히 *"미측정이면 실패"* 와 *"p95 > 2s면 고객 실시간 루프를 폐기하고 관리자·CS 도구로 강등"* 은 임계 재설정으로 도망가지 않겠다는 구속이다. 비용 우려(주장 5)의 근거인 `_component_rows_bulk` 전량 로드도 실측 확인했다(`pricing.py:284-295` — `filter(comp_cd__in=…).values(…)` 후 파이썬 그룹핑). 설계가 자기 약점을 먼저 지목하고 게이트로 계량화한 형태다.

---

## 4. 판정 기록 (루브릭 §3.5 형식 · G1 렌즈 단독)

```
설계안:   04_design/design-FINAL.md (계측 롤아웃 루프)
루브릭:   evaluation-rubric.md v1.0 (버전 고정)
렌즈:     G1 — 구조·실현
심리 반증: 2건 / 자진 각하 1건
확정 위반 주장: BLOCKER 0건 · MAJOR 2건 · MINOR 0건
최종 등급 제안(G1 렌즈 한정): AMEND
```

**오판 감사(§4.3) — G1 렌즈 자기 신고**

```
제기 총건: 3
심리:      2    (각하: 1 — N-G1-01, 요건(a) RULE-ID 미충족 자진 각하)
확정 위반 주장: 2
오판:      (미정 — 설계 측 반박 후 확정)
정밀도:    2/2 = 1.00 (설계 측 취하 반박 전 잠정치)
```

정밀도는 설계 측이 문서 내 위치를 제시해 `violation_test`를 통과시키면 재계산된다. F-G1-01·F-G1-02 각각의 자기 반증조건을 (d)항에 명시했으므로, 반박은 그 항목 하나만 보이면 성립한다.

---

## 5. 이 검증의 한계

1. **정적 독해만 했다.** 라이브 DB에 SELECT를 실행하지 않았고 `simcore`는 아직 코드가 없으므로, F-G1-01의 "후보 0개"는 함수 정의로부터의 결정론적 귀결이지 런타임 실측이 아니다. 다만 `price_views.py:2686-2694`의 분기는 조건부가 아니라 무조건 `return []`이므로 재현에 실행이 필요하지 않다.
2. **`fn_calc_pansu`/`fn_best_plate` SQL 본문과 `widget_renderer.js`는 열지 않았다.** 판걸이수 룩업·기하 폴백 구분(G5)과 캐스케이드 2벌 문제(P-21)에 대해서는 판정하지 않는다.
3. **`/validate`가 write를 수반하는지는 확인하지 않았다.** F-G1-02는 `/handoff` 경로에 한정된 주장이다.
4. **다른 렌즈(가격 정확성·운영부담) 축은 판정하지 않았다.** RULE-05·06·07·09·10·11·16·17에 대한 별도 검증은 이 문서의 범위가 아니며, 침묵을 통과 판정으로 읽어서는 안 된다.
5. 웹 검색 미사용. 근거는 전부 저장소 내부 파일이며 `Sources:` 절을 두지 않는다.
