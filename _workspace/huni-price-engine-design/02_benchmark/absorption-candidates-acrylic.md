# 후니 흡수 후보 — 아크릴 가격계산 (면적매트릭스형 종단)

> `hpe-benchmark-analyst` 산출 — 디지털인쇄(파일럿)에 이어 **면적매트릭스형 대표 아크릴** 종단.
> **목적[HARD]**: 와우프레스·레드프린팅이 아크릴 상품(키링·스탠드·블럭·코롯토·미러·등신대·명찰)의 가격을
> *어떻게 계산하는가*(면적·두께·후가공·수량 처리)를 역공학해 후니 아크릴 면적매트릭스 설계에 흡수할 메커니즘을 추출.
> **흡수 vs 답습[HARD]**: 메커니즘·표현력만 흡수, naming/codes(`acrylic2025_price`·`MTRL_CD` 등) 후니 유입 금지,
> 권위 엑셀(상품마스터260610·가격표260527) 덮어쓰기 금지. 후니가 이미 담으면 흡수 불요(overfit 경계).

## 출처 표기

- `[red:AC-reverse]` = `_workspace/huni-rpmeta/categories/AC/reverse.md`(2026-06-17 rpm 역공학·ACNTHAP/ACTHDKY/ACPDSTD 풀 infoCall 실측 + 17상품 catalog 횡단).
- `[red:cascade]` = `raw/widget_monitor/cascade_captures/ACNTHAP_{cascade,constraints}.json`(2026-04-07 라이브 인터셉트·disable 3건·size 2 프리셋 실측).
- `[red:catalog]` = `raw/widget_monitor/redprinting_catalog.json`(AC 20상품 전수 — 키링9·코롯토4·부착물5·명찰1·템플릿1).
- `[huni:acryl]` = `_workspace/huni-dbmap/31_acrylic-price-link/{acrylic-chain-design,confirms-and-gaps}.md`(후니 아크릴 가격표 260527 `아크릴` 시트 8블록·라이브 t_prc_* 실측·권위).
- `[wow:probe]` = WowPress 라이브 읽기전용 카테고리 조회(2026-06-20·아크릴보드/아크릴톡 실재 확인·옵션 상세 미캡처).
- `unobserved` = 미관측(날조 금지).

---

## 0. 경쟁사 아크릴 면적 가격화 방식 — 한눈 요약

| 항목 | 레드프린팅(RedPrinting) | 와우프레스(WowPress) | 후니 `t_prc_*` 대응 |
|------|------------------------|----------------------|---------------------|
| 아크릴 가격엔진 | **`acrylic2025_price`(아크릴 전용 엔진)** = 면적·두께·소재 산정 `[red:AC-reverse §0.6]` | 굿즈/폰액세서리 카테고리에 아크릴 실재(아크릴보드/아크릴톡)나 **옵션·가격 미캡처** `[wow:probe]` | `PRF_CLR_ACRYL`(투명아크릴 공식·라이브 실재) `[huni:acryl]` |
| 면적 가격화 | 자유사이즈(MIN/MAX 범위·키링 20×20~90×90·등신대 10×10~300×250) → 면적 산정 `[red:AC-reverse §2·§3]` | unobserved | **면적매트릭스형**(`component_prices` `use_dims=[siz_cd]` 또는 가로/세로 구간) `[huni:acryl B01~B03]` |
| 두께(2T/3T/5T) | **자재 MTRL_CD의 WGT_CD 슬롯에 인코딩**(D01=3T·D02=5T·L01~04 라미) — 별 두께축 아님 `[red:AC-reverse §0.1]` | unobserved | **`mat_cd` 차원**(투명3T/1.5T를 1 comp의 mat_cd 분기로 통합·라이브 실증) `[huni:acryl §0]` |
| 후가공(고리/받침/완칼/화이트) | `SUB_MTR`/`WRK_MTR` 부자재+공정 BUNDLE(고리 80+·받침 12)·완칼=`LAS_DFT`/FRXXX·화이트=`PRT_WHT` `[red:AC-reverse §0.4·§0.5]` | unobserved | 후가공 추가단가 comp(B05 11그룹·고리없음0/은색고리1100/금색고리1200…) `[huni:acryl B05]` |
| 수량 처리 | 키링 `prn_cnt` widget select(1~10)·이중수량(디자인수 ordCnt × 수량 printCnt) `[red:AC-reverse §2]` | unobserved | 아크릴 수량별 구간할인 6구간 0~50%(B04·t_dsc) `[huni:acryl B04]` |
| 카라비너(접합 완제) | unobserved(RP 카라비너 부재·키링 고리로 대체) | unobserved | **고정가형**(B07 4형상 자물쇠5800/하트6300/원형6900·면적 아님) `[huni:acryl B07]` |
| 코롯토(입체 블록) | `acrylic2025`/코롯토 상품군(DCO 두께블록·FCO 입체·BCO 양면) `[red:AC-reverse §0.3]` | unobserved | **면적매트릭스형**(B06 6×6·30~80mm·3600~8400) `[huni:acryl B06]` |

**한 줄 결론**: 레드프린팅은 아크릴을 **전용 가격엔진(`acrylic2025_price`)으로 분기**해 *면적(자유사이즈) × 두께(자재 WGT) × 소재(자재 PTT) × 부자재(고리/받침) 합산*으로 계산한다. 이 골격은 후니 아크릴 가격표(260527·면적매트릭스형 B01~B03·B06 + 고정가형 B07 + 후가공가산 B05 + 수량구간 B04)와 **동형**이며, 후니 4단 엔진(`PRF_CLR_ACRYL` 면적매트릭스 + 후가공 comp 합산 + t_dsc 수량구간)이 이미 담는다. WowPress는 아크릴 옵션·가격을 캡처하지 못해 면적 가격화 방식 **미관측**(보강 불가). 흡수할 실질은 **두께=자재차원 인코딩 확정**·**부자재 카탈로그 공유**·**제약 레이어**이며, 새 가격축(테이블) 신설은 0건.

---

## 1. 흡수 후보 요약 보드 (C-A1~C-A7)

| ID | 흡수 후보 | 출처 | 후니 그릇 | 사다리 | 우선순위 | overfit 위험 | 답습 리스크 |
|----|----------|------|----------|--------|---------|------------|------------|
| **C-A1** | 두께(3T/5T/8T) = 자재 `mat_cd` 차원 인코딩 (별 두께축 신설 금지) | 레드 WGT_CD 슬롯·후니 라이브 mat_cd 통합 | `component_prices.use_dims=[siz_cd,mat_cd]` | 차원(이미 존재) | **High** | **낮음(이미 동형)** | 낮음 |
| **C-A2** | 면적 자유사이즈 → 면적매트릭스 ceiling 룩업 | 레드 자유사이즈(MIN/MAX)·후니 B01~B03 매트릭스 | 면적매트릭스 comp(가로/세로 구간 + ceiling) | 데이터(이미 존재) | **High** | 낮음(메모리 정합) | 낮음 |
| **C-A3** | 아크릴 전용 가격엔진 분기 명시 (형태별 frm_cd) | 레드 `acrylic2025_price`·`vTmpl`·`tmpl` 3엔진 | `frm_cd` 바인딩(면적매트릭스/고정가/완제템플릿) | 코드행(이미 존재) | Medium | 중(엔진 과분화 경계) | 중(naming 가드) |
| **C-A4** | 부자재 카탈로그 공유 (고리/받침/자석/핀 횡단 BUNDLE) | 레드 SUB_MTR_KR/CN/CR(ST/GS 코드 공유)·후니 B05 후가공 | 후가공 comp + round-6 CPQ option BUNDLE | 데이터/제약 | **Medium** | 중(자재vs공정 분리 주의) | 낮음 |
| **C-A5** | 소재→후가공/인쇄 disable 제약 (불투명→화이트 불가 등) | 레드 `pdt_disable_pcs_info`(명찰 PET→코팅/미싱/부분UV 3건) | round-6 CPQ constraints(JSONLogic) | JSONLogic 제약행 | Medium | 낮음(제약 패턴) | 낮음 |
| **C-A6** | 완제 고정가형 (카라비너·형상별 고정단가, 면적 아님) | 후니 B07 4형상 고정가·레드 코롯토/접합 완제 | 고정가 comp(`.06 완제품비`·`use_dims=[opt_cd]`) | 코드행(이미 존재) | Low | 낮음(가격표 권위) | 낮음 |
| **C-A7** | 라미네이션=두께 합성 가공방식 (3T→2T+1T·홀로그램 합지) | 레드 `production_method`(MTG_DFT/MTG_LAM)·GRP_OPTION_CD | 자재 enum(라미 자재 별 mat_cd) or 공정 comp | 차원/공정 | Low | **중(자재 그룹핑 슬롯 신설 경계)** | 중 |

**신규 테이블(vessel) 신설 = 0건.** 전부 기존 후니 그릇(면적매트릭스 comp·`mat_cd`/`siz_cd` 차원·고정가 comp·후가공 comp·round-6 CPQ 제약/옵션)으로 닫힌다. rpmeta AC 판정(두께·소재·입체 전부 facet·distinct #19 부결)과 정합.

---

## C-A1. 두께(3T/5T/8T) = 자재 `mat_cd` 차원 인코딩 ★ (우선순위 High·흡수 강·이미 동형)

### 흡수 메커니즘
레드프린팅은 두께를 **별 옵션 슬롯이 아니라 자재 MTRL_CD의 WGT_CD 슬롯**에 인코딩한다 — ACTHDKY 키링 6 자재행: PXAATD01(3T투명·WGT=D01)·PXAATD02(5T투명·WGT=D02)·PXAATL01~04(라미). widget select `material`에 "아크릴_3T 투명/아크릴_5T 투명"으로 노출 `[red:AC-reverse §0.1]`. 즉 두께는 **자재의 한 차원**(평량 WGT 슬롯 재활용)이지 1급 가격축이 아니다.

### 후니 매핑 (이미 동형 — 라이브 실증)
후니 라이브가 **정확히 같은 발상**: round-16엔 CLEAR3T(.01)·CLEAR15T 별 comp였으나, 라이브 재실측(`[huni:acryl §0]`)에서 **투명3T·1.5T를 한 comp(`COMP_ACRYL_CLEAR3T`)의 `mat_cd` 차원으로 통합**(prc_typ .02·use_dims `[siz_cd,mat_cd,min_qty]`·MAT_000043 3T 47행 + MAT_000042 1.5T 37행). 두께 = `mat_cd` 분기. 이게 더 정합적(투명아크릴 공통 면적공식 + mat_cd로 두께 분기).

### 사다리 판정 (search-before-mint)
**신규 축/테이블 불요·흡수 후 즉시 적용 가능.** 두께를 별 차원(`thk_cd` 등)으로 신설하면 overfit — 후니가 이미 `mat_cd`로 두께를 담고 RedPrinting도 자재 WGT facet으로 본다. **흡수 = "두께는 자재 차원이다"를 설계 원칙으로 못박는 것**(미러 등 후속 소재 신설 시 두께를 자재로 일관 인코딩).

### trade-off
- 장점: 면적공식 1개 + mat_cd로 두께 분기 → 공식 폭발 방지(투명 한 공식이 3T/1.5T/8T 커버). RedPrinting도 동형.
- 단점: 8T(MAT_000044)는 마스터엔 있으나 **가격표 본체에 8T 단가매트릭스 부재**(`[huni:acryl Q-ACR-10]`) — 두께를 mat_cd로 담아도 **단가행이 없으면 견적 불가**(data-gap·자재 신설이 아니라 단가 확보 문제). 평량(종이 g)과 두께(아크릴 mm)가 같은 `mat_cd`/WGT 슬롯을 의미 다르게 쓰는 "다의 슬롯"은 자재모델 문서화 필요(GS 텀블러 용량과 동류).

### naming 유입 가드 [HARD]
RedPrinting `WGT_CD`(D01/D02)·`MTRL_CD`(PXAATD01) 후니 유입 금지. 후니 `mat_cd`(MAT_000043 등)로 번역.

---

## C-A2. 면적 자유사이즈 → 면적매트릭스 ceiling 룩업 ★ (우선순위 High·흡수 강)

### 흡수 메커니즘
레드프린팅 아크릴은 **자유사이즈 입력**(키링 MIN 20×20~MAX 90×90·등신대 MIN 10×10~MAX 300×250 `[red:AC-reverse §2·§3]`)을 `acrylic2025_price`가 면적으로 환산해 가격을 낸다(off-grid 사이즈도 산정). 자유사이즈 + 면적 함수.

### 후니 매핑 (면적매트릭스 + ceiling)
후니 가격표(`[huni:acryl B01~B03·B06]`)는 아크릴을 **[가로×세로] 면적매트릭스**로 둔다(투명3T B01·투명1.5T B02·미러3T B03·코롯토 6×6 B06). 후니 메커니즘 = `component_prices`에 가로/세로 구간 차원(메모리 `dbmap-area-matrix-wh-dimension`) + **off-grid = 한 단계 큰 구간 ceiling**(앱 런타임·메모리 `dbmap-compute-in-app-db-stores-lookup`). RedPrinting 자유사이즈 입력 UX와 후니 면적매트릭스 격자는 **표현력 동등**(UX 차이) — 자유 입력값을 매트릭스 셀(또는 ceiling)로 룩업.

### 사다리 판정 (search-before-mint)
**신규 불요.** 후니 면적매트릭스 comp가 이미 아크릴 본체를 담는다(B01~B03 단가행 라이브 실재). 흡수 = **"자유사이즈 입력 → 면적매트릭스 ceiling 룩업" UX/엔진 계약을 designer가 명시**(입력은 자유·가격은 격자). 면적 함수(㎠당 단가) 신설은 **부결** — 후니 권위 가격표가 매트릭스(이산 구간)이지 연속 함수가 아니다(메모리 `dbmap-price-formula-types-authority`: 면적함수 추천은 오판·실제=매트릭스+ceiling).

### trade-off
- 장점: 자유사이즈 UX(고객 친화) + 격자 가격(권위 단가 보존). RedPrinting과 동일 전략.
- 단점: 미적재 좌표(~58 CLEAR3T·8 미러 `[huni:acryl GAP-SIZ-COORD]`)는 ceiling으로 흡수하거나 채번. 비대칭 좌표(50×30 vs 30×50) 방향 확정 필요(`[huni:acryl Q-ACR-4]`).

### naming 유입 가드 [HARD]
RedPrinting `acrylic2025` 면적 산정식 토큰 후니 유입 금지. 후니 면적매트릭스 comp + ceiling 룩업으로 번역.

---

## C-A3. 아크릴 전용 가격엔진 분기 명시 (우선순위 Medium·흡수 중·엔진 과분화 경계)

### 흡수 메커니즘
레드프린팅 AC **한 카테고리에 3 가격엔진 공존** `[red:AC-reverse §0.6]`: 명찰=`vTmpl_price`(프리셋 템플릿가)·키링=`acrylic2025_price`(면적·두께·소재 전용)·등신대=`tmpl_price`(완제 템플릿가). **형태(라벨/die-cut/평면+받침)별 다른 가격엔진**.

### 후니 매핑
후니는 이를 `frm_cd`(상품→공식 바인딩)로 표현. 후니 아크릴도 형태별 다른 공식이 타당: **면적매트릭스형**(투명/미러/코롯토 본체) vs **고정가형**(카라비너 B07) vs **완제템플릿**(등신대류). `PRF_CLR_ACRYL`(면적)·`PRF_MIRROR_ACRYL`(면적·신설)·`PRF_COROTTO_ACRYL`(면적·신설)·`PRF_CARABINER_ACRYL`(고정가·신설) 4공식이 RedPrinting 3엔진 분기와 동형 `[huni:acryl §2]`.

### 사다리 판정·overfit 경계
**기존 `frm_cd` 코드행으로 닫힘(신규 테이블 0).** 단 **엔진 과분화 경계** — RedPrinting `acrylic2025_price`처럼 "아크릴 전용 엔진"을 후니 코드 레벨로 신설하면 overfit. 후니는 **단일 `evaluate_price` 알고리즘 + 공식/구성요소 데이터 분기**가 권위(메모리 `harness-audit-maintenance`). 흡수 = **공식 분기를 데이터(frm_cd)로** 두는 것이지 엔진 코드 분기가 아니다. rpmeta A-6(3엔진 = 형태/카테고리 전용 패턴) 정합하되 후니는 "공식 1급, 엔진 단일".

### trade-off
- 장점: 면적/고정가/완제 형태별 공식 가독성·관리성↑(미러·코롯토·카라비너 별 공식).
- 단점: 공식을 형태마다 신설하면 관리 비용. 투명3T/1.5T를 1 공식 + mat_cd로 묶듯, **같은 면적매트릭스형은 가능한 한 1 공식 + 차원 분기**로 합치고(C-A1 정합), 계산 방식이 *진짜 다를 때만*(고정가 카라비너) 별 공식.

### naming 유입 가드 [HARD]
`acrylic2025_price`·`vTmpl_price`·`tmpl_price` 후니 유입 금지. 후니 `frm_cd`(의미기반 한글공식명·`PRF_CLR_ACRYL` 등) 번역. naming 권위순서(후니 레거시 최우선) 준수.

---

## C-A4. 부자재 카탈로그 공유 (고리/받침/자석/핀 횡단 BUNDLE) (우선순위 Medium·흡수 중)

### 흡수 메커니즘
레드프린팅 아크릴 부착물은 `SUB_MTR`(추가부자재)·`WRK_MTR`(부자재작업) 2 PCS 그룹으로 인코딩되며 **자재코드+부착공정 BUNDLE** `[red:AC-reverse §0.4]`: 키링 고리 80+(KR001~040 자물쇠/하트/별/달·CN 구슬줄·CR 와이어링)·등신대 받침 12(AB005~016 형상×크기·ESN=Y 필수)·명찰 뒷면(SXANB001 옷핀/SXANB002 마그넷). ★고리 코드(KR/CN/CR)가 **ST(스티커)·GS(굿즈) SUB_MTR과 동일 코드체계 공유** = 카테고리 횡단 "부자재 카탈로그".

### 후니 매핑
후니 가격표 B05(`[huni:acryl B05]`)가 아크릴 후가공 11그룹 추가단가(고리없음0/은색고리1100/금색고리1200/원형핀600/1구자석1000…)를 담는다 — RedPrinting 부착물의 후니 권위판. 후니 메커니즘:
- **가격** = 후가공 추가단가 comp(`COMP_ACRYL_FINISH` 신설·`[huni:acryl GAP-FINISH-COMP]`)에 `use_dims=[opt_cd]` 단가행.
- **선택/생산BOM** = round-6 CPQ option(자재+공정 BUNDLE·메모리 `dbmap-option-material-process-bundle`: 고리=금속링 자재+조립 공정).
- **횡단 카탈로그** = 고리/받침/자석/핀을 **단일 부자재 마스터**로 두면 아크릴/굿즈/스티커가 공유(RedPrinting 코드공유 흡수).

### 사다리 판정 (search-before-mint)
신규 테이블 불요 — 후가공 comp(가격) + round-6 CPQ option(선택) 기존 그릇. 단 **부자재 마스터 단일화**는 dbmap round-22 자재축/basecode 거버넌스 트랙 입력(여기선 설계 권고).

### trade-off
- 장점: 부자재 1회 정의 → 아크릴/굿즈/스티커 횡단 재사용(관리성↑). RedPrinting 코드공유 입증.
- 단점: **자재 vs 공정 분리 주의**(메모리 `dbmap-option-material-process-bundle`) — 고리는 자재(금속링)+공정(조립) BUNDLE이라 후니는 둘을 구분 등록·template이 묶음. add_price 컬럼 부재(CPQ)라 가격은 항상 comp 단가행 경유(`[huni:acryl Q-ACR-1]`).

### naming 유입 가드 [HARD]
`SUB_MTR`/`WRK_MTR`/KR/CN/CR/AB 코드 후니 유입 금지. 후니 `proc_cd`/`mat_cd`/`opt_cd`로 번역.

---

## C-A5. 소재→후가공/인쇄 disable 제약 (우선순위 Medium·흡수 중)

### 흡수 메커니즘
레드프린팅 `pdt_disable_pcs_info`: 명찰(PET RXIGC075) 선택 시 코팅(COT_DFT)·미싱(MIS_DFT)·부분UV(SCO_DFT) **비활성 3건** `[red:cascade]`. 또 투명/유색 아크릴엔 인쇄면(앞뒤같음/다름)·화이트(PRT_WHT) 가용, 불투명 명찰엔 없음(print_data null) `[red:AC-reverse §0.5]` — **소재→인쇄/후가공 가용성 캐스케이드**.

### 후니 매핑
후니 가격엔진엔 "이 소재엔 이 후가공 불가"·"투명소재만 화이트 가용" 제약이 없다. → round-6 CPQ constraints(JSONLogic)로 닫는다: `{"if":[{"==":[{"var":"mat_cd"},"<불투명PET>"]}, {"not":{"in":[{"var":"pcs"},["<코팅>","<미싱>","<부분UV>"]]}}]}` / 화이트는 `{"if":[{"!=":[{"var":"mat_typ"},"투명"]}, {"not":{"var":"white_base"}}]}`.

### 사다리 판정 (search-before-mint)
round-6 CPQ constraints 제약행 추가로 무손실(C-2/C-4 디지털 제약 레이어와 동일 그릇). **data-gap이지 vessel-gap 아님**.

### trade-off
- 장점: 잘못된 (소재, 후가공) 조합 가산·화이트 오적용을 견적에서 차단 → 가격 정합·UX 정합.
- 단점: 소재×후가공 disable 규칙 데이터화 비용. 권위 엑셀(상품마스터 후가공 컬럼)에 명시돼 있으면 그게 정답(경쟁사=보강).

### naming 유입 가드 [HARD]
`disable_pcs`·COT_DFT/MIS_DFT/SCO_DFT/PRT_WHT 후니 유입 금지. 후니 `proc_cd`로 번역.

---

## C-A6. 완제 고정가형 (카라비너·형상별 고정단가) (우선순위 Low·흡수 약·가격표 권위)

### 흡수 메커니즘
후니 가격표 B07(`[huni:acryl B07]`)은 아크릴카라비너(투명3T+3T 접합)를 **4형상 고정가**(자물쇠5800/하트A5800/하트B6300/원형6900)로 둔다 — **면적 아님·형상마다 통가격**(접합 완제품). RedPrinting도 코롯토 등 일부 완제는 면적 외 고정·완제 산정.

### 후니 매핑
후니 = 고정가 comp(`COMP_ACRYL_CARABINER`·`comp_typ_cd=.06 완제품비`·`prc_typ=.01 단가형`·`use_dims=[opt_cd]`·B07 4형상 단가행 `[huni:acryl §3-2]`). 형상을 `opt_cd`로 단가 분기(면적매트릭스의 siz_cd와 다른 키).

### 사다리 판정·overfit 경계
**기존 고정가 comp 그릇으로 닫힘.** ★중요 흡수 원칙: **같은 "아크릴"이라도 가격 산정방식이 면적(키링/코롯토)과 고정가(카라비너)로 갈린다** — 한 상품군을 단일 공식으로 강제하지 말 것(메모리 `dbmap-print-domain-recipe-philosophy`: 여러 가격산정방식=도메인 현실). 형상(자물쇠/하트)을 siz_cd(면적)로 오해하면 오모델(`[huni:acryl Q-ACR-2]`).

### trade-off
- 장점: 완제 접합 상품을 형상 고정가로 정확히 표현(면적 오모델 회피).
- 단점: 형상별 단가행 enumeration(소수라 비용 낮음).

### naming 유입 가드 [HARD]
가격표 권위(B07 한글 형상명) 우선·경쟁사 토큰 불요.

---

## C-A7. 라미네이션 = 두께 합성 가공방식 (우선순위 Low·흡수 약·자재 그룹핑 슬롯 경계)

### 흡수 메커니즘
레드프린팅 `production_method`(MTG_DFT 일반/MTG_LAM 라미)가 `GRP_OPTION_CD`로 자재행을 가공그룹으로 묶는다 `[red:AC-reverse §0.6·A-8]`. 라미(MTG_LAM)는 **두께를 바꾸고(3T→2T+1T) 소재를 부여**(홀로그램 깨진유리/격자 = 라미 합지) — 자재합성 공정. RedPrinting은 라미를 별 자재행(PXAATL01~04)으로도, 가공방식 그룹핑(GRP_OPTION)으로도 양면 인코딩.

### 후니 매핑·overfit 경계
후니는 두 경로 가능:
- (a) **라미 자재를 별 `mat_cd`로** 등록(투명3T 라미 = 별 자재행·단가) — C-A1 두께=자재차원 원칙과 일관. **권장**.
- (b) 라미를 공정 comp(라미네이팅비 가산)로 — 두께 합성이 단가 효과뿐이면.

★**자재 그룹핑 슬롯(GRP_OPTION_CD) 신설은 부결(overfit)** — RedPrinting이 자재를 가공방식으로 묶는 메커니즘은 후니 미발굴이나, 후니는 자재 enum(별 mat_cd) + round-6 CPQ option(가공방식 택1)으로 표현 가능. 새 그릇(가공방식 그룹핑 컬럼/테이블) 불요.

### trade-off
- 장점: 라미/홀로그램 소재 variant를 자재행으로 일관 인코딩(C-A1 정합).
- 단점: 자재행 증가(라미 4종). 단, 표면효과(글리터/거울/자개)는 미러처럼 별 단가체계일 수 있어(`COMP_ACRYL_MIRROR3T` 별 공식 `[huni:acryl §3-1]`) 단순 variant 아닐 수 있음 — 가격 분기 시 별 comp.

### naming 유입 가드 [HARD]
`production_method`/`GRP_OPTION_CD`/MTG_LAM 후니 유입 금지. 후니 `mat_cd` 또는 `proc_cd` 번역.

---

## 2. 디지털인쇄 ×qty 과청구 맥락 — 경쟁사 아크릴 수량처리 대조 ★

> 디지털인쇄 파일럿에서 **`prc_typ .01`(단가형) × 수량 누적이 인쇄비를 과청구**하는 결함이 있었다(메모리 `dbmap-round21-cycle1-note-load`: 후가공 prc_typ .01 평면화로 엔진이 ×수량 3배). 아크릴은 경쟁사가 수량을 어떻게 처리하는가?

| 관점 | 레드프린팅 아크릴 | 후니 아크릴 가격표 | 시사점 |
|------|------------------|-------------------|--------|
| 본체 수량 | 키링 `prn_cnt` widget select(1~10)·디지털 키링류는 소량 개당 `[red:AC-reverse §2]` | 아크릴 수량별 **구간할인 6구간 0~50%**(B04·별 t_dsc 트랙) `[huni:acryl B04]` | 아크릴 본체는 **개당 면적단가 × 수량 후 구간할인** — 디지털 ×qty 과청구와 다른 구조(할인이 별 단계) |
| ★본체 comp prc_typ | unobserved(서버 `acrylic2025_price`) | 라이브 `COMP_ACRYL_CLEAR3T` **prc_typ .02(합가형)**·use_dims에 `min_qty` 포함(`[huni:acryl Q-ACR-7]`) | ★**아크릴 본체가 라이브상 .02(합가형)** — 면적단가가 수량 곱 대상인지 총액인지 **엔진 계약 미확정**(돈-크리티컬·디지털 ×qty 결함과 같은 prc_typ 정합 위험) |
| 후가공 가산 | 고리/받침 = 부자재 BUNDLE·QTY_INPUT_YN(수량입력) `[red:AC-reverse §0.4]` | B05 후가공 추가단가(고리1100 등) — 개당 1회 가산 추정 | 후가공이 **개당 1회 가산**인지 ×수량인지 = 디지털 결함과 동일 클래스(후가공 prc_typ .01 ×수량 = 과청구) |
| 이중수량 | **디자인수(ordCnt) × 수량(printCnt)** 명시 분리 `[red:AC-reverse §2]` | 가격축 아님(주문라인) | 디자인 건수를 가격 차원에 baked-in 금지(디지털 C-5 동일 가드) |
| 수량 곡선 | 소량 이산 select(1~10) | 구간할인 6구간 | 아크릴은 **소량 이산**(키링 개당)·디지털 대량 연속과 대조 — 곡선 파라미터 불요 |

### 핵심 대조 시사점
1. **★아크릴 본체 prc_typ .02 정합은 디지털 ×qty 결함과 동일 클래스의 돈-크리티컬 위험** — 면적매트릭스 단가가 "개당(×수량)"인지 "총액(.02)"인지 엔진 evaluate_price 계약으로 확정해야(`[huni:acryl Q-ACR-7]`). **추측 적재 금지**. 디지털에서 .01×수량 평면화가 3배 과청구였듯, 아크릴 .02도 엔진이 곱하는지 안 곱하는지 검증 선결.
2. **후가공 가산은 "개당 1회"인지 "×수량"인지 명시** — RedPrinting QTY_INPUT_YN(고리 수량입력)은 부자재가 수량 종속일 수 있음을 시사(고리 N개 = N×단가). 후니 후가공 comp의 prc_typ와 수량축 정합을 디지털 결함 교훈으로 검증.
3. **수량 할인은 별 단계(B04 t_dsc)** — 아크릴은 면적단가 × 수량 **후** 구간할인(0~50%). 디지털 합산형과 할인 적용 순서 다름 — designer가 할인 적용 순서(가산 후 할인 vs 항목별 할인)를 엔진 계약에 명시.
4. **이중수량 분리 일관** — 디자인 건수(ordCnt)는 주문라인 멀티플라이어·가격축 아님(디지털 C-5 = 아크릴 동일 가드).

---

## 3. 흡수 종합 판정

1. **아크릴 가격계산 골격(면적매트릭스 + 두께=자재차원 + 후가공 합산 + 수량구간할인 + 형상 고정가)은 후니 가격표(260527 아크릴 시트 8블록)와 라이브 `t_prc_*`가 이미 동형으로 담는다** → 핵심 흡수 불요(C-A1·C-A2·C-A6 = 이미 동형 확인·설계 원칙 못박기).
2. **실질 흡수 = 제약 레이어 1건(C-A5 소재→후가공 disable) + 부자재 카탈로그 공유(C-A4)** — 둘 다 기존 그릇(round-6 CPQ constraints·후가공 comp)으로 닫히며 가격 정합 가드.
3. **약한 보강 2건(C-A3 엔진분기 명시·C-A7 라미)** — frm_cd/mat_cd로 닫힘·엔진 코드 분기/자재 그룹핑 슬롯 신설은 **overfit 부결**.
4. **신규 가격축/테이블 신설 = 0건** — rpmeta AC "두께·소재·입체 전부 facet·distinct #19 부결"과 정합(search-before-mint 통과).
5. **WowPress 아크릴 = 미관측**(아크릴보드/아크릴톡 실재 확인 `[wow:probe]`나 옵션·가격 미캡처) — 면적 가격화 방식 보강 불가·정직 기록. RedPrinting(사용자 본인 설계·흡수 정당)이 주 오라클.
6. **모든 흡수는 권위 엑셀이 최종** — 경쟁사가 가격표(B01~B08)와 충돌하면 가격표가 이긴다.

### designer로 넘기는 핵심 입력
- **두께 = `mat_cd` 차원**(별 두께축 신설 금지·C-A1)·면적 = **매트릭스 ceiling 룩업**(면적 함수 부결·C-A2).
- **형태별 공식 분기**(면적매트릭스 PRF_CLR/MIRROR/COROTTO + 고정가 PRF_CARABINER)는 `frm_cd` 데이터로(엔진 코드 분기 아님·C-A3/C-A6).
- **소재→후가공 disable + 부자재 카탈로그**는 round-6 CPQ 제약/옵션 레이어(C-A4/C-A5).
- **★돈-크리티컬**: 아크릴 본체 `COMP_ACRYL_CLEAR3T` prc_typ **.02 정합**(개당×수량 vs 총액)을 엔진 evaluate_price 계약으로 확정 — 디지털 ×qty 과청구와 동일 클래스 위험(추측 적재 금지·`[huni:acryl Q-ACR-7]`).
- **할인 적용 순서**(면적단가×수량 후 구간할인 B04)를 엔진 계약에 명시.
