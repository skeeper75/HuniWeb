# t66 — 네 카드(t62·t63·t64·t65) 병합 공용 모듈.
# 원칙: 네 카드의 산출물을 읽기만 한다. 고치지 않는다. 원장(t56/rejudge.csv)에 새 행을 만들지 않는다.
import csv
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
PROC = os.path.dirname(HERE)                      # .../09_process
RUNWAY = os.path.dirname(PROC)                    # .../huni-launch-runway
LEDGER = os.path.join(RUNWAY, '08_system-screen', 't56', 'rejudge.csv')

CARDS = ['t62', 't63', 't64', 't65']
CARD_TITLE = {
    't62': '회원·마이페이지·프로모션·B2B',
    't63': '탐색~결제(카탈로그·옵션·원고·장바구니·주문·결제·배송)',
    't64': '주문 이후 생산·검판·출고',
    't65': '클레임·CS·운영자 상품가격·정산·시스템',
}


def read_csv(path):
    with open(path, encoding='utf-8') as f:
        return list(csv.DictReader(f))


def ledger_rows():
    return read_csv(LEDGER)


# ---------------------------------------------------------------- 나무 정규화
# 카드마다 열 이름이 다르다. 여기서 한 벌로 맞춘다 — 값은 그대로 옮기고 새로 만들지 않는다.

def _norm_t62_t65(card, rows):
    out = []
    for r in rows:
        out.append(dict(
            card=card, L1=r['L1'], L2=r['L2'],
            process_id=r['process_id'], process_name=r['process_name'],
            step_no=r['step_no'], step=r['step'], row_id=r['row_id'].strip(),
            기능=r['기능'], 시스템=r['시스템'], 담당자=r['담당자'], 상태=r['상태'],
            근거=r['근거'], cross=r['cross'],
            귀속='담당' if r['row_id'].strip() else '단계',
        ))
    return out


def _norm_t63(card, rows):
    out = []
    for r in rows:
        out.append(dict(
            card=card, L1=r['L1_대분류'], L2=r['L2_중분류'],
            process_id=r['L3_프로세스'], process_name=r['L3_프로세스명'],
            step_no=r['L4_순번'], step=r['기능'], row_id=r['row_id'].strip(),
            기능=r['기능'], 시스템=r['시스템'], 담당자=r['담당자'], 상태=r['상태'],
            근거=r['근거'], cross=r['cross'],
            귀속='담당' if r['row_id'].strip() else '단계',
        ))
    return out


def _norm_t64(card, rows):
    out = []
    for r in rows:
        pid, _, pname = r['L3_프로세스'].partition('-')
        out.append(dict(
            card=card, L1=r['L1_대분류'], L2=r['L2_중분류'],
            process_id=pid, process_name=pname.replace('-', ' · '),
            step_no=r['step'], step=r['기능'], row_id=r['L4_단계_row_id'].strip(),
            기능=r['기능'], 시스템='', 담당자=r['owner_proposed'], 상태=r['status'],
            근거=r['원장출처'], cross=r['cross'],
            귀속=r['귀속'] if r['L4_단계_row_id'].strip() else '단계',
        ))
    return out


NORM = {'t62': _norm_t62_t65, 't63': _norm_t63, 't64': _norm_t64, 't65': _norm_t62_t65}


def merged_tree():
    """네 카드의 process-tree.csv 를 한 벌 열 이름으로 이어 붙인다."""
    out = []
    for c in CARDS:
        rows = read_csv(os.path.join(PROC, c, 'process-tree.csv'))
        out.extend(NORM[c](c, rows))
    return out


def owned_ids(tree):
    return {r['row_id'] for r in tree if r['귀속'] == '담당' and r['row_id']}


def premise_rows(tree):
    """원장 735행 중 네 카드 어디에도 담당으로 들어가지 않은 나머지 — 전제 행."""
    owned = owned_ids(tree)
    return [r for r in ledger_rows() if r['row_id'].strip() not in owned]


# ---------------------------------------------------------------- 빠진 곳 정규화
GAP_KIND = {'가': '가 — 원장에 행 없음', '나': '나 — 행은 있는데 코드 0',
            '다': '다 — 코드는 있는데 연결 안 됨', '라': '라 — 결정 미정'}


def kind_letter(s):
    s = s.strip()
    return s[0] if s and s[0] in '가나다라' else ''


def merged_gaps():
    """네 카드 gaps.csv 를 한 벌 열 이름으로 모은다.

    gap_uid 는 **카드별로 매긴다**(`GX-t64-007`). 통번호로 매기면 한 카드의 건수가 바뀔 때
    뒤 카드의 번호가 통째로 밀려 인용이 깨진다 — 260919 t64 정정(65→169)에서 실제로 겪었다.
    """
    out = []
    n = {c: 0 for c in CARDS}

    def push(card, pid, pname, kind, 내용, 담당, 선행, rowref, 담당근거=''):
        n[card] += 1
        out.append(dict(
            gap_uid='GX-%s-%03d' % (card, n[card]), card=card, process_ref=pid, process_name=pname,
            종류=kind, 종류설명=GAP_KIND.get(kind, ''), 내용=내용.strip(),
            제안담당=담당.strip(), 담당_근거=담당근거.strip(),
            선행=선행.strip(), 관련_row_id=rowref.strip(),
        ))

    for r in read_csv(os.path.join(PROC, 't62', 'gaps.csv')):
        push('t62', r['process_id'], r['process_name'], kind_letter(r['종류']),
             r['내용'], r['제안담당'], r['선행'], r['gap_id'])
    for r in read_csv(os.path.join(PROC, 't63', 'gaps.csv')):
        push('t63', r['프로세스'], r['프로세스명'], kind_letter(r['종류']),
             r['내용'] + (' — ' + r['진단'] if r['진단'].strip() else ''),
             r['제안 담당'], r['선행'], r['row_id'])
    # t64 만 `담당_근거` 열을 갖는다(260919 lane-4 보강). 다른 세 카드는 빈칸으로 둔다 — 만들어 넣지 않는다.
    for r in read_csv(os.path.join(PROC, 't64', 'gaps.csv')):
        push('t64', r['프로세스'], '', kind_letter(r['종류']),
             r['내용'], r['제안_담당'], r['선행'], r['관련_row_id'], r.get('담당_근거', ''))
    for r in read_csv(os.path.join(PROC, 't65', 'gaps.csv')):
        push('t65', r['process_id'], r['process_name'], kind_letter(r['종류']),
             r['내용'], r['제안담당'], r['선행'], r['gap_id'])
    return out


# ---------------------------------------------------------------- 뿌리(root_cause)
# 규칙표. 위에서부터 처음 걸리는 뿌리로 간다 — 결정론이고, 걸린 낱말을 함께 적어 되짚을 수 있게 한다.
# 낱말은 네 카드가 실제로 쓴 표현에서만 뽑았다. 새 주장을 만들지 않는다.
ROOT_RULES = [
    ('RC-01', '프린팅머니 원장 소유 미결(A 샵바이 적립금 vs B′ 후니 원장+외부포인트)',
     r'프린팅?[트팅]?머니|프린트머니|외부포인트|충전|가상계좌|선불|잔액 이관'),
    ('RC-02', 'order/register 주문등록 S2S — 제공자는 살아 있고 호출측이 없다',
     r'order/register|orderRegister|order_register|S2S|주문등록'),
    ('RC-03', 'MES WCF 스펙 미확보(BLK-S2-3) — 생산 다리가 통째로 비어 있다',
     r'MES|WCF|WSDL|조판|접수파일|품목코드|mes_item|바코드'),
    ('RC-04', 'PitStop 구매·검판 경로 미결(BLK-S2-4 · T4-3)',
     r'PitStop|핫폴더|프리플라이트|preflight|검판|바이러스|clamav'),
    ('RC-05', '샵바이 Server API — 명세는 완비인데 호출 코드가 0',
     r'샵바이|Shopby|shopby|Shop API|Server API|셀러어드민|claims/|prepare-|update-invoices'),
    ('RC-06', '웹훅 수신·재전송 설계 부재(유실분이 영영 안 온다)',
     r'웹훅|webhook|SQS|재전송|이벤트 구독'),
    ('RC-07', 'huni-skin-next 포크·코드베이스 정비 미결',
     r'huni-skin-next|포크|워크트리|Prisma|미병합|브랜치 정리|CI'),
    ('RC-08', '결제수단 개통·외부 계약 회신 대기(토스·카카오페이·이니시스)',
     r'토스|카카오페이|이니시스|포트원|가맹점|수수료|PG 계약|결제수단 범위'),
    ('RC-09', '알림 채널 결정·카카오 심사(리드타임이 우리 통제 밖)',
     r'알림톡|카카오 심사|SMS|LMS|발송 템플릿|수신동의|알림 채널'),
    ('RC-10', '구 사이트 회원·잔액 이관과 컷오버 동결 창',
     r'구 사이트|이관|컷오버|스냅샷|휴면|일괄등록|delta'),
    ('RC-11', '상품·가격 원천 이원화(webadmin ↔ 샵바이 동기화)',
     r'시작가|salePrice|동기화|shopby_sync|단일 출처|원천|이원|카탈로그 원천'),
    ('RC-12', 'webadmin 운영자 화면 부재(주문 축이 통째로 없다)',
     r'운영자 화면|주문 운영|관리자 화면|webadmin 에 .{0,12}화면|admin 화면|목록 화면'),
    ('RC-13', '에디터(Edicus)·보관함 연동 미결',
     r'에디터|Edicus|에디쿠스|보관함|편집기|템플릿 없음'),
    ('RC-14', '증빙·세무 규칙 미확정(세금계산서·현금영수증)',
     r'세금계산서|현금영수증|증빙|세무|계산서'),
    ('RC-15', '주문상태 단위·상태머신 미정비',
     r'ord_sts|상태머신|상태 값|주문상태|상태 전이|13칸'),
    ('RC-16', '배송·택배사 코드 매핑과 출고 처리',
     r'택배|송장|deliveryCompany|배송추적|출고|합배송|수거'),
    ('RC-17', '옵션·제약·위젯 배선(가격 축)',
     r'제약규칙|옵션그룹|위젯|use_dims|차원|판형|가격공식|단가행'),
    ('RC-18', '회원·인증·권한 정책 미확정',
     r'로그인 식별자|소셜|본인인증|회원등급|권한|감사로그|탈퇴'),
    ('RC-19', '게시판·문의·리뷰 응대 운영',
     r'게시판|문의|Q&A|리뷰|후기|블라인드|체험단'),
    ('RC-20', 'B2B 거래처·후불 여신 범위 미확정',
     r'B2B|거래처|여신|후불|대량견적|기업회원'),
    ('RC-21', '1차 런칭 범위·오픈 일정 미확정(무엇을 빼는가가 먼저다)',
     r'1차 ?(런칭 ?)?범위|1차 오픈|1차에 (넣|포함)|오픈 목표일|런칭 범위|1차 런칭'),
    ('RC-22', '레거시·더미 콘텐츠 잔존·하드코딩(운영자가 못 고친다)',
     r'더미|목업|mock|레거시|legacy|스텁|하드코딩|상수|준비 중|잔존'),
    ('RC-23', '실측으로 확인하지 못했다(코드·화면을 찾지 못함)',
     r'찾지 못했|확인하지 못했|관측되지 않|미확인|미검증'),
]
ROOT_OTHER = ('RC-99', '공통 뿌리 없음 — 그 구간의 개별 건(사람이 읽어야 한다)')


def root_cause(gap):
    text = ' '.join([gap['내용'], gap['선행'], gap['process_name'], gap['관련_row_id']])
    for rid, label, pat in ROOT_RULES:
        m = re.search(pat, text)
        if m:
            return rid, label, m.group(0)
    return ROOT_OTHER[0], ROOT_OTHER[1], ''


ROOT_LABEL = {rid: label for rid, label, _ in ROOT_RULES}
ROOT_LABEL[ROOT_OTHER[0]] = ROOT_OTHER[1]
