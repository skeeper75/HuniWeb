# -*- coding: utf-8 -*-
"""N2 갈래1+2+3 — standard-feature-canon-v2.csv 생성기 (결정론)"""
import csv, json, re, os, collections
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
def P(*a): return os.path.join(ROOT, *a)

L1 = list(csv.DictReader(open(P('L1','standard-feature-canon.csv'), encoding='utf-8')))
M3 = list(csv.DictReader(open(P('L0','M3','production-feature-canon.csv'), encoding='utf-8')))
COLS = ['std_id','대분류','중분류','기능','인쇄특수여부','필수도','근거출처']

# ── 갈래2: M3 135행 병합 결정표 (DEL 삭제 / SUB 세분·상위참조 / DIST 유사별개 / NEW 신설) ──
DEC = {
 'STD-MFG-008':('SUB','STD-ART-007'), 'STD-MFG-016':('SUB','STD-ART-028'),
 'STD-MFG-017':('SUB','STD-SHP-015'), 'STD-MFG-021':('SUB','STD-SYS-016'),
 'STD-MFG-028':('SUB','STD-SHP-012'), 'STD-MFG-032':('SUB','STD-CLM-013'),
 'STD-MFG-035':('SUB','STD-ADO-009'), 'STD-MFG-040':('SUB','STD-ART-018'),
 'STD-MFG-041':('DEL','STD-ART-016'), 'STD-MFG-042':('DEL','STD-ART-009'),
 'STD-MFG-043':('DEL','STD-ART-011'), 'STD-MFG-044':('DIST','STD-ART-012'),
 'STD-MFG-045':('DEL','STD-ART-010'), 'STD-MFG-046':('NEW',''),
 'STD-MFG-047':('DEL','STD-ART-013'), 'STD-MFG-048':('SUB','STD-ART-008'),
 'STD-MFG-049':('SUB','STD-ART-017'), 'STD-MFG-054':('SUB','STD-ART-018'),
 'STD-MFG-055':('SUB','STD-ART-007'), 'STD-MFG-056':('SUB','STD-ART-007'),
 'STD-MFG-059':('NEW',''), 'STD-MFG-061':('SUB','STD-ART-019'),
 'STD-MFG-063':('DEL','STD-ADO-008'), 'STD-MFG-064':('SUB','STD-ART-023'),
 'STD-MFG-066':('NEW',''), 'STD-MFG-067':('SUB','STD-ADO-006'),
 'STD-MFG-068':('SUB','STD-ADO-006'), 'STD-MFG-069':('SUB','STD-FIN-012'),
 'STD-MFG-070':('SUB','STD-ORD-027'), 'STD-MFG-072':('SUB','STD-ART-001'),
 'STD-MFG-074':('SUB','STD-ADO-014'), 'STD-MFG-076':('NEW',''),
 'STD-MFG-081':('NEW',''), 'STD-MFG-082':('SUB','STD-ADP-005'),
 'STD-MFG-087':('DIST','STD-ADP-005'), 'STD-MFG-091':('SUB','STD-ART-028'),
 'STD-MFG-093':('DIST','STD-ART-028'), 'STD-MFG-097':('DEL','STD-ADO-011'),
 'STD-MFG-098':('NEW',''), 'STD-MFG-099':('DIST','STD-ADP-016'),
 'STD-MFG-100':('SUB','STD-ADO-017'), 'STD-MFG-102':('SUB','STD-ADO-017'),
 'STD-MFG-103':('SUB','STD-ADO-017'), 'STD-MFG-104':('SUB','STD-ADO-018'),
 'STD-MFG-105':('DEL','STD-ADO-019'), 'STD-MFG-107':('NEW',''),
 'STD-MFG-108':('DIST','STD-ADO-016'), 'STD-MFG-109':('NEW',''),
 'STD-MFG-110':('DIST','STD-ADO-016'), 'STD-MFG-111':('DIST','STD-ADO-020'),
 'STD-MFG-112':('DIST','STD-PAY-018'), 'STD-MFG-113':('DIST','STD-PAY-018'),
 'STD-MFG-116':('NEW',''), 'STD-MFG-119':('SUB','STD-CLM-015'),
 'STD-MFG-120':('SUB','STD-CLM-015'), 'STD-MFG-121':('DIST','STD-CLM-005'),
 'STD-MFG-123':('SUB','STD-SHP-012'), 'STD-MFG-124':('SUB','STD-ADO-022'),
 'STD-MFG-125':('SUB','STD-ART-018'), 'STD-MFG-126':('SUB','STD-ART-018'),
 'STD-MFG-127':('SUB','STD-SYS-006'), 'STD-MFG-128':('SUB','STD-SYS-006'),
 'STD-MFG-129':('SUB','STD-SYS-006'), 'STD-MFG-130':('SUB','STD-SYS-006'),
 'STD-MFG-131':('SUB','STD-SYS-016'), 'STD-MFG-132':('SUB','STD-SYS-002'),
 'STD-MFG-133':('SUB','STD-ORD-027'), 'STD-MFG-134':('SUB','STD-B2B-006'),
 'STD-MFG-135':('SUB','STD-B2B-012'),
 # FP = 기계 후보로 잡혔으나 실제 중복이 아님(어휘 우연 일치). 판정을 명시해 미판정 0 을 만든다.
 'STD-MFG-039':('FP','STD-PAY-012'), 'STD-MFG-059':('FP','STD-ADO-022'),
 'STD-MFG-066':('FP','STD-ORD-014'), 'STD-MFG-076':('FP','STD-OPT-018'),
 'STD-MFG-081':('FP','STD-ART-005'), 'STD-MFG-098':('FP','STD-OPT-008'),
 'STD-MFG-102':('SUB','STD-ADO-017'), 'STD-MFG-107':('FP','STD-SHP-005'),
 'STD-MFG-109':('FP','STD-MEM-019'), 'STD-MFG-116':('FP','STD-ORD-027'),
 'STD-MFG-122':('FP',''),
}
LEG = 'L3/legacy-normalized.json'
IAX = 'docs/huni/후니프린팅_통합IA_일정_역할분담_260616.xlsx#02_IA마스터'
FGM = '_workspace/huni-launch-scope/02_gap/fit-gap-matrix.csv'

# ── 갈래1: 신규 표준행 21건 ──
NEW = [
 ('STD-MYP-017','마이페이지','대시보드','마이페이지 메인 대시보드(주문요약·프린팅머니·쿠폰 한눈에)','N','must',
  f'{LEG}#F-029,IA-029,SCOPE-029 · {FGM}:30 · {IAX}!A30:K30 · L2/as-is-inventory.csv#SB-044 huni-skin-shopby/src/components/mypage/dashboard-section.tsx:17-59'),
 ('STD-MYP-018','마이페이지','대시보드','마이페이지 서브메인(기능군 랜딩) 화면','N','should',
  f'{LEG}#F-030,IA-030,SCOPE-030 · {FGM}:31 · {IAX}!A31:K31'),
 ('STD-MYP-019','마이페이지','대시보드','마이페이지 통합 검색결과 LIST 화면','N','should',
  f'{LEG}#F-031,IA-031,SCOPE-031 · {FGM}:32 · {IAX}!A32:K32'),
 ('STD-CAT-023','상품·카탈로그','상품','상품 기본정보 세팅·로드(상품코드·주문가능여부·회원전용 노출 게이팅)','N','must',
  f'{LEG}#F-032,IA-032,SCOPE-032 · {FGM}:33 · {IAX}!A33:K33'),
 ('STD-CAT-024','상품·카탈로그','상품군','포장재 상품군 주문 경로(전용 옵션·주문 흐름)','Y','should',
  f'{LEG}#F-091,IA-091,SCOPE-091 · {FGM}:92 · {IAX}!A92:K92'),
 ('STD-CAT-025','상품·카탈로그','상품군','굿즈 상품군 주문 경로(파우치·백 포함)','Y','should',
  f'{LEG}#F-092,IA-092,SCOPE-092 · {FGM}:93 · {IAX}!A93:K93'),
 ('STD-CAT-026','상품·카탈로그','상품군','수작 상품 메인·상품페이지 경로','Y','could',
  f'{LEG}#F-093,IA-093,SCOPE-093 · {FGM}:94 · {IAX}!A94:K94'),
 ('STD-OPT-056','옵션·견적','인쇄옵션','캘린더 가공·장수(월수) 선택','Y','should',
  f'{LEG}#F-045,IA-045,SCOPE-045 · {FGM}:46 · {IAX}!A46:K46'),
 ('STD-OPT-057','옵션·견적','가이드','규격 가이드 모달(사이즈 안내 팝업)','Y','should',
  f'{LEG}#IA-057,SCOPE-057 · {IAX}!A58:K58'),
 ('STD-OPT-058','옵션·견적','가이드','주문가능 자재(용지) 목록 모달','Y','should',
  f'{LEG}#F-059,IA-059,SCOPE-059 · {FGM}:60 · {IAX}!A60:K60'),
 ('STD-ART-029','원고·파일','업로드','가변데이터 인쇄(VDP) 데이터 업로드·병합','Y','could',
  f'{LEG}#F-055,IA-055,SCOPE-055 · {FGM}:56 · {IAX}!A56:K56'),
 ('STD-ORD-028','장바구니·주문','주문','선택옵션→주문 데이터 변환(확정 사양의 주문항목 생성)','Y','must',
  f'{LEG}#F-062,IA-062,SCOPE-062 · {FGM}:63 · {IAX}!A63:K63 · 돈Y·주문Y·1차'),
 ('STD-PAY-019','결제','결제수단','수동카드결제(키인·가상단말 · PC+모바일)','N','should',
  f'{LEG}#F-074,IA-074,SCOPE-074 · {FGM}:75 · {IAX}!A75:K75'),
 ('STD-INF-001','정보·콘텐츠','회사정보','회사소개 페이지','N','must',
  f'{LEG}#IA-083,SCOPE-083 · {IAX}!A84:K84 · L2/as-is-inventory.csv#SB-058 huni-skin-shopby/src/app/(main)/company/page.tsx:1'),
 ('STD-INF-002','정보·콘텐츠','회사정보','찾아오시는 길(약도·교통 안내)','N','must',
  f'{LEG}#IA-086,SCOPE-086 · {IAX}!A87:K87 · L2/as-is-inventory.csv#SB-058 huni-skin-shopby/src/app/(main)/location/page.tsx:1'),
 ('STD-INF-003','정보·콘텐츠','약관·정책','이용약관 페이지 게시','N','must',
  f'{LEG}#IA-084,SCOPE-084 · {IAX}!A85:K85 · L2/as-is-inventory.csv#SB-057 huni-skin-shopby/src/app/(main)/terms/page.tsx:1'),
 ('STD-INF-004','정보·콘텐츠','약관·정책','개인정보처리방침 페이지 게시','N','must',
  f'{LEG}#IA-085,SCOPE-085 · {IAX}!A86:K86 · L2/as-is-inventory.csv#SB-057 huni-skin-shopby/src/app/(main)/privacy/page.tsx:1 · src/lib/legal/markdown.ts:1'),
 ('STD-ADC-015','운영자·회원CS','게시판','매장(거래처) 게시판 관리','N','could',
  f'{LEG}#F-096,IA-096,SCOPE-096 · {FGM}:97 · {IAX}!A97:K97'),
 ('STD-ADC-016','운영자·회원CS','게시판','체험단 모집·신청내역 관리(운영자)','N','could',
  f'{LEG}#F-121,IA-121,SCOPE-121 · {FGM}:122 · {IAX}!A122:K122'),
 ('STD-ADP-034','운영자·상품가격','상품','수작 상품 등록','Y','could',
  f'{LEG}#F-111,IA-111,SCOPE-111 · {FGM}:112 · {IAX}!A112:K112'),
 ('STD-ADP-035','운영자·상품가격','상품','디자인 상품 등록','Y','could',
  f'{LEG}#F-113,IA-113,SCOPE-113 · {FGM}:114 · {IAX}!A114:K114'),
]

out = [dict(zip(COLS,[r[c] for c in COLS])) for r in L1]
deleted, tagged, fps = [], [], []
for m in M3:
    v, ref = DEC.get(m['std_id'], ('NEW',''))
    if v == 'DEL':
        deleted.append((m['std_id'], ref, m['기능'])); continue
    row = {c: m[c] for c in COLS}
    if v == 'SUB':
        row['근거출처'] = f"[상위:{ref}] " + row['근거출처']; tagged.append((m['std_id'],'SUB',ref))
    elif v == 'FP':
        fps.append((m['std_id'], ref))
    elif v == 'DIST':
        row['근거출처'] = f"[구분:{ref}] " + row['근거출처']; tagged.append((m['std_id'],'DIST',ref))
    out.append(row)
for t in NEW:
    out.append(dict(zip(COLS,t)))

with open(os.path.join(os.path.dirname(__file__),'..','standard-feature-canon-v2.csv'),'w',newline='',encoding='utf-8') as f:
    w = csv.DictWriter(f, fieldnames=COLS); w.writeheader(); w.writerows(out)
json.dump({'deleted':deleted,'tagged':tagged,'fp':fps,'new':[t[0] for t in NEW]},
          open(os.path.join(os.path.dirname(__file__),'decisions.json'),'w'), ensure_ascii=False, indent=1)
print('v2 rows:', len(out), '= L1', len(L1), '+ M3', len(M3)-len(deleted), '(삭제', len(deleted), ') + 신규', len(NEW))
