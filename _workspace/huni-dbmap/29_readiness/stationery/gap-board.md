# 문구(stationery) — 갭 보드 (round-19 · 2026-07-03)

> 가격 미구성·미적재·오적재 + 재현 + 돈영향 + COMMIT 필요분. 라이브 읽기전용 실측 근거.
> **결론: 가격 결함 0.** 문구 전 10 완제품 가격사슬 완비·PRICE≠0. 잔여는 UI/코드/생산옵션.

---

## Top 5 갭

### G1. STAT-SET-SIZCD (High · 코드 C트랙 · 전 10상품)
- **현상**: 완제품 10종 전부 `is_set=True`(셋트 완제품). 라이브 셋트 UI가 사이즈/묶음수를 `set_selections`로 미전파 시 **초기 화면 0원 → 견적불가**.
- **재현**: `simulate("PRD_000172", {}, 100)` → PRICE=0 (sel 비어 siz_cd 없음). 반면 `simulate_set("PRD_000172", set_selections={"siz_cd":"SIZ_000375"})` → **810,000**. `simulate_set("PRD_000097", set_selections={"siz_cd":"SIZ_000119","bdl_qty":"50"})` → **135,000**.
- **원인**: 엔진 정상. UI(셋트 시뮬레이터)가 dim을 set_selections에 넣지 않는 코드버그 = 엽서북 094 동근(`DEV-REQUEST-set-sim-sizcd-260702`).
- **돈영향**: 전 10상품 라이브 초기 견적 0 = 매출 차단.
- **COMMIT**: **데이터 아님**. 기존 DEV-REQUEST(엽서북과 공통)에 문구 포함.

### G2. STAT-CPQ-VOID (Medium · round-6 · 생산옵션)
- **현상**: `t_prd_product_option_groups`=0 전 상품. 생산전용 선택옵션 미노출: 면지컬러(하드커버 화이트/블랙/그레이·C27)·제본방향(좌철/상철·C28)·무지내지(C13)·개별포장(C35).
- **재현**: `SELECT count(*) FROM t_prd_product_option_groups WHERE prd_cd IN (문구10)` → 0. product_materials(하드커버 173/174)=0(면지 자재 미등록).
- **돈영향**: 0(가격 고정단가 흡수). ②생산정보 전달만 결손.
- **COMMIT**: round-6 opt_groups 신설(인간 승인). 가격 무관.

### G3. 사이즈 dflt 데이터 결함 (Medium · 데이터)
- **현상**: prod_dims의 dflt 부정합 — 다중사이즈(097·179) **양 옵션 dflt=true**, 단일사이즈(172~176 등) **dflt 없음**.
- **재현**: sim-meta `prod_dims` 실측 — 097 siz 90x90/70x120 둘 다 `"dflt":true`; 172 130x190 dflt 미표기.
- **돈영향**: 위젯 기본선택 애매 → 초기 0원 표시 유발(G1 악화).
- **COMMIT**: dflt 정규화(단일=dflt true·다중=대표 1개만).

### G4. parent BOM 공백 (Low · 생산추적)
- **현상**: 172~181 완제품 `product_materials`=0(097만 2). 상세 BOM은 members(293~308)에.
- **돈영향**: 0(all-in 고정단가라 가격 무해).
- **COMMIT**: 선택적. 생산 spec member 의존 확인.

### G5. STAT-MULTI-VOID(RTM) stale — 정정 (오적재 아님 · 진단 오류 정정)
- **현상**: RTM 2026-06-15은 문구를 "가격그릇 부재(STAT-PRICE-GRID)·CPQ 전무·바인딩 0"으로 NO-GO 기록. **6/15 이후 가격그릇 적재됨 → 판정 stale**.
- **재현**: `t_prd_product_price_formulas` 문구 바인딩 10건·`t_prc_component_prices` COMP_STN_* 값 실재(9,000/12,000/…·TTEOKME 112행).
- **돈영향**: 없음(현 상태 정상). RTM 갱신 필요.

---

## 미적재/오적재 판정

| 항목 | 판정 | 근거 |
|------|------|------|
| 가격공식 바인딩 | ✅ 적재됨 | 10/10 PRF_STN_*/PRF_TTEOKME |
| 가격구성요소·단가행 | ✅ 적재됨·값 정합 | COMP_STN_* 1행씩·MEMOPAD 2행·TTEOKME 112행·golden verbatim |
| 사이즈↔단가행 siz_cd | ✅ 정확일치 | silent-0(siz_cd 불일치) 없음 |
| 구간할인 | ✅ 작동 | 172=900,000→810,000 실측 |
| t_prd_product_prices(직접단가 테이블) | ➖ 0행(설계상) | 직접단가는 component_prices(PRICE_TYPE.01)로 실현 — 미적재 아님 |
| CPQ opt_groups | ❌ 미적재(생산옵션) | 0행·가격 무관 |
| 오적재 | 없음 | 가격값·siz_cd·구간할인 전건 정합 |

---

## COMMIT 필요분 유무

- **가격 데이터 COMMIT: 불필요** (이미 완비·PRICE≠0).
- **코드(C트랙): 필요** — 셋트 UI dim 전파(엽서북 공통 DEV-REQUEST).
- **CPQ 신설(선택·round-6): 생산옵션 + dflt 교정** (인간 승인).
