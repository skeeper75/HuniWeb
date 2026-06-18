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
> **★잔여 컨펌 = 1건**(카테고리 302/304 재연결 부모 의미매칭). 5건→1건으로 축소(B-MAT-3·AX-1·부속typ·AC-2 해소).

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

### 3.3 나머지 4축 (regspec-scaffold.md·틀)

| 축 | 등록 명세 윤곽 |
|----|---------------|
| ② 사이즈 | 자재 29행 수신 그릇·기계적 삭제 금지·비치수 마스터 DDL |
| ③ 도수 | SEED 폐쇄·신규 0·**잉크색은 옵션 확정(AX-1)이라 도수 수신 0**(도수 부적합) |
| 인쇄옵션 | 자재 14행 수신·UV/별색 위치 교정(OM-5) |
| ⑤ 공정 | 봉제/보드/미싱 신규·코팅 분해 수신·캐스케이드 빈칸 |

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
| **신규 그릇(DDL·vessel-gap)** | 2 (형상 V-12 shape_cd·비치수 size 마스터 — 둘 다 dbmap 기제안 재사용) |

> **★최종 라우팅 보정(2026-06-18·컨펌 확정):** 축이동 90→**89**(.10 잉크색 8→7·옵션 확정 합류). 교정 ~26→**.10→.07 ~17**(3용도 분해). 카테고리 = 소프트삭제 **11**(빈 고아 10+CAT_000294) + **재연결 2**(302/304 활성화·C-CAT-1 해소·del_yn 금지). 삭제 권위 = del_yn='Y'(조회 차단)·재연결 = upr_cat_cd UPDATE. 라이브 del_yn='Y'는 임시책(TRUNCATE 재적재 휘발)·근본 = 경로 Y.

---

## 4. ★ 컨펌 큐 (5건 → 잔여 1건 — 사용자 컨펌 확정 2026-06-18)

> 4건 사용자 컨펌 확정 + 1건 활성화 해소 → **잔여 컨펌 = 1건**(카테고리 부모 재연결 매칭). 평이한 한국어 질문.

### 4.1 잔여 컨펌 (1건·활성)

| ID | 대상 | 막힌 지점 | 컨펌 질문(평이한 한국어) | 결정 시 조치 |
|----|------|-----------|--------------------------|----------------|
| **C-CAT-부모매칭** | CAT_000302(데스크/사무용품)·CAT_000304(말랑 PVC고주파) | 활성 상품 유효 카테고리를 어느 정상 상위 분류(lvl2) 아래로 붙일지 미확정 | "데스크/사무용품(타이벡북커버 상품)과 말랑·PVC고주파(이미지피켓 상품) 두 분류가 지금 메뉴 트리 어디에도 안 붙어 있습니다. **각각을 어느 큰 분류 메뉴 아래에 넣을까요**? (예: 데스크/사무용품 → '문구·오피스' 아래, 말랑PVC → '굿즈' 아래. 적절한 상위 메뉴만 정해 주시면 거기에 연결합니다)" | 부모 lvl2 노드 확정 → upr_cat_cd UPDATE(재연결·소프트삭제 금지) |

### 4.2 컨펌 확정 (4건·해소·재제안 금지)

| ID | 확정 결과(2026-06-18 사용자) | 반영 |
|----|------------------------------|------|
| **B-MAT-3** | .08 실사 색 5행 = **소재별 본체색 고정(2~3종)·자재행 본체색 합성 유지**(옵션 축이동 아님) | regspec-material §2(자재 유지·삭제 0) |
| **AX-1** | .10 잉크색 7행 = **주문 옵션(CPQ option)** — 도수/별색 아님 | regspec-material §4.4(④→옵션 확정) |
| **부속 typ → .10 3용도 분해** | ★단순 .10→.07 통합 금지 — ②부자재 ~17(.10→.07 자재유지)·③봉투 5(addon=상품 운영·자재행 정리)·placeholder 6(skip)·볼체인색8+잉크색7(옵션) | regspec-material §4(3용도 분해) |
| **AC-2** | 두께=자재 식별자 정답 확정 → **dbmap 31_acrylic 트랙 위임**(라이브 재실측·가격사슬 동시) | regspec-material §5(컨펌 큐 제거·dbmap 위임) |
| **C-CAT-1** | CAT_000302/304 상품 PRD_000218/229 **활성화됨** → 소프트삭제 절대 금지·트리 부모 재연결(잔여=부모 매칭 §4.1) | regspec-category §2(재연결·C-CAT-1 해소) |

> **escalate 처리:** 서브에이전트 직접 질문 금지(agent-common-protocol). §4.1 잔여 1건을 리더에 통지 → 사용자 결정. 결정 전 재연결 부모 단정 금지. **CAT_000302/304 소프트삭제는 절대 금지**(활성 상품 유일 main·전손).

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

> **신규 그릇 정당 = vessel-gap 2건만**(형상 V-12·비치수 size). 둘 다 dbmap **기제안 재사용**(재발명 0). MAT_TYPE·MAT_FACET·신소재·카테고리 코드행 신규 = **0**. 자재 오염은 축이동/교정이지 신규 그릇 아님(directive 정합).

---

## 6. 위임 / 인간 승인 큐

| 트랙 | 위임처 | 내용 |
|------|--------|------|
| 실 적재(축이동·교정) | `dbm-axis-staged-load`(경로 Y 교정엑셀 우선) / `dbm-load-execution`(멱등 UPSERT·`WHERE del_yn='N'` 가드) | 자재 89행 축이동·BOM link 177 제거(GPM-4)·소프트삭제 del_yn='Y'·.10→.07 ~17 교정·봉투/헤더 정리 11·카테고리 소프트삭제 11·재연결 2 |
| DDL | `dbm-ddl-proposer`(기제안 재사용) | shape-axis(shape_cd)·goods-pouch-nondim-size(비치수 마스터)·MAT_FACET 컬럼(채택 시) |
| 아크릴 두께(AC-2 확정) | `dbmap 31_acrylic-price-link` | 두께=자재 식별자 확정·라이브 재실측·가격사슬 동시 |
| 컨펌 결정 | 리더 → 사용자 | §4.1 잔여 컨펌 **1건**(C-CAT-부모매칭) — 4건 확정 해소 |
| 근본 교정(경로 Y) | 개발자 v03 재적재 | del_yn='Y'는 TRUNCATE 재적재 시 휘발 → v03 오염행/고아 제거·재적재(`_backlog/developer-code-changes.md`·P-TRUNCATE 가드) |
| 적재경로 미상 | admin 명세 확인 | shape_cd/비치수 마스터 컬럼 = DDL 적용 후 catalog 모델 노출(현재 admin 미구현) |

**재진단 금지(적용완료 인용):** round-22 ⑥ 카테고리 고아 페어 COMMIT(DELETE 111·use_yn 토글 UPDATE 12·단 del_yn 미수행분은 §1.2 신규)·레더 .06 교정·GPM-1/2 본체자재 41행 설계 GO.

---

## 7. hbg-validator 통지

- **등록 명세 마스터 확정(2026-06-18 컨펌 4건 + del_yn 보정 반영)** — 자재(89 축이동·BOM link 177 제거·.10→.07 ~17·봉투/헤더 정리 11·소프트삭제)·카테고리(11 소프트삭제·2 재연결)·4축 틀. **컨펌 잔여 1건**(카테고리 부모 매칭).
- **검증 포인트:** ① FK 위상 순서(본체 선적재→목적지→**BOM link 제거(GPM-4)→오염행 del_yn='Y' 마지막**) ② **삭제 권위 = del_yn='Y'(+del_dt)·use_yn 아님**(조회 차단 권위)·**재연결 = upr_cat_cd UPDATE**(302/304 소프트삭제 금지) ③ search-before-mint 입증(신규 코드행 0·신규 그릇 2 vessel-gap만) ④ component_prices 0참조(가격사슬 안전)·**단 BOM link 런타임 참조는 GPM-4 제거가 진짜 미완** ⑤ 멱등 가드 `WHERE del_yn='N'`+del_yn·use_yn 둘 다 추적 ⑥ **컨펌 확정 4건(B-MAT-3·AX-1·부속typ·AC-2) 반영·잔여 1건(C-CAT 부모매칭) 분리** ⑦ round-22 ⑥ COMMIT분(DELETE/use_yn 토글) 재제안 0·**del_yn 미수행분만 신규(중복 아님)**.
- **escalate:** §4.1 잔여 컨펌 **1건**(C-CAT-부모매칭) — search-before-mint로 신규 그릇 정당성이 모호한 항목은 없음(전부 기제안 재사용 또는 보류).
- **★확정 요지:** ① 컨펌 5건→1건(B-MAT-3 본체색 유지·AX-1 잉크색 옵션·.10 3용도 분해·AC-2 두께 dbmap 위임 해소·C-CAT-1 활성화 재연결로 전환) ② 축이동 90→89·교정 ~26→.10→.07 ~17 ③ 카테고리 소프트삭제 11+재연결 2(302/304 활성 상품 del_yn 금지) ④ del_yn='Y' 권위(B5 해소)·라이브 임시책·근본 경로 Y.
