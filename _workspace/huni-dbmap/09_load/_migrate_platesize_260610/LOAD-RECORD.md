# 판형사이즈 누락분 등록·매핑 — 라이브 COMMIT 기록

> **적재 2026-06-22** · 하네스 §7 Huni-DBMap · **실 COMMIT 완료(인간 승인)** · 되돌리지 말 것(별도 롤백 SQL 보유).

## 적재 내용 (순수 추가 INSERT)

### t_siz_sizes — 신규 전지 siz 2종
| siz_cd | siz_nm | work | cut | impos | tags | output 계열 | note |
|---|---|---|---|---|---|---|---|
| `SIZ_000521` | 330x470 | 330x470 | 320x460(5mm) | Y | ["46전지"] | 46계열 | 반칼 스티커 표준전지 |
| `SIZ_000522` | 315x467 | 315x467 | 305x457(5mm) | Y | ["국전계열"] | 국전계열 | 투명소재 전지 |

- search-before-mint 통과(라이브 부재 확인). 채번=MAX+1(520→521/522). 마진 5mm=SIZ_000499 하우스 컨벤션.
- 권위: 상품마스터260610 출력용지규격 + 가격표 판걸이수/출력소재(IMPORT).

### t_prd_product_plate_sizes — 매핑 14건
- **330x470(SIZ_000521·OUTPUT_PAPER_TYPE.02)** ← 반칼 스티커 11종: PRD_000052/053/054/058/059/060/061/062/063/064/065.
- **315x467(SIZ_000522·OUTPUT_PAPER_TYPE.01)** ← 투명류 3종: PRD_000019(투명엽서)·PRD_000025(투명포토카드)·PRD_000039(투명명함).

## 검증
- DRY-RUN: 1차 +2/+14, 2차 멱등 델타 0, 제약위반 0, ROLLBACK 무변경.
- COMMIT: `INSERT 0 2` + `INSERT 0 14`. 단일 트랜잭션·ON_ERROR_STOP.
- 사후: siz_total 522 · plate_active 438. 신규 14행 + 상품명 join 확인.

## 산출/롤백
- SQL: `register_and_map.sql` · 백업: `backup_before_20260622_203714_plate.csv` · 롤백: `backup_before_20260622_203714_rollback.sql`(siz 2 + plate 14 DELETE).

## 미적용(후속·별도 승인)
- **기존 작업사이즈 plate 행 제거(collapse)** — 14상품에 신규 전지행이 추가됐으나 기존 작업사이즈 plate 행은 잔존(이중 plate). 정리는 `08_remediation/plate-size-remediation-260610.md` 트랙 A/B로 인간 승인 후.
- 잔여 차단 3상품(떡메모지·레더링바인더·링바인더보류)·표기 정규화 플래그.
