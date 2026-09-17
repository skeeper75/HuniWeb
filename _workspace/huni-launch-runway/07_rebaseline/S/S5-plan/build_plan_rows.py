# -*- coding: utf-8 -*-
"""M1 데이터 조립 — plan-rows.csv · decisions-by-step.csv · wait-items.csv 생성.

   입력은 전부 읽기 전용(메인 체크아웃 절대경로 + 워크트리 SPEC).
   [HARD] 추측으로 값을 만들지 않는다 — 규칙은 이 파일 한 곳에 두고, 규칙 밖 조합은 표시해 사람이 본다.
   실행: python3 build_plan_rows.py   (워크트리 S5-plan 디렉터리에서)
"""
import csv
import datetime as dt
import glob
import json
import os
import re
import sys
from collections import Counter

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import stepmap  # noqa: E402

MAIN = '/Users/innojini/Dev/HuniWeb'
WT = os.path.abspath(os.path.join(HERE, *(['..'] * 5)))  # 워크트리 루트
RB = '_workspace/huni-launch-runway/07_rebaseline'
LEDGER = f'{MAIN}/{RB}/R/R2/unified-ledger-v4.csv'
API_DIR = f'{MAIN}/docs/shopby/shopby-api/parsed'
RESEARCH = f'{WT}/.moai/specs/SPEC-LAUNCHPLAN-001/research.md'
ROOTS = [WT, MAIN]  # 증거 경로 해소 순서

NAMES = ['김동학', '서희항', '최숙진', '김용기', '신우진', '지니', '채훈희']


# ───────────────────────── 증거 실재 확인 ─────────────────────────
def resolve(path):
    for r in ROOTS:
        p = os.path.join(r, path)
        if os.path.isfile(p):
            return p
    return None


def check_file_line(ev):
    """`경로:줄` 이 실재하고 줄 번호가 총 줄 수 이하인지."""
    m = re.fullmatch(r'(.+?):(\d+)', ev)
    if not m:
        return False
    p = resolve(m.group(1))
    if not p:
        return False
    with open(p, encoding='utf-8', errors='replace') as f:
        n = sum(1 for _ in f)
    return 1 <= int(m.group(2)) <= n


def line_of(path, pattern):
    """파일에서 정규식이 처음 맞는 줄 번호(1부터). 없으면 예외 — 증거를 짐작으로 적지 않는다."""
    p = resolve(path)
    with open(p, encoding='utf-8') as f:
        for i, ln in enumerate(f, 1):
            if re.search(pattern, ln):
                return i
    raise SystemExit(f'[증거 앵커 없음] {path} ~ {pattern}')


# ───────────────────────── 샵바이 엔드포인트 ─────────────────────────
EPS = set()
for f in glob.glob(f'{API_DIR}/*.endpoints.json'):
    for e in json.load(open(f, encoding='utf-8')):
        EPS.add((os.path.basename(f), e['method'], e['path']))


def ep(file, method, path):
    key = (f'{file}.endpoints.json', method, path)
    if key not in EPS:
        raise SystemExit(f'[엔드포인트 없음] {key}')
    return f'{key[0]} {method} {path}'


# 후니 구현이 부르는 쪽 — (구간 집합, 정규식, 종류, 엔드포인트)
# 구간 제한을 두는 이유: 생산·위젯 행의 「주문」「결제」 같은 낱말이 쇼핑 API 로 오분류되지 않게.
SHOP_STEPS = {'A5', 'B1', 'B4', 'B5', 'B6', 'B7', 'D2', 'D3', 'D4', 'E3'}
SERVER_STEPS = {'A4', 'C1', 'C3', 'C6', 'C7', 'D5', 'E1', 'B5', 'D2'}
NOTIFY = r'메일|알림|SMS|알림톡|발송'   # 발송·알림 행은 쇼핑 API 가 아니다(셀러어드민 알림 설정 또는 자체 발송)
HUNI_API_RULES = [
    # (구간 집합, 포함 규칙, 제외 규칙, 종류, 엔드포인트)
    (SHOP_STEPS, r'장바구니|/cart|카트', NOTIFY, 'shop-api', ('order-shop-public', 'GET', '/cart')),
    ({'B6', 'D4'}, r'현금영수증', None, 'shop-api', ('order-shop-public', 'POST', '/profile/orders/{orderNo}/cashReceipt')),
    ({'D4'}, r'거래명세|증빙|영수증', r'결정|여부', 'shop-api', ('order-shop-public', 'GET', '/profile/orders/{orderNo}/specifications')),
    ({'B6'}, r'주문서|결제|payType|무통장|NCPPay', r'후불|B2B|' + NOTIFY, 'shop-api', ('order-shop-public', 'POST', '/payments/reserve')),
    ({'D2', 'B6'}, r'배송지', None, 'shop-api', ('order-shop-public', 'GET', '/profile/shipping-addresses')),
    ({'D3', 'D2'}, r'취소|반품|교환|클레임', r'관리|처리|목록|' + NOTIFY, 'shop-api', ('claim-shop-public', 'POST', '/profile/claims/cancel')),
    ({'D3', 'A5'}, r'Q&A|상품문의|상품 문의', r'답변', 'shop-api', ('display-shop-public', 'POST', '/products/{productNo}/inquiries')),
    ({'D3', 'D2'}, r'1:1', r'답변|확인', 'shop-api', ('manage-shop-public', 'POST', '/inquiries')),
    ({'D2', 'A5'}, r'리뷰|후기', r'관리|' + NOTIFY, 'shop-api', ('display-shop-public', 'POST', '/products/{productNo}/product-reviews')),
    ({'D2', 'B6'}, r'쿠폰', r'등록내역|관리|발행|' + NOTIFY, 'shop-api', ('promotion-shop-public', 'GET', '/coupons/issuable')),
    ({'A5', 'D3', 'E3'}, r'공지|게시판|FAQ|새소식', r'관리|매장', 'shop-api', ('manage-shop-public', 'GET', '/boards/{boardNo}/articles')),
    ({'E3', 'B5'}, r'약관', r'관리', 'shop-api', ('manage-shop-public', 'GET', '/terms')),
    ({'B5'}, r'아이디 찾기|비밀번호 찾기|계정 찾기', NOTIFY, 'shop-api', ('member-shop-public', 'POST', '/profile/find-id')),
    ({'D2', 'B7'}, r'주문조회|주문 조회|주문내역|주문 내역|주문 상세', NOTIFY, 'shop-api', ('order-shop-public', 'GET', '/profile/orders')),
    ({'D2', 'B1'}, r'위시|찜|좋아요', None, 'shop-api', ('order-shop-public', 'GET', '/wish')),
    ({'B1', 'A5'}, r'카테고리|메가메뉴|GNB', r'랜딩', 'shop-api', ('display-shop-public', 'GET', '/categories')),
    ({'B1'}, r'검색', None, 'shop-api', ('product-shop-public', 'GET', '/products/search')),
    ({'A5', 'B1'}, r'배너|기획전|팝업', r'관리', 'shop-api', ('display-shop-public', 'GET', '/display/banners/{bannerSectionCodes}')),
    ({'B5'}, r'회원가입|가입 폼|가입 화면|프로필|회원정보 수정', NOTIFY, 'shop-api', ('member-shop-public', 'POST', '/profile')),
    ({'D2'}, r'적립금 조회|적립금 내역', None, 'shop-api', ('manage-shop-public', 'GET', '/profile/accumulations')),
    ({'B1', 'A5'}, r'상품 상세|상세페이지|상품 목록|시작가', r'관리|등록', 'shop-api', ('product-shop-public', 'GET', '/products/{productNo}')),
    ({'C6', 'C7'}, r'송장', None, 'server-api', ('order-server-public', 'PUT', '/orders/update-invoices')),
    ({'C3', 'B6', 'E1'}, r'무통장 입금 확인|입금확인 처리|입금 확인 처리', r'가상계좌|토스', 'server-api', ('order-server-public', 'PUT', '/accounts/orders/confirmation')),
    ({'C6', 'C7'}, r'상품준비중|배송준비중|배송중|샵바이 상태|상태 반영', None, 'server-api', ('order-server-public', 'PUT', '/orders/change-status/by-shipping-no')),
    ({'C3'}, r'웹훅|주문 재확인|TO-1', None, 'server-api', ('order-server-public', 'GET', '/orders/{orderNo}')),
    ({'B5', 'D2'}, r'외부회원|회원 이관|회원 일괄|일괄등록|일괄 등록', None, 'server-api', ('member-server-public', 'POST', '/members/external')),
    ({'D2', 'C7'}, r'이전주문|주문 이관', None, 'server-api', ('order-server-public', 'POST', '/previous-orders')),
    ({'D5', 'D2'}, r'외부포인트|적립금 지급|적립금 차감|잔액 이관|수동 지급', r'결정|확정|주체|정책', 'server-api', ('manage-server-public', 'POST', '/profile/accumulations')),
    ({'B5'}, r'회원등급|등급 산정|등급 승급', None, 'server-api', ('member-server-public', 'PUT', '/profile/grades')),
    ({'A4'}, r'상품 연동|상품 등록|판매가|시작가|전시|판매상태|대표 ?이미지|메인이미지', None, 'server-api', ('product-server-public', 'PATCH', '/products/{productNo}/')),
]

# 셀러어드민 수동 설정 행 — 같은 일을 하는 Server API 가 있으면 「우리 구현이 수동을 택했다」(forced=Y)
ADMIN_API_RULES = [
    (r'1:1 ?문의.*(답변|확인)', ('manage-server-public', 'POST', '/inquiries/{inquiryNo}/answer')),
    (r'상품 ?Q&A.*(답변|확인)|상품 ?문의.*답변', ('display-server-public', 'POST', '/inquiry/{inquiryNo}/reply')),
    (r'주문상태 ?변경', ('order-server-public', 'PUT', '/orders/change-status/by-shipping-no')),
    (r'주문관리', ('order-server-public', 'GET', '/orders/{orderNo}')),
    (r'회원관리', ('member-server-public', 'GET', '/members')),
    (r'상품통계', ('order-friends-server-public', 'GET', '/statistics/sales/product')),
    (r'쿠폰.*(사용|등록)내역|쿠폰.*내역', ('promotion-server-public', 'GET', '/coupons/use')),
    (r'배송비', ('delivery-server-public', 'POST', '/deliveries/template-groups')),
    (r'쿠폰', ('promotion-server-public', 'POST', '/coupons')),
    (r'배너|기획전', ('display-server-public', 'POST', '/banners')),
    (r'회원 ?그룹|회원등급|등급', ('member-server-public', 'POST', '/member-groups')),
    (r'간편 ?가입|소셜|open-?id', ('member-server-public', 'PATCH', '/configurations/member/open-id/{providerType}')),
    (r'적립금 ?(지급|차감)', ('manage-server-public', 'POST', '/profile/accumulations')),
    (r'1:1 ?문의 ?유형|문의 유형', ('manage-server-public', 'POST', '/inquiries/types')),
    (r'상품 ?등록|상품정보|판매상태|전시상태', ('product-server-public', 'POST', '/products/')),
    (r'입출고 주소|반품지|출고지', ('delivery-server-public', 'POST', '/warehouses')),
]

NONE_EV = '샵바이 비경유'

# 외부 대기 행의 회신 요청 대상(바깥 기관) — [HARD] 원천에 적힌 이름만 쓴다(리드 판정 260917).
# 원천에 대상이 없거나 원천끼리 충돌하면 「회신 요청 대상 미확정」으로 둔다 — 키워드로 기관을 지어내지 않는다.
S3M_ = f'{RB}/S/S3-migration/migration-status.md'
S2F_ = f'{RB}/S/S2-pipeline/findings.md'
RES_ = '.moai/specs/SPEC-LAUNCHPLAN-001/research.md'
RUNBOOK_ = f'{RB}/S/S4-infra/migration-plan.md'
UNRESOLVED = '외부(회신 요청 대상 미확정)'
WAIT_BASIS = {
    # 원장 담당 칸이 우리 쪽 챙기는 사람인 12행
    'STD-PAY-001': ('외부(이니시스)', '원장 담당실명 「이니시스(확인 신우진·최숙진 실장)」 · 확인처 「이니시스」'),
    'STD-PAY-007': ('외부(NHN커머스)', f'원장 비고 「엔터프라이즈 플랜 확인(V9) 필요」 · {S3M_}:58 「Shopby 엔터프라이즈 플랜·외부포인트 정식 적용(V9) → NHN 1:1 세팅」'),
    'STD-PAY-008': ('외부(NHN커머스 · 이니시스)', '원장 선행의존 「STD-PAY-007;STD-PAY-001」 — 두 선행 행의 대상'),
    'STD-PAY-011': ('외부(이니시스)', '원장 선행의존 「EXT-PG」 · 같은 EXT-PG 행 STD-PAY-001 확인처 「이니시스」'),
    'STD-MEM-020': ('외부(구 사이트 운영사/IDC)', f'원장 선행의존 「EXT-OLDDB」 · {S3M_}:49 「ⓔ 구 사이트 운영사/IDC 협조」'),
    'STD-MYP-007': (UNRESOLVED, '원천 충돌 — 원장 선행의존 「EXT-PG」(이니시스) vs 9/15 회의 확정 「충전 = 토스페이먼츠 가상계좌」(STD-MYP-028)'),
    'STD-MYP-009': ('외부(구 사이트 운영사/IDC)', f'원장 선행의존 「EXT-OLDDB」 · {S3M_}:65 「구 사이트 운영사/IDC(C-1-2·C-2-4)」'),
    'STD-MYP-026': ('외부(구 사이트 운영측)', '원장 확인처 「구 사이트 운영측」'),
    'STD-MYP-028': ('외부(토스페이먼츠)', f'원장 기능 「토스페이먼츠 가상계좌 API 직접 발급」 · {RES_}:331 「토스 계약 4건 회신」'),
    'STD-FIN-008': ('외부(이니시스)', '원장 선행의존 「EXT-PG」 · 같은 EXT-PG 행 STD-PAY-001 확인처 「이니시스」'),
    'STD-SYS-004': ('외부(이니시스)', '원장 선행의존 「EXT-PG」 · 같은 EXT-PG 행 STD-PAY-001 확인처 「이니시스」'),
    'STD-SYS-039': ('외부(NHN)', '원장 비고 「앱 개발자센터 또는 NHN 1:1 문의로 확인」'),
    # 원장 담당 칸이 「상대측 회신 대기」인 행 — 선행의존 EXT-MES
    **{k: ('외부(MES 담당)', f'원장 선행의존 「EXT-MES」 · {S2F_}:53 D-P6 결정자 「MES 담당」')
       for k in ('STD-MFG-035', 'STD-MFG-059', 'STD-MFG-060', 'STD-MFG-061', 'STD-MFG-090')},
    # 차단 입력(research §4) — 행 문구 또는 짝 원천에 이름이 있는 것만
    'BLK-S2-3': ('외부(MES 담당)', f'{RES_}:316 「MES WCF 스펙」 · {S2F_}:53 D-P6 결정자 「MES 담당」'),
    'BLK-S2-4': (UNRESOLVED, f'{RES_}:317 「PitStop 구매 진행 상태」 — 회신할 상대 이름이 원천에 없다'),
    'BLK-S3-1': ('외부(구 사이트 운영사/IDC)', f'{RES_}:325 · {S3M_}:49 「ⓔ 구 사이트 운영사/IDC 협조」'),
    'BLK-S3-5': ('외부(NHN커머스)', f'{RES_}:329 「NHN 1:1 세팅 주체」 · 원장 STD-MYP-027 담당실명 「샵바이(NHN커머스)」'),
    'BLK-S3-7': ('외부(토스페이먼츠)', f'{RES_}:331 「토스 계약 4건 회신」'),
    'BLK-S3-10': ('외부(구 사이트 운영사/IDC)', f'{RES_}:334 「구 사이트 충전·사용·가입 중단 가능 여부」 · {S3M_}:65'),
    'BLK-S4-6': (UNRESOLVED, f'{RES_}:345 「Vercel 프로젝트 접근」 — 접근 권한을 가진 상대 이름이 원천에 없다'),
    'BLK-S4-7': ('외부(Cloudflare DNS 관리 권한자)', f'{RES_}:346 「DNS 관리 권한자(Cloudflare …)」'),
    'BLK-S4-10': ('외부(소셜 3사 콘솔 권한자)', f'{RES_}:349 「소셜 3사 콘솔 권한자」'),
    'T6-2': ('외부(NHN커머스)', f'{S3M_}:58 「Shopby 엔터프라이즈 플랜 … NHN 1:1 세팅」 · 원장 STD-MYP-027 담당실명 「샵바이(NHN커머스)」'),
    'T6-3': ('외부(토스페이먼츠)', f'{RES_}:331 「토스 계약 4건 회신」'),
}
for _k in ('BLK-S4-1', 'BLK-S4-2', 'BLK-S4-3', 'BLK-S4-4', 'BLK-S4-5'):
    WAIT_BASIS[_k] = ('외부(인프라팀)', f'research §4-4 {_k[4:]} 행 → S4 런북 담당 「인프라」 · {RUNBOOK_}:34 「인프라=인프라팀」')


def wait_target(d):
    """→ (대상, 근거). 원장에 벤더 이름이 담당실명으로 적힌 행은 그 이름, 런북 인프라 행은 런북 약어표."""
    if d['data_owner'] != 'ext':
        return '', ''
    if d['row_id'] in WAIT_BASIS:
        return WAIT_BASIS[d['row_id']]
    if d['source'] == 'S4-infra':
        return '외부(인프라팀)', f'{d["evidence"]} 담당 「인프라」 · {RUNBOOK_}:34 「인프라=인프라팀」'
    if d['source'] == 'ledger-v4' and d['owner_name'].startswith('외부('):
        return d['owner_name'], f'원장 담당실명 「{d["owner_name"][3:-1]}」'
    return UNRESOLVED, '원천에서 회신 상대 이름을 찾지 못했다'

# 사람 판정(run 레인 · 2026-09-17 · api-path 분류 전건 열람 후) — row_id: (owner, work, api_path, 엔드포인트|None, forced, 사유)
REVIEW = {
    # 셀러어드민 설정인데 규칙이 후니 개발로 본 행
    'STD-PAY-027': ('nhn', 'config', 'admin-manual', None, 'N', '결제수단 노출설정은 셀러어드민 화면 설정'),
    'STD-PAY-028': ('nhn', 'config', 'admin-manual', None, 'N', '무통장 입금 계좌 등록은 셀러어드민 설정'),
    'STD-PAY-029': ('nhn', 'config', 'admin-manual', None, 'N', '미입금 자동취소 기간은 셀러어드민 주문 설정'),
    'STD-PAY-030': ('nhn', 'config', 'admin-manual', None, 'N', '거래명세서 출력항목은 셀러어드민 설정'),
    'STD-PRM-002': ('nhn', 'config', 'admin-manual', None, 'N', '리뷰 작성 보상은 셀러어드민 리뷰 적립 설정'),
    'STD-PRM-005': ('nhn', 'config', 'admin-manual', None, 'N', '쿠폰 동시사용 제한은 셀러어드민 쿠폰 설정'),
    'STD-PRM-008': ('nhn', 'config', 'admin-manual', None, 'N', '리뷰 삭제 시 보상 회수는 셀러어드민 적립 설정'),
    'STD-PRM-009': ('nhn', 'config', 'admin-manual', None, 'N', '사진 리뷰 추가 보상은 셀러어드민 적립 설정'),
    'STD-ADO-024': ('nhn', 'config', 'admin-manual', None, 'N', '증빙서류 발급 관리는 셀러어드민 화면'),
    'STD-ADC-006': ('nhn', 'config', 'admin-manual', ('promotion-server-public', 'GET', '/coupons/use'), 'Y', '운영자 쿠폰 내역 조회'),
    'STD-MYP-025': ('nhn', 'config', 'admin-manual', None, 'N', '적립 정책(소멸기한 등)은 셀러어드민 적립금 설정 — 설정용 Server API 없음'),
    # 결정·정책 행 — API 경로 대상 아님
    'T5-4': (None, None, 'none', None, '', '결정 행'),
    'BLK-S1-3': (None, None, 'none', None, '', '결정 행'), 'BLK-S1-4': (None, None, 'none', None, '', '결정 행'),
    'BLK-S1-6': (None, None, 'none', None, '', '결정 행'),
    'STD-MYP-022': (None, None, 'none', None, '', '개발 주체 결정 행'), 'STD-MYP-024': (None, None, 'none', None, '', '담당 확정 행'),
    'STD-MYP-051': (None, None, 'none', None, '', '원장 소유 결정 행'), 'STD-MYP-037': (None, None, 'none', None, '', '증빙 규칙 정책 행'),
    'STD-MYP-038': (None, None, 'none', None, '', '세무 판단 행'), 'STD-PAY-021': (None, None, 'none', None, '', '회계 분리 정책 행'),
    'STD-PRM-011': (None, None, 'none', None, '', '원장 결정형 행(체험단)'),
    # 샵바이를 거치지 않는 기능
    'STD-OPT-057': (None, None, 'none', None, '', '규격 가이드 모달 — 위젯 UI'),
    'STD-MYP-030': (None, None, 'none', None, '', '편집 보관함 — Edicus'), 'STD-MYP-032': (None, None, 'none', None, '', '편집 이탈 안내 — Edicus'),
    'STD-MFG-111': (None, None, 'none', None, '', '송장 출력(택배사 라벨) — 샵바이 호출 아님'),
    # 엔드포인트를 더 정확한 것으로
    'T3-3': (None, None, 'shop-api', ('order-shop-public', 'POST', '/order-sheets'), '', '주문서 생성'),
    'STD-ORD-003': (None, None, 'shop-api', ('order-shop-public', 'PUT', '/cart'), '', ''),
    'STD-ORD-004': (None, None, 'shop-api', ('order-shop-public', 'DELETE', '/cart'), '', ''),
    'STD-ORD-007': (None, None, 'shop-api', ('order-shop-public', 'POST', '/guest/cart'), '', ''),
    'STD-ORD-009': (None, None, 'shop-api', ('order-shop-public', 'POST', '/order-sheets'), '', ''),
    'STD-ORD-010': (None, None, 'shop-api', ('order-shop-public', 'GET', '/order-sheets/{orderSheetNo}'), '', ''),
    'STD-ORD-011': (None, None, 'shop-api', ('order-shop-public', 'POST', '/order-sheets/{orderSheetNo}/calculate'), '', ''),
    'STD-ORD-013': (None, None, 'shop-api', ('manage-shop-public', 'GET', '/addresses/search'), '', ''),
    'STD-ORD-015': (None, None, 'shop-api', ('order-shop-public', 'GET', '/later-input/order'), '', ''),
    'STD-ORD-022': (None, None, 'shop-api', ('order-shop-public', 'GET', '/guest/orders/{orderNo}'), '', ''),
    'STD-MYP-017': (None, None, 'shop-api', ('order-shop-public', 'GET', '/profile/orders/summary/status'), '', ''),
    'STD-MYP-002': (None, None, 'shop-api', ('order-shop-public', 'GET', '/profile/orders/{orderNo}'), '', ''),
}


def apply_review(d):
    rv = REVIEW.get(d['row_id'])
    if not rv:
        return d
    own, wk, path, e, forced, why = rv
    if own:
        d['data_owner'], d['data_work'] = own, wk
    d['api_path'], d['forced_by_impl'] = path, forced
    if e:
        d['api_evidence'] = ep(*e) + (' (Server API 있음 → 수동은 우리 선택)' if path == 'admin-manual' else '')
    elif path == 'admin-manual':
        d['api_evidence'] = '해당 엔드포인트 없음 (셀러어드민 화면으로만 제공)'
    elif path == 'none':
        d['api_evidence'] = NONE_EV
    d['api_basis'] = '사람 판정 260917' + (f' — {why}' if why else '')
    return d


def classify_api(owner, step, text):
    """→ (api_path, api_evidence, forced_by_impl, api_basis). text = 기능명(+확인처) 만 — 근거 문장은 낱말 오염이 커서 쓰지 않는다."""
    if owner == 'nhn':
        for rx, e in ADMIN_API_RULES:
            if re.search(rx, text):
                return 'admin-manual', ep(*e) + ' (Server API 있음 → 수동은 우리 선택)', 'Y', f'nhn+규칙 /{rx}/'
        return 'admin-manual', '해당 엔드포인트 없음 (셀러어드민 화면으로만 제공)', 'N', 'nhn · Server API 대응 규칙 없음'
    if owner == 'ext':
        return 'none', NONE_EV + '(외부 벤더 대기)', '', 'ext'
    for steps, rx, ex, kind, e in HUNI_API_RULES:
        if step in steps and re.search(rx, text) and not (ex and re.search(ex, text)):
            return kind, ep(*e), '', f'{step}∈구간집합 · 규칙 /{rx}/'
    return 'none', NONE_EV, '', f'{step} · 매칭 규칙 없음'


# ───────────────────────── 원장 행 → 소유·분류·상태 ─────────────────────────
ALLOWED_HOSTS = ('huniprinting.co.kr', 'printly.co.kr', 'shopby.co.kr')
URL_RX = re.compile(r'(https?://[^\s·,)]+)')
DATE_RX = re.compile(r'(\d{4}-\d{2}-\d{2})(?:\s+(\d{2}:\d{2}))?')


def url_evidence(basis, measured):
    """상태근거에서 허용 호스트 URL + 일시를 뽑아 `URL@YYYY-MM-DD HH:MM`. 못 뽑으면 None."""
    m = URL_RX.search(basis or '')
    if not m:
        return None
    url = m.group(1)
    host = re.sub(r'^https?://', '', url).split('/')[0]
    if not any(host == h or host.endswith('.' + h) for h in ALLOWED_HOSTS):
        return None
    tail = basis[m.end():]
    d = DATE_RX.search(tail.split('@', 1)[1]) if '@' in tail else None
    d = d or DATE_RX.search(measured or '')
    if not d:
        return None
    return f'{url}@{d.group(1)}' + (f' {d.group(2)}' if d.group(2) else '')


def owner_work(r):
    text = ' '.join([r['기능'], r['확인처']])
    name = r['담당실명']
    ext_vendor = re.search(r'이니시스|카카오페이|네이버페이|토스페이먼츠|NHN커머스|상대측|구 사이트 운영', name)
    if r['담당역할'] == '외부' or r['오픈차단여부'] == '차단(외부)' or ext_vendor:
        return 'ext', 'wait'
    if re.search(r'셀러어드민|샵바이 어드민|샵바이 관리자', text) and r['분류'] in ('설정', '검증', '이슈'):
        return 'nhn', 'config'
    return 'huni', 'config' if r['분류'] == '설정' else 'dev'


def status_of(r):
    s = r['상태']
    if s == 'done':
        ev = url_evidence(r['상태근거'], r['실측일시'])
        if ev and ev.split('@', 1)[1][:10] >= '2026-09-16':
            return '작동', ev
        return '구현-미검증', r['근거'] or r['상태근거']
    return {'partial': '부분', 'todo': '미착수', 'new': '미착수', '미판정': '미실측'}[s], r['근거'] or r['상태근거']


def pick_name(raw):
    """원장 담당실명에서 첫 실명 하나. 실명 없으면 외부(<대상>) 또는 원문."""
    hits = sorted((raw.find(n), n) for n in NAMES if n in raw)
    if hits:
        return hits[0][1]
    return f'외부({raw})' if raw and raw not in ('미정',) else '미정'


# ───────────────────────── T1 런북 행 (S4-infra) ─────────────────────────
RUNBOOK = f'{RB}/S/S4-infra/migration-plan.md'
ROLE_NAME = {'인쇄개발': '서희항', '쇼핑개발': '김동학', '운영': '최숙진', 'PM': '신우진'}


def runbook_rows():
    out = []
    p = resolve(RUNBOOK)
    with open(p, encoding='utf-8') as f:
        for i, ln in enumerate(f, 1):
            m = re.match(r'\| (F[1-4]-\d+) \| (.+?) \| (.*?) \| (.*?) \| (.*?) \| (.*?) \| (.*?) \|$', ln)
            if not m:
                continue
            sid, step_txt, who, pre, done, rollback, risk = m.groups()
            if step_txt.startswith('(='):   # F3-2·F3-3 은 F2-4·F2-3 의 별칭
                continue
            roles = [x.strip() for x in re.split(r'[·+]', re.sub(r'\(.*?\)', '', who)) if x.strip()]
            if roles and all(x == '인프라' for x in roles):
                owner, work, name = 'ext', 'wait', '외부(인프라팀)'
            else:
                owner, work = 'huni', 'dev'
                name = next((ROLE_NAME[x] for x in roles if x in ROLE_NAME), '외부(인프라팀)')
                if name.startswith('외부'):
                    owner, work = 'ext', 'wait'
            text = step_txt + ' ' + done
            if re.search(r'샵바이 콘솔|웹훅 수신 URL', text):
                api = ('admin-manual', '해당 엔드포인트 없음 (셀러어드민 화면으로만 제공)', 'N', '런북 · 샵바이 콘솔 조작')
            else:
                api = ('none', NONE_EV, '', '런북 · 인프라 단계')
            irreversible = 'Y' if sid in ('F3-11', 'F4-8') else ''
            out.append(dict(
                row_id=sid, data_role='detail', track='T1', step=sid.split('-')[0],
                title=re.sub(r'\*\*', '', step_txt)[:160], std_ids='NEW',
                owner_name=name, target_date='', evidence=f'{RUNBOOK}:{i}',
                check_method=re.sub(r'\*\*', '', done), prereq=pre or '—', status='미착수',
                data_owner=owner, data_work=work, api_path=api[0], api_evidence=api[1],
                forced_by_impl=api[2], api_basis=api[3], irreversible=irreversible,
                note=('NEW 사유: 원장은 기능 원장이라 인프라 이전 단계 행이 없다 · 원천 = S4 런북'),
                source='S4-infra'))
    return out


# ───────────────────────── 차단 입력 (research.md §4) ─────────────────────────
# 내부/외부 판정은 사람이 정한 표다 — wait 은 ext 전용(AC-LP-006(e)).
BLOCKED_MAP = {
    # id: (track, step, owner, work, 담당 또는 회신 요청 대상)
    'S1-1': ('T3', 'B5', 'huni', 'config', '지니'),
    'S1-3': ('T3', 'B6', 'huni', 'config', '신우진'),
    'S1-4': ('T5', 'D4', 'huni', 'config', '신우진'),
    'S1-5': ('T4', 'C1', 'huni', 'config', '서희항'),
    'S1-6': ('T3', 'D3', 'huni', 'config', '신우진'),
    'S2-1': ('T4', 'C1', 'huni', 'config', '서희항'),
    'S2-2': ('T4', 'C3', 'nhn', 'config', '최숙진'),
    'S2-3': ('T4', 'C5', 'ext', 'wait', '외부(MES 공급사)'),
    'S2-4': ('T4', 'C4', 'ext', 'wait', '외부(PitStop 공급사)'),
    'S2-5': ('T4', 'C2', 'huni', 'config', '서희항'),
    'S3-1': ('T3', 'B5', 'ext', 'wait', '외부(구 사이트 운영사)'),
    'S3-2': ('T3', 'B5', 'nhn', 'config', '신우진'),
    'S3-3': ('T3', 'B5', 'huni', 'config', '신우진'),
    'S3-5': ('T6', 'D5', 'ext', 'wait', '외부(NHN커머스)'),
    'S3-6': ('T6', 'D5', 'huni', 'config', '채훈희'),
    'S3-7': ('T6', 'D5', 'ext', 'wait', '외부(토스페이먼츠)'),
    'S3-10': ('T6', 'D5', 'ext', 'wait', '외부(구 사이트 운영사)'),
    'S4-1': ('T1', 'F1', 'ext', 'wait', '외부(인프라팀)'),
    'S4-2': ('T1', 'F1', 'ext', 'wait', '외부(인프라팀)'),
    'S4-3': ('T1', 'F2', 'ext', 'wait', '외부(인프라팀)'),
    'S4-4': ('T1', 'F2', 'ext', 'wait', '외부(인프라팀)'),
    'S4-5': ('T1', 'F3', 'ext', 'wait', '외부(인프라팀)'),
    'S4-6': ('T1', 'F4', 'ext', 'wait', '외부(Vercel 계정 소유자)'),
    'S4-7': ('T1', 'F3', 'ext', 'wait', '외부(Cloudflare DNS 권한자)'),
    'S4-9': ('T1', 'F3', 'nhn', 'config', '최숙진'),
    'S4-10': ('T1', 'F4', 'ext', 'wait', '외부(소셜 3사 콘솔 권한자)'),
}


def blocked_rows():
    rel = '.moai/specs/SPEC-LAUNCHPLAN-001/research.md'
    rows, ys = [], []
    with open(RESEARCH, encoding='utf-8') as f:
        for i, ln in enumerate(f, 1):
            m = re.match(r'\| (S[1-4]-\d+) \| (.+)\|\s*(Y|N|해소[^|]*)\s*\|$', ln)
            if not m:
                continue
            sid, mid, flag = m.group(1), m.group(2), m.group(3).strip()
            if flag != 'Y':
                continue
            ys.append(sid)
            cells = [c.strip() for c in mid.split('|')]
            what, why = cells[0], cells[-1]
            if sid not in BLOCKED_MAP:
                raise SystemExit(f'[차단 행 분류 누락] {sid} — BLOCKED_MAP 에 사람이 넣어야 한다')
            tr, st, own, wk, who = BLOCKED_MAP[sid]
            api = classify_api(own, st, what + ' ' + why)
            rows.append(dict(
                row_id=f'BLK-{sid}', data_role='detail', track=tr, step=st,
                title=f'[선행 입력] {what}', std_ids='NEW', owner_name=who, target_date='',
                evidence=f'{rel}:{i}',
                check_method=(f'회신 메일·메신저 기록을 열어 「{what}」 값이 적혀 있는지 조회한다'
                              if own == 'ext' else f'결정·확인 기록 화면을 열어 「{what}」 가 적혀 있는지 조회한다'),
                prereq='—', status='미착수' if own != 'ext' else '대기',
                data_owner=own, data_work=wk, api_path=api[0], api_evidence=api[1],
                forced_by_impl=api[2], api_basis=api[3], irreversible='',
                note=f'NEW 사유: 원장에 소유 행이 없는 입력 대기 · 왜 필요: {why}', source='research§4'))
    unmapped = set(BLOCKED_MAP) - set(ys)
    if unmapped:
        raise SystemExit(f'[분류표에만 있고 원천에 Y 가 아닌 행] {sorted(unmapped)}')
    return rows, ys


# ───────────────────────── 결정 30건 → 구간 ─────────────────────────
DECISIONS = f'{RB}/R/R3/decisions-for-pm.md'
REST = '*나머지*'  # 같은 구간의 다른 최상위 행 filt 에 걸리지 않은 행 전부

# (번호: 구간, 오픈 전 필수?, 메모) — 사람 판단 표. 근거는 결정 문단의 「왜 막나」.
DECISION_STEP = {
    1: ('E4', 'Y', ''), 2: ('E4', 'Y', ''), 3: ('B6', 'Y', ''),
    4: ('C5', 'N', '지니 260917 확정으로 「수동 Plan B 오픈」 전제 폐기 — 결정 종결(CARDS-S §0-A)'),
    5: ('A1', 'N', ''), 6: ('D5', 'Y', '잔액 이관이 오픈 범위라 주체 결정은 오픈 전'),
    7: ('E1', 'Y', ''), 8: ('B5', 'Y', ''), 9: ('E2', 'Y', ''), 10: ('A3', 'Y', ''),
    11: ('E2', 'Y', ''), 12: ('B6', 'N', ''), 13: ('C3', 'Y', ''), 14: ('E1', 'N', ''),
    15: ('E2', 'N', ''), 16: ('E2', 'Y', ''), 17: ('D5', 'N', ''), 18: ('E2', 'Y', ''),
    19: ('E4', 'N', ''), 20: ('A3', 'N', ''),
    21: ('D5', 'Y', '9/15 회의 확정 5 = B′ 쪽(결정 문단 자체 기록) — 설계 문서 미반영이 남은 일'),
    22: ('D4', 'N', ''), 23: ('A4', 'Y', ''), 24: ('D5', 'N', ''), 25: ('B5', 'N', ''),
    26: ('A5', 'N', ''), 27: ('D3', 'N', ''), 28: ('E3', 'Y', ''), 29: ('A4', 'Y', ''), 30: ('E1', 'Y', ''),
}


def decisions():
    p = resolve(DECISIONS)
    out = []
    with open(p, encoding='utf-8') as f:
        lines = f.readlines()
    for i, ln in enumerate(lines, 1):
        m = re.match(r'### (\d+)\. (.+)', ln) or re.match(r'\| (\d+) \| (.+?) \|', ln)
        if not m or int(m.group(1)) > 30:
            continue
        n = int(m.group(1))
        body = ''.join(lines[i:i + 8]) if ln.startswith('###') else ln
        owners = re.findall(r'`(STD-[A-Z]+-\d+)`', body.split('\n### ')[0])
        st, req, memo = DECISION_STEP[n]
        out.append(dict(no=n, title=m.group(2).strip(), step=st, track=stepmap.TRACK[st],
                        open_required=req, std_ids=';'.join(dict.fromkeys(owners)) or '원장 행 없음',
                        evidence=f'{DECISIONS}:{i}', memo=memo))
    got = sorted(d['no'] for d in out)
    if got != list(range(1, 31)):
        raise SystemExit(f'[결정 번호 누락] {got}')
    return out


# ───────────────────────── 최상위 행 (트랙당 3~5) ─────────────────────────
S28 = f'{RB}/S/S5-plan/status-28.csv'
S6 = f'{RB}/S/S6-defects/defect-code-analysis.md'
S2P = f'{RB}/S/S2-pipeline/pipeline-status.csv'
S3M = f'{RB}/S/S3-migration/migration-status.md'
R1D = f'{RB}/R/R1d/findings.md'

# steps = 이 행이 대표하는 구간(원장 detail 행이 여기서 매달린다)
# filt  = 같은 구간을 두 최상위 행이 나눠 가질 때 원장 행을 가르는 정규식(기능 열)
TOP = [
    # T1 — 인프라 이전
    dict(id='T1-1', track='T1', steps=['F1'], title='관리서버(webadmin) Lightsail dev 배포·검증 — F1-1~F1-5',
         owner_name='서희항', owner='huni', work='dev', status='미착수',
         ev=(RUNBOOK, r'^### F1 '), prereq='외부(인프라팀) OIDC 신뢰정책·시크릿 회신',
         check='Lightsail 콘솔을 열어 admin 서비스가 healthy 이고 /healthz 페이지에 접속하면 ok 가 나오는지 조회한다',
         new='원장은 기능 원장이라 인프라 이전 행이 없다(S4 런북이 원천)'),
    dict(id='T1-2', track='T1', steps=['F2'], title='DB 반입(PG 18.6→17) 리허설·본반입·검증 4종·vc_ 분리 — F2-1~F2-4',
         owner_name='서희항', owner='huni', work='dev', status='미착수',
         ev=(RUNBOOK, r'^### F2 '), prereq='외부(인프라팀) SSH 터널·PG 17 인스턴스',
         check='리허설 결과 로그를 열어 검증 4종이 exit 0 이고 행수 지문 목록이 Railway 와 같은지 조회한다',
         new='원장에 행 없음(S4 런북이 원천)'),
    dict(id='T1-3', track='T1', steps=['F3'], title='운영 전환 12단계(F3-11 Railway 종료는 오픈 테스트 통과 전 금지)',
         owner_name='서희항', owner='huni', work='dev', status='미착수',
         ev=(RUNBOOK, r'^### F3 '), prereq='T1-2',
         check='huni-admin.printly.co.kr/healthz 페이지에 접속해 200 을 보고 Railway 콘솔에서 크론이 정지 상태인지 조회한다',
         new='원장에 행 없음(S4 런북이 원천)'),
    dict(id='T1-4', track='T1', steps=['F4', 'E2'], title='스킨 컨테이너화·도메인·소셜 콜백·env 이관(F4-8 Vercel 정지는 오픈 테스트 통과 전 금지) + 로그인 리다이렉트 재검증',
         owner_name='김동학', owner='huni', work='dev', status='미착수',
         ev=(RUNBOOK, r'^### F4 '), prereq='외부(Vercel 계정 소유자) 접근 · 외부(소셜 3사 콘솔 권한자)',
         check='shopby.huniprinting.co.kr 로그인 페이지에 접속해 구글·네이버·카카오 버튼을 각각 눌러 마이페이지 화면으로 돌아오는지 조회한다'),
    # T2 — 상품·가격·위젯
    dict(id='T2-1', track='T2', steps=['A1', 'A2'], title='상품·가격 데이터 충전 — 기본사양가 없음 2건·0원 조합 교정',
         owner_name='최숙진', owner='huni', work='config', status='부분',
         ev=(S28, r'^A2,'), prereq='—',
         check='webadmin 가격 시뮬레이터 화면을 열어 아크릴키링·무선책자를 조회하고 0원 구성요소가 목록에 없는지 확인한다'),
    dict(id='T2-2', track='T2', steps=['A3'], title='위젯 기본값 미지정 교정·재게시',
         owner_name='최숙진', owner='huni', work='config', status='부분',
         ev=(S28, r'^A3,'), prereq='T2-1 · 결정 10(기본값 지정 주체)',
         check='webadmin 위젯빌더 메뉴를 열어 미리보기에서 기본값 상태 가격이 0원이 아닌지 조회하고 게시 목록에 게시됨으로 뜨는지 본다'),
    dict(id='T2-3', track='T2', steps=['A4'], title='샵바이 상품 연동 — 시작가 「10원~」 교정·상품 수 296/291/297 불일치 규명',
         owner_name='서희항', owner='huni', work='dev', status='부분',
         ev=(S28, r'^A4,'), prereq='결정 23·29',
         check='shopby.huniprinting.co.kr 스티커 카테고리 페이지에 접속해 카드 가격이 10원~ 이 아닌 기본사양가로 나오는지 조회한다'),
    dict(id='T2-4', track='T2', steps=['B2', 'B3'], title='위젯 견적·원고 업로드·편집기(Edicus) 경로 검증',
         owner_name='서희항', owner='huni', work='dev', status='부분',
         ev=(S28, r'^B3,'), prereq='T3-1(담기 결함)',
         check='하드커버링책자 상품 페이지에 접속해 편집기 버튼을 눌러 저장 후 위젯 화면에 편집 완료가 표시되는지 조회한다'),
    # T3 — 쇼핑몰 주문·결제·회원
    dict(id='T3-1', track='T3', steps=['B4'], filt=None, title='회원 장바구니 인증 결함 수정(서버 프록시 토큰 · D-1) — 결함 1·2·3·5 공통 뿌리',
         owner_name='김동학', owner='huni', work='dev', status='부분',
         ev=(S6, r'^## 0\. '), prereq='서버 로그 「[shop proxy] GET /cart」 1줄(지니)',
         check='로그인 후 상품 페이지에서 장바구니 버튼을 누르고 /cart 페이지에 접속해 담은 항목이 목록에 보이는지 조회한다'),
    dict(id='T3-2', track='T3', steps=['B5'], title='로그인 성공인데 오류 문구·리다이렉트 없음 수정(D-2) + 회원 이관 경로 확정',
         owner_name='김동학', owner='huni', work='dev', status='부분',
         ev=(S6, r'^## 1\. '), prereq='결정 8(테스트 회원 계정) · 외부(구 사이트 운영사) DB 접속',
         check='shopby.huniprinting.co.kr 로그인 페이지에 접속해 정상 계정으로 로그인을 누르면 오류 문구 없이 마이페이지 화면으로 이동하는지 조회한다'),
    dict(id='T3-3', track='T3', steps=['B6', 'B7'], title='주문서·결제 — 결제수단 범위 결정 후 스킨 결제 분기·주문 성립 1건 종단',
         owner_name='김동학', owner='huni', work='dev', status='부분',
         ev=(S28, r'^B6,'), prereq='T3-1 · T5-1(PG 신청·결제수단 노출) · 결정 3',
         check='장바구니에서 주문하기를 눌러 주문서 페이지에 접속하고 무통장 결제로 주문 완료 화면까지 가서 입금계좌가 표시되는지 조회한다'),
    dict(id='T3-4', track='T3', steps=['D2', 'B1', 'A5'], title='마이페이지 배송지 결함·비로그인 노출·홈/목록 더미 정리',
         owner_name='김동학', owner='huni', work='dev', status='부분',
         ev=(S6, r'^## 3\. '), prereq='T3-1',
         check='로그인 후 마이페이지 배송지 메뉴를 열어 「불러올 수 없습니다」 문구 없이 배송지 목록이 조회되는지 본다'),
    dict(id='T3-5', track='T3', steps=['D3'], title='취소·반품·문의 — 범위 결정 후 스킨 버튼·문의 라우트 구현',
         owner_name='신우진', owner='huni', work='config', status='없음',
         ev=(S28, r'^D3,'), prereq='결정 27 · 차단 입력 S1-6',
         check='마이페이지 주문 상세 페이지를 열어 취소 신청 버튼이 보이는지 조회하고 1:1 문의 메뉴가 # 이 아닌 화면으로 열리는지 본다'),
    # T4 — 주문 수신·원고·생산
    dict(id='T4-1', track='T4', steps=['C1'], title='주문 등록 다리 — 스킨이 결제 직후 order/register 를 부르게 배선(부르는 쪽 0건)',
         owner_name='김동학', owner='huni', work='dev', status='부분',
         ev=(S2P, r'^C1,order/register'), prereq='차단 입력 S1-5(order/register 계약) · T3-3',
         check='테스트 주문 후 webadmin 관리자 화면에서 주문 등록 목록을 조회해 방금 주문번호 행이 보이는지 확인한다'),
    dict(id='T4-2', track='T4', steps=['C2', 'C3'], title='원고 승격 실파일 1건 종단 + 웹훅 해석 소비자 구현(입금→PAID 전이)',
         owner_name='서희항', owner='huni', work='dev', status='구현-미검증',
         ev=(S2P, r'^C3,이벤트 해석'), prereq='T4-1 · 결정 13(웹훅 등록 경로)',
         check='webadmin 관리자 화면에서 웹훅 수신 목록을 열어 입금 이벤트 행의 상태가 처리됨으로 조회되는지 본다'),
    dict(id='T4-3', track='T4', steps=['C4'], title='파일 검수 경로 결정·구축 — PitStop 조달 또는 사람 검수(D-P1·D-P2)',
         owner_name='서희항', owner='huni', work='dev', status='없음',
         ev=(S2P, r'^C4,PitStop'), prereq='외부(PitStop 공급사) 견적·라이선스',
         check='webadmin 관리자 메뉴에서 검수 대기 목록 화면을 열어 승격된 주문 파일이 행으로 조회되는지 본다'),
    dict(id='T4-4', track='T4', steps=['C5'], title='접수 화면·주문 상태머신·MES 접수 전송(D-P5·D-P6·D-P7)',
         owner_name='서희항', owner='huni', work='dev', status='없음',
         ev=(S2P, r'^C5,접수'), prereq='T4-3 · 외부(MES 공급사) WCF 스펙',
         check='webadmin 관리자 메뉴에서 접수 화면을 열어 주문을 제작대기로 전환한 뒤 MES 화면에서 작업이 조회되는지 본다'),
    dict(id='T4-5', track='T4', steps=['C6', 'C7'], title='출고·송장 — 셀러어드민 수동 등록 경로 확인 + 생산 상태의 고객 반영 방식 결정',
         owner_name='최숙진', owner='nhn', work='config', status='없음',
         ev=(S28, r'^C6,'), prereq='T4-4',
         check='셀러어드민 배송준비중 주문 메뉴를 열어 송장번호 저장 버튼과 송장 일괄 업로드 화면이 조회되는지 본다'),
    # T5 — 운영 설정·알림·CS·증빙
    dict(id='T5-1', track='T5', steps=['E1'], title='셀러어드민 기초정보 7항목·대표전화/메일 교체·PG 신청·결제수단 노출·운영자 계정',
         owner_name='최숙진', owner='nhn', work='config', status='부분',
         ev=(S28, r'^E1,'), prereq='사업자등록증 기준 번호 확정(지니)',
         check='셀러어드민 기초정보 관리 메뉴를 열어 회사명·사업자등록번호 칸이 채워져 있는지 조회하고 결제수단 설정 화면에서 노출이 사용함인지 본다'),
    dict(id='T5-2', track='T5', steps=['D1'], title='알림 — SMS 사용설정·알림톡 33건 개별 판단 후 켜기·템플릿 카카오 검수',
         owner_name='최숙진', owner='nhn', work='config', status='부분',
         ev=(S28, r'^D1,'), prereq='외부(카카오) 템플릿 검수',
         check='셀러어드민 SMS 관리 메뉴를 열어 사용설정이 사용함인지 조회하고 알림톡 템플릿 목록에 검수 승인 행이 있는지 본다'),
    dict(id='T5-3', track='T5', steps=['E3', 'D4'], title='법정 표기 단일화(사업자번호 206-29-88022 우세)·증빙 화면 목업 제거(D-5)',
         owner_name='김동학', owner='huni', work='dev', status='부분',
         ev=(S6, r'^## 4\. '), prereq='사업자등록증 원본 확인(지니)',
         check='shopby.huniprinting.co.kr 마이페이지 증빙서류발급 페이지에 접속해 가짜 주문 행이 없고 푸터와 같은 사업자번호가 보이는지 조회한다'),
    dict(id='T5-4', track='T5', steps=['D4'], filt=r'현금영수증|세금계산서|발급', title='현금영수증·세금계산서 발급 주체 결정(Shopby / 자체 / 외부)',
         owner_name='신우진', owner='huni', work='config', status='없음',
         ev=(S28, r'^D4,'), prereq='T5-1(PG 신청)',
         check='결정 기록 문서를 열어 발급 주체 결정 문장이 적혀 있는지 조회하고 셀러어드민 현금영수증 설정 화면 상태를 본다'),
    # T6 — 프린팅머니
    dict(id='T6-1', track='T6', steps=['D5'], filt=REST, title='프린팅머니 잔액 이관 — 추출 주체·개발 주체 결정 후 6단계',
         owner_name='채훈희', owner='huni', work='config', status='없음',
         ev=(S3M, r'^## B\. '), prereq='외부(구 사이트 운영사) DB 접속 · 결정 6',
         check='결정 기록 문서를 열어 개발 주체 결정 문장을 조회하고 구 사이트 관리자 화면에서 잔액 추출 파일 목록이 보이는지 본다'),
    dict(id='T6-2', track='T6', steps=['D5'], filt=r'엔터프라이즈|외부포인트|플랜', title='Shopby 엔터프라이즈 플랜·외부포인트 정식 적용 회신',
         owner_name='외부(NHN커머스)', owner='ext', work='wait', status='대기',
         ev=(S3M, r'^## D\. '), prereq='—',
         check='NHN커머스 회신 메일을 열어 외부포인트 적용 가능 여부를 조회하고 셀러어드민 앱 스토어 목록에 외부포인트 앱이 보이는지 본다'),
    dict(id='T6-3', track='T6', steps=['D5'], filt=r'토스|가상계좌|충전', title='토스페이먼츠 계약 4건 회신(면제·수수료·업종 심사·샌드박스)',
         owner_name='외부(토스페이먼츠)', owner='ext', work='wait', status='대기',
         ev=(S3M, r'^### C-2 '), prereq='—',
         check='토스페이먼츠 가맹점 관리자 콘솔에 접속해 심사 상태 화면에서 승인 여부를 조회한다'),
    # T7 — 테스트·리허설·Go/No-Go
    dict(id='T7-1', track='T7', steps=['E4'], title='오픈 테스트 진입 조건 9항을 리허설 체크리스트로 승격',
         owner_name='신우진', owner='huni', work='config', status='미착수',
         ev=(RUNBOOK, r'^## 3\. 오픈 테스트 진입 조건'), prereq='T1-1·T1-2·T1-3·T1-4',
         check='리허설 체크리스트 문서를 열어 9항 각 행의 확인 화면 링크를 눌러 전부 통과로 조회되는지 본다'),
    dict(id='T7-2', track='T7', steps=['E4'], filt=r'시나리오|종단|테스트', title='종단 주문 테스트 — 실주문 1건이 결제→접수→MES→송장→고객 조회까지',
         owner_name='신우진', owner='huni', work='config', status='미착수',
         ev=(S28, r'^E4,'), prereq='T7-1 · T3-3 · T4-4',
         check='테스트 주문번호로 셀러어드민 주문 목록과 마이페이지 주문조회 페이지를 열어 배송중 상태와 송장번호가 양쪽에 조회되는지 본다'),
    dict(id='T7-3', track='T7', steps=['E4'], filt=r'롤백|컷오버|Go', title='Go/No-Go 판정 회의·컷오버·롤백 트리거 확정',
         owner_name='채훈희', owner='huni', work='config', status='미착수',
         ev=(S28, r'^E4,'), prereq='T7-2',
         check='Go/No-Go 회의록 문서 페이지를 열어 네 상태 판정과 결정권자 서명 줄을 조회하고 컷오버 표의 비상조치 칸이 채워졌는지 본다'),
]

EFFORT = {'반일': 0.5, '1일': 1, '2-3일': 2, '1주+': 5}
# 지니 결정 260917: 소요 합산은 원장 분류 ∈ {개발, 수정} 행만. 검증·설정·이슈 행은 체크리스트에 남기되 소요 0.
EFFORT_CLASSES = ('개발', '수정')

# ───────────────────────── 근무일 달력 · 가장 이른 완료일(하한) ─────────────────────────
# 공휴일 원천 = 한국천문연구원 특일정보 getRestDeInfo(data.go.kr 15012690) 응답 원문 저장본.
# [HARD] CARDS-S.md:6 의 근무일 나열은 요일이 틀려 쓰지 않는다(리드 판정 260917).
TODAY = dt.date(2026, 9, 17)
HOLIDAYS = set()
for _y in (2026, 2027):
    _s = open(os.path.join(HERE, f'holidays-kasi-{_y}.xml'), encoding='utf-8').read()
    HOLIDAYS |= {dt.date(int(d[:4]), int(d[4:6]), int(d[6:])) for d in
                 re.findall(r'<isHoliday>Y</isHoliday><locdate>(\d{8})</locdate>', _s)}
WORKDAYS = [TODAY + dt.timedelta(days=i) for i in range(0, 470)]
WORKDAYS = [d for d in WORKDAYS if d.weekday() < 5 and d not in HOLIDAYS and d.year <= 2027]


def schedule(top):
    """가장 이른 완료일(하한).
       행 날짜 = 선행(T 행) 끝 + 자기 소요 — 담당자 경합을 넣지 않는다(넣으면 줄 세운 순서에 따라 날짜가
       바뀌어 「하한」이 아니게 된다). 담당자 직렬 가정은 담당자별 「전부 끝나는 날」에만 적용한다.
       소요 = 원장 작업량구간 하한 합(반일 단위). 외부 대기 = 소요 0 · 회신 시점 미정.
       원장 미완 행 0 인 비외부 행 = 미산정(선행 흐름엔 소요 0 으로 통과)."""
    by_id = {t['row_id']: t for t in top}
    slot_end, done, order = {}, set(), []

    def deps(t):
        return [x for x in re.findall(r'T\d-\d', t['prereq']) if x in by_id]
    pending = list(top)
    while pending:
        ready = [t for t in pending if all(d in done for d in deps(t))]
        if not ready:
            raise SystemExit('[선행 순환] ' + ', '.join(t['row_id'] for t in pending))
        for t in ready:
            order.append(t)
            done.add(t['row_id'])
            pending.remove(t)

    def day(slot):
        idx = max(slot - 1, 0) // 2
        if idx >= len(WORKDAYS):
            raise SystemExit(f'[달력 초과] 슬롯 {slot} — 공휴일 원천 연도를 늘려야 한다')
        return WORKDAYS[idx].isoformat()

    for t in order:
        start = max([slot_end[d] for d in deps(t)] + [0])
        unsized = [d for d in deps(t) if by_id[d]['date_basis'].startswith(('임계경로 미산정', '외부 대기'))]
        if t['data_owner'] == 'ext':
            slot_end[t['row_id']] = start
            t['target_date'] = f'회신 요청 {WORKDAYS[1].isoformat()} · 회신 시점 미정'
            t['date_basis'] = '외부 대기 — 소요 0'
            continue
        if t['open_rows'] == 0:
            slot_end[t['row_id']] = start
            rb = f'런북 단계 수 {t["_runbook_n"]} · ' if t['_runbook_n'] else ''
            t['target_date'] = f'미산정({rb}원장 미완 행 없음)'
            t['date_basis'] = '임계경로 미산정 구간'
            continue
        end = start + int(round(t['effort_lb_days'] * 2))
        slot_end[t['row_id']] = end
        t['target_date'] = day(end)
        extra = f' · 런북 {t["_runbook_n"]}단계 미산정 제외' if t['_runbook_n'] else ''
        extra += f' · 선행 {"·".join(unsized)} 미산정/회신 대기분 0 으로 계산' if unsized else ''
        t['date_basis'] = f'가장 이른 완료일(하한){extra}'

    # 담당자 직렬(가정): 최상위 행들에 매달린 원장 미완 행을 **원장 담당 열의 실명**으로 묶어 이어 붙인다.
    # 최상위 행 담당(결정자)으로 묶으면 개발 행이 결정자에게 잘못 얹힌다. 선행 대기는 넣지 않음(하한 유지).
    lanes, seen = {}, set()
    for t in top:
        for d in t['_todo']:
            if d['row_id'] in seen or d['data_owner'] == 'ext' or d['_class'] not in EFFORT_CLASSES:
                continue
            seen.add(d['row_id'])
            lanes[d['owner_name']] = lanes.get(d['owner_name'], 0) + int(round(EFFORT.get(d['_effort'], 0) * 2))
    return {n: (v / 2, day(v)) for n, v in sorted(lanes.items(), key=lambda kv: -kv[1])}


def main():
    ledger = list(csv.DictReader(open(LEDGER, encoding='utf-8')))
    assert len(ledger) == 654, len(ledger)

    # ── detail: 원장 654
    detail = []
    for r in ledger:
        st = stepmap.step_of(r['대분류'], r['중분류'], r['std_id'])
        if st == 'UNMAPPED':
            raise SystemExit(f'[UNMAPPED] {r["std_id"]}')
        own, wk = owner_work(r)
        status, ev = status_of(r)
        text = ' '.join([r['기능'], r['확인처']])
        api = classify_api(own, st, text)
        detail.append(dict(
            row_id=r['std_id'], data_role='detail', track=stepmap.TRACK[st], step=st,
            title=r['기능'], std_ids=r['std_id'], owner_name=pick_name(r['담당실명']),
            target_date='', evidence=ev, check_method=r['체크방법'], prereq=r['선행의존'] or '—',
            status=status, data_owner=own, data_work=wk, api_path=api[0], api_evidence=api[1],
            forced_by_impl=api[2], api_basis=api[3], irreversible='',
            note=f'분류={r["분류"]} · 오픈차단여부={r["오픈차단여부"]} · 작업량={r["작업량구간"]}'
                 + ('' if r['분류'] in EFFORT_CLASSES else f' · 소요 미합산(분류={r["분류"]})'),
            source='ledger-v4', _state=r['상태'], _block=r['오픈차단여부'], _effort=r['작업량구간'], _class=r['분류']))
    detail += runbook_rows()
    blk, ys = blocked_rows()
    detail += blk

    # ── top
    top = []
    for t in TOP:
        pool = [d for d in detail if d['source'] == 'ledger-v4' and d['step'] in t['steps']]
        if t.get('filt') == REST:
            sib = [o['filt'] for o in TOP if o is not t and o.get('filt') and o['filt'] != REST and set(o['steps']) & set(t['steps'])]
            pool = [d for d in pool if not any(re.search(f, d['title']) for f in sib)]
        elif t.get('filt'):
            pool = [d for d in pool if re.search(t['filt'], d['title'])]
        live = [d for d in pool if d['_block'] != '오픈 무관']
        stds = [d['std_ids'] for d in live]
        todo = [d for d in live if d['_state'] in ('todo', 'new', 'partial', '미판정')]
        path, rx = t['ev']
        ev = f'{path}:{line_of(path, rx)}'
        text = t['title']
        api = classify_api(t['owner'], t['steps'][0], text)
        top.append(dict(
            row_id=t['id'], data_role='top', track=t['track'], step=t['steps'][0],
            title=t['title'], std_ids=';'.join(stds) if stds else 'NEW', owner_name=t['owner_name'],
            target_date='', evidence=ev, check_method=t['check'], prereq=t['prereq'], status=t['status'],
            data_owner=t['owner'], data_work=t['work'], api_path=api[0], api_evidence=api[1],
            forced_by_impl=api[2], api_basis=api[3], irreversible='',
            note=('NEW 사유: ' + (t.get('new') or '원장에 이 할 일로 묶을 미완 행이 없다 — 새 행이 필요하다')) if not stds else ('구간=' + '·'.join(t['steps'])),
            source='top',
            effort_lb_days=sum(EFFORT.get(d['_effort'], 0) for d in todo if d['_class'] in EFFORT_CLASSES),
            week_plus_cnt=sum(d['_effort'] == '1주+' for d in todo if d['_class'] in EFFORT_CLASSES),
            undetermined_cnt=sum(d['_effort'] not in EFFORT for d in todo if d['_class'] in EFFORT_CLASSES),
            nondev_cnt=sum(d['_class'] not in EFFORT_CLASSES for d in todo),
            open_rows=len(todo), _todo=todo, _runbook_n=sum(1 for d in detail if d['source'] == 'S4-infra' and d['step'] in t['steps'])))
    lanes = schedule(top)

    # ── 검사(생성 시점 자기 점검 — 판정은 M4 D3 가 따로 한다)
    errs = []
    per_track = Counter(t['track'] for t in top)
    for tr in [f'T{i}' for i in range(1, 8)]:
        if not 3 <= per_track[tr] <= 5:
            errs.append(f'{tr} 최상위 {per_track[tr]}행')
    std_set = {r['std_id'] for r in ledger}
    for t in top:
        if not check_file_line(t['evidence']):
            errs.append(f'{t["row_id"]} 증거 실재 실패 {t["evidence"]}')
        for s in t['std_ids'].split(';'):
            if s != 'NEW' and s not in std_set:
                errs.append(f'{t["row_id"]} std 없음 {s}')
        if not (t['owner_name'] in NAMES or re.fullmatch(r'외부\(.+\)', t['owner_name'])):
            errs.append(f'{t["row_id"]} 담당 {t["owner_name"]}')
        c = t['check_method']
        if not (re.search(r'열|누르|접속|조회|실행', c) and re.search(r'화면|메뉴|페이지|콘솔|목록', c) and len(c) >= 15):
            errs.append(f'{t["row_id"]} 체크 방법 형식')
    new_top = sum(1 for t in top if t['std_ids'] == 'NEW')
    if new_top > 0.3 * len(top):
        errs.append(f'NEW 최상위 {new_top}/{len(top)} > 30%')
    rows = [apply_review(d) for d in top + detail]
    for d in rows:
        d['wait_target'], d['wait_target_basis'] = wait_target(d)
    unused = set(REVIEW) - {d['row_id'] for d in rows}
    if unused:
        raise SystemExit(f'[판정표에 없는 행] {sorted(unused)}')
    for d in rows:
        if d['data_owner'] in ('nhn', 'ext') and d['data_work'] == 'dev':
            errs.append(f'{d["row_id"]} {d["data_owner"]}×dev')
        if d['data_work'] == 'wait' and d['data_owner'] != 'ext':
            errs.append(f'{d["row_id"]} wait×{d["data_owner"]}')
        if d['status'] == '작동' and not re.search(r'https?://\S+@\d{4}-\d{2}-\d{2}', d['evidence']):
            errs.append(f'{d["row_id"]} 작동인데 URL@일시 없음')
    if errs:
        print('\n'.join('[FAIL] ' + e for e in errs))
        raise SystemExit(1)

    cols = ['row_id', 'data_role', 'track', 'step', 'title', 'std_ids', 'owner_name', 'target_date',
            'effort_lb_days', 'week_plus_cnt', 'undetermined_cnt', 'nondev_cnt', 'open_rows', 'date_basis',
            'evidence', 'check_method', 'prereq', 'status', 'data_owner', 'data_work',
            'api_path', 'api_evidence', 'forced_by_impl', 'api_basis', 'wait_target', 'wait_target_basis', 'irreversible', 'note', 'source']
    with open(os.path.join(HERE, 'plan-rows.csv'), 'w', encoding='utf-8', newline='') as f:
        w = csv.DictWriter(f, fieldnames=cols, extrasaction='ignore')
        w.writeheader()
        w.writerows(rows)
    with open(os.path.join(HERE, 'workdays.csv'), 'w', encoding='utf-8', newline='') as f:
        f.write('workday\n' + '\n'.join(d.isoformat() for d in WORKDAYS[:40]) + '\n')

    dec = decisions()
    with open(os.path.join(HERE, 'decisions-by-step.csv'), 'w', encoding='utf-8', newline='') as f:
        w = csv.DictWriter(f, fieldnames=list(dec[0].keys()))
        w.writeheader()
        w.writerows(dec)

    wait = [d for d in rows if d['data_owner'] == 'ext' and d['data_work'] == 'wait']
    with open(os.path.join(HERE, 'wait-items.csv'), 'w', encoding='utf-8', newline='') as f:
        w = csv.DictWriter(f, fieldnames=['row_id', 'data_role', 'track', 'step', 'title', 'wait_target', 'wait_target_basis', 'owner_name', 'evidence', 'source'], extrasaction='ignore')
        w.writeheader()
        w.writerows({k: d[k] for k in w.fieldnames} for d in wait)

    # ── 요약 출력(증거로 progress.md 에 옮긴다)
    print(f'행 {len(rows)} = 최상위 {len(top)} + detail {len(detail)} '
          f'(원장 654 + 런북 {sum(d["source"] == "S4-infra" for d in detail)} + 차단입력 {len(blk)})')
    print('트랙별 최상위:', dict(sorted(per_track.items())), f'· NEW 최상위 {new_top}/{len(top)}')
    print('차단 Y(research §4 표 직접 집계):', len(ys), Counter(y.split('-')[0] for y in ys))
    print('상태:', dict(Counter(d['status'] for d in rows)))
    print('소유×분류:', dict(Counter((d['data_owner'], d['data_work']) for d in rows)))
    print('api-path:', dict(Counter(d['api_path'] for d in rows)))
    am = [d for d in rows if d['api_path'] == 'admin-manual']
    print('admin-manual forced_by_impl:', dict(Counter(d['forced_by_impl'] for d in am)))
    print('외부 대기(ext×wait):', len(wait), '· 회신 요청 대상:', dict(Counter(d['wait_target'] for d in wait)))
    for t in top:
        print(f"  {t['row_id']:5} {t['owner_name']:12} 하한 {t['effort_lb_days']:>5}일 · 1주+ {t['week_plus_cnt']} · 미판정 {t['undetermined_cnt']} · 미완 {t['open_rows']}(미합산 {t['nondev_cnt']}) → {t['target_date']} ({t['date_basis']})")
    for n, (d, e) in lanes.items():
        print(f'  담당자 직렬(가정) {n}: 하한 {d}일 → {e}')
    with open(os.path.join(HERE, 'lanes.csv'), 'w', encoding='utf-8', newline='') as f:
        f.write('owner_name,effort_lb_days,serial_end_lb\n' + ''.join(f'{n},{d},{e}\n' for n, (d, e) in lanes.items()))
    print('결정 30 → 구간:', dict(Counter(d['step'] for d in dec)), '· 오픈 전 필수', sum(d['open_required'] == 'Y' for d in dec))


if __name__ == '__main__':
    main()
