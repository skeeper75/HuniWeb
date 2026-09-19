## 리드 1차 후보 17행 — t56 재판정

| row_id | 리드 분류 | t56 판정 | 제안 담당 | 근거등급 | 리드와 |
|---|---|---|---|---|---|
| STD-ART-019 | 위젯/webadmin/페이지빌더 의심 | 재배정 | 서희항 | rule-step | 일치 |
| STD-ART-020 | 위젯/webadmin/페이지빌더 의심 | 재배정 | 서희항 | rule-step | 일치 |
| STD-SYS-008 | 위젯/webadmin/페이지빌더 의심 | 재배정 | 서희항 | manual-read | 일치 |
| STD-SYS-010 | 위젯/webadmin/페이지빌더 의심 | 재배정 | 서희항 | evidence-path | 일치 |
| STD-ADP-015 | 위젯/webadmin/페이지빌더 의심 | 분할 | 서희항+김동학 | manual-read | 일치 |
| STD-ADO-001 | 운영자·생산 기능 의심 | provided | 최숙진 | evidence-path | 일치 |
| STD-ADO-002 | 운영자·생산 기능 의심 | 재배정 | 서희항 | manual-read | 일치 |
| STD-ADO-003 | 운영자·생산 기능 의심 | 재배정 | 서희항 | manual-read | 일치 |
| STD-ADO-004 | 운영자·생산 기능 의심 | provided | 최숙진 | evidence-path | 일치 |
| STD-ADO-005 | 운영자·생산 기능 의심 | 재배정 | 서희항·최숙진 | rule-step | 일치 |
| STD-ADO-006 | 운영자·생산 기능 의심 | 재배정 | 최숙진 | merged-owner_side | 일치 |
| STD-ADO-007 | 운영자·생산 기능 의심 | provided | 최숙진 | evidence-path | 일치 |
| STD-ADO-020 | 운영자·생산 기능 의심 | 재배정 | 서희항 | merged-owner_side | 일치 |
| STD-ADO-021 | 운영자·생산 기능 의심 | 재배정 | 서희항 | merged-owner_side | 일치 |
| STD-SHP-012 | 운영자·생산 기능 의심 | 재배정 | 서희항 | merged-owner_side | 일치 |
| STD-SHP-013 | 운영자·생산 기능 의심 | 재배정 | 서희항 | merged-owner_side | 일치 |
| STD-MFG-114 | 운영자·생산 기능 의심 | 재배정 | 서희항 | merged-owner_side | 일치 |
| STD-SYS-009 | 경계 걸침 | 담당맞음 | 김동학 | merged-owner_side | 어긋남 |

리드 후보 17행 대조: {'일치': 17, '어긋남': 1}

## 김동학 T2·T4 41행 전수
41 {'담당맞음': 17, '재배정': 16, '분할': 4, 'provided': 4}
  T4-1|C1|부분|담당맞음→김동학|rule-step|주문 등록 다리 — 스킨이 결제 직후 order/register 를 부르게 배선(부르는 쪽
  STD-CAT-001|A4|작동|담당맞음→김동학|merged-owner_side|대분류/중분류/소분류 다단 카테고리 트리 노출
  STD-CAT-002|A4|부분|담당맞음→김동학|merged-owner_side|카테고리별 상품 리스팅(정렬·페이징)
  STD-CAT-003|A4|미착수|담당맞음→김동학|merged-owner_side|상품군 전용 랜딩(출력/책자/실사/패키지/굿즈)
  STD-CAT-022|A4|미착수|담당맞음→김동학|merged-owner_side|품절/판매중지 상품 표시 및 대체 안내
  STD-CAT-023|A1|작동|담당맞음→김동학|evidence-path|상품 기본정보 세팅·로드(상품코드·주문가능여부·회원전용 노출 게이팅)
  STD-CAT-024|A1|부분|담당맞음→김동학|evidence-path|포장재 상품군 주문 경로(전용 옵션·주문 흐름)
  STD-CAT-025|A1|부분|담당맞음→김동학|evidence-path|굿즈 상품군 주문 경로(파우치·백 포함)
  STD-CAT-033|A1|미착수|재배정→서희항|merged-owner_side|디자인 상품 화면 구조 — 카테고리 → 디자인 목록 → 상세 페이지
  STD-CAT-041|A1|미착수|재배정→최숙진|evidence-path|판매중 상품 수 3갈래(대시보드 291·상품목록 판매중 297/검색 291·API ONSA
  STD-CAT-043|A4|미착수|분할→김동학+서희항|merged-owner_side|목록·검색 시작가를 webadmin `GET /api/w/v1/catalog`(게시 위젯+
  STD-ART-019|B3|미착수|재배정→서희항|rule-step|업로드 파일 썸네일·PDF 미리보기
  STD-ART-020|B3|미착수|재배정→서희항|rule-step|재단선 오버레이 미리보기
  STD-SHP-008|C6|작동|provided→최숙진|merged-owner_side|택배 배송
  STD-SHP-012|C7|부분|재배정→서희항|merged-owner_side|송장번호 등록(판매자)
  STD-SHP-013|C7|부분|재배정→서희항|merged-owner_side|송장 기반 배송상태 일괄변경
  STD-SHP-014|C7|부분|담당맞음→김동학|merged-owner_side|고객 배송 조회(택배사 추적)
  STD-SHP-015|C7|부분|담당맞음→김동학|merged-owner_side|배송지 변경/추가
  STD-ADP-015|A1|부분|분할→서희항+김동학|manual-read|상품 상세페이지 콘텐츠 편집
  STD-ADO-001|C5|작동|provided→최숙진|evidence-path|주문 목록·검색·필터
  STD-ADO-002|C5|부분|재배정→서희항|manual-read|주문 상세 조회(사양·파일·금액)
  STD-ADO-003|C5|부분|재배정→서희항|manual-read|주문 상태 변경(단건)
  STD-ADO-004|C5|작동|provided→최숙진|evidence-path|주문 상태 일괄 변경
  STD-ADO-005|C5|미착수|재배정→서희항·최숙진|rule-step|상태 변경 시 고객 알림 자동발송
  STD-ADO-006|C5|미착수|재배정→최숙진|merged-owner_side|주문서(작업지시서) 출력
  STD-ADO-007|C5|작동|provided→최숙진|evidence-path|고객 SMS/알림톡 수동 발송
  STD-ADO-020|C6|작동|재배정→서희항|merged-owner_side|송장 등록·일괄 업로드
  STD-ADO-021|C6|작동|재배정→서희항|merged-owner_side|출고 처리·배송중 전이
  STD-SYS-007|C3|작동|담당맞음→김동학|merged-owner_side|커머스 플랫폼 API 인증·토큰 관리
  STD-SYS-008|C3|부분|재배정→서희항|manual-read|인쇄 도메인 DB ↔ 커머스 상품 동기화
  STD-SYS-009|C3|작동|담당맞음→김동학|merged-owner_side|가격 계산 결과 카트 주입 브리지
  STD-SYS-010|C3|구현-미검증|재배정→서희항|evidence-path|원고 저장소(스토리지) 연동
  STD-SYS-013|C3|작동|담당맞음→김동학|merged-owner_side|우편번호/주소 검색 서비스 연동
  STD-SYS-014|C3|부분|담당맞음→김동학|merged-owner_side|택배사 배송추적 연동
  STD-SYS-015|C3|미착수|담당맞음→김동학|merged-owner_side|웹 로그/전환 분석 도구 연동
  STD-SYS-023|C3|미착수|담당맞음→김동학|merged-owner_side|담기 전달값의 민감정보 비노출·서명 검증(계약 준수)
  STD-SYS-039|C3|미착수|재배정→최숙진|evidence-path|웹훅 등록 화면 위치 확인(셀러어드민 내 미발견) 및 등록 여부
  STD-SYS-041|C3|미착수|분할→김동학+신우진|rule-track|상품 텍스트옵션 라벨 huni_token 미등록 확정(U-2) → 스킨 담기 구현 정합
  STD-SYS-045|C3|미착수|분할→김동학+서희항|merged-owner_side|후니 위젯 서버키 헤더(X-Huni-Server-Key) 전송 배선 — 제공자가 WAPI_
  STD-SYS-049|C3|미착수|담당맞음→김동학|merged-owner_side|Railway `vc_v_product_detail_tabs` 직접 SELECT — pg.
  STD-MFG-114|C6|미착수|재배정→서희항|merged-owner_side|한 주문에 다중 송장 부여
