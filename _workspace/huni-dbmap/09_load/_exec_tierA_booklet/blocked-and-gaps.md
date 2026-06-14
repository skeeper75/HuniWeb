# BLOCKED + GAP — 책자 Tier A 4상품 (→ dbm-ddl-proposer · dbm-validator)

> 빌드 2026-06-14. **BLOCKED 0건** (전 차원행 라이브 실재 → 옵션 레이어 전건 INSERTABLE).

## 1. BLOCKED (차원행 부재 — L1 선적재 필요)

| 항목 | 상품 | 사유 | 상태 |
|------|------|------|------|
| — | — | 없음. 4상품 사이즈/자재/공정/도수/셋트 차원행 전부 라이브 실재(트리거 EXISTS 통과 DRY-RUN 실증) | **BLOCKED 0** |

## 2. GAP (라이브 컬럼 부재 — ddl-proposer, 발명 금지·플래그만)

| GAP | 내용 | 영향 상품 | 라이브 권위 | 처리 방향 |
|-----|------|----------|------------|----------|
| **GAP-DOSU-USAGE** | `t_prd_product_print_options`에 usage(내지/표지) 식별자 부재 → 상품당 단/양면 2행만, 내지인쇄·표지인쇄 option_group이 동일 opt_id 1·2 **공유 참조** | 068·069·071·094 (표지인쇄 전건) | `\d t_prd_product_print_options` 실측(usage 컬럼 없음·ux 자연키=prd+side+front+back) | print_options에 usage_cd 추가 vs 내지/표지 별 행 분리 — ddl-proposer. 본 빌드=공유 참조(정직 절충, 발명 아님) |
| **GAP-PARAM** | 공정 파라미터 보존 컬럼(`ref_param_json`) 미구현 → 박/형압 크기(30x30~170x170)·제본방향(좌철/상철) 보존 불가 | 069 박/형압·071 제본방향 | cpq-schema §4 🔴8 | ref_param_json 컬럼 추가 vs qty 재사용 금지 — 본 빌드 미반영(qty=1 고정) |
| **GAP-HIDDEN** | hidden-essential(auto-apply 미표시) 플래그 부재 → 094 셋트구성 BOM을 미노출 필수로 표현 불가 | 094 셋트구성 | cascade-rules §5·cpq-schema §4 | option_groups에 hidden 플래그 추가 — 본 빌드=mand_yn=N 적재(미노출 플래그 없음) |

## 3. 설계 결정 [CONFIRM] (→ 리드·사용자)

| # | 결정 | 후보 | 본 빌드 채택 |
|---|------|------|------------|
| C1 | **094 셋트구성 = BOM vs 사용자옵션** | A 셋트 option_group 1개+`.07` 2 item(mand_yn=N·hidden 후보) / B option 미생성(t_prd_product_sets로 충분) | **A** (셋트구성 1그룹·2아이템 적재) — UI 미노출 여부는 GAP-HIDDEN |
| C2 | **내지/표지 인쇄 도수 분리 방식** | A 공유 opt_id 참조(현행) / B print_options usage 분리 후 별 행 | **A** (GAP-DOSU-USAGE로 분리는 ddl-proposer 결정 종속) |
| C3 | **제본 택일그룹 신규생성 정당성** | cpq-schema §1.5는 GRP-BOOK(PRD_000068~100) 적재 기술하나 **라이브 4상품 제본 option_group 0행**(stale) → 신규생성 | **신규** (라이브 0행 확인·중복 아님) |

> [HARD] 침묵 선택 금지 — C1~C3 리드 통해 사용자 확정. C3는 라이브 실측이 cpq-schema 기술을 정정(stale).
