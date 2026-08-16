# D3 — 위젯 옵션 캐스케이드 진단 (widget_api.py / widget_views.py)

대상: `raw/webadmin/webadmin/catalog/widget_api.py` (2,266줄), `raw/webadmin/webadmin/catalog/widget_views.py` (789줄)
보조 참조(주장 근거로만 인용, 진단 대상 아님): `raw/webadmin/webadmin/catalog/price_views.py`
읽기 전용 — 본 진단 과정에서 어떤 파일도 수정하지 않았다.

## 요약

- 위젯 런타임 API에는 **"현재 선택 → 가능한 다음 선택지"를 계산해서 돌려주는 엔드포인트가 존재하지 않는다.** 서버는 옵션 카탈로그 전체(`GET /widgets/<wgt_cd>`)와 제약 규칙 **원문**(JSONLogic)을 1회 내려주고, 캐스케이드 계산은 브라우저 렌더러가 한다 (`widget_api.py:264`, `widget_api.py:340`, `price_views.py:2735-2770`).
- 서버가 하는 일은 캐스케이드가 아니라 **완성된 선택 조합의 사후 검사(checker)** 다. `/validate`·`/handoff`·`/price` 모두 "이미 정해진 전체 선택"을 받아 위반/가격공백을 판정한다 (`widget_api.py:1313-1406`, `1823-1829`, `1299-1303`).
- CSP 관점: **제약 전파(propagation)가 아니다.** 관리자 시뮬레이터에만 존재하는 `_sim_disallowed`가 1변수 generate-and-test(전방 1단계 검사)를 하고 (`price_views.py:2701-2734`), 위젯 런타임 경로에는 그마저도 없다. 사전 계산 테이블도 없다(모든 판정이 요청 시점 평가).
- **막다른 길은 구조적으로 도달 가능하다.** 특히 단가행 부재(`price_gap`)와 조합템플릿 미등록(`tmpl_combo_gap`)은 제약 규칙 체계 밖에 있어 캐스케이드 UI가 예고할 수 없고, `tmpl_combo_gap`은 **의도적으로 가격 단계에서 막지 않고 주문 단계에서만 차단**한다 (`widget_api.py:11-12`, `1894-1909`).
- **(e) 상태: 완전 무상태(stateless).** 선택 이력·의도를 서버가 보관하는 지점이 0이다. 매 요청이 전체 선택을 다시 싣고, 서버는 매번 처음부터 재구성한다. 유일한 "기억"은 HMAC 서명 payload인데 그것도 최종 스냅샷이며 클라이언트가 들고 다닌다 (`widget_api.py:1915-1950`).

---

## 실측 사실 (모든 주장에 파일:라인 인용)

### F1. 런타임 API 표면 — 캐스케이드 엔드포인트 부재

`widget_api.py`가 노출하는 런타임 엔드포인트 전량:

| 엔드포인트 | 함수 | 라인 |
|---|---|---|
| `GET /widgets/<wgt_cd>` 구성 로드 | `api_widget` | `widget_api.py:361-375` |
| `GET /swatch/<kind>/<code>` 이미지 | `api_swatch_image` | `widget_api.py:388-389` |
| `POST /price` 가격 | `api_price` | `widget_api.py:1244-1307` |
| `POST /validate` 제약 검증 | `api_validate` | `widget_api.py:1409-1440` |
| `POST /handoff` 서명·인계 | `api_handoff` | `widget_api.py:1958-1964` |
| `POST /handoff/verify` | `api_handoff_verify` | `widget_api.py:2165-2166` |
| `POST /upload/presign`·`/upload/multipart` | `api_upload_presign`·`api_upload_multipart` | `widget_api.py:1973-1974`, `2141-2142` |
| `GET /catalog` | `api_catalog` | `widget_api.py:2184-2185` |

"현재 선택을 받아 각 차원의 잔여 가능값을 돌려주는" 엔드포인트는 이 목록에 없다. `/validate`는 boolean + 위반 메시지만 돌려준다: `return JsonResponse({"ok": not violations, "violations": violations})` (`widget_api.py:1440`).

### F2. 옵션 카탈로그는 "선택 전 1회, 전량" 전달

`api_widget` → `_runtime_meta(prd_cd)` 가 상품의 차원·옵션그룹·추가상품·수량규칙·페이지규칙·셋트구성을 **한 번에 전부** 내려준다 (`widget_api.py:319-357`). 각 차원은 필터되지 않은 전체 옵션 리스트다:

```
"prod_dims": [{"name": d["name"], "label": d["label"],
               "options": [_dim_opt(o) for o in d.get("options", [])]} ...]   # widget_api.py:321-323
```

즉 서버가 내려주는 옵션 집합은 **다른 선택과 무관한 정적 집합**이다. 응답에 "이 값은 지금 선택 불가"를 표시하는 필드는 없다(`_dim_opt` 화이트리스트 `widget_api.py:280`, `_grp_opt` `widget_api.py:311-317`).

### F3. 의존 규칙의 표현 형식 — JSONLogic 원문 + 차원↔변수 매핑

같은 응답에 `"constraints": m.get("constraints")` 가 실린다 (`widget_api.py:340`). 이 값은 `price_views._sim_constraints_meta(prd_cd)` 결과이며 (`price_views.py:2146`), 세 부분으로 구성된다 (`price_views.py:2735-2770`):

- `rules`: 활성 제약 규칙 `[{nm, msg, typ, logic, vars, forbid}]` — `logic`은 JSONLogic **원문**
- `dim_var`: 시뮬레이터 차원 → 제약 변수키
- `dim_val`: 차원 → {선택값 → 제약값}

해당 docstring이 설계 의도를 명시한다: *"프런트는 서버 왕복 없이(async 지연·경쟁 제거) 선택 즉시 cascade 를 계산한다."* (`price_views.py:2739`). `_runtime_meta` docstring도 *"constraints 는 프런트 ceEval 용으로 규칙 원문 포함"* 이라 적는다 (`widget_api.py:264`).

규칙 원본은 `t_prd_product_constraints` 이며 `use_yn='Y' AND del_yn='N'` 만 활성이다 (`price_views.py:2513-2535`). 규칙 유형은 코드값 `RULE_TYPE`(호환.01/금지.02/필수동반.03)이다 (`price_views.py:2516-2517`).

제약이 걸릴 수 있는 **차원 공간은 5개로 고정**되어 있다 (`price_views.py:2480-2486`):

```
_SIM_DIM_CONSTRAINT = {
    "siz_cd": ("siz_cd", "OPT_REF_DIM.01"),
    "plt_siz_cd": ("plt_siz_cd", "OPT_REF_DIM.02"),
    "mat_cd": ("mat_cd__usage_cd", "OPT_REF_DIM.03"),
    "proc_cd": ("proc_cd", "OPT_REF_DIM.04"),
    "bdl_qty": ("bdl_qty", "OPT_REF_DIM.05"),
}
```

여기에 배열형 변수 5종이 추가된다 — `sel_opts`, `sel_opt_grps`, `sel_addons`, `sel_procs`, `sel_dtl` (`widget_api.py:1380`).

### F4. 서버측 제약 평가 = 완성 조합 검사(`_eval_violations`)

`_eval_violations(prd_cd, selections, sel_opts, sel_opt_grps, proc_sels)` (`widget_api.py:1313-1406`):

1. 선택값을 제약 data로 환산 (`widget_api.py:1328`, `PV._sim_selection_to_constraint_data`)
2. 배열 변수 주입: `sel_opts`/`sel_opt_grps` (`1329-1330`), `sel_procs` (`1333`), `sel_dtl`(참인 boolean 상세옵션 `"{proc_cd}__{key}"`) (`1339-1355`)
3. **governed 스킵**: `if not all(v in data for v in scalars): continue   # governed — 부분선택 오탐 방지` (`widget_api.py:1381-1382`)
4. 공정 다중선택 시 규칙 유형별 집계 — 금지형은 전부 통과해야 하고, 필수동반/호환형은 하나만 만족하면 통과 (`widget_api.py:1318-1321`, 구현 `1389-1398`)
5. 반환은 `{"msg", "typ"}` 리스트뿐 (`widget_api.py:1405`)

즉 **어떤 값을 바꾸면 풀리는지에 대한 정보는 반환하지 않는다.**

### F5. 제약이 강제되는 지점 (다층 fail-closed)

| 층 | 무엇을 막나 | 위치 |
|---|---|---|
| 제약 규칙(JSONLogic) | 규칙 위반 조합 | `/validate` `widget_api.py:1437-1440`; `/handoff` 단일 `1823-1829`, 셋트 `1785-1791` (422 `constraint_violation`) |
| 단가행 부재 | 선택값에 `component_prices` 행 없음 → 언더차지 | `_price_gap_errors` `widget_api.py:455-517`; `/price` `1299-1303`(ok=false, `price_gap`), `/handoff` `1839-1841`(422) |
| 조합 템플릿 미등록 | 옵션조합→자재 미등록 | `/handoff` 전용 `widget_api.py:1894-1909` (422 `tmpl_combo_gap`) |
| 공정 화이트리스트 | 상품에 연결 안 된 공정 | `_allowed_procs` `widget_api.py:520-529`, 적용 `623-624`(조용히 skip) |
| 공정 상세입력 | 미선언 키로 가격차원 주입 | `_coerce_detail` `widget_api.py:532-586` (화이트리스트=보안경계 `535-537`), required 강제 `554-555` |
| 옵션 화이트리스트 | 상품 소속 아닌 옵션코드 | `_expand_opt_sels` `widget_api.py:1092-1098` (skip, 422 아님) |
| 셋트 구성 | 구성 소속·개수 범위·구성원 procs 주입 | `_check_set_members` `widget_api.py:945-978`, `_prep_set_body` `980-1034` |
| 수량 규칙 | 사이즈별 min/max/incr | `PV.qty_rule_error` 호출 `widget_api.py:1280-1282`(price), `1810-1812`(handoff) |
| 치수 정밀도 | 소수 2자리 초과 | `_check_dim_precision` `widget_api.py:442-452`, 적용 `1269-1271`, `1429-1431`, `1799-1801` |
| 건수 | cfg 범위 밖 건수 | `parse_case_cnt` `widget_api.py:675-724`, 적용 `1284-1286`, `1814-1816` |
| 원고/파일 | 업로드 미완료·타 사이트 키 | `_check_artwork` `widget_api.py:886`, S3 키 접두 검사 `1870-1873` |

이 층들은 서로 다른 저장소에서 나온다 — 규칙은 `t_prd_product_constraints`, 가격공백은 `component_prices` 매칭 실패, 조합공백은 조합 템플릿, 나머지는 마스터 컬럼. **하나의 제약 모델로 통합돼 있지 않다.**

### F6. 서버가 캐스케이드를 계산할 수 있는 코드는 있다 — 단, 관리자 경로 전용

`price_views._sim_disallowed(prd_cd, sel)` (`price_views.py:2701-2734`)가 정확히 "현재 선택 기준 각 차원의 불가값 → 이유" 맵을 만든다:

```
for cand in _sim_dim_candidates(prd_cd, dim):      # price_views.py:2724
    trial = dict(sel); trial[dim] = cand
    data = _sim_selection_to_constraint_data(prd_cd, trial, mat_usage)
    for r in ruleset:
        if not (r["vars"] - {var_key}).issubset(set(data.keys())):
            continue                                # governed
        if not jsonLogic(r["logic"], data):
            dis[cand] = r["nm"]; break
```

노출 지점은 `price_sim_constraints` — 관리자 가격 시뮬레이터 뷰다 (`price_views.py:2783-2792`). **`widget_api.py` 어디에서도 `_sim_disallowed`를 호출하지 않는다** (widget_api.py 내 grep 결과 `_sim_disallowed` 0건; 위젯이 쓰는 PV 함수는 `_build_sim_meta`·`_set_members_meta`·`_sim_selection_to_constraint_data`·`_sim_active_rules`·`qty_rule_error`·`simulate_set_core`·`_select_default_plate` 등이다 — `widget_api.py:268-269`, `1328`, `1378`, `1280`, `1264`, `429`).

### F7. 서버가 대신 정하는 값(자동 도출)은 딱 하나 — 판형

```
def _prep_selections(prd_cd, raw):
    """... 판형(plt_siz_cd) 자동 도출 — ... 판형은 내부(생산) 개념이라 위젯 사용자에게 묻지 않는다"""
    if sel.get("siz_cd") and not sel.get("plt_siz_cd"):
        best, _ps, _pd = PV._select_default_plate(prd_cd, sel["siz_cd"])
```
(`widget_api.py:424-432`)

이것은 캐스케이드가 아니라 **결정론적 파생값 계산**이다(선택지 축소가 아니라 값 1개 채우기).

### F8. 상태 — 무상태 판정 근거

- 게이트가 매 요청 site/widget/version을 DB에서 재조회: `_gate` (`widget_api.py:202-227`). 요청 간에 유지되는 핸들·세션 ID 없음.
- `/price`는 매 호출마다 `selections`, `qty`, `case_cnt`, `proc_sels`, `addons` **전량**을 body에서 받아 처음부터 평가 (`widget_api.py:1246-1307`).
- `/validate`도 동일하게 전량 수신 (`widget_api.py:1411-1439`).
- `/handoff`도 **다시 처음부터** 전량 재계산 후 서명 (`widget_api.py:1749-1855`). 이전 `/price` 호출 결과를 참조하지 않는다.
- `widget_api.py` 전체에서 `request.session` 사용 0건. `cache` 사용처는 rate-limit 카운터 (`_rate_ok` `191-199`, `_rate_ok_ip` `159-169`)와 로그 purge 스로틀 (`widget_api.py:1738`)뿐 — 선택값 저장 아님.
- 서버가 남기는 영속 기록: 위젯 최근사용 시각 (`_touch_used` `widget_api.py:122-137`, 1시간 1회), 핸드오프 로그 (`_log_handoff` `widget_api.py:1602`, 보존정책 `52-66`). 둘 다 **선택 이력 재구성용이 아니라 운영/감사용**이며, 로그는 요약 상한(`HANDOFF_LOG_SEL_OPTS_MAX = 100`, `HANDOFF_LOG_STR_MAX = 200` — `widget_api.py:63-64`)으로 잘린다.
- 상태를 들고 다니는 유일한 객체는 HMAC 서명 payload (`widget_api.py:1915-1950`) — 최종 선택 스냅샷 + 금액 + TTL 3600초 (`widget_api.py:47`). 이것도 서버 보관이 아니라 클라이언트가 들고 파트너 서버가 `/handoff/verify`로 검증하는 형태다 (`widget_api.py:9-10`).
- "의도/이력"에 가장 가까운 유일한 흔적: `_expand_opt_sels`가 클라이언트가 보낸 옵션 코드의 **순서를 보존**한다 — `codes.append(c)   # 클라가 본 순서 보존 + 중복 제거` (`widget_api.py:1085-1089`), `for code in codes:   # 클라 순서 그대로` (`widget_api.py:1127`). 이는 MES 전달용 표시 순서일 뿐 결정 이력이 아니며, 같은 함수 docstring이 *"가격 불변 선언(L39-S3) … 반환값이 pricing·selections·proc_sels 어디에도 유입되지 않는다"* 고 못 박는다 (`widget_api.py:1080-1083`).

### F9. widget_views.py는 런타임이 아니라 빌더(관리자 저작) 표면

- 작업본 로드/저장 (`widget_views.py:145-160`, `162-254`), 게시 = 항목 스냅샷을 `cfg` jsonb 버전으로 동결 (`widget_views.py:303-337`), 버전 목록·롤백 (`340-352`, `353-377`), 삭제·상태변경·템플릿 (`549-578`, `641-682`, `689-767`).
- 게시 산출물은 `{"cfg_ver": 1, "header": {...}, "items": items}` — **레이아웃 항목의 평면 리스트**다 (`widget_views.py:325-328`). 옵션 간 의존관계·가능조합을 담는 필드는 없다.
- 여기서 유일한 "필수 관계" 강제는 *숨김 항목은 기본값 필수* 다 (`widget_views.py:180-188`).
- 미리보기 주문 payload도 실제 `handoff`와 **같은 전개 함수**를 재사용해 무상태로 계산한다 (`widget_views.py:405-423`).

---

## 구조 해설

### (a) 캐스케이드/의존 규칙의 표현과 평가

**표현**: 두 층으로 쪼개져 있다.

1. *선택 가능 집합*은 마스터 연결 테이블에 있다 — 상품↔사이즈/자재/공정/판형/묶음수 (`price_views.py:2683-2698`의 `_sim_dim_candidates`가 그 테이블 목록을 그대로 보여준다). 이 집합은 **다른 차원과 무관한 1차원 집합**이다.
2. *조합 가능성*은 별도로 JSONLogic 규칙 테이블에 있다 (`price_views.py:2513-2535`). 규칙은 flat한 변수 이름공간(F3의 5차원 + 5배열변수) 위의 boolean 식이다.

**평가**: 규칙 원문이 클라이언트로 통째로 내려가고(`widget_api.py:340`), 브라우저가 선택 즉시 평가한다(`price_views.py:2739`). 서버는 같은 규칙을 **다시** 평가하되(`widget_api.py:1313-1406`) 목적이 다르다 — UI 안내가 아니라 위조 차단이다(`widget_api.py:1817-1818`: *"handoff 자체가 제약 위반을 강제 차단(클라 validate 를 우회한 API 직접 호출자 방어)"*).

이 이중 평가는 코드 곳곳에서 "한 벌로 유지하라"는 경고로 관리된다: `_eval_violations` docstring *"⚠ 렌더러 `ruleViolated()` 와 같은 규칙이어야 한다. 갈리면 화면은 통과인데 주문이 422."* (`widget_api.py:1322`), `sel_dtl` 동일 경고 (`widget_api.py:1338`), `_coerce_detail`의 required 판정축 일치 요구 (`widget_api.py:545-546`), 파일/건수/제목 상수 페어링 경고 (`widget_api.py:707-708`, `757-761`). **동일 규칙의 두 구현을 사람이 손으로 동기화하는 구조**다.

### (b) 제약이 적용되는 위치와 방식

F5 표가 전부다. 구조적 특징 세 가지:

1. **다중 방어선, 단일 모델 부재.** 같은 "불가능한 조합"이 어느 층에서 걸리느냐에 따라 응답이 다르다 — `constraint_violation`(422), `price_gap`(price는 200+ok:false / handoff는 422), `tmpl_combo_gap`(422, handoff에서만), `bad_qty`, `bad_proc_detail`, `bad_set_members`.
2. **비대칭 방지에 코드 예산이 크게 투입돼 있다.** `/validate`가 `/handoff`와 동치가 되도록 `_prep_selections`·`_check_dim_precision`·`_prep_proc_sels`를 강제로 같은 헬퍼로 태운다 (`widget_api.py:1417-1436`). 이는 층이 많아 생긴 비용이다.
3. **의도적 비대칭 1건.** 모듈 docstring이 명시: *"조합 템플릿 미등록(tmpl_combo_gap)은 주문 시점(handoff)에서만 차단한다 — 가격 자체는 정확하므로 표시(api_price)를 막지 않는다."* (`widget_api.py:11-12`).

### (c) CSP 관점 판정

CSP 어휘로 정확히 대응시키면:

| CSP 개념 | 이 시스템의 대응물 | 판정 |
|---|---|---|
| 변수(variable) | `siz_cd`, `plt_siz_cd`, `mat_cd`, `proc_cd`, `bdl_qty` + 배열변수 5종 | 존재 (`price_views.py:2480-2486`, `widget_api.py:1380`) |
| 도메인(domain) | `_sim_dim_candidates`의 상품별 활성 코드 집합 | 존재하나 **정적**(`price_views.py:2683-2698`) |
| 제약(constraint) | JSONLogic 규칙 | 존재 (`price_views.py:2513-2535`) |
| 제약 검사(consistency check) | `_eval_violations` | **존재** (`widget_api.py:1313-1406`) |
| 도메인 축소(pruning) | `_sim_disallowed` (관리자 전용) | **런타임에 없음** (`price_views.py:2701-2734`, 호출부 `2783-2792`) |
| 제약 전파(arc/path consistency) | — | **없음** |
| 사전 계산 테이블 | — | **없음** (모든 판정이 요청 시점 `jsonLogic()` 평가) |

결론: **제약 전파가 아니다. 하드코딩 필터도 아니다. 사전 계산 테이블도 아니다.**
정확히는 ① 서버 = *solution checker*(완성 할당의 만족 여부 판정), ② 클라이언트 = *generate-and-test with backward checking*(한 변수의 후보를 하나씩 대입해 평가; `_sim_disallowed`가 그 서버측 쌍둥이). 전방 탐색(lookahead)은 **1변수 깊이가 상한**이고, 그마저 "규칙이 참조하는 나머지 변수가 전부 배정됐을 때만" 평가한다(governed — `price_views.py:2704-2705`, `widget_api.py:1381-1382`). 즉 **backward checking**이지 forward checking/arc consistency가 아니다.

추가로 결정적인 점: **가격 데이터의 존재 여부(단가행 유무)는 제약으로 모델링되어 있지 않다.** 그것은 계산을 끝낸 뒤 `data_gap`으로 사후 발견된다 (`widget_api.py:455-477`, `489-495`). CSP로 치면 **제약 그래프에 아예 들어 있지 않은 하드 제약**이다.

### (d) 막다른 길

**도달 가능하다.** 세 가지 경로가 실측된다.

1. **`price_gap` — 규칙상 합법인데 단가행이 없다.**
   `_price_gap_errors`가 붙은 이유가 실제 사고다: *"엔진은 매칭 실패 구성요소를 조용히 0원(included=False·data_gap 기록)으로 빼고 계산을 계속한다 … 고객 주문 경로에 그대로 두면 언더차지다(아크릴 머리끈 500원 사고, 260802: 자재 신·구 코드 이중화로 단가 미매칭)"* (`widget_api.py:458-460`).
   결과: `/price`가 `ok:false`, `code:"price_gap"`, 사람 문장 사유를 돌려준다 (`widget_api.py:1299-1303`, 문장 생성 `514`). 렌더러는 CTA 비활성 (`widget_api.py:1298`). `/handoff`는 422 (`1839-1841`).
   **이 제약은 `constraints` 메타에 없으므로 클라이언트 캐스케이드가 예고할 수 없다.**

2. **`tmpl_combo_gap` — 가격은 정상 표시되고 주문 단계에서 거절된다.**
   `/price`는 이 검사를 하지 않는다(설계상 — `widget_api.py:11-12`). `/handoff`에서만 `TC.resolve` 결과가 미매칭이면 422 (`widget_api.py:1894-1909`). 사용자는 **가격까지 다 보고 장바구니/주문을 눌러야 막힌다.** 메시지는 두 갈래로 분기된다 — 미선택 축이 있으면 "…옵션(X, Y)을 모두 선택해야" (`1898-1900`), 다 골랐는데 없으면 *"선택하신 조합(…)에 사용할 자재가 등록되지 않아 주문할 수 없습니다. 관리자에게 문의해 주세요."* (`1906-1907`). 후자가 **완전한 막다른 길이며, 시스템이 제시하는 탈출구는 "관리자 문의"뿐이다.**

3. **governed 스킵으로 인한 지연 폭로.**
   규칙은 참조 변수가 모두 배정될 때까지 평가되지 않는다 (`widget_api.py:1381-1382`). 즉 앞선 선택이 마지막 차원의 도메인을 0으로 만들어도 **그 시점에는 아무 신호가 없다.** 마지막 값을 고르는 순간 비로소 위반이 뜬다. 그리고 `_eval_violations`는 위반 메시지만 돌려주므로(`widget_api.py:1405`) **어느 앞선 선택을 되돌려야 하는지 시스템은 알려주지 않는다.** 관리자 경로의 `_sim_disallowed`는 "불가값 → 규칙 이름"까지 주지만(`price_views.py:2726-2729`) 이것도 원인 선택 지목이 아니라 규칙명이다.

셋트 상품에는 추가 공백이 있다: 구성원 스코프 제약이 **모델 자체로 미지원**이다 — *"구성원별 차원 제약 … 제약변수가 평면 차원이라 구성원 스코프 모델이 없어 미지원"* (`widget_api.py:1420-1423`, 동일 취지 `1780-1784`). 셋트 경로는 `proc_sels=None`이라 `proc_cd` 축 조합은 **항상 미매칭 → 항상 422**라고 코드가 스스로 적는다 (`widget_api.py:1890-1891`).

**막다른 길에서 일어나는 일 요약**: HTTP 422(또는 200+`ok:false`) + 한국어 사유 문자열. 복구 제안 없음, 자동 되돌리기 없음, 대안 조합 제시 없음, 부분 완화 없음.

### (e) 상태 보유 — 정확한 판정

**판정: 완전 무상태. 선택의 이력도, 의도도 서버에 보존되지 않는다.**

근거는 F8. 요약하면:

- **세션 없음**: `request.session` 미사용(0건). 식별자는 `site_key` + `wgt_cd`뿐이며 매 요청 DB 재조회 (`widget_api.py:202-227`).
- **누적 없음**: `/price` → `/validate` → `/handoff`가 서로의 결과를 참조하지 않는다. `/handoff`는 `/price`가 방금 계산한 것을 **처음부터 다시** 계산한다 (`widget_api.py:1831-1833` vs `1291-1293` — 같은 인자로 `evaluate_price` 재호출).
- **순서/시간 없음**: body에 담기는 것은 최종 값 집합뿐이다. "무엇을 먼저 골랐는가", "무엇을 골랐다가 취소했는가", "왜 이 조합인가"를 담는 필드가 요청 스키마에 없다.
- **유일한 순서 흔적**은 옵션 코드 배열의 나열 순서 보존이며(`widget_api.py:1085-1089`, `1127`), 이는 MES 표시용으로 명시 격리되어 있다(`widget_api.py:1080-1083`).
- **유일한 상태 객체**는 HMAC 서명 payload — 최종 스냅샷, TTL 1시간, 서버 미보관, 클라이언트 운반 (`widget_api.py:1915-1950`, `47`).
- 서버 영속 기록은 감사 로그 뿐이며 요약 절단된다 (`widget_api.py:1602`, `61-64`).

즉 **API는 "지금 이 조합이 유효한가"만 답할 수 있고, "사용자가 어디까지 왔고 어디로 갈 수 있는가"는 원리적으로 답할 수 없다.** 그 정보를 가진 유일한 주체는 브라우저 렌더러이며, 렌더러 상태는 새로고침 시 소실된다(서버에 복원 지점이 없으므로).

---

## 결함·공백

| # | 결함 | 근거 | 영향 |
|---|---|---|---|
| D3-1 | 캐스케이드 계산의 서버 권위 부재 — 규칙 원문을 클라에 내보내고 계산을 위임 | `widget_api.py:264`, `340`, `price_views.py:2739` | 화면·서버 판정 갈림이 상시 위험. 코드가 4곳 이상에서 "한 벌로 유지하라"고 경고 (`widget_api.py:1322`, `1338`, `545-546`, `707-708`, `757-761`) |
| D3-2 | 단가행 부재가 제약 모델 밖에 있음 | `widget_api.py:455-477`, `1299-1303` | 캐스케이드가 예고 불가한 막다른 길. 실제 언더차지 사고 이력 기록됨 (`widget_api.py:460`) |
| D3-3 | 조합 템플릿 공백을 가격 단계에서 의도적으로 미차단 | `widget_api.py:11-12`, `1894-1909` | 사용자가 가격까지 본 뒤 주문에서 거절. 탈출구 = "관리자 문의" (`1906-1907`) |
| D3-4 | governed 스킵으로 위반이 마지막 선택까지 은폐 | `widget_api.py:1381-1382`, `price_views.py:2704-2705` | 앞선 선택이 도메인을 0으로 만들어도 무경고 |
| D3-5 | 위반 시 복구 정보 없음 (원인 선택 미지목, 대안 미제시) | `widget_api.py:1405`, `1440` | 사용자가 스스로 조합 탐색해야 함 |
| D3-6 | 셋트 구성원 스코프 제약 모델 부재 | `widget_api.py:1420-1423`, `1780-1784` | 셋트 상품 제약 검증이 상품 레벨로만 동작 |
| D3-7 | 셋트 + `proc_cd` 조합 축은 구조상 항상 422 | `widget_api.py:1890-1891` | 코드가 "알려진 한계"로 자인 |
| D3-8 | 화이트리스트 밖 옵션/공정은 422가 아니라 **조용히 skip** | `widget_api.py:623-624`, `1092-1095` | 화면 선택이 주문서에서 소실되는 비대칭. 주석이 "화면엔 보이는데 주문서에선 조용히 사라지는" 문제를 알고 있음 |
| D3-9 | `_runtime_meta` 표시 화이트리스트가 좁으면 임베드에서 조용히 무동작 | `widget_api.py:277-279` (주석이 명시) | 빌더 미리보기와 임베드 동작 갈림 |
| D3-10 | 상태 부재로 인해 세션 복구·재개·중단지점 재현 불가 | F8 전체 | 오류 재현·CS 대응이 핸드오프 로그 요약(절단본)에만 의존 (`widget_api.py:61-64`) |

---

## 월드모델 관점 판정

네 축에 대해 증거 기반으로 판정한다.

### (1) 뉴로 — **전무**

`widget_api.py`·`widget_views.py`·인용된 `price_views.py` 범위 어디에도 학습 모델·임베딩·통계 추론이 없다. 모든 판정은 결정론적 조회·boolean 평가·산술이다. 유사도/랭킹/추천 코드 0건.

### (2) 심볼릭 — **존재하며, 이 영역의 사실상 전부**

- 형식 언어: JSONLogic (`price_views.py:2513-2535`, 평가기 `from json_logic import jsonLogic` `widget_api.py:1325`)
- 변수 공간: 5차원 + 5배열변수 (`price_views.py:2480-2486`, `widget_api.py:1380`)
- 규칙 유형 분류: 호환/금지/필수동반 (`price_views.py:2516-2517`), 유형별 다중선택 집계 로직 (`widget_api.py:1389-1398`)
- 추론기: **없음.** 만족성 검사기(checker)만 있다. 규칙 간 상호작용(전파·함의·모순검출)을 다루는 코드는 이 범위에 없다.

판정: **심볼릭 표현은 있으나 심볼릭 *추론*은 없다.** 표현층만 존재하는 상태.

### (3) 지식/온톨로지 — **빈약한 부분 존재**

- 통제 어휘: `OPT_REF_DIM.01~05` 코드로 차원을 식별 (`price_views.py:2481-2485`), `APPLY_POS.*` 적용위치 (`widget_api.py:631-636`), `RULE_TYPE.*`, `WGT_SRC_TYPE.*` (`widget_api.py:642`, `769-775`).
- 관계: 상품↔사이즈/자재/공정/판형/묶음수 연결, 공정 상하위(`upr_proc_cd` — `widget_api.py:527-528`), 셋트 완제품↔구성원(`widget_api.py:958-960`), 옵션→차원 polymorphic 참조(`ref_dim_cd` — `widget_api.py:1121`).
- **결정적 공백: 스코프가 없다.** 제약 변수 공간이 평면(flat)이라 "이 구성원의 자재"를 표현할 수 없다고 코드가 명시한다 — *"제약변수가 평면 차원이라 구성원 스코프 모델이 없어 미지원"* (`widget_api.py:1421-1422`). 온톨로지가 1레벨에 갇혀 있다.
- **두 번째 공백: 가격 가용성이 온톨로지에 없다.** 단가행 존재 여부는 개념으로 모델링돼 있지 않고 계산 부산물(`data_gap`)로만 드러난다 (`widget_api.py:462-463`).

판정: **얕은 코드값 온톨로지 + 1레벨 관계망. 스코프·가용성 개념 부재.**

### (4) 월드모델(행동 → 결과 예측) — **부재**

월드모델의 최소 요건을 "상태 s + 행동 a → 다음 상태 s′ 및 그 귀결을 예측"으로 두면:

- **상태 s가 없다.** 서버는 상태를 보유하지 않는다(F8, D3-10). 매 요청은 독립된 완성 할당의 검사다.
- **전이 함수가 없다.** "옵션 X를 선택하면 무엇이 불가능해지는가"를 계산하는 런타임 코드가 없다. 유일한 근사치인 `_sim_disallowed`는 (i) 관리자 경로 전용이고 (`price_views.py:2783-2792`), (ii) 1변수 깊이이며, (iii) 미배정 변수를 포함한 규칙은 아예 건너뛴다(`price_views.py:2704-2705`).
- **도달가능성(reachability) 개념이 없다.** "이 선택 이후 완주 가능한 조합이 1개 이상 남아 있는가"를 묻는 코드가 이 범위에 0건이다. 그래서 D3-2·D3-3·D3-4의 막다른 길이 구조적으로 남는다.
- **결과 예측기로 볼 만한 유일한 후보는 `evaluate_price`인데**, 이것은 (i) 전이가 아니라 완성 상태의 평가이고, (ii) 런타임 응답에서 진단 필드가 의도적으로 제거되어 **불투명 오라클**로 운용되며 (`widget_api.py:4-5` R2 응답 필터, `_filter_single` `1195-1220`), (iii) 매칭 실패를 조용히 0원으로 처리해 **모델로서 충실하지도 않다** (`widget_api.py:458-459`).

판정: **월드모델 부재.** 이 영역은 심볼릭 표현층(2) 위에 얕은 온톨로지(3)를 얹은 **무상태 검증기(stateless verifier)** 이며, 예측·시뮬레이션·계획 능력은 설계상 존재하지 않는다. 예측 기능이 필요한 자리는 클라이언트 렌더러에 위임되었고, 그 렌더러 역시 1변수 lookahead를 넘지 못한다(같은 규칙·같은 governed 조건을 미러하도록 강제되므로 — `widget_api.py:1322`, `1338`, `price_views.py:2739`).

**[추정]** 월드모델을 도입한다면 최소 진입점은 두 가지로 보인다 — ① 단가행·조합템플릿 가용성을 제약으로 승격해 단일 제약 그래프에 편입, ② 서버에 "현재 부분 할당" 상태를 두고 도달가능성 질의 엔드포인트를 신설. 다만 이는 본 진단 범위 밖의 설계 제안이며 코드 근거로 확인한 사실이 아니다.

---

## 미확인

- **렌더러(`widget_renderer.js`)를 읽지 않았다.** `ruleViolated()`, `selectedDtlKeys()`, `canOrder`, `dtlReasons`, `renderPriceBoxes`의 실제 구현은 미확인이며, 클라이언트 캐스케이드의 정확한 깊이(1변수인지 그 이상인지)는 서버측 주석의 "같은 규칙이어야 한다"는 요구로부터 **추론**했을 뿐 직접 확인하지 않았다. [추정]
- `pricing.evaluate_price`, `PV.simulate_set_core`, `PV._build_sim_meta` 본문 전체를 읽지 않았다 — 인용은 호출부와 docstring 수준이다.
- `tmpl_combo.resolve` / `TC.missing_axis_names` 내부 매칭 규칙 미확인 (호출부 `widget_api.py:1894-1904`만 확인).
- 라이브 DB에서 실제로 제약 규칙이 몇 건 등록돼 있는지, 어떤 상품이 `price_gap`/`tmpl_combo_gap`에 실제로 걸리는지 **실측하지 않았다**. 본 진단은 코드 구조 판정이며, 결함의 라이브 발생 빈도는 별도 실측이 필요하다.
- 코드 주석이 인용하는 사건·결정(아크릴 머리끈 500원 사고, 라이브 감사 260802, 사용자 결정 2026-08-06 등)은 **주석 기록을 사실로 전사**한 것이며 1차 원본으로 교차확인하지 않았다.
- `api_catalog` / `catalog_data` (`widget_api.py:2184-2209`) 본문 미확인 — 캐스케이드와 무관해 보였으나 검증하지 않았다.
