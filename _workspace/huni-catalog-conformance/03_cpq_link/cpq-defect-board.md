# cpq-defect-board.md — CPQ L2 연결 정합 결함 보드 (디지털인쇄 36상품)

> **Phase 2 — hcc-cpq-link-inspector(생성측)** · 2026-06-22 · `huni-catalog-conformance` §21
> 스코프: 디지털인쇄 36상품(PRD_000016~051). 담당 4축(옵션그룹·제약규칙·추가상품·추가상품 템플릿) + ★2연결.
> **3원 대조[HARD]**: ① 권위 엑셀(authority-spec) ② 라이브 psql 실측 ③ 도메인 의미(옵션=자재+공정 BUNDLE).
> 판정 = MATCH/MISSING/EXTRA/MISMATCH/DEAD_LINK/N/A/CONFIRM. **생성측** — 게이트가 독립 재실측.
> 라이브 읽기전용 SELECT만. **직접 교정 금지(라우팅만).** 빈 셀 0.

---

## 0. 판정 분포 (144셀 = 36상품 × 4축)

| 축 | MATCH | MISMATCH | MISSING | N/A | 계 |
|----|------:|---------:|--------:|----:|---:|
| 옵션그룹 | 14 | 1 | 21 | 0 | 36 |
| 제약규칙 | 0 | 0 | 34 | 2 | 36 |
| 추가상품 | 0 | 1 | 9 | 26 | 36 |
| 추가상품 템플릿 | 1 | 0 | 9 | 26 | 36 |
| **합계** | **15** | **2** | **73** | **54** | **144** |

- **옵션→차원 연결**: 264 참조 / 264 해소 = **100%, DEAD_LINK 0.**
- **템플릿→추가상품 연결**: PRD_000016 5/5 해소(MATCH). 끊긴 묶음 0.
- 지배적 결함 = **MISSING 73건**(적재 자체 미충족). dead link가 아니라 not-yet-loaded.

---

## 1. 결함 행 (MISSING / MISMATCH)

### 1.1 옵션그룹 — MISSING 21 (권위 needed=Y·라이브 option_groups 0행)

대상 상품(공통 증상·권위·라이브·도메인·재현·라우팅 동일하여 묶음 기재):

| prd_cd | 상품 | 권위 정답 | 라이브 |
|--------|------|-----------|--------|
| PRD_000019 | 투명엽서 | 주문방법·종이·인쇄 옵션성 컬럼 존재 | grp 0·item 0 |
| PRD_000020 | 화이트인쇄엽서 | 별색(화이트) 옵션 | grp 0 |
| PRD_000021 | 핑크별색엽서 | 별색(핑크) 옵션 | grp 0 |
| PRD_000022 | 금은별색엽서 | 별색(금/은) 옵션 | grp 0 |
| PRD_000023 | 모양엽서 | 커팅모양 옵션 | grp 0 |
| PRD_000028 | 미니접지카드 | 접지·종이·인쇄 옵션 | grp 0 |
| PRD_000030 | 지그재그엽서 | 접지·종이 옵션 | grp 0 |
| PRD_000034 | 펄명함 | 종이·후가공 옵션 | grp 0 |
| PRD_000035 | 모양명함 | 커팅모양·후가공 | grp 0 |
| PRD_000036 | 미니모양명함 | 커팅모양 | grp 0 |
| PRD_000037 | 오리지널박명함 | 박/형압 옵션 | grp 0 |
| PRD_000038 | 형압명함 | 형압 옵션 | grp 0 |
| PRD_000039 | 투명명함 | 종이·별색 | grp 0 |
| PRD_000040 | 화이트인쇄명함 | 별색(화이트) | grp 0 |
| PRD_000043 | 인쇄배경지(OPP봉투타입) | 종이·인쇄·추가상품 | grp 0 |
| PRD_000044 | 인쇄배경지(투명케이스타입) | 종이·인쇄 | grp 0 |
| PRD_000045 | 인쇄헤더택 | 종이·인쇄 | grp 0 |
| PRD_000048 | 접지리플렛 | 접지·종이·후가공 | grp 0 |
| PRD_000049 | 와이드 접지리플렛 | 접지·종이 | grp 0 |
| PRD_000050 | 봉투제작 | 종이·인쇄 옵션 | grp 0 |
| PRD_000051 | 썬캡 | 인쇄·후가공 | grp 0 |

- **증상**: 권위 상품마스터에 옵션성 컬럼(주문방법·인쇄·종이·후가공·별색·접지·커팅·박) 값 존재하나 라이브
  `t_prd_product_option_groups` 0행 → 고객이 옵션 선택 불가 → 견적 차원 환원 불가.
- **도메인**: 디지털 전 상품은 최소 주문방법 옵션그룹 필요(domain-lens §10, always needed=Y).
- **재현**:
  ```sql
  SELECT p.prd_cd, p.prd_nm,
    (SELECT count(*) FROM t_prd_product_option_groups g WHERE g.prd_cd=p.prd_cd AND g.del_yn='N') grps
  FROM t_prd_products p
  WHERE p.prd_cd BETWEEN 'PRD_000016' AND 'PRD_000051' AND p.del_yn='N'
  ORDER BY p.prd_cd;   -- 위 21상품 grps=0
  ```
- **라우팅**: dbm-option-mapper (option_groups→options→option_items 설계·적재).

### 1.2 옵션그룹 — MISMATCH 1

| prd_cd | 상품 | 증상 | 권위 | 라이브 | 라우팅 |
|--------|------|------|------|--------|--------|
| PRD_000046 | 라벨/택 | 옵션그룹(커팅모양) 1개 실재하나 **option_items 0**(미완성)·커팅 공정 차원 미참조 | 커팅=사각(권위) | grp 1·item 0·옵션 나뭇잎/별타공/리니니 모두 item 0 | dbm-option-mapper |

- **도메인**: 커팅모양은 공정(.04) 참조 필요. 항목이 차원에 안 붙으면 견적/생산 환원 실패.
  또한 라이브 옵션값(나뭇잎/별타공/리니니)이 권위 커팅값(사각)과 불일치 — 권위↔라이브 내용 충돌 동반.
- **재현**:
  ```sql
  SELECT o.opt_nm,
    (SELECT count(*) FROM t_prd_product_option_items i WHERE i.prd_cd=o.prd_cd AND i.opt_cd=o.opt_cd AND i.del_yn='N') items
  FROM t_prd_product_options o WHERE o.prd_cd='PRD_000046' AND o.del_yn='N';  -- 전부 items=0
  ```

### 1.3 제약규칙 — MISSING 34 (디지털 스코프 constraints 전무)

- **대상**: PRD_000016~049 전부(needed=Y 34상품). PRD_000050·051만 N/A(제약 표기 없음).
- **증상**: 권위에 별색/접지/박/블리드/커팅 등 제약 표기 존재하나 라이브 `t_prd_product_constraints` **0행**
  (`constraint_json` 캐시도 비어 있음). 전역 constraints 10행은 전부 비디지털.
- **도메인**: 제약은 교차축 불가조합·범위 제한(JSONLogic). 미적재 = 불가조합 가드 부재(견적 유효성은
  가격엔진이 최종 판정하나, UI 제약 누락).
- **재현**:
  ```sql
  SELECT count(*) FROM t_prd_product_constraints
  WHERE prd_cd BETWEEN 'PRD_000016' AND 'PRD_000051';   -- 0
  ```
- **라우팅**: dbm-cpq-option-mapping (JSONLogic constraints 설계·적재).
- **참고**: authority-spec §5 CONFIRM 큐(Q-DGP-SPOT 등)는 결함 아님(권위 모호) — 본 MISSING과 구분.

### 1.4 추가상품 — MISMATCH 1 + MISSING 9

| prd_cd | 상품 | 판정 | 증상 | 권위 | 라이브 |
|--------|------|------|------|------|--------|
| PRD_000016 | 프리미엄엽서 | **MISMATCH** | 권위 1종 vs 라이브 5종 봉투 묶음 | 엽서봉투 100x150 | OPP접착/OPP비접착/트레싱/카드봉투W/B 5종 |
| PRD_000017 | 코팅엽서 | MISSING | addon 0 | 엽서봉투 100x150 | 0 |
| PRD_000018 | 스탠다드엽서 | MISSING | addon 0 | 엽서봉투 100x150 | 0 |
| PRD_000019 | 투명엽서 | MISSING | addon 0 | 엽서봉투 100x150 | 0 |
| PRD_000020 | 화이트인쇄엽서 | MISSING | addon 0 | 엽서봉투 100x150 | 0 |
| PRD_000021 | 핑크별색엽서 | MISSING | addon 0 | 엽서봉투 100x150 | 0 |
| PRD_000022 | 금은별색엽서 | MISSING | addon 0 | 엽서봉투 100x150 | 0 |
| PRD_000043 | 인쇄배경지(OPP봉투타입) | MISSING | addon 0 | 봉투 76x100 | 0 |
| PRD_000044 | 인쇄배경지(투명케이스타입) | MISSING | addon 0 | 투명케이스 74x74 | 0 |
| PRD_000045 | 인쇄헤더택 | MISSING | addon 0 | 봉투 80x80 | 0 |

- **도메인**: 추가상품 = 별 SKU(봉투/케이스), 별도 가격. addon 미적재 = 추가상품 견적 누락.
- **재현**:
  ```sql
  SELECT prd_cd, count(*) FROM t_prd_product_addons
  WHERE prd_cd BETWEEN 'PRD_000016' AND 'PRD_000051' GROUP BY prd_cd;  -- PRD_000016만 5, 나머지 0
  ```
- **라우팅**: dbm-option-mapper (addons + templates 적재). PRD_000016 MISMATCH는 권위 묶음 정합 재정의.

### 1.5 추가상품 템플릿 — MATCH 1 + MISSING 9

| prd_cd | 상품 | 판정 | 비고 |
|--------|------|------|------|
| PRD_000016 | 프리미엄엽서 | **MATCH** | 5 addon→5 template 100% 해소(del=N·selections 보유). 연결 정상 |
| PRD_000017~022, 043~045 | 엽서6·배경지3 | MISSING | 추가상품 needed=Y이나 연결 템플릿 0(addon 미적재 동반) |

- **★템플릿→추가상품 연결**: PRD_000016은 끊긴 묶음 0(연결 무결성 충족). 나머지 9는 적재 이전 단계.
- **재현**: link-integrity-matrix §2.2 쿼리.

---

## 2. N/A (needed=N — 인스펙터가 빠르게 닫음)

| 축 | N/A 상품 수 | 근거 |
|----|-----------:|------|
| 제약규칙 | 2 (PRD_000050 봉투제작·051 썬캡) | 권위 제약 표기 없음 |
| 추가상품 | 26 | 권위 추가상품 컬럼 공란 |
| 추가상품 템플릿 | 26 | 추가상품 없음→템플릿 불요 |

> 옵션그룹은 디지털 전 상품 needed=Y(N/A 0).

---

## 3. CONFIRM 큐 (권위↔라이브 모호·인간 확인)

| ID | 위치 | 모호 | 처리 |
|----|------|------|------|
| C-VAR-WHITE | PRD_000024·025 화이트인쇄(단면) | 별색공정 옵션항목 차원 ref 부재 — sentinel(UI표시만)인지 미적재 공정인지 모호 | sentinel 패턴(박없음/코팅없음)과 동형이나 "없음"이 아닌 실제 별색 → 인간 확인 |
| C-016-BUNDLE | PRD_000016 추가상품 | 권위(엽서봉투 1) vs 라이브(봉투 5종) — 라이브가 권위 확장인지 오적재인지 | 권위 묶음 재정의 필요 |

> CONFIRM은 결함이 아니다. 게이트는 NO-GO 사유로 삼지 않되 명시 추적.

---

## 4. 종합 (생성측 관점·게이트 재판정 전제)

- **연결 무결성은 건강**: 옵션→차원 264/264·템플릿→추가상품 5/5 해소, DEAD_LINK 0. 트리거가 강제.
- **갭의 본질은 광범위 미적재(MISSING 73)**: 디지털 36 중 옵션그룹 보유 15(그중 1 미완성), 제약 0, 추가상품 1.
  적재된 상품(엽서 일부·포토카드·접지카드·명함 일부·상품권·소량전단지)은 의미적으로 정합(인쇄/종이/코팅/모서리/후가공/접지/박/별색 그룹 + 100% 차원 해소).
- **stale 정정**: cpq-schema.md(2026-06-06)의 "options/option_items 0행"은 라이브 재실측으로 무효(현재 대량 적재).
- 모든 결함은 직접 교정 금지·dbm-option-mapper/dbm-cpq-option-mapping 라우팅.
