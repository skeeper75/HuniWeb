# -*- coding: utf-8 -*-
"""P1 — 미판정 143행 판정표.

각 항목: std_id -> (상태, 근거보강, 비고추가)
상태 ∈ done / partial / todo / new / 미판정
「done」은 file:line 필수(코드 경로 존재 = done, 운영 성공 아님을 비고에 적는다).
근거는 전부 2026-09-02 실측(webadmin 저장소 · huni-skin-shopby 저장소 · 문서 체크박스).
"""

WA = "raw/webadmin/webadmin/catalog/"
SK = "huni-skin-shopby/src/"
CODEONLY = "코드 경로 존재 = done · 운영 성공 아님(라이브 실행 0건)"
MANUAL = "10/6 범위 「수동 대체」 — 현행 MES·수기 경로로 운영(auto-vs-human.md §2)"

J = {
# ── MES연동 21 (권위: order-to-mes-process.md §11 체크박스 + 코드 실측) ──
"STD-MFG-001": ("done", "raw/webadmin/webadmin/config/urls.py:267 api_order_register · §11 0단계 [x]", CODEONLY),
"STD-MFG-002": ("done", WA+"widget_api.py:4314,4329 _ord_row_response(already=False/True) · §11 0단계 [x]", CODEONLY),
"STD-MFG-003": ("done", WA+"models.py:1043 TOrdOrders · §6.5", CODEONLY),
"STD-MFG-004": ("done", WA+"artwork_promote.py:173 S3.copy_to_order · §11 1단계 [x]", CODEONLY+" · 승격 실행 0건"),
"STD-MFG-005": ("done", WA+"artwork_promote.py:159 S3.head_object · :155 _promote_one", CODEONLY),
"STD-MFG-006": ("done", WA+"artwork_promote.py:51 ORD_HOLD", CODEONLY),
"STD-MFG-007": ("todo", "§11 1단계 「(남음) 담당자용 보류 주문 목록 화면」 — 미체크", "지금은 DB 조회로만 확인 가능"),
"STD-MFG-008": ("done", WA+"s3_artwork.py:135 build_order_key(rev=1)", CODEONLY),
"STD-MFG-009": ("done", WA+"artwork_promote.py:296 latest_artworks · models.py:1086", CODEONLY),
"STD-MFG-010": ("partial", "입력·중복검증 UI 는 상품 편집 화면에 실재 · 라이브 실측 260902 269개 중 15개만 채움 · §11 2단계 미체크", "일괄 적재분이 남음(5.6%)"),
"STD-MFG-011": ("done", WA+"admin.py:2099 clean_mes_item_cd (부분 유니크 ux_t_prd_products_mes_item_cd)", CODEONLY),
"STD-MFG-012": ("todo", "§11 2단계 「목록에는 빠져 있어 현황 파악이 어려움」", ""),
"STD-MFG-013": ("new", "§11 2단계 미체크 · webadmin 전수 grep 'MES_SENT|mes_send|api_mes' 0건(260902)", "MES WCF 스펙 미확정(§12-1)"),
"STD-MFG-014": ("new", "§11 2단계 「중복 전송 방지 도장」 미체크 · 코드 0건", ""),
"STD-MFG-015": ("new", "§8.3 MES-2 · 코드 0건", ""),
"STD-MFG-016": ("new", "§8.3 MES-3 · 코드 0건", ""),
"STD-MFG-017": ("new", "§8.3 MES-4 · 코드 0건", ""),
"STD-MFG-018": ("new", "§8.3 MES-5 · 코드 0건", ""),
"STD-MFG-019": ("new", "§11 2단계 「우리가 제공할 API 4종 정의서」 미작성 · 코드 0건", "VPC 사설경로 설계만 존재"),
"STD-MFG-020": ("new", "aws-architecture-huni.pdf p.7 §3.2 설계만 · SQS 코드 0건", "인프라 신설"),
"STD-MFG-021": ("new", "§11 5단계 미체크 · DLQ 코드 0건", ""),

# ── 상태왕복 14 ──
"STD-MFG-022": ("partial", WA+"artwork_promote.py:49-52 (REGISTERED/PROMOTING/PROMOTED/HOLD 4종 실재) · models.py:1070 ord_sts · §11 2단계 「주문 상태머신」 미체크",
                "MES_SENT·IN_PRODUCTION·PRODUCED·SHIPPED·DONE·CANCELED 6종 미구현"),
"STD-MFG-023": ("partial", WA+"models.py:1063 shop_line_no · :1078 unique_together(site_cd,shop_ord_no,shop_line_no)", "주문 단위 롤업 로직 미구현"),
"STD-MFG-024": ("partial", WA+"models.py:1043 TOrdOrders(handoff·shop_ord_no·shop_line_no 보유)", "MES 작업번호 칸 미신설"),
"STD-MFG-025": ("new", "§8.4 FR-1 · 코드 0건", ""),
"STD-MFG-026": ("new", "§7.3 취소 경합 CAS · §11 2단계 미체크 · 코드 0건", "돈·주문 직결"),
"STD-MFG-027": ("new", "§8.2 TO-2 · §11 3단계 미체크 · 코드 0건", ""),
"STD-MFG-028": ("new", "§8.4 FR-2 · 코드 0건", ""),
"STD-MFG-029": ("new", "§8.2 TO-3 · §11 3단계 미체크 · 코드 0건", ""),
"STD-MFG-030": ("new", "§8.1 SB-2 분기표 설계만 · 코드 0건", ""),
"STD-MFG-031": ("new", "§8.4 FR-3 · §8.2 TO-4 · 코드 0건", ""),
"STD-MFG-032": ("new", "§8.4 FR-5 · §8.2 TO-5 · §11 5단계 미체크 · 코드 0건", ""),
"STD-MFG-033": ("new", "§7.3 원칙 2·3 설계만 · 코드 0건", "사람 에스컬레이션 경로도 미구현"),
"STD-MFG-034": ("new", "§8.4 FR-7 · §8.2 TO-6 · §11 5단계 미체크 · 코드 0건", ""),
"STD-MFG-035": ("new", "§8.4 「MES 쪽 화면 작업(신규)」 — MES WinForms 신규 개발", "우리 저장소 밖(MES 담당)"),

# ── 프리플라이트 17 (§11 4단계 전부 미체크 · PitStop Server+n8n 선행) ──
"STD-MFG-036": ("new", "§11 4단계 「바이러스 검사 연결」 미체크 · artwork-scan-integration.md 설계만", "PitStop Server+n8n 선행"),
"STD-MFG-037": ("new", "artwork-scan-integration.md ③ 설계만 · 코드 0건", ""),
"STD-MFG-038": ("new", "artwork-scan-integration.md 시그니처 신선도 — 설계만", ""),
"STD-MFG-039": ("new", "artwork-scan-integration.md ⚠주의 3 — 설계만", ""),
"STD-MFG-040": ("new", "artwork-scan-integration.md n8n 배치 초안 — 설계만", ""),
"STD-MFG-044": ("new", "§5.2 A목록 · §11 4단계 미체크", "PitStop 판정 코드 매핑표 미작성"),
"STD-MFG-046": ("new", "§5.2 A목록 · §11 4단계 미체크", ""),
"STD-MFG-048": ("new", "§5.2 A목록 · §11 4단계 미체크", ""),
"STD-MFG-049": ("new", "§5.2 3갈래 표 — 설계만 · §11 4단계 미체크", ""),
"STD-MFG-050": ("todo", "§5.2 · §12-6 「접수담당자와 최종 확정」 — 목록 확정이 먼저", "코드 아닌 합의 항목"),
"STD-MFG-051": ("new", "§8.4 FR-6 · 코드 0건", ""),
"STD-MFG-052": ("new", "artwork-scan-integration.md 감사 기록 — 설계만 · 그릇 없음", ""),
"STD-MFG-053": ("new", "artwork-scan-integration.md 작업 폴더 정책 — 설계만", ""),
"STD-MFG-054": ("new", "§5.3 · §8.4 FR-4 · §11 4단계 미체크", ""),
"STD-MFG-055": ("new", "§5.3 재업로드 화면 · §11 4단계 미체크", "위젯 업로드 컴포넌트 재사용 예정"),
"STD-MFG-056": ("new", "§5.3 · §11 4단계 미체크", ""),
"STD-MFG-057": ("new", "§5.3 마지막 문단 — 설계만", "고객 취소권 보존 — 돈·주문 직결"),

# ── 접수·검판 13 (권위: 주문프로세스 PDF · auto-vs-human §2.2) ──
"STD-MFG-058": ("todo", "auto-vs-human.md §2.2 #22 「접수파일 등록」 🧑 · §5 A-2 「MES 화면인지 신규 화면인지 미확정」", MANUAL+" · 범위 미결 A-2"),
"STD-MFG-059": ("미판정", "PDF p.11 §09 case1 · auto-vs-human §2.2 #24 「지금」 칸이 「—」", "판정 불가 사유 — 현행 MES 구현 여부 미확인(MES 소스 없음)"),
"STD-MFG-060": ("미판정", "PDF p.11 §09 case1 · auto-vs-human §5 A-4 「랜더링 트리거 주체 색 판독 불가」", "판정 불가 사유 — A-4 미확인"),
"STD-MFG-061": ("미판정", "PDF p.11 §09 server · auto-vs-human §5 A-3 「server 가 어느 서버인가 미확인」", "판정 불가 사유 — A-3 미확인"),
"STD-MFG-062": ("todo", "PDF p.11 §09 case2 — 현행 담당자가 JPG 동반 업로드", MANUAL),
"STD-MFG-064": ("new", "auto-vs-human §2.2 #37·#38 — 편집기 수정요청/수정완료 왕복 미구현", "고객 왕복(T-H2) — 알림 67·68 도 우리 몫 미구현"),
"STD-MFG-065": ("todo", "auto-vs-human §2.2 #26 🧑 · §5 A-2 범위 미결", MANUAL+" · 범위 미결 A-2"),
"STD-MFG-066": ("todo", "auto-vs-human §2.2 #27 🧑", MANUAL),
"STD-MFG-067": ("todo", "auto-vs-human §2.2 #28 🧑(🟩) · §5 A-2 범위 미결", MANUAL+" · 범위 미결 A-2"),
"STD-MFG-068": ("todo", "auto-vs-human §2.2 #29·#30 — 빨간점은 🤖, 제작중 전환은 🧑(🟢)", MANUAL),
"STD-MFG-069": ("todo", "PDF p.4 §04 마스터관리 — 현행 MES 기능", MANUAL),
"STD-MFG-070": ("todo", "PDF p.10 §10 주문관리 — 현행 수기(EXCEL)", MANUAL),
"STD-MFG-071": ("todo", "auto-vs-human §2.7 #83 「전부 수기」", MANUAL),

# ── 조판·파일가공 10 ──
"STD-MFG-072": ("todo", "auto-vs-human §2.2 #18 🧑 ✅현행 수기", MANUAL),
"STD-MFG-073": ("todo", "auto-vs-human §2.2 #19 🧑 ✅현행 수기", MANUAL),
"STD-MFG-074": ("todo", "auto-vs-human §2.2 #20 🧑 ✅현행 수기(조판=판단작업 T-M2)", MANUAL),
"STD-MFG-075": ("todo", "PDF p.5 §05 조판 ⓛ — 현행 수기", MANUAL),
"STD-MFG-076": ("todo", "PDF p.5 §05 조판 ➂ — 현행 수기", MANUAL),
"STD-MFG-077": ("todo", "auto-vs-human §2.2 #33 🧑 ✅현행 수기", MANUAL),
"STD-MFG-078": ("new", "auto-vs-human §4 G-3 「100% 파일명 수동 수정」 → 자동 RENAME 은 미구현", "자동화 격차 G-3"),
"STD-MFG-079": ("new", "PDF p.6-7 §06 규칙 8종 — 규약 문서만, 코드 0건", "G-3 종속"),
"STD-MFG-080": ("todo", "PDF p.12 §06-1 — 현행 수기 배치", MANUAL),
"STD-MFG-081": ("todo", "auto-vs-human §2.2 #17 🧑 ✅현행 수기", MANUAL),

# ── 공정관리 17 ──
"STD-MFG-082": ("done", WA+"models.py:586 TProcProcesses · raw/webadmin/tools/manual_content.py:623", CODEONLY+" · webadmin 공정 마스터 화면 운영 중"),
"STD-MFG-083": ("done", WA+"models.py:491 TPrdProductProcesses · manual_content.py:158", CODEONLY+" · 상품뷰어 공정 섹션 운영 중"),
"STD-MFG-084": ("new", "공정관리 시행초안 p.1 §02 — 18케이스 라우트 정의서만, 그릇 없음", "L0/M3/process-route.md 참조"),
"STD-MFG-085": ("new", "공정관리 시행초안 p.1 §02 — 설계만", ""),
"STD-MFG-086": ("new", "PDF p.10 §10 「상품마스터(공정) SHEET 참고」 — 매핑 그릇 없음", "라우트 마스터(084) 선행"),
"STD-MFG-087": ("todo", "공정관리 시행초안 p.2 공정별 현황표 — 팀 7종 실재(현행 운영)", MANUAL),
"STD-MFG-088": ("todo", "auto-vs-human §2.3 #45 🧑작업자 ✅현행 · §5 A-1 「특수인쇄가공팀 칸 비어 있음」", MANUAL+" · 특수인쇄가공팀 신호는 미확인(A-1)"),
"STD-MFG-089": ("todo", "공정관리 시행초안 p.1 To Do List — 현행 수기", MANUAL),
"STD-MFG-090": ("미판정", "auto-vs-human §5 A-5 「interlock 을 MES 가 이미 구현했는지 미확인 — MES 소스 없음」", "판정 불가 사유 — A-5 미확인(자동화 격차 G-10 후보)"),
"STD-MFG-091": ("todo", "PDF p.9 §03-1 · p.11 §09 — 현행 MES 권한 운영", MANUAL),
"STD-MFG-092": ("todo", "PDF p.9 §03-1 — 규약 존재, 현행 수기 준수", MANUAL),
"STD-MFG-093": ("todo", "auto-vs-human §2.3 #43 🤖(🔴) 「지금」 칸 「—」 · 현행 MES 자동", MANUAL),
"STD-MFG-094": ("todo", "공정관리 시행초안 p.2 현황표 — 현행 운영", MANUAL),
"STD-MFG-095": ("todo", "공정관리 시행초안 p.1 산출데이터 1차 — 현행 운영", MANUAL),
"STD-MFG-096": ("new", "공정관리 시행초안 p.1 산출데이터 2차 「공정라우트 설정 후」 — 084 선행", "084·085·086 종속"),
"STD-MFG-098": ("todo", "PDF p.4 §04 생산 — 현행 MES 운영", MANUAL),
"STD-MFG-099": ("partial", WA+"widget_api.py:1226 case_cnt_rule · :1252 parse_case_cnt (건수 산출은 실재)", "MES 작업 분해 규칙은 §12-11 미협의 · 원장 근거의 widget_api.py:3388 은 오기(실제 1226·1252)"),

# ── 외주 5 ──
"STD-MFG-100": ("todo", "auto-vs-human §2.2 #31 🧑 ✅현행 수기", MANUAL),
"STD-MFG-101": ("todo", "auto-vs-human §2.2 #32 🧑 판단작업", MANUAL),
"STD-MFG-102": ("todo", "auto-vs-human §2.2 #34 🧑 ✅현행 수기", MANUAL),
"STD-MFG-103": ("todo", "PDF p.4 §04 외주관리 — 현행 MES 운영", MANUAL),
"STD-MFG-104": ("todo", "auto-vs-human §2.3 #47 🧑외주관리자 ✅현행", MANUAL),

# ── 포장·출고 13 ──
"STD-MFG-106": ("todo", "auto-vs-human §2.4 #49 🧑출고팀 ✅현행", MANUAL),
"STD-MFG-107": ("todo", "auto-vs-human §2.4 #53 🧑 ✅현행", MANUAL),
"STD-MFG-108": ("todo", "auto-vs-human §2.4 #50·#51 🧑(🟩)+🤖 ✅현행", MANUAL),
"STD-MFG-109": ("todo", "auto-vs-human §2.4 #52 🤖(🔴) ✅현행 MES 자동", MANUAL),
"STD-MFG-110": ("todo", "auto-vs-human §2.4 #57·#58 ✅현행", MANUAL),
"STD-MFG-111": ("todo", "auto-vs-human §2.4 #54 🧑(🟩) ✅현행", MANUAL),
"STD-MFG-112": ("todo", "auto-vs-human §2.4 #55 🧑(🟩) ✅현행", MANUAL),
"STD-MFG-113": ("todo", "auto-vs-human §2.4 #56 🧑(🟩) ✅현행", MANUAL),
"STD-MFG-114": ("new", "auto-vs-human §4 G-9 「한 주문 1송장 → 여러 송장」 자동화 격차 — 미구현", "G-9"),
"STD-MFG-115": ("new", "auto-vs-human §4 G-6 「장바구니 + 합배송」 자동화 격차 — 식별 로직 미구현", "G-6"),
"STD-MFG-116": ("todo", "PDF p.3 §03 하단 — 현행 정책(오프라인 주문 외 단일 출고지)", MANUAL),
"STD-MFG-117": ("todo", "PDF p.4 §04 출고 · 공정관리 PDF Case16 — 현행 운영", MANUAL),
"STD-MFG-118": ("todo", "PDF p.4 §04 출고 ★썸네일 보는 화면 — 현행 MES 화면", MANUAL),

# ── 재제작·반송 6 ──
"STD-MFG-119": ("todo", "auto-vs-human §2.6 #78 🧑MES ✅현행(주문복사)", MANUAL),
"STD-MFG-120": ("todo", "auto-vs-human §2.6 #78 🧑MES ✅현행", MANUAL),
"STD-MFG-121": ("todo", "auto-vs-human §2.6 #79 🧑 ✅현행(Nfocus 반송요청)", MANUAL),
"STD-MFG-122": ("todo", "PDF p.7 §07 정산관련 — 현행 메모 운영", MANUAL+" · 돈 직결"),
"STD-MFG-123": ("todo", "PDF p.7 §07 재출고 — 현행 수기 신규송장", MANUAL),
"STD-MFG-124": ("new", "§7.4 「반품·교환 웹훅은 기록만」 — 웹훅 수신함은 실재하나 클레임 분기 코드 0건", "§11 3단계 TO-5 미체크"),

# ── 알림 6 ──
"STD-MFG-125": ("new", "auto-vs-human §2.5 #67 「❌ 우리 몫 · 미구현」 · §11 4단계 미체크", "알림 경계: 파일 알림만 우리"),
"STD-MFG-126": ("new", "§10 — 재업로드 접수 확인 알림 미구현", ""),
"STD-MFG-127": ("new", "auto-vs-human §2.5 #68 「❌ 우리 몫 · 미구현」", ""),
"STD-MFG-128": ("todo", "§10 실무 주의 「심사 기간 때문에 일정에 영향」 · §12-7 채널 미확정", "125·127 선행 · 외부 심사 리드타임"),
"STD-MFG-129": ("new", "§10 · §12-7 — SMS/LMS 대체 미구현", "128 종속"),
"STD-MFG-130": ("todo", "§10 표 — 경계 자체는 문서로 확정(주문·결제·배송=샵바이 / 파일=우리)", "125·127 구현 시 준수 확인 대상"),

# ── 운영 5 ──
"STD-MFG-131": ("new", "§11 5단계 「처리 현황 대시보드」 미체크 · 코드 0건", ""),
"STD-MFG-132": ("todo", "PDF p.4 §04 조직 7종 — 현행 MES 권한 운영", MANUAL),
"STD-MFG-133": ("미판정", "auto-vs-human §5 A-6 「오프라인 주문이 신규 시스템 범위인지 범위 미결 — PM」", "판정 불가 사유 — A-6 PM 범위 미결"),
"STD-MFG-134": ("todo", "PDF p.4 §04 회계경리 — 현행 운영", MANUAL+" · 돈 직결"),
"STD-MFG-135": ("todo", "PDF p.7 §08 — 현행 운영", MANUAL+" · 돈 직결"),

# ── 비생산 16 (권위: huni-skin-shopby 260830 30cb88a 실측) ──
"STD-MYP-018": ("done", SK+"app/(main)/mypage/page.tsx:10 DashboardSection · layout.tsx (중첩 라우트 전환)", CODEONLY),
"STD-MYP-019": ("new", "huni-skin-shopby 전수 grep 'mypage.*search' 0건(260902) — 마이페이지 통합 검색 라우트 없음", "구 사이트 F-031 · 신규 미이관"),
"STD-CAT-023": ("partial", SK+"lib/api/server/catalog.ts:128,179 filter.saleStatus=ONSALE (주문가능여부 게이팅 실재)", "회원전용 노출 게이팅(memberOnly) grep 0건 — 미구현"),
"STD-CAT-024": ("미판정", "huni-skin-shopby 에 「포장재」 전용 경로 grep 0건 · 샵바이 카테고리로 흡수됐는지 미확인", "판정 불가 사유 — 셀러어드민 카테고리 확인 필요(접속 보류)"),
"STD-CAT-025": ("partial", SK+"components/home/home-content.ts:120 「아크릴굿즈」 메뉴 실재 — 카탈로그 노출은 됨", "굿즈 전용 주문 경로(파우치·백)는 전용 컨피규레이터 grep 0건"),
"STD-CAT-026": ("미판정", "huni-skin-shopby 에 「수작」 grep 0건 · 상품 등록 여부는 셀러어드민 확인 필요", "판정 불가 사유 — 셀러어드민 접속 보류"),
"STD-OPT-056": ("done", SK+"components/product/configurators/calendar-configurator.tsx:167 장수 · :196 캘린더 가공", CODEONLY),
"STD-OPT-057": ("new", "huni-skin-shopby 에 규격 가이드 모달 컴포넌트 grep 0건 · guide-data.ts:90 은 가이드 문서(모달 아님)", "구 사이트 IA-057 · 신규 미이관"),
"STD-OPT-058": ("new", "huni-skin-shopby 에 「주문가능 자재(용지) 목록 모달」 컴포넌트 grep 0건 · guide-data.ts:161,170 은 가이드 문서", "구 사이트 F-059 · 신규 미이관"),
"STD-ART-029": ("new", "huni-skin-shopby 전수 grep 'vdp|가변데이터' 0건(260902)", "구 사이트 F-055 · 신규 미이관"),
"STD-ORD-028": ("done", SK+"lib/api/hooks/use-cart.ts:197 (handoff token/payload 를 라인에 실음) · app/api/printly/requote/route.ts:16", CODEONLY),
"STD-PAY-019": ("new", "huni-skin-shopby 전수 grep '키인|manualCard|가상단말' 0건(260902)", "구 사이트 F-074 · 운영자 수동카드결제 — 신규 미이관"),
"STD-ADC-015": ("new", "huni-skin-shopby 전수 grep '거래처 게시판|매장' 0건 · 운영자 기능은 셀러어드민 소관", "구 사이트 F-096 · 신규 미이관"),
"STD-ADC-016": ("new", "huni-skin-shopby 전수 grep '체험단' 0건", "구 사이트 F-121 · 신규 미이관"),
"STD-ADP-034": ("미판정", "수작 상품 등록은 셀러어드민 상품 등록 화면 소관 — 접속 보류로 확인 불가", "판정 불가 사유 — 셀러어드민 접속 보류(STD-CAT-026 과 한 쌍)"),
"STD-ADP-035": ("미판정", "디자인 상품 등록은 셀러어드민 상품 등록 화면 소관 — 접속 보류로 확인 불가", "판정 불가 사유 — 셀러어드민 접속 보류"),
}
