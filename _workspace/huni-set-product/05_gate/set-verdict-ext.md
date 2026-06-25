# 셋트 검증 게이트 판정 — 남은 6셋트 구조 보정 적재본 (동형 전파 2차·S1~S7)

생성: hsp-set-gate (독립 검증·생성≠검증) · 라이브 읽기전용 SELECT 직접 재실측(2026-06-24) · DRY-RUN 롤백전용 2회 · **DB 미적재(GO여도 게이트 COMMIT 안 함 — load-executor)**.
대상: `03_design/`-ext(set-composition-design-ext·apply-ext.sql·t_prd_product_sets-ext.csv·t_prd_products-ext.csv·blocked-board-ext.csv) + `04_codex/reconcile-ext.md`(D1~D5).
대상 6셋트: PRD_000072 하드커버책자·077 레더 하드커버책자·082 하드커버 링책자·088 레더 링바인더·097 떡메모지·100 포토북.
**생성측(set-designer/codex) 주장 비신뢰 — 아래 PASS/FAIL 전부 게이트가 라이브로 직접 재실측한 증거 기반.**

---

## 0. 종합 판정

| 종합 | 결과 |
|---|---|
| **6셋트 구조 보정 본체(6 유형 UPDATE + 26 UPSERT disp_seq/note 보정)** | **GO (CONDITIONAL)** |
| 조건 | 적재본은 가격공식·면지자재·페이지축을 **건드리지 않으며 포함하지 않는다**(BLOCKED 분리). 단 apply-ext.sql 헤더 "신규 mint 0·전부 보정/UPDATE" 문구는 SQL이 `INSERT…ON CONFLICT`라 **표현 정정 권고**(D3) — 라이브 26행 실재로 실 INSERT는 발생 안 함(무해). |
| 적재 GO 행수 | t_prd_products **6행(유형 UPDATE 04→01)** + t_prd_product_sets **26행(UPSERT disp_seq/note 보정)** = **32 DML**(신규 INSERT 0) |
| BLOCKED(적재 제외·라우팅) | BLOCKED-PRICE-6(6셋트 견적불가·§18)·RM-4(페이지축·dbmap/CPQ)·RM-2(면지자재·dbmap/basecode)·GUARD-1(가격 신설 시 평면합산 금지)·CONFIRM-3(포토북 권위 모호) |
| 돈크리티컬 S4 결과 | **6셋트 전부 PRICE=0 = 진성 견적불가(BLOCKED)** — 부모 0바인딩·구성원 0바인딩·구성원 직접단가 0행. **엽서북식 "미바인딩 오청구"가 아니라 "셋트공식 진성 부재"** (라이브 실측 구분). |

**단일 FAIL 없음** → 구조 보정 본체 NO-GO 사유 없음. 가격은 적재본 범위 밖 BLOCKED라 본체 GO를 막지 않음 = **CONDITIONAL GO**(가격 BLOCKED분 분리·문구 정정 조건).

---

## 1. S1~S7 판정표

| 게이트 | 판정 | 게이트 직접 재실측 증거 |
|---|---|---|
| **S1 권위 충실성** | **PASS** | 26 구성원·disp_seq·note 적재본 = set-checklist row2-29·booklet-l1과 일치(t_prd_product_sets-ext.csv 대조)·날조 0. min/max/incr NULL 유지 = **권위 침묵(내지 MES별도설정·떡메 페이지공란·포토북 미특정)에 충실**(RM-4). DRY-RUN 후 disp_seq 단조(1-4/1-4/1-5/1-5/1/1-7)·note 역할 prefix 명확화 실증. |
| **S2 구성원 유형** | **PASS** | 라이브 실측: 26 구성원 **전부 PRD_TYPE.02(반제품)·del_yn=N**(혼입 0). 부모 6 전부 현재 PRD_TYPE.04. 유형교정 04→01 타당(아래 D1). admin.py:1095 규칙=셋트 인라인은 "반제품(02)만 제외"이고 01(완제품)은 셋트 부모 유효. sub_prd autocomplete는 02만(admin.py:1090)·구성원 02 불변. |
| **S3 무결성** | **PASS** | 복합PK(prd_cd,sub_prd_cd) 중복 **0**(HAVING count>1 빈 결과). FK 고아 **0**(6부모·26구성원 전부 t_prd_products 실재·FK는 prd_cd·sub_prd_cd 양방 REFERENCES). 26행 전부 실존(disp_seq=1 현재) → UPSERT 보정. disp_seq 단조·sub_prd_qty=1. 유형 UPDATE 멱등(`IS DISTINCT FROM`). |
| **S4 가격 e2e [HARD]** | **PASS (BLOCKED-PRICE 정직 분류)** | 부모 6 **formula 바인딩 0행**·구성원 26 **바인딩 0행**·구성원 26 **직접단가(t_prd_product_prices) 0행**. 대조군 094=PRF_PCB_FIXED 바인딩 보유(쿼리 동작 입증). → evaluate_set_price base_total=0 → **PRICE=0=진성 견적불가**(엽서북 미바인딩 오청구와 등급 다름). **★택1 합산0 재실측: 면지/표지 평면 다중행 전부 공식0·직접단가0 → 동시 전달해도 각 contribution=0·합산 오염 0**(현 상태 무해). |
| **S5 경쟁사 흡수** | **PASS** | 권위 합산형(구성원 카탈로그) 유지. note·코드 전부 후니 도메인 한국어(표지/면지/내지·전용지·레더·백모조120·몽블랑130)·경쟁사 naming/code 유입 0. |
| **S6 적재 가능성** | **PASS** | DRY-RUN 2회(BEGIN…ROLLBACK): 제약위반 0·예상 카운트 실증(1차 UPDATE 6 + INSERT…ON CONFLICT 4/4/5/5/1/7=26·setcount 26 유지). **멱등=2차 UPDATE 0행**·**sets 데이터 fingerprint AFTER1==AFTER2(`b386b34…`)**·신규행 0. ROLLBACK 후 type04 6개 원상복귀(COMMIT 안 함). D2 해소: upd_dt churns하나 데이터값 멱등. |
| **S7 생성≠검증 독립성** | **PASS** | 전 판정 게이트 직접 psql 재실측·apply-ext.sql 직접 DRY-RUN(생성자 주장 인용 아님). codex reconcile D1~D5 전부 종결(아래 §2). **★게이트가 라이브로 D1 webadmin 권위·094 선례·택1 합산0·페이지 별테이블을 독립 확증.** |

---

## 2. D1~D5 종결 (codex reconcile 미해결 큐)

| ID | 사안 | 게이트 라이브 재실측 판정 | 종결 |
|---|---|---|---|
| **D1** | 부모 04→01 권위 강도(codex CONFIRM-1 "확정 승격 과장") | **게이트 라이브 해소**: ① 094 엽서북이 **이미 PRD_TYPE.01로 COMMIT됨**(라이브 실측=01)=직전 선례·동일 directive. ② admin.py:1095 코드 주석 = "기존 셋트 데이터가 디자인상품에 존재 → '완제품 한정'이 아니라 '반제품만 제외'로 둔다" → webadmin은 04(디자인) 셋트 부모도 인라인 노출 **허용**(01 전환해도 노출 유지·기능 무해). ③ 라이브 전체에서 PRD_TYPE.04 셋트 부모 = **정확히 이 6개뿐**(다른 디자인상품 셋트 영향 0). → **유형교정 타당·codex "과장" 우려는 선례+코드로 해소**. 단 "RM-3 확정" 라벨은 directive 권위이지 권위 엑셀 명시는 아니므로 **인간 승인 큐 유지**(돈 아님·분류 영향). | **CLOSED — GO(인간 승인 후 적재)** |
| **D2** | UPSERT upd_dt 무가드 멱등 비대칭(codex FAIL) | **데이터값 멱등 입증**: DRY-RUN 2회 sets fingerprint 동일(`b386b34…`)·setcount 26 유지·2차 UPDATE 0(유형). upd_dt=now() churns은 timestamp만·데이터 오염 0. 멱등성=결과 동일성 충족. no-op 가드는 선택(강제 아님). | **CLOSED — 데이터값 멱등 인정** |
| **D3** | apply-ext.sql 헤더 "신규0/UPDATE" ↔ `INSERT…ON CONFLICT` 문구 불일치 | **정보성**: 라이브 26행 전부 실재(실측) → 실행 시 항상 ON CONFLICT DO UPDATE 분기·DRY-RUN에서 신규행 0·setcount 26 유지 확인. SQL 자체엔 preflight 가드 없음(표현차)·결함 아님. **문구를 "UPSERT(기존 26행 실재 확인됨·신규 INSERT 0)"로 정정 권고**. | **CLOSED — 문구 정정 권고(데이터 불변)** |
| **D4** | 하드/링 페이지(24~300/+2·8~100/+2) NULL = 셋트 member vs 부모옵션(codex CONFIRM-5) | **게이트 라이브 판정**: 라이브 셋트행에 **내지 member 자체가 없음**(072/077/082/088은 표지+면지 행만·내지=MES `*별도설정`으로 sub_prd_cd 미등록). 충전할 셋트행이 부재하므로 min/max/incr를 채울 수 없음 — 페이지축은 **부모상품 페이지옵션** 소관(셋트-member 범위 아님). NULL 유지는 권위 침묵에 충실(오염 아님). 단 "갭 해소"는 아니므로 RM-4로 라우팅(부모 페이지축·내지 member 등록 결정). | **CLOSED — NULL 유지 정당·RM-4 라우팅** |
| **D5** | 포토북 표지5종 택1·페이지 NULL(CONFIRM-3 권위행 미특정) | **양측 모호 인정 합의**: 구조 보정(표지5/내지1/면지1·disp_seq 1-7)은 라이브 현황 기준 GO·페이지/구성 권위는 CONFIRM-3로 미특정. 구조 보정과 권위 특정 분리. | **CLOSED — 구조보정 GO·권위 CONFIRM-3 라우팅** |

**codex reconcile 미해결 = 0** (D1~D5 전부 종결).

---

## 3. 적재 GO 큐 (load-executor 위임·인간 승인 후 COMMIT)

승인 대상 = 6셋트 구조 보정 본체 **32 DML**(apply-ext.sql 그대로·신규 mint 0):

| # | 대상 t_* | DML | 키 | 내용 | 멱등 |
|---|---|---|---|---|---|
| 1 | t_prd_products | UPDATE×6 | 072/077/082/088/097/100 | prd_typ_cd 04→01 | `IS DISTINCT FROM`(2차 0행) |
| 2 | t_prd_product_sets | UPSERT×26 | (각 부모,구성원) | disp_seq 단조 + note 명확화·min/max/incr NULL·sub_prd_qty=1·del_yn=N | ON CONFLICT DO UPDATE(데이터값 멱등·fingerprint 동일) |

**조건**: ① apply-ext.sql 헤더 "신규 mint 0·전부 보정/UPDATE" 문구를 "UPSERT(기존 26행 실재 확인됨)"로 정정(데이터 변경 0·D3). ② D1 유형교정은 directive 권위라 **인간 승인 후 적재**(094 선례·webadmin 코드 정합으로 게이트 GO). BLOCKED-PRICE-6·RM-2·RM-4·GUARD-1·CONFIRM-3은 적재본에서 제외·별도 트랙(remediation-spec-ext.md).

---

## 4. 라이브 실측 재현 쿼리 (감사용·읽기전용)

```sql
-- S2 부모/구성원 유형
SELECT prd_cd, prd_typ_cd FROM t_prd_products WHERE prd_cd IN ('PRD_000072','PRD_000077','PRD_000082','PRD_000088','PRD_000097','PRD_000100');
SELECT s.prd_cd, s.sub_prd_cd, p.prd_typ_cd FROM t_prd_product_sets s JOIN t_prd_products p ON p.prd_cd=s.sub_prd_cd WHERE s.prd_cd IN (...) ;  -- 26/26 = PRD_TYPE.02
-- D1 선례: 094 = PRD_TYPE.01 (이미 COMMIT)
SELECT prd_cd, prd_typ_cd FROM t_prd_products WHERE prd_cd='PRD_000094';
-- D1 영향: PRD_TYPE.04 셋트 부모 = 이 6개뿐
SELECT count(DISTINCT s.prd_cd) FROM t_prd_product_sets s JOIN t_prd_products p ON p.prd_cd=s.prd_cd WHERE p.prd_typ_cd='PRD_TYPE.04' AND s.del_yn='N';  -- 6
-- S3 PK dup 0 / FK
SELECT prd_cd,sub_prd_cd,count(*) FROM t_prd_product_sets WHERE prd_cd IN (...) GROUP BY 1,2 HAVING count(*)>1;  -- 빈 결과
-- S4 바인딩 0 (vs 094 대조군)
SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas WHERE prd_cd IN (부모6∪구성원26);  -- 0행
SELECT count(*) FROM t_prd_product_prices WHERE prd_cd IN (구성원26);  -- 0 (택1 합산0 근거)
-- D4 떡메 묶음수 별테이블
SELECT prd_cd,bdl_qty FROM t_prd_product_bundle_qtys WHERE prd_cd='PRD_000097';  -- 50,100
-- S6 DRY-RUN: BEGIN; \i apply-ext.sql; \i apply-ext.sql; (fingerprint 비교); ROLLBACK;
```
