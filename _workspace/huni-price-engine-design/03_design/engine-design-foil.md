# engine-design-foil.md — 박류(foil) 후가공 면적·등급·수량 가격엔진 설계

> **핵심 설계가(hpe-engine-designer) 산출 — 박 후가공 종단.** cartographer 지도(`01_formula/{formula-map,component-inventory,gap-board}-foil.md`)
> + benchmark 흡수(`02_benchmark/{competitor-pricing-models,absorption-candidates}-foil.md`)를 종합해, 박 후가공의
> 가격공식 + 가격구성요소 + t_prc_* 단가행 그릇 + 7상품 바인딩을 라이브 `evaluate_price`가 그대로 먹는 형태로 설계한다.
> **새 엔진 코드 아님 — t_prc_* 데이터 그릇/바인딩 설계.** webadmin 코드 직접수정 금지.
>
> 권위[HARD]: ① 인쇄상품 가격표 박(대형)/박(소형) 시트 > ② 라이브 t_prc_*(기준선·읽기전용) > ③ 역공학·경쟁사(흡수 후보·naming 유입 금지).
> 산출자: hpe-engine-designer · 라이브 읽기전용 SELECT 실측 2026-06-30 · 단가값=가격표 verbatim(날조 0) · **DB 미적재**(실 적용 인간 승인 후 dbmap 위임).
> 컨벤션·engine-contract = `engine-design-acrylic.md`(면적매트릭스)·`engine-design-booklet.md`(proc_grp 후가공) 동형.
>
> ★ **REV2 폐루프 보정(2026-06-30·validator E4 CONDITIONAL)**: §5 바인딩을 addon 템플릿→**(a) 본체 공식 합산 배선**으로 재작성(B-FOIL-1 돈크리티컬). §0/§4 근거 정정(B-FOIL-3). §3 면적→등급 환산=코드트랙 분리 명기(B-FOIL-2). 골든 8/8 권위 verbatim 일치는 불변(E6 PASS). 변경 이력=`design-decisions-foil-rev2.md`.
>
> ★★ **REV3 폐루프 보정(2026-06-30·codex 2차 교차 reconcile=`05_codex/codex-reconcile-foil.md`)**: ① **R-FOIL-CDX1[돈크리티컬]** — 동판비 comp C-1/C-2 use_dims에 **proc_cd 게이트 누락**(`pricing.py:99-111` NULL=와일드카드 → 박 미선택 주문에 동판비 상시 과금). 동판비 use_dims에 proc_cd 추가(C-1=`["proc_cd","siz_width","siz_height"]`·C-2=`["proc_cd"]`)·단가행 proc_cd 충전. ★라이브 재실측: 명함박 SETUP=`["min_qty"]`(proc_cd 없음)=박 항상 거는 상품이라 게이트 불요 → **7상품엔 답습 금지·proc_cd 충전 필수**(접지카드 PRF_DGP_E 후가공 comp가 proc_cd 100% 충전으로 게이트하는 동형). ② **R-FOIL-CDX2** — C-3/C-5 본문 표 prc_typ `.01` stale→`.02` 정정. ③ **R-FOIL-CDX3** — proc_grp는 코드상 매칭 차단 차원 아님(게이트=proc_cd·dim_vals만)·표기 정밀화. 골든 8/8·박가공비 .02+min_qty·본체 공식 합산·B-FOIL-2 C트랙·G6 1셀 불변. 변경 이력=`design-decisions-foil-rev3.md`.

---

## 0. 설계 요약 — 무엇을 하나 (라이브 baseline 대비)

라이브 실측(2026-06-30)이 cartographer 지도를 확인했다. 박 후가공 가격은 **명함박(PRD_000037)에만** 구현돼 있고(COMP_NAMECARD_FOIL_* 4 + SETUP 2), 그 외 박을 거는 7상품(2단/3단접지카드·프리미엄명함·펄명함·프리미엄쿠폰·무선책자·PUR책자)은 박 공정을 "선택 가능"으로 노출하나 **가격공식에 박 가공비 구성요소가 없어 박을 걸어도 0원**이다(G1·돈크리티컬·매출 누락).

| 라이브 실측 (2026-06-30·읽기전용) | 값 | 설계 함의 |
|---|---|---|
| 대형박/소형박 가공비 comp | **명함박 외 0건** (grep FOIL→NAMECARD만) | 7상품용 박 가공비 comp 신설 필요(G1) |
| 박 동판비 comp(대형 면적매트릭스) | **0건** | 대형 동판비 comp 신설 필요 |
| 박 자식공정 (parent=PROC_000033 박 아래 **16종**·PROC_000034 금·035 은·036 핑크 + 037~049 박색상 13종) | 전건 use_yn=Y·del_yn=N·실재(라이브 실측 2026-06-30) | ★박색상축 = proc_cd 차원으로 재사용(신규 mint 0·search-before-mint 강충족). 박색상 enum에는 037~049만 쓰나, 박 자식공정 자체는 **16종**(B-FOIL-3 정정: 이전 "13종"은 034~036 누락 표기) |
| **proc_cd + proc_grp:PROC_XXX 차원 패턴** | 제본(COMP_BIND_*)·접지(COMP_FOLD_LEAF_*)·타공(COMP_CUT_PERF_*) 전부 사용·라이브 광범위 선례 | ★박색상·면적등급을 담을 검증된 그릇(G2/G3 해소 키) |
| 명함박 본체 S1_STD 1000매 | **63,000** vs 권위 소형 일반박 E등급 1000(M18)=**64,000** | ★1,000원 갭(G6) — 답습 금지·권위 64,000으로 설계 |
| 7상품 product_processes 박 색상 | 2단접지카드·프리미엄명함 등에 PROC_000037~044 8종 등록·**금무광/은무광(048/049)·펄박(045)·백박(046)·녹박(047) 미등록** | 상품별 박색상 enum이 제한적(상품마다 다름) — 바인딩 시 사용 색상만 |

**∴ 박 설계의 핵심 = ① 박 가공비 comp 신설(대형 일반/특수·소형 일반/특수 = 4 comp + 대형 동판비 1 comp) ② 면적→등급은 앱 계산(DB는 등급별 단가만·[[dbmap-compute-in-app-db-stores-lookup]]) ③ 박색상 일반/특수 분기는 proc_cd 차원 + 단가표 2블록 ④ ★[REV2] 7상품 본체 공식에 박 comp를 직접 합산 배선(proc_cd 차원으로 박 선택 시만 매칭·미선택 시 0 — 명함박/접지카드가 라이브 작동 입증한 패턴. addon 템플릿 아님).** 명함박은 기존 모델 보존(미터치·참조만).

★ **[REV2 핵심 전환] addon 템플릿 부결→본체 공식 합산 채택**: validator 라이브 실측(E4)에서 `t_prd_template_prices`=`tmpl_cd|apply_ymd|unit_price` **단일 고정단가만**(차원 컬럼 0)·pricing.py:441-446이 `unit_price×qty`임이 확정됐다. ∴ addon 템플릿에는 박가공비 다차원(면적등급×수량구간×일반특수)을 담을 수 없고, 넣으면 ×qty 폭발([[bandtotal-x-qty-overcharge]] 재현). 이전 §5 "7상품=addon 템플릿"은 무효. 대신 **명함박 PRF_NAMECARD_FOIL이 박가공비 comp(COMP_NAMECARD_FOIL_S1_STD)와 동판비 comp(SETUP)를 공식 formula_components로 직접 합산**하는 방식이 라이브 작동 입증 패턴(아래 §5 재설계).

★ **돈크리티컬 가드[HARD] 3건**: (가) 동판비=1회성·×qty 절대 금지(PRICE_TYPE.03·use_dims에 min_qty 없음). (나) 박가공비=수량구간 lookup(작업 1건 고정금액·이미 수량 반영)이라 이중 ×qty 금지. [[bandtotal-x-qty-overcharge]] 교훈 — 명함박 SETUP/본체가 둘 다 "작업 1건 고정"인 것이 라이브 증거. **(다) ★[REV3·R-FOIL-CDX1] 동판비 comp use_dims에 proc_cd 게이트 필수** — `pricing.py:99-111 _row_matches`는 행 차원이 NULL이면 와일드카드(어떤 선택값이든 통과). 동판비 단가행에 proc_cd가 NULL이면 박 미선택 주문에도 사이즈(siz_width/height)만 맞으면 동판비(소형 5,000·대형 11,000~64,000)가 **상시 청구**(silent 과청구). 박가공비 comp(C-3~C-6)는 use_dims에 proc_cd가 있어 박 미선택 시 0이지만, 동판비(C-1/C-2)만 게이트 누락이었음(REV2 §5-2 "박 미선택 0 보장" 논거는 박가공비에만 성립). → **동판비 use_dims에 proc_cd 추가 + 단가행 proc_cd 충전**(박 선택 시만 매칭·미선택 0). ★라이브 재실측(2026-06-30): 명함박 `COMP_NAMECARD_FOIL_SETUP_S1_STD` use_dims=`["min_qty"]`(proc_cd 없음) — 명함박은 박을 **항상 거는 전용 상품**(PRF_NAMECARD_FOIL이 동판비+박가공비를 박 선택 무관 무조건 합산)이라 게이트 불요. 7상품은 박이 **선택적**이라 이 명함박 패턴 답습 금지·proc_cd 충전 필수(접지카드 PRF_DGP_E 후가공 comp가 proc_cd 100% 충전으로 "판별차원 없음=항상 매칭" 함정 회피하는 동형 패턴·`pricing.py:601`).

---

## 1. 박 가격 모델 (권위 디코드·이대로 설계)

```
박_총액 = 동판비_comp           ← 1회성 고정 setup (PRICE_TYPE.03·×qty 금지)
        + 박가공비_comp          ← (면적→등급 A~E) × (수량구간) lookup·작업 1건 고정금액
  동판비    = 대형: 면적매트릭스[가로][세로]  (11,000~64,000)
            = 소형: 80x40mm 고정 5,000
  박가공비  = 수량별가격표[등급][수량]
              등급 = 면적분류표[가로][세로] → A~E   (앱 계산·DB 미저장)
              표 선택 = 박색상(proc_cd) → {일반박 블록 | 특수박 블록}
              표 선택 = 크기 카테고리 → {대형 시트 | 소형 시트}  (CONFIRM·G4)
```

| 계산방식 | 박 블록 | 엔진 처리(engine-contract) |
|---|---|---|
| **면적매트릭스형** | 동판비(대형 B01)·박가공비 면적→등급(B02/B03 정의 블록) | 동판비=use_dims=[siz_width,siz_height] 직접단가. 박가공비=면적→등급은 앱 계산(§3) |
| **수량구간형** | 박가공비 수량별가격(K~P/H~M 열)·동판비(소형) | min_qty축. 작업 1건 고정금액(×qty 아님) |
| **고정가형** | 동판비(소형 5,000) | 단일값·PRICE_TYPE.03 |
| **합산형(원자합산)** | 박_총액 = 동판비 + 박가공비 (★[REV2] 본체 공식 formula_components로 직접 합산·proc_cd 미선택 시 0) | 명함박 PRF_NAMECARD_FOIL이 박가공비 comp+동판비 comp를 공식에 직접 합산해 실증(라이브 SELECT 2026-06-30 확인) |

★ **frm_typ 미참조 계약(engine-contract C7·`pricing.py:8`)**: "면적매트릭스형/수량구간형/고정가형"은 별 엔진 분기가 아니라 comp의 use_dims 차이일 뿐. 설계는 전부 `formula_components`/`addon` 배선 합산으로 표현.

---

## 2. ★박색상축 = proc_cd 차원 + 일반/특수 단가표 2블록 [HARD·G2 해소]

### 2-1. 결정: proc_cd(박 자식공정 13종) 차원 채택 — 명함박 comp분리 답습 안 함

cartographer §3이 4안(A comp분리 / B print_opt_cd / C proc_cd / D opt_cd)을 제시. **C(proc_cd) 채택**. 근거:

1. **라이브 선례 강함**: 박 자식공정 PROC_000037~049(13종)이 이미 parent=PROC_000033(박) 아래 정리·전건 use_yn=Y. **신규 mint 0**(search-before-mint 강충족·component-inventory §4).
2. **검증된 그릇 패턴 존재**: 제본·접지·타공 comp가 전부 `use_dims=["proc_cd","min_qty"(,proc_grp:PROC_XXX)]` 패턴으로 후가공 단가를 proc_cd로 분기한다(라이브 실측). 박은 그 동형 — proc_cd 정확매칭으로 박 그룹 안에서 1행 선택. ★[REV3·R-FOIL-CDX3] **proc_grp:PROC_000033은 박 그룹 식별 메타일 뿐 코드상 매칭 차단 차원이 아니다**(`pricing.py:99-111` 게이트력=proc_cd·dim_vals만). 박 선택 여부 차단력은 proc_cd가 한다 — proc_grp만 두고 proc_cd를 비우면 게이트가 안 걸린다.
3. **명함박 comp분리(S1_STD/S1_HOLO) 비채택 이유**: 명함박은 박 종류 8개가 process로 노출되나 가격은 comp 선택(S1_STD vs S1_HOLO)으로 갈렸다 — 즉 박색상→가격 매핑이 공식 배선에 안 들어가 HOLO/양면 미배선(불완전·G6). proc_cd 차원은 박색상→단가를 단가행 자체에 담아 이 결함을 처음부터 제거.
4. **opt_cd(D) 부결**: addon opt_cd 가산 모델 라이브 미작동 이력([[addon-optcd-model-broken-live]]). print_opt_cd(B) 부결: 도수(인쇄옵션) 의미축(POPT_000008)이라 박색상에 오용 우려.

### 2-2. 일반박/특수박 = 단가표 블록(component_prices 묶음) 선택

일반박과 특수박은 같은 (등급×수량)이라도 단가가 다르다(예 대형 A등급 1000매 일반 75,000 vs 특수 95,000). **단가행을 2 comp로 분리**(일반/특수)하고, 손님이 고른 박색상(proc_cd)이 **어느 comp가 활성화되는지를 가른다**:

- 박색상→{일반|특수} 그룹 매핑은 **상품/시트마다 다름**(★먹유광·펄박이 대형/소형에서 일반↔특수 소속 상이 — gap-board G2). 이 매핑은 CPQ 옵션 레이어(option_items)에서 박색상 선택→해당 comp의 proc_cd 차원으로 환원. 한 시점에 일반 comp 또는 특수 comp 중 하나만 매칭.
- ★**판별차원 필수(silent 이중합산 가드·U-7)**: 일반박 comp·특수박 comp를 한 addon 템플릿에 동시 배선하면 둘 다 와일드카드 통과→silent 이중합산. **각 comp 단가행에 proc_cd를 충전**해, 손님이 고른 박색상의 proc_cd와 정확매칭되는 comp만 단가행 후보가 되도록 한다(다른 그룹 comp는 proc_cd 불일치→no_match→합산 제외). 또는 addon 템플릿이 박색상 선택에 따라 일반/특수 중 1 comp만 인스턴스화.

### 2-3. 일반/특수 박색상 그룹 매핑 (권위 verbatim·designer 확정)

| 시트 | 일반박 (proc_cd) | 특수박 (proc_cd) |
|---|---|---|
| **대형** | 금유광(038)·금무광(048)·은유광(039)·은무광(049)·동박(041)·청박(043) | 먹유광(040)·백박(046)·홀로그램(037)·트윙클(044)·적박(042)·녹박(047) |
| **소형** | 금유광(038)·은유광(039)·먹유광(040)·청박(043)·적박(042)·동박(041)·펄박(045) | 백박(046)·홀로그램(037)·트윙클(044) |

출처: 권위 B03/B04 블록 제목(large-l1.csv:85·252 / small-l1.csv:8·147). ★먹유광(040)=소형 일반/대형 특수, 펄박(045)=소형만(일반). 적박(042)=대형 특수/소형 일반. 이 시트별 차이를 매핑 테이블로 명시(앱이 시트+박색상으로 그룹 판정).

---

## 3. ★면적→등급(A~E) 2단 lookup = 앱 계산 (DB는 등급별 단가만) [HARD·G3 해소]

### 3-1. 결정: 앱 계산 (gap-board 3안 중 다 채택)

박가공비는 (가로×세로 → 등급 A~E) → (등급 × 수량 → 단가) 2단계. 면적→등급 변환을 **어디에 두나**:

- **(다) 앱 계산 채택** — [[dbmap-compute-in-app-db-stores-lookup]] 철학 정합(판수·박 등급 동일: 중간계산=앱·DB=룩업). DB component_prices는 **등급별·수량별 단가만** 저장(등급 라벨을 dim_vals JSON 또는 opt_cd로). 면적→등급 변환표(대형 9×8·소형 5×5 등급격자)는 **앱 lookup 테이블**(코드/설정)이 가짐.
- **(나) 면적격자 직접 펼침 부결**: 등급×수량 단가를 면적 9×8 격자 × 13수량으로 펼치면 행 폭증(72×13=936행/시트) + 면적셀마다 등급단가 중복 → 권위 등급 구조 소실·유지보수 악화.
- ★**코드트랙 분리 명기 [B-FOIL-2·확정]**: 라이브 실측(2026-06-30) `pricing.py:42-50` **NON_QTY_DIMS=(siz_cd·plt_siz_cd·print_opt_cd·mat_cd·proc_cd·opt_cd·coat_side_cnt·bdl_qty)·TIER_DIMS=(siz_width·siz_height·min_qty)에 grade 없음** = 면적→등급(grade) 환산을 엔진이 **미지원** 확정. dim_vals JSON의 grade는 정확매칭 차원일 뿐 면적값→등급 변환이 아니다. **앱이 면적→등급 환산 후 grade를 selection으로 넘겨야** 작동. 현 라이브 명함박은 면적이 명함 고정→단일등급(E) collapse라 환산 불필요(단가행 use_dims=`["min_qty"]`·dim_vals 비어있음 실측). 7상품은 면적 가변이라 환산 필수.
  - **판정**: **등급별 단가 그릇은 정확(골든 8/8 권위 verbatim 일치)·엔진의 면적→등급 환산 지원이 선결**. → 개발팀 **C트랙**(dbm-price-arbiter 심의·Q-FOIL-CODE1 우선도 High). 설계 결함 아님(데이터 그릇은 건전·엔진 능력 미확정).
  - **대안(상품별 구분)**: 고정사이즈 상품(명함박·펄명함 등 사이즈 고정)은 면적이 단일등급으로 collapse(환산 불요)되어 현 엔진으로도 작동 가능 — 박가공비 comp use_dims에서 면적등급을 단일값(dim_vals `{"grade":"X"}` 고정)으로 collapse. 사이즈 가변 상품(접지카드·책자 표지 등)만 면적→등급 환산이 필요 → C트랙 종속. 상품별로 가변/고정 여부를 바인딩 시 구분.

### 3-2. 등급격자 verbatim (앱 lookup 테이블·권위 출처)

**대형 면적→등급 (B03 A15:I23·일반/특수 동일 격자)** — 행=가로(세로축 첫값), 열=세로:

| 가로\세로 | 30 | 50 | 70 | 90 | 110 | 130 | 150 | 170 |
|---|---|---|---|---|---|---|---|---|
| 30 | A | A | A | A | A | A | A | B |
| 50 | A | A | A | A | B | B | B | B |
| 70 | A | A | B | B | B | B | B | D |
| 90 | A | A | B | C | C | D | D | D |
| 110 | A | B | B | C | D | D | D | D |
| 130 | A | B | B | D | D | D | D | E |
| 150 | A | B | B | D | D | D | E | E |
| 170 | B | B | D | D | D | E | E | E |

출처: large-l1.csv B03 행16~23 (예 30×30=A[B16]·90×90=C[E19]·110×110=D[F20]·170×170=E[I23]). ★특수박 B04 격자(행36~43)도 동일 등급 매핑(large-l1.csv:269~382 verbatim 일치 확인). 즉 일반/특수가 **면적→등급은 같고 등급→단가만 다름**.

**소형 면적→등급 (B02 A9:F12)**:

| 가로\세로 | 10 | 20 | 40 | 60 | 80 |
|---|---|---|---|---|---|
| 10 | A | A | A | B | C |
| 20 | A | A | B | C | D |
| 40 | A | B | D | E | E |

출처: small-l1.csv B02 행10~12 (10×10=A·40×40=D[D12]·40×80=E[F12]·20×60=C[E11]). 소형 특수박 B04 격자(행33~35) 동일.

★ **off-grid 처리**: 손님 가로/세로가 격자값 사이면 각 축 '이하' 최소 임계 ceiling(아크릴 동형·`pricing.py:158-162`). 예 대형 가로35×세로35 → 가로 ceiling 50·세로 ceiling 50 → 50×50 셀 등급(A). 단 박은 면적→등급이 앱 lookup이므로 ceiling을 앱이 등급 환산 전에 적용. 최대 초과(>170대형·>80소형) → 더 큰 시트로 넘기거나 ERR(CONFIRM).

---

## 4. 가격구성요소 설계 (price_components) — search-before-mint

신규 mint = **5 comp** (대형 동판비 1 + 대형 일반/특수 박가공비 2 + 소형 일반/특수 박가공비 2). 명함박 comp(4)는 미터치(명함 전용·E등급 collapse). 박 자식공정 13종·아연판은 재사용(0 mint).

### C-1. COMP_FOIL_SETUP_LARGE — 대형 동판비 (면적매트릭스 1회성)

| 속성 | 값 | 근거 |
|---|---|---|
| comp_typ_cd | PRC_COMPONENT_TYPE.05 (셋업) | 라이브 SETUP_S1_STD 동일 |
| prc_typ_cd | **PRICE_TYPE.03 (작업당 1회 고정)** | ★×qty 금지 가드(동판=1회 제작비) |
| use_dims | **`["proc_cd","siz_width","siz_height"]`** ★[REV3·R-FOIL-CDX1] | 대형 B01 가로×세로 면적매트릭스 + **proc_cd 게이트**. proc_cd 없이 두면 박 미선택 주문에 사이즈만 맞으면 동판비 상시 과금(pricing.py:99-111 NULL=와일드카드). 박가공비(C-3~C-6) proc_cd 게이트와 동형으로 박 선택 시만 매칭·미선택 0 |
| comp_nm | 박·형압 동판셋업비(대형) | 후니 표준 용어(경쟁사 naming 유입 0) |
| 단가행 | 대형 B01 9×8=72행 (siz_width/siz_height·min_qty 없음·NULL) **+ 각 행 proc_cd 충전(박 자식공정 PROC_000034~049)** | large-l1.csv B01 verbatim. ★proc_cd 충전: 동판비는 박색상 무관 동일값(면적만 좌우)이라 박 그룹 전 색상에 같은 값을 채우거나, proc_grp:PROC_000033(박 그룹) 메타로 박 선택 여부만 게이트. 단 코드상 게이트력=proc_cd·dim_vals만(R-FOIL-CDX3·proc_grp는 그룹 메타)이므로 **proc_cd를 단가행에 실 충전 필수** |

### C-2. COMP_FOIL_SETUP_SMALL — 소형 동판비 (고정 5,000)

★ **search-before-mint 후보**: 라이브 `COMP_NAMECARD_FOIL_SETUP_S1_STD`=5,000(PRICE_TYPE.03)이 이미 소형 동판비 5,000과 동일값. 단 명함 전용 comp_nm·S1/S2 구조라 7상품 공유엔 부적합 → **신규 COMP_FOIL_SETUP_SMALL 1개**. 또는 명함박 SETUP을 공유 가능하나 명함박 보존 원칙([[base-master-code-no-delete]])상 별 comp 권장. **CONFIRM Q-FOIL-SETUP1**.

★★ **[REV3·R-FOIL-CDX1] proc_cd 게이트 필수**: 명함박 SETUP은 use_dims=`["min_qty"]`(라이브 재실측·proc_cd 없음)으로 **박 미선택 시 차단 차원이 없다** — 명함박은 박을 항상 거는 전용 상품이라 무방하나(박 미선택 주문 자체가 없음), **소형 동판비를 박 선택형 7상품(프리미엄명함·펄명함 등)에 본체 공식 합산하면 명함박 패턴 답습 시 박 미선택 주문에 5,000 상시 과금**. ∴ 명함박 SETUP의 use_dims를 답습하지 말고 **proc_cd를 넣어 박 선택 시만 매칭**.

| 속성 | 값 | 근거 |
|---|---|---|
| comp_typ_cd | PRC_COMPONENT_TYPE.05 | |
| prc_typ_cd | **PRICE_TYPE.03** | ×qty 금지 |
| use_dims | **`["proc_cd"]`** ★[REV3·R-FOIL-CDX1] | 단일값(소형은 80x40 단일)이나 박 선택 게이트로 proc_cd 필수. 명함박 SETUP `["min_qty"]` 답습 금지(박 항상 거는 명함박과 달리 7상품은 박 선택형) |
| 단가행 | 박 그룹 색상별 proc_cd × 5,000 (small-l1.csv B01 B3 단일값을 박 자식공정별 충전) | verbatim 5,000·각 박색상 proc_cd 행. 동판비는 박색상 무관 동일 5,000이라 박 그룹 전 색상에 같은 값. ★proc_cd 충전이 게이트(R-FOIL-CDX3·proc_grp는 그룹 메타·코드 게이트력 없음) |

### C-3. COMP_FOIL_PROC_LARGE_STD — 대형 박가공비 일반박

| 속성 | 값 | 근거 |
|---|---|---|
| comp_typ_cd | PRC_COMPONENT_TYPE.01 (가공비) | 박 단독 가공비. ★[B-FOIL-3 정정] 명함박 S1_STD는 `.06`이고 comp_nm="오리지널박명함 완제품가...(종이+동판+박)"=**종이+동판+박 통합 완제품가**(라이브 실측). 박 단독 아님. 7상품 박가공비는 본체와 분리된 박 단독 가공비 |
| prc_typ_cd | **PRICE_TYPE.02 (합가형)** ★[REV3·R-FOIL-CDX2 정정] | ★수량별가격표가 "작업 1건 고정금액"이라 ×qty 아님이 핵심. **.01(단가형)은 ×qty 폭발 위험이라 부결**(§4-가드 결론). `.02 합가형 + min_qty=구간하한`으로 작업 1건 고정 성립(명함박 동형·아래 §4-가드). 이전 표의 `.01`은 stale 표기였음(가드·결론은 항상 .02) |
| use_dims | `["proc_cd","min_qty"]` (+면적등급 dim_vals) ★proc_grp:PROC_000033은 그룹 메타(아래) | 제본/접지 후가공 동형 패턴. ★[REV3·R-FOIL-CDX3] **코드상 매칭 게이트=proc_cd·dim_vals만**(`pricing.py:99-111`)·proc_grp:PROC_000033은 박 그룹 식별 메타일 뿐 차단 차원 아님. 박 선택 여부 차단력은 proc_cd가 한다 |
| comp_nm | 박 가공비(대형·일반박) | |
| 단가행 | 등급(A~E) × 수량(10~10000 13구간) = 5×13=65행. 등급=dim_vals JSON `{"grade":"A"}` 또는 opt_cd. **min_qty=구간하한 NOT NULL·proc_cd=박색상** | large-l1.csv B03 K~P열 verbatim |

### C-4. COMP_FOIL_PROC_LARGE_SPECIAL — 대형 박가공비 특수박

C-3 동형. 단가행 = large-l1.csv B05 K~P열 verbatim(5×13=65행·특수박 단가). proc_grp:PROC_000033·proc_cd=특수박 색상.

### C-5. COMP_FOIL_PROC_SMALL_STD — 소형 박가공비 일반박

| 속성 | 값 | 근거 |
|---|---|---|
| comp_typ_cd | PRC_COMPONENT_TYPE.01 | |
| prc_typ_cd | **PRICE_TYPE.02 (합가형)** ★[REV3·R-FOIL-CDX2 정정] | 작업 1건 고정금액. .01(단가형)은 ×qty 폭발 위험이라 부결·`.02 + min_qty=구간하한`으로 작업 1건 고정 성립(§4-가드). 이전 표 `.01`은 stale |
| use_dims | `["proc_cd","min_qty"]` (+면적등급 dim_vals) ★proc_grp:PROC_000033은 그룹 메타 | ★[REV3·R-FOIL-CDX3] 코드 게이트=proc_cd·dim_vals만·proc_grp는 박 그룹 식별 메타(차단 차원 아님) |
| 단가행 | 등급(A~E) × 수량(200~10000 15구간) = 5×15=75행. min_qty=구간하한 NOT NULL·proc_cd=박색상 | small-l1.csv B03 H~M열 verbatim |

### C-6. COMP_FOIL_PROC_SMALL_SPECIAL — 소형 박가공비 특수박

C-5 동형. 단가행 = small-l1.csv B05 H~M열 verbatim(5×15=75행). ★주의: 소형 특수박은 색상 3종(백박/홀로그램/트윙클)만.

### ★ prc_typ=.01 + "작업 1건 고정금액" 가드 [HARD·돈크리티컬]

박가공비 수량별 단가는 **"제작수량 N 이상 / 작업 1건 고정 금액(수량을 곱하지 않음)"** (명함박 단가행 note·large/small 권위 동형). 즉:

- 단가표[등급][수량구간]에서 lookup한 값 = **그 주문 전체의 박가공비 총액**(개당가 아님). 예 대형 일반박 A등급·수량 1000 = 75,000원이 1,000매 전체 박가공비.
- **엔진 처리**: prc_typ=.01 단가형이면 `unit_price × qty`인데, 박가공비는 ×qty 하면 안 됨(75,000 × 1000 = 7,500만 폭발). → ★**명함박 선례 검증**: 명함박 본체는 `.02 합가형`+min_qty 구간이나 단가행 note가 "작업 1건 고정"이고 라이브 견적이 정상(63,000 그대로). 즉 **합가형(.02)이라도 min_qty=수량구간 매칭값이면 `per_item=unit÷min_qty`, ×qty=unit으로 되돌아와 "작업 1건 고정"이 성립**(아크릴 §3 동형 수학).

  ∴ **박가공비 comp는 `.02 합가형`으로 설계 + 단가행 min_qty=해당 수량구간 하한값** (명함박과 동일 메커니즘). 예 대형 A등급 1000구간 행: min_qty=1000·unit=75,000 → 손님 qty=1000일 때 `75,000÷1000×1000=75,000`(작업 1건 고정 성립). prc_typ=.01로 두면 ×qty 폭발하므로 **.02 + min_qty 구간 필수**. (C-3~C-6 prc_typ을 **.02로 정정** — §4 표의 .01은 ×qty 위험이라 부결. min_qty=구간하한 NOT NULL 가드[[acrylic min_qty NULL→ValueError]] 적용.)

  ★최종: C-3~C-6 **prc_typ_cd=PRICE_TYPE.02(합가형)·min_qty=수량구간 하한값 NOT NULL**. 면적등급은 dim_vals 또는 opt_cd 보조차원.

---

## 5. ★[REV2] 7상품 바인딩 = 본체 공식 formula_components 직접 합산 (proc_cd 미선택 시 0) [G5 재해소·B-FOIL-1 보정]

### 5-1. 결정 재결론: 본체 공식에 박 comp 직접 합산 (명함박/접지카드 라이브 작동 입증 패턴)

★ **이전 결론(addon 템플릿) 폐기.** validator E4 라이브 실측이 addon 템플릿의 다차원 박가공비 표현 불가를 확정했다(아래 부결 근거). **명함박이 이미 (a) 본체 공식 합산으로 라이브 작동**하므로 이를 정식 권고로 재설계한다.

| 안 | 채택 | 근거(라이브 실측 2026-06-30) |
|---|---|---|
| **(a) 본체 공식 formula_components 직접 합산** | **✓ 채택** | ★PRF_NAMECARD_FOIL이 박가공비 comp(COMP_NAMECARD_FOIL_S1_STD·.02)+동판비 comp(SETUP·.03)를 **공식 formula_components로 직접 합산**(SELECT 실증). PRF_DGP_E(접지카드)도 코팅·타공·접지 comp 8개를 본체 공식에 직접 합산하되 proc_cd 차원으로 선택분만 매칭. 라이브 광범위 작동 패턴 |
| (b) addon 템플릿 | ✗ **부결** | `t_prd_template_prices`=`tmpl_cd\|apply_ymd\|unit_price` 단일 고정단가만(차원 컬럼 0)·pricing.py:441-446=`unit_price×qty`. 박가공비 다차원(면적등급×수량구간×일반특수)을 담을 수 없고 넣으면 ×qty 폭발([[bandtotal-x-qty-overcharge]]·[[addon-optcd-model-broken-live]]). designer 이전 §5-3 "이중×qty 0 가드 통과" 단정 = addon 경로에서 **거짓**(validator B-FOIL-1 정당) |
| (c) 엔진 multi-dim addon 지원 | △ 보류 | 미확정(C트랙). (a)가 라이브 작동 입증이므로 (c) 전제 불필요 |

### 5-2. ★박 미선택 시 0 보장 메커니즘 [U-7·돈크리티컬 가드]

본체 공식에 박 comp를 합산해도 **박을 안 고른 주문은 0이 보장**된다 — 라이브 엔진 계약으로 검증:

1. **proc_cd 차원 매칭**: 박가공비 comp use_dims에 `["proc_cd","min_qty"]`(+ proc_grp:PROC_000033 그룹 메타). 손님이 박을 안 고르면 그 공정이 `proc_sels`에 없음 → `sel["proc_cd"]` 미충전 → 단가행 no_match → 합산 제외. pricing.py:576 주석 verbatim: **"미선택은 '데이터 없음'이 아니라 '미선택'(예: 공정 안 고름) — 빵꾸로 안 봄"**. 라이브 실증: PRF_DGP_E에 접지 comp 4개가 동시 배선됐지만 손님이 고른 접지 1개만 매칭·나머지 0(silent 이중합산 없음). ★[REV3·R-FOIL-CDX1] **동판비 comp도 동일 proc_cd 게이트 필수** — 박가공비만 proc_cd 게이트를 갖고 동판비(C-1/C-2)에 proc_cd가 없으면 박 미선택 주문에 사이즈만 맞으면 동판비가 와일드카드 통과(pricing.py:99-111 NULL=와일드카드)→상시 과금. REV2 §5-2가 동판비 게이트를 누락(이 논거는 박가공비 proc_cd에만 성립했음) → REV3에서 동판비까지 게이트 확장. ★게이트력=proc_cd·dim_vals만(R-FOIL-CDX3)·proc_grp는 그룹 식별 메타.
2. **박 그룹(proc_grp:PROC_000033) 한정**: 박 comp는 proc_cd가 박 자식공정(PROC_000034~049)일 때만 정확매칭 → 다른 후가공(코팅·접지 등) 선택은 proc_cd가 다른 그룹이라 박 comp를 깨우지 않음. ★[REV3·R-FOIL-CDX3] 실제 차단은 **proc_cd 정확매칭**이 한다(proc_grp는 그룹 식별 메타·차단 차원 아님). U-7 시트 차원경계(박 시트 안에서만) 준수.
3. **일반/특수 동시합산 가드**: 일반박 comp·특수박 comp 둘 다 본체 공식에 배선돼도, 손님 박색상이 일반박 그룹이면 일반 comp만 proc_cd 매칭·특수 comp는 no_match(0). 한 시점 1 comp만 활성(§2-2).

★ **결론**: 본체 공식 합산은 U-7 위반이 아니다 — proc_cd 판별차원이 박 미선택 시 silent 합산을 원천 차단한다(라이브 코팅/접지/타공이 이미 같은 공식에서 이렇게 작동). 이전 §5-1 "(나) 공식 침입=U-7 위반" 우려는 proc_cd 차원으로 해소됨(재고 결론).

### 5-3. 7상품 박색상 enum (상품별 사용 색상만·라이브 product_processes)

| prd_cd | 상품명 | 본체 공식(직접 합산 대상) | 박 시트(대형/소형 CONFIRM) | 박색상 등록(product_processes) | 면적등급 |
|---|---|---|---|---|---|
| PRD_000027 | 2단접지카드 | PRF_DGP_E | 대형(접지카드=대형 추정·G4) | 037~044 8종 | 가변→C트랙 |
| PRD_000029 | 3단접지카드 | PRF_DGP_E | 대형 | 037~044 8종 | 가변→C트랙 |
| PRD_000031 | 프리미엄명함 | PRF_NAMECARD_FIXED | 소형(명함=소형) | 037~044 8종 | 고정→collapse(엔진 작동) |
| PRD_000034 | 펄명함 | PRF_NAMECARD_PEARL | 소형 | 037~044 8종 | 고정→collapse(엔진 작동) |
| PRD_000042 | 프리미엄쿠폰/상품권 | PRF_DGP_A | 대형/소형 CONFIRM | (product_processes 확인 필요) | CONFIRM |
| PRD_000069 | 무선책자 | PRF_BIND_MUSEON | 대형 | (책자 박=표지 박·대형) | 가변→C트랙 |
| PRD_000070 | PUR책자 | PRF_BIND_PUR | 대형 | (표지 박·대형) | 가변→C트랙 |

★ **배선 절차(dbmap 위임·인간 승인)**: 각 본체 공식의 `t_prc_formula_components`에 박 comp(동판비 + 해당 시트 일반/특수 박가공비)를 행 추가. 명함박 PRF_NAMECARD_FOIL이 SETUP+가공비를 거는 동형. 상품별 등록 색상이 13종 전체 아님 → CPQ 옵션 레이어(option_items)가 **그 상품 실제 박색상 proc_cd만** 노출(없는 색상 청구 0). 오리지널박명함(37)은 기존 PRF_NAMECARD_FOIL 보존(미터치).

★ **면적등급 가변/고정 구분(§3-1 대안 연계)**: 명함/펄명함(사이즈 고정)은 면적이 단일등급 collapse → 박가공비 comp의 grade를 dim_vals 고정값으로 두면 **현 엔진으로 작동**(면적→등급 환산 불요). 접지카드·책자(사이즈 가변)는 면적→등급 환산 필요 → **C트랙 선결**(B-FOIL-2·Q-FOIL-CODE1).

### 5-4. 박 가격 = 동판비(1회) + 박가공비(작업1건 고정) — 이중 ×qty 0 [본체 합산 경로]

본체 공식 합산 시 박 가격 = `COMP_FOIL_SETUP_{LARGE|SMALL}`(.03) + `COMP_FOIL_PROC_{시트}_{일반|특수}`(.02). 둘 다 비-수량비례 — ★addon 경로의 ×qty 폭발 위험과 달리, 본체 공식 합산에서는 라이브 엔진 계약으로 안전:
- 동판비 .03 = 매칭 구간 금액 그대로(수량 무관·pricing.py:203-204·×qty 0). ★[REV3·R-FOIL-CDX1] 동판비 comp use_dims에 **proc_cd 필수**(C-1=`["proc_cd","siz_width","siz_height"]`·C-2=`["proc_cd"]`). proc_cd 없으면 박 미선택 주문에도 사이즈만 맞으면 동판비가 와일드카드 매칭(pricing.py:99-111)→상시 과금. 박가공비(.02)는 proc_cd 게이트로 박 미선택 시 0이지만 동판비도 동형 proc_cd 게이트를 걸어야 박 미선택 주문에서 동판비도 0이 된다. 명함박 SETUP `["min_qty"]`(proc_cd 없음·박 항상 거는 명함 전용 패턴) 답습 금지.
- 박가공비 .02 + min_qty=구간하한 = 구간 총액(per_item÷min_qty×qty=구간값일 때 unit 그대로·pricing.py:205-210). 명함박 1000구간 63,000이 ×1000 폭발 안 하고 63,000 그대로인 라이브 메커니즘 동형.
- ∴ 박 총액이 주문수량과 무관하게 "그 수량구간의 작업 1건 금액" → **이중 ×qty 폭발 0**(돈크리티컬 가드 통과). ★이 가드는 **본체 공식 합산 경로에서만 성립**(addon 템플릿 경로는 unit_price×qty라 폭발 — 그래서 addon 부결).

---

## 6. 대형/소형 경계 (G4·CONFIRM)

권위 시트에 "면적 ≤ X면 소형" 명시 임계 없음. 소형 격자 최대 80×80(6,400㎟) ↔ 대형 최소 30×30(900㎟) **면적 범위 겹침** → 단순 면적 자동분기 불가.

- **설계 결정: 상품별 시트 고정 지정**(자동 면적분기 안 함). 명함류=소형(라이브 명함박이 소형 차용)·접지카드/책자=대형. addon 템플릿이 상품마다 대형 또는 소형 comp 중 하나를 고정 배선.
- **CONFIRM Q-FOIL-SIZE1**: 프리미엄쿠폰(42)·일부 상품의 대형/소형 소속 = 실무진 확인. 또는 박영역 크기로 손님이 시트 선택(경쟁사 F-4 양자화 UX·위젯 트랙).

---

## 7. evaluate_price 계약 정합 체크 (설계 자기검증)

| 계약(engine-contract·pricing.py) | 설계 준수 |
|---|---|
| C7 frm_typ 미참조·공식=합산 | ✅ 동판비·박가공비 comp를 addon 합산으로 표현(frm_typ 무참조) |
| P3-8 ERR_AMBIGUOUS 금지(한 comp 단가행 사이) | ✅ 동판비=proc_cd+면적 정확매칭 1행. 박가공비=proc_cd+min_qty+등급 정확매칭 1행. 일반/특수 comp는 proc_cd 그룹으로 한쪽만 매칭 |
| P3-DEF 판별차원 없음 금지 / silent 이중합산 | ✅ ★[REV3·R-FOIL-CDX1] **동판비·박가공비 단가행 모두 proc_cd 충전**→박색상 정확매칭(§2-2·§5-2 가드). 동판비 use_dims=`["proc_cd","siz_width","siz_height"]`(대형)·`["proc_cd"]`(소형)로 박 미선택 시 no_match→0. **이전 REV2는 동판비 proc_cd 게이트 누락**(박 미선택 주문에 동판비 상시 과금 위험·codex 적발). 일반/특수 동시 합산 방지. ★박 미선택 시 no_match→0(pricing.py:576 라이브 실증)·게이트력=proc_cd·dim_vals만(proc_grp는 그룹 메타·R-FOIL-CDX3) |
| P4 단가형 ×qty / 합가형 min_qty 필수 | ✅ 동판비 .03(×qty 0)·박가공비 .02+min_qty=구간하한 NOT NULL(작업1건 고정·§5-4 가드·NULL→ValueError 회피). ★본체 공식 합산 경로 한정(addon 경로는 ×qty 폭발이라 부결) |
| TIER_UPPER siz_width/height '이하' ceiling | ✅ 동판비 off-grid=각 축 ceiling(엔진 내장). 박가공비 면적→등급은 앱 ceiling 후 등급 환산(§3·단 grade 환산은 코드트랙) |
| U-7 시트 차원경계(SOT 1) | ✅ ★[REV2] 박을 본체 공식에 합산하되 proc_cd 판별차원이 박 미선택 시 silent 합산 원천차단(라이브 코팅/접지가 동일 공식에서 작동). U-7 위반 아님(§5-2). 일반/특수 박은 박 시트 안에서만 |
| 면적→등급 2단 lookup | ⛔ **코드트랙 분리 [B-FOIL-2 확정]**: NON_QTY_DIMS/TIER_DIMS에 grade 없음(pricing.py:42-50 실측). 등급별 단가 그릇은 정확(골든 일치)·엔진 면적→등급 환산 지원이 선결. 고정사이즈 상품(명함/펄명함)=collapse로 현 엔진 작동·가변 상품(접지카드/책자)=C트랙. Q-FOIL-CODE1·dbm-price-arbiter |
| search-before-mint | ✅ 신규=5 comp(대형동판비 1·소형동판비 1·박가공비 4 중 대형/소형 일반·특수 4). 박 자식공정 **16종(034~049)**·아연판·proc_grp 패턴 재사용(0 mint). 명함박 미터치 |
| 명함박 1,000원 갭(G6) | ✅ 답습 안 함 — 7상품 단가행은 권위 verbatim(대형 64,000 등)·명함박 결함은 검증/C트랙 별도 |

---

## 8. designer 큐 잔여 (design-decisions-foil-rev2·golden으로 이관)

- **G1 박가공비 comp 신설 + 7상품 ★본체 공식 합산 바인딩**(§4·§5) = 1순위(돈크리티컬·박 0원 해소)·신규 5 comp·각 본체 공식 formula_components 행 추가·dbmap 위임. ★[REV2] addon 템플릿 부결→본체 공식 합산(명함박 라이브 작동 패턴). ★★[REV3·R-FOIL-CDX1] **동판비 comp(C-1/C-2) use_dims에 proc_cd 게이트 필수**(C-1=`["proc_cd","siz_width","siz_height"]`·C-2=`["proc_cd"]`)·단가행 proc_cd 충전. 박가공비만 게이트 갖고 동판비 누락 시 박 미선택 주문에 동판비 상시 과금(codex 적발·돈크리티컬). 명함박 SETUP use_dims=`["min_qty"]`(proc_cd 없음·박 항상 거는 명함 전용) **답습 금지** — 7상품은 박 선택형이라 proc_cd 충전 필수.
- **면적→등급 환산 엔진 지원**(§3·B-FOIL-2) → **코드트랙 분리 확정** Q-FOIL-CODE1(High)·dbm-price-arbiter. 등급 단가 그릇은 정확·환산 지원이 선결. 고정사이즈 상품(명함/펄명함)은 collapse로 현 엔진 작동.
- **박색상 일반/특수 동시합산 가드**(§2-2·§5-2) → proc_cd 판별차원 미선택 시 0 라이브 실증 완료(pricing.py:576).
- **대형/소형 경계**(§6) → Q-FOIL-SIZE1 실무 컨펌(상품별 시트 고정).
- **소형 동판비 명함박 SETUP 공유 vs 신설**(§4 C-2) → Q-FOIL-SETUP1(신설 권장).
- **명함박 1,000원 갭(1000구간 63,000 vs 권위 64,000=1셀 오적재)**(G6) → 명함박 별도 검증/C트랙·라이브 교정 후보(답습 금지·7상품은 권위 64,000 verbatim·미터치). validator 라이브 실측으로 "1셀 오적재" 확정(designer 추정 "동판비 미합산"은 반증=SETUP 5,000 별도 comp 실재).
</content>
</invoke>
