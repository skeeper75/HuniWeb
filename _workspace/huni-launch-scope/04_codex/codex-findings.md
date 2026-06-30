# codex-findings.md — Codex(gpt-5.5) 독립 2차 교차검증 가설

> 산출: hls-codex-verifier · 2026-06-30 · Huni-Launch-Scope(§28)
> Codex 가용: **AVAILABLE (gpt-5.5, reasoning high)**. codex-review.sh `-s read-only` 2회 호출.
> ★[HARD] Codex 산출 = **가설(외부 의견)**. Shopby 스펙·IA·라이브로 확증되기 전 사실 아님.
> 독립성 보장: Codex에 Claude 판정 미노출. 원문(02_gap·03_migration·01_foundation·00_live)만 주고 독립 의견 수령.
> ★Codex workdir = `_workspace/huni-launch-scope/`로 한정 → Codex는 `docs/shopby/` 원문 **접근 불가**.
>   이 때문에 Codex의 "API 환각" 류 가설은 접근 한계 가능성이 있어, Claude가 `docs/shopby`로 별도 확증함(reconcile 참조).

---

## A. 갭 검토 (02_gap) — Codex 가설

### G-Q1. 과대낙관 SOLVED (1차 17건 중)
| # | Codex 가설 | conf |
|---|-----------|------|
| No80 결제 | INICIS reserve는 native지만 **동적 계산가를 라인에 싣는 법 미확정·정산 권위 미확인** → "결제 버튼만 native"로 SOLVED 불가. PARTIAL/CUSTOM blocker | HIGH |
| No81 주문완료 | 화면/메일은 되나 **파일키·편집정보·생산BOM·작업지시 결선**은 별도 CUSTOM | HIGH |
| No123 회원관리 | 일반 회원조회 native라도 **사업자정보·회사주소2·프린팅머니·인쇄 주문정보** 별도 저장/이관 | HIGH |
| No9 주문조회 | native지만 인쇄주문은 파일/편집 미리보기·생산상태·BOM 결선(같은 IA No10 CUSTOM·No157 CUSTOM·No161 PARTIAL) | HIGH |
| No23 비번변경 | API native지만 **변경 전 본인확인 방법 미결정**(IA 선행조건) | MED |
| No24 탈퇴 | native expel API만으로 라이브 탈퇴폼(비번·이름·이메일·휴대폰·탈퇴사유) 흐름 대체 근거 약함 | MED |
| No78/79 배송지 | native 주소록이 **개인+회사1+회사2 다중주소** 보존까지 한다는 근거 없음 | MED |
| No94 관리자 | admin 권한 세분화 범위 open·인쇄 webadmin/MES/파일검수 역할 미포괄 | MED |
| No8 가입완료메일 | 계획·OQ 모두 native 템플릿 명시 부재 인정 | LOW |

### G-Q2. 가격 브리지 실행 가능성
- **P-A 사전 옵션행** = 유한·축≤5·고정 addPrice만 가능. **비규격 가로×세로·수량 직접입력·면적/구간단가는 옵션행 폭발(무한)**. IA가 비규격 면적계산·수량 직접입력을 P0로 둠. **(HIGH)**
- **P-B 직전 동적옵션** = 현재 "가정"이지 근거 아님. addPrice 변경 자동승인 예외 미확인·상품심사 판매차단 위험. **(HIGH)**
- **컨테이너 qty=1+총액 option amount** = Shopby가 금액을 salePrice+addPrice로 재계산·임의단가 없음. qty=1이면 **쿠폰·환불·세금계산서·매출통계·생산수량**이 라인 qty를 보면 전부 틀어짐. **(HIGH)**
- **BFF→evaluate_price→cart는 "일부 상품"만 coherent** — post-cart엔 productNo/optionNo/orderCnt/optionInputs만·가격 override 없음. 사전등록 optionNo 환원 가능 상품만 end-to-end 성립. 연속/면적/구간은 P-B·placeholder 검증 전까지 런칭 일반해 아님. **(HIGH)**

### G-Q3. 근거 없는 capability 주장(환각 의심)
- **회원 사업자정보 customField (HIGH)** — capability map에 회원 customField 근거 없음(★Claude 확증 필요).
- **P-B addPrice 자동승인 예외 (HIGH)** — capability 아니라 리스크.
- **주문 webhook (MED)** — 생산BOM이 "주문 webhook/조회" 전제하나 capability map에 webhook 근거 없음(polling이면 아키텍처 상이).
- **정산 안전성 (HIGH)** — 정산 native 존재 ≠ "후니 계산가 정산 안전". 라인가 권위 미확인.

### G-Q4. 누락/오후순위 1차 범위
- **cart→order-sheet→calculate→reserve 전체 submit path 명세 누락 (HIGH)** — cart·reserve만 언급, 주문서 생성/calculate 미닫음.
- **파일-to-order durable linkage 약함 (HIGH)** — optionInputs 텍스트는 식별 표시 채널이지 원고 권위 저장소/주문번호 매핑/재업로드/검수상태 모델 아님.
- **사업자정보(No26/27) 2차 배치 위험 (MED/HIGH)** — LAUNCH flag인데 2차. B2B/세금계산서면 1차 회원가입/수정과 함께 닫아야.
- **정산 권위(OQ-G3)가 open인 채 런칭 (HIGH)** — 가격브리지·세금·환불·통계 기준값 → 런칭 후가 아니라 **런칭 전 gate**여야.
- **Edicus 3차 이관 위험 (MED)** — IA가 편집상품 미리보기/썸네일 P0. 온라인 편집상품이 런칭범위면 3차 이관 부적절.

### G-Q5. False positive(팀이 과분류한 CUSTOM/PARTIAL)
- No56 템플릿 다운로드(HIGH)·No57/58/60 가이드 모달(MED)·No66 상세설명(MED)·No151 배송비 템플릿(MED)·No47 개별포장(LOW/MED, 단 동적가면 PARTIAL 유지) → 정적/native로 SOLVED·SKIN 가능. 과한 BFF·위젯 귀속.

### G 최다위험 오판(Codex)
> **"Shopby 결제/주문 native가 있으니 동적 인쇄가격도 브리지로 어떻게든 1차 런칭 가능"** 전제. P-A=소조합만·P-B=심사 미확인·placeholder=정산/수량/세금/환불 왜곡. 이 결정 미해소면 **No80 결제 SOLVED도 실제 SOLVED 아님.**

---

## B. 마이그레이션 검토 (03_migration) — Codex 가설

### M-Q1. Plan A 머니 손실/오표기
- **선불충전금→적립금 의미 손상 (HIGH)** — 선불금은 환불·예수금(회계) 성격. 적립금 grant로 법적/회계 의미 변동 가능.
- **만료 오표기 (HIGH)** — 잔여 유효기간 원천 미상인데 "정책값" 주입 → 소멸시점 연장/단축.
- **충전/사용 원장 손실 (HIGH)** — L1 잔액 1건 시드, 과거 거래 미룸. 선불이면 충전 PG·환불·소멸·차감사유가 **돈의 감사증적**. "돈 정확성의 자=잔액합계"는 과감.
- **음수 잔액/미수금 표현 불가 (HIGH)** — 적립금 음수 불가→제외 시 P-G1 등식 깨지거나 미수금이 별도 AR로 분리.
- **부분 사용 후 롤백 위험 (HIGH)** — DELETE는 보유액 부족 시 실패. 일부 사용 후 원 grant 삭제 불가·다른 적립금과 혼재 시 추적 모호.

### M-Q2. 대사 게이트 충분성
- **합계 대사 ≠ 충분 (HIGH)** — P-G1 총합 0원은 **회원 간 잔액 스왑** 못 잡음. P-G3는 "대표 샘플"만 → **전 회원 전수 diff/hash** 필요.
- **원장 방정식 부재 (HIGH)** — `opening+topups−uses−expiries−refunds=closing` 회원별 검증 없음.
- **동결/델타 선언만 (HIGH)** — 진행중 사용·승인지연·충전취소·환불·양쪽 사용금지창·최종 cutoff 시각 미명세.
- **Shopby 기존 적립금 baseline 분리 누락 (MED)** — 기존 적립금과 이관 grant 혼재. externalKey/tag·migration bucket·기존 baseline 분리 필요.

### M-Q3. 회원 이관 완전성
- **비번 전환 계정복구 리스크 과소 (HIGH)** — 이메일 중복/NULL/형식오류/오래된 이메일의 계정탈취·고객잠금 리스크.
- **★마케팅 동의 내부모순 (HIGH)** — 본문 §4=재동의 권고인데 **field-mapping은 "원천 없으면 이관일로 기록"** → 동의시각 허위/오해 소지. 원천 timestamp 없으면 마케팅 Y 활성 이관 말고 재동의까지 보류가 안전.
- **사업자/회사주소 의미 손상 (HIGH)** — 회사주소를 배송지 주소록에 넣는 건 실제 배송지일 때만 안전. **세금계산서 청구지/사업장이면 의미 상이**.
- **탈퇴사유 누락 (HIGH)** — 화면엔 탈퇴사유 있으나 Shopby 대상이 expelled 중심·보존 필드 불명.
- **가입일/휴면/등급 "native 손실없음" 단정 과함 (HIGH)** — 가입일 보존 가능 여부·휴면/등급 원천 미확정.

### M-Q4. API/기능 환각·미검증 가정 (★Claude 확증 대상 — Codex는 docs/shopby 미접근)
- **externalKey가 멱등/중복방지/롤백키라는 가정 (HIGH)** — 워크스페이스에 docs/shopby 부재·capability map에 근거 없다고 봄.
- **어드민 Excel 일괄지급이 API와 동등 통제성 가정 (MED)** — externalKey/멱등재실행/per-row rollback 지원 별도 검증.
- **DELETE /profile/accumulations가 특정 이관 grant 삭제 가정 (HIGH)** — "grant 취소"인지 "잔액 차감"인지·partial spent 처리 미검증.
- **적립금 명칭="프린팅머니" 단정 vs open question 충돌 (HIGH)**.
- **회원 bulk create/profile-bulk/externalKey 추적 미검증 (MED)**.
- **registerYmdt/dormant/expelled를 write/import 필드로 보는 점 (HIGH)** — read 필드인지 import 필드인지 확인 필요.

### M-Q5. False positive(과잉 우려)
- 양수 잔액 결제 사용(accumulationUseAmt)은 native 가능성 높음(MED).
- 비번 강제 미이관 결정은 과잉 아니라 정답에 가까움(HIGH).
- 회사주소가 실제 배송지면 주소록 사용 native 안전(MED).

### M 최다위험 오판(Codex)
> Plan A의 **"legacy 잔액 = 적립금 수동지급으로 무손실 시드 가능"** 결론. 원장·만료·음수 미수금·환불/충전 증적·partial-use rollback 전부 미확정인데 **잔액 합계만 맞으면 돈이 맞다**고 판단.
