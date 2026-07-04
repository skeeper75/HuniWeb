"""LinkageRmd — 배선 연결 무결성 결함 교정 생성.

[HARD] 안전한 재연결만 자동(사용자 260704) — 값 날조 금지·가격 변동 교정은 인간 확인.
분류:
  E3 UNDECLARED  → **auto_data**: comp use_dims 에 누락 차원 선언 추가(메타·값 날조 없음·가격중립).
                    SQL 트리플. 엔진은 차원을 use_dims 무관 하드코딩 매칭 → 순수 정합(P4 가격중립 확인).
  E2F 재연결후보  → **review**(가격 복원): 삭제된 comp 와 같은 이름의 활성 comp 로 재연결하는
                    구체 SQL 을 제안하되, 0→정상으로 **가격이 바뀌므로**(가격중립 아님) webadmin
                    실화면 확인 후 적용. 값 날조 아님(대상 comp 의 기존 단가행 사용).
  E4 MISSING     → **needs_authority**: 손님선택값 단가행 필요 — 값이 권위 엑셀/실무진에서.
  E2R 빈배선/고아 → **blocked_human**(placeholder) / **review**(고아·빈공식): 단가·구성 또는 배선 판단.
  E1  단절/청소   → **review**: 어느 공식/상품에 연결·정리할지 인간 판단(자동 불가).
"""
from __future__ import annotations
import json

from .base import Remediator, backup_sql, gate_assert, wrap_tx, sql_header
from ..foundation import Snapshot, Defect, Fix


class LinkageRmd(Remediator):
    dimension = "linkage"
    title = "배선 연결 무결성 교정"

    def generate(self, defects: list[Defect], snap: Snapshot) -> list[Fix]:
        mine = self._mine(defects)
        out: list[Fix] = []

        def edge(d):
            return d.evidence.get("edge", "")

        # comp 현재 use_dims(E3 auto 용)
        comp_use_dims = {}
        for r in snap.table("t_prc_price_components"):
            c = r.get("comp_cd")
            if not c:
                continue
            try:
                comp_use_dims[c] = json.loads(r.get("use_dims") or "[]")
            except Exception:
                comp_use_dims[c] = []

        # ── E3 UNDECLARED → auto_data (comp 단위·use_dims 선언 추가·가격중립) ──
        e3 = [d for d in mine if edge(d) == "E3"]
        by_comp: dict[str, list[Defect]] = {}
        for d in e3:
            by_comp.setdefault(d.comp_cd, []).append(d)
        for comp_cd, ds in sorted(by_comp.items()):
            dims_to_add = sorted({d.evidence.get("dim") for d in ds if d.evidence.get("dim")})
            cur = comp_use_dims.get(comp_cd, [])
            new = list(cur) + [dm for dm in dims_to_add if dm not in cur]
            if new == cur:
                continue
            new_json = json.dumps(new, ensure_ascii=False)
            bak = f"z_bak_linkage_usedims_{comp_cd.lower()}"
            where = f"comp_cd='{comp_cd}'"
            fix = Fix(
                dimension=self.dimension, remediation_class="auto_data",
                title=f"use_dims 선언 추가(재연결): {comp_cd} += {dims_to_add}",
                defects=[d.key() for d in ds], backup_table=bak,
                mutation={"table": "t_prc_price_components", "key": {"comp_cd": comp_cd},
                          "set": {"use_dims": new}},
                gates=[f"사후: use_dims 에 {dims_to_add} 포함",
                       "★P4 재실측: 이 comp 쓰는 상품 골든가 변동 0(가격중립) — 변동 시 NO-GO"],
            )
            body = "\n\n".join([
                backup_sql(bak, "t_prc_price_components", where),
                gate_assert(f"EXISTS(SELECT 1 FROM t_prc_price_components WHERE {where})",
                            f"{comp_cd} 부재 — 사전조건 실패"),
                f"UPDATE t_prc_price_components\n"
                f"SET use_dims = '{new_json}'::jsonb, upd_dt = now()\nWHERE {where};",
                gate_assert(
                    f"(SELECT use_dims FROM t_prc_price_components WHERE {where}) "
                    f"@> '{json.dumps(dims_to_add, ensure_ascii=False)}'::jsonb",
                    f"{comp_cd} use_dims 선언 반영 실패"),
            ])
            fix.fix_sql = sql_header(fix) + "\n" + wrap_tx(body)
            fix.dryrun_sql = (sql_header(fix) + "\n-- 롤백전용 멱등 실증\nBEGIN;\n" + body
                              + "\nROLLBACK;  -- ★DRY-RUN")
            fix.undo_sql = (f"-- undo: 백업 {bak} 에서 원복\n"
                            f"UPDATE t_prc_price_components t SET use_dims=b.use_dims, upd_dt=now()\n"
                            f"FROM {bak} b WHERE t.comp_cd=b.comp_cd;")
            out.append(fix)

        # ── E2F 재연결 후보(삭제 comp → 같은이름 활성 comp) → review + 구체 SQL 제안 ──
        e2f_relink = [d for d in mine if edge(d) == "E2F" and d.evidence.get("relink_to")]
        for d in e2f_relink:
            old, new = d.comp_cd, d.evidence["relink_to"]
            nm = d.evidence.get("relink_name", "")
            relink_sql = (
                f"-- ★가격 복원(0→정상)·webadmin 실화면 확인 후 적용. 값 날조 아님({new} 기존 단가행 사용).\n"
                f"BEGIN;\n"
                f"  DROP TABLE IF EXISTS z_bak_linkage_relink_{old.lower()};\n"
                f"  CREATE TABLE z_bak_linkage_relink_{old.lower()} AS\n"
                f"  SELECT * FROM t_prc_formula_components WHERE comp_cd='{old}';\n"
                f"  UPDATE t_prc_formula_components SET comp_cd='{new}', upd_dt=now()\n"
                f"  WHERE frm_cd='{d.frm_cd}' AND comp_cd='{old}';\n"
                f"COMMIT;  -- undo: 백업에서 comp_cd 원복")
            out.append(Fix(
                dimension=self.dimension, remediation_class="review",
                title=f"재연결 후보(삭제후재등록 흔적): '{nm}' {old}→{new}",
                defects=[d.key()],
                worklist_note=(f"공식 {d.frm_cd} 의 배선이 삭제된 구성요소 {old}('{nm}')를 물고 있고, "
                               f"같은 이름의 활성 구성요소 {new} 가 있음 → 재연결 후보. "
                               f"실무진이 {new} 가 맞는 대체인지 확인 후 아래 SQL 적용(가격 0→정상 복원):\n{relink_sql}"),
                root_comps=[old],
            ))

        # ── E4 MISSING → needs_authority(차원별 묶음) ──
        e4 = [d for d in mine if edge(d) == "E4"]
        by_dim: dict[str, list[Defect]] = {}
        for d in e4:
            by_dim.setdefault(d.evidence.get("dim", "?"), []).append(d)
        for dim, ds in sorted(by_dim.items()):
            prods = sorted({d.prd_cd for d in ds if d.prd_cd})
            out.append(Fix(
                dimension=self.dimension, remediation_class="needs_authority",
                title=f"손님선택값 단가행 누락(연결 필요·{dim}) — 권위값 확보",
                defects=[d.key() for d in ds],
                worklist_note=(f"차원 '{dim}' 에서 손님이 고를 수 있는 값에 단가행이 없어 연결이 비어 있음 "
                               f"{len(ds)}건(상품 {len(prods)}개). 단가는 권위 엑셀/실무진에서 확인 후 §7 적재 "
                               f"(값 날조 금지). 상품: {', '.join(prods[:12])}{' …' if len(prods) > 12 else ''}"),
            ))

        # ── E2R 빈배선(placeholder) → blocked_human · 고아/빈공식 → review ──
        e2r = [d for d in mine if edge(d) == "E2R"]
        placeholder = [d for d in e2r if "빈 배선" in d.summary or "확인필요" in (d.evidence.get("prd_nm", "") + d.summary)]
        # placeholder(PENDING/TBD) 는 단가·구성 입력 대기
        ph = [d for d in e2r if d.comp_cd and ("PENDING" in d.comp_cd or "TBD" in d.comp_cd)]
        rest2r = [d for d in e2r if d not in ph]
        if ph:
            comps = sorted({d.comp_cd for d in ph})
            out.append(Fix(
                dimension=self.dimension, remediation_class="blocked_human",
                title="placeholder 구성요소 단가·구성 입력 대기(빈 배선)",
                defects=[d.key() for d in ph], root_comps=comps,
                worklist_note=(f"placeholder 구성요소 {len(comps)}개가 공식에 배선됐으나 단가행 0 → 계산 불가. "
                               f"실무진이 실제 단가·구성 입력 필요(§18→§7). 배선 제거·단가 날조 금지. "
                               f"comp: {', '.join(comps)}"),
            ))
        if rest2r:
            out.append(Fix(
                dimension=self.dimension, remediation_class="review",
                title="구성요소↔공식 역방향 단절 검토(고아·빈공식)",
                defects=[d.key() for d in rest2r],
                worklist_note=(f"{len(rest2r)}건: 구성요소가 어떤 공식에도 안 붙었거나(고아), 공식이 구성요소 0개(빈 공식). "
                               f"정당 미사용인지, 어느 공식/구성요소에 재연결할지 실무진 판단(값 날조 없음·배선만)."),
            ))

        # ── E1 상품↔공식 단절/청소 → review ──
        e1 = [d for d in mine if edge(d) in ("E1F", "E1R")]
        if e1:
            hi = [d for d in e1 if d.severity in ("critical", "high")]
            lo = [d for d in e1 if d.severity not in ("critical", "high")]
            if hi:
                prods = sorted({d.prd_cd for d in hi if d.prd_cd})
                out.append(Fix(
                    dimension=self.dimension, remediation_class="review",
                    title="상품↔공식 단절(없는/비활성 공식 참조) — 재연결 판단",
                    defects=[d.key() for d in hi],
                    worklist_note=(f"{len(hi)}건: 상품이 없는/비활성 공식을 참조 → 계산 불가. "
                                   f"올바른 공식으로 재연결 또는 공식 재활성(실무진). 상품: {', '.join(prods[:12])}"),
                ))
            if lo:
                out.append(Fix(
                    dimension=self.dimension, remediation_class="review",
                    title="상품↔공식 청소·미사용 공식 검토(advisory)",
                    defects=[d.key() for d in lo],
                    worklist_note=(f"{len(lo)}건: 비활성 상품에 남은 배선(청소) 또는 어떤 상품에도 안 붙은 공식"
                                   f"(미사용/재연결 대상). 정리 여부 실무진 판단."),
                ))
        return out
