# webadmin UI 적재 경로 전수 체크리스트 (한 상품 → 가격시뮬레이터 가격 산출)

> [HARD] 라이브 DB 직접 적재 금지. **오직 webadmin UI**(https://huni-admin.printly.co.kr/admin/)로만 등록·교정.
> 목표: 한 상품이 **가격시뮬레이터에서 정확한 가격이 나오게** 전 메뉴를 하나도 안 놓치고 적재.
> 근거: webadmin `config/urls.py`(60라우트) + `views.py:565 SECTIONS` 실조사. gstack browse로 UI 구동.

## 0. 시작 전 (preflight 필수)
- `python3 _workspace/huni-webadmin-load/preflight.py <상품명>` — SOT + 원본 엑셀 셀·실무진 코멘트 + pricing.py 격자식을 먼저 로딩. **추측·재질문 금지**.
- 최신 권위: 가격표 260705 · 상품마스터 260703.

## 1. 상품 편집 8섹션 (`/admin/product-viewer/<prd>/edit/<section>/`)
| # | 섹션 key | 화면 | 무엇을 확인/적재 | 놓치면 |
|---|---|---|---|---|
| 1 | `sizes` | 사이즈 | siz_cd·min/max_qty·qty_incr·기본값 | 사이즈 선택 불가 |
| 2 | `print_options` | 도수/인쇄옵션 | opt_id·단/양면·앞뒤 도수(front/back_colrcnt) | 인쇄옵션 미노출 |
| 3 | `plate_sizes` | 판형 | siz_cd·item_siz_cd·출력용지·기본판형 | 판수환산 불가→인쇄/용지비 0 |
| 4 | `materials` | 자재 | mat_cd·용도(usage_cd)·기본값 | 소재 선택 불가 |
| 5 | `processes` | 공정 | proc_cd·필수여부(mand_proc_yn) | 인쇄/후가공비 0 (결함3 부류) |
| 6 | `bundle_qtys` | 묶음수 | bdl_qty·단위 | 묶음 단가 불가 |
| 7 | `addons` | 추가상품 | tmpl_cd(끼워팔기) | 애드온 미노출 |
| 8 | `page_rules` | 페이지룰 | page_min/max/incr | 책자 페이지 견적 불가 |

## 2. 가격 배선 (상품 상세 + 가격 MD 화면)
| 경로 | 화면 | 무엇 | 놓치면 |
|---|---|---|---|
| `/admin/price-formula-md/` | 가격공식 관리 | 상품↔가격공식(_FOIL 등) 배선·죽은공식 아님 | 가격 0 |
| `/admin/price-component-md/` + `comp/<comp>/edit/` | **가격구성요소·단가표 편집** | 공식→구성요소·**use_dims(사용차원)**·단가행 격자 | ★**잘못된 차원 매핑**(박=소재차원 등)=가격 안 나옴/오청구 |
| `/admin/price-viewer/comp/<comp>/grid/`·`/save/` | 단가표 그리드 저장 | 차원·값 편집(엑셀식 full-sync) | 미적재 셀=저청구 |
| `/admin/price-viewer/comp/<comp>/dupcheck/` | 중복 검사 | 같은 조합 중복행 | 저장 거부/오탐 |
| `/admin/discount-table-md/` + `discount/<dsc>/edit/` | 할인테이블 | 상품↔수량할인 배선 | 대량 과청구(결함1 부류) |

## 3. CPQ 옵션·제약 (`/admin/product-viewer/<prd>/...`)
| 경로 | 화면 | 무엇 |
|---|---|---|
| `/options/`·`/options/<grp>/`·`/options/<grp>/<opt>/` | 옵션그룹/옵션/옵션아이템 | 손님 선택 옵션(박색상 등)·polymorphic ref_dim |
| `/templates/`·`/templates/<tmpl>/` | 템플릿 | 셋트/구성 |
| `/dim-choices/` | 차원 선택지 | 드롭다운 값 |
| `/constraints/` | 제약규칙 | 물리불가·동반·배제(JSONLogic) |
| `/validate/` | 검증 | 등록 정합 사전점검 |

## 4. 기준정보 마스터 (`/admin/master/<entity>/`·`/admin/basecode-master/`)
- 자재·공정·사이즈·색상·인쇄옵션·박색상 등 코드가 존재해야 위 배선 가능(없으면 먼저 등록).
- `/admin/category-master/` 카테고리 · `/admin/set-products/` 셋트.

## 5. 검증 (가격시뮬레이터 — 예측 vs 실제)
| 경로 | 화면 | 무엇 |
|---|---|---|
| `/admin/price-simulator/` | 가격 시뮬레이터 | 상품 선택→조건 입력→**가격 계산**. 구성요소별 상세·제외·경고 표시 |
| `/admin/price-viewer/<prd>/simulate/` (API) | 계산 엔드포인트 | 자동 검증용 |
| `/admin/price-viewer/<prd>/detail/`·`/diagram/`·`/source/` | 상세·배선도·가격소스 | 사슬 시각 확인 |
| `/admin/impact/` | 영향도 | 이 코드 쓰는 상품(교정 파급) |

**[HARD] 종료척도**: 시뮬레이터에서 **제외 0 · 가격≠0 · 예측 기대값 = 실제 가격**(권위 엑셀 셀값과 대조). 하나라도 미달=미완.

## 6. 한 상품 완주 순서 (프리미엄명함 파일럿 기준)
1. preflight(SOT+엑셀 셀·코멘트+코드) 읽기 → 예측 기대값 산출(권위 셀).
2. 기준정보 마스터 존재 확인(자재·공정·박색상).
3. 상품 8섹션 점검·적재(누락 채움).
4. 가격공식 배선 + **가격구성요소 단가표 차원(use_dims) 교정**(잘못된 차원 전수 적발).
5. 할인테이블·옵션그룹·제약 배선.
6. 가격시뮬레이터 실행 → **예측 vs 실제** 대조 → 불일치 원인(차원/누락) 역추적 → 4로.
7. 제외 0·가격 일치까지 반복 → 완주.
