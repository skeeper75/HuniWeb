"""WidgetWiringDx — 위젯 레이어 배선 진단 어댑터 (SPEC-WIDGET-WIRING-001 M2).

컨설트가 '미커버'라 본 배선 엣지 4종(옵션 계층·ref_dim_cd 해소·단가행 도달성·제약 dangling)은
raw/webadmin/tools/ 의 결정론 센서 5종이 이미 판정한다(spec §1.1). 이 Diagnoser 는 판정 로직을
새로 mint 하지 않고 **호출/이식만** 한다:

  서브 어댑터       원본 센서                              방식                  엣지
  _opt_ref()       verify_option_ref_integrity --json    subprocess JSONL     W2·W4(+E4 PRICE_MISSING)
  _coverage()      verify_price_coverage --json           subprocess JSONL     E3·E4
  _zero()          verify_zero_quote --json               subprocess JSONL     E4(치명)
  _constraints()   audit_constraints                      판정부 verbatim 이식  C1
  _optcode()       verify_optcode_integrity [1]-[4]       판정부 verbatim 이식  W1·W2·W3·C1·E4

Defect.dimension = §3.2 엣지 ID(W1~W5·C1·E1~E4 중 이 dx 담당분). severity·돈영향은
원본 센서의 심각도 정책(verify_option_ref_integrity.SEV·FAIL/WARN 분류 등)을 승계.

[HARD] 라이브 읽기전용·결정론·토큰0. raw/webadmin/** 수정 금지(호출만).
실행 전제: raw/webadmin/.venv + DATABASE_URL(.env). 부재 시 묵음 스킵 금지 — 명시 FAIL Defect.
"""
from __future__ import annotations
import json
import pathlib
import re
import subprocess

from .base import Diagnoser
from ..foundation import Defect, db

# ── 경로 상수 ──────────────────────────────────────────────────────────────
_WEBADMIN = pathlib.Path(__file__).resolve().parents[4] / "raw" / "webadmin"
_TOOLS = _WEBADMIN / "tools"
# 센서 사용법 주석대로 webadmin 디렉터리 기준 ../.venv(= raw/.venv) 가 django 를 갖고 있다.
# raw/webadmin/.venv 는 django 부재(260821 실측) — 순서를 raw/.venv 우선으로.
_PY = _WEBADMIN.parent / ".venv" / "bin" / "python"
if not _PY.exists():
    _PY = _WEBADMIN / ".venv" / "bin" / "python"

# ── 원본 센서 심각도 정책 승계 (verify_option_ref_integrity.SEV:70 / zero SEV:76) ──
# 코드 → (엣지, severity, money_impact)
_OPTREF_MAP = {
    "ANCHOR_DELETED": ("W4", "critical", "undercharge"),
    "ANCHOR_MISSING": ("W4", "high", "undercharge"),
    "MASTER_DELETED": ("W4", "high", "unknown"),
    "MASTER_MISSING": ("W4", "high", "unknown"),
    "PRICE_MISSING": ("E4", "high", "undercharge"),
    "PARENT_DEAD": ("W2", "low", "none"),          # WARN(비게이팅) 승계
}
_COVERAGE_MAP = {"MISSING_DIM": ("E3", "high", "undercharge"),
                 "UNCOVERED": ("E4", "medium", "undercharge")}
_ZERO_MAP = {"ZERO_FINAL": ("E4", "critical", "undercharge"),
             "NO_SOURCE": ("E4", "critical", "undercharge"),
             "UNDERCHARGE": ("E4", "high", "undercharge"),
             "ENGINE_ERROR": ("E4", "medium", "unknown"),
             "TRUNCATED": ("E4", "low", "unknown")}

# 치명(게이팅) 코드 — spec R5 BROKEN 판정과 stop_predicate 기준
_FATAL = {"ANCHOR_DELETED", "ZERO_FINAL", "NO_SOURCE"}


def _run_sensor(script: str, args: list[str]) -> list[dict]:
    """raw/webadmin 센서를 서브프로세스 --json 실행 → JSONL 파싱. exit 1(결함있음)도 정상 수용."""
    cmd = [str(_PY), f"tools/{script}", *args]
    proc = subprocess.run(cmd, cwd=str(_WEBADMIN), capture_output=True, text=True, timeout=3600)
    if proc.returncode not in (0, 1):
        raise RuntimeError(f"{script} exit={proc.returncode}: {proc.stderr.strip()[:300]}")
    rows = [json.loads(ln) for ln in proc.stdout.splitlines() if ln.strip().startswith("{")]
    # exit 1 인데 JSON 방출 0 + stderr 있음 = 크래시(모듈 부재 등) — 묵음 스킵 금지(R3/A-1).
    if proc.returncode == 1 and not rows and proc.stderr.strip():
        raise RuntimeError(f"{script} 크래시(exit 1·JSON 0): {proc.stderr.strip()[:300]}")
    return rows


class WidgetWiringDx(Diagnoser):
    dimension = "widget_wiring"
    title = "위젯 배선(옵션계층·ref_dim 해소·제약·0원) — 센서 5종 어댑터"

    def scan(self, snap) -> list[Defect]:
        out: list[Defect] = []
        env_fail = self._env_check()
        if env_fail:
            return env_fail
        out += self._opt_ref()
        out += self._coverage()
        out += self._zero()
        out += self._constraints()
        out += self._optcode()
        return out

    # ── 실행 전제 확인(묵음 스킵 금지) ─────────────────────────────────────
    def _env_check(self) -> list[Defect] | None:
        if not _PY.exists():
            return [self._env_defect(f"webadmin venv 부재: {_PY}")]
        if not (_WEBADMIN / ".env").exists():
            return [self._env_defect("webadmin .env(DATABASE_URL) 부재")]
        return None

    def _env_defect(self, why: str) -> Defect:
        return Defect(dimension=self.dimension, severity="critical", money_impact="unknown",
                      summary=f"[환경 FAIL] {why} — 센서 실행 불가(묵음 스킵 아님)",
                      suggested_fix="raw/webadmin/.venv · .env(DATABASE_URL) 구성 후 재실행")

    # ── W2·W4·(E4 PRICE_MISSING): 옵션 참조(가격 앵커) 무결성 ──────────────
    def _opt_ref(self) -> list[Defect]:
        try:
            rows = _run_sensor("verify_option_ref_integrity.py", ["--json"])
        except Exception as e:                                    # noqa: BLE001
            return [self._env_defect(f"verify_option_ref_integrity 실행 실패: {e}")]
        return [self._conv(f, _OPTREF_MAP, extra=(f.get("code") == "PARENT_DEAD")) for f in rows]

    # ── E3·E4: 가격 커버리지(등록값↔단가행 any-row-exists) ─────────────────
    def _coverage(self) -> list[Defect]:
        try:
            rows = _run_sensor("verify_price_coverage.py", ["--json"])
        except Exception as e:                                    # noqa: BLE001
            return [self._env_defect(f"verify_price_coverage 실행 실패: {e}")]
        out = []
        # 직접단가 보유 상품 = 엔진 1순위 PRODUCT_PRICE(pricing.py:568-581) → 공식 없음이 정상.
        # 원본 센서도 NO_FORMULA 를 정보성(무공식 카운트)으로만 다룬다 — Defect 로 승격하지 않는다
        # (review 260822 교정1: 판정 무-mint 위반). 직접단가·공식 모두 없는 상품만 치명 결함.
        direct = {r[0] for r in db(
            "SELECT DISTINCT prd_cd FROM t_prd_product_prices WHERE unit_price IS NOT NULL")}
        for r in rows:                     # 상품 단위 레코드 → finding 단위 전개
            if r.get("status") == "NO_FORMULA" and r["prd_cd"] not in direct:
                out.append(Defect(dimension="E1", severity="critical", money_impact="undercharge",
                                   prd_cd=r["prd_cd"],
                                   summary=f"NO_FORMULA 직접단가도 없음(항상 0원): {r.get('nm','')}",
                                   evidence={"sensor": "verify_price_coverage", "status": "NO_FORMULA"},
                                   suggested_fix="직접단가 또는 공식 바인딩 구성(권위 확인 후·값 날조 금지)"))
            for f in r.get("findings", []):
                edge, sev, money = _COVERAGE_MAP.get(f["type"], ("E4", "medium", "unknown"))
                out.append(Defect(dimension=edge, severity=sev, money_impact=money,
                                   prd_cd=r["prd_cd"], comp_cd=f.get("comp") or None,
                                   summary=(f"{f['type']} {f['dim']}: {f.get('detail','')} "
                                            f"값={f.get('values', [])[:8]}"),
                                   evidence={"sensor": "verify_price_coverage",
                                             "finding": f},
                                   suggested_fix=("권위 대조 후 판단(가격 그리드를 신 코드로 재적재 vs 코드 통합). "
                                                  "[HARD] 값 삭제 금지 — 2026-07 대리키 오판 삭제로 "
                                                  "0원 견적 사고 전례")))
        return out

    # ── E4(치명): 0원 견적 전수 ───────────────────────────────────────────
    def _zero(self) -> list[Defect]:
        try:
            rows = _run_sensor("verify_zero_quote.py", ["--json"])
        except Exception as e:                                    # noqa: BLE001
            return [self._env_defect(f"verify_zero_quote 실행 실패: {e}")]
        return [self._conv(f, _ZERO_MAP) for f in rows]

    # ── C1: 제약 무효(항상거짓·죽은참조) — audit_constraints 판정부 이식 ────
    def _constraints(self) -> list[Defect]:
        try:
            bad_always, bad_dead = _audit_constraints_ported()
        except Exception as e:                                    # noqa: BLE001
            return [self._env_defect(f"audit_constraints 이식 판정 실패: {e}")]
        out = []
        for prd, cd, nm, trig in bad_always:
            out.append(Defect(dimension="C1", severity="high", money_impact="unknown",
                              prd_cd=prd,
                              summary=f"RULE_ALWAYS_FALSE {cd}({nm}) — 조건이 절대 참이 될 수 없어 아무것도 못 막음",
                              evidence={"rule_cd": cd, "rule_nm": nm, "trigger": trig},
                              suggested_fix="같은 차원 여러 값은 OR 로 묶기(그룹 배지)"))
        for prd, cd, nm, dead in bad_dead:
            out.append(Defect(dimension="C1", severity="high", money_impact="unknown",
                              prd_cd=prd,
                              summary=f"RULE_DEAD_REF {cd}({nm}) — 없는 값 참조: {dead}",
                              evidence={"rule_cd": cd, "rule_nm": nm, "dead_refs": dead},
                              suggested_fix="규칙이 가리키는 코드를 상품에 연결(또는 규칙 코드 교정)"))
        return out

    # ── W1·W2·W3·C1·E4: 옵션코드 정합 — verify_optcode_integrity[1]-[4] 이식 ──
    def _optcode(self) -> list[Defect]:
        try:
            out = _optcode_ported()
        except Exception as e:                                    # noqa: BLE001
            return [self._env_defect(f"verify_optcode_integrity 이식 판정 실패: {e}")]
        defects = []
        for code, prd, detail, sev, money, edge in out:
            defects.append(Defect(dimension=edge, severity=sev, money_impact=money,
                                  prd_cd=prd, summary=f"{code} — {detail}",
                                  evidence={"sensor": "verify_optcode_integrity", "code": code},
                                  suggested_fix="docs/optcode-verify-report.html 조치안 참고"))
        return defects

    def _conv(self, f: dict, cmap: dict, extra: bool = False) -> Defect:
        code = f.get("code", "?")
        edge, sev, money = cmap.get(code, ("W4", "medium", "unknown"))
        ev = {k: f.get(k) for k in ("sensor", "code", "prd_cd", "prd_nm", "opt_cd", "opt_nm",
                                    "item_seq", "dim", "ref_dim_cd", "ref_key1", "key", "detail")}
        return Defect(dimension=edge, severity=sev, money_impact=money,
                      prd_cd=f.get("prd_cd"), summary=f"{code} {f.get('key', f.get('detail', ''))[:120]}",
                      evidence=ev, suggested_fix="webadmin UI 교정(§36) 후 센서 재실행")

    def stop_predicate(self, defects: list[Defect]) -> bool:
        # 치명 엣지 단절 0만 종료 — PARENT_DEAD 등 비치명(WARN)은 원본 정책 승계(비게이팅).
        return not any(d.severity == "critical" for d in defects)


# ═══════════════════════════════════════════════════════════════════════════
# audit_constraints 판정부 이식 — 원본 raw/webadmin/tools/audit_constraints.py
# 의 possibilities·trigger_of·collect_refs·live_values 를 verbatim(로직 동일) 이식.
# 차이: psycopg 커서 대신 foundation.db(읽기전용 psql) 로 테이블을 한 번에 적재.
# ═══════════════════════════════════════════════════════════════════════════
_CODE_PAT = re.compile(r"OP[TV][-_][0-9]{6}")
_CHECKED_VARS = ("siz_cd", "mat_cd__usage_cd", "proc_cd", "sel_procs",
                 "sel_opts", "sel_opt_grps", "sel_addons", "sel_dtl")


def _possibilities(node):
    """audit_constraints.possibilities verbatim — [] 이면 절대 만족 불가(항상 거짓)."""
    if not isinstance(node, dict):
        return [{}]
    if "===" in node:
        a = node["==="]
        if (isinstance(a, list) and len(a) == 2 and isinstance(a[0], dict)
                and "var" in a[0] and not isinstance(a[1], (dict, list))):
            return [{a[0]["var"]: a[1]}]
        return [{}]
    if isinstance(node.get("and"), list):
        acc = [{}]
        for ch in node["and"]:
            nxt = []
            for base in acc:
                for p in _possibilities(ch):
                    if any(k in base and base[k] != v for k, v in p.items()):
                        continue
                    merged = dict(base)
                    merged.update(p)
                    nxt.append(merged)
            acc = nxt
            if not acc:
                return []
        return acc
    if isinstance(node.get("or"), list):
        out = []
        for ch in node["or"]:
            out += _possibilities(ch)
        return out
    return [{}]


def _trigger_of(logic, typ):
    """audit_constraints.trigger_of verbatim."""
    if not isinstance(logic, dict):
        return None
    if typ == "RULE_TYPE.02":
        return logic.get("!")
    if typ in ("RULE_TYPE.01", "RULE_TYPE.03"):
        oa = logic.get("or")
        if isinstance(oa, list) and len(oa) == 2 and isinstance(oa[0], dict):
            return oa[0].get("!")
    return None


def _collect_refs(node, out):
    """audit_constraints.collect_refs verbatim."""
    if isinstance(node, dict):
        for op, args in node.items():
            if op == "===" and isinstance(args, list) and len(args) == 2:
                if isinstance(args[0], dict) and "var" in args[0]:
                    out.append((args[0]["var"], args[1]))
                    continue
            if op == "in" and isinstance(args, list) and len(args) == 2:
                if isinstance(args[1], dict) and "var" in args[1]:
                    out.append((args[1]["var"], args[0]))
                    continue
            _collect_refs(args, out)
    elif isinstance(node, list):
        for x in node:
            _collect_refs(x, out)
    return out


def _tuples(sql: str) -> list[tuple]:
    return [tuple(r) for r in db(sql)]


def _audit_constraints_ported():
    """audit_constraints.main 의 판정 흐름 이식(데이터 적재만 배치化). 반환: (bad_always, bad_dead)."""
    rules = _tuples("""select prd_cd, rule_cd, rule_nm, rule_typ_cd, logic
                         from t_prd_product_constraints
                        where del_yn='N' and use_yn='Y' order by prd_cd, rule_cd""")
    # live_values 원본 쿼리들을 한 번에 적재 (var 별 집합 구성 재료)
    sizes = {}
    for prd, s in _tuples("select prd_cd, siz_cd from t_prd_product_sizes "
                          "where del_yn='N'"):
        sizes.setdefault(prd, set()).add(s)
    mats = {}
    for prd, m, u in _tuples("select prd_cd, mat_cd, usage_cd from t_prd_product_materials"):
        mats.setdefault(prd, set()).add(f"{m}__{u}")
    linked = {}
    for prd, p in _tuples("select prd_cd, proc_cd from t_prd_product_processes "
                          "where coalesce(del_yn,'N')<>'Y'"):
        linked.setdefault(prd, set()).add(p)
    procs_all = {}                      # proc_cd → (prcs_dtl_opt JSON, upr_proc_cd)
    for p, opt, up in _tuples("select proc_cd, prcs_dtl_opt::text, upr_proc_cd "
                              "from t_proc_processes where del_yn='N'"):
        try:
            procs_all[p] = (json.loads(opt) if opt and opt != "null" else None, up)
        except Exception:                                    # noqa: BLE001
            procs_all[p] = (None, up)
    opts = {}
    for prd, o in _tuples("select prd_cd, opt_cd from t_prd_product_options where del_yn='N'"):
        opts.setdefault(prd, set()).add(o)
    grps = {}
    for prd, g in _tuples("select prd_cd, opt_grp_cd from t_prd_product_option_groups "
                          "where del_yn='N'"):
        grps.setdefault(prd, set()).add(g)
    addons = {}
    for prd, t in _tuples("select prd_cd, tmpl_cd from t_prd_product_addons"):
        addons.setdefault(prd, set()).add(t)

    def live_values(prd):
        live = {"siz_cd": sizes.get(prd, set()),
                "mat_cd__usage_cd": mats.get(prd, set())}
        lk = linked.get(prd, set())
        # 원본: t_proc_processes where (proc_cd = any(linked) or upr_proc_cd = any(linked)) and del_yn='N'
        procs = {p for p, (o, up) in procs_all.items() if (p in lk or up in lk)} if lk else set()
        live["proc_cd"] = live["sel_procs"] = procs
        live["sel_opts"] = opts.get(prd, set())
        live["sel_opt_grps"] = grps.get(prd, set())
        live["sel_addons"] = addons.get(prd, set())
        dtl = set()
        for p in procs:
            cur, seen = p, set()
            while cur and cur not in seen:
                seen.add(cur)
                opt, up = procs_all.get(cur, (None, None))
                ins = (opt or {}).get("inputs") if isinstance(opt, dict) else None
                if ins:
                    for i in ins:
                        if isinstance(i, dict) and i.get("key"):
                            dtl.add(f'{p}__{i["key"]}')
                    break
                cur = up
        live["sel_dtl"] = dtl
        return live

    bad_always, bad_dead = [], []
    cache = {}
    for prd, cd, nm, typ, logic_txt in rules:
        try:
            logic = json.loads(logic_txt) if logic_txt else {}
        except Exception:                                    # noqa: BLE001
            logic = {}
        trig = _trigger_of(logic, typ or "")
        if trig is not None and _possibilities(trig) == []:
            bad_always.append((prd, cd, nm, json.dumps(trig, ensure_ascii=False)[:160]))
            continue
        if prd not in cache:
            cache[prd] = live_values(prd)
        live = cache[prd]
        dead = []
        for var, val in _collect_refs(logic, []):
            if var not in _CHECKED_VARS or not isinstance(val, str):
                continue
            if val not in live.get(var, set()):
                dead.append(f"{var}={val}")
        if dead:
            bad_dead.append((prd, cd, nm, ", ".join(sorted(set(dead)))))
    return bad_always, bad_dead


# ═══════════════════════════════════════════════════════════════════════════
# verify_optcode_integrity [1]-[4] 판정부 이식 — SQL 은 원본 verbatim,
# 결과 셋 평가만 Python 집합으로 (per-EXISTS N+1 psql 회피·판정 동일).
# ═══════════════════════════════════════════════════════════════════════════
def _optcode_ported() -> list[tuple]:
    """(code, prd_cd, detail, severity, money, edge) 목록."""
    out = []
    # [1] 교차상품 중복 (원본 SQL verbatim)
    for table, col, label in (("t_prd_product_option_groups", "opt_grp_cd", "그룹"),
                              ("t_prd_product_options", "opt_cd", "옵션")):
        rows = _tuples(f"SELECT {col}, array_agg(DISTINCT prd_cd) FROM {table} "
                       f"WHERE del_yn='N' GROUP BY {col} HAVING count(DISTINCT prd_cd)>1")
        for cd, prds in rows:
            out.append(("XPROD_DUP", None, f"{label} {cd} 교차상품 재사용: {prds}",
                        "medium", "unknown", "W2"))
    # [2] orphan 옵션/항목 (원본 SQL verbatim)
    n = int(db("""SELECT count(*) FROM t_prd_product_options o WHERE o.del_yn='N' AND NOT EXISTS
      (SELECT 1 FROM t_prd_product_option_groups g WHERE g.prd_cd=o.prd_cd AND g.opt_grp_cd=o.opt_grp_cd)""")[0][0])
    if n:
        for prd, oc in _tuples("""SELECT DISTINCT o.prd_cd, o.opt_cd FROM t_prd_product_options o
            WHERE o.del_yn='N' AND NOT EXISTS (SELECT 1 FROM t_prd_product_option_groups g
            WHERE g.prd_cd=o.prd_cd AND g.opt_grp_cd=o.opt_grp_cd)"""):
            out.append(("ORPHAN_OPT", prd, f"옵션 {oc} 그룹 없음(고아)", "medium", "none", "W2"))
    n = int(db("""SELECT count(*) FROM t_prd_product_option_items i WHERE NOT EXISTS
      (SELECT 1 FROM t_prd_product_options o WHERE o.prd_cd=i.prd_cd AND o.opt_cd=i.opt_cd)""")[0][0])
    if n:
        for prd, oc in _tuples("""SELECT DISTINCT i.prd_cd, i.opt_cd FROM t_prd_product_option_items i
            WHERE NOT EXISTS (SELECT 1 FROM t_prd_product_options o
            WHERE o.prd_cd=i.prd_cd AND o.opt_cd=i.opt_cd)"""):
            out.append(("ORPHAN_ITEM", prd, f"옵션항목 (옵션 {oc} 없음=고아 항목)",
                        "medium", "none", "W3"))
    # W1 보강: 활성 그룹인데 살아있는 옵션이 0개(빈 그룹) — spec §3.2 W1 EMPTY_GROUP
    for prd, g in _tuples("""SELECT g.prd_cd, g.opt_grp_cd FROM t_prd_product_option_groups g
        WHERE g.del_yn='N' AND g.use_yn='Y' AND NOT EXISTS
        (SELECT 1 FROM t_prd_product_options o WHERE o.prd_cd=g.prd_cd
         AND o.opt_grp_cd=g.opt_grp_cd AND o.del_yn='N')"""):
        out.append(("EMPTY_GROUP", prd, f"옵션그룹 {g} 에 살아있는 옵션 0개", "medium", "none", "W1"))
    # [3] 제약 logic 코드참조 (원본 SQL verbatim — EXISTS 를 집합 멤버십으로)
    grp_pairs = {(r[0], r[1]) for r in _tuples(
        "SELECT prd_cd, opt_grp_cd FROM t_prd_product_option_groups")}
    opt_pairs = {(r[0], r[1]) for r in _tuples(
        "SELECT prd_cd, opt_cd FROM t_prd_product_options")}
    for prd, rule, logic_txt in _tuples(
            "SELECT prd_cd, rule_cd, logic FROM t_prd_product_constraints "
            "WHERE del_yn='N' AND use_yn='Y'"):
        for m in set(_CODE_PAT.findall(logic_txt or "")):
            if (prd, m) not in grp_pairs and (prd, m) not in opt_pairs:
                out.append(("RULE_DEAD_REF", prd, f"제약 {rule} 이 {m} 참조 — 상품에 실존 안 함",
                            "high", "unknown", "C1"))
    # [4-a] 단가표 opt_cd(OPV) 참조 (원본 SQL verbatim)
    for (oc,) in _tuples(r"""SELECT DISTINCT cp.opt_cd FROM t_prc_component_prices cp
        WHERE cp.opt_cd ~ '\yOPV[-_][0-9]{6}\y'
          AND NOT EXISTS (SELECT 1 FROM t_prd_product_options o WHERE o.opt_cd=cp.opt_cd)"""):
        out.append(("PRICE_REF_DEAD", None, f"단가표 opt_cd {oc} 옵션 테이블에 없음",
                    "high", "undercharge", "E4"))
    # [4-b] use_dims 안 코드 참조 (원본 판정 verbatim)
    all_grps = {r[0] for r in _tuples("SELECT opt_grp_cd FROM t_prd_product_option_groups")}
    all_opts = {r[0] for r in _tuples("SELECT opt_cd FROM t_prd_product_options")}
    for comp, ud in _tuples("SELECT comp_cd, use_dims FROM t_prc_price_components "
                            "WHERE use_dims IS NOT NULL"):
        for c in set(_CODE_PAT.findall(ud if isinstance(ud, str) else json.dumps(ud))):
            ok = (c in all_grps) if c.startswith("OPT") else (c in all_opts)
            if not ok:
                out.append(("USEDIMS_REF_DEAD", None, f"구성요소 {comp} use_dims 코드 {c} 유실",
                            "high", "unknown", "E2"))
    return out
