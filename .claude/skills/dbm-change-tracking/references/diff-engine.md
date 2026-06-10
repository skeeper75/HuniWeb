# diff-engine — 키 기반 3-way diff 스크립트 패턴 + 매니페스트 스키마

이 파일은 `dbm-change-tracking` Phase 2(diff)·Phase 4(매니페스트)의 재현 가능 구현 패턴이다. 매핑 규칙·게이트는 SKILL.md 본문 참조.

## 목차
1. 키 컬럼 식별
2. 키 기반 셀 단위 diff (Python 패턴)
3. rename 탐지 (ADDED+REMOVED 쌍)
4. 변경 매니페스트 스키마
5. 멱등 델타 SQL 생성 원칙

## 1. 키 컬럼 식별

시트별로 안정 비즈니스 키를 먼저 확정한다(추측 금지·헤더 실측):
- 1순위 `prd_cd`(있으면) — surrogate가 아니라 엑셀에 명시된 상품코드가 있을 때.
- 2순위 `prd_nm` — 라이브 JOIN KEY([[railway-db-access]]). 대부분 시트의 실질 키.
- 키 후보가 행을 유일 식별 못하면(중복) 복합키(`prd_nm`+규격열 등) 후보를 표기하고 **차단**(키 미확정 시트는 diff 신뢰 불가).

## 2. 키 기반 셀 단위 diff (Python 패턴)

```python
import openpyxl, csv, json

def load_sheet_keyed(path, sheet, key_cols, header_row=1):
    wb = openpyxl.load_workbook(path, read_only=True, data_only=True)
    ws = wb[sheet]
    rows = list(ws.iter_rows(values_only=True))
    wb.close()
    header = [str(c).strip() if c is not None else "" for c in rows[header_row-1]]
    kidx = [header.index(k) for k in key_cols]
    out = {}
    dups = []
    for r in rows[header_row:]:
        if all(r[i] in (None, "") for i in kidx):
            continue  # 키 공백 행 = skip + 플래그
        key = "|".join("" if r[i] is None else str(r[i]).strip() for i in kidx)
        cells = {header[j]: ("" if v is None else str(v)) for j, v in enumerate(r) if header[j]}
        if key in out:
            dups.append(key)        # 키 중복 = 차단 신호
        out[key] = cells
    return header, out, dups

def diff_sheet(base_path, new_path, sheet, key_cols):
    h, base, dB = load_sheet_keyed(base_path, sheet, key_cols)
    _, new,  dN = load_sheet_keyed(new_path,  sheet, key_cols)
    bk, nk = set(base), set(new)
    added   = sorted(nk - bk)
    removed = sorted(bk - nk)
    changes = []  # MODIFIED: 셀별 전→후
    for key in sorted(bk & nk):
        for col in (set(base[key]) | set(new[key])):
            bv, nv = base[key].get(col, ""), new[key].get(col, "")
            if bv != nv:
                changes.append({"key": key, "col": col, "before": bv, "after": nv})
    return {"sheet": sheet, "added": added, "removed": removed,
            "modified_cells": changes, "dup_keys": sorted(set(dB+dN))}
```

핵심: **read-only + data_only**(수식 결과값 비교, 수식 문자열 아님). 셀 정규화(strip·None→"")를 양 버전 동일 적용해야 false diff가 없다. 빈 트레일링 행은 키 공백으로 자동 제외.

## 3. rename 탐지 (ADDED+REMOVED 쌍)

키가 `prd_nm`일 때 상품 재명명은 ADDED 1 + REMOVED 1로 나타나 단종+신규로 오분류된다. 보정:
- ADDED와 REMOVED 행의 **비키 컬럼 유사도**(예: 규격·자재·가격 컬럼 다수 일치)가 높으면 **rename 의심쌍**으로 플래그 → 사람 판단(매니페스트 `rename?` 표기). 자동 단정 금지.
- `prd_cd`가 키면 rename은 MODIFIED(prd_nm 셀 변경)로 정상 포착되므로 우선 prd_cd 키 사용.

## 4. 변경 매니페스트 스키마 (`change-manifest.csv`)

| 컬럼 | 의미 |
|------|------|
| `sheet` | 상품군 시트 |
| `key` | prd_nm 또는 prd_cd (변경 행 식별) |
| `change_type` | ADDED / REMOVED / MODIFIED |
| `column` | MODIFIED 시 변경 컬럼 (ADDED/REMOVED는 전체) |
| `before` / `after` | 전값 → 후값 (provenance) |
| `cell_ref` | 엑셀 셀 좌표 (예: `아크릴!H214`) — 감사 추적 |
| `target_entity` | 영향 t_* 엔티티 (예: `t_prd_product_sizes`) |
| `target_column` | 영향 t_* 컬럼 |
| `live_prd_cd` | 영향 라이브 상품코드(정합 실측) |
| `apply_class` | INSERT / UPDATE / LOGICAL_DELETE_PROPOSAL / ESCALATE / GAP / NO_OP(이미 일치) |
| `note` | rename 의심·키 무결성·GAP 사유 등 |

MD 요약(`change-manifest.md`)은 시트별 4분류 카운트 + apply_class 집계 + escalate/GAP 하이라이트 + 사람이 읽는 변경 서사(상위 변경 N건).

## 5. 멱등 델타 SQL 생성 원칙

`dbm-load-execution`의 ON CONFLICT 패턴을 재사용하되 **변경분만**:
- `apply_class=UPDATE` → `INSERT … ON CONFLICT (<live PK/UNIQUE>) DO UPDATE SET <changed cols>, upd_dt = now()`. 충돌키는 라이브 information_schema에서 실측(추측 금지).
- `apply_class=INSERT`(ADDED) → `INSERT … ON CONFLICT DO NOTHING`(멱등) + 신규 상품의 종속 차원/관계행/코드행 FK 위상정렬.
- `apply_class=NO_OP` → SQL 미생성(이미 라이브=목표). DRY-RUN 2회차 delta 0 기여.
- `apply_class=LOGICAL_DELETE_PROPOSAL`(REMOVED) → SQL 자동생성 금지. `logical-delete-and-gaps.md`에 `UPDATE … SET use_yn='N'` *제안*만(주석 처리·인간 승인).
- 단일 트랜잭션 `apply.sql`(`BEGIN … ON_ERROR_STOP on`), 로더 기본 ROLLBACK·`--commit`은 인간 게이트. provenance.csv로 모든 생성 행을 매니페스트 행에 역추적.
