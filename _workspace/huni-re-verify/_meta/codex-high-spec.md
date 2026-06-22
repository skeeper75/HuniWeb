# codex-cli HIGH-effort 교차검증 — 운영 명세 (Huni-RE-Verify 하네스용)

목적: 역공학된 코드/리포트가 **실제로 동작/재현되는가**를 codex(gpt-5.5)를 독립 2차
검증자로 세워 확인한다. codex는 **읽기전용 의견 제공자**(파일 쓰기 불가)이며, 그
주장은 라이브/캡처 증거로 검증되기 전까지 **사실이 아니라 가설**이다.

원천: `codex` 0.140.0 (`/Users/innojini/.local/bin/codex`), ChatGPT OAuth(콜당 API 과금 없음).

---

## 1. HIGH effort 정확한 호출 (검증됨)

config key는 **`model_reasoning_effort`** 이고 값 `high`가 맞다. 근거 3중:
- 공식 `/codex` 스킬(`~/.claude/skills/codex/SKILL.md`)이 review/challenge 모드 기본을
  `-c 'model_reasoning_effort="high"'`로 명시(L601, L760, L943).
- 사용자 전역 `~/.codex/config.toml`이 이미 `model = "gpt-5.5"` + `model_reasoning_effort = "high"`로 기본 설정.
- `codex exec --help`의 `-c, --config <key=value>`가 dotted-path TOML override를 받음(값은 TOML 파싱).

정석 명령(읽기전용·작업 디렉토리 지정):

```bash
codex exec -m gpt-5.5 -s read-only \
  -C <workdir> \
  -c model_reasoning_effort=high \
  --skip-git-repo-check \
  "<prompt>" < /dev/null      # ← stdin 반드시 닫을 것 (아래 ★ 참조)
```

### ★[HARD] 두 개의 함정 (라이브 테스트로 적발·해결)
codex exec를 비대화로 안 돌릴 때 무한 행/거짓 실패를 일으키는 **두 가지**가 있다.
둘 다 라이브에서 재현·수정·재검증 완료:

**(1) stdin 트랩** — 프롬프트를 positional arg로 줘도, stdin이 파이프/터미널로 열려 있으면
`Reading additional input from stdin...`로 **영원히 블록**(첫 테스트들 10분+ 무출력 행).
→ **`< /dev/null`** 로 stdin 차단 시 **30초 RC=0 정상**.

**(2) trusted-directory 트랩** — cwd가 git repo/신뢰 디렉토리가 **아니면**
`Not inside a trusted directory and --skip-git-repo-check was not specified`로 거부.
preflight 같은 probe가 이걸 안 붙이면 **전 후보 실패 → 거짓 `DEADLOCK`**(가용한데도 미가용 오판).
→ **`--skip-git-repo-check`** 로 해결. (`-C <workdir>`로 repo 안을 가리켜도, codex가 신뢰
판정에 쓰는 건 호출 cwd라 probe엔 반드시 필요.)

두 함정은 **모든** codex exec 호출(실 검증 + preflight probe)에 다 적용. 패치 결과
`codex-review.sh`가 비-git cwd(`/tmp`)에서도 **RC=0·27s·grounded** 로 완주(§5 검증).

- `-c model_reasoning_effort=high` — TOML override. `=high`(따옴표 없이)도 raw literal로
  먹지만, 셸 안전을 위해 codex-review.sh는 `model_reasoning_effort="$EFFORT"`로 넘김(동작 동일).
- `-C <workdir>` — codex가 **그 디렉토리에서 파일을 직접 읽게** 한다(프롬프트에 대용량
  본문을 욱여넣지 않음). 대용량 아티팩트 전달의 정석.
- `-s read-only` — 샌드박스 읽기전용 강제(codex가 무엇도 못 씀).
- `--skip-git-repo-check` — workdir가 git repo가 아닐 때 필요(`docs/reversing/`는 트래킹
  되지만 별도 repo 아님 → 안전하게 항상 붙임).

### 대안 / 주의
- **profile**: `-p <name>`로 `$CODEX_HOME/<name>.config.toml`을 레이어할 수 있음(프로젝트
  공용 프리셋 시 유용). 현재 하네스는 `-c` 인라인이면 충분.
- **`-c reasoning.effort`는 이 버전에서 쓰지 말 것** — 정식 키는 평면 `model_reasoning_effort`.
- **`xhigh` 금지(기본)**: 공식 스킬 경고 — `xhigh`는 `high` 대비 ~23배 토큰, 대용량
  컨텍스트에서 50분+ 행(OpenAI #8545/#8402/#6931). HIGH가 RE 검증의 상한 권장.
- 무해 경고: 실행 시 `~/.codex/plugins/.../hooks.json ... unknown field description` 경고가
  stderr에 뜨지만 **실행에 무영향**(플러그인 훅 파서 비호환일 뿐).

---

## 2. LIVE TEST 결과

preflight: `bash rpm-visualize/scripts/codex-preflight.sh` → **`AVAILABLE model=gpt-5.5`** (정상).

실제 실행 명령(그대로, **stdin 차단 포함**):
```bash
codex exec -m gpt-5.5 -s read-only \
  -C /Users/innojini/Dev/HuniWeb/docs/reversing \
  -c model_reasoning_effort=high --skip-git-repo-check \
  "Read only RedPrinting_SDK_Deep_Analysis_Report.html. In <=120 words:
   (1) list the API endpoint paths it documents;
   (2) list the price-calc request field names. Cite the nearby heading text.
   If absent say not found." < /dev/null
```

- (a) HIGH effort **에러 없이 수락**됨(stderr=무해한 플러그인 훅 경고 + `tokens used\n58,771`, RC=0).
- (b) **소요 30초**, 출력 589B. stdin을 안 닫은 첫 시도들은 10분+ 행(stdin 트랩) → `< /dev/null`로 30초 해결.
- (c) 출력(grounded, verbatim):
  - **엔드포인트**: `/ko/product/get_digital_product_info`, `/ko/product_price/get_ajax_price_vTmpl`,
    `/api/aws/presigned`, `/api/editor/config/` (출처 "4.4 widget.js 내 API 엔드포인트"),
    `/ko/cart/ajax_cart_count` (출처 "2.2 …").
  - **가격계산 필드**: `PDT_CD, CUT_WDT, CUT_HGH, WRK_WDT, WRK_HGH, PRN_CNT, PAGE_CNT,
    CVR_CLR_CNT, INN_CLR_CNT, CVR_MTRL_CD, INN_MTRL_CD, PCS_COD, PCS_DTL_COD, price_gbn,
    mb_cust_cod` (출처 "6.1 가격 계산 API — 실제 캡처된 요청/응답").

- **grounding 독립 검증**: Claude가 같은 HTML에 grep — codex가 인용한 14필드/5엔드포인트
  **전부 실재**(PDT_CD 3건, CUT_WDT 2건, price_gbn 2건, get_digital_product_info 4건,
  "6.1 가격 계산" 1건 등). **환각 0**. codex가 단순 grep(Claude의 1차 앵커는 priceCalc 등
  표층 토큰만)보다 **더 정확한 실측 캡처 필드(PDT_CD…)** 를 잡아냄 — 독립 2nd opinion의 가치 입증.

---

## 3. 운영 가이드

### 모델 폴백 정책
preflight(`codex-preflight.sh`)가 단일 진실원: 후보 순회 `gpt-5.5 → gpt-5.5-codex → gpt-5.1 → gpt-5.1-codex`.
- `AVAILABLE model=<m>` → 그 모델로 `-m` 지정.
- `AUTH_STALE` → 토큰 만료. 사용자 `codex login` 필요 → **Claude 단독 폴백**.
- `DEADLOCK`/`UNAVAILABLE` → 모델 전부 400 / codex 미설치 → **Claude 단독 폴백**.

### 행(hang) 방지 [HARD]
- codex 호출엔 **항상 `< /dev/null`** (stdin 트랩 차단, §1 ★).
- 타임아웃은 넉넉히(권장 600000ms). 단 stdin만 닫으면 small 검증은 ~30초로 빠름 —
  10분+ 행이 보이면 effort 탓이 아니라 stdin/네트워크를 의심.
- 작업 디렉토리가 별도 git repo가 아니면 `--skip-git-repo-check`.

### codex 미가용 시 (절대 pending 금지)
하네스는 반드시 **"codex 미가용 — Claude 단독 진행"** 을 명시 출력하고 진행한다.
`codex-review.sh`는 미가용 시 exit 2 + stderr `CODEX_UNAVAILABLE: ... Claude 단독 진행`.
호출 측은 exit 2를 만나면 reconcile 단계를 "codex 입력 없음"으로 기록하고 GO/NO-GO를
Claude 실측만으로 낸다(행/대기 금지).

### 대용량 아티팩트 전달
- 프롬프트에 본문을 stuff하지 말 것. `-C <workdir>`로 디렉토리를 주고 **codex가 파일명을
  열어 직접 읽게** 한다(프롬프트엔 "어느 파일을 읽고 무엇을 확인하라"만).
- 단, codex는 `-C` 루트 **밖**(예: `~/.claude/`, repo 밖 plan 파일)은 못 읽음 → 그런
  자료는 workdir 안으로 복사하거나 프롬프트에 임베드.

### 읽기전용 안전
`-s read-only`로 codex는 어떤 파일도 쓰/수정 못 함. 산출은 stdout 의견뿐. 교정·COMMIT은
전적으로 Claude/인간 경로(이 하네스는 분석·합의까지, 실 적용은 별도 승인).

### 비밀 위생 [HARD]
`.env.local` 값(RAILWAY_DB_*, HUNI_ADMIN_*, EDICUS_* 등)을 **프롬프트·workdir·stdout에
절대 넣지 말 것**. codex 프롬프트는 키 이름/역할까지만. 라이브 접속이 필요한 검증은
Claude가 수행하고 codex엔 산출 요약만 전달.

---

## 4. 본 목적("RE 코드가 실제 동작/재현되는가")용 교차검증 구조

### codex가 독립으로 볼 것 vs Claude가 볼 것
- **codex(읽기전용·오프라인 추론)**: 역공학 리포트/추출 코드의 **내부 정합성**을 본다 —
  ① 문서가 주장하는 API 계약/필드/시퀀스가 자기 근거(같은 HTML/코드)와 일치하는가,
  ② 누락·모순·"근거 없이 단정한" 부분, ③ 재현 절차의 논리적 구멍(이 입력으로 이 출력이
  나올 수 없는 케이스), ④ false-positive(정당한 동작을 결함으로 오판).
- **Claude(라이브/캡처 실측)**: codex가 가설로 던진 것을 **실제 증거로 검증** —
  widget_monitor 캡처·라이브 응답·실제 필드 페이로드와 대조해 "정말 그렇게 동작하는가".

### codex 주장 = 가설 (환각 가드)
codex 출력은 라이브/캡처로 확증되기 전까지 **사실 아님**. "확인 필요 후보"로 라우팅하고,
채택은 Claude 실측 후. codex가 인용한 출처는 반드시 원본에서 재확인(§2의 grep 대조처럼).

### reconcile 패턴
- **합의(codex ∧ Claude 일치)** → 고신뢰. 그대로 검증 결론.
- **불일치(codex만 / Claude만)** → 조사 항목. 원본·라이브 재실측으로 누가 맞는지 판정,
  근거 못 대면 "미확정"으로 정직 기록(어느 쪽도 사실로 승격 금지).

---

## 5. 재사용 래퍼 패턴

`codex-review.sh`를 **재사용**한다(신규 스크립트 불필요). 4번째 인자 effort →
`-c model_reasoning_effort=<effort>`, `-s read-only`, `-C <workdir>`, preflight 폴백, 미가용
exit 2 전부 갖춤.

**★ 이번에 한 패치(필수·3곳, 라이브 검증됨)**:
- `codex-review.sh` `run_codex()`: `codex exec ... --skip-git-repo-check "..." </dev/null`
- `codex-review.sh` preflight 호출: `PF="$(bash "$PREFLIGHT" </dev/null 2>/dev/null | tail -1)"`
- `codex-preflight.sh` probe: `codex exec ... --skip-git-repo-check ... "$PING" </dev/null`

패치 전: 비-git cwd에서 거짓 DEADLOCK + 파이프 호출 시 행. 패치 후: 비-git `/tmp`
cwd에서도 **RC=0·27초·grounded 출력**(엔드포인트 `/ko/product_price/get_ajax_price_vTmpl`,
필드 PDT_CD/WRK_WDT/WRK_HGH, 출처 "6.1 가격 계산 API" — HTML 대조 환각 0).

```bash
SCRIPT=/Users/innojini/Dev/HuniWeb/.claude/skills/hqv-codex-cross-verify/scripts/codex-review.sh

# 1) 검증 프롬프트 파일 작성 (역공학 리포트 + 재현 질문 + "출처 강제, 모르면 not found")
PROMPT=_workspace/huni-re-verify/05_codex/verify-prompt.txt   # 예시 경로

# 2) HIGH effort 로 codex 독립 검증 (workdir = 역공학 자료 루트)
bash "$SCRIPT" "$PROMPT" gpt-5.5 /Users/innojini/Dev/HuniWeb/docs/reversing high \
  > _workspace/huni-re-verify/05_codex/codex-verdict.txt 2>codex.err
RC=$?
# RC=0 정상 / RC=1 프롬프트없음 / RC=2 codex 미가용 → "Claude 단독" 명시 폴백
[ $RC -eq 2 ] && echo "codex 미가용 — Claude 단독 진행 (pending 아님)"
```

타임아웃: 호출 측 Bash `timeout`을 **최소 600000ms(10분)** 로(HIGH 느림).
모델 인자는 `gpt-5.5` 고정이 아니라 preflight 결과를 따르되, 스크립트 내부에서 이미
preflight로 가용 모델로 덮어쓰므로 인자는 힌트값으로 둬도 됨.

신규 스크립트가 필요한 유일한 경우: JSONL 스트리밍으로 codex 추론 트레이스(`[codex thinking]`)를
실시간 캡처하려 할 때(공식 스킬 Step 2B의 `--json` + python 파서). 본 하네스 검증엔
verbatim stdout으로 충분하므로 `codex-review.sh` 권장.
