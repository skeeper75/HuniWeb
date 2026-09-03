# 실무진 인계 — 가격구성요소 재정립 (카드 t34 · SPEC-PRICECOMP-001)

작성 2026-09-03T15:34:41+09:00 · 작성자 레인(run-huniweb) · 근거는 전부 라이브 실측과 권위 엑셀입니다.

## 0. 역할 재정의 (2026-09-03 · 실무진 요청)

| 영역 | 담당 |
|---|---|
| 가격공식 바인딩(상품↔공식 · 공식↔구성요소) | **실무진** |
| 가격구성요소 사용여부(빼고 넣기) | **실무진** — 옛 것 포함 전부 `use_yn=Y` 로 되돌려 뒀습니다 |
| 신규 43 그릇의 단가표가 권위대로 정확한 것 | **우리(완료)** |

이 재정의에 따라 M6(옛 그릇 사용중지)은 **전건 되돌렸고**, 앞으로 공식·바인딩·사용여부는
건드리지 않습니다.

## 1. 우리가 만든 신규 그릇 43개

전부 `use_yn=Y` · 단가행은 권위 엑셀과 **diff 0** 으로 확인했습니다(§3).

| 코드 | 이름 | 유형 | 차원(use_dims) | 행수 | 권위 출처 | 대체한 옛 그릇 | 현재 배선 공식 |
|---|---|---|---|---|---|---|---|
| `ACRYLIC_CARABINER_FINAL` | 아크릴_카라비너_제작가 | 02 | siz_cd  min_qty | 4 | 아크릴 r115~r119 c1~c2 | COMP_ACRYL_CARABINER | PRF_ACRYL_CARABINER |
| `ACRYLIC_CLEAR15T_PRINT` | 아크릴_투명1.5T_출력가 | 01 | mat_cd  siz_width  siz_height  min_qty | 90 | 아크릴 r26~r35 c1~c11 | CLR_ACRYL_1.5T | PRF_ACRYL_MINIPART |
| `ACRYLIC_CLEAR3T_PRINT` | 아크릴_투명3T_출력가 | 01 | mat_cd  siz_width  siz_height  min_qty | 196 | 아크릴 r4~r18 c1~c15 | COMP_ACRYL_CLEAR3T | PRF_ACRYL_BADGE PRF_ACRYL_CLIP PRF_ACRYL_HAIRBAND PRF_ACRYL_KEYRING PRF_ACRYL_MAGNET PRF_ACRYL_NAMETAG PRF_ACRYL_SMARTTOK PRF_CLR_ACRYL |
| `ACRYLIC_CLEAR8T_PRINT` | 아크릴_투명8T_출력가 | 01 | siz_width  siz_height  min_qty | 36 | 아크릴 r101~r107 c1~c7 | COMP_ACRYL_COROTTO | PRF_COROTTO_ACRYL PRF_COROTTO_ACRYL_MTX |
| `ACRYLIC_MIRROR3T_PRINT` | 아크릴_미러3T_출력가 | 01 | siz_width  siz_height  min_qty | 81 | 아크릴 r42~r51 c1~c10 | COMP_ACRYL_MIRROR3T | (미배선) |
| `ACRYLIC_TOTAL_FINISHING` | 아크릴_종합_부자재 | 01 | opt_cd  min_qty | 24 | 아크릴 r69~r94 c1~c4 | COMP_ACRYL_FINISH | PRF_ACRYL_BADGE PRF_ACRYL_CLIP PRF_ACRYL_HAIRBAND PRF_ACRYL_KEYRING PRF_ACRYL_MAGNET PRF_ACRYL_NAMETAG PRF_ACRYL_NAMETAG_GS PRF_ACRYL_SMARTTOK PRF_ZIBITZ_ACRYL |
| `POSTER_ACRYLICSTICKER_FINAL` | 포스터_아크릴스티커_제작가 | 01 | siz_cd  mat_cd  min_qty | 16 | 포스터사인 r342~r344 c1~c5 | COMP_POSTER_ACRYLSTK_GLOSS + COMP_POSTER_ACRYLSTK_MIRROR | FORM_POSTER_ACRYLICSTICKER PRF_POSTER_ACRYLSTK_GLOSS PRF_POSTER_ACRYLSTK_MIRROR |
| `POSTER_CLEARPVC_PRINT` | 포스터_투명PVC_출력가 | 01 | siz_width  siz_height  min_qty | 52 | 포스터사인 r80~r93 c1~c6 | COMP_POSTER_ADH_CLEAR_PVC | FORM_POSTER_CLEARPVC_PRINT PRF_POSTER_ADH_CLEAR |
| `POSTER_FOAMEX_PRINT` | 포스터_포맥스_출력가 | 01 | opt_cd  siz_cd  min_qty | 6 | 포스터사인 r221~r223 c1~c4 | COMP_POSTER_FOMEXBOARD_BOARD | FORM_POSTER_FOAMEX PRF_POSTER_FOMEXBOARD |
| `POSTER_FORMBOARD_PRINT` | 포스터_폼보드_출력가 | 01 | opt_cd  siz_cd  min_qty | 6 | 포스터사인 r213~r215 c1~c4 | COMP_POSTER_FOAMBOARD_BOARD | FORM_POSTER_FORMBOARD PRF_POSTER_FOAMBOARD |
| `POSTER_GRAPHIC_PRINT` | 포스터_그래픽천_출력가 | 01 | siz_width  siz_height  min_qty | 52 | 포스터사인 r99~r112 c1~c6 | COMP_POSTER_ARTPRINT_PHOTO | FORM_POSTER_GRAPHIC_PRINT PRF_POSTER_ARTFABRIC |
| `POSTER_HANGINGCANVAS_ADDON` | 포스터_캔버스행잉_부자재 | 01 | opt_cd  siz_cd  min_qty  opt_grp:OPT_000283 | 3 | 포스터사인 r251~r253 c10~c13 | COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER | FORM_POSTER_HANGINGCANVAS PRF_POSTER_CANVAS_HANGING |
| `POSTER_HANGINGCANVAS_PRINT` | 포스터_캔버스행잉_제작가 | 01 | siz_width  siz_height  siz_cd  min_qty | 3 | 포스터사인 r251~r252 c1~c4 | COMP_POSTER_CANVAS_HANGING | FORM_POSTER_HANGINGCANVAS PRF_POSTER_CANVAS_HANGING |
| `POSTER_HANGINGLINEN_ADDON` | 포스터_린넨우드봉_부자재 | 01 | opt_cd  siz_cd  min_qty  opt_grp:OPT_000266 | 3 | 포스터사인 r260~r262 c10~c13 | COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG | FORM_POSTER_HANGINGLINEN PRF_POSTER_LINEN_WOODBONG |
| `POSTER_HANGINGLINEN_PRINT` | 포스터_린넨우드봉_제작가 | 01 | siz_cd  min_qty | 3 | 포스터사인 r260~r261 c1~c4 | COMP_POSTER_LINEN_WOODBONG | FORM_POSTER_HANGINGLINEN PRF_POSTER_LINEN_WOODBONG |
| `POSTER_HANGINGSCROLL_PRINT` | 포스터_족자_출력가 | 01 | siz_cd  min_qty | 5 | 포스터사인 r243~r245 c1~c6 | COMP_POSTER_JOKJA | FORM_POSTER_HANGINGSCROLL PRF_POSTER_JOKJA |
| `POSTER_LEATHERPANEL_PRINT` | 포스터_레더아트액자_출력가 | 01 | siz_cd  min_qty | 6 | 포스터사인 r236~r237 c1~c7 | COMP_POSTER_LEATHER_FRAME | FORM_POSTER_LEATHERPANEL PRF_POSTER_LEATHER_FRAME |
| `POSTER_LEATHER_PRINT` | 포스터_레더_출력가 | 01 | siz_width  siz_height  min_qty | 52 | 포스터사인 r156~r169 c1~c6 | COMP_POSTER_CANVAS_FABRIC | FORM_POSTER_LEATHER PRF_POSTER_LEATHER_AP |
| `POSTER_LINEN_FINISHING` | 포스터_패브릭포스터_가공가 | 01 | opt_cd  min_qty | 7 | 포스터사인 r118~r123 c10~c11 | COMP_POSTEROPT_LINEN_FINISH | FORM_POSTER_LINEN FORM_POSTER_OXFORD PRF_POSTER_LINEN |
| `POSTER_LINEN_PRINT` | 포스터_린넨_출력가 | 01 | siz_width  siz_height  min_qty | 52 | 포스터사인 r118~r131 c1~c6 | COMP_POSTER_LINEN_FABRIC | FORM_POSTER_LINEN PRF_POSTER_LINEN |
| `POSTER_MESHBANNER_PRINT` | 포스터_메쉬배너_제작가 | 01 | siz_cd  min_qty | 1 | 포스터사인 권위코드오기(D-3) | COMP_POSTER_MESH_BANNER | FORM_POSTER_MESHBANNER PRF_POSTER_MESH_BANNER |
| `POSTER_MESHPLACARD_PRINT` | 포스터_메쉬현수막_출력가 | 01 | siz_width  siz_height  min_qty | 48 | 포스터사인 r310~r326 c1~c5 | COMP_POSTER_BANNER_MESH | FORM_POSTER_MESHPLACARD PRF_POSTER_BANNER_M |
| `POSTER_MESH_PRINT` | 포스터_메쉬_출력가 | 01 | siz_width  siz_height  min_qty | 52 | 포스터사인 r194~r207 c1~c6 | COMP_POSTER_CANVAS_FABRIC | FORM_POSTER_MESH PRF_POSTER_MESH |
| `POSTER_MINIBANNER_FINAL` | 포스터_미니배너_제작가 | 01 | siz_cd  min_qty | 10 | 포스터사인 r363~r368 c1~c3 | COMP_POSTER_MINI_BANNER | FORM_POSTER_MINIBANNER PRF_POSTER_MINI_BANNER |
| `POSTER_MINIBOARD_FINAL` | 포스터_미니스탠딩보드_제작가 | 01 | siz_cd  min_qty | 15 | 포스터사인 r351~r356 c1~c4 | COMP_POSTER_MINI_STANDBOARD | FORM_POSTER_MINIBOARD PRF_POSTER_MINI_STANDBOARD |
| `POSTER_OXFORD_PRINT` | 포스터_캔버스옥스포드_출력가 | 01 | siz_width  siz_height  min_qty | 52 | 포스터사인 r137~r150 c1~c6 | COMP_POSTER_CANVAS_FABRIC | FORM_POSTER_OXFORD PRF_POSTER_CANVAS |
| `POSTER_PAPER_PRINT` | 포스터_매트지_출력가 | 01 | siz_width  siz_height  min_qty | 39 | 포스터사인 r23~r36 c1~c4 | COMP_POSTER_ARTPAPER_MATTE | FORM_POSTER_PAPER_PRINT PRF_POSTER_ARTPAPER |
| `POSTER_PETBANNER_PRINT` | 포스터_PET배너_제작가 | 01 | siz_cd  min_qty | 1 | 포스터사인 r279~r280 c1~c2 | COMP_POSTER_PET_BANNER | FORM_POSTER_PETBANNER PRF_POSTER_PET_BANNER |
| `POSTER_PET_PRINT` | 포스터_PET_출력가 | 01 | siz_width  siz_height  min_qty | 52 | 포스터사인 r42~r55 c1~c6 | COMP_POSTER_ARTPRINT_PHOTO | FORM_POSTER_PET_PRINT PRF_POSTER_WATERPROOF |
| `POSTER_PHOTOPAPER_PRINT` | 포스터_인화지_출력가 | 01 | siz_width  siz_height  min_qty | 52 | 포스터사인 r4~r17 c1~c6 | COMP_POSTER_ARTPRINT_PHOTO | FORM_POSTER_PHOTOPAPER_PRINT PRF_POSTER_ARTPRINT |
| `POSTER_PLACARD_ADDON` | 포스터_현수막_부자재 | 01 | opt_cd  min_qty  opt_grp:OPT_000004 | 4 | 포스터사인 r287~r292 c13~c14 | COMP_BANNER_ADDON | FORM_POSTER_PLACARD PRF_POSTER_BANNER_N |
| `POSTER_PLACARD_FINISHING` | 포스터_현수막_가공가 | 01 | opt_cd  min_qty  opt_grp:OPT_000003 | 6 | 포스터사인 r287~r293 c10~c11 | COMP_BANNER_OPTION | FORM_POSTER_PLACARD PRF_POSTER_BANNER_N |
| `POSTER_PLACARD_PRINT` | 포스터_일반현수막_출력가 | 01 | siz_width  siz_height  min_qty | 80 | 포스터사인 r287~r303 c1~c7 | COMP_POSTER_BANNER_NORMAL | FORM_POSTER_PLACARD PRF_POSTER_BANNER_N |
| `POSTER_PVC_PRINT` | 포스터_PVC_출력가 | 01 | siz_width  siz_height  min_qty | 52 | 포스터사인 r61~r74 c1~c6 | COMP_POSTER_ARTPRINT_PHOTO | FORM_POSTER_PVC_PRINT PRF_POSTER_ADH_WP |
| `POSTER_SHEETCUT_FINAL` | 포스터_시트커팅_제작가 | 01 | siz_cd  mat_cd  min_qty | 9 | 포스터사인 r333~r335 c1~c4 | COMP_POSTER_SHEETCUT_MATTE + COMP_POSTER_SHEETCUT_HOLO | FORM_POSTER_SHEETCUT PRF_POSTER_SHEETCUT_HOLO PRF_POSTER_SHEETCUT_MATTE |
| `POSTER_TYVEK_PRINT` | 포스터_타이벡_출력가 | 01 | siz_width  siz_height  min_qty | 52 | 포스터사인 r175~r188 c1~c6 | COMP_POSTER_CANVAS_FABRIC | FORM_POSTER_TYVEK PRF_POSTER_TYVEK |
| `POSTER_WOODPANEL_PRINT` | 포스터_나무판넬_출력가 | 01 | siz_cd  min_qty | 3 | 포스터사인 r229~r230 c1~c4 | COMP_POSTER_FRAMELESS_WOOD | FORM_POSTER_WOODPANEL PRF_POSTER_FRAMELESS |
| `STK_CUT_CLEAR_PRINT` | 스티커_완칼투명_제작가 | 01 | siz_cd  mat_cd  min_qty | 30 | 스티커 r63~r69 c1~c6 | COMP_STK_PRINT | PRF_STK_CUT_CLEAR |
| `STK_CUT_LARGE_PRINT` | 스티커_완칼대형_제작가 | 01 | siz_cd  mat_cd  min_qty | 6 | 스티커 r76~r82 c1~c2 | COMP_STK_PRINT | PRF_STK_CUT_LARGE |
| `STK_CUT_PRINT` | 스티커_완칼_제작가 | 01 | siz_cd  mat_cd  min_qty | 30 | 스티커 r50~r56 c1~c6 | COMP_STK_PRINT | PRF_STK_CUT |
| `STK_KISSCUT_PRINT` | 스티커_반칼_제작가 | 01 | siz_cd  mat_cd  min_qty | 1728 | 스티커 r4~r42 c1~c20 | COMP_STK_PRINT | PRF_STK_KISSCUT |
| `STK_TATTOO_PRINT` | 스티커_타투_제작가 | 01 | siz_cd  min_qty | 1 | 스티커 r89~r91 c5~c6 | COMP_STK_TATTOO | PRF_STK_TATTOO |
| `STK_TATTOO_SETUP` | 스티커_타투_기본가 | 03 | min_qty | 1 | 스티커 r89~r90 c1~c2 | COMP_STK_TATTOO | PRF_STK_TATTOO |

기계가 읽을 형태는 `HANDOFF-vessels-43.csv` 에 같은 내용이 있습니다.

## 2. 우리가 이미 바꾼 공식 배선

M4 에서 **33 공식**을 옛 그릇 → 새 그릇으로 재배선했고, 스티커 새 공식 4개(`PRF_STK_CUT` ·
`PRF_STK_CUT_CLEAR` · `PRF_STK_CUT_LARGE` · `PRF_STK_KISSCUT`)를 신설했으며, 타투
(`PRD_000067` 수량 단위 장→세트)와 미니파츠(`PRD_000163` 단가 6,320)를 교정했습니다.
자세한 이력은 `progress.md` §E.2 를 보십시오.

### 실무진 `FORM_*` 재바인딩 현황 (2026-09-03 11:23~14:59 · `huniprinting`)

공식 29개를 신설하고 상품 31개의 바인딩을 `PRF_*` → `FORM_*` 로 **교체**하셨습니다
(덧붙임이 아니라 교체 — 옛 `PRF_*` 공식은 남아 있으나 쓰는 상품이 0 입니다).

새 `FORM_*` 공식이 쓰는 구성요소는 **우리가 만든 새 그릇 그대로**여서, 아래 두 교정이
새 공식에도 그대로 살아 있습니다. 금액도 7상품 대조에서 전건 동일했습니다.

- **D-17** 현수막 인쇄 격자 가로/세로 축 교정 (`POSTER_PLACARD_PRINT` 80행 ·
  `POSTER_MESHPLACARD_PRINT` 48행) + 두 상품 직접입력 범위 교정
- **D-16** 메쉬현수막은 전용 그릇 유지 (구조 제약 — §5)

현재 바인딩: PRD_000009→FORM_ACC_PPCASE · PRD_000118→FORM_POSTER_PHOTOPAPER_PRINT · PRD_000119→FORM_POSTER_PAPER_PRINT · PRD_000120→FORM_POSTER_PET_PRINT · PRD_000121→FORM_POSTER_PVC_PRINT · PRD_000122→FORM_POSTER_CLEARPVC_PRINT · PRD_000123→FORM_POSTER_GRAPHIC_PRINT · PRD_000124→FORM_POSTER_LINEN · PRD_000125→FORM_POSTER_OXFORD · PRD_000126→FORM_POSTER_LEATHER · PRD_000127→FORM_POSTER_TYVEK · PRD_000128→FORM_POSTER_MESH · PRD_000129→FORM_POSTER_FORMBOARD · PRD_000130→FORM_POSTER_FOAMEX · PRD_000131→FORM_POSTER_WOODPANEL · PRD_000132→FORM_POSTER_LEATHERPANEL · PRD_000133→FORM_POSTER_HANGINGCANVAS · PRD_000134→FORM_POSTER_HANGINGLINEN · PRD_000135→FORM_POSTER_HANGINGSCROLL · PRD_000136→FORM_POSTER_PETBANNER · PRD_000137→FORM_POSTER_MESHBANNER · PRD_000138→FORM_POSTER_PLACARD · PRD_000139→FORM_POSTER_MESHPLACARD · PRD_000140→FORM_POSTER_SHEETCUT · PRD_000141→FORM_POSTER_SHEETCUT · PRD_000142→FORM_POSTER_ACRYLICSTICKER · PRD_000143→FORM_POSTER_ACRYLICSTICKER · PRD_000144→FORM_POSTER_MINIBOARD · PRD_000145→FORM_POSTER_MINIBANNER · PRD_000193→FORM_GOODS_MUG · PRD_000217→FORM_GOODS_STAMP

## 3. 단가표 정확성 검증 결과 (2026-09-03)

43 그릇을 권위 붙여넣기표와 셀 단위로 대조했습니다.

| 결과 | 건수 |
|---|---|
| 권위와 **diff 0** | **41** |
| 잉여 2행 — 출처 확인됨 | 2 |
| 권위와 **어긋나는 것** | **0** |

잉여 2쌍의 출처:

| 그릇 | 행 | 등록 | 성격 |
|---|---|---|---|
| `ACRYLIC_TOTAL_FINISHING` | `OPV_001027` 700 · `OPV_001028` 1,700 | 09-03 00:10 | 우리 작업. 아크릴명찰(골드실버) 전용 옵션인데 권위 3열 격자가 그 상품을 따로 적지 않아 누락돼 있던 행. 리드가 「금액 정확 우선」으로 유지 결정 — **회신 대기 4번** |
| `POSTER_LINEN_FINISHING` | `OPV_000520` 0 · `OPV_000831` 800 | 09-03 12:12 | **실무진 추가분**(캔버스패브릭포스터). 우리 작업 아님 |

## 4. 실무진 회신이 필요한 것 8건

| # | 내용 | 막고 있는 것 |
|---|---|---|
| 1 | 메쉬현수막 공용 해석 (§2 D308) | **해소** — 구조 제약으로 공용 불가 확정(§5). 회신이 아니라 **통지**가 필요합니다 |
| 2 | 메쉬배너 code 오기 정정 (`POSTER_MESHBANNER_print` → 정식 code) | 없음(라이브는 이미 정정 code) |
| 3 | 미니파츠 1.5T 단가 | **해소** — 6,320 으로 배선 완료 |
| 4 | 아크릴 부자재 격자에 일자핀 700 · 2구자석 1,700 추가 | 없음(라이브 유지 결정 · §3 참조) |
| 5 | **반칼 격자 규격 3종** — 100×148 이 A6(105×148)인지 · 90×110 이 140×100/100×140 인지 · 아니면 세 규격 행 추가 | **보류 5상품**(`052`·`053`·`054`·`062`·`063`) |
| 7 | **`FOLD_LEAFLLET_processing` 철자** — 리플렛이 `LEAFLLET`(L 하나 더)로 적혀 있습니다. 권위 철자를 그대로 승계해 등록했으니(`FOLD_LEAFLLET_PROCESSING`) **이대로 두는 게 맞는지** 확인 부탁드립니다. 함께: 커팅타공 **r48 옵션코드 2구 칸에 코드 대신 이름**(`2구 6mm 타공`)이 들어가 있습니다 → `PROC_000127` 로 읽었습니다 | 없음(라이브 등록 완료) |
| 8 | **상품에 등록이 없어 못 고르는 열 2건** — ① 디지털인쇄 「흑백(1도)」: `POPT_000008`(단면1도)·`POPT_000009`(양면1도)를 등록한 상품이 **라이브 전체 0건**입니다(디지털인쇄 35상품 전부 단면·양면만 등록). ② 별색 「금색·은색」: `PROC_000011`·`PROC_000012` 등록 상품 0건이고, **`PRD_000022` 금은별색엽서가 별색 공정을 하나도 등록하지 않았습니다.** 값은 권위대로 다 넣었으니 **상품 쪽 등록만 하시면 바로 살아납니다** | 그 열들의 견적(값은 적재됨) |
| 6 | 엑셀 code **45셀 대문자 정정** — 포스터사인 31 · 아크릴 6 · 스티커 3 · 코팅/접지/커팅 5 | 없음(라이브는 전부 대문자 · 위반 0). 다음 판 격자 재산출 때 수동 변환이 반복됩니다 |

## 5. 알아 두셔야 할 구조 제약 — 그릇 하나에 옵션그룹 스코프는 하나

`price_views.py:445 split_scopes` 가 스코프를 dict 로 담아 `opt_grp` 키를 하나만 남기고,
공식의 옵션 축은 붙은 구성요소들 스코프의 **합집합**입니다(`2536-2541`).

그래서 **옵션그룹이 서로 다른 두 상품은 한 그릇을 공유할 수 없습니다.** 공유하면 한쪽 옵션이
전부 걸러져 옵션 축이 통째로 사라집니다(`2782`). 스코프를 비우면 가격은 맞지만 고객 노출
축 라벨이 「가공 / 부자재」 → 「옵션코드」로 퇴화하고 위젯 빌더에 중복 노출이 생깁니다.

메쉬현수막(`OPT_000285`/`OPT_000023`)과 일반현수막(`OPT_000003`/`OPT_000004`)이 이 경우라
**메쉬는 전용 그릇을 유지**했습니다(D-16). 다중 스코프 지원은 개발 요청 별건입니다.

## 6. 축 방향은 상품마다 다릅니다 (D-11 정정 · D-17 의 뿌리)

격자의 가로/세로 방향 권위는 **권위 상품마스터의 「사용자입력」 칸**입니다. 라이브 값이
아닙니다 — 라이브가 이미 뒤집혀 있으면 순환 참조가 됩니다(그것이 D-17 회귀의 원인).

| 상품 | 권위 사용자입력 | 긴 축 |
|---|---|---|
| 아트프린트포스터 `118` | 가로 200~1200 · 세로 200~3000 | **세로** |
| 일반현수막 `138` | 가로 500~5000 · 세로 500~1750 | **가로** |
| 메쉬현수막 `139` | 가로 500~3000 · 세로 500~900 | **가로** |

## 7. 예외로 남겨 둔 그릇

| 그릇 | 사유 |
|---|---|
| `COMP_STK_PRINT` | 보류 5상품이 이 그릇만 씁니다 — 회신 5번 대기 |
| `COMP_BANNER_MESH_OPTION` · `_ADDON` | 메쉬 전용 유지 확정(§5) |
| `COMP_ACRYL_NAMETAG_GS` | 명찰GS 공식 본체로 계속 쓰임 |
| `ACRYLIC_MIRROR3T_PRINT` | 신규 그릇이나 **의도적 고아** — 미러3T 상품·게시 위젯이 없어 그릇만 만들어 둠 |

## 8. 확인만 필요한 항목 (금액 영향 0)

| # | 내용 |
|---|---|
| V-1 | `ACRYLIC_TOTAL_FINISHING` 적용일이 `2026-09-03` 로 형제 그릇(09-02)과 하루 어긋남. 엔진 `as_of` 가 KST 라 현재 정상 인식 |
| V-2 | `PRD_000127` 타이벡 자재 기본 선택이 실행마다 흔들림 — 등록 자재 2건이 `dflt_yn='N'`·`disp_seq=1` 동률. 자재는 가격 축이 아니라 금액 무관 |
| V-3 | `PRD_000163` 미니파츠 자재 `MAT_000567`(투명 원형 양면테잎 10mm)이 메타 축에 없음 — 자재가 아니라 부자재로 보임. 등록 위치 확인 필요 |
| V-4 | 09-03 00:08 `PRD_000136` 행 수정 · 00:10 `ACRYLIC_TOTAL_FINISHING` 24행 재적재의 조작 주체 미상(`django_admin_log` 는 공식 changeform 만 남기고 계정도 하나뿐) |

## 9. 근거 파일

| 무엇 | 경로 |
|---|---|
| 43 그릇 인벤토리 | `_workspace/price-setup/HANDOFF-vessels-43.csv` |
| 권위 붙여넣기표 | `_workspace/price-setup/grid/*.csv` |
| 매핑 원장 | `_workspace/price-setup/m1/mapping-43-trackA.csv` |
| 골든 금액표 | `_workspace/price-setup/golden/golden-before.csv` · `golden-m5.csv` |
| 위젯 진단 | `_workspace/price-setup/golden/widget-diag-m5.csv` |
| 되돌리기 스냅샷 | `_workspace/price-setup/rollback/` |
| 화면 조작 스크린샷 | `_workspace/price-setup/screens/` |
| 전체 이력 | `.moai/specs/SPEC-PRICECOMP-001/progress.md` |

---

## 10. 트랙 B — 공정·후가공 시트 신설 8그릇 (2026-09-03 · card t34)

권위 `후니프린팅_인쇄상품_가격표_260902_2.xlsx` 의 **디지털인쇄비·코팅·접지옵션·커팅타공** 시트에서 8개 그릇을 새로 만들고 단가표를 채웠습니다.
**공식 배선은 하지 않았습니다**(신설 8그릇 전부 `formula_cnt=0`). **옛 그릇은 값·이름·`use_yn` 전부 그대로 두었습니다.**

### 10-1. 만든 그릇 8개

| # | code | 이름 | 유형 | 차원(use_dims) | 단가행 | 권위 위치 | 옛 그릇(값 그대로 둠) | 옛 그릇이 물고 있는 공식 |
|---|---|---|---|---|---:|---|---|---|
| B1 | `PRINT_SUPERA3_CMYK` | 디지털인쇄_국4절_흑백칼라 | 단가형 | 공정·판형사이즈·인쇄옵션·수량 (공정그룹 인쇄) | 212 | 디지털인쇄비 r2 | `COMP_PRINT_DIGITAL_S1` | 14개 (`PRF_DGP_*` 13 + `PRF_BOOK_COVER`) |
| B2 | `PRINT_WIDE_CMYK` | 디지털인쇄_3절_흑백칼라 | 단가형 | 〃 | 212 | 디지털인쇄비 r64 | 〃 (S1 의 3절 행) | 〃 |
| B3 | `PRINT_SUPERA3_SPOT` | 디지털인쇄_국4절_별색인쇄 | 단가형 | 판형사이즈·공정·별색면수·수량 (공정그룹 별색인쇄) | 530 | 디지털인쇄비 r126 | `COMP_PRINT_SPOT_WHITE_S1` | `PRF_DGP_A`, `PRF_DGP_A_FOIL` |
| B4 | `COAT_SUPERA3_LAMINATING` | 코팅_국4절_라미네이팅 | 단가형 | 공정·판형사이즈·코팅면수·수량 (공정그룹 라미네이팅 코팅) | 92 | 코팅 r2 | `COMP_COAT_MATTE`·`COMP_COAT_GLOSSY` | `PRF_DGP_A/A_FOIL/D/E/E_FOIL` (+ MATTE 는 `PRF_BOOK_COVER`) |
| B5 | `COAT_WIDE_LAMINATING` | 코팅_3절_라미네이팅 | 단가형 | 〃 | 92 | 코팅 r34 | 〃 (옛 그릇의 3절 행) | 〃 |
| B6 | `FOLD_CARD_PROCESSING` | 접지_카드_접지비 | 고정금액 | 공정·수량 (공정그룹 접지) | 192 | 접지옵션 r2 | `COMP_FOLD_CARD_2H`(N)·`_3H`(N)·`_6CR` | `_6CR`→`PRF_DGP_C_6CR` · `_2H`→`PRF_FOLD_SUM` |
| B7 | `FOLD_LEAFLLET_PROCESSING` | 접지_리플렛_접지비 | 고정금액 | 〃 | 192 | 접지옵션 r59 | `COMP_FOLD_LEAF_HALF/3FOLD/4ACC/4GATE` 4개 | 넷 다 `PRF_DGP_E`, `PRF_DGP_E_FOIL` |
| B14 | `PUNCHING_PROCESSING` | 타공 | 합가형 | 공정·수량 (공정그룹 타공) | 28 | 커팅타공 r45 | `COMP_CUT_PERF_1H6` | `PRF_DGP_C/C_6CR/D/E/E_FOIL` |

**합계 1,550 단가행 · 권위 대비 누락 0 · 잉여 0 · 값차이 0** (적용일 전부 `2026-09-03`).
값은 권위 엑셀을 프로그램이 직접 읽어 넣었습니다 — 사람이 옮겨 적은 숫자가 한 개도 없습니다.

**배선하실 때**: 옛 그릇 1개가 새 그릇 2개로 갈린 곳이 있습니다(B1/B2 · B4/B5 는 **판형**으로, B6/B7 은 **카드/리플렛**으로, 접지·코팅은 방식이 공정 축으로 들어갔습니다). 어느 공식에 어느 쪽을 물릴지는 그 공식을 쓰는 상품의 판형을 보고 정하셔야 합니다 — 국4절은 `SIZ_000499`(316x467), 3절은 `SIZ_000475`(330x660)입니다.

### 10-2. ⚠ 값은 넣었지만 지금은 고를 수 없는 열 (회신 대기 8번)

권위에 있는 열은 전부 넣었습니다. 다만 아래 두 묶음은 **상품 쪽에 등록이 없어 견적에서 선택되지 않습니다**(금액 결함이 아니라 도달 경로 없음이며, 옛 그릇도 같은 상태였습니다).

| 열 | 필요한 등록 | 지금 상태 |
|---|---|---|
| 디지털인쇄 흑백(1도) 단면·양면 | 상품 인쇄옵션에 `POPT_000008`·`POPT_000009` | 라이브 전체 등록 0건 |
| 별색 금색·은색 단면·양면 | 상품 공정에 `PROC_000011`·`PROC_000012` | 등록 0건 · `PRD_000022` 금은별색엽서는 별색 공정 자체가 없음 |

### 10-3. ⚠ 타공 — 옛 그릇과 값 넣는 방식이 다릅니다

- 옛 `COMP_CUT_PERF_1H6`: 18행 **전부 `PROC_000126`(1구)** 에 넣고, 1구/2구는 상세파라미터 `{"구수": 1|2}` 로 구분.
- 권위·새 그릇: 열마다 공정을 따로(`PROC_000126` 1구 / `PROC_000127` 2구), 구수 칸은 비움.
- 상품 등록도 두 공정으로 갈려 있습니다(`PROC_000126`→`PRD_000045`·`PRD_000110` · `PROC_000127`→`PRD_000111`).
- 옛 18행 값은 **전부 권위 1구/2구 열에 그대로** 있었습니다(어긋난 값 0). 수량구간은 옛 9개 → 권위 14개(6,000~10,000 추가).
- 옛 그릇은 공식 5개가 물고 있어 **저희가 손대지 않았습니다.** 정리 여부는 실무진 판단입니다.

### 10-4. 상세파라미터 칸을 비운 이유

별색·코팅 그릇의 단가표에는 「앞면별색/뒷면별색」·「앞면코팅/뒷면코팅」 칸이 있습니다. **비워 두었습니다.**
근거 둘: ① 옛 그릇이 그렇게 쓰고 있습니다(`COMP_PRINT_SPOT_WHITE_S1` 530행 · `COMP_COAT_MATTE` 230행 전부 비어 있음). ② 엔진은 이 칸이 비면 「제약 없음」으로 보고, 채우면 **선택값이 그 칸을 정확히 실어와야만** 매칭합니다(`catalog/pricing.py` `_row_matches`) — 비우는 쪽이 안전합니다. 면수는 별도의 「별색면수/코팅면수」 축이 담당합니다.

### 10-5. 표 밖이라 그릇에 담을 수 없는 것

권위 커팅타공 r64·r65: 「1구는 1000장당 10,000원씩 올립니다 / 2구는 1000장당 20,000원씩 올립니다」.
단가표는 10,000장까지만 덮습니다. 그 위 구간은 **증가식**이라 단가행으로 표현할 자리가 없습니다 — 위젯/엔진 쪽 처리가 필요합니다.
같은 모양이 기존 블록에도 있습니다: 귀돌이 「100장당 1,000원씩」(인쇄후가공 r19) · 오시·미싱 「1,000장당 20,000원씩」(r41).

### 10-6. 기존 7블록 대조 결과 — 값은 전부 맞고, 구간이 모자랍니다

전체 표는 `_workspace/price-setup/t34b/P4-DIFF-260903.md`. **저희는 기존 그릇을 하나도 바꾸지 않았습니다.**

- **겹치는 모든 칸에서 값차이 0** — 권위와 라이브가 다른 값을 든 칸은 없습니다.
- ⚠ **6,000~10,000장 5개 구간이 통째로 비어 있습니다**(귀돌이·오시·미싱). `min_qty` 는 「이상」이라 그 구간 주문은 5,000 구간 값으로 계산됩니다 — 10,000장이면 귀돌이 **101,000 → 51,000**, 오시·미싱 1줄 **205,000 → 105,000**.
- ⚠ **구간 하한이 상한으로 들어간 것 2건** — 귀돌이 권위 `101~300`(4,000)이 라이브엔 `min_qty=300` 이라 101~299 가 100 구간(2,000)으로 떨어집니다. 미싱 `301~500`(17,000)도 같은 모양(`min_qty=500`).
- ⚠ **이름 2건** — `COMP_CUT_FULL_DIECUT`(라이브 「커팅 완제품가 완칼(모양엽서·라벨택)」 vs 권위 「커팅_국4절_완칼」) · `COMP_ENV_MAKING`(「봉투제작(합판)」 vs 「봉투제작 완제품가」). 라이브 이름이 정보가 더 많아, 바꾸신다면 **기존 이름을 비고로 옮기는 것**을 함께 권합니다.
- ⚠ **유형 표기 3건** — 권위 제목이 「(합가)」인데 라이브는 고정금액입니다(귀돌이·오시·미싱). 같은 시트의 타공은 합가가 맞습니다.
- ✅ 가변텍스트·가변이미지·완칼(국4절)·봉투제작은 수량구간까지 **완전 일치**.
- 봉투 60행 중 20행이 **09-03 자 수정**(나머지 40행 07-07)입니다 — 실무진이 오늘 레자크 2종을 분리하신 것으로 보이고, **그 20행도 권위와 값차이 0** 입니다.

### 10-7. 저희가 확인하지 못한 것

- 신설 8그릇으로 **실제 견적을 돌려보지 않았습니다.** 아직 어느 공식도 물지 않아 계산할 대상이 없습니다. 배선 후 검산이 필요합니다.
- 기존 7블록의 「돈이 새는 구간」은 단가행 커버리지 + 엔진 코드(`pricing.py:30·54·204`)로 낸 결론이며, 라이브 견적으로 재현하지는 않았습니다.
- 별색 그릇(530행)의 **저장 직후 화면 갈무리 1장**이 시간초과로 남지 않았습니다(적재 전 화면은 있음). 라이브 재실측으로 530행 값차이 0 은 확인했습니다.
