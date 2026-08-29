"""M3-C — 축 라벨 → 차원 코드 번역기 (12차원 전건) · 읽기전용 SELECT.

SPEC-PRICEGRID-001 M3 산출 2. `spec.md` §2.2.2 2단계(축 번역)의 구현이다.

[HARD] 번역 절차 — 판형 축에서 실측으로 확정한 4관문을 12차원 전건에 적용한다
       (`M3-PLATESIZE-260829.md` §8 이 그 유도 과정이다).

    ① 범위     스코프 토큰(proc_grp·opt_grp)·FK 필터로 후보를 **먼저** 좁힌다.
    ② 이름     좁혀진 집합 안에서 이름 계열로 맞춘다.
               정확 일치 > 태그 일치 > 별칭(usr_def_nm) > 퍼지(상한 0.5).
    ③ 왕복     번역 결과로 만든 분모를 라이브와 대조해 확인한다.
    ④ 미성립   ①~③ 으로 갈리지 않으면 **배정하지 않고 사유와 함께 남긴다**(REQ-PG-011).

[HARD] ①을 건너뛰면 자신 있게 틀린다 — 실측된 두 사례:

    · 권위 「유광코팅」을 이름으로 곧장 찾으면 `PROC_000115`(쿨코팅)에 붙는다.
      그 코드의 `usr_def_nm` 이 literally '유광코팅' 이기 때문이다.
      그러나 `COMP_COAT_GLOSSY` 가 실제로 쓰는 것은 `PROC_000014`(유광라미네이팅)이고,
      `proc_grp:PROC_000013`(라미네이팅 코팅)으로 후보를 먼저 좁히면 쿨코팅은 애초에 없다.

    · 권위 「3절」을 `siz_nm` 으로 찾으면 0건이다(`330x660` 어디에도 「3절」이 없다).
      태그(`["3절"]`)로 찾아야 하고, 판걸이수 시트가 그 태그를 확증한다.

[HARD] 1:N 을 막지 않는다. 한 축 라벨이 여러 코드로 실현될 수 있다.
[HARD] 근사 매칭을 확정으로 승격하지 않는다. 퍼지 점수는 0.5 로 상한하고,
       동점이면 배정하지 않는다.

실행:
  raw/webadmin/.venv/bin/python _workspace/price-setup/m3_axis.py
  raw/webadmin/.venv/bin/python _workspace/price-setup/m3_axis.py --comp COMP_COAT_GLOSSY
  raw/webadmin/.venv/bin/python _workspace/price-setup/m3_axis.py --csv m3-axis-260829.csv
"""
import argparse
import csv
import itertools
import json
import os
import re
import sys
from collections import defaultdict

import django
from dotenv import load_dotenv

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
ROOT = "/Users/innojini/Dev/HuniWeb/raw/webadmin"
sys.path.insert(0, ROOT + "/webadmin")
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")
load_dotenv(ROOT + "/.env")
django.setup()
from django.db import connection  # noqa: E402

import m3_l1  # noqa: E402
import m3_map  # noqa: E402

# ── 차원 분류 ────────────────────────────────────────────────────────────
# 정본은 price_views.DIM_META 12종. 여기서는 번역 방식으로 다시 나눈다.
NUM_DIMS = {"min_qty", "siz_width", "siz_height", "bdl_qty",
            "coat_side_cnt", "spot_side_cnt"}
CODE_DIMS = {"siz_cd", "plt_siz_cd", "mat_cd", "proc_cd", "opt_cd", "print_opt_cd"}

# 코드형 차원의 마스터 · 이름 통로(우선순위 순).
#   (테이블, 코드컬럼, [이름컬럼…], 태그컬럼|None)
CODE_SRC = {
    "siz_cd":       ("t_siz_sizes", "siz_cd", ["siz_nm"], "tags"),
    "plt_siz_cd":   ("t_siz_sizes", "siz_cd", ["siz_nm"], "tags"),
    "mat_cd":       ("t_mat_materials", "mat_cd", ["mat_nm", "usr_def_nm"], None),
    "proc_cd":      ("t_proc_processes", "proc_cd", ["proc_nm", "usr_def_nm"], None),
    "print_opt_cd": ("t_prt_print_options", "print_opt_cd",
                     ["print_opt_nm", "usr_def_nm"], None),
    "opt_cd":       ("t_prd_product_options", "opt_cd", ["opt_nm"], None),
}

# 면수 축의 라벨 사전 — 권위 가격표가 쓰는 표기.
SIDE_WORDS = {"단면": 1, "한면": 1, "앞면": 1, "전면": 1, "1면": 1,
              "양면": 2, "두면": 2, "앞뒤": 2, "2면": 2}


def norm(s):
    return re.sub(r"[\s()（）\[\]/·,.\-_]+", "", str(s or ""))


# ── 숫자 축 파서 ─────────────────────────────────────────────────────────
_NUM = re.compile(r"(\d[\d,]*(?:\.\d+)?)")


def parse_number(label):
    """라벨에서 대표 수치 하나. '20mm'→20 · '1,000장'→1000 · '5매'→5."""
    m = _NUM.search(str(label or ""))
    if not m:
        return None
    try:
        v = float(m.group(1).replace(",", ""))
    except ValueError:
        return None
    return int(v) if v == int(v) else v


def parse_side(label):
    """면수 축 — '단면'→1 · '양면'→2. 숫자 표기도 받는다."""
    n = norm(label)
    for w, v in SIDE_WORDS.items():
        if w in n:
            return v
    return parse_number(label)


NUM_PARSER = {
    "min_qty": parse_number,
    "siz_width": parse_number,
    "siz_height": parse_number,
    "bdl_qty": parse_number,
    "coat_side_cnt": parse_side,
    "spot_side_cnt": parse_side,
}


# ── 마스터 사전 (①범위 · ②이름) ─────────────────────────────────────────
class Masters:
    """코드형 차원의 이름 사전. 한 번 읽어 재사용한다."""

    def __init__(self):
        self.by_dim = {}
        for dim, (tbl, cd, nms, tagcol) in CODE_SRC.items():
            cols = [cd] + nms + ([tagcol + "::text"] if tagcol else [])
            sel = ", ".join(cols)
            rows = _q(f"SELECT {sel} FROM {tbl}")
            entries = {}
            for r in rows:
                code = r[0]
                names = [x for x in r[1:1 + len(nms)] if x]
                tags = []
                if tagcol and r[-1]:
                    try:
                        t = json.loads(r[-1])
                        tags = [str(x) for x in t] if isinstance(t, list) else []
                    except Exception:
                        tags = []
                entries[code] = {"names": names, "tags": tags}
            self.by_dim[dim] = entries
        # FK 필터 (price_views.DIM_FK_FILTER 정본) — plt_siz_cd ⊆ impos_yn='Y'
        self.impos = {r[0] for r in _q("SELECT siz_cd FROM t_siz_sizes WHERE impos_yn='Y'")}

    def best_in_closed_set(self, dim, label, closed):
        """[HARD] 닫힌 집합 안의 **상대 비교** — 판형에서 쓴 원리를 코드 차원 전반으로.

        이름만으로는 원리적으로 못 가리는 경우가 있다. 실측:

            라벨 「투명아크릴3T」
              MAT_000386 '아크릴(투명) 3mm'   유사도 0.750  부분포함 ✗   ← 정답
              MAT_000192 '투명아크릴'         유사도 0.714  부분포함 ✓
              MAT_000036 '아크릴'            유사도 0.429  부분포함 ✓
              MAT_000143 '투명'              유사도 0.286  부분포함 ✓

        열린 마스터(자재 707종)에서 고르면 부분포함이 퍼지를 이겨 「투명아크릴」이 뽑힌다.
        「3T」와 「3mm」의 차이를 문자 집합 유사도가 못 읽기 때문이고, 이것은 임계를
        조정해서 풀 문제가 아니다.

        그러나 이 구성요소가 **라이브에서 실제로 쓰는 자재는 둘뿐**이고, 그 닫힌 집합
        안에서는 0.750 vs 0.500 으로 유일 최대에 여백 0.25 다.

        [HARD] 경계 — 이것은 **분모 생성이 아니라 코드 식별**이다.
          분모는 여전히 권위 하위표의 교차곱이 만든다(§2.2.2). 라이브는 「이 라벨이 어느
          코드를 가리키는가」의 오라클로만 쓴다.
          대가: 권위에 있고 라이브에 없는 코드는 이 경로로 번역되지 않는다. 그때는
          열린 마스터로 넘어가고, 거기서도 안 되면 미성립이다 — 없는 것을 지어내지 않는다.
        """
        if not closed:
            return [], "", 0.0
        scored = []
        for c in closed:
            ent = self.by_dim[dim].get(c)
            if not ent:
                continue
            best = 0.0
            for x in ent["names"] + ent["tags"]:
                if norm(x) == norm(label):
                    best = 1.0
                    break
                best = max(best, m3_map.name_sim(label, x))
            scored.append((best, c))
        if not scored:
            return [], "", 0.0
        scored.sort(reverse=True)
        top = scored[0][0]
        if top <= 0:
            return [], "", 0.0
        # 동점은 1:N 으로 함께 낸다(같은 이름을 가진 코드가 여럿일 수 있다).
        tied = [c for s, c in scored if s == top]
        second = next((s for s, _ in scored if s < top), 0.0)
        if top < 1.0 and (top - second) < 0.05:
            return [], "", 0.0        # 여백이 없으면 판별하지 않는다
        return sorted(tied), "닫힌집합(%.2f)" % top, top

    def candidates(self, dim, scopes):
        """① 범위 — 후보 집합을 먼저 좁힌다. 좁히지 못하면 마스터 전건."""
        all_codes = set(self.by_dim[dim])
        if dim == "plt_siz_cd":
            return all_codes & self.impos, "impos_yn='Y'"
        if dim == "proc_cd" and scopes.get("proc_grp"):
            g = scopes["proc_grp"]
            kids = {r[0] for r in _q("""SELECT proc_cd FROM t_proc_processes
                     WHERE upr_proc_cd=%s AND COALESCE(del_yn,'N')<>'Y'""", [g])}
            return (all_codes & kids), "proc_grp:%s (%d종)" % (g, len(kids))
        if dim == "opt_cd" and scopes.get("opt_grp"):
            g = scopes["opt_grp"]
            mem = {r[0] for r in _q("""SELECT opt_cd FROM t_prd_product_options
                     WHERE opt_grp_cd=%s AND COALESCE(del_yn,'N')<>'Y'""", [g])}
            return (all_codes & mem), "opt_grp:%s (%d종)" % (g, len(mem))
        return all_codes, "마스터 전건"

    def match_group(self, dim, label, cand):
        """[HARD] 동가 묶음 분해 — 「A3 / A2 / A1」은 라벨 하나가 아니라 셋이다.

        권위 가격표는 **같은 가격인 것을 슬래시로 묶어** 적는다. 실측 281건
        (가격표 206 + 상품마스터 75)이고, `huni-product-lifecycle.md` §8.1 이
        「⑤ 동가 묶음 — 미해소·최대」로 지목한 항목이다.

        분해하지 않으면 조용히 틀린다 — 「A3 / A2 / A1」을 수치로 읽으면 `3` 이 되고
        (실측), 코드로 읽으면 셋 중 하나만 잡힌다. 어느 쪽이든 나머지 둘의 격자가
        통째로 사라진다.

        분해 결과는 **합집합**이다(1:N). 조각 하나라도 번역되지 않으면 부분 성립으로
        남기고, 어느 조각도 안 되면 미성립이다 — 추측으로 메우지 않는다.
        """
        parts = [p.strip() for p in re.split(r"[/,·]", str(label or "")) if p.strip()]
        if len(parts) < 2:
            return None
        codes, chans, got = [], set(), 0
        for p in parts:
            c, ch, sc = self.match(dim, p, cand)
            if c:
                got += 1
                chans.add(ch)
                for x in c:
                    if x not in codes:
                        codes.append(x)
        if not codes:
            return None
        return sorted(codes), "묶음분해(%d/%d · %s)" % (got, len(parts), ",".join(sorted(chans))), \
            1.0 if got == len(parts) else 0.7

    def match(self, dim, label, cand):
        """② 이름 — 정확 > 태그 > 퍼지(상한 0.5). 1:N 을 허용한다.

        반환 (codes, channel, score). codes 가 비면 미성립.
        """
        n = norm(label)
        if not n:
            return [], "", 0.0
        # [HARD] G-1 숫자·치수 라벨은 코드 이름이 아니다 — 매칭하지 않는다.
        #   실측된 오작동 둘:
        #     · 라벨 「100」이 자재 23종에, 「1」이 사이즈 12종에 붙었다.
        #     · 라벨 「20mm」(아크릴 행 축)이 자재 8종에 부분포함으로 붙어,
        #       mat_cd 가 행 축을 차지하고 정작 자재를 담은 제목 축이 siz_height 로 밀렸다.
        #       그 결과 골든 케이스의 자재가 통째로 틀렸다.
        #   경계: **치수 표기는 사이즈의 이름이 될 수 있다**(SIZ_000533 = '320mm').
        #         그러나 자재·공정·옵션·인쇄옵션의 이름은 될 수 없다. 그 넷에만 막는다.
        if re.fullmatch(r"\d+", n):
            return [], "", 0.0
        if dim not in ("siz_cd", "plt_siz_cd") and \
                re.fullmatch(r"\d+(?:\.\d+)?(?:mm|cm|m|t|T|p|P|장|매|개|절|도|단)?", n):
            return [], "", 0.0
        ent = self.by_dim[dim]

        exact = [c for c in cand if any(norm(x) == n for x in ent[c]["names"])]
        if exact:
            return sorted(exact), "정확(이름)", 1.0
        tagged = [c for c in cand if any(norm(t) == n for t in ent[c]["tags"])]
        if tagged:
            return sorted(tagged), "정확(태그)", 1.0
        # 부분 포함 — 라벨이 이름/태그에 통째로 들어가거나 그 반대.
        #   [HARD] 태그도 함께 본다. 권위 제목은 판형 라벨을 감싸고 있는 경우가 많다 —
        #   「코팅(국4절)」 안에 태그 「국4절」이 통째로 들어 있다. 태그를 빼고 검사하면
        #   이 케이스가 퍼지(0.60)로 떨어져, 신뢰도가 낮은 통로로 옳은 답을 얻게 된다.
        sub = [c for c in cand
               if any(n and (n in norm(x) or norm(x) in n)
                      for x in (ent[c]["names"] + ent[c]["tags"]))]
        if sub:
            return sorted(sub), "부분포함", 0.7
        # 퍼지 — 상한 0.5. 최고점이 여럿이면 그대로 돌려주고 호출측이 동점 판정한다.
        best, bestc = 0.0, []
        for c in cand:
            for x in ent[c]["names"] + ent[c]["tags"]:
                s = m3_map.name_sim(label, x)
                if s > best:
                    best, bestc = s, [c]
                elif s == best and best > 0:
                    bestc.append(c)
        if best >= 0.5:
            return sorted(set(bestc)), "퍼지(%.2f)" % best, 0.5
        return [], "", 0.0


def _q(sql, params=None):
    with connection.cursor() as c:
        c.execute(sql, params or [])
        return c.fetchall()


# ── 축 후보 추출 ─────────────────────────────────────────────────────────
def block_axes(b):
    """블록이 제공하는 축들. {축이름: [라벨…]}

    row      행 라벨
    band<k>  열 밴드의 k번째 깊이 (band_header_path 를 `>` 로 split 한 결과)
    title    블록 제목 — 값이 하나뿐인 상수 축
    """
    axes = {"row": b.row_axis}
    depth = max((len(c) for c in b.col_axis), default=0)
    for k in range(depth):
        vals = []
        for c in b.col_axis:
            v = c[k] if k < len(c) else ""
            if v and v not in vals:
                vals.append(v)
        if vals:
            axes["band%d" % k] = vals
    axes["title"] = [b.title]
    return axes


# ── 배정 탐색 ────────────────────────────────────────────────────────────
def title_keys(title):
    """블록 제목에서 매칭 키 후보를 좁은 것부터 낸다.

    권위 제목은 「대상명 (부가설명) 나머지 설명」 꼴이다.
    부가설명이 문자 집합을 부풀려 정답의 유사도를 임계 아래로 끌어내리므로,
    괄호 앞·첫 공백 앞의 **앞머리**를 먼저 시도한다.

      「투명아크릴3T (직접입력형) 양면9도 / 단면7도 통용 단가」
         전체      vs 「아크릴(투명) 3mm」 = 0.27   ← 임계 미달
         앞머리 「투명아크릴3T」            = 0.75   ← 정답
    """
    t = str(title or "").strip()
    if not t:
        return []
    keys = []
    head = t.split("(")[0].strip()
    if head and head != t:
        keys.append(head)
    first = t.split()[0].strip() if t.split() else ""
    if first and first not in keys and first != t:
        keys.append(first)
    keys.append(t)
    return keys


def foreign_labels(blocks, b):
    """[HARD] 인접 하위표에서 흘러들어온 라벨 — 축 라벨이 아니다.

    포스터사인 시트는 한 영역에 표를 여럿 겹쳐 놓았고, 그 블록들은 `data_start_row=None`
    이라 기하가 `recovered` 다. 그 결과 옆 표의 **제목·머리글**이 이 블록의 행 축에 섞인다.
    실측(메쉬현수막 B27 행 축 23종): 「시트커팅 (무광 / 홀로그램)」·「사이즈 / 소재」·
    「무광(화이트/블랙)」 등 7종이 다른 표의 것이다.

    이 라벨들이 숫자로 안 읽히는 것은 **번역 규칙의 실패가 아니다.** 축 라벨이 아니어서다.

    [HARD] 판정 근거는 **다른 표의 제목**뿐이다. 형제 표의 축 라벨은 쓰지 않는다.

      [실측된 실패] 축 라벨까지 혼입 증거로 삼았더니 크게 퇴행했다 —
      판형 88%→44% · 인쇄옵션 80%→10% · 사이즈세로 75%→33%. 같은 시트의 표들이
      「600mm」·「단면」·「양면」 같은 **어휘를 공유하는 것은 정상**이고, 그것을 혼입으로
      읽으면 진짜 축 라벨이 통째로 지워진다. 제목은 표마다 고유해 그 함정이 없다.
    """
    mine = b.key()
    out = set()
    for o in blocks:
        if o.sheet != b.sheet or o.key() == mine:
            continue
        if o.title:
            out.add(norm(o.title))
    return out


def translate_param(label, meta):
    """공정 상세 파라미터 축의 라벨 하나를 값으로. 못 읽으면 None.

    [HARD] 이 축은 `use_dims` 12종에 없다 — `t_prc_component_prices.dim_vals`(jsonb)에
           담기고, 단가편집 화면은 `proc_grp` 의 상세입력을 그리드 **컬럼**으로 세운다
           (`price_views.proc_param_cols`). 화면 실측(2026-08-30):

               COMP_PP_CREASE_1L 오시비   적용일·공정·**줄수(줄)**·수량·고정·비고  → 30행
               COMP_PP_VARIMG_1EA 가변이미지 적용일·공정·**개수(개)**·수량·고정·비고

           권위 「오시 (합가)」(인쇄후가공 B03)도 열 라벨이 **1줄·2줄·3줄**이다.
           이 축을 버리면 권위 30칸이 11칸으로, 라이브 30행이 10행으로 접히고
           그 어긋남이 통째로 「누락 1」로 둔갑한다.
    """
    vals = [str(v) for v in (meta.get("values") or []) if str(v).strip()]
    if vals:                                   # 선택형 — 정의된 값 목록과 맞춘다
        nl = norm(label)
        for v in vals:
            if norm(v) == nl:
                return v
        for v in vals:                         # 라벨에 값이 포함된 형태(「앞면 유광」)
            if norm(v) and norm(v) in nl:
                return v
        return None
    return parse_number(label)                 # 수치형(integer/number) — 「1줄」→1


def translate_block(comp, b, dims, scopes, M, live_vals, foreign=frozenset(),
                    params=None):
    """이 블록의 축들을 comp 의 차원에 배정하고 번역한다.

    `dims` 는 `_comp_dims` 12종 + **공정 상세 파라미터 키**(`params` 의 key)를 합친
    격자 축 전체다. 각 축은 최대 한 차원에만 배정된다.
    배정 점수 = 번역 성공 라벨 비율의 합.
    반환: {dim: {"axis":…, "map":{라벨:[코드…]}, "channel":…, "status":…}}
    """
    params = params or {}
    axes = block_axes(b)

    # [HARD] 상수 차원을 **먼저** 빼낸다 — 축 선점을 막는다.
    #   라이브에 값이 1종뿐인 차원은 원리적으로 어떤 축도 나르지 않는다. 그런데 그 차원의
    #   이름이 블록 제목과 비슷하면 배정 탐색에서 title 축을 가로채고, 정작 그 축을 써야 할
    #   차원이 엉뚱한 축으로 밀린다.
    #   실측: 「디지털인쇄 출력비(3절)」에서 proc_cd(디지털인쇄)가 title 을 가로채
    #   plt_siz_cd 가 row 로 밀려 0.679 로 떨어졌다. 정답은 title→판형(1.0)·row→수량(0.981).
    const = {}
    free = []
    for d in dims:
        lv = live_vals.get(d, set())
        if len(lv) == 0:
            # [HARD] 라이브 값이 전건 NULL — 그 구성요소가 **쓰지 않는 차원**이다.
            #   번역 실패가 아니다. `_comp_dims` 는 min_qty 를 use_dims 에 없어도 무조건
            #   덧붙이므로(price_views.py:1339-1345 · spec.md §2.1), 수량 축이 없는
            #   구성요소에도 min_qty 컬럼이 생긴다. 포스터사인 계열이 그 형태다
            #   (use_dims=["siz_width","siz_height"] · min_qty 전건 NULL).
            const[d] = {"axis": "(미사용)", "map": {}, "channel": "라이브 전건 NULL",
                        "rate": 1.0, "status": "null-dim",
                        "why": "이 구성요소는 이 차원을 쓰지 않는다(라이브 전건 NULL)"}
            continue
        if len(lv) == 1:
            const[d] = {"axis": "(상수)", "map": {"(블록 상수)": sorted(lv)},
                        "channel": "라이브 단일값", "rate": 1.0, "status": "constant"}
        else:
            free.append(d)
    dims_search = free

    # 차원별로 각 축을 시험해 사전 점수를 낸다.
    trial = {}
    bleed = {}          # 축별 혼입 라벨 — 분모에서 제외하고 사유로 남긴다
    for ax, labels in axes.items():
        bleed[ax] = [lb for lb in labels if norm(lb) in foreign]
    for d in dims_search:
        for ax, labels in axes.items():
            # 혼입 라벨은 축 라벨이 아니므로 분모에서 뺀다(제거가 아니라 분류다).
            eff = [lb for lb in labels if lb not in bleed[ax]]
            got, mp, chans = 0, {}, set()
            if d in params:
                for lb in eff:
                    v = translate_param(lb, params[d])
                    if v is not None:
                        mp[lb] = [v]
                        got += 1
                        chans.add("상세파라미터")
            elif d in NUM_DIMS:
                p = NUM_PARSER[d]
                for lb in eff:
                    # 동가 묶음이면 조각마다 수치를 읽어 합집합으로 낸다.
                    # [HARD] 천단위 콤마는 묶음 구분자가 아니다. 먼저 지운다.
                    #   실측(오시비 · 인쇄후가공 B03): 꼬리 주석 「1,000장당 20,000원씩
                    #   올립니다.」를 `,` 로 쪼개 ["1","000장당 20","000원씩…"] → {0,1} 이
                    #   되어 **존재하지 않는 min_qty=0** 이 분모에 생겼다. 그 3칸이 오시비의
                    #   「누락 3」의 정체다 — 라이브 결손이 아니라 파서 결함이다.
                    flat = re.sub(r"(?<=\d),(?=\d{3}(?!\d))", "", str(lb))
                    parts = [x.strip() for x in re.split(r"[/,·]", flat) if x.strip()]
                    if len(parts) > 1:
                        vs = [p(x) for x in parts]
                        vs = [v for v in vs if v is not None]
                        if len(vs) == len(parts):
                            mp[lb] = sorted(set(vs))
                            got += 1
                            chans.add("묶음분해(수치)")
                            continue
                    v = p(lb)
                    if v is not None:
                        mp[lb] = [v]
                        got += 1
                        chans.add("수치파싱")
            else:
                cand, scope_note = M.candidates(d, scopes)
                closed = {c for c in live_vals.get(d, set()) if c in M.by_dim[d]}
                for lb in eff:
                    # ①' 닫힌 집합 먼저 — 라이브가 이 구성요소에 쓰는 코드로 상대 비교.
                    #    열린 마스터를 먼저 뒤지면 부분포함이 퍼지를 이겨 오답이 나온다.
                    keys = title_keys(lb) if ax == "title" else [lb]
                    hit = None
                    for key in keys:
                        r = M.best_in_closed_set(d, key, closed)
                        if r[0]:
                            hit = r
                            break
                    if hit:
                        mp[lb] = hit[0]
                        got += 1
                        chans.add(hit[1])
                        continue
                    if ax == "title":
                        # [HARD] 제목은 묶음이 아니다 — 분해하지 않는다.
                        #   실측: 「투명아크릴3T (직접입력형) 양면9도 / 단면7도 통용 단가」를
                        #   `/` 로 쪼개니 조각마다 짧은 자재명이 우연히 들어가 5종이 붙었다.
                        #   정답은 MAT_000386 하나다.
                        # [HARD] 제목은 **앞머리 명사구**로 맞춘다.
                        #   전체 제목으로는 정답도 맞지 않는다 — 부가설명이 문자 집합을
                        #   부풀려 「투명아크릴3T…통용 단가」 vs 「아크릴(투명) 3mm」이 0.27 로
                        #   임계 미달이 된다. 앞머리 「투명아크릴3T」로 자르면 0.75 다.
                        codes, ch, sc = [], "", 0.0
                        for key in title_keys(lb):
                            codes, ch, sc = M.match(d, key, cand)
                            if codes:
                                ch = "제목머리(%s)" % ch
                                break
                    else:
                        g = M.match_group(d, lb, cand)
                        codes, ch, sc = g if g else M.match(d, lb, cand)
                    if codes:
                        mp[lb] = codes
                        got += 1
                        chans.add(ch)
            if eff:
                trial[(d, ax)] = (got / len(eff), mp, ",".join(sorted(chans)))

    # 축 중복 없이 총점 최대인 배정을 고른다(축·차원 모두 소수라 전수 탐색).
    best_score, best_assign = -1.0, {}
    ax_names = list(axes)
    for perm in itertools.permutations(ax_names, min(len(dims_search), len(ax_names))):
        assign = dict(zip(dims_search, perm))
        score = sum(trial.get((d, a), (0.0, {}, ""))[0] for d, a in assign.items())
        if score > best_score:
            best_score, best_assign = score, assign

    out = dict(const)
    for d in dims_search:
        ax = best_assign.get(d)
        rate, mp, ch = trial.get((d, ax), (0.0, {}, ""))
        if not mp:
            lv = live_vals.get(d, set())
            why = "축에서 번역되지 않음(라이브 후보 %d종)" % len(lv)
            if d in CODE_DIMS:
                cand, note = M.candidates(d, scopes)
                if not cand:
                    # 스코프가 빈 집합으로 좁혔다 — 라이브 결함의 재확인이다.
                    # spec.md §2.2.3 ⑤ 가 OPT_000082·OPT_000084 를 구성원 0명으로 기록한다.
                    why = "스코프 후보 집합이 비었다(%s) — 그룹 구성원 0명" % note
            out[d] = {"axis": ax, "map": {}, "channel": "", "rate": 0.0,
                      "status": "unresolved", "why": why,
                      "bleed": bleed.get(ax, [])}
            continue
        status = "ok" if rate >= 0.999 else ("partial" if rate > 0 else "unresolved")
        out[d] = {"axis": ax, "map": mp, "channel": ch, "rate": rate, "status": status,
                  "bleed": bleed.get(ax, [])}
    return out


def run(only_comp=None, only_sheet=None):
    per_col, unmapped, names, nrows, meta = m3_map.pair_blocks(only_sheet)
    comp2blocks = m3_map.invert(per_col)
    M = Masters()

    from catalog import price_views as pv
    from catalog import models as Mo

    all_blocks = m3_l1.load_blocks(only_sheet)
    results = []
    for comp, slots in comp2blocks.items():
        if only_comp and comp != only_comp:
            continue
        cobj = Mo.TPrcPriceComponents.objects.filter(comp_cd=comp).first()
        if not cobj:
            continue
        dims = pv._comp_dims(cobj)
        _, scopes = pv.split_scopes(cobj.use_dims)
        # 이 구성요소가 라이브에서 실제로 쓰는 차원값 — ③왕복 대조의 기준
        live_vals = {}
        for d in dims:
            live_vals[d] = {r[0] for r in _q(
                f"SELECT DISTINCT {d} FROM t_prc_component_prices "
                f"WHERE comp_cd=%s AND {d} IS NOT NULL", [comp])}
        for key, v in slots.items():
            b = v["block"]
            tr = translate_block(comp, b, dims, scopes, M, live_vals,
                                 foreign_labels(all_blocks, b))
            results.append((comp, names.get(comp, ""), b, dims, scopes, tr, live_vals))
    return results, M


def main():
    ap = argparse.ArgumentParser(description="축 라벨 → 차원 코드 번역 (12차원)")
    ap.add_argument("--comp")
    ap.add_argument("--sheet")
    ap.add_argument("--csv")
    ap.add_argument("--verbose", action="store_true")
    a = ap.parse_args()

    results, M = run(a.comp, a.sheet)

    stat = defaultdict(lambda: defaultdict(int))
    chan = defaultdict(lambda: defaultdict(int))
    for comp, cname, b, dims, scopes, tr, live in results:
        for d, r in tr.items():
            stat[d][r["status"]] += 1
            if r["channel"]:
                chan[d][r["channel"]] += 1

    print("축 번역 결과 — 구성요소×하위표 %d쌍" % len(results))
    print("=" * 88)
    print(f"  {'차원':16s}{'확정':>6s}{'상수':>6s}{'미사용':>7s}{'부분':>6s}{'미성립':>7s}"
          f"{'확정률':>8s}   주 통로")
    order = ["siz_cd", "plt_siz_cd", "mat_cd", "proc_cd", "opt_cd", "print_opt_cd",
             "coat_side_cnt", "spot_side_cnt", "bdl_qty", "siz_width", "siz_height", "min_qty"]
    for d in order:
        if d not in stat:
            continue
        s = stat[d]
        tot = sum(s.values())
        # 「미사용」(라이브 전건 NULL)은 번역 대상이 아니므로 확정률의 분모에서 뺀다.
        denom = tot - s["null-dim"]
        good = s["ok"] + s["constant"]
        ch = sorted(chan[d].items(), key=lambda x: -x[1])[:2]
        chs = " · ".join(f"{k}({v})" for k, v in ch)
        pct = (100 * good // denom) if denom else 100
        print(f"  {d:16s}{s['ok']:6d}{s['constant']:6d}{s['null-dim']:7d}{s['partial']:6d}"
              f"{s['unresolved']:7d}{pct:7d}%   {chs}")

    if a.verbose or a.comp:
        for comp, cname, b, dims, scopes, tr, live in results:
            print("\n" + "=" * 88)
            print(f"{comp}  {cname}")
            print(f"  하위표: {b.sheet} {b.block_id} {b.title[:48]}  ({b.geometry})")
            print(f"  dims={dims}  scopes={scopes}")
            for d in dims:
                r = tr.get(d, {})
                mp = r.get("map", {})
                print(f"    [{r.get('status','?'):10s}] {d:14s} 축={str(r.get('axis')):8s} "
                      f"통로={r.get('channel',''):16s} 라벨 {len(mp)}종")
                for lb, codes in list(mp.items())[:6]:
                    tag = " ★1:N" if len(codes) > 1 else ""
                    print(f"         {str(lb)[:26]:28s} → {codes}{tag}")
                if len(mp) > 6:
                    print(f"         … 외 {len(mp)-6}종")
                if r.get("why"):
                    print(f"         사유: {r['why']}")

    if a.csv:
        with open(a.csv, "w", encoding="utf-8-sig", newline="") as fh:
            w = csv.writer(fh)
            w.writerow(["comp_cd", "comp_nm", "sheet", "block_id", "block_title", "geometry",
                        "dim", "axis", "channel", "status", "rate",
                        "axis_label", "dim_codes", "n_codes"])
            for comp, cname, b, dims, scopes, tr, live in results:
                for d in dims:
                    r = tr.get(d, {})
                    mp = r.get("map", {})
                    if not mp:
                        w.writerow([comp, cname, b.sheet, b.block_id, b.title, b.geometry,
                                    d, r.get("axis"), r.get("channel", ""),
                                    r.get("status"), "%.3f" % r.get("rate", 0),
                                    "", "", 0])
                        continue
                    for lb, codes in mp.items():
                        w.writerow([comp, cname, b.sheet, b.block_id, b.title, b.geometry,
                                    d, r.get("axis"), r.get("channel", ""),
                                    r.get("status"), "%.3f" % r.get("rate", 0),
                                    lb, "|".join(str(c) for c in codes), len(codes)])
        print("\n→ %s" % a.csv)


if __name__ == "__main__":
    main()
