# vessel-shape-axis (V-12, #17 형상 축) — GAP ❌ → 그릇 신설 설계

> rpm-vessel-designer. RP `Shape`(shape_info enum SQ/CL/EL/RC/FR·전용 슬롯·칼틀/사이즈 1:多 게이팅)를
> 후니가 표현할 **최소 convention-fit 그릇**. ★ST directive 1순위·16축 포화 붕괴(#17)·본 하네스 신규 vessel-gap.
> 권위 = 라이브 read-only information_schema 실측(2026-06-17·본 세션 직접 SELECT). design ≠ apply.
> **버전:** v5.0 (ST 신축). BN/GS/TP/PR 무관(직교 축·1:1 흡수 카테고리는 size 프리셋 유지).

## 0. 한 줄 평결
**#17 형상 축 = vessel-gap 확정**(라이브 3-레벨 실측: 형상 전용 컬럼 0건·테이블 0건·base_code 16그룹에 SHAPE enum 0건). 최소 그릇 = **`SHAPE` base_code 그룹 1 + `t_prd_products.shape_cd`(상품 형상·NULL) + `t_prd_product_sizes.shape_cd`(형상↔칼틀 게이팅·NULL)** — 컬럼 2개(서로 다른 카디널리티). **신규 테이블 mint = 0**(형상↔칼틀 1:多는 *기존 junction* `t_prd_product_sizes`에 `shape_cd` 분류 컬럼을 매다는 것으로 무손실 — 새 junction 테이블 불요). 형상=FR→자유칼선은 **V-1 `ref_param_json`(완칼 PROC_000053 `{"모양"}`)**·**V-4 RULE_TYPE.04(match)** 게이팅으로 연결(별 그릇 0). **★[HARD] 1:1 흡수 카테고리(BN/GS/TP/PR)는 `shape_cd` NULL 유지** — 형상축 전면 강제 금지(오모델 회피). `shape_cd`는 ST류 1:多 분리가 명시 슬롯으로 드러난 상품에만 의미.

## 1. search-before-mint (라이브 실측 — 결정적·3-레벨 + 정규화 논증)

### 1.1 후니 현황 (information_schema 직접 SELECT 2026-06-17 — 본 세션)
형상 그릇 부재를 3-레벨로 직접 실측:
```
-- (a) 형상 전용 컬럼: 전 t_* 검색 결과 = 0건 (false positive 1건만)
SELECT table_name, column_name FROM information_schema.columns
 WHERE table_name LIKE 't_%' AND (column_name ~* 'shape|outline|form_typ|die_cut|form_cd');
  → transforms.transform_type 1건(가격 변환 enum·형상 무관 false positive). 형상 컬럼 0.
-- (b) 형상 전용 테이블: 전역 'shape'/'form'/'outline' = 0건(price_formula·transforms false positive만).
-- (c) base_code 부모 그룹 16개(실측):
  CUS_GRADE·DSC_TYPE·MAT_TYPE·OPT_REF_DIM·OUTPUT_PAPER_TYPE·PRC_COMPONENT_TYPE·PRD_TYPE·
  PRICE_TYPE·QTY_UNIT·RULE_TYPE·SEL_TYPE·SEMI_ROLE·USAGE + TEST*3
  → SHAPE/형상 enum 그룹 부재. 형상 코드값(SQ/CL/EL/RC/FR)을 분류할 코드 도메인조차 없음.
```
`t_siz_sizes`(18컬럼 실측: `siz_cd·siz_nm·work_width/height·cut_width/height·margin_*·impos_yn·use_yn·note·tags jsonb`)는 **재단치수(width×height)** 슬롯이지 형상(원/사각) 분류 슬롯 *아님*. KB G-SK-2 "도형/치수 enum(원형 25~90mm)이 *어느 축에도 없음*"(`entity-semantic-model.md:39`)을 라이브가 컬럼/테이블/enum **3-레벨 전건 확증.** → 형상 = **vessel-gap 확정**(빈 테이블 아님·스키마가 축을 표현 못함).

### 1.2 기존 그릇으로 무손실 표현 불가 증명 (siz 흡수 = 정규화 붕괴)
형상을 기존 `t_siz_sizes` 행이 흡수할 수 있나? — **1:多 카디널리티가 거부:**

| RP 신호 | 의미 | 기존 그릇 환원? |
|---|---|:--:|
| `shape_info` enum(SQ/CL/EL/RC/FR) | 외곽 형상 분류 | ❌ **불가** — 코드 도메인 부재(base_code SHAPE 0). |
| 형상→칼틀 1:多 (CL → CL001~CL010 + CLFRE) | 한 형상이 다수 칼틀/사이즈 span | ❌ **불가·정규화 붕괴** — siz 행에 형상값을 매면 "원형"이라는 사실을 CL001~CL010 *매 칼틀 프리셋에 중복 인코딩*(이행종속 신설). |
| 5형상 superset 1상품 (STDCFBR=SQ/CL/EL/RC/FR 전부) | 한 상품이 N형상 보유 | ❌ **불가** — 형상=사이즈면 한 상품에 5사이즈군이 *형상 사실 없이* 평면 공존 → 형상이 어느 차원인지 소실. |
| 형상=FR → 자유칼선(THO_GRA) 강제 | 형상이 칼선 메커니즘 게이팅 | ❌ **불가** — 게이팅 분류자 슬롯 부재. |

**1:多가 핵심(결정적):** dbmap round-3는 형상을 "siz_cd 신설(사이즈 흡수)"로 닫으려 했다(`dbmap-round3-mapping-audit` "도무송 형상=siz_cd 신설 컨펌"). 그러나 ST 실측이 흡수의 *전제(형상=사이즈 프리셋 1:1)* 를 깬다: CL 형상 1개 ↔ CL001~CL100 칼틀 10+종 = **1:多**. siz 흡수 시 "원형"이 매 CL 프리셋 행에 반복 → `siz_cd → 형상`이 아니라 `siz_cd → (형상, 치수)` 이행종속이 자재 오염(MAT_TYPE.09 형상행)과 동형으로 재발생. → **siz 흡수 = 정규화 붕괴 = 무손실 표현 불가 = GAP 확정.** (dbmap siz 흡수 권고를 ST 1:多 증거가 정정·정밀화 — §4)

### 1.3 사다리 검토 (코드행 < 컬럼 < JSONB < 테이블)
| 후보 | 충분? | 판정 |
|---|:--:|---|
| **① base_code `SHAPE` enum만**(형상 분류) | △ | 형상 *값 도메인*은 코드행으로 잡으나, *어느 상품/칼틀이 어느 형상인가*(인스턴스 연결)를 코드행이 못 함 → 컬럼 필요. **필요조건이나 불충분**(design-input-channel·form-assembly 동형 논리). |
| **②a `t_prd_products.shape_cd`**(상품 형상) | ✅(상품 1형상) | 상품분기형(원형=STTHCIC·타원=STTHELP)은 *상품당 단일 형상* → 상품 컬럼이 정규 슬롯. NULL=형상축 비적용(1:1 흡수 카테고리). **채택.** |
| **②b `t_prd_product_sizes.shape_cd`**(형상↔칼틀 게이팅) | ✅(1:多) | 형상↔칼틀 1:多(CL→CL001~100)·5형상 superset(STDCFBR=한 상품 N형상)을 *기존 prd×siz junction 행에 형상 분류 컬럼*으로 매면 무손실. 각 (prd_cd,siz_cd) 칼틀 프리셋 행이 자기 형상을 1값 보유 → "원형 사실" 중복 없이 칼틀별 형상 게이팅. **채택.** |
| **③ JSONB**(`shape_json`) | ✗ | 형상이 *정형·열거형*(enum FK 거버넌스·필터/조인 대상)이라 jsonb는 enum 무결성·조인 상실. 후니 jsonb 관용(logic·prcs_dtl_opt)은 *가변 파라미터*용. **부적격.** (단 `t_siz_sizes.tags jsonb`가 거의 빈 슬롯이나 — 형상은 분류축이라 코드/컬럼이 컨벤션·tags는 비정형 보조) |
| **④ 신규 테이블**(`t_prd_product_shapes` 또는 형상→칼틀 매핑 테이블) | ✗ | 형상↔칼틀 1:多는 **이미 `t_prd_product_sizes`(prd×siz junction)가 존재** — 그 행에 `shape_cd` 분류 컬럼을 매는 것으로 1:多가 무손실 표현됨(새 junction 불요). 별 형상→칼틀 매핑 테이블 신설 시 prd_product_sizes와 *중복 junction*(같은 prd×siz 쌍 이중관리). **over-modeling·mint 거부.** |

**결론:** 사다리 = **① base_code `SHAPE` 그룹 1 + ②a 상품 컬럼 1 + ②b junction 컬럼 1**(②에서 멈춤). **신규 테이블 0.** TP V-11(TemplateAsset 시안 1:N·독립 lifecycle·완제SKU 이중의미 → 테이블 mint 정당)과 달리, 형상↔칼틀 1:多는 *기존 junction이 이미 그 쌍을 담고 있어* 컬럼이 무손실 — **카디널리티가 1:多여도 junction이 선재하면 테이블 mint 불요**(사다리 정밀 판정).

## 2. 그릇 설계 (최소 — 코드행 1그룹 + 컬럼 2)

### 2.1 형상 enum 축 — `t_cod_base_codes` 신규 그룹 `SHAPE` (코드행, 사다리 최저단)
RedPrinting *모델*만 흡수, *naming/codes*는 후니 컨벤션 코드로(shape_info COD → SHAPE.NN). 라이브 코드그룹 컨벤션(부모 `upr_cod_cd=NULL` + 자식 `<GROUP>.NN`·disp_seq·`reg_dt NOT NULL`) 그대로.
```sql
INSERT INTO t_cod_base_codes (cod_cd, cod_nm, upr_cod_cd, disp_seq, use_yn, del_yn, reg_dt) VALUES
 ('SHAPE',    '형상',        NULL,    1, 'Y','N', now()),
 ('SHAPE.01', '사각형',      'SHAPE', 1, 'Y','N', now()),  -- SQ (STCUXXX 사각반칼)
 ('SHAPE.02', '원형',        'SHAPE', 2, 'Y','N', now()),  -- CL (STTHCIC·칼틀 CL001~)
 ('SHAPE.03', '타원형',      'SHAPE', 3, 'Y','N', now()),  -- EL (STTHELP)
 ('SHAPE.04', '사각라운드형','SHAPE', 4, 'Y','N', now()),  -- RC (STTHSQU·칼틀 RC001~)
 ('SHAPE.05', '자유형',      'SHAPE', 5, 'Y','N', now());  -- FR (STTHUSR·자유칼선 강제)
```
- search-before-mint: 형상 분류 코드 도메인 자체가 부재(16그룹에 SHAPE 없음·§1.1 (c)) → enum 신설은 **명백**. RedPrinting `shape_info` COD(SQ/CL/EL/RC/FR)를 후니 코드로 흡수(naming 유입 금지).

### 2.2 형상 매다는 슬롯 — 컬럼 2개 (ADD COLUMN NULL·서로 다른 카디널리티)
```sql
-- ②a 상품 형상(상품분기형·1상품 1형상): 원형 스티커·타원형 스티커 등
ALTER TABLE t_prd_products ADD COLUMN shape_cd varchar NULL;  -- → SHAPE.* (NULL=형상축 비적용·1:1 흡수 카테고리)
-- FK → t_cod_base_codes(cod_cd).

-- ②b 형상↔칼틀 게이팅(1:多·5형상 superset): 한 상품의 각 칼틀 프리셋 행이 자기 형상 보유
ALTER TABLE t_prd_product_sizes ADD COLUMN shape_cd varchar NULL;  -- → SHAPE.* (NULL=형상 무관 사이즈)
-- FK → t_cod_base_codes(cod_cd).
```
- **②a vs ②b 분담(정규화 핵심):**
  - **②a(상품 컬럼):** 상품 전체가 단일 형상(원형 스티커=상품=원형). 상품분기형 인코딩. 5형상 superset 상품(STDCFBR)은 ②a NULL(상품 형상 미고정)·②b가 칼틀별 형상 보유.
  - **②b(junction 컬럼):** 형상↔칼틀 1:多의 게이팅. CL 형상 → (prd×CL001),(prd×CL002)… 각 행 `shape_cd=SHAPE.02`. STDCFBR 5형상 → 칼틀 프리셋 행들이 각자 SQ/CL/EL/RC/FR 보유. **"원형 사실"이 각 칼틀 행에 1값(중복 아닌 게이팅 분류)** — siz_sizes 마스터(497행 공유 칼틀)에 매면 중복이나, *상품별 junction*(prd_product_sizes)에 매면 그 상품-칼틀 쌍의 형상이라 무손실.
- ★`shape_cd` 둘 다 **NULL 허용 필수**: 1:1 흡수 카테고리(BN 어깨띠·GS 하트·TP 티켓·PR 카드형)는 형상을 사이즈 프리셋 1:1로 충분히 표현 → `shape_cd` NULL(형상축 비적용). NOT NULL 강제 금지(전 상품 형상 강제 = 오모델).

### 2.3 형상→칼선 게이팅 — 기존 그릇 연결(별 그릇 0)
형상은 단독 enum이 아니라 **칼선/사이즈/사이즈입력모드를 게이팅하는 관계 그릇**. 게이팅 간선은 전부 기존 V-항목으로 연결:
- **형상=FR(SHAPE.05) → 자유칼선:** 라이브 칼선 공정은 완칼 `PROC_000053`·반칼 `PROC_000054`·스티커완칼 `PROC_000055`만 존재(실측)·자유칼선(도무송) 전용 row 부재. FR은 **완칼(PROC_000053) + `{"모양": ...}` 파라미터**로 환원 — `PROC_000053.prcs_dtl_opt = {"inputs":[{"key":"모양","type":"string"}]}`(라이브 실측). 그 `모양` 선택값을 적는 칸 = **V-1 `t_prd_product_option_items.ref_param_json`**(공정파라미터 그릇·`{"모양":"FRXXX"}`). → 형상→칼선은 V-1이 받음(별 그릇 0·V-1·V-12 함께 설계).
- **형상=SQ/CL/RC → 프리셋칼틀:** ②b junction `shape_cd`가 그 상품의 칼틀 프리셋(=사이즈 행)을 형상별로 분류 → 형상이 칼틀 부분집합 게이팅(CL→CL001~). 사이즈축(#13·기존 PASS)이 칼틀=사이즈 행 보유, 형상은 그 위 분류자.
- **형상→사이즈 입력모드:** 자유형(FR)=자유사이즈(nonspec — `t_prd_products.nonspec_*_min/max` 기존 그릇·GS 실측 실재), 정형=프리셋 enum(사이즈 행). 게이팅 규칙 = **V-4 RULE_TYPE.04(match)** `logic jsonb`로 거버넌스(별 그릇 0): `{"if":[{"==":[{"var":"형상"},"SHAPE.05"]},{"require":["칼선:완칼","사이즈모드:자유"]}]}`.

## 3. 정규화 / 영향분석

### 3.1 정규화
- **무손실:** 형상 분류=SHAPE 코드·상품 형상=`t_prd_products.shape_cd`·형상↔칼틀 1:多=`t_prd_product_sizes.shape_cd`·FR→자유칼선=V-1 ref_param_json `{"모양"}`·입력모드 게이팅=V-4 match logic. RP 형상 4 의미축(enum·1:多 칼틀·5형상 superset·칼선 게이팅)이 각기 다른 정규 슬롯에(siz 흡수 평면화 해소).
- **무중복:** SHAPE 코드=분류 메타·`shape_cd`=인스턴스값. 상품 형상(②a)≠칼틀별 형상(②b)은 서로 다른 카디널리티의 다른 함수종속(상품 단일형상 vs 칼틀별 게이팅) — 의미 중복 아님. 5형상 superset 상품은 ②a NULL·②b가 권위(이중저장 없음).
- **함수종속:** `prd_cd → shape_cd`(②a 상품 단일형상·NULL 가능)·`(prd_cd,siz_cd) → shape_cd`(②b 칼틀별 형상·완전종속) — 부분/이행종속 신설 0. **★siz_sizes 마스터에 형상을 안 매는 이유(정규화 결정):** `t_siz_sizes`(497행 공유 칼틀)에 매면 `siz_cd → 형상` 이행종속이 같은 칼틀을 쓰는 다른 형상 상품과 충돌(과분할/오염). prd×siz junction에 매야 *그 상품-칼틀 쌍 한정* 형상이라 무손실.

### 3.2 영향 (기존 행·FK·백필·적용순서·롤백)
- **기존 행:** 컬럼 2개 전부 **ADD COLUMN NULL** = 백필 0·무잠금(PG 메타데이터 변경·full rewrite 없음). 라이브 `t_prd_products` 275상품·`t_prd_product_sizes` 전 행 **무파손**(NULL 부여만).
- **FK:** 신규 FK 2(`t_prd_products.shape_cd`·`t_prd_product_sizes.shape_cd` → `t_cod_base_codes.cod_cd`). 부모(SHAPE 코드행) 선존재 → 고아 0.
- **백필(data·dbmap 트랙):** ST 36상품에 형상 부여 — 상품분기형(원형 STTHCIC→②a SHAPE.02·타원 STTHELP→.03·사각라운드 STTHSQU→.04·사각반칼 STCUXXX→.01·자유형 STTHUSR→.05)은 ②a, 5형상 superset(STDCFBR)·칼틀 enum 깊은 상품(CL001~·RC001~)은 ②b. **★1:1 흡수 카테고리(BN/GS/TP/PR)는 백필 0(shape_cd NULL 유지)** — 형상축 전면 강제 금지(오모델 회피). → 백필 자체는 vessel 아님(dbmap round-6/ST 적재 트랙).
- **적용 순서:**
  1. step -1: base_code `SHAPE` 그룹 6코드행(선적재·후니 승인)
  2. step 0: 본 DDL(ALTER ADD COLUMN ×2 + FK ×2) ← 인간 승인 후
  3. step 1: 백필 UPDATE(ST 형상·dbmap 적재 트랙) + V-1 ref_param_json `{"모양"}`(자유형) 연동
- **롤백:** `DROP COLUMN ×2`(백필값 백업 권고·NULL이면 손실 0) + SHAPE 코드행 use_yn='N'. 무위험(NULL 컬럼·기존 행 무영향).
- **★게이팅 의존(HARD):** V-12는 단독 완결 아님 — 형상=FR→자유칼선은 **V-1(ref_param_json·완칼 `{"모양"}`) 선행/병행** 필요. 입력모드 게이팅은 V-4 RULE_TYPE.04(코드행·경량). V-1·V-4·#13(사이즈 PASS)과 연동 설계(로드맵 FK 위상 §아래).

## 4. dbmap 정합 — round-3 G-SK-2 "siz_cd 흡수" 권고 정정(충돌 아닌 정밀화)
- **dbmap 진단(권위 보존):** `entity-semantic-model.md:39` G-SK-2 "size축에 형상 enum drop·어느 축에도 없음" = **결함 명시**(정확). 본 V-12는 이 진단을 *부정하지 않고 그릇으로 닫는다.*
- **dbmap 권고(round-3) 정정 근거:** round-3 "도무송 형상=siz_cd 신설 컨펌"(`dbmap-round3-mapping-audit`)은 형상을 *사이즈 행 흡수*(siz_cd 신설)로 닫으려 했다. 그 전제 = **형상=사이즈 프리셋 1:1**. ST 실측이 1:多(CL→CL001~100·5형상 superset)를 입증 → siz 흡수 시 "원형"이 매 칼틀 프리셋에 중복 인코딩(정규화 붕괴·§1.2). → **형상 *전용* enum + junction 게이팅이 정답**(siz 흡수 권고를 1:多 증거가 정정).
- **★충돌 아님·정밀화:** dbmap이 형상을 "어느 축에도 없음"으로 *결함만 명시*하고 그릇은 미신설(siz 흡수는 1:1 가정 권고). V-12는 그 진단 위에 **1:多 카디널리티를 반영한 정밀 그릇**(SHAPE enum·prd×siz junction `shape_cd`)을 제안 = 재발견/중복 아닌 **신규 vessel-gap 정밀화.** dbmap round-3의 siz_cd 흡수가 ST에 적용되면 형상 오염을 낳음 → V-12가 그 적용을 *전용 그릇으로 대체*(1:1 흡수 카테고리는 siz 유지 여전히 정당·형상축 비적용).

## 5. 닫는 것 (GAP → PASS) + 적용 경계 [HARD]
- #17 형상 축: gap-matrix **GAP** → 본 그릇으로 **PASS**. RP `shape_info`(전용 슬롯·1:多 칼틀 게이팅·5형상 superset·FR→자유칼선 강제)를 후니 코드행(SHAPE)+컬럼 2(상품/junction)+게이팅(V-1·V-4)로 무손실 흡수.
- **unblock:** ST 36상품(자유형·사각반칼·원형·타원·라운드·5형상 데코·점착특화) + 도무송/모양재단 보유 상품(굿즈 칼틀·실사 족자 PROC_082 `모양enum`). 형상→칼선 게이팅이 V-1(공정파라미터)·#13(사이즈)을 잇는 분류자 = 옵션 캐스케이드 완성.
- **★[HARD] 적용 경계(오모델 회피):** 형상축은 **1:多 분리가 명시 슬롯으로 드러나는 ST류에만.** 1:1 흡수 카테고리는 `shape_cd` NULL 유지·사이즈 프리셋이 형상 암묵 보유:
  - **BN 어깨띠**(폭좁고 긴 형상=사이즈 프리셋 1:1·A-3) → `shape_cd` NULL·size 유지.
  - **GS 하트/여권**(THO_CUT 칼틀↔사이즈 1:1) → `shape_cd` NULL·size 유지.
  - **TP 티켓 M/I/보딩**(형태 variant=사이즈/칼틀 1:1·T-D) → `shape_cd` NULL·size 유지.
  - **PR 카드형**(형상=사이즈 1:1) → `shape_cd` NULL·size 유지.
  - → 이전 BN/GS/TP/PR 흡수 판정 **번복 안 함**(그들은 진짜 1:1·사이즈 흡수 정당). ST만 1:多가 전용 슬롯으로 드러나 distinct 승격. **형상축 전면 강제 = 오모델 회피([HARD] directive·gap-matrix XIII-1).**

## 6. open decision (날조 금지·인간 결정)
1. **②a 상품 형상 vs ②b junction 형상 중복 운영:** 상품분기형(원형 스티커)은 ②a만으로 충분(칼틀이 1형상)·5형상 superset(STDCFBR)은 ②b만(②a NULL). 둘 다 보유 상품(원형인데 CL001~ 칼틀 다수)은 ②a=SHAPE.02 + ②b=각 SHAPE.02 일관 — *파생 일관(중복 아님)*. 두 컬럼 동시 운영 정합 규칙 = `t_prd_products.shape_cd NOT NULL ⇒ 그 상품 prd_product_sizes.shape_cd ∈ {NULL, 동일값}`(앱/V-4 essential 검증). 후니가 ②a/②b 중 하나로 단순화할지(상품분기형만이면 ②a·옵션형만이면 ②b)는 ST 적재 실측 후 판정.
2. **타원형(EL·SHAPE.03) 칼틀 enum:** 원형(CL001~010)·라운드(RC001~025)는 reverse 실측·EL 프리셋 사이즈 목록 unobserved(동형 추정). 칼틀 행 *데이터*는 dbmap 적재 트랙(그릇은 ②b로 충분·EL 코드행만 선존재).
3. **자유칼선 전용 process row 신설 여부:** 라이브 칼선=완칼/반칼/스티커완칼 3행만·자유칼선(도무송) 전용 row 부재. FR은 완칼(PROC_000053)+`{"모양"}` 파라미터로 환원(V-1)이 현 설계. 후니가 자유칼선을 *별 공정 행*으로 운영할지는 공정 마스터 정책(dbmap·heat-cut-process-proposal 동류) — vessel 범위 밖(형상축은 게이팅만, 칼선 행 신설은 공정 트랙).
4. **`shape_cd` 컬럼명/타입:** `varchar NULL`(라이브 코드 참조 컬럼 컨벤션·`design_input_channel_cd`·`mat_facet_cd` 동형). FK 대상=`t_cod_base_codes.cod_cd`. reg_dt 트랩 무관(컬럼 추가만).
5. 실 적용 = 인간 승인 + dbmap 적재 트랙.

## 7. DDL 위임
- 코드행(`SHAPE` 6코드) + ALTER(ADD COLUMN ×2·FK ×2) 정밀 forward/rollback SQL = **`dbm-ddl-proposer`**(코드그룹 패턴 + `ref-param-json-proposal`/`ddl-proposal-design-input-channel` ADD COLUMN NULL+FK 동형 재사용). 본 문서 §2가 설계 권위(which/why), 정밀 SQL = `ddl-proposal-shape-axis.sql`(11_ddl_proposals/) 인용.
- ★reg_dt NOT NULL DEFAULT now() 트랩 준수(라이브 `t_cod_base_codes`·`t_prd_products`·`t_prd_product_sizes` reg_dt NOT NULL — INSERT/코드행 시 명시 또는 DEFAULT). round-5 교훈 반영.
- 라이브 DRY-RUN(BEGIN..ROLLBACK)으로 ALTER ×2+FK ×2+코드행 6 유효성·FK 무결성·0 leaked 실증 권고(V-10/V-11 동형).
