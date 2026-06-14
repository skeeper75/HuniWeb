# PRF_BIND_SUM — remediation-plan (arbiter 정립 + BIND-C1 심의)

> 작성 2026-06-15 · round-18+ Phase 6. 입력 = [[PRF_BIND_SUM/mapping-integrity]] · PRF_DGP_A remediation(C-2 가설A 선례) · 라이브 실측(읽기전용).
> DB 미적재(심의·제안까지·실 적용 인간 승인). 신규 에이전트/스킬 신설 0(기존 자산 재배치).

---

## 1. 정립 대상

| ID | 결함 | 분류 | 무엇을 해소해야 하나 |
|---|---|---|---|
| **B-WIRE** | PRF_BIND_SUM에 중철 comp만 배선(3/4 미배선) | 🔴 BLOCKING | 무선/PUR/트윈링이 자기 제본 단가표(comp)를 엔진 경로로 합산하게 배선 |
| **B-FORMULA** | 책자4종 공유 1공식 ↔ 제본방식 상품별 1고정 미스매치 | 🔴 BLOCKING | 4 comp 동시매칭 없이 각 상품이 자기 제본방식만 쓰게 공식 모델 확정(BIND-C1) |
| **D-2** | 제본 선택→comp 멤버십 자리(.08) 부재 | 🟡 DEFERRED(횡단) | PRF_DGP_A AQ-1 가설A 승계 — 단 BIND은 A안으로 우회 가능 |
| **B-OPT-070** | PUR 옵션 레이어 0행 | 🟡 DEFERRED(L2) | round-6 L2 적재 트랙 |

> B-WIRE·B-FORMULA는 **동근**(B-FORMULA 안이 정해져야 B-WIRE 교정 형태가 확정). 따라서 BIND-C1이 핵심.

## 2. BIND-C1 심의 — 공식 모델 A안 vs B안

### A안 — 제본방식별 공식 분리 (PRF_BIND_<방식> 4공식 + 상품 1:1 정적 바인딩) **[권고]**

- **구조**: PRF_BIND_SUM(중철 전용으로 유지하거나 PRF_BIND_JUNGCHEOL로 개명) + PRF_BIND_MUSEON·PRF_BIND_PUR·PRF_BIND_TWINRING 3공식 신설. 각 공식 formula_components에 자기 제본 comp 1행만 배선. product_price_formulas 바인딩을 069→PRF_BIND_MUSEON·070→PRF_BIND_PUR·071→PRF_BIND_TWINRING으로 교정(현재 전부 PRF_BIND_SUM).
- **장점**:
  - ① **라이브 실측 ③과 정합** — 제본방식이 상품 정체(상품별 1고정)이므로 "상품→공식 1:1"이 데이터 현실 그대로. 멤버십을 정적으로 인코딩(런타임 분기 불요).
  - ② **동시매칭 0** — 각 공식에 comp 1개뿐. 4중 합산 위험 원천 제거.
  - ③ **D-2(옵션 멤버십 .08) 우회** — 한 상품 내 다중 택1이 아니므로 .08 base_code·트리거 보강 불요. BIND 범위에서 횡단 결함을 안 건드리고 닫을 수 있음.
  - ④ **그릇 기존** — t_prc_price_formulas는 frm_cd/frm_nm/note/use_yn뿐(라이브 실측). 신규 공식 3행 INSERT + formula_components 3행 + 바인딩 update 3행. DDL 0(테이블 구조 불변).
- **단점**:
  - 공식 개수 증가(+3). 단 제본방식 종류만큼이라 의미상 자연(실무진 가독성도 "무선책자→무선 제본공식"으로 명확). round-17 가독성 기준에 오히려 부합.
  - 향후 한 상품이 복수 제본방식을 런타임 선택하는 상품이 생기면 A안으로는 부족 → 그땐 B안/.08 필요. **현 BIND 4상품엔 그런 상품 없음(실측 ③)**.

### B안 — 1공식 유지 + 제본방식을 CPQ 옵션(opt_cd)으로 멤버십 분기

- **구조**: PRF_BIND_SUM 1공식 유지. 4 comp를 다 배선하되, 제본방식 option_items에 OPT_REF_DIM.08(가격comp 참조)를 달아 선택값→comp 1개만 활성화(PRF_DGP_A 가설A와 동일 메커니즘). 엔진이 .08 멤버십으로 합산집합을 좁힘.
- **장점**:
  - ① PRF_DGP_A와 메커니즘 통일(횡단 일관성). .08을 한 번 도입하면 디지털인쇄·제본 둘 다 같은 방식.
  - ② 미래 확장성 — 한 상품이 제본방식을 런타임 선택하게 되면 그대로 수용.
- **치명 단점**:
  - ① **현 데이터 현실과 불일치** — 제본방식은 상품별 1고정(실측 ③). 멤버십이 정적인데 런타임 옵션 분기로 인코딩 = **과설계**. 선택지가 1개뿐인 "택1 옵션"을 만드는 셈.
  - ② **.08 base_code + 트리거 fn_chk_opt_item_ref 보강 의존**(PRF_DGP_A F-3) — BIND 단독으로는 불필요한 횡단 인프라를 끌어옴. .08 미적용 상태에서 4 comp 배선만 하면 **동시매칭 4중 합산**(B-FORMULA §4-2)이라 .08 적용 전까지 BIND이 더 위험해짐.
  - ③ 070 PUR은 옵션 0행(B-OPT-070) — B안은 PUR 옵션 레이어 적재(L2)까지 선행 필요. 의존 사슬이 길어짐.

### 권고 = **A안 (제본방식별 공식 분리)**

근거:
1. **데이터 현실 정합(최우선)** — 라이브 실측 ③: 제본방식 = 상품 정체(1고정). 멤버십이 정적이므로 정적 바인딩(공식 1:1)이 의미 정합. B안은 정적 사실을 런타임 옵션으로 오인코딩.
2. **돈-크리티컬 안전** — A안은 즉시 동시매칭 0(comp 1개/공식). B안은 .08 적용 전까지 4중 합산 위험 노출.
3. **의존 최소** — A안은 BIND 범위 내에서 자기완결(횡단 .08·트리거·L2 PUR옵션 불요). B안은 횡단 .08+트리거+070 L2까지 동반 필요.
4. **PRF_DGP_A 가설A와 모순 아님** — PRF_DGP_A는 *한 상품 내 다중 택1*(엽서 인쇄 단/양면 공존)이라 .08이 정답. BIND은 *상품별 1고정*이라 공식분리가 정답. **두 클래스의 멤버십 구조가 다르므로 해법이 다른 게 정합**이다(같은 .08을 강요하는 게 오히려 부정합). round-16 BIND-C1 권고 A안과도 일치.

> 보존 조건: 향후 "한 책자 상품이 제본방식을 고객 런타임 선택" 요건이 생기면 그 상품만 B안(.08)으로 전환. A↔B는 배타가 아니라 상품 구조에 따른 적용. 현 4상품은 전부 A안 적격.

## 3. 정립 트랙 (어느 t_*·무엇·어느 에이전트·round)

| 순서 | 작업 | 대상 t_* | 행수 | 에이전트 | round 트랙 |
|---|---|---|---|---|---|
| ① 공식 신설 | PRF_BIND_MUSEON·PUR·TWINRING 3공식 + 중철 명확화(note/frm_nm 가독성) | t_prc_price_formulas | INSERT 3(+update 1 note) | dbm-load-builder(공식정의)·round-5 적재 트랙 | DDL 0(그릇 기존) |
| ② 배선 | 각 신공식에 자기 comp 1행 배선(addtn_yn=Y·disp_seq1) | t_prc_formula_components | INSERT 3 | dbm-load-builder | round-5 |
| ③ 바인딩 교정 | 069→PRF_BIND_MUSEON·070→PUR·071→TWINRING (현재 PRF_BIND_SUM) | t_prd_product_price_formulas | UPDATE 3 | dbm-load-builder | round-5(멱등 UPSERT) |
| ④ (DEFERRED) PUR 옵션 | 070 option_groups/options/items 적재(형제 책자 동형) | t_prd_product_option_* | round-6 산정 | dbm-option-mapper | round-6 L2 |
| ⑤ (DEFERRED) D-2 횡단 | .08 도입은 BIND에 불요(A안 우회). PRF_DGP_A AQ-1과만 연결 | — | — | (PRF_DGP_A) | 횡단 |

- **ddl-proposer 불요**(신규 엔티티/컬럼 0 — A안은 기존 그릇에 INSERT/UPDATE만). B안 채택 시에만 .08 base_code+트리거 보강(ddl-proposer)이 필요해짐 → A안의 추가 이점.
- 값(단가행 32셀)은 정확(A-2 PASS)이므로 component_prices 손대지 않음.

## 4. 재검증 기준 (Phase 9 폐루프 — RESOLVED 판정)

A안 적용 후 G-DATA/G-CHAIN/G-CALC 재실행:
- [ ] **GATE-S**: 책자4종 각자 자기 제본 comp가 공식에 배선(formula_components: 각 공식 1행·4공식 = 4행). 미배선 0.
- [ ] **GATE-A A-1**: 각 상품 활성 comp 집합 = 자기 제본방식 1개만(동시매칭 0·4중 합산 0).
- [ ] **G-CALC(보정 하드코딩 없이)**: recompute가 엔진 경로(공식→comp)로 골든값 재현 — G2(무선 100권)=50,000·G4(PUR 100권)=200,000·G5(트윈링 100권)=130,000. 현재 S3에서 "BROKEN(공식 우회 직접조회)"였던 G2~G5/G6~G8이 "WIRED(엔진 경로)"로 전환.
- [ ] **값 불변 검증**: 32셀 단가행 그대로(A안은 값 미변경). A-2 재PASS.
- 충족 시 B-WIRE+B-FORMULA RESOLVED → 클래스 GO → 벤치마크(레드 PRBKYPR 완제품 대조는 인쇄/용지 클래스 적재 후).

## 5. DEFERRED / BLOCKING 분류표

| ID | 분류 | 사유 | 해소 시점 |
|---|---|---|---|
| B-WIRE | 🔴 BLOCKING | 3상품 가격 계산 불가 → 클래스 GO 판정 불가 | BIND-C1(A안) 컨펌 후 ①②③ 적용 |
| B-FORMULA | 🔴 BLOCKING | B-WIRE 교정 형태를 가르는 설계 결정 | BIND-C1(A안) 컨펌 |
| D-2 | 🟡 DEFERRED(횡단) | BIND은 A안으로 우회(상품별 1고정) → BIND 판정에 불필요 | PRF_DGP_A AQ-1과 함께(BIND 무관) |
| B-OPT-070 | 🟡 DEFERRED(L2) | 가격 사슬·재계산 무영향(PUR 고정) | round-6 L2 적재 |
| 합산형 미완성(인쇄/용지/표지 공식 미바인딩) | 🟡 DEFERRED(범위) | 본 클래스=제본비 항. 완제품가는 타 클래스 적재 후 | 벤치마크 전제(S3 §3) |

## 6. 컨펌 큐 (사용자/실무진)

- **BIND-C1 [핵심·권고 A안]**: 공식 모델 = **A안(제본방식별 공식 분리 PRF_BIND_<방식> + 상품 1:1 바인딩)**.
  - 근거: 라이브 실측 ③ 제본방식 상품별 1고정 입증 · 동시매칭 0 · D-2/.08/트리거/L2 PUR옵션 의존 0 · DDL 0 · PRF_DGP_A 가설A와 비모순(구조 다름→해법 다름이 정합).
  - B안 기각: 정적 사실을 런타임 옵션 오인코딩(과설계)·.08 미적용 전까지 4중 합산 위험·의존 사슬 김.
  - round-16 BIND-C1 권고 A안 승계·확정 요청.
- **BIND-C2**: 캘린더4·하드커버3 제본 comp(CAL_*/HC_*/SSABARI)는 책자4 범위 밖 — 어느 상품에 바인딩? (round-16 단절2 승계·본 클래스 외).
- **BIND-C3**: 하드커버 "표지비용 따로 계산"·캘린더 "삼각대 포함" 그릇 위치 — 본 클래스 외(round-16 승계).
- **AQ-BIND(승인큐·BIND-C1 확정 후 적용)**:
  | 항목 | 정립안 | 트랙 | 상태 |
  |---|---|---|---|
  | AQ-BIND-1 | A안: 공식 3신설+배선 3+바인딩 교정 3 | round-5 load-builder | 컨펌 BIND-C1 후 |
  | AQ-BIND-2 | D-2는 BIND 무관(A안 우회) | 횡단 | 닫힘(BIND) |
  | AQ-BIND-3 | 070 PUR 옵션 레이어 적재 | round-6 L2 | 적용 대기 |
