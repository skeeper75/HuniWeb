# t60 — 입력 자료 실재 확인

카드 t60 이 지정한 입력을 **하나씩 열어** 실재와 쓰임을 확인했다. 읽기만 했다.

## 1. 카드가 지정한 입력

| 입력 | 실재 | 실측 | 이 카드에서 쓴 방식 |
|---|---|---|---|
| `t56/rejudge.csv`(커밋 `a83dc44b`) | ○ | **735행** (G2) | **주 원장.** 서희항 몫 246 · 남은 일 186 추출(G3). **수정하지 않았다** |
| `t57/connect-design.md`(`900295c2`) | ○ | 이음매 10 표 `:94-186` · 결정 사슬 `:154-186` · PitStop 선례 `:303-309` | ③ 이음매 정의 · ④ **「핫폴더 vs CLI 가 아니다」 사실 정정의 근거**(G36) |
| `t58/verdict.md`·`ledger-proposal.csv`(`e023dd87`) | ○ | 제안 36행(A.status정정 3 · B.재연결 5 · C.빠진일 21 · D.결정안건 5 · E.보강행 2) | ①② 실독 교차. **t58 주장은 전부 내가 다시 열어 확인**했다(G31·G32·G33·G34) |
| `t59/csj-todo.md`·`axis-rows.csv`(`02dbfb14`) | ○ | `axis-rows.csv` 42행 · 서희항 언급 **10행** | ④ 결정 사슬의 **위쪽 절반(최숙진 정의)을 이어받았다**. §④ 선후 관계표 8줄 인용 |
| `plan-rows.csv` | ○ | **735행** (G1) · 열 29 | `prereq` 열 = ㉰ 선후 구조의 유일한 원장 근거 |
| `t51/merged.csv` | ○ | **747행** · system 8종(huni-mall 177 · webadmin 147 · widget 133 · shopby 94 · mes 88 · pagebuilder 62 · edicus 23 · pitstop 23) · `[오픈분모밖]` 접두 64행 | **축 배분의 교차 확인용.** t56 `judged_by=merged-owner_side` 66행의 출처 |

## 2. 카드가 「입력 보충」으로 지정한 절대경로

| 경로 | 실재 | 이 카드가 연 것 |
|---|---|---|
| `/Users/innojini/Dev/HuniWeb/raw/webadmin` (별도 git) | ○ | `webadmin/config/urls.py` · `catalog/widget_api.py` · `catalog/artwork_promote.py` · `catalog/admin.py` · `catalog/models.py` · `catalog/views.py` · `catalog/price_views.py` · `catalog/widget_views.py` · `tools/issue_site_key.py` · `tools/edicus_coverage_baseline.json` · `tests/test_catalog_include_unpublished.py` · `docs/widget-builder-design.html`. **쓰기·커밋 0** |
| `/Users/innojini/Dev/HuniWeb/docs/huni/` | ○ | **열지 않았다.** 이 카드의 주장은 전부 코드·원장·런북에서 나왔다. `후니정기미팅 정리260915.html` 는 t56 evidence 안의 **인용으로만** 등장한다(내가 확인한 것이 아니다 — 본문 §9) |
| `/Users/innojini/Dev/TS.BackOffice.Huni` (MES · 별도 git) | ○ | 전수 grep 2종(PitStop · shopby/huniprinting/printly) — G28·G29. **읽기만** |
| `.../07_rebaseline/S/CARDS-S.md` | ○ | §0-A 「오픈 테스트는 Lightsail 위에서」(G38) · §0-B 트랙 표 |
| `/Users/innojini/Dev/huni-skin-shopby` (**huni-mall 독립몰** · 별도 git) | ○ | `src` 전수 grep 5종 + `src/lib/printly/huni.ts` · `src/app/api/printly/requote/route.ts` · `src/lib/api/requote.ts` 실독. **쓰기·커밋 0** |

## 3. 카드가 지정하지 않았으나 필요해서 연 것

| 경로 | 왜 |
|---|---|
| `.../07_rebaseline/S/S4-infra/migration-plan.md:30-75` | ⑤의 **유일한** 근거. F1·F2·F3 단계·담당·선행·롤백·위험 6열 |
| `t50/pitstop-decisions.md` | ④ 결정 사슬 7건. t56·t57 과의 상충(`T4-3`) 확인 |
| `t48/screens.csv:192,193,239` | ③ 김동학 호출부 3행(handoff/verify · order/register · 결제 직전 재견적) |
| `08_system-screen/CONTRACT.md` | 보충 1~4 — 특히 **보충 4「인용하는 쪽이 직접 path:line 을 확인한다」** |

## 4. 찾지 못한 것

- **`CRT.DigitalEdit.V2`(PitStop 선례 저장소)를 열지 않았다.** 본문 §5 의 「열림PnP 는 둘 다 CLI 다」는
  `t57/connect-design.md:305-309` **인용**이다. 그 행이 대는 근거(`CRT.Yeolim.ServerProcess/Program.cs:636`)를
  내가 확인하지 않았으므로 **A/B 중 무엇이 낫다는 판단을 하지 않았다**(본문 §9-4).
- **라이브 화면·라이브 DB 0회.** 카드가 읽기전용이라 접속하지 않았다. `STD-MFG-010` 의 「269개 중 15개」는
  t56 evidence 안의 **260902 실측 인용**이며 현재값이 아니다.
