# Huni-Set-Product (§23) — HANDOFF

최종 갱신: 2026-07-01 · **하드커버 셋트 동작화 라이브 COMMIT 2건**(077 레더 견적0→51,146·082 링 0→44,123). **권위 = `_workspace/_foundation/`(price-formula-master·remediation).** 상세 누적 → `CHANGELOG.md`.

> 직전(2026-06-27): 전 상품 가격공식 통합 마스터 + 가격만결손 51 분해 + 명함특수 4 COMMIT + 아크릴 코드버그.

## ★077 레더하드커버 동작화 완료 (2026-07-01·셋트 동작화 동형 패턴 입증)

077을 권위대조→설계→독립 게이트 DRY-RUN→인간 승인 후 **라이브 COMMIT**(23행 단일 트랜잭션·견적 0원→51,146). **패턴**: 부모공식 미바인딩 견적0 셋트는 ① 동작하는 동형(072) 권위 대조로 빈 껍데기 결함 vs 설계의도 결판 ② 부모공식·comp·단가행 재사용 + 내지 반제품만 mint(search-before-mint) ③ 셋트행에 내지 삽입 ④ evaluate_set_price 사후 PRICE≠0 확인. 백업·undo 보유·회귀0. 상세 [[leather-hardcover-077-live-commit-260701]].

**★레더 +3,900 BLOCKED 교훈[HARD]**: COVERBIND `use_dims=["min_qty"]`만이라 mat_cd 단가행 추가 시 `_row_matches`가 AMBIGUOUS로 전체 0원화 → 단가행에 차원 넣어도 use_dims 미선언이면 무용·오히려 위험. 레더 프리미엄 정확반영은 엔진 use_dims 확장(C트랙).

**077 동형 전파 후보**: 082 하드커버링(단 cover_mult ×2 BLOCKED·[[booklet-cover-branch-design-260630]] 동반)·068~071 소프트커버(부모공식 4비목·[[booklet-set-formula-principle-260629]]). 동작화 전 BLOCKED-MAT-REWIRE(077 좀비 MAT_000002 link 정리)·CONFIRM-LEATHER-PRINT 잔존.

---

## ★다음 시작점 (fresh 세션이 바로 할 일)

**먼저 읽을 권위(재발견 0):** `_workspace/_foundation/price-formula-master.{csv,md}`(★전 275상품 가격공식 완전성 자·status 7분류)·`product-type-classification-sot.md`(분류 SOT)·`product-config-readiness-260626.md`(견적 준비도)·`remediation/_REMEDIATION-LOG.md`(가격교정·COMMIT 이력)·`remediation/CODEBUG-sizcd-area-undercharge.md`(아크릴 코드버그)·`remediation/namecard-special-design.md`. 셋트 7×4 현황판=`06_load/set-product-readiness-master.md`.

**근본원인 해소 진행 = SOT §3 작업순서:**
1. ✅ 분류축 확정 · 2. ✅ 라이브 재정렬(완226/반29/기성20) · 3. ✅ 기초 진단 · 4. ✅ A2 견적가능70 교정 3건 · 5. ✅ 전 상품 공식 완전성 마스터 + 가격만결손 51 분해 + 명함특수 4 COMMIT

**다음 우선순위 (이어서):**
1. **아크릴 siz_cd×면적 코드 환원(C)** — 개발팀 위임. `CODEBUG-sizcd-area-undercharge.md` 전달 → 엔진 siz_cd→cut_width/height 환원 적용 후 아크릴 16(157~162 등) area 바인딩 안전. **현재 area 바인딩 시 과소청구 확정이라 보류.** webadmin 코드 직접수정 금지(§6).
2. **명함 034 펄·040 화이트** — 자재 collapse(등록 MAT≠단가행 MAT) = dbmap `namecard-mat-fix` 확장 + 040 코팅 CL/NOCL 차원 → 후 바인딩(PRF/배선/태깅은 이미 적재). 박 037 HOLO/양면 = CPQ 옵션그룹 선결.
3. **DESIGNED_NOT_LOADED 22 민팅** — §18 설계만·라이브 미적재(문구9·책자셋트5·굿즈4·특수아크릴3·코롯토1). §18→dbmap 적재(돈크리티컬·각 건 인간 승인).
4. **NEEDS_BASICS_FIRST 97 구성(최대)** — 차원/자재부터. 굿즈/파우치 87. 상품마스터 굿즈파우치/문구 시트 권위로 신규 구성(§7 dbmap).

처리 방식 = 생성≠검증·백업/undo·**검증은 반드시 `*-dryrun.sql`(ROLLBACK)**·실 COMMIT은 인간 승인(이번 세션 fix.sql 오실행 교훈 [[dryrun-vs-fix-script-commit-lesson]]).

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

### 축2 전체 가격테이블 적재정합 — ★A2 검증 완료 + 견적가능70 교정 3건 COMMIT (2026-06-26)
- 검증: `06_load/a2-price-conformance/`(6클러스터+codex high·종합 NO-GO). 미바인딩 197=§18 "설계됨≠적재됨". C2 스티커만 완전 GO.
- ✅ **교정 COMMIT 3건**(`_foundation/remediation/_REMEDIATION-LOG.md`·되돌리지말것): ① 제본 다종-1배선(무선/PUR/트윈링 0원전손→정상·셋트 책자 근본) ② 디지털 흑백/칼라 오적재(색상엽서 칼라단가·이중합산0) ③ 명함 자재 결손(5종 전개). 백업/undo 보유.
- ⏸️ 094 30P 보류(코드트랙 C-1·page 전송·§6). REFUTED 1: FOMEXBOARD(가격표 권위 정합·검증가 오판).

### ★전 상품 공식 완전성 + 가격만결손 51 분해 + 명함특수 4 COMMIT (2026-06-27)
- **마스터** `_foundation/price-formula-master.{csv,md}` — 전 275상품 status 7분류. 완제품226 가격작동 78→82. **가격만결손 51 = LIVE_UNBOUND 24 + DESIGNED_NOT_LOADED 22 + DESIGN_BLOCKED 5** 정확 분해.
- ✅ **명함특수 4 라이브 COMMIT**(035 모양·036 미니모양·037 박·039 투명·`_REMEDIATION-LOG.md` 2026-06-27·되돌리지말것): 특수 comp print_opt_cd 태깅(S1=단면/S2=양면·단가verbatim)+use_dims 보강+전용 PRF 5+배선 9. ★035/036 양면 이중합산 홀(37000→19000) 해소·사후검증 통과.
- ⏸️ **아크릴 16 보류** = siz_cd×면적 코드버그(엔진 siz_cd 미환원→최소사이즈 과소청구 확정·`CODEBUG-sizcd-area-undercharge.md`·데이터편집 불가·C트랙 개발팀). ⏸️ 명함 034 펄/040 화이트 = 자재 collapse.
- 다음: 아크릴 코드(C·dev) → 명함 034/040 자재 → DESIGNED_NOT_LOADED 22 민팅 → NEEDS_BASICS 97(굿즈).

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

- 기존 라이브 COMMIT 전부 보존: 좀비배선 13건·W2 9그룹/29옵션·097 떡메 바인딩(git 26902ef·d32debf 직전)·A2 교정 3건(260626). 백업·undo 보유.
- **★2026-06-27 명함특수 4 COMMIT 보존**: PRF 5(SHAPE·MINISHAPE·FOIL·CLEAR·PEARL)·배선 9·바인딩 4(035/036/037/039)·print_opt 태깅 12행·use_dims 10 comp. 단가값 verbatim 불변. undo=`namecard-special-undo.sql`. 되돌리지 말 것.
- 산출물 보존: `_foundation/price-formula-master.*`·`remediation/`(51 board·CODEBUG·namecard-special)·`06_load/inner-promotion/`·`set-product-readiness-master.md`.

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
