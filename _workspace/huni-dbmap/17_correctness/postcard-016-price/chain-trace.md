# A. 프리미엄엽서(PRD_000016) 가격사슬 라이브 실측 — chain-trace

> 작성 2026-06-15 · round-13 라이브 정합 교정 · `dbm-correctness-audit`.
> **읽기전용 SELECT만** 사용(쓰기·COMMIT·DDL 0). 라이브 = 피고(교정 대상), 가격표 엑셀 = 판관(정답 권위).
> 모든 값은 2026-06-15 라이브 실측 + 가격표 셀 인용. 추측 0.

## 0. 사슬 개요 (재현 SELECT)

```sql
-- 상품→공식 바인딩
SELECT prd_cd, frm_cd, apply_bgn_ymd FROM t_prd_product_price_formulas WHERE prd_cd='PRD_000016';
--   PRD_000016 | PRF_DGP_A | 2026-06-01

-- 공식 헤더
SELECT frm_cd, frm_nm, note FROM t_prc_price_formulas WHERE frm_cd='PRF_DGP_A';
--   PRF_DGP_A | 디지털인쇄 원자합산형A 엽서·상품권·슬로건 | 인쇄비+코팅비+용지비+후가공비+추가상품을 더해 판매가 계산...

-- 공식→구성요소 배선
SELECT fc.disp_seq, fc.comp_cd, fc.addtn_yn, pc.comp_nm, pc.comp_typ_cd, pc.prc_typ_cd, pc.use_dims
FROM t_prc_formula_components fc JOIN t_prc_price_components pc ON fc.comp_cd=pc.comp_cd
WHERE fc.frm_cd='PRF_DGP_A' ORDER BY fc.disp_seq;
```

PRF_DGP_A에 **29개 구성요소가 전부 배선**(disp_seq 1~29). 사용자 우려 8종 모두 배선 존재 — **누락 없음**.

## 1. 사용자 우려 8종 구성요소 배선·메타·단가행 실측

| # | 구성요소 | comp_cd | comp_typ_cd | prc_typ_cd | use_dims | 단가행수 | 배선 |
|---|----------|---------|:--:|:--:|----------|:--:|:--:|
| 1 | 디지털인쇄비(단면) | COMP_PRINT_DIGITAL_S1 | .01 인쇄비 | **PRICE_TYPE.01 단가형** | siz_cd·clr_cd·min_qty | 212 | ✅ |
| 1' | 디지털인쇄비(양면) | COMP_PRINT_DIGITAL_S2 | .01 | PRICE_TYPE.01 | siz_cd·clr_cd·min_qty | 212 | ✅ |
| 2 | 별색인쇄비 화이트(단/양면) | COMP_PRINT_SPOT_WHITE_S1/S2 | .01 | PRICE_TYPE.01 | siz_cd·min_qty | 53/53 | ✅ |
| 2' | 별색인쇄비 클리어(단/양면) | COMP_PRINT_SPOT_CLEAR_S1/S2 | .01 | PRICE_TYPE.01 | siz_cd·min_qty | 53/53 | ✅ |
| 2'' | 별색 핑크/금/은(단/양면) | COMP_PRINT_SPOT_PINK/GOLD/SILVER_*  | .01 | PRICE_TYPE.01 | siz_cd·min_qty | (배선됨) | ✅ |
| 3 | 유광코팅비 | COMP_COAT_GLOSSY | .02 코팅비 | PRICE_TYPE.01 | siz_cd·coat_side_cnt·min_qty | 92 | ✅ |
| 4 | 무광코팅비 | COMP_COAT_MATTE | .02 | PRICE_TYPE.01 | siz_cd·coat_side_cnt·min_qty | 92 | ✅ |
| 5 | 오시 1/2/3줄 | COMP_PP_CREASE_1L/2L/3L | .04 후가공비 | **PRICE_TYPE.01 단가형** | min_qty | 10 each | ✅ |
| 6 | 미싱 1/2/3줄 | COMP_PP_PERF_1L/2L/3L | .04 | **PRICE_TYPE.01** | min_qty | 10 each | ✅ |
| 7 | 가변텍스트 1/2/3개 | COMP_PP_VARTEXT_1/2/3EA | .04 | **PRICE_TYPE.01** | min_qty | 23 each | ✅ |
| 8 | 가변이미지 1/2/3개 | COMP_PP_VARIMG_1/2/3EA | .04 | **PRICE_TYPE.01** | min_qty | 23 each | ✅ |

(추가 배선: COMP_PAPER 용지비 56행 / COMP_PP_CORNER_RIGHT·CORNER_ROUND 모서리 9행 each)

## 2. 단가행 축 정의 (note 실측으로 확인 — 결정적 단서)

라이브 component_prices.note가 **축 의미를 명시**한다. 두 부류로 갈린다:

| 부류 | 구성요소 | note의 min_qty 의미 | 가격 성격(note 명시) |
|------|----------|---------------------|---------------------|
| **출력축** | 디지털인쇄비·별색·코팅 | `출력매수≥N` | 단가(장당) — `[siz-corrected ...] 디지털인쇄 출력비(국4절)/.../단면 출력매수≥N` |
| **주문축** | 오시·미싱·가변텍스트·가변이미지·둥근모서리 | `제작수량≥N` | `합가` — `오시/1줄 제작수량≥N (합가, comp_typ=.04 후가공비, 옵션=comp흡수)` |

→ **두 부류의 min_qty가 다른 축**(출력매수 vs 주문수량). 그런데 **prc_typ_cd는 둘 다 PRICE_TYPE.01(단가형)으로 동일**하게 적재돼 있다. 이것이 §C 근본원인 분석의 핵심.

## 3. 단가행 값 실측 표본 (가격표 대조는 price-table-diff.md)

```sql
-- 디지털인쇄비 국4절(SIZ_000499)/흑백(CLR_000002)/단면
min_qty=1→3000 / 10→500 / 100→200 / 1000000→40
-- 별색 화이트 국4절/단면 (clr_cd=NULL, siz 차원만)
min_qty=1→3000 / 10→1400 / 100→800 / 500→460 / 1000000→300
-- 유광코팅 3절(SIZ_000077)/coat_side_cnt=1(단면)
min_qty=1→3000 / 10→1500 / 100→750 / 1000000→150
-- 오시 1줄 (siz_cd=NULL, min_qty축만)
min_qty=1→5000 / 50→5000 / 100→10000 / 300→15000 / 1000→25000 / 5000→105000
-- 가변텍스트 1개
min_qty=1→15000 / 100→15000 / 600→20000 / 1000→25000 / 9500→160000
-- 둥근모서리
min_qty=1→2000 / 300→4000 / 1000→11000 / 5000→51000
-- 직각모서리: 전구간 0.00
```

## 4. 적재 경로 (loadlogic) — 요약

- `raw/webadmin/tools/load_master.py`는 **t_prc_* 가격을 적재하지 않는다**(grep: `t_prc_`·`component_prices` 0건). load_master = 상품마스터(t_prd/t_mat/t_proc) 전용.
- 이 가격 단가행은 **round-2 가격엔진 트랙 + 디지털인쇄 가격엔진 트랙**(huni-dbmap 자체 적재)이 넣었다. note에 `round-2 파일럿 자동생성` 명시.
- 즉 사용자가 우려한 "webadmin이 v03 마이그레이션으로 잘못 넣었다"는 **이 가격 영역엔 해당 없음** — 가격 단가행은 우리(huni-dbmap)가 가격표에서 직접 추출·적재한 것이다. 상세는 loadlogic-notes.md.
