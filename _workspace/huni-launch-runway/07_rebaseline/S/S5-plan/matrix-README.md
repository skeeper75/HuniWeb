# manual-element-matrix.csv — 읽는 법·재현 방법

## 분모 산출 규칙 (D1 이 선언하고 D3 가 재계산한다)

**요소 1건 = 매뉴얼 원고가 `selector` 로 화면 위 한 지점을 지목하고 `label` 로 설명한 콜아웃 하나.**
콜아웃이 없는 화면(`MODEL_ADMIN_SCREENS` — `one_liner` 만 보유)은 **화면 1건을 요소 1건**으로 센다.
`steps` 는 요소가 아니라 그 요소에 도달하는 조작이므로 **분모에서 제외**하고 경로 종류 판정에만 쓴다.

재현 명령(이 값을 어디에도 상수로 적지 않는다):

```bash
cd raw/webadmin/tools && python3 -c 'import importlib.util as u
def L(n,p):
    s=u.spec_from_file_location(n,p); m=u.module_from_spec(s); s.loader.exec_module(m); return m
mc=L("mc","manual_content.py"); wc=L("wc","widget_manual_content.py")
n=sum(len(c.get("callouts",[])) for s in mc.SCREENS for c in s.get("captures",[]))
n+=sum(len(c.get("callouts",[])) for s in wc.SCREENS for c in s.get("captures",[]))
n+=len(mc.MODEL_ADMIN_SCREENS); print(n)'
```

## 두 분모를 섞지 않는다 (리드 판정 260917)

| 분모 | 값 | 쓰는 곳 |
|---|---|---|
| **메뉴 지도** | **37** (사이드바 33 + 비사이드바 4) | AC-LP-014(e)(v) 화면 축 하한. 위젯빌더 24 SCREENS 는 **「위젯빌더」 메뉴 1건에 귀속**한다 |
| **화면단위 / 요소** | **50 화면단위 · 159 요소** | 매트릭스 행과 요약 층 집계 |

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

## 소유 라벨 (`8dc0a618` 열거형)

`data-owner ∈ {nhn, huni, ext}` · `data-work ∈ {config, dev, wait}`.
**nhn·ext 는 `dev` 금지** · `wait` 은 `ext` 전용 · `ext×wait` 집합 = §8 「선행/외부 대기 항목」과 같은 집합.
이 매트릭스의 행은 webadmin·위젯빌더 매뉴얼이므로 기본값 `huni` / `dev` 이며,
외부 벤더가 끼는 행이 나오면 그 행만 `ext`/`wait` 로 바꾼다.
