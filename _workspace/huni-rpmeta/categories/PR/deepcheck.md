# PR 카테고리 codex 심층보강 (deepcheck) — second-opinion triage

> 후니 RP-Meta 하네스 Phase 4.5 (rpm-deepcheck). PR 분석(reverse+metamodel 16축+gap)을 codex-cli(OpenAI gpt-5.5)에 컨텍스트로 주고 **우리가 놓친 옵션/자재/공정/관리축/제약/엣지케이스/도메인 정보**를 독립 second-opinion으로 발굴 → triage.
> **★환각 경계 [HARD]:** codex(OpenAI)는 네트워크 격리 read-only 샌드박스에서 제 print-domain 지식만으로 답한 것 — 라이브/엑셀/RP 캡처 권위로 검증되기 전 전부 `unverified` 가설. codex는 RedPrinting 실데이터를 본 적 없으므로 그 주장은 "일반 인쇄업계 표현" 이지 "RP가 실제로 노출하는 옵션"이 아니다. 채택은 verify 후 — 본 산출은 후보 등재까지만(채택 0).
> **★PR 검증 렌즈(TP 세션 교훈):** PR 메타모델의 saturation 주장 = "**RedPrinting PR 56상품이 16축 외 새 관리축을 도입하지 않는다**". codex가 드는 NEW-AXIS-CANDIDATE 다수는 *일반 상업인쇄가 가능한 것*이지 *RP가 노출하는 것*이 아닐 수 있다 → "RP 캡처에 그 축이 보이는가"가 1차 검증, "후니가 그 축을 담는가"가 2차(gap). RP 미노출 = saturation 주장 무해(out-of-scope), 후니 미보유 = forward-looking vessel 후보.

## codex 호출 메타
- preflight: `AVAILABLE model=gpt-5.5` (gpt-5-codex/gpt-5는 ChatGPT 계정 400 미지원).
- 호출: `codex exec -m gpt-5.5 --sandbox read-only --output-last-message ... - < prompt`(stdin pipe·read-only·side-effect 0). **주의: 프롬프트를 `$(cat)` arg로 주면 codex가 stdin 대기와 충돌해 행(hang) — stdin pipe(`- <`)가 안전.** EXIT=0·출력 10,485 bytes.
- 프롬프트: PR 분석 요약(reverse 3대표+그룹·16축·P-1~P-9 facet 판정·saturation 주장) + 적대적 5문항(17축 hunt / 누락 옵션 / 누락 자재공정 / 모델 깨는 엣지케이스 / 도메인 규칙).

## codex 후보 수 + HIGH 요약 (완료 보고)
- **codex 제시 후보 = 20건**(NEW-AXIS-CANDIDATE 5·MISSING-OPTION/PROCESS 9·DOMAIN-RULE 6, 중복 분류 포함) + 도메인 규칙 10항.
- **17축 후보 있었는가: 예 — codex가 강하게 제기.** 최강 후보 = **① 제조구조/대수(signature/section) 축**(40pp=16+16+8 서명 그룹화·collation 순서·혼합 섹션), 2순위 = **② 생산 워크플로/SLA 축**(교정·승인·rush 납기 게이팅), 3순위 = **③ 임포지션/작업판형 축**(trim≠work≠press-sheet≠plate·grain·gripper).
- **기각 예상: HIGH 3건 중 17축 후보(C-1 대수/C-3 임포지션)는 "RP PR 미노출 + 후니 앱/MES 영역" 으로 기각 예상**(메타모델 saturation 주장에 무해 — RP 스토어프론트가 노출하지 않는 *생산 내부 구조*). 단 **C-2 per-section/per-range 자재(섹션별 다른 내지)는 모델을 진짜로 깰 수 있는 엣지케이스**라 검증 가치 HIGH(우리 cover/inner=2 고정슬롯 모델이 N-섹션을 못 담음). **C-4 교정/승인 워크플로**는 주문축이 아닌 *주문런타임/MES* 영역이나 RP가 옵션으로 노출하면 #9/#16 facet 여부 확인 필요(MED-HIGH).

---

## Triage 분류 기준
- **(a) 신규 후보** → `unverified` + 라우팅(새 축→metamodel-architect / 새 갭→gap-analyst / 미발굴 옵션→reverse-engineer / 그릇 함의→vessel-designer). 검증방법 명시.
- **(b) 이미 커버** → 폐기 + 한 줄 근거(재발굴 방지).
- **(c) 오류/부적용** → 거부 + 사유.

---

## HIGH 우선순위 후보 (검증 가치 큼)

### H-1 [C-2] Per-section / per-range 자재 (섹션별 다른 내지 stock) — **신규 후보(EDGE-CASE) → REFUTED-for-RP (2026-06-17 캡처 실측·종결)**
- **codex 주장:** 우리 모델은 `cover material vs inner material` 2 고정슬롯뿐 — "1-16p=100g 아트지, 17-32p=120g 무광, 중앙 스프레드=foldout stock, 삽입 쿠폰=컬러지" 같은 **임의 섹션별/페이지범위별 자재**를 못 담는다. 무거운 8p 이미지 섹션을 텍스트지 본문에 製本하는 카탈로그가 break example.
- **우리 분석 대조:** reverse §0.1·P-2는 표지/내지를 `pdt_mtrl_info` vs `inner_pdt_mtrl_info` **2 평행 슬롯**으로만 관측. usage_cd 7종(.01내지/.02표지/.03면지/.04간지/.05투명커버/.06표지타입/.07공통)은 *역할 슬롯*이지 *동일 역할 내 N개 섹션*이 아님. P-2 판정은 "usage_cd 슬롯 facet"으로 닫았으나 **N-섹션(같은 내지 역할에 stock 2종+)은 명시적으로 미검토** — codex가 정당한 사각을 찔렀다.
- **왜 HIGH:** 이게 RP에 실재하면 usage_cd 2슬롯 모델이 깨지고 "섹션(section) 엔티티 + 섹션별 자재/페이지범위" 가 필요 → **17축(섹션/제조구조) 후보로 격상될 수 있음**. P-2 facet 판정의 robustness 직접 시험.
- **그러나 검증 필요(in-scope 여부):** RedPrinting PR 책자가 *주문 시점에 섹션별 다른 내지를 고객이 선택*하게 하는가? 우리 캡처(PRBKYPR)는 `inner_pdt_mtrl_info` 단일 풀(내지 자재 택1)만 — **섹션 분할 UI 미관측**. 일반 출판인쇄는 가능하나 RP 스토어프론트는 통상 단일 내지지.
- `unverified`. **라우팅: gap-analyst(P-2 robustness 재검) + reverse-engineer(RP 책자 섹션 옵션 실재 확인).**
- **검증방법:** ① 로그인 캡처로 PRBKYPR/PRBKPSN(독립출판) productInfo에 섹션/페이지범위별 자재 슬롯(예: `section_mtrl_info`·범위 입력) 존재 여부 ② RP 라이브에서 책자 주문 시 "본문 용지 구간 분리" UI 유무 ③ 부재 시 → saturation 주장 무해(RP 미노출·forward-looking 후니 vessel 후보로만 noting), 존재 시 → P-2 facet 판정 정정 + 섹션 축 검토.

#### ★검증 결과 (2026-06-17 캡처 실측·라이브 대조) — **REFUTED-for-RP (생산내부 경계)**
- **실측 출처:** `_workspace/huni-widget/01_reverse/captures/product_PRBKYPR.json`(풀 productInfo) + 라이브 GET `/ko/product/item/PR/PRBKYPR`(2026-06-17·HTTP 200·313KB).
- **`inner_pdt_mtrl_info` 구조 실측:** **단일 슬롯의 평면 배열 4행**(택1 stock 후보) — `RXYWM080 윤전전용백색모조80g · RXYWM100 100g · RXPLW080 에스플러스백색80g · RXPLW100 100g`. **섹션/슬롯/순번 키 0건**(SEC/SLOT/SEQ/DIV/IDX/PART/CHAP/GBN 어느 것도 inner 항목에 부재). 즉 "내지 자재 = 책 전체 1종 택1"이며 codex가 주장한 "1-16p=A, 17-32p=B" 같은 **페이지범위별 N-stock 슬롯 구조 미존재**.
- **내지 역할 단일성 교차확인:** `inner_pdt_dosu_info`=[SID_D 양면] 1행 · `inner_pdt_bnc_info`=[BNC_COL 컬러] 1행 · `inner_pdt_dosu_bnc_info`=1행(NOTE "책자 내지 인쇄색도"). 내지 도수/색도도 **책 전체 단일** — 섹션별 분기 없음.
- **다면(페이지) 표현:** `quantityGroup.title.printCnt="내지장수"` + `pdt_prn_cnt_info` `MIN_INN_PAGE=10·MAX_INN_PAGE=300·STEP_INN_PAGE=1`. 페이지는 **스칼라 총 내지장수**로만 입력 — "섹션/구간(section/range)" 분할 입력 0건.
- **라이브 PRBKYPR 대조:** 신규 Vue client-render(옵션 SSR 미노출). 섹션/구간별/혼합용지/내지추가 UI 마크업 신호 0건("간지" 텍스트 2회뿐 — 간지=END_PAP 면지로 reverse §2에 이미 별 옵션으로 관측·섹션 아님). 로그인 productInfo 추가 캡처는 토큰 만료로 미확보이나, **비로그인 풀 productInfo 스키마 자체에 섹션 슬롯 필드가 정의돼 있지 않음**이 1차 권위.
- **판정 근거:** RP 책자는 내지를 **단일 역할·단일 stock 택1·스칼라 페이지수**로 노출 → "동일 내지 역할 내 N-섹션 다른 stock"은 **RP 스토어프론트 고객 옵션으로 미노출**. 임의 페이지범위 혼합지(8p 이미지 섹션을 텍스트 본문에 제본)는 RP에선 별도 협의/내부 임포지션 영역(생산내부 경계)이며 주문옵션 base-data 관리축이 아님.
- **결론: H-1 = REFUTED-for-RP.** P-2 판정(`pdt_mtrl_info` 표지 vs `inner_pdt_mtrl_info` 내지 = usage_cd 역할 2슬롯)은 **정정 불필요·robust 입증**. "섹션 엔티티(17축 후보)"는 RP 근거 0 → **채택 0**. 단 forward-looking 후니 vessel 후보로만 noting(고급 출판인쇄가 섹션별 혼합지를 미래 지원할 경우 "본문 섹션 + 섹션별 자재/페이지범위" 엔티티가 필요할 수 있으나, 이는 RP 흡수 대상이 아닌 후니 자체 확장 결정 — metamodel-architect 재진입 **불요**, 채택 0).
- **교훈:** codex "무거운 카탈로그 섹션" break example은 도메인상 타당한 일반 출판 시나리오이나 **RP 데이터 미존재**(TP H-1 STATE·H-2 서명 기각과 동형 — 도메인 가능성 ≠ RP 노출 옵션). 환각 경계 준수: 실측 스키마에 필드 부재 → unverified→REFUTED 확정.

### H-2 [C-1] 제조구조 / 대수(signature/section) 축 — **17축 후보(NEW-AXIS-CANDIDATE)** ★codex 최강 주장 / 기각 예상
- **codex 주장:** 책자를 `cover + 16pp 서명 + 8pp 서명 + insert + gatefold` 다중 섹션/서명으로 모델해야 — page count(우리 #10/page_rule)는 서명 그룹화·collation 순서·혼합 섹션·제본 호환을 표현 못함. 새벽서명 page count는 saddle=4배수·offset 임포지션=8/16/32pp 서명. `Body-form-assembly`(#14)는 굿즈 조립이지 인쇄 서명조립이 아니다.
- **우리 분석 대조:** 정확 — #14는 GS 평면→입체 본체생성(봉제/지퍼)이라 인쇄 서명과 무관. #10 page_rule은 min/max/incr만(서명 구조 아님). **우리 16축에 "인쇄 제조구조(서명/대수/collation)" 그릇은 명시적으로 없음.**
- **왜 기각 예상(검증 후):** ① **대수(임포지션 서명 계산)은 후니 도메인 권위가 이미 "앱 계산·DB 미저장"으로 확정**(메모리 `dbmap-compute-in-app-db-stores-lookup`·`dbmap-column-domain-loadspec-round11` "판수=앱 임포지션 계산 C6 DB 미저장"). 즉 서명 그룹화는 *주문옵션 관리축*이 아니라 *생산 런타임 계산* → 메타모델(base-data 관리 그릇) 범위 밖(TP H-1 STATE=주문런타임 out-of-scope 기각과 동형). ② RP PR 스토어프론트가 고객에게 "이 책을 16+16+8로 나눠라"를 노출하지 않음(서명은 인쇄소 내부 임포지션) — saturation은 *RP 노출 옵션* 기준이므로 무해. ③ collation 순서(면지·tip-in·tab 끼우는 순서)는 실재하면 #14를 "조립 순서(assembly sequence)" 로 일반화하거나 별 엔티티지만, RP PR 미노출.
- `unverified`. **라우팅: metamodel-architect(서명/대수가 base-data 관리축인가 vs 앱계산인가 판정·#14 일반화 가능성) — 단 기각 예상 명시.**
- **검증방법:** ① 후니 `dbmap` 권위 재확인: 대수/임포지션이 t_*에 저장 컬럼이 있는가(메모리상 "앱 계산·미저장") → 미저장 확인 시 메타모델 범위 밖 기각 ② RP 책자 주문 UI에 서명/섹션 입력 노출 여부(H-1과 같은 캡처) ③ collation 순서가 RP 옵션이면(면지 위치·tip-in) → #14 assembly-sequence facet 검토.

### H-3 [C-4] 교정/승인 워크플로(proofing/approval) 옵션 — **신규 후보(MISSING-OPTION, 조건부 NEW-AXIS)** / MED-HIGH 기각 예상
- **codex 주장:** 상업인쇄는 교정을 주문옵션으로 노출(무교정/PDF교정/실물교정/색교정/인쇄입회·승인 후 생산). 교정은 단순 addon이 아니라 **생산 상태·일정·재작업·책임·색기대치를 게이팅** → 진짜 축일 수 있음. `PDF proof`/`contract proof`/`sample print`/`press check`/`approval deadline`.
- **우리 분석 대조:** 우리 16축에 교정/승인 그릇 없음. **단 이건 huni-widget(주문 런타임)·MES 영역**(메모리 `dbmap-goal-ui-quote-mes` "주문→MES 생산정보"·`huni-project-plan` "주문 런타임 0개·MES 브릿지"). 메타모델은 *기초데이터 관리 그릇*(자재/공정/옵션 등록)이지 *주문 워크플로/상태기계*가 아님.
- **왜 MED-HIGH:** ① 교정이 *주문옵션*(가격 동반·옵션 택1)으로 RP에 노출되면 → 우리 #3 옵션 또는 #9 공정파라미터 facet일 수 있음(검증). ② 교정이 *주문상태/승인 게이트*면 → 메타모델 범위 밖(주문런타임·TP H-1 STATE 동형 기각). 둘을 가르는 건 "RP가 교정을 가격 있는 select로 노출하는가". RP PR 캡처(PRPOXXX/PRBKYPR)에 교정 옵션 미관측이나 전수 아님.
- `unverified`. **라우팅: reverse-engineer(RP PR 주문 UI에 교정/승인 옵션 실재·가격 여부 확인) → 있으면 gap-analyst(옵션#3 facet vs 주문런타임 경계 판정).**
- **검증방법:** ① RP 라이브 책자/포스터 주문 플로우에 "교정 방식" select + 가격 노출 여부 ② 노출 시 priceCall reqBody에 교정 코드가 PCS/옵션으로 들어가는가(=옵션#3 facet) vs 주문 후 상태(=런타임 밖) ③ 후니 t_*에 교정 옵션 그릇 유무(gap).

---

## MED 우선순위 후보 (기존 축 facet·검증 시 명확화)

### M-1 [C-3] 임포지션/작업판형/press-sheet 구조 — **FACET-OF-EXISTING(#13 Size) 가능·일부 앱계산**
- **codex:** trim≠bleed≠work≠press-sheet≠imposed≠plate·grain·gripper margin은 고객 Size로 환원 불가. A5 책자가 press sheet 따라 4-up/8-up/16-up.
- **대조:** #13이 이미 `cut!=plate` 구분 보유. **임포지션 단위(N-up)·press-sheet는 후니 권위상 앱계산**(`dbmap-platesize-is-output-paper`·판수=앱). 우리 #13은 출력판형(plate)까지 담음 — 임포지션 *계산*은 범위 밖.
- **(b) 대체로 커버** + 일부 앱계산(범위 밖). `unverified` 잔여 = grain↔fold 의존(M-5). **라우팅: gap-analyst(plate vs work-size 그릇 충분성 확인) — 기각 경향.**

### M-2 [C-11/C-18] 넘버링(순차데이터)·foil 파라미터 — **FACET-OF-EXISTING(#16 VDP / #9 공정파라미터)**
- **codex:** 넘버링(시작번호/자릿수/prefix/바코드/위치)·foil(색·홀로/메탈·die area·side·registration·min line width)은 단일 yes/no 아님.
- **대조:** TP T-B에서 넘버링=VDP(#16)/공정#2 분배 이미 판정(`_resolved-fragments.md` T-3). foil(박)=공정#2 멤버·박색=공정 파라미터(#9)로 PR P-9·TP T-E 이미 등재. **codex가 "파라미터 깊이(색·registration·min-line)"를 더 정밀화 요구** — #9 공정파라미터 value_domain 풍부화 후보.
- **(b) 축은 커버**(#9/#16) + 파라미터 상세는 검증분. `unverified`. **라우팅: gap-analyst(#9 GAP에 넘버링/박 파라미터 스키마 포함 확인·이미 GAP).**

### M-3 [C-12] 천공/타공 패턴(perforation) — **FACET-OF-EXISTING(#9 공정파라미터)**
- **codex:** 천공=yes/no 아님·line count/orientation/edge 위치/tear-off stub 폭/다중 평행선/microperf. 쿠폰 2-voucher.
- **대조:** 포스터 미싱(MIS_DFT)=공정#2 + 줄수=#9 공정파라미터 이미 등재(reverse §3·P-1 오시 줄수 동형). **천공 패턴 깊이가 #9 value_domain에 들어가는가가 검증분** — #9는 이미 GAP(라이브 ref_param_json 미구현).
- **(b) 커버**(#9). `unverified`. **라우팅: gap-analyst(#9 공정파라미터 GAP에 미싱/천공 패턴 포함).**

### M-4 [C-13] 드릴링/홀펀칭 — **MISSING-PROCESS(공정#2 + #9), RP PR 미관측**
- **codex:** 매뉴얼/캘린더/태그/바인더가 드릴링(구멍 수·직경·간격·위치·국제 바인더 규격) 노출.
- **대조:** 포스터 타공(HOL_DFT)=공정#2 이미 관측(reverse §3). 바인더 드릴링은 PR 책자가 아닌 캘린더/태그류 — RP PR 캡처 미관측이나 공정#2+#9로 흡수 가능.
- **(b) 축 커버**(#2/#9) + RP 노출 검증분. `unverified`. **라우팅: reverse-engineer(RP 책자/캘린더 드릴링 옵션 실재) — 우선순위 낮음.**

### M-5 [C-6] grain direction(결방향) ↔ fold 의존 — **DOMAIN-RULE(제약#5 + 자재 facet)**
- **codex:** 제본은 결이 spine 평행·접지는 잘못된 결이 cracking. `grain × fold × gsm × coating`이 접지/제본 feasibility 결정. 자재에 결방향 필요.
- **대조:** 우리 disable-rule(자재→공정 비활성 24건·`pdt_disable_pcs_info`)이 *저평량지→코팅/접지 disable*은 담으나 **결방향은 자재 속성으로 미관측**. RP가 결방향을 자재코드/제약으로 인코딩하는가 미확인.
- **(b) 제약#5/자재#1로 표현 가능** + RP 인코딩 여부 검증분. 결방향이 RP 자재행 속성이면 자재 분해축(이미 WEAK)에 추가. `unverified`. **라우팅: gap-analyst(자재 분해축에 결방향·caliper 포함 검토·이미 자재 WEAK).**

### M-6 [C-7] spine width(책등 폭) 계산 + caliper/bulk — **DOMAIN-RULE(제본#2 + 자재 caliper)**
- **codex:** 무선제본 책등=대략 `page×caliper/2 + cover allowance`·gsm만으론 불충분·자재에 caliper/bulk 필요·책등 폭 변하면 표지 아트워크 템플릿 변함.
- **대조:** 우리 자재는 평량(WGT)만·**caliper/bulk(두께) 컬럼 미관측**. 책등폭은 앱계산이나 *입력으로 caliper가 자재에 필요* — codex의 checkable 포인트(자재에 caliper 부재).
- **(b) 계산은 앱·범위밖** + caliper 자재속성은 검증분(자재 분해축). `unverified`. **라우팅: gap-analyst(자재 분해축에 caliper/bulk 포함·결방향 M-5와 묶음).**

### M-7 [C-16/C-17/C-19] 제본 adhesive(PUR vs EVA)·새들 wire·die/kiss/laser cut 구별 — **MISSING-PROCESS(공정#2 멤버 정밀화)**
- **codex:** 무선제본 PUR≠EVA(강도/평탄/코팅지 적합/가격)·새들스티치 loop/wire색/stitch수·완칼≠kiss-cut≠레이저≠라우터(자재한계·엣지품질 다름·등가 취급 금지).
- **대조:** 제본방식=공정#2(P-4)·레이저커팅/완칼=공정#2 멤버(P-9) 이미 등재. **codex가 "멤버를 더 세분(PUR/EVA·kiss/die/laser 구별)" 요구** — 공정 멤버 enum 세분화 후보(축 아님).
- **(b) 축 커버**(#2) + 멤버 enum 세분은 검증분. `unverified`. **라우팅: reverse-engineer(RP 무선제본이 PUR/EVA 구별 노출·완칼 vs kiss-cut 구별 여부).**

### M-8 [C-20] 하드커버 부속(dust jacket/ribbon/head-tail band/slipcase) — **MISSING-PROCESS(공정#2/Addon#8) + #14 일반화 시험**
- **codex:** 하드커버/프리미엄 책=먼지덮개·가름끈·헤드밴드·벨리밴드·슬립케이스·양장·둥근등 — `Addon`/`Process` 적합하나 `Body-form-assembly`(#14)가 굿즈 넘어 일반화되는지 시험.
- **대조:** RP PR 캡처는 소프트커버(CVR_SFT)·날개(CVR_SWN)만 관측, **하드커버/양장 unobserved**(reverse §2 note "하드커버는 별 상품/옵션 추정"). 가름끈/헤드밴드=Addon#8 또는 공정#2·자재 bundle.
- **(b) Addon#8/공정#2 커버** + 하드커버 RP 노출 검증분 + #14 일반화 질문(굿즈 형태가공 vs 책 부속). `unverified`. **라우팅: reverse-engineer(RP 하드커버/양장 책자 옵션 실재) + metamodel-architect(#14가 책 부속까지 담는가).**

---

## LOW 우선순위 / 폐기 (이미 커버 또는 RP 무관)

### L-1 [C-5] 납기/turnaround SLA 축 — **(c) 메타모델 범위 밖(주문런타임)**
- codex가 "rush가 코팅/제본/페이지수 게이팅"으로 축 가능성 제기하나, **납기/SLA는 주문런타임·생산캐파 영역**(huni-project-plan·MES). RP PRPODAY "[오늘 출발]"은 *별 pdtCode*(제약·납기)로 reverse §4-A 이미 관측 → 카테고리/제약 facet. 새 관리축 아님. **폐기**(주문런타임 out-of-scope·TP H-1 동형).

### L-2 [C-8] 페이지 순서/collation — **(b) H-2에 흡수**
- C-1 서명 축의 하위(collation 순서). H-2에서 함께 검토(면지/tip-in/tab 끼우는 순서가 RP 옵션인가). 별도 후보 아님 → H-2로 병합.

### L-3 [C-9] 탭/인덱스 디바이더 — **(b) 공정#2+#9·RP PR 미관측**
- 탭 leaf는 구조적 객체(일반 페이지 아님)·planner/카탈로그. RP PR 미관측. 공정#2(탭 다이컷)+#9(탭 수/위치)로 흡수 가능. H-1(per-section) robustness 시험에 포함. **LOW**.

### L-4 [C-10] 책 내부 foldout/gatefold — **(b) H-1에 흡수**
- "제본된 본문에 큰 접지 시트 tip-in"은 접지(P-1 공정#2)를 *본문 내 1섹션에 scope*해야 — H-1 per-section 엣지케이스의 한 사례. H-1로 병합.

### L-5 [C-14] 포장/번들(shrink-wrap/banding/kitting) — **(b) 공정#2/Addon#8**
- GS에서 포장=공정#2(PAK_ETC/PAK_POL·유료무료·G-8) 이미 등재(`_resolved-fragments.md` G-8). PR도 동형 흡수. shrink-wrap per N copies=가격기여#11 분기. **폐기**(GS G-8 커버).

### L-6 [C-15] FSC/재생/eco 인증 — **(b) 자재 facet/메타데이터, RP PR 미관측**
- FSC지/재생지/콩기름잉크=자재#1 facet(인증 메타). "인증마크가 출력물에 표시" 면 아트워크 영역. RP PR 미관측. 자재 분해축 또는 자재 메타 컬럼. **LOW**(자재 WEAK에 흡수 가능·우선순위 낮음).

---

## 도메인 규칙 (codex 제시 10항) — 검증 후 메타모델 제약#5/자재에 인코딩 후보 (전부 unverified)
> codex의 print-domain 일반 규칙. **RP/후니에 실재하는지 검증 전 사실 아님.** 대부분 *앱 계산/검증 로직*(제약#5 또는 런타임)이지 base-data 행이 아님.
- 새들스티치 페이지=4배수·무선=2배수·최소두께 → **제약#5(min-max/match)**. RP `pdt_prn_cnt_info` STEP/MIN에 일부 인코딩(검증).
- 책등폭=page×caliper → 앱계산(M-6, caliper 자재속성만 검증분).
- 결방향 spine 평행·접지 결 의존 → **제약#5 + 자재 결방향**(M-5).
- bleed 3mm·safe margin 제본변/드릴/접지/다이컷별 → 아트워크/검증 로직(범위 밖이나 제약#5 가능).
- 롤폴드/게이트폴드 패널 폭 불균등(face encoding이 panel compensation 포함) → **P-1 접지 family 정밀화**(우리 P-1은 "면수=파생값"으로 닫음 — codex는 *패널 폭 보정*까지 필요 지적·검증분).
- 두꺼운 코팅지 접지=선 creasing 필요 → 접지↔오시 cascade(P-1 이미 등재).
- UV/foil/emboss=min line width·gap·registration·spot layer 명명 → 공정#9 파라미터(M-2).
- offset 책자 서명구조=blank page·pagination·make-ready·가격 영향 → H-2(서명 축·앱계산 경계).

**도메인 규칙 라우팅:** gap-analyst(제약#5 RULE_TYPE 확장 시 min-max/match에 페이지배수·결방향 포함 검토) + 대부분 앱계산/검증로직은 범위 밖 noting.

---

## 종합 — codex second-opinion이 우리 분석에 주는 것

| 후보 | 분류 | 라우팅 | 검증 우선 | saturation 영향 |
|---|---|---|---|---|
| **H-1 per-section 자재** | 신규(EDGE-CASE) → **REFUTED-for-RP**(2026-06-17 캡처 실측) | ~~gap-analyst+reverse-engineer~~ 채택0·재진입 불요 | ~~HIGH~~ **종결** | RP 미노출(inner 단일슬롯·섹션키0)→P-2 robust·채택0·forward-looking noting만 |
| **H-2 서명/대수 축** | 17축 후보 | metamodel-architect | **HIGH(기각 예상)** | 앱계산·RP미노출이면 무해 |
| **H-3 교정/승인** | 신규(MISSING-OPT) | reverse-engineer→gap-analyst | MED-HIGH(기각 예상) | 주문런타임이면 범위 밖 |
| M-1 임포지션/work-size | facet #13/앱계산 | gap-analyst | MED(기각 경향) | 커버 |
| M-2 넘버링/foil 파라미터 | facet #16/#9 | gap-analyst | MED | 커버(#9 GAP) |
| M-3 천공 패턴 | facet #9 | gap-analyst | MED | 커버(#9 GAP) |
| M-4 드릴링 | MISSING-PROC #2/#9 | reverse-engineer | LOW | 커버 |
| M-5 결방향 | DOMAIN-RULE 제약#5/자재 | gap-analyst | MED | 자재 WEAK 흡수 |
| M-6 caliper/spine | DOMAIN-RULE 자재 | gap-analyst | MED | 자재 WEAK 흡수 |
| M-7 PUR/EVA·cut 구별 | MISSING-PROC #2 멤버 | reverse-engineer | MED | 멤버 세분(축 아님) |
| M-8 하드커버 부속 | MISSING-PROC #2/#8 + #14 | reverse-engineer+architect | MED | #14 일반화 시험 |
| L-1 납기 SLA | 범위 밖(런타임) | — | 폐기 | 무해 |
| L-2 collation | H-2 흡수 | — | — | — |
| L-3 탭 | facet #2/#9 | — | LOW | 커버 |
| L-4 foldout/gatefold | H-1 흡수 | — | — | — |
| L-5 포장/번들 | facet #2/#8(GS G-8) | — | 폐기 | 커버 |
| L-6 FSC/eco | facet 자재 | — | LOW | 흡수 가능 |

**★핵심 결론:**
1. **codex가 17축 후보를 강하게 제기(H-2 서명/대수)했으나 기각 예상** — 후니 도메인 권위가 임포지션/대수를 "앱 계산·DB 미저장"으로 확정했고(메모리), RP PR 스토어프론트는 서명 구조를 고객 옵션으로 노출하지 않음(생산 내부) → saturation 주장에 무해. **단 검증 트리거로 metamodel-architect가 "대수=관리축 vs 앱계산" 경계를 한 번 명시 재확인**할 가치 있음.
2. **진짜 검증 가치 HIGH = H-1 per-section 자재** — 우리 P-2 facet 판정("usage_cd 2슬롯")이 *동일 역할 내 N-섹션 다른 stock*을 미검토했다는 정당한 사각. RP 책자가 섹션별 내지를 노출하면 P-2 정정 + 섹션 엔티티 검토, 미노출이면 forward-looking 후니 vessel 후보로만 noting. **이것이 codex 보강의 최대 수확.**
3. **M-5/M-6(결방향·caliper)는 자재 분해축(이미 WEAK)에 추가 검증분** — 우리 자재 WEAK 판정이 "CLR/PTT/WGT 분해" 였는데 codex가 caliper/bulk·grain을 더 요구 → 자재 분해축 정의 풍부화.
4. **나머지(M-2/M-3 파라미터·M-7 멤버 세분·L-군)는 기존 축 facet 정밀화** — 새 축 아님. saturation 주장 유지.
5. **codex의 print-domain 깊이는 유효**(서명·spine·grain·PUR/EVA 등 정확) — 그러나 *RP가 노출하는 것* vs *상업인쇄가 가능한 것* 경계를 codex는 모름(RP 데이터 무접근). 검증의 1차 질문은 항상 "RP PR 캡처/라이브에 보이는가".

**채택 0 — 전부 `unverified` 후보 등재까지.** 검증(reverse-engineer 로그인 캡처·gap-analyst 라이브 information_schema·metamodel-architect 앱계산 경계)은 owning agent가 수행. validator는 본 목록으로 M-gate에서 "어떤 후보도 무검증 채택되지 않았는가" 확인.
