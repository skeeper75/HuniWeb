# 등록 명세 — ⑥ 카테고리 (`t_cat_categories`)

> **하네스** hbg Phase 3 설계가. **작성** 2026-06-18. 1순위 축.
> **입력:** `02_diagnosis/diagnosis-category.md`(잔여 고아 3노드) · `01_authority/axis-authority-category.md`(정답 사전) · `_routing-summary.md`.
> **재사용:** code-identifier-strategy(CAT_ 채번) · huni-admin-manual `01_source_admin-screen-map.md`(적재경로).
> **[HARD] round-22 ⑥ COMMIT분(DELETE 111·UPDATE 12·고아 11노드) 재제안 금지.** 라이브 재실측 잔여만 명세.

---

## 0. 채번·적재경로 규약

| 규약 | 내용 |
|------|------|
| **채번** | `CAT_NNNNNN` 순차. 멱등 = `(cat_nm, upr_cat_cd)` 경로 유일(같은 경로 노드 재발급 금지). |
| **적재경로** | catalog Django **`tcatcategories__add/change`**(/admin/catalog/tcatcategories/) — cat_nm·upr_cat_cd(트리 드롭다운 exclude_leaf_level)·cat_lvl·disp_seq·use_yn(드롭다운). 상품↔카테고리 연결은 product-viewer `pvEdit(prd_cd, categories)` 섹션(main_cat_yn). |
| **★소프트삭제 권위 [HARD·정정]** | hard-delete 금지 — **`del_yn='Y'`(+`del_dt`=now()) 소프트삭제만**(항상 마지막). 카테고리도 del_yn 보유(`sql/24_add_del_yn.sql` 확장)·조회 차단 = `views.py:662` `TCatCategories.filter(del_yn='N')`. **use_yn = 부차 토글(조회 미차단)** — use_yn='N'만으론 고객/admin 조회에서 안 사라짐. 진단 §del_yn 카테고리 동형 보정 인용. |
| **★멱등 가드 [HARD·정정]** | **`WHERE del_yn='N'`**(이미 'Y'면 skip) + del_yn·use_yn 둘 다 추적(단독 금지). |

> **카테고리는 커머스 축** — 생산/가격 바인딩 없음(정답 사전 §4). FK = `upr_cat_cd` self-ref(ON DELETE RESTRICT) · `t_prd_product_categories.cat_cd`. 정상 leaf 273 main='Y' 무손상.
>
> **★round-22 ⑥ 미완분 [HARD·정정]:** round-22 ⑥ COMMIT은 빈 노드를 **use_yn='N'으로만 토글**(del_yn 미수행). 조회 차단 권위 = del_yn이라, **고아 14노드 중 진짜 소프트삭제(del_yn='Y') = CAT_000297 1노드뿐.** 나머지 13 중 **빈 고아 10**(293/295/296/298~301/303/305/306) + **CAT_000294 명함** = **소프트삭제 11노드**(del_yn='Y' 필요), **CAT_000302/304 2노드 = 활성 상품 재연결**(del_yn='Y' 금지·§2). → round-22 ⑥은 use_yn 토글까지·del_yn 미완. 본 명세가 권위 정정(중복 아님·round-22 COMMIT 자체는 재제안 금지·del_yn 미수행분만 신규).

---

## 1. 신규 교정 — 빈 고아 노드 소프트삭제 del_yn='Y' (즉시·확정)

> 진단 §del_yn 카테고리 동형 보정: 조회 차단 권위 = **del_yn**. round-22 ⑥은 빈 노드 use_yn='N'까지만(del_yn 미수행) → 소프트삭제 대상 = **11노드**(빈 고아 10 + CAT_000294·297 제외·302/304는 활성 재연결로 제외)가 del_yn='N' = 조회 노출 잔존.

### 1.1 CAT_000294 명함 — 소프트삭제 (즉시·확정)

| 항목 | 내용 |
|------|------|
| **대상** | CAT_000294 (명함) — 빈 중복 고아 노드 |
| **올바른 의미** | 빈 중복 고아(상품 0·정상 명함 leaf 10개 lvl2 root CAT_000003 하위 전부 실재). round-22 빈 노드 처리 잔여 미처리분(use_yn='N'조차 안 됐거나·del_yn='N' 노출 중). |
| **목적지/조치** | `t_cat_categories` **del_yn='Y'(+del_dt=now()) 소프트삭제** — 신설/재연결 아님. use_yn='N'은 조회 미차단이라 불충분. |
| **search-before-mint** | 신규 노드 0(정상 leaf 전부 실재). 재연결 0(상품 0이라 재연결 대상 없음). 사다리 무관(삭제 명세). |
| **권위 근거** | 정답 사전 §3(상품 0 빈 노드→소프트삭제) · 진단 §2.1·§del_yn 동형 보정 · C-CAT-1 부분 해소 |
| **채번** | 없음(기존 CAT_000294 del_yn UPDATE). |
| **적재경로** | `tcatcategories change`(admin 삭제 버튼 = del_yn='Y'+del_dt logical_delete). |
| **FK 위상** | 상품 연결 0 → FK 영향 없음. 즉시 안전. self-ref 자식 0 확인(leaf). |
| **영향분석** | 상품 0 → 가격/BOM 영향 0. 정상 leaf 10개 무손상. 롤백=del_yn='N'(+del_dt=NULL). **★회귀 위험:** v03 재적재 시 소멸(load_master:282-291 재INSERT) → 근본은 경로 Y(개발자 v03 교정). |

### 1.2 round-22 ⑥ del_yn 미완 빈 고아 10노드 — 소프트삭제 보정

| 항목 | 내용 |
|------|------|
| **대상** | round-22 ⑥이 use_yn='N'으로만 토글하고 del_yn='N' 잔존한 빈 고아 노드 **10개**(CAT_000293/295/296/298/299/300/301/303/305/306·CAT_000297은 del_yn='Y' 완료 제외·**CAT_000302/304는 활성 상품 재연결이라 제외**) |
| **올바른 의미** | 조회 차단 권위 = del_yn → use_yn='N'만으론 고객/admin 조회에서 안 사라짐 = round-22 ⑥ 미완분(상품 0 빈 고아). |
| **목적지/조치** | `t_cat_categories` **del_yn='Y'(+del_dt) 소프트삭제** — round-22 use_yn 토글에 del_yn 보강(round-22 COMMIT 자체 재제안 아님·미수행분 신규). |
| **search-before-mint** | 신규/재연결 0(이미 빈 노드·고아 페어 DELETE 111 완료). del_yn 토글만. |
| **권위 근거** | 진단 §del_yn 카테고리 동형 보정(진짜 소프트삭제=CAT_000297 1노드뿐) · category §B 재판정 · routing-summary §6(빈 고아 10 + CAT_000294=11) |
| **채번** | 없음(del_yn UPDATE). |
| **적재경로** | `tcatcategories change`(logical_delete). |
| **FK 위상** | 상품 0(고아 페어 삭제됨) → FK 영향 없음. 즉시. |
| **영향분석** | 상품 0 → 영향 0. 롤백=del_yn='N'. **★회귀:** v03 재적재 시 소멸 → 경로 Y 근본. |

> **즉시 가능분(컨펌 무관).** 라우팅 = 카테고리 소프트삭제(del_yn='Y'·CAT_000294 신규 1 + round-22 미완 보정 10 = **11노드**). 302/304는 §2 재연결(소프트삭제 제외).

---

## 2. 재연결 — CAT_000302 · CAT_000304 (★C-CAT-1 해소·활성화 2026-06-18)

> 진단 §2.2 갱신: PRD_000218(타이벡북커버)·PRD_000229(이미지피켓) **use_yn='N'→'Y' 활성화**(사용자 활성화·라이브 재실측). 이전 "BLOCKED 비활성 보존" → **"활성 상품의 유효 카테고리"로 갱신.** C-CAT-1 BLOCKED 해소.

| 항목 | 내용 |
|------|------|
| **대상** | CAT_000302(데스크/사무용품)·CAT_000304(말랑 PVC고주파) — use_yn='Y'·del_yn='N'·upr_cat_cd NULL·lvl3(고아 구조) |
| **올바른 의미** | **활성 상품(PRD_000218/229)의 유효 main 카테고리** — 단 트리 미연결(upr_cat_cd NULL·고객 네비 트리에 안 붙음). |
| **목적지/조치 [★C-CAT-1 확정]** | **노드 유지 + 정상 lvl2 부모로 재연결(`upr_cat_cd` UPDATE)** — 데스크/사무용품·말랑(PVC고주파)을 적절한 상위 분류 아래로. **소프트삭제 절대 금지**(del_yn='Y'=활성 상품 카테고리 전손). |
| **search-before-mint** | 신규 노드 0(노드 실재·재연결만). 신설 0. |
| **권위 근거** | 진단 §2.2 갱신(활성화·재연결) · §B 재판정 · **C-CAT-1 해소** |
| **채번** | 없음(기존 CAT_000302/304 `upr_cat_cd` UPDATE). |
| **적재경로** | `tcatcategories change`(upr_cat_cd 트리 드롭다운 — NULL → 정상 lvl2 부모). |
| **FK 위상** | 정상 lvl2 부모 노드 선존재 확인 → upr_cat_cd UPDATE(self-ref·ON DELETE RESTRICT). 상품 연결(main='Y') 무손상. |
| **영향분석** | **del_yn='N' 유지(소프트삭제 금지)** — 활성 상품 유일 main이라 삭제 시 전손. 재연결은 트리 부모만 보정(상품 연결 불변). 롤백=upr_cat_cd→NULL. |

> **★C-CAT-1 해소(2026-06-18):** 활성화로 "BLOCKED 보존" 전제 소멸 → **재연결 트랙**(삭제 아님). 단 "어느 정상 lvl2 부모로 재연결?"(의미매칭)은 잔여 컨펌 — **컨펌 큐 유지(잔여 1건)**. 평이한 질문 §6.

---

## 3. 교정완료 (인용·재진단 금지)

| 대상 | round-22 처리 | 상태 |
|------|---------------|------|
| 고아 페어 DELETE 111 + 빈 노드 use_yn='N'(UPDATE 12) | round-22 ⑥ COMMIT | ✅ 적용완료 — **재제안 금지**(DELETE/use_yn 토글 자체) |
| ★ 단 del_yn 권위 = round-22 ⑥ **del_yn 미수행** | 빈 노드 13 중 CAT_000297만 del_yn='Y'·나머지 ~12 del_yn='N' 잔존 | **미완 — §1.2 del_yn 보정 신규**(중복 아님) |
| 정상 leaf 273 main='Y' · lvl1 12 root | 무손상 | 유지 |

---

## 4. 카테고리 등록 명세 집계

| 라우팅 | 대상 | 노드수 | 신규 mint | 즉시/컨펌 | 적재경로 |
|--------|------|:--:|:--:|------|----------|
| 카테고리 소프트삭제(신규) | CAT_000294 명함 | 1 | 0 | **즉시** | tcatcategories change(**del_yn='Y'**+del_dt) |
| 카테고리 소프트삭제(round-22 del_yn 미완 보정) | 빈 고아 10(297·302·304 제외) | 10 | 0 | **즉시** | tcatcategories change(**del_yn='Y'**+del_dt) |
| **재연결(C-CAT-1 해소)** | CAT_000302·304(★활성 상품 PRD_000218/229) | 2 | 0 | **소프트삭제 금지** · 부모 의미매칭 컨펌 | tcatcategories change(**upr_cat_cd** UPDATE) |
| 신설 | — | 0 | 0 | — | — |
| 교정완료(인용·재제안 금지) | 고아 페어 DELETE 111·use_yn 토글 12 | — | — | round-22 COMMIT | — |

**카테고리 소프트삭제(del_yn='Y') 명세 = 11노드**(CAT_000294 신규 1 + round-22 ⑥ del_yn 미완 보정 10). **재연결 = 2**(CAT_000302/304·활성화로 C-CAT-1 해소·del_yn='Y' 금지·upr_cat_cd 보정). 신설 = 0(정상 leaf 전부 실재). **★권위:** 삭제 = del_yn='Y'(조회 차단)·재연결 = upr_cat_cd UPDATE(트리 부모). round-22 ⑥ DELETE/use_yn 토글은 재제안 금지·del_yn 미수행분은 신규(중복 아님).

---

## 5. dbmap 위임 / 회귀 주의

- **실 적재 위임:** 빈 고아 소프트삭제 **del_yn='Y'(+del_dt)** = 경로 X(라이브 직접·즉시·가역) 또는 경로 Y(v03 교정·근본). round-22 ⑥은 경로 X COMMIT 선례(단 use_yn 토글까지·del_yn 미완).
- **★회귀 위험(경로 Y·정정):** load_master:170(upr NULL INSERT)·282-291(v03 11시트 `구분` 라벨→고아). del_yn='Y' 소프트삭제도 **TRUNCATE CASCADE 재적재 시 'N'으로 휘발**(자재축 동형·load_master INSERT가 del_yn 미명시→DEFAULT 'N') → 라이브 del_yn='Y'는 임시책·근본 = `_backlog/developer-code-changes.md`(개발자 v03 오염행 제거·재적재). round-22 03 P-TRUNCATE 가드 인용.
- **재진단 금지(인용):** round-22 ⑥ 고아 페어 DELETE 111·use_yn 토글 12 COMMIT(단 del_yn 미수행분은 §1.2 신규).

---

## 6. ★ 잔여 컨펌 큐 (카테고리 부모 재연결 매칭 — 1건)

> C-CAT-1 BLOCKED는 활성화로 해소됐으나, **재연결 목적지 부모(의미매칭)** 만 잔여 컨펌. 평이한 한국어 질문 첨부.

| ID | 대상 | 막힌 지점 | 컨펌 질문(평이한 한국어) | 결정 시 조치 |
|----|------|-----------|--------------------------|----------------|
| **C-CAT-부모매칭** | CAT_000302(데스크/사무용품)·CAT_000304(말랑 PVC고주파) | 두 카테고리를 어느 정상 상위 분류(lvl2) 아래로 붙일지 미확정 | "데스크/사무용품(타이벡북커버 상품)과 말랑·PVC고주파(이미지피켓 상품) 두 분류가 지금 메뉴 트리 어디에도 안 붙어 있습니다. **각각을 어느 큰 분류 메뉴 아래에 넣을까요**? (예: 데스크/사무용품 → '문구·오피스' 아래, 말랑PVC → '굿즈' 아래. 적절한 상위 메뉴만 정해 주시면 거기에 연결합니다)" | 부모 lvl2 노드 확정 → upr_cat_cd UPDATE(재연결) |

> **escalate 처리:** 본 컨펌 큐를 리더에 통지 → 사용자 결정. 결정 전 재연결 부모 단정 금지(의미매칭). **소프트삭제는 절대 금지**(활성 상품 유일 main·전손).
