# C3 실사/포스터사인 — 가격테이블 적재정합 전수 검증

작성 2026-06-26 · A2 축2 · 클러스터 C3 · 라이브 읽기전용·DB 미적재.
권위 = 인쇄상품 가격표 260527 「포스터사인」 시트(`06_extract/price-poster-sign-l1.csv`) + 상품마스터 260610 「실사」 시트(`24_master-extract-260610/silsa-l1.csv`).
라이브 = `t_prc_*` (PRF_POSTER_* 28 공식 · 각 1바인딩 + POSTER_FIXED 0바인딩 = 29 공식).

> **메모리 정합:** 실사 가격 = 포스터사인 [가로×세로] 면적매트릭스(inline 아님·좌표 siz 채번 금지). 본 검증 결과 면적매트릭스형 본체 comp는 `use_dims=[siz_width,siz_height]`로 올바르게 배선됐고 좌표 siz 신규 채번 없음(가로/세로 = siz_width/siz_height 차원값) — 메모리 원칙 준수 확인.

---

## 0. 판정 요약

| 축 | 결과 |
|---|---|
| ① 단가행 값 정합 | **2 HIGH 결함** (FOMEXBOARD 본체 2행 단가 오적재·BANNER_NORMAL 1750mm 잉여밴드 16행) + 다수 MED 누락 |
| ② 배선 정합 | **GO** — 전 공식 prc_typ=PRICE_TYPE.01 단가형, 면적형=`[siz_width,siz_height]`·고정형=`[siz_cd]`·수량형=`[siz_cd,min_qty]` 정확 |
| ③ 바인딩 정합 | **GO** — 28 제품 ↔ 28 공식 1:1. POSTER_FIXED 0바인딩 = 의도(소재별 공식이 대체) |

**C3 종합 판정 = PARTIAL** (배선·바인딩 건전, 단가행에 HIGH 2 + MED 누락 다수).

---

## 1. 권위 구조 (포스터사인 시트 = 2 레이아웃)

- **Type A 면적매트릭스(가로×세로)**: B01~B11, B26~B27 = 13 블록. 행=가로(siz_width), 열=세로(siz_height), 셀=완제품가(출력+코팅+가공 포함). off-grid는 ceiling(한 단계 큰 구간).
- **Type B 사이즈×수량(고정 사이즈 격자)**: B12~B25, B28~B31 = 18 블록. 사이즈코드별(또는 사이즈×수량구간) 완제품가 + 추가옵션(거치대·우드행거·천정형고리 등) 별도 가산표.
- Type B 본체 기본단가는 상품마스터 「실사」 시트 `price` 컬럼이 권위 사다리(폼보드 A3/A2/A1, 시트커팅 A4/A3/A2, 아크릴스티커 4사이즈 등).

---

## 2. 본체 면적매트릭스 단가행 정합 (Type A·verbatim 대조)

★ 라이브는 면적셀을 (siz_width, siz_height) 양방향 대칭으로 저장 → 권위 (가로,세로) 셀을 **대칭 매칭**(w×h ∨ h×w)으로 대조해야 정확. 대칭 매칭 시 전 본체 매트릭스 **WRONG=0**(값 verbatim 일치).

| 공식 | 본체 comp | 권위 블록 | 권위셀 | 라이브행 | WRONG | MISSING | 가격범위 |
|---|---|---|---|---|---|---|---|
| ARTPRINT | COMP_POSTER_ARTPRINT_PHOTO | B01 | 52 | 52 | 0 | 0 | 12000~72000 ✓ |
| WATERPROOF | ↑(공유) | B03 | 52 | (공유52) | 0 | 0 | B03≡B01 동일매트릭스 |
| ADH_WP | ↑(공유) | B04 | 52 | (공유52) | 0 | 0 | B04≡B01 |
| ARTFABRIC | ↑(공유) | B06 | 52 | (공유52) | 0 | 0 | B06≡B01 |
| ARTPAPER | COMP_POSTER_ARTPAPER_MATTE | B02 | 39 | 39 | 0 | 0 | 12000~54000 ✓ |
| ADH_CLEAR | COMP_POSTER_ADH_CLEAR_PVC | B05 | 52 | 52 | 0 | 0 | 16000~198000 ✓ |
| LINEN | COMP_POSTER_LINEN_FABRIC | B07 | 52 | 52 | 0 | 0 | 17000~108000 ✓ |
| CANVAS | COMP_POSTER_CANVAS_FABRIC | B08 | 52 | 52 | 0 | 0 | 19000~126000 ✓ |
| LEATHER_AP | ↑(공유) | B09 | 52 | (공유52) | 0 | 0 | B09≡B08 |
| TYVEK | ↑(공유) | B10 | 52 | (공유52) | 0 | 0 | B10≡B08 |
| MESH | ↑(공유) | B11 | 52 | (공유52) | 0 | 0 | B11≡B08 |
| BANNER_N | COMP_POSTER_BANNER_NORMAL | B26 | 64 | **79** | 0 | **1** | 8000~72000(권위 8000~60000) |
| BANNER_M | COMP_POSTER_BANNER_MESH | B27 | 48 | **46** | 0 | **2** | 20000~120000 ✓ |

### 공유 comp 무해성 확인 (★중요)
- **COMP_POSTER_ARTPRINT_PHOTO**가 5 공식(ARTPRINT/WATERPROOF/ADH_WP/ARTFABRIC/FIXED) 공유, **COMP_POSTER_CANVAS_FABRIC**가 4 공식(CANVAS/LEATHER_AP/TYVEK/MESH) 공유.
- 권위 B01≡B03≡B04≡B06, B08≡B09≡B10≡B11 = **셀단위 0 diff(byte-identical 매트릭스)**. 따라서 단가표 공유는 **값 충돌 없음 = 정합**(소재 차이는 명목뿐, 면적단가 동일). C2 DBLPANSU류 silent-collision 결함과 달리 본 공유는 안전.

---

## 3. Type B (사이즈×수량) 단가행 정합

권위 = 상품마스터 「실사」 price 사다리 + 포스터사인 B12~B31 셀. siz_cd 라벨 = `t_siz_sizes` 실측.

| 공식 | comp | 권위 출처 | 권위 셀수 | 라이브행 | 결과 |
|---|---|---|---|---|---|
| FOAMBOARD | COMP_POSTER_FOAMBOARD_WHITE | 마스터 폼보드 A3/A2/A1 | 3 | 3 | ✓ 6000/12000/20000 verbatim |
| **FOMEXBOARD** | COMP_POSTER_FOMEXBOARD_WHITE3MM | 마스터 포맥스 A3/A2/A1 | 3 | **2** | **HIGH** A3=8500✗(권위8300)·A2=13000✗(권위11500)·A1=20000 누락 |
| SHEETCUT_MATTE | COMP_POSTER_SHEETCUT_MATTE | 마스터 무광시트 A4/A3/A2 | 3 | 3 | ✓ 6000/11000/32000 |
| SHEETCUT_HOLO | COMP_POSTER_SHEETCUT_HOLO | 마스터 홀로그램 A4/A3/A2 | 3 | 3 | ✓ 8000/16000/32000 |
| ACRYLSTK_GLOSS | COMP_POSTER_ACRYLSTK_GLOSS | 마스터 유광아크릴 4사이즈 | 4 | 4 | ✓ 12000/18000/28000/47000 |
| ACRYLSTK_MIRROR | COMP_POSTER_ACRYLSTK_MIRROR | 마스터 미러아크릴 4사이즈 | 4 | 4 | ✓ 15000/22000/36000/62000 |
| FRAMELESS | COMP_POSTER_FRAMELESS_WOOD | B12 A3/A2/A1 | 3 | 2 | MED A3=16000✓·A2=23000✓·**A1=35000 누락** |
| LEATHER_FRAME | COMP_POSTER_LEATHER_FRAME | B14 6사이즈 | 6 | 2 | MED A4=16000✓·A3=21000✓·**5x5/5x7/8x8/8x10 4사이즈 누락** |
| JOKJA | COMP_POSTER_JOKJA | B16 5사이즈 | 5 | 4 | MED A3/A2/300x600/900x1200 ✓·**A1=22000 누락** |
| CANVAS_HANGING | COMP_POSTER_CANVAS_HANGING | B18 A4/A3/A2 | 3 | 3 | ✓ 6000/10500/20000 |
| LINEN_WOODBONG | COMP_POSTER_LINEN_WOODBONG | B20 A4/A3/A2 | 3 | 3 | ✓ 6000/8200/16000 |
| MINI_STANDBOARD | COMP_POSTER_MINI_STANDBOARD | B29 A5/A4/A3 × q(4/19/49/99/10000) | 15 | 15 | ✓ 전셀 verbatim |
| MINI_BANNER | COMP_POSTER_MINI_BANNER | B31 150x300/180x420 × q5 | 10 | 10 | ✓ 전셀 verbatim |
| PET_BANNER | COMP_POSTER_PET_BANNER | B22 600x1800 | 1 | 1 | ✓ 22000 |
| MESH_BANNER | COMP_POSTER_MESH_BANNER | B24 600x1800 | 1 | 1 | ✓ 38000 |

### 추가옵션 가산표 (addtn 본체와 별도 comp) — 전부 verbatim ✓
- BANNER_N: 펀치(4구3000/6구4000/8구8000)·재단마감3000·양면테이프3000·봉미싱4000·큐방3000·끈4000·각목(900이하 4000/초과 8000) → 권위 일치.
- BANNER_M(메쉬현수막): 펀치 3종·메쉬 큐방3000·끈4000 → 일치.
- JOKJA 천정형고리=6500✓ · CANVAS_HANGING 우드행거+면끈 A4/A3/A2=16000/18000/20000✓ · LINEN_WOODBONG 우드봉+면끈 7000/9800/12000✓ · LINEN_FINISH 5종(0/800/1000/2000/2000)✓.

---

## 4. 배선 정합 (축②) — GO

- 전 28 공식 본체 comp `prc_typ_cd = PRICE_TYPE.01`(단가형) — 완제품가 룩업이므로 단가형 적정(qty=1 곱).
- use_dims 패턴 정확: 면적형=`[siz_width,siz_height]`(±min_qty), 고정사이즈형=`[siz_cd]`(±min_qty), 수량구간형=`[siz_cd,min_qty]`. 추가옵션 comp=`[opt_cd,opt_grp:...]`/`[proc_cd,min_qty,proc_grp:...]` polymorphic 정합.
- 끊긴 배선·고아 comp **없음**. 전 formula_components addtn_yn=Y(가산형) 일관.

---

## 5. 바인딩 정합 (축③) — GO

- **28 제품 ↔ 28 공식 1:1 바인딩** 전건 정합 (각 소재 포스터/사인 제품이 자기 공식에 연결).
- **POSTER_FIXED 0바인딩 = 의도된 미바인딩**: note="포스터·사인 완제품가...소재·사이즈·수량 표에서 바로 조회". 소재별 PRF_POSTER_<MATERIAL> 공식 28종이 이를 대체 구현 → POSTER_FIXED는 미사용 스캐폴드(DEAD, use_yn=Y라 LOW 정리대상). 결함 아님.
- **알려진 갭(권위측 미가격)**: 「실사」 시트 `투명포스터★`(투명PET·비접착)·`접착투명포스터`(price 공란) 중 비접착 투명PET 포스터는 포스터사인 시트에 매트릭스 없음(price 공란) → 라이브 바인딩 없음 = **권위 미가격 = 정합**(off-track, 적재 대상 아님).

---

## 6. 재현 쿼리 (요지)

```sql
-- 공식·바인딩·배선 한눈
SELECT f.frm_cd, f.use_yn,
  (SELECT count(*) FROM t_prd_product_price_formulas b WHERE b.frm_cd=f.frm_cd) binds,
  (SELECT count(*) FROM t_prc_formula_components fc WHERE fc.frm_cd=f.frm_cd) wires
FROM t_prc_price_formulas f WHERE f.frm_cd LIKE 'PRF_POSTER%' ORDER BY 1;
-- FOMEXBOARD 단가 오적재 재현
SELECT siz_cd, unit_price FROM t_prc_component_prices WHERE comp_cd='COMP_POSTER_FOMEXBOARD_WHITE3MM';
--  → SIZ_000315(A3)=8500, SIZ_000317(A2)=13000  vs 권위 8300/11500, A1=20000 부재
-- BANNER_NORMAL 1750mm 잉여밴드
SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_POSTER_BANNER_NORMAL' AND siz_height=1750; -- 16행 (권위 미존재)
```

---

## 7. C3 결함 보드 → `c3-silsa-defect-board.csv` (HIGH 2 · MED 4 · LOW 1)
