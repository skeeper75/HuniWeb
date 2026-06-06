# 차단·GAP 목록 — round-4 가격 (적재 보류 + 해소 조건)

> 적재본에서 **제외된** 행을 사유·해소조건과 함께 명시한다(G7 — 침묵드롭 0). 두 종류:
> **§A 차단(blocked)** = 후니 siz 등록 대기(placeholder siz_cd, 발명 아님·정당 blocker) · **§B GAP** = t_* 6차원으로 무손실 표현 불가(박 2단 룩업, 후니 모델링 결정 선결).
> 차단·GAP 행은 **재포장하여 적재본에 넣지 않는다**. 후니 등록/결정 후 재조립 대상.

작성: dbm-load-builder · 권위: `03_validation/price-load-validation-final.md §A-2/A-3/B-2` + 적재본 조립 self-check(`assemble_price_bundle.py`) · 식별자/코드 영어, 설명 한국어.

---

## §A 차단(blocked) — 후니 siz 등록 대기 (component_prices, 2,697행)

사유 공통: `t_prc_component_prices.siz_cd`가 라이브 미등록 규격이라 placeholder(`SIZ_PENDING_*`)로 보존됨. 적재 시 `fk_prc_comp_prices_siz_cd`(→ `t_siz_sizes`) 위반. **round-2가 라이브 실코드를 선탐색한 뒤 부재만 placeholder 처리**(dodge 방지·발명 0 검증 GO). 실코드 발견분(아크릴 DIRECT 47 등)은 이미 §즉시적재로 분리됨.

해소 조건 공통: 후니가 해당 규격을 `t_siz_sizes`에 siz_cd로 등록하면 → placeholder를 실코드로 치환 후 재조립 → 적재가능.

| 군(placeholder 접두) | 차단 행수 | distinct siz | 내용 | 정확한 해소 조건 |
|---------------------|----------|-------------|------|----------------|
| `SIZ_PENDING_GUK4` | 870 | 1 | 국4절 출력판형(코팅·디지털·완칼 등 통용 규격) | 후니가 국4절 **출력판형**을 `t_siz_sizes`에 siz_cd 1종 등록 |
| `SIZ_PENDING_3JEOL` | 304 | 1 | 3절 출력판형 | 후니가 3절 출력판형을 `t_siz_sizes`에 siz_cd 1종 등록 |
| `SIZ_PENDING_STK_*` | 456 | 6 | 스티커 판수규격(A4_1P·A4_2P·A3_1P·100x148·90x110) + B3/B4 | 후니가 판수결합·B규격 siz 6종 등록 |
| `SIZ_PENDING_POSTER_*` | 680 | 113 | 대형 포스터 면적좌표(600~1750mm·A1·inch액자·900계열 등) | 후니가 면적좌표 siz 113종 등록 **또는** 면적함수 방식 결정 |
| `SIZ_PENDING_ACRYL_*` | 237 | 149 | 아크릴 면적좌표(REVERSED 21 + NONE 128, 정방향 라이브 부재 확증) | 후니가 면적좌표 siz 149종 등록 **또는** 면적함수 방식 결정 |
| `SIZ_PENDING_GP_원형*` | 110 | 11 | 합판도무송 원형 직경(10~60mm) | 후니가 직경 siz 11종 등록(의미축=직경, 별도) |
| `SIZ_PENDING_ENV_*` | 40 | 4 | 봉투종류(티켓/소/자켓/대봉투) | 후니가 봉투규격 siz 4종 등록 |
| **소계** | **2,697** | **285** | — | — |

> [정직 표기] 국4절/3절은 완성품 규격(siz_cd 본의)이 아니라 **출력판형**이나, round-2가 후니 스키마상 siz_cd 재사용으로 표현 가능하다고 확정(HANDOFF §3). 면적군(POSTER·ACRYL)은 "좌표 siz_cd 방식"(가로×세로 조합=siz_cd, 사용자 확정)이며, 면적함수 도입 시 등록 규모(262종)가 달라질 수 있어 후니 결정 여지를 병기.

### 차단 행 프로비넌스
- 위 2,697행 = 원본 `02_mapping/load_price/t_prc_component_prices.csv` 중 `siz_cd LIKE 'SIZ_PENDING%'`인 행 전수.
- 적재본(`load/04_prc_component_prices.csv`)에서 **제외**됨. 적재 2,108 + 차단 2,697 = 원본 4,805(정합).
- 후니 siz 등록 후: placeholder→실코드 치환 → `assemble_price_bundle.py` 재실행 → 차단분이 적재본으로 이동.

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
| 즉시 적재가능 (component_prices) | 2,108 | `load/04_prc_component_prices.csv` |
| 차단(후니 siz 등록 대기) | 2,697 | 본 문서 §A (적재본 제외) |
| **component_prices 소계** | **4,805** | (2,108 + 2,697, 원본 정합) |
| GAP(박 시트 2단 룩업) | 1건(0행 산출) | 본 문서 §B (에스컬레이션) |
| 코드행 선적재(별도) | 1 | `code-row-preload.md` |

---

## 에스컬레이션 요약 (사용자/후니 결정 — 본 하네스 권한 밖)

1. **코드행 등록**: `PRC_COMPONENT_TYPE.06` 1행(`code-row-preload.md`).
2. **siz 등록 7군**: 국4절·3절·STK·POSTER·ACRYL·GP·ENV (총 2,697행 해소).
3. **박 GAP 모델링**: 2단 룩업 정착지 결정(또는 동판비만 우선 처리).
4. **실제 INSERT 실행**: 위 1~2 충족 + 인간 승인 후(본 트랙은 산출까지).
