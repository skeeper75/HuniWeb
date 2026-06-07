# 디지털인쇄 원자합산형 가격엔진 — 독립 검증 게이트 (V1~V6)

> 검증 2026-06-07 · dbm-validator (독립 적대검증, 자기승인 금지=R6/G9 분리).
> 검증 대상: `02_mapping/digital-print-engine/` (dbm-mapping-designer 산출, verdict 자칭 ADEQUATE).
> 권위 기준(designer 주장 아님): 라이브 railway DB read-only SELECT(2026-06-07, 쓰기/COMMIT 0) · `06_extract/calc-formula-draft-l1.csv`(공식) · `06_extract/import-paper-l1.csv`(용지비 절가) · `00_schema/price-engine-ddl.md`·`price-engine-fk-refs.md`(제약) · `08_remediation/digital-print.md`(36상품).
> 방법: CSV는 python csv로 실제 파싱 재산출(designer 수치 불신). 라이브 SELECT 약 18회 전부 read-only. 비밀값 미노출.
> 식별자/컬럼/코드/SQL 영어, 해석 한국어.

---

## 0. 종합 판정 (D-5 보정 후 최종): **GO** (LOADABLE 147행 · 잔존 BLOCKER 0)

> **[최종 재검증 2026-06-07 — D-5 보정 확인]** designer가 D-5(049)를 BLOCKED_siz로 이동 완료. **V1~V6 + V2연장 전건 PASS, 잔존 BLOCKER 0건.** D-1~D-5 전부 RESOLVED(또는 차단/컨펌으로 정직 분리). 국4절 **LOADABLE 147행 GO**.
>
> 보정 확인(라이브 read-only 재확증): 049 plate 커버 0/3 확정 → LOADABLE에서 제거(`t_prd_product_price_formulas_DGP.csv` 19행, 049 부재)·BLOCKED_siz 3행(019/030/049) 이동·사유 note 정확(plate=SIZ_000186/188/190 작업사이즈·use_yn=Y). **V6 최종 = PASS**: LOADABLE 19상품 중 siz-미정합(covered=0)은 썬캡(051)뿐이며 use_yn=N(미출시·조건부 분류) → **use_yn=Y siz-미정합 LOADABLE 상품 0건**.
>
> 본 트랙은 round-2 가격 설계 트랙이라 G1~G9/R1~R6 적재 게이트 아님 — **V1~V6 기준** 판정. 상세는 §7·§8 재검증 섹션.

**해소 이력**: D-1(후가공비 28배선 RESOLVED)·D-2(019/030 BLOCKED 이동 RESOLVED)·D-3(권위문서 6종 정정 RESOLVED)·D-4(note 평량 RESOLVED)·**D-5(049 BLOCKED 이동 RESOLVED)**. 잔존 결함 0.

(아래 §1~§5는 초기 검증 기록 — §7·§8이 재검증 권위)

**[초기 검증]** 국4절 122행 LOADABLE 묶음은 FK·제약·사슬 측면에서 적재 가능(데이터 무결성 PASS)하나, 도메인 의미(S-gate) + 차단 정직성에서 실결함 2건(MAJOR)·정확성 흠 2건(MINOR)이 적발되어, 그 수정 전 적재는 가격 오류를 낳는다. 데이터 적재 자체는 안전하지만, "디지털인쇄 가격조회 가능화"라는 트랙 목적은 미달이다.

| 결함 ID | 심각도 | 한 줄 요약 |
|---------|:------:|-----------|
| **D-1** | **MAJOR** | PRF_DGP_A·D에 **후가공비(오시/미싱/가변/모서리) component 미배선** — calc-formula r4 권위 가산항 "후가공비" 누락. 엽서·상품권·소량전단지 후가공 가격 미합산 → **과소산정** |
| **D-2** | **MAJOR** | **투명엽서(019)를 LOADABLE 22 바인딩에 포함** — 출력용지규격이 디지털 인쇄비 커버({SIZ_000077,SIZ_000499})에 0/4 → 인쇄비·별색·용지비 lookup 전부 깨짐. designer §6.2가 자기지적한 위험을 LOADABLE로 분류(차단 정직성 위반) |
| **D-3** | **MINOR** | 권위문서 `price-engine-fk-refs.md`가 PRC_COMPONENT_TYPE **5종**으로 기재했으나 라이브는 **6종**(.06 완제품비 실재). designer가 COMP_CUT_FULL_DIECUT을 "커팅비/.04"로 본 의미 매핑이 실제(.06 완제품비)와 어긋남 → schema-analyst 라우팅 |
| **D-4** | **MINOR** | 용지비 CSV note 평량 누락(MAT_000150 "뉴크라프트 국4절" vs 라이브 "뉴크라프트 250g"). 절가·mat_cd는 정확 — prefix 매치 결과적 정당이나 note 부정확 |

---

## 1. V1~V6 PASS/FAIL 표

| 게이트 | 결과 | 근거(재산출) |
|--------|:----:|-------------|
| **V1 공식 사슬 완결성** | **PASS** | 6공식(PRF_DGP_A~F) 전부 formula(1)→formula_components(A=15·B=4·C=5·D=6·E=10·F=4)→product_price_formulas(A=10·B=2·C=3·D=1·E=5·F=1) 3단 완결. 끊긴 공식·component 0·바인딩 0 = 없음 |
| **V2 FK 선존재 (라이브 독립 재확인)** | **PASS** | 21 재사용 comp_cd 21/21·49 mat_cd 49/49·22 prd_cd 22/22·SIZ_000499(316x467 impos=Y)·FRM_TYPE.01·PRC_COMPONENT_TYPE.03 전건 라이브 실재. foil 3종 부재(BLOCKED 정당)·COMP_PAPER 미존재(신규 mint 정당)·BLOCKED_siz 9 mat_cd 9/9 실재 |
| **V3 도메인 의미 S-gate** | **FAIL** | **D-1**: PRF_DGP_A(r4 권위=인쇄+코팅+용지+**후가공비**+추가상품)·PRF_DGP_D(r25=인쇄+코팅+용지+**후가공비**)에 후가공비 미배선. DGP-B/C/E/F는 정합. 용지비 단가 import-paper 절가 49/49 field-for-field 일치(표본 대조 PASS) |
| **V4 제약 준수** | **PASS** | C-1(apply_ymd yyyy-MM-dd 49/49 OK)·C-2(자연키 UNIQUE8 중복0)·C-5(FRM_TYPE.01 6/6)·C-6(.03 1/1)·C-7(용지비 clr_cd 빈=NULL 49/49)·C-8(use_yn Y/N 위반0)·PK(formula_components 44 dup0·바인딩 22 dup0·formulas 6 unique)·unit_price numeric 위반0 |
| **V5 곱셈계수 baked-in 금지** | **PASS** | 용지비 49행 unit_price = import-paper 국4절 절가 **raw**(×출력매수·÷판걸이수·+손지율 미포함). 손지율(+5장)·출력매수곱은 앱 런타임 명문화(C-4). baked-in 0 |
| **V6 차단 정직성** | **PARTIAL-FAIL** | 정직한 차단: 3절/투명 siz 9행(siz 미채번 라이브 확증 — 330x660·315x467 부재)·foil 6슬롯(comp 부재)·048 재바인딩(PRF_FOLD_SUM 바인딩 실재·22중 기존바인딩0이라 PK충돌 정당 회피). **그러나 D-2**: §6.2가 "019/030 인쇄비도 3절/투명 siz 필요할 수 있음 — 별도검증"이라 자기지적 했으면서 **019를 LOADABLE 바인딩에 포함**(030은 3절이라 인쇄비 SIZ_000077 커버됨·019는 투명이라 미커버) → 과소차단 |

---

## 2. 적발 결함 상세

### D-1 [MAJOR] PRF_DGP_A·D 후가공비 미배선 (S-gate 위반)

**권위(calc-formula r4):** `판매가 = 인쇄비 + 코팅비 + 용지비 + 후가공비 + 추가상품`. **r25(소량전단지):** `인쇄비 + 코팅비 + 용지비 + 후가공비`.

**라이브 실태(SELECT):**
- 프리미엄엽서(016) 후가공 공정 6종: 직각(PROC_027)·둥근(028)·오시(029)·미싱(030)·가변텍스트(031)·가변이미지(032).
- 스탠다드상품권(041) 4종: 오시·미싱·가변텍스트·가변이미지.
- 소량전단지(047): 무광·유광(코팅)·가변텍스트·가변이미지.
- 이 후가공비 component **단가가 라이브에 실재**: COMP_PP_CREASE_1L(오시,10행)·COMP_PP_PERF_1L(미싱,10)·COMP_PP_VARIMG_1EA(가변이미지,23)·COMP_PP_CORNER_ROUND(모서리,9) 등 — 전부 PRC_COMPONENT_TYPE.04 후가공비.

**결함:** DGP-A 배선(`t_prc_formula_components_DGP.csv`)은 인쇄(S1/S2)+별색5종×2+코팅2+용지만 15행. **후가공비 component 0개**. DGP-D도 인쇄+코팅+용지+CUT_PERF_1H6(타공)만 — 오시/미싱/가변/모서리 미배선.

**영향:** 위젯이 엽서/상품권/소량전단지의 오시·미싱·가변·모서리 후가공을 선택해도 가격에 합산되지 않음 → **과소산정**. calc-formula 권위 가산항 1개("후가공비") 누락 = S-gate FAIL.

**수정방향(designer):** DGP-A·D에 후가공비 후보 component(COMP_PP_CREASE_1L/2L/3L·COMP_PP_PERF_1L/2L/3L·COMP_PP_VARTEXT_*·COMP_PP_VARIMG_*·COMP_PP_CORNER_ROUND/RIGHT)를 disp_seq 슬롯으로 배선(런타임 옵션 활성화). 단가는 라이브 실재(추가 적재 불요) → FK 안전. **컨펌① "옵션 후보 전부 배선" 정책을 후가공비에도 일관 적용**해야 했으나 인쇄/별색/코팅에만 적용하고 후가공비를 누락.

### D-2 [MAJOR] 투명엽서(019) LOADABLE 바인딩 = 가격조회 깨짐 (차단 정직성)

**라이브 증거:**
- 디지털 인쇄비(COMP_PRINT_DIGITAL_S1/S2)는 **siz_cd ∈ {SIZ_000077(3절 300x625), SIZ_000499(국4절 316x467)}에만** 적재(각 106행). 그 외 출력용지규격엔 인쇄비 단가 부재.
- 별색(COMP_PRINT_SPOT_*)은 **SIZ_000499에만**(53행). 코팅(COMP_COAT_*)은 SIZ_000077+499.
- 투명엽서(019) plate_size(출력용지규격) = SIZ_000113/114/115/118(100x100·102x152·137x137·150x212 = 작업사이즈). **{SIZ_000077,SIZ_000499}에 0/4** (covered_plate=0).
- 315x467(투명 출력용지규격) siz_cd 라이브 부재(SIZ_000499=316x467만 존재).

**결함:** 019는 DGP-A 22 LOADABLE 바인딩에 포함됐으나, 인쇄비·별색·용지비(투명 PET=BLOCKED_siz) 전부 lookup 불가 → **공식 사슬은 완결돼도 단가 조회 0건 = 가격 0/오류**. designer §6.2가 이 위험을 명시("019의 인쇄비 단가도 3절/투명 siz 차원이 필요할 수 있음")했으나 LOADABLE 바인딩에서 제외하지 않음.

**대조 정합:** 지그재그엽서(030)는 plate=SIZ_000142/143(604x154 등)이나 인쇄비가 3절(SIZ_000077) 커버 가능성 — 단 030의 출력용지규격도 작업사이즈로 적재돼 동일 위험(별도 검증 필요). 나머지 9개 DGP-A 상품(016/017/018/020/021/022/026/041/042)은 출력용지규격 SIZ_000499로 정상(covered 1/1).

**수정방향:** 019(투명엽서)는 LOADABLE 22행에서 **분리해 BLOCKED(투명 siz 채번 + 투명 인쇄비/별색 단가 적재 대기)**로 재분류. 030도 출력용지규격 검증 후 분류. 즉 **LOADABLE 바인딩 22 → 20~21**(019 확정 제외, 030 검증 대상)로 정정.

### D-3 [MINOR] PRC_COMPONENT_TYPE 코드 수 = 라이브 6종 (권위문서 stale)

`price-engine-fk-refs.md`·`price-engine-ddl.md`는 PRC_COMPONENT_TYPE을 **.01~.05 5종**으로 기재. 라이브 실재 = **6종**: .01 인쇄비·.02 코팅비·.03 용지비·.04 후가공비·.05 박형압비·**.06 완제품비**. `COMP_CUT_FULL_DIECUT`(DGP-B/F "커팅비/완칼" 배선)은 라이브에서 comp_typ_cd=**.06 완제품비**("커팅 합가/완제품가")이며, designer가 §1·§3에서 "후가공비(.04)"로 분류한 것과 어긋남. 배선은 comp_cd 참조만 하므로 **적재엔 무해**하나, 의미 매핑 문서가 부정확. → **schema-analyst로 라우팅**(fk-refs.md를 6종으로 갱신·완제품비 의미 추가).

### D-4 [MINOR] 용지비 CSV note 평량 누락 (prefix 매치 표기)

`t_prc_component_prices_PAPER.csv` MAT_000150 note="뉴크라프트 국4절", MAT_000151 note="팬시크라프트 국4절" — 평량 누락. 라이브 mat_nm은 "뉴크라프트 250g"·"팬시크라프트 120g". import-paper에 동명 다평량 종이가 없어 prefix 매치는 결과적 정당하고 절가(105·72)·mat_cd는 정확하나, note에 평량 명기 권장(추적성). designer "이름 정확매치 56 + prefix 2" 주장 중 국4절 분은 정확매치 47+prefix 2=49로 재산출(주장 수치는 3절/투명 포함 합산이라 무모순).

---

## 3. designer 주장 vs 독립 재산출 대조 (거짓/누락 점검)

| designer 주장 | 독립 재검증 | 판정 |
|---------------|-------------|------|
| FK 선존재 "전건 확인" | comp21/21·mat49/49·prd22/22·SIZ_000499·cod2/2 라이브 SELECT 재확인 전건 일치 | **참** |
| mat_cd 58/58 (정확56+prefix2) | 국4절 분 49 = 정확47+prefix2 라이브 mat_nm 대조. 3절5+투명4 BLOCKED mat 9/9 실재 | **참** |
| 용지비 절가 verbatim | import-paper 316x467 49종 절가 = CSV 49행 unit_price field-for-field 49/49 일치 | **참** |
| "차단 0건(종이 mat_cd)" | 58종 종이 전부 라이브 t_mat 실재 — 종이 코드행 차단 0 확증 | **참** |
| C-1~C-9·PK 전건 PASS | CSV 파싱 재산출 — 위반 0 확인 | **참** |
| "국4절 122행 즉시 적재가능" | FK/제약/사슬 무결성은 적재가능(참). **그러나 의미상 019 가격깸·후가공 누락**으로 "가격조회 가능"은 거짓 | **부분 거짓** |
| §6.2 "019/030 인쇄비 별도검증" 자기지적 | 라이브 확증: 019 인쇄비 커버 0/4 → **019는 LOADABLE에서 제외했어야** | **자기지적 후 미반영(D-2)** |
| Fit-Gap "PRC_COMPONENT_TYPE 5종" 전제 | 라이브 6종(.06 완제품비) | **근거문서 stale(D-3)** |

---

## 4. 국4절 122행 적재가능 여부 최종확인

- **데이터 무결성 차원(FK·제약·PK·사슬)**: 122행 전건 **적재 가능** — V1·V2·V4·V5 PASS. 이대로 INSERT해도 FK 위반·중복·NULL 거부 없음.
- **가격 정확성 차원(S-gate·차단정직성)**: **적재 부적합** — D-1(후가공 과소산정)·D-2(019 가격깸) 미수정 시 위젯 가격 오류.
- **권고 분리 적재**:
  - **즉시 LOADABLE(수정 후)**: formulas 6 + COMP_PAPER 1 + formula_components 44(+후가공비 배선 추가) + component_prices 49(용지비) + 바인딩 **20~21**(019 제외, 030 검증).
  - **D-1 수정**: DGP-A·D에 후가공비 후보 component 배선 추가(라이브 단가 실재 → FK 안전, 추가 적재 불요).
  - **D-2 수정**: 019(+030 검증분)을 BLOCKED(투명 siz 채번 + 투명 인쇄비/별색 단가 적재 대기)로 이동.

---

## 5. 라우팅 (수정 요청처)

| 결함 | 라우팅 | 조치 |
|------|--------|------|
| D-1 후가공비 미배선 | **dbm-mapping-designer** | DGP-A·D에 후가공비(COMP_PP_CREASE/PERF/VARTEXT/VARIMG/CORNER) component disp_seq 배선 추가. 컨펌① 정책을 후가공비에 일관 적용 |
| D-2 019 LOADABLE 오분류 | **dbm-mapping-designer** | 투명엽서(019) 바인딩을 BLOCKED로 이동(투명 siz 채번+투명 인쇄비/별색 단가 의존). 030 출력용지규격 검증 후 분류 |
| D-3 PRC_COMPONENT_TYPE 6종 | **dbm-schema-analyst** | fk-refs.md/price-engine-ddl.md를 6종(.06 완제품비)으로 갱신. COMP_CUT_FULL_DIECUT 의미(.06) 정정 |
| D-4 note 평량 | **dbm-mapping-designer** | MAT_000150/151 note에 평량(250g/120g) 명기 |

재게이트 범위: D-1/D-2 수정 후 **V3·V6만 재검증**(V1·V2·V4·V5는 still-valid PASS 유지). D-3은 문서 갱신이라 적재 무영향.

---

## 6. 검증 라이브 SELECT 수행 목록 (전부 read-only · DB 무변경)

version·comp21선존재·foil3부재·COMP_PAPER미존재·mat49선존재+mat_nm·prd22선존재·SIZ_000499의미·cod2선존재·048기존바인딩·22prd충돌체크·디지털인쇄비 siz coverage·SPOT/COAT siz coverage·019/030/044/029 plate_size·315x467/330x660 siz존재·DGP-A covered_plate·엽서 후가공 공정·후가공비 comp 단가존재·BLOCKED mat9선존재·DGP-C/D 후가공·PRC_COMPONENT_TYPE 전코드. 비밀값 stdout/파일 미노출 확인.

---

## 7. 재검증 (V3·V6 재게이트 + V2 연장) — 2026-06-07

> 보정 산출(`02_mapping/digital-print-engine/`): formula_components 44→**72행**(DGP-A·D 후가공비 28배선 추가)·바인딩 22→**20행**(019/030 제거)·BLOCKED_siz 바인딩 **2행** 신설·용지비 note 평량 명기·설계문서 §1 .04→.06 정정. D-3은 orchestrator가 권위문서 직접 정정.
> 재검증 범위: V3·V6 + V2 연장(신규 28배선 FK). V1/V4/V5는 still-valid PASS 유지(아래 확인).

### 7.1 재검증 PASS/FAIL 표

| 게이트 | 초기 | 재검증 | 근거 |
|--------|:----:|:------:|------|
| **V2 연장** (신규 28배선 FK) | — | **PASS** | DGP-A·D 후가공비 14종 distinct comp_cd(COMP_PP_CREASE_1L/2L/3L·PERF_1L/2L/3L·VARTEXT_1/2/3EA·VARIMG_1/2/3EA·CORNER_RIGHT/ROUND) **14/14 라이브 선존재**, **전건 comp_typ_cd=PRC_COMPONENT_TYPE.04**, **전건 단가 실재**(9~23행). FK RESTRICT 안전 + 가격조회 가능 |
| **V3 도메인 의미 S-gate** | FAIL | **PASS (RESOLVED)** | **D-1 보정 확인**: DGP-A(r4)·DGP-D(r25)에 후가공비 가산항 채워짐(각 14배선). 후가공비 외 잉여·과잉배선 0(권위 r4/r25에 "후가공비" 명시·라이브 공정 정합). DGP-B/C/E/F 이전 PASS 유지. 용지비 절가 49/49 일치 유지 |
| **V6 차단 정직성** | PARTIAL-FAIL | **PARTIAL-FAIL (D-2 RESOLVED, D-5 신규)** | 019/030 LOADABLE→BLOCKED_siz 정확 이동·030 BLOCKED 사유 라이브 정합(plate=SIZ_000142/143, 인쇄비 0/2 커버). **그러나 LOADABLE 20행에 049(와이드접지리플렛) siz 미정합 잔존 = D-5** |
| V1/V4/V5 | PASS | PASS (유지) | formula_components PK 72 dup0·disp_seq 중복0·addtn_yn 전건 Y. 사슬 완결(DGP-A 29comp/8prd·DGP-D 20comp/1prd). 용지비 baked-in 0 무변경 |

### 7.2 잔존 결함 D-5 [MAJOR · 신규 적발]

**와이드접지리플렛(PRD_000049) — D-2와 동일 사유, LOADABLE에서 미제외.**

라이브 증거(SELECT):
- 049 `use_yn=Y`(활성·출시), plate(출력용지규격) = SIZ_000186/188/190 (635x303·644x303·646x303, 작업사이즈, impos=N).
- 디지털 인쇄비(COMP_PRINT_DIGITAL_S1/S2) 커버 = {SIZ_000077(3절), SIZ_000499(국4절)}뿐 → **049 plate 0/3 NOT-COVERED**.
- V6-re-d 직접 확증: 049 plate siz에 디지털 인쇄비 row **0건** → **가격 lookup 깸**.
- 대조: 같은 DGP-E의 027/028/029는 plate=SIZ_000499(국4절)로 정상 커버(가격조회 가능). 즉 DGP-E 공식·배선은 건전, 049의 **출력용지규격이 작업사이즈로 잘못 적재**된 것이 근인(round-3 plate 결함 패턴과 동일).

**판정:** D-2 보정이 019/030만 잡고 동일 사유의 049를 누락. 049는 use_yn=Y라 미출시 핑계 불가 → MAJOR. **LOADABLE 바인딩에서 049 제외 → BLOCKED**(049 출력용지규격 plate를 국4절/3절로 교정하거나, 해당 작업사이즈에 디지털 인쇄비 단가 적재 후 LOADABLE 복귀).

**부수 관찰(MINOR, 차단 아님):** 썬캡(051)도 plate=SIZ_000195(313x400) 커버 0/1이나 `use_yn=N`(미출시)이라 즉시 영향 없음 — LOADABLE에 잔존하되 출시 시점 plate/인쇄비 정합 검증 조건부. 모양엽서(023)·핑크/금은별색엽서(021/022)·미니접지카드(028)도 use_yn=N이나 출력용지규격 SIZ_000499 정상 커버라 차단 불요.

### 7.3 LOADABLE 최종 행수 확정

| 파일 | 보정 후 행수 | D-5 반영 후 최종 LOADABLE |
|------|:------------:|:-------------------------:|
| t_prc_price_formulas_DGP.csv | 6 | 6 |
| t_prc_price_components_PAPER.csv | 1 (COMP_PAPER) | 1 |
| t_prc_formula_components_DGP.csv | **72** | 72 (사슬·FK 안전 — 049 제외는 바인딩만) |
| t_prc_component_prices_PAPER.csv | 49 (국4절) | 49 |
| t_prd_product_price_formulas_DGP.csv | 20 | **19** (049 제외) |
| **소계 LOADABLE** | 148 | **147** |
| BLOCKED_siz 용지비 | 9 | 9 |
| BLOCKED_siz 바인딩 (019/030) | 2 | **3** (+049) |
| BLOCKED foil 슬롯 | 6 | 6 |
| 048 재바인딩 | 1 | 1 |

→ **국4절 즉시 적재가능 = 147행**(049 바인딩 1행 BLOCKED 이동 시). 049 미제외(현 20행) 상태로 적재하면 049 가격조회 깸.

### 7.4 재검증 라우팅

| 결함 | 라우팅 | 조치 |
|------|--------|------|
| **D-5 049 LOADABLE 오분류** | **dbm-mapping-designer** | 와이드접지리플렛(049) 바인딩을 BLOCKED_siz로 이동(사유: plate=SIZ_000186/188/190 작업사이즈, 디지털인쇄비 0/3 커버). 049 출력용지규격 plate 교정 또는 해당 siz 인쇄비 단가 적재 후 LOADABLE 복귀 |
| (조건부) 051 썬캡 | dbm-mapping-designer | use_yn=N이라 즉시 무영향. 출시 전 plate/인쇄비 정합 확인 조건 부기 |

재게이트 범위: D-5 수정(049 제외) 후 **V6만 재확인**(V2연장/V3 RESOLVED 유지). D-5 제외 시 LOADABLE 147행 = **GO**.

---

## 8. 최종 재검증 (D-5 보정 확인 · V6 최종) — 2026-06-07

> 보정 산출: `t_prd_product_price_formulas_DGP.csv` 20→**19행**(049 제거)·`t_prd_product_price_formulas_DGP_BLOCKED_siz.csv` 2→**3행**(019/030/049).

### 8.1 D-5 해소 확인 (RESOLVED)

| 점검 | 결과 |
|------|------|
| 049 LOADABLE 제거 | **PASS** — `t_prd_product_price_formulas_DGP.csv` 19행, PRD_000049 부재(grep 0) |
| 049 BLOCKED_siz 이동 | **PASS** — BLOCKED_siz 3행(PRD_000019/030/049), 049 사유 note 정확("plate=SIZ_000186/188/190 작업사이즈·impos=N, 디지털인쇄비 0/3, use_yn=Y, plate 교정 또는 인쇄비 단가 적재 후 복귀") |
| 049 plate 0/3 라이브 재확증 | **PASS** — SELECT: covered=0, total_plate=3 (digital 인쇄비 {SIZ_000077,SIZ_000499} 미커버 확정) |

### 8.2 V6 최종 판정 = **PASS**

라이브 SELECT — LOADABLE 19상품 전수 siz coverage:
- **covered=0 상품 = 썬캡(051) 1건뿐**, `use_yn=N`(미출시) → 조건부 분류(차단 아님). 출시 전 plate/인쇄비 정합 확인 부기.
- **use_yn=Y siz-미정합 LOADABLE 상품 = 0건** — 가격조회 깸 위험 잔존 0.
- D-2(019/030)·D-5(049) 전부 BLOCKED_siz로 정직 이동. 과소차단·과잉차단 0.

→ **V6 = PASS. V1~V6 + V2연장 전건 PASS, 잔존 BLOCKER 0.**

### 8.3 LOADABLE 최종 행수 확정 = **147행**

| 파일 | LOADABLE |
|------|:--------:|
| t_prc_price_formulas_DGP.csv | 6 |
| t_prc_price_components_PAPER.csv | 1 (COMP_PAPER) |
| t_prc_formula_components_DGP.csv | 72 |
| t_prc_component_prices_PAPER.csv | 49 (국4절) |
| t_prd_product_price_formulas_DGP.csv | 19 (049 제외) |
| **합계** | **147** |

BLOCKED: 용지비 9(3절5+투명4) + 바인딩 3(019/030/049) + foil 슬롯 6 + 048 재바인딩 1.

### 8.4 잔존 인간승인 항목 — 정직 분리 확인 (차단/컨펌, 결함 아님)

| 항목 | 분리 위치 | 정직성 |
|------|-----------|:------:|
| 컨펌① 공식단위 배선(옵션 후보 전부, 런타임 활성화) | 설계문서 §3·§11 | **OK** — 정책 결정 명시, 후가공비도 일관 적용(D-1 보정 후) |
| 컨펌③ 3절/투명 siz 채번(330x660·315x467) | BLOCKED_siz 용지비 9행 + 바인딩 019/030 | **OK** — 라이브 siz 부재 확증, placeholder 분리 |
| 컨펌④ 박(대형) foil 트랙 | BLOCKED_foil 6슬롯 | **OK** — foil comp 라이브 부재, 슬롯만 예약·LOADABLE 제외 |
| 컨펌⑤ use_yn=N 상품(021/022/023/028/051) | LOADABLE 바인딩(공식/상품 use_yn으로 미노출) | **OK** — 바인딩하되 미노출. 051은 siz-미정합 조건부 부기 |
| 048 접지리플렛 재바인딩(DELETE PRF_FOLD_SUM+INSERT PRF_DGP_E) | 인간승인 마이그레이션(LOADABLE 제외) | **OK** — PK충돌 회피 위해 분리, 라이브 기존바인딩 실재 확인됨 |
| D-5 후속(049 plate 교정 또는 인쇄비 단가 적재) | BLOCKED_siz 바인딩 049 | **OK** — 복귀 조건 명시 |

→ 모든 인간승인 항목이 "처리완료" 포장 없이 차단/컨펌으로 정직 분리됨. **HARD "처리완료 포장 금지" 준수.**

### 8.5 최종 종합

**GO** — V1~V6 + V2연장 전건 PASS, 잔존 BLOCKER 0, LOADABLE 147행 적재 가능(데이터 무결성 + 가격 정확성 + 차단 정직성 전부 충족). 실제 INSERT·3절투명siz채번·foil·048재바인딩·use_yn=N 노출은 인간승인 대기(정직 분리됨).
