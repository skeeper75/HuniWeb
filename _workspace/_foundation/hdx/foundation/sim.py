"""webadmin 가격 시뮬레이터 클라이언트 — lib_huni.HuniSim·price_of·components_of verbatim 승계.

[HARD] 시뮬레이터 POST 는 가격 계산(읽기) 전용 엔드포인트다(주문·저장 아님).
용도: contribution_sim 계열 진단이 엔진 실호출 결과를 대조할 때(스냅샷 엔진 이식과 교차).
자격증명: HUNI_ADMIN_* (env.load_env 로 주입). 값 출력 금지.
"""
import os
import re
import json
import urllib.request
import urllib.parse
import http.cookiejar


class HuniSim:
    def __init__(self):
        self.base = os.environ["HUNI_ADMIN_URL"].split("/admin/")[0]
        self.login_url = self.base + "/admin/login/"
        self.uid = os.environ["HUNI_ADMIN_ID"]
        self.pw = os.environ["HUNI_ADMIN_PW"]
        self.cj = http.cookiejar.CookieJar()
        self.op = urllib.request.build_opener(
            urllib.request.HTTPCookieProcessor(self.cj))
        self.op.addheaders = [("User-Agent", "hdx-batch/1.0")]
        self.csrf = None
        self._login()

    def _login(self):
        html = self.op.open(self.login_url, timeout=30).read().decode()
        m = re.search(r'name="csrfmiddlewaretoken" value="([^"]+)"', html)
        if not m:
            raise RuntimeError("login csrf 토큰 없음")
        tok = m.group(1)
        data = urllib.parse.urlencode({
            "csrfmiddlewaretoken": tok, "username": self.uid,
            "password": self.pw, "next": "/admin/"}).encode()
        self.op.open(urllib.request.Request(
            self.login_url, data=data, headers={"Referer": self.login_url}), timeout=30)
        cookies = {c.name for c in self.cj}
        if "sessionid" not in cookies:
            raise RuntimeError("로그인 실패(sessionid 없음) — HUNI_ADMIN_PW 확인")
        self.csrf = next((c.value for c in self.cj if c.name == "csrftoken"), tok)

    def get(self, path):
        req = urllib.request.Request(
            self.base + path, headers={"Referer": self.base + "/admin/price-viewer/"})
        return json.loads(self.op.open(req, timeout=60).read().decode())

    def post(self, path, body):
        req = urllib.request.Request(
            self.base + path, data=json.dumps(body).encode(),
            headers={"Content-Type": "application/json", "X-CSRFToken": self.csrf,
                     "Referer": self.base + "/admin/price-viewer/"})
        return json.loads(self.op.open(req, timeout=60).read().decode())

    def sim_meta(self, prd_cd):
        return self.get(f"/admin/price-viewer/{prd_cd}/sim-meta/")

    def simulate(self, prd_cd, selections, qty, procs=None, addons=None,
                 grade_cd=None, tmpl_cd=None, mode="lenient"):
        body = {"selections": selections or {}, "qty": qty, "mode": mode}
        if procs:
            body["procs"] = procs
        if addons:
            body["addons"] = addons
        if grade_cd:
            body["grade_cd"] = grade_cd
        if tmpl_cd:
            body["tmpl_cd"] = tmpl_cd
        return self.post(f"/admin/price-viewer/{prd_cd}/simulate/", body)


def price_of(res):
    """엔진 최종가(원). 단품=final_price/grand_total."""
    for k in ("final_price", "grand_total"):
        v = res.get(k)
        if v is not None:
            try:
                return int(round(float(v)))
            except (TypeError, ValueError):
                pass
    return None


def components_of(res):
    """구성요소 분해 [(comp_cd, comp_nm, subtotal, pansu, matched_bool)]."""
    out = []
    base = res.get("base") or {}
    for c in (base.get("components") or []):
        mr = c.get("matched_row") or {}
        out.append((
            c.get("comp_cd"), c.get("comp_nm"),
            c.get("subtotal"), c.get("pansu"),
            bool(mr) and c.get("error") is None,
        ))
    return out
