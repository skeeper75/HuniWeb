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

---

## 7. PR facet 보강 (v4.0 — P-7 자재풀 게이팅 흡수·신규 그릇 0)

> PR(인쇄물·책자) 카테고리 갭 분석(`02_metamodel/_resolved-fragments.md` P-7·`03_gap/vessel-needs.md` PR 흡수 매핑). **신규 vessel-gap 0 — PR P-7은 본 V-2 그릇에 facet 강화로 흡수.** 새 테이블/컬럼/V-번호 추가 없음.

### 7.1 P-7 = "PrintMethod gates Material pool" 관계 간선 강화
- **PR 근거(`reverse.md §2·§0.4`):** 책자 내지 윤전전용지(`RXYWM080` 윤전전용백색모조80g·`RXPLW080` 에스플러스백색)는 *윤전(offset rotary) 인쇄방식에서만 쓰는 자재*. 즉 인쇄방식이 가능 자재 *부분집합*을 결정 — `윤전→YWM(윤전전용지) pool`, `토너/인디고→다른 pool`.
- **간선 의미:** §1의 "방식→가능공정 게이팅"(공정 부분집합)과 **동형의 자재판** — `process-recipe-tree §1` "1상품=1인쇄방식이 가능 공정 부분집합 결정"의 *자재 부분집합* 버전. #12(인쇄방식 레시피) → #1(자재) 사이의 새 관계 간선(`gates-material-pool`)이지 새 축이 아님.
- **그릇 조치:** **신규 그릇 0.** 자재풀 게이팅도 §2 경로 A(제약 축 흡수)로 무손실 표현 — `RULE_TYPE.02(금지)` + `logic jsonb` JSONLogic이 `인쇄방식 선택 → 비호환 자재 disable`을 표현. 공정 게이팅과 *같은 제약 그릇*이 자재 게이팅도 담는다(이중저장 없음).
  - 예: `{"if":[{"==":[{"var":"인쇄방식"},"토너"]}, {"disable":["자재:윤전전용지풀"]}]}` (logic shape는 앱 컴파일러 권위).
- **search-before-mint(자재풀 게이팅 면 재확인):** 자재풀 부분집합 = 상품별 *선택 가능 option_items 집합* + 인쇄방식 변경 시 캐스케이드 disable. 라이브 `t_prd_product_constraints.logic jsonb`(실재) + option_items(ref_dim_cd=OPT_REF_DIM.05 자재)로 이미 표현 가능 → **자재풀 게이팅 전용 그릇 mint 불요.**

### 7.2 책자 19상품 = 인쇄방식 × 제본방식 × 도수 매트릭스 (설계 노트)
- **PR 근거(`reverse.md §0.4`):** 같은 "무선 책자(컬러)"가 인쇄방식별 별도 pdtCode로 분기 — `PRBKYPR`(윤전)·`PRBKOPR`(토너)·`PRBKORD/PRBKOCD`(토너 특가)·`PRIDPRT`(인디고). 19 책자 = 인쇄방식(윤전/토너/인디고) × 제본방식(무선/스프링/트윈링/스테플러/실제본) × 도수(컬러/흑백) 매트릭스를 개별 pdtCode로 펼침.
- **정규화 관점(설계 노트·메타모델 P-4 판정 반영):** 이 매트릭스 전개는 **메타모델 판정이 아닌 후니 카탈로그 정책 결정**(GS G-2 코스터 6 pdtCode·TP T-4 "디자인X"와 동류 "공정방식=상품분기" 정책패턴). 메타모델은 양쪽 표현 가능:
  - **(가) RP 답습 — pdtCode 분리(19상품):** 인쇄방식이 자재풀(7.1)·최소수량·가격모델(P-6/V-7)을 *동반 결정* → pdtCode 분기가 게이팅 명세를 단순화. 단 카탈로그 폭증.
  - **(나) 옵션화 — 한 "책자" + 인쇄방식/제본방식/도수 차원:** 카탈로그 축소·관리용이. 단 인쇄방식이 자재풀·가격엔진 게이팅이라 캐스케이드(7.1 제약 logic)가 복잡.
  - **권고(P-4 동형):** 도수(컬러/흑백)=옵션화(자재풀 동일)·인쇄방식(윤전/토너/인디고)=별 pdtCode(자재풀·가격모델 다름·게이팅)·제본방식=PCS/자재 캐스케이드 정도 따라 혼합.
- **그릇 영향:** 어느 정책이든 **V-2 그릇 변화 0** — pdtCode 분기는 상품 행(기존), 옵션화는 option_group(택1·기존)+제약 logic(7.1). 매트릭스 차원(인쇄방식=공정 행·제본=공정 #2·도수=기초코드 #6)은 전부 라이브 실재 축. 매트릭스가 pdtCode로 정규화됨은 *상품 마스터 정책*이지 새 그릇 수요 아님.

### 7.3 PR facet → V-2 판정 정리
- **P-7(자재풀 게이팅) = GAP → 경로 A로 PASS**(공정 게이팅과 동일 제약 그릇·신규 0). 토너/인디고 책자 자재풀 차이는 **unobserved → gap/validation**(샘플 확대 시 실측).
- 책자 매트릭스 정규화 = 후니 카탈로그 정책(dbmap 상품 마스터) · vessel 조치 0.
- **★요지:** PR이 V-2에 더한 것은 새 그릇이 아니라 게이팅 간선의 *자재 부분집합* 면. 경로 A(제약 흡수)가 공정·자재 게이팅을 모두 담으므로 1급 PrintMethod 테이블 mint는 여전히 보류(§0 결론 불변).

## 8. ST facet 메모 (v5.0 — S-5 인쇄방식 합류·신규 그릇 0)
- **ST S-5(인쇄방식 일반/UV/DTF/후지)가 V-2(#12)에 횡단 합류**(PR P-4/P-7과 동류·`vessel-shape-axis.md §5`·`gap-matrix XIII-2`). ST는 인쇄방식이 자재(DTF=DTF전용필름)·도수노출(DTF=숨김)·화이트강제(DTF ESN=Y)·가격엔진(vTmpl)을 동반결정 — 경로 A(제약 `RULE_TYPE.02 금지` + `logic jsonb`)가 ST UV/DTF/후지 게이팅도 무손실 흡수(공정·자재 게이팅과 동일 그릇·신규 0). 경로 B 1급화 결정 시 PRINT_METHOD enum에 ST 방식(UV/DTF/후지) 포함 권고. **§0 결론 불변(1급 테이블 보류)** — ST는 새 방식 enum 값만 더할 뿐 새 그릇 수요 0.

## 9. CL facet 메모 (v6.0 — C-6 의류 인쇄방식 합류·신규 그릇 0)
- **CL C-6(의류 인쇄방식 실크/전사/DTF/나염)가 V-2(#12)에 횡단 합류**(PR P-4/P-7·ST S-5와 동류 #12 GAP·`reverse.md §0.4·§288`·`gap-matrix XV`·`vessel-needs.md CL 흡수 매핑`). 의류 `apparel_info.print_type` 3종(실크/전사/DTF 추정)이 자재(DTF=DTF전용필름)·도수노출·화이트강제·Pantone 활성·가격엔진(clothes2025_price)을 동반결정 — 경로 A(제약 `RULE_TYPE.02 금지` + `logic jsonb`)가 의류 인쇄방식 게이팅도 무손실 흡수(공정·자재 게이팅과 동일 그릇·신규 0).
- **★CL 인쇄방식의 삼면 표현(설계 노트):** 의류 인쇄방식은 ① 자재 facet(DTF전용필름 등)과 ② 상품내 옵션 인코딩(`apparel_info.print_type` 옵션값)으로 동시에 나타난다 — ST(자재facet/상품분기/상품내옵션 삼면)와 동형. CL은 *상품내 옵션 인코딩*이 주(clothes2025 apparel_info에 print_type 키)이고 상품분기는 약함(같은 티셔츠가 인쇄방식 옵션으로 분기 아닌 pdtCode 단일) → 경로 A 옵션+제약 그릇이 가장 자연스러운 흡수. 경로 B 1급화 결정 시 PRINT_METHOD enum에 CL 방식(실크/전사/DTF/나염) 포함 권고. **§0 결론 불변(1급 테이블 보류)** — CL은 새 방식 enum 값만 더할 뿐 새 그릇 수요 0.
