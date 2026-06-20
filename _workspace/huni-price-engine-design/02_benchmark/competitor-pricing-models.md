# 경쟁사 디지털인쇄 가격계산 모델 분석 (파일럿)

> 후니 가격계산 엔진 설계 하네스 — `hpe-benchmark-analyst` (경쟁사 가격계산 방식 흡수가·기준점).
> **목적[HARD]**: 가격차 합리성 판정(`dbm-competitor-benchmark`)이 아니라, 와우프레스·레드프린팅이
> 디지털인쇄류 상품(명함·전단·엽서 등)의 가격을 *어떻게 계산하는가*(구성요소 축·계산식·캐스케이드·세트)를
> 역공학해 후니 `t_prc_*`에 흡수할 메커니즘을 추출한다.
> **범위**: 디지털인쇄류 파일럿(명함·전단·책자·옵셋명함). 1차 캡처 재사용·재크롤 최소·라이브 읽기전용.

## 출처 표기

- `[wow:capture]` = `raw/widget_monitor/wow_capture/fresh_{namecard,flyer,booklet}_capture.json` (2026-03-31 캡처·jQuery 페이지 select DOM 추출). 가격값은 서버계산이라 캡처 미노출(`priceDisplay:[]`) — **구조가 곧 흡수 대상**.
- `[red:NC-reverse]` = `_workspace/huni-rpmeta/categories/NC/reverse.md` + `captures/nc_cap_{NCDFDFT,NCDFFLD,NCCDPHO}.json` (2026-06-19 infoCall 라이브 인터셉트·retCode 200·read-only). RedPrinting 서버 base-data 스키마 실측.
- `[red:capture]` = `raw/widget_monitor/red_captures/v2_PRBKORD_capture.json` (book2025_price·MTRL_CD×PRN_CNT 매트릭스 실측).
- `[huni:ddl]` = `_workspace/huni-dbmap/00_schema/price-engine-ddl.md` (후니 `t_prc_*` 4단 엔진 권위 해석).
- `unobserved` = 미관측(날조 금지).

---

## 0. 두 경쟁사의 가격계산 아키텍처 한눈 비교

| 항목 | 와우프레스(WowPress) | 레드프린팅(RedPrinting) | 후니 `t_prc_*` 대응 |
|------|---------------------|------------------------|---------------------|
| 가격 계산 위치 | 서버계산(클라 미노출·`priceDisplay:[]`) `[wow:capture]` | 서버계산(`price_gbn` 토큰이 엔진 선택) `[red:NC-reverse]` | 서버 `evaluate_price`(공식엔진) `[huni:ddl]` |
| 옵션 분해 | `pdata`(본품: 사이즈·도수·용지) vs `spdata`(후가공 `awk*` 코드) | `pdt_*_info` 슬롯군(size/mtrl/dosu/prn_cnt/pcs) | 차원(siz/clr/mat/coat/bdl/min_qty) + 구성요소 |
| 가격엔진 다중성 | 상품군별 가격표 분기(명시 토큰 미노출) | **`price_gbn` 토큰으로 엔진 라우팅**: `digital_price`/`offset2023_price`/`book2025_price`/`vTmpl`(면적) | `frm_cd`(공식)로 상품 바인딩 — 같은 발상 |
| 수량 처리 | 이산 tier select(명함 500~30000매·전단 0.5~200연) `[wow:capture]` | **인쇄방식별 갈림**: 디지털=연속 increment(첫100·증100), 옵셋=자재종속 이산 tier(MTRL_CD×PRN_CNT) `[red:NC-reverse]` | `min_qty`(수량구간하한·상향개방·max 없음) |
| 후가공 | `spdata_awk{코드}` 그룹별 select(박·형압·미싱·타공·오시·재단·접지) | `pdt_pcs_info` 그룹(CUT/COT/HOL/ROU/OSI/SUB_MTR) | 구성요소 `comp_typ_cd`(후가공비) + `addtn_yn` 합산 |
| 자재↔후가공 의존 | 미관측(서버) | **`pdt_disable_pcs_info`**: 자재별 후가공 비활성 `[red:NC-reverse]` | 미보유(흡수후보 C-4) |

**한 줄 결론**: 두 경쟁사 모두 가격을 **(본품 단가) + Σ(옵션·후가공 가산)** 의 합산형으로 계산하고, **인쇄방식·상품군에 따라 별도 가격엔진을 라우팅**한다. 이 발상은 후니 `frm_cd`(상품→공식 바인딩) + `addtn_yn`(구성요소 합산) 4단 엔진이 이미 동형으로 담는다. 새로 흡수할 가치가 있는 건 **세 가지 표현력 갭**(인쇄방식 라우팅의 명시화·자재×수량 허용 매트릭스·자재↔후가공 비활성)이며, 새 축(테이블) 신설이 아니라 기존 그릇의 활용·코드값/제약으로 닫힌다.

---

## 1. 와우프레스(WowPress) 가격계산 모델 `[wow:capture]`

### 1.1 옵션 2층 분해 — `pdata`(본품) vs `spdata`(후가공)

와우프레스 상품 폼은 select id 접두사로 가격축이 명확히 2층으로 갈린다:

| 층 | select id 패턴 | 의미 | 가격 역할 |
|----|---------------|------|----------|
| **본품(pdata)** | `pdata_00_sizeno`, `pdata_00_colorno`, `pdata_00_ordcnt` | 사이즈·도수·건수 | 본품 단가표의 차원 키 |
| **용지(spdata paper)** | `spdata_00_paperno3`, `spdata_00_paperno4` | 용지종류·평량 | 본품 단가의 자재 차원 |
| **수량(spdata qty)** | `spdata_00_ordqty` | 주문 부수/연 | 단가구간 룩업 키 |
| **후가공(spdata awk)** | `spdata_00_awk{코드}1`, `…2` | 후가공 종류+세부 | 가산 단가(opt-in) |

★ **명함(40073) 실측 축** `[wow:capture]`:
- 사이즈: `90x50`/`50x90`/`86x52`/`88x53` + 비규격(SizeNo 4종)
- 도수: `단면 칼라4도`/`양면 칼라8도` (ColorNo 2종 — 단/양면 × 도수 합성)
- 용지: 종류 `스노우지(무광코팅)`/`스노우지(무코팅)` × 평량 `219g`/`250g` (paperno3 × paperno4 = 2축)
- 수량: `500매`~`30000매` (ordqty 29 tier)
- 건수: `1건`~`50건` (ordcnt — 디자인 종수 멀티플라이어)
- 후가공(awk 그룹, 각 그룹 = 종류 select + 세부 select 2단):
  - 오시(awk1134): `1줄`/`2줄`/`3줄` × 위치(가로/세로/중앙)
  - 미싱(awk1135): 줄수 × 방향
  - 타공(awk1135): 개수 × `3mm`~`8mm`
  - 라운딩(awk23): 부분/전체
  - 넘버링(awk27): 개수
  - **박 앞/뒤(awk1152/1168): 박종류 9종(금박유광~먹박) × 크기 `15mm이하`~`90mm미만`**
  - 형압(awk1158): 크기 4구간

### 1.2 후가공 가격 패턴 = **종류 × 세부(크기/줄수/위치) 2단 룩업**

와우프레스 후가공은 거의 모두 `종류 select + 세부 select`의 2단 구조다(예: 박 = 박종류 9종 × 크기 4구간). 이는 후가공 가산 단가가 **(공정종류, 세부스펙) 2차원 룩업**임을 뜻한다. 박/형압이 **크기 구간(`15mm이하`/`30mm이하`/`70mm이하`/`90mm미만`)** 으로 가격이 갈리는 것은 후니 메모리 `dbmap-compute-in-app-db-stores-lookup`(박 면적→등급=앱계산·DB는 등급별 가격만)과 정확히 일치 — **흡수 불요(후니가 이미 동형)**.

### 1.3 수량 = 이산 tier select (자유입력 아님)

명함 `500매`~`30000매` 29 tier, 전단 `0.5연`~`200연` 201 tier. 와우프레스는 수량을 **미리 정의된 tier select**로 제공 — 곧 단가가 수량구간별 룩업이고, 구간 경계가 곧 select 옵션이다. 후니 `min_qty`(수량구간하한·상향개방)와 동형이나, **와우프레스는 tier 경계를 옵션으로 노출**(UX 차이일 뿐 가격 모델은 동일).

### 1.4 건수(ordcnt) = 디자인 종수 멀티플라이어

명함 `1건`~`50건`, 전단 `1건`~`20건`. "건"은 같은 사양·다른 디자인의 종수 → 본품 단가에 곱해지는 별도 축. 후니는 이를 별도 차원으로 두지 않고 주문라인 반복으로 처리(견적 단위). **흡수 후보 C-5**(주문수량 vs 디자인 건수 구분)로 라우팅.

---

## 2. 레드프린팅(RedPrinting) 가격계산 모델 `[red:NC-reverse]`

RedPrinting은 사용자 본인 설계 시스템(검증된 참조)이라 흡수 정당하나, naming/codes는 후니 유입 금지. 서버 base-data 스키마가 **infoCall API로 실측**되어 와우프레스(DOM만)보다 가격 메커니즘이 더 깊이 드러난다.

### 2.1 ★`price_gbn` 토큰 = 가격엔진 라우팅 셀렉터 (핵심 흡수 후보)

RedPrinting은 상품마다 `price_gbn`/`item_gbn` 토큰을 박아 **어느 가격엔진으로 계산할지** 를 명시한다 `[red:NC-reverse]` `[red:capture]`:

| price_gbn | 상품군 | 계산 패턴 |
|-----------|--------|----------|
| `digital_price` | 디지털 명함/포스터(BC) | 연속 수량곡선 × 자재 × 도수 합산 |
| `offset2023_price` | 옵셋 명함/카드/쿠폰(NC) | 자재×이산부수 tier 룩업 |
| `book2025_price` | 책자/제본(PRBKORD) | 페이지·제본 합성 |
| `vTmpl`(면적) | 현수막 | [가로×세로] 면적매트릭스 |

→ **같은 "명함"이 인쇄방식만 다르면 다른 엔진**(디지털=`digital_price`·옵셋=`offset2023_price`). 후니는 이를 `frm_cd`(상품→공식 바인딩)로 이미 표현 — 한 상품군에 인쇄방식별 다른 `frm_cd`를 배정하면 동형. **rpmeta 결론(인쇄방식 = #12 기존축·새 축 부결)과 정합**: 가격엔진 선택자는 새 가격 축이 아니라 공식 라우팅 enum.

### 2.2 ★수량 의미가 인쇄방식별로 갈린다 (가장 깊은 발견)

같은 `pdt_prn_cnt_info`/`pdt_exp_prn_cnt_info` 슬롯이 인쇄방식별로 정반대로 채워진다 `[red:NC-reverse]`:

| 슬롯 | 디지털(BCSPDFT) | 옵셋(NCDFDFT) |
|------|----------------|---------------|
| `pdt_prn_cnt_info` | `FIR_CNT:100, INC_CNT:100, INC_STEP:10, MIN_PRN_CNT:1` = **연속 증가곡선**(첫100·100단위·최소1) | `PRN_CNT:500, DFT_PRN_CNT:500` (기본부수만·증가필드 전부 null) |
| `pdt_exp_prn_cnt_info` | `null` | **10행** = (MTRL_CD × PRN_CNT) 매트릭스: RXSNO250→{100..500}, RXWMO220→{100..500} = **자재별 허용 부수 tier** |

→ **디지털 = 자유 수량(연속·볼륨디스카운트 곡선)**, **옵셋 = 자재마다 정해진 이산 부수만 선택**(판·임포지션 경제성의 결과). 이건 후니 `min_qty`(수량구간) 그릇으로 가격은 담기되, **"자재마다 허용 수량이 다르다"는 제약**은 후니에 전용 그릇이 없다 → **흡수 후보 C-2**(자재×허용부수 제약 매트릭스, round-6 CPQ 제약 트랙).

### 2.3 접지 = 사이즈 SKU 흡수 + 오시 공정 동반 `[red:NC-reverse]`

옵셋 2/3단 명함(NCDFFLD)은 접지를 별도 옵션축으로 두지 않고 **사이즈 SKU 16종에 베이크**(`2단 세로형 90X50` 등 — 접지수×방향×규격 합성)하고 **오시(OSI) 공정을 동반**. 펼친 크기(WRK/CUT)가 접지수에 비례(2단=높이2배). → 접지 가격은 (펼친 면적·접지수 SKU) + 오시 가산. 후니는 사이즈 차원(`siz_cd`) + 후가공 구성요소로 동형 표현 가능 — **흡수 불요**(같은 "접는다"를 상품군별 다른 축에 매핑하는 건 후니도 자유).

### 2.4 자재↔후가공 비활성 = `pdt_disable_pcs_info` `[red:NC-reverse]`

RedPrinting은 자재별로 특정 후가공을 비활성(예: 특정 용지엔 코팅 불가)하는 `pdt_disable_pcs_info` 슬롯을 갖는다. 이는 가격이 아닌 **선택 제약**이지만 잘못된 조합의 가산을 차단해 가격 정합을 지킨다. 후니는 가격엔진에 이 제약이 없음 → **흡수 후보 C-4**(자재×후가공 비활성 제약, round-6 CPQ constraints).

---

## 3. 두 경쟁사 공통 디지털인쇄 계산식 패턴 (흡수용 정리)

| 패턴 | 와우프레스 | 레드프린팅 | 후니 표현 |
|------|-----------|-----------|----------|
| **합산형 본품+가산** | 본품 단가 + Σ(후가공 awk 가산) | base + Σ(pcs 가산) | `frm_typ_cd=합산형` + `addtn_yn='Y'` Σ |
| **본품 단가 = 다차원 룩업** | (사이즈×도수×용지×수량) | (size×mtrl×dosu×prn_cnt) | `component_prices` 6차원 (siz/clr/mat/min_qty…) |
| **수량구간 룩업** | tier select(29~201종) | 디지털=연속곡선·옵셋=이산tier | `min_qty` 상향개방 구간 |
| **후가공 = 종류×세부 2단** | awk{종류}1 × awk{종류}2(크기/줄수) | pcs 그룹 × detail | 후가공 `comp` × 세부 차원 |
| **인쇄방식 라우팅** | 상품군 분기 | `price_gbn` 토큰 | `frm_cd` 상품 바인딩 |
| **건수/종수 멀티** | ordcnt 1~50건 | unobserved | 주문라인 반복(차원 아님) |

**가격 합리성·할인순서**: 두 경쟁사 모두 클라에 단가·할인순서를 노출하지 않아 `unobserved`. 와우프레스 수량 tier·레드 볼륨디스카운트 곡선이 **수량구간 = 단가 하향**(볼륨디스카운트)임을 강하게 시사하나, 정확한 곡선·할인적용 순서는 라이브 가격조회를 안 쳐서 미관측(주문플로 회피).

---

## 4. 흡수 vs 답습 판정 요약 (상세는 `absorption-candidates.md`)

| 경쟁사 패턴 | 후니 이미 담음? | 판정 |
|------------|----------------|------|
| 합산형 본품+가산 | ✅ `frm_typ_cd`+`addtn_yn` | 흡수 불요 |
| 본품 다차원 단가 룩업 | ✅ `component_prices` 6차원 | 흡수 불요 |
| 후가공 종류×세부 2단 | ✅ 구성요소 × 세부차원 | 흡수 불요 |
| 박/형압 크기구간 | ✅ 메모리 `compute-in-app-db-stores-lookup` | 흡수 불요 |
| 접지 = 사이즈 SKU+오시 | ✅ `siz_cd`+후가공 | 흡수 불요 |
| **인쇄방식 가격엔진 라우팅 명시** | △ `frm_cd`로 표현 가능하나 명시 enum 없음 | **흡수후보 C-1**(약) |
| **자재×허용수량 제약 매트릭스** | ✗ 전용 그릇 없음 | **흡수후보 C-2**(중) |
| **수량구간 = 볼륨디스카운트 곡선 표현력** | △ `min_qty`는 룩업·곡선파라미터 없음 | **흡수후보 C-3**(약) |
| **자재×후가공 비활성 제약** | ✗ 가격엔진엔 없음 | **흡수후보 C-4**(중·round-6) |
| **디자인 건수 멀티플라이어** | △ 주문라인으로 우회 | **흡수후보 C-5**(약) |

→ **결론**: 디지털인쇄 가격계산의 **핵심 골격(합산형·다차원룩업·후가공가산·수량구간)은 후니 4단 엔진이 이미 동형으로 담는다**. 경쟁사에서 흡수할 실질은 **제약 레이어 2건**(자재×허용수량 C-2·자재×후가공비활성 C-4)이 가격 정합을 지키는 가드이고, 나머지는 명시화/표현력의 약한 보강(C-1/C-3/C-5)이다. 새 가격 축(테이블) 신설은 0건 — rpmeta "인쇄방식 #18 부결"과 정합.

---

## 5. 아크릴(면적매트릭스형) 가격계산 모델 — 종단 보강

> 상세 흡수 분석 = `absorption-candidates-acrylic.md`(C-A1~C-A7). 여기선 모델 골격만.
> 출처 `[red:AC]` = `_workspace/huni-rpmeta/categories/AC/reverse.md`·`raw/widget_monitor/cascade_captures/ACNTHAP_*.json` · `[huni:acryl]` = `_workspace/huni-dbmap/31_acrylic-price-link/` · `[wow:probe]` = WowPress 라이브 읽기전용(2026-06-20).

### 5.1 레드프린팅 아크릴 = 전용 가격엔진 `acrylic2025_price` `[red:AC]`
- **면적**: 자유사이즈 입력(키링 20×20~90×90·등신대 10×10~300×250) → `acrylic2025_price`가 면적 산정.
- **두께(3T/5T/라미)**: **자재 MTRL_CD의 WGT_CD 슬롯에 인코딩**(D01=3T·D02=5T·L01~04 라미) — 별 두께축 아님.
- **소재 variant(투명/홀로그램/유색/글리터/거울/자개/렌티큘러)**: 자재 PTT + 소재특화 pdtCode 양면.
- **후가공**: 완칼(`LAS_DFT`/FRXXX 자유형 레이저)·화이트(`PRT_WHT` 투명소재 종속)·부착물(`SUB_MTR` 고리80+/받침12 부자재 BUNDLE).
- **한 카테고리 3엔진 공존**: 명찰=`vTmpl_price`·키링=`acrylic2025_price`·등신대=`tmpl_price`(형태별).
- **제약**: `pdt_disable_pcs_info`(명찰 PET→코팅/미싱/부분UV 3건)·투명소재→인쇄면/화이트 캐스케이드.

### 5.2 와우프레스 아크릴 = 미관측 `[wow:probe]`
WowPress 굿즈/폰액세서리에 아크릴 실재(아크릴보드·아크릴톡)나 **옵션·가격 미캡처**(goods 캡처는 명함 페이지). 아크릴 면적 가격화 방식 **보강 불가**(정직 기록).

### 5.3 후니 아크릴 가격표(260527 8블록) — 권위 `[huni:acryl]`
| 블록 | 내용 | 공식유형 | 후니 그릇 |
|------|------|---------|----------|
| B01~B03 | 투명3T·투명1.5T·미러3T 본체 면적단가 | **면적매트릭스형** | `PRF_CLR_ACRYL`(투명3T+1.5T mat_cd 통합·라이브 실재)·`PRF_MIRROR_ACRYL`(신설) |
| B04 | 수량별 구간할인 6구간 0~50% | (할인·t_dsc) | 별 단계(면적단가×수량 후 할인) |
| B05 | 후가공 11그룹 추가단가(고리/핀/자석) | 후가공가산 | 후가공 comp Σ(`addtn_yn`) |
| B06 | 코롯토 6×6 면적매트릭스(30~80mm) | **면적매트릭스형** | `PRF_COROTTO_ACRYL`(신설) |
| B07 | 카라비너 4형상 고정가(자물쇠5800~원형6900) | **고정가형** | `PRF_CARABINER_ACRYL`(`.06 완제품비`·신설) |
| B08 | 카라비너 구간할인 3구간 | (할인·t_dsc) | — |

### 5.4 한 줄 결론
레드프린팅 아크릴 가격 골격(*면적 × 두께(자재) × 소재(자재) × 후가공 합산·형태별 엔진 분기*)은 후니 아크릴 가격표(면적매트릭스 B01~B03·B06 + 고정가 B07 + 후가공가산 B05 + 수량구간 B04)와 **동형**. 후니 4단 엔진(`PRF_CLR_ACRYL` 면적매트릭스 + 후가공 comp 합산 + t_dsc)이 이미 담는다. **두께=자재차원·면적=매트릭스ceiling·형태별=frm_cd 분기**가 핵심 흡수 원칙(전부 기존 그릇·신규 축 0). ★돈-크리티컬: 본체 comp `prc_typ .02` 정합(개당×수량 vs 총액)은 디지털 ×qty 과청구와 동일 클래스 — 엔진 계약 확정 선결.

---

## 6. 실사출력·현수막/배너(면적매트릭스형) 가격계산 모델 — 종단 보강

> 상세 흡수 분석 = `absorption-candidates-silsa-banner.md`(C-SB1~C-SB7). 여기선 모델 골격만.
> 출처 `[red:BN]` = `_workspace/huni-rpmeta/categories/BN/{reverse,summary}.md`(2026-06-17 대표 7상품·Vue3 BFF + 레거시 SSR 실측) · `[huni:silsa]` = `_workspace/huni-dbmap/33_silsa-price-quote/{poster-sign-component-redesign,silsa-quote-design,silsa-isomorph-merge-design}.md`(`포스터사인` 가격표 + 라이브 t_prc_* + pricing.py TIER 엔진) · `[wow:probe]` = WowPress 라이브 읽기전용(2026-06-20·경로 404·미관측).

### 6.1 레드프린팅 실사·현수막 = `real_price` 전용 면적엔진 `[red:BN]`
- **가격엔진**: `item_gbn=real_item`·`price_gbn=real_price`(전 BN 6샘플 일치) = **SizeMatrix2D 면적가**.
- **면적**: CUT_WDT/CUT_HGH 수치 직접 → 면적단가(2축 룩업·단일 면적함수 아님). 자유사이즈(USER/SIZE_0) + 규격프리셋 이중모드. MIN/MAX_CUT(현수막 0~5000·PET 0~1000). 작업 = 재단 + CUT_MRG(4mm).
- **소재**: `MTRL_CD` 4축 합성코드(TYPE+PTT+CLR+WGT)·**소재마다 별 자재행**(현수막/PET/블락아웃/매쉬/텐트천/부직포). 인쇄방식(수성C/라텍스L)도 MTRL_CD 분기.
- **후가공**: `pdt_pcs_info` 7그룹(재단필수/아일렛/각목/큐방/로프/봉제/고리) — 순수공정 vs `SUB_MTRL_YN=Y` 자재+공정 BUNDLE. 부자재 수량입력(로프 number_sel).
- **거치대 부속**: `CDL_DFT` SKU(X배너 8·롤업 RLU 600/850/1000) — 본체와 별개 완제·사이즈 캐스케이드.
- **수량**: 이중 수량축 ORD_CNT(디자인수=건수) × PRN_CNT(수량). 소량 이산(1~10).
- **소재→강제옵션**: PET→코팅필수(ESN_Y)·텐트천→포장필수(PKG_GB 단일강제).

### 6.2 와우프레스 실사·현수막 = 미관측 `[wow:probe]`
WowPress 라이브 `goods/poster`·`goods/list` 404(면적 상품 경로 미해소)·기존 캡처에 현수막/실사/배너 옵션 페이지 부재(명함·전단·책자·스티커·굿즈만). 면적 가격화 방식 **보강 불가**(정직 기록·아크릴 동일).

### 6.3 후니 `포스터사인` 가격표(면적 13 + 고정가 15) — 권위 `[huni:silsa]`
| 블록 | 내용 | 공식유형 | 후니 그릇 |
|------|------|---------|----------|
| 면적 13 | 포스터/실사 11소재 + 일반/메쉬 현수막 본체 면적단가 | **면적매트릭스형(TIER)** | `PRF_POSTER_<MAT>` 13 + 정본 comp 동형 공유(13→7 결합)·use_dims `[siz_width,siz_height,min_qty]` |
| (off-grid) | 자유사이즈 입력·증가단위 | (엔진 ceiling + nonspec) | `t_prd_products.nonspec_yn/width/height_min/max/incr` |
| 고정가 15 | 폼보드/포맥스/액자/족자/배너/시트커팅/미니 | **고정가형** | `PRF_POSTER_FIXED_*`·siz_cd 이산규격 + 거치대/우드행거 옵션 comp |
| 후가공 | 오시/미싱/귀돌이/가변/별색 | 후가공가산 | add-on comp Σ(`addtn_yn`·dim_vals.줄수/개수) |
| 수량 | 1장 면적가 × 수량 | (min_qty + t_dsc) | 수량구간 + 구간할인 별 단계 |

### 6.4 한 줄 결론
레드프린팅 실사·현수막 가격 골격(*[가로×세로] 면적매트릭스 × 소재(별 자재행) + Σ후가공 + 거치대 SKU × (건수×부수)·자유사이즈 면적가*)은 후니 `포스터사인` 가격표 + 라이브 TIER 엔진(`siz_width`/`siz_height` 구간·687셀)이 **동형·우월**하게 담는다. **면적=2축 구간매트릭스+엔진 ceiling**(면적함수 부결)·**자유사이즈=nonspec_incr+범위제한**·**소재=소재별 공식+동형 단가표 공유**(byte-identical만 결합)·**거치대=별개 고정가 부속**이 핵심 흡수 원칙(전부 기존 그릇·신규 축 0). ★후니 우월 2건: off-grid ceiling 엔진 내장·동형 단가표 공유(RedPrinting MTRL_CD별 중복 대비). ★돈-크리티컬: 본체 면적단가 수량관계(1장당×수량 vs 수량구간 총액)는 디지털 ×qty·아크릴 .02와 동일 클래스 — 엔진 계약 확정 선결.

---

## 7. 문구·제본물(다부품 합성형) 가격계산 모델 — 종단 보강

> 출처 `[red:book]` = `raw/widget_monitor/red_captures/v2_PRBKORD_capture.json`(트윈링 책자 컬러·`book2025_item`·INN_PAGE 2~130·표지/내지 WGT 분리·seneca[책등]·제본방향·PVC추가커버 실측) · `[red:TP]` = `_workspace/huni-rpmeta/categories/TP/reverse.md`(캘린더/북/티켓/떡메 23상품·INN_PAGE·이중수량) · `[wow:booklet]` = `raw/widget_monitor/wow_capture/fresh_booklet_capture.json`(`paperno3/4/5` 다단 용지·colorno+colorno_add 도수·박앞뒤·`jobqty0`/`jobcost0`) + `[wow:probe]` 라이브 GET `ProdNo=30004`(2026-06-20·페이지수=가격인자·무선/중철/스프링/윤전·표지vs내지 용지·박) · `[huni:book]` = 라이브 `t_prd_*` 실측(제본 comp 11종·`PRF_BIND_SUM`·`t_prd_product_sets` 28행·`t_prd_product_page_rules` 11행).

### 7.1 레드프린팅 제본물 = `book2025_price` 전용 다부품 엔진 `[red:book]`
- **가격엔진**: `item_gbn=book2025_item`·`price_gbn=book2025_price`(전용). 표지+내지+제본+페이지 합성.
- **부품 분리**: 한 책자 안에 표지자재(`MTRL_CD=RXART250` 아트지250·`COV_MIN_WGT=200`)와 내지(`INN_MAX_WGT=1000`)가 **분리 인코딩**(별 WGT 슬롯).
- **페이지 계층**: `MIN_INN_PAGE=2`·`MAX_INN_PAGE=130`·`STEP_INN_PAGE=1`(트윈링)·캘린더 2~200. 내지 단가 페이지수 비례.
- **제본방식**: 링제본·제본방향(`BIND_DIRECTION` 좌철/상철)·PVC추가커버 PCS 그룹.
- **책등(seneca)**: `seneca=0.64`·`max_seneca=1000` = 페이지수×내지두께 파생값(입력 아님).
- **수량**: 이중수량 ORD_CNT(디자인수=건수) × PRN_CNT(부수)·FIR_CNT 1·INC_CNT/STEP 10.

### 7.2 와우프레스 제본물 = `jobqty0`→`jobcost0` 작업량 2단 산정 `[wow:booklet·probe]`
- **가격엔진**: 서버 **작업량(`jobqty0`) → 작업비(`jobcost0`) 2단 API**. 페이지수·제본·용지를 작업량(연·도무송수)으로 환산 후 작업비 산정.
- **부품 분리**: `spdata_00_paperno3/4/5` **다단 용지 select**(표지 vs 내지 용지·`mdm/detail/Paper` API)·접이식 용지 뷰어.
- **도수**: `colorno`(본판 도수) + `colorno_add`(추가도수: 단면백색/은별색).
- **제본방식**: 무선책자·중철책자·스프링·윤전책자·특가 variant(1급 분기).
- **페이지수**: 명시 가격인자(작업량 환산)·후가공 박앞/뒤.

### 7.3 후니 제본물 그릇(세트+페이지+제본 comp) — 권위·**미배선** `[huni:book·dwire]`
| 블록 | 내용 | 그릇 | 상태 |
|------|------|------|------|
| 세트 구성(반제품) | 하드커버책자(PRD_000072) → 표지(073 전용지) + 면지(074화이트/075블랙/076그레이) | **`t_prd_product_sets`** 28행(sub_prd_qty·min/max_cnt·note) | ★라이브 실재(경쟁사 부품 분리 동형·우월) |
| 페이지 계층 | 트윈링 8~100·무선 24~300·하드커버 24~300·STEP2·떡메 3~3 | **`t_prd_product_page_rules`** 11행(page_min/max/incr) | ★라이브 실재(RedPrinting INN_PAGE 동형) |
| 제본방식 | 중철·무선·PUR·트윈링·싸바리·하드커버무선/트윈링·캘린더4 | **제본 comp 11종**(`COMP_BIND_*`·`.04 공정비`·`.01 단가형`·min_qty 수량구간) | ★라이브 실재 |
| 가격사슬 | 책자 = 제본비 단일항만 | `PRF_BIND_SUM` 공유공식(중철만 배선·broken 4/1) | ★**표지/내지/인쇄 comp 미배선**(D-WIRE·D-BIND-SCOPE 미결) |
| 떡메/노트/다이어리 | 떡메모지(097)·노트·만년다이어리 | `frm_cd=NULL` | ★가격사슬 전무(설계 대상) |

### 7.4 한 줄 결론
두 경쟁사 제본물 가격 골격(*표지비 + 내지비[페이지수 비례] + 제본비 + Σ후가공·부품 합성*)은 후니가 **세트 그릇(`t_prd_product_sets` 28행)·페이지 규칙(`t_prd_product_page_rules` 11행)·제본 comp 11종·합산형 공식**으로 **1:1 동형(부품 분리는 후니가 별 prd_cd로 우월)** 하게 담는다. RedPrinting=`book2025` 전용엔진(INN_PAGE·표지/내지 WGT·seneca)·WowPress=`jobqty→jobcost` 작업량 2단(paperno 다단). ★실질 흡수 = **그릇을 가격 합산 공식에 실제 배선**(후니 라이브는 "제본비 단일항"만·표지/내지/인쇄 comp 미배선·D-WIRE 결함)·**vessel-gap 아닌 data/배선-gap**. ★흡수 부결: WowPress 작업량 2단 엔진(후니 단일 evaluate_price + 앱계산/단가룩업 분리로 이미 표현·과분화). ★돈-크리티컬: 제본비 `COMP_BIND_*` prc_typ .01(min_qty 1/4/10 구간 = .02 합가형 성격 가능)이 "부수당×수량 vs 묶음 총액"인지 디지털·아크릴 종단과 동일 클래스로 엔진 계약 확정 선결. ★D-BIND-SCOPE(제본비 단일 vs 부품 합산) = 권위 가격표가 부품별 단가 주면 부품 합산이 정답(경쟁사 입증)·인간 결정.

---

## 8. 굿즈/파우치(완제 SKU·개당단가형) 가격계산 모델 — 종단 보강

> 상세 흡수 분석 = `absorption-candidates-goods-pouch.md`(C-GP1~C-GP9). 여기선 모델 골격만.
> 출처 `[red:GS]` = `_workspace/huni-rpmeta/categories/GS/reverse.md`(GS 136상품 대표 12 + 코스터 6소재군·`tmpl_price`/`vTmpl_price`/`tiered_price` 3엔진·`DIR_MTR`/`WRK_MTR` 본체=공정성 항목·variant 3채널·자재 usage 다중슬롯) · `[red:GSTGMIC]` = `raw/widget_monitor/red_captures/v2_GSTGMIC_capture.json`(유일 `tiered_price`·S6000/L7000·인쇄가 주체) · `[wow:goods]` = `_workspace/huni-dbmap/10_configurator/wowpress-option-model.md`(WowPress 326상품·`raw.prod_info` 7축·본체색=paperinfo·형상=sizeinfo) · `[huni:goods-map]` = `_workspace/huni-dbmap/10_configurator/huni-goods-option-mapping.md`(6축↔후니 매핑·오염 재분류·GAP) · `[huni:mat]` = `_workspace/huni-dbmap/32_axis-staged-load/04_live-remeasure-260616.md`(.09 파우치 74행 오염·본체 소재 컬럼 부재) · `[huni:live]` = 라이브 `t_*`(굿즈/파우치 30상품 `t_prd_product_price_formulas` 바인딩 0·아크릴키링 1건뿐).

### 8.1 레드프린팅 굿즈 = `tmpl_price`/`vTmpl_price`/`tiered_price` 3엔진 (완제 SKU 개당단가) `[red:GS]`
- **가격엔진 3종 공존**: `tmpl_price`(완제 SKU 개당단가·텀블러45000/장패드10000/마스크끈2800)·`vTmpl_price`(variant SKU)·`tiered_price`(수량구간 단가·자재단가 필드 동반·GSTGMIC S6000/L7000). 면적형(BN `real_price`)·부품합산형(책자 `book2025`)과 다른 **완제 SKU 패러다임**.
- **★본체 = PCS_INFO 첫 항목**(`DIR_MTR` 직접인쇄 / `WRK_MTR` 부자재작업)·소재/색/용량이 완제 SKU 라벨(`PCS_DTL_NME`)에 융합·이게 PRICE 주체. 즉 본체 굿즈를 **자재가 아니라 공정성 항목**으로 모델링(후니 본체 소재 컬럼 부재와 동형 결함).
- **variant 3채널**: ① DTL 코드(색/사이즈·GSTGMIC S/L 합일=칼틀·부자재·가격 동시) ② ATTB 파라미터(링색/귀돌이 반경) ③ CUT 사이즈 프리셋.
- **자재 usage 다중슬롯**: 한 굿즈에 본체+내지+링+스펀지 동시(GSNTSPR `MTRL_CD`+`INN_DFT`+`RIN_DFT`).
- **본체 조립/봉제**: `PDT_WRK`(평면→입체 파우치 봉제·GSPUFBC)·지퍼=`FLX_ZIP`(자재+공정 BUNDLE).
- **코스터 6소재 = 6 pdtCode**(소재가 본체정체·소재 선택=상품 선택·자재 관리축 정점).
- **인쇄/포장**: 대부분 PRT_DFT=0(개당 baked-in)·대형(장패드 5000)·포장 PAK_ETC/PAK_POL(개별포장 1000 유료).

### 8.2 와우프레스 굿즈 = `optioninfo` 7축 흡수 + 동적 견적 `[wow:goods]`
- **정적표 없음** — 옵션코드 묶음 → `/std/prod/jobcost` 동적 견적(비선형·합판효율).
- **본체 블랭크 = `paperinfo`(재질 합성행)** — "물리 블랭크(소재+색+질감)" 합성 SKU(40479 캔버스 색6·40072 NCR 색별·40185 유포지 코팅×포장 합성).
- **★본체색 = paperinfo(재질), 형상 = sizeinfo(규격 융합·원형32/하트57x51), 인쇄면/방향만 colorinfo(도수)** — 새 축 안 만들고 6 의미축 흡수.
- **구수/개수 = `awkjobinfo.namestep2`**(2단계 개수형·이상은 직렬화+화이트리스트)·**포장/각인 = `optioninfo`**(flat optlist).
- **제약 = 행 인라인 `req_*`/`rst_*`**·최종 게이트 = 가격조회 성공 여부.

### 8.3 후니 굿즈 그릇(자재+규격+공정+묶음+고정가형) — 권위·**가격사슬 전무** `[huni:live·goods-map·mat]`
| 블록 | 내용 | 그릇 | 상태 |
|------|------|------|------|
| 완제 개당단가 | 텀블러/머그/키링/파우치 완제품 | `frm_typ_cd` 고정가형(`.06 완제품비`·카라비너 동형) | ★**가격사슬 전무**(30상품 바인딩 0·아크릴키링 1건뿐) |
| 본체 소재 | 코스터/파우치 소재(규조토/코르크/레더/캔버스/린넨/메쉬) | `t_prd_product_materials`(`mat_cd`·`usage_cd`) | ★**본체 소재 컬럼 부재·소재가 상품명에만**(명확분 41 COMMIT·BLOCKED 다수) |
| 본체색 | 파우치 블랙/투명/멜란지 | 재질행 합성(MAT root+색별 자식) | ★**이미 정답 패턴**(split 금지·전파 대상) |
| 형상 | 말랑키링 원형/사각/꽃/별/하트 | `t_prd_product_sizes`(siz_nm 형상) | ★**비치수=GAP-SHAPE**(자재축 오염 정리 필요) |
| 구수/개수 | 키캡키링 1구~4구 | 개수형 공정 + 개수 N | ★**GAP-COUNT**(ref_param_json 미구현) |
| 포장/각인 | OPP포장·각인·N색팩 | bundle_qtys(N개팩) / GAP-OPT | ★**GAP-OPT**(OPT_REF_DIM에 포장 차원 부재) |

### 8.4 한 줄 결론
두 경쟁사 굿즈 가격 골격(*완제 SKU 개당단가[고정가형] + Σ유료옵션[인쇄/포장] + 조립공정 + 수량·본체 소재/색이 완제 SKU에 융합*)은 후니 4단 엔진[고정가형/합산형 + min_qty 구간]이 표현력상 담을 수 있다(RedPrinting 3엔진·WowPress 동적견적 동형). ★**그러나 후니 굿즈/파우치는 5종단 중 가장 미설계** — 가격사슬 전무(바인딩 0)·본체 소재 컬럼 부재·자재축 오염(.09 파우치 74행 색/형상/구수). RedPrinting=완제 SKU `tmpl_price` 개당단가(본체=`DIR_MTR` 공정성 항목·코스터 6소재 분리)·WowPress=`paperinfo` 재질 합성 + 동적견적. ★실질 흡수 = ① **완제 개당단가형 가격사슬 신규 설계** ② **본체 소재/색/형상/구수 자재 오염 정리**(vessel-gap 아닌 가격사슬 미설계 + 오염 정리 + 3 GAP 컬럼/코드행). ★입도(과분할 금지) = WowPress 직접 흡수(본체색=재질 합성·형상=규격 융합·잉크색/인쇄면만 도수). ★돈-크리티컬: 개당단가 = min_qty=1 × qty 정당(아크릴 면적단가=개당 동형)·묶음단가면 ÷min_qty(디지털 .02 교정 동형)·엔진 계약 확정 선결. ★흡수 부결: RedPrinting 3엔진 코드 분기(후니 `frm_typ_cd` + min_qty 데이터 분기로 이미 표현·과분화). **신규 가격축 0**(rpmeta GS distinct 부결·WowPress 6 의미축 흡수 규칙·5종단 누적 결론 정합).
