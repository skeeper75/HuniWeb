판정: 전문에이전트 보고는 **RC-3, 출력스타일, 1% 현실성은 대체로 맞고**, **RC-2 메커니즘은 정정이 필요**합니다.

**쟁점별 판정**
1. **RC-2 메커니즘: 정정**
   “git modified+untracked 변경세트와 globs가 매칭돼 rules가 로드된다”는 주장은 repo에서 확인한 OMC rules-injector 구현과 맞지 않습니다. 실제 소스는 `Read/Write/Edit/MultiEdit`의 **대상 파일 경로**를 rule frontmatter의 `globs/paths`와 매칭합니다. 근거: [matcher.ts](/Users/innojini/.codex/plugins/cache/omc/oh-my-claudecode/4.14.7/src/hooks/rules-injector/matcher.ts:29), [constants.ts](/Users/innojini/.codex/plugins/cache/omc/oh-my-claudecode/4.14.7/src/hooks/rules-injector/constants.ts:31).  
   `python.md` 미로드는 “`.py`가 변경세트에 없어서”가 아니라 “이번 rules-injector 경로 접근이 `**/*.py`와 매칭되지 않아서”로도 충분히 설명됩니다. 따라서 원 진단의 “gating 미작동”도 부정확하지만, 전문에이전트의 “변경세트 매칭”도 부정확합니다.

2. **1% 달성 가능성: 동의**
   현실적으로 동의합니다. 공식 문서상 output style은 세션 시작 시스템 프롬프트 일부이고, subagent는 세션 시작 시 로드됩니다. skills는 본문은 lazy-load지만 description은 자동 선택 판단에 쓰입니다. 근거: Claude Code output styles 문서, subagents 문서, skills 문서.  
   이 repo의 실측도 큽니다: `CLAUDE.md` 95,128 bytes, memory 45,810 bytes, output style 15,758 bytes, agent description 약 66KB, skill description 약 124KB. MCP/툴/시스템 프롬프트까지 켠 상태에서 **≤10K 보장**은 목표로 잡기 어렵고, 실용 목표는 **2-3%**가 맞습니다.

3. **카탈로그 축소 안전법: 조건부 동의**
   `.claude/agents/**/*.md`, `.claude/skills/**/SKILL.md` 스캔 밖으로 옮기면 카탈로그에서 빠지는 방식은 원리상 안전하고 가역적입니다. 다만 `.claude/_archive/`로 “무더기 이동”은 closure 실수 위험이 있습니다. 더 나은 방법은:
   - 먼저 description 압축으로 고안전 절감
   - dormant `moai/` 계열만 1차 archive
   - 그 다음 비활성 하네스는 “활성 하네스 의존 closure”를 산출한 뒤 profile 단위로 이동
   - restore script/manifest를 함께 두어 즉시 복구 가능하게 유지

4. **우선순위 A~G: 일부 순서 조정**
   A는 최우선이 맞습니다. E/F도 매우 안전하므로 앞당기는 게 낫습니다. C는 “frontmatter 무력화”보다 **broad glob 제거/unused rule archive**가 정확합니다. G는 RC-2 해결책은 아닙니다. git 변경세트 기반 로더가 확인되지 않았기 때문입니다.  
   권장 순서: **A → skill description 압축 → E → F → B → C → D → G**. D는 1%에 가까워질 때만 수행할 중위험 레버입니다.

5. **진단 정정 3건: 2/3 동의**
   - RC-2 오진 정정: **부분 동의, 결론은 재정정 필요**. gating은 동작하지만 git 변경세트가 아니라 tool 대상 경로 매칭입니다.
   - RC-3 skill > agent 역전: **동의**. 실측상 skill description/frontmatter가 더 큽니다.
   - 출력스타일 미액션: **동의**. `.claude/settings.json`의 `"outputStyle": "MoAI"`와 15.7KB `moai.md`는 순수 시작 토큰 비용입니다.

**단일 권고안**
1. `CLAUDE.md` 변경이력 폭발부터 정리: 상세는 각 `CHANGELOG.md`로 이동, `CLAUDE.md`는 최근 3건 한 줄 요약만 유지.
2. `.claude/skills/*/SKILL.md`의 `description`을 상한 관리: 특히 `huni-dbmap-orchestrator` 같은 장문 orchestrator description을 “트리거 키워드 + 한 문장 목적 + 산출물 루트” 수준으로 압축.
3. `MEMORY.md`를 진짜 인덱스로 축소: 1라인 150자 안팎, 상세는 개별 memory 파일.
4. `outputStyle`을 Default 또는 1-2KB 이하 slim style로 전환.
5. dormant MoAI agents/skills와 broad rules를 archive하거나 narrow glob으로 축소.
6. 그래도 부족하면 “단일 하네스 모드”로 비활성 하네스 catalog를 closure 기반 archive.
7. **1%를 고집할 때만** MCP/플러그인/connector까지 줄입니다. 이 단계는 절감보다 운영 마찰이 커질 수 있습니다.

현실적인 목표는 **기본 lean 후 5% 전후**, 단일 하네스 모드까지 적용하면 **2-3%**입니다. **1%는 기능성을 크게 희생하는 특별 모드**로 보는 게 맞습니다.

사용한 외부 근거: Claude Code docs의 [Skills](https://code.claude.com/docs/en/skills), [Subagents](https://code.claude.com/docs/en/sub-agents), [Output styles](https://code.claude.com/docs/en/output-styles), [Settings](https://code.claude.com/docs/en/settings).