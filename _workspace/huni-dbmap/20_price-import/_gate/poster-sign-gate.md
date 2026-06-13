# 포스터사인 가격표 import 준비 — 독립 검증 게이트 (P1~P6)

> **검증자** dbm-validator · **2026-06-13** · round-16 잔여(면적매트릭스형·실사 가격 권위). 생성자(빌더)≠검증자.
> **대상** `_workspace/huni-dbmap/20_price-import/poster-sign/{poster-sign-structure.md, poster-sign-decomposition.md, poster-sign-import.xlsx, poster-sign-mapping-flow.md}`
> **권위** 원본 `docs/huni/..._260527.xlsx` 시트 `포스터사인`(openpyxl 전수) · 라이브 `t_prc_*`·`t_siz_sizes` information_schema(읽기전용 실측) · 아크릴 게이트 `_gate/acrylic-gate.md`(동형) · 메모리 [[dbmap-silsa-price-via-poster-sign]]([HARD·사용자] 실사 가격=포스터사인 면적매트릭스 권위).
> **방법** 원본 openpyxl 직접 재카운트 + 라이브 read-only psql 실측. "맞아 보임" 금지.

---

## 종합 평결: **GO** (MINOR 보정 2건 · 차단 0)

포스터사인 = **아크릴 면적매트릭스 동형 + 실사 가격 권위 확정.** 무손실·라이브 정합·동시매칭 0. 빌더 핵심 주장 전건 라이브 실증, 뒤집힌 결함 0. 사람이 읽는 문서(structure·decomposition) 주석 stale 2건은 보정 완료(데이터는 처음부터 올바름·적재 안전성 무영향).

| 게이트 | 결과 | 핵심 근거(직접 실측) |
|--------|------|---------------------|
| P1 그릇=라이브 1:1 | ✅ PASS | 5테이블(formulas/bindings/formula_components/components/component_prices) 컬럼 전건 1:1. `price_formulas`에 `frm_typ_cd`·`prd_cd` 부존재 실측 일치 |
| P2 stale 차단 | ✅ PASS | 4_RU·4b에 `proc_cd`·`opt_cd` 실재(10차원) = round-2 8차원 stale 극복 |
| P3 분해 무손실 | ✅ PASS(주석 stale 1건) | 라이브 comp_prices **105**(material 80+opt 23+POPT 2)·xlsx 4_RU 데이터 **105행**·면적조합 **687** 재카운트. **단 문서/빌드스크립트/xlsx R1 주석이 "103"으로 표기(POPT 2 누락)→데이터는 105로 올바름, 표기만 stale → md 보정 완료** |
| P4 단가/합가 | ✅ PASS | 라이브 53 comp 전건 `PRICE_TYPE.01` 단가형·use_dims `[siz_cd]`23/`[]`18/`[siz_cd,min_qty]`9/`[bdl_qty]`1 정합. 합가형 0(면적매트릭스=siz단독·밴드 9블록만 min_qty) |
| P5 동시매칭0 + 🔴siz BLOCKED | ✅ PASS | `(siz_cd,min_qty)` 중복 0. **면적조합 687 중 siz EXISTS 21·BLOCKED 666(96.9%)** — 빌더 "20/667(97%)" ±1 일치. `4b_GAP_BLOCKED` 별 시트로 분리(NULL 강제 안 함)=정당 |
| P6 🔴가격사슬 부분단절 | ✅ PASS | `formula_components`=**1행**(`COMP_POSTER_ARTPRINT_PHOTO`만)·`product_price_formulas`=**28행**·PET comp_prices 적재됐으나 **어떤 공식에도 미배선** → 27상품 조회불가 = 부분단절 실증. 인화지 600x1800=21600 손계산 일치(원본 A9=21600.0) |

---

## 빌더 주장 대비 (뒤집힘 0 · MINOR 보정 2)

| 항목 | 빌더 표기 | 실측(라이브 권위) | 판정 |
|------|----------|------------------|------|
| comp_prices RU 행수 | "103행(material 80+opt 23)" | 라이브 **105**(POPT 2 `COMP_POPT_BNR_GAKMOK_STR_900_4_GT/LE` 누락)·xlsx 데이터 **105행 정확** | **MINOR 보정** — 데이터 올바름·문서/빌드/xlsx 주석만 103 stale |
| 원본 데이터 범위 | structure "A1:Y311" | 데이터 끝행 **316**(max_row 389 서식) | **MINOR 보정** — Y311→Y316 |
| siz 실재/BLOCKED | "실재 20·BLOCKED 667(97%)" | EXISTS 21·BLOCKED 666(96.9%)·xlsx 4b=667 | 정합(±1·양방향 매칭 가정차) |
| 단가형 .01·687 면적조합·부분단절·실사 권위·아크릴 동형 | — | 전건 라이브 실증 | **확인** |

**뒤집힌 결함 0건.**

## 보정 처리 (2026-06-13)
- ✅ **md 보정 완료**: `poster-sign-structure.md`(데이터 범위 Y311→Y316·comp_prices 103→105·POPT 2 명기·무손실 한줄), `poster-sign-decomposition.md`(4_RU 라이브 103→105·무손실 한줄).
- 🟡 **비차단 잔존(MINOR)**: `build_import_workbook.py` 주석 4곳 + `poster-sign-import.xlsx` `4_component_prices_RU` R1 주석이 "103행"으로 표기. **xlsx 데이터행은 105로 올바라 적재 안전성 무영향** — 빌드스크립트 재실행 시 자동 105로 갱신(다음 빌더 터치 시 정합·세션 보호 위해 이번엔 md만 보정).

## 미해소 컨펌 (인간 결정·Q-PS-1~5)
- **Q-PS-1** 사슬 보강 = 소재별 공식 `PRF_POSTER_<MAT>` 13 분리 vs 단일공식 조건분기(webadmin Phase11 엔진 설계 확인)
- **Q-PS-2** 옵션 add-on = 공식 배선 합산 vs CPQ add_price
- **Q-PS-3** 면적조합 666 siz 채번 시점·범위(영구 격자 vs 부분)
- **Q-PS-4** 타이벡(하드/소프트)·시트커팅 변형 = 별 comp vs 색변형
- **Q-PS-5** 실사 상품↔포스터 소재 매칭 규칙([HARD·사용자] 실사=포스터사인)

실 적재·siz 채번·사슬 보강 배선·prc_typ 검토는 round-5/인간 승인. 라이브 직접 쓰기 0.
