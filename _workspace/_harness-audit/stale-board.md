# STALE 보드 — 이전버전 전제를 담은 에이전트·스킬

감사일: 2026-06-18 · "현재 사실"은 라이브 소스/CLAUDE.md/MEMORY 근거 첨부 · 읽기 전용

## S-1. [HIGH] round-18 가격엔진 "evaluate_price 미구현" 전제 — STALE

직전 검증·§13/§14에서 `evaluate_price`가 **구현 확인**됐는데, round-18 산출물 3종이 여전히 "엔진 미구현, pricing.py 부재, 호출할 엔진 없음"을 전제로 함.

### 현재 사실 (근거)
- `raw/webadmin/webadmin/catalog/pricing.py` **실재**(569줄), `def evaluate_price(...)` **line 247**에 구현.
- `raw/webadmin/webadmin/catalog/price_views.py` 실재(뷰어/시뮬레이터/진단뷰).
- CLAUDE.md §13(line 223): "라이브 가격엔진(`catalog/pricing.py`의 `evaluate_price` **단일 권위 알고리즘**)".
- CLAUDE.md §14(line 238): "프로그램 코드(`pricing.py`·`price_views.py`)가 ... 구현됐는지 진단".
- MEMORY `huni-price-quote-harness.md`: "webadmin에 `pricing.py`(엔진)·`price_views.py` 실재 → 이전 메모리의 **'evaluate_price 미구현(round-18)'에서 상태 변화**. 라이브 적재됨: 공식 48·단가행 7,293...".

### STALE 산출물 (전제가 현재 사실과 모순)
| 대상 | STALE 문구 | 근거 위치 |
|------|-----------|-----------|
| `agents/huni-dbmap/dbm-price-engine-verifier.md` | description: "라이브 가격 계산 엔진(evaluate_price)이 **미구현임이 라이브 확인된 상태에서** ... 호출할 엔진이 없으므로" | frontmatter description |
| `skills/dbm-price-engine-verify/SKILL.md` | description: "라이브 계산 엔진(evaluate_price)이 **미구현임이 라이브 가격뷰어('가격엔진 다음 단계 완성 후 활성화')로 확인된 상태에서, 호출할 엔진이 없으므로**" | frontmatter description + 본문 |
| `skills/huni-dbmap-orchestrator/SKILL.md` | round-18 행(line 37·81·344): "라이브 `evaluate_price` 미구현[가격뷰어 ⑤ '다음 단계 완성 후 활성화'·`pricing.py` 부재·ROADMAP Phase 11 미완·gstack 실증] 확인 후 ... 호출할 엔진 없음→검증용 재계산이 핵심" | round 테이블 + 에이전트 표 + 프레임 노트 |
| `skills/dbm-batch-load/references/batch-patterns.md` | "evaluate_price ... 미구현" 인용(`grep -rl` 히트) | references |

### 영향
- 이 전제 위에서 round-18은 "엔진을 호출하지 않고 명세 기반 재계산기를 재구현"하는 우회를 정당화 — 이제 엔진이 실재하므로 §13(hpq) "evaluate_price 실호출/계약 추출" 트랙과 **방법론이 충돌**. round-18 우회(recompute.py)는 불필요해졌거나 보조로 격하 가능.
- 정리 후보: dbm-price-engine-verifier·dbm-price-engine-verify·huni-dbmap-orchestrator round-18 행을 "엔진 실재→재계산은 교차검증 보조" 로 갱신하거나 §13 hpq로 흡수(가격 클러스터 별도 감사 협의).

## S-2. [MED] huni-dbmap-orchestrator round-2 가격 산출 "stale" 자기기술 — 의도된 표기지만 누적 부채

orch가 round-16/18 프레임 노트에서 "round-2 산출은 round-14 진단대로 **stale**(8→10차원·단가/합가·template_prices 누락)"을 반복 표기. 이는 의도된 경고(STALE 인용 금지)지만, round-2 스킬(`dbm-price-formula`)·에이전트 본문은 그 stale 경계를 자기 description에 담지 않아 신규 세션이 round-2 스킬을 단독 호출하면 stale 산출을 권위로 오인할 위험.
- 근거: `huni-dbmap-orchestrator/SKILL.md` line 59·328. `dbm-price-formula/SKILL.md` description엔 stale 경고 없음.
- 정리 후보(경미): dbm-price-formula description에 "round-2 스냅샷 스키마 기준·최신은 round-16 그릇 우선" 1줄 추가. (가격 클러스터 감사 협의)

## S-3. [LOW] dbm-schema-analyst 테이블 수 불일치 — 사실 드리프트

`agents/huni-dbmap/dbm-schema-analyst.md` description: "**29개 테이블**". 그러나 `huni-dbmap-orchestrator` 최신 description은 "**44테이블 — t_* 도메인 34 + Django 10**". CLAUDE.md §7도 "t_* 34테이블".
- 근거: agent description "29개 테이블" vs orchestrator/CLAUDE.md "34/44".
- 정리 후보: dbm-schema-analyst description의 "29"를 현재 수(34 도메인 / 44 전체)로 갱신.

## S-4. [LOW] round-superseded 참조 점검 결과 — 추가 STALE 미발견

- round-N 산출 인용은 대부분 "인용·정합·중복 재진단 금지" 형태로 의도적 참조 → superseded 단정 어려움.
- MEMORY 인덱스의 STALE 표시(prcx01 설계산출물 STALE·v03 배제·06_extract 260527 stale)는 **에이전트/스킬 description엔 전파 안 됨**이나, 이는 산출물(workspace) 레벨 stale이지 에이전트 정의 stale은 아님 → 본 감사 범위(에이전트/스킬 정의)에선 S-1만 정의 레벨 STALE로 확정.

## STALE 집계
- 정의 레벨 STALE 확정: **S-1 (HIGH, 4개 파일)** + S-3 (LOW, 1개 파일).
- 경계성/부채: S-2(round-2 stale 경고 미전파)·S-4(workspace 레벨, 범위 밖).
