# Huni-Set-Product (§23) — HANDOFF

최종 갱신: 2026-06-26 · 그릇 GO + PRF 설계 + ★전체 7×4 현황판 세션 마감. 상세 누적 → `CHANGELOG.md`.

---

## ★다음 시작점 (fresh 세션이 바로 할 일)

**조각(piecemeal) 금지 — 전체 현황판부터 읽고 4축으로 처리.**
권위 현황판 = **`06_load/set-product-readiness-master.md`**(7셋트 × 4축 준비 매트릭스). 먼저 이걸 읽으면 재발견 0.

라이브 가격 바인딩 = **097(완료)·094(결함)** 2건뿐. 5셋트(072/077/082/088/100) 미바인딩 = 셋트 견적 불가.

**권고 처리 순서 (사용자 시작점 미확정 — 다음 세션이 결정):**
1. **A2 전체 가격테이블 적재정합 전수** [축2·핵심 공백·미수행] — 가격표 260527이 전체 t_prc_*에 누락0으로 적재됐는지 전수(셋트 구성원 포함). 셋트 가격의 토대. §21 catalog-conformance가 부분만 수행.
2. **A1 기초데이터 정정 일괄** [축1] — 표지/내지 자재 정정·표지펼침siz(390×268 신설)·내지종이·인쇄면지087/093·면지색 옵션화·제본 param 그릇(088).
3. **A3 가격엔진 코드결함 2건** [전 책자 공통·webadmin 개발팀 트랙] — DBLPANSU(price_views.py:1707 `derive_inner_sheets→copies*pages` 1줄)·S1/S2 내지인쇄 이중합산(094도 가진 결함). 코드 직접수정 금지 → §6/dbmap·인간 승인·배포.
4. **B 그릇** — 072 내지 반제품 승격 **그릇 GO 완료**(인간 승인 후 적재·돈0). 077/082 동형 전파 미설계.
5. **C 민팅·바인딩** — 072 PRF 3(INNER/COVER/BODY)+S2 부활 민팅 → 바인딩(A1·A3 선결). 077/082/100 전파. 094 결함정정·088 제본방식(실무진).

★C로 직진하면 A 공백 위 piecemeal. A→B→C 순서 권장.

---

## 미해결 / 블로커

### 그릇 (072 내지 반제품 승격) — GO·적재 대기
- 검증(validation-gate.md rev2)+codex(codex-reconcile.md rev2) 수렴 GO. 채번 PRD_000284·정본 active siz **A5=SIZ_000007·A4=SIZ_000050**·069 무선책자 내지 7자재 재사용·국4절 plate·sets SEMI_ROLE.01. 신규 mint 14행·돈0·DB 미적재. 인간 승인 후 적재.
- production hardening(돈0): 채번 가드 del_yn/use_yn 추가·sets NOT EXISTS del_yn.
- 077/082 전파 미설계(072 동형·순차 채번 285/286).

### PRF 트랙 — NO-GO (4 선결)
- **CFM-INNER-DBLPANSU** 🔴: 데이터 정석해소 불가·코드 트랙 확정(price_views.py:1707 1줄·§6·인간 승인). 미해소 시 내지 ~0.4배 과소.
- **S1/S2 내지인쇄 이중합산** 🔴: codex 신규 적발·**094 엽서북도 가진 가격엔진 구조결함(R-3)**. 양면 주문 시 S1+S2 합산(배타선택 부재). 해법=면별 PRF 분리/only_comps/side 차원. 전 책자 공통.
- **CFM-COVER-SPREAD-SIZ** 🟡: 표지 펼침 siz 390×268 미등록(dbmap·미해소 시 표지 ~3.8배 과소).
- **CFM-COVER-A4PLT** 🔴 BLOCKED: A4 표지 3절 절가 89.54 단가행 부재·3절 impos_yn=N(A4만·A5 무관).

### 축2 전체 가격테이블 적재정합 — 전수 미수행 (핵심 공백)
- 097만 적재·094 결함·5셋트 미적재. 전체 t_prc_* 전수 정합 확인 별도 필요.

### 잔여 CONFIRM (돈영향 현재 0)
- 책등 종이 추가비를 권위 가격축이 안 받음(두꺼운 책 표지종이 증가분·실무진 확인). 비활성 판형 229건 여백 누락(향후 포스터 pansu 도입 시·현재 0). 088 제본방식 "보류중"(실무진).

---

## 이번 세션 결정 (relitigate 금지)

1. **072 내지 반제품 승격 = 그릇 GO**. 094/097 고정가형이라 derive_inner_sheets 무관했던 것 규명. 072=원자합산형(권위 확정)이라 내지 페이지곱 위해 내지 반제품 승격이 정석.
2. **정본 active siz = A5 SIZ_000007·A4 SIZ_000050**(4원천 권위 분석). 삭제 SIZ_000170(A5)은 20상품 활성참조 광역 dedup(basedata-dedup 라우팅). siz 교체 돈영향 0(절가=국4절 기준·use_dims에 siz_cd 부재·fn_calc_pansu pansu 불변).
3. **DBLPANSU = 데이터 불가·코드 트랙 확정**. `_row_matches`가 use_dims 아닌 하드코딩 NON_QTY_DIMS 순회라 데이터-only는 over-mint뿐. canonical=뷰 1줄.
4. **S1/S2 이중합산 = 가격엔진 구조결함**(094 R-3와 동일·전 책자 공통). codex 신규 적발=생성≠검증 실효.
5. **골든 968,433원**(3자 일치·표지 64,832.5+내지 453,600+제본 450,000). DBLPANSU 함정 695,395.94.
6. **출력가능영역 = fn_calc_pansu가 판형 work−margin·아이템 work로 정확 처리**. 돈경로 판형(국4절 5mm·국3절 2mm) 여백 clean.
7. **책등(spine)**: A5는 plate-based 절가+전 페이지(24~300p) 국4절 1-up 유지라 **돈영향 0**·정적 펼침siz(390×268) 충분. 진짜 결함은 펼침siz 미등록(3.8배). 책등 종이비는 권위 가격축에 없음(CONFIRM).
8. **★전체 조망 우선·조각 금지**(사용자 피드백·메모리 [[set-product-whole-before-pieces]]). 7×4 현황판=`06_load/set-product-readiness-master.md`.

---

## 건드리지 말 것 (확정 COMMIT·되돌리지 말 것)

- 기존 라이브 COMMIT 전부 보존: 좀비배선 13건·W2 9그룹/29옵션·097 떡메 바인딩(git 26902ef·d32debf 직전). 백업·undo 보유.
- **이번 세션 DB COMMIT = 0** (그릇·PRF·검증 전부 설계+DRY-RUN ROLLBACK·라이브 무변경). 산출물(06_load/inner-promotion/ 10종·set-product-readiness-master.md) 보존.

---

## 이번 세션 산출물 (06_load/inner-promotion/ + 06_load/)
- `set-product-readiness-master.md` — ★7셋트×4축 현황판(조각 방지 권위)
- `inner-promotion/inner-promotion-design.md` — 그릇 설계(rev 보정)·`validation-gate.md`(rev2 GO)·`codex-reconcile.md`(rev2 GO)·`inner-size-authority.md`(정본 siz)
- `inner-promotion/prf-track-design.md`(PRF 3·골든 968,433)·`prf-apply.sql`·`prf-dryrun.sql`·`prf-track-codex-reconcile.md`(S1/S2 적발)
- `inner-promotion/cover-spine-principle.md`(책등)·`plate-margin-audit.md`(판형 여백)

---

## 자격증명/안전
- 라이브 Railway DB: `.env.local RAILWAY_DB_*`(읽기전용 SELECT·`db railway`·비표준 포트). 파괴적 쓰기는 인간 승인 COMMIT만(백업→DRY-RUN→COMMIT→사후검증→undo).
- webadmin 코드(pricing.py·price_views.py) 직접수정 금지 — DBLPANSU·S1/S2는 §6/개발팀 위임.
- `.env.local` IGNORED 검증 후 커밋. 비밀값 `_workspace`/stdout 비노출.
