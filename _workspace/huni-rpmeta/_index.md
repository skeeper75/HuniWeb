# RP 추출 커버리지 인덱스

> 후니 RP-Meta 하네스 파이프라인 ① — 샘플 커버리지 맵 (rpm-reverse-engineer).
> 실행 이력: ① BN(현수막류) 파일럿 6+1상품. ② GS(굿즈/잡화) 확장 12상품. ③ TP(디자인템플릿) 확장 대표3+20횡단. ④ PR(인쇄물·책자) 확장 대표3+53횡단. 대표 샘플링(답습 전수수집 아님).

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

## 재사용 vs 라이브 비율
### BN(7상품)
- **재사용(reuse:Vue-BFF)**: 2상품(BNBNFBL, BNPTPET) = 29% — huni-widget s3 캡처 풀 옵션트리(productInfo 실응답).
- **라이브 보강(live:SSR)**: 5상품 = 71% — 2026-06-17 읽기전용 HTML SSR select 추출.
### GS(12상품)
- **재사용(reuse:price-capture)**: 8상품(텀블러·마스크끈·장패드·스프링노트·중철노트·스케치북·파우치·마이크네임택) = 67% — huni-widget s3 가격캡처 reqBody/result/query 풀 추출(BN SSR보다 깊은 PCS 트리).
- **라이브 보강(catalog+SSR-negative)**: 4상품(코스터·폰케이스·레더노트·효자손) = 33% — 상품정체·소재축은 catalog 확정, 옵션 상세는 client-render·BFF 익명불가로 `unobserved`(라이브 추출 시도했으나 GS 신규 Vue 옵션 미노출 확인).

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
