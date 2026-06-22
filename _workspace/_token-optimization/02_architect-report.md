# 전문 에이전트(opus) 독립 검증 보고 — 요약

## 진단 대비 정정 3건 (중대)
1. **RC-2 메커니즘 오진**: globs gating은 정상 작동. rules 로드 원인 = globs가 **git 변경세트(modified+untracked)**와 매칭. 증거: python.md(globs `**/*.py`)는 .py 존재해도 변경세트에 없어 미로드. → 수정법=globs 좁히기 ❌, rules frontmatter 무력화/이동 ✅.
2. **RC-3 순서 역전**: 스킬 description 122.9KB(~30.7K토큰) > 에이전트 66.4KB(~16.6K). orchestrator 스킬 description이 거대(huni-dbmap-orchestrator 단독 7.7KB·전체 narrative+100키워드 임베드). 최고 레버리지=비대 orchestrator description 압축(본문 불변·트리거만 영향).
3. **출력스타일 미액션**: moai.md 15.7KB 순손실(item F).

## 통제가능 베이스라인 (정정)
CLAUDE.md 23.8K + 스킬카탈로그 30.7K + 에이전트카탈로그 16.6K + rules 15.0K + MEMORY 11.5K + 출력스타일 3.9K + 글로벌 0.9K = **~102K토큰(1M의 10.2%)**. 시스템 툴정의+deferred 목록 합산 시 관찰 20% 정합.

## 우선순위 (효과×안전)
- A: CLAUDE.md §5~18 변경이력 → CHANGELOG 이주·1줄 포인터. 95KB→~14KB. **~20K절감·고안전·가역**.
- B: `.claude/agents/moai/`+`moai-*`스킬 아카이브(§19 dormant). **~14K·고안전·가역**(+rules 4개 cascade 차단).
- C: 로드된 8 rules frontmatter 무력화(coding-standards의 CLAUDE.md glob 제거·design/constitution 17.9KB gate). **~15K·중안전**.
- E: MEMORY.md 진짜 인덱스화(81줄 ≤150자). 46→~12KB. **~8K·고안전**.
- F: 출력스타일 MoAI 해제/축소. **~4K·고안전**.
- D: 세션별 하네스 dormancy 토글(비활성 10하네스 의존closure 이동). **~25K·중안전**(1% 도달 유일 레버·closure 오설정시 활성하네스 깨짐).
- G: 워킹트리 커밋(변경세트서 .claude/agents 제거→C/D 보조).

A+B+C+E+F = ~41K(~4.1%)·break 0·전부 가역. +D = ~2.5%.

## 1% 정직 판정
- 통제불가 바닥: 시스템 프롬프트+빌트인 툴정의+deferred 목록(90+ MCP/OMC 툴명)=~8-15K토큰. **MCP 서버 연결 상태로는 1% 물리적 보장 불가**.
- 현실 목표: 기본 lean(A+B+C+E+F)=~5%·단일하네스(+D)=~2.5%·sub-1%=D+미사용 MCP서버(Gmail/Calendar/Drive/figma/pencil) 차단 필요.
- 권고: **~2-3% 실질 바닥**. 리터럴 1%는 토글·MCP재연결 마찰비용이 절감(1.5%)보다 큼.

## 카탈로그 축소 메커니즘(검증)
스캐너는 `.claude/agents/**/*.md`·`.claude/skills/**/SKILL.md`의 name+description만 주입(본문 미주입·lazy). 비활성 하네스를 `.claude/_archive/` 등 스캔루트 밖으로 `git mv`하면 카탈로그서 제거·가역. 단 이동 단위=활성 하네스 **의존 closure**(cross-harness 재사용 dbm-price-arbiter 등 주의).
