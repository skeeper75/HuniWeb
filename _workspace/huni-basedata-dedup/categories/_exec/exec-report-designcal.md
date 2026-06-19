# exec-report-designcal.md — 디자인캘린더 동형 교정 적재 (가)+(나)

실행: 2026-06-19 / 에이전트: hbd-load-executor / 트랙: 기초데이터 표시중복 정리 하네스(카테고리 축 추가)
권위: empty-node-analysis.md v2 (MAP 권위 동형 교정) / 사용자 승인: (가)+(나) 둘 다 확정.

## 실행 대상 (승인 확정 3조건 충족)
- (가) 노드 논리삭제: CAT_000318·319·320 (상품을 카테고리로 오모델한 잉여 L3). CAT_000118 유지.
- (나) 상품 귀속: PRD_000108·110·111 → CAT_000118 junction 다중분류(main='N' 보조).

## junction 실제 컬럼 구조 (라이브 information_schema 실측)
| 컬럼 | 타입 | NULL | default |
|------|------|------|---------|
| prd_cd | varchar | NO | (PK) |
| cat_cd | varchar | NO | (PK) |
| main_cat_yn | char | NO | — |
| disp_seq | int | YES | — |
| note | varchar | YES | — |
| reg_dt | timestamp | NO | now() |
| upd_dt | timestamp | YES | — |
- **PK = 복합 (prd_cd, cat_cd)**. INSERT 시 필수 = prd_cd·cat_cd·main_cat_yn(reg_dt는 DEFAULT now()이나 명시 now() 사용). 분석가 명세 컬럼 가정 라이브 검증 일치.

## 백업 테이블 (물리 스냅샷·고정 접미사)
| 백업 테이블 | 원본 | 행수 |
|-------------|------|------|
| bak_cat_designcal_nodes | t_cat_categories (318/319/320/118) | 4 |
| bak_prdcat_designcal_links | t_prd_product_categories (PRD 108/110/111 + cat 318/319/320/118) | 4 |

## DRY-RUN (롤백전용 + in-tx 멱등)
| op | pass1 | pass2 delta |
|----|:-----:|:-----------:|
| (가) UPDATE | 3 | 0 |
| (나) INSERT | 3 | 0 |
- CAT_000118 del='N' 유지 ✓ · FK 고아 0 ✓ · main='Y' 신규 0(전부 N) ✓ · 제약위반 0 ✓.

## COMMIT 결과 (psql -1 단일 트랜잭션·apply.sql 내장 BEGIN/COMMIT 없음)
- (가) UPDATE 3 (318/319/320 del='Y'·use='N')
- (나) INSERT 0 3 (108/110/111 → CAT_000118 main='N')

## 사후검증 V1~V7 (COMMIT 후 라이브 재실측)
| 게이트 | 결과 | 판정 |
|--------|------|------|
| V1 318/319/320 del='Y'·use='N' | 3행 전부 Y/N | PASS |
| V2 CAT_000118 del='N' 유지(미삭제) | del='N'·use='Y' | PASS |
| V3 junction (108/110/111, 118) main='N' 3행 | 3행 존재 | PASS |
| V4 기존 귀속(112/114/115) 무변경 append만 | 7행(기존4+신규3) 기존행 불변 | PASS |
| V5 main='Y' 단일성: 신규 'N'→새 'Y' 0 | 108=1·110=2·111=1 (변화 0) | PASS |
| V6 FK 고아 0·PK 중복 0 | 0행·0행 | PASS |
| V7 2-pass 멱등(재-apply delta 0) | UPDATE 0·INSERT 0 0 | PASS |

★PRD_110 main_y_count=2(CAT_000112+CAT_000114)는 **이번 적재 이전부터 존재한 §6 escalate 결함**(별 컴펜 큐)·이번 범위 밖·무접촉 보존.

## undo
`_exec/undo_designcal.sql` — (가) 318/319/320 del='N'·use='Y' 복원 + (나) (108/110/111, 118, main='N') DELETE. 백업 테이블 2종 풀복원 안전망 보유.

## 미접촉 보존 (지시 준수)
104 rename·이전 9공정 적재분·기타 노드·main 무결성 결함(PRD_108/111 main 결손·PRD_110 del 참조) 절대 미접촉.

## 게이트 판정
- **D5 (DRY-RUN GO): PASS** — 예상 delta 일치((가)3·(나)3)·멱등·제약위반0·FK무결성.
- **D6 (COMMIT+사후검증 GO): PASS** — COMMIT 3/3·V1~V7 전건 PASS·undo 보유.
