---
name: hcr-gate-validation
description: 후니 제약규칙 하네스의 독립 검증 게이트 방법론(생성≠검증). 설계된 제약규칙·개발자 전달안을 라이브 재실측·JSONLogic 로컬 시뮬레이션으로 독립 재판정하는 CR1~CR7 게이트(필요상황 충실·오차단 0 정합·UI 역파싱 전수·가독성·이관 정합·등록 안전·독립성/전달안 실재). 단일 FAIL=NO-GO·생성자 주장 비신뢰. '제약 게이트', 'CR1 CR7', '오차단 검증', '역파싱 검증', '제약규칙 검증', '게이트 다시' 작업 시 반드시 사용.
---

# CR1~CR7 게이트 방법론

## 판정 철학
제약은 손님 선택을 막는 장치다. **정당한 조합 오차단(false-positive)은 매출 차단**이므로 누락보다 나쁘게 취급한다. 모든 판정은 designer 산출 재인용이 아니라 직접 재실측으로.

## 게이트
| 게이트 | 검사 | 방법 | FAIL 기준 |
|--------|------|------|-----------|
| CR1 필요상황 충실 | 규칙→CN 귀속·근거 실재 | 근거 쿼리/시트 재실행 | 규정 밖 규칙·근거 부재 1건 |
| CR2 정합·오차단 0 [HARD] | 차단 조합=실제 부재 조합 | 단가행/권위 전수 대조: 규칙이 막는 집합 vs component_prices 실존 집합 | 실존(판매가능) 조합 차단 1건, 엇갈림 누락 1건 |
| CR3 UI 역파싱 전수 | logic 정형 shape | views.py 역파싱 로직 기준 구조 검사(스크립트) | raw 폴백 필요 규칙 1건 |
| CR4 가독성 | rule_cd 규약·쉬운 한국어·대안 안내 | 전수 리뷰 | 기술용어 노출·대안 없는 err_msg |
| CR5 이관 정합 | 옵션그룹 이관 전후 | 선택 가능 조합 집합 비교(이관 전 CPQ vs 이관 후 그룹+제약) | 손실·과차단 1조합 |
| CR6 등록 안전 | SQL·undo·validate 케이스 | 멱등 구조 검사·undo 대칭·JSONLogic 로컬 시뮬레이션(막힘/통과 재현)·깨진 var/타입 검출(500 예방) | 비멱등·undo 비대칭·케이스 불일치 |
| CR7 독립성·전달안 실재 | 판정 증거 출처 + dev-handoff 근거 | 파일:라인 실재 확인 | 생성물 재인용 판정·근거 허위 |

## 방법 노트
- CR2 집합 대조는 스크립트로(토큰 0 지향): 규칙 logic → 차단 조합 집합 전개 → 단가행 실존 집합과 diff. 유도 스냅샷 이후 단가행 변경분(추가/삭제)도 재확인.
- CR3: 정형 shape 화이트리스트(단일조건/복수v2 구조)를 views.py에서 추출해 JSON 구조 매칭. 의심 건은 실제 빌더 로딩(gstack)으로 확증 가능.
- CR6 시뮬레이션: panzi-json-logic 동형 로컬 평가(파이썬 json-logic 등)로 rule-spec의 validate 케이스 재현.
- codex 독립 2차 필요 시 `hqv-codex-cross-verify/scripts/codex-review.sh` 재사용(codex 주장=가설·미가용 시 "Claude 단독" 명시·pending 금지).

## verdict
GO / CONDITIONAL-GO(경미 결함·사유와 잔여 위험 명시) / NO-GO(규칙 단위 사유+재현 쿼리 → designer 라우팅). UNVERIFIED 게이트가 있으면 GO 금지. GO분만 인간 승인 큐로. `dev-handoff-draft.md`는 근거 검증 통과분으로 `dev-handoff-final.md` 승격.
