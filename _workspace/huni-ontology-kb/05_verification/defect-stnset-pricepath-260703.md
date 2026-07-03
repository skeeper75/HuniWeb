# 결함 보드 — 문구 셋트(SB-1) Phase4 적대검증 · 축3 가격 경로 연결 완전성 + sparse 정직성

> 검증자: okb-adversarial-verifier (생성≠검증) · 2026-07-03 · 축: **가격 경로 연결 완전성(product→priced_by→PRF_STN_*→has_component→COMP_STN_*→단가행) + sparse grid 정직성**
> 원칙: 생성자 주장 비신뢰 · 직접 재실측(live-snapshot awk + `t_prc_component_prices` 셀 실측 + **라이브 `simulate-set` 실호출**) · 라이브 읽기전용 SELECT만.
> 범위: 문구 셋트 부모 9(172~179·181) + 구성원 반제품 16(293~308) + 공유 공식9(PRF_STN_*)/구성요소9(COMP_STN_*) + GAP4.

## 판정 요약
- **High 0 · Medium 1 · Low 0** (격리·정직표기 확인 다수).
- 가격 경로 = **구조적으로 완전하고 값이 정직**: 9 부모 전부 priced_by→PRF_STN_*→has_component→COMP_STN_* 사슬 무결(edges.jsonl 9/9·9/9), 16 구성원 전부 derived_from 부모(dangling 0·priced_by 안티패턴 0), 라이브 evaluate_set_price 실호출로 등록 사이즈 전건 PRICE≠0·off-grid 0 실증.
- 유일 결함 = **M-1(sparse 프레이밍 과대·"전 사이즈/수량 견적0"이 수량축·선택가능 사이즈를 오기술)** — 안전 방향(과소평가)이라 Medium·PLAUSIBLE.

---

## 재실측 증거 (verified·결함 아님)

### E1. 단가행 셀수 = 노드 주장 전건 일치 (awk 실측)
`awk t_prc_component_prices.csv` comp_cd별 행수: DIARY_SOFT/HARD/LHARD/LSOFT·MONTHLY·SPRINGNOTE·SPRINGNOTEBK·JUNGCHEOL = **각 1셀**, MEMOPAD = **2셀**(SIZ_000379 144x206·SIZ_000380 B5 182x257). KB "1셀×8·179만 2셀" 주장 확증. 173 단가행 = SIZ_000375(130x190)=12,000 노드 주장과 일치.

### E2. ★가격 경로 구조 무결 (edges.jsonl 실측)
- priced_by: 9/9 부모 → PRF_STN_*(172→SOFT … 181→JUNGCHEOL). 라이브 `t_prd_product_price_formulas` 바인딩 전건 정합(apply_bgn 2026-06-06).
- has_component: 9/9 PRF_STN_* → COMP_STN_*(disp_seq 1·addtn Y). 라이브 `t_prc_formula_components` 전사 일치.
- COMP_STN_* 노드 9종 전부 nodes.jsonl 실재(중복 아님 — 2회 출현은 gap-stn-sparse-grid 노드의 backlinks 목록·오탐).

### E3. ★라이브 evaluate_set_price 실호출 — 등록 사이즈 전건 PRICE≠0·값 정직 (simulate-set 직접 실행, copies=1)
| prd | 등록=단가행 siz | live final | 단가행 unit_price | 판정 |
|---|---|---|---|---|
| 172 만년다이어리(소프트) | SIZ_000375 | 9,000 | 9,000 | ✅ |
| 173 만년다이어리(하드) | SIZ_000375 | 12,000 | 12,000 | ✅ |
| 174 만년다이어리(레더하드) | SIZ_000375 | 15,000 | 15,000 | ✅ |
| 175 만년다이어리(레더소프트) | SIZ_000375 | 15,000 | 15,000 | ✅ |
| 176 먼슬리플래너 | SIZ_000170 | 12,000 | 12,000 | ✅ |
| 177 스프링노트 | SIZ_000170 | 4,500 | 4,500 | ✅ |
| 178 스프링수첩 | SIZ_000377 | 3,000 | 3,000 | ✅ |
| 179 메모패드 | SIZ_000379 | 5,000 | 5,000 | ✅ |
| 181 중철노트 | SIZ_000196 | 2,500 | 2,500 | ✅ |
- 각 부모가 **등록한 유일(179만 2개) 사이즈 = 단가행이 채워진 사이즈**로 정확히 일치 → 손님이 선택 가능한 사이즈는 항상 PRICE≠0.
- final = 부모공식 unit_price 그대로(구성원 기여 0 실증 — 면지·표지 멤버 자체 공식 0행).

### E4. ★off-grid = 견적0 실증 (simulate-set)
173에 미등록 siz(SIZ_000001) 강제 주입 → `final=0`(warns 4). 고정가 룩업(PRICE_TYPE.01)은 정확 siz_cd 매칭·면적매트릭스 ceiling 없음 → off-grid=0 확인. 노드 "sparse→off-grid 견적0" 주장 정합.

### E5. 면지 무가격(기여0) 정직 = live 실측 일치
면지 295(만다 하드)·297(레더하드) = `t_prd_product_materials` **0행**·`t_prd_product_price_formulas` **0행**·`t_prc_component_prices` 자체 comp 없음 → 엔진 기여 0(E3 final이 부모 unit과 정확 일치로 이중 확증). KB "면지 empty-shell·무가격·자재 0행·삭제금지" 정직.

### E6. 비종이 표지 판형없음 정합
레더 표지 296/298 = 자재 MAT_000186(레더·MAT_TYPE.05 비종이)·`t_prd_product_plate_sizes` 0행 → KB "레더=비종이·판형 불요" 정합(종이 표지 294도 멤버 plate 0행·판형은 부모 레벨 등록·오해 없음).

### E7. GAP 정직성 = "가격 있는 것처럼" 안 넣음 (전건 정합)
- gap-stn-177-classification: 177 라이브 prd_typ=.02(반제품) vs SOT 셋트 완제품 conflict 정직(anchor:none·양면). live 확증(PRD_000177 prd_typ_cd=PRD_TYPE.02).
- gap-stn-sparse-grid: "1~2셀·대부분 견적0·공식 존재≠가격 완성" — 셀수 실측 정합(단, M-1 프레이밍 과대).
- gap-stn-muji-inner-minmax: 무지내지 302/304/306/308 = MAT_000261 + min/max 미설정 정직(자재 실측 정합).
- gap-stn-member-optgroup-ui: 구성원 옵션/가격 UI 렌더 미결 정직(set-series D-1 동류).

### E8. 구성원 모델링 = C-5 통일 준수 (M-1 안티패턴 미재발)
16 구성원 전부 `derived_from 부모`(priced_by 부모공식 0건). 직전 set-series 배치 M-1(095/096/098 priced_by 부모FIXED 이탈)의 안티패턴을 문구 배치는 반복하지 않음 → 역방향 질의 3중청구 오탐 없음.

### E9. 누락 없음 — 180 정당 제외
PRD_000180 "메모패드(내지커스텀) 준비중"(prd_typ=PRD_TYPE.03 기성·`t_prd_product_sets` 0행) → 셋트 아님·준비중. 노드 미생성 정당(팬텀 가격 없음).

---

## 결함

### [M-1·Medium·PLAUSIBLE] sparse 프레이밍 "전 사이즈/수량 견적0"이 수량축·선택가능 사이즈를 과대 오기술
- **노드:** stationery-formulas.md(9 공식 note "→전 사이즈/수량 견적0")·stationery-components.md(9 comp)·gaps.md `gap-stn-sparse-grid`("대부분 사이즈/수량에서 견적 0")·product-172~181 부모 노드 산문.
- **유형:** sparse 정직성 — 미완성을 **과대(과소평가 방향)** 기술. 값 오류 아님·구조 결함 아님.
- **증거(라이브 실측):**
  - **수량축은 sparse 아님:** 9 단가행 전부 `min_qty=1` 단일 밴드 → 밴드 floor 룩업으로 임의 수량 정상. 173 실호출 copies=1/10/100/500 = 12,000 / 120,000 / 1,200,000 / 6,000,000 (선형·PRICE≠0). "수량 견적0"은 사실과 다름.
  - **선택가능 사이즈는 항상 가격:** 각 부모 `t_prd_product_sizes` 등록 사이즈 = 단가행 채워진 사이즈와 정확 일치(E3). 견적0인 사이즈는 손님이 선택 불가능한 off-grid뿐(E4) → 정상 구성에서 손님은 0을 만나지 않음.
- **영향:** 하위 질의게이트가 "만년다이어리(하드) 100권 얼마?"(= 1,200,000·정상)에 대해 "대부분 견적0/가격 미확정"으로 **정당한 견적을 잘못 보류/거절**할 위험. badge=candidate·"공식 존재≠가격 완성"이 실제 견적능력 대비 과도하게 비관적. (단 노드에 "PRICE≠0 가능한 등록 사이즈 존재" 완화 문구가 병기돼 있어 신중한 독자는 오도되지 않음 → PLAUSIBLE.)
- **교정안:** sparse note를 "**사이즈 grid는 sparse(1~2셀)이나 등록=선택가능 사이즈는 전부 PRICE≠0·수량은 min_qty=1 단일밴드로 전량 커버**. 미등록 사이즈만 견적0(off-grid)"로 정밀화. gap-stn-sparse-grid gap_what에서 "수량" 제거·"등록 외 사이즈 확장 시 grid 충전 필요"로 한정.
- **라우팅:** builder(Stage A 공유 공식/구성요소 note + 부모 노드 산문 정밀화) / architect(gap-stn-sparse-grid 워딩). **격리 아님 — builder 교정 가능.**

---

## 격리(Isolation·builder 교정 대상 아님)
- gap-stn-177-classification(라이브 prd_typ .02 → SOT 재분류·실무진/dbmap 승인) · gap-stn-muji-inner-minmax(무지내지 min/max·§23 set-inner) · gap-stn-member-optgroup-ui(구성원 옵션 UI·§6/§34) · 면지 색 옵션그룹·자재 충전(dbmap/§7) · 셋트 UI siz_cd 미전파(코드 C트랙·set-series 동형) — 전부 gap/양면 노드로 정직 표기 확인.

## 종합
문구 셋트 가격 경로 = **구조 무결·값 정직·라이브 실호출 전건 PRICE≠0(오차0)·off-grid 0 실증**. 유일 builder 결함 = M-1(sparse 프레이밍 과대·수량축 오기술·Medium·안전 방향·PLAUSIBLE). 나머지는 격리 정직 표기 정합.

<!-- 재현: scratchpad/stn_setprice.py(9 부모 simulate-set on-grid+off-grid)·scratchpad/qty.py(173 수량 선형)·awk t_prc_component_prices.csv COMP_STN_* 셀수·edges.jsonl priced_by/has_component/derived_from 그렙. live-snapshot=snap_20260702_1119. -->
