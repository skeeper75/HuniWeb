---
name: huni-recode-orchestrator
description: >-
  후니 Recode 하네스(Huni-Recode·역공학 코드 가독화) 오케스트레이터. 부분 디옵된 JS(docs/reversing/
  red_reverse_engineer/03_deobfuscated/*.js)를 사람이 읽고 길찾는 형태로 완성한다 — [HARD] 실행 가능 동등
  유지(AST 스코프 안전 리네이밍·Babel/recast), 서드파티(Sentry·Babel 폴리필) 분리·요약, 가독 소스 +
  길잡이 문서 산출. ★dynamic workflow(Workflow 툴)로 cartograph→codemod→verify(G1~G6)→루프(게이트
  통과까지)→doc를 구동(목적 부합까지 반복). 5 에이전트: rcd-technique-researcher(최신기법) →
  rcd-module-cartographer(리네임/주석/서드파티 맵) → rcd-readability-engineer(AST 변환·생성) →
  rcd-equivalence-verifier(동등성·가독성 게이트·검증) → rcd-doc-author(아키텍처/워크스루/내비 문서).
  생성≠검증·동작 보존이 게이트·파일럿(deob_05)→동형 전파(06/07/editor_sdk)·읽기전용(라이브 불요).
  트리거: '디옵 코드 가독화', '역공학 코드 사람이 읽게', '난독 코드 복원', '코드 가독화 하네스',
  'AST 디옵', '동작 보존 가독화', '서드파티 분리', '가독 소스 만들기', 'Recode 하네스 실행/재실행/
  업데이트/보완', '특정 파일만 가독화', '가독화 다시', '결과 개선'. 위젯 동등성 검증은 §22 RE-Verify,
  위젯 플로우 문서는 §19, edicus 코드맵은 §20이 담당. 단순 질문은 직접 응답.
---

# huni-recode-orchestrator — 역공학 코드 가독화 하네스

부분 디옵된 RedPrinting JS(`03_deobfuscated/`)를 **실행 가능 동등을 유지하며** 사람이 읽는 형태로 완성하고 길잡이 문서를 산출한다. 현대 기법(LLM이 의미 이름 추론 → AST 코드모드가 스코프 안전 적용 → AST 구조 diff로 동작 보존 증명)을 쓴다.

## 정체성 (기존 RE 하네스와 경계)
| 하네스 | 무엇 | 본 하네스와 차이 |
|--------|------|-----------------|
| §22 RE-Verify | 역공학 코드의 라이브 **런타임 동등성** 검증 | 본 하네스는 **코드 자체를 가독화**(동작 보존 변환) |
| §19 Widget-Flow | 위젯 **플로우 문서/시각화** | 본 하네스는 **소스 가독화 + 길잡이 문서** |
| §20 Edicus-Codemap | edicus.man **자체 구현** 코드맵 | 본 하네스는 **역공학된(축약) 코드** 복원 |

→ 본 하네스 = 디옵 산출물을 **입력**으로, 가독 소스(.js) + 문서를 산출. 라이브 접속 불요(파일 분석·변환만).

## 대상 & 현 상태 (입력)
`docs/reversing/red_reverse_engineer/03_deobfuscated/`:
- `deob_05_app_api.js`(1,507줄·API+Pinia+위젯SDK·식별자 73% 리네임) — **파일럿**
- `deob_06_app_widget_sdk.js`(1,392줄·위젯 UI 컴포넌트)
- `deob_07_app_components.js`(2,607줄·Vue 38컴포넌트·헤더-only 매핑 다수)
- `deob_editor_sdk.js`(12,629줄·RedEditorSDK·★~9,100줄 서드파티 Sentry 67-2534+Babel 폴리필 2888-9527)
- `*_stats.json`·`editor_sdk_method_catalog.md`(기존 리네임/섹션/메서드 — **1차 재사용**)

산출 루트: `docs/reversing/red_reverse_engineer/05_readable/`(`_meta`·`01_cartography`·`02_readable`·`03_verify`·`_tooling`·`docs`).

## 핵심 제약 (사용자 확정 · [HARD])
1. **실행 가능 동등 유지** — AST 안전 변환만. 동작 바뀌면 NO-GO. 증명=AST 구조 동등성(G2).
2. **서드파티 분리·요약** — Sentry/Babel 폴리필은 가독화 제외, region 배너로 분리(in-place·동작 보존)+참조 추출본.
3. **가독 소스 + 길잡이 문서** 둘 다 산출.
4. **생성≠검증** — engineer(생성)와 verifier(검증)는 분리 레인. verifier는 직접 재실측.

## 실행 모드: dynamic workflow (Workflow 툴) — 루프 게이트
사용자 directive = "목적에 부합할 때까지 dynamic workflow". 따라서 **Workflow 툴**로 파일별 파이프라인을 돌리되, verifier가 NO-GO면 cartographer/engineer로 되돌려 **게이트 통과까지(또는 유한 재시도 N=3) 반복**한다.

- 신규 rcd-* 에이전트가 레지스트리에 미로드면 Workflow `agent()` 프롬프트에 해당 정의파일(`.claude/agents/rcd-*.md`)을 읽혀 역할을 주입(default 워크플로 서브에이전트·tools 보유).
- 모든 에이전트 추론은 opus 급(세션 모델 상속).

### Workflow 스크립트 골격
```js
export const meta = {
  name: 'huni-recode-readable',
  description: '디옵 JS를 동작 보존하며 가독화 + 길잡이 문서',
  phases: [{title:'Research'},{title:'Cartograph'},{title:'Transform'},{title:'Verify'},{title:'Doc'}],
}
// 0) 기법 플레이북 + 도구 준비(1회)
phase('Research')
await agent(READ('rcd-technique-researcher.md') + '\n대상: 03_deobfuscated/*.js. 산출: _meta/technique-playbook.md, _meta/toolset.json. 도구 설치 절차 포함.')
// 1) 파일별 파이프라인: cartograph → transform → verify(루프) → 단위 GO
const FILES = args?.files || ['deob_05_app_api.js'] // 파일럿; 전파 시 06/07/editor_sdk 추가
const results = await pipeline(FILES,
  f => agent(READ('rcd-module-cartographer.md') + `\n파일=${f}. stats/헤더 매핑 병합 → 01_cartography/${f}/{rename-map,comment-map,thirdparty-ranges}.json + work-units`, {phase:'Cartograph'}),
  (_c, f) => transformVerifyLoop(f),   // 아래: engineer→verifier, NO-GO면 최대 3회 재시도
)
// 2) 길잡이 문서(GO된 파일들 종합)
phase('Doc')
await agent(READ('rcd-doc-author.md') + `\nGO 파일: ${JSON.stringify(goFiles)}. 산출: 05_readable/docs/{index,00-architecture,01..04-*,05-method}.md`)
return { goFiles, verdicts }
```
`transformVerifyLoop(f)`: engineer가 코드모드 실행 → verifier가 G1~G6 → NO-GO면 사유를 cartographer(맵)/engineer(스크립트)로 라우팅해 재실행, 최대 3회. 게이트 GO 또는 소진 시 verdict 반환(소진=결함 명시).

> 실제 실행은 메인 세션에서 Workflow 툴 호출(이 스킬은 그 청사진). 사용자가 "dynamic workflow"를 명시했으므로 Workflow 툴 opt-in 충족.

## 워크플로 단계 (에이전트 데이터 흐름)

### Phase 0: 컨텍스트 + 스코프
1. `05_readable/` 존재로 모드 판별: 미존재=초기, 존재+부분요청=부분 재실행(해당 파일/단계만), 존재+재실행=새 실행(이전 `_prev`).
2. 스코프: 기본 **파일럿=deob_05** 완주 → GO면 06/07 → editor_sdk(서드파티 fold + 고유 로직). 사용자가 특정 파일만 요청하면 그 범위. `args.files`로 전달.
3. Node 환경 확인(`node -v`). 부재 시 보고(AST 기법 전제).

### Phase 1: 기법 (researcher · 1회)
- `rcd-technique-researcher` → `_meta/technique-playbook.md`·`_meta/toolset.json`. 이후 세션은 재사용(변경분만).

### Phase 2: 모듈 지도 (cartographer · 파일별)
- `rcd-module-cartographer` → `01_cartography/<f>/{rename-map,comment-map,thirdparty-ranges}.json`. 기존 stats/헤더 **병합 우선**. preserve 목록 강제.

### Phase 3: 변환 (engineer · 파일별)
- `rcd-readability-engineer` + `rcd-ast-deobfuscate` 스킬 → `02_readable/<f>` + `<f>.thirdparty.js`. 도구 설치·코드모드 실행.

### Phase 4: 검증 게이트 (verifier · 파일별 · 루프)
- `rcd-equivalence-verifier` + `rcd-equivalence-verify` 스킬 → `03_verify/<f>.verdict.md`(G1~G6). NO-GO → Phase 2/3 해당 부분 재실행(최대 3회).

### Phase 5: 길잡이 문서 (doc-author)
- `rcd-doc-author` → `05_readable/docs/`. GO 파일 종합·아키텍처/워크스루/내비/기법.

## 데이터 전달
- 파일 기반(약속된 경로 위 표) + Workflow 반환값(GO 목록·verdict). 중간 산출(`01_cartography`·`03_verify`)은 보존(감사 추적).

## 에러 핸들링
- npm 설치 실패(네트워크) → 1회 재시도, 실패 시 중단·보고(텍스트 치환 우회 금지 — 동작 보존 깨짐).
- G2 구조 불일치 지속(3회) → 해당 파일 verdict에 "동작 보존 미증명 — 잠정"으로 명시하고 다음 파일 진행(거짓 GO 금지).
- 충돌/모호 → 오케스트레이터가 사용자에게 AskUserQuestion(서브 에이전트는 질문 금지·STOP 보고).

## 테스트 시나리오
- **정상**: deob_05 파일럿 → cartograph(맵 병합) → codemod → G1~G6 GO → 06/07/editor_sdk 전파 → 문서. 결과: `02_readable/*.js`(동작 보존·잔여 식별자 0) + `docs/`.
- **에러(동등성 깨짐)**: 코드모드가 프로퍼티명을 잘못 rename → G2 propsEqual=false → NO-GO → cartographer가 해당 식별자 scope 교정/preserve 추가 → 재실행 → GO.

## 후속/재호출
- "특정 파일만 다시" → 그 파일만 Phase 2~4. "결과 개선/문서 보완" → 해당 단계만. "전파" → `args.files`에 나머지 추가.
- CLAUDE.md §26 변경 이력 갱신.
