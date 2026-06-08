# 미적재 갭 보드 — round-7 입체 커버리지

> 권위: `docs/goal-2026-06-08-01.md` C6. 모든 MISSING/PARTIAL/DB-ONLY 을 **차단유형 + 라우팅**으로
> 분류. over-report(허위 누락)·under-report(은폐) 0. 차단은 발명으로 닫지 않고 BLOCKED/GAP-DEFER.
> 셀 실측 근거: `coverage-cells.csv` · `db-coverage-raw.csv`. 필요요소 근거: `excel-requirements.csv`.

## 0. 차단유형 분류표 (skill §7)

| 차단유형 | 의미 | 라우팅 |
|---------|------|--------|
| DIM-UNLOADED | 참조 대상 차원행/공식 미적재 (L2 BLOCKED, 가격사슬 미적재) | L1 선적재 → `dbm-load-builder` / `dbm-price-formula` |
| MAPPING-DEFECT | 매핑 자체 결함/누락 | `dbm-mapping-designer` / `dbm-option-mapper` |
| CODE-ROW | 코드행(siz/proc/mat) 미적재 | 코드행 선적재 (인간 승인) |
| SIZ-REG | siz 미등록(신규 규격) | siz 등록 제안 |
| MAT-MINT | 자재 신규 채번 | `dbm-load-builder` mint |
| DDL-GAP | 스키마 부족 | `dbm-ddl-proposer` |
| DOMAIN-UNDECIDED | 도메인 의미 미결정 | 사용자 [CONFIRM] |
| OVER/EXT-LOAD | 엑셀 master 미요구이나 DB 행 존재 (외부 권위 적재 또는 과적재) | 권위 대조 후 분류 |

## 1. 집계 (총 209 셀)

| 상태 | 셀 수 | 비중 |
|------|------:|------|
| ✅ LOADED | 51 | 24% |
| 🟡 PARTIAL | 44 | 21% |
| ❌ MISSING | 49 | 23% |
| ◆ DB-ONLY | 17 | 8% |
| ➖ N/A | 48 | 23% |

**검증 대상(MISSING+PARTIAL+DB-ONLY) = 110 셀.** 아래에 전건 분류한다.

## 2. 최상위 갭 — CPQ 옵션 레이어 전면 미적재 (DIM-UNLOADED + MAPPING-DEFECT)

가장 큰 횡단 결함. **option_groups / options / option_items 가 거의 전 상품군에서 0행.**
이는 round-6 메모리("L2 전 상품 미적재")의 입체 확증이다.

| 상품군 | 엔티티 | 상태 | 상품 예시 | 증거(엑셀) | 차단유형 | 라우팅 | 인간승인 |
|--------|--------|------|----------|-----------|---------|--------|:---:|
| 디지털인쇄 | opt_groups/options/items | ❌ MISSING | PRD_000016 프리미엄엽서 | 별색인쇄(화이트/클리어/핑크/금/은)·코팅·후가공(모서리/오시/미싱/가변) 옵션 컬럼 | MAPPING-DEFECT | dbm-option-mapper | Y |
| 스티커 | opt_groups/options/items | ❌ MISSING | — | 별색인쇄(화이트)·조각수 옵션 | MAPPING-DEFECT | dbm-option-mapper | Y |
| 책자 | opt_groups/options/items | ❌ MISSING | — | 표지코팅·투명커버·제본방향/면지/링컬러/바인더링 옵션 | MAPPING-DEFECT | dbm-option-mapper | Y |
| 캘린더 | opt_groups/options/items | ❌ MISSING | PRD_000111 벽걸이캘린더(admin 옵션그룹 0 확증) | 캘린더가공(삼각대컬러/가공/링칼라) | MAPPING-DEFECT | dbm-option-mapper | Y |
| 디자인캘린더 | opt_groups/options/items | ❌ MISSING | — | 캘린더사양_캘린더가공 | MAPPING-DEFECT | dbm-option-mapper | Y |
| 실사 | opt_items | ❌ MISSING | PRD_000138 일반현수막 | 코팅·가공(오버로크/말아박기) — round-6 옵션그룹/옵션은 적재됐으나 **items 0(미완 사슬)** | DIM-UNLOADED | dbm-option-mapper | Y |
| 아크릴 | opt_groups/options/items | ❌ MISSING | — | 조각수·가공 옵션 | MAPPING-DEFECT | dbm-option-mapper | Y |
| 문구 | opt_groups/options/items | ❌ MISSING | — | 내지(옵션) | MAPPING-DEFECT | dbm-option-mapper | Y |
| 굿즈파우치 | opt_groups/options/items | ❌ MISSING | 머그컵 등 | 선택(옵션)·가공(옵션) — 옵션=자재+공정 BUNDLE([[dbmap-option-material-process-bundle]]) | MAPPING-DEFECT | dbm-option-mapper | Y |

> 핵심: 라이브 option_items 전역 **0행**(relationship-integrity R3). 실사·상품악세사리에 option_groups/options
> 만 존재(round-6 일반현수막 + OPP비접착봉투 파일럿)하나 items 가 없어 **CPQ 사슬 미완**. 옵션 레이어는
> round-6에서 설계·검증 GO 됐으나 **실 적재(COMMIT)는 인간 승인 대기** 상태 그대로다.

## 3. 가격 사슬 미적재 (DIM-UNLOADED)

price_formulas + component_prices 가 6 상품군에서 0행. 가격표 단가시트는 존재(권위)하나 미적재.

| 상품군 | 상태 | 증거 | 차단유형 | 라우팅 | 인간승인 |
|--------|------|------|---------|--------|:---:|
| 포토북 | ❌ MISSING (formula+comp) | 가격_기본(24P)·추가(2P)당 (가격포함 시트) | DIM-UNLOADED | dbm-price-formula | Y |
| 캘린더 | ❌ MISSING | 가격표 `제본`·`판걸이수` 권위 + 캘린더가공 추가가 | DIM-UNLOADED | dbm-price-formula | Y |
| 디자인캘린더 | ❌ MISSING | 가격포함 시트 inline 가격 | DIM-UNLOADED | dbm-price-formula | Y |
| 아크릴 | ❌ MISSING | 가격표 `아크릴`(면적매트릭스+구간할인) | DIM-UNLOADED | dbm-price-formula | Y |
| 굿즈파우치 | ❌ MISSING | 마스터 inline 가격(가격/선택가/가공가) | DIM-UNLOADED | dbm-price-formula | Y |
| 상품악세사리 | ❌ MISSING | 마스터 inline 가격 | DIM-UNLOADED | dbm-price-formula | Y |
| 디지털인쇄 | 🟡 PARTIAL 26/36 | 가격표 디지털인쇄비 (round-2 적재분) | DIM-UNLOADED(잔여) | dbm-price-formula | Y |
| 스티커 | 🟡 PARTIAL 4/16 | 가격표 스티커(7블록)·합판스티커 | DIM-UNLOADED(잔여) | dbm-price-formula | Y |
| 책자 | 🟡 PARTIAL 6/10 | 가격표 제본·엽서북떡메 | DIM-UNLOADED(잔여) | dbm-price-formula | Y |
| 문구 | 🟡 PARTIAL 1/11 | 가격포함 시트 | DIM-UNLOADED(잔여) | dbm-price-formula | Y |
| 실사 | ✅ LOADED 28/28 | 포스터사인 면적매트릭스([[dbmap-silsa-price-via-poster-sign]]) | — | — | — |

> 가격사슬 무결성은 PASS(끊김 0, relationship-integrity R4) — **적재된 공식은 전부 component_prices 로
> 해소**된다. 문제는 미적재 상품군의 공식이 아예 없다는 것(사슬 부재≠사슬 단절).

## 4. 차원 부분 적재 (PARTIAL — MAPPING-DEFECT 또는 CODE-ROW)

| 상품군 | 엔티티 | 상태 | 누락 상품수 | 차단유형 | 라우팅 |
|--------|--------|------|:---:|---------|--------|
| 디지털인쇄 | sizes | 🟡 33/36 | 3 | MAPPING-DEFECT/SIZ-REG | dbm-mapping-designer |
| 디지털인쇄 | print_options | 🟡 32/36 | 4 | MAPPING-DEFECT | dbm-mapping-designer |
| 디지털인쇄 | processes | 🟡 23/36 | 13 | MAPPING-DEFECT/CODE-ROW | dbm-mapping-designer |
| 디지털인쇄 | materials | 🟡 35/36 | 1 | MAPPING-DEFECT | dbm-mapping-designer |
| 아크릴 | sizes | 🟡 23/25 | 2 | SIZ-REG | dbm-load-builder |
| 아크릴 | processes | 🟡 14/25 | 11 | MAPPING-DEFECT | dbm-mapping-designer |
| 아크릴 | print_options | 🟡 21/25 | 4 | MAPPING-DEFECT | dbm-mapping-designer |
| 실사 | materials | 🟡 23/28 | 5 | MAT-MINT([[dbmap-option-material-process-bundle]]) | dbm-load-builder |
| 실사 | processes | 🟡 17/28 | 11 | MAPPING-DEFECT | dbm-mapping-designer |
| 굿즈파우치 | sizes | 🟡 11/98 | 87 | DOMAIN-UNDECIDED(기성품 비치수?) | 사용자 [CONFIRM] |
| 굿즈파우치 | processes | 🟡 6/98 | 92 | MAPPING-DEFECT | dbm-mapping-designer |
| 상품악세사리 | sizes | 🟡 7/15 | 8 | DOMAIN-UNDECIDED | 사용자 [CONFIRM] |
| 문구 | print_options | 🟡 7/11 | 4 | MAPPING-DEFECT | dbm-mapping-designer |
| 문구 | processes | 🟡 9/11 | 2 | MAPPING-DEFECT | dbm-mapping-designer |
| 책자/문구 | page_rules/sets | 🟡 부분 | — | MAPPING-DEFECT | dbm-mapping-designer |

> **굿즈파우치 sizes 87 미적재**가 가장 큰 단일 PARTIAL. admin 실측(PRD_000193 머그컵 사이즈 0)으로
> 확인 — 기성/원단 상품은 사이즈가 고정(비-configurable)일 가능성. **DOMAIN-UNDECIDED**: 엑셀 master
> '사이즈(필수)' 컬럼은 채워져 있으나(예: 머그컵 규격) DB는 size 차원으로 미적재 → "기성품 사이즈는
> 차원행인가 텍스트 표기인가" 도메인 결정 필요. 발명으로 닫지 않음.

## 5. 작은 단일 MISSING

| 상품군 | 엔티티 | 상태 | 증거 | 차단유형 | 라우팅 |
|--------|--------|------|------|---------|--------|
| 캘린더 | page_rules | ❌ MISSING | 장수(필수) | MAPPING-DEFECT | dbm-mapping-designer |
| 디자인캘린더 | page_rules | ❌ MISSING | 페이지사양 | MAPPING-DEFECT | dbm-mapping-designer |
| 캘린더 | bundle_qtys | ❌ MISSING | 개별포장(옵션) | MAPPING-DEFECT | dbm-mapping-designer |
| 디자인캘린더 | templates | ❌ MISSING | 주문방법_편집기=Y (7상품) | MAPPING-DEFECT | dbm-mapping-designer |
| 캘린더/디자인캘린더/아크릴/굿즈파우치 | addons | ❌ MISSING | 추가상품(옵션) | MAPPING-DEFECT | dbm-mapping-designer |
| 스티커/책자/캘린더 | constraints | ❌ MISSING | 커팅/표지옵션/캘린더가공 캐스케이드 | DIM-UNLOADED | dbm-option-mapper |

## 6. DB-ONLY — 엑셀 master 미요구이나 DB 행 존재 (OVER/EXT-LOAD, 17셀)

은폐 금지를 위해 별도 분류. 각 셀은 **외부 권위 적재(정당)** 또는 **과적재(검토 대상)** 후보.

| 상품군 | 엔티티 | DB행 | 추정 권위(증거) | 차단유형 | 라우팅 |
|--------|--------|----:|----------------|---------|--------|
| booklet/photobook/silsa/acrylic/stationery/goods-pouch | plate_sizes | 11~122 | 가격표 판걸이수(출력판형) [[dbmap-platesize-is-output-paper]] — master '출력용지규격' 미기재 | EXT-LOAD | 권위 대조(가격표 판걸이수)로 required=Y 승격 검토 |
| acrylic/goods-pouch(81r)/stationery | discount_tables | 6~81 | round-1 구간할인 배정 [[dbmap-discount-authority]] — master '구간할인적용테이블' 컬럼(굿즈파우치만 보유) | EXT-LOAD | round-1 권위로 정당(굿즈파우치는 master 컬럼 존재) |
| goods-pouch/product-accessory | materials | 29~130 | 기성/원단 본체 자재(레더/캔버스) — master '소재' 컬럼 부재 | EXT-LOAD | 굿즈 옵션/출력소재IMPORT 권위 대조 |
| sticker/acrylic/goods-pouch/product-accessory | bundle_qtys | 2~11 | 묶음/포장단위 — master '개별포장' 컬럼 부재 상품군 | OVER-LOAD? | 적재 근거 확인(round-1 잔재 가능) |
| booklet | sets | 21 | 책자 셋트 구성 — master '표지타입' 부분 | EXT-LOAD | 정당 가능(책자=내지+표지 셋트) |
| product-accessory | opt_groups(1)/options(2)/constraints(3) | 1~3 | OPP비접착봉투(PRD_000002) 파일럿 잔재 — **items 0(미완)** | OVER-LOAD/미완 | 검토: 의도된 옵션인가 테스트 잔재인가 |

> **product-accessory 의 옵션그룹/옵션/제약**은 OPP비접착봉투 1상품에만 있고 items 가 없다.
> 상품악세사리는 본래 단순(사이즈+가격)이어야 하는데 옵션 레이어 잔재가 있음 → **검토 필요**
> (의도된 옵션 vs 파일럿 테스트 잔재). 발명으로 닫지 않고 OVER-LOAD 후보로 남긴다.

## 7. 라우팅 요약 (다음 액션)

| 라우팅 대상 | 갭 수 | 핵심 |
|------------|------:|------|
| `dbm-option-mapper` | ~28 | CPQ 옵션 레이어 전면 적재 (round-6 GO분 COMMIT + 잔여 상품군 설계) |
| `dbm-price-formula` / `dbm-load-builder` | ~12 | 가격 공식+component_prices 미적재 6 상품군 |
| `dbm-mapping-designer` | ~20 | 차원 PARTIAL(processes/print_options/sizes/page_rules/addons) 결함 |
| 사용자 [CONFIRM] | 2+ | 굿즈/상품악세사리 사이즈=차원행 여부, DB-ONLY 정당성 |
| 권위 대조(검토) | 17 | DB-ONLY 17셀의 외부권위 vs 과적재 판별 |

> 본 라운드는 **검증/조망 전용** — 실제 적재·DDL·COMMIT 없음. 위 라우팅은 제안까지이며 실행은 인간 승인.
