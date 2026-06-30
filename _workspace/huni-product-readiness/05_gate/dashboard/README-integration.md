# 상품 준비도 대시보드 — 산출물 & webadmin 통합 가이드

평가 결과(`05_gate/product-details-final.json` 283항목)를 기존 webadmin `product_viewer` UX로
재사용한 인터랙티브 준비도 대시보드입니다. **두 형태**로 제공합니다.

## 산출물

| 파일 | 용도 |
|---|---|
| `dashboard.html` | **standalone** — 데이터 임베드, 더블클릭으로 브라우저에서 바로 열림(서버 불필요). 사내 공유·리뷰용. |
| `django_app/readiness_viewer.py` | webadmin 드롭인 **읽기전용 뷰**(`product_viewer` 패턴). |
| `django_app/templates/catalog/readiness_viewer.html` | 위 뷰의 템플릿(`base_site.html` 확장·Unfold 테마 상속·`json_script` 임베드). |
| `build_dashboard.py` | 빌더. JSON만 갱신 후 `python3 build_dashboard.py` 재실행 → 두 산출 동시 갱신(레이아웃 보존). |

> **유일한 외부 의존 = Cytoscape.js**(CDN `unpkg.com/cytoscape@3.30.2`). 인터넷이 되면 그래프가 그려지고,
> 안 되면 그래프 자리에 안내문이 뜨고 나머지(사이드바·차원표·골든)는 정상 동작합니다.

## 대시보드 구성

- **상단 요약** — 전체 283(분모)·평균 완성률 63.5%·계산 가능(PRICE≠0) 수·위젯 대상(eligible=Y) 80·L3+ 수·등급 분포(L0 빨강→L4 초록). ★`golden_status` 다수가 "골든 미대조"임을 명시(계산은 되나 예전사이트 정답가 전수 일치는 미검증).
- **좌측 사이드바** — 상품군 그룹·검색·등급 색 배지·필터(등급/종이류/위젯대상만/PRICED-0만). 플래그: `W`=위젯대상·`0`=PRICED-0·`검`=검증 전.
- **우측 상세** — ① 헤더(상품명·prd_cd·등급·완성률·위젯클래스·widget_eligible·golden_status) ② **Cytoscape 플로우 그래프**(상품→구성요소→가격공식→가격구성요소→단가행, 노드색=PASS/WARN/FAIL·N/A 회색 점선, 끊긴 연결=빨강 점선=견적 0 원인) ③ **차원 D1~D11 표**(예상[권위] vs 실제[라이브 적재]+판정) ④ 골든(입력·기대가·실제가·판정) ⑤ 다음 한 걸음 + 게이트 메모.

## webadmin 통합 (인간 승인 후 개발팀 §6/webadmin 트랙)

> **raw/webadmin 은 직접 수정하지 않았습니다.** 아래는 통합 시 webadmin 레포에서 할 작업입니다.

### 1) 파일 배치 (HuniProductPrice2 레포 기준)

```
catalog/
  readiness_viewer.py                         ← django_app/readiness_viewer.py 복사
  templates/catalog/readiness_viewer.html     ← django_app/templates/catalog/readiness_viewer.html 복사
_data/readiness/product-details-final.json    ← 05_gate/product-details-final.json 복사(데이터 사본)
```

데이터 경로는 `settings.READINESS_DATA_JSON` 으로 덮어쓸 수 있습니다(미설정 시 `_data/readiness/...` 폴백).

### 2) URL 1줄 등록 (읽기전용)

webadmin 은 커스텀 뷰를 `get_urls()` 로 admin 에 붙입니다(`product_viewer` 와 동일 패턴). 해당 `AdminSite`/urls 에 추가:

```python
from catalog.readiness_viewer import readiness_viewer
# admin custom urls 목록에:
path("readiness-viewer/", admin.site.admin_view(readiness_viewer), name="readiness-viewer"),
```

`admin.site.admin_view(...)` 래핑으로 **admin 로그인 강제 = 읽기전용 인증**. 접속: `/admin/readiness-viewer/`.

### 3) Cytoscape 정적자산 (선택 — 사내망/오프라인)

기본은 CDN 입니다. 폐쇄망이면:

1. `cytoscape.min.js` 를 `catalog/static/catalog/cytoscape.min.js` 로 vendoring.
2. 템플릿의 `<script src="https://unpkg.com/cytoscape@3.30.2/...">` 를
   `<script src="{% static 'catalog/cytoscape.min.js' %}">` 로 교체.
3. `python manage.py collectstatic`.

## 안전·범위

- **읽기전용** — 저장/삭제/POST 없음(표시만). DB 접속 없음(빌드 시점 JSON 스냅샷).
- **비밀값 비노출** — 자격증명·개인정보 없음. 데이터는 평가 산출 JSON(상품/등급/차원/골든)만.
- **GO 안 난 상품도 숨기지 않음** — L3 미만·PRICED-0 등은 `검`/`0` 플래그로 표시.
- **React Flow 미채택** — React 빌드가 필요해 Cytoscape(빌드 불필요)로 대체. 교체 시 `build_dashboard.py` 의 `FLOW`/`FLOW_EDGES` 모델을 React Flow `nodes`/`edges` 로 그대로 이식 가능(JS 주석 참조).

## 데이터 갱신

평가가 다시 돌면 `05_gate/product-details-final.json` 만 갱신하고:

```bash
cd _workspace/huni-product-readiness/05_gate/dashboard
python3 build_dashboard.py
```

레이아웃/스타일은 빌더 안에 있어 보존되고, 데이터·요약만 새로 임베드됩니다.
