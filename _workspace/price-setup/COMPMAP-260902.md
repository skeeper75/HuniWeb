# 가격표 260902_1 code/name ↔ 라이브 가격구성요소 대조표 (리드 분석 초안)

> 작성 2026-09-02 · lead-peta 세션. **라이브 DB는 읽기(SELECT)만** 했다. 등록·수정은 전부 webadmin 실제 화면에서만 한다[HARD].
> 권위: `docs/huni/후니프린팅_인쇄상품_가격표_260902_1.xlsx`(17:32판이 최신 — 260902 14:58판은 포스터사인 시트에만 code가 있고, `_1`판에 스티커·아크릴 code가 추가됨).
> 라이브 실측 시각: 2026-09-02 08:46 UTC · 구성요소 223종 · 단가행 25,191 · 공식 123.

## 0. 한 장 요약

| 시트 | 엑셀 code 블록 | 라이브에 대응 그릇 있음 | 그릇 형태 차이 | 라이브에만 있음(엑셀 code 없음) |
|---|---:|---:|---|---|
| 아크릴 | 6 | 6 | 1.5T·미러3T는 **고아**(공식 0개) · 3T 그릇에 1.5T 자재행 혼재 | 볼펜·자유형스탠드·명찰GS·미니파츠·PENDING(6공식) |
| 스티커 | 7 | 7(그릇 3개로 합쳐져 있음) | 반칼/완칼/완칼투명/대형 4 code → `COMP_STK_PRINT` 1개 · 타투 2 code → 1개(합가) · 스티커팩 **엑셀 블록이 비어 있음**(16장 1세트 new) | — |
| 포스터사인 | 31 | 31 | PET·PVC·그래픽천 → 인화지 그릇 공유 · 옥스포드·레더·타이벡·메쉬 → 캔버스 그릇 공유 · 시트커팅/아크릴스티커 1 code → 상품별 2그릇 | 캔버스행잉 우드행거 `_0` 중복행(고아) |

**엑셀 code 체계와 라이브 code 체계는 다르다.** 엑셀은 `상품군_소재_역할`(`ACRYLIC_CLEAR3T_print`), 라이브는 `COMP_상품군_의미`(`COMP_ACRYL_CLEAR3T`). 값은 대부분 이미 라이브에 있다. **이번 일의 핵심은 "값 채우기"가 아니라 "이름·코드·그릇 경계를 권위 code/name 기준으로 정돈하고, 위젯에서 옵션을 고르면 그 그릇이 매칭되게 차원을 맞추는 것"이다.**

## 1. 아크릴 시트 (6 블록)

| # | 엑셀 code | 엑셀 name | 격자 | 라이브 구성요소 | 라이브 이름 | 행 | 공식 수 | 판정 |
|---|---|---|---|---|---|---:|---:|---|
| A1 | `ACRYLIC_CLEAR3T_print` | 아크릴_투명3T_출력가 | 가로14×세로14 (20~200mm) | `COMP_ACRYL_CLEAR3T` | 투명아크릴 인쇄가공비 | 277 | 8 | ✅ 값 있음. ⚠ 자재 차원에 3mm(`MAT_000386`)+1.5mm(`MAT_000387`) **두 자재 행이 한 그릇에** 섞여 있다(14×14=196 + 9×9=81 = 277). 가격유형이 `.02`(합가형)이지만 전 행 `min_qty=1`이라 엔진(`component_subtotal`: 총액÷구간수량×주문수량)에서 단가형과 결과가 같음 → **금액 결함 아님**, 형제 그릇(1.5T·미러=`.01`)과 표기만 다름 |
| A2 | `ACRYLIC_CLEAR15T_print` | 아크릴_투명1.5T_출력가 | 9×9 (20~100mm) | `CLR_ACRYL_1.5T` | 투명아크릴1.5T 인쇄가공비 | 81 | **0** | ⚠ **고아 그릇**(어느 공식에도 안 배선). 같은 값이 A1 그릇 안의 1.5mm 행으로도 존재 = 이중 그릇. 1.5mm 쓰는 상품은 아크릴미니파츠(`PRD_000163`)뿐이며 그 상품은 `COMP_ACRYL_MINIPART_TBD`(단가 미정)로 묶여 있음 |
| A3 | `ACRYLIC_MIRROR3T_print` | 아크릴_미러3T_출력가 | 9×9 (20~100mm) 전면5도 | `COMP_ACRYL_MIRROR3T` | 미러아크릴3T 인쇄가공비 | 81 | **0** | ⚠ **고아 그릇**. 차원 `[siz_width, siz_height]`만(수량 없음). 미러 3T(골드/실버 `MAT_000377/378`)를 쓰는 상품은 **아크릴명찰(골드실버)** `PRD_000153`인데, 그 상품은 매트릭스 대신 `COMP_ACRYL_NAMETAG_GS`(사이즈코드 3행 고정가)로 배선됨. 상품마스터에 "미러아크릴" 언급은 미러아크릴스티커(실사)만 → **이 격자를 쓸 상품이 무엇인지 확정 필요** |
| A4 | `ACRYLIC_TOTAL_finishing` | 아크릴_종합_부자재 | 상품군×옵션 26행 | `COMP_ACRYL_FINISH` | 아크릴 후가공 부속(통합) | 17 | 9 | ✅ 260901에 통합 완료(금액 차이 0 증명). 옛 9개 그릇(KEYRING·BADGE·MAGNET·CLIP·NAMETAG_PIN·NAMETAG_GS_OPTION·SMARTTOK·ZIBITZ·HAIR_BAND)은 배선 해제·행 보존 상태 |
| A5 | `ACRYLIC_CLEAR8T_print` | 아크릴_투명8T_출력가 | 6×6 (30~80mm) | `COMP_ACRYL_COROTTO` | 아크릴코롯토(투명8T) 인쇄가공비 | 36 | 2 | ✅ |
| A6 | `ACRYLIC_carabiner_final` | 아크릴_카라비너_제작가 | 옵션 4 + 수량할인 | `COMP_ACRYL_CARABINER` | 아크릴카라비너 본체(3T+3T접합) | 4 | 1 | ✅ (엑셀 메모 "수정없음") |

엑셀에 code가 없는 아크릴 블록: **r55~63 수량구간 할인표**(300~499 30%… ) → 라이브 `DSC_ACR_QTY`(할인테이블, 아크릴 전 상품 연결·키링은 `COMP_ACRYL_CLEAR3T` 구성요소 한정). 할인은 구성요소가 아니라 할인테이블 그릇이라 code가 없는 게 맞다.

라이브에만 있는 아크릴 그릇(상품마스터 굿즈 고정가 계열, 가격표 시트 밖): `COMP_ACRYL_BALLPEN`(3) · `COMP_ACRYL_FREESTAND`(5) · `COMP_ACRYL_NAMETAG_GS`(3) · `COMP_ACRYL_MINIPART_TBD`(1) · `COMP_ACRYL_PENDING_TBD`(0행인데 **공식 6개**에 묶임 — 포카코롯토·입체코롯토·입체블럭·쉐이커 등 use_yn=N 상품) · `COMP_ACRYL_KEYRING_BALLCHAIN`(삭제됨).

## 2. 스티커 시트 (7 블록)

| # | 엑셀 code | 엑셀 name | 격자 | 라이브 구성요소 | 행 | 공식 | 판정 |
|---|---|---|---|---|---:|---:|---|
| S1 | `STK_KISSCUT_PRINT` | 스티커_반칼_제작가 | 옵션(소재/코팅)×규격(A5·A4·A3·90×190·A6·90×110)×수량 | `COMP_STK_PRINT` 스티커 완제품가(소재·규격) | 5,424 | 1 (`PRF_STK_FIXED` → 상품 13종) | ✅ 값 있음. **엑셀 4 code가 라이브 1 그릇** |
| S2 | `STK_CUT_PRINT` | 스티커_완칼_제작가 | 수량×(A4·B4·A3·B3·A2) | 〃 | 〃 | 〃 | 〃 |
| S3 | `STK_CUT_CLEAR_PRINT` | 스티커_완칼투명_제작가 | 〃 | 〃 | 〃 | 〃 | 〃 |
| S4 | `STK_CUT_LARGE_PRINT` | 스티커_완칼대형_제작가 | 수량×400×600 | 〃 | 〃 | 〃 | 〃 |
| S5 | `STK_TATTOO_setup` | 스티커_타투_기본가 | 90×190 1행 | `COMP_STK_TATTOO` 타투스티커 완제품가(3장세트) | 333 | 1 | ✅ 라이브는 기본가+3장당을 **미리 합산한 총액형(.02) 1그릇**. 엑셀은 2 code로 분리 |
| S6 | `STK_TATTOO_print` | 스티커_타투_제작가 | 수량×90×190 | 〃 | 〃 | 〃 | 〃 |
| S7 | `STK_STICKERPACK_final` | 스티커_스티커팩_제작가 | "new 스티커팩(16장 1세트)" **데이터 0행** | `COMP_STK_PACK` 스티커 완제품가 팩(54장1세트) 4,000 | 1 | 1 | ⚠ 엑셀 블록이 **비어 있고** 세트 구성이 54장→16장으로 바뀐 듯. 값 확정 전엔 손댈 수 없음 |

대소문자: 스티커만 `_PRINT`(대문자), 다른 시트는 `_print`(소문자). 코드 표기 규칙 통일 여부 확인 필요.

### 상품뷰어 요소 ↔ 그릇 차원 (스티커)
- `COMP_STK_PRINT` 차원 = `[siz_cd, mat_cd, min_qty]`. 스티커 13종의 상품뷰어 사이즈(A6·A5·A4·A3·A2·400×600·140×100·90×190·124×186·100×140)는 모두 단가행 사이즈 26종 안에 있음 ✅.
- 스티커 13종의 상품뷰어 자재(유포·미색·아트·무광코팅·유광코팅·투명 백색후지/투명후지·홀로그램·유포지·투명접착PVC)는 **전부** 단가행 자재 축에 존재(라이브 SELECT로 대조, 누락 0) ✅.
- 반칼 상품의 옵션그룹 「커팅」(원형 25mm(24ea)… 모양)은 가격 차원이 아님(장당 가격은 규격×소재로 결정) — 옵션그룹으로 두는 것이 맞음.
- ⚠ 낱장(완칼) 자유형 스티커(`PRD_000055`)·대형(`PRD_000057`)에 옵션그룹 **「소재」= 전용지+엠보코팅**(`OPT_000277/278`)이 있음. 자재는 자재 축(`mat_cd`)이지 옵션그룹이 아니다(적재 규범 U-1 혼재). 이 옵션이 가격에 얹히는지, 단가행 자재와 어긋나지 않는지 확인 대상.

## 3. 포스터사인 시트 (31 블록)

### 3-1. 면적매트릭스형(직접입력·가로×세로)

| # | 엑셀 code | 엑셀 name | 라이브 구성요소 | 행 | 공식 | 판정 |
|---|---|---|---|---:|---:|---|
| P1 | `POSTER_PHOTOPAPER_print` | 포스터_인화지_출력가 | `COMP_POSTER_ARTPRINT_PHOTO` 실사 완제품가(아트프린트·접착방수·아트패브릭·방수) | 52 | 5 | ✅ **엑셀 4 code(인화지·PET·PVC·그래픽천) → 라이브 1 그릇 공유**(값이 같아 합친 것. 옛 개별 그릇 `WATERPROOF_PET`·`ADH_WATERPROOF_PVC`·`ARTFABRIC_GRAPHIC`은 삭제표시) |
| P3 | `POSTER_PET_print` | 포스터_PET_출력가 | 〃 | | | 〃 |
| P4 | `POSTER_PVC_print` | 포스터_PVC_출력가 | 〃 | | | 〃 |
| P6 | `POSTER_GRAPHIC_print` | 포스터_그래픽천_출력가 | 〃 | | | 〃 |
| P2 | `POSTER_PAPER_print` | 포스터_매트지_출력가 | `COMP_POSTER_ARTPAPER_MATTE` | 39 | 1 | ✅ (13×3, 900mm까지) |
| P5 | `POSTER_CLEARPVC_print` | 포스터_투명PVC_출력가 | `COMP_POSTER_ADH_CLEAR_PVC` | 52 | 1 | ✅ |
| P7 | `POSTER_LINEN_print` | 포스터_린넨_출력가 | `COMP_POSTER_LINEN_FABRIC` | 52 | 1 | ✅ |
| P7b | `POSTER_LINEN_finishing` | 포스터_린넨_가공가 | `COMP_POSTEROPT_LINEN_FINISH` 린넨 마감가공비 | 5 | 1 | ✅ 차원 `[opt_cd, min_qty]` ↔ 상품 옵션그룹 「마감」 5개 ✅ |
| P8 | `POSTER_OXFORD_print` | 포스터_캔버스옥스포드_출력가 | `COMP_POSTER_CANVAS_FABRIC` 실사 완제품가(캔버스·레더·메쉬·타이벡) | 52 | 4 | ✅ **엑셀 4 code → 라이브 1 그릇 공유**(옛 개별 그릇 삭제표시) |
| P9 | `POSTER_LEATHER_print` | 포스터_레더_출력가 | 〃 | | | 〃 |
| P10 | `POSTER_TYVEK_print` | 포스터_타이벡_출력가 | 〃 | | | 〃 |
| P11 | `POSTER_MESH_print` | 포스터_메쉬_출력가 | 〃 | | | 〃 |
| P24 | `POSTER_PLACARD_print` | 포스터_일반현수막_출력가 | `COMP_POSTER_BANNER_NORMAL` | 80 | 1 | ✅ (16×5) |
| P24b | `POSTER_PLACARD_finishing` | 포스터_현수막_가공가 | `COMP_BANNER_OPTION` 일반현수막 가공옵션 | 6 | 1 | ✅ ↔ 옵션그룹 「가공」 6개 ✅ |
| P24c | `POSTER_PLACARD_addon` | 포스터_현수막_부자재 | `COMP_BANNER_ADDON` | 4 | 1 | ✅ ↔ 옵션그룹 「부자재」 4개 ✅ |
| P25 | `POSTER_MESHPLACARD_print` (라벨이 「구성요소코드/구성요소명」으로 다름) | 포스터_메쉬현수막_출력가 | `COMP_POSTER_BANNER_MESH` | 48 | 1 | ✅ (16×3). 엑셀 메모 "가격테이블 구성안하고 공용으로 사용할 예정" — 뜻 확인 필요. 가공옵션 블록은 code 없음 → 라이브 `COMP_BANNER_MESH_OPTION`(4) · 부자재 `COMP_BANNER_MESH_ADDON`(2) 있음 |

### 3-2. 고정가형(사이즈코드×수량/옵션)

| # | 엑셀 code | 엑셀 name | 라이브 구성요소 | 행 | 공식 | 판정 |
|---|---|---|---|---:|---:|---|
| P12 | `POSTER_FORMBOARD_print` | 포스터_폼보드_출력가 | `COMP_POSTER_FOAMBOARD_BOARD` (보드칼라×사이즈) | 4 | 1 | ✅ 옵션 `OPV_000991/992` ↔ 상품 옵션그룹 「보드칼라」 ✅. 엑셀 A1 열 값은 라이브에 없음(상품 사이즈도 A3·A2만 = 라이브가 기준) |
| P13 | `POSTER_FOAMEX_print` | 포스터_포맥스_출력가 | `COMP_POSTER_FOMEXBOARD_BOARD` (두께×사이즈) | 4 | 1 | ✅ 「보드두께」 ✅ |
| P14 | `POSTER_WOODPANEL_print` | 포스터_나무판넬_출력가 | `COMP_POSTER_FRAMELESS_WOOD` | 2 | 1 | ✅ (A3·A2) |
| P15 | `POSTER_LEATHERPANEL_print` | 포스터_레더아트액자_출력가 | `COMP_POSTER_LEATHER_FRAME` | 6 | 1 | ✅ |
| P16 | `POSTER_HANGINGSCROLL_print` | 포스터_족자_출력가 | `COMP_POSTER_JOKJA` | 5 | 1 | ✅ (추가옵션 "모든사이즈 추가없음" — 옛 `JOKJA_CEILHOOK` 삭제표시) |
| P17 | `POSTER_HANGINGCANVAS_print` | 포스터_캔버스행잉_제작가 | `COMP_POSTER_CANVAS_HANGING` | 3 | 1 | ✅ |
| P17b | `POSTER_HANGINGCANVAS_addon` | 포스터_캔버스행잉_부자재 | `COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER` | 3 | 1 | ✅ ↔ 옵션 「부자재」 `OPV_000995`. ⚠ 같은 값의 `…WOODHANGER_0`(3행·공식 0) **고아 중복** |
| P18 | `POSTER_HANGINGLINEN_print` | 포스터_린넨우드봉_제작가 | `COMP_POSTER_LINEN_WOODBONG` | 3 | 1 | ✅ |
| P18b | `POSTER_HANGINGLINEN_addon` | 포스터_린넨우드봉_부자재 | `COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG` | 3 | 1 | ✅ |
| P19 | `POSTER_PETBANNER_print` | 포스터_PET배너_제작가 | `COMP_POSTER_PET_BANNER` 22,000 | 1 | 1 | ✅ 거치대는 엑셀 메모대로 **추가상품**(`TMPL-000115~117`)으로 이미 처리됨. 옛 `PET_BANNER_STAND_*` 그릇은 삭제표시/고아 |
| P20 | (메쉬배너 블록인데 code가 **`POSTER_PETBANNER_print`로 중복**) | 포스터_PET배너_제작가(복붙) | `COMP_POSTER_MESH_BANNER` 38,000 | 1 | 1 | ⚠ **엑셀 code 오기**로 보임 → `POSTER_MESHBANNER_print`/`포스터_메쉬배너_제작가` 확인 필요 |
| P26 | `POSTER_SHEETCUT_final` | 포스터_시트커팅_제작가 (무광/홀로그램 2행) | `COMP_POSTER_SHEETCUT_MATTE`(6) + `COMP_POSTER_SHEETCUT_HOLO`(3) | 9 | 2 | ✅ 엑셀 1 code → 라이브 상품별 2 그릇(무광시트커팅·홀로그램 시트커팅이 별도 상품) |
| P27 | `POSTER_ACRYLICSTICKER_final` | 포스터_아크릴스티커_제작가 (유광/미러) | `COMP_POSTER_ACRYLSTK_GLOSS`(4) + `…_MIRROR`(4) | 8 | 2 | ✅ 같은 형태 |
| P28 | `POSTER_MINIBOARD_final` | 포스터_미니스탠딩보드_제작가 | `COMP_POSTER_MINI_STANDBOARD` | 15 | 1 | ✅ (3사이즈×5수량) |
| P29 | `POSTER_MINIBANNER_final` | 포스터_미니배너_제작가 | `COMP_POSTER_MINI_BANNER` | 10 | 1 | ✅ |

### 상품뷰어 요소 ↔ 그릇 차원 (포스터)
- 면적형 상품은 `nonspec_yn=Y`(직접입력 200~1200 × 200~3000)이면서 고정 사이즈(A3·A2·A1)도 등록 → 그릇 차원 `[siz_width, siz_height]`와 맞음(엔진이 사이즈코드를 재단치수로 환원). ✅
- 옵션그룹이 곧 가격 축인 곳(폼보드 보드칼라·포맥스 두께·현수막 가공/부자재·린넨 마감·행잉 부자재)은 `opt_cd` 차원으로 전부 대응됨. ✅
- 상품 「소재」 옵션그룹(아트패브릭 `OPT_000236` 그래픽천)은 가격 축 아님(단일 소재).

## 4. 라이브에서 정돈 대상으로 보이는 것 (값은 건드리지 않음)

| 유형 | 대상 | 근거 |
|---|---|---|
| 고아 그릇(공식 0) | `CLR_ACRYL_1.5T` · `COMP_ACRYL_MIRROR3T` · `COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER_0` | 위젯이 절대 못 만나는 단가행 |
| 이중 그릇 | 1.5T 값이 `COMP_ACRYL_CLEAR3T`(mat 387행)와 `CLR_ACRYL_1.5T` 두 곳 | 한쪽만 권위 |
| 이름 불일치 | 엑셀 name(예: 아크릴_투명3T_출력가) vs 라이브 comp_nm(투명아크릴 인쇄가공비) — 전 43건 | 코드는 삭제금지·이름은 변경가능(기초마스터 규칙) |
| 코드 체계 불일치 | 엑셀 `ACRYLIC_*` vs 라이브 `COMP_ACRYL_*` | PK 변경 = 신규 그릇 + 옛 그릇 use_yn=N 재배선 (대공사) |
| 미정 값 | `COMP_ACRYL_PENDING_TBD`(공식 6개·0행) · `COMP_ACRYL_MINIPART_TBD` · 스티커팩 16장 | 실무진 확정 대기 |

## 5. 다음 단계(리드 판단 대기 — 지니 확정 필요)

1. **코드 정합 수준**: (a) 엑셀 code를 라이브 PK로 채택(신규 그릇 생성·재배선·옛 그릇 중단) / (b) 라이브 code 유지 + 이름을 엑셀 name으로 통일 + 매핑표를 정본으로 / (c) 엑셀 code를 라이브 비고(note)에 기록만.
2. **공유 그릇 유지 여부**: PET·PVC·그래픽천이 인화지 그릇을 공유하는 현 구조를 엑셀처럼 4개로 쪼갤지(값 같음 → 금액 영향 0, 관리 편의 문제).
3. **고아 그릇 처분**: 1.5T·미러3T·WOODHANGER_0.
4. **엑셀 오기 3건**: 메쉬배너 code 중복 · 메쉬현수막 라벨/메모 · 스티커팩 빈 블록 → 실무진 회신.
