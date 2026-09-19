# -*- coding: utf-8 -*-
"""t48 · shopby + huni-mall 화면·기능 원장 조립기.
입력: S5-plan/plan-rows.csv(735행 · 원격 main 산출) + S1-skin/api-wiring.csv(84행 · 메인 체크아웃 미추적)
출력: screens.csv(계약 08_system-screen/CONTRACT.md 헤더 고정)
DB write 0 · 라이브 접속 0 · 숫자 날조 0.
"""
import csv
import os
import sys

BASE = os.path.dirname(os.path.abspath(__file__))
PLAN = os.path.join(BASE, '..', '..', '07_rebaseline', 'S', 'S5-plan', 'plan-rows.csv')
OUT = os.path.join(BASE, 'screens.csv')

# screen_id -> (system, group, screen_name)
SCREENS = {
 # ---- huni-mall (스킨 저장소 huni-skin-shopby) ----
 'MALL-HOME':        ('huni-mall','홈','홈(/)'),
 'MALL-SHOP':        ('huni-mall','상품탐색','카테고리 목록(/shop · /shop/[categoryNo])'),
 'MALL-SEARCH':      ('huni-mall','상품탐색','검색 결과(/search)'),
 'MALL-LANDING':     ('huni-mall','상품탐색','상품군 전용 랜딩(미구현)'),
 'MALL-PDP':         ('huni-mall','상품상세','상품 상세(/product/[slug])'),
 'MALL-CART':        ('huni-mall','장바구니','장바구니(/cart)'),
 'MALL-CHECKOUT':    ('huni-mall','주문·결제','주문서(/checkout · /checkout/[orderSheetNo])'),
 'MALL-ORDERDONE':   ('huni-mall','주문·결제','주문완료(/order-complete · /order-complete/[orderNo])'),
 'MALL-GUESTORDER':  ('huni-mall','주문조회','비회원 주문조회(/guest-order)'),
 'MALL-LOGIN':       ('huni-mall','회원·인증','로그인(/login)'),
 'MALL-SIGNUP':      ('huni-mall','회원·인증','회원가입(/signup)'),
 'MALL-FINDID':      ('huni-mall','회원·인증','아이디·비밀번호 찾기(/find-id)'),
 'MALL-SOCIALJOIN':  ('huni-mall','회원·인증','소셜 추가정보(/social-join)'),
 'MALL-OAUTH':       ('huni-mall','회원·인증','소셜 콜백(/oauth/callback)'),
 'MALL-MYPAGE':      ('huni-mall','마이페이지','마이페이지 메인(/mypage)'),
 'MALL-MY-ORDERS':   ('huni-mall','마이페이지','주문 목록(/mypage/orders)'),
 'MALL-MY-ORDER':    ('huni-mall','마이페이지','주문 상세(/mypage/orders/[orderNo])'),
 'MALL-MY-ADDRESS':  ('huni-mall','마이페이지','배송지 관리(/mypage/address)'),
 'MALL-MY-COUPON':   ('huni-mall','마이페이지','쿠폰(/mypage/coupon · /register)'),
 'MALL-MY-POINT':    ('huni-mall','마이페이지','적립금·프린트머니 잔액(/mypage/point)'),
 'MALL-MY-CHARGE':   ('huni-mall','마이페이지','프린트머니 충전(/mypage/point/charge)'),
 'MALL-MY-MONEY':    ('huni-mall','마이페이지','프린팅머니 화면(/mypage/money)'),
 'MALL-MY-REVIEW':   ('huni-mall','마이페이지','리뷰(/mypage/review · /write · /[reviewId])'),
 'MALL-MY-ACCOUNT':  ('huni-mall','마이페이지','계정정보(/mypage/account)'),
 'MALL-MY-WITHDRAW': ('huni-mall','마이페이지','회원탈퇴(/mypage/withdraw)'),
 'MALL-MY-DOCUMENT': ('huni-mall','마이페이지','증빙서류(/mypage/document)'),
 'MALL-MY-INQUIRY':  ('huni-mall','마이페이지','내 문의·Q&A 조회(미구현)'),
 'MALL-STORAGE':     ('huni-mall','마이페이지','옵션·편집 디자인 보관함(미구현)'),
 'MALL-NOTICE':      ('huni-mall','고객지원','공지사항(/notice · /notice/[articleNo])'),
 'MALL-FAQ':         ('huni-mall','고객지원','자주묻는질문(라우트 부재)'),
 'MALL-QNA':         ('huni-mall','고객지원','상품 Q&A(미구현)'),
 'MALL-INQUIRY':     ('huni-mall','고객지원','1:1·상담 문의(미구현)'),
 'MALL-GUIDE':       ('huni-mall','고객지원','이용가이드(/guide)'),
 'MALL-REVIEWS':     ('huni-mall','고객지원','이용후기 메인(미구현)'),
 'MALL-EVENT':       ('huni-mall','프로모션','체험단(미구현)'),
 'MALL-PROMOTION':   ('huni-mall','프로모션','기획전·할인 이벤트(미구현)'),
 'MALL-COMPANY':     ('huni-mall','정책·정보','회사소개(/company)'),
 'MALL-LOCATION':    ('huni-mall','정책·정보','찾아오시는 길(/location)'),
 'MALL-TERMS':       ('huni-mall','정책·정보','이용약관(/terms)'),
 'MALL-PRIVACY':     ('huni-mall','정책·정보','개인정보처리방침(/privacy)'),
 'MALL-GLOBAL':      ('huni-mall','전역','헤더·푸터·세션 전역 요소'),
 'MALL-ADMIN':       ('huni-mall','전역','관리자 스캐폴드(/admin · 진입 불가)'),
 'MALL-SERVER':      ('huni-mall','서버·배포','스킨 서버 계층(env·프록시·배포·도메인)'),
 'MALL-REPO':        ('huni-mall','서버·배포','스킨 저장소 문서'),
 # ---- shopby (NHN 커머스 SaaS · 셀러어드민 + API + 원장) ----
 'SB-BASIC':      ('shopby','셀러어드민 기초','기초정보 설정(사업자·대표연락처·메일)'),
 'SB-PAY':        ('shopby','셀러어드민 결제','결제수단 설정·PG 신청'),
 'SB-SHIP':       ('shopby','셀러어드민 배송','배송비 정책·배송수단 설정'),
 'SB-PRODUCT':    ('shopby','셀러어드민 상품','상품·전시 카테고리 관리'),
 'SB-ORDER':      ('shopby','셀러어드민 주문','주문 관리·출고·송장'),
 'SB-CLAIM':      ('shopby','셀러어드민 클레임','취소·반품·교환·환불 처리'),
 'SB-MEMBER':     ('shopby','셀러어드민 회원','회원 관리·등급·이관'),
 'SB-COUPON':     ('shopby','셀러어드민 프로모션','쿠폰·리뷰 보상 관리'),
 'SB-BOARD':      ('shopby','셀러어드민 게시판','공지·FAQ·Q&A·1:1·후기 관리'),
 'SB-NOTIFY':     ('shopby','셀러어드민 알림','SMS·알림톡·메일 설정·발송'),
 'SB-STAT':       ('shopby','셀러어드민 통계','상품·매출 통계'),
 'SB-OPER':       ('shopby','셀러어드민 운영','운영자 계정·권한그룹'),
 'SB-SOCIALAPP':  ('shopby','셀러어드민 운영','간편로그인 앱 등록'),
 'SB-WEBHOOK':    ('shopby','연동','웹훅 등록·발신'),
 'SB-POINT':      ('shopby','연동','적립금 원장·외부포인트 연동'),
 'SB-API-SHOP':   ('shopby','연동','Shop API(고객 프런트용)'),
 'SB-NCPPAY':     ('shopby','연동','NCPPay 결제·입금 처리'),
}

CUST, OPER, ADMIN, SYSR = '고객', '운영자(CS·상품)', '관리자', '시스템(무인)'

def link(cp, direction, owner):
    return ('integrate', cp, direction, owner)
SB    = link('shopby',   'huni-mall→shopby',   'huni-mall')
WA    = link('webadmin', 'huni-mall→webadmin', 'huni-mall')
ED    = link('edicus',   'huni-mall→edicus',   'huni-mall')
WA2SB = link('shopby',   'webadmin→shopby',    'webadmin')
SB2WA = link('webadmin', 'shopby→webadmin',    'webadmin')
B = ('build','','','')
C = ('config','','','')
P = ('provided','','','')
M = ('manual','','','')

# row_id -> (screen_id, role) + (work_type, counterpart, direction, owner_side)
MAP = {
# --- A4 / B1 탐색 ---
'STD-CAT-001':('MALL-GLOBAL',CUST)+SB, 'STD-CAT-002':('MALL-SHOP',CUST)+SB,
'STD-CAT-003':('MALL-LANDING',CUST)+B, 'STD-CAT-022':('MALL-SHOP',CUST)+SB,
'STD-CAT-030':('SB-PRODUCT',OPER)+C,   'STD-CAT-043':('MALL-SHOP',CUST)+WA,
'STD-CAT-004':('MALL-SEARCH',CUST)+SB, 'STD-CAT-005':('MALL-SEARCH',CUST)+SB,
'STD-CAT-006':('MALL-GLOBAL',CUST)+SB,
# --- A5 상세·콘텐츠 ---
'STD-CAT-007':('MALL-PDP',CUST)+SB,  'STD-CAT-008':('MALL-PDP',CUST)+B,
'STD-CAT-009':('MALL-PDP',CUST)+B,   'STD-CAT-010':('MALL-PDP',CUST)+B,
'STD-CAT-011':('MALL-PDP',CUST)+B,   'STD-CAT-012':('MALL-PDP',CUST)+B,
'STD-CAT-013':('MALL-QNA',CUST)+SB,  'STD-CAT-014':('MALL-PDP',CUST)+SB,
'STD-CAT-015':('MALL-PDP',CUST)+SB,  'STD-CAT-016':('MALL-PDP',CUST)+B,
'STD-CAT-017':('MALL-GLOBAL',CUST)+B,'STD-CAT-018':('MALL-PDP',CUST)+SB,
'STD-CAT-021':('MALL-HOME',CUST)+SB, 'STD-CAT-027':('MALL-HOME',CUST)+B,
'STD-CAT-029':('MALL-PDP',CUST)+B,   'STD-CAT-034':('MALL-PDP',CUST)+WA,
'STD-CAT-042':('MALL-GLOBAL',CUST)+B,'STD-CAT-019':('MALL-GUIDE',CUST)+B,
'STD-CAT-020':('MALL-GUIDE',CUST)+B,
'STD-INF-005':('MALL-NOTICE',CUST)+SB,'STD-INF-006':('MALL-FAQ',CUST)+SB,
'STD-INF-007':('MALL-GUIDE',CUST)+B,  'STD-INF-009':('SB-BOARD',OPER)+C,
'STD-INF-010':('SB-BOARD',OPER)+C,    'STD-INF-011':('SB-BOARD',OPER)+C,
'STD-INF-012':('MALL-NOTICE',CUST)+B, 'STD-INF-013':('MALL-REPO',ADMIN)+B,
'STD-OPT-057':('MALL-PDP',CUST)+B,    'STD-OPT-058':('MALL-PDP',CUST)+B,
'STD-PRM-010':('MALL-PROMOTION',CUST)+SB, 'STD-PRM-015':('MALL-GLOBAL',CUST)+M,
# --- E3 정보·법정 ---
'STD-INF-001':('MALL-COMPANY',CUST)+B, 'STD-INF-002':('MALL-LOCATION',CUST)+B,
'STD-INF-003':('MALL-TERMS',CUST)+SB,  'STD-INF-004':('MALL-PRIVACY',CUST)+B,
'STD-INF-008':('MALL-GLOBAL',CUST)+B,
# --- B4 장바구니 ---
'STD-ORD-001':('MALL-PDP',CUST)+SB, 'STD-ORD-002':('MALL-CART',CUST)+SB,
'STD-ORD-003':('MALL-CART',CUST)+SB,'STD-ORD-004':('MALL-CART',CUST)+SB,
'STD-ORD-005':('MALL-CART',CUST)+B, 'STD-ORD-006':('MALL-CART',CUST)+SB,
'STD-ORD-007':('MALL-CART',CUST)+B, 'STD-ORD-008':('MALL-CART',CUST)+B,
# --- B6 주문서·결제 ---
'STD-ORD-009':('MALL-CHECKOUT',CUST)+SB,'STD-ORD-010':('MALL-CHECKOUT',CUST)+SB,
'STD-ORD-011':('MALL-CHECKOUT',CUST)+SB,'STD-ORD-012':('MALL-CHECKOUT',CUST)+B,
'STD-ORD-013':('MALL-CHECKOUT',CUST)+SB,'STD-ORD-014':('MALL-CHECKOUT',CUST)+B,
'STD-ORD-015':('MALL-CHECKOUT',CUST)+B, 'STD-ORD-016':('MALL-CHECKOUT',CUST)+B,
'STD-ORD-017':('MALL-CHECKOUT',CUST)+B, 'STD-ORD-018':('MALL-CHECKOUT',CUST)+B,
'STD-ORD-029':('MALL-CHECKOUT',CUST)+WA,'STD-ORD-032':('MALL-CHECKOUT',CUST)+SB,
'STD-PAY-001':('MALL-CHECKOUT',CUST)+SB,'STD-PAY-002':('MALL-CHECKOUT',CUST)+SB,
'STD-PAY-003':('SB-NCPPAY',SYSR)+P,     'STD-PAY-004':('SB-PAY',OPER)+C,
'STD-PAY-005':('SB-PAY',OPER)+C,        'STD-PAY-006':('SB-PAY',OPER)+C,
'STD-PAY-007':('MALL-CHECKOUT',CUST)+SB,'STD-PAY-008':('MALL-CHECKOUT',CUST)+SB,
'STD-PAY-009':('SB-PAY',OPER)+C,        'STD-PAY-010':('MALL-CHECKOUT',CUST)+B,
'STD-PAY-011':('MALL-CHECKOUT',CUST)+SB,'STD-PAY-012':('MALL-ORDERDONE',CUST)+SB,
'STD-PAY-013':('MALL-SERVER',SYSR)+SB,  'STD-PAY-014':('MALL-CHECKOUT',CUST)+SB,
'STD-PAY-019':('SB-PAY',OPER)+M,        'STD-PAY-020':('MALL-CHECKOUT',CUST)+SB,
'STD-PAY-021':('MALL-MY-CHARGE',CUST)+M,'STD-PAY-022':('MALL-MY-CHARGE',ADMIN)+M,
'STD-PAY-023':('MALL-MY-CHARGE',ADMIN)+M,'STD-PAY-024':('SB-PAY',OPER)+M,
'STD-PAY-025':('SB-PAY',OPER)+C,        'STD-PAY-026':('SB-PAY',OPER)+M,
'STD-PAY-027':('SB-PAY',OPER)+C,        'STD-PAY-028':('SB-PAY',OPER)+C,
'STD-PAY-029':('SB-PAY',OPER)+C,        'STD-PAY-031':('MALL-CART',CUST)+SB,
'BLK-S1-3':('MALL-CHECKOUT',ADMIN)+M,
# --- B7 주문 성립 ---
'STD-ORD-019':('MALL-CHECKOUT',CUST)+SB,'STD-ORD-020':('MALL-ORDERDONE',CUST)+SB,
'STD-ORD-021':('MALL-MY-ORDERS',CUST)+SB,'STD-ORD-022':('MALL-GUESTORDER',CUST)+SB,
'STD-ORD-023':('MALL-MY-ORDER',CUST)+SB, 'STD-ORD-024':('MALL-MY-ORDER',CUST)+WA,
'STD-ORD-025':('MALL-MY-ORDER',CUST)+SB, 'STD-ORD-026':('MALL-MY-ORDERS',CUST)+B,
'STD-ORD-028':('MALL-CART',CUST)+B,      'STD-ORD-030':('MALL-SERVER',SYSR)+WA,
'STD-ORD-031':('SB-NOTIFY',SYSR)+P,
# --- C1 주문 등록 다리 ---
'BLK-S1-5':('MALL-SERVER',ADMIN)+M,
# --- C3 연동·웹훅 ---
'STD-SYS-007':('MALL-SERVER',SYSR)+SB, 'STD-SYS-008':('SB-PRODUCT',SYSR)+WA2SB,
'STD-SYS-009':('MALL-CART',CUST)+SB,   'STD-SYS-012':('MALL-SIGNUP',CUST)+SB,
'STD-SYS-013':('MALL-CHECKOUT',CUST)+SB,'STD-SYS-014':('MALL-MY-ORDER',CUST)+SB,
'STD-SYS-015':('MALL-GLOBAL',ADMIN)+B, 'STD-SYS-023':('MALL-CART',SYSR)+SB,
'STD-SYS-029':('SB-NOTIFY',OPER)+C,    'STD-SYS-030':('SB-NOTIFY',OPER)+C,
'STD-SYS-039':('SB-WEBHOOK',ADMIN)+C,  'STD-SYS-041':('SB-PRODUCT',ADMIN)+C,
'STD-SYS-045':('MALL-SERVER',SYSR)+WA, 'STD-SYS-049':('MALL-SERVER',SYSR)+WA,
'BLK-S2-2':('SB-WEBHOOK',ADMIN)+C,
# --- E1 셀러어드민 설정 ---
'STD-SHP-001':('SB-SHIP',OPER)+C,'STD-SHP-002':('SB-SHIP',OPER)+C,
'STD-SHP-003':('SB-SHIP',OPER)+C,'STD-SHP-004':('SB-SHIP',OPER)+C,
'STD-SHP-005':('SB-SHIP',OPER)+C,'STD-SHP-006':('SB-SHIP',OPER)+C,
'STD-SHP-007':('SB-SHIP',OPER)+C,'STD-SHP-017':('SB-SHIP',OPER)+C,
'STD-B2B-013':('SB-MEMBER',OPER)+C,'STD-B2B-014':('SB-BOARD',OPER)+C,
'STD-FIN-015':('SB-STAT',OPER)+C,'STD-FIN-016':('SB-STAT',OPER)+C,
'STD-FIN-017':('SB-STAT',OPER)+C,'STD-FIN-018':('SB-STAT',OPER)+C,
'STD-SYS-004':('SB-PAY',ADMIN)+C, 'STD-SYS-005':('SB-SHIP',ADMIN)+C,
'STD-SYS-006':('SB-NOTIFY',OPER)+C,'STD-SYS-034':('SB-NOTIFY',OPER)+C,
'STD-SYS-035':('SB-NOTIFY',OPER)+C,'STD-SYS-037':('SB-BASIC',OPER)+C,
'STD-SYS-038':('SB-OPER',ADMIN)+C, 'STD-SYS-042':('MALL-ADMIN',ADMIN)+B,
'STD-SYS-053':('MALL-SERVER',ADMIN)+B,
# --- E2 도메인·env ---
'STD-SYS-024':('MALL-SERVER',SYSR)+B,'STD-SYS-036':('MALL-SERVER',ADMIN)+B,
'STD-SYS-040':('SB-BASIC',OPER)+C,   'STD-SYS-052':('MALL-SERVER',ADMIN)+B,
# --- D1 알림 ---
'STD-SHP-016':('SB-NOTIFY',SYSR)+P, 'STD-PRM-012':('SB-NOTIFY',OPER)+C,
'STD-PRM-013':('SB-NOTIFY',OPER)+C, 'STD-PRM-014':('MALL-MY-ACCOUNT',CUST)+SB,
'STD-PRM-021':('SB-NOTIFY',OPER)+M, 'STD-ADO-027':('SB-NOTIFY',OPER)+C,
'STD-MFG-130':('SB-NOTIFY',ADMIN)+M,
# --- D2 마이페이지 ---
'STD-MYP-001':('MALL-MY-ORDERS',CUST)+SB,'STD-MYP-002':('MALL-MY-ORDER',CUST)+SB,
'STD-MYP-003':('MALL-MY-ORDER',CUST)+ED, 'STD-MYP-004':('MALL-STORAGE',CUST)+B,
'STD-MYP-005':('MALL-STORAGE',CUST)+B,   'STD-MYP-010':('MALL-MY-COUPON',CUST)+SB,
'STD-MYP-011':('MALL-MY-COUPON',CUST)+SB,'STD-MYP-012':('MALL-MY-REVIEW',CUST)+SB,
'STD-MYP-013':('MALL-MY-INQUIRY',CUST)+SB,'STD-MYP-016':('MALL-MY-ADDRESS',CUST)+SB,
'STD-MYP-017':('MALL-MYPAGE',CUST)+SB,   'STD-MYP-018':('MALL-MYPAGE',CUST)+B,
'STD-MYP-019':('MALL-MYPAGE',CUST)+B,    'STD-MYP-030':('MALL-STORAGE',CUST)+ED,
'STD-MYP-031':('MALL-STORAGE',ADMIN)+M,  'STD-MYP-032':('MALL-STORAGE',OPER)+M,
'STD-MYP-033':('MALL-STORAGE',ADMIN)+M,  'STD-MYP-040':('MALL-MYPAGE',OPER)+M,
'STD-PRM-001':('SB-COUPON',OPER)+C,'STD-PRM-002':('SB-COUPON',OPER)+C,
'STD-PRM-003':('SB-COUPON',OPER)+C,'STD-PRM-004':('SB-COUPON',OPER)+C,
'STD-PRM-005':('SB-COUPON',OPER)+C,'STD-PRM-006':('SB-COUPON',OPER)+C,
'STD-PRM-007':('MALL-CHECKOUT',CUST)+SB,'STD-PRM-008':('SB-COUPON',OPER)+C,
'STD-PRM-009':('SB-COUPON',OPER)+C,'STD-PRM-011':('MALL-EVENT',CUST)+B,
'STD-PRM-016':('MALL-REVIEWS',CUST)+SB,'STD-PRM-018':('SB-COUPON',OPER)+C,
'STD-PRM-019':('SB-COUPON',OPER)+C,'STD-PRM-020':('SB-COUPON',OPER)+C,
'STD-ADC-004':('SB-POINT',SYSR)+WA2SB,'STD-ADC-006':('SB-COUPON',OPER)+C,
'STD-ADC-017':('SB-MEMBER',OPER)+C,
# --- D4 증빙 ---
'STD-PAY-015':('MALL-MY-DOCUMENT',CUST)+SB,'STD-PAY-016':('MALL-MY-DOCUMENT',CUST)+SB,
'STD-PAY-017':('MALL-MY-DOCUMENT',CUST)+B, 'STD-PAY-018':('MALL-MY-DOCUMENT',CUST)+SB,
'STD-PAY-030':('SB-ORDER',OPER)+C,
'STD-MYP-014':('MALL-MY-DOCUMENT',CUST)+SB,'STD-MYP-015':('MALL-MY-DOCUMENT',CUST)+SB,
'STD-MYP-020':('MALL-MY-DOCUMENT',CUST)+B, 'STD-MYP-021':('MALL-MY-DOCUMENT',CUST)+B,
'STD-MYP-034':('MALL-MY-DOCUMENT',CUST)+SB,'STD-MYP-035':('MALL-MY-DOCUMENT',CUST)+SB,
'STD-MYP-036':('MALL-MY-DOCUMENT',CUST)+SB,'STD-MYP-037':('MALL-MY-DOCUMENT',ADMIN)+M,
'STD-MYP-038':('MALL-MY-DOCUMENT',ADMIN)+M,'STD-MYP-039':('MALL-MY-DOCUMENT',OPER)+M,
'STD-ADO-024':('SB-ORDER',OPER)+C,'BLK-S1-4':('MALL-MY-DOCUMENT',ADMIN)+M,
# --- D5 프린트머니 ---
'STD-MYP-006':('MALL-MY-POINT',CUST)+SB,'STD-MYP-007':('MALL-MY-CHARGE',CUST)+SB,
'STD-MYP-008':('SB-POINT',SYSR)+P,      'STD-MYP-009':('SB-POINT',SYSR)+WA2SB,
'STD-MYP-022':('MALL-MY-CHARGE',ADMIN)+M,'STD-MYP-023':('MALL-MY-CHARGE',ADMIN)+M,
'STD-MYP-024':('MALL-MY-CHARGE',ADMIN)+M,'STD-MYP-025':('SB-POINT',OPER)+C,
'STD-MYP-026':('SB-POINT',ADMIN)+M,      'STD-MYP-027':('SB-POINT',ADMIN)+M,
'STD-MYP-041':('MALL-MY-MONEY',OPER)+M,  'STD-MYP-042':('SB-PRODUCT',OPER)+C,
'STD-MYP-044':('MALL-MY-CHARGE',CUST)+WA,'STD-MYP-045':('MALL-CHECKOUT',CUST)+SB,
'STD-MYP-048':('SB-PAY',OPER)+C,         'STD-MYP-049':('MALL-MY-CHARGE',ADMIN)+M,
'STD-MYP-050':('MALL-MY-CHARGE',ADMIN)+M,'STD-MYP-051':('SB-POINT',ADMIN)+M,
'STD-MYP-052':('SB-PAY',ADMIN)+M,        'STD-MYP-053':('SB-API-SHOP',ADMIN)+M,
'STD-MYP-054':('MALL-MYPAGE',ADMIN)+M,
'BLK-S3-5':('SB-POINT',ADMIN)+M,'BLK-S3-6':('MALL-MY-CHARGE',ADMIN)+M,
'BLK-S3-7':('MALL-MY-CHARGE',ADMIN)+M,'BLK-S3-10':('SB-POINT',ADMIN)+M,
# --- B5 회원 ---
'STD-MEM-001':('MALL-SIGNUP',CUST)+SB,'STD-MEM-002':('MALL-SIGNUP',CUST)+SB,
'STD-MEM-003':('MALL-SIGNUP',CUST)+SB,'STD-MEM-004':('MALL-SIGNUP',CUST)+SB,
'STD-MEM-005':('MALL-SIGNUP',CUST)+SB,'STD-MEM-006':('SB-COUPON',OPER)+C,
'STD-MEM-007':('MALL-LOGIN',CUST)+SB, 'STD-MEM-008':('MALL-FINDID',CUST)+SB,
'STD-MEM-009':('MALL-FINDID',CUST)+SB,'STD-MEM-010':('MALL-LOGIN',CUST)+SB,
'STD-MEM-011':('MALL-LOGIN',CUST)+SB, 'STD-MEM-012':('MALL-LOGIN',CUST)+SB,
'STD-MEM-013':('MALL-GLOBAL',CUST)+SB,'STD-MEM-014':('MALL-GLOBAL',CUST)+B,
'STD-MEM-015':('MALL-MY-ACCOUNT',CUST)+SB,'STD-MEM-016':('MALL-MY-ACCOUNT',CUST)+SB,
'STD-MEM-017':('MALL-MY-WITHDRAW',CUST)+SB,'STD-MEM-018':('SB-MEMBER',SYSR)+WA2SB,
'STD-MEM-019':('SB-MEMBER',OPER)+C,   'STD-MEM-020':('SB-MEMBER',SYSR)+WA2SB,
'STD-MEM-021':('SB-NOTIFY',SYSR)+P,   'STD-MEM-022':('MALL-LOGIN',ADMIN)+M,
'STD-MEM-023':('SB-SOCIALAPP',ADMIN)+C,'STD-MEM-024':('MALL-SOCIALJOIN',CUST)+SB,
'BLK-S1-1':('MALL-LOGIN',ADMIN)+M,'BLK-S3-1':('SB-MEMBER',ADMIN)+M,
'BLK-S3-2':('SB-MEMBER',OPER)+C,  'BLK-S3-3':('SB-MEMBER',ADMIN)+M,
# --- C6 출고·송장 ---
'STD-SHP-008':('SB-SHIP',OPER)+C,'STD-SHP-009':('SB-SHIP',OPER)+C,
'STD-SHP-010':('SB-SHIP',OPER)+C,'STD-SHP-011':('SB-ORDER',OPER)+C,
'STD-ADO-020':('SB-ORDER',SYSR)+WA2SB,'STD-ADO-021':('SB-ORDER',SYSR)+WA2SB,
'STD-MFG-114':('SB-ORDER',SYSR)+WA2SB,'STD-MFG-123':('SB-ORDER',SYSR)+WA2SB,
'STD-MFG-124':('SB-WEBHOOK',SYSR)+SB2WA,
# --- C7 주문 상태·배송 ---
'STD-SHP-012':('SB-ORDER',SYSR)+WA2SB,'STD-SHP-013':('SB-ORDER',SYSR)+WA2SB,
'STD-SHP-014':('MALL-MY-ORDER',CUST)+SB,'STD-SHP-015':('MALL-MY-ADDRESS',CUST)+SB,
'STD-MFG-027':('SB-ORDER',SYSR)+WA2SB,'STD-MFG-029':('SB-ORDER',SYSR)+WA2SB,
'STD-MFG-030':('SB-WEBHOOK',SYSR)+SB2WA,'STD-MFG-031':('SB-CLAIM',SYSR)+WA2SB,
'STD-MFG-032':('SB-CLAIM',SYSR)+WA2SB,'STD-MFG-034':('SB-ORDER',SYSR)+WA2SB,
# --- D3 클레임·문의 ---
'STD-CLM-001':('MALL-MY-ORDER',CUST)+SB,'STD-CLM-002':('MALL-MY-ORDER',CUST)+SB,
'STD-CLM-003':('MALL-GUESTORDER',CUST)+SB,'STD-CLM-004':('MALL-MY-ORDER',CUST)+SB,
'STD-CLM-005':('MALL-MY-ORDER',CUST)+SB,'STD-CLM-006':('MALL-MY-ORDER',CUST)+SB,
'STD-CLM-007':('MALL-MY-ORDER',CUST)+SB,'STD-CLM-008':('MALL-MY-ORDER',CUST)+SB,
'STD-CLM-009':('MALL-MY-ORDER',CUST)+SB,'STD-CLM-010':('MALL-MY-ORDER',CUST)+SB,
'STD-CLM-011':('SB-CLAIM',OPER)+C,      'STD-CLM-012':('MALL-MY-ORDERS',CUST)+SB,
'STD-CLM-013':('SB-CLAIM',OPER)+C,      'STD-CLM-014':('MALL-INQUIRY',CUST)+B,
'STD-CLM-015':('MALL-INQUIRY',ADMIN)+M, 'STD-CLM-016':('MALL-INQUIRY',CUST)+SB,
'STD-CLM-017':('MALL-QNA',CUST)+SB,     'STD-CLM-018':('MALL-FAQ',CUST)+SB,
'STD-CLM-019':('MALL-INQUIRY',CUST)+B,  'STD-CLM-020':('MALL-INQUIRY',CUST)+B,
'STD-CLM-021':('MALL-PDP',CUST)+B,      'STD-CLM-022':('SB-BOARD',OPER)+C,
'STD-CLM-023':('SB-BOARD',OPER)+C,      'STD-CLM-024':('SB-BOARD',OPER)+C,
'STD-CLM-025':('SB-BOARD',OPER)+C,      'STD-CLM-026':('SB-CLAIM',OPER)+M,
'STD-ADO-022':('SB-CLAIM',OPER)+C,      'STD-ADO-023':('SB-CLAIM',OPER)+C,
'BLK-S1-6':('MALL-INQUIRY',ADMIN)+M,
# --- F4 스킨 배포 ---
'F4-1':('MALL-SERVER',ADMIN)+C,'F4-2':('MALL-SERVER',ADMIN)+B,
'F4-3':('MALL-SERVER',ADMIN)+B,'F4-4':('MALL-SERVER',ADMIN)+B,
'F4-5':('MALL-SERVER',ADMIN)+B,'F4-6':('MALL-OAUTH',ADMIN)+B,
'F4-7':('MALL-SERVER',ADMIN)+C,'F4-8':('MALL-SERVER',ADMIN)+C,
'BLK-S4-6':('MALL-SERVER',ADMIN)+M,'BLK-S4-10':('MALL-OAUTH',ADMIN)+M,
}

# 범위 밖(webadmin · widget · edicus · mes · pitstop 시스템 카드 소관) — 사유 기록용
OUT_OF_SCOPE = {
 'STD-ADC-001':'webadmin 회원관리 화면','STD-ADC-002':'webadmin 회원등급 수동조정',
 'STD-ADC-003':'webadmin 탈퇴회원 관리','STD-ADC-005':'webadmin 쿠폰 생성·발행',
 'STD-ADC-007':'webadmin 공지 관리','STD-ADC-008':'webadmin FAQ 관리',
 'STD-ADC-009':'webadmin 상품Q&A 답변','STD-ADC-010':'webadmin 1:1 답변',
 'STD-ADC-011':'webadmin 리뷰 관리','STD-ADC-012':'webadmin 상담 접수 관리',
 'STD-ADC-013':'webadmin 배너 관리','STD-ADC-014':'webadmin 가이드 콘텐츠 관리',
 'STD-ADC-015':'webadmin 매장 게시판 관리','STD-ADC-016':'webadmin 체험단 관리',
 'STD-PRM-017':'webadmin 체험단관리',
 'STD-ORD-027':'webadmin 오프라인 주문 등록',
 'STD-B2B-001':'webadmin 거래처 관리','STD-B2B-002':'webadmin 거래처 단가',
 'STD-B2B-003':'webadmin 거래처 담당자','STD-B2B-004':'webadmin 여신한도',
 'STD-B2B-005':'webadmin 후불 승인','STD-B2B-006':'webadmin 청구서',
 'STD-B2B-007':'webadmin 미수금','STD-B2B-008':'webadmin 거래처 원장',
 'STD-B2B-009':'webadmin 원장 파일','STD-B2B-010':'webadmin 대량견적',
 'STD-B2B-011':'webadmin 견적서','STD-B2B-012':'webadmin 세금계산서 일괄',
 'STD-B2B-015':'webadmin 후불결제 주문관리',
 'STD-FIN-001':'webadmin 매출 통계','STD-FIN-002':'webadmin 매출 조회',
 'STD-FIN-003':'webadmin 결제수단 집계','STD-FIN-004':'webadmin 상품 통계',
 'STD-FIN-005':'webadmin 상품군 비중','STD-FIN-006':'webadmin 주문 비중',
 'STD-FIN-007':'webadmin 공정 통계','STD-FIN-008':'webadmin PG 정산 대사',
 'STD-FIN-009':'webadmin 적립금 부채','STD-FIN-010':'webadmin 외주 정산',
 'STD-FIN-011':'webadmin 쿠폰 집계','STD-FIN-012':'webadmin 엑셀 내보내기',
 'STD-FIN-013':'webadmin 계좌관리','STD-FIN-014':'webadmin 미수금',
 'STD-FIN-019':'webadmin 굿즈 발주정산','STD-FIN-020':'외부(토스) 정산한도',
 'STD-FIN-021':'외부 회계(MS·이카운트) 연동',
 'STD-SYS-001':'webadmin 관리자 계정','STD-SYS-002':'webadmin 권한 제어',
 'STD-SYS-003':'webadmin 감사로그','STD-SYS-010':'widget·webadmin 원고 저장소',
 'STD-SYS-011':'edicus 에디터 연동','STD-SYS-025':'webadmin 관리자 등록',
 'STD-SYS-028':'webadmin 영역 분리','STD-SYS-031':'pitstop 서버 환경',
 'BLK-S2-1':'webadmin Railway 운영변수',
 'STD-MYP-028':'webadmin↔토스 가상계좌 발급','STD-MYP-029':'webadmin 입금 웹훅 수신',
 'STD-MYP-043':'webadmin t_pm_charge_txn','STD-MYP-046':'webadmin 충전 운영화면',
 'STD-MYP-047':'webadmin 잔액 마이그레이션',
 'STD-MFG-022':'webadmin 주문 상태머신','STD-MFG-023':'webadmin 상태 단위',
 'STD-MFG-024':'webadmin 매핑 테이블','STD-MFG-025':'mes 상태 통보 수신',
 'STD-MFG-026':'webadmin 취소 잠금','STD-MFG-028':'mes 송장 수신',
 'STD-MFG-033':'webadmin 에스컬레이션','STD-MFG-035':'mes 화면 신규 버튼',
 'STD-MFG-106':'mes 1차포장','STD-MFG-107':'mes 박스포장','STD-MFG-108':'mes 바코드 포장완료',
 'STD-MFG-109':'mes 제작완료 전환','STD-MFG-110':'mes 출고완료 전환',
 'STD-MFG-111':'mes 송장 출력','STD-MFG-112':'mes 납품명세서','STD-MFG-113':'mes 출고명세서',
 'STD-MFG-115':'mes 합배송 식별','STD-MFG-116':'mes 출고지 단일화',
 'STD-MFG-117':'mes 재고상품 관리','STD-MFG-118':'mes 썸네일 확인',
 'STD-MFG-119':'mes 일부 재제작','STD-MFG-120':'mes 전체 재제작',
 'STD-MFG-121':'mes 반송 접수','STD-MFG-122':'mes 정산 메모',
 'STD-MFG-125':'webadmin 파일오류 알림','STD-MFG-126':'webadmin 재업로드 알림',
 'STD-MFG-127':'webadmin 편집 수정요청 알림','STD-MFG-128':'webadmin 템플릿 심사관리',
 'STD-MFG-129':'webadmin 알림 대체발송',
}

# 계약 「코드·화면을 실제로 본 것만 완료/진행」 적용 — 원장 status 가 부분/구현-미검증이지만
# evidence 가 회의록·SCOPE ID 뿐이라 실측이 아닌 행. 스킨 실사(S1-skin/api-wiring.csv)로
# 보강 가능하면 근거를 덧붙이고, 불가능하면 미확인/미착수로 내린다.
W = 'S1-skin/api-wiring.csv'
OVERRIDE = {
 # row_id: (status, evidence 덧말)
 'STD-MEM-003': ('진행',   W + ' B5 「가입 SMS 본인인증」 wired=Y·부분(signup-form.tsx:43 플래그 off) 실사'),
 'STD-SYS-012': ('진행',   W + ' B5 「가입 SMS 본인인증」 wired=Y·부분(signup-form.tsx:43) 실사'),
 'STD-CAT-034': ('진행',   W + ' A5 「상품 상세 콘텐츠 탭」 wired=Y·부분(product-sections.tsx:32-40) 실사'),
 'STD-PAY-017': ('미착수', W + ' D4 「사업자정보 보관·재사용」 wired=N(validations/checkout.ts:35-43 스키마만) 실사'),
 'STD-PAY-018': ('미착수', W + ' D4 「증빙서류 신청·발급 목록」 stub·없음(document-section.tsx:41-51) 실사'),
 'STD-MYP-030': ('미착수', W + ' D2 「옵션보관함」 라우트 없음·wired=N 실사'),
 'STD-SHP-007': ('미확인', '근거가 SCOPE ID 뿐 — 셀러어드민 배송 템플릿 화면 미관측'),
 'STD-SHP-012': ('미확인', '근거가 IA/SCOPE 판정 뿐 — webadmin·셀러어드민 송장 화면 미관측'),
 'STD-SHP-013': ('미확인', '근거가 IA/SCOPE 판정 뿐 — 일괄변경 화면 미관측'),
 'STD-PRM-021': ('미확인', '근거가 회의 확정 뿐 — 셀러어드민 화면 미관측'),
 'STD-SYS-029': ('미확인', '근거가 회의 확정 뿐 — 셀러어드민 발신번호 화면 미관측'),
 'STD-MYP-027': ('미확인', '근거가 회의 확정 뿐 — 외부포인트 연동 상태 미관측'),
 'STD-MYP-040': ('미확인', '근거가 회의·안내문 뿐 — 점검 판정표 미작성'),
 'STD-ORD-018': ('미확인', 'reserve 필수 termsType 세트 미상 — 코드·화면 미관측'),
}


# 보충 4 (260919): 화면도 기능도 없는 결정·관리 안건은 screens.csv 의 행이 아니다.
# 9/17 원장 735행이 그 자리이므로 여기 실으면 이중계상된다 → <system>-decisions.md 로 옮긴다.
DECISIONS = {
 'BLK-S1-1','BLK-S1-3','BLK-S1-4','BLK-S1-5','BLK-S1-6','BLK-S2-2',
 'BLK-S3-1','BLK-S3-2','BLK-S3-3','BLK-S3-5','BLK-S3-6','BLK-S3-7','BLK-S3-10',
 'BLK-S4-6','BLK-S4-10',
 'STD-MYP-022','STD-MYP-023','STD-MYP-024','STD-MYP-025','STD-MYP-026','STD-MYP-027',
 'STD-MYP-031','STD-MYP-032','STD-MYP-033','STD-MYP-037','STD-MYP-038','STD-MYP-039',
 'STD-MYP-040','STD-MYP-041','STD-MYP-049','STD-MYP-050','STD-MYP-051','STD-MYP-052',
 'STD-MYP-053','STD-MYP-054',
 'STD-PAY-021','STD-PAY-022','STD-PAY-023','STD-PAY-024','STD-PAY-025','STD-PAY-026','STD-PAY-029',
 'STD-MEM-022','STD-PRM-015','STD-PRM-021','STD-MFG-130','STD-CLM-015',
 'STD-SYS-039','STD-SYS-041','STD-SYS-042','STD-SYS-053',
}

# 보충 3 「명확화」(260919 리드 결정 b): owner_side=webadmin 인 integrate 행은 t48 에 남기되,
# evidence 의 첫 path:line 을 webadmin 코드의 실제 위치로 통일한다(t51 이 이 키로 t49 행과 합친다).
# 보충 4 「인용하는 쪽이 직접 확인」에 따라 t48 이 raw/webadmin 을 직접 읽어 확인한 결과다(260919).
WA_CODE = 'raw/webadmin/webadmin/catalog/'
WA_NONE = (WA_CODE + 'shopby_client.py:137 (request 범용 호출만 존재 — 주문·송장·회원·적립금 '
           '전용 호출 함수 0건, t48 직접 확인 260919)')
WA_EVIDENCE = {
 'STD-SYS-008': WA_CODE + 'shopby_sync.py:118·315 (sync_main_images·sync_front_display) · '
                'HTTP 계층 ' + WA_CODE + 'shopby_client.py:137 — t48 직접 확인 260919',
 'STD-MFG-030': WA_CODE + 'shopby_hook.py:82 (shopby_webhook 수신 핸들러 실재) · '
                '메아리 필터 코드 0건 — :121 은 TOrdWebhooks 저장만 한다(t48 직접 확인 260919)',
 'STD-MFG-124': WA_CODE + 'shopby_hook.py:112-121 (shop_clm_sts 포함 클레임 웹훅 저장까지 실재) · '
                'MES 작업 자동생성 방지 로직은 이 파일에 없다(t48 직접 확인 260919)',
}

STATUS = {'작동':'완료','부분':'진행','구현-미검증':'진행',
          '미착수':'미착수','없음':'미착수','미실측':'미확인','대기':'미확인'}

SCOPE_STEPS = {'A4','A5','B1','B4','B5','B6','B7','C1','C3','C6','C7',
               'D1','D2','D3','D4','D5','E1','E2','E3','F4'}

NEW_ROWS = [
 ('MALL-GLOBAL',CUST,'로그아웃(헤더 전역)')+SB+('완료',
  'S1-skin/api-wiring.csv B5 「로그아웃」 wired=Y · 원장 735행에 대응 기능 행 없음(NEW)'),
 ('MALL-CHECKOUT',CUST,'/checkout 직접 진입(주문서 번호 없이)')+B+('완료',
  'S1-skin/api-wiring.csv B6 「/checkout 직접 진입」 n/a·작동 · 원장 대응 행 없음(NEW)'),
 ('MALL-CHECKOUT',SYSR,'NCPPay confirmUrl(결제 복귀 URL) 설정')+SB+('진행',
  'S1-skin/api-wiring.csv E2 「NCPPay confirmUrl」 구현-미검증 · 원장 대응 행 없음(NEW)'),
 ('MALL-SERVER',SYSR,'서버 API 프록시 무인증(/api/shopby/*) 정리')+B+('진행',
  'S1-skin/api-wiring.csv E2 「서버 API 프록시 무인증」 부분 · 원장 대응 행 없음(NEW)'),
 ('MALL-SERVER',SYSR,'handoff/verify 재검증 호출')+WA+('미착수',
  'S1-skin/api-wiring.csv C1 「handoff/verify 재검증」 호출 0건 · 원장 대응 행 없음(NEW)'),
 ('MALL-PDP',CUST,'교환·반품 안내 문구(정적)')+B+('완료',
  'S1-skin/api-wiring.csv D3 「교환/반품 안내 문구(정적)」 작동 · 원장 대응 행 없음(NEW)'),
]


def main():
    plan = [r for r in csv.DictReader(open(PLAN, encoding='utf-8')) if r['data_role'] == 'detail']
    scope = [r for r in plan if r['step'] in SCOPE_STEPS]
    out, unmapped, decisions = [], [], []
    for r in scope:
        rid = r['row_id']
        if rid in OUT_OF_SCOPE:
            continue
        if rid not in MAP:
            unmapped.append(rid)
            continue
        sid, role, wt, cp, dirn, own = MAP[rid]
        if rid in DECISIONS:
            decisions.append((SCREENS[sid][0], r))
            continue
        system, group, sname = SCREENS[sid]
        st, ev = STATUS[r['status']], (r['evidence'] or '—')
        if own == 'webadmin':
            ev = (WA_EVIDENCE.get(rid, WA_NONE)) + ' || ' + ev
        if rid in OVERRIDE:
            st, note = OVERRIDE[rid]
            ev = ev + ' || [t48 교정] ' + note
        out.append(dict(system=system, group=group, screen_id=sid, screen_name=sname,
                        role=role, function=r['title'], work_type=wt, counterpart=cp,
                        direction=dirn, owner_side=own, plan_row_id=rid,
                        status=st, evidence=ev))
    for sid, role, func, wt, cp, dirn, own, st, ev in NEW_ROWS:
        system, group, sname = SCREENS[sid]
        out.append(dict(system=system, group=group, screen_id=sid, screen_name=sname,
                        role=role, function=func, work_type=wt, counterpart=cp,
                        direction=dirn, owner_side=own, plan_row_id='NEW',
                        status=st, evidence=ev))

    for system in ('shopby', 'huni-mall'):
        sel = [r for sysname, r in decisions if sysname == system]
        path = os.path.join(BASE, system + '-decisions.md')
        with open(path, 'w', encoding='utf-8') as f:
            f.write('# %s — 결정·관리 안건 (screens.csv 밖 · 보충 4)\n\n' % system)
            f.write('화면도 기능도 없는 안건이라 `screens.csv` 의 행이 아니다. '
                    '원장 자리는 9/17 `plan-rows.csv` 735행이며, 여기 싣는 것은 '
                    '그 행을 이 카드가 어떻게 판정했는지 남기기 위해서다 — 이중계상하지 않는다.\n\n')
            f.write('| plan_row_id | 안건 | 미결 내용(완료 판정 기준) | 근거 | 결정 주체 |\n')
            f.write('|---|---|---|---|---|\n')
            for r in sel:
                cells = [r['row_id'], r['title'], r['check_method'] or '—',
                         r['evidence'] or '—', r['owner_name'] or '미정']
                f.write('| ' + ' | '.join(c.replace('|', '\\|').replace('\n', ' ') for c in cells) + ' |\n')
        print('%s-decisions.md   : %d' % (system, len(sel)))

    if unmapped:
        print('!! UNMAPPED %d: %s' % (len(unmapped), unmapped), file=sys.stderr)
    cols = ['system', 'group', 'screen_id', 'screen_name', 'role', 'function', 'work_type',
            'counterpart', 'direction', 'owner_side', 'plan_row_id', 'status', 'evidence']
    order = {'shopby': 0, 'huni-mall': 1}
    out.sort(key=lambda r: (order[r['system']], r['group'], r['screen_id'], r['plan_row_id']))
    with open(OUT, 'w', encoding='utf-8', newline='') as f:
        w = csv.DictWriter(f, fieldnames=cols, lineterminator='\n')
        w.writeheader()
        w.writerows(out)
    print('scope rows      :', len(scope))
    print('out-of-scope    :', len([r for r in scope if r['row_id'] in OUT_OF_SCOPE]))
    print('screens.csv rows:', len(out))
    print('decisions       :', len(decisions))
    print('unmapped        :', len(unmapped))


if __name__ == '__main__':
    main()
