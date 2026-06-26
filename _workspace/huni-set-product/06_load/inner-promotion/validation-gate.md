# 내지 반제품 승격 — 독립 검증 게이트 (PRD_000072 파일럿)

검증: dbm-validator (검증 패스·**생성≠검증**·생성자 주장 비신뢰·라이브 읽기전용 SELECT 직접 재실측) · 2026-06-25 · **NO COMMIT/INSERT/DDL** (롤백전용 DRY-RUN 실행·전부 ROLLBACK) · 단가 verbatim·무날조

> 대상 = dbm-load-builder 생성 `inner-promotion-design.md` + `apply.sql`/`backup.sql`/`dryrun.sql`/`undo.sql`. 전 수치를 라이브에서 독립 재측정해 G1~G9 판정.

> **★rev2(보정본 재검증) = §14 (최신 판정·그릇 단계 GO). rev1(아래 §0~§13)은 초판·이력 보존.**

---

## ★0. 종합 판정: **CONDITIONAL-GO**

| | 게이트 | 판정 | 핵심 근거(내 SELECT) |
|---|---|---|---|
| G1 | 채번 | 🟢 PASS | MAX prd_cd=PRD_000283·284 free·내지명 0행 (내가 재측정) |
| G2 | dims 출처·copy 무손실 | 🟡 CONDITIONAL | copy 아님 — A4 dflt/seq·양면 dflt/seq를 **정규화 변경**(아래 D1). 손실은 아니나 "copy" 표현 부정확 |
| G3 | **A5 del_yn (★critical)** | 🟡 CONDITIONAL | SIZ_000170(A5) **del_yn=Y** 확증. 단 라이브 19상품(068~072·077·082·100 등)·069 sibling 전부 동일 A5 사용 → 신규 결함 아닌 **선재 마스터 dedup 이슈**. 비삭제 A5 대안 실재(SIZ_000007/426) |
| G4 | 내지종이 7자재 | 🟢 PASS | 7자재 전부 실재·del_yn=N·국4절 절가 7행 실재(36.88~77.03 verbatim)·069 USAGE.01 set과 **완전일치**(코드·dflt·seq) → 권위근거 검증됨(추측 아님) |
| G5 | 판형(CFM-INNER-PLATE) | 🟢 PASS | S1/S2 plt_siz ∈ {SIZ_000077,SIZ_000499}만·SIZ_000250/252 인쇄단가 **0행** 확증·국4절 추가가 0원함정 해소. 단 뷰 갭(D3) |
| G6 | FK/PK 위상·무결성 | 🟢 PASS | FK 전부 실재(콜러=t_clr_color_counts CLR_000005/001·POPT·USAGE·siz·mat)·sets PK(prd,sub)·위상순서 정확·DRY-RUN 고아 0 |
| G7 | 멱등성 | 🟢 PASS | DRY-RUN 2-pass: 1회차 14신규+4재배열, **2회차 전부 INSERT 0/UPDATE 0**·073 disp_seq=2 불변 (내가 실행) |
| G8 | money-impact (그릇만) | 🟢 PASS | 072 price_formula 바인딩 **0행** 확증 → 구조변경 단독은 라이브 청구 0 변화 |
| G9 | post-load smoke | 🟢 PASS(조건부) | S2 국4절 양면 53행·내지종이 절가 실재 → PRICE≠0 가능. 단 **S2 del_yn=Y 잔존**(부활 별트랙·D2) |

**결론:** 구조 그릇 자체는 **적재 가능·멱등·FK 무결·돈 무영향**으로 입증됐다. NO-GO 사유 없음. 다만 **A5 del_yn(D1) 인간 결정**과 **A4/양면 dflt 정규화 의도 명시(D4)** 두 건이 COMMIT 전 확정돼야 하므로 **CONDITIONAL-GO**. 생성자가 A5를 CONFIRM으로 정직히 올린 것은 검증 통과 요건(은폐 0).

---

## 1. G1 채번 — PASS

내 재측정(2026-06-25):
```
MAX(prd_cd LIKE 'PRD_%')                 = PRD_000283
MAX(CAST(SUBSTRING(prd_cd,5) AS INT))    = 283  → 신규 = PRD_000284
PRD_000284 존재                          = 0행  (free·정당)
prd_nm LIKE '하드커버책자-내지%'         = 0행  (중복 mint 없음)
```
생성자 주장(PRD_000283/284 free/0행)과 **전부 일치**. search-before-mint 정당.

---

## 2. G2 dims 출처 + copy 무손실 — CONDITIONAL (D1)

라이브 072 본체 dims 내 재측정 vs apply.sql 기록값:

| dim | 라이브 072(실측) | apply.sql 기록 | 일치? |
|---|---|---|---|
| sizes | SIZ_000170(A5·**dflt Y·seq1**)·SIZ_000172(A4·**dflt Y·seq1**) | A5(dflt Y·seq1)·A4(**dflt N·seq2**) | ⚠️ A4 dflt/seq 변경 |
| print_opt | opt1 POPT_000001 단면(CLR_000005/001·**dflt Y·seq1**)·opt2 POPT_000002 양면(CLR_000005/005·**dflt Y·seq1**) | opt1(dflt Y·seq1)·opt2(**dflt N·seq2**) | ⚠️ 양면 dflt/seq 변경 |
| page_rule | 24/300/2 | 24/300/2 | 🟢 일치 |
| materials | (본체엔 면지001/2/3 USAGE.03·MAT_000246 USAGE.02·**USAGE.01 0행**) | 069 USAGE.01 7자재 신규 | 🟢 (copy 아닌 069 set·G4 참조) |
| plate | SIZ_000250/252(dflt Y) | SIZ_000499 국4절 신규 | 🟢 (해소 추가·G5 참조) |

- **D1(MINOR·정직성)**: 명세는 sizes/print을 "본체 copy(무손실)"라 했으나 실제는 **A4·양면을 dflt=N/seq=2로 정규화**. 라이브는 둘 다 dflt=Y/seq=1(중복 디폴트=데이터 이상). 정규화 자체는 **개선**이나, 설계 문서가 "copy"로 표기한 것과 SQL이 불일치 → 의도(정규화)임을 §3.2에 명시해야 함. 손실 아님(값 보존), 라우팅=`dbm-load-builder`(문서 워딩).

---

## 3. G3 ★A5 del_yn (critical) — CONDITIONAL (D… 재평가)

내 재측정:
```
SIZ_000170 A5(148x210)  use_yn=Y  del_yn=Y   ← 논리삭제 상태 확증
SIZ_000172 A4(210x297)  use_yn=Y  del_yn=N
```
생성자 주장(A5 del_yn=Y) **사실 확인**. 단 생성자가 못 본/축소한 맥락을 내가 추가 재측정:

```
SIZ_000170(del_yn=Y A5)를 dflt_yn=Y product_size로 참조하는 라이브 상품 = 19개
  (047·052·053·054·058·059·060·061·068·069·070·071·072·077·082·100·144·176·177)
069 무선책자(우리가 종이set 베껴오는 sibling) sizes = SIZ_000170(A5)·SIZ_000172(A4) 동일
비삭제 A5 148x210 대안 실재 = SIZ_000007(del_yn=N)·SIZ_000426(del_yn=N)
product_sizes 트리거 = upd_dt only (del_yn=Y 마스터 참조 차단 트리거 없음)
DRY-RUN: A5 INSERT FK 통과(마스터 행 실재 → FK는 del_yn 무관)
```

**재판정(생성자 CFM-INNER-A5-DEL 보강):**
- A5 SIZ_000170을 내지에 등록하는 것은 **고립된 신규 결함이 아니다** — 라이브 책자 패밀리 19상품·권위 sibling 069가 **이미 동일하게 del_yn=Y A5를 디폴트로 운용** 중. 즉 마스터 A5가 통째로 논리삭제됐는데 상품레벨에선 활성으로 쓰이는 **선재 마스터 dedup/hygiene 모순**(메모리 huni-basedata-dedup 사이즈축과 동류).
- FK는 통과(행 실재)·트리거 차단 없음 → **적재는 됨**. 그러나 뷰 `_opts`는 product_sizes.del_yn=Y만 제외하므로 신규 내지 A5(product행 del_yn=N)는 **드롭다운에 노출**된다 → "마스터에선 삭제된 사이즈를 손님에게 선택지로 제시"하는 UX/거버넌스 부채를 **새 상품에 또 심는** 셈.
- **돈/UX 영향**: 가격 영향 0(그릇·미바인딩). UX 영향=A5 선택 가능(069 등과 동일 동작이라 회귀는 아님). 거버넌스 영향=del_yn=Y 마스터 의존 1건 추가.

**판정·권고(인간 결정 큐 D-A5):**
| 옵션 | 평가 |
|---|---|
| (a) A5=SIZ_000170 그대로(069 동형 답습) | 🟡 라이브 일관·즉시·단 del_yn=Y 부채 승계 |
| (b) **A5를 비삭제 SIZ_000007/426으로 교체**(seq1 dflt) | 🟢 부채 미승계·정합. 단 069 등 19상품과 코드 불일치(가격표 절가는 plt_siz=국4절 기준이라 siz_cd 교체 무영향=내가 G5에서 확인) → **권장** |
| (c) A4-only(A5 미등록) | 🔴 손님 A5 선택 박탈(권위 booklet-l1 A5 명시) → 비권장 |

→ **권장 = (b)** 또는 (a)+별도 마스터 A5 dedup 트랙. **이 1건이 CONDITIONAL의 첫 사유.** 라우팅=`dbm-load-builder`(siz_cd 택1) + (마스터 정리는 huni-basedata-dedup).

---

## 4. G4 내지종이 7자재 — PASS

내 재측정:
```
MAT_000073 백색모조지120g · 077 아트120 · 087 스노우120 · 095 앙상블100 · 096 앙상블130 · 104 몽블100 · 105 몽블130
  → 7자재 전부 실재·use_yn=Y·del_yn=N
069 무선책자 USAGE.01 set = 위 7코드·dflt=MAT_000073·disp_seq 1~7  ← apply.sql과 코드·dflt·seq 완전일치
COMP_PAPER 국4절(SIZ_000499) 절가 = 7자재 각 1행:
  073=36.88 · 077=36.68 · 087=36.68 · 095=54.87 · 096=71.33 · 104=59.25 · 105=77.03  (verbatim 일치)
```
- 권위근거(072 booklet-l1 내지종이 "*별도설정" → 069 무선 sibling 재사용)는 **추측이 아니라 069 실측 set과 1:1 일치**로 검증됨. 신규 자재/절가 mint 0. **내지용지 ≠ 0원** 보장. PASS.

---

## 5. G5 판형 CFM-INNER-PLATE — PASS (뷰 갭 D3)

내 재측정:
```
COMP_PRINT_DIGITAL_S1 plt_siz 분포 = SIZ_000077(106행)·SIZ_000499(106행)  ← 그 둘만
COMP_PRINT_DIGITAL_S2 plt_siz 분포 = SIZ_000077(106행)·SIZ_000499(106행)
S1/S2 의 SIZ_000250/252 단가행 = 0행  ← 본체 판형은 인쇄단가 없음(0원 함정 실증)
SIZ_000499(국4절) = 실재·del_yn=N
```
- 본체 072 plate(250/252)는 인쇄단가 0행 → 내지인쇄 평가 불가. 내지에 국4절(SIZ_000499) 추가가 S1/S2 매칭 판형 확보 → 0원함정 해소. PASS.
- **D3(MINOR·뷰)**: `_set_members_meta`(price_views.py:1525)의 `plate_options`는 **셋트 완제품(072) plate_sizes에서** 가져온다(구성원 plate 아님). 즉 내지(284) plate에 국4절을 넣어도 시뮬레이터 판형 드롭다운은 여전히 072의 250/252만 보인다. 가격 엔진(`evaluate_price(284,…)`)은 selections.plt_siz_cd로 동작하므로 **set-product 트랙이 내지인쇄 plt_siz=국4절을 명시 주입**하면 정상(명세 §3.5 핸드오프와 정합). 단 "내지 plate에 국4절 추가만으로 뷰 자동판형 동작"(명세 §3.4 표현)은 **과장** — 뷰 plate_options엔 안 뜸. 라우팅=`dbm-load-builder`(§3.4 워딩 정정) + set-product(명시 주입 가드 유지).

---

## 6. G6 FK/PK 위상·무결성 — PASS

내 재측정(information_schema + DRY-RUN):
```
FK 실재: sets.sub_prd_cd→t_prd_products · sizes/print/mat/plate.prd_cd→products
         sizes/plate.siz_cd→t_siz_sizes · print.front/back_colrcnt_cd→t_clr_color_counts
         print.print_opt_cd→t_prt_print_options · mat.mat_cd→t_mat_materials · mat.usage_cd→t_cod_base_codes
콜러 코드 CLR_000005·CLR_000001 = t_clr_color_counts 실재(★t_cod 아님)
POPT_000001/2·USAGE.01·PRD_TYPE.01/02·SEMI_ROLE.01 전부 실재
PK: sets(prd_cd,sub_prd_cd) · print(prd_cd,opt_id) · mat(prd_cd,mat_cd,usage_cd) · page_rule(prd_cd)
   → apply.sql NOT EXISTS 가드 자연키가 PK와 일치(특히 mat 3-key 정확)
NOT NULL: 전 대상테이블 NOT NULL 컬럼이 apply.sql 컬럼리스트로 충족(검증 완료)
```
- **위상순서**: products(284)→dims→sets, sets INSERT엔 `WHERE EXISTS(284 in products)` 선존 가드 → DRY-RUN에서 고아 0 입증. PASS.

---

## 7. G7 멱등성 — PASS (내가 DRY-RUN 직접 실행)

`psql -v ON_ERROR_STOP=on -f dryrun.sql` (cwd=inner-promotion·롤백전용) 실행 결과:
```
PASS1: products 1 · sizes 2 · print 2 · page 1 · mat 7 · plate 1 · reorder UPDATE 4 · sets 1   (=14신규+4재배열)
        assert P1-a(284 등록)·P1-b(dims=13)·P1-c(sets disp_seq=1·중복0)·P1-d(고아0) 전부 통과
PASS2(재적용): products 0 · sizes 0 · print 0 · page 0 · mat 0 · plate 0 · reorder UPDATE 0 · sets 0  (전부 no-op)
        assert P2: 072 sets=5·073 disp_seq=2 불변 통과
smoke NOTICE: S2 단가행 53행 · 내지종이 절가 1행
ROLLBACK   ← 영구 변경 0 (COMMIT 없음)
```
- disp_seq 재배열 멱등 가드(`NOT EXISTS 284`) 검증: 2회차에 284 실재 → reorder 미작동(UPDATE 0)·073 disp_seq 재증가 0. **멱등 정확.** PASS.
- backup.sql/undo.sql 검토: bak_* 스냅샷이 재배열 전 disp_seq 보존·undo가 bak 기준 원복+역순 삭제·잔재 0 assert → 복원 설계 건전(별도 실행 안 함·멱등 가드 정상).

---

## 8. G8 money-impact (그릇만) — PASS

```
t_prd_product_price_formulas WHERE prd_cd='PRD_000072' = 0행   ← 072 UNBOUND 확증
```
- 072는 현재 가격공식 미바인딩 → `evaluate_set_price`/`evaluate_price`가 has_formula=false로 0 반환(현재 라이브 견적 산출 없음). 본 구조변경(products+dims+sets+재배열)은 **단가·공식·바인딩을 일절 건드리지 않음** → 라이브 청구 변화 **0**. 명세 §8 "2단계 구조변경은 돈 청구 불변" **정확**. PASS.

---

## 9. G9 post-load smoke (PRICE≠0 가능) — PASS (조건부·S2 부활 의존)

내 재측정:
```
COMP_PRINT_DIGITAL_S2 국4절 POPT_000002(양면칼라) 단가행 = 53행 실재
  tier: 1=6000·2=4600·…·50=1100·100=700·1000=330  (명세 50=1100·1000=330 일치)
COMP_PAPER 국4절 MAT_000073 절가 = 1행(36.88)
```
- 그릇 검증(단가행 실재·dims 등록·sets derived 인식)은 충족 → PRF 민팅 후 PRICE≠0 가능. PASS.
- **D2(MAJOR·핸드오프 가드)**: `COMP_PRINT_DIGITAL_S2` 헤더 **del_yn=Y(라이브 잔존)** 내가 확인. 단가행은 존재하나, `evaluate_price`가 del_yn=Y comp를 평가에서 제외하면 양면 내지인쇄=0. dryrun smoke는 **단가행 존재만** 검사(comp 헤더 del_yn 미검사) → "그릇 OK"는 맞지만 "양면 PRICE≠0"은 **S2 부활(별 트랙) 선행 전제**. 명세가 S2 부활을 OUT으로 정직히 분리한 건 옳으나, smoke가 헤더 del_yn을 안 보는 한계는 검증 보고에 명시. 라우팅=set-product(S2 부활 UPDATE·인간 승인).

---

## 10. disp_seq 재배열(G7 부속) 안전성 — PASS

- 라이브 072 sets disp_seq = 073:1·074:2·075:3·076:4(실측). apply C-pre가 +1(→2~5), 내지=1.
- 멱등 가드 `disp_seq<=4 AND NOT EXISTS(284)`: 1회차 284 미존재→발동, 2회차 284 존재→스킵(DRY-RUN UPDATE 0 입증). disp_seq NULL 허용이나 094 정합 위해 명시값 — 적절. upd_dt 컬럼 실재(스키마 확인)·UPDATE에 upd_dt=now() 정상. PASS.

---

## 11. 생성자가 놓친/축소한 결함 (검증 부가가치)

| # | 결함 | 심각도 | 생성자 상태 | 내 보강 |
|---|---|---|---|---|
| D1 | sizes/print "copy" 주장이나 실제 A4·양면 dflt/seq **정규화** | MINOR | 미언급(copy로 기술) | 라이브 둘다 dflt=Y/seq=1(중복디폴트 이상)·SQL은 정규화=개선이나 문서 워딩 정정 필요 |
| D2 | S2 헤더 **del_yn=Y 라이브 잔존**·smoke가 헤더 미검사 | MAJOR | §6 CFM-S2-NONMONO만·부활 OUT | 양면 PRICE≠0은 S2 부활 선행 전제임을 smoke 한계로 명시(set-product) |
| D3 | 뷰 plate_options는 **072(셋트 완제품) plate**에서만 — 내지 plate 국4절 추가가 뷰 드롭다운엔 미반영 | MINOR | §3.4 "뷰 자동판형 동작" 과장 | 가격엔진은 selections로 동작(정상)이나 §3.4 워딩 정정 |
| D-A5 | A5 del_yn=Y이나 라이브 19상품·069 동형 사용 → **선재 마스터 dedup** | (재분류) | CFM CONFIRM(정직) | 고립 결함 아님·비삭제 A5 대안(007/426) 권장·돈영향0 |

★생성자가 A5 del_yn·S2 del_yn·SIZ_000250/252 0원함정·국4절 53행을 **정직하게 올린** 점은 양호(은폐 0). D2/D3는 명세 워딩의 과장이지 데이터 결함은 아님.

---

## 12. 인간 승인 큐 (교정·확정)

| 순서 | 항목 | 결정 필요 | 돈영향 |
|---|---|---|---|
| **1** | **D-A5**: 내지 A5 siz_cd = SIZ_000170(069 동형) vs **SIZ_000007/426(비삭제·권장)** | ★인간 택1 (CONDITIONAL 1사유) | 0(절가는 국4절 기준·siz_cd 무영향) |
| **2** | **D4**: A4·양면 dflt=N/seq=2 정규화 의도 확정(명세 §3.2 "copy"→"정규화 copy" 워딩) | 확정 | 0 |
| **3** | backup.sql 실행 → apply.sql COMMIT(products1+dims13+sets1+재배열4) | 1·2 결정 후 | 0(그릇·미바인딩) |
| **4** | (별 트랙) set-product PRF 민팅 + **S2 부활(del_yn Y→N)** + 본체 PRF=제본only 가드 | 게이트 GO 후 | 🔴 직접(내지인쇄 페이지곱 정합) |
| **5** | 077/082 동형 전파 — ★082 페이지룰·작업siz **본체 실측 재확인 필수**(트윈링 상이 가능, 명세 §7 미검증) | 072 검증 후 | 간접 |

- ★2단계(구조변경)는 청구 불변(G8). 실제 과소청구 해소는 4단계(PRF+S2). **분리 승인**(구조 먼저·가격은 게이트 후) 권장 — 명세 §8과 동의.

---

## 13. 출처 (날조 0·전부 내 SELECT 2026-06-25)

라이브 읽기전용: MAX prd_cd=283·284/내지명 0행·072 본체(PRD_TYPE.01·semi NULL·use Y·del N)·072 sets{073~076 disp_seq1~4·sub_qty1·min/max/incr NULL}·072 sizes{170 A5 dflt Y seq1·172 A4 dflt Y seq1}·072 print{opt1 POPT001 단면 CLR005/001 dflt Y seq1·opt2 POPT002 양면 CLR005/005 dflt Y seq1}·page{24/300/2}·mat{246 USAGE02·001/002/003 USAGE03·USAGE01 0행}·plate{250·252 dflt Y}·siz_master(170 A5 del_yn=Y·172 A4 del N·499 국4절 cut306x457 del N·077·250·252)·SEMI_ROLE.01/USAGE.01 del N·mat 7자재 전부 del N·069 USAGE01 7set(170/172/dflt MAT073 seq1~7 일치)·069 sizes(170/172 dflt Y)·COMP_PAPER 국4절 7절가(36.88~77.03)·S1/S2 plt_siz{077·499 각106}·S1/S2 250/252=0행·S2 헤더 del_yn=Y·S1 del_yn=N·S2 국4절 양면 53행(50=1100·100=700·1000=330)·FK 전수(콜러=t_clr_color_counts)·PK(sets 2key·mat 3key)·NOT NULL 충족·072 price_formula 바인딩 0행·A5 19상품 참조·비삭제 A5(007/426)·product_sizes 트리거 upd_dt only·094 sets(095 inner disp_seq1)·095 sizes 0행·page_rules/sets 스키마(del_yn·upd_dt·reg_dt default).
DRY-RUN: dryrun.sql 1회 실행(롤백전용)·2-pass 멱등 입증·전 assert 통과·smoke NOTICE·ROLLBACK(COMMIT 0).
엔진: pricing.py:702(derive_inner_sheets ceil)·:718/757~795(evaluate_set_price 구성원 evaluate_price+본체 공식+할인)·price_views.py:1494~1556(_set_members_meta·is_inner=SEMI_ROLE.01 derived·plate_options=셋트완제품 plate).

---

# 14. ★rev2 — 보정본 재검증 (차단 3건 보정 후 · 2026-06-25)

재검증: dbm-validator (생성≠검증·생성자 주장 비신뢰·라이브 읽기전용 직접 재실측·롤백전용 DRY-RUN **4회** 실행·전부 ROLLBACK·COMMIT 0). 대상 = load-builder 보정 `apply.sql`/`dryrun.sql`.

## 14.0 종합 판정: **그릇 단계 GO** (rev1 CONDITIONAL 2건 전부 해소)

| | rev1 판정 | rev2 보정 | rev2 재판정 |
|---|---|---|---|
| **G2 dims copy** | 🟡 CONDITIONAL(D1·"copy" 워딩) | A4·양면 dflt=N/seq=2를 **정규화 copy**로 주석 명문화(apply L99~100) | 🟢 **PASS** — 워딩 정합·무손실 정규화 의도 명시 |
| **G3 A5 del_yn** | 🟡 CONDITIONAL(삭제 A5 부채 승계) | 정본 active **SIZ_000007(A5)·SIZ_000050(A4)**로 교체 + P1-e assert | 🟢 **PASS** — 삭제 siz 미참조 입증·SIZ_000050="책자내지" 권위 |
| **차단2 채번 RACE** | (rev1 미지적·codex 신규) | advisory lock + exact-match abort + MAX 재assert + CASE 멱등 | 🟢 **PASS** — abort 실발동 입증·CASE 부분상태 수렴 입증 |
| **차단3 DBLPANSU** | (rev1 미지적) | 그릇 무관·§3.5 핸드오프 가드로 명문(apply L15~16) | 🟢 **그릇 단계 제외**(PRF 트랙 선결·가드 명문 확인) |
| G1·G4·G5·G6·G7·G8·G9 | 전부 PASS(rev1) | 회귀 없음 | 🟢 **PASS 유지**(DRY-RUN 재확증) |

## 14.1 G3 해소 — 정본 active siz 교체 (★critical 해소)

내 재측정(생성자 SIZ_000007/050 주장 직접 검증):
```
SIZ_000007  A5(148X210)  use_yn=Y  del_yn=N  work150x212·cut148x210  note"판걸이=4.0/전지=316x467/적용=엽서"
SIZ_000050  A4(210X297)  use_yn=Y  del_yn=N  work216x303·cut210x297  note"판걸이=2.0/전지=316x467/적용=전단지/★책자내지"
```
- 둘 다 **del_yn=N(정본 active)** 확증 — rev1의 삭제 SIZ_000170(del_yn=Y) 부채 승계 해소.
- ★**SIZ_000050 note에 "책자내지" 명시** → A4 내지용 권위 태그 보유(생성자 선택이 추측 아닌 정합). SIZ_000007 note "전지=316x467"=국4절(SIZ_000499)·판걸이4 → plate 국4절 선택과 정합.
- 가격영향 0: COMP_PAPER/S1/S2 절가·단가는 **plt_siz=국4절 기준**(siz_cd 무관) → siz_cd 교체가 단가 매칭 불변(G5에서 확인).

**P1-e assert 실효성 입증(내가 직접):**
- 정상경로 DRY-RUN: `OK P1-e: 내지 sizes 정본 active(SIZ_000007·SIZ_000050·둘 다 del_yn=N)` NOTICE.
- ★teeth 테스트: 내지에 삭제 SIZ_000170 강제 주입 → `P1-e CORRECTLY FAILS: 1 deleted-siz refs` 발동 확인. **assert 비공허**(회귀 차단 실효).
- sizset 문자열 검사도 `SIZ_000007,SIZ_000050` exact-match 강제 → 임의 siz 혼입 차단.

## 14.2 G2 해소 — 정규화 copy 워딩

- apply L99~100 주석에 "본체는 둘 다 dflt=Y/seq=1(중복디폴트 데이터이상)·본 등록은 정규화 copy(값 보존·dflt 단일화)" 명문. rev1 D1(MINOR·문서 워딩)의 "copy 무손실" 표현 불일치 해소. 값(POPT_000001/2·CLR 코드)은 보존·중복디폴트만 미전파 = 무손실 정규화. PASS.

## 14.3 차단2 채번 RACE — abort 가드 실발동 입증

내가 직접 시뮬(롤백전용):
```
[정상경로] DRY-RUN: pg_advisory_xact_lock 획득·chaebeon DO 통과(MAX=283·284 미존재)·inner_guard 통과 → 정상 적재
[abort경로] PRD_000284 를 비-내지 상품(PRD_TYPE.01)으로 선점 주입 후 apply 실행
   → ERROR: ABORT CFM-CHAEBEON-RACE: PRD_000284 가 우리 내지가 아닌 다른 상품으로 선점됨 (MAX=PRD_000284)
   → "SHOULD_NOT_REACH" 미도달·트랜잭션 중단·주입행 롤백(leak_check=0 확인)
```
- exact-match(PRD_TYPE.02·SEMI_ROLE.01·내지명 LIKE) 3조건 검사 정확. 우리 내지 기존재 시엔 멱등 재실행(no-op)로 정상 진행 — abort는 **오염 선점**에만 발동. 채번 가정(MAX=283) 깨짐도 별도 abort. **advisory lock = xact 단위(COMMIT/ROLLBACK 자동해제)** 적절.
- ⚠️ 잔여 주의(MINOR·운영): advisory lock은 **동일 lock key를 쓰는 세션끼리만** 직렬화 — 다른 경로(webadmin admin·타 스크립트)의 동시 채번은 직렬화 못 함. 그래도 exact-match abort가 2차 그물이라 오적재는 차단(중복 채번 시 abort). 운영 적재는 단일 창구 권장.

## 14.4 codex#7 CASE 멱등 — 부분상태 수렴 입증

내가 직접 시뮬(롤백전용):
```
[2-pass] DRY-RUN: 1회차 reorder UPDATE 4·sets INSERT 1 / 2회차 UPDATE 0·INSERT 0 (멱등)·073 disp_seq=2 불변
[부분상태] 073만 미리 disp_seq=2 로 선이동(중단된 이전 실행 모사) 후 apply
   → reorder UPDATE 3(074/075/076만)·최종 {284:1,073:2,074:3,075:4,076:5} 중복0 수렴
```
- CASE 목표값 대입 = N회·부분상태서도 **동일 결과 수렴**. rev1 `+1 증분`(부분커밋 시 073 중복증가 위험)의 비멱등 해소. `disp_seq <> target` 자가교정 가드 정확.

## 14.5 G6/G7/G8/G9 회귀 재확증 (보정본 DRY-RUN)

```
FK 위상·고아 0: P1-d(내지종이 고아0)·P1-c(sets disp_seq 중복0) 통과·sets FK 선존가드(EXISTS 284) 정상
멱등: 2-pass 전부 no-op(INSERT 0·UPDATE 0)
돈무영향: 072 price_formula 바인딩 0행 재확증(UNBOUND) → 구조변경 단독 청구 변화 0
smoke: S2 국4절 양면 53행·내지종이 절가 1행 실재·★S2 헤더 del_yn=Y NOTICE로 정직 노출(D2 한계 명문)
```
- dims 행수 13(P1-b)·284 등록(P1-a) 통과. 신규 자재/siz/단가행 mint 0 유지.

## 14.6 차단3 DBLPANSU — 그릇 단계 제외 확인

- apply L15~16 + design.md §3.5 핸드오프 가드②에 "내지 PRF는 derive_inner_sheets가 이미 ÷pansu한 qty를 받으므로 plt_siz 기반 comp(S2/COMP_PAPER) plate_qty 재환산 회피(이중 ÷pansu)" **명문 확인**. 이는 **PRF 트랙(set-product) 선결 사항**이지 그릇(products+dims+sets) 적재와 무관 → 그릇 단계 판정에서 제외. 가드 명문화만 확인(엔진 검증은 PRF 민팅 시 별 게이트). 적절.

## 14.7 잔여 (그릇 단계 GO에 영향 없음·후속 트랙)

| ID | 항목 | 영향 | 라우팅 |
|---|---|---|---|
| D2 | S2 헤더 del_yn=Y 라이브 잔존 | 양면 PRICE≠0은 S2 부활 선결 | set-product(부활 UPDATE·인간 승인) |
| advisory-scope | lock은 동일 key 세션만 직렬화 | 타 경로 동시채번 미직렬(2차 abort가 그물) | 운영 단일창구 권장 |
| 069-provisional | 내지종이 7종 권위=069 sibling(072 직접목록 미명시) | UI 운영 별도 승인 | apply L118 명문(운영 게이트) |
| 082 전파 | 082 페이지룰·작업siz 본체 실측 미검증 | 트윈링 상이 가능 | 072 검증 후 본체 재실측 |

## 14.8 ★그릇 단계 최종 판정: **GO**

- products(PRD_000284) + dims(sizes2·print2·page1·mat7·plate1=13) + sets(072←284·재배열4) 적재본은 **적재 가능·멱등(2-pass+부분상태)·FK 무결·고아 0·채번 race-safe·삭제siz 미참조·돈무영향**으로 라이브 DRY-RUN(4회·전부 ROLLBACK·COMMIT 0)에서 독립 입증.
- rev1 CONDITIONAL 2건(G2·G3) 전부 해소. NO-GO 사유 0.
- ★실 COMMIT은 인간 승인 후(backup.sql 선행). 가격 트랙(PRF 민팅·S2 부활)은 본 그릇 COMMIT 후 별 게이트 — **그릇과 가격 분리 승인**(rev1 §12와 동일).

## 14.9 rev2 출처 (날조 0·내 SELECT/DRY-RUN 2026-06-25)
- 라이브: SIZ_000007(A5 del_yn=N work150x212 note"판걸이4/전지316x467/엽서")·SIZ_000050(A4 del_yn=N work216x303 note"판걸이2/전지316x467/전단지/★책자내지")·072 binding 0행·MAX prd_cd=283·284 0행.
- DRY-RUN(롤백전용 4회): ① 정상 2-pass 멱등(P1-a~e 통과·P1-e NOTICE) ② 284 비-내지 선점→chaebeon ABORT 실발동·leak 0 ③ 부분상태(073 선이동)→CASE 수렴 {1,2,3,4,5} ④ P1-e teeth(삭제siz 주입→CORRECTLY FAILS). 전부 ROLLBACK·COMMIT 0.
