# 068~071 셋트 미구성 4종 책자 종단 설계 — 072 패턴 동형 청사진 (rev.2 · 가격공식 원리 보정)

생성: hsp-set-designer · 권위=상품마스터(260610) booklet-l1·계산공식집 + 인쇄상품 가격표(260527) 절대 · 라이브 읽기전용 실측(2026-06-29) · **DB 미적재**(설계+적재본 CSV/멱등 SQL까지·실 COMMIT은 게이트 GO+인간 승인 후 load-executor·구성원 반제품 mint는 BLOCKED→dbmap 위임).

> ★rev.2 보정(2026-06-29): 권위 큐레이터 `booklet-formula-principle.md`(책자 가격공식 원리 정답표) + `prevsite-harvest-booklet.md`(이전사이트 거동 S-A~S-D) + `04_codex/reconcile-068-071.md`(Q-A 표지용지·Q-E S2) + 라이브 재실측 반영. 보정 = **R-2(071만 표지 ×2)·R-3(내지 ×1·면 배선 정밀화)·R-4(표지 단/양면 도수축)·Q-A(표지용지비 단일귀속)·★면축 진원 정정(단/양면 = print_opt_cd로 갈림·S2 부활 불요)**. 보정 이력 = §0.1·골든 갱신 = §6.3.

스코프: **중철책자 PRD_000068 · 무선책자 PRD_000069 · PUR책자 PRD_000070 · 트윈링책자 PRD_000071** — 현재 라이브에 **셋트 구성원 0행**(미구성)·각자 **제본비 comp 1개만** 바인딩 = 종이·인쇄·표지값 전부 누락 = **심각 저청구**.

입력: `01_authority/`(set-authority-spec §7·component-boundary.csv·set-checklist·reuse-map) · `02_reference/`(domain-set-bom §6·068~071 BOM 차이) · `06_load/inner-promotion/`(072 PRF_DGP_INNER·PRF_HC_MUSEON_SET 정답 패턴·cover-spine-principle) · `03_design/hardcover-book-design.md`(072 종단 설계) · `raw/webadmin/catalog/pricing.py:718`(evaluate_set_price 계약).

> ★실행 모드(사용자 확정): "설계도 전체 먼저". 구성원 반제품(표지·내지)이 라이브에 **0개**지만, 부품이 있다고 가정하고 **부품 명세를 포함한 완전한 청사진**을 끝까지 그린다. 실제 셋트 행 적재(t_prd_product_sets)는 부품 mint 후로 BLOCKED 표시(dbmap/§7·인간 승인). search-before-mint는 유지(이 하네스가 부품을 직접 mint하지 않음).
> ★사용자 directive: **면지 없음**(068~071=표지+내지 2구성원만·소프트커버=면지 없음·권위 빈칸 정합) · **새 가격공식 신설 금지**(072 PRF_DGP_INNER + 부모공식 패턴 재사용·전사).

---

## 0. 결론 요약 (한눈에 · executive)

| # | 결정 | 근거 |
|---|---|---|
| **D1** | **각 책자 = 표지(SEMI_ROLE.02) 1 + 내지(SEMI_ROLE.01) 1 = 2구성원만**(면지 없음·사용자 확정·booklet-l1 면지 빈칸 정합) | set-authority-spec §7.2·component-boundary.csv·domain-set-bom §6.1(면지=없음 4종 전부) |
| **D2** | **구성원 반제품 전부 라이브 미존재(0행) → 셋트 행 적재 = BLOCKED**(부품 mint 선결·dbmap/§7·인간 승인). 본 설계는 placeholder prd_cd(예약 채번)로 청사진 완성 | set-authority-spec §7.3·라이브 실측 t_prd_product_sets 068~071=0행·표지/내지 반제품 0행 |
| **D3** (rev.2) | **부모 셋트공식 = 표지인쇄 + 표지코팅 + 표지용지 + 제본 4 comp 분해 배선**(표지측 비목 4개·Q-A로 표지용지 추가). COVERBIND(072 권당 통합단가)는 068~071 미적용(가격표에 통합단가 없음). **표지 단/양면 = print_opt_cd(POPT1단면/POPT2양면)·coat_side_cnt(1/2) selection 분기**(R-4). **071만 표지인쇄·코팅·용지 ×2**(R-2·068~070 ×1). 새 단가 아닌 기존 comp 조립(BLOCKED-FORMULA·dbmap) | calc-formula seq63 6비목 "내지인쇄+표지인쇄+표지코팅+제본+용지+후가공" · 라이브 S1 print_opt 단/양면 2배 실측·COMP_PAPER 국4절 절가·reconcile Q-A |
| **D4** (rev.2) | **내지(속지) 구성원 = PRF_DGP_INNER 재사용**(COMP_PRINT_DIGITAL_S1 인쇄비 + COMP_PAPER 용지비·page파생 qty). 내지 ×1(page파생)·단/양면=print_opt_cd selection(S2 부활 불요·S1 하나로 충분). 072 내지 PRD_000284가 쓰는 그 공식 그대로 | 라이브 PRF_DGP_INNER 실재(072 내지284 바인딩·S1+COMP_PAPER·use_dims print_opt_cd)·내지 전 책자 ×1(booklet-formula-principle §6)·page파생=derive_inner_sheets |
| **D5** | **표지 구성원 = 가격0(공식 미바인딩)**. 표지인쇄·표지코팅·표지용지 비용은 전부 부모공식에. 표지는 생산연결(별도설정 종이 택1)만 | 072 표지073 패턴 동형(072는 COVERBIND 통합·068~071은 부모공식에 분해)·set-authority-spec §7.5 |
| **D6** (rev.2) | **이중합산 0**: 표지인쇄·표지코팅·표지용지·제본 = 부모공식에만 · 내지인쇄·내지용지 = 내지 구성원에만. 같은 비목 두 곳 금지. 표지 구성원엔 가격공식 미부여(0). ★표지용지·내지용지 comp는 같은 COMP_PAPER지만 frm_cd 분리(부모 vs 내지)·plt_siz/mat_cd selection 다름 → 충돌 0 | §18/072 정합·evaluate_set_price=Σ구성원+부모공식·reconcile Q-A 단일귀속 |
| **D7** | **내지 페이지 가변범위(min/max/incr)를 내지 member에 충전**: 068=4/28/4 · 069=24/300/2 · 070=24/300/2 · 071=8/100/2. 표지 member=1/1/NULL(권당 1장). 제작수량(부수)은 셋트행 아님(evaluate_set_price copies 인자) | booklet-l1 r3-36 내지페이지·component-boundary.csv·072 내지284 셋트행 24/300/2 선례 |

**핵심 결함 해소**: 현재 4종은 "제본비만" 청구(5비목 누락) = 책 한 권 가격에서 종이·인쇄·표지가 전부 빠진 심각 저청구. 이 설계는 072 동형으로 6비목을 **부모공식(표지인쇄+표지코팅+표지용지+제본) + 내지 구성원(내지인쇄+내지용지)**으로 정확 분담한다.

---

## 0.1 ★rev.2 보정 이력 (무엇을·왜·원리 근거)

| 보정 | rev.1(이전) | rev.2(보정) | 원리 근거 |
|---|---|---|---|
| **면축 진원 정정** | "단/양면 = comp 접미사 S1단면/S2양면, 양면=S2 부활 선결" | **단/양면 = `print_opt_cd`(POPT_000001 단면 / POPT_000002 양면) selection으로 갈림. COMP_PRINT_DIGITAL_S1 하나로 충분·S2 부활 불요** | 라이브 실측: S1 국4절 POPT1(단면) 100매=350 vs POPT2(양면)=700(양면 2배)·use_dims에 print_opt_cd. POPT 코드값=단면/양면(흑백/칼라 아님). prevsite S-D(내지인쇄 면 무관처럼 보인 건 같은 print_opt 비교 착시·실은 POPT가 면축) |
| **R-4 [1순위·돈]** | 표지인쇄=S1 단면 기본·"양면 시 S2 별행" | **표지인쇄·표지코팅에 단/양면 selection이 손님 선택대로 흐르게 배선**(표지인쇄 print_opt_cd 단/양면·표지코팅 coat_side_cnt 1/2). 양면 주문이 양면 단가(국4절 양면 2배·prevsite +60~67%) 받음 | booklet-formula-principle §4(1면 단가 기준)·prevsite S-A(068~070 표지 10,000→16,000·071 6,000→10,000)·라이브 print_opt/coat_side_cnt 분기 |
| **R-2** | 071 표지 ×2(앞뒤)·068~070 ×1 | **유지 + 명시: 071만 표지인쇄·표지코팅·표지용지 ×2(앞뒤 낱장)·068~070 ×1(펼침). ×2는 도수축(단/양면)과 독립** | booklet-formula-principle §1·§3(트윈링 ×2 verbatim·1면 단가라 ×2 정당)·cover-spread-x2-domain-check §1(링제본=앞뒤 물리 2장) |
| **R-3** | 내지=page파생·"면별 S1/S2 분기" | **내지 ×1 page파생 유지 + 면 배선 정밀화: 내지인쇄=COMP_PRINT_DIGITAL_S1·면=print_opt_cd selection / 내지용지=COMP_PAPER·출력매수 page파생. ×2 금지** | booklet-formula-principle §6(내지 전 책자 ×1·공식집 심판)·라이브 PRF_DGP_INNER(S1+COMP_PAPER·print_opt 차원)·072 정합 |
| **Q-A [codex 진성 적발·돈]** | 표지용지비 단일귀속처 부재(부모공식=표지인쇄+코팅+제본·내지용지는 내지) | **표지용지비를 부모공식에 4번째 comp(COMP_PAPER·표지종이 국4절 절가)로 추가. 071은 표지용지 ×2** | reconcile Q-A(072 선례 073 표지가 PRF_DGP_A로 표지용지 보유·6비목 권위 seq63 용지비)·라이브 COMP_PAPER 국4절 절가행 verbatim |
| **면지** | 면지 없음(CONFIRM-6) | **유지**(booklet-formula-principle §5.3 068~071 공식집 면지 비목 0·면지=제본비 포함) | 변동 없음 |

★rev.1 대비 부모공식이 **3 comp → 4 comp**(표지인쇄+표지코팅+**표지용지**+제본)로 확장되고, 단/양면은 **comp 교체가 아니라 print_opt_cd/coat_side_cnt selection 분기**로 정정(S2 부활 BLOCKED 항목 철회).

---

## 1. 072 정답 패턴 (라이브 실측·이 설계의 템플릿)

라이브 실측(2026-06-29 읽기전용 SELECT)으로 **072 종단이 이미 적재 완료**임을 확인 — 이것이 068~071이 동형으로 따를 정답:

```
PRD_000072 하드커버책자 [셋트 완제품]
  ├─ (부모 셋트공식) PRF_HC_MUSEON_SET → COMP_HC_MUSEON_COVERBIND (표지인쇄+표지코팅+제본 권당 통합단가·prc_typ .01·use_dims=[min_qty])
  ├─ disp_seq 1: 표지 PRD_000073 → 가격공식 없음(비용=부모 COVERBIND)
  ├─ disp_seq 2: 내지 PRD_000284 → PRF_DGP_INNER (COMP_PRINT_DIGITAL_S1 인쇄비 + COMP_PAPER 용지비·page파생 qty)
  └─ disp_seq 3/4/5: 면지 PRD_000074/075/076 → 가격0(택1)
```

★072와 068~071의 결정적 차이 (D3 근거):
- **072 부모공식 = COVERBIND 1개 통합단가**(가격표가 "표지+제본"을 권당 단일 단가로 미리 합산해둠·`use_dims=[min_qty]`만). 이는 하드커버 전용 가격표 산물.
- **068~071 = 그런 통합단가가 가격표에 없음**. 라이브엔 제본비 comp(중철/무선/PUR/트윈링)만 존재. → 068~071 부모공식은 **표지인쇄(COMP_PRINT_DIGITAL_S1) + 표지코팅(COMP_COAT_MATTE/GLOSSY) + 제본(COMP_BIND_*) 3 comp를 분해 배선**해야 한다(calc-formula seq63 6비목 분해형 정합).
- 내지 공식(PRF_DGP_INNER)은 **동일 재사용**(068~071 내지 반제품에 그대로 바인딩).

---

## 2. 계층 구조 (4종 · bottom-up · 부품조립형)

### 2.1 공통 골격 (068=069=070, 071만 표지×2)

```
PRD_00006X 〈책자명〉 [셋트 완제품·prd_typ.01·라이브 실재]
  ├─ (부모 셋트공식) PRF_BIND_〈METHOD〉_SET  [BLOCKED-FORMULA·dbmap 신설·4 comp]
  │     ├─ COMP_PRINT_DIGITAL_S1  표지인쇄  print_opt_cd=단면(POPT1)/양면(POPT2) selection  [라이브 verbatim·국4절·071=×2]
  │     ├─ COMP_COAT_MATTE/GLOSSY 표지코팅  coat_side_cnt=1(단면)/2(양면)               [라이브 verbatim·국4절·071=×2]
  │     ├─ COMP_PAPER             표지용지  plt_siz=국4절·mat_cd=표지종이 (Q-A 추가)    [라이브 verbatim 절가·071=×2]
  │     └─ COMP_BIND_〈METHOD〉    제본비(자기 책자 comp만)                              [라이브 verbatim]
  │
  ├─ disp_seq 1: 표지 PRD_(mint:〈책자명〉-표지) [반제품.02·★mint 필요·BLOCKED→dbmap]
  │     ├─ 자재: 별도설정(MES 통합관리·표지종이 택1)
  │     ├─ 공정: 표지코팅 무광/유광 (PROC_000015/014) — 비용은 부모공식
  │     ├─ 인쇄 면(손님 선택): 단/양면 → 부모공식 표지인쇄 print_opt_cd로 흐름
  │     └─ 가격공식: 없음(가격0·표지인쇄/코팅/용지 비용 전부 부모공식)
  │
  └─ disp_seq 2: 내지 PRD_(mint:〈책자명〉-내지) [반제품.02·★mint 필요·BLOCKED→dbmap]
        ├─ 자재: 별도설정(내지종이 택1)
        ├─ 인쇄 면: 단/양면 = print_opt_cd(POPT1/POPT2) selection (S2 comp 불요)
        ├─ 페이지: 〈책자별 min/max/incr〉 (member-qty 가변·×1 page파생)
        └─ (구성원공식) PRF_DGP_INNER → 내지인쇄(S1·print_opt 면) + 내지용지(COMP_PAPER)·page파생 qty
```

★단/양면 진원(rev.2): **단면/양면은 comp(S1/S2) 교체가 아니라 print_opt_cd selection으로 갈린다**. 라이브 COMP_PRINT_DIGITAL_S1 국4절 100매 = POPT1(단면) 350 / POPT2(양면) 700 (양면 2배). 코팅은 coat_side_cnt 1/2(단/양면). 따라서 표지 양면 주문(+60~67%·prevsite S-A)은 print_opt_cd=양면 selection이 부모공식 표지인쇄에 흐르면 자동 정확 청구. **S2 부활 불요**(rev.1 CFM-S2-REVIVE 철회).

### 2.2 책자별 인스턴스 (4종)

| 셋트 | 부모공식(신설) | 제본 comp | 내지 페이지 min/max/incr | 내지인쇄 면 | 표지인쇄 면(print_opt) | 표지×N | 후가공박 | 071 고유 |
|---|---|---|---|---|---|---|---|---|
| **068 중철** | PRF_BIND_JUNGCHEOL_SET | COMP_BIND_JUNGCHEOL (PROC_000018) | **4/28/4** (4배수·접지) | 양면(POPT2) | 단/양면 택1(POPT1/POPT2) | ×1(펼침) | 없음 | — |
| **069 무선** | PRF_BIND_MUSEON_SET | COMP_BIND_MUSEON (PROC_000019) | **24/300/2** | 양면(POPT2) | 단/양면 택1 | ×1(펼침) | 박/형압(옵션) | — |
| **070 PUR** | PRF_BIND_PUR_SET | COMP_BIND_PUR (PROC_000020) | **24/300/2** | 단면(A5,POPT1)/양면(A4,POPT2) | 단/양면 택1 | ×1(펼침) | 박/형압(옵션) | — |
| **071 트윈링** | PRF_BIND_TWINRING_SET | COMP_BIND_TWINRING (PROC_000021) | **8/100/2** (링 한계) | 단면(A5,POPT1)/양면(A4,POPT2) | 단/양면 택1 | **×2(앞뒤 낱장)** | 없음 | 링컬러·제본방향·투명커버 택1 |

- ★**069=070 구성원 BOM 100% 동일**(접착제만 무선 vs PUR) — 부모공식의 **제본 comp 1개만 교체**(COMP_BIND_MUSEON ↔ COMP_BIND_PUR). 070은 069의 동형 전파.
- ★**단/양면(R-4)은 표지×N(R-2)과 독립축**: 단/양면 = print_opt_cd(POPT1단면/POPT2양면) selection·전 책자 공통. 표지×N = 물리 출력매수(068~070 펼침 ×1·071 앞뒤 낱장 ×2). 071은 **양면이면서 ×2 가능**(양면 단가 × 2매).
- ★**071 트윈링 표지×2(R-2)**: 앞표지+뒤표지 물리 별 낱장(링제본=펼침 불가·cover-spread-x2-domain-check §1.3) → 부모공식의 표지인쇄·표지코팅·**표지용지** 비목을 **×2 배수**. 068~070은 ×1(펼침 1장). 이 ×2는 071 고유 경계(068~070에 유입 금지). booklet-formula-principle §4 판정 = 단가가 1면(출력 1매) 기준이라 ×2 정당(이중계상 아님).
- ★**조사신호 S-B(이전사이트 거동)**: 이전사이트 AJAX는 071 표지를 ×1로 산정(×2 흔적 없음). **권위(공식집 verbatim ×2)가 값의 정답**·이전사이트는 거동 신호이지 값 정답 아님 → ×2 채택. 게이트 G-071 골든에서 권위 가격표 verbatim 대조로 ×1/×2 최종 확정(권위 표지단가가 이미 2면 포함이면 이중 ×2 방지·라이브 단가는 1면 기준 실측).

---

## 3. 부모 셋트공식 설계 (D3 · 표지인쇄+표지코팅+표지용지+제본 분해 · rev.2)

### 3.1 부모공식 = 표지측 4비목 분해 배선 (Q-A 표지용지 추가)

권위 calc-formula seq63: `판매가 = 내지인쇄비 + 표지인쇄비 + 표지코팅비 + 제본비 + 용지비 + 후가공비`. 이 중 **표지측 4비목(표지인쇄·표지코팅·표지용지·제본)**을 부모 셋트공식에, **내지측 2비목(내지인쇄·내지용지)**을 내지 구성원공식(PRF_DGP_INNER)에 분담. ★용지비는 표지측(부모)·내지측(내지 구성원) **둘 다** 발생 — 표지용지는 부모공식(Q-A), 내지용지는 내지 구성원. 후가공박은 069/070 옵션.

각 책자 부모공식(BLOCKED-FORMULA·dbmap 신설·새 PRF지만 **새 단가 아님**·전부 기존 comp 조립). ★단/양면은 comp 교체가 아니라 **print_opt_cd / coat_side_cnt selection**으로 갈림(S2 불요):

| 부모공식 | comp 배선 (disp_seq) | 제본 proc | 단/양면 분기 | ×N |
|---|---|---|---|---|
| **PRF_BIND_JUNGCHEOL_SET** (068) | 1:COMP_PRINT_DIGITAL_S1(표지인쇄)·2:COMP_COAT_MATTE/GLOSSY(표지코팅)·3:COMP_PAPER(표지용지)·4:COMP_BIND_JUNGCHEOL(제본) | PROC_000018 | 표지인쇄 print_opt_cd(POPT1단면/POPT2양면)·코팅 coat_side_cnt(1/2)·코팅종류 무광/유광 selection | ×1(펼침) |
| **PRF_BIND_MUSEON_SET** (069) | 1:S1·2:COAT·3:COMP_PAPER·4:COMP_BIND_MUSEON (+후가공박 옵션 addtn_yn) | PROC_000019 | 동 | ×1(펼침) |
| **PRF_BIND_PUR_SET** (070) | 1:S1·2:COAT·3:COMP_PAPER·4:COMP_BIND_PUR (+후가공박) | PROC_000020 | 동 | ×1(펼침) |
| **PRF_BIND_TWINRING_SET** (071) | 1:S1(표지인쇄 **×2**)·2:COAT(표지코팅 **×2**)·3:COMP_PAPER(표지용지 **×2**)·4:COMP_BIND_TWINRING | PROC_000021 | 동 + ×2(앞뒤 낱장) | **×2** |

★**표지 ×N 구현 방법(dbmap 명세)**: ×2(071)는 출력매수 = copies × 2(앞표지 + 뒤표지 각 1매·펼침 아님). 068~070은 출력매수 = copies(펼침 1매·펼침 siz pansu=1). evaluate_set_price 호출 시 071 표지 출력매수를 ×2로 산정(부모공식 comp 단가는 1매 기준 그대로·매수가 2배). ×2는 단/양면(print_opt)과 독립 — 071이 양면이면 양면 단가 × 2매.

> ★**중요(설계가 경계)**: 이 부모공식들은 **가격공식 신설**(새 frm_cd + formula_components 배선)이라 set-designer 범위 밖 → **BLOCKED-FORMULA(§18/dbmap 위임·인간 승인)**. 단 "신설"은 **새 단가/새 comp 창조가 아니라 기존 comp 조립**이다(전부 라이브 verbatim 단가 재사용·날조 0). 사용자 directive "새 가격공식 신설 금지"는 **새 가격산정 로직·새 단가 창조 금지**로 해석 — 072 PRF_HC_MUSEON_SET 패턴(표지+제본 합산)을 책자별 제본 comp로 전사하는 것이며, 이는 "전사"이지 "신설"이 아니다. 다만 frm_cd가 라이브에 없으므로 행 생성 자체는 dbmap 트랙.

### 3.2 부모공식 단가 (전부 라이브 verbatim·날조 0 · rev.2)

| 비목 | comp | 국4절 단가(verbatim) | 단/양면 진원 | 출처 |
|---|---|---|---|---|
| 표지인쇄 | COMP_PRINT_DIGITAL_S1 | POPT1(단면) 100매=350·POPT2(양면)=700 (양면 2배) | **print_opt_cd selection**(S2 불요) | 라이브 component_prices |
| 표지코팅(무광) | COMP_COAT_MATTE | 국4절 100매 coat_side_cnt=1(단면)=500·=2(양면)=1,000 | **coat_side_cnt selection** | 라이브 |
| 표지코팅(유광) | COMP_COAT_GLOSSY | 무광 동형(coat_side_cnt 분기) | coat_side_cnt | 라이브 (코팅종류=무광/유광 selection) |
| **표지용지(Q-A)** | COMP_PAPER | 국4절 절가(mat_cd별): 백모120=36.88·아트150=46.65·스노우120=36.68 등 | plt_siz=국4절·mat_cd selection | 라이브 component_prices |
| 제본(중철) | COMP_BIND_JUNGCHEOL | PROC_000018 1권=3,000·50=1,000·100=700·1000=500 | — | 라이브 |
| 제본(무선) | COMP_BIND_MUSEON | PROC_000019 1=3,000·50=700·100=500·1000=500 | — | 라이브 |
| 제본(PUR) | COMP_BIND_PUR | PROC_000020 1=5,000·50=3,000·100=2,000·1000=1,500 | — | 라이브 |
| 제본(트윈링) | COMP_BIND_TWINRING | PROC_000021 1=4,000·50=1,500·100=1,300·1000=1,000 (제본종류열 다수 proc) | — | 라이브 |

### 3.3 표지인쇄·코팅·용지 출력매수 = 표지 펼침 1-up(068~070) / 앞뒤 ×2(071) (R-2·cover-spine 원칙)

- **068~070(펼침)**: 표지 출력매수 = ⌈copies / pansu⌉. 표지 펼침 siz(국4절 1-up·pansu=1)면 출력매수=copies. 펼침형(앞+책등+뒤 한 출력면). 072 cover-spine-principle §3 동형으로 **단일 정적 표지 펼침 siz**로 방어(A5 안전·A4는 CFM-COVER-A4PLT 동일 BLOCKED 가능성).
- **071(트윈링 ×2)**: 앞표지·뒤표지가 물리 별 낱장(링제본·펼침 불가). 표지 출력매수 = copies × 2(앞 1매 + 뒤 1매). 단가는 1매 기준(booklet-formula-principle §4)이라 ×2 정확. 표지인쇄·코팅·용지 3비목 전부 ×2.
- 표지 펼침 siz 미주입 시 완제 A5(4-up)로 ~3.8배 과소 — CFM-COVER-SPREAD-SIZ(dbmap siz·표지 mint와 함께). ×2(071)는 펼침 siz 위에 매수 ×2(독립).

---

## 4. 내지 구성원공식 = PRF_DGP_INNER 재사용 (D4 · 새 공식 0)

### 4.1 PRF_DGP_INNER (라이브 실재·072 내지284가 쓰는 그 공식)

```
PRF_DGP_INNER (디지털인쇄 책자 내지·인쇄비+용지비·출력매수)
  disp_seq 1: COMP_PRINT_DIGITAL_S1  use_dims=[proc_cd,plt_siz_cd,print_opt_cd,min_qty,proc_grp:PROC_000001]
  disp_seq 2: COMP_PAPER             use_dims=[plt_siz_cd,mat_cd]
```

- 068~071 내지 반제품(mint 후)에 **PRF_DGP_INNER 바인딩**(새 공식 0·전사·×1 page파생). ★**단/양면 = print_opt_cd(POPT1단면/POPT2양면) selection**으로 갈림 — COMP_PRINT_DIGITAL_S1 하나가 use_dims에 print_opt_cd를 가지므로 손님 면 선택이 단가행 매칭으로 흐른다(라이브 S1 국4절 단면 100=350 / 양면=700). **S2 comp·부활 불요**(rev.1 정정).
- ★**내지 qty = page파생(×1)**: 총내지매수 = 부수 × ⌈페이지/판걸이수⌉ (evaluate_set_price `derive_inner_sheets`). 페이지 = member min_cnt~max_cnt(068=4~28·069/070=24~300·071=8~100). 내지 ×2 금지(booklet-formula-principle §6·페이지가 이미 양면 포함).
- ★**S-D 정밀화(R-3)**: 이전사이트 거동은 "내지인쇄 면 무관·내지용지만 면별 ~2배"로 관찰됐으나, 라이브 실측은 **내지인쇄 S1 자체가 print_opt(면)로 단가가 다름**(단면 350/양면 700). 즉 면별 가격차는 인쇄·용지 양쪽에 있을 수 있고 **권위(라이브 단가행·가격표)가 정답**. 설계 = 내지인쇄 면=print_opt selection·내지용지 면=출력매수(page파생)로 둘 다 면 종속 가능. 게이트 G 골든에서 권위 단가로 면별 위치 확정(S-D 조사신호 해소).
- ★**DBLPANSU 주의**(072 prf-track-design §2 동형): derive_inner_sheets가 ÷pansu 1회·_evaluate_formula plate_qty가 ÷pansu 1회 = 이중 가능성. 072에서 적발된 코드결함(price_views.py:1707)이 068~071 내지에도 동일 적용 → 코드 트랙(§6/dbmap) 1회 교정이 072/068~071 동시 해소. 바인딩 전 코드 교정 선결(내지 ~0.4배 과소 가드).

### 4.2 내지 면 책자별 분기 (경계 준수 · print_opt selection)

| 책자 | A5 내지인쇄 | A4 내지인쇄 | comp + 면 분기 |
|---|---|---|---|
| 068 중철 | 양면 | 양면 | COMP_PRINT_DIGITAL_S1 · print_opt_cd=POPT2(양면) |
| 069 무선 | 양면 | 양면 | S1 · POPT2(양면) |
| 070 PUR | **단면** | 양면 | S1 · POPT1(A5 단면)/POPT2(A4 양면) |
| 071 트윈링 | **단면** | 양면 | S1 · POPT1(A5 단면)/POPT2(A4 양면) |

070/071 A5=단면은 component-boundary.csv 명시(068/069와 경계 다름·유입 금지). 면은 comp 교체가 아니라 print_opt_cd selection으로 갈림(전 책자 S1 단일 comp).

---

## 5. 셋트 구성원 설계 (t_prd_product_sets · D1·D7)

### 5.1 목표 구성 (각 책자 2행 = 표지 1 + 내지 1·면지 없음)

| 셋트 | disp_seq | sub_prd_cd(예약) | 역할 | sub_prd_qty | min_cnt | max_cnt | cnt_incr | note |
|---|---|---|---|---|---|---|---|---|
| 068 | 1 | PRD_(mint:중철책자-표지) | 표지 | 1 | 1 | 1 | NULL | 표지=별도설정·1권고정·가격0(부모공식) |
| 068 | 2 | PRD_(mint:중철책자-내지) | 내지 | 1 | **4** | **28** | **4** | 내지=별도설정·페이지4~28/+4(중철 4배수·양면) |
| 069 | 1 | PRD_(mint:무선책자-표지) | 표지 | 1 | 1 | 1 | NULL | 표지=별도설정·가격0(부모공식+박/형압) |
| 069 | 2 | PRD_(mint:무선책자-내지) | 내지 | 1 | **24** | **300** | **2** | 내지=별도설정·페이지24~300/+2·양면 |
| 070 | 1 | PRD_(mint:PUR책자-표지) | 표지 | 1 | 1 | 1 | NULL | 표지=별도설정·가격0(부모공식+박/형압) |
| 070 | 2 | PRD_(mint:PUR책자-내지) | 내지 | 1 | **24** | **300** | **2** | 내지=별도설정·페이지24~300/+2·단면(A5)/양면(A4) |
| 071 | 1 | PRD_(mint:트윈링책자-표지) | 표지 | 1 | 1 | 1 | NULL | 표지=별도설정·가격0(부모공식·앞뒤표지×2) |
| 071 | 2 | PRD_(mint:트윈링책자-내지) | 내지 | 1 | **8** | **100** | **2** | 내지=별도설정·페이지8~100/+2·단면(A5)/양면(A4) |

- **면지 행 없음**(사용자 확정·소프트커버=면지 없음·booklet-l1 면지 빈칸 정합). CONFIRM-6(면지 유무)은 **면지 없음으로 확정 처리** — 면지 구성원 미생성.
- 내지 min/max/incr = 내지 member-qty 가변(evaluate_set_price page 입력·UI 미러). 표지 min/max=1/1(권당 1장 고정). 제작수량(부수)은 셋트행 아님(copies 인자).
- 071 표지×2는 부모공식에서 표지인쇄·코팅·**표지용지** ×2로 반영(셋트행 표지 sub_prd_qty=1 유지·출력매수 ×2 가격배수).
- ★표지 가격0(D5) = 표지인쇄·표지코팅·표지용지 비용이 전부 부모공식에 있어 표지 구성원 공식 미부여. 셋트행 note는 "가격0(부모공식)"로 표기.
- semi_role_cd 컬럼은 t_prd_product_sets에 없음(072 선례) → 역할은 note로만 표기.

### 5.2 택1 그룹 / always-add 함정 점검

- 068~071은 **동일 역할 다중 구성원 없음**(표지 1·내지 1) → 택1 그룹 없음·always-add 함정 원천 부재. 072 면지 3행 같은 평면합산 위험이 068~071엔 없다(면지 없음).

---

## 6. evaluate_set_price 적용 + 이중합산 0 증명 (D6)

### 6.1 가격 사슬 (pricing.py:718)

```
evaluate_set_price(00006X, selections, copies) =
    Σ 구성원 evaluate_price                              ← 내지(mint) [표지=0]
      ├─ 내지(mint): PRF_DGP_INNER → 내지인쇄(S1·print_opt 면×총내지매수) + 내지용지(COMP_PAPER×출력매수)  [×1 page파생]
      └─ 표지(mint): 가격공식 없음 → contribution 0
  + 셋트 부모공식 evaluate_price(00006X)                  ← PRF_BIND_〈METHOD〉_SET → 표지인쇄(print_opt 면) + 표지코팅(coat_side) + 표지용지 + 제본
  + 할인(셋트 기준 1회)
   ※071은 부모공식의 표지인쇄·코팅·용지가 ×2(앞뒤 낱장·출력매수 copies×2)
```

### 6.2 ★이중합산 0 증명 (비목 단일 귀속표 · rev.2 = 6비목)

| 비목 (calc-formula seq63) | 부모공식 | 내지 구성원 | 표지 구성원 | 단일 귀속? |
|---|---|---|---|---|
| 내지인쇄비 | ✗ | ✅ PRF_DGP_INNER S1(print_opt 면) | ✗ | ✅ 내지만 |
| 표지인쇄비 | ✅ PRF_BIND_*_SET S1(print_opt 면·071=×2) | ✗ | ✗(가격0) | ✅ 부모만 |
| 표지코팅비 | ✅ PRF_BIND_*_SET COAT(coat_side·071=×2) | ✗ | ✗ | ✅ 부모만 |
| **표지용지비(Q-A)** | ✅ PRF_BIND_*_SET COMP_PAPER(표지종이 국4절·071=×2) | ✗ | ✗ | ✅ 부모만 |
| 내지용지비 | ✗ | ✅ PRF_DGP_INNER COMP_PAPER(내지종이) | ✗ | ✅ 내지만 |
| 제본비 | ✅ PRF_BIND_*_SET BIND | ✗ | ✗ | ✅ 부모만 |
| 후가공박(069/070) | ✅ 부모(옵션 addtn) | ✗ | ✗ | ✅ 부모만 |

★COMP_PAPER가 부모(표지용지)·내지(내지용지) 두 곳에 등장하나, **frm_cd 분리(PRF_BIND_*_SET vs PRF_DGP_INNER)·plt_siz/mat_cd selection 상이(표지종이 vs 내지종이)**라 같은 비용을 두 번 세지 않음(표지용지 ≠ 내지용지·서로 다른 종이·다른 출력매수). 6비목 각각 정확히 한 frm_cd에 단일 귀속 → **이중합산 0**.

→ **각 비목이 정확히 한 곳에만 귀속**. 제본비·표지비를 구성원에도 부모에도 넣지 않음. 표지 구성원은 가격공식 미부여(0). **이중합산 0 보증**.

### 6.3 골든 케이스 (게이트 재계산용·verbatim 손계산 · rev.2 = 표지 단/양면·071 ×2·표지용지 반영)

> 표지 출력매수 = 펼침 1-up(068~070·pansu=1·= copies) / 071 = copies×2. 단가 전부 라이브 국4절 verbatim. DBLPANSU 코드교정 전제(내지 page파생 ÷pansu 1회).

**G-068A (중철·A5·표지 단면 백모120 무광코팅·내지 28p양면·부수 100권)** — 표지 단면 기준선
- 부모공식 PRF_BIND_JUNGCHEOL_SET (×1·펼침·출력매수=100):
  - 표지인쇄 S1 POPT1(단면) 100=350 × 100 = **35,000**
  - 표지코팅 MATTE coat_side_cnt=1(단면) 100=500 × 100 = **50,000**
  - 표지용지 COMP_PAPER 백모120(MAT_000073) 국4절 36.88 × 100 = **3,688**
  - 제본 JUNGCHEOL PROC_000018 tier(100)=700 × 100권 = **70,000**
  - 부모 소계 = 158,688
- 내지 PRF_DGP_INNER (page파생·총내지매수=100×⌈28/판걸이수⌉):
  - 내지인쇄 S1 POPT2(양면) + 내지용지 COMP_PAPER 백모120 (판걸이수·총매수 게이트 확정)
- **검증 포인트**: 표지 단면=POPT1 단가(350)·이중합산 0·제본 1회.

**G-068B (G-068A에서 표지만 양면 전환)** — ★R-4 양면 가격축 검출
- 표지인쇄 S1 POPT2(양면) 100=700 × 100 = **70,000** (단면 35,000의 2배·prevsite +60~67% 정합)
- 표지코팅 MATTE coat_side_cnt=2(양면) 100=1,000 × 100 = **100,000** (단면 50,000의 2배)
- 표지용지·제본 동일 → 부모 소계 = 70,000+100,000+3,688+70,000 = **243,688** (G-068A 158,688 대비 +85,000)
- ★**R-4 검출**: 표지 양면이 print_opt_cd=POPT2·coat_side_cnt=2로 흐르면 양면 단가 자동 청구. 단면 단가로 청구되면(R-4 미보정) +85,000 저청구.

**G-071 (트윈링·A5·표지 단면 아트150 무광코팅·내지 100p단면·부수 50권)** — ★R-2 표지×2 검출
- 부모공식 PRF_BIND_TWINRING_SET (×2·앞뒤 낱장·출력매수=50×2=100):
  - 표지인쇄 S1 POPT1(단면) 100=350 × 100(=50×2) = **35,000** ← ×2 미적용 시 50매×350=17,500(절반 저청구)
  - 표지코팅 MATTE coat_side_cnt=1 100=500 × 100 = **50,000** ← ×1이면 25,000
  - 표지용지 COMP_PAPER 아트150(MAT_000078) 46.65 × 100(=×2) = **4,665** ← ×1이면 2,332.5
  - 제본 TWINRING PROC_000021 tier(50)=1,500 × 50권 = **75,000**
  - 부모 소계 = 164,665
- 내지 PRF_DGP_INNER (100p 단면·POPT1·page파생)
- **검증 포인트**: ★표지인쇄·코팅·용지 3비목 전부 ×2(출력매수 100=copies×2). ×1로 계산되면 표지비 ~50% 저청구 = R-2 결함 검출. 제본은 권당(×1·50권). 단/양면(print_opt)과 ×2(출력매수) 독립 — 071 양면 주문이면 표지인쇄 POPT2(700)×100매.

**G-071 권위 가드(S-B·이중×2 방지)**: 권위 가격표(seq72) 트윈링 표지단가가 "1면 기준"이면 ×2 정확(라이브 라이브 단가는 1면 기준 실측). 만약 권위가 "앞뒤 2면 포함 단가"면 ×2 금지(이중계상) → 게이트 G-071 골든에서 권위 verbatim 대조로 1면/2면 확정. 이전사이트 거동(×1)은 값 정답 아님(거동 신호).

---

## 7. 상품별 구성요소 경계 준수 증거 (옵션 오염 방지 · §3 HARD)

component-boundary.csv 기준 각 책자에 **자기 시트 허용 구성요소만** 배선했음을 증명:

| 경계 축 | 068 중철 | 069 무선 | 070 PUR | 071 트윈링 | 오염 가드 |
|---|---|---|---|---|---|
| **페이지 incr** | 4배수(접지) | 2배수 | 2배수 | 2배수 | 068에만 4배수·타 책자 유입 금지 |
| **페이지 max** | 28(얇음) | 300 | 300 | 100(링 한계) | 071=100·300 유입 시 링 수용 초과 |
| **제본 comp** | JUNGCHEOL만 | MUSEON만 | PUR만 | TWINRING만 | 각 책자 자기 제본 comp만(공유 오염 0·라이브 정합) |
| **내지 면(A5)** | 양면 | 양면 | 단면 | 단면 | 070/071 A5=단면·068/069와 경계 다름 |
| **표지 ×N** | ×1 | ×1 | ×1 | **×2** | 071만 표지×2·068~070 유입 금지 |
| **후가공박** | 없음 | 있음 | 있음 | 없음 | 068/071에 박 주면 권위 위반 |
| **링/제본방향/투명커버** | — | — | — | **있음** | 068~070에 링 주면 트윈링 전용 오염 |
| **최소수량** | 2 | 2 | 2 | 1 | — |

→ **공유 공식(PRF_DGP_INNER) 써도 자기 분기만**: 내지 공식은 4종 공유하되 각 책자가 자기 plt_siz_cd·print_opt_cd(면)·페이지범위로 매칭. 부모공식은 책자별 별 frm_cd(제본 comp 분리)로 silent 적용·제본비 누락 함정 차단(현황판 B-4 해소·라이브 이미 각자 정확 배선).

---

## 8. search-before-mint 증거 (날조 0)

| 항목 | 라이브 실재(2026-06-29) | 처리 |
|---|---|---|
| 셋트 부모 PRD_000068~071 | ✅ prd_typ.01 완제품·use_yn=Y·del_yn=N | 참조(셋트 부모 후보 적격) |
| 셋트 구성원(t_prd_product_sets) | ❌ 0행(4종 전부) | 부품 mint 후 셋트행 INSERT(BLOCKED) |
| 표지 반제품 | ❌ 0행(중철/무선/PUR/트윈링 명칭) | **BLOCKED→dbmap mint**(8 반제품·표지4+내지4) |
| 내지 반제품 | ❌ 0행 | **BLOCKED→dbmap mint** |
| 제본 comp(JUNGCHEOL/MUSEON/PUR/TWINRING) | ✅ 실재·단가행 verbatim | 부모공식 신설 시 재사용(신규 0) |
| 표지인쇄 S1(print_opt 단/양면 단가행)·표지코팅 MATTE/GLOSSY(coat_side 단/양면)·COMP_PAPER(표지종이 절가) | ✅ 실재·국4절 단가행 verbatim | 부모공식 4 comp 재사용(신규 0)·단/양면=print_opt/coat_side selection |
| 내지공식 PRF_DGP_INNER(S1+COMP_PAPER·print_opt) | ✅ 실재(072 내지284 바인딩) | 내지 반제품에 전사(신규 0) |
| 부모공식 PRF_BIND_*_SET (표지인쇄+코팅+용지+제본 4 comp) | ❌ 0행(4종) | **BLOCKED-FORMULA→dbmap**(기존 comp 조립·새 단가 0) |
| 표지 펼침 siz | △ SIZ_000326(390×290·근사·072 사용) | 표지 mint 시 펼침 siz 주입(CFM-COVER-SPREAD-SIZ·071은 매수 ×2) |
| COMP_PRINT_DIGITAL_S2 부활 | — | ★**불요(rev.2 정정)** — 단/양면은 print_opt_cd로 갈림·S1 단일 comp로 충분 |

**신규 mint 필요 = 8 반제품(표지4+내지4) + 4 부모공식(PRF_BIND_*_SET·각 4 comp) + 내지 PRF_DGP_INNER 바인딩 4**. 새 단가·새 comp·새 자재·S2 부활 = **0**(전부 기존 참조·단/양면은 selection 분기).

---

## 9. 적재본 스코프 + BLOCKED 분리

### 9.1 이번 적재본(설계 청사진) = 셋트 행 placeholder

- **t_prd_product_sets.csv / apply.sql**: 8행(4종×표지1+내지1)·sub_prd_cd=예약 placeholder(mint 후 확정). **부품 미존재로 실 적재 BLOCKED** — apply.sql은 멱등 INSERT 청사진(load-executor가 부품 mint 완료 후 placeholder→실 prd_cd 치환·트랜잭션 래핑).
- 멱등=복합PK(prd_cd, sub_prd_cd) ON CONFLICT DO UPDATE.

### 9.2 BLOCKED → dbmap/§7/§18 라우팅 (blocked-board.csv)

| 트랙 | 항목 | 사유 | 라우팅 |
|---|---|---|---|
| **member-mint** | 표지4+내지4 반제품 (PRD_TYPE.02) | 라이브 0행·셋트 구성원 미존재 | dbmap/basecode mint(072 PRD_000284 동형·인간 승인) |
| **BLOCKED-FORMULA** | 부모공식 PRF_BIND_*_SET 4종(표지인쇄+코팅+용지+제본 4 comp·071 ×2) | 라이브 0행(제본비 comp만)·분해형 신설 | §18/dbmap(기존 comp 조립·인간 승인) |
| **BLOCKED-INNER-BIND** | 내지 반제품 PRF_DGP_INNER 바인딩 4 | 내지 mint 후 바인딩 | dbmap(내지 mint 후) |
| **BLOCKED-INNER-DIM** | 내지 반제품 사이즈/공정/판형 차원 | mint 직후 0행 | dbmap 차원 충전(072 내지284 동형) |
| **BLOCKED-COVER-SIZ** | 표지 펼침 siz 주입(CFM-COVER-SPREAD-SIZ)·071 표지 매수 ×2 | 표지 출력매수 1-up(068~070)/×2(071) | dbmap(SIZ_000326 근사 or 펼침 신설) |
| **C트랙(코드결함)** | DBLPANSU(내지 이중÷pansu)·band-total ×qty | 072 prf-track-design §2 동형 | 개발팀(webadmin price_views.py)·1회 교정이 072/068~071 동시 해소 |

---

## 10. 부품 mint 선결 스펙 (dbmap 위임용 · 072 PRD_000284 동형)

각 책자별 필요 반제품 명세(dbmap이 mint·search-before-mint 후):

### 10.1 내지 반제품 (4종·072 PRD_000284 동형)

| 컬럼 | 068 | 069 | 070 | 071 |
|---|---|---|---|---|
| prd_nm | 중철책자-내지 | 무선책자-내지 | PUR책자-내지 | 트윈링책자-내지 |
| prd_typ_cd | PRD_TYPE.02 | 동 | 동 | 동 |
| nonspec_yn | N | N | N | N |
| file_upload_yn | Y | Y | Y | Y |
| editor_yn | N | N | N | N |
| 자재(별도설정) | 백모/아트/스노우/몽블랑(부모 내지종이 상속) | 동 | 동 | 동 |
| 인쇄 면 | 양면(S2) | 양면(S2) | 단면(A5)/양면(A4) | 단면(A5)/양면(A4) |
| 페이지룰 | 4/28/4 | 24/300/2 | 24/300/2 | 8/100/2 |
| 가격공식 | PRF_DGP_INNER | 동 | 동 | 동 |

### 10.2 표지 반제품 (4종·가격0·생산연결)

| 컬럼 | 068 | 069 | 070 | 071 |
|---|---|---|---|---|
| prd_nm | 중철책자-표지 | 무선책자-표지 | PUR책자-표지 | 트윈링책자-표지 |
| prd_typ_cd | PRD_TYPE.02 | 동 | 동 | 동 |
| 자재(별도설정) | 표지종이 택1 | 동 | 동 | 동 |
| 공정 | 무광/유광 코팅 | 코팅+박/형압 | 코팅+박/형압 | 코팅+투명커버 |
| 가격공식 | 없음(가격0·표지인쇄+코팅+용지 전부 부모공식) | 동 | 동 | 동(앞뒤표지 ×2는 부모공식 출력매수 배수) |
| 채번 | MAX+1(PRD_000285~) 예약 | | | |

> ★채번 예약: 라이브 MAX prd_cd=PRD_000284(072 내지). 068~071 8 반제품 = PRD_000285~PRD_000292 예약(dbmap mint 시 확정·placeholder).

---

## 11. CONFIRM / 잔여 보드

| ID | 사안 | 처리 |
|---|---|---|
| **CONFIRM-6** | 068~071 면지 유무 | **해소 = 면지 없음**(사용자 확정·소프트커버·booklet-l1 빈칸) |
| **CONFIRM-7** | 부모공식 확장 방식(현 PRF_BIND_* 제본비만 → 표지인쇄+코팅+용지+제본 분해형) | **분해형 신설**(PRF_BIND_*_SET·4 comp·기존 comp 조립·D3) |
| **CONFIRM-8** | 표지/내지 반제품 자재(별도설정) | dbmap mint 시 표지/내지 종이 코드 확정(MES 통합관리) |
| **Q-A (해소·표지용지)** | 표지용지비 단일귀속(codex 진성 적발) | **해소 = 부모공식에 COMP_PAPER(표지종이) 4번째 comp 추가**(D3·§3.1·071 ×2)·게이트 골든 표지용지 비목 검출 |
| **R-4 (해소·표지 단/양면)** | 표지 양면 가격축(prevsite +60~67%) | **해소 = print_opt_cd/coat_side_cnt selection 분기**(S2 부활 불요)·게이트 G-068B 검출 |
| **CFM-COVER-SPREAD-SIZ** | 표지 출력매수 1-up siz·071 매수 ×2 | dbmap(SIZ_000326 근사 or 펼침 신설·표지 mint와 함께) |
| **CFM-INNER-DBLPANSU** | 내지 이중÷pansu | C트랙(072 동시 해소·코드 교정 전 내지 바인딩 금지) |
| **~~CFM-S2-REVIVE~~ 철회** | 양면 = S2 부활? | **철회(rev.2)** — 단/양면은 print_opt_cd selection으로 갈림·S1 단일 comp·S2 불요 |
| **071 표지×2(R-2)** | 트윈링 앞뒤표지 표지인쇄·코팅·용지 ×2 | 부모공식 PRF_BIND_TWINRING_SET 출력매수 ×2(설계 §3.1·골든 G-071·게이트 권위 1면/2면 대조로 이중×2 가드) |
| **S-B (조사신호)** | 071 ×2: 이전사이트 거동=×1 | 권위(공식집 verbatim ×2)가 정답·이전사이트는 거동 신호·게이트 권위 가격표 대조 |
| **071 투명커버** | SEMI_ROLE.05 투명커버 구성원 | 본 스코프 미포함(면지처럼 별 옵션·CONFIRM 후속·codex Q-F) |

---

## 12. 출처 (날조 0)

- **라이브 실측(2026-06-29 읽기전용 SELECT)**: PRD_000068~071=PRD_TYPE.01·use_yn=Y·del_yn=N·t_prd_product_sets 0행·바인딩 PRF_BIND_SUM/MUSEON/PUR/TWINRING(각 제본 comp 1개). MAX prd_cd=PRD_000284. 4 제본 comp(JUNGCHEOL/MUSEON/PUR/TWINRING) prc_typ=.01·use_dims=[proc_cd,min_qty,proc_grp:PROC_000017]·단가행 verbatim(JUNGCHEOL PROC_000018·MUSEON PROC_000019·PUR PROC_000020·TWINRING 다수 proc). PRF_DGP_INNER(S1 인쇄비+COMP_PAPER 용지비·072 내지284 바인딩). PRF_HC_MUSEON_SET→COMP_HC_MUSEON_COVERBIND(표지+제본 권당 통합·use_dims=[min_qty]·072 전용). 072 셋트 5구성원(073표지+284내지+074~076면지·내지 24/300/2). COMP_PRINT_DIGITAL_S1 국4절 verbatim·COMP_COAT_MATTE 국4절·SIZ_000326(390×290 표지펼침 근사). proc 위상 t_proc_processes(18~21→017 제본·004→001 인쇄·015→013 코팅). 068~071 부모 자재=책자 종이류(좀비 아님)·071 링/투명커버 자재 실재.
- **권위(상품마스터 260610)**: booklet-l1.csv r3-36(068~071 구성요소·표지/내지종이=별도설정·내지페이지 068=4/28/4·069/070=24/300/2·071=8/100/2·제본종류·표지코팅·박형압·트윈링 링컬러/제본방향/투명커버·제작수량 068~070=2/1000/1·071=1/1000/1). calc-formula-draft-l1.csv L63-78(seq63 원자합산형 6비목=내지인쇄+표지인쇄+표지코팅+제본+용지+후가공·068/069/070/072 공유·071 seq72 표지×2 후가공박 제외).
- **입력 설계**: hardcover-book-design.md(072 종단·PRF_HC_MUSEON_SET·PRF_DGP_INNER·이중합산0)·inner-promotion/prf-track-design.md(DBLPANSU·내지 page파생)·cover-spine-principle.md(표지 펼침 1-up·A5 안전·A4 BLOCKED)·set-authority-spec §7·component-boundary.csv·domain-set-bom §6.
- **rev.2 권위·실측(2026-06-29 보정)**: booklet-formula-principle.md(★정답표·068~070=표지×1펼침·071=표지×2앞뒤·내지 전책자×1·표지단가=1면 기준이라 ×2 정당·calc-formula L63-78 verbatim)·prevsite-harvest-booklet.md(S-A 표지 양면 +60~67%·S-B 071 ×1 거동·S-D 내지 면별)·cover-spread-x2-domain-check.md(펼침/×2 도메인+레드 확증)·04_codex/reconcile-068-071.md(Q-A 표지용지 진성 적발·Q-E S2 분기·Q-C 071 ×2). 라이브 재실측: COMP_PRINT_DIGITAL_S1 국4절 POPT1(단면)100=350 / POPT2(양면)700 (양면 2배·print_opt가 면축)·COMP_COAT_MATTE 국4절 coat_side_cnt 1(단면)100=500 / 2(양면)=1,000·COMP_PAPER 국4절 절가(백모120=36.88·아트150=46.65 등)·print_opt 코드값(POPT_000001 단면/POPT_000002 양면)·PRF_DGP_INNER=S1+COMP_PAPER(use_dims print_opt_cd·S2 미배선). ★rev.1 "S1단면/S2양면 comp 접미사" 해석 정정 = 면은 print_opt_cd selection.
- **계약**: pricing.py:718 evaluate_set_price(Σ구성원 evaluate_price + 셋트 부모공식 + 할인 1회)·derive_inner_sheets(copies×⌈pages/pansu⌉).
