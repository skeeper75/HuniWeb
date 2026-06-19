# 자재 축 (t_mat_materials) — reconcile (D4 게이트)

codex 가용성: **AVAILABLE model=gpt-5.5** (preflight EXIT=0·실호출 session 019eddcc·종량과금 없음)
입력: Phase2 mapping.csv·dedup-report.md·apply-plan.md / codex-verdict.md(원문+환각경계) / 라이브 read-only 재실측
권위: 상품마스터 260610 calendar-l1 · 상위 진단 dbmap C-CAL-01(round-13/22)

---

## 행별 reconcile (Claude ↔ codex ↔ 합의)

| 항목 | Claude(Phase2) | codex(2차) | 라이브 검증 | 합의/divergence |
|---|---|---|---|---|
| **MAT_000032 정체** | stale 오적재 잔재(.02 무관·권위/BOM/cp 전무) | stale mis-load remnant(동일) | type.02·authority부재·BOM0·cp0·자식0·optitem ref0 → **고아 확정** | **합의** (032=stale) |
| **MAT_000032 처분** | **C(보류)** — 표면정리가 252 canonical 확정→C-CAL-01 선점 | **A(단독 soft-delete)** — 032는 양 시나리오 junk·252 canonical 확정 아님 | 032 참조 전무(삭제 손실 0)·252 BOM 보존·process 0행 | **★DIVERGENCE** (핵심) |
| **MAT_000252 처분** | 무변경(축이동 대기) | 무변경(interim target·최종 canonical 선언 금지) | BOM1(PRD_000108) 보존·optitem 미이전 | **합의** (무변경) |
| **MAT_000254 처분** | 무변경(BLOCKED) | 무변경(축이동 대기) | BOM1(PRD_000109) 보존 | **합의** (무변경) |
| **MAT_000033 처분** | BLOCKED(평행구조·C-CAL-01 공동) | **scope out** — display-dup 아님(이름 상이)·별도 트랙 | 033 mat_nm≠254 mat_nm·BOM0 | **DIVERGENCE** (BLOCKED vs scope-out — 둘 다 무변경이라 액션 동일) |
| **가격 무영향** | 4코드 cp0 | 4코드 cp0 | 전건 cp0 라이브 확인 | **합의** |

---

## DIVERGENCE 처리

### D-1 (핵심): MAT_000032 — C(총보류) vs A(단독 soft-delete)

- **Claude 논거**: 032 삭제·252 정본 채택(A안)은 252를 '정본 자재'로 못박아 C-CAL-01의 "252/254 공정 param 이전 후 논리삭제"를 선점.
- **codex 반론**: 032 **단독** soft-delete는 252의 자재 지위를 확정하지 않는다(252는 손대지 않음). 032는 (a)252가 자재로 남으면 display-dup stale, (b)252가 process로 가도 authority없음+BOM0+wrong-type orphan → **양 시나리오 모두 junk**.
- **라이브 검증(결정적)**: 032는 BOM0·cp0·자식0·option_items ref0 — **어느 미래에서도 잃을 참조가 0**. 252/254는 무변경이므로 C-CAL-01 축이동 결정은 그대로 열려 있음.
- **판정**: **codex 채택.** Claude의 "C-CAL-01 선점" 논거는 *A안 원안(032 삭제 + 252를 canonical로 명시 채택)*에는 타당했으나, codex가 분리한 *"032만 삭제·252 무선언"* 변형에는 적용되지 않는다. Claude 1차의 과보수를 codex가 정확히 적발. **표시중복(032/252 동일 mat_nm)도 032 삭제로 해소**(252 단일 정본이 자연 결과·자재축 잔류 여부와 무관).
- ★단, 적재 시 [HARD] 가드: **252를 "정본 자재"로 명시/선언하는 SQL·주석 금지**(use_yn/del_yn/note 무변경). 032 한 행만 논리삭제(del_yn='Y'·use_yn='N' 둘 다·권위 [[dbmap-del-yn-soft-delete-authority]]).

### D-2: MAT_000033 — BLOCKED vs scope-out

- 둘 다 **라이브 무변경**이라 실질 액션 동일. codex 지적(033은 display-dup 아님·이 하네스 범위 밖)이 더 정확한 분류. 033/254는 C-CAL-01/normalization 트랙으로 scope out(현 라운드 무변경 유지). divergence이나 **무해**(액션 일치).

---

## 최종 판정 (D4 게이트)

**BLOCKED 인계가 아니라 — 안전 정리분 1건 존재.** codex 2차가 Claude 1차의 false-negative(과보수 total-hold)를 적발했고, 라이브 재실측이 codex 추론을 검증함.

| 분류 | 멤버 | 액션 | 근거 |
|---|---|---|---|
| **✅ 안전 적재(A)** | MAT_000032 삼각대(그레이) | **논리삭제**(del_yn='Y'·use_yn='N') | stale 오적재(.02·authority부재)·참조 전무(BOM/cp/자식/optitem 0)·삭제 손실0·표시중복 해소·252 무선언으로 C-CAL-01 비선점 |
| ⏸ 무변경(축이동 대기) | MAT_000252·MAT_000254 | 무변경 | BOM 보존·process 0행 mint 선행 → C-CAL-01 트랙 인계 |
| ⏸ 무변경(scope-out) | MAT_000033 | 무변경 | display-dup 아님·normalization/축이동 트랙 |

- **안전 적재 1건**(MAT_000032 논리삭제) · 무변경 3건 · 가격 무영향(전건 cp0).
- D4 합의: 핵심 divergence(D-1)는 **라이브 검증으로 해소 → codex 채택**. 잔존 미해소 divergence 0. → **D4 GO** (executor 적재 가능: MAT_000032 단독 멱등 논리삭제 + [HARD] 252 무선언 가드).
- BLOCKED 인계는 252/254/033만(축이동 트랙·무손실 보존 요건 apply-plan 보존).

## D4 권고

- **가용 경로**: codex AVAILABLE·합의 도달 → **고신뢰 진행**. executor가 MAT_000032 한 행 논리삭제(백업→DRY-RUN→승인→COMMIT·멱등 WHERE del_yn='N' 가드).
- 적재 SQL [HARD] 제약: 032만 UPDATE·252/254/033 미접촉·252 canonical 선언/note 추가 금지.
- 잔여 BLOCKED(252/254 축이동·033 normalization)는 round-22 ④/B-3·basecode §12 인계 유지.
