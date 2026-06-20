# codex-reconcile-booklet.md — codex(high) ↔ hpe-validator reconcile (책자·반제품 세트·다부품 합산형)

> **Phase 5.5 reconcile.** hpe-validator E1~E7 **GO**(`04_validation/gate-verdict-booklet.md`·라이브 SELECT 다수+pricing.py 코드 직접 검증+골든 GC-BK1~6 6/6 재계산) ↔ codex(gpt-5.5·**effort high**) 독립 판정(`codex-output-booklet.md`·설계 5파일+엔진 계약 사실만·라이브 미조회).
> **★독립성 입증[HARD]**: codex에 validator verdict·E1~E7 결론·GO/NO-GO **비전송**(프롬프트=`_codex-prompt-booklet.md`·설계 증거+엔진 계약 사실만·정답 미제공). 두 판정 독립 도출 후 대조.
> **★[HARD] codex 주장=가설**: 라이브/권위 검증 전 사실 아님(`미검증`·환각 경계). 충돌 시 **라이브 우선**·codex에 맞춰 자동 flip 금지. codex=설계문서+계약 추론·validator=라이브 SELECT+pricing.py 코드+골든 재계산(권위 더 높음).
> codex 가용성: **가용**(codex-cli 0.140.0·gpt-5.5·`--sandbox read-only --skip-git-repo-check -c model_reasoning_effort=high` stdin foreground·EXIT 0·CODEX_READY 핑 확인). "Claude 단독" 폴백 아님.

---

## 1. 핵심 독립 결론 합의 보드 (사용자 지정 핵심 질문 — 두갈래·제본비단일항vs합산·.01단가형·삭제comp오염·골든·이중수량·신규축)

| # | 명제 | hpe-validator (라이브 실측·코드·골든) | codex high (설계+계약 추론·`미검증`) | 합의? | 신뢰도 |
|---|------|--------------------------------------|--------------------------------------|-------|--------|
| **Q1** | **두 갈래 구조((A)단일 prd 제본비형 + (B)세트 부모 부품 합산형) 분리 타당·한 공식 강제 금지** | E2/E3 PASS — 068~071 sets 분해 0(단일·시트 컬럼)·072/077/082/088/100 sub_prd 분해(Q10 SELECT)·가격 합산 메커니즘 동형이라 공식 공유 가능(proc_cd 분기)·도메인 현실 존중 | **GO** — "(A)단일·(B)세트 부모 분리 타당·다만 엔진 관점에선 둘 다 FORMULA component Σ일 뿐·완전히 다른 클래스로 나눌 필요 없음·공식 공유 가능하되 comp 집합·선택 차원 충돌 없어야" | **✅ 완전 합의** | **고신뢰** (codex가 "구조는 두 갈래·엔진은 단일 Σ"를 echo 아닌 독립 추론·validator E3 "공식 공유 가능·세트 그릇 사용 여부가 결정적 차이"와 동일) |
| **Q2** | **책자 가격 = 부품 합산(제본비+표지+내지+인쇄) 방향 정답·현 라이브 제본비 단일항은 미완·단 단가 소스 미확정** | E1/E2 PASS·DB-2 `확신도:중` — 표지/내지 comp 0행(Q7 COUNT=0) confirm·부품 합산 방향(B02 "표지비 따로"·상품마스터 사양)·단가 소스 시트 매핑은 Q-BK-COVER 재대조 후 확정 | **CONDITIONAL** — "현 라이브=제본비 단일항 맞음(comp 0행)·완성가는 표지+내지+인쇄+제본 합산 방향 맞음·**단 표지/내지 단가가 디지털 종이비/인쇄비 시트에서 무손실 매핑되는지 미입증→방향 GO·적용 Q-BK-COVER 전 CONDITIONAL**" | **✅ 완전 합의** | **고신뢰** (codex가 "방향 GO·적용 CONDITIONAL"을 echo 아닌 독립 구분·validator의 DB-2 `확신도:중`·Q-BK-COVER 컨펌큐와 정확히 동일) |
| **Q3** | **제본비 .01 단가형 = 부당(권당) 단가가 옳다·÷min_qty 교정 불요·디지털 .01→.02 전이 금지** | E4/E6 PASS — PUR 5000→3000→1500 단조하락 SELECT 실측=묶음총액 불가→부당가 확정·.01 `unit×qty` 코드 검증·GC-BK3 재계산 일치 | **GO** — "묶음총액 아니라 권당 단가"·**PUR 1000부 1500×1000=1,500,000·무선 100부 500×100=50,000·중철 교정후 4부 2000×4=8,000 직접 산술**·"min_qty↑→단가↓ 패턴은 묶음총액이면 불가능→.01 unit×qty 정당·디지털 명함 .01→.02 결함 전이 금지" | **✅ 완전 합의** | **고신뢰** (codex가 단가 사다리 의미를 echo 아닌 독립 산술 재현·디지털 전이 금지까지 독립 도출=강한 교차검증) |
| **Q4** | **삭제(del_yn='Y') comp 참조 + 중철 단가행 트윈링값 오염 = 결함 확정·과청구 50%** | E1/E4/E6/E7 PASS — TWINRING/018=트윈링/021 byte-동일 SELECT 독립 확인·JUNGCHEOL/018=B01 정답 보유·del_yn 필터 부재 코드 grep 확정(misfire/0원 가설 결판)·corrupt 12,000 vs corrected 8,000 양면 | **GO·결함 확정** — "두 결함 모두 돈크리티컬"·**중철 4부 오염 3,000×4=12,000 vs 정답 2,000×4=8,000·과청구 4,000=50% 직접 산술**·"del_yn 미필터 시 삭제 comp 계산 유입 or 필터 시 comp 0개·어느 쪽도 정상 아님"·**★"산출물 '4상품 전부 중철값 misfire' 표현은 엔진 계약상 확정적이지 않음·proc_cd 정확 주입 시 무선/PUR/트윈링은 PROC_000018 행과 불일치 no_match→실제는 중철만 우연·나머지 no_match/0원에 가까움" 독립 정정(결함 결론 동일)** | **✅ 완전 합의** | **고신뢰** (codex가 과청구 50%·결함 유형을 echo 아닌 독립 산술·★misfire 양상을 "no_match/0원"으로 독립 정정한 것은 validator E4 정밀화[정정-1 LOW]와 정확히 같은 발견=echo 불가 고신뢰) |
| **Q5** | **골든 GC-BK1~6 허용오차 0 재현·corrupt/corrected 양면·GC-BK7/8은 구조검증(부품 단가 미확정)** | E6 PASS — pricing.py 충실 재구현·라이브 단가행 verbatim·GC-BK1~6 6/6 일치·GC-BK7/8 구조 정직 보류 | **GO(BK1~6)·CONDITIONAL(BK7~8)** — **GC-BK1~6 6건 전부 직접 산술 재현 일치(8,000·50,000·1,500,000·20,000·80,000·800,000·corrupt 12,000)**·"GC-BK7/8은 구조 골든이지 가격 골든 아님·표지/내지 단가 소스+페이지 곱 확정돼야 완성가 골든 승격" | **✅ 완전 합의** | **고신뢰** (codex 독립 재계산 6/6 일치·GC-BK7/8 구조 전용 한계를 echo 아닌 독립 식별·validator E6과 동일) |
| **Q6** | **이중수량(부수×페이지)·페이지=입력 차원·책등=앱 파생·DB 미저장** | E5 PASS·DB-9 — 제본비=부수만·내지비=부수×페이지(앱 2중 곱)·page_rules 입력 차원·책등 앱 파생·sub_prd 면지 합산 금지 | **CONDITIONAL** — "개념 맞음(제본비 부수만·내지비 부수×페이지·페이지=page_rules 입력·책등 앱 파생·seneca/jobqty DB 미저장 타당)"·**★"단 엔진 계약상 component subtotal은 동일 qty를 쓰는 것으로 보임→한 FORMULA에서 제본비=qty·내지비=qty×pages를 동시에 쓰려면 앱 레이어가 component별 effective quantity를 만들거나 내지단가를 페이지 반영 후 넘기는 별도 계약 필요·이 계약 미명시면 완성가 NO-GO 위험" 독립 발굴** | **✅ 합의(codex가 더 깊게)** | **고신뢰** (★codex가 "앱계산"을 **엔진 계약 레벨 component별 effective qty 미명시 위험**으로 격상=validator E5/DB-9가 "앱 곱"으로만 명시한 것의 구현 계약 공백을 외부 모델이 독립 발굴·echo 불가·설계 강화 신호·DV-BK2) |
| **Q7** | **신규 가격축/테이블 0건·기존 그릇으로 닫힘·흡수 overfit 아님** | E3 PASS — C-BK1~6 전부 후니 기존 그릇 매핑·신규 vessel 0·jobqty 2단 부결·신규 comp 가능성=표지/내지 전용 1~2건(combo_key 충돌 시·가격축 아닌 그릇)·rpmeta TP/BN distinct #18 부결 정합 | **CONDITIONAL** — "신규 테이블·WowPress 2단 작업량 불필요(GO)"·**★"단 '기존 그릇만으로 완전히 닫힌다'는 조건부·표지/내지가 동시에 다른 mat_cd/print_opt_cd를 가지는데 NON_QTY_DIMS엔 mat_cd·print_opt_cd 각 1개뿐→표지/내지 전용 comp 분리만으로도 selection 키가 하나면 부족·역할별 선택차원 부재 문제" 독립 발굴** | **✅ 합의(codex가 더 깊게)** | **고신뢰** (★codex가 validator의 "combo_key 충돌→전용 comp 분리" 가드를 **한 단계 더 깊게**=전용 comp로도 selection 키[손님 선택값]가 단일 mat_cd/print_opt_cd면 표지·내지 역할 동시 표현 불가라는 구조 공백 독립 도출·echo 불가·DV-BK3) |
| **Q8** | **추가 위험 발굴(차원 미스매치·이중계상·silent 합산·오배선·세트 가격vs구성)** | E4/E5 PASS — proc_cd 주입 선결(미주입=0원 침묵)·combo_key 충돌 가드·면지 4행 합산 금지·088 BLOCKED·표지/내지 합산 미배선 | **CONDITIONAL/일부 NO-GO 전 결함** — proc_cd 주입 필수(미주입=no_match/0원)·**★"TEMPLATE/PRODUCT_PRICE 상위 소스 있으면 FORMULA 수정 무시될 수 있음→상위 가격 소스 부재 확인 필요" 독립 발굴**·**★"required component 개념 없으면 표지/내지 no_match 시 제본비만 계산되어 저청구" 독립 발굴**·면지 3~4행 합산=이중계상(택1 필수)·088 보류 맞음·완성가는 표지/내지/면지 가격기여 확정 전 GO 불가 | **✅ 합의(codex 추가 발굴 2건)** | **고신뢰** (★codex가 ① 상위 가격소스(TEMPLATE/PRODUCT_PRICE) 부재 확인 필요 ② required component 부재→저청구 위험을 echo 아닌 독립 발굴·validator가 명시 안 한 신규 점검 포인트·DV-BK4) |

★ **8질문 전부 합의.** Q1·Q3·Q4·Q5 완전 합의(고신뢰 확정), Q2·Q5(BK7/8)·Q6·Q7·Q8은 **codex가 CONDITIONAL/추가 발굴**이나 전부 validator가 컨펌큐(Q-BK-COVER·Q-BK-PROC·Q-BK-PHOTO·Q-BK-MYUNJI)로 이미 분리했거나 **codex가 한 단계 더 깊게 본 독립 통찰**. **진짜 충돌(validator GO인데 codex 핵심 결함을 반대 결론으로 NO-GO) 0건.**

---

## 2. reconcile 매트릭스 (E게이트 ↔ codex 질문 대응)

| E게이트 | validator (라이브·코드·골든) | codex high (`미검증`) | 정합 | 해소/소유자 |
|---------|------------------------------|----------------------|------|------------|
| E1 공식 추출 충실성 | PASS (B01/B02 단가행 verbatim·표지/내지 comp 0행·G-BK-1/2 셀 재대조·날조 0) | Q3/Q5 GO (단가 사다리·골든 산술 일치·verbatim 전제 수용) | **✅ 완전 합의** | 고신뢰 확정 |
| E2 구성요소 분해 정합 | PASS (제본비 통합 comp proc_cd 종류축·세트 sub_prd 가격 비기여·시트경계 SOT 1) | Q1/Q2 GO/CONDITIONAL (두갈래 구조 타당·제본비 단일항 미완·합산 방향) | **✅ 완전 합의** | 고신뢰 확정 |
| E3 경쟁사 흡수 타당성 | PASS (신규 가격축 0·naming 유입 0·jobqty 2단 부결·두갈래 스코프 분리) | Q7 CONDITIONAL (신규 테이블/2단 불필요 GO·단 표지/내지 역할 차원 무손실성 미입증) | **✅ 합의(codex 더 깊게)** | codex의 "역할별 selection 차원 부재"=validator combo_key 충돌 가드의 심화(DV-BK3)·소유=dbm-price-arbiter Q-BK-COVER |
| E4 엔진 설계 건전성 | PASS (proc_cd NON_QTY_DIM 분기·search-before-mint·★del_yn 필터 부재 코드 확정·misfire 가설 결판) | Q4/Q8 GO/CONDITIONAL (del_yn 결함 확정·★misfire→no_match/0원 정정·★상위소스/required comp 추가 발굴) | **✅ 합의(codex 추가 발굴)** | codex misfire 정정=validator 정정-1(LOW)과 동일·상위소스/required comp는 신규 점검(DV-BK4)·소유=dbm-price-arbiter |
| E5 세트 조합 정합 | PASS (sets 25행 sub_prd_qty=1·택1·면지 합산 금지·이중수량 분리·088 BLOCKED) | Q6/Q8 CONDITIONAL (이중수량 개념 맞음·★component별 effective qty 계약 미명시 위험·면지 택1 필수·088 보류 맞음) | **✅ 합의(codex 더 깊게)** | codex의 effective qty 계약 공백=validator DB-9 "앱 곱"의 구현 계약 심화(DV-BK2)·소유=dbm-price-arbiter·designer 보강 |
| E6 골든 재현 | PASS (GC-BK1~6 6/6 허용오차 0·corrupt/corrected 양면·GC-BK7/8 구조 정직) | Q5 GO/CONDITIONAL (BK1~6 6건 직접 재계산 일치·BK7/8 구조 한계 동일 식별) | **✅ 완전 합의** | 고신뢰 확정 |
| E7 생성검증 독립성 | PASS (데이터 결함 2건 라이브 독립 재실측·del_yn 질문 코드 결판·dodge 없음) | (해당 없음·codex 자체가 독립 2nd opinion) | — | reconcile 자체가 E7 외부 보강 |

---

## 3. divergence 명세 (자동 flip 금지)

| ID | divergence | 어느 쪽이 라이브/권위 정합 | 처리 |
|----|-----------|---------------------------|------|
| **DV-BK1** | codex 종합 라벨 **"CONDITIONAL GO"** vs validator **"GO"** | **사실상 동치** | codex CONDITIONAL의 조건은 전부 ① validator가 컨펌큐(Q-BK-COVER 표지/내지 단가소스·Q-BK-PROC proc_cd 주입·Q-BK-PHOTO 포토북·Q-BK-MYUNJI 면지)로 이미 분리하고 "실 적용은 인간 승인 후 dbmap 위임"으로 GO 라벨에 내장한 항목이거나 ② DB 미적재 상태(W3 표지/내지 합산 배선·W4 세트 부모 바인딩 미적재)를 "현재 미완·확정 후 GO"로 정직 표기한 것. **진짜 충돌 아님**·codex "보완 필요"=validator "컨펌큐 동반 GO". 라이브 우선·flip 불요. 문구 reconcile DV-ST2 동형 |
| **DV-BK2** | ★**codex가 "component subtotal은 동일 qty 사용→제본비(qty)와 내지비(qty×pages)를 한 FORMULA에서 동시 표현하려면 component별 effective quantity 계약 필요·미명시면 완성가 NO-GO 위험"을 독립 발굴** — validator E5/DB-9는 "내지비=부수×페이지 앱 곱"으로 **방향만** 명시·엔진 계약 레벨 구현 공백은 명시 안 함 | **둘 다 일치(divergence 아님)·codex가 구현 계약 공백을 격상** | ★echo 불가·고신뢰 신호. codex가 "앱 계산"이라는 설계 의도를 **엔진 evaluate_price 계약이 component별 다른 qty를 어떻게 받는가(effective qty 전처리 or 내지단가 페이지 반영 후 전달)**라는 구체 계약 미명시 위험으로 구체화. 차단 아님(완성가는 어차피 Q-BK-COVER 후 적재·DB 미적재)·**designer 폐루프 보강 권고**(완성가 배선 시 component별 qty 계약 명문화) |
| **DV-BK3** | ★**codex가 "표지/내지 전용 comp 분리만으로도 selection 키(손님 mat_cd/print_opt_cd 선택값)가 단일이면 표지·내지 역할 동시 표현 부족·역할별 선택차원 부재"를 독립 발굴** — validator E4는 "COMP_PAPER 2회 배선 combo_key 충돌→전용 comp 분리" 폴백까지·전용 comp 후 selection 키 단일성 문제는 명시 안 함 | **둘 다 일치(divergence 아님)·codex가 한 단계 더 깊게** | ★echo 불가·고신뢰 신호. NON_QTY_DIMS에 mat_cd·print_opt_cd 각 1개뿐 → 한 주문에서 표지 mat_cd≠내지 mat_cd를 동시에 selections에 실어야 하는데 단일 키면 불가. codex가 "전용 comp 신설로도 부족할 수 있음·역할별 표현을 opt_cd/sub_prd/별도 평가호출/앱 전처리로 무손실 가능한지 확인 필요"로 심화. 차단 아님(완성가 DB 미적재·Q-BK-COVER 소유)·**dbm-price-arbiter 심의에 "표지/내지 역할 selection 분리 메커니즘" 추가 권고** |
| **DV-BK4** | ★**codex가 ① "TEMPLATE/PRODUCT_PRICE 상위 소스 있으면 FORMULA 수정 무시될 수 있음→상위 가격소스 부재 확인 필요" ② "required component 개념 없으면 표지/내지 no_match 시 제본비만 계산되어 저청구"를 독립 발굴** — validator는 책자=FORMULA(직접단가 0행·Q13)는 확인했으나 required component(부분 매칭 시 저청구) 위험은 명시 안 함 | **codex 발굴이 신규 점검·validator 미명시** | ★echo 불가·고신뢰 신호. ① 상위 소스: validator가 직접단가 0행 SELECT(Q13)로 일부 확인했으나 codex가 "책자 상품별 TEMPLATE 부재"까지 명시 점검 권고 → **dbm-price-arbiter 라우팅에 추가**. ② required component: 후니 엔진에 "필수 구성요소" 개념 부재 시 표지/내지 comp가 no_match여도 제본비만 합산되어 **저청구**(과청구의 반대 방향) → 완성가 배선 시 **designer/arbiter가 표지/내지 comp no_match를 0원 침묵으로 둘지 견적 거부할지 정책 결정 필요**. 차단 아님(완성가 DB 미적재)·신규 컨펌 큐 |
| **DV-BK5** | ★**codex가 "산출물 '4상품 전부 중철값 misfire' 표현은 확정적이지 않음·proc_cd 정확 주입 시 무선/PUR/트윈링은 PROC_000018 행과 불일치 no_match→실제는 중철만 우연·나머지 no_match/0원에 가까움"을 독립 정정** — validator도 정정-1(LOW)로 동일 정밀화 | **둘 다 일치(divergence 아님)·독립 동일 발견** | ★echo 불가·최고신뢰 신호. codex와 validator가 **각자 독립으로** 설계 §2.1/DB-4의 "misfire/0원" 가설을 "proc_cd 주입 종속·no_match/0원"으로 정정 → 두 모델이 같은 결함(설계의 misfire 양상 과장)을 같은 방향으로 독립 정정. 결함 결론(재배선 필수·과청구 50%)은 양쪽 모두 불변. **designer 폐루프 정정-1로 흡수**(가격 무영향·문서 정밀화) |

★ **진짜 충돌(validator GO인데 codex가 핵심 결함을 반대 결론으로 차단) 0건.** codex의 CONDITIONAL/추가 발굴은 전부 ① validator가 컨펌큐로 이미 분리한 항목(DV-BK1)이거나 ② **codex가 echo 아닌 독립으로 한 단계 더 깊게 본 통찰**(DV-BK2 effective qty 계약·DV-BK3 역할별 selection 차원·DV-BK4 상위소스/required comp·DV-BK5 misfire 정정). **자동 flip 없음·라이브 우선 유지.** codex 독립 발견이 다수(5건)=고신뢰 신호 + 설계 보강 단서.

---

## 4. codex 독립 발견(echo 아님) — 고신뢰 신호 + 설계 보강 기록

reconcile의 핵심: codex가 validator verdict를 못 본 채 **echo 아닌 독립 도출**한 것:

1. **★component별 effective quantity 엔진 계약 공백(DV-BK2·고신뢰·설계 보강)**: codex가 "후니 component subtotal은 동일 qty를 쓰는 것으로 보임 → 한 FORMULA에서 제본비=qty·내지비=qty×pages를 동시에 표현하려면 앱이 component별 effective quantity를 만들거나 내지단가를 페이지 반영 후 전달하는 별도 계약 필요·이 계약 미명시면 완성가 NO-GO 위험"을 독립 발굴. validator/designer는 "내지비=부수×페이지 앱 곱"으로 **방향만** 명시했고, 엔진이 component마다 다른 곱수를 어떻게 받는가의 구현 계약은 명시 안 함. **다부품 합산 완성가 배선 시 가장 위험한 미명시 지점**을 외부 모델이 구체화.
2. **★표지/내지 역할별 selection 차원 부재(DV-BK3·고신뢰·설계 보강)**: codex가 "NON_QTY_DIMS에 mat_cd·print_opt_cd 각 1개뿐 → 표지 mat_cd≠내지 mat_cd를 한 주문에서 동시 표현 불가·COMP_PAPER 2회 배선 충돌만이 아니라 역할별 선택차원 부재 문제·전용 comp 분리만으로도 selection 키가 하나면 부족"을 독립 발굴. validator의 combo_key 충돌 가드를 **한 단계 더 깊게**(comp 분리 후에도 손님 선택값 차원이 역할별로 갈려야 함) 본 것.
3. **★상위 가격소스(TEMPLATE/PRODUCT_PRICE) 무시 위험 + required component 부재 저청구(DV-BK4·고신뢰·신규 점검)**: codex가 ① "상위 소스 있으면 FORMULA 수정 무시" ② "required component 없으면 표지/내지 no_match 시 제본비만 계산되어 저청구"를 독립 발굴 = **과청구의 반대 방향(저청구) 위험**을 외부 모델이 발굴. validator가 명시 안 한 신규 점검 포인트.
4. **misfire 양상 독립 정정(DV-BK5·최고신뢰)**: codex가 "4상품 전부 misfire 표현은 확정적이지 않음·proc_cd 주입 시 non-중철은 no_match/0원"을 독립 정정 = validator 정정-1(LOW)과 **각자 독립으로 같은 방향** 도출. 결함 결론(재배선 필수·과청구 50%)은 양쪽 불변.
5. **단가 사다리·골든 산술 독립 재현(Q3·Q5·고신뢰)**: codex가 PUR 5000→1500 단조하락=묶음총액 불가→권당가, GC-BK1~6 6건(8,000·50,000·1,500,000·20,000·80,000·800,000·corrupt 12,000)을 **직접 산술 재계산**해 일치 = validator 라이브 SELECT·골든 재계산과 같은 결론을 설계문서만으로 독립 도출.

이 5건은 두 모델이 **같은 증거로 같은 결론**(또는 codex가 더 깊은 통찰)에 도달한 것으로, 한 모델이 합리화할 설계 오류를 외부 모델이 독립 확인/보강한 강한 교차검증 신호. 특히 DV-BK2/BK3/BK4는 **완성가(부품 합산) 배선 단계에서 designer가 닫아야 할 구현 계약 공백**을 외부 모델이 선제 발굴한 설계 강화.

---

## 5. 종합 — 책자 GO가 codex high로도 지지되는가

**지지된다(고신뢰·divergence 0·진짜 충돌 0).** codex(gpt-5.5·**effort high**)가 validator verdict·E1~E7 결론을 못 본 채 독립으로:

- **8질문 전부 동일 결론으로 도출** — Q1·Q3·Q4·Q5(BK1~6) 완전 합의(고신뢰 확정)·Q2·Q6·Q7·Q8은 codex가 CONDITIONAL/추가 발굴이나 전부 validator 컨펌큐와 정합하거나 한 단계 더 깊은 독립 통찰. 진짜 충돌 0.
- **제본비 영역 GO를 독립 확정** — ① 두갈래 구조 타당 ② 제본비 .01=권당 단가(÷min_qty 불요·디지털 전이 금지) ③ del_yn 참조+중철 오염 결함 확정(과청구 50% 직접 산술) ④ GC-BK1~6 6/6 직접 재계산 일치 ⑤ misfire 양상 독립 정정(validator 정정-1과 동일). **= 제본비 교정(W1 재배선·W2 중철 단가행 교정·돈크리티컬)은 두 모델 독립 합의로 고신뢰 확정.**
- **완성가(부품 합산) 영역을 CONDITIONAL로 격상하되, 그 조건이 validator 컨펌큐와 정합** — Q-BK-COVER(표지/내지 단가소스)·Q-BK-PROC(proc_cd 주입)·세트 부모 바인딩(W4)이 닫히기 전 실 적재 금지는 validator의 "DB 미적재·인간 승인 후 dbmap" GO 라벨에 내장된 항목.
- **★완성가 배선 구현 계약 공백 3건 독립 선제 발굴**(DV-BK2 effective qty·DV-BK3 역할별 selection·DV-BK4 상위소스/required comp) = designer가 W3/W4 완성가 배선 시 닫아야 할 위험을 외부 모델이 미리 지목 = 설계 강화.

**codex 종합 = "CONDITIONAL GO(제본비 GO·완성가는 표지/내지 단가소스+역할 차원 분리+component별 페이지 배수 계약 확정 후 적재)"** vs **validator = "GO(E1~E7 PASS·컨펌큐 동반·실 적용 인간 승인 후 dbmap·완성가 W3/W4는 Q-BK-COVER 후 확정)"** — 라벨이 사실상 동치(codex의 "완성가 보완 조건"=validator가 컨펌큐+DB 미적재로 이미 분리한 항목). **divergence 0(진짜 충돌)·고신뢰 확정.**

**∴ 책자(반제품 세트·다부품 합산형) 설계 GO는 codex high 독립 교차검증으로 지지된다(divergence 0·진짜 충돌 0).** codex가 ① 제본비 .01 권당 단가 정합(÷min_qty 불요) ② del_yn+중철 오염 결함(과청구 50%) ③ GC-BK1~6 6/6 골든 ④ misfire 양상 정정 ⑤ 완성가 배선 구현 계약 공백 3건을 echo 아닌 독립 도출 = 한 모델이 합리화할 설계 오류를 외부 모델이 독립 확인/보강한 고신뢰 신호.

**잔여(인간/designer 소유·차단 아님·전부 DB 미적재)**:
1. ★**W1 재배선(PRF_BIND_SUM→COMP_BIND_TWINRING·proc_cd 분기) + W2 중철 단가행 오염 교정(B01 verbatim 8행 UPDATE)** — 과청구 50% 차단 돈크리티컬·**두 모델 독립 합의 고신뢰**·dbm-price-arbiter 심의 + 인간 승인 후 dbmap(dbm-axis-staged-load·dbm-load-execution)·단가값 verbatim·멱등·백업·undo.
2. ★**Q-BK-COVER 표지/내지 단가소스 확정**(디지털 종이비 시트 포함 vs 책자 전용)·**DV-BK3 표지/내지 역할별 selection 차원 분리 메커니즘**(전용 comp + 역할별 선택값 전달)·**Q-BK-COVER+검증보강 proc_grp:PROC_000001 정합** — 완성가(W3) 배선 선결·dbm-price-arbiter.
3. ★**DV-BK2 component별 effective quantity 엔진 계약 명문화**(제본비=qty·내지비=qty×pages를 한 FORMULA에서 어떻게 받는가) — 완성가 배선 시 designer가 닫을 구현 공백·codex 독립 발굴.
4. ★**DV-BK4 상위 가격소스(TEMPLATE/PRODUCT_PRICE) 부재 확인 + required component 정책**(표지/내지 no_match 시 0원 침묵 vs 견적 거부=저청구 방지) — codex 독립 발굴·신규 컨펌 큐·dbm-price-arbiter.
5. **Q-BK-PROC proc_cd 주입 레이어**(상품→고정값·미주입 시 0원 침묵)→round-6 dbm-option-mapper(W1 선결).
6. **W4 세트 부모 바인딩(072/077/082/100·B02 SSABARI)·088 BLOCKED·포토북 Q-BK-PHOTO·면지 Q-BK-MYUNJI·책자 수량구간할인 Q-BK-DSC** — dbm-price-arbiter/실무 컨펌.
7. **(validator LOW·정정-1) freshness "upd_dt 2026-06-17"→"reg_dt 2026-06-17·upd_dt NULL"·misfire 양상 표현 정밀화** — designer 폐루프(가격 무영향·문서만·codex DV-BK5와 정합).

전부 DB 미적재·인간 승인 후 dbmap 위임(dbm-load-execution·dbm-axis-staged-load·dbm-price-arbiter·dbm-ddl-proposer·webadmin 코드 직접수정 금지). 라이브 읽기전용 SELECT만·DB 쓰기 0·산출 05_codex/ 한정.

---

## 6. codex 가용성 노트

- **모델**: gpt-5.5 (codex-cli 0.140.0)·**effort high**(`-c model_reasoning_effort=high`).
- **호출 방식**: preflight 백그라운드 행 회피 — `cat _prompt.md 설계5파일 | codex exec -m gpt-5.5 --sandbox read-only --skip-git-repo-check -c model_reasoning_effort=high --output-last-message _output.txt -` foreground stdin 우회(CLAUDE.md §11 교훈·EXIT 0).
- **격리**: 작업디렉토리 `/tmp/codex-booklet-work`(설계 5파일 사본만·자격증명·`.env.local` 미노출·우리 verdict 미포함).
- **가용성**: **가용**(CODEX_READY 핑 + 본 판정 EXIT 0)·"Claude 단독" 폴백 아님.
- **독립성[HARD] 입증**: codex 프롬프트(`_codex-prompt-booklet.md`)에 hpe-validator의 E1~E7·GO/NO-GO·gate-verdict 일절 미포함. codex가 CONDITIONAL GO를 자체 라벨로 도출(validator GO를 echo 아님)·misfire 정정·완성가 구현 계약 공백 3건을 독립 발굴 = echo 불가 입증.
