# Huni-Admin-Manual 하네스 CHANGELOG

> 이 파일은 `CLAUDE.md` §8의 하네스 포인터에서 분리된 **전체 변경 이력**이다.
> CLAUDE.md에는 최신 포인터 1줄만 유지하고, 전체 이력은 여기서 관리한다(최신이 위).
> 새 변경 발생 시: ① 이 테이블 상단에 추가 ② CLAUDE.md §8 포인터 갱신.

| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-06-10 | **라이브 재대조 갱신 — 0 드리프트·QA Low 3건 해소 확인** — 사용자 "admin 매뉴얼 업데이트"(라이브 재대조 후 반영). `ham-db-verifier`(DB 읽기전용 60+셀 재실측)+`ham-live-capturer`(gstack 14화면 재대조) 병렬 → **드리프트 0건**(코드값·행수·시각 전수 MATCH). CPQ 옵션 레이어(silsa `option_items` 18행)는 `02_db`가 round-9 적재(06-08~09) **이후** 캡처라 정합(빈→적재 드리프트 가설 거짓). QA 게이트가 미보정으로 남긴 Low 3건(L-1 7→8종·L-2 `use_yn` 필수·L-3 `print_side` 자유텍스트)은 작가가 게이트 직후(07:02) 이미 보정 완료 + 라이브 권위로 CONFIRMED → `04_qa` §0.5 재검증 갱신·미보정 0. **매뉴얼 본문·캡처·사이트 무변경**(정합 재확인). 교훈: 게이트 리포트는 보정 전 시점이라 stale 가능 → 매뉴얼 본문이 권위 | `_workspace/huni-admin-manual/{05_reverify_db-drift,05_reverify_capture-drift,04_qa_manual-gate}`·CLAUDE.md §8 | 사용자(라이브 재대조 후 반영) |
| 2026-06-10 | **문서 시스템 연동 보강 — Material for MkDocs 발행 트랙(docs-as-code)** — 베스트프랙티스 리서치(MkDocs Material vs Sphinx/Docusaurus/Nextra → Python·순수 Markdown·운영자 가이드에 MkDocs Material 최적) 후 6번째 에이전트 `ham-docs-publisher` + 스킬 `huni-admin-docs-publish` 추가. `site-src/`(mkdocs.yml·`build_docs.py` 정규화 빌드·requirements·README) + `.github/workflows/docs.yml`(push→build→Pages, 빌드·배포만 자동). 로컬 `mkdocs build --strict` 통과(11페이지·41이미지·깨진링크0). 자동화는 빌드·배포만(매뉴얼 재생성은 사람이 하네스 트리거)·호스팅 연결(Pages)·webadmin 연동은 인간 승인 | `.claude/agents/huni-admin-manual/ham-docs-publisher`·`.claude/skills/huni-admin-docs-publish`·`_workspace/huni-admin-manual/site-src/`·`.github/workflows/docs.yml`·오케스트레이터·`.gitignore`·CLAUDE.md §8 | 사용자(문서 시스템 연동·코드 배포 시 매뉴얼 자동 발행) |
| 2026-06-10 | 하네스 초기 구성 + 매뉴얼 산출 — 5인 팀(source-analyst·db-verifier·live-capturer·manual-writer·manual-qa) + 스킬 4종. 소스 이중 레이어(표준 admin + 상품뷰어) 파악, 3중 대조(소스맵·DB코드값72·캡처41) → 운영자 매뉴얼 11챕터·1296줄(스크린샷28)·QA GO(커버리지26/26 누락0) | `.claude/agents/huni-admin-manual/`·`.claude/skills/huni-admin-{manual-orchestrator,source-map,live-capture,manual-authoring}`·`_workspace/huni-admin-manual/`·CLAUDE.md §8, 커밋 486a54f | 사용자(라이브 admin 사용 매뉴얼 작성 하네스 구축) |
