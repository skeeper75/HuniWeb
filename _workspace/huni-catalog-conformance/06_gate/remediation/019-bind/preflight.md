# preflight.md — search-before-mint 실측 (019 묶음 교정: A5-plate + A2-bind)

> 교정: A5-plate(판형 정정) + A2-bind(공식 바인딩) 묶음 · PRD_000019(투명엽서) · 라이브 read-only 실측 2026-06-22.
> 사용자 판형 정답 확정: **019 출력판형 = 316x467(SIZ_000499) 권위**, SIZ_000522(315x467)는 완성품치수 혼입 오적재.
> 권위: `remediation-spec §S(A2-bind·A5-plate)` · `DEF-PE-01` · `e2e-golden-trace 추적1/추적3` · 사용자 판형 확정.
> [HARD] 공유 마스터(t_siz_sizes·t_prc_* 공식/comp/단가행) 무수정 — 상품별 t_prd_product_* 만.

## search-before-mint 판정 요약

### STEP 1 — A5-plate (판형 정정 SIZ_000522 → SIZ_000499)
| # | 항목 | 판정 | 근거(라이브 verbatim) |
|---|------|:----:|----------------------|
| 1 | SIZ_000499 마스터 실재 | **PASS** | `t_siz_sizes`: 316x467·use_yn=Y·del_yn=N → FK 타깃 충족·**신규 mint 0** |
| 2 | 019 현재 출력판형 행 실재 | **PASS** | `t_prd_product_plate_sizes`: SIZ_000522·otyp=OUTPUT_PAPER_TYPE.01·dflt_plt_yn=Y 1건 |
| 3 | PK 충돌 부재(멱등 UPDATE 가능) | **PASS** | 019 에 SIZ_000499 행 부재(has_499=0) → siz_cd UPDATE 시 PK(prd_cd,siz_cd) 충돌 없음 |
| 4 | 자식 FK cascade 위험 | **PASS** | t_prd_product_plate_sizes 참조 자식 FK **0건** → 행 키 변경 안전 |
| 5 | 정정 후 단가 환원 | **PASS** | SIZ_000499 에 PRF_DGP_A 단가행 실재(COMP_PRINT 106 tier·COMP_PAPER 56행) |

→ **연산 결정 = 멱등 UPDATE**(DELETE+INSERT 불요). 자식 FK 0·행 속성 보존·`WHERE siz_cd='SIZ_000522'` + `NOT EXISTS(SIZ_000499)` 가드로 멱등.
SIZ_000522·SIZ_000499 **마스터 자체 무수정**. 영향 = 019 상품행 1개만(SIZ_000522 사용 025/039 는 이번 제외·미접근).

### STEP 2 — A2-bind (공식 바인딩 PRD_000019 ↔ PRF_DGP_A)
| # | 항목 | 판정 | 근거 |
|---|------|:----:|------|
| 1 | PRD_000019 실재(del_yn=N) | **PASS** | prd_nm=투명엽서·del_yn=N·use_yn=Y |
| 2 | PRF_DGP_A 공식 실재 | **PASS** | use_yn=Y·formula_components 10행 배선 |
| 3 | 단가행 실재(환원) | **PASS** | 정정된 plate SIZ_000499 기준 COMP_PRINT 106·COMP_PAPER 56행 |
| 4 | 기존 바인딩 부재(멱등) | **PASS** | 019 바인딩 행 0건 → INSERT 대상·충돌키 PK(prd_cd,apply_bgn_ymd) |

## 묶음 효과 — 0원 차단 + 단가 환원 동시 해소

- **단건 A2-bind만으로는 불충분**(직전 진단): 019 plate=SIZ_000522 는 PRF_DGP_A 단가행 0행 → 바인딩해도 0원.
- **A5-plate 동반 시**: 출력판형 SIZ_000499 로 정정 → 단가행 106/56 환원 → 바인딩과 결합해 정상 견적 산출.
- 정정으로 출력판형 행이 SIZ_000499 가 되어 형제 016/017/018 과 **동일 plate·동일 단가행 경로** 도달(정합 동치).

## 범위·안전 확인

- 접근 테이블 = `t_prd_product_plate_sizes`(STEP1·019 1행 UPDATE) + `t_prd_product_price_formulas`(STEP2·019 1행 INSERT). **공유 마스터 0건 접근.**
- 신규 mint **0**(SIZ_000499·PRF_DGP_A·단가행 전부 실재). apply_bgn_ymd='2026-06-01'·note 컨벤션 = 형제 016~018 계승.
- 완성품치수 혼입(SIZ_000114/115/118·otyp NULL)은 본 묶음 범위 밖(출력판형 정정만이 가격 목표). 별도 EXTRA 정리는 dbm-correctness-audit 잔여.
