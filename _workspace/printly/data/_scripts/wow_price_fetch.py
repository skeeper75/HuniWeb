#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
와우프레스 jobcost API 배치 가격 페처.
- 인증: POST /api/login/issue (authUid/authPw는 .env.local에서만·stdout 금지)
- 가격: POST /api/v1/ord/cjson_jobcost (읽기전용·주문/결제 호출 없음)
- 값=API 관측(지어내기 0). 비밀값/토큰 절대 출력 금지.

용도:
  python wow_price_fetch.py validate   # 기존 7 레시피 known-good 재현 대조
  python wow_price_fetch.py batch       # 24군 대표 1개씩 가격 조회 → sourcing json
"""
import os
import sys
import json
import time
import ssl
import urllib.request
import urllib.error
import collections

ROOT = "/Users/innojini/Dev/HuniWeb"
ENV = os.path.join(ROOT, ".env.local")
CATALOG_DIR = os.path.join(ROOT, "docs/wowpress/catalog/products")
PRODUCTS = os.path.join(ROOT, "_workspace/huni-multibrand-ontology/04_wow-registration/wow-products.json")
RECIPE_DIR = os.path.join(ROOT, "_workspace/printly/data/recipes/wow")
OUT = os.path.join(ROOT, "_workspace/printly/data/sourcing/wow-group-prices-260705.json")

API_LOGIN = "https://api.wowpress.co.kr/api/login/issue"
API_JOBCOST = "https://api.wowpress.co.kr/api/v1/ord/cjson_jobcost"

_SSL = ssl.create_default_context()


def read_env():
    """비밀값을 dict로만 반환(로그/출력 금지)."""
    env = {}
    with open(ENV, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            k, v = line.split("=", 1)
            env[k.strip()] = v.strip().strip('"').strip("'")
    return env


def _post(url, body, headers):
    data = json.dumps(body).encode("utf-8")
    req = urllib.request.Request(url, data=data, method="POST")
    req.add_header("Content-Type", "application/json")
    for k, v in headers.items():
        req.add_header(k, v)
    try:
        with urllib.request.urlopen(req, context=_SSL, timeout=30) as resp:
            return resp.status, json.loads(resp.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        try:
            return e.code, json.loads(e.read().decode("utf-8"))
        except Exception:
            return e.code, {"_raw_error": str(e)}
    except Exception as e:
        return None, {"_exception": type(e).__name__}


def login(env):
    """토큰 획득. 토큰/비번은 반환만·출력 금지."""
    uid = env.get("WOWPRESS_AUTH_UID")
    pw = env.get("WOWPRESS_AUTH_PW")
    if not uid or not pw:
        raise RuntimeError("auth creds missing in .env.local")
    # authUid는 숫자일 수 있음 → int 시도, 실패시 문자열
    try:
        uid_v = int(uid)
    except ValueError:
        uid_v = uid
    status, resp = _post(API_LOGIN, {"authUid": uid_v, "authPw": pw}, {})
    if status != 200:
        raise RuntimeError(f"login failed status={status}")
    token = (resp.get("token")
             or resp.get("resultMap", {}).get("token")
             or resp.get("data", {}).get("token"))
    if not token:
        # 토큰 위치 탐색(값은 출력 안 함·키만)
        raise RuntimeError(f"token not found; resp keys={list(resp.keys())}")
    return token


def load_catalog(prodno):
    p = os.path.join(CATALOG_DIR, f"{prodno}.json")
    if not os.path.exists(p):
        return None
    return json.load(open(p, "r", encoding="utf-8"))


def build_payload(prodno, prod_info, ordqty="500", ordcnt="1",
                  override=None):
    """catalog raw.prod_info에서 대표(첫/기본) 옵션으로 payload 구성.
    override={sizeno,paperno,colorno} 지정 시 해당 값 사용(검증용).
    반환: (payload dict, spec dict) 또는 (None, reason)."""
    override = override or {}
    pi = prod_info

    # --- print job (prsjobinfo) ---
    prsinfo = pi.get("prsjobinfo") or []
    if not prsinfo:
        return None, "no_prsjobinfo"
    preset = prsinfo[0]
    jobpresetno = preset.get("jobpresetno")
    joblist = preset.get("prsjoblist") or []
    if not joblist:
        return None, "no_prsjoblist"
    job0 = joblist[0]
    jobno = job0.get("jobno")
    covercd = job0.get("covercd", 0)

    # --- size (sizeinfo) ---
    szinfo = pi.get("sizeinfo") or []
    if not szinfo:
        return None, "no_sizeinfo"
    sizelist = szinfo[0].get("sizelist") or []
    if not sizelist:
        return None, "no_sizelist"
    sz = sizelist[0]
    if override.get("sizeno"):
        sz = next((s for s in sizelist if s.get("sizeno") == override["sizeno"]), sz)
    sizeno = sz.get("sizeno")
    non_std = bool(sz.get("non_standard"))

    # --- paper (paperinfo) ---
    ppinfo = pi.get("paperinfo") or []
    if not ppinfo:
        return None, "no_paperinfo"
    paperlist = ppinfo[0].get("paperlist") or []
    if not paperlist:
        return None, "no_paperlist"
    pp = paperlist[0]
    if override.get("paperno"):
        pp = next((p for p in paperlist if p.get("paperno") == override["paperno"]), pp)
    paperno = pp.get("paperno")

    # --- color (colorinfo) ---
    clinfo = pi.get("colorinfo") or []
    if not clinfo:
        return None, "no_colorinfo"
    pagelist = clinfo[0].get("pagelist") or []
    if not pagelist:
        return None, "no_pagelist"
    colorlist = pagelist[0].get("colorlist") or []
    if not colorlist:
        return None, "no_colorlist"
    cl = colorlist[0]
    if override.get("colorno"):
        cl = next((c for c in colorlist if c.get("colorno") == override["colorno"]), cl)
    colorno = cl.get("colorno")

    prsjob = {
        "jobpresetno": jobpresetno,
        "jobno": jobno,
        "covercd": covercd,
        "sizeno": sizeno,
        "paperno": paperno,
        "colorno": colorno,
    }

    # --- 비규격 처리: width/height 필수 ---
    if non_std:
        w = sz.get("width") or sz.get("req_width")
        h = sz.get("height") or sz.get("req_height")
        # req_width/height가 dict(min/max)일 수 있음
        if isinstance(w, dict):
            w = w.get("min") or w.get("min_width")
        if isinstance(h, dict):
            h = h.get("min") or h.get("min_height")
        if not w or not h:
            return None, f"non_standard_no_dims(sizeno={sizeno})"
        prsjob["width"] = w
        prsjob["height"] = h

    payload = {
        "prodno": int(prodno),
        "ordqty": str(ordqty),
        "ordcnt": str(ordcnt),
        "prsjob": [prsjob],
        "awkjob": [],
    }
    spec = {
        "sizeno": sizeno, "sizename": sz.get("sizename"),
        "non_standard": non_std,
        "width": prsjob.get("width"), "height": prsjob.get("height"),
        "paperno": paperno, "papername": pp.get("papername"),
        "colorno": colorno, "colorname": cl.get("colorname"),
        "jobpresetno": jobpresetno, "jobno": jobno, "covercd": covercd,
    }
    return payload, spec


def valid_ordqty(pi, prefer=("500", "100", "10", "1")):
    """상품 ordqtylist에서 대표 수량 선택(500 우선, 없으면 100/10/1, 최후=첫값)."""
    oq = pi.get("ordqty") or []
    if not oq:
        return "500", None
    lst = oq[0].get("ordqtylist") or []
    if not lst:
        mn = oq[0].get("ordqtymin")
        return (str(mn) if mn else "500"), lst
    lst_str = [str(x) for x in lst]
    for p in prefer:
        if p in lst_str:
            return p, lst
    return str(lst[0]), lst


def mandatory_awkjobs(pi):
    """필수(type radio/select) 후가공 그룹의 첫 항목을 covercd별로 수집.
    req_jobsize 필요한 항목은 dims_needed 표시. 반환 list of awkjob entry(dict)."""
    out = []
    awkinfo = pi.get("awkjobinfo") or []
    for block in awkinfo:
        covercd = block.get("covercd", 0)
        for grp in block.get("jobgrouplist", []):
            gtype = grp.get("type")
            if gtype not in ("radio", "select"):
                continue  # checkbox=선택적
            jl = grp.get("awkjoblist") or []
            if not jl:
                continue
            j0 = jl[0]
            entry = {"covercd": covercd,
                     "jobgroupno": grp.get("jobgroupno"),
                     "jobno": j0.get("jobno")}
            rjs = j0.get("req_jobsize")
            if isinstance(rjs, dict):
                w = rjs.get("min_width") or rjs.get("max_width")
                h = rjs.get("min_height") or rjs.get("max_height")
                if w:
                    entry["width"] = w
                if h:
                    entry["height"] = h
            out.append(entry)
    return out


def fetch_price(token, payload):
    headers = {"authorization": f"Bearer {token}"}
    status, resp = _post(API_JOBCOST, payload, headers)
    jc = None
    if isinstance(resp, dict):
        jc = resp.get("resultMap", {}).get("cjson_jobcost")
    result = {"http_status": status}
    if jc:
        result["status"] = jc.get("status")
        result["errmsg"] = jc.get("errmsg")
        result["ordcost_sup"] = jc.get("ordcost_sup")
        result["ordcost_bill"] = jc.get("ordcost_bill")
    else:
        # 에러 메시지(비밀값 아님)만 보존
        if isinstance(resp, dict):
            result["status"] = resp.get("status") or resp.get("resultMsg") or resp.get("message")
            result["errmsg"] = resp.get("errmsg") or resp.get("resultMsg")
    return result


def _all_options(pi):
    """catalog에서 (sizes, papers, colors) 리스트 추출(대표 combo 스윕용)."""
    sizes = []
    for s in (pi.get("sizeinfo") or [{}])[0].get("sizelist", []) or []:
        sizes.append(s)
    papers = []
    for p in (pi.get("paperinfo") or [{}])[0].get("paperlist", []) or []:
        papers.append(p)
    colors = []
    clinfo = pi.get("colorinfo") or [{}]
    for pg in (clinfo[0].get("pagelist") or []):
        for c in (pg.get("colorlist") or []):
            colors.append(c)
    return sizes, papers, colors


def solve_price(token, prodno, pi, max_calls=40):
    """대표 가격을 유효 조합 탐색으로 해결.
    유효 qty + (필수 후가공 주입) + (size×paper×color 스윕)으로 200을 찾음.
    반환: (result dict, spec dict, ncalls). 실패 시 result에 마지막 errmsg."""
    ordqty, _ = valid_ordqty(pi)
    mand_awk = mandatory_awkjobs(pi)
    sizes, papers, colors = _all_options(pi)
    if not (sizes and papers and colors):
        return {"status": "SKIP_missing_axis"}, {"reason": "no size/paper/color"}, 0

    # 규격 사이즈 우선(비규격은 뒤로), 조합 폭 제한(각 축 앞쪽 대표만)
    sizes_sorted = sorted(sizes, key=lambda s: (1 if s.get("non_standard") else 0))
    S = sizes_sorted[:4]
    P = papers[:4]
    C = colors[:3]

    ncalls = 0
    last = None
    # awkjob 후보: [없음, 필수주입]
    awk_variants = [[]]
    if mand_awk:
        awk_variants = [mand_awk, []]  # 필수 먼저 시도

    for awk in awk_variants:
        for sz in S:
            for pp in P:
                for cl in C:
                    if ncalls >= max_calls:
                        break
                    override = {"sizeno": sz.get("sizeno"),
                                "paperno": pp.get("paperno"),
                                "colorno": cl.get("colorno")}
                    payload, spec = build_payload(prodno, pi, ordqty=ordqty,
                                                  override=override)
                    if payload is None:
                        last = {"status": f"BUILD:{spec}"}
                        continue
                    if awk:
                        payload["awkjob"] = awk
                    res = fetch_price(token, payload)
                    ncalls += 1
                    time.sleep(0.12)
                    if res.get("ordcost_sup") is not None and res.get("http_status") == 200:
                        spec["ordqty"] = ordqty
                        spec["awkjob_injected"] = awk if awk else None
                        return res, spec, ncalls
                    last = res
    return (last or {"status": "no_valid_combo"}), {"ordqty": ordqty, "tried": ncalls}, ncalls


# ---- 검증: 7 레시피 known-good 재현 ----
# 각 레시피 live_price_samples에서 재현 대상 1개(override spec + expected).
def validate(env, token):
    print("=== VALIDATE: 7 recipes known-good 재현 ===")
    ok = 0
    total = 0
    for fn in sorted(os.listdir(RECIPE_DIR)):
        if not fn.endswith(".json"):
            continue
        recipe = json.load(open(os.path.join(RECIPE_DIR, fn), "r", encoding="utf-8"))
        prod = recipe.get("product", {})
        prodno = prod.get("prodno")
        gc = recipe.get("recipe", {}).get("가격구성요소", {})
        lps = gc.get("live_price_samples", {})
        samples = lps.get("samples", [])
        if not prodno or not samples:
            print(f"  [skip] {fn}: no prodno/samples")
            continue
        cat = load_catalog(prodno)
        if not cat:
            print(f"  [skip] {fn}: no catalog {prodno}")
            continue
        pi = cat["raw"]["prod_info"]
        # material/size/color refs from recipe (첫 material/size + 각 sample color)
        mats = recipe["recipe"]["재료"]
        paper0 = None
        for m in mats.get("material", []):
            r = m.get("ref", "")
            if r.startswith("paper:"):
                paper0 = int(r.split(":")[1]); break
        size0 = None
        for s in mats.get("size", []):
            r = s.get("ref", "")
            if r.startswith("size:") and not s.get("nonstd"):
                size0 = int(r.split(":")[1]); break
        # color name → colorno
        colormap = {}
        for c in mats.get("color", []):
            r = c.get("ref", "")
            if r.startswith("color:"):
                tail = r.split(":")[1]
                if tail.isdigit():
                    colormap[c.get("label")] = int(tail)
        # 재현: 각 sample
        for smp in samples:
            total += 1
            colorno = colormap.get(smp.get("color"))
            override = {}
            if size0:
                override["sizeno"] = size0
            if paper0:
                override["paperno"] = paper0
            if colorno:
                override["colorno"] = colorno
            payload, spec = build_payload(prodno, pi,
                                          ordqty=str(smp.get("qty", 500)),
                                          override=override)
            if payload is None:
                print(f"  [FAIL] {prod.get('name')} {smp.get('color')} q{smp.get('qty')}: build={spec}")
                continue
            res = fetch_price(token, payload)
            exp = smp.get("ordcost_sup")
            got = res.get("ordcost_sup")
            match = (exp == got)
            if match:
                ok += 1
            flag = "OK " if match else "MISMATCH"
            nm = str(prod.get('name'))
            cl = str(smp.get('color'))
            print(f"  [{flag}] {nm:10s} {cl:12s} q{smp.get('qty')}: exp_sup={exp} got_sup={got} bill={res.get('ordcost_bill')} status={res.get('status')} colorno={override.get('colorno')}")
            time.sleep(0.15)
    print(f"=== VALIDATE result: {ok}/{total} samples reproduced ===")
    return ok, total


# ---- 배치: 24군 대표 1개 ----
def pick_reps(products):
    """카테고리별 대표 1개 선정: comp에 size/paper/color/prsjob 모두 있고 catalog 존재하는 것 우선."""
    by_cat = collections.OrderedDict()
    for pno, v in products.items():
        c = v.get("category")
        cat = c[0] if isinstance(c, list) and c else str(c)
        by_cat.setdefault(cat, []).append((pno, v))
    reps = {}
    for cat, items in by_cat.items():
        # 완비 옵션 + catalog 존재 우선. 랭크된 후보 리스트 반환(폴백용).
        scored = []
        for pno, v in items:
            comp = v.get("comp", {})
            has = all(comp.get(k) for k in ("size", "paper", "color", "prsjob"))
            has_cat = os.path.exists(os.path.join(CATALOG_DIR, f"{pno}.json"))
            score = (2 if has else 0) + (1 if has_cat else 0)
            scored.append((score, pno, v))
        scored.sort(key=lambda x: (-x[0], int(x[1]) if str(x[1]).isdigit() else 10**9))
        reps[cat] = scored  # 전체 랭크 리스트
    return reps


def batch(env, token):
    print("=== BATCH: 24군 대표 가격 조회 ===")
    products = json.load(open(PRODUCTS, "r", encoding="utf-8"))
    reps = pick_reps(products)
    results = []
    ok = 0
    fail = 0
    MAX_ALT = 4  # 카테고리당 최대 후보 시도 수(대표 실패 시 다음 후보로)
    for cat in sorted(reps.keys()):
        candidates = reps[cat]
        # 완비 옵션(score>=3) 후보만 실 조회 대상; 없으면 첫 후보 1개만(대개 SKIP)
        printable = [c for c in candidates if c[0] >= 3][:MAX_ALT]
        trylist = printable if printable else candidates[:1]
        entry = None
        last_res = None
        for score, pno, v in trylist:
            cat_json = load_catalog(pno)
            e = {"category": cat, "prodno": pno, "prodname": v.get("name"), "ordcnt": "1"}
            if not cat_json:
                e["status"] = "SKIP_no_catalog"
                entry = e; last_res = {"status": "SKIP_no_catalog"}
                continue
            pi = cat_json["raw"]["prod_info"]
            res, spec, ncalls = solve_price(token, pno, pi)
            e["spec"] = spec
            e["ordqty"] = spec.get("ordqty")
            e["http_status"] = res.get("http_status")
            e["api_status"] = res.get("status")
            e["errmsg"] = res.get("errmsg")
            e["ordcost_sup"] = res.get("ordcost_sup")
            e["ordcost_bill"] = res.get("ordcost_bill")
            e["solve_calls"] = ncalls
            entry = e; last_res = res
            if res.get("ordcost_sup") is not None and res.get("http_status") == 200:
                break  # 성공 시 이 후보 채택
        res = last_res or {}
        succeeded = res.get("ordcost_sup") is not None and res.get("http_status") == 200
        if succeeded:
            ok += 1; tag = "OK "
        else:
            fail += 1; tag = "FAIL"
        results.append(entry)
        print(f"  [{tag}] {cat:16s} {entry.get('prodno')} {str(entry.get('prodname'))[:16]:16s} sup={entry.get('ordcost_sup')} bill={entry.get('ordcost_bill')} st={entry.get('api_status') or entry.get('status')} msg={str(entry.get('errmsg'))[:22]}")
    out = {
        "_note": "와우프레스 jobcost API 24군 대표 가격(읽기전용·값=API 관측·지어내기 0). 대표=카테고리별 완비옵션 상품 1개, 유효 조합 자동탐색(유효 ordqty·필수 후가공 주입·size×paper×color 스윕). 각 값=engine 관측 ordcost_sup/bill.",
        "generated": "2026-07-05",
        "source_api": "POST /api/v1/ord/cjson_jobcost",
        "basis": {
            "ordcnt": 1,
            "spec": "카테고리 대표 상품, 첫/기본 유효옵션(size·paper·color), 필수 후가공만 주입, 유효 ordqty(500 우선·상품 ordqtylist 내)",
            "vat": "ordcost_sup=부가세 전 · ordcost_bill=부가세 포함",
        },
        "finding_api_behavior": "★jobcost API는 colorno(단면/양면)·ordqty 변경에 가격 불변(합판옵셋·디지털 공통 실측). paper/size/ordcnt만 가격 변동. 따라서 여기 값=상품 '기본 구성(첫 도수·기본 수량티어)' 가격. devshop 콘솔은 별색×수량 배수를 추가 적용해 값이 다를 수 있음(레시피 live_price_samples 대비). 이 파일 값은 jobcost API 관측 그대로(지어내기 0).",
        "ok": ok, "fail": fail, "total": len(results),
        "groups": results,
    }
    json.dump(out, open(OUT, "w", encoding="utf-8"), ensure_ascii=False, indent=2)
    print(f"=== BATCH result: ok={ok} fail={fail} total={len(results)} → {OUT} ===")
    return ok, fail


def main():
    mode = sys.argv[1] if len(sys.argv) > 1 else "batch"
    env = read_env()
    token = login(env)
    print("[auth] token acquired (not printed)")
    if mode == "validate":
        validate(env, token)
    elif mode == "batch":
        batch(env, token)
    elif mode == "both":
        validate(env, token)
        batch(env, token)
    else:
        print(f"unknown mode: {mode}")


if __name__ == "__main__":
    main()
