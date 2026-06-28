# CPQ/분류 모델 코드 감사 — 통화분석 D4·D5·D7·D8 대조 (2026-06-28)

> 방법: `raw/webadmin/webadmin/catalog`(models.py·admin.py·views.py·price_views.py·pricing.py·basecodes.py) **정적 분석만**. 라이브 접속·DB 쓰기 없음.
> 권위: 통화 SOT = `PRINCIPLES-call-analysis-260628.md`. 코드 근거는 `file:line`. 추정 금지·미발견은 "미발견" 명시.
> 위상: 이 문서는 **갭 진단**(검사 트랙). 실 인코딩/적재는 기존 가격·CPQ 하네스에 라우팅(각 갭 끝 1줄).

---

## 0. 핵심 결론 요약 (갭 3~5)

1. **D4 세 분류의 DB 경계는 명확 — 코드가 D4를 잘 지원한다(과잉설계 불필요).** 옵션(option_groups/options/option_items)·추가상품(addons→templates→selections)·공정(processes)이 별개 테이블·별개 편집 UI로 분리돼 있고, `sel_typ_cd`(택1/택N)·`mand_yn`(필수)·`max_sel_cnt`가 옵션그룹에 실재한다. **갭 없음**(지원확인).
2. **★중대 갭 — D4 복합형(자재+공정 혼합단가, 엑셀 '가공옵션')의 가격 경로는 `opt_cd` 기반인데 엔진에서 작동하지 않는다.** `pricing.py:598-601`이 "판별차원 없음 — opt_cd 등 미적재 → 선택과 무관하게 항상 매칭"으로 자인. 메모리(`addon-optcd-model-broken-live`)와 일치. 정식 경로는 추가상품 템플릿(`t_prd_product_addons`). **갭: 있음(부분)·심각도 High(돈크리티컬)**.
3. **D5 공정 다중누적·공정상세는 코드가 완전히 지원한다.** `t_prd_product_processes`는 (prd_cd, proc_cd) 복합PK라 한 상품 N공정 1:N OK. 공정상세는 `t_proc_processes.prcs_dtl_opt`(정의 JSON, 상속) + `option_items.dtl_opt`/`component_prices.dim_vals`(선택값 JSON). `pricing.py:694-705`가 `proc_sels` 다중 공정을 공정마다 개별 평가·합산. **갭 없음**(지원확인). 단 박색상별 공정분리·박크기=공정상세는 **데이터 컨벤션**이라 코드만으론 검증 불가(미발견).
4. **D7 옵션그룹 Min-Max는 실재한다 — 통화 "부재" 주장은 부정확.** `models.py:594-595` `min_sel_cnt`/`max_sel_cnt`가 옵션그룹에 있음. 단 이는 **"옵션 몇 개를 동시 선택"**(택N 범위)이지 "조각수 값의 최소~최대 범위"가 아니다. 통화의 "조각수 5~10을 개별 옵션아이템으로 등록"은 현재 모델과 **정합**한다(각 조각수 = option_item). **갭: 부분(용어 혼선)·심각도 Low**.
5. **D8 nonspec 트리거 규명 완료(통화 미결 해소).** 플래그 = `t_prd_products.nonspec_yn`(상품 단위, `models.py:508`). 직접입력 박스 트리거 = 시뮬레이터에서 `nonspec_yn==="Y"`일 때 노출, **`siz_cd` 차원이 없으면 자동 체크+disabled**(`price_simulator.html:247,273-282`). 엔진은 `siz_width`/`siz_height` 자유치수로 면적격자 조회(`pricing.py:310`, `price_views.py:1413`). **갭 없음**(코드로 규명·지원확인).

---

## D4. 옵션 / 추가상품 / 공정 3분류

| 결정 | 코드 근거(file:line) | 현재 동작 | 갭 | 심각도 | 파이프라인 함의 |
|---|---|---|---|---|---|
| 세 분류 DB 경계 분리 | 옵션: `models.py:587-654`(option_groups/options/option_items) · 추가상품: `models.py:255-268`(addons)+`657-698`(templates/selections) · 공정: `models.py:446-461`(product_processes)+`534-550`(processes) | 3분류가 별개 테이블·별개 편집화면(옵션·SKU는 custom viewer 드릴다운 `views.py:839-890`, 공정/추가상품은 product admin inline `admin.py:929-940`). 경계 명확. | 없음 | — | 지원확인. §7 dbmap CPQ·§21 정합이 이미 인코딩. |
| 추가상품='해도/안해도'(비필수) | `models.py:255-268` addons = (prd_cd, tmpl_cd) 복합PK, **필수/비필수 플래그 자체가 없음** → 구조상 전부 선택(비필수) | 추가상품은 템플릿 묶음으로 연결되며 비필수가 기본(택 안 함=미적용). '필수 추가상품' 개념은 모델에 없음. | 없음(비필수가 구조 기본) | — | 지원확인. '강제 추가상품'이 필요하면 옵션그룹(mand_yn=Y)으로 전환(D4 운영결정과 정합). |
| 옵션='택1 강제 / 택N 묶음' | `models.py:593`(sel_typ_cd)·`594-595`(min_sel_cnt/max_sel_cnt)·`596`(mand_yn) · 판정 `views.py:1161-1169`(SEL_TYPE.02=택N, else 택1; mand_yn=Y→필수) | 옵션그룹에 선택유형(SEL_TYPE.01 단일/.02 다중)·최소/최대선택수·필수여부 실재. 시뮬레이터가 라디오(택1)/체크박스(택N)로 렌더(`price_simulator.html:251-259`). | 없음 | — | 지원확인. §7 dbmap CPQ가 sel_typ_cd 매핑 담당. |
| **★복합형 예외: 자재+공정 혼합단가('가공옵션'·자재무관)** | 가격 경로 = `component_prices.opt_cd`(`models.py:185`, FK 없는 CharField) · **엔진 자인** `pricing.py:598-601`: opt_cd 만 쓰는 comp은 "판별차원 없음 → 선택과 무관하게 항상 매칭(opt_cd 등 미적재)" | opt_cd 기반 가산 구성요소는 손님 선택(opt_cd)이 엔진 selections에 주입되지 않아 **항상 매칭(상시 가산)되거나 본체에 묻힌다**. 정식 작동 경로는 추가상품 템플릿(addons→templates→selections). | **있음(부분)** | **High(돈크리티컬)** | §18 가격엔진 설계가 '가공옵션' comp을 addon 템플릿 또는 옵션그룹(차원 환원)으로 재설계·§21 정합이 opt_cd-only comp 전수 적발(메모리 `addon-optcd-model-broken-live`와 합류). |

**보강 근거:**
- 옵션 → 가격차원 환원은 `option_items.ref_dim_cd`(polymorphic, `models.py:640`) + `views.py:43-82` `VAR_KEY_MAP`이 담당. 옵션이 자재/공정/사이즈 등 어느 차원을 참조하는지는 ref_dim_cd로 결정 → "옵션=BUNDLE(자재+공정)" 표현이 데이터로 가능(D4 운영결정 수용 가능).
- 추가상품 템플릿이 "묶음"인 이유: `t_prd_template_selections`(`models.py:678-698`)가 template 1개에 여러 ref_dim_cd 선택값(자재+공정+옵션)을 담음 → '가공옵션' 복합형을 **addon 템플릿으로 표현하면 무손실**. 이것이 권장 경로.

---

## D5. 공정 상세 옵션 구조

| 결정 | 코드 근거(file:line) | 현재 동작 | 갭 | 심각도 | 파이프라인 함의 |
|---|---|---|---|---|---|
| 공정상세옵션 분리 구조 실재 | 정의: `models.py:538` `t_proc_processes.prcs_dtl_opt`(JSON `{inputs:[{key,type,unit,values,price_dim,contrib}]}`) · 상속 `price_views.py:proc_detail_inputs`(자기 우선→상위 상속) · 선택값: `models.py:644` `option_items.dtl_opt`(JSON) | 공정 자체에 상세입력 스펙(JSON)이 정의되고 부모공정 상속. 손님 선택값은 dtl_opt에 저장. 가격은 `dim_vals`(component_prices, `models.py:194`)로 매칭. | 없음 | — | 지원확인. §14 가격엔진 진단이 prcs_dtl_opt 역할 정의 보유. |
| 한 상품 같은종류 공정 **다중 누적**(1:N) | `models.py:447` `t_prd_product_processes` PK=(prd_cd, proc_cd) → 상품당 N공정 · 엔진 `pricing.py:646-648,694-705`: proc_sels 다중 공정 각각 개별 평가·합산 | 화이트+클리어·금박+은박 동시 = proc_cd 별 행 + proc_sels 배열로 각각 합산. dim_vals 충돌 없이 공정별 독립 평가. | 없음 | — | 지원확인. 박/별색 동시누적이 엔진·스키마 양쪽 OK. |
| 박=색상별 공정 분리 / 박크기=공정상세 | 박 색상별 proc_cd 분리 = **데이터 등록 컨벤션**(코드는 proc_cd 무관용). 박크기 = prcs_dtl_opt input(예 key='박크기', price_dim) | 코드는 임의 공정/상세를 데이터드리븐 처리(`pricing.py:362-388` _derive_price_dims). 박색상=별개 proc_cd, 박크기=상세 input 으로 등록하면 작동. | **미발견(데이터 의존)** | Medium | 코드만으로 "청박/녹박이 별개 proc_cd 인지" 확인 불가 → §21 정합 또는 §26 무결성이 라이브 t_proc/component_prices 실측 필요. |
| 양/단면=공정상세, 별색=공정, 인쇄 양단면=인쇄옵션 | 인쇄면 = `models.py:424`(product_print_options.print_side)+`49`(print_options.print_side) ≠ 공정. 별색=proc_cd. 별색 양/단면=prcs_dtl_opt input | 인쇄(양/단면)는 인쇄옵션 축(print_opt_cd), 별색(화이트/클리어/금/은)은 공정(proc_cd), 별색의 양/단면은 공정상세(dtl_opt). 3축 분리 가능. | 없음(구조 지원) | — | 지원확인. D5 의미축 분리가 스키마와 정합. |

**보강 근거:** `prcs_dtl_opt` 입력정의는 `price_dim`+`contrib`(`count_y`/`sum`/`passthrough`, `pricing.py:362-388`)로 상세값을 가격차원에 데이터드리븐 주입. 예: 앞/뒤 코팅 YN 2개 → coat_side_cnt=0/1/2 합산(`pricing.py:367`). 즉 **공정상세 다중누적의 단가합산 메커니즘이 일반화돼 있음**(통화 부록 "공정상세 다중누적 단가합산" 질문 = 코드상 해결됨).

---

## D7. 조각수 옵션화

| 결정 | 코드 근거(file:line) | 현재 동작 | 갭 | 심각도 | 파이프라인 함의 |
|---|---|---|---|---|---|
| 옵션그룹 Min-Max **부재** 여부(통화 주장 검증) | `models.py:594-595` `min_sel_cnt`/`max_sel_cnt` **실재**(옵션그룹) | 통화 "Min-Max 부재" = **부정확**. 단 이 Min-Max는 '동시 선택 옵션 개수'(택N 범위)이지 '조각수 값(5~10)의 범위 입력'이 아니다. 수량형 Min/Max/Step은 `t_prd_products`(min_qty/max_qty/qty_incr `models.py:517-519`)·`page_rules`(`models.py:341-343`)·`product_sets`(min_cnt/max_cnt/cnt_incr `models.py:469-471`)에 별도 존재. | **부분(용어 혼선)** | Low | "조각수 범위 입력 박스" 전용 컬럼은 옵션 레이어에 없음 → §7 dbmap CPQ가 "조각수=옵션그룹+개별 item" 패턴 확정. |
| 조각수 5~10 개별 옵션아이템 등록이 모델과 정합? | `models.py:635-654` option_items PK=(prd_cd, opt_cd, item_seq), ref_dim_cd 임의 차원 참조 | 조각수 각 값 = 개별 option_item(item_seq 1~N). '조각수' 옵션그룹 1개 + 값별 item. 가격 동일이면 차등 없이, 추후 차등은 item별 ref_key/단가행으로 가능. **현재 모델과 정합**. | 없음 | — | 지원확인. 통화 결정(개별 등록)이 그대로 적재 가능. §7 dbmap CPQ. |

---

## D8. 비규격(nonspec) 트리거

| 결정 | 코드 근거(file:line) | 현재 동작 | 갭 | 심각도 | 파이프라인 함의 |
|---|---|---|---|---|---|
| nonspec_yn 플래그 실재·위치 | `models.py:508` `t_prd_products.nonspec_yn`(상품 단위) + `509-514` nonspec_width/height_min/max/incr 6컬럼 | 비규격 여부는 **상품(t_prd_products)** 에 있음(사이즈 테이블 아님). 가로/세로 직접입력 범위·증분도 상품에 보유. | 없음 | — | 지원확인. 통화 미결("DB 위치 재확인")=상품 테이블로 규명. |
| 직접입력 박스가 켜지는 트리거(통화 미결) | `price_views.py:1307-1309`(META.nonspec 조립) → `price_simulator.html:247` `nonspecAllowed = ns.yn==="Y"` · `273-282` 렌더 · `277` `siz_cd 없으면 checked disabled`(강제 자유입력)·`343 toggleNonspec()` | UI 트리거 = **`nonspec_yn=="Y"`** 면 '비규격 직접입력' 체크박스 노출. `siz_cd` 차원이 있으면 선택형(체크 시 직접입력 병행), **없으면 자동 체크+비활성**(자유치수 전용). 통화 "사이즈코드 보유=코드선택+비규격 병행" 정합. | 없음(코드로 규명) | — | 지원확인. 통화 미결 해소. webadmin 외 위젯은 동일 nonspec_yn 계약 사용 권장(§6/§24 위젯·카트). |
| 자유치수 → 가격 환원 | `pricing.py:310`("nonspec='Y' 자유치수 보존, 덮지 않음") · `price_views.py:1413`(siz_width/siz_height 차원) · `component_prices.siz_width/siz_height`(`models.py:189-190`, '이하' 상한 티어) | 직접입력 가로/세로 → siz_width/siz_height 차원으로 면적격자(이하 상한) lookup. siz_cd 미사용. off-grid=ceiling(다음 큰 구간). | 없음 | — | 지원확인. §26 무결성이 면적격자 sparse 여부 점검(아크릴 실증). |

---

## 부록: 통화 "Claude 정밀분석 요청" 대비 코드 커버리지

| 요청 항목 | 코드 커버리지 | 비고 |
|---|---|---|
| 옵션·추가상품·공정 경계 예외(복합형 자재+공정 혼합단가) | **부분** | opt_cd-only comp 결함(D4 ★갭). addon 템플릿 경로로 재설계 권장. |
| 공정상세 다중누적 단가합산 | **지원** | prcs_dtl_opt price_dim/contrib + proc_sels 개별평가(D5). |
| 책자 반제품·세트(내지N종 max·제본세부) | **지원(구조)** | `product_sets.min_cnt/max_cnt/cnt_incr`(`models.py:469-471`)·반제품 필터 `admin.py:1090`(PRD_TYPE.02). 제본세부=공정상세 vs 옵션은 통화 미결(코드는 둘 다 가능). → §23 셋트. |
| 비규격 트리거 DB·UI 일관성 | **지원·규명** | nonspec_yn(상품) → 시뮬레이터 트리거(D8). |
| 필수공정 자동가산 | **지원** | `t_prd_product_processes.mand_proc_yn`(`models.py:451`)·viewer 필드 `views.py:547`. (D2 영역·본 감사 범위 밖이나 실재 확인.) |

**미발견(코드 정적분석으로 판정 불가 — 라이브 데이터 실측 필요):**
- 박 색상별 proc_cd 분리가 실제로 등록돼 있는지(D5).
- '가공옵션' 복합형이 라이브에서 opt_cd-only comp 으로 적재됐는지 vs addon 템플릿으로 적재됐는지(D4 ★갭의 실제 영향 상품 수).
- 조각수가 라이브에서 개별 option_item 으로 등록됐는지 vs 옵션그룹 부재인지(D7).
→ 모두 §21 정합·§26 무결성·§15 단일상품 검증으로 라이브 실측 라우팅.
