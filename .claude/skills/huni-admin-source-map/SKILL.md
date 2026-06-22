---
name: huni-admin-source-map
description: >
  후니 webadmin(Django+Unfold admin) 소스에서 라이브 admin의 모든 화면·메뉴·항목을 전수 도출해
  "admin 화면 맵"을 만드는 방법론. 제너릭 ModelAdmin 자동등록(changelist/changeform) 정적 전개,
  list_display/search/filter/inline/자동채번/논리삭제 규칙 추출, 커스텀 뷰(product-viewer·옵션·SKU·제약)
  인벤토리, 화면 목록 표 산출. 트리거: admin 소스 분석, admin 화면 맵, 메뉴 전수 추출, ModelAdmin 옵션 추출,
  커스텀 뷰 인벤토리, 화면 인벤토리. 라이브 캡처는 huni-admin-live-capture, 집필은 huni-admin-manual-authoring 담당.
---

# Huni Admin 소스 화면 맵 추출

라이브 admin이 어떤 화면으로 구성되는지를 **소스 코드(권위)** 에서 전수 도출하는 방법론. 산출물은 캡처·DB검증·작성의 단일 뿌리가 된다.

## 왜 소스가 권위인가

라이브 화면은 동적 등록(`apps.get_app_config("catalog").get_models()` 루프)으로 생성된다. 화면을 클릭으로만 발견하면 빠뜨릴 수 있다. 소스를 읽으면 "등록되는 모델 전체 + 등록 규칙 + 커스텀 뷰 전부"를 결정적으로 열거할 수 있다. 그래서 맵은 소스에서 만들고, 라이브는 그것을 시각적으로 확증하는 순서다.

## 두 레이어를 모두 전개한다

### 레이어 1 — 표준 Django admin (제너릭 등록)

`catalog/admin.py`는 전 모델을 루프로 등록한다. 정적으로 전개하려면:

1. **등록 모델 열거** — `catalog/models.py`에서 모델 클래스를 모두 찾는다(`class T... (models.Model)`). 각 모델의 `db_table`, `db_table_comment`(=좌측 메뉴 한글 라벨), PK 종류를 기록.
2. **복합PK 분기** — `CompositePrimaryKey`인 모델은 단독 등록에서 제외(`_skipped_composite`)되고 **부모 화면 인라인**으로만 나타난다. 어느 부모의 인라인인지 매핑한다(`PRODUCT_INLINE_MODELS`, `TPrdTemplateSelectionsInline`).
3. **화면 2종 도출** — 등록 모델마다 ① **목록(changelist)**: `_make_admin`의 규칙으로 list_display=앞 8개 concrete 필드, search_fields=*_nm/*_cd/note 중 최대 6, list_filter=use_yn/*_typ_cd 최대 4, list_per_page=50. ② **추가/수정(changeform)**: concrete 필드 전체(감사컬럼 reg_dt/upd_dt는 readonly), 라벨=db_comment.
4. **특수 Admin 오버라이드** — 일반 규칙을 벗어나는 모델을 따로 기록:
   - `TPrdProducts` → changeform에 상품뷰어 링크 템플릿(`product_change_with_viewer_link.html`)
   - `TCodBaseCodes` → `BaseCodeAdminForm`(빈 코드+상위 미선택 시 폼 오류)
   - `TPrdTemplates` → `TPrdTemplatesAdmin`(선택값 인라인, 논리삭제, changelist 팝업 JS, change_view가 SKU 화면으로 redirect)
5. **횡단 자동 동작** — 운영자가 체감하는 공통 동작을 규칙으로 추출:
   - 자동채번: `AUTO_SERIAL_TABLES`(PREFIX_000000 시리얼)·`t_cod_base_codes`(GROUP.NN) — PK 비우면 저장 시 채번
   - YN 드롭다운: `*_yn` 필드는 Y/N Select(단 `YN_ENHANCE_EXCLUDE` 제외), 신규 기본값 use_yn=Y·기타 N
   - 표시순서(disp_seq): 비우면 같은 상위그룹 내 max+1
   - 트리 드롭다운: `SELF_PARENT_TREES`(upr_cat_cd 등) 상위 선택 들여쓰기
   - 논리삭제: TPrdTemplates 삭제=del_yn='Y'(물리삭제 아님)
   - placeholder 안내문구(`_placeholder`)

### 레이어 2 — 커스텀 뷰 (상품 뷰어 등)

`config/urls.py`의 `urlpatterns`에서 `admin.site.admin_view(views.X)`로 감싼 path를 전부 열거하고, `catalog/views.py`의 해당 뷰 함수 + 템플릿을 읽어 화면을 인벤토리한다:

- `admin/` → product_viewer로 redirect(홈)
- `product-viewer/` 목록, `<prd_cd>/` 상세, `edit/<section>/` 섹션 편집
- 옵션 드릴다운 3계층: `options/` → `options/<grp>/` → `options/<grp>/<opt>/`
- SKU 2계층: `templates/` → `templates/<tmpl>/`
- `dim-choices/`(Ajax), `constraints/`·`validate/`(제약 폼빌더+미리보기)
- standalone: `impact/`(사용처), `sku-catalog/`(전체 SKU)

각 뷰는 {URL·화면명·진입 경로(어디서 클릭해 오는가)·주요 구성요소·액션 버튼·Ajax 의존}으로 기록.

## 읽기 전략 (큰 파일)

`views.py`·템플릿이 길면 Tier 3/4 전략(파일 읽기 최적화): Grep으로 `def {view}`·`render(`·`reverse(`·context 키·`<form`·`<button`을 먼저 찾고 해당 구간만 Read. `admin.py`는 이미 전체 파악됨(등록 규칙은 위 요약 참조).

## 산출 표준

`_workspace/huni-admin-manual/01_source_admin-screen-map.md`:

1. **사이트 개요** — 사이트 헤더("후니 상품·가격 DB 관리자"), 홈=상품뷰어, 좌측 메뉴 그룹(도메인별 모델), 테마(Unfold).
2. **화면 목록 표** (캡처가·작가가 작업 큐로 소비):

   | 화면ID | 레이어 | 유형 | 한글 라벨 | URL 패턴 | 우선순위 |
   |--------|--------|------|----------|----------|----------|
   | tprdproducts__changelist | 표준 | 목록 | 상품 | /admin/.../tprdproducts/ | High |
   | product-viewer__home | 커스텀 | 대시보드 | 상품 뷰어 | /admin/product-viewer/ | High |

3. **표준 모델 상세** — 모델별 {라벨·db_table·changelist 컬럼·검색·필터·changeform 필드(라벨·필수·readonly)·인라인·특수동작·복합PK여부}.
4. **커스텀 뷰 상세** — 뷰별 {URL·진입경로·구성요소·액션·Ajax}.
5. **횡단 동작 사전** — 자동채번·YN·논리삭제·트리·표시순서 규칙.
6. **라이브 확인 필요 플래그** — 소스만으로 불확실한 동작(캡처가에게 위임).

우선순위는 운영 빈도 기준(상품/가격/옵션=High, 드물게 쓰는 기초코드=Medium 등)으로 작가의 챕터 순서를 돕는다.

## 완료 기준

- 등록 모델 전수 열거 + 복합PK 인라인 매핑 완료
- 커스텀 뷰 전수 열거(urls.py의 모든 admin_view path)
- 화면 목록 표가 캡처/작성에 1:1로 소비 가능
- 추측 0 — 모든 항목이 소스 라인 근거
