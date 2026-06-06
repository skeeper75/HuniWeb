# _migrate_areamatrix — 면적매트릭스 좌표 siz 등록 + 면적 단가 적재

면적매트릭스 가격 경로(실사 11 + 현수막 2 + 아크릴)의 **좌표 siz 등록 + 면적 component_prices 적재**
실행본. round-5 적재 실행본 트랙. **상세는 `MIGRATION.md`.**

## 한눈에

- **211 NEW siz** (`SIZ_000511..SIZ_000721`) → `t_siz_sizes` — **후니 master-data 등록 결정 (인간 승인)**
  (501~510은 round-5 sticker 원형 예약 → 면적은 511부터. 교차등록 조율: `MIGRATION.md §10`)
- **97 reuse siz** (EXACT/REVERSED) — 재등록 안 함
- **907 면적 prices** (POSTER 670 + ACRYL 237) → `t_prc_component_prices`
- 면적 13 + 아크릴 = **이미 `PRF_POSTER_FIXED` 바인딩 → 재바인딩 없음**
- off-grid ceiling = **런타임 로직(DB 미저장)**

## 실행

```bash
./backup.sh            # (권장) 읽기전용 백업 스냅샷
./apply.sh             # DRY-RUN (기본, 롤백). assert FK 고아=0 확인
./apply.sh --commit    # 실제 적재 (인간 승인 시에만)
./undo.sh [--commit]   # 되돌리기
```

기본은 항상 **롤백 DRY-RUN**. `--commit`은 인간 승인 전용. 자격증명 `.env.local`만, 비밀번호 미출력.

## 라이브 DRY-RUN 실증 (롤백전용·COMMIT 0)

211 siz + 907 prices INSERT, **FK 고아 0 · 제약위반 0**, 2회 적용 멱등(델타 0), ROLLBACK 후 라이브 무변경.

## 검증 핸드오프

`dbm-validator`에게 R1~R6 + 라이브 롤백 DRY-RUN 검증 요청. 빌더는 자기 승인하지 않는다.
별도 디렉터리(`_exec_price`/`_migrate_fixedprice` 무간섭).
