# Wave A-2 적재 설계 독립 검증 — sticker · product-accessory (round-3 remediation 전수 확장)

> **작성** 2026-06-05 · dbm-validator(독립 적대적 검증) · 설명 한국어, 식별자/테이블/컬럼/코드/SQL 영어.
> **검증 대상:** `09_load/sticker/` · `09_load/product-accessory/` (load-spec.md · load/*.csv · _deferred · sticker `_blocked/` · verify_expected.py · expected-vs-load.md).
> **검증자는 설계자가 아님** — 본 산출물을 작성하지 않았다. 기본 입장 = 회의(결함 입증 책임은 검증자에게).
> **권위 순서(HARD):** 라이브 DB > `08_remediation/{sticker,product-accessory}.md` 기록 라이브결과 > ref-*.csv(stale 2026-06-04). 엑셀 L1 > 정규화.
> **DB 쓰기 0** — 읽기전용 SELECT 1회(배치)만 수행. password 미노출.
> **방법론:** `03_validation/dp-load-validation.md`(digital-print 파일럿) 동일 엄격성 — 게이트 재실행 + 독립 재산출 + 적재성 DRY-RUN + 적대적 재판정 + 라이브 중복-PK.

---

## 0. 최종 판정 요약

| 시트 | 판정 | 게이트 | 독립 재산출 | 적재성 DRY-RUN | 라이브 중복-PK | UPHELD/OVERTURNED |
|------|------|--------|------------|---------------|---------------|-------------------|
| **sticker** | **GO-WITH-FINDINGS** | PASS (6/6, exit 0) | 일치(active 3·def 1·qty 16) | PASS (process·qtyunit) | 0 (라이브 직접확인) | UPHELD 6 / **OVERTURNED 0** (BLOCKED 1건 UPHELD, 단 사유 정밀화 권고) |
| **product-accessory** | **GO-WITH-FINDINGS** | PASS (4/4, exit 0) | 일치(qty 15·size7·mat8 커버15) | PASS (qtyunit) | 0 (라이브 직접확인) | UPHELD 5 / **OVERTURNED 0** (대조군 합리화 **없음** — 분기·process부재 실증) |

- **NO-GO 블로커: 없음.** 양 시트 모두 적재성(type·NULL·FK·PK) 전 항목 통과, 라이브 중복충돌 0.
- **dodge/합리화 적발: 0건.** product-accessory의 "정합 양호=적재 거의 없음=정상" 주장은 **진짜 대조군**임을 라이브+L1+ref 삼중으로 실증(분기 0 mismatch·uncovered 0). 회피용 MISSING 강등 **아님**.
- **공통 HARD 조건:** 적재 직전 동일 `verify_expected.py`를 라이브 export 기반으로 1회 재실행(stale 격차 닫기) — 파일럿과 동일. 단 본 검증이 라이브 SELECT로 핵심 stale 지점을 이미 닫음(§4).

---

## 1. 게이트 재실행 + 독립 재산출

### 1-1. sticker 게이트 byte-identical 재현 — PASS
```
=== SELF-CHECK (sticker) ===
R1-whitespot-active        3   3  0  0  PASS
R6-qtyunit                16  16  0  0  PASS
deferred=use_yn:N          1   1  0  0  PASS
R1-whitespot-deferred      1   1  0  0  PASS
FK+active-guard            -   -  -  0  PASS
R2-size-blocked(no-load)   0   0  0  0  PASS
GATE: PASS — 누락0·날조0·비활성분리·마스터부재차단   (exit 0)
```

### 1-2. sticker 화이트별색 active=3·deferred=1 독립 재산출 (생성기 미신뢰, L1 재판독)
검증자가 `sticker-l1.csv`의 `별색인쇄(옵션)_화이트` 컬럼을 직접 재스캔 — 신호(`값≠'없음' && '없음' not in 값`) 보유 상품:

| prd_cd | 상품 | 화이트 L1 값 | use_yn | 분류 |
|--------|------|-------------|:------:|------|
| 053 반칼 자유형 투명스티커 | 투명 PET | `화이트인쇄(단면)` | Y | **active** |
| 054 반칼 자유형 홀로그램스티커 | 홀로그램 | `화이트인쇄(단면)` | Y | **active** |
| 056 낱장 자유형 투명스티커 | 투명전용지 | `화이트인쇄(단면)` | Y | **active** |
| 063 반칼팬시투명스티커 | 투명 | `화이트인쇄(단면)` + `화이트인쇄(없음)` 혼재 | **N** | **deferred** |

→ **active 3 (053·054·056) / deferred 1 (063)** — 설계자 산출과 **차이 0**. 052·055·057·058~062·064~067 화이트 컬럼 공백 → 비대상(false 생성 0). 063 혼재값(단면+없음)도 신호 보유 자체는 확정 — 설계 판단 정합.

### 1-3. product-accessory 게이트 byte-identical 재현 — PASS
```
=== SELF-CHECK (product-accessory) ===
R3-qtyunit(EA)               15  15  0  0  PASS
FK/typ-existence              -   -  -  0  PASS
INV size+material 커버15      15  15  0  0  PASS
INV process/addon/disc/plate 미적재=정상  -  0  -  0  PASS
GATE: PASS — 누락0·날조0 (대조군: 적재 적음=정상)   (exit 0)
```

### 1-4. PA qtyunit=15·size7/material8 커버15 독립 재산출
- qty_unit: PA 15상품(PRD_000001~015) 전건 → 적재 15행, 전부 target=QTY_UNIT.01. **15=15.**
- size/material 분기 재집계(ref): **size 7상품(38행) · material 8상품(29행) · overlap 0 · uncovered 0**. 15상품 상호배타 완전커버 독립 확인. (상품별: size={001:11,002:11,003:8,004:2,005:2,009:3,011:1}, material={006:8,007:3,008:1,010:3,012:1,013:3,014:3,015:7}.)

→ **양 시트 독립 재산출 모두 설계자와 일치. 생성기 산출을 신뢰하지 않는 독립 경로에서 검증됨.**

---

## 2. 적재성 DRY-RUN (정적, columns.csv + ref + 라이브)

> ⚠️ **검증 입력 주의:** `00_schema/columns.csv`에 `t_prd_product_processes`(7컬럼)·`t_prd_products`(21컬럼)·`t_prd_product_bundle_qtys`(7컬럼)는 수록되어 있으나 **`t_prd_product_sizes`는 0컬럼(부재)**. sticker BLOCKED CSV가 `t_prd_product_sizes`를 적재하지 않으므로 본 패스 적재성에 영향 없음. (파일럿이 권고한 "columns.csv 링크테이블 메타 보강" — `t_prd_product_sizes` 추가 권고 유효.)

### 2-1. sticker

| 테이블 | type/length fit | NOT NULL | FK 실재 | PK-dup(in-CSV) | PK-collision(라이브) | 판정 |
|--------|:---------------:|:--------:|:-------:|:--------------:|:-------------------:|:----:|
| `t_prd_product_processes` (3행, INSERT) | OK (mand_proc_yn='N' char(1)·disp_seq=2 int·proc_cd varchar50) | OK (prd_cd·proc_cd·mand_proc_yn·reg_dt 채움) | OK (PROC_000008→t_proc 실재[라이브 G]·053/054/056→t_prd_products 실재) | 0 (3 distinct prd_cd, proc 동일) | **0 (라이브 A: 053/054/056 PROC_000008=0행)** | **OK** |
| `t_prd_products_qtyunit_update` (16행, UPDATE) | OK (QTY_UNIT.02='매' 실재 ref-base-codes:40) | n/a (UPDATE) | OK (16상품 PRD_000052~067 전부 실재) | n/a | n/a (NULL→값, 라이브 C: 16/16 NULL) | **OK** |
| `_blocked/...066_circle` (11행) | (적재 대상 아님 — siz_cd=`(MINT_NEEDED)` 의사키) | — | — | — | — | **적재 비대상(정상)** |
| `_deferred/...processes` (1행, 063) | — | — | — | — | — | **보류(use_yn=N)** |

- **PK 정의:** `t_prd_product_processes` PK=(prd_cd, proc_cd). 적재 3행 = (053·054·056, PROC_000008) 전부 라이브 부재 → INSERT 안전. 기존 커팅(053/054 PROC_000054@seq1, 056 PROC_000053@seq1)과 proc_cd 상이 → 충돌 0.
- **부가:** mand_proc_yn∈{Y,N} CHECK 충족(N), disp_seq=2 기존 seq1과 의미 충돌 없음, reg_dt 채움(NOT NULL).

### 2-2. product-accessory

| 테이블 | type/length fit | NOT NULL | FK 실재 | PK-dup | PK-collision(라이브) | 판정 |
|--------|:---------------:|:--------:|:-------:|:------:|:-------------------:|:----:|
| `t_prd_products_qtyunit_update` (15행, UPDATE) | OK (QTY_UNIT.01='EA' 실재 ref-base-codes:39) | n/a (UPDATE) | OK (15상품 PRD_000001~015 전부 PRD_TYPE.03 실재) | n/a | n/a (NULL→값, 라이브 D: 15/15 NULL) | **OK** |
| `_deferred/...bundle_qtys` (9행) | (적재 대상 아님) | — | — | — | — | **보류(정책 미확정)** |

- **INSERT 적재 테이블 0개.** 유일 변경 = qty_unit UPDATE 15행. size/material/process/addon/bundle 변경 0.
- **bundle 보류 스키마 정당성 확인:** `t_prd_product_bundle_qtys` PK=prd_cd 단일·bdl_qty NOT NULL int. 트래싱지(003) 다중장수[20/30/40/100]는 단일행 모델로 대표값 미정 → DEFERRED는 **스키마 제약상 강제됨**(임의선택=발명). 라이브(F)=OPP 001/002만 bdl_qty=50 → deferred CSV의 001/002 skip 사유 정합.

→ **양 시트 적재성 위반 0. NO-GO 블로커 없음.**

---

## 3. 적대적 재판정 (under-load 의심 우선)

### 3-A. product-accessory (대조군) — 합리화 의혹 검증: **합리화 없음, UPHELD 5**

설계자 주장 = "정합 양호=적재 거의 없음=정상". **진짜 대조군인가, MISSING을 회피한 합리화인가?** 라이브+L1+ref 삼중 대조:

#### 쟁점 ①: G-PA-1 size↔material 분기 정합 — **UPHELD (실증, 합리화 아님)**
- **검증자 L1 직접 대조(`product-accessory-l1.csv` `사이즈(필수)` 셀 전수):**
  - size 적재 7상품 = **전부 치수문자열**(001 `70x200mm(50장)`, 009 `PP투명케이스 42x57x20mm(10개)`, 011 `20x20(20개입)` 등).
  - material 적재 8상품 = **전부 variant 문자열**(006 `오렌지(3개1팩)`, 007 `실버`, 015 `청보라(5cc)`, 013 `270mm+면끈`).
  - **분기 mismatch = 0건.** size성↔material성이 L1 셀과 1:1 정합.
- **판정:** 분기는 엑셀 의도대로 정확 적재됨이 L1 셀 레벨에서 실증. **합리화가 아니라 사실.** UPHELD.

#### 쟁점 ②: G-PA-4 process 부재 = 정상 — **UPHELD**
- **근거:** PA L1 컬럼 = `구분/ID/MES/상품명/사이즈(필수)/수량(최소·최대·증가)/가격`뿐. **인쇄옵션·별색·공정·코팅 컬럼 자체가 원천 부재**(L1 헤더 직접 확인). process 0행은 결함 아닌 원천 정상. digital-print(공정 26행 적재)와 결함 축 정반대 — 시트별 편차 정상.
- **판정:** UPHELD. 없는 공정 컬럼에 기대행 생성 시 거짓 MISSING — 회피가 옳음.

#### 쟁점 ③: uncovered(size·material 둘다0) 진짜 MISSING 존재 여부 — **UPHELD**
- **검증자 재집계:** PA 15상품 중 size∪material 미커버 = **0상품**. 진짜 완전누락 없음. 008 천정고리(use_yn=N)도 material 1행 보유 → 데이터 보존.
- **판정:** UPHELD. 숨겨진 under-load 없음.

#### 쟁점 ④: qty_unit 단위 선정(EA) 정당성 — **UPHELD (단 D-PA-1 컨펌 유효)**
- **검증:** QTY_UNIT.01=EA(ref-base-codes:39) 실재. 부자재 자연단위 혼재(봉투 장/매·볼체인 개·잉크 cc) → 단일 상품군 기본단위 EA가 포괄적. 발명 회피 위해 봉투 '매' 세분은 CONFIRM(D-PA-1)로 분리 — 정당.
- **잔여:** 봉투류(001~005)는 '매/장'(QTY_UNIT.02)이 자연스러울 수 있음 → D-PA-1 실무 컨펌 권장(위젯 입도). **적재 차단 아님**(컬럼 UPDATE라 후속 변경 무해).

#### 쟁점 ⑤: bundle DEFERRED 9 — **UPHELD**
- **검증:** PK=prd_cd 단일행이 스키마 강제(columns.csv 확인). 다중장수 003·002는 대표값 미정 → 발명 금지로 보류 정당. 라이브 기적재(001/002) skip 정합.

> **대조군 평결:** product-accessory의 저-적재는 **회피가 아니라 라이브 정합도가 실제로 높은 결과**다. 분기 0 mismatch·uncovered 0·process 컬럼 원천부재를 L1/ref/라이브 삼중 실증. **dodge/rationalization 적발 0건. UPHELD 5 / OVERTURNED 0.**

### 3-B. sticker — BLOCKED 정당성 + active 정확성: **UPHELD 6 (BLOCKED 사유 정밀화 권고)**

#### 쟁점 ①: 066 원형 11종 `_blocked/` (master 부재→no-load) — **BLOCKED 결정 UPHELD, 단 사유 정밀화**
- **설계자 주장:** master `t_siz_sizes`에 합판도무송 원형 size_cd 부재(circle 6종 무매치) → 11행 BLOCKED.
- **검증자 라이브+ref 교차 대조(중요 — 설계자 사유보다 정밀):**
  - **(a) 라이브(E): `066 size like '%원형%'` = 0행** → 066에 원형 size 전무 확정. 드롭 사실 라이브 입증.
  - **(b) ref-sizes에 원형 master는 6종 *존재*한다**: SIZ_000355(100x100mm원형)·369(68x70mm원형)·419(원형13x13)·420(19x19)·421(24x24)·**422(원형35x35)**. → 설계자의 "circle 6종 무매치"는 **"무매치"가 아니라 "EA-규약·치수 불일치"가 정확한 사유.**
  - **(c) 066 needed 원형 = 10/15/20/25/30/35/40/45/50/55/60mm 11종.** 이 중 **치수 일치는 35mm 단 1종(SIZ_000422)뿐**, 나머지 10종(10·15·20·25·30·40·45·50·55·60)은 master 치수 자체가 부재.
  - **(d) 결정적 — 규약 불일치:** 066의 기적재 size는 `정사각35x35mm(2EA)` 형식(siz_nm에 **판당 EA수 내포**, SIZ_000217). 그러나 master SIZ_000422 `원형35x35`는 EA수 미포함이고 **PRD_000217이 사용 중**(타 상품 전용). 066에 SIZ_000422를 link하면 `(2EA)` 임포지션 메타가 누락된 size가 매달림 → 066 size 규약 위반.
- **판정:** **BLOCKED UPHELD.** 11종 모두 새 mint가 타당(35mm조차 EA-규약·사용처가 달라 재사용 부적). 단 **설계자 사유 "circle 6종 무매치"는 부정확** → 정정 권고: *"원형 master 6종 존재하나 (i) 치수 11종 중 35mm 외 무존재, (ii) 존재하는 35mm도 EA수 미포함·타상품(PRD_000217) 전용이라 066 규약(`(NEA)` 임포지션 내포) 위반 → 11종 신규 mint 필요"*. 이 정밀화 없이는 "35mm는 SIZ_000422로 link 가능"이란 반론에 무방비. **결론(11행 no-load)은 정당, 근거 문구만 보강.**

#### 쟁점 ②: 화이트별색 active 3 (over/under 아님) — **UPHELD**
- **검증:** L1 신호 보유 = 053·054·056(Y)+063(N) 정확. 라이브(A) PROC_000008 전부 0행 → 누락 확정·중복 0. PROC_000008(화이트) master 실재(G). active 3 정확(over 0·under 0).

#### 쟁점 ③: 064 use_yn=N deferred 처리 — **UPHELD**
- **검증:** 064는 화이트 신호 **공백**(반칼 종이스티커) → 화이트별색 대상 자체 아님. deferred는 063 1건뿐(화이트 신호 보유 + use_yn=N). 064는 qty_unit UPDATE에만 포함(컬럼 갱신, 무해). 정합.

#### 쟁점 ④: benchmark §2 권고(모양=공정 + 치수=size 짝지음) 준수 — **UPHELD**
- **검증:** load-spec §3 R2가 benchmark §2를 명시 인용 — 모양=공정(PROC_000053/054/055 기적재 유지·재배치 불요)·치수=size축. BLOCKED CSV는 치수(cut_width/height)·EA를 L1에서 추출해 `_l1_shape_name/_cut_*_mm/_ea` 컬럼으로 보존, mint 인가 시 즉시 link. 권고 구조 따름.

#### 쟁점 ⑤: 058~062 형상 enum 보류(축 미확정) — **UPHELD (under-load 아님)**
- **적대적 검토:** 058~062 형상 enum(원형 25~90mm 등)이 size=A4/A5 2행에만 적재돼 형상축 드롭은 **실제 결함**(remediation G-SK-2). 설계자가 이를 "정상"으로 닫지 않고 **MISSING으로 명시 + D-3 축귀속 컨펌으로 보류**(size 보조 vs plate 임포지션 vs 신규테이블). `★사이즈선택:A4/A5` 분기가 size 재단치수인지 임포지션 메타인지 모호 → 추정 적재 금지가 옳음.
- **판정:** UPHELD. 보류는 work-avoidance 아님 — 결함을 결함으로 인정·문서화하되 축설계 결정(D-3) 선행이 정당. 066 원형(축 명확=size)은 BLOCKED, 058~062(축 모호)는 컨펌 — 처리 차등이 합리적.

#### 쟁점 ⑥: 빈 가변/코팅/addon 신호0 차단 — **UPHELD**
- **검증:** L1 154행 전부 공백(digital-print 템플릿 잔재). non-empty 게이트로 거짓 MISSING 차단. 적재 변경 0. digital-print 파일럿이 경고한 함정 회피.

> **sticker 평결:** **UPHELD 6 / OVERTURNED 0.** BLOCKED 11행은 정당(결론 유지), 단 사유 문구를 "무매치"에서 "EA-규약·치수·사용처 불일치"로 정밀화 권고(MINOR). under-load 합리화 없음.

---

## 4. 라이브 중복-PK 위험 — **0건** (양 시트)

검증자 라이브 SELECT(읽기전용 1회 배치, password 미노출) 직접 확인:

| 적재 키 | 라이브 현재 | 충돌? |
|---------|------------|:-----:|
| sticker (053·054·056, PROC_000008) [active INSERT] | 053/054/056 PROC_000008 = **0행** (A) | **충돌 0** |
| sticker 053/054 기존 PROC_000054@seq1 · 056 PROC_000053@seq1 (B) | proc_cd 상이 | 충돌 0 |
| sticker qty_unit 16상품 [UPDATE] | 16/16 NULL (C) | (NULL→값, 무해) |
| sticker 066 원형 size [BLOCKED·미적재] | 066 원형 = 0행 (E) | (미적재라 무관) |
| PA qty_unit 15상품 [UPDATE] | 15/15 NULL (D) | (NULL→값, 무해) |
| PA bundle 001/002 [deferred·skip] | 001/002 bdl_qty=50 기적재 (F) | (적재 안 함, 충돌 0) |
| master PROC_000007/008 (G) | 둘 다 실재 | FK 안전 |

→ sticker active INSERT 3행 + UPDATE 16행, PA UPDATE 15행 — 전부 **라이브 중복충돌 0**. 적재성 GO.

---

## 5. 적재 전 필수 해소 항목 (must-resolve-before-load)

| 우선 | 시트 | 항목 | 사유 / 조치 |
|:----:|------|------|------------|
| **HARD** | 양 | 적재 직전 `verify_expected.py` 라이브 export 재실행 1회 | 게이트는 use_yn·기적재를 stale ref에서 읽음. 본 검증이 핵심 stale 지점(중복PK·qty NULL·066 원형·bundle)을 라이브로 이미 닫았으나, 적재 시점 재확인이 권위반전 원칙. |
| Low(MINOR) | sticker | BLOCKED 사유 문구 정밀화 | "circle 6종 무매치" → "원형 master 6종 존재하나 치수 11종 중 35mm 외 부재 + 35mm(SIZ_000422)도 EA수 미포함·PRD_000217 전용이라 066 `(NEA)` 규약 위반 → 11종 mint 필요". 결론(no-load) 불변. |
| High | sticker | **D-2** 066 원형 11종 master mint 인가 | 마스터 쓰기(범위밖). 인가 시 BLOCKED CSV의 cut_*/EA로 즉시 link 적재. |
| High | sticker | **D-3** 058~062 형상 enum 축 귀속 | size 보조 vs plate 임포지션 vs 신규 커팅옵션 테이블. `★사이즈선택` 의미 확정 후 적재(현 미확정 보류 정당). |
| Med | sticker | **D-1** 화이트별색 부모/자식 규칙 | 자식 PROC_000008만 적재(부모 007 미적재 R-PROC-4)가 digital-print 별색 패턴과 동일 적용 OK인지 컨펌. (라이브 008 실재 확인됨.) |
| Med | PA | **D-PA-1** qty_unit 단위 + 봉투 '매' 세분 | EA 일괄이 봉투류(001~005)에 적절한지 — '매/장'(QTY_UNIT.02) 검토. 컬럼 UPDATE라 후속 변경 무해. |
| Low | PA | **D-PA-2** bundle 분리 정책 | 다중장수(003) 대표값·size표기 충분성. PK=prd_cd 단일 제약 하 정책 확정 후 일괄. |
| Low | 양 | **D-7/D-PA-4** use_yn=N 상품 qty_unit | 063·064(sticker)·008(PA) 미출시에 qty_unit 부여 — 컬럼 갱신이라 무해, 출시 시 즉시 유효. 정책 확인만. |
| Low | — | columns.csv `t_prd_product_sizes` 메타 보강 | 링크테이블 0컬럼 — 차기 size 적재 검증 토대(파일럿 권고 연장). |

---

## 6. 검증자 종합 의견

- **양 시트 게이트 PASS·독립 재산출 일치·적재성 위반 0·라이브 중복 0** — 적재 가능(GO). 미해소는 전부 **컨펌/마스터mint/정책 성격**(적재 차단 아님)이라 WITH-FINDINGS.
- **product-accessory 대조군 의혹은 기각된다.** "적재 없음=정상" 주장은 L1 셀 분기(0 mismatch)·uncovered(0)·process 컬럼 원천부재를 삼중 실증한 **사실**이며, 결함을 회피한 합리화가 아니다. digital-print(244행)와 결함 축이 정반대라는 시트별 편차가 실재. **dodge 0건.**
- **sticker BLOCKED는 정당하나 근거가 헐거웠다.** 라이브에서 066 원형 0행은 맞지만, master에 원형 6종이 *존재*하므로 "무매치"는 부정확했다. 검증자가 치수·EA규약·사용처를 직접 대조해 **35mm 1종조차 재사용 불가**(EA수 미포함·타상품 전용)임을 확정 — 11행 no-load 결론을 보강했다. 이 정밀화 없이는 부분 OVERTURN 반론 여지가 있었으므로, **사유 문구 정정을 MINOR로 권고**(결론 불변).
- **058~062 형상 enum 보류는 work-avoidance가 아니다.** 결함을 결함으로 명시·문서화하되 축귀속 모호(size vs 임포지션)로 추정 적재를 거부한 것 — 066(축명확=size)은 BLOCKED, 058~062(축모호)는 컨펌으로 차등 처리한 판단이 합리적.
- **최종: 양 시트 GO-WITH-FINDINGS. OVERTURN 0 · NO-GO 0 · dodge 0.** 적재 직전 라이브-export 게이트 재실행 1회 + sticker BLOCKED 사유 정밀화를 조건으로 무위험.
