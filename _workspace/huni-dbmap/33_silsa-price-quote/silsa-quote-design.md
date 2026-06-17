# 실사(포스터사인) 가격 견적 정립 — round-23 Phase B (최종)

> **작성** 2026-06-17 · round-23 Phase B. 입력 = `silsa-dimension-analysis.md`(항목 2·3·6 분석·GO) + `component-inventory.md`(항목 1·4 실측·C-1~C-6/G-1~G-6). **설계 + DRY-RUN 핸드오프까지 — 실 COMMIT은 인간 승인.**
>
> **권위(HARD):** 실사 가격 = 가격표 `포스터사인` 시트 `[가로×세로]` 면적매트릭스 (메모리 [[dbmap-silsa-price-via-poster-sign]]). 라이브 가격엔진은 사이즈를 `siz_cd`(FK→t_siz_sizes)로만 매칭(가로/세로 수치 컬럼 부재·라이브 실측). round-2 면적-좌표 회귀 금지·search-before-mint 엄수.
>
> **라이브 실측:** Railway read-only SELECT, 2026-06-17. 비밀값 비노출·DB 쓰기 0.

---

## 0. 핵심 결정 (5)

1. **항목 3 = A안(siz_cd 기초코드) 확정.** 가격엔진이 사이즈를 siz_cd로만 매칭 → B안(옵션화)은 면적단가가 가격사슬을 벗어남(돈-크리티컬). 라이브 선례·정규화 전건 A안.
2. **좌표 채번 규모 불일치 해소(실측):** 매트릭스 13개 distinct 좌표 = **112종** → EXACT 4 + REVERSED 2 = **6 재사용**, **NONE 106 신규 채번**(`SIZ_000518~000623`). round-16의 "667 미실재"는 28상품 전체 행수(밴드·이산 중복 포함)였고, 매트릭스만의 distinct는 112(106 신규)가 정답 — round-2 정정과 일치.
3. **항목 4 통합 = C-1/2/3(오시·가변텍스트·가변이미지) GO**(dim_vals 정본 흡수·레거시 use_yn=N·단가행 재적재 0) + **C-4(미싱) prc_typ 정정 동반 GO**(1L=.02→.01 통일 + 줄수 dim_vals 재정규화) + **C-5(귀돌이) 조건부**(proc_cd 정합 선행) + **C-6(별색)·제본 통합 비대상**.
4. **🔴 선결 데이터 정합:** 별색 WHITE_S1 **530행 중 초과중복 424행**(키 5중복·실측) 제거 → 53행 정상화. 제본 11 comp 중 **10 고아(미배선)** — 실사 직결 아니나 책자/캘린더 견적 차단.
5. **가격사슬 부분단절 해소 = 소재별/유형별 공식 분리.** 28상품 전건 `PRF_POSTER_FIXED` 단일 바인딩·배선 1 comp → 인화지 외 27상품 조회불가. 유형별 공식(면적 13 + 고정가 15) + 자기 comp 배선 + 바인딩 교체.

---

## 1. 항목 3 최종 — 매트릭스 사이즈 = A안(siz_cd 등록) + 좌표 채번 확정 목록

### 1.1 결정: A안 확정 (근거 재확인)

| 근거 | 실측 |
|------|------|
| 가격엔진 사이즈 매칭 | `t_prc_component_prices.siz_cd` FK만. 가로/세로 수치 컬럼 부재 |
| 면적매트릭스 선례 | 실사·현수막·아크릴 comp 전건 siz_cd(plt_siz_cd·dim_vals 사이즈 용도 0건) |
| t_siz_sizes 표현력 | work_width/height·cut_width/height 보유 → siz_cd 1행 = 가로×세로 정규 표현 |
| B안 불가 | option_items에 add_price 컬럼 부재 → 면적단가를 옵션으로 못 담음([[dbmap-acrylic-price-chain-link]]) |

### 1.2 좌표 채번 규모 해소 (라이브 383 좌표 siz 재대조 실측)

- **포스터사인 13 매트릭스 distinct (가로×세로) = 112종** (엑셀 13개 `가로/세로` 헤더 × 데이터행 추출).
- 라이브 `t_siz_sizes`(use_yn=Y 517행) work/cut 양방향 대조:

| 판정 | 종수 | 의미 |
|------|:---:|------|
| **EXACT** | 4 | 정방향(W,H) 이미 등록 → 재사용 |
| **REVERSED** | 2 | 역방향(H,W)만 등록 → 컨펌 후 재사용 vs 신규(Q-A4) |
| **NONE** | **106** | 신규 채번 필요 |

- **불일치 해소:** round-16 "667"은 28상품 전체 물리행(밴드·이산 포함, 중복 산입)·round-2 "211"은 POSTER 106 + ACRYL 105 합산. **포스터사인 매트릭스만의 신규 = 106**으로 확정(round-2 POSTER 부분과 일치). 아크릴 105는 별 트랙.

**EXACT 4(재사용):** `900x900=SIZ_000323` · `900x1200=SIZ_000320` · `1000x1500=SIZ_000402` · `5000x900=SIZ_000322`.
**REVERSED 2(컨펌):** `1200x900`→역방향 SIZ_000320(=900x1200) · `1800x600`→SIZ_000321(=600x1800). 직접입력형이라 면적동일 재사용 정당 가능하나 의미축(가로≠세로) 보존 필요 시 신규 — Q-A4.

### 1.3 신규 좌표 siz 코드행 선적재 제안 (106행·search-before-mint 통과)

- **siz_cd 채번:** 라이브 max `SIZ_000517` → 신규 **`SIZ_000518` ~ `SIZ_000623`**(연번 106). 직접 mint 금지 — 코드행 선적재 제안(round-5 dbm-ddl-proposer/load-builder 환원).
- **siz_nm 컨벤션:** `{width}x{height}`(라이브 `316x467`·`600x1800` 일관).
- **work/cut:** 직접입력형(자유 사이즈) → work_width=W·work_height=H·cut=work(여백 0). impos_yn='N'(조판 무관·실사 면적), use_yn='Y'.
- 산출 데이터: `/tmp/new_siz_rows.json` (Phase C 코드행 CSV로 환원). 예:

```
SIZ_000518 | 600x600   | W600  H600
SIZ_000519 | 600x800   | W600  H800
...
SIZ_000623 | 5000x1750 | W5000 H1750
```

> **컨펌 Q-A3:** 영구 격자 전건(106) vs 부분 채번. 권고 = **전건 106**(매트릭스 셀 전부 FK 연결 가능·off-grid는 런타임 ceiling, DB는 격자만). 면적조합이 시트에 명시된 정당 격자라 전건 등록이 무손실.

---

## 2. 항목 4 최종 — 구성요소 통합 정립 (확정 명세)

판별 = 같은 prc_typ + 같은 차원축 + 줄수/개수/형상만 다른 파라미터형 → 정본 comp + dim_vals 흡수. **단가행 재적재 0**(정본에 이미 존재).

### 2.1 C-1/2/3 GO — dim_vals 정본 흡수 (오시·가변텍스트·가변이미지)

| 통합 | 정본 comp(유지) | 폐기(use_yn=N) | 흡수 차원 | 단가행 재적재 |
|------|----------------|----------------|-----------|:---:|
| **C-1 오시** | `COMP_PP_CREASE_1L`(30행, dim_vals.줄수 1/2/3 보유) | `_2L`(10) · `_3L`(10) | dim_vals.줄수 | **0** |
| **C-2 가변텍스트** | `COMP_PP_VARTEXT_1EA`(69행, dim_vals.개수 1/2/3) | `_2EA`(23) · `_3EA`(23) | dim_vals.개수 | **0** |
| **C-3 가변이미지** | `COMP_PP_VARIMG_1EA`(69행, dim_vals.개수 1/2/3) | `_2EA`(23) · `_3EA`(23) | dim_vals.개수 | **0** |

- **재적재 0 입증:** 정본 1L/1EA에 줄수/개수 1/2/3이 dim_vals로 이미 전건 적재됨(component-inventory §1 실측: CREASE_1L 30행=줄수 1/2/3 × 10구간, VARTEXT_1EA 69행=개수 1/2/3 × 23구간). 레거시 2L/3L·2EA/3EA는 동일 값 중복 → use_yn=N만으로 의미손실 0.
- **배선 교체:** 레거시 comp가 PRF_DGP_A·PRF_DGP_D에 배선돼 있으면 정본 comp로 재지정(formula_components comp_cd 교체). 엔진은 dim_vals.줄수/개수로 단가 선택.

### 2.2 C-4 GO — 미싱 통합 + prc_typ 정정 (방식 불일치 교정)

라이브 실측(PERF_TYP): `PERF_1L=PRICE_TYPE.02`(30행·opt_cd OPV-000007/8/9 줄수) / `_2L=.01`(10·무축) / `_3L=.01`(10·무축).

| 단계 | 조치 |
|------|------|
| 1. prc_typ 통일 | `COMP_PP_PERF_1L.prc_typ_cd` **.02 → .01**(형제 2L/3L·오시·가변 전부 .01 단가형과 정합). 미싱은 개당 단가형이지 합가형 아님(오시 동형) |
| 2. 차원 재정규화 | 1L의 줄수 표현을 `opt_cd`(OPV) → **dim_vals.줄수**로 통일(오시·가변과 동형). opt_cd 의존 제거 |
| 3. 통합 | 정본 `COMP_PP_PERF_1L` + dim_vals.줄수 1/2/3 → `_2L`·`_3L` use_yn=N |
| 4. 단가행 | 1L에 줄수 1(30행)만 존재 → **줄수 2/3 단가행을 2L/3L에서 1L로 이설**(dim_vals.줄수=2/3 부여). C-1~3과 달리 **이설 필요**(1L에 줄수2/3 미존재) |

> **C-4 주의:** C-1/2/3은 정본에 전 줄수/개수가 이미 있어 재적재 0이지만, **미싱 1L은 줄수 1만** 보유(opt_cd로 2/3 분기). 따라서 2L/3L 단가행 20행을 1L로 dim_vals.줄수=2/3 부여해 **이설(migrate)** 필요. 값 동일·신규값 0(이설이지 신규 아님). Phase C에서 INSERT(1L 줄수2/3) + DELETE(2L/3L) 또는 UPDATE comp_cd+dim_vals.

### 2.3 C-5 조건부 — 귀돌이 (proc_cd 정합 선행)

라이브 실측(PROC_CHK): `CORNER_ROUND`=PROC_000027(9)+000028(9) / `CORNER_RIGHT`=PROC_000028(9). proc_cd 혼재.

- **선행:** proc_cd 정합 — 둥근=PROC_000028(둥근 모서리), 직각=PROC_000027(직각 모서리)로 명확화(현 혼재 교정). round-22 공정축 정답규칙 대조 필요.
- **통합:** proc_cd 정합 후 `COMP_PP_CORNER` 단일 + dim_vals.형상(둥근/직각). **단 형상별 proc_cd가 다르면**(둥근≠직각 공정) dim_vals 흡수 부적합 — 형상=공정종류이므로 **별 comp 유지가 정답일 수 있음**. → **Q-A5: 귀돌이 통합 보류 권고**(공정종류 차이는 줄수형 파라미터 아님, 제본과 동류). 무리한 통합 금지 원칙.

### 2.4 통합 비대상 (의미손실·통합 금지)

- **C-6 별색 색상 10 comp:** 색마다 단가 다름 + S1/S2 별 comp로 공식 배선 운용 중 → 현행 안정성 우선. 통합 보류.
- **제본 11 comp:** 공정종류(중철/무선/PUR/트윈링/하드커버/캘린더)가 본질적으로 다름 → 줄수형 아님. 통합 금지(배선 결함은 §4에서 별도 해소).

---

## 3. 항목 5 — 실무진 가독성 정비안 (round-17 기준: 내부 행번호 금지·한국어 식별)

| comp_cd | 현 comp_nm | 정비 comp_nm | 정비 note |
|---------|-----------|--------------|-----------|
| COMP_BIND_JUNGCHEOL | 제본비(후가공) [COMP_BIND_JUNGCHEOL] | **중철 제본비** | 책자를 가운데 철심으로 묶는 제본 |
| COMP_BIND_MUSEON | 제본비(후가공) [COMP_BIND_MUSEON] | **무선 제본비** | 책등을 풀로 붙이는 제본(실/철심 없음) |
| COMP_BIND_PUR | 제본비(후가공) [COMP_BIND_PUR] | **PUR 제본비** | 강력 접착제(PUR) 무선제본 |
| COMP_BIND_TWINRING | 제본비 | **트윈링 제본비** | 이중 링으로 묶는 제본 |
| COMP_BIND_HC_MUSEON | 제본비(후가공) [COMP_BIND_HC_MUSEON] | **하드커버 무선 제본비** | 양장 표지 + 무선제본 |
| COMP_BIND_HC_TWINRING | 제본비(후가공) [COMP_BIND_HC_TWINRING] | **하드커버 트윈링 제본비** | 양장 표지 + 트윈링 |
| COMP_BIND_SSABARI | 하드커버 제본비 | **하드커버(싸바리) 제본비** | 합지 표지 양장제본 |
| COMP_BIND_CAL_DESK130/220/MINI | 제본비(후가공) [코드] | **탁상달력 제본비(130/220/미니)** | 탁상용 캘린더 스프링 제본(높이/형) |
| COMP_BIND_CAL_WALL | 캘린더 제본비 | **벽걸이달력 제본비** | 벽걸이 캘린더 제본 |
| COMP_PP_CORNER_ROUND | 모서리 둥근 | **귀돌이(둥근 모서리)** | 모서리를 둥글게 깎는 가공 |
| COMP_PP_CORNER_RIGHT | 모서리 비 | **직각 모서리(귀돌이 없음)** | 모서리 가공 안 함(직각) |
| COMP_PP_CREASE_1L | 오시비 | **오시(접는 줄)** | 접기 쉽게 누름선(줄수=dim_vals) |
| COMP_PP_PERF_1L | 미싱비 | **미싱(점선 절취)** | 떼어내기 쉬운 점선(줄수=dim_vals) |

> 디지털/별색인쇄비는 component-inventory에서 이미 ✅ 가독성 통과(흑백/칼라·단/양면·색·면 명시) — 정비 불요.

---

## 4. 항목 2 마무리 — 실사 견적 공식별 구성요소 배선 명세 (가격사슬 단절 해소)

### 4.1 현 단절 (라이브 실측)

- 28상품(PRD_000118~145) 전건 `PRF_POSTER_FIXED` 바인딩 + 배선 1 comp(`COMP_POSTER_ARTPRINT_PHOTO`) → 인화지 외 27상품 조회불가.

### 4.2 해소 = 유형별 공식 분리 + 자기 comp 배선 + 바인딩 교체

면적 13(siz_cd) + 고정가/밴드 15(siz_cd[+min_qty]). 메모리 [[dbmap-price-chain-dwire-per-product-formula]] 상품별 공식.

| 공식(신규) | 바인딩 상품 | 본체 comp(면적/규격단가) | 후가공 add-on(addtn_yn=Y, 선택) |
|-----------|------------|--------------------------|--------------------------------|
| `PRF_POSTER_ARTPRINT` | PRD_000118 | COMP_POSTER_ARTPRINT_PHOTO | (오시/미싱/귀돌이/가변 통합 comp 선택 배선) |
| `PRF_POSTER_ARTPAPER` | PRD_000119 | COMP_POSTER_ARTPAPER_MATTE | 〃 |
| `PRF_POSTER_WATERPROOF` | PRD_000120 | COMP_POSTER_WATERPROOF_PET | 〃 |
| `PRF_POSTER_ADH_WP` | PRD_000121 | COMP_POSTER_ADH_WATERPROOF_PVC | 〃 |
| `PRF_POSTER_ADH_CLEAR` | PRD_000122 | COMP_POSTER_ADH_CLEAR_PVC | 〃 |
| `PRF_POSTER_ARTFABRIC` | PRD_000123 | COMP_POSTER_ARTFABRIC_GRAPHIC | 〃 |
| `PRF_POSTER_LINEN` | PRD_000124 | COMP_POSTER_LINEN_FABRIC | 〃 |
| `PRF_POSTER_CANVAS` | PRD_000125 | COMP_POSTER_CANVAS_FABRIC | 〃 |
| `PRF_POSTER_LEATHER_AP` | PRD_000126 | COMP_POSTER_LEATHER_ARTPRINT | 〃 |
| `PRF_POSTER_TYVEK` | PRD_000127 | COMP_POSTER_TYVEK_PRINT | 〃 |
| `PRF_POSTER_MESH` | PRD_000128 | COMP_POSTER_MESH_PRINT | 〃 |
| `PRF_POSTER_BANNER_N` | PRD_000138 | COMP_POSTER_BANNER_NORMAL | 현수막 가공/추가 옵션 comp |
| `PRF_POSTER_BANNER_M` | PRD_000139 | COMP_POSTER_BANNER_MESH | 〃 |
| `PRF_POSTER_FIXED_*` (고정가 15) | PRD_000129~137·140~145 | 규격단가 comp(폼보드/액자/족자/배너/시트커팅/미니류) | 거치대/우드행거/우드봉/천정고리 옵션 comp |

- **add-on 배선 경로 컨펌(Q-A6):** 후가공/옵션 = formula_components addtn_yn=Y 합산 vs CPQ option(add_price 컬럼 부재) → **합산형 권고**(라이브 선례 `COMP_POSTEROPT_*` 별 comp 합산). component-inventory의 통합 comp(오시 CREASE_1L·미싱 PERF_1L·귀돌이·가변)를 후가공 add-on으로 선택 배선.
- **frm_typ_cd:** 라이브 부재(round-17 확정) → 공식 레벨 유형 미설정, 구성요소 prc_typ로 계산.

### 4.3 실사 본체 vs 후가공 정합 전제

- 실사 본체 = `COMP_POSTER_*`(PRC_COMPONENT_TYPE.06 완제품 통가격·코팅포함). 후가공(오시/미싱/귀돌이/가변)이 붙으면 통합 comp 합산.
- **선결(G-1/G-2):** 별색 WHITE 중복·미싱 prc_typ 불일치는 실사 외 상품군 공통이나, 통합·배선 전 **데이터 정합 선결**(§5).

---

## 5. Phase C 실행본 핸드오프 (load-builder 적재/교정 단위 명세)

> 멱등 SQL + 롤백전용 DRY-RUN(R1~R6). 단가행 재적재 최소·이설/정정만. **실 COMMIT 인간 승인.**

| 단위 | 테이블 | 조치 | 행수 | 멱등키 | 위험 |
|------|--------|------|:---:|--------|:---:|
| **U1 좌표 siz 코드행** | t_siz_sizes | INSERT 신규 좌표(SIZ_000518~623) | 106 | siz_cd / siz_nm | 저(부모행·자식 FK 무영향) |
| **U2 면적 단가행 적재** | t_prc_component_prices | 매트릭스 셀 → (comp_cd, siz_cd, unit_price) 언피벗 | ~687(GAP) | 자연키 8컬럼 | 중(BLOCKED siz U1 선행) |
| **U3 C-1/2/3 통합** | t_prc_price_components / formula_components | 정본 유지·레거시 use_yn=N·배선 comp_cd 교체 | comp 6 use_yn=N | comp_cd | 저(재적재 0) |
| **U4 C-4 미싱 통합+정정** | t_prc_price_components / component_prices | PERF_1L prc_typ .02→.01·dim_vals.줄수 재정규화·2L/3L 단가행 1L 이설·use_yn=N | 정정 1 + 이설 20 | comp_cd+dim_vals | 중(이설=값동일·신규0) |
| **U5 별색 WHITE 중복제거** | t_prc_component_prices | WHITE_S1 530→53(초과중복 424 DELETE, 키별 1행 유지) | DELETE 424 | 자연키 | **🔴 고**(어느 행 유지 규칙 확정·DRY-RUN 필수) |
| **U6 가격사슬 공식 분리** | price_formulas / formula_components / product_price_formulas | 유형별 공식 신규 + 자기 comp 배선 + 바인딩 교체(28상품) | 공식 ~28 + 배선 + 바인딩 28 | frm_cd / (frm_cd,comp_cd) / (prd_cd,frm_cd) | 중(PRF_POSTER_FIXED→유형별) |
| **U7 제본 고아 배선** | formula_components | 10 제본 comp → 해당 책자/캘린더 공식 배선 | 10 | (frm_cd,comp_cd) | 중(실사 외·책자 트랙) |
| **U8 가독성 정비** | t_prc_price_components | comp_nm/note 한국어 정비(§3) | ~13 UPDATE | comp_cd | 저(비-가격) |

- **선결 순서:** U1(siz) → U2(면적단가) ; U3/U4(통합) 독립 ; **U5(WHITE 중복) 선결** → U6(공식분리)·U7(제본) ; U8 독립.
- **단가행 재적재 0 입증 대상:** U3(C-1/2/3 정본에 전건 존재)·U6/U7(배선만·단가 불변). U2는 신규 면적단가(BLOCKED 해소), U4는 이설(값동일), U5는 삭제(중복).

---

## 6. 미해소 컨펌 (Phase C 인계)

| ID | 컨펌 | 권고 |
|----|------|------|
| Q-A3 | 좌표 siz 전건 106 vs 부분 채번 | 전건 106(무손실) |
| Q-A4 | REVERSED 2종 역방향 재사용 vs 신규 | 의미축 보존 시 신규(직접입력형 면적동일 재사용도 가능) |
| Q-A5 | 귀돌이 C-5 통합 vs 별 comp 유지 | 형상=공정종류면 별 comp 유지(통합 보류) |
| Q-A6 | add-on 배선 = formula_components 합산 vs CPQ | 합산형(라이브 선례·option add_price 부재) |
| Q-A7 | U5 WHITE 중복 어느 행 유지 규칙 | 최신 reg_dt 또는 동일값 임의 1행(DRY-RUN로 동일성 검증 선행) |
| Q-A8 | U6 공식 분리 = 소재별 vs 단일공식 조건분기 | webadmin Phase11 엔진 설계 확인(엔진 미구현 시 실청구0) |

---

## 7. read-only 준수

- 라이브 SELECT만(siz 517·좌표대조·WHITE 중복·제본 배선·미싱 prc_typ·귀돌이 proc_cd·max siz_cd). INSERT/UPDATE/DDL/COMMIT 0. 비밀값 미출력.
- 생성자≠검증자: 본 정립안의 GO 판정은 dbm-validator 독립 게이트. 실 적용은 인간 승인.
