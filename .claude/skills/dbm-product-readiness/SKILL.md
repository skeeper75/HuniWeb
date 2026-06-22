---
name: dbm-product-readiness
description: >
  후니프린팅 한 상품군을 "견적가능"까지 종단(세로) 완주시키는 방법론 스킬(round-19). 엑셀 의미컬럼이 목표
  t_*에 적재됐는지 라이브 실측(컬럼 readiness 매트릭스)하고, 견적가능을 Q-게이트(① UI 옵션 선택 + ② 차원
  환원 생산정보 + ③ 가격 계산)로 판정하며 미달분을 기존 라운드로 라우팅한다(점검·판정·라우팅 전용·DB 미적재).
  트리거: '종단 파이프라인', '상품군 종단 완주', '견적가능 판정', '컬럼 readiness', 'RTM', '진척판',
  'round-19', '종단 검증 다시', '상품군 완주 다시'. 전 상품군 횡단 조망은 dbm-coverage-matrix, 단일 레이어는
  각 round 스킬 담당.
---

# dbm-product-readiness — 상품군 종단 견적가능 방법론

## 1. 왜 종단인가 (방법의 핵심)

하네스는 16개 라운드가 전부 **레이어(가로)**다 — 분석(r11/12)·교정(r13)·적재(r5)·CPQ(r6)·가격(r2/16/18).
각 레이어는 정교하지만, 작업이 "상품군"이 아니라 "레이어"로 흩어져서 **한 상품군도 견적가능까지
끝까지 닫힌 적이 없다.** 가로로는 길게 갔는데 세로(한 상품군 완성)로는 0.

round-19는 **세로(종단)**다 — 한 상품군을 골라 기존 레이어 라운드를 *호출 순서로 엮어* 견적가능까지
민다. round-7(전 상품군 횡단·엔티티 레벨 조망)과 종류가 다르다: round-19는 한 상품군·컬럼 레벨·
액션(적재 라우팅)·폐루프(견적가능 확인)다.

> 이것이 사용자 우려("체계적 파이프라인이 제대로 도는가")의 직답: 레이어는 돌지만 종단이 없었다.

## 2. 견적가능의 정의 (조작적 — 거짓 GO 방지)

"견적가능"은 하네스의 두 출력 + 가격이 **모두** 성립할 때만 참이다([[dbmap-goal-ui-quote-mes]]):

| 출력 | 성립 조건 | 라이브 검사 |
|------|----------|------------|
| **① UI 견적** | 손님이 화면에서 옵션을 고를 수 있다 | `t_prd_product_option_groups`/`options`/`option_items` 적재 + (필요시) `templates`/`constraints` |
| **② 생산정보 전달** | 그 선택이 차원(자재·공정·사이즈·도수)으로 환원된다 | `option_items.ref_dim_cd` polymorphic이 라이브 차원행으로 해소(트리거 `fn_chk_opt_item_ref`). **MES_ITEM_CD 아님** |
| **③ 가격 계산** | 선택 조합의 가격이 끝까지 계산된다 | 공식 바인딩→`formula_components`→`component_prices` 사슬 완결([[dbmap-price-chain-dwire-per-product-formula]]) |

하나라도 미달이면 견적가능이 아니다. 기초데이터(사이즈·자재·공정)만 있는 것은 견적가능의 **전제**일
뿐 견적가능 자체가 아니다 — CPQ가 없으면 손님은 아무것도 못 고른다.

## 3. 컬럼 readiness 매트릭스 (booklet식 표준)

`booklet-column-readiness.md`가 입증한 정밀도를 표준으로 삼는다. 한 상품군의 **엑셀 전 의미컬럼**을
행으로, 각 컬럼이 어디로 가야 하고 라이브에 실제로 어떻게 적재됐는지를 실측으로 채운다.

컬럼 1행 = `(C번호 · 엑셀 컬럼명 · L1 실값 샘플 · 목표 t_* 축 · 라이브 적재 실태 · 준비도 · 갭/처리)`.

준비도 판정:
- **✅** 적재완료·매핑명확 (목표 t_*에 라이브 행 존재 + 값 정합) 또는 견적 제외 확정(MES·내부메타).
- **🟡** 부분 (일부 상품만·param 그릇 부재·결정 대기·일부 NULL).
- **❌** 미적재·미정·GAP (그릇 자체 부재 — 예: 제본방향 param 슬롯 없음).

[HARD] 컬럼은 **빠짐없이** 행으로 — 엑셀에 있는 의미컬럼은 다 점검한다(누락 컬럼=은폐). 견적 무관
컬럼(ID·COMMENT·생산메타)은 "제외 확정" ✅로 명시(공백 금지). 상태는 라이브 읽기전용 실측 인용.

## 4. 견적가능 Q-게이트 (S5)

컬럼 readiness가 채워지면, 상품군 전체의 견적가능을 6게이트로 판정한다. 대표상품 + 변형으로 실증.

| 게이트 | 검사 | PASS 기준 |
|--------|------|----------|
| **Q1 컬럼 커버리지** | 전 의미컬럼이 readiness 매트릭스에 ✅/🟡/❌로 분류됐나 | 빈칸 0 |
| **Q2 기초데이터 완전성** | 사이즈·자재·공정·도수가 라이브 적재 | 필요 차원 전부 행 존재 |
| **Q3 ① UI + ② 차원환원** | option_groups/options/option_items 적재 + ref_dim_cd가 차원행으로 해소(생산정보) + (필요시) templates·constraints | 손님 선택 항목 전부 옵션화 + 트리거 해소 0 위반 |
| **Q4 ③ 가격사슬** | 공식 바인딩→배선→단가행 완결 | 대표 조합 사슬 단절 0 |
| **Q5 견적 시뮬레이션** | 대표 선택 → 차원 환원(생산 BOM) + 가격 계산 end-to-end | 보정 하드코딩 없이 성립([[dbmap-price-pipeline-execution-round18plus]]) |
| **Q6 정직 갭** | 미달 항목이 차단유형+라우팅으로 분류됐나 | over/under-report 0 |

Q1~Q6 전부 PASS = 그 상품군 **견적가능 GO**. 하나라도 FAIL = NO-GO + 차단 항목을 §5 라우팅으로.

## 5. 종단 조립 순서 (S0~S7 — 기존 라운드 호출 맵)

round-19는 신규 적재 로직을 만들지 않는다. 기존 라운드를 순서로 엮는다. **각 단계의 실제 작업은 그
라운드 에이전트가, 게이트(S0·S5·S7)는 `dbm-readiness-auditor`가 수행.**

| 단계 | 작업 | 호출 라운드/에이전트 | 산출 |
|------|------|---------------------|------|
| **S0** | 컬럼 readiness 점검 (booklet식, §3) | readiness-auditor (게이트) | `29_readiness/<family>/column-readiness.md` |
| **S1** | 미적재/오적재 식별 + 라우팅 | round-7 `12_coverage/` 재사용 + round-13 `dbm-correctness-auditor` | 갭 라우팅 목록 |
| **S2** | L1 적재 (기초데이터·차원) | round-5 `dbm-load-builder` (멱등 UPSERT·인간 승인) | `09_load/_exec*/` |
| **S3** | CPQ 3종 적재 (option/template/constraint) | round-6 `dbm-option-mapper` + `dbm-validator` | `10_configurator/<family>/` |
| **S4** | 가격 (그릇·사슬·계산) | round-16 `dbm-price-import-builder` / round-18 `dbm-price-engine-verifier` | `20_price-import/`·`26_price-engine-verify/` |
| **S5** | 견적가능 Q-게이트 (§4) | readiness-auditor (게이트) | `29_readiness/<family>/quote-gate.md` |
| **S6** | 실 COMMIT | 인간 승인 (기존 라운드 실행본) | 라이브 적재 |
| **S7** | RTM 갱신 + 견적가능 확인 폐루프 | readiness-auditor | `29_readiness/_rtm.md` |

원칙: S0에서 이미 ✅인 요소는 적재 단계(S2~S4)를 건너뛴다(중복 적재 금지). ❌/🟡만 라우팅.
적재(S2~S4) 후 S5 재실측으로 그 요소가 견적가능에 기여하는지 확인 — 적재했다고 견적가능 자동 아님.

## 6. RTM — 상품군 × 견적요소 진척판 (`_rtm.md`)

진척을 "라운드 N개 완료"가 아니라 **"견적가능한 상품군 수"**로 센다. 한 판에서 전체가 보인다.

행 = 상품군 11. 열 = 견적요소: `기초(siz/mat/proc/clr) · option · template · constraint · 가격사슬 ·
견적가능`. 셀 = ✅완료 / 🟡부분 / ❌미착수 / ➖불요. **빈칸 = 미검증**(진도판).

마지막 열 "견적가능" = Q1~Q6 GO 여부. 이 열의 ✅ 개수가 하네스의 **진짜 진척**이다.
세션 시작 시 RTM을 읽고 "다음 닫을 상품군"을 고른다.

## 7. 출력 규약

- `29_readiness/<family>/column-readiness.md` — §3 컬럼 매트릭스 + 준비도 집계 + ❌/🟡 갭 목록.
- `29_readiness/<family>/quote-gate.md` — §4 Q1~Q6 판정(①UI·②차원환원·③가격 명시) + GO/NO-GO + 차단·라우팅.
- `29_readiness/_rtm.md` — §6 진척판.
- 모든 판정은 **증거 인용**(엑셀 시트/행/컬럼, 라이브 쿼리/행수). "보인다" 금지. 라이브=읽기전용 SELECT만.

## 8. 재호출 동작

기존 `29_readiness/<family>/`가 있으면 변경된 컬럼/요소만 재점검·갱신, 유효 판정 이월. 적재 라우팅
후에는 해당 요소를 라이브 재실측해 견적가능 폐루프를 닫는다(적재 전 상태로 stale 판정 금지).
다음 상품군은 RTM 빈칸에서 고른다. 우선순위 = 기초완전(Tier A, [[dbmap-tierA-cpq-option-load]])부터.
