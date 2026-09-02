# 리드 설계 브리프 — 가격표 code/name 기준 가격구성요소 재정립 (아크릴·스티커·포스터/사인)

> 2026-09-02 · lead-peta. plan → run → sync 레인에 내리는 설계 정본. 대조표 = `COMPMAP-260902.md`(같은 폴더).
> 권위 = `docs/huni/후니프린팅_인쇄상품_가격표_260902_2.xlsx`(**18:56판 = 최신**, 절대경로로 확인. `_1`판 17:32는 아크릴·스티커·포스터사인 code까지, `_2`판이 디지털인쇄비·코팅·접지옵션·인쇄후가공·커팅타공·봉투제작 code를 추가) + 상품마스터 `260822_1` 「계산공식집초안」.

## 0. [HARD] 작업 규약 (레인 공통)

1. **라이브 DB 쓰기 금지.** SELECT 조회·백업·검증만. INSERT/UPDATE/DELETE 및 **UI가 부르는 POST 엔드포인트 스크립트 호출도 금지**(지니 260901·260902 재확인).
2. **등록·수정은 webadmin 실제 화면에서만.** 구성요소 신설 = 「가격구성요소(MD) › + 새 구성요소」 폼(코드 자유입력 50자·차원 이송 위젯) · 단가 = 단가표 그리드 「엑셀 복사 → 셀 붙여넣기」 · 배선 = 가격뷰어 화면. 조작 전후 스크린샷.
3. 손대는 화면은 **가격공식 · 가격구성요소 · 가격뷰어** 셋. 상품뷰어·위젯빌더는 조회(진단)만.
4. 조사 순서: ① 상품뷰어 실화면 → ② 권위 두 권(가격표·상품마스터·시트 끝까지 `max_row/max_column`) → ③ 가격 3층 → ④ 위젯 진단 → ⑤ 코드·DB.
5. **값은 verbatim(공급가·부가세 별도).** LLM 숫자 전사 금지 — 격자 → 붙여넣기용 표는 결정론 스크립트(`build_grid.py` 계열)로 만든다.
6. 쉬운 말로 보고(컬럼명·내부 번호를 문장에 섞지 않음).

## 1. 지니 결정 (2026-09-02)

| 항목 | 결정 |
|---|---|
| 코드 정합 | **가격구성요소를 엑셀 code/name 기준으로 새로 정립**한다(라이브 기존 `COMP_*`는 재배선 후 사용중지, 삭제 금지) |
| 공유 그릇 | **엑셀 code 단위로 분리**(인화지/PET/PVC/그래픽천 4개·옥스포드/레더/타이벡/메쉬 4개·스티커 4개·시트커팅/아크릴스티커는 엑셀대로 1개) |
| 고아 격자(1.5T·미러3T) | 상품마스터·게시 위젯 확인 → 쓰는 상품 없어도 **구성요소만 만들어 둔다** |
| 엑셀 오기 | 실무진 코멘트대로: 타투=**기본비용(셋업) + 세트가 묶음수 적용**(박과 동형) · new 스티커팩=**상품 없음, 이번 범위 제외** · 메쉬배너 code 복붙은 정식 code로 정정 제안(`POSTER_MESHBANNER_print`/포스터_메쉬배너_제작가) 후 확인 |

## 2. 실무진 코멘트 확인 결과 (엑셀 셀 텍스트·색 글자)

| 시트·셀 | 코멘트 | 반영 |
|---|---|---|
| 아크릴 P1 | 「아크릴모든 상품에 적용」(3T 격자) | 3T 격자 그릇 하나를 아크릴 전 상품 공식이 공유 |
| 아크릴 C56·D113 | 「수정없음」(수량할인·카라비너) | 할인테이블 `DSC_ACR_QTY`·카라비너 그릇 값 유지 |
| 스티커 H86 | 「타투스티커 상품은 박처럼 기본비용으로 넣고 세트가격으로 묶음수 적용」 | `STK_TATTOO_setup`(고정금액) + `STK_TATTOO_print`(묶음수 3장 차원) 2그릇 |
| 스티커 D101 | 「아직 상품없음 이거는 나중에 할예정」 | `STK_STICKERPACK_final` 제외(기존 54장 `COMP_STK_PACK` 유지) |
| 스티커 G47·G60·C73 | 「국4절에 인쇄하는 것이 아니기 때문에 판걸이수 상관없음」 | 완칼 계열 그릇에 판형 차원 없음 |
| 포스터 F1·F39·F58 등 | 「코팅포함가」「출력+코팅+가공 포함가」 | 완제품가형(구성요소 1개) 유지 |
| 포스터 L115 | 「사이즈무관 공용」(린넨 가공) | `POSTER_LINEN_finishing` 차원 = 옵션코드(+수량), 사이즈 없음 |
| 포스터 L240·L245 | 족자 천정형고리 「가격테이블 구성안하고 추가상품으로 할예정」「*2개 1세트」 | 구성요소 안 만듦(추가상품 트랙) |
| 포스터 L266 | PET배너 거치대 「추가상품으로 할예정」 | 이미 추가상품 `TMPL-000115~117`로 처리됨 ✅ |
| 포스터 D308 | 메쉬현수막 「가격테이블 구성안하고 공용으로 사용할 예정」 | **지니 확정(260902)**: 메쉬현수막 출력가 격자(`POSTER_MESHPLACARD_print`)는 만들고, 가공옵션 그릇은 따로 만들지 않고 `POSTER_PLACARD_finishing`(일반현수막 가공가)을 메쉬현수막 공식에도 배선(공용). ⚠ 일반현수막 가공가에 「재단만 0원」 행이 없어 위젯에서 재단만을 고르면 매칭 실패 가능 → plan이 확인 항목으로 기록(0원 행 추가 여부는 실무진 확인) |

## 3. 목표 구성요소 목록 (43개 = 44블록 − 스티커팩)

형식: 엑셀 code · 엑셀 name · 가격유형 · 차원(use_dims) · 값 출처 · 현 라이브 그릇 → 재배선 대상 공식/상품.

### 아크릴 (6)
| code | name | 유형 | 차원 | 값 출처 | 대체할 라이브 그릇 | 재배선 공식(상품) |
|---|---|---|---|---|---|---|
| ACRYLIC_CLEAR3T_print | 아크릴_투명3T_출력가 | 단가형 .01 | 자재(MAT_000386)·사이즈가로(이하)·사이즈세로(이하)·수량 | 시트 r4~r17 14×14 | COMP_ACRYL_CLEAR3T(3mm 행 196) | PRF_ACRYL_KEYRING·MAGNET·BADGE·CLIP·SMARTTOK·NAMETAG·HAIRBAND·PRF_CLR_ACRYL(8공식·상품 14종) |
| ACRYLIC_CLEAR15T_print | 아크릴_투명1.5T_출력가 | .01 | 자재(MAT_000387)·가로·세로·수량 | r26~r34 9×9 | CLR_ACRYL_1.5T + CLEAR3T 안의 1.5mm 81행 | 아크릴미니파츠 PRF_ACRYL_MINIPART(현 TBD 그릇 10,000 고정) — **단가 미정 상태이므로 그릇만 만들고 배선은 지니 확인** |
| ACRYLIC_MIRROR3T_print | 아크릴_미러3T_출력가 | .01 | 자재(골드 377·실버 378)·가로·세로·수량 | r42~r50 9×9 | COMP_ACRYL_MIRROR3T(자재 차원 없음) | 상품마스터에 미러3T 상품 없음 · 게시 위젯 없음 → **그릇만 생성** |
| ACRYLIC_TOTAL_finishing | 아크릴_종합_부자재 | .01 | 옵션코드·수량 | r69~r86 | COMP_ACRYL_FINISH(17행·이름만 다름) | 9공식 — **이름 변경으로 처리 가능 여부 plan이 판단**(코드까지 바꾸면 재배선 9건) |
| ACRYLIC_CLEAR8T_print | 아크릴_투명8T_출력가 | .01 | 가로·세로·수량 | r101~r106 6×6 | COMP_ACRYL_COROTTO(36) | PRF_COROTTO_ACRYL·PRF_COROTTO_ACRYL_MTX |
| ACRYLIC_carabiner_final | 아크릴_카라비너_제작가 | 합가형 .02 | 사이즈·수량 | r115~r119 + 할인 D112 | COMP_ACRYL_CARABINER(4) | PRF_ACRYL_CARABINER |

### 스티커 (6 + 제외 1)
| code | name | 유형 | 차원 | 값 출처 | 대체할 라이브 그릇 | 재배선 |
|---|---|---|---|---|---|---|
| STK_KISSCUT_PRINT | 스티커_반칼_제작가 | .01 | 사이즈·자재·수량(+판형 여부 확인) | r4~r46 | COMP_STK_PRINT의 반칼 규격행 | PRF_STK_FIXED → 반칼 계열 9상품(052·053·054·058~063) |
| STK_CUT_PRINT | 스티커_완칼_제작가 | .01 | 사이즈·자재·수량 | r50~r59 | 〃 완칼행 | 낱장 자유형 스티커 055 |
| STK_CUT_CLEAR_PRINT | 스티커_완칼투명_제작가 | .01 | 〃 | r63~r72 | 〃 | 낱장 자유형 투명스티커 056 |
| STK_CUT_LARGE_PRINT | 스티커_완칼대형_제작가 | .01 | 〃 | r76~r85 | 〃 | 대형 자유형 스티커 057 |
| STK_TATTOO_setup | 스티커_타투_기본가 | 고정금액 .03 | (수량만) | r90 | COMP_STK_TATTOO(합산본 333행) | PRF_STK_TATTOO → 타투스티커 067 |
| STK_TATTOO_print | 스티커_타투_제작가 | .01 | 묶음수(3장)·사이즈·수량 | r90~r91 | 〃 | 〃 (박 SETUP+PROC 구조와 동형) |
| ~~STK_STICKERPACK_final~~ | — | — | — | 값 없음 | COMP_STK_PACK 유지 | 제외(상품 없음) |

스티커 공식 `PRF_STK_FIXED`(1개가 13상품 공유)는 **그릇이 4개로 갈리면 공식도 상품군별로 갈라야** 한다(반칼용·완칼용·완칼투명용·대형용). 소량자유형스티커(064·use_yn=N)·합판도무송(별도 시트)은 범위 밖.

### 포스터/사인 (31)
면적형(가로·세로 이하 구간 + 수량): `POSTER_PHOTOPAPER_print`(118 아트프린트) · `POSTER_PAPER_print`(119) · `POSTER_PET_print`(120 방수) · `POSTER_PVC_print`(121 접착방수) · `POSTER_CLEARPVC_print`(122) · `POSTER_GRAPHIC_print`(123) · `POSTER_LINEN_print`(124) · `POSTER_OXFORD_print`(125) · `POSTER_LEATHER_print`(126) · `POSTER_TYVEK_print`(127) · `POSTER_MESH_print`(128) · `POSTER_PLACARD_print`(138) · `POSTER_MESHPLACARD_print`(139).
→ 공유 그릇 `COMP_POSTER_ARTPRINT_PHOTO`(4상품)·`COMP_POSTER_CANVAS_FABRIC`(4상품)을 상품별 그릇으로 분리하고 각 공식 1:1 재배선. 값은 현 라이브 행과 엑셀 격자를 **결정론 diff로 0 차이 확인** 후 붙여넣기.

옵션형(옵션코드·수량): `POSTER_LINEN_finishing`(← COMP_POSTEROPT_LINEN_FINISH) · `POSTER_PLACARD_finishing`(← COMP_BANNER_OPTION) · `POSTER_PLACARD_addon`(← COMP_BANNER_ADDON) · `POSTER_HANGINGCANVAS_addon`(← …CANVAS_HANGING_WOODHANGER; `_0` 고아는 사용중지) · `POSTER_HANGINGLINEN_addon`(← …LINEN_WOODBONG_WOODBONG). 메쉬현수막 가공/부자재는 §2 D308 확인 후.

고정가형(사이즈코드(+옵션)·수량): `POSTER_FORMBOARD_print`(← FOAMBOARD_BOARD·보드칼라 옵션) · `POSTER_FOAMEX_print`(← FOMEXBOARD_BOARD·두께 옵션) · `POSTER_WOODPANEL_print` · `POSTER_LEATHERPANEL_print` · `POSTER_HANGINGSCROLL_print` · `POSTER_HANGINGCANVAS_print` · `POSTER_HANGINGLINEN_print` · `POSTER_PETBANNER_print` · `POSTER_MESHBANNER_print`(code 정정 제안) · `POSTER_SHEETCUT_final`(무광+홀로그램 → 1그릇·자재 차원으로 구분·2공식) · `POSTER_ACRYLICSTICKER_final`(유광+미러 → 1그릇·자재 차원·2공식) · `POSTER_MINIBOARD_final` · `POSTER_MINIBANNER_final`.

## 4. 상품뷰어 요소 ↔ 차원 규칙 (지니 강조)

- 그릇의 차원은 **그 상품의 상품뷰어에 실제 등록된 요소**에서만 고른다(사이즈코드·자재·인쇄옵션·공정·옵션코드·묶음수). 요소가 없는 축을 차원으로 켜면 위젯이 값을 보내지 않아 매칭 실패(0원).
- 직접입력 상품(`nonspec_yn=Y`: 포스터 면적형·아크릴 3T 계열)은 사이즈가로/세로(이하 구간)로, 고정 사이즈 상품은 사이즈코드로.
- 옵션그룹이 가격을 가르는 곳(보드칼라·두께·현수막 가공/부자재·린넨 마감·행잉 부자재·아크릴 고리/가공)은 옵션코드 차원. 옵션이 가격을 안 가르는 곳(반칼 모양·조각수)은 차원에 넣지 않는다.
- ⚠ 확인 항목: 낱장/대형 자유형 스티커의 옵션그룹 「소재」(전용지+엠보코팅 `OPT_000277/278`) — 자재 축과 겹침(적재 규범 U-1). 가격에 얹히는지 위젯 진단으로 확인 후 처분 제안.

## 5. 완료 기준 (acceptance 초안)

1. 43개 구성요소가 엑셀 code/name 그대로 라이브에 존재(화면 등록·스크린샷).
2. 단가행 = 엑셀 격자 verbatim: 결정론 diff 스크립트 **차이 0**(라이브 SELECT vs 엑셀 파싱).
3. 대상 상품(아크릴 14·스티커 13·포스터 28 = 게시 위젯 보유분) 전부 공식이 새 그릇으로 재배선되고, 옛 그릇은 사용중지(삭제 금지·행 보존).
4. **금액 차이 0**: 재배선 전후 대표 조합(상품×사이즈×자재×옵션×수량) 골든 재계산 일치(값이 바뀌지 않는 정돈 작업이므로).
5. 위젯빌더 「가격 진단」: 대상 게시 위젯 전건 PRICE≠0·미매칭 사유 0(기본 선택 + 옵션 1회 변경).
6. 고아 그릇(공식 0개) 0건 — 단, 지니 결정으로 의도적으로 만든 1.5T·미러3T는 예외 목록에 명시.
7. 회신 대기 3건(메쉬현수막 공용 해석·메쉬배너 code·미니파츠 1.5T 단가) 상태가 SPEC에 기록.

## 6. 범위 밖

합판도무송·굿즈 고정가 계열(볼펜·자유형스탠드·명찰GS 본체)·PENDING_TBD 상품(use_yn=N)·new 스티커팩·추가상품 트랙(족자 고리·PET 거치대)·할인테이블 값(「수정없음」).

## 7. 범위 확장 (지니 260902 18:56 · `260902_2`판) — 공정/후가공 시트 15블록

지니 지시: **디지털인쇄비·코팅·접지옵션·인쇄후가공·커팅·타공까지 code/name이 정의됐으니 plan이 함께 체크**한다.

| 시트 | 엑셀 code | 엑셀 name | 라이브 현황(1차 대조) |
|---|---|---|---|
| 디지털인쇄비 | `PRINT_SUPERA3_CMYK` | 디지털인쇄_국4절_흑백칼라 | `COMP_PRINT_DIGITAL_S1` 계열(국4절 판형·인쇄옵션·수량 차원) — 코드 다름 |
| 디지털인쇄비 | `PRINT_WIDE_CMYK` | 디지털인쇄_3절_흑백칼라 | 3절 그릇 존재 여부 확인 |
| 디지털인쇄비 | `PRINT_SUPERA3_SPOT` | 디지털인쇄_국4절_별색인쇄 | 별색(spot_side_cnt 차원) 그릇 확인 |
| 코팅 | `COAT_SUPERA3_Laminating` | 코팅_국4절_라미네이팅 | `COMP_COAT_GLOSSY`·`COMP_COAT_MATTE`(유/무광 2그릇) — 엑셀은 1 code, 유/무광은 공정 차원으로 갈라야 하는지 확인 |
| 코팅 | `COAT_WIDE_Laminating` | 코팅_3절_라미네이팅 | 3절 코팅 그릇 확인 |
| 접지옵션 | `FOLD_CARD_processing` | 접지_카드_접지비 | `COMP_FOLD_*`(카드 접지 4종: HALF·3FOLD·4ACC·4GATE) — 엑셀 1 code ↔ 라이브 4그릇 |
| 접지옵션 | `FOLD_LEAFLLET_processing`(철자 LEAFLLET 그대로) | 접지_리플렛_접지비 | `COMP_FOLD_LEAF_*` |
| 인쇄후가공 | `COMP_PP_CORNER_RIGHT` | 귀돌이 | **라이브 코드 그대로 채택**(9구간 0원 행 실재 — §5 예외 아님, 값 대조) |
| 인쇄후가공 | `COMP_PP_CREASE_1L` / `COMP_PP_PERF_1L` | 오시비 / 미싱비 | 라이브 코드 그대로(줄수 차원 t25 카드와 접점) |
| 인쇄후가공 | `COMP_PP_VARTEXT_1EA` / `COMP_PP_VARIMG_1EA` | 가변텍스트 / 가변이미지 | 라이브 코드 그대로 |
| 커팅타공 | `COMP_CUT_FULL_DIECUT` | 커팅_국4절_완칼 | 라이브 코드 그대로 |
| 커팅타공 | `PUNCHING_processing` | 타공 | `COMP_CUT_PERF_1H6` 등 타공 그릇 — 코드 다름 |
| 봉투제작 | `COMP_ENV_MAKING` | 봉투제작 완제품가 | 라이브 코드 그대로 |

읽는 법: 실무진이 **인쇄후가공·완칼·봉투는 라이브 코드를 그대로 code로 적었고**, 인쇄·코팅·접지·타공은 새 체계 code를 적었다. 즉 이 시트들은 "이름 정합 + 값 대조"가 주고, 새 code인 것만 §1 결정(신설·재배선)을 적용한다. 이 15블록은 원자합산형(디지털인쇄 상품군 전체)의 부품이라 **재배선 영향 범위가 3상품군보다 훨씬 넓다**(디지털인쇄 원자합산 공식 PRF_DGP_* 전부). plan은 ① 영향 공식·상품 수를 먼저 실측해 ② 3상품군(M1)과 공정/후가공(M2)을 마일스톤으로 나누고 ③ M2는 금액 차이 0 증명 범위를 별도로 잡을 것.
