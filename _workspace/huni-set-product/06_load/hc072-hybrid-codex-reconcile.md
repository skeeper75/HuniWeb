# 072 하드커버책자 셋트 하이브리드 — codex 독립 2차 교차검증 reconcile

생성: hsp-codex-verifier · 2026-06-25 · codex-cli gpt-5.5(reasoning=high·`-s read-only`·session 019efe27) 독립 호출 + Claude 라이브 SELECT 재실측(읽기전용·COMMIT 0)
헬퍼: `hqv-codex-cross-verify/scripts/codex-review.sh ... high`
방법: Claude 판정 비노출·원천 사실(구성원·내지본체통합·del_yn·단가·pansu·proc위계)만 제공 → codex 독립 처분 → reconcile. codex 주장=가설 → 라이브로 확증 후 사실/기각 라우팅.

> ★**codex 종합 판정 = NO-GO**(현 설계 그대로 적재 시 돈 결함 확정). Claude 입력 비노출 독립 도출.

---

## 0. 한눈 요약

| 항목 | codex 판정 | Claude 라이브 확증 | reconcile |
|---|---|---|---|
| 하이브리드 아키텍처(구성원+본체 모델) | 부분 동의 | 사실(evaluate_set_price 코드 정합) | **합의** — 모델 자체 맞음·단일번들 폐기 옳음 |
| ★CFM-INNER-TOTSHEET(내지=본체→페이지 곱 누락 과소청구) | 동의(최중요 돈결함) | 사실(본체 copies 평가만·pages 미반영) | **합의** — 내지 과소청구 확정 |
| 내지 별도 구성원 승격이 정석 | 동의 | 코드 정합(뷰 derive_inner_sheets는 구성원에만 적용) | **합의** — 승격 동의 |
| 표지 pansu 자연 해소 | 조건부 동의(★표지 qty=copies 확장 필수 검증) | **codex 신규 적발** — 미해소 갭 | **codex 신규** — 뷰 조립 계약 명문화 필요 |
| S2 부활 | 부분 동의(부작용0 확인要) | **확증: 전역 S2 참조 0건** | **합의+확증** — 부작용 0 사실 |
| 이중계상 0 | 조건부 동의 | 사실(frm_cd 분리·comp 1회) | **합의** |
| 제본 9000×50=450,000 | 정상(false-positive 가드) | 사실(제본=책단위·plt_siz 없음→copies) | **합의** — 과대청구 아님 |
| S2 tier 비단조(10:1600,15:1800) | 데이터 품질 신호(즉시 결함 아님) | 사실(비단조 실재) | **합의** — 가격표 확인 대상 |
| fn_calc_pansu(국4절,국4절)=0 위험 | 실제 위험 | 사실(plt=siz면 0→comp 0원 제외) | **합의** — 입력 가드 필요 |
| 표지 50tier=550 | 불확실(B.5에 50행 미표시) | **확증: 50tier=550 실재** | **codex 보수성 해소** — 설계 골든 정확 |
| 내지용지 mat 주입 | 추가 리스크 지적 | **codex 신규 적발** — 072 materials에 내지종이 mat 미등록 | **codex 신규** — 내지종이 selections 주입 갭 |

---

## 1. 합의분 (Claude↔codex 독립 수렴·고신뢰)

### 1.1 ★CFM-INNER-TOTSHEET = 내지 과소청구 확정 (최중요 돈 크리티컬)
- **합의**: 내지가 sets 구성원이 아니라 본체 072에 통합 → `evaluate_set_price`가 본체를 `copies=50`으로만 평가 → 내지인쇄 comp_qty=`plate_qty(50,4)=ceil(50/4)=13`. 100페이지 50권인데 내지인쇄가 **13판어치(20,800원)만 청구**. 권위 내지인쇄비=총내지매수(부수×ceil(페이지/판걸이)=50×ceil(100/4)=50×25=1,250판) 대비 **약 1/96 과소청구**(설계자 "페이지 곱 미반영" 정확).
- **확증(코드 사실)**: pricing.py:789 본체는 `evaluate_price(set_prd_cd, set_selections, copies)` — copies 평가뿐. `derive_inner_sheets`(pages 곱)는 A.4 뷰 레이어가 **구성원(member)에만** 적용. 본체 공식에 내지인쇄·내지용지를 두는 한 페이지 곱은 구조적으로 표현 불가.
- **내지 별도 구성원 승격 동의**: codex·Claude·설계자 3자 합의. 내지를 `SEMI_ROLE.01` 구성원으로 sets에 추가 → 뷰가 `qty_mode=derived`로 `derive_inner_sheets(copies,pages,pansu)`=총내지매수 산출 → 내지인쇄/내지용지=내지 구성원 공식, **본체 072 공식엔 제본/조립만** 잔류가 코드 모델 정석.
- → ★**현 설계(본체에 내지 internalize)는 NO-GO 핵심 사유.** 072→PRF_HC_BODY(내지 포함) 바인딩 보류 권고가 정당.

### 1.2 하이브리드 모델 자체·단일번들 폐기 = 옳음
- **합의**: "구성원별 공식 + 셋트 본체 공식" 자체는 evaluate_set_price 모델 정합. 표지(펼침 siz·pansu=1)·내지(완제 siz·pansu=4)·제본(plt 무관)은 수량 기준이 달라 한 공식 internalize 시 pansu/qty가 섞임 → 단일번들 폐기 옳음(codex 독립 동의).

### 1.3 S2 부활 = 옳음 + ★부작용 0 확증
- **합의+확증**: 양면 내지=S2가 정답. S1(단면) 복제로 양면 단가 만들면 과소청구(13판 기준 S1 10tier=1,000 vs S2=1,600 → 37.5% 저청구·codex 독립 산출, Claude 단가 일치).
- ★**Claude 라이브 확증**: `t_prc_formula_components WHERE comp_cd='COMP_PRINT_DIGITAL_S2'` = **0행**(전역 활성공식 참조 0). 설계의 "부작용 0" 주장 = **사실**. del_yn Y→N 토글은 안전(단가행 212 불변).
- (대조: S1은 PRF_DGP_A~F 6공식에서 참조 중 → S1 변경은 위험·S2만 안전.)

### 1.4 false-positive 가드 = 정상 (과보류/오보류 아님)
- **제본 9000×50=450,000 = 정상**(합의): 제본은 책 단위 비용. use_dims에 plt_siz 없어 comp_qty=copies=50. "권당 9000 × 50권"이 맞고 과대청구 아님. → 설계 골든의 자기의심("부당9000×50") 표기는 **불필요한 자기의심**(false-positive 가드 통과).
- **이중계상 0 = 정상**(합의): 표지(PRF_HC_COVER)·본체(PRF_HC_BODY) frm_cd 분리 → 코팅 1회·제본 1회·용지 각 1회. 같은 COMP_PAPER를 표지/내지에 각각 쓰는 건 다른 mat·다른 평가라 이중계상 아님.

### 1.5 데이터 품질 신호 (즉시 결함 아님·확인 대상)
- **S2 tier 비단조**(10:1600, 15:1800, 20:1700): 13판이면 `max(min_qty<=qty)` 매칭=10tier=1,600 → 설계 골든 정확. 단 10→15가 비싸지는 비단조는 **가격표 확인 대상**(인쇄상품 가격표 260527 원본 verbatim 재확인 권고·돈결함 아니나 데이터 품질).
- **fn_calc_pansu(국4절,국4절)=0 위험**: plt_siz_cd=siz_cd가 되면 pansu=0 → plate_qty None → comp "합산 제외"(0원). 설계가 표지=펼침 siz·내지=A5로 국4절≠siz를 강제하면 안전하나, **입력 가드(plt≠siz 검증) 명문화 권고**.

---

## 2. codex 신규 적발 (Claude 1차서 미부각·라이브 확증)

### 2.1 ★codex 신규 #1 — 표지 구성원 qty=copies 확장 미보장 (조건부 돈 크리티컬)
- **codex 주장**: B.1 표지 구성원 `sub_prd_qty=1` + A.4 manual 모드 `eff_qty = qty if qty not in (None,'') else copies`를 문자 그대로 보면 표지가 50이 아니라 **1로 평가될 위험**. 설계 골든 "표지 50판"은 코드 사실만으로 확정 안 됨.
- **Claude 라이브 확증**: 코드 사실 = 뷰가 sets.sub_prd_qty(1)를 `dflt_qty`로 **메타에만** 노출(price_views.py:1548), 실제 평가 qty는 클라이언트가 보내는 `members[].qty`/`qty_mode`에 의존. manual 모드서 클라이언트가 표지 qty를 **비워야**(None) copies(50)로 확장됨. 만약 클라이언트가 dflt_qty=1을 그대로 보내면 표지 전체가 ~1/50 과소청구.
- **판정**: **codex 적발 타당** — 설계 문서 §2.1은 "표지 manual·qty=copies"라 단정했으나 코드는 "qty 미전달 시에만 copies". → **뷰 조립 계약 명문화 필요**(클라이언트가 표지/면지 manual 구성원에 qty를 실지 말 것·또는 sub_prd_qty의 곱 의미 정의). 미명문화 시 표지 과소청구 잔존 위험. → **CFM-COVER-QTY 신규** 라우팅.

### 2.2 codex 신규 #2 — 내지종이 mat_cd 주입 갭
- **codex 주장**: 내지용지 단가가 사실 목록에서 불명. 072 materials는 표지전용(MAT_000246)+면지색(001/2/3)뿐.
- **Claude 라이브 확증**: COMP_PAPER 국4절에 내지종이 후보 단가행 다수(MAT_000072~MAT_000109 등) **실재**(단가 있음). 그러나 **072 t_prd_product_materials에 내지종이 mat 미등록** → 본체 PRF_HC_BODY의 내지용지 comp가 set_selections.mat_cd로 무슨 코드를 받는지 불명. 내지종이가 본체 sizes/materials에 없으면 사용자 선택지·selections 주입 경로 부재.
- **판정**: **codex 적발 타당** — 내지종이 mat이 072 본체에 등록돼야(또는 내지 구성원 승격 시 내지 반제품에 등록) selections 주입 가능. → **CFM-INNER-PAPER-MAT 신규** 라우팅(내지=별도 구성원 승격 시 함께 해소).

### 2.3 codex 보수성 해소 — 표지 50tier
- **codex 주장**: 표지 S1 50tier=550이 B.5에 미표시라 불확실.
- **Claude 확증**: S1 국4절 POPT_000002 min_qty=50 unit=**550** 실재(이전 추출이 LIMIT 12로 잘렸을 뿐). → 설계 골든 표지 인쇄 550×50=27,500 **정확**. codex 보수적 불확실은 표시 잘림 탓·기각.

---

## 3. 불일치 (Claude↔codex 상이) — 없음

- 실질 불일치 0. codex 부분동의/조건부동의는 전부 "추가 확인 필요" 류였고, Claude 라이브 확증으로 수렴(부작용0 확증·50tier 확증·표지qty 갭 확증). codex의 NO-GO와 게이트(Claude S 게이트) 방향 일치 예상.

---

## 4. 내지 승격 동의 / 바인딩 보류 동의 (지시 항목 응답)

- **내지 승격 동의**: ✅ **동의**(codex·Claude·설계자 3자 합의). 내지=본체 통합 구조로는 페이지 곱 표현 불가가 코드 사실로 확정. 정석=내지 SEMI_ROLE.01 구성원 승격(뷰 derive_inner_sheets) + 본체 공식 제본/조립만. 단 **내지 반제품 신규 등록·sets 행 추가는 dbmap 위임·인간 승인**(set-designer search-before-mint 범위 밖·BLOCKED).
- **바인딩 보류 동의**: ✅ **동의**. 072→PRF_HC_BODY(내지 포함) 바인딩은 CFM-INNER-TOTSHEET 미해소 시 **보류**가 정당(돈 크리티컬 과소청구 가드). 표지 073→PRF_HC_COVER도 CFM-COVER-QTY(표지 qty=copies 계약)·CFM-COVER-SPREAD-SIZ 선결 전 보류 권고. → apply.sql의 바인딩 [3] 주석 처리 유지가 옳음.

---

## 5. 실무진 CFM 보고 (확증 후 잔여)

| ID | 항목 | 상태 | 돈영향 | 라우팅 |
|---|---|---|---|---|
| **CFM-INNER-TOTSHEET** | 내지=본체 통합→페이지 곱 누락 | 🔴 확정 결함 | 내지인쇄 ~1/96 과소청구 | 내지 SEMI_ROLE.01 구성원 승격(dbmap·내지 반제품+sets행·인간 승인) → 본체는 제본만 |
| **CFM-COVER-QTY**(codex 신규) | 표지 구성원 qty=copies 확장 미보장 | 🟡 조건부 결함 | 표지 ~1/50 과소청구 위험 | 뷰 조립 계약 명문화(manual 구성원 qty 미전달=copies) or 위젯 계약 확정 |
| **CFM-INNER-PAPER-MAT**(codex 신규) | 내지종이 mat 072 미등록 | 🟡 갭 | 내지용지 selections 주입 불가 | 내지 구성원 승격 시 내지 반제품에 mat 등록(dbmap) |
| **CFM-S2-REVIVE** | S2 부활 del_yn Y→N | 🟢 안전 확증 | 양면 정확청구 | dbmap(인간 승인 UPDATE)·전역 참조 0 확증 |
| **CFM-INNER-PLATE** | 내지 판형=국4절 주입 | 🟡 CONFIRM | 내지인쇄 0원 가드 | set_selections.plt_siz=국4절 or 072 plate_sizes 추가 |
| **CFM-COVER-SPREAD-SIZ** | 표지 펼침 siz 코드 | 🟡 CONFIRM | 표지 pansu=1 정합 | dbmap siz 신설(임시 SIZ_000326 근사) |
| **CFM-PANSU-PLT-EQ-SIZ**(codex 신규 가드) | plt_siz=siz_cd→pansu=0→0원 제외 | 🟡 가드 | comp 견적불가 | 입력 가드(plt≠siz 검증) |
| **S2 tier 비단조** | 10:1600·15:1800·20:1700 | 🟡 데이터 품질 | 0(13판=10tier 정확) | 가격표 260527 verbatim 재확인 |
| **CFM-COVER-A4PLT** | A4 표지 3절 절가 | 🔴 BLOCKED | A4 표지용지 미산출 | dbmap(아트150 3절 89.54 적재) |
| 제본 9000×50 | false-positive | 🟢 정상 | 0 | (자기의심 표기 불필요) |
| 표지 50tier=550 | codex 보수성 | 🟢 확증 정확 | 0 | (표시 잘림 탓) |

---

## 6. 종합 판정 (codex 독립 + Claude reconcile)

- **codex 독립 = NO-GO**. Claude 라이브 확증 = **수렴(NO-GO 지지)**.
- **돈 크리티컬 미해소 2건**: ① CFM-INNER-TOTSHEET(내지 과소청구·확정) ② CFM-COVER-QTY(표지 qty 확장·조건부·codex 신규).
- **GO 조건**(codex 제시 + Claude 확증):
  1. 내지를 별도 SEMI_ROLE.01 구성원 승격 + derived qty(뷰 derive_inner_sheets) — dbmap·인간 승인.
  2. 072 본체 공식은 제본/조립만 잔류(내지인쇄·내지용지 제거).
  3. 표지 구성원 qty=copies 확장 보장(뷰/위젯 조립 계약 명문화).
  4. 내지 판형=국4절·내지종이 mat 주입 경로 확정(CFM-INNER-PLATE·CFM-INNER-PAPER-MAT).
  5. S2 부활(확증 안전)·표지 펼침 siz(CFM-COVER-SPREAD-SIZ) 선결.
- **set-designer 보정 라우팅**: PRF_HC_BODY를 "제본만"으로 재설계 + 내지 구성원 공식 PRF_HC_INNER 신설 설계(내지 반제품 등록은 dbmap BLOCKED). 표지 qty 계약 명문화.
- **게이트(S 게이트)**: 본 reconcile 큐를 라이브 evaluate_set_price 실재계산으로 최종 판정. 미해소분은 set-designer 보정.

> ★ 본 산출은 검증/reconcile까지. 실 COMMIT/UPDATE/INSERT·내지 반제품 mint·바인딩 해제는 인간 승인 후 dbmap/hsp-load-executor 위임. codex 주장은 전부 라이브 확증을 거쳐 사실/기각 분류함(환각 가드).

## 7. 출처
- codex: gpt-5.5 reasoning=high `-s read-only` session 019efe27-87df · 입력=Claude 판정 비노출·라이브 사실+코드모델만.
- Claude 라이브 확증(2026-06-25 읽기전용 SELECT): formula_components S2 참조 0행·S1 참조 6(PRF_DGP_A~F)·표지 S1 국4절 POPT_000002 50tier=550·COMP_PAPER 내지종이 단가행 다수·072 materials에 내지종이 mat 미등록·뷰 manual eff_qty 코드(price_views.py:1714~1721)·dflt_qty=sub_prd_qty 메타노출(1548).
- 설계: hc072-set-hybrid-design.md·price-pilot-hc072-hybrid/(apply.sql·s2_revive.sql·blocked-board.csv). 코드: pricing.py:718/702/551·price_views.py:1501/1649.
