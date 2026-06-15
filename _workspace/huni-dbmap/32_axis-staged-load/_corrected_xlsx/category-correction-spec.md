# ⑥ 카테고리 교정 명세서 (P1·완전가역·가격 무관) — round-22 v2 경로 Y

> **작성** 2026-06-16 · dbm-correctness-auditor(round-13 방법론·dbm-axis-staged-load round-22 v2). 사용자 선택 = "가역·고효과부터(⑥카테고리·④자재 mat_typ)". 본 문서는 **교정 명세서**(correction spec)다 — 실 라이브 변경·실 COMMIT 없음(읽기전용 실측 + 명세까지).
>
> **권위순서(라이브=교정대상):** ① 상품마스터 260610 + 인쇄상품가격표(`docs/huni/`·`24_master-extract-260610/`) ② webadmin 적재 oracle(`raw/webadmin/tools/load_master.py`·`sql/`) ③ 스키마 설계의도 ④ 확정 도메인. **v03 마이그레이션=오염원·정답 아님.**
>
> **[HARD] 비파괴·읽기전용:** 라이브 SELECT만 수행(INSERT/UPDATE/DELETE/DDL 0건). hard-delete 금지(use_yn='N'/페어 제거 제안). webadmin 코드 수정 0.
>
> **경로:** 경로 Y(교정 엑셀 재적재)가 1순위(진원=ⓐ 입력 v03). 본 명세는 라이브 t_* 코드(PK) 기준 교정 + v03 시트 적용 가이드(개발자가 v03에 반영). v03 입력 엑셀 실물은 우리 repo 부재(HuniProductPrice2 별도 레포) → 엑셀 직접 빌드 불가·적용 가이드로 산출.

---

## 0. 한 줄 결론 (★실측이 진단을 정정)

⑥ 카테고리 교정은 **고아 14노드에 직결된 113 페어 행을 제거**하는 단일 작업이다. **신규 카테고리 노드 mint 0·정상노드 cat_cd UPDATE 0.** 왜냐하면 라이브 실측 결과 **113상품 중 111상품이 이미 정상 잎노드에 main_cat_yn='Y'(주카테고리)로 동시 연결**돼 있고, 고아 연결은 전부 **main_cat_yn='N'(부카테고리·중복 잡음)**이기 때문이다. 02 진단의 "고아 노드를 정상 잎노드로 재연결(cat_cd UPDATE)"은 부정확 — **재연결이 아니라 중복 고아 페어 삭제**가 정답이다(정상 페어는 이미 존재).

---

## 1. 라이브 전수 실측 (2026-06-16·읽기전용 재현 SELECT)

### 1-1. 고아 14노드 (upr_cat_cd NULL·cat_lvl=3·use_yn=Y)

```sql
SELECT cat_cd, cat_nm, cat_lvl, upr_cat_cd, use_yn
FROM t_cat_categories
WHERE upr_cat_cd IS NULL AND cat_lvl >= 2 ORDER BY cat_cd;
```

| cat_cd | 노드명(고아) | 연결 상품수 | 비고 |
|--------|------------|:--:|------|
| CAT_000293 | 상품악세사리 | 15 | 봉투/부속류 |
| CAT_000294 | 명함 | 10 | |
| CAT_000295 | 상품권 | 2 | |
| CAT_000296 | 배경지 | 4 | |
| CAT_000297 | 레드프린팅 책자 가이드 | **0** | 상품 0·빈 고아노드 |
| CAT_000298 | 실사 | 28 | |
| CAT_000299 | 단품형 | 14 | 아크릴류 |
| CAT_000300 | 플래너 | 5 | |
| CAT_000301 | 소품 | 5 | 거울류 |
| CAT_000302 | 데스크/사무용품 | 9 | |
| CAT_000303 | 디지털악세서리 | 2 | |
| CAT_000304 | 말랑(PVC고주파) | 9 | |
| CAT_000305 | 레더파우치 | 9 | |
| CAT_000306 | 에코백부자재 | 1 | |
| **합계** | | **113**(dedup) | CAT_000297 제외 시 113 페어 |

### 1-2. ★핵심 실측 — 고아 연결 113상품의 정상노드 동시연결 + main_cat_yn

```sql
-- 고아연결 상품이 정상노드에도 연결돼 있는가 + 주카테고리 분포
WITH links AS (
  SELECT r.prd_cd,
    bool_or(c.upr_cat_cd IS NULL AND c.cat_lvl>=2) AS has_orphan,
    bool_or(NOT(c.upr_cat_cd IS NULL AND c.cat_lvl>=2)) AS has_normal
  FROM t_prd_product_categories r JOIN t_cat_categories c ON r.cat_cd=c.cat_cd
  GROUP BY r.prd_cd)
SELECT count(*) FILTER(WHERE has_orphan AND has_normal) AS both,
       count(*) FILTER(WHERE has_orphan AND NOT has_normal) AS orphan_only
FROM links;
-- 결과: both=111, orphan_only=2
```

```sql
-- 고아연결 상품의 (고아여부 × 주카테고리여부) 분포
SELECT (c.upr_cat_cd IS NULL AND c.cat_lvl>=2) AS is_orphan, r.main_cat_yn, count(*)
FROM t_prd_product_categories r JOIN t_cat_categories c ON r.cat_cd=c.cat_cd
WHERE r.prd_cd IN (SELECT DISTINCT r2.prd_cd FROM t_prd_product_categories r2
   JOIN t_cat_categories c2 ON r2.cat_cd=c2.cat_cd
   WHERE c2.upr_cat_cd IS NULL AND c2.cat_lvl>=2)
GROUP BY 1,2 ORDER BY 1,2;
```

| is_orphan | main_cat_yn | count | 해석 |
|:--:|:--:|:--:|------|
| f(정상노드) | Y | **111** | 활성상품의 주카테고리 = 정상 잎노드(정답) |
| t(고아노드) | N | **111** | 고아 연결 = 부카테고리(중복 잡음·삭제 대상) |
| t(고아노드) | Y | **2** | PRD_000218·PRD_000229(둘 다 use_yn='N' 비활성) |

> **판정:** 활성 상품 111건은 **정답 카테고리(정상 잎노드)에 이미 주카테고리로 연결됨**. 고아 페어 111건은 부카테고리 중복. 따라서 고아 페어 삭제만으로 트리 무결. 정상 페어는 무손상.

---

## 2. 교정 명세표 (고아 페어 → 삭제, 정답=이미 존재하는 정상 잎노드)

> 형식: 각 고아 페어를 제거. "정답 cat_cd" = 해당 상품이 **이미 main_cat_yn='Y'로 연결된 정상 잎노드**(신규 mint·UPDATE 불필요). 재현 SELECT는 §1-2 + 아래 노드별 쿼리.

### 2-A. CAT_000293 상품악세사리(15상품) — 전부 정상노드 동시연결, 고아 페어 삭제

```sql
SELECT r.prd_cd, p.prd_nm, r.cat_cd, c.cat_nm,
  CASE WHEN c.upr_cat_cd IS NULL AND c.cat_lvl>=2 THEN 'ORPHAN(삭제)' ELSE 'NORMAL(정답·유지)' END
FROM t_prd_product_categories r JOIN t_cat_categories c ON r.cat_cd=c.cat_cd
JOIN t_prd_products p ON r.prd_cd=p.prd_cd
WHERE r.prd_cd IN (SELECT prd_cd FROM t_prd_product_categories WHERE cat_cd='CAT_000293')
ORDER BY r.prd_cd, c.cat_lvl;
```

| 대상 PRD | 상품명 | 삭제할 고아 페어 | 이미 존재하는 정답 잎노드(유지) |
|----------|--------|------------------|--------------------------------|
| PRD_000001 | OPP접착봉투 | →CAT_000293 | CAT_000277 OPP접착봉투 |
| PRD_000002 | OPP비접착봉투 | →CAT_000293 | CAT_000278 OPP비접착봉투 |
| PRD_000003 | 트래싱지 카드봉투 | →CAT_000293 | CAT_000281 트레싱지봉투 |
| PRD_000004 | 카드봉투 | →CAT_000293 | CAT_000280 카드봉투 |
| PRD_000005 | 캘린더봉투 | →CAT_000293 | CAT_000282 캘린더봉투 |
| PRD_000006 | 볼체인 | →CAT_000293 | CAT_000291 볼체인 |
| PRD_000007 | 와이어링 | →CAT_000293 | CAT_000292 와이어링 |
| PRD_000008 | 천정고리 | →CAT_000293 | CAT_000287 상품액세서리 |
| PRD_000009 | 투명케이스 | →CAT_000293 | CAT_000279 투명케이스 |
| PRD_000010 | 행택끈 | →CAT_000293 | CAT_000276 봉투/케이스 |
| PRD_000011 | 자석고정용고무판 | →CAT_000293 | CAT_000286 자석고정용고무판 |
| PRD_000012 | 우드거치대 | →CAT_000293 | CAT_000288 우드거치대 |
| PRD_000013 | 우드봉 | →CAT_000293 | CAT_000287 상품액세서리 |
| PRD_000014 | 우드행거 | →CAT_000293 | CAT_000289 우드행거 |
| PRD_000015 | 만년스탬프 리필잉크 | →CAT_000293 | CAT_000287 상품액세서리 |

### 2-B. CAT_000294 명함(10상품) — 전부 정상 명함 잎노드 동시연결

| 대상 PRD | 상품명 | 삭제할 고아 페어 | 정답 잎노드(유지) |
|----------|--------|------------------|------------------|
| PRD_000031 | 프리미엄명함 | →CAT_000294 | CAT_000048 프리미엄명함 |
| PRD_000032 | 코팅명함 | →CAT_000294 | CAT_000049 코팅명함 |
| PRD_000033 | 스탠다드명함 | →CAT_000294 | CAT_000050 스탠다드명함 |
| PRD_000034 | 펄명함 | →CAT_000294 | CAT_000051 펄명함 |
| PRD_000035 | 모양명함 | →CAT_000294 | CAT_000054 모양명함 |
| PRD_000036 | 미니모양명함 | →CAT_000294 | CAT_000055 미니모양명함 |
| PRD_000037 | 오리지널박명함 | →CAT_000294 | CAT_000056 오리지널박명함 |
| PRD_000038 | 형압명함 | →CAT_000294 | CAT_000057 형압명함 |
| PRD_000039 | 투명명함 | →CAT_000294 | CAT_000052 투명명함 |
| PRD_000040 | 화이트인쇄명함 | →CAT_000294 | CAT_000053 화이트인쇄명함 |

> **02 진단 B-2(명함 정상노드 미확인) 해소:** 명함 정상 잎노드(CAT_000048~057)는 전부 실재하고 10상품 모두 거기에 이미 연결됨. **BLOCKED 아님** — 고아 페어 삭제만.

### 2-C~N. 나머지 12 노드 (동일 패턴 — 정답 잎노드 이미 동시연결)

| 고아노드 | 상품수 | 대표 매핑(고아 삭제 → 정답 잎노드 유지) | 비고 |
|----------|:--:|------|------|
| CAT_000295 상품권 | 2 | PRD_000041→CAT_000063 스탠다드쿠폰/상품권·PRD_000042→CAT_000064 프리미엄상품권/쿠폰 | B-2 해소(정상노드 실재) |
| CAT_000296 배경지 | 4 | PRD_000043→CAT_000273·044→CAT_000274·045→CAT_000275 인쇄헤더택·046→CAT_000283 라벨/포장스티커 | 포장 카테고리(메모리 인쇄배경지=012 포장재 정합) |
| CAT_000298 실사 | 28 | PRD_000118~145 각각 CAT_000067~099 정상 포스터/사인/시트 잎노드 | 전 28건 정상노드 동시연결 |
| CAT_000299 단품형 | 14 | PRD_000146~159 각각 CAT_000140~153 정상 아크릴 잎노드 | 전 14건 동시연결 |
| CAT_000300 플래너 | 5 | PRD_000172~176 각각 CAT_000119~123 정상 문구 잎노드 | 동시연결 |
| CAT_000301 소품 | 5 | PRD_000183~187 각각 CAT_000165~169 정상 라이프(거울) 잎노드 | 동시연결 |
| CAT_000302 데스크/사무용품 | 9 | PRD_000210~217 각각 CAT_000132~139 정상 문구 잎노드 | PRD_000218 제외(아래 §3) |
| CAT_000303 디지털악세서리 | 2 | PRD_000219→CAT_000211 밴드톡·220→CAT_000212 폰스트랩 | 동시연결 |
| CAT_000304 말랑(PVC고주파) | 9 | PRD_000221~228 각각 CAT_000192/193/194/184/183/162/202/201 정상 라이프 잎노드 | PRD_000229 제외(아래 §3) |
| CAT_000305 레더파우치 | 9 | PRD_000230~238 각각 CAT_000213~221 정상 에코백(레더 파우치) 잎노드 | 동시연결 |
| CAT_000306 에코백부자재 | 1 | PRD_000280→CAT_000272 레더라벨제작 | 동시연결 |

> 전체 노드별 상세 매핑은 §1-2 재현 SELECT로 1:1 확인 가능(라이브 권위). 113 페어 전부 정상노드 동시연결 확인됨(2상품 예외는 §3).

---

## 3. BLOCKED — 정상 연결 부재 2상품 (escalate·추측 금지)

```sql
WITH links AS (
  SELECT r.prd_cd, p.prd_nm,
    bool_or(c.upr_cat_cd IS NULL AND c.cat_lvl>=2) AS has_orphan,
    bool_or(NOT(c.upr_cat_cd IS NULL AND c.cat_lvl>=2)) AS has_normal
  FROM t_prd_product_categories r JOIN t_cat_categories c ON r.cat_cd=c.cat_cd
  JOIN t_prd_products p ON r.prd_cd=p.prd_cd GROUP BY r.prd_cd, p.prd_nm)
SELECT prd_cd, prd_nm FROM links WHERE has_orphan AND NOT has_normal;
-- 결과: PRD_000218 타이벡북커버 / PRD_000229 이미지피켓
```

| PRD | 상품명 | 현재 연결 | use_yn(상품) | 정답 잎노드 후보 | 판정 |
|-----|--------|-----------|:--:|------------------|------|
| PRD_000218 | 타이벡북커버 | CAT_000302 데스크/사무용품(고아·main Y) | **N(비활성)** | 명확한 잎노드 부재(타이벡 잎노드=파우치/에코백류뿐, "북커버" 없음) | 🔴 **BLOCKED** |
| PRD_000229 | 이미지피켓 | CAT_000304 말랑(고아·main Y) | **N(비활성)** | CAT_000200 이미지피켓(우치와)이 유력하나 현재 0상품 연결 | 🔴 **BLOCKED(컨펌)** |

> **BLOCKED 사유:** 두 상품 모두 **use_yn='N'(이미 논리삭제된 비활성 상품)**이고 정상 잎노드 매칭이 불명확. 비활성 상품의 고아 연결을 강제 재연결하는 것은 추측. **B-2 잔존 컨펌**(BATCH-1)로 escalate. 활성 상품 중 정상 연결 부재는 **0건**(전부 정답 보유).

---

## 4. 빈 고아 노드 논리삭제 (CAT_000297·재연결 검증 후 마지막)

| cat_cd | 노드명 | 상품수 | 제안 | 안전성 |
|--------|--------|:--:|------|------|
| CAT_000297 | 레드프린팅 책자 가이드 | 0 | **use_yn='N'**(즉시 안전) | 상품 0·가격사슬 무관 → 안전 |
| 나머지 13 고아노드 | (상품악세사리~에코백부자재) | 각 1~28 | **고아 페어 113건 삭제 후 use_yn='N'** | 페어 제거 검증 완료 후 마지막(hard-delete 금지) |

---

## 5. v03 시트 적용 가이드 (경로 Y — 개발자 액션)

> v03 입력 엑셀 실물은 우리 repo 부재(HuniProductPrice2 별도 레포). 아래는 개발자가 v03에 반영하거나, 우리가 실물 확보 후 엑셀화할 때의 적용 위치다. **시트명/헤더 v03 동일·행순/surrogate 코드 보존 [HARD] 경로 Y 3조건.**

### 5-1. `11_상품별카테고리` 시트 — 고아 페어 행 삭제(핵심)

- **시트명:** `11_상품별카테고리` (load_master.py:283 `read_sheet`)
- **헤더 컬럼:** `상품코드·카테고리코드·주카테고리여부·표시순서·비고` (load_master.py:288-289)
- **적용:** 카테고리코드가 **고아 노드(상품악세사리/명함/상품권/배경지/실사/단품형/플래너/소품/데스크사무용품/디지털악세서리/말랑/레더파우치/에코백부자재 — v03의 한글 카테고리코드)**인 113 페어 행을 **제거**. 정상 잎노드 페어 행은 보존.
- **행 식별 방법:** 각 행의 `카테고리코드` 컬럼값 = 고아 노드의 v03 코드 + `주카테고리여부`='N'(부카테고리)인 행. §2 표의 PRD↔정답잎노드 쌍으로 1:1 대조.
- **★행순 주의 [HARD]:** load_rel_categories는 surrogate 미발급(상품/카테고리 코드 매핑만 참조)이라 행 삭제 가능. 단 `01_카테고리`/`05_자재정보`처럼 surrogate 재발급 시트가 아니므로 11시트 행 삭제는 PK 영향 없음(MAPS["CAT"]는 01시트 행순 기준).

### 5-2. `01_카테고리` 시트 — 고아 노드 처리(2안)

- **시트명:** `01_카테고리` (load_master.py:165)
- **헤더 컬럼:** `카테고리코드·카테고리명·상위카테고리코드·카테고리레벨·표시순서·사용여부` (load_master.py:172-173)
- **★surrogate 행순 보존 [HARD]:** issue가 **엑셀 행순**으로 CAT surrogate 발급(load_master.py:166). 고아 노드 행을 **삭제/재정렬하면 후속 CAT 코드 전부 어긋나 가격사슬·관계행 파손**. 따라서:
  - **A안(권장·안전):** 고아 노드 행을 **삭제하지 말고 `사용여부`='N'으로 변경**(행순·코드 보존). 11시트에서 고아 페어 제거(5-1)로 상품 연결 끊김. CAT_000297은 사용여부 N.
  - **B안(상위코드 채움):** 고아 노드의 `상위카테고리코드` 컬럼을 적절한 대분류로 채움 — **단 이는 노드를 살려 트리에 편입하는 것**이라 정상 잎노드와 중복 분류 발생. **권장 안 함**(정답 잎노드 이미 존재).
- **결론:** 11시트 고아 페어 삭제(5-1) + 01시트 고아 노드 `사용여부`='N'(A안). 상위코드 채움 불요.

### 5-3. 경로 X(라이브 직접 SQL·보조·다음 재적재 전까지만 유효)

> 개발자 부재·긴급 시 임시. **load_master --all 재적재 시 소멸**(P-TRUNCATE). 가역 작업에 한함.

```sql
-- 비파괴 제안(실행은 인간 승인). 고아 페어 113건 논리 제거 + 빈 노드 비활성.
-- (1) 고아 부카테고리 페어 제거 — 정상 주카테고리는 무손상
DELETE FROM t_prd_product_categories r
USING t_cat_categories c
WHERE r.cat_cd=c.cat_cd AND c.upr_cat_cd IS NULL AND c.cat_lvl>=2
  AND r.main_cat_yn='N';   -- 활성상품 111 + 정상중복분만(main N), main Y 2건(비활성·BLOCKED) 제외
-- (2) 빈/고아 노드 논리삭제(use_yn 컬럼 — t_cat_categories는 use_yn 사용)
UPDATE t_cat_categories SET use_yn='N', upd_dt=now()
WHERE upr_cat_cd IS NULL AND cat_lvl>=2 AND cat_cd NOT IN
  (SELECT cat_cd FROM t_prd_product_categories);  -- 페어 제거 후 빈 노드만
```

> 단 t_prd_product_categories는 use_yn 컬럼 부재(페어 테이블) → 페어는 행 삭제가 곧 논리 제거. **경로 X는 재적재 소멸 전제 명시 필수.** 권장은 경로 Y(5-1·5-2).

---

## 6. 개발자 액션 요약

1. **(경로 Y·근본)** v03 `11_상품별카테고리`에서 고아 카테고리코드 페어 113행 제거 + `01_카테고리`에서 고아 14노드 `사용여부`='N'(행순 보존). `load_master --all` 재적재.
2. **(검증)** 재적재 후 §1-2 SELECT 재실행 → 고아 연결 0·정상 주카테고리 무손상 확인.
3. **(BLOCKED)** PRD_000218 타이벡북커버·PRD_000229 이미지피켓(둘 다 비활성)의 정상 잎노드 매칭은 컨펌 후 처리(B-2).

---

## 7. 적재 로직 근거 (loadlogic — why)

- **고아 발생 진원 = ⓐ v03 입력**(03 분석 §2 CONFIRMED). `load_categories`(load_master.py:170)는 `상위카테고리코드` 셀이 비면 `upr_cat_cd=NULL` INSERT → 고아는 **v03 01시트가 이 14노드의 상위코드를 비워둠**. `load_rel_categories`(load_master.py:288)는 11시트 prd↔cat 페어를 무변환 INSERT → 이중 연결(정상+고아)은 **v03 11시트가 상품을 두 카테고리에 모두 적은 것**. 코드는 고아·중복을 만들지 않고 전파만 함(무변환 전파기).
- **why 정답:** 상품마스터 260610 카테고리맵(`24_master-extract-260610/map-l1.csv`)은 12 대분류(엽서~포장)의 잎노드만 정의 — **"상품악세사리·단품형·플래너·소품" 등 고아 노드명은 권위 트리에 부재**. 즉 고아 노드는 v03 잡음이고 정답은 12 대분류 산하 정상 잎노드(라이브에 이미 적재됨).
