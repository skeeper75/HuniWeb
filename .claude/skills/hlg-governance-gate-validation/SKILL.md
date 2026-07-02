---
name: hlg-governance-gate-validation
description: 후니 적재 거버넌스 하네스의 독립 검증 게이트 방법론(생성≠검증). 규범·옵션 처분·개발자 문서·codex reconcile를 생성자 주장 비신뢰로 직접 재실측해 LG1~LG7(규범 충실·근거 실재·오차단 0·가격 무손상 evaluate_price 골든·셋트 정합·문서 재현성·독립성/수렴)로 GO/NO-GO. 단일 FAIL=NO-GO·라우팅. 트리거 — '거버넌스 게이트', 'LG1 LG7', '처분 검증', '가격 무손상 검증', '게이트 다시'. 판정 생성은 hlg-option-usage-audit, 규범은 hlg-vessel-norm-authoring 담당.
---

# hlg-governance-gate-validation — LG1~LG7 게이트 방법론

## 판정 원칙
생성측 보드의 "확인됨"은 증거가 아니다. 게이트는 근거 쿼리를 직접 재실행하고, 가격을 직접 재계산한다. 확인 불가는 UNVERIFIED(PASS 위장 금지)·전체 CONDITIONAL.

## 게이트별 재실측 절차
- **LG1 규범 충실성** — vessel-norm 각 항목을 SOT 원문·권위 260702와 대조. relitigate 금지 항목(상품유형 분류·도메인 12규칙) 위반 grep.
- **LG2 근거 실재** — 처분 대상(RETIRE/MOVE/EXTEND) 전건의 근거 쿼리 재실행 → 보드 값과 일치 확인. 표본 아님, 전건.
- **LG3 오차단 0 [최우선]** — 처분 전건: "정리 후 손님이 같은 선택을 하는 경로"를 라이브에서 재실측(기준정보 바인딩·다른 옵션·제약). 경로 부재 1건이라도 있으면 그 항목 NO-GO.
- **LG4 가격 무손상** — 롤백 전용 트랜잭션으로 처분을 가정 적용 → 파일럿 상품 evaluate_price 재계산: PRICE≠0·권위 골든 오차 0·이중합산 0 → ROLLBACK. 가격종속인데 BLOCKED 미분리 건 적발. ★골든/발현 판정은 sim_meta 뷰어재현 simulate 방식만 신뢰(정적 스캔 과적발 선례 — [[silent-zero-final-simscan-260701]]).
- **LG5 셋트 정합** — 셋트 파일럿의 완제품/반제품 그릇 배치를 규범·권위 시트와 대조 + evaluate_set_price 골든 재현(구성원 합산+셋트 공식·이중합산 0).
- **LG6 문서 재현성** — DEV-REQUEST 재현 절차를 게이트가 직접 수행 → 같은 현상 확인. 실패 시 문서 반송.
- **LG7 독립성·수렴** — 생성 산출을 게이트가 만들지 않았는가·codex reconcile 불일치 전건 조사 종결됐는가.

## 산출
- `gate-report.md` — 게이트별 PASS/FAIL/UNVERIFIED·증거·NO-GO 라우팅(어느 에이전트로).
- `handoff-spec.md` — GO분 인계서: 처분 SQL 방향·대상 트랙(§7/§31/§17)·인간 승인 필요 항목·undo 방향·★위임 트랙의 COMMIT 전 webadmin 실화면 확인 의무(제외 0·PRICE≠0) 명기.
