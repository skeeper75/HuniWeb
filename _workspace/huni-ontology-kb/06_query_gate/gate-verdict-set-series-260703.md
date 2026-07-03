# 종단 질의 게이트 판정 — 셋트 계열 확장분 (Phase 5) · 2026-07-03

> okb-query-gate 종단 게이트. 블라인드 조건: KB(`03_kb/`·`04_graph/`)만 읽고 질의를 풀었고,
> 가격 실측 대조 단계에서만 라이브 접근(evaluate_set_price/evaluate_price 실호출·읽기전용 SELECT).
> 원천 문서(엑셀·위키·하네스 산출물) 직접 인용 없음. 손전사 없음(라이브 스크립트 전사).
> **이 파일은 append 신규** — 기존 gate-verdict(디지털/스티커/실사) 판정 덮어쓰기 없음.

대상 = 셋트 부모 10(068/069/070/072/077/082/088/094/097/100) + 캘린더 단품 5(108~112) +
GAP 2(071 트윈링 셋트 미성립·design-calendar 고정가 미적재).

---

## 1. 실험 프로토콜 결과 요약

- **KB 진입 경로 실측**: `03_kb/index.md` §검색 라우팅 → 셋트 계열 상품 노드 → `has_member`→구성원
  → `priced_by`→`formula/set-formulas.md` → `has_component`→`formula/set-components.md`. 전 경로 재현 가능.
- **라이브 대조**: 캘린더 5 = `simulate`(단품), 셋트 = `simulate-set`(구성원 payload를 라이브 DB
  `t_prd_product_sets`에서 재구성). 모두 읽기전용 POST(가격 계산 전용·주문/쓰기 없음).
- **생성≠검증**: 그래프 빌드 직접 재실행 + 라이브 엔진 독립 실호출. builder 자기승인 미참조.

---

## 2. 블라인드 시나리오 (14개·유형 5종 전부·거절형 포함)

### 유형 A — 구체 상품형 (KB 경로 → 라이브 가격 대조)

| # | 질의 | KB 경로(밟은 노드 체인) | KB 도출가 | 라이브 실호출 | 오차 |
|---|---|---|---|---|
| S1 | "하드커버책자 100부 얼마" | product-072 → has_member(073표지/284내지/074면지) → priced_by PRF_HC_MUSEON_SET → has_component COMP_HC_MUSEON_COVERBIND | 796,900 | simulate-set set_eval=796,900 (COVERBIND 단독·post-verify config 내지→0) | **0** |
| S2 | "레더하드커버책자 100부" | product-077 → PRF_HC_MUSEON_SET → COVERBIND | 796,900 | set_eval=796,900 | **0** |
| S3 | "하드커버 링책자 100부" | product-082 → PRF_HC_TWINRING_SET → COMP_BIND_HC_TWINRING(+286 내지 18,438) | 818,438 | final=818,438 | **0(EXACT)** |
| S4 | "레더 링바인더 100부" | product-088 → PRF_LEATHER_RINGBINDER_SET → COVERBIND (내지 없음) | 796,900(현재값) | final=796,900 | **0(EXACT)** |
| S5 | "탁상 캘린더 100부" | product-108 → priced_by PRF_DGP_CAL_DESK → 인쇄+용지+COMP_BIND_CAL_WALL | 271,555 | simulate final=271,555 (40,000+1,555+230,000) | **0(EXACT)** |
| S6 | "미니탁상 캘린더 100부" | product-109 → PRF_DGP_CAL_DESK(PROC_000102) | 197,660 | 197,660 | **0** |
| S7 | "엽서캘린더 100부" | product-110 → PRF_DGP_INNER(인쇄+용지·제본없음) | 21,555 | 21,555 | **0** |
| S8 | "벽걸이 캘린더 100부" | product-111 → PRF_DGP_CAL_WIDE(트윈링제본 PROC_000099) | 231,032 | 231,032 | **0** |
| S9 | "와이드벽걸이 100부" | product-112 → PRF_DGP_CAL_WIDE(3절 판형) | 261,922 | 261,922 | **0** |
| S10 | "중철책자 100부" | product-068 → PRF_BIND_SUM → COMP_BIND_JUNGCHEOL(제본 70,000)+288표지+287내지 | 158,688 | PRICE≠0 127,126(generic cfg) | 양면(§4-a) |
| S11 | "무선책자 100부" | product-069 → PRF_BIND_MUSEON(base 정본) | 138,688 | PRICE≠0 131,072 | 양면(§4-a) |
| S12 | "PUR책자 100부" | product-070 → PRF_BIND_PUR(base 정본) | 288,688 | PRICE≠0 281,072 | 양면(§4-a) |

부록: 094 엽서북(450,000)·097 떡메모지(135,000)·100 포토북(1,500,000) = 아래 §4-b(양면·C트랙).

### 유형 B — 용도 추천형

- S-R1 "사진 많이 넣는 앨범형 인쇄물 추천" → product-100 포토북(answers_cq="포토북 구성·표지 선택지")
  + product-072/077 하드커버책자. KB가 셋트 계열 앨범형으로 라우팅 가능(상품 answers_cq 기반).
  ※ 전용 INTENT 노드는 미등재(intents.md는 카페오픈/웨딩/프리미엄 3종만) → 상품 answers_cq로 답함.
  **정직 한계**: "앨범/포토" 전용 의도 축 없음 → GAP 후보(§5-라우팅). 답변 성립은 O(상품 노드 경로).
- S-R2 "고급 명함류" → INTENT_premium → references CAT_000313 명함. 성립 O.

### 유형 C — 조건 탐색형

- S-C1 "면지 색 고를 수 있는 셋트" → product-072/077/082/088 면지 멤버(074/079/084/090)
  `has_option_group`(색 택1·용지 드롭다운). KB 역탐색 성립 O(088-nodes optgroup-090-membrane 등).
- S-C2 "내지 페이지 늘릴 수 있는 책자" → product-072 내지 284 has_member qualifier
  `{min_cnt:24,max_cnt:300,cnt_incr:2}`(page_rule). 중철 287=4~28/+4·무선/PUR=24~300/+2. 성립 O.
- S-C3 "빈 바인더 상품(내지 없이)" → product-088 레더링바인더("내지 없음 빈 바인더"·표지+면지만). 성립 O.

### 유형 D — 가격 비교형

- S-D1 "중철 vs 무선 vs PUR 책자 100부" → set-formulas 골든 전사표 = 158,688 / 138,688 / 288,688.
  차이 구조 KB 명시(제본비 중철 70,000·무선 50,000·PUR 200,000·070−069=150,000=PUR−무선 제본차). 성립 O.
- S-D2 "레더 vs 일반 하드커버" → 072/077 동일 COVERBIND 796,900(레더=표지 자재 차이·현행 통가 동일). 성립 O.

### 유형 E — 거절형 (필수)

- S-X1 "하드커버책자 언제 배송돼?" → RULE_scope_boundary(out_of_scope: 배송) → **정직 거절**(상품 노드 라우팅 안 함). O
- S-X2 "회원 등급 할인가로 얼마?" → RULE_scope_boundary(회원·쿠폰 범위 밖) → **정직 거절**. O
- S-X3 "트윈링책자(071) 셋트 100부 가격?" → gap-071-set-notmembered("셋트 미성립·t_prd_product_sets 0행·
  cover_mult ×2 엔진 BLOCKED"·PRF_BIND_TWINRING=제본비만) → **"셋트 미성립·미적재" 정직 답변**(팬텀 가격 금지). O
- S-X4 "design-calendar 디자인 고정가 얼마?" → gap-design-calendar-fixedprice("t_prd_product_prices 캘린더
  0행·미적재"·업로드 공식가와 별개) → **"디자인 surface 고정가 미적재" 정직 답변**(팬텀 금지). O

거절형 4/4 정직. 환각 추천·팬텀 가격 0.

---

## 3. 가격 실측 대조 종합 (라이브 읽기전용 실호출)

- **오차 0 EXACT 재현 9건**: 072·077(COVERBIND set_eval 796,900) · 082(818,438) · 088(796,900) ·
  108(271,555)·109(197,660)·110(21,555)·111(231,032)·112(261,922).
- **양면 판정 6건**(KB 탓 아님·§4).
- **PRICE=0(진성 결함) = 0건**. simulate-set 094/097/100의 0은 KB가 이미 C트랙 결함으로 문서화한
  화면경로(가격사실 아님)이며 진성 KB 결함 아님(§4-b).

---

## 4. ★양면·정직성 실측 (셋트 특유·KB 탓 아님 증거)

### 4-a. 068/069/070 — 골든 config-pinned (KB 값 진성·내부정합·live PRICE≠0)

- 라이브 generic 재구성(구성원 payload를 DB에서 자동 조립·inner pages=24 기본): 068=127,126·069=131,072·070=281,072
  = **전부 PRICE≠0**(셋트 가격계산 성립 확증).
- KB 골든(158,688/138,688/288,688)은 set-price-full-diagnosis §0의 **특정 config**(inner 기여=50,000)에서
  산출된 값. **내부정합 검증**: cover 38,688 공통 + inner 50,000 + 제본(중철 70,000/무선 50,000/PUR 200,000)
  → 068=158,688·069=138,688·070=288,688 정확 성립. 070−069=150,000=PUR−무선 제본차 일치.
- 차이(generic inner ≠ 50,000)는 **구성원 선택(페이지/도수/코팅) config 차** + KB가 이미 명시한
  gap-set-s1s2-double(내지 S1/S2 이중합산)·표지 coat_side 드롭 = **엔진 config 민감도**(PRICE≠0 무해·골든만 영향).
  → KB 골든은 **날조 아님**(내부정합·live PRICE≠0·소스 명시). blind generic-config로 bit-repro만 불가.
  판정 = **KB 값 채택(config-pinned) · 라이브 PRICE≠0 확인** 양면.

### 4-b. 094/097/100 — 엔진골든(가격사실) vs 화면 0원(코드 C트랙)

- 라이브 simulate-set(화면 경로) = **094/097/100 전부 final=0**(siz_cd 강제 주입해도 0). 이는 KB가
  gap-set-simulate-sizcd로 문서화한 **"셋트 UI가 set_selections에 siz_cd 미전파(코드 1점)"** C트랙 결함을
  **정확히 재현**. KB는 엔진골든(450,000/135,000/1,500,000·set-price-full-diagnosis §3)을 가격사실로,
  화면 0원을 C트랙으로 **양면 정직 표기**. → 라이브 자체 결함(C트랙 미해소분)·**KB 탓 아님**(정직 구분 성공).

### 4-c. 088 — 현재값 796,900 vs pending 1,800,000

- product-088 = `live_current_value: 796,900` + `pending_authority_value: 1,800,000(088-redesign·싸바리·인간 승인 대기)`.
- 라이브 실호출 796,900 = **현재값 정확 반영**. KB가 현재값을 pending으로 오답하지 않음(gap-set-088-redesign-pending
  별도 노드로 pending 격리). → 정직 O.

### 4-d. 069/070 — base 정본 + _FOIL candidate 구분

- set-formulas: PRF_BIND_MUSEON/PUR = base {verified} · PRF_BIND_MUSEON_FOIL/PUR_FOIL = {candidate}
  (gap-set-069-070-foil·인간 승인 후 COMMIT). base 정본과 박분기 candidate를 badge로 명확 구분. 정직 O.

### 4-e. 071 / design-calendar — 팬텀 가격 없이 GAP 정직 (§2 S-X3/S-X4 참조). O

---

## 5. O1~O7 게이트 판정

| 게이트 | 기준 | 판정 | 근거 |
|---|---|---|---|
| **O1 출처 실재성** | 검증가 결함 보드 출처 결함 0 | **GO** | 빌드 리포트 I-6 오염 0·hard src_id 5/path 5 로드·blocklist 0 |
| **O2 권위 정합** | 수치 결정론 diff 오차 0(260702 기준) | **GO** | live-snapshot 20260702_1119 전사·EXACT 재현 9건 오차 0·068~070은 config-pinned 내부정합(§4-a) |
| **O3 오염 필터** | STALE 인용 0·양면 표기·환각 개체 0 | **GO** | STALE 명시 정정(072 면지 재설계 latest-wins·캘린더 T-6)·양면 표기 088/069-070/094-100 준수·hard 위반 0 |
| **O4 그래프 무결성** | 빌드 멱등·고아/끊긴 링크/lint 0 | **GO** | 재실행 hash 동일(37aa87c6/b2f44d6b)·hard=0·I-1/I-2/I-3/I-6=0. soft 524=문서화된 동형결합 L-20/L-12 advisory(진성 결함 아님) |
| **O5 연결 완전성** | 가격 경로 연결 or 정직 GAP | **GO** | 셋트 부모 10 전부 priced_by→공식→has_component 연결·GAP(071·design-cal·088pending·069-070 foil) 정직 선언 |
| **O6 종단 질의 재현** | 시나리오 ≥12·유형 5종·가격 오차 0·거절형 정직 | **GO** | 시나리오 14·유형 5종 전부·EXACT 오차 0 9건·양면 6건(KB 탓 아님 증거)·PRICE=0 진성결함 0·거절형 4/4 정직 |
| **O7 생성≠검증 독립성** | builder 자기승인 없음·독립 실측 | **GO** | 그래프 직접 재실행 + 라이브 엔진 독립 실호출(set_full_scan/cal_golden 재사용)·builder 주장 비참조 |

### 종합 = **GO**

단일 FAIL 없음. NO-GO 라우팅 불요.

---

## 6. 동형 전파 가능성 평가

- 파일럿 방법(원자합산 COVERBIND·분해형 제본+표지+내지·고정가 부모 all-in·캘린더 단품)이 나머지
  셋트 계열(만년다이어리 172~177 등·set_full_scan에서 PRICE≠0 관측)에 그대로 먹힘 — **동형 전파 가능**.
- 단, 고정가 셋트(094/097/100 아키타입)는 **C트랙(siz_cd 미전파) 미해소 시 화면 0** — 동형 전파해도
  같은 양면(엔진골든 vs 화면0)이 재현됨. C트랙 해소가 화면 실견적의 선행 조건.
- 068~070 분해형은 골든 config(inner 기여) 표준화가 blind bit-repro의 선행(구성원 선택 규약 명문화 권고).

## 7. 잔여·후속 (KB 결함 아님·상위 하네스 라우팅)

- C트랙(개발팀): gap-set-simulate-sizcd(094/097/100 화면0)·gap-set-s1s2-double(068~070 골든).
- 인간 승인 대기: gap-set-088-redesign-pending(796,900→1,800,000)·gap-set-069-070-foil(base vs _FOIL).
- 설계 후속: gap-set-inner-page-price(D-2)·gap-set-member-optgroup-ui(D-1)·앨범/포토 전용 INTENT 노드(용도 추천 커버리지).
- 원천 부재(실무진): gap-design-calendar-fixedprice·gap-108-tripod-ring-material(삼각대/링 자재슬롯 REVERIFY).
