# gate-verdict.md — L1~L7 독립 검증 게이트 판정

> 산출: hls-scope-gate · 2026-06-30 · Huni-Launch-Scope(§28)
> 위상[HARD]: **생성측 주장 비신뢰 — 직접 재실측**(IA 엑셀 원본·`docs/shopby` 원문·라이브 인벤토리). 이 문서는 판정·근거·라우팅. 사용자용 종합은 `후니프린팅_1차런칭_개발범위_Shopby갭_개발방안.md`.
> 종합 판정: **GO (조건부)** — 7게이트 중 hard NO-GO 0. L2/L3/L4는 교정·격상 조건을 최종 문서에 반영하는 조건부 GO.

---

## 0. 종합 스코어보드

| 게이트 | 판정 | 한 줄 |
|--------|------|-------|
| L1 IA 커버리지 누락 0 | **GO** | 162 고유·중복 0·canon↔fit-gap↔엑셀 원본(144+18=162) 3중 일치 |
| L2 Shopby 근거 정합 | **GO(재라벨 조건)** | 표본 operationId 전건 실재·가격주입 필드 0건 source 확증. 단 No80/81/123 과대낙관 → 재라벨 적용 |
| L3 개발방안 실현성 | **GO(격상 조건)** | 담을자리/연동/계약 구체·인쇄 특수성 SOLVED 뭉갬 없음. 단 가격브리지 GATE 격상·주문서 submit path 명세 추가 |
| L4 마이그레이션 정합 | **GO(교정 조건)** | 합계대사·비번 전환·약관 재동의 설계 건전. 단 A5·A6·A7 3건 교정 적용 |
| L5 1차 범위 완전성 | **GO** | 마이페이지 33 라이브 인벤토리 IA 매핑·상품리스트·견적형 위젯 커버 |
| L6 codex 수렴 | **GO** | 조사 9건 전부 해소/라우팅·반박 6건 source 확증·false-positive 5건 디스코핑 |
| L7 생성검증 독립성 | **GO** | 엑셀 원본 카운트·docs/shopby grep·필드 0건 전수·A7 모순 직접 적발 = 생성측 복사 아님 |

**재라벨 후 최종 판정 집계: SOLVED 48 / PARTIAL 53 / CUSTOM 61 (=162).**
(생성측 원안 SOLVED 45 / PARTIAL 56 / CUSTOM 61 → 본 게이트가 9건 재라벨)

---

## L1 — IA 커버리지 누락 0 · **GO**

재실측:
- `fit-gap-matrix.csv` no 1~162 **고유 162·중복 0**(deterministic count).
- `ia-feature-canon.csv` no 1~162, fit-gap과 **양방향 누락 0**(no 기준 join — canon→fitgap 누락 0, fitgap→canon 누락 0).
- ★IA 엑셀 원본(`02_IA마스터` 시트) 직접 재실측: 숫자 no 행 **162개**(min 1·max 162·중복 0), 헤더 표제 "기존 144 + 보강 18". = 생성측 CSV가 아닌 권위 엑셀에서 확인.

판정: 누락 0 입증. **GO.**

---

## L2 — Shopby 근거 정합 · **GO (재라벨 조건)**

재실측(docs/shopby 원문 grep):
- 표본 operationId **10/10 실재**: post-cart·get-cart-calculate·get-cart-validate·post-order-sheet·post-payments-reserve·paymentAmtForVerification·put-profile-expel·get-profile-email-exist·profile/accumulations·externalKey.
- ★가격 브리지 핵심 전제 source 확증: `order-shop-public.yml`에 **customPrice·orderPrice·priceOverride·unitPrice 전수 0건**, addPrice 52건 → "동적 계산가 카트 무손실 주입 불가·서버 salePrice+addPrice 재산출"이 **사실**(추정 아님).
- ★옵션 5축 제한 source 확증: `product/.../option.mdx:44` "선택형 옵션 ... 최대 5개"·45 "텍스트 옵션 ... 최대 5개" → 위젯이 옵션 소유 결정 정당.
- ★적립금 명칭 변경 가능: `management/accumulation-setting.mdx:20` "적립금 명칭/표시단위".

**과대낙관 적발(재라벨 필수):**
| no | 기능 | 원안 | 재판정 | 근거 |
|----|------|------|--------|------|
| 80 | 결제하기(이니시스) | SOLVED | **조건부(가격브리지 종속)** | 결제 anti-tamper(paymentAmtForVerification)가 라인가=후니계산가 일치 전제 → 가격브리지(L3) 미해소 시 결제 SOLVED 무효 (codex A1) |
| 123 | 회원관리(주문/정보) | SOLVED | **PARTIAL** | 사업자·파일·생산데이터 결선 없이 실사용 불가 (codex I1 HIGH) |
| 81 | 주문완료+메일 | SOLVED | **PARTIAL** | 인쇄 파일·생산 결선 없이 주문 end-to-end 불가 (codex I1 HIGH) |

**SOLVED 정의 확정[게이트 결정]:** SOLVED = "Shopby native 메커니즘/스킨으로 갭 없이 충족". No9·78·79처럼 native 메커니즘이 실재하고 인쇄 래퍼 갭이 **인접 행으로 별도 추적**되는 건은 SOLVED 유지. 인쇄 end-to-end가 그 행 자체에 걸린 No80/81/123만 하향.

판정: 표본 근거 정합 + 재라벨 적용으로 **GO.**

---

## L3 — 개발방안 실현성 · **GO (격상 조건)**

재실측:
- dev-plan-launch는 각 CUSTOM/PARTIAL에 담을자리·연동·데이터계약·트레이드오프·규모·선행조건을 명시 — 실현성 구체.
- ★인쇄 특수성을 SOLVED로 뭉갠 곳 **없음**: 동적가격(No49 XL)·옵션위젯(No33 L)·제약엔진(No48 L)·생산BOM(No157 L)·Edicus(No54 XL) 전부 CUSTOM. 양호.

**격상·보강 필수(codex A2·I4·I5 채택):**
1. **[GATE 격상]** 가격브리지를 "런칭 후"가 아닌 **런칭 전 hard GATE**로. 견적형(비규격 가로×세로·수량직접·면적/구간단가)은 P-A 불가·P-B 미확인 → **무손실 경로 미확정이 1차 최대 리스크**. (양측 독립으로 동일 지목)
2. **[명세 공백 닫기]** 주문서 submit path 명세 추가 — dev-plan은 cart(F4)·결제(No80)만 닫고 **주문서 단계 미명세**. ★source 확증: `post-order-sheet`·`post-order-sheets-{}-calculate` 실재 → 위젯 selections→cart→**order-sheet→calculate**→reserve 전 경로를 명세에 포함.
3. **[정산 권위]** OQ-G3(정산이 라인가/실청구액 중 무엇을 권위로) → 런칭 전 결정 GATE로 격상. placeholder 전략 시 정산 왜곡 검증 필수.

판정: 실현성 입증·격상 조건 최종 문서 반영으로 **GO.**

---

## L4 — 마이그레이션 정합 · **GO (교정 조건)**

재실측:
- 회원: native 수용 14필드·extraInfo 5·주소록 2·비번 이행불가→재인증(§3 A/B/C)·약관 재동의(§4). 합리적.
- 머니: 합계 대사 P-G1(Σ구잔액=Σ시드·차이 0원) = 돈 정확성의 자. externalKey 멱등·DELETE 롤백. 건전.
- ★API 실재 확증: profile/accumulations(POST/DELETE)·externalKey(최대 60자·조회용). = 잔액 시드 무손실 가능(환각 아님).

**교정 필수(codex A5·A6·A7 채택):**
| # | 결함 | 위치 | 교정 |
|---|------|------|------|
| A7 | **마케팅 동의 내부모순** | `migration-field-mapping.csv` 8행 "원천 없으면 **이관일로 기록**" ↔ member-spec §4 "재동의 권고" | **동의일시 날조 금지** → "원천 없으면 마케팅 수신 **보류·재동의 캠페인**"으로 통일(법적 리스크). field-mapping 8·9행 교정 라우팅 |
| A5 | Plan A 적립금 **만료 기본값** | printmoney §2 "없으면 정책값" | **기본값=제한없음**(원천 잔여 유효기간 확증 전 고객 돈 소멸 금지) 명문화 |
| A6 | **합계 대사만으로 불충분** | P-G3 샘플 1:1 | **전 회원 전수 `구잔액↔available_amount` diff/hash 게이트** 추가(회원 간 잔액 스왑 적발) |

판정: 설계 건전·3건 교정을 최종 문서 게이트에 반영하는 조건으로 **GO.** (단일 게이트 FAIL = 컷오버 NO-GO 원칙은 실 이관 트랙에서 유지)

---

## L5 — 1차 범위 완전성 · **GO**

재실측:
- 마이페이지 라이브 인벤토리 **33기능** 전건 IA대조라벨 보유 → IA가 라이브 As-Is 흡수.
- 견적형(`product/goods.asp` tmp_width/height+옵션+수량)·카탈로그형(`goods/view.asp` qty) 2갈래 = dev-plan 위젯+브리지가 양쪽 흡수.
- ★라이브 주문테이블 전무(to-be) 확정 → No162 "주문 런타임 그릇 구축"이 라이브 부재를 정확히 반영.
- 1차(64) 커버: 상품리스트(31·153·154)·회원/마이페이지 P0(9·10·21·22·23·24·29·31·123)·견적형 위젯(33·34~38·42·43·48·49·52·53·61~64)·생산브릿지(136·137·139·140·157~159·161·162).

한계 플래그: 라이브 cart 버튼 셀렉터 미검출(읽기탐색 한정·주문 동선 코드 미확인) → Shopby 그릇 채택으로 설계상 해소되나 **라이브 주문 동선 미검증** 명시.

판정: P0 세부까지 커버 입증. **GO.**

---

## L6 — codex 수렴 · **GO**

조사 9건(I1~I9) 전부 해소/라우팅:
| ID | 해소 |
|----|------|
| I1 | SOLVED 정의 확정(L2) → No123·81 PARTIAL·80 조건부 재라벨. No9/78/79 유지 |
| I2 | extraInfo 실재·용량 미확정 → 확인필요(MQ-12) 라우팅. 블로커 아님 |
| I3 | webhook 카탈로그 실재(order server-api) → §24 설계 상세 라우팅. polling 폴백 허용 |
| I4 | 정산 라인가 권위 → 런칭 전 GATE 격상(L3) |
| I5 | order-sheet submit path → source 실재 확인·명세 보강(L3) |
| I6 | 사업자정보 1차 승격 검토 → 회원가입(No5·1차)이 B2B 필드 수집하도록 결정사항 |
| I7 | Edicus 3차 → 상품범위 결정(OQ-G16) 종속. 1차 PDF만이면 정당 |
| I8 | 회사주소 용도 → 확인필요(MQ-13)·용도 확정 전 주소록 적재 보류 |
| I9 | 가입일 보존 → 확인필요(MQ-2)·registerYmdt import 가능 여부 재실측 |

반박/보정(R1~R6): Codex가 환각 의심한 API 다수가 **실재**(externalKey·Excel 일괄지급·DELETE·명칭변경·bulk 수정/삭제) = Codex workdir 한계(docs/shopby 미접근) 보정. 잔여 semantics(멱등·partial-spent·어드민 명칭)만 라이브 실측 신호로 유지.

false-positive 5건(§4): No56·57·58·60·66·151 정적/스킨 콘텐츠 = 과분류 → **디스코핑(PARTIAL→SOLVED)**. No47 개별포장은 포장가 동적이면 PARTIAL 유지.

판정: 불일치 전부 조사·해소. **GO.**

---

## L7 — 생성검증 독립성 · **GO**

독립 재실측 증거:
- IA 162를 생성측 CSV가 아닌 **엑셀 원본 02_IA마스터에서 직접 카운트**(144+18).
- operationId·가격주입 필드 0건·옵션 5축을 **docs/shopby 원문 grep**(생성측 인용 복사 아님).
- A7 마케팅 동의 모순을 **field-mapping.csv 8행 원문 직접 판독**으로 적발(codex 신규 + Claude 재확인).

판정: 생성측 주장 복사 아님. **GO.**

---

## NO-GO 라우팅 (해당 영역 되돌림)

hard NO-GO 0. 단 아래는 **실 진행 전 선행 GATE/교정**으로 라우팅(설계 문서는 GO·실 적용은 인간 승인 후):

| 라우팅 대상 | 무엇 |
|-------------|------|
| integration-architect/PM (§24) | 가격브리지 무손실 경로(견적형)·정산 권위(OQ-G3)·주문서 submit path 명세 — **런칭 전 hard GATE** |
| migration-designer | field-mapping 8·9행 A7 교정(재동의)·printmoney A5(만료 제한없음)·P-G3 전수 diff 게이트 추가(A6) |
| PM | 외부 계약(이니시스·알림톡/SMS·휴대폰인증·MES규격·파일검수)·사업자 1차 승격(I6)·상품범위/Edicus(OQ-G16) |
| dbmap/구현(§6·§7) | 실 회원/머니 이관·위젯 구현·DB 적재 = 인간 승인 후 위임(본 하네스는 설계·명세까지) |

---

## 미해소 리스크 (잔여)

1. **가격브리지(견적형) 무손실 경로 미확정** — P-A 조합폭발/P-B 심사리스크(OQ-G2 미확정)/placeholder 정산왜곡. 1차 최대 리스크.
2. **원천 구 DB 미접근** — 비번 해시·가입일·휴면/탈퇴 플래그·동의일시·잔액/원장 스키마 = 실 컬럼 미확정(MQ-1~20). 원천 제공 후 field-mapping 승격.
3. **라이브 주문 동선 코드 미검증** — cart 셀렉터 미검출(읽기탐색 한정).
4. **admin-analysis AGED(3.5개월)** — 어드민 native 분류 라이브 재확인 권장(OQ-G21).
5. **잔여 semantics 라이브 실측 대기** — externalKey 멱등 보장·partial-spent grant 동작·어드민 적립금 명칭.
