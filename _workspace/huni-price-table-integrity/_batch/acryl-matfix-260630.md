# 아크릴 mat_cd MISSING-HIGH 차원정합 결함 — 권위 대조 교정 명세 (2026-06-30)

> 진단원: `dim_conformance.py` 전수스캔 (`dim-conformance-fullscan-260630.tsv` 8~13행)
> 권위: 인쇄상품 가격표 260527 아크릴 시트 (`06_extract/price-acrylic-price-l1.csv`) + 상품마스터 260610
> 라이브 읽기전용 SELECT만. DB 미적재 — 실 COMMIT은 인간 승인 후 상위(§7/§18) 위임.
> 봉투 MAT_169(`envelope-mat169-fix-260630.sql`)와 **동형 아님** — 사유 본문.

## 결론 (1줄)

**담당 6건 전부 ② FALSE-POSITIVE (REVIEW 강등).** COMP_ACRYL_CLEAR3T의 mat_cd는 아크릴 **두께축**(투명 1.5/3mm)이고, 플래그된 MAT_046~057은 **후가공 부속**(자석/핀/집게/바디/명찰핀/머리끈)이라 별도 **opt_cd 가산 component**가 담당한다. CLEAR3T에 부속을 mat_cd로 복제하면 "자석 재질 아크릴 면적단가"라는 **무의미 행 날조**가 된다 → 봉투 복제형 교정 불가.
단, FP가 가리키는 **진짜 인접 결함**(후가공 가산 미청구 = 저청구)을 별도 escalation으로 보고한다(단가행 적재 아님 = 배선/바인딩 복원).

---

## 1. 3가지 함정 점검 (지시된 [HARD] 가드)

### 점검① PRF_CLR_ACRYL에 다른 자재담당 component가 있나?
- `PRF_CLR_ACRYL` formula_components = **`COMP_ACRYL_CLEAR3T` 단 1개**. 6상품 모두 이 공식 **하나에만** 바인딩(apply_bgn_ymd 2026-06-28).
- union 분담 흡수 대상 없음 → 스크립트 union이 흡수 못함.

### 점검② COMP_ACRYL_CLEAR3T의 mat_cd는 자재구분인가, 면적/두께축인가?
- `prc_typ=PRICE_TYPE.02`(합가/면적형), `use_dims=["mat_cd","siz_width","siz_height","min_qty"]`.
- 충전 mat_cd 2종뿐: **MAT_000042(아크릴 투명 1.5mm) 81행 · MAT_000043(아크릴 투명 3mm) 196행** — 둘 다 `MAT_TYPE.03`(아크릴 원판). **mat_cd = 두께축**(면적 격자 × 두께).
- **6상품 모두 본체 자재 MAT_000043(투명3mm)을 노출하고 CLEAR3T에 196행 존재 = 본체는 정상 커버.** 누락이라 플래그된 건 본체가 아니라 부속.

### 점검③ MAT_046~057이 무엇인가?
전부 `MAT_TYPE.07` (후가공 부속, upr_mat_cd=MAT_000045) — 아크릴 원판 아님:

| mat_cd | mat_nm | 노출 상품 |
|---|---|---|
| MAT_000050 | 네오디움 자석 | 147 아크릴마그넷 |
| MAT_000047 / 048 | 원형핀 / 1구자석 | 148 아크릴뱃지 |
| MAT_000056 | 투명집게 | 149 아크릴집게 |
| MAT_000053 / 054 | 스마트톡 투명바디 / 화이트바디 | 150 아크릴스마트톡 |
| MAT_000046 / 049 | 일자핀 / 2구자석 | 152 아크릴명찰 |
| MAT_000057 | 블랙헤어끈 | 154 아크릴 머리끈 |

→ 손님이 고르는 **후가공 부속**이지, 본체 아크릴 두께가 아니다. **FP 확정.**

---

## 2. FP 근본원인 — 부속은 opt_cd 가산 component가 담당 (CLEAR3T 무관)

라이브에 **부속 전담 component가 이미 존재·단가 적재 완료**(opt_cd축, opt_grp 게이트):

| 가산 comp | use_dims | 적재 단가행(opt_cd=단가) | 권위(가격표 "후가공 옵션 및 단가") |
|---|---|---|---|
| COMP_ACRYL_MAGNET | [opt_cd,min_qty,opt_grp:OPT_000074] | OPV_000465=**800** | 네오디움자석=800 ✅ |
| COMP_ACRYL_BADGE | [opt_cd,min_qty,opt_grp:OPT_000075] | OPV_000466=**600** · OPV_000467=**1000** | 원형핀=600·1구자석=1000 ✅ |
| COMP_ACRYL_CLIP | [opt_cd,min_qty,opt_grp:OPT_000076] | OPV_000468=**700** | 투명집게=700 ✅ |
| COMP_ACRYL_SMARTTOK | [opt_cd,min_qty,opt_grp:OPT_000077] | OPV_000469=**2600** · OPV_000470=**3000** | 화이트바디=2600 ✅ |
| COMP_ACRYL_NAMETAG_PIN | [opt_cd,min_qty,opt_grp:OPT_000078] | OPV_000471=**700** · OPV_000472=**1700** | 일자핀=700·2구자석=1700 ✅ |
| COMP_ACRYL_BLACK_HAIR_BAND | [opt_cd,min_qty,opt_grp:OPT-000014] | OPV-000028=**500** | 블랙머리끈=500 ✅ |

그리고 **본체+부속 전용공식도 이미 존재**: `PRF_ACRYL_MAGNET = COMP_ACRYL_CLEAR3T + COMP_ACRYL_MAGNET` (뱃지/집게/스마트톡/명찰/머리끈 동일 구조).

→ 부속 단가는 권위·라이브 모두 **이미 갖춰져 있다.** CLEAR3T에 추가할 것 없음. **dim_conformance가 t_prd_product_materials(부속을 mat으로 표시)만 보고 CLEAR3T 두께축과 비교해 생긴 거짓양성.**

### 봉투 MAT_169와 동형이 아닌 이유
봉투는 MAT_168(레자크체크)·MAT_169(레자크줄무늬)가 **같은 component·같은 자재축(원단)**이고 권위가 "동일단가 1셀"로 명시 → 진짜 누락 → 복제 정당. 아크릴은 플래그 자재가 **다른 역할(부속)·다른 component(opt_cd 가산)**라 복제 대상이 아니다.

---

## 3. 담당 6건 분류

| prd_cd | 상품 | 플래그 mat_cd | 분류 | 사유 |
|---|---|---|---|---|
| PRD_000147 | 아크릴마그넷 | MAT_050 | **② FP** | 부속(네오디움자석)=COMP_ACRYL_MAGNET opt_cd 담당. 본체 MAT_043 정상 |
| PRD_000148 | 아크릴뱃지 | MAT_047,048 | **② FP** | 부속(원형핀/1구자석)=COMP_ACRYL_BADGE |
| PRD_000149 | 아크릴집게 | MAT_056 | **② FP** | 부속(투명집게)=COMP_ACRYL_CLIP |
| PRD_000150 | 아크릴스마트톡 | MAT_053,054 | **② FP** | 부속(스마트톡 바디)=COMP_ACRYL_SMARTTOK |
| PRD_000152 | 아크릴명찰 | MAT_046,049 | **② FP** | 부속(일자핀/2구자석)=COMP_ACRYL_NAMETAG_PIN |
| PRD_000154 | 아크릴 머리끈 | MAT_057 | **② FP** | 부속(블랙헤어끈)=COMP_ACRYL_BLACK_HAIR_BAND |

**① 진짜누락 0 · ② FP 6 · ③ BLOCKED 0.** CLEAR3T 단가행 적재 dryrun **없음**(적재 시 데이터 오염).

---

## 4. 인접 진짜 결함 (escalation — 담당결함 아님 · 저청구)

FP의 표면 밑에 **진짜 돈샘(저청구)**가 있다. 단, **단가행 적재가 아니라 배선/바인딩 복원**이라 봉투형 turnkey 불가. 3중 결손:

- **R1 바인딩 결함**: 6상품(+146 키링)이 **본체전용 PRF_CLR_ACRYL**에 바인딩됨. 올바른 공식은 **PRF_ACRYL_MAGNET 등(본체+가산)**. 부속 전용공식엔 **바인딩 상품 0** (전용공식·가산comp·단가 모두 고아). → §26 156셀 면적 rebind(2026-06-28)가 부속 CPQ 배선을 supersede한 흔적.
- **R2 옵션레이어 결손**: 6상품 **option_groups 0 · option_items 0**. 부속 opt_cd(OPV_000465 등)가 손님에게 노출 안 됨 → 가산comp의 opt_cd 입력 없음 → rebind만으로도 발화 불가.
- **R3 엔진 C-track**: opt_cd 가산모델이 라이브 엔진에서 미발화 이력([[addon-optcd-model-broken-live]]). 복원해도 엔진 처리 선결.

**돈영향**: 부속 surcharge(자석 800·뱃지 600~1000·집게 700·스마트톡 2600~3000·명찰 700~1700·머리끈 500) **전건 미청구 = 저청구**. 단 본체 면적가는 정상 산출(시뮬 calc OK).

**라우팅**: §18 부속 CPQ 재설계(전용공식 바인딩 + 옵션그룹/아이템 복원) → §7 적재(인간 승인) + §6/C-track 엔진 검증. **본 진단의 mat_cd 플래그로 즉석 적재 금지.**

### 방향성 dryrun (R1 부분 — 단독 불충분, 참고용·ROLLBACK)

```sql
-- 방향성: 6상품을 본체전용 PRF_CLR_ACRYL → 본체+가산 전용공식으로 rebind.
-- ★단독 불충분: R2(옵션아이템)·R3(엔진) 미해소 시 가산comp opt_cd 입력 없어 발화 안 됨.
--   실 교정은 §18 CPQ 복원 패키지로 묶어 인간 승인 후 진행. 여기선 DRY-RUN 검증만.
BEGIN;
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_ACRYL_MAGNET'      WHERE prd_cd='PRD_000147' AND frm_cd='PRF_CLR_ACRYL';
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_ACRYL_BADGE'       WHERE prd_cd='PRD_000148' AND frm_cd='PRF_CLR_ACRYL';
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_ACRYL_CLIP'        WHERE prd_cd='PRD_000149' AND frm_cd='PRF_CLR_ACRYL';
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_ACRYL_SMARTTOK'    WHERE prd_cd='PRD_000150' AND frm_cd='PRF_CLR_ACRYL';
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_ACRYL_NAMETAG'     WHERE prd_cd='PRD_000152' AND frm_cd='PRF_CLR_ACRYL';
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_ACRYL_HAIRBAND'    WHERE prd_cd='PRD_000154' AND frm_cd='PRF_CLR_ACRYL';
SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas
  WHERE prd_cd IN ('PRD_000147','PRD_000148','PRD_000149','PRD_000150','PRD_000152','PRD_000154')
  ORDER BY prd_cd;
ROLLBACK;  -- === DRY-RUN ===
```

---

## 5. 스크립트 개선 제안 (FP 재발 방지)

`dim_conformance.py` Face C가 `t_prd_product_materials`를 mat_typ 구분 없이 mat_cd로 모음 → **원판(MAT_TYPE.03)과 후가공 부속(MAT_TYPE.07)을 같은 축으로 비교**해 거짓양성. 제안: Face C 자재수집 시 mat_typ_cd로 분리하거나, 비교 component의 충전 mat 타입과 같은 타입만 대조. (구조 변경이라 별도 검토 — 본 진단은 수동 FP 강등으로 처리.)
