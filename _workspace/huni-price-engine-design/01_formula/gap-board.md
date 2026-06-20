# gap-board.md — 디지털인쇄 현 라이브 미설계/불완전 지점 (designer 작업 큐)

> calc-formula-draft(요구 공식)·상품마스터 대비 라이브 t_prc_*가 미설계/불완전한 지점.
> designer(hpe-engine-designer)가 채울 곳. 검증가(validator)의 E-게이트 대조 기준.
> 산출자: hpe-formula-cartographer · 라이브 실측 2026-06-20 · 추정 0(실측·명시값).

---

## 0. 요약 보드

```
디지털인쇄 가격공식 baseline (라이브 실재):
🟢 PRF_DGP_A~F (원자합산 6) · PRF_NAMECARD_FIXED · PRF_PHOTOCARD_FIXED · PRF_ENV_MAKING · PRF_FOLD_SUM
바인딩: BOUND 25 상품 / UNBOUND 17 상품 (디지털인쇄 관련)
```

| ID | 갭 | 유형 | 심각도 | designer 작업 |
|----|----|------|--------|---------------|
| G-1 | 후가공박(대형) 미배선 — PRF_DGP_A·E | 배선 단절 | 🔴 High | 대형박 comp 신설/배선([면적별 동판비]+[A~E군 합가]) |
| G-2 | 후가공박(소형) 미배선 — 명함 후가공 | 배선 단절 | 🟡 Med | 명함 PRF에 소형박 합산 배선(FOIL comp 실재·NAMECARD_FIXED 미연결) |
| G-3 | 고정가 단가행 결손 — NAMECARD(2행)·PHOTOCARD(1행) | 단가행 결손 | 🔴 High | mat_cd×수량 / siz_cd×bdl_qty×수량 매트릭스 완전 적재 점검 |
| G-4 | 명함 variant 17 미바인딩(펄/모양/투명/형압/오리지널박/화이트·투명엽서·와이드접지) | 바인딩 누락 | 🔴 High | 각 variant→적정 PRF 바인딩(또는 variant 전용 PRF) |
| G-5 | 엽서북 세트조합 미모델 | 세트 미설계 | 🟡 Med | 내지+표지 합산 세트 레이어(반제품) |
| G-6 | 공식 권위 이원화(상품마스터 칸 희소·truncated) | 권위 충돌 | 🟡 Med | calc-draft 정본 채택 명문화·컨펌큐 |
| G-7 | 손지율 +5장 가설 | 미검증 규칙 | ⚪ Low | 용지비 손지율 엔진계산 위치 확인(pricing.py) |

---

## 1. G-1 — 후가공박(대형) 미배선  🔴 High

- **calc-draft 요구**: `(7) 후가공박(대형) = [면적별동판비] + [면적별 A,B,C,D,E군][군별/칼라별 수량행 합가]` (PRF_DGP_A 엽서·PRF_DGP_E 접지에 포함).
- **라이브**: PRF_DGP_A·E formula_components에 대형박 comp **미배선**(엽서/접지 본문에 박 항목 없음).
- **근거**: PRF_DGP_A 10 comp = 인쇄·별색·용지·코팅·후가공(귀돌이/오시/미싱/가변) — 박 없음(실측 2026-06-20).
- **designer**: 면적별 박 comp(동판비 + A~E군 합가) 신설·use_dims=[면적축, 박칼라, min_qty], PRF_DGP_A/E에 addtn_yn=Y 배선. [[dbmap-compute-in-app-db-stores-lookup]] 면적→등급=앱계산·DB는 등급별 단가만.

## 2. G-2 — 후가공박(소형) 명함 미배선  🟡 Med

- **calc-draft 요구**: 명함 `(2) 후가공박(소형) = [동판비] + [면적별 A~E군][군별/칼라별 수량행 합가]`.
- **라이브**: 소형박 comp **실재**(COMP_NAMECARD_FOIL_S1/S2_STD·HOLO·SETUP) but PRF_NAMECARD_FIXED는 STD_S1/S2 2 comp만 배선(박 미연결).
- **★오리지널박명함=별 공식** — calc-draft `판매가=동판비+오리지널박명함(테이블)` 고정가형. FOIL comp 실재하나 PRF 바인딩 미연결(G-4와 중첩).
- **designer**: 명함 후가공박을 NAMECARD_FIXED에 addtn_yn 배선 or 오리지널박명함 전용 PRF 신설+FOIL comp 연결.

## 3. G-3 — 고정가 단가행 결손  🔴 High

- **라이브 실측 단가행수**: COMP_NAMECARD_STD_S1=**2**, S2=**2**, COMP_PHOTOCARD_SET=**1**, CLEAR_SET=**1**.
- **기대**: 명함=소재(mat_cd)×수량(min_qty) 매트릭스 → 수십~수백 행. 포토카드=siz_cd×bdl_qty×min_qty → 다수 행.
- **의심**: 단가행 결손(매트릭스 미완) → 대부분 소재/수량에서 가격 0 또는 매칭실패 가능.
- **designer/검증**: 명함/포토카드 가격표 시트 대비 component_prices 완전성 점검(가격표 셀 수 = 단가행 수 대조). 결손이면 적재 큐(dbmap 위임).

## 4. G-4 — 미바인딩 상품 17  🔴 High

- **실측**: 디지털인쇄 관련 BOUND 25 / **UNBOUND 17**.
- **미바인딩 예**: 펄명함·모양명함·투명명함·형압명함·오리지널박명함·화이트인쇄명함(명함 6 variant) · 투명엽서 · 와이드 접지리플렛 · 봉투류(OPP/카드/트레싱지).
- **함의**: 이 상품들은 라이브에서 가격공식이 없어 **가격계산 불가**(evaluate_price source=NONE).
- **designer**: 각 variant를 적정 PRF에 바인딩 — 명함 variant→NAMECARD_FIXED(소재 차원으로 흡수 가능?) or variant 전용 PRF / 투명엽서→PRF_DGP_A(투명 종이=mat_cd) / 와이드접지→PRF_FOLD_SUM or DGP_E. 봉투류=추가상품 vs 독립상품 경계 컨펌(G-6).

## 5. G-5 — 엽서북 세트조합 미모델  🟡 Med

- **상품마스터**: `엽서북-내지(몽블랑240)` + `엽서북-표지(스노우300)` 별 SKU 행.
- **calc-draft**: 엽서북/떡메 = 고정가형 `[수량행][옵션열]`.
- **갭**: 내지·표지 합산 세트(반제품 조합) 레이어 미모델 — 단일 완제품 공식으로는 내지/표지 분리 단가 합산 불가.
- **designer**: 세트 조합 레이어(내지단가+표지단가)·세트 식별 모델.

## 6. G-6 — 공식 권위 이원화  🟡 Med (컨펌큐)

- 상품마스터 `가격공식` 칸 = 희소(엽서 2행만 합산식)·일부 truncated(`[인쇄-`)·파일명 규칙 혼입.
- **calc-formula-draft 시트가 상품군 단위 정본** — 이 지도는 calc-draft 1차 권위.
- **컨펌큐**: ① 상품마스터 칸 공란/truncated는 결함인가 의도인가 ② 봉투류=추가상품 vs 독립상품 ③ 오리지널박명함=별 공식 확정.

## 7. G-7 — 손지율 +5장 가설  ⚪ Low

- calc-draft `(5) 용지비 = [크기별 기준단가]×[출력매수] + 5장(손지율)`.
- 손지율 +5장이 엔진(pricing.py)에서 계산되는지·DB 단가에 포함인지 미확인 → designer/검증 pricing.py 확인.

---

## designer 우선순위 권고
1. **G-4(미바인딩 17)** + **G-3(단가행 결손)** = 가격계산 불가 직결 → 최우선.
2. **G-1/G-2(박 미배선)** = calc-draft 요구 비목 누락 → High.
3. **G-5(엽서북 세트)** + **G-6(권위 컨펌)** = 구조/경계 → Med.
4. 신규 comp mint는 search-before-mint(FOIL·박 comp 일부 실재) 후.

---

## 아크릴 절 (면적매트릭스형) — 라이브 실측 2026-06-20 · formula-map-acrylic.md 참조

```
아크릴 가격공식 baseline (라이브 실재):
🟢 PRF_CLR_ACRYL(투명 본체·CLEAR3T 165행) · PRF_COROTTO_ACRYL(코롯토·21행)
🟡 COMP_ACRYL_MIRROR3T(52행 단가행만·공식 0) · COMP_ACRYL_CARABINER(부재·미설계)
바인딩: BOUND 1 상품(PRD_000146 아크릴키링) / UNBOUND 29 상품
```

| ID | 갭 | 유형 | 심각도 | designer 작업 |
|----|----|------|--------|---------------|
| G-A1 | **본체 29상품 미바인딩**(키링만 BOUND) | 바인딩 누락 | 🔴 High | 투명 본체 24상품→PRF_CLR_ACRYL(소재=mat_cd 흡수)·미러 본체→PRF_MIRROR_ACRYL. **29상품 evaluate_price source=NONE·가격계산 불가** |
| G-A2 | **미러 공식/배선/바인딩 전무**(MIRROR3T 52행 단가행만) | 가격사슬 단절 | 🔴 High | PRF_MIRROR_ACRYL 신설+배선. ★**바인딩 대상 상품 불명 BLOCKED**(라이브 미러3T 본체 0개·미러=소재옵션 가능성·CPQ 소재레이어 선결·dbmap Q-ACR-9) |
| G-A3 | **코롯토 바인딩 0**(comp/공식 실재·배선됨) | 바인딩 누락 | 🟡 Med | 코롯토 4상품(164/168/165/226)→PRF_COROTTO_ACRYL. ★정체 컨펌(입체/쉐이커/포카=같은 매트릭스? Q-ACR-CO1)·활성 168 우선 |
| G-A4 | **카라비너 comp/공식 전무 + 형상 opt_cd 미채번** | 미설계(2중) | 🟡 Med | COMP_ACRYL_CARABINER 신설(.01·.06·use_dims=[opt_cd])+형상 4 opt_cd 채번+단가행 4(B07 verbatim)+PRF_CARABINER_ACRYL+PRD_000166. 비활성=LOW |
| G-A5 | **CPQ 옵션레이어 전무**(조각수·가공[고리/자석/바디]·소재선택·추가상품) | 옵션 미적재 | 🟡 Med | 상품마스터 옵션칸→CPQ option_groups/items(round-6). 미러 소재선택이 G-A2 선결 |
| G-A6 | nonspec 증가단위(incr) 미백필(11상품 min/max 보유·incr NULL) | 미검증 규칙 | ⚪ Low | nonspec_*_incr 백필(입력 step·가격축 아님)·값=실무진 컨펌(Q-ACR-AC2) |
| G-A7 | 공식 권위 이원화(calc-draft 코롯토=고정가형 vs 가격표 B06=면적매트릭스) | 권위 충돌 | ⚪ Low | 가격표 구조(면적매트릭스) 우선(라이브 COROTTO use_dims 정합)·컨펌큐 |

**★아크릴 핵심**: 단가행은 풍부(238행 가격표 verbatim)·**갭=배선/바인딩**(단가값 결손 아님). 디지털인쇄 동형결함(×qty 폭발·silent 이중합산)은 **없음**(면적단가=개당가·공식당 comp 1개·formula-map-acrylic §6). 유일 가드=신규 면적행 INSERT 시 .02 comp(CLEAR3T) min_qty=1 명시.
**우선순위**: G-A1(미바인딩)>G-A2(미러·BLOCKED)>G-A3(코롯토 바인딩)>G-A4/G-A5. search-before-mint(COROTTO 실재·MIRROR 단가행 실재·CARABINER 부재) 후.

---

## 실사·현수막 절 (라이브 실측 2026-06-20)

| ID | 갭 | 유형 | 심각도 | designer 작업 |
|----|----|------|--------|---------------|
| G-S1 | **후가공 add-on formula 미배선**(오시·미싱·귀돌이·가변·별색 + 배너 타공/봉미싱/큐방/끈/거치 + 거치/우드봉/우드행거/천정고리/린넨마감 comp 전부 라이브 실재하나 PRF_POSTER 공식 disp2~ 배선 **0건**) | 가격사슬 직교 단절 | 🔴 High | gd2-wiring W4: 각 PRF에 후가공 comp(addtn_yn=Y) 배선. 엔진 addtn_yn 미참조·매칭 시만 합산·본체 동시매칭은 U6 공식분리(라이브 완료)로 차단. **현재 후가공 선택해도 가격 반영 0** |
| G-S2 | **미싱(PERF) 차원축 opt_cd 부정합**(다른 후가공 proc_cd 모델과 불일치) | 모델 불일치 | 🟡 Med | gd2-wiring W5: PERF opt_cd→proc_cd·dim_vals.줄수 이설·prc_typ .02→.01·2L/3L use_yn=N. 이설(값동일) 후 배선 |
| G-S3 | **CANVAS_HANGING use_dims 선언↔실데이터 불일치**(siz_width/height 선언이나 실 NULL·min_qty=1 고정3종)·동일 의심 ARTPRINT/CANVAS_FABRIC min_qty 선언잔류 | 차원 선언 오류 | 🟡 Med | use_dims 정정 vs 단가행 채움(실무 컨펌·가격축 정확성) |
| G-S4 | **별색 WHITE 중복행**(silsa-quote U5·dbmap round-23 dedup 트랙·잔류 재실측) | 데이터 정합 | 🟡 Med | 정본 2개(S1/S2)만 배선·형제색 use_yn=N(상당수 COMMIT)·잔류분 재실측 |
| G-S5 | 고정가 단가행 결손 가능성(메쉬배너 1행·PET배너 1행 sparse) | 단가행 결손 | ⚪ Low | 가격표 규격 전건 대조·결손 INSERT(verbatim·import 트랙) |
| G-S6 | CPQ 옵션레이어 전무(소재선택·후가공 택1/택N·거치) | 옵션 미적재 | 🟡 Med | round-6 dbm-option-mapper. 후가공=합산형(가격축)·CPQ=선택 UI |

**★실사·현수막 핵심(아크릴과 정반대)**: 본체 가격사슬은 **거의 완성**(28공식 바인딩+동형결합+신안 전환 라이브 COMMIT·골든 verbatim). **핵심 갭=후가공 배선(G-S1)**·신규 mint 거의 0(후가공 comp 전부 실재). 동형결함(출력매수 곱셈·×qty 폭발·silent 이중합산) **없음**(개당가·.01 단가형·공식당 1 comp·formula-map-silsa-banner §6). 비동형점=수량구간형(미니류)·대형면적 nonspec_incr 차등(현수막 100mm).
**우선순위**: G-S1(후가공 배선)>G-S2(미싱 전환·G-S1 선행)>G-S3/G-S4(차원·별색)>G-S5/G-S6.

---

## 문구 절 (고정가형 + 수량구간할인 / 매트릭스형) — 라이브 실측 2026-06-20 · formula-map-stationery.md 참조

```
문구 가격공식 baseline (라이브 실재):
🟡 PRF_TTEOKME_FIXED(떡메모지·COMP_TTEOKME 112행·upd_dt 2026-06-13) — 단 바인딩 0행
🔴 본체 9상품 = 공식·고정가·comp 전무 (product_prices 0·바인딩 0)
바인딩: BOUND 0 상품 / UNBOUND 11 상품 (전무)
CPQ 옵션: 전 상품 0/0/0
```

**★재분류 [HARD]: 문구 ≠ 디지털 원자합산형 동형.** = 고정가형(본체 9·calc-draft row 119 `[고정가형:문구]`) + 매트릭스형(떡메모 1). 책자와 구조 동근·가격 이질. designer는 디지털 PRF_DGP 패턴을 문구에 적용 금지.

| ID | 갭 | 유형 | 심각도 | designer 작업 |
|----|----|------|--------|---------------|
| G-ST-1 | **본체 9상품 가격 그릇 전무** — 고정가 공식/단가 0(만년다이어리 4·먼슬리·스프링노트/수첩·메모패드·중철노트) | 가격사슬 부재(이중전무) | 🔴 High | 고정가 그릇 결정: ① t_prd_product_prices 직접 고정가(AC열 9000·12000·15000·12000·4500·3000·5000/6000·2500 verbatim) or ② 명함 PRF_NAMECARD_FIXED식 고정가형 공식 신설. **11상품 evaluate_price source=NONE·가격계산 불가**. ★가격 소스=상품마스터 AC열 inline(인쇄상품 가격표 아님) |
| G-ST-2 | **떡메모지 바인딩 0** — PRF_TTEOKME_FIXED·COMP_TTEOKME 112행 실재하나 PRD_000097 미연결 | 바인딩 누락 | 🔴 High | PRD_000097→PRF_TTEOKME_FIXED 바인딩(t_prd_product_price_formulas). 단가행·공식·차원 전부 실재(명함 WIRE 동근·배선만). ★단가행 verbatim·값결함 0 |
| G-ST-3 | **떡메모지 prc_typ .01 단가형 ×qty 폭발 위험** — unit_price=묶음(권) 총액(3200=100장1권 6장) | 가격계산 정합(돈크리티컬) | 🟡 Med | min_qty(6 등) 존재 → 엔진 `(unit÷min_qty)×qty` 검증. 디지털 교정안 A 동형(값불변·골든=묶음권 총액×수량 아님). 골든 8셀 재현으로 ×qty 폭발 부재 확인 |
| G-ST-4 | **CPQ 옵션 레이어 전무**(제본 택일·링컬러·면지·무지내지·page_rule·묶음수) | 옵션 미적재 | 🟡 Med | round-6 dbm-option-mapper. 제본 택1그룹(GRP-BOOK-제본)·트윈링 좌철/상철 param·page_rule(먼슬리 28 고정·떡메모 장수 3). ★가격은 고정가라 옵션 대부분 가격 비기여(생산 UI) |
| G-ST-5 | **반제품 세트=가격축 아님 명시** | 모델 경계(컨펌) | ⚪ Low | 하드커버 표지 sub_prd·면지=생산 BOM(sets)이지 가격축 아님. 디지털 엽서북식 내지+표지 합산 세트 레이어 **불요**(문구=단일 고정가 1건). designer 혼동 방지 |
| G-ST-6 | **미싱제본 MISSING**(소프트 172/레더소프트 175/먼슬리 176 `*출력+미싱`·제본 family 부재) | 생산공정 미적재 | ⚪ Low | BATCH-13(제본 family 미싱제본 mint·dbmap 위임). ★문구=고정가라 제본비 가격 비기여 → designer 가격설계 직접 영향 없음(MES 생산정보 갭) |

---

### 문구 designer 우선순위 권고
1. **G-ST-1(본체 9 가격 그릇 전무)** + **G-ST-2(떡메모 바인딩 0)** = 11상품 전부 가격계산 불가 → 최우선.
2. **G-ST-3(떡메모 ×qty 폭발)** = 돈크리티컬 골든 검증 → High(바인딩 전 확정).
3. **G-ST-4(CPQ)** + G-ST-5/G-ST-6 = 옵션/생산정보 → Med/Low.
4. 신규 그릇: 본체 고정가는 product_prices vs 고정가형 공식 — search-before-mint(명함 PRF_NAMECARD_FIXED·포토카드 PRF_PHOTOCARD_FIXED 선례 검토 후). 떡메모는 신규 mint 불요(전부 실재·배선만).

### 문구 핵심 (디지털/아크릴/실사와 대조)
- **아크릴 "이중전무"보다 더 이른 결함**: 본체 9상품은 공식 그릇 자체 부재 + product_prices 0 + 바인딩 0 + CPQ 0. 떡메모(B)만 단가행·공식 실재(바인딩 0).
- **수량구간할인(DSC_STAT_QTY·문구상품 수량별 구간할인·use_yn=Y) 곱이 모든 문구 공통** — 본체 고정가·떡메모 매트릭스 둘 다 곱. 구간할인 미배선 시 과청구(본체 돈크리티컬).
- 동형결함(인쇄면 silent 이중합산) **부재**(comp 1개·use_dims 명시). ×qty 폭발은 떡메모 prc_typ .01에 잠재(G-ST-3).

---

## 책자 절 (반제품 세트·다부품 합산형 종단 · 라이브 실측 2026-06-20) — formula-map-booklet.md 참조

> 책자 = §18 directive의 "반제품 세트상품"을 처음 본격 다루는 종단. 평면 인쇄물(단일 부품)과 달리 표지·내지·면지·제본이 각자 사양·단가를 갖는 진짜 다부품 세트. **vessel-gap 아닌 data/배선-gap**(그릇 다 보유·가격 합산 미완).

| ID | 갭 | 분류 | 우선순위 | designer 작업 |
|----|----|------|--------|---------------|
| **G-BK-1** | **COMP_BIND_TWINRING 중철(PROC_000018) 단가행 오염** — 트윈링 값(1=4000,4=3000…)으로 적재됨(가격표 중철=3000/2000·삭제된 COMP_BIND_JUNGCHEOL이 정답값 보유). 무선/PUR/트윈링 proc_cd는 정상 | 데이터 정합(돈크리티컬) | 🔴 High | 통합 comp의 중철 8행을 가격표 B01 중철값(3000/2000/1500/1000/1000/700/700/500)으로 교정. 삭제된 JUNGCHEOL 단가행이 정답 verbatim 보유. ★중철책자 부당 제본비 직접 영향 |
| **G-BK-2** | **PRF_BIND_SUM이 삭제된 COMP_BIND_JUNGCHEOL 1개만 참조** — 통합 활성 COMP_BIND_TWINRING(4 proc_cd) 미배선·통합 후 배선 갱신 누락 | 배선 단절(D-WIRE broken) | 🔴 High | PRF_BIND_SUM formula_components를 활성 COMP_BIND_TWINRING(proc_cd 분기)으로 재배선. 4상품(중철/무선/PUR/트윈링)이 같은 공식·proc_cd로 제본방식 분기(use_dims=[proc_cd,min_qty] 이미 보유) |
| **G-BK-3** | **표지/내지/인쇄/면지 가격구성요소 0행** — 가격사슬에 제본비만(완제품가 미완). 표지·내지 인쇄·용지비 미배선 | 가격사슬 부재(다부품 합산 미완) | 🔴 High | DT-BIND-SCOPE 판정 후: 표지 인쇄·용지비 comp + 내지 인쇄·용지비(×페이지수 앱계산) 신설·합산 배선. 단가 소스=디지털인쇄 종이비/인쇄비 단가표(별 시트·E-2·E-3). ★해당 comp의 prc_typ는 디지털 종단 묶음총액 ×qty 결함 상속 위험(교정 전파 점검) |
| **G-BK-4** | **하드커버/포토북 미바인딩** — PRD_000072/077/082/088(하드커버 family)·100(포토북) 공식 바인딩 0 | 바인딩 누락 | 🔴 High | 제본방식별 상품 공식(PRF_<HC무선/HC트윈링/싸바리>_SUM) 1:1 바인딩. 제본비=B02 하드커버 매트릭스(SSABARI 통합 comp 실재·30000~6000). ★표지비 "따로 계산"(B02 메모) 별 comp 필요 |
| **G-BK-5** | **세트 그릇 = 구성(BOM)이지 가격축 아님** | 모델 경계(이중계상 가드) | 🟡 Med | t_prd_product_sets sub_prd(면지 화이트/블랙/그레이·표지 소재)는 생산 BOM·택1 선택지. 면지 4행을 부품 4개 합산하면 이중계상. 세트 "구성"↔세트 "가격" 분리(benchmark P-1b·문구 DT-5 정합). 면지=택1 옵션(가격 비기여 or 면지별 단가차) |
| **G-BK-6** | **이중수량(부수×페이지) 처리** — 제본비=부수 차원(min_qty=주문수량)·내지비=부수×페이지 | 가격계산 정합(돈크리티컬) | 🟡 Med | 제본비는 부수만(min_qty), 내지비는 부수×페이지수(앱 런타임 계산·DB는 부당 단가 룩업). 페이지수=입력 차원(page_rules 보유·SKU 폭발 금지). 두 수량 축 혼동 금지 |
| **G-BK-7** | **CPQ 옵션 레이어 전무**(제본방식 택1·제본방향 좌철/상철·면지색·링컬러·투명커버·코팅·박/형압·page_rule·묶음포장) | 옵션 미적재 | 🟡 Med | round-6 dbm-option-mapper. 제본방식=proc_cd 택1그룹·면지=sub_prd 택1·page_rule(중철 4~28/4·무선 24~300/2)·박/형압(★빨강 제약조건 use_dims)·투명커버(트윈링만). ★가격 기여 옵션(제본방식·면지소재·박/형압) vs 비기여(제본방향·링컬러) 분별 |
| **G-BK-8** | **링바인더(PRD_000088) 시트상 "보류중"·제본 컬럼 공란·page_rule 부재** | 정체 미확정(컨펌) | ⚪ Low | 상품마스터 "(보류중)"·제본방식 미정. 세트 그릇만 실재(표지+면지4). designer 보류 표기·바인딩 대기 |
| **G-BK-9** | **캘린더 제본비(B03)·하드커버 캘린더 comp(CAL_*)는 캘린더 종단** | 종단 경계 | ⚪ Low | COMP_BIND_CAL_WALL(통합 4 proc_cd)·CAL_DESK*(del=Y)는 캘린더 상품 종단에서 바인딩. 책자 스코프 밖(기록만) |

### 책자 designer 우선순위 권고
1. **G-BK-1(중철 단가행 오염)** + **G-BK-2(PRF_BIND_SUM 삭제 comp 참조 재배선)** = 현 라이브 책자 4상품이 잘못된 제본비 산출 → 최우선(돈크리티컬·배선).
2. **G-BK-3(표지/내지/인쇄 comp 신설·합산)** = DT-BIND-SCOPE 판정 후 다부품 합산 완성 → High. 단가 소스 시트 매핑 + prc_typ 교정 전파 점검.
3. **G-BK-4(하드커버/포토북 바인딩)** = 5상품 가격계산 불가 해소 → High.
4. **G-BK-5(세트=BOM 가드)** + **G-BK-6(이중수량)** = 이중계상·돈크리티컬 가드 → Med.
5. **G-BK-7(CPQ)** + G-BK-8/G-BK-9 = 옵션/경계 → Med/Low.

### 책자 핵심 (디지털/아크릴/실사/문구와 대조)
- **첫 진짜 다부품 세트**: 아크릴/실사 "본체+부속 합산"·문구 "단일 고정가"와 달리, 책자는 표지·내지·제본이 각자 사양·단가 → **다부품 합산형**(benchmark P-1/P-6 본격 사례). 세트 그릇(t_prd_product_sets)·page_rules·제본 comp 11종 다 보유.
- **돈크리티컬 .01 해소**: 제본비 .01 단가형 = unit_price가 **진짜 부당가**(가격표 헤더 `제본/수량`·중철 4부=2000원/부) → `.01 × qty` 올바름. **디지털명함 묶음총액 ×qty 결함과 결정적 차이**(엔진 코드 + 가격표 헤더 + 단가행 verbatim 3중 입증).
- **broken의 본질**: PRF_BIND_SUM이 통합 후 삭제된 JUNGCHEOL을 가리키는 stale 배선 + 표지/내지/인쇄 comp 전무 + 중철 단가행 오염. **vessel-gap 아닌 data/배선-gap**(그릇 보유·배선·교정만).
- **통합 comp 패턴 [[dbmap-price-component-grouping]]**: 활성 3 comp(TWINRING/SSABARI/CAL_WALL)가 proc_cd 종류축으로 여러 제본방식 통합·per-method 8 comp는 del_yn='Y' thin-mirror 선행본.

---

## 굿즈/파우치 절 (고정가형 + 변형단가 + 구간할인 타입 종단 · 라이브 실측 2026-06-20) — formula-map-goods-pouch.md 참조

> 굿즈/파우치 = 계산방식은 **5종단 중 가장 단순**(전 86상품 단일 고정가형·면적/원자합산/세트 없음), 그러나 라이브 가격본체 완성도는 **최저**(고정가 0행). 복잡함은 "계산"이 아니라 "데이터 구조"(86상품·303 variant행·19 상품군·변형단가 31상품·구간할인 4타입). 핵심 = **변형고정가 그릇 부재**(vessel-gap).

| ID | 갭 | 분류 | 우선순위 | designer 작업 |
|----|----|------|--------|---------------|
| **G-GP-1** | **★변형고정가 그릇 부재** — 31상품이 옵션 variant별 다른 고정가(사각손거울 S5000/M5500/L6000·머그 6500/7500·보틀 350ml9000/500ml9300·쿠션 단면15000/양면16000). `t_prd_product_prices`는 prd_cd당 unit_price 1개·`option_items`에 add_price 컬럼 없음 = 담을 그릇 전무 | 그릇 부재(vessel-gap·최대 난제) | 🔴 High | 그릇 결정 선결(Q-GP-1): (a)variant별 별 prd_cd / (b)size-매트릭스 formula(PRF_GOODS_SIZED·use_dims=[opt_cd]·아크릴 면적매트릭스 1축 동형·엔진 변경 0·★권고) / (c)option_items add_price 신규 컬럼(DDL). GP-1 단일 55상품은 PRODUCT_PRICE 그대로 |
| **G-GP-2** | **고정가(product_prices) 전무** — 98 활성상품 전부 unit_price 0행 = evaluate_price source=NONE·가격계산 불가 | 가격본체 부재 | 🔴 High | GP-1 단일 55상품 → `t_prd_product_prices` unit_price 적재(상품마스터 `가격` C열 verbatim·PRODUCT_PRICE 경로). GP-2 31상품은 G-GP-1 그릇 결정 후 |
| **G-GP-3** | **변형단가 평탄화 오청구 위험** — GP-2를 GP-1처럼 단일 unit_price로 평탄 적재하면 S/M/L 한 값 → M 주문에 S가격 오청구 | 데이터 정합(돈크리티컬) | 🔴 High | G-GP-1 그릇 결정 **전** 평탄 적재 금지. round-10 size→option 재분류의 가격 함정([[dbmap-change-tracking-round10]]). variant 행별 고정가 보존 |
| **G-GP-4** | **CPQ option_items 전무** — variant축(사이즈등급·기종·면·용량·색상) 미적재. 변형단가의 선택 UX 부재 | 옵션 미적재 | 🟡 Med | round-6 dbm-option-mapper. 옵션형 사이즈(202행)→option_items(ref_dim_cd)·폰기종=기종차원·색상=동가(가격 비기여)·면=도수. G-GP-1 (b/c) 채택 시 가격축과 연동 |
| **G-GP-5** | **가공가산·추가상품 미적재** — 라벨부착(+300)·맥세이프(+6500)·잉크 5cc(+2500)·볼체인(+1000) | 가산항 미적재 | 🟡 Med | 가공=본체 + 정액 가산(addtn_yn)·추가상품=`t_prd_product_addons`+`t_prd_templates` SKU. 색상 variant 추가가격 0(동가·생산 BOM만) |
| **G-GP-6** | **구간할인 바인딩 82·고정가 0** — 할인 골격은 적재(A타입15·B타입11·말랑·FABRIC 50 카테고리단위·할인테이블 4종)이나 base가 0이라 0원 | 가격본체 선결 | 🟡 Med | 고정가 적재 후 구간할인 곱 골든 검증(틴거울 3000×100개 −10%=270,000). FABRIC=카테고리단위 바인딩이라 신규 파우치 추가 시 누락 점검([[dbmap-discount-authority]]) |
| **G-GP-7** | **폰케이스 기종 = Sheet-only·라이브 미등록** — 슬림하드/블랙젤리/임팩트/에어팟/버즈 상품 자체 부재(밴드톡·폰스트랩만 존재) | 상품 미등록(선행) | ⚪ Low | 상품 등록이 가격 적재보다 선행(round-24 Sheet-only 18·신규 노출 누락). 등록 후 GP-2 변형단가(기종별)+맥세이프 가공가산 |

### 굿즈/파우치 designer 우선순위 권고
1. **G-GP-1(변형고정가 그릇)** = 31상품 가격 표현 가능성의 전제 → 최우선(설계 결정·Q-GP-1 컨펌). (b)formula 권고(엔진 변경 0·아크릴 선례).
2. **G-GP-2(고정가 적재)** + **G-GP-3(평탄화 오청구 가드)** = 98상품 가격계산 불가 해소 → High. GP-1 단일 55는 즉시 PRODUCT_PRICE·GP-2 31은 그릇 후.
3. **G-GP-4(CPQ)** + **G-GP-5(가공/추가)** + **G-GP-6(구간할인 골든)** = 옵션/가산/할인 → Med.
4. **G-GP-7(폰케이스 등록)** = 상품 등록 선행 → Low.

### 굿즈/파우치 핵심 (5종단과 대조)
- **계산방식 단일·단순 / 데이터 구조 최복잡**: 전 86상품 = `[고정가형: 굿즈/파우치] = 고정가 + 구간할인 타입 + 추가상품`(calc-draft 122~123). 면적(아크릴/실사)·원자합산(디지털)·매트릭스(떡메모)·세트(책자) 전부 없음. 엔진=`PRODUCT_PRICE`(unit_price×qty)+`_quantity_discount`.
- **문구와 거의 동형·한 단어 차이**: 문구=`수량별구간할인`(단일), 굿즈=`수량별구간할인 **타입**`(A/B/말랑/파우치에코백 택1). GP-1 = 문구 본체(A) 고정가형 완전 동형.
- **GP-2 변형고정가 = 신규 제3유형**: 문구·디지털·아크릴 어디에도 없던 "옵션 variant별 고정가". 떡메모 매트릭스(siz×bdl×qty)와 다르고(굿즈는 단축 opt/siz), 명함 수량브래킷과 다름(굿즈는 사이즈/면/용량/기종축).
- **5종단 중 최저 완성도**: 고정가본체 0행 = 문구 본체(9상품 전무)와 동급이나 굿즈는 98상품. 단 **할인·자재 골격 절반 적재**(구간할인 82·자재 BOM 76상품 — round-1/round-22). 미러(단가행 실재)·명함(comp 실재 미배선)보다 더 이른 결함(가격본체 0행) + GP-2는 그릇 자체 부재.
- **돈크리티컬 안전**: 고정가형은 ×qty 폭발·silent 이중합산 구조적 부재(comp 합산 없음·리지드 단품 개당가). 유일 위험 = GP-3 평탄화 오청구(설계 선결) + (b)formula 채택 시 신규 component_prices min_qty=1 가드(디지털/아크릴 교훈).
