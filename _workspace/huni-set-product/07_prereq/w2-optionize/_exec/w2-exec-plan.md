# W2 CPQ 옵션화 — 고신뢰 COMMIT 범위 안전 프로토콜 실행 계획 (_exec)

> 빌드만 — 실 COMMIT/INSERT/DELETE 금지. SQL 파일 작성 + DRY-RUN 검증 SELECT 까지.
> 실측일 2026-06-25 · 권위 = w2-commit-scope.md + w2-codex-reconcile.md + 라이브 실측.
> 식별자/코드/SQL 영문, 서술 한국어. _exec 패턴 = ZR-1 동일(backup/apply/dryrun/undo).

---

## 1. COMMIT 범위 (머그컵 제외 = 고신뢰분만)

| 트랙 | 그룹 | 옵션 | 아이템 | 대상 상품 |
|---|---|---|---|---|
| T1 면지 | 4 | 14 | 14 | PRD_072·077·082·088 |
| T3 즉시 | 5 | 15 | 15 | PRD_140·142·197·198·217 |
| **합계** | **9** | **29** | **29** | **9 상품** |

- 머그컵(PRD_193) = **HOLD 제외**: codex 가 의미축 분류(투명도 2택1 vs 본체종류 3~4택1) 근거 불명 적발(reconcile §3-A). 라이브 4자재(투명143/반투명146/화이트255/화이트머그268) 전부 dflt_yn='Y'·disp_seq=1 동일 → 본체/색옵션 구분 단서 0. 상품마스터 엑셀 재큐레이션 + 실무진 컨펌 전까지 미적재. 9상품과 분리 적재 가능.
- reconcile 종합판정과 정합: 고신뢰(합의) = 9상품/9그룹/29옵션, HOLD = 머그컵 1그룹/2옵션.

## 2. 채번 처리 방식 — **연속 재정렬(빈 번호 없이)**

원본 load CSV 는 머그컵을 범위 중간에 포함(OPT_000068·OPV_000448·449). 머그컵 제거 시 두 방식이 가능:
- (A) 머그컵 번호만 비우고 나머지 유지 → OPT_000068·OPV_000448·449 가 영구 갭.
- (B) **연속 재정렬** → 머그컵 이후 행을 한 칸씩 당김. ← **채택**

### 채택 근거 (B)
1. 라이브 MAX(OPT_000063 / OPV_000433) 직후로 **빈 번호 없이 연속** → 다음 트랙이 MAX+1 잡을 때 갭 혼란 없음.
2. surrogate PK 는 의미 없는 일련번호 → 재정렬에 정보 손실 0.
3. 머그컵 HOLD 해제 시 그때의 MAX+1 로 신규 채번하면 됨 → 번호를 비워둘 이유 없음.
4. 멱등·충돌: 두 방식 모두 라이브 충돌 0(사전 SELECT 확인)이나 (B)가 연속성에서 우월.

### 재정렬 매핑 (원본 CSV → COMMIT 확정본)

| 레벨 | 머그컵 제거 | 이후 행 당김 |
|---|---|---|
| opt_grp_cd | OPT_000068 삭제(머그) | 면지 OPT_000064~067 유지 · 140~217 그룹 = **OPT_000068~072** (원 069~073 → 한 칸 당김) |
| opt_cd | OPV_000448·449 삭제(머그) | 면지 OPV_000434~447 유지 · 140~217 옵션 = **OPV_000448~462** (원 450~464 → 두 칸 당김) |

- 확정 채번: opt_grp **OPT_000064~OPT_000072** (9 연속) · opt **OPV_000434~OPV_000462** (29 연속).
- 확정본 CSV: `_exec/load_committable/*.csv` 3종(머그컵 제외·재정렬 반영). 원본 `../load/*.csv`(머그 포함 10/31/31)는 보존.

## 3. 라이브 재실측 (2026-06-25, 읽기전용 SELECT)

| # | 확인 | 결과 |
|---|---|---|
| MAX | opt_grp / opt 최대 | OPT_000063 / OPV_000433 → 설계 +1 연속 ✓ |
| 트리거 | fn_chk_opt_item_ref OPT_REF_DIM.03 분기 | (prd_cd,mat_cd,usage_cd) EXISTS 만 검사 · **del_yn 미필터**(codex N1=사실) |
| PK | 3테이블 | groups(prd_cd,opt_grp_cd)·options(prd_cd,opt_cd)·items(prd_cd,opt_cd,item_seq) |
| 트리거부착 | option_items | trg_..._chk_ref (BEFORE INSERT OR UPDATE) 실재 |
| ref EXISTS | 29 item del_yn=N | total=29 / EXISTS=29 / del_yn=N 통과=29 (FAIL 0) |
| 돈영향 | 15자재 component_prices | **0행** |
| 중복 | 9상품 기존 option_group | **0행** |
| 충돌 | 신규 채번 PK 범위 사전 점검 | grp 0 / opt 0 |

## 4. 안전 프로토콜 SQL (4종 · ZR-1 _exec 패턴)

| 파일 | 역할 |
|---|---|
| `w2-backup.sql` | 9상품 기존 옵션 3계층 스냅샷 → bak_*_w2opt_<ts> 3종(SELECT INTO·원본 무변경). 현재 0행 정상(안전망). |
| `w2-apply.sql` | 단일 BEGIN…COMMIT. groups→options→option_items(FK 위상). 전 INSERT ON CONFLICT (PK) DO NOTHING(멱등). ★실 COMMIT 은 메인 수행. |
| `w2-dryrun.sql` | BEGIN…**ROLLBACK**. 실 INSERT 로 트리거 실제 통과 입증 + 검증 SELECT ①~⑥. 라이브 무변경. |
| `w2-undo.sql` | 역 위상 DELETE(items→options→groups). 신규 채번 PK 범위(OPT_000064~072 / OPV_000434~462)로만 정확 삭제 → 기존·머그컵 불간섭. 백업 복원 블록 병행(주석). |

## 5. DRY-RUN 검증 SELECT 기대치 (w2-dryrun.sql)

| # | 검증 | 기대치 |
|---|---|---|
| ① | 29 option_item INSERT 가 트리거 fn_chk_opt_item_ref 실제 통과(EXISTS 사전체크 아님 — INSERT 실발화로 무예외 도달) | items_inserted=**29** (예외 시 ON_ERROR_STOP 중단=NO-GO) |
| ② | **N1 보완**: ref(prd_cd,mat_cd,usage_cd)가 가리키는 자재행이 del_yn='N'으로 실재 명시 확인 | items=29, deln_resolved=**29** |
| ③ | FK 무결성: option_group→상품·option→그룹·item→option 고아 0 | 세 행 전부 **0** |
| ④ | PK 중복 0(신규 채번 충돌): 적재 신규 행수 | groups=**9** / options=**29** / items=**29** (pre 0/0 이므로 곧 신규분=충돌 0) |
| ⑤ | 멱등 2-pass delta 0: 동일 INSERT 재실행 후 변화 없음 | groups=9 / items=29 (불변) |
| ⑥ | 돈영향: 15자재 component_prices 단가행 | price_rows=**0** |

- ON_ERROR_STOP on → 트리거 EXCEPTION 1건이라도 발생 시 즉시 중단(=DRY-RUN FAIL 신호).
- 가드(codex N1): 트리거 자체엔 del_yn 필터 없으므로 검증②가 별도로 del_yn='N' 실재를 명시 확인.

## 6. undo 전략

- **정밀 삭제**: 신규 채번 surrogate PK 범위(OPT_000064~072 / OPV_000434~462)로만 DELETE → 기존 옵션·머그컵·타 상품 절대 미간섭.
- **역 위상**: option_items → options → option_groups (FK 자식 먼저).
- **백업 복원 병행**: w2-backup.sql 의 bak_*_w2opt_<ts> 가 비어있지 않은 경우(이전 부분 적재 보존 시나리오)에만 :ts 치환 후 복원 블록 활성화. 현재는 9상품 기존 옵션 0행이므로 복원 대상 없음(정상).
- 기본 ROLLBACK(시험). 실 되돌리기 시에만 COMMIT 으로 교체.

## 7. 경계·미적용 사항

- **빌드만**: 실 COMMIT/INSERT/DELETE 0. SQL 파일 작성까지. 실행은 메인이 인간 승인 후.
- **머그컵 제외 확정**: 모든 SQL·CSV에서 PRD_193·OPT(머그)·OPV_000448·449(원본 머그) 부재. HOLD 사유 = reconcile §3-A.
- **신규 mint = option layer 만**: 자재/상품/차원 신규 0(전부 기존 라이브 참조).
- 후속 미해결(reconcile §6): 머그컵 의미축 컨펌, 면지 링/D링 W2 포함 여부(§3-B 명세 갭), dflt 실판매 기본 컨펌(N3).
