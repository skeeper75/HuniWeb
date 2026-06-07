# M-1 결정서 — 열재단(熱裁斷) = ① 실제 가공 공정 (verdict + 근거)

> silsa(일반현수막 PRD_000138) 파일럿 검증이 발견한 M-1을 사용자 지시("인쇄 도메인·실사작업·경쟁사 리서치 후 판단")대로 닫는다.
> 작성 2026-06-07. 결정 권위 = **후니 가격표 명시값**(메모리 `dbmap-domain-knowledge-before-asking`: 엑셀/가격표 명시값=권위, 외부표준 재고 금지).
> 식별자/코드 English, 설명 Korean.

## 0. 한 줄 결론

**열재단 = ① 실제 가공 공정** (3,000원 priced finishing). ②(0원 기본마감 sentinel) 아님. → 전용 마스터 공정 신설 제안(`11_ddl_proposals/heat-cut-process-proposal`) + silsa 파일럿 정정(완칼 PROC_053 차용 폐기).

## 1. M-1 문제 (silsa 파일럿이 발견)

일반현수막 가공 그룹 [택1·필수, 기본값=열재단]에서 **열재단**이 기본값(`dflt_yn=Y`)인데, 그 차원행(공정)이 PRD_000138에 미적재 → "필수 그룹의 기본값이 참조 해소 불가" 모순. silsa 파일럿은 banner-walkthrough의 임시 차용 `PROC_000053 완칼`을 따랐으나 라이브 검증 결과 BLOCKED(완칼은 PRD_000138 미적재 + 매질 부적합).

## 2. 두 갈래 리서치 — 표면상 상반 → 가격표가 정리

사용자 지시로 도메인·경쟁사를 먼저 자가확보(`dbm-domain-knowledge-before-asking` 원칙). 두 리서치가 갈렸다:

| 리서치 | verdict | 근거 |
|--------|---------|------|
| **A. 도메인** (`m1-yeoljaedan-domain-research.md`) | ② default sentinel | 비즈하우스 "열재단=(기본 마감)·0원(무료)" · 후니 공정관리 doc에 열재단 별도 공정 부재 · 후니 DB 공정 마스터 0건. **단 권고2에서 "가격표에 단가 있으면 ① 재검토" 안전장치를 정직하게 걸어둠** |
| **B. 경쟁사** (`m1-yeoljaedan-competitor-research.md`) | ① distinct process | RedPrinting이 현수막 재단을 **보이는 공정**(CUT_ZUN)으로 두고, **숨김-필수 센티넬(CUT_DFT, VIEW_YN=N)을 별도 코드로 구분** — 현수막 재단을 ①에 명시 배치. WowPress "현수막 열재단(사방/상하/좌우)" 명명 가공 item |

## 3. 결정 증거 — 가격표(후니 권위)가 ①로 확정

`06_extract/price-poster-sign-l1.csv` 포스터사인 B26 "일반현수막 가공옵션 추가가격" (J=가공옵션명, K=추가가격):

| 가공옵션 | 추가가격 | | 추가옵션 | 추가가격 |
|---|---|---|---|---|
| **열재단** | **3,000원** | | **추가없음** | **0원** ← 진짜 센티넬 |
| 타공(4개) | 3,000원 | | 큐방(4개) | 3,000원 |
| 타공(6개) | 4,000원 | | 끈(4개) | 4,000원 |
| 타공(8개) | 5,000원 | | 각목(900↓)+끈 | 4,000원 |

- **열재단 = 3,000원** 가격을 갖는 가공 옵션. 0원인 "추가없음"(진짜 do-nothing 센티넬)과 **명확히 구분**된다.
- → 도메인 A의 ②(0원 기본마감)는 **경쟁사 일반론(비즈하우스)에 오버피팅**된 것. 후니 실제 가격표(권위)는 ①. A의 권고2 안전장치가 정확히 발동.
- 경쟁사 B의 RedPrinting CUT_ZUN(보이는 공정) vs CUT_DFT(숨김 센티넬) 구분과도 일치 — 후니 열재단은 CUT_ZUN형(①).

**3개 증거선(가격표·경쟁사·도메인 매질) 종합 = ① 확정.**

## 4. 조치 (lead 확정 → ① 채택)

1. **열재단 전용 공정 신설 제안** = `11_ddl_proposals/heat-cut-process-proposal.{md,sql}` (dbm-ddl-proposer):
   - 신규 `t_proc_processes` 1행: `proc_cd=PROC_000084 [CONFIRM-CHANNEL]`(채번=라이브 MAX 확인 후 후니 배정·인간 승인), `proc_nm=열재단`, `upr_proc_cd=NULL`(root, 079/080/081 동형), `prcs_dtl_opt=NULL`(param 없음 — flat 3,000원; 위치변형 사방/상하/좌우는 `[CONFIRM]` 후속 ALTER 여지), note="Heat cut, 천 가장자리 열봉합".
   - 신규 `t_prd_product_processes` 1행: PRD_000138 × PROC_000084, `mand_proc_yn=N`(**필수성은 process link 아닌 CPQ option_group `mand_yn`에서 표현** — 정확).
   - 가격 3,000원 = 가격엔진(가공옵션 추가가격)에만. process에 중복 저장 안 함.
   - 영향: 순수 INSERT 2행·파괴적 변경 0·백필 불요. 정규화 무손실·비중복.
2. **silsa 파일럿 정정** = 열재단 option_item을 "PROC_053 완칼 차용 BLOCKED"에서 "신규 PROC_000084(제안) 참조 — 공정 신설 인간승인 대기 BLOCKED"로. (완칼=종이 다이컷 차용 폐기.)
3. **backfill scope**: 다른 현수막/실사 상품도 열재단 쓰면 동일 링크 필요(`silsa-l1.csv` 가공=열재단 상품 전수). 제안서 영향분석 참조.

## 5. 미해결 / 인간 승인 대기

- **proc_cd 채번** = 라이브 `MAX(proc_cd)` 확인 후 후니 배정(메모리상 PROC_000084 placeholder 의도적 제외 이력 → 단정 금지).
- **실제 공정 신설·적재** = DDL/INSERT 인간 승인(제안서까지만).
- **위치 변형(사방/상하/좌우)** = 후니 가격표에 위치별 단가 부재 → 미반영, 도입 시 후속 ALTER `[CONFIRM]`.
- **backfill 전 현수막/실사 상품** = PRD_000138 외 열재단 사용 상품 일괄 링크(인간 승인).

## 6. 교훈

- **도메인 자가확보 + 가격표 권위 교차의 정석 사례.** 도메인 일반론(비즈하우스 0원)만 봤으면 ②로 오판 → 가격표(후니 권위) 3,000원이 ①로 정정. 사용자 "리서치 후 판단" 직관이 옳았다.
- **생성-검증 분리가 M-1을 발견**(silsa 검증이 열재단 BLOCKED 모순 적발) → 리서치 → 가격표 권위 → 공정 신설 제안. 침묵 적재(BLOCKED 무시) 금지의 가치.
- **필수성 ≠ process link** — 옵션 필수성(택1·필수)은 CPQ `option_group.mand_yn`, process link는 후보 제공(mand_proc_yn=N).
