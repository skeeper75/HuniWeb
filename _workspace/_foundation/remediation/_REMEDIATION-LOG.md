# A2 가격 적재정합 교정 — 실행 로그

2026-06-26 · 견적가능 70 A2 검증 → 확정 돈크리티컬 교정. 각 건 생성(dbm-price-arbiter)≠검증(Claude 라이브 재실측)·백업/undo·DRY-RUN·인간 승인 후 COMMIT. 라이브 운영 DB.

| # | 결함 | 교정 | 상태 | 단가영향 |
|---|---|---|---|---|
| 1 | **제본 다종-1배선**(C4-D01·codex) | 공식3 신설(무선/PUR/트윈링)+배선+바인딩 069/070/071. 068 중철 유지 | ✅ **COMMIT** | 무선/PUR/트윈링 제본비 **0원 전손→정상**(qty100: 50k/200k/130k) |
| 2 | **디지털 흑백/칼라 오적재**(C1·codex) | S1 212행 → 칼라단면/칼라양면 verbatim 치환(clr_cd=NULL·plt_siz_cd 구조) | ✅ **COMMIT** | 색상엽서 단면 3000→4000·양면 4000→6000(국4절). S2 死 보존·이중합산0 |
| 3 | **명함 자재 결손**(C1·D-C1-04) | STD_S1/S2 5종 종이 단가행 전개(누락 아트250·스노우250/300 추가) | ✅ **COMMIT** | 견적불가 3종 해소. 그룹1=3500/4500·그룹2=3800/4800 |
| 4 | **094 30P 고아배선**(C5-D1) | dim_vals.page+print_opt 보강+배선 | ⏸️ **보류** | ★컨펌 C-1: 클라이언트가 page 키 전송해야(별 코드 트랙)·DB만 COMMIT 시 견적불가 위험 |

**백업/undo** (`_foundation/remediation/`·`_foundation/`): bind-sum-undo.sql · digital-clr-{backup-s1.csv,undo.sql} · namecard-mat-undo.sql. 전부 단일 트랜잭션·DO block 안전장치·롤백 가능.

**검증 핵심(생성≠검증):**
- 제본: 라이브 단가행=가격표 verbatim 확인. codex(qty10)·arbiter(qty100) "불일치"=다른 수량구간 인용·실제 정합. proc 정확매칭이라 무선/PUR/트윈링은 0원 전손(codex "3.3배 과소"보다 심각).
- 디지털: PRF_DGP_* front 전부 CLR_000005(칼라전용·흑백선택0) 확인. use_dims=[proc,plt_siz,print_opt,min_qty] 정합. DELETE/INSERT 212 동수.
- 명함: use_dims=[mat_cd,...] 정확매칭→mat별 행 필요. 기존 2종 verbatim 보존+누락3 그룹가 추가.

**잔여 동형 전파(별 트랙):** 명함 PEARL collapse·디지털 명함 S1/S2 이중합산 검증·094 코드 트랙(C-1)·견적가능 70 외 가격만결손 51·기초부실 105.
