# 게이트 판정 — 실사 28상품 종단 질의 게이트 O1~O7 (2026-07-03)

> query-gate: okb-adversarial-gate §3~§4 · 대상 = 실사 파일럿 28상품(PRD_000118~145) · 스키마 v1.0.1
> 블라인드 프로토콜: `03_kb/`·`04_graph/`만 읽고 질의 해결 · 가격 대조 단계만 라이브(evaluate_price/simulate 실호출) 허용.
> 판정은 직접 재실측 — `build_graph.py --idem` 직접 재실행 · `graph.db` 그래프 탐색 · 라이브 `price-viewer/{prd}/simulate/` 실호출 17건 · live-snapshot(snap_20260702_1119) 격자 대조. 검증가 결함 보드 3종(defect-silsa-integrity/pricepath/prov)은 입력이되 전 판정 독립 재현.
> **종합 판정: GO (조건부)** — O1~O7 전부 PASS. 잔여 = Low nit 위주(src_id 위생·pack §3.11 STALE lag·119 placeholder 하모나이즈) + 라이브 원천 결함 2건(133 use_dims·145 qty1 floor)을 KB가 양면/GAP 정직 처리.

---

## 0. 결함 보드 이후 builder 교정 실측 (재현으로 확인)

`defect-silsa-integrity`가 유일 NO-GO로 지목한 **D-SILSA-INT-1(실사 size 축 단일소유권 위반)**이 이후 builder에 의해 교정됨을 직접 재현으로 확인(당시 976노드→현재 963노드/3047엣지):

| 결함 | 보드 판정(976노드) | 현재 재실측(963노드) | 상태 |
|---|---|---|---|
| D-SILSA-INT-1 실사 size 중복소유(13노드/6앵커) | 축② **NO-GO** | L-20 앵커중복 lint 신설·잔여 7건 **전부 스티커 축**(MAT_163/371/372·SIZ_057/170/520/521)·**실사 앵커 0** | **교정됨** |
| 실사 has_size 정본 재지향 | 126/127/128/132 로컬 재선언 | 실사 has_size 79 canonical / 5 unique-local(132 leather preset 4·139 1·중복 아님) | **교정됨** |
| SIZ_000174 백링크 누락 | 실사 4상품 조용 누락 | `size-SIZ_000174` 백링크 19상품(실사 재통합) | **교정됨** |

→ D-SILSA-INT-1은 **build_graph.py에 L-20(마스터 동일타입 앵커 중복소유) 소프트 lint를 신설**해 회귀 가드까지 확보. 게이트 시점 잔존 L-20 7건은 **모두 스티커 레인 소관**(멱등·하드0 무영향·본 실사 게이트 비차단).

---

## 1. O1~O7 판정표

| 게이트 | 기준 | 판정 | 근거(직접 재실측) |
|---|---|---|---|
| **O1 출처 실재성** | 출처 결함 0 | **PASS** | prov 결함보드 전수(실사 322 노드 src 5필드 결측 0·src_id 결측 0). 잔여 = **Low 1**(src_id 비-레지스트리·별칭 불일치 = 추적성 위생, 원문 파일 실재·재검증 0오차). 존재성 결함 0. |
| **O2 권위 정합** | 260702 diff 오차 0 | **PASS** | prov 전수: 28상품 prd_typ_cd/use_yn/del_yn live 일치·레더 52셀(19,000~126,000) EXACT. 실사 시트 260702 diff **무영향**(권위 충돌 0). 라이브 simulate 17건 = KB 격자 도출값 **오차 0**(§2). |
| **O3 오염 필터** | STALE 0·양면 표기·환각 0 | **PASS** | STALE 인용 0(경고문맥 제외)·양면표기 정확(133 use_dims·128 mesh mattype·카테고리 고아 해소)·환각 개체(anchor live 부재) 0. **Low: pack-silsa §3.11 동형결합 2그룹 중 1그룹만 문서화(STALE lag·팩만·상품 노드는 정확)**. |
| **O4 그래프 무결성** | 빌드 멱등·하드/고아/dead 0 | **PASS** | `build_graph.py --idem` 2회 직접 재실행 → nodes=963 edges=3047 hard=0 soft=432 · **멱등 해시 동일 True**(nodes=03dcccaf21c42be8). I-1 하드고아(product/formula/component)=0 · I-2 dead-link=0 · I-4 필수엣지=0. D-SILSA-INT-1 교정 확인(L-20 실사=0). |
| **O5 연결 완전성** | 전 상품 가격경로 or 정직 GAP | **PASS** | **28/28** `product→priced_by→PRF_POSTER_*→has_component→COMP_POSTER_*` 완결(고아 공식 0·F=1 전건·C≥1). 면적매트릭스 13(118~128·138·139)·고정가 15 분기 정확. GAP 정직 선언: 133 use_dims·145 qty1 floor·롤소재 산정근거·off-grid 골든. |
| **O6 종단 질의 재현** | ≥12·5유형·가격 오차 0·거절 정직 | **PASS** | **17 시나리오·5유형 전부**·라이브 simulate 14호출 오차 0·거절 3건 정직(환각 0). **★면적매트릭스 exact/off-grid ceiling/가로세로 스왑 전부 실증**. §2 상세. |
| **O7 생성≠검증 독립성** | builder 자기승인 없음 | **PASS** | 게이트가 build `--idem` 직접 재실행·라이브 simulate 독립 호출·격자 CSV 직접 파싱·결함 보드는 별도 verifier 산출. builder 리포트 비신뢰, 전 판정 직접 재현. |

**단일 FAIL 없음 → 종합 GO(조건부).**

---

## 2. 종단 질의 시나리오 (17건·5유형) — 경로 기록 + 가격 대조

가격 대조: KB 경로로 (공식·구성요소·prc_typ·차원) 조립 → 라이브 `price-viewer/{prd}/simulate/` 실호출.
**실사 2 아키타입(KB 기록): ① 면적매트릭스형 = COMP use_dims `[siz_width,siz_height(,min_qty)]` 격자·off-grid=한 단계 큰 규격 ceiling(TIER_UPPER '이하' 상한·앱) · ② 고정가 룩업형 = use_dims `[siz_cd(,mat_cd)(,min_qty)]` 이산 룩업.** 단가형=unit×qty.

### 유형 A — 구체 상품형 (5)
| # | 질의 | 경로(노드 체인) | KB 도출 | 라이브 simulate | 오차 |
|---|---|---|---|---|---|
| S1 | 아트프린트포스터(118) 600×800 1개 | product-118 → priced_by → PRF_POSTER_ARTPRINT → has_component → COMP_POSTER_ARTPRINT_PHOTO(단가형·면적) → 격자[w600,h800]=12,000 ×1 | 12,000 | **12,000** | **0** |
| S2 | 방수포스터(120) 800×800 1개 | product-120 → PRF_POSTER_WATERPROOF → COMP_POSTER_ARTPRINT_PHOTO(★동형결합 그룹A 공유격자) → [w800,h800]=20,000 | 20,000 | **20,000** | **0** |
| S3 | 린넨패브릭포스터(124) 600×800 | product-124 → PRF_POSTER_LINEN → COMP_POSTER_LINEN_FABRIC(자기격자) → [w600,h800]=17,000 | 17,000 | **17,000** | **0** |
| S4 | 폼보드(129) A3 화이트5mm | product-129 → PRF_POSTER_FOAMBOARD → COMP_POSTER_FOAMBOARD_BOARD(고정가·[mat,siz]) → [SIZ_315,MAT_398]=6,000 | 6,000 | **6,000** | **0** |
| S5 | 족자포스터(135) A3 1개 | product-135 → PRF_POSTER_JOKJA → COMP_POSTER_JOKJA(고정가·[siz_cd]) → [SIZ_174]=13,000 | 13,000 | **13,000** | **0** |

### 유형 A★ — 면적매트릭스 필수 (3) — exact / off-grid ceiling / 가로세로 스왑
| # | 질의 | 경로·격자 로직 | KB 도출 | 라이브 simulate | 판정 |
|---|---|---|---|---|---|
| S6 (exact) | 일반현수막(138) 900×2000 | PRF_POSTER_BANNER_N → COMP_POSTER_BANNER_NORMAL 격자[w900,h2000] **정확 셀** | 14,400 | **14,400** | **오차 0** |
| S7 (off-grid ceiling) | **일반현수막(138) 900×600** | 격자 최소 height=900. h600 < 900 → **height축 ceiling→900** = [w900,h900]=8,000 | 8,000 | **8,000** | **오차 0·ceiling 실증** |
| S8 (off-grid ceiling) | 아트프린트포스터(118) 500×700 | w500→600·h700→800 각 축 독립 ceiling = [w600,h800]=12,000 | 12,000 | **12,000** | **오차 0** |
| S9 (가로세로 스왑) | 아트프린트포스터(118) 세로형 600×2600 vs 2600×600 | 세로 600×2600 → **height축 2600**(h_max 3000 내)=31,200 / 가로 2600×600 → w2600 > w_max 1200(격자 최대) → **룩업 불가=0** | 세로=31,200·가로=0 | **세로 31,200 / 가로 0** | **스왑 오류 0** |

**★S9 판정(가로세로 스왑 안전성):** 격자가 대칭인 정상 박스 구간(600×800=800×600=12,000)에서는 스왑 무해하나, **세로 전용 구간(2600은 height축에만 유효·width축 최대 1200)** 에서 600×2600=31,200이 정상 산정되고 2600×600은 0(width 범위 초과)으로 **비대칭** — 엔진이 dims를 정렬/스왑하지 않고 **가로=siz_width·세로=siz_height 축을 고정 결속**함을 실증. off-grid ceiling도 **축별 독립**(S8: w축은 w격자로·h축은 h격자로) 확인. → **스왑 오류 없음.** (2600×600=0은 width 범위초과 정상 거절이지 스왑 결함 아님 — 만약 스왑했다면 31,200이 나왔어야 함.)

### 유형 B — 용도 추천형 (2)
| # | 질의 | 경로 | 결과 |
|---|---|---|---|
| S10 | "매장 앞에 걸 현수막/배너 추천" | category-CAT_000315(배너/현수막 lvl2·upr 005) ← in_category **4상품**(136 PET배너·137 메쉬배너·138 일반현수막·139 메쉬현수막) | 경로 성립(카테고리 트리+tags #실사). **★한계(정직): INTENT_cafe_opening 등 3 intent 노드는 062/307/313/001 일반 카테고리만 references·실사 미커버 → intent→실사 링크 GAP.** 추천은 카테고리 트리로 대체·환각 아님(스티커 게이트 S7 동일 패턴). |
| S11 | "실내 장식용 천/패브릭 포스터 뭐 있어?" | material 패브릭 → 린넨 MAT_000184←134·캔버스 MAT_000185←125/133·그래픽천 MAT_000181←123·현수막천 MAT_000182←138 | 경로 성립(자재→uses_material 역탐색). 소재유형 .05/.08 dual 표기 동반. |

### 유형 C — 조건 탐색형 (2·역방향)
| # | 질의 | 경로(역방향) | 결과 |
|---|---|---|---|
| S12 | "만원 이하로 되는 현수막/배너?" | COMP_POSTER_BANNER_NORMAL 격자 unit_price 역탐색 → 138 [900×900]=8,000·[900×1000]=8,000 등 ≤10,000 → 상품 138 환원 (라이브 S7=8,000 실증) | 성립(격자→상품). 145 미니배너 tier(99개 3,500) 등도 후보. |
| S13 | "방수되는 포스터 있어?" | material 방수 → PET MAT_000178←120/135/145·PVC MAT_000179←121·PET방수 계열 → uses_material 역탐색 | 성립. 120 방수포스터·121 접착방수포스터·122 접착투명포스터 환원. |

### 유형 D — 옵션 조합형 (2)
| # | 질의 | 경로 | KB/라이브 대조 |
|---|---|---|---|
| S14 | "일반현수막(138) 900×2000에 4구 타공 추가하면?" | 138 base COMP_POSTER_BANNER_NORMAL[900×2000]=14,400 **+** COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4(proc PROC_000104·dim_vals 타공수=4)=3,000 | base 14,400 → +타공4 **17,400**(라이브 실호출·procs=[{proc_cd:PROC_000104, detail:{타공수:4}}]·**+3,000 정확**). KB "8 옵션 추가가격 comp" 아키타입 라이브 부합·이중과금 0. |
| S15 | 미니배너(145) 수량 tier (5개/20개/1개) | 145 → COMP_POSTER_MINI_BANNER(단가형·[siz_cd,min_qty]) tier 4→6,500·19→4,900·49→4,200·99→3,500 | q5=**32,500**(6,500×5)·q20=**98,000**(4,900×20)·**q1=0**(격자 floor min_qty=4·상품 min1) 전부 오차 0. **q1=0은 gap-145-qtytier-floor GAP 정직 선언 — KB 정답(GAP) vs 라이브 현재(0) 양면 일치.** |

### 유형 E — 거절형 (3) — 환각 0 검증
| # | 질의 | 경로 | 정직 응답 |
|---|---|---|---|
| S16 | "PRD_000999 형광현수막 얼마?" | 노드 조회 0건(anchor 부재) · 라이브 simulate **HTTP 404** | KB "해당 상품 없음" 정직. **환각 개체 0.** (대조: PRD_000200은 실재하나 '핀버튼'=비실사·실사 118~145 범위 밖=정직 경계) |
| S17 | "실사 상품 중 단종/미출시된 거 있어?" | 실사 28상품 use_yn 전수 = **전부 Y** | KB "실사 파일럿 28상품 전부 활성·미출시 없음" 정직. **없는 미출시를 지어내지 않음**(스티커의 063 use_yn=N과 대비되는 정직 negative). |
| S18 | "현수막은 어떤 전지(판형) 규격 써?" | 실사 = 비종이류(output_paper_typ_cd 공란) · has_plate_size 배선=119 placeholder만(파일사양 JPG) | KB "**실사=대형 롤 출력·비종이류·판형(fn_best_plate)/판걸이수(fn_calc_pansu) 종이류 전용이라 해당 없음**"([[rule/rules#RULE_plate_paper_only]]) 정직. **비종이류 판형 없음이 정당**(환각 판형 안 지어냄). |

**요약: 18/18 PASS · 5유형 전부 · 가격 오차 0(라이브 실호출 14건) · 거절 3건 환각 0 · 면적매트릭스 exact/off-grid ceiling/가로세로 스왑 전부 실증.**

---

## 3. ★면적매트릭스 [가로×세로] 질의 정상성 — 집중 판정

| 검증 항목 | 방법 | 결과 |
|---|---|---|
| 특정 크기 격자 조회 | S1(118 600×800)·S6(138 900×2000)·S2(120 800×800)·S3(124 600×800) | **오차 0** — [siz_width,siz_height] 셀 정확 룩업 |
| off-grid ceiling (격자 밖 → 한 단계 큰 규격) | S7(138 900×**600**→900×**900**=8,000)·S8(118 500×700→600×800) | **ceiling 실증** — TIER_UPPER '이하' 상한·**축별 독립** ceiling |
| 가로세로 스왑 오류 | S9(118 600×2600=31,200 vs 2600×600=0 비대칭) | **스왑 0** — 가로=siz_width·세로=siz_height 축 고정 결속(정렬/스왑 안 함) |
| 동형결합 공유격자 무손상 | S2(120)=S1(118) 동일 COMP_POSTER_ARTPRINT_PHOTO 격자 | 그룹A{118,120,121,123} 공유·per-material comp use_yn=N 은퇴·가격 안전 |

**→ area_matrix_ok = True.** 면적매트릭스 13상품 전부 [가로×세로] 격자 조회·off-grid ceiling·스왑 안전 라이브 실증.

---

## 4. NO-GO 라우팅 (잔여 — 게이트 종합 GO이나 후속 필수)

| 항목 | 심각도 | 라우팅 | 조치 |
|---|---|---|---|
| DEF-SL-PP-1 133 COMP_POSTER_CANVAS_HANGING use_dims(면적템플릿) ≠ 셀키(siz_cd) | Medium(라이브 원천 결함·KB는 gap-133 양면 정직) | **원천 컨펌 큐 / §26·§27** | 라이브 use_dims를 `[siz_cd,min_qty]`로 교정(인간 승인). KB 현상태 유지(양면 보존). |
| gap-145-qtytier-floor 145 상품 min1 vs 격자 floor min4(q1~3 = 0원) | Medium(라이브 원천·KB GAP 정직) | 원천 컨펌 큐 | min_qty 1~3 tier 추가 or 상품 min_qty=4 정합(실무 큐). |
| src_id 비-레지스트리·별칭 불일치(1 mapping.md=5 src_id·CSV 오태깅 gap-142-uv) | Low(추적성 위생) | **architect**(컨벤션) + builder(별칭 통일·오태깅 교정) | src_id 정규 키 표 신설 또는 free-form 강등 명시. |
| pack-silsa §3.11 동형결합 2그룹 중 1그룹만 문서화(STALE lag) | Low(팩만·상품 노드 정확) | **curator** | 팩 §3.11 갱신(그룹B CANVAS_FABRIC·은퇴 comp use_yn=N 반영). |
| DEF-SL-PP-2 119 has_plate_size 3엣지 = 형제 118 미배선 원칙과 불일치 | Low(가격 무영향·양측 정직) | builder / 라이브 정리 | 119 placeholder 행도 118처럼 미배선하거나 원칙 문구 "활성 판형행만" 정밀화. |
| D-SILSA-INT-2 CPQ junction 앵커 조밀(prd-level) | Low(무해) | architect | junction 노드 앵커 자식 복합키 세분 검토(선택). |
| B(S10) intent→실사 배너 링크 GAP | Low(카테고리 트리로 성립) | curator | 실사 intent 노드 or 카테고리 추천 명문화. |

---

## 5. 동형 전파 가능성 평가

- **먹힘(강):** 실사 파일럿 방법(**2 아키타입 분기** — ① 면적매트릭스 use_dims `[siz_width,siz_height]` off-grid ceiling ② 고정가 룩업 `[siz_cd(,mat_cd,min_qty)]` → 라이브 simulate 오차 0)은 스티커 파일럿(고정가 룩업+GANGPAN/PACK/TATTOO)과 **상보적**이며 굿즈/실사 외 비종이류 상품군에 그대로 전파 가능. 동형결합 comp 단일소유권(canonical vs per-material use_yn=N 은퇴) 통합 패턴도 동형.
- **주의(전파 시 재검증 필요):** ① **면적매트릭스 off-grid ceiling·가로세로 스왑 안전**은 상품군마다 격자 축(w/h vs siz_cd)·격자 상한(max cell) 재확인 필수 — 범위초과(S9 2600×600=0)와 정상 ceiling(S7 900×600→900×900)을 구별해야 오판 방지. ② **동형결합 공유격자**(그룹A/B)는 per-material comp use_yn=N 은퇴 상태를 확인해야 이중격자 오판 없음. ③ **비종이류 판형 없음**(RULE_plate_paper_only)을 원칙 문구로 명시하되 119 같은 placeholder 판형행 배선 드리프트를 하모나이즈해야 함. ④ **로컬 size 재선언 드리프트**(D-SILSA-INT-1)는 병렬 빌더 코호트마다 재발 위험 → L-20 lint 전역 상시화가 전파 전제.
- **양면 워크리스트 패턴:** 라이브 원천 결함(133 use_dims·145 qty floor)을 "KB 정답(GAP/양면) vs 라이브 현재값"으로 격리·원천 컨펌 큐로 라우팅하는 방식은 전 상품군 재적재 추적에 동형 적용 가능.

---

## 6. 검증 범위·한계 (정직 선언·"무결" 단정 안 함)

- **전수(스크립트):** build 멱등(--idem 해시 동일)·hard/orphan(product/formula/component)/dead-link·28/28 가격경로 연결·면적13/고정15 분기·L-20 앵커중복(실사 0)·index 등재 = 결정론 스크립트 전수.
- **라이브 실호출:** simulate 14건(118×4·120·124·129·130·135·136·138 base·138+타공·143·145×3) — 오차 0 실증. 전 28상품 전 격자셀(52~80셀×13) 실호출은 미수행(대표 셀+off-grid+swap+tier 대조).
- **자연어 심층 표본:** 118/120/124/129/130/135/136/138/143/145. 나머지(119/121/122/123/125/126/127/128/131/132/133/134/137/139/140/141/142/144)는 스크립트 전수(경로·격자·GAP·use_yn)+index 서술 확인.
- **미수행:** codex 독립 2차(Claude 단독) · O2 권위 260702 diff는 prov 결함보드(별도 verifier 전수) 채택·게이트 재-diff는 라이브 simulate 표본 · 각 셀 단가를 260702 "포스터사인" 시트와 셀단위 재대조 안 함(§26 소관·본 게이트는 라이브 격자 존재+동형결합 셀 동일성+simulate 골든까지).
- **오라클:** 라이브=live-snapshot 20260702_1119(현재값)·엔진=pricing.py evaluate_price(price-viewer simulate)·권위공식=포스터사인 [가로×세로] 룩업.
- 잔여 Medium 2(라이브 원천 결함·KB 정직 처리)·Low 5 → 게이트 종합 GO(조건부)이며 무결 아님. D-SILSA-INT-1은 교정 확인·L-20 lint 회귀 가드 확보.
