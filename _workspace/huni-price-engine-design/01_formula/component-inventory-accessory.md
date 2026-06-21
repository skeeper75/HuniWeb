# component-inventory-accessory.md — 상품악세사리 가격구성요소 인벤토리

> **기준점(생성 입력).** 상품악세사리(가격포함) 시트 14상품(67 variant행) + 이중등록 3상품이 가격에 쓰는 구성요소 전수 인벤토리. 각 요소의 차원(use_dims 후보)·단가 소스·재사용 후보.
> 산출자: hpe-formula-cartographer · 라이브 실측 2026-06-22 read-only SELECT · 권위=상품마스터(260610) 절대 · 추정 0.
> 통합 인벤토리(`01_formula/component-inventory.md`)에 병합 가능 — 본 파일은 상품악세사리 전용 슬라이스.

---

## 1. 가격구성요소 전수 인벤토리

| comp(논리) | 계산방식 | 차원(use_dims 후보) | 단가 소스(셀) | 가격 역할 | 라이브 그릇 | 재사용 후보 |
|------------|----------|---------------------|---------------|-----------|------------|-------------|
| **AC base 단일고정가** | inline 고정가형 | (없음·prd 1값) | 상품마스터 `가격` I열(볼체인1000·와이어링500·리필잉크2500) | 유일 가격항 | `t_prd_product_prices` (현 0행) | ★굿즈 GP-1 그릇 = PRODUCT_PRICE 무손실 |
| **AC base 변형고정가(규격)** | inline 고정가형(variant) | `siz_cd` | `가격` I열 variant행(OPP 70x200=1100…230x350=3250) | variant별 가격항 | **그릇 부재**(product_prices unit_price 1개·G-AC-1) | ★굿즈 GP-2 variant-매트릭스 formula |
| **AC base 변형고정가(묶음수)** | inline 고정가형(variant) | (`bdl_qty` 또는 opt_cd) | `가격` I열(트래싱지 20장6000/40장12000/100장28000) | variant별 가격항 | 그릇 부재(묶음수=가격variant) | variant-매트릭스 formula(opt축) |
| **AC base 변형고정가(색상)** | inline 고정가형(variant) | (opt_cd) | `가격` I열(카드봉투 화이트1000/블랙1500) | variant별 가격항 | siz_nm 합성(F-PA size) | variant-매트릭스 formula(opt축) |
| **AC base 변형고정가(길이/용량/3D)** | inline 고정가형(variant) | (`siz_cd` 또는 opt) | `가격` I열(우드봉 270mm7000~480mm12000·투명케이스 3D 3000~3500) | variant별 가격항 | 그릇 부재 | variant-매트릭스 formula |
| 규격 차원 | (식별·가격분기) | `siz_cd` | (가격표 매트릭스 아님·이산) | AC-2 분기 | cut_width/cut_height 분해(정상) | 이산 siz_cd(면적 ceiling 아님) |
| 묶음수 차원 | (식별·가격분기) | `bdl_qty`/opt | — | AC-2 분기(트래싱지) | siz_nm 잔존 + bdl_qty 일부 | 굿즈 size→option 동형 |
| 색상 차원 | (식별·AC-1무영향/AC-2분기) | opt | — | variant | MAT_TYPE.10 오염(볼체인8·리필7) | 색상=옵션(자재 아님·[[material-option-normalization]]) |
| 수량 qty | × 곱셈 | (× base) | — | base × qty | min1·max100·incr1 | pricing.py:316 unit_price×qty |
| addon 적용 | TEMPLATE_PRICE 경로 | `tmpl_cd` | `t_prd_template_prices`(현 0행) | 본체 가산 라인 | 봉투 template 12행 실재 | template_prices 단가만 충전 |
| **(부재) 자재 mat_cd** | — | — | — | **N/A**(완제 부속·인쇄 BOM 없음) | MAT_TYPE.10 색상 오염 잔존 | dbmap 자재축 트랙 위임 |
| **(부재) 공정 proc_cd / 도수 print_opt_cd / 판형** | — | — | — | **N/A** | 0 | — |

---

## 2. 단가 소스 맵 (전부 상품마스터 inline — 가격표 매트릭스 0)

| 상품(distinct) | prd_cd | 서브유형 | 단가 소스 | variant 가격 분기 | 가격값(L1 verbatim) |
|----------------|--------|----------|-----------|-------------------|---------------------|
| OPP접착봉투 | PRD_000001 | AC-2(규격) | 마스터 I열·11행 | 규격 | 70x200=1100 … 230x350=3250 |
| OPP비접착봉투 | PRD_000002 | AC-2(규격) | I열·11행 | 규격 | 60x90 20장=600 … 160x250=1500 |
| 트래싱지 카드봉투 | PRD_000003 | AC-2(규격×묶음수) | I열·8행 | ★규격×묶음수 | 160x110 20장6000/40장12000/100장28000·100x100 20장6800… |
| 카드봉투 | PRD_000004 | AC-2(색상) | I열·2행 | 색상 | 화이트1000/블랙1500 |
| 캘린더봉투 | PRD_000005 | AC-2(규격) | I열·2행 | 규격 | 240x230=2500/150x310=2400 |
| 볼체인 | PRD_000006 | AC-1(색상동가) | I열·8행 | (무영향) | 8색 전부 1000 |
| 와이어링 | PRD_000007 | AC-1(색상동가) | I열·3행 | (무영향) | 3색 전부 500 |
| 천정고리 | PRD_000008 | AC-2(단일·use_yn=N) | I열·1행 | — | 2개1세트 6500 |
| 투명케이스 | PRD_000009 | AC-2(3D규격) | I열·3행 | 3D규격 | 42x57x20=3000/75x75x15=3000/75x110x15=3500 |
| 행택끈 | PRD_000010 | AC-2(종류) | I열·3행 | 종류 | 사각검정3000/백색3000/마사4000 |
| 자석고정용고무판 | PRD_000011 | AC-2(단일) | I열·1행 | — | 20x20 20개입 1000 |
| 우드거치대 | PRD_000012 | AC-2(단일) | I열·1행 | — | 120mm 4mm홈 4000 |
| 우드봉 | PRD_000013 | AC-2(길이) | I열·3행 | 길이 | 270mm7000/360mm9800/480mm12000 |
| 우드행거 | PRD_000014 | AC-2(길이) | I열·3행 | 길이 | 230mm16000/320mm18000/440mm20000 |
| 만년스탬프 리필잉크 | PRD_000015 | AC-1(색상동가) | I열·7행 | (무영향) | 7색 전부 2500 |
| 카드봉투(화이트) | PRD_000281 | 이중역할 | (addon TMPL-000010) | — | template 단가 미적재 |
| 카드봉투(블랙) | PRD_000282 | 이중역할 | (addon TMPL-000011) | — | template 단가 미적재 |
| 트레싱지봉투 | PRD_000283 | 이중역할 | (addon TMPL-000009) | — | template 단가 미적재 |

★전 67행 가격 = 상품마스터 inline·**가격표(260527) 매트릭스 0건**. 봉투제작(PRD_000050·MATRIX형)은 별 상품군(혼동 금지). `확신도: 높음(L1 67행 I열 전수·라이브 product_prices 0)`

---

## 3. 차원(use_dims) 후보 정리 — designer 입력

| 서브유형 | use_dims 후보 | 사유 | 돈크리티컬 |
|----------|---------------|------|------------|
| AC-1 단일고정가 | (없음) | prd당 1값·variant 동가 | product_prices 1행이면 충분 |
| AC-2 규격변형 | `[siz_cd]` | 규격별 다른 고정가 | siz_cd 누락 시 단일가 오청구 |
| AC-2 묶음수변형 | `[siz_cd, bdl_qty]` 또는 `[opt_cd]` | 같은 규격·다른 묶음=다른 가격(트래싱지) | ★묶음수 평탄화 시 가격 붕괴(G-AC-2) |
| AC-2 색상변형 | `[opt_cd]` | 색상별 다른 고정가(카드봉투) | siz_nm 합성 잔존 |
| AC-2 길이/3D변형 | `[siz_cd]` | 길이/3D규격별 고정가 | — |

★variant-매트릭스 그릇(굿즈 GP-2 G-GP-1 동형): 단일 comp + use_dims=[variant축] + variant당 단가행. **신규 가격축 0**(린넨 `COMP_POSTEROPT_LINEN_FINISH` use_dims=[opt_cd] 그릇 재사용·dbmap round-23). `확신도: 높음`

---

## 4. 통합 인벤토리 재사용 매핑 (`component-inventory.md` 병합 시)

| 상품악세사리 comp | 통합 인벤토리 동형 | 재사용 |
|-------------------|---------------------|--------|
| AC-1 단일고정가 | 굿즈 GP-1 / 문구 DT-1 (PRODUCT_PRICE) | 그릇 동일 |
| AC-2 변형고정가 | 굿즈 GP-2 (variant-매트릭스 formula) | 그릇 동일·미해결 난제 공유 |
| addon TEMPLATE_PRICE | (신규·부자재 고유) | 봉투 template 12행·template_prices 충전 |
| 묶음수 variant | 굿즈 size→option | dbmap round-10 동형 |
| 색상 오염 정리 | 굿즈 자재 .09 오염·[[material-option-normalization]] | dbmap 자재축 트랙(가격엔진 밖) |
