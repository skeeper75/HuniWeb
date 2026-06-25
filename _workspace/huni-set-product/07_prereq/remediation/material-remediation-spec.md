# 자재 기초데이터 교정 매니페스트 (셋트 가격 적재 선행) — material-remediation-spec

생성: §(huni-set-product) 07_prereq/remediation · 라이브 Railway DB 읽기전용 SELECT 실측(2026-06-24) · **DB 미적재(설계·DRY-RUN까지)** · 실 COMMIT/DDL/DELETE는 인간 승인
권위: 상품마스터 booklet-l1·photobook-l1(`_workspace/huni-dbmap/24_master-extract-260610/`) + webadmin 스키마(`raw/webadmin/sql/`) + del_yn 논리삭제 권위([[dbmap-del-yn-soft-delete-authority]]) + 사용자 확정 결정(원 프롬프트)
원칙[HARD]: search-before-mint(신규 mint 0)·멱등(WHERE 가드·IS DISTINCT FROM)·비파괴(물리 DELETE 0)·추측 금지(권위 미특정=CONFIRM 분리)

> **결론 한 줄**: 즉시 실행 가능한 **무조건 정답 교정은 P3 출력소재 종이 root 부활 9건뿐**. P1 면지 재배선과 P2 일부는 **권위가 재배선 대상 종이를 특정하지 않아 BLOCKED→CONFIRM**. 전용지 부활(P2)은 권위가 "전용지"를 명시하므로 실행 가능. **돈 영향 0**(모든 대상 자재 component_prices 참조 0건).

---

## 0. 사전 사실(라이브 실측·스키마)

| 사실 | 값 | 출처 |
|---|---|---|
| `t_mat_materials` del_yn/del_dt 보유 | ✅ | sql/24·information_schema 실측 |
| `t_prd_product_materials` del_yn/del_dt 보유 | ✅ (PK=prd_cd,mat_cd,usage_cd) | information_schema 실측 |
| 트리거 | `trg_*_upd_dt` BEFORE UPDATE upd_dt 갱신만(비파괴) | sql/03_triggers.sql:67-71 |
| 자기참조 FK | `fk_mat_materials_upr_mat_cd` upr_mat_cd→mat_cd | sql/02_foreign_keys.sql:55-57 |
| product_materials FK | `fk_prd_product_mats_mat_cd` mat_cd→mat_materials | sql/02_foreign_keys.sql:470-472 |
| 면지 4종 가격참조 | cp.mat_cd=0 / cp.opt_cd=0 | 실측 |
| FK_DEAD 자재 5종 상태 | 전부 del_yn=Y (배선행은 del_yn=N) | 실측 |
| 면지 CPQ 옵션 등록 | option_items ref_dim_cd 면지=0건 (옵션 경로 부재) | 실측 |
| USAGE.06=표지타입 코드 존재 | ✅ (포토북 하드/소프트/레더 = 표지타입 옵션이어야) | 실측 |

---

## P1 — 면지 4종 오염 정리 · **대부분 BLOCKED(CONFIRM)**

### 권위 판정(★중요)
booklet-l1 `제본(옵션)_면지(옵션)` = **택1 옵션값**(화이트면지/블랙면지/그레이면지/인쇄면지). 이는 **종이 종류가 아니라 색상 옵션값**이다. 권위 어디에도 "화이트면지 = 특정 백색 평량지"라는 종이 매핑이 **없음**. 따라서 사용자 P1 지시("mat_cd를 실제 면지 종이로 재배선")의 *대상 종이를 권위가 특정하지 않음* → **추측 금지 = CONFIRM**.

### 대상 라이브 행(정밀 실측 = 14행, 감사보드 "12행"은 set-wiring 기준 부분집합)

| mat_cd | mat_nm | product_materials 오염참조 | usage_cd | 가격참조 |
|---|---|---|---|---|
| MAT_000001 | 화이트면지 | 4행(072·077·082·088) | USAGE.03 면지 | 0 |
| MAT_000002 | 블랙면지 | 4행(072·077·082·088) | USAGE.03 면지 | 0 |
| MAT_000003 | 그레이면지 | 4행(072·077·082·088) | USAGE.03 면지 | 0 |
| MAT_000004 | 인쇄면지 | 2행(082·088) | USAGE.03 면지 | 0 |
| **합계** | | **14행** (+ 포토북 251 그레이 1행 = P2) | | |

### 교정 방향(2단계 — 둘 다 CONFIRM 의존)
1. **mat_cd 재배선**(선행): 14행의 mat_cd를 "실제 면지 종이"로 교체 — **대상 종이 미특정 → BLOCKED·CONFIRM**(confirm-queue P1-A). usage_cd=USAGE.03(면지)는 이미 정확하므로 유지.
   - *대안(권위 정합)*: 면지 색상(화이트/블랙/그레이/인쇄)은 **자재가 아니라 CPQ 옵션값** → 면지를 product_materials에서 빼고 `t_prd_product_option_*`(option_items)로 표현. 단 면지 CPQ 옵션은 **현재 미등록(0건)** → 셋트 옵션 설계 트랙(이번 자재 교정 범위 밖)에서 처리. confirm-queue P1-B.
2. **면지 자재 4종 논리삭제**(`del_yn='N'→'Y'`): product_materials가 mat_cd로 가리키는 한 **활성 배선 → 사멸 자재 참조**가 새로 생김(현 FK_DEAD를 자가 재생산). 따라서 **1단계(재배선/배선 논리삭제) 선행 없이 자재만 논리삭제 금지** → BLOCKED·CONFIRM 의존.

→ **P1 즉시 실행 교정 = 0건.** 전량 confirm-queue(P1-A 재배선 대상, P1-B 옵션화 결정).

---

## P2 — 셋트 FK_DEAD 재배선 · **부분 실행 / 부분 CONFIRM**

### 라이브 사멸참조 배선행(전수 = 6행, del_yn=N)

| ID | prd_cd | 상품 | mat_cd(사멸) | mat_nm | usage_cd | 권위 정답 | 분류 |
|---|---|---|---|---|---|---|---|
| P2-1 | PRD_000072 | 하드커버책자 | MAT_000246 | 전용지 | USAGE.02 표지 | booklet "표지종이=전용지" → **MAT_000246 부활** | MIS-LOADED→**실행** |
| P2-2 | PRD_000082 | 하드커버 링책자 | MAT_000246 | 전용지 | USAGE.02 표지 | booklet "표지종이=전용지" → **MAT_000246 부활** | MIS-LOADED→**실행** |
| P2-3 | PRD_000100 | 포토북 | MAT_000005 | 하드커버 | USAGE.02 표지 | photobook "표지타입=하드커버"=USAGE.06 옵션(종이 아님)·표지종이는 MAT_000250 OK행 별존 → **배선 논리삭제** | EXTRA→CONFIRM |
| P2-4 | PRD_000100 | 포토북 | MAT_000007 | 소프트커버 | USAGE.02 표지 | photobook "표지타입=소프트커버"=USAGE.06 옵션 → **배선 논리삭제** | EXTRA→CONFIRM |
| P2-5 | PRD_000100 | 포토북 | MAT_000006 | 레더하드커버 | USAGE.02 표지 | photobook "표지타입=레더하드커버"=USAGE.06 옵션 → **배선 논리삭제** | EXTRA→CONFIRM |
| P2-6 | PRD_000100 | 포토북 | MAT_000251 | 그레이(면지) | USAGE.03 면지 | photobook "면지=그레이"=면지 옵션값(종이 미특정) → P1과 동일 | CONFIRM(P1-A) |

### P2 실행 정답 = 전용지 부활(P2-1·P2-2)
- **search-before-mint**: 전용지 후보 = MAT_000172 "하드커버전용지+무광코팅"(살아있음). 그러나 권위 booklet은 표지종이를 **단순 "전용지"** 로 명시(코팅 미명시) → 의미 최충실 = 사멸된 **MAT_000246 "전용지" 부활**(`del_yn Y→N`). MAT_000172로의 재배선은 권위가 코팅 여부를 특정 안 함 → 채택 보류(confirm-queue P2-X에 대안 기록).
- 부활하면 P2-1·P2-2 배선행(현 del_yn=N, mat_cd=MAT_000246)이 **자동으로 살아있는 자재를 가리킴 → FK_DEAD 해소**. 배선행 자체는 손대지 않음(이미 올바른 mat_cd·usage_cd).

### P2 CONFIRM(포토북)
- P2-3~P2-5: 표지타입(하드/소프트/레더하드커버)은 USAGE.06 옵션 의미인데 USAGE.02(표지) 자재로 박힘 + 자재 사멸. 표지종이는 MAT_000250(아트250+무광코팅)·MAT_000186(레더화이트) **OK행이 이미 존재**(중복 표지) → 사멸 표지타입 배선행 **논리삭제**가 정답으로 보이나, "표지타입을 CPQ 옵션으로 재표현"이 동반돼야 완결 → 셋트 옵션 설계 트랙. confirm-queue P2-3/4/5.
- P2-6: 면지 그레이(251) = P1-A와 동일(면지 종이 미특정).

→ **P2 즉시 실행 = MAT_000246 부활 1건**(배선 2행 자동 정합). 나머지 4행 CONFIRM.

---

## P3 — 출력소재 계층 부활 · **종이 root 9건 실행 / 경계·NO_ROOT CONFIRM**

### P3-A 출력소재 종이 root 부활(실행 정답)
사용자 결정: "출력소재 상위자재 13개 del_yn=Y = 오류 → 부활". 라이브 실측 결과 **dead_root_live_children = 13개**이나, 그중 **출력소재(MAT_TYPE.01 종이) root는 9개**(활성 자식 보유):

| root mat_cd | root_nm | mat_typ | 활성 자식수 | 부활 |
|---|---|---|---|---|
| MAT_000071 | 백모조 | 01 종이 | 3 | ✅ |
| MAT_000075 | 아트 | 01 종이 | 8 | ✅ |
| MAT_000085 | 스노우 | 01 종이 | 8 | ✅ |
| MAT_000094 | 앙상블 | 01 종이 | 5 | ✅ |
| MAT_000100 | 랑데뷰 | 01 종이 | 2 | ✅ |
| MAT_000103 | 몽블랑 | 01 종이 | 9 | ✅ |
| MAT_000122 | 띤또 | 01 종이 | 2 | ✅ |
| MAT_000143 | 투명 | 01 종이 | 2 | ✅ |
| MAT_000146 | 반투명 | 01 종이 | 2 | ✅ |
| **합계** | | | **41 활성자식 정합** | **9건** |

- `del_yn Y→N`. 부활 정당화 = 각 root에 활성 자식 존재(고아 자식 41건 계층 복구).
- **sel_typ_cd 부작용 검토**: 9 root 전부 `sel_typ_cd=SEL_TYPE.01(단일)`. root는 그룹핑 노드인데 단일선택값을 가져 **부활 시 선택목록 재노출 우려**. 단 SEL_TYPE에는 "비선택" 코드가 없음(01단일/02다중뿐). → 부활은 계층 복구가 목적이고, 선택목록 노출은 product_materials 배선(자식 종이가 선택지)으로 제어되지 root 자체로 노출되지 않음(root는 product에 배선 안 됨). **부작용 없음 판정**. 단 그룹핑 노드 의미 명시 필요 시 confirm-queue P3-X(설계 옵션).

### P3-B 비종이 root 4개 — 사용자 "13개"와 경계 불일치 → CONFIRM
dead_root_live_children 13개 중 **종이 아닌 4개**: 투명커버(MAT_TYPE.02·자식2)·아크릴(03·자식3)·D링(04·자식5)·아크릴부자재(07·자식13). 사용자가 "출력소재 13개"라 했으나 출력소재(종이) 엄격정의로는 9개. 이 4개는 부자재/소재 root — 부활하면 계층 복구되나 "출력소재"는 아님 → **사용자 의도 확인 필요**. confirm-queue P3-B(4건).
- 활성 자식 0인 dead_root 6개(볼체인·굿즈부속·파우치·모조·유포·레더하드커버A·MAT_000058 등)는 **부활 보류**(자식 없어 부활 정당성 없음) — 보고만.

### P3-C upr_mat_cd 미연결 평량 종이 31건 — 대부분 매칭 root 부재 → CONFIRM
NO_ROOT 31건(MAT_TYPE.01·upr NULL·자식없음) 중:
- **매칭 root 후보 있음(애매)**: 스타드림 7종(스타드림 root 부재)·아트250+무광코팅(아트 root 후보지만 코팅변형)·큐리어스스킨 5종(root 부재) 등 → 추측 매칭 금지.
- **매칭 root 없음**: 팬시크라프트·한지·린넨커버·스코트랜드·매쉬멜로우·켄도·뉴크라프트·매직터치·아코팩·유니크라프트·클래식크래스트·그문드·아이보리·인바이런먼트·마테리카·리메이크스카이·뉴에코블랙 등 = 고유 브랜드지(평량변형 아님 또는 root 미존재).
→ **31건 전량 CONFIRM**(이름 매칭 모호·신규 root mint는 search-before-mint 위반). confirm-queue P3-C.

→ **P3 즉시 실행 = 종이 root 부활 9건.**

---

## 종합 실행/보류 분포

| 구분 | 즉시 실행(apply.sql) | CONFIRM(보류) | 돈영향 |
|---|---|---|---|
| P1 면지 | 0 | 14 배선행(P1-A 재배선)+면지자재 4종 논리삭제(P1 의존)+옵션화(P1-B) | 0 |
| P2 FK_DEAD | **1**(MAT_000246 부활 → 배선 2행 정합) | 4행(포토북 표지타입3·면지1) | 0 |
| P3 계층 | **9**(종이 root 부활) | 4(비종이 root)+31(NO_ROOT)+6(자식0 root 보류) | 0 |
| **합계** | **10 UPDATE**(자재 10행 del_yn Y→N) | **CONFIRM 큐 19+ 항목** | **0원** |

- **즉시 실행 = 자재 10행 `del_yn='Y'→'N'` 부활**(MAT_000246 전용지 + 종이 root 9). 모두 부활(논리삭제 아님)·재배선 0·mint 0.
- **search-before-mint 위반 = 0**(신규 자재 생성 없음, 전부 기존 행 부활).
- **돈 영향 = 0**(대상 자재 component_prices 참조 0건. 부활은 가격에 신규 단가행 추가 아님).
- **셋트 가격 적재 가부**: 즉시 실행 10건 부활은 셋트 가격과 무관(가격참조 0). 셋트 가격 적재는 **이 교정 없이도 안전**(오염 면지 가격참조 0)하나, 사용자 결정대로 **계층 부활을 가격 적재보다 먼저** 수행 가능(독립·비충돌).

## 라우팅
- 즉시 실행 10건 → apply.sql(인간 승인 후 dbm-load-execution COMMIT).
- P1 재배선·P2 포토북 표지타입 옵션화 → 셋트 옵션 설계 트랙(CPQ option_items) + confirm-queue.
- P3-B/C 경계·NO_ROOT → confirm-queue(실무진/사용자 확인).
</content>
</invoke>
