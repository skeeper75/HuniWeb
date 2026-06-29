# 문구 파일럿 설계 결정·근거 (260629)

PRICE-IN-SHEET 트랙(채점 로봇 UNBOUND-PRICE-IN-SHEET 실해소) · §18 설계 · 라이브 읽기전용 + DRY-RUN

> 기존 03_design 정본 `engine-design-stationery.md`(6/20)는 라이브 실측·DRY-RUN 전 버전.
> 본 문서 = 라이브 실측 기반 보강·결정 로그. 실 COMMIT 시 정본 동기화 권고.

---

## D1. 가격모델 판정 — 고정 per-unit 단가형(.06/.01), 면적/구간매트릭스 아님
- **근거**: stationery-l1.csv `가격` 컬럼이 상품×사이즈당 **단일 정수값**(9000/12000/…). 면적(가로×세로)·
  판수·구간단가 매트릭스 없음. 수량 영향은 별도 `문구 구간할인`(rate). → 떡메·포토북 BASE 동형(.06/.01).
- **trade-off**: 합가형(.02·구간총액)·고정금액(.03·수량무관) 후보 검토 → 둘 다 부적합. 문구는 "단가×수량 후
  rate할인"이라 .01 단가형이 유일 정합(엔진 component_subtotal pricing.py:214 = unit_price × qty).

## D2. 상품별 1:1 공식 — 공유 공식 불가 입증(돈크리티컬)
- **사실**: 만년다이어리 4종 전부 SIZ_000375(단가 9000/12000/15000/15000) · 먼슬리(176)·스프링노트(177) 둘 다
  SIZ_000170(12000/4500). 같은 siz_cd에 단가 복수 → 공유 comp+siz_cd 차원으로 못 가름(ERR_AMBIGUOUS 또는 충돌).
- **결정**: 상품별 전용 공식 PRF_STN_<상품> + 전용 구성요소 COMP_STN_<상품> 1:1(메모리
  `dbmap-price-chain-dwire-per-product-formula` 정합). 메모패드만 1상품 siz_cd 2값 → 1공식 2단가행.
- **U-7 준수**: 전용 comp이라 타상품 단가행 silent 합산 불가. use_dims=["siz_cd","min_qty"]에 판별차원
  siz_cd 존재 → "전부 NULL→항상매칭" 위반 0. 시트 차원경계(SOT 1) 안에서만 배선.

## D3. 흡수 적용(경쟁사/포토북) — 포토북 BASE 패턴 흡수, naming 유입 0
- 포토북 `COMP_PHOTOBOOK_BASE`(.06/.01·siz_cd 차원·단가행 verbatim) 패턴을 그대로 흡수. 094 `COMP_PCB_*`·
  떡메 `COMP_TTEOKME` 동형. 경쟁사 가격 흡수 없음(문구는 후니 권위 시트에 단가 완비 — 갭헌팅 불요).
- naming: 후니 레거시 이름형(PRF_TTEOKME_FIXED 동형). 경쟁사 코드/네임 0 유입.

## D4. search-before-mint
- **재사용**: ① 수량할인 `DSC_STAT_QTY`(기존·6상품 이미 연결) → 신규 할인테이블 0. ② siz_cd = 라이브
  t_prd_product_sizes 등록 정본(SIZ_000375/170/377/379/380/196) → 신규 사이즈 mint 0. ③ comp_typ .06·
  prc_typ .01·use_dims 패턴 = 라이브 표준 재사용.
- **신규 mint(무손실 표현 불가 입증 후)**: PRF_STN_* 8 + COMP_STN_* 8(라이브 count 0 확인). 공유 불가(D2)라
  상품별 신규가 유일 무손실 표현. 채번=이름형 separator `_`.

## D5. 수량할인 연결 — 권위 빈칸 verbatim 존중(레더 174/175 미연결 유지)
- 6상품(172/176/177/178/179/181)은 시트 `구간할인적용테이블`="문구 구간할인" → DSC_STAT_QTY junction
  **이미 적재됨**(라이브 실측). 레더 174/175는 시트 빈칸 → junction 미연결.
- **결정**: 권위 빈칸=미지정 verbatim 존중 → 레더 할인 자동주입 금지(메모리 `transparent-postcard` 교훈=
  권위 절대·자동교정 금지). 단 의도는 컨펌큐 Q1로 노출(연결 원하면 junction 2행 추가만·설계 변경 0).

## D6. siz_cd 정본 사용(silsa 오적재 교훈 회피)
- 단가행 siz_cd = 라이브 등록 사이즈 1:1(SIZ_000375 등). 이번 세션 silsa는 A시리즈 중복본(315/317…)이
  단가행에 잘못 들어가 매칭 0이었음. 문구는 상품 등록 siz_cd를 그대로 단가행에 써 자동정합(매칭 0 회피).

---

## 컨펌큐 (인간 승인 필요)

| # | 항목 | 기본값(권위) | 대안 | 결정 필요 |
|---|---|---|---|---|
| **Q1** | 레더 만년다이어리(174/175) 수량할인 | **미연결**(시트 빈칸 verbatim) | DSC_STAT_QTY 연결(junction 2행) | 권위 빈칸 의도 확인 — 미연결이 기본 |
| **Q2** | 실 COMMIT 승인 | DRY-RUN까지(미적재) | fix.sql COMMIT(공식8·구성요소8·배선8·단가행9+1·바인딩8) | ★실 COMMIT은 인간 승인 |
| Q3 | 떡메097(세트) | 본 범위 제외(이미 PRF_TTEOKME_FIXED) | — | 제외 확정 |

## 라우팅
- 확정 신규 그릇(공식/구성요소/단가행/바인딩) = 본 DRY-RUN → 승인 후 **dbmap 적재 트랙**(dbm-load-execution·
  dbm-axis-staged-load)으로 fix.sql COMMIT 위임.
- Q1 할인 정책 심의 = dbm-price-arbiter(또는 실무진 확인).
- 후속 4시트(악세·캘린더·파우치) = §18 동형 전파(스코프 문서 §4 순서).

## search-before-mint 요약(DRY-RUN 실측)
- 재사용: DSC_STAT_QTY·siz_cd 정본·.06/.01 패턴 → 신규 할인/사이즈 0.
- 신규: PRF_STN_* 8·COMP_STN_* 8·단가행 9(+메모패드 1)·바인딩 8. 전부 라이브 부재 확인 후 mint.
- 무손실: 공유 불가(D2) 입증 → 상품별 1:1이 유일 무손실.
