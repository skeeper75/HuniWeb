# wave-1 파일럿 규칙 설계서 (129 폼보드 · 130 포맥스보드)

> §31 Huni-Constraint-Rules · Phase 2 · hcr-rule-designer · 2026-07-02
> 입력: `01_scenario/constraint-need-spec.md`(판례 P-1)·`constraint-candidates.csv`(129/130 CN-2)
> 유도 원천: 라이브 `t_prc_component_prices` (읽기전용, 유도 시점 2026-07-02 13:59:30)
> 자가검사: `raw/webadmin/webadmin/catalog/views.py` `_parse_logic_to_conditions` verbatim 대조(→ `parse_check.py`)

---

## 0. 요약

- CN-2(단가행 부재 엇갈림). 폼보드·포맥스보드는 자재명에 사이즈가 내장(A3/A2 전용)돼
  자재×사이즈 8셀 중 대각선 4셀만 단가행이 있고, 나머지 4셀은 견적 0원이 그대로 노출된다
  (`evaluate_price`는 제약을 안 봄). → **자재별 필수동반 사이즈**로 명시 차단.
- **기존 `R_DEMO_MATSIZ`(상품당 1규칙, `{"and":[OR,OR,OR,OR]}`)는 폼빌더가 역파싱 못 함**
  (`.03` 역파서는 최상위 `"or"` 를 기대하는데 최상위가 `"and"`) → **RAW-ONLY(규약 위반)**.
  → 자재별 단일 implication 8규칙으로 **분할**해 전부 폼빌더 역파싱 가능하게 재설계.
- **자동 유도**: 각 자재의 허용 사이즈를 단가행에서 유도(수동 나열 금지·drift 제거).
  유도 결과 = **자재당 사이즈 정확히 1개(1:1)** → 단일 `.03` result 로 표현 가능.

## 1. 유도 결과 (2026-07-02 스냅샷 · `derive-snapshot.csv`)

| 상품 | 컴포넌트 | 자재(mat_cd__usage_cd) | 허용 사이즈 | 차단 사이즈 |
|------|----------|------------------------|-------------|-------------|
| 129 폼보드 | COMP_POSTER_FOAMBOARD_BOARD | MAT_000398__USAGE.07 (A3 화이트 5mm) | SIZ_000315 A3 | SIZ_000198 A2 |
| 129 | 〃 | MAT_000399__USAGE.07 (A3 블랙 5mm) | SIZ_000315 A3 | SIZ_000198 A2 |
| 129 | 〃 | MAT_000612__USAGE.07 (A2 화이트 5mm) | SIZ_000198 A2 | SIZ_000315 A3 |
| 129 | 〃 | MAT_000613__USAGE.07 (A2 블랙 5mm) | SIZ_000198 A2 | SIZ_000315 A3 |
| 130 포맥스 | COMP_POSTER_FOMEXBOARD_BOARD | MAT_000022__USAGE.07 (3mm A3) | SIZ_000174 A3 | SIZ_000197 A2 |
| 130 | 〃 | MAT_000554__USAGE.07 (3mm A2) | SIZ_000197 A2 | SIZ_000174 A3 |
| 130 | 〃 | MAT_000023__USAGE.07 (5mm A3) | SIZ_000174 A3 | SIZ_000197 A2 |
| 130 | 〃 | MAT_000555__USAGE.07 (5mm A2) | SIZ_000197 A2 | SIZ_000174 A3 |

- **막는 조합 = 8셀**(상품당 오프대각 4셀 × 2상품). 정당 조합(대각 4셀×2=8) 오차단 0.
- 재생성: `python3 derive_matsiz.py` → 새 자재/사이즈 추가 시 규칙 자동 갱신(수동 drift 제거).

## 2. 규칙별 명세

각 규칙은 동일 골격. CN유형=CN-2 · rule_typ_cd=RULE_TYPE.03(필수동반) · 대상 var=`mat_cd__usage_cd`(조건)·`siz_cd`(결과).

### 정형 shape (폼빌더 `_build_logic_from_conditions` .03 과 동형)

```json
{"or": [
  {"!": {"===": [{"var": "mat_cd__usage_cd"}, "<MAT>__USAGE.07"]}},
  {"===": [{"var": "siz_cd"}, "<SIZ>"]}
]}
```

뜻: **이 자재를 고르면(mat===MAT) 사이즈는 반드시 SIZ 여야 한다.** 다른 자재일 때는 antecedent
가 거짓이라 `{"!":...}` 가 참 → 규칙 통과(간섭 없음). 활성 8규칙을 엔진이 `{"and":[...]}` 로 병합하면
구 `R_DEMO_MATSIZ` 의 AND-of-4-OR 과 **논리적으로 완전히 동일**(분할만 함).

★ 주의(정형성 함정): 부정은 반드시 `{"!": {"===": ...}}` 형태여야 한다. 구 규칙처럼 `{"!==": ...}`
를 쓰면 `.03` 역파서의 `neg_part.get("!")` 가 None 이 되어 **폼빌더가 못 연다**. 유도 스크립트가
이 형태를 강제 생성한다.

### 규칙 목록 (logic·err_msg·validate 케이스)

각 규칙의 완전한 logic·pass/block 데이터는 `derived-rules.json` 에 verbatim 보존.
아래는 대표 2건(나머지 6건 동형 — `rules.csv`).

| rule_cd | 조건 자재키 | 결과 사이즈 | err_msg |
|---------|-------------|-------------|---------|
| R_MATSIZ_FB_A3_WHITE_5MM | MAT_000398__USAGE.07 | SIZ_000315 A3 | 이 자재(A3 폼보드(화이트) 5mm)는 A3 크기 전용입니다. 크기를 A3로 선택해 주세요. |
| R_MATSIZ_FX_A2_WHITE_5MM | MAT_000555__USAGE.07 | SIZ_000197 A2 | 이 자재(포맥스(화이트) 5mm A2)는 A2 크기 전용입니다. 크기를 A2로 선택해 주세요. |

### validate 케이스 (규칙마다 막힘1·통과1 — `parse_check.py` 로 8/8 재현 확인)

예) R_MATSIZ_FB_A3_WHITE_5MM
- **통과**: `{"mat_cd__usage_cd":"MAT_000398__USAGE.07", "siz_cd":"SIZ_000315"}` → 허용(A3 자재+A3 크기)
- **막힘**: `{"mat_cd__usage_cd":"MAT_000398__USAGE.07", "siz_cd":"SIZ_000198"}` → 차단(A3 자재+A2 크기)

`parse_check.py` 결과: **8/8 PARSEABLE · 통과재현 True · 막힘재현 True.**

## 3. 폼빌더 역파싱 자가검사 결과 (`parse_check.py`)

| 규칙 | 역파싱 | 판정 |
|------|--------|------|
| 설계 8규칙 (R_MATSIZ_*) | PARSEABLE | ✅ 규약 충족 |
| 구 R_DEMO_MATSIZ (AND-of-OR) | RAW-ONLY | ❌ 대체 대상(논리삭제) |

## 4. search-before-mint 결정

- 구 `R_DEMO_MATSIZ`(129·130 각 1행, 라이브 실재) → **논리삭제**(`use_yn='N', del_yn='Y'`).
  1규칙→8규칙 **분할**이라 내용 동일 UPDATE-개명 불가 → 신규 mint + 구규칙 논리삭제.
- 신규 rule_cd `R_MATSIZ_*` 는 라이브 미존재 확인(멱등 UPSERT).

## 5. 경계·함정 (spec 명시)

- **증상 완화 태그**: 근본 원인은 자재 모델링 미정규화(자재명에 사이즈 내장). 근본 교정은
  §7 dbmap / §12 basecode 트랙. 본 규칙은 **증상 완화**(0원 오노출 차단)일 뿐 근본 아님.
- **강제 지점 한계**: `evaluate_price`/`simulate` 는 제약을 안 봄 → 규칙을 넣어도 오프대각 셀의
  견적 0원 자체는 그대로. 규칙은 **위젯/주문이 `/validate/` 를 호출해 선택을 차단**할 때만 효력
  (§6 위젯 계약·§24 주문 게이트). 이 규칙은 "선택 차단용"이지 "가격 교정"이 아님.
- **오차단 0 재확인(게이트용)**: 유도 스냅샷(2026-07-02) 이후 새 (mat,siz) 단가행이 추가됐는지
  gate 에서 `derive_matsiz.py` 재실행으로 재확인(정당 조합 오차단 방지).

## 6. 적재본

- `apply-dryrun.sql` — BEGIN…ROLLBACK. 라이브 실행 검증 완료(UPDATE 2 + INSERT 8, JSONB 캐스팅
  정상=500 위험 없음, 활성 8 + 구데모 비활성 확인 후 ROLLBACK).
- `apply-fix.sql` — COMMIT 종결자(승인 후 registrar 만 실행 · 여기서 실행 금지).
- `undo.sql` — 신규 8규칙 논리삭제 + 구 R_DEMO_MATSIZ 재활성(대칭 복원).
- 산출 스크립트: `derive_matsiz.py`(유도)·`gen_sql.py`(SQL 생성)·`parse_check.py`(역파싱 자가검사).
