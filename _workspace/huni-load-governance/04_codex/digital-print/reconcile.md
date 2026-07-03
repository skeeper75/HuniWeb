# 디지털인쇄 옵션 판정 — Claude ↔ codex reconcile (최종 수렴)

> §34 Huni-Load-Governance · Phase 3 · hlg-codex-verifier · 2026-07-03
> 대조: Claude Phase 2 판정(`02_audit/digital-print/disposition-spec.md`·board 325행) ↔ codex 독립 판정(`codex-verdict.md`)
> 방법[HARD]: codex 주장 = 가설 → **board 원자료(ref해소 열)·규범 재확인**으로 판정. 라이브 SELECT 불요(board가 이미 ref를 해소해 기록).
> 후속: hlg-governance-gate LG7(reconcile 수렴 확인).

---

## 0. 수렴 요약

| 구분 | 건수 | 항목 |
|------|------|------|
| **합의(고신뢰)** | 2 | 과제1 MOVE-기준정보=0 · 과제5 오차단 0(삭제 아님) |
| **불일치→codex 옳아 Claude 정정** | 2 | 과제4 PRD_042 종이(스타드림 4항목) KEEP→**EXTEND** · PRD_047 EXTEND 근거 확장 |
| **불일치→라벨 정형화로 수렴** | 1 | 과제3 PRD_037 박종류 EXTEND→**EXTEND-BLOCKED**(가격종속 정식 분리) |
| **codex UNCERTAIN→위임 큐(미수렴)** | 1 | 과제2 무옵션 9상품 = §21/라이브 재확인 위임(현 처분 유지) |

**divergence 잔존**: 과제2 1건(UNCERTAIN·판정 대립 아님·증거 위임). 나머지 4과제는 수렴.

---

## 1. 합의 항목 (고신뢰 — 양측 일치)

### R-1. 과제1 — MOVE-기준정보 = 0 (KEEP 63그룹 잉여중복 없음) — **합의 유지**
- Claude: 옵션 ref가 기준정보 같은 값 가리켜도 anti-pattern 아님(CPQ 환원 구조·트리거 강제·제거 시 선택지 손실).
- codex: AGREE. 단일항목 그룹(024/026 종이 1항목)도 "기준정보만으로 선택/가격 성립" 증거 4파일에 없음 → MOVE 근거 부족.
- **재확인**: board `PRD_024/026 종이` = `Y-트리거정합(1/1)·가격종속 Y·KEEP`. 단일항목이라도 mat_cd 환원=가격 경로 → 제거=견적축 상실. **MOVE-기준정보 0 최종 확정.**

### R-2. 과제5 — 오차단 0(정당 옵션 삭제 유발 없음) — **합의**
- 양측: EXTEND는 "선택지 추가/보강"이지 제거 아님 → 손님 선택지 손실 0. Claude spec §5 오차단 0 자기점검 유효.

---

## 2. 불일치 → codex가 옳아 정정된 항목 (★핵심 적발)

### R-3. ★ PRD_042 종이(스타드림 4항목) — KEEP → **EXTEND**(ref 의미오매핑 재배선) + 가격게이트
- **Claude 판정**: KEEP · `기준정보중복=Y-트리거정합` · 근거=ref .03→mat_cd 환원 성립.
- **codex 판정**: DISAGREE — board ref해소 열이 **의미 오매핑**을 스스로 기록.
- **board 원자료 재확인(라이브 불요·board 자체 증거)**:
  ```
  스타드림(실버) 240g   → 자재:MAT_000128(면끈)          ← 종이 옵션인데 면끈(굿즈)
  스타드림(골드) 240g   → 자재:MAT_000129(아크릴키링고리)  ← 아크릴 키링고리(굿즈)
  스타드림(다이아) 240g → 자재:MAT_000240(보드스탠딩)      ← 보드스탠딩(굿즈)
  스타드림(로츠쿼츠)240g→ 자재:MAT_000241(핀버튼)          ← 핀버튼(굿즈)
  ```
  정상 스타드림 종이 코드는 실재함(PRD_047 board: `스타드림(다이아몬드)→MAT_000127(스타드림)`). 즉 실버/골드/다이아/로츠쿼츠 옵션이 **인접 굿즈오염 코드(MAT_000128~130/240/241)로 오배선**됨.
- **판정**: codex 옳음. **트리거 정합(ref 존재) ≠ 의미 정합(올바른 자재).** Claude auditor가 자기 board의 ref해소 열을 교차독해하지 못하고 KEEP 태깅.
- **최종 채택**: **EXTEND**(ref .03을 올바른 스타드림 종이 코드로 재배선) + evaluate_price PRICE≠0 게이트. 실무진 IMPORT 존중(삭제 아님·ref 목적지 교정). 근본은 [[goods-material-contamination-260630]] 굿즈 자재오염의 **옵션-아이템 ref 잔재**(product_materials 정리 6상품 COMMIT 후에도 옵션 ref 층 미교정) → §7 dbmap 재배선.
- **주의**: 이 오매핑이 다른 스타드림 보유 상품에도 있는지 board 전수확인 → 아래 R-4.

### R-4. PRD_047 종이 — EXTEND 유지, 단 **근거 "1종 미실재"→"미실재 1 + 의미오매핑 3"으로 확장**
- **Claude 판정**: EXTEND · `부분(46/47 일치)` · 근거="1종 미실재 → 그 용지 선택 시 견적0".
- **codex 판정**: AGREE(EXTEND 방향)이나 근거 부족 지적.
- **board 재확인**: PRD_047 종이 중 `스타드림(실버)→MAT_000128(면끈)`·`골드→MAT_000129(아크릴키링고리)`·`로즈쿼츠→MAT_000130(네오디움자석)` = **의미 오매핑 3종**. "46/47 일치"의 "일치" 카운트가 트리거-존재만 보고 의미오매핑을 **일치로 오집계**함.
- **최종 채택**: EXTEND 유지, 처방 = "미실재 1종 배선 + **의미오매핑 3종 ref 목적지 교정**". PRD_042와 동일 오염 패턴.

## 3. 불일치 → 라벨 정형화로 수렴

### R-5. PRD_037 박종류(opt_cd) — EXTEND → **EXTEND-BLOCKED**(가격종속 정식 분리)
- **Claude 판정**: EXTEND(spec §3-D) + 각주 "가격종속=Y → 재배선은 evaluate_price PRICE≠0·이중합산 0 입증 후에만(BLOCKED성)". 요약표 22행도 "EXTEND 1건(037)이 가격종속→가격무손상 입증 게이트".
- **codex 판정**: DISAGREE — 각주로 두지 말고 **정식 BLOCKED로 분리**해야(criteria §4: 대체 placement 가격보존 입증 전까지 BLOCKED).
- **판정**: 실질 이견 없음(양측 모두 "PRICE≠0 입증 전 재배선 금지"). 라벨 이견만 — Claude=EXTEND(게이트 각주), codex=BLOCKED. criteria §4 규범이 가격종속 재배선을 **BLOCKED 분리**로 명문화하므로 codex 라벨이 규범 정합.
- **최종 채택**: **EXTEND-BLOCKED**(처분=EXTEND·상태=BLOCKED). opt_cd 가격모델([[addon-optcd-model-broken-live]])→.03+.04 BUNDLE 재배선은 evaluate_price PRICE≠0·이중합산 0 입증 후에만 실행. 선택지(일반박/홀로그램)는 그대로 유지(손실 0).

## 4. codex UNCERTAIN → 위임 큐 (미수렴·현 처분 유지)

### R-6. 무옵션 9상품(034/035/036/039/043/044/045/048/049) — EXTEND 유지 + §21 권위 재확인 위임
- **codex**: UNCERTAIN — 근거가 전부 `§21 cpq-defect-board 기대옵션` 인용(4파일 밖). base-info only로 충분한 단일축인지 검증 불가.
- **판정**: codex의 "base-only 충분 가능성"은 **미검증 가설**(codex-verdict §2-1) → 사실 채택 안 함. 동시에 Claude의 "EXTEND(옵션레이어 신설)"도 §21 인용에 의존 → 위임 트랙(§7 dbmap Tier-A 신설)에서 260702 권위·라이브 옵션 실재로 재확인.
- **최종**: 현 **EXTEND 유지**(선택지 손실 유발 없음·신설 방향은 보수적으로 안전). 단 각 상품 기대옵션 목록은 §21/라이브로 확정 후 착수(현 board는 방향만).

---

## 5. 환각/기각 (codex 주장 중 board와 불일치 없음)

- codex가 존재하지 않는 테이블/컬럼을 언급한 사례 **없음**(board 실 컬럼·MAT 코드만 인용). 환각 기각 대상 0.
- codex 단독 미검증 가설 2건(R-6 base-only·R-5 BUNDLE 가격보존)은 사실 채택 없이 위임 큐로만 기록.

## 6. 최종 수렴 상태 (LG7 인계)

- **합의 2 · 정정 2(codex 옳음) · 라벨수렴 1 · 위임(미수렴) 1.**
- Claude 처분 명세 갱신 필요분(→ Phase 2 board/spec 반영 또는 §7 위임):
  1. **PRD_042 종이 스타드림 4항목: KEEP→EXTEND**(ref 의미오매핑 재배선·가격게이트). [★board 자체증거로 검증]
  2. **PRD_047 종이: EXTEND 근거 확장**(미실재 1 + 의미오매핑 3).
  3. **PRD_037 박종류: EXTEND→EXTEND-BLOCKED**(가격종속 정식 분리).
  4. 무옵션 9상품: EXTEND 유지 + 기대옵션은 §21 권위 재확인 후 확정(divergence 잔존 1).
- **오차단 0 불변**: 위 정정 전부 "재배선/보강/게이트"이지 선택지 제거 아님 → 손님 선택지 손실 0 유지.
- **최종 잣대**: 정정분(042/047) 재배선 후 evaluate_price **PRICE≠0**로 위임 트랙(§7) 검증 의무.
