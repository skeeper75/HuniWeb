"""DimConformanceRmd — 차원 정합 결함 교정 생성.

분류:
  UNDECLARED → **auto_data**: comp use_dims 에 누락 차원 선언 추가(메타데이터·값 날조 없음).
               SQL 트리플 생성(백업·dryrun·fix·undo·게이트). ★가격중립 예상 —
               엔진(match_component)은 NON_QTY_DIMS 를 use_dims 무관하게 하드코딩 매칭하므로
               use_dims 선언은 UI/차원 인식용. 실제 가격 변동 여부는 **P4 재실측이 확인**(게이트).
  MISSING    → **needs_authority**: 누락 차원값에 단가행 필요. 값이 권위 엑셀/실무진에서 와야 함
               → 날조 금지·SQL 안 만듦·worklist 로만.
"""
from __future__ import annotations
import json

from .base import Remediator, backup_sql, gate_assert, wrap_tx, sql_header
from ..foundation import Snapshot, Defect, Fix


class DimConformanceRmd(Remediator):
    dimension = "dim_conformance"
    title = "차원 정합 교정"

    def generate(self, defects: list[Defect], snap: Snapshot) -> list[Fix]:
        mine = self._mine(defects)
        # comp 현재 use_dims 조회(원본 문자열 → 파싱)
        comp_use_dims = {}
        for r in snap.table("t_prc_price_components"):
            c = r.get("comp_cd")
            if not c:
                continue
            try:
                comp_use_dims[c] = json.loads(r.get("use_dims") or "[]")
            except Exception:
                comp_use_dims[c] = []

        out: list[Fix] = []
        missing = [d for d in mine if "MISSING" in d.summary]
        undeclared = [d for d in mine if "UNDECLARED" in d.summary]

        # ── UNDECLARED → auto_data (comp 단위로 묶음) ──
        by_comp: dict[str, list[Defect]] = {}
        for d in undeclared:
            by_comp.setdefault(d.comp_cd, []).append(d)
        for comp_cd, ds in sorted(by_comp.items()):
            dims_to_add = sorted({d.evidence.get("dim") for d in ds if d.evidence.get("dim")})
            cur = comp_use_dims.get(comp_cd, [])
            new = list(cur)
            for dm in dims_to_add:
                if dm not in new:
                    new.append(dm)
            if new == cur:
                continue  # 이미 선언됨(스냅샷 드리프트) → skip
            new_json = json.dumps(new, ensure_ascii=False)
            bak = f"z_bak_dimconf_usedims_{comp_cd.lower()}"
            where = f"comp_cd='{comp_cd}'"
            fix = Fix(
                dimension=self.dimension, remediation_class="auto_data",
                title=f"use_dims 선언 추가: {comp_cd} += {dims_to_add}",
                defects=[d.key() for d in ds],
                backup_table=bak,
                gates=[
                    f"사후: use_dims 에 {dims_to_add} 포함(선언 반영)",
                    "★P4 재실측: 이 comp 를 쓰는 상품 골든가 변동 0(가격중립 확인) — 변동 시 NO-GO",
                ],
            )
            body = "\n\n".join([
                backup_sql(bak, "t_prc_price_components", where),
                gate_assert(f"EXISTS(SELECT 1 FROM t_prc_price_components WHERE {where})",
                            f"{comp_cd} 부재 — 사전조건 실패"),
                f"UPDATE t_prc_price_components\n"
                f"SET use_dims = '{new_json}'::jsonb, upd_dt = now()\n"
                f"WHERE {where};",
                gate_assert(
                    f"(SELECT use_dims FROM t_prc_price_components WHERE {where}) @> '{json.dumps(dims_to_add, ensure_ascii=False)}'::jsonb",
                    f"{comp_cd} use_dims 선언 반영 실패"),
            ])
            fix.fix_sql = sql_header(fix) + "\n" + wrap_tx(body)
            fix.dryrun_sql = (sql_header(fix) +
                              "\n-- 롤백전용 멱등 실증(적재 안 함): BEGIN → fix → 검증 → ROLLBACK\n" +
                              "BEGIN;\n" + body + "\nROLLBACK;  -- ★DRY-RUN: 적용 안 함")
            fix.undo_sql = (f"-- undo: 백업 {bak} 에서 use_dims 원복\n"
                            f"UPDATE t_prc_price_components t\n"
                            f"SET use_dims = b.use_dims, upd_dt = now()\n"
                            f"FROM {bak} b WHERE t.comp_cd = b.comp_cd;")
            out.append(fix)

        # ── MISSING → needs_authority (차원별 묶음·worklist) ──
        if missing:
            by_dim: dict[str, list[Defect]] = {}
            for d in missing:
                by_dim.setdefault(d.evidence.get("dim", "?"), []).append(d)
            for dim, ds in sorted(by_dim.items()):
                prods = sorted({d.prd_cd for d in ds if d.prd_cd})
                note = (f"차원 '{dim}' 단가행 누락 {len(ds)}건(상품 {len(prods)}개). "
                        f"누락 값에 대응하는 단가는 **권위 엑셀(가격표)/실무진**에서 확인해야 함 "
                        f"— AI 날조 금지. 값 확보 후 §7 dbmap 적재. 대상 상품: "
                        f"{', '.join(prods[:12])}{' …' if len(prods) > 12 else ''}")
                out.append(Fix(
                    dimension=self.dimension, remediation_class="needs_authority",
                    title=f"차원 누락 단가행 적재 필요(MISSING·{dim}) — 권위값 확보",
                    defects=[d.key() for d in ds], worklist_note=note,
                ))
        return out
