# manual-element-matrix.csv — 읽는 법·재현 방법

## 분모 산출 규칙 (D1 이 선언하고 D3 가 재계산한다)

**요소 1건 = 매뉴얼 원고가 `selector` 로 화면 위 한 지점을 지목하고 `label` 로 설명한 콜아웃 하나.**
콜아웃이 없는 화면(`MODEL_ADMIN_SCREENS` — `one_liner` 만 보유)은 **화면 1건을 요소 1건**으로 센다.
**[보강 · 리드 판정 260917] 매뉴얼 콜아웃이 0 이거나 매뉴얼 섹션이 없는 사이드바 관리 화면도 화면 1건 = 요소 1건**으로 센다
(메뉴 지도 CSV 의 「매뉴얼 화면 섹션」 칸이 `없음…` 이거나 `콜아웃 0` 을 담은 사이드바 행). 이유: (v) 화면 축 하한은 대조 대상을
줄이는 해석을 막으려고 둔 장치다 — 「섹션이 없어서 제외」는 바로 그 해석이다. 위젯 매뉴얼의 콜아웃 0 부품 설명(`comp_*`)은
사이드바 화면이 아니므로 더하지 않는다.

**제외 선언(숨은 제외 0)** — 화면 요소가 아니라 **문서 본문 자체**라 대조할 지점이 없는 메뉴 6개:
퀵스타트 가이드 · 메뉴얼 · 위젯빌더 메뉴얼 · 테이블 명세서(문서) · SDK 개발가이드 · 임베드 라이브 데모(개발자 문서).
D3 가 이 목록을 실행 시마다 출력한다.
`steps` 는 요소가 아니라 그 요소에 도달하는 조작이므로 **분모에서 제외**하고 경로 종류 판정에만 쓴다.

재현 명령(이 값을 어디에도 상수로 적지 않는다):

```bash
cd raw/webadmin/tools && python3 -c 'import importlib.util as u
def L(n,p):
    s=u.spec_from_file_location(n,p); m=u.module_from_spec(s); s.loader.exec_module(m); return m
mc=L("mc","manual_content.py"); wc=L("wc","widget_manual_content.py")
n=sum(len(c.get("callouts",[])) for s in mc.SCREENS for c in s.get("captures",[]))
n+=sum(len(c.get("callouts",[])) for s in wc.SCREENS for c in s.get("captures",[]))
n+=len(mc.MODEL_ADMIN_SCREENS); import csv; M=list(csv.DictReader(open("../../../_workspace/huni-launch-runway/07_rebaseline/S/S5-live/menu-map-260917.csv",encoding="utf-8"))); k="매뉴얼 화면 섹션(SCREENS/MODEL_ADMIN) 유무"
n+=sum(1 for r in M if r["사이드바그룹"]!="(사이드바 없음)" and (r[k].startswith("없음") or "콜아웃 0" in r[k]))
print(n)'
```

## 두 분모를 섞지 않는다 (리드 판정 260917)

| 분모 | 값 | 쓰는 곳 |
|---|---|---|
| **메뉴 지도** | **37** (사이드바 33 + 비사이드바 4) | AC-LP-014(e)(v) 화면 축 하한. 위젯빌더 24 SCREENS 는 **「위젯빌더」 메뉴 1건에 귀속**한다 |
| **화면단위 / 요소** | **53 화면단위 · 162 요소**(보강 전 50 · 159) | 매트릭스 행과 요약 층 집계 |

요약 층에는 「메뉴 37 중 커버 N」과 「화면단위 50 · 요소 159 · 결과 4종 분포」를 **나란히** 적고,
서로 다른 분모임을 한 줄로 명시한다.

## 실측 결과 값은 4종뿐

`동작확인(URL@일시)` · `불일치(URL@일시+차이)` · `쓰기경로-dev환경필요` · `미실측(사유)`.
그 밖의 값을 만들지 않는다. `미실측` 은 사유 없이 남기지 않는다.

- 실클릭 대상 = 읽기 91 + 「읽기+쓰기」 25 의 **읽기 부분** = **116건**. 저장은 0회.
- 쓰기 43 은 클릭하지 않고 `쓰기경로-dev환경필요`.
- 「읽기+쓰기」 행은 읽기 부분의 실측 결과를 적고 note 에 「쓰기 부분 dev 필요」를 병기한다.
- AC-LP-014(e)(vi) 의 `미실측 ≤ 30%` 는 **159 전체 대비 `미실측` 만** 센다
  (`쓰기경로-dev환경필요` 는 `미실측` 과 다른 값이다 — 리드 확인).

## [재현 기법] 샵바이 셀러어드민(NHN)은 iframe 안에 있다

다음 사람이 헤매지 않도록 적어 둔다. 2026-09-17 07:40 실측.

1. 본문은 `service.shopby.co.kr` 가 아니라 **`enterprise-remote.shopby.co.kr` iframe** 안에 렌더된다.
   예: 기초정보 = `…/configuration/basic/info?serviceType=PREMIUM`,
   SMS = `…/member/sms/main/config?...&mallNo=81683`.
2. **주소를 직접 입력하면 좌측 메뉴만 뜨고 폼이 뜨지 않는다.** 반드시 메뉴를 **클릭**해야 iframe 이 이동한다.
3. 메뉴가 접힌 상태에서 항목은 `x = -105`(화면 밖)이라 클릭이 잡히지 않는다 —
   **「전체메뉴 열기」 버튼을 먼저 누르고**, 열린 메가메뉴에서 좌표로 클릭한다.
4. iframe 은 교차 출처라 `contentDocument` 로 못 읽는다. **`page.snapshot()` 이 iframe 내용을 포함**하므로
   그것으로 읽고, 라디오·체크박스의 **선택 상태는 스냅샷에 안 나오므로 스크린샷으로 확인**한다.
5. 그리드의 「상세」 버튼은 「그리드 컬럼 개인 설정」 모달을 여는 함정이 있다(R1d §1) — 누르기 전에 확인한다.

## [HARD] 실측 방법론 3항 — 2026-09-17 사고에서 나온 규칙

`/admin/category-master/` 에서 매뉴얼이 규정한 선행 조작 `click .row` 가
**「엽서/카드 카테고리를 삭제할까요?(논리삭제)」 확인 창**을 띄웠다. 그 화면의 `.row` 가
내부에 `<span class="del" onclick="delRow(event,'CAT_000001')">삭제</span>` 를 품고 있어
행 중앙 클릭이 자식에 닿은 것이다. 피해는 없었다(webadmin·고객 화면 양쪽에 그대로 존재함을
07:58 실측). 다시 일어나지 않게 아래 셋을 고정한다.

1. **다이얼로그 자동 수락 금지.** `acceptDialog()` 를 루프에 넣지 않는다.
   다이얼로그가 뜨면 그 요소는 **`미실측(사유)`** 로 두고 다음으로 넘어간다.
   내용을 읽을 수 없으면 **수락이 아니라 취소(dismiss)** 가 기본이다.
2. **선행 조작은 행 중앙이 아니라 안전한 자식을 지목한다.**
   `.row` 대신 `.row .nm`(이름 영역) 처럼 **읽기 전용이 확실한 자식**으로 좁힌다.
3. **클릭 전에 쓰기 컨트롤 자식을 검사한다.**
   대상 요소 안에 `.del` · `.edit` · `[onclick*=del]` · `[onclick*=save]` 가 있으면
   그 요소는 클릭하지 않고 `쓰기경로-dev환경필요` 또는 `미실측(사유)` 로 처리한다.

> **부수 판정(리드 260917)**: 이 건은 **매뉴얼 결함**이기도 하다 —
> 원고 주석은 「`steps` 는 GET-전용 읽기 조작만 둔다(저장/삭제 클릭 금지)」라고 선언하는데
> `category-master` 의 step 은 쓰기 컨트롤을 품은 행을 지목한다. **D1 부록에 1행**으로 올리고
> 개발자에게 전달한다(오픈 일정과는 무관).

## 선행 조작을 빼면 없는 결함이 보인다 (같은 날 교훈)

첫 순회에서 「매뉴얼에 있는데 화면에 없는 요소」가 8건 나왔으나, **전부 매뉴얼의 선행
`click` step 을 실행하지 않아서**였다. step 을 넣자 `tmpl-combo-md` 는 2/4 → **4/4**,
`edicus-template-md` 는 2/5 → **5/5**, `paper-management` 는 3/4 → **4/4** 로 붙었다.
**캡처의 `steps` 를 실행하지 않은 상태의 판정은 불일치가 아니라 `미실측` 이다.**

## 소유 라벨 (`8dc0a618` 열거형)

`data-owner ∈ {nhn, huni, ext}` · `data-work ∈ {config, dev, wait}`.
**nhn·ext 는 `dev` 금지** · `wait` 은 `ext` 전용 · `ext×wait` 집합 = §8 「선행/외부 대기 항목」과 같은 집합.
이 매트릭스의 행은 webadmin·위젯빌더 매뉴얼이므로 기본값 `huni` / `dev` 이며,
외부 벤더가 끼는 행이 나오면 그 행만 `ext`/`wait` 로 바꾼다.

## [교훈] `{code}` 자리에 데이터 없는 상품을 넣으면 없는 결함이 보인다 (260917 M1.5-②)

「선행 조작을 빼면 없는 결함이 보인다」의 쌍둥이다. 두 번 겪었다.

| 화면 | 처음 넣은 코드 | 결과 | 데이터 있는 코드 | 결과 |
|---|---|---|---|---|
| `product-viewer/{code}/templates/` | `PRD_000046` | `.lnk.edit` **0건** | `PRD_000001` | **11건** |
| `price-viewer/{code}/diagram/` | `PRD_000223`(직접단가) | `단가표 편집` **0건** | `PRD_000145`(가격공식) | **1건** |

`PRD_000223` 의 진단 화면은 「이 상품은 현재 가격공식이 없습니다」라고 **스스로 말한다.**
0건을 `불일치` 로 적기 전에 **그 화면이 무슨 상태인지 먼저 읽는다.** 상태가 「비어 있음」이면
그건 화면 결함이 아니라 **대표 코드 선택 실패**다.

대표 코드는 목록에서 **그 기능을 실제로 쓰는 행**으로 고른다 — 가격 뷰어 목록은 행마다
`공식`(177) / `단가`(66) / `가격없음`(53) 라벨을 달고 있다.

## [교훈] 느슨한 `text=` 매처는 거짓양성을 만든다 (260917 M1.5-②)

첫 순회의 `text=` 판정은 「자식이 3개 이하인 요소의 textContent 에 포함」이었다. 상위 컨테이너가
자식 텍스트를 통째로 품는 바람에 **`＋ 템플릿 지정`·`템플릿 목록에서 빼기`·`이름 저장` 이 전부
「있음」으로 잡혔다**(샘플 텍스트가 `settings 후니 상품·가격 DB 관리자 Railway…` 로 찍혀 드러났다).

**리프 노드 전용**(`e.children.length === 0`)으로 고친 뒤 다시 재자, 같은 화면에서
`템플릿 목록에서 빼기`·`이름 저장` 은 **0건**이었고 — `.tm-row` 선행 클릭 뒤에야 떴다.

규칙: **`text=` 존재 판정은 리프 노드로만 한다.** 그리고 샘플 텍스트를 같이 찍어
**잡힌 게 정말 그 요소인지 눈으로 확인**한다. 찍힌 샘플이 페이지 머리글이면 그 판정은 버린다.

## [재현] 프로브 스크립트

`probe.mjs` — [HARD] 3항(다이얼로그 자동수락 금지 · 안전 자식 · 쓰기 컨트롤 선검사)이 코드로 박혀 있다.
`m15-2-results.jsonl` — 화면 1건 끝날 때마다 즉시 append 한 원시 결과(07:58 증거 유실의 재발 방지책).

```bash
ego-browser nodejs -e "
const fs = await import('node:fs/promises');
const { probeScreen } = await import('<path>/probe.mjs');
const task = await taskSpace(20); const page = task.page('p2');
await probeScreen(page, fs, '<out>/results.jsonl',
  { name:'<capture>', path:'<url>', waitUntil:'domcontentloaded',
    steps:[{action:'wait',ms:900}], selectors:['<selector>', ...] });
"
```

주의 둘: 위젯 계열 화면은 `waitUntil:'domcontentloaded'` 가 아니면 `goto` 가 걸린다.
그리고 **막힌 ego-browser 프로세스가 남아 있으면 뒤 호출이 전부 멈춘다** — 먼저 죽이고 다시 건다.
