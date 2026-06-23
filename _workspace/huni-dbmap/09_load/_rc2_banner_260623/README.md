# _rc2_banner_260623 — RC-2 일반현수막 가공/추가 옵션 바인딩 적재본

§21 RC-2 파일럿. 일반현수막(PRD_000138·공식 PRF_POSTER_BANNER_N)의 가공/추가 옵션 6 comp를
종단 배선(use_dims 판별차원 충전·단가행 opt_cd 충전·공식 addtn_yn=Y 바인딩). **단가 verbatim 불변**.

## 실행 (기본 DRY-RUN·COMMIT 안 함)
```
./apply.sh            # DRY-RUN(롤백전용) — 아무것도 커밋 안 됨
./apply.sh commit     # ★인간 승인 후에만 — 실제 적재(COMMIT)
```
재생성(손편집 금지): `python3 gen_load_sql.py`
종단 재계산: `python3 evaluate_trace.py`

## 파일
- `mapping.csv` — 충전 매핑(comp·use_dims·단가행 opt_cd·바인딩)
- `gen_load_sql.py` → `01_use_dims.sql`·`02_opt_fill.sql`·`03_formula_components.sql`·`apply.sql`
- `apply.sh`(로더·기본 dryrun) · `backup.sql`(롤백 스냅샷) · `load.provenance.csv`
- `verbatim-guard.md` · `dryrun-log.md` · `evaluate-trace.md`(+`evaluate_trace.py`·`_pricing_pure.py`)
- `exec-report.md` — 종합 보고(스코프·CONFIRM-A·DRY-RUN·종단·BLOCKED)

## 안전
라이브 읽기전용+롤백 DRY-RUN만. 단가행 단가 미변경(가드: UPDATE WHERE에 단가 검증값).
기초코드 마스터 불변·search-before-mint·DB 영구쓰기 0. 생성자≠검증자(dbm-validator R1~R6 후 인간 승인).
