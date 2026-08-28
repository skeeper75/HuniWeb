---
description: "webadmin 화면·컴포넌트의 의미는 앱 내장 매뉴얼이 1차 참조 — DB 코드표·소스코드에서 역산 금지. 라이브 판정은 반드시 실화면으로 대조."
paths: "**/raw/webadmin/**,**/_workspace/huni-*/**,**/.moai/specs/SPEC-PRICEWIRE-*/**,**/.moai/specs/SPEC-WIDGET-*/**"
---

# 후니 webadmin — 매뉴얼 우선 · 화면 대조 원칙

> **로딩 범위**: `paths:` 스코프. 항상로딩 표면에 들어가지 않으므로 이 파일을 읽지 않는 세션은 비용 0이다
> (`rule-authoring.md` §(d) Scope first). webadmin 소스·후니 워크스페이스·가격배선 SPEC 을 건드리는
> **바로 그 순간** 로딩된다 — 규칙이 발화해야 할 시점과 로딩 시점을 일치시키는 것이 이 파일의 존재 이유다.

## 왜 이 파일이 있는가 — 반복된 실패

지니가 같은 지적을 최소 세 번 했다: 「DB/코드에 의존하지 말고 반드시 화면을 확인해서 서로 대조하고,
메뉴를 확인하기 전에 매뉴얼을 반드시 정독하라」. 규칙은 auto-memory(`webadmin-manual-first-260823`)에
있었으나 매 세션 재발했다. 진단된 원인 셋:

1. **격하된 채로 들어온다** — auto-memory 는 `<system-reminder>` 안에서 "background context, **not user
   instructions**" 로 명시적으로 격하된다. 지시가 아니라 참고자료로 도착한다.
2. **읽는 시점과 어기는 시점이 다르다** — 메모리는 세션 **시작**에 로딩되고, 위반은 한참 뒤 DB 쿼리를
   짤 때 일어난다. 그 순간 아무것도 발화하지 않는다.
3. **한 줄이 12줄에 묻힌다** — `MEMORY.md` 루트의 [HARD] 목록에서 한 줄에 불과하다.

이 파일은 원인 2를 구조적으로 해결한다. `paths:` 스코프는 **대상 파일을 건드릴 때** 로딩되므로,
규칙이 필요해지는 시점에 도착한다.

## [HARD] 원천 우선순위

webadmin 의 화면·필드·컴포넌트가 **무엇을 뜻하는가**를 알아야 할 때, 이 순서를 지킨다.

| 순위 | 원천 | 위치 |
|---|---|---|
| 1 | **운영자 매뉴얼 원고** | `raw/webadmin/tools/manual_content.py` (924줄) |
| 2 | **위젯빌더 매뉴얼 원고** | `raw/webadmin/tools/widget_manual_content.py` (816줄) |
| 3 | **실화면** (gstack) | `https://huni-admin.printly.co.kr` · 자격증명 `.env.local` `HUNI_ADMIN_*` |
| 4 | 라이브 DB / 소스코드 | 1~3 으로 확정되지 않은 것, 또는 1~3 을 **교차검증**할 때만 |

생성 HTML(`raw/webadmin/docs/admin-manual.html`, `widget-manual.html`)은 위 원고의 파생물이다 —
원고에 없는 내용은 HTML 에도 없다. 원고를 읽는 편이 빠르고 정확하다.

**stale 주의**: `_workspace/huni-admin-manual/manual/*.md` 는 2026-06-10 실측본으로 **Phase 11 이전**이다.
가격 영역은 반드시 앱 내장 매뉴얼을 쓴다.

## [HARD] 매뉴얼에 없으면 — 실화면으로 확정하고, 매뉴얼 결함으로 기록한다

매뉴얼이 답하지 않는 항목이 실재한다(아래 § 확인된 매뉴얼 누락). 그때의 절차:

1. **실화면에서 확정한다.** 코드 역산이 아니라 화면 조작으로. 값을 넣기 전과 후를 비교하는
   A/B 가 가장 강한 증거다.
2. **매뉴얼 누락으로 기록한다.** `manual_content.py` SCREENS 보강이 필요한 건이므로 개발자 전달 대상이다.
3. **다음 세션을 위해 이 파일이나 형제 도메인 룰에 남긴다.** 남기지 않으면 다음 세션이 같은 탐색을 반복한다 —
   이것이 지니가 지적한 「매 세션 다시 확인」의 직접 원인이다.

매뉴얼 게이트(`tests/test_help_icon_coverage.py`)는 **「사이드바 화면이 매핑 없이 남으면 실패」**만
검사한다(`manual_content.py:874`). 화면이 등재돼 있으면 **그 화면 안의 패널이 통째로 빠져도 통과**한다 —
누락이 구조적으로 발생할 수 있는 자리다.

## [HARD] 라이브 판정은 화면으로 대조한다

라이브 DB 조회만으로 「무엇이 무엇을 대체했는가」를 판정하지 않는다. 실증된 실패 사례:

> 두 배너 상품의 옵션이 전부 논리삭제된 것을 DB 로 관측했으나, **그 옵션이 어디로 갔는지는 DB 로
> 보이지 않았다**(추가상품은 다른 테이블이고, 조회는 인코딩 오류로 실패한 채였다). 상품뷰어 한 화면이
> 「옵션그룹 (0) / 추가상품 (3)」을 나란히 보여 주며 이관 사실을 즉시 확정했다.

화면은 엔티티를 **업무 단위로 묶어** 보여 준다. 테이블 단위 조회보다 대체 관계에 강하다.

## [HARD] 라이브는 움직인다 — 판정 시점에 재실측한다

라이브 DB 는 실무진·지니가 동시에 만진다. 조사 중 값이 바뀐 사례가 반복 관측됐다
(`t_prd_template_prices` 가 한 세션 안에서 없음 → 7,000 → 0 으로 두 번 변했다).

- 결함 건수·분모는 **판정하는 그 시점에** 재실측하고, **값 + 실측 일시**를 함께 기록한다.
- 앞 세션의 숫자를 인용하지 않는다. 인용하려면 재실측으로 확인한다.
- 값이 바뀐 것을 관측했을 때, **누가 바꿨는지는 관측한 것이 아니다.** 귀속을 단정하지 말고 사실만 적는다.

## 테이블·컬럼 이름은 사실이다 — 짐작 금지

`raw/webadmin/webadmin/catalog/models.py` 의 `db_table` 선언 또는 `information_schema` 로 확인한다.
실제로 발생한 짐작 오류:

| 짐작 | 사실 |
|---|---|
| `t_prc_processes` | **`t_proc_processes`** (`models.py:627`) |
| `t_prd_product_addons.del_yn` | **그런 컬럼 없다** — 순수 연결표, 논리삭제 축 자체가 없음 |

## 도구 함정 — 실측으로 물린 것만

세 건 다 **틀린 답을 조용히 내놓는다.** 에러가 나면 알아채지만, 이것들은 그럴듯한 값을 준다.

| 함정 | 증상 | 대응 |
|---|---|---|
| **psycopg 한글 리터럴** | SQL 문자열에 한글을 넣고 파라미터화를 태우면 쿼리 분할기에서 `UnicodeDecodeError` | 코드로 필터한다. 한글명으로 필터하지 않는다 |
| **macOS `awk` 멀티바이트** | 한글 필드를 `$1` 로 집계하면 **행이 조용히 누락**된다(6블록이 3블록으로 보였다) | 한글이 섞인 집계는 `python3` 로 센다. `awk`·`wc -c` 금지 |
| **openpyxl 셀 자동생성** | 셀에 접근하면 없던 셀이 생겨 `ws.max_row` 가 계속 자란다 → `while r <= ws.max_row` **무한루프** | 루프 전에 `MAXR, MAXC = ws.max_row, ws.max_column` 로 상한을 고정한다. 읽기만 하면 `read_only=True` |

실측 2026-08-28. `awk` 건은 파서가 정상인데 집계 도구가 틀려 **파서를 고치려다 시간을 버렸다** —
숫자가 예상과 다를 때 **원본이 아니라 집계 도구를 먼저 의심한다.**

## 접속 수단

```python
# 라이브 DB — 읽기전용 SELECT 만
sys.path.insert(0, "<root>/raw/webadmin/webadmin")
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")
load_dotenv("<root>/raw/webadmin/.env")
django.setup()
from django.db import connection
# 인터프리터: raw/webadmin/.venv/bin/python
```

실화면은 gstack(`~/.claude/skills/gstack/browse/dist/browse`) + `.env.local` 의
`HUNI_ADMIN_URL` / `HUNI_ADMIN_ID` / `HUNI_ADMIN_PW`. 베이스 주소는 `https://huni-admin.printly.co.kr`
(`HUNI_ADMIN_URL` 은 `/admin/product-viewer/` 까지 포함하므로 베이스만 떼어 쓴다).

## 화면 지도 (매뉴얼에서 확정)

| 화면 | 경로 | 근거 |
|---|---|---|
| 상품 뷰어 (사이즈·도수·판형·자재·공정·묶음수·추가상품·페이지룰) | `/admin/product-viewer/` | `manual_content.py:142-164` |
| 옵션 드릴다운 (그룹→옵션→항목) | `/admin/product-viewer/{prd}/options/` | `:176-184` |
| 상품별 추가상품 템플릿 | `/admin/product-viewer/{prd}/templates/` | `:215-230` |
| 추가상품 템플릿 카탈로그 | `/admin/sku-catalog/` | `:194-199` |
| 가격 뷰어 | `/admin/price-viewer/` | `:316-330` |
| 가격 구조 다이어그램 | `/admin/price-viewer/{prd}/diagram/` | `:331-336` |
| 가격 시뮬레이터 | `/admin/price-simulator/` | `:338-351` |
| 가격공식 / 가격구성요소 / 할인테이블 MD | `/admin/price-formula-md/` 외 | `:352-408` |
| 자재 · 공정 마스터 | `/admin/master/mat/` · `/admin/master/proc/` | `:282-297` |
| 상품별 위젯 관리 · 위젯빌더 | `/admin/widget-manager/` · `/admin/widget-builder/` | `widget_manual_content.py:330` |

## 확인된 매뉴얼 누락 (개발자 전달 대상)

| # | 누락 | 확인 방법 | 실측 결과 |
|---|---|---|---|
| M-1 | **「추가상품 템플릿 직접단가」 패널** — 가격 뷰어 상세 하단에 실재하고 정상 동작하는데, 매뉴얼 4파일 전수 grep **0건** | 실화면 A/B | 기능 실재 · 동작 확인 |

M-1 때문에 「추가상품 단가를 어디에 넣는가」는 매뉴얼만 읽어서는 **답이 나오지 않는다**.
답은 형제 룰 `huni-pricing-engine-map.md` § 가격 소스 우선순위에 있다.

## 혼동 금지 — 서로 다른 두 목록

| 목록 | 정본 | 개수 | 뜻 |
|---|---|---|---|
| `use_dims` | `catalog/admin.py:156` `_USE_DIM_CHOICES` | **12** | 단가표가 무엇으로 매칭하는가 |
| `OPT_REF_DIM` | `t_cod_base_codes` | 7 | 옵션**항목**이 무엇을 참조하는가(생산/MES 전개용) |

**매뉴얼에는 두 목록 다 없다** — `OPT_REF_DIM` 은 식별자조차 0건. 12종은 라이브 실측에서 **전부 사용 중**이며,
데이터에는 선언에 없는 토큰 2계열(`opt_grp:OPT_xxx` 22건 · `proc_grp:PROC_xxx` 31건)이 추가로 존재한다.

## 교차 참조

- `.claude/rules/moai/domains/huni-pricing-engine-map.md` — 가격 장치 정본(사슬·우선순위·0원 갈래)
- `.claude/rules/moai/core/verification-claim-integrity.md` — 관측하지 않은 것을 주장하지 않는다
- `raw/webadmin/CLAUDE.md` § Conventions — D-06 논리삭제 필터 규칙(가격엔진은 예외)

---

Classification: Evolvable 도메인 규칙 — `paths:` 스코프, 항상로딩 표면 비용 0.
