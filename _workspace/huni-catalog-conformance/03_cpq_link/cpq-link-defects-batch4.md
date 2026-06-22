# cpq-link-defects-batch4.md — 굿즈파우치 CPQ L2 연결 정합 결함 보드 + 연결 해소 매트릭스

> 생성측 인스펙터(hcc-cpq-link-inspector) · 라이브 읽기전용 SELECT 실측 2026-06-23 · DB 미적재.
> 대상: 굿즈파우치 라이브 98 prd (PRD_000183~280·del_yn=N) × cpq-link 4축 = **392 셀(빈 셀 0)**.
> 권위: authority-spec-batch4.md · domain-lens-batch4.md. 판정 게이트는 hcc-conformance-gate가 독립 재실측.

## 0. 셀 집계 (392)

| 축 | needed=Y | needed=N | MISSING | N/A | DEAD_LINK | ORPHAN | MISMATCH | EXTRA |
|----|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| 옵션그룹 | 67 | 31 | **67** | 31 | 0 | 0 | 0 | 0 |
| 제약규칙 | 0 | 98 | 0 | 98 | 0 | 0 | 0 | 0 |
| 추가상품 | 5 | 93 | **5** | 93 | 0 | 0 | 0 | 0 |
| 추가상품 템플릿 | 5 | 93 | **5** | 93 | 0 | 0 | 0 | 0 |
| **합계** | 77 | 315 | **77** | 315 | **0** | **0** | **0** | **0** |

확신도: 전 392 셀 HIGH(라이브 단순 부재 = 결정적).

## 1. 라이브 실측 (PRD_000183~280)

전 cpq 테이블이 **굿즈파우치 범위에서 0행**:

| 테이블 | 범위 내 prd | 전역 행수 | 전역 소유주(범위 외) |
|--------|:---:|:---:|----|
| t_prd_product_option_groups | 0 | 138 | 다른 상품군 |
| t_prd_product_options | 0 | — | — |
| t_prd_product_option_items | 0 | 480 | 다른 상품군 |
| t_prd_product_addons | 0 | 5 | **전부 PRD_000016(아크릴)** |
| t_prd_product_constraints | 0 | 10 | 다른 상품군 |
| t_prd_product_sets(템플릿) | 0 | — | — |
| t_prd_templates / selections | 0 | 13 / 15 | 다른 상품군 |

→ 배치1·2·3 동형: **굿즈파우치 CPQ 옵션레이어 전무.**

## 2. 결함 (전건 MISSING — 동일 결함 동형 압축)

### D-GP-CPQ-1 [MISSING·67건·옵션그룹] — variant/가공 택1 옵션레이어 전무
- 증상: 옵션 또는 가공 보유 67상품에 option_groups/options/option_items 0행.
- 권위 정답: GP-2(사이즈등급 S/M/L·용량·면·기종)·GP-PROC(고주파/승화/UV 택1) variant 택1 옵션그룹 needed=Y.
- 라이브: 0. 도메인: variant 선택 UI 없음 → 견적 환원 시 옵션 선택 불가.
- 라우팅: dbm-cpq-option-mapping (option_groups→options→option_items + polymorphic ref_dim_cd 배선).
- 대표: PRD_000186(사각손거울 SIZE)·PRD_000193(머그컵 VAR)·PRD_000227(미니우치와키링 PROC).

### D-GP-CPQ-2 [MISSING·5건·추가상품] — 추가상품 옵션 미배선
- 증상: 추가상품(옵션) 보유 5상품(PRD_000217 만년스탬프·221·222·223·226)에 addons 0행.
- 권위 정답: 잉크5cc/볼체인/아크릴스탠드/맥세이프 등 addon SKU needed=Y.
- 라이브: addons 5행은 전부 PRD_000016(아크릴) 소유 — 굿즈 귀속 0.
- 라우팅: dbm-cpq-option-mapping (t_prd_product_addons + tmpl_cd 묶음).

### D-GP-CPQ-3 [MISSING·5건·추가상품 템플릿] — addon SKU 묶음 템플릿 전무
- 증상: 추가상품 5상품과 동치인 templates/sets 0행.
- 권위 정답: 추가상품 보유 = 템플릿 묶음 동치 needed=Y(동일 5 prd).
- 라이브: t_prd_templates/selections/sets 범위 내 0.
- 라우팅: dbm-cpq-option-mapping (templates+selections 조립).

### 제약규칙 [N/A·98건] — 결함 아님
- needed 전건 N(엑셀 별표=폰케이스 신규기종 마커일 뿐·진짜 제약 0). 라이브 0행 = 범위 내 EXTRA 0 = 정합.

## 3. 연결 무결성 매트릭스 [HARD]

### 3-1. 옵션→차원 연결 (polymorphic ref_dim_cd)
| 항목 | 값 |
|------|----|
| 굿즈 option_items | **0** |
| 해소 대상 polymorphic 참조 | 0 |
| DEAD_LINK(고아 참조) | **0**(해소할 행 자체가 없음) |
| ORPHAN | **0** |
판정: 옵션레이어가 전무하므로 끊긴 참조는 발생 불가. **단, 적재 시점**에 67 옵션그룹의 option_items가
ref_dim_cd로 siz/print_opt/mat 실재 차원행을 100% 해소해야 함(현재 needed=Y인데 미적재라 dead-link 이전 단계 = MISSING). 게이트는 적재 명세 검증 시 fn_chk_opt_item_ref 무결성 강제.

### 3-2. 템플릿→추가상품 연결
| 항목 | 값 |
|------|----|
| 굿즈 templates/sets | **0** |
| 굿즈 addons | **0** |
| 끊긴 묶음(오배선) | 0(양쪽 모두 부재) |
| 권위 동치성 | addon needed=Y 5 prd ≡ template needed=Y 5 prd **완전 일치**(authority 정합) |
판정: 양 끝 모두 미적재 = 끊긴 묶음이 아니라 **전건 MISSING**. 적재 시 동일 5 prd(217·221·222·223·226)에
addons + templates 동치 배선 필요.

## 4. CONFIRM (권위 충돌·인간 확인 — 인스펙터 검증 반영)
- **C-GP-3(판형 85 EXTRA)**: basedata 축 소관(판형=t_prd_product_plate_sizes). cpq-link 4축에는 영향 없음 — 본 인스펙터 범위 외(basedata-inspector 라우팅).
- **C-GP-1(폰케이스 5종 미등록)**: 라이브 미존재 → 본 392 셀 모집단(98 prd)에 미포함. 등록 후 GP-2 옵션그룹 바인딩 필요(현 범위 제외).

## 5. 동형 전파
- 옵션그룹 67건 MISSING = 동일 결함 동형(대표 3종 종단 = 전파). 추가상품/템플릿 5건 = 동일 5 prd 양축 동치.
- 게이트는 대표(186·193·227·217) + 무작위 스팟 재실측으로 0행 동형 비준 권고.
