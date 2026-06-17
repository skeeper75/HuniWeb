# vessel-template-asset (V-11, #4↔#16 이중의미·TemplateAsset 분리) — WEAK 🟡 → 그릇 설계

> rpm-vessel-designer. TP "디자인 시안"(에디터가 로드하는 가격0 템플릿 리소스)을
> 완제SKU 템플릿(`t_prd_templates`)과 **별 엔티티로 분리**하는 그릇. V-10 종속(에디터 채널 #16).
> 권위 = 라이브 read-only 실측(2026-06-17). design ≠ apply.
> **버전:** v3.0 (TP 신축·V-10 종속). BN/GS 무관.

## 0. 한 줄 평결
**TemplateAsset = 신규 테이블 1개 mint 정당**(`t_prd_template_assets` + 상품 링크 `t_prd_product_template_assets`). 이유: 디자인 시안은 **상품당 N개(1:N)·독립 lifecycle(시안 카탈로그가 상품과 별개로 추가/폐기)·가격0**의 *반복그룹* — 컬럼/jsonb로 환원 불가. **★`t_prd_templates`(완제SKU·봉투 OTC 12행) 흡수 절대 금지**(이중의미 오염: 가격0 디자인 리소스를 주문단위 SKU로 오모델 = `dbmap-schema-design-intent-first` "카드봉투 색=siz" 동형 위험). 본 vessel은 **V-10의 5번째 사다리(④ 신규 테이블)** — 채널은 1:1이라 컬럼에서 멈췄으나, *시안 자산*은 1:N이라 테이블이 정답. dictionary #4 [HARD] "디자인 시안을 완제SKU에 적재 금지"의 그릇 구현.

## 1. search-before-mint (라이브 실측 — 이중의미 분리)

### 1.1 후니 `t_prd_templates` 실측 = 완제SKU(디자인 시안 아님)
라이브 컬럼(2026-06-17): `tmpl_cd·base_prd_cd·tmpl_nm·dflt_qty·use_yn·del_yn·note·reg_dt·upd_dt·tags·usr_def_cd·usr_def_nm`. 12행 전수 = **완제SKU/OTC 번들**:
```
봉투(700x200) 50 · 카드봉투(블랙) 165x115 50장 · OPP접착봉투 · 트레싱지봉투 …
```
- 전부 **봉투류 완제 주문단위**(`base_prd_cd`→products·`dflt_qty`=주문수량·`tmpl_nm`=수량포함 SKU명). 개당가 = `t_prd_template_prices`(tmpl_cd·apply_ymd·unit_price). → `t_prd_templates`는 *주문 가능 완제 SKU* 그릇이지 *디자인 시안 카탈로그*가 아니다.

### 1.2 TP "템플릿"(디자인 시안)은 의미가 다름 (이중의미)
RP TP 관측: `useTemplateDownload=Y`·`koi_template_resource_id`·SDK `getTemplateList`/`setCurrentTemplate` = **에디터가 런타임에 별도 카탈로그에서 로드하는 디자인 시안**(가격0·인쇄/자재가 가격 주체·TPCLWLB 실측 PRICE=PRT_DFT 11900·템플릿 PCS=0). dictionary #4: 완제SKU(`Template`) vs 디자인 자산(`TemplateAsset`) = **같은 단어 다른 의미·별 엔티티**.

| 항목 | `t_prd_templates`(완제SKU·#4) | TemplateAsset(디자인 시안·#16 종속) |
|---|---|---|
| 정체 | 주문 가능 완제 단위(봉투 50장) | 에디터 로드 디자인 시안(가격0) |
| 가격 | `template_prices` 개당가 보유 | **0**(인쇄/자재가 가격) |
| 식별 | base_prd_cd→상품·dflt_qty | template_resource_id(KOI 리소스) |
| 카디널리티 | 상품 1:1~소수 OTC | 상품 1:**N**(시안 갤러리) |
| lifecycle | 주문 SKU(안정) | 시안 추가/교체 빈번(독립) |

### 1.3 사다리 검토 — 왜 컬럼/jsonb 불가, 테이블만 정답
| 후보 | 충분? | 판정 |
|---|:--:|---|
| `t_prd_products.template_resource_id` 컬럼 1개 | ✗ | 상품당 **시안 N개**(갤러리) → 단일 컬럼 1:1 가정 붕괴. |
| jsonb `template_assets_json`(시안 배열) | ✗ | 시안이 *조회/필터/개별 참조 대상*(에디터 getTemplateList·개별 resource_id 바인딩)·N행 → jsonb 배열은 개별 FK·조인·무결성 상실. 후니 jsonb 관용(가변 파라미터)과 용도 불일치. |
| **`t_prd_templates` 컬럼 추가**(price=0 플래그 등) | ✗✗ | **★이중의미 오염**(HARD 금지) — 완제SKU 순수성 파괴(`base_prd_cd`·`template_prices` 의미 충돌). dictionary #4 명시 금지·`dbmap-schema-design-intent-first` 위험. |
| **신규 테이블** `t_prd_template_assets`(+링크) | ✅ | 1:N·독립 lifecycle·가격0·완제SKU와 의미 분리 = **진짜 반복그룹/독립 엔티티** → mint 정당(사다리 4단계 도달). **채택.** |

**결론:** 본 하네스 전체에서 **유일한 신규 테이블 mint**(BN/GS 0·V-10 0). 정당화: 디자인 시안의 1:N·독립 lifecycle·이중의미 분리가 컬럼/jsonb/기존테이블 어느 것도 무손실 못 담음. over-modeling 아님(최소 2테이블: 자산 마스터 + 상품 링크, goods-pouch nonspec 선례 동형).

## 2. 그릇 설계 (신규 테이블 2 — 자산 마스터 + 상품 링크)

### 2.1 디자인 시안 자산 마스터 — `t_prd_template_assets`
```sql
CREATE TABLE IF NOT EXISTS t_prd_template_assets (
  tmpl_asset_cd        VARCHAR(50)  NOT NULL,            -- PK, TASSET_NNNNNN
  tmpl_asset_nm        VARCHAR(200) NOT NULL,            -- 시안 이름
  editor_kind_cd       VARCHAR(50),                      -- → t_cod_base_codes(EDITOR_KIND.*) (V-10): KOI/Edicus/RP
  template_resource_id VARCHAR(200),                     -- 에디터 리소스 포인터(RP koi_template_resource_id). NULL=미바인딩
  asset_options_json   JSONB,                            -- 시안 옵션(RP koiOption[]). 가변 → jsonb 정당
  vdp_yn               CHAR(1) NOT NULL DEFAULT 'N',     -- 이 시안이 VDP 변수 슬롯 보유(명함/상장)
  note                 VARCHAR(500),
  use_yn               CHAR(1) NOT NULL DEFAULT 'Y',
  del_yn               CHAR(1) NOT NULL DEFAULT 'N',
  del_dt               TIMESTAMP WITHOUT TIME ZONE,
  reg_dt               TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now(),
  upd_dt               TIMESTAMP WITHOUT TIME ZONE,
  CONSTRAINT pk_t_prd_template_assets       PRIMARY KEY (tmpl_asset_cd),
  CONSTRAINT ck_t_prd_tmpl_asset_use_yn     CHECK (use_yn IN ('Y','N')),
  CONSTRAINT ck_t_prd_tmpl_asset_del_yn     CHECK (del_yn IN ('Y','N')),
  CONSTRAINT ck_t_prd_tmpl_asset_vdp_yn     CHECK (vdp_yn IN ('Y','N')),
  CONSTRAINT fk_t_prd_tmpl_asset_editor_cd  FOREIGN KEY (editor_kind_cd)
             REFERENCES t_cod_base_codes (cod_cd)
);
-- ★가격 컬럼 없음 = 디자인 시안은 가격0(인쇄/자재가 가격 주체). 완제SKU와 구조 구별.
```
- ★`asset_options_json`만 jsonb(시안 옵션 = 가변·미정형 → jsonb 정당). 정형 enum(editor_kind)은 FK 컬럼.

### 2.2 상품↔시안 연결 — `t_prd_product_template_assets` (1:N)
```sql
CREATE TABLE IF NOT EXISTS t_prd_product_template_assets (
  prd_cd         VARCHAR(50) NOT NULL,                   -- → t_prd_products
  tmpl_asset_cd  VARCHAR(50) NOT NULL,                   -- → t_prd_template_assets
  dflt_yn        CHAR(1) NOT NULL DEFAULT 'N',           -- 기본 노출 시안
  disp_seq       INTEGER,                                -- 갤러리 노출순
  reg_dt         TIMESTAMP WITHOUT TIME ZONE NOT NULL DEFAULT now(),
  upd_dt         TIMESTAMP WITHOUT TIME ZONE,
  del_yn         CHAR(1) NOT NULL DEFAULT 'N',
  del_dt         TIMESTAMP WITHOUT TIME ZONE,
  CONSTRAINT pk_t_prd_product_template_assets  PRIMARY KEY (prd_cd, tmpl_asset_cd),
  CONSTRAINT ck_t_prd_prd_tasset_dflt_yn       CHECK (dflt_yn IN ('Y','N')),
  CONSTRAINT ck_t_prd_prd_tasset_del_yn        CHECK (del_yn  IN ('Y','N')),
  CONSTRAINT fk_t_prd_prd_tasset_prd_cd        FOREIGN KEY (prd_cd)
             REFERENCES t_prd_products (prd_cd),
  CONSTRAINT fk_t_prd_prd_tasset_asset_cd      FOREIGN KEY (tmpl_asset_cd)
             REFERENCES t_prd_template_assets (tmpl_asset_cd)
);
```
- 완제SKU 링크(`t_prd_templates.base_prd_cd`)와 **평행 구조**(goods-pouch nonspec 선례 동형)·의미는 분리.

## 3. 정규화 / 영향분석
- **무손실:** 시안 정체=마스터·시안 옵션=asset_options_json·상품-시안 N링크=링크테이블·에디터 종류=EDITOR_KIND FK(V-10 공유)·VDP=vdp_yn. RP `koi_template_resource_id`+`koiOption[]`+갤러리(getTemplateList) 무손실.
- **무중복:** 완제SKU(`t_prd_templates`)와 **물리 분리** → 이중의미 오염 0. 시안은 자산 테이블, SKU는 templates — 단일 사실 단일 위치.
- **함수종속:** tmpl_asset_cd → 마스터 속성 완전종속. (prd_cd, tmpl_asset_cd) → 링크 속성. 부분/이행 신설 0.
- **영향(기존 행·FK·백필·순서·롤백):**
  - 기존 행: **신규 테이블** — 라이브 `t_prd_templates`(12행 봉투SKU)·`t_prd_template_prices`·products **무영향**. 완제SKU 순수성 보존(★핵심 목적).
  - FK: 부모(t_prd_products·t_cod_base_codes·t_prd_template_assets) 선존재 → 고아 0. EDITOR_KIND 코드행(V-10 §2.1) 선행 필요.
  - 백필: 없음(신규·시안 데이터는 후니 에디터 카탈로그 확정 후 적재 = data·dbmap). 발명 금지(시안 목록 = 후니 권위·로그인 에디터 미관측).
  - 적용 순서: ① EDITOR_KIND 코드행(V-10 §2.1·선행) → ② 본 DDL(CREATE ×2) → ③ 시안 마스터 행 → ④ 상품-시안 링크 행. **V-10 선행**(editor_kind_cd FK 의존).
  - 롤백: `DROP TABLE t_prd_product_template_assets; DROP TABLE t_prd_template_assets;`(무위험·신규).
- **load-bearing:** TP 디자인 시안 보유 상품(디자인명함·캘린더·상장)·use_template_download=Y 게이팅(V-10 채널). 시안 그릇 없으면 에디터가 런타임 SDK 카탈로그만 의존 → DB 시안 관리 불가(현 상태).

## 4. 닫는 것 (WEAK → PASS)
- T-A TemplateAsset(에디터 디자인 시안): gap-matrix **WEAK**(그릇 부재 + `t_prd_templates` 오염 위험 양면) → 본 그릇으로 **PASS**. ① 디자인 시안 전용 그릇 신설(부재 해소) ② `t_prd_templates`와 물리 분리(오염 위험 차단). dictionary #4 [HARD] 이중의미 분리 구현.
- **★완제SKU 오염 방지:** TP "템플릿"을 `t_prd_templates`에 적재하려던 위험을 그릇 분리로 봉쇄 — 봉투 OTC 12행 의미 보존.

## 5. V-10과의 관계 (종속)
- TemplateAsset은 **#16 디자인 입력 채널(V-10) 종속** — `use_template_download` 게이트(채널이 시안 갤러리 노출 결정)·`editor_kind_cd` FK 공유(V-10 §2.1 EDITOR_KIND). V-10 그릇이 *채널/에디터 종류*를 정의하고, 본 V-11이 *그 채널이 로드할 시안 카탈로그*를 보관. **FK 위상: V-10(EDITOR_KIND 코드행) 선행 → V-11(테이블).**
- 위젯 정합([[huni-widget-conversion-strategy]]): 어댑터 `getTemplateList`/`setCurrentTemplate`가 본 테이블에서 시안 목록을 읽어 에디터에 전달 — 시안 카탈로그의 DB 권위. 위젯 코어 불변(데이터-드리븐).

## 6. open decision
1. **시안 데이터 적재:** 시안 마스터 행(상품별 디자인 시안 목록)은 후니 에디터 카탈로그 확정 후(로그인 에디터·후니 운영 정책 권위). 본 vessel은 그릇만 — 시안 발명 금지.
2. **asset_options_json vs 정형 컬럼:** koiOption[] 미관측(빈배열) → jsonb 가변 슬롯으로 출발. 옵션 구조 관측 후 정형화 검토(과잉 정형 경계).
3. **VDP 변수 슬롯 위치:** `vdp_yn` 플래그는 본 테이블(시안 단위 VDP 여부). VDP *변수 필드 본문*은 V-10 §6.2 open decision(시안 종속 1:N이면 `t_prd_template_asset_vdp_fields` 추가 검토 — 관측 후).
4. 실 적용 = 인간 승인 + dbmap 적재 트랙.

## 7. DDL 위임
- CREATE TABLE ×2 정밀 SQL = `dbm-ddl-proposer`(`ddl-proposal-goods-pouch-nondim-size.sql` 마스터+링크 패턴 동형·reg_dt NOT NULL DEFAULT now() 트랩 준수). 본 §2가 설계 권위, forward/rollback/적용순서 SQL은 ddl-proposer 산출 인용.

## 8. AC facet 메모 (v7.0 — ACTPKEY 키링 템플릿 동형·신규 그릇 0)
> AC 갭 분석(`categories/AC/reverse.md`·`gap-matrix §XVII (부)`·`vessel-needs.md AC 흡수 매핑 (부)`). **AC distinct 신축 0 — 본 V-11 TemplateAsset에 새 그릇 수요 추가 없음(기존 그릇 흡수 확증).**
- **ACTPKEY(아크릴 키링 템플릿)가 #16 TemplateAsset(T-A)와 동형:** "아크릴 키링 템플릿"은 에디터 디자인 자산(가격0 디자인 시안)이지 완제 주문단위 SKU가 아님 → **`t_prd_templates`(봉투 OTC 12행 완제SKU) 적재 금지**(이중의미 분리 [HARD]·§4 완제SKU 오염 방지 동일). 본 §2 `t_prd_template_assets` 그릇이 ACTPKEY 키링 시안을 무손실 수용(channel FK→V-10·price=0). **신규 테이블/컬럼 0 — V-11이 이미 담음.** 이것이 17축 재포화의 TemplateAsset-side 증거: 7번째 카테고리(AC)가 디자인 자산 그릇에 새 수요를 더하지 않고 V-10/V-11 동형으로 흡수.
