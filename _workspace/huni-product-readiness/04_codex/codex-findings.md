# Codex 독립 2차 교차검증 — 제기 가설 (hpr-codex-verifier)

> 검토 대상: `02_readiness/`(283상품·scorecard·4리스트)·`03_schedule/`(W0~W6·blocked).
> 근거: `01_rubric/rubric.md`·`00_spine/`. 평가일 2026-06-30.
> codex: **가용**(gpt-5.5·reasoning=high·`-s read-only`·stdin `</dev/null`·`--skip-git-repo-check`). 84,841 tokens.
> ★[HARD] 아래는 **codex 제기 가설**(라이브/권위 검증 전 사실 아님). 채택은 scorecard-gate 몫. Claude 판정 비노출로 독립 산출.

---

## Q1. 등급 과대평가 — 판정: 전역 과대평가 가설 **매우 강함** ★최중대

- 루브릭 D5 PASS = `PRICE≠0 AND 골든 정합(money_delta=0)` (rubric.md:26). L3/L4 게이트 = D5 PASS (rubric.md:50).
- codex가 scorecard.csv 283행 재집계: **L3/L4 = 83건**(L3 69 + L4 14).
  - 근거에 `PR=`/`money_delta`/`golden`/`골든` 있는 건 = **0/83**
  - `calc=OK`만 = **80/83**, 나머지 3은 `calc=PRICED-완제품가`뿐(골든 비교 증거 없음: PRD_000097·094·072)
- **결론(가설):** 파일 근거만 보면 83건 전부 D5 PASS가 아니라 **D5=WARN 후보**(PRICE≠0이나 골든 미대조=조사신호). 루브릭대로면 L3/L4가 아니라 최소 **L2/L2+ cap**.
- 대표 모순: PRD_000020(L3·calc=OK뿐·D11 FAIL)·PRD_000042(동)·PRD_000174/175(L4인데 pfm=DESIGNED_NOT_LOADED·골든 없음).
- L4 14건 전부 골든 근거 없음: 147·148·149·150·152·154·172·173·174·175·176·178·179·181.

## Q2. 구성요소 silent 합산 — 판정: 7 FAIL 대체로 타당 / WARN-12 중 3건 재승격 후보

- **7 FAIL 중 실제 현재가격에 닿는(calc=OK + frm bound) = 3건**: PRD_000020·042·047. → 지금 과청구 위험.
- 나머지 4 FAIL = "바인딩/축 해소 시 과금 위험"(현재 미과금): 034·037·048(UNSCORED-축미탑재)·040(UNBOUND-NO-PRICE).
- **WARN-12 → 돈크리티컬 재승격 후보 3 (calc=OK라 현재 과청구 가능)**:
  - PRD_000138 일반현수막(양면테입/설치용끈/큐방/각목/봉제사·OC=67)
  - PRD_000139 메쉬현수막(설치용끈·OC=50)
  - PRD_000136 PET배너(우드거치대·OC=50) — "본체포함 vs addon" 권위 확인 필요
- **반대로 자기부품 WARN 타당(codex 동의=오염 아님)**: 050 봉투제작(레자크지=봉투용지)·071 트윈링책자(링/투명커버=제본부품)·153 골드/실버 아크릴(재질옵션)·174/175 레더(커버재질). → 이들의 본 문제는 D11이 아니라 D5/라이브 적재 모순.

## Q3. 판형/종이류 — 판정: 25건 리스트 대체로 합리 / "23 WARN=공식 바인딩 후 보류" 설명은 **과하게 느슨**

- 확정 결함 후보: PRD_000051 썬캡(PRICED-0 + D10 FAIL)·미등록 링바인더(FAIL) = 타당.
- 다만 23 WARN 중 상당수는 "공식 미바인딩"이 아니라 **`UNSCORED-축미탑재`(공식 이미 보임)** — 031/032/033/034 명함·037·048·068~071 책자·050 봉투. → "나중에 공식 바인딩 후"가 아니라 **지금 직접 simulate로 best-plate=0 여부 확인해야 하는 후보**.
- 종이류 플래그 의심:
  - PRD_000066 합판도무송스티커(종이류=Y·D10 WARN·OFFGRID): 스티커 고정가 모델이면 **판형 요구가 false-positive 가능**.
  - 반대로 PRD_000019 투명엽서·025 투명포토카드·039 투명명함(종이류=N·D10 N/A): 생산상 판형 쓰는 투명 소재라면 **missed D10 가능**(파일만으론 확정 불가).

## Q4. 위젯 선행조건 누수 — 판정: PRICED-0 6건 누수 없음 / D11 돈크리티컬 3건 **W2 누수 가설 강함**

- PRICED-0 6건은 전부 L1/L2라 W1~W6 미진입(051·132·135=L2·077·082·088=L1) — 누수 없음(blocked-before-widget.md:45 명시).
- **그러나 silent-merge 7 중 3건(020·042·047)은 L3/W-CASCADE** → W2(W-CASCADE L3 19)에 포함. D11=FAIL인데도 D5만 보고 등급이 L3로 남아 **돈크리티컬이 위젯 wave에 누수**. 등급 게이트가 D11(돈크리티컬)을 cap하지 않는 구조적 구멍.

## Q5. 환각 PASS / false-positive — 판정: pfm=DESIGNED_NOT_LOADED·LIVE_UNBOUND ∧ D5 PASS 동시 = **환각 PASS 후보**

- 강한 후보(라이브 미적재인데 L4 100%): 만년다이어리 174/175(DESIGNED_NOT_LOADED·L4)·아크릴명찰153(DESIGNED_NOT_LOADED·L3)·아크릴 147/148/149/150/152(**LIVE_UNBOUND인데 L4 100%**).
- false-positive(codex 동의): 050·071·108/109/111/112·153·174/175 = 타 상품 오염보다 자기부품/재질/제본부품 가능성 큼 → 평가자 FP 가드가 이들엔 적절.
- 반제품/기성 100%는 L1(기성)·L2(반제품)로 남아 **W1~W6 누수 증거 파일상 없음**(평가자 정상 처리).

---

## codex Top 3 (돈크리티컬 순)
1. **전역 D5 과대평가**: L3/L4 83건 전부 골든/money_delta 증거 없음 → widget-ready 83 전체 재심 대상.
2. **돈크리티컬 silent-merge 위젯 누수**: 020·042·047 = calc=OK + D11 FAIL + L3/W-CASCADE → W2 누수.
3. **DESIGNED_NOT_LOADED/LIVE_UNBOUND ∧ L4 100% 모순**: 172/173/176/178/179/181·147/148/149/150/152/154 = "설계/미바인딩" 표식과 L4 PASS 충돌.

## codex 한계
- 파일 근거만 사용(라이브 evaluate_price 미실호출). 골든 미대조·LIVE_UNBOUND 모순은 **라이브 simulate로만 확정**.
- 투명 소재 D10 missed·OFFGRID 스티커 판형 FP는 파일만으론 확정 불가(조사 필요).
