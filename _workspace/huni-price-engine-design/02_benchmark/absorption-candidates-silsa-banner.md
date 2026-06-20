# 후니 흡수 후보 — 실사·현수막 가격계산 (면적매트릭스형 종단)

> `hpe-benchmark-analyst` 산출 — 디지털인쇄(파일럿)·아크릴(면적매트릭스)에 이어 **면적매트릭스형 대표 실사출력·현수막/배너** 종단.
> **목적[HARD]**: 와우프레스·레드프린팅이 실사출력·현수막/배너의 가격을 *어떻게 계산하는가*(면적 가격화·소재·후가공·수량·자유사이즈/증가단위)를
> 역공학해 후니 면적매트릭스 설계에 흡수할 메커니즘을 추출. 가격차 합리성 판정(`dbm-competitor-benchmark`)이 아님.
> **흡수 vs 답습[HARD]**: 메커니즘·표현력만 흡수, naming/codes(`real_price`·`MTRL_CD`·`CDL_DFT`·`PKG_GB` 등) 후니 유입 금지,
> 권위 엑셀(상품마스터260610·가격표260527·`포스터사인` 시트) 덮어쓰기 금지. 후니가 이미 담으면 흡수 불요(overfit 경계).
> **아크릴 일관성**: `absorption-candidates-acrylic.md`(신규축 0건·두께=자재차원·면적=매트릭스ceiling) 참조해 면적매트릭스 단일 차원 모델로 통일.

## 출처 표기

- `[red:BN-reverse]` = `_workspace/huni-rpmeta/categories/BN/reverse.md`(2026-06-17 rpm 역공학 — 대표 7상품 BNBNFBL/BNPTPET/BNSTDFT/BNBNSOD/BNRLSLV/BNPTMAS/BNTNHVY · Vue3 BFF 풀캡처 + 레거시 jQuery SSR `<select>` 실측·read-only GET).
- `[red:BN-summary]` = `_workspace/huni-rpmeta/categories/BN/summary.md`(BN+GS 통합 15축·갭 PASS5/WEAK7/GAP3·distinct 축 판정).
- `[huni:silsa]` = `_workspace/huni-dbmap/33_silsa-price-quote/{poster-sign-component-redesign,silsa-quote-design,silsa-isomorph-merge-design}.md`(후니 `포스터사인` 가격표 260527 면적매트릭스 + 라이브 `t_prc_*`·pricing.py TIER 엔진 실측·권위).
- `[huni:engine]` = pricing.py `TIER_DIMS=("siz_width","siz_height","min_qty")`·`match_component`(라인 119/150-152)·`_tier_val`(라인 99-101) 코드 직접 확인 경유 `[huni:silsa]`.
- `[wow:probe]` = WowPress 라이브 읽기전용 조회(2026-06-20·`goods/poster`·`goods/list` 404 — 면적 상품 경로 미해소). 기존 캡처(`raw/widget_monitor/wow_capture/`)에 현수막/실사/배너 옵션 페이지 캡처 부재(명함·전단·책자·스티커·굿즈만).
- `unobserved` = 미관측(날조 금지).

---

## 0. 경쟁사 실사·현수막 면적 가격화 방식 — 한눈 요약

| 항목 | 레드프린팅(RedPrinting BN) | 와우프레스(WowPress) | 후니 `t_prc_*` 대응 |
|------|---------------------------|----------------------|---------------------|
| 가격엔진 | **`item_gbn=real_item`·`price_gbn=real_price`**(대형 실사/배너 전용·SizeMatrix2D 면적가) — 전 BN 6샘플 일치 `[red:BN-reverse §0]` | 미관측(현수막/실사 옵션 캡처 부재·라이브 경로 404) `[wow:probe]` | 면적매트릭스형 공식 `PRF_POSTER_*` 13 + 고정가 15 `[huni:silsa]` |
| 면적 가격화 | **[가로×세로] 면적매트릭스(SizeMatrix2D)** — CUT_WDT/CUT_HGH 수치 직접 → `real_price` 면적단가 `[red:BN-reverse §1]` | unobserved | **`siz_width`/`siz_height` '이하 상한' 구간 매트릭스**(pricing.py TIER 엔진·687 단가행) `[huni:engine]` |
| 자유사이즈 | **규격프리셋 + 사이즈직접입력(USER/SIZE_0)** 이중 모드 — MIN/MAX_CUT 범위(현수막 0~5000·PET 0~1000) · 작업=재단+CUT_MRG(4mm) `[red:BN-reverse §0·§1]` | unobserved | **`t_prd_products.nonspec_*`**(nonspec_yn·width/height min/max/**incr** 증가단위) + 엔진 TIER ceiling `[huni:silsa §2.4]` |
| 소재 | `MTRL_CD` 4축 합성코드(TYPE+PTT+CLR+WGT)·**소재마다 별 자재행**(현수막/PET/블락아웃/매쉬/텐트천/부직포) · 인쇄방식(수성C/라텍스L)도 MTRL_CD 분기 `[red:BN-reverse §1·8]` | unobserved | **소재별 별 공식 `PRF_POSTER_<MAT>` + 동형 단가표 공유**(byte-identical 13→7 comp 결합·소재≠가격축) `[huni:silsa isomorph]` |
| 후가공 | `pdt_pcs_info` 7그룹(재단/아일렛/각목/큐방/로프/봉제/고리) + 코팅(PET필수)·포장(텐트천필수) — 순수공정 vs `SUB_MTRL_YN=Y` 자재+공정 BUNDLE `[red:BN-reverse §1~7]` | unobserved | 후가공 add-on comp Σ(`addtn_yn=Y`·오시/미싱/귀돌이/가변/별색) + round-6 CPQ 제약 `[huni:silsa §4.2]` |
| 거치대 부속 | **`CDL_DFT` 거치대 SKU**(X배너 8종·롤업 RLU 600/850/1000) — 본체와 별개 완제 부속·사이즈와 캐스케이드 `[red:BN-reverse §3·5]` | unobserved | 고정가 comp(거치대/우드행거/우드봉/천정고리 옵션 comp·`PRF_POSTER_FIXED_*`) `[huni:silsa §4.2]` |
| 수량 | **이중 수량축**: ORD_CNT(디자인수=건수) × PRN_CNT(수량) — 면적가 × 수량 `[red:BN-reverse §1·8]` · 공정 종속 수량(로프 number_sel) `[red:BN-reverse §7]` | unobserved | `min_qty` 수량구간 + 별 t_dsc 구간할인. 디자인 건수=주문라인(가격축 아님) |
| 소재→강제옵션 | **소재특성→강제 공정**: PET→코팅필수(ESN_Y)·텐트천→포장필수(PKG_GB 단일강제) `[red:BN-reverse §2·7]` | unobserved | 미보유 → round-6 CPQ constraints(필수 동반) 흡수후보 C-SB5 |

**한 줄 결론**: 레드프린팅은 실사·현수막을 **`real_price` 전용 면적엔진(SizeMatrix2D)으로 분기**해 *[가로×세로] 면적단가 × (소재별 자재행) + Σ(후가공) + 거치대 SKU × 수량(건수×부수)*로 계산한다. 이 골격은 후니 `포스터사인` 가격표(260527)와 라이브 `t_prc_*` **TIER 엔진**(`siz_width`/`siz_height` 구간 매트릭스·687 단가행)이 이미 **동형·우월**하게 담는다 — 후니는 자유사이즈 off-grid를 **엔진 내장 ceiling**(다음 큰 구간)으로 처리하고, **소재는 별 가격축이 아니라 소재별 공식이 동형 단가표를 공유**(byte-identical 결합)한다. WowPress는 실사·현수막 옵션·가격 **미관측**(라이브 경로 404·기존 캡처 부재). RedPrinting(사용자 본인 설계·흡수 정당)이 단독 오라클. **신규 가격축/테이블 신설 = 0건**(아크릴과 일관).

---

## 1. 흡수 후보 요약 보드 (C-SB1~C-SB7)

| ID | 흡수 후보 | 출처 | 후니 그릇 | 사다리 | 우선순위 | overfit 위험 | 답습 리스크 |
|----|----------|------|----------|--------|---------|------------|------------|
| **C-SB1** | 면적 = [가로×세로] **2축 구간 매트릭스**(면적함수 아님·ceiling 엔진 내장) | 레드 SizeMatrix2D·후니 TIER 엔진 | `component_prices use_dims=[siz_width,siz_height]` + pricing.py TIER | 데이터(이미 존재) | **High** | **낮음(이미 동형·우월)** | 낮음 |
| **C-SB2** | 자유사이즈 입력 → nonspec 증가단위 스냅 → 구간 ceiling 룩업 | 레드 USER/SIZE_0·MIN/MAX_CUT·작업=재단+여백 | `t_prd_products.nonspec_yn/width_min/max/incr` + 엔진 ceiling | 차원(이미 존재) | **High** | 낮음(메모리 정합) | 낮음 |
| **C-SB3** | 소재 = 별 가격축 아님·**소재별 공식이 동형 단가표 공유**(byte-identical 결합) | 레드 MTRL_CD별 자재행·후니 13→7 동형결합 | `PRF_POSTER_<MAT>` 별 공식 + 정본 comp 공유 | 코드행/배선(이미 존재) | **High** | 중(소재를 mat_cd 차원으로 오모델 경계) | 낮음 |
| **C-SB4** | 거치대/우드행거 = **별개 완제 부속 SKU**(본체 면적가와 분리·고정가) | 레드 `CDL_DFT`(X배너8·롤업RLU3) | 고정가 comp(`.06 완제품비`·옵션 comp) + round-6 CPQ | 코드행/제약 | **Medium** | 중(거치대를 면적 차원으로 오모델 경계) | 낮음 |
| **C-SB5** | 소재→강제 후가공/포장 제약(PET→코팅필수·텐트천→포장필수) | 레드 ESN_YN=Y·PKG_GB 단일강제 | round-6 CPQ constraints(JSONLogic 필수동반) | JSONLogic 제약행 | **Medium** | 낮음(제약 패턴) | 낮음 |
| **C-SB6** | 인쇄방식(수성/라텍스)·통풍소재(매쉬) = **자재행 분기**(소재×인쇄방식 합성) | 레드 PXBOPXXX vs PXBOPTEX·TFC/TFL | `mat_cd` 분기 or 별 `PRF_POSTER_<MAT>` 공식 | 코드행(이미 존재) | Low | 중(자재 그룹핑 슬롯 신설 경계) | 중(naming 가드) |
| **C-SB7** | 부자재 수량입력(로프 N개·아일렛 N개) = **공정 종속 수량 슬롯** | 레드 `QTY_INPUT_YN=Y`·number_sel_ROP_DFT | 후가공 comp + dim_vals.개수(앱 계산·룩업) | 차원/제약 | Low | 낮음(개당×수량 가드와 동일 클래스) | 낮음 |

**신규 테이블(vessel) 신설 = 0건.** 전부 기존 후니 그릇(TIER 면적매트릭스 comp·`siz_width`/`siz_height` 구간·`nonspec_*` 증가단위·소재별 공식 + 동형 결합·고정가 comp·round-6 CPQ 제약/옵션)으로 닫힌다. rpmeta BN 판정(`[red:BN-summary]`: #11 가격기여역할 SizeMatrix2D·#8 부속물·#13 사이즈 nonspec — 전부 기존축 facet·distinct 새 가격축 부결)과 정합.

---

## C-SB1. 면적 = [가로×세로] 2축 구간 매트릭스 ★ (우선순위 High·흡수 강·이미 동형·후니 우월)

### 흡수 메커니즘
레드프린팅 BN은 전 6샘플 공통으로 `item_gbn=real_item`·`price_gbn=real_price` = **SizeMatrix2D 면적 가격모델** `[red:BN-reverse §0]`. 사이즈는 CUT_WDT/CUT_HGH 수치를 그대로 `real_price` 엔진에 전달 → 면적단가로 계산(off-grid 자유사이즈도 산정). 즉 **2축(가로·세로) 면적 룩업**이지 단일 면적(㎡) 함수가 아니다.

### 후니 매핑 (이미 동형·우월 — 코드 입증)
후니 `포스터사인` 가격표는 면적을 **[가로×세로] 매트릭스**(투명/소재별 13블록·687셀)로 둔다 `[huni:silsa]`. 후니 엔진 `[huni:engine]`이 이를 정확·완전 표현:
- `TIER_DIMS=("siz_width","siz_height","min_qty")` + `TIER_UPPER=("siz_width","siz_height")` = **가로·세로 각 축 독립 '이하 상한' 구간**.
- `match_component`(라인 150-152): `eligible=[t for t in tiers if t>=cmp_val]; selected=min(eligible)` = **주문 가로 ≤ 임계 중 최소 = 값 담는 가장 작은 구간**(2축 동시 = 면적매트릭스).
- **off-grid = 다음 큰 구간 자동(ceiling 엔진 내장)** — RedPrinting/위젯이 별도 런타임 ceiling 해야 하는 것을 후니는 DB 차원으로 흡수.

### 사다리 판정 (search-before-mint)
**신규 축/테이블 불요·후니가 오히려 우월.** ★**면적함수(㎠/㎡당 단가) 신설은 부결(overfit)** — 후니 권위 가격표가 이산 구간 매트릭스이지 연속 함수가 아니다(메모리 `dbmap-price-formula-types-authority`: 면적함수 추천은 오판·실제=매트릭스+ceiling). 흡수 = "면적은 2축 구간 매트릭스 + ceiling"을 **설계 원칙으로 못박는 것**(아크릴 C-A2와 동일 결론·면적매트릭스 단일 차원 모델로 실사·현수막·아크릴 통일).

### trade-off
- 장점: 권위 단가(이산 셀) 보존 + 자유사이즈 UX(C-SB2와 결합) + off-grid 엔진 내장(위젯 단순). RedPrinting SizeMatrix2D와 표현력 동등·후니가 ceiling 우월.
- 단점: 단가행 백필(687셀 siz_width/siz_height 임계)·최대 구간 NULL(∞) vs 명시값(초과 거부) 정책 컨펌(`[huni:silsa Q-PR-1]`).

### naming 유입 가드 [HARD]
RedPrinting `real_price`·`SizeMatrix2D`·`CUT_WDT/CUT_HGH` 토큰 후니 유입 금지. 후니 `siz_width`/`siz_height` 구간 + TIER 엔진으로 번역.

---

## C-SB2. 자유사이즈 → nonspec 증가단위 스냅 → 구간 ceiling ★ (우선순위 High·흡수 강·대형 자유사이즈 핵심)

### 흡수 메커니즘 (대형 자유사이즈 처리)
레드프린팅 BN은 **규격프리셋 + 사이즈직접입력(USER/SIZE_0) 이중 모드** `[red:BN-reverse §0·1]`:
- 현수막 base_info: `MIN_CUT=0 MAX_CUT_WDT=5000 MAX_CUT_HGH=5000 CUT_MRG=4mm`(대형 m 단위·최대 5m).
- PET배너: `MAX_CUT 1000`(소형). 매쉬: 1000. X배너: 거치형 세로>가로 프리셋.
- **작업사이즈 = 재단사이즈 + CUT_MRG(4mm) 자동** — 여백 가산이 엔진 내장.
- 직접입력 시 USER 수치 직접전달(프리셋 룩업 불가·면적가 직접 산정).

### 후니 매핑 (nonspec 증가단위 + 엔진 ceiling)
후니는 **두 그릇이 정확히 이를 흡수** `[huni:silsa §2.4]`:
- **입력 검증/스냅** = `t_prd_products.nonspec_*`(nonspec_yn·width_min/max·height_min/max·**incr 증가단위**). 비규격 가로/세로 입력 시 증가단위로 스냅·MIN/MAX 범위 제한 — RedPrinting MIN/MAX_CUT·증가단위와 동형.
- **가격 룩업** = 엔진 TIER '이하 상한'(다음 큰 구간 ceiling). off-grid 사이즈는 nonspec_incr로 입력 정규화 → siz_width/siz_height 구간 매칭.
- **여백(작업=재단+4mm)** = 후니 `t_siz_sizes` work/cut 양방향(work_width/height·cut_width/height) — 여백을 사이즈 정의에 baked.

### 사다리 판정 (search-before-mint)
**신규 불요.** `nonspec_*` 컬럼 + work/cut 사이즈 + 엔진 TIER가 이미 자유사이즈·증가단위·여백을 담는다. 흡수 = **"자유사이즈 입력 → nonspec_incr 스냅 → 구간 ceiling 룩업" 계약을 designer가 명시**(입력은 연속·가격은 격자 ceiling). 대형(현수막 5m)에서 격자 셀을 무한 채울 필요 없음 — **셀은 가격표 명시 구간만, off-grid는 ceiling**(데이터 효율).

### trade-off
- 장점: 대형 자유사이즈를 무한 셀 없이 처리(권위 구간 + ceiling). 증가단위로 입력 제어(비규격 난수 방지). RedPrinting MIN/MAX·CUT_MRG 동형.
- 단점: 최대 구간 초과(5m 초과) 정책 = `ERR_ABOVE_MAX` vs nonspec_max 제한 명시 필요(`[huni:silsa Q-PR-1]`). 증가단위(incr) 값을 상품마다 설정(가격표/실무진 권위).

### naming 유입 가드 [HARD]
`USER`/`SIZE_0`/`MIN/MAX_CUT_WDT/HGH`/`CUT_MRG` 후니 유입 금지. 후니 `nonspec_yn`/`width_min`/`incr`/work·cut으로 번역.

---

## C-SB3. 소재 = 별 가격축 아님 · 소재별 공식이 동형 단가표 공유 ★ (우선순위 High·흡수 강·후니 우월)

### 흡수 메커니즘
레드프린팅 BN은 소재를 **`MTRL_CD` 4축 합성코드(TYPE+PTT+CLR+WGT)·소재마다 별 자재행**으로 둔다 `[red:BN-reverse §1·8]`: 현수막(PXBFCXXX)·PET(PXPETXXX)·블락아웃(PXBOPXXX/PXBOPTEX)·매쉬(PXMASXXX)·텐트천(PXTFCXXX/PXTFLXXX)·부직포어깨띠(PXVGP001). 각 소재가 면적단가 분기키(MTRL_CD → `real_price`).

### 후니 매핑 (★후니가 더 정합적 — 동형 단가표 공유)
후니 라이브가 **결정적으로 우월한 발상** `[huni:silsa isomorph]`:
- 소재별 별 공식(`PRF_POSTER_CANVAS`·`PRF_POSTER_LEATHER_AP`·`PRF_POSTER_MESH`·`PRF_POSTER_TYVEK`·`PRF_POSTER_ARTPRINT`·…) 13 + 상품 1:1 바인딩.
- ★**소재 단가가 byte-identical이면 동형 결합**: 13 면적 comp 중 그룹A(캔버스/레더아트/메쉬/타이벡 = 600×1800 **37,800** 동일)·그룹B(방수PVC/아트패브릭/아트프린트/방수PET = **21,600** 동일)이 전컬럼 md5 일치 → **13→7 comp**(정본 comp 단가표 공유·레거시 use_yn=N·단가행 보존·DELETE 0·UPDATE 19행). 단독 5(아트지/메쉬배너/투명점착PVC/린넨/일반배너)는 단가 상이라 결합 금지.
- ★**[HARD 교훈] 동형=byte-identical만**(행수 같아도 단가 다르면 금지 — LINEN 32,400·ADH_CLEAR 59,400은 52행이나 그룹과 단가 상이 → 결합 금지 정당).

### 사다리 판정·overfit 경계
**기존 `frm_cd` 코드행 + 배선으로 닫힘(신규 테이블 0).** ★**중요 흡수 원칙: 소재는 별 가격 차원(`mat_cd` 면적단가 분기)으로 둘 수도, 소재별 공식으로 둘 수도 있으나, 후니 권위는 소재별 공식 + 동형 단가표 공유**(가독성·관리성·가격 정합). RedPrinting MTRL_CD 면적단가 분기를 후니에 그대로 답습(소재를 면적 comp의 mat_cd 차원으로) 하면 동형 결합·소재별 공식의 가독성 이점을 잃는다. 흡수 = **"소재는 면적단가 분기키이되, 동값 소재는 정본 comp 공유"**(아크릴 두께=mat_cd 차원 C-A1과 다른 패턴 — 아크릴 두께는 1소재 내 차원, 실사 소재는 별 상품/공식).

### trade-off
- 장점: 소재별 공식 가독성 + 동형 단가표 공유(중복 제거·중복 단가 오류 방지). RedPrinting 소재별 자재행보다 후니가 관리 우월.
- 단점: 동형 판정에 byte-identical 전컬럼 md5 필수(행수·외형 동일에 속지 말 것). 소재명 한글 표기 권위(가격표/상품마스터 원본 표기명·naming 권위순서) 대조 필요(`[huni:silsa Q-IM1]`).

### naming 유입 가드 [HARD]
`MTRL_CD`/`PTT_CD`(BFC/PET/BOP/MAS/TFC) 후니 유입 금지. 후니 소재명(가격표 권위·한글)으로 번역. naming 권위순서(후니 레거시 최우선) 준수.

---

## C-SB4. 거치대/우드행거 = 별개 완제 부속 SKU (우선순위 Medium·흡수 중·면적 분리)

### 흡수 메커니즘
레드프린팅 X배너·롤업배너는 **`CDL_DFT` 거치대를 본체(인쇄물)와 별개 완제 부속 SKU**로 둔다 `[red:BN-reverse §3·5]`:
- X배너: 실내(뉴포인트/L/W/NP거치대) + 실외(에코배너 단/양면·복플러스·K배너) 8종.
- 롤업: RLU01/02/03(600/850/1000) — **거치대 폭이 size 프리셋과 1:1 캐스케이드**(롤업600↔거치대600).
- 거치대 = 본체 면적가와 별개 단가(완제 부속물·면적 아님).

### 후니 매핑
후니 `포스터사인` 고정가 15(폼보드/액자/족자/배너/시트커팅/미니류)가 **거치대/우드행거/우드봉/천정고리 옵션 comp**를 담는다 `[huni:silsa §4.2]`. 후니 메커니즘:
- **가격** = 고정가 comp(`.06 완제품비`·`use_dims=[opt_cd]` 단가행) — 면적 아님·부속별 통가격.
- **선택/생산BOM** = round-6 CPQ option(거치대 종류 택1) + 본체와 합산(`addtn_yn`).
- **사이즈 캐스케이드** = 롤업 폭↔거치대 폭 1:1은 round-6 CPQ constraints(사이즈→부속 매칭).

### 사다리 판정·overfit 경계
**기존 고정가 comp + round-6 CPQ로 닫힘.** ★중요: **거치대를 면적 차원(siz_width/height)으로 오모델 금지** — 거치대는 부속 SKU 고정가(아크릴 카라비너 C-A6·형상 고정가와 동류). 본체 면적가 + 거치대 고정가 **합산**(아크릴 P-4a 본체+부착물 동형). 별 SKU 테이블 신설은 부결(고정가 comp + CPQ option으로 표현).

### trade-off
- 장점: 본체 면적가와 거치대 고정가를 정확히 분리(면적 오모델 회피)·거치대↔사이즈 캐스케이드 제약.
- 단점: 거치대 종류 enumeration(X배너 8·롤업 3). 거치대 폭↔사이즈 매칭 제약 데이터화.

### naming 유입 가드 [HARD]
`CDL_DFT`/RLU/PTIDF/PT001~005 후니 유입 금지. 후니 `opt_cd`/`comp_cd`로 번역.

---

## C-SB5. 소재→강제 후가공/포장 제약 (우선순위 Medium·흡수 중·가격정합 가드)

### 흡수 메커니즘
레드프린팅 BN은 **소재특성이 후가공/포장을 강제** `[red:BN-reverse §2·7]`:
- **PET배너**: `COT_DFT 코팅` ESN_YN=**Y 필수**(PET 소재 특유·무광/유광 택1 강제).
- **텐트천 두꺼운 현수막**: `PKG_GB = PKG_RUP "말아서 포장 필수"` — **선택 아닌 고정 단일강제**(두꺼운 소재 → 말아서 포장).
- 자재→후가공 disable(`pdt_disable_pcs_info`)의 역방향(자재→공정 **강제**).

### 후니 매핑
후니 가격엔진엔 "이 소재는 이 후가공/포장 필수" 강제 제약이 없다 → round-6 CPQ constraints(JSONLogic 필수동반):
`{"if":[{"==":[{"var":"mat_cd"},"<PET>"]}, {"in":[{"var":"coat"},["<무광코팅>","<유광코팅>"]]}]}` / `{"if":[{"==":[{"var":"mat_cd"},"<텐트천>"]}, {"==":[{"var":"pkg"},"<말아서포장>"]}]}`.

### 사다리 판정 (search-before-mint)
round-6 CPQ constraints 제약행으로 무손실(아크릴 C-A5 소재→후가공 disable·디지털 C-4와 동일 그릇). **data-gap이지 vessel-gap 아님**. ESN_YN(필수 동반)은 접지→오시 필수(set P-3)와 같은 캐스케이드 패턴.

### trade-off
- 장점: 소재별 필수 공정/포장이 견적에 자동 가산(누락 방지)·잘못된 조합 차단 → 가격 정합. PET 코팅·텐트천 포장 비용 누락 회피(돈-크리티컬).
- 단점: 소재×강제옵션 규칙 데이터화. 권위 엑셀(상품마스터 후가공 컬럼)에 명시돼 있으면 그게 정답(경쟁사=보강).

### naming 유입 가드 [HARD]
`ESN_YN`/`PKG_GB`/`PKG_RUP`/`COT_DFT` 후니 유입 금지. 후니 `proc_cd`/CPQ constraint로 번역.

---

## C-SB6. 인쇄방식·통풍소재 = 자재행 분기 (우선순위 Low·흡수 약·자재 그룹핑 슬롯 경계)

### 흡수 메커니즘
레드프린팅은 **동일 소재를 인쇄방식별로 별 MTRL_CD** `[red:BN-reverse §5·7]`: 블락아웃PET 수성용(PXBOPXXX) vs 라텍스용(PXBOPTEX)·텐트천 수성(PXTFCXXX) vs 라텍스(PXTFLXXX). 또 매쉬(통풍)·부직포(어깨띠)는 소재 정체가 자재축으로 분리. 즉 **소재 = 소재정체(PTT) × 인쇄방식(수성C/라텍스L) 합성**.

### 후니 매핑·overfit 경계
후니는 두 경로 가능:
- (a) **인쇄방식별 별 `mat_cd`**(블락아웃-수성·블락아웃-라텍스 별 자재행) — 단가가 다르면.
- (b) **인쇄방식 = 별 `PRF_POSTER_<MAT>` 공식**(C-SB3 소재별 공식·동형이면 결합).

★**자재 그룹핑 슬롯(RedPrinting `GRP_OPTION_CD` 류) 신설은 부결(overfit)** — 인쇄방식은 새 가격축이 아니라 **자재행 분기/소재별 공식**(rpmeta·dbmap `print-method-not-absolute-axis`: 인쇄방식≠절대축·생산레시피 #12 토큰). 후니는 자재 enum(별 mat_cd) 또는 소재별 공식으로 표현·새 그릇 불요.

### trade-off
- 장점: 인쇄방식별 단가 차이를 자재행/공식으로 일관 인코딩(C-SB3 정합). 동값이면 동형 결합(중복 제거).
- 단점: 자재행/공식 증가(소재×인쇄방식). 단, 통풍(매쉬)은 면적가 자체가 달라 단독 comp(`COMP_POSTER_BANNER_MESH` 단독·결합 금지).

### naming 유입 가드 [HARD]
`PXBOPXXX`/`PXBOPTEX`/`TFC`/`TFL`/`GRP_OPTION_CD` 후니 유입 금지. 후니 `mat_cd`/`frm_cd`로 번역.

---

## C-SB7. 부자재 수량입력 = 공정 종속 수량 슬롯 (우선순위 Low·흡수 약·개당×수량 가드)

### 흡수 메커니즘
레드프린팅 텐트천 현수막은 **후가공(로프)이 자체 수량입력 select**를 갖는다 `[red:BN-reverse §7]`: `number_sel_ROP_DFT`(USER 직접입력·1~10) = `QTY_INPUT_YN=Y`의 SSR 구현. 아일렛/각목/큐방/로프 등 `SUB_MTRL_YN=Y` 부자재는 수량 종속(고리 N개 = N×단가). 공정 + 수량 결합.

### 후니 매핑
후니 후가공 comp + dim_vals.개수(개수 차원·앱 계산·DB 룩업). 부자재 수량은 **dim_vals.개수**(오시 줄수·가변 개수와 동형·메모리 `compute-in-app-db-stores-lookup`). 가격 = 부자재 단가 × 개수(엔진 dim_vals 매칭).

### 사다리 판정 (search-before-mint)
**신규 불요.** 후가공 comp + dim_vals.개수 기존 그릇(silsa 오시/가변 통합 comp와 동형). ★**개당 1회 가산 vs ×개수 정합 가드**(디지털 ×qty 과청구·아크릴 후가공 prc_typ와 동일 클래스 위험) — 부자재가 수량 종속(QTY_INPUT_YN=Y)이면 ×개수, 1회면 고정가산. 엔진 계약으로 확정(추측 적재 금지).

### trade-off
- 장점: 부자재 N개 가산을 정확히 표현(로프 3개 = 3×단가)·개수 입력 UX.
- 단점: 개당×개수 정합을 엔진 prc_typ로 확정 필수(과청구 위험 클래스).

### naming 유입 가드 [HARD]
`QTY_INPUT_YN`/`number_sel_ROP_DFT`/`SUB_MTRL_YN` 후니 유입 금지. 후니 dim_vals/comp로 번역.

---

## 2. 대형 자유사이즈·증가단위 처리 시사점 (핵심 종단)

> 실사·현수막의 가장 변별적 특성 = **대형(m 단위)·자유사이즈**. 아크릴(소형 키링 20~90mm)·디지털(규격 명함)과 대조.

| 관점 | 레드프린팅 BN | 후니 그릇 | 시사점 |
|------|--------------|----------|--------|
| 자유사이즈 입력 | USER/SIZE_0 직접입력 + 규격프리셋(이중모드) | nonspec_yn + siz_cd 프리셋(이중) | **흡수 불요(동형)** — 입력은 자유·가격은 격자 |
| 범위 제한 | MIN/MAX_CUT(현수막 0~5000·PET 0~1000) | nonspec_width_min/max·height_min/max | **흡수 불요(동형)** — 상품별 MIN/MAX |
| 증가단위 | (관측 SSR엔 미노출·FIR/INC/INC_STEP 슬롯 존재) | **nonspec_incr**(증가단위) | 후니가 명시 보유 — RedPrinting INC_STEP과 동형(흡수 불요) |
| 여백(작업≠재단) | 작업 = 재단 + CUT_MRG(4mm) 자동 | work_width/height vs cut_width/height | **흡수 불요(동형)** — 여백 사이즈에 baked |
| off-grid 가격 | `real_price` 면적 직접 산정(연속) | **엔진 TIER ceiling**(다음 큰 구간) | ★**후니 우월** — 무한 셀 불요·격자 + ceiling |
| 대형 셀 밀도 | (서버 면적 함수 추정) | 가격표 명시 구간만(W 18·H 7 distinct·687셀) | **데이터 효율** — 5m까지 무한 셀 없이 ceiling |

### 핵심 시사점
1. **대형 자유사이즈는 "연속 입력 + 이산 격자 가격 + ceiling"으로 닫힌다** — 면적 함수(㎡당 단가) 신설 부결(C-SB1). 후니 TIER 엔진이 RedPrinting 연속 면적가보다 **권위 단가 보존 + ceiling 우월**.
2. **증가단위(nonspec_incr)는 후니가 이미 명시 보유** — RedPrinting INC_STEP/FIR_CNT/INC_CNT 슬롯과 동형. 비규격 입력 난수 방지(예: 1mm 단위가 아니라 10mm 단위 스냅).
3. **여백(작업=재단+4mm)은 사이즈 정의(work/cut)에 흡수** — 별 가산축 불요. RedPrinting CUT_MRG 동형.
4. **셀 밀도 = 가격표 명시 구간만**(W 18 × H 7 distinct로 13블록 687셀) — 5m까지 무한 셀 채울 필요 없음. off-grid ceiling이 격자 사이를 메운다(데이터 효율·메모리 정합).

---

## 3. 수량 처리 대조 (디지털 ×qty 과청구 맥락)

> 디지털 파일럿에서 `prc_typ .01`(단가형) × 수량이 인쇄비 과청구 결함(메모리 `dbmap-round21-cycle1-note-load`). 아크릴은 본체 .02(합가형) 정합 미확정(돈-크리티컬). 실사/현수막은?

| 관점 | 레드프린팅 BN | 후니 실사/현수막 가격표 | 시사점 |
|------|--------------|----------------------|--------|
| 본체 수량 | 면적가 × PRN_CNT(수량) — 1장 단위 면적가 × 부수 `[red:BN-reverse §1·8]` | 본체 면적매트릭스 comp(use_dims `[siz_width,siz_height,min_qty]`) | 실사/현수막은 **1장 면적가 × 수량 누적**(아크릴 개당·디지털 묶음과 다름) |
| ★본체 comp prc_typ | unobserved(서버 `real_price`) | 면적 comp use_dims에 `min_qty` 포함(수량구간) `[huni:silsa §2.1]` | ★**면적단가가 "1장당(×수량)"인지 "수량구간 총액"인지 엔진 계약 확정 필요**(디지털/아크릴과 동일 클래스 돈-크리티컬) |
| 이중수량 | **ORD_CNT(디자인수=건수) × PRN_CNT(수량)** 명시 분리 `[red:BN-reverse §0·1·8]` | 가격축 아님(주문라인) | 디자인 건수를 가격 차원에 baked 금지(디지털 C-5·아크릴 동일 가드) |
| 후가공 가산 | 부자재 QTY_INPUT_YN(로프 N개) `[red:BN-reverse §7]` | 후가공 add-on comp(오시/미싱/귀돌이/가변) | 후가공이 **개당 1회**인지 ×수량인지 명시(C-SB7·디지털 결함 클래스) |
| 수량 곡선 | number1_sel(1~10)·number4_sel(N배) | min_qty 수량구간 + t_dsc 구간할인 | 현수막은 **소량 이산**(1~10)·디지털 대량 연속과 대조 — 곡선 파라미터 불요 |

### 핵심 수량 시사점
1. **실사/현수막 본체 = 1장 면적가 × 수량 누적** — 아크릴(개당가)·디지털(묶음총액)과 또 다른 수량처리. ★면적 comp의 `min_qty`(수량구간)와 면적단가의 곱셈 관계(1장당×수량 vs 수량구간 총액)를 **엔진 evaluate_price 계약으로 확정**(추측 적재 금지·디지털 ×qty 3배 과청구·아크릴 .02 미확정과 동일 돈-크리티컬 클래스).
2. **이중수량(디자인 건수 × 수량)은 RedPrinting이 명시 분리** — ORD_CNT(건수)는 주문라인 멀티플라이어·가격축 아님(BN/디지털/아크릴 전부 동일 가드).
3. **후가공·부자재 수량 종속**(로프 N개·아일렛 N개)은 dim_vals.개수 ×개수(C-SB7) — 개당 1회 vs ×개수 정합을 엔진 prc_typ로 확정.
4. **수량 곡선 = 소량 이산(1~10) + 구간할인** — 현수막은 대량 볼륨디스카운트 곡선 불요(디지털과 대조)·t_dsc 구간할인이 별 단계.

---

## 4. 흡수 종합 판정

1. **실사·현수막 가격계산 골격(면적 2축 매트릭스 + 자유사이즈 ceiling + 소재별 공식 + 후가공 합산 + 거치대 고정가 + 1장면적가×수량)은 후니 `포스터사인` 가격표(260527)와 라이브 `t_prc_*` TIER 엔진이 이미 동형·우월하게 담는다** → 핵심 흡수 불요(C-SB1·C-SB2·C-SB3 = 이미 동형·후니 우월·설계 원칙 못박기).
2. **실질 흡수 = 제약 레이어 1건(C-SB5 소재→강제 후가공/포장) + 거치대 부속 SKU(C-SB4)** — 둘 다 기존 그릇(round-6 CPQ constraints·고정가 comp)으로 닫히며 가격 정합 가드.
3. **약한 보강 2건(C-SB6 인쇄방식 자재분기·C-SB7 부자재 수량)** — mat_cd/공식/dim_vals로 닫힘·자재 그룹핑 슬롯 신설은 **overfit 부결**.
4. **신규 가격축/테이블 신설 = 0건** — rpmeta BN "#11 SizeMatrix2D·#8 부속물·#13 사이즈 nonspec 전부 기존축 facet·distinct 새 가격축 부결"(`[red:BN-summary]`)·아크릴 "신규 0"과 정합(search-before-mint 통과).
5. **WowPress 실사·현수막 = 미관측**(라이브 경로 404·기존 캡처 부재·옵션/가격 보강 불가). RedPrinting BN(사용자 본인 설계·흡수 정당·Vue3 BFF + 레거시 SSR 이중 실측)이 단독 오라클·정직 기록.
6. **모든 흡수는 권위 엑셀이 최종** — 경쟁사가 `포스터사인` 가격표(면적매트릭스 13 + 고정가 15)와 충돌하면 가격표가 이긴다.
7. **★후니 우월 2건**: ① off-grid ceiling 엔진 내장(RedPrinting 연속 면적가 + 별도 ceiling 대비) ② 소재별 공식 + 동형 단가표 공유(byte-identical 결합·RedPrinting MTRL_CD별 자재행 중복 대비). 흡수가 아니라 후니가 가르치는 패턴.

### designer로 넘기는 핵심 입력
- **면적 = `siz_width`/`siz_height` 2축 구간 매트릭스 + 엔진 ceiling**(면적함수 부결·C-SB1)·**자유사이즈 = nonspec_incr 스냅 + 범위제한**(대형 5m·C-SB2).
- **소재 = 소재별 `PRF_POSTER_<MAT>` 공식 + 동형 단가표 공유**(byte-identical만 결합·소재를 면적 mat_cd 차원으로 답습 금지·C-SB3).
- **거치대/우드행거 = 별개 고정가 부속 comp**(면적 차원 오모델 금지·합산·C-SB4)·**소재→강제 후가공/포장 = round-6 CPQ constraints**(C-SB5).
- **★돈-크리티컬**: 실사/현수막 본체 면적단가의 **수량 관계**(1장당×수량 vs 수량구간 총액)를 엔진 evaluate_price 계약으로 확정 — 디지털 ×qty 과청구·아크릴 .02 미확정과 동일 클래스(추측 적재 금지).
- **이중수량(디자인 건수)은 주문라인·가격축 아님**·후가공/부자재 수량 종속(dim_vals.개수)은 개당 1회 vs ×개수 엔진 계약 명시.
