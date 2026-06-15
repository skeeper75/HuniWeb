# 270 상품 배치 분류 (round-20 · classify.py)

> 실행 2026-06-15 · `dbm-batch-load/scripts/classify.py` (라이브 read-only 한 SQL 집계).
> 원본 = `classification.csv` (275행). 동형 두 축 분리[HARD]: 가격(frm_cd 레시피) / 옵션(opt_sig).

## 상태 분포 (275 상품)

| 상태 | 수 | 의미 | 처리 |
|------|---:|------|------|
| **ready** | 58 | use_yn=Y · 가격공식(frm_cd) 바인딩 있음 | 가격 동형 배치 대상 |
| **pending** | 189 | use_yn=Y · 가격공식 **NONE**(가격 미구성) | 가격공식 구성 선결(round-16/2) |
| **unlisted** | 28 | use_yn=N | 제외 |

> pending 189 = round-18+ "184 가격 미구성"과 정합. 봉투·악세사리(볼체인·우드거치대)·투명/모양/박 명함·스티커 등 — **여러 가격산정방식이 아직 DB에 안 들어온** 상품(도메인 현실·[[dbmap-print-domain-recipe-philosophy]]). 배치 적재가 아니라 가격공식 설계가 먼저.

## 축 1 — 가격 동형 (frm_cd · 레시피) = 가격 적재 배치 단위

ready 58 → 14 가격클래스. **배치 가능(멤버≥2) = 8클래스 52상품:**

| 가격공식(레시피) | 상품수 | 비고 |
|------------------|---:|------|
| PRF_POSTER_FIXED | 28 | 면적매트릭스(포스터사인) — 최대 |
| PRF_DGP_A | 7 | 합산형(엽서·쿠폰/상품권·종이슬로건) |
| PRF_BIND_SUM | 4 | 제본 합산 |
| PRF_DGP_C | 3 | 합산형 |
| PRF_NAMECARD_FIXED | 3 | 고정가(명함) |
| PRF_STK_FIXED | 3 | 고정가(스티커) |
| PRF_DGP_E | 2 | 합산형 |
| PRF_PHOTOCARD_FIXED | 2 | 고정가(포토카드) |

단건(load-execution): PRF_DGP_B·DGP_D·ENV_MAKING·FOLD_SUM·GANGPAN_FIXED·PCB_FIXED 각 1.

> **같은 공식 = 같은 comp 레시피**(formula_components가 frm_cd 단위). PRF_DGP_A 7상품은 옵션이 달라도(프리미엄/코팅/스탠다드 엽서·쿠폰) **가격은 한 배치**. comp 차이는 런타임 옵션 선택.

## 축 2 — 옵션 동형 (가격공식 × opt_sig) = 옵션 적재 배치 단위(별 축)

배치 가능 7클래스 29상품:

| 옵션 동형 | 상품수 |
|-----------|---:|
| PRF_POSTER_FIXED__NOOPT | 14 |
| PRF_DGP_C__NOOPT | 3 |
| PRF_POSTER_FIXED__95fa3c19 | 3 |
| PRF_POSTER_FIXED__c075ac1d | 3 |
| PRF_DGP_E__f253cecb | 2 |
| PRF_POSTER_FIXED__8e5d30b8 | 2 |
| PRF_POSTER_FIXED__f6552d27 | 2 |

> 같은 가격공식이어도 옵션구성이 다르면 옵션 배치는 분리(PRF_DGP_A 7상품이 옵션시그 7개로 흩어짐). NOOPT = 옵션 그룹 미적재(round-7 CPQ 옵션 비균질) — 옵션 동형 축은 CPQ 적재 진척에 의존.

## 다음 (S2 선결 → 배치)

1. **가격 동형 첫 배치 후보**: PRF_POSTER_FIXED(28) 또는 PRF_DGP_A(7) — 각 클래스의 **미적재 단가행 GAP**(종이비 7행 같은)을 S2 선결로 점검 → 동형 배치(gen_batch_upsert).
2. **pending 189**는 가격공식 구성(round-16/2)이 선결 — 배치 적재 전 단계.
3. ready 단건 6은 load-execution(단건).
