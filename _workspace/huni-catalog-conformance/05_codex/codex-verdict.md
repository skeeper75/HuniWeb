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
