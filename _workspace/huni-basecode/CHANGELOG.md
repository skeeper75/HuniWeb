# Huni-Basecode-Governance 하네스 CHANGELOG

> 이 파일은 `CLAUDE.md` §12의 하네스 포인터에서 분리된 **전체 변경 이력**이다.
> CLAUDE.md에는 최신 포인터 1줄만 유지하고, 전체 이력은 여기서 관리한다(최신이 위).
> 새 변경 발생 시: ① 이 테이블 상단에 추가 ② CLAUDE.md §12 포인터 갱신.

| 날짜 | 변경 내용 | 대상 | 사유 |
|------|----------|------|------|
| 2026-06-18 | **교정 실행 우선순위 트랙 추가(Phase 5)** — 신규 에이전트 `hbg-remediation-planner` + 스킬 `hbg-remediation-planning`. 등록 명세를 안전·가역성 우선 우선순위화 + ★가격사슬 영향 분석(t_prc_* 교정 영향·dbm-price-arbiter 협업) + 교정 경로 혼합(가역=라이브직접/근본=경로Y) + wave 단계별 인간 승인 큐. 실 COMMIT은 GO분 wave 단위 승인 후 dbmap 트랙(dbm-axis-staged-load·dbm-load-execution) 위임 | `.claude/agents/huni-basecode/hbg-remediation-planner`·`.claude/skills/hbg-remediation-planning`·오케스트레이터 §Phase5·CLAUDE.md §12 | 사용자(`/harness:harness` — 우선순위로 라이브 실제 교정·가격사슬 점검) |
| 2026-06-18 | 6축 등록 명세 마스터 완주(GO) — 자재·카테고리(1차)+사이즈·도수·인쇄옵션·공정(2차) 전건 GO. ★3대 발견: del_yn 권위 정정·ref_param_json 신규그릇 철회(dtl_opt 재사용)·.10 3용도 분해. 신규 코드행 0(결함=오염/미적재). 커밋 d382a56~33f4407 | `_workspace/huni-basecode/`(01~04)·메모리 [[del_yn 권위]] | 사용자(파이프라인 실행) |
| 2026-06-18 | 하네스 초기 구성 — 4 에이전트(hbg-authority-curator·diagnostician·registration-designer·validator) + 5 스킬(orchestrator + curation·diagnosis·registration-spec·governance-evaluation). rpmeta∩dbmap을 기초코드 등록 명세로 종합하는 신규 통합 거버넌스 하네스. 산출=등록 명세 마스터(분석·명세 전용·실 COMMIT은 dbmap 위임). 1순위=자재·카테고리 | `.claude/agents/huni-basecode/`·`.claude/skills/{huni-basecode-orchestrator,hbg-*}`·CLAUDE.md §12 | 사용자(`/harness:harness` — rpmeta 읽고 기초코드 등록 필요분 도출 전략) |
