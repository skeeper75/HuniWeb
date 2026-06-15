# Huni-Admin-Manual — HANDOFF (다음 세션 재시작 포인터)

## 다음 시작점 (예약 작업, 2026-06-15)

**라이브 admin 매뉴얼 업데이트** — `huni-admin-manual-orchestrator` 스킬로 라이브 재대조 후 반영.

1. `ham-db-verifier`(DB 읽기전용 코드값·행수 재실측) + `ham-live-capturer`(gstack 14화면 재대조) **병렬** 실행 → 드리프트 점검.
2. 드리프트 발견 시 `ham-manual-writer`가 매뉴얼 본문(11챕터) 갱신 + 캡처 교체, `ham-manual-qa`가 커버리지·정합 게이트.
3. 변경 시 `ham-docs-publisher`로 MkDocs 빌드(`mkdocs build --strict`) 재검증.

**자격증명**: `.env.local` `RAILWAY_DB_*`(DB 읽기전용 SELECT)·`HUNI_ADMIN_*`(라이브 화면 읽기 탐색만, 저장/삭제 금지).

## 직전 상태 (참고)
- 2026-06-10 라이브 재대조에서 **드리프트 0건**(DB 60+셀·gstack 14화면 전수 MATCH). 매뉴얼 본문이 권위([[huni-admin-manual-live-reverify]]).
- 이후 dbmap 하네스가 round-13~21 라이브 적재/교정을 진행했으므로, **그 적재분이 admin 화면에 반영됐는지**가 이번 재대조의 핵심 확인 포인트.
