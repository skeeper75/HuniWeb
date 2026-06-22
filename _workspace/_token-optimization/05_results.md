# 세션 시작 토큰 선소비 — 최종 결과

## BEFORE → AFTER (통제가능 자동로드, 파일 기준 bytes)
| 항목 | BEFORE | AFTER | 조치 |
|------|--------|-------|------|
| CLAUDE.md | 95,128 | 37,104 | §5~18 변경이력→14 CHANGELOG 무손실 이주 |
| MEMORY.md | 45,810 | 18,472 | 인덱스 라인 ≤150자 압축(정보손실 0) |
| 에이전트 카탈로그 | 84,803 | 42,044 | MoAI 22개 _archive |
| 스킬 카탈로그 | ~133,000 | ~72,533 | MoAI 48개 _archive + 71개 description 압축(본문 불변) |
| rules 풀로드 | ~60,000 | 0 | .claude/rules/moai 전체 _archive |
| 출력스타일 | 15,758 | 0 | settings outputStyle "MoAI" 제거 |
| **합계** | **~434,499 (~108K tok)** | **~170,153 (~43K tok)** | **−61% / 약 −66K 토큰** |

## MCP/deferred 차단 (다음 세션 적용)
- OMC 플러그인 비활성(`oh-my-claudecode@omc`: false) → deferred 툴 ~60개 + rules-injector hook 제거
- MCP 제거: figma·pencil(user)·sequential-thinking·moai-lsp(project) / **context7 유지**
- claude.ai connector(claudeAiMcpEverConnected) 비움
- 유지 플러그인: harness, huni-design-system, warp

## 예상 효과
- 세션 시작: **~20% → ~5%** (통제가능분 −61% + MCP/deferred floor 축소). 다음 세션 재측정으로 확정.
- **리터럴 1% 미달성**: 전문가 3자 만장일치 — 빌트인 툴 정의+시스템 프롬프트는 통제불가(~5K+ floor). MCP까지 끊은 현 상태가 실질 바닥. 1% 추가 하락은 단일하네스 토글(사용자가 제외) 필요.

## 안전망 (전부 가역)
- 복구: `bash .claude/_archive/RESTORE.sh` (MoAI agents/skills/rules)
- MCP/설정 백업: `.claude/_archive/mcp-backup/`
- OMC 재활성: `claude plugin enable oh-my-claudecode@omc`
- 정보손실 0: CLAUDE.md→CHANGELOG, MEMORY 압축 모두 이주(삭제 아님)

## 3자 교차검증 산출
01_diagnosis · 02_architect-report(opus) · 03_codex-verdict(gpt-5.5 high) · 04_reconcile · 05_results
