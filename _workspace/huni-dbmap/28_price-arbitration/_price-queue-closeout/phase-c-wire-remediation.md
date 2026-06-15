# Phase C — WIRE(가격사슬 배선 미완) 정정 제안본 (round-19 가격 폐루프)

> 작성 2026-06-15 · round-19 Phase C · `dbm-price-arbiter`. **비파괴**(제안·심의·INSERT/UPDATE 제안문·DDL 개요까지 — 실 COMMIT/DDL은 인간 승인).
> 권위(HARD) = 가격표 엑셀 `docs/huni/후니프린팅_인쇄상품_가격표_260527.xlsx`(명함포토카드·후가공_박(소형/대형)) + round-19 큐. 라이브 `t_prc_*`(2026-06-15 읽기전용 SELECT)는 **배선 현황 실측 오라클**이지 권위 아님.
> 입력 = `_price-queue-closeout/phase-a-pricetable-recheck.md`(MATGROUP/WIRE-3 GO) + `29_readiness/_price-remediation-queue.md` §2/§3/§5 + `29_readiness/namecard/quote-gate.md` + 라이브 실측(본 세션).
> **닫는 대상**: 명함 031/032/033 가격 배선 + 상품권 042 박. **보정 하드코딩 0**([HARD]) — 라이브/제안 단가만으로 재현돼야 RESOLVED.
> **Phase B(D-1b)와 경계**: Phase B = 박 comp의 prc_typ 메타(.01→.03) 정정만. Phase C = 박 배선·042 박 comp 신설. **prc_typ 메타 정정은 본 문서가 다루지 않음**(중복 금지·§6).

---

## 0. 라이브 배선 현황 실측표 (2026-06-15 read-only) — 결함 재확인

### 0-1. PRF_NAMECARD_FIXED 배선 (031/032/033 공유 공식)

```
SELECT frm_cd, comp_cd, disp_seq FROM t_prc_formula_components
WHERE frm_cd='PRF_NAMECARD_FIXED' ORDER BY disp_seq;
→ PRF_NAMECARD_FIXED | COMP_NAMECARD_STD_S1 | 1
  PRF_NAMECARD_FIXED | COMP_NAMECARD_STD_S2 | 2
```

**배선된 comp = STD S1/S2 단 2개.** 명함종 comp 25개 중 **23개 미배선**.

### 0-2. 명함종 comp 전수 인벤토리 + 배선여부 (라이브 실측)

| comp_cd | comp_nm(축약) | 단가행 | 배선됨? | 용도 |
|---------|------|:--:|:--:|------|
| COMP_NAMECARD_STD_S1/S2 | 명함 단가(용지포함) | 2 each | **✅ PRF_NAMECARD_FIXED** | 033 스탠다드 |
| COMP_NAMECARD_PREMIUM_S1/S2_MGA | 명함 단가(용지포함) | 1 each | ❌ 미배선 | **031 프리미엄 A군** |
| COMP_NAMECARD_PREMIUM_S1/S2_MGB | 명함 단가(용지포함) | 1 each | ❌ 미배선 | **031 프리미엄 B군** |
| COMP_NAMECARD_COAT_S1/S2 | 명함 단가(용지포함) | 2 each | ❌ 미배선 | **032 코팅** |
| COMP_NAMECARD_PEARL_S1/S2 | 명함 단가(용지포함) | 2 each | ❌ 미배선 | 펄지 명함 |
| COMP_NAMECARD_WHITE_S1W/S2W_CL/NOCL | 명함 단가(용지포함) | 1 each | ❌ 미배선 | 화이트(클리어/노클리어) |
| COMP_NAMECARD_CLEAR_S1 | 명함 단가(용지포함) | 1 | ❌ 미배선 | 클리어 |
| COMP_NAMECARD_SHAPE_S1/S2 | 명함 단가(용지포함) | 1 each | ❌ 미배선 | 도무송 명함 |
| COMP_NAMECARD_MINISHAPE_S1/S2 | 명함 단가(용지포함) | 1 each | ❌ 미배선 | 미니도무송 |
| COMP_NAMECARD_FOIL_S1/S2_STD | 오리지널박 합가(완제품가) | 9 each | ❌ 미배선 | **031 박(일반 6색)** |
| COMP_NAMECARD_FOIL_S1/S2_HOLO | 오리지널박 합가(완제품가) | 9 each | ❌ 미배선 | **031 박(홀로/트윙클)** |
| COMP_NAMECARD_FOIL_SETUP_S1/S2_STD | 박형압 동판셋업비 | 1 each(5,000) | ❌ 미배선 | **031 박 셋업** |

- **결함 NAMECARD-WIRE 재확인**: 031(PREMIUM)·032(COAT)·박(FOIL)이 전부 미배선 → 031 전 견적 단절·032 코팅 STD로 떨어져 오산·031 박 침묵 누락. 데이터·단가행은 전부 실재·L1 정합(아래 §1-2/§2).
- **모든 comp `prc_typ_cd=PRICE_TYPE.01`**(단가형) — 이는 **Phase B(D-1b)** 영역(메타 오적재). 본 Phase C는 배선만 다룸(§6 경계).

### 0-3. 042 박 배선 + DB 전체 박 comp 범위 (라이브 실측)

```
-- 042(PRF_DGP_A) 배선 comp 중 박 관련: 0행 → 042 박 comp 미배선·부재
-- PRF_DGP_A 전 배선 = 인쇄·별색·코팅·용지·오시·미싱·가변·모서리 29 comp (박 0개)
-- DB 전체 박 가격 comp = COMP_NAMECARD_FOIL_* 6개(명함전용)만
```

- **042 박 comp 부재 확정**: PRF_DGP_A는 합산형 29 comp이나 박 comp 0개. DB 전체에서 박 가격 comp는 명함전용 6개뿐 → **042용 박 comp 신설 필요**(명함 박은 종이포함이라 재사용 불가·§4).

### 0-4. PRICE_TYPE 코드 현황 (라이브 `t_cod_base_codes`)

```
PRICE_TYPE.01 | 단가형  | disp_seq 1 | use_yn Y
PRICE_TYPE.02 | 합가형  | disp_seq 2 | use_yn Y
(.03 구간고정총액형 = 부재)
```

- 042 박 comp 신설 시 prc_typ는 본 Phase C 범위 밖(Phase B의 .03 결정에 동조). 본 문서는 신설 comp의 prc_typ를 **잠정 미지정(Phase B 동조)**로 둠.

---

## 1. NAMECARD-WIRE — 명함종 comp 배선 (큐 §2-a) — **공식분리 ⓑ 권고**

### 1-1. 분기로직 대안·트레이드오프

고정가형은 명함종별 comp **택1 룩업**(합산 아님). 한 공식 PRF_NAMECARD_FIXED에 명함종 comp 25개를 다 배선하면 엔진이 "어느 명함종인가"로 1개를 택1해야 한다. 두 길:

| 대안 | 무엇 | 장점 | 단점 | 권고 |
|------|------|------|------|:--:|
| **ⓐ 단일 공식 + 명함종 discriminator** | PRF_NAMECARD_FIXED에 25 comp 전부 배선 + 엔진이 선택 명함종(option)으로 1개 택1 | 공식 1개·바인딩 불변 | 배선 다수(25)·엔진에 "고정가형 명함종 택1" 분기 로직 신규 구현 필요. formula_components가 합산형(addtn_yn=Y)과 의미 충돌(25개 합산되면 폭증) | △ |
| **ⓑ 상품별 공식 분리** | `PRF_NAMECARD_PREMIUM`·`PRF_NAMECARD_COAT` 신설(STD는 기존 `PRF_NAMECARD_FIXED` 유지) + 031→PREMIUM·032→COAT·033→STD 바인딩 UPDATE. 각 공식 1~2 comp만 배선 | 공식별 배선 단순(택1 불요·공식 자체가 명함종 고정)·엔진 분기 로직 불요·의미 정합(상품별 1고정) | 공식 데이터 INSERT 2~3건·바인딩 UPDATE 2건 | **○ 권장** |

**권고 = ⓑ 공식분리.** 근거:
- **BIND 일반원칙 정합** [[dbmap-price-pipeline-execution-round18plus]]: "한 상품 다중택1 → option_items+.08 / **상품별 1고정 → 공식분리**". 명함종은 상품(031/032/033)당 1종 고정(031=프리미엄·032=코팅·033=스탠다드)이므로 공식분리가 의미 정합.
- ⓐ는 25 comp를 한 공식에 합산형(addtn_yn=Y)으로 두면 엔진이 합산(25개 더함)할 위험. 고정가형 "택1"을 엔진에 별도 구현해야 하는데, 이는 합산형 엔진에 새 분기를 강제 → **회귀·복잡도 증가**.
- ⓑ는 공식 자체가 "이 명함종 1 comp"이므로 합산형 엔진을 그대로 써도(공식당 S1/S2 중 면으로 택1 = 기존 STD 거동과 동일) 올바로 작동. **엔진 무변경**.

> **공식 신설은 DDL이 아니다**: `t_prc_price_formulas`(공식 정의)·`t_prd_product_price_formulas`(바인딩)·`t_prc_formula_components`(배선)는 **전부 기존 테이블 데이터 INSERT/UPDATE**. 신규 컬럼·테이블 0 → ddl-proposer 불요. round-16 배선 트랙 + round-2 분기결정 트랙.

### 1-2. 명함종 comp 단가행 L1 정합 (라이브 실측·배선 후 룩업 도달값)

| comp | mat_cd | 100매 unit_price | L1 출처 |
|------|--------|:--:|------|
| COMP_NAMECARD_STD_S1 | MAT_000074(백모조220) | 3,500 | 명함포토카드 B4 3,500군 |
| COMP_NAMECARD_STD_S1 | MAT_000082(아트300) | 3,800 | 명함포토카드 C4 3,800군 |
| COMP_NAMECARD_PREMIUM_S1_MGA | (mat_cd 없음·소재군 A) | 4,500 | 명함 프리미엄 R10 A단면 |
| COMP_NAMECARD_COAT_S1 | MAT_000081(아트250) | 5,500 | 코팅 R17 |
| COMP_NAMECARD_COAT_S1 | MAT_000082(아트300) | 5,800 | 코팅 R17 |

- PREMIUM은 mat_cd 없이 **소재군 등급(MGA/MGB)** 룩업(프리미엄지는 가격이 소재군 단위) — 차원환원은 소재→등급 매핑(quote-gate §Q3 PASS).
- COAT는 mat_cd 직접(081=5,500·082=5,800) — 코팅명함은 소재별 단가.
- **데이터 전건 정확** → 배선만 하면 룩업 도달.

### 1-3. 멱등 INSERT/UPDATE 제안 (round-16 배선·round-2 공식분리·실 COMMIT 인간 승인)

```sql
-- ============================================================
-- NAMECARD-WIRE 정정 [ⓑ 공식분리] — round-16 배선 + round-2 공식신설
-- 전제: WIRE-1(ⓑ) 비준. 멱등(ON CONFLICT / NOT EXISTS 가드). 단가행 신설 0·comp 신설 0.
-- ============================================================

-- (1) 공식 정의 신설 (t_prc_price_formulas 데이터 INSERT — DDL 아님)
--     기존 PRF_NAMECARD_FIXED 행을 템플릿으로 frm_typ·note 복제. note는 명함종 명시.
INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn, reg_dt)
SELECT v.frm_cd, v.frm_nm, v.note, 'Y', now()
FROM (VALUES
  ('PRF_NAMECARD_PREMIUM','프리미엄명함 단가(고정가형·소재군x면 룩업)','명함 프리미엄 단가(용지포함). 수량x(소재군등급xS1/S2) 표 단품가 조회'),
  ('PRF_NAMECARD_COAT','코팅명함 단가(고정가형·소재x면 룩업)','명함 코팅 단가(용지포함). 수량x(소재xS1/S2) 표 단품가 조회')
) AS v(frm_cd, frm_nm, note)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_price_formulas f WHERE f.frm_cd = v.frm_cd);

-- (2) 배선: 각 명함종 공식에 면별(S1/S2) comp 배선 (택1 아님 — 공식이 명함종 고정·면만 분기)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT v.frm_cd, v.comp_cd, v.disp_seq, 'Y', now()
FROM (VALUES
  -- 031 프리미엄 (A/B 소재군 x 면) — 단가행이 MGA/MGB 등급별 → 4 comp
  ('PRF_NAMECARD_PREMIUM','COMP_NAMECARD_PREMIUM_S1_MGA',1),
  ('PRF_NAMECARD_PREMIUM','COMP_NAMECARD_PREMIUM_S1_MGB',2),
  ('PRF_NAMECARD_PREMIUM','COMP_NAMECARD_PREMIUM_S2_MGA',3),
  ('PRF_NAMECARD_PREMIUM','COMP_NAMECARD_PREMIUM_S2_MGB',4),
  -- 032 코팅 (면별·소재는 단가행 mat_cd 룩업) — 2 comp
  ('PRF_NAMECARD_COAT','COMP_NAMECARD_COAT_S1',1),
  ('PRF_NAMECARD_COAT','COMP_NAMECARD_COAT_S2',2)
) AS v(frm_cd, comp_cd, disp_seq)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_formula_components fc
  WHERE fc.frm_cd = v.frm_cd AND fc.comp_cd = v.comp_cd
);

-- (3) 바인딩 전환: 031→PREMIUM, 032→COAT (033은 기존 FIXED 유지)
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_NAMECARD_PREMIUM', upd_dt=now()
WHERE prd_cd='PRD_000031' AND frm_cd='PRF_NAMECARD_FIXED';
UPDATE t_prd_product_price_formulas SET frm_cd='PRF_NAMECARD_COAT', upd_dt=now()
WHERE prd_cd='PRD_000032' AND frm_cd='PRF_NAMECARD_FIXED';
```

> **주의(컨펌 분리):** PREMIUM은 단가행에 `mat_cd` 없이 소재군 등급(MGA/MGB)이 comp_cd에 인코딩됨 → 031 프리미엄에서 손님 소재 선택을 어느 등급(A/B)으로 환원할지는 차원환원(quote-gate §Q3에서 PASS 확인). 등급별로 comp_cd가 갈리므로 PREMIUM 공식에 MGA/MGB 4 comp를 다 배선하고 **엔진이 선택 소재의 등급으로 S1/S2_MG{A,B} 중 택1**(STD가 mat_cd로 단가행 택1하는 것과 동형 — 합산형 엔진의 단가행 매칭으로 자연 도달). addtn_yn=Y지만 면(S1/S2)·등급(A/B)이 손님 선택으로 1개만 매칭되므로 합산 폭증 없음(STD가 S1/S2 2개 배선이어도 면 1개만 매칭되는 것과 동일).

### 1-4. 미해소 — WIRE-1 최종 결정
- ⓐ(단일공식+discriminator) vs **ⓑ(공식분리·권고)** 최종 비준 = round-2 `dbm-price-formula` + 실무진. 본 제안은 ⓑ 가정.

---

## 2. MATGROUP — 033 STD 단가행 확장 (큐 §2-c·Phase A GO)

### 2-1. mat_cd↔소재명 귀속 — **라이브 실측으로 확정 (round-13 대조 불요·추측 0)**

Phase A 경고("mat_cd 귀속은 round-13 대조 필요")에 대해, 본 세션 라이브 `t_mat_materials` 실측으로 **귀속 확정**:

```
SELECT mat_cd, mat_nm FROM t_mat_materials WHERE mat_cd IN (...074,081,082,091,092);
→ MAT_000074 | 백색모조지 220g
  MAT_000081 | 아트지 250g
  MAT_000082 | 아트지 300g
  MAT_000091 | 스노우지 250g
  MAT_000092 | 스노우지 300g
```

가격표 헤더(Phase A B3/C3)와 **정확히 대조**:

| 가격열 | 가격표 헤더 소재(Phase A) | 라이브 mat_cd 귀속 | STD 단가행 보유 | 부재(확장 대상) |
|------|------|------|:--:|:--:|
| **3,500군** | 백모조220 / 아트250 / 스노우250 | 074 / **081** / **091** | 074만 | **081·091** |
| **3,800군** | 아트300 / 스노우300 | 082 / **092** | 082만 | **092** |

- 귀속이 라이브 소재명으로 **명시 확정**(백모조220=074·아트250=081·스노우250=091·아트300=082·스노우300=092). round-13 대조 없이 닫힘. 033이 쓰는 종이 5종(option_items 실측)도 정확히 이 5개.

### 2-2. ⓐ 대표가 복제 — component_prices INSERT 제안 (round-16)

```sql
-- ============================================================
-- MATGROUP 정정 [ⓐ STD 단가행 대표가 복제] — round-16 단가행 확장
-- 권위: 명함포토카드 B01 헤더가 동일가 묶음 명시(3,500군·3,800군). 멱등(NOT EXISTS).
-- mat_cd 귀속 = 라이브 t_mat_materials 실측 확정(추측 0).
-- 단면(S1) + 양면(S2) · 100매 외 전 수량구간 동형 복제 필요 → 074/082 행을 081/091/092로 복제.
-- ============================================================

-- 3,500군: STD 074 단가행 → 081(아트250)·091(스노우250) 복제 (단면·양면·전 수량)
INSERT INTO t_prc_component_prices (comp_cd, mat_cd, min_qty, unit_price, reg_dt /* +기타 차원컬럼 동일복제 */)
SELECT cp.comp_cd, v.tgt_mat, cp.min_qty, cp.unit_price, now()
FROM t_prc_component_prices cp
CROSS JOIN (VALUES ('MAT_000081'),('MAT_000091')) AS v(tgt_mat)
WHERE cp.comp_cd IN ('COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2')
  AND cp.mat_cd = 'MAT_000074'   -- 3,500군 대표
  AND NOT EXISTS (
    SELECT 1 FROM t_prc_component_prices x
    WHERE x.comp_cd=cp.comp_cd AND x.mat_cd=v.tgt_mat AND x.min_qty=cp.min_qty);

-- 3,800군: STD 082 단가행 → 092(스노우300) 복제
INSERT INTO t_prc_component_prices (comp_cd, mat_cd, min_qty, unit_price, reg_dt)
SELECT cp.comp_cd, 'MAT_000092', cp.min_qty, cp.unit_price, now()
FROM t_prc_component_prices cp
WHERE cp.comp_cd IN ('COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2')
  AND cp.mat_cd = 'MAT_000082'   -- 3,800군 대표
  AND NOT EXISTS (
    SELECT 1 FROM t_prc_component_prices x
    WHERE x.comp_cd=cp.comp_cd AND x.mat_cd='MAT_000092' AND x.min_qty=cp.min_qty);
```

> 실 실행 전 round-16 `dbm-price-import-builder`가 component_prices 전 차원컬럼(siz_cd·clr_cd 등)을 074/082 행과 동일 복제하도록 컬럼 목록 확정. 단가값(3,500/3,800)은 가격표 권위로 변경 없이 복제(동일가 묶음 = 새 값 만들지 않음).

---

## 3. 031 박 배선 (큐 §2-b·명함) — 배선만

### 3-1. 사실 (라이브 실측)
- 명함 박 comp = COMP_NAMECARD_FOIL_S1/S2_STD·HOLO(각 9 단가행) + FOIL_SETUP_S1/S2_STD(5,000) **실재·미배선**.
- FOIL_S1_STD 단가행 = 면적등급·소재·색 축 **전부 NULL·수량 1D만**(200매 19,200 ~ 1000매 63,000) = Phase A "종이+동판+박가공비 완제품가"(면적등급 collapse) 확정.
- 명함 박은 종이포함 완제품가 → **명함 공식엔 그대로 배선해도 정합**(종이 이중계상 없음 — 명함 공식은 박 1종이 완제품 총액).

### 3-2. 멱등 INSERT 제안 (round-16 배선·comp 신설 0)

```sql
-- ============================================================
-- 031 박 배선 — 명함 박은 종이포함 완제품가(.06급)라 배선만. comp 신설 0.
-- ⓑ 공식분리 채택 시: 031 박은 PRF_NAMECARD_PREMIUM(031 바인딩 공식)에 add-on 배선.
-- (031은 프리미엄 본체 + 선택 시 박 add-on. 박 add-on은 합산이 맞음 — 본체단가+박합가.)
-- ============================================================
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT 'PRF_NAMECARD_PREMIUM', v.comp_cd, v.disp_seq, 'Y', now()
FROM (VALUES
  ('COMP_NAMECARD_FOIL_S1_STD',11),
  ('COMP_NAMECARD_FOIL_S1_HOLO',12),
  ('COMP_NAMECARD_FOIL_S2_STD',13),
  ('COMP_NAMECARD_FOIL_S2_HOLO',14),
  ('COMP_NAMECARD_FOIL_SETUP_S1_STD',15),
  ('COMP_NAMECARD_FOIL_SETUP_S2_STD',16)
) AS v(comp_cd, disp_seq)
WHERE NOT EXISTS (
  SELECT 1 FROM t_prc_formula_components fc
  WHERE fc.frm_cd='PRF_NAMECARD_PREMIUM' AND fc.comp_cd=v.comp_cd);
```

> **주의(WIRE-1 의존):** 031이 프리미엄(PREMIUM)인지 별도 "오리지널박명함"(다른 상품)인지 — quote-gate는 031을 프리미엄으로 보되 박칼라 8색 옵션 보유. 본 제안은 031 박 add-on을 031 바인딩 공식(ⓑ면 PRF_NAMECARD_PREMIUM)에 배선. ⓐ(단일공식) 채택 시엔 PRF_NAMECARD_FIXED에 배선. **박은 본체+박 합산이라 addtn_yn=Y 정합**(명함종 본체단가 택1 + 박 add-on 더함). 박 선택 안 하면(박없음 null choice) 박 comp 미매칭 → 합산 0(정상).
> 명함 박은 면적등급 차원 불요(완제품가가 수량 1D로 흡수) — 042와 결정적 차이(§4).

---

## 4. 042 박 공용 comp 신설 (큐 §3 ⓐ·WIRE-3 GO) — ddl-proposer 라우팅

### 4-1. 042 박 vs 명함 박 — 재사용 불가(종이 이중계상) 확정

| 항목 | 명함 031 박 | 상품권 042 박 |
|------|------------|--------------|
| 박 가격 comp | 있음(FOIL 6개·완제품가) | **0개(부재·신설 필요)** |
| 단가 의미 | 종이+동판+박가공 **완제품가**(F57 명시) | **순수 박가공비만**(종이=COMP_PAPER 별도) |
| 200매 A등급 | 19,200(종이+동판 포함) | **12,200**(순수·후가공_박(소형) I10) |
| 면적등급 차원 | collapse(수량 1D) | **필수(A~E×수량 2D)** |

- **명함 FOIL 042 재사용 = 종이 이중계상**(042는 COMP_PAPER로 종이 이미 합산 + FOIL이 또 종이 포함 → 과대청구). **ⓑ 기각 확정**(Phase A·큐 §3).
- 042는 **순수 박가공비 comp 신설**이 정답.
- **[검증 정정 2026-06-15]** 명함(19,200)−042순수(12,200)=7,000의 본질은 **종이분**이며, 동판 5,000은 양쪽 공통 가산항(명함 F57 완제품가에 동판이 이미 흡수됐는지는 명함 박 단가표 구조에 의존 → WIRE-3b 동반 검증). "약 7,000=종이+동판"이 아니라 "차액 본질=종이"로 봐야 정확. 정확한 종이분 금액은 042 박 단가행 적재 후 확정(엔진 미구현이라 현재 정밀 산술 불가).

### 4-2. 후가공_박(소형) 시트 권위 — 면적등급×수량 단가 (가격표 실측)

```
동판비(A1) = 5,000 (수량무관·"*아연판")
면적등급 정의(A9:F12) = 가로(10~80mm)×세로(10~80mm) → A/B/C/D/E 등급 매트릭스
일반박 등급×수량(H9:K27) = 금/은/먹/청/적/동/펄박 공용:
  200매  A=12,200  B=15,000  C=16,400
  300매  A=14,300  B=18,500  C=20,600
  ...    (1000매 A=29,000 B=43,000 C=50,000 · 10000매 A=218,000…)
특수박 등급×수량(H31:K45) = 백박/홀로그램/트윙클: 200매 A=14,300 B=18,500 C=20,600 …
```

- 명함과 **권위 시트 공유**(후가공_박(소형))이나 명함은 완제품가로 collapse·042는 순수가공비 2D 보존 → **별 comp 유지**(완전 통일 아님·큐 §3 결론).
- 후가공_박(대형)도 동형(동판비 11,000~64,000·면적등급 30~170mm). 042가 소형/대형 어느 시트인지는 `[CONFIRM:WIRE-3b]`(§5).

### 4-3. 042 박 comp 신설 — 작업 단위 분해 (트랙 라우팅 명시)

| 작업 | 무엇 | t_* | DDL인가? | 트랙 |
|------|------|------|:--:|------|
| **(a) 박 comp 신설** | `COMP_FOIL_AREA_STD`(일반박)·`COMP_FOIL_AREA_SPECIAL`(특수박)·`COMP_FOIL_SETUP`(동판 5,000) | t_prc_price_components INSERT | **아니오**(데이터 INSERT) | round-16 |
| **(b) 단가행 적재** | 면적등급(A~E)×수량(200~10000) 단가 — 일반박/특수박 각 27행급 | t_prc_component_prices INSERT | **아니오**(데이터) | round-16 |
| **(c) 면적등급 차원** | 박 가로×세로→A~E 등급 매핑 보존처(C36-FOILSIZE) | 차원 컬럼/ref_param_json | **예(ALTER)** | **ddl-proposer** |
| **(d) ref_param_json** | 박 면적등급 손님입력 보존(GAP-PARAM 동반) | t_prd_product_option_items ADD COLUMN | **예(ALTER)** | **ddl-proposer** |
| **(e) PRF_DGP_A 배선** | (a) comp를 042 공식에 add-on 배선 | t_prc_formula_components INSERT | 아니오 | round-16 |

```sql
-- ============================================================
-- 042 박 공용 comp 신설 (큐 §3 ⓐ) — 개요(검토용·search-before-mint 후 확정)
-- comp 신설·단가행·배선 = 데이터 INSERT(round-16). 면적등급 차원·ref_param_json = ddl-proposer.
-- prc_typ_cd = Phase B(.03 신규) 결정 동조(미지정 보류).
-- ============================================================

-- (a) comp 신설 (prc_typ_cd는 Phase B 동조·잠정)
INSERT INTO t_prc_price_components (comp_cd, comp_nm, prc_typ_cd, use_dims, reg_dt)
VALUES
 ('COMP_FOIL_AREA_STD','순수 박가공비 일반박(면적등급x수량) [COMP_FOIL_AREA_STD]', /*Phase B*/ 'PRICE_TYPE.01', '["area_grade","min_qty"]', now()),
 ('COMP_FOIL_AREA_SPECIAL','순수 박가공비 특수박(백/홀로/트윙클) [COMP_FOIL_AREA_SPECIAL]', 'PRICE_TYPE.01', '["area_grade","min_qty"]', now()),
 ('COMP_FOIL_SETUP','박 동판셋업비(5000·수량무관) [COMP_FOIL_SETUP]', 'PRICE_TYPE.01', '[]', now())
ON CONFLICT (comp_cd) DO NOTHING;

-- (b) 단가행: 면적등급(area_grade A/B/C)×수량 — 후가공_박(소형) I/J/K 열 권위
--     ★ 면적등급 보존축이 component_prices에 없으면 (c) ddl 선행 필요.
--     예시(일반박 200매): area_grade=A→12200·B→15000·C→16400 …
INSERT INTO t_prc_component_prices (comp_cd, /*area_grade,*/ min_qty, unit_price, reg_dt)
VALUES
 ('COMP_FOIL_AREA_STD', /*'A',*/ 200, 12200, now()),
 ('COMP_FOIL_AREA_STD', /*'B',*/ 200, 15000, now())
 -- … 일반박 A/B/C × 200~10000 전수 + 특수박 H31:K45 전수
ON CONFLICT DO NOTHING;

-- (e) 042 배선 (add-on)
INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn, reg_dt)
SELECT 'PRF_DGP_A', v.comp_cd, v.disp_seq, 'Y', now()
FROM (VALUES ('COMP_FOIL_AREA_STD',30),('COMP_FOIL_AREA_SPECIAL',31),('COMP_FOIL_SETUP',32)) AS v(comp_cd,disp_seq)
WHERE NOT EXISTS (SELECT 1 FROM t_prc_formula_components fc WHERE fc.frm_cd='PRF_DGP_A' AND fc.comp_cd=v.comp_cd);
```

> **ddl-proposer 라우팅 필수**: (b) 단가행이 면적등급(area_grade)을 분기축으로 쓰려면 component_prices에 면적등급 보존 컬럼이 있어야 함. 라이브 component_prices에 area_grade 컬럼 부재 → **C36-FOILSIZE 차원 신설**(ddl-proposer). 동시에 손님 박 면적 입력 보존 = **GAP-PARAM(ref_param_json)** 동반. 박 가로×세로→A~E 등급 룩업표(가격표 A9:F12)는 별 매핑(앱 계산 or 차원행) — [[dbmap-compute-in-app-db-stores-lookup]] 원리상 면적→등급은 앱 계산 후보, DB는 등급별 단가만 보유 → ddl-proposer가 보존처 결정.

---

## 5. 재검증 게이트 (큐 §2-d·§3·폐루프) — 보정 하드코딩 0

각 케이스가 **라이브/제안 단가만으로** 재현돼야 RESOLVED. 가격사슬(공식→comp→단가행) 추적표.

| 케이스 | 입력 | 가격사슬(정정 후) | 기대값 | 현재(정정 전) |
|--------|------|------|:--:|------|
| **명함 C2** | 031 프리미엄·랑데뷰WH240(A군)·단면·100매 | PRF_NAMECARD_PREMIUM → COMP_PREMIUM_S1_MGA → min100=4,500 | **4,500** | 단절(PREMIUM 미배선·STD에 031소재 0개) |
| **명함 C3** | 032 코팅·아트300(082)·무광·100매 | PRF_NAMECARD_COAT → COMP_COAT_S1 mat082 → min100=**5,800** | **5,800** | STD로 떨어져 3,800(2,000 과소 오산) |
| **명함 C1b** | 033 스탠다드·스노우250(091)·단면·100매 | PRF_NAMECARD_FIXED → STD_S1 mat091(복제) → 3,500 | **3,500** | 키 부재 단절(091 없음) |
| **명함 C4** | 031 박·금유광·단면·200매 | PREMIUM 본체 + FOIL_S1_STD(200매=19,200) + SETUP(5,000) | 본체+**24,200**(박분) | 박 침묵 누락(FOIL 미배선) |
| **042 C3** | 042 박·금유광·면적A·200매 | PRF_DGP_A 합산 + COMP_FOIL_AREA_STD(A·200매=12,200) + SETUP(5,000) | +**17,200**(순수 박가공비) | 박 comp 부재(침묵 누락) |

- **C2/C3/C1b**: 라이브 단가행(4,500·5,800·3,500)이 이미 정확 → 배선/복제만으로 도달(하드코딩 0).
- **C4**: 명함 박=완제품가 19,200(라이브). ⚠ **F57="종이+동판+박가공비"라 동판이 명함 단가에 이미 포함됐을 수 있음** → 그 경우 SETUP(5,000) 별도 배선은 **동판 이중계상**(명함 C4=24,200 과대 가능). **명함 박 SETUP 별도 배선 여부 = 명함 박 단가표 구조 확정 후 결정(WIRE-3b 동반)**. 명함 본체와 박은 각각 완제품 항이라 종이 이중계상은 없음(동판만 쟁점).
- **042 C3**: 042 박=순수 가공비 12,200(가격표 후가공_박 소형 I10)+동판 5,000 → 17,200. 종이는 COMP_PAPER로 별도(이중계상 0·042 단가표는 순수 박가공비라 동판 별도가 정합). **명함 19,200(완제품) vs 042순수 12,200 차액 본질=종이분** → 재사용 불가 정량 입증(동판 귀속은 위 C4 주의 참조).

> **거짓 RESOLVED 금지**: 042 C3은 면적등급 차원(c)(d) 적재가 선행돼야 area_grade=A 룩업 도달. 차원 미적재 시 042 박은 **CONDITIONAL**(배선·comp는 되나 등급 분기 불가). C4(명함)는 등급 차원 불요라 배선만으로 RESOLVED 가능.

---

## 6. Phase B(D-1b)와 박 처리 경계 — 중복 금지 (명시)

| 항목 | Phase B(D-1b) | Phase C(WIRE·본 문서) |
|------|------|------|
| 박 comp prc_typ 메타(.01→.03 구간고정총액형) | **○ Phase B 전담**(CONFIRM:D1b-06 그룹② 박/완칼 .06/.05) | ✗ 다루지 않음(신설 comp는 .03 결정 동조·잠정) |
| 박 comp 배선(명함031 FOIL → 공식) | ✗ | **○ Phase C 전담**(§3) |
| 042 박 comp 신설 + 단가행 + 면적등급 차원 | ✗ | **○ Phase C 전담**(§4) |
| 명함종 comp 배선(PREMIUM/COAT) | ✗ | **○ Phase C 전담**(§1) |
| 033 MATGROUP 단가행 복제 | ✗ | **○ Phase C 전담**(§2) |

- **순서 의존**: 042 박 신설 comp의 prc_typ는 Phase B(.03 신규) 결정 후 확정. Phase C는 comp/배선/단가행을 준비하되 prc_typ는 잠정(.01)·Phase B 적용 시 동조 UPDATE. 메타·배선을 **동시 배포**해야 엔진 미정의 동작 회피(큐 §1-3 트레이드오프).
- 명함 박 comp(COMP_NAMECARD_FOIL_*)는 Phase B 그룹②에 이미 포함(prc_typ 정정 대상) — Phase C는 그 comp를 **배선만**(메타 안 건드림).

---

## 7. 트랙 라우팅 + 미해소 컨펌

### 7-1. 트랙 라우팅

| 작업 | 트랙 | 실 적용 |
|------|------|:--:|
| 명함종 comp 배선·박 배선·033 단가행 복제·042 박 comp 신설/단가행/배선 | **round-16** `dbm-price-import-builder` | 인간 승인 |
| 공식분리(PRF_NAMECARD_PREMIUM/COAT 신설) 최종 결정 | **round-2** `dbm-price-formula` | 인간 승인 |
| 042 박 면적등급 차원(C36-FOILSIZE)·ref_param_json(GAP-PARAM) | **dbm-ddl-proposer** | 인간 승인 |
| 박 comp prc_typ 메타(.03) | **Phase B / round-13** | 인간 승인 |

### 7-2. 미해소 컨펌 (정직 분리)

| 컨펌ID | 무엇 | 누가 | 상태 |
|--------|------|------|------|
| **WIRE-1** | 명함종 분기로직 ⓐ단일공식 vs **ⓑ공식분리(권고)** 최종 비준 | round-2 + 실무진 | 미해소(본 제안 ⓑ 가정) |
| **WIRE-3b** | 042 박이 후가공_박(소형) vs (대형) 어느 시트 권위인지(박 디자인 면적) | 실무진/디자인 | 미해소(소형 가정·쿠폰/상품권 박은 소형 로고급 추정) |
| **033 mat_cd 귀속** | 081/091/092 ↔ 소재명 | **해소**(라이브 t_mat_materials 실측 확정·§2-1·round-13 불요) | ✅ |
| GAP-2 | 042 면적등급 param 슬롯 위치(option_items.ref_param_json vs 신규) | ddl-proposer + 실무진 | 미해소(GAP-PARAM 동반) |

> **전부 실 적용 인간 승인.** 본 Phase C는 제안·심의·INSERT/UPDATE 제안문·DDL 개요까지(비파괴). 엔진(evaluate_price) 미구현·가격뷰어 비활성 = 실청구 위험 0 → 배선·신설을 큐에 적재하고 적용 시점은 인간 결정.
