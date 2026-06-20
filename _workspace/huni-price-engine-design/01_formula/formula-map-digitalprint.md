# formula-map-digitalprint.md — 디지털인쇄 가격공식 3층 지도

> **기준점 지도 (생성 입력).** "후니가 디지털인쇄 가격을 어떻게 계산하려는가"의
> 상품→가격구성요소→계산방식 3층 지도. 설계가(designer)·검증가(validator)가 이것을 자(尺)로 쓴다.
> 권위 순서[HARD]: ① 상품마스터(260610) > ② 인쇄상품 가격표(260527) > ③ 라이브 t_prc_*(현 상태 기준선) > ④ 역공학(후보).
> 산출자: hpe-formula-cartographer · 라이브 실측 2026-06-20 읽기전용 SELECT · 추정 0.

---

## 0. 권위 원천 요약

| 원천 | 위치 | 역할 |
|------|------|------|
| 상품마스터 디지털인쇄 시트 | `24_master-extract-260610/digital-print-l1.csv` (212행, 36 anchor 상품) | 상품별 요소(사이즈/판수/종이/인쇄/별색/코팅/커팅/접지/후가공/박/추가상품) + 행별 `가격공식` 칸 |
| **계산공식집초안 시트** | `24_master-extract-260610/calc-formula-draft-l1.csv` (95행) | **★공식 유형 정의의 절대 권위** — 상품군별 판매가 공식·구성요소 분해를 명문화 |
| 인쇄상품 가격표(260527) | `06_extract/` 단가 CSV | 차원·단가 매트릭스 |
| 라이브 t_prc_* | Railway DB (2026-06-20 실측) | PRF_DGP_A~F 6공식 + PRF_NAMECARD_FIXED + PRF_PHOTOCARD_FIXED 실재(기준선) |

**★핵심 발견 — 가격공식 권위는 두 곳에 이원화:**
- 상품마스터 `가격공식` 칸은 **희소**(엽서 프리미엄/코팅 2행에만 합산식, 나머지는 파일명 규칙·공란·truncated `[인쇄-`). 신뢰 낮음.
- **계산공식집초안 시트가 상품군 단위 공식 유형의 정본**. 디지털인쇄 전 상품군을 유형(원자합산형/고정가형)으로 분류하고 구성요소를 분해해 둠. **이 지도는 calc-draft를 1차 권위로 삼는다.**

---

## 1. 계산방식 분류 (calc-formula-draft 권위)

디지털인쇄 상품군의 계산방식은 **2종**으로 수렴한다(면적매트릭스형은 아크릴/실사 등 타 시트):

| 계산방식 | 정의 | 디지털인쇄 해당 상품군 |
|----------|------|----------------------|
| **원자합산형** | 판매가 = Σ(구성요소비). 각 비목을 독립 계산 후 합산 | 엽서류·상품권·슬로건 · 모양엽서·라벨택 · 인쇄배경지·헤더택 · 소량전단지 · 접지카드·접지리플렛 · 썬캡(미출시) |
| **고정가형** | 판매가 = [수량행][소재/면/옵션 열] 룩업단가(용지 포함) (+ 후가공) | 명함류(8종) · 오리지널박명함 · 포토카드·투명포토카드 |

`확신도: 높음` (calc-formula-draft B열 명시 라벨 "[원자합산형: …]" / "[고정가형: …]").

---

## 2. 3층 지도 — 원자합산형 (완제품)

### 2-A. 엽서류·상품권·슬로건  → **PRF_DGP_A** (라이브 실재)

> calc-draft: `판매가 = 인쇄비 + 코팅비 + 용지비 + 후가공비 + 추가상품` (별색인쇄비·대형박 별도)

```
상품 [완제품]: 프리미엄엽서·코팅엽서·스탠다드엽서·투명엽서·화이트인쇄엽서·핑크별색엽서·
              금은별색엽서·종이슬로건·스탠다드 쿠폰/상품권·프리미엄 쿠폰/상품권
  ├─ (1) 인쇄비(4도)   = [수량행단가] × 출력매수        comp=COMP_PRINT_DIGITAL_S1  [원자합산]
  │        출력매수 = 주문수량 / 판걸이수(판수)
  │        use_dims=[proc_cd, plt_siz_cd, print_opt_cd, min_qty, proc_grp:PROC_000001]
  ├─ (2) 별색인쇄비    = [인쇄비단가] + [출력매수 수량행]×[칼라열]  comp=COMP_PRINT_SPOT_WHITE_S1
  │        ★색(화이트/클리어/핑크/금/은)×면(단/양)은 단일 comp의 proc_cd/print_opt_cd 차원으로 흡수
  │        use_dims=[plt_siz_cd, proc_cd, print_opt_cd, min_qty, proc_grp:PROC_000007]
  ├─ (3) 코팅비        = [수량행단가]×[코팅타입열] × 출력매수    comp=COMP_COAT_GLOSSY / COMP_COAT_MATTE
  │        use_dims=[siz_cd, coat_side_cnt, min_qty]
  ├─ (4) 용지비        = [크기별 기준단가] × [출력매수] + 5장(손지율)  comp=COMP_PAPER
  │        use_dims=[siz_cd, mat_cd]                                  (★손지율 +5장은 엔진계산 가설)
  ├─ (5) 후가공비      = [제작수량행]   comp=COMP_PP_CORNER_RIGHT(귀돌이)·CREASE_1L(오시)·
  │                                          PERF_1L(미싱)·VARTEXT_1EA·VARIMG_1EA
  └─ (8) 추가상품      = 목록별 가격적용  (봉투류 등 → addon/template 트랙, 공식 외)
  · (7) 후가공박(대형) = [면적별동판비] + [면적별 A~E군][군별·칼라별 수량행 합가]  ★PRF_DGP_A에 미배선(GAP)
```
계산방식: **원자합산형** · 라이브 baseline: PRF_DGP_A (10 comp 배선·9개 single 상품 바인딩) `확신도: 높음(라이브+calc-draft 일치)`

### 2-B. 모양엽서·라벨택  → **PRF_DGP_B**
> calc-draft: `판매가 = 인쇄비 + 용지비 + 커팅비` · `커팅비 = [출력매수] × 2000원[커팅가격테이블]`
```
상품 [완제품]: 모양엽서·라벨/택
  ├─ 인쇄비   COMP_PRINT_DIGITAL_S1
  ├─ 용지비   COMP_PAPER
  └─ 커팅비(완칼)  COMP_CUT_FULL_DIECUT   use_dims=[siz_cd, min_qty]
```
계산방식: 원자합산형 · baseline: PRF_DGP_B (3 comp) `확신도: 높음`

### 2-C. 인쇄배경지·헤더택  → **PRF_DGP_C**
> calc-draft: `판매가 = 인쇄비 + 용지비 + 접지비 + 타공비 + 추가상품`
```
상품 [완제품]: 인쇄배경지(OPP봉투타입)·인쇄배경지(투명케이스타입)·인쇄헤더택
  ├─ 인쇄비   COMP_PRINT_DIGITAL_S1
  ├─ 용지비   COMP_PAPER
  ├─ 접지비(카드 2단)  COMP_FOLD_CARD_2H   use_dims=[min_qty]   ★접지비=오시 가격테이블 참조(calc-draft)
  ├─ 타공비   COMP_CUT_PERF_1H6  = [출력매수] × 장당 1000원[타공가격테이블]
  └─ (추가상품)  공식 외
```
계산방식: 원자합산형 · baseline: PRF_DGP_C (4 comp) `확신도: 높음`

### 2-D. 소량전단지  → **PRF_DGP_D**
> calc-draft: `판매가 = 인쇄비 + 코팅비 + 용지비 + 후가공비`
```
상품 [완제품]: 소량전단지
  ├─ 인쇄비   COMP_PRINT_DIGITAL_S1
  ├─ 코팅비   COMP_COAT_GLOSSY / COMP_COAT_MATTE  (★종이 180g 이상만 코팅가능 제약)
  ├─ 용지비   COMP_PAPER
  └─ 후가공비 COMP_CUT_PERF_1H6·CREASE_1L·PERF_1L·VARTEXT·VARIMG·CORNER_RIGHT
```
계산방식: 원자합산형 · baseline: PRF_DGP_D (10 comp) `확신도: 높음`

### 2-E. 접지카드·접지리플렛  → **PRF_DGP_E**
> calc-draft: `판매가 = 인쇄비 + 코팅비 + 용지비 + 접지비 + 후가공비 + 후가공_박(대형) + 추가상품` (국4절/3절 기준)
```
상품 [완제품]: 2단접지카드·미니접지카드·3단접지카드 · (접지리플렛·와이드접지리플렛=미바인딩 GAP)
  ├─ 인쇄비   COMP_PRINT_DIGITAL_S1
  ├─ 코팅비   COMP_COAT_GLOSSY / COMP_COAT_MATTE
  ├─ 용지비   COMP_PAPER
  ├─ 접지비   COMP_FOLD_LEAF_HALF·3FOLD·4ACC·4GATE  use_dims=[min_qty]  (★상품마다 접지타입 택1)
  ├─ 타공비   COMP_CUT_PERF_1H6
  └─ · 후가공박(대형)  ★미배선(GAP·calc-draft가 요구)
```
계산방식: 원자합산형 · baseline: PRF_DGP_E (9 comp) `확신도: 높음(접지비 단가행 결손 점검 필요)`

### 2-F. 썬캡 (미출시)  → **PRF_DGP_F**
> calc-draft: `판매가 = 용지비 + 인쇄비 + 커팅비`
```
상품 [반제품 후보·미출시]: 썬캡   ├─ 인쇄비 COMP_PRINT_DIGITAL_S1  ├─ 용지비 COMP_PAPER  └─ 커팅비 COMP_CUT_FULL_DIECUT
```
계산방식: 원자합산형 · baseline: PRF_DGP_F (3 comp) · ★MES 미등록 신규상품(상품마스터 노랑배경) `확신도: 중(미출시)`

---

## 3. 3층 지도 — 고정가형 (완제품)

### 3-A. 명함류 (8종)  → **PRF_NAMECARD_FIXED** (라이브 실재)
> calc-draft: `판매가 = [수량행][소재×면열] + 후가공비` · "명함/포토카드 시트 가격은 용지 포함"
```
상품 [완제품]: 스탠다드명함·프리미엄명함·코팅명함·펄명함·투명명함·화이트인쇄명함·모양명함·미니모양명함
  ├─ 완제품 단가(단면)  COMP_NAMECARD_STD_S1   use_dims=[mat_cd, min_qty]   ★용지·인쇄·코팅 통합단가
  ├─ 완제품 단가(양면)  COMP_NAMECARD_STD_S2   use_dims=[mat_cd, min_qty]
  ├─ (후가공비)  COMP_PP_* (calc-draft가 명함 후가공비 별도 요구)  ★PRF_NAMECARD_FIXED에 미배선(GAP)
  └─ (후가공박 소형)  [동판비]+[면적별 A~E군 합가]  ★미배선(GAP·calc-draft 요구)
```
계산방식: **고정가형** · baseline: PRF_NAMECARD_FIXED (S1·S2 단 2 comp·단가행 각 2행=희소) `확신도: 높음(구조)·중(단가행 결손 의심)`

### 3-B. 오리지널박명함  → **고정가형 (라이브 미바인딩 GAP)**
> calc-draft: `판매가 = 동판비 + 오리지널박명함(테이블)`
```
상품 [완제품]: 오리지널박명함 (형압명함 동 ID)
  ├─ 동판비
  └─ 오리지널박명함 룩업테이블 단가
```
계산방식: 고정가형 · ★라이브 PRF 미배선(GAP) `확신도: 높음(calc-draft)`

### 3-C. 포토카드·투명포토카드  → **PRF_PHOTOCARD_FIXED** (라이브 실재)
> calc-draft: `판매가 = [세트당 고정단가]`
```
상품 [완제품·세트]: 포토카드·투명포토카드
  ├─ 일반세트 고정단가  COMP_PHOTOCARD_SET        use_dims=[siz_cd, bdl_qty, min_qty]
  └─ 투명세트 고정단가  COMP_PHOTOCARD_CLEAR_SET  use_dims=[siz_cd, bdl_qty, min_qty]
```
계산방식: 고정가형(세트단가) · baseline: PRF_PHOTOCARD_FIXED (2 comp·단가행 각 1행=희소) `확신도: 높음(구조)·중(단가행)`

### 3-D. 봉투제작  → **고정가형 (라이브 미바인딩 GAP)**
> calc-draft: `판매가 = [수량행][소재열]`
```
상품 [완제품]: 봉투제작 (·OPP접착봉투·OPP비접착봉투·카드봉투·트레싱지봉투 — 추가상품/완제품 경계 컨펌큐)
```
계산방식: 고정가형 · ★라이브 PRF 미배선(GAP) `확신도: 중(추가상품 vs 독립상품 경계)`

---

## 4. 완제품 vs 반제품(세트) 구분

| 구분 | 디지털인쇄 상품 | 근거 |
|------|----------------|------|
| **완제품(단일 자기공식)** | 위 모든 상품군 본체 | 단일 상품 1 공식 바인딩 |
| **반제품/세트(조합)** | **엽서북(내지+표지 별 행)** · 포토카드(세트=bdl_qty 차원) · (캘린더·책자=타 시트) | 엽서북=`엽서북-내지(몽블랑240)`+`엽서북-표지(스노우300)` 2행 분리 / calc-draft 별도 "엽서북/떡메=[수량행][옵션열] 고정가형" |
| **추가상품(공식 외 add-on)** | 봉투류(엽서봉투·OPP·카드봉투·트레싱지봉투) | 상품마스터 `추가상품` 칸 + calc-draft "(8)추가상품=목록별 가격적용" |

**★엽서북 = 반제품/세트조합 후보** — 내지·표지가 별 SKU 행으로 분해됨. calc-draft는 엽서북을 고정가형 `[수량행][옵션열]`로 둠. designer가 세트 조합 레이어(내지단가+표지단가 합) 모델링 필요. `확신도: 중(세트 조합 미배선)`

---

## 5. 핵심 메모

1. **공식 권위 이원화** — 상품마스터 `가격공식` 칸은 희소·truncated. **calc-formula-draft 시트가 정본**. 둘이 어긋나면 calc-draft 우선(컨펌큐 §gap-board).
2. **출력매수 = 주문수량 / 판걸이수(판수)** — 판수는 상품마스터 `판수` 칸(앱 임포지션 계산값·DB 미저장 가능성). 인쇄비·코팅비·용지비가 공통으로 출력매수를 곱한다.
3. **별색인쇄 = 단일 comp + 색×면 차원** — CLEAR/GOLD/PINK/SILVER/WHITE × S1/S2 형제 comp는 전부 `del_yn=Y`(논리삭제)·정본 COMP_PRINT_SPOT_WHITE_S1(530 단가행)이 proc_cd/print_opt_cd 차원으로 5색×2면 흡수. designer는 별색을 별 comp로 분할 금지.
4. **고정가형 단가행 희소** — NAMECARD S1/S2 각 2행, PHOTOCARD 각 1행. mat_cd×min_qty / siz_cd×bdl_qty×min_qty 매트릭스가 실제로 채워졌는지 단가행 결손 점검 필요(→ gap-board).
5. 라이브는 calc-draft가 요구한 **후가공박(대형/소형)·접지리플렛·오리지널박명함·봉투제작**을 아직 미배선(GAP·designer 큐).
