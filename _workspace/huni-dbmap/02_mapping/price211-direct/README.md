# price211-direct — DIRECT-PRICE 트랙 (Phase-1 slice B)

211 무가격 상품의 **직접가(B) 경로** 매핑 + 적재 실행본. 타깃 `t_prd_product_prices`.
**DB 미적재**(생성 트랙 — INSERT/DDL/COMMIT/git 커밋 없음). 검증은 dbm-validator 별도.

## 산출물
| 파일 | 내용 |
|------|------|
| `mapping.md` | 매핑 설계서(스키마 타깃·family별 매핑·PK트랩·FK순·C게이트·FLAG·라이브-vs-계획 모순) |
| `dryrun-plan.md` | 라이브 DRY-RUN **계획**(미실행. R1~R6 게이트·멱등2pass·기대결과) |
| `load.sql` | 멱등 `INSERT … ON CONFLICT DO UPDATE`, 단일 트랜잭션, **reg_dt OMIT(DEFAULT)**, 73행, 끝 ROLLBACK |
| `load/t_prd_product_prices.csv` | INSERTABLE 73행(헤더=DB 컬럼명: prd_cd,apply_ymd,unit_price,note) |
| `load/BLOCKED_DECISION_option_variant.csv` | 옵션변형 PK충돌 43+9건(Phase-0 DDL 라우트 명기) |
| `load/BLOCKED_DATA.csv` | 가격공란5 + 미등록(prd_cd부재)5 + 노트/플래너 out-of-source 10 |
| `load/BLOCKED_OTHER_TRACK_F8.csv` | F8 3건(digital-print-engine 3절/투명 차단) |
| `_live/` | read-only 실측 산출(211목록·분류 json·FK체크 sql) — 추적용 |

## 카운트 요약
| 버킷 | 수 | 비고 |
|------|:--:|------|
| **INSERTABLE (direct price)** | **73** | F1-goods 59 · F1-accessory 6 · F6 5 · F7 3 |
| BLOCKED-DECISION (옵션변형) | 43 | goods 34 + accessory 9(카드봉투 1건은 .05 분할로 해소) |
| BLOCKED-DATA | 20 | 공란5 + 미등록5 + 노트/플래너10 |
| BLOCKED-OTHER-TRACK (F8) | 3 | 투명엽서·지그재그엽서·와이드접지리플렛 |

F1-123 정산: 65 INSERTABLE + 43 DECISION + 15 DATA(prd_cd有) = 123(누락0) + 미등록5(prd_cd無).

## 핵심 트랩(처리완료)
- **PK 충돌**: 한 prd_cd 다중가(머그컵 6500/7500 등) → 직접가 강행 금지 → BLOCKED-DECISION.
- **F8 침묵 NULL**: 바인딩만 하면 component_prices 미커버로 가격 NULL → BLOCKED-OTHER-TRACK.
- **reg_dt NOT NULL DEFAULT now()**: 컬럼 OMIT으로 DEFAULT 발화(명시 NULL 금지).
- **F7 .03↔.05 동명**: INSERTABLE=.05 분할판만(PRD_000281/282/283).

## 실행 (인간 승인 후에만)
`load.sql` 끝 `ROLLBACK`을 `COMMIT`으로 교체. 그 전엔 절대 적재 금지.
