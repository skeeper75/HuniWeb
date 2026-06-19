# reconcile — 카테고리 축 표시중복 정리 Claude↔codex 교차합의 (D4 게이트)

생성: 2026-06-19 / hbd-codex-verifier / 방법론: hbd-codex-cross-verify
입력: Phase 2(mapping.csv·dedup-report·apply-plan) + codex-verdict.md + 라이브 재실측
codex 가용성: **AVAILABLE model=gpt-5.5** (preflight EXIT=0) — 미가용 폴백 불필요

## 1. 행별 reconcile 표 (그룹·노드 단위)

| 노드 | Claude 판정 | codex 판정 | 합의? | 비고 |
|---|---|---|:---:|---|
| **CAT_000104** | ① 오적재 — cat_nm '하드커버책자'→'하드커버'(가역 교정·안전 적재) | AGREE — 104 rename 합의 | **✅ 합의** | MAP F8 ▶︎하드커버 권위 양측 인용·라이브 동명충돌 실측 |
| **CAT_000105** | ④ 정당구분 keep(잎 상품22) | AGREE — 105 삭제=false-merge | **✅ 합의** | 사이즈 105삭제 패턴 카테고리 오적용 금지 양측 동의 |
| **CAT_000112** | ④ 정당구분 keep(L2 상품3) | AGREE — keep 안전 | **✅ 합의** | 부모/레벨/역할 상이(318과) |
| **CAT_000115** | ④ 정당구분 keep(L2 상품2) | AGREE — keep 안전 | **✅ 합의** | 부모/레벨/역할 상이(319와) |
| **CAT_000318** | 빈노드 BLOCKED(인간 IA·A/B 택일) | STRONGER — A(채움) 방향 타당·단 안전적재 아님·인간 IA 승인 후 | **🟡 합의(강도차)** | "BLOCKED·삭제금지·실적재 인간승인"은 동일. codex는 방향 힌트 A 추가 |
| **CAT_000319** | 빈노드 BLOCKED | STRONGER — 동상(A 방향) | **🟡 합의(강도차)** | 동일 |
| **CAT_000320** | 빈노드 BLOCKED(참고) | STRONGER — 동상(A 방향)·★114 충돌 점검 | **🟡 합의(강도차)** | codex가 CAT_000114 점검 추가→라이브 114 del=Y 확인됨 |

## 2. divergence 목록 — 진짜 불일치 0, 강도차(refinement) 2

### D-NONE 진짜 divergence: **없음**
양측 모두 ① 진짜중복 0 ② 104 rename = 유일 안전 적재 ③ 105/112/115 keep ④ 318/319/320 자의적 삭제 금지·실 적재 인간 승인. **핵심 결론 전건 합의.**

### R-1 [강도차·refinement] 빈노드 318/319/320 방향
- Claude: BLOCKED(A 채움 vs B 폐기 둘 다 dedup 자체판정 불가).
- codex: BLOCKED 유지하되 **A(채움) 방향이 더 타당**(MAP G16~G19가 PRD_108/110/111 재리스트=IA 의도 명시·B는 권위 의도 버림).
- **처리**: divergence 아님(둘 다 "삭제 금지·인간 IA 승인"). codex의 A 방향 힌트를 컨펌 큐에 **권고로 부기**(채택 아님·인간 결정).

### R-2 [강도차·codex 신규 발견·라이브 CONFIRMED] main_cat_yn append 안전성
- Claude apply-plan §6: "(A 실현) junction append, **main_cat_yn='N'**".
- codex: 이 가정 **미증명**. PRD_000110이 112·114 둘 다 main='Y' → 단일 main 불변식 미강제.
- **라이브 검증**: main='Y' 다중 보유 prd_cd **8건** 실재(PRD_000019~025·110) → ✓ codex CONFIRMED.
- **처리**: Claude apply-plan §6의 "main='N' append"는 **검증 전 가정**으로 강등. 318~320 채움(A) 실행 시
  main_cat_yn 규칙(앱 화면 노출 의미·단일성 미강제)을 IA/app 권위로 먼저 확정해야 함 → **컨펌 큐 보강 항목**.

### R-3 [강도차·codex 신규·라이브 부분확인] CAT_000114 충돌 점검
- codex: 320(엽서캘린더) 채움 전 CAT_000114(PRD_000110이 main=Y로 귀속) 활성 여부 확인 안 하면 세 갈래 위험.
- **라이브 검증**: CAT_000114 **del_yn='Y'(논리삭제)**·PRD_000110 활성 귀속은 112만 → 320 채움 시 활성 충돌 없음.
- **처리**: codex 점검은 정당(미확인 시 위험)·실측 결과 안전. 컨펌 큐에 "114 del=Y 확인됨" 명시로 해소.

## 3. 최종 안전 적재 대상 (양측 합의분만)

| 구분 | 건수 | 내용 | Claude | codex | 합의 |
|---|:---:|---|:---:|:---:|:---:|
| **안전 적재(가역·무손실)** | **1** | CAT_000104 cat_nm '하드커버책자'→'하드커버'(표시명 교정·pd=N·물리삭제0·멱등) | 적재 | 적재 | **✅** |
| keep(정당구분) | 3 | CAT_000105·112·115 | keep | keep | **✅** |
| BLOCKED(인간 IA 결정) | 3 | CAT_000318·319·320 빈노드 | BLOCKED | BLOCKED(A 힌트) | **✅** |

→ **고신뢰 안전 적재 = CAT_000104 rename 1건** (apply-plan.md §3 SQL 그대로·BEGIN/COMMIT 내장 금지·hbd-load-execution 위임).
→ 빈노드 3 = 인간 IA 승인 후 별도(채움 시 R-2/R-3 선결).

## 4. 컨펌 큐 (인간 승인 대상·reconcile 보강)

1. **[안전 적재] CAT_000104 표시명 교정** — 양측 합의·즉시 가능. MAP F8 '하드커버' 복원. 가역·가격무관·상품귀속 무영향.
2. **[BLOCKED·IA 결정] 빈노드 318/319/320** — A(채움) vs B(폐기) 인간 판단.
   - codex 권고: **A(채움) 방향**(MAP IA 의도 명시·B는 권위 버림). 단 dedup 자체판정 아님.
   - ★A 채움 시 선결(R-2): **main_cat_yn 규칙 확정 필수** — DB가 단일성 미강제(8건 다중 main=Y 실재).
     Claude의 "main='N' append" 가정은 검증 전. 앱 화면 노출 의미를 IA/app 권위로 확정 후 실행.
   - ★A 채움 시 안전 확인(R-3): CAT_000114(엽서캘린더) **del_yn='Y' 확인됨** → 320 채움 시 활성 충돌 없음.

## 5. D4 게이트 판정

| 항목 | 상태 |
|---|---|
| codex 가용성 | **AVAILABLE gpt-5.5** (미가용 폴백 불필요) |
| 환각 경계 | codex 인용 근거 = work-spec 라이브/MAP 실측 범위 내·날조 0. 신규 발견 2건 라이브 재대조(R-2 CONFIRMED·R-3 부분확인). **PASS** |
| reconcile 완료 | 7노드 전건 reconcile·진짜 divergence 0·강도차 refinement 3(R-1/2/3 컨펌 큐 흡수) |
| divergence 해소 | 진짜 divergence 없음·강도차는 컨펌 큐 보강으로 흡수. **해소 완료** |
| 최종 안전 적재 | **CAT_000104 rename 1건**(양측 ✅ 합의) |

→ **D4 PASS.** 합의분(104 rename) 진행 가능. 빈노드 3 = 인간 IA 승인 후(채움 시 main_cat_yn 규칙 선결).
divergence 미잔존 → dedup-analyst 재판정 라우팅 불필요.
