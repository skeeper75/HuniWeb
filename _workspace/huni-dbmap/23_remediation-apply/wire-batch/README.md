# wire-batch — WIRE 통합 배선 실행본 (round-21 시스템 결함 일괄)

round-21 6사이클이 밝힌 **시스템 결함 = 가격 공식사슬 배선(WIRE) 누락**을 일괄 해소하는 멱등 배선 실행본.
4 WIRE 제안본(전부 게이트 GO)을 재설계 없이 실행본화. **빌드 + 롤백전용 DRY-RUN까지**(실 COMMIT = 인간 승인).

## 파일

| 파일 | 역할 |
|------|------|
| `inventory.md` | Phase A 인벤토리·분류(순수배선/공식분리/범위밖) |
| `00_formulas.sql` | 공식분리 신규 PRF_* (NAMECARD PREMIUM/COAT · SILSA BANNER_NORMAL) |
| `01_formula_components.sql` | 공식↔comp 배선 14건 |
| `02_bindings.sql` | 상품 바인딩 frm_cd UPDATE 3건 |
| `03_matgroup_copy.sql` | 명함 033 STD 단가행 verbatim 복제 6건(값 불변) |
| `apply.sql` | 단일 트랜잭션 래퍼(FK순·ON_ERROR_STOP) |
| `apply_loader.sh` | psql 로더(**기본 DRY-RUN**·--commit 인간승인) |
| `manifest.md` | 매니페스트(배선 건수·멱등·단가행 불변·D-1b 의존) |
| `dry-run-result.md` | 라이브 2-pass DRY-RUN 결과 |

## 실행

```bash
./apply_loader.sh            # DRY-RUN (BEGIN…ROLLBACK·라이브 무변경·기본)
./apply_loader.sh --commit   # 실 COMMIT (인간 승인 + 엔진 동시배포 선결)
```

## 안전 [HARD]

- **돈-크리티컬**: `t_prc_component_prices.unit_price` 절대 불변. 배선은 formula_components/공식/바인딩, MATGROUP은 verbatim 복제(신값 0). 보정 하드코딩 0.
- **멱등**: 재실행 delta 0(라이브 PK 실측 충돌키). DRY-RUN 2-pass 입증.
- **동시배포**: 배선·신규공식은 엔진 룩업/모드분기 해석 규칙(webadmin Phase11) + D-1b `.03` 규칙과 **반드시 동시 배포**. 배선 단독 적용 = 미정의 동작.
- **자기승인 금지**: R1~R6 = `dbm-validator` 독립 게이트.

## 범위 경계

- **D-1b 중복 금지**: prc_typ 메타 정정은 `../d1b-prctyp/`(기존)·본 트랙은 배선만.
- **SILSA 대표만**: 138 BANNER_NORMAL 1소재 종단. 27상품 전파 = round-16 import.xlsx 별트랙.
- **범위밖**: 스티커 STK-AXIS·아크릴 이중전무·SILSA 격자/CPQ(`inventory.md` §1).
