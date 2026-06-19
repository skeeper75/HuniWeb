# RP 추출 커버리지 인덱스

> 후니 RP-Meta 하네스 파이프라인 ① — 샘플 커버리지 맵 (rpm-reverse-engineer).
> 실행 이력: ① BN(현수막류) 파일럿 6+1상품. ② GS(굿즈/잡화) 확장 12상품. ③ TP(디자인템플릿) 확장 대표3+20횡단. ④ PR(인쇄물·책자) 확장 대표3+53횡단. ⑤ ST(스티커) 확장 대표3+33횡단. ⑥ CL(의류) 확장 대표3+27횡단. ⑦ AC(아크릴·키링·코롯토·명찰·등신대) 확장 대표3+17횡단. ⑧ PD(스툴·슬리퍼·강아지계단·봉제 구조물) 전수 3상품. ⑨ PH(포토보드·액자·사진인화·포토북·포토굿즈) 확장 대표3+27횡단(★§0.5 client-render 재캡처로 거치/마운팅 블로커 해소). ⑩ FS(패브릭·봉제 완제 직물 굿즈) 확장 대표5+16횡단(★타일링 신규 fragment 발굴·신규축 선별 모드). 대표 샘플링(답습 전수수집 아님). **메타모델 = 17축(10 카테고리·distinct: TP #16·ST #17·나머지 0·PH 재포화 9번째·FS 재포화 10번째·★FS 타일링 #18 후보 1건 판정보류→아키텍트/갭).**

## 커버리지 맵 — BN(현수막류) (상품 → 축 → 출처)

| pdtCode | 상품명 | 구조 다양성 | 축 수 | 자재 | 사이즈 | 도수 | 후가공그룹 | 부속물 | 출처 |
|---------|--------|------------|-------|------|--------|------|-----------|--------|------|
| BNBNFBL | 현수막 | 기본/대표 | 5 | 1 | 5(프리셋4+자유) | 1 | 7그룹/14상세 | - | `[reuse:Vue-BFF]` 풀 |
| BNPTPET | PET 배너 | 코팅필수 | 4 | 2 | 2 | 1 | 5그룹/8상세 | - | `[reuse:Vue-BFF]` 풀 |
| BNSTDFT | X배너(스탠드) | 거치형 | 5 | 2 | 3 | 부분 | 6그룹(존재만) | 거치대 8 | `[live:SSR]` |
| BNBNSOD | 어깨띠 | 형상특이 | 4 | 1 | 3 | 부분 | 2그룹(최소) | - | `[live:SSR]` |
| BNRLSLV | 롤업배너-블락아웃PET | 롤업형 | 5 | 1 | 4 | 부분 | 3그룹 | 롤업거치대 3 | `[live:SSR]` |
| BNPTMAS | 매쉬배너 | 매쉬소재 | 4 | 1 | 2 | 부분 | 5그룹 | - | `[live:SSR]` |
| BNTNHVY | 텐트천 두꺼운 현수막 | 텐트천소재/최대가공 | 6 | 2 | 5 | 부분 | 7그룹+포장 | - | `[live:SSR]` |

## 커버리지 맵 — GS(굿즈/잡화, 136상품·최대 카테고리)

| pdtCode | 상품명 | 구조 다양성 | 축 수 | 본체 | variant 인코딩 | 제본/가공 | 가격모델 | 출처 |
|---------|--------|------------|-------|------|---------------|-----------|---------|------|
| GSTBMWM | 미르 와이드마우스 텀블러 | 완제SKU·무인쇄 | 5 | DIR_MTR(텀블러) | DTL(색+용량) | - | tmpl_price | `[reuse:price-capture]` 풀 |
| GSMLSLC | 마스크 스트랩(실리콘) | 실리콘·색variant | 3 | DIR_MTR(실리콘끈) | DTL(색=핑크) | - | tmpl_price | `[reuse:price-capture]` 풀 |
| GSPDLNG | 장패드 | 대형패브릭·유료인쇄/포장 | 4 | DIR_MTR(장패드4T) | DTL(두께) | - | vTmpl_price | `[reuse:price-capture]` 풀 |
| GSNTSPR | 스프링노트 삼총사 | 제본계층·자재다중슬롯 | 8 | MTRL(표지)+INN(내지) | ATTB(링색)·CUT(사이즈) | 트윈링RIN+귀돌이ROU×4 | tmpl_price | `[reuse:price-capture]` 풀 |
| GSNTSTA | 내 마음의 중철노트 | 중철·완칼형상 | 6 | MTRL+INN | DTL(형상 하트/여권) | 중철STA | tmpl_price | `[reuse:price-capture]` 풀 |
| GSDRSKS | 스케치북 학생용 | 코일제본·내지등급 | 5 | MTRL+INN(학생속지) | DTL(상철) | 코일RIN_COL | tmpl_price | `[reuse:price-capture]` 풀 |
| GSPUFBC | 파우치-패브릭코튼 | 본체조립·지퍼 | 6 | MTRL(코튼) | DTL(방향)·CUT(기종) | PDT_WRK조립+FLX_ZIP | tmpl_price | `[reuse:price-capture]` 풀 |
| GSTGMIC | 마이크 네임택 | ★tiered·S/L합일variant | 6 | WRK_MTR(스펀지) | DTL(S/L 합일) | PDT_WRK+THO_CUT | tiered_price | `[reuse:price-capture]` 풀 |
| GSTTDTM | 규조토 코스터 | ★소재축 정점(6소재군) | 2+ | 규조토 본체 | (소재=pdtCode) | unobserved | tmpl(추정) | `[live:catalog]`+`[SSR-neg]` |
| GSCAPHN | 폰케이스(일반/터프) | ★기종variant·후니미등록 | 2+ | 케이스(일반/터프) | 기종 enum(unobs) | unobserved | unobserved | `[live:catalog]`+`[SSR-neg]` |
| GSNTLTR | 레더 노트 | 레더본체·후니BATCH-4정합 | 2+ | 레더 본체 | unobserved | unobserved | unobserved | `[live:catalog]`+`[SSR-neg]` |
| GSSKHND | 효자손 | 순수완제·본체주체 | 2+ | DIR_MTR(추정) | unobserved | unobserved | tmpl(추정) | `[live:catalog]`+`[SSR-neg]` |

> GSTTDTM은 코스터 6소재군 대표 — 나머지 5(GSPLCST 펠트·GSTTCRK 코르크·GSTTPAP 종이·GSTTACR 아크릴(모양)·GSTTREZ 레더)는 §9에 묶어 기록(소재만 다른 동형, 답습 회피).

## 커버리지 맵 — TP(디자인템플릿, 23상품·★템플릿/에디터 축 본질)

| pdtCode | 상품명 | 구조 다양성 | 축 수 | 에디터 채널 | 템플릿 | 페이지/형태 | 가격모델 | 출처 |
|---------|--------|------------|-------|-----------|--------|------------|---------|------|
| TPBCDFT | 디자인 명함 | 에디터+VDP 기본 | 2+ | Edicus(추정) | useTemplate(추정) | - | unobs | `[live:SSR]` partial |
| TPTKDFT | 티켓(M/I/보딩) | 형태variant·티켓특화·SSR실측 | 8 | **KOI(Y)·PDF(Y)** 실측 | unobs | M/I/보딩·미싱 | digital_price | `[live:SSR]` |
| TPCLSTD | 디자인_탁상 세로 캘린더 | 캘린더·HL옵셋 트윈대조 | 7 | KOI+템플릿(자매실측) | **Y**(useTemplate) | 12~13월·링 | vTmpl(추정) | `[reuse:productInfo]` 자매+`[live:catalog]` |
| TPCLECO | 에코 캘린더 | 페이지계층 정점 | 6 | **KOI(Y)·PDF(Y)** | **Y** | **2~200면**·상철RIN | **tiered_price** | `[reuse:productInfo]` 풀 |
| TPCLWLB | 큰달력(효도) | 중철쫄대·가격실측 | 4 | **KOI(Y)·템플릿(Y)** | **Y** | 1면·중철STA쫄대 | **vTmpl_price** | `[reuse:productInfo]` 풀 |

> TPCLECO·TPCLWLB는 ★풀 productInfo 실측(에디터 플래그 전체 + TPCLWLB PRICE=11900). TPCLSTD 구조는 동형 자매로 확정.
> 나머지 18종(디자인 X 4·박티켓·캘린더 4·북 3·평면지류 8)은 reverse.md §4 그룹 A~E에 묶어 횡단 태깅(에디터/템플릿 동형, 답습 회피).
> **★HL 옵셋 캘린더(비-TP 트윈) 실측 대조**: HLCLSTD/HLCLWAL = `offset2023_item`·useKoiEditor=N·useTemplate=N·usePDF=Y — TP가 추가하는 단 하나 = 디자인 입력 레이어.

## 커버리지 맵 — PR(인쇄물·책자, 56상품·★다면/제본/접지/인쇄방식 축 본질)

| pdtCode | 상품명 | 구조 다양성 | 축 수 | 자재(역할) | 사이즈 | 도수 | 다면/제본/접지 | 가격모델 | 출처 |
|---------|--------|------------|-------|-----------|--------|------|---------------|---------|------|
| PRLFXXX | 리플렛 | ★접지/면분할 | 6 | 용지(추정) | 규격+자유(추정) | SID_S/D | **접지 FLD_DFT 7종** | digital(추정) | `[live:SSR-neg]`+`[reuse]`접지 |
| PRBKYPR | [윤전]무선책자(컬러) | ★제본·표지내지·페이지 정점 | 15 | **표지+내지 분리** | 출판판형5+자유 | **표지/내지 분리** | 무선PER·방향·면지10·날개·페이지10~300 | **book2025** | `[reuse:productInfo]`+`[reuse:price]`8조합 |
| PRPOXXX | 종이 포스터 | ★규격/자유·BN대조 | 13 | 용지 45종(평량정점) | A2/A3/A4/B3/B4+자유 | SID_S/D | **접지 7종**+후가공11그룹 | **digital** | `[reuse:productInfo]`+`[reuse:price]` |

> PRBKYPR·PRPOXXX는 ★풀 productInfo+priceCall 실측(책자 book2025 8조합 56,000~420,900·포스터 접지7·45용지). 리플렛 접지축은 동형 포스터 FLD_DFT 7종으로 확정.
> 나머지 53종(포스터군10·카드엽서16·책자18·용도별책자6·평면POP5)은 reverse.md §4 그룹 A~E에 묶어 횡단 태깅(접지/제본/인쇄방식 동형, 답습 회피).
> **★인쇄방식 분기축(BN/GS/TP 미발굴)**: 윤전(PRBKY*)/토너(PRBKO*)/인디고(PRIDPRT)/리소(PRPORSO) — 같은 책자가 인쇄방식별 별 pdtCode. 제본방식{무선/스프링/트윈링/스테플러/실제본}×도수{컬러/흑백}와 함께 3축 매트릭스를 19 pdtCode로 펼침.

## 커버리지 맵 — ST(스티커, 36상품·★형상×칼선×점착소재×인쇄방식 4축 본질)

| pdtCode | 상품명 | 구조 다양성 | 축 수 | 형상/칼선 | 재단입자 | 소재(점착) | 인쇄방식 | 가격모델 | 출처 |
|---------|--------|------------|-------|----------|---------|-----------|---------|---------|------|
| STTHUSR | 자유형 스티커 | ★형상FR·자유칼선·소재정점 | 11 | FR / THO_GRA(자유) | 반칼/낱장(CUT_DFT 2) | 26종(리무버블/유포/메탈/한지) | 일반(digital) | **digital** | `[reuse:productInfo]` 풀 |
| STCUXXX | 사각반칼 스티커 | ★반칼/완칼·프리셋칼틀 | 10 | SQ / THO_DFT(프리셋) | 반칼/낱장(CUT_DFT 2) | 19종 | 일반(digital) | **digital** | `[reuse:productInfo]`+`[reuse:price]` |
| STPADPN | DTF 열전사 판스티커 | ★인쇄방식분기·판단위·완제SKU형 | 7 | (형 무)/판단위재단 | 판전체 | DTF전용필름(단일) | **DTF**(화이트강제·도수숨김) | **vTmpl** | `[reuse:productInfo]`+`[reuse:price]` |

> STTHUSR·STCUXXX·STPADPN은 ★풀 productInfo 실측(shape_info·THO_GRA/THO_DFT·CUT_DFT 반칼/개별·소재19~26·disable 227·PAK_POL). STCUXXX/STPADPN priceCall까지(칼틀·재단·화이트 PCS 전달 확정). 보조 실측 5(STTHCIC 원형 CL칼틀11·STTHSQU 라운드 RC칼틀25·STDCFBR 5형상 superset·STPADIY 정가tmpl·STPADNM DTF네임).
> 나머지 33종(형상칼선5·다양한모양/패브릭4·점착특화7·특수후가공/소재5·인쇄방식분기7·기타형태4)은 reverse.md §4 그룹 A~F에 묶어 횡단 태깅(형상/칼선/점착/인쇄방식 동형, 답습 회피). 모집단=catalog category=ST 36상품(전부 /item/ST/·코드접두≠카테고리 누수 없음).
> **★ST 신규 발굴축(BN/GS/TP/PR 미발굴)**: ① 형상(shape_info SQ/CL/EL/RC/FR enum·directive #1) ② 칼선 2메커니즘(THO_GRA 자유 vs THO_DFT 프리셋칼틀 enum 수십종) ③ 재단입자(묶음재단=반칼시트/개별재단=완칼낱장·directive #2) ④ 점착/내후 소재차원(directive #3). 인쇄방식(일반/UV STPAU*/DTF STPAD*/후지 STBP*) 분기는 PR 윤전/토너/인디고와 합류 → **16축 포화 유지 가설은 ST에서 깨질 후보**(형상·칼선·재단입자가 distinct 신규).

## 커버리지 맵 — CL(의류·티셔츠·앞치마·가방류, 30상품·★의류 variant/apparel_info/2모델 본질)

| pdtCode | 상품명 | 구조 다양성 | 축 수 | 본체 인코딩 | 모델(item_gbn) | 의류 차원 | 가격모델 | 출처 |
|---------|--------|------------|-------|------------|---------------|-----------|---------|------|
| CLSTSHS | 5.6oz 하이퀄리티 티셔츠 | ★자체 의류 정수·apparel_info 풀 | 8 | size×color→MTRL_COD(584행) | **clothes2025** | 54색·7사이즈·6위치·3방식·Pantone1124 | **clothes2025_price** | `[reuse:productInfo]`+`[reuse:price]` 풀 |
| CLTMSHS | 단체티-반팔(Printstar086) | ★단체·브랜드완제·아동사이즈 | 7 | size×color→MTRL_COD(62행) | clothes2025 | 6색·9사이즈(★child)·6위치 | clothes2025_price | `[reuse:productInfo]` 풀 |
| CLAPDFT | 앞치마 | ★굿즈형 분기·레거시SSR | 6 | DIR_MTR 완제SKU(용도×색 융합) | **tmpl(굿즈형)** | 본체8·영역5·위치chip·도수2 | **tmpl_price** | `[live:SSR]` |
| CLDFSHS | 76000 반팔 티셔츠 | 브랜드완제·신규Vue | 7+ | unobserved | clothes2025(추정) | unobserved | unobs | `[live:SSR-neg]`+`[catalog]` |

> CLSTSHS·CLTMSHS는 ★풀 productInfo 실측(★`apparel_info` 전용 6키 구조: print_type 3·print_area 6·apparel_color 54/6·size_info 7/9·size_color_info 227/54셀→MTRL_COD·pantone 1124). CLSTSHS는 가격(본체16200+위치3700·DTF/DIR·M/L) 추가 실측. CLAPDFT는 ★유일 SSR-positive(레거시 jQuery·paper8/size5/sodu2 select·print_area radio chip·tmpl_price).
> 나머지 26종(자체의류12·자체가방모자에이프런4·브랜드완제8·단체2)은 reverse.md §5/§6/§14에 그룹 횡단 태깅(원단평량/형태/원단출처 동형, 답습 회피).
> **★CL 신규 발굴축(BN/GS/TP/PR/ST 미발굴)**: ① **의류 variant = `clothes2025` 전용 item_gbn + `apparel_info` 전용 그릇**(GS variant facet 아님 — 1차 예측 distinct #18) ② **size×color = MTRL_COD 2D 매트릭스**(variant 4번째 인코딩·GS 3채널 초과) ③ **사이즈 grid(GBN 성인/아동)** ④ **인쇄위치 6 다중선택 공정(PDT_WRK·KOI_NME 에디터매핑)** ⑤ **카테고리 내부 2모델(clothes2025 티셔츠 vs tmpl 앞치마/가방)** ⑥ **원단 출처 3분기(자체/브랜드/단체)** ⑦ **Pantone 1124 별색 라이브러리**. 인쇄방식(DTF/직접/실크)은 ST/PR(상품분기)과 달리 CL은 상품내 ORD_INFO 옵션 → 인쇄방식 축 2표현 합류. 모집단=catalog category=CL 30상품(전부 /item/CL/·코드접두=CL≠카테고리 누수 0). **★17축 안정성: CL에서 의류 variant(#18 후보)가 깨질 강한 후보** — item_gbn·apparel_info·size×color·Pantone 모두 별도 그릇.

## 커버리지 맵 — AC(아크릴·키링·코롯토·명찰·등신대, 20상품·★두께×소재variant·완칼·부착물·입체/받침 본질)

| pdtCode | 상품명 | 구조 다양성 | 축 수 | 본체(두께×소재) | 완칼/부착물 | 입체 | 가격엔진 | 출처 |
|---------|--------|------------|-------|----------------|------------|------|---------|------|
| ACNTHAP | 아크릴 명찰 | ★라벨형·PET+아크릴합지·뒷면부착 | 7 | RXIGC075 고투명PET리무버블(합지로 아크릴화) | 레이저·WRK_MTR 옷핀/마그넷 | - | **vTmpl_price** | `[reuse:productInfo]` 풀 |
| ACTHDKY | 아크릴 키링 | ★두께×소재정점·완칼·고리80+·전용엔진 | 11 | 6종(3T/5T×일반/라미/홀로그램·WGT 슬롯) | 자유형레이저(완칼)·SUB_MTR 고리/구슬/와이어 80+ | (평면) | **acrylic2025_price** | `[reuse:productInfo]` 풀 |
| ACPDSTD | 아크릴 등신대 | ★입체/스탠드·받침12 SKU·대형자유 | 6 | PXACR016 3T투명 단일 | 레이저·SUB_MTR 받침12(원형/타원/사각/육각×S/M/L·필수) | ★받침이 평면을 세움 | **tmpl_price** | `[reuse:productInfo]` 풀 |

> ACNTHAP·ACTHDKY·ACPDSTD ★풀 productInfo 실측(두께×소재 6/단일·프리셋/자유사이즈·BON_PAP합지·LAS_DFT완칼·SUB_MTR 고리80+/받침12·WRK_MTR뒷면·PRT_WHT·production_method 일반/라미·print_data 앞뒤·disable·widgetDump select). item_gbn 3종(vDigital/acrylic2025/edicus)·price_gbn 3종(vTmpl/acrylic2025/tmpl) 헤더 실측.
> 나머지 17종(키링류8 ACTH*KY·코롯토4 ACTH*CO·부착물4 ACPD*·템플릿1 ACTPKEY)은 reverse.md §4 그룹 A~D 횡단 태깅(소재variant/입체/부착 동형 추정·unobserved 정직). 모집단=catalog category=AC 20상품(전부 /item/AC/·코드접두 AC≠카테고리 누수 0).
> **★AC 신규 발굴 후보축 + 1차 distinct/facet 판정**: ① **두께(3T/5T/8T)=자재#1 WGT 슬롯 facet**(distinct #19 아님 — MTRL_CD WGT_CD 인코딩·[huni-ref] mat_cd 차원 동형) ② **소재 variant(홀로그램/글리터/거울/자개/렌티큘러/유색/파스텔)=자재 surface-finish facet**(ST 점착소재 동형·거울만 [huni-ref] MIRROR3T 별 가격공식) ③ **입체/스탠드=분산 facet**(받침=부자재 SUB_MTR·두께블록=자재·양면=print_data·distinct #19 아님·단 "평면→입체 변환"은 round-15 생산형태 검토) ④ **가공방식(일반/라미 GRP_OPTION_CD)=신규 자재 그룹핑 슬롯 가설** ⑤ **완칼(자유형레이저 FRXXX)=ST 재단입자축 합류** ⑥ **부착물(고리 KR/CN/CR 80+)=ST SUB_MTR 코드 공유·부자재 카탈로그 횡단**. **★17축 안정성: AC에서 두께·입체 모두 distinct 아님(facet)으로 1차 판정 → 17축 안정 유지 가설 강화**(신규 강후보 가공방식 그룹핑 슬롯·표면효과 차원은 자재모델 내부 확장).

## 재사용 vs 라이브 비율
### AC(20상품·대표3+17횡단)
- **재사용(reuse:productInfo)**: 3상품(ACNTHAP·ACTHDKY·ACPDSTD) — huni-widget `01_reverse/captures/product_ACNTHAP.json` + `05_qa/captures/major_radius_ACTHDKY.json`·`major_acc_ACPDSTD.json` 풀 rawProductData+widgetDump. ★AC 두께/소재variant/완칼/부착물(고리80+·받침12)/가공방식/인쇄면/3가격엔진 축 1차 증거. (qtysweep_ACNTHAP.json 수량가격 보조.)
- **라이브 보강(live:SSR-negative)**: 1상품(ACTHFCO 입체코롯토) — HTTP 200·354KB이나 신규 Vue client-render(전역 km1_size 샘플 2 select만·거울/글리터/두께/받침/스탠드/입체/코롯토/투명은 정적 마케팅 카피·옵션 select 미노출). 입체/받침 구조는 ACPDSTD 풀 캡처로 확정.
- **catalog 횡단**: 20종 전부 category=AC·/item/AC/ 확인(코드접두≠카테고리 누수 0). 16종 catalog 상품명 + 그룹 A~D 횡단 태깅(소재variant/입체/부착 동형 추정·unobserved 정직).
- **[huni-ref] 대조**: `_workspace/huni-dbmap/31_acrylic-price-link/` — 후니 아크릴 두께(투명3T/1.5T mat_cd 분기)·미러(MIRROR3T 별 공식)·코롯토(B06 6×6 면적매트릭스)·카라비너(고정가) 모델 = 갭/메타모델 단계 대조용(여기선 RP 추출에 집중).

## AC 미관측(unobserved) 요약
- **소재특화 키링(ACTHGKY 글리터·ACTHMKY 거울·ACTHPKY 자개·ACTHCKY 유색·ACTHLKY 렌티큘러·ACTHPAM/PAA 파스텔) 자재코드·두께** — ACTHDKY 6소재(투명/홀로그램) 실측, 표면효과 variant MTRL_CD·WGT 두께·가격 unobserved(동형 추정·거울은 [huni-ref] MIRROR3T 실재).
- **코롯토(ACTHDCO/BCO/FCO/LCO) 입체 옵션/두께/공정** — [huni-ref] 코롯토 6×6 매트릭스(30~80mm)만 참조. 입체조형(FCO)·양면(BCO)·두께블록(DCO 8T)·렌티큘러(LCO) MTRL_CD·자립방식 unobserved.
- **마그넷/뱃지/조이톡/젤펜(ACPDAMG/MGN/PIN/JOY·ACTHPEN) 부착 공정·부자재코드** — 통자석합지(ST STMADFT 동형)·자석부착·뱃지핀·그립톡·펜토퍼 unobserved.
- **ACTPKEY 키링 템플릿** — 에디터 디자인 자산형 추정(TP #16), 템플릿 자산 카탈로그·VDP unobserved.
- **두께 8T(8mm) 가격** — [huni-ref] 8T 자재(MAT_000044) 마스터 존재·가격표 본체 8T 매트릭스 부재(가격 미정). RP 측 8T 상품 매핑 unobserved.
- **AC 전반 PRICE>0 실가** — 비로그인 캡처(PRICE 미캡처·세션결함·구조 무관). acrylic2025_price 산정식은 [huni-ref] 면적매트릭스 참조.

## AC 미샘플 상품 (20종 중 대표3+17 그룹 횡단)
키링류8(ACTHCKY·ACTHGKY·ACTHMKY·ACTHPKY·ACTHLKY·ACTHPAM·ACTHPAA·ACTHPEN)·코롯토4(ACTHDCO·ACTHBCO·ACTHFCO·ACTHLCO)·부착물4(ACPDAMG·ACPDMGN·ACPDPIN·ACPDJOY)·템플릿1(ACTPKEY) — 구조 다양성(두께×소재6·소재variant7표면·입체3방식·완칼·부착물80+·가공방식라미·인쇄면·화이트·3가격엔진)은 대표3(명찰=라벨/합지·키링=두께/소재/완칼/고리·등신대=입체/받침) 풀 실측으로 커버. 검증 시 갭(소재특화 자재코드·코롯토 입체공정·마그넷/뱃지 부착·8T 가격)은 로그인 캡처로 추가.

## 다음 단계 — AC 추가분 (rpm-metamodel-architect 주목 — ★두께·입체 distinct 판정 핵심)
30. **★두께(3T/5T/8T) distinct #19 vs 자재 WGT facet 최종 판정** — 1차 예측=**facet(자재#1 WGT 차원)**. MTRL_CD WGT_CD(D01/D02) 인코딩·widget select "3T/5T" 노출·[huni-ref] mat_cd 차원 통합 동형. distinct #19 아님. 단 WGT 슬롯이 평량(종이g)·두께(아크릴mm) 다의 사용 → 후니 자재모델 "WGT 슬롯 다의성"(GS 텀블러 용량 DTL 동류) 검토. A-1.
31. **★입체/스탠드 distinct #19 vs 분산 facet 판정** — 1차 예측=**분산 facet**(받침=부자재 SUB_MTR·두께블록=자재·양면=print_data·입체조형=공정). distinct 3D축 아님. 단 "받침이 평면을 입체로 변환"·"코롯토=자립블록"은 round-15 생산형태(평면 vs 입체)·BN 거치대 부속물과 합류 검토. A-3.
32. **★가공방식 그룹핑 슬롯(GRP_OPTION_CD) 신규 가설** — `option_info.production_method`(일반/라미)가 자재행을 가공그룹으로 묶음(라미=두께합성·홀로그램 부여). 후니 미발굴 "자재를 가공방식으로 그룹핑하는 슬롯". GS 제본·PR 면지·ST 합지 BUNDLE과 경계. A-8.
33. **★표면효과/광학효과 자재 차원(소재variant)** — 홀로그램/글리터/거울/자개/렌티큘러/파스텔/유색이 자재 surface-finish. ST 점착/내후(S-4)와 자재 variant 동형 합류 — 후니 자재모델 "표면/광학 효과" 차원. 거울만 별 가격공식([huni-ref] MIRROR3T) → variant vs 별계열 경계. A-2.
34. **★부자재 카탈로그 횡단 공유(SUB_MTR KR/CN/CR)** — AC 고리(80+)·받침(12)·뒷면(SXANB)이 ST SUB_MTR_KR/CN/CR과 코드 공유 = 굿즈/스티커/아크릴 횡단 단일 부자재 마스터 시사. 받침=필수(ESN=Y)·고리=선택 부자재 필수성 차원. 메모리 "옵션=자재+공정 BUNDLE" 정점. A-4.
35. **★3 가격엔진(acrylic2025_price) 패턴** — AC 한 카테고리 3엔진(vTmpl/acrylic2025/tmpl). 전용 acrylic2025_price=면적매트릭스([huni-ref])·CL clothes2025·ST 3엔진과 "2025세대 형태/카테고리 전용 가격엔진" 통합. 상품명 소재≠본체자재(명찰 PET+합지·A-7)·인쇄면/화이트 투명소재 종속(A-5)·ACTPKEY 템플릿 AC vs TP(A-9) 동반. A-5·A-6·A-7·A-9.

## 커버리지 맵 — PD(스툴·슬리퍼·강아지계단, 3상품 전수·★구조물/3D 조립 완제품 본질)

| pdtCode | 상품명 | 구조 다양성 | 축 수 | 자재(원단) | 사이즈 의미 | 공정 PCS | 부자재 | 가격엔진 | 출처 |
|---------|--------|------------|-------|-----------|------------|---------|--------|---------|------|
| PDCHSTL | 스툴 | 봉제스툴·형상융합사이즈 | 9 | 면10수화이트(면직물) | 형상+치수(미니사각/원형/긴사각) | SEW_LTR 레더재봉·THO_CUT·six_clr별색 | SUB_MTR | **tmpl_price** | `[live:SSR]` |
| PDWRSLP | 슬리퍼 | 신발류·발치수·밑창색 | 8 | 슬리퍼원단 | 발 치수(230~280mm) | six_clr별색·THO_CUT·PDT_WRK 제품가공 | SUB_MTR sub-radio 밑창색검정/흰색×사이즈 12-variant(SLB*/SLW*) | **tmpl_price** | `[live:SSR]` |
| PDSRPPY | 강아지 계단 | 반려동물구조물·단수사이즈 | 8 | PU(폴리우레탄)-코끼리원단 | 단수+치수(2단/3단) | SEW_LTR 레더재봉·THO_CUT·six_clr | SUB_MTR | **tmpl_price** | `[live:SSR]` |

> ★3상품 전수 `[live:SSR]` 실측(레거시 jQuery `productOrder` 위젯·Vue 아님). paper/sodu/size select + six_clr/SEW_LTR/THO_CUT/SUB_MTR/PDT_WRK 체크박스 + icon_txt 라벨 서버렌더. price_gbn=tmpl_price 3상품 공통. THO_CUT_SUB_SELECT 상세 enum·SUB_MTR enum·가격은 infoCall AJAX 후행(`unobserved`).
> 모집단=catalog category=PD 3상품 전수(PDCHSTL·PDWRSLP·PDSRPPY·전부 /item/PD/·코드접두 PD≠카테고리 누수 0). 재사용 캡처 0 — 라이브 1차.
> **★PD 핵심 발견 + 1차 distinct/facet 판정(directive 최대 관전 = 조립·구조·3D폼·부품 #18 여부)**: ① **조립/봉제(SEW_LTR 레더재봉·PDT_WRK 제품가공)=공정#2 family 멤버**(기존 PCS 슬롯 인코딩·새 슬롯 없음·AC WRK_MTR 동형·distinct #18 부결) ② **구조(다리/받침/바닥재/솜/지퍼/논슬립)=옵션 미노출 고정 제조사양**(마케팅 카피만·카테고리#7 정체에 내재·base-data 관리대상 아님) ③ **3D폼(입체 완제품)=GS 완제SKU·AC 코롯토 입체블록 동형**(tmpl_price 완제단가·생산형태#15 완제품) ④ **단수(2단/3단)=사이즈#13 프리셋 흡수**(1:1·구조 distinct 부결 결정적 증거) ⑤ **자재=직물/PU 원단**(종이 아님·AC/CL 비종이 자재 동형) ⑥ **밑창색=SUB_MTR sub-radio(SLB01~06 검정/SLW01~06 흰색·MTRL_COD SBSLP/SWSLP230~280)에 색×사이즈 12-variant 매트릭스로 인코딩**(★six_clr 아님·six_clr은 3상품 전부 별색=공정·D-PD-1 정정 반영) — 자재 본체색 variant·CL size×color MTRL_COD 매트릭스·GS/AC 본체색 동형. **★17축 안정성 = 재포화(distinct 0·8번째 카테고리·PR/CL/AC 패턴 반복) — 가장 이질적 "봉제 구조물 완제품"조차 17축 무손실 흡수.** 단 두 격상 명시: 공정#2 "봉제/제품가공" family 멤버 수용·완제 구조물 "내재 제조BOM"을 옵션과 분리해 카테고리#7/생산형태#15/addons#8에 두는 경계(vessel-gap 후보 PD-4).

## 재사용 vs 라이브 비율
### BN(7상품)
- **재사용(reuse:Vue-BFF)**: 2상품(BNBNFBL, BNPTPET) = 29% — huni-widget s3 캡처 풀 옵션트리(productInfo 실응답).
- **라이브 보강(live:SSR)**: 5상품 = 71% — 2026-06-17 읽기전용 HTML SSR select 추출.
### GS(12상품)
- **재사용(reuse:price-capture)**: 8상품(텀블러·마스크끈·장패드·스프링노트·중철노트·스케치북·파우치·마이크네임택) = 67% — huni-widget s3 가격캡처 reqBody/result/query 풀 추출(BN SSR보다 깊은 PCS 트리).
- **라이브 보강(catalog+SSR-negative)**: 4상품(코스터·폰케이스·레더노트·효자손) = 33% — 상품정체·소재축은 catalog 확정, 옵션 상세는 client-render·BFF 익명불가로 `unobserved`(라이브 추출 시도했으나 GS 신규 Vue 옵션 미노출 확인).

### CL(30상품·대표3+27횡단)
- **재사용(reuse:productInfo+price)**: 2상품(CLSTSHS·CLTMSHS) — huni-widget 05_qa `major_apparel_*.json` 풀 rawProductData(★`apparel_info` 전용 6키 + pdt_pcs_info 591/62 + pdt_mtrl_info 584). CLSTSHS는 `clstshs_price.json` 가격(본체16200+위치3700) 추가. ★CL 의류 variant/size×color/인쇄위치/방식 축 1차 증거.
- **라이브 보강(live:SSR)**: 1상품(CLAPDFT) — ★유일 SSR-positive(레거시 jQuery·paper8/size5/sodu2 select·print_area radio chip·tmpl_price). 굿즈형 분기 실측.
- **catalog+SSR-negative**: 1상품(CLDFSHS) 신규 Vue 옵션 미노출(unobs) / 나머지 26종 catalog 상품명 + §5/§6/§14 그룹 횡단 태깅(원단평량/형태/원단출처 동형·unobserved 정직).

## CL 미관측(unobserved) 요약
- **CLDF\* 브랜드 완제 8종(76000/88000/300-ACT/Printstar 등) 옵션 + item_gbn** — Vue client-render. CLTMSHS(브랜드 완제·실측 clothes2025)로 동형 강한 추정·CLDF 인스턴스 미확정.
- **CLST 가방/모자/에이프런(CLSTSAP/TOB/LUB/CAP) 모델** — 굿즈형(tmpl·apparel_info 부재) 추정·미관측. CL 카테고리 내 비의류 경계.
- **인쇄위치 다중선택 가격 합산 규칙** — 좌측가슴 단일(3700) 실측. 다위치 동시·위치별 단가 차이 미관측.
- **인쇄방식별 가격 차이** — DTF/DIR 동일(19900) 실측. 실크(SLK)·방식×위치 조합 미관측.
- **size_color_info HIDE_YN 셀별 가용성 UI 동작** — 셀 데이터 실측·실제 비활성 캐스케이드 동작 미관측.
- **CL 전반 PRICE>0 실가** — CLSTSHS 19900만 실측. CLTMSHS·CLAPDFT 가격 미캡처(구조 확정).

## CL 미샘플 상품 (30종 중 26종, 대표3+CLDFSHS 외 그룹 횡단)
자체의류 12(CLSTDLD~CLSTBSH 반팔/긴팔/스웻/후드/맨투맨/탱크탑·원단 4.01~10.0oz)·자체 가방/모자/에이프런 4(CLSTSAP·CLSTTOB·CLSTLUB·CLSTCAP 캔버스류=굿즈형 추정)·브랜드완제 7(CLDFMHS~CLDFNCP·제품번호)·단체 2(CLTMMTS·CLTMHDS) — 구조 다양성(2모델·size×color매트릭스·3인쇄방식·6위치·자체/브랜드/단체 3분기·아동사이즈·Pantone)은 대표3+CLTM/CLDF로 커버. 검증 시 갭(가방/모자 굿즈모델 확정·후드집업 지퍼·CLDF 낱장가격·다위치 합산)은 로그인 캡처로 추가.

## 라이브 접속 가능 여부 (다음 단계 참고)
- **chrome MCP (navigate/get_page_text)**: 이 실행 컨텍스트에서 **미주입**(역할 frontmatter 선언됐으나 런타임 불가).
- **BFF API (`/rp-api/.../get_digital_product_info`)**: 익명 curl **불가** — 세션토큰/리퍼러 인증 BFF 뒤(캡처 토큰 만료). retCode 999 / error page.
- **상품 페이지 HTML (`/ko/product/item/{cat}/{code}`)**: 익명 GET **가능**(읽기전용). 레거시 jQuery 상품(일부 BN)은 SSR `<select data-type={...}>`로 옵션 노출 → 정적 추출 성공. **신규 Vue 상품(전 GS·신규 BN)은 client-render**(SSR엔 `km1_size` 전역 샘플 select만, 실옵션 미노출) → huni-widget 기존 캡처 의존.
- **GS 확장 확인(2026-06-17)**: 코스터/폰케이스/레더노트/효자손 4상품 라이브 GET 시도 → 전부 신규 Vue, 옵션 SSR 미노출. **GS는 가격캡처(s3 reqBody/result)가 BN SSR보다 깊은 PCS 트리를 담아 1차 추출원으로 우수** — 8 reuse 캡처에서 DIR_MTR/INN_DFT/RIN_DFT/PDT_WRK/FLX_ZIP/WRK_MTR/THO_CUT 등 BN 미발굴 축 확보.
- **권장**: 신규 Vue 위젯 상품의 깊은 옵션/캐스케이드는 gstack browse(로그인 세션) 또는 widget_monitor 라이브 테스트베드(`raw/widget_monitor/local` → localhost:3001)로 보강. GS 코스터 6소재·폰케이스 기종 enum은 로그인 캡처 필요.

## 미관측(unobserved) 요약
- BNSTDFT/BNBNSOD/BNRLSLV/BNPTMAS/BNTNHVY의 **PCS_DTL 상세 옵션값**(예: 아일렛 사각귀퉁이/사각테두리) — SSR에 그룹 존재만 노출, 상세는 JS 렌더. 그룹 PCS_COD는 확정.
- 전 BN의 **PRICE>0 실가** — 비로그인 캡처(PRICE=0). RedPrinting PRICE≠0 정상이므로 0은 세션결함(메모리). 옵션구조엔 무관.
- 도수 다양성 — 전 샘플 SID_S(단면) 중심. 양면(SID_D) BN 상품 미샘플.

## GS 미관측(unobserved) 요약
- **4 live-augment 상품(코스터/폰케이스/레더노트/효자손) 옵션 상세** — 신규 Vue client-render·BFF 익명불가로 라이브 추출 불가. 상품정체·본체소재는 catalog 확정, 옵션 트리는 `unobserved`(§9~12 추정은 §0 굿즈 공통패턴 유추, 실측 아님 명시).
- **폰케이스 기종 enum** — 갤럭시/아이폰 수십 기종 variant·기종↔칼틀 캐스케이드 규모 미관측.
- **코스터 6소재 개당단가·옵션** — 소재가 pdtCode 분리는 확정, 소재별 가격/옵션 미관측.
- **전 GS PRICE 실가** — 비로그인 캡처라 다수 PRICE=0(노트류·코스터). 단 텀블러45000·마스크끈2800·장패드16000·마이크네임택6000/7000은 실가 확보(가격모델 3종 입증). PRICE=0은 세션결함(메모리)·옵션구조엔 무관.

## TP 재사용 vs 라이브 비율 (23상품·대표3+20횡단)
- **재사용(reuse:productInfo)**: 2상품(TPCLECO·TPCLWLB) — huni-widget s6 캘린더 캡처 풀 infoCall(에디터 플래그 전체 + product_data + TPCLWLB PRICE=11900). ★TP 에디터/템플릿 축 1차 증거. **비-TP 트윈 HLCLSTD/HLCLWAL 실측 대조분도 재사용**.
- **라이브 보강(live:SSR)**: 1상품(TPTKDFT) — 레거시 jQuery·SSR 인라인 플래그(useKoiEditor=Y/usePDF=Y/digital_price) + 용지11종 + PCS data-type 6종 + 미싱/보딩 텍스트 추출.
- **catalog+SSR-partial**: 1상품(TPBCDFT) edicus 마커만, 옵션 unobs / 나머지 19종 catalog 상품명 + 그룹 횡단 태깅(unobserved 정직).

## TP 미관측(unobserved) 요약
- **신규 Vue TP 상품 옵션 상세 + 에디터 플래그**(TPBCDFT·TPCLSTD·TPCLHOL·TPCLWAL·TPCLWEK·디자인 X 군) — client-render·BFF 익명불가. item_gbn/useKoiEditor는 동형 자매(TPCLECO/TPCLWLB) 실측 외 추정.
- **템플릿 자산 카탈로그** — koi_template_resource_id/koiOption[] 관측분 null/빈배열(비로그인·미선택). 상품별 실제 템플릿 목록·VDP 변수 스키마 미관측(로그인 에디터 필요).
- **티켓 미싱/넘버링/일련번호 상세** — SSR "미싱" 텍스트만, 옵션구조·번호규칙 JS렌더. 순차번호 공정축은 가설.
- **TP 가격 실가 다양성** — TPCLWLB 11900(vTmpl)만 PRICE>0 실측. TPCLECO(tiered)·TPTKDFT(digital) 가격모델만 확정·실가 미캡처.

## TP 미샘플 상품 (23종 중 18종, 대표3+실측2 외 그룹 횡단)
디자인 X 4(명함/쿠폰/손목띠/슬로건)·박티켓·캘린더 4(탁상실측외 벽걸이타공/걸이/스케줄러)·북 3(엽서북/사진북/포토카드)·평면지류 8(와블러/떡메/점메/세팅지/네임·패키지스티커/데코페이퍼/상장) — 구조 다양성(에디터 3채널·템플릿 자산·페이지 계층·형태 variant·티켓 특화·이중수량)은 대표3+실측2로 커버. 검증 시 갭(VDP 변수·티켓 넘버링·상장 양식 템플릿)은 로그인 에디터 캡처로 추가.

## PR 재사용 vs 라이브 비율 (56상품·대표3+53횡단)
- **재사용(reuse:productInfo+price)**: 2상품(PRBKYPR·PRPOXXX) — huni-widget s3 캡처 풀 infoCall+priceCall. ★PR 다면/제본/접지 축 1차 증거(PRBKYPR 표지내지분리·면지10·제본방향·disable24·book2025 8조합 / PRPOXXX 접지7·45용지·후가공11). 접지축은 포스터 캡처가 리플렛 superset.
- **라이브 보강(live:SSR-negative)**: 1상품(PRLFXXX) — HTTP 200·305KB이나 신규 Vue client-render(옵션/플래그 미노출). 접지축은 동형 포스터 FLD_DFT 7종으로 확정.
- **catalog 횡단**: 53종 catalog 상품명 + 그룹 A~E 횡단 태깅(인쇄방식/제본방식/접지/자재분기 동형 추정·unobserved 정직).

## PR 미관측(unobserved) 요약
- **리플렛(PRLFXXX) 옵션 상세 + 접지 강제 여부** — Vue client-render. 접지 7종은 포스터 실측, 리플렛 접지필수/면수↔접지 캐스케이드 unobserved.
- **토너/인디고/리소 책자(PRBKO*·PRIDPRT·PRPORSO) 옵션** — catalog 상품명만. 윤전과 자재(YWM 윤전전용지)·최소수량·페이지범위 차이 unobserved.
- **제본방식별(스프링/트윈링/스테플러/실제본) PCS·자재** — PRBKYPR(무선 PER_DFT)만 실측. 나머지 제본 옵션 unobserved.
- **카드/엽서 특수후가공 상세** — 박색·형압·스코딕스 패턴·레이저커팅 칼틀값 unobserved(상품명만).
- **PR 전반 PRICE>0 실가** — 책자 8조합(56,000~420,900)만 실가. 포스터 등 PRICE=0(세션결함·구조 무관).

## ST 재사용 vs 라이브 비율 (36상품·대표3+33횡단)
- **재사용(reuse:productInfo+price)**: 8상품 풀 캡처(STTHUSR·STCUXXX·STPADPN·STPADNM·STTHCIC·STTHSQU·STDCFBR·STPADIY) — huni-widget s2 캡처 풀 infoCall(shape_info·THO_GRA/THO_DFT 칼틀·CUT_DFT 반칼/개별·소재19~26·disable 227·PAK_POL·skinInfo). STCUXXX·STPADPN·STTHCIC priceCall(reqBody/query — 칼틀·재단·화이트 PCS 전달 실측). ★ST 형상/칼선/재단입자/점착소재/인쇄방식 축 1차 증거.
- **라이브 보강(live:SSR-negative)**: 1상품(STTHCIC) — HTTP 200·306KB이나 신규 Vue client-render(전역 km1_size 샘플+footer만·반칼/모양/자유형은 정적 마케팅 카피·옵션 select 미노출). 구조는 s2 풀 캡처로 확정.
- **catalog 횡단**: 36종 전부 category=ST·/item/ST/ 확인(PR D-7식 코드접두≠카테고리 누수 0). 28종 catalog 상품명 + 그룹 A~F 횡단 태깅(형상/칼선/점착/인쇄방식 동형 추정·unobserved 정직).

## ST 미관측(unobserved) 요약
- **UV 스티커(STPAU*) 가격엔진/자재** — DTF(STPAD*) 실측으로 vDigital/vTmpl 추정하나 UV 자재·도수·화이트강제 unobserved.
- **후지(STBPDFT)·수정(STMDDFT)·타원(STTHELP) 상세** — 후지 은염·수정 불투명백 추정·EL 칼틀 enum unobserved(CL/RC 실측 동형 추정).
- **점착특화/특수후가공 자재코드** — 자석(STMADFT)·오토바이PVC(STBKDFT)·박색(STFODFT FOI)·형압깊이(STEMDFT)·스크래치층(STSKDFT) unobserved(리무버블/옥외/메탈/한지는 STCUXXX/STTHUSR 소재 enum에 실재).
- **완제SKU형(STTPMSK 테이프·STTPBND 밴드·STDRCAD 카드스티커·STTBDFT 띠부) 규격** — 롤 폭×길이·밴드·결합형 구조 unobserved.
- **ST 전반 PRICE>0 실가** — 비로그인 캡처(STCUXXX/STPADPN retCode=999·PRICE=0=세션결함·구조 무관).

## ST 미샘플 상품 (36종 중 33종, 대표3+실측5 외 그룹 횡단)
형상칼선5(STPADIY·STCUNXT·STTHCIC·STTHELP·STTHSQU·STCUUSR)·다양한모양/패브릭4(STDCFBR·STSHDFT·STRMSHP·STFBDFT)·점착특화7(STRMDFT~STSKDFT)·특수후가공/소재5(STFODFT~STKPDFT)·인쇄방식분기7(STPAU*·STPADDY·STPADNM·STBPDFT·STMDDFT)·기타형태4(STDRCAD·STTBDFT·STTPMSK·STTPBND) — 구조 다양성(형상5·칼선2메커니즘·재단입자2·점착소재 spectrum·인쇄방식4·판/die-cut/완제 3가격엔진)은 대표3+풀실측8로 커버. 검증 시 갭(UV 가격엔진·후지/수정 방식·EL칼틀·자석/메탈 자재·완제SKU 테이프)은 로그인 캡처로 추가.

## PR 미샘플 상품 (56종 중 53종, 대표3 외 그룹 횡단)
포스터군10(PRPODAY~PRPOBLT)·카드엽서16(PRCA*/PRKC*/PRCABMK/PRCATCK)·책자18(PRBKY*/PRBKO*/TPRNBND)·용도별책자6(PRBKPSN~POL)·평면POP5(PRCPDFT~PRIDPRT·PRBNDGN) — 구조 다양성(접지7·제본5·인쇄3·표지내지분리·페이지차원·박/형압/스코딕스/레이저커팅·자재분기)은 대표3+풀실측2로 커버. 검증 시 갭(토너↔윤전 차이·제본방식별 PCS·스코딕스 패턴·인디고 낱장)은 로그인 캡처로 추가.

## GS 미샘플 상품 (136종 중 124종, 답습 회피로 의도적 제외)
케이스류 19종(GSCAGB*글라스범퍼·GSCATPG/P투명젤·GSCAEPB에폭시·GSCAPDL에어팟레더 등), 텀블러/보틀 다수, 파우치 6소재(GSPULTC/GSPULTH 레더·GSPUFBC코튼 외), 거울/스트랩/뱃지/마그넷/스티커형 굿즈 등 — 구조 다양성은 12샘플로 충분히 커버(완제SKU·variant 3채널·자재 다중슬롯·제본 3방식·본체조립·tiered가격·소재축 6분기·기종variant). 메타모델 검증 시 갭(예: 케이스 기종 enum 규모·뱃지 핀부착 bundle) 발견되면 추가.

## BN 미샘플 상품 (23종 중 17종, 답습 회피로 의도적 제외)
BNBNLOW(특가현수막), BNBNDAY(오늘출발), BNTPSNG(타포린단면), BNFGBNR(깃발), BNHGDBL(양면행잉), BNHGTRA(투명행잉), BNHGMAS/BNHGSGW, BNSTPED(오늘출발X배너), BNSTDGN/BNSTEPX/BNSTMAS/BNSTMSD/BNSTTRA, BNLGSOD, BNBNDAY 등 — 구조 다양성은 6샘플로 충분히 커버(소재변형·거치형·형상특이·최대가공). 메타모델 검증 시 갭 발견되면 추가.

## 다음 단계 (rpm-metamodel-architect 주목)
1. **소재 합성코드 추상화** — MTRL_CD 4~5축 분해(TYPE/PTT/CLR/WGT/인쇄방식)를 후니 5축 자재모델에 매핑. 후니 자재오염(색/형상 혼입) 대조.
2. **공정/bundle 분리 모델** — SUB_MTRL_YN 플래그 = 후니 "옵션=자재+공정 BUNDLE" 동형 확인.
3. **부속물(거치대) 축** — 본체와 분리된 SKU/번들 축 + size 캐스케이드 모델링.
4. **소재→강제옵션 규칙 엔진** — PET→코팅필수, 텐트천→포장필수 (ESN_YN/PKG_GB) = disable의 역(force) 제약.
5. `_ambiguous-fragments.md` 모호 항목 버킷 확정.

## 다음 단계 — TP 추가분 (rpm-metamodel-architect 주목)
6. **★에디터/디자인입력 축 신설 검토** — `item_gbn`+useKoiEditor/useRPEditor/usePDF/useTemplateDownload 플래그 묶음을 후니 어느 그릇으로? 옵션 트리와 직교 → 7버킷 어디에도 안 들어감(vessel-gap 1순위). T-1.
7. **★템플릿 "디자인 자산" vs "완제 SKU" 분리** — TP 템플릿(디자인 시안·가격0·에디터 종속)이 후니 `t_prd_templates`(완제SKU·봉투/OTC)와 같은 단어 다른 의미. 템플릿 개념 2분화 필요. T-2.
8. **에디터 채널 3종 계약 재사용** — KOI/Edicus/없음. huni-widget 역공학 RedEditorSDK 45메서드 계약(setCurrentTemplate/openVdpViewer/setVariableData) 이미 확보 → TP 메타모델이 그 계약 흡수.
9. **페이지 계층(INN_PAGE)·티켓 넘버링/미싱 공정축** — 캘린더 월수·북 대수 + 순차번호/절취선이 옵션/차원/공정 중 무엇? T-3·T-7.

## 다음 단계 — PR 추가분 (rpm-metamodel-architect 주목)
10. **★표지/내지 역할(role) 자재·도수 슬롯** — `pdt_mtrl_info` vs `inner_pdt_mtrl_info`(가격 cover/inner 단가 분리). 후니 단일 본체 자재모델에 "역할 차원" 추가 검토(캘린더 TP·파우치 GS 표지내지와 합류). P-2.
11. **★접지(FLD_DFT 7종) = 면 분할 공정축 신설** — directive #1 핵심. 후니 미발굴(BN/GS/TP 전무). 접지방식↔면수↔오시 캐스케이드. P-1·P-9(스코딕스/레이저커팅 특수공정).
12. **★페이지(INN_PAGE) 다면 차원 통합** — 책자 대수(10~300)·캘린더 월수(TP)·북 대수가 같은 필드 다른 의미. 부수와 직교·가격 선형가산. "다면 페이지 차원" 추상화(T-7과 합류). P-3.
13. **★제본/인쇄방식 상품분기 vs 옵션화** — 책자 19상품=윤전/토너×무선/스프링/트윈링/스테플러/실제본×컬러/흑백 매트릭스를 개별 pdtCode. 인쇄방식이 자재(YWM)·최소수량·가격모델 동반결정 → 단순 옵션화 위험(P-4·P-7·P-8·TP T-4 동류).
14. **★규격 인쇄물 vs 면적 산정물 가격엔진 경계** — 포스터 digital_price(좌표→자유사이즈) vs BN 면적매트릭스(좌표→룩업). 같은 좌표 입력·다른 엔진. 사이즈 차원 통합모델·price_gbn 분기 정합. P-6.
15. **★면지 자재+공정 BUNDLE** — END_PAP(색=컬러지 자재+삽입=공정). GS 제본 bundle·아일렛 동형. P-5.

## 다음 단계 — ST 추가분 (rpm-metamodel-architect 주목 — ★16축 포화 가설 깨질 후보)
16. **★형상(shape) 1급 기초코드 축 신설** — `option_info.shape_info` SQ/CL/EL/RC/FR enum. BN/GS/TP/PR 전무한 distinct 신규 축(directive #1). 상품분기(원형=STTHCIC)·한상품 옵션(STDCFBR 5형상) 양면 인코딩 모델 결정. S-1.
17. **★칼선 2메커니즘 + 칼틀 enum** — `THO_GRA`(자유칼선/도무송) vs `THO_DFT`(형상별 사이즈 칼틀 enum: 원형 11·라운드 25). PR THO_GRA(1종)보다 깊다. 칼틀이 사이즈를 겸함. S-2·P-9(레이저커팅) 합류.
18. **★재단 입자(반칼/완칼/낱장) 축** — `CUT_DFT` 묶음재단(반칼시트)/개별재단(완칼낱장). directive #2 핵심. GS 완칼 THO_CUT과 "분리 입자" 축 통합 검토. S-3.
19. **★점착/내후 자재 차원** — 강접/리무버블/유포옥외/저온/자석/메탈/한지가 소재 enum + 특화상품 양면. 후니 자재모델(지종×평량)에 점착강도/내후등급 차원 추가(directive #3·GS 본체소재·PR 방수/점착포스터 합류). S-4.
20. **★인쇄방식 분기 통합(PR과 횡단)** — ST 일반/UV/DTF/후지 + PR 윤전/토너/인디고/리소. pdtCode prefix가 자재·도수노출·화이트강제·가격엔진 동반결정. "인쇄방식=상품분기" 횡단 패턴 통합. S-5·P-4·P-7.
21. **★판 vs die-cut vs 정가 3가격엔진 경계** — die-cut(digital_price 산정)·판(vTmpl_price 템플릿·완제SKU형)·정가(tmpl_price). price_gbn 분기 기준·GS tmpl/PR digital/book2025와 정합. S-6·P-6.
22. **disable 룰엔진 정점 케이스(227건)** — ST `pdt_disable_pcs_info`가 BN 강제·PR 24건보다 깊다. JSONLogic constraint vs 자재-후가공 호환매트릭스 그릇 일반화 검증. S-8.
23. **화이트강제 분기·넘버링 VDP·완제SKU 스티커** — PRT_WHT(일반 선택/DTF 강제·S-7)·NUM_DFT(가변 넘버링 VDP·S-9·TP 티켓 합류)·테이프/밴드 완제SKU(S-10·GS tmpl 합류).

## 다음 단계 — CL 추가분 (rpm-metamodel-architect 주목 — ★의류 variant = distinct #18 판정)
24. **★의류 variant #18 distinct vs GS facet 최종 판정** — C-2 핵심 directive. 1차 예측=**distinct #18**(근거: item_gbn `clothes2025` 별 그릇·apparel_info 전용 6키·size×color 2D 매트릭스·Pantone1124·인쇄위치6·인쇄방식3 모두 GS variant 초과). GS와 공유분=DIR_MTR 본체 PCS·PRICE주체·SKU라벨융합(variant 상위개념). 아키텍트가 §15 #1~4로 distinct 비준 또는 "variant 메타축의 의류 facet" 재분류.
25. **★`apparel_info` 전용 그릇 = vessel-gap 정점** — C-1. print_type/area/color/size enum + size_color_info(227셀→MTRL_COD) + pantone1124가 후니 어느 그릇에도 직접 안 들어감. 의류 전용 테이블군 신설 vs 기초코드+자재+제약 조합뷰 판정. 후니 굿즈 본체소재 부재(round-22 GPM)와 연결.
26. **★size×color = MTRL_COD 2D 매트릭스 그릇** — C-3. 후니 자재모델 1D(지종×평량)→CL 2D(size×color)→1 MTRL. variant 4번째 인코딩 흡수 그릇(자재행 폭발 vs 매트릭스 테이블).
27. **★인쇄위치(print_area) 다중선택 공정축** — C-4. 기초코드(위치 enum)+공정(PDT_WRK 위치별 가산)+에디터매핑(KOI_NME→TP 채널#16). PR 다면·GS PDT_WRK와 경계 재정의.
28. **★카테고리 내부 2모델(item_gbn 분기)** — C-5. 같은 CL이 clothes2025(티셔츠)·tmpl(앞치마/가방)로 그릇 분기. 후니 "카테고리" vs "모델/생산형태" 버킷 분리. round-15 생산형태×그릇 합류.
29. **★원단 출처 3분기·GBN 연령·Pantone 규모** — C-6/C-7/C-8. CLST/CLDF/CLTM=원단 라이브러리 계열(옵션모델 동일·자재 카탈로그 분리) vs 카테고리/판매단위. 사이즈 GBN(성인/아동) 축. Pantone1124 별색=공정(후니 round-22) vs 의류 별색 도메인. 인쇄방식 인코딩 2표현(CL 옵션 vs ST/PR 상품분기) 통합.

## 커버리지 맵 — PH(포토보드·액자·사진인화·포토북·포토굿즈, 30상품·★완제 액자 그릇/마운팅·출력매체 5상품군 공존)
| pdtCode | 상품 | 핵심 단서 | 축수 | 자재(대표) | 옵션/variant | 공정/형태 | 가격 | 출처 |
|---|---|---|---|---|---|---|---|---|
| PHPTPRM | 포토 보드 | ★보드/판·포스터 동형·풀 SSR | 5 | 인화지×마감(유광/반광/스노우/홀로그램) | 규격5·디자인수·매수 | koi 에디터 | tmpl_price | `[live:SSR-legacy]` 풀 |
| PHFRDIA | 디아섹 아크릴 액자 | ★완제 프레임·거치 캐스케이드 ★§0.5 OBSERVED | 6 | 디아섹(프레임재질 pdtCode 분기) | **거치(탁상용/벽걸이)→마감→완제SKU사이즈** | 완제 조립 | unobserved | `[live:client-render]` |
| PHPTEDT | 일반 사진인화 | ★인화지×마감 합성·형태(비율) ★§0.5 OBSERVED | 5 | 인화용지(반광-러스터/유광) | **형태(일반/정사각/파노라마)**·사이즈8 | - | unobserved | `[live:client-render]` |
| PHPRDFT | 증명사진600 | ★[재고부족]홀로그램 disabled ★§0.5 OBSERVED | 4 | 인화용지(유광)·홀로그램(disabled) | 수량(set 배수) | - | unobserved | `[live:client-render]` |
| PHBKMYB | 내 파일 포토북 | 사진책 제본·PR 책자 동형 | 4 | 표지/내지 | 정사각계 사이즈·단/양면 | 제본(소프트/하드/프리미엄) | digital_price | `[live:SSR-legacy]` |
| PHPODFT | 포토 화분 | 전사인쇄 완제굿즈·GS 동형 | 4 | 전사지·화분 본체 | 단면·80x95mm·건수+수량 | 전사인쇄 | tmpl_price | `[live:SSR-legacy]` |

> 5개 이질 상품군: ① 액자 PHFR*(11·프레임재질=pdtCode 분기) ② 사진인화 PHPT*/PHPR*/PHPK*(8) ③ 보드·판 PHPTPRM·PHST*(4) ④ 포토북 PHBK*(5) ⑤ 포토굿즈 PHMG/PHPO(2). 나머지 24종은 reverse.md §4 그룹 A~E에 묶어 횡단 태깅(답습 회피). 모집단=catalog category=PH 30상품(전부 /item/PH/).
> **★§0.5 client-render 재캡처(gstack browse 2026-06-17·블로커 해소)**: reverse 1차의 SSR-negative(액자/사진인화 Vue client-render 옵션 미노출) 블로커를 OBSERVED로 해소 — PHFRDIA 거치(탁상용/벽걸이) 캐스케이드·PHPTEDT 인화지×마감 합성+형태축·PHPRDFT [재고부족]disabled 실측.
> **★PH 발굴 fragment(전부 facet·distinct 0)**: PH-1 완제 프레임=완제SKU#4(거치+마감+사이즈 인코딩)+자재#1 variant+생산형태#15(★directive 최대 관전·1차 예측 facet 강화) · PH-2 거치=옵션#3 캐스케이드 상위 차원(★RESOLVED OBSERVED)·전면재=자재#1 내재·후면받침=부속물#8(미관측) · PH-3 인화지×마감=자재#1 surface-finish(ST S-4/AC A-2) · PH-4 set 단위=수량#10+완제SKU#4 base_quant · PH-5 머그·화분=카테고리#7 다중분류 · PH-6 형태(일반/정사각/파노라마)=사이즈#13 비율 프리셋(형상#17 부결). **★17축 안정성: PH가 9번째 카테고리로 재포화 — §0.5 거치 OBSERVED(미싱데이터 해소)되었으나 옵션 캐스케이드 + 완제 SKU variant 구현 → ST 형상#17 같은 KB 결함 부재로 distinct #18 부결.**

## 커버리지 맵 — FS(패브릭·봉제 완제 직물 굿즈, 21상품·★면직물(면사 수)+타일링+마감봉제+완제 봉제가공 본질)
| pdtCode | 상품 | 구조 다양성 | 축수 | 자재(면사 수) | 타일링 | 봉제/가공 | 가격모델 | 출처 |
|---|---|---|---|---|---|---|---|---|
| FSSQPST | 패브릭 포스터 | ★패브릭 현수막·풀슬롯 | 9 | 면10/20/40/60수 | TIL_NON/세로/가로 | SEW_FBR(오버로크/말아박기/벨크로)+행잉/봉/고리(BN 상속)+별색 6색×3농도 | real_price(면적) | `[live:SSR]` 풀 |
| FSCUDFT | 패브릭 쿠션 | ★양면 봉제·솜 충전 | 8 | 면10/20수 | 동형 | 솜(TN001)+PDT_WRK(쿠션가공)+라벨 | real_calc_price | `[live:SSR]` 풀 |
| FSBGECO | 에코백(풀프린팅) | ★완제 가방·끈/포켓/자석 | 11 | 면10/20수 | 동형 | 끈(LIN_PRT)+포켓(POC_FBR)+자석(WRK_MTR)+에코백가공 | real_calc_price | `[live:SSR]` 풀 |
| FSPUSTR | 스트링 파우치 | 파우치 완제 | 8 | 면20/40수 | 동형 | PDT_WRK(스트링파우치가공)+라벨 | real_calc_price | `[live:SSR]` 풀 |
| FSBDSCR | 스크런치(곱창머리끈) | 소형 봉제 variant | 8 | 면60수 | 동형 | PDT_WRK(스크런치가공)+포장 | real_calc_price | `[live:SSR]` 풀 |

> 5개 이질 구조: 평면 현수막형(FSSQPST·real_price·BN 행잉/봉 상속) · 양면봉제+솜(FSCUDFT) · 완제 가방(FSBGECO·끈/포켓/자석) · 파우치(FSPUSTR) · 소형 봉제 variant(FSBDSCR). 나머지 16종(코스터/엽서/노렌/테이블류·쿠션/커버·파우치/필통·가방·스카프)은 reverse.md §9에 소재/형태/부자재만 다른 동형으로 묶음(답습 회피). 모집단=catalog category=FS 21상품(전부 /item/FS/). ★전 5상품 레거시 productOrder SSR(vueMarkers=0·라이브 추출 성공·PH 같은 client-render 블로커 없음).
> **★FS 발굴 fragment(★directive 1순위=신규축 선별 모드)**: **FS-1 ★타일링(TILL_WH_GBN: 없음/세로/가로)=distinct #18 후보 1건·판정보류** — 전 9 카테고리 전무 + 명시 슬롯 실재(승격기준 ①충족)이나 후니 KB "인쇄 레이아웃/반복" 흡수처 실재 여부 미확정(②미확정)→1차 예측 공정#2(인쇄 배치) facet 흡수 우세이나 ST 형상#17·CL 인쇄위치 승격과 대조해 아키텍트/갭분석가 결정. FS-2 방향(PAPER_WH W/H)=사이즈#13 facet · FS-3 면직물(면사 수 綿絲 count)=자재#1 평량 차원(CL oz·PD 원단·GS 코스터 소재 동형) · FS-4 별색(SID_FBR 6색×3농도)=공정#2 별색 family(CL Pantone 1124 축소 직물 도메인) · FS-5 마감봉제(SEW_FBR 오버로크/말아박기/벨크로)·제품가공(PDT_WRK 상품별 명칭)·FBR-접미 슬롯=공정#2 family(PD SEW_LTR 동형)+부속물#8(라벨/끈/자석 BUNDLE·AC/ST/PD SUB_MTR) · FS-6 솜/끈/자석=완제 부자재(옵션 노출 vs 고정BOM·PD-4 vessel-gap 합류) · FS-7 가격모델 분기(real_price 현수막형 vs real_calc_price 봉제완제·PD tmpl 아님). **★17축 안정성: FS가 10번째 카테고리로 재포화(타일링 1건 제외 무손실 흡수) — 가장 이질적 "직물 풀프린팅+봉제 완제 굿즈"조차 17축 흡수. FS 진짜 기여: 자재#1에 "면직물·면사 수" 평량 단위 추가·공정#2에 "마감봉제(edge finish)" family 추가·★타일링이라는 반복-배치 차원을 metamodel/validator 흡수 vs 신축 판정에 던짐(PD 봉제 #18 부결과 일관하나 "전 카테고리 부재+명시 슬롯"이라 적대검증 대상).**

## 다음 단계 — PH 추가분 (rpm-gap-analyst 주목 — ★전부 facet·data-gap)
30. **★완제 SKU/거치 캐스케이드 그릇(data-gap)** — PH-1/PH-2. `t_prd_templates`/완제SKU 그릇 실재·거치방식 polymorphic ref(옵션#3·AC GRP_OPTION_CD cascade 동형)·거치+마감+사이즈 완제 variant 적재만(축 부재 아님·vessel-gap 아님). [HARD] 완제 SKU 라벨 분해 {mount_type,finish,frame_material,size}(G-1/AC variant 동일 처방).
31. **★인화지×마감 surface-finish 분해 그릇** — PH-3. ST S-4 점착/AC A-2 surface-finish 합성축(V-3) 합류·`{ptt, surface_finish}` 분해(직물 물성 차원·점착/내후와 동근).
32. **★미관측 라이브 재캡처 후보** — 전면 보호재 별옵션 액자(한나무/멀티 미캡처)·후면 받침(부속물#8 후보·unobserved)·포토북(PHBK*) 면수/제본 client-render·set base_quant(it_g_base_quant) 상세. deepcheck/gap이 필요 시 라이브 재캡처 또는 후니 도메인 권위로 확정.
