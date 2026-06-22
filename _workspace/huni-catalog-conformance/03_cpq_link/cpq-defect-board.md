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

---

# 배치1 — 포토북·캘린더 13상품 (PRD_000100~112) · 2026-06-22

> Phase 2 hcc-cpq-link-inspector(생성측). 스코프: 포토북 PRD_000100~107(본체1+반제품7)·캘린더 PRD_000108~112.
> 디지털인쇄 파일럿을 동형 자(尺)로 적용. 라이브 읽기전용 SELECT. 직접 교정 금지(라우팅만).

## B1.0 판정 분포 (52셀 = 13상품 × 4축)

| 축 | MATCH | MISMATCH | MISSING | DEAD_LINK | N/A | 계 |
|----|------:|---------:|--------:|----------:|----:|---:|
| 옵션그룹 | 0 | 0 | 11 | 0 | 2 | 13 |
| 제약규칙 | 0 | 0 | 6 | 0 | 7 | 13 |
| 추가상품 | 0 | 0 | 1 | 0 | 12 | 13 |
| 추가상품 템플릿 | 0 | 0 | 1 | 0 | 12 | 13 |
| **합계** | **0** | **0** | **19** | **0** | **33** | **52** |

- **옵션→차원 연결**: 참조 0 / 해소 0 → **DEAD_LINK 0**(연결할 option_item 자체가 0행 = vacuously clean).
- **템플릿→추가상품 연결**: PRD_000108 addon 0·template 0 → 끊긴 묶음 0(적재 이전 단계).
- 지배 결함 = **MISSING 19**(needed=Y 셀 전부). 포토북·캘린더는 **CPQ 옵션 레이어 전무**.

## B1.1 라이브 실측 사실 (3원 ②)

| 상품 | prd_typ | grp/opt/item | constr | addon | tmpl(base) |
|------|---------|-------------:|-------:|------:|-----------:|
| PRD_000100 포토북[본체] | PRD_TYPE.04 | 0/0/0 | 0 | 0 | 0 |
| PRD_000101 내지(몽블랑130) | PRD_TYPE.02 | 0/0/0 | 0 | 0 | 0 |
| PRD_000102 표지(하드커버) | PRD_TYPE.02 | 0/0/0 | 0 | 0 | 0 |
| PRD_000103 표지(아트250+무광) | PRD_TYPE.02 | 0/0/0 | 0 | 0 | 0 |
| PRD_000104 면지(그레이) | PRD_TYPE.02 | 0/0/0 | 0 | 0 | 0 |
| PRD_000105 표지(레더하드) | PRD_TYPE.02 | 0/0/0 | 0 | 0 | 0 |
| PRD_000106 표지(레더) | PRD_TYPE.02 | 0/0/0 | 0 | 0 | 0 |
| PRD_000107 표지(소프트) | PRD_TYPE.02 | 0/0/0 | 0 | 0 | 0 |
| PRD_000108 탁상형캘린더 | PRD_TYPE.04 | 0/0/0 | 0 | 0 | 0 |
| PRD_000109 미니탁상형캘린더 | PRD_TYPE.04 | 0/0/0 | 0 | 0 | 0 |
| PRD_000110 엽서캘린더 | PRD_TYPE.04 | 0/0/0 | 0 | 0 | 0 |
| PRD_000111 벽걸이캘린더 | PRD_TYPE.04 | 0/0/0 | 0 | 0 | 0 |
| PRD_000112 와이드벽걸이캘린더 | PRD_TYPE.04 | 0/0/0 | 0 | 0 | 0 |

- PRD_TYPE.04 = 완제/세트(본체·캘린더 6), PRD_TYPE.02 = 반제품(내지/표지/면지 7).
- 반제품 7 중 101/104(내지·면지)=옵션그룹 needed=N, 102/103/105/106/107(표지)=표지타입 택일 needed=Y.
- 재현:
  ```sql
  SELECT p.prd_cd, p.prd_typ_cd,
    (SELECT count(*) FROM t_prd_product_option_groups g WHERE g.prd_cd=p.prd_cd AND g.del_yn='N'),
    (SELECT count(*) FROM t_prd_product_constraints c WHERE c.prd_cd=p.prd_cd AND c.del_yn='N')
  FROM t_prd_products p WHERE p.prd_cd BETWEEN 'PRD_000100' AND 'PRD_000112' AND p.del_yn='N'
  ORDER BY p.prd_cd;   -- 전 행 grp=0·constr=0
  SELECT count(*) FROM t_prd_product_addons  WHERE prd_cd BETWEEN 'PRD_000100' AND 'PRD_000112';  -- 0
  SELECT count(*) FROM t_prd_templates WHERE base_prd_cd BETWEEN 'PRD_000100' AND 'PRD_000112';   -- 0
  ```

## B1.2 결함 행 (MISSING 19)

### 옵션그룹 MISSING 11
- 대상: PRD_000100(본체 주문방법·표지타입), 102/103/105/106/107(표지타입 택일), 108~112(주문방법·캘린더가공 택일).
- 증상: 권위 옵션성 컬럼 존재하나 라이브 option_groups/options/option_items 0행 → 옵션선택·차원환원 불가.
- 도메인: 캘린더=주문방법(편집기)+캘린더가공 택일·포토북=주문방법+표지타입 택일이 항상 needed(domain-lens).
- 라우팅: **dbm-option-mapper**.

### 제약규칙 MISSING 6
- 대상: PRD_000100(블리드·책등 10/12/14/16), 108~112(블리드·캘린더 제약 주석).
- 증상: 권위 제약 표기 존재하나 라이브 constraints 0행(전 DB 8행 전부 비대상)·**t_prd_products.constraint_json 컬럼 부재**(checklist target_table의 `constraint_json` 표기는 스키마에 없음 → 게이트 확인 항목).
- 라우팅: **dbm-cpq-option-mapping**(JSONLogic).

### 추가상품 MISSING 1 + 템플릿 MISSING 1 (PRD_000108 탁상형캘린더)
- 증상: 권위 추가상품(옵션) 표기 존재하나 addon 0·연결 template 0. base_prd_cd in 100~112 = 0행.
- ★연결: 끊긴 묶음(dead link)이 아니라 묶을 addon·template 자체 미적재(적재 이전 단계).
- 라우팅: **dbm-option-mapper**(addon+template).

## B1.3 ★연결 무결성 결론 (사용자 강조)

- **옵션→차원 polymorphic 해소: 측정 대상 0건**(option_item 0행). 고아·DEAD_LINK 0. 단 "건강"이 아니라
  "연결 이전". 적재 후 반드시 fn_chk_opt_item_ref로 재검증 필요(게이트 노트).
- **템플릿→추가상품 묶음: 0건**(PRD_000108 addon 0). 끊긴 묶음 0이나 묶음 자체 부재.
- 디지털 파일럿(264/264 해소·5/5 템플릿)과 대비 — 포토북·캘린더는 적재 자체가 0인 **전(全) 미적재 상태**.

## B1.4 N/A 33 (needed=N — 빠르게 닫음)

| 축 | N/A 수 | 근거 |
|----|-------:|------|
| 옵션그룹 | 2 (PRD_000101 내지·104 면지) | 반제품 PRD_TYPE.02·옵션 레이어 비대상 |
| 제약규칙 | 7 (101~107) | 반제품 역할 외 축 |
| 추가상품 | 12 (100~107·109~112) | 엑셀 추가상품 미사용 |
| 추가상품 템플릿 | 12 (동일) | 추가상품 없음→템플릿 불요 |

## B1.5 게이트/codex 라우팅

- **GATE-1**: `t_prd_products.constraint_json` 컬럼 부재 — checklist target_table 표기 오류인지, 캐시 컬럼이
  다른 이름인지 게이트 독립 재실측 필요(디지털 보드도 동일 표기 사용 → 횡단 정정 가능성).
- **GATE-2**: PRD_TYPE.04(완제) vs .02(반제품) 경계가 옵션그룹 needed 분기와 정합한지 게이트 확인.
- codex: 전 미적재라 옵션→차원 오배선 의심 없음. 단 PRD_000108 추가상품 권위 표기 내용(어떤 SKU 묶음인지)을
  엑셀에서 codex 독립 추출해 향후 적재 정답 후보로 둘 것(현 단계는 MISSING 확정).

---

## 배치2 — 책자·문구·상품악세사리 (2026-06-23, hcc-cpq-link-inspector 생성측)

> 스코프: 책자10(PRD_000068·069·070·071·072·077·082·088·094·097)·문구9(172~179·181)·악세15(001~015).
> 라이브 읽기전용 SELECT. ★GATE-1 반영: 제약 target=`t_prd_product_constraints(logic jsonb)`만(constraint_json 부재).
> 판정은 게이트 독립 재실측. 직접 교정 금지·라우팅만.

### B2.0 한 줄 결론

- **DEAD_LINK 3건 — 사이즈 고아(논리삭제 마스터 참조).** 책자 068·069·071의 옵션 `사이즈` A5 계열
  option_item이 **del_yn=Y 처리된 siz 마스터행**(SIZ_000170 A5·SIZ_000253 A5세로·SIZ_000255 A4가로)을 가리킨다.
  사용자가 A5를 고르면 차원 환원이 끊겨 **견적 불가**. 디지털·배치1에서 0였던 dead link가 배치2에서 처음 출현.
- **옵션그룹 광범위 미적재(MISSING 15) + 추가상품 미연결(MISSING 13)** 이 지배적 갭. 책자 6종(070·072·077·082·088·097)·
  문구 9종 전부 옵션그룹 미구현(070은 "Test" 잡음 1개=실질 0). 악세 13종은 addon 연결 0(어느 본상품에도 안 붙음).
- **악세 addon 연결: 15개 중 단 2개만 살아있음(MATCH).** OPP접착봉투(001)·OPP비접착봉투(002)만 template로
  프리미엄엽서(PRD_000016) addon에 연결. 나머지 13개(카드봉투류·금속/목재 부속·리필잉크)는 묶음 자체 부재.
- **EXTRA 잡음:** 악세 001 제약1행·001/002 옵션그룹 잔여(테스트/제본방식·items0)는 권위 근거 없음.

### B2.1 결함 행

| ID | 위치 | 축 | 증상 | 권위 정답 | 라이브 | 도메인 | 판정 | 라우팅 |
|----|------|----|------|-----------|--------|--------|------|--------|
| **B2-DL-068SIZ** | PRD_000068 중철책자 / 옵션 사이즈 | 옵션그룹(옵션→차원) | A5 옵션항목이 SIZ_000170(del_yn=Y) 가리킴 | A5 사이즈 선택→실재 활성 siz 환원 | option_item ref_key1=SIZ_000170, 마스터 del_yn=Y | 옵션=차원행 포인터(L2). 삭제된 행=환원 실패 | **DEAD_LINK** | dbm-option-mapper |
| **B2-DL-069SIZ** | PRD_000069 무선책자 / 옵션 사이즈 | 옵션그룹 | A5(SIZ_000170 del=Y) | 동상 | 동상 | 동상 | **DEAD_LINK** | dbm-option-mapper |
| **B2-DL-071SIZ** | PRD_000071 트윈링책자 / 옵션 사이즈 | 옵션그룹 | A5(170)·A5세로(253)·A4가로(255) 3건 모두 del=Y | 동상(3사이즈) | ref→삭제 마스터 3건 | 동상 | **DEAD_LINK** | dbm-option-mapper |
| **B2-OG-MISS** | 책자 070·072·077·082·088·097 (6) + 문구 9 (15 prd) | 옵션그룹 | 옵션그룹 0행(070=Test 잡음 1개·items0) | 주문방법·제본/표지/내지옵션 택일 | option_groups 미적재 | CPQ 옵션 선택 불가 | **MISSING** | dbm-option-mapper |
| **B2-ADDON-MISS** | 악세 003~015 (13 prd) | 추가상품 | 이 prd를 base로 묶은 template 0=어느 본상품 addon에도 미연결 | 부속물이 본상품 addon SKU로 연결 | addon 연결 미적재 | 끊긴 묶음=추가상품 견적·주문 미부착 | **MISSING** | dbm-option-mapper |
| **B2-EXTRA-001C** | PRD_000001 OPP접착봉투 / 제약 | 제약규칙 | 권위 제약 0건인데 라이브 1행 | needed=N(별표 0) | logic: siz∈{078/079/080}→bdl_qty=50 | siz 참조는 실재·JSONLogic 정합하나 권위 부재 | **EXTRA** | dbm-cpq-option-mapping |
| **B2-EXTRA-OG** | PRD_000001(테스트)·002(제본방식) / 옵션그룹 | 옵션그룹 | needed=N인데 EXTRA 잡음 그룹 적재(items0) | 악세=옵션 미사용 | 001 "테스트"·002 "제본방식" | 부속물에 부적절한 옵션그룹 | **EXTRA**(N/A 셀에 부기) | dbm-option-mapper |

### B2.2 재현 쿼리

```sql
-- DEAD_LINK: 사이즈 옵션항목이 논리삭제 siz 마스터를 가리킴 (책자 4종 중 3종 고아 5건)
SELECT oi.prd_cd, o.opt_nm, oi.ref_key1, (s.siz_cd IS NULL) AS dead_link
FROM t_prd_product_option_items oi
JOIN t_prd_product_options o ON oi.prd_cd=o.prd_cd AND oi.opt_cd=o.opt_cd
LEFT JOIN t_siz_sizes s ON s.siz_cd=oi.ref_key1 AND s.del_yn='N'
WHERE oi.prd_cd IN ('PRD_000068','PRD_000069','PRD_000071','PRD_000094')
  AND oi.del_yn='N' AND oi.ref_dim_cd='OPT_REF_DIM.01'
ORDER BY oi.prd_cd;   -- 11 total, 5 dead (068×1,069×1,071×3) ; 094 0 dead

-- 악세 addon 연결: base_prd_cd가 악세인 template을 소비하는 본상품
SELECT a.tmpl_cd, t.base_prd_cd, string_agg(DISTINCT a.prd_cd,',') consumers
FROM t_prd_product_addons a JOIN t_prd_templates t ON t.tmpl_cd=a.tmpl_cd
WHERE t.base_prd_cd BETWEEN 'PRD_000001' AND 'PRD_000015'
GROUP BY a.tmpl_cd, t.base_prd_cd;   -- TMPL-000005(base 001)·TMPL-000006(base 002) → PRD_000016 만

-- 옵션그룹 미적재
SELECT prd_cd, count(*) FROM t_prd_product_option_groups
WHERE prd_cd IN (책자6+문구9) AND del_yn='N' GROUP BY prd_cd;  -- 070=1(Test), 나머지 0
```

### B2.3 CONFIRM 추적 (결함 아님)

- **Q-PA-ADDON 부분 해소:** 악세 001/002는 addon으로 연결됨(자체 고정가 SKU + 본상품 addon 양립 확인) →
  나머지 13개는 연결 자체 부재라 "본상품 가산 여부"를 논하기 전 단계. 게이트·codex가 권위 의도 재확인.
- **Q-BK-떡메모지(PRD_000097):** 옵션그룹 0행 — 책자/문구 어느 권위로 봐도 미적재(MISSING). 영향 동일.
