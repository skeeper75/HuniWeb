# 072 하드커버책자 하이브리드 — 교정 명세 (게이트 확정 결함)

검증: hsp-set-gate · 2026-06-25 · 라이브 읽기전용 재실측 근거 · 실 COMMIT/DDL은 인간 승인 후 dbmap/§18 위임

명세 포맷: {결함 · 권위 정답 · 교정 · 대상 t_* · FK 위상 · 돈영향 · 라우팅 · 인간 승인}

---

## R-1 [🔴 돈 크리티컬·NO-GO 차단] CFM-INNER-TOTSHEET — 내지 페이지 곱 미반영 (19.6배 과소청구)
- **결함**: 내지가 본체 072 통합 상태 → PRF_HC_BODY 내지인쇄(S2)가 본체 copies로만 평가. `plate_qty(copies, pansu)`는 부수÷판수 1단계만 환산(페이지 곱 미반영). 골든(50권·100p): 정석 1,250매×326=407,500 vs 현 13판×1,600=20,800 → **386,700원 과소(19.6배)**.
- **권위 정답**: 내지인쇄비 = 총내지매수 × 단가, 총내지매수 = `derive_inner_sheets(copies, pages, pansu)` = 부수×⌈페이지/판걸이⌉(pricing.py:702). 권위 page_rule 24~300/+2(라이브 실측).
- **교정**: **내지를 별도 반제품 구성원으로 승격**(하이브리드 정석) — ① 내지 반제품 prd 등록(PRD_TYPE.02·search-before-mint) ② t_prd_product_sets에 내지 구성원 행 추가(disp_seq) ③ 뷰 레이어(`price_views.py` _set_members_meta:1501·derive_inner_sheets:702)가 내지 member qty=총내지매수 산출 → evaluate_set_price 구성원 평가에서 페이지 곱 반영. **대안(비권장)**: 본체 공식 한계 수용(과소청구 확정·금지).
- **대상 t_***: t_prd_products(내지 반제품)·t_prd_product_sets(member 행)·바인딩.
- **FK 위상**: 내지 prd → sets member → 내지 공식 바인딩.
- **돈영향**: 386,700원/골든(저청구) — 부수·페이지 클수록 확대.
- **라우팅**: dbmap(내지 반제품 등록 + sets 행) — **인간 승인 필수**. codex CN-4/D4(`reconcile-ext.md:37,47`) 미해결과 동일 뿌리 → 권위 판정(내지 member vs 부모옵션) 선행.
- **인간 승인**: 필요(구조 변경·돈 크리티컬).

## R-2 [🔴 돈 크리티컬] CFM-INNER-PAPER — 내지 종이 자재 미등록 (no-match 0원·게이트 신규 적발)
- **결함**: 072 materials = {면지색 MAT_000001/2/3·전용지 MAT_000246}뿐 — **내지 종이 자재 미등록**. PRF_HC_BODY seq2 내지용지(COMP_PAPER)는 매칭할 mat_cd가 072에 없음 + MAT_000246 PAPER 단가행 0행(실측) → no-match 0원. 설계는 "내지종이 단가행 기적재(🟢 READY)"라 주장했으나 **라이브 미등록**.
- **권위 정답**: 가격표 내지용지 절가행(상품마스터 내지 용지 컬럼) — 권위 종이별 절가.
- **교정**: 내지 종이 자재를 072(또는 R-1 승격 시 내지 반제품)에 등록 + COMP_PAPER 단가행 적재(verbatim). search-before-mint.
- **대상 t_***: t_prd_product_materials·t_prc_component_prices(COMP_PAPER).
- **돈영향**: 내지용지비 전액 미산출(0원).
- **라우팅**: dbmap. **인간 승인 필요**.

## R-3 [🔴 설계 오류 정정] CFM-COVER-MAT — 표지 자재 MAT_000246 단가행 0행
- **결함**: 설계는 "MAT_000078 vs MAT_000246 단가 동일 46.65(돈영향0)"이라 표기. **라이브 재실측: MAT_000246(전용지)=PAPER 단가행 0행**. 46.65는 MAT_000078(아트지150g) 단독. 072에 등록된 표지 자재는 MAT_000246(전용지)인데 단가행이 없음 → 표지용지는 mat_cd=MAT_000078 명시 주입해야만 산출(072 등록자재로는 0원).
- **권위 정답**: 표지용지=아트150(MAT_000078)·국4절·46.65(가격표 verbatim).
- **교정**: PRF_HC_COVER member.selections.mat_cd=MAT_000078 고정 주입(설계대로) — 단 072 등록자재(MAT_000246)와 불일치 명시. 또는 MAT_000246에 PAPER 단가행 적재.
- **돈영향**: 미해소 시 표지용지 0원(2,332.5/골든 누락).
- **라우팅**: 적재 시 mat_cd 택1 확정 — **인간 확인**.

## R-4 [🟡 CONFIRM] CFM-INNER-PLATE — 내지 인쇄판형 국4절 주입
- **결함**: S1/S2 단가행 plt_siz={SIZ_000077,SIZ_000499}만(실측). 072 plate_sizes={SIZ_000250,SIZ_000252}는 인쇄단가 0행 → set_selections.plt_siz_cd 자동도출 시 no-match 0원.
- **교정**: set_selections.plt_siz_cd=SIZ_000499(국4절) 명시 주입 또는 072 plate_sizes에 국4절 추가.
- **돈영향**: 미주입 시 내지인쇄 0원 가드.
- **라우팅**: 뷰 레이어 주입 or dbmap. **인간 확인**.

## R-5 [🟡 CONFIRM] CFM-COVER-SPREAD-SIZ — 표지 펼침 siz
- **결함**: 표지 펼침(390x268) 미등록. 임시 근사 SIZ_000326(390x290)으로 pansu=1 동작(라이브 검증). 표지 펼침 siz로 줘야 pansu=1 정합.
- **교정**: dbmap siz 신설(search-before-mint) 또는 SIZ_000326 임시 사용(돈영향: 1-up 동일).
- **돈영향**: 0(둘 다 pansu=1). 표지 바인딩 선결조건.
- **라우팅**: dbmap. 인간 승인.

## R-6 [🔴 BLOCKED] CFM-COVER-A4PLT — A4 표지 3절 절가
- **결함**: COMP_PAPER 아트150 단가행 = 국4절(SIZ_000499) 1판형뿐(실측). A4(SIZ_000172) 표지 3절 절가행 0행. 권위 89.54 존재(설계 인용)이나 라이브 미적재.
- **교정**: dbmap 아트150 3절(89.54) 적재(verbatim·신규mint 아님·적재만).
- **돈영향**: A4 표지용지 미산출.
- **라우팅**: dbmap. 인간 승인.

## R-7 [🟢 권고·부작용0 입증] CFM-S2-REVIVE — S2 부활
- **결함**: COMP_PRINT_DIGITAL_S2 del_yn=Y. 양면 내지 단가 212행(verbatim) 비활성.
- **게이트 재실측**: ① S2 참조 활성 formula_components **0건**(실측) ② component_prices 212행 ③ DRY-RUN UPDATE 1·2회 멱등(del_yn=Y 조건부)·부작용0. **부활 안전 입증.**
- **교정**: `UPDATE t_prc_price_components SET del_yn='N' WHERE comp_cd='COMP_PRINT_DIGITAL_S2' AND del_yn='Y';`(verbatim·단가행 불변).
- **돈영향**: 양면 내지 정확청구(미부활 시 S1단면 복제=과소 함정 회피).
- **라우팅**: dbmap UPDATE. 인간 승인.

## R-8 [🟡 비차단] 바인딩 ON CONFLICT 키 오류
- **결함**: apply.sql 주석 바인딩이 `ON CONFLICT (prd_cd,apply_bgn_ymd)` 표기. 라이브 PK=(prd_cd,frm_cd,apply_bgn_ymd)(실측).
- **교정**: 주석 해제 전 `ON CONFLICT (prd_cd,frm_cd,apply_bgn_ymd)`로 정정.
- **라우팅**: load-executor 적재 SQL 교정. 인간 확인.

---

## 라우팅 요약
| ID | 상태 | 트랙 | 인간 승인 | 돈 |
|---|---|---|---|---|
| R-1 INNER-TOTSHEET | 🔴 NO-GO 차단 | dbmap(내지 member 승격) | 필수 | Y(19.6배) |
| R-2 INNER-PAPER | 🔴 | dbmap(자재+단가행) | 필수 | Y(전액) |
| R-3 COVER-MAT | 🔴 정정 | 적재 mat 택1 | 필수 | Y |
| R-4 INNER-PLATE | 🟡 | 주입/dbmap | 확인 | 가드 |
| R-5 COVER-SPREAD | 🟡 | dbmap siz | 승인 | 0 |
| R-6 COVER-A4PLT | 🔴 BLOCKED | dbmap 적재 | 승인 | Y |
| R-7 S2-REVIVE | 🟢 안전입증 | dbmap UPDATE | 승인 | Y(양면정확) |
| R-8 바인딩키 | 🟡 비차단 | load-executor | 확인 | 0 |

**072 본체(PRF_HC_BODY) 바인딩 적재는 R-1·R-2 해소 전 금지(돈 크리티컬). 표지(PRF_HC_COVER) 바인딩은 R-3·R-5 해소 후 가능.**
