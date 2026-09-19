# -*- coding: utf-8 -*-
"""t59 ㉮㉯ — 최숙진 역할 5축 행 원장 생성.

원칙
- 기존 행의 owner/status/t56 판정은 **원본 CSV 에서 조인**한다(전사 0).
- 신규 제안 행은 `row_id=NEW-*` 로 두고 plan-rows 에 같은 일을 하는 행이 없음을 verify.py 가 검사한다.
- 축 귀속은 제목이 아니라 evidence 를 열어 확인한 결과다(근거는 basis 열).
"""
import csv

BASE = '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t59/_workspace/huni-launch-runway/'
MAIN = '/Users/innojini/Dev/HuniWeb/'
PLAN = BASE + '07_rebaseline/S/S5-plan/plan-rows.csv'
REJ = BASE + '08_system-screen/t56/rejudge.csv'
OUT = BASE + '08_system-screen/t59/axis-rows.csv'

SKIN = MAIN.replace('/HuniWeb/', '/') + 'huni-skin-shopby/'   # /Users/innojini/Dev/huni-skin-shopby/
WADM = MAIN + 'raw/webadmin/'
DOCS = MAIN + 'docs/huni/'

# (축, kind, row_id, 최숙진몫, action, evidence, basis)
# kind: 재연결 = 원장에 행이 있다 / 신규 = 원장에 대응 행이 없다 / 경계 = 최숙진 몫이 아니라 짝이 되는 남의 행
T = [
 # ── ① 가이드북 콘텐츠 ────────────────────────────────────────────────
 ('1.가이드북', '재연결', 'STD-CAT-019', '원고', '콘텐츠 몫 유지(t56 분할: 콘텐츠=최숙진 / 화면=김동학)',
  SKIN + 'src/lib/guide-data.ts:61-128',
  '파일작업가이드 탭 12편 중 실원고는 pdf-save 1편(:62-85)뿐이고 11편이 stub() 자리표시자(:86-128)'),
 ('1.가이드북', '재연결', 'STD-INF-007', '원고', '콘텐츠 몫 유지 · STD-CAT-019 와 같은 11종을 가리키는지 중복 확인 필요',
  SKIN + 'src/lib/guide-data.ts:86-128',
  '「작업 유의사항 11종」의 수가 파일작업가이드 stub 11편과 일치 — 두 행이 같은 대상일 가능성'),
 ('1.가이드북', '경계', 'STD-ADC-014', '콘텐츠 충전', '도구=서희항(webadmin) 유지 + 콘텐츠 충전 짝 행(NEW-G4)을 최숙진으로',
  WADM + 'webadmin/config/urls.py:72-87',
  '「상품별 작업가이드 파일 관리」 화면이 webadmin 에 산다(guide_file_md·presign·save·delete). 원장 check_method 는 샵바이 셀러어드민을 가리켜 어긋난다'),
 ('1.가이드북', '신규', 'NEW-G1', '원고', '가이드북 5개 탭 60편 원고 작성 — 원장 행 0',
  SKIN + 'src/lib/guide-data.ts:147-209',
  '책자·인쇄와종이·후가공·주문·편집기 5탭이 각 count:12 · articles 는 전부 stubList() 자리표시자'),
 ('1.가이드북', '신규', 'NEW-G2', '제목 확정', '자동생성 제목 40건(탭당 8편) 교정 — 원장 행 0',
  SKIN + 'src/lib/guide-data.ts:132-146',
  'stubList 가 titles[i] 가 없으면 `${titles[0]} ${i+1}` 로 제목을 만든다. 탭마다 제목 4개만 주어져 8편이 자동 제목'),
 ('1.가이드북', '신규', 'NEW-G3', '제목 확정', '파일작업가이드 동일 제목 5건 정리 — 원장 행 0',
  SKIN + 'src/lib/guide-data.ts:93-123',
  'outline-1~outline-5 가 모두 「폰트 아웃라인 (Create Outlines) 미적용시 해결법」 같은 제목'),
 ('1.가이드북', '신규', 'NEW-G4', '자료 등재', '상품군별 가이드 파일 등재(webadmin 가이드파일 관리 화면 사용) — STD-ADC-014 의 콘텐츠 짝 행',
  WADM + 'webadmin/catalog/s3_guide.py:269-291',
  'presign_put 으로 브라우저 직결 업로드하는 도구는 완성돼 있다 — 무엇을 올릴지는 운영이 정한다'),

 # ── ② 상품 상세페이지 탭 콘텐츠 ───────────────────────────────────────
 ('2.상세탭', '경계', 'STD-CAT-007', '없음', '도구·화면=김동학 유지(t56 담당맞음)',
  SKIN + 'src/app/(main)/product/[slug]/page.tsx:49-56',
  '스킨은 fetchPublishedDetailTabs 로 발행본을 읽기만 한다 — 발행본을 만드는 일은 스킨 밖'),
 ('2.상세탭', '경계', 'STD-CAT-034', '없음', '탭 6종 자동 등록=개발(t56 분할: 김동학+서희항)',
  BASE + '08_system-screen/t56/rejudge.csv (row_id STD-CAT-034)',
  't56 판정 분할 · 근거등급 merged-owner_side'),
 ('2.상세탭', '경계', 'STD-ADP-015', '없음', '편집 도구=김동학 유지(t56 manual-read 로 확정)',
  BASE + '08_system-screen/t56/verdict.md',
  't56 §5 manual-read 8행에 포함 — 페이지빌더=김동학 확정으로 조회·편집이 한 사람'),
 ('2.상세탭', '신규', 'NEW-D1', '콘텐츠', '게시 상품별 상세탭 4종(차별점·디자인보기·디자인가이드·유의사항) 발행본 채우기 — 원장 행 0',
  SKIN + 'src/lib/printly/detail-tabs.ts:16-32',
  'TAB_SOURCES 가 발행본으로 채울 수 있는 탭을 4종으로 한정한다 · 채우는 행위의 원장 행이 없다'),
 ('2.상세탭', '신규', 'NEW-D2', '콘텐츠', '미발행 상품의 정적 폴백 문구 교체 — 현재 핀버튼 샘플 카피가 전 상품에 노출',
  SKIN + 'src/components/product/product-sections.tsx:14-46',
  'DiffSection 하드코딩 문구 = 「로고 핀버튼으로 아이덴티티를 부여하세요」 등 핀버튼 전용 카피'),
 ('2.상세탭', '신규', 'NEW-D3', '콘텐츠', '유의사항 탭 상품정보 고시값을 상품별로 정의 — 현재 전 상품 동일 고정값',
  SKIN + 'src/components/product/product-sections.tsx:146-153',
  'spec 이 품명=프리미엄 인쇄 상품 · A4 · 몽블랑 190g · 3박4일 · OPP 로 고정'),
 ('2.상세탭', '신규', 'NEW-D4', '콘텐츠', '포장/배송·상품리뷰 탭은 발행 대상 밖 — 문구 확정 주체 지정 필요',
  SKIN + 'src/lib/printly/detail-tabs.ts:5-6',
  '주석: 「여기 없는 탭(유의사항·포장/배송·상품리뷰)은 항상 기존 정적/라이브 섹션」'),

 # ── ③ 후니프린팅 정책(엑셀) 정리 ─────────────────────────────────────
 ('3.정책', '재연결', 'STD-PAY-029', '정책값 확정', '미입금 자동취소 기간 확정 — t56 이 신우진→최숙진 재배정 제안(evidence-path)',
  BASE + '08_system-screen/t56/rejudge.csv (row_id STD-PAY-029)',
  't56 판정 재배정 · owner_proposed 최숙진'),
 ('3.정책', '재연결', 'STD-SHP-001', '정책값 확정', '기본 배송비 — 담당맞음 유지',
  DOCS + '후니프린팅_운영정책_260918.xlsx (구매배송정보 시트 2행)',
  '엑셀이 택배·기본배송비·무료배송 기준을 적은 유일 원천'),
 ('3.정책', '재연결', 'STD-SHP-002', '정책값 확정', '무료배송 기준금액 — 담당맞음 유지',
  DOCS + '후니프린팅_운영정책_260918.xlsx (구매배송정보 시트 2행)', '위와 같은 셀'),
 ('3.정책', '재연결', 'STD-SYS-005', '정책값 확정', '배송비 정책 설정 — t56 이 김동학→최숙진 재배정 제안',
  BASE + '08_system-screen/t56/rejudge.csv (row_id STD-SYS-005)', 't56 판정 재배정 · merged-owner_side'),
 ('3.정책', '경계', 'STD-MYP-025', '값 회신', '프린트머니 소멸정책 — 결정 주체는 지니/대표. 최숙진은 엑셀 값 회신',
  DOCS + '후니프린팅_운영정책_검토요청_260918.md:44-57',
  '같은 항목에 8/27판 무기한 · FAQ 1년 · 9/15 확정 소멸없음 · 9/18판 5년 — 값이 넷'),
 ('3.정책', '신규', 'NEW-P1', '정리', '운영정책 엑셀 「IA(정리중)」 시트 완료 — 시트명이 미완을 자인',
  DOCS + '후니프린팅_운영정책_260918.xlsx (IA(정리중) 시트 · 내용행 41 / max_row 45)',
  '시트명 「(정리중)」 · 기능 칸이 대부분 비어 있다'),
 ('3.정책', '신규', 'NEW-P2', '정리', '운영정책 엑셀 「FAQ(정리중)」 시트 완료 — 3행에 「정리중입니다」',
  DOCS + '후니프린팅_운영정책_260918.xlsx (FAQ(정리중) 시트 3행 · 내용행 94 / max_row 157)',
  'FAQ 항목 다수가 「오프린트미 참조함」·「레드프린팅」 같은 참조 메모 상태'),
 ('3.정책', '신규', 'NEW-P3', '정리', '할인쿠폰 정책 정리 — 시트 내용행 2',
  DOCS + '후니프린팅_운영정책_260918.xlsx (할인쿠폰 시트 · 내용행 2 / max_row 1003)',
  '쿠폰이용안내 1항만 있고 발급·중복·최소주문 조건이 없다'),
 ('3.정책', '신규', 'NEW-P4', '회신', '운영정책 검토요청 21건 결정 회신 — 원장 행 0',
  DOCS + '후니프린팅_운영정책_검토요청_260918.md:1-30',
  '커밋 48714c44 리포트: 정책 49건 중 실무진 결정 대기 21건 · 이 회신을 담는 원장 행이 없다'),

 # ── ④ 내부 프로세스 정의 → CTO 연동 ──────────────────────────────────
 ('4.프로세스', '재연결', 'STD-ADO-010', '기준 정의', '검수 게이트(G1 파일·G3 가공·G4 출고) — 담당맞음 유지 · 기준 문서가 산출물',
  BASE + '08_system-screen/t57/connect-design.md:154-186',
  't57 결정 사슬에 STD-ADO-010 이 「최숙진 ⚠rule-step · 추정 확인」으로 올라 있다'),
 ('4.프로세스', '재연결', 'STD-ADO-008', '기준 정의', '파일 확인 처리(검판 판정) — CTO 구간 09 접수자 자리',
  DOCS + '후니-주문흐름-장바구니에서-MES까지_서희항_260908.html (구간 09 「접수 — 검수하고 제작대기로」)',
  'CTO 문서가 이 구간을 「가장 큰 공백」으로 적었다'),
 ('4.프로세스', '재연결', 'STD-MFG-092', '규약 정의', '인쇄타입별 접수파일 포맷 규약(PDF/AI/JPG) — 담당맞음 유지',
  BASE + '07_rebaseline/S/S5-plan/plan-rows.csv (row_id STD-MFG-092)', '원장 owner_name=최숙진'),
 ('4.프로세스', '재연결', 'STD-MFG-058', '규약 정의', '접수파일 등록 2경로(원본 그대로 vs 가공 후) — 담당맞음 유지',
  BASE + '07_rebaseline/S/S5-plan/plan-rows.csv (row_id STD-MFG-058)', '원장 owner_name=최숙진'),
 ('4.프로세스', '경계', 'STD-ART-034', '선행 입력', 'PitStop 연동방식 결정(A 큐+DB vs B 파일+JSON) — 결정 주체 미정. 최숙진 입력이 선행',
  BASE + '08_system-screen/t57/connect-design.md:158-170',
  't57: 「여기가 막히면 아래 전부 막힌다」 · t50·t56 양쪽 미정 · t56 근거 rule-track(약함)'),
 ('4.프로세스', '경계', 'STD-MFG-049', '선행 입력', '판정 3갈래 분기 구현=서희항 — 분기 규칙 정의는 최숙진(NEW-C2)',
  BASE + '07_rebaseline/S/S5-plan/plan-rows.csv (row_id STD-MFG-049)', '원장 owner_name=서희항'),
 ('4.프로세스', '신규', 'NEW-C1', '기준 정의', '프리플라이트 검사 범위 정의(재단여백·해상도·색상모드·글꼴·페이지수) — 원장 행 0',
  DOCS + '후니-주문흐름-장바구니에서-MES까지_서희항_260908.html (구간 08 「어디까지 검사할지 범위 정리」)',
  'STD-ART-035 는 「작업 분량 추정치」를 내는 행이지 기준을 정하는 행이 아니다(check_method 실독)'),
 ('4.프로세스', '신규', 'NEW-C2', '기준 정의', '검사 결과별 처리 규칙 정의(통과 / 담당자 검수 / 고객 재업로드) — 원장 행 0',
  DOCS + '후니-주문흐름-장바구니에서-MES까지_서희항_260908.html (구간 08 「검사 결과별 처리 프로세스 정리」)',
  '구현행 STD-MFG-049(3갈래 분기)는 있으나 무엇이 어느 갈래인지 정하는 행이 없다'),
 ('4.프로세스', '신규', 'NEW-C3', '기준 정의', '접수 화면 검수 기준 정의(무엇을 보고 무엇으로 제작대기 전환) — 원장 행 0',
  DOCS + '후니-주문흐름-장바구니에서-MES까지_서희항_260908.html (구간 09)',
  'CTO: 「접수자가 결과를 화면에서 보고 … 문제 없으면 제작대기로 넘긴다」 — 그 판단 기준 문서가 없다'),
 ('4.프로세스', '신규', 'NEW-C4', '결정 요청', 'Edicus 생성 파일 검수 스킵 여부 — 원장 행 0',
  DOCS + '후니-주문흐름-장바구니에서-MES까지_서희항_260908.html (구간 09 말미)',
  'plan-rows 전수 검색에서 이 안건을 담는 행이 없다(Edicus 관련 행은 T2-4·STD-MFG-060·F3-9 뿐)'),
 ('4.프로세스', '신규', 'NEW-C5', '기준 정의', '생산 착수 후 취소 에스컬레이션 판단 기준 — 구현행 STD-MFG-033 의 사람 규칙',
  BASE + '07_rebaseline/S/S5-plan/plan-rows.csv (row_id STD-MFG-033)',
  '원장은 「자동 처리하지 않고 담당자 에스컬레이션」까지만 적는다 — 담당자가 무엇을 보고 정하는지가 없다'),

 # ── ⑤ 테스트 시나리오 내부팀 역할 배정 ────────────────────────────────
 ('5.테스트역할', '경계', 'T7-1', '확인 주체', '진입조건 9항 = 인프라·개발 축. 최숙진 확인 항목 0 — 배정표가 필요',
  BASE + '07_rebaseline/S/S4-infra/migration-plan.md:89-97',
  '9항 전부 DB 반입·시크릿·화이트리스트·웹훅·CORS·도메인·크론 — 실무운영 확인 항목이 없다'),
 ('5.테스트역할', '경계', 'T7-2', '확인 주체', '종단 주문 테스트 — 접수 단계 확인자가 명시되지 않음',
  BASE + '07_rebaseline/S/S5-plan/plan-rows.csv (row_id T7-2)',
  'check_method 는 셀러어드민 주문목록·마이페이지만 본다 — 접수·검수 단계 확인 주체가 빠져 있다'),
 ('5.테스트역할', '재연결', 'STD-ADP-037', '검증 차수', '게시 위젯 가격 전수 대조 1차 최숙진→2차 김용기→3차 채훈희 — 다단 검증 선례',
  BASE + '07_rebaseline/S/S5-plan/plan-rows.csv (row_id STD-ADP-037)',
  '원장 title 에 3차 승인 체계가 이미 적혀 있다 — ⑤의 형식을 이 선례에 맞춘다'),
 ('5.테스트역할', '재연결', 'STD-ADO-028', '확인 주체', '스모크 주문 3건·취소 1건 관측 — 최숙진 담당맞음(evidence-path)',
  BASE + '08_system-screen/t56/rejudge.csv (row_id STD-ADO-028)', 't56 판정 담당맞음'),
 ('5.테스트역할', '신규', 'NEW-T1', '배정표', '진입조건 9항별 확인 주체·확인 화면 배정표 — 원장 행 0',
  BASE + '07_rebaseline/S/S4-infra/migration-plan.md:89-97', '9항에 담당 열이 없다'),
 ('5.테스트역할', '신규', 'NEW-T2', '배정표', '종단 주문 테스트 단계별 내부팀 역할표(결제→접수→MES→송장→고객조회) — 원장 행 0',
  DOCS + '후니-주문흐름-장바구니에서-MES까지_서희항_260908.html (구간 04~10)',
  'CTO 10구간이 단계를 이미 나눠 두었다 — 사람 배정만 없다'),
 ('5.테스트역할', '신규', 'NEW-T3', '배정표', '2주 테스트 시나리오의 게시 상품 전수 분담 — STD-SYS-032 하위 분담 행 0',
  BASE + '07_rebaseline/S/S5-plan/plan-rows.csv (row_id STD-SYS-032)',
  'check_method: 「게시 상품 전부를 덮는 시나리오 목록」 — 누가 어느 상품군을 보는지가 없다'),
 ('5.테스트역할', '신규', 'NEW-T4', '배정표', '오픈 당일·직후 운영 당번과 장애 에스컬레이션 경로 — 원장 행 0',
  BASE + '07_rebaseline/S/S5-plan/plan-rows.csv (전수 검색: 당번·장애·비상 0건 · T7-3 은 Go/No-Go 회의)',
  'T7-3 컷오버·롤백 트리거는 대표 결정 행이고 운영 당번 행은 없다'),
]


def load(p):
    with open(p, encoding='utf-8') as f:
        return list(csv.DictReader(f))


plan = {r['row_id']: r for r in load(PLAN)}
rej = {r['row_id']: r for r in load(REJ)}

cols = ['axis', 'kind', 'row_id', 'title', 'csj_part', 'owner_now', 'status',
        't56_verdict', 't56_owner_proposed', 't56_judged_by', 'action', 'evidence', 'basis']
with open(OUT, 'w', encoding='utf-8', newline='') as f:
    w = csv.DictWriter(f, fieldnames=cols, lineterminator='\n')
    w.writeheader()
    for axis, kind, rid, part, action, ev, basis in T:
        p = plan.get(rid, {})
        j = rej.get(rid, {})
        w.writerow({
            'axis': axis, 'kind': kind, 'row_id': rid,
            'title': p.get('title', '(신규 제안 — 원장 행 없음)'),
            'csj_part': part, 'owner_now': p.get('owner_name', ''), 'status': p.get('status', ''),
            't56_verdict': j.get('verdict', ''), 't56_owner_proposed': j.get('owner_proposed', ''),
            't56_judged_by': j.get('judged_by', ''),
            'action': action, 'evidence': ev, 'basis': basis,
        })
print('axis-rows.csv rows =', len(T))
