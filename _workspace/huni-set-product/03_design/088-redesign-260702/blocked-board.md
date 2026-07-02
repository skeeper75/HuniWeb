# 088 재설계 — BLOCKED 보드 (Q2 해소 갱신)

- 작성 2026-07-02 · 갱신 2026-07-02(Q2 CLOSED) · §23 088 단일 스코프 · 적재 불가분 분리
- 형식: (track, 대상, 차단 사유, 상태, 라우팅)

---

## BLOCKED-Q2 — 소재+인쇄비 X 값·귀속 → ★CLOSED (2026-07-02)

| 필드 | 내용 |
|---|---|
| **track** | set/member 값 (돈크리티컬) |
| **대상** | 088 표지 원가 조각 = [소재+인쇄비] |
| **원 차단 사유** | 실무진 지목 "출력소재관리>하드커버전용>레더링바인더 A4" 행이 엑셀·라이브에 부재(CONFLICT). 후보 (a)7000 / (b)19000 간 100부 최대 ~1.2M 차이. |
| **해소** | **CLOSED** — 사용자가 출력소재관리 0702 발췌 전달(2026-07-02): **레더 링바인더 A4 = 9,000원**(636×374 기준·"소재+인쇄비 통합"·실무진 공식 문장 권위). verbatim = `01_authority/088-0702/leather-ringbinder-a4-grid.csv` 하단. → 값 확정·member 089 Home-M mint 명세 완료. |
| **해소 산출** | set-composition-design.md(§1 Q2 해소·§7 골든)·apply.sql(변경 8행)·apply-dryrun.sql·undo.sql·golden-088.csv. |
| **라우팅** | → hsp-set-gate S1~S8(evaluate_set_price 재계산·DRY-RUN·이중합산 0) → webadmin 가격시뮬레이터 실화면 "제외 0·PRICE≠0" 확인[HARD] → 인간 승인 후 hsp-load-execution COMMIT. |

- ★별도 인쇄비 component 추가 CONFLICT **없음**: 실무진 공식 문장이 9,000을 소재+인쇄비 통합가로 명시(행 비고 "소재비"보다 문장 권위). 임의 인쇄비 미추가.

---

## 표지 작업사이즈 3종 CONFLICT → ★해소 (2026-07-02 오케 보충)

| 필드 | 내용 |
|---|---|
| **대상** | 상품시트 611×374 vs 출력소재관리 636×374 |
| **판정** | **CONFLICT 아님** — 표지 작업사이즈 3종(611/622/636×374·D링 31/42/56 대응)이며 둘 다 맞다. 가격은 최대 636×374 기준 9,000 단일(링 두께 무차등). 가격축 아님 = 생산 메타. |
| **스코프** | 사이즈 코드 등록은 적재 스코프 밖(가격 배선·member까지)·생산 메타 참고로만 기록. |

---

## BLOCKED-COVERMULT — cover_mult ×2 (링 표지 앞뒤 물리 2장) → 잔존 (본 건 무관)

| 필드 | 내용 |
|---|---|
| **track** | 엔진 코드버그 (C트랙·개발팀) |
| **대상** | 088 표지 소재+인쇄비 ×2 (링=책등 없음·앞뒤 물리 2장) |
| **차단 사유** | pricing.py `plate_qty=⌈qty÷pansu⌉` 나눗셈만·×2 곱셈 경로 phantom → 표지 저평가(082/077 동일). |
| **상태** | **잔존** — 단 088 데이터 동작화(×1)는 이 블로커와 **독립 진행 가능**(082/077 선례·×1로 먼저 동작화). 본 재설계는 ×1 기준(골든 §7). |
| **라우팅** | 개발팀 C트랙(`_foundation/remediation/CODEBUG-cover-mult-x2-undercharge.md`). ×2 구현 후 표지 조각 ×2 재계산. |

---

## 비-블로커 (확정·적재 가능)

| 항목 | 상태 |
|---|---|
| 싸바리 제본비 (COMP_BIND_SSABARI@PROC_000098) | 확정·재사용(6밴드 verbatim) |
| 부모공식 shell (PRF_LEATHER_RINGBINDER_SET) | 확정·재사용(component 교체) |
| 표지 소재+인쇄비 (COMP_LEATHER_RINGBINDER_COVER·9,000) | 확정·mint 명세(값 verbatim·날조 0) |
| member 구조·면지 무가격·링 비가격축·proc PROC_000098 격리 | 확정 |
| 반제품 미등록 BLOCKED | **없음**(member 6종 전부 라이브 실재 .02) |
| 가격공식 부재 BLOCKED | **없음**(부모공식·싸바리 comp 실재·표지 comp/공식 mint) |

> **적재 트리거 조건**: BLOCKED-Q2 해소됨 → apply.sql 생성 완료. 게이트 GO + 인간 승인 후 COMMIT 가능. cover_mult ×2는 독립(×1로 동작화 진행).
