---
name: hcr-rule-authoring
description: 후니 제약규칙 하네스의 규칙 작성 규약. t_prd_product_constraints(JSONLogic)용 규칙을 ★폼빌더 역파싱 가능한 정형 shape로만 작성(raw escape hatch 금지 — UI에서 확인·조정 가능해야 함), var 계약(VAR_KEY_MAP) 준수, CN-2는 단가행 자동 유도, rule_cd/err_msg 쉬운 한국어 명명, 멱등 SQL(dryrun/fix/undo)+validate 케이스 동봉 절차를 정의한다. '제약규칙 설계', '제약규칙 작성', 'JSONLogic 제약', '단가행 유도 규칙', '제약 적재본', '포맥스 제약 수정', '규칙 작성 다시' 작업 시 반드시 사용.
---

# 제약규칙 작성 규약

## 대상 그릇 (실측 계약 — [[constraint-builder-contract-demo-260702]])
`t_prd_product_constraints`: 복합PK(prd_cd, rule_cd) · rule_typ_cd=RULE_TYPE.01(호환)/.02(금지)/.03(필수동반) · rule_nm · logic(JSONB·JSONLogic) · err_msg · use_yn/del_yn. 평가=활성규칙 `{"and":[...]}` 즉석 병합(panzi-json-logic). 저장 시 캐시 폐기.

## var 계약 [HARD]
사용 가능 키(VAR_KEY_MAP): `siz_cd`·`plt_siz_cd`·`mat_cd__usage_cd`(결합키 — mat_cd 단독 금지)·`proc_cd`·`bdl_qty`(int)·`opt_id`(int)·`sub_prd_cd` + 배열 `sel_opt_grps`/`sel_opts`(in 비교). 계약 밖 키는 위젯이 data에 싣지 않으므로 평가되지 않는 죽은 규칙이 된다.

## 정형 shape [HARD] — UI 역파싱 가능성이 완료 조건
폼빌더 2경로가 역파싱하는 구조만 쓴다(raw escape hatch 금지):
- **단일조건**: `{"<op>": [{"var":"<key>"}, <value>]}` (op: ==, !=, in 등 빌더 지원 연산자)
- **복수조건(v2·implication)**: `{"or": [{"!" : <조건A>}, <조건B>]}` 또는 빌더가 생성하는 if/and 조합 — 반드시 빌더로 한 번 만들어 본 구조를 그대로 따른다(views.py 역파싱 로직이 정본).
- 한 규칙에 못 담기면 규칙을 **분할**한다(자재별 1규칙 등). 복잡한 단일 규칙보다 단순한 규칙 여러 개가 UI에서 읽힌다.
- 설계 후 자가검사: 이 logic을 빌더가 다시 열 수 있는가? 못 열면 반려.

## CN-2 단가행 자동 유도
```sql
-- 유도 원천: 해당 상품 공식의 component_prices 실존 (mat, siz) 조합
SELECT DISTINCT <판정축1>, <판정축2> FROM t_prc_component_prices ... WHERE del_yn='N';
```
유도 결과 → 축1 값별 "필수동반: 축2 IN (허용값들)" 규칙(RULE_TYPE.03 implication). 유도 스크립트·실행 시점·스냅샷을 산출물에 남긴다(신규 자재/사이즈 추가 시 재생성으로 drift 제거 — 수동 나열 금지).

## 명명·메시지 규약
- rule_cd: `R_MATSIZ_*`(자재↔사이즈)·`R_REQ_*`(필수동반)·`R_EXCL_*`(금지)·`R_RANGE_*`(범위). 데모 표기는 규칙명에("제약조건데모" 등), rule_cd 재사용은 search-before-mint.
- rule_nm·err_msg: 쉬운 한국어([[user-nonexpert-plain-language]]). err_msg="왜 안 되는지 + 무엇을 고르면 되는지" (예: "이 재질은 A3 크기 전용입니다. 크기를 A3로 선택해 주세요.").

## 적재본 규약
- `apply-dryrun.sql` — BEGIN…ROLLBACK 전용(검증은 이것만 실행). `apply-fix.sql` — COMMIT 종결자(인간 승인 후 registrar만 실행, [[dryrun-vs-fix-script-commit-lesson]]). `undo.sql` — 대칭 복원.
- 멱등: `INSERT … ON CONFLICT (prd_cd, rule_cd) DO UPDATE`. 기존 규칙 폐기는 del_yn='Y' 논리삭제만.
- 규칙마다 validate 케이스 최소 2개(막힘 1·통과 1)를 rule-spec.md에 동봉 — registrar가 실화면 재현, gate가 로컬 시뮬레이션.

## 함정
- evaluate_price/simulate는 제약을 안 본다 — 규칙을 넣어도 견적 0원은 그대로다. 가격 결함은 가격 트랙(§26/§27)으로, 제약은 선택 차단용임을 spec에 명시.
- evaluate_constraints는 try 없음 — 깨진 var·타입 불일치 logic은 500을 유발한다. 저장 전 validate 미리보기 통과 필수.
- 정당한 조합 오차단이 최악(매출 차단). 유도 스냅샷 이후 단가행이 추가된 조합이 없는지 gate에서 재확인.
