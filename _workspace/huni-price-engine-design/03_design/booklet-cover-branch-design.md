# booklet-cover-branch-design.md — 책자 셋트 표지 펼침/개별 분기 가격계산공식 설계

> **핵심 설계가(hpe-engine-designer) — §18 directive "책자 셋트상품 표지 펼침/개별 분기" 전용 설계.**
> 입력 재사용[HARD]: `engine-design-booklet.md`(A 제본비형·B 세트합산형·G-BK 결함) + `huni-set-product/03_design/booklet-068-071-design.md` rev.2(068~071 4비목 부모공식) + 메모리 `booklet-set-formula-principle-260629`(펼침×1/개별×2·표지단가=1면) + `output-material-composite-decode.md`(표지=`코팅/오시` 결합·하드커버전용지+무광코팅 묶음) + 메모리 set-semifinished-3tier/book-set-page/hardcover-blocked.
>
> 권위[HARD]: ① 상품마스터(260610) booklet-l1·계산공식집 seq63 6비목 > ② 인쇄상품 가격표(260527 제본 B01/B02·디지털인쇄비·출력소재) > ③ 라이브 t_prc_*/t_prd_*(기준선) > ④ 출력소재 묶음 분석.
> 산출자: hpe-engine-designer · **라이브 읽기전용 SELECT 실측 2026-06-30**(아래 §0.1 freshness) · 단가값=권위 verbatim(날조 0) · **DB 미적재**(실 적용 인간 승인 후 dbmap 위임·webadmin 코드 직접수정 금지).

---

## 0. 설계 요약 — 무엇을 설계하나

**한 정보(표지인쇄+표지코팅)가 책등 유무로 펼침×1/개별×2 분기**되도록, evaluate_set_price가 처리할 표지측 가격구성요소 배치를 10책자(068~071·072·077·082·088·094·100)에 설계한다. 핵심 = **표지 출력매수가 책등 유무로 갈리는 배수를 어디에 어떻게 두느냐**.

### 0.1 ★라이브 freshness 실측 (2026-06-30·읽기전용 SELECT·본 세션 직접 — 입력 문서 이후 대폭 진화)

| 상품 | 라이브 바인딩 실측 | 셋트 구성원 | page_rule | 표지/내지 합산 상태 | 비고 |
|------|-------------------|------------|-----------|---------------------|------|
| **068 중철** | `PRF_BIND_SUM` → `COMP_BIND_JUNGCHEOL` 1개만 | 0행 | 4/28/4 | ❌ **제본비만**(표지/내지/용지 누락=저청구) | G-BK-2 stale 배선은 **해소**(JUNGCHEOL 직접·del_yn 무관·정답값) |
| **069 무선** | `PRF_BIND_MUSEON`(제본1)+`PRF_BIND_MUSEON_FOIL`(제본+박3) | 0행 | 24/300/2 | ❌ 제본비만(+박옵션 면적) | 박류 §18이 _FOIL 변종 추가(2026-06-30) |
| **070 PUR** | `PRF_BIND_PUR`+`PRF_BIND_PUR_FOIL` | 0행 | 24/300/2 | ❌ 제본비만(+박) | 동 |
| **071 트윈링** | `PRF_BIND_TWINRING` → `COMP_BIND_TWINRING` | 0행 | 8/100/2 | ❌ 제본비만 | ★TWINRING comp는 4 proc_cd 다중행(018~021) 보유 |
| **072 하드커버** | `PRF_HC_MUSEON_SET` → `COMP_HC_MUSEON_COVERBIND`(표지+제본 통합·권당) | 5(표지073+내지284+면지3) | 24/300/2 | ✅ **완비**(COVERBIND 통합 + 내지284=PRF_DGP_INNER) | 정답 템플릿 |
| **077 레더HC** | **미바인딩**(공식 0) | 4(표지078+면지3) | 24/300/2 | ❌ **내지 구성원 누락**(page 있으나 sub_prd 없음) | G-BK 결함 잔존 |
| **082 HC링** | **미바인딩**(공식 0) | 5(표지083+면지4) | 8/100/2 | ❌ **내지 구성원 누락** | G-BK 결함 잔존 |
| **088 레더링바인더** | **미바인딩**(공식 0) | 5(표지089+면지4) | **없음** | 정상(빈 바인더·내지 없음) | BLOCKED(보류중) |
| **094 엽서북** | `PRF_PCB_FIXED` → COMP_PCB_S1/S2_20P(완제품가) | 2(내지095+표지096) | 20/30/10 | ✅ 완제품가형(부품합산 아님) | 면지 없음·소프트 |
| **100 포토북** | `PRF_PHOTOBOOK_FIXED`(base)+내지101=`PRF_PHOTOBOOK_INNER`(per2p) | 7(내지101+표지6+면지) | 24/150/2 | ✅ base24+per2p 완비 | 표지 6 variant 택1 |

★ **freshness 정정 3건(라이브가 입력 문서 stale 갱신)**:
1. **068 제본비 단가 = 정답**(JUNGCHEOL 1=3000·100=700·1000=500·B01 verbatim) — engine-design-booklet.md G-BK-1(중철 단가행 오염)·G-BK-2(stale JUNGCHEOL 참조)는 **이미 해소**. 068이 `PRF_BIND_SUM`→`COMP_BIND_JUNGCHEOL` 직접 배선·정답값 보유. **단 표지/내지/용지 미배선 저청구는 잔존**.
2. **069/070에 `_FOIL` 변종 신설**(박류 §18 산물·2026-06-30) — 박 후가공 면적 comp 3개 추가됨. 본 설계의 표지/내지 배선은 _FOIL 변종에도 동형 적용(박은 후가공 add-on·별개 층).
3. **표지/코팅/용지 단가 전건 verbatim 일치**: S1 국4절 100매 단면 350/양면 700·MATTE coat_side 1=500/2=1000·COMP_PAPER 백모120=36.88·아트150=46.65 — booklet-068-071-design.md 골든값과 byte 일치(검증가 E1 재대조 통과 예상).

### 0.2 ★표지 펼침/개별 분기 = 책등 유무 결정 (이 설계의 중심 원리 [HARD])

| 분기 | 책자 | 책등 | 표지 물리 출력 | 표지 출력매수 배수 | 근거 |
|------|------|------|----------------|---------------------|------|
| **펼침 ×1** | 068 중철·069 무선·070 PUR·072 하드커버무선 | **있음** | 앞표지+책등+뒤표지를 **한 펼침면**(국4절 1-up·pansu=1) | × **1** (copies) | booklet-formula-principle §1·메모리 펼침×1 |
| **개별 ×2** | 071 트윈링·082 하드커버링 | **없음**(링/바인더) | 앞표지 1장 + 뒤표지 1장 **물리 2장**(펼침 불가) | × **2** (copies×2) | booklet-formula-principle §3·cover-spread-x2 §1 |

★ **핵심[HARD]**: 표지인쇄·표지코팅·표지용지 **단가는 출력 1매(국4절 1판) 기준** → 트윈링/하드커버링 2장이면 ×2 정확(**이중계상 아님**). 디지털인쇄비 단/양면 칼럼=인쇄 도수(print_opt_cd)이지 앞뒤 매수 아님. **펼침/개별은 도수축(단/양면)과 완전 독립** — 071은 양면이면서 ×2 가능(양면 단가 × 2매).

---

## 1. ★표지 펼침/개별 분기 로직 — evaluate_set_price 처리 설계

### 1.1 분기를 어디에 두는가 — 3개 후보 비교 (search-before-mint)

표지 출력매수 배수(펼침 ×1 / 개별 ×2)를 엔진이 어떻게 산정하는가. 세 곳에 둘 수 있다:

| 후보 | 배수 위치 | 메커니즘 | trade-off | 판정 |
|------|----------|----------|-----------|------|
| **후보 ① 출력매수 앱계산 (권고)** | evaluate_set_price 런타임 `cover_sheets = copies × cover_mult` | 부모공식 표지인쇄/코팅/용지 comp 단가는 1매 기준(verbatim 그대로)·매수만 cover_mult(068~070=1·071/082=2) 곱. cover_mult는 상품 메타/page_rule 파생(책등 유무) | **단가행 무중복**(comp 단가 1매 기준 그대로)·SKU 폭발 0·off-grid ceiling·판수·책등과 동일 앱계산 철학([[dbmap-compute-in-app-db-stores-lookup]]) | ✅ **권고** |
| 후보 ② sub_prd_qty=2 (셋트행) | 표지 구성원 `sub_prd_qty`를 068~070=1·071/082=2 | 셋트 BOM 수량으로 표지 2장 표현. 단 **표지 구성원은 가격공식 0**(비용=부모공식)이라 sub_prd_qty 곱이 가격에 안 닿음 → 무효 | ❌ 표지 가격이 부모공식에 있어 sub_prd_qty가 가격에 미반영(072 표지073=공식0 실측) | ✗ 부결 |
| 후보 ③ comp 배선 ×2 (formula_components 2회) | 부모공식에 표지인쇄 comp를 2회 배선(071만) | 같은 comp_cd 2회 → `_combo_key` 충돌·silent 이중합산/ERR_AMBIGUOUS(디지털 S1/S2 동형 위험) | ❌ combo_key 충돌·엔진 계약 위반 | ✗ 부결 |

★ **결정 (AD-CB1·확신도 높음): 후보 ① 출력매수 앱계산** — 표지 출력매수 = `copies × cover_mult`. `cover_mult`는 책등 유무 파생(펼침=1·개별=2). 부모공식의 표지인쇄(S1)·표지코팅(MATTE/GLOSSY)·표지용지(COMP_PAPER) comp는 **1매 기준 단가 그대로**, 곱해지는 출력매수(qty 인자)만 cover_mult 반영. 이중계상 0(단가 1매 기준이라 ×2 정당·booklet-formula-principle §4).

### 1.2 cover_mult를 무엇이 결정하는가 (책등 유무 파생)

`cover_mult ∈ {1, 2}`는 **제본방식(proc_cd)이 책등을 만드는지**로 결정 — 상품 고정값(손님 선택 아님):

| 제본방식 | proc_cd | 책등 | cover_mult | 적용 상품 |
|----------|---------|------|:----------:|-----------|
| 중철 | PROC_000018 | 있음(접지) | **1** | 068 |
| 무선 | PROC_000019 | 있음 | **1** | 069·072·077 |
| PUR | PROC_000020 | 있음 | **1** | 070 |
| 하드커버무선(싸바리) | PROC_000023 | 있음 | **1** | 072 |
| 트윈링 | PROC_000021 | **없음**(링) | **2** | 071 |
| 하드커버트윈링(링) | PROC_000024 | **없음**(링) | **2** | 082 |

★ **cover_mult 주입 메커니즘**: 제본방식은 **상품→proc_cd 고정값**(중철책자=PROC_000018 자동·068~071-design §3). cover_mult는 **이 proc_cd가 링/바인더(021/024)면 2·아니면 1**로 앱이 파생. 신규 차원·신규 단가행 불요(books-formula-principle §4·seneca naming 유입 금지·앱 함수). DB는 1매 단가만 룩업.

★ **돈크리티컬 가드 [HARD]**: cover_mult 누락(071/082을 ×1로 계산)하면 표지인쇄·코팅·용지 3비목 ~50% 저청구(골든 G-071 검출). 반대로 068~070을 ×2로 계산하면 표지비 2배 과청구.

### 1.3 시뮬레이터에서 표지단가 = 출력1매 기준 ×N 처리 (방법론)

가격시뮬레이터(라이브 POST `/simulate` 또는 evaluate_set_price 직호출)에서:

```
표지측 부품 비용 (부모공식 PRF_BIND_<METHOD>_SET):
  cover_sheets = copies × cover_mult           # 068~070=copies·071/082=copies×2 (앱계산)
  표지인쇄비 = S1[국4절, print_opt(단/양면)] × cover_sheets     # 단가 1매 기준
  표지코팅비 = COAT[국4절, coat_side(1/2)]    × cover_sheets     # 단가 1매 기준
  표지용지비 = COMP_PAPER[국4절, 표지mat_cd]   × cover_sheets     # 절가 1매 기준
```

- **단/양면(print_opt_cd)은 표지인쇄 단가행에 흐름** — 손님 양면 선택 시 S1 POPT_000002(700)이 매칭(단면 350의 2배). cover_mult(출력매수)와 독립 곱.
- **코팅 단/양면(coat_side_cnt)은 표지코팅 단가행에 흐름** — coat_side=2면 MATTE 1000(단면 500의 2배).
- **시뮬레이터 검증 포인트**: cover_sheets가 책등 유무 정확 반영하는지(068~070=copies·071/082=copies×2). 양면 주문이 양면 단가 받는지(R-4·prevsite +60~67%).

---

## 2. ★상품별 가격구성요소 배치표 (10책자 × 8슬롯)

각 책자가 어느 슬롯에 어느 comp·어느 차원·펼침/개별을 배치하는지. ●=배선·×N=출력매수 배수·∅=해당없음.

| 책자 | 표지인쇄 | 표지코팅 | 표지용지 | 내지인쇄 | 내지용지 | 내지page파생 | 면지 | 제본비 |
|------|---------|---------|---------|---------|---------|------------|------|--------|
| **068 중철** | ●S1 ×1 | ●COAT ×1 | ●PAPER ×1 | ●S1 (내지member) | ●PAPER (내지) | page 4/28/4 | ∅(없음) | ●JUNGCHEOL |
| **069 무선** | ●S1 ×1 | ●COAT ×1 | ●PAPER ×1 | ●S1 | ●PAPER | 24/300/2 | ∅ | ●MUSEON (+박_FOIL) |
| **070 PUR** | ●S1 ×1 | ●COAT ×1 | ●PAPER ×1 | ●S1 | ●PAPER | 24/300/2 | ∅ | ●PUR (+박_FOIL) |
| **071 트윈링** | ●S1 **×2** | ●COAT **×2** | ●PAPER **×2** | ●S1 | ●PAPER | 8/100/2 | ∅ | ●TWINRING (proc_cd 분기) |
| **072 하드커버** | ◆COVERBIND(표지+제본 통합·권당) | ◆통합 | ◆통합 | ●S1 (내지284) | ●PAPER (내지284) | 24/300/2 | ●면지3 택1(가격0) | ◆통합 |
| **077 레더HC** | ◆COVERBIND(레더 표지) | ◆통합 | ◆통합(레더) | ●S1 (**내지 mint 필요**) | ●PAPER | 24/300/2 | ●면지3 택1 | ◆통합 |
| **082 HC링** | ◆COVERBIND **×2** | ◆ **×2** | ◆ **×2** | ●S1 (**내지 mint 필요**) | ●PAPER | 8/100/2 | ●면지4 택1 | ◆통합(트윈링 proc) |
| **088 레더링바인더** | (보류중) | (보류) | (보류) | ∅(내지 없음) | ∅ | 없음 | ●면지4 | **BLOCKED** |
| **094 엽서북** | ◆PCB 완제품가(siz·단/양면) | (완제품가 내장) | (내장) | (완제품가 내장) | (내장) | 20/30/10 | ∅ | (완제품가 내장) |
| **100 포토북** | ◆base24(siz·표지타입 mat) | (base24 내장) | (내장) | per2p(siz·page증분) | (per2p) | 24/150/2 | ●면지 택1(가격0) | (base24 내장) |

**범례**: ●=분해형 별 comp 배선 · ◆=통합단가형(부품 내장·base24/COVERBIND/PCB) · ×N=표지 출력매수 배수(펼침1/개별2) · ∅=해당없음.

### 2.1 분해형(068~071) vs 통합형(072·094·100) — 2가지 표지 가격모델 [HARD]

| 모델 | 책자 | 표지 가격 표현 | 펼침/개별 배수 위치 | 근거 |
|------|------|----------------|---------------------|------|
| **분해형(●)** | 068·069·070·071 | 표지인쇄(S1) + 표지코팅(COAT) + 표지용지(PAPER) **3 comp 별 배선** | **출력매수(cover_sheets)에 cover_mult** | 가격표에 통합단가 **없음**·제본비 comp만(068-071-design D3·라이브 실측) |
| **통합형(◆)** | 072·077·082 | COVERBIND(표지+제본 권당 통합단가·use_dims=[min_qty]) | ★**COVERBIND 단가가 이미 펼침/×2 포함?** — §2.2 확인 필요 | 하드커버 전용 가격표가 표지+제본 권당 단일단가 제공(072 라이브 COVERBIND 6행 실측) |
| **완제품가형(◆)** | 094 | PCB 완제품가(siz·단/양면) — 표지/내지/제본 전부 내장 | N/A(완제품 통째) | 엽서북 가격표=완제품가(PCB 라이브 실측) |
| **base24+per2p(◆)** | 100 | base24(siz·표지타입) + per2p(page) | N/A(통합·페이지만 외부) | 포토북 시트=완제 base24(engine-design-photobook §3.2) |

★ **핵심 분기[HARD]**: **펼침/개별 cover_mult는 분해형(068~071)에만 명시 적용**. 통합형(072/082)은 COVERBIND/완제품가가 표지 출력매수를 **이미 단가에 흡수**했는지가 관건(§2.2). 082(하드커버링·책등없음)는 COVERBIND가 ×1 통합단가면 ×2 보정 필요·이미 ×2 포함이면 보정 금지(이중계상 가드).

### 2.2 ★082 하드커버링 COVERBIND ×2 결판 (개별 분기·통합형 교차) — 컨펌큐 Q-CB-082

> **문제**: 082는 **링제본(책등없음=개별 ×2)**이면서 **통합형(COVERBIND 권당단가)** 후보. COVERBIND가 펼침 1매 기준이면 ×2 보정·앞뒤 2매 이미 포함이면 ×1.

- 072 COVERBIND(하드커버무선·펼침×1) = 표지+제본 권당 통합단가(1=34100·100=7969). **펼침 1매 전제**(책등있음).
- 082(하드커버링)는 **링이라 앞뒤 2장**. 082가 072 COVERBIND를 공유하면 표지비 ~50% 저청구(앞뒤 2장인데 1장단가).
- **설계 결판(확신도 중)**: 082는 **별 COVERBIND_TWINRING 또는 분해형(068~071 패턴)** 필요. 통합단가 공유 금지(펼침/개별 다름). **권위 가격표(하드커버링 표지단가)가 앞뒤 2면 포함이면 ×1·1면 기준이면 ×2** → 게이트에서 권위 verbatim 대조(Q-CB-082).

---

## 3. ★077/082 내지 구성원 누락 교정 명세 (라이브 실측 결함)

### 3.1 결함 확정 (2026-06-30 실측)

| 상품 | 셋트 구성원 실측 | page_rule | 내지 누락 |
|------|------------------|-----------|-----------|
| **077 레더HC** | 표지078 + 면지079/080/081 (**내지 0행**) | **24/300/2 존재** | ❌ page_rule 있는데 내지 구성원 없음 = 내지비 전부 누락(심각 저청구) |
| **082 HC링** | 표지083 + 면지084~087 (**내지 0행**) | **8/100/2 존재** | ❌ 동 |
| 088 레더링바인더 | 표지089 + 면지090~093 | **없음** | ✅ 정상(빈 바인더·내지 없음·BLOCKED 보류중) |

★ page_rule이 있다는 것은 **내지 페이지를 입력받는다는 뜻** = 내지가 가격에 기여해야 함. 그런데 내지 구성원(sub_prd)이 없어 evaluate_set_price가 내지비를 합산 못 함 → **책 한 권에서 종이·인쇄가 전부 빠진 저청구**(072 내지284 대비).

### 3.2 교정 명세 — 내지 구성원 mint (search-before-mint·072 PRD_000284 동형)

| 항목 | 077 | 082 | 처리 |
|------|-----|-----|------|
| **내지 반제품 mint** | 레더하드커버책자-내지 | 하드커버 링책자-내지 | **BLOCKED→dbmap mint**(072 PRD_000284 동형·인간 승인·채번 MAX+1) |
| **가격공식 바인딩** | PRF_DGP_INNER (재사용·신규0) | PRF_DGP_INNER | 내지 반제품에 전사(S1 인쇄비 + COMP_PAPER 용지비·page파생) |
| **셋트행 INSERT** | 077 disp_seq 5: 내지 sub_prd | 082 disp_seq 6: 내지 sub_prd | t_prd_product_sets 1행 추가(min/max/incr=page_rule) |
| **내지 page 범위** | 24/300/2 (077 page_rule) | 8/100/2 (082 page_rule) | 셋트행 min_cnt/max_cnt/cnt_incr 충전 |
| **내지 면(print_opt)** | 양면(POPT_000002·도메인) | 단면(A5)/양면(A4·082 링·068-071 경계 동형) | print_opt_cd selection |

★ **결정 (AD-CB2): 내지 직접 비목 아닌 구성원 mint** — 072가 내지를 별 반제품(PRD_000284)+PRF_DGP_INNER로 둔 정답 패턴을 077/082에 전사. 내지 직접 비목(부모공식에 S1/PAPER 배선)도 가능하나 **072 동형 = 내지 구성원이 깔끔**(BOM 일관·page파생 evaluate_set_price 자동). 신규 공식 0(PRF_DGP_INNER 재사용).

★ **선결 가드**: 내지 구성원 바인딩 전 **DBLPANSU 코드결함**(내지 이중÷pansu·price_views.py:1707·072 적발) 교정 선결 — 안 그러면 077/082 내지도 ~0.4배 과소. C트랙(개발팀)·1회 교정이 072/068~071/077/082 동시 해소(068-071-design §4.1).

---

## 4. ★가격시뮬레이터 처리 방법론 (evaluate_set_price 흐름)

### 4.1 가격 사슬 (pricing.py:718 evaluate_set_price)

```
evaluate_set_price(prd_cd, selections, copies) =
    Σ 구성원 evaluate_price                                    ← 내지(member)·표지(member·가격0)·면지(택1·가격0)
      ├─ 내지 member: PRF_DGP_INNER
      │     ├─ 내지인쇄 S1[국4절, print_opt(면), inner_sheets]   inner_sheets = copies × ⌈page / pansu⌉  (page파생·×1)
      │     └─ 내지용지 COMP_PAPER[국4절, 내지mat] × inner_sheets
      ├─ 표지 member: 가격공식 0 → contribution 0  (표지비=부모공식)
      └─ 면지 member: 가격공식 0 → contribution 0  (택1 색·제본비 포함)
  + 부모공식 evaluate_price(prd_cd)                            ← PRF_BIND_<METHOD>_SET (분해형 068~071) or COVERBIND (통합 072)
      ├─ [분해형 068~071] 표지인쇄 S1[국4절, print_opt] × cover_sheets    cover_sheets = copies × cover_mult
      │                   표지코팅 COAT[국4절, coat_side]      × cover_sheets
      │                   표지용지 COMP_PAPER[국4절, 표지mat]  × cover_sheets
      │                   제본비   COMP_BIND_<M>[proc_cd, min_qty=copies tier] × copies
      └─ [통합형 072]     COVERBIND[min_qty=copies tier] × copies  (표지+제본 권당 통합)
  + 후가공(069/070 박 _FOIL·옵션)
  + 할인(셋트 기준 1회)
```

★ **두 수량축 [HARD·혼동 금지]**:
- **cover_sheets**(표지 출력매수) = copies × cover_mult(펼침1/개별2). 도수(print_opt)와 독립.
- **inner_sheets**(내지 출력매수) = copies × ⌈page/pansu⌉. 내지 ×1(page가 양면 이미 포함).
- **copies**(부수) = 제본비 min_qty tier·전 항 곱. 페이지·표지매수와 별개.

### 4.2 이중합산 0 증명 (비목 단일 귀속 — 6비목 calc-formula seq63)

| 비목 | 부모공식 | 내지 member | 표지 member | 단일귀속 |
|------|---------|------------|------------|----------|
| 표지인쇄 | ●분해형(S1·×cover_mult) / ◆통합(COVERBIND) | ✗ | ✗(0) | ✅ 부모만 |
| 표지코팅 | ●분해형 / ◆통합 | ✗ | ✗ | ✅ 부모만 |
| 표지용지 | ●분해형(PAPER 표지mat) / ◆통합 | ✗ | ✗ | ✅ 부모만 |
| 제본비 | ●COMP_BIND / ◆통합 | ✗ | ✗ | ✅ 부모만 |
| 내지인쇄 | ✗ | ●S1(내지) | ✗ | ✅ 내지만 |
| 내지용지 | ✗ | ●PAPER(내지mat) | ✗ | ✅ 내지만 |

★ **COMP_PAPER 충돌 가드**: 표지용지(부모·표지mat)·내지용지(내지member·내지mat)가 같은 COMP_PAPER지만 **frm_cd 분리(PRF_BIND_*_SET vs PRF_DGP_INNER)·mat_cd selection 상이** → 서로 다른 종이·다른 출력매수 → 같은 비용 두 번 안 셈(068-071-design D6). 같은 공식 내 2회 배선 아님(다른 frm_cd) → `_combo_key` 충돌 없음.

### 4.3 골든 케이스 (검증가 재계산용·verbatim 손계산)

> 단가 전부 라이브 국4절 verbatim(2026-06-30 실측). DBLPANSU 코드교정 전제(내지 ÷pansu 1회).

**G-CB-068A (중철·표지 단면 백모120 무광·내지 28p양면·100부)** — 펼침×1 기준선
- 부모공식 PRF_BIND_SUM (cover_mult=1·cover_sheets=100):
  - 표지인쇄 S1 POPT_000001(단면) 국4절 100매=350 × 100 = **35,000**
  - 표지코팅 MATTE coat_side=1 100매=500 × 100 = **50,000**
  - 표지용지 COMP_PAPER 백모120(MAT_000073) 국4절 36.88 × 100 = **3,688**
  - 제본 JUNGCHEOL PROC_000018 tier(100)=700 × 100부 = **70,000**
  - 부모 소계 = **158,688**
- 내지 PRF_DGP_INNER (page파생·inner_sheets=100×⌈28/pansu⌉·게이트 판수 확정)
- 검증: 표지 단면=350·펼침 cover_mult=1·이중합산 0·제본 1회.

**G-CB-068B (068A에서 표지만 양면)** — R-4 양면 가격축
- 표지인쇄 S1 POPT_000002(양면) 700 × 100 = **70,000** (단면 35,000의 2배)
- 표지코팅 MATTE coat_side=2 1000 × 100 = **100,000** (2배)
- 부모 소계 = 70,000+100,000+3,688+70,000 = **243,688** (068A 대비 +85,000)
- 검증: 양면이 POPT_000002·coat_side=2로 흐르면 양면단가 자동. 단면으로 청구되면 +85,000 저청구.

**G-CB-071 (트윈링·표지 단면 아트150 무광·내지 100p단면·50부)** — ★개별 ×2 검출
- 부모공식 PRF_BIND_TWINRING (cover_mult=**2**·cover_sheets=50×2=**100**):
  - 표지인쇄 S1 POPT_000001 350 × 100(=50×2) = **35,000** ← ×2 미적용 시 50×350=17,500(절반 저청구)
  - 표지코팅 MATTE coat_side=1 500 × 100 = **50,000** ← ×1이면 25,000
  - 표지용지 COMP_PAPER 아트150(MAT_000078) 46.65 × 100 = **4,665** ← ×1이면 2,332.5
  - 제본 TWINRING PROC_000021 tier(50)=1,500 × 50부 = **75,000** (proc_cd 주입 필수·§5)
  - 부모 소계 = **164,665**
- 내지 PRF_DGP_INNER (100p 단면·POPT_000001·page파생)
- 검증: ★표지 3비목 전부 cover_sheets=100(=copies×2). ×1이면 표지비 ~50% 저청구=cover_mult 결함. 제본은 권당(×50부·proc_cd=PROC_000021 정확). 단/양면(print_opt)과 ×2(cover_mult) 독립.

**G-CB-077 (레더HC·내지 mint 후·24p양면·100부)** — 내지 누락 교정 검출
- 부모공식 PRF_HC_MUSEON_SET COVERBIND tier(100)=7,969 × 100부 = **796,900** (표지+제본 통합·펼침×1)
- 내지 member PRF_DGP_INNER (24p양면·inner_sheets=100×⌈24/pansu⌉) ← **현재 0(누락)·mint 후 추가**
- 검증: 내지 member 없으면 내지비 0(저청구). mint 후 내지비 합산 확인.

**G-CB-082 (하드커버링·8p단면·50부)** — ★Q-CB-082 COVERBIND ×2 결판
- 표지+제본: COVERBIND ×1(072 공유 시) vs ×2(앞뒤 별·링) — **게이트에서 권위 표지단가 1면/2면 대조**
- 내지 member ← **mint 후 추가**(082 page 8/100/2)
- 검증: 082 링 책등없음 → 표지 앞뒤 2장 보정 여부(Q-CB-082)·내지 누락 교정.

---

## 5. ★제본 proc_cd 주입 가드 (071 트윈링 다중매칭·돈크리티컬) [HARD]

라이브 실측: `COMP_BIND_TWINRING`은 **4 proc_cd 다중행 보유**(PROC_000018/019/020/021 전부)·use_dims=[proc_cd, min_qty, proc_grp]. 071이 이 comp를 쓰는데:

- **proc_cd 미주입 시**: 4 proc_cd 단가행(중철+무선+PUR+트윈링)이 전부 와일드 후보 → silent 다중매칭/오값(실사 PUNCH·디지털 S1/S2 동형 위험).
- **proc_cd 주입 시**: 트윈링책자=PROC_000021 고정 주입 → 1행만 매칭(50부=1,500).

★ **결정 (AD-CB3)**: 071 견적 시 **상품→proc_cd=PROC_000021 고정 주입**(중철책자=018·무선=019·PUR=020·트윈링=021). CPQ option 또는 상품 메타에서 결정(068-071-design §3·Q-CB-PROC). cover_mult(=2)도 이 proc_cd(021=링)에서 파생. **proc_cd 주입이 cover_mult·제본비 둘 다의 선결**.

★ 068(JUNGCHEOL)·069(MUSEON)·070(PUR)은 각자 단일 proc_cd comp라 다중매칭 위험 낮으나, TWINRING comp가 4 proc_cd 공유하므로 071이 가장 위험. 082(하드커버링)도 트윈링 proc(024) 주입 필요.

---

## 6. ★출력소재 분석 통합 — 표지=`코팅/오시` 결합 (output-material-composite-decode)

### 6.1 표지 묶음 = 코팅+오시 한 단위 (실무진 설정)

출력소재 시트 실측(output-material-composite-decode §1):
- **`트윈링표지 :: 코팅/오시`**(28종)·**`무선표지 :: 코팅/오시`**(6종) — 표지를 고르면 **코팅(표면)+오시(제본 접지선)**를 함께 결정.
- 중철표지(13종)·중철내지(13종)·무선내지(7종)·트윈링내지(16종) = 단일 상품축(공정 내장).

★ **설계 반영**:
| 공정 | 가격구성요소 처리 | 책자 |
|------|-------------------|------|
| **코팅** | 표지코팅 comp(COMP_COAT_MATTE/GLOSSY·coat_side_cnt 1/2) — **가격축** | 무선069·트윈링071·하드커버 전부 |
| **오시** | 접는선 누름(제본 전 필수) — **가격 비기여**(제본/접지에 내장·생산 공정) | 무선·트윈링 표지 |
| **접지** | 리플렛 전용(접지카드·소량전단지)·책자 비해당 | — |

★ **오시 = 가격 비기여 [HARD]**: 출력소재 `::코팅/오시` 묶음에서 **코팅만 별 단가(표지코팅 comp)·오시는 제본비/생산에 내장**(별 단가행 없음·접지선 누름은 제본 부수공정). 오시를 별 가격축으로 mint 금지(가격표에 오시 단독 단가 없음·output §2). 표지 가격 = 표지인쇄 + 표지코팅(±오시 내장) + 표지용지.

### 6.2 하드커버전용지+무광코팅 묶음단가 (072/077/082 표지)

출력소재 §4: 하드커버전용 3행(상품컬럼 미배정):
| 종이 | 가격(국4절) | 결합 | 설계 처리 |
|------|------------|------|-----------|
| **하드커버전용지+무광코팅** | 계산식(묶음) | 종이+무광코팅 **묶음단가** | 072 COVERBIND가 이미 흡수(표지+제본 권당 통합)·별 배선 불요 |
| 레더하드커버 A5 | 4,000 | A5 완제품가 | 077 레더표지(레더하드커버)·완제품가 |
| 레더하드커버 A4 | 7,000 | A4 완제품가 | 077 레더표지·A4 완제품가 |

★ **설계 반영**: 072/077/082 표지는 **통합형(◆ COVERBIND)** — 하드커버전용지+무광코팅 묶음단가가 COVERBIND 권당 통합단가에 흡수(분해형 068~071과 정반대). 레더하드커버 A5/A4 완제품가(4,000/7,000)는 077 레더표지 자재단가 소스(컨펌 Q-CB-LEATHER·표지타입 mat_cd 매핑). **별 코팅 comp 배선 금지**(묶음단가 이미 코팅 포함·이중계상 가드).

---

## 7. CPQ 옵션 — 가격기여 분별 (표지 분기 관련)

| 옵션 | 가격기여 | 처리 | 비고 |
|------|---------|------|------|
| **제본방식(중철/무선/PUR/트윈링)** | ★가격축(proc_cd·제본비 + **cover_mult 파생**) | 상품→proc_cd 고정 주입(§5) | 책등 유무로 cover_mult 결정 |
| **표지인쇄 단/양면** | ★가격축(S1 print_opt_cd) | 손님 택1→print_opt 주입 | cover_mult와 독립 |
| **표지코팅 무광/유광·단/양면** | ★가격축(COAT·coat_side_cnt) | 택1→coat_side 주입 | 오시는 비기여(내장) |
| **표지 소재(전용지/레더/아트)** | ★가격축(표지용지 mat_cd or COVERBIND variant) | 택1→mat_cd 주입 | 분해형=PAPER mat·통합형=COVERBIND variant |
| **내지 페이지수** | ★가격축(내지비 × page파생) | 입력 차원·page_rule 제약 | inner_sheets 앱계산 |
| **면지 색상(화이트/블랙/그레이)** | 미정(택1·색별 단가차 있으면 가격축) | sub_prd 택1·가격0 추정 | Q-CB-MYUNJI |
| **박/형압(069/070)** | ★가격축(_FOIL 변종·면적 add-on) | 선택 시 _FOIL 공식 | silent 합산 가드(박류 §18 REV3) |
| **제본방향·링컬러·투명커버** | 가격 비기여 | proc param | 생산 UI |

★ **펼침/개별 분기는 제본방식(proc_cd)에서 자동 파생** — 손님이 별도로 "펼침/개별" 선택하지 않음. 제본방식이 링(021/024)이면 cover_mult=2·아니면 1. **이 자동 파생이 핵심**(손님 실수 여지 0).

---

## 8. evaluate_set_price 계약 정합 체크 (설계 자기검증)

| 계약(engine-contract·pricing.py) | 설계 준수 |
|----------------------------------|-----------|
| 가격 소스 우선순위(TEMPLATE→PRODUCT_PRICE→FORMULA·:296-326) | ✅ 책자=FORMULA·세트 sub_prd 가격 비기여·표지/면지 member 가격0 |
| C7 frm_typ 미참조·공식=합산 | ✅ 분해형/통합형 둘 다 합산형 comp Σ·펼침/개별=cover_mult 앱계산(엔진 코드 분기 아님) |
| P3-8 ERR_AMBIGUOUS / silent 이중합산 | ⚠️ **가드**: ① 071/082 제본 proc_cd 미주입→TWINRING 4 proc_cd 다중매칭(§5) ② COMP_PAPER 표지/내지 다른 frm_cd라 충돌 없음(§4.2). 검증가 E4 재현 |
| P4-1 단가형 ×qty | ✅ 표지인쇄/코팅/용지·제본 전부 .01 단가형·×cover_sheets/×copies. COVERBIND .01·×copies |
| TIER min_qty '이상' 하한(:42·144) | ✅ 제본비·COVERBIND min_qty=부수 tier(100부=700/7969) |
| **cover_mult 앱계산(off-grid 동류)** | ✅ DB는 1매 단가만·cover_mult(펼침1/개별2)=앱 파생(책등 유무·proc_cd)·SKU 폭발 0 |
| U-7 시트 차원경계 | ✅ 책자 공식에 시트 밖 comp 침입 금지·표지/내지=디지털인쇄 종이비/인쇄비 경계 내 재사용 |
| 수량구간할인(:478-504) | ⚠️ 책자 discount_tables 링크 미점검(Q-CB-DSC) |
| search-before-mint | ✅ 표지/내지=S1·COAT·PAPER·PRF_DGP_INNER 재사용(신규 공식 0·068~071 부모공식만 dbmap mint)·077/082 내지 member mint(072 동형) |

---

## 9. designer 큐 잔여 (golden-cases·design-decisions로 이관)

- **펼침/개별 분기 = cover_mult 앱계산**(펼침1·개별2·책등 유무/proc_cd 파생) = 중심 설계(AD-CB1). 표지단가 1매 기준 ×cover_sheets(이중계상 0).
- **068~071 부모공식 표지/내지/용지 배선**(제본비만 저청구) = 1순위(068-071-design rev.2 청사진·dbmap mint·인간 승인).
- **077/082 내지 구성원 mint**(page_rule 있는데 내지 0행=저청구) = 1순위·072 PRD_000284 동형(§3).
- **071/082 제본 proc_cd 주입**(TWINRING 4 proc_cd 다중매칭) = 선결 가드(§5).
- **082 COVERBIND ×2 결판**(링 책등없음·통합형 교차) = Q-CB-082·게이트 권위 대조.
- **088 레더링바인더 BLOCKED**(보류중·내지/page 없음·빈 바인더) = 정체 확정 후.

실 적용(부모공식 신설·내지 member mint·셋트행·cover_mult 코드)은 **DB 미적재·인간 승인 후 dbmap/§18/개발팀 위임**(dbm-axis-staged-load·dbm-load-execution·dbm-ddl-proposer·dbm-price-arbiter·cover_mult 앱로직=webadmin price_views.py C트랙·webadmin 코드 직접수정 금지).

## naming 유입 가드 [HARD]
`book2025`·`INN_PAGE`·`seneca`·`COV_MIN_WGT`·`BIND_DIRECTION`·`jobqty0`·`오시(별 단가)`·`paperno` 후니 유입 금지. 후니 `frm_cd`(PRF_BIND_*_SET·PRF_DGP_INNER·PRF_HC_MUSEON_SET)·`comp_cd`(COMP_PRINT_DIGITAL_S1·COMP_COAT_MATTE·COMP_PAPER·COMP_BIND_*·COMP_HC_MUSEON_COVERBIND)·`proc_cd`·`print_opt_cd`·`coat_side_cnt`·`page_rules`·cover_mult(앱변수) 컨벤션으로 번역. cover_mult·inner_sheets=앱 런타임 변수(DB 차원 아님).

## 컨펌큐 (design-decisions 통합)
- **Q-CB-082**: 082 하드커버링 COVERBIND ×2 여부(링 책등없음·통합단가 1면/2면)·게이트 권위 표지단가 대조.
- **Q-CB-PROC**: 071/082 제본 proc_cd 고정 주입 메커니즘(상품 메타 vs CPQ option).
- **Q-CB-LEATHER**: 077 레더표지 자재단가(레더하드커버 A5=4000/A4=7000 완제품가)→표지타입 mat_cd 매핑.
- **Q-CB-MYUNJI**: 면지 색상별 단가차 유무(가격기여/비기여).
- **Q-CB-DSC**: 책자 수량구간할인(discount_tables) 링크.
- **CFM-COVER-SPREAD-SIZ**: 표지 펼침 1-up siz(068~070)·071/082 매수 ×2.
- **CFM-INNER-DBLPANSU**: 내지 이중÷pansu(C트랙·072/068~071/077/082 동시 해소).
