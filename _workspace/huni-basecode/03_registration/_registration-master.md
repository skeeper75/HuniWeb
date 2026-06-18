# 등록 명세 마스터 — 후니 기초코드 거버넌스 Phase 3 (전 축 통합)

> **하네스** hbg Phase 3 설계가(`hbg-registration-designer`). **작성** 2026-06-18. **최종 산출.**
> **입력:** Phase 2 진단(`02_diagnosis/*`) + Phase 1 정답 사전(`01_authority/*`) + 재사용(rpmeta V-3·dbmap DDL/code-strategy·admin-screen-map).
> **축별 명세:** `regspec-material.md`(자재) · `regspec-category.md`(카테고리) · `regspec-scaffold.md`(나머지 4축 틀).
> **[HARD] 명세 ≠ 적용.** CREATE/ALTER/COMMIT 0. 실 적재 = `dbm-axis-staged-load`/`dbm-load-execution` 인간 승인 후. 적재경로 불명 = "미상" 정직 표기.

---

## 0. 한 줄 평결

**1순위 자재·카테고리 결함은 거의 전부 축이동/교정 — 신규 그릇은 vessel-gap(형상 V-12·비치수 size) 2건뿐, MAT_TYPE/카테고리 신규 코드행 0.** 자재 **89행 축이동** + **.10→.07 교정 ~17** + 봉투 정리 5 + 카테고리 **소프트삭제 11 + 재연결 2**가 핵심. **사용자 컨펌 4건 확정(2026-06-18)으로 자재축 컨펌 잔여 0**(B-MAT-3·AX-1·부속typ·AC-2 전건 해소). **FK load-bearing(BOM 177 link)이 적재순서를 지배** — 본체 소재 선적재 → 목적지 적재 → **BOM link 제거(GPM-4) → 오염행 del_yn='Y' 마지막**. component_prices 참조 0이라 가격사슬은 안전.
>
> **★컨펌 확정 4건(2026-06-18·사용자):** ① **B-MAT-3** = .08 색 5 **본체색 고정·자재 유지**(옵션 아님) ② **AX-1** = .10 잉크색 7 **주문 옵션 확정**(도수/별색 아님) ③ **.10 3용도 분해** = ②부자재 ~17(.10→.07)·③봉투 5(정리)·placeholder 6(skip)·볼체인색8+잉크색7(옵션) — 단순 .10→.07 통합 금지 ④ **C-CAT-1** = CAT_000302/304 **활성 상품 재연결**(소프트삭제 금지·upr_cat_cd 보정)·CAT_000294만 소프트삭제. **AC-2** = 두께=자재 식별자 확정·dbmap 31_acrylic 위임.
>
> **★삭제 권위(2026-06-18·B5 blind-spot):** 소프트삭제 권위 = **del_yn='Y'(+del_dt)**(조회/BOM/가격 선택지 차단)·use_yn은 부차 토글(조회 미차단). 진짜 미완 = **BOM link 제거**(소프트삭제만으론 기존 BOM/그리드 mat_cd 런타임 참조 잔존). 라이브 del_yn='Y'는 임시책(TRUNCATE 재적재 시 휘발) → 근본 = 경로 Y(v03 오염행 제거·개발자 재적재).
>
> **★컨펌 큐 전건 해소(2026-06-18) — 잔여 0건.** 5건 전부 사용자 결정/활성화로 해소(B-MAT-3·AX-1·부속typ·AC-2 + C-CAT 부모매칭). 카테고리 302/304 부모 = CAT_000302→**CAT_000134**(데스크소품)·CAT_000304→**CAT_000198**(응원/시즌) 확정(라이브 SELECT 근접 매칭·동명 부재). **1순위 자재·카테고리 축 컨펌 0.**

---

## 1. 채번·멱등·적재경로 공통 규약 (전 축)

> dbmap `code-identifier-strategy.md` D1~D5 비준 인용.

| 규약 | 내용 |
|------|------|
| **채번** | `PREFIX_` + lpad(라이브 MAX(suffix)+1,6,'0'). 자재 `MAT_000337~`·siz `SIZ_NNNNNN`·공정 `PROC_NNNNNN`·카테고리 `CAT_NNNNNN`. 코드행 `GROUP.NN`. separator `_`(하이픈 폐기). |
| **멱등 키** | 이름 기반 — 자재 `(mat_nm,mat_typ_cd)`·카테고리 `(cat_nm,upr_cat_cd)`·코드행 `(cod_cd)`. NOT EXISTS 가드. 신규 DDL 0 지향. |
| **적재경로(catalog Django)** | 자재 `tmatmaterials__add/change` · 카테고리 `tcatcategories__add/change` · 코드행 `tcodbasecodes__add/change`(BaseCodeAdminForm·그룹채번). |
| **적재경로(product-viewer pvEdit 섹션)** | siz=`sizes` · 인쇄면=`print_options` · 묶음=`bundle_qtys` · 공정=`processes` · BOM=`materials` · 카테고리연결=`categories` · 옵션=`option_items` 드릴다운 3계층. |
| **★소프트삭제 권위 [HARD·정정]** | hard-delete 금지 — **`del_yn='Y'`(+`del_dt`=now()) 소프트삭제만**(항상 마지막). del_yn = 조회/BOM/가격 선택지 차단 권위(`admin.py:452-461` exclude·`cfg_utils logical_delete`·`views.py` `del_yn='N'` 필터). **use_yn = 부차 활성 토글**(조회 미차단). 진단 §del_yn 권위 관계 인용. |
| **★멱등 가드 [HARD·정정]** | **`WHERE del_yn='N'`**(이미 'Y'면 skip) + **del_yn·use_yn 둘 다 추적**(단독 금지·B5 blind-spot 재발 방지). |
| **reg_dt 함정** | NOT NULL DEFAULT — 명시 NULL 금지(admin UI 자동). |

---

## 2. ★ FK 위상 핵심 [HARD]

> 모든 자재 축이동·카테고리 정리의 실행 순서를 지배. 위반 시 본체 BOM 전손.

```
[자재 축이동 — round-22 GPM-4 인용]
 ① 본체 소재 .05/.06 자재 link 선적재 (GPM-1/2 41행 INSERT 설계 GO·미COMMIT)
 ② 비소재 값 목적지 축 적재:
      형상 → t_siz_sizes + shape_cd(SHAPE 코드·shape-axis DDL)
      비치수 size → t_siz_nonspec_sizes(신규 마스터·goods-pouch DDL)
      색(4종+) → option_items (트리거 fn_chk_opt_item_ref: ref 차원 선존재)
      인쇄면 → t_prd_product_print_options.print_side
      구수 → t_prd_product_bundle_qtys
      잉크색 → option_items (★AX-1 확정: 주문 옵션·도수/별색 아님)
 ③ 오염 .09/.10 BOM link 제거/재배선 (GPM-4·177건 USAGE.07)  ← 진짜 미완
 ④ 오염 .09/.10 자재행 del_yn='Y'(+del_dt)  ← 마지막(소프트삭제 권위)
   ※ .08 색 5(본체색·B-MAT-3 확정)·②부자재 ~17(.10→.07)은 자재 유지(삭제 아님)
```

| 사실(라이브 실측) | 함의 |
|-------------------|------|
| 오염 .08/.09/.10 BOM link = **177**(전건 usage_cd=USAGE.07·본체 슬롯·80/82 상품) | FK load-bearing — 삭제 선행 시 본체 자재 link 전손 → 재배선 후 del_yn='Y' 마지막 |
| **del_yn='Y' 효과 = 신규 선택 UI 숨김까지만**(`price_views.py:537-538` "그리드는 기존 셀 코드 보존"·BOM JOIN mat del_yn 미필터) | **진짜 미완 = BOM link 제거(GPM-4)** — 소프트삭제만으론 기존 BOM/그리드 mat_cd 런타임 참조 잔존. .09 69행 이미 del_yn='Y'이나 BOM link 113 활성 = blind-spot 실증 |
| 라이브 del_yn='Y'(143행) = admin UI 논리삭제 흔적(load_master del_yn 미명시→DEFAULT 'N') | TRUNCATE 재적재 시 'N'으로 휘발 → 임시책·근본 = 경로 Y(v03 오염행 제거·개발자 재적재·P-TRUNCATE 가드) |
| 오염행 **component_prices 참조 = 0**(.08/.09/.10 전건) | **가격사슬 안전** — 축이동/삭제가 단가행 파손 없음 |
| 카테고리 정상 leaf 273 main='Y' 무손상·CAT_000294 상품 0 | 카테고리 소프트삭제가 상품 카테고리 파손 없음 |

---

## 3. 등록 명세 건수 집계 (전 축)

### 3.1 자재 (regspec-material.md)

| 라우팅 | 행수 | 신규 mint | 즉시/컨펌 |
|--------|:--:|:--:|------|
| 축이동 ④→②siz+SHAPE(.09 shape 18+size 11) | 29 | siz 일부·SHAPE 코드6·nondim 마스터 | 치수 즉시·비치수 DDL |
| 축이동 ④→옵션 색(.09 color21+.10 볼체인색8+.10 잉크색7) | **36** | 0(자재 del_yn='Y') | **확정**(AX-1 잉크색 옵션) |
| 축이동 ④→print_side(.09 14) | 14 | 0 | **즉시** |
| 축이동 ④→bundle(.09 count4+other1) | 5 | 0 | **즉시** |
| **★BOM link 제거(GPM-4)** | 오염 .09/.10 link 177 | — | 본체 선적재·축이동 후 |
| **★오염 자재행 소프트삭제 del_yn='Y'** | (축이동분) | — | **마지막**(use_yn 아님) |
| 교정 mat_typ .10→.07(②부자재) | **~17** | 0(UPDATE) | **확정**(3용도 분해) |
| 정리(③봉투 placeholder·placeholder/헤더) | **5+6** | 0(del_yn='Y') | **확정** |
| 자재 유지(.08 본체색·B-MAT-3 확정) | (5) | 0 | **확정**(소재별 본체색) |
| 교정 두께 분리(AC-2 확정·dbmap 위임) | (22상품) | 두께별 mat_cd | **확정**·dbmap 31_acrylic |
| 신규 코드행(MAT_TYPE·MAT_FACET·신소재) | **0** | 0 | 보류(.05 흡수) |

**자재 축이동 = 89행**(②siz 29+옵션색 36+print_side 14+bundle 5·.10 잉크색 8→7 정정) + BOM link 제거 177(GPM-4) + 교정 .10→.07 ~17 + 봉투/헤더 정리 11 + 아크릴 22(dbmap) + 신규 0. **컨펌 잔여 0**(자재축 전건 확정).

### 3.2 카테고리 (regspec-category.md)

| 라우팅 | 노드수 | 즉시/컨펌 |
|--------|:--:|------|
| 카테고리 소프트삭제 del_yn='Y'(신규) CAT_000294 | 1 | **즉시** |
| 카테고리 소프트삭제 del_yn='Y'(round-22 del_yn 미완 보정) | 10 | **즉시** |
| **재연결 CAT_000302/304(C-CAT-1 해소·활성화)** | 2 | upr_cat_cd UPDATE·**소프트삭제 금지**·부모매칭 컨펌 |
| 신설 | 0 | — |

### 3.3 4축 (사이즈·도수·인쇄옵션·공정 — 전수 명세 2026-06-18)

> 2차 회차 전수 완성: `regspec-{size,color,printoption,process}.md`. scaffold(`regspec-scaffold.md`)는 요약 인덱스로 승격.

> **[B4·B2·B5 정정 — 검증자 NO-GO 반영]:** ref_param_json 신규 컬럼 철회(기존 dtl_opt 재사용)·UV 14/7 분기·option_items 행 선적재·가격 formula 간접경로. **4축 신규 mint = 0.**

| 축 | t_* | 핵심 실 조치 | 신규 mint | 컨펌 |
|----|-----|-------------|:--:|------|
| ② 사이즈 🟡 | t_siz_sizes(520) | **SZ-1 색오염 2행 교정**(siz_nm 정규화·무비용·가격 0참조) | 0 | SZ-2(형상 칼틀) |
| ③ 도수 🟢 | t_clr_color_counts(5) | **0건**(폐쇄 SEED·정상·빈 라우팅) | 0 | 없음 |
| 인쇄옵션 🔴 | t_prd_product_print_options(166) | **PO-1 UV 변형 63행 축이동**(print_side→**기존 dtl_opt**·PO-1a 14/PO-1b 7·**underbase=UV param 확정**) | **0**(dtl_opt 재사용·B4) | **B-PO-1 ✅해소**·잔여 PO-1b 정체 |
| ⑤ 공정 🟡 | t_proc_processes(102) | **기존 dtl_opt 재사용**(param 채움·data-gap) + **레이플랫 PROC_000025 소프트삭제 1**(AX-6 ✅해소·연결 0) | **0**(B4·신설 철회) | 잔여 AX-5(이관 범위) |

**4축 = 즉시 교정 2(SZ-1) + 축이동 63(PO-1a 42/PO-1b 21) + dtl_opt 재사용 채움(신규 컬럼 0) + 레이플랫 소프트삭제 1(AX-6 확정) + 판정불가 30(SZ-2 형상+EA). 신규 mint·컬럼·코드행·테이블 = 0.**

### 3.4-bis ★ 공정 PR-1 ↔ 인쇄옵션 PO-1 합류 (FK 위상 [HARD·B4·B5])

```
[목적지 = 기존 t_prd_product_option_items.dtl_opt (신규 컬럼 ALTER 아님·B4)]
[PO-1a UV 14 실연결 — 즉시]
 ① 해당 14상품 option_items 행 선적재 (현재 0행·B5)   ← 진짜 선결
 ② UV 변형값을 기존 dtl_opt로 이관 ({"변형":"풀빼다"} 등)
 ③ print_side를 단면/양면 정규화(UPDATE)
[PO-1b UV 7 무연결 — 공정 링크 선행]
 ⓪ PROC_000002 product_processes 링크 선적재 + 정체 컨펌(코롯토164/카라비너166 round-22 BLOCKED)
 ①~③ 이후 동일
   ※ 행/링크 선결 위반 시 고아 param·변형 구분 소실 → round-23 아크릴 가격사슬 손실(formula 간접·골든 불변)
```

- **★[B4] 신규 ref_param_json 컬럼 신설 철회** — `t_prd_product_option_items.dtl_opt` jsonb 라이브 실재(6행 공정 param 실사용)·UV 변형 동형 → 재사용. vessel-gap → data-gap 격하. prcs_dtl_opt(스키마)와 역할 구분=값(인스턴스).
- **★[B5] 진짜 선결 = option_items 행 적재(PO-1a)·PROC_000002 링크(PO-1b)** — 신규 컬럼 ALTER가 아님.
- 사이즈 SZ-1은 독립(색 cp 0참조·무비용)·도수는 변경 0.

### 3.4 총계

| 유형 | 건수 |
|------|:--:|
| **축이동(자재→타축)** | **89행** (②siz 29·옵션색 36·print_side 14·bundle 5·전건 확정) |
| **★BOM link 제거(GPM-4)** | **177 link** (오염 .09/.10 USAGE.07·본체 선적재 후·진짜 미완) |
| **★오염 자재행 소프트삭제** | (축이동분) del_yn='Y'(+del_dt) 마지막 |
| **교정 mat_typ .10→.07(②부자재)** | **~17행** (자재 유지·확정) |
| **정리(③봉투 5 + placeholder/헤더 6)** | **11행** (del_yn='Y'·확정·멱등 skip) |
| **교정 두께 분리(AC-2 확정)** | 아크릴 22상품 (dbmap 31_acrylic 위임) |
| **자재 유지(.08 본체색 B-MAT-3 확정)** | 5행 (변경 없음·결함 아님) |
| **카테고리 소프트삭제 del_yn='Y'** | **11노드** (CAT_000294 신규 1 + round-22 del_yn 미완 보정 10·즉시) |
| **카테고리 재연결(C-CAT-1 해소)** | **2노드** (CAT_000302/304·활성 상품·upr_cat_cd UPDATE·소프트삭제 금지) |
| **신규 코드행 등록** | **0** (search-before-mint·.05 흡수·라이브 14코드 실재) |
| **신규 그릇(DDL·vessel-gap) — 자재·카테고리** | 2 (형상 V-12 shape_cd·비치수 size 마스터 — 둘 다 dbmap 기제안 재사용) |
| **★4축: 사이즈 교정(SZ-1 색오염)** | **2행** (siz_nm 정규화·무비용·가격 cp 0참조·즉시·삭제 아님) |
| **★4축: 도수** | **0행** (폐쇄 SEED·정상·빈 라우팅·잉크색은 옵션 확정 AX-1이라 도수 수신 0) |
| **★4축: 인쇄옵션 UV 축이동(PO-1)** | **63행** (PO-1a 14 실연결 ~42 + PO-1b 7 무연결 ~21·print_side→**기존 dtl_opt**·**underbase=UV param 확정**·선결=option_items 행/PROC 링크·돈 크리티컬 formula 간접) |
| **★4축: 공정 param 슬롯(dtl_opt 재사용)** [B4 정정] | **신규 컬럼 0** (ref_param_json 신설 철회·기존 dtl_opt 라이브 실재 재사용·vessel-gap→data-gap 격하) |
| **★4축: 레이플랫 PROC_000025 소프트삭제(PR-2)** [AX-6 확정] | **1행** (del_yn='Y'+del_dt·라이브 연결 0 실측·use_yn 아님·멱등 가드 WHERE del_yn='N') |
| **★4축: 신규 공정/도수 코드행·컬럼·테이블** | **0** (dtl_opt 재사용·열재단 PROC_000084·미싱·봉제·에폭시 라이브 실재·재제안 금지) |
| **★4축: 판정불가(잔여 컨펌)** | **30** (SZ-2 형상+EA 30·PO-1b 정체 7무연결 별도) — PR-2 레이플랫은 AX-6 해소로 판정불가→소프트삭제 확정 |

> **★최종 라우팅 보정(2026-06-18·컨펌 확정):** 축이동 90→**89**(.10 잉크색 8→7·옵션 확정 합류). 교정 ~26→**.10→.07 ~17**(3용도 분해). 카테고리 = 소프트삭제 **11**(빈 고아 10+CAT_000294) + **재연결 2**(302/304 활성화·C-CAT-1 해소·del_yn 금지). 삭제 권위 = del_yn='Y'(조회 차단)·재연결 = upr_cat_cd UPDATE. 라이브 del_yn='Y'는 임시책(TRUNCATE 재적재 휘발)·근본 = 경로 Y.

---

## 4. ★ 컨펌 큐 — 자재·카테고리 0건 + 4축 확정 2 / 잔여 3

> **1순위(자재·카테고리) = 전건 해소(잔여 0)** · **4축 = 확정 2건(B-PO-1·AX-6·2026-06-18 사용자) / 잔여 3건(AX-5 범위·PO-1b 정체·SZ-2 칼틀·후속 실측).**

### 4.1 자재·카테고리 컨펌 확정 (5건·전건 해소·재제안 금지)

| ID | 확정 결과(2026-06-18 사용자) | 반영 |
|----|------------------------------|------|
| **B-MAT-3** | .08 실사 색 5행 = **소재별 본체색 고정(2~3종)·자재행 본체색 합성 유지**(옵션 축이동 아님) | regspec-material §2(자재 유지·삭제 0) |
| **AX-1** | .10 잉크색 7행 = **주문 옵션(CPQ option)** — 도수/별색 아님 | regspec-material §4.4(④→옵션 확정) |
| **부속 typ → .10 3용도 분해** | ★단순 .10→.07 통합 금지 — ②부자재 ~17(.10→.07 자재유지)·③봉투 5(addon=상품 운영·자재행 정리)·placeholder 6(skip)·볼체인색8+잉크색7(옵션) | regspec-material §4(3용도 분해) |
| **AC-2** | 두께=자재 식별자 정답 확정 → **dbmap 31_acrylic 트랙 위임**(라이브 재실측·가격사슬 동시) | regspec-material §5(컨펌 큐 제거·dbmap 위임) |
| **C-CAT-1 / 부모매칭** | CAT_000302/304 상품 PRD_000218/229 **활성화** → 소프트삭제 절대 금지·**부모 재연결 확정**: CAT_000302→**CAT_000134**(데스크소품·문구 계열)·CAT_000304→**CAT_000198**(응원/시즌·라이프 계열). 라이브 SELECT 근접 매칭(동명 부재) | regspec-category §2.1/§2.2(upr_cat_cd UPDATE 확정·§6 해소) |

> **★부모 매칭 정직 표기:** 사용자 명명("굿즈·기타 제작물"·"응원·이벤트 굿즈")과 정확 동일 cat_nm은 라이브 부재 → 의미상 가장 근접한 정상 lvl2 노드(CAT_000134·CAT_000198)로 매칭(확정도: 근접). 라이브 lvl1 12개에 "굿즈" 전용 대분류 없음(굿즈류=lvl1 라이프 산하). 실 적재 시 운영자 1회 시각 확인 권장.
>
> **escalate 처리:** **자재·카테고리 잔여 0** — 리더 escalate 불요. **CAT_000302/304 소프트삭제는 절대 금지**(활성 상품 유일 main·전손)·재연결만(upr_cat_cd UPDATE).

### 4.2-a ★ 4축 컨펌 확정 (2건·2026-06-18 사용자·재제안 금지)

| ID | 축 | 확정 결과 | 반영 |
|----|----|-----------|------|
| **B-PO-1** ✅해소 | 인쇄옵션 | 화이트/클리어 언더베이스 = **UV 인쇄 옵션(PROC_000002 공정 param·dtl_opt)** 확정·**별색공정 PROC_000008 아님**·UV 14 실연결 한정. PO-1a 14상품 dtl_opt param 이관(`{"언더베이스":"화이트"}` 등) | regspec-printoption §1.1·§6.1 |
| **AX-6** ✅해소 | 공정 | 레이플랫 PROC_000025 = **미운영(소프트삭제)** 확정. **★라이브 read-only SELECT 실측 = 연결 상품 0건**([HARD] 연결 있으면 보존 조건 충족 안 함) → `del_yn='Y'`(+del_dt)·use_yn 아님·멱등 가드 `WHERE del_yn='N'`. round-22 카테고리 소프트삭제 동형 | regspec-process §3 PR-2·§6.1 |

### 4.2-b ★ 4축 잔여 컨펌 (3건·후속 실측·escalate)

| ID | 축 | 막힌 결정 | 평이한 한국어 질문 | 명세 위치 |
|----|----|-----------|--------------------|-----------|
| **AX-5** [B4·범위 결정] | 공정/인쇄옵션 | 공정 파라미터(줄수·조각수·UV 변형/언더베이스) 선택값을 **기존 dtl_opt 칸에 채우는 범위**(신규 칸 아님) | "오시 2줄, 반칼 4조각, 아크릴 풀빼다 같은 '공정 세부 선택값'을 담는 칸은 이미 있습니다(봉제 옵션에서 쓰는 중). 대부분 비어 있을 뿐이에요. 어느 상품·옵션부터 채울지만 정하면 됩니다(새 칸 만들 필요 없음)." | `regspec-process.md §1·§6.2` |
| **PO-1b 정체** | 인쇄옵션 | UV 변형값은 있으나 공정 연결 0인 7상품(코롯토164·카라비너166 등)의 정체·공정 연결 여부 | "코롯토·카라비너 같은 7개 상품은 화면엔 'UV 변형'이 적혀 있는데 실제 UV 공정 연결이 없습니다. 정말 UV 가공인가요, 비활성/정체인가요? 공정 연결을 먼저 정해야 변형값(언더베이스 포함)을 옮길 수 있습니다." | `regspec-printoption.md §1·§6.2` |
| **SZ-2** | 사이즈 | 형상 siz(정사각/원형/하트 30행)가 칼틀 물리존재(정당 siz)인지 규격형(공정 param)인지 + EA 의미(판걸이수 vs 조각수) | "정사각·원형·하트 같은 모양 사이즈가 30개 있는데, 실제로 그 모양의 '칼틀'(금형)이 따로 있어서 사이즈로 둔 건가요, 아니면 모양 이름만 적어둔 건가요? 또 '8EA' 같은 숫자가 한 판에 몇 개 들어가는 수인가요, 조각 개수인가요? 칼틀이 있으면 그대로 두고, 아니면 모양은 형상칸으로 옮깁니다." | `regspec-size.md §3·§6` |

> **★4축 escalate 처리:** **확정 2(B-PO-1 underbase=UV param·AX-6 레이플랫 소프트삭제·연결 0 실측)**. 잔여 3: AX-5 = 신규 칸 신설 아님·이관 범위 결정만(dtl_opt 기존 실재·DDL 불요). PO-1b 정체 = 7 무연결분 공정 연결 선결(underbase 판정보다 먼저). SZ-2 = 칼틀 실측 전 등록·삭제 0(판정불가·보류). **★신규 그릇 = 0**(ref_param_json 철회·전부 교정/축이동/data-gap/소프트삭제/판정불가·신규 그릇 모호 0).

---

## 5. search-before-mint 입증 요약 [HARD]

| 항목 | 사다리 | 판정 |
|------|--------|------|
| MAT_TYPE 코드행 | 1단(코드행) | **신규 0** — 라이브 14코드(`.01~.14`) 이미 실재(C-MAT-1 해소) |
| 자재 색/구수/인쇄면 오염 | (축이동) | **신규 그릇 0** — 기존 print_side/bundle/option_items 그릇으로 수신 |
| 형상(shape) | 코드행+junction 재사용 | shape-axis DDL(SHAPE 코드6 + 기존 `t_prd_product_sizes.shape_cd` 컬럼·**테이블 0**·V-12 vessel-gap 정당) |
| 비치수 size | 신규 마스터(사다리 4) | goods-pouch-nondim-size DDL — t_siz_sizes work/cut NULL 라벨 0건 입증·4 기존 구조 무손실 실패 → **신규 테이블 정당(data-gap)** |
| MAT_FACET 분해축 | 1단(코드행·보류) | upr_mat_cd 계층 우선 시도 → 부족 시만(V-3 §6)·1순위 scope 밖 |
| 신소재 MAT_TYPE | (보류) | .05 특수소재 흡수 우선·mint 0(YAGNI) |
| 카테고리 신규 노드 | — | **신규 0** — 정상 leaf 전부 실재(신설 0·재연결 2는 기존 노드 upr 보정) |
| **★공정 param 선택값(dtl_opt)** [B4 정정] | **0단(기존 컬럼 재사용)** | **신규 컬럼 0·data-gap** — `t_prd_product_option_items.dtl_opt` jsonb **라이브 실재**(6행 공정 param 실사용·`{"유형":"봉미싱(7cm)"}`). UV 변형 `{"변형":"풀빼다"}` 동형 → 재사용. **★rpmeta V-1이 dtl_opt를 누락 → ref_param_json 신설 제안은 오판·철회**(vessel-gap→data-gap 격하). dtl_opt(값) vs prcs_dtl_opt(스키마) 역할 구분 |
| **★4축: 도수/인쇄옵션/사이즈 코드행** | 1단(코드행) | **신규 0** — 도수 SEED 폐쇄·print_side 5종 도메인 기존·siz SZ-1은 기존 행 정규화(채번 0)·신규 공정(열재단/미싱/봉제/에폭시) 라이브 실재 |

> **★신규 그릇 정당 = vessel-gap 2건**(자재·카테고리: 형상 V-12·비치수 size 마스터·둘 다 dbmap 기제안 재사용). **[B4] 4축 ref_param_json 컬럼 신설 = 철회**(dtl_opt 기존 재사용·data-gap). MAT_TYPE·MAT_FACET·신소재·카테고리·도수·공정·print_side 코드행·**공정 param 컬럼** 신규 = **0**. 오염은 축이동/교정/data-gap이지 신규 그릇 아님(directive 정합·search-before-mint 0단 dtl_opt 재사용 검증 추가).

---

## 6. 위임 / 인간 승인 큐

| 트랙 | 위임처 | 내용 |
|------|--------|------|
| 실 적재(축이동·교정) | `dbm-axis-staged-load`(경로 Y 교정엑셀 우선) / `dbm-load-execution`(멱등 UPSERT·`WHERE del_yn='N'` 가드) | 자재 89행 축이동·BOM link 177 제거(GPM-4)·소프트삭제 del_yn='Y'·.10→.07 ~17 교정·봉투/헤더 정리 11·카테고리 소프트삭제 11·재연결 2 · **4축: SZ-1 색오염 2행 정규화·PO-1 UV 63행 축이동(PO-1a 14: option_items 행 선적재 후·underbase=UV param / PO-1b 7: PROC_000002 링크 선행·기존 dtl_opt로 이관)·레이플랫 PROC_000025 소프트삭제 1(del_yn='Y'·AX-6 확정)** |
| DDL | `dbm-ddl-proposer`(기제안 재사용) | shape-axis(shape_cd)·goods-pouch-nondim-size(비치수 마스터)·MAT_FACET 컬럼(채택 시). **★[B4] ref_param_json ALTER = 철회**(기존 dtl_opt 재사용·4축 DDL 0) |
| **4축 data-gap** | dbmap 적재/CPQ constraints 트랙 | nonspec 25/275 채움(SZ-3)·캐스케이드 제약(GAP-PROC-2·constraints.logic 기존 그릇)·자재 수신(siz 29·print_side 14는 material §3 처리) |
| 아크릴 두께(AC-2 확정) | `dbmap 31_acrylic-price-link` | 두께=자재 식별자 확정·라이브 재실측·가격사슬 동시 |
| 컨펌 결정(자재·카테고리) | — | **잔여 0** — 컨펌 5건 전건 해소(B-MAT-3·AX-1·부속typ·AC-2·C-CAT 부모매칭). 부모 = CAT_000134·CAT_000198 확정 |
| **컨펌 결정(4축)** | 리더 escalate / 실무진 | **확정 2**(B-PO-1 underbase=UV param·AX-6 레이플랫 소프트삭제·연결 0 실측) · **잔여 escalate 3** — AX-5(dtl_opt 이관 범위·DDL 불요)·PO-1b 정체(7 무연결 공정 연결)·SZ-2(형상 칼틀·EA). 평이한 한국어 질문 §4.2-b |
| 근본 교정(경로 Y) | 개발자 v03 재적재 | del_yn='Y'는 TRUNCATE 재적재 시 휘발 → v03 오염행/고아 제거·재적재(`_backlog/developer-code-changes.md`·P-TRUNCATE 가드) |
| 적재경로 미상 | admin 명세 확인 | shape_cd/비치수 마스터 컬럼 = DDL 적용 후 catalog 모델 노출(현재 admin 미구현) |

**재진단 금지(적용완료 인용):** round-22 ⑥ 카테고리 고아 페어 COMMIT(DELETE 111·use_yn 토글 UPDATE 12·단 del_yn 미수행분은 §1.2 신규)·레더 .06 교정·GPM-1/2 본체자재 41행 설계 GO · **4축: round-23 siz_width/height 구간차원 COMMIT·스티커 SIZ_000518/519·반칼 520 채번·열재단 PROC_000084·미싱/봉제/에폭시(085~102) 라이브 실재·캘린더 제본(098~102) — 전부 재제안 금지.**

---

## 7. hbg-validator 통지

- **등록 명세 마스터 최종 확정(2026-06-18 컨펌 5건 전건 해소 + del_yn 보정 반영)** — 자재(89 축이동·BOM link 177 제거·.10→.07 ~17·봉투/헤더 정리 11·소프트삭제)·카테고리(11 소프트삭제·2 재연결[부모 CAT_000134·CAT_000198 확정])·4축 틀. **컨펌 잔여 0.**
- **검증 포인트:** ① FK 위상 순서(본체 선적재→목적지→**BOM link 제거(GPM-4)→오염행 del_yn='Y' 마지막**) ② **삭제 권위 = del_yn='Y'(+del_dt)·use_yn 아님**(조회 차단 권위)·**재연결 = upr_cat_cd UPDATE**(302→CAT_000134·304→CAT_000198·소프트삭제 금지) ③ search-before-mint 입증(신규 코드행 0·신규 그릇 2 vessel-gap만) ④ component_prices 0참조(가격사슬 안전)·**단 BOM link 런타임 참조는 GPM-4 제거가 진짜 미완** ⑤ 멱등 가드 `WHERE del_yn='N'`+del_yn·use_yn 둘 다 추적 ⑥ **컨펌 5건 전건 확정 반영·잔여 0** ⑦ round-22 ⑥ COMMIT분(DELETE/use_yn 토글) 재제안 0·**del_yn 미수행분만 신규(중복 아님)** ⑧ 부모 매칭 정직(라이브 동명 부재→근접 매칭·날조 0).
- **escalate:** **잔여 0** — 컨펌 전건 해소. search-before-mint로 신규 그릇 정당성 모호 항목 0(전부 기제안 재사용/보류).
- **★최종 확정 요지(자재·카테고리):** ① 컨펌 5건→0(B-MAT-3 본체색 유지·AX-1 잉크색 옵션·.10 3용도 분해·AC-2 dbmap 위임·C-CAT 부모 CAT_000134/CAT_000198 확정) ② 축이동 90→89·교정 ~26→.10→.07 ~17 ③ 카테고리 소프트삭제 11+재연결 2(부모 확정·302/304 활성 상품 del_yn 금지) ④ del_yn='Y' 권위(B5 해소)·라이브 임시책·근본 경로 Y.

### 7-bis. ★ 4축 검증 포인트 (2차 회차·hbg-validator 통지)

- **4축 등록 명세 확정(2026-06-18·B4·B2·B5 정정)** — 사이즈(SZ-1 색오염 2 교정·무비용)·도수(0건 정상)·인쇄옵션(PO-1 UV 63 축이동·PO-1a 14/PO-1b 7 분기)·공정(기존 dtl_opt 재사용·신규 컬럼 철회). **★신규 코드행·도수·print_side·공정 코드행·컬럼·테이블 = 0. 4축 신규 mint = 0**(ref_param_json 신설 철회·dtl_opt 라이브 실재 재사용).
- **검증 포인트 [B4·B2·B5]:** ① **★[B4] 신규 컬럼 0** — 기존 `t_prd_product_option_items.dtl_opt` 재사용(라이브 6행 실사용·V-1 dtl_opt 누락 오판 철회·vessel-gap→data-gap) ② **★[B5] FK 위상: 진짜 선결 = option_items 행 적재(PO-1a)·PROC_000002 링크(PO-1b)** — 신규 컬럼 ALTER 아님·순서 위반 시 고아 param ③ **[B2] UV 14 실연결/7 무연결 분기**("전건 UV" 과장 정정) ④ **돈 크리티컬 간접경로**(component_prices에 prd_cd 부재·formula PRF_CLR_ACRYL 경유·단가행 byte 불변·골든 재현·colrcnt 무접촉) ⑤ search-before-mint **0단(dtl_opt 재사용 검증) 명시**(V-1 누락 정정)·신규 공정 mint 0(라이브 실재) ⑥ **기계적 size 삭제 절대 금지**(component_prices 116siz 2,601행 CASCADE·round-22 ② CORRECT 반증) ⑦ SZ-1 색오염 cp 0참조(무비용·siz_nm 정규화 UPDATE) ⑧ 도수 5행 byte 일치(잉크색은 옵션 AX-1) ⑨ data-gap(nonspec·캐스케이드·param 채움)는 dbmap 위임·본 회차 등록 0 ⑩ round-23/round-22 COMMIT분 재제안 0.
- **4축 컨펌 확정 2건:** **B-PO-1 해소**(underbase=UV 인쇄 옵션·PROC_000002 param·dtl_opt·별색공정 아님·14 한정) · **AX-6 해소**(레이플랫 PROC_000025 소프트삭제·라이브 연결 0 실측·del_yn='Y'·use_yn 아님·멱등 가드). **잔여 escalate 3건:** AX-5(dtl_opt 이관 범위·DDL 불요·신규 그릇 아님)·PO-1b 정체(7 무연결 공정 연결 선결)·SZ-2(형상 칼틀·EA·후속 실측). 평이한 한국어 질문 §4.2-b. **★신규 그릇 정당성 모호 = 0**(ref_param_json 철회·전부 교정/축이동/data-gap/소프트삭제/판정불가).
