# -*- coding: utf-8 -*-
"""t52 — 미수록 83행 재판정. 입력=t51 xlsx 「미수록」 시트(추출본 unlisted-input.csv),
대조=t48/t49/t50 screens.csv(레인 원장 747행). 읽기전용·판정표를 결정론으로 합친다."""
import csv, collections, sys, pathlib
BASE = pathlib.Path(__file__).resolve().parent.parent

# 판정: R=라우팅 대상 오류(원장 실재·plan_row_id 연결 누락) / M=빠진 일(원장에 대응 행 없음) / N=불필요(보충 4 결정·관리 안건)
J = {
"STD-ORD-027": ("R","mes","t50/screens.csv:30","MES-ORD-FrmOrderOffline 오프라인 주문 등록(STD-MFG-133·build/완료·[오픈분모밖]) — 넘긴곳 webadmin 오배정"),
"STD-MYP-028": ("M","webadmin↔토스","t49/screens.csv:199","webadmin 원장 147행에 토스 counterpart 행 0 · 샵바이 가상계좌(t48/screens.csv:90 STD-PAY-003)는 주문결제용 provided 로 충전 발급과 별건. 선행 결정 STD-PAY-023·STD-MYP-023(t48/huni-mall-decisions.md)"),
"STD-MYP-029": ("M","webadmin","t49/screens.csv:199","기존 shopby_webhook 는 결제완료·취소·배송지변경만 수신(STD-PAY-031) — 입금 콜백→충전 적립 분기 행 없음"),
"STD-MYP-043": ("M","webadmin","t48/screens.csv:34","프린트머니 M0(t48:34)·M2(t48/screens.csv:116)·M3(t48/screens.csv:227)·M6(t48/screens.csv:10)은 원장 실재, M1 만 부재. 단 원장 소유 결정 STD-MYP-051(t48/shopby-decisions.md) 에서 A(샵바이 적립금) 채택 시 불요"),
"STD-MYP-046": ("M","webadmin","t48/screens.csv:34","M4(충전 취소/환불 + txn 운영화면) 대응 행 0 — M0/M2/M3/M6 만 실재"),
"STD-MYP-047": ("R","shopby","t48/screens.csv:93","SB-POINT 기존 프린트머니 잔액 이관(STD-MYP-009·integrate/미착수)이 M5 와 같은 일"),
"STD-PRM-017": ("M","shopby","t48/screens.csv:255","MALL-EVENT 체험단 모집·신청·당첨·후기(STD-PRM-011)는 고객 화면 — 운영자 관리 화면 행 0. STD-ADC-016 과 동일 기능의 구IA 표기(t48 선례상 두 plan_row_id 를 한 화면에 병기)"),
"STD-B2B-001": ("R","shopby","t48/screens.csv:86","SB-MEMBER [구IA#45] 거래처관리 (등록/수정/처리)(STD-B2B-013·config/미확인)"),
"STD-B2B-002": ("M","shopby","t48/screens.csv:86","거래처별 커머스 단가/할인율 행 0(MES 고객별 제지 할인율 t50/screens.csv:44 는 생산원가축으로 별건)"),
"STD-B2B-003": ("M","shopby","t48/screens.csv:86","거래처 소속 담당자 다계정 행 0"),
"STD-B2B-004": ("M","shopby","t48/screens.csv:245","MALL-CHECKOUT B2B 후불결제(STD-PAY-010)는 고객 주문서 측 — 여신한도 설정 행 0"),
"STD-B2B-005": ("M","shopby","t48/screens.csv:245","후불 주문 승인·미결제 관리(운영자) 행 0"),
"STD-B2B-006": ("M","shopby","t48/screens.csv:51","SB-ORDER 증빙서류 발급 관리(STD-ADO-024)는 건별 증빙 — 월 마감 청구서 행 0"),
"STD-B2B-007": ("M","shopby","t52/ledger-index.txt","원장 747행 「미수금」 0건(grep 실측) · STD-FIN-014 와 동일 기능의 구IA 표기"),
"STD-B2B-008": ("M","shopby","t50/screens.csv:30","온·오프라인 통합 거래처 원장 행 0(MES 오프라인 주문 등록은 주문 단건)"),
"STD-B2B-009": ("M","shopby","t52/ledger-index.txt","원장 데이터 .txt 산출 행 0(grep 실측)"),
"STD-B2B-010": ("M","shopby","t48/screens.csv:103","MALL-INQUIRY 기업인쇄 상담 접수(STD-CLM-019)·디자인 상담 접수(t48/screens.csv:104 STD-CLM-020)만 실재 — 대량견적 전용 접수·회신 행 0"),
"STD-B2B-011": ("M","shopby","t50/screens.csv:53","MES-SAL-FrmEstimate 견적서 출력(build/완료·[오픈분모밖])은 오프라인 영업용 — 커머스 B2B 견적서 발행 행 0(재사용 후보)"),
"STD-B2B-012": ("R","shopby","t48/screens.csv:51","SB-ORDER 증빙서류 발급 관리(STD-ADO-024·config/미착수)가 운영자 발행 창구 · 「일괄」 여부는 그 행의 세부로 흡수"),
"STD-B2B-015": ("M","shopby","t48/screens.csv:245","운영자 후불결제 주문관리 행 0(고객측 STD-PAY-010 만 실재) · STD-B2B-005 와 동일 축의 구IA 표기"),
"STD-ADC-001": ("R","shopby","t48/screens.csv:85","SB-MEMBER [구IA#73] 회원관리 (주문내역/정보확인)(STD-ADC-017·config/미확인)"),
"STD-ADC-002": ("M","shopby","t48/screens.csv:87","SB-MEMBER 회원등급 산정·자동 승급(STD-MEM-018)만 실재 — 수동 조정 행 0"),
"STD-ADC-003": ("M","shopby","t48/screens.csv:153","MALL-MY-WITHDRAW 회원탈퇴(STD-MEM-017)는 고객 신청 · SB-MEMBER 5행에 탈퇴회원 관리 행 0"),
"STD-ADC-005": ("R","shopby","t48/screens.csv:82","SB-COUPON [구IA#76] 쿠폰관리 (발행/매칭/사용내역)(STD-PRM-018) + 쿠폰 등록·사용 내역 조회(t48/screens.csv:72 STD-ADC-006) — SB-COUPON 그룹 13행 실측"),
"STD-ADC-007": ("R","shopby","t48/screens.csv:7","SB-BOARD [구IA#64] 공지사항 관리 (등록/수정/html생성)(STD-INF-009) — SB-BOARD 그룹 8행 실측"),
"STD-ADC-008": ("R","shopby","t48/screens.csv:8","SB-BOARD [구IA#65] 자주묻는질문 관리(STD-INF-010)"),
"STD-ADC-009": ("R","shopby","t48/screens.csv:5","SB-BOARD [구IA#69] 상품Q&A (확인/답변)(STD-CLM-024)"),
"STD-ADC-010": ("R","shopby","t48/screens.csv:6","SB-BOARD [구IA#70] 1:1문의 (확인/답변)(STD-CLM-025)"),
"STD-ADC-011": ("R","shopby","t48/screens.csv:9","SB-BOARD [구IA#72] 이용후기관리 (관리자등록/수정)(STD-INF-011) · 「블라인드」 세부는 그 행의 하위"),
"STD-ADC-012": ("R","shopby","t48/screens.csv:3","SB-BOARD [구IA#67] 기업인쇄상담(STD-CLM-022)·[구IA#68] 디자인상담(t48/screens.csv:4 STD-CLM-023) — 대량견적 몫만 STD-B2B-010 으로 남음"),
"STD-ADC-013": ("M","shopby","t48/screens.csv:257","MALL-HOME 메인 기획전/배너 영역(STD-CAT-021·integrate/진행)은 고객 화면 — 운영자 배너 등록 행 0"),
"STD-ADC-015": ("R","shopby","t48/screens.csv:2","SB-BOARD [구IA#46] 매장게시판(STD-B2B-014·config/미확인)"),
"STD-ADC-016": ("M","shopby","t48/screens.csv:255","운영자 체험단 모집·신청내역 관리 행 0(고객측 STD-PRM-011 만 실재) · STD-PRM-017 과 동일 기능"),
"STD-FIN-001": ("M","shopby","t48/screens.csv:68","SB-STAT 4행은 [구IA#79~82] 상품통계뿐 — 월별 매출 통계 행 0"),
"STD-FIN-002": ("M","shopby","t48/screens.csv:68","SB-STAT 에 일별/기간별 매출 조회 행 0"),
"STD-FIN-003": ("M","shopby","t48/screens.csv:68","SB-STAT 에 결제수단별 매출 집계 행 0"),
"STD-FIN-004": ("M","shopby","t48/screens.csv:68","[구IA#79~82]는 상품군 4종 통계 화면 — 상품별 판매 통계 행 0"),
"STD-FIN-005": ("M","shopby","t48/screens.csv:68","SB-STAT 에 상품군별 매출 비중 행 0"),
"STD-FIN-006": ("M","shopby","t48/screens.csv:68","SB-STAT 에 회원/비회원 주문 비중 행 0"),
"STD-FIN-008": ("M","shopby","t48/screens.csv:62","SB-CLAIM 환불 실행·정산 반영(STD-ADO-023)은 클레임축 — PG 정산 대사 행 0"),
"STD-FIN-009": ("M","webadmin","t48/screens.csv:93","SB-POINT 3행(수동 지급·구매확정 적립·잔액 이관)만 실재 — 적립금 부채 집계 행 0"),
"STD-FIN-010": ("M","mes","t50/screens.csv:25","MES-MFG-FrmMnfOutsource 외주 관리(STD-MFG-100·build/완료·[오픈분모밖])는 발주 등록 — 정산 엑셀 산출 행 0(재사용 후보)"),
"STD-FIN-011": ("M","shopby","t48/screens.csv:68","SB-COUPON 13행은 발행·보상 정책 — 쿠폰/할인 사용액 집계 행 0"),
"STD-FIN-012": ("M","shopby","t48/screens.csv:68","통계·주문 데이터 엑셀 내보내기 행 0"),
"STD-FIN-013": ("M","shopby","t48/screens.csv:17","SB-PAY 무통장 입금 계좌 등록(STD-PAY-028·config/완료)은 쇼핑몰 수납계좌 — B2B 원장용 계좌 등록은 별건·행 0"),
"STD-FIN-014": ("M","shopby","t52/ledger-index.txt","원장 747행 「미수금」 0건 · STD-B2B-007 과 동일 기능의 구IA 표기"),
"STD-FIN-019": ("M","mes","t50/screens.csv:25","굿즈 발주/정산 Excel 다운 행 0(MES 외주 관리와 별건)"),
"STD-FIN-020": ("N","-","t48/shopby-decisions.md:26","화면·기능 없는 외부 회신 대기 안건(보충 4) — 토스 정산한도는 BLK-S3-7 「정산한도·환불계좌 절차」로 이미 선행 입력에 실재"),
"STD-FIN-021": ("N","-","t48/huni-mall-decisions.md:5","「연동 방식」 결정 안건(보충 4 명시 제외 대상) · MES 이카운트 매출전송(t50/screens.csv:71)은 [오픈분모밖] 기존 자산으로 별도 실재"),
"STD-SYS-001": ("R","webadmin","t49/screens.csv:210","auth_user_admin 관리자 계정 등록·비밀번호·권한 관리(build/완료·plan_row_id=NEW) — NEW→STD-SYS-001 재연결"),
"STD-SYS-002": ("R","webadmin","t49/screens.csv:210","같은 행이 「그룹·개별 permission」을 담당 · MES 측 짝 t50/screens.csv:2~6(권한그룹·메뉴권한 5행)"),
"STD-SYS-003": ("M","webadmin","t52/ledger-index.txt","원장 747행에 관리자 감사로그 행 0(grep 「감사」 = pitstop PS-20·pagebuilder 백업 2건뿐)"),
"STD-SYS-010": ("R","webadmin","t49/screens.csv:224","wapi_presign 원고 단일 업로드 presign(STD-ART-001·integrate/완료) + rt_upload(t49/screens.csv:247·248) + comp_file(t49/screens.csv:265) — 원고 S3 저장소 배선 실재"),
"STD-SYS-011": ("R","edicus","t50/screens.csv:90","edicus 레인 23행(t50/screens.csv:90~112 EDI-01~23)이 편집기 외부 서비스 연동 일체"),
"STD-SYS-025": ("R","webadmin","t49/screens.csv:210","STD-SYS-001 과 같은 행 — [구IA#44] 관리자 등록/관리의 구IA 표기"),
"STD-SYS-028": ("N","-","t48/huni-mall-decisions.md:5","화면 없는 구조·작업범위 결정 안건(보충 4) — webadmin-decisions.md 로 이관 대상"),
"STD-MFG-022": ("M","webadmin","t49/screens.csv:199","13상태 상태머신 정의 행 0(shopby_webhook STD-PAY-031 은 수신구 · PS-25 t50/screens.csv:132 STD-MFG-057 은 한 상태 유지 규칙)"),
"STD-MFG-023": ("M","webadmin","t49/screens.csv:208","wapi_order_register 는 주문번호 단위 저장 — orderProductOptionNo 단위 상태·롤업 행 0"),
"STD-MFG-024": ("M","webadmin","t50/screens.csv:85","MES-ITF-Shopby-04 는 상품 매핑 — handoff_id×orderNo+옵션번호×MES 작업번호 3시스템 매핑 행 0"),
"STD-MFG-025": ("M","mes","t48/screens.csv:66","FR-3(STD-MFG-031)·FR-5(t48/screens.csv:67)·FR-6(t50/screens.csv:128)·FR-7(t48/screens.csv:54)은 실재 — FR-1 수신 행만 0"),
"STD-MFG-026": ("M","webadmin","t48/screens.csv:52","샵바이 측 짝 TO-2 취소 창구 닫기(STD-MFG-027)만 실재 — webadmin 측 cancelable CAS 행 0"),
"STD-MFG-028": ("M","mes","t48/screens.csv:53","샵바이 측 짝 TO-3 배송처리(STD-MFG-029)·송장번호 등록(t48/screens.csv:59 STD-SHP-012)만 실재 — FR-2 수신 행 0"),
"STD-MFG-033": ("M","webadmin","t48/screens.csv:64","SB-CLAIM 판매자 클레임 승인·거부(STD-CLM-013)는 샵바이 화면 — 생산 착수 후 에스컬레이션 분기 행 0"),
"STD-MFG-035": ("M","mes","t52/ledger-index.txt","t50 mes 88행에 취소·재업로드요청·승인거부 버튼 화면 0 — 상대측 회신 대기 중이나 행 자체는 필요"),
"STD-MFG-106": ("M","mes","t50/screens.csv:12","MES-DLV-FrmDelivery 출고 처리(패킹·송장 STD-MFG-111)만 실재 — 1차포장 처리 행 0"),
"STD-MFG-107": ("M","mes","t50/screens.csv:12","박스포장(실사·대형) 처리 행 0"),
"STD-MFG-108": ("M","mes","t50/screens.csv:12","제작번호 바코드 입력→포장완료 상태변경 행 0"),
"STD-MFG-109": ("M","mes","t50/screens.csv:12","전 상품 포장완료 시 제작완료 자동 전환 행 0"),
"STD-MFG-112": ("M","mes","t50/screens.csv:13","송장 출력(RptHJInvoiceFS·STD-MFG-111)만 실재 — 납품명세서(퀵) 출력 행 0"),
"STD-MFG-113": ("M","mes","t50/screens.csv:13","출고명세서(직접방문) 출력 행 0"),
"STD-MFG-115": ("M","mes","t50/screens.csv:16","MES-DLV-FrmDeliveryReadyList 출고대기 목록(STD-MFG-116)은 분모 — 합배송 식별 행 0(재사용 후보)"),
"STD-MFG-117": ("M","mes","t50/screens.csv:38","MES-PRD-FrmMaterial 자재 관리(재고관리여부·적정재고수량)는 생산자재 — 판매 액세서리 재고상품 행 0(재사용 후보)"),
"STD-MFG-118": ("M","mes","t50/screens.csv:73","MES-ITF-DesignFile-ThumbnailCreate(STD-MFG-061)는 생성측 — 제작완료 썸네일 확인 화면 행 0"),
"STD-MFG-119": ("M","mes","t52/ledger-index.txt","t50 mes 88행에 주문복사·재제작 지시 행 0 · 상위 정책은 STD-CLM-015(t48/huni-mall-decisions.md:11) 미결"),
"STD-MFG-120": ("M","mes","t52/ledger-index.txt","전체 재제작+재배송 지시 행 0"),
"STD-MFG-121": ("M","mes","t52/ledger-index.txt","원장 747행 「반송」 0건(grep 실측)"),
"STD-MFG-122": ("M","mes","t48/screens.csv:54","FR-7 주문 메모→샵바이 업무메시지(STD-MFG-034)는 커머스축 — MES 주문 내 정산 메모필드 행 0"),
"STD-MFG-125": ("R","pitstop","t50/screens.csv:129","PS-22 치명 오류 자동 재업로드 요청(알림톡+링크·STD-MFG-054) + PS-30 담당자 발 알림톡 발송(t50/screens.csv:135 STD-MFG-049) — 자동·담당자 발 양쪽 실재"),
"STD-MFG-126": ("M","pitstop","t50/screens.csv:131","PS-24 재업로드 시 회차 증가+자동 재검사(STD-MFG-056)만 실재 — 고객 접수 확인 알림 행 0"),
"STD-MFG-127": ("R","edicus","t50/screens.csv:104","EDI-16 편집기 상품 수정요청·수정완료 왕복(STD-MFG-064·manual/미착수)"),
"STD-MFG-128": ("R","shopby","t48/screens.csv:46","SB-NOTIFY 알림톡 사용여부+템플릿 검수(STD-SYS-035) + 알림 템플릿 설정(t48/screens.csv:42 STD-SYS-006)"),
"STD-MFG-129": ("M","webadmin","t48/screens.csv:42","SB-NOTIFY 11행에 발송 실패 시 SMS/LMS 자동 대체 행 0"),
"BLK-S2-1":    ("N","-","t48/shopby-decisions.md:22","「[선행 입력]」 계열은 t48 이 이미 decisions.md 로 분류한 형식(BLK-S2-2 등) — 화면·기능 없는 선행 입력 확인 안건(보충 4)"),
}
LABEL = {"R": "라우팅 대상 오류", "M": "빠진 일", "N": "불필요"}

src = list(csv.DictReader(open(BASE / 't52/unlisted-input.csv', encoding='utf-8')))
ids = {r['원장행'] for r in src}
missing = [r['원장행'] for r in src if r['원장행'] not in J]
extra = [k for k in J if k not in ids]
if missing or extra:
    sys.exit(f"판정 누락 {missing} / 잉여 {extra}")

with open(BASE / 't52/rejudge.csv', 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f)
    w.writerow(['plan_row_id', '내용', '넘긴곳(t51)', '판정', '정정대상시스템', '근거', '근거 요지'])
    for r in src:
        k, tgt, ev, note = J[r['원장행']]
        w.writerow([r['원장행'], r['내용'], r['넘긴곳'], LABEL[k], tgt, ev, note])

cnt = collections.Counter(J[r['원장행']][0] for r in src)
tgt = collections.Counter(J[r['원장행']][1] for r in src)
print(f"입력 {len(src)}행 / 판정 {sum(cnt.values())}행")
for k in ('M', 'R', 'N'):
    print(f"  {LABEL[k]}: {cnt[k]}")
print("정정대상시스템:", dict(tgt))
print("근거 빈 행:", sum(1 for r in src if not J[r['원장행']][2]))
