# 결함 보드 — 스티커 16상품 출처·권위·오염 + 연당가 양면 정합

> 검증가: okb-adversarial-verifier · 2026-07-03 · 배정축 = 스티커 출처 실재성/권위 정합/오염 + 연당가 양면 정합
> 대상: PRD_000052~067 (16상품) · 스티커 스코프 노드 140 · 소스 280 · 재현 스크립트 `05_verification/scripts/sticker_prov_260703.py`
> 원칙: 생성자·리포트 비신뢰 — 전 판정 직접 재실측(결정론 diff/awk). 자연어 판단은 gap 서술·중복 판정에만.

## 요약 (축별 전수/표본)

| 축 | 방법 | 결과 |
|----|------|------|
| ① 출처 실재성 | 전수(280 소스 resolver+행 재조회) | 278 실재 확인 · 2 해석불가(malformed) · 5필드 결측 0 · 손전사 마커 결측 0 |
| ② 배선(priced_by/has_component) | 전수(16상품 edge 추적) | **16/16 완전 배선** · 고아 공식 0 · 끊긴 사슬 0 · 완제품가 룩업(원자합산 오모델 0) |
| ③ 권위 정합(연당가 값) | 전수(dual 노드 ↔ price-diff CSV diff) | 전사값 3소재 오차 0 (162/163/372) |
| ④ 오염 4종 | 전수(STALE/구권위/환각/오적재-verified) | STALE 0 · 환각개체 0 · 오적재-verified 0 · 구권위 origin 2건(Low) |
| ⑤ 연당가 양면(§4-D) | 전수(4권위소재 커버리지 + false-defect 스캔) | **크라프트(164) 양면노드 누락(Medium)** · false-defect 0(무변경 소재 준수) |

## 결함 목록

### D-STK-01 [Medium] 크라프트(MAT_000164) 연당가 양면노드 누락 — 4소재 중 1개 미커버 + 순환 위임 서술 오류
- **노드:** (누락) `material-MAT_000164`/`matcost-*-krafft` 부재 · 오귀속 서술=`gap-058-yeondangga`·`gap-062-yeondangga`·`gap-066-yeondangga`
- **축:** ⑤ 연결 완전성(조용한 누락) + ③ 오염(왜곡 서술)
- **증거(재현):** `sticker_prov_260703.py` [A4.a] `MAT_000164 -> ★없음(MISSING dual)`. 260702 diff는 크라프트를 4 돈-크리티컬 변경으로 명시(`price-diff-260527-260702.csv`: 크라프 연당가 156000→81500·국4절 312→272). 투명162·홀로163·투명후지372는 dual 생성됐으나 **크라프164만 KB에 노드 0개**. gap-058/062/066은 "재적재 워크리스트는 **투명/홀로/크라프트 소재 쓰는 타 스티커(059~064·053/054/056/063)** 소관"이라 위임하나, `awk t_prd_product_materials`: **MAT_000164·자식 MAT_000591을 쓰는 상품 0행**(어떤 스티커도 크라프트 미사용) → 위임 대상이 실재하지 않는 **순환/허위 위임**. 팩 §4-D "이 4소재를 양면 노드로 만들어라 = 재적재 워크리스트" 위반(워크리스트 3/4 불완전).
- **심각도 근거:** 크라프트를 쓰는 라이브 상품 0 → 현재 견적 오가격 없음(High 아님). 단 §4 "★핵심 임무·돈-크리티컬"의 4소재 중 1개 미추적 + 허위 위임으로 조용히 누락(O5 "조용한 누락=결함").
- **교정안:** MAT_000164 양면(defect) 노드 신설 — `authority_value=연당가 81,500/국4절 272/평량 57(무변)` · `current_value=t_mat_materials MAT_000164 원가 미저장·COMP_PAPER 0행` · 자식 MAT_000591(06-30 mint) 병기. gap-058/062/066의 위임 서술에서 "크라프트" 제거(투명/홀로만 실 owner).
- **라우팅:** builder(양면노드 신설 + gap 서술 정정).

### D-STK-02 [Low] optgroup-052/067-paper source_file `+` 결합 — 단일 파일로 해석 불가
- **노드:** `optgroup-052-paper`·`optgroup-067-paper`
- **축:** ① 출처 실재성
- **증거:** `[A1.b]` source_file=`live-snapshot/latest/t_prd_product_options.csv+t_prd_product_option_items.csv`. 두 CSV는 각각 실재하나 `+` 결합으로 단일 source_file 필드가 resolver·lint에서 미해석. (참고: 실제 옵션 junction 정답 파일명은 `t_prd_product_option_groups.csv`/`t_prd_product_option_items.csv`)
- **교정안:** source 항목을 파일당 1개로 분리(2 엔트리)하고 locator에 복합키 전사.
- **라우팅:** builder.

### D-STK-03 [Low] MAT_000372(투명후지) 양면노드 중복 — 동일 앵커 2노드
- **노드:** `material-MAT_000372`(axis/materials.md) + `matcost-053-clear-backing`(product/sticker-halfcut-clear-nodes.md) — 둘 다 anchor `t_mat_materials/MAT_000372`·둘 다 defect·둘 다 authority 222,000/740
- **축:** ③ 오염(중복·L-3 근접) / §4-D 워크리스트 이중계상 위험
- **증거:** `[A4.a] MAT_000372 -> ['matcost-053-clear-backing', 'material-MAT_000372']`. 동일 소재·동일 권위값을 2노드가 주장 → "dual 노드 = 재적재 워크리스트"(§4-D) 관점에서 372 변경이 이중 등재. (162도 material-MAT_000162[parent] + matcost-053-white-backing[child 371]로 2노드지만 parent/child 앵커가 달라 정당 — 372는 앵커 동일)
- **교정안:** axis 정본(`material-MAT_000372`)을 canonical로, `matcost-053-clear-backing`은 `references`로 접거나 product-local 표식 명시(중복 계상 방지).
- **라우팅:** builder(architect 확인 — 2층 원가노드 규약).

### D-STK-04 [Low] plate-060/061 SIZ_000521 — "상품마스터260610" origin 무대조 인용
- **노드:** `plate-060-SIZ_000521`·`plate-061-SIZ_000521`
- **축:** ③ 오염(구권위 잔재 스캔 hit)
- **증거:** `[A3.a]` locator=`…330x470·tags 46전지·note 반칼 스티커 표준전지·**출처 상품마스터260610** 출력소재IMPORT`. 1순위 소스는 live `t_siz_sizes.csv`(값 330x470 검증됨)이고 260610은 origin 주석 — 전지 규격은 structure-diff상 무변경(price-diff 비대상). 실 오염 아님(false-positive 경계)이나 §8-6 규칙상 260610 인용은 260702 대조 주석 필요.
- **교정안:** locator에 "260702 무변경(전지 규격 diff 비대상)" 주석 추가 → 스캔 노이즈 제거.
- **라우팅:** builder(주석) 또는 curator(스캔 예외 등재).

### D-STK-05 [Low] gap-058/062/066 `_meta/scripts/…` KB-상대경로 관례 불일치
- **노드:** `gap-058-yeondangga`·`gap-062-siz058-price-missing`·`gap-066-yeondangga`
- **축:** ① 출처 실재성(경로 관례)
- **증거:** source_file=`_meta/scripts/transcribe_sticker_058.py` 등 — 파일은 **실재**(`_workspace/huni-ontology-kb/_meta/scripts/`)하나 KB-루트 상대경로라 문서화된 root(repo·foundation·live-snapshot)에서 미해석. prov_expand의 기존 resolver가 이를 repo-root로 오해해 "파일 부재"로 오탐(교정 resolver로 실재 확인). 다른 소스는 `_workspace/…` 전체경로 사용 → 관례 혼재.
- **교정안:** source_file를 `_workspace/huni-ontology-kb/_meta/scripts/…` 전체경로로 통일(또는 resolver에 KB-root 등록 명문화).
- **라우팅:** builder(경로 통일).

## 통과 확인 (반증 실패 = 생존)

- **배선 전수 GO:** 16상품 priced_by→공식→has_component 완전(PRF_STK_FIXED×13→COMP_STK_PRINT · PRF_STK_PACK/COMP_STK_PACK · PRF_GANGPAN_FIXED/COMP_GANGPAN_PRINT · PRF_STK_TATTOO/COMP_STK_TATTOO). 완제품가 고정 룩업 모델 — 원자합산 오모델 0.
- **연당가 값 전사 오차 0:** 162(149,500/499·105→50)·163(253,700/846)·372(222,000/740) 전부 `price-diff-260527-260702.csv` verbatim 일치.
- **false-defect 0:** 무변경 소재(비코팅 084=candidate·미색 242=verified·유포)에 defect 양면노드 없음 — §4-D "retail 무변경 = dual 금지" 준수. 065 스티커팩 clean 판정도 정당.
- **오염 3종 0:** STALE 금지패턴 0 · 환각개체(anchor live 부재) 0 · 라이브 오적재 verified 표기 0.

## 검증 범위·한계 (정직 선언)

- **전수:** 출처 실재/배선/연당가 값·양면 커버리지·오염 4종 = 스티커 16상품 전수 결정론.
- **표본/미검증:** ① 그래프 무결성(build_graph 멱등 재실행)은 본 배정축 밖(별도 verifier 소관) — 현행 nodes.jsonl(11:27 빌드) 신뢰하되 직접 재빌드 안 함. ② gap 서술의 자연어 정확성은 크라프트 위임 오류(D-STK-01) 외 표본 확인. ③ 라이브 evaluate_price 실호출 가격 대조는 미수행(질의 게이트 소관). "무결" 단정 아님 — Medium 1·Low 4 잔존.
