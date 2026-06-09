---
name: huni-admin-docs-publish
description: 후니 admin 운영자 매뉴얼(Markdown)을 Material for MkDocs 문서 사이트로 발행하고, GitHub Actions로 빌드·배포를 자동화(docs-as-code)하는 방법론 스킬. 매뉴얼 md를 MkDocs docs_dir 구조로 정규화(이미지 경로 변환·멱등·원본 보존)하는 빌드 스크립트, mkdocs.yml 핵심 설정(Material 테마·한글 lang/검색·nav·admonition·코드복사), GitHub Actions 워크플로(push→build→GitHub Pages), requirements 고정, venv 로컬 빌드 검증, webadmin 코드 배포 연동(cross-repo repository_dispatch) 옵션을 제공한다. 'mkdocs', '문서 사이트', '문서 발행', '매뉴얼 사이트', 'docs 빌드', 'docs-as-code', 'GitHub Pages 배포', '문서 CI', '매뉴얼 배포 자동화', 'Material for MkDocs' 작업 시 반드시 이 스킬을 사용. 매뉴얼 집필 자체는 huni-admin-manual-authoring가 담당한다.
---

# Huni Admin 매뉴얼 → MkDocs 문서 사이트 발행

운영자 매뉴얼(Markdown)을 **Material for MkDocs** 문서 사이트로 발행하고 CI로 자동 빌드·배포하는 방법론. 도구 선정 근거는 우리 컨텍스트(Python/Django 대상·순수 Markdown 매뉴얼·운영자 가이드·docs-as-code)에서 MkDocs Material이 최적이기 때문이다.

## 왜 docs-as-code · 왜 MkDocs Material

- **docs-as-code**: 매뉴얼 md = git 소스. 사람이 하네스로 매뉴얼을 갱신·QA한 뒤 커밋하면, CI가 사이트를 자동 빌드·배포한다. 검증 안 된 매뉴얼이 자동 발행되지 않게 하는 표준 패턴.
- **MkDocs Material**: 매뉴얼이 이미 순수 Markdown → 변환 0. Python(pip) 생태계로 대상 시스템과 일관. 검색·admonition·이미지·한글 지원, GitHub Actions 배포 베스트프랙티스 성숙.

## 사이트 구조 (원본 보존 · 정규화 빌드)

매뉴얼 원본(`_workspace/huni-admin-manual/manual/*.md` + `captures/*.png`)은 **건드리지 않고**, 발행용 `docs/` 트리를 빌드 스크립트로 생성한다(멱등). MkDocs는 docs_dir 밖 파일을 가져오지 못하므로 이미지를 docs 안으로 모으고 경로를 정규화한다.

```
_workspace/huni-admin-manual/
├── manual/                 # 원본 매뉴얼(권위, 손대지 않음)
│   ├── 00_index.md ... 10_appendix.md
├── captures/*.png          # 원본 스크린샷(권위)
└── site-src/               # MkDocs 프로젝트 (발행 산출물)
    ├── mkdocs.yml
    ├── requirements-docs.txt
    ├── build_docs.py       # manual/+captures → docs/ 정규화 동기화(멱등)
    └── docs/               # 빌드 스크립트가 생성(자동) — git 추적 제외 권장
        ├── index.md        # ← manual/00_index.md
        ├── 01_*.md ...
        └── assets/captures/*.png  # ← ../captures, 경로 정규화
```

### 정규화 빌드 스크립트(build_docs.py) 규칙

- `manual/00_index.md` → `docs/index.md`(홈), `manual/NN_*.md` → `docs/NN_*.md` 복사.
- 본문 이미지 참조 `../captures/X.png` 또는 `captures/X.png` → `assets/captures/X.png`로 치환(정규식, 멱등).
- `captures/*.png` → `docs/assets/captures/`로 복사.
- 원본 manual/·captures/는 읽기만(수정 금지). docs/는 매번 재생성(stale 방지).
- 챕터 내부 상호링크(`09_screen-reference.md` 등)는 파일명 유지되므로 그대로 동작.

## mkdocs.yml 핵심 설정

```yaml
site_name: 후니 상품·가격 DB 관리자 운영자 매뉴얼
docs_dir: docs
theme:
  name: material
  language: ko
  features: [navigation.sections, navigation.top, navigation.instant, search.suggest, content.code.copy, toc.follow]
  palette: [{ scheme: default, primary: indigo, toggle: ... }, { scheme: slate, ... }]
plugins:
  - search:
      lang: [ko, en]      # 한글 검색
markdown_extensions:
  - admonition            # 콜아웃(주의/팁) 렌더
  - pymdownx.details
  - attr_list
  - md_in_html
  - toc: { permalink: true }
nav:
  - 시작하기: [index.md, 01_getting-started.md]
  - 상품 관리: [02_product-register.md, 03_product-sections.md]
  - 옵션·SKU·제약: [04_options.md, 05_sku-templates.md, 06_constraints.md]
  - 마스터·가격: [07_masters.md, 08_pricing.md]
  - 레퍼런스·부록: [09_screen-reference.md, 10_appendix.md]
```

- **admonition**: 매뉴얼의 `> ⚠️`·`> 💡`·`> ℹ️` blockquote는 그대로 렌더된다. 더 보기 좋게 하려면 빌드 스크립트가 `> ⚠️ **주의:**` → `!!! warning` 블록으로 선택 변환할 수 있으나, 원본 가독성 보존을 위해 기본은 blockquote 유지.
- **nav**: 매뉴얼 목차(00_index) 구조와 일치시킨다.
- **한글 검색**: `search.lang: [ko, en]`. (ko는 jieba 등 추가 의존 불필요 — MkDocs 기본 토크나이저로 동작, 필요 시 plugin 보강.)

## requirements 고정

```
mkdocs-material>=9.5
mkdocs>=1.6
```

버전을 고정해 CI/로컬 빌드 재현성을 보장한다.

## GitHub Actions (HuniWeb 레포 — docs-as-code)

`.github/workflows/docs.yml`:
- **트리거**: `push` to main, `paths: ['_workspace/huni-admin-manual/manual/**', '_workspace/huni-admin-manual/captures/**', '_workspace/huni-admin-manual/site-src/**']` — 매뉴얼·캡처·사이트 설정 변경 시에만.
- **단계**: checkout → setup-python → `pip install -r site-src/requirements-docs.txt` → `python site-src/build_docs.py`(정규화) → `mkdocs build -f site-src/mkdocs.yml` → GitHub Pages 배포(`actions/deploy-pages` 또는 `mkdocs gh-deploy --force`).
- **캐시**: `actions/cache`로 pip·`~/.cache` 캐시(주간 갱신)해 빌드 가속(Material 공식 권장).
- **권한**: `permissions: { contents: read, pages: write, id-token: write }`(Pages 배포).

## webadmin 코드 배포 연동 (옵션 — cross-repo)

대상 코드(`HuniProductPrice2`)가 배포돼 admin 화면이 바뀌면 매뉴얼 갱신이 필요하다. 자동화 수준은 **빌드·배포만 자동(docs-as-code)** 이므로 매뉴얼 *재생성*은 사람이 하네스로 트리거한다. 연동 옵션:

1. **알림형(권장·기본)**: webadmin 배포 워크플로 끝에 "매뉴얼 갱신 필요" 이슈/알림 생성. 운영자가 HuniWeb에서 `huni-admin-manual-orchestrator`(또는 부분 재실행)로 매뉴얼 갱신 → QA GO → 커밋 → HuniWeb CI가 사이트 자동 발행.
2. **repository_dispatch형(고급)**: webadmin 배포 성공 시 `repository_dispatch`로 HuniWeb에 신호 → HuniWeb이 매뉴얼 갱신 대기 이슈 생성(여전히 사람이 하네스 실행·QA). LLM 하네스를 CI에서 무인 실행하지 않는다(비결정성·검증 부담 회피).

이 연동은 산출물에 워크플로 예시 + README 안내로 문서화하되, 실제 cross-repo 시크릿·활성화는 인간 승인 대상이다.

## 로컬 빌드 검증

```bash
python3 -m venv _workspace/huni-admin-manual/site-src/.venv
source _workspace/huni-admin-manual/site-src/.venv/bin/activate
pip install -r _workspace/huni-admin-manual/site-src/requirements-docs.txt
python _workspace/huni-admin-manual/site-src/build_docs.py
mkdocs build -f _workspace/huni-admin-manual/site-src/mkdocs.yml --strict
```

- `--strict`로 깨진 링크·누락 이미지를 빌드 실패로 잡는다(전수 검증). `site/`(빌드 출력)와 `.venv/`·`docs/`(생성물)는 git 추적에서 제외.

## 완료 기준

- `mkdocs build --strict` 무경고 성공(깨진 링크·이미지 0)
- 모든 매뉴얼 챕터가 nav에 노출 + 스크린샷이 사이트에서 렌더
- CI 워크플로·requirements·빌드 스크립트·README 산출
- 원본 manual/·captures/ 무수정(발행은 docs/로만)
- 시크릿·Pages 활성화 등 호스팅 연결은 인간 승인 대상으로 명시
