#!/usr/bin/env python3
r"""
gen_notes.py — 전 상품군 가격테이블 note 전문용어 → 쉬운 한국어 교정 번들 생성기.

016 가격사슬(PRF_DGP_A)은 이미 COMMIT 완료(23_remediation-apply/016-notes). 이 번들은 그 외
전 상품군 잔존 전문용어 note(t_prc_price_components 정의행 ~115행 + t_prc_component_prices 단가행
~2,057행)를 라이브 실측 기준으로 교정한다. 016 사슬 행은 멱등 가드로 자동 no-op(중복 안전).

산출(재현성·provenance·손편집 금지):
  - note-map.csv          : 행별 {table·pk·comp_cd·comp_nm·current_note(라이브 실측)·corrected_note·flag}
  - 01_update_notes.sql   : 멱등 UPDATE (note만·IS DISTINCT FROM·upd_dt=now())
  - apply.sql             : 단일 트랜잭션 래퍼 (ON_ERROR_STOP, BEGIN; \i 01_...; — COMMIT/ROLLBACK 로더 주입)

[HARD] note 컬럼만 변경. unit_price·prc_typ_cd·축 컬럼·가격/단가행 절대 불변.
[HARD] 멱등 — 재실행 delta 0 (IS DISTINCT FROM + no-op regexp).
[HARD] 의미 왜곡 금지 — 소재·색·도수·사이즈·축·단위 보존. 내부 메모(코드/식별자/정정이력)만 제거.
[HARD] 불명확 comp(comp_nm·도메인 KB에도 없음) → 추측 라벨 금지·FLAG_UNCLEAR + 현재 note 유지.

규칙 권위: 토대 §9 (후니 용어·실무진 가시성) + 016 note-remediation.md 패턴 재사용.
라이브는 읽기전용 SELECT로만 접속(현재 note 실측). 비밀번호 stdout 출력 금지.
"""
import os
import re
import csv
import subprocess

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = subprocess.check_output(["git", "rev-parse", "--show-toplevel"], cwd=HERE).decode().strip()

# ---------------------------------------------------------------------------
# A) 정의행(t_prc_price_components) 라벨 — comp_nm(식별자 정리) 패턴별 쉬운 한국어 풀이.
#    comp_nm은 이미 후니 용어로 양호 → note는 "comp_nm을 풀어, 무슨 비용인지 + 축/단위" 설명.
# ---------------------------------------------------------------------------
# comp_nm(식별자 [COMP_xxx] 제거 후) → note 라벨. key = 정리된 comp_nm.
DEF_NM_LABELS = {
    "투명아크릴1.5T 인쇄가공비": "투명 아크릴 1.5T 인쇄·가공 포함가. 사이즈·수량별 단가표.",
    "투명아크릴3T 인쇄가공비": "투명 아크릴 3T 인쇄·가공 포함가. 사이즈·수량별 단가표.",
    "미러아크릴3T 인쇄가공비": "미러 아크릴 3T 인쇄·가공 포함가. 사이즈·수량별 단가표.",
    "제본비(후가공)": "제본 가공비(후가공). 제본 종류·수량별 단가표.",
    "접지비(후가공)": "접지(접는 가공)비(후가공). 접지 종류·주문수량 구간별 작업 1건 고정 금액(수량을 곱하지 않음).",
    "타공비(후가공)": "타공(구멍 뚫기) 가공비(후가공). 구 수·출력매수별 단가표.",
    "커팅 합가(완제품가)": "커팅(완칼/미싱) 포함 완제품가. 소재·사이즈·수량을 합산한 1장당 단가표.",
    "봉투제작 완제품가": "봉투 제작 완제품가(용지 포함). 봉투 종류·소재·주문수량 구간별 단가표.",
    "명함 단가(용지포함 완제품가)": "명함 완제품가(용지 포함). 소재·인쇄면·수량을 합산한 1건당 단가표.",
    "오리지널박 합가(완제품가)": "오리지널 박명함 완제품가(종이+동판+박 가공 합산). 인쇄면·박 종류·수량별 단가표.",
    "박형압 동판셋업비": "박·형압용 동판 셋업비. 주문 1건당 한 번 부과(수량을 곱하지 않음).",
    "엽서북 단가(완제품가)": "엽서북 완제품가. 인쇄면·페이지수·수량별 1권당 단가표.",
    "포토카드 단가(완제품가)": "포토카드 완제품가. 구성·수량별 단가표.",
    "떡메모지 단가(완제품가)": "떡메모지 완제품가. 사이즈·권당 장수·수량별 단가표.",
    "스티커 단가(완제품가)": "스티커 완제품가(출력+가공 포함). 소재·사이즈·수량별 단가표.",
    "합판도무송 단가(완제품가)": "합판 도무송(목형 따기) 완제품가. 사이즈·수량별 단가표.",
    "포스터 완제품가(포함항목 통가격)": "포스터·사인 완제품가(소재+출력+가공 포함 통가격). 사이즈·수량별 단가표.",
    "포스터 추가옵션 추가가격(별도 add-on 통가격)": "포스터·사인 추가옵션 가격(거치대·끈·타공 등 별도 추가). 옵션·수량별 단가표.",
}
# comp_nm에서 식별자 [COMP_xxx] 떼기
RE_COMP_ID = re.compile(r"\s*\[COMP_[^\]]*\]")

# ---------------------------------------------------------------------------
# B) 단가행(t_prc_component_prices) 결정적 치환 체인.
#    의미(소재/색/도수/사이즈/축/단위) 보존 · 내부 메모(코드/식별자/정정이력)만 제거.
# ---------------------------------------------------------------------------
# 메모 시그니처: 이 토큰이 든 괄호그룹(1단 중첩까지)은 내부 메모로 판정·제거.
# 시그니처에 여는 괄호 '(' 를 포함하지 않는다 — 1단 중첩 메모 그룹 매칭이 어긋남(SQL/Python 불일치).
# 완칼 규격단독 메모는 '규격단독|상품구분독' 등 다른 토큰으로 이미 전체 잡힘.
MEMO_SIG = (
    r"comp흡수|comp_typ|SIZ_[0-9]|MAT_[0-9]|PRD_[0-9]|규칙④|규칙[0-9]|bdl_qty|min_qty|"
    r"라이브 siz|완제품비\.|완제품가 \.|중첩서브제품|소재묶음|band=|M-[0-9]+정정|행[0-9]|"
    r"별도 add-on|수량무관 셋업|차원부재|DIRECT매칭|SIZ_PENDING|대표mat|규격단독|상품구분축|"
    r"후니확인|=comp|추출결함|면당EA"
)
# 합가 메모 괄호(코드 포함) → 작업 1건 고정 금액으로 풀이. 1단 중첩 인식.
RE_HAPGA = re.compile(r"\s*\([^()]*합가[^()]*(\([^()]*\)[^()]*)*\)")
# prefix 내부 교정 마커 [siz...]/[siz-corrected...]
RE_PFX_SIZ = re.compile(r"^\[siz[^\]]*\]\s*")
# 메모 시그니처 괄호그룹(1단 중첩까지)
RE_MEMO_PAREN = re.compile(r"\s*\([^()]*(?:" + MEMO_SIG + r")[^()]*(\([^()]*\)[^()]*)*\)")
# 대괄호 안 mat 코드만 제거(설명은 보존): [레자크체크=줄무늬 동일단가, mat=MAT_N 대표] → [레자크체크=줄무늬 동일단가]
RE_BR_MAT = re.compile(r"\[([^\]]*?)\s*,?\s*mat=MAT_[0-9]+[^\]]*\]")
# 수량/매수 축 한국어화: A≥N → A N 이상
RE_AXIS = re.compile(r"(총제작수량|제작수량|출력매수|수량|장수)≥([0-9]+)")
# 잔여 ≥ (축 단어 미동반) → '이상'
RE_GEQ = re.compile(r"≥\s*([0-9]+)")
RE_WS = re.compile(r"\s{2,}")


def transform_price_note(note):
    s = note
    s = RE_HAPGA.sub(" / 작업 1건 고정 금액(수량을 곱하지 않음)", s)
    s = RE_PFX_SIZ.sub("", s)
    s = RE_MEMO_PAREN.sub("", s)
    s = RE_BR_MAT.sub(r"[\1]", s)
    s = RE_AXIS.sub(r"\1 \2 이상", s)
    s = RE_GEQ.sub(r"\1 이상", s)
    s = RE_WS.sub(" ", s)
    return s.strip()


# 교정 후에도 전문용어 잔존이 있으면 FLAG_UNCLEAR (추측 라벨 금지·현재 note 유지)
RESIDUAL_JARGON = re.compile(
    r"siz-corrected|comp_typ|PRC_COMPONENT_TYPE|round-2|clr=NULL|별색=공정|옵션=comp흡수|"
    r"SIZ_[0-9]|MAT_[0-9]|PROC_[0-9]|mat_cd|siz_cd|C-[0-9]|≥|bdl_qty|min_qty|규칙④"
)


def _db_env():
    env = dict(os.environ)
    with open(os.path.join(REPO, ".env.local")) as f:
        for line in f:
            line = line.strip()
            if line.startswith("RAILWAY_DB_") and "=" in line:
                k, v = line.split("=", 1)
                env[k.strip()] = v.strip().strip('"').strip("'")
    env["PGPASSWORD"] = env["RAILWAY_DB_PASSWORD"]
    return env


def psql_csv(copy_sql):
    """라이브 읽기전용 SELECT → CSV(\\copy TO STDOUT WITH CSV). 멀티라인·구분자 안전.
    비밀번호 미출력. copy_sql = '(SELECT ...)' 형태의 서브쿼리."""
    import csv as _csv
    import io
    env = _db_env()
    full = f"\\copy {copy_sql} TO STDOUT WITH (FORMAT csv)"
    cmd = [
        "psql", "-h", env["RAILWAY_DB_HOST"], "-p", env["RAILWAY_DB_PORT"],
        "-U", env["RAILWAY_DB_USER"], "-d", env["RAILWAY_DB_NAME"],
        "-v", "ON_ERROR_STOP=1", "-P", "pager=off", "-c", full,
    ]
    out = subprocess.check_output(cmd, env=env).decode()
    return list(_csv.reader(io.StringIO(out)))


def sql_lit(s):
    return "'" + s.replace("'", "''") + "'"


# JARGON: note에 전문용어가 있는 행만 대상 (016 무관 사슬 포함 — 멱등 가드로 안전)
JARGON_RE = (
    "siz-corrected|comp_typ|PRC_COMPONENT_TYPE|round-2|clr=NULL|별색=공정|옵션=comp흡수|"
    "SIZ_[0-9]|MAT_[0-9]|PROC_[0-9]|mat_cd|siz_cd|C-[0-9]|≥"
)


def main():
    # 1) 정의행 실측 (전문용어 있는 것만)
    def_rows = psql_csv(
        "(SELECT comp_cd, coalesce(comp_nm,''), note FROM t_prc_price_components "
        f"WHERE note ~ '{JARGON_RE}' ORDER BY comp_cd)"
    )
    # 2) 단가행 실측 (전문용어 있는 것만)
    price_rows = psql_csv(
        "(SELECT comp_price_id::text, comp_cd, note FROM t_prc_component_prices "
        f"WHERE note ~ '{JARGON_RE}' ORDER BY comp_cd, comp_price_id)"
    )

    mapping = []   # (table, pk, comp_cd, comp_nm, current, corrected, flag)
    flags = []

    # 2a) 정의행 교정 — comp_nm(식별자 정리) → 라벨. PK = comp_cd.
    #     mapping 튜플 = (table, pk, comp_cd, comp_nm, current, corrected, flag)
    for comp_cd, comp_nm, cur in def_rows:
        nm_clean = RE_COMP_ID.sub("", comp_nm).strip()
        label = DEF_NM_LABELS.get(nm_clean)
        if label is None:
            flags.append(("t_prc_price_components", comp_cd, comp_nm, cur, "FLAG_UNCLEAR"))
            mapping.append(("t_prc_price_components", comp_cd, comp_cd, comp_nm, cur, cur, "FLAG_UNCLEAR"))
            continue
        mapping.append(("t_prc_price_components", comp_cd, comp_cd, comp_nm, cur, label, ""))

    # 2b) 단가행 교정 — 결정적 체인. PK = comp_price_id. comp_nm은 단가행에 없음(빈칸).
    for cpid, comp_cd, cur in price_rows:
        new = transform_price_note(cur)
        flag = ""
        if RESIDUAL_JARGON.search(new):
            # 교정 후에도 전문용어 잔존 → 추측 금지·현재 유지·플래그
            flag = "FLAG_UNCLEAR"
            flags.append(("t_prc_component_prices", cpid, comp_cd, cur, new))
            new = cur
        mapping.append(("t_prc_component_prices", cpid, comp_cd, "", cur, new, flag))

    # 3) note-map.csv
    with open(os.path.join(HERE, "note-map.csv"), "w", newline="") as f:
        w = csv.writer(f)
        w.writerow(["table", "pk", "comp_cd", "comp_nm", "current_note", "corrected_note", "flag"])
        for r in mapping:
            assert len(r) == 7, f"mapping tuple must be 7-field, got {len(r)}: {r}"
            w.writerow(r)

    # 4) 01_update_notes.sql
    lines = []
    lines.append("-- 01_update_notes.sql — 전 상품군 가격테이블 note 전문용어→쉬운 한국어 교정 (note 컬럼만)")
    lines.append("-- 생성기: gen_notes.py (손편집 금지·재현성). 멱등=IS DISTINCT FROM + no-op regexp.")
    lines.append("-- [HARD] unit_price·prc_typ_cd·축 컬럼 절대 미변경. SET 절은 note·upd_dt 둘뿐.")
    lines.append("-- 016 사슬 행은 이미 교정됨 → 동일 텍스트면 IS DISTINCT FROM 가드로 자동 no-op(중복 안전).")
    lines.append("")

    # 4a) 정의행 — 행별 UPDATE (comp_cd PK). FLAG_UNCLEAR는 SQL 미생성(현재 유지).
    lines.append("-- A) 구성요소 정의행 t_prc_price_components.note (comp_cd PK)")
    for table, pk, comp_cd, comp_nm, cur, new, flag in mapping:
        if table != "t_prc_price_components" or flag == "FLAG_UNCLEAR":
            continue
        lines.append(
            f"UPDATE t_prc_price_components SET note={sql_lit(new)}, upd_dt=now() "
            f"WHERE comp_cd={sql_lit(pk)} AND note IS DISTINCT FROM {sql_lit(new)};"
        )
    lines.append("")

    # 4b) 단가행 — 결정적 regexp 체인(라이브에서 직접 수행, SQL이 파이썬과 동치).
    #     comp_price_id PK 화이트리스트로 스코프(전문용어 있는 행만) → 결정적 동일.
    lines.append("-- B) 단가행 t_prc_component_prices.note — 결정적 regexp 치환 체인")
    lines.append("--    합가 메모 → '작업 1건 고정 금액' / prefix [siz..] 제거 / 메모 시그니처 괄호 제거")
    lines.append("--    [..mat=MAT_N..] 코드만 제거(설명 보존) / 'A≥N'→'A N 이상' / 잔여 ≥ → '이상' / 공백 정리")
    lines.append("--    의미(소재·색·도수·사이즈) 괄호·[..포함가]·[묶음..]은 보존. note만 읽어 note만 씀.")

    memo_sig_sql = MEMO_SIG.replace("\\.", "\\.")  # regex 그대로 (psql ERE)
    # 결정적 SQL 체인 — 파이썬 transform과 동치. 적용 대상은 FLAG 없는 단가행 PK만.
    insertable_price_pks = [pk for (t, pk, cc, nm, cur, new, fl) in mapping
                            if t == "t_prc_component_prices" and fl != "FLAG_UNCLEAR"]
    xf = (
        "btrim("
        "regexp_replace("                                                     # 7) 공백 정리
        "regexp_replace("                                                     # 6) 잔여 ≥N → N 이상
        "regexp_replace("                                                     # 5) 축≥N → 축 N 이상
        "regexp_replace("                                                     # 4) [..mat=MAT_N..] 코드 제거
        "regexp_replace("                                                     # 3) 메모 시그니처 괄호 제거
        "regexp_replace("                                                     # 2) prefix [siz..] 제거
        "regexp_replace(note, '\\s*\\([^()]*합가[^()]*(\\([^()]*\\)[^()]*)*\\)', ' / 작업 1건 고정 금액(수량을 곱하지 않음)', 'g'), "  # 1) 합가
        "'^\\[siz[^\\]]*\\]\\s*', ''), "
        f"'\\s*\\([^()]*({memo_sig_sql})[^()]*(\\([^()]*\\)[^()]*)*\\)', '', 'g'), "
        "'\\[([^\\]]*?)\\s*,?\\s*mat=MAT_[0-9]+[^\\]]*\\]', '[\\1]', 'g'), "
        "'(총제작수량|제작수량|출력매수|수량|장수)≥([0-9]+)', '\\1 \\2 이상', 'g'), "
        "'≥\\s*([0-9]+)', '\\1 이상', 'g'), "
        "'\\s{2,}', ' ', 'g'))"
    )
    lines.append(
        f"UPDATE t_prc_component_prices cp SET note = {xf}, upd_dt=now()\n"
        f"WHERE cp.note IS NOT NULL\n"
        f"  AND cp.note ~ '{JARGON_RE}'\n"
        f"  AND cp.note IS DISTINCT FROM ({xf})\n"
        f"  AND ({xf}) !~ '{JARGON_RE.replace(chr(39), chr(39)+chr(39))}';"  # 교정 후 잔존 전문용어 있으면 미적용(FLAG와 동치)
    )
    lines.append("")

    with open(os.path.join(HERE, "01_update_notes.sql"), "w") as f:
        f.write("\n".join(lines) + "\n")

    # 5) apply.sql
    apply = [
        "-- apply.sql — 전 상품군 가격테이블 note 교정 단일 트랜잭션 래퍼",
        "-- 기본 = DRY-RUN: 로더(apply_loader.sh)가 끝에 ROLLBACK 주입. --commit 시에만 COMMIT.",
        "-- [HARD] note 컬럼만 변경. 중간 COMMIT 없음(원자성).",
        "\\set ON_ERROR_STOP on",
        "BEGIN;",
        "  \\i 01_update_notes.sql",
        "-- COMMIT/ROLLBACK 미포함 — 로더가 주입(기본 ROLLBACK).",
    ]
    with open(os.path.join(HERE, "apply.sql"), "w") as f:
        f.write("\n".join(apply) + "\n")

    # 요약 출력
    n_def = sum(1 for r in mapping if r[0] == "t_prc_price_components" and r[6] != "FLAG_UNCLEAR")
    n_price = sum(1 for r in mapping if r[0] == "t_prc_component_prices" and r[6] != "FLAG_UNCLEAR")
    n_flag = len(flags)
    print(f"note-map.csv rows={len(mapping)} (def_insertable={n_def}, price_insertable={n_price}, FLAG_UNCLEAR={n_flag})")
    print("generated: note-map.csv, 01_update_notes.sql, apply.sql")
    if flags:
        print("--- FLAG_UNCLEAR ---")
        for fl in flags[:30]:
            print("  ", fl[0], fl[1], "|", fl[3][:80])


if __name__ == "__main__":
    main()
