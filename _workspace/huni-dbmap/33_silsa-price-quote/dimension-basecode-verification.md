# 실사(포스터사인) 차원 → 기초코드 표현 검증 + 옵션/제약 후보 + 공정상세옵션 누락 — round-23

> **작성** 2026-06-17 · round-23. **★최신 차원 모델 기준**(webadmin 2026-06-17 변경: plt_siz_cd 추가·clr_cd→print_opt_cd·proc_sel→proc_grp+상세옵션 상위 상속·Phase11 엔진). 입력 = `webadmin-change-mapping.md`(change-tracker)·`grouping-model-design.md`(GO)·git log/diff·라이브 read-only psql 실측.
>
> **적재/정정 실행 안 함**(이후 단계). 차원 검증·구성 설계·누락 발굴 전용. DB 쓰기 0·비밀값 비노출. 생성자≠검증자.

---

## 0. 핵심 5줄

1. **새 차원 모델 라이브 확정:** 자연키 = **12컬럼 + dim_vals**(`ux_t_prc_comp_prices_nat_key`: comp_cd·apply_ymd·siz_cd·**plt_siz_cd**·clr_cd·mat_cd·proc_cd·opt_cd·**print_opt_cd**·coat_side_cnt·bdl_qty·min_qty·dim_vals). 실사 면적매트릭스 사이즈축은 **siz_cd 유지**(plt_siz_cd는 인쇄비/별색 전용·실사 무영향 → A안 유효).
2. **실사 차원 기초코드 표현 = 대부분 가능.** 가로×세로→siz_cd(✅·106 신규 채번)·별색색→proc_cd(✅)·인쇄면→print_opt_cd(✅·새 모델)·후가공종류→proc_cd(✅)·줄수/개수→dim_vals+prcs_dtl_opt(✅)·수량구간→min_qty(✅). **불가/부분 = 거치대/우드행거 등 부속 add-on(가격영향이나 기초코드 아님)·타이벡 하드/소프트 변형·off-grid ceiling(런타임)**.
3. **가격영향 비기초코드 차원 = 옵션/제약 후보 5건:** 거치대 4택1(배너)·추가옵션 부속(천정고리/우드행거/우드봉/끈/큐방)·현수막 가공옵션(타공/봉제/재단)·타이벡 하드/소프트·수량구간 종속. → CPQ 옵션/템플릿/제약으로 dbm-option-mapper 인계.
4. **공정상세옵션 상속 모델 확정(eb1e0ce):** `t_proc_processes.prcs_dtl_opt jsonb`가 상위에 1개·자식 상속. 오시(PROC_000029)=`{줄수 max3}`·가변데이타(85)=`{개수 max3}` 보유, 자식 EMPTY(상속). **별 테이블 없음.**
5. **공정상세옵션 누락 발굴:** 🔴 **미싱(PROC_000030)에 prcs_dtl_opt 부재**(오시는 줄수 보유인데 미싱은 EMPTY) — 미싱 줄수 상세옵션 누락. 🟡 귀돌이(26)·직각/둥근=상세옵션 없음(형상=종류 자체라 정상). 🔴 포스터 본체 comp use_dims=`["siz_cd"]`만 → **후가공(오시/미싱/귀돌이/가변) 견적 차원 미배선**(실사에 후가공 붙으면 조회 불가).

---

## 1. 차원 → 기초코드 표현 검증표 (포스터사인 전 차원)

| 차원 | 출처(가격표) | 목표 기초코드 | 판정 | 근거(라이브 실측) |
|------|-------------|--------------|:--:|------|
| **가로×세로 사이즈** | 면적매트릭스 13블록 | `t_siz_sizes.siz_cd`(work/cut 수치) | ✅ 가능 | 112 distinct 좌표 → EXACT 4+REVERSED 2 재사용·NONE 106 신규(SIZ_000518~623). 가격엔진 siz_cd 매칭 |
| **규격(A시리즈·5x5 등)** | 고정가/밴드 블록 | `t_siz_sizes.siz_cd` | ✅ 가능 | round-2 §6.5 전건 라이브 실존(A1~A5·5x5~590x390·600x1800). 신규 0 |
| **판형사이즈(전지)** | (실사 본체 없음·인쇄비 전용) | `t_prc_component_prices.plt_siz_cd`(impos_yn='Y') | ✅ 가능(실사 미사용) | 1,219행 백필·distinct 2(전지 316x467·300x625). 실사 면적은 plt 0건 |
| **별색 색(화이트/클리어/핑크/금/은)** | 별색 add-on | `t_proc_processes.proc_cd`(PROC_000008~012, 부모 별색인쇄 PROC_000007) | ✅ 가능 | SPOT comp 색축=proc_cd 실측(GOLD=011·CLEAR=009…). clr_cd 단가차원 폐기(0행) |
| **인쇄면(단/양면/풀빼다/배면)** | 인쇄옵션 | `t_prt_print_options.print_opt_cd`(7행) → 단가 print_opt_cd | ✅ 가능(새 모델) | POPT_000001~007·front/back_colrcnt_cd→t_clr 참조. 메모리 G-1/G-2 RESOLVED |
| **도수(앞/뒤 색수)** | 인쇄옵션 내부 | `t_prt_print_options.front/back_colrcnt_cd`→`t_clr_color_counts` | ✅ 가능 | print_opt 마스터가 도수 흡수(단가차원은 print_opt_cd) |
| **후가공 종류(오시/미싱/귀돌이/가변)** | add-on | `t_proc_processes.proc_cd`(proc_grp 그룹+하위) | ✅ 가능 | 오시 29·미싱 30·귀돌이 26·가변 85 그룹 트리 실측. proc_grp 모델(35 use_dims 토큰) |
| **오시 줄수 / 가변 개수** | add-on 파라미터 | `dim_vals` jsonb + `prcs_dtl_opt`(상위 상속) | ✅ 가능 | CREASE_1L dim_vals.줄수 1/2/3·오시 prcs_dtl_opt={줄수 max3}·가변={개수 max3} |
| **미싱 줄수** | add-on 파라미터 | `dim_vals`(목표) | 🟡 **부분** | dim_vals 가능하나 **prcs_dtl_opt 누락**(미싱 30 EMPTY·§3) + 1L/2L/3L 혼재·prc_typ .02 불일치 |
| **수량구간** | 밴드 블록 | `min_qty`(상향개방) | ✅ 가능 | use_dims `["siz_cd","min_qty"]`·미니류 5구간(4/19/49/99/10000) |
| **소재(인화지/PET/PVC/패브릭…)** | 매트릭스 제목 | comp_cd 분기(mat_cd 미사용) | ✅ 가능 | COMP_POSTER_<MAT> 별 comp(소재명 박힘). 면적단가 통가 |
| **색변형(폼보드 화이트/검정)** | 이산표 | comp_cd 분기(가격상이) 또는 mat_cd | ✅ 가능 | round-2: board 전용 색자재 부재→per-색 comp. 동일가는 단일 comp |
| **타이벡 하드/소프트 변형** | 매트릭스 제목 | (불명) | 🔴 **부분/불가** | 1 comp에 변형구분 불명(§2 옵션 후보). 가격동일/상이 미확정 |
| **거치대/우드행거/우드봉/천정고리/끈/큐방** | add-on 테이블 | (기초코드 아님·부속) | 🔴 **불가→옵션** | COMP_POSTEROPT_* 별 comp 합산. 선택 종속(§2 옵션 후보) |
| **현수막 가공옵션(타공/봉제/재단)** | add-on 테이블 | proc_cd(공정) but 선택종속 | 🟡 **부분→옵션+제약** | proc_cd로 종류는 잡히나 "선택 시 가산"은 제약(§2) |
| **off-grid(격자 외 사이즈)** | (런타임) | (DB 미저장) | ➖ N/A | ceiling=엔진/위젯 런타임. DB는 격자 siz만(메모리) |

**요약:** 가격을 가르는 **단가 차원**은 전부 기초코드/dim_vals로 표현 가능(siz_cd·proc_cd·print_opt_cd·dim_vals·min_qty·plt_siz_cd). **불가/부분 = 선택 종속·조합 제약·변형 구분**(=옵션/제약 영역, §2). 미싱 줄수는 dim_vals 가능하나 상세옵션 메타 누락(§3).

---

## 2. 가격영향 차원 → 옵션/템플릿/제약 후보 (dbm-option-mapper 인계 입력)

기초코드로 단가는 표현되나, **"언제 그 단가가 더해지는가"(선택 종속·조합 제약)**는 CPQ 레이어가 담당. 후보:

| # | 차원 | 왜 기초코드 불가 | 후보 엔티티 | 구성 힌트 |
|---|------|------------------|------------|----------|
| **CPQ-1** | **배너 거치대 4택1**(없음/실내/실외단면/실외양면) | 상호배타 택1 + 선택 시 add-on 단가 가산. 기초코드는 "선택 여부"를 모름 | `option_groups`(택1) + `options` + `option_items`(→COMP_POSTEROPT_PET_BANNER_STAND_* 참조) | ref_dim_cd로 comp 참조·택1 그룹 |
| **CPQ-2** | **추가옵션 부속**(천정고리·우드행거+면끈·우드봉+면끈·끈·큐방) | 본체와 별개 선택·가산. 부속=완제품 추가요소 | `option_groups`(택N) + option_items(→COMP_POSTEROPT_* 합산) | 본체 comp + 옵션 comp formula_components addtn_yn=Y |
| **CPQ-3** | **현수막 가공옵션**(타공4/6/8·봉제·재단·양면테이프) | 공정은 proc_cd로 표현되나 "선택 가산·다중선택" 로직 필요 | `option_groups`(택N) + `constraints`(공정 양립) | 가공옵션=proc_cd 종류축 + 선택 시 가산 |
| **CPQ-4** | **타이벡 하드/소프트** | 1 comp에 변형 불명·가격 동일/상이 미확정 | 변형: 가격동일→option(가격무관 택1) / 가격상이→별 comp 또는 mat_cd | 컨펌 후 분기(Q-D2) |
| **CPQ-5** | **수량구간 종속(밴드)** | min_qty는 기초코드 아닌 단가행 차원이나, UI 수량입력→구간매칭은 엔진/제약 | (엔진 처리·option 아님) min_qty 차원 + constraint_json(min/max/incr) | t_prd_products 수량규칙 + 엔진 |

> **인계 메모(option-mapper):** CPQ-1~3은 라이브에 **COMP_POSTEROPT_* 별 comp로 단가는 이미 적재**(grouping-model 종류축=proc/별comp). 미적재 = **option_groups/options/option_items 레이어**(L2)와 **선택→가산 배선**. ref_dim_cd로 comp 참조하는 polymorphic 패턴(메모리 [[dbmap-cpq-option-layer-mapping]]). 상호배타=L2 택1(가격구성요소 통합과 무관·grouping-model P-4 정정).

---

## 3. 공정상세옵션 누락 보드 (proc_grp 상속 모델·eb1e0ce)

### 3.1 상속 구조 (라이브 실측)

- 모델 = `t_proc_processes.prcs_dtl_opt jsonb`. **별 테이블 없음**(`%proc%opt%` 0건). 상위에 1개 두면 자식이 **상속**(자기 있으면 override).
- 실측: 오시(PROC_000029)=`{"inputs":[{"key":"줄수","max":3,"min":0,"type":"integer","unit":"줄"}]}` / 가변데이타(85)=`{"key":"개수","max":3}`. 자식(오시90·텍스트31·이미지32) prcs_dtl_opt EMPTY → 상위 상속.

### 3.2 누락 보드 (실사 견적 필요 vs 라이브 현황)

| 공정 | 상세옵션 필요 | 라이브 prcs_dtl_opt | 누락 | 등급 |
|------|--------------|---------------------|------|:--:|
| **오시(PROC_000029)** | 줄수 1~3 | ✅ `{줄수 max3}`(상위) | 없음 | OK |
| **가변데이타(PROC_000085)** | 개수 1~3 | ✅ `{개수 max3}`(상위) | 없음 | OK |
| **미싱(PROC_000030)** | 줄수 1~3(오시 동형) | 🔴 **EMPTY**(부모·자식 086 둘 다) | **줄수 상세옵션 미설정** | 🔴 |
| **귀돌이(PROC_000026)** | 형상(둥근/직각) | EMPTY(직각27·둥근28도 EMPTY) | 형상=하위공정 자체(종류축)라 상세옵션 불요 | OK(설계상) |
| **별색인쇄(PROC_000007)** | 색(화이트/클리어/핑크/금/은) | (색=하위공정 008~012) | 색=하위공정(proc_cd 종류)라 상세옵션 불요 | OK |
| **박(PROC_000033)** | 박색·면적등급 | 미실측(별트랙) | 박 17자식=종류·면적등급=앱계산(메모리) | 🟡 별트랙 |

### 3.3 핵심 누락 2건

- 🔴 **G-D1 미싱 줄수 상세옵션 누락:** 오시(줄수 max3)와 동형인데 미싱(PROC_000030)은 prcs_dtl_opt EMPTY. grouping-model C-4(미싱 통합·prc_typ .02→.01)와 연동 — **미싱 부모(30)에 `{줄수 max3}` 상세옵션 설정 필요**(상속으로 자식 086 자동). 이게 있어야 dim_vals.줄수 입력 UI·검증 성립.
- 🔴 **G-D2 포스터 본체 comp 후가공 미배선:** COMP_POSTER_ARTPRINT_PHOTO·BANNER_NORMAL use_dims=`["siz_cd"]`만 → 오시/미싱/귀돌이/가변을 실사에 붙일 경로 없음(공식 배선 부재·silsa-quote §4 가격사슬 단절과 동근). 실사 후가공 견적하려면 후가공 comp를 공식에 add-on 배선(addtn_yn=Y).

> 미싱 줄수는 §1에서 "🟡 부분"(dim_vals 가능·prcs_dtl_opt 누락)으로 판정한 그 근거. 누락 해소 = prcs_dtl_opt 1행 설정(상속 모델 활용·과적 0).

---

## 4. 새 차원 모델이 실사 트랙에 주는 영향 (요약)

| 변경 | 실사 영향 |
|------|----------|
| plt_siz_cd 추가 | **무영향** — 실사 면적=siz_cd 유지(plt 0건). A안 그대로 |
| clr_cd→print_opt_cd | 실사 본체 무영향(소재 통가). 별색 add-on은 proc_cd(색)+print_opt_cd(면) 모델 적용 |
| proc_sel→proc_grp | 후가공 add-on 공정을 proc_grp(그룹+하위) 모델로 배선해야 정합 |
| prcs_dtl_opt 상속 | 오시/가변 OK·미싱 누락(G-D1) |
| Phase11 엔진 | **공식 경로 열림** — 실사 단가행(siz_cd) 채우면 견적 산출 가능(직접/템플릿단가 0행이라 공식만 실효) |

---

## 5. 미해소 컨펌

| ID | 컨펌 | 권고 |
|----|------|------|
| Q-D1 | 미싱 prcs_dtl_opt 줄수 설정(상속) | 미싱 부모 30에 {줄수 max3}(오시 동형) |
| Q-D2 | 타이벡 하드/소프트 = option(가격동일) vs 별 comp/mat_cd(상이) | 가격 실측 후 분기 |
| Q-D3 | 실사 후가공 add-on 배선 = 공식 합산(addtn_yn) vs CPQ | 합산(라이브 선례·option add_price 부재) |
| Q-D4 | 현수막 가공옵션 다중선택 제약 로직 | constraints(JSONLogic) option-mapper |

---

## 6. read-only 준수

- 라이브 SELECT만(자연키 12컬럼·print_options 7행·별색 새모델·proc 트리·prcs_dtl_opt 상속·포스터 use_dims) + webadmin git show(커밋 5건 실재). INSERT/UPDATE/DDL/COMMIT 0. 비밀값 미출력.
- 적재/정정 실행 안 함(이후). 옵션/제약 구체 구성은 dbm-option-mapper 인계(§2 입력 명세). GO는 dbm-validator.
