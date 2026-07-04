# -*- coding: utf-8 -*-
"""스텝1b — prd_nm→prd_cd 브리지 신뢰도 맵 빌더.

★목적: 권위 엑셀(상품마스터 260702, prd_nm) ↔ 라이브 DB(prd_cd) 조인 다리를 신뢰도 등급으로
만들고, 저신뢰·미상 케이스를 인간 게이트로 분리한다. 잘못된 매칭 = 엉뚱한 상품에 엉뚱한 가격 =
no-match 보다 나쁨. 매칭은 가설이지 사실이 아니다.

[HARD] 엑셀 prd_nm=절대 권위. 라이브/이전사이트/레드는 "이 상품이 무엇인지" 아는 다리(보강 근거)일 뿐,
정답 원천이 아니다(CLAUDE.md ⑦). LLM 추측을 확정으로 승격 금지 → DOMAIN_INFERRED/AMBIGUOUS/
UNMATCHED 는 전부 needs_human=TRUE. 근거 없는 매칭 금지(모든 추론 매칭에 evidence 문자열 필수).

재사용 자산(search-before-mint, 재구현 금지):
  · registration_check.py db_state() nm2cd — 라이브 prd_nm→prd_cd 역맵(EXACT 판정 근거).
  · 35_category-map/matching.csv (norm→live_prd_cd 252건) — 카테고리맵 상품 매칭 harvest(보강 근거).
  · l1 CSV 의 MES ITEM_CD — 라이브 t_prd_products.MES_ITEM_CD 와 대조(보강 근거, 라이브 16건만 채워짐).

라이브 읽기전용 스냅샷 CSV 만 읽음(DB 쓰기 없음).
재실행: python3 _workspace/_foundation/hdx/board/build_prd_nm_bridge.py
"""
from __future__ import annotations
import csv, re, pathlib
from collections import defaultdict

ROOT = pathlib.Path("/Users/innojini/Dev/HuniWeb")
SNAP = ROOT / "_workspace/_foundation/live-snapshot/latest/t_prd_products.csv"
MASTER = ROOT / "_workspace/huni-dbmap/24_master-extract-260702"
MATCHING = ROOT / "_workspace/huni-dbmap/35_category-map/matching.csv"
OUT_CSV = ROOT / "_workspace/_foundation/hdx/board/prd_nm_bridge.csv"
OUT_MD = ROOT / "_workspace/_foundation/hdx/board/prd_nm_bridge-summary.md"

# 권위 상품시트(11) — map-l1 은 카테고리 구성맵이라 상품 권위 아님(matching.csv 로만 harvest).
SHEETS = ["acrylic", "booklet", "calendar", "design-calendar", "digital-print",
          "goods-pouch", "photobook", "product-accessory", "silsa", "stationery", "sticker"]


def norm(s: str) -> str:
    """공백 제거 정규화(공백차만 EXACT 로 흡수). 괄호/토큰은 보존(의미 있음)."""
    return re.sub(r"\s+", "", (s or "").strip())


def core(s: str) -> str:
    """후보 탐색용 코어 — 장식 접미사(★·(보류중)·(가격포함) 등)와 공백 제거.
    권위 prd_nm 자체는 보존; 후보 부분포함 매칭에만 사용(장식 때문에 후보 놓치지 않게)."""
    c = re.sub(r"[\(（].*?[\)）]", "", s or "")     # 괄호 주석 제거
    c = re.sub(r"[★☆*\s]+", "", c)                 # 장식/공백 제거
    return c.strip()


def is_nonproduct(nm: str) -> bool:
    """상품명 칸에 흘러든 비상품 행(레전드 노트·가이드 URL·품절안내 문단) 판별 → 브리지 제외."""
    n = (nm or "").strip()
    if not n:
        return True
    if n.startswith("http") or "redprinting.co.kr" in n:
        return True
    if "노랑색배경" in n or "그레이배경" in n or "Figma" in n:  # 저자 레전드 문단
        return True
    if len(n) > 40:  # 정상 상품명은 40자 이하 — 그 이상은 문단/노트 아티팩트
        return True
    return False


def load_live():
    live = list(csv.DictReader(open(SNAP, encoding="utf-8")))
    by_nm = defaultdict(list)     # prd_nm -> [prd_cd]  (라이브는 실측상 유니크)
    by_norm = defaultdict(list)   # norm(prd_nm) -> [(prd_cd, prd_nm)]
    by_mes = {}                   # MES_ITEM_CD -> (prd_cd, prd_nm)
    meta = {}                     # prd_cd -> row
    for x in live:
        by_nm[x["prd_nm"]].append(x["prd_cd"])
        by_norm[norm(x["prd_nm"])].append((x["prd_cd"], x["prd_nm"]))
        if x.get("MES_ITEM_CD"):
            by_mes[x["MES_ITEM_CD"]] = (x["prd_cd"], x["prd_nm"])
        meta[x["prd_cd"]] = x
    return by_nm, by_norm, by_mes, meta


def load_harvest():
    """matching.csv → norm 상품명 -> {live_prd_cd} (기존 확립 매핑 수확·보강근거)."""
    h = defaultdict(set)
    if not MATCHING.exists():
        return h
    for x in csv.DictReader(open(MATCHING, encoding="utf-8-sig")):
        cd = (x.get("live_prd_cd") or "").strip()
        nm = (x.get("norm") or "").strip()
        if cd and nm and (x.get("type") == "product"):
            h[nm].add(cd)
    return h


def load_authority():
    """11 상품시트 → [(sheet, prd_nm, mes)] distinct. 비상품 노트행 제외."""
    prods, excluded = [], []
    for sh in SHEETS:
        rows = list(csv.DictReader(open(MASTER / f"{sh}-l1.csv", encoding="utf-8-sig")))
        seen = {}
        for x in rows:
            nm = (x.get("prd_nm") or "").strip()
            if not nm or nm in seen:
                continue
            mes = (x.get("MES ITEM_CD") or "").strip()
            if mes and len(mes) > 12:  # MES 칸에 레전드 문단이 흘러든 경우 무효화
                mes = ""
            seen[nm] = mes
        for nm, mes in seen.items():
            if is_nonproduct(nm):
                excluded.append((sh, nm))
            else:
                prods.append((sh, nm, mes))
    return prods, excluded


def build():
    by_nm, by_norm, by_mes, meta = load_live()
    harvest = load_harvest()
    prods, excluded = load_authority()

    # N:1 탐지 — 동일 prd_nm 이 여러 (sheet) 권위행에 존재하면 하나의 prd_cd 로 수렴.
    name_sheets = defaultdict(list)
    for sh, nm, mes in prods:
        name_sheets[nm].append(sh)
    multi_sheet = {nm for nm, shs in name_sheets.items() if len(shs) > 1}

    rows = []
    for sh, nm, mes in sorted(prods):
        cand, evid, tier, card, need = [], [], None, "", True

        exact = by_nm.get(nm)                    # 정확 문자열 일치
        normhit = by_norm.get(norm(nm))          # 공백차만 다른 일치
        meshit = by_mes.get(mes) if mes else None
        harv = harvest.get(norm(nm))

        if exact:                                # ── EXACT ─────────────────────────
            cand = exact
            evid.append(f"prd_nm 문자열 정확 일치(라이브 {exact[0]})")
            if meshit and meshit[0] in exact:
                evid.append(f"MES {mes} 라이브 일치(보강)")
            if harv and set(exact) & harv:
                evid.append("matching.csv 확립 매핑 일치(보강)")
            if nm in multi_sheet:                # 동일 이름 다중시트 → N:1
                tier, card = "AMBIGUOUS", "N:1"
                evid.append(f"동일 prd_nm 이 {sorted(name_sheets[nm])} {len(name_sheets[nm])}시트 → "
                            "라이브 단일 prd_cd 수렴(일반/디자인 변형 별도 등록 여부 인간 확인)")
                need = True
            elif len(exact) > 1:                 # 라이브 다중(실측상 없음이나 방어)
                tier, card, need = "AMBIGUOUS", "1:N", True
            else:
                tier, card, need = "EXACT", "1:1", False
                lc = meta.get(exact[0], {})      # 생애주기 주석 — 매칭 대상이 삭제 상태면 인간 확인.
                if lc.get("del_yn") == "Y":
                    evid.append("⚠ 라이브 del_yn=Y(논리삭제) — 매칭 대상이 삭제 상태, 재확인 권장")
                    need = True
                elif lc.get("use_yn") == "N":
                    evid.append("라이브 use_yn=N(미노출·비활성)")

        elif normhit:                            # ── EXACT(정규화) ─────────────────
            cand = [c for c, _ in normhit]
            evid.append(f"prd_nm 공백차만 다른 일치(라이브 {normhit[0][0]} '{normhit[0][1]}')")
            if nm in multi_sheet:
                tier, card, need = "AMBIGUOUS", "N:1", True
            elif len(cand) > 1:
                tier, card, need = "AMBIGUOUS", "1:N", True
            else:
                tier, card, need = "EXACT", "1:1", False

        else:
            # ── 문자열 불일치 → 도메인/보강 근거로 후보 탐색 ─────────────────────
            if meshit:
                cand = [meshit[0]]
                evid.append(f"MES {mes} 라이브 일치 → '{meshit[1]}'({meshit[0]})")
            if harv:
                cand = list(set(cand) | harv)
                evid.append(f"matching.csv harvest 후보 {sorted(harv)}")
            # 도메인 키워드 후보(코어 부분포함) — 근거로만, 확정 금지(★·괄호 접미사 제거 후 비교).
            ck = core(nm)
            kwc = [(cd, r["prd_nm"]) for cd, r in meta.items()
                   if len(ck) >= 2 and (ck in core(r["prd_nm"]) or core(r["prd_nm"]) in ck)]
            if kwc:
                for cd, lnm in kwc:
                    if cd not in cand:
                        cand.append(cd)
                evid.append(f"도메인 코어 '{ck}' 부분포함 후보: "
                            + "; ".join(f"{c}='{n}'" for c, n in kwc))

            if not cand:
                tier, card, need = "UNMATCHED", "0:0", True
                evid.append("라이브 후보 없음 — rename·신규·단종 의심")
                if not mes:
                    evid.append("MES 미등재(신규 상품 강신호)")
            elif len(cand) == 1:
                tier, card, need = "DOMAIN_INFERRED", "1:1(추정)", True
            else:
                tier, card, need = "AMBIGUOUS", "1:N", True

        matched_nm = "; ".join(meta[c]["prd_nm"] for c in cand if c in meta)
        rows.append(dict(
            excel_sheet=sh, excel_prd_nm=nm,
            matched_prd_cd="; ".join(cand), matched_prd_nm=matched_nm,
            tier=tier, cardinality=card,
            evidence=" | ".join(evid), needs_human=("TRUE" if need else "FALSE"),
        ))
    return rows, excluded, name_sheets


def main():
    rows, excluded, name_sheets = build()
    cols = ["excel_sheet", "excel_prd_nm", "matched_prd_cd", "matched_prd_nm",
            "tier", "cardinality", "evidence", "needs_human"]
    with open(OUT_CSV, "w", encoding="utf-8", newline="") as f:
        w = csv.DictWriter(f, fieldnames=cols)
        w.writeheader()
        w.writerows(rows)

    from collections import Counter
    tc = Counter(r["tier"] for r in rows)
    total = len(rows)
    need = sum(1 for r in rows if r["needs_human"] == "TRUE")
    ex = tc.get("EXACT", 0)

    def block(t):
        return [r for r in rows if r["tier"] == t]

    lines = []
    lines.append("# prd_nm→prd_cd 브리지 신뢰도 맵 — 요약 (스텝1b)\n")
    lines.append("> 권위 엑셀(상품마스터 260702, prd_nm) ↔ 라이브 DB(prd_cd) 조인 다리. "
                 "매칭=가설(사실 아님). 잘못된 매칭=엉뚱한 상품에 엉뚱한 가격=no-match보다 나쁨.\n")
    ex_auto = sum(1 for r in rows if r["tier"] == "EXACT" and r["needs_human"] == "FALSE")
    ex_flag = ex - ex_auto
    lines.append(f"- **권위 상품 총계**: {total}건 (11 상품시트 distinct prd_nm; 비상품 노트행 {len(excluded)}건 제외)")
    lines.append(f"- **EXACT**: {ex}건 ({ex*100//total}%) — {ex_auto}건 자동 확정(needs_human=FALSE)"
                 + (f", {ex_flag}건 생애주기 재확인(라이브 del_yn=Y)" if ex_flag else ""))
    lines.append(f"- **DOMAIN_INFERRED**: {tc.get('DOMAIN_INFERRED',0)}건 — 인간 확인 대기")
    lines.append(f"- **AMBIGUOUS**: {tc.get('AMBIGUOUS',0)}건 — 인간 확인 대기")
    lines.append(f"- **UNMATCHED**: {tc.get('UNMATCHED',0)}건 — 인간 확인 대기")
    lines.append(f"- **인간 확인 필요(needs_human=TRUE) 합계**: {need}건\n")

    lines.append("## 재사용한 기존 자산 (search-before-mint)")
    lines.append("- `registration_check.py` db_state() `nm2cd` — 라이브 prd_nm→prd_cd 역맵(EXACT 판정 근거).")
    lines.append("- `35_category-map/matching.csv` (type=product, norm→live_prd_cd 252건) — 카테고리맵 상품 매칭 harvest(EXACT 보강·불일치건 후보).")
    lines.append("- `24_master-extract-260702/*-l1.csv` `MES ITEM_CD` ↔ 라이브 `t_prd_products.MES_ITEM_CD`(16건) — 보강 근거.")
    lines.append("- 라이브 스냅샷 `live-snapshot/latest/t_prd_products.csv`(300 상품, prd_nm 전량 유니크) — 대상.\n")

    for t, label in [("DOMAIN_INFERRED", "DOMAIN_INFERRED (문자열 불일치·단일 후보 추론)"),
                     ("AMBIGUOUS", "AMBIGUOUS (N:1·1:N·후보 복수)"),
                     ("UNMATCHED", "UNMATCHED (후보 없음·신규/단종 의심)")]:
        b = block(t)
        lines.append(f"## {label} — {len(b)}건")
        for r in sorted(b, key=lambda z: (z["excel_sheet"], z["excel_prd_nm"])):
            tgt = f"→ {r['matched_prd_cd']} '{r['matched_prd_nm']}'" if r["matched_prd_cd"] else "→ (후보 없음)"
            lines.append(f"- [{r['excel_sheet']}] **{r['excel_prd_nm']}** {tgt} · card={r['cardinality']}")
            lines.append(f"    - 근거: {r['evidence']}")
        lines.append("")

    lines.append("## 제외된 비상품 노트행 (파싱 아티팩트)")
    for sh, nm in excluded:
        disp = nm if len(nm) <= 50 else nm[:50] + "…"
        lines.append(f"- [{sh}] `{disp}`")
    lines.append("")
    lines.append("## [HARD] 게이트 규칙")
    lines.append("- EXACT(needs_human=FALSE)만 자동 조인 확정. 나머지 3등급은 전부 인간 확정 전까지 가설.")
    lines.append("- 엑셀 prd_nm=절대 권위. 라이브/이전사이트/레드는 다리(보강 근거)일 뿐 엑셀을 덮어쓰지 않음.")
    lines.append("- 근거 없는 매칭 금지 — 모든 추론 매칭에 evidence 문자열 첨부.")

    OUT_MD.write_text("\n".join(lines), encoding="utf-8")

    print("=" * 74)
    print("prd_nm→prd_cd 브리지 신뢰도 맵 (스텝1b)")
    print("=" * 74)
    print(f"권위 상품 {total}건 | EXACT {ex}({ex*100//total}%) | "
          f"DOMAIN_INFERRED {tc.get('DOMAIN_INFERRED',0)} | AMBIGUOUS {tc.get('AMBIGUOUS',0)} | "
          f"UNMATCHED {tc.get('UNMATCHED',0)}")
    print(f"인간 확인 필요(needs_human=TRUE) = {need}건 | 비상품 노트행 제외 = {len(excluded)}건")
    print(f"CSV → {OUT_CSV}")
    print(f"MD  → {OUT_MD}")


if __name__ == "__main__":
    main()
