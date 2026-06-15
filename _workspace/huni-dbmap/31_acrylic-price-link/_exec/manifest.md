# 아크릴 가격사슬 연결 — 적재 매니페스트 (round-5 load-execution)

> **작성** 2026-06-15 · `dbm-load-builder`(실행본화·재설계 0). 입력 = `acrylic-chain-design.md`(arbiter 확정 설계).
> **DB 미적재 · 실 COMMIT 0** — 멱등 SQL + 롤백전용 라이브 DRY-RUN까지만(사용자 범위 확정). 실 적용 = 인간 승인.
> 산출 = `31_acrylic-price-link/_exec/`. 생성기 `gen_load_sql.py`(손편집 금지·재현성 R3).

---

## 1. 충돌키(라이브 PK 실측 — 추측 0)

| 테이블 | PK(=ON CONFLICT 타겟) | 비고 |
|--------|----------------------|------|
| `t_prc_price_formulas` | `frm_cd` | DO NOTHING |
| `t_prc_price_components` | `comp_cd` | DO NOTHING |
| `t_prc_formula_components` | `frm_cd, comp_cd` | DO NOTHING |
| `t_prd_product_price_formulas` | **`prd_cd, apply_bgn_ymd`** | ⚠️ `frm_cd`는 PK 밖 — 한 상품·한 적용일에 한 공식 |

> `reg_dt` 전 테이블 **NOT NULL DEFAULT now()** → 컬럼 omit(명시 NULL 금지·DEFAULT 발화). round-5 reg_dt 교훈 반영.

## 2. FK 위상순서 (apply.sql)

```
01 t_prc_price_formulas        (부모)
02 t_prc_price_components       (부모)
03 t_prc_formula_components     (자식: frm_cd→01 · comp_cd→02/기존)
04 t_prd_product_price_formulas (자식: frm_cd→01 · prd_cd→t_prd_products[실재])
```

## 3. 테이블별 INSERT 행수 (신규 / 스킵 — 라이브 DRY-RUN 실측)

| 단계 | 테이블 | INSERT 시도 | 신규(0행→실삽입) | 스킵(ON CONFLICT) | 근거 |
|:--:|--------|:--:|:--:|:--:|------|
| 01 | `t_prc_price_formulas` | 4 | **3** | 1 | PRF_CLR_ACRYL 라이브 실재 스킵(`INSERT 0 0`)·MIRROR/COROTTO/CARABINER 신규 |
| 02 | `t_prc_price_components` | 2 | **2** | 0 | COROTTO·CARABINER 신규(CLEAR3T/MIRROR3T 재적재 0·미동봉) |
| 03 | `t_prc_formula_components` | 3 | **3** | 0 | MIRROR/COROTTO/CARABINER 배선 신규(CLR 메타보정 BLOCKED·주석) |
| 04 | `t_prd_product_price_formulas` | 19 | **18** | 1 | PRD_000146 라이브 실재 스킵·투명13+미니파츠1+코롯토3+카라비너1=18 신규 |
| — | `t_prc_component_prices` | 0 | 0 | — | **단가행 재적재 0**(골든 CLEAR3T 84·MIRROR3T 37 보존) |

**적재 후 아크릴 사슬 카운트** (DRY-RUN before→after):
- formulas: 1 → 4 · components: 4 → 6 · wiring: 1 → 4 · binding: 1 → 19

## 4. 바인딩 상세 (04단계 19행 = 4 공식)

| → frm_cd | 상품 수 | 상품 |
|----------|:--:|------|
| `PRF_CLR_ACRYL` | 15 | 키링146(실재)·마그넷147·뱃지148·집게149·스마트톡150·명찰152·머리끈154·볼펜155·네임택157·포카키링158·자유형스탠드160·판아크릴161·포카스탠드162·미니파츠163(1.5T)·쉐이커170 |
| `PRF_COROTTO_ACRYL` | 3 | 코롯토164·입체코롯토168·쉐이커코롯토226 |
| `PRF_CARABINER_ACRYL` | 1 | 카라비너166 |
| `PRF_MIRROR_ACRYL` | **0** | **BLOCKED**(Q-ACR-9 미러 본체 상품 불명) — 공식정의·배선만, 바인딩 미동봉 |

## 5. 게이트 자가요약 (생성자 — 검증 권위는 validator R1~R6)

| 항목 | 결과 | 근거 |
|------|:--:|------|
| 멱등 ON CONFLICT 전 INSERT | ✅ | 4 SQL 전건 ON CONFLICT(라이브 PK 일치) |
| 단일 트랜잭션·FK 위상순서 | ✅ | apply.sql BEGIN·중첩 COMMIT 0·ON_ERROR_STOP |
| 라이브 DRY-RUN 멱등(R1) | ✅(예비) | 2회차 전건 `INSERT 0 0`·after1=after2 |
| 라이브 DRY-RUN FK 고아(R5) | ✅(예비) | 4 FK 어서션 전건 0행·신규 comp 코드 FK 0고아 |
| 골든 재현 | ✅ | CLEAR3T 84·MIRROR3T 37 불변·단가행 재적재 0 |
| 라이브 진화 교차 | ✅ | PRF_CLR_ACRYL·PRD_000146 스킵 카운트로 실재 입증 |

> **NEVER COMMIT** — 위 DRY-RUN은 전부 `BEGIN…ROLLBACK`. 실 적재 = 인간 승인 + webadmin Phase11 엔진 동시배포 선결.
