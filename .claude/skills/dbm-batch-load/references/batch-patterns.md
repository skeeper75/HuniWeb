# 배치 적재 상세 패턴 (dbm-batch-load references)

## 동형 클래스 판정 (S1 상세)
동형 = **(옵션구성 시그니처, 가격계산방식)** 동일. 표면 시트 무관.
- 가격계산방식 = round-18+ 가격공식 15클래스(`26_price-engine-verify/_class-map.md`): PRF_DGP_A 합산형·PRF_POSTER_FIXED 면적매트릭스·PRF_NAMECARD_FIXED 고정가형 등.
- 옵션구성 = option_groups 타입 패턴(택1/택N) + 차원 참조(자재/공정/사이즈).
- 같은 클래스 예: 엽서·상품권 둘 다 PRF_DGP_A 합산형 → 한 배치. / 명함·포토카드 둘 다 고정가형 → 한 배치.

## 상태 분류 기준 (S1)
| 상태 | 기준 | 처리 |
|------|------|------|
| ready | use_yn=Y · 기초 차원(siz/mat/proc) 적재 · plate 정합 · 가격사슬 배선 존재 | 배치 대상 |
| pending | 신규출시예정 · 컬럼 완정성 미확인(NULL 다수·plate 미교정) | 선결 트랙 후 재진입 |
| unlisted | use_yn=N · 정체 미확정 | 제외 |

## 기존 스크립트 자산 재사용 (중복 작성 금지)
| 자산 | 용도 |
|------|------|
| `06_extract/scripts/extract_l1.py·extract_price*.py` | 엑셀 → L1 CSV(권위) |
| `02_mapping/scripts/gen_foil_load.py·build_engine_tables.py` | L1 → t_* 적재 CSV(클래스별 변환 규칙 참고) |
| `20_price-import/*/build_import_workbook.py` | 시트별 가격 그릇 분해 |
| `09_load/_exec_safeload_260614/apply.sh` | BEGIN…ROLLBACK·commit 패턴 원형 |

gen_batch_upsert.py는 이들 산출 CSV를 입력으로 **멱등 UPSERT SQL**만 생성(변환 로직 중복 금지).

## 집계 검증 V5 staged diff (S4)
가격 권위 대조 = 가격표 L1을 임시 테이블로 올려 SQL JOIN diff:
```sql
CREATE TEMP TABLE stg_price (comp_cd text, mat_cd text, siz_cd text, min_qty int, unit_price numeric);
\copy stg_price FROM 'price_l1.csv' CSV HEADER
SELECT count(*) FROM stg_price g
  JOIN t_prc_component_prices cp USING (comp_cd, mat_cd, siz_cd, min_qty)
  WHERE round(g.unit_price,2) <> cp.unit_price;  -- = 0 이면 권위 일치
```
TEMP 테이블은 트랜잭션/세션 종료 시 자동 소멸(라이브 무흔적).

## 멱등 NOT EXISTS 가 ON CONFLICT 보다 옳은 이유
자연키 인덱스 `ux_t_prc_comp_prices_nat_key.indnullsnotdistinct=f`(NULLS DISTINCT) → NULL 차원 컬럼이 있는 단가행은 `ON CONFLICT`가 **미발화**(중복 INSERT). `WHERE NOT EXISTS (… IS NOT DISTINCT FROM …)`는 NULL-safe로 진짜 중복을 막는다. [[dbmap-live-load-transition-260615]] 실증.

## 배치 단위 권장 순서
1. 선결 PASS + 멤버 많은 동형 클래스부터(ROI).
2. 선결 미달(plate 미교정·siz 미등록)은 선결 트랙(correctness/ddl-proposer) 먼저.
3. 가격엔진(evaluate_price) 미구현 의존 클래스(D-1b 등)는 엔진 동시배포 필요분과 분리.
