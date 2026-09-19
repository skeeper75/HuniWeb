#!/usr/bin/env python3
"""t56 — 역할별 Todo 재판정(S7-A).

입력  : 07_rebaseline/S/S5-plan/plan-rows.csv (735행 · 담당 원장)
        08_system-screen/t51/merged.csv       (747행 · 화면·기능 원장 · owner_side 보유)
출력  : rejudge.csv (735행 · 5분류 판정 + 재배정 제안)

판정 5분류(카드 ①):
  담당맞음 / 재배정 / provided / 분할 / 미정

판정 근거 등급(judged_by) — 무엇을 근거로 했는지 섞지 않는다:
  merged-owner_side : t51 merged.csv 가 그 기능이 사는 코드 쪽(owner_side)을 이미 적어 둔 행
  evidence-path     : plan-rows 의 evidence 문자열이 저장소·호스트를 직접 가리키는 행
  manual-read       : 내가 그 evidence 파일을 열어 확인한 행(파일·줄 확인함)
  rule-track        : 위 셋이 다 없어 트랙·단계 규칙으로만 판정한 행(약한 근거)

책임 경계(지니 확정 260919):
  위젯 = 상품선택·가격계산·에디터·파일업로드·PitStop/MES 연계
  쇼핑몰 = 그 값을 받아 카트·주문·결제
담당: webadmin·위젯·WebAdmin SDK·API = 서희항 / 쇼핑몰 스킨(huni-skin-shopby) = 김동학
      실무운영 = 최숙진(·김용기) / PM = 신우진·지니
  · 페이지빌더 = 김동학(쇼핑개발) — CARDS-S §1 A5.

역할 정의(지니 확정 260919 · 리드 lane-1 전달):
  · 신우진 = 프로젝트 총괄 PM — CTO 와 기술 적합성 논의 · 기초자료 정리 ·
    프로젝트 전체 프로세스 정리 · 일정관리. **만들지 않는다.**
    → 구현·설정 행을 신우진에게 **보내는** 제안은 금지(_pm_guard).
      결정과 구현이 한 행에 섞였을 때만 「구현 담당 + 신우진」 분할로 둔다.
  · 최숙진 = ① 가이드북 콘텐츠 ② 상세페이지 탭 콘텐츠 ③ 후니프린팅 정책(엑셀) 정리
    ④ 내부 프로세스 정의(→ CTO 와 생산 연동에 필요한 내용 정리)
    ⑤ 테스트 시나리오별 내부팀 역할 배정.
    → **도구·화면은 최숙진 몫이 아니고 그 안의 내용이 최숙진 몫**(CONTENT_SPLIT).
"""
import csv, os, re, collections

HERE = os.path.dirname(os.path.abspath(__file__))
BASE = os.path.dirname(os.path.dirname(HERE))
PLAN = os.path.join(BASE, '07_rebaseline/S/S5-plan/plan-rows.csv')
MERGED = os.path.join(os.path.dirname(HERE), 't51/merged.csv')
OUT = os.path.join(HERE, 'rejudge.csv')

# 사는 곳 → 담당자
SITE_OWNER = {
    'huni-mall': '김동학',
    'webadmin': '서희항',
    'widget': '서희항',
    'edicus': '서희항',
    'pitstop': '서희항',
    'shopby': '최숙진',      # 셀러어드민 = 설정·운영(코드 0)
    # 페이지빌더 = **김동학(쇼핑개발)** — 지니 결정 260919. CARDS-S §1 A5 「상세페이지·가이드·홈
    # 콘텐츠 = 스킨·페이지빌더 = 실무운영·쇼핑개발」 그대로. (t56 초판은 자사 관리도구로 보아
    # 서희항으로 돌렸으나 그 판단은 철회한다.)
    'pagebuilder': '김동학',
    'mes': '최숙진',          # 생산 현장 · MES 화면은 외부(MES 담당) 개발
}

# ── 직접 열어 확인한 행(manual-read) ───────────────────────────────
# 값 = (판정, 제안담당, 확인한 파일:줄, 메모)
MANUAL = {
    'STD-SYS-008': ('재배정', '서희항',
                    'raw/webadmin/webadmin/catalog/shopby_sync.py:118 sync_main_images · :315 sync_front_display · catalog/shopby_client.py:1-16',
                    '[범위 한정] shopby_sync.py 가 실제로 미는 축은 **메인이미지(:118)와 전시 frontDisplayYn(:315) 둘뿐**이고, '
                    '공통 API 클라이언트는 shopby_client.py 다. 시작가·옵션 등 나머지 상품 축의 push 코드는 이 파일에 없다'
                    '(시작가는 스킨이 webadmin GET /api/w/v1/catalog 를 당겨가는 pull — STD-CAT-043 참조). '
                    '그래도 결론은 유지: 존재하는 동기화 코드는 전부 webadmin 안에 살고 스킨 코드 0 · merged t48:35 owner_side=webadmin 와 일치. '
                    '행이 말하는 「상품 동기화」 전체 범위는 아직 구현 미완이라 status=부분이다'),
    'STD-ADO-002': ('재배정', '서희항',
                    'raw/webadmin/webadmin/catalog/models.py:1078-1093',
                    'TOrdOrders(t_ord_orders)·TOrdArtworks 가 webadmin 모델. 주문 상세의 사양·파일·금액 그릇이 webadmin 에 있다'),
    'STD-ADO-003': ('재배정', '서희항',
                    'raw/webadmin/webadmin/catalog/models.py:1085',
                    'ord_sts(주문상태) 컬럼이 webadmin t_ord_orders. 단건 상태변경 화면은 webadmin 제네릭 admin'),
    'STD-ADP-015': ('담당맞음', '김동학',
                    'huni-skin-shopby/src/app/(main)/product/[slug]/page.tsx:49-56',
                    '스킨은 fetchPublishedDetailTabs 로 발행된 탭을 읽고, 편집 화면은 pagebuilder(vibe-canvas) 쪽이다. '
                    '**페이지빌더 담당 = 김동학(지니 결정 260919)** 이므로 조회·편집이 같은 사람에게 있다 — 분할 불요'),
    'STD-MYP-003': ('분할', '서희항+김동학',
                    'huni-skin-shopby/src/components/product/configurator-actions.tsx:170-176',
                    '스킨 버튼은 onClick 없는 데드 버튼(=김동학 몫). 미리보기 산출물 자체는 Edicus/위젯(=서희항)'),
    'STD-PAY-031': ('분할', '김동학+서희항',
                    'huni-skin-shopby/src/lib/api/widget-order.ts:26-35',
                    'amountToOrderCnt(10원×수량)는 스킨 코드. 그러나 총액 권위는 위젯 handoff/requote(서희항). 표시↔청구 정합은 두 쪽 합의 행'),
    'STD-PAY-013': ('분할', '김동학+서희항',
                    'huni-skin-shopby/src/lib/api/widget-order.ts:26-35',
                    '위변조 검증은 스킨이 부르고 위젯 /handoff/verify 가 판정한다 — 호출측·판정측이 다른 사람'),
    'STD-MFG-001': ('담당맞음', '서희항',
                    'raw/webadmin/webadmin/config/urls.py:268',
                    'api/w/v1/order/register 수신 엔드포인트가 webadmin urls.py 에 실재(주석 「쇼핑몰이 주문 생성 직후 부른다」). 수신측=서희항'),
}

# ── 직접 판단이 필요한 행(수기 오버라이드, 파일은 열지 않음) ────────
# 값 = (판정, 제안담당, 메모)   judged_by 는 merged/evidence 근거를 그대로 유지
OVERRIDE = {
    # PM 이 구현 행을 들고 있다(카드 ④)
    'T3-5': ('분할', '신우진+김동학', '「범위 결정」(PM) + 「스킨 버튼·문의 라우트 구현」(김동학)이 한 행에 섞였다 — 결정/구현 분리'),
    'T5-4': ('담당맞음', '신우진', '발급 주체 결정 = 순수 결정 안건. 구현은 결정 뒤 별도 행'),
    # 위젯/에디터 축인데 PM·운영이 들고 있는 행
    'STD-OPT-053': ('재배정', '서희항', '견적 결과 저장(옵션보관함) = 위젯 상태 저장 축'),
    'STD-OPT-054': ('재배정', '서희항', '견적서 발급 = 가격엔진 산출물'),
    'STD-ART-016': ('재배정', '서희항', 'PitStop 연동 = 경계 정의상 위젯/파이프라인 축(merged lives=webadmin)'),
    'STD-ART-023': ('재배정', '서희항', '에디터 작업물 저장·재편집 = Edicus 연동 계약(위젯 축)'),
    'STD-ART-027': ('분할', '서희항+김동학', '과거 주문 파일 재사용 = 원고 보관(webadmin) + 재주문 진입(스킨)'),
    # 결정 안건은 PM/대표가 맞다
    'STD-SYS-042': ('담당맞음', '신우진', '/admin 존폐 = 결정 안건'),
    'STD-SYS-050': ('분할', '신우진+김동학', '포크 처리 「결정」은 PM, 선별 이식 「구현」은 스킨 담당'),
    'STD-SYS-033': ('담당맞음', '신우진', '사이트 전체 화면·절차 설계 = PM 안건'),
    'STD-SYS-028': ('담당맞음', '신우진', 'webadmin 영역 분리 = 조직·범위 결정'),
    # 사실 기록이지 남은 일이 아니다
    'STD-SYS-027': ('불필요', '—', '「기술 책임 총괄 = CTO 서희항」은 확정 사실 기록이지 작업 행이 아니다 — 원장에서 작업으로 세지 말 것'),
    # 인프라 — 대상 호스트로 갈린다
    'F3-7': ('재배정', '서희항', 'huni-admin.printly.co.kr(관리서버) DNS — 관리서버 담당'),
    'F3-11': ('재배정', '서희항', 'Railway 3서비스 종료 = 관리서버·DB 쪽'),
    'F3-12': ('담당맞음', '신우진', '웹팀 통보 = 커뮤니케이션'),
    # 제목에 결정 키워드가 없지만 실제로는 PM 조달·정책 행
    'STD-PAY-021': ('담당맞음', '신우진', '충전 수납·회계 분리 = 정책 확정 안건'),
    'STD-PAY-024': ('담당맞음', '신우진', '카카오페이 신청 서류·절차 = 대외 조달 행(구현 아님)'),
    'STD-MYP-033': ('담당맞음', '신우진', '보관함 확대 여부 = 범위 결정 안건'),
    'STD-CLM-015': ('분할', '신우진+최숙진', '재제작 처리 「경로 결정」(PM) + 「운영 절차」(실무운영). 화면 근거 없음'),
    'STD-PRM-015': ('미정', '신우진', 'IA r59 기능명 공란 — 무슨 일인지조차 미상. 실측 전 배정 불가'),
    # 알림 발송 주체 경계(order-to-mes-process.md §10): 주문·결제·배송=샵바이 / 파일=우리(webadmin).
    # 파일 관련 알림은 발송 「배선」이 webadmin 코드 = 서희항, 「템플릿 심사·계약」은 최숙진.
    'STD-MFG-125': ('분할', '서희항+최숙진', '파일 오류 재업로드 알림 — 발송 배선(webadmin)=서희항 / 알림톡 템플릿·계약=최숙진'),
    'STD-MFG-126': ('분할', '서희항+최숙진', '재업로드 접수 확인 알림 — 발송 배선=서희항 / 템플릿=최숙진'),
    'STD-MFG-127': ('분할', '서희항+최숙진', '편집상품 수정요청 알림 — 발송 배선=서희항 / 템플릿=최숙진'),
    'STD-MFG-129': ('분할', '서희항+최숙진', '알림톡 실패 시 SMS/LMS 대체 — 대체 로직=서희항 / 채널 계약=최숙진'),
    'STD-MFG-130': ('담당맞음', '최숙진', '발송 주체 경계 준수 = 운영 규약 확인 행(문서로 이미 확정)'),
    'STD-SYS-026': ('담당맞음', '서희항', '유지보수 내부 인력 이관 = 기술 총괄(CTO) 안건'),
    # 콘텐츠 ≠ 화면. 시스템 경계(huni-mall·pagebuilder)가 한 사람으로 모여도
    # 「11종 원고를 쓰는 일」과 「스텁 화면을 채우는 일」은 다른 사람 몫이다.
    'STD-CAT-019': ('분할', '최숙진+김동학',
                    '인쇄 가이드 11종 — 원고·콘텐츠=최숙진 / guide-data.ts 스텁 채우기·화면=김동학'),
    'STD-INF-007': ('분할', '최숙진+김동학',
                    '가이드북 고객 화면 — 작업 유의사항 11종 내용=최숙진 / 화면 구현=김동학'),
    # 「PM 은 만들지 않는다」 보정 — rule-step E3/E4 가 구현 행을 신우진으로 보냈던 자리
    'STD-SYS-017': ('재배정', '서희항',
                    '데이터 백업·복구 절차 = 관리서버·DB 영역(T1 인프라와 같은 손). PM 은 만들지 않는다'),
    'STD-SYS-019': ('담당맞음', '김동학',
                    '반응형/모바일 대응 = 스킨 전 화면 품질축. PM 은 만들지 않는다 — 현 구현 담당 유지'),
    'STD-SYS-022': ('담당맞음', '김동학',
                    '구→신규 URL 리다이렉트 = 스킨 라우팅·도메인. PM 은 만들지 않는다 — 현 구현 담당 유지'),
    'T5-3': ('분할', '김동학+최숙진',
             '법정 표기 단일화(표기 내용=최숙진) + 증빙 화면 목업 제거(스킨 구현=김동학). PM 은 만들지 않는다'),
}

# ── 「도구·화면 = 개발 / 그 안의 내용 = 최숙진」 (지니 260919 역할 ①②) ──────
# 한 행에 화면과 그 화면이 담을 내용이 같이 있는 행만 손으로 고른다(정규식 금지 — 과발화).
CONTENT_SPLIT = {
    'STD-CAT-007': ('김동학+최숙진', '상품 상세페이지 본문 — 이미지·설명 블록 화면=김동학 / 본문 콘텐츠=최숙진(역할②)'),
    'STD-CAT-009': ('김동학+최숙진', '후가공 용어 툴팁 — 툴팁 구현=김동학 / 용어 설명 문구=최숙진(역할②)'),
    'STD-CAT-012': ('김동학+최숙진', '재작업 불가 고지 — guide-data.ts 스텁 채우기=김동학 / 고지 문구=최숙진(역할①)'),
    'STD-CAT-034': ('김동학+서희항+최숙진',
                    '상세페이지 탭 6종 자동 등록 — 자동등록 도구=서희항(webadmin)·표시=김동학(스킨·페이지빌더) / 탭 콘텐츠=최숙진(역할②)'),
    'STD-INF-005': ('김동학+최숙진', '공지사항 고객 화면 — 화면=김동학 / 공지 내용 작성·게시=최숙진'),
    'STD-OPT-057': ('김동학+최숙진', '규격 가이드 모달 — 모달 구현=김동학 / 사이즈 안내 내용=최숙진(역할①)'),
    'STD-OPT-058': ('김동학+최숙진', '주문가능 자재 목록 모달 — 모달 구현=김동학 / 자재 안내 내용=최숙진(역할①)'),
    'STD-ADC-014': ('서희항+최숙진',
                    '인쇄 가이드 콘텐츠 관리 — 관리 화면·도구=서희항 / 표시명·태그·비고 채우기=최숙진(역할①). '
                    '[직접 확인 260919] raw/webadmin/webadmin/config/urls.py:73-74 guide_file_md 화면 실재 · '
                    ':81-83 guide_save 주석 「표시명·태그·순서·비고만 갱신」 · '
                    '_workspace/_foundation/live-snapshot/snap_20260827_1422/t_prd_guide_files.csv 504행/88상품에서 '
                    'orig_file_nm·file_key 는 전건 채워졌는데 guide_nm·tags·note 는 **전건 공란** → 도구는 있고 내용이 비었다. '
                    '[원장 결함] 이 행의 check_method 는 「샵바이 셀러어드민에서 화면이 열리면 완료」인데 evidence 는 webadmin 이다 — 확인처 불일치, 교정 필요'),
}


def load(p):
    with open(p, encoding='utf-8') as f:
        return list(csv.DictReader(f))


def merged_index():
    idx = collections.defaultdict(list)
    for r in load(MERGED):
        for pid in (r['plan_row_id'] or '').replace(';', ' ').replace(',', ' ').split():
            idx[pid.strip()].append(r)
    return idx


EV_PATTERNS = [
    ('huni-mall', r'huni-skin-shopby|huni-skin-next|shopby\.huniprinting\.co\.kr|www\.huniprinting\.com'),
    # order-to-mes-process.md·artwork-scan-integration.md 는 **우리(webadmin) 쪽 설계 문서**다.
    # MES 현행 기능 문서(주문프로세스 PDF·공정관리 시행초안)와 섞으면 안 된다.
    ('webadmin', r'raw/webadmin|huni-admin\.printly\.co\.kr|order-to-mes-process\.md|artwork-scan-integration\.md'),
    ('shopby', r'service\.shopby\.co\.kr'),
    ('mes', r'주문프로세스_20251001|공정관리_시행초안'),
    ('pitstop', r'[Pp]it[Ss]top'),
]


def ev_site(ev):
    for site, pat in EV_PATTERNS:
        if re.search(pat, ev):
            return site
    return ''


PM_OWNERS = {'신우진', '지니', '채훈희', '김용기'}

# 단계(A1~E4·F1~F4) 기본 담당 — CARDS-S §1 「기본 담당」 표를 사람 이름으로 옮긴 것.
# 사는 시스템을 원장·evidence 어디서도 못 짚은 행에만 쓰는 **약한 근거**다.
STEP_OWNERS = {
    'A1': {'최숙진', '서희항'}, 'A2': {'최숙진', '서희항'}, 'A3': {'최숙진', '서희항'},
    'A4': {'최숙진', '서희항'}, 'A5': {'최숙진', '김동학'},
    'B1': {'김동학'}, 'B2': {'서희항'}, 'B3': {'서희항'},
    'B4': {'김동학'}, 'B5': {'김동학'}, 'B6': {'김동학'}, 'B7': {'김동학'},
    'C1': {'서희항', '김동학'}, 'C2': {'서희항'}, 'C3': {'서희항'},
    'C4': {'서희항', '최숙진'}, 'C5': {'서희항', '최숙진'},
    'C6': {'최숙진'}, 'C7': {'서희항', '김동학'},
    'D1': {'최숙진'}, 'D2': {'김동학'}, 'D3': {'김동학', '최숙진'},
    'D4': {'김동학', '최숙진'},
    'E1': {'최숙진'}, 'E2': {'김동학', '신우진'}, 'E3': {'최숙진', '신우진'},
    'E4': {'신우진'},
    'F1': {'서희항'}, 'F2': {'서희항'}, 'F3': {'서희항'}, 'F4': {'김동학'},
    # D5(프린트머니)는 원장 소유 결정 전이라 기본 담당을 두지 않는다.
}


def _pm_guard(rid, owner, verdict, prop, judged_by, basis, note):
    """「PM 은 만들지 않는다」(지니 260919).

    구현·설정 행을 신우진에게 **보내는** 재배정 제안을 막는다. 분할(결정+구현)은 통과 —
    거기서 신우진은 만드는 쪽이 아니라 결정하는 쪽이다.
    """
    if verdict != '재배정' or '신우진' not in prop:
        return verdict, prop, judged_by, basis, note
    rest = [p for p in prop.replace('+', '·').split('·') if p and p != '신우진']
    tag = 'PM 은 만들지 않는다(지니 260919) — 제안에서 신우진 제외. '
    if rest:
        return '재배정', '·'.join(rest), judged_by, basis, tag + (note or '')
    # 신우진 말고 갈 데가 없으면 현 구현 담당을 유지한다(근거가 약해 옮길 수 없다).
    return '담당맞음', owner, judged_by, basis, tag + '대체 담당을 짚지 못해 현 담당 유지(약한 근거·실측 필요). ' + (note or '')


def judge(r, hits):
    rid = r['row_id']
    owner = r['owner_name']

    if rid in MANUAL:
        v, po, path, note = MANUAL[rid]
        return v, po, 'manual-read', path, note

    # 1) merged.csv 가 사는 곳을 적어 둔 행
    def site_of(h):
        # owner_side 가 비었거나 '-' 면 system 이 사는 곳이다(t50 pitstop 행 실측).
        os_ = (h['owner_side'] or '').strip()
        return os_ if os_ and os_ != '-' else (h['system'] or '').strip()

    sites = sorted({s for s in (site_of(h) for h in hits) if s})
    judged_by, basis = '', ''
    if sites:
        judged_by = 'merged-owner_side'
        basis = 'merged.csv ' + ','.join(h['row_uid'] for h in hits[:3]) + ' owner_side/system=' + ','.join(sites)
    else:
        s = ev_site(r['evidence'])
        if s:
            sites = [s]
            judged_by = 'evidence-path'
            basis = r['evidence'][:120]
        else:
            judged_by = 'rule-track'
            basis = r['evidence'][:120]

    note = ''
    # 외부·대표·미정 담당은 재판정 대상 밖(경계는 사내 4담당에 대한 것)
    if owner.startswith('외부') or owner in ('대표(구매)', '미정'):
        v, po = '미정', owner
        note = '사내 4담당 경계 밖(외부·미정) — 이번 재판정 대상 아님'
        if rid in OVERRIDE:
            v, po, note = OVERRIDE[rid]
        return v, po, judged_by, basis, note

    if rid in OVERRIDE:
        v, po, note = OVERRIDE[rid]
        return v, po, judged_by, basis, note

    if not sites:
        # 사는 곳을 못 짚었다 → 결정 안건인지 먼저 보고, 아니면 단계 기본 담당(약한 근거)
        if re.search(r'결정|확정|미결|선행 입력|협의|판단|주체|범위 산정', r['title']):
            if owner in PM_OWNERS:
                return '담당맞음', owner, judged_by, basis, '결정·조율 안건 — PM/대표가 맞다'
            return '분할', f'{owner}+신우진', judged_by, basis, \
                '결정 안건이 실무 담당에게 걸려 있다 — 결정(PM)/실행(담당) 분리'
        step = r['step']
        if step in STEP_OWNERS:
            cand = STEP_OWNERS[step]
            if owner in cand:
                return '담당맞음', owner, 'rule-step', basis, \
                    f'사는 시스템 미확인 — 단계 {step} 기본 담당과 일치(약한 근거)'
            return '재배정', '·'.join(sorted(cand)), 'rule-step', basis, \
                f'사는 시스템 미확인 — 단계 {step} 기본 담당과 불일치(약한 근거·실측 필요)'
        return '미정', owner, judged_by, basis, \
            '사는 시스템도 단계 기본 담당도 못 짚음(D5 프린트머니 등) — 실측·결정 필요'

    # 여러 곳에 걸치면 분할
    if len(sites) > 1:
        props = sorted({SITE_OWNER.get(s, '미정') for s in sites})
        if len(props) == 1:
            prop = props[0]
            return ('담당맞음' if prop == owner else '재배정'), prop, judged_by, basis, \
                '여러 시스템에 걸치나 담당은 한 사람(' + ','.join(sites) + ')'
        return '분할', '+'.join(props), judged_by, basis, \
            '두 시스템에 걸침(' + ','.join(sites) + ') — 행을 나눠 각자에게'

    site = sites[0]
    prop = SITE_OWNER.get(site, '미정')

    # 외부 제품이 그대로 하는 일(t51 work_type=provided) — 우리 개발 일이 아니다.
    if hits and all(h['work_type'] == 'provided' for h in hits):
        return 'provided', prop, judged_by, basis, \
            '외부 제품 제공 기능(t51 work_type=provided) — 개발 일 아님. 연동·확인만 ' + prop

    # shopby(셀러어드민)에 사는 행: 우리 코드가 0 → 제공 / 설정·운영
    if site == 'shopby':
        if r['status'] in ('작동',):
            return 'provided', '최숙진', judged_by, basis, \
                '셀러어드민 기본 제공 기능이 이미 작동 — 개발 일 아님(확인·설정만)'
        return ('담당맞음' if owner == '최숙진' else '재배정'), '최숙진', judged_by, basis, \
            '셀러어드민 설정·운영(코드 0)'

    if site == 'mes':
        return ('담당맞음' if owner == '최숙진' else '재배정'), '최숙진', judged_by, basis, \
            'MES 현행 기능·생산 현장 운영 — 신규 개발이면 외부(MES 담당)'

    if prop == owner:
        return '담당맞음', owner, judged_by, basis, ''
    return '재배정', prop, judged_by, basis, f'그 일이 사는 곳={site}'


def main():
    idx = merged_index()
    rows = load(PLAN)
    out = []
    for r in rows:
        rid = r['row_id']
        hits = idx.get(rid, [])
        v, po, jb, basis, note = judge(r, hits)
        # 도구/내용 분리(최숙진 역할 ①②) — MANUAL·OVERRIDE 보다 뒤에 건다.
        if rid in CONTENT_SPLIT:
            po, cnote = CONTENT_SPLIT[rid]
            v = '분할'
            note = cnote
        # PM 은 만들지 않는다 — 마지막 게이트.
        v, po, jb, basis, note = _pm_guard(rid, r['owner_name'], v, po, jb, basis, note)
        out.append({
            'row_id': r['row_id'],
            'track': r['track'],
            'step': r['step'],
            'title': r['title'],
            'status': r['status'],
            'owner_now': r['owner_name'],
            # 남은 일 여부 = status 가 진다(CONTRACT 보충 3). 작동/완료는 남은 일 아님.
            'remaining': 'N' if r['status'] in ('작동', '완료') else 'Y',
            'verdict': v,
            'owner_proposed': po,
            'judged_by': jb,
            'basis': basis,
            'note': note,
            'evidence': r['evidence'],
        })
    with open(OUT, 'w', encoding='utf-8', newline='') as f:
        w = csv.DictWriter(f, fieldnames=list(out[0].keys()))
        w.writeheader()
        w.writerows(out)
    print('rejudge.csv', len(out), '행')
    print('\n[verdict]', dict(collections.Counter(o['verdict'] for o in out)))
    print('[judged_by]', dict(collections.Counter(o['judged_by'] for o in out)))
    print('\n[owner_now → verdict]')
    c = collections.Counter((o['owner_now'], o['verdict']) for o in out)
    for k, v in sorted(c.items()):
        if k[0] in ('김동학', '서희항', '최숙진', '신우진'):
            print(' ', k, v)


if __name__ == '__main__':
    main()
