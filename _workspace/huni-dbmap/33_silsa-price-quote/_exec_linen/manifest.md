# 린넨패브릭포스터 마감가공 옵션 등록 — 실행본 manifest (round-23)

> 작성 2026-06-17 · `dbm-load-builder`. arbiter 정립 = `linen-finishing-options.md`(L1~L5).
> 대상 = **PRD_000124 린넨패브릭포스터** · 가공 5택1(OPT_000009 그룹) · 단가 verbatim(0/800/1000/2000/2000).
> **DB 미적재 — 롤백전용 DRY-RUN GO 까지. 실 COMMIT 은 인간 최종 승인.**

## 1. 실측 정정 (spec ↔ 라이브 divergence·search-before-mint)

| 항목 | spec 가정 | 라이브 실측 | 조치 |
|------|----------|------------|------|
| 오버로크+리본끈 | 신규 OPV(OPV_000028) | **OPV-000024 이미 존재**(하이픈·disp4·item/단가 없음) | **재사용**(중복 mint 금지)·item+단가만 추가 |
| 말아박기+면끈 | 신규 OPV(OPV_000029) | 부재 | 신규 mint **OPV_000424**(우세 `OPV_` 시리즈 max=OPV_000423 → +1·밑줄 컨벤션) |
| 오버로크/말아박기/봉미싱 | 기존 OPV_000025/26/27 | 확인 | 재사용·mint 0 |
| 봉제 PROC_000080 | 재사용 | PRD_000124 product_processes 에 실재(trigger 통과) | 재사용·proc mint 0 |
| 리본끈/면끈 자재 | 통가 포함 | 전용 자재 부재 | 별 자재 mint 0(복합 단가 통가) |

> spec 의 OPV_000028/29 채번을 그대로 따랐다면 ① OPV-000024 와 의미 중복(오버로크+리본끈 2벌) ② 밑줄/하이픈 혼재. 라이브 실측으로 교정.

## 2. 단위·영향행수 (PASS1 실측·FK 위상순)

| 단위 | 테이블 | 조치 | 행수 | 멱등키 |
|------|--------|------|:--:|--------|
| **L1** | t_prd_product_options | 말아박기+면끈 OPV_000424 신규(오버로크+리본끈은 기존 OPV-000024 → skip) | **INSERT 1** | (prd_cd,opt_cd) NOT EXISTS |
| **L1b** | t_prd_product_option_items | 복합 2(OPV-000024·OPV_000424) item·OPT_REF_DIM.04→PROC_000080 | **INSERT 2** | (prd_cd,opt_cd,item_seq) NOT EXISTS |
| **L2** | t_prc_price_components | COMP_POSTEROPT_LINEN_FINISH(.01·use_dims `["opt_cd"]`·PRC_COMPONENT_TYPE.06) | **INSERT 1** | comp_cd NOT EXISTS |
| **L3** | t_prc_component_prices | 단가행 5(opt_cd별 0/800/1000/2000/2000·proc_cd PROC_000080·apply_ymd 2026-06-01) | **INSERT 5** | (comp_cd,apply_ymd,opt_cd) NOT EXISTS |
| **L4** | t_prc_formula_components | PRF_POSTER_LINEN ← COMP_POSTEROPT_LINEN_FINISH disp_seq10 addtn_yn=Y | **INSERT 1** | (frm_cd,comp_cd) NOT EXISTS |
| **L5** | t_prd_product_options | 오버로크 dflt_yn=Y·복합/유료 dflt_yn=N | **UPDATE 0**(라이브 이미 정합) | 조건부 UPDATE |

**합계: INSERT 10 · UPDATE 0.** (L5 UPDATE 0 = 라이브 오버로크 이미 dflt_yn=Y·나머지 N → 멱등 정합 입증).
mint: 옵션 1(OPV_000424)·comp 1·단가행 5·item 2·배선 1. proc/자재 신규 0.

## 3. FK 위상·트리거

```
L1(옵션 OPV_000424) → L1b(option_items FK→options·트리거 fn_chk_opt_item_ref)
L2(comp) → L3(component_prices.comp_cd FK→price_components)
L2 + 기존 PRF_POSTER_LINEN → L4(formula_components)
L5(options UPDATE·독립)
```
- 트리거 `fn_chk_opt_item_ref`(OPT_REF_DIM.04): PRD_000124 product_processes 에 PROC_000080 실재 → L1b 통과(실측).
- component_prices PK=comp_price_id(시퀀스 자동)·자연키 unique 제약 부재 → 멱등은 `(comp_cd,apply_ymd,opt_cd)` 논리키 NOT EXISTS 로 보장.

## 4. 백업 / undo

`apply.sh` 가 실행 전 항상 `backup_<ts>/` 에 5개 read-only 스냅샷 CSV:
- `pre_options.csv`(가공 옵션·L1/L5 undo) · `pre_option_items.csv`(L1b undo) · `pre_comp.csv`(L2 undo)
- `pre_component_prices.csv`(L3 undo·comp_price_id 포함) · `pre_formula_components.csv`(L4 undo)

undo: 신규 INSERT(L1·L1b·L2·L3·L4)는 신규 행 DELETE — `OPV_000424`·`COMP_POSTEROPT_LINEN_FINISH`·그 단가행·배선·복합 item.
OPV-000024 item(L1b 추가분)은 백업에 없던 (opt_cd,item_seq) 만 삭제. L5 UPDATE 는 백업 dflt_yn 값으로 원복(이번은 변경 0).

## 5. 실 COMMIT 절차 (인간 최종 승인 후)

```bash
bash _exec_linen/apply.sh            # 1) DRY-RUN 재확인(라이브 무변경)
# 2) dryrun-report.md GO + 인간 승인
bash _exec_linen/apply.sh --commit   # 3) ROLLBACK→COMMIT 치환·백업 자동 선행
# 4) 사후: 5택1 단가·골든(본체+가산)·dflt 오버로크 확인
```
[HARD] `--commit` 은 인간 최종 승인 전제. 비밀값 `.env.local` RAILWAY_DB_* 만 사용(비노출).
