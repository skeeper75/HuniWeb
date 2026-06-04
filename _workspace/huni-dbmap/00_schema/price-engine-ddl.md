# 가격엔진 DDL 권위 해석 (round-2)

후니 POD 가격엔진의 **라이브 DDL(railway pg18.4)** 권위 해석 문서. round-2 가격 매핑의 진입 게이트.
[HARD] 적재 컬럼명·타입·제약은 **라이브 DDL 기준**. 최신 스펙 `table-spec_260603.html`(2026-06-03 생성, 29테이블/247컬럼)은 **라이브와 완전 정합** — 설계의도 권위로 사용. 구버전 `table-spec_260602.html`은 stale(컬럼명·길이 상이) → 사용 금지.
식별자/컬럼/코드값/SQL은 영어, 해석은 한국어.

권위 입력: `price-engine-ddl-raw.txt`(적재 권위) · `price-engine-fk-refs.md`(FK 부모 코드) · `pricing-erd__mermaid.md`(ERD) · `table-spec_260603.html`(최신 설계의도, 라이브 정합) · 상품마스터/가격표 엑셀.

---

## 1. 엔진 구조 모델 — 4단 엔진 + 상품바인딩 2

가격엔진은 **계산 엔진 4테이블 + 상품 바인딩 2테이블 = 6테이블**로 구성된다. 라이브 DDL에 7번째 보조 테이블 `t_prd_product_bundle_qtys`(상품별 묶음수 옵션)가 함께 추출됨(차원 보조).

### 엔진 코어 4단

| 단 | 테이블 | 역할(DB 주석) | PK | 비고 |
|----|--------|---------------|----|----|
| 1. 공식 헤더 | `t_prc_price_formulas` | 가격공식 | `frm_cd` | 명명된 공식 1행 (예: "디지털인쇄 원자합산형") |
| 2. 구성요소 카탈로그 | `t_prc_price_components` | 가격구성요소 | `comp_cd` | 재사용 가능 원가 항목(인쇄비/코팅비/용지비/후가공비/박형압비) |
| 3. 공식↔구성요소 배선 | `t_prc_formula_components` | 공식별구성요소 | `(frm_cd, comp_cd)` | 공식을 구성요소 조합으로 정의 + `disp_seq` 순서 + `addtn_yn` 합산여부 |
| 4. 다차원 단가 매트릭스 | `t_prc_component_prices` | 구성요소 다차원 단가 — 시계열 | `comp_price_id`(surrogate) | 구성요소별 실제 단가를 6차원 × 시계열로 보관. **엔진 최난도·핵심** |

### 상품 바인딩 2

| 테이블 | 역할(DB 주석) | PK | 비고 |
|--------|---------------|----|----|
| `t_prd_product_price_formulas` | 상품별가격공식 | `(prd_cd, frm_cd)` | 상품→공식 배정 (M:N). `apply_bgn_ymd`는 메모(키 아님) |
| `t_prd_product_prices` | 상품단가 — 시계열 | `(prd_cd, apply_ymd)` | 공식과 별개로 상품에 직접 매기는 단가. `(가격포함)` 상품용 |

### 보조 1 (차원 지원)

| 테이블 | 역할 | PK | 비고 |
|--------|------|----|----|
| `t_prd_product_bundle_qtys` | 상품별묶음수 | `(prd_cd, bdl_qty)` | 상품별 묶음수 옵션 세트. `component_prices.bdl_qty` 차원의 의미 원천. `bdl_unit_typ_cd` FK(QTY_UNIT: EA/매/권/세트) |

---

## 2. FK 그래프

```
t_cod_base_codes(cod_cd)
   ├─< t_prc_price_formulas.frm_typ_cd        (FRM_TYPE — 합산형/단순형)
   ├─< t_prc_price_components.comp_typ_cd      (PRC_COMPONENT_TYPE — 인쇄/코팅/용지/후가공/박형압)
   └─< t_prd_product_bundle_qtys.bdl_unit_typ_cd (QTY_UNIT — EA/매/권/세트)

t_prc_price_formulas(frm_cd)
   ├─< t_prc_formula_components.frm_cd         (ON DELETE RESTRICT)
   └─< t_prd_product_price_formulas.frm_cd     (ON DELETE RESTRICT)

t_prc_price_components(comp_cd)
   ├─< t_prc_formula_components.comp_cd        (ON DELETE RESTRICT)
   └─< t_prc_component_prices.comp_cd          (ON DELETE CASCADE)

t_prc_component_prices 차원 FK (모두 nullable, NULL=차원 무관)
   ├─ siz_cd  →< t_siz_sizes(siz_cd)           (497행)
   ├─ clr_cd  →< t_clr_color_counts(clr_cd)    (5행)
   └─ mat_cd  →< t_mat_materials(mat_cd)       (336행)
   · coat_side_cnt — integer, FK 없음
   · bdl_qty       — integer, FK 없음 (묶음수 PK가 복합이라 단독 FK 불가 → 차원 키로만 사용)
   · min_qty       — integer, FK 없음 (수량구간하한, max_qty 없음=상향개방)

t_prd_products(prd_cd)
   ├─< t_prd_product_price_formulas.prd_cd     (ON DELETE RESTRICT)
   ├─< t_prd_product_prices.prd_cd             (ON DELETE CASCADE)
   └─< t_prd_product_bundle_qtys.prd_cd        (ON DELETE RESTRICT)
```

[HARD] 적재 전 모든 FK 부모값(comp_cd/frm_cd/prd_cd/siz_cd/clr_cd/mat_cd/frm_typ_cd/comp_typ_cd/bdl_unit_typ_cd)이 부모 테이블에 **선존재**해야 함(읽기전용 검증). `t_prc_component_prices.comp_cd`·`t_prd_product_prices.prd_cd`는 `ON DELETE CASCADE`(부모 삭제 시 단가 동반 삭제), 나머지 엔진 FK는 `RESTRICT`(공식/구성요소 보호).

---

## 3. 적재 순서 (FK 그래프 위상정렬)

부모가 자식보다 먼저. 동일 단계 내는 병렬 가능.

```
[단계 0] 부모 코드/도메인 (선존재 가정 — 적재 대상 아님, 검증만)
   t_cod_base_codes, t_siz_sizes, t_clr_color_counts, t_mat_materials, t_prd_products

[단계 1] 엔진 부모 헤더 (병렬)
   t_prc_price_formulas      ← frm_typ_cd ∈ FRM_TYPE
   t_prc_price_components    ← comp_typ_cd ∈ PRC_COMPONENT_TYPE

[단계 2] 엔진 자식 (단계1 후, 병렬)
   t_prc_formula_components  ← frm_cd, comp_cd 선존재
   t_prc_component_prices    ← comp_cd, (siz/clr/mat)_cd 선존재
   t_prd_product_bundle_qtys ← prd_cd, bdl_unit_typ_cd 선존재

[단계 3] 상품 바인딩
   t_prd_product_price_formulas ← prd_cd, frm_cd 선존재

[독립] 상품 직접단가 (공식 무관, prd_cd만 필요 — 단계 0 후 언제든)
   t_prd_product_prices      ← prd_cd 선존재
```

---

## 4. `t_prc_component_prices` 6차원 의미

자연키 UNIQUE = **8컬럼**(`comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty`) = 구성요소 + 시계열 + **6차원**. `comp_price_id`는 surrogate PK(자동), 자연키가 진짜 중복 방지 키.

| # | 차원 컬럼 | 타입 | 의미 | FK 부모 | NULL 의미 | 엑셀 원천 |
|---|-----------|------|------|---------|-----------|-----------|
| 1 | `siz_cd` | varchar(50) | 사이즈/규격 | t_siz_sizes(497) | 규격 무관 | 출력소재 크기별 / 국4절·3절 규격 |
| 2 | `clr_cd` | varchar(50) | 도수(0~4도/CMYK) | t_clr_color_counts(5) | 도수 무관 | 디지털인쇄비 outer band(흑백/칼라/별색…) |
| 3 | `mat_cd` | varchar(50) | 자재/소재 | t_mat_materials(336) | 자재 무관 | 출력소재 / 소재열 / 별색잉크 후보 |
| 4 | `coat_side_cnt` | integer | 코팅면수 | (FK없음) | 코팅 무관 | 코팅 sheet 단면=1/양면=2 |
| 5 | `bdl_qty` | integer | 묶음수 | (FK없음, bundle_qtys 의미연결) | 묶음 무관 | 상품별 묶음 옵션(세트/EA) |
| 6 | `min_qty` | integer | 수량구간하한 | (FK없음) | 구간 무관 | 단가시트 수량행(출력매수/제작수량) |

핵심 의미 규칙:
- **`clr_cd` = 도수 축**: 0도(인쇄안함)/1도(흑백)/2도/3도/CMYK 4도 5종뿐. **별색(화이트/클리어/핑크/금색/은색) 자리 없음** → fit-gap 불일치(§6 G-1).
- **단/양면**은 6차원에 전용 축이 없다. 코팅의 단/양면은 `coat_side_cnt`(1/2)로 흡수되지만, **인쇄(디지털인쇄비)의 단/양면**은 coat가 아니므로 흡수 불가 → fit-gap(§6 G-2).
- **`min_qty` = 수량구간하한이며 상향개방**: `max_qty` 컬럼 없음. 한 구간 행은 `min_qty` 이상 다음 구간 `min_qty` 미만까지 적용(round-1 구간할인과 동일 패턴). 마지막 구간은 무제한.
- **수량 의미**: 단가시트 수량행은 **출력매수(print-sheet count)**이지 주문수량이 아니다. 주문수량→출력매수 변환(÷판걸이수)은 공식 단계(`계산공식집초안` (1))로 보존하고 단가행에 baked-in 금지.

---

## 5. 계산 흐름 (상품→공식→구성요소→다차원단가 ; 상품직접단가)

```
주문 입력 (상품 prd_cd, 옵션: 규격/도수/단·양면/코팅/수량 등)
  │
  ├─[A. 공식 경로]──────────────────────────────────────────────
  │   1. t_prd_product_price_formulas[prd_cd] → frm_cd  (상품에 배정된 공식)
  │   2. t_prc_price_formulas[frm_cd] → frm_typ_cd       (FRM_TYPE.01 합산형 / .02 단순형)
  │   3. t_prc_formula_components[frm_cd] → comp_cd[] (disp_seq 순, addtn_yn)
  │        = {인쇄비, 코팅비, 용지비, 후가공비, 박형압비} 중 필요분
  │   4. 각 comp_cd 마다:
  │        t_prc_component_prices에서 (comp_cd, 최신 apply_ymd,
  │          siz_cd=규격, clr_cd=도수, mat_cd=자재,
  │          coat_side_cnt=코팅면수, bdl_qty=묶음, min_qty≤출력매수 최대구간)
  │        조건으로 unit_price 1건 조회 (안 쓰는 차원=NULL 매칭)
  │   5. 합산형: 판매가 = Σ(unit_price × 단계계수)   (addtn_yn='Y' 항목 합)
  │      단순형: 판매가 = 단일 component 또는 고정 transform
  │
  └─[B. 상품 직접단가 경로]────────────────────────────────────
      t_prd_product_prices[prd_cd, 최신 apply_ymd] → unit_price (그대로 사용)
      → `(가격포함)` 상품(문구/굿즈파우치/포토북 등) 전용. 공식·구성요소 미사용.
```

엑셀 근거(`계산공식집초안`): "판매가 = 인쇄비 + 코팅비 + 용지비 + 후가공비 + 추가상품" 형태가 **원자합산형**(→ FRM_TYPE.01 합산형 + 4단 엔진 풀배선). `(가격포함)` 시트 상품은 **고정가형**(→ `t_prd_product_prices`). 실사/현수막/아크릴은 **면적매트릭스형**(→ 합산형 + `siz_cd` 차원, 신규 코드 불요).

---

## 6. 적재 권위 = 라이브 DB DDL (최신 스펙 260603과 정합)

[정정] 최신 스펙 `table-spec_260603.html`은 라이브 DB와 **완전 정합**한다. 아래 D-1~D-8은 **구버전 260602 또는 raw 엑셀 라벨**을 그대로 쓸 때의 함정이며, 260603/라이브를 기준하면 발생하지 않는다. 적재 시 항상 라이브 DDL 컬럼명을 사용.

### 6.A 컬럼명 함정 (구버전 260602/raw 라벨 → 라이브 권위)

| # | 테이블 | 구버전 260602(stale) | 라이브 DDL = 260603(권위) | 적재 주의 |
|---|--------|-----------------|------------------|-----------|
| D-1 | `t_prc_price_formulas` | `frm_typ` varchar(20), FK 없음 | `frm_typ_cd` varchar(50), **FK→t_cod_base_codes** NOT NULL | **코드값 적재 필요**(FRM_TYPE.01/.02). raw 코드("원자합산형") 직삽 금지, 코드 매핑 필수 |
| D-2 | `t_prc_price_components` | `comp_type_cd` | `comp_typ_cd` varchar(50) | 컬럼명 철자(type→typ). 값은 PRC_COMPONENT_TYPE.01~05 |
| D-3 | `t_prd_product_prices` | `price` | `unit_price` numeric(12,2) | 가격 컬럼명 `unit_price` 사용 |

### 6.B 타입/길이 (260603/라이브 일관 varchar(50))

| # | 테이블.컬럼 | 구버전 260602 | 라이브 = 260603 | 적재 주의 |
|---|-------------|----------|------------|-----------|
| D-4 | `t_prc_component_prices.siz_cd` | varchar(20) | varchar(50) | siz_cd(예 `SIZ_000123`) 적재 안전 |
| D-5 | `t_prc_component_prices.clr_cd` | varchar(20) | varchar(50) | 안전 |
| D-6 | `t_prc_component_prices.mat_cd` | varchar(20) | varchar(50) | 안전 |
| D-7 | `t_prd_product_price_formulas.prd_cd` | varchar(20) | varchar(50) | prd_cd 적재 안전 |
| D-8 | `t_prd_product_prices.prd_cd` | varchar(20) | varchar(50) | 안전 |

### 6.C 누락/추가 객체

| # | 항목 | 스펙HTML | 라이브 DDL | 적재 영향 |
|---|------|----------|------------|-----------|
| D-9 | `t_prd_product_bundle_qtys` 테이블 | 미기재(스펙HTML 가격섹션에 없음) | 라이브 존재(상품별묶음수) | `bdl_qty` 차원 의미·묶음 옵션 원천. 묶음 단가 매핑 시 적재 대상 |
| D-10 | `component_prices` 인덱스 | 미기재 | UNIQUE(자연키 8) + comp_cd/siz/clr/mat/comp_apply 인덱스 | 자연키 중복 = 적재 거부 → CSV 내 8컬럼 조합 사전 중복제거 필수 |
| D-11 | FK ON DELETE 정책 | 미기재 | component_prices/product_prices=CASCADE, 엔진=RESTRICT | 적재엔 무영향, 운영 삭제 시 영향. 문서화만 |

### 6.D 도메인 코드 자리 부재 (스펙·라이브 공통 GAP — round-2 매핑 차단 후보)

| # | 갭 | 내용 | 적재 영향 |
|---|----|------|-----------|
| G-1 | 별색=clr 아님, **공정(process)** | [정정·라이브확증] 별색은 도수(clr_cd)가 아니라 **공정**이다. `t_proc_processes`에 `PROC_000007 별색인쇄`(root) + 자식 5종 `PROC_000008~012 화이트/클리어/핑크/금색/은색` 실재 — 디지털인쇄비 F~O 5열과 정확히 일치. 별색 **선택**=`t_prd_product_processes`(proc_cd), 별색 **단가**=별도 comp_cd(PRC_COMPONENT_TYPE.01 인쇄비, 5종→2 단가프로파일: 화이트=클리어 / 핑크=금=은). clr_cd는 NULL(절대 매핑 금지=FK 위반). 박도 동일: `PROC_000033 박`+17자식(금/은/핑크/홀로그램/금유광…)=박 시트 정합 |
| G-2 | 인쇄 단/양면 전용 축 없음 | component_prices 6차원에 단/양면 직접 축 없음. coat_side_cnt는 **코팅**면수 | **해소됨(상품옵션 레벨)**: `t_prd_product_print_options`(`print_side`, `front_colrcnt_cd`/`back_colrcnt_cd`→t_clr)가 단/양면·앞뒤도수를 상품옵션으로 표현. 단가가 단/양면별로 실제 다르면 별도 comp_cd(단면/양면 인쇄비)로 분리. 단순 옵션이면 차원 불요 |
| G-3 | 면적매트릭스형 FRM_TYPE 없음 | FRM_TYPE 2종(합산형.01/단순형.02)만. "면적매트릭스형" 코드 없음 | 합산형+siz_cd 차원으로 흡수(신규 코드 불요)면 무영향. siz_cd→t_siz_sizes(work/cut 치수 보유)로 면적 표현. 흡수 불가 판정 시 FRM_TYPE.03 신규 제안 |

[참고] 가격 6테이블 밖이지만 가격 모델링에 직결되는 상품옵션/메타 테이블이 위 GAP 후보를 대부분 흡수한다(§ price-engine-ddl 본문 외 — 최신 스펙 260603 확인): **단/양면+앞뒤도수**=`t_prd_product_print_options`, **출력용지규격/판걸이수 맥락**=`t_prd_product_plate_sizes`(국전계열/46계열)+`t_siz_sizes`(work/cut 치수·`impos_yn` 조판), **수량규칙**=`t_prd_products`(min/max/incr/`constraint_json`). 즉 단/양면·판걸이수는 component_prices 차원 문제가 아니라 상품옵션·공식외부 로직.

[HARD] G-1(별색 귀속)·G-3(면적형 코드)은 **모델링 결정**으로 해소하되 **침묵 드롭 금지**. round-2 Step 0 fit-gap에서 유형별 verdict 확정 전 해당 유형 매핑 착수 금지.

---

## 7. 핵심 제약 정리 (적재 게이트)

| 제약 | 내용 | 위반 시 |
|------|------|---------|
| C-1 `apply_ymd` 형식 | `component_prices.apply_ymd`·`product_prices.apply_ymd` = varchar(10) **`'yyyy-MM-dd'`** NOT NULL. `product_price_formulas.apply_bgn_ymd`는 nullable 메모 | round-1 `yyyyMMdd`(8자리) 적재했으면 **변환 필수**. NULL 불가(2 테이블) |
| C-2 자연키 UNIQUE 8 | `component_prices` UNIQUE(`comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd, coat_side_cnt, bdl_qty, min_qty`) | CSV 내 8컬럼 동일조합 2행 → 적재 거부. **사전 중복제거 필수** |
| C-3 `max_qty` 부재 | `component_prices`에 max_qty 없음 = **상향개방**(min_qty 이상 다음 구간까지). 구간 표현은 min_qty 행들의 연속 | max_qty 만들려 하지 말 것. 구간 경계는 정렬된 min_qty로 해석 |
| C-4 `addtn_yn` 의미 | `formula_components.addtn_yn` char(1) CHECK Y/N. **합산 여부 플래그일 뿐 곱셈 연산 아님** | addtn_yn으로 배수/곱 표현 금지. 곱(×출력매수 등)은 공식 단계 의미로 별도 처리 |
| C-5 FRM_TYPE 2종 | `frm_typ_cd` ∈ {FRM_TYPE.01 합산형, FRM_TYPE.02 단순형}. NOT NULL | 그 외 값 적재 = FK 위반. "원자합산형/고정가형/면적형" → 코드 매핑 후 적재 |
| C-6 PRC_COMPONENT_TYPE 5종 | `comp_typ_cd` ∈ {.01 인쇄비, .02 코팅비, .03 용지비, .04 후가공비, .05 박형압비}. nullable | 별색인쇄비는 전용 유형 없음 → .01 귀속 또는 별도 comp_cd 결정 |
| C-7 clr 5종 | `clr_cd` ∈ {CLR_000001 인쇄안함, 000002 1도, 000003 2도, 000004 3도, 000005 CMYK 4도}. 별색 없음 | 별색 clr_cd 적재 = FK 위반(G-1) |
| C-8 use_yn/dflt_yn CHECK | `price_formulas.use_yn`·`price_components.use_yn`·`bundle_qtys.dflt_yn` char(1) CHECK Y/N NOT NULL | 공란/소문자 적재 거부. 기본 'Y' |
| C-9 NULL=NULL 비차원 | nullable 차원 컬럼은 빈 문자열이 아니라 **NULL**로 적재(빈 문자열은 FK 위반). CSV 공란→NULL 변환 규칙 명문화 | '' 적재 시 siz/clr/mat FK 위반 |

---

## 8. round-1(구간할인) 대비 차이

round-1은 `t_dsc_*` 평면 구간행(할인율 %). round-2는 `t_prc_*` **계산 엔진**(구성요소 합산 + 다차원 단가 조회). 구조가 달라 round-1 패턴 재사용 불가. 단 **수량구간 상향개방(max 부재) 패턴은 동일**(round-1 마지막 구간 max_qty=NULL ↔ round-2 min_qty 연속). `apply_ymd` 형식 역시 round-1 적재가 `yyyyMMdd`였다면 round-2는 `'yyyy-MM-dd'`로 변환 정합 필요(C-1).

---

## 부록: 라이브 DDL 컬럼 요약 (적재 권위 — 컬럼명/타입/NULL)

`t_prc_price_formulas`: frm_cd vc50 PK NN · frm_nm vc200 NN · **frm_typ_cd vc50 NN FK** · note vc500 · use_yn ch1 NN · reg_dt/upd_dt
`t_prc_price_components`: comp_cd vc50 PK NN · comp_nm vc200 NN · **comp_typ_cd vc50 FK** · note vc500 · use_yn ch1 NN · reg_dt/upd_dt
`t_prc_formula_components`: frm_cd vc50 PK FK NN · comp_cd vc50 PK FK NN · disp_seq int · addtn_yn ch1 CHECK(Y/N) · reg_dt/upd_dt
`t_prc_component_prices`: comp_price_id bigint PK NN · comp_cd vc50 NN FK · apply_ymd vc10 NN · siz_cd vc50 FK · clr_cd vc50 FK · mat_cd vc50 FK · coat_side_cnt int · bdl_qty int · min_qty int · **unit_price num(12,2)** · note vc500 · reg_dt/upd_dt — UNIQUE(8 자연키)
`t_prd_product_price_formulas`: prd_cd vc50 PK FK NN · frm_cd vc50 PK FK NN · apply_bgn_ymd vc10 · note vc500 · reg_dt/upd_dt
`t_prd_product_prices`: prd_cd vc50 PK FK NN · apply_ymd vc10 PK NN · **unit_price num(12,2)** · note vc500 · reg_dt/upd_dt
`t_prd_product_bundle_qtys`: prd_cd vc50 PK FK NN · bdl_qty int PK NN · bdl_unit_typ_cd vc50 FK · dflt_yn ch1 CHECK(Y/N) NN · disp_seq int · reg_dt/upd_dt

(NN=NOT NULL, vc=varchar, ch=char, num=numeric)
