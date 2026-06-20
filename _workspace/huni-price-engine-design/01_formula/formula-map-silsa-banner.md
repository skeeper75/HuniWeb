# formula-map-silsa-banner.md — 실사·현수막 가격공식 3층 지도 (면적매트릭스형 동형 종단)

> **기준점 지도 (생성 입력).** "후니가 실사·현수막 가격을 어떻게 계산하려는가"의 상품→가격구성요소→계산방식 3층 지도.
> 설계가(designer)·검증가(validator)가 이것을 자(尺)로 쓴다. **아크릴 파일럿(formula-map-acrylic·engine-design-acrylic·gate-verdict-acrylic)의 면적매트릭스 동형 기준선을 자로 삼아 동형/비동형을 명확 구분.**
> 권위 순서[HARD]: ① 상품마스터(260610) 실사·현수막 시트 + 계산공식집초안 > ② 인쇄상품 가격표(260527) **포스터사인 [가로×세로] 면적매트릭스(=실사 가격 권위·[[dbmap-silsa-price-via-poster-sign]]·실사 inline price 아님)** > ③ 라이브 t_prc_*(현 상태 기준선) > ④ 역공학(rpmeta 배너·widget_monitor 후보).
> 산출자: hpe-formula-cartographer · 라이브 실측 2026-06-20 읽기전용 SELECT · 추정 0(실측·명시값) · 단가값=가격표 verbatim.

---

## 0. 권위 원천 요약

| 원천 | 위치 | 역할 |
|------|------|------|
| **계산공식집초안 시트** | `06_extract/calc-formula-draft-l1.csv` 행100·101·103 | **★공식 유형 정의 절대 권위** — 행100 `[면적매트릭스형: 실사,현수막]`(★실사+현수막=아크릴과 **같은 면적매트릭스 클래스**·행106 아크릴과 병렬)·행101 `판매가 = [세로mm행][가로mm열]`(포스터/사인)·행103 `[고정가형: 폼보드,포맥스,프레임리스액자,레더아트액자,캔버스행잉포스터,린넨우드봉족자,족자포스터,PET배너,메쉬배너,시트커팅,아크릴스티커,미니스탠딩보드,미니배너]` |
| 인쇄상품 가격표(260527) 포스터사인 시트 | `06_extract/price-poster-sign-l1.csv`(1223행) | **[가로×세로] 면적 매트릭스 verbatim**(B07 린넨 등 블록별)·면적매트릭스 13소재 + 고정가 15 |
| 상품마스터 실사 시트 | `24_master-extract-260610/silsa-l1.csv`(118행)·`silsa-l1-meta.csv` | 상품별 요소(구분/소재/사이즈/후가공/추가옵션) + 완제품·반제품 구분 |
| 라이브 t_prc_* | Railway DB (2026-06-20 실측·읽기전용) | **PRF_POSTER_* 28공식·면적 본체 comp(use_dims=[siz_width,siz_height])·동형결합 COMMIT됨·바인딩 28상품 전건 실재** |
| dbmap 선행 설계(권위 정합) | `huni-dbmap/33_silsa-price-quote/`: `poster-sign-component-redesign.md`(신안 siz_width/height 전환)·`silsa-isomorph-merge-design.md`(동형결합 13→7)·`silsa-quote-design.md`(U6 공식분리)·`gd2-wiring-design.md`(후가공 배선 설계) | round-23 면적매트릭스 신안·동형결합·공식분리 설계(상당수 라이브 COMMIT 완료) |

**★핵심 발견 — 실사·현수막은 아크릴보다 가격사슬이 훨씬 완성돼 있다(라이브 실측 2026-06-20):**
- 아크릴: 본체 16상품 미바인딩(G-A1)·미러 공식 0·카라비너 comp 0 = 가격계산 불가가 다수.
- **실사·현수막: 28 PRF_POSTER_* 공식이 28상품(PRD_000118~145)에 전건 1:1 바인딩·각 공식 disp1=자기 본체 comp 실재·동형결합(13→7 정본)·신안 siz_width/height 전환 COMMIT 완료.** → 본체 가격계산은 **거의 완성**(GAP=후가공 배선·일부 단가행).
- **공식 권위 = calc-draft 행100이 실사·현수막을 아크릴과 동일 `[면적매트릭스형]`으로 명시 → 동형 종단의 정당 근거(반증불가).**

---

## 1. 계산방식 분류 (calc-formula-draft 권위) — 아크릴 2종 → 실사·현수막 **3종**

| 계산방식 | 정의 | 실사·현수막 해당 상품 | 권위 | 아크릴 동형? |
|----------|------|----------------------|------|:----:|
| **면적매트릭스형** | 판매가 = 소재별 [세로mm 행][가로mm 열] 면적 룩업단가 (off-grid='이하' 최소 임계 ceiling). 인쇄·재단·소재가 단가에 통합 | 면적 13소재: 아트프린트·아트페이퍼·방수·접착방수·접착투명·아트패브릭·린넨·캔버스·레더·타이벡·메쉬프린트 + **일반현수막·메쉬현수막** | calc-draft 행100 `[면적매트릭스형:실사,현수막]`·행101 `[세로mm행][가로mm열]` | ✅ **동형**(아크릴 행106·108과 병렬) |
| **고정가형** | 판매가 = 규격(siz_cd)별 고정 개당단가(면적 무관·이산 규격) | 폼보드·포맥스·프레임리스액자·레더액자·캔버스행잉·린넨우드봉족자·족자·PET배너·메쉬배너·시트커팅(무광/홀로)·아크릴스티커(유광/미러) | calc-draft 행103 `[고정가형: ...]` | ✅ **동형**(아크릴 카라비너 고정가와 동류·단 축이 siz_cd) |
| **★수량구간형(고정가+qty band)** | 판매가 = 규격(siz_cd) × **수량구간(min_qty tier)별 개당단가**(수량 많을수록 개당가 하락·볼륨할인 단가 내장) | **미니배너·미니보드스탠딩**(min_qty 4/19/49/99/10000 tier·라이브 실측) | 라이브 component_prices min_qty tier + 가격표 미니류 수량밴드 | 🔶 **비동형**(아크릴엔 없음·디지털인쇄 묶음과도 다름·§6) |

`확신도: 높음` — calc-draft 행100/103 명시 라벨 + 라이브 use_dims([siz_width,siz_height] vs [siz_cd] vs [siz_cd,min_qty]) 3분기가 반증불가로 확정.

**★아크릴과의 결정적 차이 3가지:**
1. **면적축은 동일하나 prc_typ가 다름** — 아크릴 본체 CLEAR3T=`.02 합가형`(min_qty=1 우연 안전), **실사·현수막 면적 본체 전건 `.01 단가형`**(÷min_qty 미발생·ValueError 위험 구조적 0). → 아크릴의 "신규 .02 행 min_qty=1 명시 가드"가 실사·현수막엔 불필요.
2. **고정가형 축이 다름** — 아크릴 카라비너 고정가=`use_dims=[opt_cd]`(형상), **실사·현수막 고정가=`use_dims=[siz_cd]`**(규격)·일부 `[siz_cd,min_qty]`(규격+수량밴드).
3. **수량구간형이 추가** — 미니류 = 규격×수량구간 단가(아크릴엔 부재).

---

## 2. 면적매트릭스 구조 (가격표 verbatim·라이브 실측 — 자[尺])

### 2-1. 매트릭스 축 = [세로mm 행] × [가로mm 열] = **siz_width × siz_height 구간**(아크릴과 동형·신안 채택)

```
행축 = 세로(siz_height): mm 임계 (예 린넨 600·800·1000·1200·1400·1600·1800·2000·2200·2400·2600 …)
열축 = 가로(siz_width):  mm 임계 (예 린넨 600·800·1000·1200)
셀 = 그 [가로][세로] 구간의 개당 완제품 단가 (인쇄+재단+소재 통합)
  예(라이브 실측 verbatim): 린넨 600×600=17,000 / 캔버스 600×1800=37,800 / 아트프린트 600×1800=21,600
```
- **★아크릴과 동형 — 신안(siz_width/siz_height 구간) 라이브 COMMIT 완료.** 라이브 실측: 면적 본체 comp 전건 `use_dims=["siz_width","siz_height"]`(siz_cd=NULL·numeric 직접). poster-sign-component-redesign §1 신안 전환(A안 좌표 siz 106 채번 폐기)·아크릴(WH 전환) 동일 모델.
- **off-grid = 엔진 TIER '이하' 최소 임계 ceiling**(`pricing.py` TIER_DIMS·TIER_UPPER·아크릴 §2-3 동일 메커니즘). 단가행에 ceiling 행 안 만듦.
- **인쇄 도수·재단 = 단가 통합**(아크릴 "양면9도/단면7도 통용단가"와 동형 — 면적단가가 완제품가). 별 도수축/재단 comp 없음. comp_typ=완제품가.

### 2-2. ★W=가로(앞)·H=세로(뒤)·work사이즈 금물 — 아크릴 돈크리티컬 동형 [HARD]

- 아크릴 round-23 확정과 **동형**: `siz_width`=가로(앞)·`siz_height`=세로(뒤) = 가격표 매트릭스 헤더. 라이브 면적 본체 전건 siz_cd=NULL·siz_width/siz_height numeric(work 미사용).
- ★**단 실사는 아크릴과 미묘한 차이: 실사는 직접입력형(자유 가로/세로)** — 주문자가 임의 mm 입력 → nonspec_incr(증가단위)로 스냅 → 구간 매칭. 아크릴은 규격 격자에 가까움. 실사의 work=cut(여백 0·직접입력형·silsa-quote §1.3). **work 블리드 가산 위험은 실사가 더 낮으나(cut=work) 원칙은 동일(가격축=siz_width/height 수치·work 가산 금물)**.

### 2-3. ★대형 면적·비규격 증가단위(nonspec) — 실사·현수막 고유점 (라이브 실측)

아크릴(소형·mm 200 이하)과 달리 실사·현수막은 **대형 면적(m 단위)·연속 사이즈**:

| 상품 | nonspec_yn | width_min~max | width_incr | 함의 |
|------|:--:|:--:|:--:|------|
| 면적포스터 11소재(PRD_000118~128) | Y | 200~600/900/1200mm | **200mm** | 직접입력 200mm 단위 스냅 |
| **일반현수막**(PRD_000138) | Y | **500~1750mm** | **100mm** | ★현수막=100mm 미세 증가단위(포스터 200보다 세밀) |
| **메쉬현수막**(PRD_000139) | Y | 500~900mm | **100mm** | 〃 |
| 고정가 15(폼보드·액자·미니 등) | **N** | — | — | 규격(siz_cd) 이산·nonspec 무관 |

- **★nonspec_incr = 입력 스냅(가격축 아님·아크릴 G-A6와 동형)** — 비규격 가로/세로 입력을 incr 단위로 정규화 후 siz_width/height 구간 매칭. 가격 룩업은 엔진 TIER ceiling. 라이브 백필 **완료**(아크릴은 incr NULL 미백필이 GAP였으나 실사·현수막은 width/height min/max/incr 전건 실재).
- **현수막 incr=100mm·포스터 incr=200mm** = 상품군 내 증가단위 차등(실무진 의도)·라이브 실재.

---

## 3. 3층 지도 — 면적매트릭스형 (완제품·아크릴 동형)

### 3-A. 면적 13소재 → **PRF_POSTER_<MAT>** (28공식 중 면적 13·라이브 바인딩 COMMIT됨)

> calc-draft 행100/101 `[면적매트릭스형:실사,현수막]·[세로mm행][가로mm열]` · 가격표 포스터사인 블록별 매트릭스

```
상품 [완제품] (라이브 바인딩 1:1·use_yn=Y 전건):
  PRD_000118 아트프린트포스터 → PRF_POSTER_ARTPRINT  → COMP_POSTER_ARTPRINT_PHOTO
  PRD_000119 아트페이퍼포스터 → PRF_POSTER_ARTPAPER  → COMP_POSTER_ARTPAPER_MATTE
  PRD_000120 방수포스터       → PRF_POSTER_WATERPROOF → COMP_POSTER_ARTPRINT_PHOTO ★동형결합(정본)
  PRD_000121 접착방수포스터   → PRF_POSTER_ADH_WP     → COMP_POSTER_ARTPRINT_PHOTO ★동형결합
  PRD_000122 접착투명포스터   → PRF_POSTER_ADH_CLEAR  → COMP_POSTER_ADH_CLEAR_PVC (단독)
  PRD_000123 아트패브릭포스터 → PRF_POSTER_ARTFABRIC  → COMP_POSTER_ARTPRINT_PHOTO ★동형결합
  PRD_000124 린넨패브릭포스터 → PRF_POSTER_LINEN      → COMP_POSTER_LINEN_FABRIC (단독)
  PRD_000125 캔버스패브릭포스터→ PRF_POSTER_CANVAS    → COMP_POSTER_CANVAS_FABRIC (정본)
  PRD_000126 레더아트프린트   → PRF_POSTER_LEATHER_AP → COMP_POSTER_CANVAS_FABRIC ★동형결합
  PRD_000127 타이벡프린트     → PRF_POSTER_TYVEK      → COMP_POSTER_CANVAS_FABRIC ★동형결합
  PRD_000128 메쉬프린트       → PRF_POSTER_MESH       → COMP_POSTER_CANVAS_FABRIC ★동형결합
  PRD_000138 일반현수막       → PRF_POSTER_BANNER_N   → COMP_POSTER_BANNER_NORMAL (단독·79행)
  PRD_000139 메쉬현수막       → PRF_POSTER_BANNER_M   → COMP_POSTER_BANNER_MESH (단독·46행)
  └─ 본체 면적 comp [면적매트릭스]
       use_dims = ["siz_width","siz_height"]   ★라이브 실측 verbatim (siz_cd=NULL)
       prc_typ  = PRICE_TYPE.01(단가형)·min_qty 전건 1 또는 NULL   ★아크릴 .02와 다름·÷ 미발생
       단가행: 정본 CANVAS_FABRIC 52·ARTPRINT_PHOTO 52·단독(ADH_CLEAR 52·LINEN 52·ARTPAPER 39·BANNER_N 79·BANNER_M 46)
       골든(라이브 verbatim): 캔버스 600×1800=37,800 / 아트프린트 600×1800=21,600 / 린넨 600×600=17,000
  · 도수·재단 = 단가 통합(완제품가)·별축 없음 (아크릴 동형)
  · off-grid = 엔진 TIER ceiling (siz_width/siz_height 각 축 '이하' 최소 임계)
  · 후가공(오시/미싱/귀돌이/가변/별색) = 면적축과 직교 (배선 GAP·§7 G-S2)
```
계산방식: **면적매트릭스형** · 라이브 baseline: PRF_POSTER_* 13면적공식·1배선(disp1 본체)·바인딩 28상품 전건 실재
`확신도: 높음(라이브 바인딩+동형결합+가격표 골든 3원 일치)`

**★동형결합(13→7 정본·silsa-isomorph-merge·라이브 COMMIT됨):** 단가표 byte-identical 2그룹만 결합 — 그룹A 정본 `CANVAS_FABRIC`←레더/메쉬프린트/타이벡(공식은 1:1 유지·comp만 정본 가리킴), 그룹B 정본 `ARTPRINT_PHOTO`←방수/접착방수/아트패브릭. 단독 5(접착투명·린넨·아트페이퍼·일반현수막·메쉬현수막)는 단가 상이로 결합 금지. **★byte-identical만 결합(행수 같아도 단가 다르면 금지)·[[dbmap-price-component-grouping]]·메모리.**

### 3-B. 현수막(배너) = 면적매트릭스형 본체 + 배너 전용 후가공 (라이브)

> 현수막은 면적 본체(BANNER_NORMAL/MESH)는 §3-A에 포함. **차이 = 배너 전용 후가공 옵션 comp 풍부**(라이브 실재·단 미배선):

```
일반현수막(PRD_000138) 배너 전용 후가공 comp (라이브 use_yn=Y·formula 미배선):
  COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4/6/8  타공(아일렛 구멍수)
  COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW      봉미싱(끝단 봉제)
  COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE      열재단(끝단 마감)
  COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE        양면테이프
  COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4       큐방(고정쇠)
  COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4      끈
메쉬현수막(PRD_000139): PROC_PUNCH_4/6/8·ADD_QBANG_4·ADD_STRING_4 (동형)
PET배너(PRD_000136): COMP_POSTEROPT_PET_BANNER_STAND_IN/OUT_S1/S2 (거치대)
```
계산방식: 면적매트릭스 본체 + **배너 후가공 add-on(타공/봉미싱/큐방/끈/거치대)** · ★후가공 comp 실재하나 **formula 미배선=가격사슬 직교 단절**(§7 G-S2)
`확신도: 높음(comp 라이브 실재)·배선 GAP`

---

## 4. 3층 지도 — 고정가형 + 수량구간형 (완제품)

### 4-A. 고정가형 (규격 siz_cd·면적 아님) → **PRF_POSTER_<X>** (라이브 바인딩됨)

> calc-draft 행103 `[고정가형: ...]` · 가격표 규격별 고정단가

```
상품 [완제품] (라이브 1:1 바인딩):
  PRD_000129 폼보드        → PRF_POSTER_FOAMBOARD  → COMP_POSTER_FOAMBOARD_WHITE (2행·use_dims=[siz_cd])
  PRD_000130 포맥스보드    → PRF_POSTER_FOMEXBOARD → COMP_POSTER_FOMEXBOARD_WHITE3MM
  PRD_000131 프레임리스우드액자→ PRF_POSTER_FRAMELESS → FRAMELESS_WOOD (use_dims=[siz_cd,min_qty])
  PRD_000132 레더아트액자  → PRF_POSTER_LEATHER_FRAME → LEATHER_FRAME [siz_cd,min_qty]
  PRD_000133 캔버스행잉포스터→ PRF_POSTER_CANVAS_HANGING → CANVAS_HANGING ★use_dims 선언은 [siz_width,siz_height,min_qty]이나 실데이터 siz_width/height NULL·min_qty=1·3행(=사실상 고정 3종·§7 G-S3)
  PRD_000134 린넨우드봉족자→ PRF_POSTER_LINEN_WOODBONG → LINEN_WOODBONG [siz_cd,min_qty]
  PRD_000135 족자포스터    → PRF_POSTER_JOKJA      → JOKJA [siz_cd,min_qty]
  PRD_000136 PET배너       → PRF_POSTER_PET_BANNER → PET_BANNER [siz_cd,min_qty]
  PRD_000137 메쉬배너      → PRF_POSTER_MESH_BANNER → MESH_BANNER [siz_cd,min_qty]·1행
  PRD_000140 무광시트커팅  → PRF_POSTER_SHEETCUT_MATTE → SHEETCUT_MATTE [siz_cd]·3행
  PRD_000141 홀로그램시트커팅→ PRF_POSTER_SHEETCUT_HOLO → SHEETCUT_HOLO [siz_cd]·3행
  PRD_000142 유광아크릴스티커→ PRF_POSTER_ACRYLSTK_GLOSS → ACRYLSTK_GLOSS [siz_cd]·4행
  PRD_000143 미러아크릴스티커→ PRF_POSTER_ACRYLSTK_MIRROR → ACRYLSTK_MIRROR [siz_cd]·4행
  └─ 본체 규격 comp [고정가/규격]
       use_dims = ["siz_cd"] 또는 ["siz_cd","min_qty"]   ★siz_width/height 아님(이산 규격)
       prc_typ  = PRICE_TYPE.01(단가형)·min_qty 전건 NULL 또는 1
  · 거치대/우드행거/우드봉/천정고리/거치대 = 추가옵션 comp 실재 (COMP_POSTEROPT_*·미배선 §7 G-S2)
```
계산방식: **고정가형(규격 siz_cd)** · ★아크릴 카라비너(opt_cd 형상)와 달리 **siz_cd 규격축**(폼보드/액자=명시규격) `확신도: 높음(라이브 바인딩+use_dims)`

### 4-B. ★수량구간형 (규격 × 수량밴드 단가·아크릴 비동형) → **PRF_POSTER_MINI_***

> 라이브 실측 — 미니류만 min_qty tier(볼륨할인 단가 내장):

```
상품 [완제품]:
  PRD_000144 미니보드스탠딩→ PRF_POSTER_MINI_STANDBOARD → MINI_STANDBOARD (15행)
  PRD_000145 미니배너      → PRF_POSTER_MINI_BANNER     → MINI_BANNER (10행)
  └─ 본체 규격×수량밴드 comp
       use_dims = ["siz_cd","min_qty"]
       prc_typ  = PRICE_TYPE.01(단가형)
       단가행(라이브 verbatim·미니배너 SIZ_000028 예):
         min_qty 4=6,500 / 19=4,900 / 49=4,200 / 99=3,500 / 10000=2,800  ★수량 ↑ 개당가 ↓
       ★엔진 처리: min_qty TIER('이상' 방향 아님·'이하 최소임계' = 주문수량 담는 구간)·개당가×수량
```
계산방식: **수량구간형(고정가+qty band)** · ★**아크릴엔 없음**·디지털인쇄 묶음총액과도 다름(여기는 개당가가 수량구간별 하락·×qty 폭발 없음·§6) `확신도: 높음(라이브 min_qty tier 실측)`

---

## 5. 완제품 vs 반제품(세트) 구분

| 구분 | 실사·현수막 상품 | 근거 |
|------|------------------|------|
| **완제품(단일 자기공식)** | 면적 13소재·고정가 13·수량구간 2 = 28상품 전건 | 각 상품 1 PRF 바인딩(면적/규격/수량밴드 본체 1 comp). 인쇄+재단+소재가 한 단가에 통합 = 단일 완제품 단가(아크릴 동형) |
| **반제품/세트(조합)** | **명시적 세트 상품 부재**(아크릴 동형) | calc-draft가 실사·현수막을 세트조합으로 분해하지 않음. 캔버스행잉·족자·액자는 "본체+거치/봉/액자틀"이나 가격표가 단일 규격단가(부품 합 아님). 거치/봉/행거는 **추가옵션(후가공) 합산**(§6)이지 별 SKU 세트 아님 |
| **추가상품/옵션(후가공·합산)** | 면적: 오시·미싱·귀돌이·가변텍스트·가변이미지·별색 / 현수막: 타공·봉미싱·열재단·큐방·끈·D테이프 / 고정가: 거치대·우드행거·우드봉·천정고리·린넨마감 | 상품마스터 후가공 칸 + 라이브 COMP_POSTEROPT_*·COMP_PP_* 실재. 본체와 직교·합산형(addtn_yn=Y) — **단 대부분 formula 미배선(§7)** |

**★아크릴과 동형 — 명시적 반제품(세트조합) 구조 없음.** 캔버스행잉/족자/액자도 본체는 단일 규격 면적단가·거치류는 후가공 add-on(별 구성품 SKU 합산 아님). 세트조합 레이어 설계 불요. `확신도: 높음(calc-draft 세트분해 없음·라이브 단일 본체 공식)`

---

## 6. ★동형결함 사전 플래그 — ×qty 폭발·silent 이중합산·출력매수 사슬 (라이브 실측 판정)

아크릴 §6 동형 점검 + 실사·현수막 고유점(대형면적·수량구간·소재다양):

| 결함 | 아크릴 판정 | **실사·현수막 판정 (라이브 실측 2026-06-20)** | 위험도 |
|------|-----------|---------------------------------------------|--------|
| **① 출력매수/판수 곱셈사슬** (디지털 "출력매수=주문수량/판걸이수" ×사슬) | 🟢 없음(개당가) | 🟢 **없음** — 면적단가·규격단가·수량밴드단가 전부 **개당 완제품가**(인쇄+재단+소재 통합). 출력매수/판걸이수 차원 부재(라이브 use_dims에 plate/판수 없음). calc-draft "판매가=[세로][가로]" = 면적당 완제품가. **디지털인쇄의 곱셈사슬 부재(아크릴 동형)** | 🟢 안전 |
| **② prc_typ ×qty 폭발** (단가가 묶음총액인데 ×qty) | 🟡 .02(min_qty=1 우연 안전·가드 필요) | 🟢 **더 안전** — 면적·고정가 본체 전건 `.01 단가형`(아크릴 .02와 다름). `unit×qty`·÷min_qty 미발생. 단가=개당가. **신규 .02 행 가드조차 불필요**(전건 .01) | 🟢 안전 |
| **③ silent 이중합산** (두 comp 한 공식·판별차원 NULL) | 🟢 없음(공식당 1 comp) | 🟢 **현재 없음** — 라이브 28 PRF 전건 **disp1 본체 1 comp만**(multi-comp 공식 0건·실측). 합산 대상 1개=구조적 이중합산 불가. **★단 후가공 배선(§7 G-S2) 시 본체+후가공 N comp가 한 공식에 → 각 후가공 판별차원(proc_cd/opt_cd/print_opt_cd) 필수**(gd2-wiring §1.2: 본체는 면적축뿐이라 동시매칭 위험은 소재 comp 한 공식 다배선일 때만·U6 공식분리로 이미 회피됨). designer 주의 | 🟡 후가공 배선 시 |
| **④ 동형결합 단가 오염** (byte-identical 아닌데 결합) | — | 🟢 **검증됨** — 결합 2그룹 전컬럼 md5 byte-identical·셀 diff 0·단가행 보존(DELETE 0)·골든 불변(isomorph-merge §1.3). 단독 5는 단가 상이로 결합 안 함(정당). [[dbmap-price-component-grouping]] | 🟢 안전 |
| **⑤ 수량구간형 ×qty** (미니류 min_qty tier) | 없음(해당없음) | 🟢 **안전** — 미니 단가=수량구간별 **개당가**(4개=6,500/개·100개=2,800/개). 엔진=구간 룩업 후 개당가×수량. 묶음총액 아님(min_qty tier가 볼륨할인 단가). ×qty 폭발 없음 | 🟢 안전 |

**∴ 결론: 디지털인쇄의 3대 동형결함(출력매수 곱셈사슬·×qty 폭발·silent 이중합산)은 실사·현수막에 없다.** 면적/규격/수량밴드 단가가 전부 개당 완제품가이고, 본체 prc_typ가 전건 `.01`이며, 현 라이브는 공식당 comp 1개. **유일한 잠재 위험 = 후가공 배선(§7 G-S2) 시 판별차원 충전**(단 U6 공식분리가 본체 동시매칭은 이미 차단). `확신도: 높음(라이브 prc_typ·min_qty·use_dims·배선 직접 실측)`

---

## 7. gap-board (실사·현수막 절) — designer 작업 큐

| ID | 갭 | 유형 | 심각도 | designer 작업 |
|----|----|------|--------|---------------|
| **G-S1** | **후가공 add-on formula 미배선** (오시·미싱·귀돌이·가변·별색 + 배너 타공/봉미싱/큐방/끈/거치대 + 거치/우드봉/우드행거/천정고리/린넨마감 comp 전부 라이브 실재하나 **PRF_POSTER 공식에 disp2~ 배선 0건**·실측) | 가격사슬 직교 단절 | 🔴 High | gd2-wiring W4 명세대로 각 PRF에 후가공 comp(addtn_yn=Y·disp2~) 배선. ★엔진 addtn_yn 미참조·매칭 시만 합산(pricing.py:349)·미선택 자연제외 → **배선만 하면 됨**. 본체 동시매칭은 U6 공식분리(라이브 완료)로 이미 차단. **함의: 현재 견적 시 후가공 선택해도 가격 반영 0**(본체만 산출) |
| **G-S2** | **미싱(PERF) 차원축 opt_cd 부정합** (COMP_PP_PERF_1L use_dims=[opt_cd]·다른 후가공 proc_cd 모델과 불일치) | 모델 불일치 | 🟡 Med | gd2-wiring W5: PERF use_dims opt_cd→proc_cd 전환·dim_vals.줄수 이설·prc_typ .02→.01·2L/3L use_yn=N. 이설(값동일·신규0) 후 배선(G-S1 일부) |
| **G-S3** | **CANVAS_HANGING use_dims 선언↔실데이터 불일치** (use_dims=[siz_width,siz_height,min_qty] 선언이나 실 3행 siz_width/height NULL·min_qty=1 = 사실상 고정 3종) | 차원 선언 오류 | 🟡 Med | 실데이터가 면적 아닌 고정 3규격 → use_dims를 [siz_cd] 또는 명시 차원으로 정정 vs 단가행에 siz_width/height 채움. 실무 컨펌(가격축 정확성). 동일 의심: ARTPRINT_PHOTO/CANVAS_FABRIC use_dims에 min_qty 포함이나 min_qty 전건 NULL/1 — 잔류 시맨틱 |
| **G-S4** | **별색 WHITE_S1 중복행** (silsa-quote U5: 530행 중 초과중복 분석·라이브 잔류 여부 재확인 대상) | 데이터 정합 | 🟡 Med | 별색 정본(WHITE_S1/S2) 형제색 use_yn=N·중복행 정리는 dbmap round-23 별색 dedup 트랙(상당수 COMMIT)·잔류분 재실측 후 배선(G-S1). designer는 정본 2개만 배선 |
| **G-S5** | **고정가 단가행 결손 가능성** (메쉬배너 1행·PET배너 1행 등 일부 규격 sparse) | 단가행 결손 | ⚪ Low | 가격표 규격 전건 대조·결손 규격 INSERT(가격표 verbatim·dbmap import 트랙). 가격축 신규 아님 |
| **G-S6** | **CPQ 옵션레이어 전무** (소재선택·후가공 택1/택N·거치 옵션) | 옵션 미적재 | 🟡 Med | round-7 횡단 — option_items 전역 미적재. 후가공=합산형(§6·gd2-wiring Q-A6 확정)이 가격축·CPQ는 선택 UI. round-6 dbm-option-mapper |

**designer 우선순위**: ① **G-S1(후가공 미배선)=실사·현수막 핵심 갭**(본체는 거의 완성·후가공만 단절)·gd2-wiring W4 명세 실행 → ② G-S2(미싱 전환·G-S1 선행) → ③ G-S3/G-S4(차원·별색 정합) → ④ G-S5/G-S6. **신규 comp/공식 mint 거의 0**(후가공 comp 전부 실재·공식 28 실재·동형결합 완료) — search-before-mint 강하게 충족(아크릴보다 우월).

---

## 8. 핵심 메모 (아크릴 동형점 / 비동형점)

### 아크릴 동형점 (그대로 적용)
1. **면적매트릭스 = [세로행][가로열] = siz_width/siz_height 구간** — calc-draft 행100이 실사·현수막을 아크릴(행106)과 같은 클래스로 명시. 신안(siz_width/height·좌표 채번 0) 라이브 COMMIT 완료.
2. **W=가로(앞)·H=세로(뒤)·work사이즈 금물** — 돈크리티컬 동형(단 실사는 cut=work·직접입력형이라 work 가산 위험 더 낮음).
3. **off-grid = 엔진 TIER ceiling 내장** — 단가행에 ceiling 행 안 만듦(pricing.py TIER_UPPER).
4. **도수·재단 = 단가 통합(완제품가)·별축 없음** — 면적단가=개당 완제품가.
5. **출력매수 곱셈사슬·×qty 폭발·silent 이중합산 동형결함 없음** — 개당가·공식당 1 comp.
6. **명시적 반제품(세트조합) 없음** — 본체 단일 공식·거치류는 후가공 add-on.

### 비동형점 (아크릴과 다름·반드시 구분)
1. **prc_typ 더 안전** — 실사·현수막 면적 본체 전건 `.01 단가형`(아크릴 CLEAR3T=.02). 아크릴의 ".02 신규행 min_qty=1 가드"가 불필요.
2. **고정가형 축이 siz_cd(규격)** — 아크릴 카라비너=opt_cd(형상). 실사·현수막 고정가=명시 규격.
3. **수량구간형 추가**(미니류 min_qty tier·아크릴 부재) — 규격×수량밴드 개당가(볼륨할인 단가 내장).
4. **대형 면적·연속 사이즈·nonspec_incr 차등** — 현수막 incr=100mm/포스터 200mm(라이브 백필 완료·아크릴은 incr NULL이 GAP였음).
5. **소재 다양·동형결합 라이브 적용** — 13→7 정본(byte-identical 2그룹)·아크릴은 결합 대상 없었음.
6. **가격사슬 완성도 정반대** — 아크릴=본체 미바인딩(G-A1) 다수가 핵심 갭. **실사·현수막=본체 거의 완성(28공식 바인딩+동형결합 COMMIT)·핵심 갭은 후가공 배선(G-S1)**.

### 라이브 현황 요약
7. **본체 가격사슬 = 거의 완성** — 28 PRF_POSTER 공식·28상품 1:1 바인딩·각 공식 disp1 본체·동형결합·신안 전환 전부 라이브 COMMIT(2026-06-20 실측). 골든(캔버스 37,800·아트프린트 21,600·린넨 17,000) verbatim 재현.
8. **후가공 = 단절** — COMP_POSTEROPT_*·COMP_PP_*(타공/봉미싱/큐방/끈/거치/오시/미싱/귀돌이/가변/별색) 라이브 실재하나 **PRF에 disp2~ 배선 0건**. 현 견적은 본체만 산출(후가공 선택해도 가격 반영 0). **핵심 갭=후가공 배선(G-S1)·gd2-wiring W4 명세 존재(미적용)**.
