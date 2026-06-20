# component-inventory.md — 디지털인쇄 가격구성요소 통합 인벤토리

> 디지털인쇄가 가격에 쓰는 구성요소(comp)의 통합 인벤토리. 요소·차원(use_dims)·단가소스·재사용 후보.
> 권위: calc-formula-draft(요소 분해) + 라이브 t_prc_price_components(실측 use_dims·단가행수, 2026-06-20).
> 산출자: hpe-formula-cartographer. 단가행수=`t_prc_component_prices` COUNT(실측).

---

## 1. 라이브 실재 comp (디지털인쇄 6공식 + 고정가 2공식)

| comp_cd | comp_nm | comp_typ | prc_typ | use_dims (차원) | 단가행수 | 쓰는 공식 |
|---------|---------|----------|---------|-----------------|---------|-----------|
| COMP_PRINT_DIGITAL_S1 | 디지털인쇄비 | .01 인쇄 | .01 단가 | proc_cd, plt_siz_cd, print_opt_cd, min_qty, proc_grp:PROC_000001 | **212** | A·B·C·D·E·F |
| COMP_PRINT_SPOT_WHITE_S1 | 별색인쇄비(정본) | .01 인쇄 | .01 | plt_siz_cd, proc_cd, print_opt_cd, min_qty, proc_grp:PROC_000007 | **530** | A |
| COMP_PAPER | 용지비(종이별 절가) | .03 소재 | .01 | siz_cd, mat_cd | 56 | A·B·C·D·E·F |
| COMP_COAT_GLOSSY | 유광코팅비 | .02 코팅 | .01 | siz_cd, coat_side_cnt, min_qty | (D/E 공용) | A·D·E |
| COMP_COAT_MATTE | 무광코팅비 | .02 코팅 | .01 | siz_cd, coat_side_cnt, min_qty | 92 | A·D·E |
| COMP_CUT_FULL_DIECUT | 커팅 완칼(모양엽서·라벨택) | .06 커팅 | .01 | siz_cd, min_qty | 36 | B·F |
| COMP_FOLD_CARD_2H | 접지비 카드 2단 | .04 후가공 | .01 | min_qty | 48 | C |
| COMP_CUT_PERF_1H6 | 타공비(6mm) | .04 | .01 | proc_cd, min_qty, proc_grp:PROC_000079 | — | C·D·E |
| COMP_FOLD_LEAF_HALF/3FOLD/4ACC/4GATE | 접지비 리플렛(반/3단/4아코/4게이트) | .04 | .01 | min_qty | — | E |
| COMP_PP_CORNER_RIGHT | 귀돌이비 | .04 | .01 | proc_cd, min_qty, proc_grp:PROC_000026 | — | A·D |
| COMP_PP_CREASE_1L | 오시비 | .04 | .01 | proc_cd, min_qty, proc_grp:PROC_000029 | — | A·D |
| COMP_PP_PERF_1L | 미싱비 | .04 | .01 | proc_cd, min_qty, proc_grp:PROC_000030 | — | A·D |
| COMP_PP_VARTEXT_1EA | 가변텍스트 | .04 | .01 | proc_cd, min_qty, proc_grp:PROC_000085 | — | A·D |
| COMP_PP_VARIMG_1EA | 가변이미지 | .04 | .01 | proc_cd, min_qty, proc_grp:PROC_000085 | — | A·D |
| COMP_NAMECARD_STD_S1 | 스탠다드명함 완제품가 단면(용지포함) | (고정) | .01 | mat_cd, min_qty | **2** | NAMECARD_FIXED |
| COMP_NAMECARD_STD_S2 | 스탠다드명함 완제품가 양면(용지포함) | (고정) | .01 | mat_cd, min_qty | **2** | NAMECARD_FIXED |
| COMP_PHOTOCARD_SET | 포토카드 완제품가 일반세트 | (고정) | .01 | siz_cd, bdl_qty, min_qty | **1** | PHOTOCARD_FIXED |
| COMP_PHOTOCARD_CLEAR_SET | 포토카드 완제품가 투명세트 | (고정) | .01 | siz_cd, bdl_qty, min_qty | **1** | PHOTOCARD_FIXED |

★ 단가행 결손 의심: NAMECARD S1/S2(각 2행)·PHOTOCARD(각 1행) — mat_cd/siz_cd×수량 매트릭스 대비 너무 적음. designer/검증 확인 필요(gap-board G-3).

---

## 2. 별색인쇄 형제 comp (논리삭제 — 정본 흡수)

| comp_cd | use_yn | del_yn | 처리 |
|---------|--------|--------|------|
| COMP_PRINT_SPOT_CLEAR_S1/S2 · GOLD_S1/S2 · PINK_S1/S2 · SILVER_S1/S2 · WHITE_S2 | N | **Y** | 정본 COMP_PRINT_SPOT_WHITE_S1로 dedup(530행이 5색×2면 통합·proc_cd/print_opt_cd 차원 분기) |

**[HARD] 별색=단일 comp + 차원** — designer는 색·면을 별 comp로 분할 금지(round-23 dedup 정합·[[dbmap-price-component-grouping]]).

---

## 3. 구성요소 유형별 차원 패턴 (재사용 후보)

| 비목 | 대표 comp | 차원 패턴 | 재사용 |
|------|-----------|-----------|--------|
| **인쇄비** | COMP_PRINT_DIGITAL_S1 | plt_siz_cd(출력판형)·print_opt_cd(도수)·min_qty(수량행)·proc_grp | 전 디지털인쇄 공유 |
| **별색** | COMP_PRINT_SPOT_WHITE_S1 | + proc_cd(색)·print_opt_cd(면) | 엽서류 |
| **용지비** | COMP_PAPER | siz_cd·mat_cd (종이별 절가, 손지율+5장 가설) | 전 디지털인쇄 공유 |
| **코팅비** | COMP_COAT_GLOSSY/MATTE | siz_cd·coat_side_cnt·min_qty | 엽서·전단·접지 |
| **커팅비(완칼)** | COMP_CUT_FULL_DIECUT | siz_cd·min_qty | 모양엽서·라벨택·썬캡 |
| **접지비** | COMP_FOLD_* | min_qty (타입=별 comp) | 카드·리플렛 |
| **타공비** | COMP_CUT_PERF_1H6 | proc_cd·min_qty | 배경지·전단·접지 |
| **후가공(낱개)** | COMP_PP_* | proc_cd·min_qty·proc_grp | 엽서·전단 |
| **완제품 고정가** | COMP_NAMECARD_*·PHOTOCARD_* | mat_cd 또는 siz_cd×bdl_qty × min_qty | 명함·포토카드(용지 통합) |

---

## 4. 단가 소스 셀 (가격표 매핑)

| comp | 단가 소스(가격표 시트·축) |
|------|---------------------------|
| 인쇄비 | 디지털인쇄비 시트 — [수량행][출력판형(국4절/3절)]×도수 |
| 별색 | 디지털인쇄 시트 — 인쇄비단가 + [출력매수 수량행]×[칼라열] (3절 별색 상품 없음) |
| 코팅 | 코팅 시트 — [수량행]×[코팅타입] |
| 용지비 | 출력소재 시트 — [크기별 기준단가] |
| 커팅 | 커팅/타공 시트 — 2000원[커팅가격테이블] |
| 접지 | 접지옵션 시트(카드)·인쇄후가공>오시(배경지) — [제작수량행 단가] |
| 타공 | 커팅/타공 시트 — 장당 1000원[타공가격테이블] |
| 후가공박(대형/소형) | 후가공_박 시트 — [면적별 동판비]+[면적별 A~E군 합가] |
| 명함 완제품가 | 명함/포토카드 시트 — [수량행][소재×면열](용지 포함) |
| 포토카드 | 명함/포토카드 시트 — [세트당 고정단가] |

---

## 5. designer를 위한 재사용 권고

- **공유 comp 4종**(인쇄비·별색·용지비·코팅비)이 디지털인쇄 전 원자합산 공식의 뼈대 → 신규 comp mint 금지, 차원으로 흡수.
- **고정가형은 "완제품 통합단가" comp 패턴** — 명함/포토카드는 용지·인쇄·코팅을 1개 단가행에 통합. 분해형(원자합산)으로 재모델 금지(상품마스터 권위 = 고정가).
- 후가공박(대형/소형)·접지리플렛·오리지널박명함은 **calc-draft가 요구하나 라이브 미배선** → designer 신설 큐(gap-board).

---

## 6. 아크릴 절 (면적매트릭스형) — 라이브 실측 2026-06-20

> 디지털인쇄와 구성요소 패턴이 다름(출력매수/별색/코팅 없음·면적 단가 통합). formula-map-acrylic.md 참조.

### 6-1. 라이브 실재 아크릴 comp

| comp_cd | comp_nm | comp_typ | prc_typ | use_dims (차원) | 단가행수 | 쓰는 공식 |
|---------|---------|----------|---------|-----------------|---------|-----------|
| COMP_ACRYL_CLEAR3T | 투명아크릴 인쇄가공비 | .01 인쇄 | **.02 합가**(min_qty=1) | siz_width, siz_height, mat_cd | **165**(3T=113·1.5T=52) | PRF_CLR_ACRYL |
| COMP_ACRYL_COROTTO | 아크릴코롯토 인쇄가공비 | .01 인쇄 | .01 단가 | siz_width, siz_height | **21** | PRF_COROTTO_ACRYL |
| COMP_ACRYL_MIRROR3T | 미러아크릴3T 인쇄가공비 | .01 인쇄 | .01 단가(min_qty 전건 NULL) | siz_width, siz_height | **52** | (미배선·공식 0 GAP) |
| COMP_ACRYL_CARABINER | (라이브 부재·신설 대기) | .06 완제품 | .01 단가 | opt_cd(형상) | 0(채번 대기) | (미설계 GAP) |

★ 단가행 결손 아님(238행 가격표 verbatim 풍부) — 결손은 **바인딩/배선**(미러 공식 0·카라비너 comp 0·본체 29상품 미바인딩).

### 6-2. 아크릴 차원 패턴 (디지털인쇄와 대조)

| 비목 | 대표 comp | 차원 패턴 | 디지털인쇄 대비 |
|------|-----------|-----------|----------------|
| **본체 면적단가** | COMP_ACRYL_CLEAR3T | siz_width·siz_height(2축 면적)·mat_cd(두께 3T/1.5T 직교) | ★출력매수/판형 없음·인쇄+레이저커팅+소재 단가 통합 |
| **코롯토 면적단가** | COMP_ACRYL_COROTTO | siz_width·siz_height | 단일소재·mat_cd 무관 |
| **미러 면적단가** | COMP_ACRYL_MIRROR3T | siz_width·siz_height | mat_cd 미사용(단가행 NULL)·미러=투명3T×2 |
| **카라비너 고정가** | COMP_ACRYL_CARABINER(신설) | opt_cd(형상) | 면적 아님·외주 완제품 고정가 |

**[HARD] 두께=mat_cd 직교·면적=siz_width/siz_height·도수/커팅=단가통합** — designer는 두께를 면적축에 섞거나 도수/커팅 별 comp로 분리 금지(라이브·가격표 정합).

### 6-3. 아크릴 단가 소스 셀 (가격표 매핑)

| comp | 단가 소스(아크릴 가격표 시트) |
|------|------------------------------|
| CLEAR3T(3T) | B01 투명아크릴3T [세로행]×[가로열] 매트릭스 |
| CLEAR3T(1.5T) | B02 투명아크릴1.5T [세로행]×[가로열](=3T×0.8) |
| MIRROR3T | B03 미러아크릴3T [세로행]×[가로열](셀 formula `=투명3T×2`) |
| COROTTO | B06 코롯토 [가로×세로] 21조합 |
| CARABINER | B07 4형상 고정가(5,800~6,900·치수=명칭설명) |

---

## 7. 실사·현수막(포스터사인) 구성요소 (라이브 실측 2026-06-20)

### 7-1. 면적매트릭스 본체 comp (use_dims=[siz_width,siz_height]·prc_typ=.01 단가형·동형결합 후 정본/단독)

| comp(정본) | 결합 소재 | 차원 | 단가행 | 골든(라이브 verbatim) |
|-----------|----------|------|:--:|----------|
| COMP_POSTER_CANVAS_FABRIC(정본A) | 캔버스·레더·메쉬프린트·타이벡 | siz_width·siz_height | 52 | 600×1800=37,800 |
| COMP_POSTER_ARTPRINT_PHOTO(정본B) | 아트프린트·방수·접착방수·아트패브릭 | siz_width·siz_height(·min_qty 선언잔류) | 52 | 600×1800=21,600 |
| COMP_POSTER_ADH_CLEAR_PVC(단독) | 접착투명 | siz_width·siz_height | 52 | 600×1800=59,400 |
| COMP_POSTER_LINEN_FABRIC(단독) | 린넨 | siz_width·siz_height | 52 | 600×600=17,000 |
| COMP_POSTER_ARTPAPER_MATTE(단독) | 아트페이퍼 | siz_width·siz_height | 39 | — |
| COMP_POSTER_BANNER_NORMAL(단독) | 일반현수막 | siz_width·siz_height | 79 | min_qty=1 전건 |
| COMP_POSTER_BANNER_MESH(단독) | 메쉬현수막 | siz_width·siz_height | 46 | — |
| (use_yn=N 레거시 6) | ADH_WP/ARTFABRIC/WATERPROOF/LEATHER_ARTPRINT/MESH_PRINT/TYVEK_PRINT | — | 52×6(보존) | 정본으로 배선 재지정·DELETE 0 |

### 7-2. 고정가/수량구간 본체 comp (use_dims=[siz_cd] 또는 [siz_cd,min_qty])

| comp | 상품 | 차원 | 비고 |
|------|------|------|------|
| FOAMBOARD_WHITE/BLACK·FOMEXBOARD_WHITE3MM/5MM | 폼보드·포맥스 | siz_cd | 규격 2행 |
| FRAMELESS_WOOD·LEATHER_FRAME·JOKJA·LINEN_WOODBONG·PET_BANNER·MESH_BANNER | 액자·족자·배너 | siz_cd·min_qty | 규격 |
| SHEETCUT_MATTE/HOLO·ACRYLSTK_GLOSS/MIRROR | 시트커팅·아크릴스티커 | siz_cd | 규격 3~4행 |
| CANVAS_HANGING | 캔버스행잉 | [siz_w,siz_h,min_qty] 선언↔실데이터 NULL·고정3종(G-S3) | 차원 정합 컨펌 |
| **MINI_BANNER·MINI_STANDBOARD** | 미니배너·미니보드 | **siz_cd·min_qty(수량밴드)** | ★수량구간형(4/19/49/99/10000 개당가 하락) |

### 7-3. 후가공/추가옵션 comp (라이브 실재·★formula 미배선=직교 단절 G-S1)

| comp | 의미 | 차원 |
|------|------|------|
| COMP_PP_CREASE_1L 오시·COMP_PP_PERF_1L 미싱·COMP_PP_CORNER_ROUND/RIGHT 귀돌이·COMP_PP_VARTEXT_1EA/VARIMG_1EA 가변 | 공통 후가공 | proc_cd·dim_vals(줄수/개수)·(미싱만 opt_cd 부정합 G-S2) |
| COMP_PRINT_SPOT_WHITE_S1/S2 별색 | 별색인쇄 | plt_siz_cd·proc_cd·print_opt_cd |
| COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4/6/8·BONGSEW·CUTEDGE·DTAPE·ADD_QBANG_4·ADD_STRING_4 | 현수막 가공(타공/봉미싱/열재단/큐방/끈) | opt_cd/proc_cd·min_qty |
| COMP_POSTEROPT_PET_BANNER_STAND_IN/OUT·CANVAS_HANGING_WOODHANGER·LINEN_WOODBONG_WOODBONG·JOKJA_CEILHOOK·LINEN_FINISH | 거치/우드행거/우드봉/천정고리/린넨마감 | siz_cd/opt_cd/bdl_qty |

**[HARD] 면적=siz_width/siz_height·고정가=siz_cd·수량구간=siz_cd+min_qty·후가공=합산형(addtn_yn=Y)** — designer는 면적/규격 축 혼동 금지, 후가공은 본체와 직교 합산. **재사용 후보: 후가공 comp 전부 실재(아크릴보다 우월·신규 mint 거의 0)**.

---

## 문구 절 (라이브 실측 2026-06-20) — formula-map-stationery.md 참조

문구는 디지털 원자합산 comp를 쓰지 않는다(재분류 §0). 라이브 comp는 **떡메모지 1개뿐**, 본체 9상품은 comp 전무(고정가 inline·미적재).

| comp_cd | comp_nm | comp_typ | prc_typ | use_dims (차원) | 단가행수 | 쓰는 공식 |
|---------|---------|----------|---------|-----------------|---------|-----------|
| COMP_TTEOKME | 떡메모지 완제품가(권당장수) | (고정·완제품) | **PRICE_TYPE.01 단가** | siz_cd, bdl_qty, min_qty | **112**(verbatim·NULL min_qty 0건) | PRF_TTEOKME_FIXED |

- 단가 소스: 인쇄상품 가격표 `엽서북떡메` 시트 (사이즈 90x90/70x120 × 권당장수 50/100 × 장수구간 6~600 28구간 = 112셀). unit_price 850~3200.
- siz_cd: SIZ_000119(90x90)·SIZ_000266(70x120). bdl_qty: 50/100(권당장수).
- ★prc_typ=.01 단가형이나 unit_price(3200)=묶음(권) 총액 → 엔진 unit×qty 시 ×qty 폭발 위험(디지털 동형·교정안 A `(unit÷min_qty)×qty` 후보). designer 골든 확정 필요(gap-board G-ST-3).

**본체 9상품(만년다이어리 4·먼슬리·스프링노트/수첩·메모패드·중철노트) = comp·고정가·바인딩 전무.** 가격 소스=상품마스터 AC열 inline 고정가(product_prices 0행). 재사용 후보 comp 없음 — designer가 고정가 그릇(product_prices 직접가 or 명함 PRF_NAMECARD_FIXED식 고정가 공식) 신설 결정(gap-board G-ST-1).

**재사용 후보(문구→타 종단):** COMP_TTEOKME use_dims=[siz_cd,bdl_qty,min_qty]는 디지털 COMP_PHOTOCARD_SET와 **동일 차원 구조**(세트/묶음 매트릭스). 떡메모·포토카드·엽서북 = 같은 "묶음(권/세트) 단가형" 패밀리.

## 책자 절 (반제품 세트·다부품 합산형 · 라이브 실측 2026-06-20) — formula-map-booklet.md 참조

책자 가격사슬에 존재하는 가격구성요소는 **제본비(COMP_BIND_*) 11종뿐** — 표지/내지/면지/인쇄 comp는 **0행(전무)**. 통합 comp 패턴([[dbmap-price-component-grouping]]): 활성 3개가 proc_cd 종류축으로 제본방식 통합, per-method 8개는 del_yn='Y' thin-mirror 선행본.

| comp_cd | comp_nm | comp_typ | prc_typ | use_dims (차원) | del_yn | proc 수 | 단가행 | 쓰는 공식 |
|---------|---------|----------|---------|-----------------|--------|--------|--------|-----------|
| **COMP_BIND_TWINRING** | 제본비 트윈링(통합) | .04 공정비 | **.01 단가형** | proc_cd, min_qty, proc_grp:PROC_000017 | **N** | 4(중철/무선/PUR/트윈링) | 32 | (PRF_BIND_SUM 재배선 대상) |
| **COMP_BIND_SSABARI** | 제본비 싸바리바인더(통합) | .04 | .01 | 동상 | **N** | 3(HC무선/HC트윈링/싸바리) | 18 | (하드커버 미배선) |
| **COMP_BIND_CAL_WALL** | 제본비 벽걸이캘린더(통합) | .04 | .01 | 동상 | **N** | 4(캘린더) | 24 | (캘린더 종단) |
| COMP_BIND_JUNGCHEOL~PUR·HC_*·CAL_DESK* | per-method 8종 | .04 | .01 | 동상 | **Y(삭제)** | 1 | 6~8 | thin-mirror 선행본 |

- 단가 소스: 인쇄상품 가격표 `제본` 시트 B01(일반 제본비·중철/무선/트윈링/PUR × 수량 1~1000)·B02(하드커버·하드커버무선/트윈링/싸바리 × 수량)·B03(캘린더). **단가 = 부당(권당) 제본비**(헤더 `제본/수량`·중철 4부=2000원/부). unit_price 500~30000.
- proc_cd: 중철=PROC_000018·무선=019·PUR=020·트윈링=021·하드커버무선=023·HC트윈링=024·싸바리=098·캘린더=099~102. proc_grp=PROC_000017(제본·상위그룹).
- ★prc_typ=.01 단가형이며 unit_price가 **진짜 부당가** → 엔진 `unit×qty` 올바름(디지털명함 묶음총액 ×qty 결함과 결정적 차이·가격표 헤더+엔진 코드 3중 입증).
- ★**데이터 정합 결함(G-BK-1)**: COMP_BIND_TWINRING의 **중철(PROC_000018) 8행이 트윈링 값(1=4000,4=3000…)으로 오염**(가격표 중철=3000/2000·삭제된 COMP_BIND_JUNGCHEOL이 정답값 보유). 무선/PUR/트윈링 proc_cd는 정상.

**표지/내지/면지/인쇄 가격구성요소 = 0행(전무).** 책자 다부품 합산(DT-BIND-SCOPE 부품 합산 방향) 시 표지 인쇄·용지비 + 내지 인쇄·용지비(×페이지) comp 신설 필요 — 단가 소스=디지털인쇄 종이비(COMP_PAPER 계열)·인쇄비. 그 comp의 prc_typ는 디지털 종단 묶음총액 ×qty 결함 상속 위험(교정 전파 점검).

**재사용 후보(책자→타 종단):** COMP_BIND_* 통합 comp 패턴(단일 comp + proc_cd 종류축)은 캘린더 제본·기타 공정비 통합에 동형. 엽서북(PRF_PCB_FIXED)·떡메모지·먼슬리는 떡제본/단일 고정가로 별도(문구 종단). 세트 그릇(t_prd_product_sets)은 하드커버/포토북/엽서북 횡단 공유(구성 BOM·가격축 아님).

---

## 굿즈/파우치 절 (고정가형 + 변형단가 · 라이브 실측 2026-06-20) — formula-map-goods-pouch.md 참조

굿즈/파우치는 **comp(가격구성요소) 자체를 쓰지 않는 가능성이 가장 큰 종단**이다. 계산방식이 고정가형이라 엔진 경로가 `PRODUCT_PRICE`(`t_prd_product_prices.unit_price × qty`·pricing.py:312-317)이며 component_prices/formula를 경유하지 않는다.

### 라이브 실재 comp = 0 (굿즈/파우치 전용 comp 전무)
- 98 활성상품(PRD_000183~280) 전부 `t_prd_product_price_formulas` 바인딩 0·`t_prd_product_prices` 0행·`option_items` 0. 굿즈 전용 가격구성요소(comp)는 라이브에 **하나도 없다.**
- 단 **인접 그릇 절반 실재(comp 아님)**: 수량구간할인 테이블 4종(DSC_GOODSA_QTY·DSC_GOODSB_QTY·DSC_SQUISHY_QTY·DSC_FABRIC_QTY)·구간할인 바인딩 82링크·자재 BOM 76상품/164링크(round-1·round-22 적재분).

### 가격 그릇 패턴 (designer 재사용 후보)
| 서브클래스 | 그릇 후보 | 차원 | 비고 |
|-----------|----------|------|------|
| **GP-1 단일고정가**(55상품) | `t_prd_product_prices` unit_price 1행 | (차원 없음·prd_cd당 1) | 명함/포토카드 PRODUCT_PRICE 동형이나 굿즈는 **공식 미경유**(완제품 통합단가도 아닌 순수 inline 고정가). 신규 comp mint 불요 |
| **GP-2 변형고정가**(31상품·★그릇 부재) | (b) PRF_GOODS_SIZED + COMP_GOODS_VARIANT | use_dims=[opt_cd] 또는 [siz_cd] (단축) | **아크릴 면적매트릭스(siz_width×siz_height)의 1축 축소판** — variant당 단가행 1개. component_prices 기존 그릇 재사용·엔진 변경 0. ★min_qty=1 명시 가드(.02 시 ÷min_qty) |
| **가공 가산** | 본체 + 정액(addtn_yn) 또는 option add | opt_cd | 라벨부착+300·맥세이프+6500·에폭시0. 소액 정액 |
| **추가상품(addon)** | `t_prd_product_addons`+`t_prd_templates`(SKU) | tmpl_cd | 잉크 5cc+2500·볼체인+1000(색상 variant)·아크릴스탠드 |

**★굿즈/파우치는 종단 중 유일하게 "comp가 정답이 아닐 수 있는" 종단.** GP-1은 PRODUCT_PRICE 직접가(comp 없음)가 정답·GP-2만 그릇 부재로 (b)formula+comp 도입 검토(컨펌 Q-GP-1). 디지털/아크릴/실사/책자의 comp 합산 모델을 굿즈에 답습하면 과설계(고정가형 권위 위반). 색상 variant는 가격 비기여(동가·재질행 합성 BOM만·[[dbmap-material-option-normalization]]).
