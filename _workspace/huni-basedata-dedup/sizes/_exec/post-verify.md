# post-verify — D-1 (SIZ_000105 → SIZ_000104) 사후검증

검증 시각: 2026-06-19 (COMMIT 직후 라이브 재실측) / hbd-load-executor
대상: D-1 1건 — 카드봉투(PRD_000004) 사이즈 화면 중복 해소

## 사전 실측 (변경 전, 라이브 = 명세 일치)

| 항목 | 값 |
|---|---|
| SIZ_000104 (정본) | `165x115mm(10장)`·del_yn=N·cp_rows=0 |
| SIZ_000105 (멤버) | `165x115mm(10장)`·del_yn=N (byte-identical) |
| PRD_000004 바인딩 | **104·105 둘 다** dflt_yn=Y·disp_seq=1·del_yn=N (이중 default 중복) |
| SIZ_000105 외부참조 | component_prices=0·prd_product_sizes_active=1·plate_sizes=0 |
| FK 표면 전수 스캔 | siz_cd 참조 라이브 테이블 4종(component_prices·plate_sizes·product_sizes·siz_sizes) 중 105 참조 = siz_sizes(자기행)+product_sizes(1) 뿐 → CASCADE 위험 0 |

## DRY-RUN (롤백전용, 2-pass)

| pass | (a) DEL delta | (b) UPD delta | 제약위반 | 결과 |
|---|:---:|:---:|:---:|---|
| 1 | 1 | 1 | 0 | ROLLBACK |
| 2 | 1 | 1 | 0 | ROLLBACK (동일 = no-drift) |

DRY-RUN 내 사후검증 SELECT가 기대값(104=N/105=Y·PRD_000004 단일 104·cp=0/prd_active=0)을 모두 충족.

## COMMIT delta

| 변경 | 테이블 | 실제 delta |
|---|---|:---:|
| (a) 멤버 바인딩 제거 | t_prd_product_sizes | DELETE 1 |
| (b) 멤버 논리삭제 | t_siz_sizes | UPDATE 1 (del_yn N→Y) |
| INSERT / 물리 DELETE | — | 0 |

## 사후검증 게이트 (전건 GO)

| # | 게이트 | 기대 | 실측 | 판정 |
|---|---|---|---|:---:|
| V1 | 멤버 논리삭제·정본 활성 | 104=N, 105=Y | 104=N, 105=Y | **GO** |
| V2 | PRD_000004 사이즈 단일·중복 해소 | SIZ_000104 단일(dflt_yn=Y) | SIZ_000104 단일(dflt_yn=Y) | **GO** |
| V3 | 멤버 외부참조 0 (CASCADE 무발생) | cp=0, prd_active=0 | cp=0, prd_active=0 | **GO** |
| V4 | FK 고아 0 | 활성 product_sizes→del_yn=Y siz 0 | 0 | **GO** |
| V5 | 멱등 (재-dryrun delta) | 0, 0 | a=0, b=0 | **GO** |

종합: **GO** — 카드봉투 사이즈 화면 중복(SIZ_000104·SIZ_000105 동일 `165x115mm(10장)`) 해소. 상품은 정본 SIZ_000104 단일 default 유지(무손실). 가격행(component_prices) 영향 0.

## undo 안전망

- 백업: `bak_siz_basedata_dedup_20260619_0800`(2행)·`bak_prdsiz_basedata_dedup_20260619_0800`(2행)
- 복원: `_exec/undo.sql` (직접 역연산 A안 / 백업 테이블 복원 B안)
