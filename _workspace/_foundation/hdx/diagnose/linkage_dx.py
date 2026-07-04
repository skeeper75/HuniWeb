"""LinkageDx — 배선 연결 무결성(양방향) 진단. 새 스코프 `--scope linkage`.

★목적(사용자 260704): 실무진이 webadmin 에서 기준정보를 수정·이름변경·삭제후재등록 하면서
상품 ↔ 가격공식 ↔ 가격구성요소 ↔ 단가행/차원 의 **연결 고리가 끊어지는(단절)** 상황을,
한 명령으로 한 바퀴 돌며 잡아 교정하기 위한 전용 렌즈. 값(단가)의 정확성이 아니라
**연결(배선)의 무결성**에 초점 — 값 날조 문제가 아니라 재연결(re-link) 문제.

각 연결지점을 **정방향(부모→자식 참조 유효)** + **역방향(자식이 유효 부모에서 도달)** 으로 모두 확인.
정방향만 보면 "참조는 정상"이라 안 보이는 단절이, 역방향에서 "붙어있어야 할 게 떨어졌다"로 드러난다.

연결 체인(4 에지):
  E1 상품 ──t_prd_product_price_formulas──▶ 가격공식
  E2 가격공식 ──t_prc_formula_components──▶ 가격구성요소
  E3 가격구성요소 ──use_dims / 단가행──▶ 차원(자재·공정·옵션·사이즈)
  E4 상품구성요소(손님선택) ──▶ 단가행 차원값   (E3·E4 는 서로 맞아야 가격 계산됨)

search-before-mint(CLAUDE.md §6):
  · E2 배선 고아/죽은단가행/오염(논리삭제) = 검증된 `batch/wiring_scan.py` 재사용(드리프트 0·LEGIT_UNUSED 존중).
  · E3 UNDECLARED / E4 MISSING = 검증된 `DimConformanceDx` 재사용(3자 조인 verbatim).
  · 신규 = E1 양방향(상품↔공식) + E2 dangling(참조 자체 부재)·빈공식(역) + E2 오염 재연결후보 탐지.

[HARD] 스냅샷 읽기전용·결정론·토큰0. 교정 생성은 P3(LinkageRmd)·재실측은 P4.
"""
from __future__ import annotations
import sys
import pathlib
from collections import defaultdict

from .base import Diagnoser
from .dim_conformance_dx import DimConformanceDx
from ..foundation import Snapshot, Defect

# 원본 배선 스캐너 재사용(검증된 로직·LEGIT_UNUSED 판정 존중)
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[2] / "batch"))
import wiring_scan  # noqa: E402

# 에지 라벨(보드·리포트 표시)
EDGE_LABEL = {
    "E1F": "상품→공식",         "E1R": "공식→상품(역)",
    "E2F": "공식→구성요소",     "E2R": "구성요소→공식(역)",
    "E3":  "구성요소→단가행차원", "E4": "상품선택↔단가행",
}

_ACTIVE_PRD = lambda r: (r.get("use_yn", "Y") != "N") and (r.get("del_yn", "N") != "Y")
_ACTIVE_COMP = lambda r: (r.get("use_yn", "Y") != "N") and (r.get("del_yn", "N") != "Y")


class LinkageDx(Diagnoser):
    dimension = "linkage"
    title = "배선 연결 무결성(양방향)"

    def scan(self, snap: Snapshot) -> list[Defect]:
        out: list[Defect] = []

        # ── 기준 인덱스 ──────────────────────────────────────────────
        products = {r["prd_cd"]: r for r in snap.table("t_prd_products") if r.get("prd_cd")}
        prod_active = {p for p, r in products.items() if _ACTIVE_PRD(r)}
        prod_nm = {p: r.get("prd_nm", "") for p, r in products.items()}

        formulas = {r["frm_cd"]: r for r in snap.table("t_prc_price_formulas") if r.get("frm_cd")}
        frm_active = {f for f, r in formulas.items() if (r.get("use_yn", "Y") != "N")}
        frm_nm = {f: r.get("frm_nm", "") for f, r in formulas.items()}

        comps = {r["comp_cd"]: r for r in snap.table("t_prc_price_components") if r.get("comp_cd")}
        comp_active = {c for c, r in comps.items() if _ACTIVE_COMP(r)}
        comp_nm = {c: r.get("comp_nm", "") for c, r in comps.items()}
        # comp_nm → 활성 comp_cd (오염 재연결 후보 탐지용: 삭제된 comp 와 같은 이름의 활성 comp)
        nm_to_active = defaultdict(list)
        for c in comp_active:
            nm_to_active[comp_nm.get(c, "").strip()].append(c)

        ppf = [r for r in snap.table("t_prd_product_price_formulas")
               if r.get("prd_cd") and r.get("frm_cd")]
        fc = [r for r in snap.table("t_prc_formula_components")
              if r.get("frm_cd") and r.get("comp_cd")]

        # 배선 집합(역방향 판정용)
        frm_in_ppf = {r["frm_cd"] for r in ppf}          # 상품에 물린 공식
        prd_in_ppf = {r["prd_cd"] for r in ppf}          # 공식을 가진 상품
        frm_has_comp = {r["frm_cd"] for r in fc}         # comp 를 가진 공식
        comp_wired = {r["comp_cd"] for r in fc}          # 공식에 물린 comp

        # ══════════════════════════════════════════════════════════════
        # E1  상품 ↔ 가격공식  (정방향 + 역방향)
        # ══════════════════════════════════════════════════════════════
        for r in ppf:
            p, f = r["prd_cd"], r["frm_cd"]
            # E1-정방향: 상품이 참조하는 공식이 존재/활성인가
            if f not in formulas:
                out.append(self._d("E1F", "critical", "undercharge", p, prod_nm.get(p),
                    frm=f, summary=f"상품이 존재하지 않는 공식 참조(frm_cd={f}) → 가격계산 불가",
                    fix="공식 재등록 또는 올바른 frm_cd 로 재연결(실무진 확인)"))
            elif f not in frm_active:
                out.append(self._d("E1F", "high", "undercharge", p, prod_nm.get(p),
                    frm=f, summary=f"상품이 비활성(use_yn=N) 공식 참조: {frm_nm.get(f, f)} → 계산 불가",
                    fix="공식 활성화(use_yn=Y) 또는 활성 공식으로 재연결"))
            # E1-정방향(상품측): 죽은/없는 상품에 공식 배선(청소 대상)
            if p not in prod_active:
                out.append(self._d("E1F", "low", "unknown", p, prod_nm.get(p),
                    frm=f, summary=f"비활성/없는 상품에 공식 배선(청소 대상): {p}",
                    fix="논리삭제 상품이면 배선 행 정리(product_price_formulas)"))

        # E1-역방향: 활성 공식인데 어떤 상품도 안 씀(상품에서 떨어진 공식·orphan formula)
        for f in sorted(frm_active):
            if f in frm_in_ppf:
                continue
            if f not in frm_has_comp:
                continue  # comp 도 없는 완전 빈 공식은 E2R 에서 다룸
            out.append(self._d("E1R", "medium", "unknown", None, None,
                frm=f, summary=f"공식이 어떤 상품에도 안 붙음(역방향 단절): {frm_nm.get(f, f)}",
                fix="이 공식을 써야 할 상품에 배선(product_price_formulas) 또는 미사용이면 use_yn=N"))

        # ══════════════════════════════════════════════════════════════
        # E2  가격공식 ↔ 가격구성요소  (정방향 + 역방향)
        # ══════════════════════════════════════════════════════════════
        for r in fc:
            f, c = r["frm_cd"], r["comp_cd"]
            # E2-정방향(공식측): 죽은/없는 공식에 comp 배선(청소)
            if f not in formulas:
                out.append(self._d("E2F", "low", "unknown", None, None,
                    frm=f, comp=c, summary=f"존재하지 않는 공식에 구성요소 배선(청소 대상): frm_cd={f}",
                    fix="죽은 배선 행 정리(formula_components)"))
            # E2-정방향(comp측): 참조하는 comp 가 마스터에 아예 없음(dangling)
            if c not in comps:
                out.append(self._d("E2F", "critical", "undercharge", None, None,
                    frm=f, comp=c, summary=f"공식이 존재하지 않는 구성요소 참조(comp_cd={c}) → 배선 끊김",
                    fix="구성요소 재등록 또는 올바른 comp_cd 로 재연결(실무진 확인)"))
            # E2-정방향(comp측): comp 는 있으나 논리삭제/비활성(오염 배선) — rename 재등록 흔적
            elif c not in comp_active:
                nm = comp_nm.get(c, "").strip()
                relink = [x for x in nm_to_active.get(nm, []) if x != c]
                if relink:
                    out.append(self._d("E2F", "high", "undercharge", None, None,
                        frm=f, comp=c,
                        summary=f"삭제된 구성요소가 배선에 남음 '{nm}' → 같은 이름 활성 comp 존재(재연결 후보: {relink[0]})",
                        fix=f"배선을 {c} → {relink[0]} 로 재연결(이름 동일·삭제후재등록 흔적)",
                        extra={"relink_to": relink[0], "relink_name": nm}))
                else:
                    out.append(self._d("E2F", "high", "undercharge", None, None,
                        frm=f, comp=c,
                        summary=f"논리삭제된 구성요소가 배선에 남음(오염 배선): {nm or c}",
                        fix="죽은 배선 제거 또는 구성요소 재활성(실무진 확인)"))

        # E2-역방향: wiring_scan 재사용(고아 comp·빈배선·오염) — 검증된 로직·LEGIT_UNUSED 존중
        wr = wiring_scan.scan_from_snapshot(snap.dir)
        for o in wr.get("orphans", []):
            out.append(self._d("E2R", "high", "undercharge", None, None,
                comp=o["comp_cd"],
                summary=f"구성요소가 어떤 공식에도 안 붙음(역방향 단절·단가행 {o['price_rows']}행 있음): {o['comp_nm']}",
                fix="이 구성요소를 써야 할 공식에 배선(formula_components) 또는 정당 미사용 등록",
                extra={"price_rows": o["price_rows"]}))
        for d in wr.get("dead_wires", []):
            out.append(self._d("E2R", "high", "undercharge", None, None,
                comp=d["comp_cd"], frm=d["frm_cd"],
                summary=f"배선됐으나 단가행 0(빈 배선): {d['comp_nm']}",
                fix="단가행(component_prices) 적재 또는 배선 제거"))

        # E2-역방향(빈 공식): 상품에 물렸는데 comp 0개 → 계산 불가
        for f in sorted(frm_in_ppf):
            if f in frm_active and f not in frm_has_comp:
                out.append(self._d("E2R", "critical", "undercharge", None, None,
                    frm=f, summary=f"상품에 물린 공식인데 구성요소 0개(빈 공식) → 가격계산 불가: {frm_nm.get(f, f)}",
                    fix="이 공식이 물어야 할 구성요소를 formula_components 에 배선(실무진 확인)"))

        # ══════════════════════════════════════════════════════════════
        # E3 / E4  차원 정합 — DimConformanceDx 재사용(3자 조인 verbatim·재구현 0)
        #   UNDECLARED → E3(구성요소↔단가행 use_dims 단절)   MISSING → E4(상품선택↔단가행)
        # ══════════════════════════════════════════════════════════════
        for d in DimConformanceDx().scan(snap):
            if "UNDECLARED" in d.summary:
                out.append(self._d("E3", d.severity, d.money_impact, d.prd_cd,
                    prod_nm.get(d.prd_cd), frm=d.frm_cd, comp=d.comp_cd,
                    summary=f"단가행은 차원 구분하나 use_dims 미선언(엔진이 차원 무시): {d.evidence.get('dim')}",
                    fix=d.suggested_fix, extra=dict(d.evidence)))
            elif "MISSING" in d.summary:
                out.append(self._d("E4", d.severity, d.money_impact, d.prd_cd,
                    prod_nm.get(d.prd_cd), frm=d.frm_cd, comp=d.comp_cd,
                    summary=f"손님이 고를 수 있는데 단가행에 없음(연결 누락·{d.evidence.get('dim')}): {d.evidence.get('missing_count')}값",
                    fix=d.suggested_fix, extra=dict(d.evidence)))
        return out

    # ── Defect 빌더(에지 메타 부착) ──────────────────────────────────
    def _d(self, edge, severity, money, prd, prd_nm=None, *, frm=None, comp=None,
           summary="", fix="", extra=None):
        ev = {"edge": edge, "edge_label": EDGE_LABEL[edge],
              "dir": "reverse" if edge.endswith("R") else "forward"}
        if prd_nm:
            ev["prd_nm"] = prd_nm
        if extra:
            ev.update(extra)
        return Defect(
            dimension=self.dimension,
            summary=f"[{EDGE_LABEL[edge]}] {summary}",
            severity=severity, money_impact=money,
            prd_cd=prd, comp_cd=comp, frm_cd=frm,
            evidence=ev, suggested_fix=fix,
        )

    def stop_predicate(self, defects: list[Defect]) -> bool:
        # 연결 단절 종료 기준 = 하드 단절(critical/high) 0. medium/low(청소·미사용후보)는 advisory.
        return not any(d.dimension == self.dimension and d.severity in ("critical", "high")
                       for d in defects)
