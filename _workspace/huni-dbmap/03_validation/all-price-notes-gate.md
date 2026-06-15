# 전 상품군 가격테이블 note 교정 — 독립 게이트 (N1~N6) | 판정: GO

> 검증자: dbm-validator (생성자≠검증자 — 빌더 산출은 권위 아님). 라이브 `railway` DB 읽기전용 + 롤백전용 DRY-RUN(2-pass).
> 검증 대상: `23_remediation-apply/all-price-notes/` (gen_notes.py·note-map.csv·01_update_notes.sql·apply.sql·apply_loader.sh·dry-run-result.md·manifest.md).
> 기준: 토대 §9-2(후니 용어) + 016 선례(`23_remediation-apply/016-notes/`·`17_correctness/postcard-016-price/note-remediation.md`).
> **COMMIT 0 — 모든 검증은 BEGIN…ROLLBACK. 라이브 무변경. 비밀번호 미출력.**

## 종합 — N1~N6 전건 PASS → GO

| 게이트 | 판정 | 근거 (독립 재측정) |
|--------|:--:|------|
| **N1 note-only(돈 회귀 차단)** | ✅ PASS | 라이브 DRY-RUN 독립: 단가행 비-note 지문 `md5(unit_price\|bdl_qty\|min_qty\|siz_cd\|clr_cd\|mat_cd\|proc_cd\|opt_cd\|apply_ymd)` 정정 전후 `b4bb0b77...` **동일**. 정의행 지문 `md5(prc_typ_cd\|comp_typ_cd\|comp_nm)` `ed6fd36e...` **동일**. `sum(unit_price)` 76,884,888.51 → **76,884,888.51 동일**. 단 1행도 비-note 컬럼 미변경. |
| **N2 멱등성** | ✅ PASS | 단일 트랜잭션 2-pass: PASS1 변경 2,172행(정의 115 UPDATE 1×115문 + 단가 1블록 UPDATE 2057). PASS2 비-제로 UPDATE **0건**. note 전역 지문(정의 `c891a9de...`·단가 `b476a3d0...`) PASS1 후 == PASS2 후 **동일**. `IS DISTINCT FROM` 가드·no-op regexp 실재. |
| **N3 전역 전문용어 잔존 0** | ✅ PASS | PASS1 후 라이브 정의행 전문용어 14패턴 **0**, 단가행 **0**(독립 grep). 깨진 괄호 잔재(`BROKEN_PAREN`=닫는>여는) 라이브 **0** + note-map.csv `corrected_note` 2,172행 독립 grep **0**. regexp 중첩 괄호 버그 잔재 없음. |
| **N4 의미 정확·후니 용어** | ✅ PASS | 상품군 다양 표본(아크릴·책자·캘린더·합판/굿즈·봉투·명함[표준/박/펄/화이트]·포토카드·포스터·아크릴스티커·카드/리플렛접지) 라이브 인용 정정 전후 대조: 소재·색·도수·사이즈·축·포함가/추가가·`[묶음 동일단가]`·`[출력가]`·`[코팅포함가]` 전부 보존, 내부 메모(코드/식별자/정정이력)만 제거. 후니 용어(완제품가·후가공·오시+접지·용지포함) 유지·경쟁사 용어 미덮음. 의미 왜곡·과도 삭제 **0**. |
| **N5 트랜잭션·실행가능성** | ✅ PASS | apply.sql 단일 `BEGIN;`+`\i 01_update_notes.sql`(COMMIT/ROLLBACK은 로더 주입). `\set ON_ERROR_STOP on` 존재, 01_update_notes.sql 내 BEGIN/COMMIT 중첩 0. 라이브 파싱·2-pass 무오류 완료 후 ROLLBACK. **SQL↔Python 동치**: 라이브 apply 후 단가행 note vs note-map.csv corrected 2,057행 대조 **mismatch 0**(byte-identical). |
| **N6 독립성·FLAG** | ✅ PASS | 빌더 숫자 독립 재현: 정의 jargon 115·단가 jargon 2,057·합계 2,172, sum(unit_price) 76,884,888.51 — 전부 일치. FLAG_UNCLEAR **0**: 라이브 표본에서 모든 모호 comp가 의미 보존 교정 가능, corrected_note 전수 잔존 0이 결과(추측 라벨 mint 없음·정당). |

## N1 가격행 회귀 0 (라이브 DRY-RUN 실측)

```
단가행 비-note 지문   before b4bb0b7727e633c0db23485f3a21544d == after 동일
정의행 비-note 지문   before ed6fd36e0287116f86dbcfbd4b0bd3c4 == after 동일
sum(unit_price)      76,884,888.51 → 76,884,888.51 (동일)
SET 절 = note · upd_dt 둘뿐 (라이브 실증)
```
(단가행 t_prc_component_prices에 prc_typ_cd 컬럼 부재 — prc_typ_cd는 정의행에만 존재[전부 PRICE_TYPE.01·144], SET 절 미포함으로 불변. 016 게이트 관찰과 동일.)

## N2 멱등성 — DRY-RUN 2-pass

| 테이블 | PASS1 변경 | PASS2 비-제로 UPDATE | note 지문 after1==after2 |
|--------|:--:|:--:|:--:|
| t_prc_price_components(정의) | 115 | 0 | c891a9de... 동일 |
| t_prc_component_prices(단가) | 2,057 | 0 | b476a3d0... 동일 |
| **합계** | **2,172** | **0** | |

## N3 전문용어 잔존 0 — 양쪽 실측 + regexp 버그 점검

| 검사 | 라이브 PASS1 후 | note-map corrected |
|------|:--:|:--:|
| 14패턴 전문용어(정의+단가) | 0 | 0 (2,172행) |
| 깨진 괄호(닫는>여는) | 0 | 0 (2,172행) |

## N4 의미 보존 표본 (라이브 인용, 현재 → 교정)

| comp_cd | 현재(라이브) | 교정 |
|---------|------|------|
| COMP_ACRYL_CLEAR15T (아크릴) | `투명아크릴1.5T 가로20mm×세로20mm 면적단가 (라이브 siz SIZ_000336 실코드, M-1정정 DIRECT매칭)` | `투명아크릴1.5T 가로20mm×세로20mm 면적단가` |
| COMP_FOLD_CARD_2H (카드접지·합가) | `카드접지/2단 제작수량≥1 (오시+접지 합가, comp_typ=.04 후가공, 옵션=comp흡수) [묶음 동일단가: 2단가로접지 / 2단세로접지]` | `카드접지/2단 제작수량 1 이상 / 작업 1건 고정 금액(수량을 곱하지 않음) [묶음 동일단가: 2단가로접지 / 2단세로접지]` |
| COMP_NAMECARD_FOIL_S1_STD (박명함·합가) | `오리지널박명함 종이+동판+박가공비 합가 단면/금유광, 은유광… 제작수량≥200 (규칙④ 합가)` | `오리지널박명함 종이+동판+박가공비 합가 단면/금유광, 은유광… 제작수량 200 이상 / 작업 1건 고정 금액(수량을 곱하지 않음)` |
| COMP_NAMECARD_STD_S1 (명함) | `스탠다드명함/단면/백모조220 / 아트250 / 스노우250 제작수량≥100 (용지포함 단품가 행39, 명함종+면=comp흡수, 소재군=대표mat/흡수)` | `스탠다드명함/단면/백모조220 / 아트250 / 스노우250 제작수량 100 이상` |
| COMP_GANGPAN_PRINT (합판/굿즈) | `[siz-corrected: SIZ_PENDING_GP_원형35mm→SIZ_000422] 원형 35mm/비코팅/무광코팅/유광코팅 제작수량≥1000 (…)` | `원형 35mm/비코팅/무광코팅/유광코팅 제작수량 1000 이상` |
| COMP_ENV_MAKING (봉투) | `[siz: ENV_TICKET→SIZ_000191] 봉투제작/티켓봉투/모조 120g 제작수량≥1000 (완제품가 .06)` | `봉투제작/티켓봉투/모조 120g 제작수량 1000 이상` |
| COMP_PHOTOCARD_SET (포토카드) | `포토카드(20장1세트) 세트단가 (1세트=20장→bdl_qty=20, 55x86=SIZ_000012, 세트단위)` | `포토카드(20장1세트) 세트단가` |
| COMP_POSTER_ACRYLSTK_GLOSS (포스터/아크릴스티커) | `아크릴스티커(유광/미러)/유광 (화이트 / 블랙)/290 x 90 mm 완제품가[유광/미러] (중첩서브제품 추출결함보정, 라이브 siz SIZ_000324 실코드, …)` | `아크릴스티커(유광/미러)/유광 (화이트 / 블랙)/290 x 90 mm 완제품가[유광/미러]` |

## N5 SQL↔Python 동치 / 실행가능성

라이브 단가행 결정적 regexp 체인 결과 vs note-map.csv corrected: **2,057행 비교 mismatch 0**(byte-identical). apply.sql 단일 트랜잭션·ON_ERROR_STOP·중첩 COMMIT 0·롤백 후 라이브 jargon 2,172 그대로(무변경).

## 차단/에스컬레이션

- **실제 COMMIT (`./apply_loader.sh commit`)** — 인간 승인 대기. 이 게이트는 검증 전용·자기승인 안 함.
  GO 판정 + 사용자 라이브 반영 승인은 확인됨 → 후니/사용자가 COMMIT 실행.

## 검증 환경

라이브 읽기전용 SELECT + 롤백전용 DRY-RUN(2-pass)만 수행. 쓰기/COMMIT 0. 비밀번호 미출력.
