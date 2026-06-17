# vessel-material-axis (V-3, #1 자재 합성 분해축) — WEAK 🟡 → 그릇 설계

> rpm-vessel-designer. RP `MaterialAxis`(CLR/PTT/WGT/방식 분해축)를 후니 `t_mat_materials`가 표현할 그릇.
> [HARD] 행 오염(색→공정·형상→size 재배치)은 data 교정(round-22 B-3) — 여기는 분해축 *그릇*만.
> 권위 = 라이브 read-only 실측(2026-06-17). design ≠ apply.
>
> **── 버전 ──**
> - **v1.0 (BN):** §0~§6 (자재 분해축 일반 — 소재/두께/색). **보존(아래 원문 그대로).**
> - **v2.0 (GS·2026-06-17):** + §7 **굿즈 완제 본체 분해축 확장**(body_color/capacity/thickness/brand). GS 라이브 재실측이 BN 결론 *확증*(분해축 컬럼 부재·MAT_TYPE.09/.10 오염). 신규 절만 추가, v1.0 무수정.

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
