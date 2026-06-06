# _migrate_gp_circle — GP 합판도무송 원형 직경 siz 등록 + GP 가격 + 066 size link

GP(합판도무송, `COMP_GANGPAN_PRINT`) 원형 직경 가격 경로의 **직경 siz 등록 + GP component_prices 적재 +
PRD_000066 원형 size link** 실행본. round-5 적재 실행본 트랙 — 자율 quick win. **상세는 `MIGRATION.md`.**

## 한눈에

- **10 NEW siz** (`SIZ_000501..SIZ_000510`, 직경 10~60mm 중 35 제외) → `t_siz_sizes`
  — **후니 master-data 등록 결정 (인간 승인)**. 35mm=`SIZ_000422` 재사용(committed, 등록 안 함).
- **100 GP prices** (10직경×2mat[MAT_000084/153]×5수량밴드[1000~5000]) → `t_prc_component_prices`
- **11 size link** (신규 10 + 재사용 1) → `t_prd_product_sizes` (PRD_000066)
- siz 1회 등록 → 가격·size link 양쪽이 공유(register ONCE, reference TWICE)
- siz 번호 조율: 501~510 = 본 트랙, 511~721 = 면적매트릭스 → **불교차**

## 실행

```bash
./backup.sh            # (권장) 읽기전용 백업 스냅샷
./apply.sh             # DRY-RUN (기본, 롤백). guard0/assert ×3 통과 확인
./apply.sh --commit    # 실제 적재 (인간 승인 시에만)
./undo.sh [--commit]   # 되돌리기 (35mm SIZ_000422 보존)
```

기본은 항상 **롤백 DRY-RUN**. `--commit`은 인간 승인 전용. 자격증명 `.env.local`만, 비밀번호 미출력.

## FK 위상순 (단일 트랜잭션)

```
01 siz (t_siz_sizes)
   ├─→ 02 component_prices (siz_cd FK)
   └─→ 03 product_sizes    (siz_cd FK + prd_cd FK→PRD_000066)
```

## 검증 핸드오프

`dbm-validator`에게 R1~R6 + 라이브 롤백 DRY-RUN(2회 멱등·제약위반0) 검증 요청. 빌더는 자기 승인하지 않는다.
committed `_exec_price`/`_exec`/`_migrate_fixedprice`/`_migrate_areamatrix`와 무간섭(별도 디렉터리).
