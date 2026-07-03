# 결함 보드 — 아크릴 신규 노드 (축1: 출처 실재성 + 권위 정합 + 오염 적발)

- 검증 대상: 아크릴 25 단품(146~170 minus 167 결번 + 226·171 del_yn=Y 미생성) + 공유축
- 검증자: Phase 4 적대적 검증가 (생성≠검증·구축가 주장 비신뢰·라이브/캐시 직접 재실측)
- 기준: 상품마스터·인쇄상품 가격표 260702 + 07-04 신규 라이브 SELECT 캐시(`_cache/acryl-*-260704.csv`) + `pack-acrylic.md`
- 빌드 실측: node 1486 · edge 4571 · 아크릴 badge=defect 0 (오케 baseline 일치)
- **판정: PASS (조건부) — High 0 · Medium 0 · Low 2. 축1 GO.**

---

## PASS 항목 (기계 대조로 반증 실패 = 정합 확인)

### A. 출처 실재성 — PASS
- 표본 노드(146/159/164/226) `sources[]` 전수 재확인: 인용처가 실재 파일(`acryl-universe/price-chain/addon-templates/prod-formulas-260704.csv`·`pack-acrylic.md`·`live-snapshot/latest/*.csv`·라이브 railway SELECT). locator 값이 캐시 실데이터와 축자 일치(예: 146→PRF_CLR_ACRYL→COMP_ACRYL_CLEAR3T 277셀·2,000~32,700).
- source 테이블 실재·badge 부여. 날조 인용 0.

### B. 가격모델 정합(핵심) — PASS
- **T-7 재확인:** `acryl-prod-prices-260704.csv` = **0행**(헤더만). 그래프 edge 전수 스캔 — 아크릴 25 상품 中 `gap-goods-fixed-lookup-no-formula` 슬러그 부착 **0건**(해당 슬러그는 굿즈팩 59상품 전용). 아크릴 전량 공식기반.
- **M1 면적(148/150/151/152/157/158/159/161/162):** priced_by PRF_CLR_ACRYL → COMP_ACRYL_CLEAR3T **277셀 실재**(min 2,000·max 32,700) 라이브 price-chain 대조 일치. 146/147/149/154(CL-2)도 본체=277셀 area + 부속 addon(M2b).
- **M3 고정가형(153/155/160/166):** component_prices siz_cd 단가행 수 라이브 awk 대조 = 153:3 · 155:3 · 160:5 · 166:4 **전건 일치**. 직접단가룩업 아님(공식기반).
- **M5 164 코롯토:** COMP_ACRYL_COROTTO 36셀 실재 → gap-acryl-tbd 미부착(진짜 단가 보유·정확 판정).

### C. STALE 오값 적발 — PASS (반증 실패)
- 과업·구문서 대형 숫자 "146=480,000·151=590,000·부속 330/380/300k" → `nodes.jsonl` 전수 grep **0건**(480000/590000/330000/380000/300000 어느 노드에도 값으로 미적재).
- 라이브 실측값만 적재: 면적 최대 32,700 · 부속 마그넷 800/집게 700/헤어끈 500 · 볼체인 1,000(146 addon TMPL-000056~063). 151 맥세이프 = "바디 가격 미정·본체 area만" 정직(590,000 팬텀 없음).

### D. 오염 적발 — PASS
- **① substrate=두께만(T-8):** 146/147/148/154 `uses_material` = MAT_000043(아크릴 3mm) **단일**. 부속(고리 051/052·군번줄 456·자석 050/047/048/049·핀·헤어끈 057·바디)은 uses_material **미배선** — edge note가 "부속=has_addon/부자재이지 substrate 아님(T-8)" 명시. 색상값→substrate 오배선 0.
- **② 판형(T-9):** 아크릴 25 상품 `has_plate_size` edge **0건**. plate_sizes 실재분은 props에 "면적공식 미참조=가격영향 없음(비종이·양면)"으로 양면 정직 표기.
- **③ 226 드리프트 정정:** priced_by = **PRF_GOODS_FIXED_SIZ**(§23 재바인딩·77 공유셀). STALE stub `PRF_ACRYL_SHCOROTTO_TBD` edge 0건. 인쇄면 오염자재 MAT_000309/311/313(del_yn=Y) uses_material 미배선 — 대신 has_size SIZ_000611/612/613(인쇄면 siz화). 활성 글리터 310/312/314/315(del_yn=N)만 배선하고 edge note "무가 CPQ" 명시. drift_note가 구 STALE 노드 대체 이력 기록.

### E. 미출시 정직 — PASS
- 159/164/165/168/169/170/226 = 라이브 use_yn=N 실측 일치. props `use_yn:N`·`status:미출시` 기록·팬텀 가격 0. 165/168/170 = "견적 불가·COMP_ACRYL_PENDING_TBD 0셀·추천 제외·팬텀 금지" 명시.
- **171 지비츠(del_yn=Y): 상품 노드 미생성 확인**(material-MAT_000171만 존재·product 노드 부재·T-10).
- **167 결번: 노드 미생성 확인**(범위 내 DB 부재).

---

## 결함(빌더 교정 대상)

### [LOW-1] 159 아크릴코스터 — use_yn=N인데 "추천 제외" 명시 결여 + badge=verified
- **현상:** 159 props = `status:미출시(use_yn=N)`만 기록. 형제 미출시(164/165/168/170)가 가진 "추천 결과 제외·팬텀 가격 금지" 명시 문구가 **없음**. 게다가 badge=**verified**(형제 164/165/168/169/170/226은 candidate)이며 완전한 면적 277셀 가격경로 보유.
- **실패 시나리오:** 질의 게이트가 use_yn을 안 읽고 badge=verified+가격경로 완비만 보면 159가 추천에 누출될 수 있음(형제 미출시 대비 방어 문구 1겹 부족).
- **격리 아님(빌더 교정 가능):** 159 props에 형제와 동일한 "추천 제외·팬텀 금지" 가드 문구 추가로 정합. 기능 결함은 아님(use_yn=N 자체는 기록됨) → LOW.

### [LOW-2] 226 글리터 색상 4종 uses_material 배선 — T-8 경계 회색지대
- **현상:** 226 uses_material → MAT_000310/312/314/315(글리터 색상값·MAT_TYPE.09). edge note가 "글리터 옵션·무가 CPQ"로 disclaim하고 has_option_group(글리터)도 병존하나, 색상값이 substrate 관계(uses_material)로도 배선됨.
- **판정 근거:** 라이브 prod-materials del_yn=N 실재분과 일치(faithful-to-live)이고 226엔 두께 substrate 자재 부재(글리터가 유일 활성자재)·note가 무가 CPQ 명시·use_yn=N. 엄격 T-8(색상값≠substrate) 관점에서 uses_material 대신 옵션-only가 더 깨끗하나, 정보 손실 회피·정직 disclaim로 완충됨 → LOW(선택적 정정).

---

## 격리(builder 교정 대상 아님 — 원천결함·정직 표기 정당)

- **mat_typ 오타이핑(GAP-AC-1):** 아크릴 3mm가 MAT_TYPE.03(부자재)·153 골드실버 MAT_TYPE.20·226 글리터 MAT_TYPE.09. 라이브 현재값 그대로 기록·정합은 §7/§12. 실무진 IMPORT 자재 삭제금지[HARD].
- **공정 0행 MISSING 10상품(GAP-AC-2):** 153/154/156/159/164/165/166/168/170/226 공정 미배선. 라이브 원천 부재·양면 정직.
- **TBD 6건 0단가행(gap-acryl-tbd-formula-no-priced-rows):** 163/165/168/169/170·226 = COMP_ACRYL_PENDING_TBD/MINIPART_TBD 0(or placeholder)셀·실무진 BLOCKED. gap 슬러그 정직 부착·226은 gap-226-acryl-tbd.
- **plate_sizes 오적재(T-9):** 비종이 아크릴에 plate_sizes 행 실재하나 면적공식 미참조. props 양면 표기로 격리.

---

## 결론
축1(출처 실재성·권위 정합·오염) = **GO**. 구축가 산출은 반증에 견딤 — 출처 실재·STALE 대형오값 미적재·substrate/판형/226 드리프트 오염 0·미출시/del/결번 정직. 잔여 = LOW 2(159 추천-제외 문구·226 글리터 uses_material 회색지대), 원천결함 전량 정직 격리.
