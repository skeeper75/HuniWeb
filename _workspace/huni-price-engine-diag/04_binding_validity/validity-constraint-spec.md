# validity-constraint-spec — 개발자용 정합 명세 (정답 데이터·제약 규칙·정리 후 기대 가격) (U-7)

> **Phase 3 — hped-binding-validity-designer** · 2026-06-18 · `huni-price-engine-diag/04_binding_validity`
> **초점[HARD]:** 제약 "장치"(트리거/CHECK/FK/DDL)는 **개발자 몫**. 이 문서는 그 장치가 **강제해야 할 정답 데이터**(어떤 묶임이 옳고 그른가) + **정리 후 제대로된 가격 결과**다.
> **입력:** comp-product-validity-matrix · binding-violation-board · SOT 1/2/4(sot-definitions) · constraint-mechanism-gap.
> **DDL/트리거 코드 형태가 필요하면 → `dbm-ddl-proposer` 위임**(포인터 §5). 우리는 데이터 정합 명세까지.

---

## 1. 정합 규칙 (제약 장치가 강제할 정답 — 데이터 형태)

### 규칙 R-1 (배선 유효성 — 핵심)
> 가격구성요소(comp)를 가격공식(frm)에 묶을 때(`t_prc_formula_components` INSERT), 그 공식이 바인딩된 상품(`t_prd_product_price_formulas.prd_cd`)의 **상품군이 comp의 유효 상품군 목록(아래 §2 허용표)에 있어야 한다.** 없으면 금지(reject).

- **현재 부재(SOT 4):** `t_prc_formula_components`에 `prd_cd` 없음·코드 clean() 0·DB 트리거 0(constraint-mechanism-gap §1~3). → 장치 없음.
- **선례 패턴:** `fn_chk_opt_item_ref`(sql/10:189-236)가 CPQ option_items에 정확히 이 검사(상품-스코프 참조 무결성)를 한다. **같은 발상을 가격 배선으로 확장**이 자연스러운 방향(코드=개발자).
- **장치가 참조할 "정답"** = §2 comp↔상품군 허용 매트릭스(이 문서가 산출하는 데이터).

### 규칙 R-2 (의미축 단일 인코딩 — 중복 금지)
> 한 의미축(줄수·개수 등)은 **단일 comp의 dim_vals로 표현하거나 comp별 분리하거나 둘 중 하나만.** 1L(dim_vals 전체) + 2L/3L(별 comp)을 같은 공식에 동시 배선 금지.

- **레퍼런스 정답:** `COMP_PP_PERF_1L`(미싱) = 줄수 param 단일 comp(2L/3L 미배선) = 정상. CREASE/VARTEXT/VARIMG도 이 형태로 통일.

### 규칙 R-3 (단가행 차원 정합)
> comp 단가행(component_prices)의 비수량 차원값은 comp 의미와 일치해야 한다(귀돌이 직각 comp는 직각 proc만). 다른 차원값 오염 금지. (V-3·dbmap 정합교정 영역 — R-3은 경계 명시용.)

### 규칙 R-4 (단가형/면적형 상품군 = 후가공 합산 차원 부재)
> **면적매트릭스 단가형·고정가형 상품군**(G-POSTER·G-ACRYL·G-ACRYLSTK·G-NAMECARD·G-STICKER·G-PHOTOCARD·G-PCB·G-ENV)의 공식에는 **종이 후가공 comp(오시/귀돌이/미싱/가변데이타/별색)를 배선하지 않는다.** 이 상품군의 매트릭스/고정가 셀이 이미 "완성 단가(코팅·후가공 포함가)"(authority-golden §2). 추가 후가공은 **별도 add-on**(templates/addons·`COMP_POSTEROPT_*`)로만.

---

## 2. comp↔상품군 허용 매트릭스 (제약 장치가 강제할 정답 데이터)

**행=comp(군), 열=상품군. ✅유효 / ✗무효(배선 금지) / —무관.** 위반 집중 comp만 발췌(전체 독립형은 1:1 자기군만 ✅ — matrix §4).

| comp(군) | G-PAPER | G-PAPER-VAR | G-FOLD | G-NAMECARD | G-BOOKLET | G-STICKER | G-PHOTOCARD | G-ENV | G-POSTER | G-POSTER-FIX | G-ACRYL | G-ACRYLSTK |
|---------|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| CREASE_1L 오시 | ✅ | ✅* | — | ✗ | ✗ | ✗ | ✗ | ✗ | **✗** | **✗** | ✗ | **✗** |
| CORNER_RIGHT/ROUND 귀돌이 | ✅ | ✅* | — | ✗ | ✗ | ✗ | ✗ | ✗ | **✗** | **✗** | ✗ | **✗** |
| PERF_1L 미싱 | ✅ | ✅* | — | ✗ | ✗ | ✗ | ✗ | ✗ | **✗** | **✗** | ✗ | **✗** |
| VARTEXT/VARIMG 가변데이타 | ✅ | ✗ | — | ✗ | ✗ | ✗ | ✗ | ✗ | **✗** | **✗** | ✗ | **✗** |
| SPOT_* 별색 | ✅(국4절) | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | **✗** | **✗** | ✗ | **✗** |
| DIGITAL_S1/S2 인쇄비 | ✅ | ✅ | ✅ | — | — | — | — | — | ✗ | ✗ | ✗ | ✗ |
| PAPER 용지비 | ✅ | ✅ | ✅ | — | — | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ |
| COAT_GLOSSY/MATTE 코팅 | ✅ | △ | ✅ | — | — | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ |
| FOLD_* 접지 | △ | ✅ | ✅ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ |
| CUT_FULL_DIECUT 완칼 | — | ✅ | — | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ |
| CUT_PERF_1H6 타공 | — | ✅ | ✅ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ |
| BIND_* 제본 | ✗ | ✗ | ✗ | ✗ | ✅ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ |
| NAMECARD_* 완제품가 | ✗ | ✗ | ✗ | ✅ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ |
| STK_*·GANGPAN 완제품가 | ✗ | ✗ | ✗ | ✗ | ✗ | ✅ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ |
| PHOTOCARD_* 완제품가 | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✅ | ✗ | ✗ | ✗ | ✗ | ✗ |
| ENV_MAKING 봉투 | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✅ | ✗ | ✗ | ✗ | ✗ |
| POSTER_<소재>_완제품가(본체) | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✅(해당소재) | ✅(해당) | ✗ | ✗ |
| ACRYL_* 인쇄가공비 | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✅ | ✗ |
| POSTER_ACRYLSTK_* | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✅ |
| POSTEROPT_*·POPT_*(현수막 add-on) | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ | ✅(해당상품 add-on) | ✅(해당) | ✗ | ✗ |

> `*` = 상품 레벨 정밀화 필요(G-PAPER-VAR 내 어느 상품이 오시/귀돌이 허용하는지 = 상품마스터 종이시트 후가공 컬럼 컨펌·SOT 7 큐). `△` = 부분(코팅이 접지카드에 적용되나 모든 종이변형 아님). **현 라이브 위반은 전부 G-POSTER/POSTER-FIX/ACRYLSTK 열의 ✗ 셀에 7 후가공 comp가 배선된 것(196행).**

### 머신 판정형(개발자 룩업용 의사규칙)
```
allow_wiring(comp_cd, frm_cd):
    grp = product_group_of( products_bound_to(frm_cd) )   # 공식→상품→상품군
    return grp ∈ valid_groups(comp_cd)                     # §2 매트릭스
# valid_groups(comp_cd) = 위 표의 ✅ 열 집합 (이 문서가 정답 데이터로 제공)
```

---

## 3. ★정리 후 기대 가격 결과 (결과물 정합 — 핵심 판단 기준)

R-1·R-2·R-4 정답대로 오배선을 풀면(use_yn=N·배선 제거, **단가행 보존**) 가격이 어떻게 정합되는가:

### 3.1 V-1 정리(포스터 196 배선 제거) → 포스터 가격 = 순수 면적매트릭스
| 상품 | 현재(오배선) | 정리 후(기대) | 변화 |
|------|------------|--------------|------|
| 일반현수막 etc. 28 상품 | 면적매트릭스 단가 + (선택 시) 종이후가공 가산 위험 | **면적매트릭스 단가 1셀(완성가)뿐** | 종이후가공 가산경로 196 제거 → off-grid ceiling 본체만. **현재 무발화라 골든값 불변**(authority 면적매트릭스 골든 그대로), **잠재 과대청구 경로 차단**(옵션/selections 바뀌어도 안전) |

- **골든 재현(불변 입증):** 아트프린트 세로600×가로600=12000·세로1000×가로1000=20000(authority §2.5). V-1 제거해도 동일(후가공 comp는 현재 무발화). → **정리=안전망**(가격 안 깨고 위험만 제거).

### 3.2 V-2 정리(CREASE/VAR 2L/3L·2EA/3EA 배선 제거) → 종이 후가공 정상 단일가
| 케이스 | 현재(이중) | 정리 후(기대·정답) |
|------|----------|------------------|
| 오시 줄수=2 | CREASE_1L(줄수2) + CREASE_2L = **12000** | CREASE_1L(줄수2) 단일 = **6000** [공식집:행10] |
| 오시 줄수=3 | 1L + 3L = 3배 | 1L 단일 |
| 가변텍스트 개수=2 | 1EA + 2EA 이중 | 1EA(개수2 dim_vals) 단일 |

- **기대 결과:** 후가공비 = 제작수량행 1회(authority §1.6). PERF(미싱)가 이미 이 형태 → CREASE/VAR도 동일. **과대청구 해소**(손님 정당가).

### 3.3 V-4 정리(유광코팅 단가 적재) → 유광 0원 침묵 해소
- 현재: 유광코팅 선택 = 0원(단가행 0). 기대: 가격표 `코팅` 유광단/양 단가 적재 → 정상 코팅비. (data-gap·dbmap import)

### 3.4 종합 기대
> **정리 후 = "각 상품군이 자기 시트 차원으로만 가격 구성"** — 포스터=면적매트릭스 단일셀, 종이=합산형(인쇄+코팅+용지+후가공 단일가), 명함/스티커/봉투=고정가 단일셀. **시트 밖 comp 침입 0.** 이것이 SOT 1 "그릇 경계" 정합의 가격 결과. 돈크리티컬: V-2(active 과대) 즉시 교정 효과, V-1(latent) 위험 영구 차단.

---

## 4. 정리 실행 명세 (데이터 — 실행은 dbmap 위임·인간 승인)

| 위반 | 대상 행 | 정리 액션 | 단가행 | 트랙 |
|------|--------|----------|------|------|
| V-1 | `t_prc_formula_components` 28공식 × 7 comp = **196행** | DELETE(또는 배선용 use_yn 부재→물리 DELETE) | **보존**(comp 단가행 무손상) | dbmap [[dbmap-price-component-grouping]] |
| V-2 | `t_prc_formula_components` PRF_DGP_A·D × {CREASE_2L,3L·VAR{TEXT,IMG}_2EA,3EA} = ~16행 | DELETE 배선(comp는 use_yn=N) | 보존 | 동상 |
| V-3 | `t_prc_component_prices` CORNER_RIGHT PROC_000028 9행 | DELETE/use_yn=N(단가행 오염) | — | [[dbmap-correctness-audit-round13]] |
| V-4 | `t_prc_component_prices` COMP_COAT_GLOSSY | INSERT 유광 단가 | — | [[dbmap-price-import-round16]] |

> **★HARD:** 본 트랙은 데이터 정답 명세까지. 실 DELETE/INSERT/use_yn 변경·트랜잭션·멱등·백업은 dbmap 적재 트랙(dbm-load-execution)이 인간 승인 후 수행. 본 문서는 "무엇을 어디서 왜"의 정답.

---

## 5. 개발자 위임 포인터 (코드 형태 — 우리 범위 밖)

| 필요 산출 | 담당 | 비고 |
|----------|------|------|
| 배선 유효성 강제 **트리거/CHECK/FK** 코드(R-1 장치화) | **개발자 / dbm-ddl-proposer** | `fn_chk_formula_comp_validity` 신설 — `fn_chk_opt_item_ref`(sql/10:189-236) 패턴을 `t_prc_formula_components`/`t_prd_product_price_formulas`로 확장. comp↔상품군 허용표(§2)를 참조 데이터로 사용. **단 formula_components에 prd_cd 부재** → 검사 시 공식→바인딩상품→상품군 조인 필요(설계 결정=개발자). |
| 상품군 분류 마스터(상품→상품군 매핑) 그릇 | 개발자 | 현재 상품군이 명시 컬럼 없음(prd_typ_cd≠상품군·메모리 [[dbmap-grid-binding-round15]]). 공식 prefix(PRF_POSTER_*)·comp_nm이 사실상 상품군 신호. 정식 상품군 컬럼/코드 = 그릇 설계(rpmeta/dbmap). §2 매트릭스가 그 정답 데이터. |
| addtn_yn 활성화 여부 | 개발자 백로그 | 현재 엔진 미사용(11-CONTEXT:23 deferred). R-2 정리 후엔 불요(중복 자체 제거). |

---

## 6. 잔존 컨펌 큐 (SOT 7 오염검증 — 사용자/도메인)

| # | 미해소 | 영향 | 누가 |
|---|------|------|------|
| C-V1 | G-PAPER-VAR/상품 레벨 후가공 허용 정밀화(§2 `*`) — 어느 종이상품이 오시/귀돌이/가변데이타 실제 허용? | V-1 정당 reach(10)를 상품 레벨로 좁힘 | 상품마스터 종이시트 후가공 컬럼 컨펌 |
| C-V2 | 포스터에 별색/후가공이 **실무상 정말 0인가**(가격표 포스터 블록 후가공 행 미열람분) | V-1 별색 단정 확신도 | 가격표 포스터 시트 전수(authority-gap D-6 CONFIRM과 동일) |
| C-V3 | V-5 호출측 단일키 보장(plt_siz vs siz) | DIGITAL 이중 위험 | price_views 호출 로직(검증자 재실측) |

> 본 명세는 **상품군 레벨에서 확신도 높음**(authority-golden 권위 + 라이브 196 실측). 상품 레벨 정밀화·포스터 후가공 부재 최종확정은 위 컨펌 후. 미지를 정답으로 위장하지 않음(본 하네스 원칙).
