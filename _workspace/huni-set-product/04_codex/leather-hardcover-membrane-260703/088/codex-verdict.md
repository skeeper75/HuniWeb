# codex 독립 판정 — 088 레더 링바인더 "면지 통합" 재설계

- 작성 2026-07-03 · hsp-codex-verifier · §23 Phase 3(088 면지 통합)
- codex 가용: **YES**(gpt-5.5 · effort high · read-only · rc=0) → Claude 단독 폴백 불요.
- 방법: Claude 판정 비노출(독립성). 설계 spec + apply/undo SQL + 라이브 사실(데이터로만) + 적대적 6질문 제공.
  codex가 저장소를 자체 탐색(pricing.py:402/470/854·apply-088.sql·088-redesign apply.sql 정독)해 독립 판정.
- codex 샌드박스 제약: 라이브 DB DNS 접근 불가(`zephyr.proxy.rlwy.net` 미해석) → 골든 재실행은 못 하고
  제공 사실 + 코드/SQL 정독 기준으로 판정(예상된 read-only 제약). 라이브 실증은 게이트/verifier 몫.
- 프롬프트/원문: `_codex-prompt-088.md` · 원문 raw = scratchpad `codex-088-verdict-raw.txt`(세션 산출) / 세션 로그.

---

## 전체 판정: **CONDITIONAL GO**

> "데이터/SQL 설계는 대체로 GO지만, 실 COMMIT 게이트에서 **직접단가 0건**과 088 실제 UI 발현을 반드시 닫아야 한다."

## 질문별 codex 독립 판정

| # | 질문 | codex 판정 | 핵심 근거 |
|---|---|---|---|
| 1 | 골든 무손상(34,100/159,100/796,900 불변) | **AGREE, 단 조건** | 부모 COVERBIND use_dims=["min_qty"]·할인 0 → 논리 맞음. ★단 evaluate_price는 구성원을 무조건 진입시켜 **직접단가를 먼저** 봄(pricing.py:470) → "공식 0건"만이 아니라 **089~093 직접단가 0건**도 게이트 실측해야 완전 |
| 2 | USAGE.07 D링(247/248/249) 보존 | **AGREE** | apply-088.sql:84 은퇴가 `mat_cd IN(382~385)+usage_cd='USAGE.03'`로 제한 → D링 범위 밖. 현행 COVERBIND는 min_qty만 사용 → D링은 가격축 아님(단 생산 BOM 축 보존 필수) |
| 3 | 088-redesign 직교성·순서 무관 | **AGREE, 골든 문구 구분** | 행 범위 직교(면지 통합=090~093·088 면지옵션/USAGE.03 / 재설계=089·COVER comp·부모배선·PROC_000098). ★단 재설계 COMMIT되면 전체 골든은 재설계 골든(39,000…)으로 바뀌는 게 정상. "면지 통합이 각 모델 골든을 오염 안 함"이면 AGREE·"재설계 후에도 현행 COVERBIND 골든 유지"면 DISAGREE |
| 4 | 인쇄면지·역참조·트리거 | **AGREE** | OPV_447→MAT_385 이관(apply:61). 090 무공식/무직접단가면 "인쇄" 인쇄비 기여 0 = **선존 결함 D-3**(본 apply 파손 아님). 트리거 순서(자재 INSERT→옵션아이템) 무결. 091~093 역참조 0 전제 맞으면 은퇴 안전 |
| 5 | 색 택1 발현·선택지 손실 | **AGREE(data)·UNCERTAIN(UI)** | 데이터 선택지 손실 0(MAT_382~385+OPV_444~447 전부 090 이관·apply:29). UI 발현(구성원 자재 드롭다운 렌더)은 088 post-apply 화면 확인 조건. 구성원 옵션그룹 렌더=별도 D-1 휴면 |
| 6 | 오구성·false-positive | **AGREE with caveats** | 089~093 반제품·완제품 혼입 0. ★FP 오판 주의점="표지 089 공식 0건"을 즉시 결함으로 보는 것(현행 COVERBIND는 부모가 표지+제본 통합가 → 089 무공식은 임시모델상 정상). ★놓칠 진짜 결함=MAT_385 인쇄 가격 0·구성원 옵션 UI 휴면·"공식 0건=기여 0" 주장에 직접단가 0건 실측 누락 |

## codex 지정 "실 COMMIT 전 게이트 필수 실증"
1. 089~093 **직접단가 0건**
2. 090 자재/옵션 INSERT 후 `fn_chk_opt_item_ref` 통과
3. USAGE.07 D링 3종 활성 잔존
4. evaluate_set_price 1/10/100부 골든 전후 동일
5. 091~093 전역 역참조 0
6. 088 실제 화면 면지 4택1 발현 및 PRICE≠0
