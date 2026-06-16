# BN(현수막류) — codex-cli Deep-Augmentation (deepcheck)

> rpm-deepcheck. RedPrinting BN 카테고리 분석(reverse+metamodel+gap)을 독립 OpenAI 모델(codex-cli)에
> 컨텍스트로 주고, 우리 분석이 놓친 옵션/자재/공정/관리축/제약/엣지케이스/도메인 정보를 second-opinion으로
> 심층 발굴하는 산출물.
> **[HARD] 환각 경계:** codex(OpenAI) 제안 = `unverified` 가설. 후니 라이브/엑셀 권위로 검증되기 전엔 사실 아님.
> codex가 우리 검증된 발견과 충돌하면 우리 것 유지(라이브 권위).

---

## 상태: ❌ DEEPCHECK PENDING — codex CLI 버전 블로커 (인증은 해소됨)

**2026-06-17(재실행) codex consult 시도 결과: codex 호출 실패. 후보 0건. 날조 없음.**
**진단 갱신: 직전 세션의 "401 OAuth 만료"는 해소됨(재인증 완료). 이번 블로커는 별개 — codex CLI 0.38.0 버전이 너무 낮음.**

### 시도 내역 (재현 가능)
- codex-cli **0.38.0** 설치 확인 ✅ · 인증 ✅ (401 더 이상 발생 안 함 — 토큰 갱신 정상, API 도달함)
- 트리벌 ping `codex exec -m <model> --sandbox read-only --output-last-message <out> "reply OK"` 으로 모델별 전수 시도.
- **모든 모델 id가 동일 패턴으로 거부됨 (실제 에러 메시지):**
  ```
  # 이 CLI 기본/codex 계열 — ChatGPT 계정에서 차단
  400 Bad Request: "The 'gpt-5-codex' model is not supported when using Codex with a ChatGPT account."
  (gpt-5, gpt-5.1, gpt-5.1-codex, gpt-5.1-codex-mini, gpt-5-codex-mini 전부 동일 메시지)
  # 계정이 기대하는 최신 모델 — 이 CLI 버전이 너무 낮음
  400 Bad Request: "The 'gpt-5.5' model requires a newer version of Codex. Please upgrade to the latest app or CLI and try again."
  ```
  → 일시 장애 아님. **CLI 0.38.0의 모델 카탈로그(gpt-5* / gpt-5-codex*)는 ChatGPT 계정에 더 이상 서빙되지 않고,
  계정이 요구하는 gpt-5.5는 더 최신 CLI를 요구**. 양쪽이 어긋나 호출 자체가 불가.
- `codex debug models` → `0.38.0`에 미존재 서브커맨드(`unrecognized subcommand 'models'`) — 카탈로그 조회도 불가.
- 로컬 OSS 우회(`codex exec --oss`) 시도 → `ollama not found`(로컬 프로바이더 없음). 우회 불가.
- (참고) `gpt-5.1-codex`는 MCP(figma) 시작 타임아웃이 모델 거부보다 먼저 떠 일시적으로 다르게 보였으나,
  `-c mcp_servers='{}'`로 MCP 끄면 동일 "not supported" 400. → MCP는 진짜 원인 아님.

### 해소 조건 (사용자 작업 필요)
- **codex CLI 업그레이드**가 핵심. ChatGPT 계정에서 OpenAI가 현재 서빙하는 모델(gpt-5.5 등)을 쓰려면
  CLI를 최신(스킬 기준 0.128+)으로 올려야 함. 예: `npm i -g @openai/codex@latest` 또는 사용자 설치 경로 갱신.
- 업그레이드 후 `codex login status` 정상 + 트리벌 ping 통과 확인 → 이 deepcheck 재실행(`'심층보강 다시'` / rpm-deepcheck 재호출).
- (대안) 로컬 OSS 경로를 쓰려면 `ollama` 설치 + 모델 pull 후 `codex exec --oss --local-provider ollama -m <model>` — 단 품질·second-opinion 가치는 OpenAI 호스티드보다 낮음.

### 재실행 준비물 (보존됨)
- codex에 줄 BN 분석 요약 컨텍스트(영문, checkable 갭발굴 질문 A~E 포함):
  `_workspace/huni-rpmeta/categories/BN/_tmp/rpm-bn-context.md`
- 재실행 명령(CLI 업그레이드 후 — 모델은 업그레이드된 CLI 기본값[gpt-5.5 등]에 맡기고, MCP 타임아웃 회피 위해 끔):
  ```bash
  cat _workspace/huni-rpmeta/categories/BN/_tmp/rpm-bn-context.md | codex exec \
    -c mcp_servers='{}' \
    --sandbox read-only --skip-git-repo-check \
    --output-last-message /tmp/rpm-deepcheck-BN.md -
  ```
  결과는 output-last-message 파일에서 수집(stdout 노이즈 회피). 비밀값·.env 프롬프트 주입 금지(준수됨).
  (구버전 0.38.0에서는 `-m gpt-5.5` 강제해도 "requires a newer version" 400 → 모델 지정으로는 해결 안 됨, 반드시 CLI 업그레이드.)

---

## codex에 제시한 BN 분석 요약 (consult 컨텍스트 — 재인증 후 그대로 재사용)

우리 BN 분석을 codex에 줄 수 있도록 요약한 입력(전문은 `_tmp/rpm-bn-context.md`):
- **카테고리 범위:** 면적 기반 대형 실사 배너(현수막/타포린·PET·X배너·어깨띠·롤업·매쉬·텐트천). 수성/라텍스 잉크젯. PDF 업로드 전용·단면 4색.
- **포착한 15축 메타모델:** 자재(합성코드 TYPE+소재+색+무게+인쇄방식)·공정/후가공·옵션·템플릿/SKU·제약(6논리유형)·기초코드·카테고리·부속물(거치대)·공정파라미터·수량모델(건수×수량)·가격기여역할(면적 SizeMatrix2D)·인쇄방식레시피·사이즈(프리셋+nonspec)·본체형태가공·생산형태.
- **자재→강제공정:** PET→코팅 필수, 텐트천→포장 필수, 동일소재 인쇄방식(수성/라텍스) 분기.
- **이미 아는 갭(재보고 제외 지시):** nonspec 범위·거치대↔사이즈 캐스케이드·면적 off-grid ceiling·건수×수량 이중가.
- **갭발굴 질문(checkable 강제):** A 누락 옵션축(라미네이션/엣지마감/걸이 하드웨어/실내외 내구·잉크등급/방염인증) · B 누락 자재·부자재(타포린 무게·백라이트필름·양면블락아웃·아일렛 규격·폴포켓·번지/케이블타이) · C 누락 후가공(용착헴 vs 봉제헴·폴포켓/슬리브·모서리보강·바람구멍/슬릿·열재단/윤곽재단·순서의존) · D 면적-매트릭스 가격을 깨는 엣지케이스(롤폭 초과 분할/용착·최소과금·양면 2배·매쉬 풍하중·중량배송) · E 도메인 사실(무게단위 gsm/oz·해상도 DPI·잉크↔소재 호환 매트릭스·ICC컬러·마감 리드타임·실내외 수명·아일렛 간격 표준).

---

## Triage 후보 목록

| # | claim | 상태 | 라우팅 stage | 검증법 |
|---|-------|------|-------------|--------|
| — | (없음 — codex 호출 실패로 후보 미발굴) | — | — | 재인증 후 재실행 |

> [HARD] 정직한 빈 결과: codex가 응답하지 못했으므로 후보를 지어내지 않음. 가짜 갭으로 채우지 않음.

## Re-invocation 메모
재인증 성공 시: codex output을 triage(① 신규 후보→`unverified` 태그 + 라우팅[새 축→metamodel-architect / 새 갭→gap-analyst / 누락 옵션→reverse-engineer / 그릇 함의→vessel-designer], ② 이미 커버→폐기 노트, ③ 오류/부적용→거부 사유). checkable 후보만 유지. 이 파일의 "상태"를 갱신하고 validator에 후보 목록을 넘겨 M게이트가 미검증 무단 채택 0을 확인하게 함.
