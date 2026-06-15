# 책자(booklet) 동형 사이클 독립 검증 게이트 (round-21 7차 사이클)

> 작성 2026-06-15 · `dbm-validator`(독립 검증·생성자 분리·DB 읽기전용·미적재).
> 대상 = `booklet-class.md`(Sc)·`booklet-rep-5layer.md`(S0~S5)·`booklet-cycle-report.md`(S5).
> 방법 = 라이브 읽기전용 직접 실측(2026-06-15) + 가격표 엑셀 `제본` 시트 byte 대조.
> 권위 = 라이브 t_* > 생성자 주장 / 가격표 엑셀 셀 > 생성자 restate 표.

---

## 0. 비준 결론

- **생성자 NO-GO 판정(`BOOKLET-BIND-WIRE`) = 비준(번복 없음).** Q3·Q4·Q5 FAIL을 독립 재현으로 확증.
- **verbatim 32/32 = 독립 재현 성공**(가격표 엑셀 셀 ↔ 라이브 단가행 byte 대조, mismatch 0).
- **7/7 시스템 결론 일관 = 동의.** 책자 차단 전부 WIRE/CPQ/ENGINE/그릇 = 시스템 결함, per-product 결함 0.
- **거짓 GO / 거짓 NO-GO / 날조 = 0건 적발.** 생성자 정직성 확증(7번째 사이클 연속).
- 검증자 자체 1차 측정 오류 1건(option_items 조인 fan-out) → 재측정으로 자가 철회(아래 §3).

---

## 1. 게이트별 PASS/FAIL + 독립 재측정 vs 생성자 주장 대조

| 게이트 | 생성자 주장 | 검증자 독립 실측 | 판정 |
|--------|------------|------------------|:--:|
| **공식 바인딩** | 068/069/070/071→PRF_BIND_SUM·094→PRF_PCB_FIXED·072/077/082/088/097=0 | 동일(5 rows: 4×BIND_SUM+1×PCB_FIXED·off-class 0 rows) | **PASS** |
| **B-WIRE(formula_components)** | PRF_BIND_SUM에 중철 comp 1개만 배선·무선/PUR/트윈링 미배선 | `t_prc_formula_components` PRF_BIND_SUM=`COMP_BIND_JUNGCHEOL` 1행뿐(MUSEON/PUR/TWINRING 0) | **PASS(FAIL 재현)** |
| **단가행 존재(4×8)** | JUNGCHEOL8·MUSEON8·PUR8·TWINRING8 | `min_qty` 8행씩 정확(JUNGCHEOL/MUSEON/PUR/TWINRING 각 8) | **PASS** |
| **verbatim 32/32** | 가격표 제본 B1 ↔ 단가행 32/32 일치 | 엑셀 `제본` 시트 r3~10 직접 파싱 → 32셀 byte 대조 mismatch **0** | **PASS** |
| **070 CPQ 0행** | option_groups/options/items 전부 0 | groups=0·options=0·items=0 | **PASS** |
| **069/071 ref 해소** | ref_dim NULL 0·미해소 0·트리거 위반 0 | 069/071/068/094 ref_dim_null=0·ref_key1_null=0·`fn_chk_opt_item_ref` 존재 | **PASS** |
| **option_groups 수** | 068=7·069=8·071=9·070=0 | 동일(068=7·069=8·071=9·070 부재) | **PASS** |
| **option_items 수** | 069=32·071=60·068=35·094=13 | 동일(options→items 직조인: 32·60·35·13) | **PASS** |
| **069 ref_dim 분포** | .01=2·.03=13·.04=13·.06=4 | 동일 | **PASS** |
| **071 ref_dim 분포** | .01=4·.03=49·.04=3·.06=4 | 동일 | **PASS** |
| **제본공정 1:1** | 068→18·069→19·070→20·071→21 | `t_prd_product_processes` 동일 | **PASS** |
| **C32 제본방향 그릇 부재** | 좌철/상철 per-product 슬롯 없음·CPQ 옵션 없음 | 책자4 option_groups 24개 어디에도 "제본방향" 없음·방향은 PROC_000017(제본) 입력정의로만 존재 | **PASS(❌ 재현)** |
| **클래스 경계** | 094=완제품(PCB_FIXED 2배선)·하드커버3/싸바리=별클래스(comp 有·바인딩0) | 094 PCB_FIXED 2 comps·HC_MUSEON/HC_TWINRING/SSABARI 각 6행·off-class 바인딩 0 | **PASS** |

---

## 2. 견적가능 3요소 게이트(Q1~Q6) 독립 비준

| 게이트 | 생성자 | 검증자 비준 |
|--------|:--:|------------|
| Q1 컬럼 커버리지 | PASS | 비준(빈칸0·readiness 분류는 booklet-column-readiness 선행 산출 — 본 게이트 범위 외이나 모순 없음) |
| Q2 기초데이터 | PASS | 비준(상품행4·제본공정1:1·자재/공정/단가행 실재) |
| Q3 ①UI+②차원환원 | FAIL(부분) | **비준** — 069/071 ref 전건 해소(✅)이나 070 CPQ 0행·C32 방향 부재로 부분 FAIL 정당 |
| Q4 ③가격사슬 | FAIL | **비준** — PRF_BIND_SUM 중철 1 comp만 배선(라이브 실측 1행) |
| Q5 견적 시뮬 | FAIL | **비준** — 무선/PUR/트윈링 comp가 공식 경로 미도달(엔진 불가)·중철만 도달 가능 |
| Q6 정직 갭 | PASS | **비준** — over/under-report 0(아래 §3 dodge-hunt 결과) |

→ **Q3·Q4·Q5 FAIL = 책자4 NO-GO** 독립 비준. **③ 가격 단절로 견적가능 불성립**(②는 완비). 값이 verbatim이어도 GO 주지 않은 것 = 거짓 GO 금지 원칙 준수.

---

## 3. dodge-hunt(거짓·날조·누락 적발) 결과

| 의심 항목 | 검사 | 결과 |
|-----------|------|------|
| verbatim이라며 불일치 은폐? | 엑셀 셀 직접 파싱 후 32셀 byte 대조 | **은폐 0** — mismatch 0, 32/32 진짜 일치 |
| NO-GO라며 일부 GO 가능 누락? | 중철(068) 사슬 완결 여부 | 생성자가 "중철만 가능(K4 ✅)"으로 정직히 명시 — 누락 아님 |
| 동형 분류에 미출시/이질 상품 끼움? | 068~071 상품행·제본공정·바인딩 실재 | 4상품 전부 실재·미출시 0·이질 상품(094/하드커버/싸바리) 정확히 배제 |
| 070을 "미출시"로 과장? | 070 상품행 존재 + 기초데이터 | 070 상품행 실재 → "옵션 적재 대기"로 정직 분류(미출시 단정 안 함) ✅ |
| off-class 바인딩 누락 과장? | 072/077/082/088/097 바인딩 | 실제 0 rows — "별 클래스" 정당 |

→ **거짓 GO / 거짓 NO-GO / 날조 / 과장 = 0건.**

### 검증자 자가 철회 (정직성)
- 1차 측정에서 `option_groups→options→items` 3중 조인으로 069=106·071=82·068=177·094=54를 얻어 생성자(32/60/35/13)와 불일치 적발 보고 직전이었으나, **group 조인의 fan-out**(한 item이 다중 group과 카티전 곱)임을 발견. `options→items` 직조인으로 재측정 → **069=32·071=60·068=35·094=13** 생성자와 정확히 일치. → **검증자 측정 오류였음을 명시 철회.** 생성자 수치 정확.

---

## 4. 7/7 시스템 결론 일관성 동의

| 사이클 | 상품군 | 단가행 값 | 차단 유형 | 일관? |
|--------|--------|:--:|-----------|:--:|
| 1~6 | 엽서·명함·아크릴·포토카드·실사·스티커 | verbatim ✅ | WIRE/CPQ/ENGINE/그릇 | (선행 비준) |
| **7** | **책자** | **verbatim 32/32 ✅** | **WIRE(중철외 미배선)+CPQ(070)+그릇(C32)+ENGINE** | **✅ 동의** |

- 책자 = 새 결함 유형 없음. **WIRE 결함의 4번째 인스턴스**(엽서 D-1b·명함·실사·책자)로 수렴 — 생성자 통찰 비준.
- 명함 NAMECARD-WIRE와 동근(1공식 다상품 공유·각자 1고정 방식) → A안(PRF_BIND_<방식> 분리)로 동일 패턴 해소 가능 = 비준.
- **per-product 결함 0** 비준 — C32도 스키마 구조(공정 param 슬롯 부재) 시스템 결함.

---

## 5. 최종 비준 + 라우팅

- **최종 = NO-GO 비준** (생성자 자가판정 유지). 차단 `BOOKLET-BIND-WIRE`(+CPQ-070·C32-DIR·ENGINE).
- 라우팅 정합(번복 없음):
  - BK-1 BOOKLET-BIND-WIRE → round-5 `dbm-load-builder`(A안 공식 3신설·comp 3배선·바인딩 3교정) + 엔진 동시배포 선결.
  - BK-2 070 CPQ 신설 → round-6 `dbm-option-mapper`(069 코어 복제).
  - BK-3 C32 제본방향 그릇 → `dbm-ddl-proposer`/CPQ 신설·도메인 컨펌.
  - BK-4 ③템플릿·④constraints 재실측 → round-6(🟡 미확정 정직 기록 비준).
- **실 COMMIT 0**(읽기전용 종단). 가격 COMMIT은 엔진 미구현으로 현재 실청구 위험 0 — 동의.

### 미확정(생성자 🟡 동의 — 본 게이트도 미실측)
- ③ 템플릿(셋트구성)·④ constraints(JSONLogic 조합 제약): 생성자가 🟡로 정직 기록. 본 게이트도 미실측이라 PASS/FAIL 부여 안 함(과대판정 회피). round-6 재실측 큐 유효.
- PRF_BIND_SUM 완제품가 내지/표지 항 배선 여부: 생성자가 "미실측·의심"으로 정직 기록 — 비준. 제본 comp 1행만으로는 완제품가 불성립이 맞음.
