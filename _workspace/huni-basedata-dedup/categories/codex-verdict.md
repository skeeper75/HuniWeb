# codex-verdict — 카테고리 축 표시중복 정리 2차 교차검증 (codex gpt-5.5)

생성: 2026-06-19 / 검증자: codex gpt-5.5 (read-only sandbox) / 호출: `cat codex-prompt.txt | codex exec -s read-only -`
가용성: **AVAILABLE model=gpt-5.5** (codex-preflight EXIT=0) · session 019edd9c
원문 보존: `~/.claude/projects/.../tool-results/byha8wirh.txt` (1193줄·세션 추적용)

> ★[HARD 환각 경계] codex(OpenAI) 주장 = 외부 의견·가설. 라이브/MAP 권위로 검증 전엔 사실 아님.
> 아래는 codex 원문 + Claude의 환각 경계 주석(✓검증·⚠가설·✗반증).

## codex 행동 관찰 (자율 검증 추적)
codex는 work-spec만 받지 않고 자율적으로:
1. `dbm-category-audit/SKILL.md` 읽어 MAP IA 검증 렌즈(섹션 ▶︎ vs 상품 분리) 적용
2. 작업폴더 산출물(dedup-report·mapping.csv·apply-plan·live.csv·index.csv) 행 단위 재대조
3. §2/§3 권위 범위 안에서만 판정(work-spec 명시 준수)
→ 산출물 인용이 work-spec §2/§3과 일치함을 자체 확인 후 "Claude 판정을 역방향으로 흔들기" 수행.

## codex 판정 원문 (요약)

| 검토점 | codex 판정 | 핵심 |
|---|---|---|
| **Q1 빈노드 318/319/320** | **STRONGER** | A(채움) 방향이 더 타당. 단 안전 적재 대상 아님·인간 IA 승인 후 별도 실행. B(폐기)는 MAP 권위 의도 버림이라 dedup이 단정 불가. ★main='N' append 안전성 미증명. |
| **Q2 동명 104/105** | **AGREE** | 104 rename 합의. 105 삭제/흡수=false-merge(상품22 잎). 사이즈 105 삭제패턴 카테고리 적용 금지. |
| **Q3 junction del_yn 부재** | **AGREE w/ nuance** | junction 컬럼에 del_yn 없음 확인 → 채움=물리 append·제거=물리 DELETE. 단 노드(t_cat) 자체 폐기가 물리 DELETE인지 del_yn=Y인지는 별도 정책. |
| **Q4 누락 위험** | **STRONGER** | 큰 false-merge 없음·112/115 keep 안전. ★신규 위험 2: ① main_cat_yn 불변식 ② CAT_000114(PRD_000110이 114에도 main=Y). |

**codex 최종 안전 적재 권고**: `CAT_000104 cat_nm '하드커버책자' → '하드커버'` **1건뿐**. 105/112/115 keep,
318/319/320 삭제 금지·A(채움) 방향 인간 IA 승인 후 별도.

## codex 신규 발견 2건 — Claude 라이브 검증 (가설→사실 판정)

### 발견-1 [⚠가설→✓CONFIRMED] main_cat_yn 단일성 불변식 미강제
codex: "PRD_000110이 CAT_000112·CAT_000114 둘 다 main=Y → 단일 main 불변식 깨졌거나 강제 안 됨."
**라이브 검증(SELECT)**: main='Y' 다중 보유 prd_cd **8건**(PRD_000019~025 7건 + PRD_000110).
→ ✓ codex 가설 **CONFIRMED**. DB가 main_cat_yn 단일성을 강제하지 않음.
→ Claude apply-plan §6의 "main_cat_yn='N' append" 가정이 **안전하다고 증명되지 않음**(codex STRONGER 정당).

### 발견-2 [⚠가설→부분✓] CAT_000114 상태 확인 필요
codex: "PRD_000110→CAT_000114(main=Y)가 있으나 114 활성여부 미확인 → 320(엽서캘린더) 채움 시 세 갈래 위험."
**라이브 검증(SELECT)**: CAT_000114='엽서캘린더'·**del_yn='Y'(논리삭제됨)**. PRD_000110의 활성 귀속은 CAT_000112만.
→ codex 우려한 점검은 **정당**(확인 안 했으면 위험). 실측 결과 114 이미 del → 320 채움 시 활성 충돌 없음.
→ ★단 Claude dedup-report는 PRD_000110→"112/114"라 적었으나 **114가 del='Y'임을 본문서 활성 충돌로는 제외**했음(report ℓ79·ℓ41 형제 114 del=Y 언급 있음). codex가 이를 명시 경고로 격상.

## 환각 경계 최종 점검
- codex가 인용한 §2/§3 모든 근거 = work-spec에 Claude가 라이브/MAP에서 실측 제시한 것. codex는 외부 사실 날조 0(권위 범위 내 추론만).
- codex 신규 발견 2건 모두 라이브 SELECT로 재대조 → 발견-1 CONFIRMED·발견-2 부분확인. **codex 환각 0**.
