# reconcile — Claude↔codex 합의/불일치 (남은 6셋트·동형 전파 2차)

생성: hsp-codex-verifier · 방법=독립 2차(codex 판정 비노출)→Claude 라이브 실측 그라운딩→합의/불일치 분리·게이트 라우팅.
**codex 주장 = 가설.** 아래는 codex 주장을 Claude 라이브 읽기전용 실측(2026-06-24)으로 그라운딩한 결과. 최종 판정은 S 게이트(라이브 재실측).

> 독립성 주의: codex에는 Claude/게이트 판정·엽서북 결론을 노출하지 않았다. 같은 입력(-ext 설계·권위·적재본)만 줬다.

---

## A. Claude 독립 라이브 실측 (codex 그라운딩용 — codex엔 비노출)

| 실측 | 쿼리 | 결과 | codex 주장 그라운딩 |
|---|---|---|---|
| 부모 6 유형 | t_prd_products | 6 전부 PRD_TYPE.04(라이브 현재값) | 설계 "현재값04 실측"·codex "교정 전 04" 양측 일치 |
| 구성원 26 유형 | t_prd_product_sets⋈products | 26 전부 PRD_TYPE.02·del_yn=N | codex Q1 "전부 02·혼입0" **라이브로 확증** |
| 셋트 행 26 | t_prd_product_sets | 전부 존재·sub_prd_qty=1·min/max/incr=NULL·disp_seq=1 | codex Q4 "기존행 존재·복합PK 유일·FK 고아0" **라이브로 확증**(F-2 INSERT 위험은 실재행 존재로 무해) |
| 멤버 수 | group by | 4+4+5+5+1+7=26 | codex 행수 정합 **라이브로 확증** |
| 가격공식 바인딩 | t_prd_product_price_formulas | 부모6·구성원26 **전부 0행**·094만 PRF_PCB_FIXED | codex Q3 "PRICE=0 견적불가" **라이브로 확증** |

→ codex의 사실 주장(유형·존재·바인딩 0)은 **전부 Claude 라이브 실측과 합의**. codex의 견해 차이는 사실이 아니라 "권위 강도·SQL 멱등 표현"에 있음(아래 B).

---

## B. 합의 / 불일치 매트릭스

| # | 사안 | codex | Claude(설계+라이브) | 상태 | 라우팅 |
|---|---|---|---|---|---|
| R1 | 구성원 26 전부 반제품·혼입0 | PASS | 라이브 확증(26/26 PRD_TYPE.02) | **합의·고신뢰** | 게이트 형식확인만 |
| R2 | 택1 면지/표지=카탈로그(always-add 아님)·행 보존 | PASS | 설계 §3.2 동일 결론 | **합의·고신뢰** | 게이트 형식확인만 |
| R3 | GUARD-1(가격 신설 시 평면합산 과대청구 위험) 식별 | 정확 | 설계 §3.3·blocked-ext:5 동일 | **합의·고신뢰** | §18 가격설계 계약 이월 |
| R4 | 6셋트 PRICE=0 견적불가·이중합산0 | PASS | 라이브 확증(바인딩 0) | **합의·고신뢰** | BLOCKED-PRICE-6 §18 라우팅 유지 |
| R5 | 복합PK 중복0·FK 고아0·disp_seq 단조·유형UPDATE 멱등 | PASS | 라이브 확증(26행 유일·존재) | **합의·고신뢰** | 게이트 형식확인만 |
| R6 | false-positive(택1 정상구조 오판) 0 | PASS | 합의 | **합의** | — |
| **D1** | **부모 04→01 교정의 권위 강도** | **확인필요(CONFIRM-1 미해소·"확정" 승격 과장)** | 설계는 "directive가 완제품 교정으로 확정(RM-3 해소)" | **불일치(견해)** | **게이트 라이브 판정 — 권위 근거 강도 재확인** |
| **D2** | **셋트 UPSERT upd_dt 무가드 멱등성** | **FAIL(재실행 timestamp 변경)** | 설계 §2 "UPSERT 멱등(ON CONFLICT)"로 strict 미주장 안 함 | **부분 불일치** | **게이트/load-executor — upd_dt no-op 가드 or 허용 결정** |
| **D3** | **apply-ext.sql "UPDATE·신규0" 주장 vs INSERT…ON CONFLICT** | **본문↔SQL 불일치(preflight 가드 없음)** | 라이브 26행 실재→INSERT 미발생(무해)이나 SQL 자체엔 가드 부재 | **부분 불일치(표현/안전망)** | **게이트 — 문구 정정 or UPDATE-only/preflight 결정** |
| **D4** | 하드커버/링책자 min/max/incr NULL 유지 | 확인필요(권위에 페이지 24~300/+2·8~100/+2 명시·CONFIRM-5 미해소·"갭 해소" 아님) | 설계는 "페이지축=부모옵션·내지 member 부재→충전 행 없음"으로 NULL 정당화 | **불일치(견해)** | **게이트/RM-4 — 페이지가변이 셋트 member 범위인지 부모 옵션인지 권위 판정** |
| D5 | 포토북 표지5종 택1·페이지 NULL | 확인필요(CONFIRM-3 권위행 미특정) | 설계도 CONFIRM-3로 BLOCKED·라이브 현황 기준 GO | **합의(둘 다 모호 인정)** | CONFIRM-3 권위 시트 특정·실무진 |

---

## C. 확인 필요 후보 (codex 신규 제기 — 라이브/권위 확인 전 가설)

- **CN-1 (D1·codex F-1)**: 부모 6 유형 04→01이 **권위 미확정(CONFIRM-1)**인데 설계 §0이 "확정" 승격. directive(셋트 부모=완제품)와 webadmin 주석("반제품만 제외"=디자인상품도 셋트 부모 허용) 충돌이 권위 레벨 미해소. → **게이트가 라이브로 판정**: 디자인상품(use_yn=N 코드)에 붙은 셋트 부모를 01로 바꾸는 것이 webadmin 인라인 노출·상품뷰어 분류에 미치는 영향 + directive 권위 강도. 엽서북(094) 04→01 COMMIT 선례가 있으나, codex는 그 선례를 모르는 상태(독립)에서 "권위 근거 미흡"을 제기 — 게이트가 선례 정합으로 해소할 것.
- **CN-2 (D2·codex F-3)**: 셋트 UPSERT `upd_dt=now()` 무가드 → 재실행 timestamp 변경. 엽서북 1차 F-4와 **동형 반복**(동형 전파 시 가드 누락도 전파됨). → load-executor가 strict 멱등(변경0) 요구 시 `WHERE … IS DISTINCT FROM` 또는 값 동일 시 `upd_dt` 미변경 가드 추가 결정.
- **CN-3 (D3·codex F-2)**: apply-ext.sql 본문 "UPDATE·신규 mint 0" 주장 vs `INSERT…ON CONFLICT`. 라이브 26행 실재로 실제 INSERT는 발생 안 하나, SQL 자체에 preflight 없음. → 문구를 "UPSERT(기존행 존재 확인됨)"로 정정 or UPDATE-only로 전환 결정.
- **CN-4 (D4·codex Q5)**: 하드커버/링책자 페이지 가변(24~300/+2·8~100/+2)이 셋트 member 범위(min/max/incr)인가 부모상품 페이지옵션인가. 권위는 "set-designer가 채울 셀"(CONFIRM-5)이라 기록 → 설계의 "셋트 member 아님" 판정과 견해 차. **게이트/RM-4가 권위로 판정**(내지 member가 MES별도설정으로 미등록인지 라이브 재확인).

---

## D. 게이트 라우팅 큐 (S 게이트 입력)

| 큐 | 내용 | 우선순위 | 처리 주체 |
|---|---|---|---|
| Q-AGREE | R1~R6 합의분(구성원 유형·택1·가격BLOCKED·무결성·false-positive) | 고신뢰 | 게이트 형식 재실측만(이월) |
| Q-D1/CN-1 | 부모 04→01 권위 강도(CONFIRM-1)·엽서북 선례 정합 확인 | High(돈 아님·분류 영향) | 게이트 라이브 판정 |
| Q-D2/CN-2 | UPSERT upd_dt no-op 가드 추가 여부(strict 멱등) | Medium(안전망) | load-executor 결정 |
| Q-D3/CN-3 | apply-ext.sql "UPDATE/신규0" 문구↔INSERT 정합(preflight or 정정) | Medium(문서/안전) | 게이트/set-designer |
| Q-D4/CN-4 | 하드/링 페이지가변=셋트 member vs 부모옵션(RM-4) | Medium(차원 모델) | 게이트/dbmap·인간 |
| Q-D5 | 포토북 CONFIRM-3 권위행 특정 | Low(구조보정은 라이브 기준 GO) | 권위 시트·실무진 |

---

## E. false-positive 점검 (양방향 적발)

- **codex가 정상구조를 결함으로 오판했나?** — 아니오. codex는 택1 다중행을 정상(카탈로그)으로 인정, R2/R6 PASS. 부품조립형 정상 구조(한 완제품 다수 반제품)를 결함으로 오독하지 않음.
- **codex가 진짜 오염을 놓쳤나?** — 진성 가격결함(BLOCKED-PRICE)·이중합산은 양측 합의로 적발됨. codex가 추가로 D1(권위 강도)·D2/D3(SQL 멱등/문구)을 제기 → 설계가 "정직하게 BLOCKED 분리"한 것과 별개로, **유형교정 권위 강도와 SQL 안전망**을 게이트가 보강할 여지. 이는 놓친 돈크리티컬 결함이 아니라 절차/안전망 보강 사안.
- **종합 신뢰도**: 사실 주장(유형·바인딩·무결성)은 codex↔Claude 라이브 **완전 합의**. 불일치는 전부 "권위 강도·SQL 표현"의 견해차이며, 어느 것도 적재본을 무효화하는 데이터 결함이 아님. 게이트는 D1~D4를 라이브/선례로 해소하면 GO 가능.
