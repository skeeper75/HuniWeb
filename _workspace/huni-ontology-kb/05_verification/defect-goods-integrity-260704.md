# 결함 보드 — 굿즈/파우치/봉투 Phase 4 적대검증 · 축 2(그래프 무결성 + 연결 완전성 + O5 코드정렬 건전성)

> **검증자:** okb-adversarial-verifier (생성≠검증) · 2026-07-04
> **범위:** 굿즈/파우치/봉투 신규 103 상품 노드(147→250) + 공유 gap 7종 + O5 코드정렬(build_graph.py 2026-07-04 변경)
> **방법:** `python3 04_graph/build_graph.py` 재빌드 실측 · nodes/edges.jsonl 기계 대조 · live-snapshot awk 재실측 · 생성자 주장 비신뢰
> **판정: CONDITIONAL-GO** — 무결성 골격은 건전(하드 0·멱등·닫힌어휘·판형 0·index 등재·dead-link 0)하나, **O5 코드정렬 변경이 "가격 gap"과 "비가격 gap"을 구분하지 못해 고정가 실재 상품 6건이 비가격 gap으로 O5를 통과(부정직 green)** — 이 High 1건 교정 후 GO.

---

## 통과 확인(축 2 clean 항목·기계 실측)

| 검사 | 결과 | 증거 |
|------|------|------|
| 재빌드 하드 위반 | **hard=0** (soft=607) | `nodes=1359 edges=4287 hard=0` |
| 멱등(2회 빌드 해시 동일) | **PASS** | `nodes=74a7577e38bfd68b edges=c1813a039d3dbd55` 2회 동일 |
| member_of 엣지 | **0** (has_member만 사용·정상) | edges 17종 rel 중 member_of 부재 |
| 닫힌 어휘 19종 | **PASS** (사용 17 ⊂ 등재 19) | REL 레지스트리 19·미등재 rel 0 |
| 비종이 판형(has_plate_size) | **0** on 굿즈/파우치/봉투(001·002·005·050·183~283) | 도메인 [HARD] 준수·전체 74 has_plate_size 중 goods 0 |
| L-1 파일명↔id | **PASS**(하드 0) | 103 신규 파일명 = id |
| index 103 등재 | **PASS** — 굿즈/문구 primary product 파일 미등재 0 | O4 미등재는 전부 `-nodes.md` 번들(스티커/실사 축)·goods primary 0 |
| dead-link(O4b) | **0** | 링크 target 파일 실재 검사 |
| 신규 product 수 | **103**(147→250) | 빌드리포트 타입별 노드 수 |
| **L-20 신규 충돌** | **없음**(0703=0704=7) | 과업 우려 "cardenv L-20 충돌" **불발**(cardenv=degree-0 고아일 뿐 L-20 아님) |

---

## D-GD-INT-1 (High) — 고정가 실재 파우치/백 6건이 **비가격 gap으로 O5 통과**(부정직 green·연결 미완)

**현상:** 라이브 고정가 실재 상품 6건(248=12,500·263=31,000·265=16,500·266=24,000·272=58,000·275=25,000 — 전부 `t_prd_product_prices` verbatim 실재, awk 실측 확인)이:
- **gap-goods-fixed-lookup-no-formula(가격 gap)를 참조하지 않음** (`ref_gap=False`)
- O5(끊긴 **가격**사슬 게이트)를 **오직 비가격 gap으로 incidental 충족** — 참조 gap = gap-goods-sewing-missing(공정)·gap-goods-material-contamination(자재)·gap-pouch-empty-shell(BOM)뿐.

**모순 증거(생성자 자기 불일치):** builder 자신의 `gap-goods-fixed-lookup-no-formula.gap_what`이 "185·196·205·210·211·212·219·223·224·225·**248·263·265·266·272·275**"를 고정가룩업 클러스터로 **명시**. 이 중 SB-2 굿즈 10건(185~225)은 전부 해당 가격 gap을 참조(`ref_gap=True`)하나, **SB-3 파우치/백 6건(248/263/265/266/272/275)은 참조 누락** — 동일 아키타입을 두 배치가 다르게 배선(SB-3 pass 회귀).

**왜 결함인가(축 2 직격):**
1. **O5 부정직 green** = 과업이 경고한 "가격 실재 상품이 gap으로 O5 회피·부정직"의 정확한 발현. 263(31,000)의 가격사슬은 엣지 레벨에서 **미선언**인데(priced_by 0·가격 gap 참조 0), O5는 sewing/material gap 덕에 GREEN 보고.
2. **엣지-레벨 연결 미완** = 블라인드 NL 질의(KB 목적: 질의→가격)가 엣지 순회로 "263 가격 근거"를 물으면 비가격 gap만 반환. 값은 props.price_archetype/전사표에 있으나 **가격 선언 엣지가 없어** 그래프 탐색이 놓침.

**격리 아님·builder 교정 대상:** 가격값은 라이브 실재·knowable(185/210이 동일 패턴을 올바로 배선). props/전사에 값 기록 + 가격 gap 참조는 100% builder 통제. → **6건에 gap-goods-fixed-lookup-no-formula 참조 추가**(SB-2 동형)해 가격사슬을 가격 gap으로 정직 선언.

**실측 재현:**
```
gap-goods-fixed-lookup-no-formula 참조 = 10 (185/196/205/210/211/212/219/223/224/225)
248/263/265/266/272/275 = ref_gap=False, gap edges = {sewing-missing, material-contamination, pouch-empty-shell}
awk t_prd_product_prices: 263=31000 272=58000 248=12500 275=25000 265=16500 266=24000 (전부 실재)
```

---

## D-GD-INT-2 (Medium) — O5 코드정렬이 **가격 gap ≠ 비가격 gap을 구분 안 함**(D-1의 근본원인·게이트 의미 소실)

**현상:** build_graph.py(2026-07-04) O5 정렬:
```python
has_gap_decl = any(nodes[e["dst"]].type == "gap" for e in out_by.get(nid, []))
if not has_price and not has_gap_decl and n.anchor != "none":
    hard.append("O5 product 끊긴 가격사슬(priced_by/gap 없음)")
```
`has_gap_decl`이 **어떤 gap 타입이든**(공정·자재·BOM·UI gap 포함) 그것도 **최약 R19 `references`(doc-origin 본문 [[link]])** 엣지로 O5(끊긴 **가격**사슬) 게이트를 충족.

**정합 판정(spec §5.4 / 파일 line 151):** spec은 "product | `priced_by` ≥1 또는 **gap/양면 선언**(O5)". 코드 변경은 **문자적으로는 정합**(gap 선언 = type=gap out-edge). 그러나 **섹션 표제·의도는 "끊긴 가격 사슬(priced_by 없는 상품)"** = 가격 선언. 코드는 gap을 **가격 클래스로 제한하지 않아**, 상품이 **무관한 공정/자재 gap을 선언하기만 하면** 가격사슬 미선언인데도 게이트를 통과 → **게이트가 원래 의미(모든 상품은 가격 있거나 가격부재를 정직 선언)를 상실**.

**남용 규모 실측:** O5-via-gap 88건 중 **17건이 비가격 gap으로만 충족**(D-1의 6 파우치/백 + 235~260 레더파우치 계열 + 226 아크릴). 전부 references(doc) 엣지 경유(가격 전용 rel 0).

**정직성 판정(과업 3소항):**
- ③ **NEITHER-gap → gap-goods-neither = 정직 GO.** 001/002/005 등 진짜 공식·고정가 둘 다 0행(awk 확인)을 gap-goods-neither로 선언 = 진짜 가격 부재의 정직 표기. 정합.
- ② **고정가룩업(가격 실재) → gap-goods-fixed-lookup-no-formula 로 O5 충족 = 정직**(단 D-1처럼 실제 참조된 경우). gap_what이 "실제 결함 아니라 스키마가 fixed-lookup을 1급 미수용한 모델 공백"·"값=verified·라이브 CSV 권위"로 **명시** → gap은 "공식 아키타입 부재"만 선언하고 값은 props.price_archetype+전사·source에 verified 기록. **정직 설계.** ✔
- ① **spec 정합 but 과대허용:** 코드가 "가격 gap"으로 좁히지 못한 것이 D-1을 silent 통과시킨 root cause.

**권고(architect/코드 소관):** `has_gap_decl`을 가격 클래스 gap 화이트리스트(neither·price-unloaded·fixed-lookup-no-formula·sparse-grid·cardenv-addon·set 가격 gap)로 제한, 또는 props.가격상태=verified 도 O5 충족 경로로 승격. 그러면 D-1의 6건이 하드로 노출됨(정직 게이트 복원).

---

## D-GD-INT-3 (Low) — gap-goods-cardenv-addon = **degree-0 완전 고아**(연결 대기·유지 판정)

**현상:** gap-goods-cardenv-addon 노드 in-edge 0·out-edge 0(degree 0). 소프트 I-1 "고아 노드(연결 대기·Phase 4)"로 정직 노출됨(리포트 line 558).

**판정:** **유지(KEEP) 허용** — gap_what이 "281/282 del_yn=Y 상품 노드 미생성이 정답·실체는 엽서 has_addon 라벨(260702 50→10장)"을 정직 예약. Stage B 엽서(디지털인쇄 016 등) 노드가 **아직 has_addon으로 이 gap을 참조하지 않아** 현재 dead weight일 뿐, 삭제 시 260702 카드봉투 변경 지식이 소실. → **references 강등/제거 불가·유지**하되, 엽서 노드 (재)빌드 시 has_addon 배선으로 고아 해소 예약(gap_fill_from 기재대로). 과업 우려 "L-20 신규 충돌"은 **불발**(L-20 0703=0704=7·cardenv 무관).

---

## 종합

- **하드 0·멱등·닫힌어휘 19·판형 0·index 103·dead-link 0** = 무결성 골격 건전.
- **High 1(D-1)** = O5 부정직 green(고정가 6건 비가격 gap 통과·SB-3 배선 회귀) → builder 교정(가격 gap 참조 추가).
- **Medium 1(D-2)** = O5 코드가 가격/비가격 gap 미구분(D-1의 근본·게이트 의미 소실) → architect 코드 강화.
- **Low 1(D-3)** = cardenv-addon 고아 유지 판정(연결 대기·정직 노출됨).
- **O5 코드정렬 자체는 spec §5.4 문자 정합·정직 경로(neither/fixed-lookup) 설계 정직** — 다만 가격 클래스 미제한이 남용창(D-2).
