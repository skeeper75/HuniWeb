# 후니 admin 운영자 매뉴얼 — 문서 사이트 (MkDocs Material)

운영자 매뉴얼(Markdown)을 **Material for MkDocs** 문서 사이트로 발행하는 프로젝트입니다.
원본 매뉴얼은 손대지 않고(권위 보존), 발행용 `docs/` 트리만 빌드 스크립트가 생성합니다.

## 구조

```
_workspace/huni-admin-manual/
├── manual/                 # 원본 매뉴얼(권위, 손대지 않음)
├── captures/*.png          # 원본 스크린샷(권위, 손대지 않음)
└── site-src/               # ← 이 디렉터리 (MkDocs 프로젝트)
    ├── mkdocs.yml          # Material 테마·한글·검색·nav 설정
    ├── build_docs.py       # manual/+captures/ → docs/ 정규화 동기화(멱등)
    ├── requirements-docs.txt
    ├── docs/               # build_docs.py가 생성(자동) — git 추적 제외
    └── site/               # mkdocs build 출력(HTML) — git 추적 제외
```

`build_docs.py`가 하는 일(멱등):

- `manual/00_index.md` → `docs/index.md`(홈), `manual/NN_*.md` → `docs/NN_*.md`
- 본문 이미지 참조 `../captures/X.png`·`captures/X.png` → `assets/captures/X.png` 치환
- 챕터 상호링크의 `00_index.md` → `index.md` 치환(이름 변경된 홈 링크 보정)
- `captures/*.png` → `docs/assets/captures/` 복사
- `docs/`는 매번 비우고 재생성(stale 방지). 원본 `manual/`·`captures/`는 읽기 전용.

## 로컬 빌드 (venv 필수 — 시스템 전역 설치 금지)

PEP 668(externally-managed) 환경 보호를 위해 반드시 가상환경을 씁니다.

```bash
# 1) 가상환경 생성·활성화
python3 -m venv _workspace/huni-admin-manual/site-src/.venv
source _workspace/huni-admin-manual/site-src/.venv/bin/activate

# 2) 의존성 설치(버전 고정)
pip install -r _workspace/huni-admin-manual/site-src/requirements-docs.txt

# 3) docs/ 정규화 생성
python _workspace/huni-admin-manual/site-src/build_docs.py

# 4) 빌드(엄격 모드 — 깨진 링크·누락 이미지를 실패로 처리)
mkdocs build -f _workspace/huni-admin-manual/site-src/mkdocs.yml --strict

# 5) 로컬 미리보기(선택)
mkdocs serve -f _workspace/huni-admin-manual/site-src/mkdocs.yml
```

`--strict`가 통과하면 깨진 링크·누락 이미지가 0건이라는 뜻입니다.
빌드 출력은 `site-src/site/`에 생성됩니다.

> 매뉴얼 내용에 문제(깨진 링크·누락 이미지)가 있어도 **원본 매뉴얼을 직접 고치지 마세요.**
> 발행가는 원본을 권위로 보존합니다. 경로 정규화 문제면 `build_docs.py`를,
> 누락 챕터·잘못된 차례면 `mkdocs.yml`의 `nav`를 고칩니다. 내용 결함은 매뉴얼 작가
> (`ham-manual-writer`) 하네스로 환원합니다.

## 자동 배포 (GitHub Actions · docs-as-code)

워크플로 템플릿: **`site-src/ci/docs.yml`**.

> **CI 활성화 방법**: 이 템플릿을 레포 루트 `.github/workflows/docs.yml`로 복사한 뒤
> push하세요. (CI 워크플로 파일은 git push에 OAuth `workflow` scope가 필요해
> 템플릿으로 보관합니다 — 복사는 `workflow` scope 있는 인증 또는 GitHub 웹 UI에서.)
> 이후 GitHub → Settings → Pages → Source를 **GitHub Actions**로 설정하면 배포됩니다.

- **트리거**: `main` 브랜치 push 중 `manual/**`·`captures/**`·`site-src/**` 변경 시.
- **단계**: checkout → setup-python → pip 캐시 → 의존성 설치 →
  `build_docs.py`(정규화) → `mkdocs build --strict` →
  `upload-pages-artifact` → `deploy-pages`.
- **권한**: `contents: read`·`pages: write`·`id-token: write`.

매뉴얼 *재생성*(내용 변경)은 사람이 하네스로 수행하고 QA(GO) 후 커밋합니다.
CI는 빌드·배포만 자동입니다 — 검증 안 된 매뉴얼이 자동 발행되지 않습니다.

## 호스팅 연결 (인간 승인 필요)

CI 워크플로는 작성돼 있으나 실제 게시를 위해 아래는 사용자가 직접 해야 합니다.

1. **GitHub Pages 활성화**: HuniWeb 레포 → Settings → Pages →
   **Build and deployment → Source = "GitHub Actions"** 로 설정.
   (이 설정 전에는 `deploy` 잡이 실패하거나 배포되지 않습니다.)
2. **권한 확인**: 워크플로의 `pages: write`·`id-token: write` 권한은 이미 선언돼 있습니다.
   조직 정책으로 Actions 권한이 제한돼 있으면 Settings → Actions에서 허용해야 합니다.
3. **첫 배포 확인**: 활성화 후 push(또는 Actions 탭 → workflow_dispatch 수동 실행)로
   배포 URL(`https://skeeper75.github.io/HuniWeb/`)을 확인합니다.

## webadmin(대상 코드) 배포 연동

대상 코드 `HuniProductPrice2`(별도 레포·Railway)가 배포돼 admin 화면이 바뀌면
매뉴얼 갱신이 필요합니다. 자동화 수준은 **빌드·배포만 자동**이므로 매뉴얼 재생성은
사람이 하네스로 트리거합니다. 두 가지 연동 옵션:

### 1) 알림형 (권장·기본)

`HuniProductPrice2` 배포 워크플로 끝에 "매뉴얼 갱신 필요" 이슈/알림을 생성합니다.
운영자가 HuniWeb에서 `huni-admin-manual-orchestrator`(또는 부분 재실행)로 매뉴얼을
갱신 → QA GO → 커밋하면 HuniWeb CI가 사이트를 자동 발행합니다.

예시(대상 레포 워크플로 끝에 추가):

```yaml
- name: Notify manual update needed
  if: success()
  uses: actions/github-script@v7
  with:
    github-token: ${{ secrets.HUNIWEB_DISPATCH_TOKEN }}  # repo:issues 권한 PAT
    script: |
      await github.rest.issues.create({
        owner: 'skeeper75', repo: 'HuniWeb',
        title: '[manual] webadmin 배포됨 — 매뉴얼 갱신 검토 필요',
        body: `대상 코드(HuniProductPrice2)가 배포됐습니다. admin 화면 변경 여부를 확인하고\n` +
              `필요 시 huni-admin-manual 하네스로 매뉴얼을 갱신하세요. (커밋 ${context.sha})`,
        labels: ['manual', 'needs-review']
      });
```

### 2) repository_dispatch형 (고급)

배포 성공 시 `repository_dispatch`로 HuniWeb에 신호를 보내 갱신 대기 이슈를 자동
생성합니다. 여전히 사람이 하네스를 실행·QA합니다(LLM 하네스를 CI에서 무인 실행하지 않음).

```yaml
- name: Dispatch to HuniWeb
  if: success()
  run: |
    curl -X POST \
      -H "Authorization: Bearer ${{ secrets.HUNIWEB_DISPATCH_TOKEN }}" \
      -H "Accept: application/vnd.github+json" \
      https://api.github.com/repos/skeeper75/HuniWeb/dispatches \
      -d '{"event_type":"webadmin-deployed","client_payload":{"sha":"${{ github.sha }}"}}'
```

HuniWeb 측에서 `on: repository_dispatch: types: [webadmin-deployed]`로 받아
갱신 대기 이슈를 생성하는 워크플로를 추가하면 됩니다.

> 두 옵션 모두 **cross-repo 시크릿**(`HUNIWEB_DISPATCH_TOKEN` PAT)이 필요하며,
> 실제 토큰 발급·시크릿 등록·활성화는 인간 승인 대상입니다.
