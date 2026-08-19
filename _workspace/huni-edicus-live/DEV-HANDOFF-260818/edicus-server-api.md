# Edicus Server API 규격표

> 1차 근거: `MotionOne/edicus-dev` → `demo-basic/server.js` (로컬 사본 `raw/edicus_dev/`).
> 상태 전이는 `demo-basic/order.js` 주석 + `ORDER_PROCESS.md`.
> 이 표에 없는 것은 **확인 안 된 것**입니다 — 추측으로 채우지 마세요.

---

## 공통 규칙

```
Base    settings.EDICUS_API_HOST        예) https://api-dot-edicusbase.appspot.com
Header  edicus-api-key: <비밀 키>        ★ 절대 브라우저로 내보내지 말 것
        edicus-uid:     <고객 식별자>
        Content-Type:   application/json
```

공식 데모 `server.js` 머리말이 명시합니다.

> 아래 function들은 원래 고객사의 server에서 api형태로 구현되어 사용되어야 합니다.
> 테스트의 편의상 client-side에서 구현되었습니다.
> 실제 구현의 호출 흐름은 다음과 같아야 합니다.
> `browser <-- partner사 server <-- edicus api server`

**uid 는 반드시 편집기 토큰 발급 때 쓴 값과 같아야 합니다.**
우리 코드에서는 `edicus_lookup.guest_uid(partner, site_cd, guest_id)` 가 만듭니다.

```
uid = ("mo-" + base64url(sha256(f"{partner}:{site_cd}:{guest_id}")))[:50]
```

**오류는 두 겹입니다.** HTTP 상태 코드와, 본문의 `err` 키. HTTP 200 이어도 `err` 가 있으면
실패입니다. `edicus_lookup._edicus_api()` 가 둘 다 처리합니다.

---

## 엔드포인트

| # | Method | Path | 용도 | 우리 구현 |
|---|---|---|---|---|
| 1 | POST | `/api/auth/token` | 편집기용 사용자 토큰 발급 | ✅ `issue_token()` — 호출 중 |
| 2 | GET | `/api/projects` | 프로젝트 목록 | ❌ 미사용 |
| 3 | GET | `/api/projects/{prjid}` | 프로젝트 상태·`order_id` 조회 | ⬜ `get_project()` — 배선 전 |
| 4 | POST | `/api/projects/{prjid}/order/tentative` | 잠정주문 | ⬜ `tentative_order()` — 배선 전 |
| 5 | POST | `/api/projects/{prjid}/order/definitive` | 확정주문 | ⬜ `definitive_order()` — 배선 전 |
| 6 | POST | `/api/orders/{order_id}/cancel` | 잠정주문 취소 ★경로 다름 | ⬜ `cancel_order()` — 배선 전 |
| 7 | POST | `/api/projects/{prjid}/clone` | 프로젝트 복제(재주문) | ⬜ `clone_project()` — 배선 전 |
| 8 | DELETE | `/api/projects/{prjid}` | 프로젝트 삭제 | ⬜ `delete_project()` — 배선 전 |
| 9 | GET | `/api/projects/{prjid}/preview_urls` | 미리보기 이미지 URL | ❌ 미사용 |
| 10 | POST | `/api/auth/staff/token` | 직원용 토큰(`edicus-email`/`edicus-pwd`) | ❌ 미사용 |
| 11 | POST | `/api/projects/{prjid}/order/tentative_with_vdp` | 가변데이터 잠정주문 | ❌ 해당 없음 |

`⬜` = 호출 함수는 `edicus_lookup.py` 에 있으나 **아무도 부르지 않음**.

---

## 주문 상태 기계

```
        tentative              definitive
editing ──────────▶ ordering ──────────────▶ ordered ──▶ (렌더링) ──▶ 3~4주 후 자동삭제
   ▲                    │
   └────────────────────┘
          cancel
```

| 상태 | 편집 | 저장 | 취소 | 설명 |
|---|:-:|:-:|:-:|---|
| `editing` | O | O | — | 디자인 작업 중. **잠정주문은 이 상태에서만 됨** |
| `ordering` | 열림 | ✕ | O | 잠정주문. 편집기는 열리지만 저장 불가. **확정주문은 이 상태에서만 됨** |
| `ordered` | ✕ | ✕ | ✕ | 확정. 생산파일(PDF·JPG) 렌더링 시작. **취소 불가** |

취소하면 `ordering` → `editing` 으로 되돌아가 고객이 다시 편집할 수 있습니다.

---

## 잠정주문 본문

`demo-basic/order.js` 에서 그대로:

```json
{
  "order_for_test":   false,
  "order_count":      1,
  "total_price":      23500,
  "partner_order_id": "우리 주문번호",
  "order_name":       "실제 주문자명"
}
```

| 필드 | 주의 |
|---|---|
| `order_count` | ★ **수수료 정산 데이터** — 정확히 넣어야 합니다 (데모 주석 명시) |
| `total_price` | ★ **수수료 정산 데이터** — 정확히 넣어야 합니다 (데모 주석 명시) |
| `partner_order_id` | Edicus 주문번호에 대응하는 우리 주문번호. 주문 추적에 씁니다 |
| `order_for_test` | 기본 `false` |

확정주문(`definitive`)과 취소(`cancel`) 본문은 **비웁니다**.

---

## ⚠️ 놓치기 쉬운 3가지

### 1. 취소 경로만 다릅니다

```
잠정  POST /api/projects/{prjid}/order/tentative
확정  POST /api/projects/{prjid}/order/definitive
취소  POST /api/orders/{order_id}/cancel          ← prjid 아님!
```

`order_id` 는 잠정주문 응답, 또는 `GET /api/projects/{prjid}` 응답에서 얻습니다
(공식 데모 `index.js`: `context.orderId = projectData.order_id`).
**우리 주문 레코드에 저장하지 않으면 취소할 방법이 없습니다.**

### 2. uid 재현이 안 되면 아무것도 못 부릅니다

모든 주문 API가 `edicus-uid` 를 요구합니다. 주문 레코드에 `guest_id` 와 `site_cd` 가
남아 있어야 `guest_uid()` 로 재현할 수 있습니다. **없다면 그것부터 저장하세요.**

### 3. 주문된 프로젝트를 편집기로 열지 마세요

열어서 고칠 수는 있지만 **주문된 정보는 바뀌지 않습니다.** 고객은 수정했다고 믿는데
인쇄물은 그대로 나가는, 가장 조용한 클레임 경로입니다.

---

## 미확인 — 실제 응답을 보고 확정해야 하는 것

| 항목 | 왜 미확인인가 |
|---|---|
| `GET /api/projects/{prjid}` 응답에서 **상태가 실리는 키** | 공식 데모가 표를 그리기만 하고 키를 못박지 않음. `order.status` 인지 최상위 `status` 인지 불명. **응답 1건 받아보고 확정할 것** |
| `preview_urls` 응답 구조 | 우리가 안 쓰므로 미조사 |
| 미주문 프로젝트 자동삭제 기간 | Edicus 문서에 없음 — 모션원 문의 필요 |
| 주문완료 후 "3~4주"의 정확한 일수·기준 시점 | 범위라서 상한 계산 불가 — 모션원 문의 필요 |

---

## 참고 문서 (모션원 · 접근 권한 필요)

`demo-basic/server.js` 주석에 걸린 링크입니다.

- Edicus Javascript SDK — `docs.google.com/document/d/1buvh-TjQtAqddAD4-QFxBHKFDESRxInsxFcViuEwNZc`
- Edicus Server API — `docs.google.com/document/d/1OhWdgv9Sz8By4N48eY0uO_84M3keLVQvdpdpK9u_3bA`
