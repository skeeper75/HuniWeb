# added-schema-260701.md — 위젯 추가 스키마 사유·영향분석

> 파이프라인 ③' 컨버전 선행. 권위 스키마 `docs/huni/table-spec_260619.html`(36테이블/374컬럼)에 **없는데
> 위젯 정규화 계약이 필요로 하는** 진짜 갭만 추가(search-before-mint). DDL=`added-schema-260701.sql`.
> 병합 명세=`docs/huni/table-spec_260701.html`. **실 적용은 §7 dbmap 인간 승인 후** — 여기는 제안까지.

## 0. search-before-mint 원칙

기존 36테이블/374컬럼으로 표현 가능하면 신규 금지. 아래 5건은 전수 확인 후 **표현 불가**로 판정된 갭. 자재/공정/옵션 같은 차원 코드는 신규 mint 금지(round-trip echo만) — 추가는 **표시 메타·라우팅 메타**에 한정.

## 1. 추가 컬럼 5건 (테이블 4개·기초코드 2그룹)

| # | 대상 | 추가 | 타입 | 위젯 계약 필드 | 사유(부재 확인) |
|---|------|------|------|----------------|------------------|
| 1a | t_mat_materials | `color_hex` | varchar(7) | `OptionValue.colorHex` | mat 17컬럼·자재 어디에도 hex 없음. color-chip 렌더 불가 |
| 1b | t_mat_materials | `image_url` | varchar(500) | `OptionValue.imageUrl` | 이미지 URL 컬럼 전무. image-chip 렌더 불가 |
| 1c | t_mat_materials | `add_clr_yn` | char(1) | `OptionValue.addColorCapable` / `NormalizedPriceRequest.addColorCapable` | 별색/형광 가용 플래그 부재(N1 추가색 게이트) |
| 2 | t_prd_product_options | `badge_cd` | varchar(50) FK | `OptionValue.badge` | options.tags(jsonb) 비표준 → 4값 enum 신뢰 불가 |
| 3 | t_prd_products | `editor_partner_cd` | varchar(50) FK | `NormalizedEditorConfig`(발급 라우팅) | editor_yn(boolean)만 — 어느 에디터인지 분기 불가 |
| 4 | t_prd_product_processes | `view_yn` | char(1) | `OptionGroup.visible`(hidden-essential) | mand_proc_yn(required)만 — visible 없음(현재 disp_seq<0 관례 우회) |

기초코드 신규: `BADGE_TYPE`(.01~.04 recommend/best/new/up) · `EDITOR_PARTNER`(.01 edicus / .99 none).

## 2. 컬럼별 상세 사유 + 영향분석

### 1. t_mat_materials.{color_hex, image_url, add_clr_yn}
- **위함**: color-chip/image-chip componentType은 자재 값에 hex/이미지가 있어야 렌더된다. 디지털인쇄 파일럿(PRD_000041)은 용지 select-box라 영향 0이나, 색지·악세서리·가죽(MAT_TYPE 가죽/악세사리) 상품은 색상칩/이미지칩 필수. add_clr_yn은 별색/형광 추가색 게이트(INV-1).
- **영향**: 신규 NULLABLE 3컬럼. FK 없음. 기존 609 자재행 영향 0(NULL=hex/이미지 없음→기본 select-box 유지). 어댑터는 NULL이면 colorHex/imageUrl 미주입.
- **백필**: 색지/특수자재만 점진 백필(운영자 admin). 미백필=기존 동작.

### 2. t_prd_product_options.badge_cd (FK BADGE_TYPE)
- **위함**: `OptionValue.badge`(recommend/best/new/up). 추천/베스트 배지 UI.
- **영향**: 상품별 옵션 단위(554행) NULLABLE. FK→t_cod_base_codes. BADGE_TYPE 기초코드 선행 INSERT 필요(FK 위상).
- **백필**: 운영자 임의. 미설정=배지 없음.
- **대안 검토**: tags jsonb 재사용 → enum 미강제·위젯 신뢰 불가로 기각.

### 3. t_prd_products.editor_partner_cd (FK EDITOR_PARTNER)
- **위함**: `NormalizedEditorConfig` 발급 라우팅(Edicus psCode/templateUrl/resourceId/token). DB는 partner 분기만(psCode/token은 BFF 런타임 발급·보안상 DB 비보관).
- **영향**: 284 상품 NULLABLE. editor_yn='Y'인 상품만 partner 설정. NULL+editor_yn='Y'=EDITOR_PARTNER.01(edicus) fallback 가능.
- **분류**: 일부 (A) 어댑터 흡수 가능(editor_yn='Y'면 edicus 단정) — 그러나 다중 에디터 대비 명시 컬럼 권고. → gaps (B)/(C) 경계.

### 4. t_prd_product_processes.view_yn
- **위함**: hidden-essential 공정(PROC_000004 인쇄 base 등 mand=Y·비표시·자동적용)을 `OptionGroup.visible=false`로 명시.
- **영향**: 312 공정행 NULLABLE. NULL=disp_seq<0 관례 fallback(어댑터 흡수)이라 **비파괴**. N=명시 hidden.
- **분류**: (A) 어댑터가 disp_seq<0 관례로 흡수 가능 — 명시 컬럼은 안전성 향상용 권고(필수 아님).

## 3. 추가하지 않은 것 (갭이나 스키마 미추가)

- **위젯 세션/장바구니/주문 테이블**: 커머스 바인딩 UNDECIDED(data-contract §6 HARD). 추가하지 않고 `gaps-and-recommendations.md` (C)로만 표기.
- **Edicus psCode/templateUrl/token 컬럼**: BFF 런타임 발급·보안상 DB 비보관. 추가 금지.
- **NormalizedOrderReadiness 테이블**: 서버 doc 검수 로직 — 위젯 스코프 밖.

## 4. 적용 순서·멱등·비밀값

1. 기초코드 INSERT(BADGE_TYPE·EDITOR_PARTNER) → 2. ALTER ADD COLUMN(IF NOT EXISTS) → 3. 점진 백필(운영자) → 4. §7 검증.
- 멱등: ADD COLUMN IF NOT EXISTS · INSERT ON CONFLICT DO NOTHING.
- 전 컬럼 NULLABLE → 백필 무중단·기존 evaluate_price/위젯 동작 불변.
- 비밀값(JWT/token/자격) DDL·명세에 평문 없음.

## 5. 인간 승인 게이트

본 DDL은 **제안**이다. 실 COMMIT은 §7 huni-dbmap 적재 트랙(dbm-load-execution·인간 승인) 위임. webadmin 코드 직접수정 금지.
