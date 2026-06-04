# 전수 대조 방법 설계서 (산출물 C) — 규칙 기반 expected-vs-actual 자동 정합 검증

작성: 2026-06-05 · round-3 매핑 정합 검증 방법론 재설계 산출물 C.
설명 한국어, 식별자/컬럼/코드/SQL/의사코드 영어. **이 문서는 설계서다 — 전수 실행·프로덕션 코드 작성 아님.** 핵심 의사코드까지.
**DB 적재 절대 금지. read-only만.** 라이브 추출은 신선도 기록 후 스냅샷 작업, 결정적 존재판정만 read-only 재확증.

---

## ① 요약

### 무엇을 설계하나
B 규칙사전(28규칙)을 **코드(스크립트)로 구현하기 위한 청사진**이다. 입력은 엑셀 파싱본(260상품) + DB 적재 스냅샷(ref-*.csv), 출력은 상품×속성 MATCH/MISSING/EXTRA/MISMATCH 매트릭스 + 명세 CSV + 신뢰도 대시보드다.

### 프레임 (HARD — 핸드오프 §3 교정)
> 비교 기준은 **엑셀 셀집합이 아니라 B 규칙이 산출한 expected rows**다.
> `MISSING = (규칙으로 변환한 expected) − (DB actual)` = "규칙대로면 적재됐어야 할 누락분".
> 엑셀≠DB가 곧 DB 오류가 아니다 — 정규화 변환 결과일 수 있다(R-SIZE-4 비치수 옵션, R-PROC-7 노이즈 등은 배제 사전으로 사전 제거).

### 핵심 설계 결정
1. **파이프라인 7단계** (Extract → Normalize-Key → Rule-Transform → Integrity-Gate → 3-Layer-Diff → Classify → Report). 단계별 입출력 데이터 형태를 §②에 명시.
2. **규칙 코드화 단위 = 7개 변환함수군** (proc / mat / size / clr / set / cod / addon), 각 함수군이 B의 28규칙을 흡수. 우선순위는 B §⑥대로 **R-PROC-2(줄수/개수=공정 존재 신호) 최우선** — 1차 결함 검출력 최상.
3. **배제 사전 7항목**으로 거짓 MISSING/EXTRA 사전 차단.
4. **1차 결함(상쇄형 누락 은폐)이 구조적으로 재발 불가**함을 §⑦에서 논증: ① 비교 기준이 엑셀셀→expected rows로 바뀌어 "1줄/2개"가 더 이상 "과적재 옵션"이 아니라 "공정 존재 신호 expected row"가 되고, ② count 단독 통과를 금지(set+value 3계층 강제)하며, ③ EXTRA를 잉여 단정 전 규칙 재검토 분기를 둔다.

### C가 의존하는 미해결 전제 (B §⑤ 중 C 영향분 — §⑧에 상세)
R-MAT-2 IMPORT 컬럼-상품 매핑(#1), 중철책자 sets 0행 구조 확증(#2), 공정택일그룹 권위 부재(#3), 줄수형 블록 순서 의존(#4). 이들은 전수 실행 전 확정/플래그 처리 필요.

---

## ② 파이프라인 아키텍처 (단계별 입출력)

총 **7단계**. 각 단계는 멱등(idempotent)·read-only·CSV 중간산출로 재현 가능.

```
[S0 입력]
  excel:  04_audit/excel-{size,material,print-option,process,plate-size,bundle-qty,page-rule,addl-product}.csv
          스키마: (sheet, gubun, prd_nm, mes_item_cd, source_values[\| 구분])
  actual: 00_schema/ref-product-{sizes,materials,processes,print-options,plate-sizes,
          bundle-qtys,page-rules,addons,process-excl-groups,sets}.csv
  master: 00_schema/ref-{sizes,materials,processes,color-counts,base-codes,product-sets}.csv
  join:   00_schema/ref-products.csv (prd_nm → prd_cd 해소)
  bridge: 04_audit/import-resolution.csv (R-MAT-2), 가격표 판걸이수(R-SIZE-2, 참조)

   │
   ▼
[S1 Extract & Tokenize]  (속성별 독립)
  입력: excel-*.csv 1개
  처리: source_values를 ` \| ` 로 split → 토큰 리스트. 빈셀=빈리스트(스킵 후보).
  출력: tokens[<attr>]  형태 = (prd_nm, sheet, gubun, token_idx, raw_token)
        예) (프리미엄엽서, 디지털인쇄, 엽서, 3, "1줄")

   │
   ▼
[S2 Normalize Join-Key]  (전 속성 공통)
  입력: tokens + ref-products.csv
  처리: prd_nm 정규화 norm_prd_nm = trim + collapse_space + 전각→반각 (괄호표기 보존)
        → ref-products의 norm_prd_nm 으로 prd_cd 해소.
        해소 실패 = UNRESOLVED_PRD 플래그(분류 제외, 별도 리포트).
  출력: tokens with (prd_cd, norm_prd_nm)

   │
   ▼
[S3 Rule-Transform → expected rows]   ★C의 심장 (§③ 규칙 코드화)
  입력: tokens(prd_cd 해소됨) + master ref-*.csv + 배제 사전(§⑥)
  처리: 속성별 변환함수군 적용 (우선순위 R-PROC-2 first). 배제 사전 통과 토큰만 변환.
        토큰 → 0~N개의 expected row 산출 (1토큰=N행 가능: 줄수블록→2공정 등).
  출력: expected_<attr>.csv  — actual ref-*.csv와 **동일 shape의 자연키 컬럼**(§④)
        + 추적컬럼 (src_token, rule_id)

   │
   ▼
[S4 Integrity Gate]   (값 대조 前 선행 — A §③)
  입력: actual ref-*.csv (+ master)
  처리: not_null / unique / accepted_values(코드 도메인) / relationships(FK→master) 4종.
        위반 = INTEGRITY_VIOLATION 리포트(값 대조 차단 아님, 동반 출력).
  출력: integrity-violations.csv (속성별)

   │
   ▼
[S5 3-Layer Diff]   (expected ⨝ actual, A §4.2)
  입력: expected_<attr>.csv + actual ref-*.csv
  처리: L1 count(스크리닝, 단독판정 금지) → L2 set(자연키 차집합) → L3 value(교집합 필드대조)
  출력: diff_<attr>.csv  (key, layer, side: expected|actual|both, fields...)

   │
   ▼
[S6 Classify]   (4분류 + EXTRA 재검토 분기)
  입력: diff_<attr>.csv
  처리: expected−actual=MISSING / actual−expected=EXTRA(→재검토 분기) / 교집합 value일치=MATCH / 불일치=MISMATCH
  출력: classified_<attr>.csv (prd_nm, prd_cd, attr, 분류, 엑셀토큰, 기대코드, 실제코드, rule_id, note)

   │
   ▼
[S7 Report]
  입력: classified_*.csv 9속성 + integrity-violations + unresolved + 배제로그
  출력: 05_method/out/ 상품×속성 매트릭스 CSV + audit-dashboard.md(속성별 집계·신뢰도등급·핫스팟)
```

**그레인(grain) 원칙(A §2.1)**: expected와 actual은 반드시 같은 grain·같은 코드값 공간으로 맞춘 뒤 대조한다. 예: 공정은 `(prd_cd, proc_cd)` grain, 사이즈는 `(prd_cd, siz_cd)` grain. 파라미터(줄수/면/박크기 등 `prcs_dtl_opt`)는 grain에 넣지 않고 L3 value 대조 대상으로만 둔다(존재여부가 1차 검증축).

---

## ③ 규칙 코드화 설계 (B 28규칙 → 코드 표현)

### 코드화 단위 = 7개 변환함수군

B의 28규칙을 속성 도메인별 **변환함수군**으로 묶는다. 각 함수군 = `transform_<domain>(token, prd_cd, master, exclude_dict) -> list[expected_row]`. 같은 시트 전체 동일 적용(시트 칸 구조 기반)이므로 함수는 prd_cd 무관, 토큰 패턴만 본다(시트 헤더 앵커는 R-PROC-2 블록순서에만 사용).

| 함수군 | 흡수 규칙 | 출력 grain | 핵심 변환 |
|--------|----------|-----------|-----------|
| `transform_proc` | R-PROC-1~7, R-PROC-3(별색) | (prd_cd, proc_cd) | enum 매치 + **줄수/개수 신호** + 별색 강제라우팅 |
| `transform_mat` | R-MAT-1~5 | (prd_cd, mat_cd, usage_cd) | 종이명 매치 + `*별도설정`→IMPORT + 복합 2축분해 |
| `transform_size` | R-SIZE-1~6 | (prd_cd, siz_cd) | 치수 정규화 매치 + 복합분해 + 비치수 배제 |
| `transform_clr` | R-CLR-1~3 | (prd_cd, print_side, front/back_colrcnt_cd) | 인쇄면→도수쌍 |
| `transform_set` | R-SET-1~3 | (prd_cd, sub_prd_cd) | 2축→sub_prd (책자/포토북/문구 시트) |
| `transform_cod` | R-COD-1~4, R-PSG-1~2 | 속성별 FK 컬럼 | 단위/유형/택일그룹 코드 정규화 |
| `transform_addon` | (addon) | (prd_cd, addon_prd_cd) | 봉투명 정규화 매칭(brittle, 신뢰도 하향) |

### 규칙 코드화 우선순위 (B §⑥ — 결함 검출력 순)

#### 우선순위 1 — R-PROC-2 (줄수/개수 = 공정 존재 신호) [HARD · 결함 핵심]

```pseudo
# 시트별 공정 컬럼 헤더 앵커 테이블 (블록 순서 → 부모공정). 시트마다 다를 수 있음(§⑧ #4).
ANCHOR = {
  "디지털인쇄": [ ... , ("줄수블록#1","오시",PROC_000029), ("줄수블록#2","미싱",PROC_000030),
                 ("개수블록#1","가변텍스트",PROC_000031), ("개수블록#2","가변이미지",PROC_000032) ],
}
def transform_proc_signal(tokens_of_prd, sheet):
    expected = []
    line_blocks = group_consecutive(tokens, pattern=r'^\d+줄$', anchor="없음")  # 없음|1줄|2줄|3줄
    cnt_blocks  = group_consecutive(tokens, pattern=r'^\d+개$', anchor="없음")  # 없음|1개|2개|3개
    for i, blk in enumerate(line_blocks):   # 블록 순서로 오시(0)/미싱(1)
        proc = ANCHOR[sheet].line_proc(i)   # PROC_000029 / PROC_000030
        expected.append( ExpRow(prd_cd, proc, src=blk.tokens, rule="R-PROC-2",
                                param={"줄수": blk.max_n}) )
    for i, blk in enumerate(cnt_blocks):    # 가변텍스트(0)/가변이미지(1)
        proc = ANCHOR[sheet].cnt_proc(i)    # PROC_000031 / PROC_000032
        expected.append( ExpRow(prd_cd, proc, src=blk.tokens, rule="R-PROC-2",
                                param={"개수": blk.max_n}) )
    return expected
```
- **검출 논리**: `\d+줄`/`\d+개` 블록 존재 → 공정 존재 expected row. actual에 그 proc_cd 없으면 MISSING. 프리미엄엽서: 줄수블록2+개수블록2 → expected {29,30,31,32}, actual {27,28}만 → **MISSING 4 자동 검출**.
- **마스터 정합 게이트**: 생성한 proc_cd가 `ref-processes.csv`에 존재 + `prcs_dtl_opt`의 `줄수/개수 max` ≥ blk.max_n 확인(범위 초과=MISMATCH).

#### 우선순위 2 — R-MAT-2 (`*별도설정` → IMPORT 실자재)

```pseudo
def transform_mat_placeholder(token, prd_cd, import_resolution):
    if token.strip() == "*별도설정":
        papers = import_resolution.papers_for(prd_cd)   # IMPORT ● 종이 리스트 (미확정시 §⑧ #1)
        return [ ExpRow(prd_cd, mat_lookup(p), usage="USAGE.01", src="*별도설정",
                        rule="R-MAT-2") for p in papers ]
    return None  # 다른 규칙으로
```
- 1차 검증이 `*별도설정`을 "플레이스홀더→제외(빈값)"로 처리해 자재 MISSING 전량을 가린 결함 차단. 프리미엄엽서 자재 actual 0행 → IMPORT ● 종이 N개 expected → MISSING N.
- **미해결(§⑧ #1)**: IMPORT 컬럼-상품 매핑 미확정 시 expected를 "MISSING 후보(신뢰도 보류)"로 표기.

#### 우선순위 3 — R-PROC-1/3/4/5/6 (명칭 enum → leaf proc_cd)

```pseudo
def transform_proc_enum(token, master_proc):
    if excluded(token): return None                 # 배제 사전(§⑥)
    if token in SPECIAL_COLOR_5:                     # 화이트/클리어/핑크/금색/은색 (R-PROC-3 별색)
        return [ExpRow(prd_cd, color_to_child(token), rule="R-PROC-3")]  # PROC_000008~012
    leaf = master_proc.match_leaf_by_name(strip_paren(token))  # 부모(upr 빈값) 미적재, 자식 leaf만
    if leaf: return [ExpRow(prd_cd, leaf.proc_cd, param=paren_param(token), rule="R-PROC-1/4/5/6")]
    return None
```
- 부모 미적재 규칙: `match_leaf_by_name`은 `upr_proc_cd` 비어있지 않은(=자식) row만 후보. 박/코팅/제본 자식 enum, 코팅 면 파라미터는 괄호에서 추출.

#### 우선순위 4 — R-SIZE-1/3/6 (치수 정규화 매칭)

```pseudo
def transform_size(token, master_siz):
    if size_excluded(token): return None             # 사용자입력/★/온스/ml/팩/폰모델 (R-SIZE-4/5)
    for sub in split_complex(token):                 # "73x98 / 100x150" 복합분해 (R-SIZE-6)
        norm = lower(replace(replace(sub,' ',''),'mm',''))   # "73 x 98 mm" → "73x98"
        norm = extract_paren_dim(norm)               # "A4(210x297)" → "210x297" (R-SIZE-3)
        siz = master_siz.match_by_siz_nm(norm)       # cut 기준 siz_nm
        if siz: yield ExpRow(prd_cd, siz.siz_cd, rule="R-SIZE-1")
```

#### 우선순위 5 — R-CLR-1/2/3 (인쇄면 → 도수쌍)
```pseudo
def transform_clr(token):
    if token=="단면": return ExpRow(prd_cd, side="단면", front="CLR_000005", back="CLR_000001")
    if token=="양면": return ExpRow(prd_cd, side="양면", front="CLR_000005", back="CLR_000005")
    if m:=match_dorae(token): return ExpRow(... front=clr_by_chnl(m), ...)  # 1도/2도 등
```

#### 우선순위 6 — R-SET-1 (2축 → sub_prd)
- 책자/포토북/문구 시트 상품은 sets 보유 기대. actual 0행 = MISSING. **중철책자 PRD_000068 예외 플래그**(§⑧ #2): 단일 반제품 구조 가능성 → 라이브 확증 전 "MISSING 의심(보류)"로만 분류.

#### 우선순위 7 — R-COD-1~4 / R-PSG (코드 FK 정규화)
- 마스터 enum 매핑표(딕셔너리)로 정규화: `매/권/세트/EA → QTY_UNIT.01~04`, `출력용지규격 → OUTPUT_PAPER_TYPE.01~03`, `자재유형→MAT_TYPE`, `용도→USAGE`.
- **R-PSG(공정택일그룹)은 엑셀 원천 부재(§⑧ #3) → expected 자동산출 불가.** "추론 매핑 vs DB 실제" 일치만 점검(반자동), MISSING 자동검출 대상에서 제외 → CONFIRM 플래그.

### 규칙 표현 방식 요약
- **규칙 테이블(dict)**: 코드값 매핑(도수쌍, QTY_UNIT, 별색 5종, 시트별 ANCHOR) = 데이터로 외부화 → 시트 추가 시 코드 수정 없이 테이블만 확장.
- **변환함수(7군)**: 토큰 패턴 분기·N행 산출 로직.
- **배제 정규식 사전(§⑥)**: 변환 진입 전 게이트.

---

## ④ 기대행 생성 스키마 (9속성별 자연키·컬럼)

expected_<attr>.csv는 actual ref-*.csv와 **동일 shape의 자연키 컬럼 + 추적컬럼(src_token, rule_id)**으로 산출한다. JOIN KEY = `prd_nm`(정규화) → `prd_cd`. 아래 자연키 = 집합대조 키, value컬럼 = L3 필드대조 대상.

| 속성 | actual 테이블 | 자연키(set 대조) | value(L3 대조) | expected 산출 규칙 |
|------|--------------|-----------------|----------------|-------------------|
| 사이즈 | ref-product-sizes | (prd_cd, **siz_cd**) | dflt_yn, disp_seq | R-SIZE-1/3/6 |
| 자재 | ref-product-materials | (prd_cd, **mat_cd, usage_cd**) | dep_proc_cd, dflt_yn | R-MAT-1~5 |
| 인쇄옵션 | ref-product-print-options | (prd_cd, **print_side**) | front_colrcnt_cd, back_colrcnt_cd | R-CLR-1~3 |
| 공정 | ref-product-processes | (prd_cd, **proc_cd**) | excl_grp_cd, mand_proc_yn, param(prcs_dtl_opt) | R-PROC-1~6 |
| 공정택일그룹 | ref-product-process-excl-groups | (prd_cd, **excl_grp_cd**) | sel_typ_cd, max_sel_cnt, mand_yn | R-PSG(반자동·CONFIRM) |
| 판형사이즈 | ref-product-plate-sizes | (prd_cd, **siz_cd**) | output_paper_typ_cd, output_file_typ | R-COD-2 (의미축 주의·CONDITIONAL) |
| 묶음수 | ref-product-bundle-qtys | (prd_cd, **bdl_qty, bdl_unit_typ_cd**) | dflt_yn | R-COD-1 |
| 페이지룰 | ref-product-page-rules | (prd_cd) ※1:1 | page_min, page_max, page_incr | (가변구조 unpivot) |
| 추가상품 | ref-product-addons | (prd_cd, **addon_prd_cd**) | disp_seq, note | addon 매칭(brittle) |

부속(1층 기초데이터) — 마스터 자체 무결성은 S4 게이트가 본다:
- 상품셋트 ref-product-sets: (prd_cd, **sub_prd_cd**) | sub_prd_qty, disp_seq | R-SET-1~3.

**reg_dt/upd_dt 등 적재 메타컬럼은 자연키·value 대조에서 제외**(타임스탬프는 정합 무관). expected는 자연키+도메인 value만 채우고 NULL로 둔다.

### 판형사이즈 의미축 주의 (CONDITIONAL)
엑셀 plate-size `316x467`(전지)는 `t_siz` 마스터에 없는 의미축이고, DB `ref-product-plate-sizes.siz_cd`(예 SIZ_000112)는 작업사이즈(cut+블리드)다. 따라서 **엑셀 전지값을 siz_cd로 직접 매칭하면 전건 MISMATCH 오탐**. 이 속성은 set 대조 보류, "엑셀 전지 ↔ DB 작업사이즈" 의미축 매핑표 확정 전까지 CONDITIONAL 플래그(자동 MISSING 산출 안 함).

---

## ⑤ 3계층 대조 + 무결성 게이트 + EXTRA 재검토

### 무결성 게이트 (S4 — 값 대조 前 선행, A §③)
actual ref-*.csv에 대해 4종 선행(위반은 동반 리포트, 대조는 계속):
1. **not_null**: 자연키·필수 코드 컬럼 빈값/공백 = 침묵 결함 신호(위젯 메모리 교훈).
2. **unique**: 자연키 조합 중복 = count 부풀림 + set대조 EXTRA 양산.
3. **accepted_values**: 코드값이 master 도메인(ref-processes/sizes/materials/base-codes/color-counts)에 존재 — 이형/오타 코드 = MISMATCH 숨은 원인.
4. **relationships(FK)**: 자식 코드값이 부모 master에 존재 — 고아 FK = EXTRA 의심.

### 3계층 대조 (S5)
```pseudo
def diff(expected, actual, natural_key, value_cols):
    # L1 count — 스크리닝 (단독 판정 금지: 중복+누락 상쇄 위험)
    log_count(len(expected), len(actual))
    e = index_by(expected, natural_key); a = index_by(actual, natural_key)
    # L2 set — 자연키 차집합
    missing = e.keys - a.keys      # expected − actual
    extra   = a.keys - e.keys      # actual − expected → 재검토 분기
    both    = e.keys & a.keys
    # L3 value — 교집합 필드대조
    for k in both:
        yield ("MATCH" if e[k][value_cols]==a[k][value_cols] else "MISMATCH", k, e[k], a[k])
    for k in missing: yield ("MISSING", k, e[k], None)
    for k in extra:   yield ("EXTRA",   k, None, a[k])
```
- **L1 count 단독 통과 금지(HARD)**: 1차 결함의 한 축이 "건수만 보고 통과". set·value까지 강제 → 상쇄형 누락(중복+누락 동시) 검출.

### EXTRA 재검토 분기 (A §4.3 원칙)
EXTRA를 "엑셀에 없으니 잉여"로 단정 금지. 분기:
```pseudo
def review_extra(extra_key, attr):
    if produced_by_cascade_or_derivation(extra_key, attr):  # 정규화 파생(별색 자식, 도수쌍 등)
        return "EXTRA→규칙누락 재검토"   # 변환규칙이 이 행을 산출했어야 하는가? → 규칙 보강 후보
    if orphan_fk(extra_key): return "EXTRA→고아FK(무결성)"
    if duplicate(extra_key): return "EXTRA→중복(dedup)"
    return "EXTRA→플래그(잉여 의심, 삭제 단정 금지)"   # 핸드오프 §1
```

---

## ⑥ 배제 사전 (false-positive 차단 — 7항목)

거짓 MISSING/EXTRA를 변환 진입 전 차단. B §⑥ 배제 사전 + §⑤ 미해결 케이스 반영. **배제는 "삭제"가 아니라 "비매핑 분류 + 배제로그 기록"** — 추적성 유지.

| # | 항목 | 패턴/조건 | 처리 | 근거 규칙 |
|---|------|----------|------|----------|
| 1 | 공정 비명칭 노이즈 | `^\*`(가격표참고) · 순수수치 `^[\d/ .]+$` · `0.0` | 공정 매핑 배제 | R-PROC-7 |
| 2 | 사이즈 비치수 옵션축 | `사용자입력` · `★` · `온스`/`oz` · `ml` · `팩` · 폰모델 토큰 | size 매핑 배제(별도 옵션축, 거짓 MISSING 방지) | R-SIZE-4 |
| 3 | 사이즈 가변치수(범위) | `\d+~\d+`(예 `200~3000`) · 가로/세로 입력형 | 고정 siz_cd 매핑 배제(nonspec/면적축) | R-SIZE-5 |
| 4 | 자재 `*별도설정` 빈값오처리 | token=`*별도설정` | **빈값 처리 금지** → IMPORT 라우팅(배제 아님, 재라우팅) | R-MAT-2 |
| 5 | 공정택일그룹 자동산출 | 전 토큰 | **expected 자동산출 보류**(엑셀 원천 부재) → CONFIRM, 반자동 점검만 | R-PSG, §⑧ #3 |
| 6 | round-2 variant(component_prices) | 거울 S/M/L · 머그 색상 등 가격차원 토큰 | 9속성 매핑축 배제(가격 round-2 귀속) | B §⑤ #6 |
| 7 | 판형 전지 의미축 | plate-size 엑셀값(전지) | set 자동대조 보류 → CONDITIONAL(의미축 매핑표 확정 전) | R-COD-2, §④ |

배제로그: `out/excluded-tokens.csv (prd_nm, attr, raw_token, exclude_reason, rule_id)` — 사후 검토로 "잘못 배제"를 잡을 수 있게.

---

## ⑦ 출력 산출물 설계 + 1차 결함 재발불가 논증

### 출력 산출물
모두 `05_method/out/` (또는 향후 하네스 `scripts/out/`):

1. **상품별 명세 CSV** `out/classified-<attr>.csv` (속성별 9개)
   스키마: `prd_nm, prd_cd, attr, 분류(MATCH/MISSING/EXTRA/MISMATCH), 엑셀토큰(src_token), 기대코드(expected_key), 실제코드(actual_key), rule_id, note`.
2. **상품×속성 매트릭스** `out/matrix.csv`
   스키마: `prd_nm, prd_cd, size{m/x/mm}, material{...}, ... 9속성` (각 셀 = MATCH n / MISSING n / EXTRA n / MISMATCH n).
3. **속성별 대시보드** `out/audit-dashboard.md`
   - 속성별 집계 (MATCH/MISSING/EXTRA/MISMATCH 건수·상품수)
   - 규칙별 적용 건수 + 검출 MISSING 수 (R-PROC-2가 몇 건 잡았나 = 결함 검출 회귀지표)
   - 핫스팟 (MISSING/EXTRA 상위 상품·속성)
   - **신뢰도 등급** (속성별):
     | 등급 | 조건 |
     |------|------|
     | A (확정) | 배제·미해결 전제 없음, master 정합 게이트 통과 (예: 사이즈·인쇄옵션·공정 enum) |
     | B (조건부) | 의미축/브리지 의존 (판형 CONDITIONAL, 자재 R-MAT-2 IMPORT 미확정) |
     | C (보류) | 엑셀 원천 부재·반자동 (공정택일그룹 CONFIRM, addon brittle 매칭) |
4. **부속 리포트**: `integrity-violations.csv`, `unresolved-prd.csv`, `excluded-tokens.csv`.

### 1차 결함(누락 은폐) 재발불가 논증 — 구조적 3중 방어
1차 결함 = "엑셀 옵션값(1줄/2개)을 과적재 옵션으로 제외 → 그 공정의 MISSING을 못 봄"(상쇄형 누락 은폐).

- **방어 1 — 비교 기준 전환 (프레임)**: 비교 기준이 "엑셀 셀집합"이 아니라 "B 규칙이 산출한 expected rows"다. R-PROC-2가 `1줄/2개`를 **"공정 존재 신호 → expected row(PROC_000029~032)"**로 변환하므로, "옵션값이라 제외"라는 판단 자체가 파이프라인에서 불가능해진다(토큰이 expected row가 됨). → 1차의 제외 오판 경로가 코드상 존재하지 않음.
- **방어 2 — count 단독 통과 금지 (3계층 강제)**: S5가 L2 set·L3 value를 무조건 산출한다. 건수만 맞아도 자연키 차집합(expected−actual)이 MISSING을 드러낸다. 프리미엄엽서 expected{27,28,29,30,31,32} − actual{27,28} = MISSING{29,30,31,32}가 기계적으로 출력된다.
- **방어 3 — EXTRA 재검토 분기**: 정규화 파생행을 "엑셀에 없다"고 잉여 단정하던 경로를, "규칙이 산출했어야 하는가" 재검토로 바꿔 규칙 누락을 역으로 노출.

추가로 **회귀 게이트**: 대시보드의 "R-PROC-2 검출 MISSING 수"가 프리미엄엽서 4 + 명함 2 ≥ 6을 만족해야 통과. 이 수치가 0으로 떨어지면 규칙 코드화가 퇴행한 신호 → 전수 실행 차단.

---

## ⑧ 실행 환경 권고 + 다음 단계 연결

### 실행 환경
- **언어/위치**: Python 3 (pandas) 권장 — split/melt/lookup/set 연산이 자연스럽고 CSV in/out 멱등. 위치 = `05_method/scripts/`(설계 검증용) → 향후 하네스 정식화 시 `scripts/audit/`로 승격. 외부 의존 최소(pandas만).
- **입력**: §② S0 명시. 엑셀 파싱본·ref-*.csv 스냅샷 재사용. **DB 라이브는 결정적 존재판정만 read-only SELECT**(§⑧ #1/#2 확정용), 신선도(추출 일시)를 매 실행 헤더에 기록(stale 권위반전 방지).
- **멱등성·재현성**: 각 단계 CSV 중간산출 → 재실행 시 동일 입력→동일 출력. 규칙 테이블/ANCHOR/배제 사전을 데이터로 외부화 → 코드 변경 없이 규칙 조정·재현.
- **[HARD] DB 적재 없음**: INSERT/UPDATE/DDL 금지. no reverse load(A §③). 산출은 expected/diff/classified CSV + md만.

### C가 의존하는 미해결 전제 (B §⑤ 중 C 영향분)
전수 실행 **전** 확정/플래그 필요:
1. **R-MAT-2 IMPORT 컬럼-상품 매핑(B §⑤ #1)**: `import-resolution.csv`의 어느 ● 종이가 어느 prd_cd에 붙는지 컬럼-상품 매핑 미확정 → 자재 expected가 "MISSING 후보(신뢰도 B)"까지만. **전수 실행 전 IMPORT 컬럼↔상품 매핑 확정 필요**.
2. **중철책자 PRD_000068 sets 0행(B §⑤ #2)**: R-SET-1상 MISSING 의심이나 단일 반제품 구조 가능성 → 라이브 prd 구조 read-only 확증 후 "MISSING vs 정상" 확정. 미확정 시 보류 플래그.
3. **공정택일그룹 권위 부재(B §⑤ #3, R-PSG)**: 엑셀 원천 컬럼 없음 → expected 자동산출 불가. C는 "추론 매핑 vs DB 실제" 반자동 점검만(CONFIRM 등급). 권위 소스 확정 전 자동 MISSING 판정 금지.
4. **줄수형 블록 순서 의존(B §⑤ #4)**: R-PROC-2가 동일 `1줄~3줄` 블록 2개를 순서(첫=오시·둘째=미싱)로 구분 → 시트별 공정 컬럼 헤더 ANCHOR 테이블이 전수 실행 전 시트마다 확정 필요. 헤더 앵커 부재 시 그 시트는 보류.

(B §⑤ #5 비치수 옵션축 재판정·#6 variant·#7 addon brittle 매칭은 배제 사전 #2/#6/추가상품 신뢰도 C로 흡수 — C 설계 내 처리 완료.)

### 다음 단계 연결
```
[현재] A(리서치)·B(규칙사전)·C(본 설계서) 산출
   → 사용자 검토·승인
   → [하네스 개선] dbm-mapping-audit 프레임 교정("엑셀=권위"→"DB정규화규칙=기준")
                   + 리서치/규칙코드화 단계 신설 + ANCHOR/IMPORT매핑/sets확증 미해결 4건 해소
   → [전수 실행] §② 파이프라인을 scripts/로 구현 → 260상품 expected 생성 → 대조 → 대시보드
   → dbm-validator 독립 재검증 (회귀 게이트: R-PROC-2 MISSING≥6 확인)
```
**전수 실행·구현은 본 설계서 범위 밖**(하네스 개선 후, 사용자 검토 통과 시). C는 설계·명세·핵심 의사코드까지다.
