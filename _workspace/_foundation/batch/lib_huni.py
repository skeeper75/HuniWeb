#!/usr/bin/env python3
"""
lib_huni — 후니 가격 배치 채점 공용 클라이언트.

재사용 토대(빌드스크립트 isomorphic_batch 의 의존성):
  - HuniSim: webadmin 가격 시뮬레이터 인증 + sim-meta / simulate / simulate-set 호출
  - db():    라이브 Railway DB 읽기전용 psql 조회(서브프로세스)

[HARD] 라이브 읽기전용. 이 라이브러리는 어떤 쓰기도 하지 않는다(DB COMMIT/POST 주문 없음).
시뮬레이터 POST 는 가격 계산(읽기) 전용 엔드포인트다.

자격증명: .env.local (RAILWAY_DB_* · HUNI_ADMIN_*) — 환경변수로만 읽고 절대 출력하지 않는다.
"""
import os
import re
import json
import subprocess
import urllib.request
import urllib.parse
import http.cookiejar


# ─────────────────────────────────────────────────────────────────────
# 환경 로딩 (.env.local) — 비밀값은 환경변수에만, 출력 금지
# ─────────────────────────────────────────────────────────────────────
def load_env(path=None):
    """.env.local 을 os.environ 에 주입(이미 있으면 보존)."""
    if path is None:
        # _foundation/batch/ → repo root
        here = os.path.dirname(os.path.abspath(__file__))
        path = os.path.abspath(os.path.join(here, "..", "..", "..", ".env.local"))
    if not os.path.exists(path):
        return
    with open(path, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith("#") or "=" not in line:
                continue
            k, v = line.split("=", 1)
            k = k.strip()
            v = v.strip().strip('"').strip("'")
            os.environ.setdefault(k, v)


# ─────────────────────────────────────────────────────────────────────
# 라이브 DB 읽기전용 조회 (psql 서브프로세스)
# ─────────────────────────────────────────────────────────────────────
def db(sql, rows=True):
    """라이브 DB SELECT. rows=True 면 [[col,...],...] 리스트(탭 구분), False 면 raw 텍스트."""
    env = dict(os.environ)
    env["PGPASSWORD"] = os.environ["RAILWAY_DB_PASSWORD"]
    env["PGHOST"] = os.environ["RAILWAY_DB_HOST"]
    env["PGPORT"] = os.environ["RAILWAY_DB_PORT"]
    env["PGUSER"] = os.environ["RAILWAY_DB_USER"]
    env["PGDATABASE"] = os.environ["RAILWAY_DB_NAME"]
    args = ["psql", "-At", "-F", "\t", "-c", sql]
    out = subprocess.run(args, env=env, capture_output=True, text=True, timeout=120)
    if out.returncode != 0:
        raise RuntimeError(f"psql 실패: {out.stderr.strip()}")
    if not rows:
        return out.stdout
    return [ln.split("\t") for ln in out.stdout.splitlines() if ln != ""]


# ─────────────────────────────────────────────────────────────────────
# 시뮬레이터 클라이언트 (인증 세션 + sim-meta/simulate/simulate-set)
# ─────────────────────────────────────────────────────────────────────
class HuniSim:
    def __init__(self):
        self.base = os.environ["HUNI_ADMIN_URL"].split("/admin/")[0]
        self.login_url = self.base + "/admin/login/"
        self.uid = os.environ["HUNI_ADMIN_ID"]
        self.pw = os.environ["HUNI_ADMIN_PW"]
        self.cj = http.cookiejar.CookieJar()
        self.op = urllib.request.build_opener(
            urllib.request.HTTPCookieProcessor(self.cj))
        self.op.addheaders = [("User-Agent", "huni-batch/1.0")]
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

    # ── 상품 가격 메타(케이스 enumerate 소스) ───────────────────────
    def sim_meta(self, prd_cd):
        return self.get(f"/admin/price-viewer/{prd_cd}/sim-meta/")

    # ── 단품 가격 계산 ──────────────────────────────────────────────
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

    # ── 세트 가격 계산 ──────────────────────────────────────────────
    def simulate_set(self, prd_cd, copies, members, set_selections=None,
                     set_procs=None, grade_cd=None, mode="lenient"):
        body = {"copies": copies, "members": members, "mode": mode,
                "set_selections": set_selections or {}}
        if set_procs:
            body["set_procs"] = set_procs
        if grade_cd:
            body["grade_cd"] = grade_cd
        return self.post(f"/admin/price-viewer/{prd_cd}/simulate-set/", body)


# ─────────────────────────────────────────────────────────────────────
# 응답 파서 (가격 필드 경로 — 응답 구조 검증 완료 2026-06-29)
# ─────────────────────────────────────────────────────────────────────
def price_of(res):
    """엔진 최종가(원). 단품=final_price/grand_total, 세트=동일 키."""
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


if __name__ == "__main__":
    # 셀프테스트: 프리미엄엽서 결정론 재현 (PRF_DGP_A · 디인쇄+용지 · pansu=18 · PRICE≠0)
    load_env()
    sim = HuniSim()
    meta = sim.sim_meta("PRD_000016")
    assert meta["frm"]["frm_cd"] == "PRF_DGP_A", meta["frm"]
    r = sim.simulate("PRD_000016",
                     {"siz_cd": "SIZ_000001", "print_opt_cd": "POPT_000001", "mat_cd": "MAT_000074"},
                     100, procs=[{"proc_cd": "PROC_000004"}])
    p = price_of(r)
    comps = components_of(r)
    print(f"frm={meta['frm']['frm_cd']}  final_price={p}")
    for cc, cn, sub, pansu, ok in comps:
        print(f"  {cn:16s} subtotal={sub} pansu={pansu} matched={ok}")
    assert p and p > 0, "PRICE=0 결함"
    print("SELFTEST OK")
