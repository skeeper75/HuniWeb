# 엽서북(PRD_000094) 셋트 구성 설계 — 종단 파일럿

생성: hsp-set-designer · 권위=상품마스터(260610) 절대 · 라이브 읽기전용 실측 · **DB 미적재**(적재본 조립까지).
입력: `01_authority/`(set-authority-spec·set-checklist·product-type-board·reuse-map) · `02_reference/`(domain-set-bom·competitor-set-reference·gap-fill-candidates) · `raw/webadmin/catalog/pricing.py`(evaluate_set_price·evaluate_price 계약).

---

## 0. 결론 요약

| 항목 | 결과 |
|---|---|
| 셋트 구성원 | **2행**(내지 PRD_000095 · 표지 PRD_000096) — 기존 셋트 **보정**(신규 mint 0) |
| 유형 교정 | PRD_000094 `prd_typ_cd` **04(디자인) → 01(완제품)** (라이브 현재값 04 실측 확인) |
| 개수규칙 | 내지(95) **min20/max30/incr10**(권위 booklet-l1 row61) 충전 · disp_seq 1→{내지1, 표지2} 보정 |
| 가격 사슬 | **GO** — 셋트 완제품(94) 자기 공식 **PRF_PCB_FIXED** 단독으로 PRICE≠0 견적(구성원 합산 0 + set_eval≠0) |
| 면지 정규화 | 엽서북 **N/A**(종이 2종만 참조) · 면지 4종 자재 오등록은 **확장 phase**(하드커버/링책자 4상품) 스펙으로 명세 |
| 적재본 행수 | t_prd_product_sets **2행**(UPDATE 보정) + t_prd_products **1행**(유형 UPDATE) |
| BLOCKED | 30P 단가행 부재(가격 데이터 갭·dbmap) · 면지 자재 수술(공유 마스터·인간 승인) |

---

## 1. 셋트 구성원 설계 (t_prd_product_sets · 보정)

라이브 실측(`t_prd_product_sets where prd_cd='PRD_000094'`):

| prd_cd | sub_prd_cd | 역할 | 현재 sub_prd_qty | 현재 min/max/incr | 현재 disp_seq | 비고 |
|---|---|---|---|---|---|---|
| PRD_000094 | PRD_000095 | 내지(몽블랑240) | 1 | NULL/NULL/NULL | **1** | 내지 |
| PRD_000094 | PRD_000096 | 표지(스노우300) | 1 | NULL/NULL/NULL | **1** | 표지 |

**보정 설계** (권위 set-checklist row20-21 + booklet-l1 row61):

| sub_prd_cd | 역할 | sub_prd_qty | min_cnt | max_cnt | cnt_incr | disp_seq | note | 근거 |
|---|---|---|---|---|---|---|---|---|
| PRD_000095 | 내지 | 1 | **20** | **30** | **10** | **1** | 내지=몽블랑240·페이지20~30/+10 | booklet-l1 row61 내지페이지 20/30/10(권위 명시) |
| PRD_000096 | 표지 | 1 | NULL | NULL | NULL | **2** | 표지=스노우300·1권고정 | 표지 1 per 책(권위 표지1·도메인 §4) |

**보정 내용 (2가지)**:
1. **내지 가변범위 충전** — 내지(95) min_cnt/max_cnt/cnt_incr = 20/30/10. 표지(96)는 NULL 유지(표지=셋트 수량과 1:1, 가변 없음).
   - 의미: 내지 페이지(떼어낼 엽서 장수) 20장 또는 30장 택1. evaluate_set_price의 `derive_inner_sheets(copies, pages, pansu)` 입력 차원. (단, 엽서북은 셋트공식 단독 견적이라 §3 참조 — 이 가변범위는 UI 옵션·생산정보로 보존하되 현 가격엔진은 셋트공식에서 페이지를 직접 차원으로 안 씀.)
2. **disp_seq 보정** — 둘 다 1 → 내지1·표지2(표시순서 명확화).

### 1.1 택1 그룹 vs always-add 함정 점검 (CONFIRM-2·§21 교훈)

- 엽서북 구성원은 **내지 1종·표지 1종**(동일 역할 다중 구성원 **없음**) → 택1 그룹 이슈 **해당 없음**.
- 하드커버/링책자(면지 3~4종 = 동일 역할 다중 sub_prd_cd)는 택1 그룹 설계 필요하나 **엽서북 파일럿 범위 밖**.
- always-add 가드: 엽서북은 구성원 합산이 가격에 기여하지 않으므로(§3) 평면 합산 오염 위험 0.

---

## 2. 셋트 부모 유형 교정 (directive 1 · t_prd_products UPDATE)

**라이브 실측**: `PRD_000094 엽서북 prd_typ_cd = PRD_TYPE.04` (디자인상품), use_yn=Y, del_yn=N.

**교정**: `PRD_TYPE.04 → PRD_TYPE.01`(완제품).

- 근거: 엽서북은 표지+내지+떡제본으로 조립되는 **완제품 셋트**(제조 대상). 디자인상품(04)은 directive 분류 제외 대상.
- 영향: prd_typ_cd는 webadmin 셋트 인라인 노출 규칙(admin.py:1095 "반제품만 제외")에 영향. 01(완제품)은 셋트 부모로 유효(반제품 아님) → 인라인 노출 유지. **셋트 구성원(95/96)은 PRD_TYPE.02 유지**(불변).
- 멱등: `UPDATE ... SET prd_typ_cd='PRD_TYPE.01' WHERE prd_cd='PRD_000094' AND prd_typ_cd<>'PRD_TYPE.01'` (이미 01이면 0행).

> 주의[CONFIRM-1]: 권위 큐레이터가 셋트 완제품 7개 전부 04인 것을 정책 충돌(admin 주석=반제품만 제외)로 보고했다. 이번 directive는 **엽서북 1건만** 01로 교정 — 나머지 6셋트의 유형 교정은 본 파일럿 범위 밖(인간 정책 확인 후 확장).

---

## 3. 가격 정합 사슬 점검 (directive 3 · evaluate_set_price)

### 3.1 가격공식 바인딩 실측

| 상품 | 가격공식 | 단가/구성요소 |
|---|---|---|
| PRD_000094 (셋트 완제품) | **PRF_PCB_FIXED** (apply_bgn_ymd=2026-06-01) | "엽서북 사이즈/면/페이지/수량별 단가" use_yn=Y |
| PRD_000095 (내지 구성원) | **없음** | 사이즈/공정/자재 전부 0 |
| PRD_000096 (표지 구성원) | **없음** | 사이즈/공정/자재 전부 0 |

### 3.2 PRF_PCB_FIXED 종단 사슬 (라이브 실측)

```
PRF_PCB_FIXED
 ├─ COMP_PCB_S1_20P (엽서북 완제품가 단면·20p) use_dims=[siz_cd, min_qty, print_opt_cd] · 단가행 117 (2,200~12,000)
 └─ COMP_PCB_S2_20P (엽서북 완제품가 양면·20p) use_dims=[siz_cd, min_qty, print_opt_cd] · 단가행 117 (2,300~12,500)
차원 충전: PRD_000094 등록 사이즈 SIZ_000003/004/124 = 단가행 siz_cd와 정합 ✅
          print_opt_cd POPT_000001(단면)/POPT_000002(양면) = 면 차원 ✅
          min_qty = 수량구간(2,4,10,...,1000 이상) ✅
```

### 3.3 evaluate_set_price 적용 (pricing.py:718)

`evaluate_set_price` = Σ(구성원 evaluate_price) + 셋트 완제품 자기 공식(evaluate_price(94)) + 할인 1회.

- **구성원 합산**: 95/96 가격공식·차원 0 → 각 base.amount=0 → 합산 기여 **0** (warnings: "유효수량 산출 실패/매칭 없음").
- **셋트공식 (set_eval)**: `evaluate_price({"prd_cd":"PRD_000094"}, {siz_cd, print_opt_cd, min_qty}, copies)` → FORMULA 소스 PRF_PCB_FIXED → 차원매칭 단가행 1개 included → **PRICE≠0**.
- **결론**: 엽서북은 **셋트 완제품 자기 공식이 단독으로 견적을 내는 구조**(구성원 합산 없이). 권위 공식명 "수량×(사이즈·면·페이지) 표에서 단가 조회"와 정합.

→ **가격 사슬 = GO** (PRICE≠0 계산 가능).

### 3.4 이중합산 점검

- 두 comp(단면 S1·양면 S2)는 **print_opt_cd로 배타 매칭**(동시매칭 실측 = 0행: S1@양면 0 / S2@단면 0). addtn_yn=Y지만 선택된 면 1개만 included → **silent 이중합산 없음** ✅.
- 구성원가가 0이라 셋트공식과 이중 계상 위험도 0(구성원 합산형 아님·셋트공식 단독형).

### 3.5 가격 BLOCKED (분리)

- **30P 단가행 부재**: PRF_PCB_FIXED 구성요소가 **20P 전용** 2개뿐(COMP_*_20P). 단가행 note 전부 "20P". 권위는 페이지 20/30 택1인데 **30P comp·단가행 라이브 부재** → 30P 선택 시 견적 불가(매칭 0).
  - 라우팅: 가격 데이터 갭 → **§18 가격엔진 설계 / dbmap 적재 트랙**(30P 단가행·comp 신설·인간 승인). set-designer는 셋트 행만 보정·가격공식 신설 안 함.

---

## 4. 면지 자재 정규화 스펙 (directive 4)

### 4.1 엽서북 실측 = N/A

엽서북(94)·구성원(95/96)이 참조하는 자재(t_prd_product_materials):

| prd_cd | mat_cd | mat_nm |
|---|---|---|
| PRD_000094 | MAT_000092 | 스노우지 300g (표지 출력소재) |
| PRD_000094 | MAT_000109 | 몽블랑 240g (내지 출력소재) |

→ **엽서북은 면지 자재를 참조하지 않음**(종이 2종만). 직물·면지성 자재 오등록 **없음**. directive 4의 면지 정규화는 **엽서북 N/A**.

### 4.2 면지 자재 오등록 실재 (확장 phase 대상)

t_mat_materials 전수 검색 결과 **용도성이 자재로 오등록된 면지 4종 실재**:

| mat_cd | mat_nm | 참조 상품(t_prd_product_materials) |
|---|---|---|
| MAT_000001 | 화이트면지 | PRD_000072·077·082·088 (하드커버/링책자 4상품) |
| MAT_000002 | 블랙면지 | PRD_000072·077·082·088 |
| MAT_000003 | 그레이면지 | PRD_000072·077·082·088 |
| MAT_000004 | 인쇄면지 | PRD_000082·088 (링책자/레더링바인더 2상품) |

이들은 **출력소재(종이)가 아니라 "면지=용도성"**이 자재 마스터에 오등록된 것(directive 4 진단 적중). 단 **엽서북엔 영향 없음** → 확장 phase(하드커버/링책자) 적용 대상.

### 4.3 재배선 설계 스펙 (확장 phase · t_mat 공유 마스터 수술 → 게이트 GO+인간 승인 후)

> ★엽서북 적재본에는 **포함하지 않는다**(N/A). 하드커버/링책자 셋트 설계 시 적용할 스펙으로만 명세.

```
(a) 논리삭제: MAT_000001~004 (화이트/블랙/그레이/인쇄 면지) del_yn='Y' (용도성 자재 제거)
(b) 출력소재 귀속: 면지의 실제 종이(예 컬러 색지·인쇄용지)를 t_mat_materials에 정규 자재로 search-before-mint 후 등록,
    하드커버/링책자 셋트 구성원(면지 sub_prd_cd)이 그 정규 자재를 참조하도록 재배선.
(c) 용도(면지) 축 분리: "면지"는 상품뷰어 자재추가의 **용도 축**(예 SEMI_ROLE.03 면지 + 색상 옵션)으로 등록,
    자재(종이)와 용도(면지 슬롯)를 분리.
```
- 영향: t_mat 공유 마스터 + 4~6상품 구성원 재배선 → **돈/영향 큼**. 실 실행은 게이트 GO + 인간 승인 후 **dbmap/basecode 트랙** 위임. set-designer는 스펙만.
- search-before-mint: 면지의 실제 종이 자재를 신규 mint하기 전 라이브 t_mat_materials에서 동일 종이 존재 확인 필수.

---

## 5. search-before-mint 증거

| 항목 | 라이브 실재 | 처리 |
|---|---|---|
| 셋트 부모 PRD_000094 | ✅ 존재(prd_typ_cd=04) | 참조·유형 UPDATE만 |
| 구성원 PRD_000095(내지) | ✅ PRD_TYPE.02 존재 | 기존 sub 참조(보정만) |
| 구성원 PRD_000096(표지) | ✅ PRD_TYPE.02 존재 | 기존 sub 참조(보정만) |
| 셋트 행(94→95, 94→96) | ✅ 2행 존재 | **UPDATE 보정**(신규 INSERT 0) |
| 가격공식 PRF_PCB_FIXED | ✅ 존재·구성요소·단가행 충전 | 참조만(공식 신설 0) |
| 면지 정규 자재 | (확장 phase) | 신규 mint 금지·dbmap 위임 |

**신규 mint = 0**. 전부 기존 라이브 엔티티 참조·보정.

---

## 6. 스키마 주의 (라이브 실측 vs 권위 스펙)

- **semi_role_cd 컬럼 부재**: set-authority-spec/reuse-map은 models.py에 `semi_role`이 있다고 했으나, **라이브 t_prd_product_sets 스키마에는 semi_role_cd 컬럼이 없다**(컬럼 전수: prd_cd·sub_prd_cd·sub_prd_qty·disp_seq·note·reg_dt·upd_dt·del_yn·del_dt·min_cnt·max_cnt·cnt_incr). 역할 구분은 **note**(내지=…/표지=…)로만 표현. → 적재본은 라이브 실스키마 컬럼만 사용(semi_role 미적재).
- PK = 복합(prd_cd, sub_prd_cd) → ON CONFLICT 멱등 키.
- 가격공식 바인딩 테이블(t_prd_product_price_formulas)에 use_yn/del_yn 없음(apply_bgn_ymd만) — 변경 무관(읽기만).
