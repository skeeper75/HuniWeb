# 입체 커버리지 매트릭스 — 상품마스터 11 상품군 × 라이브 t_* 엔티티

> 생성: `scripts/build_matrix.py` (= extract_excel_requirements.py + probe_db_coverage.sh).  
> 권위: 필요여부=엑셀 명시값(`06_extract/*-l1.csv`), 상태=라이브 DB 실측 행수(읽기전용 psql).  
> 셀 표기: `아이콘 wr/n` — wr=행 보유 상품수, n=그 상품군 해소 상품수. LOADED는 `✅ n` (전 상품 보유).

## 범례

| 아이콘 | 상태 | 의미 |
|:--:|------|------|
| ✅ | LOADED | 필요 + 그 상품군 전 상품이 행 보유 |
| 🟡 | PARTIAL | 필요 + 일부 상품만 행 보유 |
| ❌ | MISSING | 필요한데 라이브 0행 |
| ◆ | DB-ONLY | 엑셀 master 미요구이나 DB에 행 존재 (외부 권위 적재 또는 과적재 후보 — gap-board) |
| ➖ | N/A | 엑셀이 이 엔티티를 요구하지 않음 + DB도 0행 |

## 집계 (총 209 셀 = 11 상품군 × 19 엔티티)

- ✅ LOADED: **51**
- 🟡 PARTIAL: **44**
- ❌ MISSING: **49**
- ◆ DB-ONLY: **17**
- ➖ N/A: **48**

## 매트릭스 (행=엔티티, 열=상품군)

| 엔티티 \ 상품군 | 디지털인쇄 | 스티커 | 책자 | 포토북 | 캘린더 | 디자인캘린더 | 실사 | 아크릴 | 문구 | 굿즈파우치 | 상품악세사리 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| `products` | ✅ 36 | ✅ 16 | ✅ 10 | ✅ 1 | ✅ 5 | ✅ 5 | ✅ 28 | ✅ 25 | ✅ 11 | ✅ 98 | ✅ 15 |
| `categories` | ✅ 36 | ✅ 16 | ✅ 10 | ✅ 1 | ✅ 5 | ✅ 5 | ✅ 28 | ✅ 25 | ✅ 11 | ✅ 98 | ✅ 15 |
| `sizes` | 🟡 33/36 | ✅ 16 | ✅ 10 | ✅ 1 | ✅ 5 | ✅ 5 | ✅ 28 | 🟡 23/25 | ✅ 11 | 🟡 11/98 | 🟡 7/15 |
| `materials` | 🟡 35/36 | ✅ 16 | 🟡 9/10 | ✅ 1 | ✅ 5 | ✅ 5 | 🟡 23/28 | 🟡 23/25 | ✅ 11 | ◆ 130r | ◆ 29r |
| `print_opts` | 🟡 32/36 | ✅ 16 | ✅ 10 | ✅ 1 | ✅ 5 | ✅ 5 | ➖ | 🟡 21/25 | 🟡 7/11 | ➖ | ➖ |
| `processes` | 🟡 23/36 | 🟡 14/16 | 🟡 9/10 | ✅ 1 | ✅ 5 | ✅ 5 | 🟡 17/28 | 🟡 14/25 | 🟡 9/11 | 🟡 6/98 | ➖ |
| `plate_sizes` | ✅ 36 | ✅ 16 | ◆ 32r | ◆ 11r | ✅ 5 | ✅ 5 | ◆ 84r | ◆ 51r | ◆ 11r | ◆ 122r | ➖ |
| `bundle_qtys` | ➖ | ◆ 5r | 🟡 1/10 | ➖ | ❌ | ➖ | ➖ | ◆ 6r | 🟡 1/11 | ◆ 2r | ◆ 11r |
| `page_rules` | ➖ | ➖ | 🟡 9/10 | ✅ 1 | ❌ | ❌ | ➖ | ➖ | 🟡 2/11 | ➖ | ➖ |
| `sets` | ➖ | ➖ | ◆ 21r | ✅ 1 | ➖ | ➖ | ➖ | ➖ | 🟡 1/11 | ➖ | ➖ |
| `addons` | 🟡 1/36 | ➖ | ➖ | ➖ | ❌ | ❌ | ➖ | ❌ | ➖ | ❌ | ➖ |
| `opt_groups` | ❌ | ❌ | ❌ | ➖ | ❌ | ❌ | 🟡 1/28 | ❌ | ❌ | ❌ | ◆ 1r |
| `options` | ❌ | ❌ | ❌ | ➖ | ❌ | ❌ | 🟡 1/28 | ❌ | ❌ | ❌ | ◆ 2r |
| `opt_items` | ❌ | ❌ | ❌ | ➖ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ➖ |
| `templates` | 🟡 2/36 | 🟡 8/16 | 🟡 1/10 | ✅ 1 | ➖ | ❌ | 🟡 3/28 | 🟡 1/25 | 🟡 6/11 | 🟡 96/98 | ➖ |
| `constraints` | 🟡 1/36 | ❌ | ❌ | ➖ | ❌ | ❌ | ➖ | ➖ | ➖ | ➖ | ◆ 3r |
| `price_frm` | 🟡 26/36 | 🟡 4/16 | 🟡 6/10 | ❌ | ❌ | ❌ | ✅ 28 | ❌ | 🟡 1/11 | ❌ | ❌ |
| `comp_prices` | 🟡 26/36 | 🟡 4/16 | 🟡 6/10 | ❌ | ❌ | ❌ | ✅ 28 | ❌ | 🟡 1/11 | ❌ | ❌ |
| `discounts` | ➖ | ➖ | ➖ | ➖ | ➖ | ➖ | ➖ | ◆ 11r | 🟡 6/11 | 🟡 81/98 | ➖ |

> `short` ↔ 실제 테이블: products=t_prd_products, categories=t_prd_product_categories,
> sizes/materials/print_opts/processes/plate_sizes/bundle_qtys/page_rules/sets/addons=t_prd_product_*,
> opt_groups/options/opt_items=t_prd_product_option_*, templates=t_prd_templates,
> constraints=t_prd_product_constraints, price_frm=t_prd_product_price_formulas,
> comp_prices=t_prc_component_prices(공식사슬 경유), discounts=t_prd_product_discount_tables.

## 3원 대조 (엑셀 ↔ DB ↔ admin product-viewer) — C4 증거

라이브 admin(`/admin/product-viewer/<prd_cd>/`) 로그인 성공. 대표상품 + 미적재 의심분 3종 대조.
admin 탭의 (행수) = t_* 엔티티 역할 UI ground-truth. **3종 모두 admin 탭 = DB 실측 = 정확 일치.**
캡처: `admin-captures/`.

| 상품 | 상품군 | admin 탭(행수) | DB 실측 | 엑셀 요구 | 일치 |
|------|--------|---------------|---------|----------|:---:|
| PRD_000016 프리미엄엽서 | 디지털인쇄(대표) | 사이즈7·도수2·판형1·자재21·공정6·묶음0·추가1·페이지0·옵션그룹0·제약0 | sizes7·print2·plate1·mat21·proc6·bdl0·addon1·page0·optg0·con0·frm1 | 사이즈/종이/인쇄/별색/코팅/커팅/후가공/추가 | ✅ |
| PRD_000111 벽걸이캘린더 | 캘린더(미적재 의심) | 사이즈3·도수2·판형1·자재23·공정2·추가0·페이지0·옵션그룹0·제약0 | sizes3·print2·plate1·mat23·proc2·addon0·page0·optg0·frm0 | 장수(page)·캘린더가공(옵션)·추가상품 → DB 0 확증 | ✅ |
| PRD_000193 머그컵 | 굿즈파우치(기성품) | 사이즈0·자재4·판형1·나머지0 | sizes0·mat4·plate1·discount1 | 사이즈(필수) 컬럼有 but DB size 0 → DOMAIN-UNDECIDED | ✅ |

> admin = DB 100% 일치 → DB 실측 행수를 상태 권위로 신뢰 가능(C3·C4). 캘린더 page/옵션그룹/추가 0,
> 머그컵 size 0 은 admin 으로도 재확인(미적재가 사실임을 UI 가 확증). 날조 0.

## 해소 캐비엇 (matrix 행 해석 주의)

1. **calendar ↔ design-calendar 동일 prd_cd 공유** — 두 상품군 모두 PRD_000108~112(탁상/미니/엽서/
   벽걸이/와이드벽걸이) 5상품을 가리킨다(라이브 prd_nm 1:1 확인). 같은 물리 상품을 두 시트가 다른
   속성으로 기술 → 두 행의 상태가 유사한 것은 정상(오류 아님).
2. **prd_cd 해소 = prd_nm 조인**(MES_ITEM_CD 전부 NULL — 유일 가능 키). 264 (family,prd_nm) 중
   250 해소·14 미해소(★신규상품·"(보류중)"·하이퍼링크·코멘트행 — DB 미등록이 정상).
3. **DB-ONLY(◆) 17셀**은 엑셀 master 가 요구 안 했으나 DB 행 존재 — 외부 권위(가격표 판걸이수·
   round-1 구간할인) 적재 또는 과적재 후보. C2(추측 0) 준수로 required=Y 자동전환 안 함, gap-board §6.

## 셀 단위 실측은 `coverage-cells.csv`, 미적재 갭 분류는 `gap-board.md`, 관계 무결성은 `relationship-integrity.md` 참조.
