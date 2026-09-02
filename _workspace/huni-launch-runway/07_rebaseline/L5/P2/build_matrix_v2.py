#!/usr/bin/env python3
"""scenario-matrix v1(48행) -> v2(51행). 실행일 열 신설 + 송장 변경 3건 추가.
재실행: python3 build_matrix_v2.py"""
import csv, pathlib, collections

SRC = pathlib.Path("../O1/scenario-matrix.csv")
DST = pathlib.Path("scenario-matrix-v2.csv")

rows = list(csv.DictReader(SRC.open(encoding="utf-8")))
assert len(rows) == 48, f"v1 은 48행이어야 한다 (실제 {len(rows)})"

# 신규 3건 — O1 test-scenarios.md §6.1 「진짜 갭 12 중 실무 위험 3칸」 = 송장 변경
GEUN = ("_workspace/huni-launch-runway/07_rebaseline/L0/N1/shopby-order-state-machine.md"
        " §3-1 주석6 · order-server-public.yml:1434(송장번호 변경) · :1617-1624")
NEW = [
    dict(scn_id="P1-16", 등급="P1", 게이트="G4", 단계="13 배송·주문조회",
         전제="배송중(DELIVERY_ING) 상태의 주문 1건. 송장번호가 이미 등록돼 있다",
         조작="잘못 등록된 송장번호를 다른 번호로 바꾼다 (셀러어드민 송장 변경 또는 송장번호 변경 API)",
         기대결과="변경 요청이 200 으로 받아들여지고, 주문 상세의 송장번호가 새 번호로 보인다. 주문상태는 배송중 그대로다 (DELIVERY_ING 유지)",
         확인처="셀러어드민 주문 상세 송장 칸 + 응답 코드",
         PG승인전가능="N", 근거=GEUN,
         미확인분기="변경 후 고객에게 배송추적 알림이 다시 나가는가 — 미확인(알림 항목 목록 A-7 미관측)",
         실행일="2026-10-02"),
    dict(scn_id="P1-17", 등급="P1", 게이트="G4", 단계="13 배송·주문조회",
         전제="배송완료(DELIVERY_DONE) 상태의 주문 1건. 송장번호가 이미 등록돼 있다",
         조작="송장번호를 다른 번호로 바꾼다",
         기대결과="변경 요청이 200 으로 받아들여지고 새 번호가 보인다. 주문상태는 배송완료 그대로다. 수령자 정보 칸은 잠긴 채(변경 불가) 유지된다",
         확인처="셀러어드민 주문 상세 송장 칸·수령자 정보 칸 + 응답 코드",
         PG승인전가능="N", 근거=GEUN + " · 주석8(송장 입력 후 수령자 정보 잠김)",
         미확인분기="에스크로 결제 주문이면 배송완료 이후 전이가 전면 봉인된다 — 송장 변경도 봉인 대상인지 미확인(state-machine §2-4)",
         실행일="2026-10-02"),
    dict(scn_id="P1-18", 등급="P1", 게이트="G4", 단계="13 배송·주문조회",
         전제="구매확정(BUY_CONFIRM) 상태의 주문 1건. 송장번호가 이미 등록돼 있다",
         조작="송장번호를 다른 번호로 바꾼다",
         기대결과="변경 요청이 200 으로 받아들여지고 새 번호가 보인다. 구매확정 상태는 바뀌지 않는다",
         확인처="셀러어드민 주문 상세 송장 칸 + 응답 코드",
         PG승인전가능="N", 근거=GEUN,
         미확인분기="구매확정 이후 송장 변경이 정산 집계에 영향을 주는가 — 미확인(B 문의서 8·9번 회신 대기)",
         실행일="2026-10-02"),
]

# 실행일 배정 규칙 (결정론)
#  G2 -> 2026-09-18 (게이트일) · G3 -> 2026-09-22 (게이트일)
#  G4 -> 9/30 리허설(P0 전건) · 10/01 교정창1(P1 주문성립·결제·생산지시) · 10/02 교정창2(P1 배송·주문조회)
G4_1001_STEPS = {"7 주문 성립(shopby)", "6 결제(PG)", "10 생산지시"}
def assign_date(r):
    g = r["게이트"]
    if g == "G2":
        return "2026-09-18"
    if g == "G3":
        return "2026-09-22"
    if g == "G4":
        if r["등급"] == "P0":
            return "2026-09-30"
        return "2026-10-01" if r["단계"] in G4_1001_STEPS else "2026-10-02"
    raise SystemExit(f"알 수 없는 게이트: {g} ({r['scn_id']})")

for r in rows:
    r["실행일"] = assign_date(r)
rows.extend(NEW)

fields = list(csv.DictReader(SRC.open(encoding="utf-8")).fieldnames) + ["실행일"]
with DST.open("w", encoding="utf-8", newline="") as f:
    w = csv.DictWriter(f, fieldnames=fields)
    w.writeheader()
    w.writerows(rows)

# ---- 기계 검산 ----
steps_p0 = {r["단계"] for r in rows if r["등급"] == "P0"}
g4 = [r for r in rows if r["게이트"] == "G4"]
print(f"행 수            : {len(rows)}  (v1 48 + 신규 3)")
print(f"scn_id 유니크    : {len({r['scn_id'] for r in rows})}")
print(f"P0 단계 유니크   : {len(steps_p0)}  (13 이어야 함)")
print(f"등급별           : {dict(collections.Counter(r['등급'] for r in rows))}")
print(f"게이트별         : {dict(collections.Counter(r['게이트'] for r in rows))}")
print(f"실행일 빈칸      : {sum(1 for r in rows if not r['실행일'])}")
print(f"G4 실행일 빈칸   : {sum(1 for r in g4 if not r['실행일'])}")
print(f"G4 날짜별        : {dict(collections.Counter(r['실행일'] for r in g4))}")
print(f"기대결과 빈칸    : {sum(1 for r in rows if not r['기대결과'].strip())}")
print(f"「정상 동작」 표현: {sum(1 for r in rows if '정상 동작' in r['기대결과'])}")
print(f"v1 scn_id 유실   : {len({r['scn_id'] for r in csv.DictReader(SRC.open(encoding='utf-8'))} - {r['scn_id'] for r in rows})}")
