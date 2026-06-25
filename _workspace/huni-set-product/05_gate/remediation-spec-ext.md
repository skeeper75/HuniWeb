# 교정 명세 — 남은 6셋트 구조 보정 (동형 전파 2차·BLOCKED 라우팅)

생성: hsp-set-gate · 라이브 읽기전용 실측(2026-06-24) 근거 · 구조 보정 본체는 **GO(CONDITIONAL)**, 아래는 적재본 분리 BLOCKED분.
포맷: `{결함·권위 정답·교정 방법·대상 t_*·FK 위상·돈영향·라우팅 트랙·인간 승인 필요}`.

---

## A. 적재 GO 큐 (load-executor·인간 승인 후 COMMIT)

| 결함 | 권위 정답 | 교정 | 대상 t_* | 돈영향 | 라우팅 | 인간승인 |
|---|---|---|---|---|---|---|
| 6셋트 부모 유형 04(디자인)→완제품 미반영 | directive(셋트 부모=완제품)·094 선례(PRD_TYPE.01 COMMIT)·admin.py:1095(디자인 셋트부모 허용) | prd_typ_cd 04→01 (6 UPDATE·`IS DISTINCT FROM` 멱등) | t_prd_products | 없음(분류만) | load-executor(apply-ext.sql §1) | **필요**(directive 권위·돈 아님) |
| 26 구성원 disp_seq 미정렬(전부 1)·note 역할 모호 | set-checklist row2-29·booklet-l1 | disp_seq 단조 + note 역할 prefix (26 UPSERT) | t_prd_product_sets | 없음 | load-executor(apply-ext.sql §2) | 불요(구조보정·게이트 GO) |

조건: apply-ext.sql 헤더 "신규 mint 0·전부 보정/UPDATE" → "UPSERT(라이브 26행 실재 확인·신규 INSERT 0)" 문구 정정(데이터 불변·D3).

---

## B. BLOCKED 분리 (적재본 제외·별도 트랙)

### B-1. BLOCKED-PRICE-6 — 6셋트 견적불가 (돈 크리티컬)
- **결함**: 부모 6 가격공식 바인딩 0행 + 구성원 26 바인딩 0행 + 구성원 26 직접단가 0행 → evaluate_set_price base_total=0 → **PRICE=0 견적불가**.
- **권위 정답**: 6셋트는 표지+면지/내지+제본 조립 완제품 → 셋트 제본/조립 가격공식 필요.
- **★진단 구분(엽서북 교훈 적용)**: 엽서북 30P는 "comp 존재·미바인딩→오청구"였으나, **6셋트는 셋트공식·구성요소·단가가 라이브에 아예 없음(진성 부재)**. 견적 자체 불가(과소/과대청구가 아님). 게이트 라이브로 094 대조군(PRF_PCB_FIXED 보유) 대비 0행 확증.
- **교정 방법**: §18 가격엔진 설계(셋트 제본/조립 공식 PRF_BIND_* 류 신설) → dbmap 적재.
- **대상 t_***: t_prc_price_formulas·formula_components·price_components·component_prices + t_prd_product_price_formulas(바인딩).
- **돈영향**: 큼(견적 산출 자체 불가능 → 신설 필요).
- **라우팅**: §18 → 인간 승인 후 dbmap. **인간승인 필요**.

### B-2. GUARD-1 — 택1 평면합산 금지 가드 (가격 설계 계약·★택1 합산0 재확인)
- **게이트 재실측**: 면지/표지 평면 다중행(072=면지3·082/088=면지4·100=표지5)이 **현재 가격공식0·직접단가0**이라 **동시 전달해도 각 contribution=0·합산 오염 0**(라이브 확증). 따라서 현 상태 택1 합산은 **무해**(과대청구 아님)·행 보존이 정답.
- **미래 위험**: BLOCKED-PRICE-6 해소(가격 신설) 시 면지/표지에 공식·차원이 붙으면 평면 member 합산이 **즉시 과대청구로 전환**(RC-2 always-add 함정 동형).
- **교정 계약**: 가격 신설 시 면지/표지 택1은 **member 평면합산 금지** → 옵션축(상품뷰어 자재/옵션 택1)으로 모델링·evaluate_set_price 호출단이 택1 1개만 members 전달 보증.
- **라우팅**: §18 가격설계 계약(BLOCKED-PRICE-6와 동반). **인간승인 필요**.

### B-3. RM-4 — 페이지 가변 미충전 (차원 모델)
- **게이트 판정**: 하드/링(072/077/082/088) 라이브 셋트행에 **내지 member 없음**(표지+면지 행만·내지=MES `*별도설정`). 페이지(24~300/+2·8~100/+2)는 셋트-member 범위(min/max/incr)가 아니라 **부모상품 페이지옵션** 소관. NULL 유지 정당(권위 침묵). 떡메 50/100은 t_prd_product_bundle_qtys 별 테이블 실재(라이브 확증·묶음수≠member-qty).
- **교정 방법**: 부모 페이지축 옵션 등록 + 내지 member 등록 결정(MES별도설정 해소 여부).
- **대상 t_***: t_prd_product_option_groups/options(페이지축) 또는 t_prd_product_sets(내지 member 신규)·dbmap 결정.
- **라우팅**: dbmap/CPQ. **인간승인 필요**.

### B-4. RM-2 — 면지 자재 4종 재배선 (기초코드·t_mat 공유마스터)
- **결함**: 면지 자재(화이트/블랙/그레이/인쇄)=용도성이 자재로 오등록 가능성·t_mat 공유마스터 수술(영향 큼).
- **교정 방법**: 논리삭제 + 출력소재 귀속 + 용도축 분리 — **셋트 행 보정과 분리**(공유 마스터라 다른 상품 영향).
- **대상 t_***: t_mat_materials(공유)·다른 상품 참조 SELECT 선행 필수.
- **라우팅**: dbmap/basecode·게이트 GO + **인간승인 필요**.

### B-5. CONFIRM-3 — 포토북 권위 모호
- **결함**: 포토북(100) booklet-l1 권위행 미특정(표지5/내지1/면지1 구성·페이지 미특정).
- **교정**: 구조보정은 라이브 현황 기준 GO(이미 적재 GO 큐). 페이지/구성 권위는 권위 시트(photobook-l1?) 특정·실무진 확인.
- **라우팅**: 권위 시트 특정·실무진. **인간승인 필요**(권위 확정).

---

## C. 인간 승인 큐 요약

| 승인 항목 | 종류 | 우선순위 | 트랙 |
|---|---|---|---|
| 6셋트 유형 04→01 적재 (D1) | 적재 GO(directive 권위) | High | load-executor(apply-ext.sql §1) |
| 26 disp_seq/note 보정 적재 | 적재 GO(구조보정) | High | load-executor(apply-ext.sql §2) — 유형과 동반 |
| BLOCKED-PRICE-6 셋트공식 신설 | 신규 설계 | High(돈) | §18 → dbmap |
| GUARD-1 택1 옵션축 모델링 계약 | 설계 계약 | High(가격 신설과 동반) | §18 |
| RM-4 페이지축·내지 member 등록 | 차원 결정 | Medium | dbmap/CPQ |
| RM-2 면지 자재 재배선 | 공유마스터 수술 | Medium | dbmap/basecode |
| CONFIRM-3 포토북 권위 특정 | 권위 확정 | Low(구조 GO) | 권위 시트·실무진 |
