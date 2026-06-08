# admin product-viewer 3원 대조 캡처 — C4 증거

> 라이브 admin (`https://huni-admin-production.up.railway.app/admin/product-viewer/<prd_cd>/`)
> 로그인 성공(gstack browse, Django 폼 인증, 자격증명=.env.local `HUNI_ADMIN_ID/PW`).
> admin 탭의 (행수) = t_* 엔티티 역할 UI ground-truth ([[dbmap-live-admin-product-viewer]]).
> 대조 방식: admin 탭 행수 ↔ 라이브 psql `count(*)` ↔ 엑셀 master 필요요소. 3종 모두 **정확 일치**.

## 캡처 목록

| 파일 | prd_cd | 상품 | 상품군 | 역할 |
|------|--------|------|--------|------|
| `PRD_000016_premium-postcard.png` | PRD_000016 | 프리미엄엽서 | 디지털인쇄 | 대표상품(완비 케이스) |
| `PRD_000111.png` | PRD_000111 | 벽걸이캘린더 | 캘린더 | 미적재 의심분(옵션/가격/페이지 0 확증) |
| `PRD_000193.png` | PRD_000193 | 머그컵 | 굿즈파우치 | 기성품(사이즈 0 = DOMAIN-UNDECIDED 확증) |

## 대조 결과

### PRD_000016 프리미엄엽서 (대표)
admin 12탭: 사이즈(7)·도수/인쇄옵션(2)·판형(1)·자재(21)·공정(6)·묶음수(0)·추가상품(1)·페이지룰(0)·
옵션그룹(0)·제약규칙(0)·구성템플릿(0).
DB psql: sizes=7·print=2·plate=1·materials=21·processes=6·bundle=0·addons=1·page=0·opt_groups=0·
constraints=0·price_formulas=1.
→ **admin = DB 전 항목 일치.** 엑셀 digital-print master 필요요소(사이즈·종이·인쇄·별색·코팅·커팅·후가공·
추가상품) 와 정합. 옵션그룹 0 = 별색/코팅/후가공이 CPQ 옵션 레이어로 아직 미적재(gap-board §2).

### PRD_000111 벽걸이캘린더 (미적재 의심)
admin: 사이즈(3)·도수(2)·판형(1)·자재(23)·공정(2)·추가상품(0)·페이지룰(0)·옵션그룹(0)·제약(0).
DB psql: sizes=3·print=2·plate=1·materials=23·processes=2·addons=0·page_rules=0·opt_groups=0·
price_formulas=0.
→ **admin = DB 일치.** 엑셀 calendar master 가 요구하는 장수(page_rules)·캘린더가공(옵션그룹)·추가상품·
가격이 **DB 0** 임을 admin UI 가 재확인. 미적재가 사실임을 ground-truth 로 확증(matrix MISSING 정당).

### PRD_000193 머그컵 (기성품)
admin: 사이즈(0)·도수(0)·판형(1)·자재(4)·공정(0)·나머지 0.
DB psql: sizes=0·print=0·plate=1·materials=4·discount_tables=1.
→ **admin = DB 일치.** 엑셀 goods-pouch master '사이즈(필수)' 컬럼은 채워져 있으나(머그컵 규격 텍스트)
DB size 차원행 0 → "기성품 사이즈는 차원행인가 텍스트인가" DOMAIN-UNDECIDED(gap-board §4). discount=1
은 goods_b 구간할인 배정과 정합.

## 결론

admin product-viewer = 라이브 DB 100% 일치(3종). 따라서 **DB psql 실측 행수를 상태 판정의 권위로 신뢰
가능**(C3). admin 은 미적재(캘린더 옵션/가격, 머그컵 사이즈)를 UI 로 재확증 — 날조·은폐 0(C4). admin
대조는 대표+의심분 집중(전수 아님, 세션 비용). 나머지 셀은 R1~R7 관계 무결성 + psql 실측으로 뒷받침.
