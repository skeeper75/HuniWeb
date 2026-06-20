# engine-design-acrylic.md — 아크릴 면적매트릭스형 가격엔진 설계 (완제품)

> **핵심 설계가(hpe-engine-designer) 산출 — 아크릴 종단.** cartographer 지도(`formula-map-acrylic.md`)
> + benchmark 흡수(`absorption-candidates-acrylic.md`)를 종합해, 아크릴 **면적매트릭스형** 완제품의
> 가격공식 + 가격구성요소 + t_prc_* 단가행 그릇 + 상품↔공식 바인딩을 라이브 `evaluate_price`가
> 그대로 먹는 형태로 설계한다. **새 엔진 코드 아님 — t_prc_* 데이터 그릇/바인딩 설계.**
>
> 권위[HARD]: ① 상품마스터(260610) > ② 인쇄상품 가격표(260527) > ③ 라이브 t_prc_*(기준선) > ④ 역공학(후보).
> 산출자: hpe-engine-designer · 라이브 읽기전용 SELECT 실측 2026-06-20 · 단가값=가격표 verbatim(날조 0) · **DB 미적재**(실 적용 인간 승인 후 dbmap 위임·webadmin 코드 직접수정 금지).
> 디지털인쇄 GO 설계(`engine-design-digitalprint.md`)와 동일 컨벤션·동일 engine-contract.

---

## 0. 설계 요약 — 라이브 baseline 대비 무엇을 하나

라이브 실측(2026-06-20)이 cartographer 지도를 **거의 전부 확인**했다. 디지털인쇄와 달리 아크릴은 prc_typ/이중합산 동형결함이 **없고**(§7), 핵심 작업은 **바인딩(배선이 아니라 상품↔공식 연결)**이다.

| 라이브 실측 (2026-06-20·읽기전용) | 값 | 설계 함의 |
|----------------------------------|----|-----------|
| **COMP_ACRYL_CLEAR3T** prc_typ | `.02` 합가형·use_dims=`[siz_width,siz_height,mat_cd]`·165행·min_qty **전건 1** | min_qty=1이라 ÷1=단가형과 수학적 동일(§3 계약 확정·안전) |
| **COMP_ACRYL_COROTTO** prc_typ | `.01` 단가형·use_dims=`[siz_width,siz_height]`·21행·min_qty **전건 1** | 단가형(÷ 없음)·안전 |
| **COMP_ACRYL_MIRROR3T** prc_typ | `.01` 단가형·use_dims=`[siz_width,siz_height]`·52행·min_qty **전건 NULL** | .01이라 ÷min_qty 미발생·ValueError 위험 0 |
| **COMP_ACRYL_CARABINER** | **라이브 부재**(존재 안 함) | 신설 대기(G-A4) |
| **PRF_CLR_ACRYL** | use_yn=Y·COMP_ACRYL_CLEAR3T 1개 배선(disp_seq=1·addtn_yn=N) | 본체 공식·실재 |
| **PRF_COROTTO_ACRYL** | use_yn=Y·COMP_ACRYL_COROTTO 1개 배선 | 코롯토 공식·실재(배선됨) |
| **PRF_MIRROR_ACRYL / PRF_CARABINER_ACRYL** | **라이브 부재** | 신설 대기(G-A2/G-A4) |
| **t_prd_product_price_formulas 바인딩** | `PRD_000146(아크릴키링)→PRF_CLR_ACRYL` **1건뿐** | ★G-A1: 본체 활성 17상품 미바인딩=가격계산 불가 |

**∴ 아크릴 설계의 핵심 = "이미 충전·배선된 공식에 본체 상품을 바인딩"이다(G-A1).** 단가행은 238행 가격표 verbatim 풍부(값결손 0). 신규 mint는 미러 공식 1개·카라비너 comp/공식 1쌍(컨펌 후)뿐. search-before-mint 강하게 충족.

★ **골든값 라이브 재현 확인(2026-06-20)**: CLEAR3T 가로30×세로30 3T(MAT_000043)=**3,100** / 1.5T(MAT_000042)=**2,480**(=3,100×0.8). 가로50×세로30 3T=**3,800**. COROTTO 30×30=**3,600**. MIRROR 20×20=**5,000**. 전부 가격표 verbatim·라이브 단가행 직독.

---

## 1. 계산방식 2종 (calc-formula-draft 권위)

| 계산방식 | 정의 | 아크릴 상품군 | 엔진 처리(engine-contract) |
|----------|------|--------------|---------------------------|
| **면적매트릭스형** | 판매가 = 소재별 [세로mm 행][가로mm 열] 면적 룩업단가 (off-grid=각 축 '이하' 최소 임계 ceiling·`pricing.py:141-164`). 인쇄·레이저커팅·아크릴 소재가 단가에 통합 | 투명아크릴 본체 전 상품·미러아크릴 본체·아크릴코롯토 | comp 1개 매칭(면적 차원)·단가형 unit×qty·합가형(min_qty=1) ÷1×qty (P4) |
| **고정가형** | 판매가 = 형상별 고정 개당단가(외주비용·면적 무관) | 아크릴카라비너(4형상 고정가) | **엔진 동일** — comp 1개(`use_dims=[opt_cd]`)·단가형 unit×qty (C7) |

★ **핵심[HARD]**: 엔진은 `frm_typ_cd`를 참조하지 않는다(engine-contract C7·`pricing.py:8` "공식유형 frm_typ 폐기→공식은 항상 구성요소 합산"). "면적매트릭스형"·"고정가형"은 별 엔진 분기가 아니라 **comp 1개의 use_dims가 면적축(siz_width/siz_height)이냐 형상축(opt_cd)이냐의 차이**일 뿐. 설계는 둘을 똑같이 `formula_components` 1배선으로 표현한다. (디지털인쇄 설계 §1 동형 — frm_typ 미참조 계약 동일.)

---

## 2. 면적매트릭스 엔진 계약 — evaluate_price가 어떻게 먹나 [HARD]

### 2-1. 매트릭스 룩업 메커니즘 (라이브 `pricing.py` 검증)

본체 면적 단가는 `COMP_ACRYL_CLEAR3T` 한 comp이 **3 차원**(siz_width·siz_height·mat_cd)으로 단가행을 매칭한다. 엔진 처리(`pricing.py:78-174`):

1. **비수량 차원 정확매칭**(`NON_QTY_DIMS`·`pricing.py:38-39`): `mat_cd`가 여기 포함 → 선택한 두께(MAT_000043 3T / MAT_000042 1.5T)와 **정확히** 같은 mat_cd 단가행만 후보(combo_key 그룹핑). 두께 분기는 별 comp가 아니라 **같은 comp의 mat_cd 정확매칭**으로 1행 선택.
2. **구간(티어) 차원 ceiling**(`TIER_DIMS`·`TIER_UPPER`·`pricing.py:41-46·141-164`): `siz_width`·`siz_height`는 **'이하' 상한 방향**(`TIER_UPPER`). 각 축 독립으로 "주문값 ≤ 임계 중 최소 임계"(=한 단계 큰 격자) 선택. off-grid(예 가로35×세로35) → width 축 ceiling 40·height 축 ceiling 40 → 40×40 셀 단가. 주문값 > 최대(200) → `ERR_ABOVE_MAX`.
3. **단가행 1행 확정** 후 `component_subtotal`(`pricing.py:177-192`)로 소계 산출(§3).

★ **두께=mat_cd 직교 [HARD]**: 두께를 면적축에 섞거나 별 comp로 분리 금지. 라이브가 이미 1 comp + mat_cd 정확매칭으로 3T/1.5T를 분기(MAT_000043 113행 + MAT_000042 52행 = 165행). benchmark C-A1(두께=자재 차원·별 두께축 신설 부결) 정합·RedPrinting WGT 슬롯 발상과 동형.

### 2-2. ★W=가로(앞)·H=세로(뒤) — 가격축 권위 = siz_nm WxH (work사이즈 절대 금물) [HARD·돈크리티컬]

dbmap round-23 돈크리티컬 확정·라이브 실측 재확인:

- **아크릴 면적축 권위 = `siz_width`=가로(앞)·`siz_height`=세로(뒤)** = 가격표 매트릭스 헤더([세로행]×[가로열]). 라이브 비대칭쌍 실측: **가로50×세로30 = 3,800**(`siz_width=50,siz_height=30`). 만약 축이 뒤바뀌면 가로30×세로50을 룩업해 틀린 단가.
- **★work_width/height(작업사이즈) 절대 금물** — 아크릴 work=작업사이즈(블리드/여백 가산: siz_nm "50x50"→work 60x60). work 기준 룩업하면 주문자가 "30×30"을 골라도 가격표 40×40 구간을 룩업해 **틀린(비싼) 단가**. (포스터는 우연히 work==매트릭스 축이라 안전했으나 아크릴은 다름.)
- **라이브 실측 확정**: CLEAR3T/COROTTO/MIRROR 단가행 전건 `siz_cd=NULL·siz_width/siz_height NOT NULL`(WH 전환 COMMIT 완료·work 미사용). **설계는 이 상태를 유지**(신규 좌표 INSERT 시도 절대 work 기준 금지·가격축=siz_nm WxH).

### 2-3. off-grid ceiling = 엔진 내장 (단가행에 ceiling 행 안 만듦)

각 축 '이하' 최소 임계 ceiling은 `pricing.py:158-162`가 런타임 처리. 단가행에 보간/ceiling 행을 만들지 않는다([[dbmap-compute-in-app-db-stores-lookup]]·benchmark C-A2 "면적함수 부결·매트릭스+ceiling"). 미적재 좌표(~58 CLEAR3T·8 MIRROR)는 ceiling으로 흡수(다음 큰 격자 단가)되거나 가격표 좌표 채번(dbmap import 트랙·여기선 가격축 신규 아님).

---

## 3. ★min_qty 엔진 계약 확정 (cartographer↔benchmark 긴장 해소) [HARD·돈크리티컬]

### 3-1. 긴장과 라이브 증거

- **cartographer**: "min_qty 전건 1→÷1=단가형 동일·안전".
- **benchmark**: "개당×수량인지 총액인지 미확정·디지털 ×qty 동일 클래스 위험(추측 적재 금지)".

라이브 직접 실측(2026-06-20) + 코드 검증(`pricing.py:177-192`)으로 **확정**:

| 증거 | 값 | 출처 |
|------|----|------|
| CLEAR3T prc_typ / min_qty | `.02 합가형` / **min_qty 전건 1**(distinct=1) | 라이브 `t_prc_component_prices` SELECT |
| COROTTO prc_typ / min_qty | `.01 단가형` / **min_qty 전건 1** | 라이브 SELECT |
| MIRROR prc_typ / min_qty | `.01 단가형` / **min_qty 전건 NULL** | 라이브 SELECT |
| `component_subtotal` 계약 | `.02`: `per_item = unit_price ÷ tier_min_qty`, `× qty`. `tier_min_qty <= 0`(NULL) → **ValueError**. `.01`: `unit_price × qty` | `pricing.py:185-192` |

### 3-2. 확정 결론 — **면적단가 = 개당가·subtotal = (unit ÷ min_qty) × qty·min_qty=1이면 개당×수량**

> **결론[HARD]: 아크릴 면적단가는 "개당 완제품가"이고, ×qty 과청구 위험은 없다.**

근거(반증불가):
1. **CLEAR3T `.02` + min_qty=1**: `component_subtotal`이 `per_item = unit ÷ 1 = unit`, `subtotal = unit × qty`. 즉 **단가형(`.01`)과 수학적으로 완전 동일**. 키링 가로30×세로30 3T 100개 = `3,100 ÷ 1 × 100 = 310,000`(정상·개당 3,100×100). **묶음 총액이 아니라 개당가**(가격표 매트릭스 셀이 "그 사이즈 1개당 완제품가"이기 때문).
2. **디지털 ×qty 결함과 다른 이유**: 디지털 결함(명함 3500→350,000)은 단가가 **"100매 1세트 총액"인데 min_qty=100·prc_typ=.01이라 ×100 폭발**한 것. 아크릴은 단가가 **개당가**이고 min_qty=1이라 ÷1 후 ×qty가 곧 정답. **단가 의미(개당 vs 묶음총액)가 디지털과 정반대** → ×qty 위험 없음.
3. **COROTTO/MIRROR `.01`**: ÷min_qty 자체가 발생 안 함(`pricing.py:191-192` 단가형 분기) → ValueError·환산오류 0.

**∴ 면적단가=개당가, subtotal=(unit÷min_qty)×qty이고 min_qty=1이므로 곧 개당×수량. ×qty 폭발 위험은 아크릴에 없다.** (benchmark가 경계한 "디지털 ×qty 동일 클래스 위험"은 라이브 단가 의미 확정으로 해소 — 디지털은 묶음총액·아크릴은 개당가.)

### 3-3. ★신규 면적행 INSERT 가드 [HARD] — .02 comp min_qty=1 명시 필수

`COMP_ACRYL_CLEAR3T`는 `.02`(합가형)다. 향후 미적재 좌표(~58 CLEAR3T)나 8T 매트릭스를 INSERT할 때:

- **min_qty를 NULL로 두면 `tier_min_qty=NULL`→`base<=0`→ValueError("합가형 단가행에 수량구간 없어 장당가 환산 불가")로 견적 불가**(`pricing.py:187-188`). 디지털 박 SETUP `.02`+NULL이 ValueError 낸 것과 동형.
- **∴ 신규 CLEAR3T 면적행은 전건 `min_qty=1` 명시**(NULL 금지·가격 불변·dbmap B1 가드). 다른 .02 면적 comp(향후 미러를 .02로 바꾸면 동일) 동일 가드.
- COROTTO/MIRROR(`.01`)는 min_qty 자유(÷ 미발생). 단 일관성 위해 신규 행은 min_qty=1 권장.

★ **prc_typ .02 시맨틱 잔류(LOW)**: CLEAR3T가 `.02`인데 min_qty=1이라 결과는 단가형과 동일(가격 무영향·dbmap Q-ACR-7 RESOLVED). `.01`로 정정할지 `.02` 유지할지는 개발자 시맨틱 컨펌(가격 무관·design-decisions Q-ACR-CTR1). **설계는 라이브 .02 유지**(가격 정확·가드만 명시).

---

## 4. ★G-A1 본체 29(활성 17)상품 미바인딩 해소 (최우선·가격계산 불가 직결)

### 4-1. 라이브 바인딩 실상 (2026-06-20)

`t_prd_product_price_formulas`에 **`PRD_000146(아크릴키링)→PRF_CLR_ACRYL` 1건뿐**. 본체 아크릴 상품(146~170 영역 활성 18 중 1만 바인딩) → **활성 17상품 evaluate_price source=NONE·가격계산 불가**.

### 4-2. 바인딩 명세 (product_price_formulas) — search-before-mint(기존 공식 재사용)

투명 본체 전 상품은 **PRF_CLR_ACRYL 재사용**(소재=mat_cd 차원으로 흡수·신규 공식 0). 본체 BOM이 MAT_000043(투명3T)임을 라이브 확인(146/147/148 전건). **두께(3T/1.5T)는 상품이 아니라 견적 시 mat_cd 옵션 선택으로 분기**(공식은 한 개).

| 바인딩 (신규 INSERT into t_prd_product_price_formulas) | 공식 | 근거·상태 |
|------------------------------------------------------|------|-----------|
| **PRD_000146 아크릴키링** | PRF_CLR_ACRYL | 라이브 실재(baseline·유지) |
| **PRD_000147 아크릴마그넷** | PRF_CLR_ACRYL | 활성·BOM MAT_000043·투명본체 |
| **PRD_000148 아크릴뱃지** | PRF_CLR_ACRYL | 활성·BOM MAT_000043·투명본체 |
| **PRD_000149 아크릴집게** | PRF_CLR_ACRYL | 활성·투명본체 |
| **PRD_000150 아크릴스마트톡** | PRF_CLR_ACRYL | 활성·투명본체 |
| **PRD_000152 아크릴명찰** | PRF_CLR_ACRYL | 활성·투명본체 |
| **PRD_000154 아크릴 머리끈** | PRF_CLR_ACRYL | 활성·투명본체 |
| **PRD_000155 아크릴볼펜** | PRF_CLR_ACRYL | 활성·투명본체 |
| **PRD_000157 아크릴네임택** | PRF_CLR_ACRYL | 활성·투명본체 |
| **PRD_000158 아크릴 포카키링** | PRF_CLR_ACRYL | 활성·투명본체 |
| **PRD_000160 아크릴자유형스탠드** | PRF_CLR_ACRYL | 활성·투명본체 |
| **PRD_000161 판아크릴** | PRF_CLR_ACRYL | 활성·투명본체 |
| **PRD_000162 아크릴포카스탠드** | PRF_CLR_ACRYL | 활성·투명본체 |
| **PRD_000163 아크릴미니파츠** | PRF_CLR_ACRYL | 활성·투명본체 |
| **PRD_000169 아크릴입체블럭** | PRF_CLR_ACRYL | 활성·입체여도 단일 면적매트릭스(§set P-4c) |
| **PRD_000170 아크릴쉐이커★** | PRF_CLR_ACRYL | 활성·입체여도 단일 면적매트릭스 |
| **PRD_000168 아크릴입체코롯토** | **PRF_COROTTO_ACRYL** | 활성·코롯토 면적매트릭스(§5·정체 컨펌 Q-ACR-CO1) |

**활성 미바인딩 17 = 위 16(투명본체)+1(코롯토 168)** → 전건 바인딩 명세. 비활성(use_yn=N) 상품(153 골드실버명찰·156 지비츠·159 코스터·164 코롯토·165 포카코롯토·166 카라비너·226 쉐이커코롯토)은 활성화 시 동일 패턴 바인딩(보류·컨펌큐).

### 4-3. 바인딩 유효성 가드 (U-7 binding-validity 계승)

- **PRF_CLR_ACRYL에 바인딩되는 상품은 견적 시 mat_cd(MAT_000043/042) 선택을 반드시 제공**해야 CLEAR3T 단가행이 매칭됨(mat_cd는 NON_QTY_DIMS 정확매칭). mat_cd 미선택 시 단가행 후보 0→`no_match`(0원 침묵 위험) → CPQ 소재옵션(§6·G-A5) 또는 상품 디폴트 mat_cd 필수. **컨펌큐 Q-ACR-MAT1**: 두께 선택 옵션 UI 연결(option_items→mat_cd 주입).
- **시트 차원경계(SOT 1) 안에서만 배선** — PRF_CLR_ACRYL에 디지털인쇄 comp(인쇄비/용지비 등) 침입 금지. 아크릴 본체는 면적 1 comp만(인쇄+커팅+소재 통합단가)이 맞음(addtn_yn=N·후가공만 §6에서 addtn_yn=Y 별 comp).

---

## 5. 미러 / 코롯토 / 카라비너 처리

### 5-A. 코롯토 (G-A3) — 공식·배선 실재·바인딩만 명세

- **라이브**: `PRF_COROTTO_ACRYL`(use_yn=Y) ← `COMP_ACRYL_COROTTO`(.01·21행·골든 30×30=3,600) 배선 실재. **바인딩만 0**.
- **설계**: 코롯토 상품을 PRF_COROTTO_ACRYL에 바인딩. **활성 PRD_000168(아크릴입체코롯토) 우선 바인딩**(§4-2에 포함). 비활성 164/165/226은 활성화 시.
- **정체 컨펌 Q-ACR-CO1**: 입체코롯토(168)·포카코롯토(165)·쉐이커코롯토(226)가 **모두 같은 B06 면적매트릭스**인가? 가격표 B06이 단일 코롯토 매트릭스라 동형 가정. 단 입체/포카/쉐이커가 다른 단가체계면 별 comp 필요(현재 라이브 단가행 1체계뿐 → 동형으로 설계·실무 컨펌큐).
- **G-A7 권위 충돌(LOW)**: calc-draft는 코롯토를 `[고정가형]`이라 했으나 가격표 B06·라이브 use_dims=[siz_width,siz_height]는 **면적매트릭스**. 가격표·라이브 권위로 **면적매트릭스 채택**(calc-draft 라벨 우선순위 하).

### 5-B. 미러 (G-A2) — 단가행 실재·공식 신설·바인딩 BLOCKED

- **라이브**: `COMP_ACRYL_MIRROR3T`(.01·52행·use_dims=[siz_width,siz_height]·min_qty NULL·골든 20×20=5,000·셀 formula `=투명3T×2`) **단가행만 실재**. 공식 0·배선 0·바인딩 0 = 가격사슬 단절.
- **설계(확정 가능분)**: **PRF_MIRROR_ACRYL 신설 + MIRROR3T 1배선**(disp_seq=1·addtn_yn=N). PRF_CLR_ACRYL 동형 구조(comp만 MIRROR3T). search-before-mint: MIRROR3T comp는 실재(재사용)·신규는 공식 1개뿐.
- **★바인딩 대상 상품 불명 = BLOCKED(컨펌큐 Q-ACR-MIR1)**: **라이브에 미러아크릴 본체 상품 0개**(상품 BOM 전수에 미러 소재 상품 부재·미러아크릴스티커 142/143은 별 poster-sign 트랙). 미러는 **본체 소재옵션(투명/미러 택1)** 가능성이 높음(benchmark C-A1/C-A7) → 그러면 PRF_MIRROR_ACRYL 별 공식이 아니라 **PRF_CLR_ACRYL에 소재 택1 CPQ + 두 comp(CLEAR3T/MIRROR3T) 배선**이 정답일 수 있음.
  - ★**그 경우 소재 판별차원(mat_cd) 필수 [HARD]** — CLEAR3T(mat_cd 차원 보유)·MIRROR3T(mat_cd 차원 **없음**·단가행 mat_cd NULL)를 한 공식에 배선하면 **silent 이중합산**(둘 다 와일드카드 통과·디지털 V-DGP-1 동형) 위험. 미러를 한 공식에 합치려면 MIRROR3T에도 소재 판별차원(예 mat_cd=미러 자재코드) 충전 + use_dims 등재 선행.
  - **∴ 미러는 "공식 신설은 설계 확정, 배선/바인딩 방식(별 공식 vs 소재옵션 합류)은 컨펌 대기"**. 별 공식 단독 신설(상품 없는 orphan 공식)은 무의미 → 소재옵션 도입(G-A5) 결정과 묶어 진행. dbmap Q-ACR-9·dbm-price-arbiter 라우팅.

### 5-C. 카라비너 (G-A4) — comp/공식 전무·형상 opt_cd 미채번·고정가형 (확정 가능·LOW)

- **라이브**: COMP_ACRYL_CARABINER **부재**(존재 안 함)·PRF_CARABINER_ACRYL 부재·PRD_000166 비활성(use_yn=N)·BOM MAT_000043(형상 opt_cd 없음).
- **계산방식 = 고정가형**(외주비용·면적 아님·calc-draft 행116·가격표 B07). 형상 4종 고정가: 사각자물쇠40×69=**5,800**·하트A 43×71=**5,800**·하트B 59×54=**6,300**·원형B 68×70=**6,900**(치수=명칭설명·가격축 아님).
- **설계(확정 가능분·2중 mint)**:
  1. **COMP_ACRYL_CARABINER 신설** — comp_typ=`.06 완제품비`·prc_typ=`.01 단가형`·use_dims=`[opt_cd]`(형상). (★면적 아님 — siz_width/siz_height 절대 금지·형상을 siz_cd로 오해하면 오모델·benchmark C-A6 가드.)
  2. **형상 4 opt_cd 채번**(OPV_NNNNNN·MAX+1·separator `_`) — 사각자물쇠/하트A/하트B/원형B.
  3. **단가행 4 INSERT** — B07 verbatim(5,800/5,800/6,300/6,900·use_dims=[opt_cd]·min_qty=1 권장).
  4. **PRF_CARABINER_ACRYL 신설 + COMP_ACRYL_CARABINER 1배선**(disp_seq=1·addtn_yn=N).
  5. **PRD_000166 바인딩** → PRF_CARABINER_ACRYL.
- **우선순위 LOW**: PRD_000166 비활성. 활성화 시 위 5단계 일괄. 형상 opt_cd 채번값은 채번 트랙 위임([[dbmap-code-identifier-strategy]]·MAX+1).

---

## 6. CPQ 옵션 (G-A5) · 후가공 합산

본체 면적 단가와 직교하는 옵션/후가공(상품마스터 `조각수(옵션)`·`가공(옵션)`·`추가상품(옵션)`·가격표 B05). **라이브 CPQ 옵션 전무**(round-7 횡단 발견 — option_items 전역 미적재).

| 항목 | 가격 처리 | 선택 처리 | 그릇 |
|------|----------|----------|------|
| **두께(3T/1.5T)** | 면적 본체 comp의 **mat_cd 차원**(별 가산 아님·매트릭스가 두께별 다른 단가) | 소재/두께 택1 옵션 → mat_cd 주입 | option_group(택1)→option_items→ref_dim_cd=mat_cd (round-6) |
| **후가공(고리/자석/바디·핀)** | B05 추가단가 comp `COMP_ACRYL_FINISH`(신설·`use_dims=[opt_cd]`·**addtn_yn=Y** 합산) | 가공 택1/택N 옵션 + 자재(금속링)+공정(조립) BUNDLE | 후가공 comp + round-6 CPQ option BUNDLE([[dbmap-option-material-process-bundle]]) |
| **조각수(옵션)** | (가격축 여부 컨펌·상품마스터 옵션 칸) | 택1/수량 | round-6 CPQ |
| **소재선택(투명/미러)** | 미러=별 단가체계(MIRROR3T) → §5-B 소재 판별차원 필수 | 소재 택1 | round-6 CPQ + 판별차원 가드 |

- **후가공 가산 = 개당 1회 vs ×수량 [HARD·돈크리티컬]**: B05 고리(1,100 등)가 **개당 1회 가산**인지 ×수량인지 = 디지털 후가공 prc_typ .01 ×수량 과청구와 동일 클래스. COMP_ACRYL_FINISH prc_typ를 단가행 의미(개당가)에 맞게 설계 — **개당 가산이면 .01·use_dims=[opt_cd]·min_qty=1**(unit×qty=개당×수량·각 개에 고리 1개). 묶음총액이면 .02+min_qty. **추측 적재 금지·실무 컨펌 Q-ACR-FIN1** + dbm-price-arbiter 심의. (현재 라이브 COMP_ACRYL_FINISH 부재 → 신설 시 가드.)
- **소재→후가공 disable 제약(benchmark C-A5)**: round-6 CPQ constraints(JSONLogic)로 "불투명→화이트 불가" 등 — data-gap(기존 그릇)·가격 정합 가드. 가격축 신규 아님.
- **부자재 카탈로그 공유(benchmark C-A4)**: 고리/자석/핀을 굿즈/스티커 횡단 단일 부자재 마스터 — dbmap round-22 자재축/basecode 거버넌스 입력(여기선 설계 권고).

---

## 7. 수량할인 적용 순서 [HARD·엔진 계약]

benchmark: 아크릴은 면적단가×수량 **후** t_dsc 구간할인(B04 6구간 0~50%). 디지털 합산형과 적용 순서가 다르지 않음 — **엔진이 단일 순서로 처리**(`pricing.py:24·471-536`):

```
① comp subtotal Σ  (면적 본체 + 후가공 addtn_yn — 공식의 모든 구성요소 합)
② 수량구간 할인     (_quantity_discount: prd_cd 연결 t_dsc 디테일·min_qty≤qty≤max_qty·정률/정액)
③ 등급 할인         (_grade_discount: 주카테고리·등급별·선택적)
   → ②③ 순차 곱(sequential)·final_price
```

- **아크릴 본체**: ① = CLEAR3T subtotal(개당가×수량) → ② B04 수량구간할인(0~50%) → ③ 등급할인. **할인은 항목별이 아니라 합계(amount)에 단계 적용**(`apply_discount(amount,...)`). 디지털 원자합산형과 동일 엔진 경로 — 별도 분기 없음.
- **B08 카라비너 구간할인 3구간**: 카라비너 고정가 subtotal에 동일 ②단계 적용(prd_cd 연결 t_dsc). 면적 본체와 같은 순서.
- **설계 함의**: 할인 데이터(t_dsc B04/B08)는 dbmap round-1(구간할인 매핑·GO·미적재) 트랙. 본 설계는 **할인 적용 순서가 엔진에 이미 단일 경로로 내장**됨을 명시(별 설계 불요)·바인딩 시 prd_cd↔t_dsc 연결 유효성만 확인(컨펌큐 Q-ACR-DSC1).

---

## 8. evaluate_price 계약 정합 체크 (설계 자기검증)

| 계약(engine-contract·pricing.py) | 설계 준수 |
|----------------------------------|-----------|
| C7 frm_typ 미참조·공식=합산 | ✅ 면적매트릭스/고정가 모두 comp 1배선 합산형으로 표현(frm_typ 무참조) |
| P3-8 ERR_AMBIGUOUS 금지(한 comp 단가행 사이) | ✅ 본체 mat_cd+면적 정확매칭 1행·COROTTO/MIRROR 면적 1행·카라비너 opt_cd 1행. 미러 합류 시 mat_cd 판별차원 필수(§5-B 가드) |
| P3-DEF 판별차원 없음 금지 / silent 이중합산 | ✅ 공식당 comp 1개(addtn_yn=N) → 구조적 이중합산 불가. ★미러 소재옵션 합류 시에만 두 comp → mat_cd 판별차원 충전 선결(§5-B) |
| P4-1 단가형 ×qty / P4-3 합가형 min_qty 필수 | ✅ CLEAR3T .02+min_qty=1(÷1=개당가)·COROTTO/MIRROR .01·카라비너 .01. ★신규 .02 면적행 INSERT 시 min_qty=1 명시 가드(§3-3·NULL→ValueError) |
| TIER_UPPER siz_width/height '이하' ceiling | ✅ off-grid=각 축 ceiling(엔진 내장)·단가행 ceiling 행 안 만듦(§2-3) |
| U-7 시트 차원경계(SOT 1) | ✅ PRF_CLR_ACRYL=면적 본체 1 comp(디지털 인쇄/용지 comp 침입 금지)·후가공만 addtn_yn=Y 별 comp(§6) |
| 할인 적용 순서 | ✅ ① comp Σ → ② 수량구간 → ③ 등급(엔진 단일 경로·§7) |
| search-before-mint | ✅ 신규 = 미러 공식 1(컨펌 후)·카라비너 comp/공식 1쌍+형상 opt_cd(컨펌 후)·후가공 COMP_ACRYL_FINISH 1(컨펌 후). 본체 17상품은 **바인딩만**(공식/comp 재사용·신규 0) |

---

## 9. designer 큐 잔여 (set-product·design-decisions로 이관)

- **G-A1 본체 17상품 바인딩**(§4) = 1순위 실행(가격계산 불가 직결)·신규 mint 0·dbmap 위임.
- **미러 소재옵션 vs 별 공식**(§5-B) → 컨펌큐 Q-ACR-MIR1(소재 판별차원 가드 묶음)·dbm-price-arbiter.
- **카라비너 채번·신설**(§5-C) → PRD 활성화 시·형상 opt_cd 채번 트랙.
- **후가공 가산 개당/×수량 의미**(§6) → 컨펌큐 Q-ACR-FIN1·dbm-price-arbiter.
- **prc_typ .02 시맨틱 정정 여부**(§3-3) → 개발자 컨펌(가격 무관·LOW).
- **세트/입체 합성**(입체블럭·쉐이커=단일 면적매트릭스·세트조합 아님) → set-product-design.md 아크릴 절.
