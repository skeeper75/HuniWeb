# Shopby 재고(=카트 담기 상한) 변경 기록 — 2026-08-30

## 무엇을 확인했나

**카트에 담을 수 있는 개수의 상한은 「재고(stockCnt)」 하나다.**
구매수량 제한 필드는 전 상품이 0(무제한)이었다.

게스트 카트(`POST /guest/cart` — 서버 미영속·계산 전용)로 실측:

| orderCnt | 재고 9,999일 때 | 재고 1,000,000일 때 |
|---:|---|---|
| 9,999 | 담김 | 담김 |
| 10,000 | `OUT_OF_STOCK` | 담김 |
| 1,000,000 | `OUT_OF_STOCK` | **담김** |
| 1,000,001 | `OUT_OF_STOCK` | `OUT_OF_STOCK` |

거부 사유 원문: `validInfo.errorCode = "OUT_OF_STOCK"`,
`maxBuyCountInfo = {maxBuyPersonCount:0, maxBuyTimeCount:0, maxBuyDays:0, maxBuyPeriodCount:0}`.

기존 9,999는 Shopby 기본값이 아니라 **우리가 등록할 때 넣은 값**이다
(`13_product-load/register.py:187` `'stockCnt': 9999`).

## 재고 변경 API (문서에 본문 스키마가 없어 실측으로 확정)

```
PUT /products/options/stock-with-id
{"options": [{"optionNo": <mallOptionNo>, "stock": <수량>}]}
→ 200 {"failures": []}
```

[HARD] 수량 필드는 **`stock`** 이다. `stockCnt` / `cnt` / `quantity` 로 보내면
**200을 돌려주면서 재고를 0으로 만든다** — 조용한 파괴다. 필드명을 반드시 확인할 것.
[HARD] 옵션 식별자는 **`mallOptionNo`** 다. `optionNo`(=0)나 `stockNo`를 보내면
`OSEC0001`로 실패한다.

동작하지 않는 경로(실측): `PATCH /products/{no}`는 204를 주지만 재고를 바꾸지 않는다.
`PATCH /products/stocks`는 `productNo`를 요구하는데 이 몰의 상품은 `productNo=0`
(`mallProductNo`만 유효)이라 통과하지 못한다.

## 무엇을 바꿨나

- 대상: 게시·미게시 포함 **전 상품 297종 / 옵션 297건**
- 값: `stockCnt` 9,999 → **1,000,000**
- 결과: 297/297 성공 · 재조회 검증 297건 전부 `1000000` (예외 0)

변경 전 분포: `9999` 294건 · `19998` 1건 · `39976` 1건 · `1000000` 1건(시험분).
**`19998`·`39976`은 다른 값이었다** — 의도가 있었다면 스냅샷에서 복원할 것.

## 백업 · 되돌리기

- `options-snapshot.json` — 변경 전 전 옵션의 `stockCnt` 스냅샷
- `backup-136578130.json` — 시험 상품 상세 전문

되돌리기: `set-stock.py`의 `TARGET`을 원래 값으로 두고 실행하거나,
스냅샷의 `stockCnt`를 옵션별로 되돌린다.

## 사고 기록 (정직하게)

본문 형태를 탐색하는 과정에서 `cnt`·`stockCount` 필드로 호출했고, 그 호출들이
**시험 상품 `136578130`의 재고를 0으로 만들었다**(게시 중 상품 → 일시 품절).
같은 세션에서 즉시 1,000,000으로 복구했고 최종 검증에서 정상 확인됐다.
교훈: 쓰기 API의 본문 형태를 모를 때는 **읽기로 필드명을 먼저 확정**하거나,
게시되지 않은 상품을 시험 대상으로 고를 것.

## 도구

| 파일 | 용도 |
|---|---|
| `set-stock.py` | 스냅샷의 전 옵션에 `stock` 일괄 설정(50건씩 배치) |
| `verify-stock.py` | 전 상품 재조회로 실제 반영 검증 |
| `cart-limit-test.py` | 게스트 카트로 담기 상한 실측(서버 미영속) |
