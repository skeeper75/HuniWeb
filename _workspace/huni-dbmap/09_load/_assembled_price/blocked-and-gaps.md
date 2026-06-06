# 차단·GAP 목록 — round-4 가격 (적재 보류 + 해소 조건)

> 적재본에서 **제외된** 행을 사유·해소조건과 함께 명시한다(G7 — 침묵드롭 0). 두 종류:
> **§A 차단(blocked)** = 후니 siz 등록 대기(placeholder siz_cd, 발명 아님·정당 blocker) · **§B GAP** = t_* 6차원으로 무손실 표현 불가(박 2단 룩업, 후니 모델링 결정 선결).
> 차단·GAP 행은 **재포장하여 적재본에 넣지 않는다**. 후니 등록/결정 후 재조립 대상.

작성: dbm-load-builder · 권위: `03_validation/price-load-validation-final.md §A-2/A-3/B-2` + 적재본 조립 self-check(`assemble_price_bundle.py`) · 식별자/코드 영어, 설명 한국어.

---

## §A 차단(blocked) — 후니 siz 등록 대기 (component_prices, 1,513행)

> **siz 교정 통합(2026-06-06, dbm-load-builder)**: GUK4 870 + GP원형35mm 10 + 3JEOL 304 = **1,184행**이
> 기존 라이브 siz로 **해소(RESOLVED)** → 차단 2,697 → **1,513**. 권위:
> `02_mapping/price-siz-mapping-inspection.md §1-1/§1-4`(데이터 입증·search-before-mint) +
> 라이브 read-only SELECT(SIZ_000499/SIZ_000422/SIZ_000077 실존·impos_yn=Y 확증). 발명 0·기존 siz 재사용.

사유 공통: `t_prc_component_prices.siz_cd`가 라이브 미등록 규격이라 placeholder(`SIZ_PENDING_*`)로 보존됨. 적재 시 `fk_prc_comp_prices_siz_cd`(→ `t_siz_sizes`) 위반. **round-2가 라이브 실코드를 선탐색한 뒤 부재만 placeholder 처리**(dodge 방지·발명 0 검증 GO). 실코드 발견분(아크릴 DIRECT 47 등)은 이미 §즉시적재로 분리됨.

해소 조건 공통: 후니가 해당 규격을 `t_siz_sizes`에 siz_cd로 등록하면 → placeholder를 실코드로 치환 후 재조립 → 적재가능.

### §A-0 RESOLVED(1,184행) — 기존 라이브 siz로 해소, 차단→적재 승격

| 군(placeholder) | → 교정 siz_cd | 행수 | 증거(라이브 실존, del_yn=N·impos_yn=Y) |
|----------------|---------------|-----:|----------------------------|
| `SIZ_PENDING_GUK4` | **`SIZ_000499`** (cut 316x467/work 306x457) | **870** | 국전(636x939)/4 표준 정합·impos_yn=Y(조판=출력판형)·OUTPUT_PAPER_TYPE.01(국전계열) plate 유일행. 870행 distinct siz=1 → 단일 공유 출력판형 데이터 입증 |
| `SIZ_PENDING_GP_원형35mm` | **`SIZ_000422`** (원형35x35) | **10** | siz_nm 정확 일치(round-4 G9가 적발한 매칭) |
| `SIZ_PENDING_3JEOL` | **`SIZ_000077`** (cut 300x625/work 304x629) | **304** | **impos_yn=Y**(=출력판형 마커, GUK4의 SIZ_000499와 동일)·국3절 표준 ≈313x636 근접·국3절 dims 근처 **유일 impos=Y 판형**. `SIZ_000475`(330x640)은 impos_yn=N(=완성품, NOT plate)이라 기각. 304행 distinct siz=1, comps=디지털인쇄S1/S2·코팅무광/유광 → GUK4와 동일 단일 공유 출력판형 구조 |
| **소계 RESOLVED** | — | **1,184** | FK `fk_prc_comp_prices_siz_cd` PASS. 무발명/search-before-mint. |

> [후니 비차단 메모] `SIZ_000499`는 라이브 siz_nm이 `316x467`(국4절 라벨 아님)이다. 국4절 공유 출력판형을 이 siz_cd에 묶는 것은 치수·impos·국전계열 3중 증거로 **기술적으로 동일 판형**이라 적재를 막지 않으며, siz_nm을 `국4절(316x467)`로 보정할지는 **운영 명명 선택(cosmetic, 비차단)**.

### §A-1 잔여 차단(1,513행) — 후니 모델링 결정/등록 선결

| 군(placeholder 접두) | 차단 행수 | distinct siz | 내용 | 정확한 해소 조건 |
|---------------------|----------|-------------|------|----------------|
| `SIZ_PENDING_STK_*` | 456 | 6 | 스티커 판수규격(A4_1P·A4_2P·A3_1P·100x148·90x110) + B3/B4 | 후니가 판수축 모델(bdl_qty 차용 등) 결정 + B규격 siz 등록 |
| `SIZ_PENDING_POSTER_*` | 680 | 113 | 대형 포스터 면적좌표(600~1750mm·A1·inch액자·900계열 등) | 면적 좌표 재매핑(`price-correction-poster-sign.md`)으로 **별도 처리 중** — 후니가 면적좌표 siz 113종 등록 **또는** 면적함수 방식 결정 |
| `SIZ_PENDING_ACRYL_*` | 237 | 149 | 아크릴 면적좌표(REVERSED 21 + NONE 128, 정방향 라이브 부재 확증) | 면적 좌표 재매핑(`price-correction-poster-sign.md`)으로 **별도 처리 중** — 후니가 면적좌표 siz 149종 등록 **또는** 면적함수 방식 결정 |
| `SIZ_PENDING_GP_원형*` (35mm 제외) | 100 | 10 | 합판도무송 원형 직경(10~60mm 중 35mm 외) | 후니가 직경 siz 10종 등록(의미축=직경, 별도) |
| `SIZ_PENDING_ENV_*` | 40 | 4 | 봉투종류(티켓/소/자켓/대봉투) | 후니가 봉투규격 siz 4종 등록 |
| **소계** | **1,513** | **276** | — | — |

> [정직 표기] 면적군(POSTER·ACRYL)은 "좌표 siz_cd 방식"(가로×세로 조합=siz_cd, 사용자 확정)이며, 면적함수 도입 시 등록 규모(262종)가 달라질 수 있어 후니 결정 여지를 병기. POSTER/ACRYL은 면적 좌표 재매핑(`price-correction-poster-sign.md`) 트랙에서 별도 처리 중.

### 차단/교정 행 프로비넌스
- 원본 `02_mapping/load_price/t_prc_component_prices.csv`(4,805행) 중 `siz_cd LIKE 'SIZ_PENDING%'` = 2,697행.
  - 그 중 **1,184행**(GUK4 870 + GP원형35mm 10 + 3JEOL 304) → siz_cd 1:1 치환(`SIZ_PENDING_GUK4→SIZ_000499`, `SIZ_PENDING_GP_원형35mm→SIZ_000422`, `SIZ_PENDING_3JEOL→SIZ_000077`) → 적재본 `04` 로 **승격**. (다른 차원 컬럼 불변·무발명. 실행 SQL `09_load/_exec_price/04_prc_component_prices.sql` 의 `-- src: … siz:<from>-><to>` 주석 + note `[siz-corrected: <from>→<to>]` 접두로 행별 추적.)
  - 잔여 **1,513행** = 본 §A-1, 적재본에서 **제외** 유지.
- 적재 04 = 2,108(즉시) + 1,184(교정) = **3,292**. 적재 3,292 + 차단 1,513 = 원본 4,805(정합).
- 잔여 placeholder 후니 siz 등록 후: placeholder→실코드 치환 → 재생성 → 차단분이 적재본으로 이동.

### 차단에 묶인 상품 바인딩(참고, 미차단)
- `load/05_prd_product_price_formulas.csv`의 봉투(PRD_000050)·스티커·포스터·아크릴·합판 바인딩은 **prd_cd·frm_cd FK만 의존**(siz_cd 무관)이라 즉시 적재가능. 단, 해당 상품의 **단가 조회 실효**는 차단 siz 등록 후 완성(바인딩 note에 명시됨, 예: PRD_000050 "봉투종류 siz_cd 후니 등록 후 component_prices siz 채움").

---

## §B GAP — 무손실 표현 불가 (박 시트, 후니 모델링 결정 선결)

### B-1. 박(소형/대형) 가공비 — 2단 룩업 (BLOCKED-LEGIT, 에스컬레이션)

| 항목 | 산출 | 사유 |
|------|------|------|
| `COMP_FOIL_*`(박 시트 가공비/동판비) component_prices | **0행** | 통째 미산출 |
| price_formulas FOIL | 0 | 미배선 |
| product binding FOIL | 0 | 미바인딩 |

**사유(왜 6차원에 못 담는가)**: 박 가공비는 진짜 **2단 룩업**(면적 → 분류등급 A~E/A~I → 가격)이다. component_prices의 6차원(siz/clr/mat/coat/bdl/min)에 **중간키(분류등급 A~E)** 를 둘 슬롯이 없다. 면적을 siz_cd로 직접 담으면 분류등급 단계가 소실되어 의미 왜곡 → **억지평면화 금지**(round-2 검증 GO 원칙). 침묵드롭·발명 0으로 **에스컬레이션** 처리.

**정확한 해소 조건(후니 결정 필요 — 택일)**:
1. 분류등급(A~E)을 **신규 차원/중간 룩업 테이블**로 둘지,
2. **면적 직접 함수**(면적→가격)로 단순화할지,
3. `mat_cd` 차용 등 기존 차원 재해석으로 흡수할지.
→ 후니가 ①~③ 중 택일(또는 입력 UI 방식: 분류등급 입력 vs 면적 입력)하면, 그에 맞춰 박 시트 추출·평면화 후 재조립.

> [정직 표기] **동판비**(B01, 가로×세로→단가 2D)는 아크릴형 ADEQUATE라 즉시 처리 가능 후보였으나, GAP 결정 선결로 **이번 미산출**. `COMP_NAMECARD_FOIL_*`(명함 박)은 별개 시트로 **이미 적재됨**(.06 유형) — 박 *시트*(foil-small/large)와 혼동 금지(검증-final §A-3).

---

## 집계 재구성 (G7 — 아무 행도 사라지지 않음)

| 분류 | 행수/건수 | 행선지 |
|------|----------|--------|
| 즉시 적재가능 (component_prices, real+null siz) | 2,108 | `_exec_price/04_prc_component_prices.sql` |
| siz 교정 적재가능 (GUK4 870 + GP35mm 10 + 3JEOL 304) | 1,184 | `_exec_price/04_prc_component_prices.sql`(승격) |
| **적재가능 소계** | **3,292** | (2,108 + 1,184) |
| 잔여 차단(후니 siz 등록 대기) | 1,513 | 본 문서 §A-1 (적재본 제외) |
| **component_prices 소계** | **4,805** | (3,292 + 1,513, 원본 정합) |
| GAP(박 시트 2단 룩업) | 1건(0행 산출) | 본 문서 §B (에스컬레이션) |
| 코드행 선적재(별도) | 1 | `code-row-preload.md` |

---

## 에스컬레이션 요약 (사용자/후니 결정 — 본 하네스 권한 밖)

1. **코드행 등록**: `PRC_COMPONENT_TYPE.06` 1행(`code-row-preload.md`).
2. **siz 교정 완료(1,184행, 비차단)**: 국4절(GUK4)→`SIZ_000499` 870 + GP원형35mm→`SIZ_000422` 10 + 3절(3JEOL)→`SIZ_000077` 304 — 기존 라이브 siz 재사용(셋 다 impos_yn=Y 출력판형)으로 **이미 적재 승격**(후니 등록 불요). 잔여 cosmetic: `SIZ_000499`/`SIZ_000077` siz_nm을 국절 라벨로 보정할지(운영 명명, 비차단).
3. **siz 등록 잔여 5군(1,513행)**: STK·POSTER·ACRYL·GP(원형35mm 외)·ENV (POSTER/ACRYL은 면적 좌표 재매핑으로 별도 처리 중).
4. **박 GAP 모델링**: 2단 룩업 정착지 결정(또는 동판비만 우선 처리).
5. **실제 INSERT 실행**: 위 1·코드행 충족 + 인간 승인 후(본 트랙은 산출까지).
