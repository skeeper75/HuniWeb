#!/usr/bin/env python3
"""webadmin 몫과 widget 몫이 같은 urls.py 라우트를 이중 계상한 16건을 한쪽으로 귀속시킨다.

귀속 근거는 t49 카드의 명시 지시(「위젯↔webadmin 가격 API·Edicus 브리지는 integrate 행으로 분리」)와
호출 주체다. 라우트가 webadmin 코드에 산다는 사실만으로는 귀속이 정해지지 않는다 —
`api/w/v1/*` 는 전부 webadmin 코드이지만 상대는 위젯일 수도 쇼핑몰 서버일 수도 있기 때문이다.
"""
import csv
import re
import sys

# urls.py 라인 -> 남길 쪽
OWNER = {
    242: "widget",    # sdk/guide — 위젯 SDK 공개 가이드
    243: "widget",    # sdk/demo — 게시 위젯 실임베드 데모
    246: "widget",    # sdk/cart-guide — 위젯 장바구니 연동 가이드
    251: "widget",    # upload/presign — 위젯 런타임 원고 업로드
    254: "widget",    # upload/multipart — 같은 업로드 경로
    275: "widget",    # editor/resolve — 카드가 지정한 Edicus 브리지
    276: "widget",    # editor/token — 같은 브리지
    262: "webadmin",  # cart/items — 호출 주체가 쇼핑몰 서버(X-Huni-Server-Key)
    263: "webadmin",  # cart/items/fetch — 동일
    265: "webadmin",  # cart/items/<id> — 동일
    278: "webadmin",  # swatch — 자사몰 웹서버용 서빙
    281: "webadmin",  # guides — 동일
    284: "webadmin",  # main-image — 동일
    286: "webadmin",  # main-images — 동일
    288: "webadmin",  # designs — 동일
    290: "webadmin",  # design-image — 동일
    399: "webadmin",  # admin/widget-manual — webadmin 문서 메뉴의 화면
}
PARTS = {"webadmin": "_part-webadmin.csv", "widget": "_part-widget.csv"}
ROUTE = re.compile(r"config/urls\.py:(\d+)")


def lines(row: dict) -> set[int]:
    return {int(m.group(1)) for m in ROUTE.finditer(row.get("evidence", ""))}


dropped_total = 0
for system, path in PARTS.items():
    with open(path, newline="", encoding="utf-8") as fh:
        reader = csv.DictReader(fh)
        header = reader.fieldnames
        rows = list(reader)

    keep, dropped = [], []
    for row in rows:
        # 이 행이 참조하는 라우트 중 '다른 시스템 소유'로 정해진 것이 있으면 뺀다.
        foreign = {ln for ln in lines(row) if OWNER.get(ln) not in (None, system)}
        (dropped if foreign else keep).append(row)

    with open(path, "w", newline="", encoding="utf-8") as fh:
        writer = csv.DictWriter(fh, fieldnames=header)
        writer.writeheader()
        writer.writerows(keep)

    dropped_total += len(dropped)
    print(f"{path}: {len(rows)} -> {len(keep)} (뺀 행 {len(dropped)})")
    for row in dropped:
        print(f"    - {row['screen_id']} | {row['function'][:60]}")

print(f"\n이중 계상 해소 합계 {dropped_total}행")
sys.exit(0)
