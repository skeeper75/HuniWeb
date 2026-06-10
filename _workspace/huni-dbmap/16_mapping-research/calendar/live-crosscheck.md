# 캘린더 + 디자인캘린더 — 라이브 실측 대조 (round-12 P3)

> **작성** 2026-06-10 · round-12. 읽기전용 SELECT만(INSERT/UPDATE/DDL 0). 비밀값 비노출. 재현 가능한 쿼리·결과 요약. `mapping-final.md` 우변(코드값·FK·행 존재/미적재)의 권위.
>
> **접속:** `set -a; source .env.local; set +a; PGPASSWORD="$RAILWAY_DB_PASSWORD" psql -h "$RAILWAY_DB_HOST" -p "$RAILWAY_DB_PORT" -U "$RAILWAY_DB_USER" -d "$RAILWAY_DB_NAME" -tAc "..."`

---

## 1. 캘린더 5 form factor 상품 (라이브 존재 + 속성)

```sql
SELECT prd_cd, "MES_ITEM_CD", prd_nm, prd_typ_cd, file_upload_yn, editor_yn,
       min_qty, max_qty, qty_incr, qty_unit_typ_cd
FROM t_prd_products WHERE prd_nm LIKE '%캘린더%';
```
| prd_cd | MES_ITEM_CD | prd_nm | prd_typ_cd | qty_unit |
|--------|:-----------:|--------|-----------|----------|
| PRD_000108 | **NULL** | 탁상형캘린더 | **PRD_TYPE.04** | QTY_UNIT.01(EA) |
| PRD_000109 | NULL | 미니탁상형캘린더 | PRD_TYPE.04 | — |
| PRD_000110 | NULL | 엽서캘린더 | PRD_TYPE.04 | — |
| PRD_000111 | NULL | 벽걸이캘린더 | PRD_TYPE.04 | — |
| PRD_000112 | NULL | 와이드벽걸이캘린더 | PRD_TYPE.04 | — |
| PRD_000005 | 012-0008 | 캘린더봉투 | **PRD_TYPE.03**(기성상품) | — |

**판정:** ① 5 form factor 적재됨(round-11 정합) ② **MES_ITEM_CD 전부 NULL**(엑셀 007-* 미반영=업데이트 대상) ③ **전부 PRD_TYPE.04 디자인상품** → 디자인캘린더가 별 상품 아님(CL-1 해소·Q6 정합) ④ 봉투=별 상품(addon 대상).

## 2. 9속성 하위 적재 상태 (5상품)

```sql
SELECT count(*) FROM t_prd_product_<child> WHERE prd_cd='PRD_000xxx';
```
| 상품 | sizes | materials | print_opt | plate | proc | page_rule | opt_grp/opt/item | addons | prices | formulas | cat |
|------|:----:|:--------:|:---------:|:----:|:---:|:--------:|:----------------:|:-----:|:------:|:--------:|:--:|
| 108 탁상 | 2 | 10 | 1 | 1 | 1 | **0** | **0/0/0** | **0** | **0** | **0** | 1 |
| 109 미니 | 2 | 9 | 1 | 1 | 1 | 0 | 0/0/0 | 0 | 0 | 0 | 1 |
| 110 엽서 | 6 | 10 | 1 | 1 | 1 | 0 | 0/0/0 | 0 | 0 | 0 | 1 |
| 111 벽걸이 | 3 | 23 | 2 | 1 | 2 | 0 | 0/0/0 | 0 | 0 | 0 | 1 |
| 112 와이드 | 1 | 4 | 2 | 1 | 1 | 0 | 0/0/0 | 0 | 0 | 0 | 1 |

**판정:** sizes·materials·print_options·plate_sizes·processes·categories = **적재됨**. page_rules·option_*·addons·prices·formulas = **0(미적재)** → 장수·CPQ·봉투/거치대·가격 = 적재 대상. option_* 0 = OM-6(CPQ 전면 미적재) 정합.

## 3. 코드값 권위 (upr_cod_cd 기반)

```sql
SELECT cod_cd, cod_nm FROM t_cod_base_codes WHERE upr_cod_cd='<GRP>' ORDER BY disp_seq;
```
| 그룹 | 코드값 |
|------|--------|
| OUTPUT_PAPER_TYPE | **.01 국전계열 · .02 46계열 · .03 기타** |
| SEL_TYPE | .01 단일 · .02 다중 |
| PRD_TYPE | .01 완제품 · .02 반제품 · .03 기성상품 · **.04 디자인상품** · .05 추가상품 |
| QTY_UNIT | .01 EA · .02 매 · .03 권 · .04 세트 · .05 팩 |
| USAGE | .01 내지 · .02 표지 · .03 면지 · .04 간지 · .05 투명커버 · .06 표지타입 · **.07 공통** |

**★정정 2건(round-11 인용 오류):**
- **OUTPUT_PAPER_TYPE 코드값 = 계열**(국전/46/기타), round-11이 인용한 "316x467/330x660"은 **치수**(코드 아님). 캘린더 plate=`.01 국전계열`, 와이드=`.03 기타`(아래 실측).
- **USAGE.07=공통**(USAGE.01=내지). round-11이 캘린더 종이를 "USAGE.01 본체"로 인용 → 라이브 실측은 **USAGE.07 공통**(§4).

## 4. plate_sizes + materials usage + processes 실측

```sql
SELECT prd_cd, output_paper_typ_cd FROM t_prd_product_plate_sizes WHERE prd_cd IN ('PRD_000108','PRD_000111','PRD_000112');
SELECT usage_cd, count(*) FROM t_prd_product_materials WHERE prd_cd='PRD_000111' GROUP BY usage_cd;
SELECT pp.proc_cd, p.proc_nm, pp.mand_proc_yn FROM t_prd_product_processes pp JOIN t_proc_processes p ON pp.proc_cd=p.proc_cd WHERE pp.prd_cd='PRD_000111';
```
| 항목 | 결과 |
|------|------|
| plate (108 탁상·111 벽걸이) | `OUTPUT_PAPER_TYPE.01`(국전계열) |
| plate (112 와이드) | `OUTPUT_PAPER_TYPE.03`(기타) — 3절 → .03 정합 |
| materials usage (벽걸이 23행) | **전부 USAGE.07(공통)** ★ |
| processes (벽걸이) | `PROC_000079 타공`(mand=**N**) · `PROC_000021 트윈링제본`(mand=N) |
| print_options (탁상) | `print_side='양면'`(자유텍스트·코드 아님) |

**판정:** ① 출력판형 코드 정합(국전/기타) ② **종이=USAGE.07 공통**(round-11 .01 오류 정정) ③ 트윈링제본=PROC_000021·타공=PROC_000079(round-11 BOM 정합) — 단 **mand_proc_yn=N**(round-11이 mand=Y 인용 → 불일치, §6 CONFLICT).

## 5. 사이즈 변형 커버리지 (엽서캘린더 — D-1 교훈)

```sql
SELECT s.siz_cd, s.siz_nm FROM t_prd_product_sizes ps JOIN t_siz_sizes s ON ps.siz_cd=s.siz_cd WHERE ps.prd_cd='PRD_000110';
```
| siz_cd | siz_nm | 엑셀 distinct 대조 |
|--------|--------|-------------------|
| SIZ_000069 | 220x145 | ✓ |
| SIZ_000070 | 130x220 | ✓ |
| SIZ_000072 | 145x145 | ✓ |
| SIZ_000073 | 220x130 | ✓ |
| SIZ_000074 | 145x300 | ✓ |
| **SIZ_000007** | **148x210** | ✗ 엑셀 캘린더 distinct에 없음 |

**판정:** 라이브 6종 적재. SIZ_000007(148x210)이 엑셀 캘린더 시트 distinct(145x145·145x300·130x220·220x145·220x130)에 부재 — **변형 커버리지 1종 불일치**. LOADED=행존재만(D-1)이 아니라 셀단위 대조는 round-4 적재 audit에서. 본 round=매핑 확정까지 → 🟡 flag.

## 6. 라이브↔round-11 불일치 (CONFLICT)

| # | 항목 | round-11 인용 | **라이브 실측(권위)** | 처분 |
|---|------|---------------|----------------------|------|
| X-1 | 캘린더 종이 usage | USAGE.01 본체 | **USAGE.07 공통** | mapping-final §A C15 정정(라이브 권위) |
| X-2 | 출력판형 코드값 | 316x467/330x660 | **계열 코드 .01/.03**(치수는 별도) | mapping-final §A C9 정정 |
| X-3 | excl_groups 테이블 | `t_prd_product_process_excl_groups`(/_prd_process_excl_groups) | **테이블 부재** → `t_prd_product_option_groups`로 흡수(GRP-CAL-가공·SEL_TYPE.01) | mapping-final §A C19 정정(schema-intent L366 정합) |
| X-4 | 트윈링제본 mand_proc_yn | mand=Y(필수) | **mand=N**(벽걸이 PROC_000021·PROC_000079 둘 다 N) | mapping-final §A C19 비고 — 캘린더가공=택일(필수공정 아님) 정합. 라이브 권위 |
| X-5 | MES_ITEM_CD | 007-0001~5(적재 가정) | **NULL(미적재)** | mapping-final §A C3 = 업데이트 대상 |

## 7. 디자인 templates 실측

```sql
SELECT tmpl_cd, base_prd_cd, tmpl_nm FROM t_prd_templates WHERE base_prd_cd IN ('PRD_000108'..'PRD_000112');
```
**결과: 0행.** 캘린더 5상품의 에디터 디자인 템플릿(Q6) 미적재 → 적재 대상(round-6/CPQ 또는 에디터 연계).

---

## 재현 노트
- 모든 쿼리 읽기전용 SELECT. 쓰기 0. 비밀값은 `.env.local` 환경변수로만 주입, 본 문서·stdout 비노출.
- `t_cod_base_codes`는 `cod_grp_cd` 없음 — 코드 그룹은 `upr_cod_cd`(상위코드)로 표현. `t_prd_product_process_excl_groups`/`t_prd_process_excl_groups` 테이블 부재(option_groups 흡수).
