# 후가공 proc(오시·미싱) 가격경로 코드↔DB 정밀 추적 — 260701

§14 가격엔진 이해·진단 / hped-code-schema-audit. 라이브 읽기전용 SELECT + 결정론 매칭 재현. DB 미적재.
권위 순서: ① 라이브 코드(pricing.py·price_views.py·price_simulator.html) ② 라이브 스키마/데이터.

---

## 0. TL;DR (반환)

- **오시 합산에 필요한 정확한 selection**: `proc_cd = PROC_000090`(자식) **AND** `detail.줄수 = 1|2|3`.
  둘 중 하나라도 빠지면 `no_match` → 조용히 0(저청구). 부모 029 로는 절대 매칭 안 됨.
- **미발현 근본원인 = 결함 2개가 스택**:
  1. 상품이 **부모 029** 를 바인딩(단가행은 **자식 090**) — 위젯/뷰어는 부모→자식 해소하지만, simulate 직접호출이나 부모 코드를 그대로 넘기면 미매칭.
  2. 단가행이 `dim_vals={"줄수":N}` 요구(와일드카드 없음) — **줄수 detail 미공급 시 무조건 no_match**. ★직전 실패한 "090 재키 simulate" 가 안 풀린 진짜 이유 = **줄수를 안 줬기 때문**(재키만으론 부족 — 배경에서 추정한 그대로 코드로 확정).
- **부모/자식 해소 메커니즘 유무**: 엔진(pricing.py)에는 **없음**. 부모→자식 해소는 **위젯/뷰어 옵션빌더(price_views.py:1372-1408 `_emit`+`proc_child_options`)에만** 존재. 단가행을 부모로 옮기는 교정은 위젯이 자식만 내보내므로 역효과(아래 §6).
- **정상 동작 후가공 대조 오라클 = 귀돌이(COMP_PP_CORNER_RIGHT)**: 단가행이 **자식**(027/028)에 키되고 `dim_vals` 없음 + 상품이 **자식 직접** 바인딩 → 매칭. 오시/미싱이 어긋난 두 축(부모바인딩·dim_vals)을 모두 안 가짐.
- **올바른 교정안 = (D)+위젯 경로**: 단가행은 자식 090 유지(귀돌이와 동형). 미발현 근본은 "줄수 미공급"이므로 ① 위젯/시뮬레이터가 줄수 detail 을 실제로 전송하게(필수화 또는 기본값) ② 부모바인딩→자식 해소는 위젯이 이미 함(검증 OK). ★(B) 단가행 부모로 이전 = NO-GO(위젯이 자식만 emit).
- **★4상품 전부 동일 결함(오라클 없음)**: PRD_000016(프리미엄엽서)·PRD_000018(스탠다드엽서)·PRD_000041(스탠다드 쿠폰/상품권)·PRD_000042(프리미엄 쿠폰/상품권). 오시·미싱 단가행 100% 자식+dim_vals, 상품 100% 부모바인딩.

---

## 1. 가격경로 도해 (selection → proc_sels → match → subtotal)

```
[위젯/시뮬레이터 UI]
  product_dim_options(proc_cd)  price_views.py:1372-1408
    prod_procs = TPrdProductProcesses(prd_cd)            ← 부모 029(오시)/030(미싱), mand_proc_yn='N'
    _emit(029): proc_child_options(029) → [{v:PROC_000090, t:오시}]   ★부모→자식 펼침
                o["detail"] = proc_detail_inputs(090)               ★090 빈 → 부모 029 상속 → [{key:"줄수",min:0,max:3}]
                o["mand"]  = (mand_proc_yn=='Y')  → False           ★오시는 비필수
  →  드롭다운 옵션: {v:PROC_000090, detail:[{key:줄수}], mand:false}

[simulator JS]  price_simulator.html
  L325/626  PROCSEL = options.filter(mand).map(...)   ★mand만 자동선택 → 오시 자동선택 안 됨(수동 add 필요)
  L363      addProc(v)  → PROCSEL.push({proc_cd:v})    ← v = PROC_000090(자식, 위 옵션에서)
  L424-427  detail = {줄수: input.value} (input 비면 키 생략)  ★줄수 안 넣으면 detail={}
  →  payload.procs = [{proc_cd:"PROC_000090", detail:{줄수:"1"}}]   ← 정상 케이스

[price_views.price_simulate]  L1774-1787
  proc_sels = [{proc_cd:"PROC_000090", detail:{줄수:"1"}}]   (빈/None 값 필터)
  evaluate_price(..., proc_sels=proc_sels)

[pricing.evaluate_price → _evaluate_formula]  pricing.py:643-711
  comps = TPrcFormulaComponents(frm_cd=PRF_DGP_A)            ← COMP_PP_CREASE_1L 포함(disp_seq 4) ✔ 배선됨
  _derive_price_dims(proc_sels)                              ← 줄수는 price_dim/contrib 미선언 → 주입 안 함(무관)
  for c in comps:
    use_dims = ["proc_cd","min_qty","proc_grp:PROC_000029"]
    non_qty  = [d for d if ":" not in d] = ["proc_cd"]       ★proc_grp:* 토큰 제거(L675) — 매칭 미사용
    is_proc  = "proc_cd" in non_qty = True
    if proc_sels and is_proc:                                 L694
      for ps in proc_sels:
        sel = {...selections, proc_cd:ps.proc_cd}             = {... proc_cd:"PROC_000090"}
        for k,v in ps.detail: sel[k]=v                        sel["줄수"]="1"   ★줄수 주입
        entry = _match_entry(c, rows, sel, comp_qty, ...)
        if entry.included or error or calc_error: out.append  ★순수 no_match 는 out 에서 누락(보고서서도 사라짐)

[match_component → _row_matches]  pricing.py:94-106, 134
  for d in NON_QTY_DIMS: if row[d] != sel[d] → fail          proc_cd 행=090 == sel 090 ✔
  for k,v in row.dim_vals: if sel[k] != v → fail             줄수: 행=1, sel=1 ✔  (sel 줄수 없으면 None≠1 → fail)
  → tier(min_qty) 선택 → subtotal = unit_price × qty (PRICE_TYPE.01 단가형)
```

### 결정론 매칭 재현 (실 단가행 30개 대상, qty=100, as_of=2026-07-01)

| # | selection | 결과 |
|---|-----------|------|
| A | `proc_cd=PROC_000029` (부모, detail 없음) | **no_match** ← 행이 029에 없음 |
| B | `proc_cd=PROC_000090` (자식, detail 없음) — ★직전 실패 재현 | **no_match** ← 줄수 미공급 |
| C | `proc_cd=PROC_000090, 줄수=1` | **MATCH** id=8191 unit=10,000 min_qty=100 |
| D | `proc_cd=PROC_000090, 줄수=2` | **MATCH** id=8211 unit=12,000 min_qty=100 |
| E | `proc_cd=PROC_000029, 줄수=1` (부모 재키 가정) | **no_match** ← 행이 029에 없음 |
| F | `proc_cd=PROC_000090, 줄수=1, qty=1000` | **MATCH** id=8194 unit=25,000 min_qty=1000 |

(재현 스크립트 `/tmp/sim_match.py` — pricing.py `_row_matches`/`match_component` 동일 로직, 라이브 30행 입력.)

---

## 2. 왜 자식 090 선택해도 미매칭인가 (질문2 답)

**선택만 090 으로는 부족 — 줄수 detail 이 필수.** 단가행 전수 실측(`t_prc_component_prices`, comp_cd=COMP_PP_CREASE_1L):

- 30행 **전부** `proc_cd=PROC_000090`, `dim_vals={"줄수": 1|2|3}`, 그 외 차원(siz/plt/print_opt/mat/opt/coat/bdl) 전부 NULL(와일드카드).
- `_row_matches`(pricing.py:103-105): `dim_vals` 의 모든 키는 selection 과 일치해야 함 — **와일드카드 없음**(주석 L96 "파라미터는 와일드카드 없음").
- ∴ `sel["줄수"]` 가 없으면(None) → `None != 1` → 전 행 fail → `no_match` → 순수 no_match 라 `out` 에도 안 들어감(L704 게이트) → 보고서서도 사라지고 합계 0.

직전 "090 재키 후 simulate → 여전히 0" 의 정확한 이유: 재키 자체는 맞았으나 **simulate 가 줄수 detail 을 안 보냄**(=시나리오 B). 줄수 미공급이 진짜 차단점이지 proc_cd 레벨이 아님.

(`줄수` 는 prcs_dtl_opt.inputs 에 `price_dim`/`contrib` 미선언 → `_derive_price_dims`(pricing.py:374-375) 가 무시. 즉 줄수는 코팅 coat_side_cnt 같은 자동 파생 차원이 아니라, **proc_sels.detail 로만 들어가는 raw dim_vals 매칭 키**다.)

---

## 3. 부모(029)/자식(090) 계층을 엔진이 해소하는가 (질문3 답)

- **pricing.py(엔진): 해소 안 함.** proc_cd 를 selection 값과 단가행 값의 **정확 동등**으로만 비교(_row_matches). 부모코드를 주면 자식행과 안 맞음. upr_proc_cd 를 읽는 코드 0.
- **price_views.py(위젯/뷰어 옵션빌더): 해소 함.** `_emit`(L1380) → `proc_child_options`(L112) 가 부모(하위 보유)면 자식으로 펼쳐 **자식코드만** 드롭다운에 노출(주석 L1374-1376 "상위공정 코드 자체는 절대 노출 안 함 → 가격 매칭 보장"). detail 도 `proc_detail_inputs`(자기 우선, 없으면 부모 상속)로 자식에 부여.
- `proc_grp:PROC_000029` 토큰: pricing.py 에서 **게이트/필터로 안 쓰임**(L675 가 ":" 토큰 전부 non_qty 에서 제거, L599 는 `opt_grp:` 만 특수처리). 순수 UI 힌트(split_scopes 가 드롭다운 범위 채움). → "proc_grp 게이트가 막는다" 가설 = **기각**.

**함의:** 부모→자식 해소가 위젯에만 있으므로, **위젯을 거치면 자식 090 이 정상 전송**된다. 미발현은 계층해소 결함이 아니라 **줄수 detail 전송 결함 + (simulate 직접호출 시) 자동선택 안 됨**.

---

## 4. 정상 동작 후가공 대조 오라클 — 귀돌이(COMP_PP_CORNER_RIGHT)

| 항목 | 오시 COMP_PP_CREASE_1L (결함) | 귀돌이 COMP_PP_CORNER_RIGHT (정상) |
|------|------|------|
| 단가행 proc_cd | **자식 090** (부모 029 아님) | **자식 027/028** (부모 026 아님) |
| 단가행 dim_vals | **`{"줄수":N}` 요구** (와일드카드 없음) | **없음** (proc_cd 만으로 매칭) |
| 상품 product_processes 바인딩 | **부모 029** (mand=N) | **자식 027·028** 직접 (mand=N) |
| 위젯 드롭다운 결과 | 부모→자식 펼침 필요 + 줄수 입력 필요 | 자식 그대로 노출, 추가입력 0 |
| 매칭 성립 조건 | proc_cd=090 **AND** 줄수=N | proc_cd=027or028 (끝) |

귀돌이가 동작하는 이유 = 어긋난 두 축(부모바인딩·dim_vals)을 **둘 다 안 가짐**. 오시/미싱은 둘 다 가짐 → 이중 차단.
(귀돌이 027 단가=0원이지만 매칭 자체는 성립 — 가격경로는 정상. 가격이 0인 건 별개 권위 이슈.)

★ **오시/미싱 자체에는 정상 동작 상품이 없음** — 4상품(016/018/041/042) 전부 부모 바인딩 + 단가행 자식+dim_vals 라 동일 결함.

---

## 5. "확실히 아는 것 vs 모르는 것" 지식맵 (질문5)

### 확실히 아는 것 (코드·DB 실측 확증)
- 오시 매칭 성립조건 = `proc_cd=PROC_000090` AND `줄수∈{1,2,3}`. (단가행 30행 전수 + _row_matches 로직 + 결정론 재현 C/D/F)
- 직전 simulate 실패 원인 = 줄수 detail 미전송(시나리오 B 재현 일치).
- 엔진은 부모/자식 해소 안 함 / 위젯 옵션빌더는 함 (price_views.py:1372-1408 코드).
- proc_grp:* 는 가격 매칭에 무관(pricing.py 전수 grep).
- COMP_PP_CREASE_1L 은 PRF_DGP_A 에 정상 배선됨(disp_seq 4) — 배선 결함 아님.
- 4상품 전부 동일 패턴, 귀돌이가 작동 오라클.
- 순수 no_match proc 엔트리는 보고서서 누락(L704) — "왜 안 보이나"의 코드 근거.

### 모르는 것 (확인 필요 — 결론으로 위장 금지)
- **줄수를 손님이 직접 고르는가, 자동 도출인가?** UI 상 줄수 input 은 있으나(price_simulator L386) 기본값/필수 여부 미상. 도메인상 "오시 1줄/2줄/3줄"이 손님 선택인지 상품고정인지 권위 엑셀 확인 필요. → 교정안 (D) 의 구체 방식(필수화 vs 기본값 1)을 좌우.
- **위젯(실서비스 widget.js)도 시뮬레이터와 동일하게 줄수를 전송하는가?** 본 진단은 webadmin 시뮬레이터 경로만 코드 확인. 실 위젯 payload 는 미확인.
- **상품이 부모(029)를 바인딩한 게 의도인가 오적재인가?** 귀돌이는 자식 직접 바인딩이라 비일관. 자식 직접 바인딩으로 통일하면 위젯 펼침 단계 생략 가능하나, 위젯이 이미 부모→자식 처리하므로 기능상 무해 — 정합성 이슈만.
- **줄수 0(=오시 안 함)일 때 거동** — min:0 이나 줄수 0 행은 없음. 0 선택 시 no_match(정상 미적용)인지 의도 확인 필요.

---

## 6. 올바른 교정안 (A/B/C/D)

| 안 | 내용 | 판정 | 코드 근거 |
|----|------|------|----------|
| **D ★권장** | 위젯/시뮬레이터가 **줄수 detail 을 실제 전송**(필수화 또는 기본값 1) — 단가행·바인딩 구조는 귀돌이 동형 유지(자식행+상품 부모바인딩은 위젯이 해소) | **GO(데이터 무변경·UI/전송 교정)** | 미발현 진짜 차단점=줄수 미공급(§2·시나리오 B). price_simulator.html L424-427 이 빈 줄수를 생략. 줄수만 채우면 즉시 매칭(C/D 재현). |
| C | 위젯/엔진이 부모→자식 해소 | **이미 됨(추가 불요)** | price_views.py:1380 `_emit`+`proc_child_options` 가 029→090 펼침. 엔진 추가 해소 불필요. |
| A | 상품이 자식 090/086 직접 바인딩 | **부가(정합성 개선·필수 아님)** | 귀돌이 동형 정합성↑, 위젯 펼침 단계 생략. 단 위젯이 이미 처리하므로 기능 무영향. 줄수 결함은 미해결 → 단독 불충분. |
| B | 단가행을 부모 029/030 으로 이전 | **NO-GO** | 위젯이 부모코드 절대 미노출(자식만 emit, price_views L1374-1376) → 부모행은 영원히 미매칭. 직전 UNDO 한 재키의 역방향이며 동일하게 실패. |

**결론**: 1차 = **(D)** 줄수 detail 전송 보장(필수/기본값 — §5 "줄수가 손님선택인지" 권위 확인 후 방식 확정). 부가 = **(A)** 부모→자식 바인딩 정합화(선택). (B) 금지. 단가행 자체는 정확(귀돌이와 동형 구조) — 데이터 교정 불필요.

**영향범위**: 오시·미싱 동일 구조(미싱 COMP_PP_PERF_1L = 자식 086 + dim_vals 줄수, 동일 4상품). 가변텍스트/가변이미지(proc_grp:PROC_000085, PRICE_TYPE.03)도 자식+detail 패턴일 수 있어 동형 점검 권장(본 진단 범위 밖 — 확인 필요).

**트랙**: 교정은 §18 설계 → §7 인간 승인 적재 또는 위젯/simulate 전송 로직(개발팀). 데이터 COMMIT 불요(데이터는 정확). DB 미적재 원칙 준수.

---

## 부록 — 실측 출처

- 공식 배선: `t_prc_formula_components` frm_cd=PRF_DGP_A → COMP_PP_CREASE_1L disp_seq 4 (use_dims `["proc_cd","min_qty","proc_grp:PROC_000029"]`).
- 단가행: `t_prc_component_prices` comp_cd=COMP_PP_CREASE_1L → 30행 전부 proc_cd=PROC_000090, dim_vals `{"줄수":1|2|3}`, 타 차원 NULL.
- proc 계층: `t_proc_processes` — 029(오시,부모,inputs 줄수 max3)/090(오시,자식 upr=029,inputs 빈→상속) ; 030(미싱)/086 동형.
- 상품 바인딩: `t_prd_product_processes` 016/018/041/042 → 029·030 (부모, mand_proc_yn='N').
- 오라클: COMP_PP_CORNER_RIGHT → 027/028(자식) 단가행, dim_vals 없음 ; 상품은 027·028 직접 바인딩.
- 코드: pricing.py 41-43(NON_QTY_DIMS)·94-106(_row_matches)·134-190(match_component)·362-388(_derive_price_dims)·643-711(_evaluate_formula L675 ":"제거·L694 proc 멀티평가·L704 no_match 누락) ; price_views.py 79-118·1372-1408·1774-1787 ; price_simulator.html 325·363·424-427.
- 재현: `/tmp/sim_match.py`(라이브 30행, 6 시나리오, 결정론).
