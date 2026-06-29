# gate-verdict-foil.md — 박류(foil) 설계 E1~E7 독립 검증 게이트

> hpe-validator(Claude) 독립 재실측 · 2026-06-30 · 생성자(designer) 주장 비신뢰·권위 박 시트+라이브 읽기전용 직접 재실측.
> 검증 대상: `03_design/{engine-design,design-decisions,golden-cases}-foil.md`.
> 권위[HARD]: 인쇄상품 가격표 박(대형/소형) 시트 > 라이브 t_prc_*/t_proc_* > 역공학/경쟁사.
> 단일 FAIL = NO-GO. 코드 지원 의존성은 "코드트랙 미확정"으로 분류(설계 결함과 구분).

---

## E1 — 공식 추출 충실성 · **PASS**

박 가격모델(동판비 + 박가공비 면적→등급→수량)이 권위 박 시트와 일치하는지 셀 단위 독립 재대조.

| 검사 | 결과 | 근거 |
|---|---|---|
| 동판비 대형=면적매트릭스(가로×세로) | ✅ | B01 9×8 격자 verbatim. 11,000(B3)~64,000(I10) 재확인(large-l1.csv:13·83) |
| 동판비 소형=고정 5,000 | ✅ | small-l1.csv:6 (B01 B3, 80x40 단일) |
| 박가공비=면적→등급 + 수량구간 2단 | ✅ | 대형 일반 B03(면적정의)+수량표(K~P), 특수 B04+B05. 소형 일반 B02+B03, 특수 B04+B05 구조 정합 |
| 일반/특수 단가 차등 | ✅ | 대형 C·1000 일반 120,000(N19) vs 특수 150,000(N39). 권위 실측 차등 확인 |
| 면적등급 격자 verbatim | ✅ | designer §3-2 표 전 셀 권위 일치(30×30=A·90×90=C·170×170=E·소형 40×40=D·40×80=E) |
| 수량구간 | ✅ | 대형 13구간(10~10000)·소형 일반 18구간(200~10000)·소형 특수 18구간. 권위 K/H열 verbatim |
| 날조/v03 인용 | ✅ 없음 | 전 값 권위 셀 출처 명기·v03 미참조 |

**미세 정정 요청(non-blocking):** designer §0이 박 자식공정 "13종(037~049)"이라 했으나 라이브 실측 = **16종**(PROC_000034 금·035 은·036 핑크 + 037~049). 박색상 축에는 037~049만 쓰나, "13종" 표기는 부정확(034~036도 박 자식). 설계 영향 없음(사용 색상만 바인딩).

---

## E2 — 구성요소 분해 정합 · **PASS**

5 신규 comp(SETUP_LARGE/SMALL·PROC_LARGE/SMALL_STD/SPECIAL) + use_dims가 권위 차원과 정합하는지.

| 검사 | 결과 | 근거 |
|---|---|---|
| 동판비 comp use_dims=[siz_width,siz_height] | ✅ | 엔진 TIER_DIMS=(siz_width,siz_height,min_qty)·TIER_UPPER 내장(pricing.py:49-50). 면적매트릭스 직접 지원 |
| 동판비 prc_typ=.03(1회·×qty 0) | ✅ | component_subtotal:203-204 .03=곱셈 없음. 동판=1회 제작비 정합 |
| 박가공비 면적→등급 앱계산·DB=등급단가 | ✅ 설계타당 | 등급격자 직접 펼침(936행) 회피·[[dbmap-compute-in-app-db-stores-lookup]] 정합. 단 코드트랙(E4) |
| 일반/특수 2 comp 분리 | ✅ | 권위가 일반/특수 단가 다름(120k vs 150k) → 2 comp 정당 |
| silent 이중합산 가드(일반·특수 동시) | △ 설계의도 OK·라이브 미작동(E4 참조) | designer §2-2 proc_cd 판별차원 충전 의도는 타당하나, addon 경로에선 proc_cd 차원 매칭 자체가 작동 안 함(E4 발견7) |
| 완제품/반제품·시트경계 | ✅ | 박=본체 직교 후가공·시트(박 대형/소형) 안 |

★ **명함박 comp 오설명 정정(non-blocking):** designer §4 C-3 주석 "명함박 .06=종이통가와 달리 박만"은 라이브와 **불일치** — 명함박 S1_STD는 comp_typ_cd `PRC_COMPONENT_TYPE.06`이고 comp_nm="...완제품가...(종이+동판+박)"으로 **종이+동판+박 통합 완제품가**다(박 단독 아님). 신규 7상품 comp 설계엔 영향 없으나 근거 주석 부정확.

---

## E3 — 경쟁사 흡수 타당성 · **PASS**

| 검사 | 결과 | 근거 |
|---|---|---|
| 동판비 ×qty 금지 가드 | ✅ | .03 설계·design-decisions 결정점5-1 |
| 박가공비 이중 ×qty 금지 가드 | ✅ 설계의도 | .02+min_qty=구간하한 → 작업1건 고정 수학(단 addon 경로 미작동·E4) |
| F-3 면적비율 추가금 미도입(권위=절대 mm 등급) | ✅ | 권위 덮어쓰기 회피. 후니 절대등급 유지 |
| naming/codes 유입 0 | ✅ | comp_nm=후니 표준(박·형압 동판셋업비 등)·레드 "동판 금형" 미유입 |
| 후니 표현력 초과 mint 0 | ✅ | proc_cd/proc_grp 재사용·신규=5 comp만 |

---

## E4 — 엔진 설계 건전성 · **CONDITIONAL (코드트랙 미확정 2건·설계 자체 결함 0)**

★ 검증 핵심. prc_typ·차원·addon 바인딩이 라이브 evaluate_price 계약과 정합하는지 직접 실측.

| 검사 | 결과 | 근거 |
|---|---|---|
| 동판비 prc_typ=.03·×qty 금지 | ✅ PASS | component_subtotal:203(.03=곱셈없음). 라이브 SETUP_S1_STD=.03 선례 |
| **박가공비 prc_typ=.02(designer 정정)** | ✅ PASS | designer가 inventory의 .01 후보를 **.02로 정정**한 것은 **옳음**. .01이면 unit×qty 폭발(component_subtotal:212). .02+min_qty=구간하한이면 (총액÷구간하한)×qty=구간일치 시 총액 그대로(:205-210). 박 권위="작업1건 총액(곱하지 않음)"에 정합. ★라이브 후가공(BIND/FOLD/CUT_PERF)은 전부 .01+min_qty=장당가 모델이라 박과 데이터 모델 다름 — designer가 답습 안 하고 .02로 간 판단 정당 |
| min_qty NOT NULL 가드 | ✅ PASS | .02는 base<=0 시 ValueError(:207-208). designer 전건 min_qty=구간하한 명시 |
| proc_cd+proc_grp 차원 패턴 라이브 실재 | ✅ PASS | BIND(PROC_000017)·FOLD(056)·CUT_PERF(079)·COAT(013) 등 광범위 선례 실측. NON_QTY_DIMS에 proc_cd 포함(pricing.py:42) |
| 박 자식공정 13종 재사용(mint 0) | ✅ PASS | PROC_000037~049 라이브 use_yn=Y·del_yn=N 실재. search-before-mint 강충족 |
| **★면적→등급(grade) 환산 엔진 지원** | ⛔ **코드트랙 미확정** | 라이브 엔진 NON_QTY_DIMS/TIER_DIMS에 **grade 없음**(pricing.py:42-50). dim_vals JSON grade는 정확매칭 차원이지 면적→등급 환산 아님. **앱이 면적→등급 환산 후 grade를 selection으로 넘겨야** 작동. 현 엔진 미지원 → 개발팀 C트랙. designer Q-FOIL-CODE1 정직 분류 |
| **★addon 템플릿 4축 가격 지원** | ⛔ **코드트랙 미확정 + 설계 위험** | ★라이브 실측: t_prd_template_prices=`tmpl_cd|apply_ymd|unit_price` **단일 고정단가만**(차원 컬럼 0). pricing.py:441-446 템플릿가=`unit_price×qty`(차원매칭 없음). ∴ addon 템플릿은 (면적등급×수량×박색상) 다차원 박가공비를 **담을 수 없고**, 넣으면 ×qty 폭발([[bandtotal-x-qty-overcharge]] 재현). designer §5-3 "이중×qty 0·가드 통과" 단정은 라이브 addon 메커니즘과 **어긋남** |
| ERR_AMBIGUOUS 방지(단가행 1행) | ✅ PASS(설계의도) | 동판비=면적 정확매칭·박가공비=proc_cd+min_qty+grade 매칭(grade가 엔진 지원 시) |
| 채번·FK 위상 | ✅ | comp_cd=COMP_FOIL_*(MAX+1·dbmap 채번 위임). proc_cd/proc_grp FK 실재 |

**E4 판정 = CONDITIONAL PASS.** 설계 자체(prc_typ·차원·verbatim)는 건전. 단 ① 면적→등급 환산 ② addon 4축 가격 = **둘 다 라이브 엔진/스키마 미지원**(코드트랙). designer가 둘 다 Q-FOIL-CODE1로 정직 분류한 것은 생성≠검증 정합이나, **§5-3 "이중×qty 폭발 0 가드 통과" 단정은 addon 경로에서 거짓**(보정 요청). 단가행을 채워도 addon 템플릿 단일고정가 구조로는 박이 옳게 계산 안 됨. → 대안: 박가공비를 **본체 공식의 분기 comp**(proc_cd 판별차원)로 두거나 엔진에 grade·면적환산·multi-dim addon 지원 추가(C트랙). designer §5-1 "(나) 공식 침입 부결" 결론이 라이브 제약상 재고 대상.

---

## E5 — 세트(반제품) 조합 정합 · **PASS (해당 약함)**

| 검사 | 결과 | 근거 |
|---|---|---|
| 박이 책자(무선69/PUR70)에 addon으로 본체 이중합산 | ✅ 설계상 직교 | 박=표지 후가공·본체 제본/내지 공식과 차원 직교. 동판비+박가공비만 가산·본체 미침범 |
| 접지카드(27/29) 본체+박 이중계상 | ✅ 없음(설계상) | 박가공비는 박 시트 단가만·접지비(FOLD comp)와 별 comp |
| 번들 할인 박 적용 오류 | N/A | 박은 수량구간 자체 lookup·번들과 무관 |

★ 단 E4의 addon 4축 미작동이 해소돼야 책자/접지카드 박 가산이 실제 작동. 세트 조합 **논리**는 무모순이나 **작동**은 E4 코드트랙에 종속.

---

## E6 — 골든 재현(허용오차 0) · **PASS**

8 골든 케이스를 권위 박 시트 셀로 **독립 재계산**(recompute-log-foil.md). designer 기대값 베끼지 않고 권위 셀 인용→합산.

| 케이스 | designer | validator 독립 | 일치 |
|---|---|---|---|
| G-F1 대형일반 90×90·1000 | 138,000 | 138,000 | ✅ |
| G-F2 대형특수 90×90·1000 | 168,000 | 168,000 | ✅ |
| G-F3 대형일반 30×30·10 | 66,000 | 66,000 | ✅ |
| G-F4 소형일반 40×80·1000 | 69,000 | 69,000 | ✅ |
| G-F5 소형특수 10×10·200 | 19,300 | 19,300 | ✅(격자빈칸 ceiling 경유) |
| G-F6 대형일반 75×85 off-grid | 138,000 | 138,000 | ✅(면적등급 ceiling) |
| G-F7 대형특수 170×170·1000 | 314,000 | 314,000 | ✅ |
| G-F8 소형일반 40×40·500 | 37,500 | 37,500 | ✅ |

**8/8 권위 verbatim 합산 일치·허용오차 0·날조 0.**
★ G6 명함박 갭(63,000 vs 64,000): 라이브 실측으로 **1000구간 단가행 1셀 −1,000 오적재**로 확정(designer 추정 "(나) 동판비 미합산"은 반증). designer 결론(7상품 권위 64,000 verbatim·답습 금지)은 올바름.
★ E6 PASS는 **산술 일치**이며, 실 엔진 재현(grade 환산·multi-dim addon)은 E4 코드트랙 종속(evaluate_price 실호출 미수행 — 면적→등급·4축 addon 미지원이라 실호출 무의미·동치 재구현으로 산술 검증).

---

## E7 — 생성-검증 독립성 · **PASS**

| 검사 | 결과 |
|---|---|
| designer 기대값 베끼지 않고 권위 셀 직접 재실측 | ✅ recompute-log 전 케이스 권위 file:line 인용 |
| 라이브 직접 SELECT 교차(명함박 갭·proc 13종·addon 구조·pricing.py) | ✅ 6개 라이브 쿼리+pricing.py 코드 직접 확인 |
| self-approve/dodge-hunt 회피 | ✅ E4에서 designer §5-3 단정을 라이브 addon 메커니즘으로 **반증**(addon 단일고정가×qty)·designer §0 "13종"·§4 명함박 .06 주석 정정 |
| 순환참조(설계값으로 골든 만들고 그걸로 재현) 적발 | ✅ 없음 — 골든값이 전부 권위 셀 추적 가능·설계 자기참조 아님 |

---

## 게이트 종합

| 게이트 | 판정 |
|---|---|
| E1 공식 추출 충실성 | PASS |
| E2 구성요소 분해 정합 | PASS |
| E3 경쟁사 흡수 타당성 | PASS |
| **E4 엔진 설계 건전성** | **CONDITIONAL**(설계결함 0·코드트랙 2건·§5-3 단정 보정요청) |
| E5 세트 조합 정합 | PASS(작동은 E4 종속) |
| E6 골든 재현 | PASS(산술 허용오차 0·실재현 E4 종속) |
| E7 생성-검증 독립성 | PASS |

**종합 = 조건부 GO** (단일 FAIL 없음·E4가 설계 자체 결함 0이나 코드트랙 의존 2건 + §5-3 거짓단정 보정). validation-summary-foil.md 참조.
