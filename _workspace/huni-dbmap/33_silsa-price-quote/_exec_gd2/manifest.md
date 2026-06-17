# G-D2 포스터 본체 후가공 배선 — 실행본 manifest (round-23)

> 작성 2026-06-17 · dbm-load-builder. 입력 = `gd2-wiring-design.md`(W1~W6) + 라이브 read-only 실측.
> **설계+DRY-RUN GO까지. 실 COMMIT은 인간 승인(`apply.sh --commit`).**
> 단가행 재적재 0 — 전부 공식/배선/차원전환(값 불변).

## 단위별 대상·행수·순서

| 단위 | 테이블 | 조치 | 영향행수(PASS1 실측) | 멱등키 | 비고 |
|------|--------|------|:--:|--------|------|
| **W1** 본체 공식 분리 | t_prc_price_formulas | 소재별 PRF_POSTER_<MAT>·_FIXED_<X> 28 INSERT | INSERT 28 | frm_cd | 동시매칭 방지 선행 필수 |
| **W2** 본체 배선 | t_prc_formula_components | 각 공식 disp_seq=1=자기 본체 comp | INSERT 28 | (frm_cd,comp_cd) | addtn_yn='Y'(메타) |
| **W3** 바인딩 교체 | t_prd_product_price_formulas | 28상품 PRF_POSTER_FIXED→유형별 | DELETE 28 + INSERT 28 | (prd_cd,apply_bgn_ymd) | PK=(prd_cd,apply_bgn_ymd)·동일 '2026-06-01' |
| **W4** 후가공 배선 | t_prc_formula_components | 오시·귀돌이2·가변2·별색2 = 7 × 28공식 (disp_seq 2~8) | INSERT 196 | (frm_cd,comp_cd) | 미싱 제외(W5 후 W6) |
| **W5** 미싱 차원전환 | t_prc_price_components / t_prc_component_prices | use_dims opt→proc · prc_typ .02→.01 · 단가행 opt_cd→proc_cd=PROC_000086+dim_vals.줄수 · 2L/3L use_yn=N | UPDATE 1+1+30+2 | comp_cd / comp_price_id | 이설(값동일·신규0) |
| **W6** 미싱 배선 | t_prc_formula_components | 28공식에 COMP_PP_PERF_1L (disp_seq=9) | INSERT 28 | (frm_cd,comp_cd) | W5 후에만 모델 정합 |

**합계:** INSERT 28+28+28+196+28 = 308 · DELETE 28 · UPDATE 34 (=1+1+30+2). 공식 29(28신규+FIXED 보존)·배선 252(본체28+후가공196+미싱28).

## 실행 순서 (FK 위상정렬·apply.sql 단일 트랜잭션)

```
W1(공식 부모) → W2(본체배선) → W3(바인딩) → W4(후가공배선) → W5(미싱 차원전환) → W6(미싱배선)
```
- W1이 W2/W4/W6 frm_cd 부모. comp_cd/prd_cd/proc_cd(PROC_000086)는 라이브 선존재(전건 검증).
- W5(차원전환) 선행 → W6(미싱배선): PERF_1L이 proc_cd/proc_grp 모델로 통일된 뒤에만 다른 후가공과 동형 배선.

## BLOCKED / 별 트랙

| ID | 항목 | 상태 | 해소 |
|----|------|------|------|
| **W4-spot-dedup** | 별색 WHITE_S1 530행(5색 proc 교차적재 잔존)·형제 4색 comp use_yn=Y | **별 트랙(grouping U5')** | W4 배선은 정상 동작(BLOCKED 아님) — dedup은 데이터 위생 문제. 정본화는 grouping 권위. `W4_spot_dedup.PRECONDITION.BLOCKED.sql` 참조 |

> ★설계의 B-1(미싱 배선 BLOCKED)은 **W5 차원전환으로 해소** — 라이브 데이터(OPV→줄수·PROC_000086 leaf·proc_grp PROC_000030)가 전환을 지원해 이번 단위에 포함(이설·값동일).

## undo

- 비파괴 단위(W1/W2/W4/W6 INSERT·W5 UPDATE)는 ROLLBACK이 1차 안전망.
- 실 COMMIT 후 undo 근거: `apply.sh`가 COMMIT/DRY-RUN 무관 사전 백업 3종 저장 —
  `backup_bindings_pre.csv`(W3 바인딩)·`backup_perf_comp_pre.csv`(W5 comp)·`backup_perf_prices_pre.csv`(W5 단가행).
- undo SQL: W3=백업 바인딩 복원(신규 DELETE→FIXED INSERT)·W5=opt_cd 복원(proc_cd/dim_vals NULL·prc_typ .02 복원)·use_yn=N→Y·W1/W2/W4/W6=신규 frm/배선 DELETE.

## 산출물

- `W1~W6 *.sql` (멱등) · `apply.sql`(FK순 단일 트랜잭션·기본 ROLLBACK) · `apply.sh`(env·백업·--commit 게이트)
- `W4_spot_dedup.PRECONDITION.BLOCKED.sql`(별 트랙 의존성 문서) · `dryrun-report.md`(R1~R6 실증) · `manifest.md`
- 생성 스크립트 `_gen.py`(재현·결정적)
