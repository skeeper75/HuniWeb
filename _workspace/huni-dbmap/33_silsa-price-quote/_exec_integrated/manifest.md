# 통합 실행본 manifest — 신안 + G-D2 (X-1 단일화)

> 작성 2026-06-17 · `dbm-load-builder`. 입력 = `_exec_wh/`(신안 V1·V1b·V2·V3) + `_exec_gd2/`(G-D2 W1~W6).
> 권위 설계 = `poster-sign-component-redesign.md`(신안) · `gd2-wiring-design.md`(G-D2).
> **DB 미적재 — 롤백전용 DRY-RUN GO까지. 실 COMMIT은 인간 최종 승인.**

## 1. 통합 단위·순서 (FK 위상·단일 트랜잭션)

apply.sql 은 원본 단위 SQL 을 `\i` 로 참조(중복 사본 0, 단일 권위 유지).

| 순 | 단위 | 출처 파일 | 대상 테이블 | 핵심 |
|----|------|-----------|-------------|------|
| 1 | V1 | `../_exec_wh/V1_area_unitprices.sql` | t_prc_component_prices | 면적단가 667 INSERT(siz_width/height·가격표 verbatim) |
| 2 | V1b | `../_exec_wh/V1b_convert_live_sizcd.sql` | t_prc_component_prices | 라이브 매트릭스 siz_cd 17행→width/height 전환 |
| 3 | V2 | `../_exec_wh/V2_use_dims_switch.sql` | t_prc_price_components | 면적 13 comp use_dims→[siz_width,siz_height] |
| 4 | W1 | `../_exec_gd2/W1_body_formula_split.sql` | t_prc_price_formulas | 소재별 공식 28 분리 |
| 5 | W2 | `../_exec_gd2/W2_body_wiring.sql` | t_prc_formula_components | 본체 28 배선(면적13 width/h + 고정15 siz_cd) |
| 6 | W3 | `../_exec_gd2/W3_binding_swap.sql` | t_prd_product_price_formulas | 바인딩 교체(FIXED→유형별 28) |
| 7 | W4 | `../_exec_gd2/W4_postproc_wiring.sql` | t_prc_formula_components | 후가공 배선(오시·귀돌이·가변·별색 7×28) |
| 8 | W5 | `../_exec_gd2/W5_perf_dim_convert.sql` | price_components·component_prices | 미싱 차원전환(opt→proc·prc_typ·30 이설) |
| 9 | W6 | `../_exec_gd2/W6_perf_wiring.sql` | t_prc_formula_components | 미싱 PERF_1L→28공식 배선 |
| 10 | V3 | `../_exec_wh/V3_nonspec_incr.sql` | t_prd_products | off-grid nonspec_incr 백필 13 |

### 통합 정합 규칙(반영)
- **면적 13 comp**: use_dims=[siz_width,siz_height](V2)·단가 V1(667)+V1b(17)·off-grid V3. 공식분리(W1)·본체배선(W2)은 신안 차원으로 동작(siz_cd 가정 폐기).
- **고정가 15 comp**: siz_cd 이산 유지(신안 미적용). W1/W2 그대로.
- **후가공/미싱/별색(W4~W6)**: 28공식 공통·proc_cd/dim_vals(사이즈축 무관·신안 영향 0).
- **폐기/대체**: U1(좌표 siz 채번) 폐기 · U2(면적단가)=V1로 대체 · U5'(별색 dedup) 별 트랙(W4 배선만 포함).

## 2. 영향행수 합산

INSERT **975** (V1 667·W1 28·W2 28·W3 28·W4 196·W6 28) · UPDATE **77** (V1b 17·V2 13·W5 34·V3 13) · DELETE **28** (W3).
단가행 재적재 0(V1=신규 verbatim·V1b/W5=값불변 전환).

## 3. 백업 / undo 경로

`apply.sh` 가 실행 전 항상 `backup_<timestamp>/` 에 5개 read-only 스냅샷 CSV 저장:
- `pre_use_dims.csv` — price_components `comp_cd, use_dims, prc_typ_cd, use_yn` (V2/W5 undo 근거)
  · **[MINOR-1 보강] W5 가 바꾸는 `prc_typ_cd`(.02→.01)·`use_yn`(2L/3L→N) 포함** → 역복원 가능.
- `pre_component_prices.csv` — `comp_price_id` 포함 면적/미싱 단가행 (V1/V1b/W5 undo)
- `pre_formula_components.csv` — 배선 (W2/W4/W6 undo)
- `pre_product_price_formulas.csv` — 바인딩 (W3 undo)
- `pre_nonspec.csv` — nonspec_incr (V3 undo)

undo: `undo.sql.tmpl` 가 위 CSV 를 `-v bkp=backup_<ts>` 로 받아 역복원(기본 ROLLBACK·인간 승인 시 COMMIT).
- 비파괴 INSERT(V1·W1·W2·W4·W6): 신규 행 DELETE.
  · **[MINOR-2 정밀화] V1 undo 는 `comp_price_id` 기준** — V1 신규 667행·V1b 전환 17행이 둘 다
    `apply_ymd='2026-06-01'`·`siz_width NOT NULL` 이라 predicate 삭제 시 V1b 17행 과삭제 위험 →
    **백업 CSV 의 `comp_price_id` 집합에 없는 매트릭스 행만 삭제**(V1 667만·V1b 17 보존).
- 전환 UPDATE(V1b·V2·W5·V3): 백업 CSV 값으로 원복(`comp_price_id`/`comp_cd`/`prd_cd` 키).
- W3 DELETE: 백업 `pre_product_price_formulas.csv` 로 FIXED 바인딩 재INSERT.

## 4. 실 COMMIT 시 실행 절차 (인간 최종 승인 후)

```bash
# 1) 사전 DRY-RUN 재확인 (라이브 무변경)
bash _exec_integrated/apply.sh

# 2) dryrun-report.md GO 확인 + 인간 최종 승인

# 3) 실 적용 (ROLLBACK→COMMIT 치환·백업 자동 선행)
bash _exec_integrated/apply.sh --commit

# 4) 사후 검증: FK 고아 0·골든 재현·use_dims 전환·바인딩 28 확인
```

[HARD] `--commit` 은 인간 최종 승인 전제. 비밀값은 `.env.local` RAILWAY_DB_* 만 사용(출력 비노출).

## 5. 게이트 결과 (dryrun-report.md 상세)

멱등 2-pass delta 0 · FK 고아 0 · 동시매칭 0 · 골든 결합 재현(600×1800+오시2줄=27,600·off-grid 800×800=20,000) · COMMIT 0 → **GO(롤백전용)**.
