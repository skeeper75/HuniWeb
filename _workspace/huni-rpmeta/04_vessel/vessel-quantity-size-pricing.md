# vessel-quantity-size-pricing (V-5 수량 · V-6 사이즈 nonspec · V-7 가격 role) — P3 통합

> rpm-vessel-designer. 저 leverage·샘플 확대 필요 3축을 통합 판정. 권위 = 라이브 read-only 실측(2026-06-17). design ≠ apply.

---

## A. V-5 수량 이중슬롯 (#10 수량모델) — WEAK 🟡

### A0. 한 줄 평결
**그릇 신설 보류 — 후니 미관측(RP ORD_CNT BN 한계) + 라이브에 이미 다중 수량 슬롯 분리 존재.** 사다리 = (필요 시) `options.tags` jsonb 재사용 또는 코드행. 신규 테이블 0.

### A1. search-before-mint (라이브 실측)
라이브 수량 슬롯 실측:
- `t_prd_product_bundle_qtys`(묶음수 `bdl_qty`·`bdl_unit_typ_cd`) — 묶음 단위 슬롯 **분리 실재**.
- `t_prd_product_page_rules`(내지 11행) — 페이지 수량 별 슬롯.
- 가격 수량구간 = `t_dsc_*`·component_prices 차원.
- `t_prd_product_options.tags jsonb`(494행·전부 빈값) — **미사용 유연 슬롯 실재**.

| RP facet | 후니 표현 | 판정 |
|---|---|:--:|
| PRN_CNT 인쇄수량 | 가격 차원(component_prices)·bundle_qty | ✅ |
| 묶음수 | `bundle_qtys.bdl_qty`+`bdl_unit_typ_cd` | ✅ |
| ORD_CNT 디자인 건수(곱수 vs 선형) | **후니 미관측** — BN 현수막 RP만. 굿즈/디지털 동형 슬롯 존재 여부 미입증 | ❓ 샘플 부족 |

### A2. 그릇 설계
- **신규 그릇 0(권고)** — ORD_CNT 별 슬롯 정당성이 후니 데이터로 입증 안 됨(과잉 일반화 경계, vessel-needs §V-5 명시).
- 만약 후니 상품에 건수×수량 이중축이 발견되면 → 사다리: ① `options.tags` jsonb(`{"qty_role":"곱수"}`) 재사용(미사용 슬롯) ② 또는 `bdl_unit_typ_cd`에 코드행 추가. **테이블 신설 불요.**

### A3. open decision
1. 후니 상품에 ORD_CNT(디자인 건수=세팅곱수) 슬롯이 실재하는가? → dbmap 가격 트랙 샘플 확대 후 판정. 현재 그릇 mint 보류.

---

## B. V-6 사이즈 nonspec 범위 (#13 사이즈) — WEAK 🟡

### B0. 한 줄 평결
**범위 그릇은 V-4 제약(RULE_TYPE.05 min-max)으로 일원화 권고 — size 행에 min/max 컬럼 추가보다 제약 logic이 정합.** size 마스터 컬럼 신설 보류. size/plate 혼재는 data 정합(plate 트랙·vessel 아님).

### B1. search-before-mint (라이브 실측)
라이브 `t_siz_sizes` 컬럼: `work_width/height`·`cut_width/height`·`margin_*`·`impos_yn`·`tags jsonb`(510행 중 1행만 사용). nonspec min/max 전용 컬럼 **없음**.
| 후보 | 근거 | 무손실? |
|---|---|:--:|
| `t_siz_sizes`에 min_w/max_w/min_h/max_h 컬럼 4개 | nonspec(현수막 0~5000)은 *상품별 제약*이지 *사이즈 마스터 속성* 아님 — 같은 자유입력 size가 상품마다 범위 다름 | ❌ 마스터에 두면 상품별 분기 못함 |
| **V-4 제약 `RULE_TYPE.05 범위` + logic jsonb** | `{"<=":[0,{"var":"가로"},5000]}` 상품별 제약으로 표현. 라이브 constraints.logic 실재 | ✅ **정합** |
| `sizes.tags jsonb` | 마스터 메타용·상품별 범위 부적합 | ❌ |

**결론:** nonspec 범위는 사이즈 마스터가 아니라 **상품별 제약** → V-4 RULE_TYPE.05로 흡수. size 마스터 신규 컬럼 mint 불요.

### B2. 그릇 설계
- **신규 그릇 0** — V-4 RULE_TYPE.05(범위) 코드행 재사용. size 마스터 무변경.
- size↔plate 마스터 혼재(이중등록·SIZ_PENDING)는 **data 정합**(`dbmap-platesize-is-output-paper`·plate 트랙) — vessel 아님.

### B3. open decision
1. 후니 현수막류(PRD_000138 등)가 nonspec 자유입력 범위를 실제 보유하는가? → 보유 시 RULE_TYPE.05 제약 적재(dbmap). 미보유 시 그릇 자체 불요.

---

## C. V-7 가격기여 role 태그 (#11 가격기여역할) — WEAK 🟡 (가격 트랙 위임)

### C0. 한 줄 평결
**대부분 dbmap 가격 트랙 범위 — vessel로는 frm_typ_cd 그릇 정도, 그나마 라이브 가격사슬이 component_prices로 작동 중이라 leverage 최하.** 신규 그릇 보류, 가격 트랙 위임.

### C1. search-before-mint (라이브 실측)
- 라이브 가격: `price_formulas`(17)·`formula_components`·`price_components`(`prc_typ_cd`=PRICE_TYPE 단가/합가·`use_dims jsonb`)·`component_prices`(3,416·`dim_vals jsonb`). 가격기여 *유형*은 prc_typ_cd로 운영 중.
- `frm_typ_cd`(PricingModel 유형) = **라이브 부재**(`dbmap-price-formula-audit-round17` 확정·price_views.py 미사용).
- 선택축 행(자재/사이즈/공정)에 price_flag 부착 컬럼 = 부재.

| 후보 | 근거 | 판정 |
|---|---|:--:|
| 선택축 행에 price_role 컬럼 부착 | 가격기여는 이미 component 사슬(use_dims가 어느 차원이 가격에 기여하는지 명시) | ❌ 중복(use_dims가 표현) |
| `frm_typ_cd` 그릇(PricingModel 유형 분류) | round-17: 라이브 부재·price_views.py 미사용·유형축=prc_typ_cd로 운영 | 🟡 거버넌스용 코드그룹은 가능하나 가격 트랙 결정 |

**결론:** 가격기여 역할은 `use_dims jsonb`(어느 차원 기여)+`prc_typ_cd`(단가/합가)로 이미 표현. frm_typ_cd는 거버넌스 편의이나 라이브가 안 쓰는 축 → **가격 트랙(round-17) 위임**, 본 하네스 그릇 mint 보류.

### C2. 그릇 설계
- **신규 그릇 0(권고)** — 가격 표현력은 component 사슬로 충족. frm_typ_cd 거버넌스 코드그룹이 필요하면 가격 트랙(`dbmap-price-formula-audit-round17`)이 코드행으로 결정.

### C3. open decision
1. frm_typ_cd(PricingModel 유형) 거버넌스 코드그룹 신설 여부 = 가격 트랙(round-17) 결정. vessel 위임.

### C4. PR facet 보강 (v4.0 — P-6 digital_price 라우팅 흡수·신규 그릇 0)
> PR 갭 분석(`02_metamodel/_resolved-fragments.md` P-6·`03_gap/vessel-needs.md` PR 흡수 매핑). **신규 vessel-gap 0 — PR P-6은 본 V-7(#11)의 pricing_model/frm_typ 라우팅키 결손과 동일.** 새 테이블/컬럼/V-번호 추가 없음.
- **P-6 = 규격물(digital_price) vs 면적물(면적매트릭스) 가격엔진 분기:** 포스터(`price_gbn=digital_price`·`NO_STD_ABL_YN=N` 비규격 가능·A2/A3/A4/B3/B4 프리셋 + MIN/MAX_CUT 자유입력)와 BN 현수막(`real_price` 면적매트릭스)은 *같은 좌표 입력(CUT_WDT/HGH)·다른 가격엔진*. `price_gbn`이 가격엔진을 라우팅(pricing_model 5종: 면적형 BN / digital_price 규격자유 PR / tmpl·vTmpl·tiered GS).
- **V-7 연결:** P-6의 `price_gbn` 라우팅키 = C1~C2에서 결손으로 본 **`frm_typ_cd`(PricingModel 유형) 라이브 부재**와 동일 갭. 같은 좌표 입력을 어느 가격엔진(원자합산 digital vs 면적 룩업)으로 보낼지를 결정하는 *유형 분류축*이 라이브에 없다(`dbmap-price-formula-audit-round17` 확정 — price_views.py 미사용).
- **그릇 조치:** **신규 그릇 0 — 가격 트랙 위임(V-7 최하·C2 권고 불변).** frm_typ_cd 거버넌스 코드그룹이 신설되면 digital/면적/tmpl/vTmpl/tiered 라우팅을 동시 해소. 본 하네스는 그릇 mint 안 함 — `dbmap-price-formula-types-authority`(면적매트릭스형 vs 고정가형)·`dbmap-digitalprint-atomic-formula-unbuilt`(digital 원자합산형)가 권위인 **dbmap 가격 트랙(round-16/17)** 결정 사안. 사이즈#13 면(프리셋+자유 동일·가격엔진만 분기)은 B절(V-6) RULE_TYPE.05로 이미 정합.
- **판정:** P-6(digital_price 라우팅) = WEAK → **V-7과 함께 가격 트랙 위임.** frm_typ_cd 그릇이 digital/면적 라우팅을 해소(돈 크리티컬·인간 승인).

---

## 종합 (P3 3축)
| 축 | 판정 | 그릇 | 사다리 |
|---|---|---|---|
| V-5 수량 | WEAK→보류 | 신규 0(필요 시 options.tags/코드행) | 샘플 확대 후 |
| V-6 사이즈 nonspec | WEAK→V-4 흡수 | 신규 0(RULE_TYPE.05 재사용) | 코드행(V-4 공유) |
| V-7 가격 role (+PR P-6 digital_price) | WEAK→가격 트랙 위임 | 신규 0 | 위임 |
> 전 3축: 신규 테이블/컬럼 mint 0. 저 leverage·후니 미관측/가격 트랙 귀속으로 vessel 신설 부적합. open decision으로 샘플/트랙 결정 대기.
> ★PR(v4.0): P-6(규격물 digital_price vs 면적물 가격엔진 분기)은 V-7 frm_typ_cd 라우팅키 결손과 동일 → 신규 그릇 0·가격 트랙(round-16/17) 위임(C4). 신규 V-번호 없음.
