# vessel-print-method-recipe (V-2, #12 인쇄방식 레시피) — GAP ❌ (조건부) → 그릇 설계 + open decision

> rpm-vessel-designer. RP `PrintMethod`(레시피·allowed_processes·file_formats·team 게이팅)을 후니가 표현할 그릇.
> [HARD] 인쇄방식 절대축 아님(`dbmap-print-method-not-absolute-axis`) — 강제 1급화 금지. 조건부 판정 선행.
> 권위 = 라이브 read-only 실측(2026-06-17). design ≠ apply.

## 0. 한 줄 평결
**조건부 GAP — 1급 PrintMethod 테이블 신설은 보류(over-modeling 위험), 게이팅은 기존 제약 축(V-4 RULE_TYPE.02 금지)으로 흡수 가능.** 단 도메인 결정(후니가 인쇄방식을 1급 게이팅 축으로 운영할지)이 미정이므로 **open decision**으로 두 경로를 제시. 자율 1급화 금지.

## 1. search-before-mint (라이브 실측)
RP가 요구하는 것: 인쇄방식 선택 → (a) 가능 공정 부분집합 결정 (b) 파일포맷 결정 (c) 생산팀 라우팅.

| 요구 facet | 후니 기존 그릇으로 표현 가능? | 라이브 근거 |
|---|---|---|
| 인쇄방식 *존재* | ✅ `t_proc_processes` 공정 행(디지털/UV 등 PROC_000002~6) | live `t_proc_processes` |
| 방식→가능공정 *게이팅* | △ **제약 축으로 흡수 가능** — 방식 선택 시 비호환 공정 disable = `RULE_TYPE.02 금지` + `logic jsonb` JSONLogic | live `t_prd_product_constraints.logic jsonb`(실재)·option_groups `sel_typ_cd`(택1) |
| 파일포맷 | ❌ 전용 슬롯 없음 — 단 후니 도메인=디지털+굿즈 중심, 방식별 파일포맷 다양성 RP보다 낮음(샘플 부족) | 미관측 |
| 생산팀 라우팅 | ❌ 전용 슬롯 없음 — MES 축(MES_ITEM_CD 전량 NULL, `dbmap-goal-ui-quote-mes`)에 귀속될 사안 | MES 미완 |

**핵심:** 게이팅(가장 leverage 높은 facet)은 **기존 제약 그릇으로 무손실 흡수 가능**. 파일포맷/팀은 (1) 후니 도메인에서 RP만큼 분기 다양성이 입증되지 않았고 (2) MES 미완 상태라 1급 그릇 신설은 시기상조. → **1급 PrintMethod 테이블 mint = 현 시점 과설계.**

## 2. 그릇 설계 — 두 경로 (designer 권고: 경로 A 우선)

### 경로 A (권장) — 제약 축 흡수 (코드행 0 + 데이터, 신규 그릇 0)
- 인쇄방식 = 공정 행(기존). 방식↔공정 게이팅 = `t_prd_product_constraints`(rule_typ_cd=RULE_TYPE.02 금지) + `logic jsonb` JSONLogic.
  예: `{"if":[{"==":[{"var":"인쇄방식"},"디지털"]}, {"disable":["공정:옵셋전용후가공"]}]}` (logic shape는 앱 컴파일러 권위).
- 방식 선택지 = option_group(sel_typ_cd=택1) + option_items(ref_dim_cd=OPT_REF_DIM.04 공정).
- **신규 그릇 0** — 전부 라이브 실재 구조 재사용. 사다리 최저단(데이터/코드행).
- 파일포맷·팀은 미보류(MES 트랙에서 별도). 

### 경로 B (조건부·후니가 1급화 결정 시만) — `t_proc_processes.prcs_dtl_opt`에 method 메타 인라인 또는 신규 코드그룹
- 방식별 메타(파일포맷 enum·팀)를 `t_cod_base_codes` 신규 그룹 `PRINT_METHOD` 코드행 + 방식 코드의 `note`/별 메타 jsonb로 인라인.
  사다리: 코드행(PRINT_METHOD.01 디지털…) < (필요 시) jsonb 메타.
- **신규 테이블은 그래도 보류** — 방식 0~5종·상품당 1방식이라 독립 lifecycle 테이블 정당성 약함. 1급 테이블은 방식별 파일포맷/팀 분기가 실데이터로 입증될 때 재평가.

## 3. 정규화 / 영향 (경로 A 기준)
- **무손실:** 게이팅은 JSONLogic이 임의 조건 표현(이미 V-4 logic 그릇). 방식 존재=공정 행.
- **무중복:** 방식을 공정 행으로 두되 게이팅을 제약으로 — 방식 정의(공정)와 게이팅 규칙(제약) 분리, 이중저장 없음.
- **영향:** 신규 컬럼/테이블/FK 0. 기존 행 무영향. RULE_TYPE.02(금지) 이미 라이브 실재 → 코드행도 0. 데이터(constraints 룰) 적재만 = dbmap round-6 트랙.
- **롤백:** 데이터(constraints 행) 삭제만. DDL 0.

## 4. WEAK/GAP → 판정
- #12 GAP(조건부) → **경로 A 채택 시 PASS**(게이팅 표현력 확보, 신규 그릇 0). 파일포맷/팀 facet은 **DEFER**(MES 트랙·샘플 확대 후 재평가).

## 5. DDL 참조
- 경로 A: **DDL 불요**(데이터·기존 제약 그릇). 경로 B 1급화 결정 시 → `dbm-ddl-proposer`에 PRINT_METHOD 코드그룹 + (필요 시) 메타 슬롯 위임.

## 6. open decision (★ 자율 진행 금지 — 도메인 결정 필요)
1. **후니가 인쇄방식을 1급 게이팅 축으로 운영할 것인가?** (경로 A 제약흡수 vs 경로 B 코드/메타). 메모리 `dbmap-print-method-not-absolute-axis`는 강제 1급화 금지를 명시 → 기본값 **경로 A**.
2. **파일포맷·생산팀 facet 필요성:** RP는 1급, 후니는 미관측. MES(MES_ITEM_CD 전량 NULL) 완성 시점에 재평가. 현 시점 그릇 mint 보류.
3. 어느 경로든 실 적용 = 후니 인간 승인.
