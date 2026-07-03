# 디지털인쇄 옵션 판정 — 독립 검증 게이트 LG1~LG7 (gate-report)

> §34 Huni-Load-Governance · Phase 5 · hlg-governance-gate · 2026-07-03
> 대상: 디지털인쇄 시트 32상품(PRD_000016~051, 전부 .01 일반 완제품) · board 325행 · EXTEND 90행/21그룹
> 방법[HARD]: 생성측 board/spec/reconcile "확인됨" 비신뢰 → 라이브 읽기전용 SELECT 직접 재실행·직접 재집계.
> 판정 기준 상태: **reconcile 정정 반영본**(042 KEEP→EXTEND·047 근거확장·037 EXTEND-BLOCKED)을 유효 처분으로 채택.
> 자격증명: `.env.local RAILWAY_DB_*`(읽기전용). 실 COMMIT/시뮬 적용 없음.

---

## 0. 최종 판정 요약

| 게이트 | 판정 | 핵심 근거(재실측) |
|--------|------|-------------------|
| LG1 규범 충실성 | **GO** | vessel-norm §1 상품유형 = product-type-SOT 정합·권위 260702 선언·relitigate 위반 0 |
| LG2 판정 근거 실재 | **GO** | 처분대상(EXTEND) 전건 라이브 재실행 일치. RETIRE/MOVE 0 |
| LG3 ★오차단 0 | **GO** | RETIRE/MOVE 0 → 선택지 제거 0. EXTEND=보강/재배선(라벨 불변)·AMBIG=보류 |
| LG4 가격 무손상 | **GO(조건부)** | 처분 미적용(명세까지)·BLOCKED 분리 누락 0(037). 042/047 재배선 PRICE≠0=§7 위임(gate에서 evaluate_price 실행 불가=UNVERIFIED) |
| LG5 셋트 정합 | **GO** | 32상품 전부 `t_prd_product_sets` 부모 0건(라이브 실측)=일반 완제품 |
| LG6 문서 재현성 | **N/A** | 03_devdoc/ 비어있음 = Phase 4 NO-OP(코드결함 dev-doc 없음) |
| LG7 독립성·수렴 | **GO(주의 1)** | 게이트 독립 재실측·codex 정정 2건 라이브 확증. divergence 1=위임큐 종결. ★Phase2 board 미동기화 주의 |

**전체 판정: GO (CONDITIONAL)** — 명세(처분 방향)는 GO. 조건 = 042/047/037 재배선 실행 시 §7 위임 트랙에서 evaluate_price PRICE≠0·이중합산 0을 webadmin 실화면[HARD]으로 입증 후 COMMIT. 게이트 단계에서 실 파손 없음(미적용).

---

## LG1 — 규범 충실성 : GO

| 항목 | 재실측 | 결과 |
|------|--------|------|
| 상품유형 3종(vessel-norm §1) | product-type-classification-sot.md 대조 | 완.01/셋트.01(부모등록)/반.02 일치. 디지털=일반 완제품 .01 |
| 셋트 아님 판정 | 라이브 `t_prd_product_sets` 32상품 부모 조회 | **0건** → 셋트 부모 미등록=일반 완제품 정합(LG5와 동일 증거) |
| 도메인 12규칙 정합(§3 규범표) | 판형=종이류만·base proc(PROC_000004)·도수=print_opt_cd·이중합산 가드 | HARNESS-DOMAIN-RULES-260701 정합·모순 0 |
| 권위 260702 | vessel-norm §6 SOT 충돌 보드 | 하드 충돌 0·260702 우선 확정·재적재 후속 High큐(별도) |
| relitigate 금지 위반 | 상품유형·도메인규칙 재논의 grep | 위반 0(규범이 SOT 확정분을 승계만) |

→ 규범이 SOT·권위 260702와 모순 0, 판정의 유일 기준으로 유효. **GO**.

## LG2 — 판정 근거 실재 (처분 전건 직접 재실행) : GO

RETIRE/MOVE = 0(board CSV 9번째 열 집계: KEEP 223·EXTEND 90·AMBIG 12·RETIRE 0·MOVE 0). 처분대상=EXTEND 전건 라이브 재실측:

| 판정 대상 | board 주장 | 라이브 재실측(SELECT) | 일치 |
|-----------|-----------|----------------------|------|
| 무옵션 9상품(034/035/036/039/043/044/045/048/049) | use=Y·옵션그룹 0 | 전 9건 use_yn=Y, opt_grp 0 | ✓ |
| 미출시 5상품(022/023/028/038/051) | use=N·옵션 부재 유보 | 전 5건 use_yn=N, opt_grp 0 | ✓ |
| PRD_019 소재 / 020 종이 / 021 인쇄 / 025 화이트별색 / 040 클리어 | items 0(미배선) | 각 그룹 item_cnt=0 | ✓ |
| PRD_025 종이 / 030 종이 | 0/1(단일 ref 미실재) | 각 total 1·NOT_IN_PM 1 | ✓ |
| PRD_031 종이 | 6/14(8 미실재) | total 14·NOT_IN_PM 8 | ✓ |
| PRD_047 종이 | 46/47(codex: 미실재1+오매핑3) | total 47·NOT_IN_PM 1·굿즈오매핑 3(128면끈/129아크릴키링고리/130네오디움자석) | ✓ |
| ★PRD_042 종이(codex 정정) | KEEP→EXTEND(스타드림 4항목 굿즈오매핑) | ref_dim OPT_REF_DIM.03: MAT_128(면끈)/129(아크릴키링고리)/240(보드스탠딩)/241(핀버튼) = 굿즈 4건 | ✓ 확증 |
| PRD_037 박종류 | opt_cd 판별·ref 무 | group OPT_000080·options 2(일반박/홀로)·option_items 0 | ✓ |

전 처분대상 근거가 라이브에서 그대로 재현. **GO**.

## LG3 — 오차단 0 [최우선] : GO

- RETIRE/MOVE 처분 = **0건**(board 전수 집계 확증) → 손님 선택지를 없애는 처분이 원천적으로 없음.
- **MOVE-기준정보=0 적대 재검**: 옵션 ref가 기준정보 같은 값을 가리켜도(예 016 종이 21/21), 옵션이 곧 **유일 손님 선택 UI 기제**(기준정보 바인딩은 후보풀)이고 `fn_chk_opt_item_ref` 트리거가 공존을 강제. 옵션 제거 시 손님이 자재/도수/공정을 **못 고름 = 선택지 손실**. 따라서 KEEP-대신-MOVE로 오판해 선택지를 없앨 위험 항목 = 0. 잉여중복 조작 없음.
- EXTEND 90행: 전부 재배선(ref 목적지 교정)·보강·레이어 신설 = **선택지 추가/유지**. 042/047 재배선도 "스타드림 실버" 라벨은 그대로, ref만 면끈→스타드림으로 교정 → 손님 선택 불변.
- AMBIG 12행: 확정 보류(선택지 유지).

→ 오차단 위험 항목 0. 최우선 가드 충족. **GO**.

## LG4 — 가격 무손상 : GO (조건부)

- **처분 미적용**: 본 하네스는 명세까지(DB 미적재) → 게이트 단계에서 evaluate_price를 파손시키는 실 변경 없음. 롤백 시뮬레이션 대상(적용) 자체가 없음.
- **BLOCKED 분리 누락 0**: 가격종속 처분(RETIRE/MOVE) 0 → un-blocked 가격파손 위험 0. opt_cd 가격모델 재배선인 **PRD_037 박종류만이 가격사슬 접촉** → reconcile R-5가 **EXTEND-BLOCKED**로 정식 분리(criteria §4 정합). 게이트 확인: 037 items 0·opt_cd 판별 라이브 확증 → BLOCKED 분리 타당.
- **042/047 재배선 = 가격종속(재실측)**: 굿즈 오매핑 자재(128/129/130/240/241)는 `t_prc_component_prices`에 단가행 **실재** → 현재 "스타드림" 선택 시 굿즈 연당가로 **잘못된 가격 발현**(견적0 아닌 오금액=실질 돈결함). 정상 스타드림(352/358/359/360)은 PRD_042/047 `product_materials`에 **부재** → ref만 교정하면 트리거 위반+NO_MATCH 견적0. 따라서 재배선 무손상 조건 = **§7이 정상 스타드림 자재+연당가를 선등록한 뒤 ref 교정**(순서 의무).
- **UNVERIFIED(정직)**: evaluate_price는 Python 엔진(pricing.py)이라 psql 게이트에서 재계산 불가 → 재배선 후 PRICE≠0·이중합산 0의 실증은 §7 위임 트랙의 webadmin 가격시뮬레이터 실화면(제외0·PRICE≠0)[HARD]으로 이관.

→ 게이트 단계 파손 0·BLOCKED 분리 정확. 실행시 PRICE≠0 입증은 위임(조건). **GO(조건부)**.

## LG5 — 셋트 정합 : GO

- 디지털 32상품 전부 `t_prd_product_sets` 부모 등록 **0건**(라이브 실측). 완제품/반제품 그릇 배치 검증 대상 없음(일반 완제품).
- 부모 0 확인 = vessel-norm §1 "일반 완제품=셋트 부모 미등록" 정합. **GO**.

## LG6 — 문서 재현성 : N/A

- `03_devdoc/` 비어있음 = 디지털인쇄 상품군 DEV-REQUEST 없음(Phase 4 NO-OP). 재현 대상 문서 부재 → **N/A**(정직 표기, PASS 위장 아님).

## LG7 — 독립성·수렴 : GO (주의 1)

- **생성≠검증**: 게이트는 board/spec/reconcile를 생성하지 않았고, 근거 쿼리를 독립 재작성·재실행. codex 정정 2건(042/047)을 board 인용이 아닌 **라이브 SELECT로 직접 확증**(면끈/아크릴키링고리/보드스탠딩/핀버튼 실측).
- **codex reconcile 수렴**: 합의 2(MOVE0·오차단0)·정정 2(042/047·게이트 라이브 확증 옳음)·라벨수렴 1(037 EXTEND-BLOCKED)·divergence 잔존 1.
- **divergence 1(무옵션 9상품 R-6)**: codex UNCERTAIN(base-only 충분성 미검증) vs Claude EXTEND(신설). 양측 "선택지 손실 없음" 합치 → 보수적 EXTEND 유지 + 기대옵션은 §21 권위/라이브 재확인 위임으로 **종결(위임큐 명시)**. 미조사 대립 아님 → 잔존 처리 타당.
- **★주의(NO-GO 아님)**: Phase 2 board CSV·disposition-spec가 reconcile 정정을 **미반영**(042 스타드림 4행 여전히 KEEP·spec §2 KEEP 예시에 042 잔존). 게이트는 reconcile 정정본을 유효 처분으로 채택(task directive 정합)하므로 판정에는 영향 없으나, **§7 위임 전 board 동기화**(042 KEEP→EXTEND·047 근거확장·037 EXTEND-BLOCKED)가 필요 → 라우팅에 명기.

→ 독립성·수렴 충족·divergence 종결. **GO(board 동기화 주의)**.

---

## NO-GO 라우팅

| 항목 | 게이트 | 처리 |
|------|--------|------|
| (게이트 단계 NO-GO 없음) | — | 전 게이트 GO/N/A |
| 042/047 재배선 PRICE≠0 입증 | LG4 조건 | §7 dbmap 실행 트랙 위임(webadmin 실화면 HARD) |
| 무옵션 9상품 기대옵션 확정 | LG7 divergence | §21 권위/라이브 재확인 후 §7 Tier-A 신설 착수 |
| Phase2 board reconcile 동기화 | LG7 주의 | hlg-option-usage-auditor 반송(042/047/037 라벨 갱신) 또는 §7이 reconcile 직접 소비 |
