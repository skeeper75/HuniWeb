# 가격구성요소 적재정합 + 과분리(over-split) 심의 — 라이브 전수 감사

작성: 2026-06-30 · 권위=상품마스터260610+가격표260527 · 라이브 읽기전용(COMMIT 0) · 분석/권고만(실 적용=인간 승인+dbmap 트랙)

기준[HARD]: [[price-component-unify-vs-split-criterion-260630]] · [[dbmap-price-component-grouping]] · [[base-master-code-no-delete]]
엔진 근거: `raw/webadmin/webadmin/catalog/pricing.py` — `_row_matches`(NULL 차원=와일드카드=항상가산), `match_component`(2개+ 차원조합 동시매칭=ERR_AMBIGUOUS=합산 제외=P3-8), `_match_entry`(`non_qty_dims`는 min_qty·opt_grp:* 제외 → 판별차원 유무 판정).

---

## 0. 감사 모집단 (라이브 t_prc_price_components)

| 구분 | 수 |
|---|---|
| 전체 comp | 173 |
| del_yn=Y (논리삭제) | 26 |
| use_yn=N (비활성·보존) | 20 |
| **활성(del=N·use=Y) — 본 감사 대상** | **약 127** |
| 박류(foil/박) — 별도 트랙(engine-design-foil REV4) | 6 (제외) |

★중요: del_yn=Y 26건 중 9건은 **별색(spot) 색상별 comp**, 나머지는 캘린더/하드커버 폐기 잔재. 엔진은 del_yn 미필터(가격계산 무관·어드민 뷰어만 숨김)이나 **활성 바인딩이 없으면** 가격에 영향 없음 → 별색 9건은 이미 정상 흡수 완료(아래 B-0).

---

## A. 적재정합 결함 보드 (CONFORMANCE)

판정 범례: 🟢정상 · 🟡주의(설계상 무해하나 정리 권고) · 🔴결함(돈 영향). 박류 6건 제외.

| comp | 설계의도 | 라이브상태 | 결함 | 돈영향 | 라우팅 |
|---|---|---|---|---|---|
| **CUT_FULL_DIECUT** (구 코드, prefix `COMP_` 없음) | 커팅(완칼) 후가공 | use_yn=Y·**단가행 0**·**바인딩 0**·use_dims에 proc_cd 有 | 🟡 **빈 껍데기 comp**(0행·0바인딩). 정본은 `COMP_CUT_FULL_DIECUT`(36행·PRF_DGP_B/F 바인딩). 네이밍 컨벤션 위반(COMP_ 누락) | 없음(바인딩 0이라 가산 안 됨) | use_yn=N 토글(삭제 아님·[[base-master-code-no-delete]]) → §7 |
| **COMP_POSTEROPT_BANNER_MESH_PROC_OPT** | 포스터 추가옵션 통가격 | use_yn=Y·**단가행 0**·바인딩 0·use_dims=`["min_qty"]` | 🟡 빈 껍데기(0행). "별도 add-on 통가격" 자리표시자만 남음 | 없음 | use_yn=N → §7 |
| **COMP_POPT_BNR_GAKMOK_STR_900_4** (구 통합 comp) | 각목+끈 통가격 | use_yn=N·use_dims=NULL·0행·0바인딩 | 🟢 이미 비활성(900_4_GT/900_4_LE 분리본으로 대체됨·[[catalog-conformance-rc2-addon-260623]]) | 없음 | 조치 불요 |
| **COMP_ACRYL_PENDING_TBD** | 단가/구성 미정(실무진 확인) | use_yn=Y·0행·**7개 TBD 공식에 바인딩** | 🟡 의도된 placeholder(단가 미정 상품). use_dims=`["min_qty"]`만 → 판별차원 없으나 0행이라 가산 0 | 없음(0행) | 실무진 단가 컨펌 대기(추측 적재 금지) |
| **COMP_ACRYL_MINIPART_TBD** | 미니파츠 단가미정(격자밖) | use_yn=Y·0행·PRF_ACRYL_MINIPART 바인딩 | 🟡 placeholder. 단가 미정 | 없음(0행) | 실무진 컨펌 |
| **COMP_POSTER_FOMEXBOARD_WHITE3MM** | 포맥스보드 3mm 완제품가 | use_yn=Y·2행·PRF_POSTER_FOMEXBOARD 바인딩 | 🟢 정상 | — | — |
| **별색 9 comp** (CLEAR/GOLD/SILVER/PINK ×S1/S2 + WHITE_S2) | 별색인쇄비(색상별) | **use_yn=N·del_yn=Y**·각 53행·**바인딩 0** | 🟢 **정상 흡수 완료** — `COMP_PRINT_SPOT_WHITE_S1`(530행)이 proc_cd(화이트8/클리어9/핑크10/금11/은12 ×106)로 5색 전부 담음. 단가행 보존된 채 use_yn=N(삭제 아님) | 없음 | 조치 불요(모범사례) |
| **제본비 6 comp** 중 CAL_WALL·SSABARI | 벽걸이캘린더·싸바리 제본비 | use_yn=Y·각 24/18행·**바인딩 0(미바인딩)** | 🟡 단가행은 있으나 공식 바인딩 없음 → 견적 시 합산 안 됨(언더차지 잠재). CAL_DESK130/220/MINI·HC_MUSEON·HC_TWINRING은 del_yn=Y(폐기 잔재) | 잠재(해당 상품 견적 시 제본비 누락) | 캘린더/싸바리 상품 공식 존재 확인 → 미바인딩이면 §18 설계+§7 바인딩 |
| **명함 코팅/프리미엄/화이트 미바인딩 11 comp** | 명함 완제품가(타입별) | use_yn=Y·단가행 1~5행·**바인딩 0** | 🟡 단가행 적재됐으나 공식 미연결(설계됨≠적재됨). PREMIUM_MGA/MGB·WHITE_*·COAT_S1/S2 | 잠재(해당 명함 견적 0/불가) | 상품-공식 바인딩 추적 → §7 (기존 [[a2-price-conformance-remediation]] 명함5종 COMMIT의 잔여분) |
| **COMP_ACRYL_MIRROR3T** | 미러아크릴3T 인쇄가공비 | use_yn=Y·81행·**바인딩 0** | 🟡 면적격자 81행 적재됐으나 미바인딩(미러아크릴 상품 공식 없음/미연결) | 잠재 | 미러아크릴 상품 공식 확인 → §18/§7 |
| **COMP_FOLD_CARD_3H·6CR** | 접지카드 3단/6크리즈 | use_yn=Y·각 48행·**바인딩 0** | 🟡 2H만 PRF_DGP_C/PRF_FOLD_SUM 바인딩. 3단/6크리즈는 미바인딩(해당 옵션 견적 시 접지비 누락) | 잠재 | 접지카드 3단/6크리즈 상품 공식 바인딩 → §7 |
| **COMP_CUT_FULL_PERF_1H6·2H6** | 완칼+타공1구/2구 | use_yn=Y·각 9행·바인딩 0·use_dims=`["min_qty"]`(판별차원 없음) | 🟡 미바인딩. 만약 바인딩 시 판별차원 없어 항상가산 위험(단 전용상품이면 무해) | 잠재 | 해당 상품 식별 후 §7(바인딩 시 use_dims에 plt_siz_cd/proc_cd 보강 검토) |
| **COMP_POSTER_FOAMBOARD_BLACK·FOMEXBOARD_WHITE5MM·PHOTOCARD_BULK** | 완제품가 | use_yn=Y·단가행 有·바인딩 0 | 🟡 미바인딩(설계됨≠적재됨) | 잠재 | 상품-공식 바인딩 → §7 |

### A 요약
- **빈 껍데기(0행·0바인딩) 2건**: `CUT_FULL_DIECUT`(구코드), `COMP_POSTEROPT_BANNER_MESH_PROC_OPT` → use_yn=N 정리 권고(돈영향 0).
- **미바인딩(단가행 有·공식 0) 약 24건**: 캘린더·명함·미러아크릴·접지카드·보드류 등. **"설계됨≠적재됨"** — 잠재 언더차지(해당 상품 견적 시 그 비목 누락). 기존 [[a2-price-conformance-remediation]]의 미바인딩 197 진단과 동일 계열. **새 결함 아님** → §7 바인딩 트랙.
- **placeholder(TBD) 2건**: 실무진 단가 컨펌 대기(추측 적재 금지).
- **오적재(wrong use_dims / 항상가산 silent)** 확정 신규 결함 **0건** — 활성·바인딩된 comp 중 판별차원 누락으로 silent 항상가산되는 건은 아래 B 위험게이트에서 별도 검사했고, 현 라이브는 전용공식 1:1이라 무해(상세 B-위험게이트).

---

## B. 과분리 병합 후보 (OVER-SPLIT)

원칙: 같은 use_dims+role 클러스터 안에서 **한 상품 안 손님-선택 축**으로만 갈린 comp는 1 comp(+차원키)로 병합 가능. **단, 두 comp가 같은 공식에 동시 바인딩되면 병합 시 ERR_AMBIGUOUS(P3-8 동시매칭) → UNSAFE.** 안전성 게이트 = "병합 후보들이 같은 공식에 공존하지 않는가 + 차원키로 한 행만 매칭되는가".

### B-0. [이미 병합됨·모범사례] 별색 인쇄비
- **상태**: `COMP_PRINT_SPOT_WHITE_S1` 1개가 화이트/클리어/핑크/금/은 5색 + 단면을 **proc_cd 차원**으로 담음(530행). 색상 9 comp는 use_yn=N 보존.
- **판정**: ✅ 이미 정합. **양면(S2) 미흡** — 별색 양면은 현재 WHITE_S1에 없음(106행×5색 단면만). 양면 별색 상품 존재 시 행 보강 필요(별도 확인). 추가 병합 불요.

### B-1. 병합 후보 테이블 (활성 클러스터 대상)

| # | 클러스터 (comps) | use_dims | 차이축 | merge target + 차원키 | 안전성 | 단가행 영향 | 권고 |
|---|---|---|---|---|---|---|---|
| 1 | COMP_FOLD_CARD_**3H** / **6CR** (2H는 바인딩됨·별도) | `["min_qty"]` | 접지 단수(2단/3단/6크리즈) = **한 상품(접지카드) 안 손님 택1** | 1 comp `COMP_FOLD_CARD` + 차원키 `proc_cd`(접지방식) 또는 `opt_cd` | ⚠️ **조건부 SAFE** — 현재 셋 다 미바인딩이라 공존 없음. 단 use_dims=`["min_qty"]`로 판별차원이 없어 **병합하려면 proc_cd/opt_cd 차원 신설+충전 필수**(안 하면 3단 선택에도 2단가 매칭). | 3×48=144행 → 1 comp 144행(proc_cd 태깅) | **병합 권고(차원 신설 동반)**. 단 우선순위 Low(미바인딩 상태라 견적 영향 현재 0). 바인딩 트랙과 함께 처리 |
| 2 | COMP_NAMECARD_**COAT_S1** / **COAT_S2** | `["mat_cd","min_qty"]` | 단면/양면(S1/S2) = **한 상품(코팅명함) 안 손님 택1** | 1 comp `COMP_NAMECARD_COAT` + 차원키 `print_opt_cd`(인쇄면=도수) | ⚠️ **조건부** — 형제 STD/PEARL은 이미 `print_opt_cd`를 use_dims에 두고 S1/S2 1 comp화 안 함(각 S1/S2 분리 유지). 즉 **명함류 S1/S2 분리가 라이브 표준**. 병합하려면 print_opt_cd로 단/양면 구분해야 함 | 2×2=4행 | **KEEP-separate 권고**(C-3 참조). 명함 전 계열이 S1/S2 분리 통일 — 단독 병합은 일관성 깸 |
| 3 | COMP_POSTEROPT_BANNER_NORMAL_PROC_**BONGSEW** / **CUTEDGE** / **DTAPE** | `["opt_cd","opt_grp:OPT_000003"]` | 마감방식(봉미싱/열재단/양면테잎) = **현수막 마감 손님 택1** | 1 comp `COMP_BANNER_N_FINISH` + 차원키 `opt_cd` | 🔴 **UNSAFE** — **셋 다 같은 공식 PRF_POSTER_BANNER_N에 동시 바인딩**. 병합하면 한 공식에 1 comp가 3행(opt_cd 다름)으로 들어가나 `_row_matches`는 opt_cd로 1행만 매칭 → 실제론 SAFE. **재검토**: opt_cd가 use_dims에 있어 동시매칭 안 됨 | 3×1=3행 | **조건부 SAFE**(아래 주석). 단 이익 적음(행 3개·관리 단순화뿐)·동일 OPT_000003 그룹이라 의미상 1 comp 타당. **병합 권고(Low)** |
| 4 | COMP_POSTEROPT_BANNER_NORMAL_ADD_**QBANG_4** / **STRING_4** + GAKMOK_**900_4_GT** / **900_4_LE** | `["opt_cd","opt_grp:OPT_000004"]` | 부속(큐방/끈/각목세트) = **현수막 부속 손님 택1** | 1 comp `COMP_BANNER_N_ADDON` + 차원키 `opt_cd` | ⚠️ **조건부 SAFE** — 4개 모두 PRF_POSTER_BANNER_N 공존. opt_cd가 use_dims에 있어 `_row_matches`로 1행만 매칭(동시매칭 회피). [[catalog-conformance-rc2-addon-260623]]에서 각목 손님택1(900이하/초과)·이중합산 해소 완료된 영역 | 4행 | **병합 가능하나 KEEP 권고** — 최근(RC-2) 정밀 교정 완료 영역. 건드리면 회귀 위험. **Low/보류** |
| 5 | COMP_POSTEROPT_BANNER_MESH_PROC_**PUNCH_4** / **6** / **8** | `["proc_cd","min_qty","proc_grp:PROC_000079"]` | 타공 개수(4/6/8) = **메쉬현수막 타공 손님 택1** | 1 comp `COMP_BANNER_M_PUNCH` + 차원키 `proc_cd` 또는 `dim_vals(개수)` | ⚠️ **조건부 SAFE** — 3개 모두 PRF_POSTER_BANNER_M 공존. proc_cd로 구분되면 1행 매칭. 단 타공4/6/8이 **동일 proc_cd**면 동시매칭 위험 → **proc_cd 또는 dim_vals 개수축 확인 필수** | 3×1=3행 | **검증 후 병합**(proc_cd 상이 확인 시 SAFE). 우선순위 Low |
| 6 | COMP_PP_CREASE_**2L** / **3L** (1L은 바인딩됨) | `["proc_cd","min_qty","proc_grp:PROC_000029"]` | 오시 줄수(1/2/3줄) = **한 상품 안 손님 택1** | 1 comp `COMP_PP_CREASE` + 차원키 `dim_vals(줄수)` | ⚠️ 2L/3L은 use_yn=Y·del_yn=Y(폐기 잔재)·바인딩 0. 1L(COMP_PP_CREASE_1L)이 PRF_DGP_A/D 바인딩 | 줄수별 행 | **이미 사실상 1L로 운영**. 2L/3L use_yn=N 정리 또는 1L에 dim_vals 줄수 보강. **Low** |
| 7 | COMP_PP_PERF_**2L** / **3L** (미싱 2/3줄) | `["min_qty"]` | 미싱 줄수 | 1 comp `COMP_PP_PERF`(=PERF_1L) + dim_vals(줄수) | del_yn=Y·바인딩0. PERF_1L이 정본 | 동일 | **6과 동형 — Low 정리** |
| 8 | COMP_PP_VARIMG_**2EA**/**3EA** / VARTEXT_**2EA**/**3EA** (1EA는 PRICE_TYPE.03 별도) | `["proc_cd","min_qty","proc_grp:PROC_000085"]` | 가변 개수(1/2/3개) | 1 comp `COMP_PP_VARIMG` + dim_vals(개수) | del_yn=Y·바인딩0. 1EA(VARIMG/VARTEXT)가 PRICE_TYPE.03로 PRF_DGP_A/D 바인딩 | 동일 | **이미 1EA 운영·2/3EA 폐기 잔재**. 정리 Low |

### B-1 주석 (안전성 재판정 핵심)
**동시매칭(P3-8) 위험의 진짜 조건**: 두 comp가 같은 공식에 바인딩 + **병합 후 한 선택값에 2행 이상이 동시 매칭**. 라이브 현실에서는 각 comp의 use_dims에 **opt_cd/proc_cd 판별차원이 이미 있어**, 병합해도 `_row_matches`가 그 축으로 1행만 고름 → 동시매칭 안 생김. 따라서 **#3·#4·#5는 기술적으로 SAFE**(판별차원 보존 전제). 하지만 **이익이 작고**(comp 3~4개→1개, 행 보존), **#4는 RC-2 정밀 교정 직후라 회귀 위험**이 더 크다 → 실익 대비 KEEP/Low.

---

## C. KEEP-SEPARATE 목록 (병합 금지 + 사유)

| 클러스터 | comps | KEEP 사유 |
|---|---|---|
| **C-1 보드류 완제품가** | ACRYLSTK_GLOSS/MIRROR·FOAMBOARD_BLACK/WHITE·FOMEXBOARD_3MM/5MM·SHEETCUT_HOLO/MATTE (8) | use_dims=`["siz_cd"]` 동일하나 **각각 별개 상품·소재**(유광아크릴스티커 vs 폼보드 vs 포맥스보드 vs 시트커팅). 손님이 한 주문서에서 택1하는 옵션 아님 → 별개 상품. 병합 시 siz_cd만으로 소재 구분 불가(소재축 없음)=오적재 |
| **C-2 문구류 완제품가** | STN_DIARY_*·JUNGCHEOL·MEMOPAD·MONTHLY·SPRINGNOTE* 등 (다수) | use_dims=`["siz_cd","min_qty"]` 동일하나 **각각 별개 문구 상품**(다이어리/노트/메모패드…). 병합하면 단가행 충돌·상품식별 불가 |
| **C-3 명함 S1/S2 분리** | NAMECARD_STD_S1/S2·PEARL_S1/S2·SHAPE_S1/S2·MINISHAPE_S1/S2·COAT_S1/S2 | **명함 전 계열이 S1(단면)/S2(양면)을 별도 comp로 분리한 것이 라이브 표준**(완제품가에 용지+인쇄 포함·단/양면 단가표가 별표). 단독 병합은 일관성 깨고, S2는 단면 단가의 ~2배라 print_opt_cd 차원으로 합치려면 행 재설계 필요·실익 적음 |
| **C-4 제본종류** | BIND_JUNGCHEOL/MUSEON/PUR/TWINRING/SSABARI/CAL_WALL | [[price-component-unify-vs-split-criterion-260630]] 확정 — 중철/무선/PUR/트윈링 책자는 **4개 별개 상품(PRD_068~071)**. 각자 전용 공식(PRF_BIND_SUM/MUSEON/PUR/TWINRING)이 자기 제본비 1개만 가산(오염 0). 한 상품 안 택1 아님 → 분리가 정답 |
| **C-5 접지 리플렛 4종** | FOLD_LEAF_3FOLD/4ACC/4GATE/HALF | 모두 PRF_DGP_E 공존하나 **proc_cd로 구분**(접지방식). 한 상품 안 손님 택1이긴 하나 — 이미 use_dims에 proc_cd 有 → 1 comp 병합 가능하나 4종이 별개 접지방식이고 단가표가 방식별 별표. **병합 가능(B 후보 동형)이나 현 분리도 정합**(proc_cd 판별차원 충전됨) → 우선순위 Low. ★현 상태로도 silent 가산 없음(proc_cd 매칭) |
| **C-6 아크릴 부속(addon)** | ACRYL_KEYRING/BADGE/CLIP/MAGNET/SMARTTOK/NAMETAG/HAIRBAND/SMARTTOK | 각자 별도 공식(PRF_ACRYL_*)+opt_grp 차원. **부속 가산형 addon 모델**([[addon-optcd-model-broken-live.md]] 교훈). 본체(CLEAR3T)와 공존하나 opt_grp/opt_cd로 구분. 병합 시 부속 종류 식별 불가 |
| **C-7 코팅 유광/무광** | COMP_COAT_GLOSSY / COMP_COAT_MATTE | use_dims 동일·PRF_DGP_A/D/E 공존. **proc_cd로 구분(유광/무광은 손님 택1)** → 기술상 1 comp+proc_cd 병합 가능하나, 둘 다 92행·proc_grp PROC_000013 동일. **병합 가능(SAFE·proc_cd 판별)이나 실익 적음**. 코팅 유/무광은 의미상 명확히 다른 공정이라 현 분리도 합당 → Low |
| **C-8 디지털 인쇄비 S1/S2** | COMP_PRINT_DIGITAL_S1(424행·바인딩) / S2(212행·미바인딩) | S1이 도수(흑백/칼라)를 print_opt_cd로 이미 통합(318행). S1/S2(단/양면)는 별도 comp 유지가 라이브 표준(명함 C-3과 동형). KEEP |

---

## D. 우선순위 수정 정리 (인간 승인 큐)

### 🟡 P-LOW (정리·무해·돈영향 0) — 묶음 처리 권장
1. **빈 껍데기 use_yn=N 토글**: `CUT_FULL_DIECUT`(구코드), `COMP_POSTEROPT_BANNER_MESH_PROC_OPT` — 0행·0바인딩. 삭제 아님·use_yn=N([[base-master-code-no-delete]]).
2. **폐기 잔재 정리**: PP_CREASE_2L/3L·PP_PERF_2L/3L·PP_VARIMG_2EA/3EA·VARTEXT_2EA/3EA — del_yn=Y·바인딩0인데 use_yn=Y인 것 정합화(이미 1L/1EA 정본 운영). 또는 정본에 dim_vals(줄수/개수) 보강 결정.
3. **별색 양면(S2) 행 보강 검토**: WHITE_S1이 단면 5색만. 별색 양면 상품 존재 시 행 추가(실무진 확인).

### 🟠 P-MED (잠재 언더차지 — "설계됨≠적재됨" 바인딩 트랙) — §7
4. **미바인딩 단가행 약 24건 → 상품-공식 바인딩**: 캘린더 제본비(CAL_WALL·SSABARI)·명함(COAT/PREMIUM/WHITE 11)·미러아크릴(81행)·접지카드 3H/6CR·보드류. 각 해당 상품 공식 존재 여부 추적 후 바인딩. **기존 [[a2-price-conformance-remediation]] 미바인딩 197 진단의 잔여분 — 새 조사 불요, 그 트랙 재개**.

### 🟢 P-OPTIONAL (과분리 병합 — 실익 대비 신중) — §18설계+§7
5. **접지카드 2H/3H/6CR 병합**(B-1 #1): 차원 신설(proc_cd/opt_cd) 동반. 바인딩 트랙(#4)과 함께 처리 시 효율적.
6. **현수막 마감/타공 병합**(B-1 #3·#5): proc_cd 판별 확인 후. RC-2 영역(#4)은 보류.

### 🔴 컨펌 필요(추측 적재 금지)
7. **TBD placeholder 2건**(ACRYL_PENDING_TBD·MINIPART_TBD): 실무진 단가 컨펌 대기.
8. **명함 S1/S2 통합 여부**: 현 분리가 표준이나, print_opt_cd 차원 통합이 더 깔끔한지 = **설계 정책 결정**(사용자/실무진).

---

## 안전성 종합 게이트
- **신규 오적재(wrong use_dims·silent 항상가산) 확정 결함: 0건** — 활성·바인딩 comp는 판별차원(opt_cd/proc_cd/print_opt_cd) 보존돼 `_row_matches` 와일드카드 항상가산 미발생.
- **UNSAFE 병합(동시매칭 야기): 사실상 0건** — 후보 전부 판별차원이 use_dims에 있어 병합해도 1행만 매칭. 단 #4(RC-2 직후)는 회귀 위험으로 KEEP.
- **돈-크리티컬 미해소**: 미바인딩 약 24건(언더차지 잠재) = 게이트만 적발(생성≠검증). 실 교정은 인간 승인+dbmap(§7).
- 본 산출은 **분석/권고만 — 라이브 COMMIT 0**. 실 적용은 dbm-load-execution(§7)·dbm-correctness-audit(§13) + 인간 승인.
