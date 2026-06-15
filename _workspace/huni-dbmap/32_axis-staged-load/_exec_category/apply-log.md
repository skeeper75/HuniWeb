# ⑥ 카테고리 고아 페어 정리 — 실 라이브 COMMIT 로그 (round-22 v2 경로 X)

> **실행** 2026-06-16 · 경로 X(라이브 직접 SQL). 검증 GO(X1~X6)·사용자 승인("둘 다 — 경로 X 즉시 + 경로 Y 백로그"). undo 안전망 보유.

## 적용 내용

| 단계 | SQL | 결과 |
|------|-----|------|
| 백업 | `\copy` 삭제 대상 페어 111 + 고아 노드 14 → `_exec_category/backup_*.csv` | 보존 |
| DRY-RUN | BEGIN…ROLLBACK | DELETE 111·UPDATE 12·정상 273 무손상 실증 |
| **COMMIT** | `DELETE … main_cat_yn='N'` 고아 페어 + `UPDATE … use_yn='N'` 빈 노드 | **DELETE 111 · UPDATE 12 · COMMIT** |

## COMMIT 후 검증 (라이브 실측)

| 항목 | 기대 | 실측 | 판정 |
|------|:--:|:--:|:--:|
| 고아 페어 잔존 | 2(BLOCKED main='Y') | 2 | ✅ |
| 정상 주카테고리(main='Y') | 273 무손상 | 273 | ✅ |
| 빈 고아 노드 use_yn='N' | 12 | 12 | ✅ |
| 잔존 use_yn='Y' 고아 노드 | 2(BLOCKED) | 2 | ✅ |
| t_prd_product_categories total | 392→281 | 281 | ✅ |
| 멱등(페어 DELETE 재실행) | 0 | 0 | ✅ |

## 멱등 노트 (정직 기록)

- **페어 DELETE = 완전 멱등**(재실행 0행).
- **빈 노드 UPDATE = 값 멱등·메타 비멱등** — `UPDATE … use_yn='N'`에 `AND use_yn='Y'` 가드가 없어 재실행 시 이미 N인 12행을 다시 매칭(`use_yn`='N' 불변·`upd_dt`만 갱신). 데이터 정합 무영향. 향후 가드 권장: `... AND use_yn='Y'`.

## 되돌리기 (undo)

```
bash _workspace/huni-dbmap/32_axis-staged-load/_exec_category/undo.sh
```
백업 CSV(`backup_orphan_pairs.csv` 111행)에서 페어 복원 + 고아 노드 `use_yn='Y'` 복원.

## BLOCKED (미적용 — 인간 승인)

- **PRD_000218 타이벡북커버 · PRD_000229 이미지피켓** (둘 다 `use_yn='N'` 비활성 상품·고아 main='Y') — 정상 잎노드 매칭 불명확(B-2). 고아 페어 보존됨.
- 그 결과 CAT_000302(데스크/사무용품)·CAT_000304(말랑) 2 노드는 use_yn='Y' 유지(BLOCKED 상품 연결 잔존).

## ★회귀 위험 (경로 Y 백로그 필수)

경로 X는 **개발자가 v03을 `load_master --all` 재적재하면 소멸**(v03 11_상품별카테고리에 고아 페어가 그대로 있으므로 재INSERT). 근본 교정 = 경로 Y(`_backlog/developer-code-changes.md`) — 개발자가 v03 교정 후 재적재. 본 COMMIT은 그 전까지 유효.
