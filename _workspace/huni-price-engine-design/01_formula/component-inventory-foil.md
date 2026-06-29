# 박류(foil) 가격구성요소 인벤토리 — component-inventory-foil

작성: hpe-formula-cartographer · 2026-06-30 · 권위=가격표 박 시트 · 라이브=`live-snapshot/latest/`
규칙: search-before-mint · 단가 verbatim · 날조 0 · DB 미적재 · 불명=CONFIRM

---

## 1. 필요 가격구성요소 후보 (designer가 mint 결정)

박 후가공 가격에 필요한 구성요소는 **2종 + (선택)1종**:

### C-1. 동판비 setup comp (박·형압 동판 제작비)
| 속성 | 후보값 | 근거 |
|---|---|---|
| comp_typ_cd | PRC_COMPONENT_TYPE.05 (셋업) | 라이브 COMP_NAMECARD_FOIL_SETUP_* 동일 |
| prc_typ_cd | PRICE_TYPE.03 (작업당 1회 고정) | 수량 미곱(권위 "1회 고정"·라이브 SETUP=PRICE_TYPE.03) |
| use_dims (소형) | `[]` 또는 `["min_qty"]` | 소형=단일값 5,000 |
| use_dims (대형) | `["siz_width","siz_height"]` | 대형=가로×세로 면적매트릭스(B01) |
| 단가소스 | 소형 B3=5,000 / 대형 B01 9×8 격자(11,000~64,000) | price-foil-{small,large}-l1.csv B01 |

### C-2. 박가공비 area comp (면적등급 × 수량 × 일반/특수)
| 속성 | 후보값 | 근거 |
|---|---|---|
| comp_typ_cd | PRC_COMPONENT_TYPE.01 (가공비) 또는 .06(완제품가) | 라이브 명함박=.06(종이포함 통가). 박 단독 가공비면 .01 |
| prc_typ_cd | PRICE_TYPE.02 (합가형) | 라이브 FOIL 본체=.02. 면적등급별 합가 |
| use_dims | `["siz_width","siz_height","min_qty"]` (+박색상축) | 면적→등급 + 수량구간. 아크릴 COMP_ACRYL_CLEAR3T가 동형(siz_width/siz_height/min_qty) |
| 단가소스 | 대형 B03/B04 K~P열 · 소형 B02/B04 H~M열 | 등급(A~E)×수량 격자 |

### C-3. (선택) 박색상 구분 — 일반박/특수박 (표현축 미정)
- 일반박과 특수박은 **같은 (등급×수량)이라도 단가가 다름** → 반드시 구분 필요.
- 표현 방식 4안 (§3 trade-off) → designer 결정. 단일 comp의 차원으로? 별도 comp로? print_opt로?

---

## 2. use_dims 차원 후보 — 상세

| 차원키 | 박에서의 의미 | 단가 소스 | 비고 |
|---|---|---|---|
| `siz_width` | 박 가로(mm) | B01 동판비 행 / B03·B02 면적정의 행 | 30~170(대형)·10~80(소형) |
| `siz_height` | 박 세로(mm) | B01 열 / B03·B02 면적정의 열 | 동판비는 가로×세로 직접단가. 가공비는 면적→등급 변환 |
| `min_qty` | 수량구간 | B03 K열 / B02 H열 | 대형 10~10000(13구간) · 소형 200~10000(15구간) |
| **(등급 A~E)** | 면적이 환산되는 중간축 | B03/B02 L~P열 컬럼 헤더 | ★단가행에 직접 등급 컬럼 없음 → dim_vals JSON 또는 면적행 전개 필요(gap G3) |
| **(박색상종류)** | 일반박 vs 특수박 | B03(일반)/B04(특수) 분리 블록 | ★표현축 미정(gap G2) |

---

## 3. 박색상축 표현 — 4안 trade-off (★designer 결정)

박 종류(금유광/은유광/홀로그램/트윙클...)와 일반/특수 구분을 어디에 담을지.

| 안 | 방식 | 장점 | 단점 | 라이브 선례 |
|---|---|---|---|---|
| **A. comp 분리** | COMP_FOIL_STD / COMP_FOIL_SPECIAL 2 comp, 공식에 둘 다 배선+택1 제약 | 단가표 깔끔(블록=comp 1:1) | comp 수 증가·택1 제약 필요 | 명함박 S1_STD/S1_HOLO가 이 방식(STD/HOLO 분리) |
| **B. print_opt_cd 차원** | 단일 comp + use_dims에 print_opt_cd, 박색상=print_opt 코드 | 단가행 1묶음 | print_opt는 도수(인쇄옵션)용 의미축 → 박색상에 오용 우려 | 도수=POPT_000008(MEMORY) — 박색상 아님 |
| **C. proc_cd 차원(박 자식공정)** | 단일 comp + use_dims에 proc_cd, PROC_000037~049 박색상별 자식공정 | 라이브에 박색상별 자식공정 18종 이미 존재(search-before-mint 충족) | 단가행마다 proc_cd 필요·일반/특수 그룹핑은 별도 매핑 | ★박 자식공정이 이미 PROC_000033 아래 정리됨(가장 자연스러움) |
| **D. opt_cd 차원** | 옵션그룹+옵션항목으로 박색상 선택, comp use_dims=opt_cd | CPQ UI 자연스러움 | ★addon opt_cd 가산 모델 라이브 미작동 이력(MEMORY addon-optcd-model-broken-live) | 위험 |

- ★권장 출발점(designer 검토용): **C(proc_cd)** — 박색상별 자식공정(PROC_000034~049)이 라이브에 이미 18종 정리돼 있어 search-before-mint 부합. 일반/특수 그룹은 단가행 묶음으로 가름. 단, 명함박 선례는 A(comp 분리)이므로 동형 전파 시 A가 일관성 유리. **두 안의 정합을 designer가 판단**.

---

## 4. search-before-mint — 재사용 가능 기존 자원

| 기존 자원 | 재사용 가능성 | 비고 |
|---|---|---|
| COMP_NAMECARD_FOIL_S1/S2_STD/HOLO (4) | ❌ 명함 전용(E등급 collapse·면적 미가변) | 7상품은 면적 가변 → 차용 불가. 패턴만 참조 |
| COMP_NAMECARD_FOIL_SETUP_S1/S2_STD (2) | △ 소형 동판비 5,000과 동일 | 소형 명함 한정. 대형은 면적매트릭스 동판비 신규 필요 |
| PROC_000033(박) + 자식 18종(034~049) | ✅ 박색상축에 그대로 재사용 | 신규 mint 불요. 일반/특수 그룹핑만 매핑 |
| PROC_000050(형압) | ✅ 동판 패턴 동형 | 라이브 미사용이나 등록됨. 박과 동일 그릇 |
| 아크릴 COMP_ACRYL_CLEAR3T use_dims=[mat_cd,siz_width,siz_height,min_qty] | ✅ 면적×수량 패턴 차용 | 박가공비 면적매트릭스 use_dims 템플릿 |
| 아연판 | = 동판비 동의어(별도 코드 아님) | 신규 mint 불요 |

→ ★신규 mint 후보: **일반 박가공비 comp(소형/대형 × 일반/특수 = 최대 4) + 대형 동판비 comp(1)**. 박 자식공정은 재사용. 정확한 mint 개수는 §3 박색상축 안에 따라 달라짐 → designer 결정.

---

## 5. 단가행 적재 규모 추정 (참고)

| comp | 단가행 수(대략) | 차원 조합 |
|---|---|---|
| 대형 동판비 | 9×8 = 72행 | siz_width × siz_height |
| 대형 일반박 가공비 | 5등급 × 13수량 = 65행 | 등급×수량 (면적→등급 변환표 별도) |
| 대형 특수박 가공비 | 5 × 13 = 65행 | |
| 소형 동판비 | 1행 | 5,000 단일 |
| 소형 일반박 가공비 | 5 × 15 = 75행 | |
| 소형 특수박 가공비 | 5 × 15 = 75행 | |
| 면적→등급 변환표(대형) | 9×8 = 72셀(등급 라벨) | siz_width × siz_height → A~E |
| 면적→등급 변환표(소형) | 5×5 = 25셀 | |

→ 면적→등급 변환을 어떻게 저장할지가 적재 규모·스키마의 핵심(gap G3).
