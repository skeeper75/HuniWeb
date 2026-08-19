#!/usr/bin/env python3
"""
RedPrinting 상품페이지 실측 캡처 — 편집기 구성이 무엇으로 갈리는지 확인용.

목적: private_css 로는 못 하는 레이아웃 차이(좌측 레일 / 우측 옵션패널 /
      모양컷 단독 등)가 Edicus 쪽 어느 설정에서 오는지 근거를 잡는다.

읽기 전용. 주문·결제·폼 제출 없음. 상품 조회 응답만 받아 적는다.

실행: .venv-cap/bin/python capture-rp.py
"""
import json, pathlib, re

OUT = pathlib.Path(__file__).parent / "raw" / "cap-260819"
OUT.mkdir(parents=True, exist_ok=True)

TARGETS = [
    ("ACTHPEN", "https://www.redprinting.co.kr/ko/product/item/AC/ACTHPEN"),
    ("CLSTDLD", "https://www.redprinting.co.kr/ko/product/item/CL/CLSTDLD"),
]

# capture_xhr 는 URL 에 걸 정규식 문자열을 받는다 (scrapling _create_response_handler)
XHR_PATTERN = r"(?i)get_digital_product_info|product_info|editor|edicus|makers\.|template|option|price"
INTEREST = re.compile(XHR_PATTERN)

# 페이지 안에서 편집기 실행 코드의 흔적을 훑는다
PROBE_JS = """() => {
  const rx = /edicusbase|makers\\.redprinting|editor_landing|ps_code|useKoiEditor|koiAccessToken/i;
  const scripts = [];
  for (const s of document.querySelectorAll('script')) {
    const t = s.textContent || '';
    if (t && rx.test(t)) scripts.push({src: s.src || '(inline)', snippet: t.slice(0, 8000)});
    else if (s.src && rx.test(s.src)) scripts.push({src: s.src, snippet: ''});
  }
  const g = (n) => { try { return window[n]; } catch(e) { return undefined; } };
  const globals = {};
  for (const n of ['useKoiEditor','usePDF','pdt_cod','pdt_cd','productInfo',
                   'digitalProductInfo','koiAccessToken','editorConfig','Editor'])
    { const v = g(n); if (v !== undefined) globals[n] = (typeof v === 'object' ? '[object]' : v); }
  const buttons = [...new Set([...document.querySelectorAll('a,button,input[type=button]')]
    .map(e => (e.innerText || e.value || '').trim())
    .filter(t => t && /편집|디자인|에디터|만들기|업로드|주문/.test(t)))].slice(0, 40);
  // 편집 진입 링크의 href / onclick
  const launchers = [...document.querySelectorAll('a,button')]
    .filter(e => /편집|디자인|에디터/.test(e.innerText || ''))
    .map(e => ({text: (e.innerText||'').trim(), href: e.getAttribute('href') || '',
                onclick: (e.getAttribute('onclick') || '').slice(0, 500),
                cls: e.className}));
  return {scripts, globals, buttons, launchers,
          title: document.title, iframes: [...document.querySelectorAll('iframe')].map(f => f.src)};
}"""


def main():
    from scrapling.fetchers import StealthySession

    with StealthySession(headless=True, network_idle=True, humanize=False,
                         capture_xhr=XHR_PATTERN, timeout=90000, disable_resources=False) as session:
        for code, url in TARGETS:
            print(f"\n=== {code} ===")
            bag = {"code": code, "url": url, "xhr": [], "errors": []}

            def action(page, code=code, bag=bag):
                page.wait_for_timeout(4000)
                try:
                    bag["probe"] = page.evaluate(PROBE_JS)
                except Exception as e:
                    bag["errors"].append(f"probe: {e!r}")
                try:
                    page.screenshot(path=str(OUT / f"{code}_page.png"))
                except Exception as e:
                    bag["errors"].append(f"screenshot: {e!r}")
                return page

            try:
                resp = session.fetch(url, page_action=action, network_idle=True)
            except Exception as e:
                bag["errors"].append(f"fetch: {e!r}")
                (OUT / f"{code}.json").write_text(json.dumps(bag, ensure_ascii=False, indent=2), "utf-8")
                print("  ! fetch 실패:", e)
                continue

            for x in (getattr(resp, "captured_xhr", None) or []):
                if not INTEREST.search(x.url):
                    continue
                rec = {"url": x.url, "status": x.status}
                try:
                    rec["json"] = x.json()
                except Exception:
                    rec["text"] = (x.body or b"")[:20000].decode("utf-8", "replace") \
                        if isinstance(x.body, (bytes, bytearray)) else str(x.body)[:20000]
                bag["xhr"].append(rec)

            bag["status"] = resp.status
            (OUT / f"{code}.html").write_text(resp.html_content, encoding="utf-8")
            (OUT / f"{code}.json").write_text(
                json.dumps(bag, ensure_ascii=False, indent=2), encoding="utf-8")

            p = bag.get("probe", {})
            print(f"  HTTP {resp.status} · XHR {len(bag['xhr'])}건 · "
                  f"편집기 스크립트 {len(p.get('scripts', []))}건 · "
                  f"편집버튼 {len(p.get('launchers', []))}개")
            for e in bag["errors"]:
                print("   !", e)


if __name__ == "__main__":
    main()
