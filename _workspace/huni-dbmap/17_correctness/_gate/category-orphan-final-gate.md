# 카테고리 잔존고아 마무리 — 독립 검증 게이트 (category-orphan-final-gate)

> **검증자** dbm-validator (독립 — 생성자≠검증자) · **일자** 2026-06-14
> **대상** `23_remediation-apply/category-orphan-final/{apply,rollback}.sql`·manifest-worksheet·backup
> **방법** 라이브 직접 재실측(읽기전용) + 롤백전용 DRY-RUN(BEGIN…ROLLBACK, **COMMIT 0**)
> **종합 판정: GO** · 뒤집힘 0 · BLOCKER 0 · MAJOR 0 · MINOR 1(문서 표기, 적재 영향 없음)

---

## 게이트 1~8 (각 PASS/FAIL + 라이브 실측 근거)

### 1. 매핑 정확성 — PASS
라이브에서 12상품 prd_nm과 12 대상노드 cat_nm을 재조회해 의미 1:1 대조. 기계적 번호매칭 아님(예: PRD_000035 모양명함→CAT_000054 모양명함, 번호 비순차).
- 명함 10: 프리미엄/코팅/스탠다드/펄/모양/미니모양/오리지널박/형압/투명/화이트인쇄 = 전부 동명 1:1 (CAT_000048/49/50/51/54/55/56/57/52/53).
- 상품권 2: PRD_000041 스탠다드 쿠폰/상품권→CAT_000063 동명. PRD_000042 prd_nm="프리미엄 쿠폰/상품권" vs CAT_000064 cat_nm="프리미엄 상품권/쿠폰" — **어순 스왑이나 동일 의미**(프리미엄+쿠폰+상품권), 1:1 정당. → MINOR(이름 비완전일치는 manifest 주석 권장, 적재 영향 없음).

### 2. search-before-mint — PASS
대상 12노드 전부 라이브 실재, upr_cat_cd 정상(명함 10→CAT_000003 인쇄홍보물 직속, 상품권 2→CAT_000062 쿠폰/상품권 하위), use_yn='Y', **main_cat_yn='Y' 연결수=0(전부 비어있음)**. apply.sql 신규 노드 mint 0. 백업 파일의 "비어있음" 주장과 라이브 실측 일치.

### 3. 고아 노드 사실 — PASS
- CAT_000294(명함)·CAT_000295(상품권): upr_cat_cd **공백=NULL(고아 확정)**.
- 12상품이 거기 main_cat_yn='Y'로 묶임 — CAT_000294 main_y_cnt=10, CAT_000295 main_y_cnt=2. 백업 12행과 정확히 일치.

### 4. 멱등성 — PASS (구문 분석 + 라이브 2회차 실증)
- INSERT … ON CONFLICT (prd_cd,cat_cd) DO UPDATE … WHERE main_cat_yn IS DISTINCT FROM 'Y' → 이미 Y면 0행.
- UPDATE … WHERE cat_cd='CAT_000294/295' AND main_cat_yn='Y' → 이미 N이면 0행.
- **라이브 DRY-RUN 2-pass 실증**: PASS1 (1a=10,1b=10,2a=2,2b=2), **PASS2 전부 0행**(p2_1a/1b/2a/2b=0). 재실행 0행 보장 확인.

### 5. 비파괴성 — PASS
apply.sql에 DELETE/DROP/TRUNCATE 없음. 고아 연결은 논리강등(main_cat_yn='N'+upd_dt), 노드 자체 use_yn 변경 없음(컨펌대기/별도 트랙으로 정직 분리).

### 6. 롤백 정합 — PASS (DRY-RUN 실증)
apply 적용 후 rollback.sql 로직 실행 시: INSERT한 12행 DELETE(12), 고아 294/295 연결 main='Y' 복귀(10+2). 결과 rb_orphan_mainY=12·rb_target_mainY=0·rb_target_rows_remaining=0 → **정정 전 상태(백업과 일치)로 정확 원복**.
- 주의(MINOR): rollback ②는 prd_cd IN(...) AND cat_cd='CAT_000294' 전건 main='Y'로 올림 — 정정 전 12행이 전부 main='Y'였으므로 부작용 없음. 단, 만약 그 연결이 원래 보조('N')였다면 과복원 위험. 본 건은 백업상 전부 'Y'라 정합.

### 7. 컨펌 분리 정직성 — PASS
PRD_000218 타이벡북커버(고아 CAT_000302 데스크/사무용품)·PRD_000229 이미지피켓(고아 CAT_000304 말랑(PVC고주파)) 라이브 재확인. 유사명 노드 ILIKE 재탐색 결과 **동명 정상노드 부재**:
- 타이벡: 타이벡프린트/타이벡파우치류/타이벡에코백류만 — "타이벡북커버" 없음.
- 피켓: 이미지피켓(우치와)/하트 이미지피켓만 — 단독 "이미지피켓" 정상노드 없음.
- 즉시적용 제외(컨펌대기) **정당**.

### 8. 라이브 롤백전용 DRY-RUN — PASS (NEVER COMMIT 준수)
ON_ERROR_STOP=1 단일 트랜잭션, BEGIN…ROLLBACK.
- ① 제약위반 0(중단 없이 완주).
- ② 변경행수 = 정상연결 12 INSERT + 고아강등 12 UPDATE(10+2). 일치.
- ③ mid-tx 무결성: orphan main=Y 잔존=0, target main=Y=12, 각 상품 정확히 1개 main=Y(위반 0).
- ④ ROLLBACK 후 라이브 불변: live_orphan_294_295_mainY=12, live_target_nodes_mainY=0(적용 전 상태 유지). **COMMIT 0**.

---

## 스키마 정합 (보강)
- PK = (prd_cd, cat_cd) 복합 → ON CONFLICT 키 일치. NOT NULL = prd_cd/cat_cd/main_cat_yn/reg_dt(DEFAULT now()); INSERT가 전부 명시 공급(reg_dt=now()). 누락 NOT NULL 0.
- 12 대상쌍 사전부재 확인 → 1회차 INSERT 12행 정상.

## 종합 판정: **GO**
- 8/8 PASS. 라이브 실측이 생성자 설계(매핑·비어있음·고아사실·컨펌분리)를 전건 확증. **뒤집힌 판정 0.**
- MINOR 1: PRD_000042 ↔ CAT_000064 이름 어순 스왑(쿠폰/상품권 vs 상품권/쿠폰) — 의미 동일·적재 무해. manifest 주석으로 명시 권장.
- 실 COMMIT·부자재 2상품 컨펌·빈 임시함 정리는 인간 승인 대기(설계대로).
