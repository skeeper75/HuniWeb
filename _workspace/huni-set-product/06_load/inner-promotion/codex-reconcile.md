# 내지 반제품 승격 구조변경 — codex 독립 2차 교차검증 reconcile

생성: hsp-codex-verifier · 2026-06-25 · codex-cli **gpt-5.5 reasoning=high** `-s read-only`(session 019efe4e) 독립 호출 + Claude 라이브 SELECT 재실측(읽기전용·COMMIT/UPDATE/INSERT 0)
헬퍼: `hqv-codex-cross-verify/scripts/codex-review.sh ... high`
방법: **Claude/게이트 판정 비노출.** 엔진 코드 모델 + 권위(원자합산형 6비목) + 제안 spec 사실만 codex에 제공 → codex 독립 처분 → Claude 라이브 코드/DB 확증 → reconcile. codex 주장=가설 → 라이브 확증 전 사실 아님(환각 가드). 각 주장 사실/기각 분류.

> ★**rev1 codex 종합 판정 = NO-GO as written** ("방향성 GO·적용 NO-GO"). Claude 입력 비노출 독립 도출.
> ★**codex availability = AVAILABLE**(gpt-5.5·preflight 통과·미가용 폴백 불요).
> ★**rev1 reconcile 종합 = NO-GO 수렴** — 단, codex가 **prior hybrid reconcile이 놓친 Critical 신규 1건(이중 판수환산)**을 독립 적발. 이것이 본 패스의 핵심 산출.
>
> ★★**rev2 (보정본 재판정·2026-06-25 session 새 호출)**: load-builder가 차단 3건 보정 → codex 독립 재판정 = **VESSEL-STAGE GO**(조건부). 차단1 CLOSED·차단2 CLOSED(minor hardening)·차단3 PARTIAL(handoff 충분). **상세 = §7 rev2.**

---

## 0. 한눈 요약 (codex 10 findings × Claude 라이브 확증)

| # | codex finding | codex sev | Claude 라이브 확증 | 판정 |
|---|---|---|---|---|
| 1 | 내지 SEMI_ROLE.01 승격은 구조적 타당 | Low | pricing.py:718 본체=copies만·derive_inner_sheets=구성원 qty | **사실·합의** |
| 2 | 지금 COMMIT하면 내지=0원 구성원(PRF 미민팅) | High | pricing.py:404/422·428 source=NONE→amount=0(lenient 경고만) | **사실·합의**(spec도 §5.3서 자인) |
| 3 | "copy not move" 데이터만으론 불안전(본체 PRF 잔류=이중계상) | High | 엔진은 dims 역할 무지·comp 배선만 평가(_evaluate_formula) | **사실·합의** |
| 4 | ★**derive_inner_sheets + plt_siz_cd comp = 이중 판수환산** | **Critical** | **확증 사실** — view:1707~1709 + pricing.py:561/574 | **★codex 신규·사실** |
| 5 | A5 del_yn=Y 참조 차단(master del_yn 미필터→죽은 코드 노출) | High | 라이브 A5 del_yn=Y·_set_members_meta `_opts` master del_yn 미필터(1520) | **사실·합의** |
| 6 | hard-coded PRD_000284 + NOT EXISTS = 충돌 시 오염 | Critical | EXISTS 가드가 "그게 내지인지" 미검증·동시채번 위험 | **사실·합의**(신규 강화) |
| 7 | disp_seq +1 정상2-pass 멱등이나 부분실패 취약 | Med-High | 가드는 현상태 {073:1..076:4} 전제·부분커밋 시 재증가 | **사실·합의**(CASE 목표대입 권고) |
| 8 | 069 내지 7종 재사용 방어가능하나 완전권위 아님 | Med | 069 USAGE.01 7종 라이브 일치·072 자체 7종 목록 미명시 | **사실·부분합의**(provisional) |
| 9 | 권위 충돌 없으나 spec만으론 6비목 재구성 불가(PRF 부재) | High | 권위 6비목·spec=vessel만 | **사실·합의**(가격재구성 게이트 필요) |
| 10 | 과민팅 작으나 검색기준 약함(name-only) | Low-Med | name-search 0행이나 SEMI_ROLE.01 3상품(095/098/101) 실재·전부 set-specific | **사실·기각 보강**(over-mint 아님) |

**불일치(Claude↔codex 상이) = 0.** codex 부분동의는 전부 라이브 확증으로 수렴.

---

## 1. ★codex 신규 적발 (prior hybrid reconcile 미포착·돈 크리티컬) — 본 패스 핵심

### 1.1 [Critical·사실] finding #4 — derive_inner_sheets + plt_siz_cd comp = 이중 판수환산

- **codex 주장(가설)**: view가 내지 구성원 qty를 `derive_inner_sheets`(=copies×ceil(pages/pansu))로 이미 산출하고 `plt_siz_cd`도 selections에 주입한다. 그런데 `_evaluate_formula`는 comp의 `use_dims`에 `plt_siz_cd`가 있으면 **다시** `plate_qty(qty, pansu)=ceil(qty/pansu)`로 나눈다. 즉 `qty=총내지매수`를 넣고 기존 `COMP_PRINT_DIGITAL_S2`/`COMP_PAPER`(둘 다 plt_siz_cd use_dims)를 쓰면 **pansu로 두 번 나눠** 과소청구된다.

- **Claude 라이브 코드 확증 = 사실(환각 아님)**:
  - `price_views.py:1707` `eff_qty = pricing.derive_inner_sheets(copies, pages, pansu)` — 이미 ÷pansu 적용된 값.
  - `price_views.py:1708~1709` `if plate: sel["plt_siz_cd"] = plate` — 같은 member에 plt_siz_cd 주입.
  - `price_views.py:1725` member에 `qty=eff_qty`(=총내지매수) + `selections=sel`(plt_siz_cd 포함) 전달.
  - `pricing.py:561` `needs_plate = any("plt_siz_cd" in use_dims ...)` → `pricing.py:574~575` `if "plt_siz_cd" in non_qty: pq = plate_qty(qty, pansu)` — **qty(=총내지매수)를 pansu로 또 나눔.**
  - ∴ 내지 PRF가 plt_siz_cd-기반 comp(S2/COMP_PAPER 등 기존 comp)를 쓰면 실효 qty = `ceil( (copies×ceil(pages/pansu)) / pansu )`. 설계 §5.3 smoke의 "1,250판 × tier"는 실제 엔진서 **ceil(1250/4)=313판**으로 붕괴 → 약 1/4 과소청구.

- **★이것이 본 교차검증의 결정적 가치**: 직전 `hc072-hybrid-codex-reconcile.md`(이 구조변경의 직전 패스)는 내지 승격의 **방향**만 합의했고, 승격 후 **내지 PRF가 어떤 comp를 써야 이중나눗셈을 피하는가**는 포착하지 못했다. codex가 이번에 독립으로 `derive_inner_sheets`(view)와 `plate_qty`(formula) **두 레이어의 ÷pansu 충돌**을 적발 → 내지인쇄 과소청구가 본체통합(~1/96)을 고친 뒤에도 **새 형태(~1/4)로 재발**할 수 있음.

- **돈영향**: 🔴 내지인쇄·내지용지 약 1/pansu(국4절 4-up이면 ~1/4) 과소청구 재발 위험.
- **라우팅**: set-product PRF 트랙 [HARD] 가드. codex 권고 = 택1:
  - (a) member qty = `copies × pages`(미환산) 전달 → 기존 plate comp가 ÷pansu **1회**만.
  - (b) `derive_inner_sheets`(이미 환산) 전달할 거면 내지 전용 comp는 **plt_siz_cd를 use_dims에서 제외**(자동 plate 환산 없는 comp).
  - **본 구조변경 spec은 vessel만 만들므로 본 NO-GO 사유 자체는 아니나, vessel이 노출하는 plate_sizes(국4절)+derived qty 조합이 PRF 트랙에서 (a)/(b) 미결정 시 함정** → §3.5 핸드오프 인터페이스에 본 가드 **명문 추가 필수**.

### 1.2 [Critical·사실] finding #6 — hard-coded PRD_000284 채번 동시성/오염

- **codex 주장**: PRD_000284가 다른 세션/운영자에 의해 먼저 생성되면 product INSERT는 NOT EXISTS로 skip되나 dims/sets는 **기존(타 의미) PRD_000284에 붙는다**. `WHERE EXISTS(prd_cd='PRD_000284')` FK 가드는 "그게 내지 상품인지" 검증 안 함.
- **Claude 확증 = 사실**: apply.sql L95 `WHERE EXISTS (SELECT 1 FROM t_prd_products WHERE prd_cd='PRD_000284')`는 단순 존재만 확인. 라이브 현재 MAX=283이라 지금은 정합이나, COMMIT 시점까지 다른 적재가 284를 선점하면 오염. 채번=수동 MAX+1·트랜잭션 락 없음.
- **라우팅**: apply.sql에 ① 트랜잭션 시작 시 `MAX(prd_cd)=283` 재assert ② 기존 284 발견 시 `prd_nm='하드커버책자-내지(별도설정)' AND semi_role_cd='SEMI_ROLE.01'` exact-match 아니면 ABORT ③ advisory lock 추가. **인간 승인 COMMIT 직전 재실측 필수**.

---

## 2. 합의분 (Claude↔codex 독립 수렴·고신뢰)

### 2.1 [High·사실] finding #2/#3 — vessel-first COMMIT의 잠복 위험
- **#2**: 지금(PRF 미민팅) COMMIT하면 `evaluate_price(284)`=0(pricing.py:422~428 source=NONE). spec §5.3도 자인("PRF 미민팅 상태선 has_formula false→0"). lenient서 경고만 → **운영 quote가 0원 내지 구성원을 침묵 합산**할 위험.
- **#3**: "copy not move"는 **데이터 안전이 아니라 프로세스 약속**. 엔진은 본체 dims가 내지용인지 모르고 comp 배선만 본다. 본체 PRF에 `COMP_PRINT_DIGITAL_*`/`COMP_PAPER` 잔류 + 내지 PRF 동일 비목 = 이중계상. spec §3.5 "본체 PRF=제본-only 전제"는 DB/엔진 제약이 아님.
- **합의 라우팅**: 본 vessel COMMIT을 PRF 트랙과 **같은 릴리스 게이트로 묶거나**(권장) feature flag로 숨김. PRF 적용 게이트에 검증 SQL 필수: "072 최신 공식 comp = 제본/조립/후제본 후가공만·내지인쇄/내지용지 comp 0". spec의 "분리 승인(구조변경 먼저)"(§8)은 **0원 구성원·이중계상 잠복** 때문에 codex와 충돌 → **묶음 게이트로 정정 권고**.

### 2.2 [High·사실] finding #5 — A5 del_yn=Y 죽은 사이즈 노출
- **codex 주장 = 라이브 확증 사실**: SIZ_000170(A5) del_yn=Y(라이브 확인). `_set_members_meta._opts`(price_views.py:1515~1520)는 **product-setting 테이블 del_yn만** exclude하고 **master `t_siz_sizes.del_yn`은 미필터** → A5가 내지 사이즈 드롭다운에 죽은 코드로 노출. 역으로 master del_yn=N 필터하는 타 API는 A5를 누락.
- **라우팅**: 🟡→🔴 격상. A5가 내지 dflt 주력이므로 **A4-only 임시안도 부적절**(codex). SIZ_000170 부활(del_yn N) or 대체 active A5 확정 **전 apply 금지**. dbmap 위임. → spec CFM-INNER-A5-DEL을 **CONFIRM(🟡)→BLOCKED(🔴)** 격상.

### 2.3 [Med-High·사실] finding #7 — disp_seq +1 부분실패 비멱등
- **codex 주장 = 사실**: apply.sql L80~86 `disp_seq=disp_seq+1 WHERE disp_seq<=4 AND NOT EXISTS(284 sets)`. dryrun 2-pass는 성공경로만 증명. 만약 UPDATE 후 sets INSERT 실패 + 부분 커밋이 남으면(트랜잭션 미보장 시) 재실행 때 `disp_seq<=4`인 일부 행 재증가. 라이브 현 {073:1,074:2,075:3,076:4} 확인 → 가드 전제 성립하나 부분실패 취약.
- **라우팅**: `+1` → **목표값 대입**(`CASE sub_prd_cd WHEN 'PRD_000073' THEN 2 WHEN 'PRD_000074' THEN 3 ...`) + 현상태 정확 매칭 시에만 실행. 단일 트랜잭션 래핑 명문화(spec 주석엔 있으나 SQL 구조는 +1).

### 2.4 [Med·부분합의] finding #8 — 069 내지 7종 재사용
- **codex**: 072=하드커버무선·내지종이 "*별도설정"이라 069 sibling 재사용은 내부 납득. 7종 전부 일반 내지용지(백모/아트/스노우/앙상블/몽블랑)라 "명백히 틀린 종이" 없음. 단 072 권위가 7종 목록을 **직접 제시한 건 아님**.
- **Claude 확증**: 069 USAGE.01 7종 = `MAT_000073/077/087/095/096/104/105`(라이브 일치). 하드커버용으로 부적합 종이 없음(전부 내지 범용).
- **라우팅**: **provisional authority** 인정(NO-GO 사유 아님). 단 상품마스터/운영 UI에서 072 내지종이 목록 **별도 승인 게이트** 추가 권고(누락 가능성 잔존).

### 2.5 [Low·합의] finding #1/#9 — 승격 방향·권위 정합
- 내지 SEMI_ROLE.01 승격 자체 = 구조적 정답(pricing.py:718 본체=copies만). 권위 6비목과 충돌 없음 — 분리 모델로 정확히 1회씩 재구성 가능(내지member=내지인쇄+내지용지·표지member=표지인쇄+표지코팅+표지용지·body=제본/후가공). 단 본 spec=vessel만 → "가격재구성 GO" 게이트에서 비목별 exactly-once 검증 필요.
- ★**내지 용지비 경로 질문(spec §6 미명시) 해소**: 권위 "용지비"는 내지용지(COMP_PAPER USAGE.01)로 내지 member에 귀속. 표지용지(MAT_000246)는 표지 member로. **본 vessel이 내지에 USAGE.01 7종 등록 → 내지 용지비 경로 확보**(spec 정합). 단 §1.1 plt_siz_cd 이중나눗셈 함정이 COMP_PAPER에도 적용됨 주의.

---

## 3. false-positive 가드 (codex 검증 — over-mint 아님 확증)

### 3.1 [기각·정상] finding #10 — 과민팅 검색기준 약함
- **codex 주장**: name-search `하드커버책자-내지%`=0행이면 새 product 정당하나 **name-only는 동일역할/fingerprint 부재를 완전 증명 못 함**. SEMI_ROLE.01 + sizes/page_rules/material fingerprint 검색 추가 권고.
- **Claude 라이브 확증**: SEMI_ROLE.01 상품 **3개 실재**(095 엽서북-내지·098 떡메-내지·101 포토북-내지). 그러나 **전부 set-specific**(각자 094/097/100에 1:1 바인딩·자기 dims/page/mat 보유·내지종이 단종 명시). 072 내지(7종 별도설정·A5/A4·24~300p)와 fingerprint 상이 → **재사용 부적절·신규 mint 정당**.
- **판정**: codex의 "검색 강화" 권고는 타당(다음 전파 077/082에 fingerprint 검색 적용 권장)하나, **본 건 over-mint 아님**(false-positive 가드 통과). PRD_000284 신규는 올바른 granularity.

### 3.2 [기각] 제본 false-positive (직전 패스 계승)
- 직전 hybrid reconcile서 확정: 제본 9000×50=450,000은 책 단위 정상(과대청구 아님). 본 구조변경은 제본 미변경 → 영향 없음.

---

## 4. CFM / BLOCKED 보드 (reconcile 후·실무진 보고)

| ID | 항목 | reconcile 상태 | 돈영향 | 라우팅 |
|---|---|---|---|---|
| **CFM-INNER-DBLPANSU**(★codex 신규 #4) | derive_inner_sheets + plt_siz_cd comp = 이중 판수환산 | 🔴 Critical·확증 | 내지인쇄/용지 ~1/4 재과소 위험 | set-product PRF 트랙 [HARD] 가드(qty=copies×pages or plt_siz_cd-free 내지 comp)·§3.5 핸드오프 명문 추가 |
| **CFM-INNER-A5-DEL** | A5 SIZ_000170 del_yn=Y 죽은 사이즈 | 🔴 격상(spec 🟡→codex#5) | 내지 A5 선택 불가/죽은코드 노출 | A5 부활 or 대체 active A5 **전 apply 금지**(dbmap·A4-only 부적절) |
| **CFM-CHAEBEON-RACE**(★codex 신규 #6) | hard-coded 284 + NOT EXISTS 오염 | 🔴 강화 | 타의미 284에 dims/sets 오부착 | COMMIT 직전 MAX재assert + exact-match abort + advisory lock |
| **CFM-VESSEL-ZERO**(codex #2) | vessel-first COMMIT 시 내지=0원 침묵합산 | 🟡 High | 0원 구성원 합산 | PRF 트랙과 묶음 게이트 or feature flag(분리승인 정정) |
| **CFM-BODY-INNER-RESIDUAL**(codex #3 강화) | 본체 PRF 잔류 시 이중계상 | 🟡 High·프로세스약속 | 내지비 이중계상 | PRF 게이트 검증SQL(072 comp=제본/조립/후가공만) 필수 |
| **CFM-DISPSEQ-REORDER**(codex #7) | +1 부분실패 비멱등 | 🟡 Med-High | UI 표시순서 | CASE 목표값 대입 + 현상태 매칭 가드 + 단일 트랜잭션 |
| **CFM-INNER-PAPER-AUTH**(codex #8) | 069 7종=provisional(072 직접권위 아님) | 🟢 provisional | 0(전부 내지범용) | 운영 UI 072 내지종이 목록 별도 승인 게이트 |
| **CFM-INNER-6BIMOK**(codex #9) | spec=vessel만·6비목 재구성 PRF 부재 | 🟡 High | (PRF 트랙) | "가격재구성 GO" 게이트 비목별 exactly-once 검증 |
| CFM-INNER-WORKSIZ(spec 계승) | 내지 작업siz 단면/양면 분기 | 🟡 CONFIRM | pansu 정합 | set-product pansu siz 분기 명문 |
| CFM-COVER-QTY(직전 패스 계승) | 표지 qty=copies 확장 | 🟡 본 범위 밖 | 표지 ~1/50 | 뷰/위젯 조립 계약 |

---

## 5. 종합 판정 (codex 독립 + Claude reconcile)

- **codex 독립 = NO-GO as written**(방향성 GO·적용 NO-GO). Claude 라이브 확증 = **NO-GO 수렴**. **불일치 0.**
- **본 vessel spec을 그대로 COMMIT 불가 — 적용 차단 사유(reconciled residuals)**:
  1. 🔴 **CFM-INNER-A5-DEL**(codex#5·라이브 A5 del_yn=Y 확증) — A5 상태 정리 전 apply 금지.
  2. 🔴 **CFM-CHAEBEON-RACE**(codex#6) — 284 채번 락/exact-match assert 보강 전 COMMIT 금지.
  3. 🔴 **CFM-INNER-DBLPANSU**(codex#4·★신규·view+formula 두 레이어 ÷pansu 확증) — 본 vessel이 노출하는 국4절 plate + derived qty가 PRF 트랙서 이중나눗셈 함정 → §3.5 핸드오프에 가드 명문 추가 전 vessel 무의미(돈결함 재발).
- **vessel 자체 구조(승격 방향·069 자재·국4절 판형·6비목 정합)는 GO 방향** — codex·Claude·권위 3자 정합. 차단은 전부 **적용 안전(soft-delete·채번·이중나눗셈)** 사유.
- **set-designer/PRF 트랙 보정 라우팅**:
  - §3.5 핸드오프 인터페이스에 **CFM-INNER-DBLPANSU 가드**(qty 환산 정책 택1·plt_siz_cd 내지 comp 정책) 명문화.
  - apply.sql: disp_seq CASE 목표대입 + 284 exact-match abort + MAX재assert.
  - CFM-INNER-A5-DEL을 dbmap BLOCKED로 격상(A5 부활 선결).
  - vessel COMMIT을 PRF 트랙과 **묶음 게이트**(분리승인 정정·0원 구성원 가드).
- **게이트(S 게이트)**: 본 reconcile 큐를 라이브 evaluate_set_price 실재계산(PRF 민팅 후)으로 최종 판정. 미해소분 set-designer 보정.

> ★본 산출 = 검증/reconcile까지. 실 COMMIT/UPDATE/INSERT·내지 반제품 mint·PRF 바인딩은 인간 승인 후 dbmap/hsp-load-executor 위임. **codex 주장 전건 라이브 코드/DB 확증 거쳐 사실/기각 분류**(환각 가드·기각 0건·전건 사실 확증, finding #10만 "정상=over-mint 아님" 기각 보강).

---

## 6. 출처 (날조 0)
- codex: gpt-5.5 reasoning=high `-s read-only` session 019efe4e-0d1b · 입력=Claude/게이트 판정 비노출·엔진 모델+권위+spec 사실만. codex가 라이브 repo 파일(pricing.py·price_views.py) 직접 read 후 라인 인용.
- Claude 라이브 코드 확증(읽기전용): pricing.py:404/422/428(source NONE→0)·:551/561/564/574~575(plt_siz_cd→plate_qty ÷pansu)·:718(evaluate_set_price)·:702(derive_inner_sheets) · price_views.py:1501~1560(_set_members_meta·_opts master del_yn 미필터)·:1698~1726(derived qty + plt_siz_cd 동시 주입).
- Claude 라이브 DB 확증(2026-06-25 읽기전용 SELECT): MAX prd_cd=283·SIZ_000170(A5) del_yn=Y·SIZ_000172(A4) del_yn=N·SIZ_000499(국4절) use_yn=Y/del_yn=N·`하드커버책자-내지%`=0행·SEMI_ROLE.01 상품 3건(095/098/101 전부 set-specific)·S2 국4절 POPT_000002 53행·COMP_PAPER 국4절 MAT_000073 1행·069 USAGE.01 7종(MAT_000073/077/087/095/096/104/105)·072 sets disp_seq{073:1,074:2,075:3,076:4}.
- spec: inner-promotion-design.md·apply.sql·dryrun.sql·backup.sql·undo.sql. 직전 패스: hc072-hybrid-codex-reconcile.md(승격 방향 합의). 권위: set-price-authority.md §1.1(원자합산형 6비목).

---

## 7. ★rev2 — 보정본 재판정 (차단 3건 보정 후 codex 독립 재호출 + Claude 라이브 확증)

생성: hsp-codex-verifier rev2 · 2026-06-25 · codex-cli **gpt-5.5 reasoning=high** `-s read-only` 새 호출(보정본 4파일 직접 read) + Claude 라이브 SELECT 재실측. **codex availability = AVAILABLE.** Claude/게이트 판정 비노출.

> ★**rev2 codex 종합 = VESSEL-STAGE GO**(조건부 — "가격 PRF 미민팅·미노출·후속 PRF 게이트 필수" 전제). Claude 라이브 확증 = **GO 수렴.** 불일치 0.

### 7.0 한눈 요약 (rev1 차단 → rev2 처분 × Claude 확증)

| rev1 차단 | codex rev2 STATUS | codex 근거(file:line) | Claude 라이브 확증 | reconcile |
|---|---|---|---|---|
| 차단1 CFM-INNER-A5-DEL | **CLOSED** | apply.sql:88 정본 SIZ_000007/050·dryrun P1-e:49·size-authority:30/33/131·pricing.py:559 | **확증** — SIZ_000007 del_yn=N·SIZ_000050 del_yn=N note"책자내지"·내지 comp use_dims에 siz_cd 부재 | **합의·CLOSED** |
| 차단2 CFM-CHAEBEON-RACE | **CLOSED**(minor hardening) | apply.sql:21 advisory lock·:40 exact-match·:50 MAX재assert·:71 의미가드·:145 CASE | **확증** — 가드 구조 정합·precondition(284=0·072→284=0·MAX=283) 유효 | **합의·CLOSED + codex 신규 2건(아래)** |
| 차단3 CFM-INNER-DBLPANSU | **PARTIAL·handoff 충분** | price_views.py:1704·pricing.py:572/199·design §3.5:185(정직한 핸드오프) | **확증** — 결함 실재(view ÷pansu + formula ÷pansu)·vessel SQL로 해결불가·PRF 트랙 hard gate가 정석 | **합의·PARTIAL(그릇 단계 GO·DBLPANSU는 PRF 트랙)** |

### 7.1 차단1 CLOSED (codex·Claude 합의·확증)
- codex: 삭제 SIZ_000170 대신 정본 active SIZ_000007/050 등록(apply.sql:88)·P1-e가 마스터 del_yn=Y 참조 적발 + size set 강제(dryrun:49,57)·size-authority 근거 충분(A5 active·A4 "책자내지" 태그)·가격영향 0 sound(내지 comp use_dims에 siz_cd 부재·엔진 plt_siz_cd만 판수환산 pricing.py:559).
- **Claude 라이브 확증**: `SIZ_000007 del_yn=N use_yn=Y`·`SIZ_000050 del_yn=N note="...책자내지"`·내지 comp use_dims=`COMP_PAPER[plt_siz_cd,mat_cd]`·`S1/S2[proc_cd,plt_siz_cd,print_opt_cd,min_qty,proc_grp]`(전부 siz_cd 부재). → 가격영향 0 **이중 확증**.
- ★**codex "fn_calc_pansu live 재확인 필요"(rev2 new finding) — Claude 즉시 해소**: `fn_calc_pansu(국4절,SIZ_000007)=4`(구 SIZ_000170=4와 **동일**)·`fn_calc_pansu(국4절,SIZ_000050)=2`(구 SIZ_000172=2와 **동일**). → siz 교체가 **pansu도 불변** → 판수환산 레벨에서도 가격영향 0. codex 우려 **기각(불변 확증)**.
- ★**codex new finding(SIZ_000007 note="적용=엽서"=약점이나 leap 아님)**: Claude 동의 — 치수/작업/판걸이 메타 정합·A4=책자내지 직접태그가 강근거. note는 1차 용도 라벨일 뿐(size-authority §3.1 정합). **NO-GO 사유 아님·provisional 보강 권고**.

### 7.2 차단2 CLOSED + codex 신규 2건 (minor hardening·전건 라이브 확증)
- codex: foreign 284 오부착 차단됨(advisory lock + type/role/name exact-ish guard apply.sql:40 + dims/sets 전 재가드:71 + MAX≠283 abort:50 + CASE 멱등:145).
- **★codex 신규 #A(사실)**: 채번 가드가 `use_yn='Y'/del_yn='N'` 미확인(apply.sql:40) → 동일 이름/type/role의 **soft-deleted 284**가 있으면 통과. **Claude 확증**: SQL L40~44는 prd_typ/semi_role/prd_nm만 검사·del_yn 미포함=사실. 현 precondition(284=0행·라이브 확증)에선 비도달이나 production apply 전 가드에 `del_yn='N' AND use_yn='Y'` 추가 권고. **돈영향 0·minor hardening**.
- **★codex 신규 #B(사실)**: sets INSERT의 `NOT EXISTS`가 del_yn 미확인(apply.sql:173) → soft-deleted 072→284 row 있으면 active row 미생성. **Claude 확증**: L173~175 NOT EXISTS에 del_yn 필터 없음=사실. 단 **dryrun P2(active 총행=5 assert·dryrun:73)가 이를 적발** → codex도 "dryrun이 잡는다" 인정. 현 precondition(072→284=0행·라이브 확증)에선 비도달. **돈영향 0·dryrun 가드 존재**.
- reconcile: 차단2 핵심 결함(foreign 오부착)은 **CLOSED**. codex 신규 2건은 **edge-case minor hardening**(현 라이브 상태선 비도달·dryrun 가드 존재) → vessel GO 차단 아님·production apply 전 가드 강화 권고로 라우팅.

### 7.3 차단3 PARTIAL — 핸드오프 충분(codex·Claude 합의)
- codex: 결함 자체는 코드상 실재(view:1704 eff_qty=derive_inner_sheets ÷pansu + sel[plt_siz_cd] 주입 → pricing.py:572 plate_qty 재적용 → :199 ceil(qty/pansu) **÷pansu 이중**). 현 코드 + 기존 plt_siz_cd comp PRF는 **반드시 trap**. **그러나 design §3.5가 명시 + 후보 (a)/(b)를 PRF track hard gate로 넘긴 것은 정직**·vessel SQL로 더 encode할 것 거의 없음(plate_sizes/sets는 필요한 그릇·trap 방지는 member qty 계약 or comp plt_siz 회피=PRF/호출계약 영역).
- **Claude 라이브 코드 확증**: rev1 §1.1 확증 그대로 유효(view:1707~1709·pricing.py:561/574~575). **vessel이 trap을 pre-commit하지 않음** — 국4절 plate + derived sets는 구조 그릇이고, 이중나눗셈은 PRF가 어떤 comp를 쓰느냐(plt_siz_cd 포함 여부)에서 발생 → vessel 단계 책임 아님.
- ★**codex 신규(가치 있는 지적)**: 후보 (a)(member qty=copies×pages)는 **PRF data만으로 불가**·`price_views.py` 호출 계약 변경 포함 → "후속 트랙 이름이 PRF면 이 점을 gate에 명시"해야. **Claude 동의** — DBLPANSU 해소는 순수 PRF data가 아니라 **뷰 호출 계약(member qty 산출)**까지 닿음 → §3.5 가드②에 "(a)는 price_views.py 계약 변경 필요" 명문 추가 권고.
- reconcile: DBLPANSU는 **PARTIAL(코드 실재 결함)이나 vessel 기준 핸드오프 충분**. 그릇 단계 GO·DBLPANSU는 정당히 PRF 트랙으로 핸드오프됨(codex·Claude 합의).

### 7.4 new defects / false-positive (codex rev2 — NO NEW BLOCKER·Claude 동의)
- P1-e 하드코드(SIZ_000007/050 강제)=future canonical 변경엔 false-positive이나 **본 load regression guard로는 의도된 teeth**(codex)·Claude 동의(범위 한정 가드).
- hashtext advisory collision=과잉 직렬화 리스크일 뿐·부정확 적재 아님·blocker 아님.
- S2 헤더 del_yn=Y=vessel NO-GO 아님(양면 PRICE≠0은 S2 부활[set-product] 선행·design:247 명시·Claude 라이브 확증 S2 헤더 del_yn=Y).

### 7.5 ★rev2 종합 판정 (codex 독립 + Claude reconcile)
- **codex rev2 = VESSEL-STAGE GO**(조건부). **Claude 라이브 확증 = GO 수렴. 불일치 0.**
- **차단 3건 처분**: 차단1 **CLOSED**(정본 siz·가격영향0·pansu불변 이중확증)·차단2 **CLOSED**(foreign 오부착 차단·신규 2건은 edge minor)·차단3 **PARTIAL→핸드오프 충분**(코드 실재 결함이나 vessel 책임 아님·§3.5 정직).
- **그릇 단계 codex 판정 = GO** — 단 [HARD] 조건:
  1. final apply 직전 backup + dryrun 재실행 + 284 부재/active exact-match 재확인(precondition 라이브 재실측).
  2. **PRF 트랙 전까지 072 견적 노출 금지**(vessel-zero·body-residual·DBLPANSU 미해소 상태서 가격 enablement 금지).
  3. PRF 트랙은 **NO-GO 상태로 시작**(DBLPANSU 해소[(a)뷰계약 or (b)comp plt_siz 회피]·S2 부활·본체 PRF 내지잔류 제거 통과 전 가격 enable 금지).
- **잔여(production hardening·돈영향 0)**: 채번 가드에 del_yn='N'/use_yn='Y' 추가(codex#A)·sets NOT EXISTS del_yn 고려(codex#B·dryrun P2 가드 존재)·§3.5 가드②에 "(a)=price_views.py 계약 변경" 명문.
- **게이트(S 게이트)**: 본 rev2 reconcile를 라이브 evaluate_set_price 실재계산(PRF 민팅 후)으로 최종 판정. vessel COMMIT은 인간 승인 후 dbmap/hsp-load-executor.

### 7.6 rev2 출처
- codex rev2: gpt-5.5 reasoning=high `-s read-only` 새 session · 입력=Claude/게이트 판정 비노출·보정본 4파일(design·apply·dryrun·size-authority) codex 직접 read + 엔진 코드 직접 read 후 라인 인용.
- Claude rev2 라이브 확증(2026-06-25 읽기전용 SELECT): SIZ_000007 del_yn=N/use_yn=Y·SIZ_000050 del_yn=N/note"책자내지"·내지 comp use_dims(COMP_PAPER/S1/S2 전부 siz_cd 부재·plt_siz_cd 중심)·S2 헤더 del_yn=Y·**fn_calc_pansu(국4절,SIZ_000007)=4=구SIZ_000170·(국4절,SIZ_000050)=2=구SIZ_000172**(siz 교체 pansu 불변)·precondition(284=0행·072→284 sets=0행·MAX=283) 유효.
- 보정본: apply.sql(advisory lock+exact-match+MAX assert+CASE)·dryrun.sql(P1-e)·inner-promotion-design.md §3.5 가드②·§5.3 양면(412,500 vs 313)·inner-size-authority.md(4원천 정본).
