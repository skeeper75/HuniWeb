# reconcile.md — Claude 인스펙터 ↔ Codex 행별 reconcile

> **Phase 5 — hcc-codex-verifier** · 2026-06-22 · `huni-catalog-conformance/05_codex`
> 행별 {Claude 인스펙터 · codex · 합의/불일치 · 근거 실재성 대조 · 라우팅}.
> **합의=고신뢰** · **불일치=게이트 조사 큐** · **codex 신규=확인 필요 후보(hypothesis)**.
> codex 가용(AVAILABLE gpt-5.5). codex는 라이브 미접속 → 모든 codex 신규/이견은 게이트가 라이브 최종 판정.
> ★[HARD] codex 주장=가설. 본 reconcile은 채택이 아니라 라우팅. 최종 GO/NO-GO는 hcc-conformance-gate.

---

## 0. 한 줄 결론

- codex 총평 = "결함 보드 방향 대체로 동의, 일부 CONFIRM/범위축소 필요". **합의 다수(고신뢰)·불일치 5·codex 신규 2.**
- **codex 환각(근거 부재 허위 주장) = 0건.** codex 인용 prd_cd 전부 디지털 스코프 실재(라이브 tsv 대조 완료).
- codex가 적발한 **주요 false-positive 후보 2건**(포토카드 별색 과판정·constraints 34 전건 근거부족),
  **놓친 결함 신규 1건**(E2E 견적 돈영향: 공식 있어도 옵션경로 부재 상품), **부호 정밀화 1건**(D-A/D-B 합성).

---

## 1. 합의 (고신뢰 — 게이트 확정 우선)

| # | 항목 | Claude 인스펙터 판정 | codex | 근거 실재성 | 라우팅 |
|---|------|----------------------|-------|-------------|--------|
| A1 | basedata 별색 MISSING/MISMATCH 17건 (019~025·035·036·039·040·043~046·048) | 진짜 결함(HIGH·견적가산 누락) | [동의] 마스터 존재+링크 0이면 선택/가격가산 끊김 | ✅ PROC family·product_processes 링크 0은 boards 근거와 일치 | **고신뢰** — dbm-correctness-audit |
| A2 | 가격엔진 frm_cd 미바인딩 10상품 (019·030·034~040·049) | MISSING·견적 차단(0원) | [동의] 견적 차단/0원 위험 | ✅ 10 prd_cd 전부 디지털 스코프 실재 | **고신뢰** — engine-design 명세→dbm-load-execution |
| A3 | COMP_COAT_GLOSSY 단가행 0 | MISSING·유광 과소·0원 침묵 | [동의] 유광코팅비 과소 방향 맞음 | ✅ 메커니즘 정합 | **고신뢰** — dbm-load-execution |
| A4 | 옵션→차원 264/264·템플릿 5/5 = 끊긴 링크 아님 | 연결 무결성 건강·갭=not-yet-loaded | [동의] but "이미 적재된 것에 한한 무결성"임을 명시 강조 | ✅ 트리거 fn_chk_opt_item_ref 강제 정합 | **고신뢰**(단 표현 주의=A4-note) |
| A5 | 묶음수 MISSING 10(명함류 박스단위) | LOW 결함 | [동의] "건수 표기"면 결함 유지 타당 | ✅ bundles.tsv 031~040 0행 확인 | **고신뢰** — dbm-load-builder |
| A6 | 커버리지 468셀 빈 칸 0 | 빈 셀 0(288+144+36) | [동의] 36×13=468 산술 정합 | ✅ basedata-cells 288·cpq 144·price 36 실측 | **고신뢰** |
| A7 | DEF-PE-01~04 기본 메커니즘(orphan=과소·미바인딩=차단) | 명시 | [동의] isolated 부호 맞음 | ✅ | **고신뢰** |

> **A4-note**: codex가 "264/264·5/5을 CPQ 완성도 100%로 읽으면 안 됨"을 강조. 이는 Claude 보드도 이미 명시
> ("not-yet-loaded가 지배적 갭"). 합의이나 게이트 보고 시 오독 방지 표현 권장(불일치 아님).

---

## 2. 불일치 (게이트 조사 큐 — 라이브 재실측으로 최종 판정)

| # | 항목 | Claude 인스펙터 | codex 이견 | 근거 실재성 | 라우팅(게이트 조사) |
|---|------|-----------------|------------|-------------|---------------------|
| **X1** | PRD_000037·050·051 판형 | **CONFIRM 3건**(권위 빈값 vs 라이브 plate·needed 재판정) | **050·051은 EXTRA 후보가 더 강함**(권위 비판형 needed=N 명시)·037만 CONFIRM 유지 | ✅ 라이브 plate-sizes.tsv: 050(4행)·051(1행)·037(1행) **모두 output_paper_typ_cd=NULL** 확인 | **게이트 조사**: 050/051 EXTRA vs CONFIRM 판정. authority §4 needed=N + NULL-type plate → codex EXTRA 논거 실재. needed 재판정 큐 연계 |
| **X2** | 포토카드 024·025 화이트인쇄단면 | basedata는 **MISMATCH 확정**(인쇄옵션 미적재)·cpq는 C-VAR-WHITE **CONFIRM** | basedata 확정 MISMATCH는 **과판정**·CONFIRM이 안전(보드 내 판정 불일치) | ✅ 보드 내부 불일치 실재(basedata MISMATCH ↔ cpq/price CONFIRM 병존) | **게이트 조사**: 024/025 별색 단일판정 정합. sentinel vs 미적재 공정 라이브 재실측(option_item ref_dim) |
| **X3** | constraints MISSING 34(016~049 전부) | 전건 needed=Y·MISSING | 권위는 "표기 상품만 needed=Y" → **34 전건 확정 근거 부족**(상품별 별표/블리드/가변 근거 미전개) | ⚠️ 보드는 상품별 제약 근거 미상세(근거 펼침 부재 사실) | **게이트 조사**: 상품별 제약 표기(별표/블리드/박크기/가변) 권위 재추출 → needed 상품별 재판정 |
| **X4** | 페이지룰 MISSING 5(016~019·027) | LOW·MISSING 확정 | 도메인 렌즈 `[HARD] 판수=앱런타임 DB미저장`과 충돌 → **CONFIRM으로 낮춰야** | ✅ page-rules.tsv 0행(전 상품 미적재)·domain-lens §횡단 판수=앱계산 명문 충돌 실재 | **게이트 조사**: 페이지룰 needed 판정. 권위 §9 page_rules vs 렌즈 판수=앱계산 충돌 해소 |
| **X5** | DEF-PE-02/03 금액규모(D-A −200K·D-B +450K) | 금액 명시 | **부호 유지·금액 크기는 CONFIRM**(3,500/5,500이 100매 묶음 총액이면 단위가 −2K·+4.5K) | ⚠️ DEF-PE-05가 이미 prc_typ 장당가 vs 묶음가 모호를 CONFIRM 처리 → codex 지적과 정합 | **게이트 조사**: DEF-PE-05 prc_typ 심의와 합산. 금액 규모는 단가의미 확정 후 재계산 |

---

## 3. codex 신규 발굴 (확인 필요 후보 — hypothesis·채택 금지)

| # | codex 신규 | 내용 | 근거 실재성 | 라우팅 |
|---|------------|------|-------------|--------|
| **N1** | D-A/D-B 합성 부호 | 같은 명함 공식에 D-A(과소)+D-B(과대) 공존 시 **상품별 최종 부호는 합성 재계산 필요**(COAT 선택+양 STD 통과 시 800K vs 550K=과대) | ✅ 보드도 "어느 쪽 발화는 option→차원 주입 상태에 달림"이라 명시 → codex가 합성 시나리오로 정밀화 | **확인 필요**: 게이트 evaluate_price 재계산 시 상품별(032 등) 합성 최종가로 부호 확정. 가설 |
| **N2** | E2E 견적 돈영향 누락 | price 보드가 formula 중심 → **공식 있어도 옵션경로(별색/커팅/접지) 부재면 가산비 선택·계산 불가**한 상품(020~023·028·043~046·048) 돈영향이 price 집계에서 누락 | ⚠️ 부분 실재: 해당 상품은 basedata(인쇄옵션 MISSING)+cpq(옵션그룹 MISSING)에 이미 결함 등재. price 보드엔 미집계가 사실 | **확인 필요**: 게이트가 cross-board 돈영향 집계(basedata 별색 MISSING + cpq 옵션그룹 MISSING이 합쳐져야 E2E 견적 가산비 차단). 가설→cross-inspector 종합 |

> N1·N2 모두 **새 결함 창작이 아니라 기존 결함의 영향 재해석**(합성·cross-board). 게이트가 라이브 재계산·
> 보드 횡단 집계로 최종 판정. 라이브 검증 전 사실 채택 금지.

---

## 4. ★ 환각 경계 대조 (codex 인용 근거 실재성)

라이브 캐시(`02_basedata/_live/*.tsv`)·결함 보드로 codex 인용을 전수 대조:

| codex 인용 | 실재 여부 | 대조 출처 |
|-----------|-----------|-----------|
| PRD_000050·051·037 plate output_paper_typ NULL | ✅ 실재 | `_live/plate-sizes.tsv` (050 4행·051 1행·037 1행 전부 typ 빈값) |
| page_rules 전 상품 0행 | ✅ 실재 | `_live/page-rules.tsv` = 0행 |
| bundles 031~040 0행 | ✅ 실재 | `_live/bundles.tsv` 해당 prd_cd 부재 |
| 별색 PROC_000007 family·링크 0 | ✅ 실재 | basedata-coverage-note §2 + processes.tsv |
| 인용 prd_cd 전부(024·025·020~023·028·032·043~046·048) | ✅ 실재 | 전부 PRD_000016~051 디지털 스코프 내 |
| D-A/D-B 단가(3,500/4,500/5,500) | ✅ 실재(verbatim) | price-engine-defect-board DEF-PE-02/03 |

- **환각(근거 부재 허위 주장) = 0건.** codex는 라이브 미접속을 자기 명시했고, 추론 부분은 "추정/CONFIRM"으로
  표기. 허위 코드·없는 prd_cd·날조 치수 인용 없음.

---

## 5. 게이트 인계 (hcc-conformance-gate)

- **합의 7건(§1)** = 고신뢰. 게이트 NO-GO 사유 우선순위(별색·미바인딩·유광 0원·명함 misfire).
- **불일치 5건(§2)** = 게이트 조사 큐. 라이브 재실측 항목: X1(050/051 EXTRA vs CONFIRM)·X2(포토카드 별색
  단일판정)·X3(constraints 상품별 needed)·X4(페이지룰 needed 충돌)·X5(prc_typ 금액규모).
- **codex 신규 2건(§3)** = 확인 필요 후보. N1(D-A/D-B 합성 부호 재계산)·N2(cross-board E2E 돈영향 집계).
- 게이트는 위 큐를 라이브/권위로 최종 판정. codex 가설은 게이트 검증 전 결함 보드에 사실로 병합 금지.

---

# 배치1 — 포토북(PRD_000100~107)·캘린더(PRD_000108~112) reconcile

> **Phase 3 배치1 — hcc-codex-verifier** · 2026-06-22 · 13상품(포토북 8세트멤버 + 캘린더 5).
> codex 가용(AVAILABLE·gpt-5.5·EXIT=0). codex는 라이브 미접속 → 모든 신규/이견은 게이트가 라이브 최종 판정.
> ★[HARD] codex 주장=가설. 본 reconcile은 채택이 아니라 라우팅. 최종 GO/NO-GO=hcc-conformance-gate.

## B0. 한 줄 결론
- codex 총평="인스펙터 보드 큰 방향 타당, Q1 라벨 정정·Q4(c) 실물확인 여지." **4쟁점 전건 합의(고신뢰)·불일치 0·codex 신규 4.**
- **codex 환각=0건.** codex 인용 사실 전부 검증자 제공 사실(S1~S7) 내. 단 신규발굴 N-B2는 라이브 재실측으로 **부분 정정**.
- 가장 중요한 수렴: **Q-PB-SUPERSET 비대칭 = 진짜 결함**(N/A 아님). codex 독립으로 같은 결론 + 라벨 정밀화(ROLE_SCOPE_MISSING).

## B1. 합의 (고신뢰 — 게이트 확정 우선)

| # | 쟁점 | Claude 인스펙터 판정 | codex 판정 | 근거 실재성(라이브 재실측) | 라우팅 |
|---|------|----------------------|-----------|----------------------------|--------|
| **B-A1** | Q1 Q-PB-SUPERSET: 101~107 도수/판형/공정 0행 | MISSING(12셀)·단 N/A 재판정 CONFIRM 단서 | **[동의·라벨정정]** 비대칭=진짜 결함·N/A 아님·ROLE_SCOPE_MISSING/LOSSY_SUPERSET | ✅ 실측: 101~107 전 역할축 0행·본체 100=자재 USAGE.01/02/03 가름 BUT 공정(무광+PUR)·판형·도수 무구분 합쳐짐 확정 | **고신뢰**: MISSING 유지(N/A 기각)·라벨 정밀화→dbm-correctness-audit(역할 스코프 환원) |
| **B-A2** | Q2 GATE-1: constraint_json 컬럼 부재 | 표기 오류 의심(횡단 정정·49행) | **[동의]** 라이브 부재·제약=t_prd_product_constraints.logic·검증명세 표기오류·횡단 정정 타당 | ✅ 실측: t_prd_products 24컬럼에 constraint 없음·t_prd_product_constraints.logic 실재 | **고신뢰**: checklist target_table 49행 `t_prd_products.constraint_json` 삭제 정정(횡단·데이터결함 아님) |
| **B-A3** | Q3 DEF-PE-06 full WIRE | 공식 0행→full WIRE·디지털보다 깊음 | **[동의]** PRF_PHOTOBOOK*/PRF_CAL* 0행=공식그래프 신규·재사용 comp가 범위 축소 | ✅ 실측: t_prc_price_formulas PHOTOBOOK/CAL 0행·COMP_BIND_CAL_DESK*/WALL 단가행 충전(6·6·6·24) | **고신뢰**: engine-design-photobook/calendar §2~6 명세→dbm-price-arbiter→dbm-load-execution |
| **B-A4a** | Q4(a) 캘린더 자재 EXTRA(삼각대/링) | EXTRA(공정 오염·4건) | **[동의]** 공정축(캘린더가공/링칼라)·USAGE.07 혼입=축오염·FP 아님 | ✅ 실측: 108/109/111/112 USAGE.07에 삼각대·링+종이 혼입 확정 | **고신뢰**: dbm-axis-staged-load(자재→공정 축이동) |
| **B-A4b** | Q4(b) 112 판형 MISMATCH | 304x629 작업판→330x660 전지 | **[동의]** siz_cd=출력판형 HARD·304x629=작업사이즈·오적재·FP 아님 | ✅ 실측: 112 plate=SIZ_000292(304x629)·OUTPUT_PAPER_TYPE.03 | **고신뢰**: dbm-load-builder(SIZ_000292→SIZ_000475) |
| **B-A4d** | Q4(d) D-CAL-PAGE MISSING | 캘린더 page_rule 결함 | **[동의]** 판수=앱런타임과 불충돌·캘린더 고정페이지=본질 예외·결함 맞음·FP 아님 | ✅ domain-lens §B.0 "캘린더 페이지사양=needed=Y" 명문 | **고신뢰**: dbm-load-builder(고정페이지 코드행, min=max 해석은 Q-CAL-PAGE-SHAPE CONFIRM) |
| **B-A5** | 커버리지 빈 칸 | 52셀(13×4 cpq)·basedata 8축·price 1축 빈셀 0 | (cpq DEAD_LINK 0=vacuous clean 명시 동의·B-N3 참조) | ✅ cpq 52셀(MISSING19+N/A33) 산술 정합 | **고신뢰** |

> **B-A4d 주의**: page_rule 결함은 합의이나 **적재형태(고정 min=max vs 가변)**는 Q-CAL-PAGE-SHAPE CONFIRM(권위 단일 페이지수 표기)으로 게이트 인간확인. 결함 여부=합의, 적재값=보류.

## B2. 불일치 (게이트 조사 큐)
- **불일치 0건.** 4쟁점 전건 codex 동의. Q1만 "라벨 정정"(MISSING→ROLE_SCOPE_MISSING)이나 결함 존재 여부는 합의 — 불일치 아닌 정밀화로 분류.

## B3. codex 신규발굴 (확인 필요 후보 — hypothesis·채택 금지)

| # | codex 신규 | 내용 | 근거 실재성(라이브 재실측) | 라우팅 |
|---|------------|------|----------------------------|--------|
| **B-N1** | 역할 스코프 부재(본체 전역부착) | 핵심 결함=반제품 0행보다 **본체 100 공정2·판형11·도수2 전역부착**→표지/내지/면지 간 잘못된 조합 생성 위험 | ✅ 실재: 본체 100 공정=무광(표지)+PUR제본(면지) 혼재·역할 무구분 확정 | **확인 필요**: 게이트가 세트 역할 스코프 환원 vs 본체집약+제약가드 중 무엇이 정합인지 판정(Q-PB-SUPERSET와 합류). 가설 |
| **B-N2** | 111 링 공정 누락 후보 | 111도 링이 자재에만·공정엔 타공만 → 108/109 외 111도 링 공정 누락 | ❌ **부분 오판(정정)**: 라이브 재실측 111 공정=**타공+트윈링제본**·112=트윈링제본 등록. 링 공정 누락은 **108/109에 국한**(보드 D-CAL-CRAFT-PROCESS와 일치). codex는 검증자 제공 S4(111 "타공 보유" 불완전 기재)의 한계로 오판 | **정정 후 기각**: 111/112 링 공정 OK·자재 슬롯 잔존만 EXTRA. 108/109 링 공정 누락은 기존 보드대로 유효 |
| **B-N3** | DEAD_LINK 0=vacuous | 연결무결성 PASS로 오독 금지·CPQ 전미적재 부수상태로만 해석 | ✅ 보드도 "vacuously clean·건강 아님" 명시 → codex와 정합 | **고신뢰 노트**(불일치 아님): 게이트 보고 시 "DEAD_LINK 0 ≠ CPQ 건강" 오독방지 표현 |
| **B-N4** | 반제품 고객노출 시 dead-catalog | 101~107 active면 공식/CPQ/자식 0행=dead-catalog·숨김 내부면 N/A | ⚠️ 실재(판정 보류): 101~107 use_yn=Y·del_yn=N·SEMI_ROLE 부여(논리 active)·고객노출 여부는 product-viewer 미확인 | **확인 필요**: 게이트 gstack product-viewer로 반제품 고객노출 여부 확인 → dead-catalog vs N/A 분기. 가설 |

## B4. ★ 환각 경계 대조 (codex 인용 근거 실재성)

라이브 psql 재실측 + 결함 보드로 codex 인용 전수 대조:

| codex 인용/주장 | 실재 여부 | 대조 출처(독립 재실측) |
|----------------|-----------|------------------------|
| 101~107 역할축 0행·본체 100 집약 | ✅ 실재 | psql: 101~107 print_opt/plate/proc/mat 전부 0행·100=2/11/2/7 |
| 본체 100 자재 USAGE.01/02/03 가름·공정 무구분 | ✅ 실재 | psql: mat 7행 USAGE.01몽블랑130/.02표지5변형/.03그레이·공정=무광+PUR 혼재 |
| constraint_json 컬럼 라이브 부재 | ✅ 실재 | information_schema: t_prd_products 24컬럼·constraint 없음·t_prd_product_constraints.logic 실재 |
| PRF_PHOTOBOOK*/PRF_CAL* 공식 0행 | ✅ 실재 | psql: t_prc_price_formulas 해당 0행·재사용 COMP_BIND_CAL_* 단가행 실재 |
| 112 판형 304x629 작업사이즈 | ✅ 실재 | psql: SIZ_000292·OUTPUT_PAPER_TYPE.03·304x629 |
| 캘린더 삼각대·링 USAGE.07 자재 혼입 | ✅ 실재 | psql: 108/109/111/112 USAGE.07 삼각대·링+종이 |
| **111 링 공정 누락** | ❌ **부분오판(B-N2)** | psql: 111 공정=타공+트윈링제본·112=트윈링제본 → 링 공정 누락 108/109 국한 |

- **환각(근거 부재 허위 주장)=0건.** codex가 인용한 prd_cd·치수·컬럼·comp_cd 전부 실재. 단 **B-N2는 환각이 아닌 "검증자 제공 사실(S4)의 불완전성"에서 온 부분 오판** — 라이브 재실측으로 정정해 가설 라우팅(채택 금지) 원칙 준수. codex는 추론부를 [동의]/[CONFIRM]으로 정직 표기.

## B5. 게이트 인계 (hcc-conformance-gate)
- **합의 7건(B1)** = 고신뢰. NO-GO 사유 우선순위: ① Q-PB-SUPERSET 역할스코프(B-A1·B-N1)·② DEF-PE-06 공식 전무 차단(B-A3)·③ 112 판형(B-A4b)·④ 캘린더 자재 EXTRA(B-A4a). 횡단 정정 1건: **GATE-1 checklist target_table constraint_json 삭제(B-A2)**.
- **불일치 0건** — 게이트 조사 큐 없음(4쟁점 전건 수렴).
- **codex 신규 4건(B3)**: B-N1(역할스코프=Q-PB-SUPERSET 합류·가설)·B-N2(**정정 후 기각**: 111 링 공정 OK)·B-N3(DEAD_LINK 0 오독방지 노트)·B-N4(반제품 고객노출=product-viewer 확인 가설).
- **게이트 라이브 재실측 큐**: B-N1(세트 역할스코프 vs 본체집약+제약 정합)·B-N4(101~107 product-viewer 고객노출)·Q-CAL-PAGE-SHAPE(page_rule 고정 vs 가변 적재형태)·Q-PB-SUPERSET/Q-CAL-PLATE-112/Q-CAL-PROC-EXTRA-110(기존 CONFIRM 큐).
- codex 가설은 게이트 검증 전 결함 보드에 사실 병합 금지. B-N2는 이미 라이브로 정정(기각).

---

# 배치2 reconcile — 책자10·문구9·악세15 (34상품) · 2026-06-23

> **Phase 3 배치2 — hcc-codex-verifier.** Claude 인스펙터(3 보드) vs Codex(gpt-5.5) 독립 2차.
> codex 가용(AVAILABLE). codex 주장=가설 → 검증자가 라이브 psql 재실측으로 근거 실재성 대조(★환각 경계).
> 합의=고신뢰(게이트 빠른 확인)·불일치=게이트 조사 큐·codex 신규=확인필요 후보(라이브 검증 후 채택).

## 1. 5쟁점 행별 reconcile

| # | 쟁점 | Claude 인스펙터 | Codex | 합의/불일치 | 근거 실재성(라이브 대조) | 라우팅 |
|---|------|----------------|-------|------------|------------------------|--------|
| 1 | 094 엽서북 silent 이중합산 | DEF-PE-10: S1_20P+S2_20P 둘 다 print_opt_cd=NULL→단/양면 silent 이중합산 +11,500/장 과대. 30p orphan | **동의**. +단면뿐 아니라 **양면도 +11,000 과대**(신규B). 30p "20p값으로 매겨짐"은 추정·확실한 건 "30p 도달불가" | **합의(고신뢰)** + codex 신규B | ✅ **라이브 실증**: 094 배선=S1_20P+S2_20P(2개), 둘 다 print_opt_cd=NULL·use_dims=[siz_cd,min_qty]. S1_30P/S2_30P 단가행 실재·미배선. 양방향 wildcard 확인 | dbm-price-arbiter→dbm-load-execution |
| 2 | DEAD_LINK 5건 책자 사이즈 | B2-DL: 068/069 A5 1건·071 A5/A5세로/A4가로 3건이 del_yn=Y siz 참조 | **동의**. 활성 SIZ_000172 정상·삭제 siz만 dead 구분 동의 | **합의(고신뢰)** | ✅ **라이브 실증**: 068/069→SIZ_000170(Y)·071→SIZ_000170/253/255(전부 Y)=5 dead. SIZ_000172(N)=정상 공존 | dbm-option-mapper |
| 3 | del_yn=Y comp 합산 포함 | DEF-PE-08: pricing.py del_yn 필터 부재→삭제 JUNGCHEOL이 합산되어 069/070/071 misfire | **동의**. 반대 가설(평가 제외)을 S-CODE로 기각. 부분합 가격 판단 맞음 | **합의(고신뢰)** | ✅ **코드 실증**: pricing.py L450 TPrcFormulaComponents.filter(frm_cd)·L239 TPrcComponentPrices.filter(comp_cd) 둘 다 del_yn 필터 없음·파일 전체 del_yn 0회. JUNGCHEOL del_yn=Y 배선 확인 | dbm-price-arbiter→dbm-load-execution |
| 4 | 축귀속 false-positive 사냥 | 악세 8건·책자 3건 모두 CONFIRM(축귀속 모호) | (a) 악세 변형 materials=**결함 동의**(CONFIRM 약함·격상 가능) (b) 책자 링/커버=**CONFIRM 유지 타당**(확정 오염 단정 경계) | **부분 불일치** | ✅ 라이브 실증: 006 sizes 0·materials 8(USAGE.07, '볼체인 오렌지(3개1팩)' 등 색상변형). 071/082/088 링/커버 USAGE.05/07. **엔진/UI 슬롯 동작은 미확인**(codex 경계 정당) | (a)dbm-axis-staged-load (b)gate product-viewer 3원 |
| 5 | Q-PA-ADDON 악세 이중역할 | 악세 001/002 addon 연결+자체 SKU 양립 확인 | **동의**. 양립 가능·돈영향(양 경로 0원) 맞게 봄 | **합의(고신뢰)** | ✅ 라이브 실증: 016 addon 5행→base 001/002/283/281/282. 001/002 product_prices=0·template_prices(전체)=0. 양 경로 가격 전무 | dbm-load-execution(양 경로 가격 적재) |

## 2. 합의(고신뢰) vs 불일치(조사) 분리

### 합의 — 고신뢰(게이트 빠른 확인, NO-GO 사유 강함)
- **쟁점1 094 silent 이중합산** ✅ 라이브+코드 양면 실증. 돈크리티컬 과대(양방향). **최우선 교정 대상.**
- **쟁점2 DEAD_LINK 5건** ✅ 라이브 실증. 견적 차단 dead link 유효.
- **쟁점3 del_yn comp 합산** ✅ 코드 실증. JUNGCHEOL misfire 성립.
- **쟁점5 Q-PA-ADDON 양립** ✅ 라이브 실증. 인스펙터 판정 정확.
→ 4건은 게이트가 evaluate_price 재계산/라이브 재실측으로 NO-GO 비준 가능(고신뢰).

### 불일치 — 게이트 조사 큐
- **쟁점4(b) 책자 071/082/088 링/투명커버 materials 귀속**: 인스펙터=CONFIRM(자재오염 의심). codex=CONFIRM 유지 타당(확정 오염 단정 경계·USAGE 슬롯 동작 미확인).
  → **게이트가 product-viewer 3원 대조(엑셀↔DB↔화면)로 USAGE.05/07 슬롯이 옵션 슬롯처럼 쓰이는지 확인** 후 자재오염 vs 정당슬롯 확정. (양측 모두 "단정 금지"에 수렴 = 사실상 합의된 CONFIRM)
- **쟁점4(a) 악세 변형 축귀속**: codex가 인스펙터 CONFIRM을 "약한 표기·결함 격상 가능"으로 더 강하게 봄. 방향 일치(결함)·강도만 차이. 게이트가 sizes vs materials 정답축 확정.

## 3. Codex 신규발굴 / false-positive (★환각 경계 적용)

| 항목 | codex 주장 | 라이브 대조 결과 | 채택 판정 |
|------|-----------|----------------|----------|
| **신규B** 094 양면 선택도 +11,000 과대 | 보드는 단면(+11,500)만 강조·양면도 단면 comp 붙음 | ✅ **라이브 입증**: use_dims에 print_opt_cd 없음=양방향 wildcard. 양면 선택 시 S1(11,000)도 합산 | **채택**(인스펙터 보드 양면 케이스 보강) |
| **신규A** del_yn 필터 부재=가격엔진 공통 결함·배치2 밖 전수 스캔 필요 | S-CODE면 모든 formula_components·component_prices 논리삭제 행이 살아있는 가격 입력 | ⚠️ **부분 기각(환각 경계)**: 필터 부재는 사실. 그러나 라이브 스캔=formula_components에 배선된 del_yn=Y comp는 **전 카탈로그 단 1건**(COMP_BIND_JUNGCHEOL→PRF_BIND_SUM)뿐. 배치2가 이미 그 유일 노출 케이스를 잡음 | **가설로 라우팅**: 필터 부재=구조 위험(타당)이나 "광범위 공통 피해"는 라이브 미입증. 실 노출 1건=배치2 커버. webadmin 코드 직접수정 금지·구조개선은 별도 트랙 |
| false-positive 후보 | 071/082/088 링/커버 materials를 확정 오염으로 단정 말 것 | 쟁점4(b)와 동일·게이트 product-viewer 확정 | **CONFIRM 유지**(양측 수렴) |

**허위 주장 건수: 0.** codex가 인용한 모든 근거(S1~S5·S-CODE)는 검증자 제공 사실의 재진술이며, codex 자가 발굴(신규A/B)도
지어낸 prd_cd·치수 없음. 신규A의 "광범위 공통 결함" 강도만 라이브로 조정(1건 노출). 환각 0·과잉일반화 1건(라우팅 처리).

## 4. 게이트(K1~K8) 인계 최종 reconcile 요약

- **고신뢰 4 NO-GO 후보(게이트 비준 권장):** 094 silent 이중합산(돈크리·양방향 과대)·책자 DEAD_LINK 5건(견적 차단)·
  책자 068~071 del_yn JUNGCHEOL misfire(과소/미완성가)·악세 가격 전무(양 경로 0원). 전부 라이브/코드 실증 완료.
- **CONFIRM(NO-GO 사유 아님·인간 확인):** 책자 071/082/088 링/커버 materials 귀속(게이트 product-viewer 3원)·
  악세 변형 sizes vs materials 축귀속(방향=결함·정답축 확정 필요).
- **codex 신규 채택 1:** 094 양면 선택 +11,000 과대 → DEF-PE-10 교정범위에 양방향 명시(단면+양면 둘 다 print_opt_cd 충전).
- **codex 가설 라우팅 1:** del_yn 필터 부재 구조위험 → 실 노출 1건(배치2 커버)·코드개선은 webadmin 트랙(직접수정 금지).
- **환각 경계:** 허위 주장 0. codex 과잉일반화 1건(공통결함 범위)을 라이브 1건으로 교정. codex 미가용 폴백 불요(가용).
- 전 결함 직접 교정 금지 — dbm-* 트랙 라우팅(실 COMMIT/DDL 인간 승인).

---

# [APPEND 2026-06-23] 과대청구 타겟 스캔(OC-01~08) reconcile

> 입력 결함보드: `04_price_engine/overcharge-scan-catalog.md`·`.csv`(8건). codex 가용=AVAILABLE(gpt-5.5·high).
> ★[HARD] codex 주장=가설. 본 reconcile은 라우팅. 최종 GO/NO-GO=hcc-conformance-gate(evaluate_price 재계산).
> 검증자가 OC-04~08 라이브 사실(comp use_dims·단가·바인딩·proc_grp 토큰 부재)을 라이브 t_prc_*로 재대조 완료.

## OC. 행별 reconcile (Claude 인스펙터 ↔ codex)

| OC | prd | 항목 | Claude 인스펙터 | codex | 합의/불일치 | 근거 실재성(라이브 대조) | 라우팅 |
|----|-----|------|-----------------|-------|:-----------:|-------------------------|--------|
| OC-01 | 032 코팅명함 | NAMECARD S1/S2 print_opt_cd NULL | 과대 +4,500/100매(기존 DEF-PE-03) | 과대청구 맞음 | **합의** | ✅ S1·S2 각2행 print_opt_cd=`<NULL>` 확인 | 교정명세→dbm-load-execution(print_opt_cd 충전) |
| OC-02 | 031 프리미엄명함 | 동상 | 과대 +4,500/100매 | 과대청구 맞음 | **합의** | ✅ 동일 공식 PRF_NAMECARD_FIXED | 교정명세→dbm-load-execution |
| OC-03 | 094 엽서북 | PCB S1/S2 print_opt_cd 전117행 NULL | 과대 +11,500/장(기존 DEF-PE-10) | 과대청구 맞음 | **합의** | ✅ S1·S2 각117행 `<NULL>`·SIZ_000003 min_qty=2 | 교정명세→dbm-load-execution |
| OC-04 | 027 2단접지 | FOLD_LEAF 4 comp silent 합산 | 과대 +18,000~20,000/장(V2 신규) | 과대청구 맞음(Q1 CONFIRM) | **합의(신규 확증)** | ✅ PRF_DGP_E 바인딩·4 comp use_dims=[min_qty]·proc_cd 0행·min_qty=1 합 25,000 | 교정명세→dbm-price-arbiter(접지방식 판별차원)→dbm-load-execution |
| OC-05 | 028 미니접지 | 동상(옵션그룹 0행) | 과대청구 맞음 | **합의(신규 확증)** | ✅ 동 PRF_DGP_E | 동상 |
| OC-06 | 029 3단접지 | 동상 | 과대청구 맞음 | **합의(신규 확증)** | ✅ 동 PRF_DGP_E | 동상 |
| OC-07 | 024 포토카드 | PHOTOCARD SET+CLEAR_SET silent 합산(MATCH 정정) | 과대 +8,500/세트(V3 신규) | 과대청구 맞음(Q3 CONFIRM·정정 타당) | **합의(신규 확증+정정 합의)** | ✅ 024·025 둘 다 PRF_PHOTOCARD_FIXED·두 comp 차원 동일(SIZ_000012/20/1)·6000+8500 | 교정명세→dbm-price-arbiter(상품별 공식분리/투명 판별차원)→dbm-load-execution |
| OC-08 | 025 투명포토카드 | 동상 | 과대 +6,000/세트 | 과대청구 맞음 | **합의(신규 확증)** | ✅ 동 PRF_PHOTOCARD_FIXED | 동상 |

→ **8/8 합의(고신뢰).** codex가 신규 5건(접지카드3·포토카드2)을 명함/094와 같은 silent 이중합산 클래스로 독립 확증.
   접지카드 "4개 합산=오류 vs 의도" → **codex 독립 판정 = 오류(의도된 합산 아님·택일인데 4개 청구)**. Claude와 합의.

## OC-V2 인과 독립 확증
codex가 V2 인과("proc_grp 토큰 없음→P8-1 미분리·별 comp_cd→P3-8 미발화→P2-2 4개 included→P2-3 합산")를
계약 명제로 단계 정합 CONFIRM. 검증자 라이브 대조: FOLD_LEAF 4 comp 모두 proc_cd 충전 0행·use_dims에
proc_grp 토큰 없음 — 인과 데이터 실재. **합의(고신뢰).**

## OC-FP. false-positive 가드 reconcile
- codex Q4: clean 목록 중 proc_grp 토큰 보유분(디지털vs별색·귀돌이·오시·미싱·가변·PERF_1L·CUT_PERF·코팅)은
  **정당 분리=오적발 아님**으로 Claude와 합의. → **8건 적출 중 false-positive 오적발 0건.**
- 검증자 라이브 대조: COMP_PRINT_DIGITAL_S1(proc_grp:PROC_000001)≠SPOT_WHITE_S1(PROC_000007)·CORNER/CREASE/
  PERF_1L/VARIMG/VARTEXT/CUT_PERF_1H6 전부 proc_grp 토큰 보유·COAT GLOSSY 0행 → clean 입증. **합의.**

## OC-N. codex 신규 발굴 → 환각 경계 라우팅(★핵심)
| 신규 | codex 주장 | 라이브 대조 결과(검증자) | 판정 |
|------|-----------|--------------------------|------|
| **N-PERF** | COMP_PP_PERF_2L·3L은 proc_grp 토큰 없음 → "같은 공식 배선+단가행 겹치면" FOLD_LEAF 동형 silent 합산 위험. "PERF 통째 clean"은 과잉 일반화 | **PERF_2L·3L은 formula_components에 0행(어떤 공식에도 미배선).** 단가행은 각 10행 존재하나 orphan(미배선)이라 공동청구 불가. PERF_1L만 PRF_DGP_A/D에 배선(proc_grp 토큰 보유→clean) | **가설 기각** — silent 합산 전제(①같은 공식 ②2+comp) 미충족. **현 상태 과대청구 아님.** codex가 "확정 불가·조건부"로 정직 표기 → 환각 아님 |

→ **codex 신규발굴 1건(PERF_2L/3L)은 라이브 검증에서 기각**(미배선 orphan·공동청구 불가). 단 인스펙터의
  "PERF 통째 clean" 표현은 부정확(PERF_1L만 wired-clean·2L/3L은 orphan-no-risk) → **게이트 표현 정밀화 권고**(결함 아님).

## OC. 환각(허위 주장) 건수
- **codex 환각 = 0건.** codex 인용 사실 전부 검증자 제공 verbatim 범위 내·라이브 대조 일치. PERF_2L/3L 추정도
  "확정 불가·조건부"로 정직 표기(사실 단정 아님) → 환각 아님(properly-hedged hypothesis).

## OC. 교정명세로 넘길 최종 확증 목록(8/8 고신뢰)
1. **OC-04~06 접지카드**(027/028/029·PRF_DGP_E): 접지방식 판별차원(opt_cd vs proc_grp 택일) 신설→4 comp 분리.
   단가값 verbatim 불변. **돈크리티컬 1순위**(단가형×qty·100장 ~수십~180만원 누적 과대). → dbm-price-arbiter→dbm-load-execution.
2. **OC-07~08 포토카드**(024/025·PRF_PHOTOCARD_FIXED): 상품별 공식분리 또는 투명여부 판별차원. MATCH 오분류 정정.
   → dbm-price-arbiter→dbm-load-execution.
3. **OC-01~03 명함·엽서북**(031/032/094): print_opt_cd 충전+use_dims 등재(기존 DEF-PE-03/10 유효 이월). → dbm-load-execution.
4. (비결함·표현 정밀화) PERF_2L/3L=orphan 미배선 → 게이트 보드의 "PERF clean" 표현을 "PERF_1L wired-clean·2L/3L orphan"으로 명료화.

> ★게이트(hcc-conformance-gate) 최종 판정 권장: evaluate_price 실호출로 접지카드 25,000 합산·포토카드 14,500 합산을
> 독립 재계산해 돈영향 수치 확정. 8건은 codex+Claude 양자 합의 고신뢰이나 라이브 재계산이 최종 권위.
