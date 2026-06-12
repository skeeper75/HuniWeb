---
name: pkw-wiki-evaluation
description: 후니프린팅 Print-KB LLM 위키의 엄밀 평가 방법론 스킬 — W1~W8 게이트 정의·lint 스크립트 패턴·verdict 포맷. W1 인용 실재성(라인 단위 의미 대조), W2 링크 무결성(깨진 [[참조]]·고아 페이지), W3 스키마 앵커(라이브 information_schema 실측 대조), W4 badge 정합(✅ 인플레 적발), W5 stale/v03 인용 차단, W6 CQ 커버리지, W7 index/log 일관성, W8 레시피 실행가능성(dry walk-through). '위키 검증', '위키 QA', 'W게이트', 'W1 W8', '레시피 검증', '인용 실재성', '링크 무결성 검증', '위키 lint', '커버리지 게이트', '위키 게이트 재실행' 작업 시 반드시 이 스킬을 사용. 집필 컨벤션은 pkw-recipe-authoring, 원천 등급은 큐레이션 팩이 담당하므로 그 작업에는 트리거하지 않는다.
---

# Wiki Evaluation — W1~W8 Gates

검증 대상 = `wiki/recipes/*` · `wiki/huni/*` (+ 전체 scope 시 index/log/base/policy 정합). 검증자는 생성자와 독립이며, 모든 FAIL은 (블록 인용)+(재현 가능한 반대 증거) 쌍을 가진다.

## W1 — 인용 실재성 (FABRICATED 적발)

페이지의 모든 `출처:` 라인을 추출 → 인용 파일 실재(Glob) → 해당 §/라인 Read → **의미 대조**(블록의 주장을 그 출처가 실제로 말하는가). 존재만 확인하고 통과시키지 않는다 — G-1(인용 라인 deob 부존재)·F-PB-1(엑셀 공란을 MISSING으로 날조)은 모두 "존재하는 파일의 없는 내용" 사례였다.

```bash
# 출처 추출 패턴
grep -n '^- 출처:' wiki/recipes/<family>.md | sed 's/.*출처: //'
```

판정: 출처 부재=FABRICATED · 의미 불일치=FABRICATED · 출처가 🟡문서인데 블록 ✅=W4로 이관.

## W2 — 링크 무결성 (BROKEN-LINK / 고아)

`[[page#anchor]]` 전수 추출 → 대상 파일·앵커 실재 검사. 역방향: 어떤 페이지에서도 참조되지 않고 index에도 없는 페이지 = 고아. `_`-prefix 폴더는 그래프에서 제외.

```bash
grep -ohE '\[\[[^]]+\]\]' wiki/{recipes,huni,base,policy}/*.md | sort -u
```

## W3 — 스키마 앵커 (SCHEMA-MISMATCH)

각 섹션/블록의 `앵커:` 가 가리키는 t_* 테이블·컬럼을 라이브 `information_schema`로 읽기전용 실측(권위=라이브, 문서 아님 — round-8 tags jsonb 교훈). 코드값(PRF_*, MAT_TYPE.*)은 해당 테이블 SELECT로 실재 확인. "앱 계산"/🔴GAP 표기 항목은 앵커 면제 — 단 면제 표기 자체가 있어야 PASS.

```bash
set -a; source .env.local; set +a
PGPASSWORD="$RAILWAY_DB_PASSWORD" psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" \
  -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -tAc \
  "SELECT column_name FROM information_schema.columns WHERE table_name='t_prc_price_formulas'"
```

비밀값을 verdict 문서에 절대 기록하지 않는다.

## W4 — badge 정합 (BADGE-INFLATED)

✅ 블록 전수: 출처 tier가 A/B(라이브 스키마·L1 엑셀·실무진 확정) 또는 GO 판정 round 산출인지 큐레이션 팩으로 대조. 🟡 출처만으로 ✅면 FAIL. 역방향(과소 — 권위 출처인데 🔴)은 Low finding.

## W5 — stale/v03 전파 차단 (STALE-CITED)

인용 전수 × 큐레이션 팩의 freshness 등급 대조. STALE 인용=FAIL(대체 소스 제시). `v03`/`prdmaster_full_migration_v03` 문자열 인용=무조건 FAIL[HARD]. 팩에 없는 출처=UNGRADED-CITED(escalate, FAIL 아님).

## W6 — CQ 커버리지 (COVERAGE-GAP)

`answers_cq:` 역추적 → `cq-registry.md`의 해당 그룹(제품/가격/공정/...) CQ 중 이 family 범위 CQ가 답변됐는지 커버리지%. 목표는 orchestrator가 지정(기본: family 관련 CQ 80%+). 미답 CQ는 GAP 목록으로.

## W7 — index/log 일관성

recipes/huni 모든 페이지가 index.md에 1줄 등재 + 이번 작업이 log.md에 append됐는지. index 요약과 페이지 실제 상태(badge 분포) 불일치 검사.

## W8 — 레시피 실행가능성 (NOT-EXECUTABLE)

레시피의 핵심 가치 검증: 페이지만 보고 "이 상품군의 신상품 1개를 등록"하는 dry walk-through를 수행한다 — 0정체→6적재경로 순서로 각 단계에서 **구체 입력**(테이블·컬럼·값/코드·화면)을 페이지가 제공하는지 체크리스트화. "어딘가 다른 문서를 봐야 알 수 있음" = 그 단계 FAIL(단, [[link]]로 축 페이지가 답하면 PASS). 실제 INSERT는 하지 않는다.

## Verdict 포맷

`wiki/_qa/<scope>-gate.md`:

```markdown
# <scope> W-gate verdict — GO|CONDITIONAL-GO|NO-GO (YYYY-MM-DD)
| 게이트 | 결과 | findings |
|---|---|---|
| W1 인용 실재성 | PASS/FAIL | n건 |
...
## Findings
| ID | 페이지#블록 | 게이트 | 분류 | 증거(재현 명령/라인) | 보정 제안 |
## 재현
<사용한 스크립트/명령 전체 — 비밀값 제외>
```

GO = 전 게이트 PASS. CONDITIONAL-GO = Low만 잔존. NO-GO = FABRICATED/SCHEMA-MISMATCH/STALE-CITED 1건 이상 또는 W8 핵심 단계 FAIL.

## 운영 규칙

- family 페이지 완성 직후 점진 실행(incremental). 전체 lint는 마일스톤 시 1회.
- 동일 페이지 3회 NO-GO → 페이지 보정이 아니라 스키마/팩 재설계 권고로 전환.
- lint 헬퍼가 반복되면 `wiki/_qa/scripts/`에 저장해 재사용(매번 재작성 금지).
