# A2 — 전체 가격테이블 적재정합 전수 검증 (공통 브리핑)

작성 2026-06-26 · 셋트상품 하네스(§23) 축2. **목적 = 권위 엑셀의 모든 가격데이터가 라이브 `t_prc_*`에 누락0·오류0으로 적재됐고 엔진에서 가격계산이 가능한가**를 상품군 클러스터 단위로 전수 대조. 라이브 읽기전용·DB 미적재·검증+결함 보드까지(교정은 인간 승인).

---

## 권위 원천 (2 엑셀)

1. **인쇄상품 가격표 260527** = `docs/huni/후니프린팅_인쇄상품_가격표_260527.xlsx` (15시트).
   - 추출본 = `_workspace/huni-dbmap/06_extract/` 안의 가격 관련 CSV/JSON:
     - `_price-sheets-extract-summary.json`·`_price-sheets-extract-raw.json` (시트 게이트·셀)
     - `_price-extract-summary.json` (시트별 axis_map: product/price 컬럼 분류)
     - `digital-print-price-*`·`coating-*`·`folding-*`·`import-paper-*`·`import-paper-matrix-long.csv`·`pangeori-*`·`price-acrylic-price-*` 등 `<slug>-l1.csv`
2. **상품마스터 260610** = `docs/huni/후니프린팅_상품마스터_260610.xlsx` (13시트, 5개 (가격포함)).
   - 추출본 = `_workspace/huni-dbmap/24_master-extract-260610/<slug>-l1.csv` (+ `-l1-meta.csv`).
   - (가격포함) 시트 = photobook·design-calendar·stationery·goods-pouch·product-accessory.

**[HARD]** 단가행 값은 권위 verbatim. 라이브 값이 권위와 1원이라도 다르면 결함. 추측 0·날조 0.

---

## 라이브 접속 (읽기전용 SELECT만)

```bash
cd /Users/innojini/Dev/HuniWeb
set -a; source /Users/innojini/Dev/HuniWeb/.env.local 2>/dev/null; set +a
export PGPASSWORD="$RAILWAY_DB_PASSWORD"
psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -At -F'|' -c "SELECT ..." 2>&1 | grep -v -iE 'password'
```
- Bash 호출 시 `dangerouslyDisableSandbox: true` 필요(네트워크). 비밀값 stdout/산출물 비노출. `db railway`·비표준 포트.
- ★앞 명령에서 `cd`로 cwd가 바뀌면 `.env.local` source가 깨지니 **항상 절대경로 source + cwd 복귀**.

---

## 라이브 t_prc_* 구조 (현 실측 2026-06-26 · round-17 기록은 stale)

| 테이블 | 행수 | 의미 |
|---|---|---|
| `t_prc_price_formulas` | **50** | 가격공식(frm_cd·use_yn·note). frm_typ_cd 라이브 부재 |
| `t_prc_formula_components` | **103** | 공식→구성요소 배선(frm_cd·comp_cd·disp_seq·addtn_yn) |
| `t_prc_price_components` | **149** | 구성요소(comp_cd·comp_nm·comp_typ_cd·prc_typ_cd·use_dims jsonb) |
| `t_prc_component_prices` | **7,293** | 단가행(comp_cd·siz_cd·mat_cd·opt_cd·proc_cd·bdl_qty·min_qty·unit_price 등 ~10차원) |
| `t_prd_product_price_formulas` | **78** | 상품→공식 바인딩(prd_cd·frm_cd). **275 상품 중 78 바인딩 = 197 미바인딩** |
| `t_prd_product_prices` (직접단가) | **0** | 전 상품 공식기반(직접단가 경로 없음) |

- `prc_typ_cd`: .01=단가형(unit×qty), .02=합가형. `use_dims`(jsonb)=단가행 매칭에 쓰는 차원키 배열(예 `[siz_cd]`).
- 엔진=`raw/webadmin/webadmin/catalog/pricing.py` `evaluate_price` 단일 권위. `_row_matches`가 use_dims로 단가행 매칭(NON_QTY_DIMS 하드코딩 순회 주의 — DBLPANSU/S1S2 이중합산 결함의 진원).

---

## 라이브 공식 50개 ↔ 상품군 ↔ 바인딩 (검증 분담 기준)

| 클러스터 | 공식(바인딩수) | 대표 단가행 comp(행수) |
|---|---|---|
| **C1 디지털인쇄** | PRF_DGP_A(10)·B(2)·C(3)·D(1)·E(3)·F(1)·NAMECARD_FIXED(3)·ENV_MAKING(1) | DIGITAL_S1/S2(212×2)·별색 SPOT_*(530+53×다수)·가변 VAR(69×2)·PAPER(56) |
| **C2 스티커·합판** | STK_FIXED(13)·STK_PACK(1)·STK_TATTOO(1)·GANGPAN_FIXED(1) | STK_PRINT(2694)·GANGPAN_PRINT(370) |
| **C3 실사/포스터사인** | POSTER_* 31공식(각 1) | BANNER_NORMAL(79)·기타 포스터 comp |
| **C4 아크릴·책자제본·접지** | CLR_ACRYL(1)·COROTTO_ACRYL(0)·BIND_SUM(4)·FOLD_SUM(1)·PHOTOCARD_CLEAR(1)·NORMAL(1)·PHOTOCARD_FIXED(0,use_yn=N) | ACRYL_CLEAR3T(165)·코팅 COAT_MATTE(92) |
| **C5 고정가 셋트(엽서북·떡메)** | PCB_FIXED(1)·TTEOKME_FIXED(1) | PCB_*(117×4)·TTEOKME(112) |
| **C6 미바인딩 (가격포함)·root cause** | 바인딩 0/희소 — 포토북·디자인캘린더·문구·굿즈파우치·상품악세사리·캘린더·MAP | 해당 상품군이 라이브에 공식·단가행 자체가 없는지 |

바인딩 0 공식 = COROTTO_ACRYL·POSTER_FIXED·PHOTOCARD_FIXED(use_yn=N). C4/C3에서 사유 규명.

---

## 검증 3축 (각 클러스터 공통)

1. **단가행 값 정합** — 권위 시트의 가격 셀(차원조합×단가) ↔ 라이브 `t_prc_component_prices` 행. 행수 일치·차원조합 누락0·**단가값 verbatim**. 누락/오류/중복/잉여 집계.
2. **배선 정합** — 공식→`formula_components`→`price_components`(use_dims·prc_typ)가 권위 가격공식 의도대로인가. 끊긴 배선·고아 comp·prc_typ 오적재.
3. **바인딩 정합 + 미바인딩 root cause** — 권위에 가격이 있는 상품이 라이브에서 공식 바인딩됐나. 미바인딩이면 사유(공식 미설계 / 단가행 미적재 / use_yn=N / 고아)를 분류.

---

## 산출 (각 클러스터)

`_workspace/huni-set-product/06_load/a2-price-conformance/`:
- `<cluster>-conformance.md` — 검증 서술(권위↔라이브 대조·3축 결과·GO/PARTIAL/NO-GO 판정·재현 쿼리)
- `<cluster>-defect-board.csv` — 결함 1건1행: `id,axis,product_or_formula,authority_value,live_value,defect_type(MISSING/WRONG/DUP/EXTRA/UNBOUND),severity(HIGH/MED/LOW),root_cause,fix_route,evidence`

결함이 없으면 "정합 GO"로 명시. 돈크리티컬(단가값 오류·이중합산·미바인딩으로 견적불가)은 HIGH. 생성≠검증 원칙 — 모든 주장은 라이브 쿼리/권위 셀 근거.
