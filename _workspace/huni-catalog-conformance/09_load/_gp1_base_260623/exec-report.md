# exec-report.md — §21 R-GP4-1 굿즈 GP-1 base 라이브 COMMIT

> hbd-load-executor · 2026-06-23 · 인간 승인(GP-1만 먼저) 완료 후 실행.
> 명세 권위: `06_gate/remediation-spec-batch4.md` R-GP4-1 · `01_authority/authority-spec-batch4.md` GP-1.

## 1. 대상 확정 (28 후보 → 26 적재 + 2 보류)

GP-1 후보 추출 = checklist `옵션그룹 needed=N` ∩ `가격엔진 needed=Y` = **28 prd**.
권위 엑셀(goods-pouch-l1.csv) variant/addon 신호 정밀 재검 결과:

| 분류 | 수 | prd | 처리 |
|------|---|-----|------|
| 순수 GP-1(신호 0) | 25 | (아래 mapping.csv) | 적재 |
| GP-ADD(addon=별SKU·본체 단일가) | 1 | PRD_000223 말랑포카홀더(14000, 볼체인 9색 +1000=별SKU) | 적재(본체 base만·G-GP-5 비위반) |
| **GP-2 variant 보류** | 2 | PRD_000206 반팔티셔츠·PRD_000209 후드티셔츠 | **제외**(색상×사이즈 variant=화이트/블랙 M/L/XL/XXL·멜란지/블랙 XL) |

★ checklist `옵션그룹=N` 오분류 적발: 반팔/후드는 엑셀 `상품(옵션)` 공란이나 `선택(옵션)_선택`에
색상×사이즈 variant 존재 → **G-GP-5 위반 위험**(product_prices 선점 시 FORMULA 영영 우회).
→ R-GP4-5(GP-2 FORMULA 바인딩) 트랙으로 라우팅·이번 적재 제외.

## 2. COMMIT 결과

- **적재 테이블**: `t_prd_product_prices` (적재 전 전체 0행)
- **적재 행수**: **26행** (prd 26 × apply_ymd=2026-06-10)
- **단가**: 상품마스터260610 가격(C열) verbatim (날조 0)
- **apply_ymd**: `2026-06-10`(권위 엑셀 날짜·라이브 컨벤션 yyyy-MM-dd·today 이하→견적 유효)
- **멱등 키**: PK(prd_cd, apply_ymd) + `ON CONFLICT DO NOTHING`
- **물리 백업**: `bak_t_prd_product_prices_gp1base_20260623` (스냅샷 0행=적재 전 무행)

## 3. 게이트 결과 (DRY-RUN + 사후 라이브 재실측)

| 게이트 | 결과 |
|--------|------|
| DRY-RUN 적재 카운트 | INSERT 0 26 ✅ |
| DRY-RUN 멱등(2회) | INSERT 0 0 (delta 0) ✅ |
| DRY-RUN verbatim | 카드거울2500·말랑포카14000·캔버스58000 일치 ✅ |
| DRY-RUN 견적 0→정상 | 카드거울 qty10=25000·캔버스 qty3=174000 ✅ |
| DRY-RUN ROLLBACK | 라이브 0행 복원(무변경) ✅ |
| 사후 적재행 수 | 26 ✅ |
| 사후 FK 고아 | 0 ✅ |
| 사후 verbatim 26건 | mismatch 0 ✅ |
| 사후 G-GP-5(반팔/후드 미오염) | 0행 ✅ |
| 사후 멱등 재실행 | INSERT 0 0 ✅ |
| 사후 견적 실증 | PRODUCT_PRICE unit×qty 정상 ✅ |

## 4. 견적 검증 (evaluate_price 산식 재현)

엔진 우선순위(pricing.py L404-410): ① PRODUCT_PRICE(상품직접단가) → ② FORMULA.
product_prices 적재로 source=PRODUCT_PRICE, `base_amount = unit_price × qty` 적용 → 견적 0원 해소.

| prd | unit | qty=1 | qty=10 |
|-----|------|-------|--------|
| 카드거울 PRD_000185 | 2500 | 2500 | 25000 |
| 말랑포카홀더 PRD_000223 | 14000 | 14000 | 140000 |
| 캔버스 포켓숄더백 PRD_000272 | 58000 | 58000 | 580000 |

## 5. 안전 준수

- 라이브 쓰기 = 이 작업만(GP-1 product_prices INSERT 26행). 기초코드 마스터 불변.
- 단가 verbatim 불변·search-before-mint(신규 prd/siz 채번 0).
- undo 보유: `undo.sql`(apply_ymd=2026-06-10 대상 26행 DELETE).
- 비밀값 비노출.

## 6. 산출물

- `mapping.csv`(26 prd·단가·출처) · `apply.sql`(BEGIN/COMMIT 미내장 멱등 INSERT)
- `backup.sql` · `undo.sql` · `verbatim-guard.csv` · `post-verify.md` · `exec-report.md`

## 7. 후속(이번 범위 외)

- R-GP4-5: GP-2 variant FORMULA 바인딩 — 반팔티셔츠·후드티셔츠 포함(보류분).
- R-GP4-8: 말랑포카홀더 볼체인 addon SKU.
- 나머지 GP-2/PROC/COUNT 등 동형 클래스 base — 각 트랙 인간 승인 후.
