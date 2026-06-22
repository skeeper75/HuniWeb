---
name: dbm-loadspec-extract
description: >
  후니프린팅 라이브 admin 소스(raw/webadmin Django catalog)를 읽어 각 t_* 엔티티가 무엇을 어떻게 적재하는가(컬럼·폼
  위젯·검증·코드값 그룹·자동채번·감사컬럼·논리삭제·FK·드릴다운 적재경로)를 코드 근거(file:line)로 추출하는 방법론
  (round-11). models.py·admin.py(BaseAdmin)·basecodes.py·views.py 대상·두 적재 surface(표준 changeform·상품뷰어)·필수여부 도출·코드값 enum 열거. DB 미접속.
  트리거: webadmin 적재명세, 적재 로직 추출, t_* 적재방법, Django admin 적재 분석, BaseAdmin 폼 분석, 코드값 그룹 추출, 상품뷰어 적재경로, round-11 적재명세.
  라이브 DB DDL 사실 추출은 dbm-schema-extract, 컬럼 도메인 의미·상품 BOM은 dbm-column-domain.
---

# dbm-loadspec-extract — raw/webadmin 적재명세 추출 방법론

라이브 admin의 소스코드(`raw/webadmin`)를 권위로, 각 t_* 엔티티가 **어떻게 적재되는가**를 명세화한다. dbm-schema-extract(라이브 DB DDL=런타임 사실)와 상보적 — 이 스킬은 "소스코드가 규정한 적재 방법"을 담당한다. 매핑이 라이브가 지원하지 않는 적재 경로를 발명하지 않도록 막는 권위다.

## 권위 [HARD]
- **raw/webadmin 소스 = 적재 방법 권위.** 컬럼이 어떻게 채워지고·검증되고·기본값/자동채번되고·코드 제한되는지는 Django 코드가 말하는 그대로. `file:line` 인용.
- **DB 미접속.** 라이브 DDL/행 사실은 dbm-schema-analyst 담당. 코드만 읽는다. 코드와 라이브 스키마가 어긋나 보이면 추측으로 메우지 말고 discrepancy로 기록한다.
- **감사/자동 컬럼은 적재 사실.** `reg_dt DEFAULT now()`·`upd_dt` 트리거·surrogate PK 자동채번(round-9 코드전략: 순차 surrogate·이름기반 멱등)은 사용자 입력 컬럼이 아니다 — 명확히 표시해 매핑이 공급하려 들지 않게 한다.

## 추출 대상 (raw/webadmin/webadmin/catalog/)

| 파일 | 추출 내용 |
|------|----------|
| **models.py** | `db_table`별 필드셋(컬럼·타입·FK·`db_table_comment`), 34모델. `class Meta` 제약. |
| **admin.py** | 제너릭 `BaseAdmin(UnfoldModelAdmin)` 적재 동작 — `list_display`·`exclude`(`reg_dt`/`upd_dt` 숨김)·`autocomplete_fields`(대용량 FK 검색형)·`readonly_fields`·`save_model`·논리삭제(`del_yn`)·per-model Admin 서브클래스 오버라이드(예 `TPrdTemplatesAdmin`). |
| **basecodes.py** | `BASE_CODE_GROUP` 맵 — 필드→`t_cod_base_codes` 그룹(`usage_cd`→USAGE·`mat_typ_cd`→MAT_TYPE·`prd_typ_cd`→PRD_TYPE 등 14). `basecode_queryset`가 `cod_cd__startswith=GROUP+"."`로 그룹 멤버만 노출 = **컬럼별 코드값 적재 도메인**. |
| **views.py** | 커스텀 상품뷰어 적재경로 — `section_edit`·`_save_inline_items`(옵션그룹 인라인)·`_save_drilldown_row`/`_drilldown_edit`(상품별 자식행)·각 경로가 쓰는 t_*. (2500+줄 → Grep 후 타겟 Read.) |
| **cfg_utils.py** | 트리/계층 필드 설정(`upr_cat_cd` 부모 드롭다운·exclude-leaf 모드). |

## 절차
1. **제너릭 적재 기계 1회 추출.** `BaseAdmin`이 전 t_*를 제너릭 changeform으로 자동 등록 → 공통 동작(exclude 감사컬럼·autocomplete FK·save_model·논리삭제)을 한 번 기술하고, 엔티티별 delta(어느 필드 exclude·어느 FK autocomplete·서브클래스 오버라이드)만 기록. 모델마다 제너릭 재기술 금지.
2. **코드값 도메인 열거.** `t_cod_base_codes` FK 컬럼은 해당 그룹 멤버만 허용 → 그룹별 enum을 열거(매핑은 "FK다"가 아니라 실제 허용값이 필요).
3. **두 적재 surface 구분.** 표준 admin changeform(모델 1개·전 필드) vs 커스텀 상품뷰어 section/drilldown(상품별 자식행·views.py). 각 t_*가 어느 surface로 적재되는지(필수 필드·FK 스코프가 다름).
4. **필수여부 코드 도출.** `NOT NULL` + no default + not in `exclude` = 필수 입력. `exclude`/DB default = 비입력. 테이블명이 아니라 models+admin 종합으로 도출.
5. **인용·distill.** 엔티티별 행에 `file:line` 근거. 대형 코드블록 붙여넣기 금지 — 명세 표로 distill.

## 산출 포맷

`_workspace/huni-dbmap/15_domain-spec/_loadspec/`:

**`loadspec-<entity>.md`** (또는 통합 `loadspec.md`)
| 컬럼 | 타입 | 필수(근거) | 적재 위젯/방식 | 코드값 그룹(basecodes) | 자동채번/감사 | 적재 surface | file:line |

**`loadspec-codegroups.md`** — 전체 `BASE_CODE_GROUP` 맵(필드→그룹)·각 그룹 용도.

**`loadspec-overview.md`** — 제너릭 `BaseAdmin` 기계 1회·두 적재 surface·엔티티별 delta/오버라이드.

## 함정
- 모델마다 제너릭 동작 재기술 = 토큰 낭비. 1회 기술 + delta만.
- 코드값 컬럼을 "FK다"로만 적기 = 매핑이 허용 enum을 모름. 그룹 멤버 열거 필수.
- views.py 전체 Read = 낭비. Grep(함수명·t_* 테이블명) 후 타겟 Read.
- 헬퍼(cfg_utils·서브클래스 Admin) 동작을 이름으로 추론 = 금지. 전문 Read 후 기술.
- 코드와 라이브 스키마 불일치를 코드 쪽으로 임의 정합 = 금지. discrepancy로 남겨 validator/schema-analyst가 해소.
