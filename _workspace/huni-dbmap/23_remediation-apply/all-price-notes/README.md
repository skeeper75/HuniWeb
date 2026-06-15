# all-price-notes — 전 상품군 가격테이블 note 전문용어 교정 번들

016 가격사슬(PRF_DGP_A) 외 **전 상품군 잔존 전문용어 note**(정의행 115 + 단가행 2,057 = 2,172행)를
라이브 실측 기준으로 **쉬운 한국어**(후니 용어 + 인쇄 도메인)로 교정한다.
**note 컬럼만 변경 · 가격/단가행 불변 · 멱등 · 의미 보존.**

## 실행

```bash
./apply_loader.sh            # DRY-RUN (BEGIN; ...; ROLLBACK) — 기본·안전
./apply_loader.sh commit     # 실제 적재 — 독립 게이트 GO + 인간 승인 후에만
```

재생성(라이브 재실측 → SQL):
```bash
python3 gen_notes.py
```

DRY-RUN 2-pass 멱등·불변·잔존0 검증:
```bash
# (apply_loader 가 호출하는 것과 동일 패턴)
{ echo "BEGIN;"; cat _dryrun_verify.sql; echo "ROLLBACK;"; } | psql ...   # → dry-run-result.md
```

## 안전 원칙

- 기본 모드 = **롤백전용 DRY-RUN**. COMMIT은 `commit` 인자 + 인간 승인 시에만.
- 비밀번호는 `.env.local` `RAILWAY_DB_*` 에서만 로드, stdout/로그/`_workspace` 미기록.
- SET 절은 `note`·`upd_dt` 둘뿐 — unit_price·prc_typ_cd·축 컬럼 절대 불변.
- `IS DISTINCT FROM` 가드 → 재실행 delta 0 (016 사슬 행은 자동 no-op).
- 자기승인 금지 — 검증은 독립 게이트 `dbm-validator`.

## 핵심 산출

- `note-map.csv` — 전수 대조표(현재→교정·flag). 검증자 역대조용.
- `manifest.md` — 범위·교정 규칙·실행 순서.
- `dry-run-result.md` — 라이브 DRY-RUN 실증(2,172행·멱등·불변·잔존0).
