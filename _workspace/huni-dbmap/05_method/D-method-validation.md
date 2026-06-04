# D. 방법론 재설계 1단계 산출물(A·B·C) 독립 교차검증 보고서

> huni-dbmap round-3 방법론 재설계 산출물 D (검증/QA).
> 검증 대상: `05_method/A-etl-bestpractices.md`(리서치) · `B-normalization-rules.md`(규칙사전) · `C-fulldiff-design.md`(전수설계).
> 대조 권위: `00_schema/ref-*.csv`(마스터+9속성 연결) · `04_audit/excel-*.csv`(엑셀 파싱본) · `04_audit/import-resolution.csv` · `HANDOFF-audit.md`.
> 원칙: **독립재검증(HARD)** — A·B·C 상호 인용을 그대로 신뢰하지 않고 소스라인 실재성·분기 도달성·field 대조를 손수 확인. read-only, DB 무변경.
> 검증 방식: ref-*.csv / excel-*.csv 직접 grep 대조(라이브 SELECT 불필요 — 스냅샷으로 결함 체인 전 구간 확인 가능). 작성 2026-06-05.

---

## ① 판정 요약

### 최종 판정: **CONDITIONAL GO**

**근거**: 방법론 A·B·C는 프레임이 일관되고, **핵심 결함 검출 체인(프리미엄엽서 4공정 누락)이 dead link 없이 ref/excel 실측으로 완전 무결**함을 확인했다. B의 "마스터 전체 정합" 인용 표본도 대부분 실측 정합이며 **권위 날조는 발견되지 않았다**. 다만 ① 전수 실행을 막는 미해결 전제 4건(C가 이미 정직하게 플래그)이 해소돼야 하고, ② 경미한 용어/범위 표기 부정확 2건(검출력 무영향)이 정정 권고 대상이라 무조건 GO가 아닌 **CONDITIONAL GO**다. C가 "전수 실행은 본 설계서 범위 밖, 미해결 4건 해소 후"라고 스스로 게이트를 건 것은 정직하므로, **설계 산출물로서는 승인 가능**하고 차단 전제는 전수 실행 단계의 입력 조건이다.

### 7 검증포인트 PASS/FAIL 요약

| # | 검증포인트 | 판정 |
|---|-----------|------|
| 1 | 프레임 일관성("DB 정규화 규칙=기준") | **PASS** |
| 2 | 결함 검출 체인 무결(4공정 누락) | **PASS** (실측 확증, dead link 0) |
| 3 | 인용 실재성(마스터 전체 정합 표본) | **PASS** (1 경미 FLAG) |
| 4 | C 기대행 shape ↔ actual shape 정합 | **PASS** (9속성 전건) |
| 5 | 배제 사전 타당성(결함 재은폐 방지) | **PASS** |
| 6 | 미해결 전제 정직성(4건 플래그) | **PASS** (정직, 과소평가 없음) |
| 7 | A 출처 신뢰성(날조 점검) | **PASS** (날조 없음) |

**적발한 날조/dead link: 0건.** 경미 FLAG 2건(용어·범위 표기, 검출력 무영향).

---

## ② 검증포인트별 결과 (손수 확인 증거)

### 검증포인트 1 — 프레임 일관성 · PASS

- `HANDOFF-audit.md` §1/§3 = "엑셀=권위 단순대조 폐기 → **DB 정규화 규칙=기준**, 엑셀≠DB가 곧 DB 오류 아님". 이 교정이 토대.
- A ①.1("검증 기준은 DB 정규화 규칙이지 엑셀 셀 집합이 아니다") · B ①("프레임은 핸드오프 §3 교정대로 DB 정규화 규칙=기준") · C 프레임(HARD, "비교 기준은 엑셀 셀집합이 아니라 B 규칙이 산출한 expected rows") — **3 문서 전반 일관**. 옛 "엑셀=권위" 프레임 잔존 없음.
- MISSING 재정의("정규화 규칙대로면 적재돼야 할 누락분")가 A §4.3 · B ①(MISSING 재정의) · C 프레임에서 동일 정의로 반복 — 정합.

### 검증포인트 2 — 결함 검출 체인 무결 · PASS (가장 중요, ③에 상세)

엑셀 원천 → B R-PROC-2 → C 코드화 → MISSING 출력까지 전 구간 실측 확인. dead link 0. (상세 ③)

### 검증포인트 3 — 인용 실재성 · PASS (1 경미 FLAG)

실측 대조한 B "마스터 전체 정합" 주장 표본:

| B 인용 | 실측 결과 | 판정 |
|--------|----------|------|
| R-CLR: ref-color-counts 5행(0/1/2/3/4도), CLR_000001 "단면 시 뒷면", CLR_000005 "기본 default" | `cat ref-color-counts.csv` = 정확히 5행, note 문구 일치 | ✅ 정합 |
| R-CLR-1: 프리미엄엽서 print-options 단면(05/01)·양면(05/05) | `grep PRD_000016 ref-product-print-options.csv` = 단면 CLR_000005/CLR_000001, 양면 CLR_000005/CLR_000005 | ✅ 정합 |
| R-PROC-3: 별색 PROC_000007(note "선택유형=다중")+자식 008~012 | `grep ref-processes` = PROC_000007 별색인쇄 note "(선택유형=다중)" + 008~012(화이트/클리어/핑크/금색/은색) upr=PROC_000007 | ✅ 정합 |
| R-PROC-2 일반화: PROC_000079 타공 `구수 max:8` | `grep PROC_000079` = `{구수 max:8 unit:개}` | ✅ 정합 |
| R-MAT-1: 정확매치 74/110 | excel-attrs-normalized.md "정확매치 74/110" 실재 | ✅ 정합 |
| R-SIZE: 사이즈 225/409 매치 | excel-attrs-normalized.md "225/409 매치" 실재 | ✅ 정합 |
| R-COD-1: 묶음수 actual 2상품(97/182)만 | `cat ref-product-bundle-qtys.csv` = PRD_000097·PRD_000182 4행뿐 | ✅ 정합 |

- **경미 FLAG-1 (R-PROC-4 박색상 코드 범위 표기)**: B §③ R-PROC-4가 "박색상 자식 PROC_000034~049"라 범위 표기했으나, 마스터 실측상 034=금/035=은/036=핑크는 **디지털인쇄 4종용**이고 명함 적재(037~044)와 무관. 다만 B의 결론("명함 37~44 적재=정합")은 실측 정합(엑셀 명함 박색상 8종 = {홀로그램037·금유광038·은유광039·먹유광040·동박041·적박042·청박043·트윙클044} 집합 일치 확인). **범위 표기의 느슨함이지 날조 아님, 검출력 무영향.** 정정 권고만.

### 검증포인트 4 — C shape ↔ actual shape 정합 · PASS

C §④ expected 자연키/value 컬럼을 actual ref-product-*.csv 헤더와 전건 대조(실측 header grep):

| 속성 | C §④ 자연키 | actual header | 정합 |
|------|-----------|---------------|:----:|
| 사이즈 | (prd_cd, siz_cd) | prd_cd,siz_cd,dflt_yn,disp_seq | ✅ |
| 자재 | (prd_cd, mat_cd, usage_cd) | prd_cd,mat_cd,usage_cd,dep_proc_cd,dflt_yn | ✅ |
| 인쇄옵션 | (prd_cd, print_side) | prd_cd,opt_id,print_side,front/back_colrcnt_cd | ✅ (opt_id=surrogate, print_side 자연키 정당) |
| 공정 | (prd_cd, proc_cd) | prd_cd,proc_cd,excl_grp_cd,mand_proc_yn | ✅ |
| 공정택일그룹 | (prd_cd, excl_grp_cd) | prd_cd,excl_grp_cd,...,sel_typ_cd,max_sel_cnt,mand_yn | ✅ |
| 판형 | (prd_cd, siz_cd) | prd_cd,siz_cd,dflt_plt_yn,output_paper_typ_cd,output_file_typ | ✅ |
| 묶음수 | (prd_cd, bdl_qty, bdl_unit_typ_cd) | prd_cd,bdl_qty,bdl_unit_typ_cd,dflt_yn | ✅ |
| 페이지룰 | (prd_cd) 1:1 | prd_cd,page_min,page_max,page_incr | ✅ |
| 추가상품 | (prd_cd, addon_prd_cd) | prd_cd,addon_prd_cd,disp_seq,note | ✅ |
| (부속)상품셋트 | (prd_cd, sub_prd_cd) | prd_cd,sub_prd_cd,sub_prd_qty,disp_seq | ✅ |

- 자연키는 모두 actual 컬럼에 실재 → 집합대조 가능. reg_dt/upd_dt 메타컬럼 제외 처리도 명시(C §④). JOIN KEY=prd_nm 정합(ref-products.csv 경유 prd_cd 해소). **9속성+1부속 전건 shape 정합.**

### 검증포인트 5 — 배제 사전 타당성 · PASS

- **별색이 배제되지 않음(핵심)**: C §⑥ 배제 7항목에 별색 5종 **없음**. C §③ 우선순위3 `SPECIAL_COLOR_5` 강제 라우팅으로 PROC_000008~012 expected 산출. 즉 별색은 expected row를 만든다 → 1차 audit가 별색공정 9건을 MISSING으로 잡은 것을 재설계도 동일하게 검출. **결함 재은폐 없음.**
- **공정택일그룹 보류(위험 항목 점검)**: `grep -ic 택일 excel-process.csv` = **0건** → 엑셀에 택일그룹 명시 컬럼이 실제로 없음. C가 "expected 자동산출 보류, 반자동 CONFIRM"로 둔 것은 **권위 부재의 정직한 인정**이지 진짜 MISSING 은폐 아님. excl-groups actual 13행(책자/캘린더만, PRD_000068~112)도 실재 확인.
- **비치수 옵션축 배제(위험 항목 점검)**: 폰모델/색상/온스 등은 t_siz 마스터에 대응 코드 자체가 없으므로 size MISSING으로 집계하면 거짓 MISSING. 정당한 false-positive 차단. 배제 처리가 "삭제"가 아니라 "배제로그 기록"(C §⑥)이라 추적성 유지 → 사후 오배제 점검 가능.

### 검증포인트 6 — 미해결 전제 정직성 · PASS

C §⑧이 플래그한 4건을 실측 교차 — 모두 정직, 과소평가 없음(⑤에 상세). 오히려 #1(IMPORT 매핑)은 import-resolution.csv에 프리미엄엽서 21종이 이미 매핑돼 있어 C가 다소 **보수적**(과대 차단 쪽)이나, "DB_상품(추정)" 컬럼이라 추정 단계이므로 보류 플래그 자체는 정당.

### 검증포인트 7 — A 출처 신뢰성 · PASS

- A §⑦ 11개 출처 도메인 추출: certlibrary / milvus.io / integrate.io(×2) / dqops.com / datagaps.com / icedq.com / conduktor.io / greatexpectations.io / getdbt.com / sciencedirect.com / arxiv.org.
- 전부 실존하는 ETL·data-quality·ML 도메인. arXiv 1506.02629(Holdout Reuse)는 실존 논문 ID 패턴. 명백한 생성·날조 URL 패턴 없음. (깊이 검증 불필요 명시.)

---

## ③ 결함 검출 체인 무결성 상세 (실측 ref 대조)

**1차 결함 = 프리미엄엽서 공정 4종(오시·미싱·가변텍스트·가변이미지) 누락이 "옵션값 제외"로 은폐됨.** 재설계가 이를 잡는지 전 구간 실측:

### 체인 1단계 — 마스터 코드 실재 (ref-processes.csv grep)
```
PROC_000029 오시        upr=[]  prcs_dtl_opt={줄수 max:3 min:0 unit:줄}   ✅ 실재
PROC_000030 미싱        upr=[]  prcs_dtl_opt={줄수 max:3 min:0 unit:줄}   ✅ 실재
PROC_000031 가변텍스트  upr=[]  prcs_dtl_opt={개수 max:3 min:0 unit:개}   ✅ 실재
PROC_000032 가변이미지  upr=[]  prcs_dtl_opt={개수 max:3 min:0 unit:개}   ✅ 실재
PROC_000027 직각        upr=[PROC_000026 귀돌이]                           ✅ 실재
PROC_000028 둥근        upr=[PROC_000026 귀돌이]                           ✅ 실재
```
→ B 주장(줄수 max3·개수 max3)이 마스터 `prcs_dtl_opt` JSON과 **정확 정합**. 마스터에 4공정 다 존재(1층 GO 확인).

### 체인 2단계 — 프리미엄엽서 actual 적재 (ref-product-processes.csv grep)
```
PRD_000016, PROC_000027   ← 직각(귀돌이)
PRD_000016, PROC_000028   ← 둥근(귀돌이)
(PROC_000029/030/031/032 행 없음)         ← MISSING 4건 확증
```
→ B/핸드오프 주장("귀돌이만 적재") 실측 정확. 오시/미싱/가변텍스트/가변이미지 미적재 확증.

### 체인 3단계 — 엑셀 원천 줄수/개수 표기 실재 (excel-process.csv grep)
```
프리미엄엽서 source_values:
  직각 | 둥근 | 없음 | 1줄 | 2줄 | 3줄 | 없음 | 1줄 | 2줄 | 3줄 | 없음 | 1개 | 2개 | 3개 | 없음 | 1개 | 2개 | 3개
  → 줄수블록 ×2 (오시·미싱) + 개수블록 ×2 (가변텍스트·가변이미지) 실재
```
→ B 본문 22행 인용과 **글자 그대로 일치(날조 없음)**. 줄수블록 2·개수블록 2 패턴 실재.

### 체인 4단계 — B R-PROC-2 규칙 → C 코드화 → 출력 (dead link 점검)
- B R-PROC-2(134~141행): `1줄~3줄` 블록2 → 오시(29)·미싱(30), `1개~3개` 블록2 → 가변텍스트(31)·가변이미지(32). 기대행 {27,28,29,30,31,32} − actual {27,28} = **MISSING 4** 명시.
- C §③ 우선순위1 `transform_proc_signal`(123~144행): `group_consecutive(pattern=r'^\d+줄$')` → ANCHOR로 29/30, `r'^\d+개$'` → 31/32. 마스터 정합 게이트(`prcs_dtl_opt 줄수/개수 max ≥ blk.max_n`)까지 코드화.
- C §⑦ 회귀 게이트: "R-PROC-2 검출 MISSING 수 ≥ 프리미엄엽서4+명함2=6" — 0이면 퇴행 신호로 전수 차단.

**dead link 0 — 엑셀 원천(실재) → B R-PROC-2(규칙 명시) → C transform_proc_signal(코드화) → MISSING{29,30,31,32}(출력) → 회귀 게이트(≥6) 까지 전 구간 연결·실측 확인.** 명함 PRD_000031도 엑셀 개수블록2 실재(`없음|1개|2개|3개` ×2) + actual에 31/32 미적재 → MISSING 2 확증.

### 미세 FLAG-2 (C ANCHOR 용어 부정확, 검출력 무영향)
C §③ ANCHOR가 "블록 순서 → **부모공정** 매칭"이라 표현했으나, PROC_000029/030/031/032는 실측상 **upr_proc_cd 비어있는 최상위 leaf**(부모-자식 관계 아님, 각 독립 공정). C의 의도(블록 순서로 어느 proc_cd에 매핑)와 산출 코드는 정확하므로 검출력 무영향. 용어를 "공정코드 매핑"으로 정정 권고.

---

## ④ 발견된 결함 · 날조 · dead link 목록

| ID | 분류 | 위치 | 내용 | 심각도 | 검출력 영향 |
|----|------|------|------|:------:|:----------:|
| FLAG-1 | 범위 표기 느슨 | B §③ R-PROC-4 | "박색상 자식 PROC_000034~049" 범위 표기. 034~036(금/은/핑크)은 디지털 4종용, 명함 적재(037~044)와 무관. 결론(37~44 집합 일치)은 실측 정합 | MINOR | 없음 |
| FLAG-2 | 용어 부정확 | C §③ ANCHOR / B R-PROC-2 표현 | 오시/미싱/가변텍/가변이미지를 "부모공정"이라 칭하나 실측은 upr 빈 최상위 leaf. 매핑 코드·산출은 정확 | MINOR | 없음 |

- **날조(권위 날조) 0건.** 과거 G-1(인용 코드라인 부존재) 같은 사례 없음 — B/C가 인용한 ref 코드값(PROC_000027~032, 007~012, 079, color-counts 5행, bundle-qtys 2상품 등)이 **전부 실측 실재**.
- **dead link 0건.** 결함 검출 체인 전 구간 연결 확인.

---

## ⑤ 전수 실행 전 반드시 해소할 차단 전제

C §⑧이 이미 정직하게 플래그한 4건. 전수 실행(scripts 구현·260상품 적용)의 **입력 조건**이며, 설계 산출물 승인과는 별개:

| # | 차단 전제 | 실측 상태 | 해소 방법 | 미해소 시 영향 |
|---|----------|----------|----------|--------------|
| BLOCK-1 | R-MAT-2 IMPORT 컬럼↔상품 매핑 확정 | import-resolution.csv에 프리미엄엽서 21종·스탠다드엽서 7종 등 16행 매핑 **존재하나 "DB_상품(추정)" 단계** | 추정 매핑을 prd_cd 단위로 확정(read-only) | 자재 expected가 "MISSING 후보(신뢰도 B)"까지만 — 자재 MAJOR 정량화 불가 |
| BLOCK-2 | 중철책자 PRD_000068 sets 0행 구조 확증 | sets 0행 실측 확인. 단 excl-groups엔 GRP-BOOK-제본 보유(다른 제본상품과 동급) → "단일 반제품 구조" 가설 약함 | 라이브 prd 구조 read-only 1회 확증("MISSING vs 정상") | 책자류 셋트 정합이 "보류"로 남음 |
| BLOCK-3 | 공정택일그룹 권위 부재 | excel-process.csv 택일그룹 컬럼 0건 실측 → 자동 MISSING 검출 불가 | 권위 소스(엑셀 외) 확정 전엔 CONFIRM 반자동 점검만 | 공정택일그룹은 자동 4분류 불가(N/A 유지) |
| BLOCK-4 | 줄수형 블록 순서(ANCHOR) 시트별 확정 | R-PROC-2가 동일 `1~3줄` 블록2를 순서(첫=오시·둘째=미싱)로 구분 | 시트별 공정 컬럼 헤더 ANCHOR 테이블을 전수 실행 전 시트마다 확정 | 헤더 앵커 부재 시트는 오시/미싱 오매핑 위험 → 그 시트 보류 |

추가 권고: BLOCK-4가 가장 위험. 엽서 시트는 줄수블록2(오시/미싱)·개수블록2(가변텍/가변이미지)지만, **명함은 줄수블록 없이 개수블록만 2개**(실측). 즉 시트마다 블록 종류·순서가 다르므로 "블록 순서 → 공정" 매핑이 시트 헤더 앵커 없이는 깨진다. ANCHOR 테이블 확정을 BLOCK-4의 1순위로 둘 것.

---

## ⑥ 권고

1. **설계 산출물 A·B·C는 CONDITIONAL GO로 승인 가능.** 프레임 일관·결함 검출 체인 무결·shape 정합·날조 0이 실측으로 입증됐다. 사용자 검토 후 하네스 개선(dbm-mapping-audit 프레임 교정 + 리서치/규칙코드화 단계 신설)으로 진행 권고.
2. **전수 실행 전 BLOCK-1~4 해소가 게이트.** 특히 BLOCK-4(시트별 ANCHOR) 1순위 — 명함/엽서 블록 구조 상이 실측 확인. BLOCK-1은 import-resolution 추정 매핑을 prd_cd 확정으로 승격.
3. **경미 정정 2건**(FLAG-1 박색상 범위 표기, FLAG-2 "부모공정"→"공정코드 매핑" 용어) — 다음 개정 시 반영. 검출력 무영향이라 차단 사유 아님.
4. **회귀 게이트 채택 권고**: C §⑦의 "R-PROC-2 MISSING ≥ 6"을 전수 실행 후 dbm-validator 독립 재검증의 PASS 조건으로 고정. 이 수치가 0이면 규칙 코드화 퇴행 — 1차 결함 재발 신호.
5. **read-only 유지 확인**: A·B·C 모두 no reverse load·DB 미적재 HARD 명시. B의 라이브 추출 1회(ref-product-sets.csv 28행)는 read-only SELECT로 정당. 위반 없음.

---

## 부록 — 검증 수행 로그 (재현 가능)

- 대조 도구: `head`/`grep`/`cat` (read-only), ref-*.csv·excel-*.csv 스냅샷. 라이브 DB SELECT 미수행(스냅샷으로 결함 체인 전 구간 확인 가능).
- 핵심 실측 명령:
  - `grep -E "PROC_00002[6-9]|PROC_00003[0-2]" ref-processes.csv` → 오시/미싱/가변텍/가변이미지 + prcs_dtl_opt 확인
  - `grep PRD_000016 ref-product-processes.csv` → 귀돌이 2종만 적재 확인
  - `grep 프리미엄엽서 excel-process.csv` → 줄수/개수 표기 실재 확인
  - `head -1 ref-product-*.csv` (9속성+sets) → shape 정합 확인
  - `cat ref-color-counts.csv`·`cat ref-product-bundle-qtys.csv` → B 인용 표본 실측
  - `grep -ic 택일 excel-process.csv` = 0 → 공정택일그룹 원천 부재 확증
- 신선도: ref-*.csv = 2026-06-04 추출(round3 fresh). 결정적 존재판정은 본 스냅샷 기준. 전수 실행 시 BLOCK-2는 라이브 재확증 권고.
