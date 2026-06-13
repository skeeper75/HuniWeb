# 인쇄후가공 import 준비 — 독립 검증 게이트 (round-16 B)

> 검증자 = 독립 게이트(생성자 아님·빌더 의심·직접 실측). 2026-06-13.
> 권위 = 원본 `docs/huni/...260527.xlsx > 인쇄후가공`(openpyxl 전수 재카운트) + 라이브 `t_prc_*`·`t_cod_base_codes`(`.env.local` `RAILWAY_DB_*` 읽기전용·`db railway`).
> 대상 = `20_price-import/print-finishing/`(structure·decomposition·import.xlsx·mapping-flow).
> **종합 평결: GO (P4만 인간 컨펌 Q-PF-1 — 빌더 처리 정당, 게이트 통과 방해 아님)**

---

## 0. 종합 평결표

| 게이트 | 결과 | 핵심 |
|--------|------|------|
| P1 그릇=라이브 1:1 | ✅ PASS | import.xlsx 4테이블(price_components·component_prices·formula_components·price_formulas) = 라이브 컬럼 1:1 |
| P2 stale 차단 | ✅ PASS | 10차원·단가/합가·use_dims jsonb 반영. round-2 회귀 0 |
| P3 무손실 (216) | ✅ PASS | 원본 6블록 216 가격셀 ↔ import 216 ↔ 라이브 216 — **3원 전건 일치(MISMATCH 0)** 직접 재산출 |
| P4 단가/합가 🔴 | ⚠️ PASS-with-CONFIRM | 거동상 합가형(.02) 정당. 라이브 .01 충돌 **실재**(명함박 comp_nm "합가"인데 .01). Q-PF-1 컨펌 정당 |
| P5 동시매칭0 + 차원 | ✅ PASS | 14 comp 분리·전 차원 NULL·`(comp_cd,min_qty)` 유일. 동시매칭 0 (라이브 실측) |
| P6 가격사슬 | ✅ PASS | PRF_DGP_A(disp16~29)·PRF_DGP_D(7~20) 28배선 + 상품바인딩 9/1 실재 = **완결**(아크릴 단절과 정반대) |

---

## P1 — 그릇 = 라이브 1:1 ✅ PASS

라이브 `t_prc_price_formulas` 컬럼 실측 = `frm_cd·frm_nm·note·use_yn·reg_dt·upd_dt` — **`frm_typ_cd` 컬럼 부재 확인**(메모리 교훈 "frm_typ_cd 라이브 부재" 정합). import.xlsx의 mermaid에 `frm_typ_cd=.02?` 표기가 있으나 이는 price_components의 `prc_typ_cd`를 가리킴(혼동 소지 있는 라벨 — MINOR, 보정 권고). RU 시트 3종(price_components·component_prices·formula_components) 컬럼이 라이브 information_schema와 1:1.

## P2 — stale 차단 ✅ PASS

prc_typ_cd(.01/.02)·use_dims(jsonb)·전 차원(siz/clr/mat/proc/coat_side_cnt/opt/bdl) 반영. round-2 BLOCKED NULL 강제 회귀 0(증분룰은 NULL 강제 대신 별 시트 C1_REF 분리). Phase11 단가/합가 구조 정합.

## P3 — 무손실 216 ✅ PASS (직접 재산출)

원본 시트 openpyxl 전수 카운트 → 6블록 분해 재확인:
| 블록 | 원본 범위 | 셀 |
|------|----------|-----|
| B1 모서리 | A3~A11(9구간)×직각/둥근 | 18 |
| B2 오시 | A17~A26(10)×1/2/3줄 | 30 |
| B3 미싱 | F17~F26(10)×1/2/3줄 | 30 |
| B4 가변텍스트 | A34~A56(23)×1/2/3개 | 69 |
| B5 가변이미지 | F34~F56(23)×1/2/3개 | 69 |
| **합계** | | **216** |

3원 자동 대조(원본↔import↔라이브): **MISMATCH 0 · EXCEL-ONLY 0 · LIVE-ONLY 0**. 빌더 주장 정확.
- 빌더가 프롬프트 명시 3블록(모서리·오시·가변텍스트)을 넘어 미싱·가변이미지까지 6블록 무손실 분해한 것 정당(round-10 침묵삭제 금지).
- 부유셀 A57·F57=100000 note 보존 ✅. 병합셀 K31:N31(빈 값)·증분룰 A12·A27·F27 보존 ✅.

## P4 — 🔴 단가/합가 ⚠️ PASS-with-CONFIRM (빌더 판정 타당·1점 보정)

빌더 판정: 거동상 **합가형(.02)** 이나 라이브 14 comp 전건 **.01** → Q-PF-1 인간 컨펌.

**독립 실측으로 확증:**
1. 코드 마스터 `t_cod_base_codes`: PRICE_TYPE.01(단가형)·.02(합가형) 둘 다 정의(use_yn=Y). 후가공 14 comp(전 144 comp 포함) **전건 .01·.02 적용 0**.
2. 거동 직접 계산: 둥근모서리 1매=2000·100매=2000(정액세트). 오시1줄 장당가 5000→21원(비일정) = **구간총액(합가) 명백**. 단가형이면 장당가 일정해야 함.
3. **결정적 교차증거**: 명함박 comp `comp_nm`이 명시적으로 **"오리지널박 합가(완제품가)"** 인데 `prc_typ_cd=.01` — comp_nm은 "합가"인데 코드는 단가형. 라이브 데이터 자체가 빌더의 "미백필 디폴트" 주장을 입증. foil-small 게이트 동일 결론.
4. round-14 진단 원문(impact-diagnosis.md L90) "144행 전부 .01, 합가형(02)은 아직 미지정 — 합가형 상품 식별은 미래 작업" = 빌더 인용 **실재**(날조 아님).

→ Q-PF-1(인간 컨펌 후 .02 백필) 처리 정당. import.xlsx가 .02 권장값을 담되 라이브 .01을 비고/P4 시트에 병기한 것 모범.

**[보정 1·MINOR] over-claim:** 빌더 decomposition §2가 "14 comp **전부** '합가' 명시(A1·A15·F15)"라 했으나, **가변(텍스트)·가변(이미지) 6 comp는 헤더에 '합가' 표기가 없다**(A32='가변(텍스트)'·F32='가변(이미지)'). 가변 6 comp의 합가 근거는 헤더 표기가 아니라 거동(장당가 비일정)뿐이다. 판정(.02)은 거동으로 유지되나 근거 문구를 "모서리/오시/미싱 8 comp=헤더+거동, 가변 6 comp=거동만"으로 분리해야 정확. → `dbm-price-import-builder` 라우팅.

## P5 — 동시매칭0 + 차원 ✅ PASS

라이브 실측: 14 comp 전건 `opt_cd·proc_cd·siz_cd` 등 전 차원 NULL(nonnull_dims=0), use_dims=["min_qty"]. 줄수/개수는 opt_cd 차원이 아니라 **comp 분리**(CREASE_1L/2L/3L·VARTEXT_1/2/3EA) — foil-small STD/SPC 분리와 동형. 자연키 `(comp_cd, min_qty)` 유일(comp 내 min_qty 중복 0) → 동시매칭 0. 손님이 "둥근모서리" 선택 시 CORNER_ROUND 1개만 매칭. 공정(귀돌이/오시/미싱)=comp군·proc_cd NULL 확인.

## P6 — 가격사슬 완결 ✅ PASS (직접 확인)

라이브 `t_prc_formula_components` 실측:
- PRF_DGP_A: 14 comp, disp_seq **16~29** (빌더 주장 정확)
- PRF_DGP_D: 14 comp, disp_seq **7~20** (빌더 주장 정확)
- **총 28 배선**(14 comp × 2 공식).
- 상품 바인딩 `t_prd_product_price_formulas`: PRF_DGP_A=**9 상품**·PRF_DGP_D=**1 상품** → 사슬 완결(공식→배선→구성요소→단가행→상품 전부 실재). 아크릴(배선0)·foil-small(미적재)과 정반대.
- 증분룰 3건 = DB 미저장·앱 외삽(C1_increment_rules_REF 보존·메모리 "중간계산=앱·DB=룩업" 권위 정합). 정당.

**[보정 2·MINOR] 내부 표기 불일치:** decomposition §0/§1이 "**14 배선**"이라 적은 곳과 §8/mapping-flow가 "**28 배선**"이라 적은 곳 공존. 라이브 실측=28 배선(comp는 14·배선 row 28). 28로 통일 권고. → `dbm-price-import-builder`.

---

## 빌더 주장 적발/대조표

| 빌더 주장 | 독립 실측 | 판정 |
|-----------|-----------|------|
| 216 가격셀 = 라이브 216행 전건 일치 | openpyxl 6블록 216 ↔ 라이브 216 = MISMATCH 0 | ✅ 확증 |
| 라이브 14 comp 전건 .01 (round-14 미백필) | 전건 .01 실측·round-14 L90 인용 실재·명함박 comp_nm "합가"인데 .01 | ✅ 확증 |
| 합가형(.02) 정당·Q-PF-1 컨펌 | 거동(정액세트·장당가 비일정)으로 정당 | ✅ 확증 (단 가변 6 comp 헤더근거 over-claim → 보정1) |
| 증분룰 3건=앱 외삽·C1_REF 보존 | A12·A27·F27 실재·메모리 권위 정합 | ✅ 확증 |
| 가격사슬 완결 (PRF_DGP_A disp16~29·D 7~20) | 28배선·상품바인딩 9/1 실측 | ✅ 확증 |
| frm_typ_cd | 라이브 컬럼 부재 확인 | ✅ (mermaid 라벨 혼동 소지 MINOR) |

**뒤집힌 항목: 0건.** 보정(MINOR) 3건 — ① 가변 6 comp "합가 명시" over-claim(거동근거로 수정) ② "14배선↔28배선" 표기 불일치(28 통일) ③ mermaid `frm_typ_cd` 라벨(prc_typ_cd로 정정). 전부 문구 보정이며 판정·카운트·정합 결론을 바꾸지 않음.

---

## 종합 평결

**GO.** 인쇄후가공 시트는 round-16 시트 중 유일하게 **이미 완전 적재 + 배선 완결 + 216/216 3원 전건 정합**. import.xlsx는 라이브 실재를 충실 재현(RU)했고, 유일 미해소 P4(단가/합가)는 빌더가 추정 금지·인간 컨펌(Q-PF-1)으로 정직하게 분리·명시 — 게이트 통과 방해 아님. MINOR 보정 3건은 `dbm-price-import-builder`에 라우팅(문구 보정·재게이트 불요). DB 미적재 — prc_typ_cd .02 백필은 인간 컨펌 후.
