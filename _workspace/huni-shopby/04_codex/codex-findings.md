# codex-findings.md — Codex(gpt-5.5) 독립 2차 교차검증 원 발견

> 산출자: hsb-codex-verifier. 작성: 2026-06-25. codex 모델=gpt-5.5(preflight AVAILABLE)·effort=high·`-s read-only`.
> 입력=설계 산출(`03_design/`·`02_bridge/`) + Shopby 스펙 경로(`docs/shopby/shopby-api/*.yml`). ★Claude 판정 비노출(독립성 유지).
> 헬퍼=`.claude/skills/hqv-codex-cross-verify/scripts/codex-review.sh ... high`(stdin `</dev/null`·`--skip-git-repo-check`·`-s read-only`).
>
> ★[HARD] **codex 주장 = 가설.** 아래는 codex가 스펙을 독립적으로 읽어 낸 발견 원문(요약)이다. reconcile.md에서
> 각 항목을 Claude가 스펙으로 재확인(verified)/반증/false-positive 판정한다. 본 문서 자체는 "사실"이 아니다.

---

## codex 발견 목록 (원문 — 가설)

| ID | 한 줄 | codex 분류 | codex 심각도 | codex 근거 후보 |
|----|------|-----------|:---:|----------------|
| **HSB-X01** | 카트 라인 shape 대체로 정합하나 `post-cart.channelType`은 member schema엔 없음(예제에만) | false-positive 후보 / 일부 누락 | LOW | order-shop:722·729·32025·32035·32093 |
| **HSB-X02** | 라인 임의 단가 입력 필드 실제로 없음(설계 전제 옳음) | false-positive 후보 | HIGH | order-shop:32035·21432, product-shop:3816 |
| **HSB-X03** | `addPrice=final_price`는 `salePrice=0` 전제 없으면 과금 오류(+첫 옵션가 addPrice=0 강제) | 결함 | HIGH | arch:230, product-shop:3816, product-server:16844 |
| **HSB-X04** | `put-product-options({mallProductNo, addPrice})` 의사코드는 실제 request shape 아님(`options[]`/`inputs[]` 구조) | 결함 | HIGH | widget-cart-contract:141, product-server:1795·16796·1817 |
| **HSB-X05** | 가격 동기화 API(put-product-options) 인증 헤더가 Shop API 흐름과 다름(server API systemKey) | 결함 | HIGH | e2e:48, product-server:1758·1788 |
| **HSB-X06** | P-B 동적 옵션 스펙상 가능성은 있으나 상품심사/노출/동시성 통과 미검증 | 리스크 | HIGH | product-server:1748·3287, open-issues:15 |
| **HSB-X07** | `post-order-sheet.products[]` 필수 `recurringPaymentDelivery`가 시퀀스 입력에서 빠짐 | 결함 | MEDIUM | order-shop:21436, e2e:21 |
| **HSB-X08** | `order-sheet calculate` 필수 `addressRequest`가 e2e 입력에서 빠짐 | 결함 | HIGH | order-shop:28580, e2e:23 |
| **HSB-X09** | `payments/reserve` 필수 필드 축약(clientReturnUrl·saveAddressBook·subPayAmt·updateMember 누락) — 그대로면 실패 | 결함 | HIGH | order-shop:33000, e2e:24 |
| **HSB-X10** | 게스트 previous-order token 단계 method/body 틀림(실제 POST + password body) | 결함 | MEDIUM | order-shop:5304·5345, e2e:26 |
| **HSB-X11** | 동적 옵션 청소 후 과거 주문/클레임 추적성 스펙만으로 단정 불가(immutable 보존 권고) | 리스크 | HIGH | claim-shop:7489·7614·8063 |

---

## codex 종합 판정 (원문)

> "설계의 큰 전제(카트/주문 라인에 임의 가격 필드 없음·Shopby는 등록 salePrice/addPrice로 재계산)는 **스펙 정합**.
> 그러나 현재 설계는 **치명 결함**이 있다. 특히 `addPrice=final_price` 수식은 `salePrice=0`이 아니면 돈이 틀리고,
> `put-product-options` payload/auth·`order-sheet calculate`·`payments/reserve`·게스트 token 단계가 실제 OpenAPI
> shape와 어긋난다. **P-B는 가능성 있는 아이디어이지 운영 가능 확정 설계가 아니다.**"

## codex가 "모르는 것"으로 분리 (원문 — 추정 안 함)

1. 옵션/addPrice 변경이 상품심사 `AFTER_APPROVAL_READY`를 실제로 유발하는지.
2. 동적 옵션 생성 직후 storefront/cart에서 즉시 구매 가능한지.
3. 정산/세금계산서/클레임 환불이 과거 주문 snapshot만 쓰는지, 현재 option master를 참조하는지.
4. `recurringPaymentDelivery` 일반 주문의 안전한 빈 값 shape.
5. PG reserve 이후 결제 확정 콜백의 전체 공식 흐름.

> ★ codex 출력 raw 보존: `_workspace/huni-shopby/04_codex/_tmp/codex-out.txt`(thinking 트레이스 포함 12,277줄, 최종 답변=말미).
> 비밀값(.env.local·토큰·clientId)은 프롬프트/로그에 비노출.
