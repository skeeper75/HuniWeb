# 072 하드커버책자 PRF_HC_MUSEON_SUM — codex 독립 2차 교차검증 reconcile

생성: hsp-codex-verifier · 2026-06-25 · codex-cli gpt-5.5 read-only(`-s read-only`·effort=high) 독립 2nd opinion + Claude 라이브 재실측 사실 제공 · **DB 미적재**(COMMIT/INSERT 0) · codex 주장=가설(라이브/권위 확증 전 사실 단정 금지)

> 방법: Claude(set-designer/게이트) 판정을 codex에 **비노출**. 핵심 사실(del_yn·단가·복합PK·proc 분포)은 본 검증자가 라이브 읽기전용 SELECT(2026-06-25)로 **재실측**해 codex에 F1~F6 사실로만 제공. codex가 독립 처분(AGREE/DISAGREE/UNSURE) → 본 문서가 reconcile.
> codex 가용성: **AVAILABLE(gpt-5.5)** — preflight PASS. 폴백 불요.
> codex 원문: `04_codex/_codex-prompt-hc072.md`(프롬프트)·tool-results b7i2ycf3e.txt(전문·135,517 tokens).

---

## 0. 한눈 요약

| 검증 초점 | Claude 설계 판정 | codex 독립 판정 | reconcile | 후속 |
|---|---|---|---|---|
| 1. 삭제 comp 대체(HC_MUSEON→SSABARI) | 타당(활성·단가 byte동일) | **AGREE(조건부)** | 🟢 **합의** | proc_cd 주입 HARD(아래 D-1) |
| 2. 내지인쇄 BLOCKED | 진성 BLOCKED(S2삭제·PK충돌·차원상이) | **AGREE** | 🟢 **합의** | 해소=mint(dbmap)·대안 없음 동의 |
| 3. 코팅 이중계상 0 | 이중계상 0(용지=순수절가·코팅 별비목) | **AGREE(현 4비목 한정)** | 🟢 **합의** | MAT_000246 후속 적재 가드(D-2) |
| 4. 면지 무료·표지 46.65 | 면지=무료·표지=아트150 46.65 | **AGREE(범위 caveat)** | 🟢 **합의** | A4/MAT_000246 범위 한정(D-3) |
| 5. 바인딩 보류 | 절대 보류(과소청구 가드) | **AGREE** | 🟢 **합의** | 보류 유지 동의 |
| 6. false-pos/neg 가드 | READY 4·BLOCKED 2·N/A 1 | **대체로 AGREE·READY 1개 과대** | 🟡 **부분합의** | COMP_PAPER READY 범위 협소화(D-3) |

- **divergence(불일치) = 0**. 전 6초점 합의(2건은 codex가 범위/조건 caveat 추가 → 설계 보정 라우팅).
- **codex 신규 적발 = 2건**(설계 본문과 충돌): ① 설계 §2.5/§5의 "SSABARI 단일 proc" 서술이 라이브 사실(3 proc)과 충돌 → Claude 재실측이 codex 손 들어줌(설계 보정). ② §0 요약 "표지용지비 READY"가 A5/국4절/MAT_000078 한정인데 무한정 READY로 읽힐 여지(false-positive 라벨).
- **돈 크리티컬 양측 1순위 일치**: 내지인쇄/내지용지 누락 상태 바인딩 = 파국적 과소청구 → 바인딩 보류 = 양측 절대 동의.

---

## 1. Claude 라이브 재실측 (codex에 제공한 F1~F6 사실 — 본 검증자 SELECT 2026-06-25)

> ★게이트 독립성: 본 검증자가 직접 SELECT한 1차 사실(설계 주장 비신뢰). 전부 설계 주장과 일치 확인.

| # | 사실 | SELECT 결과 | 설계 일치 |
|---|---|---|---|
| F1 | COMP_BIND_HC_MUSEON del_yn / SSABARI del_yn | **Y(삭제) / N(활성)** | 🟢 |
| F1 | PROC_000023 6 tier 단가 동일성 | HC_MUSEON·SSABARI **완전 byte-동일**(1=30000…1000=6000) | 🟢 |
| F1 | SSABARI proc 분포 | **PROC_000023·000024·000098 각 6행**(★multi-proc·단일 아님) | 🔴 설계 §2.5/§5 "단일 proc" 서술 **부정확** |
| F1 | SSABARI use_dims | `["proc_cd","min_qty","proc_grp:PROC_000017"]`(plt_siz 없음) | 🟢 설계 §2.2 표 일치 |
| F2 | S1/S2 del_yn | **N(활성) / Y(삭제)** | 🟢 |
| F2 | 2번째 활성 범용 디지털인쇄 comp 존재? | **부재**(활성 인쇄=S1·SPOT_WHITE_S1만·명함/아크릴=상품전용) | 🟢 |
| F3 | formula_components PK | **(frm_cd, comp_cd)**·전 공식 동일 comp 중복 **0건** | 🟢 (S1 2회 불가 입증) |
| F4 | PRF_HC% / 072 바인딩 / 구성원 바인딩 | **0행 / 0행 / 0행** | 🟢 |
| F4 | 072 sets 구성원 유형 | 073/074/075/076 **전부 PRD_TYPE.02**·면지 3색 택1(sub_prd_qty=1) | 🟢 |
| F5 | COMP_PAPER 아트150 국4절 / MAT_000246 | **46.65(1행) / 0행** | 🟢 |
| F5 | COMP_COAT_MATTE 무광 국4절 단면 | 실재(50권 tier=700원…) | 🟢 |
| F6 | 072 등록 공정 / 박 / 할인 | {유광·무광·하드커버무선·수축포장}·**박 없음** / discount **0행** | 🟢 |

---

## 2. 초점별 reconcile (상세)

### 초점1 — 삭제 comp 대체 (HC_MUSEON→SSABARI) 🟢 합의
- **codex**: AGREE(조건부). 가격 byte-동일·활성 우선이 운영상 안전. **단 proc_cd=PROC_000023 주입이 HARD 전제**(SSABARI multi-proc이라 미주입 시 wrong proc/ambiguous/0원/과소·과대청구). semantic name "싸바리바인더" 혼동 가능하나 돈 리스크는 proc_cd 가드가 핵심.
- **Claude 재실측**: SSABARI=3 proc 확인 → codex 적발 **타당**. 설계 §2.5는 "SSABARI는 하드커버무선만 보유·다중매칭 위험 낮음"이라 했으나 **부정확**. proc_cd 주입은 (위험 낮아서가 아니라) **multi-proc이라 더더욱 필수**.
- **판정**: 대체 자체 합의. **설계 §2.5/§5 서술 보정 + proc_cd 주입을 "위험 낮음"이 아닌 "HARD 필수"로 격상**(D-1).

### 초점2 — 내지인쇄 BLOCKED 🟢 합의 (과보류 아님)
- **codex**: AGREE. live 자산 재사용 조건에선 진성 BLOCKED. 근거 3중(S2 삭제·PK가 S1 2회 금지·차원/수량/페이지출력매수 상이로 1 formula_component·1평가로 동시표현 불가) 전부 동의. **"다른 해법(기존 comp 재사용)은 없다"** — 대안은 전부 "BLOCKED 해소(신규 mint COMP_PRINT_BOOK_INNER·S1 단가 verbatim 복제 / or S2 의미확인 후 복원)"이지 READY가 아님. **과보류 아님**.
- **Claude 재실측**: PK 중복 0건·2번째 활성 범용 인쇄 comp 부재 확인 → codex와 독립 동일 결론.
- **판정**: 합의. **내지인쇄 해법 대안 = codex도 신규 해법 발견 못함**(설계의 A안 COMP_PRINT_BOOK_INNER mint이 정석·dbmap 위임). 과보류 의혹 해소.

### 초점3 — 코팅 이중계상 0 🟢 합의
- **codex**: AGREE(현 4비목 설계 한정). COMP_PAPER=순수 아트150 46.65 + COMP_COAT_MATTE 별 비목 1회 → hidden double-count 없음. MAT_000246 "+무광코팅" 라벨은 혼동源이나 가격행 0이라 현재 무영향. **리스크=후속 적재에서 MAT_000246에 "코팅포함 단가"를 넣고 COMP_COAT_MATTE도 유지하면 이중계상** → 46.65 복제 시 "순수 용지단가" note/검증 가드 필요(설계 §3 규칙2와 일치).
- **Claude**: 설계 §3 4증거(E1~E4)·MAT_000246 0행 실측 → codex의 "숨은 이중계상 없음" 동의. codex가 발견한 후속 리스크는 설계가 이미 §3 규칙2(note="순수 용지단가·코팅 미포함")로 가드.
- **판정**: 합의. **숨은 이중계상 0 — codex도 발견 못함**. 후속 MAT_000246 적재 시 코팅포함 단가 금지 가드 명문 유지(D-2).

### 초점4 — 면지 무료·표지 46.65 🟢 합의(범위 caveat)
- **codex**: AGREE. 면지 무료=잘 grounded(6비목에 면지 없음·074/075/076 무지 택1·멤버 바인딩 0). 표지 46.65도 A5/국4절/SIZ_000499+아트150 기준 타당. **caveat**: ① MAT_000246 selection 들어오면 가격행 0이라 용지비 누락 위험 ② A4/3절 SIZ_000475 단가 비면 A4 표지 용지비 미해결 ③ 손지+5장은 DB단가행이 아닌 앱 수량산식 가드.
- **Claude**: 설계 §4·lining-derivation 3중정합·cover-paper-derivation과 일치. caveat 3건은 설계가 CFM-COVER-MAT/A4PLT/SONJI로 이미 분리한 잔여 CONFIRM과 동일.
- **판정**: 합의. codex caveat = 설계 기존 CONFIRM과 수렴.

### 초점5 — 바인딩 보류 🟢 합의 (양측 1순위 돈 리스크)
- **codex**: AGREE. 내지인쇄+내지용지=책자 큰 금액축. 누락 채 바인딩하면 "부분 가격"이 실판매가로 활성=명백한 과소청구. PRF 1행+fc 4행 무바인딩 load는 inert라 가능하나 product binding은 내지 해소 후에만 OPEN.
- **Claude**: 설계 §6.1 "절대 보류 [HARD]"·apply.sql 바인딩 주석처리와 동일.
- **판정**: 합의. **바인딩 보류 = 양측 절대 동의**(과소청구 가드). 본 검증자도 동의.

### 초점6 — false-positive/negative 가드 🟡 부분합의 (READY 1개 라벨 과대)
- **codex**: 대체로 AGREE. 4 READY 중 "배선 자체 BLOCKED"인 것 0. **단 COMP_PAPER는 "전체 072 변형 READY"가 아니라 A5/국4절+MAT_000078 한정 READY** — MAT_000246/A4·3절까지 묶어 "표지용지비 READY"라 부르면 **false-positive**. BLOCKED쪽: inner-print/inner-paper 묶음 BLOCKED 맞음, foil N/A 맞음(단 "권위에 후가공비 있으니 영구 미지원"이 아니라 현 상품옵션 기준 N/A).
- **Claude**: 설계 §0 요약은 표지용지비를 무조건 READY처럼 표기(§4·§7에서 A4/MAT_000246 분리하나 §0 라벨이 협소화 미흡). codex 지적 **타당** → §0 READY 라벨을 "표지용지비(A5/국4절/MAT_000078) READY"로 협소화(D-3).
- **판정**: 부분합의. **codex 신규 적발(false-positive 라벨) 수용** — 배선은 옳으나 READY 범위 표기를 협소화.

---

## 3. codex 신규 적발 (설계 본문과 충돌·Claude 재실측이 판정)

| ID | codex 적발 | Claude 라이브 재실측 | 판정 | 라우팅 |
|---|---|---|---|---|
| **NF-1** | 설계 §2.5/§5 "SSABARI 단일 proc·다중매칭 위험 낮음" 서술이 사실과 충돌(SSABARI=3 proc) | SELECT: SSABARI proc={PROC_000023,000024,000098} 각 6행 = **multi-proc 확정** | 🔴 **설계 서술 부정확** | set-designer 보정: §2.5/§5 서술 정정 + proc_cd 주입 "HARD 필수"로 격상(돈 영향=주입 가드 동일, 배선 불변) |
| **NF-2** | §0 요약 "표지용지비 READY" 라벨이 A5/국4절/MAT_000078 한정인데 무한정으로 읽힐 여지 | MAT_000246=0행·A4 3절(SIZ_000475) 아트150 단가 미확인 | 🟡 **라벨 과대(false-positive)** | set-designer 보정: §0 READY를 "표지용지비(A5/국4절/MAT_000078) READY"로 협소화. A4/MAT_000246=CFM-COVER-A4PLT/MAT 잔류 |

> ★두 적발 모두 **배선(apply.sql 4 formula_components)·단가·BLOCKED 판정에는 영향 없음**. 서술/라벨 정확성 보정이며 돈 리스크는 proc_cd 주입 가드(이미 설계 §2.5에 존재·격상만)로 커버.

---

## 4. 돈 크리티컬 리스크 랭킹 (codex + Claude 합의)

| 순위 | 리스크 | 출처 | 가드 상태 |
|---|---|---|---|
| 1 | 내지인쇄/내지용지 누락 상태 바인딩 = 파국적 과소청구 | 양측 1순위 | 🟢 가드됨(바인딩 주석·§6.1 HARD·load-executor 미실행) |
| 2 | proc_cd / 표지 plt_siz / pansu 주입 오류(SSABARI multi-proc 포함) = wrong row/0원/과소·과대 | 양측 | 🟡 CPQ option→차원 주입 정합 선결(CFM-HC-INJECT·W7)·NF-1 격상 |
| 3 | A4 3절(SIZ_000475) + MAT_000246 용지비 0원 매칭 = 누락 과소청구 | codex+설계 | 🟡 CFM-COVER-A4PLT/MAT(dbmap·A5 적재는 무관) |
| 4 | SSABARI multi-proc semantic 혼동 | codex(NF-1) | 🟡 proc_cd 주입 가드로 커버·서술 보정 |
| 5 | MAT_000246 후속 적재 시 코팅포함 단가 = 이중계상 | codex(Q3) | 🟢 설계 §3 규칙2 가드(순수 용지단가 note) |

---

## 5. 게이트 라우팅 (S 게이트 큐)

- 🟢 **load 조건부 GO 후보**(무바인딩): PRF_HC_MUSEON_SUM 1행 + formula_components 4행(READY). 양측 합의·divergence 0·neg/pos 가드 통과. **실 COMMIT은 S게이트 GO + 인간 승인 후 hsp-load-executor**.
- 🔴 **바인딩 = 절대 보류 유지**(내지인쇄+내지용지 해소 전). 양측 절대 동의.
- 📋 **set-designer 보정 라우팅(돈 영향 0·서술/라벨)**: NF-1(SSABARI multi-proc 서술 정정+proc_cd 주입 HARD 격상)·NF-2(§0 READY 라벨 협소화).
- 📋 **dbmap 위임(BLOCKED 해소)**: COMP_PRINT_BOOK_INNER mint(S1 verbatim 복제)·내지 용지 평가슬롯·MAT_000246 단가행(A5 국4절 46.65 복제·코팅포함 금지)·A4 3절 아트150 절가.
- 📋 **실무진 CFM**(권위 1줄 부재·돈 영향=선택): CFM-HC-BIND-DELYN(SSABARI 정명 vs HC_MUSEON 복원·단가0)·CFM-COVER-MAT/A4PLT/SONJI·CFM-COVER-COAT(해소·형식컨펌).

---

## 6. 결론 (본 검증자)

- **codex 가용**(gpt-5.5·high·read-only). 미가용 폴백 불요.
- **합의 6/6·불일치 0**. codex가 6초점 전부 AGREE(2건 조건/범위 caveat). 독립 2차 시각이 Claude 핵심 판정(삭제 comp 대체·내지 진성 BLOCKED·이중계상 0·바인딩 보류)을 **독립 확증**.
- **codex 신규 적발 2건**(NF-1 SSABARI 단일 proc 서술 오류·NF-2 READY 라벨 과대) — 둘 다 본 검증자 라이브 재실측이 codex 편. **배선/단가/판정 불변·서술/라벨 보정**.
- **내지인쇄 해법 대안**: codex도 신규 해법 발견 못함 → 설계 A안(COMP_PRINT_BOOK_INNER mint) 정석. 과보류 아님(양측 동의).
- **바인딩 보류 동의**: 양측 1순위 돈 리스크·절대 보류 유지.
- codex 주장은 가설로 처리했고, 핵심 사실은 본 검증자가 라이브로 재실측해 확증함. **불일치 없으므로 추가 라이브 재실측 요구 항목 없음**(S게이트가 evaluate_set_price 재계산·DRY-RUN으로 최종 판정).
