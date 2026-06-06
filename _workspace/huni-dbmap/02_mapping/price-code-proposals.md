# 가격 신규 코드 제안 (round-2 파일럿 5시트 + 비면적 7시트 확대)

평면화로 신설하는 `comp_cd`(가격구성요소)·`frm_cd`(공식)·코드행 네이밍 컨벤션과 근거.
[HARD] 스키마 무변경 — 코드/구성요소/공식 **행 추가**만(컬럼·제약 불변). DB 미적재(CSV 산출).

## 1. 네이밍 컨벤션

| 종류 | 접두 | 패턴 | 예 |
|------|------|------|----|
| 가격구성요소 | `COMP_` | `COMP_{도메인}_{세부}_{옵션}` | `COMP_PRINT_DIGITAL_S1` |
| 가격공식 | `PRF_` | `PRF_{상품/도메인}_{형태}` | `PRF_ENV_MAKING` |
| 코드행 | (부모코드).N | `{UPPER_GROUP}.{seq}` | `PRC_COMPONENT_TYPE.06` |

- 옵션 접미: 단면=`_S1`/양면=`_S2`(규칙②), 후가공 옵션=`_RIGHT/_ROUND/_1L/_2L/_3L/_1EA/_2EA/_3EA`(M-1 차원흡수).
- 별색은 색명 영문화: `WHITE/CLEAR/PINK/GOLD/SILVER`.
- 파일럿 기존 코드(`COMP_GDS_SQMIRROR`, `PRF_GDS_SQMIRROR`)와 동일 컨벤션 — 충돌 없음.

## 2. 신규 comp_cd (32종)

### 2-1. 코팅 (2) — comp_typ=PRC_COMPONENT_TYPE.02 코팅비
| comp_cd | comp_nm | 근거 |
|---------|---------|------|
| `COMP_COAT_MATTE` | 무광코팅비 | 무광/유광 단가 프로파일 상이(차원아닌 comp 분리). 단/양면은 coat_side_cnt |
| `COMP_COAT_GLOSSY` | 유광코팅비 | 〃 |

### 2-2. 디지털인쇄 도수 (2) — comp_typ=.01 인쇄비
| comp_cd | comp_nm | 근거 |
|---------|---------|------|
| `COMP_PRINT_DIGITAL_S1` | 디지털인쇄비(단면) | 단/양면 별 comp(규칙②). 도수(흑백/칼라)는 clr_cd 차원 |
| `COMP_PRINT_DIGITAL_S2` | 디지털인쇄비(양면) | 양면≠단면×2(M-3) |

### 2-3. 별색인쇄 (10) — comp_typ=.01 인쇄비, clr_cd=NULL
| comp_cd | comp_nm | 근거 |
|---------|---------|------|
| `COMP_PRINT_SPOT_WHITE_S1` / `_S2` | 별색인쇄비 화이트(단/양면) | **규칙①/M-2: 별색=공정. clr_cd 매핑=FK위반→comp 분리, clr=NULL** |
| `COMP_PRINT_SPOT_CLEAR_S1` / `_S2` | 별색인쇄비 클리어 | 〃 |
| `COMP_PRINT_SPOT_PINK_S1` / `_S2` | 별색인쇄비 핑크 | 〃 |
| `COMP_PRINT_SPOT_GOLD_S1` / `_S2` | 별색인쇄비 금색 | 〃 |
| `COMP_PRINT_SPOT_SILVER_S1` / `_S2` | 별색인쇄비 은색 | 〃 |

> 별색단가는 `t_proc_processes`(PROC_000007 별색인쇄 + 자식 8~12 화이트/클리어/핑크/금/은)와 **선택**은 연결되나, **단가**는 본 comp가 보유(공정코드는 가격을 들고 있지 않음). 화이트=클리어, 핑크=금=은 단가가 같은 행이 다수이나 자연키8(comp 분리)로 별도 보관(중복 아님).

### 2-4. 아크릴 (3) — comp_typ=.01 인쇄가공비
| comp_cd | comp_nm | 근거 |
|---------|---------|------|
| `COMP_ACRYL_CLEAR3T` | 투명아크릴3T 인쇄가공비 | 면적매트릭스 base, siz_cd=면적 |
| `COMP_ACRYL_CLEAR15T` | 투명아크릴1.5T 인쇄가공비 | 〃 |
| `COMP_ACRYL_MIRROR3T` | 미러아크릴3T 인쇄가공비 | 수식81(=투명×2) data_only값 그대로 보관(파생 동적계산 안 함) |

### 2-5. 인쇄후가공 (14) — comp_typ=.04 후가공비 (합가)
| comp_cd | comp_nm | 근거(M-1 옵션흡수) |
|---------|---------|------|
| `COMP_PP_CORNER_RIGHT` / `_ROUND` | 모서리 직각/둥근 | **자연키 충돌 해소(검증 적발): 직각0 vs 둥근2000** |
| `COMP_PP_CREASE_1L`~`_3L` | 오시 1~3줄 | 줄수 옵션=차원부재→comp 흡수 |
| `COMP_PP_PERF_1L`~`_3L` | 미싱 1~3줄 | 〃 |
| `COMP_PP_VARTEXT_1EA`~`_3EA` | 가변텍스트 1~3개 | 개수 옵션 흡수 |
| `COMP_PP_VARIMG_1EA`~`_3EA` | 가변이미지 1~3개 | 〃 |

### 2-6. 봉투 (1) — comp_typ=.06 완제품비
| comp_cd | comp_nm | 근거 |
|---------|---------|------|
| `COMP_ENV_MAKING` | 봉투제작 완제품가 | 완제품 통가격(규칙⑩). 봉투종류=siz, 소재=mat 차원 |

## 3. 신규 frm_cd (1종)

| frm_cd | frm_nm | frm_typ_cd | 근거 |
|--------|--------|-----------|------|
| `PRF_ENV_MAKING` | 봉투제작 소재/수량별 단가 | FRM_TYPE.02 단순형 | 계산공식집초안 행46 `판매가=[수량행][소재열]`. 완제품가 1 component |

> 코팅·디지털·아크릴·후가공은 **상위 상품의 원자합산형 공식이 참조하는 구성요소 단가**라 시트단위 독립 공식을 만들지 않는다(공식은 상품 매핑 단계에서 부여). 봉투만 완결된 단순형 공식.

## 4. 신규 코드행 (1종) — t_cod_base_codes

| cod_cd | cod_nm | upr_cod_cd | 근거 |
|--------|--------|-----------|------|
| `PRC_COMPONENT_TYPE.06` | 완제품비 | PRC_COMPONENT_TYPE | **D-D 확정·규칙⑩·AWK-7 해소**. 완제품 통가격(비분해) 구성요소 유형. ref-base-codes 미존재→신설. PRD_TYPE.01(상품분류)과 별개 축 |

[HARD] 적재 순서: `PRC_COMPONENT_TYPE.06` 코드행 → `t_prc_price_components`(FK 부모 선존재). 직접 적재 금지 → CSV 산출 또는 후니 코드마스터 등록.

## 5. 재사용/확대 시 주의

- 후가공(접지·제본·커팅·타공)도 동일 `COMP_PP_*` 또는 도메인 접두로 옵션흡수 컨벤션 유지.
- 별색·박 단가는 절대 clr_cd로 매핑 금지(규칙①). 박은 `COMP_FOIL_*`(comp_typ=.05 박형압비)로 별도 신설 예정(박 시트 GAP 해소 후).
- 동일가격 공유(화이트=클리어 등)도 comp 분리 유지(자연키8이 comp 포함, 통합 시 의미 손실).

---

# 비면적 7시트 확대 — 신규 코드 (접지·제본·커팅타공·스티커·합판·명함·엽서북)

신규 component_prices **2154행** / 신규 comp_cd **55종** / 신규 frm_cd **6종** / formula_components 8 / product binding 13.
계산공식집초안(공식 권위) + ref-sizes/materials/products(라이브 실코드 탐색) 기반. M-1 옵션 흡수·규칙④ 합가 적용.

## 6. 신규 comp_cd (55종, 시트별)

### 6-1. 접지옵션 (folding) — 8종, comp_typ=.04 후가공비
| comp_cd | comp_nm | 근거 |
|---------|---------|------|
| `COMP_FOLD_CARD_2H`/`_3H`/`_6CR` | 카드접지 2단/3단/6단 | 계산공식집초안 행30 접지비=[제작수량행]. 단수=comp흡수(M-1). 가로/세로(오시/미싱) 묶음 동일단가→note 보존 |
| `COMP_FOLD_LEAF_HALF`/`_3FOLD`/`_4ACC`/`_4GATE` | 리플렛 반/3단/4단병풍/4단대문 | 리플렛 접지옵션. 카드/리플렛 옵션집합 상이→블록별 comp |

### 6-2. 제본 (binding) — 11종, comp_typ=.04 후가공비
| comp_cd | comp_nm | 근거 |
|---------|---------|------|
| `COMP_BIND_JUNGCHEOL`/`_MUSEON`/`_TWINRING`/`_PUR` | 중철/무선/트윈링/PUR제본 | 행69 제본비=[수량행][제본종류열]. 제본종류=comp흡수(M-1) |
| `COMP_BIND_HC_MUSEON`/`_HC_TWINRING`/`_SSABARI` | 하드커버무선/트윈링/싸바리바인더 | 하드커버 제본(B02) |
| `COMP_BIND_CAL_WALL`/`_DESK220`/`_DESK130`/`_DESKMINI` | 캘린더 벽걸이/탁상220/130/미니 제본 | 캘린더 제본(B03). 삼각대 포함 합가는 binding 시트 밖 |

### 6-3. 커팅타공 (cutting) — 4종
| comp_cd | comp_nm | comp_typ | 근거 |
|---------|---------|----------|------|
| `COMP_CUT_PERF_1H6` | 타공 1구(6mm) 단가 | .04 후가공 | 행22 타공비=[출력매수]×1000. 구수=comp흡수. 2구 단가는 엑셀 공란 |
| `COMP_CUT_FULL_DIECUT` | 완칼(국4절) 인쇄+소재+커팅 합가 | .06 완제품 | 행49 인쇄+커팅+용지. '단면' band=합가단가(규칙④). 출력매수 변동→차원 |
| `COMP_CUT_FULL_PERF_1H6`/`_2H6` | 타공 1구/2구 합가 | .06 완제품 | 타공(합가) F~I열. 헤더택/벽걸이캘린더용 |

### 6-4. 스티커 (sticker-price) — 2종
| comp_cd | comp_nm | comp_typ | 근거 |
|---------|---------|----------|------|
| `COMP_STK_PRINT` | 스티커 규격/소재/수량 단가 | .06 완제품 | 행52 [수량행][출력매수×소재열]. 규격(판수)=siz, 소재묶음=mat 차원. 완칼은 블록별 소재(상품 구분축) |
| `COMP_STK_PACK` | 스티커팩(54장1세트) | .06 완제품 | 행58 [1세트당]. 75x110(SIZ_000068)×수량 |

### 6-5. 합판도무송 (gangpan-sticker) — 1종
| comp_cd | comp_nm | comp_typ | 근거 |
|---------|---------|----------|------|
| `COMP_GANGPAN_PRINT` | 합판도무송 사이즈/소재/수량 단가 | .06 완제품 | 행61 [수량행][사이즈×소재열]. 모양×사이즈mm=siz(비치수 PENDING), 소재묶음=mat |

### 6-6. 명함포토카드 (namecard-photocard) — 25종
| comp_cd | comp_nm | comp_typ | 근거 |
|---------|---------|----------|------|
| `COMP_NAMECARD_{STD/COAT/PEARL/CLEAR/SHAPE/MINISHAPE}_{S1/S2}` | 명함종×면 단가(용지포함) | .06 완제품 | 행33 [수량행][소재×면열]. **명함종이 다르면 같은 q·면도 단가 상이(검증 적발)→명함종+면 흡수(M-1)**. 행39 용지포함 단품가 |
| `COMP_NAMECARD_PREMIUM_{S1/S2}_{MGA/MGB}` | 프리미엄 면×소재군 | .06 완제품 | A군(랑데뷰 등)/B군(린넨 등) 단가차→소재군 가격축 comp흡수 |
| `COMP_NAMECARD_WHITE_{S1W/S2W}_{NOCL/CL}` | 화이트인쇄 면×클리어유무 | .06 완제품 | 별색조합(화이트+클리어 없음/단면/양면) 가격축→흡수. clr 매핑 금지(규칙①) |
| `COMP_NAMECARD_FOIL_{S1/S2}_{STD/HOLO}` | 오리지널박 종이+동판+박 합가 | .06 완제품 | 행38 합가(규칙④). 박종묶음/홀로그램 분리 |
| `COMP_NAMECARD_FOIL_SETUP_{S1/S2}_STD` | 박 동판셋업비(아연판) | .05 박형압 | 기본가(아연판)=수량무관 셋업비. min_qty 공란 |
| `COMP_PHOTOCARD_BULK` | 포토카드 대량제작 | .06 완제품 | 총제작수량×가격 단순 |

### 6-7. 엽서북떡메 (postcard-book) — 4종
| comp_cd | comp_nm | comp_typ | 근거 |
|---------|---------|----------|------|
| `COMP_PCB_{S1/S2}_{20P/30P}` | 엽서북 면×페이지 단가 | .06 완제품 | 행92 [수량행][옵션열]. 사이즈=siz, **페이지(20P/30P)=차원 부재→comp흡수(M-1)**, 면=comp흡수 |

## 7. 신규 frm_cd (6종)

| frm_cd | frm_typ_cd | 근거 |
|--------|-----------|------|
| `PRF_STK_FIXED` | FRM_TYPE.02 단순형 | 스티커 [수량행][소재열]. 규격·소재=component_prices 차원 |
| `PRF_GANGPAN_FIXED` | .02 단순형 | 합판도무송 [수량행][사이즈×소재열] |
| `PRF_NAMECARD_FIXED` | .02 단순형 | 명함 [수량행][소재×면열] 용지포함 |
| `PRF_PCB_FIXED` | .02 단순형 | 엽서북 [수량행][옵션열] |
| `PRF_FOLD_SUM` | FRM_TYPE.01 합산형 | 접지비=구성요소(상위 카드/리플렛 원자합산형 공식의 후가공) |
| `PRF_BIND_SUM` | .01 합산형 | 제본비=구성요소(책자 원자합산형 공식의 제본) |

> 접지/제본은 상위 상품(리플렛/책자)의 **원자합산형 공식이 참조하는 구성요소**다. 본 단계는 시트단위 단가(component_prices)와 대표 공식 헤더·1차 배선만 산출. 상품별 전체 구성요소 조합(인쇄비+용지비+...)은 상품 매핑 단계에서 완성.

## 8. comp_typ 귀속 요약

| comp_typ_cd | 7시트 적용 | 근거 |
|-------------|-----------|------|
| `.04 후가공비` | 접지·제본·타공 단가 | 합산형 공식의 후가공 구성요소(규칙⑩ 경로②) |
| `.05 박형압비` | 명함 박 동판셋업비 | 박=공정(규칙①), 셋업비=박형압 |
| `.06 완제품비` | 완칼합가·스티커·합판·명함·엽서북·포토카드 | 비분해 통가격(규칙⑩ 경로). [고정가형] 시트 |

---

# wave-2 보정 — dbm-validator NO-GO 4건 해소 신규 코드

dbm-validator `03_validation/price-load-validation-wave2.md`가 적발한 과소적재 BLOCKER 2 + dodge MAJOR 2 보정. component_prices 3906→**4020행**(+114).

## 9. 신규 comp_cd (3종) — wave-2

| comp_cd | comp_nm | comp_typ | 근거 |
|---------|---------|----------|------|
| `COMP_TTEOKME` | 떡메모지 단가(완제품가) | .06 완제품 | **[B-1]** postcard-book B03 떡메모지 통째 누락 해소. 사이즈(90x90/70x120)=siz·권당장수(50/100장1권)=bdl_qty·장수=min_qty. +112행 |
| `COMP_PHOTOCARD_SET` | 포토카드(20장1세트) 세트가 | .06 완제품 | **[B-2]** B10 PRD_000024. 6000원/세트. 20장1세트=bdl_qty=20. siz=SIZ_000012(55x86) |
| `COMP_PHOTOCARD_CLEAR_SET` | 투명포토카드(20장1세트) 세트가 | .06 완제품 | **[B-2]** B11 PRD_000025. 8500원/세트. bdl_qty=20 |

## 10. 신규 frm_cd (2종) — wave-2

| frm_cd | frm_typ_cd | 근거 |
|--------|-----------|------|
| `PRF_TTEOKME_FIXED` | FRM_TYPE.02 단순형 | 떡메모지 [수량행][옵션열](행92). 사이즈=siz·권당장수=bdl_qty·장수=min_qty |
| `PRF_PHOTOCARD_FIXED` | .02 단순형 | 포토카드 세트 [세트당 고정단가](행43). 20장1세트=bdl_qty. 일반/투명 2 comp |

formula_components: PRF_TTEOKME_FIXED→COMP_TTEOKME, PRF_PHOTOCARD_FIXED→COMP_PHOTOCARD_SET/_CLEAR_SET.
product binding: PRD_000097→PRF_TTEOKME_FIXED, PRD_000024/025→PRF_PHOTOCARD_FIXED (라이브 실존).

## 11. dodge 해소 — placeholder→실 siz_cd 교체 (발명 회피)

| dodge | 종/행 | 교체 | 근거 |
|-------|-------|------|------|
| **M-1 GANGPAN 정사각** | 12종/120행 | `정사각NxNmm`→SIZ_000212~000223 | 라이브 siz_nm `정사각10x10mm(8EA)` 정규화 정확매칭. (NEA) 면당EA=note "후니확인" |
| **M-1 GANGPAN 직사각** | 14종/140행 | `직사각WxHmm`→SIZ_000224~000249 | 라이브 직사각 실코드(순차 아님, siz_nm 정확매칭). 사이에 비-직사각 코드 끼어있어 매칭 필수 |
| **M-2 STK 400x600** | 1종/6행 | `400x600`→SIZ_000199 | 라이브 실코드 |

**정당 placeholder 유지(라이브 부재 확증)**: GANGPAN 원형11종(직경=의미축 상이)·STK 판수규격 6종(A4(2판)≠일반A4)·CUT 국4절·봉투·아크릴. **dodge 재발 0**: placeholder 생성 전 라이브 siz_nm 정규화 탐색 선행.

---

# 면적 시트 확대 — 포스터사인 신규 코드 + 아크릴 M-1 정정 + 박 GAP 제안

component_prices 4020→**4805행**(+785 포스터). 신규 comp_cd **53종**(포스터) · frm_cd **1종** · product binding 28. 라이브 정확매칭(siz/prd) 무발명.

## 12. 포스터사인 신규 comp_cd (53종)

### 12-1. 메인 완제품가 (COMP_POSTER_<소재>) — comp_typ=.06 완제품비
| comp_cd 패턴 | 대상 | 근거 |
|-------------|------|------|
| `COMP_POSTER_ARTPRINT_PHOTO` … `_BANNER_MESH` (21종) | 포스터 21소재(인화지/매트지/PET/PVC/패브릭/레더/타이벡/메쉬/액자/족자/배너/현수막…) | **실무진 포함항목 통가격(규칙④⑩). 메인=출력+코팅+가공 포함가 1행 완제품비.** 면적/규격=siz, 소재=상품 분기 comp |
| `COMP_POSTER_FOAMBOARD_{WHITE/BLACK}` (2) | 폼보드 보드종(B11 중첩) | 추출결함 보정. 사이즈×보드종. PRD_000129 |
| `COMP_POSTER_FOMEXBOARD_{WHITE3MM/WHITE5MM}` (2) | 포맥스보드(B11 중첩) | PRD_000130 |
| `COMP_POSTER_ACRYLSTK_{GLOSS/MIRROR}` (2) | 아크릴스티커 유광/미러(B27 중첩) | PRD_000142/143. 사이즈=라이브 실코드(290x90=SIZ_000324) |
| `COMP_POSTER_SHEETCUT_{MATTE/HOLO}` (2) | 시트커팅 무광/홀로그램(B27 중첩) | PRD_000140/141 |

### 12-2. 추가옵션 (COMP_POSTEROPT_<블록>_<옵션>) — comp_typ=.06 완제품비(별도 add-on 통가격)
| comp_cd 패턴 | 옵션 | 근거(실무진 셀) |
|-------------|------|----------------|
| `COMP_POSTEROPT_JOKJA_CEILHOOK` | 족자 천정형고리 | K213=6500, L213="*2개1세트"→**bdl_qty=2** |
| `COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER` | 캔버스행잉 우드행거+면끈 | 사이즈별(A4/A3/A2=16000/18000/20000) |
| `COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG` | 린넨우드봉 우드봉+면끈 | 사이즈별(7000/9800/12000) |
| `COMP_POSTEROPT_PET_BANNER_STAND_{IN/OUT_S1/OUT_S2}` | 배너거치대 실내/실외단면/실외양면 | 7000/23000/25000 |
| `COMP_POSTEROPT_BANNER_NORMAL_PROC_{CUTEDGE/PUNCH_4/PUNCH_6/PUNCH_8/DTAPE/BONGSEW}` | 현수막 가공옵션 | 열재단/타공4·6·8/양면테잎/봉미싱(3000~5000). baseline(재단만0)=제외 |
| `COMP_POSTEROPT_BANNER_NORMAL_ADD_{QBANG_4/STRING_4/GAKMOK_STRING_900_4_LE/_GT}` | 현수막 추가옵션 | 큐방/끈/각목(900mm**이하**4000·**초과**8000). **이하/초과 조건이 단가차→슬러그 분리(침묵충돌 방지)** |

- **별색 금지**: 전건 clr_cd=NULL(규칙①). 추가옵션도 통가격 add-on이라 .06.
- **세트**: `*N개 1세트`→bdl_qty(천정형고리=2). baseline(추가없음/출력만 0원)=메인포함이라 적재 제외.

## 13. 포스터 신규 frm_cd (1종)

| frm_cd | frm_typ_cd | 근거 |
|--------|-----------|------|
| `PRF_POSTER_FIXED` | FRM_TYPE.02 단순형 | 면적/사이즈×수량×소재별 완제품가(포함항목 통가격). 단순형=component_prices 직접 룩업. formula_components=대표 COMP_POSTER_ARTPRINT_PHOTO 1배선 |

product binding **28건**(메인 21 + 중첩 서브제품 폼보드/포맥스/아크릴스티커2/시트커팅2 + 1, 전건 라이브 실 prd_cd PRD_000118~145 확증, 무발명).

## 14. 아크릴 M-1 정정 (dodge 해소 — 발명 회피)

| 매칭 | 종 | 처리 | siz_cd |
|------|----|------|--------|
| DIRECT(WxH) | 47 | 라이브 실코드 교체 | SIZ_000336(20x20)·SIZ_000329(20x30)·SIZ_000330(30x30)… 매칭표 `09_load/poster-sign/_acryl_siz_match.csv` |
| REVERSED(HxW만) | 21 | SIZ_PENDING 유지+에스컬레이션 | 의미축 불일치(직접입력형 가로/세로 뒤바뀜) |
| NONE(라이브 부재) | 128 | SIZ_PENDING 등록대기 | 발명 금지 |

검증 적발 47종 = 정정 DIRECT 47종 정확 일치. REVERSED 21·NONE 128은 P-1 에스컬레이션 유지.

## 15. 박(소형/대형) GAP — [RESOLVED] 등급 소멸·면적 환원으로 종결

> [정정 2026-06-07] 당초 "2단 룩업 GAP·코드 신설 보류"였으나, 사용자 KEY DIRECTIVE
> (박등급 A~E=엑셀 한계상 편의표현, 본질 차원 아님)로 **B02⋈B03 등급조인→면적 환원** 종결.
> 권위 설계=`02_mapping/price-foil-matrix-mapping.md`, 산출=`load_price/_foil/*.csv`.

박은 **면적매트릭스형**(실사/아크릴과 동일, `FRM_TYPE.02` 재사용). 등급은 조인 키로만 소멸(DB 0누출).

| 코드 | 유형 | 비고 |
|------|------|------|
| `PRF_FOIL_AREA` | FRM_TYPE.02 | 박 면적·박종·수량 공식. 가공비4+동판비2 배선 |
| `COMP_FOIL_SMALL_GENERAL` / `_SPECIAL` | .05 박형압비 | 소형 일반7·특수3 동일가→각 1 comp |
| `COMP_FOIL_LARGE_GENERAL` / `_SPECIAL` | .05 | 대형 일반6·특수6 동일가→각 1 comp |
| `COMP_FOIL_DIE_SMALL` / `_LARGE` | .05 | 동판(아연판 셋업). 수량무관(min_qty NULL) |
| `SIZ_000722~774` (53 MINT) | 좌표 siz | 박 면적좌표 신규(라이브 부재). search-before-mint: 79좌표 중 26재사용·53신규 |

- component_prices **2143행**(raw 2233 − REVERSED 동일가 collapse 90). 자연키 중복0·가격충돌0·등급누출0.
- 기존 `COMP_NAMECARD_FOIL_*`(명함 임베드 박)과 **별개**(standalone 후가공_박 add-on).
- **잔여 FLAG**: ①공식 바인딩 대상 미확정(standalone 후가공_박 product 부재→빈 CSV, 후니 지정 필요)
  ②53 siz 등록=후니 master-data 결정(준비만) ③REVERSED 5종 의미축 후니 재검토 여지. (상세=mapping 문서 §7)
