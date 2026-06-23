# _rc2_addon_unblocked_260623 — RC-2 추가물형(비BLOCKED) 적재본

§21 RC-2 추가물형 3상품(메쉬139·캔버스133·린넨134) CPQ 옵션+가격사슬 적재본. PET(136)=HOLD-1 BLOCKED 제외.
**DB 미적재** — 멱등 SQL + 롤백전용 DRY-RUN까지. 실 COMMIT은 dbm-validator R1~R6 + 인간 승인 후.

## 파일
- `mapping.csv` — 진실 소스(전 행 매핑·provenance). 손편집 금지·`gen_load_sql.py`가 권위.
- `gen_load_sql.py` — mapping.csv → SQL 4단 생성기(reproducible·disp_seq 정수 가드).
- `01_options.sql` — 신규 CPQ 옵션 INSERT(멱등 NOT EXISTS).
- `02_use_dims.sql` — comp use_dims 판별차원 충전(멱등 IS DISTINCT FROM·always-add 가드).
- `03_price_fill.sql` — 단가행 opt_cd 충전 + RC-4 siz_cd 재배선(단가 verbatim·멱등).
- `04_formula_components.sql` — 공식 바인딩 UPSERT(addtn_yn=Y·disp_seq).
- `apply.sql` — BEGIN…ROLLBACK 트랜잭션 래퍼(FK 위상순서).
- `undo.sql` — 역위상 원복(단가 불변).
- `apply.sh` — 로더(기본 DRY-RUN·`commit`/`undo`/`undo-commit` 인자).
- `manifest.md` — 전 행 1:1·현재값↔설계값·실측 근거·멱등 근거.
- `dryrun-result.md` — DRY-RUN 증거(영향행수·제약위반0·멱등2-pass·always-add 입증·undo 정합).
- `load.provenance.csv` — 행별 출처 추적.

## 재현
```
python3 gen_load_sql.py     # SQL 재생성
./apply.sh                  # DRY-RUN (롤백전용·무커밋)
./apply.sh undo             # DRY-RUN 원복
# ── 인간 승인(검증 GO) 후에만 ──
./apply.sh commit           # 실 적재 COMMIT
```

## 핵심 사실 (라이브 실측 2026-06-23)
- 가격=단가행 opt_cd/siz_cd 단독 판별(option_item=MES 환원·가격 독립·본 적재본 제외).
- always-add 가드: use_dims에 opt_cd 추가 + 단가행 opt_cd 충전 → "출력만" 미선택 시 가산 0(입증됨).
- RC-4: 캔버스 우드행거 siz_cd 258/315/317(133 미등록)→172/174/197(동일 치수) 재배선.
- 단가 verbatim 전건 불변·신규 그룹 0·opt_cd 채번 MAX+1·날조 0.
