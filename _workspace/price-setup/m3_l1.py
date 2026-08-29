"""M3-A — 권위 L1 추출본 로더 · 하위표 기하 복구 (읽기전용 · 라이브 접근 없음).

입력은 `table_parse.py` 가 아니라 **기존 260822 L1 추출본**이다(SPEC-PRICEGRID-001 v0.7.0 §2.4.1).

    _workspace/huni-dbmap/24_price-extract-260822/<sheet>-l1.csv
    _workspace/huni-dbmap/24_price-extract-260822/<sheet>-l1-meta.csv

L1 이 이미 갖고 있어서 새로 만들 필요가 없는 것:
    block_id          하위표 식별자      — 분모가 하위표 단위라서 이것이 없으면 M3 가 성립하지 않는다
    cell_ref          셀 좌표            — 권위 귀속(AC-PG-016)의 주소
    band_header_path  다단 헤더 경로     — `>` 로 split 하는 소비 규칙이 T-1 에 이미 설계돼 있다
    header_rows / data_start_row / row_range / col_range   블록 기하

[HARD] 이 모듈의 존재 이유 — `data_start_row` 는 기하 신뢰도 표식이다.

  data_start_row 가 정수      → 추출기가 데이터 시작을 찾았다. header_rows 전건이 진짜 밴드다.
                                 코팅 B01: header_rows=[2,3] · data_start=4 · 「무광코팅 > 단면」 2단.

  data_start_row 가 None      → 추출기가 데이터 시작을 못 찾고 **데이터행을 header_rows 로 삼켰다.**
                                 아크릴 B01: header_rows=[2..16] 15개 · data_start=None.
                                 그 결과 band_header_path 가
                                 「20mm > 2500 > 2700 > …」처럼 열 라벨 + 그 열의 데이터가 된다.

  복구 규칙 — data_start_row 가 None 이면 진짜 헤더는 header_rows[0] 하나이고
             데이터행은 그 다음 행부터다. 열 라벨은 band_header_path 의 **첫 토큰**이다.

  이 복구가 옳다는 증거(실측 2026-08-29):
      아크릴 B01 투명3T   r3~16 = 14행 × 14열 = 196
      아크릴 B02 투명1.5T r23~31 =  9행 ×  9열 =  81   → 196+81 = 277 = 라이브 COMP_ACRYL_CLEAR3T
      아크릴 B03 미러3T   r37~45 =  9행 ×  9열 =  81   =        라이브 COMP_ACRYL_MIRROR3T
      아크릴 B05 코롯토   r92~97 =  6행 ×  6열 =  36   =        라이브 COMP_ACRYL_COROTTO
  세 회귀 기준선이 규칙 하나로 재현된다.

[HARD] 추정하지 않는다 — 기하를 복구할 수 없는 블록은 버리지 않고 status 를 달아 남긴다.
       미성립을 미성립으로 남기는 것이 REQ-PG-011 이고, 목록이 비지 않은 것은 실패가 아니다.
"""
import csv
import glob
import json
import os
from collections import OrderedDict

L1_DIR = "/Users/innojini/Dev/HuniWeb/_workspace/huni-dbmap/24_price-extract-260822"
MANIFEST = os.path.join(L1_DIR, "_authority-manifest-260822.json")

# 권위 판본 — 이 값과 다른 추출본을 읽고 있으면 즉시 멈춘다(spec.md §2.4 판본 함정).
EXPECT_AUTHORITY = "260822_1"


def col_index(letter):
    """엑셀 열 문자 → 0-기반 인덱스. 'A'→0 · 'Z'→25 · 'AA'→26."""
    n = 0
    for ch in letter.strip().upper():
        if not ("A" <= ch <= "Z"):
            return None
        n = n * 26 + (ord(ch) - 64)
    return n - 1 if n else None


def as_number(s):
    """셀 값이 단가로 읽히면 Decimal 로, 아니면 None. 쉼표·원 표기를 걷어낸다."""
    if s is None:
        return None
    t = str(s).strip().replace(",", "").replace("원", "")
    if not t or t in {"-", "—", "0"} and t != "0":
        return None
    try:
        from decimal import Decimal
        v = Decimal(t)
    except Exception:
        return None
    return v


def _looks_like_price_row(cells_in_row):
    """그 행의 A열 밖 셀들이 대부분 수치인가 — 헤더행과 데이터행을 가르는 보조 신호."""
    body = [c for c in cells_in_row if c["col"] != "A"]
    if not body:
        return False
    num = sum(1 for c in body if as_number(c["value"]) is not None)
    return num >= max(1, int(len(body) * 0.6))


class Block:
    """권위 하위표 하나. 분모 생성의 최소 단위다(spec.md §2.2.2 3단계)."""

    def __init__(self, sheet, block_id, meta):
        self.sheet = sheet
        self.block_id = block_id
        self.title = (meta or {}).get("title") or ""
        self.header_rows = list((meta or {}).get("header_rows") or [])
        self.data_start_row = (meta or {}).get("data_start_row")
        self.row_range = (meta or {}).get("row_range") or []
        self.col_range = (meta or {}).get("col_range") or []
        self.cells = []                 # 원본 L1 행 전건
        # 아래는 resolve() 가 채운다
        self.geometry = "unresolved"    # declared | recovered | unresolved
        self.band_depth = 0             # 진짜 헤더 밴드의 깊이
        self.header_row_no = None       # 헤더 밴드의 첫 행
        self.label_row_no = None        # 열 라벨을 읽는 행 — 밴드의 **가장 깊은** 행
        self.col_labels = OrderedDict()  # 열문자 -> (라벨 튜플)  밴드 깊이만큼의 튜플
        self.row_labels = OrderedDict()  # row_seq -> 행 라벨
        self.matrix = []                # (row_label, col_label_tuple, value, cell_ref)
        self.notes = []                 # 판정 근거 · 미성립 사유

    # ── 기하 ────────────────────────────────────────────────────────────
    def resolve(self):
        """헤더 밴드와 데이터행을 확정한다. 실패하면 geometry='unresolved' 로 남긴다."""
        by_row = {}
        for c in self.cells:
            by_row.setdefault(int(c["row_seq"]), []).append(c)

        if not self.header_rows:
            self.notes.append("header_rows 비어 있음 — 기하 미확정")
            return self

        if isinstance(self.data_start_row, int):
            # 추출기가 데이터 시작을 찾은 경우 — header_rows 전건이 진짜 밴드다.
            self.geometry = "declared"
            hdr_rows = [r for r in self.header_rows if r < self.data_start_row]
            if not hdr_rows:
                hdr_rows = self.header_rows[:1]
            self.band_depth = len(hdr_rows)
            self.header_row_no = hdr_rows[0]
            # [HARD] 열 라벨은 밴드의 **가장 깊은 행**에서 읽는다.
            # 상위 밴드는 병합셀이라 L1 에 대표 열 하나만 남는다 — 코팅 B01 은 「무광코팅」이
            # B2:C2 병합이어서 첫 행에는 B·D 둘뿐이고, C·E 는 최하단 행(단면/양면)에만 있다.
            # 첫 행에서 읽으면 4열짜리 표가 2열로 잡혀 셀 절반(46/92)을 잃는다.
            self.label_row_no = hdr_rows[-1]
            data_rows = sorted(r for r in by_row if r >= self.data_start_row)
        else:
            # 데이터행이 header_rows 로 새어 들어온 경우 — 첫 행만 진짜 헤더로 복구한다.
            self.geometry = "recovered"
            self.band_depth = 1
            self.header_row_no = self.header_rows[0]
            self.label_row_no = self.header_row_no
            data_rows = sorted(r for r in by_row if r > self.header_row_no)
            self.notes.append(
                "data_start_row=None — header_rows[%d]=%d 만 헤더로 복구, 데이터행 %d개"
                % (0, self.header_row_no, len(data_rows)))

        self._read_col_labels(by_row)
        self._read_matrix(by_row, data_rows)
        self._drop_row_header_cols()
        return self

    def _drop_row_header_cols(self):
        """[HARD] 값이 곧 행 라벨인 열은 **행 축의 머리 열**이지 단가 열이 아니다.

        A열만 걸러서는 부족하다 — 시트에 따라 수량 머리 열이 B열 이후에 놓인다.
        실측: 인쇄후가공 「오시 (합가)」의 4열 중 「제작수량」 열이 그것이고, 그 열이
        단가 열로 읽히는 바람에 겹침 0.90·점수 0.42 로 엉뚱하게 `COMP_PRINT_DIGITAL_S1`
        에 짝지어졌다(나머지 3열은 0.83~0.88 로 오시비에 정확히 갔다).
        머리 열을 단가로 읽으면 **없는 짝을 만들어 낸다.**

        판정은 구조로 한다 — 그 열의 값 집합이 행 라벨 집합과 같으면 머리 열이다.
        """
        if not self.matrix:
            return
        rowlabs = {str(rl).strip() for rl in self.row_labels.values()}
        if not rowlabs:
            return
        by_col = {}
        for rl, cl, v, ref in self.matrix:
            by_col.setdefault(cl, []).append((rl, v))
        drop = set()
        for cl, cells in by_col.items():
            vals = {str(v).rstrip("0").rstrip(".") if "." in str(v) else str(v)
                    for _, v in cells}
            if len(vals) >= 3 and vals <= rowlabs:
                drop.add(cl)
                self.notes.append("열 %r 은 행 축 머리 열(값=행 라벨) — 단가 열에서 제외"
                                  % (" > ".join(cl) if isinstance(cl, tuple) else cl,))
        if drop:
            self.matrix = [m for m in self.matrix if m[1] not in drop]
            self.col_labels = OrderedDict(
                (k, v) for k, v in self.col_labels.items() if v not in drop)

    def _read_col_labels(self, by_row):
        """열 라벨을 읽는다.

        declared  — band_header_path 를 `>` 로 split 한 전체 경로가 라벨 튜플이다(T-1).
        recovered — 첫 토큰만 진짜 라벨이고 나머지는 새어 들어온 데이터다.
        """
        for c in self.cells:
            if int(c["row_seq"]) != self.label_row_no:
                continue
            if c["col"] == "A":
                continue                     # A열은 행 축 머리다
            path = (c.get("band_header_path") or "").strip()
            if path:
                parts = [p.strip() for p in path.split(">") if p.strip()]
            else:
                parts = [(c.get("value") or "").strip()]
            if self.geometry == "recovered":
                parts = parts[:1]
            else:
                parts = parts[:self.band_depth] or parts[:1]
            if parts and parts[0]:
                self.col_labels[c["col"]] = tuple(parts)

    def _read_matrix(self, by_row, data_rows):
        """(행 라벨, 열 라벨, 값, 셀좌표) 4-튜플을 만든다. 값이 수치인 셀만 담는다."""
        for r in data_rows:
            row_cells = by_row.get(r, [])
            if not row_cells:
                continue
            # 행 라벨 — L1 이 채워 준 row_key 를 쓰고, 비면 A열 값으로 대체한다.
            rl = ""
            for c in row_cells:
                if c.get("row_key"):
                    rl = c["row_key"].strip()
                    break
            if not rl:
                a = [c for c in row_cells if c["col"] == "A"]
                rl = (a[0]["value"] or "").strip() if a else ""
            if not rl:
                continue
            if rl == self.title:
                continue                     # 제목행이 데이터행으로 잡힌 경우
            self.row_labels[r] = rl
            for c in row_cells:
                if c["col"] not in self.col_labels:
                    continue
                v = as_number(c["value"])
                if v is None:
                    continue
                self.matrix.append((rl, self.col_labels[c["col"]], v, c["cell_ref"]))

    # ── 조회 ────────────────────────────────────────────────────────────
    @property
    def values(self):
        return {v for _, _, v, _ in self.matrix}

    @property
    def cell_count(self):
        return len(self.matrix)

    @property
    def row_axis(self):
        seen = []
        for _, rl in sorted(self.row_labels.items()):
            if rl not in seen:
                seen.append(rl)
        return seen

    @property
    def col_axis(self):
        seen = []
        for lab in self.col_labels.values():
            if lab not in seen:
                seen.append(lab)
        return seen

    def key(self):
        return (self.sheet, self.block_id)

    def __repr__(self):
        return "<Block %s/%s %r %dx%d=%d %s>" % (
            self.sheet, self.block_id, self.title[:22],
            len(self.row_axis), len(self.col_axis), self.cell_count, self.geometry)


def check_authority():
    """권위 판본 확인 — 260822_1 이 아니면 멈춘다(spec.md §2.4 · REQ-PG-014)."""
    with open(MANIFEST, encoding="utf-8") as fh:
        man = json.load(fh)
    got = man.get("authority_version")
    if got != EXPECT_AUTHORITY:
        raise SystemExit(
            "권위 판본 불일치: manifest=%r · 기대=%r — 260822_1 이 아닌 추출본이다. 멈춘다."
            % (got, EXPECT_AUTHORITY))
    return man


def load_blocks(only_sheet=None):
    """L1 추출본 전건을 Block 목록으로 읽는다."""
    check_authority()
    blocks = OrderedDict()

    for path in sorted(glob.glob(os.path.join(L1_DIR, "*-l1.csv"))):
        stem = os.path.basename(path)[:-len("-l1.csv")]
        meta_path = os.path.join(L1_DIR, stem + "-l1-meta.csv")
        metas = {}
        if os.path.exists(meta_path):
            with open(meta_path, encoding="utf-8-sig", newline="") as fh:
                for row in csv.DictReader(fh):
                    if row.get("type") != "block":
                        continue
                    try:
                        metas[row["block_id"]] = json.loads(row["meta_json"] or "{}")
                    except Exception:
                        metas[row["block_id"]] = {}

        with open(path, encoding="utf-8-sig", newline="") as fh:
            for row in csv.DictReader(fh):
                sheet = (row.get("sheet") or "").strip()
                if only_sheet and sheet != only_sheet:
                    continue
                bid = (row.get("block_id") or "").strip()
                if not bid:
                    continue
                k = (sheet, bid)
                if k not in blocks:
                    b = Block(sheet, bid, metas.get(bid))
                    if not b.title:
                        b.title = (row.get("block_title") or "").strip()
                    b.source_file = os.path.basename(path)
                    blocks[k] = b
                blocks[k].cells.append(row)

    out = [b.resolve() for b in blocks.values()]
    return out


def main():
    import argparse
    ap = argparse.ArgumentParser(description="권위 L1 하위표 인벤토리")
    ap.add_argument("--sheet", help="한 시트만")
    ap.add_argument("--csv", help="인벤토리를 CSV 로 저장")
    a = ap.parse_args()

    man = check_authority()
    blocks = load_blocks(a.sheet)
    print("권위 판본 %s — 가격표 %s"
          % (man["authority_version"], man["sources"]["price_table"]["source_file"]))
    print("=" * 92)
    n_dec = sum(1 for b in blocks if b.geometry == "declared")
    n_rec = sum(1 for b in blocks if b.geometry == "recovered")
    n_un = sum(1 for b in blocks if b.geometry == "unresolved")
    tot = sum(b.cell_count for b in blocks)
    print("  하위표 %d개 — 기하 declared %d · recovered %d · unresolved %d · 수치셀 %d"
          % (len(blocks), n_dec, n_rec, n_un, tot))
    print("=" * 92)
    cur = None
    for b in blocks:
        if b.sheet != cur:
            cur = b.sheet
            print("\n[%s]" % cur)
        print("  %-4s %-9s %3d행 x %3d열 = %5d셀  %s"
              % (b.block_id, b.geometry, len(b.row_axis), len(b.col_axis),
                 b.cell_count, b.title[:44]))

    if a.csv:
        with open(a.csv, "w", encoding="utf-8-sig", newline="") as fh:
            w = csv.writer(fh)
            w.writerow(["sheet", "block_id", "title", "geometry", "band_depth",
                        "n_rows", "n_cols", "n_cells", "header_row", "source_file", "notes"])
            for b in blocks:
                w.writerow([b.sheet, b.block_id, b.title, b.geometry, b.band_depth,
                            len(b.row_axis), len(b.col_axis), b.cell_count,
                            b.header_row_no, getattr(b, "source_file", ""),
                            " | ".join(b.notes)])
        print("\n→ %s" % a.csv)


if __name__ == "__main__":
    main()
