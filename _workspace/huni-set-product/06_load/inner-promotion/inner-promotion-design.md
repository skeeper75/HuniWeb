# 내지 반제품 승격 — 구조변경 설계 명세 (PRD_000072 파일럿 · CFM-INNER-TOTSHEET 해소)

생성: dbm-load-builder (생성 패스·**자기승인 금지**) · 2026-06-25 라이브 읽기전용 SELECT 직접 재실측 · **DB 미적재**(COMMIT/INSERT/UPDATE/DDL 0·설계+멱등 SQL 제안+롤백전용 DRY-RUN+검증 설계까지·실 적재 인간 승인 후) · search-before-mint 전수 · 단가 verbatim·날조 0

> ★**목적**: 072 하드커버책자의 내지(內紙)를 **별도 반제품 구성원(SEMI_ROLE.01·자기 dims 보유)**으로 승격해, `evaluate_set_price`가 내지 구성원을 `derive_inner_sheets(copies,pages,pansu)=총내지매수`로 평가할 수 있게 한다. 이것이 **CFM-INNER-TOTSHEET**(내지=본체 통합 → 페이지 곱 누락 → 내지인쇄 ~1/96 과소청구·3자 합의 NO-GO 핵심)의 **유일한 정석 해소**다.
> ★**범위 경계**: 본 명세 = ① 내지 반제품 신규 등록 ② 내지 dims 등록(자기 sizes/print_options/page_rules/내지종이 materials) ③ sets 행(072←내지·inner-first) ④ 판형 해소. **PRF 민팅(PRF_HC_INNER/BODY 재설계·S2 부활·표지 펼침 siz)은 OUT — 그건 본 구조변경 COMMIT 이후 set-product 트랙**(§3.5 핸드오프 인터페이스). 본 명세는 그 가격 트랙이 동작할 **그릇**을 만든다.

---

## ★0. 결론 요약 (한눈에 · 인간 승인 큐) — ★보정 2026-06-25(차단 3건 반영)

> 검증 게이트 = **CONDITIONAL-GO**(그릇 방향 GO·적재 가능·멱등·FK·돈무영향) · codex 독립 = **NO-GO as written**(방향 GO·적용 NO-GO). 차단 3건(A5 정본·채번 race·이중판수) 보정 반영. **그릇 방향은 GO·아래 차단 보정 후 적용 안전 확보**.

| 항목 | 결론(보정 후) | 근거 |
|---|---|---|
| **채번(신규 내지 prd_cd)** | **PRD_000284** (MAX=PRD_000283→MAX+1) + ★**race 가드**(advisory lock·exact-match abort·MAX재assert) | [차단2 CFM-CHAEBEON-RACE] codex#6·게이트 G1 |
| **신규 내지 상품명** | **`하드커버책자-내지(별도설정)`** | 095/098/101 컨벤션·072 내지종이="*별도설정"(다종) |
| **내지종이 자재(CFM-INNER-PAPER 해소)** | **069 무선책자 USAGE.01 내지 7종 set 재사용**(MAT_000073/077/087/095/096/104/105·dflt MAT_000073) ※provisional(072 직접목록 미명시·운영UI 별도 승인) | 072=하드커버**무선**→069 동형 sibling·게이트 G4 PASS·codex#8 |
| **★내지 sizes(차단1 CFM-INNER-A5-DEL 해소)** | ★**정본 active SIZ_000007(A5·del_yn=N)·SIZ_000050(A4·del_yn=N·note"책자내지")** — 삭제 SIZ_000170 copy **폐기** | inner-size-authority.md §3·§4(4원천 권위)·가격영향0(절가=국4절 기준·siz_cd 비격자축) |
| **dims = 정규화 copy(이동 아님)** | 권장 = copy(본체 dims 비파괴) ※sizes=정본교체·양면/A4 dflt=N/seq=2 **정규화**(라이브 중복디폴트 미전파·D1) | §3.2·게이트 G2 |
| **sets 행** | 072←PRD_000284·sub_prd_qty=1·disp_seq=1(inner-first)·min/max/cnt_incr=24/300/2·del_yn=N ※재배열 ★**CASE 목표대입**(+1 폐기·부분실패 멱등) | 094 패턴·[codex#7] |
| **판형(CFM-INNER-PLATE)** | 내지 plate_sizes에 국4절 SIZ_000499 추가(dflt) ※[D3] 뷰 plate_options는 셋트완제품(072) plate에서만 옴—내지 plate 추가만으론 뷰 미반영, 엔진은 selections로 동작(set-product 명시 주입) | S1/S2 plt_siz∈{077,499}만·게이트 G5 |
| **신규 mint 합계** | products1·sizes2·print2·page1·mat7·plate1·sets1 = **14행 INSERT** + 재배열 4 · 신규 자재/siz/단가행 **0** | search-before-mint 전수(§2) |
| **smoke(evaluate_price(inner)≠0)** | 🟡 단가행 실재(S2 53행·내지종이 절가)나 ★**S2 헤더 del_yn=Y 잔존**→양면 PRICE≠0은 S2부활(set-product) 선행 | §5.3·게이트 D2 |
| **★차단3 CFM-INNER-DBLPANSU** | 🔴 derive_inner_sheets(÷pansu)+plt_siz_cd comp plate_qty(÷pansu)=**이중 판수환산**→내지인쇄/용지 ~1/4 재과소 위험 | codex#4(신규 Critical)·view:1707~1709+pricing.py:561/574 |
| **잔여 CFM** | CFM-VESSEL-ZERO·CFM-BODY-INNER-RESIDUAL·CFM-INNER-WORKSIZ·CFM-INNER-PAPER-AUTH·CFM-COVER-QTY | §6 |

**판정: 보정 완료(생성 패스). 차단 3건 = (1)A5 정본 교체 **그릇 해소**·(2)채번 race **그릇 해소**·(3)이중판수 = **PRF 트랙 선결**(그릇 단계 무관·§3.5 핸드오프 가드 명문). 재검증(게이트+codex) 대기. 자기승인 금지.**

---

## 1. 라이브 재실측 (2026-06-25 읽기전용 SELECT · 사용자 제공 사실 전수 재확인)

### 1.1 채번 (search-before-mint 선결)

```
MAX prd_cd (PRD_%)               = PRD_000283  → 신규 내지 = PRD_000284
"하드커버책자-내지%" 상품 검색    = 0행  ← 신규 mint 정당(중복 없음)
```

### 1.2 072 sets 현 구성 (내지 구성원 부재 확증)

| disp_seq | sub_prd_cd | prd_nm | prd_typ | semi_role | sub_prd_qty | del_yn |
|---|---|---|---|---|---|---|
| 1 | PRD_000073 | 하드커버책자-표지(전용지) | PRD_TYPE.02 | **SEMI_ROLE.02**(표지) | 1 | N |
| 2 | PRD_000074 | 하드커버책자-면지(화이트면지) | PRD_TYPE.02 | SEMI_ROLE.03(면지) | 1 | N |
| 3 | PRD_000075 | 하드커버책자-면지(블랙면지) | PRD_TYPE.02 | SEMI_ROLE.03 | 1 | N |
| 4 | PRD_000076 | 하드커버책자-면지(그레이면지) | PRD_TYPE.02 | SEMI_ROLE.03 | 1 | N |

- ★**SEMI_ROLE.01(내지) 구성원 없음.** 본체 072 = PRD_TYPE.01·semi_role NULL·use_yn=Y·del_yn=N·min/max=1/1000.

### 1.3 072 본체 dims (내지 속성이 본체에 통합·이것을 내지로 copy)

| dim | 값(verbatim) | 의미 |
|---|---|---|
| **sizes** | SIZ_000170(A5 148x210·dflt Y·seq1·★마스터 del_yn=Y) · SIZ_000172(A4 210x297·dflt Y·seq1) | 완제(내지) 사이즈 — ★본체는 삭제 A5 참조 중(내지엔 정본 SIZ_000007/050 등록·§3.2) |
| **print_options** | opt_id1 POPT_000001(단면·front CLR_000005/back CLR_000001·dflt Y·seq1) · opt_id2 POPT_000002(양면·front/back CLR_000005·dflt Y·seq2) | 내지 도수(단면/양면) |
| **page_rules** | page_min24·page_max300·page_incr2 | 내지 페이지룰 |
| **materials** | MAT_000001/2/3(면지색·USAGE.03)·MAT_000246(전용지·USAGE.02) | 면지색 + 표지용지 |
| **plate_sizes** | SIZ_000250(150x214·dflt Y) · SIZ_000252(213x303·dflt Y) | 본체 판형(★인쇄단가 0행) |

- ★**내지종이(USAGE.01) 본체 미등록** = CFM-INNER-PAPER(사용자 제공 정확). 면지·표지만 있고 내지 종이가 없음 → 내지인쇄/내지용지 selections.mat_cd 타깃 부재.

### 1.4 핵심 코드/단가 사실 (smoke·전파 근거)

```
SIZ_000499 = 316x467(국4절·use_yn Y·del_yn N)  ← 사용자 "315x467"은 근사·실측 316x467
★[차단1] 내지 정본 active siz (삭제 SIZ_000170 대체·inner-size-authority.md):
   A5 = SIZ_000007 "A5 (148X210)" · del_yn=N · note=판걸이4/전지316x467/적용엽서 (작업150x212≈마스터150x214)
   A4 = SIZ_000050 "A4 (210X297)" · del_yn=N · note=판걸이2/전지316x467/적용전단지/★책자내지
   SIZ_000170(A5) del_yn=Y(삭제·copy 금지) · SIZ_000172(A4) del_yn=N(빈약 메타·정본 아님)
USAGE.01=내지 · SEMI_ROLE.01=내지  (t_cod_base_codes)
S1/S2 단가행 plt_siz ∈ {SIZ_000077, SIZ_000499} only  ← SIZ_000250/252 인쇄단가 0행
S2 국4절 POPT_000002(칼라양면) 단가행 53행 실재(1=6000·10=1600·50=1100·1000=330) · ★S2 헤더 del_yn=Y(부활 선행)
COMP_PAPER 국4절 내지종이 절가 실재(MAT_000073 백모120=36.88·MAT_000105 몽블130=77.03 …)
COMP_PAPER/S1/S2 use_dims 에 siz_cd 부재 → 내지 트림 siz 교체 가격영향 0(절가=plt_siz_cd 국4절 기준)
```

---

## 2. search-before-mint 전수 (신규 mint 정당성 입증)

| mint 후보 | 라이브 검색 결과 | 판정 |
|---|---|---|
| 내지 반제품 상품 | `하드커버책자-내지%` = **0행** | 🟢 신규 mint 정당(PRD_000284) |
| 내지 sizes ★SIZ_000007(A5)·SIZ_000050(A4) | 이미 존재(siz 마스터·del_yn=N 정본)·삭제 SIZ_000170 대체 | 🟢 **siz 재사용**(신규 siz 0·dim 행만 신규·차단1 해소) |
| 내지 print_opts POPT_000001/2 | 이미 존재·본체 등록 | 🟢 **재사용**(dim 행만 신규) |
| 내지종이 자재 7종 | MAT_000073/077/087/095/096/104/105 전부 실재(069 무선책자 USAGE.01) | 🟢 **자재 재사용**(신규 자재 0·dim 행만 신규) |
| 국4절 판형 SIZ_000499 | 실재(siz 마스터) | 🟢 **재사용**(plate dim 행만 신규) |
| COMP_PAPER 내지 단가행 | 국4절 7종 전부 절가 실재 | 🟢 **단가행 재사용**(신규 단가행 0) |
| S1/S2 인쇄 단가행 | 국4절 실재(S2는 부활 선행·set-product 트랙) | 🟢 재사용 |

★**신규 자재/siz/단가행 mint = 0.** 신규는 **상품 1행 + 그 상품의 dim 연결행(sizes2/print2/page1/mat7/plate1) + sets 1행 = 14행**. 전부 기존 마스터 코드의 새 연결.

---

## 3. 구조변경 설계 (PRD_000072 파일럿)

### 3.1 (A) 신규 내지 반제품 — t_prd_products INSERT 1행

| 컬럼 | 값 | 근거 |
|---|---|---|
| prd_cd | **PRD_000284** | MAX+1 |
| MES_ITEM_CD | NULL | 095 템플릿(반제품 MES 미부여) |
| prd_nm | **하드커버책자-내지(별도설정)** | 095/098/101 컨벤션·내지종이 다종 |
| prd_typ_cd | **PRD_TYPE.02** | 반제품(095/098/101 동일) |
| semi_role_cd | **SEMI_ROLE.01** | 내지(t_cod 확정) |
| nonspec_yn | **N** | 095 |
| file_upload_yn | **N** | 095 |
| editor_yn | **N** | 095 |
| min_qty/max_qty/qty_incr/dflt_qty | NULL | 095(내지 qty는 뷰 derived) |
| qty_unit_typ_cd | NULL | 095 |
| use_yn | **Y** · del_yn **N** | 활성 |
| reg_dt | DEFAULT now() | NOT NULL DEFAULT |

### 3.2 (B) 내지 dims — copy(이동 아님) · 정당화

**결정: copy(본체 dims 잔류) — 권장.** 분석:

| 옵션 | 본체 UI | 본체 이중평가 위험 | 판정 |
|---|---|---|---|
| **copy**(본체 dims 유지·내지에 동일 dims 등록) | 🟢 비파괴(본체 changeform 그대로) | 🟢 **0** — 본체 072 PRF는 **제본-only**로 재설계(set-product 트랙)·내지인쇄/내지용지 comp 미포함 → 본체가 내지 dims를 selections로 받아도 **그 dims를 쓰는 comp가 본체 공식에 없으므로 평가 기여 0** | 🟢 **권장** |
| move(본체 dims 삭제·내지로 이전) | 🔴 본체 changeform 파괴(운영자 혼란)·기존 화면 깨짐 | 🟢 0 | 🔴 비권장 |

- ★**이중평가 0 입증**: `evaluate_set_price`는 본체를 `evaluate_price(072, set_selections, copies)`로 자기 PRF(BODY=제본-only)만 평가. 내지인쇄·내지용지는 **내지 구성원 PRF(PRF_HC_INNER)**가 `evaluate_price(284, member.selections, total_sheets)`로 평가. 같은 dims가 본체·내지 양쪽에 있어도 **comp를 가진 쪽(내지)에서만 1회 청구** → 이중평가 없음. (단 set-product 트랙에서 본체 PRF가 제본-only임을 강제하는 것이 전제 — §3.5 핸드오프 가드.)
- copy 대상 dim 행:

| 테이블 | 내지(PRD_000284)에 등록할 행 | 출처 |
|---|---|---|
| t_prd_product_sizes | ★**SIZ_000007(A5·dflt Y·seq1)·SIZ_000050(A4·dflt N·seq2)** | ★[차단1] 정본 active 교체(삭제 SIZ_000170 copy 폐기·inner-size-authority.md) |
| t_prd_product_print_options | opt_id1 POPT_000001(단면·front CLR_000005/back CLR_000001·dflt Y·seq1)·opt_id2 POPT_000002(양면·CLR_000005/CLR_000005·dflt N·seq2) | 본체 print_opts **정규화 copy**(D1) |
| t_prd_product_page_rules | page_min24·max300·incr2 | 본체 page_rule copy |
| **t_prd_product_materials(USAGE.01 내지종이 7종)** | MAT_000073(dflt Y·seq1)·077(seq2)·087(seq3)·095(seq4)·096(seq5)·104(seq6)·105(seq7) | 069 무선책자 USAGE.01 set(CFM-INNER-PAPER 해소·provisional) |
| t_prd_product_plate_sizes | **SIZ_000499**(국4절·dflt_plt_yn Y) | CFM-INNER-PLATE 해소(§3.4) |

- ★**[차단1 CFM-INNER-A5-DEL 해소]**: 본체 072가 쓰는 **SIZ_000170(A5)는 마스터 del_yn=Y(삭제)** — copy하면 죽은 사이즈를 새 상품에 재이식. 4원천 권위(상품마스터+가격표+도메인+경쟁사) 분석 결과 **정본 active = A5 SIZ_000007(del_yn=N·작업150x212≈마스터150x214·margin/판걸이/전지 완비)·A4 SIZ_000050(del_yn=N·note "책자내지" 직접 태깅)**. 가격영향 **0**(COMP_PAPER/S1/S2 use_dims에 siz_cd 부재·절가는 국4절 plt_siz 기준·내지 트림 siz는 단가 격자축 아님). dryrun.sql P1-e가 "삭제 siz 미참조·정본 set 일치" assert로 가드. (라이브 19~20상품이 삭제 SIZ_000170 활성참조하는 광역 dedup 결함은 **huni-basedata-dedup 라우팅**·여기서 마스터/타상품 수정 금지.)
- ★**[D1 정규화 명시]**: 본체는 A4·양면이 둘 다 dflt=Y/seq=1(중복디폴트=데이터 이상). 본 내지 등록은 **값 보존 + dflt 단일화/seq 명확화 = 무손실 정규화 copy**(라이브 중복디폴트 미전파). "copy"라 했으나 정확히는 정규화 copy.
- ★**내지종이는 본체에 없던 USAGE.01** → copy가 아니라 **069 sibling set 신규 등록**(본체엔 내지종이 자체가 없으므로). dflt=MAT_000073(069 dflt 동일·백색모조지120g). ※069=provisional authority(072 직접 7종목록 미명시·codex#8)·운영 UI 내지종이 목록 별도 승인 게이트.

### 3.3 (C) sets 행 — t_prd_product_sets INSERT 1행 + 기존 disp_seq 재배열

| 컬럼 | 값 | 근거 |
|---|---|---|
| prd_cd | PRD_000072 | 셋트 본체 |
| sub_prd_cd | **PRD_000284** | 신규 내지 |
| sub_prd_qty | **1** | 094 패턴(내지=1) |
| **disp_seq** | **1**(inner-first) | 094: 내지 disp_seq=1·표지 2 |
| min_cnt/max_cnt/cnt_incr | **24/300/2** | 내지 페이지룰을 cnt로(094: 095 내지 20/30/10) |
| note | `내지=별도설정·페이지24~300/+2·총내지매수 derived` | 094 note 컨벤션 |
| del_yn | N · reg_dt DEFAULT now() | NOT NULL DEFAULT |

- ★**disp_seq 충돌 가드**: 현 073=1·074=2·075=3·076=4. 내지를 disp_seq=1로 넣으려면 기존 4행을 2~5로 밀어야 함. ★**[codex#7 보정] `+1` 증분 폐기 → `CASE` 목표값 대입**(073→2·074→3·075→4·076→5). `+1`은 부분커밋/재실행 시 누적증가(비멱등) 위험 — 목표값 대입은 N회 실행해도 동일 결과(멱등)·부분실패 안전. UPDATE 조건 = 현 disp_seq ≠ 목표값일 때만 발동(no-op 멱등). **단일 트랜잭션 필수**(BEGIN..COMMIT 내부서만).
- ⚠️ disp_seq는 NULL 허용이나 094는 명시값 → 명시 권장.

### 3.4 (D) 판형 해소 — CFM-INNER-PLATE

**결정: 내지 plate_sizes에 국4절 SIZ_000499 추가 — 권장.**

| 옵션 | 평가 | 판정 |
|---|---|---|
| **내지 plate_sizes에 SIZ_000499 추가**(dflt_plt_yn Y) | 🟢 S1/S2 단가행 매칭 판형 확보(0원 가드)·가격엔진 selections.plt_siz_cd 동작 | 🟢 **권장** |
| 클라이언트 plt 직접 주입 | 🟡 위젯 계약 의존·`_fn_best_plate` NULL 위험 | 🔴 차선 |

- 본체 072 plate_sizes(SIZ_000250/252)는 **인쇄단가 0행**이라 내지인쇄 평가 불가. 내지 구성원에 국4절을 등록하면 S1/S2 단가행 매칭·`fn_calc_pansu(국4절,A5)=4`(4-up)로 판수 환산 정합.
- ★**[D3 워딩 정정]**: 뷰 `_set_members_meta.plate_options`는 **셋트 완제품(072) plate_sizes에서** 가져온다(구성원 plate 아님·price_views.py:1525). 즉 내지(284) plate에 국4절을 넣어도 **시뮬레이터 판형 드롭다운엔 여전히 072의 250/252만** 보인다 → "내지 plate 추가만으로 뷰 자동판형 동작"은 **과장이었음**. 가격엔진(`evaluate_price(284,…)`)은 selections.plt_siz_cd로 동작하므로 **set-product 트랙이 내지인쇄 plt_siz=국4절을 명시 주입**하면 정상(§3.5 핸드오프 정합).
- ★내지 작업 siz(150x214·213x303)는 **출력파일 메타**로는 의미 있으나 **인쇄 단가 매칭 판형은 국4절**. 둘은 다른 역할(작업사이즈 vs 출력판형).

### 3.5 ★핸드오프 인터페이스 (set-product 가격 트랙이 동작하려면 내지가 노출해야 할 것)

본 구조변경 COMMIT 후, set-product 트랙(PRF 민팅)이 `evaluate_price(PRD_000284, member.selections, total_sheets)`를 성립시키려면 내지 구성원이 다음을 노출해야 한다 (본 명세가 전부 충족):

| 인터페이스 | 본 명세 제공 | set-product 트랙이 쓸 곳 |
|---|---|---|
| 내지 prd_cd | PRD_000284 | 073→COVER처럼 284→PRF_HC_INNER 바인딩 |
| selections.siz_cd | sizes(A5/A4) | pansu = fn_calc_pansu(국4절, 내지작업siz) |
| selections.print_opt_cd | print_opts(단면/양면) | 내지인쇄 S1(단면)/S2(양면·부활) |
| selections.mat_cd | materials(내지종이 7종) | 내지용지 COMP_PAPER 절가 |
| selections.plt_siz_cd | plate_sizes(국4절) | S1/S2·COMP_PAPER plt_siz 매칭 |
| page_rules | 24/300/2 | derive_inner_sheets(copies, pages, pansu)=총내지매수 |
| sets disp_seq=1·sub_prd_qty=1 | sets 행 | 뷰 `_set_members_meta`가 내지를 qty_mode=derived로 인식 |
| **본체 072 PRF = 제본-only** | (★가드·본 명세 밖이나 전제) | 본체에 내지인쇄/내지용지 comp 미배선 → 이중평가 0 |

- ★**가드 ①(이중계상)**: set-product 트랙은 본체 PRF_HC_BODY를 **제본/조립만**으로 재설계해야 한다(내지인쇄·내지용지 제거). 본 구조변경만 적용하고 본체 PRF에 내지 comp가 남으면 이중평가 발생 → §6 CFM-BODY-INNER-RESIDUAL 가드.

- ★★**가드 ②(차단3 CFM-INNER-DBLPANSU·codex 신규 Critical·돈 크리티컬)**:
  **내지 member 평가 경로에서 `derive_inner_sheets`가 이미 총판수(÷pansu·페이지 곱)를 산출**한다(price_views.py:1707 `eff_qty=derive_inner_sheets(copies,pages,pansu)`). 그 member에 `plt_siz_cd`도 주입되므로(price_views.py:1708~1709), `evaluate_price` 내지 평가 시 `_evaluate_formula`가 **plt_siz_cd 기반 comp(S2·COMP_PAPER)에 `plate_qty(qty,pansu)=⌈qty/pansu⌉`를 재적용**(pricing.py:561·574~575) → **÷pansu 이중**(국4절 4-up이면 실효 qty=⌈1,250/4⌉=313판 → §5.3의 1,250판이 ~1/4로 붕괴·내지인쇄/용지 ~1/4 재과소).
  → ★**이건 그릇(dims/sets) 단계가 아니라 set-product PRF 민팅 단계 선결 이슈다.** 그릇 적용만으로는 미해소. **PRF 트랙이 다음 중 하나를 [HARD] 선택해야 함**(후보만·본 명세 단정 금지·PRF 트랙·codex 재검증 대상):
  - (a) member qty = **`copies × pages`(미환산)** 전달 → 기존 plt_siz_cd comp가 plate_qty로 ÷pansu **1회**만.
  - (b) `derive_inner_sheets`(이미 환산) 전달 시 → 내지 전용 comp는 **use_dims에서 plt_siz_cd 제외**(plate_qty 재환산 없는 comp·단, 단가매칭은 plt_siz로 하되 환산 비적용 경로 필요) **또는** derive 시 plt 미주입 + 단가 직접지정.
  - 본 그릇이 노출하는 **국4절 plate + derived qty 조합**이 PRF 트랙에서 (a)/(b) 미결정 시 함정 → 본 핸드오프 가드를 PRF 게이트에서 반드시 해소.

---

## 4. 멱등 SQL 제안 (NOT 실행 · FK 위상정렬: products → dims → sets)

파일: `apply.sql`(가드 INSERT)·`backup.sql`(bak_* 스냅샷)·`dryrun.sql`(BEGIN…assert…ROLLBACK)·`undo.sql`(역적용). 전부 **제안·미실행**. 상세는 각 SQL 파일 주석 참조.

- **FK 위상순서**: ① t_prd_products(PRD_000284) → ② t_prd_product_sizes/print_options/page_rules/materials/plate_sizes(284 참조) → ③ t_prd_product_sets(072←284, 284 선존 필수).
- **멱등 가드**: 전 INSERT = `WHERE NOT EXISTS (SELECT 1 … 자연키 매칭)`. 자연키 = (prd_cd) products·(prd_cd,siz_cd) sizes·(prd_cd,opt_id) print_opts·(prd_cd) page_rules·(prd_cd,mat_cd,usage_cd) materials·(prd_cd,siz_cd) plate_sizes·(prd_cd,sub_prd_cd) sets. **ON CONFLICT 미사용**(자연키 UNIQUE 인덱스 NULLS DISTINCT 함정 회피·NOT EXISTS 명시 가드 — 메모리 dbmap-live-load-transition 교훈).
- **reg_dt**: DEFAULT now() 컬럼 → INSERT 시 명시 or 생략(생략 시 default). disp_seq 재배열 UPDATE는 ★**CASE 목표값 대입**(현 disp_seq ≠ 목표일 때만 발동·멱등·부분실패 안전·codex#7 보정).
- **★[차단2] 채번 race 가드**: apply.sql 선두에 `pg_advisory_xact_lock(hashtext('inner-promotion-prd-chaebeon'))` + DO 블록(MAX(prd_cd)=283 재assert·PRD_000284 선점 시 exact-match[PRD_TYPE.02·SEMI_ROLE.01·내지명] 아니면 ABORT) + dims/sets 부착 전 "284=우리 내지" 의미 재확인 DO. COMMIT 직전 라이브 재실측 필수.
- **IDENTITY/sequence**: t_prd_products PK=prd_cd(문자열·시퀀스 아님)·채번=MAX+1 수동 → 시퀀스 setval 불요. t_prd_product_print_options opt_id는 prd_cd 범위 내 1/2(수동) → 시퀀스 없음. ★**component_prices 류 IDENTITY 부활 함정은 본 구조변경엔 무관**(신규 단가행 0).

---

## 5. DRY-RUN 검증 설계 (멱등·FK 무결성·고아 0·smoke PRICE≠0)

### 5.1 멱등성 증명 (dryrun.sql 2-pass)

- BEGIN → apply 1회차 → 영향행 COUNT(7테이블) assert = 14 신규 + 4 재배열 → apply 2회차(동일 SQL) → 신규 INSERT **0행**(NOT EXISTS 가드) assert → ROLLBACK. 2회차 0행 = 멱등 입증.

### 5.2 FK 무결성·고아 0

- assert: 내지 PRD_000284 INSERT가 dims/sets보다 **선행**(위상순서). sets 행 INSERT 전 `EXISTS(284 in t_prd_products)` assert.
- assert: 고아 0 — 내지 dims의 siz_cd/print_opt_cd/mat_cd 전부 마스터 실재(FK 만족). sets.sub_prd_cd=284 실재.
- assert: disp_seq 재배열 후 072 sets disp_seq 집합 = {1(내지),2(073),3,4,5} 중복 0.

### 5.3 post-load smoke — evaluate_price(inner) PRICE≠0 (읽기전용 SELECT로 사전 확증)

내지 구성원이 갖출 단가행이 실재함을 **이미 SELECT로 확증**(적재 후 evaluate_price가 0 아님을 보장):

```
[내지인쇄 S2 국4절 POPT_000002(양면칼라)] 단가행 53행 실재 — 1=6000·10=1600·50=1100·100=700·1000=330
[내지인쇄 S1 국4절 POPT_000002(양면*=칼라단면)] 1=4000·10=1000 …
[내지용지 COMP_PAPER 국4절] MAT_000073=36.88·077=36.68·087=36.68·095=54.87·096=71.33·104=59.25·105=77.03 (절가·verbatim)
```

- 손계산(set-product 트랙 PRF 민팅 후·★차단3 DBLPANSU 보정 반영): A5·양면칼라·100p·50권·백모120 →
  pansu = fn_calc_pansu(국4절,A5)=4 → total_sheets = derive_inner_sheets(50,100,4) = 50×⌈100/4⌉ = 50×25 = **1,250판**(뷰가 산출)
  - 🟢 **정답(목표)**: 내지인쇄 = S2 tier(1250→1000tier=330) × 1,250 = **412,500**(현 본체통합 13판×1600=20,800 대비 ~20배 정합)·내지용지 36.88×1,250=46,100.
  - 🔴 **★차단3 함정(보정 안 하면)**: 내지 PRF가 plt_siz_cd 기반 S2/COMP_PAPER를 그대로 쓰면 `_evaluate_formula`가 **plate_qty(1250, pansu=4)=⌈1250/4⌉=313판** 재적용 → 내지인쇄 ~313×tier·내지용지 36.88×313 = **~1/4 재과소청구**(이중 ÷pansu). → PRF 트랙이 §3.5 가드 ②(a)/(b)로 해소 필수.
  → **PRICE ≠ 0** 가능하나 **정확 청구는 차단3 해소 전제**. (본 명세는 그릇만·PRF 민팅 후 게이트.)
- ★smoke 한계: ① PRF 미민팅 상태에선 `evaluate_price(284)` = has_formula false → 0 반환. ② **S2 헤더 del_yn=Y 잔존**(라이브 확증) → 양면 내지인쇄 평가 제외(0) → 양면 PRICE≠0은 **S2 부활(set-product) 선행 전제**. dryrun.sql smoke가 헤더 del_yn을 NOTICE로 표면화(D2 한계 명시). **그릇 검증 = 단가행 실재 + dims 등록(정본 active siz) + sets derived 인식**까지. PRICE≠0·정확청구 실증은 set-product 트랙(PRF 민팅·S2 부활·차단3 해소) 후 게이트.

---

## 6. CFM / BLOCKED 보드

| ID | 항목 | 상태(보정 후) | 라우팅 | 돈영향 |
|---|---|---|---|---|
| **CFM-INNER-TOTSHEET** | 내지=본체 통합→페이지 곱 누락 | 🔴 본 구조변경이 **해소 그릇** 제공(내지 구성원 승격) | 본 명세 INSERT(인간 승인) + set-product PRF 민팅 | 내지인쇄 ~20배 과소청구 해소 |
| **★CFM-INNER-A5-DEL(차단1)** | SIZ_000170(A5) del_yn=Y(삭제) copy 위험 | 🟢 **해소** — 정본 active SIZ_000007(A5)·SIZ_000050(A4) 등록(부활 불요) | apply.sql sizes 교체·dryrun P1-e assert·**광역 dedup(20상품)은 huni-basedata-dedup flag** | 0(절가=국4절 기준·siz_cd 무영향) |
| **★CFM-CHAEBEON-RACE(차단2)** | 하드코딩 284 + 단순 NOT EXISTS = 타의미 오부착 | 🟢 **해소(그릇)** — advisory lock + exact-match abort + MAX재assert + 의미가드 | apply.sql 선두 DO 블록·COMMIT 직전 재실측 | 0(오염 차단) |
| **★CFM-INNER-DBLPANSU(차단3·codex 신규 Critical)** | derive_inner_sheets(÷pansu)+plt_siz_cd comp plate_qty(÷pansu)=이중 판수환산 | 🔴 **PRF 트랙 선결**(그릇 단계 무관)·§3.5 가드② 명문 | set-product PRF [HARD]: (a)member qty=copies×pages or (b)내지 comp use_dims plt_siz_cd 제외 | 🔴 내지인쇄/용지 ~1/4 재과소 위험 |
| **CFM-INNER-PAPER** | 내지종이 USAGE.01 미등록 | 🟢 해소(069 set 7종·provisional) | 본 명세 materials 7행·운영UI 목록 별도승인 게이트(codex#8) | 내지용지 selections 주입 가능 |
| **CFM-INNER-PLATE** | 내지 판형=국4절 | 🟢 해소(plate_sizes 국4절 추가)·★[D3] 뷰 plate_options 미반영(엔진 selections 동작) | 본 명세 plate 1행·set-product 명시 주입 | 내지인쇄 0원 가드 |
| **CFM-VESSEL-ZERO(codex#2)** | vessel-first COMMIT 시 내지=0원 침묵합산 | 🟡 High | PRF 트랙과 묶음 게이트 or feature flag 권고(분리승인 재검토) | 0원 구성원 합산 위험 |
| **CFM-BODY-INNER-RESIDUAL(codex#3 강화)** | 본체 PRF에 내지 comp 잔류 시 이중계상 | 🟡 가드·프로세스약속(엔진 제약 아님) | PRF 게이트 검증SQL: 072 최신 공식 comp=제본/조립/후가공만 | 내지비 이중계상 |
| **CFM-DISPSEQ-REORDER(codex#7)** | disp_seq +1 부분실패 비멱등 | 🟢 **해소** — CASE 목표값 대입 + 단일 트랜잭션 | apply.sql C-pre CASE | UI 표시순서 |
| **CFM-INNER-WORKSIZ** | 내지 작업siz 단면150x214/양면213x303 분기 | 🟡 CONFIRM | pansu 계산 siz 분기 명문화(set-product) | pansu 정합 |
| **CFM-S2-DEL-REVIVE(D2)** | S2 헤더 del_yn=Y → 양면 내지인쇄 평가 제외 | 🟡 set-product 선행 | S2 부활(del_yn Y→N·인간 승인·부작용0 직전 확증)·smoke가 헤더 del_yn NOTICE | 양면 PRICE=0 가드 |
| **CFM-S2-NONMONO** | S2 10:1600·15:1800·20:1700 비단조 | 🟡 데이터품질(본 범위 밖) | 가격표 260527 verbatim 재확인(set-product) | 0(매칭 정확) |
| **CFM-COVER-QTY** | 표지 구성원 qty=copies 확장(codex 직전) | 🟡 본 범위 밖 | 뷰/위젯 조립 계약(set-product) | 표지 ~1/50 과소 위험 |

---

## 7. 077 / 082 전파 노트

| 셋트 | 072 대비 | 내지 승격 전파 |
|---|---|---|
| **PRD_000077 레더 HC책자** | 제본=하드커버무선(072 동형)·표지=레더(078)·내지종이 booklet-l1 "*별도설정"(072 동일) | **동형 전파** — 신규 내지 PRD_000285(채번 순차)·prd_nm=`레더 하드커버책자-내지(별도설정)`·dims=072 내지와 동일(069 무선 set·국4절)·sets 077←285 disp_seq=1. 077 sets 현 4구성원(078표지·079~081면지) +1 재배열. 표지 자재 오등록(078=몽블랑130 CONFIRM-077-MAT)은 별건(본 내지 승격 무관) |
| **PRD_000082 HC링책자** | 제본=하드커버트윈링·★**면지인쇄+면지코팅 2비목 추가(8비목)·표지/면지 ×2**·**087 인쇄면지 이미 별 구성원 존재** | 내지 승격 **동형**(신규 내지 PRD_000286·`하드커버 링책자-내지(별도설정)`·dims 동형·sets 082←286 disp_seq=1·현 5구성원 +1). ★차이: 082는 **면지인쇄(087)가 이미 별 구성원**(SEMI_ROLE.03 인쇄면지) → ×2 면지인쇄/코팅은 087 구성원 자기 공식으로 자연 표현(하이브리드 강점·multiplier 불요). 내지 승격은 072와 동일 패턴이나 **내지 작업siz·페이지룰은 082 본체 실측 재확인 필요**(트윈링은 페이지룰 상이 가능) |

- ★전파 원칙: 내지 승격 = **순수 그릇 추가**(셋트별 내지 1구성원·069 무선 내지 set·국4절). 채번만 순차(284/285/286), 나머지는 072 파일럿 동형. 082의 면지인쇄 multiplier(×2)는 **이미 087 별 구성원이라 본 내지 승격과 직교**(별 트랙).

---

## 8. 인간 승인 큐 (정확히 무엇을·어떤 순서로·돈영향)

> 차단 3건 중 (1)A5 정본·(2)채번 race = **그릇 단계 해소(apply/dryrun 보정 완료)**. (3)이중판수 = **PRF 트랙 선결**(아래 4단계 전제).

| 순서 | 승인 항목 | 파일 | 돈영향 | 전제 |
|---|---|---|---|---|
| **1** | 072 backup.sql 실행(영향행 bak_* 스냅샷) | backup.sql | 0(읽기 스냅샷) | 적재 전 필수 |
| **2** | 072 내지 승격 apply.sql COMMIT(products1+dims13+sets1+재배열4) | apply.sql | **간접**(그릇만·가격 미배선·이 단계 청구 변화 0·G8) | 차단1(A5 정본)·차단2(채번 race) 보정 완료 ✅·재검증 GO |
| **3** | (별 트랙) set-product PRF 민팅(PRF_HC_INNER·BODY=제본only·S2 부활·표지 펼침siz) **+ ★차단3 DBLPANSU 해소**(member qty=copies×pages or 내지 comp plt_siz 제외) | set-product 트랙 | **🔴 직접**(내지인쇄 ~20배 정합·과소청구 해소·단 DBLPANSU 미해소 시 ~1/4 재과소) | 2 COMMIT 후·게이트 GO·본체 PRF=제본only 가드·DBLPANSU 가드 |
| **4** | 077/082 동형 전파(285/286 내지 승격·082 페이지룰/작업siz 본체 실측 재확인) | (후속 파일) | 간접(그릇) | 072 파일럿 검증 후 |

- ★**2단계(구조변경)는 돈 청구를 바꾸지 않는다**(그릇만·G8). 실제 과소청구 해소는 3단계(PRF 민팅·set-product). 2가 3의 **선결 그릇**.
- ⚠️**[codex#2 CFM-VESSEL-ZERO 긴장]**: codex는 "vessel-first COMMIT 시 내지=0원 구성원이 침묵 합산"을 우려해 **vessel COMMIT을 PRF 트랙과 묶음 게이트 or feature flag 숨김** 권고(분리 승인과 충돌). 단 게이트 G8 = 072 price_formula 바인딩 0행(현 라이브 견적 미산출) → 2단계 직후 0원 구성원이 실제 quote에 노출되는 경로 없음(072 자체가 미바인딩). **권고: 2단계는 안전하나, 3단계 PRF 바인딩 전까지 072가 손님 견적에 노출되지 않도록(use_yn/노출 가드) 운영 확인** — 분리 승인 유지하되 노출 가드 추가. (인간 결정 사항.)

---

## 9. 출처 (날조 0)

- 라이브 실측(2026-06-25 읽기전용 SELECT): MAX prd_cd=PRD_000283·`하드커버책자-내지%`=0행·072 sets{073표지SEMI_ROLE.02·074/075/076면지SEMI_ROLE.03·전부 PRD_TYPE.02·sub_prd_qty1}·072 본체 PRD_TYPE.01/semi NULL/use Y/min1max1000·072 sizes{SIZ_000170 A5 dflt Y·SIZ_000172 A4 dflt Y}·print_opts{opt1 POPT_000001 단면 CLR_000005/CLR_000001·opt2 POPT_000002 양면 CLR_000005/CLR_000005}·page_rule{24/300/2}·materials{MAT_000001/2/3 USAGE.03·MAT_000246 USAGE.02·★USAGE.01 0행}·plate_sizes{SIZ_000250·252 dflt Y}·SIZ_000499=316x467·SIZ_000170 del_yn=Y·USAGE.01=내지·SEMI_ROLE.01=내지·S1/S2 plt_siz{SIZ_000077,SIZ_000499}·SIZ_000250/252 인쇄단가0·S2 국4절 POPT_000002 53행(50=1100·1000=330)·COMP_PAPER 국4절 내지종이 절가(MAT_000073=36.88…105=77.03)·068 USAGE.01 13종·069 USAGE.01 7종(MAT_000073/077/087/095/096/104/105 dflt MAT_000073)·094 sets{095내지 disp_seq1 cnt20/30/10·096표지 disp_seq2}·095/098/101=PRD_TYPE.02 SEMI_ROLE.01 nonspec/file/editor N use Y·082 sets 5구성원(087 인쇄면지 별구성원)·077 sets 4구성원·t_prd_products reg_dt DEFAULT now()/del_yn DEFAULT 'N'/nonspec_yn·file_upload_yn·editor_yn·use_yn NOT NULL·t_prd_product_sets reg_dt DEFAULT now()/del_yn DEFAULT 'N'/sub_prd_qty NOT NULL.
- 컬럼 실측: t_prd_product_sizes(prd_cd,siz_cd,dflt_yn,disp_seq,del_yn)·print_options(prd_cd,opt_id,print_side,front_colrcnt_cd,back_colrcnt_cd,dflt_yn,disp_seq,print_opt_cd,del_yn)·materials(prd_cd,mat_cd,usage_cd,dflt_yn,disp_seq,del_yn)·plate_sizes(prd_cd,siz_cd,dflt_plt_yn,output_paper_typ_cd,output_file_typ,note,del_yn)·page_rules(prd_cd,page_min,page_max,page_incr,note).
- 권위: 상품마스터(260610) booklet-l1.csv 072 하드커버책자(내지종이=*별도설정·내지인쇄 단면150x214/양면213x303·페이지24/300/2)·069 무선책자 USAGE.01 내지 set·set-price-authority.md §1.1(L47~54 원자합산형·내지인쇄비=[총내지매수행][도수열]×총내지매수).
- 엔진: pricing.py:718(evaluate_set_price)·:702(derive_inner_sheets=부수×⌈pages/pansu⌉)·price_views.py:1649(price_simulate_set·qty_mode derived)·:1472(_fn_calc_pansu)·:1501(_set_members_meta).
- 직전 설계: hc072-set-hybrid-design.md(하이브리드 모델·CFM-INNER-TOTSHEET §2.4)·hc072-hybrid-codex-reconcile.md(codex NO-GO·내지 승격 3자 합의 §1.1·§4)·inner-print-comp-arbitration.md(S1단면/S2양면·S2 부활)·cover-paper-calc-derivation.md(내지종이 *별도설정).
- ★보정 입력(2026-06-25·차단 3건): **inner-size-authority.md**(차단1·4원천 권위 → 내지 정본 active A5=SIZ_000007/A4=SIZ_000050·가격영향0·삭제 SIZ_000170 20상품 광역 dedup flag→huni-basedata-dedup)·**validation-gate.md**(CONDITIONAL-GO·G1~G9·D1 정규화/D2 S2헤더del_yn/D3 뷰plate_options/D-A5)·**codex-reconcile.md**(NO-GO as written·codex#4 DBLPANSU[★신규 Critical·view:1707~1709+pricing.py:561/574]·#5 A5 del_yn·#6 채번race·#7 disp_seq CASE·#8 069 provisional·#2 vessel-zero·#3 body-residual).
- ★보정 라이브 재확증(2026-06-25 읽기전용 SELECT): SIZ_000007(A5 148X210·del_yn=N·note 판걸이4/전지316x467/적용엽서)·SIZ_000050(A4 210X297·del_yn=N·note 판걸이2/전지316x467/적용전단지/책자내지)·SIZ_000170 del_yn=Y·SIZ_000172 del_yn=N·MAX prd_cd=PRD_000283·PRD_000284 0건·pg_advisory_xact_lock 가용·COMP_PAPER/S1/S2 use_dims siz_cd 부재(절가=plt_siz 국4절)·S2 헤더 del_yn=Y(부활 선행).
