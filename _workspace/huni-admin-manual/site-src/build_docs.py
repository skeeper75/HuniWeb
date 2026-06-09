#!/usr/bin/env python3
"""후니 admin 매뉴얼(원본) → MkDocs docs/ 트리 정규화 동기화 스크립트.

원칙:
- 원본 `../manual/*.md`·`../captures/*.png`는 읽기 전용(절대 수정하지 않음).
- 발행용 `docs/` 트리는 매번 깨끗이 재생성(멱등).
- MkDocs는 docs_dir 밖 파일을 가져오지 못하므로 이미지를 docs 안으로 모으고
  본문의 이미지 참조 경로를 정규화한다.
- `00_index.md` → `docs/index.md`(홈)로 이름 변경하고, 챕터 상호링크의
  `00_index.md` 참조도 `index.md`로 치환해 깨진 링크를 방지한다.
- 표준 라이브러리만 사용(pathlib·re·shutil).
"""

from __future__ import annotations

import re
import shutil
from pathlib import Path

# 스크립트 위치 기준 경로 해석(CWD 무관)
SITE_SRC = Path(__file__).resolve().parent
ROOT = SITE_SRC.parent                       # _workspace/huni-admin-manual/
MANUAL_DIR = ROOT / "manual"                 # 원본 매뉴얼(읽기 전용)
CAPTURES_DIR = ROOT / "captures"             # 원본 스크린샷(읽기 전용)
DOCS_DIR = SITE_SRC / "docs"                 # 생성 대상(매번 재생성)
ASSETS_CAPTURES = DOCS_DIR / "assets" / "captures"

# 본문 이미지 참조 정규화: `../captures/X.png` 또는 `captures/X.png`
#   → `assets/captures/X.png`
# (앞에 `(` 또는 공백/시작이 오는 마크다운 링크 형태를 모두 포괄)
IMG_REF_RE = re.compile(r"(?<=\()(?:\.\./)?captures/")

# 00_index.md → index.md 링크 치환(파일명만 정확히 매칭)
INDEX_LINK_RE = re.compile(r"(?<=\()00_index\.md(?=[)#])")


def reset_docs() -> None:
    """docs/ 를 매번 비우고 재생성(stale 산출물 방지·멱등)."""
    if DOCS_DIR.exists():
        shutil.rmtree(DOCS_DIR)
    ASSETS_CAPTURES.mkdir(parents=True, exist_ok=True)


def transform_markdown(text: str) -> str:
    """본문 마크다운의 경로 참조를 docs 트리에 맞게 정규화."""
    text = IMG_REF_RE.sub("assets/captures/", text)
    text = INDEX_LINK_RE.sub("index.md", text)
    return text


def sync_markdown() -> list[str]:
    """manual/*.md → docs/ 복사(00_index.md는 index.md로). 변환 적용."""
    written: list[str] = []
    for src in sorted(MANUAL_DIR.glob("*.md")):
        dest_name = "index.md" if src.name == "00_index.md" else src.name
        dest = DOCS_DIR / dest_name
        content = src.read_text(encoding="utf-8")
        dest.write_text(transform_markdown(content), encoding="utf-8")
        written.append(dest_name)
    return written


def sync_captures() -> int:
    """captures/*.png → docs/assets/captures/ 복사."""
    count = 0
    for src in sorted(CAPTURES_DIR.glob("*.png")):
        shutil.copy2(src, ASSETS_CAPTURES / src.name)
        count += 1
    return count


def main() -> None:
    if not MANUAL_DIR.is_dir():
        raise SystemExit(f"원본 매뉴얼 디렉터리를 찾을 수 없음: {MANUAL_DIR}")
    if not CAPTURES_DIR.is_dir():
        raise SystemExit(f"원본 캡처 디렉터리를 찾을 수 없음: {CAPTURES_DIR}")

    reset_docs()
    md_files = sync_markdown()
    img_count = sync_captures()

    print(f"[build_docs] docs/ 재생성 완료 → {DOCS_DIR}")
    print(f"[build_docs] 마크다운 {len(md_files)}개: {', '.join(md_files)}")
    print(f"[build_docs] 이미지 {img_count}개 → assets/captures/")


if __name__ == "__main__":
    main()
