# huni-mall(독립몰) 결정·관리 안건 — 화면·기능 행이 아닌 것

카드 t61 · 계약 `../CONTRACT.md` 보충 4 적용.
**화면도 기능도 없는 결정·관리 안건은 원장 행이 아니다.** 지우지 않고 여기로 옮긴다.
t51 은 이 파일을 「관리 요소(RACI·리스크·의존)」 절의 입력으로 쓴다.

주의 — 아래 행들은 **`t56/rejudge.csv` 에 실재하는 행**이다. 이 문서는 그 행을 삭제하자는 뜻이 아니라,
**`axis-rows.csv` 를 작업 Todo 로 읽을 때 이 13행은 「만드는 일」이 아니라 「정하는 일」** 이라는 표시다.
(`axis-rows.csv` 에는 189행 전수가 그대로 남아 있다 — 뺀 행 0.)

| plan_row_id | 안건 | 미결 내용 | 근거 path:line | 결정 주체(제안) |
|---|---|---|---|---|
| `BLK-S4-6` | Vercel 접근·현재 env 소재 확인 | `DATABASE_URL`·`NEXTAUTH_URL` 이 무엇을 가리키는지 · 리다이렉트 설정 유무 | `_workspace/huni-launch-runway/07_rebaseline/S/S4-infra/migration-plan.md:131` | 신우진(PM) — 김동학은 수신 |
| `F4-4` | Prisma `DATABASE_URL` 목적지 | Lightsail PG `webapp` 합류 vs 별도 DB | `migration-plan.md:81` · `:136` | 신우진(PM)·김동학 |
| `F4-7` | vercel.app 리다이렉트 이관 여부 | 코드에 없음 — 대시보드 설정 확인 후 이관/폐기 결정 | `migration-plan.md:84` | 신우진(PM) |
| `F4-8` | Vercel 프로젝트 정지 시점 | 되돌릴 수 없는 단계 — 오픈 테스트 통과가 선행 | `migration-plan.md:85` · `:117` R9 | 신우진(PM)·채훈희 |
| `STD-SYS-050` | huni-skin-next 포크 처리 | 원본 main 에 선별 이식 vs 폐기(20커밋·remote 없음) | `t56/rejudge.csv` `STD-SYS-050` evidence | 신우진(PM)+김동학 |
| `STD-SYS-051` | 미병합 로컬 브랜치·워크트리 7개 정리 | 유효 변경 유무 확인 후 삭제 판단 | `t56/rejudge.csv` `STD-SYS-051` evidence | 김동학 |
| `STD-SYS-053` | Prisma 로컬 DB(23테이블) 존폐 | 코드 소비자 0(`src/lib/prisma.ts` 만) | `t56/rejudge.csv` `STD-SYS-053` evidence | 김동학·신우진 |
| `STD-MEM-022` | 로그인 식별자 정책 | 이메일 전용 vs 아이디 · 테스트회원 계정 정비 | `t56/rejudge.csv` `STD-MEM-022` evidence(라이브 `/login` 실측) | 지니·PM |
| `STD-MYP-054` | 마이포인트 ↔ 프린팅머니 메뉴 중복 | 노출 메뉴·명칭 확정 | `/Users/innojini/Dev/huni-skin-shopby/src/components/mypage/mypage-shared.tsx:14-15` | 최숙진(정책)·지니 |
| `STD-INF-012` | 뉴스·소식 공간 형태 | 갤러리형/게시판형/커뮤니티형 중 택1 + 메뉴명 | `t56/rejudge.csv` `STD-INF-012` evidence | 최숙진·신우진 |
| `STD-PAY-025` | 카카오페이 신청 경로 확인 | 셀러어드민 신청 경로 — 확인 안건(코드 0) | `후니정기미팅 정리260915.html §결제수단 · 미결 3` | 최숙진(config) |
| `STD-B2B-004`·`008`·`009` | 후불 여신한도 · 거래처 원장 · 원장 `.txt` 연계 | t56 판정이 **미정** — 범위·시스템 경계 미확정 | `t56/rejudge.csv` verdict=미정 3행 | 신우진(PM)·지니 |
| `STD-CAT-043` | 시작가 원천 이관 개발안 | 샵바이 `salePrice` 더미 → webadmin `GET /api/w/v1/catalog` | `t56/rejudge.csv` `STD-CAT-043` evidence | 김동학+서희항 |

**건수 = 13 안건**(`STD-B2B` 3행을 한 줄로 묶어 적었으므로 원장 행 기준으로는 15행).

## 이 문서가 새로 세운 결정 안건 — 2건

원장에 행이 없고, §5(mall-todo.md)에서 실측으로 드러난 것.

| 안건 | 미결 내용 | 근거 | 결정 주체(제안) |
|---|---|---|---|
| `order/register` 경로 선택 | `token` 경로 vs `item_id` 경로. `item_id` 로 가면 몰이 토큰을 보관하지 않아도 되나 `X-Huni-Server-Key` 가 **스위치와 무관하게 필수**다 | `/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/catalog/widget_api.py:5623-5626` | 김동학 ↔ 서희항 |
| API 로 등록한 리뷰에 사진리뷰 보상이 붙는가 | `STD-PRM-009` 는 `provided` 판정인데 리뷰 작성 화면은 huni-mall 몫(`STD-MYP-012`)이다 — 「샵바이 몰에서 쓴다」는 전제가 headless 에서 깨진다 | `t56/rejudge.csv` `STD-PRM-009`(provided) ↔ `STD-MYP-012`(김동학·남은 일) | 최숙진(확인)·샵바이 회신 |
