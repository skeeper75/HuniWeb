# reconcile.md — Claude 판정 vs Codex 가설 대조 (scope-gate 입력)

> 산출: hls-codex-verifier · 2026-06-30 · Huni-Launch-Scope(§28)
> 위상[HARD]: 합의=고신뢰 / 불일치=조사 신호로만 분류. **채택 결정은 scope-gate 몫**(여기서 확정 아님).
> Codex 가설 = 외부 의견. Claude가 `docs/shopby/` 원문으로 별도 확증한 항목은 ★표기.
> Codex 한계: workdir=launch-scope로 한정 → Codex는 `docs/shopby` 미접근(API 존재성 일부 오판) → Claude가 보정.

---

## 1. 합의 (AGREEMENT) — 고신뢰. 생성측이 보강해야 할 실결함

| # | 합의 내용 | Claude 사전판정 | Codex | 권고 |
|---|-----------|----------------|--------|------|
| A1 | **No80 결제 SOLVED는 가격브리지에 종속 — 표면 SOLVED 위험** | 동일(MED→상향) | G-Q1 HIGH | 결제는 라인가가 후니 계산가와 일치해야 `paymentAmtForVerification` 재계산이 맞음. 가격브리지(OQ-G1) 미해소 시 결제 SOLVED 무효 → **SOLVED→조건부(가격브리지 종속) 재표기** |
| A2 | **가격브리지가 1차 핵심 미해결** — P-A는 유한·소조합만, **연속/면적/구간(견적형 핵심)은 무손실 경로 미확정** | 동일(HIGH·중심 리스크) | G-Q2 HIGH·최다위험 | 양측 독립으로 **동일하게 "가장 위험한 오판"** 지목. 견적형(자동견적의 본질) 상품군은 P-A 불가·P-B 미확인·placeholder 왜곡 → **런칭 전 결정 gate** |
| A3 | **placeholder qty=1+총액옵션이 정산/통계/생산수량 왜곡** | 동일(정산) | G-Q2 HIGH(+쿠폰·환불·세금·매출통계·생산수량 차원 추가) | Codex가 왜곡 차원을 확장(생산수량까지). 채택 |
| A4 | **P-B 자동승인 예외는 가정이지 capability 아님** | 동일 | G-Q3 HIGH | 팀도 OQ-G2로 플래그함 — 합의. capability map에서 "리스크"로 명시 격하 |
| A5 | **Plan A 만료 오표기 — 비만료 선불금에 정책 유효기간 주입 시 돈 소멸** | 동일(HIGH) | M-Q1 HIGH | ★기본값을 "제한없음"으로(원천 잔여 유효기간 확증 전 소멸 금지) |
| A6 | **합계 대사(P-G1)만으로 불충분 — 전 회원 전수 diff 필요** | 동일(샘플만은 약함) | M-Q2 HIGH(회원 간 스왑 못잡음) | Codex가 날카롭게 보강: P-G3 샘플→전수 `구잔액↔available_amount` diff/hash 게이트 추가 |
| A7 | **★마케팅 동의 내부모순** — member-spec §4(재동의 권고) ↔ field-mapping row8("원천 없으면 이관일로 기록") | (미사전판정) | M-Q3 HIGH | **Codex 신규 적발**. 동의일시 날조 소지·법적 리스크. field-mapping을 "원천 없으면 마케팅Y 보류"로 교정 |
| A8 | **음수 잔액(미수금)·부분사용 후 DELETE 롤백 한계** | 동일(음수=보류는 인지) | M-Q1 HIGH | 팀도 §5에서 음수=보류 처리. Codex가 P-G1 등식과의 충돌·partial-use rollback 불능을 명확화 → 게이트 보강 |

---

## 2. 불일치 / 조사 신호 (INVESTIGATION) — scope-gate가 재실측 후 결정

| # | Codex 가설 | Claude 대조 | 분류 |
|---|-----------|------------|------|
| I1 | No9·24·78·79·81·94·123 → PARTIAL 하향 (G-Q1) | **부분 동의.** SOLVED는 *native 메커니즘*(주문조회 API·expel API)엔 옳음. Codex가 잡은 건 *인쇄/B2B 래퍼*(생산상태·파일결선·사업자필드)인데 팀은 이를 **별도 행**(No10·157·161·5·26·27)으로 추적 중. = **분류 입도(granularity) 불일치**: "SOLVED=기능의 native 메커니즘" vs "SOLVED=인쇄 end-to-end 사용가능". **No123·No81은 Codex 쪽(HIGH)** — 회원관리/주문완료는 사업자·파일·생산데이터 결선 없이는 실사용 불가. No9·78·79는 인접행이 갭을 이미 포착 → 팀 분류 유지 가능 | scope-gate가 SOLVED 정의 확정 후 일괄 재라벨 |
| I2 | 회원 사업자정보 customField 근거 없음 (G-Q3 HIGH) | ★Claude 확증: member extraInfo(추가항목 TEXTBOX)는 `configurations-member-extra-info-config`로 **존재**. 단 **수용 개수/검색/관리 범위는 미확정**(OQ-G5·MQ-12). customField라는 용어 자체보다 extraInfo 용량이 관건 | 환각 아님·용량 재실측 신호 |
| I3 | 주문 webhook 가정 (G-Q3 MED) | ★Claude 확증: `/webhooks/failed`만 grep 확인·**주문/ACCUMULATION 이벤트 webhook 카탈로그 미확인**. polling/조회 기반이면 생산BOM 아키텍처 상이 | 조사 신호(MED) — webhook 이벤트 목록 재실측 |
| I4 | 정산이 라인가 권위인지 미확인 (G-Q3·G-Q4 HIGH) | 동의. OQ-G3 그대로 open. Codex 기여=**"런칭 후 검증"이 아니라 "런칭 전 gate"로 우선순위 격상** | 우선순위 격상 신호(사실 아닌 우선순위) |
| I5 | cart→order-sheet→calculate→reserve submit path 명세 누락 (G-Q4 HIGH) | ★Claude 확증: `POST /order-sheets`·`/order-sheets/{}/calculate`·`GET /cart/calculate` 전부 스펙 존재. 팀 dev-plan은 cart(F4)·결제(No80)만 명세·**주문서 단계 미닫음** = 진짜 명세 공백 | 명세 보강 신호(HIGH) |
| I6 | 사업자정보(No26/27) 2차 배치가 위험 (G-Q4 MED/HIGH) | 동의. 라이브 회원=세금계산서용 사업자필드 보유·LAUNCH flag인데 2차. 회원가입(1차)이 B2B 필드 미수집이면 결손 | 1차 승격 검토 신호 |
| I7 | Edicus 3차 이관 위험 (G-Q4 MED) | 조건부. **상품범위 결정(OQ-G16)에 종속** — 온라인 편집상품을 런칭에 넣으면 3차 부적절. 1차 PDF만이면 정당 | 상품범위 결정 종속 |
| I8 | 회사주소를 배송지 주소록에 = 의미 손상 가능 (M-Q3 HIGH) | 동의. 청구지/사업장 vs 배송지 용도 미확정(MQ-13). 용도 확정 전 주소록 적재는 분류 오류 위험 | 용도 재실측 신호 |
| I9 | 가입일/휴면/등급 "native 손실없음" 단정 과함 (M-Q3 HIGH) | 동의. registerYmdt 보존 가능 여부가 import 시 미확정 — 불가 시 가입연차/등급혜택 왜곡 | 재실측 신호 |

---

## 3. Codex 가설 중 **반박/보정** (★Claude가 docs/shopby로 확증 — Codex 접근한계 보정)

> 이 절이 본 검증의 핵심 가치: Codex의 "환각" 가설 다수가 **Codex workdir 한계(docs/shopby 미접근)** 때문. Claude가 스펙으로 확증해 **false alarm을 걸러냄**.

| # | Codex 가설(M-Q4) | Claude 스펙 확증 | 판정 |
|---|-----------------|-----------------|------|
| R1 | externalKey가 멱등/롤백키라는 가정=환각 의심 (HIGH) | ★`docs/shopby/.../04_server-api/manage.mdx`: `POST /profile/accumulations`·`DELETE /profile/accumulations` **존재**, `externalKey`(query, **최대 60자**) **존재** | **부분 반박**: API·필드 실재(환각 아님). 단 externalKey 설명="외부 키(**조회용**)" → **unique constraint/멱등 semantics는 스펙 미명시** = 잔여 MED 조사 신호(존재성≠멱등보장) |
| R2 | 어드민 Excel 일괄지급 = API 동등 통제성 가정 (MED) | ★`member/list.mdx:174`·`accumulation-payment-deduct` **존재**(적립금 일괄 지급/차감·엑셀 일괄 등록) | **반박**: Excel 일괄지급 실재. 단 **Excel 경로의 externalKey/멱등재실행 지원은 미명시** → 서버API 경로가 멱등엔 우월. 잔여 MED |
| R3 | DELETE가 특정 grant 삭제하는지 가정 (HIGH) | ★DELETE 엔드포인트 실재·externalKey query 받음 | **부분 반박**: 엔드포인트 실재. 단 **partial-spent grant 동작·"취소 vs 차감" semantics는 스펙 미상** = M-Q1 partial-use 위험과 동일 잔여 신호(HIGH 유지) |
| R4 | 적립금 명칭="프린팅머니" 단정 vs open 충돌 (HIGH) | ★`accumulation-setting.mdx:20-24`: 적립금 명칭 변경 **가능**. 단 **"쇼핑몰에만 반영·어드민 미반영"** | **반박(명칭변경 가능=사실)**. Codex의 "충돌"은 false positive. 단 팀이 놓친 진짜 단서=**어드민엔 여전히 "적립금" 표기** → UX 보정 필요(MED) |
| R5 | 회원 bulk create/profile-bulk 미검증 (MED) | ★`member.mdx`: `PUT /profile/bulk`(대량 수정)·`POST /profile/bulk-delete` **존재**·단건 `post-profile` 존재 | **부분 반박**: bulk **수정/삭제** 실재. **bulk create 단일 엔드포인트는 미확인**(단건 post-profile 반복) → 적재 성능 설계 시 확인(MED) |
| R6 | registerYmdt/dormant/expelled를 write 필드로 (HIGH) | 스펙상 필드 실재하나 **import(쓰기) 가능 여부는 별도** | **유지(조사 신호)**: Codex 지적 타당. 존재≠import 가능. 재실측 |

**옵션 5축 제한 확증:** ★`product/.../option.mdx:44` "선택형 옵션 최대 5개" — 팀의 핵심 전제(5축 초과→위젯이 옵션 소유)는 **스펙 정합**(환각 아님). 위젯 CUSTOM 결정 정당.

---

## 4. Codex가 적발한 생성측 false-positive (과분류) — 디스코핑 신호

> Codex Q5 = 팀이 CUSTOM/PARTIAL로 과분류한 것. 채택 시 개발량 절감. scope-gate 판단.

- No56 템플릿 다운로드(HIGH)·No57/58/60 가이드 모달(MED)·No66 상세설명(MED)·No151 배송비 템플릿(MED) → 정적/native SOLVED·SKIN 가능. **단 No47 개별포장은 포장가가 동적이면 PARTIAL 유지**(조건부). Claude 동의: 대부분 2·3차 정적 콘텐츠라 영향 낮음·과한 BFF 귀속 정리 가치 있음.

---

## 5. scope-gate 핸드오프 — 우선순위

1. **[GATE·런칭 전]** 가격브리지 결정(A1·A2·A3·A4·I4·I5) — 견적형(연속/면적/구간) 무손실 경로 + 정산 권위(OQ-G3) + 주문서 submit path 명세. **최우선 돈/주문 크리티컬.**
2. **[돈·머니]** Plan A 보강(A5·A6·A8·R1·R3) — 만료 기본값=제한없음·전 회원 전수 대사 게이트·partial-use rollback/externalKey 멱등 semantics 라이브 실측.
3. **[법적·이관]** A7 마케팅 동의 모순 교정·I8 회사주소 용도·I9 가입일 보존 재실측.
4. **[분류]** I1 SOLVED 정의 확정 후 No123·No81 등 재라벨·I6 사업자 1차 승격 검토.
5. **[디스코핑]** §4 false-positive 정리(개발량 절감).
6. **[보정 적용]** R1~R6·옵션5축은 **환각 아님(스펙 확증)** — 생성측 명세 유지하되 잔여 semantics(멱등·partial-spent·어드민 명칭)만 라이브 실측으로 확정.
