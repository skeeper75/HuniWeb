# W2 CPQ 옵션화 1차 — 고신뢰 9그룹 라이브 COMMIT 실행 리포트

생성: §23 huni-set-product `07_prereq/w2-optionize/_exec` · 라이브 Railway DB(`db railway`, 비표준 포트) · 인간 승인(사용자 AskUserQuestion "codex 검증→게이트→COMMIT" 직접 선택)
권위: 상품마스터 260610(면지 disp_seq·색 라벨) + 라이브 트리거 `fn_chk_opt_item_ref`(OPT_REF_DIM.03) + w2-design.md + w2-codex-reconcile.md(reconcile §5 고신뢰)
원칙[HARD]: search-before-mint(차원/자재 신규 mint 0·option layer만) · 멱등(ON CONFLICT DO NOTHING) · FK 위상(groups→options→items) · 생성≠검증(codex 독립 2차)

> **결론 한 줄**: W2 고신뢰분 **9 option_group / 29 option / 29 option_item COMMIT 성공**(T1 면지 4 + T3 즉시 5). 트리거 실 INSERT 통과 29/29·옵션 ref 활성자재 해소 29/29·돈영향 0·머그컵(T2) HOLD. 채번 OPT_000064~072·OPV_000434~462.

---

## 1. COMMIT 범위 (머그컵 제외)

| 트랙 | 상품 | opt_grp | 옵션 | 변형축 |
|---|---|---|---|---|
| T1 면지 | PRD_072·077·082·088 | OPT_000064~067 | 화이트·블랙·그레이(·인쇄 082/088만) | 색축(USAGE.03) |
| T3 즉시 | PRD_140·142·197·198 | OPT_000068~071 | 화이트·블랙(255/256) | 색축(USAGE.07) |
| T3 즉시 | PRD_217 만년스탬프 | OPT_000072 | 잉크 7색(297~303) | 색축(USAGE.07) |
| **합계** | **9 상품** | **9** | **29** | — |

- **제외(HOLD)**: T2 머그컵(PRD_193, 투명143/반투명146) — codex 의미축 분류 불명(투명도 2택1 vs 본체종류 3~4택1)·라이브 4자재 dflt/disp_seq 무차별로 구분 단서 0. 상품마스터 재큐레이션+실무진 컨펌 후 별도 적재.
- 면지 disp_seq 권위: 상품마스터 `제본(옵션)_면지(옵션)` 컬럼 행순서 = 화이트→블랙→그레이→인쇄.

## 2. 채번 (MAX+1 연속 재정렬)

- 라이브 MAX 재확인: OPT_000063 / OPV_000433.
- 확정: opt_grp OPT_000064~OPT_000072(9) · opt OPV_000434~OPV_000462(29). 머그컵 제거분 연속 재정렬(빈 번호 0). surrogate PK·이름기반 멱등.

## 3. 백업 (undo 가역)

| 백업 테이블 | 비고 |
|---|---|
| `bak_opt_groups_w2opt_20260624215218` | 적재 대상 9상품 기존 opt_group 스냅샷(신규 적재라 0행) |
| `bak_options_w2opt_20260624215218` | 기존 option 스냅샷(0행) |
| `bak_opt_items_w2opt_20260624215218` | 기존 option_item 스냅샷(0행) |

복원 = `w2-undo.sql`(신규 채번 PK 기준 정확 삭제). 신규 INSERT라 백업은 빈 스냅샷·undo는 신규행 DELETE.

## 4. DRY-RUN (BEGIN…ROLLBACK · 메인 독립 재확인)

| 검증 키 | 기대 | 실측 | 판정 |
|---|---|---|---|
| pre PK 충돌(grp/opt) | 0 / 0 | 0 / 0 | PASS |
| INSERT groups/options/items | 9/29/29 | 9/29/29 | PASS |
| ① 트리거 실 INSERT 통과(item) | 29 | 29 | PASS |
| ② N1 보완: ref del_yn='N' 해소 | 29 | 29 | PASS |
| ③ FK 고아(grp/opt/item) | 0/0/0 | 0/0/0 | PASS |
| ④ 신규 행수(채번 충돌 0) | 9/29/29 | 9/29/29 | PASS |
| ⑤ 멱등 2-pass delta | 0 | 0 | PASS |
| ⑥ 돈영향(15자재 단가행) | 0 | 0 | PASS |

ROLLBACK 후 라이브 무변경.

## 5. 실 COMMIT

w2-backup.sql → w2-apply.sql. psql 출력:
```
=== APPLY (COMMIT) ===
BEGIN
INSERT 0 9
INSERT 0 29
INSERT 0 29
적재 후: groups 9 / options 29 / items 29
COMMIT
```
→ **COMMIT 성공.**

## 6. 사후 재실측 (라이브 실측)

| 검증 | 기대 | 실측 | 판정 |
|---|---|---|---|
| 라이브 group/option/item(del_yn=N) | 9/29/29 | 9/29/29 | PASS |
| 옵션 ref가 활성자재 해소 | 29 | 29 | PASS |
| 머그컵(PRD_193) 적재 | 0 | 0 | PASS (HOLD) |
| 돈영향(13자재 단가행) | 0 | 0 | PASS |
| 상품별 옵션수 | 3·3·4·4 / 2·2·2·2 / 7 | 일치 | PASS |

## 7. codex 교차검증 반영

- reconcile §5 고신뢰 합의분(T1+T3)만 COMMIT. 머그컵 HOLD.
- N1(트리거 del_yn 미필터) → 검증 SELECT에 `del_yn='N'` 명시 확인 내장.
- N3(mand_yn+dflt 강제선택) → 면지/색은 상품 필수 속성이라 택1 mandatory+default 적정(reversible·돈0·향후 조정 가능)으로 채택.
- 링/D링 명세 누락 → w2-deferred.md CONFIRM 큐 등재(후속).

## 8. 경계·롤백

- **9그룹만 COMMIT.** 머그컵·BLOCKED-needs-L1 ~36·CONFIRM ~30 미접근.
- 멱등(ON CONFLICT DO NOTHING). 신규 mint = option layer만(차원/자재/상품 0).
- undo 경로: `w2-undo.sql`.

## 9. 산출물

| 파일 | 역할 |
|---|---|
| `w2-backup.sql` | 백업 3종 |
| `w2-apply.sql` | 단일 트랜잭션 INSERT(9/29/29·멱등) |
| `w2-dryrun.sql` | BEGIN…ROLLBACK 6검증 |
| `w2-undo.sql` | 신규행 삭제·백업 복원 |
| `w2-exec-plan.md` | 빌드 계획 |
| `w2-exec-report.md` | 본 리포트 |
| `load_committable/` | 재정렬 확정본 CSV 3종 |
