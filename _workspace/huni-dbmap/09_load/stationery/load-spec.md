# stationery(문구) 적재 설계서 (load-spec) — round-3 remediation 전수 확장

> **작성** 2026-06-05 · dbm-mapping-designer · 설명 한국어, 식별자/테이블/컬럼/코드/SQL 영어.
> **범위:** `08_remediation/stationery.md` ⑤의 R1~R5를 FK 순서 적재 설계 + 적재용 CSV로 변환.
> digital-print 파일럿(`09_load/digital-print/`)과 동일 메서드(독립 재생성 자기검증·provenance·보류 분리).
> **DB 쓰기 절대 없음** — INSERT/UPDATE/DDL 0. 산출 = 적재 CSV + 자기검증 스크립트뿐. 적재는 별도 인가 후.
> **권위:** L1 엑셀(`06_extract/stationery-l1.csv`, 24행) = 상품별 진실 · ref 마스터(`00_schema/ref-*.csv`,
> stale 2026-06-04 주의). 추정 0 — 모든 행은 L1 셀 또는 ref 라인에 추적된다(`_provenance` 컬럼).
> **컨펌 권위:** `_confirmations.md` C-1(비활성 제외)·C-3·C-4(권 일괄)·C-6·C-8(관리용이성) binding 적용.

---

## 0. 산출물 맵

| 파일 | 대상 테이블 | 내용 | 행수 |
|------|------------|------|:----:|
| `load/t_prd_product_processes.csv` | t_prd_product_processes | R1 제본 6 + R2 코팅분리 7 (active) | **13** |
| `load/t_prd_products_qtyunit_update.csv` | t_prd_products (UPDATE) | R5 qty_unit 일괄 (QTY_UNIT.03 권) | **11** |
| `t_prd_product_processes_confirm.csv` | (보류) | 제본사양 공란 상품(172·175·176) | 3 |
| `ref097-validation.csv` | (검증기록) | 097 레퍼런스 적재 정확성 검증 | 5 |
| `_deferred/t_prd_product_processes_deferred.csv` | (보류) | use_yn=N 제본 — **본 시트 0행**(no-op) | 0 |

생성기 `gen_load.py`(재현 가능) · 검증 `verify_expected.py`(게이트 **PASS, exit 0**).

> **stationery 특수성:** digital-print과 달리 **IMPORT 자재 적재 없음**(자재=직접명 이미 적재)·**줄수/개수 공정
> 신호 없음**. 핵심 적재축은 단 하나 — **제본사양 enum → 제본 공정 변환**(G-ST-1 BLOCKER). 부차로 표지 코팅 분리.

---

## 1. CRITICAL — 097 떡메모지 레퍼런스 검증 결과 (R1 패턴화 선행)

**과업 지시(머리말):** 떡메모지(097)는 묶음수·페이지룰·제본·excl_group이 *이미* 적재된 "round-3 레퍼런스".
digital-print 016 교훈대로 **무비판 복제 금지 — 097이 엑셀 의도대로 들어갔는지 검증 후 패턴화**.

**검증 절차·결과 (`ref097-validation.csv`, ref-CSV 2026-06-04 기준):**

| 테이블 | ref 실태 | 판정 | finding |
|--------|----------|:----:|---------|
| `t_prd_product_processes` | `PROC_000022 떡제본 · excl_grp_cd=BLANK · mand_proc_yn=N · disp_seq=1` | **PARTIAL** | 떡제본 proc_cd는 **마스터 정합·정확**. 단 `mand_proc_yn=N`(제본=필수 도메인과 불일치)·excl_grp 미연결 |
| `t_prd_product_process_excl_groups` | `GRP-BOOK-제본` 헤더 존재(SEL_TYPE.01·max1·mand=Y·note=`trigger=떡제본`) | **ORPHAN** | 헤더는 있으나 process 행이 그 `excl_grp_cd`를 안 가리킴 → **미연결 고아 헤더**(booklet 떡제본 spillover) |
| `t_prd_product_bundle_qtys` | `50/QTY_UNIT.03/dflt=Y/seq=1` + `100/QTY_UNIT.03/dflt=Y/seq=1` | **DEFECT** | 두 행 **모두 dflt_yn=Y**(이중 기본값)·disp_seq 동일(1) — 기본값 1개 원칙 위배 |
| `t_prd_product_page_rules` | (행 없음) | **CORRECT-BY-DOMAIN** | L1 페이지사양 3/3/3 있으나 떡제본은 page 무의미(recipe §3-2 rule4) → **미적재가 정당**(잡음 회피) |
| `t_prd_product_materials` | `MAT_000073(백색모조지 120g) USAGE.01 dflt=Y` | **MATCH** | L1 `백모조120` → MAT_000073 정합 |

**판정 — 부분 결함 레퍼런스(무비판 복제 금지 입증):**
- 떡메모지 097은 "깨끗한 레퍼런스"가 아니다. **proc_cd·자재·페이지 부재는 옳으나**, ① process의 `mand_proc_yn=N`,
  ② excl_group 헤더가 process와 미연결(고아), ③ bundle 이중 기본값 — **3개 결함 잔존**.
- 따라서 097의 *좋은 부분*(떡제본 단독·excl_group 없이·page_rule 없이)만 패턴화하고, *결함*은 복제하지 않는다.

**조치 (digital-print 016 패턴 동일):**
- **proc_cd 매핑 규칙은 097이 아니라 L1 제본사양 + ref-processes 마스터에서 직접 도출**(아래 §3 R1).
- **mand_proc_yn은 097(N)을 따르지 않고 도메인 권위(PROC_000017 note "필수,단일")대로 Y** 부여 — divergence 명기.
- **excl_group은 G-ST-3대로 생성 안 함**(097 고아 헤더는 booklet spillover, 문구 단일고정엔 불요).
- 097 자체 정정(mand_proc_yn N→Y, bundle 이중기본값, 고아 excl_group)은 **본 패스에서 자동 수정 안 함** —
  finding으로만 보고(과업 지시: EXTRA 삭제·기적재 정정은 별도 인가).

> **설계결정 D-ST-1(컨펌):** 097 process `mand_proc_yn=N`을 Y로 정정할지(제본은 필수)? bundle 이중 dflt_yn=Y를
> 50장만 Y로 정정할지? 고아 GRP-BOOK-제본 헤더를 삭제(문구 단일고정)할지 booklet과 분리 유지할지?

---

## 2. FK 적재 순서 (HARD)

마스터(`t_mat`·`t_proc`·`t_cod`·`t_siz`)는 건전 → **상품 연결 테이블만** 적재. 본 시트 실적재는 process·qty_unit 둘뿐.

```
① qty_unit UPDATE (t_prd_products)   — 컬럼 업데이트, FK 무관, 선/후 무관(독립)
② size                                — n/a (전 11상품 size 1행 기적재, 본 범위 외)
③ material                            — n/a (직접명 이미 적재). 코팅 분해 시 자재 swap만 D-ST-4 보류
④ process (R1 제본 + R2 코팅)         — FK: prd_cd→t_prd_products, proc_cd→t_proc. excl_group 동반 없음(G-ST-3)
⑤ page_rule                           — n/a (엑셀 페이지 공란 / 떡제본 page 무의미). 발명 금지
⑥ bundle_qty                          — n/a (떡메모지 외 묶음 단위 없음, 실버링=링색 아님 묶음)
```

**no-op 단계와 사유 (HARD — 명기):**
- **material 적재 = no-op(이미 적재)**: stationery 자재는 `백모조100→MAT_000072`·`백모조120→MAT_000073`·
  `아트250+무광코팅→MAT_000260(복합)`·`레더→MAT_000008`·`레더(화이트)→MAT_000186`이 **ref에 이미 USAGE 슬롯
  구분 적재됨**(172~181 전상품 내지 USAGE.01/.07 + 표지 USAGE.02). IMPORT 우회 불요(`*별도설정` 아님). 신규 적재 0.
- **excl_group 전무 = 정상(G-ST-3)**: 문구 제본은 상품당 1종 고정(스프링=트윈링만·중철=중철만)이라 **택일 아님**.
  → process 단독 적재, `excl_grp_cd` 공란. 097의 고아 GRP-BOOK-제본은 booklet spillover(§1). MISSING 아님.
- **page_rule 적재 = no-op**: 엑셀 `페이지사양`이 **노트류 전부 공란**(먼슬리플래너 28/28/0·떡메모지 3/3/3만 기재,
  둘 다 이미 적재). 노트류 내지 페이지 출처는 엑셀 외(G-ST-2 CONFIRM) → **자동검출 불가, 발명 금지**.
- **bundle_qty 적재 = no-op**: 묶음수 원천(`제본옵션=50장1권/100장1권`)은 **떡메모지(097)뿐**(이미 적재).
  다른 노트 `제본옵션=실버링`은 **링 색상**이지 묶음수 아님(오해 금지). 메모패드(떡제본)도 L1 묶음 표기 없음.

process는 prd_cd FK가 전 11상품 라이브 등록 확인됨(unmatched 0, remediation §①).

---

## 3. R-카테고리별 적재 설계

### R1 (High · BLOCKER) — 제본 공정 적재 [process active 6행] (G-ST-1)

**도메인 근거(R-PROC-6):** 엑셀 `제본사양` enum = 제본 공정(PROC_000017 family). 원적재가 이 enum을
공정으로 변환하지 못해 노트·다이어리 8상품 제본 0건 = **위젯 제본 옵션 통째 소실 = BLOCKER**.

**변환 로직 (L1 제본사양 → proc_cd · ref-processes 마스터 직접 매핑):**

| L1 제본사양 토큰 | → proc_cd | proc_nm (마스터) | 상품(prd_cd) |
|------------------|:---------:|------------------|--------------|
| `트윈링제본(좌철+실버링)` | **PROC_000021** | 트윈링제본 | 스프링노트 177 |
| `트윈링제본(상철+실버링)` | **PROC_000021** | 트윈링제본 | 스프링수첩 178 |
| `중철제본` | **PROC_000018** | 중철제본 | 중철노트 181 |
| `떡제본` | **PROC_000022** | 떡제본 | 메모패드 179 |
| `하드커버(면지?)` | **PROC_000023** | 하드커버무선제본 | 만년다이어리(하드)173·(레더하드)174 |

> **proc_cd 권위 정정(HARD):** remediation 문서와 recipe-tree는 떡제본=`PROC_000094`/하드커버=`023?`로
> **추정 표기**했으나, **ref-processes 마스터 실값**은 떡제본=**PROC_000022**·하드커버무선제본=**PROC_000023**·
> 트윈링=**PROC_000021**·중철=**PROC_000018**(전부 `upr_proc_cd=PROC_000017` 자식, use_yn=Y). 마스터 = 권위.
> recipe-tree §3-1의 🟡 추정(023/024/094)은 **폐기**하고 마스터 실값 채택.

**적재 컬럼값:**
- `excl_grp_cd` = **공란**(G-ST-3 단일고정, 택일그룹 없음).
- `mand_proc_yn` = **Y**(제본은 필수·단일 — PROC_000017 note "필수,단일" 권위. 097 ref의 N과 divergence, §1·D-ST-1).
- `disp_seq` = 1(상품 첫 공정 = 제본).

**보류 (제본사양 공란 — 발명 금지):**
| prd_cd 상품 | 제본사양 L1 | 처리 |
|-------------|-------------|------|
| 만년다이어리(소프트커버) 172 | **공란** | CONFIRM(`t_prd_product_processes_confirm.csv`) — 소프트커버 제본종류 미명시(무선/떡/제본없음?) |
| 만년다이어리(레더소프트커버) 175 | **공란** | CONFIRM — 〃 |
| 먼슬리플래너 176 | **공란** | CONFIRM — 플래너 제본 미명시(낱장형?) |

**기적재 skip:** 떡메모지(097)는 PROC_000022 이미 적재 → 중복 PK 회피로 active 제외(§1 검증·finding).

> **active 6행** = 173·174(하드커버) + 177·178(트윈링) + 179(떡) + 181(중철). **use_yn=N 노트 제본 0건**
> (180 메모패드준비중은 제본사양도 공란) → `_deferred` process 0행(no-op).
>
> **provenance 예:** `L1:스프링노트 제본사양="트윈링제본(좌철+실버링)" → PROC_000021 트윈링제본(좌철) (R1)`

---

### R2 (Medium · 컨펌후) — 표지 무광코팅 공정 분리 적재 [process active 7행] (G-ST-4)

**도메인 근거(entity-semantic §, C-8):** L1 `표지사양 = 아트250 + 무광코팅`은 **자재(아트지 250g)+공정(무광코팅)
복합표기**. 현 ref material은 이를 `MAT_000260(아트250 + 무광코팅)` **단일 복합자재로 평면 적재**(코팅 미분리).
의미축 분리 규칙: `아트250+무광코팅` → material(아트지250 MAT_000081) + **process(무광코팅 PROC_000015)**.

**처리 — 2단계 분리, 안전부만 적재:**
1. **코팅 공정행 추가(active 적재 — 순수 INSERT·안전):** 표지에 무광코팅이 있는 7상품에
   `PROC_000015(무광)` 공정행 추가. `mand_proc_yn=N`(선택 후가공), `excl_grp_cd` 공란, `disp_seq=5`(제본 1 이후).
2. **자재 복합→분해 swap(보류·컨펌 D-ST-4):** 기적재 `MAT_000260` 복합자재를 `MAT_000081(아트지 250g)`로
   교체하는 것은 **UPDATE성**(기적재 행 변경)이라 본 패스 미수행. **C-8 관리용이성 고려** — 현장에서 복합자재
   1행 유지가 편한지 vs 분해가 위젯 캐스케이드에 필요한지 실무 판단.

**코팅 적재 7상품:** 172·173·176·177·178·179·181 (L1 표지사양에 "+ 무광코팅" 명시 + 현 material MAT_000260 보유).
- **제외:** 174(레더하드)·175(레더소프트) = 표지사양 `레더`(코팅 없음, MAT_000186/MAT_000008). 코팅행 미생성 — 정확.
- **제외:** 떡메모지 097 = 표지 없는 메모지(표지사양 공란) → 코팅 무관.

> **C-8 적용:** 코팅 *공정* 분리는 위젯 옵션(무광/유광 선택)에 필요하므로 active 적재.
> 자재 *복합명* 분해는 관리부담 vs 캐스케이드 저울질 → 실무 컨펌(D-ST-4). **과세분화 강행 금지.**
>
> **provenance 예:** `L1:스프링노트 표지사양="아트250 + 무광코팅" → 코팅공정 분리 PROC_000015 무광 (R2/G-ST-4)`

---

### R3 (Medium · CONFIRM) — 페이지룰 노트류 (적재 변경 없음 · no-op) (G-ST-2)

- **도메인 근거:** `페이지사양_최소/최대/증가` = 내지 페이지 규칙 `t_prd_product_page_rules`.
- **라이브/엑셀 실태:** 페이지값 기재 상품 = 먼슬리플래너(176, 28/28/0)·떡메모지(097, 3/3/3)뿐 — **둘 다 이미 적재**
  (097은 떡제본이라 page 무의미·미적재가 정당, §1). 다른 노트류는 L1 `페이지사양` **전부 공란**.
- **판정:** 노트류 내지 페이지 규칙 **출처가 엑셀 외**(엑셀 공란 = 자동검출 불가). → **발명 금지, 적재 변경 없음.**
  page_rule 출처 확정 후 적재 = 실무 컨펌(D-ST-2).

---

### R4 (정정만) — excl_group · bundle_qty (적재 변경 없음) (G-ST-3·G-ST-5)

- **excl_group(G-ST-3):** 문구 제본 단일고정 → **excl_group 불요**(process 단독, R1에 반영). 적재 변경 없음.
  097 고아 GRP-BOOK-제본 헤더는 정정 후보(D-ST-1)이나 본 패스 미수정(EXTRA 삭제 금지).
- **bundle_qty(G-ST-5):** 묶음수 원천 = 떡메모지(097)뿐(이미 적재). 메모패드(떡제본)도 L1 묶음 표기 없음.
  다른 노트 `제본옵션=실버링`은 링 색상(묶음 아님). → **적재 변경 없음**(097 이중 dflt_yn은 D-ST-1 정정 후보).

---

### R5 (Medium) — qty_unit 일괄 부여 [UPDATE set 11행] (G-ST-6)

- **C-4 binding:** "상품군별 기본 일괄 부여". stationery 노트/문구 → **QTY_UNIT.03(권)**
  (code-values: 권 = 현재 실사용 유일 단위. 노트·다이어리·메모지 모두 권 단위).
- **UPDATE-class:** `t_prd_products.qty_unit_typ_cd` 컬럼 업데이트(INSERT 아님) →
  `load/t_prd_products_qtyunit_update.csv`에 `prd_cd, prd_nm, current(NULL), target(QTY_UNIT.03), use_yn, provenance`.
- **대상:** stationery 11상품 전건(172~181 + 097). 라이브 현재 전건 NULL(G-ST-6, 272 전상품 글로벌 갭).
  use_yn=N 1상품(180 메모패드준비중)도 포함 — 컬럼 업데이트는 비활성 무관, 출시 시 즉시 유효(D-ST-3).
- **글로벌 갭 주의:** qty_unit NULL은 272 전상품 — stationery 한정 아님. 본 set은 stationery 11건만(상품군별 일괄의 한 조각).

---

## 4. 적재 행 요약 (active vs 보류)

| R | 결함 | 대상 테이블 | active 적재 | 보류/no-op | 사유 |
|---|------|------------|:----------:|:----------:|------|
| R1 | 제본 공정 (G-ST-1) | t_prd_product_processes | **6** | 172·175·176=CONFIRM(3) · 097=기적재 | 제본사양 공란·기적재 |
| R2 | 표지 코팅 분리 (G-ST-4) | t_prd_product_processes | **7** | 자재 swap=D-ST-4 보류 | UPDATE성 |
| R3 | 페이지룰 (G-ST-2) | t_prd_product_page_rules | 0(no-op) | 엑셀 공란 | 자동검출 불가·발명 금지 |
| R4 | excl_group·bundle (G-ST-3·5) | — | 0(정정만) | — | 단일고정·묶음 떡메모지뿐 |
| R5 | qty_unit (G-ST-6) | t_prd_products(UPDATE) | **11** | — | — |

- **active 적재 합계: process 13(제본 6 + 코팅 7) + qty_unit 11(UPDATE) = 24행.**
- **보류 합계: 제본 CONFIRM 3 + 자재 swap 컨펌 + page_rule no-op + 097 정정 후보 3.**
- **`_deferred` 0행:** 본 시트 use_yn=N 상품(180)은 제본사양도 공란이라 보류 제본 공정 없음(no-op).

---

## 5. 캐스케이드 제약 — grounded 여부

- **점검 결과: stationery에 grounded disable 제약 없음(발명 금지).** digital-print는 L1 코팅 셀 주석
  "★종이두께선택시 : 180g이상 코팅가능"이라는 **실 disable 근거**가 있었으나, stationery L1 전 컬럼·셀 주석 점검
  결과 **자재→공정 disable 신호 없음**(표지 무광코팅은 무조건 적용, 평량 조건부 아님).
- **간접 캐스케이드(제약 아님):** 제본 종류가 필요 자재/param을 가르는 것(트윈링→링컬러, 하드커버→면지)은
  **옵션 종속**이지 disable 제약이 아니다. constraint_json 신설 대상 아님.
- → **캐스케이드 제약 행 0건.** benchmark §9 권고는 disable 근거가 있는 시트(digital-print)에만 적용.

---

## 6. 설계결정 — 사용자 컨펌 필요 목록

| ID | 결정 사항 | 현 처리 | 컨펌 질문 |
|----|----------|---------|-----------|
| **D-ST-1** | 097 레퍼런스 결함 정정 | finding만(미수정) | process `mand_proc_yn=N→Y`? bundle 이중 dflt_yn을 50장만 Y로? 고아 GRP-BOOK-제본 헤더 삭제/유지? |
| **D-ST-2** | 노트류 page_rule 출처 | no-op(엑셀 공란) | 스프링노트·수첩·메모패드·중철노트 내지 min/max/증가 출처가 엑셀 외 어디인가? page_rule 채울 근거? |
| **D-ST-3** | 소프트커버/플래너 제본종류 | CONFIRM 보류(3상품) | 만년다이어리 소프트(172)·레더소프트(175)·먼슬리플래너(176)는 어떤 제본인가(무선/떡/제본없음)? L1 미명시 |
| **D-ST-4** | 표지 복합자재 분해 | 코팅공정만 적재·자재 swap 보류 | `MAT_000260(아트250+무광코팅)`을 `MAT_000081(아트지250)`로 분해 swap할지? C-8 관리용이성 vs 위젯 캐스케이드 |
| **D-ST-5** | mand_proc_yn=Y 적정성 | Y 부여(제본 필수) | 제본을 mand_proc_yn=Y로 적재(PROC_000017 "필수,단일" 권위)가 위젯/주문 흐름에 맞는가? |
| **D-ST-6** | qty_unit use_yn=N(180) 포함 | 포함(11건) | 미출시 180에도 지금 QTY_UNIT.03 부여? 출시 시 일괄? (컬럼 업데이트라 무해하나 정책 확인) |

> **D-ST-1·D-ST-3은 라이브 SELECT 1~2회 + 엑셀 재확인으로 즉시 해소 가능**(적재 직전 라이브 export로 verify 재실행 시 검출).

---

## 7. stale 주의 (HARD)

- 본 설계는 `ref-*.csv`(2026-06-04 추출본, **stale 가능**)를 자재 기적재·097 레퍼런스·use_yn 판정에 사용.
- **판정이 stale에 의존하는 지점** = 097 process/excl/bundle 실태(§1)·172~181 material 기적재(no-op 근거)·qty_unit NULL.
- **적재 직전 동일 `verify_expected.py`를 라이브 export로 재실행** → stale 격차 검출·해소(검증 권위=라이브 HARD).
- 본 단계 판정은 "**추출본 기준 누락0·날조0**"(자기검증 PASS, `expected-vs-load.md`).
- **proc_cd 매핑은 stale 무관**: ref-processes 마스터(2026-06-03)는 코드 정의라 안정. 떡제본=022 등은 라이브 변동 거의 없음.
