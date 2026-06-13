# 포스터사인 분해 설계 (poster-sign-decomposition) — round-16 (면적매트릭스형·실사 가격 권위)

> **작성** 2026-06-13 · round-16. 입력 = `poster-sign-structure.md`(26블록 해부) + 라이브 `t_prc_*` 실측(2026-06-13 read-only) + `20_price-import/acrylic/acrylic-decomposition.md`(동형 패턴) + `02_mapping/price-formula-types-authoritative.md` + round-14 stale 진단. **분해 기준 = Phase11 가격엔진 `evaluate_price` 매칭 규칙**(보기 좋게 ✗ → 엔진이 먹는 형태 ⭕). **DB 미적재.**

---

## 0. 그릇 (라이브 information_schema 실측 = 권위, 2026-06-13)

스티커·디지털·아크릴 파일럿 교훈 적용 — **라이브 실측 선행**(개념설계 `11-CONTEXT` 아님). 실측 결과:

```
[공식정의]   t_prc_price_formulas(frm_cd, frm_nm, note, use_yn)              ← frm_typ_cd 없음(라이브 실측 확정)
[상품바인딩] t_prd_product_price_formulas(prd_cd, frm_cd, apply_bgn_ymd)     ← 별 테이블(공식정의와 분리)
[배선]       t_prc_formula_components(frm_cd, comp_cd, disp_seq, addtn_yn)
[구성요소]   t_prc_price_components(comp_cd, comp_nm, comp_typ_cd, prc_typ_cd, use_dims jsonb, use_yn, note)
[단가행]     t_prc_component_prices(comp_price_id PK, comp_cd, apply_ymd, siz_cd, clr_cd, mat_cd,
                                    coat_side_cnt, bdl_qty, min_qty, unit_price, note, proc_cd, opt_cd)
                                                                                          ↑신설 ↑신설(8→10차원)
```

- **PRICE_TYPE 코드값 실측 확정**(`t_cod_base_codes`, 컬럼 = `cod_cd`/`cod_nm`/`upr_cod_cd`): `PRICE_TYPE.01=단가형` / `PRICE_TYPE.02=합가형`(둘 다 use_yn=Y).
- **라이브 포스터사인 components 실측**: `COMP_POSTER_*` 30 material + `COMP_POSTEROPT_*` 20 옵션 + `COMP_POPT_*` 3(별색 add-on) = **53종 전건 `prc_typ_cd=PRICE_TYPE.01`(단가형)·`comp_typ_cd=PRC_COMPONENT_TYPE.06`(완제품가/add-on 통가격)**.
- **그릇 엑셀 시트** = `0_README` + `1_price_formulas`(RU 1 + 소재별 신규) + `1b_product_price_formulas`(RU 28 + 바인딩 교체) + `2_formula_components`(RU 1 + 배선 신규) + `3_price_components`(RU 53) + `4_component_prices_RU`(라이브 105행 재현) + `4b_component_prices_GAP_BLOCKED`(siz 미채번 667 면적조합) + `5_qtyband`(사이즈/수량 밴드 참조) + `6_addon_options`(옵션열 분리) + `7_excluded_note`(부유·제외 보존).

---

## 1. 공식 매핑 (포스터사인 = 면적매트릭스 + 수량밴드 혼재)

면적매트릭스형은 **수량축이 없다**(`siz_cd` 1개 차원이 단가). 단, 포스터사인은 **사이즈/수량 밴드 블록(B14~B20·B25·B26)이 다수** → 이 블록은 `siz_cd + min_qty`(수량구간) 2차원 — 아크릴(전건 면적·min_qty NULL)과 결정적 차이.

| frm_cd | 대상 | 구성요소(Σ) | 라이브 상태 |
|--------|------|------------|------------|
| `PRF_POSTER_FIXED`(라이브) | 포스터사인 28상품 전건 바인딩 | **`COMP_POSTER_ARTPRINT_PHOTO` 1개만 배선** | 🔴 1상품(인화지)만 조회가능·27상품 단절 |
| `PRF_POSTER_<MATERIAL>`(신규 제안) | 소재별(매트지/PET/PVC/패브릭/레더/타이벡/메쉬/현수막/밴드류) | 해당 `COMP_POSTER_<MAT>` + 옵션 add-on | ❌ 미배선(comp는 적재됨) |

> **🔴 가격사슬 부분단절(핵심·structure §4.1)**: 라이브 `t_prc_formula_components`는 `PRF_POSTER_FIXED`에 **`COMP_POSTER_ARTPRINT_PHOTO` 1행만** 배선. 28상품이 전부 이 단일 공식에 바인딩됐으므로 **인화지 외 27상품은 자기 소재 단가행이 적재돼 있어도 엔진이 조회 불가**(공식이 그 comp를 안 봄). 아크릴(배선 0행·전건단절)과 양태 다름 = **단일공식+다소재 바인딩의 구조적 결함**.
>
> **해소 방향**(메모리 [[dbmap-price-chain-dwire-per-product-formula]] 상품별 공식): 소재별 공식 `PRF_POSTER_<MATERIAL>` 신규 + 상품→자기소재 공식 바인딩 교체. round-16 그릇은 공식정의+배선+바인딩 교체를 신규 제안해 사슬 완결(단가행 재적재 ✗·재현만). **컨펌 Q-PS-1**(단일공식 유지+조건분기 vs 소재별 공식 분리 — webadmin 엔진 설계 확인 필요).

---

## 2. 🔴 단가형 / 합가형 판별 (Phase11 핵심)

판별 근거 = 가격표 단위 표기 + 라이브 실측.

| 구성요소 군 | prc_typ_cd | 근거 | 엔진 계산 |
|-------------|-----------|------|----------|
| `COMP_POSTER_*`(면적매트릭스 11) | **.01 단가형** | 라이브 실측 전건 `PRICE_TYPE.01`. 매트릭스 셀 = **개당 면적단가**(수량축 없음·"통용 단가"). | `면적단가 × 주문수량` |
| `COMP_POSTER_*`(사이즈/수량 밴드 9·use_dims `[siz_cd,min_qty]`) | **.01 단가형** | 라이브 실측 `.01`. 밴드 단가 = **구간별 개당단가**(수량구간 = min_qty 차원으로 매칭, 합가형 아님). | `구간 개당단가 × 주문수량` |
| `COMP_POSTEROPT_*`·`COMP_POPT_*`(옵션 add-on) | **.01 단가형** | 라이브 실측 `.01`. 추가옵션 통가격(별도 add-on). | `add-on 단가 × 수량` 또는 고정 |

- **합가형(.02) 없음** — 포스터사인 전 구성요소가 라이브 실측 `.01`(단가형). 단가표가 **구간총액(예 "100매 20,000원")이 아니라 개당단가**(수량구간은 단가 자체가 구간별로 다른 단가형). 스티커 타투/팩(세트 총액=합가형)과 달리 **세트 총액 단위 표기 없음**.
- **🔴 밴드의 단가형 판별 주의**: 미니배너(B26) `150x300 / 수량구간 [10000/99/49/19/4 → 2800/3500/4200/4900/6500]`은 **수량 많을수록 개당 싸지는 단가형 단가표**(구간총액 ÷ 환산 아님). 라이브 실측이 `.01`로 확정 — **min_qty 차원 매칭으로 구간별 단가 선택 후 ×수량**(합가형 환산 아님). 추정 아님(라이브 권위).

---

## 3. 🔴 면적매트릭스 → siz_cd long-form 분해 (면적-좌표 회귀 금지)

```
B01 매트릭스 셀 (가로 g, 세로 s) = 단가 p
  → component_prices row:
     comp_cd=COMP_POSTER_ARTPRINT_PHOTO, siz_cd=<(g,s) 규격코드>,
     clr_cd=NULL, mat_cd=NULL, proc_cd=NULL, coat_side_cnt=NULL, opt_cd=NULL,
     bdl_qty=NULL, min_qty=NULL, unit_price=p, apply_ymd='2026-06-01'
```

- **[HARD] 면적-좌표 회귀 금지**(메모리 [[dbmap-price-formula-types-authority]]): 매트릭스를 면적함수(R²)로 적합하지 않음. **격자 단가를 (siz_cd, unit_price) 행으로 언피벗**(라이브 실측 적재방식과 동일·아크릴 동형). off-grid는 §6 ceiling 런타임.
- **use_dims = `["siz_cd"]`**(라이브 실측·B01~B11·현수막). 나머지 9차원 NULL(와일드카드). min_qty NULL = 수량 무관.
- **🔴 BLOCKED 좌표(siz 미채번 667)**: 가로×세로 조합 687 중 **667(97%)이 siz_cd 미실재**. NULL 강제 금지 → **별 시트 `4b_..._GAP_BLOCKED`**(siz_cd `(미채번:GxS)` 표기·채번 요청 대상). 라이브 실재 20조합만 `4_RU`로 정상 적재. (아크릴은 siz 다수 실재라 GAP 소수였으나 포스터사인은 BLOCKED가 압도적.)

### 3.1 사이즈/수량 밴드 → siz_cd + min_qty (아크릴엔 없던 차원)
```
B26 미니배너 (150x300mm, 수량 100개) → 단가 2800
  → component_prices row:
     comp_cd=COMP_POSTER_MINI_BANNER, siz_cd=SIZ_000028(150x300), min_qty=99,
     ... (나머지 NULL), unit_price=2800
```
- **min_qty = 수량구간 하한**(주문수량 이하 최대 min_qty 구간 매칭·Phase11 규칙). 미니배너는 5구간(min_qty 4/19/49/99/10000) — 라이브 실측 그대로.
- use_dims = `["siz_cd","min_qty"]`(라이브). 면적아님·**수량밴드** — 이 블록 siz는 A-시리즈(A3/A2 등)·명시 규격(150x300)이라 **siz 실재율 높음**(BLOCKED 낮음).

### 무손실 검산 (P3·P6 예비)
| 블록군 | 엑셀 데이터셀 | 라이브 물리행 | GAP(미적재) | siz BLOCKED | 손실위험 |
|--------|--------------|--------------|------------|-------------|---------|
| 면적매트릭스 13(B01~B11·B21·B22) | 687(순매트릭스) | ~28 | ~659 | **667 채번필요** | **0**(GAP 정직표기) |
| 사이즈/수량 밴드 9 | ~55 | ~44 | ~11 | 소수 | **0** |
| 이산 사이즈/소재 4(B12/13/23/24) | 26 | ~24 | ~2 | 소수 | **0** |
| 옵션 add-on(옵션열·POPT) | ~21 | 23 | 0 | siz 무관 | **0** |
| **합계** | **789** | **103** | **~672** | **667 BLOCKED** | **0** |

→ **무손실 완결**: `엑셀 = 라이브 재현(RU 103) + GAP(672, 대부분 siz BLOCKED)`. 라이브에 있고 엑셀에 없는 행 = 검증 대상(없어야 round-trip 보존). 옵션열·부유노트 보존(침묵삭제 금지).

---

## 4. use_dims (구성요소별 차원 집합 — 라이브 실측 재현)

| comp 군 | use_dims(라이브 실측) | 안 쓰는 차원(NULL) |
|---------|----------------------|-------------------|
| 면적매트릭스 포스터(B01~B11·현수막) | `["siz_cd"]` | clr·mat·proc·coat·opt·bdl·**min_qty**(수량무관) |
| 사이즈/수량 밴드(B14~B20·B25·B26) | `["siz_cd","min_qty"]` | clr·mat·proc·coat·opt·bdl |
| 옵션 add-on(우드행거·우드봉) | `["siz_cd"]` | min_qty·나머지 |
| 옵션 add-on(타공·끈·큐방·봉제 등) | `[]`(차원무관 고정 add) | 전부 NULL — 선택시 고정단가 |
| 족자 천장후크 | `["bdl_qty"]` | 묶음수 차원 |

- **clr_cd=NULL**: 매트릭스 단가는 도수 무관(별색=공정 규칙·통가격).
- **mat_cd=NULL**: 소재(인화지/PET/PVC/패브릭…)가 **구성요소명에 박혀있음**(comp별 분기) → mat_cd 차원 미사용(아크릴·디지털 별색 동일 패턴).
- **opt_cd/proc_cd=NULL**(본체) / 옵션 comp는 별 comp로 분리(opt_cd가 아니라 별 component로 모델 — 라이브 실측이 `COMP_POSTEROPT_*`를 **별 comp**로 둠, opt_cd 차원 아님).

---

## 5. 옵션 add-on 분리 (현수막 가공옵션·추가옵션 — 별 comp)

| 블록 옵션열 | 라이브 처리(실측) | round-16 |
|------------|------------------|----------|
| 현수막 `가공옵션명`(타공4/6/8·봉제·재단·양면테이프) | `COMP_POSTEROPT_BANNER_NORMAL_PROC_*`(별 comp·use_dims `[]` 고정) | `6_addon_options` 시트(별 comp 재현) |
| 현수막 `추가옵션명`(끈·큐방) | `COMP_POSTEROPT_BANNER_*_ADD_*` | 〃 |
| 족자/캔버스/린넨 추가옵션(천장후크·우드행거·우드봉) | `COMP_POSTEROPT_JOKJA_CEILHOOK`·`_CANVAS_HANGING_WOODHANGER`·`_LINEN_WOODBONG_WOODBONG` | 〃 |
| PET배너 거치대(IN/OUT) | `COMP_POSTEROPT_PET_BANNER_STAND_*` | 〃 |
| 별색 add-on(POPT) | `COMP_POPT_BNR_GAKMOK_STR_900_4*` | 〃 |

> **옵션 = 별 comp(opt_cd 차원 아님)**: 라이브는 포스터 옵션을 `opt_cd` 차원행이 아니라 **별도 component**(`COMP_POSTEROPT_*`)로 모델링. 공식이 본체 comp + 옵션 comp를 **합산**(addtn_yn). 이는 아크릴 카라비너(opt_cd 분기)와 다른 모델 — 라이브 실측 따름(기계적 통일 금지). **컨펌 Q-PS-2**(옵션 add-on 합산이 공식 배선인지 CPQ option add_price인지).

---

## 6. off-grid ceiling (런타임 규칙 — DB 미저장)

- **off-grid = 가로×세로가 매트릭스에 정확히 없으면 → 한 단계 큰 크기 가격**(round-2 권위·메모리 [[dbmap-compute-in-app-db-stores-lookup]]).
- **DB는 격자 단가만 저장**, off-grid 선택은 엔진/위젯 런타임 계산. 그릇에 ceiling 행 생성 안 함(과적재 금지).
- 현수막은 세로 5000mm까지 격자 → off-grid 빈도 낮음. 포스터류는 200mm 간격 격자.

---

## 7. 미적재·갭·BLOCKED 정직표기 (HARD)

| 항목 | 상태 | 처리 |
|------|------|------|
| 면적조합 667 siz 미채번 | 🔴 라이브 siz 부존재(97%) | `4b_GAP_BLOCKED` 시트 — **siz 좌표 채번 요청 후 적재**(NULL 강제 금지·별 시트). 영구격자 vs 부분 컨펌 Q-PS-3 |
| 가격사슬 부분단절(공식 1 comp만 배선) | 🔴 라이브 1행 배선 | `1`·`2`·`1b` 시트 신규 제안(소재별 공식+바인딩 교체) Q-PS-1 |
| 옵션 add-on 합산 귀속 | 🟡 별 comp(라이브) vs CPQ | `6_addon_options` 재현·합산 여부 컨펌 Q-PS-2 |
| 타이벡 하드/소프트 변형 | 🟡 1 comp(라이브)에 변형 구분 불명 | 변형=별 comp vs opt 컨펌 Q-PS-4 |

---

## 8. 자체검산 (recompute sanity — P6 예비)

아트프린트포스터(PRD_000118·인화지·600×1800mm·1개) 엔진 손계산:
```
본체가 = COMP_POSTER_ARTPRINT_PHOTO[siz_cd=SIZ_000321(600x1800)] = 21600원 (라이브 실측·단가형 .01)
× 주문수량 1
→ 21600 (라이브 조회가능 — 인화지는 배선됨)
```
방수포스터(PRD_000120·PET) 손계산:
```
본체 comp = COMP_POSTER_WATERPROOF_PET (단가행 적재됨)
공식 = PRF_POSTER_FIXED → 배선 = COMP_POSTER_ARTPRINT_PHOTO 만 ❌
→ 엔진이 WATERPROOF_PET comp를 안 봄 → 가격 조회불가(🔴 부분단절 실증)
→ 해소: PRF_POSTER_WATERPROOF 신규 + PRD_000120 바인딩 교체 후 조회가능
```
off-grid 예: 650×650mm → 매트릭스 부재 → ceiling 800×800(런타임·DB 미저장).

---

## 9. 미해소 컨펌 (추정 금지)

| ID | 컨펌 | 영향 |
|----|------|------|
| **Q-PS-1** | 가격사슬 보강 = 소재별 공식 `PRF_POSTER_<MAT>` 분리 + 바인딩 교체 vs 단일공식 유지(엔진 조건분기) — webadmin Phase11 엔진 설계 확인 | 27상품 조회불가 해소 방식 |
| **Q-PS-2** | 옵션 add-on(현수막 가공/추가·천장후크 등) = 공식 배선 합산(addtn_yn) vs CPQ option_item add_price | 옵션가 조립 경로 |
| **Q-PS-3** | 면적조합 667 좌표 siz 채번 시점·범위(영구 격자 전건 vs 부분·round-2 "좌표 siz 등록 요청서") | BLOCKED 좌표 적재 |
| **Q-PS-4** | 타이벡(하드/소프트)·시트커팅(무광 색변형) 변형 = 별 comp vs 색변형(가격무관) | comp 분기 |
| **Q-PS-5** | 실사 시트 가격을 이 포스터사인 매트릭스로 매핑할 때 실사 상품↔포스터 소재 매칭 규칙([HARD·사용자] 실사=포스터사인) | 실사 가격 권위 적용 |

---

## 10. 한 줄 현황

포스터사인 분해 설계 완료 — **면적매트릭스형 + 수량밴드 혼재**(아크릴 동형이나 규모 大·min_qty 차원 추가·현수막 5000mm). 면적매트릭스 13(siz_cd·use_dims `[siz_cd]`)·밴드 9(`[siz_cd,min_qty]`)·이산 4·옵션 add-on(별 comp)·**단가형 전건(.01·라이브 실측·합가형 없음)**·소재=구성요소분기/도수=NULL. **🔴 핵심 ①: BLOCKED 압도적 — 687 면적조합 중 667(97%) siz 미채번(별 시트). 🔴 핵심 ②: 가격사슬 부분단절 — 28상품 단일 공식 바인딩이나 공식은 인화지 1 comp만 배선(27상품 조회불가) → 소재별 공식 보강 제안.** [HARD] 실사 가격=이 시트 권위. **무손실: 라이브 105행 전건 엑셀 대조(material 80+opt 23+POPT 2)·미적재 다수(BLOCKED 667) 정직표기**. 컨펌 5건. **다음 = import.xlsx 빌드 + mapping-flow mermaid → validator P1~P6.**
