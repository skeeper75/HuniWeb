# t56 — 재배정 제안표 (제안까지 · 결정은 지니)

대상 = 사내 4담당이 든 행 중 판정이 담당맞음이 아닌 **216행**.
작업량 숫자·날짜 추정 없음. 근거 등급이 `rule-step`·`rule-track` 인 행은 **약한 근거**로, 실측 후 확정해야 한다.

## 이동 흐름(재배정만)

| 현재 → 제안 | 행수 |
|---|---|
| 김동학 → 최숙진 | 27 |
| 신우진 → 김동학 | 22 |
| 최숙진 → 서희항 | 20 |
| 김동학 → 서희항 | 20 |
| 최숙진 → 김동학 | 12 |
| 신우진 → 최숙진 | 12 |
| 서희항 → 최숙진 | 8 |
| 신우진 → 서희항 | 7 |
| 서희항 → 김동학 | 5 |
| 김동학 → 신우진 | 3 |
| 신우진 → 서희항·최숙진 | 2 |
| 김동학 → 신우진·최숙진 | 1 |
| 김동학 → 서희항·최숙진 | 1 |

## 재배정 — 140행

| row_id | 트랙.단계 | status | 일 | 현재 | 제안 | 근거등급 | 근거 |
|---|---|---|---|---|---|---|---|
| STD-CAT-033 | T2.A1 | 미착수 | 디자인 상품 화면 구조 — 카테고리 → 디자인 목록 → 상세 페이지 | 김동학 | 서희항 | merged-owner_side | 여러 시스템에 걸치나 담당은 한 사람(webadmin,widget) |
| STD-CAT-041 | T2.A1 | 미착수 | 판매중 상품 수 3갈래(대시보드 291·상품목록 판매중 297/검색 291·API ONSALE 226) 기준 | 김동학 | 최숙진 | evidence-path | 셀러어드민 설정·운영(코드 0) |
| STD-ART-019 | T2.B3 | 미착수 | 업로드 파일 썸네일·PDF 미리보기 | 김동학 | 서희항 | rule-step | 사는 시스템 미확인 — 단계 B3 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-ART-020 | T2.B3 | 미착수 | 재단선 오버레이 미리보기 | 김동학 | 서희항 | rule-step | 사는 시스템 미확인 — 단계 B3 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-ADC-014 | T3.A5 | 구현-미검증 | 인쇄 가이드 콘텐츠 관리 | 김동학 | 서희항 | merged-owner_side | 그 일이 사는 곳=webadmin |
| STD-MEM-020 | T3.B5 | 미착수 | 기존 회원 데이터 이관(구 사이트) | 김동학 | 서희항 | merged-owner_side | 그 일이 사는 곳=webadmin |
| STD-ORD-027 | T3.B7 | 부분 | 오프라인 주문 별도 등록 경로 | 김동학 | 서희항 | evidence-path | 그 일이 사는 곳=webadmin |
| STD-PRM-002 | T3.D2 | 미착수 | 리뷰 작성 보상 쿠폰 발행 | 김동학 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-PRM-003 | T3.D2 | 미착수 | 재구매 쿠폰 발행 | 김동학 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-PRM-005 | T3.D2 | 부분 | 쿠폰 동시사용 개수 제한 | 김동학 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-PRM-008 | T3.D2 | 미착수 | 리뷰 삭제 시 보상 회수 | 김동학 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-ADC-004 | T3.D2 | 미착수 | 프린팅머니 수동 지급·차감 | 김동학 | 서희항 | merged-owner_side | 그 일이 사는 곳=webadmin |
| STD-CLM-011 | T3.D3 | 미착수 | 귀책 구분(구매자/판매자/단순변심) | 김동학 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-CLM-013 | T3.D3 | 미착수 | 판매자 클레임 승인·거부 처리 | 김동학 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-ADO-023 | T3.D3 | 부분 | 환불 실행·정산 반영 | 김동학 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-SYS-008 | T4.C3 | 부분 | 인쇄 도메인 DB ↔ 커머스 상품 동기화 | 김동학 | 서희항 | manual-read | 동기화 코드가 webadmin 안에 산다(모듈 docstring 「우리 DB 가 원본이고 샵바이는 밀어넣는 대상」). 스킨 코드 0. merged t48:35 owner_side=webadmin 와 |
| STD-SYS-010 | T4.C3 | 구현-미검증 | 원고 저장소(스토리지) 연동 | 김동학 | 서희항 | evidence-path | 그 일이 사는 곳=webadmin |
| STD-SYS-039 | T4.C3 | 미착수 | 웹훅 등록 화면 위치 확인(셀러어드민 내 미발견) 및 등록 여부 | 김동학 | 최숙진 | evidence-path | 셀러어드민 설정·운영(코드 0) |
| STD-ADO-002 | T4.C5 | 부분 | 주문 상세 조회(사양·파일·금액) | 김동학 | 서희항 | manual-read | TOrdOrders(t_ord_orders)·TOrdArtworks 가 webadmin 모델. 주문 상세의 사양·파일·금액 그릇이 webadmin 에 있다 |
| STD-ADO-003 | T4.C5 | 부분 | 주문 상태 변경(단건) | 김동학 | 서희항 | manual-read | ord_sts(주문상태) 컬럼이 webadmin t_ord_orders. 단건 상태변경 화면은 webadmin 제네릭 admin |
| STD-ADO-005 | T4.C5 | 미착수 | 상태 변경 시 고객 알림 자동발송 | 김동학 | 서희항·최숙진 | rule-step | 사는 시스템 미확인 — 단계 C5 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-ADO-006 | T4.C5 | 미착수 | 주문서(작업지시서) 출력 | 김동학 | 최숙진 | merged-owner_side | MES 현행 기능·생산 현장 운영 — 신규 개발이면 외부(MES 담당) |
| STD-ADO-020 | T4.C6 | 작동 | 송장 등록·일괄 업로드 | 김동학 | 서희항 | merged-owner_side | 그 일이 사는 곳=webadmin |
| STD-ADO-021 | T4.C6 | 작동 | 출고 처리·배송중 전이 | 김동학 | 서희항 | merged-owner_side | 그 일이 사는 곳=webadmin |
| STD-MFG-114 | T4.C6 | 미착수 | 한 주문에 다중 송장 부여 | 김동학 | 서희항 | merged-owner_side | 그 일이 사는 곳=webadmin |
| STD-SHP-012 | T4.C7 | 부분 | 송장번호 등록(판매자) | 김동학 | 서희항 | merged-owner_side | 그 일이 사는 곳=webadmin |
| STD-SHP-013 | T4.C7 | 부분 | 송장 기반 배송상태 일괄변경 | 김동학 | 서희항 | merged-owner_side | 그 일이 사는 곳=webadmin |
| STD-PRM-012 | T5.D1 | 미착수 | 알림톡/SMS 마케팅 발송 | 김동학 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-PRM-013 | T5.D1 | 미착수 | 이메일 뉴스레터 발송 | 김동학 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-ADO-024 | T5.D4 | 미착수 | 증빙서류 발급 관리 | 김동학 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-SHP-017 | T5.E1 | 부분 | 금지 설정 4종 확인(A-14/U-1): 수량비례·중량 배송비 / 최대구매수량 / 즉시할인 | 김동학 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-B2B-001 | T5.E1 | 부분 | 거래처(기업회원) 등록·관리 | 김동학 | 서희항 | evidence-path | 그 일이 사는 곳=webadmin |
| STD-B2B-002 | T5.E1 | 미착수 | 거래처별 단가/할인율 설정 | 김동학 | 최숙진 | rule-step | 사는 시스템 미확인 — 단계 E1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-B2B-003 | T5.E1 | 미착수 | 거래처 소속 담당자 다계정 | 김동학 | 최숙진 | rule-step | 사는 시스템 미확인 — 단계 E1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-B2B-006 | T5.E1 | 미착수 | 월 마감 청구서 발행 | 김동학 | 최숙진 | rule-step | 사는 시스템 미확인 — 단계 E1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-B2B-007 | T5.E1 | 미착수 | 업체별 미수금 관리 | 김동학 | 최숙진 | rule-step | 사는 시스템 미확인 — 단계 E1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-B2B-010 | T5.E1 | 미착수 | 대량 견적 요청 접수·회신 | 김동학 | 최숙진 | rule-step | 사는 시스템 미확인 — 단계 E1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-B2B-011 | T5.E1 | 미착수 | 견적서 발행(사업자 양식) | 김동학 | 최숙진 | rule-step | 사는 시스템 미확인 — 단계 E1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-FIN-008 | T5.E1 | 미착수 | PG 정산 대사 | 김동학 | 최숙진 | rule-step | 사는 시스템 미확인 — 단계 E1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-FIN-009 | T5.E1 | 미착수 | 적립금(프린팅머니) 부채 집계 | 김동학 | 최숙진 | rule-step | 사는 시스템 미확인 — 단계 E1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-FIN-010 | T5.E1 | 미착수 | 외주 발주/정산 엑셀 산출 | 김동학 | 최숙진 | rule-step | 사는 시스템 미확인 — 단계 E1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-FIN-012 | T5.E1 | 미착수 | 통계·주문 데이터 엑셀 내보내기 | 김동학 | 최숙진 | rule-step | 사는 시스템 미확인 — 단계 E1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-SYS-004 | T5.E1 | 부분 | PG 연동 설정 | 김동학 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-SYS-005 | T5.E1 | 부분 | 배송비 정책 설정 | 김동학 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-SYS-006 | T5.E1 | 미착수 | 알림(SMS/알림톡/이메일) 템플릿 설정 | 김동학 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| T5-3 | T5.E3 | 부분 | 법정 표기 단일화(사업자번호 206-29-88022 우세)·증빙 화면 목업 제거(D-5) | 김동학 | 신우진·최숙진 | rule-step | 사는 시스템 미확인 — 단계 E3 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-MYP-009 | T6.D5 | 미착수 | 기존 프린트머니 잔액 이관 | 김동학 | 서희항 | merged-owner_side | 그 일이 사는 곳=webadmin |
| STD-SYS-016 | T7.E4 | 부분 | 주문/결제 실패 모니터링·알림 | 김동학 | 서희항 | evidence-path | 그 일이 사는 곳=webadmin |
| STD-SYS-017 | T7.E4 | 미착수 | 데이터 백업·복구 절차 | 김동학 | 신우진 | rule-step | 사는 시스템 미확인 — 단계 E4 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-SYS-019 | T7.E4 | 미착수 | 반응형/모바일 대응 | 김동학 | 신우진 | rule-step | 사는 시스템 미확인 — 단계 E4 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-SYS-021 | T7.E4 | 미착수 | 페이지 빌더(운영자 화면 편집) | 김동학 | 서희항 | merged-owner_side | 그 일이 사는 곳=pagebuilder |
| STD-SYS-022 | T7.E4 | 미착수 | 구 사이트 → 신규 사이트 URL 리다이렉트 | 김동학 | 신우진 | rule-step | 사는 시스템 미확인 — 단계 E4 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-OPT-056 | T2.B2 | 구현-미검증 | 캘린더 가공·장수(월수) 선택 | 서희항 | 김동학 | evidence-path | 그 일이 사는 곳=huni-mall |
| STD-ART-029 | T2.B3 | 미착수 | 가변데이터 인쇄(VDP) 데이터 업로드·병합 | 서희항 | 김동학 | evidence-path | 그 일이 사는 곳=huni-mall |
| STD-OPT-057 | T3.A5 | 미착수 | 규격 가이드 모달(사이즈 안내 팝업) | 서희항 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-OPT-058 | T3.A5 | 미착수 | 주문가능 자재(용지) 목록 모달 | 서희항 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-PAY-007 | T3.B6 | 부분 | 적립금(프린팅머니) 결제 | 서희항 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-ADO-012 | T4.C5 | 미착수 | 인쇄 공정 상태 트래킹 | 서희항 | 최숙진 | merged-owner_side | MES 현행 기능·생산 현장 운영 — 신규 개발이면 외부(MES 담당) |
| STD-MFG-078 | T4.C5 | 미착수 | 파일명 자동 RENAME 규약 적용(품목_출력사이즈_양단면_소재_거래처_고객_고유번호_수량) | 서희항 | 최숙진 | evidence-path | MES 현행 기능·생산 현장 운영 — 신규 개발이면 외부(MES 담당) |
| STD-MFG-079 | T4.C5 | 미착수 | 상품군별 파일명 조합 규칙 8종(디지털/캘린더/스티커/실사/배너/패브릭/시트커팅/레이저커팅) | 서희항 | 최숙진 | evidence-path | MES 현행 기능·생산 현장 운영 — 신규 개발이면 외부(MES 담당) |
| STD-MFG-084 | T4.C5 | 미착수 | 공정라우트 마스터(18케이스 라우트 정의·재채번) | 서희항 | 최숙진 | merged-owner_side | MES 현행 기능·생산 현장 운영 — 신규 개발이면 외부(MES 담당) |
| STD-MFG-085 | T4.C5 | 미착수 | 라우트 단계 정의(순번·공정·필수선택·담당팀) | 서희항 | 최숙진 | evidence-path | MES 현행 기능·생산 현장 운영 — 신규 개발이면 외부(MES 담당) |
| STD-MFG-086 | T4.C5 | 미착수 | 상품→공정라우트 매핑 | 서희항 | 최숙진 | evidence-path | MES 현행 기능·생산 현장 운영 — 신규 개발이면 외부(MES 담당) |
| STD-MFG-096 | T4.C5 | 미착수 | 2차 산출데이터(팀별 입고예정·공정별 평균리드타임·평균 제작기간) | 서희항 | 최숙진 | evidence-path | MES 현행 기능·생산 현장 운영 — 신규 개발이면 외부(MES 담당) |
| STD-MFG-115 | T4.C6 | 미착수 | 합배송 리스트 식별 | 서희항 | 최숙진 | evidence-path | MES 현행 기능·생산 현장 운영 — 신규 개발이면 외부(MES 담당) |
| F3-7 | T1.F3 | 미착수 | DNS `huni-admin.printly.co.kr` CNAME → Lightsail + `CUSTOM_D | 신우진 | 서희항 | rule-track | huni-admin.printly.co.kr(관리서버) DNS — 관리서버 담당 |
| F3-11 | T1.F3 | 미착수 | Railway 3서비스 종료(최종 덤프 보관 후) | 신우진 | 서희항 | rule-track | Railway 3서비스 종료 = 관리서버·DB 쪽 |
| F4-7 | T1.F4 | 미착수 | vercel.app 리다이렉트: 코드에 없음(§1 마지막 행). Vercel 대시보드 리다이렉트·도메인 설정 | 신우진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| F4-8 | T1.F4 | 미착수 | Vercel 프로젝트 정지(오픈 테스트 통과 후) | 신우진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-CAT-026 | T2.A1 | 미착수 | 수작 상품 메인·상품페이지 경로 | 신우진 | 김동학 | evidence-path | 그 일이 사는 곳=huni-mall |
| STD-CAT-040 | T2.A1 | 미착수 | 시작가가 API 로 샵바이에 내려가는데 쇼핑몰에 반영되지 않는 원인 확인 | 신우진 | 서희항·최숙진 | rule-step | 사는 시스템 미확인 — 단계 A1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-ADP-034 | T2.A1 | 미실측 | 수작 상품 등록 | 신우진 | 서희항·최숙진 | rule-step | 사는 시스템 미확인 — 단계 A1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-OPT-053 | T2.B2 | 미착수 | 견적 결과 저장(옵션보관함) | 신우진 | 서희항 | rule-track | 견적 결과 저장(옵션보관함) = 위젯 상태 저장 축 |
| STD-OPT-054 | T2.B2 | 미착수 | 견적서 PDF/출력물 발급 | 신우진 | 서희항 | rule-track | 견적서 발급 = 가격엔진 산출물 |
| STD-ART-023 | T2.B3 | 미착수 | 에디터 작업물 저장·재편집 | 신우진 | 서희항 | rule-track | 에디터 작업물 저장·재편집 = Edicus 연동 계약(위젯 축) |
| STD-MEM-022 | T3.B5 | 미착수 | 로그인 식별자 정책(이메일 전용 vs 아이디) 확정·테스트회원 계정 정비 | 신우진 | 김동학 | evidence-path | 그 일이 사는 곳=huni-mall |
| STD-ORD-015 | T3.B6 | 미착수 | 나중배송(배송지 미입력) 주문 | 신우진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-ORD-017 | T3.B6 | 미착수 | 출고 옵션 선택(오늘출고·토요일출고) | 신우진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-PAY-001 | T3.B6 | 미착수 | 신용카드 결제(PG) | 신우진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-PAY-006 | T3.B6 | 미착수 | 토스페이 결제 | 신우진 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-PAY-010 | T3.B6 | 미착수 | B2B 후불결제 | 신우진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-PAY-029 | T3.B6 | 미착수 | 미입금 주문 자동취소 기간 정책 확정(현재 무통장 7영업일·가상계좌 7일) | 신우진 | 최숙진 | evidence-path | 셀러어드민 설정·운영(코드 0) |
| STD-MYP-004 | T3.D2 | 미착수 | 옵션보관함 저장/불러오기 | 신우진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-MYP-005 | T3.D2 | 미착수 | 보관 기간 정책 적용·만료 처리 | 신우진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-MYP-019 | T3.D2 | 미착수 | 마이페이지 통합 검색결과 LIST 화면 | 신우진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-PRM-011 | T3.D2 | 미착수 | 체험단 모집·신청·당첨·후기 | 신우진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-PRM-016 | T3.D2 | 미착수 | 이용후기 메인(전체 리뷰 모아보기) | 신우진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-PRM-017 | T3.D2 | 미실측 | [구IA#71] 체험단관리 (등록/수정/신청내역) | 신우진 | 김동학 | rule-step | 사는 시스템 미확인 — 단계 D2 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-CLM-018 | T3.D3 | 부분 | 공지사항·FAQ 열람 | 신우진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-CLM-021 | T3.D3 | 미착수 | 디자인 의뢰하기(주문 흐름 내) | 신우진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-SYS-012 | T4.C3 | 부분 | 본인인증 서비스 연동 | 신우진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-ART-016 | T4.C4 | 미착수 | 자동검판 도구 연동(PitStop 등) | 신우진 | 서희항 | merged-owner_side | PitStop 연동 = 경계 정의상 위젯/파이프라인 축(merged lives=webadmin) |
| STD-MFG-133 | T4.C5 | 미실측 | 오프라인 주문 등록(거래처별 EXCEL·금액 직접 입력) | 신우진 | 최숙진 | merged-owner_side | MES 현행 기능·생산 현장 운영 — 신규 개발이면 외부(MES 담당) |
| STD-SHP-011 | T4.C6 | 미착수 | 분할배송(건별 부분 출고) | 신우진 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-MFG-128 | T5.D1 | 미착수 | 알림톡 템플릿 사전 심사·승인 관리 | 신우진 | 서희항 | evidence-path | 그 일이 사는 곳=webadmin |
| STD-B2B-013 | T5.E1 | 미실측 | [구IA#45] 거래처관리 (등록/수정/처리) | 신우진 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-B2B-014 | T5.E1 | 미실측 | [구IA#46] 매장게시판 | 신우진 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-FIN-013 | T5.E1 | 미착수 | [구IA#47] 계좌관리 (원장용 계좌 등록) | 신우진 | 최숙진 | rule-step | 사는 시스템 미확인 — 단계 E1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-FIN-014 | T5.E1 | 미착수 | [구IA#49] 업체별 미수금 | 신우진 | 최숙진 | rule-step | 사는 시스템 미확인 — 단계 E1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-FIN-015 | T5.E1 | 미실측 | [구IA#79] 인쇄/제본 상품통계 (상세보기) | 신우진 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-FIN-016 | T5.E1 | 미실측 | [구IA#80] 굿즈 상품통계 (상세보기) | 신우진 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-FIN-017 | T5.E1 | 미실측 | [구IA#81] 패키지 상품통계 (상세보기) | 신우진 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-FIN-018 | T5.E1 | 미실측 | [구IA#82] 수작 상품통계 (상세보기) | 신우진 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-INF-001 | T5.E3 | 부분 | 회사소개 페이지 | 신우진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-INF-002 | T5.E3 | 작동 | 찾아오시는 길(약도·교통 안내) | 신우진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-INF-003 | T5.E3 | 작동 | 이용약관 페이지 게시 | 신우진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-INF-004 | T5.E3 | 작동 | 개인정보처리방침 페이지 게시 | 신우진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-MYP-054 | T6.D5 | 미착수 | 마이포인트(/mypage/point·shopby 적립금)와 프린팅머니(/mypage/money·UI 전용)  | 신우진 | 김동학 | evidence-path | 그 일이 사는 곳=huni-mall |
| F3-4 | T1.F3 | 미착수 | 샵바이 콘솔 IP 화이트리스트 52.78.126.17 등록 → 메인이미지 동기화 1건 실측 | 최숙진 | 서희항 | rule-step | 사는 시스템 미확인 — 단계 F3 기본 담당과 불일치(약한 근거·실측 필요) |
| F3-5 | T1.F3 | 미착수 | 샵바이 웹훅 수신 URL → 새 호스트 `/api/w/v1/shopby/webhook/<secret>` | 최숙진 | 서희항 | rule-step | 사는 시스템 미확인 — 단계 F3 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-CAT-028 | T2.A2 | 미착수 | 목록·검색 시작가 「10원~」 표시(샵바이 salePrice 더미) | 최숙진 | 김동학 | evidence-path | 그 일이 사는 곳=huni-mall |
| STD-OPT-048 | T2.A2 | 부분 | 면적 기반 가격 계산(실사·현수막·아크릴) | 최숙진 | 서희항 | evidence-path | 그 일이 사는 곳=webadmin |
| STD-OPT-050 | T2.A2 | 부분 | 고정가형 가격 계산(수량×옵션) | 최숙진 | 서희항 | evidence-path | 그 일이 사는 곳=webadmin |
| STD-OPT-051 | T2.A2 | 부분 | 셋트/부품조립 상품 합산 가격 계산 | 최숙진 | 서희항 | merged-owner_side | 그 일이 사는 곳=webadmin |
| STD-ADP-037 | T2.A2 | 부분 | 게시 위젯 가격 전수 대조(1차 최숙진 → 2차 김용기 → 3차 채훈희 승인) | 최숙진 | 서희항 | merged-owner_side | 그 일이 사는 곳=widget |
| T2-2 | T2.A3 | 부분 | 위젯 기본값 미지정 교정·재게시 | 최숙진 | 서희항 | merged-owner_side | 그 일이 사는 곳=widget |
| STD-OPT-039 | T2.A3 | 부분 | 공정 택일 그룹(상호배타) 처리 | 최숙진 | 서희항 | evidence-path | 그 일이 사는 곳=webadmin |
| STD-OPT-016 | T2.B2 | 부분 | 작업 사이즈 입력·자동 도출(도련 포함) | 최숙진 | 서희항 | merged-owner_side | 그 일이 사는 곳=widget |
| STD-OPT-025 | T2.B2 | 부분 | 박 선택(색상 다종 × 면 × 크기 × 내용같음/틀림) | 최숙진 | 서희항 | merged-owner_side | 그 일이 사는 곳=widget |
| STD-OPT-035 | T2.B2 | 미착수 | 상품별 기본제공 부자재 규칙 표시 | 최숙진 | 서희항 | merged-owner_side | 그 일이 사는 곳=widget |
| STD-OPT-055 | T2.B2 | 미착수 | 대량주문 견적 문의 접수 | 최숙진 | 김동학 | evidence-path | 그 일이 사는 곳=huni-mall |
| STD-ART-021 | T2.B3 | 부분 | 온라인 디자인 에디터 진입 | 최숙진 | 서희항 | merged-owner_side | 여러 시스템에 걸치나 담당은 한 사람(webadmin,widget) |
| STD-ART-025 | T2.B3 | 부분 | 선택 옵션(사이즈·페이지)과 에디터 캔버스 동기화 | 최숙진 | 서희항 | rule-step | 사는 시스템 미확인 — 단계 B3 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-ART-032 | T2.B3 | 미착수 | 에디쿠스 테스트용 단순 상품(메모패드 등) 제공 | 최숙진 | 서희항 | rule-step | 사는 시스템 미확인 — 단계 B3 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-INF-005 | T3.A5 | 부분 | 공지사항 고객 화면(목록·상세) | 최숙진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-MEM-018 | T3.B5 | 미착수 | 회원등급 산정·자동 승급 | 최숙진 | 서희항 | merged-owner_side | 그 일이 사는 곳=webadmin |
| STD-PAY-002 | T3.B6 | 미착수 | 실시간 계좌이체 | 최숙진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-PAY-025 | T3.B6 | 미착수 | 샵바이 어드민의 카카오페이 신청 경로 확인 | 최숙진 | 김동학 | rule-step | 사는 시스템 미확인 — 단계 B6 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-ORD-025 | T3.B7 | 미착수 | 구매확정(고객·자동) | 최숙진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-MYP-032 | T3.D2 | 미착수 | 편집 후 장바구니를 누르지 않고 이탈한 고객 안내 방법 | 최숙진 | 김동학 | rule-step | 사는 시스템 미확인 — 단계 D2 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-CLM-004 | T3.D3 | 미착수 | 제작 착수 후 취소 제한·협의 안내 | 최숙진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-ADO-008 | T4.C4 | 미착수 | 파일 확인 처리(검판 판정) | 최숙진 | 서희항 | merged-owner_side | 그 일이 사는 곳=pitstop |
| STD-MFG-050 | T4.C4 | 미착수 | 자동 발송 오류 목록 관리(좁게 유지·담당자와 확정) | 최숙진 | 서희항 | evidence-path | 그 일이 사는 곳=webadmin |
| STD-MFG-010 | T4.C5 | 부분 | 상품↔MES 품목코드(MES_ITEM_CD) 매핑 일괄 적재 | 최숙진 | 서희항 | evidence-path | 그 일이 사는 곳=webadmin |
| STD-MFG-123 | T4.C6 | 미착수 | 재출고 신규송장 부여(상품누락 추가발송·교환 재발송) | 최숙진 | 서희항 | merged-owner_side | 그 일이 사는 곳=webadmin |
| STD-PAY-015 | T5.D4 | 미착수 | 현금영수증 발급 | 최숙진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-PAY-017 | T5.D4 | 부분 | 사업자정보 등록·관리 | 최숙진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-PAY-018 | T5.D4 | 부분 | 거래명세서 출력 | 최숙진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-SYS-025 | T5.E1 | 부분 | [구IA#44] 관리자 등록/관리 | 최숙진 | 서희항 | evidence-path | 그 일이 사는 곳=webadmin |
| STD-INF-008 | T5.E3 | 미착수 | 푸터 SNS 4종·입점제휴문의·카톡상담 링크가 '#' | 최숙진 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |

## 분할 — 38행

| row_id | 트랙.단계 | status | 일 | 현재 | 제안 | 근거등급 | 근거 |
|---|---|---|---|---|---|---|---|
| STD-ADP-015 | T2.A1 | 부분 | 상품 상세페이지 콘텐츠 편집 | 김동학 | 서희항+김동학 | manual-read | 스킨은 fetchPublishedDetailTabs 로 **발행된 탭을 읽기만** 한다. 「편집」 화면은 pagebuilder(vibe-canvas) 쪽 — 조회=김동학 / 편집=서희항(pagebu |
| STD-CAT-043 | T2.A4 | 미착수 | 목록·검색 시작가를 webadmin `GET /api/w/v1/catalog`(게시 위젯+시작가) 로 이관  | 김동학 | 김동학+서희항 | merged-owner_side | 두 시스템에 걸침(huni-mall,webadmin) — 행을 나눠 각자에게 |
| STD-CAT-007 | T3.A5 | 부분 | 상품 상세페이지 본문(이미지·설명 블록) | 김동학 | 김동학+서희항 | merged-owner_side | 두 시스템에 걸침(huni-mall,pagebuilder) — 행을 나눠 각자에게 |
| STD-CAT-011 | T3.A5 | 미착수 | 상품별 제작 소요일/출고 기준 안내 | 김동학 | 김동학+서희항 | merged-owner_side | 두 시스템에 걸침(huni-mall,webadmin) — 행을 나눠 각자에게 |
| STD-CAT-012 | T3.A5 | 부분 | 재작업 불가 사항 고지(폰트 아웃라인 등) | 김동학 | 김동학+서희항 | merged-owner_side | 두 시스템에 걸침(huni-mall,pagebuilder) — 행을 나눠 각자에게 |
| STD-CAT-014 | T3.A5 | 작동 | 상품 리뷰 목록·평점 노출 | 김동학 | 김동학+최숙진 | merged-owner_side | 두 시스템에 걸침(huni-mall,shopby) — 행을 나눠 각자에게 |
| STD-CAT-034 | T3.A5 | 부분 | 상세페이지 탭 6종 자동 등록(디자인가이드·디자인보기 포함) | 김동학 | 김동학+서희항 | merged-owner_side | 두 시스템에 걸침(huni-mall,pagebuilder,webadmin) — 행을 나눠 각자에게 |
| T3-2 | T3.B5 | 부분 | 로그인 성공인데 오류 문구·리다이렉트 없음 수정(D-2) + 회원 이관 경로 확정 | 김동학 | 김동학+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| T3-3 | T3.B6 | 부분 | 주문서·결제 — 결제수단 범위 결정 후 스킨 결제 분기·주문 성립 1건 종단 | 김동학 | 김동학+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| STD-PAY-013 | T3.B6 | 부분 | 결제 금액 위변조 검증(서버 재계산 대조) | 김동학 | 김동학+서희항 | manual-read | 위변조 검증은 스킨이 부르고 위젯 /handoff/verify 가 판정한다 — 호출측·판정측이 다른 사람 |
| STD-PAY-031 | T3.B6 | 미착수 | 위젯 총액↔shopby 청구액 「10원×수량」 모델 정합 검증(표시↔청구 불일치 알려진 이슈) | 김동학 | 김동학+서희항 | manual-read | amountToOrderCnt(10원×수량)는 스킨 코드. 그러나 총액 권위는 위젯 handoff/requote(서희항). 표시↔청구 정합은 두 쪽 합의 행 |
| STD-MYP-003 | T3.D2 | 미착수 | 편집상품 미리보기 | 김동학 | 서희항+김동학 | manual-read | 스킨 버튼은 onClick 없는 데드 버튼(=김동학 몫). 미리보기 산출물 자체는 Edicus/위젯(=서희항) |
| STD-MYP-030 | T3.D2 | 부분 | 편집 디자인 보관함 — 편집 종료 후 보관, 장바구니 담기 전까지 수정 가능 | 김동학 | 김동학+서희항 | merged-owner_side | 두 시스템에 걸침(huni-mall,widget) — 행을 나눠 각자에게 |
| STD-SYS-041 | T4.C3 | 미착수 | 상품 텍스트옵션 라벨 huni_token 미등록 확정(U-2) → 스킨 담기 구현 정합 | 김동학 | 김동학+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| STD-SYS-045 | T4.C3 | 미착수 | 후니 위젯 서버키 헤더(X-Huni-Server-Key) 전송 배선 — 제공자가 WAPI_SERVER_KEY | 김동학 | 김동학+서희항 | merged-owner_side | 두 시스템에 걸침(huni-mall,webadmin,widget) — 행을 나눠 각자에게 |
| STD-B2B-005 | T6.D5 | 미착수 | 후불 주문 승인·미결제 관리 | 김동학 | 김동학+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| BLK-S1-5 | T4.C1 | 미착수 | [선행 입력] `order/register` 계약(엔드포인트·페이로드·서버키) | 서희항 | 서희항+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| BLK-S2-1 | T4.C1 | 미착수 | [선행 입력] Railway 운영 변수 4종 설정 여부(값 아님) — `WAPI_SERVER_KEY_REQU | 서희항 | 서희항+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| BLK-S2-5 | T4.C2 | 미착수 | [선행 입력] Lightsail 이전 후 크론·워커 실행 형태 | 서희항 | 서희항+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| T4-3 | T4.C4 | 없음 | 파일 검수 경로 결정·구축 — PitStop 조달 또는 사람 검수(D-P1·D-P2) | 서희항 | 서희항+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| T4-4 | T4.C5 | 없음 | 접수 화면·주문 상태머신·MES 접수 전송(D-P5·D-P6·D-P7) | 서희항 | 미정+최숙진 | merged-owner_side | 두 시스템에 걸침(mes,미정) — 행을 나눠 각자에게 |
| STD-MFG-125 | T5.D1 | 미착수 | 파일 오류 재업로드 요청 알림톡 발송(자동·담당자 발) | 서희항 | 서희항+최숙진 | evidence-path | 파일 오류 재업로드 알림 — 발송 배선(webadmin)=서희항 / 알림톡 템플릿·계약=최숙진 |
| STD-MFG-126 | T5.D1 | 미착수 | 재업로드 접수 확인 알림 | 서희항 | 서희항+최숙진 | evidence-path | 재업로드 접수 확인 알림 — 발송 배선=서희항 / 템플릿=최숙진 |
| STD-MFG-127 | T5.D1 | 미착수 | 편집상품 수정요청 알림(주문번호·편집번호·안내) | 서희항 | 서희항+최숙진 | evidence-path | 편집상품 수정요청 알림 — 발송 배선=서희항 / 템플릿=최숙진 |
| STD-MFG-129 | T5.D1 | 미착수 | 알림톡 발송 실패 시 SMS/LMS 자동 대체 | 서희항 | 서희항+최숙진 | evidence-path | 알림톡 실패 시 SMS/LMS 대체 — 대체 로직=서희항 / 채널 계약=최숙진 |
| T3-5 | T3.D3 | 없음 | 취소·반품·문의 — 범위 결정 후 스킨 버튼·문의 라우트 구현 | 신우진 | 신우진+김동학 | rule-track | 「범위 결정」(PM) + 「스킨 버튼·문의 라우트 구현」(김동학)이 한 행에 섞였다 — 결정/구현 분리 |
| STD-CLM-015 | T3.D3 | 미착수 | 재제작(재작업) 처리 경로 | 신우진 | 신우진+최숙진 | rule-track | 재제작 처리 「경로 결정」(PM) + 「운영 절차」(실무운영). 화면 근거 없음 |
| STD-ART-027 | T4.C2 | 미착수 | 과거 주문 파일 재사용 재주문 | 신우진 | 서희항+김동학 | rule-track | 과거 주문 파일 재사용 = 원고 보관(webadmin) + 재주문 진입(스킨) |
| STD-SYS-050 | T7.E4 | 미착수 | huni-skin-next 포크(SPEC-TAKEOVER-001 M0~M7·20커밋·remote 없음) 처리 | 신우진 | 신우진+김동학 | evidence-path | 포크 처리 「결정」은 PM, 선별 이식 「구현」은 스킨 담당 |
| BLK-S4-9 | T1.F3 | 미착수 | [선행 입력] 샵바이 콘솔 권한자(IP 화이트리스트·웹훅 URL 편집) | 최숙진 | 최숙진+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| STD-CAT-031 | T2.A1 | 부분 | 캘린더 4종 1차 오픈 포함 확정 | 최숙진 | 최숙진+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| STD-CAT-019 | T3.A5 | 부분 | 인쇄 가이드 콘텐츠(11종) | 최숙진 | 김동학+서희항 | merged-owner_side | 두 시스템에 걸침(huni-mall,pagebuilder) — 행을 나눠 각자에게 |
| STD-INF-007 | T3.A5 | 부분 | 가이드북 고객 화면(작업 유의사항 11종) | 최숙진 | 김동학+서희항 | merged-owner_side | 두 시스템에 걸침(huni-mall,pagebuilder) — 행을 나눠 각자에게 |
| STD-MYP-040 | T3.D2 | 부분 | 마이페이지 9개 메뉴 점검·판정표 + 프린트머니 범위 결정 | 최숙진 | 최숙진+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| BLK-S2-2 | T4.C3 | 미착수 | [선행 입력] 샵바이 어드민 웹훅 등록 현황(URL·구독 이벤트) | 최숙진 | 최숙진+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| T4-5 | T4.C6 | 없음 | 출고·송장 — 셀러어드민 수동 등록 경로 확인 + 생산 상태의 고객 반영 방식 결정 | 최숙진 | 최숙진+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| T5-2 | T5.D1 | 부분 | 알림 — SMS 사용설정·알림톡 33건 개별 판단 후 켜기·템플릿 카카오 검수 | 최숙진 | 최숙진+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| STD-MYP-039 | T5.D4 | 미착수 | 세금계산서 API 자동 발행 여부 결정 | 최숙진 | 최숙진+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |

## provided — 37행

| row_id | 트랙.단계 | status | 일 | 현재 | 제안 | 근거등급 | 근거 |
|---|---|---|---|---|---|---|---|
| STD-ADC-007 | T3.A5 | 작동 | 공지사항 관리 | 김동학 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-ADC-008 | T3.A5 | 작동 | FAQ 관리 | 김동학 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-ADC-009 | T3.A5 | 작동 | 상품Q&A 답변 관리 | 김동학 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-ADC-010 | T3.A5 | 작동 | 1:1 문의 답변 관리 | 김동학 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-ADC-011 | T3.A5 | 작동 | 이용후기(리뷰) 관리·블라인드 | 김동학 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-PRM-009 | T3.D2 | 작동 | 사진 리뷰 추가 보상 | 김동학 | 최숙진 | merged-owner_side | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-ADC-001 | T3.D2 | 작동 | 회원 목록·검색·상세 | 김동학 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-ADC-003 | T3.D2 | 작동 | 탈퇴회원 관리 | 김동학 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-ADC-006 | T3.D2 | 작동 | 쿠폰 등록·사용 내역 조회 | 김동학 | 최숙진 | merged-owner_side | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-ADO-022 | T3.D3 | 작동 | 클레임 접수 목록·처리 | 김동학 | 최숙진 | merged-owner_side | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-ADO-001 | T4.C5 | 작동 | 주문 목록·검색·필터 | 김동학 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-ADO-004 | T4.C5 | 작동 | 주문 상태 일괄 변경 | 김동학 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-ADO-007 | T4.C5 | 작동 | 고객 SMS/알림톡 수동 발송 | 김동학 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-SHP-008 | T4.C6 | 작동 | 택배 배송 | 김동학 | 최숙진 | merged-owner_side | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-SHP-016 | T5.D1 | 미착수 | 배송 상태 변경 알림 발송 | 김동학 | 최숙진 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 최숙진 |
| STD-FIN-001 | T5.E1 | 작동 | 월별 매출 통계 | 김동학 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-FIN-002 | T5.E1 | 작동 | 일별/기간별 매출 조회 | 김동학 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-FIN-003 | T5.E1 | 작동 | 결제수단별 매출 집계 | 김동학 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-FIN-004 | T5.E1 | 작동 | 상품별 판매 통계 | 김동학 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-FIN-005 | T5.E1 | 작동 | 상품군별 매출 비중 | 김동학 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-FIN-006 | T5.E1 | 작동 | 회원/비회원 주문 비중 | 김동학 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-FIN-011 | T5.E1 | 작동 | 쿠폰/할인 사용액 집계 | 김동학 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-SYS-003 | T5.E1 | 작동 | 관리자 작업 감사로그 | 김동학 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-ART-008 | T4.C4 | 미착수 | 파일 포맷 유효성 검사 | 서희항 | 서희항 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 서희항 |
| STD-ART-009 | T4.C4 | 미착수 | 재단선/블리드 3mm 확보 검사 | 서희항 | 서희항 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 서희항 |
| STD-ART-010 | T4.C4 | 미착수 | 색공간(CMYK) 검사 및 RGB 경고 | 서희항 | 서희항 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 서희항 |
| STD-ART-011 | T4.C4 | 미착수 | 해상도(dpi) 검사 | 서희항 | 서희항 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 서희항 |
| STD-ART-012 | T4.C4 | 미착수 | 폰트 아웃라인 여부 검사 | 서희항 | 서희항 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 서희항 |
| STD-ART-013 | T4.C4 | 미착수 | 주문 사양과 파일 실측 사이즈 대조 | 서희항 | 서희항 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 서희항 |
| STD-ART-014 | T4.C4 | 미착수 | 별색 채널·오버프린트 검사 | 서희항 | 서희항 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 서희항 |
| STD-MFG-048 | T4.C4 | 미착수 | 파일 열림·손상·암호 걸림 검사 | 서희항 | 서희항 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 서희항 |
| STD-MEM-021 | T3.B5 | 미착수 | 가입완료 안내 메일 발송 | 최숙진 | 최숙진 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 최숙진 |
| STD-PAY-003 | T3.B6 | 작동 | 무통장입금(가상계좌)·입금대기 상태 | 최숙진 | 최숙진 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 최숙진 |
| STD-PAY-028 | T3.B6 | 작동 | 무통장 입금 계좌 등록 | 최숙진 | 최숙진 | merged-owner_side | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-ORD-031 | T3.B7 | 미착수 | 주문완료 메일/알림 발송 | 최숙진 | 최숙진 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 최숙진 |
| STD-SHP-006 | T5.E1 | 작동 | 혼합주문 배송비 산정(최고값 1건) | 최숙진 | 최숙진 | merged-owner_side | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-MYP-008 | T6.D5 | 미착수 | 구매확정 적립금 자동 지급 | 최숙진 | 최숙진 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 최숙진 |

## 불필요 — 1행

| row_id | 트랙.단계 | status | 일 | 현재 | 제안 | 근거등급 | 근거 |
|---|---|---|---|---|---|---|---|
| STD-SYS-027 | T7.E4 | 미착수 | 기술 책임 총괄 = CTO 서희항 대표 | 서희항 | — | rule-track | 「기술 책임 총괄 = CTO 서희항」은 확정 사실 기록이지 작업 행이 아니다 — 원장에서 작업으로 세지 말 것 |

