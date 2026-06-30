# booklet-jungcheol-068-full-load-spec.md — 중철 소프트커버책자(068) ★완전 동작화 명세 (표지 member 포함)

> 생성: hsp-set-designer 2026-07-01 · 라이브 읽기전용 SELECT 실측 · DB 미적재(게이트 DRY-RUN + 인간 승인 후 COMMIT).
> 권위[HARD]: `booklet-cover-branch-design.md` rev.2(068A 골든 158,688=제본70,000+표지88,688) · `booklet-068-071-design.md` rev.2 · 077/082 member 패턴(동작 기준·방금 COMMIT) · 단가 verbatim(날조 0).
> 적재본: `booklet-jungcheol-068-full-load.sql`(멱등·FK 위상순) · 부분 적재본 `booklet-jungcheol-068-load.sql`(내지+제본만)을 표지 member까지 확장.

---

## 0. 한 줄 요약

사용자 directive "**표지까지 완전 동작화**" → 부분 적재본(내지287+제본 PRICE≠0)을 **표지 member(288)까지 확장**해 **골든 158,688 도달**. 068=분해형(077/082 통합형 COVERBIND와 근본 다름)이라 표지가 **인쇄+코팅+용지 3비목**으로 쪼개짐. 표지 깔끔 3비목 공식 부재 → **신규공식 PRF_BOOK_COVER**(comp는 전부 재사용·신규 comp 0) + **표지 반제품 PRD_000288 mint** + **셋트행 표지 member 추가**. 표지 펼침 판형 매칭(NO_MATCH)은 **표지 사이즈=A3펼침(SIZ_000174)+판형 SIZ_000499 → pansu=1**로 해소.

---

## 1. ★골든 158,688 도달 경로 (라이브 실측 검증·허용오차 0)

| 비목 | comp | 단가 verbatim(SIZ_000499) | 수량 | 소계 | 귀속 |
|------|------|---------------------------|------|------|------|
| 표지인쇄 | COMP_PRINT_DIGITAL_S1 (POPT_000001 칼라단면·PROC_000004) | min100=**350** | plate_qty(100·pansu1)=100 | **35,000** | 표지 member 288 |
| 표지코팅 | COMP_COAT_MATTE (coat_side=1·PROC_000015) | min100=**500** | 100 | **50,000** | 표지 member 288 |
| 표지용지 | COMP_PAPER (백모120 MAT_000073) | **36.88** | 100 | **3,688** | 표지 member 288 |
| **표지 소계** | | | | **88,688** | (PRF_BOOK_COVER) |
| 제본 | COMP_BIND_JUNGCHEOL (PROC_000018) | min100=**700** | copies=100 | **70,000** | 부모 PRF_BIND_SUM |
| 내지인쇄+용지 | PRF_DGP_INNER (S1+PAPER·28p) | (page파생) | inner_sheets | (가산) | 내지 member 287 |
| **부모+표지 = 158,688** | | | | **158,688** | G-CB-068A verbatim |

★ **검증 손계산(라이브 실측 2026-07-01)**: 인쇄 350×100=35,000 + 코팅 500×100=50,000 + 용지 36.88×100=3,688 = 88,688. + 제본 700×100=70,000 = **158,688**(booklet-cover-branch G-CB-068A byte 일치).
★ **fn_calc_pansu(SIZ_000499, SIZ_000174)=1 실측** → plate_qty(100)=⌈100/1⌉=100 → 표지 3비목 tier가 100매 기준(350/500) 매칭 → 표지 1매=1판 정확. **이것이 표지 35,000(저청구 17,500 아님)의 핵심**.

---

## 2. ★077/082 대비 068 표지 처리 차이 (분해형 vs 통합형)

| 항목 | 077 레더HC / 082 HC링 | **068 중철** | 068 처리 |
|------|----------------------|-------------|----------|
| 표지 가격모델 | ◆통합형 COVERBIND(표지+제본 권당 1단가) | **●분해형(인쇄+코팅+용지 3비목)** | 표지 member에 3비목 공식 부여 |
| 표지 member 공식 | **없음**(가격0·부모 COVERBIND가 표지 책임) | **PRF_BOOK_COVER(3비목)** | ★068 표지 member는 자기 공식 가짐 |
| 표지 member 차원 | 사이즈/판형 미충전(공식0이라 불요) | **사이즈(A3펼침)+판형(499)+인쇄옵션+자재+코팅proc** | 88,688 평가 환원 차원 충전 |
| 표지 반제품 | 078/083 실재 | **부재 → 288 mint** | search-before-mint·MAX=286·287내지→288표지 |
| 면지 | 3~4종 택1(무료) | **없음(소프트커버)** | 셋트행 면지 0 |
| cover_mult | 077=×1·082=×2(BLOCKED) | **×1(중철 펼침·접지·책등 있음)** | 호출자 member.qty=copies×1=copies·×2 BLOCKED 무관 |

★ **068이 077/082와 갈리는 핵심**: 077/082는 통합단가(COVERBIND)가 표지를 흡수 → 표지 member 공식=0이고, 분해형 표지 comp 추가배선은 **double-count 금지**(booklet-cover-branch §2.2). 068은 통합단가가 **없어서**(가격표에 제본비 comp만) 표지를 인쇄/코팅/용지로 쪼개 별 평가해야 함. 따라서 068 표지 member는 **자기 공식(PRF_BOOK_COVER)을 가진 evaluate 단위** = booklet-cover-branch 해법(a)(표지 member 분리).

---

## 3. 적재본 구성 (신규 mint·재사용·INSERT 행수)

| 위상 | 대상 | 종류 | 행수 | 비고 |
|:----:|------|------|:----:|------|
| **PART A (부분 적재본 verbatim·멱등 재확인)** | | | | |
| 1 | PRD_000287 중철책자-내지 | 재확인 mint | 1 | search-before-mint·MAX=286→287 |
| 2a~2d | 내지287 차원(사이즈3·인쇄4·자재9·판형1) | 차원 | 17 | 284~286 동형 |
| 3 | 내지287 공식 PRF_DGP_INNER | 바인딩(재사용) | 1 | 신규 공식 0 |
| 4 | 068 부모공식 PRF_BIND_SUM | NO-OP 멱등 재확인 | 1 | 제본 JUNGCHEOL·이미 정답 |
| **PART B (★표지 member 확장 — 완전 동작화 추가분)** | | | | |
| 5a | PRF_BOOK_COVER 공식 행 | **신규 mint(공식)** | 1 | t_prc_price_formulas·인쇄+코팅+용지 |
| 5b | PRF_BOOK_COVER formula_components | **신규 mint(비목)** | 3 | S1+COAT_MATTE+PAPER·comp 전부 재사용(신규 comp 0) |
| 6 | PRD_000288 중철책자-표지 | **신규 mint(반제품)** | 1 | search-before-mint·287내지→288표지·prd_typ.02 |
| 7a | 표지288 사이즈 | 차원 | 1 | ★A3펼침 SIZ_000174(pansu=1) |
| 7b | 표지288 인쇄옵션 | 차원 | 2 | 칼라단면001 dflt + 칼라양면002 |
| 7c | 표지288 자재(표지용지) | 차원 | 8 | USAGE.01·백모120 dflt(068 완제품 동형) |
| 7d | 표지288 판형 | 차원 | 1 | SIZ_000499(인쇄/코팅/용지 환원 키·pansu=1) |
| 7e | 표지288 코팅공정 | 공정 | 1 | PROC_000015 무광(proc_cd 주입 가드) |
| 8 | 표지288 공식 PRF_BOOK_COVER | 바인딩 | 1 | 표지 88,688 평가 |
| 9a | 068 셋트행 표지288 (seq1·min1/max1) | 셋트행 | 1 | ★완전 동작화 핵심 |
| 9b | 068 셋트행 내지287 (seq2·page4~28/+4) | 셋트행 | 1 | 부분 적재본 verbatim |

**신규 mint 합계**: 공식 1(PRF_BOOK_COVER) + 비목 3 + 반제품 2(287내지·288표지). **신규 comp 0**(전부 재사용). 셋트행 2(표지+내지·면지 없음).

---

## 4. search-before-mint 결과

| 대상 | 라이브 조회 | 판정 |
|------|------------|------|
| PRD_000287/288 | MAX prd_cd=PRD_000286·287/288 미존재 | mint(287내지·288표지) |
| 표지 깔끔 3비목 공식 | 코팅포함 공식 전수=PRF_DGP_A/D/E/_FOIL(후가공 comp 10~14개 혼입·옵션오염) | **재사용 불가 → PRF_BOOK_COVER 신규 mint** |
| comp(S1·COAT_MATTE·PAPER·JUNGCHEOL) | 전부 실재·SIZ_000499 단가행 충전 | **재사용(신규 comp 0)** |
| 단가행(표지인쇄350/코팅500/용지36.88/제본700) | 전건 verbatim 실재 | 재사용 |
| 표지 펼침 사이즈 pansu=1 | fn_calc_pansu(499,174)=1·(172=2·499자신=0) | SIZ_000174 채택 |

---

## 5. ★S8 옵션 오염 가드 (표지 공식 신규 vs 재사용)

- **PRF_DGP_A/D/E/_FOIL 빌리기 부결**: 이 공식들은 COMP_PP_CORNER_RIGHT(코너라운딩)·COMP_PP_PERF_1L(미싱)·COMP_FOLD_LEAF_*(접지)·COMP_PP_VARTEXT_1EA(가변텍스트)·COMP_FOIL_*(박) 등 **굿즈/명함/리플렛 후가공 comp 10~14개**가 섞임. 068 표지에 빌리면 무관 옵션 노출(S8 위반). 가격은 NO_MATCH로 0 기여라 silent overcharge는 없으나 **정책상 금지**.
- **PRF_BOOK_COVER 신규(깔끔 3비목)**: 인쇄(S1)+코팅(MATTE)+용지(PAPER)만. 굿즈/후가공 comp 무혼입. 068~071 분해형 책자 표지 공통 재사용 가능.
- **proc_cd 주입 가드**: S1(proc_grp:PROC_000001)·COAT_MATTE(proc_grp:PROC_000013) use_dims에 proc_cd → 표지 평가 시 인쇄=PROC_000004·코팅=PROC_000015 고정 주입(silent 다중매칭 가드).

---

## 6. 이중합산 0 (비목 단일 귀속)

| 비목 | 표지 member 288 | 내지 member 287 | 부모 068 | 단일귀속 |
|------|:---:|:---:|:---:|:---:|
| 표지인쇄/코팅/용지 | ●(PRF_BOOK_COVER) | ✗ | ✗ | ✅ 표지만 |
| 내지인쇄/용지 | ✗ | ●(PRF_DGP_INNER) | ✗ | ✅ 내지만 |
| 제본 | ✗ | ✗ | ●(PRF_BIND_SUM→JUNGCHEOL) | ✅ 부모만 |

★ COMP_PAPER 충돌 가드: 표지용지(member288·표지mat MAT_000073·USAGE.01)·내지용지(member287·내지mat·USAGE.07)는 **다른 frm_cd·다른 mat_cd·다른 출력매수** → 같은 비용 두 번 안 셈.

---

## 7. 게이트(S1~S8) 확인 포인트

1. **S1 권위 충실**: page_rule 4/28/4 verbatim·표지 단가 350/500/36.88·제본 700 byte 일치.
2. **S2 구성원 반제품 유형**: 287/288 둘 다 PRD_TYPE.02(반제품). 완제품/기성/디자인 아님.
3. **S3 복합PK/FK 무결성**: (068,288)·(068,287) 복합PK·sub_prd FK 실재(mint 후).
4. **S4 가격 e2e**: evaluate_set_price(068·100부·A5·칼라·중철) = **158,688**(허용오차 0)·PRICE≠0·이중합산 0.
5. **S5 경쟁사 흡수**: N/A(데이터 verbatim).
6. **S6 DRY-RUN 적재 가능성**: 멱등 ON CONFLICT·FK 위상(공식→비목→반제품→차원→공식바인딩→셋트행)·단일 트랜잭션.
7. **S7 생성/검증 독립**: codex 2차·게이트 evaluate 재계산.
8. **★S8 옵션 오염**: PRF_BOOK_COVER에 후가공/굿즈 comp 혼입 0(인쇄+코팅+용지 3비목만)·표지 펼침 판형(SIZ_000499)이 다른 책자에 silent 적용 안 됨(068 전용 member).

★ **게이트 주의**: PRF_BOOK_COVER 신규공식·formula_components는 set-designer 본분(t_prd_product_sets) 밖 t_prc_* 영역. 게이트가 evaluate 재계산으로 검증하되, 실 COMMIT은 **§18 가격공식 설계 GO + 인간 승인 후 dbmap**(t_prc_* 영역). 셋트행(위상9)은 set-designer 본분으로 게이트 GO 후 hsp-load-executor COMMIT.
