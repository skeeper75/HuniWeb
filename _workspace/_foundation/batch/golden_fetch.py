#!/usr/bin/env python3
"""
golden_fetch — 예전사이트(huniprinting.com goods.asp) 정답가 골든 추출기.

목적: 배치 PR(가격재현) 채점의 오라클 공급자. 한 상품의 대표 구성(사이즈·용지·
인쇄·수량)으로 예전사이트 폼을 **네이티브 이벤트**로 채우고 setActionCheck()가
서버 AJAX 재계산을 돌게 한 뒤 **공급가(부가세 전)** 와 분해값(price_01 등)을 읽어
반환한다. 우리 엔진 simulate 금액과 이 골든을 대조하면 "가격이 맞나"가 채점된다.

★위상[HARD]: 예전사이트=구 시스템(리뉴얼 대상). 권위 엑셀이 절대 기준.
  골든 ↔ 엔진 차이는 **조사 신호**일 뿐 자동 교정 트리거가 아니다.

★폼 구동 사실(실측 2026-06-29 — 재사용):
  - 가격은 onchange→setActionCheck() 의 서버 AJAX 로 계산. raw JS .value= 는
    재계산이 안 걸린다(0원/고정 함정) → 반드시 gstack browse 네이티브 select/fill.
  - 사이즈(tmp_p01)를 고르면 사이즈군별 용지 sub-select(tmp_p07_H/X/M)와
    사이즈별 수량 select(qty_<내부코드>)가 **활성화**된다. 활성 select 는 화면에
    보이는(offsetParent!==null) 것만 — 그래서 셀렉터를 동적으로 찾는다.
  - 공급가 읽기: input[name=price_01] 은 **id 가 없다**(getElementById 실패 함정).
    document.getElementsByName('price_01')[0].value 또는 본문 "공급가 : N원" 파싱.

★브라우저 독점: gstack browse 는 단일 세션. 이 모듈(=PR 채점 작업)이 전담.
  다른 작업과 동시 사용 금지.

[HARD] 라이브 읽기탐색만 — 옵션 선택까지(장바구니/주문/결제/폼 submit 금지).

사용(단독):
  python3 golden_fetch.py <pcode> [--size "100mm x 150mm"] [--paper "백색모조지 220g"]
                          [--print 단면] [--qty 100]
  python3 golden_fetch.py --selftest      # pcode 33 엽서 골든 재현 확인
"""
import os
import re
import sys
import json
import time
import subprocess

HERE = os.path.dirname(os.path.abspath(__file__))
BROWSE = "/Users/innojini/.claude/skills/gstack/browse/dist/browse"
GOODS_BASE = "https://www.huniprinting.com/product/goods.asp"

# setActionCheck AJAX 재계산 대기(초). 서버 왕복이라 넉넉히.
RECALC_WAIT = 2.0
ACTIVATE_WAIT = 1.0


# ─────────────────────────────────────────────────────────────────────
# gstack browse 래퍼 (단일 세션·네이티브 이벤트)
# ─────────────────────────────────────────────────────────────────────
def _b(*args, timeout=60):
    """browse 서브커맨드 실행 → stdout(strip). 실패 시 stderr 포함 예외."""
    out = subprocess.run([BROWSE, *args], capture_output=True, text=True,
                         timeout=timeout)
    if out.returncode != 0:
        raise RuntimeError(f"browse {args[0]} 실패: {out.stderr.strip()[:200]}")
    return out.stdout.strip()


def _js(expr, timeout=60):
    """페이지 JS 평가(읽기 전용 권장)."""
    return _b("js", expr, timeout=timeout)


def goto(pcode):
    """상품 폼으로 네비게이트(렌더 대기)."""
    _b("goto", f"{GOODS_BASE}?pcode={pcode}", timeout=90)
    time.sleep(ACTIVATE_WAIT)


def breadcrumb():
    return _js("document.body.innerText.split('\\n')"
               ".map(s=>s.trim()).filter(Boolean)[0] || ''")


def list_selects(visible_only=True):
    """현재 select 목록 [{name, label, n, options:[...], visible}]."""
    flt = "filter(s=>s.offsetParent!==null)." if visible_only else ""
    raw = _js(
        "JSON.stringify(Array.from(document.querySelectorAll('select'))." + flt +
        "map(s=>({name:s.name,"
        "label:(s.options[s.selectedIndex]||{}).textContent||'',"
        "n:s.options.length,"
        "visible:s.offsetParent!==null,"
        "options:Array.from(s.options).map(o=>o.textContent.trim())})))")
    try:
        return json.loads(raw)
    except json.JSONDecodeError:
        return []


def _opt_match(options, want):
    """want 와 가장 잘 맞는 옵션 텍스트 반환(부분일치·공백무시). 없으면 None."""
    if want is None:
        return None
    wn = re.sub(r"\s+", "", str(want)).lower()
    # 1) 정확(공백무시)
    for o in options:
        if re.sub(r"\s+", "", o).lower() == wn:
            return o
    # 2) 포함
    for o in options:
        if wn and wn in re.sub(r"\s+", "", o).lower():
            return o
    return None


def native_select(name, want):
    """name select 에서 want 에 맞는 옵션을 네이티브로 선택. 선택값 반환."""
    sels = list_selects(visible_only=False)
    target = next((s for s in sels if s["name"] == name), None)
    if not target:
        return None
    opt = _opt_match(target["options"], want)
    if opt is None:
        # 첫 실값(--- placeholder 제외)으로 폴백
        opt = next((o for o in target["options"]
                    if o and "---" not in o and "선택" not in o), None)
    if opt is None:
        return None
    _b("select", f"select[name={name}]", opt)
    time.sleep(ACTIVATE_WAIT)
    return opt


def active_qty_select():
    """현재 활성(보이는) 수량 select 이름. qty_<숫자>·qty 형태."""
    for s in list_selects(visible_only=True):
        nm = s["name"]
        if re.match(r"^qty(_\d+)?$", nm) and s["n"] > 1:
            return nm
    return None


def active_paper_select():
    """현재 활성(보이는) 용지 select 이름. tmp_p07_* 중 보이고 옵션>1."""
    for s in list_selects(visible_only=True):
        nm = s["name"]
        if nm.startswith("tmp_p07") and s["n"] > 1:
            return nm
    return None


def trigger_recalc():
    """setActionCheck() 서버 AJAX 재계산 발동 + 대기."""
    _js("typeof setActionCheck==='function' && setActionCheck()")
    time.sleep(RECALC_WAIT)


def read_supply_price():
    """공급가(부가세 전·원) + 분해. {supply, price_01, raw}.
       supply=None 이면 읽기 실패(미실측)."""
    # 1차: input[name=price_01].value (id 없음 — getElementsByName 필수)
    p01 = _js("var n=document.getElementsByName('price_01');"
              "n.length?n[0].value:''")
    # 2차: 본문 '공급가 : N원' 파싱(권위 표시값)
    raw = _js("var t=document.body.innerText;var i=t.indexOf('공급가');"
              "i>-1?t.slice(i,i+40).replace(/\\s+/g,' '):''")
    m = re.search(r"공급가\s*:?\s*([\d,]+)\s*원", raw)
    supply_text = int(m.group(1).replace(",", "")) if m else None
    try:
        supply_p01 = int(re.sub(r"[^\d]", "", p01)) if p01 else None
    except ValueError:
        supply_p01 = None
    # 공급가 표시값 우선(없으면 price_01). 0원은 미계산 신호(None 취급).
    supply = supply_text if supply_text else supply_p01
    if supply == 0:
        supply = None
    return {"supply": supply, "price_01": supply_p01, "raw": raw}


# ─────────────────────────────────────────────────────────────────────
# 골든 추출 — 한 상품(pcode)의 대표 구성으로 정답가 읽기
# ─────────────────────────────────────────────────────────────────────
def fetch_golden(pcode, size=None, paper=None, print_side="단면", qty=100,
                 extra_selects=None):
    """예전사이트 정답가 골든 추출.
    인자:
      size        사이즈 라벨(예 "100mm x 150mm"). None=폼 첫 실사이즈.
      paper       용지 라벨(예 "백색모조지 220g"). None=활성 용지 첫 실옵션.
      print_side  인쇄(단면/양면). 폼에 tmp_p09 있으면 적용.
      qty         수량(정수). 활성 qty select 에서 "N 장"/"N장" 매칭.
      extra_selects {select_name: want}  추가 옵션(코팅·접지 등) 선택.
    반환 dict:
      ok, pcode, breadcrumb, picked{size,paper,print,qty},
      supply(공급가·부가세전·원), price_01, note
    """
    res = {"ok": False, "pcode": str(pcode), "breadcrumb": "",
           "picked": {}, "supply": None, "price_01": None, "note": ""}
    try:
        goto(pcode)
        res["breadcrumb"] = breadcrumb()

        # 1) 사이즈 — tmp_p01 활성화 트리거(용지·수량 sub-select 켜짐)
        size_sel = next((s for s in list_selects(visible_only=False)
                         if s["name"] == "tmp_p01"), None)
        if size_sel:
            picked = native_select("tmp_p01", size)
            res["picked"]["size"] = picked
            time.sleep(ACTIVATE_WAIT)  # sub-select 활성 대기

        # 2) 용지 — 활성 tmp_p07_* 동적 탐색
        pname = active_paper_select()
        if pname:
            res["picked"]["paper"] = native_select(pname, paper)

        # 3) 인쇄(단/양면)
        if any(s["name"] == "tmp_p09" for s in list_selects(visible_only=False)):
            res["picked"]["print"] = native_select("tmp_p09", print_side)

        # 4) 추가 옵션(코팅·접지 등 — 호출자 지정)
        for nm, want in (extra_selects or {}).items():
            native_select(nm, want)

        # 5) 수량 — 활성 qty select 동적 탐색 + "N 장" 매칭
        qname = active_qty_select()
        if qname:
            qpick = native_select(qname, f"{qty} 장")
            if not qpick:
                qpick = native_select(qname, f"{qty}장")
            res["picked"]["qty"] = qpick

        # 6) 재계산 + 공급가 읽기
        trigger_recalc()
        pr = read_supply_price()
        res["supply"] = pr["supply"]
        res["price_01"] = pr["price_01"]
        if pr["supply"] is None:
            res["note"] = ("공급가 0/미산출 — 구성 미완(필수옵션 누락) 또는 "
                           "off-grid(견적문의). 미실측 신호.")
        else:
            res["ok"] = True
    except Exception as e:
        res["note"] = f"폼 구동 실패: {str(e)[:160]}"
    return res


# ─────────────────────────────────────────────────────────────────────
# CLI
# ─────────────────────────────────────────────────────────────────────
def _selftest():
    """pcode 33(엽서) 골든 재현: 100x150·백색모조220·단면·100장 → 공급가>0."""
    print("=== golden_fetch SELFTEST (pcode 33 엽서) ===")
    g = fetch_golden(33, size="100mm x 150mm", paper="백색모조지 220g",
                     print_side="단면", qty=100)
    print(json.dumps(g, ensure_ascii=False, indent=2))
    assert g["ok"] and g["supply"] and g["supply"] > 0, "골든 공급가 0/실패"
    print(f"SELFTEST OK — 공급가={g['supply']:,}원")


def main():
    if "--selftest" in sys.argv:
        _selftest()
        return
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    pcode = sys.argv[1]
    kw = {"size": None, "paper": None, "print_side": "단면", "qty": 100}
    a = sys.argv[2:]
    for i, tok in enumerate(a):
        if tok == "--size" and i + 1 < len(a):
            kw["size"] = a[i + 1]
        elif tok == "--paper" and i + 1 < len(a):
            kw["paper"] = a[i + 1]
        elif tok == "--print" and i + 1 < len(a):
            kw["print_side"] = a[i + 1]
        elif tok == "--qty" and i + 1 < len(a):
            kw["qty"] = int(a[i + 1])
    g = fetch_golden(pcode, **kw)
    print(json.dumps(g, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
