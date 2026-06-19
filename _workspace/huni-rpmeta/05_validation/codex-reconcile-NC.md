# codex Cross-Validation Reconcile — NC ([옵셋] 명함·카드·쿠폰·포토카드)

> 후니 RP-Meta 하네스 Phase 6.5 (rpm-codex-validator). codex 독립 lane ↔ rpm-validator verdict 대조.
> **베이스라인 = `05_validation/mgate-verdict-NC.md`(M1~M6 GO·인쇄방식 #18 부결·distinct 0)** — YOU(reconciler)가 읽되 **codex 프롬프트에 비노출**.
> 독립성 HARD: codex는 증거 + 17축 frame만 받고 우리 GO/NO-GO·"#18 부결"·"인쇄방식=#12" 결론을 **못 본 상태**에서 자체 판정.
> 외부 의견 ≠ 사실 — 합의도 codex 인용은 `unverified`. 라이브 우선·자동 flip 금지.

## codex 가용성 노트
- **AVAILABLE — codex-cli 0.140.0 · gpt-5.5 · read-only · EXIT 0**(36,852 tokens). 레인 정상 작동.
- 호출 폴백 1회: `/tmp` trusted-dir 미인정 → `--skip-git-repo-check` + stdin 파이프로 복구. "codex 미가용·Claude 단독" 폴백 **불필요**(레인 작동).

---

## Reconcile 매트릭스 (codex 독립 판정 ↔ rpm-validator)

| # | 검증 항목 | rpm-validator (베이스라인) | codex 독립 판정 (`unverified`) | 합의/불일치 | 신뢰도·해소 |
|---|---|---|---|:---:|---|
| **R1** | **인쇄방식 #18 distinct 승격/부결** | **부결**(=이미 #12·M3 GO·전용슬롯❌+KB결함❌ 양방향) | **ABSORBED**(부결·승격기준 양방향 불충족·새 축 0) | ✅ **합의** | **고신뢰**. 두 모델이 *같은 양방향 기준*에 독립 도달. codex는 우리 "#18 부결" 라벨 못 본 채 frame의 #12 존재만으로 ABSORBED 도출 = 진짜 교차확인. |
| **R2a** | `offset2023_price` 별도 가격엔진 | #11 가격모델 라우팅 값(M3·M4 N-1 WEAK·바인딩 76행 그릇 흡수) | **#11 가격모델의 값/라우트·새 축 아님** | ✅ **합의** | **고신뢰**. codex가 "별도 엔진=새 축"이라는 가장 강한 distinct 신호를 독립적으로 #11로 분류. |
| **R2b** | 자재×부수 이산 tier | #10 수량 + #5 제약 + #11 가격(N-2 data-gap·M5) | **#10 + #5 + #11 참여·새 축 아님** | ✅ **합의** | **고신뢰**. 3축 분해가 우리 N-2 판정과 정확히 동일. |
| **R2c** | 옵셋 전용 자재풀(RXWMO220) | #1 자재 흡수 + #12/#5 제약 가능(N-3/N-4 GAP=#12) | **#1 자재·#12 또는 #5 제약으로 제약·새 축 아님** | ✅ **합의** | **고신뢰**. |
| **R2d** | `item_gbn`/`price_gbn` 토큰 | #12 인쇄방식 enum 토큰(전용 슬롯 아님·M3) | **#12 인쇄방식/생산레시피 enum·레시피 선택자·새 축 아님** | ✅ **합의** | **고신뢰**. |
| **R3** | 이산 tier = vessel-gap vs data-gap | **data-gap**(그릇 실재: option_items 477·constraints 10·t_dsc_* min/max_qty·formulas 76·M5 search-before-mint 통과) | **data-gap**(그릇 이미 존재·NC 데이터 올바른 cardinality로 적재만 하면 됨) | ✅ **합의** | **고신뢰**. codex가 "vessel 이미 존재"를 독립 단언 = 우리 M5 비준과 일치. |
| **R4** | 날조·오버피팅·비합리 갭 | 날조 0·오버피팅 0·갭 11건 라이브 일치(M1·M4·M6) | **날조 신호 없음·비합리 갭 없음·정상 인쇄도메인 변이** | ✅ **합의** | **고신뢰**. 외부 모델도 건전성 이상 없음 독립 확인. |
| **R5** | #12 복합 recipe 표현력 caution | reverse N-1(가격엔진 선택자)·deepcheck NC-DC-17(variable-data offset)을 metamodel 흡수·표현력 nuance로 라우팅(새 축 아님) | **#12 복합 recipe(base+overprint) 표현력 필요·단 표현력 작업이지 새 축 아님** | ✅ **합의** | **고신뢰**. codex가 우리 deepcheck/reverse가 이미 식별한 동일 nuance를 독립 재도출·동일하게 "새 축 아님" 결론. 자동 채택 아님 — **표현력 nuance는 metamodel-architect 후속 검토 항목으로 carry-forward**(open·게이트 무관). |

**불일치(divergence) = 0건.** 모든 항목 합의.

---

## 종합 판정

- **codex 독립 lane ↔ rpm-validator = 7/7 전건 합의·divergence 0** → NC verdict(M1~M6 GO·인쇄방식 #18 부결·distinct 0)는 **고신뢰 confirm**.
- 핵심: codex가 우리 "#18 부결·인쇄방식=#12" 결론을 **못 본 상태**에서, frame의 #12 존재만 보고 ABSORBED + 4요소 기존축 분류 + data-gap을 *독립* 도출 = 두 모델 동일 evidence·동일 verdict 수렴(echo 아님·진짜 교차확인).
- **라이브 재실측 불요**: 불일치 0이라 조사 트리거 없음. (불일치 시에만 승격기준 ①전용슬롯 OBSERVED+②KB결함 라이브 재측정·codex 단독주장 unverified 가설 처리·라이브 우선)

## carry-forward (open·게이트 무관·Low)
- **#12 복합 recipe 표현력**(R5): codex·reverse N-1·deepcheck NC-DC-17 3소스 합치. 새 축 아님(부결 불변)이나 #12를 단일 토큰으로 평면화하지 말 것 — variable-data offset(base+overprint) 출시 시 metamodel-architect가 #12 recipe 표현력 검토. **owner = rpm-metamodel-architect**(후속·NC 박/형압 NCDFFOI/NCCDFOI 출시 재캡처 시 합류).
- (validator 경미 권고 carry) `_vessel-roadmap.md` "v11.0 NC=신규 0" 행 추가 — owner = rpm-vessel-designer(문서 일관성·게이트 무관).

---

**reconcile 시각**: 2026-06-19 · codex gpt-5.5 read-only EXIT 0 · 베이스라인 mgate-verdict-NC.md(codex 비노출) · 합의 7/7·divergence 0 · 외부 의견 전부 `unverified`(라이브 우선·자동 flip 금지).
