# webadmin 메뉴 전수 지도 — 엽서북(PRD_000094) 화면 0원의 "메뉴-우선" 재진단 (2026-07-02)

> 목적: 코드 수정을 피하고 **webadmin 메뉴에서 데이터 등록/수정만으로** 엽서북 셋트 시뮬레이터 0원을
> 해소할 수 있는지, 전 메뉴를 "셋트 가격 경로에 영향 주는가" 렌즈로 전수 분석.
> 근거: `raw/webadmin/webadmin/` 최신 소스(파일:라인) + §8 admin 매뉴얼 화면맵(`_workspace/huni-admin-manual/01_source_admin-screen-map.md`).
> 라이브 읽기전용 — 이 문서는 지도·후보 도출까지(등록/수정 실행 없음).

---

## 0. 먼저 알아야 할 것 — §8 화면맵(6/10)과 달라진 점 (stale 정정)

§8 화면맵은 2026-06-10 기준이라 그 뒤 추가된 메뉴가 빠져 있다. 현재 소스(`config/settings.py:95-177`, `config/urls.py`) 기준으로:

| §8에 없던 것 | 지금 상태 | 의미 |
|---|---|---|
| **셋트상품 관리** 메뉴 | `views.py:654 set_products` + 상품정보 changeform에 **셋트 구성 인라인 부착**(`admin.py:1238` `inlines=[ProductCategoriesInline, ProductSetsInline]`) | §8의 "F-2: `t_prd_product_sets`는 어느 화면에서도 편집 불가" → **이제 메뉴에서 편집 가능** |
| **가격 뷰어** 메뉴 + 저장 API | `price_views.py:995 price_source_save` — kind=`price`/`formula`/`discount`/`tmpl_price` add/del | §8의 "F-2: `t_prd_product_price_formulas`(공식 바인딩)·`t_prd_product_prices`(직접단가)·`t_prd_product_discount_tables` 편집 불가" → **가격 뷰어 상품 상세에서 추가/삭제 가능** |
| **가격 시뮬레이터** 메뉴 | `price_views.py:2002 price_simulator` (계산 전용 화면) | 이번 진단의 무대 |
| 가격공식MD/가격구성요소MD/할인테이블MD | 읽기전용 문서 화면 | 데이터 훅 아님 |
| 인쇄옵션 메뉴 | `t_prt_print_options` changelist | 양면 판정(chnl_cnt) 데이터 훅 |
| 단가 그리드 | `price_views.py:802 price_grid_save` — `t_prc_component_prices` 엑셀형 편집 | 단가행 셀은 메뉴에서 편집 가능 |

여전히 **어느 메뉴에서도 편집 불가(DB 전용)**: `t_prc_formula_components`(공식↔구성요소 배선 — price_views 전체에서 읽기만, 쓰기 endpoint 0), `t_dsc_grade_discount_rates`, `t_siz_pansu`(판걸이수 lookup).

---

## 1. 메뉴 전수 인벤토리 × 셋트 가격 경로 영향

시뮬레이터 셋트 경로 = `sim_meta`(입력 메타) → `simulate-set`(`price_simulate_set`) → `evaluate_set_price` → 구성원별/셋트공식별 `evaluate_price`.

| # | 메뉴(사이드바) | 등록/수정 가능한 데이터 | 셋트 가격 경로 영향 | 엽서북 관련 비고 |
|---|---|---|---|---|
| 1 | 상품정보 | `t_prd_products`(수량규칙 min/max/incr/dflt·비규격·semi_role) + 인라인 `t_prd_product_categories`·**`t_prd_product_sets`(셋트 구성)** | **예** — 셋트 구성 행 존재 여부가 `is_set` 분기 자체를 결정(`price_views.py:1760-1765`) | 094 셋트 구성 2행(095/096)이 여기서 편집됨 |
| 2 | 상품 뷰어 | 9섹션(`t_prd_product_sizes/materials/print_options/plate_sizes/processes/bundle_qtys/addons/page_rules/categories`) + CPQ 옵션 3계층 + SKU 2계층 + 제약 | **예** — 드롭다운 옵션 전부(`_dim_options`:1378·`_set_members_meta`:1685)·판형 자동선택(:1614)·페이지룰(:1348) | R1-D1/D2 교정이 이 메뉴 영역(이미 완료) |
| 3 | 셋트상품 관리 | `t_prd_product_sets`(상품 changeform iframe의 셋트 구성 인라인) | **예** — 위 1과 동일 테이블 | 셋트 해제/구성 변경의 공식 화면 |
| 4 | 추가상품 템플릿 | `t_prd_templates`+`t_prd_template_selections` | 셋트 경로 **아니오**(simulate-set body에 tmpl_cd 없음) — 단일상품 경로·addon만 | 템플릿 직접단가 훅은 셋트에서 못 씀 |
| 5 | 카테고리 | `t_cat_categories` | 간접(등급할인 주카테고리 :1487) | 0원과 무관 |
| 6 | 자재정보 | `t_mat_materials` | 예(자재 드롭다운 라벨·mat_cd 차원값) | 정상 |
| 7 | 사이즈정보 | `t_siz_sizes`(작업/재단 치수) | **예** — `fn_calc_pansu` 기하 폴백·사이즈 마스터 | 판걸이 9 정상 |
| 8 | 도수정보 | `t_clr_color_counts`(chnl_cnt) | **예** — 양면 판정 `_print_sides`(:1598, back_colrcnt_cd→chnl_cnt) | 정상 |
| 9 | 인쇄옵션 | `t_prt_print_options` | **예** — 단/양면 차원 + sides | 정상 |
| 10 | 공정정보 | `t_proc_processes`(트리·상세입력 JSON) | **예** — proc 드롭다운(:1408)·셋트공정 | 엽서북 셋트공식은 proc 차원 없음 |
| 11 | 기초코드정보 | `t_cod_base_codes`(SEMI_ROLE·GRADE·PRD_TYPE…) | **예** — 내지 판정(SEMI_ROLE.01→파생수량 :1734)·등급 | 정상 |
| 12 | 가격공식 | `t_prc_price_formulas`(공식 마스터 행) | **예** — 현재공식 해석(:1285) | PRF_PCB_FIXED 존재 |
| 13 | 가격공식MD / 가격구성요소MD / 할인테이블MD | (읽기전용 문서) | 아니오 | — |
| 14 | 가격구성요소 | `t_prc_price_components` — **`use_dims`(JSON 필드, models.py:227) 포함 전 필드 changeform 편집 가능** | **예** — use_dims가 차원 요구(dim_union :1304)와 단가 매칭 판별축 | siz_cd 제거 유혹 = 후보 D(아래, 막힘) |
| 15 | 구성요소 다차원 단가(표준) + 가격 뷰어 단가 그리드 | `t_prc_component_prices`(행 단위 / 엑셀형 `price_grid_save`:802) | **예** — 단가행 매칭 원천 | 468행 완비·verbatim(수정 금지) |
| 16 | **가격 뷰어** | **`price_source_save`(:995): `t_prd_product_prices` 직접단가 · `t_prd_product_price_formulas` 공식 바인딩 · `t_prd_product_discount_tables` 할인 연결 · `t_prd_template_prices` 템플릿단가 — 상품별 add/del** | **예 — 가장 강력한 가격 훅** | 공식 바인딩을 메뉴에서 옮기는 것 "가능"(후보 A/B의 무대) |
| 17 | 할인테이블(수량구간) + 할인 그리드 | `t_dsc_discount_tables`·`t_dsc_discount_details`(full-sync 그리드 :1100~) | 예 — 합산 후 곱셈(`_quantity_discount`:714) | **base 0엔 무력**(0×할인=0) |
| 18 | 가격 시뮬레이터 | (계산 실행 전용 — 쓰기 없음) | 무대 | — |
| 19 | 고객 / 사용자·그룹 / 문서 3종 | `t_cus_customers`·auth·정적 문서 | 아니오 | — |

---

## 2. 셋트 시뮬레이터 가격 경로가 읽는 데이터 지점 전수 (훅 지도)

"여기에 데이터를 넣으면 경로가 바뀐다"는 지점 전부. (파일:라인 = `raw/webadmin/webadmin/catalog/`)

### 2-1. sim_meta (`price_views.py:1757 price_sim_meta` → `:1277 _build_sim_meta` + `:1685 _set_members_meta`)

| 데이터 지점 | 코드 | 경로에 미치는 효과 |
|---|---|---|
| `t_prd_product_prices` 존재 여부 | :1284 | 있으면 source_hint=PRODUCT_PRICE(직접단가 우선 신호) |
| `t_prd_product_price_formulas`(부모) | :1285-1287 | 현재공식 결정(최신 apply_bgn_ymd) |
| `t_prc_formula_components` → `t_prc_price_components.use_dims` | :1297-1322, :1371 | **차원 합집합(dim_union)=조건 UI에 뜰 드롭다운 목록** + opt_grp/proc_grp 범위 |
| `t_prd_product_sizes/plate_sizes/print_options/materials/options/bundle_qtys/processes`(부모) | :1378-1459 `_dim_options` | 각 차원 드롭다운 옵션(0건이면 그 차원 숨김) |
| `opt_groups = []` 하드코딩 | **:1480** | CPQ 옵션그룹 시뮬레이터 비노출(2026-06-28 설계결정) — **데이터로 재활성 불가** |
| `t_prd_products` 수량 필드·`t_prd_product_sizes` 사이즈별 수량·`t_prd_product_page_rules` | :1340-1351 | 부수 기본값·페이지 입력 범위 |
| `t_cod_base_codes`(GRADE.*)·`t_prd_product_categories`+`t_dsc_grade_discount_rates` | :1482-1493 | 등급 드롭다운·등급 반영 여부 |
| `t_prd_templates`+`t_prd_template_prices`·`t_prd_product_addons` | :1495-1522 | 템플릿/추가상품(셋트 경로 미사용) |
| **`t_prd_product_sets`(del_yn=N)** | :1691 | **행 있으면 is_set=True → 셋트 UI, 0행이면 단일상품 UI**(:1760-1765) |
| 구성원 자신의 `sizes/materials/print_options`(sub_prd_cd 기준) | :1698-1749 | 구성원별 드롭다운(R1-D1에서 채움) |
| 구성원 `t_prd_product_page_rules`(없으면 부모 페이지룰, 내지만) | :1736-1739 | 페이지수 입력 |
| **부모(셋트) `t_prd_product_plate_sizes`** | :1722 (docstring "셋트 완제품 기준") | 판형 후보(R1-D2에서 채움) |
| 구성원 `t_prd_product_price_formulas` 존재 | :1752 has_formula | "공식無" 배지(정보성) |
| `t_prd_products.semi_role_cd`(SEMI_ROLE.01) | :1732-1734 | 내지 판정 → 파생수량 모드 |

### 2-2. simulate-set (`price_views.py:1888 price_simulate_set`)

| 데이터/입력 지점 | 코드 | 효과 |
|---|---|---|
| **member 복사 화이트리스트 = `("siz_cd","mat_cd","print_opt_cd")`** | **:1930-1933** | member.selections로 넘어가는 차원 이 3개뿐. **opt_cd·coat_side_cnt 등은 member 경로로 전달 불가** |
| member `plt_siz_cd`(수동) 또는 `_select_default_plate(부모 prd_cd, siz_cd)` | :1952-1955, :1614 | 판형 → `sel["plt_siz_cd"]`(:1963) — **부모 `t_prd_product_plate_sizes`만 읽음** |
| `fn_calc_pansu(판형, 내지사이즈)`(DB 함수·`t_siz_pansu` lookup→기하) | :1547, :1960 | 판걸이수 → 총내지매수 `derive_inner_sheets`(pricing.py:820) |
| `_print_sides` ← `t_prt_print_options.back_colrcnt_cd`→`t_clr_color_counts.chnl_cnt` | :1598, :1958 | 단/양면 → 파생수량 절반 |
| **set_selections = body 그대로**(백필 없음) | **:1987-1988** | 셋트공식이 받을 차원 — 프론트 JS가 조립 |
| 프론트 setSel 조립: `if(d.name==="proc_cd"||d.name==="siz_cd") continue;` | **price_simulator.html:722**(UI 렌더도 :635에서 siz_cd 제외) | **siz_cd가 서버로 갈 통로 자체가 없음** ← 0원의 결정 축 |
| (참고) 옵션그룹 `maps.dims` → setSel 주입 루프 | price_simulator.html:733 | 이론상 어떤 차원이든 주입 가능하나 **:1480 `opt_groups=[]`로 사장**(데이터로 못 켬) |
| opt_cd(20P/30P)는 setSel에 정상 포함 | :635 others에 opt_cd 포함(:1396 frm_opt_grps 한정 드롭다운) | 셋트공식에 opt_cd는 전달됨(주입 A/B 실증과 정합) |

### 2-3. evaluate_set_price / evaluate_price (`pricing.py`)

| 데이터 지점 | 코드 | 효과 |
|---|---|---|
| 구성원별 `evaluate_price({"prd_cd":sub}, member.selections, 유효수량)` | pricing.py:904 | 구성원 기여(095/096은 공식 0행 → 기여 0 = all-in 설계 정합) |
| **셋트공식 = `evaluate_price({"prd_cd":셋트}, set_selections, 부수)`** | **pricing.py:920** | 부모 공식이 set_selections만 보고 계산 — siz_cd 없으면 COMP_PCB_* 4개 전부 미매칭 → 0 |
| evaluate_price 가격 소스 우선순위: ① `t_prd_template_prices`(:441, tmpl 타깃만) ② **`t_prd_product_prices` 직접단가(:461 — 공식보다 우선!)** ③ `t_prd_product_price_formulas`→`t_prc_price_formulas`→`_evaluate_formula`(:469-479) | pricing.py:434-479 | **094에 직접단가를 넣으면 공식을 영구히 가림**(후보 B의 함정) |
| `_evaluate_formula`: `t_prc_formula_components`+`t_prc_price_components(use_dims·prc_typ)`+`t_prc_component_prices` 매칭(`match_component`:134), plt_siz_cd면 판수 환산(:287 `_calc_pansu`) | pricing.py:643~ | 판별차원 값이 다른 행이 여럿 매칭되면 ERR_AMBIGUOUS 합산 제외(:603) |
| 할인: `t_prd_product_discount_tables`→`t_dsc_discount_tables`→`t_dsc_discount_details`(:714-742) · `t_prd_product_categories`+`t_dsc_grade_discount_rates`(:744~) | pricing.py:938-945 | 합산 후 곱셈 — base 0엔 무력 |

---

## 3. "메뉴 등록/수정만으로 0원 해소" 후보 전수 판정

### 후보 A — 공식 바인딩을 부모(094)→내지(095) member로 이동 · **막힘(BLOCKED)**
- **메뉴에서 가능한가**: 가능. 가격 뷰어 상품 상세 → `price_source_save kind="formula"`(price_views.py:1027-1039)로 095에 PRF_PCB_FIXED add, 094에서 del.
- **member 경로가 siz_cd를 받는가**: 받음 — 화이트리스트 `("siz_cd","mat_cd","print_opt_cd")`(:1930) 통과. 여기까진 좋다.
- **왜 막히나 ①**: **opt_cd(20P/30P)가 화이트리스트에 없다**(:1930 — 정확히 3개뿐). COMP_PCB_* 4개 전부 use_dims에 `opt_cd`+`opt_grp:OPT_000082`를 요구 → member 경로에선 opt_cd 영구 미전달 → 미매칭(0) 또는 20P/30P 두 행 동시매칭 ERR_AMBIGUOUS(pricing.py:603) 합산 제외. **UI에도 member 카드에 opt_cd 입력 자체가 없다.**
- **왜 막히나 ②**: 내지는 파생수량 모드 — member qty=총내지매수(부수×⌈페이지/판걸이⌉, :1961). 단가행 min_qty 밴드는 "부수"(2~100+) 기준이라 수량축도 어긋남(100부→총내지매수 200~400장 → 밴드 오매칭·과소청구).
- **왜 막히나 ③(권위)**: 이를 피하려고 opt_cd 없는 member 전용 공식/단가표를 새로 만들면 권당 완제품가(권위 단일표)를 장당가로 역산 분해해야 함 = **단가 날조 금지 위반**.
- 결론: **부모→자식 공식 분리는 메뉴로 조작 자체는 가능하나, 시뮬레이터 member 경로 계약(화이트리스트·파생수량)과 권위 표 구조가 이중으로 막는다. Q1의 답 — 매핑이 잘못된 게 아니라(권당 완제품가=부모 all-in이 권위 그대로), 셋트 경로가 siz_cd를 안 실어주는 게 결함.**

### 후보 B — 094에 직접단가 등록(가격 뷰어 kind="price") · **부적격(권위 위반+회귀 함정)**
- 기술적으로는 화면 0원이 사라짐: evaluate_price가 직접단가를 공식보다 먼저 읽어(pricing.py:461-466) unit_price×부수를 냄.
- 위험: ① 사이즈 3종×20P/30P×단/양면×수량밴드(468행)가 **단일 unit_price로 붕괴** — 450,000은 특정 조합(SIZ_000003·100부·단면·20P)만 맞고 나머지 전 조합 오가격 = 권위 위반. ② **직접단가가 공식을 영구히 가림** — 나중에 C트랙이 착지해 siz_cd가 전달돼도 공식이 안 돌아감(조용한 회귀 함정). ③ 수량밴드 비선형(2부 11,000→100부 4,500)이라 선형 unit×qty 자체가 구조 불일치.
- 결론: 등록 금지 권고.

### 후보 C — 셋트 구성 해제: `t_prd_product_sets` 2행 제거(셋트상품 관리/상품정보 인라인) · **유일하게 "정확한 450,000"이 나오는 데이터 경로 — 그러나 고위험·인간 결정 사안**
- 원리: 셋트 구성 0행 → `price_sim_meta` is_set=False(:1760-1765) → 시뮬레이터가 **단일상품 UI(buildCond)** 사용 → siz_cd 드롭다운 정상 렌더·전송(price_simulator.html:452) → `price_simulate`→`evaluate_price`에 siz_cd·opt_cd·print_opt_cd·수량 전부 도달 → **A/B 실증과 동일 조건으로 450,000 verbatim**. 판형도 단일 경로 자동선택(:1821-1826, 부모 판형 SIZ_000499 사용) — 엔진·단가·차원 전부 기존 그대로.
- 위험(중대): ① **상품 유형 분류 SOT[HARD] 위반** — "셋트 완제품/일반 단일 구분 = `t_prd_product_sets` 부모 등록 여부"(CLAUDE.md §1). 엽서북은 권위상 셋트 완제품(내지 095+표지 096) — 구성 해제는 094를 일반 단일로 격하시키는 **역방향 교정(금지)**. ② §23 셋트 19개 전수진단(18/19 GO에 094 포함)·셋트 대시보드·위젯 컨버전 트랙이 셋트 구조를 입력으로 씀 — 회귀. ③ 구성원 파생수량(페이지→내지매수)·생산 BOM 표시 소실. ④ 인라인 삭제는 **물리 DELETE**(ProductSetsInline can_delete 기본 True — 논리삭제 전환 코드 없음) — 복구는 백업 필요.
- 결론: "메뉴만으로 화면 0원 해소"가 목적이라면 이것이 유일 경로이나, **분류 SOT·타 하네스 회귀 비용이 화면 표시 개선보다 크다.** 채택하려면 인간 승인 + 094 백업 + '임시 조치·C트랙 착지 시 원복' 조건 필수.

### 후보 D — 가격구성요소 use_dims에서 siz_cd 제거(가격구성요소 changeform, JSON 직접 편집 가능) · **막힘(BLOCKED)**
- use_dims는 메뉴에서 편집 가능(표준 changeform 전 필드 노출·models.py:227 JSONField).
- 왜 막히나: siz_cd를 빼도 단가행 468행에는 사이즈 3종 값이 그대로 → 같은 (min_qty, print_opt, opt) 조합에 3행 매칭 → **ERR_AMBIGUOUS "동시매칭 — 데이터 오류, 합산 제외"(pricing.py:603-604) → 여전히 0원**. 이를 피하려 2개 사이즈 단가행을 지우면 권위 3사이즈 표 파괴(날조). 게다가 use_dims는 카탈로그 공용 축이라 타상품 회귀 위험.

### 후보 E — CPQ 옵션그룹 maps.dims로 setSel에 siz_cd 주입 · **막힘(코드 하드코딩)**
- 프론트에는 옵션그룹 선택 시 `o.maps.dims`를 setSel에 주입하는 루프가 살아 있음(price_simulator.html:733) — 이론상 "사이즈 옵션그룹"을 등록하면 siz_cd 주입 가능.
- 왜 막히나: sim_meta가 `opt_groups = []` **하드코딩**(price_views.py:1480, 2026-06-28 설계결정·relitigate 금지) — 옵션그룹을 어떻게 등록해도 시뮬레이터에 안 내려감. 데이터로 재활성 불가.

### (참고) 후보 아님 — 할인테이블/등급/직접단가(095·096)/템플릿단가
- 할인·등급: 합산 **후** 곱셈(pricing.py:938-945) — base 0×무엇=0.
- 095/096에 직접단가: member 기여가 생기지만 all-in 부모 단가와 **이중합산**(기지 S1/S2 계열) + 권위에 없는 분해가 날조.
- 템플릿단가: simulate-set body에 tmpl_cd 자체가 없음(:1891-1893) — 셋트 경로 미접속.

---

## 4. 종합 답 (사용자 두 질문)

**Q1. 부모-자식 공식 매핑이 잘못된 것 아닌가? 자식에 맞게 분리해야 하나?**
아니다. 권위(상품마스터 260610)의 엽서북 가격은 "권당 완제품가"(사이즈×페이지수×수량밴드) **단일표**이고, 표지/내지/제본 분해가는 권위에 없다. 이 구조에 맞는 라이브 표현이 지금의 "부모 all-in 공식(PRF_PCB_FIXED) + 구성원 무공식(기여 0)"이며, 068~070(구성원이 각자 가격을 내고 셋트공식은 제본비만)과는 **권위 표 구조가 다를 뿐 양쪽 다 정합**이다. 공식을 자식으로 분리하려면 권당가를 장당가로 역산해야 하는데 이는 단가 날조(금지)이고, 설령 하더라도 member 경로 화이트리스트(:1930)에 opt_cd(20P/30P)가 없어 계산이 성립하지 않는다(후보 A). **잘못된 것은 매핑이 아니라, 시뮬레이터 셋트 경로가 "all-in형 부모공식"을 가정하지 않아 siz_cd를 수집·전달하지 않는 것**(price_simulator.html:635/722 + price_views.py:1987 백필 없음)이다.

**Q2. 메뉴 데이터만으로 해결 가능한가?**
- 정확한 가격(450,000 verbatim)이 나오는 데이터-온리 경로는 **후보 C(셋트 구성 해제) 단 하나**이나, 상품 유형 분류 SOT[HARD]·§23 회귀·물리 DELETE 위험으로 **권장하지 않음**(채택 시 인간 승인+백업+임시조치 명시 필수).
- 나머지 전 후보(A 공식이동·B 직접단가·D use_dims·E 옵션그룹 주입)는 화이트리스트/동시매칭/권위/하드코딩으로 각각 막힘 — 코드 근거 위 §3.
- 따라서 정공은 기존 결론 유지: **R1-D3/R2-D1 C트랙**(택1: ⓐ price_views.py:1987 직후 "부모 현재공식 use_dims가 siz_cd 요구 & set_selections에 없으면 내지 member.selections.siz_cd 백필" ⓑ price_simulator.html:635/722 siz_cd 제외를 use_dims 조건부로 완화). 검수 기대값: copies=100·SIZ_000003·POPT_000001·OPV_000491 → final=450,000.

**부수 정정(문서 유지보수):** §8 화면맵의 F-2 목록 중 `t_prd_product_sets`·`t_prd_product_price_formulas`·`t_prd_product_prices`·`t_prd_product_discount_tables`·`t_prd_template_prices`는 이제 메뉴(셋트상품 관리·가격 뷰어)에서 편집 가능 — 화면맵 갱신 필요. `t_prc_formula_components`(배선)·`t_dsc_grade_discount_rates`·`t_siz_pansu`는 여전히 DB 전용.
