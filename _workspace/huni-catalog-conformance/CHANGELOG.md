# Huni-Catalog-Conformance — CHANGELOG

전 상품 12축 + 가격엔진이 두 권위 엑셀(상품마스터 260610·인쇄상품 가격표 260527)과 일치하는지
누락 0으로 종단 정합 검증 + 교정 명세. 최신 항목이 맨 위.

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
- **K6 gstack BLOCKED**: `.env.local HUNI_ADMIN_PW`·CLAUDE.md "test1234" 모두 라이브 인증 불일치. **유효 PW 갱신 후 product-viewer 3원 대조 재실행** 필요(추측 로그인 금지).
- 교정 실행(R1~R9)은 인간 승인 후 dbmap 트랙 위임(본 하네스는 검증+명세까지).
- 전 상품 확장: 동일 자(尺)로 나머지 10시트 전파 가능(디지털인쇄 파일럿 완주).

### 산출물 루트
`_workspace/huni-catalog-conformance/`(01_authority·02_basedata·03_cpq_link·04_price_engine·05_codex·06_gate).
종합 판정=`06_gate/conformance-verdict.md`·교정 명세=`06_gate/remediation-spec.md`·종단 추적=`06_gate/e2e-golden-trace.md`.
