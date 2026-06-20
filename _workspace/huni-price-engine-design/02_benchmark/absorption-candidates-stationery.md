# 후니 흡수 후보 — 문구 가격계산 (제본물·반제품 세트 종단)

> `hpe-benchmark-analyst` 산출 — 디지털인쇄(파일럿)·아크릴(면적매트릭스)·실사현수막(면적+거치) 3종단에 이어 **문구류(떡메모지·노트·책자·제본물·다이어리) 종단**.
> **목적[HARD]**: 와우프레스·레드프린팅이 문구류(특히 **제본물 = 표지+내지+제본 다부품 합성**·**페이지수 계층**)의 가격을 *어떻게 계산하는가*(부품 합성·페이지 비례·제본방식 분기·수량 처리)를 역공학해 후니 제본물·세트상품 설계에 흡수할 메커니즘을 추출.
> **흡수 vs 답습[HARD]**: 메커니즘·표현력만 흡수, naming/codes(`book2025_price`·`MTRL_CD`·`INN_PAGE`·`paperno3` 등) 후니 유입 금지, 권위 엑셀(상품마스터260610·가격표260527) 덮어쓰기 금지. 후니가 이미 담으면 흡수 불요(overfit 경계).

## 출처 표기

- `[red:TP]` = `_workspace/huni-rpmeta/categories/TP/reverse.md`(2026-06-17 rpm 역공학 — 캘린더/북/티켓/떡메 23상품·TPCLECO/TPCLWLB 풀 infoCall 실측·item_gbn·INN_PAGE·이중수량).
- `[red:book]` = `raw/widget_monitor/red_captures/v2_PRBKORD_capture.json`(트윈링 책자 컬러·`book2025_item`·INN_PAGE 2~130·표지/내지 분리 WGT·seneca[책등]·제본방향·PVC추가커버 실측).
- `[wow:booklet]` = `raw/widget_monitor/wow_capture/fresh_booklet_capture.json`(책자/홀더 40004·`paperno3/4/5` 다단 용지·colorno+colorno_add 도수·박앞뒤·`jobqty0`/`jobcost0` API) + `[wow:probe]` 라이브 읽기전용 GET `ProdNo=30004`(2026-06-20·페이지수=가격인자·무선/중철/스프링/윤전 제본·표지vs내지 용지 분리·박 후가공 확인).
- `[huni:book]` = 라이브 `t_prd_*` 실측(2026-06-20·읽기전용) — 제본 comp 11종(`COMP_BIND_*`)·`PRF_BIND_SUM` 공유공식·`t_prd_product_sets` 28행(하드커버 표지+면지 세트)·`t_prd_product_page_rules` 11행(page_min/max/incr).
- `[huni:dwire]` = `_workspace/huni-dbmap/02_mapping/dwire-bind-namecard-photocard-remodel/`(제본 공유공식 broken 진단·상품별 공식 1:1 재모델·D-BIND-SCOPE).
- `unobserved` = 미관측(날조 금지).

---

## 0. 경쟁사 문구·제본물 가격화 방식 — 한눈 요약

| 항목 | 레드프린팅(RedPrinting) | 와우프레스(WowPress) | 후니 `t_prc_*`/`t_prd_*` 대응 |
|------|------------------------|----------------------|---------------------|
| 제본물 가격엔진 | **`book2025_price`(책자 전용 엔진)** = 표지+내지+제본+페이지 산정 `[red:book]` | 서버 **`jobqty0`(작업량)→`jobcost0`(작업비)** 2단 산정 — 페이지수·제본·용지로 작업량 환산 `[wow:booklet]` | `PRF_BIND_SUM` 합산형(`addtn_yn`Σ)·라이브상 **제본비 단일항**만 배선 `[huni:book·dwire]` |
| 부품 분리 | **표지/내지 WGT 분리**(COV_MIN_WGT 200·INN_MAX_WGT 1000·표지자재 ART250 + 내지자재 별행) `[red:book]` | **`paperno3/4/5` 다단 용지 select**(표지 vs 내지 용지 분리·`mdm/detail/Paper`) `[wow:booklet·probe]` | **`t_prd_product_sets`**(하드커버책자 PRD_000072 → 표지 073 + 면지 074/075/076 sub_prd)·표지/면지 = **별 prd_cd 반제품** `[huni:book]` |
| 페이지 계층 | **`INN_PAGE` MIN/MAX/STEP**(트윈링 2~130·STEP1·캘린더 2~200) `[red:book·TP]` | **페이지수 입력 = 명시 가격인자**(작업량 환산) `[wow:probe]` | **`t_prd_product_page_rules`**(page_min/max/incr·트윈링 8~100·무선 24~300·STEP2) `[huni:book]` |
| 제본방식 분기 | 링제본·제본방향(좌철/상철 BIND_DIRECTION)·PVC추가커버 등 PCS 그룹 `[red:book]` | 무선/중철/스프링/윤전/특가 제본 variant `[wow:probe]` | **제본 comp 11종**(중철·무선·PUR·트윈링·싸바리·하드커버무선/트윈링·탁상캘린더130/220/미니·벽걸이) — 각 별 comp `[huni:book]` |
| 책등(seneca) | **`seneca`(책등 두께 0.64~)** = 페이지수×내지두께 파생 `[red:book]` | 작업량에 내포 추정 | unobserved(앱 계산 파생 후보) |
| 수량 처리 | **이중수량**(ORD_CNT 디자인수 × PRN_CNT 부수)·부수 tier `[red:TP]` | 수량(연/건) + ordcnt(건수) tier `[wow:booklet]` | 제본 comp 단가행 = **`min_qty` 수량구간**(트윈링 1/4/10…별 단가)·구간할인 t_dsc `[huni:book]` |
| 디자인 입력(에디터/템플릿) | **`item_gbn`(book2025/edicus/vDigital) + useKoiEditor/useTemplateDownload**(가격 0) `[red:TP]` | hasEditor=true(편집기)·가격 비결합 | `t_prd_templates`(완제SKU·의미 다름)·에디터 채널 = 후니 위젯 역공학 영역(가격축 아님) |
| 떡메모지/메모패드 | 풀제본(점착)·단면·소량 `[red:TP 그룹E]` | unobserved | `PRF_*` 미바인딩(가격사슬 부재 — 가격엔진 설계 대상) `[huni:book]` |

**한 줄 결론**: 두 경쟁사 모두 제본물을 **부품 합성**(표지자재 + 내지자재 + 제본비 + 후가공 Σ) + **페이지수 계층**(내지 단가가 페이지수에 비례) + **제본방식 분기**(무선/중철/링/PUR…)로 계산한다. RedPrinting은 `book2025_price` 전용 엔진 + INN_PAGE + 표지/내지 WGT 분리, WowPress는 `jobqty0→jobcost0` 작업량 2단 산정 + `paperno3/4/5` 다단 용지. **이 골격은 후니가 이미 강력한 그릇으로 보유** — `t_prd_product_sets`(표지+면지 세트 28행)·`t_prd_product_page_rules`(페이지 규칙 11행)·제본 comp 11종이 경쟁사 모델과 **1:1 동형**. 다만 후니 라이브 가격사슬은 **"제본비 단일항"만 배선**(`PRF_BIND_SUM` 공유공식·표지/내지/인쇄 comp 미배선·D-WIRE 결함)이라, 흡수할 실질은 **(가격 합성 메커니즘 흡수가 아니라) "이미 보유한 세트/페이지 그릇을 가격 합산 공식에 실제로 배선"**하는 것이다. WowPress의 작업량 2단(jobqty→jobcost) 산정은 후니 단일 evaluate_price와 다른 패턴이나 **흡수 부결**(과분화).

---

## 1. 흡수 후보 요약 보드 (C-ST1~C-ST8)

| ID | 흡수 후보 | 출처 | 후니 그릇 | 사다리 | 우선순위 | overfit 위험 | 답습 리스크 |
|----|----------|------|----------|--------|---------|------------|------------|
| **C-ST1** | 제본물 = 부품 합성 (표지비+내지비+제본비+후가공 Σ) | 레드 book2025 표지/내지 WGT·와우 paperno3/4/5 다단 | `PRF_*_BIND` 합산형 `addtn_yn`Σ + `t_prd_product_sets` | 공식 배선(그릇 존재·**미배선**) | **High** | 낮음(이미 동형 그릇) | 낮음 |
| **C-ST2** | 페이지수 계층 = 내지 단가 비례 (앱 계산·DB 룩업) | 레드 INN_PAGE 2~130·와우 페이지수=작업량 | `t_prd_product_page_rules`(page_min/max/incr·**라이브 실재**) | 데이터(이미 존재) | **High** | 낮음(그릇 실재) | 낮음 |
| **C-ST3** | 표지/내지 자재 분리 (한 상품 안 다부품 자재) | 레드 표지ART250+내지 별WGT·와우 표지vs내지 용지 select | `t_prd_product_sets` sub_prd(표지=별 prd·면지=별 prd) + 부품별 `mat_cd` comp | 데이터/배선(그릇 실재) | **High** | 낮음 | 낮음 |
| **C-ST4** | 제본방식 분기 = 별 comp/공식 (중철/무선/PUR/링…) | 레드 링/제본방향·와우 무선/중철/스프링/윤전 | 제본 comp 11종(`COMP_BIND_*`·**라이브 실재**) + 상품별 공식 1:1 | 코드행(이미 존재) | **Medium** | 중(엔진 과분화 경계) | 중(naming 가드) |
| **C-ST5** | 책등(seneca) 두께 = 페이지수 파생 (앱 계산) | 레드 `seneca` 0.64~(페이지×내지두께) | 앱 런타임 계산(off-grid ceiling 동류·DB 미저장) | 앱 계산(저장 안 함) | Medium | 낮음 | 낮음 |
| **C-ST6** | 작업량→작업비 2단 산정 (jobqty→jobcost) | 와우 `jobqty0`/`jobcost0` 서버 2단 | 후니 단일 `evaluate_price`(공식/구성요소 데이터 분기) | — | Low | **부결(과분화)** | **중(엔진 코드 분기 답습 금지)** |
| **C-ST7** | 떡메모지/메모패드 = 풀제본 묶음 단가 (소량·세트) | 레드 떡메/점메 풀제본·세트판매 `[red:TP]` | `bdl_qty` + `t_prd_product_bundle_qtys`(QTY_UNIT) + 제본 comp | 데이터/배선 | Medium | 낮음 | 낮음 |
| **C-ST8** | 이중수량 (디자인수 × 부수) — 가격축 baked-in 금지 | 레드 ORD_CNT×PRN_CNT·와우 ordcnt | 부수=수량구간(min_qty)·디자인수=주문라인 | 가드(설계 원칙) | Medium | 낮음 | 낮음 |

**신규 테이블(vessel) 신설 = 0건.** 후니가 제본물 세트(`t_prd_product_sets`)·페이지 규칙(`t_prd_product_page_rules`)·제본 comp 11종·합산형 공식·묶음수(`bundle_qtys`)를 **이미 전부 보유**. 실질 흡수 = **이미 보유한 그릇을 가격 합산 공식에 실제 배선**(C-ST1·C-ST3 = data/배선 gap)이지 새 그릇 발명이 아니다. rpmeta TP 판정(페이지 계층·형태 variant·제본 = 기존 옵션/공정/제약 facet)과 정합.

---

## C-ST1. 제본물 = 부품 합성 (표지비+내지비+제본비+후가공 Σ) ★ (우선순위 High·흡수 강·그릇 존재·미배선)

### 흡수 메커니즘
- **레드프린팅 `book2025`** `[red:book]`: 한 책자 상품 안에 표지자재(`MTRL_CD=RXART250` 아트지250g·`COV_MIN_WGT=200`)와 내지(`INN_MAX_WGT=1000`)가 **분리 인코딩**. 가격 = 표지(자재×인쇄×후가공) + 내지(자재×인쇄×페이지수) + 제본 + (PVC추가커버·박). 부품별 자재가 한 상품에 공존.
- **와우프레스 책자** `[wow:booklet·probe]`: `spdata_00_paperno3/4/5` **다단 용지 select**(표지 vs 내지 용지 분리·`mdm/detail/Paper` API) + `colorno`(본판 도수) + `colorno_add`(추가도수: 백색/은별색) + 박앞/뒤. 서버 `jobcost0`이 부품 단가를 합산.

### 합성식 (관측·추정)
```
제본물 가격 = 표지비(자재×인쇄×후가공) + 내지비(자재×인쇄×페이지수) + 제본비 + (박/PVC커버 가산)
           = Σ 부품 component 단가   (각 부품이 자기 차원으로 단가 룩업)
```

### 후니 매핑 (그릇 존재·**미배선** — 흡수 = 배선)
후니는 **세트 구성 그릇을 이미 보유**: `t_prd_product_sets`(`[huni:book]` 28행) — 하드커버책자(PRD_000072)가 sub_prd로 **표지(073=전용지) + 면지(074 화이트/075 블랙/076 그레이)** 를 가짐(`sub_prd_qty`·`note`="표지=전용지"/"면지=화이트면지"). 즉 후니는 **표지·면지를 각각 별 prd_cd 반제품**으로 두고 세트로 묶는다(RedPrinting WGT 분리·WowPress 다단 용지의 후니 권위판).
- **그러나 라이브 가격사슬은 "제본비 단일항"만 배선**(`PRF_BIND_SUM` 공유공식·`COMP_BIND_JUNGCHEOL` 1개만·`[huni:dwire]` D-WIRE 4/1 broken). 표지비·내지비·인쇄비 comp **미배선**(D-BIND-SCOPE: "책자=제본비 단일 합산" vs "인쇄+용지+제본 합산" 미결).
- **흡수 = 부품 합성 배선**: 합산형 공식(`PRF_<제본>_BIND`)에 표지비 comp + 내지비 comp(페이지수 차원) + 제본비 comp + 후가공 comp를 `addtn_yn='Y'` Σ로 배선. dbmap round-21 BOOKLET-BIND-WIRE 방향과 정합.

### 사다리 판정 (search-before-mint)
**신규 테이블 0·신규 공식/comp 배선 필요.** 세트 그릇(`t_prd_product_sets`)·합산형(`addtn_yn`)은 이미 존재. data/배선 gap이지 vessel-gap 아님.

### trade-off
- 장점: 경쟁사와 동형의 정확한 부품 합성(표지 고급지 + 내지 평량 + 제본방식별 비용). 세트 구성(반제품)을 가격에 정확 반영.
- 단점: **표지/내지/인쇄 comp 미적재가 진짜 병목**(제본비만 있고 인쇄·용지 comp 없음·`[huni:dwire]` 실측). 부품 comp 단가행 확보가 선결(권위 가격표 260527 제본물 시트 → 부품별 단가 추출). **D-BIND-SCOPE 인간 결정 필요**(제본비 단일 vs 부품 합산 — 권위 가격표가 부품별로 단가를 주면 부품 합산이 정답).

### naming 유입 가드 [HARD]
`book2025_price`·`MTRL_CD`(RXART250)·`COV_MIN_WGT`/`INN_MAX_WGT`·`paperno3/4/5` 후니 유입 금지. 후니 `frm_cd`/`comp_cd`/`mat_cd`·`t_prd_product_sets` 컨벤션으로 번역.

---

## C-ST2. 페이지수 계층 = 내지 단가 비례 (앱 계산·DB 룩업) ★ (우선순위 High·흡수 강·그릇 실재)

### 흡수 메커니즘
- **레드프린팅** `[red:book·TP]`: `pdt_prn_cnt_info`에 `MIN_INN_PAGE`/`MAX_INN_PAGE`/`STEP_INN_PAGE`(트윈링 책자 2~130 STEP1·캘린더 2~200·효도달력 1). 내지 페이지수 입력 → 내지 단가가 페이지수에 비례(대수/페이지 곱).
- **와우프레스** `[wow:probe]`: "페이지수"가 **명시 가격인자**(작업량 환산). 페이지수↑ → 작업량(jobqty)↑ → 작업비(jobcost)↑.

### 후니 매핑 (그릇 실재 — `t_prd_product_page_rules`)
후니는 **페이지 규칙 그릇을 이미 보유**: `t_prd_product_page_rules`(`[huni:book]` 11행) — `page_min`/`page_max`/`page_incr`. 실측: 트윈링책자(PRD_000071) 8~100·무선책자(PRD_000069) 24~300·하드커버(PRD_000072) 24~300·STEP2·떡메모지(PRD_000097) 3~3. **RedPrinting `MIN/MAX/STEP_INN_PAGE`와 1:1 동형**(후니 권위판). 페이지수는 **입력 차원**이고, 내지 단가 곱은 **앱 런타임 계산**(메모리 `dbmap-compute-in-app-db-stores-lookup`: 파생값은 앱 계산·DB는 단가 룩업).

### 사다리 판정 (search-before-mint)
**신규 불요.** 페이지 규칙 그릇(`page_rules`) 라이브 실재. 흡수 = **"페이지수 = 입력 차원·내지 단가 비례는 앱 계산"을 엔진 계약에 명시**(페이지수를 가격 단가행 차원으로 폭발시키지 말 것 — 내지 1면 단가 × 페이지수 또는 대수 룩업).

### trade-off
- 장점: 페이지 2~300까지 단가행 폭발 없이 1면 단가 + 페이지수 곱으로 표현(앱 계산). RedPrinting·WowPress 동형.
- 단점: 페이지수↔대수(8면/16면 한 대) 환산·STEP(2면 단위) 규칙을 엔진이 정확히 구현해야(page_incr 준수). 내지 1면(또는 1대) 단가 comp 단가행 확보 필요(C-ST1 부품 comp와 동반).

### naming 유입 가드 [HARD]
`INN_PAGE`·`MIN/MAX/STEP_INN_PAGE`·`pdt_prn_cnt_info` 후니 유입 금지. 후니 `t_prd_product_page_rules`(page_min/max/incr) 컨벤션으로 번역(이미 존재).

---

## C-ST3. 표지/내지 자재 분리 = 다부품 자재 (우선순위 High·흡수 강·그릇 실재)

### 흡수 메커니즘
- **레드프린팅** `[red:book]`: 표지자재(`PTT_CD=ART`·`WGT_CD=250`·`COV_MIN_WGT=200`)와 내지(`INN_MAX_WGT=1000`)가 한 책자에 분리. 표지=고급지(아트지250)·내지=별 평량.
- **와우프레스** `[wow:booklet·probe]`: 표지 용지 select ≠ 내지 용지 select(`paperno3/4/5` 다단·접이식 용지 뷰어 표지vs내지).

### 후니 매핑 (그릇 실재 — `t_prd_product_sets` + 별 prd_cd)
후니는 표지·면지를 **각각 별 prd_cd 반제품**으로 둠(`[huni:book]`): 하드커버책자(072)=세트 부모, 표지(073 전용지)·면지(074 화이트/075 블랙/076 그레이)=sub_prd. 레더 하드커버(077)도 표지(078 레더화이트)+면지(079/080/081). 즉 **부품별 자재가 별 상품으로 분리**(RedPrinting WGT 분리·WowPress 용지 분리보다 명시적 — 후니가 표현력 우위).
- 가격: 부품 prd(표지/면지)별 자기 comp/공식(자재 단가) + 세트 부모(072)가 합산. 또는 부모 공식이 sub_prd 부품 단가를 Σ.

### 사다리 판정 (search-before-mint)
**신규 불요.** `t_prd_product_sets` + 별 prd_cd가 이미 다부품 자재를 담는다(28행 라이브). 흡수 = **"표지/내지 자재 = 세트 부품으로 분리, 부품별 단가 합산"을 가격 설계에 반영**(C-ST1 배선과 동반).

### trade-off
- 장점: 면지 색상(화이트/블랙/그레이/인쇄)을 별 부품으로 선택·단가 분기(RedPrinting WGT·WowPress 용지보다 명시). 세트 구성(반제품)이 명확.
- 단점: 부품 prd가 늘면 세트 관리 복잡(하드커버 1상품 = 부모 1 + 표지 1 + 면지 4 = 6 prd). 부품별 단가 comp 미배선이 C-ST1과 같은 병목.

### naming 유입 가드 [HARD]
`COV_MIN_WGT`/`INN_MAX_WGT`·`PTT_CD`·`paperno` 후니 유입 금지. 후니 `t_prd_product_sets`(sub_prd_cd·note)·`mat_cd` 번역.

---

## C-ST4. 제본방식 분기 = 별 comp/공식 (우선순위 Medium·흡수 중·엔진 과분화 경계)

### 흡수 메커니즘
- **레드프린팅** `[red:book]`: 링제본·제본방향(좌철/상철 `BIND_DIRECTION`)·PVC추가커버 PCS 그룹. 책자별 다른 제본(트윈링/무선/하드커버…).
- **와우프레스** `[wow:probe]`: 무선책자·중철책자·스프링·윤전책자·특가 — **제본방식이 1급 상품/옵션 분기**.

### 후니 매핑 (제본 comp 11종 라이브 실재)
후니는 **제본 comp 11종 보유**(`[huni:book]`): 중철·무선·PUR·트윈링·싸바리바인더·하드커버무선·하드커버트윈링 + 캘린더 제본 4종(탁상130/220/미니·벽걸이). 각 별 comp(`COMP_BIND_*`·`comp_typ_cd=.04 공정비`·`prc_typ=.01 단가형`). 제본방식별 단가행은 **`min_qty` 수량구간**(트윈링 1/4/10…별 단가·siz_cd 없음). → 제본방식 = 별 comp + 상품별 공식 1:1(`[huni:dwire]` 권고: 공유 `PRF_BIND_SUM` broken → `PRF_<제본>_BIND` 분리).

### 사다리 판정·overfit 경계
**기존 comp 11종으로 닫힘(신규 0).** ★**엔진 과분화 경계** — WowPress처럼 제본방식마다 별 가격엔진을 후니 코드 레벨로 신설하면 overfit. 후니는 **단일 `evaluate_price` + 제본 comp/공식 데이터 분기**가 권위(메모리 `harness-audit-maintenance`). 흡수 = 제본 분기를 **데이터(comp/frm_cd)로** 두는 것. 단 제본방식이 **계산방식이 진짜 다를 때만** 별 공식(중철=면적/수량 단순·하드커버=부품 합성 복잡).

### trade-off
- 장점: 제본방식별 정확한 단가(트윈링 ≠ 무선 ≠ 하드커버). 상품별 공식 1:1로 D-WIRE 라우팅 문제 해소(`[huni:dwire]`).
- 단점: 제본 comp가 수량구간(min_qty)만 차원이라 사이즈(A4/A5) 차이가 단가에 안 들어가면 검증 필요(권위 가격표 대조).

### naming 유입 가드 [HARD]
`book2025_price`·`BIND_DIRECTION`·WowPress 제본 토큰 후니 유입 금지. 후니 `comp_cd`(COMP_BIND_*)·`frm_cd` 번역.

---

## C-ST5. 책등(seneca) 두께 = 페이지수 파생 (앱 계산) (우선순위 Medium·흡수 중)

### 흡수 메커니즘
레드프린팅 `seneca_info`: `seneca=0.64`·`max_seneca=1000.00` `[red:book]`. 책등(spine) 두께 = 내지 페이지수 × 내지 두께(평량)로 파생되는 값(무선/하드커버 표지 재단·인쇄 영역에 영향). 입력이 아니라 **페이지수에서 계산되는 파생값**.

### 후니 매핑 (앱 런타임 계산·DB 미저장)
후니에 책등 두께축은 없으나, 이는 **앱 런타임 파생**이 정답(메모리 `compute-in-app-db-stores-lookup`: 판수·박 등급과 동류·DB는 단가만). 책등 두께가 가격에 직접 영향하면(표지 재단/면적) 페이지수에서 앱 계산. DB에 별 축/단가행 신설 불요.

### 사다리 판정 (search-before-mint)
**신규 불요(앱 계산).** 책등 두께를 DB 차원/단가행으로 박제하면 overfit. 페이지수(page_rules) + 내지 평량(mat_cd)에서 앱 계산.

### trade-off
- 장점: 페이지수만 입력받고 책등은 파생(off-grid ceiling·판수 계산과 동일 철학). 단가행 폭발 회피.
- 단점: 표지 재단/면적이 책등에 의존하면 엔진이 정확히 계산해야(min/max_seneca 한계). 후니 권위 가격표에 책등 영향이 명시 안 됐으면 미관측(보강).

### naming 유입 가드 [HARD]
`seneca`/`seneca_info` 후니 유입 금지. 앱 계산 로직(한글 "책등 두께") 번역.

---

## C-ST6. 작업량→작업비 2단 산정 (jobqty→jobcost) (우선순위 Low·**흡수 부결**·엔진 과분화)

### 관측 메커니즘
와우프레스 책자는 서버 **`jobqty0`(작업량 계산) → `jobcost0`(작업비 계산)** 2단 API로 가격을 낸다 `[wow:booklet]`. 페이지수·제본·용지·도수를 **작업량(연·도무송수 등)으로 환산**한 뒤 작업비를 산정(인쇄 생산 단위 기반).

### 후니 매핑·overfit 경계
**흡수 부결.** 후니는 **단일 `evaluate_price` 알고리즘 + 공식/구성요소 데이터 분기**가 권위(메모리 `harness-audit-maintenance`·`huni-price-engine-design-harness`). WowPress의 "작업량 중간 산출 → 작업비" 2단 서버 분기를 후니 엔진 코드로 흉내내면 **답습·과분화**. 후니에서 "작업량"(판수·대수·페이지)은 **앱 런타임 계산**(DB는 단가 룩업·C-ST2/C-ST5와 동일), 작업비는 단가행 룩업. 즉 후니는 이미 "작업량(앱 계산) → 단가 룩업"을 분리하므로 **2단 엔진 코드 신설 불요**.

### 사다리 판정
**신설 0·부결.** WowPress 2단 패턴은 그들의 레거시 작업비 회계 구조(연·도무송)에 묶인 것이지 후니 모델에 흡수할 표현력 이득 없음.

### naming 유입 가드 [HARD]
`jobqty0`/`jobcost0`·"작업량/작업비" 엔진 토큰 후니 유입 금지. 후니는 앱 계산 + 단가 룩업으로 표현(엔진 코드 분기 금지).

---

## C-ST7. 떡메모지/메모패드 = 풀제본 묶음 단가 (우선순위 Medium·흡수 중)

### 흡수 메커니즘
레드프린팅 떡메(`TPBLMEO` 프리미엄 떡메)·점메(`TPBLPST`) `[red:TP 그룹E]` = **메모지 풀제본(점착)** + 소량·세트(권/묶음) 판매. 떡메 = N매를 풀(점착)로 묶은 패드(제본의 한 형태).

### 후니 매핑 (그릇 보유·**미바인딩**)
후니 떡메모지(PRD_000097)·메모패드(179)·떡메모지-내지(098)는 라이브에 **공식 미바인딩**(`frm_cd=NULL`·`[huni:book]`) — 가격사슬 부재(가격엔진 설계 대상). page_rules는 보유(097=3~3). 후니 그릇:
- **풀제본 = 제본 comp**(풀제본비·신규 comp 후보 or 기존 제본 comp 재사용) + 묶음 단가 `bdl_qty`(`t_prd_product_bundle_qtys`·QTY_UNIT 권/묶음).
- 내지(098)는 떡메(097)의 sub_prd 후보(`t_prd_product_sets` — 떡메=표지(점착커버)+내지 다부품 가능).

### 사다리 판정 (search-before-mint)
**그릇 보유(bundle_qtys·sets·page_rules)·미바인딩.** 흡수 = 떡메 가격공식 신규 설계(풀제본비 + 내지비 + 묶음 단가). 풀제본비 comp는 제본 comp 11종에 없으면 신규 1행(점착/풀제본) — 권위 가격표 확인.

### trade-off
- 장점: 떡메/메모패드를 풀제본 + 묶음 단가로 정확 표현(소량·권 단위). RedPrinting 떡메 동형.
- 단점: 떡메 가격사슬 전무(공식·comp 미배선) → 설계 신규(가격표 260527 떡메 시트 권위로 단가 추출).

### naming 유입 가드 [HARD]
`TPBLMEO`/`TPBLPST` 후니 유입 금지. 후니 `comp_cd`/`bdl_qty` 번역.

---

## C-ST8. 이중수량 (디자인수 × 부수) — 가격축 baked-in 금지 (우선순위 Medium·흡수 중·가드)

### 흡수 메커니즘
레드프린팅 `[red:TP]`: **ORD_CNT "디자인 수(건수)" × PRN_CNT "수량(부수)"** 명시 분리(캘린더 TPCLWLB·북류 전부). 와우프레스도 ordcnt(건수) + 수량(연/매). 디자인 종수와 부수가 별 축.

### 후니 매핑 (수량구간 + 주문라인)
후니: **부수 = 수량구간**(제본 comp 단가행 `min_qty` 1/4/10…·구간할인 t_dsc) — 가격 차원. **디자인수(건수) = 주문라인 멀티플라이어**(가격축 아님·디지털/아크릴 종단의 C-5/이중수량 가드와 동일). 디자인 종수를 가격 단가행 차원에 baked-in 금지.

### 사다리 판정
**가드(설계 원칙)·신설 0.** 부수는 수량구간(보유)·디자인수는 주문라인. 흡수 = "이중수량 분리"를 엔진 계약에 명시.

### trade-off
- 장점: 디자인 N종 × 부수 M을 정확히 분리(같은 부수라도 디자인 2종이면 2× 주문). 디지털/아크릴 종단과 일관.
- 단점: 디자인수가 면付(임포지션·판수)에 영향하면 앱 계산 연동 필요(디자인 종수 → 판 배치). 가격 단가행엔 부수만.

### naming 유입 가드 [HARD]
`ORD_CNT`/`PRN_CNT`·`ordcnt` 후니 유입 금지. 후니 수량구간(min_qty)·주문라인 번역.

---

## 2. ×qty 과청구 맥락 — 경쟁사 문구 수량처리 대조 ★

> 디지털인쇄 파일럿에서 **`prc_typ .01`(단가형) × 수량 누적이 인쇄비를 과청구**(명함 3500→350,000)하는 결함이 있었다. 문구·제본물은 경쟁사가 수량을 어떻게 처리하는가?

| 관점 | 레드프린팅 제본물 | 와우프레스 책자 | 후니 제본물 라이브 | 시사점 |
|------|------------------|----------------|-------------------|--------|
| 본체 수량 | PRN_CNT 부수 tier·FIR_CNT 1·INC_CNT 10·INC_STEP 10(`[red:book]`) | 수량(연/건) tier·ordcnt | 제본 comp `min_qty` 수량구간(트윈링 1/4/10) `[huni:book]` | 부수 구간별 단가(볼륨디스카운트) |
| ★제본비 prc_typ | unobserved(서버 book2025) | 작업비(jobcost) | **`COMP_BIND_*` prc_typ .01(단가형)** `[huni:book]` | ★**제본비가 .01 단가형** — 엔진이 ×수량 곱하면 디지털 과청구와 동일 클래스 위험(제본비가 "부수당"인지 "묶음 총액"인지 검증 선결) |
| 페이지 비례 | INN_PAGE × 내지단가(`[red:book]`) | 페이지수 → 작업량 | 내지 comp 미배선(`[huni:dwire]`) | 내지 단가 = 1면(또는 1대) × 페이지수 — 페이지수를 ×수량과 혼동 금지 |
| 후가공(박/PVC) | 박앞/뒤·PVC추가커버 가산 | 박 후가공 | 후가공 comp(미배선 다수) | 후가공 = 부수당 1회 vs ×수량 = 디지털 결함 동일 클래스 |
| 이중수량 | ORD_CNT × PRN_CNT 분리 | ordcnt × 수량 | 부수=구간·디자인수=주문라인 | 디자인 건수를 가격 차원에 baked-in 금지(C-ST8) |

### 핵심 대조 시사점
1. **★제본비 `COMP_BIND_*` prc_typ .01(단가형)이 디지털 ×qty 결함과 동일 클래스 돈-크리티컬** — 제본비 단가(트윈링 3000~5000)가 "부수당(×수량)"인지 "묶음 총액"인지 엔진 evaluate_price 계약으로 확정. `min_qty` 1/4/10 구간이 있으니 **구간별 묶음 단가(.02 합가형 성격)일 가능성** — 디지털 명함(.01 평면화로 ×수량 3배 과청구)·아크릴(.02 정합 미확정) 종단의 prc_typ 검증 교훈 적용. **추측 적재 금지**.
2. **내지 단가 페이지 비례 = ×수량과 혼동 금지** — 내지비 = 1면 단가 × 페이지수(앱 계산)이지 부수×페이지 이중곱 금지. 페이지수(차원) × 부수(수량) × 1면단가 곱셈사슬 순서를 엔진 계약에 명시.
3. **후가공(박/PVC) 가산 = 부수당 1회 vs ×수량** — 디지털 결함과 동일 클래스. 후가공 comp prc_typ·수량축 정합 검증.
4. **수량 할인은 별 단계(t_dsc)** — 부수 구간할인(아크릴 B04 동형). 제본비×부수 후 구간할인 순서를 엔진 계약에 명시.

---

## 3. 흡수 종합 판정

1. **제본물 가격계산 골격(부품 합성 + 페이지 계층 + 표지/내지 분리 + 제본방식 분기)은 후니가 강력한 그릇으로 이미 보유** → `t_prd_product_sets`(28행 표지+면지 세트)·`t_prd_product_page_rules`(11행 페이지 규칙)·제본 comp 11종·합산형 공식. RedPrinting `book2025`(INN_PAGE·표지/내지 WGT)·WowPress(jobcost·paperno 다단)와 **1:1 동형**(C-ST1·C-ST2·C-ST3 = 그릇 존재).
2. **실질 흡수 = 그릇을 가격 합산 공식에 실제 배선**(C-ST1·C-ST3) — 후니 라이브 가격사슬은 "제본비 단일항"만 배선(`PRF_BIND_SUM` broken·표지/내지/인쇄 comp 미배선·`[huni:dwire]` D-WIRE 4/1). **vessel-gap 아닌 data/배선-gap**. 부품 comp 단가행 확보(권위 가격표 260527 제본물 시트) + 상품별 공식 1:1 배선이 핵심.
3. **★D-BIND-SCOPE 인간 결정 필요** — "책자=제본비 단일 합산"(라이브 현황) vs "표지+내지+인쇄+제본 부품 합산"(경쟁사 동형·세트 그릇 보유). **권위 가격표가 부품별 단가를 주면 부품 합산이 정답**(경쟁사 = 부품 합산 입증). designer/arbiter 판정 입력.
4. **약한 보강 2건(C-ST5 책등·C-ST4 제본 분기)** — 책등=앱 계산·제본=comp/frm_cd로 닫힘. 엔진 코드 분기는 overfit.
5. **흡수 부결 1건(C-ST6 jobqty→jobcost 2단)** — WowPress 작업량 2단 엔진은 후니 단일 evaluate_price + 앱 계산/단가 룩업 분리로 이미 표현·코드 분기 답습 금지.
6. **신규 가격축/테이블 신설 = 0건** — rpmeta TP "페이지 계층·형태·제본 = 기존 옵션/공정/제약 facet·distinct 부결"과 정합(search-before-mint 통과).
7. **모든 흡수는 권위 엑셀이 최종** — 경쟁사가 가격표(제본물 시트)와 충돌하면 가격표가 이긴다.

### designer로 넘기는 핵심 입력
- **제본물 = 부품 합성 공식**(표지비 + 내지비[페이지수 차원] + 제본비 + 후가공 Σ·`addtn_yn`·C-ST1) — `t_prd_product_sets` 세트 부품을 합산 배선. **단 D-BIND-SCOPE(제본비 단일 vs 부품 합산) 인간 결정 선결**.
- **페이지수 = 입력 차원**(`t_prd_product_page_rules`)·**내지 단가 = 1면(또는 1대) × 페이지수 앱 계산**(단가행 폭발 금지·C-ST2). 책등 두께 = 페이지수 파생 앱 계산(C-ST5).
- **표지/내지 자재 = 세트 별 부품 prd**(`t_prd_product_sets`·면지 색상 = 별 부품 단가·C-ST3).
- **제본방식 = 별 comp + 상품별 공식 1:1**(공유 `PRF_BIND_SUM` broken 해소·`[huni:dwire]`·C-ST4) — 엔진 코드 분기 아닌 데이터.
- **★돈-크리티컬**: 제본비 `COMP_BIND_*` prc_typ **.01 단가형 정합**(부수당×수량 vs 구간 묶음 총액) — `min_qty` 1/4/10 구간이 있어 .02 합가형 성격 가능. 디지털 ×qty 과청구·아크릴 .02 미확정과 동일 클래스(엔진 evaluate_price 계약으로 확정·추측 적재 금지).
- **할인 적용 순서**(제본비×부수 후 구간할인 t_dsc)·**이중수량 분리**(부수=수량구간·디자인수=주문라인·C-ST8)를 엔진 계약에 명시.
- **떡메모지/노트/다이어리는 가격사슬 전무**(`frm_cd=NULL`·`[huni:book]`) — 풀제본·묶음 단가로 신규 설계(C-ST7·권위 가격표 단가 추출).
