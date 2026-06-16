# RP 추출 커버리지 인덱스

> 후니 RP-Meta 하네스 파이프라인 ① — 샘플 커버리지 맵 (rpm-reverse-engineer).
> 실행 이력: ① BN(현수막류) 파일럿 6+1상품. ② GS(굿즈/잡화) 확장 12상품. 대표 샘플링(답습 전수수집 아님).

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
