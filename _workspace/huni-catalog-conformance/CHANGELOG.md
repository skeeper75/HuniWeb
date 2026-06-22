# Huni-Catalog-Conformance — CHANGELOG

전 상품 12축 + 가격엔진이 두 권위 엑셀(상품마스터 260610·인쇄상품 가격표 260527)과 일치하는지
누락 0으로 종단 정합 검증 + 교정 명세. 최신 항목이 맨 위.

---

## 2026-06-23 (4) — 교정 실행 단계 진입: K6 PASS + R-GP4-1 굿즈 base 라이브 COMMIT

검증 종료 후 인간 승인(굿즈 GP-1만 먼저)으로 교정 실행 시작.

**K6 해소(전 5배치 BLOCKED→PASS):** `.env.local` 자격증명 갱신 → product-viewer
gstack 로그인 SUCCESS(이전 stale 판정은 당시 `.env.local` 값 오류였음). 화면축 3원 대조 8상품 불일치 0·과대청구
교정분(027 접지·094 엽서북) silent-sum 차단이 화면에 반영 확인. 종합 verdict 불변(화면축이 역전 없이
독립 재확인). 산출=`06_gate/k6-screen-recheck-260623.md`+captures.

**R-GP4-1 굿즈 GP-1 base 라이브 COMMIT(되돌리지 말 것):** 단일고정가 26행 `t_prd_product_prices`
INSERT(상품마스터 C열 단가 verbatim). 견적 0→정상 실증(카드거울 qty10=25,000·캔버스 qty3=174,000·
말랑포카 qty10=140,000). DRY-RUN PASS·멱등(PK prd_cd+apply_ymd·ON CONFLICT DO NOTHING)·물리
백업·undo 보유(`09_load/_gp1_base_260623/`). 기초코드 마스터 무접촉·단가 0변경·search-before-mint.

★로드 실행기 독립 적발: 반팔티(PRD_000206)·후드티(PRD_000209)가 checklist 옵션그룹=N 오분류였으나
엑셀 권위에 색상×사이즈 variant 존재 → **G-GP-5 위반 위험**(product_prices 선점=FORMULA 영영 우회)으로
적재 보류·R-GP4-5 라우팅. 적재 26 / 보류 2.

**잔여 교정(미실행):** 실사 A-프리셋 R-B3-PRICE(arbiter 모델정립)·아크릴20 R-B3-1(Q-ACR-MISSING20)·
GP-2 FORMULA R-GP4-5·R-GP4-2~4·CPQ MISS — 전부 모델정립/CONFIRM 선행.

---

## 2026-06-23 (3) — ★전 카탈로그 11시트 종단 완료 + 배치4(goods-pouch 98 prd) CONDITIONAL GO

마지막 잔여 시트 goods-pouch 종단 → **전 11시트 종단 정합 검증 완료**. checklist 누계 3,198 데이터행·
246 prd·16 그룹·**빈 셀 0**(누락 0 완주). 동형 7클래스 압축으로 103상품 토큰 효율 처리.

**배치4 결과:**
- Phase 1: 라이브 98 prd(PRD_000183~280, 엑셀 103 중 폰케이스 5 미등록). 동형 7클래스 전부 고정가형.
- Phase 2 인스펙터: basedata 784셀(MISSING 240·자재 MISMATCH 76 오염·판형 EXTRA 85·도수 MISSING 98·
  돈크리 0)·cpq-link 392셀(MISSING 77·DEAD_LINK 0·전 CPQ 테이블 0행)·price-engine 98셀(MISSING_BIND 93·
  NO_AUTHORITY 5 권위공란·신규 ACR 할인 오귀속 1).
- Phase 3 codex(gpt-5.5 high): 합의 6·불일치 0·신규발굴 1(discount 82 FK/del_yn 무결성)·환각 0.
- Phase 4 게이트: K1~K5·K7·K8 PASS·**K6 BLOCKED(HUNI_ADMIN_PW 5연속 stale)** → **CONDITIONAL GO**.

**게이트 codex 큐 해소(생성≠검증):** ★자재 "100% 오염" 가설 기각 — PRD_000230 `레더|L|M`(본체소재+옵션값
공존)이라 교정은 **행 단위**(레더 잔류·옵션값만 이관). discount FK 전건 해소(유일 결함=PRD_000203
DSC_ACR_QTY 오귀속). 단가행 유일성은 base 0이라 적재명세 가드(G-GP-6)로 이월.

**핵심 결함:** 바인딩 0/98 = 가격 산출 불가(견적 0원·최대 결함·D-GP4-BIND). 판형 85 EXTRA(굿즈=전지없음·
round-22 잔재). 자재 76 오염·묶음수 64 MISSING(구수 materials 오적재)·CPQ MISSING 77. NO_AUTHORITY 5는
결함 아닌 권위 공란.

**인간 승인 큐:** 클래스 A=R-GP4-1(GP-1 base 적재·1순위·98상품 견적0 해소)·R-GP4-2(ACR 재바인딩)·
R-GP4-3(판형 정리)·R-GP4-4(자재 행단위 정규화) / 클래스 B=GP-2 FORMULA·가공·구수·CPQ77.

### ★전 11시트 종합 (`06_gate/conformance-final-summary.md`)
- 시트별 verdict: 디지털·배치1·2·3 = NO-GO(라이브 권위 미달=round-13 역전)·배치4 = CONDITIONAL GO.
- 과대청구 8건 전부 라이브 COMMIT 차단 완료(되돌리지 말 것). 미검증이던 4시트 종단 결과 신규 과대청구
  1건(배치3 실사 A-프리셋·게이트 적발·미적재라 미COMMIT).
- 생성≠검증 입증 누적: 배치2 094 양방향·배치3 실사 A1+8,000·배치4 자재100%오염 기각.
- **실 COMMIT 0**(전 교정 인간 승인 후 dbmap 위임). 검증 단계 종료 → 교정 실행 단계.
- 유일 미해소: K6 product-viewer(HUNI_ADMIN_PW 5연속 stale·갱신 후 전 배치 일괄 재실행).

---

## 2026-06-23 (2) — 배치3 (sticker·acrylic·silsa, 라이브 65 prd) 종단 완료·NO-GO

미검증 4시트 중 3시트 동형 파이프라인 완주(잔여=goods-pouch 배치4). checklist +845행(누계 1,924
데이터행). 모집단=라이브 prd_nm 1:1 실측(엑셀 66 중 실사 투명포스터 1 미등록=CONFIRM).

**Phase 결과:**
- Phase 1 권위: 바인딩 45/65=69%(§18 가격엔진 설계가 라이브 적재된 결과·배치2 5/34 대비 급상승).
  판별차원 명시(스티커=소재×사이즈×수량 단면=NULL 안전 / 실사=소재별 1:1+면적매트릭스 / 아크릴=두께/색×가공×조각수).
- Phase 2 인스펙터 3병렬: basedata 520셀(MISSING 4=아크릴 부속물 부착공정 누락 148/149/152/154)·
  cpq-link 260셀(MISSING 76·MISMATCH 2·옵션→차원 100% 해소·DEAD_LINK 0)·price-engine 65셀(BOUND 45·
  MISSING_BIND 20=아크릴 147~166·NULL_WILDCARD 0).
- Phase 3 codex(gpt-5.5 high): 합의 6·불일치 0·신규발굴 0·false-positive 0·환각 0. 신규 가설 2건 게이트로.
- Phase 4 게이트 K1~K8: **K4 FAIL → NO-GO**. K6 BLOCKED(PW 3연속 stale)→CONDITIONAL.

**★게이트 신규발굴(생성≠검증 입증·돈크리티컬):**
- 인스펙터·codex 모두 "과대청구 0/조건부 보류"로 봤으나, 게이트가 evaluate_price ceiling 재계산으로
  **실사 면적그리드 A-사이즈 과대청구 확정 적발** — 실사 118/120/121/123 ×3프리셋. A3/A2 +5,000,
  **A1 +8,000(594<600 off-grid)은 generation-side가 "A1=on-grid"로 오판해 놓친 신규 결함**.
  근본=A3/A2/A1 고정가 프리셋행(7000/7000/12000) 미적재(사용자입력 ≥600 연속티어만 평면화 적재).
- codex 가설 H1(스티커 tuple 중복)·H2(실사 formula_components 중복) 라이브 GROUP BY=전부 0 기각.

**핵심 결함:** ①실사 A-사이즈 과대청구(R-B3-PRICE·돈크리·클래스 B 4상품 공유 comp) ②아크릴 147~166
20 미바인딩=가격0 견적불가(R-B3-1·G-4 끊김 라이브 재현) ③부속물 BUNDLE 부착공정 4(R-B3-BUNDLE)
④CPQ MISSING 76·MISMATCH 2(거치대 비대칭·고리 sel_typ NULL)·EXTRA 1(TMPL-000013 테스트 잔재).

**실 COMMIT 0**(인간 승인 후 dbmap 위임). 인간승인큐: R-B3-PRICE > R-B3-1 > R-B3-BUNDLE > CPQ 클래스 A.
산출=`06_gate/{conformance-verdict,e2e-golden-trace,remediation-spec}-batch3.md`·`_meta/batch-progress-260622.md`.

---

## 2026-06-22 (2) — 019 첫 교정 라이브 COMMIT (클래스 A·directive 준수·되돌리지 말 것)

사용자 directive "기초코드 미수정·상품별 구성요소만"으로 교정 명세 재분류 → 클래스 A(상품별 9)/
클래스 B(공유 마스터 수정 필요·보류 5). 최대 돈결함(명함 D-A/D-B·미바인딩)은 공유 공식 영역이라
**클래스 B 보류**(directive 엄수·추후 §18에서 공유 공식 재설계로). 클래스 A 중 019만 교정 실행.

**019 투명엽서 묶음 교정 (라이브 COMMIT 완료·되돌리지 말 것):**
- **A5-plate**: 출력판형 SIZ_000522(315x467 오적재) → **SIZ_000499(316x467, 사용자 확정)** 멱등 UPDATE.
- **A2-bind**: PRD_000019 ↔ **PRF_DGP_A** 바인딩 UPSERT(@2026-06-01).
- 효과: 가격 **0원 차단 → 77,064원**(대표 골든 qty100·단면·MAT_000074·무광). 형제 016/017/018 동일 경로 합류.
- **directive 준수**: `t_prd_product_plate_sizes`·`t_prd_product_price_formulas` 019 2행만 접근. 공유 마스터(t_siz_sizes·t_prc_* 공식/comp/단가행) 무수정·신규 mint 0.
- 검증 체인(생성≠검증): load-builder DRY-RUN(목표 미달 적발→판형 정정 동반 필요 분리) → dbm-validator R1~R6 GO(77,064 독립 재계산) → 사용자 승인 → COMMIT → 독립 사후검증 PASS(영속·부작용0·멱등).
- 잔여: 025/039 동형 판형(권위 확인 후 별도)·019 완성품치수 혼입 EXTRA 정리.

산출: `06_gate/remediation/019-bind/`(apply.sql·apply.sh·preflight·dryrun-log·validation-verdict·postcommit-verify).

---

## 2026-06-22 — 하네스 초기 구성 + 디지털인쇄 첫 종단 실행 (NO-GO)

### 하네스 구성
- 6 에이전트(`hcc-authority-curator`→`hcc-basedata-inspector`·`hcc-cpq-link-inspector`·
  `hcc-price-engine-inspector` 팬아웃→`hcc-codex-verifier` 독립 2차→`hcc-conformance-gate` K1~K8).
- 6 스킬(hcc-* 5 + orchestrator). codex 교차는 `hqv-codex-cross-verify` 재사용. CLAUDE.md §21.

### 첫 실행: 디지털인쇄 36상품(PRD_000016~051) 종단 정합 검증
- **Phase 1 큐레이션**: 36상품 × 13축 = 468셀 체크리스트(누락 0의 자)·domain-lens·reuse-map.
  기존 산출물 재사용(조사 반복 0). CONFIRM 큐 4건. frm_cd 미바인딩 10건 단서.
- **Phase 2 인스펙터 3 병렬**: 468셀 전수 채움(빈 셀 0).
  - basedata 288셀: MATCH158·N/A85·MISSING31·MISMATCH9·EXTRA2·CONFIRM3. 별색인쇄 미적재·판형 오매칭·자재 미적재.
  - cpq-link 144셀: MATCH15·MISMATCH2·MISSING73·N/A54. **옵션→차원 264/264 해소(DEAD_LINK 0)**·템플릿→추가상품 5/5. 갭=광범위 미적재. cpq-schema.md stale 정정(옵션 대량 적재됨).
  - price-engine 36셀: MATCH23·MISMATCH3·MISSING10. frm_cd 미바인딩 10 확정(단서 1:1).
- **Phase 3 codex 교차**(gpt-5.5 가용·환각 0): 합의 7·불일치 5·codex 신규 2. codex가 false-positive 후보 3건(포토카드 별색 과판정·constraints 34 근거 부족·페이지룰 강등)·놓친 결함 N2 적발.
- **Phase 4 게이트 K1~K8 → 종합 NO-GO**:
  - K1 PASS(누락 0) · K2 PASS(결함 입증) · K3 PASS(연결 무결) · **K4 FAIL** · **K5 FAIL** · K6 BLOCKED(gstack 로그인 인증 실패) · K7 PASS(codex 큐 미해결 0) · K8 PASS.
  - 게이트 독자 적발(생성≠검증 작동): D-B 이중합산 진원=STD use_dims에 print_opt_cd 부재·COMP_PRINT 키=plt_siz_cd·constraint_json 캐시 라이브 부재·032 MAT_000081 STD 행 부재로 0원.

### 돈 크리티컬 결함 (교정 명세 9항목·전부 인간 승인 큐)
- **R1 명함 D-A/D-B** — 이중합산 과대(+280K)·미충전 과소(−550K). use_dims에 print_opt_cd 등재 선행. → dbm-price-arbiter→dbm-load-execution
- **R2 미바인딩 10상품** — 견적 0원 차단. 공식 신설+바인딩(comp orphan 실재). → dbm-load-execution
- **R4 COMP_COAT_GLOSSY 0행** — 유광 과소.

### 블로커 / 다음 시작점
- **K6 gstack BLOCKED**: `.env.local HUNI_ADMIN_PW`·CLAUDE.md "[REDACTED]" 모두 라이브 인증 불일치. **유효 PW 갱신 후 product-viewer 3원 대조 재실행** 필요(추측 로그인 금지).
- 교정 실행(R1~R9)은 인간 승인 후 dbmap 트랙 위임(본 하네스는 검증+명세까지).
- 전 상품 확장: 동일 자(尺)로 나머지 10시트 전파 가능(디지털인쇄 파일럿 완주).

### 산출물 루트
`_workspace/huni-catalog-conformance/`(01_authority·02_basedata·03_cpq_link·04_price_engine·05_codex·06_gate).
종합 판정=`06_gate/conformance-verdict.md`·교정 명세=`06_gate/remediation-spec.md`·종단 추적=`06_gate/e2e-golden-trace.md`.
