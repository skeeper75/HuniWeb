# price-component-dimension-mechanism-audit.md — 가격구성요소 차원 메커니즘 구현 감사

> 2026-06-23 · §21. 가격구성요소 단가표가 옵션·공정(공정상세옵션)·템플릿을 차원으로 받아 항목을 추가하는
> 메커니즘이 코드에 어디까지 구현됐는지 감사. ★초점=가격 시뮬레이터(위젯은 별도 트랙). 코드=권위·읽기전용.
> 근거: `raw/webadmin/catalog/price_views.py`·`pricing.py`(라인 인용).

## 0. 결론 (먼저)
차원 메커니즘은 **이미 폭넓게 구현됨**. 옵션/공정상세/템플릿을 단가표 판별차원으로 쓸 수 있고, 시뮬레이터가
그 선택값을 엔진에 전달한다. ★따라서 R-B3(프리셋)·RC-2(가공/추가) 대부분은 **위젯/코드 변경 없이** 이
메커니즘(특히 opt_cd 차원·proc_cd+dim_vals)으로 풀 수 있다. (앞서의 "siz_preset 코드 배선 필수" 진단을 정정.)

## 1. 차원 종류 (use_dims)
- DIM_META(price_views.py:29-41): `siz_cd·plt_siz_cd·print_opt_cd·mat_cd·proc_cd·opt_cd·coat_side_cnt·bdl_qty·siz_width·siz_height·min_qty`.
- 엔진 NON_QTY_DIMS(pricing.py:42)에 `opt_cd` 포함 → 단가행 opt_cd 정확매칭 가능.
- 스코프 토큰(price_views.py:50-70 split_scopes): `opt_grp:코드`(옵션 차원의 옵션그룹 범위)·`proc_grp:코드`(공정 차원의 대상 상위공정). use_dims 끝에 저장, 차원 아님.

## 2. 옵션 → 차원 (2경로·구현됨)
- (A) **옵션→매핑 차원**: `_opt_maps`(price_views.py:1377-1391) — option_items.ref_dim_cd로 옵션을 차원값으로 변환:
  `OPT_REF_DIM.01→siz_cd · .02→plt_siz_cd · .03→mat_cd · .04→proc · .05→bdl_qty`. 옵션 선택이 해당 차원 selection에 반영.
- (B) **opt_cd 직접 차원**: comp use_dims에 `opt_cd`(+`opt_grp:` 스코프) 두면 → 단가표 그리드가 그 옵션그룹의 옵션을 드롭다운으로(`_opt_cd_options` price_views.py:726·`price_grid`:758-762), 단가행을 opt_cd별로 적재. 시뮬레이터는 opt_cd를 selection으로 전송(`_dim_options` opt_cd 분기 1343-1348·prod_dims 1364-1374). 엔진이 opt_cd 정확매칭.

## 3. 공정 + 공정상세옵션 → 차원 (구현됨)
- comp use_dims에 `proc_cd`(+`proc_grp:상위공정`) → 단가표 그리드 공정 컬럼=그 그룹 하위공정 드롭다운(`proc_child_options`:112) + **공정상세옵션 컬럼**(`proc_param_cols`:122, prcs_dtl_opt['inputs']에서). 상세값은 `dim_vals`에 저장(price_grid_save:836-853).
- 엔진 매칭: `_row_matches`(pricing.py:82-94)가 dim_vals 키도 **정확히 일치 요구**(공정 상세는 와일드카드 없음). 다중공정=proc_sels로 공정마다 개별 평가·합산(`_evaluate_formula`:583-592).
- **데이터드리븐 가격차원**(`_derive_price_dims`:308-334): prcs_dtl_opt.inputs가 `price_dim`+`contrib`(count_y/sum/passthrough) 선언 시 상세값을 가격차원으로 집계(예 앞/뒤 코팅 YN→coat_side_cnt). 엔진은 도메인 모른 채 데이터 선언대로.

## 4. 템플릿/추가상품 → 가격 (구현됨)
- 템플릿 직접단가(TPrdTemplatePrices)=우선순위 1위(evaluate_price:378-394).
- 추가상품(addons→템플릿): 시뮬레이터가 각 addon을 자기 템플릿 SKU 단가로 **개별 평가·합산**(price_views.py:1431-1449·price_simulate:1618-1645).

## 5. 시뮬레이터가 보내는 것 (price_simulate)
- selections(차원 직접: siz_cd·opt_cd·mat_cd 등)·procs(다중공정 proc_sels: proc_cd+detail)·addons·grade·qty.
- plt_siz_cd만 자동도출(siz_cd→fn_best_plate, 1586-1589). 나머지는 위젯/UI 선택을 그대로 전달.
- ★opt_cd·proc_cd·dim_vals(공정상세)는 시뮬레이터가 이미 전송 → comp가 그 차원으로 단가 매칭 가능(코드 변경 불요).

## 6. ★RC 재모델 (이 메커니즘으로·코드 변경 없이)
- **RC-1 프리셋(A3/A2/A1)**: 4 사이즈를 **옵션그룹**(A3/A2/A1/사용자입력)으로 두고 comp use_dims에 **opt_cd** 추가(+opt_grp 스코프). 단가행: opt_cd=A3→7000·A2→7000·A1→12000 / 사용자입력=opt_cd CUSTOM+면적티어. 시뮬레이터가 opt_cd 전송 → 프리셋/커스텀 정확 판별(동시매칭 ERR_AMBIGUOUS 회피). **위젯/price_simulate 코드 변경 불요.** (확인필요: 사용자입력 옵션이 nonspec 가로/세로 입력과 공존하는 모델링.)
- **RC-2 가공/추가(30 comp 고아)**: 각 옵션 comp를 공식에 addtn_yn=Y 바인딩 + use_dims에 **판별차원(opt_cd 또는 proc_cd+proc_grp+dim_vals)** 충전. 시뮬레이터의 옵션/공정 선택이 그대로 그 단가행 매칭. (타공=proc_grp:PROC_000104 이미 정상 패턴.)
- **RC-3 빈 use_dims/좀비**: 판별차원이 빈 comp(`[]`)는 위 메커니즘 미사용 상태 → opt_cd/proc 차원 충전으로 정상화. 좀비 PUNCH_6/8 use_yn=N.
- **RC-4 차원 역배선(캔버스행잉)**: use_dims=siz_width/height인데 단가행=siz_cd → use_dims를 siz_cd로 정정(설계의도 정합).

## 7. 갭(미사용·미충전)
메커니즘은 있으나 실사 옵션 comp 대부분이 (a)공식 미바인딩 (b)use_dims 판별차원 빈/오배선이라 **메커니즘을 안 쓰는 상태**. 즉 RC-2/RC-3/RC-4/RC-1은 "새 코드"가 아니라 **기존 차원 메커니즘에 맞게 데이터(use_dims+단가행+바인딩)를 채우는 일**. 단가 verbatim·기초코드 마스터 영향은 search-before-mint로 가드.

## 정정 노트
앞서 R-B3-PRICE/실사 모델에서 "siz_preset 위젯/price_views 코드 배선 필수"로 본 것은 **과한 진단**. opt_cd 차원
메커니즘이 시뮬레이터에 이미 구현돼 있어, 프리셋도 옵션 모델로 코드 변경 없이 처리 가능(시뮬레이터 한정·위젯은 별도 트랙).
