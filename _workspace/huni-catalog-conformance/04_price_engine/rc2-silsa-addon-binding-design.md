# rc2-silsa-addon-binding-design.md — RC-2 실사 가공/추가 옵션 바인딩 설계

> dbm-price-arbiter · 2026-06-23 · §21 RC-2. 읽기전용 라이브 실측·DB 미적재·webadmin 코드 미변경·기존 차원 메커니즘 사용.
> 권위[HARD]: silsa-l1(260610)·라이브 단가행 verbatim. 엔진[HARD]: pricing.py evaluate_price(`_row_matches`·`_evaluate_formula`·`_derive_price_dims`).
> ★생성자(arbiter)≠검증자 — 본 설계 GO 비준은 dbm-validator 독립 게이트. 실 COMMIT은 인간 승인 후 dbm-load-execution.
> 라이브 실측 일시: 2026-06-23. 단가 전부 라이브 t_prc_component_prices verbatim(0 변경).

---

## ① comp 전수 목록 (현 use_dims·bound·단가행·단가 verbatim)

라이브 실측 결과. **bound**=t_prc_formula_components 바인딩 수. **[]**=빈 판별차원(always-add 결함).

### A. 공정형 (proc_cd 차원 — 정상 패턴 PUNCH_4 계승 대상)
| comp_cd | comp_nm | use_dims 현재 | bound | 단가행(verbatim) | 판정 |
|---|---|---|---|---|---|
| `COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4` | 일반현수막 타공(4개) | `[proc_cd, min_qty, proc_grp:PROC_000104]` | **1** | proc=PROC_000105·dim_vals{타공수:4/6/8}=3000/4000/8000 | ★정상 패턴(단 옵션환원 불일치 CONFIRM-A) |
| `COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_6` | 일반현수막 타공(6개) | `[]` | 0 | (좀비·del_yn=Y) | RC-3 좀비 → use_yn=N 확정 |
| `COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_8` | 일반현수막 타공(8개) | `[]` | 0 | (좀비·del_yn=Y) | RC-3 좀비 → use_yn=N 확정 |
| `COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE` | 일반현수막 열재단 | `[]` | 0 | 3000 | 빈 차원·미바인딩 |
| `COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE` | 일반현수막 양면테잎 | `[]` | 0 | 3000 | 빈 차원·미바인딩 |
| `COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW` | 일반현수막 봉미싱 | `[]` | 0 | 4000 | 빈 차원·미바인딩 |
| `COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_4` | 메쉬현수막 타공(4개) | `[]` | 0 | 3000 | 빈 차원·미바인딩 |
| `COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_6` | 메쉬현수막 타공(6개) | `[proc_cd, min_qty, proc_grp:PROC_000080]` | 0 | 4000 | 차원 일부有·미바인딩(proc_grp 오설정 의심) |
| `COMP_POSTEROPT_BANNER_MESH_PROC_PUNCH_8` | 메쉬현수막 타공(8개) | `[]` | 0 | 5000 | 빈 차원·미바인딩 |
| `COMP_POSTEROPT_LINEN_FINISH` | 린넨 마감가공비 | `[opt_cd, min_qty]` | 0 | proc=PROC_000080·opt=OPV-000024~424=0/800/1000/2000/2000 | ★opt_cd 배선 但 미바인딩+옵션 불일치(CONFIRM-B) |

### B. 추가물형 (opt_cd 또는 siz_cd 차원)
| comp_cd | comp_nm | use_dims 현재 | bound | 단가행(verbatim) | 판정 |
|---|---|---|---|---|---|
| `COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4` | 일반현수막 큐방(4개) | `[opt_cd, min_qty, opt_grp:OPT_000018]` | 0 | 3000 (단가행 opt_cd=**NULL**) | ★use_dims에 opt_cd有 但 단가행 opt_cd 빔→always-add |
| `COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4` | 일반현수막 끈(4개) | `[]` | 0 | 4000 | 빈 차원·미바인딩 |
| `COMP_POPT_BNR_GAKMOK_STR_900_4_LE` | 현수막 각목(≤900)+끈 | `[]` | 0 | 4000 | 빈 차원·미바인딩(각목 CONFIRM-4) |
| `COMP_POPT_BNR_GAKMOK_STR_900_4_GT` | 현수막 각목(>900)+끈 | `[]` | 0 | 8000 | 빈 차원·미바인딩(각목 CONFIRM-4) |
| `COMP_POPT_BNR_GAKMOK_STR_900_4` | 각목 부모(통가격 껍데기) | `[]` | 0 | (단가행 0건) | 빈 껍데기 → use_yn=N 후보 |
| `COMP_POSTEROPT_BANNER_MESH_ADD_QBANG_4` | 메쉬현수막 큐방(4개) | `[]` | 0 | 3000 | 빈 차원·미바인딩 |
| `COMP_POSTEROPT_BANNER_MESH_ADD_STRING_4` | 메쉬현수막 끈(4개) | `[]` | 0 | 4000 | 빈 차원·미바인딩 |
| `COMP_POSTEROPT_PET_BANNER_STAND_IN` | PET 실내용거치대 | `[]` | 0 | min_qty=1·7000 | 빈 차원·미바인딩 |
| `COMP_POSTEROPT_PET_BANNER_STAND_OUT_S1` | PET 실외거치대(단면) | `[]` | 0 | 23000 | 빈 차원·미바인딩 |
| `COMP_POSTEROPT_PET_BANNER_STAND_OUT_S2` | PET 실외거치대(양면) | `[]` | 0 | 25000 | 빈 차원·미바인딩 |
| `COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER` | 캔버스행잉 우드행거+면끈 | `[siz_cd]` | 0 | siz=SIZ_000258/315/317=16000/18000/20000 | ★siz_cd有 但 상품 사이즈와 불일치(RC-4) |
| `COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG` | 린넨우드봉 우드봉+면끈 | `[siz_cd]` | 0 | siz=동일 3종=7000/9800/12000 | siz_cd有·미바인딩(상품사이즈 대조 필요) |
| `COMP_POSTEROPT_JOKJA_CEILHOOK` | 족자 천정형고리 | `[bdl_qty, min_qty]` | 0 | bdl_qty=2·6500 | 차원有·미바인딩(bdl_qty 의미 CONFIRM-C) |

**집계**: 대상 comp **약 23개**(공정형 10·추가물형 13). bound=0이 22개, bound=1이 1개(PUNCH_4). 빈 use_dims=`[]`가 13개. 정상 동작 사례=0개(PUNCH_4도 옵션환원 불일치로 실전 미작동).

---

## ② comp별 배선 설계표 (대상공식·판별차원·단가행충전·CPQ피드)

**원칙**: ⓐ 공식 바인딩(addtn_yn=Y) ⓑ use_dims 판별차원 충전 ⓒ 단가행 판별값 충전(단가 verbatim) ⓓ CPQ 피드 확보.
comp는 전부 상품 1:1 전용(comp_cd에 상품토큰 내장·공유 0건 — 라이브 확인). 따라서 각 comp는 자기 상품 공식 1개에만 바인딩.

| comp | 대상공식 | 판별차원 설계(use_dims) | 단가행 충전 | CPQ 피드 상태 |
|---|---|---|---|---|
| 일반현수막 PUNCH_4 | `PRF_POSTER_BANNER_N`(바인딩有) | 유지 `[proc_cd,min_qty,proc_grp:PROC_000104]` | 유지(proc_cd=PROC_000105·dim_vals 타공수) | ⚠️ proc 등록有(PROC_000104) 但 **타공수 detail·proc_cd 105 전송 미흡**(CONFIRM-A) |
| 일반현수막 CUTEDGE(열재단) | `PRF_POSTER_BANNER_N` addtn_yn=Y | `[opt_cd, opt_grp:OPT_000003]` | opt_cd=OPV_000006 | ✅ 옵션 OPV_000006 등록됨(가공그룹) |
| 일반현수막 DTAPE(양면테입) | `PRF_POSTER_BANNER_N` addtn_yn=Y | `[opt_cd, opt_grp:OPT_000003]` | opt_cd=OPV_000010 | ✅ OPV_000010 등록됨 |
| 일반현수막 BONGSEW(봉미싱) | `PRF_POSTER_BANNER_N` addtn_yn=Y | `[opt_cd, opt_grp:OPT_000003]` | opt_cd=OPV_000011 | ✅ OPV_000011 등록됨 |
| 일반현수막 QBANG(큐방) | `PRF_POSTER_BANNER_N` addtn_yn=Y | 유지 `[opt_cd,min_qty,opt_grp:OPT_000018]` → ★단 opt_grp 정정 OPT_000004 | **단가행 opt_cd=OPV_000013 충전** | ✅ OPV_000013 등록됨(추가그룹 OPT_000004) |
| 일반현수막 STRING(끈) | `PRF_POSTER_BANNER_N` addtn_yn=Y | `[opt_cd, opt_grp:OPT_000004]` | opt_cd=OPV_000014 | ✅ OPV_000014 등록됨 |
| 각목 LE/GT (CONFIRM-4) | `PRF_POSTER_BANNER_N` addtn_yn=Y | 권고(b): 1 comp `[opt_cd, siz_width]` | opt_cd=OPV_000015/16·siz_width=900/NULL | ⚠️ OPV_000015(세로)/OPV_000016(가로) 등록됨 — 但 라벨=세로/가로≠900임계(CONFIRM-4) |
| 메쉬현수막 PUNCH_4/6/8 | `PRF_POSTER_BANNER_M` addtn_yn=Y | `[proc_cd,min_qty,proc_grp:PROC_000079]`(메쉬 1 comp 통합 권고) | proc=PROC_000103(메쉬타공)·dim_vals 타공수 | ⚠️ 공정 PROC_000079 등록됨·타공수 detail 미흡(CONFIRM-A 동일) |
| 메쉬현수막 QBANG/STRING | `PRF_POSTER_BANNER_M` addtn_yn=Y | `[opt_cd, opt_grp:OPT_000023]` | opt_cd=OPV_000045 계열 | ⚠️ 추가그룹에 "추가없음"만 등록(OPV_000045)·큐방/끈 옵션 **미등록**→CPQ 선행 |
| PET 거치대 IN/OUT_S1/S2 | `PRF_POSTER_PET_BANNER`(확인 필요) addtn_yn=Y | `[opt_cd, opt_grp:OPT-000009]` | opt_cd=OPV-000019(실내)/OPV-000020(실외) | ⚠️ 거치대구매여부 그룹有(OPV-000019/020) 但 단면/양면(S1/S2) 구분 옵션 미등록→CPQ 선행 |
| 캔버스행잉 우드행거 | `PRF_POSTER_CANVAS_HANGING`(확인) addtn_yn=Y | `[opt_cd, siz_cd, opt_grp:OPT_000012]` | ★단가행 siz_cd **재배선**(SIZ_000258/315/317→상품 실사이즈 SIZ_000172/174/197) + opt_cd=OPV_000030 | ⚠️ 추가그룹 OPV_000030(출력만)만·우드행거 옵션 미등록→CPQ 선행+RC-4 차원 정정 |
| 린넨우드봉 우드봉 | 린넨우드봉 공식 addtn_yn=Y | `[opt_cd, siz_cd]` | opt_cd=OPV_000032 + siz_cd 상품대조 | ⚠️ 추가그룹에 "출력만"만·우드봉 옵션 미등록→CPQ 선행 |
| 린넨마감 LINEN_FINISH | 린넨패브릭/캔버스패브릭 공식 addtn_yn=Y | 유지 `[opt_cd, min_qty]`+`proc_grp:PROC_000080` | ★단가행 opt_cd **재배선**(OPV-000024~424→상품 옵션 OPV_000029/031) | ⚠️ opt_cd 불일치(CONFIRM-B)·미바인딩 |
| 족자 천정형고리 | 족자포스터 공식 addtn_yn=Y | `[opt_cd, opt_grp:OPT_000016]` | opt_cd=OPV_000035 계열 | ⚠️ bdl_qty=2 의미 불명(CONFIRM-C)·옵션 "추가없음"만 |

---

## ③ 각목 모델 권고 (CONFIRM-4)

**현황 실측**: 2 comp 분리(`_LE`=4000·`_GT`=8000), 둘 다 use_dims=`[]`(빈 차원).
**재계산 입증(검증 C)**: 현재 둘 다 always-match → 한 주문에 **4000+8000=12000 동시 이중합산**(돈크리티컬·과대청구).

**권고 = (b) 1 comp siz_width 티어 통합** (엔진 네이티브):
- 단가행 2행: `siz_width=900·4000`(≤900 구간 상한) / `siz_width=NULL·8000`(>900 catch-all). 엔진 TIER_UPPER('이하' 상한) 정확 동작 — 검증 C에서 폭=800→4000·폭=1200→8000 입증.
- use_dims=`[opt_cd, siz_width]` (opt_cd=각목 선택 판별 + siz_width=900임계 판별).
- 트레이드오프: (a) 2 comp 유지=각목 선택 판별을 opt_cd로 둘 수 있으나 임계를 사람이 골라야 함(LE/GT 옵션 2개 등록)·코드 단순. (b) 1 comp=siz_width 자동티어로 사용자는 "각목+끈" 1옵션만 선택→폭은 본체 사이즈에서 자동(엔진 네이티브·UI 간결)·단 siz_width가 selections에 실려야 함.
- **★CONFIRM-4 핵심 미해결**: CPQ 옵션 라벨이 "각목(세로)/각목(가로)"(OPV_000015/016)인데 권위 엑셀·단가행은 "900이하/900초과". **세로/가로 ≠ 900mm 임계** — 의미축이 다름. (b) 통합 전제는 "각목 가격이 변의 길이(900임계)로 결정된다"인데, CPQ는 "어느 변에 각목을 다나(세로/가로)"로 등록됨. 둘 중 무엇이 권위인지 **실무진 컨펌 필수**(추측 적재 금지). 컨펌 전 BLOCKED.

---

## ④ evaluate_price 재계산 검증표 (라이브 단가행·엔진 순수함수 재현)

엔진 `_row_matches`/`match_component` 순수함수를 라이브 단가행 입력으로 재현(ORM 비의존).

| 케이스 | 입력 | 현재(결함) | 설계후 | 판정 |
|---|---|---|---|---|
| **A. 일반현수막+타공4** | procs=[{proc_cd:PROC_000105,detail:{타공수:4}}] | (옵션환원 105 미전송→미작동) | **3000** 정확 | ✅ 설계後 GO·단 CONFIRM-A |
| A. 타공6 / 타공8 | 동상 detail 타공수 6/8 | — | **4000 / 8000** 정확 | ✅ |
| A. 타공 미선택 | proc_cd 없음 | — | row=None → **가산 0** | ✅ 미선택 0가산 입증 |
| **B. 큐방 현재** | siz_cd만(큐방 미선택) | **3000 SILENT ALWAYS-ADD** | — | 🔴 결함 입증(빈 차원) |
| B. 큐방 설계후·선택 | opt_cd=OPV_000013 | — | **3000** 정확 | ✅ |
| B. 추가없음 선택 | opt_cd=OPV_000012 | — | row=None → **가산 0** | ✅ |
| **C. 각목 현재** | 아무 주문 | **LE 4000 + GT 8000 = 12000 이중** | — | 🔴 과대청구 입증 |
| C. 각목 설계후(b) | opt_cd=각목·siz_width=800 | — | **4000**(≤900) | ✅ |
| C. 각목 설계후(b) | opt_cd=각목·siz_width=1200 | — | **8000**(>900) | ✅ |
| ERR_AMBIGUOUS/DUPLICATE | 전 케이스 | — | **0건** | ✅ 단일 조합 매칭 |

**결론**: 설계(opt_cd/proc_cd+dim_vals 판별차원 충전)는 ① 선택시 정확 단가만 가산 ② 미선택시 0가산 ③ ERR 0 ④ 단가 verbatim 모두 충족. 단 작동 전제=CPQ 피드(아래 ⑤).

---

## ⑤ CPQ 선행 필요분 (옵션그룹/공정 미등록·시뮬레이터 피드 트리거)

**★핵심 메커니즘 사실(코드 실측)**: `price_simulate`(price_views.py:1604-1612)는 클라이언트가 보낸 `selections`(opt_cd 직접)와 `procs`([{proc_cd,detail}])를 **그대로** 엔진에 전달. 옵션→공정 자동변환(`_opt_maps`:1377-1391)은 위젯/price_grid 경로 전용이고 **시뮬레이터에선 동작 안 함**. 따라서 시뮬레이터 작동 = 호출자가 판별값을 직접 구성해 전송해야 함.

| 상품 | 이미 있음(✅) | CPQ 선행 필요(추가 등록) |
|---|---|---|
| 일반현수막(138) | 가공그룹 6옵션(열재단·타공4/6/8·양면테입·봉미싱)·추가그룹 5옵션(큐방·끈·각목세로/가로)·공정 PROC_000104 전부 등록 | **없음**(옵션 완비). 단 ⚠️CONFIRM-A·각목 의미 |
| 메쉬현수막(139) | 가공그룹 타공4/6/8·공정 PROC_000079 | **추가그룹에 큐방/끈 옵션 미등록**(추가없음만 OPV_000045) → 추가 |
| PET배너(136) | 거치대구매 그룹 OPV-000019(실내)/020(실외)·가공 4구타공 | **실외 단면/양면(S1/S2) 구분 옵션 미등록**(단가 23000≠25000 구분 불가) → 추가 |
| 캔버스행잉(133) | 추가그룹 OPV_000030(출력만)·가공 오버로크 | **우드행거+면끈 옵션 미등록** → 추가 + **RC-4 단가행 siz_cd 재배선**(상품 사이즈와 불일치) |
| 린넨우드봉(134) | 추가그룹 출력만·가공 오버로크+봉미싱 | **우드봉+면끈 옵션 미등록** → 추가 |
| 족자포스터(135) | 가공 사각/원형족자·추가 추가없음 | **천정형고리 옵션 미등록** → 추가·bdl_qty 의미 CONFIRM-C |
| 린넨/캔버스패브릭(124/125) | 가공그룹 오버로크/말아박기/봉미싱(LINEN_FINISH 대상) | LINEN_FINISH **단가행 opt_cd가 상품 옵션과 불일치**(CONFIRM-B) → opt_cd 재배선 |

**판정**: CPQ 옵션이 **완비된 상품=일반현수막뿐**. 나머지 6상품은 옵션 추가 등록(CPQ 선행) 후에만 가산 트리거 가능 → 그 전 **BLOCKED**.

---

## ⑥ 적재 순서 (FK 위상) · 인간 승인 큐

**전부 인간 승인·DB 미적재.** 데이터 트랙 / 코드(위젯·프론트) 트랙 분리.

**Phase 0 (CONFIRM 선결)**: CONFIRM-A(타공수 detail·proc_cd 105 전송)·CONFIRM-4(각목 세로/가로 vs 900임계)·CONFIRM-B(린넨마감 opt_cd)·CONFIRM-C(족자 bdl_qty) 실무진 확정.

**데이터 트랙(dbm-load-execution·FK 위상순서)**:
1. **CPQ 옵션 선행**(t_prd_product_options/option_items): 메쉬 큐방·끈 / PET S1·S2 / 캔버스행잉 우드행거 / 린넨우드봉 우드봉 / 족자 천정고리 신규 옵션 등록(search-before-mint·채번 MAX+1).
2. **comp use_dims 충전**(t_prc_price_components): 빈 `[]`→opt_cd/proc_cd 판별차원. RC-4 차원 정정(우드행거 siz_cd·린넨마감 opt_cd 재배선).
3. **단가행 판별값 충전**(t_prc_component_prices): opt_cd/proc_cd/dim_vals 채움·단가 verbatim 불변. 각목(b) 통합 시 2행 siz_width=900/NULL.
4. **공식 바인딩**(t_prc_formula_components): addtn_yn=Y로 각 상품 공식에 comp 연결(disp_seq).
5. **좀비 정리**: PUNCH_6/8(일반)·각목 부모 껍데기 use_yn=N.

**코드 트랙(§6/webadmin·별 트랙·§21 범위 밖)**:
6. 시뮬레이터 호출자(위젯/프론트)가 옵션 선택→procs=[{proc_cd:PROC_000105,detail:{타공수:N}}] / selections={opt_cd:...} 구성 전송(CONFIRM-A 전제). ★데이터만 채워도 호출자가 안 보내면 미작동.

---

## ⑦ 미해결 CONFIRM

- **CONFIRM-A (타공 detail 전송·proc_cd 불일치)**: PUNCH_4 단가행 proc_cd=PROC_000105인데 옵션 ref_dim(_opt_maps)은 PROC_000104로 환원하고 **타공수 detail 없이 공정코드만** 넘김(price_views.py:1390). 시뮬레이터가 정확 매칭하려면 호출자가 procs=[{proc_cd:**PROC_000105**, detail:{타공수:N}}]를 직접 보내야 함. proc_cd를 105로 통일할지(데이터) vs 호출자가 105 전송(코드)인지 실무진 확정.
- **CONFIRM-4 (각목 의미축)**: CPQ="각목(세로)/각목(가로)"(OPV_000015/016) ↔ 권위="900이하/900초과". 세로/가로≠900임계. 무엇이 권위인지·각목 가격이 변길이로 결정되는지 실무진 컨펌. 확정 전 각목 BLOCKED.
- **CONFIRM-B (린넨마감 opt_cd)**: LINEN_FINISH 단가행 opt_cd=OPV-000024~424 ↔ 상품(133/134) 옵션 OPV_000029/031. 단가행이 어느 상품 옵션을 가리켜야 하나(재배선 방향) 확정.
- **CONFIRM-C (족자 천정고리 bdl_qty)**: 단가행 bdl_qty=2·6500. bdl_qty(묶음수)가 천정고리 판별에 맞는 차원인지(opt_cd가 더 적합) 확정.
- **CONFIRM-D (각 상품 본체 공식 frm_cd)**: PET/캔버스행잉/린넨우드봉의 본체 공식 frm_cd가 addtn_yn=Y 바인딩 대상으로 확정됐는지(공식 바인딩 라이브 추가 실측 필요분).

---

## 판정

**분석·설계·명세까지 GO.** 핵심: ① 엔진 차원 메커니즘은 이미 충분(코드 변경 불요·데이터 충전 일) ② 재계산으로 빈 차원=always-add 결함·각목=12000 이중합산 확정·설계후 정확 단가만 가산 입증 ③ CPQ 옵션 완비=일반현수막뿐, 나머지 6상품은 CPQ 선행 후 BLOCKED ④ CONFIRM-A~D 미해결.
데이터 트랙은 CONFIRM 확정 + dbm-validator 독립 재실측 후 적재. **DB 미적재·단가 verbatim·search-before-mint·날조 0.**
