# cpq-link-defects-batch3.md — 스티커·아크릴·실사 CPQ L2 연결 정합 결함 보드

> **Phase 2 — hcc-cpq-link-inspector(생성측)** · 2026-06-23 · §21 배치3
> 라이브 65 prd(스티커16·실사28·아크릴21) × 4축(옵션그룹·제약규칙·추가상품·추가상품템플릿) = **260셀**.
> 권위[HARD]=두 엑셀 / 라이브 실측(읽기전용 SELECT) / 도메인 의미 3원 대조. 생성측 — 게이트가 독립 재실측.
> 직접 교정 금지·라우팅만. 셀=`cpq-link-cells-batch3.csv`.

## 0. 셀 집계 (빈 셀 0)

| verdict | 옵션그룹 | 제약규칙 | 추가상품 | 추가상품템플릿 | 합계 |
|---------|---------|---------|---------|----------------|------|
| MATCH | 18 | 7 | – | – | 25 |
| MISSING | 45 | 22 | 2 | 7 | **76** |
| MISMATCH | 2 | – | – | – | 2 |
| EXTRA | – | – | – | 1 | 1 |
| N/A(needed=N 정합) | – | 36 | 63 | 57 | 156 |
| **합계** | 65 | 65 | 65 | 65 | **260** |

---

## 1. ★연결 무결성 [HARD] — 두 연결 결과

### 1.1 옵션→차원 (polymorphic ref_dim_cd) — **해소율 100% (DEAD_LINK 0)**

- 라이브 batch3 option_items **69행**(ref_dim_cd NULL 0행) 전수 LEFT JOIN 해소 = **69/69 해소**.
- 무결성 권위 = 트리거 `fn_chk_opt_item_ref`(ref_dim_cd→대상 차원 테이블·prd 스코프 일치 검사) 그대로 적용.
- soft-delete(del_yn=Y) 통한 dead link도 **0건**(대상 차원행 전부 del_yn='N' 활성).
- 배치3에 쓰인 dim: `OPT_REF_DIM.03`(자재 materials, 25) · `.04`(공정 processes, 40) · `.06`(도수 print_options, 4).
- ★배치2의 DEAD_LINK 5건(siz del_yn=Y → A5 차단) 같은 끊김 **배치3에는 없음**.

| ref_dim_cd | 대상 차원 테이블 | 검사 | 해소 |
|-----------|------------------|------|------|
| OPT_REF_DIM.03 | t_prd_product_materials(mat_cd+usage_cd) | 25 | 25/25 ✅ |
| OPT_REF_DIM.04 | t_prd_product_processes(proc_cd) | 40 | 40/40 ✅ |
| OPT_REF_DIM.06 | t_prd_product_print_options(opt_id::int) | 4 | 4/4 ✅ |
| **합계** | | **69** | **69/69 = 100%** |

### 1.2 템플릿→추가상품 — **needed 7 전부 MISSING + 테스트 잔재 1 EXTRA**

- 아크릴 조합형(조각수형) 세트조합 SKU PRD_000160~166 = template needed=Y 7건 → 라이브 t_prd_templates 0행 = **MISSING 7**.
- 라이브 batch3 템플릿은 **TMPL-000013 1건뿐**: base=PRD_000136(PET배너)·tmpl_nm="테스트 템플릿"·needed=N.
  - selection이 `OPT_REF_DIM.04 PROC_000015`(공정) 1건만 묶음 = **추가상품 묶음 아님**(끊긴 묶음 아니라 잘못 만들어진 묶음).
  - → **EXTRA**(테스트 잔재). PET배너는 권위상 템플릿 needed=N.
- 추가상품(t_prd_product_addons): batch3 전체 **0행**. 아크릴 볼체인 needed=Y 2건(146·158) → MISSING 2.

---

## 2. 결함 보드 (위치·증상·권위정답·라이브·도메인·재현쿼리·라우팅)

### D-B3-CPQ-1 [MISSING ×45] 옵션그룹 전무 — 옵션레이어 미적재
- **위치**: 옵션그룹 needed=Y 65 중 라이브 그룹 보유 20 → 45 prd 옵션레이어 전무.
  - 스티커 12(054·056~065·067) / 실사 19(119·123·126~132·140~144 등) / 아크릴 14(147~166 단품·조합형).
- **증상**: option_groups 0행 = 시뮬레이터에서 소재/가공/별색 택일 UI 부재 → 차원환원 불가(견적 조립 불가).
- **권위정답**: 전 상품 최소 "주문방법+소재/가공/별색 택일" 옵션그룹 needed(authority-spec §1·domain-lens §4).
- **도메인**: 옵션그룹=L2 옵션 레이어(차원행 polymorphic 포인터). 배치1·2와 동형(옵션레이어 전무 다수).
- **재현**: `select prd_cd from t_prd_products p where (스코프) and not exists(select 1 from t_prd_product_option_groups g where g.prd_cd=p.prd_cd and g.del_yn='N');`
- **라우팅**: dbm-option-mapper(옵션레이어 설계·적재). 클래스=구조 미충전(돈크리티컬 아님).

### D-B3-CPQ-2 [MISSING ×22] 제약규칙 미등록 — 실사 비규격 경계 + 스티커 소량
- **위치**: 제약 needed=Y 29 중 라이브 7만(118·120·121·122·124·125·139) → MISSING 22.
- **증상**: t_prd_product_constraints 0행 = 사용자입력 치수 min/max 가드 부재 → 비규격 입력 무제한 통과.
- **권위정답**: 실사 비규격(최소/최대)_가로/세로 → width/height min·max JSONLogic. 스티커 소량(*1조각) 1건.
- **도메인**: 제약=불가조합 enumerate 금지·jsonb logic. 실사 면적 입력 경계가 핵심(domain-lens §3·§4).
- **라이브 정합분(MATCH 7)**: RULE_TYPE.01 `{"or":[{"!=":["size_mode","nonspec"]},{"and":[{">=":["width",200]},...]}]}` — JSONLogic 구조 건전.
- **재현**: `select prd_cd from t_prd_product_constraints where (스코프) and del_yn='N';` (라이브 7만 반환).
- **라우팅**: dbm-cpq-option-mapping(제약 JSONLogic 설계).

### D-B3-CPQ-3 [MISSING ×2] 추가상품 미연결 — 아크릴 볼체인
- **위치**: PRD_000146(아크릴키링)·PRD_000158(아크릴포카키링) 추가상품 needed=Y → addon 0행.
- **증상**: t_prd_product_addons 0행 = 볼체인 등 부속물이 견적·주문에 안 붙음.
- **권위정답**: 상품마스터 아크릴 볼체인(146·158) 추가상품 컬럼. 부속물=자재+공정 BUNDLE([[dbmap-option-material-process-bundle]]).
- **도메인**: 가공(부속물)=자석/핀/볼체인 한 옵션이 부속물(자재)+부착(공정) 이중의미 → mat+proc 구분등록·template 묶음.
- **라우팅**: dbm-option-mapper(추가상품 묶음)·dbm-cpq-option-mapping(BUNDLE 구분등록). CONFIRM Q-ACR-부속물BUNDLE 동반.

### D-B3-CPQ-4 [MISSING ×7] 추가상품 템플릿 미배선 — 아크릴 조합형 세트조합 SKU
- **위치**: PRD_000160~166(자유형스탠드/판아크릴/포카스탠드/미니파츠/코롯토/포카코롯토/카라비너) → t_prd_templates 0행.
- **증상**: 조각수(2/10조각)×본체 조합 세트 SKU가 견적 불가(세트 조합 미배선).
- **권위정답**: 상품마스터 아크릴 조합형(조각수형) 세트조합 컬럼(authority-spec §2.3).
- **도메인**: 조합형=본체+받침/조각 조합 → 추가상품 템플릿(t_prd_templates·template_selections) 축.
- **라우팅**: dbm-cpq-option-mapping(템플릿 묶음 설계). 가격엔진 MISSING 20(아크릴 147~166)과 동반(Q-ACR-MISSING20).

### D-B3-CPQ-5 [MISMATCH ×2] 옵션그룹 config 무결성 — PET배너 거치대 + 아크릴키링 고리
- **PRD_000136(PET배너) 거치대구매여부 그룹** [HIGH]:
  - mand_yn=Y인데 `min_sel_cnt`/`max_sel_cnt` **NULL** (필수그룹 선택 수 미정).
  - 옵션 OPV-000020(실외용거치대)는 **option_item 0행 = 차원 미배선**(짝 OPV-000019 실내용은 MAT_000178 연결).
    → 비대칭 배선: 실외용거치대 선택 시 자재 환원 실패(반쪽 dead link).
  - **재현**: `select o.opt_cd,o.opt_nm,(select count(*) from t_prd_product_option_items oi where oi.opt_cd=o.opt_cd and oi.del_yn='N') from t_prd_product_options o where o.prd_cd='PRD_000136' and o.opt_grp_cd='OPT-000009';` → OPV-000020=0.
- **PRD_000146(아크릴키링) 고리 그룹** [HIGH]: `sel_typ_cd` **NULL**(택1/택N 미정)·min/max NULL.
- **라우팅**: dbm-cpq-option-mapping(그룹 sel_typ/min/max 충전 + OPV-000020 option_item 생성).

### D-B3-CPQ-6 [EXTRA ×1] 테스트 템플릿 잔재 — TMPL-000013
- **위치**: t_prd_templates `TMPL-000013` base_prd_cd=PRD_000136(PET배너)·tmpl_nm="테스트 템플릿"·use_yn=Y.
- **증상**: needed=N(PET배너 템플릿 불요)인데 라이브 존재. selection=`PROC_000015`(공정) 1건만 묶음 = 추가상품 세트 아닌 잔재.
- **재현**: `select tmpl_cd,base_prd_cd,tmpl_nm from t_prd_templates where tmpl_nm like '%테스트%';`
- **라우팅**: dbm-cpq-option-mapping(테스트 데이터 정리·use_yn=N 또는 논리삭제). 운영 영향 낮음(돈크리 아님).

---

## 3. 과대청구(silent 합산) 면 — batch3 CPQ 영역 0
- authority-spec §4 재사용: 미검증 4시트(sticker·acrylic·silsa·goods-pouch) 과대청구 스캔 적출 0.
- CPQ 영역도 정합: 옵션레이어 전무 다수=silent 합산 자체 불가, 라이브 옵션→차원 100% 해소(고아 0)로 잘못 매칭 없음.

## 4. CONFIRM 추적 (결함 아님·인간 확인)
- Q-ACR-MISSING20 / Q-ACR-부속물BUNDLE: 추가상품·템플릿 MISSING(D-3·D-4)이 종속. 고정가형 vs 가공가산형·BUNDLE 구분등록 기준 인간 확인.
- Q-SILSA-투명포스터: 라이브 미등록(checklist 행 0)이라 본 인스펙터 스코프 외.

## 5. 라우팅 요약
| 결함 | 라우팅 트랙 | 클래스 |
|------|-------------|--------|
| D-1 옵션그룹 MISSING 45 | dbm-option-mapper | 구조 미충전 |
| D-2 제약 MISSING 22 | dbm-cpq-option-mapping | 구조 미충전 |
| D-3 추가상품 MISSING 2 | dbm-option-mapper + cpq-option | BUNDLE(Q-ACR-부속물) |
| D-4 템플릿 MISSING 7 | dbm-cpq-option-mapping | 세트조합(Q-ACR-MISSING20) |
| D-5 그룹 config MISMATCH 2 | dbm-cpq-option-mapping | 무결성 |
| D-6 테스트 잔재 EXTRA 1 | dbm-cpq-option-mapping | 정리 |

> 직접 교정 금지. 실 COMMIT/DDL은 인간 승인 후 dbmap 트랙. 게이트가 독립 재실측·codex 2nd opinion.
