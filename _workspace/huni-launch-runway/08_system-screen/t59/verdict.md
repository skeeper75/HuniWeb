# t59 verdict — 오픈일정 S8 · 최숙진 실장 역할 5축 Todo 수립

브랜치 `WT-ops-role-todo` · 워크트리 `.claude/worktrees/t59` · 분기점 `48714c44`
병합: `WT-role-todo-rejudge`(t56 `5bb97cfd`) → `WT-connect-design-doc`(t57 `900295c2`) → `WT-widget-scope-read`(t58 `e023dd87`), 전부 `--no-ff`.

읽기전용 — DB write 0 · 라이브 접속 0 · MES·webadmin 저장소 쓰기 0 · 날짜 추정 0 · 작업량 숫자 0.
**재배정·신규 행은 전부 제안이고 결정은 지니다. t56 원장(`t56/rejudge.csv`)은 수정하지 않았다.**

## 1. 산출물

| 파일 | 내용 |
|---|---|
| `csj-todo.md` | **본문** — 한 장 요약 → 5축 → 행 · ㉰ 선후 관계표 · ㉱ 테스트 단계별 역할표 |
| `axis-rows.csv` | ㉮㉯ 행 원장 **42행**(재연결 12 · 경계 9 · 신규 제안 21) |
| `inputs-check.md` | ㉲ 입력 자료 실재 확인(정책 엑셀 · 가이드북 원고 · 대조 리포트) |
| `t56-check.md` | ㉳ t56 보정 제안 2건 검증 |
| `scan.py` · `build_axis.py` · `verify.py` · `verify-result.txt` | 결정론 스캔·생성·검산 |

## 2. 행수·분포

- 입력: `plan-rows.csv` **735행** · `t56/rejudge.csv` **735행** (검산 G1·G2)
- 산출 `axis-rows.csv` **42행**

| 축 | 행 | 재연결 | 경계 | 신규 제안 |
|---|---|---|---|---|
| ① 가이드북 콘텐츠 | 7 | 2 | 1 | 4 |
| ② 상세탭 콘텐츠 | 7 | 0 | 3 | 4 |
| ③ 정책(엑셀) 정리 | 9 | 4 | 1 | 4 |
| ④ 내부 프로세스 정의 | 11 | 4 | 2 | 5 |
| ⑤ 테스트 역할 배정 | 8 | 2 | 2 | 4 |
| **합계** | **42** | **12** | **9** | **21** |

**결정 안건(계약 보충 4) 신설 0건** — 이 카드는 `screens.csv` 를 만들지 않으므로 해당 없음.
④의 결정 안건(`STD-ART-034` 등)은 이미 `t50/pitstop-decisions.md`·`t58/widget-decisions.md` 에 있고 여기서는 **인용만** 했다.

## 3. 카드 질문별 답

### ㉮ 5축별 행 전수 수집 — 완료(단, 전 행 evidence 실독은 아니다)

`plan-rows.csv` 735행을 결정론 스캔(`scan.py`)해 후보 366행을 뽑고, 그중 5축에 실제로 귀속되는 행을
**evidence 파일을 직접 열어** 확정했다. 연 파일은 §5.

`t51/merged.csv`(747행)·`t52/rejudge.csv`(83행)·`t58/ledger-proposal.csv`(36행)도 읽었으나
**이 다섯 축에 해당하는 행이 거의 없다** — t52 는 83행 중 콘텐츠·정책·역할 축 0건(접수·MES 구현 행뿐),
t58 은 36행 전부 위젯·webadmin 코드 축이다. 그 사실 자체가 ㉯의 근거다.

### ㉯ 원장에 없는 일 — **21건. 「정의하는 일」이 구조적으로 빠져 있다**

가장 큰 근거는 행이 아니라 **간선**이다.

- 원장에서 해석 가능한 `prereq` 간선 **182개** 중 선행이 최숙진 행인 것 **25개**, 그중 후행이 서희항인 것 **1개**
  (`STD-MFG-078` ← `STD-MFG-010`). (검산 G5)
- 이 카드가 다루는 **정의하는 행 10개는 후행이 전부 0건**이다. (검산 G6)
- 최숙진 행 **153개 중 126개가 `prereq` 공란**이다. (검산 G7)

→ 원장은 「최숙진이 정하면 누가 움직인다」를 **기록하고 있지 않다.** 그래서 ㉰의 선후 관계표가 필요했다.

축별 실측:

- **①** 가이드북 글 **72편 중 71편이 자리표시자**(`guide-data.ts`). 자동 생성 제목 **40건**, 동일 제목 **5건**. (G9·G10)
  다운로드 자료는 **504행·상품 88종** 등재돼 있으나 **표시명이 504행 전건 공란**(스냅샷 260827). (G12)
- **②** 상세탭 원장 행 5개가 **전부 도구·화면**이고 최숙진 행 **0**. (G8) 발행본이 없으면 스킨은
  **핀버튼 샘플 카피**와 **전 상품 동일 고시값**(A4·몽블랑 190g·3박4일·OPP)을 그대로 띄운다.
- **③** 운영정책 엑셀 두 시트가 시트명에 **「(정리중)」**(IA 41행 · FAQ 94행) · 할인쿠폰 시트 내용행 **2**.
  검토요청 리포트(커밋 `48714c44`)의 **실무진 결정 대기 21건**을 담는 원장 행이 0.
- **④** CTO 구간 08 의 3·4번(검사 범위 정리 · 결과별 처리 프로세스 정리)과 구간 09 의 검수 기준,
  그리고 「Edicus 파일 검수 스킵 여부」가 **전부 원장 행 0**.
- **⑤** 진입 조건 9항에 **담당 열 자체가 없다**. 「내부팀 누가 무엇을 확인하는가」 행 0.

### ㉰ ④ ↔ t57 이음매 ⑥⑦⑧ · `STD-ART-034` 선후 관계표 — 완료(8줄)

`csj-todo.md` §④. **표의 간선은 원장에 없는 제안이고, 그 사실을 표의 마지막 열에 적었다.**
`STD-ART-034`(연동방식 결정)는 **결정 주체를 고르지 않았다** — t50·t56 양쪽 미정이고 t56 근거가 `rule-track`(약함)이기 때문이다.
이 카드가 말한 것은 **그 결정의 선행 입력 둘(검사 범위 · 결과별 처리 규칙)이 최숙진 몫이고 지금 원장에 없다**는 것뿐이다.

### ㉱ 테스트 단계별 역할표 — 완료

T7-1 진입조건 9항별 확인 주체 배정(실무운영 확인 자리 **4개** 식별: 1·5·8·9) ·
T7-2 종단 주문 테스트를 CTO 10구간에 맞춘 단계별 역할표(구간 09 만 실무운영이 **실행 주체**).
검증 차수는 `STD-ADP-037` 에 이미 적힌 **1차 최숙진 → 2차 김용기 → 3차 채훈희** 선례를 따른다.
실무운영 인원 = 최숙진 실장 · 김용기 부장(`CARDS-S.md:62`).

### ㉲ 입력 자료 실재 — 정책 엑셀 **있음** · 대조 리포트 **있음** · **가이드북 원고는 찾지 못했다**

`inputs-check.md`. 못 찾은 것에는 돌린 패턴을 남겼고, 오인하기 쉬운 문서 3건을 「가이드북 원고가 아닌 것」으로 따로 적었다.

### ㉳ t56 보정 제안 2건 — 검증 완료

`t56-check.md`. 요지:

1. **`STD-ADC-014`** — t56 의 서희항 재배정은 **맞다**(화면이 `urls.py:72-87` 의 webadmin 에 실재). 다만 `guide_save` 가 다루는 것이
   **표시명·태그·순서**이고 그 값이 라이브 스냅샷에서 **전건 공란**이라 **분할이 더 맞다**(도구=서희항 / 채우기=최숙진 `NEW-G4`).
   덤으로 **`check_method` 결함 1건** — evidence 는 webadmin 을 대는데 확인처를 샵바이 셀러어드민으로 적었다.
2. **`STD-CAT-007`·`034`·`STD-ADP-015`** — 도구=김동학 **유지가 맞다**(t56 판정 확인). 짝이 되는 **콘텐츠 행 4건이 원장에 없어** 신설 제안했고,
   보충 3 의 제한(「오픈 전 필수 세팅임을 evidence 로 댈 수 있을 때만」)을 만족함을 `product-sections.tsx` 실독으로 댔다.

## 4. 미확인 (그대로 읽을 것)

1. **분모 2개 미확인** — ② 게시 상품 중 발행본 보유 수, ⑤ 2주 시나리오 상품 건수. 라이브 조회가 필요해 재지 않았다.
   `NEW-D1`~`D4` 의 크기는 이 수가 나와야 정해진다.
2. **가이드 파일 504행은 2026-08-27 스냅샷**이고 라이브 현재값이 아니다.
3. **`STD-CAT-019` ↔ `STD-INF-007` 중복 가능성** — 둘 다 「11종」을 말하고 파일작업가이드 자리표시자 11편과 수가 맞는다.
   지적만 하고 병합하지 않았다(원장 수정 금지).
4. **㉮의 「evidence 를 열어 확인」은 5축 귀속 행에만 적용**했다. 366개 후보 전건을 열지는 않았다.
5. **선후 관계표의 간선은 원장 기록이 아니다.** 제안이며, 원장에 없다는 사실을 표에 명시했다.
6. **작업량·기간 0.** 행수와 선후만 셌다. 행수는 일의 크기가 아니다.

## 5. 직접 열어 확인한 파일 (전체 경로)

| 파일 | 확인한 것 |
|---|---|
| `/Users/innojini/Dev/huni-skin-shopby/src/lib/guide-data.ts:41-209` | 자리표시자 71편 · 자동 제목 40건 · 동일 제목 5건 |
| `/Users/innojini/Dev/huni-skin-shopby/src/lib/printly/detail-tabs.ts:5-6,16-32` | 발행 가능 탭 4종 · 나머지는 정적 |
| `/Users/innojini/Dev/huni-skin-shopby/src/components/product/product-sections.tsx:14-46,146-153` | 핀버튼 카피 · 고정 고시값 |
| `/Users/innojini/Dev/huni-skin-shopby/src/app/(main)/product/[slug]/page.tsx:49-56` | 스킨은 발행본을 읽기만 한다 |
| `/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/config/urls.py:72-87` | 가이드파일 관리 라우트 6개(읽기만) |
| `/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/catalog/s3_guide.py:269-291` | presign 업로드 실재(읽기만) |
| `/Users/innojini/Dev/HuniWeb/docs/huni/후니프린팅_운영정책_260918.xlsx` | 시트 10종 실측(`max_row`·`max_column` 고정 후 순회) |
| `/Users/innojini/Dev/HuniWeb/docs/huni/후니프린팅_리뉴얼_정책체크리스트.xlsx` | 시트 5종 |
| `/Users/innojini/Dev/HuniWeb/docs/huni/후니프린팅_운영정책_검토요청_260918.md` | 49건 분해 · 결정 대기 21건 · 프린팅머니 4출처 3값 |
| `/Users/innojini/Dev/HuniWeb/docs/huni/후니-주문흐름-장바구니에서-MES까지_서희항_260908.html` | 구간 08 네 단계 · 구간 09 「가장 큰 공백」 |
| `/Users/innojini/Dev/HuniWeb/_workspace/huni-launch-runway/07_rebaseline/S/S4-infra/migration-plan.md:89-97` | 진입 조건 9항 · 담당 열 없음 |
| `/Users/innojini/Dev/HuniWeb/_workspace/huni-launch-runway/07_rebaseline/S/CARDS-S.md:62` | 실무운영 = 최숙진·김용기 |
| `/Users/innojini/Dev/HuniWeb/_workspace/_foundation/live-snapshot/snap_20260827_1422/t_prd_guide_files.csv` | 504행·88상품·표시명 전건 공란 |
| `08_system-screen/t56/rejudge.csv:36,61,413,477` · `t56/verdict.md` · `t56/reassign-proposal.md:32,175` | ㉳ 대상 4행의 t56 판정·근거 |
| `08_system-screen/t57/connect-design.md:94-186,355-460` | 이음매 10 표 · 결정 사슬 · ⑥⑦⑧ |
| `08_system-screen/t58/ledger-proposal.csv` · `t52/rejudge.csv` | 5축 해당 행 없음을 확인 |

`raw/webadmin` 과 `huni-skin-shopby` 는 별도 저장소다 — **읽기만** 했다(쓰기·커밋 0).

## 6. 검산 (`python3 verify.py` 출력 그대로 · `verify-result.txt`)

```
PASS G1 입력 plan-rows 735행 — 735
PASS G2 입력 t56 rejudge 735행 — 735
PASS G3 신규 제안 row_id 가 원장과 충돌 0 — 신규 21건 · 충돌 0
PASS G4 재연결·경계 행 전건 원장 실재 — 21건 · 누락 0
PASS G5 원장 prereq 간선 182 · 최숙진 선행 25 · 그중 서희항 후행 1 — (182, 25, 1)
PASS G6 정의 행 10개 후행 0건 — {}
PASS G7 최숙진 행 153 · prereq 공란 126 — (153, 126)
PASS G8 상세탭 원장 행 5개 중 최숙진 0
PASS G9 가이드북 글 72편 · 자리표시자 71편 — (72, 71)
PASS G10 자동 생성 제목 40건(5탭 × 8편) — 40
PASS G11 인용 경로 전건 실재 — 13개 확인 · 없음 0
PASS G12 가이드파일 504행 · 상품 88 · 표시명 공란 504 — (504, 88, 504)
PASS G13 axis-rows 42행 · 5축 · 신규 21 — (42, …, {'재연결': 12, '경계': 9, '신규': 21})
실패 0
```
