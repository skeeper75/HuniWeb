# 전 상품마스터 시트 OPTION / TEMPLATE / CONSTRAINT 후보 인벤토리 (OTC Extract)

> **목적:** 11개 상품마스터 시트의 옵션성 컬럼을 **OPTION(이 상품의 속성)·TEMPLATE(별도 생산·배송 독립 상품)·CONSTRAINT(교차축 조건규칙)** 3분류로 전수 추출한 후보 인벤토리. round-6 CPQ widening. 사슬 인스턴스화(option_items 코드)는 다음 단계.
>
> **상태/이력** 작성 2026-06-09 · WIP · `dbm-option-mapper` 산출. DB 미적재(실 INSERT/DDL = 인간 승인).
> **권위 입력(인용·발명 금지):** `06_extract/<slug>-l1.csv`(엑셀 명시값, 본 문서의 모든 후보는 실제 L1 컬럼/값 인용) · `10_configurator/option-vs-template-guide.md`(OPTION vs TEMPLATE 판별 기준) · `attribute-entity-map.md`(13시트 속성→엔티티 지도, 재사용). 판별 기준 한 문장 = **"주문 시 별도로 생산·포장·배송되는 독립 상품인가? → 예=TEMPLATE / 아니오=OPTION."**
> 식별자/컬럼/코드/sel_typ = English, 설명 = Korean. 불확실 = `[CONFIRM]`.
>
> **범례:** sel_typ = `SEL_TYPE.01`(택1) / `SEL_TYPE.02`(택N). 환원 = OPTION이 가리키는 차원(size=`.01`·material=`.03`·process=`.04`·print=`.06`·set=`.07`·bundle=`.05`) 또는 자재+공정 BUNDLE. **scope 외(비상품):** map(→t_prd_product_categories)·pangeori(판걸이수 가격축 ref)·calc-formula-draft(→t_prc_*) — 옵션 레이어 대상 아님.

---

## 1. digital-print (36상품) — 옵션 표현력 최대

L1 컬럼·값 권위: `digital-print-l1.csv`.

### OPTION 후보
| option_group | sel_typ | L1 컬럼 | member 값 샘플(실측) | 환원 |
|---|---|---|---|---|
| OG-SIZE | 01 mand | `사이즈(필수)` | 73x98 / 98x98 / 100x150 / 148x210 mm | dimension size(.01) |
| OG-JONGI | 01 mand | `종이(필수)` | 아트250 / 아트300 / 투명PET 260g / 큐리어스스킨 블랙 270g / `*별도설정` | dimension material(.03) |
| OG-DOSU | 01 mand | `인쇄(옵션)` | 단면 / 양면 | dimension print(.06 opt_id) |
| OG-BYEOLSAEK | **02** (max 5) | `별색인쇄(옵션)_화이트/클리어/핑크/금색/은색` | 화이트인쇄(없음/단면/양면) | process(.04 PROC_000007 family, clr_cd=NULL) |
| OG-COATING | 01 | `코팅(옵션)` | 무광코팅(단/양면) / 유광코팅(단/양면) / 코팅없음 | process(.04) |
| OG-CUTTING | 01 | `커팅(옵션)` | 자유형 / 한쪽라운딩 / 원형 / 물방울 | process(.04) |
| OG-FOLD | 01 | `접지(옵션)` | 2단가로/세로접지 / 3단접지 / 6단오시·미싱접지 | process(.04) + **param(접지 사이즈연동)** |
| OG-MOSEORI | 01 | `후가공(옵션)_모서리` | 직각 / 둥근 | process(.04) |
| OG-HUGAGONG | **02** (max 4) | `후가공(옵션)_오시/미싱/가변(텍스트)/가변(이미지)` | 오시/미싱: 없음·1·2·3줄 | process(.04) + **param(줄수·개수)** |
| OG-BAK | 01 | `박(앞면)/박(뒷면)/형압(옵션)_박/형압 가공` | 박(없음/있음) / 형압(없음/음각/양각) | process(.04 composite 박033·형압050) |
| OG-BAKCOLOR | 01 (박 자식) | `..._박칼라` | 금유광·은유광·동박·먹유광·청박·적박·홀로그램·트윙클 | process(.04 박색상, **박 선택시만**) |

### TEMPLATE 후보 ✅ (보유)
L1 `추가상품(옵션)_추가상품` 실측값 = **봉투류 별도 상품**:
- 고정 SKU: `카드봉투(블랙) 165x115 mm 50장` / `카드봉투(화이트) 165x115 mm 50장` / `OPP접착봉투 110x160 mm 50장` / `트레싱지봉투 160x110 mm 20장` / `OPP비접착봉투 110x160 mm 50장`
- **본체연동 동적**: `엽서봉투 ★사이즈선택 : 100x150` / `봉투 ★사이즈선택 : 86x120 / 76x120 / 76x100`
- **판별 근거:** 봉투는 엽서와 별도 생산·포장·배송되는 독립 상품(자기 prd_cd·size·qty) → TEMPLATE. `★사이즈선택`=본체 size 연동 동적 template(설계 GAP-B). base 봉투 prd_cd 라이브 실재(PRD_000001/002/281~283).

### CONSTRAINT 후보
| 조건 → 결과 | 근거(L1 실측) |
|---|---|
| 박칼라 enabled only if `박/형압 가공`=박(있음) | 박칼라 16종은 박 자식(계층종속) — postcard §5.2(c) |
| 형압(음각/양각) 선택 시 박칼라 비활성 (형압=별트리) | `박/형압 가공` 단일 컬럼에 박·형압 혼재 |
| 코팅 enabled only if 종이두께 ≥ 180g | L1 코팅값 `★종이두께선택시 : 180g이상 코팅가능` (자재→후가공 조건) |
| 접지 선택 시 size는 명시 후보로 제약 | 접지값 내 `★사이즈선택 : 150x100 / 135x135 / 170x110` |
| 별색×도수 호환 (양면별색은 양면인쇄 시만) | 화이트인쇄(양면)=인쇄 양면 의존 `[CONFIRM]` |

---

## 2. sticker (16상품)

L1 권위: `sticker-l1.csv`.

### OPTION 후보
| option_group | sel_typ | L1 컬럼 | member 값 샘플 | 환원 |
|---|---|---|---|---|
| OG-SIZE | 01 mand | `사이즈(필수)` | A6/A5/A4/A3/A2 / 400x600 / 100x140 mm | size(.01) |
| OG-JONGI | 01 mand | `종이(필수)` | 유포·비코팅·미색·무광코팅·유광코팅·투명·홀로그램스티커 | material(.03) |
| OG-DOSU | 01 mand | `인쇄(옵션)` | 단면 (양면 없음) | print(.06) |
| OG-CUTTING | 01 | `커팅(옵션)` | 반칼(자유형) / 완칼(자유형) / 원형 25~50mm (ea수 명시) | process(.04) + **param(칼선·ea)** |
| OG-JOGAK | 01 | `조각수(옵션)` | `*최대20조각` / `*최대40조각` / 5~10조각 | process(.04) + **param(조각수 N)** |

> 코팅 컬럼 = 값 없음(스티커는 종이가 코팅 흡수). 후가공 가변(텍스트/이미지) 2컬럼 존재(digital-print와 동형 OG-HUGAGONG 02).

### TEMPLATE 후보
**TEMPLATE 없음.** `추가상품(옵션)_추가상품` 컬럼은 존재하나 전 행 값 공란(실측). add-on 별도 상품 없음.

### CONSTRAINT 후보
| 조건 → 결과 | 근거 |
|---|---|
| 조각수 max = 자유형/도무송 커팅일 때만 의미 | 커팅(원형 25~50mm)은 ea 고정·조각수 무의미 |
| 원형 N mm 커팅 선택 시 ea(수율) 고정 | 커팅값 `원형 25mm (24ea)` 등 — ea가 가격·수량 연동 |

---

## 3. booklet (12상품) — CONSTRAINT 풍부

L1 권위: `booklet-l1.csv`. 내지/표지 2축.

### OPTION 후보
| option_group | sel_typ | L1 컬럼 | member 값 샘플 | 환원 |
|---|---|---|---|---|
| OG-NAEJI-JONGI | 01 mand | `내지종이(필수)` | 몽블랑240 / 백모조120 / `*별도설정` | material(.03) |
| OG-NAEJI-DOSU | 01 mand | `내지인쇄(필수)` | 양면 / 단면 | print(.06) |
| OG-PYOJI-JONGI | 01 mand | `표지종이(필수)` | 전용지 / 레더(화이트) / 스노우300 / `*별도설정` | material(.03) |
| OG-PYOJI-DOSU | 01 mand | `표지인쇄(필수)` | (표지인쇄) | print(.06) |
| OG-COATING | 01 | `표지옵션_표지코팅` | 코팅없음 / 무광코팅(단면) / 유광코팅(단면) | process(.04) |
| OG-COVER | 01 | `표지옵션_투명커버` | 투명커버없음 / 유광투명커버 / 무광투명커버 | process(.04) |
| OG-BAK | 01 | `박(표지)/형압_박/형압가공` | 박(없음/있음) / 형압(없음/음각/양각) | process(.04 composite) |
| OG-BAKCOLOR | 01 (박자식) | `..._박칼라` | 금유광·은유광·먹유광·동박·적박·청박·홀로그램·트윙클 | process(.04) |
| **GRP-BOOK-제본** | 01 mand (택일) | `제본(필수)` | 중철·무선·PUR·트윈링·하드커버무선·하드커버트윈링·떡제본 | process(.04 제본, excl_group 흡수) |
| OG-BANGHYANG | 01 | `제본_제본방향` | 좌철 / 상철 | process(.04 param) |
| OG-MYEONJI | 01 | `제본_면지` | 화이트·블랙·그레이·인쇄면지 | material **vs** process `[CONFIRM]` |
| OG-RINGCOLOR | 01 | `제본_링컬러` | 화이트링·블랙링·메탈링·D링 | process(.04 color-chip UI) |
| OG-BINDERRING | 01 | `제본_바인더링` | D링 / D링(31/42/56mm) | process **vs** set `[CONFIRM]` |
| OG-PACK | 01 | `개별포장(옵션)` | 개별포장없음 / 수축포장 | GAP-OPT(포장 차원 부재) |

### TEMPLATE 후보
**TEMPLATE 없음.** `추가상품` 컬럼 없음(헤더 부재).

### CONSTRAINT 후보 (풍부)
| 조건 → 결과 | 근거(L1 실측값) |
|---|---|
| 링컬러 enabled only if 제본=트윈링제본/하드커버트윈링제본 | 링컬러=링제본 부속 |
| 바인더링 ★사이즈선택은 A4 선택시만 | 바인더링값 `★사이즈선택 : A4선택시` |
| 인쇄면지 enabled only if 제본=하드커버링책자 또는 레더링바인더 | 면지값 `★인쇄면지는 하드커버링책자와/레더링바인더만 있음` |
| 박칼라 enabled only if 박/형압가공=박(있음) | 박 계층종속 |
| 내지페이지 MIN/MAX/STEP (옵션 아님, page_rule) | `내지페이지(필수)_최소/최대/증가` |
| 표지코팅 자재 의존 disable | material→pcs disable (Red 캐스케이드) |

---

## 4. photobook (1상품)

L1 권위: `photobook-l1.csv`. booklet 동형(단일 상품).

### OPTION 후보
| option_group | sel_typ | L1 컬럼 | member 값 | 환원 |
|---|---|---|---|---|
| OG-NAEJI-JONGI | 01 | `내지종이` | 몽블랑130 | material(.03) |
| OG-NAEJI-DOSU | 01 | `내지인쇄` | 양면 | print(.06) |
| GRP-PYOJITYPE | 01 mand (택일) | `표지타입(필수)` | 하드커버 / 레더하드커버 / 소프트커버 | process/option(.04) |
| OG-PYOJI-JONGI | 01 | `표지종이사양` | 아트250+무광코팅 / 레더 | material(.03) |
| OG-PYOJI-DOSU | 01 | `표지인쇄사양` | 단면 | print(.06) |
| OG-JEBON | 01 | `제본사양_제본` | PUR | process(.04) |
| OG-MYEONJI | 01 | `제본사양_면지` | 그레이 | material/process `[CONFIRM]` |

### TEMPLATE 후보
**TEMPLATE 없음.**

### CONSTRAINT 후보
| 조건 → 결과 | 근거 |
|---|---|
| 책등 = 페이지수 함수(앱계산, 옵션 아님) | `제본사양_책등` 값 `10 / 12 / 14 /16`, `4 / 6 / 8 / 10 / 12 / 14` = 페이지구간별 책등 |
| 표지타입 → 제본 호환 | 하드커버=특정 제본만 `[CONFIRM]` |
| 내지페이지 MIN/MAX/STEP (page_rule) | `내지페이지(편집기)_최소/최대/증가` |

---

## 5. calendar (5상품) — CONSTRAINT 명시·TEMPLATE 보유

L1 권위: `calendar-l1.csv`.

### OPTION 후보
| option_group | sel_typ | L1 컬럼 | member 값 샘플 | 환원 |
|---|---|---|---|---|
| OG-SIZE | 01 mand | `사이즈(필수)` | (캘린더 크기 13종) | size(.01) |
| OG-JONGI | 01 | `종이사양` | 스노우지 250g(3절) / 몽블랑 190g(3절) / `*별도설정` | material(.03) |
| OG-DOSU | 01 mand | `인쇄(필수)` | 양면 / 단면 | print(.06) |
| OG-JANGSU | 01 mand | `장수(필수)` | `4(8P)/8(16P)/12(24P)/16(32P)` 등 | page_rule/products 범위(옵션 아님 — counter) |
| OG-SAMGAKDAE | 01 | `캘린더가공_삼각대컬러` | 삼각대(그레이) / 삼각대(블랙) | process/material(.04, color-chip) |
| **GRP-CAL-가공** | 01 mand (택일) | `캘린더가공_캘린더가공` | 가공없음(재단만)·우드거치대·1구타공+끈·고리형트윈링제본·2구타공+끈·제본없음 | process(.04, **자재+공정 BUNDLE**) |
| OG-RINGCOLOR | 01 | `캘린더가공_링칼라` | 블랙 / `★고리형트윈링제본선택시만 : 링칼라선택` | process(.04, **조건부**) |
| OG-PACK | 01 | `개별포장(옵션)` | 개별포장없음 / 수축포장 | GAP-OPT |

### TEMPLATE 후보 ✅ (보유)
L1 `추가상품(옵션)_추가상품` 실측값:
- 고정 SKU: `캘린더봉투 240x230 mm 10장` / `캘린더봉투 150x310 mm 10장`
- 본체연동 동적: `캘린더봉투 ★사이즈선택 : 130x220` / `220x145`
- **판별 근거:** 캘린더봉투=별도 생산·배송 독립 상품(봉투 base prd_cd + size·qty) → TEMPLATE. 라이브 TMPL-000004~009 봉투와 동형.

### CONSTRAINT 후보
| 조건 → 결과 | 근거(L1 명시값) |
|---|---|
| 링칼라 enabled only if 캘린더가공=고리형트윈링제본 | 링칼라값 `★고리형트윈링제본선택시만 : 링칼라선택` (L1 명시) |
| 1구/2구타공+끈 선택 시 끈 자재 동반(BUNDLE) | 가공값 `1구타공+끈`·`2구타공+끈` |
| 삼각대컬러 = 거치형 가공 의존 `[CONFIRM]` | 삼각대=탁상형 캘린더 가공 |

---

## 6. design-calendar (5상품) — TEMPLATE 보유(우드거치대 포함)

L1 권위: `design-calendar-l1.csv`. calendar와 동형이나 가공이 단순.

### OPTION 후보
| option_group | sel_typ | L1 컬럼 | member 값 | 환원 |
|---|---|---|---|---|
| OG-SIZE | 01 mand | `사이즈(필수)` | (사이즈) | size(.01) |
| OG-JONGI | 01 | `종이사양` | 몽블랑 190g / 몽블랑 190g(3절) | material(.03) |
| OG-DOSU | 01 | `인쇄사양` | 양면 / 단면 | print(.06) |
| OG-PAGE | 01 | `페이지사양` | 30P / 26P / 12P / 13P | page_rule(counter, 옵션 아님) |
| GRP-CAL-가공 | 01 | `캘린더사양_캘린더가공` | 삼각대(그레이)·삼각대(블랙)·고리형트윈링제본 | process(.04 BUNDLE) |
| OG-RINGCOLOR | 01 | `캘린더사양_링칼라` | 블랙 | process(.04, 조건부) |
| OG-PACK | 01 | `개별포장(옵션)` | (값 공란) | GAP-OPT |

### TEMPLATE 후보 ✅ (보유)
L1 `추가상품_추가상품` 실측값:
- 캘린더봉투 고정/동적 (calendar와 동일): `캘린더봉투 240x230 mm 10장` / `150x310 mm 10장` / `★사이즈선택 : 220x145 / 130x220`
- **`우드거치대`** = 별도 거치 상품 → TEMPLATE 후보(base 거치대 prd_cd `[CONFIRM]`)
- **판별 근거:** 봉투·우드거치대 모두 별도 생산·배송 독립 상품. 단 우드거치대가 GRP-CAL-가공 내 `우드거치대`(가공·OPTION)와 의미 충돌 가능 → `[CONFIRM]` 가공(본체 일체) vs 추가상품(별도 거치대) 구분.

### CONSTRAINT 후보
| 조건 → 결과 | 근거 |
|---|---|
| 링칼라 enabled only if 캘린더가공=고리형트윈링제본 | calendar 동형(L1 패턴) |

---

## 7. silsa (29상품·일반현수막) — 혼합 컬럼·BUNDLE

L1 권위: `silsa-l1.csv` + `option-vs-template-guide.md §실사`. (`추가` 컬럼 = embedded newline으로 헤더 일부 절단, guide 권위 사용.)

### OPTION 후보
| option_group | sel_typ | L1 컬럼 | member 값 | 환원 |
|---|---|---|---|---|
| OG-SIZE | 01 (규격행) | `사이즈(필수)` | 규격 33종 + 사용자입력 | size(.01) + 비규격 토글 |
| (비규격) | — products 범위 | `비규격(최소/최대)_가로/세로` | 가로/세로 min/max | products(nonspec_w/h) — 옵션 아님 |
| OG-SOJAE | 01 mand | `소재(필수)` | 현수막 소재 19종 | material(.03) |
| OG-BYEOLSAEK | 01 | 화이트별색(옵션) | 화이트 별색 | process(.04) |
| OG-COATING | 01 | 코팅(옵션) | 코팅 | process(.04) |
| **OG-GAGONG** | 01 mand (택일) | `가공(옵션)` 20종 | 봉미싱·타공(4/6/8)·열재단·양면테입 | process(.04, **자재+공정 BUNDLE**) + **param(타공 구수)** |
| **OG-CHUGA(혼합)** | 01 | `추가(옵션)` 13종 | 끈·큐방·각목 | **복합 item_seq**: 끈=process(.04 081) / 각목=set(.07) |

### TEMPLATE 후보 (혼합 — 같은 `추가` 컬럼에서 갈림)
- 끈·큐방·각목 = **OPTION**(현수막에 붙는 부착 자재, 같은 주문라인)
- 배너거치대·우드행거·거치대 = **TEMPLATE 후보**(별도 생산·배송 독립 상품) — guide §실사 명시
- **판별 근거:** 같은 "추가" 컬럼이 끈=option(붙는 자재) vs 거치대=template(독립 SKU)로 갈림. 별도 생산·배송 여부가 판별자. (일반현수막 v2 적재본은 끈/큐방/각목 OPTION만 — 거치대류는 행잉포스터/족자 상품군에서 재판별.)

### CONSTRAINT 후보
| 조건 → 결과 | 근거 |
|---|---|
| 각목규격 ↔ 세로 정합 (R-GAKMOK-HEIGHT) | 각목 길이=현수막 세로 함수 — banner §5.2 |
| 비규격 가로/세로 = min~max 범위 내 (R-SIZE-NONSPEC) | `비규격_가로/세로` (연속수치·이산옵션 아님) |
| 타공 구수(4/6/8) = 공정 1행 + param{구수:N} | 공정 마스터 비대화 방지 — **GAP-PARAM** |
| 비가격 사이즈조합 = 주문불가 (최종판정=가격엔진) | 면적매트릭스(포스터사인 가격표) |

---

## 8. acrylic (25상품·면적형) — TEMPLATE 보유(볼체인)

L1 권위: `acrylic-l1.csv`.

### OPTION 후보
| option_group | sel_typ | L1 컬럼 | member 값 샘플 | 환원 |
|---|---|---|---|---|
| OG-SIZE | 01 | `사이즈(필수)` | 규격 + 비규격 | size(.01) |
| (비규격) | products 범위 | `비규격(최소/최대)_가로/세로` | min/max | products(옵션 아님) |
| OG-SOJAE | 01 mand | `소재(필수)` | 투명아크릴 3mm / 골드·실버 3mm / 8mm / 3mm+3mm 접합 / 라미(10T) | material(.03, 두께융합) |
| OG-INSWAE | 01 | `인쇄사양` | 배면양면 / 풀빼다 / 투명테두리★ / 단면인쇄 | print/process(.06/.04) `[CONFIRM]` |
| OG-JOGAK | 01 | `조각수(옵션)` | 2~10조각 | process(.04) + **param(조각수 N)** |
| **OG-GAGONG** | 01 | `가공(옵션)_가공` | 고리없음·은색고리·금색고리·자석부착·원형핀·1구자석·투명집게·화이트바디 | process(.04, **자재+공정 BUNDLE**) |

### TEMPLATE 후보 ✅ (보유)
L1 `추가상품(옵션)_추가상품` 실측값 = **볼체인(색) 별도 상품**:
- `볼체인(블루)` / `볼체인(핑크)` / `볼체인(블랙)` / `볼체인(오렌지)` / `볼체인(바이올렛)` / `볼체인(화이트)` / `볼체인(민트그린)` / `볼체인(핫핑크)` / `볼체인(선택안함)`
- **판별 근거:** 볼체인=별도 부자재 SKU(아크릴 키링에 끼우는 독립 부품). 단 `볼체인(선택안함)`이 있어 **OPTION 성격(택1)도 동시 존재** → `[CONFIRM]` 볼체인이 별도 배송 부품(TEMPLATE)인가, 본체 동봉 부자재(OPTION/set)인가. guide 기준상 "별도 생산·배송 독립 상품"이면 TEMPLATE, "본체에 끼워 함께 배송"이면 set(.07) OPTION. **고리(가공)와 볼체인 동시 존재 = 가공은 본체 일체, 볼체인은 부착 부품 — 도메인 확정 필요.**

### CONSTRAINT 후보
| 조건 → 결과 | 근거 |
|---|---|
| 조각수 = 자유형/도무송 커팅 시만 의미 | 조각수 2~10 |
| 가공(고리/자석) ↔ 볼체인 호환 `[CONFIRM]` | 고리없음+볼체인 조합 가부 |
| 비규격 가로/세로 범위 | `비규격_가로/세로` |
| 비가격 조합 = 주문불가(가격엔진) | 면적형 가격 |

---

## 9. goods-pouch (103상품·굿즈) — TEMPLATE 보유(볼체인·리필잉크)

L1 권위: `goods-pouch-l1.csv` + `huni-goods-option-mapping.md`.

### OPTION 후보
| option_group | sel_typ | L1 컬럼 / 오염자재 | member 값 샘플 | 환원 |
|---|---|---|---|---|
| OG-SIZE | 01 | `사이즈(필수)` | (사이즈) | size(.01) |
| OG-SELECT | 01 | `선택(옵션)_선택` | 화이트·반투명·투명·블랙 / 화이트 M·L·XL·XXL | **혼합** — 본체색→material(.03 합성) / 사이즈M·L→size(.01) `[CONFIRM]` |
| OG-GAGONG | 01 | `가공(옵션)_가공` | 에폭시·라벨없음·라벨부착·맥세이프추가 | process(.04) |
| (형상) | 01 | 오염 MAT(원형/하트/별) | — | size(.01 형상융합, **GAP-SHAPE**) |
| (본체색) | 01 | 오염 MAT(블랙/화이트) | — | material(.03 합성, color-chip) |
| (구수) | 01 | 오염 MAT(1~4구) | — | process(.04 + param, **GAP-COUNT**) |
| (잉크색) | 01/02 | 오염 MAT(검정/빨강 만년스탬프) | — | print(.06) **vs** GAP-OPT `[CONFIRM] §ambiguous` |

### TEMPLATE 후보 ✅ (보유)
L1 `추가상품(옵션)_추가상품` 실측값 = **2종 별도 상품 혼재**:
- **리필잉크**: `빨강 5cc` / `파랑 5cc` / `노랑 5cc` / `핑크 5cc` / `검정 5cc` / `초록 5cc` / `청보라 5cc` (만년스탬프 리필잉크 = 별도 소모품 상품)
- **볼체인(색)**: `볼체인(핑크)` / `볼체인(오렌지)` / `볼체인(선택안함)` (acrylic과 동일)
- **판별 근거:** 리필잉크 5cc·볼체인=별도 생산·배송 독립 상품/소모품 → TEMPLATE. `볼체인(선택안함)` 존재 → 본체 동봉이면 set, 별도 배송이면 template `[CONFIRM]`(acrylic과 동일 이슈).

### CONSTRAINT 후보
| 조건 → 결과 | 근거 |
|---|---|
| 선택(화이트 M/L/XL) = 본체색+사이즈 동시 (cascade) | `선택_선택`값 `화이트 M`·`화이트 L` (색·사이즈 합성) |
| 리필잉크색 = 만년스탬프 상품일 때만 노출 | 리필잉크=만년스탬프 부속 |
| 맥세이프추가 가공 ↔ 호환 본체 | `가공_가공`값 `맥세이프추가` |
| 구간할인 (`구간할인적용테이블`) = 가격엔진(t_dsc_*) | 옵션 아님 |

---

## 10. product-accessory (15상품) — 옵션 거의 없음

L1 권위: `product-accessory-l1.csv`. 컬럼 최소(사이즈·수량·가격만).

### OPTION 후보
| option_group | sel_typ | L1 컬럼 | member 값 | 환원 |
|---|---|---|---|---|
| OG-SIZE | 01 | `사이즈(필수)` | (사이즈) | size(.01) |
| (수량) | products 범위 | `수량(필수)_최소/최대/증가` | min/max/step | products(옵션 아님) |

### TEMPLATE 후보
**TEMPLATE 없음.** `추가상품` 컬럼 없음. (부자재 셋트 후보지만 L1 컬럼 근거 없음.)

### CONSTRAINT 후보
**없음.** (사이즈·수량만, 교차축 규칙 없음.)

---

## 11. stationery (12상품) — 책자류 동형

L1 권위: `stationery-l1.csv`.

### OPTION 후보
| option_group | sel_typ | L1 컬럼 | member 값 샘플 | 환원 |
|---|---|---|---|---|
| OG-SIZE | 01 | `사이즈(필수)` | (사이즈) | size(.01) |
| OG-NAEJI | 01 | `내지(옵션)` | 무지내지 | material(.03) |
| OG-JONGI | 01 | `종이(옵션)` | 백모조100 / 백모조120 | material(.03) |
| OG-NAEJI-DOSU | 01 | `내지인쇄사양` | 양면 / 단면 | print(.06) |
| OG-PYOJI | 01 | `표지사양` | 아트250+무광코팅 / 레더 | material(.03) |
| OG-PYOJI-DOSU | 01 | `표지인쇄사양` | 단면 | print(.06) |
| GRP-제본옵션 | 01 | `제본옵션(옵션)` | 실버링 / 50장1권 / 100장1권 | process/bundle `[CONFIRM]` |
| GRP-제본 | 01 (택일) | `제본사양` | 하드커버 / 트윈링제본(좌철+실버링) / 트윈링제본(상철+실버링) / 떡제본 / 중철제본 | process(.04 BUNDLE) |
| OG-PACK | 01 | `개별포장(옵션)` | 개별포장없음 / 수축포장 | GAP-OPT |

### TEMPLATE 후보
**TEMPLATE 없음.** `추가상품` 컬럼 없음.

### CONSTRAINT 후보
| 조건 → 결과 | 근거 |
|---|---|
| 제본사양 트윈링(좌철/상철+실버링) = 제본방향+링 합성 | `제본사양`값 `트윈링제본(좌철+실버링)` |
| 제본옵션 `50장1권`/`100장1권` = 묶음수 cascade `[CONFIRM]` | `제본옵션`값 (제본 vs 묶음 모호) |
| 페이지사양 MIN/MAX/STEP (page_rule) | `페이지사양_최소/최대/증가` |
| 구간할인 = 가격엔진 | `구간할인적용테이블` |

---

## 12. 횡단 요약

### 시트별 1줄 요약 (option group 수 · template 유무 · constraint 수)
| 시트 | OPTION group 수 | TEMPLATE | CONSTRAINT 수 |
|---|:---:|:---:|:---:|
| digital-print | 11 | ✅ 보유(봉투류, 동적 ★사이즈) | 5 |
| sticker | 5 | ❌ 없음(컬럼 공란) | 2 |
| booklet | 14 | ❌ 없음(컬럼 부재) | 6 (최다) |
| photobook | 7 | ❌ 없음 | 3 |
| calendar | 8 | ✅ 보유(캘린더봉투, 동적) | 3 |
| design-calendar | 7 | ✅ 보유(봉투+우드거치대) | 1 |
| silsa | 7 | 혼합(끈=opt / 거치대=tmpl) | 4 |
| acrylic | 6 | ✅ 보유(볼체인 — set vs tmpl 확정필요) | 4 |
| goods-pouch | 7 | ✅ 보유(리필잉크·볼체인) | 4 |
| product-accessory | 1 | ❌ 없음 | 0 |
| stationery | 9 | ❌ 없음 | 4 |

### TEMPLATE 보유 시트 (6/11)
`추가상품(옵션)_추가상품` 컬럼 보유 + 실값 존재 = **digital-print · calendar · design-calendar · acrylic · goods-pouch** + **silsa**(거치대 혼합). 두 유형:
- **봉투류**(digital-print·calendar·design-calendar): 고정 SKU + `★사이즈선택` 본체연동 동적 → 라이브 봉투 base prd_cd 실재, template_selections로 siz freeze.
- **부자재류**(acrylic·goods-pouch 볼체인·goods-pouch 리필잉크·design-calendar 우드거치대·silsa 거치대): **OPTION/set vs TEMPLATE 경계** — `볼체인(선택안함)`처럼 택1 sentinel이 있으면 본체 동봉 set(.07) 가능성. 별도 배송 여부 도메인 확정 필요.
- **sticker만** 컬럼은 있으나 값 공란 → TEMPLATE 없음.

### CONSTRAINT-heavy 시트
- **booklet(6)** 최다: 링컬러→링제본·바인더링→A4·인쇄면지→하드커버·박칼라→박·material→코팅 disable.
- **digital-print(5)**: 박칼라→박·형압↔박 배타·코팅→종이두께·접지→size·별색×도수.
- **calendar(3)** 명시 constraint: **L1 값 자체에 `★고리형트윈링제본선택시만`이 박혀 있어** 캐스케이드가 엑셀에 명시(가장 깨끗한 JSONLogic 후보).
- 공통 패턴: **박칼라⊂박(계층종속)** · **링/면지→제본방식 의존** · **자재→후가공 disable** · **비규격 사이즈 범위**(면적형). 최종 가격유효성=가격엔진(enumerate 금지).
- product-accessory(0): constraint 없음.

### 반복 비옵션 패턴 (전 시트)
- `제작수량/수량_최소/최대/증가`·`내지페이지`·`장수`·`페이지사양` = **products/page_rule 범위(counter-input)**, OPTION 아님.
- `구간할인적용테이블`(goods-pouch·stationery) = **가격엔진 t_dsc_***.
- `개별포장(옵션)` = **GAP-OPT**(포장 차원 부재, 4시트 공통).

---

## 13. 다음 적재 우선순위 제언

| 우선 | 시트 | 근거 | 행사 축 / 닫는 GAP |
|:---:|---|---|---|
| **1 (권장)** | **digital-print(엽서 PRD_000016)** | postcard-walkthrough 검증완료. OPTION(11)·TEMPLATE(봉투 동적)·CONSTRAINT(5·박 composite) 전부 보유 — master map 정합 즉시 입증 | .01·.03·.04·.06 + add-on template / GAP-PARAM·GAP-COMPOSITE·GAP-DEFER |
| **2** | **calendar** | CONSTRAINT가 **L1 명시값**(`★고리형트윈링제본선택시만`)이라 JSONLogic 변환이 가장 명료. GRP-CAL-가공 택일그룹(excl_group 마이그 GAP-2 실증) + 봉투 template | GRP 택일·링칼라 조건부·봉투 template / GAP-2·GAP-OPT |
| **3** | **silsa(일반현수막 PRD_000138)** | banner-walkthrough 검증완료. 비규격 사이즈·복합옵션(각목+끈 polymorphic 2행)·타공 구수 param | .01·.03·.04·.07 / GAP-PARAM(구수)·GAP-COMPOSITE |
| 4 | **booklet** | CONSTRAINT 최다(6)·내지/표지 2축·제본 택일그룹 — 제약 표현력 한계 시험 | 내지/표지 2벌·GRP-BOOK-제본 / 면지·바인더링 `[CONFIRM]` |

> **권고:** 1=digital-print(엽서) 먼저(walkthrough 검증완료·표현력 최대). 2=calendar(constraint가 엑셀 명시값이라 JSONLogic 검증이 깨끗·봉투 template + GRP 택일그룹으로 GAP-2 닫음). acrylic/goods-pouch 부자재 template는 **볼체인/리필잉크의 set vs template 도메인 확정** 후 착수.

---

## 14. [CONFIRM] 도메인 모호성 (침묵 선택 금지)

| ID | 모호성 | 후보 A | 후보 B | 출처 |
|---|---|---|---|---|
| C-1 | **볼체인/리필잉크 = set vs template** | TEMPLATE(별도 배송 독립 상품) | t_prd_product_set(.07, 본체 동봉 부품) | acrylic·goods-pouch 추가상품에 `볼체인(선택안함)` sentinel 존재 → 택1 부품 성격 |
| C-2 | **만년스탬프 잉크색 = 도수 vs 자유옵션** | print(.06 colorinfo) | GAP-OPT 자유옵션그릇 | 마스터 지도 §5.1 (스탬프 잉크≠인쇄 도수) |
| C-3 | **booklet 면지·바인더링 = 자재 vs 공정/셋트** | material(.03) | process(.04)/set(.07) | booklet L1, 라이브 차원행 정체 미확인 (dbm-schema-analyst) |
| C-4 | **design-calendar 우드거치대 = 가공 vs 추가상품** | OPTION(GRP-CAL-가공 `우드거치대`, 본체 일체) | TEMPLATE(별도 거치대 SKU) | 같은 시트에 가공·추가상품 양쪽 등장 |
| C-5 | **stationery 제본옵션 `50장1권/100장1권` = 제본 vs 묶음수** | process(.04 제본부속) | bundle_qty(.05) | `제본옵션(옵션)`값 모호 |
| C-6 | **goods-pouch 선택 `화이트 M/L` = 색+사이즈 합성** | size(.01)와 material(.03) 2축 분리 | 단일 합성행 | `선택_선택`값에 색·사이즈 혼재 |

---

## 15. [CONFIRM] 결정 (2026-06-09 사용자)

| ID | 결정 | 적용 규칙 |
|---|---|---|
| **C-1** 볼체인/리필잉크 | 🔍 **경쟁사+인쇄 도메인 리서치 후 확정**(set vs template) | 리서치 결과로 확정 — `cpq-confirm-research-c1-c4.md` |
| **C-2** 만년스탬프 잉크색 | ✅ **도수(.06) 아님** — 도수는 인쇄 전용. 잉크색=별개 자유옵션 그릇 | print(.06)에 넣지 말 것 |
| **C-3** booklet 면지·바인더링 | ✅ **자재(.03)** — 단 트윈링/하드커버에 면지 붙이는 작업 동반 시 **자재+공정 BUNDLE**(붙임 공정 추가) | material + (조건부)process BUNDLE |
| **C-4** 캘린더 우드거치대 | 🔍 **경쟁사 리서치 후 확정**(가공 OPTION vs 추가상품 TEMPLATE) | 리서치 결과로 확정 — `cpq-confirm-research-c1-c4.md` |
| **C-5** stationery "50장1권" | ✅ **제본이면서 묶음수** — 제본 옵션 + 묶음수(bundle_qty) 의미 동반 | process(제본) + bundle_qty 동반 |
| **C-6** goods-pouch "화이트 M/L" | ✅ **한 덩어리** — 색·사이즈 분리 말고 단일 합성행(화이트 머그처럼) | 단일 합성 옵션(분할 금지) |

> C-2/C-3/C-5/C-6 = 사용자 확정(2026-06-09). C-1/C-4 = 경쟁사(RedPrinting/WowPress) + 인쇄 도메인 리서치 대기.

---

> 본 인벤토리는 후보 식별까지. 사슬 인스턴스화(option_groups/options/option_items 코드·constraints JSONLogic·templates SKU)는 우선순위 1(digital-print 엽서) 파일럿에서 `<family>-option-layer.md`로 수행. 모든 후보는 §1~11의 L1 컬럼/값 인용에 근거(발명 0).
