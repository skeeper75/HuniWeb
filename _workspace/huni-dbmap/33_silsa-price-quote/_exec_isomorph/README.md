# _exec_isomorph — 실사 동형 가격구성요소 결합 실행본

round-23 실사(포스터/사인) 동형 가격테이블 결합. **comp 레벨 UPDATE 19행 · INSERT/DELETE 0 · 단가행 보존.**
권위: `../silsa-isomorph-merge-design.md` · 통합모델 `../grouping-model-design.md`. 검증/GO=dbm-validator.

## 실행법
```bash
./apply.sh              # 기본 DRY-RUN: apply.sql 롤백전용 (COMMIT 0)
./apply.sh dryrun-full  # 검증본: before/after/골든/고아·중복·동시매칭/단가행/2-pass 멱등 (BEGIN…ROLLBACK)
./apply.sh commit       # 실 COMMIT — 인간 승인 후만 (돈-크리티컬)
```
- `.env.local`의 `RAILWAY_DB_*`만 사용. 비밀번호 stdout/로그/`_workspace` 미기록.
- 기본 모드 = 롤백. COMMIT은 `commit` 인자로만.

## 재생성 (재현성)
```bash
python3 gen_load_sql.py   # apply.sql·dryrun.sql·backup_undo.sql·apply.provenance.csv 재생성
```
SQL 손편집 금지 — 항상 생성기 경유.

## DRY-RUN 실증 결과 (2026-06-18)
- 1차 APPLY: 19 UPDATE / 2차 APPLY: 전건 UPDATE 0 (멱등 PASS)
- 배선 정본 6/6 · 레거시 use_yn=N 6/6 · 정본2+단독5 comp_nm/note 갱신 7/7
- 골든 CANVAS=37,800·ARTPRINT=21,600 (결합 전 레거시 동일·가격 불변)
- 고아 0 · 중복배선 0 · 동시매칭 0 · 단가행 684 보존 · POST-ROLLBACK 원복(COMMIT 0)

## undo
적용 후 원복: `backup_undo.sql` — 적용 직전 백업 SELECT 결과 보관 → undo UPDATE(배선·use_yn 결정적·comp_nm/note는 백업값으로 채워 실행).
