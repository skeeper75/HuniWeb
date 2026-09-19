# shopby — 결정·관리 안건 (screens.csv 밖 · 보충 4)

화면도 기능도 없는 안건이라 `screens.csv` 의 행이 아니다. 원장 자리는 9/17 `plan-rows.csv` 735행이며, 여기 싣는 것은 그 행을 이 카드가 어떻게 판정했는지 남기기 위해서다 — 이중계상하지 않는다.

| plan_row_id | 안건 | 미결 내용(완료 판정 기준) | 근거 | 결정 주체 |
|---|---|---|---|---|
| STD-PAY-024 | 카카오페이 신청 서류·절차 정리 후 전달 | 카카오페이 신청 서류 목록과 절차가 정리되어 담당자에게 전달되면 완료 | 후니정기미팅 정리260915.html §결제수단 · 미결 2 | 신우진 |
| STD-PAY-025 | 샵바이 어드민의 카카오페이 신청 경로 확인 | 샵바이 셀러어드민에서 카카오페이 신청 메뉴 경로를 찾아 화면 경로가 기록되면 완료 | 후니정기미팅 정리260915.html §결제수단 · 미결 3 | 최숙진 |
| STD-PAY-026 | 경로별 수수료 차이(이니시스 경유 +0.x% 여부) 확인 | 경유/직접 신청의 수수료율 차이가 숫자로 회신되어 기록되면 완료 | 후니정기미팅 정리260915.html §결제수단 · 미결 4 | 외부(이니시스·카카오페이) |
| STD-PAY-029 | 미입금 주문 자동취소 기간 정책 확정(현재 무통장 7영업일·가상계좌 7일) | PM 결정(예: 3영업일)이 회의록에 적히고 쇼핑몰 수정 값이 그 값이면 완료 | https://service.shopby.co.kr/mall/modification/81683 @ 2026-09-16 21:31 — 주문처리기간 설정: 무통장입금 주문완료 7영업일 이후 자동취소·가상계좌 7일 (R/R1d/evidence/24c-order-period.png) | 신우진 |
| STD-MYP-025 | 프린트머니 정책 — 소멸기한 없음·충전 1:1·추가 적립 없음 | 이용약관에 「프린트머니 소멸 없음」이 고지되고, 충전권 상품의 적립률이 0으로 설정되어 있으면 완료 | 후니정기미팅 정리260915.html §프린팅머니 · 확정 3 | 신우진 |
| STD-MYP-026 | 구 ASP 코드·DB 미제공 전제 — 이관 원천은 잔액 스냅샷만 | 구 사이트 회원별 프린트머니 잔액 스냅샷 파일이 1부 전달되면 완료 | 후니정기미팅 정리260915.html §프린팅머니 · 확정 4 | 최숙진 |
| STD-MYP-027 | 샵바이 외부포인트 연동 협의 완료 | 샵바이와의 외부포인트 연동 협의 결과가 문서로 남아 있으면 완료 — 정식 계약·플랜 적용은 별건 | 후니정기미팅 정리260915.html §프린팅머니 · 확정 6 | 외부(샵바이(NHN커머스)) |
| STD-MYP-051 | 프린트머니 결정 요청 — 원장 소유 결정 A(샵바이 적립금) vs B′(후니 원장+외부포인트 연동) | A/B′ 중 하나가 선택되어 설계 문서의 목표 아키텍처가 그 안으로 확정되면 완료 | _workspace/huni-shopby/17_prepaid-money/prepaid-money-design-260915.md:303 | 지니 |
| STD-MYP-052 | 프린트머니 결정 요청 — 충전 전용 입금계좌 분리 여부 · 과입금·부분입금 정책 | 입금계좌 분리 여부와 과입금·부분입금 처리 규칙이 문서에 적히면 완료 | _workspace/huni-shopby/17_prepaid-money/prepaid-money-design-260915.md:306 | 지니 |
| STD-MYP-053 | 테스트몰 실측 12항(전액결제 payType 조합·expireYmd 생략·externalKey 유일성·웹훅 페이로드 등) | 12항 각각에 실측 결과(값 또는 실패 사유)가 기록되면 완료 | _workspace/huni-shopby/HANDOFF.md:16 | 미정 |
| STD-PRM-021 | 080 수신거부 서비스 미도입 확정 | 080 수신거부 서비스 신청을 하지 않기로 한 결정이 기록되어 있으면 완료 | 후니정기미팅 정리260915.html §회원·로그인·인증 · 확정 4 | 신우진 |
| STD-SYS-039 | 웹훅 등록 화면 위치 확인(셀러어드민 내 미발견) 및 등록 여부 | 웹훅 URL 이 등록된 화면 캡처 1장 + 무통장 입금확인 1건에 t_ord_webhooks 1행이 생기면 완료(G2 ④) | https://service.shopby.co.kr 전체메뉴 98링크 중 webhook 0 · 앱 상세(Huni Admin) 항목=설치정보·API 권한 8종만 · Server API GET /webhooks 404·/webhooks/failed 400 (R/R1d/evidence/01-fullmenu-links.txt·42-app-huni-admin-detail.txt·api-get-log.txt) | 김동학 |
| STD-SYS-041 | 상품 텍스트옵션 라벨 huni_token 미등록 확정(U-2) → 스킨 담기 구현 정합 | 담기 1건 후 셀러어드민 주문 상세 옵션 칸에 huni_item·huni_order 두 값이 보이고 오류 없이 저장되면 완료 | API GET /products/136578130 mallProductInputs=[huni_order, huni_item] (huni_token 없음) @ 2026-09-16 21:31 (R/R1d/evidence/api-server-product-sample.json) · Q0 label-check 226건 참조 | 김동학 |
| STD-MFG-130 | 알림 발송 주체 경계 준수(주문·결제·배송=샵바이 / 파일=우리) | 셀러어드민 알림 템플릿에 파일 관련 알림이 없고, 우리 쪽에 주문·결제 알림이 없으면 완료. | [상위:STD-SYS-006] order-to-mes-process.md §10 표 \|\| P1판정(260902): §10 표 — 경계 자체는 문서로 확정(주문·결제·배송=샵바이 / 파일=우리) | 최숙진 |
| BLK-S2-2 | [선행 입력] 샵바이 어드민 웹훅 등록 현황(URL·구독 이벤트) | 결정·확인 기록 화면을 열어 「샵바이 어드민 웹훅 등록 현황(URL·구독 이벤트)」 가 적혀 있는지 조회한다 | .moai/specs/SPEC-LAUNCHPLAN-001/research.md:315 | 최숙진 |
| BLK-S3-1 | [선행 입력] 구 사이트 DB 접속 권한·경로 | 회신 메일·메신저 기록을 열어 「구 사이트 DB 접속 권한·경로」 값이 적혀 있는지 조회한다 | .moai/specs/SPEC-LAUNCHPLAN-001/research.md:325 | 외부(구 사이트 운영사) |
| BLK-S3-2 | [선행 입력] Shopby 회원 일괄등록 수단(어드민 엑셀 / Server API 부재 확인 / 외부회원연동) | 결정·확인 기록 화면을 열어 「Shopby 회원 일괄등록 수단(어드민 엑셀 / Server API 부재 확인 / 외부회원연동)」 가 적혀 있는지 조회한다 | .moai/specs/SPEC-LAUNCHPLAN-001/research.md:326 | 신우진 |
| BLK-S3-3 | [선행 입력] 이메일 NULL·중복 회원 규모와 처리 원칙 | 결정·확인 기록 화면을 열어 「이메일 NULL·중복 회원 규모와 처리 원칙」 가 적혀 있는지 조회한다 | .moai/specs/SPEC-LAUNCHPLAN-001/research.md:327 | 신우진 |
| BLK-S3-5 | [선행 입력] Shopby 엔터프라이즈 플랜·외부포인트 정식 적용(V9) + NHN 1:1 세팅 주체 | 회신 메일·메신저 기록을 열어 「Shopby 엔터프라이즈 플랜·외부포인트 정식 적용(V9) + NHN 1:1 세팅 주체」 값이 적혀 있는지 조회한다 | .moai/specs/SPEC-LAUNCHPLAN-001/research.md:329 | 외부(NHN커머스) |
| BLK-S3-10 | [선행 입력] 컷오버 동결 창·delta 규칙(구 사이트 충전·사용·가입 중단 가능 여부) | 회신 메일·메신저 기록을 열어 「컷오버 동결 창·delta 규칙(구 사이트 충전·사용·가입 중단 가능 여부)」 값이 적혀 있는지 조회한다 | .moai/specs/SPEC-LAUNCHPLAN-001/research.md:334 | 외부(구 사이트 운영사) |
