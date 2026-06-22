# codex-reconcile-batch4.md — 배치4(굿즈파우치) codex 독립 2차 교차검증

> **Phase 6.5 — hcc-codex-verifier** · 2026-06-23 · §21 배치4(goods-pouch 98 prd PRD_000183~280)
> codex(gpt-5.5·reasoning effort=high·`-s read-only`) 독립 2nd opinion ↔ 3 인스펙터 결함 보드 reconcile.
> ★독립성: codex에 Claude 인스펙터의 GO/NO-GO·verdict 결론 비노출(원시 신호·권위·검토질문만 work-spec 제시).
> ★환각 경계[HARD]: codex 주장=가설(라이브/권위 검증 전 사실 아님). codex 인용 근거 전건 캐시 대조 완료(날조 0).
> 입력: `codex-prompt-batch4.txt` / 원문: `codex-raw-batch4/codex-output.txt`(비밀값 비노출 확인·env값 0).

## 0. 가용성·요약

- **codex 가용** (preflight=AVAILABLE model=gpt-5.5·exit 0·effort=high). 폴백 불필요.
- **합의 6 · 불일치 0 · codex 신규발굴(인스펙터 미보드化) 1 · false-positive 적발 0 · codex 신규 가설(hypothesis) 2.**
- codex가 인용한 모든 코드·치수·prd_cd(plate output_paper_typ_cd=NULL·materials 2구/3구/4구·단면/양면·PRD_000203 DSC_ACR_QTY·
  4종 할인 구간·67 option_group·5 addon)는 **인스펙터 셀/보드 캐시에 실재**(대조 완료). codex 환각 0.

## 1. 쟁점별 reconcile

### 쟁점1 — ★판형 85 EXTRA (배치4 최중점 / C-GP-3)

| Claude 인스펙터 | codex 독립 판정 | 합의/불일치 | 근거 실재성 |
|----------------|----------------|------------|-----------|
| **EXTRA 확정** — 122행 전부 output_paper_typ_cd=NULL·siz_cd=작업/재단사이즈. 굿즈=전지 없음 → plate→sizes 이관/삭제 | **EXTRA** — 완제 굿즈는 출력용지규격 축 아님·NULL output_paper_typ_cd로 plate selector 결정력 없음 → 부당 잔재 적재 | **합의(완전 일치)** | ✅ basedata 셀 verdict=EXTRA 정확히 85건·다른 EXTRA 0 |
- **합의·고신뢰**. codex가 정당성 반론(작업/재단 사이즈로 정당한가?)을 명시 검토 후 **EXTRA로 독립 비준** — 인스펙터 잉여 적재 판정 교차 입증.
- codex 결정체크: "권위 엑셀에 상품별 출력용지/전지 선택축이 명시·엔진이 plate selector로 소비하는지" → 없으면 전건 EXTRA. 게이트 K1/K2가 흡수.

### 쟁점2 — ★자재 76 MISMATCH (자재축 오염 / false-positive 의심면)

| Claude 인스펙터 | codex 독립 판정 | 합의/불일치 | 근거 실재성 |
|----------------|----------------|------------|-----------|
| **MISMATCH** — 옵션값(사이즈등급/면/구수/색)이 본체소재로 혼입·정답=본체소재만 | **genuine mis-load** — 2구/3구/4구=수량·단면/양면=면수·블랙M/화이트L=색+사이즈, 본체소재 아님 | **합의** | ✅ PRD_000202/206/220 materials 셀 실재 |
- **false-positive 아님** 양자 합의 — codex도 "옵션값이 material axis 오염=실결함"으로 동의. 정당한 본체소재(레더/캔버스/타이벡/메쉬)만 USAGE.07 잔류.
- **★codex HYPOTHESIS 표기 1건**: "76건 전수 원문 미확인 → 76 전부 100% 오염 단정 불가, 제공 예시는 명백 오염". → **게이트 라이브 재실측 큐**(76 prd materials 전수 GROUP BY 후 본체소재 vs 옵션값 분류 — 일부가 진짜 본체소재면 MISMATCH 건수 하향). 사실 채택 보류.

### 쟁점3 — ★바인딩 0/98 전건 미바인딩 (결함 vs 굿즈 의도 / D-GP4-BIND)

| Claude 인스펙터 | codex 독립 판정 | 합의/불일치 | 근거 실재성 |
|----------------|----------------|------------|-----------|
| **MISSING_BIND=차단**(source=NONE·견적0). 단 검사오류 아닌 needed=Y 미충족(round-13 역전). NOPRICE 5=NO_AUTHORITY 별개 | **DEFECT** — formula·product_prices 둘다 없으면 source=NONE·base 산출 불가·견적 0원. NOPRICE 5는 권위문서로 미출시/별도견적 확정 전 HYPOTHESIS | **합의(+ 결정체크 보강)** | ✅ price-engine 셀 formula0·pp0 전건 실재 |
- **합의·고신뢰**. codex가 "굿즈 의도(고정가 미적재)" 가능성을 검토 후 **결함으로 독립 판정** — 단, 결정체크를 인스펙터와 동일하게 명시(단일가→product_prices·variant가→formula). 굿즈라서 0원이 정상이라는 반론 **기각**.
- **codex가 NOPRICE 5를 HYPOTHESIS로 격리** — 인스펙터의 C-GP-2(NO_AUTHORITY·인간 확정)와 정확히 합치. 가격표260527 별도 존재여부 인간 확정 라우팅 비준.

### 쟁점4 — 신규 적발 2건 실재성 (D-GP4-ACR-MISBIND / D-GP4-DSC-ORPHAN)

| 항목 | Claude 인스펙터 | codex 독립 | 합의 | 근거 실재성 |
|------|----------------|-----------|------|-----------|
| **(a) PRD_000203 DSC_ACR_QTY 오귀속** | 굿즈에 아크릴 할인타입 오바인딩·잠재 오청구(base 적재 시 아크릴 구간율 적용) | **실결함 가능성 높음**·도메인 불일치. 현재 inert(base 0)·가격 붙으면 할인율 오적용 실금액 영향 | **합의** | ✅ price 셀 PRD_000203 live_discount_table=DSC_ACR_QTY 실재 |
| **(b) 82 discount 고아** | base 0이라 할인 곱할 대상 없음·base 적재 시 자동 해소 | **real finding**·inert/orphan. 단 본 결함은 "할인 미적용"이 아니라 "기본가 부재로 전체 견적 0" | **합의** | ✅ 82 바인딩·formula/pp 0 실재 |
- **양자 합의**. (a) codex 결정체크: "권위 가격표에서 LED투명키캡키링 할인구간이 DSC_ACR_QTY와 동일한지" → 게이트 K4가 권위 대조. (b) codex가 위계 정정(고아의 본질=base 부재의 종속 증상)을 명시 — 인스펙터 "D-GP4-BIND와 동반 해소"와 합치.

### 쟁점5 — ★적재 후 과대청구 가드 충분성 (GP-2 판별차원 설계)

| Claude 인스펙터 | codex 독립 | 합의/불일치 | 근거 실재성 |
|----------------|-----------|------------|-----------|
| GP-2-SIZE `[siz_cd]`·GP-2-VAR `[opt_cd]` 처방 정합 ✅·**단 적재 시** PRODUCT_PRICE 선점 가드(G-GP-5)·평탄화 가드 필요. GP-PROC/GP-COUNT는 Q-GP-FIN1/C-GP-5 미해소 ⚠ | **`[siz_cd]/[opt_cd]` 설계만으론 불충분**·방향은 맞으나 load-time 검증 필수: ① GP-2에 product_prices 0행 ② discriminator 전 단가행 NOT NULL ③ 동일 discriminator당 단가행 유일성 | **합의(+ 결정체크 추가)** | ✅ §18 처방·골든 캐시 대조 |
- **합의**. codex가 인스펙터 가드(선점·평탄화)에 더해 **단가행 유일성 체크(③)를 독립 추가** — 배치3에서도 동일 가설(tuple 중복)을 제기한 것과 동형. 적재 명세 검증의 새 체크포인트로 흡수.
- codex blind-spot 경고(GP-PROC 개당vs1회·GP-COUNT 가격축 여부)는 인스펙터 Q-GP-FIN1·C-GP-5와 정확히 동일 — 양자 "미해소·arbiter 선행" 합치.

## 2. codex 추가 발굴 (인스펙터 보드 대비)

| 항목 | codex 판정 | 인스펙터 보드 대조 | 결론 |
|------|-----------|-------------------|------|
| **단가행 discriminator 유일성**(같은 siz_cd/opt_cd 중복 단가행=중복 합산 위험) | 적재 시 필수 체크 | 인스펙터 GP-2 판별차원 충전만 명시·**유일성 미명시** | **신규 가설(hypothesis)** — 게이트 적재 명세 검증 큐 |
| **discount_tables FK 유효성·del/use 상태·권위 할인타입 상품별 매칭** | 미검증으로 보임 | price 셀 note에 FK/del_yn/use_yn 검사 **부재** 확인 | **★codex 신규발굴 1**(인스펙터 미보드化) — 게이트 라이브 재실측 큐 |
| sizes 11·processes 6·bundle 1 EXTRA 여부 product별 재판정 | 미검증으로 보임 | 인스펙터 셀: sizes 11=**MATCH**(검증 완료)·processes 12=MATCH·EXTRA는 판형 85뿐 | **합의(이미 검증)** — codex 우려는 "행수 요약" 한계 지적이나 셀 단위로 이미 MATCH 판정·신규 아님 |
| CPQ 67 option_group·5 addon·5 template product별 누락 리스트 | 미검증으로 보임 | 인스펙터 cpq 보드 D-GP-CPQ-1/2/3 전건 MISSING·대표 prd 명시 | **합의(이미 보드化)** |

- codex **신규 결함 발굴 1건**: discount_tables FK/del-use/권위 할인타입 매칭 무결성 — 인스펙터가 base 부재에 가려 별도 검사 안 함. **가설로 라우팅**(게이트 K4 재실측: 82 discount 바인딩의 FK 유효·del_yn=N·권위 할인타입 일치 여부).
- codex **false-positive 적발 0**(인스펙터 EXTRA/MISMATCH/MISSING 판정 모두 정당 비준).

## 3. 환각 경계 점검 (codex 주장=가설)

- codex 인용 근거 **전건 캐시 실재 대조 완료**: plate output_paper_typ_cd=NULL(basedata 셀 85 EXTRA)·materials 2구/단면/색(PRD_000202/206/220 셀)·
  PRD_000203 DSC_ACR_QTY(price 셀)·4종 할인 구간(price 보드 §5 verbatim)·67 option_group·5 addon(cpq 보드). **날조/환각 0**.
- codex가 명시적으로 **HYPOTHESIS 표기**: ① 자재 76 전수 100% 오염 단정 불가 ② NOPRICE 5 미출시/별도견적 여부 — 둘 다 사실 채택 보류·게이트 재실측/인간 확정 큐.
- codex 신규 가설 2건(단가행 유일성·discount FK 무결성)도 **사실로 채택하지 않고** 게이트 라이브 재실측 큐로 라우팅. codex의 결정체크는 게이트 검증 절차 보강으로 흡수(가설→검증 절차化).

## 4. 라우팅 종합 (게이트 K1~K8 입력)

| 항목 | reconcile 결과 | 게이트 액션 |
|------|---------------|-----------|
| 판형 85 EXTRA | 합의·고신뢰 | K1/K2 비준(EXTRA)·dbm-axis-staged-load plate→sizes 이관/삭제 |
| 자재 76 MISMATCH | 합의(+codex HYPOTHESIS) | K2 재실측: 76 prd materials 전수 본체소재 vs 옵션값 분류(일부 진짜 본체소재면 건수 하향) |
| 바인딩 0/98 차단 | 합의·고신뢰 | K6 비준(MISSING_BIND)·NOPRICE 5는 C-GP-2 인간 확정 분리 |
| D-GP4-ACR-MISBIND(PRD_000203) | 합의 | K4 권위 할인구간 대조 → 재바인딩(dbm-axis-staged-load) |
| D-GP4-DSC-ORPHAN(82) | 합의 | base 적재 동반 해소(D-GP4-BIND 종속) |
| GP-2 과대청구 가드 | 합의(+codex 유일성 체크) | K4 적재 명세 검증: ① product_prices 0 선점가드 ② discriminator NOT NULL ③ **단가행 유일성(신규)** |
| **★codex 신규 — discount FK/del-use/권위타입 무결성** | 신규발굴(가설) | **K4 라이브 재실측**: 82 discount 바인딩 FK 유효·del_yn=N·권위 할인타입 일치 — 위반 시 신규결함 승격 |
| GP-PROC 개당/1회·GP-COUNT 가격축 | 합의(미해소) | dbm-price-arbiter 심의(Q-GP-FIN1·C-GP-5) 선행 |

- 합의=고신뢰(게이트 부담 경감). 불일치=0. codex 신규발굴 1·가설 2=조사 큐(K4). 실 COMMIT/DDL은 인간 승인 후 dbmap 위임.
