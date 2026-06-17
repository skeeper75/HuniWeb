# vessel-material-axis (V-3, #1 자재 합성 분해축) — WEAK 🟡 → 그릇 설계

> rpm-vessel-designer. RP `MaterialAxis`(CLR/PTT/WGT/방식 분해축)를 후니 `t_mat_materials`가 표현할 그릇.
> [HARD] 행 오염(색→공정·형상→size 재배치)은 data 교정(round-22 B-3) — 여기는 분해축 *그릇*만.
> 권위 = 라이브 read-only 실측(2026-06-17). design ≠ apply.
>
> **── 버전 ──**
> - **v1.0 (BN):** §0~§6 (자재 분해축 일반 — 소재/두께/색). **보존(아래 원문 그대로).**
> - **v2.0 (GS·2026-06-17):** + §7 **굿즈 완제 본체 분해축 확장**(body_color/capacity/thickness/brand). GS 라이브 재실측이 BN 결론 *확증*(분해축 컬럼 부재·MAT_TYPE.09/.10 오염). 신규 절만 추가, v1.0 무수정.
> - **v8.0 (PD·2026-06-17):** + §11 **직물/PU 원단 물성 차원·밑창 sole sub_mtr 메모**(신규 그릇 0·facet 강화만). PD facet WEAK 2항(직물/PU=#1·밑창 SUB_MTR=#1/#8)이 본 V-3 분해축에 합류. 메모만 추가, §1~§10 무수정.

## 0. 한 줄 평결
**대부분 PASS — 라이브 `t_mat_materials`는 이미 분해축 구조 컬럼을 보유**(`upr_mat_cd` 계층 + `width/height/depth/weight` + `sel_typ_cd`/`max_sel_cnt`/`bdl_qty`). 진짜 결손은 **"이 자재 행이 어느 분해 facet(소재/색/두께)인가"를 분류하는 facet 축 1개**뿐. 사다리 = **코드행(분해 facet enum) + 기존 컬럼 재사용**. 신규 테이블 mint 불요(over-modeling). 단 본체색 같은 facet은 round-6 CPQ option으로 가는 것이 정답일 수 있어 **분해 그릇은 "소재/두께"용으로 최소화** + 본체색은 option 위임.

## 1. search-before-mint (라이브 실측 — 결정적)
RP `MaterialAxis` 요구: 합성 자재를 TYPE(소재)·CLR(색)·PTT(패턴)·WGT(무게/두께)·방식 facet으로 *분리* 표현.

라이브 `t_mat_materials` 컬럼 실측(2026-06-17):
```
mat_cd, mat_nm, mat_typ_cd, upr_mat_cd(계층 부모), sel_typ_cd, max_sel_cnt,
width, height, depth, weight(numeric — 치수/무게 분해축 슬롯 실재!), bdl_qty,
use_yn, note, ...
```
| RP facet | 후니 기존 그릇 | 무손실 가능? |
|---|---|:--:|
| TYPE 소재 | `mat_typ_cd`(MAT_TYPE) + `upr_mat_cd` 계층 | ✅ (부모=소재 그룹·자식=variant) |
| WGT 무게/두께 | `weight numeric`·`depth numeric` 컬럼 실재 | ✅ (전용 슬롯 있음 — 현재 polluted 행은 NULL) |
| 치수(폭/높이) | `width/height numeric` 실재 | ✅ |
| CLR 본체색 | ❌ 전용 슬롯 없음 — **단 round-6 CPQ option(본체색→자재 합성 또는 option_items)이 정답 경로** | △ option 위임 |
| PTT 패턴 | ❌ 전용 슬롯 없음 (드묾) | △ note/option |
| facet *분류*(이 행이 소재인지 색인지) | ❌ — `mat_nm` 평면 문자열만(MAT_000302 "핑크"·MAT_000308 "하트"가 자재 행에 혼재) | ❌ **← 진짜 vessel-gap** |

**라이브 오염 실증(MAT_TYPE.09 파우치):** `MAT_000302 핑크`·`MAT_000298 빨강`(색)·`MAT_000308 하트`·`MAT_000274 사각 57mm`(형상/사이즈)·`MAT_000309 양면인쇄`(인쇄면)·`MAT_000294 2개1팩`(구수)가 전부 자재 행. `width/height/weight`는 전부 NULL → 구조 슬롯은 있으나 안 쓰고 평면 mat_nm에 의미 욱여넣음.

**결론:** 무게/두께/치수 분해축 = **이미 그릇 있음(PASS)**, 단 비어있음(data-gap, dbmap). 진짜 부재 = **각 자재 행의 분해 facet 분류 축**. 그러나 색/형상/사이즈/구수/인쇄면은 round-22 B-3가 *자재 밖으로* 축이동(색→option·형상→siz·구수→bundle·인쇄면→print_side)할 대상 → 이들은 자재 분해 그릇이 아니라 *목적지 그릇*이 받음. 자재에 남는 진짜 분해축 = **소재(PTT) + 두께/무게(WGT)** 뿐.

## 2. 그릇 설계 (최소 — 코드행 + 기존 컬럼)
### 2.1 분해 facet 분류 축 — `t_cod_base_codes` 신규 그룹 `MAT_FACET` (코드행, 사다리 최저단)
```sql
-- 신규 enum 그룹 (테이블 신설 0)
INSERT INTO t_cod_base_codes (cod_cd, cod_nm, upr_cod_cd, disp_seq, use_yn, reg_dt) VALUES
 ('MAT_FACET',    '자재분해축',  NULL,        NULL, 'Y', now()),
 ('MAT_FACET.01', '소재(PTT)',  'MAT_FACET', 1,    'Y', now()),
 ('MAT_FACET.02', '두께/무게(WGT)','MAT_FACET',2,  'Y', now());
-- (색/형상/사이즈/구수/인쇄면은 자재 facet 아님 — B-3가 자재 밖으로 축이동)
```
- 그릇 신설(테이블/컬럼)이 필요한 경우만: 자재 행에 facet 코드를 매다는 `t_mat_materials.mat_facet_cd` 컬럼 1개(NULL 허용·FK→base_codes). **단 search-before-mint상 `upr_mat_cd` 계층(부모=소재·자식=두께 variant)으로 이미 표현 가능하면 컬럼도 불요** → designer 권고: **먼저 upr_mat_cd 계층 재사용 시도, 그래도 부족할 때만 mat_facet_cd 컬럼**.
- 무게/두께 *값*은 기존 `weight`/`depth` 컬럼에 — 신규 0.

### 2.2 본체색(CLR) = 자재 그릇 아님 → round-6 CPQ option 위임 (vessel 신설 0)
- 본체색은 option_group(본체색·sel_typ=택1) + option_items(ref_dim_cd=OPT_REF_DIM.03 자재 합성 또는 자유옵션). `dbmap-material-option-normalization` "본체색=재질행 합성·과분할 금지" 정답 계승. **여기서 그릇 mint 0.**

## 3. 정규화 / 영향
- **무손실:** 소재=mat_typ_cd+upr_mat_cd, 두께/무게=weight/depth(기존 슬롯), facet 분류=MAT_FACET 코드(+선택적 1컬럼). 색/형상 등은 목적지 그릇(option/siz/bundle)이 받음 → 자재는 자재만(함수종속 정합).
- **무중복:** facet 코드는 분류 메타, 값은 기존 컬럼 — 이중저장 없음.
- **영향:** 코드행 2~3개(+선택 컬럼 1개 NULL). 기존 340행 무영향(NULL-add). FK 신규 0~1(mat_facet_cd→base_codes, 채택 시). 백필=dbmap B-3 축이동과 동시(vessel 선행→data 이동).
- **롤백:** 코드행 use_yn='N'(+컬럼 채택 시 DROP COLUMN, 값 NULL이라 손실 0).
- **★ FK load-bearing(HARD):** round-22 B-3 메모리 — 80/82 상품 BOM이 .08/.09/.10 자재행에 의존. 분해 그릇(목적지) **선행** 후 축이동, 자재행 삭제는 use_yn='N' **마지막**(선삭제 시 본체 자재 전손).

## 4. WEAK → 판정
- #1 자재 WEAK → **부분 PASS**: 두께/무게 분해축은 기존 컬럼으로 PASS(채우기=data), facet 분류축만 코드행 신설로 PASS. 색/형상 등은 자재 밖 목적지 그릇으로 이동(B-3) → 자재 vessel은 최소.

## 5. DDL 참조
- 코드행(MAT_FACET) = `dbm-ddl-proposer` 코드그룹 패턴(사다리1). 선택적 `mat_facet_cd` 컬럼 = ddl-proposer 위임. `goods-pouch-nondim-size` 제안과 분리(그건 비치수 size 목적지 그릇).

## 6. open decision
1. **upr_mat_cd 계층 vs mat_facet_cd 컬럼:** 먼저 계층 재사용 입증 → 부족 시만 컬럼. (search-before-mint 잔여 — round-22 자재 실측 데이터로 후니 판정)
2. **본체색 목적지:** 자재 합성(.03) vs 자유옵션그릇 — `dbm-ddl-proposer P0-1` open decision과 동일(잉크색 선례). round-6 CPQ 트랙.
3. 색/형상/사이즈/구수/인쇄면 축이동(B-3 data)은 dbmap — vessel 선행이 전제.
4. 실 적용 = 인간 승인.

---

## ═══ §7. 굿즈 완제 본체 분해축 확장 (V-3 GS·v2.0) ═══

> 사용자 directive 최우선. "굿즈 본체자재 확인" 핵심 질의의 vessel 측 직답.
> RP는 완제 본체에서도 소재/색/용량/두께/브랜드를 라벨에 융합(`PCS_DTL_NME`="미르 와이드마우스 보틀 화이트 20oz"). 메타모델 정답 = `{body_material, body_color, capacity, thickness, brand}` 분해축(dictionary §1 G-1·명제 #11).

### 7.0 한 줄 평결
**§1~§6 결론을 GS가 확증** — body_material(소재)·thickness/weight는 기존 그릇 PASS, **body_color·capacity·brand 분해축만 vessel-gap**. 단 색(body_color)은 §2.2대로 **CPQ option으로 위임**이 정답이고, 용량(capacity)·브랜드(brand)는 완제 SKU 식별 속성이라 **`weight` 같은 전용 수치/문자 슬롯이 없음**. 사다리 = **MAT_FACET 코드에 .03 용량 추가 + capacity 수치는 기존 `weight`/`bdl_qty` 재사용 검증 → 부족분만 컬럼**. 신규 테이블 mint 불요.

### 7.1 search-before-mint (GS 라이브 재실측 2026-06-17 — 결정적)
`t_mat_materials`에 jsonb 컬럼 **0건**(실측: jsonb 컬럼 query 빈 결과) → 색/용량 facet을 materials.tags-jsonb로 담을 수 없음. 수치 슬롯은 `width/height/depth/weight numeric` + `bdl_qty integer`만.

| RP 완제 본체 facet | 후니 기존 그릇 | 무손실 가능? |
|---|---|:--:|
| body_material 소재 | `mat_typ_cd`(.05 특수/.06 가죽 등) + `upr_mat_cd` | ✅ (정상 버킷 실재 — MAT_000008 레더 등) |
| thickness 두께 | `depth numeric` 슬롯 | ✅ (4T 등 — 현재 NULL=data) |
| weight 무게 | `weight numeric` 슬롯 | ✅ |
| **capacity 용량**(20oz·500ml) | △ — 전용 슬롯 부재. `weight`(무게≠용량 의미 오염 위험)·`bdl_qty`(구수≠용량) 부적합 | ❌ **← 진짜 vessel-gap(굿즈)** |
| **body_color 본체색**(화이트/블랙) | ❌ 전용 슬롯 부재 — **단 §2.2 CPQ option이 정답 경로** | △ option 위임 |
| **brand 브랜드**(미르 등 OEM) | ❌ 전용 슬롯 부재. `mat_nm`/`note`에 융합 | △ (드묾·note 흡수 가능) |

**라이브 오염 실증(MAT_TYPE.09, GS 재측):** `MAT_000263 원형 90mm`·`MAT_000274 사각 57mm`(형상/사이즈)·`MAT_000271 단면`·`MAT_000272 양면`(인쇄면)·`MAT_000277 2구`(구수)가 전부 자재 행, `width/height/weight` 전부 NULL. → 구조 슬롯 있으나 미사용·평면 mat_nm에 의미 융합 = §1 BN 결론과 동일 진원.

### 7.2 그릇 설계 (최소 — §2 facet 코드 1행 추가 + 용량 슬롯 판정)
```sql
-- §2.1 MAT_FACET 그룹에 용량 facet 1행 추가 (사다리 최저단·테이블 0)
INSERT INTO t_cod_base_codes (cod_cd, cod_nm, upr_cod_cd, disp_seq, use_yn, reg_dt) VALUES
 ('MAT_FACET.03', '용량(capacity)', 'MAT_FACET', 3, 'Y', now());
-- (body_color=CPQ option 위임[§2.2]·brand=note 흡수·thickness/weight=기존 컬럼 → facet 코드 불요)
```
- **용량 *값* 슬롯:** open decision — (a) 기존 `weight numeric` 재해석(단 무게와 의미 충돌 위험·HARD 권장 안 함) (b) `capacity numeric` + `capacity_unit_cd` 컬럼 신설(전용·명확). search-before-mint 결과 무게≠용량이라 (b)가 무손실이나, **굿즈 용량 보유 상품 수가 적으면**(텀블러/보틀류 한정) 코드+`note` 흡수로도 가능 → designer 권고: **B-3 축이동 시 굿즈 용량 보유 상품 수 실측 후 (b) 컬럼 채택 여부 판정**. 과잉모델 경계.
- **body_color:** §2.2 그대로 — option_group(본체색·택1) + option_items. 자재 그릇 mint 0. `dbmap-material-option-normalization` "본체색=재질행 합성·과분할 금지" 계승.
- **brand:** RP OEM 브랜드는 후니 굿즈에서 드묾(상품명 흡수) → 별 슬롯 mint 보류, `note` 흡수. 후니가 브랜드 분기 가격/옵션 필요해질 때 facet 코드 추가(YAGNI).

### 7.3 정규화 / 영향 (§3 동일 패턴)
- **무손실:** 소재=mat_typ_cd·두께=depth·무게=weight·용량=MAT_FACET.03(+선택 capacity 컬럼)·색=option·브랜드=note. 각 facet 분리 함수종속.
- **무중복:** 용량≠무게(weight 재사용 시 의미 이중화 위험 → 전용 컬럼 권장 근거).
- **영향:** 코드행 1개(+조건부 capacity 컬럼 1~2개 NULL). 기존 340행 무영향. FK 0~1. 백필=B-3·GPM-4 축이동/소재행 mint와 동시.
- **롤백:** 코드행 use_yn='N'(+컬럼 채택 시 DROP, 값 NULL이라 손실 0).
- **★ FK load-bearing(HARD):** §3.5 동일 — 파우치 103상품 BOM이 .08/.09/.10 의존. 분해/목적지 그릇 **선행** 후 축이동, 자재행 use_yn='N'은 **마지막**.

### 7.4 WEAK → 판정
- 굿즈 본체 분해축: **body_material/두께/무게=PASS(기존 컬럼)** · **body_color=CPQ option 위임(vessel mint 0)** · **capacity=MAT_FACET.03 코드행(+조건부 컬럼)으로 PASS** · **brand=note 흡수(YAGNI)**. → 순 신규 그릇 = **코드행 1 + 조건부 capacity 컬럼**. 사용자 질의 직답: 본체자재 *연결*은 있음(PASS), *분해축*은 색=option·용량=코드행/컬럼으로 닫음.

### 7.5 DDL 참조 / open decision (GS)
- 코드행 = `dbm-ddl-proposer` 코드그룹 패턴. capacity 컬럼 = ddl-proposer 위임(채택 시).
- **open decision (GS):** ① capacity 값 슬롯 = weight 재해석 금지 → 전용 `capacity numeric`+단위 코드 vs note 흡수(굿즈 용량상품 수 실측 후) ② brand 슬롯 신설 보류(YAGNI·note) ③ body_color 목적지=§2 open decision과 동일(자재 합성 .03 vs 자유옵션). ④ 실 적용=인간 승인.

---

## ═══ §8. ST 점착/내후 차원 메모 (V-3 ST·v5.0·신규 그릇 0) ═══
- **ST S-4(점착/내후 소재)가 V-3(#1) 합성 분해축에 합류**(`vessel-shape-axis.md §5`·`gap-matrix XIII-2`). 강접/리무버블/옥외/저온/자석/메탈/한지 = §2.1 MAT_FACET·§7.2 동형의 *추가 합성 차원*(adhesion_grade 점착강도·weather_grade 내후등급) — 색상/두께→material 분해와 같은 패턴. **신규 V 아님**: MAT_FACET 그룹에 `.04 점착강도`·`.05 내후등급` 코드행 추가로 흡수(facet 분류축)·값은 기존 컬럼/note 또는 굿즈 용량 동형 판정(과잉모델 경계·점착 상품 수 실측 후).
- **★ST 자재는 클린 버킷:** ST 점착 소재는 `.11 스티커용지`(클린)이지 파우치 `.09`/악세사리 `.10` 오염 버킷 아님 — V-3 §1 오염 실증(MAT_TYPE.09)과 달리 ST 자재행은 정상 등록 가능. 점착/내후 차원은 *오염 교정(B-3)이 아니라 facet 추가*(data-gap 아님·분해축 코드만).
- search-before-mint: 점착강도/내후등급 전용 컬럼 라이브 부재(§7.1 jsonb 0건 동일) → MAT_FACET 코드행이 분류·값은 컬럼/note. **신규 테이블 0·V-3 흡수.**

---

## ═══ §9. CL 의류 본체 분해축 + size×color 2D 메모 (V-3 CL·v6.0·신규 그릇 0) ═══
- **CL C-2/C-3(의류 size×color 2D matrix)가 V-3(#1) 분해축에 합류**(`reverse.md §0.4·§285`·`gap-matrix XV`·`vessel-needs.md CL 흡수 매핑`). 의류 본체 = `{원단(fabric/PTT)×색(CLR)×사이즈}` 분해 = §1 합성 분해축의 *2D 일반화*(GS 1D variant·§7 완제 본체 분해축의 의류판). **신규 V 아님 — V-3 설계 시 의류 본체(원단×색×사이즈) 분해/버킷 함께 고려.**
- **★2D 셀 *구조*는 그릇이 견딤(vessel 조치 0):** size×color 매트릭스 셀은 라이브 `t_prd_product_option_items.ref_key1/ref_key2` 2D 페어링이 **활성**(255/469행에 ref_key2 비NULL 실측) → 한 셀=(size,color) 쌍을 `ref_key1`=size·`ref_key2`=color로 무손실 인코딩·`use_yn`=셀 가용성(품절). GS SKU 1D·ST disable 정점과 동형 그릇이 의류 2D variant까지 *구조적으로 수용* — **2D matrix 전용 테이블 mint 불요**(후니 옵션 그릇이 1D→2D 일반화를 견딘다는 vessel-side 검증). 이것이 의류 variant #18 부결의 그릇 측 근거: 새 그릇 없이 기존 옵션 레이어가 담음.
- **단 두 facet은 V-3 분해축에 귀속(신규 V 0):** ① **색상(body_color)이 OPT_REF_DIM 7종에 별 ref 타입 없음** → §2.2대로 자재 CLR 라우팅(본체색=재질행 합성 또는 option_items) — §1 색=option 위임 정답 계승 ② **의류 원단(SXSRT/SXZSB) MAT_TYPE 버킷 부재**(라이브 `.09`/`.10`은 파우치/악세사리 상품군명 버킷이지 의류 원단 버킷 아님) → V-3 §6 open decision "버킷 재정의"에 의류 원단 계열(자체 SXSRT/브랜드 SXZSB·평량 oz) 추가 검토. 단 CL은 자체/브랜드/단체 3분기 = *원단 라이브러리/모집단* 차이(옵션 모델 동일·clothes2025 단일) → 버킷이 아니라 자재 *행* 분리(자체 원단 vs 브랜드 원단 mat_cd)로도 환원 가능 → designer 실측 후 판정(과잉 버킷 mint 경계).
- search-before-mint: 의류 size×color 2D 셀=ref_key1/ref_key2 기존 그릇 PASS·색=option 위임·원단=mat 행/버킷(기존 또는 코드행). **신규 테이블 0·V-3 흡수.** ★주의: 의류 평량(oz)·형태(반팔/긴팔/후드)는 §7 thickness/weight 동형 + 자재 행 분리 — 분해축 grain은 자재 행/MAT_FACET이지 새 그릇 아님.

---

## ═══ §10. AC 자재 분해축 3차원 확장 메모 (V-3 AC·v7.0·신규 그릇 0) ═══
> AC 갭 분석(`categories/AC/reverse.md`·`02_metamodel/_resolved-fragments.md` A-1~A-9·`gap-matrix §XVII`·`vessel-needs.md AC 흡수 매핑`). 후니 대조 = `_workspace/huni-dbmap/31_acrylic-price-link/`. **AC distinct 신축 0(가공방식 그룹핑 #18 부결·17축 재포화) — AC facet 6항 중 WEAK 3항(두께·surface-finish·부자재 횡단공유)이 본 V-3(#1) 분해축에 합류·신규 V-번호 0.** AC가 V-3를 **3차원으로 확장**(별 그릇 mint 0·전부 facet 강화):

### 10.1 차원 ① 두께 measure_type 구분 (WGT 슬롯 다의)
- **AC #1(3T/5T 두께)가 §7 thickness/weight 동형에 합류**: 아크릴 두께(3mm/5mm)는 종이 평량(g/㎡)·텀블러 용량(oz)과 **같은 WGT(무게/두께) 분해 슬롯을 다의(多義)로 사용** — 평량 g vs 두께 mm vs 용량 ml/oz가 한 슬롯에 혼재. 라이브 실측: `t_mat_materials.weight`/`depth` 컬럼은 아크릴 행에서 **NULL**·두께는 `mat_nm` 텍스트 융합("아크릴 투명 3mm").
- **그릇 조치:** §2.1 `MAT_FACET.02 두께/무게(WGT)` 코드가 *분류*는 이미 담음 → AC가 더하는 것은 **measure_type 구분 차원**(평량/두께/용량 중 무엇인지 측정유형 라벨). 사다리 = `MAT_FACET.02`를 measure_type별로 세분(`.02 평량`·신규 `.06 두께`·GS `.03 용량` 이미 존재) 또는 facet 코드에 measure_unit 속성 부착. **신규 테이블 0.** ★dbmap CLEAR3T(투명 1.5T=3T×0.8을 mat_cd 통합) 동형 확증 — 두께는 자재 mat_cd 차원으로 무손실(`31_acrylic-price-link/acrylic-chain-design`).
- search-before-mint: 두께 전용 컬럼은 `depth`(NULL·재활용 가능)·`weight`(NULL) 존재하나 measure_type을 구별하는 슬롯 부재 → MAT_FACET 코드의 measure_type 세분으로 닫음(값은 depth/weight 재해석 또는 note). 과잉모델 경계 — measure_type은 facet 분류이지 새 수치 컬럼 아님.

### 10.2 차원 ② surface_finish 합성 차원 (ST S-4와 통합)
- **AC #2(소재 surface-finish: 글리터/거울/자개/홀로그램)가 §8 ST 점착/내후 차원과 *동근***(`vessel-shape-axis.md §5`·gap-matrix XIII-2). 라이브 실측: `surface`/`finish`/`glitter`/`mirror`/`holo` 컬럼 **전역 0건**·`mat_nm` 텍스트 융합("아크릴 글리터") → §8 adhesion_grade/weather_grade와 같은 *추가 합성 차원* = **`surface_finish`**.
- **그릇 조치:** §8 ST 점착/내후를 MAT_FACET `.04 점착강도`·`.05 내후등급` 코드행으로 흡수한 패턴과 **통합** — `MAT_FACET`에 `surface_finish`(표면마감) facet 코드 추가(글리터/거울/자개/홀로/무광/유광). **AC surface_finish ≡ ST adhesion/weather = 동일 합성-차원 패턴**(별 그릇 아님·한 MAT_FACET 그룹이 점착·내후·표면마감을 다 담음). 거울 별 가격공식(`PRF_MIRROR_ACRYL`)은 §C/V-7 라우팅(가격 트랙·여기 아님). **신규 테이블 0·V-3 흡수.**
- search-before-mint: surface/finish 전용 컬럼 전역 0건(§7.1 jsonb 0건·§8 동일) → MAT_FACET 코드행이 분류·값은 컬럼/note. 색상/두께/점착/내후/표면마감이 *한 합성-분해축의 차원들*임이 BN→GS→ST→AC 4카테고리 누적으로 확증.

### 10.3 차원 ③ 단일 부자재 마스터 (버킷 재정의·data 강결합·신중)
- **AC #4(부자재 횡단 공유: 고리 KR/CN/CR·받침 AB)가 V-3 §6 "MAT_TYPE 버킷 재정의"에 합류** — ★라이브 실측 핵심: 고리/받침/자석/와이어링이 **`MAT_TYPE.04`(링)/`.07`(핀·자석·고리)/`.10`(와이어링)/`.02`(D링) 4버킷 분산**·**D링이 `.02`/`.04`/`.07` 3중복.** RP는 KR/CN/CR 코드를 ST/GS/AC 횡단 **단일 부자재 카탈로그**로 공유 → 후니는 단일화 미달(같은 D링이 3행·횡단 재사용 불가).
- **★vessel-gap이 아니라 버킷 정합(주로 data·일부 vessel):** 부자재 *행* 자체는 `t_mat_materials`에 존재(그릇 PASS)·문제는 **버킷 배치(mat_typ_cd 오라벨)와 횡단 중복** → 주로 **data 교정**(round-22 ④자재 B-3 축이동·`vessel-mat-type-relabel.md`와 동일 결의 분류축 결함)·vessel 측은 **V-3 §6 버킷 재정의 검토**(부자재 횡단 단일 카탈로그가 MAT_TYPE 버킷 재배치만으로 닫히는지). **신규 테이블 0.**
- **★[HARD] round-22 ④자재 B-3과 조율 필요 (우선순위 중·신중):** 단일 부자재 마스터는 ① vessel 측(고리/받침/자석을 한 버킷으로 재정의·MAT_TYPE 분류축 교정)과 ② data 측(D링 3중복 행 통합·`use_yn='N'` 선이동) **양면** — `vessel-needs.md AC 흡수 매핑 ④`·`dbmap-axis-staged-load-round22` B-3과 **조율**해야 안전. **행 영향 큼**(80/82 상품 BOM이 부자재 link 의존 → 통합 시 본체-부자재 link 재배선 필요) → vessel 선행(버킷 정의) → data 이동(round-22 B-3) 순서 [HARD]. designer 단독 mint 금지·dbmap B-3 강결합으로 노트(`vessel-mat-type-relabel.md §open decision` 동형). **신규 V 아님·신규 테이블 0.**

### 10.4 종합 (AC V-3 3차원)
- AC가 V-3에 더한 것 = **3 facet 차원(measure_type·surface_finish·단일 부자재 마스터)**, 전부 `MAT_FACET` 코드행·버킷 재정의로 흡수 = **신규 테이블/컬럼/V-번호 0.** ① 두께 measure_type = MAT_FACET measure_type 세분(`.06 두께` 등) ② surface_finish = MAT_FACET 표면마감 코드(★ST adhesion/weather와 통합·동근) ③ 단일 부자재 마스터 = V-3 §6 버킷 재정의 *검토*(우선순위 중·★round-22 B-3 조율·행 영향 큼·designer 단독 mint 금지). search-before-mint: 두께/surface/부자재 전용 컬럼 전부 라이브 부재(NULL·텍스트 융합·버킷 분산) → MAT_FACET 코드행·버킷 재정의가 분류·값은 기존 컬럼/note/data 교정. **신규 그릇 0·V-3 흡수.**
- ★dbmap 31_acrylic 라이브 산출과 **구조 동형 확증**(CLEAR3T가 3T/1.5T를 mat_cd로 통합·MIRROR3T 별 comp·화이트=`PROC_000008` 공정). Q-ACR-7(prc_typ `.02` 엔진계산 미확정)·미러 GAP은 **가격 트랙 범위 외**(vessel 아님·`vessel-quantity-size-pricing §C5`).

---

## ═══ §11. PD 직물/PU 원단 물성 + 밑창 sole sub_mtr 메모 (V-3 PD·v8.0·신규 그릇 0) ═══
> PD 갭(`categories/PD/reverse.md`·`02_metamodel/_resolved-fragments.md` PD-1~PD-6·`gap-matrix §XIX`·`vessel-needs.md PD 흡수 매핑 ②⑤`). 후니 대조 = 라이브 `t_mat_materials` 실측(2026-06-17). **PD distinct 신축 0(완제 구조물 내재BOM #18 부결·17축 재포화·8번째 카테고리). PD facet 5항 중 WEAK 2(직물/PU=#1·밑창 SUB_MTR=#1/#8)가 본 V-3(#1) 분해축에 합류·신규 V-번호 0.** PD가 V-3에 더한 것 = **직물 물성 차원 + 밑창 sub_mtr variant**, 둘 다 §2.1 MAT_FACET·기존 그릇으로 흡수(별 테이블/컬럼 0).

### 11.1 차원 ① 직물/PU 원단 물성 차원 (§7 thickness·§8 점착·§10 measure_type과 동근)
- **PD #2(직물/PU 원단: 면10수·슬리퍼원단·PU폴리우레탄)가 §7 thickness/weight·§8 ST 점착/내후·§10 AC measure_type/surface_finish와 *동근***: 직물 *물성 차원*(번수[면10수=10수]·신축성[슬리퍼원단 elasticity]·원단 종류[PU/PVC]) = §1 합성 분해축의 *추가 차원*. 라이브 실측: 린넨(`.05`)/타이벡(`.05`)/메쉬(`.08`) 자재행은 실재(*링크* PASS)·★직물 물성 차원 분해 컬럼 부재(`mat_nm` 텍스트 융합 "면 10수").
- **그릇 조치:** §2.1 `MAT_FACET`에 직물 물성 facet 코드 추가(번수[yarn count]·신축성·원단종류) — §8 점착강도(`.04`)·내후등급(`.05`)·§10 표면마감과 같은 *합성-차원 패턴*(한 MAT_FACET 그룹이 점착·내후·표면마감·직물물성을 다 담음). **PD 직물물성 ≡ ST adhesion/weather ≡ AC surface_finish = 동일 합성-차원 패턴**(별 그릇 아님). 값은 기존 컬럼/note(번수 수치는 `weight` 재해석 금지 — §10.1 measure_type 다의 회피·전용 코드/note). **신규 테이블 0·V-3 흡수.**
- search-before-mint: 직물 번수/신축성/원단종류 전용 컬럼 라이브 부재(§7.1 jsonb 0건·§8·§10 동일) → MAT_FACET 코드행이 분류·값은 컬럼/note. **★미적재 본체소재 행(면10수/슬리퍼/PU)=data-gap**(`_data-gaps-noted §9`·round-22 ④자재·GPM-4) — 분해축 그릇(여기) 선행 후 행 적재(dbmap).

### 11.2 차원 ② 밑창색×사이즈 SUB_MTR variant (★별색 아님 정정·CL §9 2D 동형)
- **PD #5(밑창색×사이즈) = §9 CL size×color 2D 동형 + ★별색≠부자재 variant 경계 정정:** ★D-PD-1 정정 — 밑창색(검정/흰색)은 `six_clr`(별색·공정#2) **아니라** SUB_MTR 부자재 variant(`SLB01~06` 검정·`SLW01~06` 흰색 밑창색×사이즈 12-variant·`MTRL_COD SBSLP/SWSLP230~280`). 별색 인쇄(잉크)와 부자재(밑창 부품) variant는 **다른 축** — 슬리퍼 밑창은 결합 부품이지 인쇄 도수가 아님.
- **그릇 조치(★둘 다 기존 그릇 PASS):**
  - 밑창 = 완제 부자재(addon→tmpl_cd·#8 부속물) *또는* 본체 결합 부품(자재 sub_mtrl·`usage_cd .07` 639행 슬롯) — **둘 다 그릇 보유**(`vessel-form-assembly §7`·`_data-gaps-noted §9`와 정합).
  - 밑창색×사이즈 12-variant = `t_prd_product_option_items.ref_key1/ref_key2` 2D 페어링(§9 CL size×color 동형·라이브 255/469 활성) — `ref_key1`=사이즈·`ref_key2`=밑창색 무손실 인코딩·`use_yn`=variant 가용성. **2D matrix 전용 테이블 mint 불요**(§9와 동일 구조적 수용).
- search-before-mint: 밑창 sub_mtrl·2D 페어링 전부 기존 그릇 PASS(§9 CL·`vessel-form-assembly §7` usage_cd .07). **★밑창 sole 자재코드(SLB*/SLW*) 미적재=data-gap**(`_data-gaps-noted §9`)·★부속물#8 vs 자재 sub_mtrl 최종 귀속은 reverse SUB_MTR 정정본 검증 후(open decision·둘 다 그릇 실재라 vessel-gap 아님). **신규 테이블/컬럼 0·V-3 흡수.**

### 11.3 종합 (PD V-3)
- PD가 V-3에 더한 것 = **2 차원(직물 물성·밑창 sub_mtr variant)**, 전부 `MAT_FACET` 코드행(직물물성·§8/§10 합성차원 통합)·기존 sub_mtrl/2D 페어링 그릇으로 흡수 = **신규 테이블/컬럼/V-번호 0.** ① 직물물성 = MAT_FACET 합성차원(★ST 점착/AC surface_finish와 동근·BN→GS→ST→AC→PD 5카테고리 누적이 *합성-분해축은 차원을 계속 더해도 facet 코드행으로 닫힌다* 확증) ② 밑창 sub_mtr = 기존 usage_cd .07/addon + ref_key1/ref_key2 2D(§9 CL 동형·별색 아님 정정). search-before-mint: 직물물성/밑창 전용 컬럼 부재·기존 sub_mtrl/2D 페어링 PASS → MAT_FACET 코드·기존 그릇이 흡수·미적재 행=data(dbmap). **신규 그릇 0·V-3 흡수.**
- ★`_data-gaps-noted §9` 정합: PD-4 완제 구조물 내재BOM(다리/받침/논슬립=부속물#8·솜/지퍼=자재 usage .07)·밑창 sole 자재코드·직물 본체소재 행은 **data-gap not vessel-gap**(그릇 실재·미적재만·dbmap). 본 §11은 *분해축 그릇*(직물물성 facet·밑창 variant 인코딩 구조)만 — 행 적재는 dbmap.

---

## ═══ §12. PH 인화지×마감 surface-finish 메모 (V-3 PH·v9.0·신규 그릇 0) ═══
> PH 갭(`categories/PH/reverse.md` §0.5·`02_metamodel/_resolved-fragments.md` PH-3·`gap-matrix §XXI`·`vessel-needs.md PH 흡수 매핑 ③`). 후니 대조 = 라이브 `t_mat_materials` 실측(2026-06-17). **PH distinct 신축 0(완제 액자 그릇/마운팅 #18 부결·17축 재포화·9번째 카테고리·★directive 최대 관전). PH facet 6항 중 WEAK 1(인화지×마감 surface-finish=#1)이 본 V-3(#1) 분해축에 합류·신규 V-번호 0.** PH가 V-3에 더한 것 = **인화지×마감 surface_finish 차원**, §10.2 AC surface_finish·§8 ST 점착/내후와 *동근*으로 흡수(별 테이블/컬럼 0).

### 12.1 차원: 인화지×마감 surface-finish (§8 ST 점착·§10 AC surface_finish와 동근)
- **PH #3(인화지×마감 경계: 유광/반광/스노우/홀로그램 마감 × 캐논전용지/스노우지 인화매체)가 §10.2 AC surface_finish·§8 ST adhesion/weather와 *동근***: §0.5 client-render 재캡처 실측 — "인화용지(반광-러스터)/인화용지(유광)"가 **한 combobox에 마감×매체 합성**(BN 코팅·AC 글리터/거울 동형·마감=인화지 매체 종속). 라이브 실측: `surface`/`finish`/`glitter` 컬럼 **전역 0건**·마감이 `mat_nm` 텍스트 융합("유광(Glossy)_캐논전용지").
- **그릇 조치:** §2.1 `MAT_FACET` `surface_finish`(표면마감) 코드행으로 흡수 — §10.2 AC(글리터/거울/자개/홀로) + §8 ST(점착강도/내후등급)와 **동일 합성-차원 패턴**(한 MAT_FACET 그룹이 점착·내후·표면마감·인화마감을 다 담음). **PH 인화마감 ≡ AC surface_finish ≡ ST adhesion/weather = 동일 합성-차원 패턴**(별 그릇 아님). **신규 테이블/컬럼 0·V-3 흡수.**
- search-before-mint: 인화 마감/매체 전용 컬럼 라이브 부재(§10 AC 동일·전역 0건·텍스트 융합) → MAT_FACET 코드행이 분류·값은 기존 컬럼/note. **★인화지 매체행(캐논전용지/스노우/홀로그램)·인화 마감 행=data-gap**(`_data-gaps-noted §10`·round-22 ④자재) — 분해축 그릇(여기) 선행 후 행 적재(dbmap).

### 12.2 종합 (PH V-3)
- PH가 V-3에 더한 것 = **1 차원(인화지×마감 surface_finish)**, `MAT_FACET` 코드행으로 흡수 = **신규 테이블/컬럼/V-번호 0.** ★**BN→GS→ST→AC→PD→PH 6카테고리째 V-3 합성-분해축에 차원을 더했으나 여전히 facet 코드행으로 닫힘**(테이블 mint로 번지지 않음·합성-분해축 사다리 정직성 6연속 확증). search-before-mint: 인화 마감/매체 전용 컬럼 부재 → MAT_FACET 코드·기존 컬럼/note·미적재 행=data(dbmap). **신규 그릇 0·V-3 흡수.**
- ★`_data-gaps-noted §10` 정합: PH 인화지 매체행·인화 마감 행은 **data-gap not vessel-gap**(자재 그릇 실재·미적재만·dbmap). 본 §12는 *분해축 그릇*(surface_finish facet)만 — 행 적재는 dbmap. ★**deepcheck 주의: codex M-6 "photo paper weight/surface(gsm·RC·은염)"·M-4 glazing은 §0.5 미캡처·전부 `unverified` → 별 슬롯으로 OBSERVED되기 전 surface_finish 외 추가 facet mint 금지(라이브 실측 대상·`_vessel-roadmap.md` carry-forward).**
