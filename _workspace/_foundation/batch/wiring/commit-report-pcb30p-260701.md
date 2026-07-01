# 엽서북30p PRD_000094 라이브 COMMIT 리포트 — 2026-07-01

§27 배선 서브트랙. 고아 `COMP_PCB_S1_30P`·`COMP_PCB_S2_30P`(30페이지 완제품가) 미배선 → 30p 손님 저청구(20p로 청구) 해소.

## 배경 (오진단 3회 정정 끝 확정)
- 094 엽서북 = 셋트(내지095+표지096=생산정보). **가격은 셋트 완제품 공식 `PRF_PCB_FIXED`가 통째 단가표 계산**(가격표260527 verbatim).
- `evaluate_set_price`(pricing.py:920)가 셋트 완제품 공식을 `set_selections`+copies로 호출 → 셋트 해제 불요·데이터만 COMMIT.
- 30p 미배선(고아)이라 셋트 완제품 공식이 30p 미평가 → 20p 고정 청구(저청구).

## 백엔드 경로 검증 (코드 3계층 — COMMIT 전)
| 계층 | 파일:라인 | 확인 |
|---|---|---|
| 엔진 | pricing.py:920 | set_selections → evaluate_price selections → `_row_matches`(L94) opt_cd(NON_QTY_DIMS) 매칭 |
| 뷰 | price_views.py:1921 | set_selections 키 화이트리스트 없이 통과 → 클라이언트 opt_cd 전달 |
| sim_meta | price_views.py:1333-1368 | formula_components use_dims `opt_grp:OPT_000082` 스코프 수집 → opt_cd 드롭다운(20P/30P) 한정 노출 |

★주의(C트랙 메모): sim_meta opt_cd 드롭다운(L1360)은 mat_cd(L1359)와 달리 `dflt` 미방출 → 시뮬레이터는 운영자 수동 선택 필요. 위젯(§6)은 옵션그룹 `dflt=20P·mand_yn=Y`로 사전선택(20p 회귀방지)—위젯 계약.

## 실행 (인간 승인 하)
- 채번 라이브 재확인: MAX opt_grp=OPT_000081·MAX opt_cd=OPV_000490 → OPT_000082·OPV_000491/492 free.
- dryrun: 멱등(재실행 INSERT 0 0)·검증1~4 통과·ROLLBACK.
- COMMIT `pcb30p-fix.sql`: 옵션그룹1+옵션2 INSERT·판별차원 UPDATE(234+117+117)·use_dims UPDATE(4)·배선 INSERT(2).
- 사후검증: 배선 4행·판별NULL 0·옵션값 2.

## 골든 6/6 (결정론 엔진매칭 재현 — `_row_matches`+min_qty 티어)
| 케이스 | 매칭 comp | 단가 | 계산가 | 골든 | 판정 |
|---|---|---|---|---|---|
| 30p단면 100x150 q2 | S1_30P | 11,500 | 23,000 | 23,000 | PASS |
| 30p단면 100x150 q4 | S1_30P | 9,900 | 39,600 | 39,600 | PASS |
| 30p양면 100x150 q2 | S2_30P | 12,500 | 25,000 | 25,000 | PASS |
| 30p단면 135x135 q2 | S1_30P | 12,500 | 25,000 | 25,000 | PASS |
| 20p단면 100x150 q2 [회귀] | S1_20P | 11,000 | 22,000 | 22,000 | PASS |
| 20p양면 100x150 q2 [회귀] | S2_20P | 11,500 | 23,000 | 23,000 | PASS |

각 케이스 disjoint(정확히 1 comp 매칭). 30p 저청구 해소(+500~3,200/건)·20p 회귀 0.

## 산출물
- `pcb30p-fix.sql`(COMMIT본)·`pcb30p-undo.sql`(롤백)·`pcb30p-usedims-backup-260701.tsv`(원본 use_dims 백업).
- 배선 재스캔: 결함 **17 → 15**(고아 9→7). `wiring-status.json` round 11.

## 잔여 / C트랙
- 시뮬레이터 opt_cd 드롭다운 dflt 방출(price_views.py:1360) = 개발팀 C트랙(선택). 데이터는 COMMIT 완료·위젯 계약으로 회귀가드.
