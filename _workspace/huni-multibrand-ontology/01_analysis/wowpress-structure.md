# 와우프레스 데이터 모델·API 구조 — 원자 사실 (§35 Phase 1)

> 원천: `docs/wowpress/catalog/`(2025-10-14 devshop 수집)·`wowpress-api-document.txt`·`*_spec.pdf`.
> 값은 전부 스크립트 전사(`_cache/*.csv`). 앵커 없는 사실 없음. 부재는 GAP으로 표기.
> **경계**: 와우 원어 원자 기록까지. 후니 t_* 번역·대조는 mapper 몫.

## 0. 카탈로그 규모 (스크립트 전사)

| 지표 | 값 | 앵커 |
|---|---|---|
| 상품 수 | 326 | `catalog:index.json#productCount` |
| 카테고리 수 | 47 | `catalog:index.json#categoryCount` |
| 규격(size) 옵션 행 총계 | 1,584 | `_cache/wow_size_options.csv` |
| 후가공(awkjob) 작업 행 총계 | 4,141 | `_cache/wow_awkjob_flat.csv` |
| index 표기 templatedProducts / quotedProducts | 6 / 0 | `catalog:index.json#pricingStats` |

## 1. 상품 JSON 이중 구조 [핵심]

catalog `products/<id>.json`은 **normalized 뷰 + raw 원본**의 이중 구조.
- `meta` / `delivery` / `options` / `availability` / `pricing` = 정규화 뷰 (sparse — `options`는 `orderQuantities`·`coverTypes`·`additionalOptions`만 담음).
- `raw.prod_info` = **와우 OPEN API 원본 응답**(6축 rich 데이터 전부 여기 존재). 앵커 원천: `GET /api/v1/std/prod_info/{prodno}` (`wowpress-api:7#prod_info`).
- 앵커: `catalog:products/40002.json#raw.prod_info` = `wowpress-api:6.3-제품상세` 응답과 동형.

**따라서 6축 원자 추출의 1차 앵커는 `raw.prod_info.<axis>`.** normalized `options`는 파생·부분.

## 2. 6축 + 보조축 (와우 원어) — raw.prod_info 필드

| 축 | raw 필드 | 주문 식별키 | 교차제약 필드 | 앵커 예 |
|---|---|---|---|---|
| 규격 | `sizeinfo[].sizelist[]` | `sizeno` | `req_width/height/awkjob`, `rst_ordqty/awkjob`, `non_standard` | `catalog:products/40002.json#raw.prod_info.sizeinfo` |
| 도수 | `colorinfo[].pagelist[].colorlist[]` | `colorno`(+`colornoadd`) | `req_prsjob`, `rst_prsjob/awkjob/opt`, `addtype` | `#raw.prod_info.colorinfo` |
| 재질 | `paperinfo[].paperlist[]` | `paperno` | `papergroup`,`pgram`, `req_width/height/awkjob`, `rst_ordqty/prsjob/awkjob` | `#raw.prod_info.paperinfo` |
| 인쇄방식 | `prsjobinfo[].prsjoblist[]` | `jobno`(그룹 `jobpresetno`) | `req_color`, `rst_paper/awkjob` | `#raw.prod_info.prsjobinfo` |
| 후가공 | `awkjobinfo[].jobgrouplist[].awkjoblist[]` | `jobno` (그룹 `jobgroupno`) | `req_jobsize/jobqty/awkjob`, `rst_jobqty/cutcnt/size/paper/color/awkjob` | `#raw.prod_info.awkjobinfo` |
| 부자재 | `prodaddinfo[]` | `prodno`(부속 상품 참조) | — | `#raw.prod_info.prodaddinfo` |
| 배송 | `deliverinfo{dlvyfree[],...}` | `usrkd`(회원등급) | `mincost`(무료배송 기준) | `#raw.prod_info.deliverinfo` |
| 수량/건수 | `ordqty[]` · `coverinfo[].pagelist`+`pagecnt` | `ordqtylist`/`min/max/interval` · `covercd`/`pagecd` | — | `#raw.prod_info.ordqty` |

- **`optioninfo`**(부자재/옵션 별도 필드)는 34상품만 non-empty (`_cache/wow_products.csv#n_optioninfo`).
- **`awkjobinfo`는 2단 중첩**: `jobgrouplist`(후가공 그룹: 박·타공·코팅·제본…) → `awkjoblist`(구체 작업). `namestep1/namestep2` 2단 표시명.

## 3. 상품 유형 판별자 (와우 원어)

| 필드 | 값 분포 (스크립트) | 의미 | 앵커 |
|---|---|---|---|
| `meta.selType` (`seltype`) | M=311·S=12·None=3 | **M=구성형(다옵션 인쇄상품)·S=단순(거치대·케이스·받침대 등 부속완제품)** | `_cache/wow_products.csv#selType` |
| `raw.prod_info.pjoin` | 0=174·9=137·1=12·None=3 | 제품구분(0=독판/none·9=합판인쇄·1=별도). API 응답에도 `pjoin` 재출현 | `catalog:products/*.json#raw.prod_info.pjoin` (`wowpress-api:6.4#pjoin`) |
| `ordqty[].type` | select=317·input=6 | select=수량 리스트 선택·**input=자유입력(대량포스터/전단/리플렛)** | `_cache/wow_products.csv#ordqty_type` |
| `meta.unit` | 매144·개136·권16·세트13·부6·장6·연2 | 수량 단위 | `_cache/wow_products.csv#unit` |

- selType=S 12상품 예: 포스터박스(40117)·플라잉배너받침대(40125)·거치대류·명함케이스·철제입간판. = **부속/거치 완제품**(구성옵션 없음).
- selType=None 3: 40078 LED라이트배너거치대·40089 PP부채·40297 종이자석광고지(패턴)_TEST → **GAP 후보**(_TEST 1건 포함).

## 4. 축 커버리지 (상품 중 해당 축 보유 수, 스크립트 전사)

| 축 | 보유 상품수 | 앵커 |
|---|---|---|
| 규격 sizeinfo | 307 | `_cache/wow_products.csv` (n_sizes>0) |
| 재질 paperinfo | 276 | 〃 (n_papers>0) |
| 도수 colorinfo | 277 | 〃 (n_colors>0) |
| 인쇄방식 prsjobinfo | 319 | 〃 (n_prsjob>0) |
| 후가공 awkjobinfo | 145 | 〃 (n_awkjob>0) |
| 부자재 prodaddinfo | 87 | 〃 (n_prodadd>0) |
| optioninfo | 34 | 〃 (n_optioninfo>0) |

## 5. 교차축 제약 (req_ 필수조건 / rst_ 제약조건) [핵심]

와우는 축 간 **필수조건(`req_*`)·제약조건(`rst_*`)**을 각 옵션 항목에 인라인으로 붙인다 (`wowpress-api:7#제약조건`, `catalog:products/*.json#raw.prod_info.sizeinfo[].req_awkjob` 등).

| 축 | 교차제약 보유 상품수 | 대표 제약 필드 |
|---|---|---|
| 도수(color) | 186 | `req_prsjob`(이 도수는 특정 인쇄방식 필수), `rst_prsjob/awkjob/opt` |
| 재질(paper) | 151 | `req_awkjob`, `rst_ordqty/prsjob/awkjob` |
| 규격(size) | 109 | `req_width/height`(비규격 시), `rst_ordqty/awkjob`, `req_awkjob` |

- 후가공 항목은 자체적으로 `rst_jobqty/cutcnt/size/paper/color/awkjob` 6종 제약을 가짐 (가장 제약이 촘촘한 축).
- 앵커: `wowpress-api:7.1-규격#req_awkjob`(규격관련 후가공 필수), `wowpress-api:7.1#rst_ordqty`(규격관련 수량 제약).
- **의미**: 온톨로지 제약 모델링의 1차 원천 = 이 인라인 req_/rst_ 그래프. mapper가 후니 constraint(CN-1~6)와 대조.

## 6. OPEN API 기능 목록 (앵커 인벤토리)

원천 `wowpress-api-document.txt` §6~§9 (`docs/wowpress/wowpress-api-document.txt`):

| § | 엔드포인트/기능 | 앵커 |
|---|---|---|
| 6.2 | 제품목록조회 | `wowpress-api:6.2` |
| 6.3 | 제품상세 = `GET /api/v1/std/prod_info/{prodno}` → **catalog raw.prod_info 원천** | `wowpress-api:6.3` / `wowpress-api:7#prod_info` |
| 6.4 | **제품가격조회 = `POST /api/v1/ord/cjson_jobcost`** (가격 단일 권위) | `wowpress-api:6.4` |
| 6.5 | 주문하기 | `wowpress-api:6.5` |
| 7.1~7.6 | 규격/도수/재질/후가공/부자재/배송 제약 조건 SPEC | `wowpress-api:7.1`~`7.6` |
| 8.1~8.9 | 제품별 옵션 개별 조회(기본/규격/도수/지질/수량/건수/후가공/옵션/부자재) | `wowpress-api:8.1`~`8.9` |
| 9.1 | 제품상세·제품가격 status 코드표(200/401~411) | `wowpress-api:9.1` |
| PDF | 제품상세 SPEC / 제품가격&주문 SPEC | `wowpress-pdf:products_spec_v1.0.pdf` / `wowpress-pdf:price_order_spec_v1.01.pdf#p5` |

## 7. 앵커 규약 (§35 [HARD])

- `catalog:products/<id>.json#<jsonpath>` — 상품 사실(raw.prod_info.* 우선).
- `catalog:categories/<catid>.json#<jsonpath>` · `catalog:index.json#<jsonpath>` — 카테고리·요약.
- `wowpress-api:<§>-<이름>#<field>` — API 계약(문서 §번호).
- `wowpress-pdf:<file>#p<page>` — SPEC PDF.
- `_cache/<file>.csv#<column>` — 스크립트 전사값(재현 스크립트 `_cache/_*.py`).

## GAP (정직 기록)

- **G-STRUCT-1**: catalog에 **실 가격값 0** — 전 326상품 `pricing.status=requires-configuration`. 가격은 jobcost API로만. (price-mechanism 문서 참조)
- **G-STRUCT-2**: `optioninfo` 축은 34상품만 채워짐 — 나머지 부자재는 `prodaddinfo`로. 두 필드 역할 경계는 catalog만으로 불명확(라이브/8.8·8.9 조회 필요). anchor=`wowpress-api:8.8-옵션`·`8.9-부자재` (본문 미상세).
- **G-STRUCT-3**: selType=None 3상품(40078·40089·40297_TEST) — 유형 미정. 40297은 명시 _TEST.
- **G-STRUCT-4**: catalog 노후(2025-10-14) — 옵션/가격 갱신분 미반영 가능. 의심분만 devshop 라이브 재확인.
