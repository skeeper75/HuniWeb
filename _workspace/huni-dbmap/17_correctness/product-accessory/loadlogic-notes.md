# 상품악세사리 — 적재 로직 재구성 (round-13 C1)

> **작성** 2026-06-11 · round-13(라이브 정합 교정). 설명 한국어, 식별자/컬럼/코드/SQL 영어.
>
> **목적:** `raw/webadmin`이 상품악세사리 15 부자재를 라이브 t_*에 어떻게 채웠는지 재구성하고, 그 규칙이 만든 결함을 file:line으로 짚는다. 라이브=교정 대상(피고), oracle=정답.
>
> **프레임[HARD]:** round-12는 라이브를 권위로 봤다. round-13은 역전 — 라이브가 oracle(엑셀 L1·적재 SQL·적재 로직·도메인 확정)과 충돌하면 **라이브가 틀린 것**.

---

## 0. 적재 파이프라인 전모 + 상품악세사리 특이점

| 단계 | 스크립트 | 입력 시트 | 상품악세사리 영향 |
|------|----------|-----------|-------------------|
| seed | `sql/05_seed.sql` | — | PRD_TYPE.03 기성·.05 추가·QTY_UNIT.01 EA/.02 매/.04 세트/.05 팩·MAT_TYPE.10 정의 |
| 마스터+관계 | `tools/load_master.py --all` | `prdmaster_full_migration_v03_20260518.xlsx`(line 39) | 정규화 시트(10/12/13/14/15…) 적재. **부자재 결함의 출처** |
| 중복삭제 | `sql/09_delete_dup_products.sql` | — | 중복명 7건 삭제(PRD_000099/113~117/167/182). **281/282/283 삭제 안 함**(이중등록 의도 보존) |
| Phase7 | `tools/migrate_phase7.py --all` | 라이브 | addon→`TMPL-`+addon_prd_cd 전환(봉투 template 자동 생성·하이픈) |

> **[HARD] 적재원은 정규화 시트지 "상품악세사리(가격포함)" L1 시트가 아니다.** load_master가 읽는 것은 `10_상품정보`·`12_상품별묶음수`·`13_상품별사이즈`·`14_상품별자재` 등 **이미 정규화된 마스터 시트**다(read_sheet 호출). 즉 "사이즈 3축 복합 분해"(치수/묶음수/색상)는 load_master **이전 단계**(엑셀 작성자가 L1 시트를 수동으로 정규화 시트로 분해)에서 일어났다. load_master는 그 정규화 결과를 충실히 옮길 뿐 — **3축 분해 결함은 정규화 시트 작성 단계의 산물**이고, load_master는 분해 로직 자체를 안 가진다.

> **[HARD] 적재원 엑셀 v03(5/18) ≠ oracle 260610(6/10)**(load_master.py:39). 라이브에 v03 파일 부재(`raw/webadmin/data/` gitignore) → 적재원 1차 검증 불가. v03↔260610 차이로 설명 안 되는 라이브 값은 "적재 경로 불명".

---

## 1. load_master.py 부자재 컬럼 변환 규칙 재구성

### 1-1. 상품 (`t_prd_products`, load_products line 250-275)

| 컬럼 | 적재 규칙 | line | 결함/주의 |
|------|-----------|------|-----------|
| prd_cd | PRD_NNNNNN identity 보존 | 252 | 정상(PRD_000001~015) |
| `"MES_ITEM_CD"` | **무조건 None 적재** | 261 | **🔴 라이브는 7/15 채워짐(012-0004 등)·8/15 NULL — load_master 산물 아님(적재 경로 불명, §2 L-PA-A)** |
| prd_nm | 그대로 | 262 | 멱등 키. 우드 3종 별 prd_nm |
| prd_typ_cd | bcd_label→enum_code(PRD_TYPE) | 263 | 라이브 PRD_000001~015=PRD_TYPE.03 기성·281~283=PRD_TYPE.05 추가 |
| min/max/incr_qty | 정수 | 268 | 라이브 1/100/1(L1과 일치) |
| qty_unit_typ_cd | **무조건 None 적재** | 269 | **🔴 라이브는 QTY_UNIT.01/02/04/05 채워짐 — load_master 산물 아님(적재 경로 불명, §2 L-PA-A)** |

### 1-2. 카테고리 (`t_cat_categories`+`t_prd_product_categories`, load_categories 164-178 / load_rel_categories 282-291)

- 마스터: `01_카테고리` 시트의 (카테고리코드, 카테고리명, 카테고리레벨)을 적재하되 **upr_cat_cd는 일단 NULL**(line 171), 이후 `상위카테고리코드`가 **있는 행만** UPDATE(line 175-176). → **상위코드 빈 행은 영구 NULL 고아**.
- 관계: `11_상품별카테고리`의 (상품코드, 카테고리코드)를 그대로 연결(line 288).
- **🔴 핵심:** 잉여 고아 노드 CAT_000293 "상품악세사리"(upr=NULL·lvl3)는 `01_카테고리` 시트가 `구분` 라벨에서 파생한 편의 그룹을 상위코드 없이 정의해서 생긴 것. `11_상품별카테고리`가 15 부자재를 그 고아 노드에 연결. load_master는 시트 그대로 충실 적재 → 잉여 고아 + 오연결(§2 L-PA-B).

### 1-3. 묶음수 (`t_prd_product_bundle_qtys`, load_rel_bundle_qtys 294-304)

- `12_상품별묶음수`의 (상품코드, 묶음수, 묶음단위명)을 적재. 묶음단위명→enum_code("QTY_UNIT")(line 301).
- **규칙:** 묶음수는 정규화 시트12의 행만 적재. **L1의 "(50장)" 텍스트는 시트12로 분해돼야 적재됨** — 분해 안 된 부자재는 bundle 0행.
- **🔴 라이브 실측:** PRD_000001=50/QTY_UNIT.01(EA)·002=50/QTY_UNIT.02(매)·003=100/30/40/20 매·004=10 매·005=10 매·009=10 EA·011=20 EA·283=50 EA. **볼체인(006)·와이어링(007)·우드(012~014)·리필잉크(015)·천정고리(008)·행택끈(010) = bundle 0행**(시트12 미분해). 단위도 혼선(001=EA·002=매, L1은 둘 다 "장")(§2 L-PA-C).

### 1-4. 사이즈 (`t_siz_sizes`+`t_prd_product_sizes`, load_sizes 194-207 / load_rel_sizes 307-315)

- 마스터: `04_사이즈정보`의 (사이즈명, 작업가로/세로, 재단가로/세로)를 **그대로** 적재(line 203-205). fix_size_dims.py가 사후 NULL 보정.
- 관계: `13_상품별사이즈`의 (상품코드, 사이즈코드) 연결.
- **🔴 핵심:** 라이브 siz_nm이 `"70x200mm(50장)"`·`"화이트165x115mm(10장)"` — **치수+묶음수(+색상)가 siz_nm 텍스트에 평면화**(cut_width/height는 70/200로 분해됐으나 "50장"·"화이트"가 siz_nm에 잔존). 즉 `04_사이즈정보` 시트가 사이즈명을 합성 텍스트로 가졌고 load_master가 그대로 옮김 → 묶음수가 bundle_qty와 siz_nm에 **중복 인코딩**(3축 미완분해, §2 L-PA-C).

### 1-5. 자재 (`t_mat_materials`+`t_prd_product_materials`, load_materials 227-247 / load_rel_materials 318-333)

- 마스터: `05_자재정보`의 (자재명, 자재구분→MAT_TYPE, …)를 적재. 자재구분 enum_code(line 239).
- 관계: usage 빈값→USAGE.공통(=USAGE.07) 강제(line 324, PK NOT NULL 대응).
- **🔴 핵심:** 볼체인 8색·리필잉크 7색·우드거치대가 **MAT_TYPE.10**으로 적재됨(자재명="오렌지 (3개1팩)" 등 색상+묶음/용량 합성). 즉 `05_자재정보` 시트가 부자재 색상을 자재 행으로 정의했고 load_master가 그대로 옮김 → 색상 variant가 자재로 오염(§2 L-PA-D).

### 1-6. 추가상품/template (`t_prd_product_addons`→`t_prd_templates`, load_rel_addons 436-444 / migrate_phase7 195-257)

- load_master: `20_상품별추가상품`의 (상품코드, 추가상품코드)를 addon_prd_cd로 적재(line 441).
- migrate_phase7: addon_prd_cd → `'TMPL-'||addon_prd_cd`(line 215,226) tmpl_cd 전환. base-only template을 ON CONFLICT DO NOTHING으로 자동 생성(line 212-219).
- **🔴 핵심:** 봉투 template(TMPL-000004~009)은 **봉투 상품이 다른 상품의 addon으로 참조될 때** migrate_phase7가 자동 생성한 것. 그러나 라이브 addon 행은 **PRD_000016(엽서)→TMPL-000005 1행뿐**(전 DB). TMPL-000001~003은 테스트(del_yn=Y), 004/007/008도 del_yn=Y, 005/006/009만 활성. 즉 봉투 template은 대부분 수동/테스트 생성물이고 실제 addon 연결은 1건 = **배경지 봉투 세트가 addon으로 적재 안 됨**(§2 L-PA-E·디지털인쇄 L-G와 동형).

### 1-7. 가격 (`t_prd_product_price_formulas`+`t_prc_component_prices`)

- **load_master.py 미관여** — RELATIONS 목록(line 469-481)에 price 없음. 가격은 dbm 하네스 round-2의 산물.
- **🔴 라이브 실측:** 봉투 부자재(PRD_000001~015) = `t_prd_product_price_formulas` **0행** · 봉투 사이즈(SIZ_000078~080) `t_prc_component_prices` **0행**. **L1은 "가격포함" 시트로 각 행에 단가(1100/3000/16000원 등)가 있는데 라이브 가격 사슬 전무**(§2 L-PA-F).

---

## 2. 발견된 적재 로직 결함 (file:line)

| ID | 결함 | 근거(file:line) | 라이브 증상 | 분류 |
|----|------|-----------------|-------------|------|
| **L-PA-A** | MES·qty_unit 무조건 None 적재 | load_master.py:261,269 | 라이브는 7/15 MES·전 qty_unit 채워짐 → load_master 산물 아님 | 적재 경로 불명(후속 손작업) |
| **L-PA-B** | 카테고리 상위코드 빈 행→영구 NULL 고아 + 상품을 고아에 연결 | load_master.py:171,175-176,282-291 | 15 부자재 → CAT_000293(NULL·lvl3 잉여 고아). 정상 노드 276/285/287 실재 | MIS-LOADED(시트 결함 통과) |
| **L-PA-C** | 사이즈명 합성 텍스트 그대로 적재(묶음수=siz+bundle 중복) | load_master.py:203-205 + 정규화 시트12/04 | siz_nm "70x200mm(50장)"·단위 혼선(001=EA·002=매) | MIS-LOADED(3축 미완분해) |
| **L-PA-D** | 색상 자재 행 그대로 적재(MAT_TYPE.10) | load_master.py:236-242 + 시트05 | 볼체인 8색·리필 7색=MAT_TYPE.10 자재. 옵션 0행 | MIS-LOADED(색상=자재 오염) |
| **L-PA-E** | 봉투 template 자동 생성(`TMPL-`+addon, 하이픈) but addon 원천 1건 | migrate_phase7.py:215,226 + load_master.py:436-444 | TMPL 9개 중 6 del_yn=Y·addon 실연결 1행 | MISSING(봉투 세트 미적재) |
| **L-PA-F** | 가격 적재 webadmin 밖(round-2 미커버) | load_master.py:469-481(price 부재) | 부자재 가격 공식/component 0행 | MISSING(가격 전무) |
| **L-PA-G** | 묶음수 정규화 시트12 미분해 부자재 | load_master.py:294-304 + 시트12 | 볼체인/우드/리필/와이어링 등 bundle 0행 | MISSING(묶음수 누락) |

> **방법론 핵심[HARD]:** load_master는 정규화 시트(04/05/12/13/14)를 **변환 없이 충실히 옮긴다**. 따라서 사이즈 3축 미분해(L-PA-C)·색상 자재 오염(L-PA-D)·카테고리 고아(L-PA-B)의 라이브 결함은 **정규화 시트 작성 단계의 산물**(스크립트 버그 아님). 반대로 MES·qty_unit(L-PA-A)은 load_master가 None 적재하므로 라이브 값은 **webadmin 밖 후속 손작업**(적재 경로 불명). 가격(L-PA-F)은 round-2가 부자재를 커버 안 해 전무. 이중등록(281~283)은 09_delete_dup_products가 삭제 제외 = 의도 보존.

---

## 3. 디지털인쇄 파일럿과의 적재경로 연속성

- **L-PA-B(카테고리 고아) = 디지털인쇄 L-H 동형** — CAT_000293(상품악세사리)·CAT_000295(상품권)·CAT_000296(배경지)이 모두 `구분` 라벨 파생 잉여 고아. 정상 012 포장 트리(273/274/275/276/283/285/287)를 두고 상품이 고아에 묶임. **정체 선행이 없으면 안 보이는 결함**.
- **L-PA-E(봉투 세트 미적재) = 디지털인쇄 L-G의 반대 끝** — 디지털인쇄 배경지(043/044)가 봉투 addon을 못 받은 것(L-G)과, 상품악세사리 봉투(PRD_000001~)가 그 addon의 base임이 연결된다. 즉 **봉투 template은 실재하나 배경지가 참조 안 함** → Q-ID-A는 "어느 모델로 배경지↔봉투를 연결하느냐"의 문제이고, 봉투 상품·template은 이미 준비됨(search-before-mint 재사용 가능).
