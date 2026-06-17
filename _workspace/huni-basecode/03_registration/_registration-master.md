# 등록 명세 마스터 — 후니 기초코드 거버넌스 Phase 3 (전 축 통합)

> **하네스** hbg Phase 3 설계가(`hbg-registration-designer`). **작성** 2026-06-18. **최종 산출.**
> **입력:** Phase 2 진단(`02_diagnosis/*`) + Phase 1 정답 사전(`01_authority/*`) + 재사용(rpmeta V-3·dbmap DDL/code-strategy·admin-screen-map).
> **축별 명세:** `regspec-material.md`(자재) · `regspec-category.md`(카테고리) · `regspec-scaffold.md`(나머지 4축 틀).
> **[HARD] 명세 ≠ 적용.** CREATE/ALTER/COMMIT 0. 실 적재 = `dbm-axis-staged-load`/`dbm-load-execution` 인간 승인 후. 적재경로 불명 = "미상" 정직 표기.

---

## 0. 한 줄 평결

**1순위 자재·카테고리 결함은 거의 전부 축이동/교정 — 신규 그릇은 vessel-gap(형상 V-12·비치수 size) 2건뿐, MAT_TYPE/카테고리 신규 코드행 0.** 자재 90행 축이동 + ~26행 mat_typ 교정 + 카테고리 ~13노드 소프트삭제가 핵심. **FK load-bearing(BOM 177 link)이 적재순서를 지배** — 본체 소재 선적재 → 목적지 적재 → **BOM link 제거(GPM-4) → 오염행 del_yn='Y' 마지막**. component_prices 참조 0이라 가격사슬은 안전.
>
> **★삭제 권위 정정(2026-06-18·B5 blind-spot):** 소프트삭제 권위 = **del_yn='Y'(+del_dt)**(조회/BOM/가격 선택지 차단)·use_yn은 부차 토글(조회 미차단). 진짜 미완 = **BOM link 제거**(소프트삭제만으론 기존 BOM/그리드 mat_cd 런타임 참조 잔존). 라이브 del_yn='Y'는 임시책(TRUNCATE 재적재 시 휘발) → 근본 = 경로 Y(v03 오염행 제거·개발자 재적재).

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
      잉크색 → 별색공정/옵션 (AX-1 컨펌 후)
 ③ 오염 .08/.09/.10 BOM link 제거/재배선 (GPM-4·177건 USAGE.07)  ← 진짜 미완
 ④ 오염 .08/.09/.10 자재행 del_yn='Y'(+del_dt)  ← 마지막(소프트삭제 권위)
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
| 축이동 ④→옵션 색(.08 색5+.09 color21+.10 볼체인색8) | 34 | 0(자재 del_yn='Y') | 4종+ 즉시·.08 경계 컨펌 |
| 축이동 ④→print_side(.09 14) | 14 | 0 | **즉시** |
| 축이동 ④→bundle(.09 count4+other1) | 5 | 0 | **즉시** |
| 축이동 ④→③/별색/옵션(.10 잉크색8) | 8 | 분기 | 컨펌 AX-1 |
| **★BOM link 제거(GPM-4)** | 오염 link 177 | — | 본체 선적재·축이동 후 |
| **★오염 자재행 소프트삭제 del_yn='Y'** | (축이동분) | — | **마지막**(use_yn 아님) |
| 교정 mat_typ .10→.07(진짜 부속) | ~26 | 0(UPDATE) | 컨펌 부속typ |
| 교정 두께 분리(아크릴) | (22상품) | 두께별 mat_cd | 컨펌 AC-2 |
| 신규 코드행(MAT_TYPE·MAT_FACET·신소재) | **0** | 0 | 보류(.05 흡수) |

**자재 축이동 = 90행**(즉시 48·컨펌 42) + BOM link 제거 177(GPM-4) + 교정 ~26행+아크릴22 + 신규 0.

### 3.2 카테고리 (regspec-category.md)

| 라우팅 | 노드수 | 즉시/컨펌 |
|--------|:--:|------|
| 카테고리 소프트삭제 del_yn='Y'(신규) CAT_000294 | 1 | **즉시** |
| 카테고리 소프트삭제 del_yn='Y'(round-22 del_yn 미완 보정) | ~12 | **즉시** |
| BLOCKED 보존 CAT_000302/304 | 2 | 컨펌 C-CAT-1 |
| 재연결 / 신설 | 0 | — |

### 3.3 나머지 4축 (regspec-scaffold.md·틀)

| 축 | 등록 명세 윤곽 |
|----|---------------|
| ② 사이즈 | 자재 29행 수신 그릇·기계적 삭제 금지·비치수 마스터 DDL |
| ③ 도수 | SEED 폐쇄·신규 0·잉크색 수신 컨펌(AX-1) |
| 인쇄옵션 | 자재 14행 수신·UV/별색 위치 교정(OM-5) |
| ⑤ 공정 | 봉제/보드/미싱 신규·코팅 분해 수신·캐스케이드 빈칸 |

### 3.4 총계

| 유형 | 건수 |
|------|:--:|
| **축이동(자재→타축)** | **90행** (즉시 48·컨펌 42) |
| **★BOM link 제거(GPM-4)** | **177 link** (오염 .08/.09/.10 USAGE.07·본체 선적재 후·진짜 미완) |
| **★오염 자재행 소프트삭제** | (축이동분) del_yn='Y'(+del_dt) 마지막 |
| **교정(mat_typ/두께)** | ~26행 + 아크릴 22상품 (전부 컨펌) |
| **카테고리 소프트삭제 del_yn='Y'** | ~13노드 (CAT_000294 신규 1 + round-22 del_yn 미완 보정 ~12·즉시) |
| **카테고리 BLOCKED 보존** | 2노드 (컨펌) |
| **신규 코드행 등록** | **0** (search-before-mint·.05 흡수·라이브 14코드 실재) |
| **신규 그릇(DDL·vessel-gap)** | 2 (형상 V-12 shape_cd·비치수 size 마스터 — 둘 다 dbmap 기제안 재사용) |

> **★삭제 라우팅 보정(2026-06-18):** "use_yn='N'" → **"del_yn='Y'(+del_dt)"** 전건 교체(조회 차단 권위). 자재 소프트삭제에 **BOM link 제거(GPM-4)가 선행**(진짜 미완). 카테고리 = round-22 ⑥이 use_yn만 토글·del_yn 미수행 → ~12노드 보정 신규(CAT_000297만 del_yn='Y' 완료). 라이브 del_yn='Y'는 임시책(TRUNCATE 재적재 휘발)·근본 = 경로 Y.

---

## 4. ★ 컨펌 큐 (사용자 일괄 결정 — 평이한 한국어 질문)

> 진단 escalate 5건 + 부속 typ. 명세는 만들었으나 권위 모호로 목적지/실행 미확정. **각 질문을 비전문가도 이해 가능하게 작성.** 사용자가 나중에 한 번에 결정.

| ID | 대상 | 막힌 지점 | 컨펌 질문(평이한 한국어) | 결정 시 목적지 |
|----|------|-----------|--------------------------|----------------|
| **B-MAT-3** | .08 실사 색 5행(화이트/블랙/홀로/골드/실버) | 본체색(자재 유지)인지 선택 팔레트(옵션)인지 미실측 | "실사소재 상품에서 화이트·블랙·홀로그램·골드·실버 색은, **상품마다 한 색으로 정해져 있나요**(예: 이 상품은 항상 화이트), 아니면 **고객이 주문할 때 5색 중에서 고르나요**? 고르는 거면 '옵션'으로, 상품마다 고정이면 '자재'로 둡니다." | 고정 2~3종→자재 유지 / 선택 4종+→option_items |
| **AX-1** | .10 만년스탬프 잉크색 8행(청보라/빨강/검정 등 5cc) | 잉크색이 도수/별색공정/자유옵션 중 어디 귀속인지 미확정 | "만년스탬프 리필잉크 색깔(청보라·빨강·검정 등)은 **인쇄 도수**(흑백/컬러 같은 색 개수)인가요, 아니면 **그냥 고객이 고르는 잉크 색 선택**인가요? 잉크 색은 자재가 아니라서, '색 선택 옵션' 또는 '별색 공정' 중 어디에 둘지 정해야 합니다." | 별색공정(PROC) 또는 자유옵션. 도수 SEED는 부적합 |
| **부속 typ** | .10 진짜 부속자재 ~26행(봉투·볼체인본체·우드거치/봉/행거·와이어링) | ".10 악세사리" 분류가 부자재에 어색 — .07 부자재 통합 여부 | "봉투·우드 거치대·와이어링·볼체인 본체 같은 **진짜 부속 재료**가 지금 '악세사리(.10)' 분류에 들어 있는데, 이걸 **'부자재(.07)' 분류로 옮길까요**, 아니면 그냥 '악세사리'로 둘까요? (자재인 건 맞고, 분류 라벨만 바꾸는 일입니다)" | .07 부자재 통합 / .10 유지. 봉투는 .14 별검토 |
| **AC-2** | 아크릴 두께 평면화(22상품→MAT_000192 단일) | 두께 분리 교정방향은 확정이나 실행 회차 | "아크릴 상품에서 두께(1.5mm·3mm·8mm)가 지금 한 자재로 뭉뚱그려져 있는데, **두께별로 따로따로 자재 행을 나눌까요**? (두께는 가격·재료가 다른 자재라서 나누는 게 맞습니다. 실행 시점만 정하면 됩니다)" | 두께별 mat_cd 분리(다음 회차 실측) |
| **C-CAT-1** | 카테고리 CAT_000302/304(비활성 상품 PRD_000218/229) | 비활성 상품 정체·정상 leaf 매칭 미확정 | "지금 안 쓰는(비활성) 상품 2개(타이벡북커버·이미지피켓)가 길 잃은 카테고리 노드에만 매달려 있습니다. **이 상품들을 다시 살릴까요**(살리면 정상 카테고리에 연결), **완전히 버릴까요**(버리면 노드도 삭제)?" | 활성화→재연결 / 폐기→노드 삭제 |

> **escalate 처리:** 서브에이전트 직접 질문 금지(agent-common-protocol). 본 컨펌 큐를 리더에 통지 → 리더가 사용자 일괄 결정. 결정 전 "어긋남" 단정 금지.

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
| 카테고리 신규 노드 | — | **신규 0** — 정상 leaf 전부 실재(재연결/신설 0) |

> **신규 그릇 정당 = vessel-gap 2건만**(형상 V-12·비치수 size). 둘 다 dbmap **기제안 재사용**(재발명 0). MAT_TYPE·MAT_FACET·신소재·카테고리 코드행 신규 = **0**. 자재 오염은 축이동/교정이지 신규 그릇 아님(directive 정합).

---

## 6. 위임 / 인간 승인 큐

| 트랙 | 위임처 | 내용 |
|------|--------|------|
| 실 적재(축이동·교정) | `dbm-axis-staged-load`(경로 Y 교정엑셀 우선) / `dbm-load-execution`(멱등 UPSERT·`WHERE del_yn='N'` 가드) | 자재 90행 축이동·BOM link 177 제거(GPM-4)·소프트삭제 del_yn='Y'·~26행 교정·카테고리 ~13노드 |
| DDL | `dbm-ddl-proposer`(기제안 재사용) | shape-axis(shape_cd)·goods-pouch-nondim-size(비치수 마스터)·MAT_FACET 컬럼(채택 시) |
| 컨펌 결정 | 리더 → 사용자 | §4 컨펌 큐 5건(B-MAT-3·AX-1·부속typ·AC-2·C-CAT-1) |
| 근본 교정(경로 Y) | 개발자 v03 재적재 | del_yn='Y'는 TRUNCATE 재적재 시 휘발 → v03 오염행/고아 제거·재적재(`_backlog/developer-code-changes.md`·P-TRUNCATE 가드) |
| 적재경로 미상 | admin 명세 확인 | shape_cd/비치수 마스터 컬럼 = DDL 적용 후 catalog 모델 노출(현재 admin 미구현) |

**재진단 금지(적용완료 인용):** round-22 ⑥ 카테고리 고아 페어 COMMIT(DELETE 111·use_yn 토글 UPDATE 12·단 del_yn 미수행분은 §1.2 신규)·레더 .06 교정·GPM-1/2 본체자재 41행 설계 GO.

---

## 7. hbg-validator 통지

- **등록 명세 마스터 완성(2026-06-18 del_yn 보정 반영)** — 자재(90 축이동·BOM link 177 제거·소프트삭제)·카테고리(~13 소프트삭제·2 BLOCKED)·4축 틀.
- **검증 포인트:** ① FK 위상 순서(본체 선적재→목적지→**BOM link 제거(GPM-4)→오염행 del_yn='Y' 마지막**) ② **삭제 권위 = del_yn='Y'(+del_dt)·use_yn 아님**(조회 차단 권위) ③ search-before-mint 입증(신규 코드행 0·신규 그릇 2 vessel-gap만) ④ component_prices 0참조(가격사슬 안전)·**단 BOM link 런타임 참조는 GPM-4 제거가 진짜 미완** ⑤ 멱등 가드 `WHERE del_yn='N'`+del_yn·use_yn 둘 다 추적 ⑥ 컨펌 큐 5건 미확정 분리 ⑦ round-22 ⑥ COMMIT분(DELETE/use_yn 토글) 재제안 0·**del_yn 미수행분만 신규(중복 아님)**.
- **escalate:** §4 컨펌 큐 5건 — search-before-mint로 신규 그릇 정당성이 모호한 항목은 없음(전부 기제안 재사용 또는 보류). 권위 모호분만 컨펌 큐.
- **★del_yn 정정 요지:** B5 blind-spot(use_yn만 추적) 해소. 라이브 del_yn='Y'는 임시책(TRUNCATE 재적재 휘발)·근본 = 경로 Y. **컨펌 큐 변화 없음**(5건 유지·del_yn 정정은 권위 플래그 교체일 뿐 컨펌 항목 추가/삭제 0).
