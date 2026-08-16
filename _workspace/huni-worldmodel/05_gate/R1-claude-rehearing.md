# R1 재심 — 렌즈 R1 (스키마·구조) · RULE-02 / RULE-12

> 재심관: Claude (단일 렌즈 R1) · 기준: `04_design/evaluation-rubric.md` v1.0 (수정 금지·버전 고정)
> 대상: `04_design/design-FINAL.md` **현재 판본 1,046행** (원 라운드가 본 804행 판본과 좌표가 다르다)
> 구속: `.claude/rules/moai/core/adversarial-verification-governance.md` §2(입증책임 5요건) · §3(반박 라운드) · §4.3(다수결 금지) · §6(오판 감사·커버리지 정직)
> 읽기 전용: `raw/webadmin`, 라이브 DB, `_workspace/huni-worldmodel` 판정 기록

---

## 0. 이 재심이 한 일과 하지 않은 일 (§6.6 커버리지 정직)

| 규칙 | 이 렌즈에서 | 근거 |
|---|---|---|
| **RULE-02** (BLOCKER) | `violation_test` ①②③ **전항 적용** | 아래 §1 |
| **RULE-12** (MAJOR) | `violation_test` ①② + 6벌 자동위반 절 **전항 적용** | 아래 §2 |
| RULE-05 · RULE-09 · RULE-13 · RULE-14 · RULE-10 · RULE-18 | **NOT_ASSESSED** — 이 렌즈(스키마·구조)의 범위 밖. `violation_test` 적용 자체를 하지 않았다 | — |

**"미검증"과 "위반 미확정"은 다른 상태다**(§6.6). 위 6규칙에 대해 이 문서는 어떤 통과 주장도 하지 않는다.

**새 §11(자율성 경계 선언, ESTC 3단 축)** — 루브릭 18규칙에 대응 규칙이 **없다**. 따라서 **판정하지 않는다**. 없는 규칙을 만들어 재면 그것이 FP-4다(거버넌스 §6.3, §8.4).

---

## 1. RULE-02 · 뉴로→심볼릭 인터페이스의 타입화 · BLOCKER

### 1.1 `violation_test` 축자 인용 (`evaluation-rubric.md:64`)

> **violation_test**: 설계 문서에 **의도 객체(또는 동등물)의 필드 스키마가 명시되어 있지 않으면** 위반. 명시 기준 3항 전부 충족해야 통과 — ① 필드 목록과 각 필드의 도메인 출처(어느 `t_*` 축인가), ② 미확정(unknown) 표현 방법, ③ 이 스키마를 검증하는 지점의 위치. 셋 중 하나라도 없으면 위반.

### 1.2 원 위반(A7)의 내용

원 라운드 확정: *"blanket 출처가 12축 중 5축만 실효"* — 개정 전 `selections` 값 도메인 출처가 `price_views._sim_dim_candidates` **1개로 12축 전체를 덮는 blanket** 이었으나 그 함수는 5축만 처리하고 나머지는 `return []` (`gate-report.md:272`, R-4 재실측 `gate-report.md:35`).

### 1.3 항별 적용 결과

**① 필드 목록 + 각 필드 도메인 출처 — 충족**

`design-FINAL.md:288-303` 이 `Intent` 8필드를 열거하고 각 필드에 도메인 출처를 단다(`prd_cd`→`t_prd_products.prd_cd where del_yn='N'` `:289`, `qty`→`t_prd_products`/`t_prd_product_sizes` min/max/incr `:290`, `opt_sels`→`t_prd_product_options` `:294`, `proc_sels`→`widget_api._allowed_procs`/`_coerce_detail` 화이트리스트 `:295-296`).

핵심은 위반이 확정됐던 `selections` 다. `:291-293` 이 **blanket 을 명시적으로 철회**한다 — *"dim 키 도메인 = 아래 ★FIX-1 3분류 중 '열거축'만. (`pricing.NON_QTY_DIMS ∪ pricing.TIER_DIMS` 를 blanket 으로 쓰지 않는다)"*. 그리고 `:315-321` 3분류표가 12축을 **전건 배정**한다:

| 부류 | 축 | 출처 | 좌표 |
|---|---|---|---|
| 열거축 5 | `siz_cd`·`plt_siz_cd`·`mat_cd`·`proc_cd`·`bdl_qty` | `_sim_dim_candidates` 무수정 import | `:317` |
| 열거축 +1 | `print_opt_cd` | `t_prd_product_print_options(prd_cd=?, del_yn≠'Y')` distinct · NULL 행 제외 · 라벨 `print_side`→`print_opt_nm` 폴백 | `:318` |
| 비열거축 6 | `siz_width`·`siz_height`·`min_qty`·`coat_side_cnt`·`spot_side_cnt`·`opt_cd` | **`selections` 키에서 제외** (파생축·파생 카운트·`opt_sels` 중복) | `:319-321` |

5 + 1 + 6 = 12. **분모 누락 0.** 즉 "선언된 출처가 나머지 7축에 대해 실효적이지 않았다"는 원 위반 사실이 소멸했다 — 7축 중 1축은 실효 출처를 새로 얻었고 6축은 스키마 키에서 제거되어 출처를 요구받지 않는다.

**근거의 원본 재확인(§3-1 · 반증자 인용을 그대로 받아 적지 않는다)** — 이 재심이 `raw/webadmin` 에서 직접 확인:

- `webadmin/catalog/price_views.py:2683-2699` — `_sim_dim_candidates` 의 dict 는 `siz_cd`/`plt_siz_cd`/`mat_cd`/`proc_cd`/`bdl_qty` **5키뿐**이며 `if not q: return []`. 설계의 5축 배정 **일치**.
- `webadmin/catalog/price_views.py:31-43` — `DIM_META` **12축** 실재. 설계 분모 12 **일치**.
- `webadmin/catalog/models.py:463` — `print_opt_cd = models.ForeignKey('TPrtPrintOptions', ..., blank=True, null=True)`. **nullable 마스터 FK 확인** → 설계의 "NULL 행 제외" 규정이 실코드 조건과 일치.

**② 미확정 표현 방법 — 충족**

`:286` `UNKNOWN = "<unknown>"` 단일 센티널, `:307` *"누락·`None`·빈문자열은 전부 검증 실패"*. 표현 방법이 하나로 고정돼 있고 대체 표현이 봉쇄된다.

**③ 스키마 검증 지점의 위치 — 충족**

`:308` *"`IntentValidator.validate()` 단 한 곳, 루프 진입 직전, 실패 시 fail-closed(되묻기 라우팅)"*. 위치가 특정되고 유일하다.

추가로 FIX-2(`:326-335`)가 `numeric_spans` 필수화 + `NumericIntentParser` 를 **`IntentValidator.validate()` 내부**(`:331`)에 두어, LLM 산출 수치가 원문 재파싱값과 대조되지 않고 통과하던 경로를 닫는다. ③이 요구하는 것은 "위치가 있는가"이므로 FIX-2 는 ③ 충족의 **필요조건이 아니라 강화**다 — test 를 넘는 방어선이다.

### 1.4 `print_opt_cd` SELECT — "재배선"인가 "신규 도메인 규칙 작성"인가 (렌즈 지시 항목)

설계는 이 지점을 은폐하지 않는다: `:323` *"동등 SELECT 1개를 우리 층이 작성해야 한다 … §9 주장 1의 반증조건과 접하는 지점으로 은폐 없이 기록한다"*, `:789` *"'조립만으로 성립'이라 말한 강도는 약화된다"*.

이 재심이 라이브 원본을 직접 읽어 4요소를 대조했다 (`webadmin/catalog/price_views.py` `_dim_options` 의 `print_opt_cd` 분기, `:1775` 정의 · `print_opt_cd` 분기 `:1832` 부근):

| 설계가 쓸 SELECT의 요소 | 라이브 원본 | 판정 |
|---|---|---|
| `filter(prd_cd=?)` | `M.TPrdProductPrintOptions.objects.filter(prd_cd=prd_cd)` | 복제 |
| `del_yn ≠ 'Y'` | `.exclude(del_yn="Y")` | 복제 |
| NULL 행 제외 | `# 미연결(None) 행은 선택지가 될 수 없어 skip — 기존 동작 유지` + `if c is not None` | 복제 |
| 라벨 `print_side` 우선 → 마스터 `print_opt_nm` 폴백 | 원본 주석 *"라벨은 **상품별 표시명(print_side) 우선** → 마스터 인쇄옵션명 폴백 → 코드"* | 복제 |

**판정: 재배선이다.** 값 집합 규칙·필터·라벨 폴백 순서가 전부 기존 계약의 복제이고, 새로 도입된 **판단 규칙은 0건**이다. 원 라운드의 같은 판정(`gate-report.md:156`)을 이 재심이 원본 대조로 **독립 재확인**했다(§3-1 이행 — 인용을 받아 적지 않고 코드에서 확인).

동시에 정직하게 남긴다: 라이브 로직이 `_dim_options` **내부 중첩 클로저**라 import 불가하다는 설계의 진술도 원본에서 확인된다(중첩 함수 정의 `price_views.py:1775`). 따라서 "조립만"이라는 주장 1의 강도 약화는 **실재하는 비용**이며, 설계가 그것을 기록한 것은 test 요구 밖의 자기구속이다.

### 1.5 RULE-02 판정

> **CLOSED — `violation_test` ①②③ 전항 충족. 원 위반(A7) 소멸.**

자기 반증조건: `design-FINAL.md:315-321` 3분류표에서 `DIM_META` 12축 중 어느 축이든 배정 누락이 발견되거나, `selections` 키로 남은 6축(5+1) 중 어느 축의 값 도메인 출처가 실효적이지 않음(예: 새 축의 `_sim_dim_candidates` 미처리)이 실측되면 이 CLOSED 는 철회된다.

---

## 2. RULE-12 · 단일 정의·단일 편집표면 · MAJOR

### 2.1 `violation_test` 축자 인용 (`evaluation-rubric.md:110`)

> **violation_test**: 두 검사 — ① 설계가 도입하는 각 개념(차원·규칙·효과·상태 등)에 대해 "정의가 사는 곳"이 문서에 **정확히 하나** 지정되어 있는가. 두 곳 이상이면(또는 "코드와 DB 양쪽에 둔다"면) 위반. ② 설계가 새 규칙 표현을 도입할 때 그 표현이 webadmin 폼빌더에서 역파싱 가능한지 판정이 문서에 없으면 위반. 그리고 **설계가 기존 5벌 병렬(ref_dim) 문제를 6벌로 늘리면** 자동 위반.

### 2.2 원 위반(A1 동반)의 내용

원 라운드 확정: 게이트 G0.5 의 **정의처가 두 곳으로 분열**(분모 `DIM_META` 12축 vs 감시 대상 `OPT_REF_DIM` 7축×5표면) — 한 개념에 정의처 2곳(`gate-report.md:272,284`).

### 2.3 항별 적용 결과

**① 개념별 정의처 정확히 하나 — 충족**

FIX-3 이 **한 개념 2정의처**를 **두 개념 각 1정의처**로 재구성한다(`:455-475`):

| 개념 | 정의처 (정확히 하나) | 좌표 |
|---|---|---|
| `ref_dim` 축 집합 (7축) | `sql/12_phase7_seed.sql:27,37-61` | `:451`, `:709` |
| 가격차원 어휘 (12축) | `price_views.py:31` `DIM_META` | `:452`, `:710` |
| 두 우주 사이 사상 | **projection map 1개** — 맵 파일 해시를 G0.5a 산출물에 스탬프 | `:459-470`, `:709` |
| Intent / Outcome / 문구 / 원장 / provenance-map | `simcore/intent.py` / `simcore/outcome.py` / `simcore/phrases.py` / 사이드카 DDL / 사이드카 | `:747` |

분모도 두 게이트가 각자 하나씩 갖고 §4.5(`:451-452` 35쌍/36쌍)와 §7 게이트표(`:709-710` 35쌍/36쌍)가 **일치**한다 — 문서 내부 모순 없음. projection map 은 `.06`·`.07` 및 역방향 7축의 **비사상**까지 명시해(`:468-470`) 빈칸을 남기지 않는다.

**② 새 규칙 표현의 폼빌더 역파싱 판정 — 충족**

`:747` — *"새 규칙 표현을 도입하지 않으므로 폼빌더 역파싱 판정은 '해당 없음(변경 0)'"*. test 가 요구하는 것은 **판정의 존재**이며, 판정이 문서에 있다. FIX-1 의 `print_opt_cd` SELECT 는 `t_prd_product_constraints` JSONLogic 제약 표현이 아니라 후보 열거 질의이므로 폼빌더 역파싱 대상이 아니다(§1.4 재배선 판정과 정합).

**③ ref_dim 5벌 → 6벌 자동위반 — 미해당**

§5 전건이 `pricing.py`·`price_views.py`·`widget_api.py`·`tmpl_combo.py` **무수정 import only**(`:547-588`)이고, 차원 정의를 새로 만들지 않는다. FIX-1 이 추가한 `print_opt_cd` SELECT 는 `ref_dim` 7축 우주에 대해 **양방향 비사상**으로 확정된 축이므로(`:468-472`, R-6), `ref_dim` 5벌 병렬을 6벌로 늘리지 않는다. 이 비사상 근거(`views.py:1888` 의 `.06`=`opt_id` 행 식별자 vs `models.py:463` 의 `print_opt_cd` 마스터 FK)는 이 재심이 `models.py:463` 에서 직접 재확인했다.

### 2.4 [HARD] 해석 분기 기록 (거버넌스 §4.2 · 은폐 금지)

FIX-1 로 `print_opt_cd` **후보 열거 로직**이 (i) 라이브 `_dim_options` 중첩 클로저와 (ii) 우리 층 SELECT 두 곳에 병렬 존재하게 된다. 이것을 ①의 "두 곳 이상"으로 읽을 수 있는가?

- **읽지 않는 쪽(이 재심의 채택)**: ①은 *"설계가 도입하는 각 개념"*의 정의처를 묻는다. 이 개념은 설계가 도입한 것이 아니라 라이브에 이미 존재하며, 설계는 그 복제본의 정의처를 우리 층 SELECT 1곳으로 지정하고 **두 산출의 동일성을 G0.5a 가 기계 감시**한다(`:318`, `:451` 추가 1항 — 불일치 1건이면 빌드 FAIL). 즉 분기가 무감시로 남는 구조가 아니다.
- **읽는 쪽**: 문언만 보면 같은 로직이 2곳에 산다.

**채택 이유**: 후자를 위반으로 세우려면 §2.2 (b) 재현 가능한 실패 시나리오가 필요한데, 설계가 정확히 그 시나리오(라이브 클로저 변경 → 두 산출 갈림)를 잡는 센서를 명시해 두었으므로 **재현이 성립하지 않는다**(FP-3 위험). §2.1 기본값 — 근거 불충분 시 각하 — 을 적용한다.

**재심 트리거**: G0.5a 의 "추가 1항"(`print_opt_cd` 결과 집합 동일성)이 구현 단계에서 게이트 명세에서 빠지면, 이 해석은 무효가 되고 RULE-12 ① 위반으로 승격한다.

### 2.5 RULE-12 판정

> **CLOSED — `violation_test` ①② 충족, 6벌 자동위반 미해당. 원 위반(A1 동반) 소멸.**

자기 반증조건: `design-FINAL.md:451`/`:709` 에서 G0.5a 의 `print_opt_cd` 동일성 감시 1항이 삭제되거나, projection map 의 정의처가 2곳 이상으로 갈리거나, §4.5 와 §7 의 분모(35쌍/36쌍)가 서로 어긋나면 이 CLOSED 는 철회된다.

---

## 3. 범위 밖 관찰 (판정 미산입 · 위반 주장 아님)

거버넌스 §2.3 J-3 및 루브릭 §5-1(개정 안건 경로)에 따라 **위반 등급을 내지 않고** 기록만 한다.

1. **`Intent.soft_prefs.axis` 의 값 도메인 미선언** (`design-FINAL.md:297-298`). `dir`·`w` 는 타입이 고정됐으나 `axis` 허용 집합이 선언돼 있지 않다. 다만 `soft_prefs` 는 Scorer 사전식 키의 ④에만 들어가 ①~③을 뒤집을 수 없고(`:488`, `:496`) 어떤 경로로도 코드값·금액이 되지 않으므로, RULE-02 ①이 겨눈 "심볼릭에 진입하는 값의 출처" 문제와 성격이 다르다. **위반 주장 아님** — 원 라운드가 정상으로 다루던 범위를 사후에 결함으로 올리는 것은 J-2 위험이다.
2. **G0.5a 의 `print_opt_cd` 감시가 "결과 집합"만 대상**(`:318`, `:451`). 라벨 폴백 규칙(`print_side`→`print_opt_nm`)의 갈림은 감시 문언에 포함되지 않는다. 값 도메인·금액에 영향이 없으므로 RULE-02·RULE-12 어느 `violation_test` 도 이것을 재지 않는다. 루브릭 개정 안건 후보.

두 항 모두 **어느 규칙의 violation_test 도 직격하지 않는다** — 억지로 가장 가까운 규칙에 거는 것이 원 라운드 FP-4 11건의 원인이었으므로(`gate-report.md:317-319`) 반복하지 않는다.

---

## 4. 오판 감사 (§6.2 · 이 렌즈 구간)

```
오판 감사 — R1 재심 렌즈 (RULE-02 · RULE-12)

  제기 총건:  0
  심리:       0    (각하: 0)
  중복 병합:  0 → 0
  확정 위반:  0
  오판:       0
  정밀도:     정의되지 않음 (P=0 — 제기 0건이므로 R/P 미정의)

  근거 원본 재확인(§3-1): 4건 전건 실행 — price_views.py:2683-2699 · price_views.py:31-43
                          · models.py:463 · price_views.py:1775/print_opt_cd 분기
  원본 실재 확인률: 100% (4/4)
  FP-4 자발 회피: 2건 (범위 밖 관찰 §3-1·§3-2 — 규칙에 억지로 걸지 않고 분리 기록)
  렌즈 가용: 1/1 (이 렌즈에 한함). 나머지 6규칙은 다른 렌즈 소관 — 이 문서는 미검증으로 표기
```

정밀도가 미정의인 이유는 **제기가 0건이기 때문**이며(§4.4 임계 판정 대상 아님), 검증을 하지 않았기 때문이 아니다. `violation_test` 는 두 규칙 전항에 실제로 적용됐다.

---

## 5. 결론

| 규칙 | 판정 | 한 줄 사유 |
|---|---|---|
| **RULE-02** (BLOCKER) | **CLOSED** | FIX-1 3분류가 `DIM_META` 12축을 누락 0으로 배정해 blanket 실효 결손을 소멸시켰고, ②`UNKNOWN` 단일·③`IntentValidator` 단일 지점이 그대로 유지된다 |
| **RULE-12** (MAJOR) | **CLOSED** | FIX-3 이 한 개념 2정의처를 두 개념 각 1정의처 + projection map 단일 정의처로 재구성했고, import-only 유지로 6벌 증식이 없다 |
| RULE-05 · RULE-09 · RULE-13 · RULE-14 · RULE-10 · RULE-18 | **NOT_ASSESSED** | 이 렌즈 범위 밖 — `violation_test` 미적용. 통과로 읽지 말 것(§6.6) |
| 새 §11 (ESTC 3단 축) | **판정 불가** | 루브릭 18규칙에 대응 규칙 부재. 없는 규칙을 만들어 재는 것이 FP-4 |

**이 재심은 위반을 제기하지 않았다.** 거버넌스 §2.1 — 억지로 찾지 않는 것이 정상 결과이며, 위 CLOSED 2건은 침묵이 아니라 `violation_test` 항별 적용의 결과다.

---

Sources: 웹 검색을 사용하지 않았다. 모든 근거는 저장소 내부 `파일경로:라인`이며 외부 URL 인용이 없다.
