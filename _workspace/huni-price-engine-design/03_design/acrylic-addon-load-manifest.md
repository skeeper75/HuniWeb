# 아크릴 addon 5상품 CPQ+가산공식 멱등 적재본 매니페스트 (R4 구축)

> **작성** 2026-06-28 · `dbm-option-mapper`(구축) · 설계 권위 `03_design/acrylic-addon-design.md` + validator `04_validation/acrylic-addon-verdict.md`.
> **대상** addon 5상품: 147 마그넷 · 148 뱃지 · 149 집게 · 150 스마트톡 · 152 명찰.
> **권위[HARD]** ① 상품마스터 `24_master-extract-260610/acrylic-l1.csv`(가공옵션 = "*가격표참고") ② 가격표 B04b 후가공단가(verbatim) ③ 라이브 읽기전용 실측(2026-06-28).
> **산출** `_foundation/remediation/acryl-addon-147-152-{fix,dryrun,undo}.sql`. **DB 미적재**(dryrun ROLLBACK만·실 COMMIT 인간 승인).
> 146 키링은 별건 완료(`acryl-146-keyring-fix.sql`·라이브 바인딩 `PRF_ACRYL_KEYRING`@2026-06-28 실측 확인). 본 R4 범위 = 147~152.

---

## 0. 라이브 실측 기준점 (2026-06-28 · 본 적재본의 채번·무결성 근거)

| 항목 | 실측값 | 비고 |
|------|------|------|
| DB | `railway` | (postgres 아님) |
| opt_grp_cd 언더스코어 MAX | **`OPT_000073`** (us 135건·hy 14건 혼재) | 신규 = `OPT_000074~`(언더스코어·거버넌스 확정) |
| opt_cd(options) 언더스코어 MAX | **`OPV_000464`** (us 510건·hy 28건) | 신규 = `OPV_000465~` |
| comp_price_id MAX (PK·시퀀스 default 없음) | **`39077`** | 신규 = `39078~` 명시 채번 |
| 택1 sel_typ_cd | **`SEL_TYPE.01`** (라이브 136건) | min=0·max=1·mand_yn=N (146 "(옵션)" 선례 동형·미선택 허용) |
| 본체 comp `COMP_ACRYL_CLEAR3T` | 실재·`PRICE_TYPE.02`·use_dims=`[mat_cd,siz_width,siz_height,min_qty]`·comp_typ=`PRC_COMPONENT_TYPE.01` | 재사용(미터치) |
| KEYRING comp(가산 패턴 템플릿) | `PRICE_TYPE.01`·use_dims=`[opt_cd,min_qty,opt_grp:OPT-000012]`·comp_typ=`PRC_COMPONENT_TYPE.04` | 동형 복제 |
| usage_cd 위치 | t_mat_materials에 **없음** → `t_prd_product_materials(prd_cd,mat_cd,usage_cd)` PK 3중 | 부속 mat = **USAGE.07**(146 선례) |
| 트리거 `fn_chk_opt_item_ref` OPT_REF_DIM.03 | `t_prd_product_materials(prd_cd,mat_cd,usage_cd)` EXISTS 검사 | 옵션아이템 선행 = product_material 등록 필수 |
| 부속자재 8종 t_mat_materials 실재 | MAT_046 일자핀·047 원형핀·048 1구자석·049 2구자석·050 네오디움자석·053 스마트톡투명바디·054 화이트바디·056 투명집게 | 신규 mint **0** |
| 신규 comp5·공식5 기존재 | **전부 미존재** | 신규 생성(멱등 가드만) |
| 147~152 현 바인딩·옵션그룹 | **0** (견적불가 확증) | 본 적재본이 견적가능화 |

---

## 1. ★product_material 보강 (트리거 무결성 선결)

라이브 `t_prd_product_materials` 실측 — 옵션아이템 ref(OPT_REF_DIM.03=mat_cd+usage_cd) 선행 등록 점검:

| 상품 | 부속 mat | 등록 여부 | 조치 |
|------|------|:--:|------|
| 147 마그넷 | MAT_000050 네오디움자석 | **미등록** 🔴 | **보강 1건** `(PRD_000147, MAT_000050, USAGE.07)` |
| 148 뱃지 | MAT_000047 원형핀 · MAT_000048 1구자석 | 둘 다 등록 ✓ | 없음 |
| 149 집게 | MAT_000056 투명집게 | 등록 ✓ | 없음 |
| 150 스마트톡 | MAT_000053 투명바디 · MAT_000054 화이트바디 | 둘 다 등록 ✓ | 없음 |
| 152 명찰 | MAT_000046 일자핀 · MAT_000049 2구자석 | 둘 다 등록 ✓ | 없음 |

> **보강 = 147 단 1건.** 미보강 시 147 옵션아이템 INSERT가 트리거 `fn_chk_opt_item_ref`에 의해 거부됨(BLOCKED). 나머지 4상품은 product_material 선등록 완료 → 옵션아이템 즉시 통과.

---

## 2. 채번 표 (언더스코어·연속·충돌 0)

| prd | 옵션그룹 opt_grp_cd | 가공옵션(opt_cd / 부속mat / 가산액) | comp_cd | comp_price_id | frm_cd |
|-----|------|------|------|:--:|------|
| 147 마그넷 | `OPT_000074`(자석부착) | `OPV_000465` 자석부착 / MAT_000050 / **800** | `COMP_ACRYL_MAGNET` | 39078 | `PRF_ACRYL_MAGNET` |
| 148 뱃지 | `OPT_000075`(부속) | `OPV_000466` 원형핀 / MAT_000047 / **600**<br>`OPV_000467` 1구자석 / MAT_000048 / **1000** | `COMP_ACRYL_BADGE` | 39079·39080 | `PRF_ACRYL_BADGE` |
| 149 집게 | `OPT_000076`(집게) | `OPV_000468` 투명집게 / MAT_000056 / **700** | `COMP_ACRYL_CLIP` | 39081 | `PRF_ACRYL_CLIP` |
| 150 스마트톡 | `OPT_000077`(바디) | `OPV_000469` 화이트바디 / MAT_000054 / **2600**<br>`OPV_000470` 투명바디 / MAT_000053 / **3000** | `COMP_ACRYL_SMARTTOK` | 39082·39083 | `PRF_ACRYL_SMARTTOK` |
| 152 명찰 | `OPT_000078`(부속) | `OPV_000471` 일자핀 / MAT_000046 / **700**<br>`OPV_000472` 2구자석 / MAT_000049 / **1700** | `COMP_ACRYL_NAMETAG_PIN` | 39084·39085 | `PRF_ACRYL_NAMETAG` |

- **신규 옵션그룹 5** (OPT_000074~OPT_000078) · **신규 옵션 8** (OPV_000465~OPV_000472) · **신규 옵션아이템 8** · **신규 comp 5** · **단가행 8** (39078~39085) · **공식 5** · **바인딩 5** · **product_material 1**.
- 단가 = 가격표 B04b verbatim(작업지시 확정값). 본체 = COMP_ACRYL_CLEAR3T(MAT_043 면적격자·277셀) 재사용·미터치.

---

## 3. 상품별 구축 내역 (FK 위상순)

각 상품 동일 5층 (146 템플릿 복제):
1. **product_material**(147만) — 옵션아이템 트리거 선결.
2. **옵션그룹** `t_prd_product_option_groups` — sel_typ=SEL_TYPE.01(택1)·min=0·max=1·mand_yn=N·use_yn=Y·del_yn=N.
3. **옵션** `t_prd_product_options` — dflt_yn=N·disp_seq 순차.
4. **옵션아이템** `t_prd_product_option_items` — ref_dim_cd=OPT_REF_DIM.03·ref_key1=부속mat·ref_key2=USAGE.07·qty=NULL·item_seq=1.
5. **가산 comp** `t_prc_price_components` — prc_typ=PRICE_TYPE.01(단가형)·comp_typ=PRC_COMPONENT_TYPE.04·use_dims=`["opt_cd","min_qty","opt_grp:OPT_0000xx"]`(★opt_cd 보유=always-add 가드).
6. **단가행** `t_prc_component_prices` — apply_ymd=2026-06-28·opt_cd→unit_price(verbatim)·min_qty=1·comp_price_id 명시.
7. **공식** `t_prc_price_formulas` + **formula_components**(1:본체 CLEAR3T addtn_yn=N · 2:가산comp addtn_yn=Y).
8. **바인딩** `t_prd_product_price_formulas` — apply_bgn_ymd=2026-06-28.

---

## 4. 골든 케이스 (verdict E6 계승 · 마스터 등록사이즈 보강 포함)

본체 = 라이브 COMP_ACRYL_CLEAR3T(MAT_043·B01 면적격자 ceiling) + 가공 = B04b verbatim. qty=1(수량할인 미적용). 허용오차 0.

| # | 상품 | 사이즈 | 본체(라이브) | 가공옵션 | 가공단가 | **기대 골든** | 비고 |
|---|------|------|------|------|------|------|------|
| G4 | 147 마그넷 | 30x30 | 3100 | 자석부착(OPV_000465) | 800 | **3900** | 격자정점 |
| G4b | 147 마그넷 | 24x24→w30/h30 ceiling | 3100 | 자석부착 | 800 | **3900** | 마스터 등록사이즈 24(ceiling 검증) |
| G5 | 148 뱃지 | 40x40 | 3800 | 1구자석(OPV_000467) | 1000 | **4800** | |
| G6 | 148 뱃지 | 30x30 | 3100 | 원형핀(OPV_000466) | 600 | **3700** | |
| G7 | 149 집게 | 50x50 | 4800 | 투명집게(OPV_000468) | 700 | **5500** | |
| G8 | 150 스마트톡 | 50x50 | 4800 | 투명바디(OPV_000470) | 3000 | **7800** | |
| G9 | 150 스마트톡 | 60x60 | 5900 | 화이트바디(OPV_000469) | 2600 | **8500** | |
| G10 | 152 명찰 | 60x20 | 3400 | 2구자석(OPV_000472) | 1700 | **5100** | |
| G11 | 152 명찰 | 80x30 | 4700 | 일자핀(OPV_000471) | 700 | **5400** | |
| G-가드 | 147 마그넷 | 30x30 | 3100 | (가공 미선택) | 0 | **3100** | always-add 가드: opt_cd 미선택 → 가산 0 |

> dryrun SQL이 본체 라이브 단가 + 가산 단가행을 조회해 합산이 기대 골든과 일치하는지 어서션. 본체값은 라이브 t_prc_component_prices 실조회(날조 0).

---

## 5. 안전가드 (verdict §2 계승 · dryrun 어서션 대상)

1. **always-add 회피** — 전 가산 comp use_dims에 `opt_cd` 보유 → 손님 미선택 시 가산 0(G-가드). NULL 와일드카드 단가행 없음.
2. **이중합산 0** — 본체 use_dims(mat/siz/min_qty) ↔ 가산 use_dims(opt_cd/min_qty/opt_grp) 차원축 분리 → 동시매칭 불가.
3. **공유공식 미오염** — 전용공식 5개 신규(PRF_ACRYL_*)·`PRF_CLR_ACRYL`/`CLEAR3T`/`KEYRING` 미터치 보존([[base-master-code-no-delete]]).
4. **단가 verbatim** — B04b 값 그대로(800·600·1000·700·2600·3000·700·1700)·날조 0.
5. **트리거 무결성** — 147 product_material 선보강 → 옵션아이템 8건 전부 ref 통과.

---

## 6. dryrun 어서션 (ROLLBACK 전 검증)

- A1 채번 충돌 0: 신규 OPT_/OPV_/comp/frm/comp_price_id가 기존재와 미충돌(INSERT 성공).
- A2 옵션아이템 ref 무결성: 8건 전부 트리거 통과(147 product_material 보강 포함).
- A3 5바인딩 실재: 147~152 각 PRF_ACRYL_* 바인딩 1건씩.
- A4 가산 작동: 골든 9케이스 본체+가산 합산 = 기대값(허용오차 0).
- A5 always-add 가드: 미선택 시 가산 comp 매칭 0(G-가드).
- A6 멱등: 재실행 시 중복 INSERT 0(NOT EXISTS/ON CONFLICT).

---

## 7. 잔여 컨펌 (적재 전·verdict §8 계승)

| # | 항목 | 비고 |
|---|------|------|
| C1 | 가공옵션 **택1·비필수**(SEL_TYPE.01·min0·max1·mand_yn=N) 설계 채택 | 마스터 "(옵션)" 근거·146 선례. 필수화 원하면 mand_yn=Y·min1로 변경 |
| C2 | 단가 verbatim 확정 | 작업지시 = 가격표 B04b. 800·600·1000·700·2600·3000·700·1700 |
| C3 | 수량할인 가산범위(B04a) | 가산 comp에 수량할인 적용 여부 = 라이브 할인모델 의존(본 R4 범위 밖) |
| C4 | 볼펜155·지비츠156·네임택157 가공 | 권위 단가 부재(BLOCKED)·본 적재본 제외 |
