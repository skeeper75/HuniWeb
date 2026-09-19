# t56 — 담당자별 Todo(재판정 후) · 오픈일정 S7-A

입력 = `07_rebaseline/S/S5-plan/plan-rows.csv` 735행 · `08_system-screen/t51/merged.csv` 747행.
판정 = 5분류(담당맞음 / 재배정 / 분할 / provided·불필요 / 미정). **재배정은 제안까지 — 결정은 지니.**
작업량·날짜 추정 0. 모든 행의 근거는 `rejudge.csv` 의 `basis`·`evidence` 열.

## 0. 전체

- 원장 735행 중 남은 일(status≠작동) = **620행**
- 판정 분포(735행 전체): 담당맞음 456 · 재배정 134 · 분할 44 · provided 37 · 불필요 1 · 미정 63
- 근거 등급: merged-owner_side 366 · evidence-path 177 · rule-track 99 · rule-step 85 · manual-read 8

| 근거등급 | 뜻 |
|---|---|
| manual-read | 그 evidence 파일을 열어 확인함(파일·줄 명시) |
| merged-owner_side | t51 merged.csv 가 그 기능이 사는 코드 쪽을 이미 적어 둔 행 |
| evidence-path | plan-rows evidence 가 저장소·호스트를 직접 가리킴 |
| rule-step | 위가 전부 없어 CARDS-S §1 단계 기본 담당으로만 판정 — **약한 근거** |
| rule-track | 위가 전부 없고 트랙/수기 판단 — **약한 근거** |

## 담당자 한 장 요약(전원)

| 담당 | 현재 행 | 남은 일 | 담당맞음 | 재배정 | 분할 | 제공/불필요 | 미정 | 넘어올 제안 |
|---|---|---|---|---|---|---|---|---|
| 서희항 | 202 | 144 | 113 | 11 | 11 | 9 | 0 | 57 |
| 김동학 | 244 | 193 | 127 | 45 | 17 | 23 | 3 | 43 |
| 최숙진 | 153 | 150 | 104 | 31 | 10 | 6 | 2 | 65 |
| 신우진 | 69 | 66 | 19 | 40 | 4 | 0 | 3 | 16 |


## 서희항

### 한 장 요약

| 항목 | 행수 |
|---|---|
| 현재 걸린 행(원장 전체) | 202 |
| 그중 남은 일(status≠작동) | 144 |
| ① 담당 맞음 — 그대로 한다 | 113 |
| ② 다른 담당으로 넘길 제안 | 11 |
| ③ 행을 나눠야 함(경계 걸침) | 11 |
| ④ 샵바이·MES 제공이라 개발 일 아님 / 불필요 | 9 |
| ⑤ 미정(실측·결정 전이라 배정 불가) | 0 |
| **다른 사람에게서 넘어올 제안** | **57** |

재판정 뒤 이 사람이 실제로 질 남은 일(제안 기준) = 113 + 넘어옴 57 = **170행** (+ 나눠야 하는 11행의 자기 몫)

### 트랙별

| 트랙 | 남은 일 | 담당맞음 | 재배정 | 분할 | 제공/불필요 | 미정 |
|---|---|---|---|---|---|---|
| T1 인프라 이전(Lightsail) | 14 | 14 | 0 | 0 | 0 | 0 |
| T2 상품·가격·위젯 준비 | 41 | 39 | 2 | 0 | 0 | 0 |
| T3 쇼핑몰 주문·결제·회원 | 3 | 0 | 1 | 2 | 0 | 0 |
| T4 주문 수신·원고·생산 연동 | 80 | 59 | 8 | 5 | 8 | 0 |
| T5 운영 설정·알림·CS·증빙 | 4 | 0 | 0 | 4 | 0 | 0 |
| T7 테스트·리허설·컷오버 | 2 | 1 | 0 | 0 | 1 | 0 |

### ① 담당 맞음 — 그대로 한다 — 113행

| row_id | 트랙.단계 | status | 일 | 근거등급 |
|---|---|---|---|---|
| F1-2 | T1.F1 | 미착수 | `huni/dev/admin-runtime-env` 시크릿 채움(필수: `DJANGO_SECRET_KEY` 고정 난수≥32자· | rule-step |
| F1-3 | T1.F1 | 미착수 | Actions → 「Deploy to dev (huni-admin)」 수동 실행(master) | rule-step |
| F1-4 | T1.F1 | 미착수 | 사이드카·LB 실측: cron 로그 `cron_hourly 시작 — 매시 :15` → 정시 `recalc 종료` · 60초 초 | rule-step |
| F1-5 | T1.F1 | 미착수 | 첫 성공 후 `deploy.yml` push 트리거 주석 해제 + `test_deploy_workflow_manual_firs | rule-step |
| T1-1 | T1.F1 | 미착수 | 관리서버(webadmin) Lightsail dev 배포·검증 — F1-1~F1-5 | rule-step |
| F2-2 | T1.F2 | 미착수 | 리허설: Railway `pg_dump --no-owner --no-acl` 평문 SQL → 임시 스키마에 복원 → 검증 4종 | rule-step |
| F2-3 | T1.F2 | 미착수 | vc_ 2객체 재덤프(파이썬 DDL+INSERT 조립) → `webapp` 적재 → 웹팀 도구 접속 문자열 `webapp` 확 | rule-step |
| F2-4 | T1.F2 | 미착수 | 본반입 창: Railway 관리자 쓰기 정지 공지 → 재덤프 → `hunidb` 반입 → 검증 4종 → 행수 지문 대조 | rule-step |
| T1-2 | T1.F2 | 미착수 | DB 반입(PG 18.6→17) 리허설·본반입·검증 4종·vc_ 분리 — F2-1~F2-4 | rule-step |
| F3-1 | T1.F3 | 미착수 | Railway `start-price-cron` 정지 | rule-step |
| F3-10 | T1.F3 | 미착수 | 전환 후 실측: `/healthz`·로그인·위젯 설정 API 지연·장바구니→재견적·크론 로그 | rule-step |
| F3-8 | T1.F3 | 미착수 | Railway 변수 이관 대조(`railway variables --service huni-admin` 키 목록, 값 노출 금 | rule-step |
| F3-9 | T1.F3 | 미착수 | Edicus 허용 도메인/콜백에 새 호스트 필요 여부 확인 | rule-step |
| T1-3 | T1.F3 | 미착수 | 운영 전환 12단계(F3-11 Railway 종료는 오픈 테스트 통과 전 금지) | rule-step |
| STD-ADP-006 | T2.A1 | 구현-미검증 | 공정 택일그룹 관리 | evidence-path |
| STD-ADP-008 | T2.A1 | 구현-미검증 | 제본 방식 마스터 관리 | merged-owner_side |
| STD-CAT-035 | T2.A1 | 미착수 | 디자인 식별 규약 — PS코드 1개 + 템플릿 경로(이름) 구분·정사각형 공용 템플릿 | merged-owner_side |
| STD-CAT-036 | T2.A1 | 미착수 | 디자인 목록 API — webadmin 등록분을 신규몰이 불러오는 연동 | merged-owner_side |
| STD-CAT-039 | T2.A1 | 부분 | 목록 시작가 자동 계산(위젯 기본값) — 오리지널 명함만 수기 입력 | merged-owner_side |
| STD-ADP-025 | T2.A2 | 구현-미검증 | 단가행 일괄 등록(엑셀 업로드) | merged-owner_side |
| STD-ADP-026 | T2.A2 | 구현-미검증 | 단가유형(단가형/합가형) 설정 | merged-owner_side |
| STD-ADP-028 | T2.A2 | 구현-미검증 | 면적 매트릭스 단가 관리 | evidence-path |
| STD-ADP-017 | T2.A3 | 구현-미검증 | 상품별 옵션그룹 구성 | merged-owner_side |
| STD-ADP-019 | T2.A3 | 구현-미검증 | 옵션 참조 무결성 검증 | evidence-path |
| STD-ADP-021 | T2.A3 | 구현-미검증 | 제약규칙 등록(UI 폼빌더) | merged-owner_side |
| STD-ADP-022 | T2.A3 | 구현-미검증 | 제약규칙 시뮬레이션·미리보기 | merged-owner_side |
| STD-OPT-004 | T2.A3 | 부분 | 옵션 선택 캐스케이드(상위 선택이 하위 목록 갱신) | merged-owner_side |
| STD-OPT-005 | T2.A3 | 부분 | 토글형 후가공 섹션(켜야 하위 선택지 노출) | rule-step |
| STD-OPT-006 | T2.A3 | 부분 | 옵션 그룹 접기/펼치기·진행 스텝 표시 | merged-owner_side |
| STD-OPT-037 | T2.A3 | 부분 | 옵션 조합 제약 규칙 평가(불가 조합 차단·사유 표시) | merged-owner_side |
| STD-OPT-038 | T2.A3 | 부분 | 자재→가능 인쇄방식 게이팅 | evidence-path |
| STD-OPT-040 | T2.A3 | 부분 | 필수 동반 옵션 강제(예 인쇄없음 시 후가공 필수) | rule-step |
| STD-OPT-042 | T2.A3 | 부분 | 사이즈 범위·비율 검증(매트릭스 밖 사이즈 차단) | rule-step |
| T2-3 | T2.A4 | 부분 | 샵바이 상품 연동 — 시작가 「10원~」 교정·상품 수 296/291/297 불일치 규명 | merged-owner_side |
| STD-OPT-019 | T2.B2 | 부분 | 페이지 수 입력(책자류 필수 축) | rule-step |
| STD-OPT-024 | T2.B2 | 부분 | 코팅 선택(무광/유광 × 단면/양면) | rule-step |
| STD-OPT-026 | T2.B2 | 부분 | 형압(양각/음각) 선택 | evidence-path |
| STD-OPT-027 | T2.B2 | 부분 | 오시 선택(줄 수 × 방향) | evidence-path |
| STD-OPT-028 | T2.B2 | 부분 | 미싱 선택 | rule-step |
| STD-OPT-029 | T2.B2 | 부분 | 타공 선택(직경 × 개수 × 위치) | rule-step |
| STD-OPT-030 | T2.B2 | 부분 | 귀돌이/라운딩 선택(반경 × 모서리 위치) | rule-step |
| STD-OPT-032 | T2.B2 | 미착수 | 넘버링(일반/난수 × 자릿수 × 개수) 선택 | rule-step |
| STD-OPT-033 | T2.B2 | 부분 | 부분UV/에폭시 선택 | rule-step |
| T2-4 | T2.B2 | 부분 | 위젯 견적·원고 업로드·편집기(Edicus) 경로 검증 | merged-owner_side |
| STD-ART-002 | T2.B3 | 구현-미검증 | 대용량 파일 분할/재개 업로드 | merged-owner_side |
| STD-ART-003 | T2.B3 | 부분 | 업로드 진행률·실패 재시도 | rule-step |
| STD-ART-004 | T2.B3 | 부분 | 건수별 개별 파일 업로드(디자인 N종) | merged-owner_side |
| STD-ART-005 | T2.B3 | 부분 | 앞면/뒷면 파일 분리 업로드 | rule-step |
| STD-ART-006 | T2.B3 | 부분 | 주문 이후 파일 업로드 경로(결제 후 입고) | evidence-path |
| STD-ART-007 | T2.B3 | 부분 | 파일 재업로드·버전 이력 보관 | evidence-path |
| STD-ART-024 | T2.B3 | 부분 | 에디터 산출물 인쇄용 파일 변환·주문 연결 | merged-owner_side |
| STD-ART-030 | T2.B3 | 미착수 | 「옵션 조합에 연결된 편집기 템플릿 없음」 오류 — 에디쿠스 템플릿 연결 점검 | merged-owner_side |
| STD-ART-031 | T2.B3 | 미착수 | 삭제된 사이즈 코드가 연결된 템플릿 전수조사(800여 개 중 노출 대상 선별) | rule-step |
| T4-2 | T4.C2 | 구현-미검증 | 원고 승격 실파일 1건 종단 + 웹훅 해석 소비자 구현(입금→PAID 전이) | rule-step |
| STD-ADO-009 | T4.C4 | 미착수 | 재업로드 요청 발송 | rule-step |
| STD-ART-015 | T4.C4 | 미착수 | 검판 결과 리포트 고객 노출 | rule-step |
| STD-ART-018 | T4.C4 | 미착수 | 재업로드 요청 발송(문자/알림) | rule-step |
| STD-MFG-036 | T4.C4 | 미착수 | 원고 바이러스 온디맨드 명시 스캔 | evidence-path |
| STD-MFG-037 | T4.C4 | 미착수 | 바이러스 검사 3중 교차 판정(스캔결과·탐지기록·파일존재해시) | evidence-path |
| STD-MFG-038 | T4.C4 | 미착수 | 시그니처 신선도 확인·오래되면 보류 | evidence-path |
| STD-MFG-039 | T4.C4 | 미착수 | 스캔 실패·타임아웃은 통과가 아니라 보류(재시도 큐) | evidence-path |
| STD-MFG-040 | T4.C4 | 미착수 | 감염 파일 격리+담당자 알림+고객 재업로드 요청 | evidence-path |
| STD-MFG-044 | T4.C4 | 미착수 | 폰트 미포함 검사 | evidence-path |
| STD-MFG-046 | T4.C4 | 미착수 | 페이지 수와 주문 사양 대조 | evidence-path |
| STD-MFG-049 | T4.C4 | 미착수 | 판정 3갈래 분기(자동 재업로드 요청·담당자 검수·담당자 발 요청) | merged-owner_side |
| STD-MFG-051 | T4.C4 | 미착수 | FR-6 프리플라이트 재실행 요청 수신 | merged-owner_side |
| STD-MFG-052 | T4.C4 | 미착수 | 검사 감사기록 보관(검사시각·엔진시그니처버전·판정·탐지명·파일해시·PitStop 리포트) | merged-owner_side |
| STD-MFG-053 | T4.C4 | 미착수 | 검사 없이 PitStop 투입 경로 차단(코드상 부재 보장) | merged-owner_side |
| STD-MFG-054 | T4.C4 | 미착수 | FR-4 재업로드 요청 수신→서명 1회성 링크 발급(주문·항목·구성원 바인딩·7일) | merged-owner_side |
| STD-MFG-055 | T4.C4 | 미착수 | 재업로드 화면(위젯 업로드 컴포넌트 재사용·대상 파일 지정) | merged-owner_side |
| STD-MFG-056 | T4.C4 | 미착수 | 재업로드 시 회차 증가+검사 자동 재실행 | merged-owner_side |
| STD-MFG-057 | T4.C4 | 미착수 | 원고 보완 대기 중 주문상태 결제완료 유지(고객 취소권 보존) | merged-owner_side |
| STD-MFG-064 | T4.C4 | 미착수 | 편집기 상품 수정요청·수정완료 왕복 | merged-owner_side |
| STD-ADO-015 | T4.C5 | 미착수 | 생산 지시 데이터 연계(JDF/XJDF) | rule-step |
| STD-ART-028 | T4.C5 | 부분 | 생산용 원고 자동 다운로드/전달 | evidence-path |
| STD-MFG-001 | T4.C5 | 부분 | 주문 등록 API 수신(자사몰→우리·site_key/order_no/line_no/token) | manual-read |
| STD-MFG-002 | T4.C5 | 부분 | 주문 등록 멱등 처리(재시도 already:true·같은 자리 다른 사양 409) | evidence-path |
| STD-MFG-003 | T4.C5 | 부분 | 결제 사양 전문 보관(t_ord_orders·서명 token 검증 후 전개) | evidence-path |
| STD-MFG-004 | T4.C5 | 부분 | 원고 승격 tmp→order 버킷 CopyObject | evidence-path |
| STD-MFG-005 | T4.C5 | 부분 | 승격 시 원본 실존·크기 실측 대조(head_object) fail-closed | evidence-path |
| STD-MFG-006 | T4.C5 | 부분 | 승격 실패 시 주문 보류(HOLD)+사유 기록 | evidence-path |
| STD-MFG-007 | T4.C5 | 미착수 | 담당자용 보류 주문 목록 화면 | evidence-path |
| STD-MFG-008 | T4.C5 | 부분 | 원고 키 회차(r{n}) 규약·재업로드 누적 보관 | evidence-path |
| STD-MFG-009 | T4.C5 | 부분 | MES 넘길 파일 목록 산출(t_ord_artworks 최신 회차) | evidence-path |
| STD-MFG-011 | T4.C5 | 부분 | MES 품목코드 중복 검증(부분 유니크·삭제상품 점유 명시) | evidence-path |
| STD-MFG-012 | T4.C5 | 미착수 | MES 품목코드 매핑 현황 목록 노출 | evidence-path |
| STD-MFG-013 | T4.C5 | 미착수 | MES-1 주문 접수 전송(WCF·주문헤더+제작사양 전문+원고 목록+handoff_id) | evidence-path |
| STD-MFG-014 | T4.C5 | 미착수 | MES 중복 전송 방지 도장 | evidence-path |
| STD-MFG-015 | T4.C5 | 미착수 | MES-2 주문 취소 통보(생산중지 요청) | evidence-path |
| STD-MFG-016 | T4.C5 | 미착수 | MES-3 원고 교체 통보(회차 증가 시 새 키 전달) | evidence-path |
| STD-MFG-017 | T4.C5 | 미착수 | MES-4 배송지·수령자 변경 통보(출고 전 한정) | evidence-path |
| STD-MFG-018 | T4.C5 | 미착수 | MES-5 주문 조회 재동기화 | evidence-path |
| STD-MFG-019 | T4.C5 | 미착수 | MES→우리 API 인증(VPC 사설 경로+API 키·인터넷 미개방) | evidence-path |
| STD-MFG-020 | T4.C5 | 미착수 | 주문 큐 비동기 처리(SQS 디커플·MES 다운 중에도 접수 지속) | rule-step |
| STD-MFG-021 | T4.C5 | 미착수 | 실패 재시도·DLQ·처리 실패 주문 관리자 화면 | evidence-path |
| STD-MFG-099 | T4.C5 | 부분 | 셋트상품·건수(같은 사양 반복) MES 작업 분해 | evidence-path |
| STD-MFG-131 | T4.C5 | 미착수 | 단계별 체류 건수·DLQ 처리 현황 대시보드 | evidence-path |
| STD-MFG-136 | T4.C5 | 미착수 | 샵바이 웹훅 이벤트 수신 후 소비(결제완료 → 주문 상태 반영 · 생산 전환 착수) | evidence-path |
| STD-MFG-124 | T4.C6 | 미착수 | 반품·교환 웹훅 기록만 하고 MES 작업 자동생성 안 함 | merged-owner_side |
| STD-MFG-022 | T4.C7 | 부분 | 주문 상태머신(REGISTERED/PROMOTING/PROMOTED/HOLD/PAID/FILE_CHECK/FILE_HOLD/M | evidence-path |
| STD-MFG-023 | T4.C7 | 부분 | 상태 단위=주문상품옵션(orderProductOptionNo)·주문 단위는 롤업 | evidence-path |
| STD-MFG-024 | T4.C7 | 부분 | 3시스템 매핑 테이블(handoff_id·orderNo+orderProductOptionNo·MES 작업번호) | evidence-path |
| STD-MFG-025 | T4.C7 | 미착수 | FR-1 MES 주문 상태 변경 통보 수신(접수완료/생산대기/생산중/생산완료) | evidence-path |
| STD-MFG-026 | T4.C7 | 미착수 | 접수완료 시 취소 잠금 원자적 전환(cancelable CAS) | evidence-path |
| STD-MFG-027 | T4.C7 | 미착수 | TO-2 샵바이 상품준비중 전환(취소 창구 닫기) | merged-owner_side |
| STD-MFG-028 | T4.C7 | 미착수 | FR-2 MES 송장번호 등록 수신 | evidence-path |
| STD-MFG-029 | T4.C7 | 미착수 | TO-3 샵바이 배송처리(송장 등록·정정) | merged-owner_side |
| STD-MFG-030 | T4.C7 | 미착수 | 우리가 올린 상태변경 웹훅 메아리 필터(무한루프 방지) | merged-owner_side |
| STD-MFG-031 | T4.C7 | 미착수 | FR-3 MES 발 주문 취소 요청 수신→샵바이 취소·환불(TO-4) | merged-owner_side |
| STD-MFG-032 | T4.C7 | 미착수 | FR-5 취소요청 승인·거부 수신→샵바이 클레임 처리(TO-5) | merged-owner_side |
| STD-MFG-033 | T4.C7 | 미착수 | 생산 시작 후 도착한 취소는 자동 처리하지 않고 담당자 에스컬레이션 | evidence-path |
| STD-MFG-034 | T4.C7 | 미착수 | FR-7 주문 메모 기록→샵바이 업무 메시지 동기화(TO-6) | merged-owner_side |
| STD-SYS-026 | T7.E4 | 미착수 | 오픈·안정화 후 유지보수 내부 인력 이관 | rule-track |

### ② 다른 담당으로(제안) — 11행

| row_id | 트랙.단계 | status | 일 | 제안 담당 | 근거등급 | 근거 |
|---|---|---|---|---|---|---|
| STD-OPT-056 | T2.B2 | 구현-미검증 | 캘린더 가공·장수(월수) 선택 | 김동학 | evidence-path | 그 일이 사는 곳=huni-mall |
| STD-ART-029 | T2.B3 | 미착수 | 가변데이터 인쇄(VDP) 데이터 업로드·병합 | 김동학 | evidence-path | 그 일이 사는 곳=huni-mall |
| STD-PAY-007 | T3.B6 | 부분 | 적립금(프린팅머니) 결제 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-ADO-012 | T4.C5 | 미착수 | 인쇄 공정 상태 트래킹 | 최숙진 | merged-owner_side | MES 현행 기능·생산 현장 운영 — 신규 개발이면 외부(MES 담당) |
| STD-MFG-078 | T4.C5 | 미착수 | 파일명 자동 RENAME 규약 적용(품목_출력사이즈_양단면_소재_거래처_고객_고유번호_수량) | 최숙진 | evidence-path | MES 현행 기능·생산 현장 운영 — 신규 개발이면 외부(MES 담당) |
| STD-MFG-079 | T4.C5 | 미착수 | 상품군별 파일명 조합 규칙 8종(디지털/캘린더/스티커/실사/배너/패브릭/시트커팅/레이저커팅) | 최숙진 | evidence-path | MES 현행 기능·생산 현장 운영 — 신규 개발이면 외부(MES 담당) |
| STD-MFG-084 | T4.C5 | 미착수 | 공정라우트 마스터(18케이스 라우트 정의·재채번) | 최숙진 | merged-owner_side | MES 현행 기능·생산 현장 운영 — 신규 개발이면 외부(MES 담당) |
| STD-MFG-085 | T4.C5 | 미착수 | 라우트 단계 정의(순번·공정·필수선택·담당팀) | 최숙진 | evidence-path | MES 현행 기능·생산 현장 운영 — 신규 개발이면 외부(MES 담당) |
| STD-MFG-086 | T4.C5 | 미착수 | 상품→공정라우트 매핑 | 최숙진 | evidence-path | MES 현행 기능·생산 현장 운영 — 신규 개발이면 외부(MES 담당) |
| STD-MFG-096 | T4.C5 | 미착수 | 2차 산출데이터(팀별 입고예정·공정별 평균리드타임·평균 제작기간) | 최숙진 | evidence-path | MES 현행 기능·생산 현장 운영 — 신규 개발이면 외부(MES 담당) |
| STD-MFG-115 | T4.C6 | 미착수 | 합배송 리스트 식별 | 최숙진 | evidence-path | MES 현행 기능·생산 현장 운영 — 신규 개발이면 외부(MES 담당) |

### ③ 행을 나눠야 함 — 11행

| row_id | 트랙.단계 | status | 일 | 제안 담당 | 근거등급 | 근거 |
|---|---|---|---|---|---|---|
| STD-OPT-057 | T3.A5 | 미착수 | 규격 가이드 모달(사이즈 안내 팝업) | 김동학+최숙진 | merged-owner_side | 규격 가이드 모달 — 모달 구현=김동학 / 사이즈 안내 내용=최숙진(역할①) |
| STD-OPT-058 | T3.A5 | 미착수 | 주문가능 자재(용지) 목록 모달 | 김동학+최숙진 | merged-owner_side | 주문가능 자재 목록 모달 — 모달 구현=김동학 / 자재 안내 내용=최숙진(역할①) |
| BLK-S1-5 | T4.C1 | 미착수 | [선행 입력] `order/register` 계약(엔드포인트·페이로드·서버키) | 서희항+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| BLK-S2-1 | T4.C1 | 미착수 | [선행 입력] Railway 운영 변수 4종 설정 여부(값 아님) — `WAPI_SERVER_KEY_REQUIRED`·`SHO | 서희항+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| BLK-S2-5 | T4.C2 | 미착수 | [선행 입력] Lightsail 이전 후 크론·워커 실행 형태 | 서희항+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| T4-3 | T4.C4 | 없음 | 파일 검수 경로 결정·구축 — PitStop 조달 또는 사람 검수(D-P1·D-P2) | 서희항+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| T4-4 | T4.C5 | 없음 | 접수 화면·주문 상태머신·MES 접수 전송(D-P5·D-P6·D-P7) | 미정+최숙진 | merged-owner_side | 두 시스템에 걸침(mes,미정) — 행을 나눠 각자에게 |
| STD-MFG-125 | T5.D1 | 미착수 | 파일 오류 재업로드 요청 알림톡 발송(자동·담당자 발) | 서희항+최숙진 | evidence-path | 파일 오류 재업로드 알림 — 발송 배선(webadmin)=서희항 / 알림톡 템플릿·계약=최숙진 |
| STD-MFG-126 | T5.D1 | 미착수 | 재업로드 접수 확인 알림 | 서희항+최숙진 | evidence-path | 재업로드 접수 확인 알림 — 발송 배선=서희항 / 템플릿=최숙진 |
| STD-MFG-127 | T5.D1 | 미착수 | 편집상품 수정요청 알림(주문번호·편집번호·안내) | 서희항+최숙진 | evidence-path | 편집상품 수정요청 알림 — 발송 배선=서희항 / 템플릿=최숙진 |
| STD-MFG-129 | T5.D1 | 미착수 | 알림톡 발송 실패 시 SMS/LMS 자동 대체 | 서희항+최숙진 | evidence-path | 알림톡 실패 시 SMS/LMS 대체 — 대체 로직=서희항 / 채널 계약=최숙진 |

### ④ 제공/불필요 — 개발 일 아님(확인만) — 9행

| row_id | 트랙.단계 | status | 일 | 제안 담당 | 근거등급 | 근거 |
|---|---|---|---|---|---|---|
| STD-ART-008 | T4.C4 | 미착수 | 파일 포맷 유효성 검사 | 서희항 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 서희항 |
| STD-ART-009 | T4.C4 | 미착수 | 재단선/블리드 3mm 확보 검사 | 서희항 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 서희항 |
| STD-ART-010 | T4.C4 | 미착수 | 색공간(CMYK) 검사 및 RGB 경고 | 서희항 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 서희항 |
| STD-ART-011 | T4.C4 | 미착수 | 해상도(dpi) 검사 | 서희항 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 서희항 |
| STD-ART-012 | T4.C4 | 미착수 | 폰트 아웃라인 여부 검사 | 서희항 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 서희항 |
| STD-ART-013 | T4.C4 | 미착수 | 주문 사양과 파일 실측 사이즈 대조 | 서희항 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 서희항 |
| STD-ART-014 | T4.C4 | 미착수 | 별색 채널·오버프린트 검사 | 서희항 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 서희항 |
| STD-MFG-048 | T4.C4 | 미착수 | 파일 열림·손상·암호 걸림 검사 | 서희항 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 서희항 |
| STD-SYS-027 | T7.E4 | 미착수 | 기술 책임 총괄 = CTO 서희항 대표 | — | rule-track | 「기술 책임 총괄 = CTO 서희항」은 확정 사실 기록이지 작업 행이 아니다 — 원장에서 작업으로 세지 말 것 |

### 넘어올 제안 — 57행

| row_id | 트랙.단계 | status | 일 | 현재 담당 | 판정 | 근거등급 |
|---|---|---|---|---|---|---|
| F3-11 | T1.F3 | 미착수 | Railway 3서비스 종료(최종 덤프 보관 후) | 신우진 | 재배정 | rule-track |
| F3-4 | T1.F3 | 미착수 | 샵바이 콘솔 IP 화이트리스트 52.78.126.17 등록 → 메인이미지 동기화 1건 실측 | 최숙진 | 재배정 | rule-step |
| F3-5 | T1.F3 | 미착수 | 샵바이 웹훅 수신 URL → 새 호스트 `/api/w/v1/shopby/webhook/<secret>` | 최숙진 | 재배정 | rule-step |
| F3-7 | T1.F3 | 미착수 | DNS `huni-admin.printly.co.kr` CNAME → Lightsail + `CUSTOM_D | 신우진 | 재배정 | rule-track |
| STD-ADP-034 | T2.A1 | 미실측 | 수작 상품 등록 | 신우진 | 재배정 | rule-step |
| STD-CAT-033 | T2.A1 | 미착수 | 디자인 상품 화면 구조 — 카테고리 → 디자인 목록 → 상세 페이지 | 김동학 | 재배정 | merged-owner_side |
| STD-CAT-040 | T2.A1 | 미착수 | 시작가가 API 로 샵바이에 내려가는데 쇼핑몰에 반영되지 않는 원인 확인 | 신우진 | 재배정 | rule-step |
| STD-ADP-037 | T2.A2 | 부분 | 게시 위젯 가격 전수 대조(1차 최숙진 → 2차 김용기 → 3차 채훈희 승인) | 최숙진 | 재배정 | merged-owner_side |
| STD-OPT-048 | T2.A2 | 부분 | 면적 기반 가격 계산(실사·현수막·아크릴) | 최숙진 | 재배정 | evidence-path |
| STD-OPT-050 | T2.A2 | 부분 | 고정가형 가격 계산(수량×옵션) | 최숙진 | 재배정 | evidence-path |
| STD-OPT-051 | T2.A2 | 부분 | 셋트/부품조립 상품 합산 가격 계산 | 최숙진 | 재배정 | merged-owner_side |
| STD-OPT-039 | T2.A3 | 부분 | 공정 택일 그룹(상호배타) 처리 | 최숙진 | 재배정 | evidence-path |
| T2-2 | T2.A3 | 부분 | 위젯 기본값 미지정 교정·재게시 | 최숙진 | 재배정 | merged-owner_side |
| STD-CAT-043 | T2.A4 | 미착수 | 목록·검색 시작가를 webadmin `GET /api/w/v1/catalog`(게시 위젯+시작가) 로 이관  | 김동학 | 분할 | merged-owner_side |
| STD-OPT-016 | T2.B2 | 부분 | 작업 사이즈 입력·자동 도출(도련 포함) | 최숙진 | 재배정 | merged-owner_side |
| STD-OPT-025 | T2.B2 | 부분 | 박 선택(색상 다종 × 면 × 크기 × 내용같음/틀림) | 최숙진 | 재배정 | merged-owner_side |
| STD-OPT-035 | T2.B2 | 미착수 | 상품별 기본제공 부자재 규칙 표시 | 최숙진 | 재배정 | merged-owner_side |
| STD-OPT-053 | T2.B2 | 미착수 | 견적 결과 저장(옵션보관함) | 신우진 | 재배정 | rule-track |
| STD-OPT-054 | T2.B2 | 미착수 | 견적서 PDF/출력물 발급 | 신우진 | 재배정 | rule-track |
| STD-ART-019 | T2.B3 | 미착수 | 업로드 파일 썸네일·PDF 미리보기 | 김동학 | 재배정 | rule-step |
| STD-ART-020 | T2.B3 | 미착수 | 재단선 오버레이 미리보기 | 김동학 | 재배정 | rule-step |
| STD-ART-021 | T2.B3 | 부분 | 온라인 디자인 에디터 진입 | 최숙진 | 재배정 | merged-owner_side |
| STD-ART-023 | T2.B3 | 미착수 | 에디터 작업물 저장·재편집 | 신우진 | 재배정 | rule-track |
| STD-ART-025 | T2.B3 | 부분 | 선택 옵션(사이즈·페이지)과 에디터 캔버스 동기화 | 최숙진 | 재배정 | rule-step |
| STD-ART-032 | T2.B3 | 미착수 | 에디쿠스 테스트용 단순 상품(메모패드 등) 제공 | 최숙진 | 재배정 | rule-step |
| STD-ADC-014 | T3.A5 | 구현-미검증 | 인쇄 가이드 콘텐츠 관리 | 김동학 | 분할 | merged-owner_side |
| STD-CAT-011 | T3.A5 | 미착수 | 상품별 제작 소요일/출고 기준 안내 | 김동학 | 분할 | merged-owner_side |
| STD-CAT-034 | T3.A5 | 부분 | 상세페이지 탭 6종 자동 등록(디자인가이드·디자인보기 포함) | 김동학 | 분할 | merged-owner_side |
| STD-MEM-018 | T3.B5 | 미착수 | 회원등급 산정·자동 승급 | 최숙진 | 재배정 | merged-owner_side |
| STD-MEM-020 | T3.B5 | 미착수 | 기존 회원 데이터 이관(구 사이트) | 김동학 | 재배정 | merged-owner_side |
| STD-PAY-013 | T3.B6 | 부분 | 결제 금액 위변조 검증(서버 재계산 대조) | 김동학 | 분할 | manual-read |
| STD-PAY-031 | T3.B6 | 미착수 | 위젯 총액↔shopby 청구액 「10원×수량」 모델 정합 검증(표시↔청구 불일치 알려진 이슈) | 김동학 | 분할 | manual-read |
| STD-ORD-027 | T3.B7 | 부분 | 오프라인 주문 별도 등록 경로 | 김동학 | 재배정 | evidence-path |
| STD-ADC-004 | T3.D2 | 미착수 | 프린팅머니 수동 지급·차감 | 김동학 | 재배정 | merged-owner_side |
| STD-MYP-003 | T3.D2 | 미착수 | 편집상품 미리보기 | 김동학 | 분할 | manual-read |
| STD-MYP-030 | T3.D2 | 부분 | 편집 디자인 보관함 — 편집 종료 후 보관, 장바구니 담기 전까지 수정 가능 | 김동학 | 분할 | merged-owner_side |
| STD-ART-027 | T4.C2 | 미착수 | 과거 주문 파일 재사용 재주문 | 신우진 | 분할 | rule-track |
| STD-SYS-008 | T4.C3 | 부분 | 인쇄 도메인 DB ↔ 커머스 상품 동기화 | 김동학 | 재배정 | manual-read |
| STD-SYS-010 | T4.C3 | 구현-미검증 | 원고 저장소(스토리지) 연동 | 김동학 | 재배정 | evidence-path |
| STD-SYS-045 | T4.C3 | 미착수 | 후니 위젯 서버키 헤더(X-Huni-Server-Key) 전송 배선 — 제공자가 WAPI_SERVER_KEY | 김동학 | 분할 | merged-owner_side |
| STD-ADO-008 | T4.C4 | 미착수 | 파일 확인 처리(검판 판정) | 최숙진 | 재배정 | merged-owner_side |
| STD-ART-016 | T4.C4 | 미착수 | 자동검판 도구 연동(PitStop 등) | 신우진 | 재배정 | merged-owner_side |
| STD-MFG-050 | T4.C4 | 미착수 | 자동 발송 오류 목록 관리(좁게 유지·담당자와 확정) | 최숙진 | 재배정 | evidence-path |
| STD-ADO-002 | T4.C5 | 부분 | 주문 상세 조회(사양·파일·금액) | 김동학 | 재배정 | manual-read |
| STD-ADO-003 | T4.C5 | 부분 | 주문 상태 변경(단건) | 김동학 | 재배정 | manual-read |
| STD-ADO-005 | T4.C5 | 미착수 | 상태 변경 시 고객 알림 자동발송 | 김동학 | 재배정 | rule-step |
| STD-MFG-010 | T4.C5 | 부분 | 상품↔MES 품목코드(MES_ITEM_CD) 매핑 일괄 적재 | 최숙진 | 재배정 | evidence-path |
| STD-MFG-114 | T4.C6 | 미착수 | 한 주문에 다중 송장 부여 | 김동학 | 재배정 | merged-owner_side |
| STD-MFG-123 | T4.C6 | 미착수 | 재출고 신규송장 부여(상품누락 추가발송·교환 재발송) | 최숙진 | 재배정 | merged-owner_side |
| STD-SHP-012 | T4.C7 | 부분 | 송장번호 등록(판매자) | 김동학 | 재배정 | merged-owner_side |
| STD-SHP-013 | T4.C7 | 부분 | 송장 기반 배송상태 일괄변경 | 김동학 | 재배정 | merged-owner_side |
| STD-MFG-128 | T5.D1 | 미착수 | 알림톡 템플릿 사전 심사·승인 관리 | 신우진 | 재배정 | evidence-path |
| STD-B2B-001 | T5.E1 | 부분 | 거래처(기업회원) 등록·관리 | 김동학 | 재배정 | evidence-path |
| STD-SYS-025 | T5.E1 | 부분 | [구IA#44] 관리자 등록/관리 | 최숙진 | 재배정 | evidence-path |
| STD-MYP-009 | T6.D5 | 미착수 | 기존 프린트머니 잔액 이관 | 김동학 | 재배정 | merged-owner_side |
| STD-SYS-016 | T7.E4 | 부분 | 주문/결제 실패 모니터링·알림 | 김동학 | 재배정 | evidence-path |
| STD-SYS-017 | T7.E4 | 미착수 | 데이터 백업·복구 절차 | 김동학 | 재배정 | rule-track |


## 김동학

### 한 장 요약

| 항목 | 행수 |
|---|---|
| 현재 걸린 행(원장 전체) | 244 |
| 그중 남은 일(status≠작동) | 193 |
| ① 담당 맞음 — 그대로 한다 | 127 |
| ② 다른 담당으로 넘길 제안 | 45 |
| ③ 행을 나눠야 함(경계 걸침) | 17 |
| ④ 샵바이·MES 제공이라 개발 일 아님 / 불필요 | 23 |
| ⑤ 미정(실측·결정 전이라 배정 불가) | 3 |
| **다른 사람에게서 넘어올 제안** | **43** |

재판정 뒤 이 사람이 실제로 질 남은 일(제안 기준) = 127 + 넘어옴 43 = **170행** (+ 나눠야 하는 17행의 자기 몫)

### 트랙별

| 트랙 | 남은 일 | 담당맞음 | 재배정 | 분할 | 제공/불필요 | 미정 |
|---|---|---|---|---|---|---|
| T1 인프라 이전(Lightsail) | 9 | 9 | 0 | 0 | 0 | 0 |
| T2 상품·가격·위젯 준비 | 11 | 6 | 4 | 1 | 0 | 0 |
| T3 쇼핑몰 주문·결제·회원 | 102 | 80 | 10 | 12 | 0 | 0 |
| T4 주문 수신·원고·생산 연동 | 19 | 7 | 10 | 2 | 0 | 0 |
| T5 운영 설정·알림·CS·증빙 | 32 | 12 | 18 | 1 | 1 | 0 |
| T6 프린팅머니 | 7 | 2 | 1 | 1 | 0 | 3 |
| T7 테스트·리허설·컷오버 | 13 | 11 | 2 | 0 | 0 | 0 |

### ① 담당 맞음 — 그대로 한다 — 127행

| row_id | 트랙.단계 | status | 일 | 근거등급 |
|---|---|---|---|---|
| STD-SYS-024 | T1.E2 | 미착수 | 보호 라우트 리다이렉트가 vercel.app 도메인으로 튐(마이페이지·/admin) | merged-owner_side |
| STD-SYS-036 | T1.E2 | 미착수 | 쇼핑몰 도메인·SNS 콜백 URL 정합(shopby.huniprinting.com / shoby.huniprinting.com | merged-owner_side |
| STD-SYS-052 | T1.E2 | 미착수 | 환경변수 정합 — 코드 참조 vs .env.example vs vercel-env-push.sh 불일치(HUNI_WIDGET_ | merged-owner_side |
| F4-2 | T1.F4 | 미착수 | `deploy.yml` 스킨판 작성(webadmin 것을 본떠 OIDC→ECR→push-container-image→env 조 | merged-owner_side |
| F4-3 | T1.F4 | 미착수 | env 이관 — `.env.example` 기준 필수: `AUTH_SECRET`·`NEXTAUTH_URL`·`AUTH_GOOG | merged-owner_side |
| F4-4 | T1.F4 | 미착수 | `DATABASE_URL`(Prisma) 목적지 결정: Lightsail PG `webapp` 로 합칠지 별도 DB 로 갈지  | merged-owner_side |
| F4-5 | T1.F4 | 미착수 | DNS `shopby.huniprinting.co.kr` → Lightsail 스킨 + 인증서 · `NEXTAUTH_URL=h | merged-owner_side |
| F4-6 | T1.F4 | 미착수 | 소셜 콜백 검증: 구글·네이버·카카오 콘솔 Redirect URI = `${NEXTAUTH_URL}/oauth/callback | merged-owner_side |
| T1-4 | T1.F4 | 미착수 | 스킨 컨테이너화·도메인·소셜 콜백·env 이관(F4-8 Vercel 정지는 오픈 테스트 통과 전 금지) + 로그인 리다이렉트  | rule-step |
| STD-ADP-015 | T2.A1 | 부분 | 상품 상세페이지 콘텐츠 편집 | manual-read |
| STD-CAT-024 | T2.A1 | 부분 | 포장재 상품군 주문 경로(전용 옵션·주문 흐름) | evidence-path |
| STD-CAT-025 | T2.A1 | 부분 | 굿즈 상품군 주문 경로(파우치·백 포함) | evidence-path |
| STD-CAT-002 | T2.A4 | 부분 | 카테고리별 상품 리스팅(정렬·페이징) | merged-owner_side |
| STD-CAT-003 | T2.A4 | 미착수 | 상품군 전용 랜딩(출력/책자/실사/패키지/굿즈) | merged-owner_side |
| STD-CAT-022 | T2.A4 | 미착수 | 품절/판매중지 상품 표시 및 대체 안내 | merged-owner_side |
| STD-ADC-012 | T3.A5 | 미착수 | 대량견적/기업상담/디자인상담 접수 관리 | rule-step |
| STD-ADC-013 | T3.A5 | 미착수 | 메인/기획전 배너 관리 | rule-step |
| STD-ADC-015 | T3.A5 | 미착수 | 매장(거래처) 게시판 관리 | evidence-path |
| STD-ADC-016 | T3.A5 | 미착수 | 체험단 모집·신청내역 관리(운영자) | evidence-path |
| STD-CAT-008 | T3.A5 | 미착수 | 동일 계열 상품 분기 안내(일반명함/고급지명함/부분UV명함 등) | merged-owner_side |
| STD-CAT-013 | T3.A5 | 미착수 | 상품 Q&A 게시 | merged-owner_side |
| STD-CAT-015 | T3.A5 | 부분 | 사진 리뷰 갤러리 | merged-owner_side |
| STD-CAT-016 | T3.A5 | 미착수 | 관련상품/함께 주문한 상품 추천 | merged-owner_side |
| STD-CAT-017 | T3.A5 | 미착수 | 최근 본 상품 | merged-owner_side |
| STD-CAT-018 | T3.A5 | 미착수 | 찜/관심상품 | merged-owner_side |
| STD-CAT-021 | T3.A5 | 부분 | 메인 기획전/배너 영역 | merged-owner_side |
| STD-CAT-027 | T3.A5 | 미착수 | 홈 더미 콘텐츠 정리(BEST 8종 /product/1 404 · 프로모션 ZONE·새소식 영문 문구) | merged-owner_side |
| STD-CAT-029 | T3.A5 | 미착수 | 메뉴 슬러그형 목업 상세(/product/calendar 등) 잔존 — 「(44 Reviews)」·더미 옵션 | merged-owner_side |
| STD-CAT-042 | T3.A5 | 미착수 | 레거시 mock 훅 제거 — legacy-data 참조 17파일(configurator 11종·홈 뉴스/프로모·포인트 모달) | merged-owner_side |
| STD-INF-006 | T3.A5 | 미착수 | 자주묻는질문(FAQ) 고객 화면 | merged-owner_side |
| STD-INF-013 | T3.A5 | 미착수 | 저장소 문서 stale 정비 — docs/api/README 「코드는 아직 backend API 기준」·frontend REA | merged-owner_side |
| STD-PRM-010 | T3.A5 | 미착수 | 기획전/할인 이벤트 페이지 | merged-owner_side |
| STD-CAT-005 | T3.B1 | 미착수 | 종이/소재명 기준 검색(아트지·스노우지 등) | merged-owner_side |
| STD-CAT-006 | T3.B1 | 부분 | 검색어 자동완성·인기검색어 | merged-owner_side |
| STD-ORD-006 | T3.B4 | 부분 | 구매가능 검증(결제 전 sanity) | merged-owner_side |
| T3-1 | T3.B4 | 부분 | 회원 장바구니 인증 결함 수정(서버 프록시 토큰 · D-1) — 결함 1·2·3·5 공통 뿌리 | rule-step |
| STD-MEM-002 | T3.B5 | 부분 | 약관 동의·전체동의 | merged-owner_side |
| STD-MEM-003 | T3.B5 | 부분 | 휴대전화 본인인증(SMS/PASS) | merged-owner_side |
| STD-MEM-005 | T3.B5 | 부분 | 1인 1계정 중복가입 제한 | merged-owner_side |
| STD-MEM-007 | T3.B5 | 부분 | 아이디/비밀번호 로그인 | merged-owner_side |
| STD-MEM-008 | T3.B5 | 미착수 | 아이디 찾기(마스킹) | merged-owner_side |
| STD-MEM-009 | T3.B5 | 미착수 | 비밀번호 재설정(이메일 링크) | merged-owner_side |
| STD-MEM-010 | T3.B5 | 부분 | 카카오 소셜 로그인 | merged-owner_side |
| STD-MEM-011 | T3.B5 | 부분 | 네이버 소셜 로그인 | merged-owner_side |
| STD-MEM-012 | T3.B5 | 부분 | 구글/애플 소셜 로그인 | merged-owner_side |
| STD-MEM-013 | T3.B5 | 부분 | 로그인 세션 유지·자동 갱신 | merged-owner_side |
| STD-MEM-015 | T3.B5 | 부분 | 회원정보 수정(비밀번호 재확인) | merged-owner_side |
| STD-MEM-016 | T3.B5 | 부분 | 비밀번호 변경 | merged-owner_side |
| STD-MEM-017 | T3.B5 | 부분 | 회원탈퇴 | merged-owner_side |
| STD-MEM-024 | T3.B5 | 미착수 | 소셜 최초 로그인 가입완료(WAITING→ACTIVE) 추가정보 화면 실검증 — 약관 타입·필수항목이 몰 설정과 맞는지 | merged-owner_side |
| STD-ORD-011 | T3.B6 | 부분 | 쿠폰·배송지 반영 최종 금액 계산 | merged-owner_side |
| STD-ORD-014 | T3.B6 | 미착수 | 배송 요청사항 입력 | merged-owner_side |
| STD-ORD-016 | T3.B6 | 부분 | 주문 제목/작업명 입력 | merged-owner_side |
| STD-ORD-018 | T3.B6 | 부분 | 약관 동의(구매·개인정보 제3자) | merged-owner_side |
| STD-ORD-029 | T3.B6 | 미착수 | 결제 직전 재견적(최종 금액을 다시 확정하고 결제로 넘김) | merged-owner_side |
| STD-ORD-032 | T3.B6 | 부분 | 비회원 주문서 무통장 계좌·입금자명 표시(회원 주문서와 동일 여부) | merged-owner_side |
| STD-PAY-008 | T3.B6 | 미착수 | 복합결제(적립금+PG 병용) | merged-owner_side |
| STD-PAY-011 | T3.B6 | 부분 | PG 리다이렉트·결제 확정 콜백 | merged-owner_side |
| STD-PAY-012 | T3.B6 | 미착수 | 결제 실패 안내·재시도 | merged-owner_side |
| STD-PAY-014 | T3.B6 | 미착수 | 결제 포기 처리 | merged-owner_side |
| STD-PAY-020 | T3.B6 | 미착수 | 카드 결제 화면 분기(비회원·회원 주문서) | merged-owner_side |
| STD-ORD-019 | T3.B7 | 부분 | 주문 예약(reserve) 및 금액 검증 | merged-owner_side |
| STD-ORD-021 | T3.B7 | 부분 | 주문 상태 조회(회원) | merged-owner_side |
| STD-ORD-023 | T3.B7 | 부분 | 주문 상태 머신 전이 표시(결제완료→상품준비→배송준비→배송중→배송완료→구매확정) | merged-owner_side |
| STD-ORD-024 | T3.B7 | 미착수 | 인쇄 공정 단계 상태 노출(검판·출력·후가공) | merged-owner_side |
| STD-ORD-026 | T3.B7 | 미착수 | 재주문(동일 사양 반복) | merged-owner_side |
| STD-ORD-030 | T3.B7 | 미착수 | 주문 생성 직후 후니 주문등록 S2S 호출(order/register) | merged-owner_side |
| STD-ADC-002 | T3.D2 | 미착수 | 회원등급 수동 조정 | rule-step |
| STD-ADC-005 | T3.D2 | 미착수 | 쿠폰 생성·발행 관리 | rule-step |
| STD-MYP-001 | T3.D2 | 부분 | 주문 목록 조회 | merged-owner_side |
| STD-MYP-002 | T3.D2 | 부분 | 주문 상세 조회(사양·파일·상태) | merged-owner_side |
| STD-MYP-010 | T3.D2 | 부분 | 보유 쿠폰 목록 | merged-owner_side |
| STD-MYP-011 | T3.D2 | 부분 | 쿠폰 번호 등록 | merged-owner_side |
| STD-MYP-012 | T3.D2 | 부분 | 내 리뷰 작성·조회 | merged-owner_side |
| STD-MYP-013 | T3.D2 | 미착수 | 내 상품Q&A/1:1문의 조회 | merged-owner_side |
| STD-MYP-016 | T3.D2 | 부분 | 배송지 주소록 관리 | merged-owner_side |
| STD-MYP-017 | T3.D2 | 부분 | 마이페이지 메인 대시보드(주문요약·프린팅머니·쿠폰 한눈에) | merged-owner_side |
| STD-MYP-018 | T3.D2 | 부분 | 마이페이지 서브메인(기능군 랜딩) 화면 | merged-owner_side |
| STD-PRM-007 | T3.D2 | 부분 | 장바구니/주문서 쿠폰 적용 | merged-owner_side |
| T3-4 | T3.D2 | 부분 | 마이페이지 배송지 결함·비로그인 노출·홈/목록 더미 정리 | rule-step |
| STD-CLM-001 | T3.D3 | 미착수 | 주문 전체 취소 신청 | merged-owner_side |
| STD-CLM-002 | T3.D3 | 미착수 | 옵션 부분 취소 신청 | merged-owner_side |
| STD-CLM-003 | T3.D3 | 미착수 | 비회원 취소 신청 | merged-owner_side |
| STD-CLM-005 | T3.D3 | 미착수 | 반품 신청(단일·복수) | merged-owner_side |
| STD-CLM-006 | T3.D3 | 미착수 | 교환 신청(출고 전/후) | merged-owner_side |
| STD-CLM-007 | T3.D3 | 미착수 | 환불 예상금액 계산 | merged-owner_side |
| STD-CLM-008 | T3.D3 | 미착수 | 환불계좌 등록·수정 | merged-owner_side |
| STD-CLM-009 | T3.D3 | 미착수 | 클레임 철회 | merged-owner_side |
| STD-CLM-010 | T3.D3 | 미착수 | 클레임 사유 분류 선택(12종) | merged-owner_side |
| STD-CLM-012 | T3.D3 | 미착수 | 클레임 목록·상세 조회 | merged-owner_side |
| STD-CLM-014 | T3.D3 | 미착수 | 인쇄 불량 접수(사진 첨부) | merged-owner_side |
| STD-CLM-016 | T3.D3 | 미착수 | 1:1 문의 등록·답변 | merged-owner_side |
| STD-CLM-017 | T3.D3 | 미착수 | 상품 Q&A 등록·답변 | merged-owner_side |
| STD-CLM-019 | T3.D3 | 미착수 | 기업인쇄 상담 접수 | merged-owner_side |
| STD-CLM-020 | T3.D3 | 미착수 | 디자인 상담 접수 | merged-owner_side |
| T4-1 | T4.C1 | 부분 | 주문 등록 다리 — 스킨이 결제 직후 order/register 를 부르게 배선(부르는 쪽 0건) | rule-step |
| STD-SYS-014 | T4.C3 | 부분 | 택배사 배송추적 연동 | merged-owner_side |
| STD-SYS-015 | T4.C3 | 미착수 | 웹 로그/전환 분석 도구 연동 | merged-owner_side |
| STD-SYS-023 | T4.C3 | 미착수 | 담기 전달값의 민감정보 비노출·서명 검증(계약 준수) | merged-owner_side |
| STD-SYS-049 | T4.C3 | 미착수 | Railway `vc_v_product_detail_tabs` 직접 SELECT — pg.Pool 타임아웃 없음·DDL 소유자 | merged-owner_side |
| STD-SHP-014 | T4.C7 | 부분 | 고객 배송 조회(택배사 추적) | merged-owner_side |
| STD-SHP-015 | T4.C7 | 부분 | 배송지 변경/추가 | merged-owner_side |
| STD-MYP-014 | T5.D4 | 미착수 | 증빙서류 발급내역 조회 | merged-owner_side |
| STD-MYP-015 | T5.D4 | 미착수 | 현금영수증 정보 관리 | merged-owner_side |
| STD-MYP-020 | T5.D4 | 미착수 | 사업자정보 목록 | merged-owner_side |
| STD-MYP-021 | T5.D4 | 미착수 | 사업자정보 등록(쓰기) | merged-owner_side |
| STD-MYP-034 | T5.D4 | 미착수 | 증빙 신청 탭 3개(신청 가능 / 신청 완료 / 신용카드 결제) | merged-owner_side |
| STD-MYP-035 | T5.D4 | 미착수 | 현금 결제 건만 신청 대상 — 세금계산서·현금영수증 중 택1 | merged-owner_side |
| STD-MYP-036 | T5.D4 | 미착수 | 카드 결제 건·발행 완료 건은 목록에 보이되 비활성+사유 표시 | merged-owner_side |
| STD-MYP-037 | T5.D4 | 미착수 | 프린트머니 증빙 발행 규칙 — 충전 시 충전액·주문 시 실결제액·환불 시 마이너스 계산서 | rule-step |
| STD-PAY-016 | T5.D4 | 미착수 | 세금계산서 발급 신청·내역 | merged-owner_side |
| STD-SYS-001 | T5.E1 | 부분 | 관리자 계정 등록·관리 | evidence-path |
| STD-SYS-002 | T5.E1 | 부분 | 역할 기반 세분 권한 제어 | evidence-path |
| STD-SYS-053 | T5.E1 | 미착수 | Prisma 로컬 DB(23테이블·DATABASE_URL) 존폐 — 코드 소비자 0(src/lib/prisma.ts 만) | evidence-path |
| STD-MYP-006 | T6.D5 | 부분 | 프린팅머니 잔액·내역 조회 | merged-owner_side |
| STD-MYP-007 | T6.D5 | 부분 | 프린팅머니 충전(PG 결제→적립 전환) | merged-owner_side |
| STD-SYS-019 | T7.E4 | 미착수 | 반응형/모바일 대응 | rule-track |
| STD-SYS-020 | T7.E4 | 미착수 | SEO 메타·사이트맵 | evidence-path |
| STD-SYS-021 | T7.E4 | 미착수 | 페이지 빌더(운영자 화면 편집) | merged-owner_side |
| STD-SYS-022 | T7.E4 | 미착수 | 구 사이트 → 신규 사이트 URL 리다이렉트 | rule-track |
| STD-SYS-043 | T7.E4 | 미착수 | [보안 Critical] /api/shopby 서버(파트너) API 범용 프록시가 인증·경로 화이트리스트 없이 파트너 비밀 토 | evidence-path |
| STD-SYS-044 | T7.E4 | 미착수 | 전역 오류 화면(error.tsx·not-found.tsx·global-error.tsx) 부재 — Next 기본 404/50 | evidence-path |
| STD-SYS-046 | T7.E4 | 미착수 | 공지 본문·상품설명 HTML 무필터 렌더(저장형 XSS 여지) — sanitize 적용 | evidence-path |
| STD-SYS-047 | T7.E4 | 미착수 | 보안 응답 헤더/CSP 부재(next.config.ts 에 headers() 없음) | evidence-path |
| STD-SYS-048 | T7.E4 | 미착수 | 회귀 테스트 0개·CI 없음 — 포크의 특성화 테스트(14파일·108케이스)·ci.yml 이식 | evidence-path |
| STD-SYS-051 | T7.E4 | 미착수 | 미병합 로컬 브랜치·워크트리 7개 정리(WT-* 6 + release/0.2.0) — 유효 변경 유무 확인 후 삭제 | evidence-path |
| STD-SYS-054 | T7.E4 | 미착수 | 운영 console.error 24건·요청 ID 없는 진단 로그 → 구조화 로그·요청 ID 이식 | evidence-path |

### ② 다른 담당으로(제안) — 45행

| row_id | 트랙.단계 | status | 일 | 제안 담당 | 근거등급 | 근거 |
|---|---|---|---|---|---|---|
| STD-CAT-033 | T2.A1 | 미착수 | 디자인 상품 화면 구조 — 카테고리 → 디자인 목록 → 상세 페이지 | 서희항 | merged-owner_side | 여러 시스템에 걸치나 담당은 한 사람(webadmin,widget) |
| STD-CAT-041 | T2.A1 | 미착수 | 판매중 상품 수 3갈래(대시보드 291·상품목록 판매중 297/검색 291·API ONSALE 226) 기준 정리 | 최숙진 | evidence-path | 셀러어드민 설정·운영(코드 0) |
| STD-ART-019 | T2.B3 | 미착수 | 업로드 파일 썸네일·PDF 미리보기 | 서희항 | rule-step | 사는 시스템 미확인 — 단계 B3 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-ART-020 | T2.B3 | 미착수 | 재단선 오버레이 미리보기 | 서희항 | rule-step | 사는 시스템 미확인 — 단계 B3 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-MEM-020 | T3.B5 | 미착수 | 기존 회원 데이터 이관(구 사이트) | 서희항 | merged-owner_side | 그 일이 사는 곳=webadmin |
| STD-ORD-027 | T3.B7 | 부분 | 오프라인 주문 별도 등록 경로 | 서희항 | evidence-path | 그 일이 사는 곳=webadmin |
| STD-ADC-004 | T3.D2 | 미착수 | 프린팅머니 수동 지급·차감 | 서희항 | merged-owner_side | 그 일이 사는 곳=webadmin |
| STD-PRM-002 | T3.D2 | 미착수 | 리뷰 작성 보상 쿠폰 발행 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-PRM-003 | T3.D2 | 미착수 | 재구매 쿠폰 발행 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-PRM-005 | T3.D2 | 부분 | 쿠폰 동시사용 개수 제한 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-PRM-008 | T3.D2 | 미착수 | 리뷰 삭제 시 보상 회수 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-ADO-023 | T3.D3 | 부분 | 환불 실행·정산 반영 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-CLM-011 | T3.D3 | 미착수 | 귀책 구분(구매자/판매자/단순변심) | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-CLM-013 | T3.D3 | 미착수 | 판매자 클레임 승인·거부 처리 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-SYS-008 | T4.C3 | 부분 | 인쇄 도메인 DB ↔ 커머스 상품 동기화 | 서희항 | manual-read | [범위 한정] shopby_sync.py 가 실제로 미는 축은 **메인이미지(:118)와 전시 frontDisplayYn(:315) 둘뿐**이고, 공통 API 클 |
| STD-SYS-010 | T4.C3 | 구현-미검증 | 원고 저장소(스토리지) 연동 | 서희항 | evidence-path | 그 일이 사는 곳=webadmin |
| STD-SYS-039 | T4.C3 | 미착수 | 웹훅 등록 화면 위치 확인(셀러어드민 내 미발견) 및 등록 여부 | 최숙진 | evidence-path | 셀러어드민 설정·운영(코드 0) |
| STD-ADO-002 | T4.C5 | 부분 | 주문 상세 조회(사양·파일·금액) | 서희항 | manual-read | TOrdOrders(t_ord_orders)·TOrdArtworks 가 webadmin 모델. 주문 상세의 사양·파일·금액 그릇이 webadmin 에 있다 |
| STD-ADO-003 | T4.C5 | 부분 | 주문 상태 변경(단건) | 서희항 | manual-read | ord_sts(주문상태) 컬럼이 webadmin t_ord_orders. 단건 상태변경 화면은 webadmin 제네릭 admin |
| STD-ADO-005 | T4.C5 | 미착수 | 상태 변경 시 고객 알림 자동발송 | 서희항·최숙진 | rule-step | 사는 시스템 미확인 — 단계 C5 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-ADO-006 | T4.C5 | 미착수 | 주문서(작업지시서) 출력 | 최숙진 | merged-owner_side | MES 현행 기능·생산 현장 운영 — 신규 개발이면 외부(MES 담당) |
| STD-MFG-114 | T4.C6 | 미착수 | 한 주문에 다중 송장 부여 | 서희항 | merged-owner_side | 그 일이 사는 곳=webadmin |
| STD-SHP-012 | T4.C7 | 부분 | 송장번호 등록(판매자) | 서희항 | merged-owner_side | 그 일이 사는 곳=webadmin |
| STD-SHP-013 | T4.C7 | 부분 | 송장 기반 배송상태 일괄변경 | 서희항 | merged-owner_side | 그 일이 사는 곳=webadmin |
| STD-PRM-012 | T5.D1 | 미착수 | 알림톡/SMS 마케팅 발송 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-PRM-013 | T5.D1 | 미착수 | 이메일 뉴스레터 발송 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-ADO-024 | T5.D4 | 미착수 | 증빙서류 발급 관리 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-B2B-001 | T5.E1 | 부분 | 거래처(기업회원) 등록·관리 | 서희항 | evidence-path | 그 일이 사는 곳=webadmin |
| STD-B2B-002 | T5.E1 | 미착수 | 거래처별 단가/할인율 설정 | 최숙진 | rule-step | 사는 시스템 미확인 — 단계 E1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-B2B-003 | T5.E1 | 미착수 | 거래처 소속 담당자 다계정 | 최숙진 | rule-step | 사는 시스템 미확인 — 단계 E1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-B2B-006 | T5.E1 | 미착수 | 월 마감 청구서 발행 | 최숙진 | rule-step | 사는 시스템 미확인 — 단계 E1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-B2B-007 | T5.E1 | 미착수 | 업체별 미수금 관리 | 최숙진 | rule-step | 사는 시스템 미확인 — 단계 E1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-B2B-010 | T5.E1 | 미착수 | 대량 견적 요청 접수·회신 | 최숙진 | rule-step | 사는 시스템 미확인 — 단계 E1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-B2B-011 | T5.E1 | 미착수 | 견적서 발행(사업자 양식) | 최숙진 | rule-step | 사는 시스템 미확인 — 단계 E1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-FIN-008 | T5.E1 | 미착수 | PG 정산 대사 | 최숙진 | rule-step | 사는 시스템 미확인 — 단계 E1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-FIN-009 | T5.E1 | 미착수 | 적립금(프린팅머니) 부채 집계 | 최숙진 | rule-step | 사는 시스템 미확인 — 단계 E1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-FIN-010 | T5.E1 | 미착수 | 외주 발주/정산 엑셀 산출 | 최숙진 | rule-step | 사는 시스템 미확인 — 단계 E1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-FIN-012 | T5.E1 | 미착수 | 통계·주문 데이터 엑셀 내보내기 | 최숙진 | rule-step | 사는 시스템 미확인 — 단계 E1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-SHP-017 | T5.E1 | 부분 | 금지 설정 4종 확인(A-14/U-1): 수량비례·중량 배송비 / 최대구매수량 / 즉시할인 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-SYS-004 | T5.E1 | 부분 | PG 연동 설정 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-SYS-005 | T5.E1 | 부분 | 배송비 정책 설정 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-SYS-006 | T5.E1 | 미착수 | 알림(SMS/알림톡/이메일) 템플릿 설정 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-MYP-009 | T6.D5 | 미착수 | 기존 프린트머니 잔액 이관 | 서희항 | merged-owner_side | 그 일이 사는 곳=webadmin |
| STD-SYS-016 | T7.E4 | 부분 | 주문/결제 실패 모니터링·알림 | 서희항 | evidence-path | 그 일이 사는 곳=webadmin |
| STD-SYS-017 | T7.E4 | 미착수 | 데이터 백업·복구 절차 | 서희항 | rule-track | 데이터 백업·복구 절차 = 관리서버·DB 영역(T1 인프라와 같은 손). PM 은 만들지 않는다 |

### ③ 행을 나눠야 함 — 17행

| row_id | 트랙.단계 | status | 일 | 제안 담당 | 근거등급 | 근거 |
|---|---|---|---|---|---|---|
| STD-CAT-043 | T2.A4 | 미착수 | 목록·검색 시작가를 webadmin `GET /api/w/v1/catalog`(게시 위젯+시작가) 로 이관 — 「10원~」 더 | 김동학+서희항 | merged-owner_side | 두 시스템에 걸침(huni-mall,webadmin) — 행을 나눠 각자에게 |
| STD-ADC-014 | T3.A5 | 구현-미검증 | 인쇄 가이드 콘텐츠 관리 | 서희항+최숙진 | merged-owner_side | 인쇄 가이드 콘텐츠 관리 — 관리 화면·도구=서희항 / 표시명·태그·비고 채우기=최숙진(역할①). [직접 확인 260919] raw/webadmin/webadmi |
| STD-CAT-007 | T3.A5 | 부분 | 상품 상세페이지 본문(이미지·설명 블록) | 김동학+최숙진 | merged-owner_side | 상품 상세페이지 본문 — 이미지·설명 블록 화면=김동학 / 본문 콘텐츠=최숙진(역할②) |
| STD-CAT-009 | T3.A5 | 미착수 | 후가공 용어 설명 툴팁(도무송·오시·형압·귀돌이) | 김동학+최숙진 | merged-owner_side | 후가공 용어 툴팁 — 툴팁 구현=김동학 / 용어 설명 문구=최숙진(역할②) |
| STD-CAT-011 | T3.A5 | 미착수 | 상품별 제작 소요일/출고 기준 안내 | 김동학+서희항 | merged-owner_side | 두 시스템에 걸침(huni-mall,webadmin) — 행을 나눠 각자에게 |
| STD-CAT-012 | T3.A5 | 부분 | 재작업 불가 사항 고지(폰트 아웃라인 등) | 김동학+최숙진 | merged-owner_side | 재작업 불가 고지 — guide-data.ts 스텁 채우기=김동학 / 고지 문구=최숙진(역할①) |
| STD-CAT-034 | T3.A5 | 부분 | 상세페이지 탭 6종 자동 등록(디자인가이드·디자인보기 포함) | 김동학+서희항+최숙진 | merged-owner_side | 상세페이지 탭 6종 자동 등록 — 자동등록 도구=서희항(webadmin)·표시=김동학(스킨·페이지빌더) / 탭 콘텐츠=최숙진(역할②) |
| T3-2 | T3.B5 | 부분 | 로그인 성공인데 오류 문구·리다이렉트 없음 수정(D-2) + 회원 이관 경로 확정 | 김동학+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| STD-PAY-013 | T3.B6 | 부분 | 결제 금액 위변조 검증(서버 재계산 대조) | 김동학+서희항 | manual-read | 위변조 검증은 스킨이 부르고 위젯 /handoff/verify 가 판정한다 — 호출측·판정측이 다른 사람 |
| STD-PAY-031 | T3.B6 | 미착수 | 위젯 총액↔shopby 청구액 「10원×수량」 모델 정합 검증(표시↔청구 불일치 알려진 이슈) | 김동학+서희항 | manual-read | amountToOrderCnt(10원×수량)는 스킨 코드. 그러나 총액 권위는 위젯 handoff/requote(서희항). 표시↔청구 정합은 두 쪽 합의 행 |
| T3-3 | T3.B6 | 부분 | 주문서·결제 — 결제수단 범위 결정 후 스킨 결제 분기·주문 성립 1건 종단 | 김동학+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| STD-MYP-003 | T3.D2 | 미착수 | 편집상품 미리보기 | 서희항+김동학 | manual-read | 스킨 버튼은 onClick 없는 데드 버튼(=김동학 몫). 미리보기 산출물 자체는 Edicus/위젯(=서희항) |
| STD-MYP-030 | T3.D2 | 부분 | 편집 디자인 보관함 — 편집 종료 후 보관, 장바구니 담기 전까지 수정 가능 | 김동학+서희항 | merged-owner_side | 두 시스템에 걸침(huni-mall,widget) — 행을 나눠 각자에게 |
| STD-SYS-041 | T4.C3 | 미착수 | 상품 텍스트옵션 라벨 huni_token 미등록 확정(U-2) → 스킨 담기 구현 정합 | 김동학+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| STD-SYS-045 | T4.C3 | 미착수 | 후니 위젯 서버키 헤더(X-Huni-Server-Key) 전송 배선 — 제공자가 WAPI_SERVER_KEY_REQUIRED  | 김동학+서희항 | merged-owner_side | 두 시스템에 걸침(huni-mall,webadmin,widget) — 행을 나눠 각자에게 |
| T5-3 | T5.E3 | 부분 | 법정 표기 단일화(사업자번호 206-29-88022 우세)·증빙 화면 목업 제거(D-5) | 김동학+최숙진 | rule-track | 법정 표기 단일화(표기 내용=최숙진) + 증빙 화면 목업 제거(스킨 구현=김동학). PM 은 만들지 않는다 |
| STD-B2B-005 | T6.D5 | 미착수 | 후불 주문 승인·미결제 관리 | 김동학+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |

### ④ 제공/불필요 — 개발 일 아님(확인만) — 23행

| row_id | 트랙.단계 | status | 일 | 제안 담당 | 근거등급 | 근거 |
|---|---|---|---|---|---|---|
| STD-ADC-007 | T3.A5 | 작동 | 공지사항 관리 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-ADC-008 | T3.A5 | 작동 | FAQ 관리 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-ADC-009 | T3.A5 | 작동 | 상품Q&A 답변 관리 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-ADC-010 | T3.A5 | 작동 | 1:1 문의 답변 관리 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-ADC-011 | T3.A5 | 작동 | 이용후기(리뷰) 관리·블라인드 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-ADC-001 | T3.D2 | 작동 | 회원 목록·검색·상세 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-ADC-003 | T3.D2 | 작동 | 탈퇴회원 관리 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-ADC-006 | T3.D2 | 작동 | 쿠폰 등록·사용 내역 조회 | 최숙진 | merged-owner_side | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-PRM-009 | T3.D2 | 작동 | 사진 리뷰 추가 보상 | 최숙진 | merged-owner_side | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-ADO-022 | T3.D3 | 작동 | 클레임 접수 목록·처리 | 최숙진 | merged-owner_side | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-ADO-001 | T4.C5 | 작동 | 주문 목록·검색·필터 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-ADO-004 | T4.C5 | 작동 | 주문 상태 일괄 변경 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-ADO-007 | T4.C5 | 작동 | 고객 SMS/알림톡 수동 발송 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-SHP-008 | T4.C6 | 작동 | 택배 배송 | 최숙진 | merged-owner_side | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-SHP-016 | T5.D1 | 미착수 | 배송 상태 변경 알림 발송 | 최숙진 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 최숙진 |
| STD-FIN-001 | T5.E1 | 작동 | 월별 매출 통계 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-FIN-002 | T5.E1 | 작동 | 일별/기간별 매출 조회 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-FIN-003 | T5.E1 | 작동 | 결제수단별 매출 집계 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-FIN-004 | T5.E1 | 작동 | 상품별 판매 통계 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-FIN-005 | T5.E1 | 작동 | 상품군별 매출 비중 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-FIN-006 | T5.E1 | 작동 | 회원/비회원 주문 비중 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-FIN-011 | T5.E1 | 작동 | 쿠폰/할인 사용액 집계 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-SYS-003 | T5.E1 | 작동 | 관리자 작업 감사로그 | 최숙진 | evidence-path | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |

### ⑤ 미정 — 3행

| row_id | 트랙.단계 | status | 일 | 제안 담당 | 근거등급 | 근거 |
|---|---|---|---|---|---|---|
| STD-B2B-004 | T6.D5 | 미착수 | 후불 여신한도 설정 | 김동학 | rule-track | 사는 시스템도 단계 기본 담당도 못 짚음(D5 프린트머니 등) — 실측·결정 필요 |
| STD-B2B-008 | T6.D5 | 미착수 | 거래처 원장(온·오프라인 통합) | 김동학 | rule-track | 사는 시스템도 단계 기본 담당도 못 짚음(D5 프린트머니 등) — 실측·결정 필요 |
| STD-B2B-009 | T6.D5 | 미착수 | 원장 데이터 파일 생성(.txt 연계) | 김동학 | rule-track | 사는 시스템도 단계 기본 담당도 못 짚음(D5 프린트머니 등) — 실측·결정 필요 |

### 넘어올 제안 — 43행

| row_id | 트랙.단계 | status | 일 | 현재 담당 | 판정 | 근거등급 |
|---|---|---|---|---|---|---|
| BLK-S4-6 | T1.F4 | 미착수 | [선행 입력] Vercel 프로젝트 접근 · 현재 `DATABASE_URL`·`NEXTAUTH_URL` 소재 | 김동학·PM | 분할 | rule-track |
| F4-7 | T1.F4 | 미착수 | vercel.app 리다이렉트: 코드에 없음(§1 마지막 행). Vercel 대시보드 리다이렉트·도메인 설정 | 신우진 | 재배정 | merged-owner_side |
| F4-8 | T1.F4 | 미착수 | Vercel 프로젝트 정지(오픈 테스트 통과 후) | 신우진 | 재배정 | merged-owner_side |
| STD-CAT-026 | T2.A1 | 미착수 | 수작 상품 메인·상품페이지 경로 | 신우진 | 재배정 | evidence-path |
| STD-CAT-028 | T2.A2 | 미착수 | 목록·검색 시작가 「10원~」 표시(샵바이 salePrice 더미) | 최숙진 | 재배정 | evidence-path |
| STD-OPT-055 | T2.B2 | 미착수 | 대량주문 견적 문의 접수 | 최숙진 | 재배정 | evidence-path |
| STD-OPT-056 | T2.B2 | 구현-미검증 | 캘린더 가공·장수(월수) 선택 | 서희항 | 재배정 | evidence-path |
| STD-ART-029 | T2.B3 | 미착수 | 가변데이터 인쇄(VDP) 데이터 업로드·병합 | 서희항 | 재배정 | evidence-path |
| STD-CAT-019 | T3.A5 | 부분 | 인쇄 가이드 콘텐츠(11종) | 최숙진 | 분할 | merged-owner_side |
| STD-INF-005 | T3.A5 | 부분 | 공지사항 고객 화면(목록·상세) | 최숙진 | 분할 | merged-owner_side |
| STD-INF-007 | T3.A5 | 부분 | 가이드북 고객 화면(작업 유의사항 11종) | 최숙진 | 분할 | merged-owner_side |
| STD-INF-012 | T3.A5 | 미착수 | 뉴스·소식 공간 신설(갤러리형/게시판형/커뮤니티형 중 택1 + 메뉴명) | 채훈희 | 재배정 | merged-owner_side |
| STD-OPT-057 | T3.A5 | 미착수 | 규격 가이드 모달(사이즈 안내 팝업) | 서희항 | 분할 | merged-owner_side |
| STD-OPT-058 | T3.A5 | 미착수 | 주문가능 자재(용지) 목록 모달 | 서희항 | 분할 | merged-owner_side |
| STD-MEM-022 | T3.B5 | 미착수 | 로그인 식별자 정책(이메일 전용 vs 아이디) 확정·테스트회원 계정 정비 | 신우진 | 재배정 | evidence-path |
| STD-ORD-015 | T3.B6 | 미착수 | 나중배송(배송지 미입력) 주문 | 신우진 | 재배정 | merged-owner_side |
| STD-ORD-017 | T3.B6 | 미착수 | 출고 옵션 선택(오늘출고·토요일출고) | 신우진 | 재배정 | merged-owner_side |
| STD-PAY-001 | T3.B6 | 미착수 | 신용카드 결제(PG) | 신우진 | 재배정 | merged-owner_side |
| STD-PAY-002 | T3.B6 | 미착수 | 실시간 계좌이체 | 최숙진 | 재배정 | merged-owner_side |
| STD-PAY-007 | T3.B6 | 부분 | 적립금(프린팅머니) 결제 | 서희항 | 재배정 | merged-owner_side |
| STD-PAY-010 | T3.B6 | 미착수 | B2B 후불결제 | 신우진 | 재배정 | merged-owner_side |
| STD-PAY-025 | T3.B6 | 미착수 | 샵바이 어드민의 카카오페이 신청 경로 확인 | 최숙진 | 재배정 | rule-step |
| STD-ORD-025 | T3.B7 | 미착수 | 구매확정(고객·자동) | 최숙진 | 재배정 | merged-owner_side |
| STD-MYP-004 | T3.D2 | 미착수 | 옵션보관함 저장/불러오기 | 신우진 | 재배정 | merged-owner_side |
| STD-MYP-005 | T3.D2 | 미착수 | 보관 기간 정책 적용·만료 처리 | 신우진 | 재배정 | merged-owner_side |
| STD-MYP-019 | T3.D2 | 미착수 | 마이페이지 통합 검색결과 LIST 화면 | 신우진 | 재배정 | merged-owner_side |
| STD-MYP-032 | T3.D2 | 미착수 | 편집 후 장바구니를 누르지 않고 이탈한 고객 안내 방법 | 최숙진 | 재배정 | rule-step |
| STD-PRM-011 | T3.D2 | 미착수 | 체험단 모집·신청·당첨·후기 | 신우진 | 재배정 | merged-owner_side |
| STD-PRM-016 | T3.D2 | 미착수 | 이용후기 메인(전체 리뷰 모아보기) | 신우진 | 재배정 | merged-owner_side |
| STD-PRM-017 | T3.D2 | 미실측 | [구IA#71] 체험단관리 (등록/수정/신청내역) | 신우진 | 재배정 | rule-step |
| STD-CLM-004 | T3.D3 | 미착수 | 제작 착수 후 취소 제한·협의 안내 | 최숙진 | 재배정 | merged-owner_side |
| STD-CLM-018 | T3.D3 | 부분 | 공지사항·FAQ 열람 | 신우진 | 재배정 | merged-owner_side |
| STD-CLM-021 | T3.D3 | 미착수 | 디자인 의뢰하기(주문 흐름 내) | 신우진 | 재배정 | merged-owner_side |
| T3-5 | T3.D3 | 없음 | 취소·반품·문의 — 범위 결정 후 스킨 버튼·문의 라우트 구현 | 신우진 | 분할 | rule-track |
| STD-ART-027 | T4.C2 | 미착수 | 과거 주문 파일 재사용 재주문 | 신우진 | 분할 | rule-track |
| STD-SYS-012 | T4.C3 | 부분 | 본인인증 서비스 연동 | 신우진 | 재배정 | merged-owner_side |
| STD-PAY-015 | T5.D4 | 미착수 | 현금영수증 발급 | 최숙진 | 재배정 | merged-owner_side |
| STD-PAY-017 | T5.D4 | 부분 | 사업자정보 등록·관리 | 최숙진 | 재배정 | merged-owner_side |
| STD-PAY-018 | T5.D4 | 부분 | 거래명세서 출력 | 최숙진 | 재배정 | merged-owner_side |
| STD-INF-001 | T5.E3 | 부분 | 회사소개 페이지 | 신우진 | 재배정 | merged-owner_side |
| STD-INF-008 | T5.E3 | 미착수 | 푸터 SNS 4종·입점제휴문의·카톡상담 링크가 '#' | 최숙진 | 재배정 | merged-owner_side |
| STD-MYP-054 | T6.D5 | 미착수 | 마이포인트(/mypage/point·shopby 적립금)와 프린팅머니(/mypage/money·UI 전용)  | 신우진 | 재배정 | evidence-path |
| STD-SYS-050 | T7.E4 | 미착수 | huni-skin-next 포크(SPEC-TAKEOVER-001 M0~M7·20커밋·remote 없음) 처리 | 신우진 | 분할 | evidence-path |


## 최숙진

### 한 장 요약

| 항목 | 행수 |
|---|---|
| 현재 걸린 행(원장 전체) | 153 |
| 그중 남은 일(status≠작동) | 150 |
| ① 담당 맞음 — 그대로 한다 | 104 |
| ② 다른 담당으로 넘길 제안 | 31 |
| ③ 행을 나눠야 함(경계 걸침) | 10 |
| ④ 샵바이·MES 제공이라 개발 일 아님 / 불필요 | 6 |
| ⑤ 미정(실측·결정 전이라 배정 불가) | 2 |
| **다른 사람에게서 넘어올 제안** | **65** |

재판정 뒤 이 사람이 실제로 질 남은 일(제안 기준) = 104 + 넘어옴 65 = **169행** (+ 나눠야 하는 10행의 자기 몫)

### 트랙별

| 트랙 | 남은 일 | 담당맞음 | 재배정 | 분할 | 제공/불필요 | 미정 |
|---|---|---|---|---|---|---|
| T1 인프라 이전(Lightsail) | 4 | 1 | 2 | 1 | 0 | 0 |
| T2 상품·가격·위젯 준비 | 20 | 5 | 14 | 1 | 0 | 0 |
| T3 쇼핑몰 주문·결제·회원 | 30 | 18 | 6 | 4 | 2 | 0 |
| T4 주문 수신·원고·생산 연동 | 70 | 64 | 4 | 2 | 0 | 0 |
| T5 운영 설정·알림·CS·증빙 | 23 | 16 | 5 | 2 | 0 | 0 |
| T6 프린팅머니 | 3 | 0 | 0 | 0 | 1 | 2 |

### ① 담당 맞음 — 그대로 한다 — 104행

| row_id | 트랙.단계 | status | 일 | 근거등급 |
|---|---|---|---|---|
| STD-SYS-040 | T1.E2 | 미착수 | 발송전용 e-mail 도메인(gmail) 정리·자동 메일 도메인 인증 | merged-owner_side |
| STD-CAT-032 | T2.A1 | 부분 | 포토앨범 1차 오픈 제외 — 전달·문의 멘트 통일 | rule-step |
| STD-CAT-037 | T2.A1 | 미착수 | 디자인 그룹핑 기준(태그·그룹·복수 그룹 등록·노출 순서) | rule-step |
| T2-1 | T2.A1 | 부분 | 상품·가격 데이터 충전 — 기본사양가 없음 2건·0원 조합 교정 | rule-step |
| STD-OPT-045 | T2.A2 | 부분 | 가격 0원/계산불가 상태 처리 및 사용자 안내 | rule-step |
| STD-CAT-030 | T2.A4 | 미착수 | 상품 0개 중분류(스티커 팩 0 등) 노출 정리 | merged-owner_side |
| STD-INF-009 | T3.A5 | 미실측 | [구IA#64] 공지사항 관리 (등록/수정/html생성) | merged-owner_side |
| STD-INF-010 | T3.A5 | 미실측 | [구IA#65] 자주묻는질문 관리 | merged-owner_side |
| STD-INF-011 | T3.A5 | 미실측 | [구IA#72] 이용후기관리 (관리자등록/수정) | merged-owner_side |
| STD-MEM-006 | T3.B5 | 미착수 | 가입완료 혜택 자동지급(쿠폰+적립금) | merged-owner_side |
| STD-MEM-019 | T3.B5 | 미착수 | 휴면계정 전환·복구 | merged-owner_side |
| STD-MEM-023 | T3.B5 | 미착수 | 소셜 로그인 전제 설정 — 셀러어드민 간편로그인 앱(네이버·카카오·구글) 등록 + 각 개발자센터 Redirect URI `{o | merged-owner_side |
| STD-PAY-027 | T3.B6 | 미착수 | 결제수단 노출설정 10항목 켜기(PG 승인 후) | merged-owner_side |
| STD-ADC-017 | T3.D2 | 미실측 | [구IA#73] 회원관리 (주문내역/정보확인) | merged-owner_side |
| STD-PRM-001 | T3.D2 | 미착수 | 신규회원 쿠폰 자동발행 | merged-owner_side |
| STD-PRM-004 | T3.D2 | 미착수 | 회원등급(VIP) 쿠폰 발행 | merged-owner_side |
| STD-PRM-006 | T3.D2 | 미착수 | 쿠폰 유효기간 관리 | merged-owner_side |
| STD-PRM-018 | T3.D2 | 미실측 | [구IA#76] 쿠폰관리 (발행/매칭/사용내역) | merged-owner_side |
| STD-PRM-019 | T3.D2 | 미실측 | [구IA#77] 쿠폰등록내역 | merged-owner_side |
| STD-PRM-020 | T3.D2 | 미실측 | [구IA#78] 쿠폰사용내역 | merged-owner_side |
| STD-CLM-022 | T3.D3 | 미실측 | [구IA#67] 기업인쇄상담 (확인/답변) | merged-owner_side |
| STD-CLM-023 | T3.D3 | 미실측 | [구IA#68] 디자인상담 (확인/답변) | merged-owner_side |
| STD-CLM-024 | T3.D3 | 미실측 | [구IA#69] 상품Q&A (확인/답변) | merged-owner_side |
| STD-CLM-025 | T3.D3 | 미실측 | [구IA#70] 1:1문의 (확인/답변) | merged-owner_side |
| STD-SYS-029 | T4.C3 | 구현-미검증 | SMS 발신번호 인증 완료 | merged-owner_side |
| STD-SYS-030 | T4.C3 | 미착수 | 테스트용 SMS 충전 완료 여부 확인 | merged-owner_side |
| STD-ADO-010 | T4.C4 | 미착수 | 검수 게이트 관리(G1 파일·G3 가공·G4 출고) | rule-step |
| STD-ADO-011 | T4.C4 | 미착수 | 불량 판정·재작업 지시 | rule-step |
| STD-ART-017 | T4.C4 | 미착수 | 검판 게이트 통과/보류 상태 관리 | rule-step |
| STD-MFG-058 | T4.C4 | 미착수 | 접수파일 등록(원본 그대로 사용 vs 가공 후 등록 2경로) | evidence-path |
| STD-MFG-062 | T4.C4 | 미착수 | AI 접수파일에 썸네일용 JPG 동반 업로드(아크릴스티커·박) | evidence-path |
| STD-MFG-065 | T4.C4 | 미착수 | 출고예정일(완료예정일) 등록 | evidence-path |
| STD-MFG-066 | T4.C4 | 미착수 | 생산메모 입력 | evidence-path |
| STD-MFG-067 | T4.C4 | 미착수 | 작업의뢰서 출력(대표썸네일·EXCEL 다운) | evidence-path |
| STD-MFG-068 | T4.C4 | 미착수 | 의뢰서 출력 시 처리표시(빨간점)·주문상태 제작중 전환 | evidence-path |
| STD-MFG-069 | T4.C4 | 미착수 | 거래처별 주문 EXCEL 다운(가격 제외) | evidence-path |
| STD-MFG-070 | T4.C4 | 미착수 | 업체별 주문등록(EXCEL 등록·파일경로 선택) | evidence-path |
| STD-MFG-071 | T4.C4 | 미착수 | OEM 주문 IMPORT(비즈하우스·후지필름·컨티뉴) | merged-owner_side |
| STD-ADO-013 | T4.C5 | 미착수 | 작업 큐/일정 배정 | rule-step |
| STD-ADO-016 | T4.C5 | 미착수 | 바코드/라벨 출력 | rule-step |
| STD-ADO-017 | T4.C5 | 미착수 | 외주 발주 등록·관리 | rule-step |
| STD-ADO-018 | T4.C5 | 미착수 | 외주 입고 전수검수 기록 | rule-step |
| STD-ADO-019 | T4.C5 | 미착수 | 외주 정산(월 마감) | rule-step |
| STD-ADO-025 | T4.C5 | 미실측 | [구IA#86] 주문관리-인쇄/제본/굿즈 (상세) | rule-step |
| STD-ADO-026 | T4.C5 | 미실측 | [구IA#93] 주문상태변경 (일괄) | rule-step |
| STD-ADO-028 | T4.C5 | 미착수 | 스모크 주문 3건·취소 클레임 1건으로 A-1/A-2/A-4 관측 완료하기 | evidence-path |
| STD-MFG-072 | T4.C5 | 미착수 | 원본 AI→PDF 변환 업로드 | evidence-path |
| STD-MFG-073 | T4.C5 | 미착수 | 인쇄파일과 칼선파일 분리하여 공정별 등록 | evidence-path |
| STD-MFG-074 | T4.C5 | 미착수 | 조판(판걸이+아이마크) 파일 생성 | evidence-path |
| STD-MFG-075 | T4.C5 | 미착수 | 아크릴 원판 배치 조판(396x480·도수 구분·돔보) | evidence-path |
| STD-MFG-076 | T4.C5 | 미착수 | 다도안 상품 판걸이·건수·수량 기준 조판 | evidence-path |
| STD-MFG-077 | T4.C5 | 미착수 | 수동조판(여러 주문 취합·틴거울/아크릴/자석북마크) | evidence-path |
| STD-MFG-080 | T4.C5 | 미착수 | 공정별 파일서버 폴더 구조(년도>발주일자) 자동 배치 | evidence-path |
| STD-MFG-081 | T4.C5 | 미착수 | 팀별 또는 담당자 파일 분리 전달(분배) | evidence-path |
| STD-MFG-087 | T4.C5 | 미착수 | 팀·파트 마스터(디지털인쇄/스티커가공/인쇄후가공/제본/특수인쇄가공/봉재가공/굿즈가공) | evidence-path |
| STD-MFG-088 | T4.C5 | 미착수 | 공정 완료 신호 입력(출력완료·커팅완료·제본시작·봉재시작·가공시작) | merged-owner_side |
| STD-MFG-089 | T4.C5 | 미착수 | 팀 간 출고·입고 처리(봉제미싱입고·아크릴가공입고·제본입고·박작업입고) | merged-owner_side |
| STD-MFG-091 | T4.C5 | 미착수 | 팀별 파일 다운로드 권한(제작중 상태 and 생산다운여부 Y) | evidence-path |
| STD-MFG-092 | T4.C5 | 미착수 | 인쇄타입별 접수파일 포맷 규약(PDF/AI/JPG) | evidence-path |
| STD-MFG-093 | T4.C5 | 미착수 | 파일 다운로드 시 다운로드완료 상태 자동 전환 | evidence-path |
| STD-MFG-094 | T4.C5 | 미착수 | 공정별 현황표(당일발주 대기·완료 / 당일생산 주의·불량 / 당일출고) | evidence-path |
| STD-MFG-095 | T4.C5 | 미착수 | 1차 산출데이터(일별 출력량·출고건량·미출고건량·입고건량) | evidence-path |
| STD-MFG-098 | T4.C5 | 미착수 | 자재 입·출고 관리 | evidence-path |
| STD-MFG-100 | T4.C5 | 미착수 | 외주처별 발주서 생성(접수파일 취합) | merged-owner_side |
| STD-MFG-101 | T4.C5 | 미착수 | 책자 상품 수량·크기 기준 선택적 외주 판단 | evidence-path |
| STD-MFG-102 | T4.C5 | 미착수 | 외주 파일 다운로드·업체 포맷 변환·웹하드 업로드 | evidence-path |
| STD-MFG-103 | T4.C5 | 미착수 | 외주공정 주문리스트·외주처별 생산리스트 | evidence-path |
| STD-MFG-104 | T4.C5 | 미착수 | 외주제작·외주공정 제작물 입·출고 기록 | evidence-path |
| STD-MFG-132 | T4.C5 | 미착수 | 조직별 권한 관리(마스터/상품마케팅/발주/생산/출고/외주관리/회계경리) | evidence-path |
| STD-MFG-134 | T4.C5 | 미착수 | 거래처별 청구서 발행(오프라인주문·금액 포함) | evidence-path |
| STD-MFG-135 | T4.C5 | 미착수 | 세금계산서 발행여부·발행날짜 정보 보관 | evidence-path |
| STD-MFG-106 | T4.C6 | 미착수 | 1차포장 처리 | evidence-path |
| STD-MFG-107 | T4.C6 | 미착수 | 박스포장 처리(실사·대형 상품군) | evidence-path |
| STD-MFG-108 | T4.C6 | 미착수 | 제작번호별 바코드 입력→포장완료 상태변경 | evidence-path |
| STD-MFG-109 | T4.C6 | 미착수 | 전 상품 포장완료 시 제작완료 자동 전환 | evidence-path |
| STD-MFG-110 | T4.C6 | 미착수 | 주문번호별 바코드 입력→출고완료 전환 | merged-owner_side |
| STD-MFG-111 | T4.C6 | 미착수 | 송장 출력·송장 추가출력(택배) | merged-owner_side |
| STD-MFG-112 | T4.C6 | 미착수 | 납품명세서 출력(퀵) | evidence-path |
| STD-MFG-113 | T4.C6 | 미착수 | 출고명세서 출력(직접방문) | evidence-path |
| STD-MFG-116 | T4.C6 | 미착수 | 전 상품 출고지 단일화(오프라인 주문 외) | merged-owner_side |
| STD-MFG-117 | T4.C6 | 미착수 | 재고상품(상품 액세서리) 관리 | evidence-path |
| STD-MFG-118 | T4.C6 | 미착수 | 제작완료 썸네일 확인 화면 | evidence-path |
| STD-MFG-119 | T4.C6 | 미착수 | 일부 재제작+재배송 지시(MES 주문복사) | evidence-path |
| STD-MFG-120 | T4.C6 | 미착수 | 전체 재제작+재배송 지시 | evidence-path |
| STD-MFG-121 | T4.C6 | 미착수 | 반송 접수·반송여부 체크 | evidence-path |
| STD-MFG-122 | T4.C6 | 미착수 | 주문 내 정산 메모필드(반송비·재제작 비용 부담) | evidence-path |
| STD-SHP-009 | T4.C6 | 미착수 | 퀵/화물 배송(대형 인쇄물) | merged-owner_side |
| STD-SHP-010 | T4.C6 | 미착수 | 매장 방문수령 | merged-owner_side |
| STD-ADO-027 | T5.D1 | 미실측 | [구IA#94] 고객 SMS 발송 | merged-owner_side |
| STD-MFG-130 | T5.D1 | 미착수 | 알림 발송 주체 경계 준수(주문·결제·배송=샵바이 / 파일=우리) | evidence-path |
| STD-PAY-030 | T5.D4 | 미착수 | 거래명세서 어드민 출력항목·수량 표기 확인(A-4) | merged-owner_side |
| STD-FIN-007 | T5.E1 | 미착수 | 공정/팀별 작업량 통계 | merged-owner_side |
| STD-FIN-019 | T5.E1 | 미착수 | [구IA#84] 굿즈 발주/정산 (Excel 다운) | rule-step |
| STD-SHP-001 | T5.E1 | 부분 | 기본 배송비 부과 | merged-owner_side |
| STD-SHP-002 | T5.E1 | 부분 | 무료배송 기준금액 적용 | merged-owner_side |
| STD-SHP-003 | T5.E1 | 미착수 | 제주 추가 배송비 | merged-owner_side |
| STD-SHP-004 | T5.E1 | 미착수 | 도서산간 권역별 추가 배송비 | merged-owner_side |
| STD-SHP-005 | T5.E1 | 미착수 | 특정 상품군 무료배송 제외(실사·대형) | merged-owner_side |
| STD-SHP-007 | T5.E1 | 부분 | 배송 권역·템플릿 관리 | merged-owner_side |
| STD-SYS-034 | T5.E1 | 미착수 | SMS 사용설정 「사용」 전환 + 포인트 충전(현재 1,000P·사용 안 함) | merged-owner_side |
| STD-SYS-035 | T5.E1 | 미착수 | 알림톡 사용여부 「사용함」 + 주문배송 항목 선택 + 템플릿 검수 | merged-owner_side |
| STD-SYS-037 | T5.E1 | 미착수 | 기초정보 사업자 정보 입력(회사명·사업자등록번호·통신판매업신고번호·주소·개인정보책임자) | merged-owner_side |
| STD-SYS-038 | T5.E1 | 미착수 | 실무진 운영자 계정 생성 + 권한그룹(현재 마스터 1·권한그룹 0) | merged-owner_side |
| T5-1 | T5.E1 | 부분 | 셀러어드민 기초정보 7항목·대표전화/메일 교체·PG 신청·결제수단 노출·운영자 계정 | rule-step |

### ② 다른 담당으로(제안) — 31행

| row_id | 트랙.단계 | status | 일 | 제안 담당 | 근거등급 | 근거 |
|---|---|---|---|---|---|---|
| F3-4 | T1.F3 | 미착수 | 샵바이 콘솔 IP 화이트리스트 52.78.126.17 등록 → 메인이미지 동기화 1건 실측 | 서희항 | rule-step | 사는 시스템 미확인 — 단계 F3 기본 담당과 불일치(약한 근거·실측 필요) |
| F3-5 | T1.F3 | 미착수 | 샵바이 웹훅 수신 URL → 새 호스트 `/api/w/v1/shopby/webhook/<secret>` | 서희항 | rule-step | 사는 시스템 미확인 — 단계 F3 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-ADP-037 | T2.A2 | 부분 | 게시 위젯 가격 전수 대조(1차 최숙진 → 2차 김용기 → 3차 채훈희 승인) | 서희항 | merged-owner_side | 그 일이 사는 곳=widget |
| STD-CAT-028 | T2.A2 | 미착수 | 목록·검색 시작가 「10원~」 표시(샵바이 salePrice 더미) | 김동학 | evidence-path | 그 일이 사는 곳=huni-mall |
| STD-OPT-048 | T2.A2 | 부분 | 면적 기반 가격 계산(실사·현수막·아크릴) | 서희항 | evidence-path | 그 일이 사는 곳=webadmin |
| STD-OPT-050 | T2.A2 | 부분 | 고정가형 가격 계산(수량×옵션) | 서희항 | evidence-path | 그 일이 사는 곳=webadmin |
| STD-OPT-051 | T2.A2 | 부분 | 셋트/부품조립 상품 합산 가격 계산 | 서희항 | merged-owner_side | 그 일이 사는 곳=webadmin |
| STD-OPT-039 | T2.A3 | 부분 | 공정 택일 그룹(상호배타) 처리 | 서희항 | evidence-path | 그 일이 사는 곳=webadmin |
| T2-2 | T2.A3 | 부분 | 위젯 기본값 미지정 교정·재게시 | 서희항 | merged-owner_side | 그 일이 사는 곳=widget |
| STD-OPT-016 | T2.B2 | 부분 | 작업 사이즈 입력·자동 도출(도련 포함) | 서희항 | merged-owner_side | 그 일이 사는 곳=widget |
| STD-OPT-025 | T2.B2 | 부분 | 박 선택(색상 다종 × 면 × 크기 × 내용같음/틀림) | 서희항 | merged-owner_side | 그 일이 사는 곳=widget |
| STD-OPT-035 | T2.B2 | 미착수 | 상품별 기본제공 부자재 규칙 표시 | 서희항 | merged-owner_side | 그 일이 사는 곳=widget |
| STD-OPT-055 | T2.B2 | 미착수 | 대량주문 견적 문의 접수 | 김동학 | evidence-path | 그 일이 사는 곳=huni-mall |
| STD-ART-021 | T2.B3 | 부분 | 온라인 디자인 에디터 진입 | 서희항 | merged-owner_side | 여러 시스템에 걸치나 담당은 한 사람(webadmin,widget) |
| STD-ART-025 | T2.B3 | 부분 | 선택 옵션(사이즈·페이지)과 에디터 캔버스 동기화 | 서희항 | rule-step | 사는 시스템 미확인 — 단계 B3 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-ART-032 | T2.B3 | 미착수 | 에디쿠스 테스트용 단순 상품(메모패드 등) 제공 | 서희항 | rule-step | 사는 시스템 미확인 — 단계 B3 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-MEM-018 | T3.B5 | 미착수 | 회원등급 산정·자동 승급 | 서희항 | merged-owner_side | 그 일이 사는 곳=webadmin |
| STD-PAY-002 | T3.B6 | 미착수 | 실시간 계좌이체 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-PAY-025 | T3.B6 | 미착수 | 샵바이 어드민의 카카오페이 신청 경로 확인 | 김동학 | rule-step | 사는 시스템 미확인 — 단계 B6 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-ORD-025 | T3.B7 | 미착수 | 구매확정(고객·자동) | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-MYP-032 | T3.D2 | 미착수 | 편집 후 장바구니를 누르지 않고 이탈한 고객 안내 방법 | 김동학 | rule-step | 사는 시스템 미확인 — 단계 D2 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-CLM-004 | T3.D3 | 미착수 | 제작 착수 후 취소 제한·협의 안내 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-ADO-008 | T4.C4 | 미착수 | 파일 확인 처리(검판 판정) | 서희항 | merged-owner_side | 그 일이 사는 곳=pitstop |
| STD-MFG-050 | T4.C4 | 미착수 | 자동 발송 오류 목록 관리(좁게 유지·담당자와 확정) | 서희항 | evidence-path | 그 일이 사는 곳=webadmin |
| STD-MFG-010 | T4.C5 | 부분 | 상품↔MES 품목코드(MES_ITEM_CD) 매핑 일괄 적재 | 서희항 | evidence-path | 그 일이 사는 곳=webadmin |
| STD-MFG-123 | T4.C6 | 미착수 | 재출고 신규송장 부여(상품누락 추가발송·교환 재발송) | 서희항 | merged-owner_side | 그 일이 사는 곳=webadmin |
| STD-PAY-015 | T5.D4 | 미착수 | 현금영수증 발급 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-PAY-017 | T5.D4 | 부분 | 사업자정보 등록·관리 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-PAY-018 | T5.D4 | 부분 | 거래명세서 출력 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-SYS-025 | T5.E1 | 부분 | [구IA#44] 관리자 등록/관리 | 서희항 | evidence-path | 그 일이 사는 곳=webadmin |
| STD-INF-008 | T5.E3 | 미착수 | 푸터 SNS 4종·입점제휴문의·카톡상담 링크가 '#' | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |

### ③ 행을 나눠야 함 — 10행

| row_id | 트랙.단계 | status | 일 | 제안 담당 | 근거등급 | 근거 |
|---|---|---|---|---|---|---|
| BLK-S4-9 | T1.F3 | 미착수 | [선행 입력] 샵바이 콘솔 권한자(IP 화이트리스트·웹훅 URL 편집) | 최숙진+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| STD-CAT-031 | T2.A1 | 부분 | 캘린더 4종 1차 오픈 포함 확정 | 최숙진+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| STD-CAT-019 | T3.A5 | 부분 | 인쇄 가이드 콘텐츠(11종) | 최숙진+김동학 | merged-owner_side | 인쇄 가이드 11종 — 원고·콘텐츠=최숙진 / guide-data.ts 스텁 채우기·화면=김동학 |
| STD-INF-005 | T3.A5 | 부분 | 공지사항 고객 화면(목록·상세) | 김동학+최숙진 | merged-owner_side | 공지사항 고객 화면 — 화면=김동학 / 공지 내용 작성·게시=최숙진 |
| STD-INF-007 | T3.A5 | 부분 | 가이드북 고객 화면(작업 유의사항 11종) | 최숙진+김동학 | merged-owner_side | 가이드북 고객 화면 — 작업 유의사항 11종 내용=최숙진 / 화면 구현=김동학 |
| STD-MYP-040 | T3.D2 | 부분 | 마이페이지 9개 메뉴 점검·판정표 + 프린트머니 범위 결정 | 최숙진+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| BLK-S2-2 | T4.C3 | 미착수 | [선행 입력] 샵바이 어드민 웹훅 등록 현황(URL·구독 이벤트) | 최숙진+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| T4-5 | T4.C6 | 없음 | 출고·송장 — 셀러어드민 수동 등록 경로 확인 + 생산 상태의 고객 반영 방식 결정 | 최숙진+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| T5-2 | T5.D1 | 부분 | 알림 — SMS 사용설정·알림톡 33건 개별 판단 후 켜기·템플릿 카카오 검수 | 최숙진+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |
| STD-MYP-039 | T5.D4 | 미착수 | 세금계산서 API 자동 발행 여부 결정 | 최숙진+신우진 | rule-track | 결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리 |

### ④ 제공/불필요 — 개발 일 아님(확인만) — 6행

| row_id | 트랙.단계 | status | 일 | 제안 담당 | 근거등급 | 근거 |
|---|---|---|---|---|---|---|
| STD-MEM-021 | T3.B5 | 미착수 | 가입완료 안내 메일 발송 | 최숙진 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 최숙진 |
| STD-PAY-003 | T3.B6 | 작동 | 무통장입금(가상계좌)·입금대기 상태 | 최숙진 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 최숙진 |
| STD-PAY-028 | T3.B6 | 작동 | 무통장 입금 계좌 등록 | 최숙진 | merged-owner_side | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-ORD-031 | T3.B7 | 미착수 | 주문완료 메일/알림 발송 | 최숙진 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 최숙진 |
| STD-SHP-006 | T5.E1 | 작동 | 혼합주문 배송비 산정(최고값 1건) | 최숙진 | merged-owner_side | 셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만) |
| STD-MYP-008 | T6.D5 | 미착수 | 구매확정 적립금 자동 지급 | 최숙진 | merged-owner_side | 외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 최숙진 |

### ⑤ 미정 — 2행

| row_id | 트랙.단계 | status | 일 | 제안 담당 | 근거등급 | 근거 |
|---|---|---|---|---|---|---|
| STD-MYP-026 | T6.D5 | 미착수 | 구 ASP 코드·DB 미제공 전제 — 이관 원천은 잔액 스냅샷만 | 최숙진 | rule-track | 사는 시스템도 단계 기본 담당도 못 짚음(D5 프린트머니 등) — 실측·결정 필요 |
| STD-MYP-041 | T6.D5 | 미착수 | 프린트머니 화면 피그마 부재·명칭 미정(「마이 포인트」 등) | 최숙진 | rule-track | 사는 시스템도 단계 기본 담당도 못 짚음(D5 프린트머니 등) — 실측·결정 필요 |

### 넘어올 제안 — 65행

| row_id | 트랙.단계 | status | 일 | 현재 담당 | 판정 | 근거등급 |
|---|---|---|---|---|---|---|
| STD-ADP-034 | T2.A1 | 미실측 | 수작 상품 등록 | 신우진 | 재배정 | rule-step |
| STD-CAT-040 | T2.A1 | 미착수 | 시작가가 API 로 샵바이에 내려가는데 쇼핑몰에 반영되지 않는 원인 확인 | 신우진 | 재배정 | rule-step |
| STD-CAT-041 | T2.A1 | 미착수 | 판매중 상품 수 3갈래(대시보드 291·상품목록 판매중 297/검색 291·API ONSALE 226) 기준 | 김동학 | 재배정 | evidence-path |
| STD-ADC-014 | T3.A5 | 구현-미검증 | 인쇄 가이드 콘텐츠 관리 | 김동학 | 분할 | merged-owner_side |
| STD-CAT-007 | T3.A5 | 부분 | 상품 상세페이지 본문(이미지·설명 블록) | 김동학 | 분할 | merged-owner_side |
| STD-CAT-009 | T3.A5 | 미착수 | 후가공 용어 설명 툴팁(도무송·오시·형압·귀돌이) | 김동학 | 분할 | merged-owner_side |
| STD-CAT-012 | T3.A5 | 부분 | 재작업 불가 사항 고지(폰트 아웃라인 등) | 김동학 | 분할 | merged-owner_side |
| STD-CAT-034 | T3.A5 | 부분 | 상세페이지 탭 6종 자동 등록(디자인가이드·디자인보기 포함) | 김동학 | 분할 | merged-owner_side |
| STD-OPT-057 | T3.A5 | 미착수 | 규격 가이드 모달(사이즈 안내 팝업) | 서희항 | 분할 | merged-owner_side |
| STD-OPT-058 | T3.A5 | 미착수 | 주문가능 자재(용지) 목록 모달 | 서희항 | 분할 | merged-owner_side |
| STD-PAY-006 | T3.B6 | 미착수 | 토스페이 결제 | 신우진 | 재배정 | merged-owner_side |
| STD-PAY-029 | T3.B6 | 미착수 | 미입금 주문 자동취소 기간 정책 확정(현재 무통장 7영업일·가상계좌 7일) | 신우진 | 재배정 | evidence-path |
| STD-PRM-002 | T3.D2 | 미착수 | 리뷰 작성 보상 쿠폰 발행 | 김동학 | 재배정 | merged-owner_side |
| STD-PRM-003 | T3.D2 | 미착수 | 재구매 쿠폰 발행 | 김동학 | 재배정 | merged-owner_side |
| STD-PRM-005 | T3.D2 | 부분 | 쿠폰 동시사용 개수 제한 | 김동학 | 재배정 | merged-owner_side |
| STD-PRM-008 | T3.D2 | 미착수 | 리뷰 삭제 시 보상 회수 | 김동학 | 재배정 | merged-owner_side |
| STD-ADO-023 | T3.D3 | 부분 | 환불 실행·정산 반영 | 김동학 | 재배정 | merged-owner_side |
| STD-CLM-011 | T3.D3 | 미착수 | 귀책 구분(구매자/판매자/단순변심) | 김동학 | 재배정 | merged-owner_side |
| STD-CLM-013 | T3.D3 | 미착수 | 판매자 클레임 승인·거부 처리 | 김동학 | 재배정 | merged-owner_side |
| STD-CLM-015 | T3.D3 | 미착수 | 재제작(재작업) 처리 경로 | 신우진 | 분할 | rule-track |
| STD-SYS-039 | T4.C3 | 미착수 | 웹훅 등록 화면 위치 확인(셀러어드민 내 미발견) 및 등록 여부 | 김동학 | 재배정 | evidence-path |
| STD-ADO-005 | T4.C5 | 미착수 | 상태 변경 시 고객 알림 자동발송 | 김동학 | 재배정 | rule-step |
| STD-ADO-006 | T4.C5 | 미착수 | 주문서(작업지시서) 출력 | 김동학 | 재배정 | merged-owner_side |
| STD-ADO-012 | T4.C5 | 미착수 | 인쇄 공정 상태 트래킹 | 서희항 | 재배정 | merged-owner_side |
| STD-MFG-078 | T4.C5 | 미착수 | 파일명 자동 RENAME 규약 적용(품목_출력사이즈_양단면_소재_거래처_고객_고유번호_수량) | 서희항 | 재배정 | evidence-path |
| STD-MFG-079 | T4.C5 | 미착수 | 상품군별 파일명 조합 규칙 8종(디지털/캘린더/스티커/실사/배너/패브릭/시트커팅/레이저커팅) | 서희항 | 재배정 | evidence-path |
| STD-MFG-084 | T4.C5 | 미착수 | 공정라우트 마스터(18케이스 라우트 정의·재채번) | 서희항 | 재배정 | merged-owner_side |
| STD-MFG-085 | T4.C5 | 미착수 | 라우트 단계 정의(순번·공정·필수선택·담당팀) | 서희항 | 재배정 | evidence-path |
| STD-MFG-086 | T4.C5 | 미착수 | 상품→공정라우트 매핑 | 서희항 | 재배정 | evidence-path |
| STD-MFG-096 | T4.C5 | 미착수 | 2차 산출데이터(팀별 입고예정·공정별 평균리드타임·평균 제작기간) | 서희항 | 재배정 | evidence-path |
| STD-MFG-133 | T4.C5 | 미실측 | 오프라인 주문 등록(거래처별 EXCEL·금액 직접 입력) | 신우진 | 재배정 | merged-owner_side |
| T4-4 | T4.C5 | 없음 | 접수 화면·주문 상태머신·MES 접수 전송(D-P5·D-P6·D-P7) | 서희항 | 분할 | merged-owner_side |
| STD-MFG-115 | T4.C6 | 미착수 | 합배송 리스트 식별 | 서희항 | 재배정 | evidence-path |
| STD-SHP-011 | T4.C6 | 미착수 | 분할배송(건별 부분 출고) | 신우진 | 재배정 | merged-owner_side |
| STD-MFG-125 | T5.D1 | 미착수 | 파일 오류 재업로드 요청 알림톡 발송(자동·담당자 발) | 서희항 | 분할 | evidence-path |
| STD-MFG-126 | T5.D1 | 미착수 | 재업로드 접수 확인 알림 | 서희항 | 분할 | evidence-path |
| STD-MFG-127 | T5.D1 | 미착수 | 편집상품 수정요청 알림(주문번호·편집번호·안내) | 서희항 | 분할 | evidence-path |
| STD-MFG-129 | T5.D1 | 미착수 | 알림톡 발송 실패 시 SMS/LMS 자동 대체 | 서희항 | 분할 | evidence-path |
| STD-PRM-012 | T5.D1 | 미착수 | 알림톡/SMS 마케팅 발송 | 김동학 | 재배정 | merged-owner_side |
| STD-PRM-013 | T5.D1 | 미착수 | 이메일 뉴스레터 발송 | 김동학 | 재배정 | merged-owner_side |
| STD-ADO-024 | T5.D4 | 미착수 | 증빙서류 발급 관리 | 김동학 | 재배정 | merged-owner_side |
| STD-B2B-002 | T5.E1 | 미착수 | 거래처별 단가/할인율 설정 | 김동학 | 재배정 | rule-step |
| STD-B2B-003 | T5.E1 | 미착수 | 거래처 소속 담당자 다계정 | 김동학 | 재배정 | rule-step |
| STD-B2B-006 | T5.E1 | 미착수 | 월 마감 청구서 발행 | 김동학 | 재배정 | rule-step |
| STD-B2B-007 | T5.E1 | 미착수 | 업체별 미수금 관리 | 김동학 | 재배정 | rule-step |
| STD-B2B-010 | T5.E1 | 미착수 | 대량 견적 요청 접수·회신 | 김동학 | 재배정 | rule-step |
| STD-B2B-011 | T5.E1 | 미착수 | 견적서 발행(사업자 양식) | 김동학 | 재배정 | rule-step |
| STD-B2B-013 | T5.E1 | 미실측 | [구IA#45] 거래처관리 (등록/수정/처리) | 신우진 | 재배정 | merged-owner_side |
| STD-B2B-014 | T5.E1 | 미실측 | [구IA#46] 매장게시판 | 신우진 | 재배정 | merged-owner_side |
| STD-FIN-008 | T5.E1 | 미착수 | PG 정산 대사 | 김동학 | 재배정 | rule-step |
| STD-FIN-009 | T5.E1 | 미착수 | 적립금(프린팅머니) 부채 집계 | 김동학 | 재배정 | rule-step |
| STD-FIN-010 | T5.E1 | 미착수 | 외주 발주/정산 엑셀 산출 | 김동학 | 재배정 | rule-step |
| STD-FIN-012 | T5.E1 | 미착수 | 통계·주문 데이터 엑셀 내보내기 | 김동학 | 재배정 | rule-step |
| STD-FIN-013 | T5.E1 | 미착수 | [구IA#47] 계좌관리 (원장용 계좌 등록) | 신우진 | 재배정 | rule-step |
| STD-FIN-014 | T5.E1 | 미착수 | [구IA#49] 업체별 미수금 | 신우진 | 재배정 | rule-step |
| STD-FIN-015 | T5.E1 | 미실측 | [구IA#79] 인쇄/제본 상품통계 (상세보기) | 신우진 | 재배정 | merged-owner_side |
| STD-FIN-016 | T5.E1 | 미실측 | [구IA#80] 굿즈 상품통계 (상세보기) | 신우진 | 재배정 | merged-owner_side |
| STD-FIN-017 | T5.E1 | 미실측 | [구IA#81] 패키지 상품통계 (상세보기) | 신우진 | 재배정 | merged-owner_side |
| STD-FIN-018 | T5.E1 | 미실측 | [구IA#82] 수작 상품통계 (상세보기) | 신우진 | 재배정 | merged-owner_side |
| STD-FIN-021 | T5.E1 | 미착수 | 적립금·증빙 데이터의 MS·이카운트 연동 방식 | 김용기 | 재배정 | rule-step |
| STD-SHP-017 | T5.E1 | 부분 | 금지 설정 4종 확인(A-14/U-1): 수량비례·중량 배송비 / 최대구매수량 / 즉시할인 | 김동학 | 재배정 | merged-owner_side |
| STD-SYS-004 | T5.E1 | 부분 | PG 연동 설정 | 김동학 | 재배정 | merged-owner_side |
| STD-SYS-005 | T5.E1 | 부분 | 배송비 정책 설정 | 김동학 | 재배정 | merged-owner_side |
| STD-SYS-006 | T5.E1 | 미착수 | 알림(SMS/알림톡/이메일) 템플릿 설정 | 김동학 | 재배정 | merged-owner_side |
| T5-3 | T5.E3 | 부분 | 법정 표기 단일화(사업자번호 206-29-88022 우세)·증빙 화면 목업 제거(D-5) | 김동학 | 분할 | rule-track |


## 신우진

### 한 장 요약

| 항목 | 행수 |
|---|---|
| 현재 걸린 행(원장 전체) | 69 |
| 그중 남은 일(status≠작동) | 66 |
| ① 담당 맞음 — 그대로 한다 | 19 |
| ② 다른 담당으로 넘길 제안 | 40 |
| ③ 행을 나눠야 함(경계 걸침) | 4 |
| ④ 샵바이·MES 제공이라 개발 일 아님 / 불필요 | 0 |
| ⑤ 미정(실측·결정 전이라 배정 불가) | 3 |
| **다른 사람에게서 넘어올 제안** | **16** |

재판정 뒤 이 사람이 실제로 질 남은 일(제안 기준) = 19 + 넘어옴 16 = **35행** (+ 나눠야 하는 4행의 자기 몫)

### 트랙별

| 트랙 | 남은 일 | 담당맞음 | 재배정 | 분할 | 제공/불필요 | 미정 |
|---|---|---|---|---|---|---|
| T1 인프라 이전(Lightsail) | 5 | 1 | 4 | 0 | 0 | 0 |
| T2 상품·가격·위젯 준비 | 7 | 1 | 6 | 0 | 0 | 0 |
| T3 쇼핑몰 주문·결제·회원 | 26 | 8 | 15 | 2 | 0 | 1 |
| T4 주문 수신·원고·생산 연동 | 5 | 0 | 4 | 1 | 0 | 0 |
| T5 운영 설정·알림·CS·증빙 | 15 | 5 | 10 | 0 | 0 | 0 |
| T6 프린팅머니 | 4 | 1 | 1 | 0 | 0 | 2 |
| T7 테스트·리허설·컷오버 | 4 | 3 | 0 | 1 | 0 | 0 |

### ① 담당 맞음 — 그대로 한다 — 19행

| row_id | 트랙.단계 | status | 일 | 근거등급 |
|---|---|---|---|---|
| F3-12 | T1.F3 | 미착수 | 웹팀 통보: vc_ 는 `webapp`, 우리 DB 에 직접 테이블 생성 금지 | rule-track |
| STD-CAT-038 | T2.A1 | 미착수 | 디자인 목록용 API·어드민 기능 개발자 협의 | rule-track |
| BLK-S3-2 | T3.B5 | 미착수 | [선행 입력] Shopby 회원 일괄등록 수단(어드민 엑셀 / Server API 부재 확인 / 외부회원연동) | rule-track |
| BLK-S3-3 | T3.B5 | 미착수 | [선행 입력] 이메일 NULL·중복 회원 규모와 처리 원칙 | rule-track |
| BLK-S1-3 | T3.B6 | 미착수 | [선행 입력] 결제수단 범위(무통장만 / +카드 / +계좌이체) | rule-track |
| STD-PAY-021 | T3.B6 | 미착수 | 충전은 현금만 수납 — 이니시스 PG 결제와 회계 분리 | rule-track |
| STD-PAY-024 | T3.B6 | 미착수 | 카카오페이 신청 서류·절차 정리 후 전달 | rule-track |
| STD-MYP-031 | T3.D2 | 미착수 | 보관함 저장 시점 결정(저장 버튼 vs 편집 종료 시 자동) | rule-track |
| STD-MYP-033 | T3.D2 | 미착수 | 보관함을 일반 상품까지 확대할지 여부 | rule-track |
| BLK-S1-6 | T3.D3 | 미착수 | [선행 입력] 클레임·문의 범위(Shopby API / 외부 채널 / 미제공) | rule-track |
| STD-PRM-021 | T5.D1 | 구현-미검증 | 080 수신거부 서비스 미도입 확정 | rule-track |
| BLK-S1-4 | T5.D4 | 미착수 | [선행 입력] 현금영수증·세금계산서 발급 주체(Shopby/자체/외부) | rule-track |
| T5-4 | T5.D4 | 없음 | 현금영수증·세금계산서 발급 주체 결정(Shopby / 자체 / 외부) | rule-track |
| STD-SYS-028 | T5.E1 | 미착수 | webadmin 영역 분리(쇼핑몰 관리자 영역 / DB·생산 영역) | rule-track |
| STD-SYS-042 | T5.E1 | 미착수 | 관리자 대시보드(/admin) 존폐 결정 — 빈 스캐폴드이며 role 이 항상 "user" 라 누구도 진입 불가 | evidence-path |
| STD-MYP-022 | T6.D5 | 미착수 | 프린트머니 원장·외부포인트 API 5종·증빙 발행·충전 운영 화면의 개발 주체·배치 확정 | rule-track |
| STD-SYS-033 | T7.E4 | 미착수 | 사이트 전체 화면·절차 설계(버튼 동작·결제 단계 기능 가능 여부·비용 정리 후 컨펌) | rule-track |
| T7-1 | T7.E4 | 미착수 | 오픈 테스트 진입 조건 9항을 리허설 체크리스트로 승격 | rule-step |
| T7-2 | T7.E4 | 미착수 | 종단 주문 테스트 — 실주문 1건이 결제→접수→MES→송장→고객 조회까지 | rule-step |

### ② 다른 담당으로(제안) — 40행

| row_id | 트랙.단계 | status | 일 | 제안 담당 | 근거등급 | 근거 |
|---|---|---|---|---|---|---|
| F3-11 | T1.F3 | 미착수 | Railway 3서비스 종료(최종 덤프 보관 후) | 서희항 | rule-track | Railway 3서비스 종료 = 관리서버·DB 쪽 |
| F3-7 | T1.F3 | 미착수 | DNS `huni-admin.printly.co.kr` CNAME → Lightsail + `CUSTOM_DOMAIN` 에 콤 | 서희항 | rule-track | huni-admin.printly.co.kr(관리서버) DNS — 관리서버 담당 |
| F4-7 | T1.F4 | 미착수 | vercel.app 리다이렉트: 코드에 없음(§1 마지막 행). Vercel 대시보드 리다이렉트·도메인 설정을 PM 이 확인해 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| F4-8 | T1.F4 | 미착수 | Vercel 프로젝트 정지(오픈 테스트 통과 후) | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-ADP-034 | T2.A1 | 미실측 | 수작 상품 등록 | 서희항·최숙진 | rule-step | 사는 시스템 미확인 — 단계 A1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-CAT-026 | T2.A1 | 미착수 | 수작 상품 메인·상품페이지 경로 | 김동학 | evidence-path | 그 일이 사는 곳=huni-mall |
| STD-CAT-040 | T2.A1 | 미착수 | 시작가가 API 로 샵바이에 내려가는데 쇼핑몰에 반영되지 않는 원인 확인 | 서희항·최숙진 | rule-step | 사는 시스템 미확인 — 단계 A1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-OPT-053 | T2.B2 | 미착수 | 견적 결과 저장(옵션보관함) | 서희항 | rule-track | 견적 결과 저장(옵션보관함) = 위젯 상태 저장 축 |
| STD-OPT-054 | T2.B2 | 미착수 | 견적서 PDF/출력물 발급 | 서희항 | rule-track | 견적서 발급 = 가격엔진 산출물 |
| STD-ART-023 | T2.B3 | 미착수 | 에디터 작업물 저장·재편집 | 서희항 | rule-track | 에디터 작업물 저장·재편집 = Edicus 연동 계약(위젯 축) |
| STD-MEM-022 | T3.B5 | 미착수 | 로그인 식별자 정책(이메일 전용 vs 아이디) 확정·테스트회원 계정 정비 | 김동학 | evidence-path | 그 일이 사는 곳=huni-mall |
| STD-ORD-015 | T3.B6 | 미착수 | 나중배송(배송지 미입력) 주문 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-ORD-017 | T3.B6 | 미착수 | 출고 옵션 선택(오늘출고·토요일출고) | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-PAY-001 | T3.B6 | 미착수 | 신용카드 결제(PG) | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-PAY-006 | T3.B6 | 미착수 | 토스페이 결제 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-PAY-010 | T3.B6 | 미착수 | B2B 후불결제 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-PAY-029 | T3.B6 | 미착수 | 미입금 주문 자동취소 기간 정책 확정(현재 무통장 7영업일·가상계좌 7일) | 최숙진 | evidence-path | 셀러어드민 설정·운영(코드 0) |
| STD-MYP-004 | T3.D2 | 미착수 | 옵션보관함 저장/불러오기 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-MYP-005 | T3.D2 | 미착수 | 보관 기간 정책 적용·만료 처리 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-MYP-019 | T3.D2 | 미착수 | 마이페이지 통합 검색결과 LIST 화면 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-PRM-011 | T3.D2 | 미착수 | 체험단 모집·신청·당첨·후기 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-PRM-016 | T3.D2 | 미착수 | 이용후기 메인(전체 리뷰 모아보기) | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-PRM-017 | T3.D2 | 미실측 | [구IA#71] 체험단관리 (등록/수정/신청내역) | 김동학 | rule-step | 사는 시스템 미확인 — 단계 D2 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-CLM-018 | T3.D3 | 부분 | 공지사항·FAQ 열람 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-CLM-021 | T3.D3 | 미착수 | 디자인 의뢰하기(주문 흐름 내) | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-SYS-012 | T4.C3 | 부분 | 본인인증 서비스 연동 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-ART-016 | T4.C4 | 미착수 | 자동검판 도구 연동(PitStop 등) | 서희항 | merged-owner_side | PitStop 연동 = 경계 정의상 위젯/파이프라인 축(merged lives=webadmin) |
| STD-MFG-133 | T4.C5 | 미실측 | 오프라인 주문 등록(거래처별 EXCEL·금액 직접 입력) | 최숙진 | merged-owner_side | MES 현행 기능·생산 현장 운영 — 신규 개발이면 외부(MES 담당) |
| STD-SHP-011 | T4.C6 | 미착수 | 분할배송(건별 부분 출고) | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-MFG-128 | T5.D1 | 미착수 | 알림톡 템플릿 사전 심사·승인 관리 | 서희항 | evidence-path | 그 일이 사는 곳=webadmin |
| STD-B2B-013 | T5.E1 | 미실측 | [구IA#45] 거래처관리 (등록/수정/처리) | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-B2B-014 | T5.E1 | 미실측 | [구IA#46] 매장게시판 | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-FIN-013 | T5.E1 | 미착수 | [구IA#47] 계좌관리 (원장용 계좌 등록) | 최숙진 | rule-step | 사는 시스템 미확인 — 단계 E1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-FIN-014 | T5.E1 | 미착수 | [구IA#49] 업체별 미수금 | 최숙진 | rule-step | 사는 시스템 미확인 — 단계 E1 기본 담당과 불일치(약한 근거·실측 필요) |
| STD-FIN-015 | T5.E1 | 미실측 | [구IA#79] 인쇄/제본 상품통계 (상세보기) | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-FIN-016 | T5.E1 | 미실측 | [구IA#80] 굿즈 상품통계 (상세보기) | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-FIN-017 | T5.E1 | 미실측 | [구IA#81] 패키지 상품통계 (상세보기) | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-FIN-018 | T5.E1 | 미실측 | [구IA#82] 수작 상품통계 (상세보기) | 최숙진 | merged-owner_side | 셀러어드민 설정·운영(코드 0) |
| STD-INF-001 | T5.E3 | 부분 | 회사소개 페이지 | 김동학 | merged-owner_side | 그 일이 사는 곳=huni-mall |
| STD-MYP-054 | T6.D5 | 미착수 | 마이포인트(/mypage/point·shopby 적립금)와 프린팅머니(/mypage/money·UI 전용) 메뉴 중복 정리 — | 김동학 | evidence-path | 그 일이 사는 곳=huni-mall |

### ③ 행을 나눠야 함 — 4행

| row_id | 트랙.단계 | status | 일 | 제안 담당 | 근거등급 | 근거 |
|---|---|---|---|---|---|---|
| STD-CLM-015 | T3.D3 | 미착수 | 재제작(재작업) 처리 경로 | 신우진+최숙진 | rule-track | 재제작 처리 「경로 결정」(PM) + 「운영 절차」(실무운영). 화면 근거 없음 |
| T3-5 | T3.D3 | 없음 | 취소·반품·문의 — 범위 결정 후 스킨 버튼·문의 라우트 구현 | 신우진+김동학 | rule-track | 「범위 결정」(PM) + 「스킨 버튼·문의 라우트 구현」(김동학)이 한 행에 섞였다 — 결정/구현 분리 |
| STD-ART-027 | T4.C2 | 미착수 | 과거 주문 파일 재사용 재주문 | 서희항+김동학 | rule-track | 과거 주문 파일 재사용 = 원고 보관(webadmin) + 재주문 진입(스킨) |
| STD-SYS-050 | T7.E4 | 미착수 | huni-skin-next 포크(SPEC-TAKEOVER-001 M0~M7·20커밋·remote 없음) 처리 결정 — 원본 m | 신우진+김동학 | evidence-path | 포크 처리 「결정」은 PM, 선별 이식 「구현」은 스킨 담당 |

### ⑤ 미정 — 3행

| row_id | 트랙.단계 | status | 일 | 제안 담당 | 근거등급 | 근거 |
|---|---|---|---|---|---|---|
| STD-PRM-015 | T3.A5 | 미실측 | (IA r59 기능명 공란) | 신우진 | rule-track | IA r59 기능명 공란 — 무슨 일인지조차 미상. 실측 전 배정 불가 |
| STD-B2B-015 | T6.D5 | 미실측 | [구IA#91] 주문관리-후불결제 | 신우진 | rule-track | 사는 시스템도 단계 기본 담당도 못 짚음(D5 프린트머니 등) — 실측·결정 필요 |
| STD-MYP-025 | T6.D5 | 미착수 | 프린트머니 정책 — 소멸기한 없음·충전 1:1·추가 적립 없음 | 신우진 | rule-track | 사는 시스템도 단계 기본 담당도 못 짚음(D5 프린트머니 등) — 실측·결정 필요 |

### 넘어올 제안 — 16행

| row_id | 트랙.단계 | status | 일 | 현재 담당 | 판정 | 근거등급 |
|---|---|---|---|---|---|---|
| BLK-S4-9 | T1.F3 | 미착수 | [선행 입력] 샵바이 콘솔 권한자(IP 화이트리스트·웹훅 URL 편집) | 최숙진 | 분할 | rule-track |
| BLK-S4-6 | T1.F4 | 미착수 | [선행 입력] Vercel 프로젝트 접근 · 현재 `DATABASE_URL`·`NEXTAUTH_URL` 소재 | 김동학·PM | 분할 | rule-track |
| STD-CAT-031 | T2.A1 | 부분 | 캘린더 4종 1차 오픈 포함 확정 | 최숙진 | 분할 | rule-track |
| T3-2 | T3.B5 | 부분 | 로그인 성공인데 오류 문구·리다이렉트 없음 수정(D-2) + 회원 이관 경로 확정 | 김동학 | 분할 | rule-track |
| T3-3 | T3.B6 | 부분 | 주문서·결제 — 결제수단 범위 결정 후 스킨 결제 분기·주문 성립 1건 종단 | 김동학 | 분할 | rule-track |
| STD-MYP-040 | T3.D2 | 부분 | 마이페이지 9개 메뉴 점검·판정표 + 프린트머니 범위 결정 | 최숙진 | 분할 | rule-track |
| BLK-S1-5 | T4.C1 | 미착수 | [선행 입력] `order/register` 계약(엔드포인트·페이로드·서버키) | 서희항 | 분할 | rule-track |
| BLK-S2-1 | T4.C1 | 미착수 | [선행 입력] Railway 운영 변수 4종 설정 여부(값 아님) — `WAPI_SERVER_KEY_REQU | 서희항 | 분할 | rule-track |
| BLK-S2-5 | T4.C2 | 미착수 | [선행 입력] Lightsail 이전 후 크론·워커 실행 형태 | 서희항 | 분할 | rule-track |
| BLK-S2-2 | T4.C3 | 미착수 | [선행 입력] 샵바이 어드민 웹훅 등록 현황(URL·구독 이벤트) | 최숙진 | 분할 | rule-track |
| STD-SYS-041 | T4.C3 | 미착수 | 상품 텍스트옵션 라벨 huni_token 미등록 확정(U-2) → 스킨 담기 구현 정합 | 김동학 | 분할 | rule-track |
| T4-3 | T4.C4 | 없음 | 파일 검수 경로 결정·구축 — PitStop 조달 또는 사람 검수(D-P1·D-P2) | 서희항 | 분할 | rule-track |
| T4-5 | T4.C6 | 없음 | 출고·송장 — 셀러어드민 수동 등록 경로 확인 + 생산 상태의 고객 반영 방식 결정 | 최숙진 | 분할 | rule-track |
| T5-2 | T5.D1 | 부분 | 알림 — SMS 사용설정·알림톡 33건 개별 판단 후 켜기·템플릿 카카오 검수 | 최숙진 | 분할 | rule-track |
| STD-MYP-039 | T5.D4 | 미착수 | 세금계산서 API 자동 발행 여부 결정 | 최숙진 | 분할 | rule-track |
| STD-B2B-005 | T6.D5 | 미착수 | 후불 주문 승인·미결제 관리 | 김동학 | 분할 | rule-track |


## 그 밖(외부·대표·지니·미정) — 67행

사내 4담당 경계 밖이라 이번 재판정 대상이 아니다(판정=미정 유지).

| 담당 | 행수 |
|---|---|
| 미정 | 22 |
| 외부(인프라팀) | 9 |
| 채훈희 | 5 |
| 외부(토스페이먼츠) | 5 |
| 지니 | 5 |
| 외부(상대측 회신 대기) | 5 |
| 외부(NHN커머스) | 2 |
| 외부(KG이니시스) | 2 |
| 외부(구 사이트 운영사) | 2 |
| 외부(네이버페이) | 1 |
| 외부(카카오페이) | 1 |
| 외부(이니시스·카카오페이) | 1 |
| 외부(샵바이(NHN커머스)) | 1 |
| 김용기 | 1 |
| 외부(MES 담당) | 1 |
| 대표(구매) | 1 |
| 김동학·PM | 1 |
| 외부(Cloudflare DNS 권한자) | 1 |
| 외부(소셜 3사 콘솔 권한자) | 1 |
