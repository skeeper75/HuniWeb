# 상품악세사리 Phase 1 — 34 활성 템플릿 가격 라이브 COMMIT (2026-07-03)

> 트랙: huni-dbmap §7 적재. 정답 그릇 = `t_prd_template_prices`(pricing.py:442~454).
> 권위 = 상품마스터 260702(=260610 변경0) 엑셀 `가격` verbatim. 매핑 = `template-price-mapping-260703.md`.

## 배경
상품악세사리 15상품 가격 3그릇(product_prices·price_formulas·template_prices) 전부 empty →
evaluate_price 0. 34개 활성 addon 템플릿이 무가격인데 **22개가 11개 부모상품(엽서·포토카드·
접지카드·스티커·만년스탬프·아크릴키링)에 addon 연결** → 손님 선택 시 0원 기여 = **저청구 라이브 발생 중.**

## COMMIT 내용
`t_prd_template_prices` **UPSERT 34행**(apply_ymd='2026-07-03', unit_price=엑셀 verbatim).
- 봉투류 8(OPP접착2·비접착3·카드2·캘린더1블록) · 볼체인8 · 와이어링3 · 투명케이스3 · 우드거치대1 · 우드봉3 · 리필잉크7
- 단가합 = **82,000** · 미매핑 0 · 신규 mint 0(기존 템플릿에 가격만 부여).
- DB 결과: `PRE priced 0 → INSERT 0 34 → POST priced 34`. COMMIT.

## 사후 검증 (독립 재실측)
- 라이브 priced 34/34 · 값 verbatim 대조 **불일치 0행**.
- 상품별 단가: 봉투 600~3,500·볼체인 1,000·와이어 500·투명 3,000~3,500·우드거치대 4,000·우드봉 7,000~12,000·리필 2,500.

## webadmin 실화면 검증 (라이브 admin simulate·인증 세션·PRICE≠0) [HARD]
- template-직접 simulate 4건: OPP접착110x160=**1,200**·볼체인오렌지=**1,000**·리필검정=**2,500**·우드봉480=**12,000**(전부 ok=true·기대 정확).
- **addon 경로**: 프리미엄엽서(PRD_000016)에 카드봉투화이트+OPP접착봉투 addon → **addon_total=2,200**(1,000+1,200) = 저청구 해소 실증.

## 안전장치
- 물리백업: `backup/pre_template_prices.csv`(사전 empty·헤더만).
- undo: `undo.sql`(apply_ymd='2026-07-03' 34행만 삭제·다른 상품/날짜 무접촉).
- 실행기: `apply.sh`(dryrun 기본·`commit` 인자로 실 반영).

## 범위 밖 (다음 단계)
- **GAP-4**: 봉투 누락 치수(OPP접착9·비접착8) + 템플릿 0개 상품(행택끈3·자석고무판1·우드행거3) = **24 variant 템플릿 신규 생성 + 가격**(엑셀에 가격 존재·현재 저청구는 아님·주문경로 부재).
- **003 트래싱지 카드봉투** del_yn=Y(삭제·엑셀 가격 존재) → 삭제 의도 실무진 확인.
- **008 천정고리** use_yn=N(비활성).
