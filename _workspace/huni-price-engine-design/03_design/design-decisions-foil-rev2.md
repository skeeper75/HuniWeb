# design-decisions-foil-rev2.md — 박류(foil) 설계 폐루프 보정 REV2 변경 이력

> hpe-engine-designer 폐루프 보정 · 2026-06-30 · validator E4 **CONDITIONAL** 판정에 대한 designer 재결정.
> 입력: `04_validation/{gate-verdict-foil,validation-summary-foil,recompute-log-foil}.md`(validator E1~E7).
> 보정 대상: `03_design/{engine-design-foil,design-decisions-foil}.md`(REV1). 골든(`golden-cases-foil.md`)은 **변경 없음**(8/8 권위 verbatim 일치·E6 PASS).
> 권위[HARD]: 가격표 박(대형/소형) 시트 절대 · 단가 verbatim · DB 미적재 · 라이브 읽기전용 · webadmin 코드 직접수정 금지 · 바인딩=라이브 작동 입증 패턴 우선.

---

## 0. 보정 트리거 — validator E4 CONDITIONAL (설계결함 0·코드트랙 2건·단정 1건)

validator는 E1·E2·E3·E5·E6·E7 PASS, **E4만 CONDITIONAL**으로 판정했다. 데이터 그릇 설계(공식 추출·구성요소 분해·골든 산술)는 권위 verbatim 정합·허용오차 0(GO 수준). 막는 것은 ① addon 바인딩이 라이브 메커니즘에 어긋남(돈크리티컬) ② 면적→등급 환산 엔진 미지원(코드트랙) ③ 근거 서술 부정확 2건. REV2는 이 3건을 폐루프 보정한다.

---

## 1. B-FOIL-1 [돈크리티컬·재결정] — 바인딩: addon 템플릿 → 본체 공식 합산

### 1-1. validator 발견 (라이브 실측)

`t_prd_template_prices` = `tmpl_cd | apply_ymd | unit_price` **단일 고정단가만**(차원 컬럼 0). `pricing.py:441-446`이 템플릿가 = `unit_price × qty`(차원매칭 전무). ∴ addon 템플릿엔 박가공비 다차원(면적등급×수량구간×일반특수)을 담을 수 없고, 단일값을 넣으면 ×qty 폭발([[bandtotal-x-qty-overcharge]] 재현·예 박가공비 75,000을 템플릿가로 → 1000매면 7,500만). REV1 §5-3 "동판비+박가공비 둘 다 비-수량비례→이중×qty 0·가드 통과" 단정은 addon 경로에서 **거짓**.

### 1-2. designer 재결정 = (a) 본체 공식 formula_components 직접 합산 채택

★ **라이브 작동 입증 패턴을 정식 권고로 재설계.** designer 독립 라이브 SELECT(2026-06-30)로 다음을 실증:

| 실증 | 라이브 SELECT 결과 |
|---|---|
| 명함박 공식이 박 comp를 직접 합산 | PRF_NAMECARD_FOIL의 formula_components = **COMP_NAMECARD_FOIL_S1_STD(.02·박가공비)** + **COMP_NAMECARD_FOIL_SETUP_S1_STD(.03·동판비)** 2행. addon 아닌 공식 직접 합산 |
| 후가공 comp가 본체 공식에 합산되는 광범위 선례 | PRF_DGP_E(접지카드)에 COMP_COAT_GLOSSY/MATTE·COMP_CUT_PERF_1H6·COMP_FOLD_LEAF_{3FOLD,4ACC,4GATE,HALF} 7개 후가공 comp가 본체 공식에 직접 합산. use_dims=`["proc_cd","min_qty","proc_grp:PROC_XXX"]` |
| 박 미선택 시 0 보장 | pricing.py:576 verbatim "미선택은 '데이터 없음'이 아니라 '미선택'(예: 공정 안 고름) — 빵꾸로 안 봄". 손님이 안 고른 후가공 proc_cd는 no_match→합산 제외(접지카드는 접지 4개 배선됐어도 선택분 1개만 매칭) |
| 박가공비 ×qty 폭발 0(본체 합산 경로) | 명함박 1000구간 단가행 63,000이 ×1000 폭발 안 함(.02+min_qty=구간하한 메커니즘·pricing.py:205-210) |

**∴ 박 comp(동판비+박가공비 일반/특수)를 각 7상품 본체 공식의 `t_prc_formula_components`에 직접 합산 배선.** proc_cd(박 자식공정)+proc_grp:PROC_000033(박 그룹) 차원으로 박 선택 시만 매칭·미선택 시 0. 명함박/접지카드와 동형. addon 템플릿 부결.

### 1-3. U-7 위반 우려 해소 (REV1 부결 사유 재고)

REV1은 "공식에 박 comp 추가=U-7 시트 차원경계 위반·silent 합산"이라 부결했으나, **proc_cd 판별차원이 박 미선택 시 silent 합산을 원천 차단**(라이브 코팅/접지/타공이 이미 동일 공식에서 이렇게 작동). 본체 공식 합산은 U-7 위반이 아니고 라이브 검증된 정합 패턴. 박이 mand화되지도 않음(proc_cd 미선택=0).

> ★★ **[REV3 정정·R-FOIL-CDX1] 이 "박 미선택 0" 논거는 박가공비 comp(C-3~C-6·use_dims에 proc_cd 보유)에만 성립했고, 동판비 comp(C-1/C-2)에는 proc_cd 게이트가 없어 적용되지 않았다(codex 2차 교차 적발·돈크리티컬).** `pricing.py:99-111 _row_matches`는 행 차원이 NULL이면 와일드카드 통과 → 동판비 단가행에 proc_cd가 NULL이면 박 미선택 주문에도 사이즈(siz_width/height)만 맞으면 동판비(소형 5,000·대형 11,000~64,000)가 상시 매칭→과청구. ∴ REV3에서 동판비 use_dims에 proc_cd를 추가(C-1=`["proc_cd","siz_width","siz_height"]`·C-2=`["proc_cd"]`)하고 단가행에 proc_cd를 충전해, 박 미선택 시 동판비도 박가공비와 동형으로 0이 되도록 확장 정정한다. 라이브 재실측: 명함박 SETUP=`["min_qty"]`(proc_cd 없음)은 박을 **항상 거는 전용 상품**이라 게이트 불요 — 7상품(박 선택형)은 이 명함박 패턴을 답습하면 안 되고 proc_cd 충전 필수. 변경 이력=`design-decisions-foil-rev3.md`.

### 1-4. 반영 위치

- `engine-design-foil.md` §5 전면 재작성(5-1 결정 재결론·5-2 미선택 0 보장 메커니즘·5-3 7상품 본체 공식 배선 절차·5-4 ×qty 0 가드 본체 경로 한정). §0 핵심요약·§1 합산형 표·§7 계약표 U-7 갱신.
- `design-decisions-foil.md` 결정점4 재결론·결정점5 가드 본체 경로 한정·CONFIRM 큐 addon 4축 질문 종결.

---

## 2. B-FOIL-2 [코드트랙·분리 명기] — 면적→등급 환산 엔진 미지원

### 2-1. validator 발견 (라이브 실측)

`pricing.py:42-50` NON_QTY_DIMS=(siz_cd·plt_siz_cd·print_opt_cd·mat_cd·proc_cd·opt_cd·coat_side_cnt·bdl_qty)·TIER_DIMS=(siz_width·siz_height·min_qty)에 **grade·면적→등급 환산 없음**. dim_vals JSON grade는 정확매칭 차원일 뿐 면적값→등급 변환이 아님. 앱이 면적→등급 환산 후 grade를 selection으로 넘겨야 작동. designer 독립 재확인(NON_QTY_DIMS/TIER_DIMS sed 실측).

### 2-2. designer 명기

- **설계 명기**: "등급별 단가 그릇은 정확(골든 8/8 권위 verbatim 일치)·엔진의 면적→등급 환산 지원이 선결." 설계 결함 아님(데이터 그릇 건전·엔진 능력 미확정).
- **대안(상품별 구분)**: 고정사이즈 상품(명함박·펄명함 등)은 면적이 단일등급으로 collapse(환산 불요) → 박가공비 comp의 grade를 dim_vals 고정값으로 두면 **현 엔진으로 작동**. 명함박 단가행이 use_dims=`["min_qty"]`·dim_vals 비어있음(단일등급 E collapse)으로 라이브 실증. 사이즈 가변 상품(접지카드·책자 표지)만 면적→등급 환산 필요 → C트랙 종속.
- **라우팅**: 개발팀 **C트랙** + dbm-price-arbiter 심의(Q-FOIL-CODE1·우선도 **High** 격상).

### 2-3. 반영 위치

`engine-design-foil.md` §3-1 코드트랙 분리 강화·§5-3 면적등급 가변/고정 구분·§7 계약표. `design-decisions-foil.md` 결정점2/4·CONFIRM 큐.

---

## 3. B-FOIL-3 [non-blocking 정정] — 근거 서술 2건

| 항목 | REV1(부정확) | REV2(정정·라이브 실측) |
|---|---|---|
| §0 박 자식공정 종수 | "13종(037~049)" | **16종**(PROC_000034 금·035 은·036 핑크 + 037~049 박색상 13종). parent=PROC_000033·전건 use_yn=Y·del_yn=N. 박색상 enum엔 037~049만 사용 |
| §4 C-3 명함박 comp 주석 | "명함박 .06=종이통가와 달리 박만" | 명함박 S1_STD는 `.06`·comp_nm="오리지널박명함 완제품가...(종이+동판+박)"=**종이+동판+박 통합 완제품가**(박 단독 아님). 7상품 박가공비는 본체와 분리된 박 단독 .01이라 명함박과 모델 다름 |

신규 7상품 comp 설계엔 무영향(근거 주석만 정정).

---

## 4. G6 [확정·답습 금지] — 명함박 1000구간 1셀 오적재

validator 라이브 실측 + designer 재확인: 명함박 `COMP_NAMECARD_FOIL_S1_STD` 단가행 = 200=19,200 / 300=24,800 / 500=36,000 / 700=47,200 / 900=58,400(권위 소형 일반박 E등급 verbatim 일치) / **1000=63,000** vs 권위 M18=**64,000** → **단일 셀 −1,000 오적재 확정**. SETUP_S1_STD=5,000 별도 comp 실재 → REV1 추정 "(나) 동판비 미합산"은 **반증**(동판비는 SETUP comp로 합산됨·갭은 1000구간 1셀 오적재뿐).

- **7상품 설계**: 권위 64,000 verbatim 반영(라이브 오적재 답습 금지). 골든 G-F4 소형 일반박 E등급 1000=64,000 그대로.
- **명함박 라이브**: 1셀 교정 후보로 기록(63,000→64,000·검증 트랙 §13/§21·인간 승인). 박 설계와 무관·명함박 미터치.

---

## 5. CONFIRM 큐 갱신 (REV2)

| ID | REV2 상태 |
|---|---|
| Q-FOIL-CODE1 | ⛔ 면적→등급 환산 **미지원 확정**·C트랙(High). addon 4축 질문은 본체 공식 합산 전환으로 **종결**(소멸). 고정사이즈 상품=collapse로 현 엔진 작동 |
| Q-FOIL-SIZE1 | 유효(권위 면적임계 없음·범위겹침)·실무진 컨펌·Medium |
| Q-FOIL-SETUP1 | 신설 권장 유효([[base-master-code-no-delete]])·Low |
| Q-FOIL-FACE1 | 권위에 면 차원 없음 확인·실무진 컨펌·Medium |
| Q-FOIL-G6 | ✅ 1셀 오적재 확정·명함박 라이브 교정 후보·답습 금지·Medium |

---

## 6. 다음 행동 (라우팅)

1. **dbmap 위임(인간 승인 후)** — G1 박가공비 5 comp 신설 + 각 7상품 본체 공식 formula_components에 박 comp 직접 합산 배선 행 추가(명함박 동형). 단가행 권위 verbatim. comp_cd=COMP_FOIL_*(MAX+1·separator `_`).
2. **dbm-price-arbiter 심의** — B-FOIL-2 면적→등급 환산(grade) 엔진 지원 처방(Q-FOIL-CODE1 High). 고정사이즈 상품 우선 적재(collapse·현 엔진 작동)·가변 상품은 C트랙 선결.
3. **검증/C트랙** — G6 명함박 1셀 오적재(63,000→64,000) 별도 라이브 교정 후보.
4. **재검증 라우팅** — REV2 설계를 validator E4 재게이트(addon→본체 합산 전환·B-FOIL-1 정정 반영 확인) + codex 2차 교차.

★ **요약**: 박 가격모델 추출·골든 산술은 정확(GO 수준·불변). REV2 보정 = ① 바인딩을 라이브 작동 입증 패턴(본체 공식 합산)으로 재결정해 돈크리티컬 ×qty 폭발 위험 제거 ② 면적→등급 환산 코드트랙 분리 명기 ③ 근거 2건 정정. 데이터 그릇은 건전·**엔진의 면적→등급 환산 지원 확정 전 가변상품 적재 보류**가 정합(돈크리티컬).
