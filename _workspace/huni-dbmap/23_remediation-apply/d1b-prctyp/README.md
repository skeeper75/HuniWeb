# 23_remediation-apply/d1b-prctyp — D-1b 후가공 prc_typ 정정 실행본

> round-13 정정 트랙 · 권위 입력 = [[../../28_price-arbitration/_price-queue-closeout/phase-b-d1b-remediation.md]] (GO).
> 방식 = ⓒ-2(신규 `PRICE_TYPE.03`). **돈-크리티컬 · 단가행 불변 · 비파괴(실 COMMIT 인간 승인).**

## 파일

| 파일 | 역할 |
|------|------|
| `00_preload_price_type_03.sql` | base_code `PRICE_TYPE.03` 멱등 INSERT (`ON CONFLICT DO NOTHING`) |
| `01_update_comp_prctyp.sql` | 그룹① 13 comp `prc_typ_cd` `.01`→`.03` 멱등 UPDATE (단가행 불변) |
| `apply.sql` | 단일 트랜잭션 래퍼(`BEGIN; \i 00 → \i 01;` · 로더가 ROLLBACK/COMMIT 주입) |
| `apply_loader.sh` | psql 로더 — 기본 DRY-RUN(롤백전용), `--commit`=인간 승인 |
| `manifest.md` | 무엇/단가행 불변/멱등 가드/동시배포 경고/롤백/영향 행수 |
| `dry-run-result.md` | 라이브 DRY-RUN 실증(13행 UPDATE·멱등 2회 델타 0·unit_price 불변·FK 고아 0·RESOLVED C3/C2/C4) |

## 실행

```bash
cd _workspace/huni-dbmap/23_remediation-apply/d1b-prctyp
./apply_loader.sh            # DRY-RUN(기본) — BEGIN...ROLLBACK, 라이브 무변경
./apply_loader.sh --commit   # [인간 승인 전용] 실 적재 — 엔진 .03 규칙과 동시 배포 필수
```

- 자격증명: `.env.local`의 `RAILWAY_DB_*`에서만 로드. 비밀번호 미출력.
- `\i` 상대경로 해석을 위해 로더가 `cd` 후 실행(이 디렉토리 기준).

## ⚠ HARD 주의

1. **단가행 불변**: `t_prc_component_prices.unit_price` 절대 미변경 — 메타 `prc_typ_cd` 1컬럼만. 보정 하드코딩 0.
2. **NEVER COMMIT 자동**: 기본 ROLLBACK. 실 COMMIT은 `--commit`(인간 승인)에서만.
3. **동시 배포**: prc_typ `.03` UPDATE는 엔진 `.03` 해석 규칙(webadmin Phase11)과 **반드시 동시 배포**. 분리 시 미정의 동작.
4. **ⓒ-1 대안**: `C-D1b`로 ⓒ-1(.02 재사용) 채택 시 → `00_*.sql` 생략 + `01_*.sql`의 `.03`→`.02` 치환(manifest §0 참조).

## 검증

R-게이트(R1~R6)는 `dbm-validator`(별도 에이전트)가 수행. 본 빌더 산출은 자가실증(dry-run-result.md)까지 — 자기승인 아님.
