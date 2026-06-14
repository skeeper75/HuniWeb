---
name: dbm-price-engine-verify
description: 후니프린팅 라이브에 적재된 가격 데이터가 명세대로 "실제로 올바른 가격을 계산하는지" 상품군별로 실증검토하는 round-18 방법론 스킬. 라이브 계산 엔진(evaluate_price)이 미구현임이 라이브 가격뷰어("가격엔진 다음 단계 완성 후 활성화")로 확인된 상태에서, 호출할 엔진이 없으므로 ① 가격사슬 완전성을 라이브 실측(가격소스 바인딩·공식→formula_components 배선→price_components→component_prices 단가행·t_dsc 수량구간 할인 연결·등급) ② Phase11 명세(11-CONTEXT/prcx01)대로 검증용 계산기를 재구현해 대표 선택+수량 케이스를 재계산(단가형/합가형 환산·NULL 와일드카드·동시매칭 오류·수량구간·시계열·할인 순차곱·우선순위) ③ 재계산값을 가격표 엑셀 known값·가격뷰어와 수치 대조 ④ 가격뷰어 표시 정합을 검증한다. 생성(dbm-price-engine-verifier)·게이트(dbm-validator PE1~PE6) 분리. 상품군 아크릴·문구·굿즈/파우치 + 가격뷰어. DB 직접 쓰기 없음(라이브 읽기전용·실 적재/배선/엔진구현은 인간 승인). '가격엔진 실증', '가격계산 검증', '가격공식 매핑 실증', '가격사슬 완전성', '재계산 검증', '단가형 합가형 계산', '수량구간 할인 계산', '가격뷰어 정합', '아크릴 가격 검증', '문구 가격 검증', '굿즈 파우치 가격 검증', 'round-18', '가격엔진 검증 다시', '실증검토' 작업 시 반드시 이 스킬을 사용. 가격표→그릇 분해(round-16)는 dbm-price-import-prep, 가격공식 정리 정적검증(round-17)은 dbm-price-formula-audit, 가격공식 엔진 fit-gap(round-2)은 dbm-price-formula가 담당하므로 그 작업에는 트리거하지 않는다.
---

# dbm-price-engine-verify — 가격엔진 실증검토 (round-18)

라이브에 적재된 가격 데이터(공식·구성요소·단가행·수량구간 할인)가 **명세대로 실제로 올바른 가격을 산출하는지**를 상품군별로 실증한다. round-2/16/17이 매핑·그릇·정적정리(공식이 정리·배선됐는가)를 다뤘다면, round-18은 **계산이 맞는가**를 수치로 증명한다 — 종류가 다른 **생성-검증** 트랙.

## 0. 왜 "검증용 재계산"인가 (HARD 전제)

라이브 계산 엔진 `evaluate_price`는 **존재하지 않는다**(라이브 gstack 실증: 가격뷰어 ⑤ 카드 "가격엔진(다음 단계) 완성 후 활성화"·`raw/webadmin`에 `pricing.py` 부재·ROADMAP Phase 11 미완). 가격뷰어는 가격 소스/배지(공식 바인딩·직접단가·할인 링크·SKU)를 **표시만** 하고 계산하지 않는다. 따라서 "엔진을 호출해 결과를 검증"하는 길은 닫혀 있고, **명세(Phase11)대로 계산기를 재구현해 라이브 데이터로 돌린 뒤 정답(가격표)과 대조**하는 것이 유일한 비침습 실증 경로다. webadmin에 실제 엔진을 만들지 않는다(읽기전용·별도 GSD 레포).

## 1. 권위 (입력 순서)

1. **계산 모델** = `raw/webadmin/.planning/phases/11-price-engine-simulator/11-CONTEXT.md` + `raw/webadmin/docs/prcx01-pricing-model.md`. 명세에 없는 규칙은 발명 금지.
2. **가격 그릇** = 라이브 `t_prc_*` 4테이블 + `t_dsc_*` + `t_prd_product_price_formulas`/`t_prd_template_prices` (information_schema 실측이 컬럼 권위 — round-16/17 교훈 `frm_typ_cd` 등은 라이브로 결판).
3. **정답(기대가)** = 가격표 엑셀 `docs/huni/후니프린팅_인쇄상품_가격표_260527.xlsx` known값 > 상품마스터 가격포함 시트 > 가격뷰어 표시 소스(=바인딩 권위이지 금액 권위 아님) > 도메인.
4. **재사용** = round-16 `20_price-import/<sheet>/`(그릇 분해·가격사슬 단절 진단) + round-17 `21_price-formula-audit/`(공식 인벤토리). 재유도 금지.

## 2. 계산 알고리즘 (11-CONTEXT 확정 — 재구현 기준)

`recompute.py`는 다음을 충실히 구현한다(임의 변형 금지):

1. **가격 우선순위**: 템플릿단가 > 상품 직접단가(`t_prd_product_prices`) > 상품 공식(`t_prd_product_price_formulas`→`t_prc_price_formulas`) > 없음(계산불가).
2. **공식유형**: `FRM_TYPE.01 합산형`(Σ 구성요소), `FRM_TYPE.02 단순형`(구성요소 1~2개·합산형 특수케이스 동일 로직).
3. **합산 대상 = 선택값 매칭 자동판정**: 사용자 선택값(자재·사이즈·도수·코팅·공정·옵션·수량)과 `t_prc_component_prices` 차원 컬럼이 매칭되는 단가행이 있는 구성요소만 합산. 미선택 옵션은 매칭 실패로 자연 제외(호출자가 구성요소 목록 안 넘김).
4. **단가/합가 이원화**(`t_prc_price_components.prc_typ_cd`): `PRICE_TYPE.01 단가형` = `unit_price(장당가) × 주문수량`. `PRICE_TYPE.02 합가형` = `unit_price(구간총액) ÷ 구간 min_qty = 장당가` 환산 후 `× 주문수량`.
5. **NULL = 와일드카드**: 단가행 차원이 NULL이면 그 차원은 어떤 선택값이든 매칭(PRCX-01).
6. **동시매칭 = 데이터 오류**: 한 구성요소에서 같은 선택값에 단가행 2개 이상 매칭(NULL행+전용행 공존 포함)이면 "최구체 우선" 흡수 금지 → **오류**(검증 모드=경고+해당 행 목록).
7. **수량구간**: 주문수량 이하 최대 `min_qty` 구간. 최소구간 미달(예: 최소 100인데 50 주문) = **계산불가**.
8. **시계열**: 같은 차원 조합 내 가장 최근 `apply_ymd <= 기준일` 행(PRC-08).
9. **할인**: 수량구간 할인(`t_dsc_discount_tables`/`details`, 상품 연결분) → 등급 할인(`t_dsc_grade_discount_rates`, 0행=스킵) **순차 곱**(직전 결과 기준). 등급 미지정=기준가.
10. **금액**: 중간 Decimal 유지, 최종가 원 단위 ROUND_HALF_UP.

> `addtn_yn`(현재 전부 'Y')은 이번 엔진에서 무시(11-CONTEXT 확정·매칭 자동판정만).

## 3. 산출물 (`_workspace/huni-dbmap/26_price-engine-verify/<family>/`)

상품군(`acrylic`·`stationery`·`goods-pouch`)별로:

| 파일 | 내용 |
|------|------|
| `chain-completeness.md` | 상품별 표: 가격소스(공식/직접단가/없음)·공식→`formula_components` 배선·`comp_cd`→`component_prices` 단가행 유무·`t_dsc` 할인 연결·등급. 사슬 **완결/단절(지점)** 판정. 라이브 실측 + 가격뷰어 3원 대조(엑셀↔DB↔뷰어). |
| `recompute.py` | Phase11 명세 재구현 계산기(라이브 read-only SELECT). 손편집 금지·결정적. |
| `recompute-cases.md` | 대표 상품 × 대표 선택+수량 케이스 재계산 내역(구성요소별 매칭 단가행·단가/합가 환산·소계·할인단계·최종가). |
| `expected-vs-computed.md` | 가격표 known값 vs 재계산값 수치 대조 — 일치/불일치(원인)/계산불가. |
| `defects.md` | 결함 보드: 가격 미구성·사슬 단절·할인 미연결·동시매칭·최소수량 미달·prc_typ 오적재·기대값 불일치 + 라우팅(round-5 배선/적재·round-13 교정·ddl-proposer). |

가격뷰어 정합은 `chain-completeness.md`에 통합(대표상품 gstack `qvSelect` 표시 vs DB 실측).

## 4. 검증 게이트 (dbm-validator, PE1~PE6 — 생성자≠검증자)

| 게이트 | 합격 기준 |
|--------|----------|
| **PE1 권위 인용 실재** | 11-CONTEXT/prcx01 규칙 인용이 실재·가격표 기대값 셀이 실재. |
| **PE2 사슬 실측 정확** | `chain-completeness`의 바인딩·배선·단가행·할인 연결을 validator가 라이브 read-only로 독립 재현·가격뷰어 3원 일치. |
| **PE3 계산 알고리즘 정합** | `recompute.py`가 §2 규칙(단가/합가·NULL·동시매칭 오류·수량구간·시계열·할인 순차곱·우선순위) 준수(임의 변형 0). |
| **PE4 기대값 대조** | 재계산값이 가격표 known값과 수치 일치. 불일치는 원인 분류(데이터 결함 vs 재계산 버그)·계산불가는 단절 지점 명시. |
| **PE5 결함 정직성** | 미구성/단절을 계산성공으로 위장 0·임의 0원 대체 0·계산불가 정직 표기. |
| **PE6 독립성** | validator가 생성자와 독립으로 대표 케이스 1건 이상 손계산 재현(생성자 산출 맹신 금지). |

전부 PASS = GO. 발견 결함은 verifier로 라우팅(조용히 수정 금지). **NEVER COMMIT/DDL.**

## 5. 범위·비파괴

- 상품군: **아크릴·문구·굿즈/파우치** + 가격뷰어 정합(사용자 지정). 파일럿 깊이 우선·GO 후 확장 가능.
- **DB 미적재**: 라이브 읽기전용 SELECT + admin 읽기 탐색(저장/삭제 금지). 실 배선/적재/엔진구현(Phase 11)은 본 트랙 종착점 너머·인간 승인.
- 보안: 자격증명 `.env.local`만(`RAILWAY_DB_*`·`HUNI_ADMIN_*`)·stdout/_workspace 비노출.

## 6. 인간 결정 게이트 (라운드 종료 전 에스컬레이션)

- 가격사슬 단절분(공식 미바인딩·배선 0·할인 미연결) 실 교정 진행 여부(round-5/13 트랙·인간 승인).
- 가격표 기대값 부재 상품군의 정답 권위 확정.
- 재계산 불일치가 "데이터 결함"인지 "명세 해석 차"인지 판정(실무진/사용자).
- 실제 `evaluate_price` 엔진(webadmin Phase 11) 구현 착수 여부(별도 레포·범위 큼).
