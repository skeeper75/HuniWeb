# 책자 — 갭 보드 (round-19 종단 · 미적재/오적재/오배선/silent-0)

> 점검일 2026-07-03 · 라이브 실측. 각 갭 = 증상 + 증거(라이브 쿼리) + 돈영향 + 라우팅 + COMMIT 필요.
> 라우팅: round-6 CPQ(`dbm-option-mapper`) / round-16·18 가격(`dbm-price-*`) / round-5 적재(`dbm-load-builder`) / C트랙=개발자.

## ★ BOOKLET-BIND-WIRE = 해소 확인 (stale 반증)

RTM(2026-06-15)의 "PRF_BIND_SUM에 중철 comp만 배선·무선/PUR/트윈링 미배선" NO-GO는 **해소됨**.
라이브 실측: 069→PRF_BIND_MUSEON(COMP_BIND_MUSEON 8행)·070→PRF_BIND_PUR(8행)·071→PRF_BIND_TWINRING(32행)로 **A안 공식분리 COMMIT 완료**. 068 PRF_BIND_SUM은 이제 중철 전용(COMP_BIND_JUNGCHEOL). **제본비항 미배선 갭 0.**

## 갭 목록 (돈영향·심각도 순)

### GB-1 [High·돈] 071 트윈링책자 저청구 — 제본비만 청구, 인쇄/용지 미청구
- **증상**: 071은 셋트 미전환(t_prd_product_sets 0행)·비셋트 `evaluate_price` 경로. 바인딩 공식 PRF_BIND_TWINRING = **COMP_BIND_TWINRING(제본비/트윈링제본) 단 1개 comp**. 내지 인쇄비·용지비·표지 comp 없음.
- **증거**: `formula_components WHERE frm_cd='PRF_BIND_TWINRING'` = COMP_BIND_TWINRING 1건. note="제본비/트윈링제본". 반면 068~070은 셋트라 내지(287~291·PRF_DGP_INNER)+표지(288~292·PRF_BOOK_COVER)가 인쇄+용지 청구.
- **돈영향**: 트윈링책자 = 제본비(700~5,000원 tier)만 청구 → 책 한 권 실가 대비 **수만 원 저청구** 위험. 4개 A통합 중 유일 미전환.
- **처리**: 068/069/070과 동형으로 **셋트 전환**(트윈링-내지·트윈링-표지 member 생성 + sets 연결) OR PRF_BIND_TWINRING에 COMP_PAPER+COMP_PRINT_DIGITAL 추가. → round-5(member 생성)+round-16/18. **실무진 확인**: 071이 인쇄 포함 상품인지(내지인쇄 CPQ·page_rule 보유 = 예상 인쇄상품). **COMMIT 필요·인간 승인**.

### GB-2 [High] 070 PUR책자 CPQ VOID — "Test" 껍데기 그룹만
- **증상**: 070 옵션그룹 = OPT-000011 "Test"(옵션1·item 0) 뿐. 손님이 사이즈/용지/인쇄/코팅/제본 아무것도 못 고름 → **주문 불가**(가격은 정상).
- **증거**: `option_groups WHERE prd_cd='PRD_000070'` = "Test" 1행. `options WHERE opt_grp_cd='OPT-000011'` = 옵션1·items 0. 구성원(291/292)에도 옵션그룹 0.
- **돈영향**: 가격체인은 완결(PRICE≠0)이나 UI 미구성 = 매출 차단(주문 자체 불가).
- **처리**: 068 중철 7그룹(사이즈/내지종이/내지인쇄/표지종이/표지인쇄/표지코팅/제본) **동형 복제** + "Test" 그룹 은퇴. → round-6. **COMMIT 필요**.

### GB-3 [Med-High] 097 떡메모지 CPQ 0그룹
- **증상**: 097 옵션그룹 0. 손님이 사이즈·묶음수(50/100장1권)·용지 못 고름 → 주문 불가(가격 정상 135,000).
- **증거**: `option_groups WHERE prd_cd='PRD_000097'` = 0행. C36 묶음수(bundle_qtys)는 적재됐으나 CPQ 미노출.
- **처리**: 사이즈+묶음수(bundle)+용지 옵션그룹 신설. → round-6. **COMMIT 필요**.

### GB-4 [Med] 072/077/082/088 하드커버 셋트 CPQ thin — 면지색만
- **증상**: 4 하드커버 셋트 각 옵션그룹 **1개("면지색")** 뿐. 사이즈/내지종이/내지인쇄/표지코팅/페이지수 CPQ 미노출(구성원에도 0). 손님이 면지색 외 선택 불가.
- **증거**: `option_groups WHERE prd_cd='PRD_000072'` = "면지색" 1행. 094 엽서북(9그룹)·068(7그룹)과 대조. §23 D-1 "구성원 옵션그룹 UI 렌더" 후속과 동근.
- **돈영향**: 사이즈/용지 고정 판매면 부분 허용이나, 사이즈 선택은 최소 필요(082=siz 4종 보유). 매출·오주문 리스크.
- **처리**: 최소 사이즈 그룹 + (페이지수·내지종이) 그룹 신설(094 엽서북 superset 패턴 참조). 셋트 구성원 옵션 렌더 방식 실무진 확인. → round-6 + §23 D-1. **COMMIT 필요(부분)**.

### GB-5 [Med·C트랙] 094 엽서북·097 떡메모지 셋트 UI siz_cd 미전파 → 화면 초기 0원
- **증상**: 셋트 완제품은 셋트 UI가 siz_cd/bdl_qty를 set_selections로 전파 안 하면 초기 0원. 엔진은 dims 주면 정확(094=450,000·097=135,000).
- **증거**: 기존 `DEV-REQUEST-set-sim-sizcd-260702`(문구·명함 동근). 데이터로 못 고침.
- **처리**: **C트랙(개발자)** — 이미 알려진 DEV-REQUEST. 데이터 COMMIT 불필요.

### GB-6 [Low·비차단] C32 제본방향(좌철/상철) 그릇부재
- **증상**: 068~071 제본방향 CPQ 그룹 없음. 공정에 per-product param 슬롯 부재.
- **돈영향**: 없음(생산메타·가격 무관). 비차단.
- **처리**: 견적 비차단. 위젯/주문 생산정보 전달 시 param 슬롯 필요분만 후속(§6).

## 오적재·오배선 스캔 결과
- **silent-0**: 책자 완제품 10 전건 PRICE≠0(엔진 유효 dims). silent-0 0건. 단 071은 저청구(GB-1)·094/097은 코드 0원(GB-5).
- **이중합산**: §23 셋트 게이트 S4에서 072/077/082/088 이중합산 0 검증됨(면지=제본비 흡수·셋트공식 mat 미종속). 재발 0.
- **오적재**: 면지 색멤버(075/076/080/081/085/086/091/092/093) use_yn=N 은퇴 정상(§23 재설계). 잉여 아님.

## COMMIT 필요분 요약
| 갭 | 유형 | 라우팅 | 우선 |
|----|------|--------|------|
| GB-1 071 저청구 | 가격구조(셋트전환/comp추가) | round-5+16/18 | High |
| GB-2 070 CPQ void | CPQ 동형복제 | round-6 | High |
| GB-3 097 CPQ 0 | CPQ 신설 | round-6 | Med-High |
| GB-4 072/077/082/088 thin CPQ | CPQ 부분신설 | round-6+§23 | Med |
| GB-5 094/097 화면 0원 | 코드결함 | C트랙(기존 DEV-REQUEST) | Med |
| GB-6 C32 제본방향 | 그릇부재 | §6 후속 | Low |

**즉시 COMMIT 필요분 있음** (GB-1~GB-4, 인간 승인 후 각 라운드). GB-5=C트랙·GB-6=비차단.
