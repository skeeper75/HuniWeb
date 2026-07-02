# 후니 제약(Constraint) 레이어 — 개발자 전달안 (확정본)

> Huni-Constraint-Rules 하네스(§31) · **hcr-gate-validator(CR7) 근거 실재 검증 통과 후 확정 승격** · 2026-07-02
> 초안(`02_research/dev-handoff-draft.md`)의 부록 A 인용 파일:라인을 게이트가 **전건 직접 실재 확인** →
> 허위/불명 근거 항목 **0건** → 초안 항목 전부 승격 + wave-1/wave-2 실측 발견분(C-9·부록 B) 추가.
> 근거: 내부 실측(파일:라인) + 외부 CPQ 베스트프랙티스(`cpq-best-practices.md`). 시간 추정 없음 — 우선순위 라벨만.
> 파일 경로는 모두 `raw/webadmin/webadmin/catalog/` 기준. 쉬운 한국어(실무진도 읽는 문서).

---

## 0. 현재 제약 레이어가 어떻게 돌아가는가 (한눈에)

**관리자가 폼빌더로 규칙을 만들면 JSONLogic으로 저장되고, 그 규칙은 "미리보기 버튼"과 "SKU 저장 시 경고"에서만 평가된다. 정작 가격계산·주문에는 규칙이 전혀 반영되지 않는다.** (게이트 실측 재확인)

- **저장 위치** — `t_prd_product_constraints`(복합PK `prd_cd`+`rule_cd`·`rule_typ_cd`·`logic`(JSONB)·`err_msg`·`disp_seq`·`use_yn`·`del_yn`·`reg_dt` DEFAULT now()). 저장 로직 = `views.py:2525-2538`.
- **규칙 유형 3종** — `.01` 호환 / `.02` 금지 / `.03` 필수동반. 템플릿 = `views.py:120-130`.
- **평가(병합)** — 활성 규칙(`use_yn='Y'`·`del_yn='N'`)을 `{"and":[...]}`로 즉석 병합(`cfg_utils.py:23-53`) 후 panzi-json-logic 평가(`cfg_utils.py:61-72`). ★게이트 실측: 병합 AND라 자재별 단일 implication 규칙들을 함께 넣어도 논리 무손상(각 규칙 antecedent 거짓이면 통과).
- **손님 선택 → 데이터 계약(var 키)** — `VAR_KEY_MAP`(`views.py:52-60`): `siz_cd`·`plt_siz_cd`·`mat_cd__usage_cd`(자재 결합키)·`proc_cd`·`bdl_qty`·`opt_id`·`sub_prd_cd`, 옵션은 `sel_opt_grps`/`sel_opts` 배열(`views.py:67-70`).
- **폼빌더 3경로** — ① 복수조건 빌더(`conditions_json`) ② 고급 직접 JSONLogic(`raw_logic`) ③ 하위호환 단일조건(`views.py:2454-2493`).
- **강제(적용) 지점 2곳뿐** — ⓐ SKU 저장 콜백(`views.py:3058-3080`, 경고만·차단 안 함) ⓑ 검증 미리보기 Ajax(`views.py:2798-2846`, 관리자가 버튼 눌러야 함).

---

## 1. 잘된 점 (유지·계승할 것)

- **JSONLogic 표준 채택**(`views.py:120-130`·`cfg_utils.py:67`) — 클라/서버 공용 평가 기반. 폼빌더 JS에 동일 `VAR_KEY_MAP` 미러(`constraint_builder.html:597`).
- **폼빌더 3경로**(no-code 빌더 + 고급 직접입력) — 업계 베스트프랙티스 정합(`cpq-best-practices.md §3-A`).
- **복수조건 빌더(AND/OR 그룹)** — `views.py:133-193`. "조건 가지" 패턴 정합(§3-B).
- **검증 미리보기(/validate/ Ajax)** — `views.py:2798-2846`, `blocked_rule` 반환. "영향 미리보기"의 씨앗(§5-B).
- **복합PK + 논리삭제** — `del_yn='Y'`(`cfg_utils.py:80-98`). 물리삭제 안 함(이력 보존).
- **자동 채번** — `rule_cd`(RULE_NNN)·`disp_seq` max+1(`views.py:2496-2523`).
- **역파싱 시도 + 정직한 폴백** — 실패 시 "빌더로 역변환 불가 → 고급 JSON 창에서 수정하세요"(`constraint_builder.html:265-269`).

---

## 2. 개선 · 보완 · 강화 · 수정 (현상 → 근거 → 제안 → 우선순위)

### C-1. 가격계산·시뮬레이터가 제약을 전혀 안 본다 — **High**
- 현상: 손님이 금지 조합을 골라도 가격이 그대로 계산되어 규칙이 무력.
- 근거: `pricing.py`·`price_views.py` constraint 참조 **grep 0건**(게이트 재확인). `evaluate_price`/`simulate` 어디서도 `evaluate_constraints` 미호출.
- 제안: 가격계산 진입점(또는 시뮬 응답)에서 `evaluate_constraints(prd_cd, data)` 호출 → 위반 조합이면 가격+`blocked_rule` 플래그 동반. 강제 최종 권위는 주문(§4), 여기선 신호.

### C-2. 진짜 강제 지점이 없다 (경고뿐) — **High**
- 현상: 규칙 어겨도 저장·진행이 안 막힘.
- 근거: `views.py:3058-3062` "위반 시 warn=1 + 세션 메시지 ... 저장 결과 불변". 위젯/카트/주문 경로에 validate 호출 자체 없음.
- 제안: §6(위젯)·§24(주문)에 validate 강제 배치(§4 로드맵). 관리자 SKU 저장은 경고 유지, 손님 주문은 차단.

### C-3. 깨진 규칙 처리가 두 경로에서 다르다 (하나는 500, 하나는 조용히 통과) — **High**
- 근거: `cfg_utils.py:61-72` `evaluate_constraints`는 `jsonLogic`을 try 없이 호출 → 예외 시 **500**. 반면 `validate_preview`는 `except Exception: result = True`(`views.py:2836-2837`) → 깨진 규칙을 조용히 통과(금지 규칙이 깨지면 위험).
- 제안: 정책 통일. 예외 은폐 금지, (a) 로그+알림 (b) 규칙유형별 안전 기본값(금지 규칙 평가불능=통과 아닌 보류/차단). `evaluate_constraints`에도 방어 로직 추가하되 구조화된 결과 반환.

### C-4. logic 안의 코드가 실재하는지 검증하지 않는다 (규칙 부패) — **Med**
- 근거: 저장 경로(`views.py:2495-2538`) logic을 JSONB 그대로 저장. FK/실재성 검증 없음. `raw_logic`은 아무 값이나 통과.
- ★게이트 실증(058): `siz_cd===SIZ_000426`인데 상품 미제공 → **죽은 규칙**(라이브 확인). 이런 부패를 저장 시 못 잡음.
- 제안: 저장 시 logic 순회해 var 키·값이 현재 상품 차원행/옵션에 실재하는지 검사(없으면 경고). + "부패 규칙 스캐너" 배치.

### C-5. 수동 규칙 드리프트 — 신규 자재/사이즈 추가 시 규칙이 안 따라온다 — **Med**
- 근거: 규칙 전부 수동 입력(폼빌더 3경로). 데이터 유도 경로 없음.
- ★게이트 실증(129/130): 단가행(component_prices)에서 자재별 유효 사이즈를 **자동 유도**해 규칙 생성 가능(`derive_matsiz.py` 실증). 단가행 격자가 곧 "실재 조합" 원천(`cpq-best-practices.md §7`).
- 제안: 단가행 격자에서 호환 규칙 자동 유도(또는 "단가행 없는데 규칙도 없음" 제안) 보조 도구. 규칙기반→데이터기반 전환 발판.

### C-6. 규칙 충돌·중복·죽은 규칙을 감지하지 않는다 — **Med**
- 근거: 저장 경로에 규칙 간 관계 분석 없음(`views.py:2495-2538` 단일 규칙만). 목록도 나열만.
- 제안: 배치로 ① 모순 ② 중복(동일 logic) ③ 죽은 규칙(실재 조합으로 절대 발동 안 됨) 스캔 → 관리자 배지 경고(`cpq-best-practices.md §4-B`).

### C-7. 감사추적·규칙 소유권 없음 — **Low**
- 근거: `t_prd_product_constraints`에 변경자·사유·이전값 컬럼 없음. `update_or_create`로 덮어씀(`views.py:2526`).
- 제안: 규칙 변경 이력 테이블(또는 감사 컬럼 `upd_by`·`chg_rsn`·이전 logic 스냅샷).

### C-8. impact(사용처) 뷰가 제약 규칙을 차원행 단위로 못 본다 — **Low**
- 근거: `v_cfg_ref_impact` CONSTRAINT 레그 `ref_dim_cd=NULL`(`views.py:2683,2758-2776`) → 차원행 단위 매칭 불가. 상품 단위 총계만.
- 제안: 규칙 logic 파싱해 참조 차원행 추출·인덱싱 → 차원행 삭제 경고에 "이 값 쓰는 규칙 N건" 표시. C-4와 파싱 인프라 공유.

### ★ C-9. 폼빌더에 수치 범위 조건 타입이 없다 (자유치수 범위규칙 UI-관리 불가) — **High** [wave-2 실측 신설]
- **현상**: 아트페이퍼포스터·현수막·아크릴키링 등 **자유치수(nonspec) 상품 19건**의 가로/세로 범위(min~max) 제약을 폼빌더로 만들 수 없다. 억지로 만들면 "고급(raw) JSON 창"으로만 열려 관리 불가.
- **근거(게이트 실측)**:
  - `VAR_KEY_MAP`(`views.py:52-60`)에 `width`·`height`·`size_mode` **없음** → 역파싱 시 `_REVERSE_VAR_KEY.get("width")=""` → 빌더 복원 실패.
  - `_dim_clause`(`views.py:106-114`)·`_is_leaf`(`views.py:239-241`)가 만들고 인식하는 연산자는 `===`/`in` **뿐** — `>=`·`<=`·`<`·`>` 경로 없음.
  - 기존 committed 범위규칙(118 등 7건)은 `{"or":[{"!=":[size_mode,nonspec]},{"and":[{">=":[width,200]},{"<=":[width,1200]},...]}]}` = **전부 RAW-ONLY**(라이브 실증). 런타임(panzi)은 동작하나 폼빌더로는 못 엶.
- **영향 목록**: 신규 필요 19건(119·123·126·127·128·138·146·147·148·149·150·151·152·153·154·155·156·164·171) + 기존 raw-only 7건(118·120·121·122·124·125·139).
- **제안(택1 또는 병행)**:
  1. **(최단) §6 위젯이 컬럼으로 직접 강제** — 각 상품 `nonspec_width/height_min/max/incr` 컬럼이 이미 존재(라이브 확인). 위젯이 입력 min/max/step으로 막으면 제약규칙 불요. 규칙 없이 UI가 컬럼으로 막는 가장 단순한 정답.
  2. **폼빌더 수치범위 조건 타입 추가** — 연산자 `>=`/`<=`, var `width`/`height`/`size_mode`를 `VAR_KEY_MAP`·`_dim_clause`·`_is_leaf`·역파서에 확장. 추가되면 19건+기존 7건 모두 UI-관리 가능.
- 우선순위 **High**(off-grid 0원/과금 위험 직결). 단, 규칙 신설이 아니라 **플랫폼 확장 또는 위젯 컬럼강제**로 해소(죽은/raw-only 규칙 mint 금지).

### ★ C-10. 폼빌더 "결과절 리스트" implication을 못 담는다 (X→Y∈[리스트]는 RAW-ONLY) — **Med** [wave-3 실측 신설]
- **현상**: "코팅 선택 → 종이 ∈ [180g 이상 32종]" 같은 **필수동반(.03)/호환(.01) implication의 결과절이 여러 값(리스트)** 이면 폼빌더로 관리할 수 없다(고급 raw JSON 창으로만 열림).
- **근거(게이트 실측)**: 역파서(`views.py:200-315`)와 빌더의 **result 필드는 단일 `{dim, val}`** 만 담는다(`views.py:225-234`·`views.py:309-312`). 결과절이 `{"or":[32절]}` 이면 `res_part.get("===")`·`.get("in")` 모두 None → `result_dim=""` → 빌더 복원 실패(**RAW-ONLY 재현 확인**).
- **해소(설계 패턴)**: 이런 "한쪽이 리스트"인 조건부는 **여집합을 .02(금지)로 뒤집어** `NOT( (선택) AND (금지 리스트) )` 로 모델링하면 폼빌더 복수조건 v2(그룹 or×2, groupOps=and)로 **PARSEABLE + 오차단 안전**(적극 선택 시에만 발동). wave-3 047(`R_EXCL_COATING_THIN_PAPER`)이 이 패턴의 전형 — .03 대신 .02, 허용 32종 대신 금지 15종 열거.
- **동형 적용 대상**: 048·049 접지리플렛(코팅×종이두께 동일 규칙·현재 옵션그룹 0건 BLOCKED-UI) — §7 옵션그룹 선적재 후 `derive_coating_paper.py`의 PRD/그룹 파라미터만 바꿔 동형 생성.
- **플랫폼 개선(선택)**: 빌더 result에 다중값(리스트) 결과절 타입을 추가하면 .03 implication을 직관적으로 관리 가능(단, .02 여집합 모델이 오차단 안전성에서 우위라 필수는 아님).

---

## 3. 시각화 보완 · 강화

- **V-1. 호환성 매트릭스 히트맵 — High**: 상품별 "자재×사이즈" 격자를 초록(허용)/빨강(금지)/회색(규칙없음)으로. 데이터=규칙 logic + 차원행(§29 대시보드 스냅샷 재사용). ★129/130이 이 히트맵의 전형(대각 4셀 허용/오프대각 4셀 차단).
- **V-2. 자연어 규칙 요약 렌더 — Med**: JSONLogic→문장("A4+50매 함께 선택 불가"). `RULE_TYPE_TEMPLATES`(`views.py:120-130`) 정형이라 역방향 문장 생성 용이(raw_logic만 예외).
- **V-3. 영향 미리보기("이 규칙이 막는 조합 N개") — Med**: 저장 전 차원행 전조합에 validate 배치. ★게이트가 이미 이 방식으로 129/130 = "막는 8셀/허용 8셀" 계산(구현 참조).
- **V-4. §29 대시보드 Cytoscape 연계 — Med**: 상품 노드에 규칙 배지·충돌 경고, 참조 차원행 간선으로 부패(끊긴 간선) 시각화.

---

## 4. 강제(validate) 지점 로드맵

**원칙** — 클라(위젯)=UX 즉시 피드백, **서버=최종 권위**. 주문 확정 직전 서버 재검증(`cpq-best-practices.md §6-B`). 흐름 = 담기→구성→가격→검증→결제.

- **R-1. 위젯 실시간 필터링/경고(§6) — High**: 위젯이 서버/클라 공용 JSONLogic 사용(`constraint_builder.html:597`). 손님 선택을 `siz_cd`·`mat_cd__usage_cd`·`sel_opts` 등 var 키로 실어야 평가됨(어댑터 변환 필요). 성격=UX 유도(강제 아님).
- **R-2. 카트 담기 시 서버 검증(§24) — High**: 담는 순간 `evaluate_constraints`/validate 호출 → 위젯 우회 조합도 차단.
- **R-3. 주문 확정 직전 최종 재검증(§24) — High**: 결제 직전 하드 차단. 진짜 강제의 최종 게이트.
- **R-4. 가격계산 응답에 제약 신호 동반(C-1 연계) — Med**: 견적/시뮬 응답에 위반+`blocked_rule` 동반(신호, 강제는 R-2/R-3).
- **R-5. 관리자 SKU 저장 경고 유지 — Low(현행 유지)**: `views.py:3058-3080` 경고만 유지. 단 C-3 적용 대상.

---

## 부록 A. 근거 파일:라인 인덱스 (게이트 CR7 실재 확인 완료 ✓)

| 항목 | 파일:라인 | 실재 |
|---|---|---|
| 규칙 병합(compile) | `cfg_utils.py:23-53` | ✓ |
| 규칙 평가(try 없음→500) | `cfg_utils.py:61-72` | ✓ |
| 논리삭제 헬퍼 | `cfg_utils.py:80-98` | ✓ |
| VAR_KEY_MAP(var 계약·width/height 없음) | `views.py:52-60` | ✓ |
| 자재 결합키 mat_cd__usage_cd | `views.py:88-94` | ✓ |
| 옵션 합성차원 sel_opt_grps/sel_opts | `views.py:67-70` | ✓ |
| RULE_TYPE 템플릿(.01/.02/.03) | `views.py:120-130` | ✓ |
| 복수조건 → JSONLogic 변환 | `views.py:133-193` | ✓ |
| JSONLogic → 빌더 역파싱 | `views.py:200-315` | ✓ |
| dim_choices Ajax | `views.py:2307-2378` | ✓ |
| 저장 3경로(raw/conditions/legacy) | `views.py:2454-2493` | ✓ |
| 규칙 저장(update_or_create) | `views.py:2525-2538` | ✓ |
| 자동채번(rule_cd/disp_seq) | `views.py:2496-2523` | ✓ |
| impact CONSTRAINT ref_dim_cd=NULL 한계 | `views.py:2683, 2758-2776` | ✓ |
| validate_preview(깨진규칙→통과) | `views.py:2798-2846` | ✓ |
| SKU 저장 콜백(경고만·차단 안 함) | `views.py:3058-3080` | ✓ |
| 폼빌더 UI · 클라 VAR_KEY_MAP 미러 | `constraint_builder.html`(861행)·`:597`·`:265-269` | ✓ |
| pricing/price_views 제약 참조 0건 | `pricing.py`·`price_views.py` grep 0 | ✓ |

## 부록 B. wave-1 파일럿 등록 예정분 (게이트 GO · 인간 승인 대기)

- **129 폼보드·130 포맥스보드 CN-2 자재↔사이즈 제약 8규칙**(`R_MATSIZ_*`, RULE_TYPE.03) — 단가행 자동유도·전건 폼빌더 역파싱 가능·오차단 0(게이트 CR2 PASS). 구 `R_DEMO_MATSIZ`(129/130 각 1건)는 논리삭제 대체.
- 적재본: `03_rules/wave1-pilot/apply-fix.sql`(멱등 UPSERT·ON CONFLICT prd_cd,rule_cd). undo=`undo.sql`(대칭).
- **주의**: 이 규칙들은 위젯/주문이 `/validate/`를 호출할 때만 실효(C-1·C-2·R-1~R-3 미구현 시 0원 오노출은 그대로). 등록=선택 차단 계약 확보, 강제 계층은 별도 개발.
- **CONFIRM-QUEUE**: 058 RULE_001(type/shape 불일치+죽은 규칙+err 공백) — 실무진/curator 컨펌 후 정형 수정 또는 논리삭제.
- **[wave-3 추가]** 047 소량전단지 CN-3 코팅×종이두께 1규칙(`R_EXCL_COATING_THIN_PAPER`, RULE_TYPE.02·차단 종이 15종) — 라이브 자동유도·전건 폼빌더 역파싱 가능·전수 188조합 오차단 0(게이트 CR2 PASS·GO). 적재본 `03_rules/wave3-dgp/apply-fix.sql`(멱등 UPSERT). C-10 패턴(implication 결과절 리스트→.02 여집합) 참조.
