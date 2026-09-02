# L4a status-flip — legacy 미착수/대기/진행중 → L2 근거로 done 재판정

> 담당: L4a 고객 주문경로(186행) · 작성 2026-09-02
> 규칙: `done` 은 전건 L2 `file:line` 인용. §4-4 — done = 「코드 경로가 배선돼 있다」이지 「운영에서 성공한다」가 아니다.

| std_id | 기능 | 뒤집힌 legacy_id (원판정) | L2 근거 file:line |
|---|---|---|---|
| STD-CAT-007 | 상품 상세페이지 본문(이미지·설명 블록) | IA-066(진행중) | huni-skin-shopby/src/app/(main)/product/[slug]/page.tsx:42-47 · :51-56 · src/components/product/product-sections.tsx:1 |
| STD-CAT-014 | 상품 리뷰 목록·평점 노출 | F-089(미착수) · IA-089(미착수) | huni-skin-shopby/src/lib/api/hooks/use-product-reviews.ts:41 |
| STD-OPT-001 | 상품 상세 내 주문옵션 위젯 마운트(격리 렌더) | F-033(미착수) · IA-033(진행중) | huni-skin-shopby/src/components/product/huni-widget.tsx:312-313 · raw/webadmin/webadmin/config/urls.py:184,190,192 |
| STD-OPT-002 | 정규화 옵션 데이터 계약 기반 위젯 구동 | F-033(미착수) · IA-033(진행중) | raw/webadmin/webadmin/config/urls.py:246 (위젯 정의 조회) · :247 (카탈로그 조회) |
| STD-OPT-003 | 옵션 컴포넌트 타입 다형 렌더(셀렉트·라디오·체크·수치입력·이미지선택) | F-033(미착수) · IA-033(진행중) | raw/webadmin/webadmin/config/urls.py:184,190,192 · src/lib/printly/widget.ts:60-90 |
| STD-OPT-008 | 용지(자재) 선택 | F-037(미착수) · IA-037(미착수) · P-MATPOLLUTE-26-01(미착수) · P-MAT-PRICEGAP-01(미착수) | raw/webadmin/webadmin/config/urls.py:304,307,310,313 (용지 관리+단가) · :247 (카탈로그 조회) |
| STD-OPT-009 | 평량(g/㎡) 선택 | F-037(미착수) · IA-037(미착수) | raw/webadmin/webadmin/config/urls.py:304,307,310,313 · catalog/paper_views.py:1 |
| STD-OPT-010 | 비종이 소재 선택(아크릴·PVC·패브릭 등) | F-037(미착수) · IA-037(미착수) · P-GOODS-AXIS-NORM-01(미착수) | raw/webadmin/webadmin/config/urls.py:344,346 (엔티티 공통 마스터) · :247 |
| STD-OPT-011 | 인쇄도수 선택(단면/양면·4도/8도·1도) | F-038(미착수) · IA-038(미착수) · P-DIGITAL-BW-01(미착수) | raw/webadmin/webadmin/config/urls.py:368 (dim-choices) · :247 |
| STD-OPT-012 | 별색(spot color) 선택 | F-038(미착수) · IA-038(미착수) | raw/webadmin/webadmin/config/urls.py:368 · :316 (색상칩 스테이징) |
| STD-OPT-013 | 화이트/UV white 언더베이스 선택 | F-038(미착수) · IA-038(미착수) | raw/webadmin/webadmin/config/urls.py:368 |
| STD-OPT-014 | 규격 사이즈 선택(프리셋) | F-034(미착수) · IA-034(미착수) · P-DELYN-SIZE-01(미착수) · P-SIZEMAP-214-01(미착수) | raw/webadmin/webadmin/config/urls.py:368 · :247 |
| STD-OPT-017 | 수량 선택(구간 프리셋 + 직접입력) | F-036(미착수) · IA-036(미착수) | raw/webadmin/webadmin/config/urls.py:248 (price) · :137,177-181 (수량구간 할인표) |
| STD-OPT-020 | 표지/내지/간지 용지 개별 선택 | F-043(미착수) · IA-043(미착수) | raw/webadmin/webadmin/config/urls.py:356-360 (옵션그룹/옵션/항목 CRUD) · :368 |
| STD-OPT-021 | 표지/내지 인쇄도수 개별 선택 | F-043(미착수) · IA-043(미착수) | raw/webadmin/webadmin/config/urls.py:356-360 · :368 |
| STD-OPT-022 | 제본 방식 선택(중철·무선·PUR·트윈링·하드커버) | F-042(미착수) · IA-042(미착수) · P-PED-BOOK-W12-01(미착수) | raw/webadmin/webadmin/config/urls.py:356-360 · :320-330 (책등 계산) |
| STD-OPT-023 | 제본 방향 선택(좌철/상철 × 세로/가로) | F-042(미착수) · IA-042(미착수) | raw/webadmin/webadmin/config/urls.py:356-360 |
| STD-OPT-031 | 도무송(전체/부분·모양·개수) 선택 | F-040(미착수) · IA-040(미착수) · P-DIECUT-2-01(검증대기) | raw/webadmin/webadmin/config/urls.py:356-360 (옵션 항목 CRUD) |
| STD-OPT-034 | 부자재 선택(케이스·폴리백·포장) | F-047(미착수) · IA-047(미착수) · F-046(미착수) · IA-046(미착수) | raw/webadmin/webadmin/config/urls.py:363-365 (상품 템플릿/추가상품) · :378 (SKU 카탈로그) |
| STD-OPT-036 | 추가상품(악세사리) 템플릿 묶음 선택 | F-046(미착수) · IA-046(미착수) | raw/webadmin/webadmin/config/urls.py:363-365 · :378 |
| STD-OPT-043 | 옵션 변경 시 실시간 재견적 | F-049(미착수) · IA-049(진행중) | raw/webadmin/webadmin/config/urls.py:248 (api/w/v1/price) · huni-widget.tsx:162-176 · src/app/api/printly/requote/route.ts:16-50 |
| STD-OPT-044 | 서버 권위 가격 계산(클라이언트 계산 금지) | F-049(미착수) · IA-049(진행중) | raw/webadmin/webadmin/catalog/pricing.py:1 (evaluate_price 1561줄) · config/urls.py:248 |
| STD-ORD-001 | 장바구니 담기(인쇄옵션+파일 동반) | F-064(미착수) · IA-064(미착수) · F-076(미착수) · IA-076(미착수) | huni-skin-shopby/src/lib/api/hooks/use-cart.ts:201 · src/lib/api/widget-order.ts:26-35 (위젯 견적가 적재) |
| STD-ORD-002 | 장바구니 조회 | F-076(미착수) · IA-076(미착수) | huni-skin-shopby/src/lib/api/hooks/use-cart.ts:130-230 |
| STD-ORD-003 | 장바구니 수량/옵션 수정 | F-076(미착수) · IA-076(미착수) | huni-skin-shopby/src/lib/api/hooks/use-cart.ts:130-230 · src/app/api/printly/requote/route.ts:16-50 |
| STD-ORD-004 | 장바구니 항목 삭제 | F-076(미착수) · IA-076(미착수) | huni-skin-shopby/src/lib/api/hooks/use-cart.ts:130-230 |
| STD-ORD-005 | 선택 상품 금액 계산 | F-076(미착수) · IA-076(미착수) | huni-skin-shopby/src/lib/api/hooks/use-order-sheet.ts:177,252 |
| STD-ORD-009 | 주문서 작성 | F-077(미착수) · IA-077(미착수) | huni-skin-shopby/src/lib/api/hooks/use-order-sheet.ts:40 |
| STD-ORD-010 | 주문서 조회 | F-077(미착수) · IA-077(미착수) | huni-skin-shopby/src/lib/api/hooks/use-order-sheet.ts:177,252 |
| STD-ORD-011 | 쿠폰·배송지 반영 최종 금액 계산 | F-077(미착수) · IA-077(미착수) | huni-skin-shopby/src/lib/api/hooks/use-order-sheet.ts:177,252 · use-order-coupons.ts:34,69,102 |
| STD-ORD-012 | 주문자/수령자 정보 입력 | F-077(미착수) · IA-077(미착수) | huni-skin-shopby/src/lib/api/hooks/use-order-sheet.ts:40 |
| STD-ORD-013 | 배송지 주소 검색(우편번호) | IA-079(미착수) | huni-skin-shopby/src/components/checkout/address-modal.tsx:1 · src/lib/daum-postcode.ts:10 |
| STD-ORD-020 | 주문 완료 화면·주문번호 발급 | F-081(미착수) · IA-081(미착수) | huni-skin-shopby/src/components/order/order-complete-view.tsx:1 |
| STD-ORD-021 | 주문 상태 조회(회원) | IA-009(미착수) · F-161(미착수) | huni-skin-shopby/src/lib/api/hooks/use-my-orders.ts:84,354 |
| STD-ORD-022 | 비회원 주문 조회(주문번호+휴대전화) | IA-073(미착수) | huni-skin-shopby/src/components/order/guest-order-lookup.tsx:4-9 |
| STD-SHP-015 | 배송지 변경/추가 | IA-078(미착수) · IA-079(미착수) | huni-skin-shopby/src/lib/api/hooks/use-shipping-address.ts:65-125 (CRUD·기본배송지) |

**합계: 36개 std 행이 미착수→done 으로 뒤집혔다.**

## 뒤집히지 않은 done (legacy 매핑 0건 = `new` 이면서 이미 구현된 것)

| std_id | 기능 | L2 근거 |
|---|---|---|
| STD-CAT-001 | 대분류/중분류/소분류 다단 카테고리 트리 노출 | huni-skin-shopby/src/lib/api/server/catalog.ts:1-20 (MULTI_LEVEL 트리 조회 done) |
| STD-ORD-007 | 비회원 장바구니 계산(비영속) | huni-skin-shopby/src/lib/guest-cart.ts:1-31 (localStorage 게스트 장바구니 done) |

이 행들은 **표준목록에는 있고 legacy 분모에는 없는데 이미 구현된** 기능이다 — 분모 누락의 직접 증거.
