# 디지털인쇄비 분해 설계 (digital-print-decomposition) — round-16

> **작성** 2026-06-13 · round-16. 입력 = `digital-print-structure.md`(2블록 해부) + 라이브 `t_prc_*` 실측(2026-06-13 read-only) + round-2 `digital-print-price-engine-design.md`(6공식·라이브 적재) + round-14 stale 진단. **분해 기준 = Phase11 가격엔진 `evaluate_price` 매칭 규칙**(보기 좋게 ✗ → 엔진이 먹는 형태 ⭕). **DB 미적재.**

---

## 0. 그릇 (라이브 information_schema 실측 = 권위, 2026-06-13)

스티커 파일럿 교훈 적용 — **라이브 실측 선행**(개념설계 `11-CONTEXT` 아님). 실측 결과:

```
[공식정의]   t_prc_price_formulas(frm_cd, frm_nm, note, use_yn)          ← frm_typ_cd 없음(라이브 실측 확정)
[상품바인딩] t_prd_product_price_formulas(prd_cd, frm_cd, apply_bgn_ymd) ← 별 테이블(공식정의와 분리)
[배선]       t_prc_formula_components(frm_cd, comp_cd, disp_seq, addtn_yn)
[구성요소]   t_prc_price_components(comp_cd, comp_nm, comp_typ_cd, prc_typ_cd[단가/합가], use_dims jsonb, use_yn)
[단가행]     t_prc_component_prices(comp_cd, siz_cd, clr_cd, mat_cd, proc_cd, coat_side_cnt, opt_cd, bdl_qty, min_qty, apply_ymd, unit_price)
                                                          ↑신설        ↑신설(8→10차원 자연키) + comp_price_id PK
```

- **단가형/합가형은 `price_components.prc_typ_cd`로만 표현** — 공식정의(`price_formulas`)엔 유형 컬럼 없음(스티커와 동일 실측).
- **코드값 실측**: `PRICE_TYPE.01=단가형`·`PRICE_TYPE.02=합가형`. 라이브 components 전건 `.01`(round-14 진단대로 합가형 백필 미완).
- **그릇 엑셀 시트** = `1_price_formulas_RU` + `1b_product_price_formulas_RU` + `2_formula_components_RU` + `3_price_components_print_RU` + `4_component_prices_print_RU`(954행) + `4b_..._GAP`(3절 별색) + `9_BLOCKED_binding`(siz 미채번 3상품). `_RU` = 라이브 재현(신규 적재 아님).

---

## 1. 공식 매핑 (디지털인쇄 = 합산형 — 스티커 단순형과 차이)

디지털인쇄비 시트는 **6공식의 공통 부품(인쇄비)**을 공급한다. 공식별 구성(라이브 배선 72행 재현):

| frm_cd | 대상 상품군 | 구성요소(합산 Σ) | use_yn |
|--------|-------------|------------------|:------:|
| **PRF_DGP_A** | 엽서·상품권·종이슬로건 | 인쇄(단/양) + **별색5×2면** + 코팅2 + 용지 + 후가공14 + 박슬롯 = **29 comp** | Y |
| **PRF_DGP_B** | 모양엽서·라벨택 | 인쇄(단/양) + 용지 + 완칼 = 4 comp | Y |
| **PRF_DGP_C** | 인쇄배경지·헤더택 | 인쇄(단/양) + 용지 + 접지 + 타공 = 5 comp | Y |
| **PRF_DGP_D** | 소량전단지 | 인쇄(단/양) + 코팅2 + 용지 + 타공 + 후가공14 = 20 comp | Y |
| **PRF_DGP_E** | 접지카드·접지리플렛 | 인쇄(단/양) + 코팅2 + 용지 + 접지4 + 타공 = 10 comp | Y |
| **PRF_DGP_F** | 썬캡(미출시) | 용지 + 인쇄(단/양) + 완칼 = 4 comp | **N** |

- **합산형 핵심**: `판매가 = Σ components`(addtn_yn='Y'·라이브 전건). Phase11은 addtn_yn 무시하고 런타임 옵션 활성화로 합산 결정(라이브 값은 보존).
- **이 시트가 공급하는 부품** = `COMP_PRINT_DIGITAL_S1/S2`(흑백·CMYK) + `COMP_PRINT_SPOT_*_S1/S2`(별색5종). 6공식 전부에 인쇄비가 disp_seq 1~2(+별색 3~12)로 배선됨.

---

## 2. 🔴 단가형 / 합가형 판별 (Phase11 핵심)

판별 근거 = 가격표 단위 표기 + 수량-단가 거동.

| 구성요소 | prc_typ_cd | 근거 | 엔진 계산 |
|----------|-----------|------|----------|
| `COMP_PRINT_DIGITAL_S1/S2` | **.01 단가형** | A열 수량↑ → 장당가↓(국4절 흑백단면 1→3000, 100→200, 1000000→40). 셀=장당 단가. 헤더 "단면/양면" 장당. | `단가 × 주문수량` |
| `COMP_PRINT_SPOT_*_S1/S2` | **.01 단가형** | 동형(화이트단면 1→3000, 100→800). 장당 단가. | `단가 × 주문수량` |

- **합가형(.02) 없음** — 디지털인쇄비는 전 구성요소 장당가(단가형). 스티커 타투/팩(세트 총액=합가형)과 달리 **구간총액 표기·세트 단위 없음**. 추정 아님 — 가격표 수량축이 "수량(국4절)"이고 각 셀이 장당가로 곱셈 거동(수량↑ 장당가↓ 체감).
- **라이브 일치**: 라이브 `prc_typ_cd` 전건 `PRICE_TYPE.01` 확인(실측). round-2 암묵 단가형을 명시화.

---

## 3. 🔴 도수·면·별색 분해 결정 (엔진 매칭 단위)

가격표 도수 7종 × 면 2종을 어떻게 그릇 구성요소·차원으로 쪼개나:

| 가격표 헤더 | 엔진 분해 | 근거 |
|------------|----------|------|
| 흑백(1도) | `COMP_PRINT_DIGITAL`의 **clr_cd=CLR_000002** | 같은 인쇄비 단가표 내 색수 차이 = 차원 |
| 칼라(CMYK) | `COMP_PRINT_DIGITAL`의 **clr_cd=CLR_000005** | 〃 |
| 별색(화이트) | **별 구성요소 `COMP_PRINT_SPOT_WHITE`** (clr_cd=NULL) | 별색=공정([[dbmap-digitalprint-atomic-formula-unbuilt]] G-1). 별색은 도수 아니라 추가 인쇄 패스 |
| 별색(클리어/핑크/금색/은색) | `COMP_PRINT_SPOT_{CLEAR/PINK/GOLD/SILVER}` | 〃 각 별 구성요소 |
| 단면 | 구성요소 접미 **`_S1`** | 면수가 도수표 전체를 가름 → 차원 아니라 구성요소 분기(라이브 패턴) |
| 양면 | 구성요소 접미 **`_S2`** | 〃 |

> **왜 흑백/CMYK는 차원, 별색은 구성요소?** Phase11 엔진은 손님이 "CMYK 선택" → `COMP_PRINT_DIGITAL`에서 `clr_cd=CLR_000005` 단가행 1개 매칭(차원 매칭). 별색은 기본 인쇄에 **추가로 합산**되는 별도 인쇄 패스라 별 구성요소(addtn_yn 합산). 가격표도 흑백/CMYK는 "기본 도수 택1", 별색은 "추가 인쇄"로 구조가 다름.
>
> **왜 단/양면은 구성요소(_S1/_S2)이고 coat_side_cnt 차원이 아닌가?** 라이브가 단면·양면을 별 구성요소로 적재(DIGITAL_S1=212·DIGITAL_S2=212). 면수가 가격표 전체 컬럼셋을 통째로 가르므로(단면 14컬럼 vs 양면 14컬럼) 한 단가표의 차원이 아니라 별 단가표 = 별 구성요소. coat_side_cnt는 **코팅 면수**(COMP_COAT_*용)이지 인쇄 면수가 아님.

---

## 4. use_dims (구성요소별 차원 집합 — 라이브 실측 재현)

각 구성요소가 실제 쓰는 component_prices 차원(나머지=NULL 와일드카드):

| comp_cd | use_dims (라이브 jsonb) | 안 쓰는 차원(NULL) |
|---------|------------------------|-------------------|
| `COMP_PRINT_DIGITAL_S1/S2` | `["siz_cd","clr_cd","min_qty"]` | mat_cd·proc_cd·coat_side_cnt·opt_cd·bdl_qty |
| `COMP_PRINT_SPOT_*_S1/S2` | `["siz_cd","min_qty"]` | **clr_cd**·mat_cd·proc_cd·coat_side_cnt·opt_cd·bdl_qty |

- **별색 clr_cd=NULL**: 별색은 색이 구성요소명에 박혀있고(WHITE/GOLD…) clr_cd 차원 미사용 — 라이브 실측(SPOT 단가행 clr_cd 전건 NULL).
- **proc_cd·opt_cd=NULL**(신설 차원): 인쇄비는 공정·옵션 차원 미사용.
- **siz_cd**: SIZ_000499(국4절)·SIZ_000077(3절) = 출력판형(임포지션 규격). 상품 표시사이즈 아님([[dbmap-platesize-is-output-paper]]).

---

## 5. component_prices long-form 분해 규칙

```
B01/B02 매트릭스 셀 (수량 r, 도수 d, 면 s)
  흑백/CMYK → comp_cd=COMP_PRINT_DIGITAL_S{1|2}, clr_cd=CLR_{흑백|CMYK}, siz_cd=SIZ_{판형},
              min_qty=r, unit_price=셀값, 나머지 NULL
  별색5종   → comp_cd=COMP_PRINT_SPOT_{색}_S{1|2}, clr_cd=NULL, siz_cd=SIZ_{판형},
              min_qty=r, unit_price=셀값, 나머지 NULL
```

- **동시매칭 0 검증(Phase11)**: 같은 (comp,siz,clr,min_qty)에 단가행 1개만. **자체검산 통과** — 954행 자연키 중복 0(빌드 스크립트 검증).
- **무손실**: 가격표 954 데이터셀 ↔ 954 long 행 round-trip(validator P3). 국4절 742 + 3절 212.

---

## 6. 미적재·갭 정직표기 (HARD)

| 항목 | 상태 | 처리 |
|------|------|------|
| 3절 별색 5종 | 가격표 B62에 별색 없음·라이브도 별색=국4절만 | `4b_..._GAP` 시트(가격표 부재 = 정상·향후 출시 자리) |
| 019 투명엽서·030 지그재그·049 와이드리플렛 | siz 미채번/plate 결함 | `9_BLOCKED_binding`(round-2 D-2/D-5)·인간 승인 |
| 박(대형) 슬롯 | foil 트랙 미해소 | round-2 BLOCKED(이 시트 범위 밖) |
| 048 접지리플렛 재바인딩 | PRF_FOLD_SUM→DGP_E DELETE+INSERT | 인간 승인 마이그(이 시트 범위 밖) |

---

## 7. 미해소 컨펌 (추정 금지)

| ID | 컨펌 | 영향 |
|----|------|------|
| **Q-DGP-1** | 단/양면을 별 구성요소(_S1/_S2)로 유지 vs coat_side_cnt 통합 — 라이브 현행은 별 구성요소. round-15 그릇 단순화 의도와 충돌 여부 | 구성요소 수(인쇄비 2 vs 1) |
| **Q-DGP-2** | 3절 별색 미적재 = 가격정책상 영구 부재인지, 향후 추가 예정인지(GAP 시트 처분) | 3절 별색 상품 가격 |
| Q-DGP-3(참고) | 019/030/049 siz 채번·plate 교정 시점(round-2 컨펌 ③) | BLOCKED 복귀 |
| Q-DGP-4(참고) | 048 재바인딩(round-2 컨펌 ②·이 시트 범위 밖) | DGP_E 정합 |

---

## 8. 자체검산 (recompute sanity — P6 예비)

PRF_DGP_A 프리미엄엽서(016) CMYK 양면 국4절 100매 주문(앱 런타임 합산):
```
인쇄비 = COMP_PRINT_DIGITAL_S2[siz=SIZ_000499, clr=CLR_000005, min_qty≤출력매수] × 출력매수
       = 700(가격표 E26·라이브 일치) × 출력매수
+ 용지비 = COMP_PAPER[mat=종이, siz=SIZ_000499] × (출력매수+5)   ← 별 시트
+ 코팅비 = COMP_COAT_GLOSSY × 출력매수                          ← 코팅 선택 시
+ 후가공/별색/박 = 선택 시 합산
```
출력매수=주문수량/판걸이수(앱·DB 미저장). DB는 [수량행단가] lookup만. 인쇄비 단가 700 = 가격표 E26 일치 → 그릇 정합.

---

## 9. 한 줄 현황

디지털인쇄비 분해 설계 완료 — **합산형**(스티커 단순형과 차이) 6공식의 공통 인쇄비 부품. **단가형 전건(.01)**·use_dims 2종(DIGITAL=[siz,clr,min_qty]·SPOT=[siz,min_qty])·흑백CMYK=clr차원/별색5=구성요소분리/단양면=_S1_S2. **954 단가행 자연키 중복 0·무손실 954셀 일치**. 라이브 전체 기존 적재(재적재 금지·RU 재현). 컨펌 2건(단양면 구성요소 정책·3절 별색 GAP). **다음 = mapping-flow mermaid(완료) → validator P1~P6.**
