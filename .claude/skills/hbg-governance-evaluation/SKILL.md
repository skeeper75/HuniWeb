---
name: hbg-governance-evaluation
description: >
  후니프린팅 기초코드 거버넌스 하네스의 검증 게이트 방법론 스킬 — B1~B6 게이트(권위 충실성·진단 정확성·라우팅 타당성·
  search-before-mint 준수·등록 명세 실행가능성·생성-검증 독립성)·라이브 재실측·verdict 포맷. 생성자 비신뢰·라이브 직접 재실측·
  dodge-hunt·단일 결함 FAIL·검증 전용. 트리거: 기초코드 검증, 거버넌스 게이트, B1 B6, 등록명세 검증, 권위 충실성,
  search-before-mint 검증, 교차검증. 생성(큐레이션/진단/명세)은 각 생성 스킬이 담당.
---

# 기초코드 거버넌스 검증 게이트 방법론

## 원칙 — 생성자 비신뢰·라이브 직접 재실측

생성자(큐레이터·진단가·설계가) 산출을 **그대로 신뢰하지 않는다**. 인용된 행수·코드값·존재를 라이브 `psql`
읽기전용으로 다시 측정해 대조한다(2-pass). 단일 결함이면 해당 단계 FAIL → 재산출.

## B1~B6 게이트 [HARD]

| 게이트 | 검증 내용 |
|---|---|
| **B1 권위 충실성** | 정답 사전 각 값 ↔ 상품마스터(260610)/가격표(260527) 명시값 셀 대조. 역공학/경쟁사가 권위 침묵 아닌데 정답 단정(덮어쓰기) 적발. 날조(없는 권위 인용) 적발. |
| **B2 진단 정확성** | 4-way 결함을 라이브 `information_schema`·실데이터 재실측 일치 확인. dbmap 기진단 중복/이미 COMMIT된 결함 미교정 오판(stale) 적발. |
| **B3 라우팅 타당성** | 원인유형(ⓐ/ⓑ/ⓒ/ⓓ)·라우팅(신규/교정/축이동)이 결함과 논리 정합. 자재 색 2~3종 자재유지/4종+ CPQ 경계 준수. |
| **B4 search-before-mint 준수** | 신규 등록이 코드행/컬럼/JSONB/junction 표현 불가 입증했는지. 신규 그릇이 vessel-gap 3건(V-10/11/12) 외 남발 0. |
| **B5 등록 명세 실행가능성** | FK 위상 무모순(목적지 선행)·webadmin 적재경로 실재(admin 화면 확인)·채번 정합(MAX+1·`_`·멱등)·영향분석 완비(가격사슬·롤백). dry walk-through: 명세만으로 운영자 등록 가능한가. |
| **B6 생성-검증 독립성** | 생성자 산출 베끼지 않고 라이브 직접 재실측. self-approve·dodge(어려운 항목 회피) 적발. |

## 라이브 재실측 패턴 (읽기전용)

```bash
psql "$RAILWAY_DB_URL" -c "SELECT count(*) FROM t_mat_materials WHERE mat_typ_cd IN ('08','09','10');"
psql "$RAILWAY_DB_URL" -c "SELECT count(*) FROM t_cat_categories WHERE use_yn='N';"
```

[HARD] SELECT만. 쓰기 절대 금지.

## verdict 포맷

```
## B{N} {게이트명} — GO / NO-GO / CONDITIONAL
- 검증: {무엇을 어떻게 재실측}
- 증거: {라이브 수치·셀 대조 결과}
- 판정: {GO 근거 / FAIL 항목 + 재산출 지시 대상 에이전트}
```

## 정직 규율 [HARD]

- 일부만 검증 가능 → **CONDITIONAL-GO + 미검증 항목 명시**. 전건 GO 남발 금지(날조 유혹).
- dodge-hunt — 진단가/설계가가 어려운 자재 오염·카테고리 고아를 건너뛴 곳 능동 탐색.
- FAIL은 해당 생성자에 되돌림(SendMessage)·리더 종합 보고.

## 산출

`_workspace/huni-basecode/04_gate/gate-verdict.md` — B1~B6 판정 + 증거 + GO/NO-GO + 재산출 지시.

## 금지

- 전건 GO 자동 비준.
- 생성자 주장 그대로 인용(라이브 재실측 필수).
- DB 쓰기.
