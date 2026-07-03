# 게이트 판정 — 스티커 16상품 종단 질의 게이트 O1~O7 (2026-07-03)

> query-gate: okb-adversarial-gate §3~§4 · 대상 = 스티커 파일럿 16상품(PRD_000052~067) · 스키마 v1.0.1
> 블라인드 프로토콜: `03_kb/`·`04_graph/`만 읽고 질의 해결 · 가격 대조 단계만 라이브(evaluate_price 실호출) 허용.
> 판정은 직접 재실측 — build_graph.py 2회 직접 재실행 · graph.db 그래프 탐색 · 라이브 시뮬레이터 POST 8건 · live-snapshot(20260702_1119) 격자 대조. 검증가 결함 보드 3종은 입력이되 전 판정 독립 재현.
> **종합 판정: GO (조건부)** — O1~O7 전부 PASS. 잔여 = D-STK-2 명명 통일(Medium·architect·질의 재현 비차단) + Low nit 6건(builder/curator).

---

## 0. 결함 보드 이후 builder 교정 실측 (재현으로 확인)

결함 보드 3종(defect-sticker-integrity/pricepath/prov, 11:32~11:36 스냅샷 652노드)이 지목한 상위 결함이 **이후 builder에 의해 교정**됨을 직접 재현으로 확인(현재 654노드/2128엣지):

| 결함 | 보드 판정 | 현재 재실측 | 상태 |
|---|---|---|---|
| D-STK-pricepath D1 | qty-059 노드+has_qty_rule 엣지 부재(Medium) | 16/16 상품 qty 노드+엣지 보유(qty-059 실재) | **교정됨** |
| D-STK-integrity D-STK-1 | index.md L112 dead-link 404(Medium) | index product-link 77건 dead=0 (L112 → 실존 `sticker-spec-square.md`) | **교정됨** |
| D-STK-integrity D-STK-5 | 루트 graph.db 0바이트 잔재(Low) | 루트 graph.db 부재(정본 `04_graph/graph.db`만) | **교정됨** |
| D-STK-prov D-STK-01 | 크라프트 MAT_000164 양면노드 누락+허위위임(Medium) | `material-MAT_000164` defect 노드 실재(authority 81,500 verbatim)·gap-058/062/066 위임 서술 정정("라이브 미사용→axis owner") | **교정됨** |

→ 게이트 시점 잔존 결함은 Low nit 위주 + D-STK-2(명명 2규칙 분열, Medium·architect·그래프는 16/16 정합 해결이라 질의 비차단).

---

## 1. O1~O7 판정표

| 게이트 | 기준 | 판정 | 근거(직접 재실측) |
|---|---|---|---|
| **O1 출처 실재성** | 출처 결함 0 | **PASS** | prov 결함 보드 전수(280 소스): 278 실재+주장 지지 · 날조/누락/왜곡 0. 잔여 2건 = 소스 **형식** nit(D-STK-02 `+`결합·D-STK-05 KB-상대경로)로 원문 파일은 실재. 존재성 결함 0. |
| **O2 권위 정합** | 260702 diff 오차 0 | **PASS** | prov 전수: 연당가 3소재 전사값 오차 0(162=149,500/499·163=253,700/846·372=222,000/740) + 크라프트 164=81,500 verbatim(price-diff CSV). 구권위(260610/260527) 잔재 결정 수치 0. |
| **O3 오염 필터** | STALE 0·양면 표기·환각 0 | **PASS** | STALE 인용 0·환각 개체(anchor live 부재) 0·라이브 오적재 verified 표기 0. 양면 노드 note "current(구값/미저장)·authority(260702) 둘 다 보존·삭제 금지" 준수. Low nit: D-STK-03 MAT_000372 앵커중복·D-STK-04 260610 origin 주석. |
| **O4 그래프 무결성** | 빌드 멱등·하드/고아/dead 0 | **PASS** | build_graph.py 2회 직접 재실행 → nodes=654 edges=2128 hard=0 soft=315 · `--idem` 해시 동일 True(nodes=e39020760303c641). orphan_hard(product/formula/component)=0 · index dead-link=0. |
| **O5 연결 완전성** | 전 상품 가격경로 or 정직 GAP | **PASS** | 16/16 `product→priced_by→PRF_*→has_component→COMP_*` 완결(고아 공식 0). 공식 4종(FIXED/GANGPAN/PACK/TATTOO) 전부 live 실재. GAP 정직 선언: gap-062-siz058(silent-0)·gap-063/064(use_yn=N 미출시)·연당가 워크리스트. |
| **O6 종단 질의 재현** | ≥12·5유형·가격 오차 0·거절 정직 | **PASS** | 15 시나리오·5유형 전부·라이브 evaluate_price 8호출 오차 0·거절 3건 정직(환각 0). §2 상세. |
| **O7 생성≠검증 독립성** | builder 자기승인 없음 | **PASS** | 게이트가 build 직접 재실행·라이브 evaluate_price 독립 호출·결함 보드는 별도 verifier 산출. builder 리포트 비신뢰, 전 판정 직접 재현(D-STK-3 O4 false-negative 교훈 반영해 dead-link 실파일 검사로 재확인). |

**단일 FAIL 없음 → 종합 GO(조건부).**

---

## 2. 종단 질의 시나리오 (15건·5유형) — 경로 기록 + 가격 대조

가격 대조: KB 경로로 (공식·구성요소·prc_typ·차원) 조립 → 라이브 `price-viewer/{prd}/simulate/` 실호출. **아키타입 규칙(KB 기록): PRICE_TYPE.01 단가형=unit×qty · PRICE_TYPE.02 합가형=격자 band 그 자체.**

### 유형 A — 구체 상품형 (6)
| # | 질의 | 경로(노드 체인) | KB 도출 | 라이브 evaluate_price | 오차 |
|---|---|---|---|---|---|
| S1 | 반칼자유형(052) A6 유포 100개 | product-052 → priced_by → PRF_STK_FIXED → has_component → COMP_STK_PRINT(단가형) → 격자[SIZ_057,MAT_584,min100]=5,700 ×100 | 570,000 | **570,000** | **0** |
| S2 | 052 A6 유포 1개 | 동상 min1=6,700 ×1 | 6,700 | **6,700** | **0** |
| S3 | 반칼원형(058) A4반칼 유포 1개 | product-058 → PRF_STK_FIXED → COMP_STK_PRINT → 격자[SIZ_520,MAT_584,min1]=5,000 | 5,000 | **5,000** | **0** |
| S4 | 스티커팩(065) 75x110 54팩 | sticker-pack → PRF_STK_PACK → COMP_STK_PACK(합가형·4,000/팩) ×54 | 216,000 | **216,000** | **0** |
| S5 | 타투(067) 90x190 3장세트 | sticker-tattoo → PRF_STK_TATTOO → COMP_STK_TATTOO(합가형) 격자[SIZ_060,min3]=6,000 | 6,000 | **6,000** | **0** |
| S6 | 합판도무송(066) 유광 1000개 | sticker-gangpan-diecut → PRF_GANGPAN_FIXED → COMP_GANGPAN_PRINT(합가형) 격자[SIZ_212,MAT_155,min1000]=20,000 | 20,000 | **20,000** | **0** |

### 유형 B — 용도 추천형 (2)
| # | 질의 | 경로 | 결과 |
|---|---|---|---|
| S7 | "카페 굿즈로 스티커 추천" | category-CAT_000002(스티커 root) ← in_category 16상품 → 서브 CAT_000309(자유형)/037(규격)/311(특수)/312(팩) 분기 | 경로 성립(카테고리 트리+tags #스티커+answers_cq). **★한계(정직): INTENT_cafe_opening 등 3 intent 노드는 카탈로그 일반 카테고리(062/307/313/001)만 참조·스티커 미커버 → 전용 intent→sticker 링크 GAP.** 추천은 카테고리 트리로 대체 가능·환각 아님. |
| S8 | "고급/특수 스티커 뭐 있어?" | material 코팅(585/586)·홀로(163)·투명(162/371/372) → 상품 052/054/053/056 · category 특수(311)=067 타투 | 경로 성립(자재·카테고리). |

### 유형 C — 조건 탐색형 (2)
| # | 질의 | 경로(역방향) | 결과 |
|---|---|---|---|
| S9 | "만원 이하 스티커?" | COMP_STK_PRINT 격자 unit_price 역탐색 → 052 A6유포 1개=6,700·최저 SIZ_172 300개=3,200 등 다수 ≤10,000 → 상품 환원 | 성립(격자→상품). |
| S10 | "투명 스티커 있어?" | material 투명(MAT_000162/371/372) → uses_material ← 053(반칼투명)·056(낱장투명)·063(팬시투명) | 성립. **063은 use_yn=N 미출시 양면 표기 동반**(추천하되 상태 고지). |

### 유형 D — 옵션 조합형 (2)
| # | 질의 | 경로 | KB/라이브 대조 |
|---|---|---|---|
| S11 | "052에 (무광)코팅 추가하면?" | 052 유포(MAT_584) → 코팅자재 무광코팅(MAT_585) 교체 · **coat_side_cnt='' → 코팅=독립 가격축 아님·자재 흡수** · gap-052-coating-conflict(자재585/586 vs 공정014/015 양면) | 유포 1개 6,700 → 무광코팅 1개 **7,700**(라이브 실호출·+1,000). KB "코팅=자재 흡수" 아키타입 라이브 부합·이중과금 경로 0. |
| S12 | "투명(053)에 화이트별색 넣으면?" | 053 → 화이트 언더베이스 공정 PROC_000008(KB=선택 옵션그룹 서술) | 양면 판정: **KB 정답**=화이트별색 옵션그룹+공정 배선 서술 / **라이브 현재값**=053 sim_meta opt_groups=0(CPQ 미배선·gap-053-cutting-rekey 계열). KB가 양면 격리·환각 아님. |

### 유형 E — 거절형 (3) — 환각 0 검증
| # | 질의 | 경로 | 정직 응답 |
|---|---|---|---|
| S13 | "팬시(062) 100x140 100개 얼마?" | 062 → has_size SIZ_000058(100x140) → COMP_STK_PRINT 격자 **0행** → gap-062-siz058-price-missing(silent-0) | **라이브 실호출=0원**(결함 신호). KB가 "격자 부재·가격 미산정" GAP 정직 선언 → 지어내지 않음. **KB 정답(GAP) vs 라이브 현재(0)** 양면 일치. |
| S14 | "반칼팬시투명(063) 주문돼?" | 063 → use_yn=N·opt_groups 0행(라이브 sim_meta 확인) | KB "미출시(use_yn=N)·CPQ 미배선" 정직. 환각 추천 안 함. |
| S15 | "형광 스티커 / PRD_000099 얼마?" | 노드 조회 0건(anchor 부재) | KB "해당 상품 없음" 정직. 환각 개체 0. |

**요약: 15/15 PASS · 5유형 전부 · 가격 오차 0(라이브 실호출 8건) · 거절 3건 환각 0.**

---

## 3. ★연당가 양면 노드 = "재적재 워크리스트" 질의 노출 검증

**dual_worklist_count = 6** (스티커 스코프 연당가 material 양면 defect 노드). 질의가 라이브 현재값·260702 정답 **둘 다** 답하는지 확인:

| 양면 노드 | 앵커 | 260702 정답(authority) | 라이브 현재(current) | 질의 진입 경로(inbound) |
|---|---|---|---|---|
| matcost-053-white-backing | MAT_000371 | 국4절 499·연당가 149,500·평량 50 | 구값 국4절 1300·미저장 | 053 → uses_material 371 → references |
| matcost-053-clear-backing | MAT_000372 | 연당가 222,000·국4절 740 | 라이브 미저장 | 053·gap-053-yeondangga-repricing |
| matcost-054-hologram | MAT_000163 | 253,700·국4절 846(구 360,000/936) | 미반영 | 054 → references |
| material-MAT_000162 | MAT_000162 | 투명 연당가(재적재) | 미저장 | 056/063 uses_material |
| material-MAT_000164(크라프트) | MAT_000164 | 81,500·국4절 272(구 156,000/312) | 원가 미저장·라이브 상품 미사용 | gap-058/062/066 references(axis owner) |
| material-MAT_000372 | MAT_000372 | 222,000/740 | 미저장 | optgroup-053 option_refs |

- **노출 확인**: 각 노드 note가 authority+current 양면 보존("어느 쪽도 삭제 금지") → "투명스티커 소재 가격?" 질의가 두 값 모두 응답. ✔
- **인접 워크리스트**: `size-SIZ_000170`(A5 사이즈 양면·§4-C 재키잉 파손복구) = 별도 사이즈 정리 워크리스트(연당가 아님) → 스티커 양면 defect 노드 총 **7**(연당가 6 + 사이즈 1).
- **잔여 Low(O3)**: **D-STK-03** — `material-MAT_000372`와 `matcost-053-clear-backing`가 **동일 앵커 MAT_000372**를 2노드가 주장(고유 소재 앵커=5, 노드=6) → 재적재 워크리스트 이중계상 위험. 교정=axis 정본 canonical·product-local은 references 강등.

---

## 4. NO-GO 라우팅 (잔여 — 게이트 종합 GO이나 후속 필수)

| 항목 | 심각도 | 라우팅 | 조치 |
|---|---|---|---|
| D-STK-2 스티커 노드ID 명명 2규칙 분열(product-NNN 5 : sticker-slug 11) | Medium | **architect**→builder | 코호트 1규칙 통일(3계층 파일명·노드ID·index 정렬). 그래프 16/16 해결이라 질의 비차단이나 059/061 노드ID-index 라우팅 갭 존재. |
| D-STK-03 MAT_000372 앵커 중복 양면노드 | Low | builder(architect 확인) | canonical 1노드·중복 계상 방지. |
| D2 055 coating-conflict gap 미격상 | Low | curator confirm | 052-family와 선언 일관화 or exempt 명문화. |
| D-STK-4 공유 PROC_000008 product-local 소유 | Low | curator/builder | axis/processes.md 승격. |
| D-STK-02/04/05 소스 형식 nit(`+`결합·260610 origin·KB-상대경로) | Low | builder | 소스 필드 분리·주석·경로 통일. |
| B-용도 intent→sticker 링크 GAP | Low | curator | 스티커 intent 노드 or 카테고리 추천 명문화(현재 카테고리 트리로 성립). |

---

## 5. 동형 전파 가능성 평가

- **먹힘(강)**: 스티커 파일럿 방법(완제품가 고정 룩업 아키타입 → COMP 격자 prc_typ[단가형/합가형] 기록 → 라이브 evaluate_price 실호출 오차 0)은 **디지털인쇄(016~051)에 그대로 전파 가능**. 격자·공식 4종 단일 소유권 통합 패턴도 동형.
- **주의(전파 시 재검증 필요)**: ① 합가형(GANGPAN/TATTOO band 그 자체) vs 팩(4,000×팩수) vs 단가형(unit×qty)의 **아키타입 분기**를 상품군마다 prc_typ로 정확 기록해야 오차 0 유지(스티커에서 3분기 실증). ② silent-0(격자 0행) GAP 정직 선언 규율은 sparse 격자 전 상품군 필수. ③ 명명 2규칙 분열(D-STK-2)은 병렬 빌더 코호트마다 재발 위험 → architect 명명 정본 선행이 전파 전제.
- **연당가 양면 워크리스트 패턴**: 260702 돈-크리티컬 소재변경을 "authority vs current 양면 defect 노드=재적재 워크리스트"로 격리하는 방식은 전 상품군 재적재 추적에 동형 적용 가능(단 앵커 중복 D-STK-03 가드 필요).

---

## 6. 검증 범위·한계 (정직 선언·"무결" 단정 안 함)

- **전수**: build 멱등·hard/orphan/dead-link·16/16 가격경로·격자 PRICE≠0 = 결정론 스크립트 전수.
- **라이브 실호출**: evaluate_price 8건(052×3·058·065×2·067×2·066·062 silent-0) — 오차 0 실증. 20 siz×15 mat 전 격자셀 실호출은 미수행(대표 셀+tier 대조).
- **표본**: 자연어 심층은 052/053/054/058/062/063/065/066/067. 나머지(055/056/057/059/060/061/064)는 스크립트 전수(경로·격자·GAP)+index 서술 확인.
- **미수행**: codex 독립 2차(Claude 단독) · O2 권위 diff는 prov 결함 보드(별도 verifier 전수) 채택(게이트 재-diff는 표본).
- 잔여 Medium 1(D-STK-2)·Low 6 → 게이트 종합 GO(조건부)이며 무결 아님. D-STK-2 명명 통일이 동형 전파의 선행 조건.
