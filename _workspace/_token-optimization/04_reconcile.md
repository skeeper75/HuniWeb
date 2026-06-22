# 3자 Reconcile — 진단 / 에이전트(opus) / codex(gpt-5.5 high)

## 합의 (고신뢰)
- **1% 불가·현실 바닥 2-3%**: 3자 만장일치. 시스템 주입분(빌트인 툴정의+deferred 90+개+시스템프롬프트)+연결 MCP 서버는 통제불가 ~8-15K토큰. 기본 lean=~5%·단일하네스=~2-3%·1%=MCP 차단 특별모드.
- **RC-3 스킬>에이전트 역전**: 합의. 스킬 description ~123KB > 에이전트 ~66KB. orchestrator description(huni-dbmap-orchestrator 7.7KB 등)이 narrative+100키워드 임베드 → 압축 최고 레버리지(본문 불변·트리거만).
- **출력스타일 미액션**: 합의. moai.md 15.7KB 순손실.
- **카탈로그 축소법**: 스캔루트(.claude/agents·skills) 밖 이동=가역·안전. 단 무더기 금지→description 압축 먼저→dormant moai/만 1차 아카이브→비활성 하네스는 의존 closure 단위+복구 스크립트.

## RC-2 최종 정정 (codex 소스 확인 — 최고 신뢰)
- rules 로드 메커니즘 = **OMC rules-injector hook이 Read/Write/Edit 대상 파일경로를 rule frontmatter globs와 매칭**(`~/.codex/plugins/.../rules-injector/matcher.ts`). git 변경세트(에이전트 주장)도, gating 미작동(원 진단)도 아님.
- python.md 미로드 = 이번 세션 도구 접근경로가 `**/*.py` 미매칭.
- **해결책(불변)**: broad glob 제거 / unused rule 아카이브(frontmatter 무력화보다 정확). coding-standards의 `CLAUDE.md` glob이 영구매칭 주범.

## 합의 실행 순서 (codex 권장 채택)
A(CLAUDE.md 변경이력→CHANGELOG) → 스킬 description 압축 → E(MEMORY 인덱스화) → F(출력스타일 slim/해제) → B(dormant moai/ 아카이브) → C(rules broad glob 제거/아카이브) → [D 단일하네스 토글: 1% 근접 시만·중위험] → [MCP 차단: 1% 고집 시만]

## 예상 절감
A+스킬압축+E+F+B+C = ~10% → ~4-5%(무위험·전부 가역·break 0). +D = ~2-3%. +MCP차단 = ~1%(기능 희생).
