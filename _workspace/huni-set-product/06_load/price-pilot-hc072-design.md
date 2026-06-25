# 가격 파일럿 종단 설계 — 하드커버책자(PRD_000072·원자합산형) t_prc_* 민팅

생성: hsp-set-designer · 권위=set-price-authority §1.1(하드커버무선 6비목 L47-54) + §18 engine-design-booklet §4.1 + 라이브 읽기전용 실측(2026-06-25) · 단가=가격표(260527)/추출 verbatim·**날조 0**(원천 부재=BLOCKED) · **DB 미적재**(실 COMMIT/민팅 별도 인간 승인). search-before-mint 전수(재사용 입증 후에만 신규 mint).

> 본 설계는 set-price-authority §3.1 "적재 대상 5건"의 책자류 대표(072)를 종단 설계한다. price-mint-readiness.md는 072를 "comp 0행→BLOCKED"로 판정했으나, **본 세션 라이브 재실측(2026-06-25)에서 그 판정이 부분 오류임을 확정** — 제본비·코팅비·인쇄비·용지비 comp가 라이브 실재(재사용 가능)하며, 진성 BLOCKED는 **후가공박(비목6)·표지내지 용지 단가 원천(비목1·6) 두 곳**으로 좁혀진다(비목 단위 분리).

---

## 0. 결론 요약 — 6비목 준비도 (비목 단위 READY/BLOCKED)

| 비목 | 권위 산식(set-authority §1.1) | comp(라이브) | search-before-mint | 단가행 원천 | 판정 |
|---|---|---|---|---|---|
| (5) 제본비 | [수량행][제본종류열] | **COMP_BIND_HC_MUSEON**(실재·use_yn=Y) | ✅ 재사용 | 라이브 6행(PROC_000023: 1=30000…1000=6000)·가격표 B02 | 🟢 **READY** |
| (3) 표지인쇄비 | 출력매수 × 수량행단가 | **COMP_PRINT_DIGITAL_S1**(실재·212행) | ✅ 재사용 | 라이브 212행·디지털인쇄비 시트 | 🟢 **READY**(출력매수=앱 판수계산) |
| (4) 표지코팅비 | 출력매수 × 수량행단가 | **COMP_COAT_MATTE/GLOSSY**(MATTE 92행 실재·GLOSSY 0행) | 🟡 부분재사용 | 라이브 MATTE 92행(PROC_000015 무광)·코팅 시트 | 🟡 **PARTIAL**(유광 단가행 부재) |
| (1) 내지인쇄비 | [총내지매수행][도수열] × 총내지매수 | **COMP_PRINT_DIGITAL_S1/S2** 재사용 | ✅ 재사용 | 라이브 212행 | 🟢 **READY**(총내지매수=앱 이중수량) |
| (2) 용지비(표지/내지) | (산식항—종이별 절가) | **COMP_PAPER**(56행)이나 **072 자재 4종 미수록** | 🔴 단가행 부재 | 가격표 종이비 시트 — **072 표지/면지 자재 절가 미추출** | 🔴 **BLOCKED**(단가 원천 미추출·날조 금지) |
| (6) 후가공박(대형) | [면적별동판비]+[면적별A~E군][군별/칼라별 합가] | **COMP_FOIL_LARGE_***(라이브 **0행**) | 🔴 신규 mint | foil-large 분해물 194행(동판64+박130) | 🔴 **BLOCKED**(comp 미민팅·상품바인딩/등급코드/동판좌표51 미해소) |

- **READY 3비목**(제본비·표지인쇄·내지인쇄): comp·단가행 라이브 실재(재사용·신규 mint 0).
- **PARTIAL 1비목**(표지코팅비): comp 실재·MATTE 단가행만(GLOSSY 92행 라이브 진화로 소실 — round-16 분해물은 184행 주장하나 실측 92행·R7 freshness 드리프트).
- **BLOCKED 2비목**(용지비·후가공박): 단가 원천 미추출/comp 미민팅 → **날조 금지 원칙상 비목 단위 BLOCKED 분리**(전체 막지 않음).
- **종합**: 072는 "전부 BLOCKED"가 아니라 **부분 적재 가능**(제본+인쇄 3비목)·**용지비·후가공박 2비목 미해소**. 그러나 **용지비가 빠지면 완제 가격이 미완**(돈 크리티컬·과소청구) → 6비목 전부 READY 전까지 **셋트 바인딩 보류**(PRF 민팅·comp 배선까지 설계·바인딩은 용지비 해소 후).

---

## 1. 가격 모델 (set-price-authority §1.1 · engine-design-booklet §1·§4)

```
판매가 = 내지인쇄비 + 표지인쇄비 + 표지코팅비 + 제본비 + 용지비 + 후가공비   (6비목 Σ·calc-formula L48)
 (1) 내지인쇄비 = [총내지매수행][도수열] × 총내지매수
 (2) 총내지매수 = 부수 × (페이지수 / 판걸이수)        ← 앱 이중수량 곱(런타임·DB 미저장)
 (3) 표지인쇄비 = 출력매수 × 수량행단가              ← 출력매수=앱 판수계산
 (4) 표지코팅비 = 출력매수 × 수량행단가
 (5) 제본비   = [수량행][제본종류열]                  ← 부당 × 부수
 (6) 후가공박 = [면적별동판비] + [면적별 A~E군 합가]   ← 선택 시 add-on
```

- 셋트 부모 072(PRD_TYPE.01) 자기 공식 **PRF_HC_MUSEON_SUM**(신설)에 6비목 comp를 Σ 배선.
- 구성원(반제품): 표지 073·면지 074/075/076(택1 색) — **가격 비기여**(BOM 구성). 가격은 공식 comp Σ로만(이중계상 가드 §5).
- evaluate_set_price 종단: 구성원 4종 가격공식 0행 → contribution 0 → 셋트공식 Σ = 판매가(엽서북 094/떡메 097 동형의 "셋트 단독형").

---

## 2. PRF_HC_MUSEON_SUM 정의 + formula_components 6비목 배선

### 2.1 PRF 공식 정의 (신규 mint — 라이브 0행 확정)

| frm_cd | frm_nm | use_yn | note |
|---|---|---|---|
| **PRF_HC_MUSEON_SUM** | 하드커버무선책자 원자합산형(내지인쇄+표지인쇄+표지코팅+제본+용지+후가공) | Y | 6비목 Σ·calc-formula L48·set-authority §1.1 |

- search-before-mint: `t_prc_price_formulas` PRF_HC% 0행(실측) → **신규 mint 정당**. frm_cd 채번=네이밍 컨벤션(PRF_<제본방식>_SUM·set-price-authority/§18 명세 일치).
- ★공유 PRF_BIND_SUM 미채택 이유: PRF_BIND_SUM은 A갈래(068~071·단일 prd) 전용이며 현재 COMP_BIND_JUNGCHEOL stale 1개만 배선(W1 미해소). 072(B갈래·세트 부모·6비목)를 거기 합류시키면 comp 집합 상이로 충돌 → **전용 PRF 분리**(engine-design-booklet §4.2 후보②·comp 집합 차이로 공유 불가).

### 2.2 formula_components 배선 (6비목·전부 addtn_yn=Y·Σ)

| disp_seq | comp_cd | 비목 | addtn_yn | prc_typ(comp) | use_dims(라이브 실측) | 판별차원(silent 합산 가드) | 상태 |
|---|---|---|---|---|---|---|---|
| 1 | **COMP_BIND_HC_MUSEON** | (5)제본비 | Y | PRICE_TYPE.01 단가형 | `["proc_cd","min_qty","proc_grp:PROC_000017"]` | proc_cd=PROC_000023 주입(셋트 고정) | 🟢 READY |
| 2 | **COMP_PRINT_DIGITAL_S1** | (3)표지인쇄비 | Y | .01 단가형 | `["proc_cd","plt_siz_cd","print_opt_cd","min_qty","proc_grp:PROC_000001"]` | plt_siz_cd(표지판형)+print_opt_cd 주입 | 🟢 READY |
| 3 | **COMP_COAT_MATTE**(or GLOSSY) | (4)표지코팅비 | Y | .01 단가형 | `["proc_cd","plt_siz_cd","coat_side_cnt","min_qty","proc_grp:PROC_000013"]` | proc_cd(유광014/무광015)+coat_side_cnt 주입 | 🟡 PARTIAL(GLOSSY 단가 부재) |
| 4 | **COMP_PRINT_DIGITAL_S2**(내지전용·또는 S1 재배선) | (1)내지인쇄비 | Y | .01 단가형 | (S1과 동일) | plt_siz_cd(내지판형)+print_opt_cd 주입 ×총내지매수(앱) | 🟢 READY·**충돌가드 §2.4** |
| 5 | **COMP_PAPER** | (2)용지비 | Y | .01 단가형 | `["plt_siz_cd","mat_cd"]` | mat_cd(표지/내지 종이) | 🔴 BLOCKED(072 자재 단가행 0) |
| 6 | **COMP_FOIL_LARGE_PLATE + _PROC_STD/SPC** | (6)후가공박 | Y | PLATE=.01·PROC=.02 합가형 | PLATE=`["siz_cd"]`·PROC=`["opt_cd","min_qty"]` | opt_cd=등급·선택 시만 | 🔴 BLOCKED(comp 0행·신규mint) |

### 2.3 ★proc_cd / plt_siz_cd 주입 선결 (돈 크리티컬·silent 다중매칭 가드) [HARD]

- **제본비(seq1)**: COMP_BIND_HC_MUSEON 단가행이 PROC_000023(하드커버무선)·PROC_000024(하드커버트윈링)·PROC_000098 3 proc_cd 보유. 072는 **하드커버무선 고정** → `selections.proc_cd=PROC_000023` 주입해야 1행 매칭. **미주입 시 3 proc_cd 전부 와일드카드 후보→silent 3중합산** 위험(실사 PUNCH·디지털 S1/S2 동형). → 상품→proc_cd 고정값 주입 레이어(CPQ option→차원·round-6) 선결.
- **인쇄비(seq2/4)**: COMP_PRINT_DIGITAL plt_siz_cd=출력판형(SIZ_000077 3절/SIZ_000499 국4절)·print_opt_cd=도수. 072 본체 사이즈=A5/A4(완제)이나 인쇄비는 **출력판형 차원** → 앱이 완제사이즈→임포지션→출력판형(plt_siz_cd)·판수 계산 후 주입(중간계산=앱·DB=룩업). 미주입 시 다중 판형 행 매칭.
- **코팅비(seq3)**: proc_cd(유광/무광)+coat_side_cnt(단/양면) 주입. 미주입 시 무광/유광·단/양면 다중매칭.

★ 결론: **072 가격계산은 proc_cd·plt_siz_cd·print_opt_cd·coat_side_cnt 4 차원이 selections에 주입돼야 silent 합산 0.** 미연결 시 0원 또는 과청구(디지털 G-7·문구 Q-ST-OPT1 동형 함정). → CPQ 옵션→차원 자동주입이 가격 정합의 선결(W7).

### 2.4 ★COMP_PRINT_DIGITAL_S1 표지·내지 2회 배선 충돌 가드 [HARD]

- 표지인쇄(seq2)·내지인쇄(seq4)를 같은 COMP_PRINT_DIGITAL_S1로 2회 배선하면 **(frm_cd, comp_cd) PK 충돌**(formula_components PK=2컬럼) → 같은 comp 2행 불가. 또 한 selections에 두 인쇄 항이 동시매칭되면 silent 합산 오류.
- **해소안**: 표지=COMP_PRINT_DIGITAL_S1·내지=COMP_PRINT_DIGITAL_S2로 **별 comp 배선**(둘 다 212행·단가 동일 가능성 — 검증가 대조). S2가 양면 전용이면 의미 불일치 → **책자 표지/내지 전용 인쇄 comp 신설**(COMP_PRINT_BOOK_COVER/INNER) 가능성. → CONFIRM-HC-PRINT(검증가 _combo_key 충돌 재현).

---

## 3. ★search-before-mint 전수 (비목별 재사용 vs 신규 mint)

| 비목 | 라이브 재사용 후보 | 실재 입증(2026-06-25 실측) | 판정 |
|---|---|---|---|
| (5)제본비 | COMP_BIND_HC_MUSEON | comp use_yn=Y·단가행 PROC_000023 6행(1=30000·4=20000·10=14000·50=9000·100=7000·1000=6000) | **재사용**(신규 mint 0) |
| (3)표지인쇄 | COMP_PRINT_DIGITAL_S1 | comp use_yn=Y·212행·plt_siz_cd[SIZ_000077,SIZ_000499] | **재사용**(단가 차원 정합 검증가 대조) |
| (1)내지인쇄 | COMP_PRINT_DIGITAL_S2(또는 신설) | comp use_yn=Y·212행 | **재사용 우선**(충돌가드 §2.4·신설 가능성 CONFIRM) |
| (4)표지코팅 | COMP_COAT_MATTE / COMP_COAT_GLOSSY | MATTE 92행·**GLOSSY 0행**(라이브 진화·round-16 분해물 184행과 불일치) | **부분재사용**(GLOSSY 단가행 부재=R7 드리프트·재추출 필요) |
| (2)용지비 | COMP_PAPER | 56행·**072 자재 MAT_000246/001/002/003 단가행 0행** | **재사용 불가**(단가 원천 미추출→BLOCKED) |
| (6)후가공박 | COMP_FOIL_LARGE_* | **comp·단가행 전부 0행**(라이브 미민팅) | **신규 mint**(foil-large 분해물 194행·BLOCKED) |

### 3.1 신규 mint 목록 (search-before-mint 통과분)

| mint 항목 | 사유 | 출처 | 라우팅 |
|---|---|---|---|
| **PRF_HC_MUSEON_SUM**(price_formulas) | A갈래 PRF_BIND_SUM과 comp 집합 상이·공유 불가 | calc-formula L48·§18 §4.1 | 본 설계(READY)·dbm-ddl-proposer |
| formula_components 6배선 | 신규 PRF의 비목 배선 | §2.2 | 본 설계(READY 3·PARTIAL 1·BLOCKED 2) |
| (CONFIRM) COMP_PRINT_BOOK_COVER/INNER | 표지/내지 인쇄 충돌가드 시만 | §2.4 | 검증가 _combo_key 재현 후 |
| (BLOCKED) COMP_FOIL_LARGE_PLATE/PROC_STD/PROC_SPC | 후가공박 미민팅 | foil-large-decomposition §0 | §18+dbmap(등급코드·동판좌표51·상품바인딩 선결) |
| (BLOCKED) COMP_PAPER 072 자재 단가행 | 표지/면지/내지 절가 미추출 | 가격표 종이비 시트 | dbmap(가격표 재추출·날조 금지) |

---

## 4. component_prices verbatim 단가 (출처·행번호 명시·날조 0)

### 4.1 제본비(5) — COMP_BIND_HC_MUSEON / PROC_000023 (라이브 verbatim·6행)

| comp_cd | proc_cd | min_qty | unit_price | 출처 |
|---|---|---|---|---|
| COMP_BIND_HC_MUSEON | PROC_000023 | 1 | 30,000 | 라이브 t_prc_component_prices(2026-06-25)·가격표 B02 하드커버무선 |
| COMP_BIND_HC_MUSEON | PROC_000023 | 4 | 20,000 | 〃 |
| COMP_BIND_HC_MUSEON | PROC_000023 | 10 | 14,000 | 〃 |
| COMP_BIND_HC_MUSEON | PROC_000023 | 50 | 9,000 | 〃 |
| COMP_BIND_HC_MUSEON | PROC_000023 | 100 | 7,000 | 〃 |
| COMP_BIND_HC_MUSEON | PROC_000023 | 1000 | 6,000 | 〃 |

→ **단가행 신규 생성 0**(라이브 실재·재사용). COMP_BIND_SSABARI/PROC_000023과 byte-동일(통합 흔적·HC_MUSEON이 정명).

### 4.2 표지인쇄(3)·내지인쇄(1) — COMP_PRINT_DIGITAL_S1 (verbatim·212행 라이브)

- 단가행 212행 라이브 실재(plt_siz_cd×print_opt_cd×min_qty). verbatim 샘플: PROC_000004/SIZ_000077/POPT_000001/min_qty1=3,500·2=2,500·…·8=700(라이브 실측).
- ★단가행 신규 생성 0(재사용). 단 **072 표지/내지의 plt_siz_cd가 SIZ_000077/499에 매칭되는지 검증가 대조 필요**(완제 A5/A4→출력판형 임포지션은 앱계산).

### 4.3 표지코팅(4) — COMP_COAT_MATTE (verbatim·92행)·GLOSSY 부재

- MATTE 92행 라이브(PROC_000015 무광·plt_siz_cd·coat_side_cnt·min_qty). verbatim: PROC_000015/SIZ_000077/단면(1)/min_qty1=3,000·2=2,500·5=2,000·10=1,500·20=1,200(라이브 실측).
- 🔴 **GLOSSY(유광) 단가행 0행** — round-16 coating-decomposition은 184행(MATTE92+GLOSSY92) 주장하나 라이브 92행만(GLOSSY 소실=R7 드리프트). 유광 표지코팅 선택 시 매칭0 → **재추출 필요**(가격표 코팅 시트 유광 verbatim·BLOCKED 분리).

### 4.4 용지비(2) — 🔴 BLOCKED (단가 원천 미추출·날조 금지)

- 072 표지(MAT_000246 전용지)·면지(MAT_000001/002/003 화이트/블랙/그레이)·내지 자재가 **COMP_PAPER 56행 단가 분포에 0건**(실측 확인). 가격표 종이비 시트에서 이들 자재의 절가가 추출되지 않음.
- **단가 날조 절대 금지** → 비목 단위 BLOCKED. dbmap 가격표 재추출(표지/면지/내지 종이별 절가) 후 COMP_PAPER 단가행 추가 또는 책자 전용 용지 comp 신설.

### 4.5 후가공박(6) — 🔴 BLOCKED (comp 미민팅)

- COMP_FOIL_LARGE_* 라이브 0행. foil-large-decomposition.md가 194행(동판64+일반박65+특수박65) 분해 보유하나 **미적재**. 선결 차단: ① 등급코드(GRADE_A~E) ② 동판좌표 51개 siz 미등록 ③ 상품바인딩(박 붙는 prd_cd) 미확정. 072가 박 후가공을 쓰는지도 미확정(072 process 등록=제본023·코팅014/015·수축포장076만·박 공정 미등록).
- → **072는 후가공박 비목이 실제 적용 안 될 가능성**(process 미등록) → 6비목 중 (6)은 072에선 **선택적·미적용**일 수 있음(CONFIRM-HC-FOIL).

---

## 5. 선행 W1/W2 의존 진단 (책자 제본비 정합 전제)

| 선행 | 내용 | 072 의존? | 판정 |
|---|---|---|---|
| **§18 W1** | PRF_BIND_SUM stale COMP_BIND_JUNGCHEOL → COMP_BIND_TWINRING 재배선 | **❌ 비의존** | 072 제본비=COMP_BIND_HC_MUSEON(별 comp·하드커버무선)·PROC_000023 단가 정상(트윈링 오염 무관). PRF_BIND_SUM(A갈래)과 PRF_HC_MUSEON_SUM(B갈래·072) 분리이므로 W1(A갈래 stale 배선) 해소 불요 |
| **§18 W2** | COMP_BIND_TWINRING/PROC_000018(중철) 8행 트윈링값 오염 교정 | **❌ 비의존** | 072 제본비=하드커버무선(PROC_000023)·중철(PROC_000018) 무관. W2(중철 오염)는 068 중철책자 전용 |

★ **결론: 072는 W1·W2에 비의존.** price-mint-readiness.md가 "072 선행의존 W1·W2"라 표기한 것은 부정확 — W1/W2는 **A갈래(068~071) 단일책자 PRF_BIND_SUM 전용**이며, 072는 별 comp(COMP_BIND_HC_MUSEON·정상 단가)·별 PRF(PRF_HC_MUSEON_SUM)를 쓰므로 W1/W2 선행 COMMIT 없이 제본비 정합. **단 W2 교훈(통합 시 단가 오염)은 검증가가 COMP_BIND_HC_MUSEON 단가가 가격표 B02 verbatim인지 재대조해야 함**(SSABARI와 byte-동일=통합 흔적·오염 가능성 점검 — CONFIRM-HC-BIND).

---

## 6. 바인딩 + 이중계상 점검

### 6.1 셋트 바인딩 (t_prd_product_price_formulas)

| prd_cd | frm_cd | apply_bgn_ymd | note |
|---|---|---|---|
| PRD_000072 | PRF_HC_MUSEON_SUM | 2026-06-01 | 하드커버책자 원자합산형 바인딩(set-authority §1.1) |

- 실 PK=(prd_cd, apply_bgn_ymd). 072 현재 0행 → 충돌 0. ★**바인딩은 6비목 전부 READY 후 실행**(용지비 BLOCKED 상태로 바인딩하면 용지 누락 과소청구·돈 크리티컬).

### 6.2 구성원 가격공식 유무·이중계상 (실측)

- 구성원 073/074/075/076 가격공식 바인딩 **0행**(072 바인딩 SELECT 결과 공란 확인) → 구성원 contribution 0.
- 면지 074/075/076 = 화이트/블랙/그레이 **택1 색**(sub_prd_qty=1·disp_seq 2/3/4) → "면지 3개 합산" 금지(택1). 가격은 공식 comp Σ(용지비 mat_cd 1행 매칭·선택색).
- **이중계상 0**: 가격은 PRF_HC_MUSEON_SUM의 comp Σ로만. 세트 sub_prd 자체는 BOM 구성(가격 비기여·engine-design-booklet §5).

---

## 7. 골든 종단 재현 (대표 케이스·evaluate_set_price 손계산·PRICE≠0)

> ★용지비(2)·후가공박(6) BLOCKED 상태라 **완전 6비목 합산은 불가**. 아래는 **READY 4비목(제본+표지인쇄+표지코팅+내지인쇄)만의 부분 골든**(PRICE≠0·이중합산0 입증)·용지비/박 해소 후 완전 골든 재계산.

### 골든 케이스 정의

| 항목 | 값 |
|---|---|
| 셋트 | PRD_000072 하드커버책자 |
| 사이즈 | A5(SIZ_000170)·출력판형=3절(SIZ_000077·앱 임포지션) |
| 도수 | 단면(POPT_000001) |
| 페이지 | 100p(page_rule 24~300/2 내)·판걸이수=16(앱)·총내지매수=부수×100/16 |
| 제본 | 하드커버무선(PROC_000023) |
| 부수(copies) | 50권 |
| 코팅 | 무광 단면(PROC_000015·coat_side_cnt=1) |

### 부분 골든 손계산 (READY 4비목·pricing.py:718)

```
evaluate_set_price(PRD_000072, members=[073,074,075,076(택1)],
  set_selections={proc_cd:PROC_000023, plt_siz_cd:SIZ_000077, print_opt_cd:POPT_000001,
                  coat_side_cnt:1, coat_proc:PROC_000015}, copies=50)

[A] 구성원 073/074/075/076 evaluate_price → 가격공식 0행 → contribution 0 (실측)

[B] set_eval = evaluate_price(PRD_000072, set_selections, 50) → PRF_HC_MUSEON_SUM
    _evaluate_formula → formula_components Σ:
      seq1 제본비 COMP_BIND_HC_MUSEON: proc_cd=PROC_000023·min_qty tier(50≤50)=9,000
                  component_subtotal(.01 단가형) = 9,000 × 50 = 450,000
      seq2 표지인쇄 COMP_PRINT_DIGITAL_S1: plt_siz=SIZ_000077·POPT_000001·출력매수(앱=표지 1대×50)
                  단가행 매칭(min_qty tier)·× 출력매수 = [검증가 plt_siz 정합 대조 후 확정]
      seq3 표지코팅 COMP_COAT_MATTE: PROC_000015·SIZ_000077·coat_side_cnt1·min_qty tier
                  × 출력매수 = [verbatim 단가 × 매수]
      seq4 내지인쇄 COMP_PRINT_DIGITAL_S2: × 총내지매수(앱=50×100/16=312.5→313)
                  단가행 매칭 × 총내지매수 = [앱 이중수량 곱]
      seq5 용지비 COMP_PAPER: 🔴 BLOCKED — 매칭0(072 자재 단가행 0) → included=False·기여 0
      seq6 후가공박: 🔴 BLOCKED(미민팅·072 미적용 가능) → 미배선
    included_sum = 제본비 450,000 + 표지인쇄 + 표지코팅 + 내지인쇄 (≥ 450,000)

[C] base_total = 0 + included_sum ≥ 450,000  ✅ PRICE ≠ 0 (제본비만으로도 입증)

[D] 할인: t_prd_product_discount_tables(072)=점검 대상(미실측·CONFIRM-HC-DSC)
[E] final ≥ 450,000  ✅
```

**부분 골든 = 제본비 450,000 + (표지인쇄·표지코팅·내지인쇄) ≥ 450,000.** PRICE≠0 입증(제본비 단독). **단 용지비 누락 = 완제가 미달**(돈 크리티컬·과소청구) → **용지비 해소 전 바인딩 금지**.

### 이중합산 점검 (돈 크리티컬)

- 비목별 comp 상이(제본/인쇄/코팅/용지/박) → comp간 중복 0.
- proc_cd·plt_siz_cd·coat_side_cnt 정확매칭(NON_QTY_DIMS) → 각 비목 1행 매칭(주입 전제·§2.3).
- ★표지인쇄(S1)·내지인쇄(S2) 별 comp → (frm_cd,comp_cd) PK 충돌 0·동시매칭 0(§2.4 충돌가드 준수 시).
- 구성원 가격공식 0 → 셋트공식과 이중계상 0.
- → **이중합산 0**(단 proc_cd 주입·표지내지 comp 분리 전제·검증가 _combo_key 재현 대상).

---

## 8. 077/082 전파 노트 (동형 차이)

| 셋트 | 072 대비 차이 | 전파 |
|---|---|---|
| **PRD_000077 레더 하드커버책자** | 표지=레더(078·MAT 상이)·면지 079/080/081·**제본 동일**(하드커버무선 PROC_000023) | PRF_HC_MUSEON_SUM **공유**(072와 동형)·표지 용지비 mat_cd만 레더로(역시 COMP_PAPER 단가행 BLOCKED 동일) |
| **PRD_000082 하드커버 링책자** | 제본=하드커버트윈링(PROC_000024·COMP_BIND_HC_TWINRING)·**면지인쇄비+면지코팅비 2비목 추가**(8비목·표지/면지 ×2)·인쇄면지 087 | **별 PRF_HC_TWINRING_SUM** 신설(비목 8개·면지 ×2)·제본비 comp=HC_TWINRING(PROC_000024 단가행 라이브 실재·1=30000…1000=7000) |

- 072가 READY 검증되면 077은 **단가 원천만 레더로 교체**(공식·배선 동형)·082는 **면지 2비목 추가 + ×2 산식**으로 확장. 용지비 BLOCKED·후가공박 BLOCKED은 3셋트 공통.

---

## 9. CONFIRM / BLOCKED 라우팅

| ID | 항목 | 라우팅 | 사유 |
|---|---|---|---|
| **BLK-HC-PAPER** | 용지비(2) 표지/면지/내지 절가 미추출 | dbmap(가격표 종이비 재추출)→COMP_PAPER 단가행 | 072 자재 4종 COMP_PAPER 0행·날조 금지 |
| **BLK-HC-FOIL** | 후가공박(6) COMP_FOIL_LARGE_* 미민팅 | §18+dbmap(등급코드·동판좌표51·상품바인딩) | comp 0행·선결 3차단 |
| **PARTIAL-HC-COAT** | 표지코팅 유광 단가행 0행(R7 드리프트) | dbmap(코팅 유광 verbatim 재추출) | round-16 184행 주장 vs 라이브 92행 |
| **CFM-HC-PRINT** | 표지/내지 인쇄 S1/S2 충돌·전용 comp 신설 여부 | 검증가 _combo_key 재현 | (frm_cd,comp_cd) PK·동시매칭 |
| **CFM-HC-BIND** | COMP_BIND_HC_MUSEON 단가가 가격표 B02 verbatim인지 | 검증가 재대조 | SSABARI와 byte-동일=통합 흔적·W2 교훈 |
| **CFM-HC-FOIL** | 072가 후가공박 실제 적용하는지(process 미등록) | 인간 확인 | 072 process=제본/코팅/수축포장만·박 미등록 |
| **CFM-HC-DSC** | 072 수량구간 할인테이블 유무 | 라이브 실측 | discount_tables 미점검 |
| **CFM-HC-INJECT** | proc_cd/plt_siz_cd/print_opt_cd/coat_side_cnt CPQ 주입 레이어 | W7 CPQ option→차원·round-6 | 미주입 시 silent 합산/0원 |

---

## 10. 적재 경계 (DB 미적재)

- 본 산출 = PRF·6비목 배선 설계 + verbatim 단가 추출(READY분) + 부분 골든 손계산 + BLOCKED 비목 분리까지. **실 INSERT/COMMIT·신규 mint은 게이트 GO + 인간 승인 후 hsp-load-executor / dbmap 위임**.
- ★**바인딩(t_prd_product_price_formulas)은 6비목 전부 READY 후 실행** — 용지비 BLOCKED 상태 바인딩=용지 누락 과소청구.
- load CSV/apply.sql 초안은 **READY 3비목(제본·표지인쇄·내지인쇄) + PRF 정의 + formula_components(READY분)** 까지만(준비된 비목만·BLOCKED 비목 미포함).

---

## 11. 출처 (날조 0)

- 권위 공식: set-price-authority.md §1.1(calc-formula L47-54)·`24_master-extract-260610/calc-formula-draft-l1.csv` L48.
- §18 설계: `_workspace/huni-price-engine-design/03_design/engine-design-booklet.md` §1·§3·§4.1(PRF_HC_MUSEON_SUM·B02 SSABARI·DT-BIND-SCOPE 부품합산·충돌가드 AD-BK3).
- 단가 분해: `_workspace/huni-dbmap/20_price-import/binding/binding-decomposition.md`(B2 하드커버)·`coating/coating-decomposition.md`(184행 주장)·`foil-large/foil-large-decomposition.md`(194행·BLOCKED).
- 라이브 실측(2026-06-25 읽기전용 SELECT): 072 sets 4구성원(073표지·074/075/076면지)·PRD_TYPE 01/02·바인딩 0행·PRF_HC% 0행·COMP_BIND_HC_MUSEON 6행(PROC_000023)·COMP_PRINT_DIGITAL_S1/S2 212행·COMP_COAT_MATTE 92행/GLOSSY 0행·COMP_FOIL_LARGE 0행·COMP_PAPER 56행(072 자재 4종 0행)·072 process(023/014/015/076)·page_rule 24/300/2·plate 출력파일사양·proc명(023=하드커버무선/014유광/015무광).
- 엔진 계약: `raw/webadmin/webadmin/catalog/pricing.py:718`(evaluate_set_price)·:82(_row_matches)·:122(match_component 티어)·:181(component_subtotal 단가형).
</content>
</invoke>
