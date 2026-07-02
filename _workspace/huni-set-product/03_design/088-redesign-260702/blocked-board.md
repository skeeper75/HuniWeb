# 088 재설계 — BLOCKED 보드

- 작성 2026-07-02 · §23 088 단일 스코프 · 적재 불가분 분리
- 형식: (track, 대상, 차단 사유, 무엇이 오면 해소, 해소 시 잔여 작업, 라우팅)

---

## BLOCKED-Q2 — 소재+인쇄비 X 값·귀속 미확정 (★핵심·유일 하드 블로커)

| 필드 | 내용 |
|---|---|
| **track** | set/member 값 (돈크리티컬) |
| **대상** | 088 표지 원가 조각 X = [소재+인쇄비] (표지 member 089 또는 부모공식 두 번째 component) |
| **차단 사유** | 실무진이 지목한 "출력소재관리 > 하드커버전용 > **레더링바인더 A4**" 행이 상품마스터_260702·가격표_260702 전 시트·라이브 DB 어디에도 **부재**(CONFLICT). 존재하는 건 "레더하드커버 A4=7000"(소재비만·사이즈 532×355≠611×374·인쇄비 포함 불명)뿐. 후보 (a)소재7000+인쇄비 / (b)레더아트프린트19000이 **1부 12k·100부 최대 1.2~1.75M 차이** → 임의 채택 시 저/과청구. 값 날조 금지[HARD]. |
| **무엇이 오면 해소** | 실무진이 ① X를 **어느 파일/화면의 어느 줄**에 입력했는지(또는 "레더하드커버 A4=7000을 쓰라") ② **값이 얼마**인지(소재만인지 인쇄비 포함인지) ③ 인쇄비 별도면 어떤 인쇄비 component/proc인지 를 회신. (재질문서 = `03_design/088-Q2-재질문-260702.md`·`레더링바인더-실무진질문서-260702.pdf`) |
| **해소 시 잔여 작업** | 1) X 값·경로(a/b)·귀속 home(P부모공식/M표지member) 확정 → 2) X component 재사용(b: COMP_POSTER_CANVAS_FABRIC) 또는 단가행 mint(a: 레더 소재비 7000 + 인쇄비 component, mint는 dbmap/§18 위임) → 3) **apply.sql 생성**(부모공식 component 교체: COMP_HC_MUSEON_COVERBIND 배선 제거 + COMP_BIND_SSABARI 배선 추가 + X 배선 + 088 product_processes PROC_000098 추가·멱등 ON CONFLICT) → 4) hsp-set-gate S1~S8(evaluate_set_price 재계산·DRY-RUN·이중합산 0) → 5) webadmin 가격시뮬레이터 실화면 "제외 0·PRICE≠0" 확인[HARD] → 6) 인간 승인 후 load-executor COMMIT. |
| **라우팅** | 실무진 회신 대기 → 회신 후 hsp-set-design(값 채움·SQL) → hsp-set-gate → hsp-load-execution. (a 채택 시 소재/인쇄비 단가행 신설 = dbmap 위임.) |

---

## BLOCKED-COVERMULT — cover_mult ×2 (링 표지 앞뒤 물리 2장) 저청구

| 필드 | 내용 |
|---|---|
| **track** | 엔진 코드버그 (C트랙·개발팀) |
| **대상** | 088 표지 인쇄/소재비 ×2 (링=책등 없음·앞뒤 물리 2장) |
| **차단 사유** | pricing.py `plate_qty=⌈qty÷pansu⌉` 나눗셈만·×2 곱셈 경로 phantom → 표지 저청구(082/077과 동일). |
| **무엇이 오면 해소** | 개발팀이 cover_mult ×2 경로 구현(`_foundation/remediation/CODEBUG-cover-mult-x2-undercharge.md`). |
| **해소 시 잔여 작업** | ×2 반영 후 예상가 재계산(§set-composition-design §3.3 ×2 행)·골든 재검. **단 088 데이터 동작화(×1)는 이 블로커와 독립 진행 가능**(082/077 선례 — ×1로 먼저 동작화 COMMIT). |
| **라우팅** | 개발팀 C트랙(데이터 트랙과 병행). |

---

## 비-블로커 (확정·지금 진행 가능·참고)

| 항목 | 상태 |
|---|---|
| 싸바리 제본비 component | 확정(COMP_BIND_SSABARI@098 재사용·verbatim) — X 확정 후 apply.sql에 포함 |
| member 구조·면지 무가격·링 비가격축·proc PROC_000098 격리 | 확정(값 무관) |
| 반제품 미등록 BLOCKED | **없음**(member 6종 전부 라이브 실재) |
| 가격공식 부재 BLOCKED | **없음**(PRF_LEATHER_RINGBINDER_SET 실재·COMP_BIND_SSABARI 실재) |

> **적재 트리거 조건**: BLOCKED-Q2 해소(X 값·경로 확정) 전에는 apply.sql 생성·DB 적재 **금지**. 싸바리 조각만 배선하고 X를 0으로 두면 표지 원가 누락 = 저청구이므로, **X와 싸바리를 한 트랜잭션으로** 확정 후 COMMIT.
