# booklet-jungcheol-068-load-spec.md — 중철 소프트커버책자(068) 셋트 동작화 적재본 명세

> 생성: hsp-set-designer 2026-07-01 · 라이브 읽기전용 SELECT 실측 · DB 미적재(게이트 DRY-RUN + 인간 승인 후 COMMIT).
> 권위[HARD]: `booklet-068-071-design.md` rev.2 · `booklet-cover-branch-design.md`(데이터 GO/cover_mult×2 BLOCKED 2트랙) · 077/082 동형(방금 COMMIT) · 단가 verbatim(날조 0).
> 적재본: `booklet-jungcheol-068-load.sql`(멱등·FK 위상순).

---

## 0. 한 줄 요약

068 중철책자는 **부모공식 PRF_BIND_SUM=제본비(JUNGCHEOL) 1개만**이라 표지/내지/용지 누락 저청구. 077이 전용지 골든부터·082가 제본+내지부터 PRICE≠0을 달성한 패턴을 068에 전파하되, **068 고유 = 분해형(통합형 COVERBIND 아님) + 표지 반제품·표지공식 둘 다 부재 + 면지 없음(소프트커버)**. 동작화 = **내지 member(PRF_DGP_INNER) 분리 + 제본(기존 부모공식) → 내지+제본 PRICE≠0**. 표지 3비목은 BLOCKED(깔끔한 표지공식·표지 반제품 부재).

---

## 1. ★077/082 대비 068 추가 복잡분 (핵심)

| 항목 | 077 레더HC | 082 HC링 | **068 중철** | 068 처리 |
|------|-----------|----------|-------------|----------|
| 표지 가격모델 | ◆통합형 COVERBIND | ◆통합형(링 신설) | **●분해형(인쇄+코팅+용지 3비목)** | 표지 member 분리 필요(직배선 불가) |
| 부모공식 현황 | 0행(미바인딩) | 0행(미바인딩) | **PRF_BIND_SUM 실재(제본만)** | 재바인딩 불요(NO-OP·멱등 재확인) |
| 표지 반제품 | 078 실재 | 083 실재 | **부재(중철책자-표지 없음)** | mint 필요=BLOCKED |
| 깔끔한 표지공식 | COVERBIND 통합단가 | 신설 COVERBIND_TWINRING | **부재(코팅공식 전부 오염)** | §18 신규공식=BLOCKED |
| 면지 | 3종 택1(무료) | 4종 택1 | **없음(소프트커버)** | 셋트행 면지 0 |
| cover_mult | ×1(무선·책등) | ×2(링·BLOCKED) | **×1(중철·접지·책등)** | ×배수 없음(BLOCKED 무관) |
| page_rule | 24/300/2 | 8/100/2 | **4/28/4** | 셋트행 min/max/incr verbatim |
| ★plt_siz 정합 | 내지=SIZ_000499 | 내지=SIZ_000499 | 완제품판형 SIZ_000250 ≠ 단가행 SIZ_000499 | 내지 member에 SIZ_000499 부여(환원) |

**068이 가장 까다로운 이유**: 077/082는 (a)표지 반제품·(b)표지가격을 통합 COVERBIND 1단가로 흡수 → 표지를 부모공식이 책임. 068은 분해형이라 표지가 인쇄/코팅/용지 3비목으로 쪼개지는데 **그 3비목만 가진 깔끔한 공식이 없고, 표지 반제품도 없다.** → 표지 전체가 BLOCKED. 단 내지+제본만으로도 PRICE≠0 즉시 달성(077의 +3,900 BLOCKED, 082의 표지/면지 BLOCKED와 동형).

---

## 2. 적재본 구성 (신규 mint 1·재사용 다수·INSERT 행수)

| 위상 | 대상 | 종류 | 행수 | 비고 |
|:----:|------|------|:----:|------|
| 1 | PRD_000287 중철책자-내지 | **신규 mint** | 1 | search-before-mint·MAX=286→287·prd_typ.02 |
| 2a | 내지287 사이즈 | 차원 | 3 | A5 dflt/B5/A4 (284~286 동형) |
| 2b | 내지287 인쇄옵션 | 차원 | **4** | ★칼라단/양면(001/002)+흑백단/양면(008/009)·dflt=흑백양면 |
| 2c | 내지287 자재(내지종이) | 차원 | 9 | 백모조100 dflt (USAGE.07) |
| 2d | 내지287 판형 | 차원 | 1 | SIZ_000499(316x467)·인쇄/용지 환원 키 |
| 3 | 내지287 가격공식 | 바인딩(재사용) | 1 | PRF_DGP_INNER(S1+PAPER·신설 0) |
| 4 | 068 부모공식 | 멱등 재확인(NO-OP) | 1 | PRF_BIND_SUM 기존·note만 갱신 |
| 5a | 068 셋트행 내지287 | 셋트 member | 1 | min4/max28/incr4·면지 0·표지 BLOCKED |

- **신규 mint: 1건**(PRD_000287 내지 반제품).
- **재사용: PRF_DGP_INNER·PRF_BIND_SUM·COMP_*·단가행 전부 기존**(신규 공식 0·신규 단가행 0).
- **t_prd_product_sets INSERT: 1행**(내지 member·068=소프트커버라 면지 0).

---

## 3. FK 위상 순서 (적재 순서)

```
[1] t_prd_products (PRD_000287)                         ← 내지 반제품 신설(부모)
 └→ [2a] t_prd_product_sizes        (287 ← siz_cd)      ← 차원
 └→ [2b] t_prd_product_print_options(287 ← print_opt)   ← 차원
 └→ [2c] t_prd_product_materials    (287 ← mat_cd)      ← 차원
 └→ [2d] t_prd_product_plate_sizes  (287 ← SIZ_000499)  ← 차원(환원 키)
 └→ [3]  t_prd_product_price_formulas(287 ← PRF_DGP_INNER) ← 내지 가격공식 바인딩(공식 실재)
[4]  t_prd_product_price_formulas   (068 ← PRF_BIND_SUM) ← 부모공식 멱등 재확인(기존)
[5]  t_prd_product_sets             (068 ← 287)          ← 셋트행(FK: 068·287 모두 실재 후)
```

위상 무결성: 셋트행(5)은 내지287(1)·068(기존) 둘 다 실재 후. 가격공식 바인딩(3)은 내지287(1)·PRF_DGP_INNER(기존) 후. 모든 단가행(COMP_*)·공식(PRF_*)은 기존 실재라 선행 INSERT 불요.

---

## 4. 골든 도달 경로 (PRICE≠0 확인)

`evaluate_set_price(068, members=[내지287], set_selections={제본 proc}, copies=N)`:

```
내지 member (PRF_DGP_INNER · SIZ_000499 · qty=호출자 inner_sheets):
  내지인쇄 S1[SIZ_000499, proc=PROC_000004, print_opt, min_qty tier] × inner_sheets   > 0
  내지용지 COMP_PAPER[SIZ_000499, 내지mat]                            × inner_sheets   > 0
부모공식 PRF_BIND_SUM (068 · qty=copies):
  제본 COMP_BIND_JUNGCHEOL[PROC_000018, min_qty=copies tier] × copies               > 0
  └ 100부 tier=700 × 100 = 70,000 (verbatim 실측)
= base_total > 0  →  PRICE≠0 ✅ (내지비 + 제본비 70,000+)
```

- **제본 골든 verbatim**: JUNGCHEOL PROC_000018 100부=700 → 70,000(라이브 실측 일치).
- **내지 단가 verbatim**(SIZ_000499·PROC_000004): S1 POPT_000001=350·002=700·008=200·009=400(100매)·COMP_PAPER 백모100(MAT_000072)=30.73·백모120(073)=36.88.
- **표지 88,688은 본 SQL 밖**(BLOCKED-COVER-FORMULA) → 현행 동작값 = 내지+제본(표지 저청구 잔존, 0원 아님). 077의 +3,900·082의 표지/면지 BLOCKED와 동형.
- **부모 158,688 골든**(booklet-cover-branch G-CB-068A) = 제본 70,000 + 표지 88,688(인쇄35,000+코팅50,000+용지3,688) — 표지 3비목 신설(BLOCKED) 후에야 완전 재현.

---

## 5. 표지 펼침 siz · 부품 mint BLOCKED 여부

- **표지 펼침 siz**: 068 중철=PROC_000018(접지·책등 있음)=펼침 ×1. 표지 출력판형 = **SIZ_000499(316x467 국4절)** — 라이브 실재(별도 등록 불요·077/082 내지와 동일 판형). booklet-cover-branch가 언급한 "390×268"은 입력문서 표현이며, 라이브 책자류 표지/내지 출력판형은 SIZ_000499로 통일됨(실측). **CFM-COVER-SPREAD-SIZ 해소**(신규 siz 등록 불요·SIZ_000499 재사용).
- **내지 부품 mint**: PRD_000287 신설(BLOCKED 아님·본 SQL 포함·077/082 동형).
- **표지 부품 mint**: **BLOCKED**(중철책자-표지 반제품 라이브 부재 + 깔끔한 표지공식 부재). 표지 3비목 동작화는 §18 표지공식 신설 + 표지 반제품 mint(dbmap·PRD_000288) + 셋트행 표지 member 추가 후. cover_mult=1이라 ×배수 BLOCKED는 무관(호출자 qty=copies 주입으로 즉시 정확·엔진 코드 0).

---

## 6. search-before-mint 결과

| 자원 | 라이브 실재? | 처리 |
|------|:-----------:|------|
| PRF_BIND_SUM (068 부모) | ✅ 실재(068 전용·공유 0) | 재사용(제본비만·표지 미배선) |
| COMP_BIND_JUNGCHEOL | ✅ 실재(PROC_000018 8 tier) | 재사용(verbatim) |
| PRF_DGP_INNER (내지 공식) | ✅ 실재(S1+PAPER·깔끔) | 재사용(077/082 동형·신설 0) |
| COMP_PRINT_DIGITAL_S1·COMP_PAPER 단가행(SIZ_000499) | ✅ 실재(상품 비종속) | 재사용(신규 단가행 0) |
| 내지 반제품(중철책자-내지) | ❌ 부재 | **mint PRD_000287**(본 SQL) |
| 표지 반제품(중철책자-표지) | ❌ 부재 | **BLOCKED**(dbmap mint·§18 트랙) |
| 깔끔한 표지 분해형 공식(인쇄+코팅+용지) | ❌ 부재(코팅공식 전부 굿즈/명함 오염) | **BLOCKED**(§18 신규공식 PRF_BIND_SUM_COVER 등) |
| 표지 펼침 siz | ✅ SIZ_000499 실재 | 재사용(신규 siz 0) |

★ **옵션 오염 가드(§3·S8)**: PRF_DGP_A/D/E(코팅 포함 공식)는 코너라운딩·미싱·접지·가변텍스트 등 굿즈/명함 후가공 comp 8~17개 혼입 → 068 표지에 빌리면 옵션 오염(무관 옵션 노출). 가격은 NO_MATCH로 0 기여(silent overcharge 없음)이나 정책상 금지. 표지공식은 인쇄+코팅+용지 3비목 전용 신규 신설로만 해결.

---

## 7. 게이트 확인 포인트 (hsp-set-gate-validation S1~S8)

| 게이트 | 068 확인 포인트 |
|--------|-----------------|
| S1 권위 충실 | page_rule 4/28/4 verbatim·068 전용 PRF_BIND_SUM·단가 SIZ_000499 verbatim |
| S2 구성원 반제품 유형 | PRD_000287=PRD_TYPE.02(반제품)·068=PRD_TYPE.01(셋트 완제품) |
| S3 복합PK/FK 무결성 | 셋트행 PK(068,287)·내지287 FK 실재·고아 0 |
| S4 가격 e2e | **evaluate_set_price(068) PRICE≠0**(내지+제본 70,000+)·이중합산 0(내지비=내지member만·제본비=부모만) |
| S5 경쟁사 흡수 | 해당 없음(권위 verbatim·흡수 0) |
| S6 적재 가능성 DRY-RUN | 멱등 ON CONFLICT·롤백 무손상·재실행 동일 |
| S7 생성≠검증 | codex 독립 2차(PRF_DGP_INNER 깔끔·표지 BLOCKED 타당성) |
| **S8 옵션 오염** | ★표지공식 미배선 확인(PRF_DGP_A 빌리지 않음)·068 표지에 굿즈/명함 후가공 comp 침입 0·내지 PRF_DGP_INNER=S1+PAPER 2비목만 |

- **이중합산 0**: 내지인쇄/용지 = 내지287 member만 / 제본비 = 부모공식 PRF_BIND_SUM만 / 표지 = 미배선(BLOCKED). 같은 비용 2회 귀속 없음.
- **DBLPANSU**: 내지 이중÷pansu(C트랙·전 책자 공통)는 골든 페이지 환산 시 입력값 우회 — 게이트 골든 재계산 시 명시.
- **NO-GO 신호**: PRICE=0(내지 판형 SIZ_000499 미환원·제본 단가행 NO_MATCH) → 위상 2d 누락 점검.
