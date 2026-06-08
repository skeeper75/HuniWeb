# price-211 slice C2 — BOOKLET / PHOTOBOOK / POSTCARD-BOOK / 떡메

price-211 Phase-1, slice C2 적재 실행본 (DB 미적재 — 인간 승인 대기).

## 핵심 (TL;DR)

계획 F3 "33 무가격"은 부모+반제품 prd-count였다. **라이브 실측 결과 엽서북·떡메·일반책자 제본·전체
제본비 단가는 이미 적재 완료**되어 있었고, 真 미적재는 **5상품**(하드커버 책자 4 + 포토북 1)뿐이다.

## 산출물

| 파일 | 내용 |
|----|----|
| `mapping.md` | STATUS·형태·공식설계·코드제약·설계결정·역대조 (권위 설계서) |
| `dryrun-plan.md` | 적재행수·FK선존재검증(read-only)·R1~R6·recompute |
| `load.sql` | 멱등 INSERT 단일 트랜잭션 (BEGIN…ROLLBACK). 31행. |
| `load/t_prc_price_formulas.csv` | PRF_PBK_PAGEBAND 1 |
| `load/t_prc_price_components.csv` | COMP_PBK_BASE24P·ADD2P 2 |
| `load/t_prc_formula_components.csv` | 배선 2 |
| `load/t_prc_component_prices.csv` | 포토북 base11+add11 = 22 |
| `load/t_prd_product_price_formulas.csv` | 하드커버3+포토북1 = 4 |
| `load/*_BLOCKED.csv` | 레더링바인더 1 + 10×10소프트 2 (미적재 분리) |

## 하위구조별 형태

- **하드커버 책자 (3)**: 제본 합산형. 라이브 PRF_BIND_SUM + COMP_BIND_HC_* (단가 이미 적재) →
  **상품 바인딩만**. 제본종류=라이브 proc link 권위(072/077=하드커버무선, 082=하드커버트윈링).
- **포토북 (1)**: **page-band 합산형 (신규 PRF_PBK_PAGEBAND)**.
  `가격 = 기본가(24P) + ceil((pages−24)/2) × 추가2P단가`.
  [HARD] DB = base + add2P **lookup 2행만** (siz×mat 차원). page count 곱셈/ceiling = **앱 런타임**(baked 금지).
- **엽서북·떡메 (이미 완료)**: PRF_PCB_FIXED(234행)·PRF_TTEOKME_FIXED(112행) 라이브 선존재 → **재적재 금지**.

## INSERTABLE vs BLOCKED

- INSERTABLE = **31행**.
- BLOCKED = 3:
  - PRD_000088 레더 링바인더: 제본종류 미상(소스공란+proc 없음, 발명금지) → 후니 input.
  - 포토북 10×10 소프트커버: 소스 base/add 공란(품절/미출시) → 후니 input.

## 적재 (인간 승인 후)

DB 미적재. 실 적재 시: ① IDENTITY 시퀀스 setval 재동기화(R6 함정) → ② `ROLLBACK;`→`COMMIT;`
교체 → ③ 2-pass 멱등 확인. 상세 `dryrun-plan.md §4`.
