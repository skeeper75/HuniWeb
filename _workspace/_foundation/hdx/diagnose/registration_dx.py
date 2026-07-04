"""RegistrationDx — 유료옵션 등록 도달성 진단. `board/registration_check.py` **어댑터**(재구현 0).

★목적(지니 260704·260705): 실무진 권위 엑셀(상품마스터 260703)을 '의도'로, 라이브 DB 를 '실제
등록'으로 보고 **상품별 유료 추가옵션이 DB에 등록·가격연결됐나** 대조. 내부 정합만으론 못 잡는
저청구 갭(예: 키링류 고리 0원)을 엑셀 대조로 포착.

승계(search-before-mint·[HARD] 원 로직 verbatim):
  · 스탠드얼론 `registration_check.check()` 를 그대로 호출(파서·3경로 도달성·addon 판정 verbatim).
  · 조인키 = 인라인 nm2cd → `board/prd_nm_bridge.csv`(스텝1b·신뢰도 등급)로 교체(check 내부).
  · 시트 = 전 상품시트(인라인 유료 5 + 형식가격 6). 형식가격 격자값=§26 축B(PriceGridDx) 소관.

산출 리스트(레코드) → 공통 Defect 로 변환만.
  HIGH(가격경로 끊김·addon 삭제)  → severity=high · undercharge(키링류 저청구 강신호)
  REVIEW(옵션·addon 모두 없음)    → severity=low · unknown(이름차이 오탐·별도상품 가능)
  NEEDS_HUMAN(브리지 AMBIGUOUS/UNMATCHED) → severity=low · needs_human=True(자동 결론 금지)
stop = HIGH 0(기존 registration 신뢰도 규약과 동일).

[HARD] 스냅샷 읽기전용·엑셀=권위(날조 0)·후보 보드(자동결론 아님). 교정 생성은 P3(RegistrationRmd).
주의: registration_check 는 자체 SNAP=live-snapshot/latest 사용(--snap 미반영). 배치 미가용 시 graceful.
"""
from __future__ import annotations
import sys
import pathlib

from .base import Diagnoser
from ..foundation import Snapshot, Defect

# 스탠드얼론 등록 점검표 재사용(board 패키지)
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[1] / "board"))
import registration_check as rc  # noqa: E402


class RegistrationDx(Diagnoser):
    dimension = "registration"
    title = "유료옵션 등록 도달성(권위 엑셀↔DB·브리지 조인)"

    def scan(self, snap: Snapshot) -> list[Defect]:
        try:
            recs = rc.check()                 # 브리지 조인 + 전 상품시트(결정론·엑셀=권위)
        except Exception as e:                # 엑셀 부재·시트명 변경 등 → graceful
            return [Defect(dimension=self.dimension, severity="low", money_impact="unknown",
                           summary=f"등록 점검표 배치 미가용(graceful): {type(e).__name__}",
                           evidence={"error": str(e)[:160]},
                           suggested_fix="권위 엑셀(상품마스터 260703)·prd_nm 브리지·시트명 config 확인")]

        out: list[Defect] = []
        for rec in recs:
            nm = rec["prd_nm"]
            gaps = rec.get("gaps", [])
            gapstr = " | ".join(gaps)

            # (A) 조인 불확실(브리지 AMBIGUOUS/UNMATCHED) → 자동 결론 금지·advisory
            if rec.get("needs_human"):
                out.append(Defect(
                    dimension=self.dimension, severity="low", money_impact="unknown",
                    prd_cd=rec.get("prd_cd"),
                    summary=f"[조인 불확실·{rec.get('tier')}] '{nm}' 유료옵션 등록 도달성 진단 보류(prd_cd 확정 필요)",
                    evidence={"sheet": rec.get("sheet"), "tier": rec.get("tier"),
                              "needs_human": True, "gaps": gapstr[:200]},
                    suggested_fix="prd_nm→prd_cd 브리지 확정(스텝1b·엑셀=권위) 후 재진단 — 자동 결론 금지",
                    authority_ref=f"상품마스터260703:{rec.get('sheet')}"))
                continue

            # (B) EXACT 조인 → 도달성 판정. HIGH=끊김/addon삭제, REVIEW=그 외
            high = rc.conf(gapstr) == "HIGH"
            out.append(Defect(
                dimension=self.dimension,
                severity="high" if high else "low",
                money_impact="undercharge" if high else "unknown",
                prd_cd=rec.get("prd_cd"),
                summary=f"유료옵션 {'저청구(가격경로 끊김)' if high else '미등록/검토'}: '{nm}' — {gapstr[:150]}",
                evidence={"sheet": rec.get("sheet"), "tier": rec.get("tier"), "gaps": gapstr[:260]},
                suggested_fix=("권위 엑셀 유료옵션을 DB 옵션 단가행/addon 템플릿에 연결(값=권위·날조 금지·"
                               "webadmin 실화면 확인)" if high else
                               "DB 옵션·addon 모두 없음 — 진짜 미연결/이름차이/별도상품 수동 확정"),
                authority_ref=f"상품마스터260703:{rec.get('sheet')}"))
        return out

    def stop_predicate(self, defects: list[Defect]) -> bool:
        # HIGH(가격경로 끊김=키링류 저청구)만 blocking. REVIEW·needs_human 은 advisory.
        return not any(d.dimension == self.dimension and d.severity == "high"
                       for d in defects)
