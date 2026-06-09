# BLOCKED / GAP — 프리미엄엽서(PRD_000016) CPQ 옵션레이어 적재본

> 패키지 `09_load/_exec_postcard_cpq/`. 정직 분리 원칙: BLOCKED 행은 절대 INSERTABLE 로 재포장하지 않는다.
> 각 항목은 **차단 사유 + 해제(unblock) 조건**을 명시한다. 실 적재(차원 선적재·DDL·코드행 등록)는 인간 승인.

---

## A. BLOCKED — option_items 5행 (차원행 부재 → 트리거 REJECT)

격리 파일: `_blocked/07_t_prd_product_option_items_BLOCKED.sql` (apply.sql 에서 `\i` 안 함).
트리거 `fn_chk_opt_item_ref` 가 `(prd_cd, 차원행)` EXISTS 를 행단위로 강제 → 차원행 0행이면 EXCEPTION → 전체 ROLLBACK.

| opt(재코드) | ref_dim_cd | ref_key1 | 차단 사유(라이브 0행) | 해제 조건 |
|---|---|---|---|---|
| 오시 `OPV_000022` | OPT_REF_DIM.04 공정 | PROC_000029 | t_prd_product_processes(PRD_000016, PROC_000029) **0행** | PROC_000029 를 PRD_000016 차원 선적재(공정 mint+링크·인간 승인) + GAP-PARAM(줄수 0~3 보존처) 결정 |
| 미싱 `OPV_000023` | OPT_REF_DIM.04 공정 | PROC_000030 | processes(030) **0행** | PROC_000030 차원 선적재 + GAP-PARAM(줄수) |
| 가변텍스트 `OPV_000024` | OPT_REF_DIM.04 공정 | PROC_000031 | processes(031) **0행** | PROC_000031 차원 선적재 + GAP-PARAM(개수) |
| 가변이미지 `OPV_000025` | OPT_REF_DIM.04 공정 | PROC_000032 | processes(032) **0행** | PROC_000032 차원 선적재 + GAP-PARAM(개수) |
| 별도설정 `OPV_000019` | OPT_REF_DIM.03 자재 | `[CONFIRM]` mat_cd | t_prd_product_materials(PRD_000016) **0행**(종이=*별도설정 센티넬) | 종이 자재 차원 선적재 vs deferred 센티넬(mat_cd 규약) 확정(GAP-DEFER·D-2) |

> **헤더는 적재됨:** 종이 그룹(OPT_000006)·후가공 그룹(OPT_000008)·해당 옵션 5개(options 13행 중) 자체는 트리거 없어 적재 가능. **차단은 item 레벨**(차원행 포인터). 즉 UI 에는 후가공/종이 옵션이 노출되나, 그 옵션이 가리킬 차원행이 아직 없어 환원 미완.
> [HARD] qty 에 줄수/개수 smear 금지(qty=소비수량, 줄수≠qty). ref_param_json 부재로 줄수/개수는 미보존(GAP-PARAM).

---

## B. `[CONFIRM]` — 라이브 실측이 설계와 충돌(발명 금지·인간 결정)

### CONFIRM-1 (적재 영향 有) — 카드봉투 base_prd_cd: PRD_000004 vs PRD_000281
- **설계**: 카드봉투 base = `PRD_000004`(카드봉투), freeze `SIZ_000104`.
- **라이브**: 카드봉투(화이트) 전용 상품 `PRD_000281` 존재. 소프트삭제 템플릿 `TMPL-000007`(base PRD_000281·del_yn=Y)·`TMPL-000008`(블랙 PRD_000282·del_yn=Y) 실재. **활성(del_yn=N) 카드봉투 템플릿 0개.**
- **본 적재 채택**: 설계 권위대로 `TMPL_000010` base=`PRD_000004` mint(SIZ_000104 가 PRD_000004 에 실재함을 라이브 확인 — freeze 무결성 통과). 
- **해제(결정)**: 봉투 SKU base 를 일반 `PRD_000004`(카드봉투) vs 전용 `PRD_000281`(카드봉투 화이트) 중 무엇으로 할지 인간 결정. PRD_000281 채택 시 TMPL_000010 base 를 PRD_000281 로 교체 + 그 상품 SIZ 보유 재확인 필요. **현재는 PRD_000004 로 적재(설계 권위)·차단 아님.**

### CONFIRM-2 (적재 영향 無·note 보존) — SIZ_000104 장수 충돌
- siz 명칭 "화이트165x115mm**(10장)**" baked-in 장수 vs template_selections.qty=**50**(addon note 권위).
- 해제: siz 명칭에서 장수 제거(마스터 정합·GAP-C 연계). 적재 차단 아님 — qty=50 적재(addon note 권위)·note 보존.

### CONFIRM-3 (적재 영향 無) — 봉투 가격 보관처
- `t_prd_templates.price` 컬럼 라이브 부재(R4). 봉투 추가가격 보관처 미정(가격엔진 t_prc_* 연계 vs 컬럼 추가).
- 해제: 가격엔진 연계 결정(ddl-proposer/가격트랙). 적재 차단 아님(템플릿은 가격 없이 적재).

---

## C. GAP (구조적 한계 — 본 적재 범위 밖)

| GAP | 내용 | 등급 | 처리 트랙 |
|---|---|:--:|---|
| **GAP-PARAM** | 후가공 줄수(오시/미싱)·개수(가변T/I) 0~3 선택값 보존처(`ref_param_json`) 부재 | High | `dbm-ddl-proposer`(ALTER 제안). 본 적재는 BLOCKED item 으로 우회·R-HUGA-PARAM constraint 로 범위만 강제 |
| **GAP-DEFER** | 종이=*별도설정·후가공 4종 차원행 선적재 미완(A절 BLOCKED 5행 직결) | High | 차원 선적재(공정/자재 mint+링크·인간 승인) vs deferred 센티넬 규약 |
| **GAP-B** | ★사이즈선택 동적 addon(L1 row1 "엽서봉투 사이즈선택:100x150"=본체연동 freeze) | Minor | template 고정 freeze 한계 인정 vs 동적 selection 메커니즘 신설 |
| **GAP-C** | note→siz_cd 마이그 규칙(명칭 문자열 파싱 의존·오매칭 위험) | Minor | 명시 매핑표 |

---

## D. 적재된 것 vs 미적재 정리 (정직 경계)

**적재(INSERTABLE·DRY-RUN 실증, COMMIT 0):** option_groups 5 · options 13 · option_items **4**(도수2·모서리2) · templates **1**(카드화이트 mint) · template_selections **1** · addons **2**(접착/카드 신규·비접착 1행 기실재 흡수→누적3) · constraints **3** · constraint_json compile UPDATE 1.

**미적재(BLOCKED/CONFIRM/GAP):** option_items 5(후가공4·종이1) · 봉투 접착/비접착 템플릿(라이브 실재라 의도적 미관여) · 후가공 줄수/개수 파라미터(GAP-PARAM). 별색 그룹(본 상품 미보유·미인스턴스화).

> [HARD] 본 패키지는 빌드 산출이며 **GO 선언 아님**. `dbm-validator` 가 R1~R6 + S-gate 로 별도 게이트. 실제 COMMIT·차원 선적재·DDL·코드행 등록은 인간 승인.
