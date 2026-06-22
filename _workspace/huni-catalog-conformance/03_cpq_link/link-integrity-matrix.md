# link-integrity-matrix.md — 옵션→차원·템플릿→추가상품 연결 해소 매트릭스

> **Phase 2 — hcc-cpq-link-inspector(생성측)** · 2026-06-22 · `huni-catalog-conformance` §21
> 스코프: 디지털인쇄 36상품(PRD_000016~051). 라이브 읽기전용 SELECT(`.env.local RAILWAY_DB_*`).
> 본 문서는 사용자 핵심 요구 **★두 연결**(옵션→차원 polymorphic 해소·템플릿→추가상품 묶음)의 해소율·고아 목록.
> 판정은 게이트가 독립 재실측. 직접 교정 금지(라우팅만).

---

## 0. 한 줄 결론

- **옵션→차원 연결: 264/264 = 100% 해소, 고아(DEAD_LINK) 0건.** 트리거 `fn_chk_opt_item_ref`가
  INSERT/UPDATE 시점에 무결성을 강제하므로 적재된 option_item은 전부 실재 차원행을 가리킨다.
- **템플릿→추가상품 연결: PRD_000016의 5 addon→5 template 100% 해소(MATCH).** 다른 추가상품 needed=Y
  상품 9종은 addon·template 자체가 미적재(연결 이전 단계 MISSING).
- **연결 무결성은 건강하다. 결함의 본질은 "끊긴 연결"이 아니라 "적재 자체의 광범위 미충족"**(옵션그룹 21,
  제약 34, 추가상품/템플릿 9 MISSING). 즉 dead link가 아니라 not-yet-loaded가 디지털 CPQ의 지배적 갭.

> ⚠️ **stale 정정:** 재사용 입력 `cpq-schema.md`(2026-06-06)는 "options 0행·option_items 0행"으로 기록했으나
> 라이브 재실측 결과 디지털 스코프 option_groups 61·options 281·option_items 264(del_yn=N)로 **그 이후 대량 적재됨**.
> 본 매트릭스는 라이브 실측이 권위.

---

## 1. 옵션→차원 (polymorphic ref_dim_cd) 해소율

### 1.1 전역 해소 (디지털 스코프, del_yn=N)

| ref_dim_cd | 의미 | 대상 차원 t_* | 키 | 참조 수 | 해소 | 고아(DEAD_LINK) |
|------------|------|---------------|----|--------:|-----:|----------------:|
| OPT_REF_DIM.03 | 자재 | t_prd_product_materials | mat_cd=ref_key1, **usage_cd=ref_key2** | 143 | 143 | **0** |
| OPT_REF_DIM.04 | 공정 | t_prd_product_processes | proc_cd=ref_key1 | 96 | 96 | **0** |
| OPT_REF_DIM.06 | 도수 | t_prd_product_print_options | **opt_id=ref_key1::int** | 25 | 25 | **0** |
| .01 사이즈·.02 판형·.05 묶음수·.07 셋트 | — | — | — | 0 | 0 | 0 |
| **합계** | | | | **264** | **264 (100%)** | **0** |

- **해소 재현 쿼리(.03 자재 예):**
  ```sql
  SELECT count(*) total,
         count(*) FILTER (WHERE m.prd_cd IS NULL) orphan
  FROM t_prd_product_option_items oi
  LEFT JOIN t_prd_product_materials m
    ON m.prd_cd=oi.prd_cd AND m.mat_cd=oi.ref_key1 AND m.usage_cd=oi.ref_key2
  WHERE oi.prd_cd BETWEEN 'PRD_000016' AND 'PRD_000051'
    AND oi.del_yn='N' AND oi.ref_dim_cd='OPT_REF_DIM.03';   -- 143 total, 0 orphan
  ```
- **도메인 정합:** 도수 키가 `opt_id`(clr_cd 아님)로 적재됨 = cpq-schema §2 MISMATCH-1 정정이 라이브 반영.
  자재가 (mat_cd, usage_cd) 2키 복합으로 정상 해소 = 옵션=자재+공정 BUNDLE 의미([[dbmap-option-material-process-bundle]])와 정합.
- **고아 목록: 없음.** 트리거가 DB FK 불가한 polymorphic 참조를 BEFORE INSERT/UPDATE EXISTS 검사로 강제.

### 1.2 상품별 옵션→차원 해소 (옵션그룹 보유 15상품)

| prd_cd | 상품 | grp | item(.03/.04/.06) | 빈 옵션(item 0) | 해소율 | 비고 |
|--------|------|----:|-------------------|----------------:|-------:|------|
| PRD_000016 | 프리미엄엽서 | 7 | 41 | 0 | 100% | 인쇄/종이/모서리/오시/미싱/가변텍스트/가변이미지 |
| PRD_000017 | 코팅엽서 | 4 | 8 | 1(코팅없음) | 100% | 빈=sentinel |
| PRD_000018 | 스탠다드엽서 | 4 | 15 | 0 | 100% | 후가공=SEL_TYPE.02(택N) |
| PRD_000024 | 포토카드 | 4 | 7 | 1(화이트인쇄단면) | 100% | ⚠️ 빈=별색공정 추정(아래 §3 D-VAR) |
| PRD_000025 | 투명포토카드 | 4 | 4 | 1(화이트인쇄단면) | 100% | ⚠️ 빈=별색공정 추정 |
| PRD_000026 | 종이슬로건 | 3 | 5 | 1(코팅없음) | 100% | 빈=sentinel |
| PRD_000027 | 2단접지카드 | 5 | 25 | 3(접지가로/세로·박없음) | 100% | 종이13·박8·도수1·가변2·접지sentinel |
| PRD_000029 | 3단접지카드 | 5 | 25 | 3 | 100% | 동형 |
| PRD_000031 | 프리미엄명함 | 5 | 30 | 1(박없음) | 100% | |
| PRD_000032 | 코팅명함 | 4 | 8 | 1(코팅없음) | 100% | |
| PRD_000033 | 스탠다드명함 | 4 | 11 | 0 | 100% | |
| PRD_000041 | 스탠다드 쿠폰/상품권 | 3 | 10 | 0 | 100% | |
| PRD_000042 | 프리미엄 쿠폰/상품권 | 4 | 22 | 1(박없음) | 100% | |
| PRD_000046 | 라벨/택 | 1 | **0** | 3(나뭇잎/별타공/리니니) | **N/A** | 🔴 그룹만·옵션항목 0=미완성(§3 D-LABEL) |
| PRD_000047 | 소량전단지 | 4 | 53 | 1(코팅없음) | 100% | |

- **빈 옵션 17건의 성격(차원 미참조)**: 대부분 **sentinel**(코팅없음·박없음·접지방향 가로/세로 — 차원행 불필요한
  "미적용/UI방향" 선택지, default=Y 다수) → DEAD_LINK 아님. 단 **2그룹은 CONFIRM/MISMATCH 후보**:
  ① 화이트인쇄(단면)(024/025) = 권위상 별색 **공정**인데 ref 없음, ② 라벨/택 커팅모양(046) = 커팅 공정인데 ref 없음.

---

## 2. 템플릿→추가상품 연결 묶음

### 2.1 추가상품 needed=Y 10상품의 연결 상태

| prd_cd | 상품 | 권위 추가상품 | 라이브 addon | template 해소 | 판정 |
|--------|------|---------------|-------------:|---------------|------|
| PRD_000016 | 프리미엄엽서 | 엽서봉투(100x150) | **5** | 5/5 실재(del=N)·selections 보유 | **MISMATCH**(묶음 내용 상이) |
| PRD_000017 | 코팅엽서 | 엽서봉투(100x150) | 0 | — | MISSING |
| PRD_000018 | 스탠다드엽서 | 엽서봉투(100x150) | 0 | — | MISSING |
| PRD_000019 | 투명엽서 | 엽서봉투(100x150) | 0 | — | MISSING |
| PRD_000020 | 화이트인쇄엽서 | 엽서봉투(100x150) | 0 | — | MISSING |
| PRD_000021 | 핑크별색엽서 | 엽서봉투(100x150) | 0 | — | MISSING |
| PRD_000022 | 금은별색엽서 | 엽서봉투(100x150) | 0 | — | MISSING |
| PRD_000043 | 인쇄배경지(OPP봉투타입) | 봉투(76x100) | 0 | — | MISSING |
| PRD_000044 | 인쇄배경지(투명케이스타입) | 투명케이스(74x74) | 0 | — | MISSING |
| PRD_000045 | 인쇄헤더택 | 봉투(80x80) | 0 | — | MISSING |

### 2.2 PRD_000016 addon→template 묶음 해소 상세 (★연결 검증 핵심)

| addon tmpl_cd | 템플릿명 | base_prd_cd | del_yn | selections | 해소 |
|---------------|----------|-------------|--------|-----------:|------|
| TMPL-000005 | OPP접착봉투 110x160 mm 50장 | PRD_000001 | N | 1 | ✅ |
| TMPL-000006 | OPP비접착봉투 110x160 mm 50장 | PRD_000002 | N | 2 | ✅ |
| TMPL-000009 | 트레싱지봉투 160x110 mm 20장 | PRD_000283 | N | 1 | ✅ |
| TMPL-000010 | 카드봉투(화이트) 165x115 mm 50장 | PRD_000281 | N | 1 | ✅ |
| TMPL-000011 | 카드봉투(블랙) 165x115 mm 50장 | PRD_000282 | N | 1 | ✅ |

- **연결 무결성: 5/5 = 100% 해소, 끊긴 묶음(고아 템플릿) 0.** 모든 addon이 실재·비삭제 템플릿을 가리키고
  각 템플릿은 template_selections(사이즈·묶음수 freeze)를 보유 → 추가상품이 견적·주문에 정상 붙음.
- **단, 권위 묶음과 내용 불일치(MISMATCH)**: 권위(상품마스터)는 PRD_000016 추가상품 = **"엽서봉투 100x150" 1종**.
  라이브는 **봉투 5종**(OPP접착/OPP비접착/트레싱지/카드봉투 화이트/블랙) — 권위에 없는 봉투가 묶임. EXTRA 성격 동반.
  → 게이트가 "권위 묶음 1 vs 라이브 묶음 5"의 정합을 재판정. 묶음 연결 자체는 살아있음(끊김 아님).
- 재현 쿼리:
  ```sql
  SELECT a.tmpl_cd, t.tmpl_nm, t.base_prd_cd, t.del_yn,
         (SELECT count(*) FROM t_prd_template_selections s WHERE s.tmpl_cd=a.tmpl_cd) sel_cnt
  FROM t_prd_product_addons a LEFT JOIN t_prd_templates t ON t.tmpl_cd=a.tmpl_cd
  WHERE a.prd_cd='PRD_000016' ORDER BY a.disp_seq;
  ```

---

## 3. 연결 관점 결함 후보 (게이트 재판정 대상)

| ID | 위치 | 증상 | 영향 | 라우팅 |
|----|------|------|------|--------|
| D-LABEL | PRD_000046 라벨/택 | 옵션그룹(커팅모양) 1개만·옵션항목 0·커팅 공정 미참조 | 라벨 커팅 옵션이 견적/생산에 환원 안 됨 | dbm-option-mapper |
| D-VAR | PRD_000024·025 화이트인쇄(단면) | 별색 공정 옵션인데 option_item 차원 ref 없음 | 별색공정이 가격/생산에 연결 안 됨(단 sentinel 가능성) | CONFIRM→dbm-cpq-option-mapping |
| D-016-ADDON | PRD_000016 추가상품 | 권위=엽서봉투 1 vs 라이브=봉투 5종 묶음 | 견적에 권위 외 추가상품 노출/권위 항목 부재 | dbm-option-mapper |

> ★ 연결 자체(polymorphic 해소·템플릿 실재)는 0 고아. 위 후보는 "연결의 내용·완성도" 문제이지 dead link 아님.
