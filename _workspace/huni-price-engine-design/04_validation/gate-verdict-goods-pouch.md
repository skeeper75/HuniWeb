# gate-verdict-goods-pouch.md — 굿즈/파우치(단일고정가 + 변형고정가 + 구간할인타입) 가격엔진 설계 독립 검증 (E1~E7)

> **hpe-validator 독립 검증 (생성≠검증).** engine-designer 설계 주장을 라이브 t_prc_*·t_prd_*·t_dsc_*·권위 엑셀로 직접 재실측해 결판.
> 라이브 읽기전용 SELECT 실측 2026-06-20(Railway `db railway`·psql) · pricing.py(`raw/webadmin/webadmin/catalog/pricing.py`·569줄) 코드 직접 검증 · 골든 15건 충실 재구현(허용오차 0).
> 검증 대상: `03_design/engine-design-goods-pouch.md`·`golden-cases-goods-pouch.md`(GC-GP1~15)·`design-decisions.md` 굿즈절(GP-DEC-1~5)·`set-product-design.md` §10.
> 기준점: `01_formula/formula-map-goods-pouch.md`·`02_benchmark/absorption-candidates-goods-pouch.md`.

---

## 0. 종합 판정: **GO** (E1~E7 전건 PASS · 차단 결함 0 · 보정 요구 0 · 정정 권고 1[LOW·문서만·가격 무영향])

굿즈/파우치는 **첫 게이트부터 GO**(아크릴·실사·문구·책자 GO 동류·디지털 NO-GO와 대조). 5종단 중 **가장 단순한 계산방식(전건 고정가형)·가장 미완성한 라이브(product_prices 0행)**라는 cartographer 지도를 라이브가 전부 확인했다. 핵심 결판 4가지(GP-1 PRODUCT_PRICE 동형·GP-2 (b)formula 그릇·G-GP-3 평탄화 가드·4타입 구간할인)를 라이브로 독립 재실측해 **전부 designer 정확**. 골든 GC-GP1~12 허용오차 0 재현·GC-GP13~15 rate 로직 재현(C열 단가는 dbmap 추출 대상=정직 보류)·평탄화 양면(5500 vs 5000/6000) 독립 재현. 신규 mint 최소(공식 2+comp 2·LINEN_FINISH 선례)·신규 가격축/테이블 0.

| 게이트 | 판정 | 핵심 근거(라이브 실측 2026-06-20) |
|--------|------|------------------------------------|
| E1 공식 추출 충실성 | **PASS** | calc-draft 고정가형 단일유형·4종 구간할인 디테일 byte-verbatim 일치(날조·누락 0)·product_prices 0·formula 0·option_items 0 셀 단위 재대조 |
| E2 구성요소 분해 정합 | **PASS** | GP-1 PRODUCT_PRICE(차원없는 단일가·comp 침입 불가)·GP-2 COMP_GOODS_* 1배선(opt_cd/siz_cd 판별차원)·본체소재 BOM≠가격축·시트경계 SOT 1 준수 |
| E3 경쟁사 흡수 타당성 | **PASS** | 신규 가격축 0·naming(tmpl_price/DIR_MTR/THO_CUT…) 유입 0·자재오염 dbmap 위임 스코프분리 적절·rpmeta GS distinct 부결 정합 |
| E4 엔진 설계 건전성 | **PASS** | PRODUCT_PRICE(:312-317)/FORMULA(:319-326) 경로 코드 확정·opt_cd·siz_cd 둘다 NON_QTY_DIMS(:38)·LINEN_FINISH 선례 실재·`.01` min_qty 가드·평탄화 가드·search-before-mint·채번·FK |
| E5 세트 조합 정합 | **PASS** | t_prd_product_sets 굿즈 0행·세트 레이어 불요 판정 라이브 확정·완제 개당단가(부품 합산 아님)·이중계상 구조적 부재 |
| E6 골든 재현 | **PASS** | GC-GP1~12 **12/12 일치(허용오차 0)**·GC-GP13~15 rate 로직 재현(C열 단가 dbmap 추출=정직 보류)·평탄화 양면 5500↔5000/6000 독립 재현 |
| E7 생성검증 독립성 | **PASS** | 핵심 4결판 라이브 독립 재실측·평탄화 양면 자체 재계산·골든 충실 재구현·dodge/self-approve 없음 |

---

## E1 — 공식 추출 충실성 (cartographer 지도 ↔ 권위 엑셀/라이브 셀 재대조) · **PASS**

**재현 SQL:**
```sql
-- 4종 구간할인 디테일 verbatim
SELECT dsc_tbl_cd, dsc_tbl_nm, dsc_typ_cd, use_yn FROM t_dsc_discount_tables
 WHERE dsc_tbl_cd IN ('DSC_GOODSA_QTY','DSC_GOODSB_QTY','DSC_FABRIC_QTY','DSC_SQUISHY_QTY');
SELECT min_qty,max_qty,dsc_rate FROM t_dsc_discount_details WHERE dsc_tbl_cd='DSC_<X>_QTY' ORDER BY (min_qty)::int;
-- 라이브 완성도
SELECT count(*) FROM t_prd_product_prices       WHERE prd_cd BETWEEN 'PRD_000183' AND 'PRD_000280';  -- 0
SELECT count(*) FROM t_prd_products             WHERE prd_cd BETWEEN 'PRD_000183' AND 'PRD_000280' AND use_yn='Y' AND del_yn='N';  -- 88
SELECT count(*) FROM t_prd_product_price_formulas WHERE prd_cd BETWEEN 'PRD_000183' AND 'PRD_000280';  -- 0
SELECT dsc_tbl_cd,count(*) FROM t_prd_product_discount_tables WHERE prd_cd BETWEEN 'PRD_000183' AND 'PRD_000280' GROUP BY dsc_tbl_cd;
```

| 항목 | 설계 기술 | 라이브 실측 | 판정 |
|------|-----------|-------------|------|
| 계산방식 유형 | calc-draft row 122~123 `[고정가형: 굿즈/파우치] = 고정가 + 수량별구간할인 타입 + 추가상품` | (calc-draft 권위)·면적/원자합산/세트 0건 라이브 확정 | ✓ 단일유형 |
| product_prices(고정가 본체) | 0행 | **0** | ✓ |
| 활성 상품 | 88 | **88** | ✓ |
| formula 바인딩 | 0행 | **0** | ✓ |
| 구간할인 바인딩 | GOODSA15·GOODSB11·FABRIC50·SQUISHY5 = 82(+ACR1) | **GOODSA15·GOODSB11·FABRIC50·SQUISHY5·ACR1** | ✓ |
| 4종 헤더 use_yn·DSC_TYPE.01(정률) | 전건 Y·정률 | **전건 Y·DSC_TYPE.01** | ✓ |
| GOODSA 구간 | 1~49=0·50~99=5·100~499=10·500~999=15·1000~=20 | **byte-동일** | ✓ |
| GOODSB 구간 | 1~99=0·100~499=5·500~=10 | **byte-동일** | ✓ |
| FABRIC 구간 | A타입 동일구조 | **byte-동일** | ✓ |
| SQUISHY 구간 | 1~1=0·2~9=10·10~29=15·30~49=20·50~99=25·100~499=30·500~999=40·1000~=50(8구간) | **byte-동일** | ✓ |

- **날조 0·누락 0.** 4종 구간 디테일 전건 라이브 verbatim과 일치. 라이브 완성도 수치(0/88/0/82)도 전건 일치.
- **v03 인용 차단**: 설계는 상품마스터(260610)+가격표(260527 미사용·굿즈=inline)+라이브만 인용. ✓
- **단가값 출처 정직**: GP-1/GP-2 단가는 상품마스터 C열 verbatim·미표기분(GP-1 ~48상품·FABRIC C열)은 "dbmap C열 전수 추출 대상"으로 명시 보류(designer 창작 0). E6 재현은 표기분 12건으로 충실 재현. ✓
- **LOW 정정 1 (문서·가격 무영향)**: engine-design §0 표는 자재 BOM "**78상품**"이라 기술했으나 formula-map §0·benchmark·라이브 실측은 **76상품**(`SELECT count(DISTINCT prd_cd) … del_yn='N'`=76). 가격축 아님(§5 위임)·결론 불변 → 수치 정밀화 권고.

---

## E2 — 구성요소 분해 정합 (시트 차원경계 SOT 1·완제품/반제품) · **PASS**

- **GP-1 = PRODUCT_PRICE(차원 없는 단일가)**: `t_prd_product_prices`는 `prd_cd·apply_ymd(PK)·unit_price·note` — **차원 컬럼 없음**(라이브 information_schema 확인). 굿즈 단일 고정가(카드거울 2500 단 1가)에 정확히 맞고, 디지털/제본/면적 comp가 **구조적으로 침입 불가**(차원 없는 단일행). 명함식 통합 comp 공식 부결(과설계)이 무손실 표현 근거. ✓
- **GP-2 = COMP_GOODS_* 1배선**: variant축(opt_cd/siz_cd)을 판별차원으로 둔 단가형 comp 1개. comp 1배선·addtn_yn=N → silent 이중합산 구조적 불가. 시트 밖 comp 침입 없음. ✓
- **본체 소재 BOM ≠ 가격축[HARD]**: t_prd_product_materials 76상품(레더/캔버스/타이벡/메쉬·round-22)은 생산 BOM·MES이고 가격은 단일 고정가 inline baked-in. 소재 단가 합산 세트 불요(§7). materials를 가격에 끌어들이지 않음. ✓
- **완제품/반제품 구분 정확**: 굿즈 전건 완제품(GP-1 단일 / GP-2 variant)·명시적 세트 0(라이브 sets 0행·E5). 의미축 이중 인코딩 없음. ✓

---

## E3 — 경쟁사 흡수 타당성 (답습 아닌 흡수·naming 유입·자재오염 위임) · **PASS**

- **신규 가격축 0**: C-GP1~9 전부 후니 기존 그릇(고정가형/합산형 공식·component_prices opt_cd/siz_cd 차원·min_qty 구간·t_dsc 4종) 매핑. 신규 테이블/가격축 0건. rpmeta GS distinct #18 부결·WowPress "6 의미축 흡수"·5종단 누적 결론(신규 축 0)과 정합. ✓
- **naming 유입 0**: `tmpl_price`/`vTmpl_price`/`tiered_price`/`DIR_MTR`/`WRK_MTR`/`PCS_COD`/`THO_CUT`/`PDT_WRK`/`paperinfo`/`papergroup` 등 후니 유입 없음. 후니 `frm_cd`/`comp_cd`/`mat_cd`/`siz_cd`/`opt_cd` 컨벤션만 사용. ✓
- **자재오염 dbmap 위임 = 스코프분리 적절**: 본체 소재/색/형상/구수 오염(.09 74행)·3GAP(SHAPE/COUNT/OPT)은 **가격축 아님**(component_prices 0참조·본체단가에 baked-in) → dbm-axis-staged-load ④자재·ddl-proposer 위임. 가격엔진은 inline 고정가 verbatim만 충전. 이중 작업 회피·경계 명확. ✓ (E3 핵심: 흡수 권고 항목 중 가격축은 C-GP1[고정가형 공식 신설]·C-GP9[수량구간]뿐·나머지는 자재축 데이터 정리=가격엔진 스코프 밖.)
- **개당단가 패러다임 흡수 정합**: 경쟁사가 굿즈를 "본품+가산 합산형"이 아닌 "완제 SKU 개당단가형"으로 계산 → 후니 고정가형(PRODUCT_PRICE·.06 완제품비)이 표현력 동형. 답습(엔진 3분기) 아닌 메커니즘 흡수. ✓

---

## E4 — 엔진 설계 건전성 (evaluate_price 계약·NON_QTY_DIMS·.01·search-before-mint·평탄화 가드) · **PASS**

**pricing.py 코드 직접 검증:**

| 계약 | 코드 라인 | 설계 인용 | 검증 |
|------|-----------|-----------|------|
| 소스 우선순위 TEMPLATE→PRODUCT_PRICE→FORMULA | :290-326 | 정확 | ✓ GP-1=PRODUCT_PRICE(:312-317 `unit_price×qty`)·GP-2=FORMULA(:319-326·PRODUCT_PRICE 부재 시 fallback) |
| frm_typ 미참조(C7) | (frm_typ_cd 컬럼 부재) | 정확 | ✓ |
| 단가형(.01) `unit×qty`·÷min_qty 미발생 | :177-192 | 정확 | ✓ `PRC_TYPE_UNIT`=기본 `up*q`(:191-192)·`.02`만 ÷min_qty·min_qty≤0 시 ValueError(:188) |
| **opt_cd·siz_cd 둘다 NON_QTY_DIMS 정확매칭** | :38-39 | 정확 | ✓ `NON_QTY_DIMS=("siz_cd",…,"opt_cd",…)` — variant 1행 정확매칭(ERR_AMBIGUOUS 회피·:54·:136-138) |
| `_row_matches` 행 차원 NULL=와일드카드 | :78-90 | 정확 | ✓ variant축을 NULL로 비우면 와일드카드化 위험 → 설계 "절대 NULL/와일드카드로 비우지 않음"(G-GP-3) 정확 |
| 수량구간할인 연결 prd_cd→dsc_tbl | :478-504 | 정확 | ✓ `_quantity_discount(eff_prd_cd…)`·pick_discount_detail(:215-226) min≤qty≤max |
| 할인 정률 `amount×(1−rate/100)` | :195-212 | 정확 | ✓ |

**★E4 핵심 결판:**

1. **GP-2 (b)formula 그릇 = LINEN_FINISH 선례 라이브 실재**:
   ```sql
   SELECT comp_cd,comp_typ_cd,prc_typ_cd,use_dims,use_yn,del_yn FROM t_prc_price_components WHERE comp_cd='COMP_POSTEROPT_LINEN_FINISH';
   -- COMP_POSTEROPT_LINEN_FINISH|PRC_COMPONENT_TYPE.06|PRICE_TYPE.01|["opt_cd","min_qty"]|Y|N
   ```
   designer 주장(dbmap round-23 린넨 COMMIT)을 신뢰 없이 직접 SELECT → **use_dims=["opt_cd","min_qty"]·comp_typ .06·prc_typ .01·use_yn=Y·del_yn=N 그릇 실제 작동 중**. opt_cd 차원 comp가 라이브 실재(BANNER_ADD_QBANG도 opt_cd 보유) → **search-before-mint 강하게 충족·vessel-gap 해소·신규 mint=공식2+comp2 뿐·신규 테이블/축 0.** ✓
2. **option_items add_price 컬럼 부재 = (c)DDL안 부결 근거 정확**:
   ```sql
   SELECT column_name FROM information_schema.columns WHERE table_name='t_prd_product_option_items';
   -- prd_cd,opt_cd,item_seq,ref_dim_cd,ref_key1,ref_key2,qty,use_yn,del_yn,del_dt,reg_dt,upd_dt,dtl_opt  (add_price/amt 없음)
   ```
   add_price 컬럼 없음 독립 확인 → (c)option_items add_price 신규 컬럼안은 DDL 필요(과설계) 정확·(b)formula가 엔진 변경 0. ✓
3. **`.01` min_qty 가드 정확**: COMP_GOODS_* `.01`(단가형)이면 `component_subtotal`(:191) `up*q`로 ÷min_qty 미발생 → min_qty NULL이어도 ValueError 없음(아크릴 CLEAR3T `.02`+NULL ValueError와 다름). 설계의 "min_qty=1 명시 권장(일관성)" 정합. ✓
4. **G-GP-3 평탄화 가드 = 돈크리티컬·코드 근거 확정**: variant 행을 `component_prices` 1행씩 + use_dims 판별차원(opt_cd/siz_cd)으로 충전하면 `_row_matches`(:81-86)가 선택 variant 1행만 매칭. 평탄화(단일 unit_price)하면 M 주문에 S/L 단가 오청구. 디지털 인쇄면 silent 합산·실사 면적 좌표축과 동류 가드. E6에서 양면 독립 재현(5500↔5000/6000). ✓
5. **할인 base 0 가드**: `_quantity_discount`(:480) `if not prd_cd or amount<=0: return amount,None` → 현 라이브(product_prices 0)는 base 0 → 할인 skip → **0원·source=NONE**. "현재 가격계산 불가" 결론 코드로 확정. ✓
- **search-before-mint**: GP-1=product_prices INSERT(공식/comp 0)·GP-2=공식 2+comp 2(LINEN_FINISH opt_cd 그릇 재사용)·신규 테이블/가격축 0·t_dsc 4종 재사용(링크만). 라이브 COMP_GOODS_*/PRF_GOODS_* 부존재 확인(미래 mint·기존 clobber 0). ✓
- **채번/FK**: 신규 comp_cd/frm_cd는 `COMP_`/`PRF_` 컨벤션·separator `_`·31상품 2공식 바인딩(상품별 공식 폭발 금지·맛간장 철학). FK 위상(comp→공식 배선→상품 바인딩)·할인 링크 정합. ✓

---

## E5 — 세트(반제품) 조합 정합 (이중계상·구성품 누락·번들 할인) · **PASS**

**재현 SQL:** `SELECT count(*) FROM t_prd_product_sets WHERE prd_cd BETWEEN 'PRD_000183' AND 'PRD_000280';` → **0**

- **세트 레이어 불요 판정 라이브 확정**: 굿즈 t_prd_product_sets **0행** → 명시적 세트(부품 합산) 구조 부재. calc-draft가 굿즈를 세트조합으로 분해하지 않음·디지털 엽서북식 내지+표지 별 SKU 합산 없음·책자 다부품 합산 없음. set-product-design §10 판정(P-7a 완제 개당단가·P-1 다부품 합성 ❌) 정확. ✓
- **이중계상 구조적 부재**: 완제 굿즈=개당 완제품가(GP-1 단일 / GP-2 variant별)·comp 1배선·세트 0 → 부품 합산 자체가 없어 이중계상 불가. 본체 소재/조립(지퍼/끈) BUNDLE은 생산 BOM(가격은 inline baked-in·dbmap 위임). ✓
- **가산항 분리 정직**: 가공(라벨 +300·맥세이프 +6500)·추가상품(잉크 +2500)·색상(동가)은 세트 아닌 §6 가산/옵션. 가공 개당/×수량은 컨펌큐(Q-GP-FIN1·dbm-price-arbiter)로 정직 보류. ✓
- **번들 할인**: 굿즈 구간할인은 변형단가(GP-2)도 variant별 단일 개당가일 뿐 단가 내장 볼륨할인 아님 → DSC_*_QTY 1회 적용이 정상(이중 볼륨할인 위험 부재). ✓

---

## E6 — 골든 재현 (설계 공식으로 실제 재계산·허용오차 0) · **PASS**

**pricing.py 충실 재구현**(PRODUCT_PRICE `unit×qty` / FORMULA `.01 unit×qty` / pick_discount_detail bracket / apply_discount 정률 / round_won). 라이브 4종 구간 verbatim 사용. 전 단계 `recompute-log-goods-pouch.md`.

| GC | 입력 | 할인타입(라이브 확인) | 구간 rate | 재계산 | 골든 | 일치 |
|----|------|----------------------|-----------|--------|------|------|
| **GC-GP1** | 카드거울 2500×1 | DSC_GOODSB ✓ | 1~99=0% | 2,500 | 2,500 | ✓ |
| **GC-GP2** | 틴거울 3000×100 | DSC_GOODSB ✓ | 100~499=5% | 285,000 | 285,000 | ✓ |
| **GC-GP3** | 틴거울 3000×500 | DSC_GOODSB ✓ | 500~=10% | 1,350,000 | 1,350,000 | ✓ |
| **GC-GP4** | 코르크코스터 3000×100 | DSC_GOODSA ✓ | 100~499=10% | 270,000 | 270,000 | ✓ |
| **GC-GP5** | 레더여권케이스 5000×50 | DSC_GOODSA ✓ | 50~99=5% | 237,500 | 237,500 | ✓ |
| **GC-GP6** | 코르크코스터 3000×1000 | DSC_GOODSA ✓ | 1000~=20% | 2,400,000 | 2,400,000 | ✓ |
| **GC-GP7** | 사각손거울 S 5000×1 | DSC_GOODSA ✓ | 1~49=0% | 5,000 | 5,000 | ✓ |
| **GC-GP8** | 사각손거울 M 5500×1 | DSC_GOODSA ✓ | 1~49=0% | 5,500 | 5,500 | ✓ |
| **GC-GP9** | 사각손거울 L 6000×100 | DSC_GOODSA ✓ | 100~499=10% | 540,000 | 540,000 | ✓ |
| **GC-GP10** | 머그 11온스 6500×50 | DSC_GOODSB ✓ | 1~99=0% | 325,000 | 325,000 | ✓ |
| **GC-GP11** | 머그 대용량 7500×100 | DSC_GOODSB ✓ | 100~499=5% | 712,500 | 712,500 | ✓ |
| **GC-GP12** | 벨벳쿠션 양면 16000×10 | DSC_GOODSA ✓ | 1~49=0% | 160,000 | 160,000 | ✓ |
| GC-GP13 | 파우치(FABRIC) C열×100 | DSC_FABRIC ✓ | 100~499=10% | C열×100×0.90 | (식) | rate ✓·단가 보류 |
| GC-GP14 | 메쉬에코백(FABRIC) C열×500 | DSC_FABRIC ✓ | 500~999=15% | C열×500×0.85 | (식) | rate ✓·단가 보류 |
| GC-GP15 | 말랑(SQUISHY) C열×10 | DSC_SQUISHY | 10~29=15% | C열×10×0.85 | (식) | rate ✓·단가 보류 |

- **GC-GP1~12 전건 12/12 일치(허용오차 0).** PRODUCT_PRICE/FORMULA 산식·구간 bracket·정률 할인 라이브 코드 충실.
- **A타입 vs B타입 구간차 입증**: 코르크코스터(A·qty100=10%·270,000) vs 틴거울(B·qty100=5%·285,000) — 같은 100개라도 타입별 다름(굿즈 "타입입력" = 4종 택1·문구 단일 DSC_STAT_QTY와 결정적 차이). ✓
- **GC-GP13~15 = rate 로직 재현 + 단가 정직 보류**: 구간 rate(FABRIC q100=10%·q500=15%·SQUISHY q10=15%) 라이브 verbatim 재현. SQUISHY 소량급할인 입증(qty=10: GOODSA/B/FABRIC=0%·SQUISHY=15% 교차 재계산). C열 단가는 cartographer 미표기(dbmap C열 전수 추출 대상)=designer 정직 보류·날조 아님. ✓
- **★평탄화 양면(G-GP-3·돈크리티컬·NO-GO 입증용) 독립 재현**: 사각손거울 M 주문(qty=1) — 올바른 설계(variant 판별차원) **5,500** ✓ / 잘못된 평탄화(S단가) **5,000** 과소·(L단가) **6,000** 과대. 평탄화가 오청구임 독립 재계산 입증. variant 행별 단가를 component_prices use_dims=[siz_cd/opt_cd]로 충전하면 방지. ✓
- **돈크리티컬 양면(현 라이브 source=NONE)**: GP-1/GP-2 모두 product_prices 0·formula 0 → 현재 source=NONE·0원(가격계산 불가). 진원=고정가 본체 미적재(단가값 결함 아님·C열 verbatim 옳음·구간할인 바인딩 82+디테일 라이브 실재). 골든은 적재 후 기대값. ✓

---

## E7 — 생성-검증 독립성 (self-approve·dodge-hunt·라이브 독립 재실측) · **PASS**

- **핵심 4결판 라이브 독립 재실측**: ① LINEN_FINISH use_dims(designer 주장 신뢰 없이 직접 SELECT) ② option_items add_price 부재(information_schema 직접) ③ 4종 구간 디테일 byte 재대조 ④ 골든 product 식별·할인 바인딩 직접 SELECT. 전건 designer 정확 확인.
- **평탄화 양면 자체 재계산**: GP-2 평탄화 오청구를 designer 골든 신뢰 없이 5500↔5000/6000 직접 재계산해 NO-GO 입증 논리 비준.
- **골든 충실 재구현**: pricing.py 산식(:177-192·:215-226·:195-212·round_won)을 Python으로 충실 재구현해 12건 허용오차 0 독립 산출(설계 재유도 아님).
- **dodge-hunt**: designer가 "C열 미표기·dbmap 추출 대상"·"가공 개당/×수량 컨펌"으로 보류한 것을 정답 위장 아닌 정직 보류로 확인(미확정을 GO로 가리지 않음). 평탄화·돈크리티컬을 명시 가드로 노출. dodge 없음.
- **self-approve 없음**: 설계를 재유도하지 않고 라이브·코드·골든 재계산으로만 판정.

---

## 라이브 freshness (드리프트 점검)

| 객체 | 라이브 실측 | 설계 기술 | 정합 |
|------|-------------|-----------|------|
| product_prices(굿즈) | 0행 | 0행 | ✓ |
| 활성 상품 | 88 | 88 | ✓ |
| formula 바인딩 | 0행 | 0행 | ✓ |
| 구간할인 바인딩 | GOODSA15·GOODSB11·FABRIC50·SQUISHY5(+ACR1) | 동일 | ✓ |
| 4종 구간 디테일 | byte-verbatim | 동일 | ✓ |
| LINEN_FINISH use_dims | ["opt_cd","min_qty"]·.06·.01·Y/N | 동일 | ✓ |
| option_items add_price | 컬럼 부재 | 부재 | ✓ |
| sets(굿즈)/option_items(굿즈) | 0/0 | 0/0 | ✓ |
| 자재 BOM distinct 상품 | **76** | **78**(§0 표) / 76(formula-map) | ⚠ LOW(§0 수치·가격 무영향) |

설계↔라이브 어긋남 0(자재 BOM 수치만 LOW·가격축 아님). 날조 0.

---

## 컨펌큐 (designer 큐 유지 + 검증 보강)

| # | 미해소 | 누가 | 영향 |
|---|--------|------|------|
| Q-GP-FIN1 | ★가공 가산(라벨 +300·맥세이프 +6500) 개당 1회 vs ×수량 — 개당이면 후가공 comp `.01` use_dims=[opt_cd] min_qty=1·1회면 use_dims=[] qty=1 격리(디지털 후가공 ×qty 과청구·아크릴 Q-ACR-FIN1 동일 클래스) | dbm-price-arbiter·실무 | 돈크리티컬 |
| Q-GP-OPT1 | ★GP-2 variant 룩업이 작동하려면 option_items(ref_dim_cd=siz_cd/opt_cd) 적재 선결(현 0행)·미연결 시 0원 침묵 회피용 디폴트 variant 필요 | round-6 dbm-option-mapper | GP-2 가격계산 직결 |
| Q-GP-DSC-TYPE | 상품별 할인타입 바인딩(GOODSA/B·FABRIC·SQUISHY 택1) 권위=상품마스터 "구간할인적용테이블" 컬럼 재대조·FABRIC 카테고리단위 신규 파우치 누락 점검 | dbmap round-1·[[dbmap-discount-authority]] | 4타입 구간 곱·과청구 |
| Q-GP-CFLAT | ★GP-1 미표기 ~48상품 C열·GP-2 FABRIC C열 단가 dbmap 전수 추출(designer 추측 금지) | dbmap C열 추출 | 골든 수치 확정 |
| Q-GP-7 | 폰케이스 기종(Sheet-only·라이브 미등록) 상품 등록 선행(round-24) 후 PRF_GOODS_VARIANT 바인딩 | round-24·실무 | GP-2 확장 |
| CV-GP-MAT(검증 정정) | engine-design §0 자재 BOM "78상품"→라이브 실측 76(formula-map 정합) | designer | LOW·문서만 |

---

## 보정 요구 (재게이트 조건)

**차단 결함(NO-GO) 0건. 보정 요구 없음.** 정정 권고 1(LOW·가격 무영향·designer 폐루프):
- **정정-1(LOW)**: engine-design §0 표 자재 BOM "78상품"→라이브 실측·formula-map 정합 "76상품"으로 수치 정밀화(가격축 아님·결론 불변).

## 라우팅

- **GP-1 product_prices INSERT(C열 verbatim)·GP-2 공식2+comp2+단가행·바인딩·할인 링크 점검** → dbm-price-arbiter 심의 + 인간 승인 후 dbmap(dbm-load-execution·dbm-axis-staged-load). 평탄화 가드(variant 판별차원)·min_qty=1·멱등·백업·undo. 돈크리티컬(평탄화 오청구).
- **Q-GP-FIN1 가공 가산 개당/×수량** → dbm-price-arbiter 심의(추측 적재 금지).
- **Q-GP-OPT1 GP-2 variant option_items 주입** → round-6 dbm-option-mapper(GP-2 가격계산 선결).
- **본체 소재/색/형상/구수 오염 정리(§5)** → dbm-axis-staged-load ④자재·ddl-proposer(가격엔진 스코프 밖·라우팅만).
- **설계 정정-1(LOW)** → designer 폐루프(문서만·가격 무영향).
- **codex 2차(Phase 5.5·굿즈/파우치)** → 오케스트레이터 reconcile(본 판정 독립·codex 비참조).

## DB 미적재 [HARD]

본 검증은 라이브 읽기전용 SELECT만 수행·DB 쓰기 0. 모든 결함 교정(product_prices INSERT·GP-2 공식/comp/단가행·바인딩·할인 링크·자재오염 정리)은 인간 승인 후 dbmap 위임·webadmin 코드 직접수정 금지.
