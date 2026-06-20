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
