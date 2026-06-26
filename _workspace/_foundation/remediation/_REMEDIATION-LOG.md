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

---

## 2026-06-27 · 가격만결손 51 → 명함특수 4 바인딩 COMMIT (되돌리지 말 것)

권위=가격표260527 명함 B04~B09. 생성(hpe-engine-designer)≠검증(main 독립 재실측·사후검증). **★실 라이브 COMMIT 발생**(main이 dryrun 대신 fix.sql 실행한 실수로 조기 COMMIT → 독립검증 통과분·사용자 승인접근 일치 확인 후 **유지** 결정).

| 대상 | 처리 | 상태 | 골든(사후검증) |
|---|---|---|---|
| 035 모양·036 미니모양 | print_opt_cd 태깅(S1=단면·S2=양면) + use_dims 보강 + 전용 PRF + S1/S2 배선 + 바인딩 | ✅ **COMMIT** | 035 단면18000/양면19000 · 036 16000/17000 |
| 037 박 | PRF_NAMECARD_FOIL(본체+동판셋업5000) + 바인딩 | ✅ **COMMIT** | 200개=24200(19200+5000) |
| 039 투명 | PRF_NAMECARD_CLEAR(S1단독·단면만) + 바인딩 | ✅ **COMMIT** | 13500 |
| 034 펄 | 태깅·use_dims·PRF_NAMECARD_PEARL·배선 적재됨·**바인딩 보류** | ⏸️ 자재 collapse | 등록 MAT_128/129/240/241 ↔ 단가행 MAT_127/130 불일치 → dbmap namecard-mat-fix 후 GO |
| 040 화이트 | print_opt 태깅·use_dims만 선반영·PRF/배선/바인딩 미적재 | ⏸️ 보류 | 코팅 CL/NOCL 차원+자재 3중 선결 |

**라이브 footprint:** 신규 PRF 5(SHAPE·MINISHAPE·FOIL·CLEAR·PEARL) · 배선 9 · 바인딩 4 · print_opt 태깅 12행(단가값 verbatim 불변·NULL→코드) · use_dims 보강 10 comp. 바인딩 distinct prd **78→82**.
**핵심 입증:** ★035/036 양면 이중합산 홀(태깅 전 양면=S1+S2=37000 과청구) → 태깅 후 양면=S2만 19000 해소(사용자 적발). 부수효과 0(대상 comp 전부 기존 미배선). 단가값 0 변경.
**백업/undo:** `namecard-special-{backup,undo}.sql`(태깅·use_dims·PRF·배선·바인딩 전부 역연산). 단가값 미변경이라 undo도 단가 무관.
**교훈(프로세스):** 검증용 실행은 반드시 `*-dryrun.sql`(ROLLBACK), `*-fix.sql`은 끝이 `COMMIT;`이므로 라이브 적용. 운영 DB 대상 psql -f 전 파일 종결자 확인.
