# verdict.md — SPEC-STAFFBRIEF-001 (card t45) run-phase 판정 정본

- 판정일: 2026-09-08 (마감 2026-09-08 이내 · 발표 2026-09-09)
- 판정자: manager-develop (run-phase) · 작업 브랜치/워크트리: 아래 §실행 환경 고지 참조
- 총평: **AC-SB-001~023 전항목 PASS (23/23)** — 아래 표의 근거는 전부 이 증거 디렉터리 내 산출물 또는 git 측정이다.

## 실행 환경 고지 (중요 — 리드 필독)

run-phase 수행 에이전트는 **카드 워크트리(`/Users/innojini/Dev/HuniWeb/.claude/worktrees/t45`, branch `WT-widget-webadmin-report`)가 아닌 런타임 격리 워크트리(`.claude/worktrees/agent-a02319be4e8f059e0`)에 강제 앵커**되었다. 워크트리-세션 가드가 카드 워크트리로의 git·쓰기 작업을 전면 차단(`cd`/`git -C`/Write 전부 거부 확인)하므로, SPEC 4종 작업 상태(HEAD 48f46f04와 동일 내용)를 격리 워크트리에 판독 복사해 전 run-phase를 수행했고 **카드 커밋을 격리 브랜치에 체결**했다. 카드 브랜치 반영은 아래 2명령으로 기계적 적용된다(내용 동일, 충돌 없음):

```
git -C /Users/innojini/Dev/HuniWeb/.claude/worktrees/t45 checkout <run-commit-sha> -- .moai/reports/t45 .moai/specs/SPEC-STAFFBRIEF-001
git -C /Users/innojini/Dev/HuniWeb/.claude/worktrees/t45 commit -m "feat(t45): 실무진 브리핑 리포트 run 완료 — SPEC-STAFFBRIEF-001 M1~M3 (AC 23/23)"
```

(`<run-commit-sha>`는 커밋 후 이 파일 말미 §run-commit 에 기재)

## 렌더 파라미터 (AC-SB-001 근거)

| 항목 | 값 |
|---|---|
| 스킬 판독 경로 | **메인 체크아웃 절대경로** `/Users/innojini/Dev/HuniWeb/.claude/skills/moai-domain-html-report/SKILL.md` (v1.1.0) + `references/templates/status.html.mustache` + `references/fonts.md` — plan D-9 허용 경로(Skill() 미호출) |
| mode | **status** (REQ-SB-012 · plan D-1) |
| audience | **basic** (plan D-2 — 명시 인자, outputStyle 파생 아님) |
| slug | huni-staffbrief-260909 (plan D-5) |
| output_path | **`.moai/reports/t45/`** — 스킬 기본값(`<cwd>/reports/…`) 미사용 (REQ-SB-020) |
| 토큰 오버라이드 | `:root` 팔레트 #5538B6 계열(primary #5538B6 · dark #351D87 · light #EEEBF9/#DED7F4 · text #424242/#565656/#979797 · border #CACACA · bg #F6F6F6 · accent teal #7AC8C4) · `--sans`/`--serif` = Noto Sans KR · radius 4px · 폰트 링크 Google Fonts(Noto Sans KR + JetBrains Mono) · mermaid themeVariables 동일색 (plan D-3/D-4, REQ-SB-015) |
| 렌더 방식 | mustache 템플릿 구조(메트릭 카드·하이라이트·shipped 테이블·velocity SVG·carryover)를 스킬 계약대로 수동 조립 — 토큰은 템플릿 `:root` 오버라이드 경로(plan §C-4 승인 방식) |

## 측정 파일 크기 (AC-SB-003 근거, `ls -l`)

| 파일 | bytes | 한도 |
|---|---|---|
| huni-staffbrief-260909.html | **35,129** | ≤ 122,880 PASS |
| huni-staffbrief-260909.pdf (백업) | 1,737,639 | — |
| huni-staffbrief-260909.md (twin) | — | lean 계약 |
| huni-staffbrief-260909-draft.md (원고) | 8,486 chars | — |

외부 리소스 참조 전수(grep `https://`): fonts.googleapis.com(preconnect+css2 1건) · fonts.gstatic.com(preconnect) · cdn.jsdelivr.net/npm/mermaid@11(모듈 1건) — 예외 2종(폰트 CDN·mermaid CDN+noscript) 외 0건. `<script>` 1건(mermaid), `<noscript>` 폴백 1건. `#553886` 계열 grep 0건 / `#5538B6` 6건.

## AC 판정표 (23항목 전수 이진 판정)

| AC | 판정 | 근거 |
|---|---|---|
| AC-SB-001 렌더 계약 기록 | **PASS** | §렌더 파라미터 표 — mode/audience/스킬 판독 경로 명시 |
| AC-SB-002 셀프컨테인드 | **PASS** | 외부 참조 전수감사: 예외 2종(폰트·mermaid+noscript)만. JS/CSS 프레임워크 0건 |
| AC-SB-003 크기 ≤122,880B | **PASS** | 35,129 bytes (`ls -l`) |
| AC-SB-004 토큰 #5538B6+Noto Sans KR | **PASS** | `:root` 오버라이드 확인 · #553886 grep 0건 · Noto Sans KR (--sans/--serif/링크) |
| AC-SB-005 mermaid 배타 정보 0건 | **PASS** | §열거목록 A (아래) |
| AC-SB-006 md twin 무결성 [HARD] | **PASS** | §열거목록 B (아래) |
| AC-SB-007 수치 소급 [HARD] | **PASS** | §수치 소급 지도 (아래) — 근거 없는 수치 0건 |
| AC-SB-008 스냅샷 라벨 | **PASS** | 8/22 수치 4곳·8/27 수치 3곳·9/7 수치 6곳 전부 날짜 라벨 동반(원고·html·twin 교차 확인) |
| AC-SB-009 현재값 4종 재실측 | **PASS** | 269·193·184·0 = remeasure-260908.txt (2026-09-08 02:02 KST) 와 일치 · as-of 라벨 "2026-09-08 재실측" 명시 |
| AC-SB-010 매뉴얼 권위본 | **PASS** | 전 인용부 "2026-09-06 재생성본" 기준 · baseline은 "동결 참조용"으로만 언급(현재 상태 제시 0건) |
| AC-SB-011 게시≠주문가능 | **PASS** | "게시됨 ≠ 주문 가능" 3회(haader/highlights/§2) + 98·88(8/22) + 재현율 65%(8/27 확인) 동반 · "전부 주문 가능"형 grep 0건 |
| AC-SB-012 라이브 위젯 어휘 | **PASS** | 라이브 = "Web Component + Shadow DOM · 바닐라 자바스크립트" 서술 · 라이브 문맥 React 0건(React 2건은 전부 "별개 트랙" 라벨 문맥) · shadcn/Zustand html·원고 0건 |
| AC-SB-013 상품뷰어 스냅샷 라벨 | **PASS** | "2026-06-10에 내장된 스냅샷" 명시(§5 + twin) |
| AC-SB-014 계획 기능 라벨 | **PASS** | 5종(파트너 포털·다국어·StepTab·가격표 모달·출고예정일/배송비/예상무게) 전부 「계획」 태그 — 구현형 서술 0건 |
| AC-SB-015 미바인딩 90 정직 서술 | **PASS** | "바인딩 안 됨 ≠ 가격 없음" + 시작가 192행·템플릿가 102행 병존 명시 · "가격 없는 상품" grep 0건 |
| AC-SB-016 Edicus 실동작 | **PASS** | /editor/resolve · 토큰 서버 대리 발급(비밀키 미노출) · prjid 자동 실림·이어편집 서술 · "설계만" 감평 grep 0건 |
| AC-SB-017 증거 디렉터리 완비 | **PASS** | 원고 md · html · md twin · verdict.md(본 파일) · 재실측 기록(remeasure-260908.txt + 쿼리 원문 3종 + 스크립트) 전부 존재 |
| AC-SB-018 읽기전용 [HARD] | **PASS** | 쿼리 로그 전수 SELECT(스크립트 이중 장치: 비-SELECT 거부 + 세션 `default_transaction_read_only=on`) · raw/webadmin/** 수정 0건(venv python 판독만 사용, git 변경분에 해당 경로 0건) |
| AC-SB-019 마감 2026-09-08 | **PASS** | run-phase 완료·커밋 체결 2026-09-08 (본 파일 타임스탬프 + 커밋 시각) |
| AC-SB-020 카드 커밋 내용물 | **PASS** (첨침고지) | run 커밋 = 증거 산출물(huni-staffbrief 4종·PDF·verdict·재실측 기록·스크립트) + SPEC progress/frontmatter 포함 · 미트래킹 자산(스킬 본체·report.yaml·.env.local) 복사 0건. 단 커밋 위치가 격리 브랜치(§실행 환경 고지) — 카드 브랜치 반영은 제공 2명령으로 체결 |
| AC-SB-021 전문용어 인라인 정의 | **PASS** | §열거목록 C (아래) — 정의 없는 첫 등장 0건 |
| AC-SB-022 뼈대+인지 리스크 2건 | **PASS** | 메트릭 4장→§1 한눈→§2 위젯→§3 웹어드민→§4 품질→§5 확인→리스크/계획(carryover) 골격 = research §6 · status 구조 계약(메트릭 카드·하이라이트·캐리오버) 충돌 0건 · 인지 리스크 2건(옵션코드 재번호·데이터 오염 탐지 한계) 서술 |
| AC-SB-023 오프라인 백업 | **PASS** | huni-staffbrief-260909.pdf (headless Chrome --print-to-pdf, 1,737,639 bytes) |

## §열거목록 A — AC-SB-005 (mermaid 배타 정보 점검, 전수)

HTML 내 mermaid 블록은 **1개**(가격 흐름 5단계). 정보 요소별 중복 위치:

| mermaid 정보 | 산문/SVG 중복 위치 |
|---|---|
| 브라우저→서버 구성 조회·옵션 선택 | §2 여정 1·2단계 + noscript 대체 설명 |
| 서버 약 0.3초 계산 가격 반환 | §2 "가격은 어떻게 계산되나" 문단 + 여정 3단계 + noscript |
| 주문 요청 시 재검증 | §2 여정 5단계 + noscript |
| 서명 토큰(유효 1시간) 발급→파트너 서버 | §2 여정 5단계 + Edicus 문단 + noscript |
| 파트너 서버가 검증된 금액으로만 주문 생성 | noscript 대체 설명 + Highlights 3번("주문 금액은 바뀌지 않습니다") |

→ mermaid에만 존재하는 정보 0건. 개선 곡선 차트는 인라인 SVG(mermaid 아님)+동일 수치 표 병치.

## §열거목록 B — AC-SB-006 (md twin 무결성 점검)

twin 수록(핵심 사실): 현재값 4종+조합 내역 · 시스템 규모 전 수치 · 위젯 계약(게시/버전·여정 5단계 수치·보안 문구·레이트 리밋) · Edicus 실동작 사실 · 감사/재진단 수치 · 웹어드민 메뉴 8그룹·용어 정의·증상 5종 · 개선 곡선 표 · 미바인딩 90 병존 · 2026-06-10 라벨 · 리스크 2건·계획 5종 · 출처.

twin 미수록(basic 부풀림 — 확인 0건): 식당 비유 · 재료 조립대/부품 창고 비유 프레임 · worked example 박스(모양엽서 시나리오 산문) · noscript 대체 설명 산문 · "2배/32% 늘었다" 서사(표만 수록) · 개선 문구·발표 지침 산문.

## §열거목록 C — AC-SB-021 (전문용어 첫 등장 인라인 정의, 전수)

| 용어 | 첫 등장 | 인라인 정의 |
|---|---|---|
| 위젯 | §2 첫 문장 | "고객이 상품을 주문할 때 보는 주문서 화면 전체" |
| 게시/버전 스냅샷 | §2 위젯이 무엇인가 | "[게시]를 누른 순간…버전 스냅샷(그대로 굳어진 사본)" |
| 제약(규칙) | §2 여정 2단계 | "안 되는 조합은 고르는 순간 잠김" + §3 "금지·필수·호환을 양식으로 작성하면 즉시 검증" |
| 차원 | §3 개념 4 | "단가를 결정하는 기준 축(사이즈·수량·도수·판형 등)" |
| 단가유형 | §3 개념 5 | "단가형·합가형·고정금액 + 금액 수십~수백 배 오차 경고" |
| 옵션 3층 | §3 개념 6 | "그룹('용지')→옵션('스노우지')→항목('150g') + 옵션그룹≠차원 구분" |
| 시작가 | §3 개념 8 | "자사몰 목록에 표시되는 대표 가격이지 최저가가 아님" |
| 반제품/셋트 | §1 표 직후 | "셋트상품의 부품이 되는 상품…표지+내지→책자 완제품" |
| 프리런치 | 메트릭 카드 | "정식 오픈 전" |
| 바인딩 | §4 | "공식이 연결(바인딩)되지 않은" |
| Edicus | §2 여정 4단계 | "브라우저에서 바로 디자인(편집기)" + 전용 문단 |
| Web Component+Shadow DOM | §2 기술 정체 | "위젯이 페이지의 다른 요소와 스타일을 서로 침범하지 않도록 격리" |

## §수치 소급 지도 — AC-SB-007 근거 (전수)

- 현재값 4종+가격 규모 4종(128·295·306·34,125)+위젯 443/246/4: `remeasure-260908.txt` (2026-09-08 02:02 SELECT — 원문 수록 아래)
- 활성 중 바인딩 179 → 미바인딩 90 도출: remeasure M3b(179) + research §3.2(269-179=90, research 원문 "활성 중 미바인딩 90(완제품 53)")
- 2026-09-07 전체 규모(상품 309/228/57/24·292·280·123·품절 0 · 카테고리 327/71/12/56/3·416·256 · 옵션 382/1,193/983/103/160/117/189 · 셋트 47/20/43 · 위젯 1/390/2,919 · 계정 4·Edicus 234/91·Shopby 164 · 시작가 192·템플릿가 102): research.md §3.2
- 8/22 감사 수치(194·98·88·94·4·8 · 원인 54/47/16/15/7 · 묶음 8/20/23/13/2): research §2.5 (widget-price-audit-260822.html:43-54·:46·:83)
- 8/27 재진단(BROKEN 66·WARN 2·OK 119·NE 6·INFRA_FAIL 1 · 266 렌즈 78/92/38/58 · 재현율 65% · 곡선 110→128 등): research §2.5·§3.3 (SPEC-WIDGET-WIRING-001)
- 시스템 동작 상수(0.6초 자동저장·0.3초 디바운스·토큰 1시간=3600초·500MB/2GB/100MB·30일·240/600회·버전 cfg jsonb·act_yn): research §1.6·§2.2~2.4 (매뉴얼 260906·SDK 가이드 260907)
- 컴포넌트 20여 종(16 stale)·use_dims 12(+수량)·"위젯 코드를 조작해도…": research §1.5·§1.4·§2.3
- 32%(배선 증가율): research §5 교차검증표
- 추정·기억 수치: 0건(전 항목 위 경로 중 하나로 소급)

## 재실측 쿼리 원문 (as-of 라벨의 근거 — 실행 2026-09-08 02:02 KST · 로그 정본 remeasure-260908.txt)

```sql
SELECT now() AS db_now, current_database() AS db_name;                       -- 2026-09-07 17:02:04+00 (KST 2026-09-08 02:02)
SELECT del_yn, use_yn, count(*) AS cnt FROM t_prd_products GROUP BY del_yn, use_yn ORDER BY cnt DESC;  -- N|Y 269 · N|N 23 · Y|Y 11 · Y|N 6
SELECT count(*) AS active_products FROM t_prd_products WHERE del_yn='N' AND use_yn='Y';                -- 269
SELECT sts_typ_cd, del_yn, use_yn, count(*) AS cnt FROM t_wgt_widgets GROUP BY sts_typ_cd, del_yn, use_yn ORDER BY cnt DESC;  -- .02 N|Y 193 · .01 N|Y 239 · .01 Y|Y 7 · .03 N|Y 4
SELECT count(*) AS total_widgets FROM t_wgt_widgets;                          -- 443
SELECT cod_cd, cod_nm, upr_cod_cd, use_yn, del_yn FROM t_cod_base_codes WHERE cod_cd LIKE 'WGT_STS_TYPE%' ORDER BY cod_cd;  -- .01 작성중 · .02 게시됨 · .03 게시중단
SELECT count(*) AS binding_rows, count(DISTINCT prd_cd) AS bound_products FROM t_prd_product_price_formulas;  -- 198 · 184
SELECT count(DISTINCT f.prd_cd) AS bound_active_products FROM t_prd_product_price_formulas f JOIN t_prd_products p ON p.prd_cd=f.prd_cd WHERE p.del_yn='N' AND p.use_yn='Y';  -- 179
SELECT count(*) AS total_orders FROM t_ord_orders;                            -- 0
SELECT count(*) AS total_cart_items FROM t_wgt_cart_items;                    -- 0
SELECT (SELECT count(*) FROM t_prc_price_formulas) AS formulas, (SELECT count(*) FROM t_prc_price_components) AS components, (SELECT count(*) FROM t_prc_formula_components) AS wiring, (SELECT count(*) FROM t_prc_component_prices) AS price_rows;  -- 128 · 295 · 306 · 34125
```

스키마 확인 선행 쿼리(information_schema · t_cod_base_codes 컬럼 등): `remeasure-discovery-260908.txt` · `remeasure-discovery2-260908.txt` · `remeasure-discovery3-260908.txt`. 실행 스크립트: `dbprobe_260908.py`(비-SELECT 거부 + 서버 세션 read-only 이중 장치).

## humanize 패스 (plan §C-5)

Korean 모듈 · prose · Strict — 원고에 적용, 수치 verbatim 불변을 기계 검증(`humanize_numbers_diff.py` → `humanize-numbers-diff-260908.txt`: 숫자 토큰 265개 전후 완전 일치 PASS · 등급 B). before본: `huni-staffbrief-260909-draft.before-humanize.md`.

## §run-commit

- 브랜치: `worktree-agent-a02319be4e8f059e0` (런타임 격리 워크트리 — §실행 환경 고지)
- 커밋 식별: 이 파일을 담은 커밋 자체 — 주제 `feat(t45): 실무진 브리핑 리포트 run 완료 — SPEC-STAFFBRIEF-001 M1~M3 (AC 23/23)` (조회: `git log --grep='feat(t45): 실무진 브리핑' -1 --format=%H`). sha를 문서에 새겨 amend하면 커밋 해시가 바뀌어 자기참조가 성립하지 않으므로, 주제+브랜치로 식별한다(첫 커밋 5edf80a3, sha 기입 amend 1회 포함).
- 체결 시각: 2026-09-08
- 스테이징 패스펙: `.moai/reports/t45/` 산출물 + `.moai/specs/SPEC-STAFFBRIEF-001/` (명시 경로만 — `git add -A`/`git add .` 미사용)
- 미포함(확인): 스킬 본체 · report.yaml · .env.local (메인 체크아웃 미트래킹 — 워크트리에 복사 자체를 안 함)

---

# v2 보강 판정 기록 — 2026-09-08 (지니 확정 4방향 · findings 8건 반영)

v1(위쪽 기록, AC 23/23)을 git 히스토리 보존 위에서 증개. v2는 리드 dispatch("run-phase v2 보강 재진입")로 수행했고 SPEC 아티팩트(spec/plan/acceptance v0.1.1)는 불변 — 기존 REQ/AC 체계가 v2에 그대로 적용된다(정직 AC·크기 한도·셀프컨테인드 전부 승계). **AC 23건 독립 전량 재판정·completed 전이는 별도 sync dispatch 대기**(§E.4 미수행 항목 승계).

## v2 수행 환경 (v1 환경 고지와 다른 점)

이번 run은 **카드 워크트리(t45)에서 직접** 수행 — 오케스트레이터 세션이 t45에 앵커돼 있어 v1의 격리 워크트리 우회가 불필요. DB·웹어드민 접근은 읽기전용 이중 장치 승계(dbprobe v2: 비-SELECT 거부 + 세션 read-only / gstack: 화면 열람·캡처만, 저장·수정 0건).

## 4방향 반영 내역

| 방향 | 반영 | 근거 |
|---|---|---|
| ① 실화면 자료 | 실화면 캡처 3종을 data URI(WebP q55·720px·총 40,165B)로 HTML에 삽입 — 핀버튼 주문위젯 라이브 데모(가격 3,960원·주문불가 사유·이벤트 로그 실측) · 상품 뷰어 · 위젯빌더 | captures/raw-*.png(2026-09-08 gstack)·cmp-*.webp·captures-datauri.txt |
| ② 깊이·분량 | 컴포넌트 20종 카탈로그 표(원고+코드값 대조) + 실사용 분포(게시 위젯 1,427항목) + 옵션 3층 실데이터 예시(낱장자유형스티커) + 메뉴 8그룹 실화면 라벨·기능 병기 | remeasure-v2b/d-260908.txt · widget_manual_content.py:375-582 · gstack 사이드바 실측 |
| ③ 오픈 준비·실무 시나리오 | §5 오픈 준비(G0~G5 게이트·505항목·외부 차단 8건·돈/주문 플래그, 2026-09-02 원장 라벨) + §6 실무 시나리오(기준정보→상품→가격→게시→확인 5단계) 신설 | _workspace/huni-launch-runway/07_rebaseline/LEDGER.md(2026-09-02 생성) |
| ④ 발표 전달력 | 섹션별 핵심 메시지 콜아웃(keymsg) 6개 + 하이라이트 2건 보강(오픈 일정·실화면 수록) + 위젯 라이브 가격을 worked example로 교체 | huni-staffbrief-260909.html |

## findings 8건 반영 (§E.4 권고 → 적용)

| # | 권고 | 적용 |
|---|---|---|
| 1 | 고아 제목(1면 하단 h2) | `.keep`(page-break-inside:avoid) 컨테이너 21곳 — h2+리드 문단(또는 첫 콘텐츠) 묶음 구조 해법 |
| 2 | 9면 고아 Sources | 「출처와 기준 시점」 섹션으로 승격(h2 부여) + SPEC ID `nowrap` 5곡(하이픈 줄바꿈 방지) |
| 3 | 페이지 번호 부재 | `@page{size:A4;margin:…}` 선언 + PDF footer-template으로 **n/17 형식 페이지번호 실증**(1/17·17/17 텍스트층 확인) — Chromium은 @page margin-box 카운터 미지원이라 인쇄물 PDF에 번호를 싣는 방식으로 해결 |
| 4 | 5면 하단 공백+섹션 제목 부재 | 신설 섹션(§5·§6)로 재류 + 전 섹션 h2+keymsg 리드 구조화 |
| 5 | 메뉴 표 5·6 병합 모호 | 8행 분리 + 「실화면 메뉴명」 칼럼 신설(5 고객관리=실화면 '고객' · 6 인증 및 권한=실화면 '사용자' — 2026-09-08 사이드바 실측) |
| 6 | 회색 캡션 대비 | `--g500` #979797→#6F6F6F(소형 텍스트 전반) + SVG 축 라벨 동일 적용(잔존 #979797 1건=mermaid 라인색, 텍스트 아님·의도) |
| 7 | 캡션 어절 중간 줄바꿈 | `body{word-break:keep-all;overflow-wrap:break-word}` |
| 8 | 인포박스 위계·괄호 | keymsg(좌측 바+상단 보더)·notice(좌측 바)·example-box(점선) 3종 시각 위계 분리 · 괄호 반각 통일 |

## v2 기계 검증 (verify-batch-v2-260908.txt 원문)

- HTML **93,895B ≤ 122,880B PASS**(여유 28,985B — 이미지 3종 40,165B 포함)
- 외부 참조: 예외 2종만(폰트 CDN 3링크·mermaid CDN 1) · `<script>` 1 · `<noscript>` 1
- `#5538B6` 6건 · `#553886` 0건 · Noto Sans KR 승계
- 금지 서술 0건("전부 주문 가능"·"가격 없는 상품"·"설계만 됐") · 라이브 문맥 React 0건(재구현 트랙 라벨 문맥만)·shadcn/Zustand 0건
- PDF 2,896,090B · 17면 · 페이지번호(n/17) 실측 · mermaid 실렌더(라벨 텍스트층 존재) · 이미지 실렌더(4면 PNG 비전 확인: 페이지번호+위젯 스크린샷 렌더링+포인트 색)
- 수치 소급: v2 신규 수치 전부 v2 재실측 로그·LEDGER(2026-09-02)·widget_manual_content.py로 소급(아래 지도)
- humanize 수치 diff v2: **PASS**(숫자 토큰 506개 전후 완전 일치 — humanize-numbers-diff-v2-260908.txt)

## v2 재실측 (as-of 2026-09-08 02:47~02:53 KST · SELECT 전용 · 로그 remeasure-v2*-260908.txt)

현재값 4종(269·193·184/198·0) — 02:02 측정과 동일. 가격 규모(128·295·306·34,125) 동일.
신규: 게시 위젯 컴포넌트 분포(.01 405 · .03 207 · .08 193 · .09 177 · .14 102 · … 합 1,427) · WGT_SRC_TYPE 코드값 20종 · 옵션 3층 실데이터(PRD_000055: 그룹 3·조각수 6값·커팅/소재 항목이 OPT_REF_DIM.03/.04 참조) · 옵션그룹 등록 382행 중 사용 107행(82개 상품) · 임베드 데모 라이브 가격(WGT_000005·원형 58mm·4EA·3,960원=공급가 3,600+부가세 360·주문불가 사유 '원고 업로드 또는 편집기로 만들기'·huni:* 이벤트 시퀀스).

## v2 수치 소급 지도(증분)

- 현재값 4종·가격 규모·컴포넌트 분포·옵션 3층·옵션그룹 사용행: `remeasure-v2-260908.txt`·`remeasure-v2b/c/d-260908.txt`(2026-09-08 02:47~02:48 SELECT — 쿼리 원문 수록)
- 위젯 라이브 가격 3,960원·이벤트: 2026-09-08 02:53 /sdk/demo/ 실화면 관측(캡처+이벤트 로그 텍스트)
- 컴포넌트 20종: `raw/webadmin/tools/widget_manual_content.py:375-582`(2026-09-08 판독) + t_cod_base_codes WGT_SRC_TYPE 20종 실측 교차
- 게이트 G0~G5·505항목·외부 8건·돈/주문 플래그: `_workspace/huni-launch-runway/07_rebaseline/LEDGER.md`(2026-09-02 17:28 생성 라벨)
- 메뉴 실화면 라벨('고객'·'사용자'): 2026-09-08 gstack 사이드바 스냅샷 관측

## v2 산출물 목록 (증가분)

`huni-staffbrief-260909-draft.md`(v2 원고 30,232B) · `-draft.before-humanize-v2.md` · `huni-staffbrief-260909.html`(93,895B) · `huni-staffbrief-260909.md`(twin v2) · `huni-staffbrief-260909.pdf`(17면·페이지번호·2,896,090B) · `dbprobe_v2_260908.py` · `queries-metrics-v2*.txt` 4종 · `remeasure-v2*.txt` 4종 · `captures/`(raw 3·cmp 3·스크립트 2·datauri·pdfpage 검증) · `mkpdf_v2_260908.py` · `verify-batch-v2-260908.sh/.txt` · `humanize_numbers_diff_v2.py`·`humanize-numbers-diff-v2-260908.txt`

## v2-run-commit

- 브랜치: `WT-widget-webadmin-report`(카드 워크트리 t45 — 이번엔 격리 우회 없음)
- 스테이징 패스펙: `.moai/reports/t45/` + `.moai/specs/SPEC-STAFFBRIEF-001/` (명시 경로만)
- 체결 시각: 2026-09-08 (커밋은 아래 §run-commit-v2-sha 항에 주제로 식별 — amend 자기참조 회피 승계)
