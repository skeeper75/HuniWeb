# vessel-design-input-channel (V-10, #16 디자인 입력 채널) — GAP ❌ → 그릇 설계

> rpm-vessel-designer. RP `DesignInputChannel`(에디터 채널 + 입력방식 + 디자인수 산정 + VDP 게이팅)을
> 후니가 표현할 **최소 convention-fit 그릇**. ★TP directive 1순위.
> 권위 = 라이브 read-only information_schema 실측(2026-06-17·본 세션 직접 측정). design ≠ apply.
> **버전:** v3.0 (TP 신축). BN/GS 무관(직교 축·본체 옵션과 독립).

## 0. 한 줄 평결
**#16 디자인 입력 채널 = vessel-gap 확정**(라이브 `t_prd_products`에 `editor_yn`·`file_upload_yn` 불리언 2개뿐·전역 컬럼/테이블/base_code 검색 0건). 최소 그릇 = **`DESIGN_INPUT_CHANNEL` base_code 그룹 1 + `t_prd_products`에 NULL 컬럼 4개**(`design_input_channel_cd`·`editor_kind_cd`·`ord_cnt_source_cd`·`vdp_yn`). **신규 테이블 mint = 0**(채널은 상품 1:1 속성 — 종속 테이블 부적격). VDP는 `vdp_yn` 플래그 1개로 게이트만(변수 스키마 본문은 후니 미관측 → 그릇 신설 보류·open decision). 위젯 정규화 계약과 정합: 이 4컬럼이 huni-widget Edicus/KOI 어댑터가 *읽어 채울 슬롯*(어댑터는 DB 아닌 계약 의존이나, 채널 메타는 DB가 권위로 제공).

## 1. search-before-mint (라이브 실측 — 결정적)

### 1.1 후니 현황 (information_schema 직접 SELECT 2026-06-17)
`t_prd_products` 전 컬럼 실측 — 디자인 입력 관련:
```
file_upload_yn  CHAR(1) NOT NULL  CHECK (∈ Y/N)   -- PDF 업로드 허용 여부
editor_yn       CHAR(1) NOT NULL  CHECK (∈ Y/N)   -- 에디터 사용 여부
```
- `editor_yn`/`file_upload_yn` 분포(use_yn=Y): **Y/Y=104·Y/N=3·N/Y=91·N/N=49**(editor_yn=Y 107상품).
- 전역 검색(editor/koi/edicus/vdp/item_gbn/channel/resource/asset/template/variable):
  `editor_yn`·`file_upload_yn` + `tmpl_cd` 계열만 매치. **에디터 *종류*·채널 *타입*·템플릿 리소스·VDP 컬럼 0건.**
- `t_cod_base_codes` 16 그룹(CUS_GRADE/DSC_TYPE/MAT_TYPE/OPT_REF_DIM/OUTPUT_PAPER_TYPE/PRC_COMPONENT_TYPE/PRD_TYPE/PRICE_TYPE/QTY_UNIT/RULE_TYPE/SEL_TYPE/SEMI_ROLE/USAGE + TEST*3): **에디터 채널 enum 그룹 부재.**

### 1.2 기존 그릇으로 무손실 표현 불가 증명 (불리언 2개의 환원 한계)
RP 디자인 입력 신호 vs `editor_yn`+`file_upload_yn` 2-불리언(4분포)의 환원 가능성:

| RP 신호 | 의미 | 2-불리언으로 환원? |
|---|---|:--:|
| `item_gbn` (vDigital_item / edicus_item / offset2023_item) | 처리 채널 3분기 | ❌ **불가** — KOI(vDigital)·Edicus 둘 다 editor_yn=Y·file_upload_yn 무관 → 같은 Y/Y 셀에 *두 채널이 충돌*. offset2023(N/Y)는 PDF전용과 구별 안 됨. 3값을 2-불리언(4셀)이 분해 못함. |
| 에디터 종류 (KOI vs Edicus vs RP) | useKoiEditor/useRPEditor | ❌ **불가** — editor_yn=Y가 *어느 에디터*인지 0정보. KOI·Edicus·RP 3종이 단일 Y로 평면화. |
| `useTemplateDownload` (기성 시안 갤러리) | TemplateAsset 노출 게이트 | ❌ **불가** — 불리언에 슬롯 없음. (→ V-11 TemplateAsset 그릇·아래) |
| `koi_template_resource_id` (템플릿 리소스 포인터) | 에디터 로드 시안 ID | ❌ **불가** — 포인터 컬럼 부재. |
| `ord_cnt_source` (usePDFordCnt / useEditorOrdCnt) | 디자인수 산정 출처(수량모델#10 게이팅) | ❌ **불가** — file_upload_yn=Y가 *PDF가 ord_cnt 출처인지*까지 담지 못함(업로드 허용 ≠ 건수 출처). |
| `vdp_capable` (가변데이터 가능) | 명함/상장 VDP | ❌ **불가** — 그릇 없음. |

**4분포 셀의 의미 충돌(결정적):** Y/Y 셀 104상품에 **KOI 에디터 + PDF 병행(TPTKDFT 동형)** 과 **Edicus SDK(TPBCDFT 동형)** 가 *섞여* 있다 — 같은 `editor_yn=Y·file_upload_yn=Y`로 표현되나 채널이 다르다. 즉 2-불리언은 *에디터 사용 여부*만 표현하고 **채널 3분기·에디터 종류·리소스·VDP·ord_cnt 출처 5개 의미축을 전부 drop**한다. → 무손실 표현 불가 = **GAP 확정**(빈 테이블 아님·스키마가 축을 표현 못함 = vessel-gap).

### 1.3 사다리 검토 (코드행 < 컬럼 < JSONB < 테이블)
| 후보 | 충분? | 판정 |
|---|:--:|---|
| **① base_code enum만**(채널 타입 분류) | △ | 채널 *분류*는 코드행으로 잡으나, 상품-채널 *인스턴스 연결*(어느 상품이 어느 채널)을 코드행이 못 함 → 컬럼 필요. **코드행은 필요조건이나 불충분**(form-assembly PROC_CLASS와 동형 논리). |
| **② 컬럼 N개**(상품 1:1 속성) | ✅ | 채널·에디터종류·ord_cnt출처·vdp가 **상품당 단일값**(1상품 1입력구성·메타모델 §16 "1상품 1입력구성") → 상품 컬럼이 정규 슬롯. 4컬럼 NULL = 백필 0·무잠금. **채택.** |
| **③ JSONB 1개**(`design_input_json`) | ✗ | 4값이 *정형·열거형*(enum FK 거버넌스 필요·조회/필터 대상)이라 jsonb는 enum 무결성·조인 상실. 후니 jsonb 관용(logic·prcs_dtl_opt)은 *가변 파라미터*용 — 정형 enum엔 컬럼이 컨벤션. **부적격.** |
| **④ 신규 테이블**(`t_prd_design_input_channels`) | ✗ | 채널이 상품과 **1:1**(다대일/반복그룹/독립 lifecycle 아님) → 종속 테이블 정당화 실패. **over-modeling·mint 거부.** (단 TemplateAsset 시안 카탈로그는 1:N·독립 → 별 테이블 = V-11, 본 채널과 분리) |

**결론:** 사다리 = **① base_code 그룹 1 + ② 상품 컬럼 4개**(②에서 멈춤). 신규 테이블 0. VDP 본문 스키마(`setVariableData` 변수 필드)는 후니 미관측(`koiOption[]` 빈배열·로그인 에디터 필요) → `vdp_yn` 게이트만 두고 변수 스키마 테이블은 **관측 후 판정**(과잉 모델 경계·open decision §6.2).

## 2. 그릇 설계 (최소 — 코드행 1그룹 + 컬럼 4)

### 2.1 채널/에디터 enum 축 — `t_cod_base_codes` 신규 그룹 2개 (코드행, 사다리 최저단)
RedPrinting *모델*만 흡수, *naming/codes*는 후니 컨벤션 코드로(item_gbn → DESIGN_INPUT_CHANNEL.NN). 라이브 코드그룹 컨벤션(부모 `upr_cod_cd=NULL` + 자식 `<GROUP>.NN`·disp_seq) 그대로.

```sql
-- 그룹 A: 디자인 입력 채널(처리 타입 = RP item_gbn 흡수, 후니 코드로)
INSERT INTO t_cod_base_codes (cod_cd, cod_nm, upr_cod_cd, disp_seq, use_yn, del_yn, reg_dt) VALUES
 ('DESIGN_INPUT_CHANNEL',    '디자인입력채널',  NULL,                   1, 'Y','N', now()),
 ('DESIGN_INPUT_CHANNEL.01', '웹에디터',        'DESIGN_INPUT_CHANNEL', 1, 'Y','N', now()),  -- vDigital/edicus (에디터 종류는 editor_kind_cd로 세분)
 ('DESIGN_INPUT_CHANNEL.02', '파일업로드',      'DESIGN_INPUT_CHANNEL', 2, 'Y','N', now()),  -- offset2023 PDF 전용
 ('DESIGN_INPUT_CHANNEL.03', '에디터+업로드',   'DESIGN_INPUT_CHANNEL', 3, 'Y','N', now());  -- 병행(TPTKDFT KOI+PDF)
-- 그룹 B: 에디터 종류(에디터 채널일 때 어느 SDK)
INSERT INTO t_cod_base_codes (cod_cd, cod_nm, upr_cod_cd, disp_seq, use_yn, del_yn, reg_dt) VALUES
 ('EDITOR_KIND',    '에디터종류',  NULL,          1, 'Y','N', now()),
 ('EDITOR_KIND.01', 'KOI',        'EDITOR_KIND', 1, 'Y','N', now()),  -- vDigital_item
 ('EDITOR_KIND.02', 'Edicus',     'EDITOR_KIND', 2, 'Y','N', now()),  -- edicus_item·VDP 지원
 ('EDITOR_KIND.03', 'RedEditor',  'EDITOR_KIND', 3, 'Y','N', now());  -- 자체(useRPEditor)
-- 그룹 C: 디자인수(건수) 산정 출처(수량모델#10 ORD_CNT 게이팅)
INSERT INTO t_cod_base_codes (cod_cd, cod_nm, upr_cod_cd, disp_seq, use_yn, del_yn, reg_dt) VALUES
 ('ORD_CNT_SOURCE',    '디자인수산정출처', NULL,             1, 'Y','N', now()),
 ('ORD_CNT_SOURCE.01', '에디터',          'ORD_CNT_SOURCE', 1, 'Y','N', now()),  -- useEditorOrdCnt
 ('ORD_CNT_SOURCE.02', '업로드파일',      'ORD_CNT_SOURCE', 2, 'Y','N', now());  -- usePDFordCnt
```
- ★`editor_yn`/`file_upload_yn`(불리언) **기존 유지**(107상품 적재값 무파손) — 신규 채널 컬럼은 *세분 보강*(대체 아님). `editor_yn=Y` ⇔ `design_input_channel_cd ∈ {.01,.03}`로 일관(백필 규칙 §3).

### 2.2 상품에 채널 매다는 슬롯 — `t_prd_products` 컬럼 4개 (ADD COLUMN NULL)
```sql
ALTER TABLE t_prd_products ADD COLUMN design_input_channel_cd varchar NULL;  -- → DESIGN_INPUT_CHANNEL.*
ALTER TABLE t_prd_products ADD COLUMN editor_kind_cd           varchar NULL;  -- → EDITOR_KIND.* (채널=웹에디터/병행일 때만)
ALTER TABLE t_prd_products ADD COLUMN ord_cnt_source_cd        varchar NULL;  -- → ORD_CNT_SOURCE.* (수량모델#10 게이팅)
ALTER TABLE t_prd_products ADD COLUMN vdp_yn  CHAR(1) NULL;                    -- 가변데이터 가능 Y/N (명함/상장)
-- FK 3개 → t_cod_base_codes(cod_cd). vdp_yn은 CHECK(∈Y/N) (nonspec_yn/editor_yn 동형).
```
- ★`vdp_yn`은 기존 `*_yn CHAR(1) CHECK` 컨벤션 추종하되 **NULL 허용**(기존 107상품 백필 전까지 미설정) — 단 NOT NULL 강제는 백필 후 별 마이그(over-reach 경계).

## 3. 정규화 / 영향분석

### 3.1 정규화
- **무손실:** 채널 분류=DESIGN_INPUT_CHANNEL 코드·에디터 종류=EDITOR_KIND 코드·ord_cnt 출처=ORD_CNT_SOURCE 코드·VDP 게이트=vdp_yn — RP 5 의미축이 각기 다른 정규 슬롯에(2-불리언 평면화 해소). 채널·에디터종류·ord_cnt·vdp가 서로 다른 함수종속.
- **무중복:** enum=분류 메타·컬럼=상품 인스턴스값 — 이중저장 없음. `editor_yn`(거친 불리언)과 `design_input_channel_cd`(세분) 공존은 *환원 가능 파생*이라 정합 규칙(§3.2)으로 무결성 보장(중복 아닌 보강·롤아웃 후 editor_yn 폐기 검토는 open decision).
- **함수종속:** prd_cd → {design_input_channel_cd, editor_kind_cd, ord_cnt_source_cd, vdp_yn} 완전종속(1상품 1입력구성). 부분/이행 신설 0. (editor_kind_cd는 channel=웹에디터/병행일 때만 NOT NULL — 조건부 종속, V-4 essential 제약로 거버넌스 가능)

### 3.2 영향 (기존 행·FK·백필·적용순서·롤백)
- **기존 행:** 컬럼 4개 전부 **ADD COLUMN NULL** = 백필 0·무잠금(메타데이터 변경). 라이브 275상품·107 editor_yn=Y **무파손**.
- **FK:** 신규 FK 3(design_input_channel_cd·editor_kind_cd·ord_cnt_source_cd → base_codes). 부모(t_cod_base_codes) 선존재 → 고아 0. vdp_yn은 CHECK만.
- **백필(data·dbmap 트랙):** 기존 107 editor_yn=Y 상품에 채널 부여 —
  `editor_yn='Y'·file_upload_yn='N'`(3행)→`.01 웹에디터` / `Y·Y`(104행)→`.03 에디터+업로드`(또는 `.01`, 채널 실측 후) / `N·Y`(91행)→`.02 파일업로드` / `N·N`(49행)→채널 NULL(또는 별도 분류). **에디터 종류(KOI/Edicus)는 상품별 RP item_gbn 실측 필요**(라이브 미보유 → huni-widget 캡처·dbmap 적재). → ★백필 자체는 vessel 아님(dbmap round-6/TP 적재 트랙). 단 정합 규칙 `editor_yn='Y' ⇒ channel∈{.01,.03}` 강제.
- **적용 순서:**
  1. step -1: base_code 그룹 3 + 코드행(코드행 선적재·후니 승인)
  2. step 0: 본 DDL(ALTER ADD COLUMN ×4 + FK ×3) ← 인간 승인 후
  3. step 1: 백필 UPDATE(채널·ord_cnt·vdp — dbmap 적재 트랙·에디터종류는 RP 실측 후)
- **롤백:** `DROP COLUMN ×4`(백필값 백업 권고) + 코드행 use_yn='N'. 무위험(NULL 컬럼).
- **★editor_yn 정합(HARD):** 신규 채널 컬럼은 기존 불리언 *대체 아님·보강*. 롤아웃 중 두 표현 공존 — 정합 규칙으로 무결성. editor_yn 폐기 여부는 위젯/앱 의존성 조사 후(open decision §6.1).

## 4. 닫는 것 (WEAK/GAP → PASS)
- #16 디자인 입력 채널: gap-matrix **GAP** → 본 그릇으로 **PASS**. RP `item_gbn` 3분기·에디터 종류·ord_cnt 출처·VDP 게이트를 후니 코드행+컬럼으로 무손실 흡수. (VDP *변수 스키마 본문*은 게이트만·본문은 미관측 보류 → 부분 PASS·관측 후 완결)
- **unblock:** TP 23상품(디자인명함·티켓·캘린더·북·평면지류) + 전 카테고리 editor_yn=Y 107상품. huni-widget Edicus/KOI 어댑터가 읽을 입력채널 메타 = 위젯-DB 경계 1급. MES 생산팀 라우팅(채널별 입력물 처리)에도 연결.

## 5. 위젯 정규화 계약과의 정합 (HARD — directive 명시 요구)
- **원칙([[huni-widget-conversion-strategy]]):** huni-widget은 **DB가 아닌 정규화 계약**에 의존 — Edicus/KOI 어댑터가 RedEditorSDK 45메서드·editor-bridge-protocol(cmd create-design-project·editor_type/run_mode) *코드 계약*으로 에디터를 구동한다. 위젯 코드는 DB 그릇 신설로 **불변**.
- **그릇의 역할 = 어댑터가 채울/읽을 슬롯:** 본 4컬럼은 위젯 런타임 계약을 *대체하지 않는다*. 위젯은 "이 상품이 어느 에디터·VDP 가능·ord_cnt 출처인가"를 **DB(채널 메타)에서 읽어** 어댑터에 전달(editor_type=editor_kind_cd 매핑·run_mode=ord_cnt_source 연동·openVdpViewer 게이트=vdp_yn). 즉 그릇은 **계약의 입력 파라미터 원천**.
  - `design_input_channel_cd`/`editor_kind_cd` → 어댑터 `editor_type`(KOI/Edicus 분기) 선택.
  - `vdp_yn` → 어댑터 `openVdpViewer`/`setVariableData` 활성 게이트.
  - `ord_cnt_source_cd` → 디자인수(ORD_CNT) 산정 출처(수량모델#10) — 가격/수량 계약 입력.
- **정합 보장:** 그릇이 *없으면* 위젯이 채널을 앱 하드코딩(상품코드 목록)해야 함 = 컨버전 시 후니 상품마다 분기 재작성. 그릇이 *있으면* 어댑터가 DB 메타로 데이터-드리븐 → 위젯 코어 불변·무손실 컨버전([[huni-widget-conversion-strategy]] 원칙 준수). **DB 그릇 ⊥ 위젯 코드 계약**(직교·상보) — 충돌 없음.

## 6. open decision (날조 금지·인간 결정)
1. **editor_yn 운명:** 신규 `design_input_channel_cd` 롤아웃 후 `editor_yn`(거친 불리언) **유지 vs 폐기.** 위젯·admin·기존 쿼리 의존성 조사 필요 — 본 그릇은 *공존+정합 규칙*으로 안전, 폐기는 별 마이그(인간 결정).
2. **VDP 변수 스키마 본문:** `vdp_yn` 게이트만 설계. VDP *변수 필드 정의*(명함 이름/직함·상장 수상자)는 후니 미관측(`koiOption[]` 빈배열·로그인 에디터 필요). 관측 후 ① `t_prd_products`에 추가 컬럼 불가(가변 N필드·상품별 상이) ② **jsonb `vdp_schema_json`** or ③ **종속 테이블 `t_prd_product_vdp_fields`**(1:N·진짜 반복그룹) 중 판정 — 변수 필드가 *상품별 가변 반복그룹*이면 ③이 정답(이때만 신규 테이블 정당). **관측 전 그릇 신설 금지**(over-modeling).
3. **에디터 종류 백필 출처:** RP item_gbn(KOI/Edicus 분기)은 라이브 미보유 — huni-widget 캡처(`s6` 등)·후니 실제 에디터 운영 정책이 권위. 후니가 Edicus 단일이면 EDITOR_KIND.02 고정·컬럼 불요 가능(과잉 모델 경계). **후니 에디터 채널 운영 결정 필요.**
4. **채널 컬럼 vs 인쇄방식(#12) 결합 금지:** 입력채널(주문측 UX) ≠ 인쇄방식(생산측 게이팅)·메타모델 §16 경계. V-2(인쇄방식)와 *상관하나 별 축* — 한 컬럼 통합 금지.
5. 실 적용 = 인간 승인 + dbmap 적재 트랙.

## 7. DDL 위임
- 코드행(DESIGN_INPUT_CHANNEL·EDITOR_KIND·ORD_CNT_SOURCE) + ALTER(ADD COLUMN ×4·FK ×3) 정밀 SQL = `dbm-ddl-proposer`(코드그룹 패턴 + `ref-param-json-proposal` ADD COLUMN NULL+FK 동형). 본 문서 §2가 설계 권위(which/why), 정밀 forward/rollback/순서 SQL은 ddl-proposer 산출 인용.
- ★reg_dt NOT NULL DEFAULT now() 트랩 준수(라이브 t_cod_base_codes·t_prd_products reg_dt NOT NULL — INSERT 시 명시 또는 DEFAULT). round-5 교훈 반영.
