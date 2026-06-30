# 레더 하드커버책자(PRD_000077) 셋트 동작화 — 실 COMMIT 로그

실행: hsp-load-executor · 2026-07-01 · 라이브 운영 DB(Railway `railway`) · 단일 트랜잭션 COMMIT 성공
승인: 게이트 CONDITIONAL GO(`05_gate/gate-verdict-leather-hardcover-077.md`) + 인간 승인("지금 COMMIT 진행")
자격: `.env.local RAILWAY_DB_*`(키 이름만·값 비노출)

---

## 0. 결과 한 줄

> 23행 단일 트랜잭션 COMMIT 성공 — 077 견적 **0원 → PRICE≠0(≈51,146)** 동작화 달성. 멱등·복합PK·FK·회귀 0 전부 통과. 레더 +3,900은 BLOCKED(별도 트랙).

---

## 1. 안전 프로토콜 실행 순서 (전부 통과)

| 단계 | 내용 | 결과 |
|---|---|---|
| 실행 전제 | 게이트 GO + 인간 승인 확인 | ✅ CONDITIONAL GO·승인 명시 |
| FK 선행 | sub_prd_cd 078/079/080/081 라이브 실재(.02)·285 mint 대상 | ✅ 고아 INSERT 위험 0 |
| 물리 백업 | baseline dump → `leather-hardcover-077-backup-20260701_0005.sql` | ✅ 077 4행·바인딩0·285부재 캡처 |
| DRY-RUN | `BEGIN; \i load.sql ×2; ROLLBACK` 롤백전용 | ✅ 멱등 delta0·제약위반0·복합PK충돌0·예상카운트 일치 |
| 실 COMMIT | `BEGIN; \i load.sql; COMMIT`(ON_ERROR_STOP=1) | ✅ exit 0·부분실패 0 |
| 사후 재실측 | 285·077·무결성·회귀·멱등·가격사슬 | ✅ 전부 통과(§3) |
| undo 보유 | `leather-hardcover-077-undo.sql` | ✅ baseline 복원 SQL 산출 |

- 적재 SQL(`leather-hardcover-077-load.sql`)에 BEGIN/COMMIT 미내장 → load-executor가 DRY-RUN/COMMIT 단계에서만 외부 래핑(프로토콜 4 준수).

## 2. COMMIT 결과 — 실제 INSERT 행수

| 위상 | 테이블 | 행수 |
|---|---|---|
| 1 | t_prd_products (PRD_000285 mint·.02 반제품) | INSERT 0 1 |
| 2 | t_prd_product_sizes (285·siz3) | INSERT 0 3 |
| 2 | t_prd_product_print_options (285·popt2) | INSERT 0 2 |
| 2 | t_prd_product_materials (285·mat9) | INSERT 0 9 |
| 2 | t_prd_product_plate_sizes (285·plate1·SIZ_000499) | INSERT 0 1 |
| 3 | t_prd_product_price_formulas (285→PRF_DGP_INNER) | INSERT 0 1 |
| 4 | t_prd_product_price_formulas (077→PRF_HC_MUSEON_SET) | INSERT 0 1 |
| 5 | t_prd_product_sets (077 셋트 5행) | INSERT 0 5 |
| **합계** | | **23행 (전부 신규 INSERT·UPSERT 갱신 0)** |

- 신규 공식·component·단가행·자재·사이즈 mint = **0** (전부 072 자산 재사용). 신규 mint = 내지 PRD_000285 1건만.
- 백업: `leather-hardcover-077-backup-20260701_0005.sql`

## 3. 사후 재실측 (라이브·COMMIT 후)

### ① PRD_000285 실재·차원 충전
```
PRD_000285  레더 하드커버책자-내지  PRD_TYPE.02  use_yn=Y  del_yn=N
차원: sizes=3 · popt=2 · mat=9 · plate=1  (284 동형·전부 충전)
```

### ② 077 셋트행 4 → 5 (disp_seq 1~5 단조)
```
seq1 PRD_000078 (표지)   qty1 min1/max1
seq2 PRD_000285 (내지)   qty1 min24/max300/incr2   ← 신규 member
seq3 PRD_000079 (면지W)  qty1
seq4 PRD_000080 (면지Bk) qty1
seq5 PRD_000081 (면지Gy) qty1
공식 바인딩: PRD_000077→PRF_HC_MUSEON_SET · PRD_000285→PRF_DGP_INNER (2026-06-06)
```

### ③ evaluate_set_price 무손상 (PRICE≠0 재확인)
가격 사슬 환원을 라이브 단가행으로 입증(Django 미설치 → pricing.py pure-helper 알고리즘 손계산·게이트 §S4 재현):
- 부모 COMP_HC_MUSEON_COVERBIND 6밴드 verbatim: **34100**/22425/15910/10170/7969/6368.40 (밴드1=34,100·copies1)
- 내지 PRF_DGP_INNER = COMP_PRINT_DIGITAL_S1(양면·판형 SIZ_000499 단가행 환원) + COMP_PAPER(SIZ_000499·백모조100=30.73/장)
- G1(A4·30p·qty1·양면·백모조100): base_total = 34,100(부모) + ≈17,046(내지·qty=derive_inner_sheets=8매) + 0(표지·면지) = **≈51,146원**
- **이전 견적 0원(부모공식 0행) → 51,146 PRICE≠0 = 동작화 달성** ✅
- 골든 잔차: ASP 레더 골든 50,800 대비 +346 = 072 동형 엔진모델 편차(C-TRACK·전 책자 공통)이지 077 적재 데이터 결함 아님. 레더 +3,900은 BLOCKED.
- 이중합산 0: COVERBIND(표지+제본)·PRF_DGP_INNER(인쇄+용지)·면지0 — frm_cd 분리.

### ④ 무결성·멱등·회귀
| 검사 | 결과 |
|---|---|
| FK 고아 (077 셋트 sub_prd_cd ← products) | **0** |
| 복합PK 중복 (077 셋트행) | **0** |
| 멱등 (COMMIT 후 적재 SQL 재-DRY-RUN) | 전부 INSERT 0 0 = **delta 0** |
| 회귀: 072 셋트행 무손상 | **5행 불변** |
| MAX prd_cd | PRD_000285 (mint 정상) |

## 4. undo 방법

`leather-hardcover-077-undo.sql` — `psql -v ON_ERROR_STOP=1 -f undo.sql`(BEGIN/COMMIT 내장):
1. 내지285 셋트 member 물리삭제 + 077 baseline 셋트행 원복(표지078 min/max NULL·면지 seq2/3/4)
2. 077/285 공식 바인딩 제거(baseline 0행)
3. 내지285 차원 4종·마스터(PRD_000285) 물리삭제(신규 mint 생성분·마스터 보존규칙 미해당)
4. 복귀 기대: 077=4행·285 부재·바인딩 0 (= baseline)

baseline 대조 백업: `leather-hardcover-077-backup-20260701_0005.sql`

## 5. 잔존 BLOCKED (본 COMMIT 밖·인간 승인·미적재)

| ID | 트랙 | 사안 |
|---|---|---|
| BLOCKED-COVERBIND-LEATHER | §18/engine | 레더 +3,900(골든 50,800). COMP_HC_MUSEON_COVERBIND.use_dims=["min_qty"]만 → mat_cd 단가행 silent 무시/AMBIGUOUS. (A)use_dims+mat_cd+레더6밴드 or (B)별도 component 신설+PRF 분기. 현재=072 전용지 동일가(저청구). |
| BLOCKED-MAT-REWIRE | dbmap/basecode | 077 부모 좀비 MAT_000002(아크릴·del_yn=N 활성) link 제거 + 표지078 자재=레더(MAT_000186/379) link 추가. link만·마스터 삭제 금지·견적 미관여. |
| CONFIRM-LEATHER-PRINT | authority | 표지 특수인쇄/실사출력이 레자인쇄 +3,900에 포함되는지·잔차 +346. 실무진. |
| C-TRACK-ENGINE | engine | COVERBIND ×copies·책등 by 페이지·내지 이중÷pansu — 072 동형 전 책자 공통. 개발팀(webadmin). |

## 6. 산출물

- `leather-hardcover-077-backup-20260701_0005.sql` — baseline 물리 백업
- `leather-hardcover-077-dryrun.sql` — 롤백전용 DRY-RUN 스크립트(멱등 2회·복합PK·롤백복귀)
- `leather-hardcover-077-apply.sql` — 트랜잭션 래핑 COMMIT 스크립트
- `leather-hardcover-077-undo.sql` — baseline 복원 undo
- `leather-hardcover-077-commit-log.md` — 본 로그

안전: 라이브 쓰기는 COMMIT 1회만(DRY-RUN/멱등재검은 ROLLBACK). 비밀값 비노출.
