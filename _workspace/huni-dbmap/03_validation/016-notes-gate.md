# 016 프리미엄엽서 note 교정 — 독립 게이트 (N1~N6) | 판정: GO

> 검증자: dbm-validator (생성자≠검증자 — 빌더 산출은 권위 아님). 라이브 `railway` DB 읽기전용 + 롤백전용 DRY-RUN.
> 검증 대상: `23_remediation-apply/016-notes/` (note-map.csv·01_update_notes.sql·apply.sql·apply_loader.sh·manifest.md·dry-run-result.md·gen_remediation_sql.py).
> 교정 원칙: `17_correctness/postcard-016-price/note-remediation.md` + 토대 §9-1.
> **COMMIT 0 — 모든 검증은 BEGIN…ROLLBACK. 라이브 무변경. 비밀번호 미출력.**

## 종합 — N1~N6 전건 PASS → GO

| 게이트 | 판정 | 근거 (독립 재측정) |
|--------|:--:|------|
| **N1 note-only(돈 회귀 차단)** | ✅ PASS | DRY-RUN 독립 실행: 단가행 비-note 컬럼 변경 **0**(unit_price·siz_cd·clr_cd·mat_cd·coat_side_cnt·bdl_qty·min_qty·apply_ymd·proc_cd·opt_cd), 정의행 비-note 변경 **0**(prc_typ_cd·comp_typ_cd·comp_nm). `sum(unit_price)` 정정 전후 **18,509,572.51 동일**. |
| **N2 멱등성** | ✅ PASS | 단일 트랜잭션 2-pass: PASS1 변경 1,432행 재현, PASS2 모든 UPDATE 문 **UPDATE 0**(정의행 29 + 단가행 regexp + 용지비 suffix 전부). after1=after2 (price 1410=1410, def 29=29). `IS DISTINCT FROM` 가드·no-op regexp 실재. |
| **N3 전문용어 잔존 0** | ✅ PASS | PASS1 후 라이브 단가행 13개 마커(`[siz-corrected`·`comp_typ`·`PRC_COMPONENT_TYPE`·`clr=NULL`·`별색=공정`·`옵션=comp흡수`·`(합가`·`round-2`·`SIZ_`·`mat_cd`·`siz_cd`·`≥`·`C-4`) **전부 0**. 정의행 7개 마커 **전부 0**. note-map.csv `corrected_note` 1,432행 python 독립 grep도 **전부 0**. |
| **N4 의미 정확(틀린 라벨 mint 차단)** | ✅ PASS | 표본 9 comp 라이브 인용: 출력축(인쇄·코팅 `출력매수 N장 이상`=장당단가) vs 주문축(후가공 `주문수량 N건 이상 / 작업 1건 고정 금액`) 정확 구분. 구성요소·사이즈(국4절)·도수(흑백/별색)·면수(단면/양면) 원 의미 보존. 뜻 왜곡 0. |
| **N5 트랜잭션·실행가능성** | ✅ PASS | apply.sql 단일 `BEGIN;` + `\i 01_update_notes.sql`(COMMIT/ROLLBACK은 주석뿐 — 로더가 주입). `\set ON_ERROR_STOP on` 존재. 01_update_notes.sql 내 BEGIN/COMMIT/ROLLBACK 중첩 0. SQL 라이브 파싱·실행 무오류(2-pass 정상 완료). 롤백 후 라이브 무변경. |
| **N6 독립성** | ✅ PASS | 빌더 숫자 독립 재현: 행수 1,432(정의 29+단가 1,354+용지 49), sum(unit_price) 18,509,572.51, comp 29종 사슬 목록 일치. 검증자 자체 SQL로 재측정(빌더 dry-run-result 미신뢰). |

## N1 가격행 회귀 0 (라이브 DRY-RUN 실측)

```
단가행 비-note 컬럼 변경 행수      : 0
정의행 비-note 컬럼 변경 행수      : 0
sum(unit_price) 정정 전           : 18,509,572.51
sum(unit_price) 정정 후           : 18,509,572.51   (동일)
SET 절 = note · upd_dt 둘뿐 (라이브 실증)
```

## N2 멱등성 — DRY-RUN 2-pass

| 테이블 | PASS1 변경 | PASS2 변경(delta) | after1 | after2 |
|--------|:--:|:--:|:--:|:--:|
| t_prc_price_components(정의) | 29 | 0 | 29 | 29 |
| t_prc_component_prices(단가, regexp) | 1,354 | 0 | 1410 | 1410 |
| t_prc_component_prices(용지비 suffix) | 49 | (위 1410에 포함) | — | — |
| **합계** | **1,432** | **0** | | |

## N3 전문용어 잔존 0 — 양쪽 실측

| 마커 | 라이브 단가행(PASS1 후) | 라이브 정의행 | CSV corrected_note |
|------|:--:|:--:|:--:|
| 13개 식별자/마커 전체 | 0 | 0 | 0 (1,432행 전수) |

## N5 라이브 DRY-RUN — 제약 위반

제약 위반 **0** (UPDATE는 note·upd_dt만 변경 — 타입/길이/NOT NULL/CHECK/FK/PK 무영향). ON_ERROR_STOP=1 하 2-pass·N1·N4 DRY-RUN 모두 abort 없이 완료 후 ROLLBACK.

## 관찰(결함 아님)

- 사용자 지시의 "prc_typ_cd distinct"는 **단가행(t_prc_component_prices)에 prc_typ_cd 컬럼이 부재** — prc_typ_cd는 정의행(t_prc_price_components)에만 존재(라이브 information_schema 확인). 정의행 prc_typ_cd 분포(전부 PRICE_TYPE.01)는 UPDATE SET 절에 미포함 → N1로 불변 보증. 빌더 dry-run-result가 단가행 회귀 컬럼 목록에 prc_typ_cd를 넣지 않은 것은 정확.
- 별색 단가행 note가 "디지털인쇄 출력비/별색(금색)" 표기 — 별색이 출력 단가표를 공유하는 사슬 설계 반영(별색=공정이나 단가는 출력비 매트릭스 공유). 의미 왜곡 아님.

## 차단/에스컬레이션

- **실제 COMMIT (`./apply_loader.sh commit`)** — 인간 승인 대기. 이 게이트는 검증 전용·자기승인 안 함. GO 판정 + 사용자 라이브 반영 승인 확인 후 후니/사용자가 COMMIT.
