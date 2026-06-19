# 기초데이터 축 레지스트리 — 표시중복 정리 하네스 확장 범위 확정

> **목적**: 추정 6축이 아니라 라이브 DB 스키마(44테이블 = t_* 도메인 34 + Django 10)를 실측해, 본 하네스(표시명 중복 검수·정리·적재)의 **진짜 기초데이터 대상 축**을 확정한다.
>
> **판정 기준**: 코드 PK(`_cd`) + 표시명/라벨 컬럼(`_nm`) 보유 + 사용자가 화면(견적 위젯·admin)에서 선택하는 **마스터 코드 테이블**. 순수 트랜잭션/바인딩(`t_prd_product_*`), 가격 사슬(`t_prc_*`·`t_dsc_*`), Django 시스템은 제외(영향만 표기).

## 출처 / freshness

- 구조 권위(재사용): `_workspace/huni-dbmap/00_schema/columns.csv`(34 t_* 전 컬럼), `schema-overview.md`. 엑셀 Read 0회.
- 라이브 실측(읽기전용 SELECT, `.env.local RAILWAY_DB_*`): row count·use_yn/del_yn·표시명 중복 sniff·가격종속. 추출 시각 **2026-06-19 08:02**.
- 라이브 freshness(max upd_dt): proc=2026-06-18, cat=2026-06-19 01:22, mat=2026-06-19 01:48 → cat/mat은 최근(round-22/24 정리분) 변동 중이므로 정리 시 재실측 권장.

## 확정 기초데이터 축 (BASEDATA = 6)

| table | 한글 의미 | 표시명 컬럼 | 코드 PK | 라이브 행수(total/active/notdel) | 표시중복 sniff(그룹수) | 가격종속 | 우선순위 |
|-------|----------|------------|---------|------------------|------------------|---------|---------|
| `t_siz_sizes` | 사이즈(작업/재단/판형) | siz_nm | siz_cd | 520 / 520 / 454 | **1** (raw) | **Y** (component_prices 84 siz_cd) | **DONE-PILOT** |
| `t_proc_processes` | 공정(인쇄/후가공) | proc_nm | proc_cd | 102 / 102 / 101 | **13** | **Y ★정정** (component_prices.proc_cd 1,919행/25코드) | **DONE-PILOT** (9건 논리삭제 COMMIT·BLOCKED 3) |
| `t_cat_categories` | 카테고리(고객 IA·트리) | cat_nm | cat_cd | 326 / 315 / **활성79** | 11→**3 실측** | N (확정·grade cat_cd 0행) | **DONE-PILOT** (rename1+디자인캘린더 동형교정) |
| `t_mat_materials` | 자재(본체/부자재) | mat_nm | mat_cd | 340 / 340 / 192 | **1** (raw) | **Y** (component_prices 68 mat_cd) | **MEDIUM** |
| `t_clr_color_counts` | 도수(색상/채널) | clr_nm | clr_cd | 5 / 5 / 5 | 0 | N (단가행 clr_cd 0) | **LOW** |
| `t_cod_base_codes` | 기초코드(enum 사전) | cod_nm | cod_cd | 85 / 84 / — | 0 (부모그룹 기준) | N | **LOW** |

### 우선순위 근거
- **★공정 가격종속 정정(2026-06-19 파일럿 실측)**: 본 표가 "공정=가격비종속(N)"이라 한 건 **거짓**. `component_prices.proc_cd` 1,919행/25코드 실재 = Y. 단 표시중복 13그룹의 thin-mirror 자식 9건은 참조 0이라 가격 무영향 안전(논리삭제 COMMIT), 오적재 3건(미싱/오시/타공 자식이 단가행 보유)만 BLOCKED. **잔여 축(카테고리·도수·기초코드)도 "N" 표기를 믿지 말고 추출 단계에서 가격종속 직접 재확인할 것.**
- **HIGH**: 표시중복 sniff가 많고(11~13). `t_proc_processes`(DONE·9건 적재), `t_cat_categories`(부자재/명함/특수스티커/하드커버책자/레더에코백/탁상형캘린더/엽서북 등).
- **MEDIUM**: `t_mat_materials`는 표시중복 raw 1건뿐이나 **가격종속(68 mat_cd)** + del_yn=N 192행(오염·논리삭제 多, round-22④ 트랙) → 정리 시 component_prices 영향 점검 필수.
- **LOW**: `t_clr`(5행), `t_cod`(85행) 모두 표시중복 0 → 정리 실익 낮음. 단 `t_cod_base_codes`는 전 도메인 `*_typ_cd` FK 권위라 변경 영향 광범위.
- **DONE**: `t_siz_sizes`는 파일럿 GO(완료). siz_nm raw 1건은 의미축 구분(작업/재단/판형·잠정) false-positive 가드 대상.

## 제외 축 (EXCLUDE = 5) — 영향만 표기

| table | 분류 | 사유 / 기초데이터 의존 |
|-------|------|----------------------|
| `t_prc_price_components` (comp_nm) | 가격사슬 | 표시명 있으나 가격 부품. comp_nm 네이밍 표준화는 별 트랙. formula_components 84·component_prices 7288 의존 |
| `t_prc_price_formulas` (frm_nm) | 가격사슬 | 가격공식. product_price_formulas 76 바인딩 |
| `t_dsc_discount_tables` (dsc_tbl_nm) | 가격사슬(경계) | 코드+표시명 있으나 사용자 선택이 아닌 가격 적용 헤더. discount_details 의존 |
| `t_prd_products` (prd_nm) | 상품 본체 | 마스터 본체·JOIN KEY. 표시중복 0. 본 하네스 대상 아님 |
| `t_prd_templates` (tmpl_nm) | 트랜잭션(SKU) | base_prd_cd 종속 조합. 소규모·중복 0 |

> `t_prd_product_*` 11개 바인딩/매핑 테이블, `t_cus_customers`, `t_prc_*` 단가행, Django 10 시스템 테이블은 기초데이터 PK+표시명 패턴이 아니거나 순수 트랜잭션이므로 후보에서 제외.

## 추정 6축 대비 교정

추정 6축 = ① 기초코드 ② 사이즈 ③ 도수 ④ 자재 ⑤ 공정 ⑥ 카테고리. **실측 결과 6축 모두 BASEDATA로 확정(추가/제외 없음)** — 추정이 정확했다. 다만 다음을 보정:

- **우선순위 재배치**: 추정은 "자재🔴·카테고리🔴 1순위"였으나, 본 하네스(표시중복 정리) 관점에서는 **공정(13)·카테고리(11)가 HIGH**(중복 多 + 가격 비종속 = 안전), **자재는 MEDIUM**(중복 1 + 가격종속 = 신중). 도수·기초코드는 **LOW**(중복 0).
- **경계 축 식별**: `t_prc_price_components`/`t_prc_price_formulas`/`t_dsc_discount_tables`도 코드+표시명을 가지나 가격사슬이라 제외(영향만). 추정 6축에 없던 이 3개를 명시적으로 경계로 분류해 오확장 방지.
- **DONE 표기**: `t_siz_sizes`는 파일럿 완료로 별도 표기.
