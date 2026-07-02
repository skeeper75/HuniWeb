# wave-2 CN-5 범위·증분 규칙 — 설계 판정 (전건 BLOCKED)

> §31 Huni-Constraint-Rules · Phase 2 · hcr-rule-designer · 2026-07-02
> 입력: `constraint-candidates.csv` CN-5 High 19건 · `views.py` 폼빌더 역파싱 로직 실측

---

## 0. 결론 — 설계 가능분 0건 · BLOCKED 19건

wave-2 CN-5(자유치수 nonspec 상품의 가로/세로 범위) High 19건은 **폼빌더 역파싱 가능한 정형
shape 로 표현 불가** → 규약([HARD] "raw escape hatch 로만 표현되는 규칙은 설계 반려") 에 따라
**전건 설계 반려(BLOCKED)**. 죽은 규칙 mint 금지.

## 1. BLOCKED 사유 (2중 구조적 한계)

범위 규칙은 본질적으로 `width >= min AND width <= max AND height >= min AND height <= max`
형태의 **수치 부등호**가 필요하다. 그런데 폼빌더는:

1. **연산자 한계** — `_dim_clause`(views.py:106-114)가 생성하는 연산자는 `===` / `in` **뿐**.
   `>=`·`<=`·`<`·`>` 를 만드는 경로가 없다. `_parse_logic_to_conditions` 도 leaf 를
   `===` / `in` 만 인식(`_is_leaf`, views.py:239-241) → 부등호 절은 역파싱 불가.
2. **var 계약 한계** — 폼빌더 `VAR_KEY_MAP`(views.py:52-60)은 7개 ref_dim(`siz_cd`·`plt_siz_cd`·
   `mat_cd__usage_cd`·`proc_cd`·`bdl_qty`·`opt_id`·`sub_prd_cd`)+옵션 2배열만 역매핑한다.
   `width`·`height`·`size_mode` 는 **폼빌더 VAR_KEY_MAP 에 없음** → `_REVERSE_VAR_KEY.get("width")`
   = "" → `_clause_to_row` 가 None → 역파싱 실패.

### 실측 대조 (기존 committed 범위 규칙 = 전부 RAW-ONLY)
118·120·121·122·124·125·139 에 이미 committed 된 범위 규칙(RULE_001)은:
```json
{"or": [{"!=": [{"var":"size_mode"}, "nonspec"]},
        {"and": [{">=": [{"var":"width"}, 200]}, {"<=": [{"var":"width"}, 1200]},
                 {">=": [{"var":"height"}, 200]}, {"<=": [{"var":"height"}, 3000]}]}]}
```
→ `>=`·`<=`·`!=`·`width`·`height`·`size_mode` 사용 = **폼빌더 고급(raw) 창으로만 열리는
escape-hatch 규칙**. `parse_check.py` 계열 역파서로 열리지 않는다. 19건을 같은 형태로 mint 하면
"UI-확인가능 우선"[HARD] 을 정면 위반.

### 죽은 규칙 여부 (뉘앙스)
- 런타임 var 계약(spec §1)에는 `width`/`height`/`size_mode` 가 포함되고, 위 7건이 라이브에 이미
  존재하므로 **런타임 평가는 됨**(panzi-json-logic 은 `>=`/`<=` 지원) → 엄밀히는 "죽은 규칙"은
  아니다. 그러나 **폼빌더로 관리 불가(역파싱 실패)** → 본 하네스의 [HARD] "UI-확인가능 우선"
  기준에서 **BLOCKED-UI** 로 분류(raw-only 규칙 신설 금지).

## 2. BLOCKED 목록 (19건)

| prd_cd | 상품 | 범위(w×h mm) | 분류 |
|--------|------|--------------|------|
| PRD_000119 | 아트페이퍼포스터 | 200~900 × 200~3000 | BLOCKED-UI |
| PRD_000123 | 아트패브릭포스터 | 200~1200 × 200~3000 | BLOCKED-UI |
| PRD_000126 | 레더아트프린트 | 200~600 × 200~3000 | BLOCKED-UI |
| PRD_000127 | 타이벡프린트 | 200~1200 × 200~3000 | BLOCKED-UI |
| PRD_000128 | 메쉬프린트 | 200~600 × 200~3000 | BLOCKED-UI |
| PRD_000138 | 일반현수막 | 500~1750 × 500~5000 | BLOCKED-UI |
| PRD_000146 | 아크릴키링 | 20~100 × 20~100 | BLOCKED-UI |
| PRD_000147 | 아크릴마그넷 | 20~80 × 20~80 | BLOCKED-UI |
| PRD_000148 | 아크릴뱃지 | 30~80 × 30~80 | BLOCKED-UI |
| PRD_000149 | 아크릴집게 | 30~60 × 30~60 | BLOCKED-UI |
| PRD_000150 | 아크릴스마트톡 | 50~80 × 50~80 | BLOCKED-UI |
| PRD_000151 | 맥세이프 스마트톡 | 50~80 × 50~80 | BLOCKED-UI |
| PRD_000152 | 아크릴명찰 | 60~80 × 20~50 | BLOCKED-UI |
| PRD_000153 | 아크릴명찰(골드실버) | 60~80 × 20~50 | BLOCKED-UI |
| PRD_000154 | 아크릴 머리끈 | 20~40 × 20~40 | BLOCKED-UI |
| PRD_000155 | 아크릴볼펜 | 20~40 × 20~40 | BLOCKED-UI |
| PRD_000156 | 아크릴지비츠 | 15~35 × 15~35 | BLOCKED-UI |
| PRD_000164 | 아크릴코롯토 | 30~80 × 30~80 | BLOCKED-UI |
| PRD_000171 | 지비츠★ | 15~35 × 15~35 | BLOCKED-UI |

(범위 원천: `constraint-candidates.csv` 근거열 nonspec 컬럼값. 실 min/max 은 각 상품
`t_prd_products.nonspec_*_min/max` 실측으로 게이트 단계 재확인.)

## 3. 라우팅 (죽은 규칙 mint 대신)

이 19건은 실제 High 갭(off-grid 0원/과금 위험)이 맞다. 다만 **제약 폼빌더가 아닌 다른 계층**에서
해소해야 한다:

1. **컬럼 강제(우선)** — 각 상품 `nonspec_width/height_min/max/incr` 컬럼이 이미 존재(판례 P-4).
   §6 위젯이 이 컬럼값으로 입력 범위·증분을 **직접 강제**(min/max/step) → 제약규칙 불요.
   이것이 가장 단순한 정답(규칙 없이 UI 가 컬럼으로 막음).
2. **빌더 확장(개발 요청)** — 범위 규칙을 UI 로 관리하려면 폼빌더에 **수치 범위 조건 타입**
   (연산자 `>=`/`<=`, var `width`/`height`/`size_mode`)을 추가해야 함. 추가되면 19건 + 기존 7건이
   모두 UI-관리 가능해짐. → dev-handoff(§C-5 연장) 개발 요청 항목.
3. **현행 7건(118 등)** — raw-only 이나 이미 committed·런타임 동작. 빌더 확장 전까지 유지
   (본 designer 가 건드리지 않음).

## 4. 산출

- BLOCKED-UI 19건은 규칙·SQL 산출 없음(mint 금지). 본 문서가 판정 근거.
- 해소 경로는 §6 위젯(컬럼 강제) + 폼빌더 수치범위 확장(개발) — 본 하네스 범위 밖.
