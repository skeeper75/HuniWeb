# price211-fixedgrid (slice C3) — 실사 고정가형 PRICE 적재 실행본

실사 시트 **고정가형 15상품**의 가격을 인쇄상품 가격표 **"포스터사인"** 시트 고정가형
블록(**[수량(행) × 규격(열)]**)을 권위로 `t_prc_component_prices` 에 적재(CORRECTION+
EXPANSION). 엔드포인트 = **적재 실행본**(멱등 SQL + DRY-RUN 계획). **DB 무쓰기.**

## USER HARD RULE (적용 명시)
- 가격 권위 = 포스터사인 가격표 **고정가형 [수량×규격]** 명시값. **실사 inline R/S/V 미사용.**
- **[HARD] 면적매트릭스([가로×세로]) 아님 = 고정가형([수량×규격])이다.** slice A
  (`02_mapping/silsa-poster-area-matrix/`)와 혼동 금지. 면적-좌표 모델 강제 금지.
- 메모리 `dbmap-silsa-price-via-poster-sign` + `dbmap-price-formula-types-authority` 적용.

## 결과 한눈에
- **15상품 / 17 comp_cd / 73 long-form 행** ([수량×규격] 평면화).
- **INSERTABLE 73 · BLOCKED 0** (규격 siz_cd 18종 전부 라이브 선존재).
- **라이브 대조**: 멱등 no-op 63 + EXPANSION fill 10 + 단가충돌 0 + stale 변칙 0.
- **신규 mint 0**: comp/siz/formula/binding 전부 라이브 선존재. **단가 행만 적재.**

## live-vs-doc 모순 (적발)
메모리/slice A 문서는 "round-2 가 이 15를 **면적-좌표로 오모델**"이라 단정하나, 라이브
실측 결과 round-2 는 실제로는 **고정가형 [수량×규격]으로 비교적 정확히 적재**(단가 100%
일치)했고 일부 규격 셀(A1·소형 4규격)만 누락했다. → 본 트랙 = **면적-좌표 정정이 아니라
sparse 셀 누락 채움(EXPANSION 10셀)**. (상세 `mapping.md §1.3`.)

## 파일
| 파일 | 내용 |
|------|------|
| `mapping.md` | 매핑 설계서 (USER RULE·상품↔comp↔siz·라이브대조·제약·설계결정) |
| `load/t_prc_component_prices_INSERTABLE.csv` | 적재 단가 73행 (헤더=DB 컬럼명, 공란=NULL) |
| `load/t_prc_component_prices_BLOCKED.csv` | 차단 0행 (헤더만 — 정직 분리) |
| `load.sql` | 멱등 INSERT(NOT EXISTS) + 단계0 FK검증 + setval 가드. 기본 ROLLBACK |
| `dryrun-plan.md` | DRY-RUN 게이트 + 설계자 사전점검(R1~R6) |

## 적재 절차 (인간 승인 시)
1. `dryrun-plan.md` R1~R6 확인.
2. `load.sql` 을 롤백전용으로 라이브 DRY-RUN (BEGIN…ROLLBACK; 멱등 2-pass 검증).
3. 1차 10행 INSERT / 2차 0행(멱등) 확인 후 ROLLBACK→COMMIT 교체 (인간 승인).
4. **NO DB WRITE** — 본 산출물은 생성·검증 단계까지. 실제 COMMIT·F-WIRE 배선은 별도 승인.

## 멱등성 핵심 함정 (load.sql 주석 참조)
자연키 UNIQUE 인덱스 `ux_t_prc_comp_prices_nat_key` 가 **NULLS DISTINCT(기본)** 이므로
NULL 차원(clr/mat/coat/bdl/일부 min_qty)을 가진 본 행들은 `ON CONFLICT(자연키)`가
**트리거되지 않는다** → 재실행 시 중복 INSERT. 따라서 **`NOT EXISTS(IS NOT DISTINCT FROM)`
가드**로 NULL-aware 멱등을 보장한다(ON CONFLICT 미사용).

## 미해결 (인간 확인)
- **D-WIRE**: formula_components 배선 부재(`PRF_POSTER_FIXED`에 본 17 comp 0배선, 라이브
  ARTPRINT 1개뿐). 가격엔진 prd→comp 조회 경로 GAP. 별도 배선 트랙 + slice A over-claim 정정.
- **D-A1**: A1=SIZ_000293 채택(명명 `A1(594x841mm)`, A2/A3 단순명명과 패턴 상이).
