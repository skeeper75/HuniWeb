# wave-3 사후검증 (PRD_000047 소량전단지)

> §31 Phase 5 · hcr-ui-registrar · 2026-07-02 · 라이브 재실측(읽기전용 SELECT + validate 1회)

## 1. 라이브 재SELECT (COMMIT 후)

```
prd_cd     | rule_cd                   | rule_typ_cd  | use_yn | del_yn | paper_conds | coat_conds | logic_type
PRD_000047 | R_EXCL_COATING_THIN_PAPER | RULE_TYPE.02 | Y      | N      |     15      |     2      | object
active=1 · total=1
```

- **행 수 일치**: 활성 1건(기대 1) · total 1 · 중복 0.
- **logic 일치**: coating or 절 2조건(유광/무광)·paper or 절 15조건(얇은종이 15종) = rule-spec/derived-rules.json 과 일치.
- **logic_type=object**: JSONB 정상 파싱(캐스팅 오류 0).

## 2. evaluate_constraints / validate 500 무발생

- 실화면 `/validate/` POST 3회(막힘·통과·통과2) 전부 **HTTP 200**(약 130ms·410B) · 응답 정상 렌더.
- console 오류 0 · JSONLogic 평가 예외 0(결측키 조용 통과 = 플랫폼 C-3 이슈, 이 규칙 구조 결함 아님).
- 규칙 병합 평가가 500 없이 도는 것 실화면으로 확인(활성 규칙 1건이므로 병합=단일 규칙 평가).

## 3. 잔여 위험(GO 유지 · gate-report W0 계승)
- `evaluate_price`/`simulate` 는 제약 미참조 → 이 규칙은 **위젯/주문이 `/validate/` 호출 시에만 실효**.
  강제 계층 신설은 dev-handoff C-1·C-2·R-1~R-3 개발 항목(본 wave 범위 밖). 규칙 자체 정확성·안전성은 GO.

## 4. 판정
- **사후검증 PASS.** COMMIT 결과·UI 4항·validate 3케이스 전부 부합. wave-3 완료.
- undo 경로: `03_rules/wave3-dgp/undo.sql` · 백업: `04_register/wave3/backup-20260702-172125.sql`.
