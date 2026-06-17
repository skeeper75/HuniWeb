# 네이밍 표준화 적재 실행본 매니페스트 (round-34 · `_exec_naming/`)

> **산출자:** dbm-load-builder · 2026-06-18 · 조립자=생성자(자기 GO 금지 — 검증은 dbm-validator)
> **대상:** 라이브 `t_prc_price_components` (db `railway`)
> **권위(verbatim):** `34_naming-standardization/component-naming-cleanup.md`(v2) · `standard-term-dictionary.md`(v2) · `naming-domain-refinement.md`
> **상태:** 롤백전용 DRY-RUN 통과 · **실 COMMIT 미실행(인간 승인 대기)**

---

## 1. 작업 정의
가격구성요소 `comp_nm`/`note`를 실무진 표준 한글 용어로 UPDATE (코드노출 `[COMP_xxx]` 제거 + 컨펌 해소 반영 + note/comp_typ_cd 빈값 보강).
**comp_nm/note(+TATTOO comp_typ_cd 1건)만 변경. 가격행·use_yn·배선 무변경. INSERT/DELETE 0.**

## 2. 대상 행수 (라이브 실측 2026-06-18 · DRY-RUN 실증)
| 구분 | 행수 | 비고 |
|---|---|---|
| comp UPDATE 대상행(distinct comp_cd) | **111** | comp_nm 110 + note 2 + both 1 (중복 제거 111) |
| ─ comp_nm 변경 | 110 | (109 name-only + 1 both[TATTOO]) |
| ─ note 변경 | 2 | COMP_ACRYL_COROTTO(note-only) · COMP_STK_TATTOO(both) |
| comp_typ_cd 보강 | **1** | COMP_STK_TATTOO → `PRC_COMPONENT_TYPE.06` |
| **합계 변경 행수** | **111** | (TATTOO는 1행에서 comp_nm+note+typ 동시) DRY-RUN `changed_rows=111` |
| 코드노출 102 → | **2** | 제외한 빈더미 2건만 잔존 = **목표(빈더미 제외 코드노출 0) 달성** |

구성(권위 §): A-1 명함 19 · A-2 오리지널박명함 4 · A-3 동판셋업 2 · A-4 제본비 11(코드노출 8 + 통일정정 3) · A-5 접지 7 · A-6 타공 1 · A-7 커팅합가 3 · A-8 엽서북 4 · A-9 포토카드 3 · A-10 스티커/떡메/합판/타투 5 · A-11 포스터본체 23(활성 17 + 레거시 6) · A-12 add-on 21(빈더미 2 제외) · B 소폭보정 7 · C note보강 1(COROTTO). = 111 distinct.

## 3. 제외분 (task §4 — 이번 적재 대상 아님)
| comp_cd | 사유 | 결과 |
|---|---|---|
| COMP_POSTEROPT_BANNER_MESH_PROC_OPT | 가격행 0행 빈 더미 (use_yn=N 검토 별도) | 코드노출 유지(2건 중 1) |
| COMP_POPT_BNR_GAKMOK_STR_900_4 (base) | 가격행 0행 base 빈 더미 (_GT/_LE만 활성) | 코드노출 유지(2건 중 1) |

→ 적재 후 코드노출 잔존 2건은 **의도적**(빈더미 별도 검토). 빈더미 제외 코드노출 = **0**.

## 4. BLOCKED (치환안 미확정으로 제외)
- **없음.** cleanup v2 치환안에 빈칸/미확정 comp 없음 → 전건 표준 문안 verbatim 확보. (PROC_OPT 한글명 미확정분은 §3 제외에 해당하여 BLOCKED 아님)

## 5. 멱등키 / 멱등 메커니즘
- 자연키 = `comp_cd` (PK). 모든 UPDATE에 `comp_nm/note/comp_typ_cd IS DISTINCT FROM 목표값` 가드 → 2회차 0행.
- DRY-RUN PASS-2 실측: `pass2_changed_rows = 0` (멱등 입증).
- INSERT/ON CONFLICT 없음 — 순수 가드형 UPDATE(자연키 기존행 대상).

## 6. 산출물
| 파일 | 역할 |
|---|---|
| `gen_naming_sql.py` | 생성기(cleanup v2 verbatim 매핑·재현성). `_naming_updates.sql` 산출. 손편집 금지 |
| `_naming_updates.sql` | 생성된 멱등 가드 UPDATE 블록(comp 111 + typ 1). apply/dryrun이 `\i` |
| `_naming_undo.sql` | pre-state(라이브 2026-06-18) 원복 블록(111행·멱등) |
| `apply.sql` | 단일 트랜잭션 BEGIN…(COMMIT/ROLLBACK은 로더 주입)·자가점검 SELECT 3종 |
| `dryrun.sql` | 롤백전용 DRY-RUN(before/after·멱등 2-pass·가격행/use_yn 무변경·컨펌 해소) |
| `backup_undo.sql` | 현재값 백업 SELECT + (-v run_undo=1) 원복 |
| `apply.sh` | psql 로더(기본 dryrun·apply·--commit·backup·undo). 비밀값 미출력 |
| `manifest.md` | 본 문서 |

## 7. 자가 점검 (DRY-RUN 실측 — 자기 GO 아님 · 검증=dbm-validator)
라이브 롤백전용 DRY-RUN(`./apply.sh dryrun`) 2026-06-18 결과:
- [관측] 코드노출 before 102 → after **2**(빈더미) · 빈더미 제외 코드노출 **0**
- [관측] use_yn=Y note 빈값 2 → **0** · comp_typ_cd 빈값 1 → **0**
- [관측] 실제 변경 행수 = **111**
- [관측] 가격행(component_prices) 변동 = **0행** · use_yn 변동 = **0행**
- [관측] 멱등 2-pass = **0행 변경**
- [관측] 컨펌 해소 반영: 귀돌이비·큐방·열재단·봉미싱·각목(900mm 초과/이하)+끈·오리지널박명함 등 표준 한글명 적용 확인
- [관측] ROLLBACK 완료 · 라이브 사후 재조회 코드노출 = **102 유지**(DRY-RUN 무흔적)
- [경계] 실 COMMIT 미실행. DDL/INSERT/DELETE 0. 비밀값 미출력.

## 8. 다음 단계
1. **dbm-validator** 독립 검증(코드노출 잔여·문안 verbatim·무변경 불변식·멱등·컨펌 해소·rpmeta naming 유입 0).
2. 검증 GO + **인간 승인** 후 `./apply.sh --commit` (백업: `./apply.sh backup > backup_260618.txt` 선행 권장).
3. 빈더미 2건(PROC_OPT·GAKMOK base) use_yn=N 정리는 **별도 트랙**(이번 범위 외).
