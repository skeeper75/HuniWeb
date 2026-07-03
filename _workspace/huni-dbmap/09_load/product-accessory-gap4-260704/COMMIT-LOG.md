# 상품악세사리 GAP-4 — 누락 24 variant 템플릿 mint + 가격 라이브 COMMIT (2026-07-04)

> 트랙: huni-dbmap §7 적재. 권위 = 상품마스터 260702 엑셀 verbatim. Phase 1(34 템플릿 가격)의 후속.

## 배경
Phase 1은 기존 34 활성 템플릿에 가격만 부여. GAP-4 = 가격표엔 있으나 라이브 템플릿이 없어
손님이 선택 자체 불가였던 **누락 치수 24 variant**를 신규 mint + 가격.

## COMMIT 내용
- **t_prd_templates mint 24행**(TMPL-000067~090·라이브 max 066 이후 연속·use_yn=Y·tags='[]').
  - OPP접착봉투 9치수(70x200~230x350) · OPP비접착봉투 8치수 · 행택끈 3(사각검정/백색/마사) · 자석고정용고무판 1 · 우드행거 3(230/320/440mm).
- **t_prd_template_prices 24행**(apply_ymd='2026-07-03' Phase1 정합·unit_price=엑셀 verbatim·단가합 87,550).
- `PRE tmpl 0 → INSERT 24+24 → POST tmpl 24·price 24`. COMMIT.

## 사후 검증
- 상품악세사리 활성 템플릿 34→**58·priced 58/58**(Phase1 34 + GAP-4 24).
- webadmin 실화면(라이브 admin simulate): OPP접착70x200=1,100·230x350=3,250·행택끈사각마사=4,000·자석고무판=1,000·우드행거230=16,000 = 전부 정확·ok=true.

## 안전장치
- 물리백업 `backup/pre_templates.csv`(사전 5상품 템플릿 10행). undo `undo.sql`(신규 24 템플릿+가격 삭제·기존 무접촉). 값=스크립트 도출.

## 후속(별도)
- 신규 치수 템플릿을 부모상품(엽서 등) addon 메뉴에 노출할지 = 별도 ①UI 결정(t_prd_product_addons 확장·per-parent).
- 003 트래싱지 카드봉투(del_yn=Y) 삭제 의도 실무진 확인.
