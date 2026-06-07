# 실사/포스터사인 면적매트릭스 가격 — 적재 실행본 (price-211 Phase-1)

생성: dbm-mapping-designer (dbm-price-formula 스킬) · 2026-06-07 · **생성 단계**(검증은 별도)

## 한 줄 요약
실사 13 면적형 상품의 가격을, 실사 시트 inline 단일가가 아니라 **가격표 포스터사인
[가로×세로] 면적매트릭스 셀단가**로 적재(687셀). 13상품 전부 round-2 가 sparse(1~6%)로
오모델 → **CORRECTION+EXPANSION**. siz 108종 미등록으로 본체 670행 BLOCKED, 17행만 INSERTABLE
(라이브 동일=멱등 no-op). **실 적재·siz채번·COMMIT 인간 승인.**

## 파일
| 파일 | 용도 |
|------|------|
| `mapping.md` | 매핑 설계서(상품↔블록↔prd_cd, 매트릭스 평면화, siz 해소, 공식/바인딩, 제약, 설계결정) |
| `load.sql` | 멱등 INSERT(INSERTABLE 17) + 부모검증 + setval 가드. BEGIN/COMMIT 미포함(apply.sh 주입) |
| `dryrun-plan.md` | FK 적재순서 + DRY-RUN 게이트(R1~R6) + 설계자 사전점검 PASS 기록 |
| `load/t_prc_component_prices_INSERTABLE.csv` | 17행 (siz 4종 선존재) |
| `load/t_prc_component_prices_BLOCKED.csv` | 670행 (매트릭스 본체, siz 108 미등록) |
| `load/t_siz_sizes_BLOCKED.csv` | 108 siz 선적재 제안(SIZ_000511~000618, 인간승인) |

## 적재 상태
- **INSERTABLE 17행** → `load.sql`. DRY-RUN `INSERT 0 17`(전건 멱등 no-op, 라이브 동일값).
- **BLOCKED 670 + siz 108** → siz 인간승인 후 별도 라운드(매트릭스 실데이터 본체).
- **공식/구성요소/바인딩** → 라이브 선존재(round-2), 신규 INSERT 0.

## 다음 단계
1. dbm-validator 독립 재검증 (S-gate + 역대조 + R1~R6).
2. (인간 승인) siz 108 등록 → BLOCKED 670 적재.
3. (인간 승인) round-2 sparse 변칙행(min_qty=1 BANNER/JOKJA/PET) 정리 CORRECTION.
4. 고정가형 16상품(수량×규격)은 **별도 트랙** — 본 면적매트릭스에 편입 금지.
