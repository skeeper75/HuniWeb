# 스티커 시트 — codex 독립 2차 교차검증 reconcile

**검증 구도:** Claude inspector(생성측·`02_load/sticker-defect-board.md`·14결함) ⟂ codex gpt-5.5(독립 2차·읽기전용 high effort).
**codex 가용:** ✅ AVAILABLE (codex exec 0.x·gpt-5.5·`model_reasoning_effort=high`). "Claude 단독" 폴백 아님.
**호출 경위:** codex-review.sh의 preflight probe가 1차 데드락(40분 무응답·`reply with exactly OK` 행) → kill 후 **preflight 우회 직접 `codex exec -s read-only --skip-git-repo-check`** 1회 재시도 성공(rc=0). 재시도가 본 검증의 채택분.
**입력:** 정답 격자 1089셀(facts)·라이브 shape(관측입력)·3종 결함정의·Q1~Q7 독립질문. codex는 `-C` 루트 read-only로 워크스페이스의 prior 산출(`huni-dbmap/33_silsa-price-quote/_gate/sticker-validation-verdict.md` 등)을 **스스로 탐색**해 round-23 DRY-RUN(R1~R6·골든 6/6)을 독립 재현 — 그 자체가 강한 교차 코로보레이션. 단 그 과정에서 결함보드도 읽음(완전 블라인드 아님 — 아래 독립성 한계 명기).
**경계 [HARD]:** codex 주장=가설. NEW 후보·정합 판단은 **Claude가 정답 격자 CSV로 직접 재실측**해 확정(가설→사실). 라이브 DB 최종 확정은 integrity-gate SELECT.

---

## 0. 종합 reconcile 표

| 결함ID | 영역 | Claude inspector 판정 | codex 판정 | reconcile 결론 | 근거 |
|---|---|---|---|---|---|
| **STK-D01** | 054 홀로 mat163 전건 no_match | DEFECT·견적불가(1순위·active) | **CONFIRM defect** | **합의 (결함 확정)** | B01 grp3=mat162+mat163 **둘 다** 동일가 요구. 상품이 mat163 오퍼인데 바인딩 siz에 mat163 행 0 → exact match no_match. 단 A6(196)은 권위 부재 별건(D07) |
| **STK-D02** | 053 투명 170/196 미적재 | DEFECT·견적불가+저청구 | **부분 합의**: 170(B01 A5)=CONFIRM·196(A6)=REFUTE(권위 부재) | **합의(170)+정정(196)** | mat162 행은 B01 grp3에 필요(170 결함). 196은 authority B01 6 siz_label에 없음=미적재 결함 아님→D06과 동일 분리 |
| **STK-D03** | 052 A4 SIZ_172=4000 저청구 | DEFECT·저청구 -1000/장(돈크리티컬) | **CONFIRM defect** | **합의 (저청구 확정)** | B01 반칼 A4=A4_2판 qty1 **5000**. SIZ_172=낱장/완칼 A4 **4000** 성격. SIZ_520 분리가 root cause로 타당 |
| **STK-D04** | 052 A4 4소재 no_match | DEFECT·견적불가 | **CONFIRM (D03과 동근)** | **합의** | SIZ_172엔 153/162만 → 084/155/156/242 no_match. SIZ_520 교체로 D03·D04 동시 해소 |
| **STK-D08/09/10** | 055/056/057 자재 오바인딩(MAT154/243) | DEFECT·견적불가(신규·active) | **CONFIRM conformance mismatch** | **합의 (오바인딩 확정)** | 라이브 가격축=B02/B04 유포 **153**·B03 투명 **162**. mat154/243 행 신규 복제보다 **상품 소재 바인딩을 권위 가격축 코드로 정렬**이 정답(codex가 Claude 라우팅과 동일 결론) |
| **STK-D11/12** | 062/063 100x140 미적재 | 확인필요(권위 단가 부재) | **REFUTE as missing cell (권위 부재)** | **합의 (결함 아님·확인필요)** | SIZ_058 100x140은 authority grid에 셀 0 → 임의 적재 금지. 추측가드 유지 |
| **STK-D13** | 066 합판 6소재 중 4 no_match | DEFECT·견적불가(false-positive 가드 재판정) | **CONFIRM defect, engine caveat** | **합의 (조건부)** | exact mat_cd 매칭이면 155/156/170/171 no_match=실결함. **단 엔진에 소재→그룹대표 resolver가 있으면 false-positive** → gate가 라이브에서 resolver 유무 확인(코드 실측) |
| **STK-D05/06/07** | 052/053/054 A6 권위 부재 | 확인필요(추측 금지) | **PARTIAL REFUTE (권위 부재 확정)** | **합의** | SIZ_196 A6는 authority B01 6 siz_label 부재 → 미적재 결함 아님. 추측 적재 금지 합의 |
| **STK-D14** | 067 타투 기본가2000 | 확인필요(권위 단가 부재로 분류) | **정정: 권위 부재 아님·"값 있음·의미 미확정"** | **불일치 (분류 정정)** | ★격자 CSV에 `기본가/2000`(B80) **셀 실재**. "단가 부재"가 아니라 "기본가 vs 3장4000 관계 미확정"으로 분류 수정 |

**합의:** 돈크리티컬 결함(D01 견적불가·D03 저청구·D08/09/10 오바인딩·D04·D13) 전부 **CONFIRM**(codex가 결함 부정 0건). 확인필요(A6·100x140) 전부 **권위 부재로 합의**(과적발 아님).
**정정 2건:** ① STK-D14 타투 기본가는 "권위 단가 부재"가 아니라 "값 있음(2000)·의미 미확정" — 분류 수정. ② STK-D02의 196은 D06과 같은 권위부재 분리(170만 결함).
**과적발(false-positive):** codex가 inspector 결함 판정 중 **과적발 0건** 적발 — inspector가 미리 가드한 형상/코팅/도수NULL/addon0/동일가그룹 전부 codex도 독립적으로 정당 차이로 합의.

---

## 1. codex 신규 발굴 (inspector 놓친 gap) — Claude 재실측 확정

### NEW-1 [확정·결함] B02/B03 B4·B3 사이즈 미처리 — 결함보드 누락
- **codex 적발(HYPOTHESIS):** authority B02/B03 = `A4/B4/A3/B3/A2 × qty6`인데 결함보드는 PRD_055/056을 **172/174/197(A4/A3/A2)만** 다룸. B4/B3 누락 가능.
- **Claude 재실측(정답 격자 CSV·확정):** `awk B02 siz_label` → **{A2,A3,A4,B3,B4} 5종**·B02=30셀·B03=30셀. 결함보드 STK-D08/09는 A4/A3/A2(172/174/197)만 라우팅 → **B4/B3 2사이즈 × {유포153/투명162} × 6수량 = 24셀이 결함보드에 부재.**
- **교차 코로보레이션:** codex가 스스로 탐색한 round-23 DRY-RUN(`sticker-validation-verdict.md`)도 동일하게 **S3=SIZ_515(B4)/SIZ_514(B3) 24행 적재**를 별도 단위로 식별(채번0·즉시 GO 후보). 두 독립 경로 수렴.
- **결론:** **inspector 결함보드의 진짜 누락(coverage gap).** B4/B3는 라이브 siz(515/514) 실존·채번0 → 즉시 교정 후보. **integrity-gate가 B4/B3 라이브 적재 상태 재실측 필수.**

### NEW-2 [확정·분류정정] 타투 기본가2000 = 권위 부재 아님
- **codex 적발:** tattoo `기본가 2000`은 CSV에 authority signal 실재 → "가격 부재"가 아니라 "엔진 표현/정책 의미 미확정".
- **Claude 재실측(B80 셀·확정):** 격자에 `MAT167·기본가·2000`(B80) + `3장·4000`(B81) + `1000장·4000`(B82) 3셀 실재. **값은 권위에 있음.** 미확정은 기본가2000 vs 3장4000 합가형 환산 관계(Q-STK-1)뿐.
- **결론:** STK-D14를 "권위 단가 부재"(D05/06/07/11/12와 동류)로 묶은 inspector 분류는 부정확. **"값 존재·의미 미확정"으로 재분류** — 임의단가 금지 결론은 동일하나, gate는 2000을 "발명"이 아닌 "권위값 반영"으로 처리해야 함(별 component/최소가/base fee 중 무엇인지 컨펌).

### NEW-3 [보강·gate 검사] resolver 유무가 D13·소재전개 결함 성립의 분기점
- **codex caveat:** STK-D13(합판 4소재)·STK-D01(홀로)·소재 7전개 전부 **"엔진이 exact mat_cd 매칭이냐, 소재→그룹대표 resolver가 있느냐"** 에 결함 성립이 의존. resolver 있으면 일부가 false-positive로 뒤집힘.
- **Claude 판단:** 권위 dims [HARD]="같은 단가라도 7 mat_cd 개별 행"·라이브 use_dims=[siz_cd,mat_cd,min_qty] exact 매칭 전제 → resolver 부재가 설계 의도. 그러나 **코드 실측 전엔 가설** → **gate가 `pricing.py` match_component에서 mat_cd 정규화/그룹resolver 유무를 코드로 확정**(아크릴 reconcile의 no-swap 코드실증과 동형). resolver 부재면 D13/D01 전부 실결함 확정·있으면 D13 일부 false-positive.

### NEW-4 [가설·gate 재실측] GANGPAN 4소재 exact-row 등가 gap 규모
- **codex 적발(HYPOTHESIS):** resolver 부재 시 합판 6소재 중 4소재(155/156/170/171) exact rows 필요 = `37형상×4소재×5수량=740 row-equivalent gap`.
- **Claude 메모:** 권위는 2그룹 동일가 → 740행은 **동일단가 복제 적재**(날조0·verbatim). inspector STK-D13 라우팅("grpA→155/156·grpB→170/171 복제")과 일치하나 **규모(740)는 inspector 미명시.** gate가 복제 적재 규모로 반영.

---

## 2. codex 과적발 적발 (inspector가 결함으로 본 것 중 정당한 차이) — 0건

codex는 inspector 14결함 중 **false-positive(과적발)를 찾지 못함.** 오히려 inspector가 미리 가드한 정당 차이(반칼 형상=커팅옵션·코팅=자재variant·동일가그룹 collapse·clr_cd NULL 도수무관·addon 블록 0)를 codex가 **독립적으로 동일하게 "결함 아님"** 으로 합의 → inspector 과적발 0 확증.

단 codex가 **분류 정밀화 2건**을 적발(결함 유무는 동일·기술/분류가 부정확): ① STK-D14 타투 기본가="권위 부재"→"값 존재·의미 미확정"(NEW-2) ② STK-D02의 A6(196)은 결함이 아니라 권위부재(D06와 동일 분리). 아크릴 reconcile의 "D-04 비대칭 기술 오류"와 동형 패턴(결함 보존·서술 정정).

---

## 3. 돈영향 우선순위 — Claude·codex 합의 랭킹

| 순위 | 결함 | 영향 | 합의 |
|---|---|---|---|
| **1** | STK-D01 054 홀로 전건 no_match | 견적불가·active 상품 | ✅ |
| **2** | STK-D08/09/10 055/056/057 오바인딩 | 견적불가 전건·active(신규) | ✅ |
| **3** | STK-D03 052 A4 저청구 | -1000/장 돈크리티컬 | ✅ |
| **4** | STK-D04 052 A4 4소재 / STK-D13 합판 4소재 | 견적불가(부분 소재) | ✅(D13은 resolver 확인 조건부) |
| **5** | NEW-1 B02/B03 B4/B3 24셀 | 견적불가(B4/B3 선택 시) | ✅ 신규 |

---

## 4. integrity-gate 인계 (독립 재실측 포인트)

1. **[NEW-1·필수] B02/B03 B4(515)·B3(514) 24셀 라이브 적재 상태 재실측** — 결함보드 누락. 미적재면 견적불가(즉시 교정·채번0).
2. **[NEW-3·필수·코드트랙 분기] `pricing.py` match_component 소재 resolver 유무 코드 실측** — exact mat_cd면 D01/D13 실결함 확정·resolver 있으면 D13 일부 false-positive. 아크릴 no-swap과 동형 코드실증.
3. **[STK-D01/D08~10] evaluate_price 실호출 no_match 재현** — 홀로163·055/056/057 오바인딩.
4. **[STK-D03] evaluate_price(052,A4,mat153,qty1)=4000 재계산** 입증(정답 5000).
5. **[NEW-2] 타투 기본가2000** = 권위값 실재(B80) → 임의 발명 아님·의미(base/최소가/component) 컨펌 후 반영.
6. **[합의] A6(196)·100x140(058)** = 권위 부재 → 미적재 결함 아님 유지(추측 적재 금지).
7. **[교차 코로보레이션 활용] round-23 DRY-RUN(R1~R6·골든 6/6 PASS·405행)** = codex가 독립 재현한 기존 적재준비본 — gate가 그 골든(124x186 유포 mq3=5900·홀로163 mq1=7000·B4투명 10500)을 재실측 기준으로 재사용 가능.

---

## 5. 독립성 한계 (정직 명기)

- codex는 `-C` read-only 루트에서 **결함보드 자체도 읽음**(완전 블라인드 아님) → 일부 verdict는 Claude 보드를 관찰입력으로 본 상태. 단 codex가 **독립 발굴한 NEW-1(B4/B3)·NEW-2(기본가 값 실재)·resolver caveat**는 보드에 없던 것 → 독립 발굴 성립. 보드 의존 verdict(D01/D03 CONFIRM)는 "동의" 가중을 낮춰 해석.
- codex 1차 preflight 데드락 → 직접 호출 재시도 채택(에러 핸들링 directive 정합·1회 재시도 후 성공).
- 모든 NEW 후보는 Claude가 정답 격자 CSV로 재실측 확정(NEW-1·NEW-2)했거나 gate 코드실측 위임(NEW-3·NEW-4).

---

## 부록 — codex 호출/근거
- 프롬프트: `_sticker-codex-prompt.md` · codex stdout(최종 verdict): `/tmp/codex-sticker-out.txt`(4080B) · 탐색 트레이스(R1~R6 재현): `/tmp/codex-sticker-err.txt`(166KB).
- codex가 독립 탐색한 권위: `_workspace/huni-dbmap/33_silsa-price-quote/_gate/sticker-validation-verdict.md`(round-23 R1~R6 GO·골든 6/6·405행)·`06_extract/price-gangpan-sticker-l1.csv`.
- Claude 재실측: `sticker-authority-grid.csv` awk(B02/B03=5사이즈30셀·B80 기본가2000 셀 실재) 확정.
