# M1 진행 기록 — 위젯 본체 (`plan-huniweb`)

**카드**: M1 — 위젯 본체
**상태**: ✅ **완료** (2026-09-02)
**질문**: 위젯은 고객에게 무엇을 시키고, 무엇을 만들어내며, 그것을 어디로 넘기는가.

---

## [HARD] 순서 준수 기록

| 단계 | 상태 | 근거 |
|---|---|---|
| ① **앱 내장 매뉴얼 2종 정독** | ✅ | `raw/webadmin/tools/manual_content.py` **924줄 전문** · `tools/widget_manual_content.py` **821줄 전문**. 코드보다 먼저 읽었다 |
| ② **라이브 webadmin 실화면 관찰** | ✅ | `https://huni-admin.printly.co.kr` 로그인(gstack 헤드리스) → 사이드바 전수 → **SDK 개발가이드 2,132줄** → **임베드 라이브 데모** 실동작 |
| ③ **코드 대조** | ✅ | `widget_api.py`(4,666줄) 핵심 구간 · `models.py` · `work_margin.py` · `widget_renderer.js` · `urls.py` · 자사몰 `widget-order.ts`·`huni-widget.tsx` |

> ②에서 상품(위젯) 하나를 끝까지 몰아보되 **주문 직전에 멈췄다.**
> 「장바구니 담기」 버튼을 누르지 않았고, 파일 업로드·편집기 열기도 하지 않았다(외부 SaaS 호출·S3 오브젝트 생성 방지).

---

## 산출물

| 파일 | 내용 | 규모 |
|---|---|---|
| `widget-anatomy.md` | 위젯 해부 — 소스 20종·컨트롤 26종 코드표(라이브 DB 실측), 항목 스키마, 셋트 구조, 게시/버전/사이트키 | 10절 |
| `customer-journey.md` | 고객 여정 10단계, 단계별 필수/선택, 이벤트 계약 7종, state 실측, 담당 경계, 보관기간 | 7절 |
| `artwork-flow.md` | 파일업로드 3층 검증·승격, Edicus 4단계, 디자인 고정사양, 오류코드 17종, 프리플라이트 현황 | 6절 |
| **`production-payload.md`** ★ | **생산 payload 25키 전수 + 자재 3경로 + 공정 단일/셋트 분기 + work_size + 원고 원장 + M3 인계표** | 9절 |
| `l0-corrections.md` | L0 교정 8건(치명 2·중대 2·기타 4) + 보강 5건 + 유지 3건 | — |
| `progress.md` | 이 문서 | — |

---

## 완료조건 대조

| # | 완료조건 | 충족 | 어디에 |
|---|---|---|---|
| ① | **매뉴얼 정독 근거(어느 매뉴얼 어느 절) 명시** | ✅ | 전 산출물에 `manual_content.py` / `widget_manual_content.py` 의 섹션명(`OVERVIEW`·`COMPONENTS`·`COMMON_PROPS`·`FIELD_REF`·`PUBLISH_NOTES`·`EMBED_NOTES`·`FAQ`) 인용 |
| ② | **라이브 실화면 관찰 근거(화면·경로) 명시** | ✅ | `/sdk/demo/?wgt=WGT_000288` 스크린샷 + `huni:change` 이벤트 전문 캡처 + `GET /api/w/v1/widgets/{cd}` 응답 + 라이브 DB 읽기전용 SELECT 5종 |
| ③ | **고객 여정 단계마다 「무엇이 필수/선택인가」** | ✅ | `customer-journey.md` §1 (사양·수량·제목·원고 4구간 표) |
| ④ | **생산 payload 필드 전수 + 미확인 표시** | ✅ | `production-payload.md` §1 (25키+`work_size`) · §9 미확인 8건 |
| ⑤ | **L0 교정 지점 지목** | ✅ | `l0-corrections.md` — 교정 8 · 보강 5 · 유지 3 |

---

## ★ M3 에게 넘기는 것 (인계 요약)

`production-payload.md` §7·§8 이 본문. 요지 5가지:

1. **생산 사양의 원장은 `t_ord_orders.payload`**(서명 payload 통째, JSONB). 키는 `(site_cd, shop_ord_no, shop_line_no)`.
2. **자재는 4경로** — `payload.combo`(★조합템플릿이 확정, 서버 재조회) · `selections.mat_cd` · `set.members[].mat_cd` · `spine.ring`.
3. **공정은 단일/셋트 분기 필수** — 단일 `payload.proc_sels[]`, **셋트는 `payload.set.members[].procs` / `set_procs`** (셋트의 `proc_sels` 는 **비어 있다**).
4. **원고 실파일 키는 payload 가 아니라 `t_ord_artworks.ord_key`** — 「payload 의 키로는 MES 가 가져갈 수 없다」(`models.py:1086`). 편집기 원고는 `payload.editors[].result.prjid` + `payload.edicus_uid`.
5. **생산 치수는 `payload.work_size`** — 완성사이즈가 아니다. `order/register` 시점에 서버가 주입. ⚠ 매뉴얼상 「작업여백을 쓰는 공정이 아직 없다」 → 현재 대부분 `null` 추정, **M3 라이브 실측 필요**.

**M3 가 먼저 읽어야 할 문서 (L0 지도에 없음)**
- `raw/webadmin/docs/order-to-mes-process.md` (**737줄**) ← 코드가 §4·§6.5 를 직접 인용
- `raw/webadmin/docs/order-to-mes-diagrams.md` (306줄)
- `raw/webadmin/docs/artwork-scan-integration.md` 외 2종 (프리플라이트 설계)
- `raw/webadmin/docs/aws-architecture-huni.md` (M3 카드 지목 PDF 의 md 판본)

**M3 가 확정해야 할 판정 2건** (M1 은 「코드에 인계 호출부가 없다」까지만 관측):
- 프리플라이트 구현/미구현/부분
- MES 접수 구현/미구현/부분

---

## ★ M2 에게 넘기는 것 (계약 축 · 치명 2건)

M1 이 발견했으나 **판정 주체는 M2**다. `l0-corrections.md` C-1·C-2 참조.

| # | 발견 | 요지 |
|---|---|---|
| **C-1** | **optionInputs 규약 드리프트 (보안)** | 현행 계약은 `huni_item`+`huni_order` 2칸·**토큰 금지**인데, 자사몰은 `huni_token`(서명 토큰) + `huni_order`(**`files` S3 키·`editors` prjid 포함**)를 싣는다. 텍스트 옵션은 **주문조회 응답으로 그대로 읽힌다** |
| **C-2** | **`orderCnt` 반올림** | 자사몰 `Math.round(total/10)` — 계약은 **반올림 금지**(`price_unit_mismatch` 가드 무력화) |
| **C-3** | **`cart/*` 4종 미사용** | 자사몰에 `cart/items`·`X-Huni-Server-Key` 호출 0건. 레거시(`/handoff/requote`) 경로만 사용 |
| **C-4** | **프로모션 충돌 답이 이미 있음** | SDK 가이드 §11: 쿠폰·적립금 **안전** / 수량·중량 배송비 **영구금지** / 재고=결제한도. M2 는 조사 대신 **설정 점검 항목**으로 전환 |

**M2 의 1차 참조**: `https://huni-admin.printly.co.kr/sdk/guide/` §9(장바구니 9절)·§10(주문등록·담당경계)·§11(샵바이 연동 규칙)·§14(API 레퍼런스)·§15(오류코드 70여 개)

---

## ★ lead 에게 넘기는 것 (런웨이 항목 후보)

| 우선 | 항목 | 근거 |
|---|---|---|
| 🔴 최우선 | **종단 1건 관통** — 위젯→담기→결제→주문등록→원고승격 | `t_ord_orders` **0행**, `t_wgt_cart_items` **0행**, `t_ord_artworks` **0행** (라이브 실측) |
| 🔴 | **optionInputs 규약 정합** (C-1) | 보안 + 조용한 실패 위험 |
| 🔴 | **`orderCnt` 반올림 제거** (C-2) | 청구액 오차 위험 |
| 🟠 | **게시 위젯 없는 판매상품 77건 해소** | 판매중 269 vs 게시위젯보유 193 |
| 🟠 | **샵바이 금지 설정 점검** (수량·중량 배송비 / 최대구매수량 / 즉시할인 OFF, 판매가 10원 226건 유지) | SDK 가이드 §11 |
| 🟠 | **프리플라이트 구현 여부 확정 + 계약 정합** | 가이드 §10 은 「파일 오류 검사 = 후니 몫」으로 약속했으나 코드에 없음 |
| 🟡 | **트윈링 계열 위젯에 부속 색상 컴포넌트 배치 검토** | `WGT_SRC_TYPE.19` 라이브 배치 **0건** |
| 🟡 | **운영 최종 도메인 확정** | `allow_domains` 10개 중 무엇이 런칭 대상인지 미확인 |
| 🟡 | **셋트 위젯 summary 후가공 라벨 표시 결함** | 라이브 재현: 표지코팅·박가공·형압 3라벨이 전부 「디지털인쇄」 표시. `huni_order` 로 셀러어드민에 노출됨 |
| 🟡 | **매뉴얼 누락 5건 보강** | `widget-anatomy.md` §9 |

---

## 준수 확인

- ✅ **읽기전용** — 주문·결제·폼제출·DB write 없음. 라이브 DB 는 `SELECT` 만.
- ✅ **`L0/M1/` 안에만 작성** — 다른 디렉터리 미수정.
- ✅ **커밋·푸시·`git add -A` 없음.**
- ✅ **추정으로 빈칸 메우지 않음** — 각 문서 말미에 「미확인」 절.
- ✅ **매뉴얼 우선** — 코드보다 매뉴얼을 먼저 읽었다.

---

## 작업 로그

| 순서 | 행위 |
|---|---|
| 1 | 카드·`huni-webadmin-manual-first.md` 규칙 정독 |
| 2 | 위젯빌더 매뉴얼 원고 821줄 전문 정독 |
| 3 | 운영자 매뉴얼 원고 924줄 전문 정독 |
| 4 | 라이브 admin 로그인 → 사이드바 전수 → **「개발자 문서(외부 공개)」 발견** |
| 5 | SDK 개발가이드 2,132줄 전문 정독 |
| 6 | 라이브 데모에서 핀버튼(단일)·무선책자(셋트) 위젯 실동작 관찰, 읽기전용 이벤트 리스너로 state 전문 캡처, 스크린샷 |
| 7 | `GET /api/w/v1/widgets/{WGT_000005, WGT_000288}` 구성 원본 취득 |
| 8 | 코드 대조 — `_quote()` payload 조립부·`api_order_register`·`_promote_artwork`·`work_margin.py`·`models.py` |
| 9 | 라이브 DB 읽기전용 SELECT 6종 (코드표·위젯상태·상품갭·컴포넌트분포·주문행수·사이트키) |
| 10 | 자사몰 `huni-skin-shopby` 대조 → **C-1·C-2 드리프트 확정** |
| 11 | 산출물 6종 작성 |
