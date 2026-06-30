# remediation-spec-booklet-jungcheol-068.md — 068 완전 동작화 교정·적재 명세

> 게이트: hsp-set-gate 2026-07-01 · 종합 GO(조건부·2트랙) · 실 COMMIT 인간 승인 후.

068 게이트는 결함 교정이 아닌 **신규 적재 명세**(068=현재 셋트행 0행·표지/내지 미배선 → 완전 동작화). 결함은 없음. 적재 명세는 의존순서 2트랙.

## 트랙 ② (선행·t_prc_*·BLOCKED→§18/dbmap)

| 항목 | 권위 정답 | 교정/적재 방법 | 대상 t_* | FK 위상 | 돈영향 | 라우팅 | 인간 승인 |
|------|-----------|----------------|----------|---------|--------|--------|:--------:|
| PRF_BOOK_COVER 공식행 | 책자 표지 분해형(인쇄+코팅+용지)·use_yn=Y | INSERT 1행 | t_prc_price_formulas | 선행(no FK in) | 표지 88,688/권 산정 가능(없으면 표지 전액 0) | §18 GO→dbmap | 필요 |
| formula_components 3행 | COMP_PRINT_DIGITAL_S1·COMP_COAT_MATTE·COMP_PAPER(전부 재사용·신규 comp 0)·addtn_yn=Y | INSERT 3행 | t_prc_formula_components | frm_cd FK→PRF_BOOK_COVER | 동상 | §18→dbmap | 필요 |

★ 게이트 검증: 정의 정합·158,688 도달(오차0)·S8 후가공 무혼입·proc_cd 주입 다중매칭 0. 단가행은 라이브 실재(재사용)·신규 단가행 0.

## 트랙 ① (후행·t_prd_*·GO→load-executor)

| 항목 | 적재 방법 | 대상 t_* | FK 위상 | 돈영향 | 인간 승인 |
|------|-----------|----------|---------|--------|:--------:|
| 반제품 287(내지)·288(표지) mint | INSERT(prd_typ.02·MAX286→287/288) | t_prd_products | 선행 | — | 필요 |
| 표지288 차원 | 사이즈1(174)·인쇄옵션2·자재8(USAGE.01)·판형1(499)·코팅proc1(015) | t_prd_product_sizes/_print_options/_materials/_plate_sizes/_processes | prd_cd FK→288·코드 FK 실재 | 88,688 평가 환원 | 필요 |
| 내지287 차원 | 사이즈3·인쇄옵션4·자재9(USAGE.07)·판형1(499) | 동상 | prd_cd FK→287 | 내지비 환원 | 필요 |
| 공식 바인딩 | 288→PRF_BOOK_COVER·287→PRF_DGP_INNER·068→PRF_BIND_SUM | t_prd_product_price_formulas | frm_cd FK(288은 ②선행 필수) | — | 필요 |
| 068 셋트행 2 | 표지288(qty1·min1/max1)·내지287(min4/max28/incr4) | t_prd_product_sets | sub_prd_cd FK→287/288 실재 | 골든 도달 | 필요 |

★ **적재 순서 [HARD]**: ② PRF_BOOK_COVER COMMIT → ① 반제품 mint → 차원 → 공식바인딩(288→COVER FK 유효) → 셋트행. 역순 시 위상8 FK 깨짐(표지 견적0).

## 라우팅 요약
- **§18/dbmap (인간 승인)**: PRF_BOOK_COVER + fc 3행.
- **hsp-load-executor (인간 승인·②후)**: 반제품·차원·셋트행.
- **개발팀 C트랙**: DBLPANSU 내지 이중÷pansu(전 책자 공통·내지비만·1회 해소).
- **dbmap link(선택)**: 068 완제품 USAGE.01 자재 link 일관성(견적 미관여).

## 동형 전파 (참고)
068 패턴(분해형 표지 member + PRF_BOOK_COVER)은 069 무선·070 PUR(둘 다 cover_mult=1·068 동형 적용 가능)에 전파 가능. 071 트윈링·082 하드커버링은 cover_mult ×2 실행 트랙 BLOCKED(엔진 미지원·Q-CB-COVERMULT-ENGINE·별건). 068은 ×1이라 본 패턴으로 완결.
