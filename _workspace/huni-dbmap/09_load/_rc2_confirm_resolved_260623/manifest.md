# manifest.md — RC-2 CONFIRM 확정 3건 적재본 (린넨마감·타공 데이터·족자)

> dbm-load-builder · 2026-06-23 · §21 RC-2. **DB 미적재** — 멱등 SQL + 롤백전용 DRY-RUN까지.
> 입력 명세 = `_workspace/huni-catalog-conformance/03_cpq_link/rc2-confirm-resolved-load-spec.md`.
> 권위[HARD]: silsa-l1(260610) · 라이브 t_prc_component_prices verbatim. 단가 전부 verbatim(0 변경).
> ★**각목(CONFIRM-4)=범위 밖·일절 미접촉**. 기초코드 마스터(t_siz/t_mat/proc) 불변.
> ★생성자(load-builder)≠검증자. 실 COMMIT은 dbm-validator R1~R6 GO + 인간 승인 후 hbd-load-executor.
> 라이브 재실측 일시 = 2026-06-23 (psql 읽기전용 SELECT — 명세 주장 직접 재확인·전건 일치).

---

## 0. 적재 전 라이브 재실측 — 명세 주장 검증 (전건 일치·불일치 0)

| # | 명세 주장 | 라이브 실측 결과 | 일치 |
|---|---|---|---|
| 1 | opt_cd MAX=OPV_000430·OPV_000431 충돌 0 | MAX=OPV_000430·count(OPV_000431)=0 | ✅ |
| 2 | 린넨 LINEN_FINISH 5행 opt_cd 124 정합·proc=PROC_000080·use_dims `["opt_cd","min_qty"]` | id 22341~22345 opt_cd=OPV_000025/OPV-000024/OPV_000026/OPV_000424/OPV_000027·proc PROC_000080·단가 0/800/1000/2000/2000 | ✅ |
| 3 | 124=PRF_POSTER_LINEN·LINEN_FINISH 바인딩 0·기존 MAX disp_seq=1 | PRF_POSTER_LINEN(disp_seq=1 COMP_POSTER_LINEN_FABRIC만)·LINEN_FINISH 바인딩 0 | ✅ |
| 4 | 일반 PUNCH_4 3행 proc=PROC_000105·dim_vals{4/6/8}=3000/4000/8000 | id 38219/38220/38221 proc=PROC_000105·{타공수:4/6/8}·3000/4000/8000 | ✅ |
| 5 | 일반 PUNCH_4 이미 PRF_POSTER_BANNER_N disp_seq=2 바인딩 | 바인딩 실재(disp_seq=2) — 추가 불요 | ✅ |
| 6 | 일반 좀비 PUNCH_6/8 del_yn=Y·use_dims=[] | id 4695/4697 del_yn=Y·use_dims=[] | ✅ |
| 7 | 메쉬 PUNCH_4/6/8 3 comp 각 1행·proc NULL·dim_vals NULL·3000/4000/5000 | id 4750/4752/4754 proc NULL·dim_vals NULL·3000/4000/5000·del_yn=N | ✅ |
| 8 | 메쉬 use_dims PUNCH_4/8=[]·PUNCH_6=`[...,proc_grp:PROC_000080]` | 실측 일치 | ✅ |
| 9 | 메쉬 PRF_POSTER_BANNER_M 바인딩=본체+QBANG+STRING(MAX disp_seq=3)·타공 0 | disp_seq 1/2/3·타공 미바인딩 | ✅ |
| 10 | 족자 천정고리 1행 id 4594·bdl_qty=2·6500·use_dims `["bdl_qty","min_qty"]`·바인딩 0 | 실측 일치 | ✅ |
| 11 | 135=PRF_POSTER_JOKJA(disp_seq=1)·OPT_000016 추가(SEL_TYPE.01·min0/max1·mand_yn=N·disp_seq=2·옵션 OPV_000035만·기존 옵션 MAX disp_seq=1) | 실측 일치 | ✅ |
| 12 | proc 마스터: PROC_000104(부모 del_yn=N)·PROC_000105(자식·del_yn=N)·PROC_000079(부모 del_yn=N)·PROC_000103(좀비 del_yn=Y) | 실측 일치 | ✅ |
| 13 | FK `fk_comp_prices_proc` proc_cd→t_proc_processes; opt_cd FK 없음 | 실측 일치(104/079 실재 → proc UPDATE FK 안전) | ✅ |

**불일치 0 — 명세 주장 전건 라이브 검증 통과. 중단 사유 없음.**

---

## 1. 적재 순서 (FK 위상정렬·단일 트랜잭션)

```
apply.sql  (BEGIN … ROLLBACK[기본]/COMMIT[--commit·인간승인])
 ├ 01_options.sql           t_prd_product_options       옵션 선행(부모 그룹 OPT_000016 실재)
 ├ 02_use_dims.sql          t_prc_price_components       comp use_dims 충전/재배선
 ├ 03_price_fill.sql        t_prc_component_prices       단가행 판별값 충전/재배선(verbatim)
 ├ 04_formula_components.sql t_prc_formula_components     공식 바인딩(부모 frm/comp 실재)
 └ 05_zombie_cleanup.sql    t_prc_price_components       좀비 use_yn=N
```
FK 안전: opt_cd 충전(03)은 opt FK 없음이나 CPQ 정합상 옵션(01) 선행. proc_cd 충전(03)은 PROC_000104/079 실재 → `fk_comp_prices_proc` 만족. 바인딩(04)은 부모 frm_cd(PRF_*)·comp_cd 실재.

## 2. 전 행 1:1 — 현재값 ↔ 설계값 (단가 verbatim·날조 0)

### 2.1 CONFIRM-B 린넨마감 (124) — 바인딩 1건만 (재배선 0)
| step | 테이블 | 키 | 현재값 | 설계값 | 멱등 가드 |
|---|---|---|---|---|---|
| 04 | formula_components | PRF_POSTER_LINEN, COMP_POSTEROPT_LINEN_FINISH | 부재 | addtn_yn=Y·disp_seq=2 | NOT EXISTS |

> 단가행/use_dims 충전 0(이미 정합). LINEN_FINISH 5행 단가 0/800/1000/2000/2000 verbatim 불변.

### 2.2 CONFIRM-A 타공 데이터 (138/139)
| step | 테이블 | 키(id) | 현재값 | 설계값 | 멱등 가드 | 단가 verbatim |
|---|---|---|---|---|---|---|
| 03 | component_prices | 38219 | proc=PROC_000105 | proc=PROC_000104 | unit_price=3000 + IS DISTINCT FROM | 3000 |
| 03 | component_prices | 38220 | proc=PROC_000105 | proc=PROC_000104 | unit_price=4000 + IS DISTINCT FROM | 4000 |
| 03 | component_prices | 38221 | proc=PROC_000105 | proc=PROC_000104 | unit_price=8000 + IS DISTINCT FROM | 8000 |
| 02 | price_components | MESH_PUNCH_4 | use_dims=[] | `["proc_cd","min_qty","proc_grp:PROC_000079"]` | IS DISTINCT FROM | — |
| 02 | price_components | MESH_PUNCH_6 | proc_grp:PROC_000080 | proc_grp:PROC_000079 | IS DISTINCT FROM | — |
| 02 | price_components | MESH_PUNCH_8 | use_dims=[] | `["proc_cd","min_qty","proc_grp:PROC_000079"]` | IS DISTINCT FROM | — |
| 03 | component_prices | 4750 | proc=NULL·dim_vals=NULL | proc=PROC_000079·{타공수:4} | unit_price=3000 + IS DISTINCT FROM | 3000 |
| 03 | component_prices | 4752 | proc=NULL·dim_vals=NULL | proc=PROC_000079·{타공수:6} | unit_price=4000 + IS DISTINCT FROM | 4000 |
| 03 | component_prices | 4754 | proc=NULL·dim_vals=NULL | proc=PROC_000079·{타공수:8} | unit_price=5000 + IS DISTINCT FROM | 5000 |
| 04 | formula_components | PRF_POSTER_BANNER_M, MESH_PUNCH_4 | 부재 | addtn_yn=Y·disp_seq=4 | NOT EXISTS | — |
| 04 | formula_components | PRF_POSTER_BANNER_M, MESH_PUNCH_6 | 부재 | addtn_yn=Y·disp_seq=5 | NOT EXISTS | — |
| 04 | formula_components | PRF_POSTER_BANNER_M, MESH_PUNCH_8 | 부재 | addtn_yn=Y·disp_seq=6 | NOT EXISTS | — |
| 05 | price_components | NORMAL_PUNCH_6 (4695) | use_yn=Y·del_yn=Y | use_yn=N | del_yn=Y guard + IS DISTINCT FROM | — |
| 05 | price_components | NORMAL_PUNCH_8 (4697) | use_yn=Y·del_yn=Y | use_yn=N | del_yn=Y guard + IS DISTINCT FROM | — |

> 일반 PUNCH_4 바인딩=이미 disp_seq=2(추가 0). 일반 PUNCH_4 use_dims=이미 정합(충전 0).

### 2.3 CONFIRM-C 족자 (135)
| step | 테이블 | 키(id) | 현재값 | 설계값 | 멱등 가드 |
|---|---|---|---|---|---|
| 01 | product_options | PRD_000135, OPV_000431 | 부재 | OPT_000016·천정형고리 포함·disp_seq=2·dflt=N·use=Y | NOT EXISTS |
| 02 | price_components | JOKJA_CEILHOOK | use_dims=`["bdl_qty","min_qty"]` | `["opt_cd","min_qty"]` | IS DISTINCT FROM |
| 03 | component_prices | 4594 | bdl_qty=2·opt=NULL·6500 | bdl_qty=NULL·opt=OPV_000431 | unit_price=6500 + IS DISTINCT FROM |
| 04 | formula_components | PRF_POSTER_JOKJA, JOKJA_CEILHOOK | 부재 | addtn_yn=Y·disp_seq=2 | NOT EXISTS |

> opt_nm="천정형고리 포함" = 권위 엑셀 verbatim. 6500 verbatim(HOLD-C-PRICE: 권위 "4000?" 미확정 — 별 결정).

## 3. 멱등성

- **UPDATE**: 전부 `IS DISTINCT FROM`(또는 OR 조합) 가드 → 동일값 재실행 시 0행. 단가행 UPDATE는 `unit_price=<검증값>` 추가 가드(verbatim 검증·불일치 시 0행).
- **INSERT**: 전부 `WHERE NOT EXISTS`(PK 기준) → 존재 시 0행.
- **2-pass 실증**: PASS1=19행·PASS2=전부 0행 (dryrun-result.md §R1).
- reg_dt = DEFAULT now() (옵션·바인딩 INSERT). apply_ymd 분기 없음(단가행 적용일 미생성 — 이중계상 함정 없음).

## 4. 범위 밖·HOLD (정직 표기)
- ★**각목(CONFIRM-4)**: GAKMOK comp/단가행/옵션 0건 변경(미접촉).
- **HOLD-125**(캔버스패브릭 마감비): 비동형·단가 부재 → 미적재.
- **HOLD-C-PRICE**(족자 6500 vs 권위 4000?): 6500 verbatim·실무 확정 필요.
- **HOLD-C-ITEM**(족자 천정고리 자재 MAT_000215 135 미등록): option_item 환원 HOLD(가격 무영향).
- **타공 코드 트랙**: 타공수별 가산은 위젯 코드 동반 후 작동. 데이터 트랙=미선택 0가산(always-add 제거)까지 보장.
