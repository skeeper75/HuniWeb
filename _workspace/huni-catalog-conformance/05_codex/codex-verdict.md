# codex-verdict.md — Codex(gpt-5.5) 독립 2차 교차검증 원문

> **Phase 5 — hcc-codex-verifier** · 2026-06-22 · `huni-catalog-conformance/05_codex`
> 호출: `codex-review.sh codex-prompt.txt gpt-5.5 _workspace/huni-catalog-conformance high`
> **codex 가용**(preflight=AVAILABLE model=gpt-5.5, codex-cli 0.140.0). 1차 호출은 transient rc=2,
> 재호출에서 정상 응답. 입력=결함 보드 3종+권위 발췌만(Claude GO/NO-GO 비노출·비밀값 0).
> **★[HARD] codex 주장 = 가설.** 라이브/권위로 검증되기 전엔 사실 채택 금지. 근거 실재성 대조는 reconcile.md.
> codex는 라이브 DB 미접속 — 결함 보드·권위 기준의 논리적 정합만 판정(codex 자기 명시).

---

## 총평 (codex 원문)

> "대체로 결함 보드 방향에 동의하되, 일부는 CONFIRM/범위축소가 필요." (라이브 재조회 없이 내부 논리만)

---

## Q1 — 놓친 누락·끊긴 연결

- **[동의]** 큰 축의 누락 없음. 36상품 × 13축(basedata 8 + cpq 4 + price 1) 모두 커버.
- **[이견]** `옵션→차원 264/264`·`템플릿 5/5`는 "이미 적재된 option_item/template에 한한 연결무결성"으로만 맞음.
  `option_groups MISSING 21`·`addon/template MISSING 9`가 있으므로 전체 CPQ 완성도 100%처럼 읽으면 안 됨.
  끊긴 링크는 아니고 **미적재로 검증 대상 자체가 없음**.
- **[신규발굴]** `PRD_000050 봉투제작`·`PRD_000051 썬캡` 판형은 권위상 "비판형 needed=N" 명시 →
  라이브 plate 존재는 **CONFIRM보다 EXTRA 후보가 더 강함**. `PRD_000037 오리지널박명함`은 비판형 여부
  미명시 → **CONFIRM 유지가 맞음**.

## Q2 — false-positive(정당한 도메인 의미구분)

- **[동의]** basedata 별색 MISSING 대부분 진짜 결함. 별색=도수 아닌 PROC_000007 family 링크여야 하며,
  "마스터 존재 + product_processes 링크 0"이면 상품별 선택/가격가산이 끊김.
- **[이견]** `PRD_000024 포토카드`·`PRD_000025 투명포토카드` 화이트인쇄단면은 보드 자체가 `C-VAR-WHITE`
  CONFIRM으로 올림. basedata에서 이 둘을 확정 MISSING/MISMATCH로 세면 **과판정 가능성** → CONFIRM이 안전.
- **[이견]** cpq `constraints MISSING 34`는 방향 그럴듯하나 권위가 "표기 상품만 needed=Y". 보드가
  `016~049 전부 needed=Y`라고만 하고 상품별 별표/블리드/가변 근거를 펼치지 않음 → **34 전건 확정 MISSING은
  근거 부족**. 결함 후보는 맞으나 상품별 근거 필요.
- **[이견]** 페이지룰 LOW MISSING 5 조심. 도메인 렌즈 `[HARD] 판수=앱 런타임 계산(DB 미저장)`과 충돌 →
  `엽서016~019`·`2단접지카드027` page_rule MISSING은 확정 결함보다 **CONFIRM으로 낮추는 게 맞음**.
- **[동의]** 묶음수 MISSING 10은 "제작수량_건수"가 엑셀에 옵션 표기된 경우에 한해 결함. "명함류 건수 박스단위"면
  LOW 결함 유지 타당.

## Q3 — 가격엔진 돈영향 부호·메커니즘

- **[동의]** 기본 메커니즘 맞음. frm_cd 미바인딩 10건=견적 차단/0원, COMP_COAT_GLOSSY 0행=유광 과소,
  orphan variant comp=선택값 무시로 과소 방향 맞음.
- **[이견]** D-A·D-B는 **동시 적용 시 부호가 달라질 수 있음**. PRD_000032 코팅명함 COAT 선택인데 STD_S1/S2
  둘 다 와일드카드 통과하면, 보드는 D-A에서 350,000 vs 550,000 과소라 했으나 D-B 합성 시 실제값
  800,000 vs 550,000 **과대**가 될 수 있음. 개별 결함 isolated 부호는 맞으나 **상품별 최종 과대/과소는 합성 재계산 필요**.
- **[이견]** D-A −200,000·D-B +450,000 금액 규모는 DEF-PE-05(prc_typ 심의)와 연결. 3,500/5,500이 100매
  묶음 총액이면 차이는 −2,000·+4,500 단위가 됨. **부호 유지, 금액 크기는 CONFIRM**.
- **[신규발굴]** price-engine 보드가 formula 중심이라 CPQ/basedata 미적재로 인한 돈크리티컬 누락이 별도
  집계에서 빠질 수 있음. `PRD_000020~022`·`023`·`028`·`043~046`·`048` 등은 공식이 있어도 별색/커팅/접지
  선택 경로가 없으면 가산비 선택·계산 불가 → price formula 결함은 아니지만 **E2E 견적 돈영향 결함**.

## Q4 — 커버리지 빈 칸

- **[동의]** 산술 커버리지 맞음. 288+144+36=468 = 36×(8+4+1). 상품×축 빈 칸 없음.
- **[이견]** 468셀은 **축 단위** 커버리지. 옵션값 cardinality·constraint 근거·MISSING option_group 내부
  미생성 option_item은 별도 행으로 펼쳐야 보임. "빈 셀 0"은 맞으나 "세부 선택지까지 누락 0"은 아님.

---

## codex 메타

- tokens used: 53,975 · 판정 범위: 라이브 DB 재조회 없이 권위 기준+결함 보드 내부 논리만(codex 자기 명시).
- codex가 명시적 환각(허위 prd_cd·없는 코드 인용) 없음 — 인용한 prd_cd(050·051·037·032·024·025·020~023·028·043~046·048)
  전부 디지털 스코프(PRD_000016~051) 실재. 근거 실재성 대조는 reconcile.md §환각경계.

---

# 배치1 — 포토북(PRD_000100~107)·캘린더(PRD_000108~112) Codex 원문 판정

> **Phase 3 배치1 — hcc-codex-verifier** · 2026-06-22 · `huni-catalog-conformance/05_codex`
> 호출: `codex-review.sh codex-prompt-batch1.txt gpt-5.5 _workspace/huni-catalog-conformance high`
> **codex 가용**(AVAILABLE·gpt-5.5·codex-cli 0.140.0·EXIT=0·tokens 18,848). 입력=배치1 결함 보드 발췌
> + 권위/도메인 발췌 + 검증자 독립 라이브 실측 사실(S1~S7)만. Claude GO/NO-GO 비노출·비밀값 0.
> codex는 라이브 미접속 — 제공 사실+도메인 논리 정합만 판정(codex 자기 명시). ★[HARD] codex 주장=가설.

## 총평 (codex 원문)
> "인스펙터 보드의 큰 방향은 타당. 다만 Q1은 '반제품 자식행 0=MISSING'보다 **본체 superset 적재가 역할축을
> 잃은 결함**으로 재라벨링하는 게 정확. Q4(c)만 권위상 EXTRA 우세하되 제품 실물 확인 여지."

## Q1 — Q-PB-SUPERSET (verdict 분기 핵심)
- **[동의·단 라벨 정정]** 자식행 0행 자체는 "세트 본체 집약"이면 N/A 가능. 그러나 자재만 USAGE.01/02/03으로
  역할 구분되고 도수·판형·공정은 본체에 무구분 합쳐져 **역할 스코프 소실**. 무해하지 않음 —
  내지=양면·페이지룰, 표지=단면·무광코팅, 면지=PUR제본처럼 역할별 적용축이 달라 스코프 없으면 잘못된 조합 차단·
  가격차원 판별 곤란. **"MISSING"보다 ROLE_SCOPE_MISSING / LOSSY_SUPERSET 결함이 정확.** (비대칭=진짜 결함 신호)

## Q2 — GATE-1 (constraint_json)
- **[동의]** S7 기준 `t_prd_products.constraint_json`은 라이브 부재 컬럼. 제약 권위=별도 테이블
  `t_prd_product_constraints.logic`. checklist target_table 49행은 데이터 결함 아닌 **검증 명세/타깃 표기 오류** →
  횡단 정정 타당.

## Q3 — DEF-PE-06 full WIRE 깊이
- **[동의]** 디지털=공식 실재·바인딩만 부재 ↔ 포토북/캘린더=PRF_PHOTOBOOK*/PRF_CAL* 카탈로그 0행 →
  공식 그래프 신규 구성 필요(작업 깊이 더 큼). 단 재사용 comp(BIND_CAL_*·PAPER·PRINT_DIGITAL·COAT_MATTE)
  단가행 실재로 범위 축소 → 정확 규모=**공식 신설 + 기존 comp 재배선 + 누락 comp/단가만 보충 + product binding**.
  "전부 신규 단가 설계"는 아니나 "디지털보다 큰 full WIRE" 판단은 맞음.

## Q4 — false-positive 사냥
- **(a) 캘린더 자재 EXTRA [동의]** 권위가 삼각대/링을 캘린더가공·링칼라(공정축)로 둠. 물리부품이란 이유로
  자재 슬롯 허용되는 구조 아님. 종이와 같은 USAGE.07 혼입=축 오염. (false-positive 아님)
- **(b) 112 판형 [동의]** component_prices.siz_cd=출력판형(전지) HARD·권위 전지 330x660. 304x629=작업사이즈
  동일치 → 판형 오적재. (false-positive 아님)
- **(c) 110 엽서캘린더 타공 [동의+CONFIRM]** 권위 빈칸이면 EXTRA 의심 타당. "벽걸이형 타공" 논리는 111엔 맞으나
  110 엽서캘린더엔 직접 전이 불가. 단 실제 걸이구멍 포함 상품이면 권위 누락 가능 → 실물/주문페이지 확인 대상.
- **(d) D-CAL-PAGE MISSING [동의]** "판수=앱런타임" 일반원칙과 불충돌. 캘린더는 고정 페이지사양=상품 본질
  예외 명시 → 108~112 page_rule 부재는 결함. (false-positive 아님)

## codex 신규발굴
- **[신규발굴 N-B1]** 핵심 결함은 반제품 자식행 0보다 **본체 100 역할별 제약/스코프 부재**(공정 2·판형 11·도수 2가
  전역 부착 → 표지/내지/면지 간 잘못된 조합 생성 위험).
- **[신규발굴 N-B2]** 111 벽걸이도 링블랙이 자재에 있고 공정엔 타공만 확인 → 108/109뿐 아니라 111도 링 공정
  누락 후보. 112는 공정 미실측 CONFIRM.
- **[신규발굴 N-B3]** `DEAD_LINK 0`은 option_item 0행에서 온 vacuous clean → 연결무결성 PASS로 오독 금지.
  CPQ 전미적재 결함의 부수 상태로만 해석.
- **[신규발굴+CONFIRM N-B4]** 반제품 101~107이 라이브 고객노출 active면 공식/CPQ/자식축 0행으로 dead-catalog
  별도 문제. semi_role로 완전 숨김 내부 반제품이면 N/A.

## codex 메타
- tokens 18,848 · 판정범위: 라이브 재접속 없이 제공 사실(S1~S7)+권위+도메인 논리만(codex 자기 명시).
- 환각(허위 prd_cd·없는 코드) 없음 — 인용 전부 제공 사실 내. N-B2만 검증자 라이브 재실측으로 부분 정정(아래 reconcile).

---

# 배치2 — 책자10·문구9·악세15 (34상품) Codex 독립 2차 교차검증 원문

> **Phase 3 배치2 — hcc-codex-verifier** · 2026-06-23 · `huni-catalog-conformance/05_codex`
> 호출: `codex-review.sh codex-prompt-batch2.txt gpt-5.5 _workspace/huni-catalog-conformance high`
> **codex 가용**(preflight=AVAILABLE model=gpt-5.5). 입력=배치2 결함 보드 3종 발췌 + 검증자가 라이브 재실측한
> S-사실(S-CODE·S1~S5) + 권위 도메인 렌즈. Claude GO/NO-GO·게이트 결론 비노출(독립성)·비밀값 0.
> **★[HARD] codex 주장 = 가설.** 라이브/권위로 검증되기 전엔 사실 채택 금지. 근거 실재성 대조는 reconcile.md 배치2.

## codex 원문 (5쟁점 + 신규)

### 쟁점1 — 094 엽서북 silent 이중합산: [동의]
S1b/S1c가 사실이면 돈크리티컬 과대청구. S1_20P·S2_20P 동시 배선·둘 다 print_opt_cd=NULL·use_dims=[siz_cd,min_qty]면
단/양면 판별 차원 부재 → 와일드카드 동시 매칭. 단면 선택 시 S1 11,000+S2 11,500 = +11,500 과대. **양면 선택도 S1이
함께 붙어 +11,000 과대**. 30p orphan: 30p 단가행 존재·미배선 → 현 공식 경로로 30p 가격축 도달 불가. 단 "30p 주문도
20p 단가로 매겨짐"은 30p가 동일 PRF_PCB_FIXED를 타는지 미명시라 **추정**. 확실한 결론은 "30p 단가행 현재 공식에서 도달 불가".

### 쟁점2 — DEAD_LINK 5건: [동의]
삭제 권위=del_yn='Y'·옵션 차원연결=option_item.ref_key1→siz면, A5/A4 옵션이 삭제된 SIZ_000170/253/255를 가리키는
상태는 정상 차원 환원 아님. "활성 SIZ_000172 정상·삭제 siz만 dead" 구분에도 동의. 같은 상품 안 정상링크·dead link 공존.

### 쟁점3 — del_yn comp 합산: [동의]
반대 가설("del_yn=Y comp 평가 제외")을 S-CODE로 기각. 공식 구성요소·단가행 조회 모두 del_yn 필터 없음·코드 전체 del_yn 0회면
삭제 comp도 평가 포함. PRF_BIND_SUM에 COMP_BIND_JUNGCHEOL(del_yn=Y)만 배선돼도 실제 합산. 068 중철 우연 일치·069 무선/070
PUR/071 트윈링이 중철값 misfire 동의. 표지/내지 comp 0행 → 완성가 아닌 부분합 가격 판단도 맞음.

### 쟁점4 — false-positive 사냥: [부분 불일치]
(a) 악세 부속물 변형 materials USAGE.07 귀속 = **결함 쪽 동의**. HARD 렌즈가 "부속물=사이즈(필수) 컬럼에 변형(색/길이)"
못박음. 볼체인 색상·와이어링·행택끈·우드봉·리필잉크 색상은 소재 사양 아닌 판매 변형축 → sizes 0+materials N은 축귀속 오등록.
(b) 책자 071/082/088 바인더링·투명커버 materials 귀속 = **결함 가능성 높으나 CONFIRM 유지 타당**. 링/투명커버는 자재 아닌
제본옵션/공정/표지옵션이 원칙이나 USAGE.05/07 분리·실제 엔진/어드민 슬롯 사용 여부 미제공 → "정당 슬롯" 배제하려면 추가 확인 필요.
false-positive 지목할 것: 봉투류 001~005·009·011 치수형 sizes 정상 등록은 인스펙터도 MATCH로 구분 → 과잉표기 아님.
반대로 악세 006/007/008/010/012/013/014/015를 단순 CONFIRM으로 둔 것은 오히려 약한 표기·결함으로 격상 가능.

### 쟁점5 — Q-PA-ADDON: [동의]
악세 "자체 완제품가 + 본상품 addon" 이중역할 양립 가능. OPP봉투=단독 구매 완제품 + 엽서 추가 구성품 모델은 자연스러움.
인스펙터 "양립 확인" 옳음. S5b 사실이면 돈영향도 맞게 봄: 001/002 product_prices=0·template_prices=0 → 단독·addon 양 경로
가격 전무. 003~015 addon 연결 자체 없음 = "본상품 addon으로 안 붙음" 맞음.

### 쟁점6 — 누락/false-positive (신규)
- **신규A:** del_yn 필터 부재 자체가 가격엔진 공통 결함. 인스펙터는 제본 comp 사례로 잡았으나 S-CODE면 모든
  formula_components·component_prices에서 논리삭제 행이 살아있는 가격 입력으로 작동 → 배치2 밖 동일 패턴 전수 스캔 필요.
- **신규B:** 094 양면 선택도 과대청구(+11,000). 보드는 단면 케이스(+11,500)에 초점이나 구조상 양면도 단면 comp 붙음.
- false-positive 후보: 071/082/088 링/투명커버 materials 귀속을 확정 오염으로 단정하는 부분(USAGE 분리·UI/엔진 동작 미제공 → CONFIRM 적절).

### codex 종합 한 줄
가장 위험한 결함 = 094 엽서북 단/양면 wildcard 동시합산 과대청구. 가장 의심스러운 false-positive = 책자 링/투명커버
materials USAGE.05/07 귀속을 확정 오염으로 단정하는 것(CONFIRM 유지가 타당).

---

# [APPEND 2026-06-23] 과대청구 타겟 스캔(OC-01~08) — codex 독립 2nd opinion

> 입력: `04_price_engine/overcharge-scan-catalog.md`·`.csv`(8건 silent 이중합산 후보).
> codex 가용=AVAILABLE(gpt-5.5·high·read-only). 프롬프트=`05_codex/codex-prompt-overcharge.txt`.
> ★codex 주장=가설. OC-ID는 codex가 프롬프트 등장순으로 재번호(보드 ID와 다름) — 의미 매핑은 reconcile에서 정합.

## codex 판정 요약(원문 의미)

| Q | codex 라벨 | 핵심 |
|---|-----------|------|
| Q1 접지카드 4합산 | **CONFIRM** | 오류(택일인데 4개 청구). 25,000×qty 청구. 과대액=택일별 18,000~20,000×qty(3FOLD택→19,000·4ACC/4GATE택→18,000·HALF택→20,000) |
| Q2 V2 인과 | **CONFIRM** | use_dims=[min_qty]만→P8-1 미분리·별 comp_cd→P3-8 미발화→P2-2 4개 included→P2-3 합산. 계약 정합 |
| Q3 포토카드 | **CONFIRM** | 024(일반)·025(투명) 같은 공식+동일차원→6000+8500=14500 합산. 기존 MATCH 분류 정정 타당 |
| Q4 false-positive 가드 | **DISPUTE** | proc_grp 토큰 보유 clean(디지털vs별색·귀돌이·오시·가변·PERF_1L·CUT_PERF·코팅)은 정당분리=오적발 아님. **단 COMP_PP_PERF_2L/3L은 clean 확정 불가**(proc_grp 토큰 없음·FOLD_LEAF 동형 위험) |
| Q5 신규 | **CONFIRM** | 신규 도전 항목=PERF_2L/3L. "PERF 통째 clean"은 과잉 일반화. (codex는 "같은 공식 배선+단가행 겹침이면"으로 조건부 명시·확정 불가 표기) |

## codex 8건 판정(의미 정합 후)
- OC-01~06(명함2·엽서북·접지카드3 = 보드 OC-01~06): **전부 과대청구 맞음**.
- OC-07·08(포토카드 024·025): **과대청구 맞음**(기존 MATCH 정정).
- false-positive 오적발(8건 중): **0건**.

## codex 접지카드 한 줄 결론
> "4개 합산은 의도된 구성요소 합산이 아니라, 택일 접지방식 4개를 모두 청구하는 silent 이중합산 오류."

## codex 신규 발굴(가설)
- **COMP_PP_PERF_2L·3L**: proc_grp 토큰 없음 → 같은 공식 배선+단가행 겹치면 FOLD_LEAF 동형 silent 합산 위험.
  codex가 "확정 불가·조건부"로 명시한 가설 → 라이브 검증 대상으로 라우팅(채택 금지).
