# booklet-museon-pur-069-070-load-spec.md — 무선069·PUR070 소프트커버책자 ★완전 동작화 통합 명세

> 생성: hsp-set-designer 2026-07-01 · 라이브 읽기전용 SELECT 실측 · DB 미적재(게이트 DRY-RUN + 인간 승인 후 COMMIT).
> 권위[HARD]: `booklet-cover-branch-design.md`(069=PRF_BIND_MUSEON·070=PRF_BIND_PUR·page 24/300/2·분해형 펼침 cover_mult=1) · 068 full-load(동형 템플릿·방금 COMMIT·표지 88,688 패턴) · 단가 verbatim(날조 0).
> 적재본: `booklet-museon-069-load.sql` · `booklet-pur-070-load.sql`(각 멱등·FK 위상순).

---

## 0. 한 줄 요약

068 중철 완전동작화 패턴(표지 member 분리·PRF_BOOK_COVER 3비목·표지 펼침 판형 SIZ_000499 pansu=1)을 **069 무선·070 PUR에 동형 전파**. 둘 다 분해형 소프트커버·**cover_mult=1**(책등 있음·펼침 ×1)이라 068과 완전 동형. **신규 공식 0**(PRF_BOOK_COVER·PRF_DGP_INNER·제본 부모공식 전부 라이브 재사용) — 반제품 4개(표지·내지)와 셋트행 4개만 mint. 골든: **069=138,688**(제본 MUSEON 50,000+표지 88,688)·**070=288,688**(제본 PUR 200,000+표지 88,688), 각 +내지.

---

## 1. ★골든 도달 경로 (라이브 실측 검증·허용오차 0·100부·표지 칼라단면 백모120 무광)

| 비목 | comp / 공식 | 단가 verbatim(SIZ_000499) | 수량 | 069 소계 | 070 소계 | 귀속 |
|------|-------------|---------------------------|------|---------|---------|------|
| 표지인쇄 | COMP_PRINT_DIGITAL_S1 (POPT_000001 칼라단면·PROC_000004) | min100=**350** | plate_qty(100·pansu1)=100 | 35,000 | 35,000 | 표지 member |
| 표지코팅 | COMP_COAT_MATTE (coat_side=1·PROC_000015) | min100=**500** | 100 | 50,000 | 50,000 | 표지 member |
| 표지용지 | COMP_PAPER (백모120 MAT_000073) | **36.88** | 100 | 3,688 | 3,688 | 표지 member |
| **표지 소계** | PRF_BOOK_COVER | | | **88,688** | **88,688** | 표지 290/292 |
| 제본 | 069=COMP_BIND_MUSEON(PROC_000019)·070=COMP_BIND_PUR(PROC_000020) | 069 min100=**500**·070 min100=**2000** | copies=100 | 50,000 | 200,000 | 부모 PRF_BIND_* |
| 내지인쇄+용지 | PRF_DGP_INNER (S1+PAPER·page파생·MAT_000074=70.64) | (page 24~300/+2) | inner_sheets | (가산) | (가산) | 내지 member 289/291 |
| **부모+표지 합** | | | | **138,688** | **288,688** | 골든 verbatim |

★ **검증 손계산(2026-07-01 실측)**:
- **069**: 표지 88,688 + 제본 MUSEON 500×100=50,000 = **138,688** + 내지(page파생).
- **070**: 표지 88,688 + 제본 PUR 2000×100=200,000 = **288,688** + 내지(page파생).
★ **fn_calc_pansu(SIZ_000499, SIZ_000174)=1 실측** → plate_qty(100)=⌈100/1⌉=100 → 표지 3비목 tier가 100매 기준(350/500) 매칭 → 표지 1매=1판(저청구 가드·068 동형).

---

## 2. ★068 동형 전파 — 차이점만 (3개)

| 항목 | 068 중철 | **069 무선** | **070 PUR** |
|------|---------|-------------|-------------|
| 제본 부모공식 | PRF_BIND_SUM→JUNGCHEOL(min100=700) | **PRF_BIND_MUSEON→COMP_BIND_MUSEON**(min100=500) | **PRF_BIND_PUR→COMP_BIND_PUR**(min100=2000) |
| page_rule | 4/28/4 | **24/300/2** | **24/300/2** |
| cover_mult | 1(중철 접지·책등 있음) | **1**(무선 PROC_000019 책등 있음·펼침) | **1**(PUR PROC_000020 책등 있음·펼침) |
| 표지공식 | PRF_BOOK_COVER(068 신설·COMMIT) | **PRF_BOOK_COVER 재사용**(신규 0) | **PRF_BOOK_COVER 재사용**(신규 0) |
| 내지공식 | PRF_DGP_INNER | PRF_DGP_INNER 재사용 | PRF_DGP_INNER 재사용 |
| 완제품 자재 | 표지288/내지287 member 충전 | 069 완제품 USAGE.01(표지7)·USAGE.02(내지6) 보유 → member 충전 | **070 완제품 자재 0행** → 069 권위 verbatim member 충전 |
| 채번(prd_cd) | 내지287·표지288 | **내지289·표지290** | **내지291·표지292** |

★ 그 외 전부 068 verbatim 동형: 표지 사이즈=SIZ_000174(A3 펼침)·판형=SIZ_000499·인쇄 칼라단면 POPT_000001 dflt·코팅 PROC_000015 무광·proc_cd 주입 가드·셋트행 표지 min1/max1 + 내지 page_rule·면지 0(소프트커버).

---

## 3. 적재본 구성 (신규 mint·재사용·INSERT 행수)

### 3.1 069 무선 (`booklet-museon-069-load.sql`)

| 위상 | 대상 | 종류 | 행수 | 비고 |
|:----:|------|------|:----:|------|
| A1 | PRF_BOOK_COVER 공식 | **NO-OP 재확인** | 0 | 068 COMMIT·라이브 실재(use_yn=Y)·재사용 |
| A2 | PRF_BOOK_COVER 비목 3 | **NO-OP 재확인** | 0 | S1+COAT_MATTE+PAPER·전부 실재·재사용 |
| 1 | PRD_000289 무선책자-내지 | mint(반제품) | 1 | search-before-mint·MAX=288→289 |
| 2a~2d | 내지289 차원(사이즈2·인쇄4·자재6·판형1) | 차원 | 13 | 069 USAGE.02 내지 6종 verbatim |
| 3 | 내지289 공식 PRF_DGP_INNER | 바인딩(재사용) | 1 | 신규 공식 0 |
| 4 | PRD_000290 무선책자-표지 | mint(반제품) | 1 | 289내지→290표지·prd_typ.02 |
| 5a~5e | 표지290 차원(사이즈1·인쇄2·자재7·판형1·코팅proc1) | 차원 | 12 | A3펼침174·SIZ_000499·USAGE.01 표지7종 |
| 6 | 표지290 공식 PRF_BOOK_COVER | 바인딩(재사용) | 1 | 표지 88,688 평가 |
| 7 | 069 부모공식 PRF_BIND_MUSEON | **NO-OP 재확인** | 0/1 | 이미 라이브·note만 멱등(재바인딩 불요) |
| 8a/8b | 069 셋트행 표지290(seq1)+내지289(seq2) | 셋트행 | 2 | ★완전 동작화 핵심·면지 0 |

### 3.2 070 PUR (`booklet-pur-070-load.sql`)

069와 동일 구조(채번 291내지/292표지·제본 PRF_BIND_PUR). 070 완제품 자재 0행이라 member 자재는 069 권위 재사용.

### 3.3 신규 mint 합계 (069+070)

- **신규 공식 0**(PRF_BOOK_COVER·PRF_DGP_INNER·PRF_BIND_MUSEON·PRF_BIND_PUR 전부 라이브 재사용).
- **신규 comp 0**.
- **신규 반제품 4**: 289(069내지)·290(069표지)·291(070내지)·292(070표지).
- **셋트행 4**: 069×2(표지+내지)·070×2(표지+내지)·면지 0(소프트커버).

---

## 4. search-before-mint 결과 (라이브 실측 2026-07-01)

| 대상 | 라이브 조회 | 판정 |
|------|------------|------|
| MAX prd_cd | **PRD_000288**(068 표지·방금 COMMIT) | 069=289/290·070=291/292 |
| PRD_000289~292 | 전부 미존재 | mint |
| PRF_BOOK_COVER | 실재(use_yn=Y·068 COMMIT)·비목 S1+COAT_MATTE+PAPER 3개 verbatim | **재사용(신규 0)** |
| PRF_DGP_INNER | 실재(use_yn=Y) | 재사용 |
| PRF_BIND_MUSEON / PRF_BIND_PUR | 069/070 바인딩 실재(+_FOIL 변종) | **NO-OP**(재바인딩 불요) |
| 표지/내지/제본 단가행 | S1 350·COAT 500·PAPER 36.88·내지PAPER 70.64·MUSEON 500·PUR 2000 전건 verbatim 실재 | 재사용 |
| fn_calc_pansu(499,174) | =1 | SIZ_000174 표지 채택 |

---

## 5. ★S8 옵션 오염 가드 + 이중합산 0

- **PRF_BOOK_COVER = 인쇄(S1)+코팅(MATTE)+용지(PAPER) 3비목만** — 굿즈/명함/후가공 comp 혼입 0(068과 동일·068에서 검증된 깔끔 공식 재사용).
- **proc_cd 주입 가드**: 표지 인쇄=PROC_000004·코팅=PROC_000015 고정 주입(silent 다중매칭 가드). 제본 069=MUSEON 단일 comp·070=PUR 단일 comp(071 TWINRING 4 proc_cd 다중매칭 위험과 무관).
- **이중합산 0**: 표지인쇄/코팅/용지=표지 member만·내지인쇄/용지=내지 member만·제본=부모공식만. COMP_PAPER는 표지(MAT_000073·USAGE.01)/내지(MAT_000074·USAGE.07) 다른 frm_cd·다른 mat_cd라 충돌 없음.
- **★공유공식 경계 준수(§3 옵션오염 방지)**: PRF_BOOK_COVER를 068·069·070 셋이 공유하나, 표지 comp(S1/COAT/PAPER)는 **자기 표지 member에만 바인딩**되고 제본은 각 책자 고유 부모공식(중철 JUNGCHEOL·무선 MUSEON·PUR PUR)이라 한 책자 comp가 다른 책자에 silent 적용되지 않음. 071 트윈링(×2 BLOCKED)은 동형 전파 대상 아님(cover_mult=2 엔진 미지원).

---

## 6. 게이트(S1~S8) 확인 포인트

1. **S1 권위 충실**: page_rule 069/070=24/300/2 verbatim·표지 단가 350/500/36.88·제본 MUSEON 500/PUR 2000 byte 일치.
2. **S2 구성원 반제품 유형**: 289~292 전부 PRD_TYPE.02(반제품). 완제품/기성/디자인 아님.
3. **S3 복합PK/FK 무결성**: (069,290)·(069,289)·(070,292)·(070,291) 복합PK·sub_prd FK 실재(mint 후).
4. **S4 가격 e2e**: evaluate_set_price(069·100부)=**138,688**·(070·100부)=**288,688**(허용오차 0)·PRICE≠0·이중합산 0.
5. **S5 경쟁사 흡수**: N/A(데이터 verbatim·068 동형).
6. **S6 DRY-RUN 적재 가능성**: ★실증 완료(2026-07-01·BEGIN…ROLLBACK·제약위반 0·069/070 각 셋트 2행·반제품 4개·멱등 2회 delta 0). FK 위상(공식 NO-OP→반제품→차원→공식바인딩→셋트행)·단일 트랜잭션.
7. **S7 생성/검증 독립**: codex 2차·게이트 evaluate 재계산.
8. **★S8 옵션 오염**: PRF_BOOK_COVER 3비목만(068 검증 재사용)·표지 펼침 판형 SIZ_000499가 다른 책자에 silent 적용 안 됨(각 표지 member 전용)·공유공식 경계 준수.

★ **게이트 주의**: 069/070은 신규 공식 0(전부 재사용)이라 068과 달리 **t_prc_* 영역 신규 COMMIT 불요**(PRF_BOOK_COVER NO-OP). 셋트행+반제품 차원(t_prd_* 영역)이 본분 — 게이트 GO 후 hsp-load-executor COMMIT. 인간 승인 후 단일 트랜잭션.

---

## 7. BLOCKED / C트랙 (본 SQL 미포함)

| ID | 대상 | 사유 | 라우팅 |
|----|------|------|--------|
| C-TRACK-ENGINE-DBLPANSU | 내지289/291 이중÷pansu(price_views.py:1707) | 전 책자 공통 코드결함·내지비 과소·표지/제본 무영향 | 개발팀 C트랙(1회 교정 전 책자 해소) |
| BLOCKED-MAT070-LINK | 070 완제품 자재 link 0행 | 069는 USAGE.01/02 보유·070 부재(라이브 실측) | member(291/292) 069 권위 충전(견적 정확)·완제품 link 보강은 견적 미관여 선택 정합(dbmap) |
| NA-FOIL-VARIANT | PRF_BIND_MUSEON_FOIL·PRF_BIND_PUR_FOIL | 박 후가공 옵션(박 미선택 기본가)·본체 동작화 불요 | 건드리지 않음(박류 §18 별 트랙) |
| NA-COVERMULT-X2 | 069/070 cover_mult ×2 | 둘 다 책등 있음·펼침 cover_mult=1이라 ×배수 자체 없음 | 071/082(×2) BLOCKED 무관 |
