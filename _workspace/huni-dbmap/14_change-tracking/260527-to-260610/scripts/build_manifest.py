#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Phase 3+4 — 셀→t_* 영향 매핑 + 라이브 정합 분류 + 변경 매니페스트/델타 조립.

[입력] diff/_diff-raw.json (diff_versions.py 산출)
[라이브 정합] 별도 수집한 live_reconcile.json (read-only psql 결과, 비밀값 비포함)
[산출]
  - impact/<entity>-impact.csv
  - change-manifest.csv / change-manifest.md
  - _delta/*.sql, apply.sql (auto-UPSERT 0건이면 escalation-only)
  - code-row-preload.md / logical-delete-and-gaps.md

[apply_class 규칙 — dbm-change-tracking V4/V5]
  - 사이즈(필수)<->상품(옵션) 컬럼 마이그레이션: 차원행(size)을 CPQ 옵션레이어로
    재분류. 라이브 옵션레이어 미적재(items 18건=silsa만) -> ESCALATE
    (dbm-cpq-option-mapping L2 설계 필요. 기계적 size 삭제 금지 = 적재된
    size/price 사슬 파손 위험. schema-design-intent-first.)
  - 커팅(옵션) 클리어: 합판도무송스티커 커팅옵션 텍스트 제거. 라이브는 커팅을
    size로 적재(정사각NxN(EA)), 커팅 옵션그룹 없음 -> ESCALATE(옵션레이어).
  - block_resized(아크릴미니파츠 -16행)의 LOW 셀: tail-shift 유령 가능 ->
    ESCALATE(변형행 감축, 사람 판단. 라이브 size 1행뿐).
  - 실사 footnote 텍스트 추가: t_* 상품속성 아닌 범례/주석 -> GAP(no target)/NO_OP.

비밀값 비취급. DB 무변경.
"""
import json
import os
import csv

ROOT = "_workspace/huni-dbmap/14_change-tracking/260527-to-260610"

# 라이브 정합 실측(읽기전용 psql, 본 세션 수집). prd_nm -> {prd_cd, size_rows, opt_items}
LIVE = {
    "클립보드": {"prd_cd": "PRD_000215", "size_rows": 2},
    "투명클립보드": {"prd_cd": "PRD_000216", "size_rows": None},
    "만년스탬프": {"prd_cd": "PRD_000217", "size_rows": 7},
    "레더라벨제작": {"prd_cd": "PRD_000280", "size_rows": 3,
                "live_sizes": ["레더15x30", "레더20x40", "레더30x50"]},
    "레더스트랩키링": {"prd_cd": "PRD_000201", "size_rows": 0},
    "합판도무송스티커": {"prd_cd": "PRD_000066", "size_rows": 37},
    "미니배너": {"prd_cd": "PRD_000145"},
    "아크릴미니파츠": {"prd_cd": "PRD_000163", "size_rows": 1},
}
# 전역 CPQ 옵션레이어 실측(거의 미적재): groups5 options16 items18 (전부 silsa)
CPQ_GLOBAL = {"groups": 5, "options": 16, "items": 18, "products_with_groups": 3}


def classify(sheet, col, conf, block_resized_keys, key):
    """(target_entity, target_column, apply_class, note) 반환."""
    # 굿즈파우치 size<->option 컬럼 마이그레이션
    if sheet.startswith("굿즈파우치") and col in ("사이즈(필수)", "상품(옵션)"):
        return ("t_prd_product_option_groups/options/option_items",
                "(차원행 size -> CPQ 옵션레이어 재분류)", "ESCALATE",
                "size를 CPQ 옵션으로 재분류. 라이브 옵션레이어 미적재(items=18=silsa만). "
                "dbm-cpq-option-mapping L2 설계 필요. 기계적 size 삭제 금지(price/size 사슬 파손).")
    # 스티커 커팅 옵션 클리어
    if sheet == "스티커" and col == "커팅(옵션)":
        return ("t_prd_product_option_groups/options",
                "(커팅 옵션 텍스트 제거)", "ESCALATE",
                "합판도무송스티커 커팅옵션 텍스트 제거. 라이브는 커팅을 size로 적재"
                "(정사각NxN(EA)), 커팅 옵션그룹 없음. 옵션레이어 설계/논리 검토 필요.")
    # 아크릴 block_resized LOW 셀
    if sheet == "아크릴" and key in block_resized_keys:
        return ("t_prd_product_sizes (+ 변형행)",
                col, "ESCALATE",
                "아크릴미니파츠 변형행 -16(34->18). 위치정렬 LOW 신뢰(tail-shift 유령 가능). "
                "라이브 size 1행뿐. 변형행 감축은 사람 판단(논리삭제 후보).")
    # 실사 footnote
    if sheet == "실사" and col == "MES ITEM_CD":
        return ("(없음 — 범례/주석셀)", "", "GAP",
                "MES ITEM_CD 헤더영역 범례 텍스트 추가(가격표 참조 안내). 상품속성 아님 -> 적용 대상 없음.")
    # default: 미매핑 -> GAP
    return ("(미매핑)", col, "GAP", "영향 엔티티 미확정 -> 정직 GAP.")


def main():
    d = json.load(open(os.path.join(ROOT, "diff", "_diff-raw.json"), encoding="utf-8"))
    sheet_map = {r["sheet"]: r for r in d}
    block_resized_keys = set()
    for r in d:
        for br in r["block_resized"]:
            block_resized_keys.add(br["key"])

    manifest = []
    for r in d:
        sheet = r["sheet"]
        slug = sheet.replace("(가격포함)", "").replace("/", "-")
        for a in r["added"]:
            manifest.append(dict(sheet=sheet, key=a["key"], change_type="ADDED",
                                 column="(전체 상품)", before="", after="(신규 상품)",
                                 cell_ref=f"{slug}!{a['anchor_row']}", target_entity="t_prd_products(+종속)",
                                 target_column="", live_prd_cd="", apply_class="INSERT",
                                 confidence="HIGH", note="FK 위상정렬 신규 적재"))
        for rm in r["removed"]:
            manifest.append(dict(sheet=sheet, key=rm["key"], change_type="REMOVED",
                                 column="(전체 상품)", before="(상품 존재)", after="",
                                 cell_ref=f"{slug}!{rm['anchor_row']}", target_entity="t_prd_products",
                                 target_column="use_yn", live_prd_cd="", apply_class="LOGICAL_DELETE_PROPOSAL",
                                 confidence="HIGH", note="hard-delete 금지. use_yn='N' 제안+escalate."))
        for c in r["modified_cells"]:
            te, tc, ac, note = classify(sheet, c["col"], c["confidence"],
                                        block_resized_keys, c["key"])
            live = LIVE.get(c["prd_nm"], {})
            manifest.append(dict(
                sheet=sheet, key=c["key"], change_type="MODIFIED",
                column=c["col"], before=c["before"], after=c["after"],
                cell_ref=f"{slug}!N{c['new_cell']}" if c["new_cell"] else f"{slug}!B{c['base_cell']}",
                target_entity=te, target_column=tc,
                live_prd_cd=live.get("prd_cd", ""),
                apply_class=ac, confidence=c["confidence"],
                note=note + f" [prd_nm={c['prd_nm']} vidx{c['variant_idx']}]"))

    # ---- change-manifest.csv ----
    cols = ["sheet", "key", "change_type", "column", "before", "after", "cell_ref",
            "target_entity", "target_column", "live_prd_cd", "apply_class",
            "confidence", "note"]
    with open(os.path.join(ROOT, "change-manifest.csv"), "w", newline="", encoding="utf-8-sig") as f:
        w = csv.DictWriter(f, fieldnames=cols)
        w.writeheader()
        for m in manifest:
            w.writerow(m)

    # ---- impact/<entity>-impact.csv (그룹핑) ----
    os.makedirs(os.path.join(ROOT, "impact"), exist_ok=True)
    by_ent = {}
    for m in manifest:
        ent = m["target_entity"].split(" ")[0].split("/")[0] or "unmapped"
        ent = ent.replace("(미매핑)", "unmapped").replace("(없음", "annotation")
        safe = "".join(ch if (ch.isalnum() or ch == "_") else "-" for ch in ent)[:50] or "unmapped"
        by_ent.setdefault(safe, []).append(m)
    for safe, rows in by_ent.items():
        with open(os.path.join(ROOT, "impact", f"{safe}-impact.csv"), "w",
                  newline="", encoding="utf-8-sig") as f:
            w = csv.DictWriter(f, fieldnames=cols)
            w.writeheader()
            for m in rows:
                w.writerow(m)

    # ---- apply_class tally ----
    from collections import Counter
    tally = Counter(m["apply_class"] for m in manifest)
    print("manifest rows:", len(manifest))
    print("apply_class tally:", dict(tally))
    print("impact entities:", list(by_ent.keys()))
    return manifest, tally


if __name__ == "__main__":
    main()
