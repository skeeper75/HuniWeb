# CPQ Tier A 책자 4상품 옵션 레이어 — 적대적 교차검증 게이트 (round-6)

> **검증가:** `dbm-validator` (생성자 `dbm-option-mapper`와 독립) · **일시** 2026-06-14 라이브 read-only 실측
> **대상:** PRD_000068 중철 · PRD_000069 무선 · PRD_000071 트윈링 · PRD_000094 엽서북
> **검증본:** `10_configurator/tierA/booklet-option-layer.md` (설계) · `09_load/_exec_tierA_booklet/` (실행본)
> **판정: GO** — 게이트 1~6 전건 PASS. 실행본 SQL은 라이브 권위. 단 **설계서/매니페스트 문서 행수 표기 stale (MINOR 2건)** 보정 권고. 실 COMMIT은 인간 승인. **NEVER COMMIT** (DRY-RUN은 ROLLBACK 실증).

---

## 0. 최종 판정

| 항목 | 결과 |
|------|------|
| **GO / NO-GO** | **GO** |
| **뒤집힌 분류 건수** | **0** (생성자 판정 INSERTABLE 140 / BLOCKED 0 = 독립 재확인) |
| INSERTABLE (독립 재집계) | **option_groups 32 · options 140 · option_items 140** |
| BLOCKED (needs L1) | **0** |
| GAP (→ ddl-proposer) | **3** (GAP-DOSU-USAGE · GAP-PARAM · GAP-HIDDEN) |
| [CONFIRM] (→ 리드/사용자) | **3** (C1 094 셋트 BOM · C2 도수 분리방식 · C3 제본 신규생성) — 정직히 에스컬레이션됨 |
| 신규 결함 (MINOR) | **2** (M-1 설계서 §0.1 자재 행수 stale · M-2 매니페스트 §3 자재 분해 내역 오기) |

---

## 1. Gate 1 — 트리거 reference resolution: **PASS**

option_items 140행 전부 `fn_chk_opt_item_ref` 디스패치와 일치하는 슬롯으로 라이브 차원행을 참조. 라이브 트리거 소스를 직접 읽어 디스패치 대조:

| ref_dim_cd | 트리거 검사 (라이브 소스) | SQL 슬롯 | 정합 |
|------------|------------------------|----------|:--:|
| `.01` 사이즈 | `t_prd_product_sizes(prd_cd, siz_cd=ref_key1)` | `ref_key1=siz_cd, ref_key2=NULL` | ✓ |
| `.03` 자재 | `t_prd_product_materials(prd_cd, mat_cd=ref_key1, usage_cd=ref_key2)` | `ref_key1=mat_cd, ref_key2=USAGE.0x` | ✓ |
| `.04` 공정 | `t_prd_product_processes(prd_cd, proc_cd=ref_key1)` | `ref_key1=proc_cd, ref_key2=NULL` | ✓ |
| `.06` 도수 | `t_prd_product_print_options(prd_cd, opt_id=CAST(ref_key1 AS int))` | `ref_key1='1'/'2'`(opt_id) | ✓ (clr_cd 아님 — MISMATCH-1 정정 준수) |
| `.07` 셋트 | `t_prd_product_sets(prd_cd, sub_prd_cd=ref_key1)` | `ref_key1=PRD_000095/096` | ✓ |

**라이브 DRY-RUN 실증:** `apply.sh dryrun` (BEGIN…apply…ROLLBACK) → 140 option_items INSERT 전건 성공, 트리거 RAISE EXCEPTION 0건. 부재행 INSERTABLE 0. 디스패치 슬롯 오류 0.

전 차원행 라이브 실측 (068/069/071/094):
- 사이즈: 068·069 = 2(SIZ_000170·172) · 071 = 4(+253·255) · 094 = 3(003·004·124) ✓
- 도수 opt_id: 4상품 전부 1·2 라이브 실재 ✓
- 공정: 068 PROC_000014/015/018 · 069 014/015/019/037~044/051/052/076 · 071 014/015/021/076 · 094 015/022/076 — SQL 참조 proc 전건 EXISTS ✓
- 자재 .05 투명커버: 071 MAT_000244/245 실재 ✓ · .07 링컬러: 071 MAT_000013/014/015 실재 ✓
- 셋트: 094 PRD_000095·096 실재 ✓

---

## 2. Gate 2 — 내지/표지 2축 정합: **PASS**

- **자재 90행은 usage_cd로 올바로 분리.** 트리거 `.03`은 `(mat_cd, usage_cd)` 복합 검사. SQL은 내지종이 그룹 → `USAGE.01`, 표지종이 그룹 → `USAGE.02`로 분리 전개(라이브 `t_prd_product_materials` 실측: 같은 종이가 USAGE.01·02로 2벌 링크 확인). 같은 차원의 중복 노출이 아니라 **별 usage 행을 가리키는 정당 분리** → 과대적재 아님.
- **도수 내지/표지 공유 참조 = 트리거 통과 실증.** 라이브 `t_prd_product_print_options`는 usage 식별자 없음(상품당 opt_id 1·2만). 내지인쇄·표지인쇄 2 option_group이 **동일 opt_id 1·2를 공유 참조** → 트리거는 `(prd_cd, opt_id)`만 검사하므로 통과. DRY-RUN에서 표지인쇄 items 전건 INSERT 성공 확인. 이는 라이브 스키마 제약(usage 미구분) 하의 **정직한 절충**이며 GAP-DOSU-USAGE로 정직히 등록됨(발명 아님).

> mat_nm 중복 점검: 4상품 × USAGE.01/02 각 그룹 내 `distinct(mat_nm) = rows` (068:13=13·069:7=7,6=6·071:16=16,28=28·094:1=1) → 가드(`opt_nm=mat_nm`)에 의한 행 손실 위험 **없음**.

---

## 3. Gate 3 — 제본 택일그룹 정직성: **PASS**

cpq-schema §1.5는 GRP-BOOK(PRD_000068~100) excl_group 적재를 기술하나, **라이브 4상품 제본 option_group 0행** 독립 실측 확인:

```
SELECT count(*) FROM t_prd_product_option_groups
 WHERE prd_cd IN (4상품) AND del_yn='N';  → 0  (groups/options/items 전부 0)
```

→ 생성자 판정(stale → 신규생성)이 라이브로 입증됨. **중복 생성 아님.** 제본 택일그룹(SEL_TYPE.01 max_sel=1 mand_yn=Y)을 4상품에 1그룹씩 신규생성(068 중철제본·069 무선제본·071 트윈링제본·094 떡제본, 각 공정 1개). C3로 정직히 에스컬레이션(blocked-and-gaps §3 C3) — cpq-schema 기술을 라이브가 정정.

---

## 4. Gate 4 — page_rule 제외 정합: **PASS**

- 내지페이지·장수가 option_group으로 만들어지지 않음: `grep '내지페이지\|장수' 05_*.sql → 0`.
- page_rule 라이브 실재 + 미손상: 4상품 `t_prd_product_page_rules` 각 1행 실측, 적재 SQL이 손대지 않음(08 constraints는 주석만, INSERT 0행).
- 08 page_rule 언급은 주석 1줄(비옵션 범위 명시)뿐 → constraint로 중복 표현 안 함. 스킬 원칙(quantity=products/page_rule, constraint 아님) 준수.

---

## 5. Gate 5 — 멱등성 / PK 충돌 / disp_seq: **PASS**

**라이브 롤백전용 DRY-RUN 2-pass (단일 트랜잭션):**

| 검사 | 결과 |
|------|------|
| PASS 1 (트리거 통과·insertability) | **32 groups / 140 options / 140 items, ERROR 0** |
| PASS 2 (재적용 delta) | **32 / 140 / 140 — delta 0** |
| 라이브 영속성 (ROLLBACK 후) | **0행** (COMMIT 없음 실증) |

- **opt_cd 동적 채번 PK 충돌 0.** PK = `(prd_cd, opt_cd)`. 채번 `MAX(regexp_replace(opt_cd))+1`이 매 INSERT 재계산 → 트랜잭션 내 직전 INSERT 가시 → 140행 단조 증가, 충돌 0. 시작점 라이브 MAX(opt)=16 → OPV_000017~ 일치.
- **멱등 가드:** option_groups = `(prd_cd, opt_grp_nm)` NOT EXISTS · options = `(prd_cd, opt_nm, opt_grp_cd)` NOT EXISTS · option_items = `(prd_cd, opt_cd, item_seq)` NOT EXISTS. 전 INSERT 자연키 가드 확인 → 2회차 0.
- **opt_grp_cd 리터럴 OPT_000006~037** 라이브 충돌 0(상품별 분리 할당, PK=prd+grp). 시작점 MAX(grp)=5 일치.
- **disp_seq = L1 컬럼 등장순서 정합:** 사이즈1·내지종이2·내지인쇄3·표지종이4·표지인쇄5·표지코팅6·투명커버7·박형압8·제본9·링컬러10·셋트11. 보유 그룹만 부여(빈 disp 생략) — L1 권위 일치.

---

## 6. Gate 6 — 094 셋트 BOM 판정: **PASS** (정직 에스컬레이션 확인)

엽서북 셋트 2행(PRD_000095 내지·PRD_000096 표지) = 생산 BOM 구성(사용자 add-on 아님). 생성자는:
- option_group 1개(셋트구성, mand_yn=N) + `.07` 2 item으로 적재(후보 A) — **하지만 침묵 선택이 아님.**
- **[CONFIRM C1]로 정직히 에스컬레이션**: `blocked-and-gaps.md §3 C1` + 설계 §5.4에 "BOM vs 사용자옵션" 양 후보 명시, "DESIGN DECISION NEEDING CONFIRMATION" 플래그.
- hidden(미노출) 플래그 부재 = **GAP-HIDDEN**으로 별도 등록(option_groups에 auto-apply hidden 컬럼 없음 → ddl-proposer). qty/다른 컬럼에 미노출 의미를 욱여넣지 않음(스킬 GAP 처리 준수).

→ Gate 6 합격: 침묵 선택 아님, C1·GAP-HIDDEN 이중 정직 처리.

---

## 7. 신규 발견 (MINOR — 라우팅 → dbm-option-mapper)

| ID | 심각도 | 내용 | 증거 | 라우팅/수정 |
|----|:--:|------|------|------------|
| **M-1** | MINOR | 설계서 `booklet-option-layer.md §0.1` 자재 행수 표기 stale: 069 내지 8(라이브 7)·071 내지 18(라이브 16)·표지 21(라이브 28) | 라이브 `t_prd_product_materials` 실측 vs §0.1 표 | dbm-option-mapper — §0.1 표를 라이브 실측으로 갱신. **실행본 SQL은 라이브 SELECT 전개라 무영향**(행수는 라이브 권위로 정확, 매니페스트 §2 068=35·069=32·071=60·094=13 합 140 = 독립 재집계 일치) |
| **M-2** | MINOR | 매니페스트 §3 자재 90행 분해 오기: "mat_usage 77 + enum 13"은 틀림. 실제 = mat_usage 85(068:26+069:13+071:44+094:2) + enum 5(투명커버2+링컬러3) = 90 | 라이브 자재행 합산 | dbm-option-mapper — §3 내역만 보정. **합계 90·총 140은 정확**(판정 무영향) |

> 두 MINOR 모두 **문서 표기 stale**일 뿐, 실행본 SQL 동작·DRY-RUN 실측 행수에 영향 없음(SQL이 라이브 자재행을 SELECT로 동적 전개하므로). GO 유지.

---

## 8. 잔존 GAP / [CONFIRM] (이미 정직히 등록 — 재확인)

| 유형 | ID | 내용 | 라우팅 |
|------|----|------|--------|
| GAP | GAP-DOSU-USAGE | print_options usage(내지/표지) 미구분 → 도수 공유 참조 | ddl-proposer |
| GAP | GAP-PARAM | 박/형압 크기·제본방향 param(ref_param_json) 부재 → 069·071 미반영(qty=1) | ddl-proposer (cpq-schema §4 🔴8) |
| GAP | GAP-HIDDEN | 094 셋트 BOM 미노출 플래그 부재 | ddl-proposer |
| CONFIRM | C1 | 094 셋트 = BOM vs 사용자옵션 (본 빌드 후보 A) | 리드/사용자 |
| CONFIRM | C2 | 내지/표지 도수 분리방식 (GAP-DOSU-USAGE 종속) | 리드/ddl-proposer |
| CONFIRM | C3 | 제본 택일그룹 신규생성 정당성 (라이브 0행 실측 입증) | 리드 (라이브가 cpq-schema stale 정정) |

---

## 9. 경계면 PASS/FAIL 요약

| 경계 | 판정 | 핵심 증거 |
|------|:--:|----------|
| option_items ↔ 라이브 차원행 (트리거) | **PASS** | DRY-RUN 140 INSERT 전건 통과·트리거 위반 0·디스패치 슬롯 정합 |
| 내지/표지 2축 (usage_cd 분리·도수 공유) | **PASS** | 자재 .03 (mat_cd,usage) 복합·도수 공유 참조 트리거 통과·과대적재 0 |
| 제본 택일그룹 (라이브 0행) | **PASS** | 4상품 제본 OG 라이브 0행 실측 → 신규생성 정당 |
| page_rule 제외 | **PASS** | option_group 0·SQL 미손상·08 주석만 |
| 멱등성/PK/disp_seq | **PASS** | 2-pass delta 0·PK 충돌 0·ROLLBACK 영속 0·disp_seq L1 정합 |
| 094 셋트 BOM 에스컬레이션 | **PASS** | C1+GAP-HIDDEN 이중 정직 처리·침묵 선택 아님 |

> **NEVER COMMIT.** 모든 DB 접근 = read-only SELECT + 롤백전용 DRY-RUN. 실 COMMIT·코드행 등록·DDL 적용·C1~C3 확정 = 인간 승인.
