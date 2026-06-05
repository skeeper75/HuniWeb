# sticker 적재 설계서 (load-spec) — round-3 remediation 전수 확장

> **작성** 2026-06-05 · dbm-mapping-designer · 설명 한국어, 식별자/테이블/컬럼/코드/SQL 영어.
> **범위:** `08_remediation/sticker.md` ⑤의 R1~R6을 FK 순서 적재 설계 + 적재용 CSV로 변환(digital-print 파일럿 메서드 동일).
> **DB 쓰기 절대 없음** — INSERT/UPDATE/DDL 0. 산출 = 적재 CSV + 자기검증 스크립트뿐. 적재는 별도 인가 후.
> **권위:** L1 엑셀(`06_extract/sticker-l1.csv`, 154행·45컬럼) = 상품별 진실 · ref 마스터(`00_schema/ref-*.csv`,
> stale 2026-06-04 주의) · 도메인 KB(`07_domain/{benchmark-competitors,entity-semantic-model,process-recipe-tree}.md`).
> 추정 0 — 모든 행은 L1 셀 또는 ref/마스터 라인에 추적된다(`_provenance` 컬럼).
> **컨펌 권위:** `_confirmations.md` C-1(비활성 제외)·C-4(스티커→매)·C-7(완칼=공정+조각수 bundle_qty)·C-8(variant 관리용이성) binding 적용.

---

## ⚠️ 0. 머리말 — sticker는 digital-print와 결함 축이 정반대 (remediation 권위 반전)

digital-print 파일럿은 **R-PROC-2(줄수/개수 공정) 누락**이 핵심이었으나, sticker는 다르다(remediation §머리말 권위반전):

1. **커팅 공정(반칼/완칼/스티커완칼)은 이미 14상품에 올바로 적재됨**(라이브 확인). 반칼=PROC_000054·완칼=PROC_000053·스티커완칼=PROC_000055. → **커팅 재적재 금지**(건전, no-op).
2. **빈 `가변(텍스트/이미지)`·`코팅`·`추가상품` 컬럼은 digital-print 템플릿 잔재** — sheet 154행 전부 공백(신호0). VDP/코팅/addon 공정은 sticker에 **존재하지 않는 게 정상**. → non-empty 게이트로 거짓 MISSING 차단(기대행 미생성).
3. **진짜 잔존 결함 = (a) 화이트별색 공정 누락(G-SK-1) + (b) 커팅 형상 enum 축 평면화(G-SK-2)**. 이 둘이 본 적재 설계의 본체다.

본 설계는 **digital-print식 "공정행 자동 생성"을 sticker에 무비판 적용하지 않는다**(false MISSING 위험). L1 화이트 신호와 형상 enum만을 근거로 한다.

---

## 1. 산출물 맵

| 파일 | 대상 테이블 | 내용 | 행수 |
|------|------------|------|:----:|
| `load/t_prd_product_processes.csv` | t_prd_product_processes | R1 화이트별색 공정 (active) | **3** |
| `load/t_prd_products_qtyunit_update.csv` | t_prd_products (UPDATE) | R6 qty_unit 일괄(매) | **16** |
| `_deferred/t_prd_product_processes_deferred.csv` | (보류) | R1 화이트별색 063(use_yn=N) | 1 |
| `_blocked/t_prd_product_sizes_066_circle.BLOCKED.csv` | (보류) | R2 066 원형 11종 — master mint 선행 필요 | 11 |

생성·검증 = `verify_expected.py`(게이트 **PASS, exit 0** — §expected-vs-load).

---

## 2. FK 적재 순서 (HARD)

마스터(`t_proc`·`t_siz`·`t_mat`)는 건전 → **상품 연결 테이블만** 적재. 16/16 상품 `prd_cd` 라이브 등록 확인(unmatched 0).

```
① qty_unit UPDATE (t_prd_products)   — 컬럼 업데이트, FK 무관, 독립(선/후 무관)
② size (형상 enum 치수프리셋)         — R2 BLOCKED: master t_siz_sizes mint 선행 필요(범위밖) → no-op
③ material                           — n/a: 자재 직접명 16상품 전부 기적재 정합(G-SK-5 MATCH) → no-op
④ process (화이트별색)                — R1: FK prd_cd→t_prd_products, proc_cd→t_proc(PROC_000008). 커팅은 기적재 no-op
   excl_group                        — n/a (스티커=단일 커팅, 택일그룹 전무=정상)
⑤ bundle_qty (조각수)                — n/a: 조각수=bundle_qty 차원(C-7)이나 현 라이브 bundle 전무. §3 R-piece 참조(보류)
   page_rule / addon                 — n/a (낱장 스티커→전무=정상)
```

**no-op 단계와 사유:**
- **③ material 전건 no-op = 정상**: sticker는 `*별도설정`(IMPORT 포인터)가 아니라 **자재 직접명**(유포/코팅/투명/홀로그램/타투전용지 등). 16상품 mat_nm 1:1 매치로 이미 충실 적재(052=5종·066=6종 등 remediation §3 일치). digital-print의 IMPORT 미적재(G-DP-3) 결함은 sticker엔 **없음**. → **재적재 금지**.
  - 단 `유포지+엠보코팅`(055·057) = **복합표기(자재+공정)**. 라이브는 자재=MAT_000154 유포지 단독 적재(엠보코팅=공정 별도) → 자재축 정합, 평면화 아님. no-op.
- **④ 커팅 공정 no-op = 정상**: 052~064·066의 커팅(반칼/완칼/스완)은 `disp_seq=1`로 기적재(remediation §3·라이브). 화이트별색은 `disp_seq=2`로 **추가만**(중복 없음).
- **excl_group 전무 = 정상**: 스티커는 단일 커팅 방식(공정 택일그룹 부재). 택일은 책자제본·캘린더가공 도메인.
- **page_rule·addon 전무 = 정상**: 낱장 스티커엔 페이지·추가상품 무의미(빈 컬럼 신호0).
- **065 스티커팩·067 타투스티커 process 0행 = 정상**: 엑셀 `커팅` 공백 → 커팅 공정 미존재(MISSING 아님).

process(④)는 커팅 기적재(seq 1) 뒤 `disp_seq=2`로 화이트별색을 잇는다(FK·순서 안전).

---

## 3. R-카테고리별 적재 설계

### R1 (High) — 화이트별색 공정 적재 [process active 3행, deferred 1]

**도메인 근거(G-SK-1, C-11/entity-semantic-model §3 binding):** 엑셀 `별색인쇄(옵션)_화이트 = 화이트인쇄(단면)`은
빈값이 아니라 **별색(화이트) 공정이 이 상품에 존재한다는 신호**다. 도메인 KB: 별색 = CMYK 외 별도 잉크 후공정,
DB 정규화상 **인쇄 옵션이 아니라 공정**. **투명/홀로그램 원단은 바탕이 비쳐 화이트 underbase 인쇄가 필수**(entity-semantic-model:
화이트=투명소재 베이스 underbase, 표준 강한 근거). 원적재가 별색을 "인쇄 옵션 위치 부속 텍스트"로 오해해 공정 미정규화(digital-print G-DP-7과 동형).

**변환 로직 (L1 → DB):**
| L1 신호컬럼 (값≠`없음`) | 기대 proc_cd | 적재 규칙 |
|-------------------------|:------------:|-----------|
| `별색인쇄(옵션)_화이트` = `화이트인쇄(단면)` | **PROC_000008** (화이트, 자식 leaf) | 부모 PROC_000007(별색인쇄) **미적재**, 자식 leaf만 적재 — **R-PROC-4 규칙**(digital-print 박/형압·귀돌이 자식 leaf 동일) |

- **부모/자식 규칙(R-PROC-4 통일, 머리말 HARD):** 별색 마스터 = 부모 PROC_000007(`선택유형=다중`) + 자식 5종(008화이트/009클리어/010핑크/011금/012은). digital-print의 박색상·형압·귀돌이가 모두 **부모 미적재·자식 leaf 적재**(R-PROC-4)이므로 **화이트도 자식 008만 적재**(부모 007 미적재)로 통일. → 위젯 별색 옵션에서 화이트가 leaf로 직접 노출.
- `mand_proc_yn = N`(선택 별색), `excl_grp_cd` 공란(택일그룹 무관), `disp_seq = 2`(커팅 seq1 다음).

**상품별 패턴 (L1 화이트 신호 검증, 라이브 008 부재 확인 SELECT #6,7):**
| prd_cd | 상품 | 화이트 L1 신호 | use_yn | 분류 |
|--------|------|----------------|:------:|------|
| **053** 반칼 자유형 투명스티커 | 투명 PET | `화이트인쇄(단면)` | Y | **active** |
| **054** 반칼 자유형 홀로그램스티커 | 홀로그램 | `화이트인쇄(단면)` | Y | **active** |
| **056** 낱장 자유형 투명스티커 | 투명전용지 | `화이트인쇄(단면)` | Y | **active** |
| **063** 반칼팬시투명스티커 | 투명 | `화이트인쇄(단면)\|화이트인쇄(없음)` | **N** | **deferred** |

- **active 3행** = 053·054·056 (use_yn=Y, 투명/홀로그램 원단). 라이브 PROC_000008 전부 부재 → 누락 확정.
- **063 deferred** = use_yn=N(C-1 비활성 제외). 출시 시 active 승격해 적재. L1에 `화이트인쇄(없음)` 값도 섞여 있으나 신호 보유 자체는 확정(없음≠전부없음).
- **064 소량자유형 화이트 미보유**: L1 화이트 컬럼 공백(종이 반칼 스티커) → 대상 아님(false 생성 금지).

> **provenance 예:** `L1:반칼 자유형 투명스티커 별색인쇄(옵션)_화이트=화이트인쇄(단면) → 별색(화이트) 공정 PROC_000008(부모 007 미적재·자식 leaf 적재 R-PROC-4). 투명원단 underbase 도메인필수 (R1/G-SK-1)`

---

### R2 (High, BLOCKED/설계) — 커팅 형상·치수 enum 축

**도메인 근거(G-SK-2, benchmark §2 권고):** 도형 enum 상품(058 원형·059 정사각·060 직사각·061 띠지·062 팬시·066 합판도무송)의
엑셀 `커팅`(058~062) / `사이즈`(066) 컬럼은 **그 상품에서 선택 가능한 도형/치수/판당 EA를 정의하는 옵션 축**이다.
이 축이 DB의 size·process·excl 어디에도 표현 안 됨(평면화 drop, L1/L2 교훈 재현).

**benchmark §2 권고(축설계 권위):**
- **모양 = 공정 `prcs_dtl_opt.모양`(기존 유지)** — 완칼 PROC_000053·반칼 054·스티커완칼 055. 후니가 RP/WP보다 명확(이미 root 공정 분리). **재배치 불요.**
- **치수 프리셋 = 사이즈 축 `t_prd_product_sizes`에 적재 + `prcs_dtl_opt.모양`과 짝지음**(캐스케이드 연동). 모양(공정)과 치수(사이즈)는 별 축이되 연동.
- **자유형(non_standard) 치수 = `nonspec_*_min/max` 슬롯**(현재 전상품 NULL — 자유형 052~057·064 보강 대상).

**축설계 결과 (모양 공정 + 치수 size):**
| prd_cd | 상품 | 모양(공정, 기적재) | 치수 enum(size 대상) | DB size 현황 | 적재 판정 |
|--------|------|-------------------|---------------------|:------------:|----------|
| **066** 합판도무송 | PROC_000055 스완 | 원형11·정사각12·직사각14 (37종) | 26행(정사각12+직사각14) | **원형 11종 MISSING** |
| 058 반칼원형 | PROC_000055 스완 | 원형 25~90mm 10종 | A4·A5 2행(판형만) | 형상 enum 축 부재 |
| 059 반칼정사각 | PROC_000055 스완 | 정사각 30~90mm 6종 | A4·A5 2행 | 〃 |
| 060 반칼직사각 | PROC_000055 스완 | 직사각 20×40~120×60 23종 | A4·A5 2행 | 〃 |
| 061 반칼띠지 | PROC_000055 스완 | 띠지 10×190~60×278 15종 | A4·A5 2행 | 〃 |
| 062 반칼팬시 | PROC_000055 스완 | 하트/원형/사각분할 5종 | 100×140·124×186·90×190 3행 | 〃 |

**(A) 066 원형 11종 — MISSING 명확하나 master 부재로 BLOCKED:**
- 라이브 066 size = 26행(정사각 SIZ_000212~223 + 직사각 SIZ_000224~249). 엑셀 `사이즈` 원형 11종(10/15/20/25/30/35/40/45/50/55/60mm) **전부 드롭**(remediation SELECT #11 `siz_nm like '원형%'`=0건).
- **그러나 master `t_siz_sizes`에 합판도무송 원형 size_cd가 부재**(ref-sizes circle 6종=SIZ_000355/369/419~422, 무매치). → `t_prd_product_sizes` link 적재 전에 **master 원형 11 size_cd 신규 mint 필요**.
- **master 쓰기 = 본 과업 범위밖**(HARD: 마스터 건전 전제·상품 연결 테이블만 적재·`t_siz_sizes_dims.SKIP.md` 선례 NO-LOAD). **발명 금지** → `_blocked/t_prd_product_sizes_066_circle.BLOCKED.csv`에 11행 분리(siz_cd=`(MINT_NEEDED)`, 치수·EA는 L1 추출). master mint 인가 시 즉시 link 적재 가능.

**(B) 058~062 형상 enum — 축설계 결정 선행(설계 컨펌):**
- 058~062는 `커팅` 컬럼이 형상 enum 본체(058 원형 25~90mm 10종 등 + `★사이즈선택:A4/A5선택시` 분기). 현 DB는 size=판형(A4/A5)만·process=스완 조각수만 → **형상 enum 축 자체 부재**.
- benchmark §2 권고대로 **치수=size축에 적재**하려면 마찬가지로 master size_cd 부재(원형/띠지/하트 치수 무매치) → 066과 동일 BLOCKED. **단 058~062는 `★사이즈선택`(A4/A5 모지에서 다EA 임포지션) 구조라, "도형별 판당 EA"가 size 재단치수가 아니라 임포지션(plate) 메타일 수 있어 축 귀속이 모호** → **설계 컨펌 D-2 선행**(size 보조 vs plate 메타 vs 신규 커팅옵션 테이블). 본 패스는 **축 미확정으로 적재 보류**(추정 적재 금지).

> **결정 D-1·D-2:** 066 원형 11종 master mint 인가 + 058~062 형상 enum 축 귀속 확정 후 size link 적재. 둘 다 **마스터/축 결정이 선행**이라 본 패스는 BLOCKED 분리만.

---

### R3 (Low, 보류) — 064 소량자유형 size 오공유 (G-SK-3 MISMATCH)

- **도메인 근거:** 064 size 7행 중 **SIZ_000043(80×80) note=`적용=인쇄해더택`**, **SIZ_000036(94×94) note=`적용=인쇄배경지`** — 다른 상품군(헤더택/배경지)의 size_cd를 공유해 스티커에 매단 상태(라이브 SELECT #10 확정, ref 재확인 일치). 나머지 5행(SIZ_000061~065)은 note=`적용=소형반칼스티커`로 정상.
- **판정:** **MISMATCH** — 치수값(80×80·94×94)은 우연히 맞으나 size 마스터 엔트리의 적용 상품이 헤더택/배경지(브리들). 전지 메타(`전지=316×467 / 적용=인쇄배경지`)가 스티커와 무관.
- **처리:** 064 전용 80×80·94×94 size_cd 신규 mint 후 재연결(master 쓰기) **또는** 공유가 의도면 note 정정. **둘 다 master 쓰기 = 범위밖**. + **064 use_yn=N(미출시)** → **Low·보류**(출시 시 처리). 본 패스 적재 변경 없음(컨펌 D-3).

---

### R4 (정정만) — false MISSING 차단 · 자재 MATCH (G-SK-4/5)

- **G-SK-4 빈 컬럼 신호0:** `가변(텍스트)`·`가변(이미지)`·`코팅`·`추가상품` = sheet 154행 전부 공백(L1·라이브 동시 확인). R-PROC-2식 기대행 생성 시 **거짓 MISSING** → **non-empty 게이트로 차단, MISSING 0건**(digital-print 파일럿 경고 함정 회피). 적재 변경 없음.
- **G-SK-5 자재 직접명 MATCH:** 16상품 material = 엑셀 `종이` 직접명과 mat_nm 1:1 매치(usage_cd=USAGE.07 일관). IMPORT 결함 없음. **자재축 건전 → 재적재 금지**(머리말 명시). 적재 변경 없음.
- **삭제 절대 금지:** 본 패스는 누락 행 추가만 — 어떤 행도 삭제 제안하지 않음(EXTRA 삭제 단정 금지 HARD).

---

### R5 (Medium, 컨펌 선행) — 반칼↔스티커완칼 코드 정합 (G-SK-6)

- **도메인 모호:** 058~062는 상품명이 "**반칼**원형/정사각/…스티커"인데 DB는 `PROC_000055 스티커완칼`(완칼+조각수)로 적재. 반칼=Kiss Cut(종이만)인데 "완칼" 계열 코드 부여가 명칭상 불일치로 보일 수 있다.
- **라이브 근거:** PROC_000055 note=`Die Cut + 조각수`. 도형 enum(원형 25mm 등 판당 다EA)은 판 단위 다조각 도무송형이라 스티커완칼이 의미상 맞을 가능성(판당 다조각=스완 규칙).
- **판정:** **CONFIRM — 후니 내부 결정. 발명 금지·flag**(과업 HARD). 의도면 무변경, 오매핑이면 058~062를 PROC_000054(반칼)로 정정. **본 패스는 코드 변경 안 함**(컨펌 D-4 선행). 커팅 기적재는 no-op 유지.

---

### R-piece (C-7, 보류) — 완칼/반칼 조각수 = bundle_qty 차원

- **C-7 binding:** 완칼(PROC_000053/054/055) = **공정으로 적재**(기적재 정합). **조각수 = bundle_qty 차원으로 DB 표현, 위젯 표시는 "조각수"**.
- **L1 조각수 신호:** 052(`*최대20/40조각`)·055·056·057(`5~10조각`·`*최소크기 30×30/10조각이내`)·064(`*1조각`)에 조각수 enum 보유.
- **현 라이브 bundle_qty = 16상품 전부 0행**(remediation §3). 조각수를 `t_prd_product_bundle_qtys`로 옮기는 게 C-7 방향이나:
  1. 조각수 일부는 `조각수(옵션)` 컬럼 enum(052·055·056·057·064), 일부는 `커팅` 컬럼 EA(058~062·066 판당 다EA)로 **두 위치 혼재** → bundle 적재 단위(조각수 enum vs 판당EA)가 모호.
  2. C-7 단서 "완칼 가격은 엑셀 2개 비교 필요(심도)"는 **round-2 가격엔진 영역** — 9속성 적재(본 패스)는 공정 적재까지.
- **판정:** **보류(컨펌 D-5)**. 조각수의 bundle_qty 적재 단위·위젯 매핑 일관성 확정 후 별도 패스. 본 패스 적재 변경 없음(추정 bundle 생성 금지).

---

### R6 (Medium) — qty_unit 일괄 부여 [UPDATE set 16행]

- **C-4 binding:** "상품군별 기본 일괄 부여". sticker 낱장/팩 → **QTY_UNIT.02(매)**.
- **UPDATE-class**: `t_prd_products.qty_unit_typ_cd` 컬럼 업데이트(INSERT 아님) → `t_prd_products_qtyunit_update.csv`에 `prd_cd, prd_nm, current(NULL), target(QTY_UNIT.02), use_yn, _provenance`.
- **대상:** sticker 16상품(PRD_000052~067) 전건. 라이브 현재 전건 NULL(글로벌 갭 G-SK-7). use_yn=N 2상품(063·064)도 포함(컬럼 업데이트는 비활성 무관, 출시 시 즉시 유효).
- **글로벌 갭 주의:** qty_unit NULL은 272 전상품(G-SK-7) — sticker 한정 아님. 본 set은 sticker 16건만. 전사 정책은 상품군별 매핑표(낱장=매/책자=권/굿즈=EA) 별도 일괄(C-4) — 본 패스 범위밖.

---

## 4. 적재 행 요약 (active vs 보류)

| R | 결함 | 대상 테이블 | active 적재 | 보류 | 보류 사유 |
|---|------|------------|:----------:|:----:|----------|
| R1 | 화이트별색 공정 | t_prd_product_processes | **3**(053·054·056) | 063=1(deferred) | use_yn=N(C-1 비활성) |
| R2 | 형상 enum(원형) | t_prd_product_sizes | 0 | 066 원형=11(blocked)·058~062=축미정 | master mint 선행·축설계 컨펌 |
| R3 | 064 size 오공유 | t_siz_sizes/연결 | 0 | (정정 보류) | master 쓰기·use_yn=N Low |
| R4 | false MISSING·자재 | — | 0(정정만) | — | 신호0 차단·자재 MATCH |
| R5 | 반칼↔스완 코드 | t_prd_product_processes | 0 | (컨펌 선행) | 후니 내부 결정 flag |
| R-piece | 조각수 bundle_qty | t_prd_product_bundle_qtys | 0 | (보류) | 적재 단위 모호·round-2 |
| R6 | qty_unit | t_prd_products(UPDATE) | **16** | — | — |

- **active 적재 합계: process 3 + qtyunit 16 = 19행.**
- **보류 합계: deferred 1(화이트별색 063) + blocked 11(066 원형 size) + 축미정/컨펌(058~062·064·R5·R-piece).**

---

## 5. 캐스케이드 제약 메모 (benchmark §9 권고)

- benchmark §9는 후니 스키마가 경쟁사 표현력을 흡수했으나 **단 하나 — 캐스케이드 제약(자재/사이즈→공정 disable)**만 보강 권고.
- **sticker에서 발견된 캐스케이드 후보:** 형상 enum 상품의 `★사이즈선택:A4/A5선택시` 분기 = **사이즈(모지 A4/A5) 선택 → 가능 도형 enum 변경**(예 058 A4선택시 다른 원형 세트). 이는 자재→공정 disable이 아니라 **size→shape-enum 캐스케이드**.
- **본 패스 적재 안 함:** 형상 enum 축(R2)이 BLOCKED/미확정이라 그 위에 얹는 캐스케이드도 보류. R2 축설계 확정 시 함께 설계(위젯 도형 선택 UI의 size-gating). 추정 제약 생성 금지.

---

## 6. 설계결정 — 사용자 컨펌 필요 목록

| ID | 결정 사항 | 현 처리 | 컨펌 질문 |
|----|----------|---------|-----------|
| **D-1** | 화이트별색 부모/자식 규칙 | active 3행 자식 008만 적재(R-PROC-4 통일) | 투명/홀로그램(053·054·056) 화이트인쇄를 자식 PROC_000008만 적재(부모 007 미적재)가 맞나? digital-print 별색 패턴과 동일 적용 OK? |
| **D-2** | 066 원형 11종 master mint | blocked(11행 분리, siz_cd=MINT_NEEDED) | 합판도무송 원형 10~60mm 11 size_cd를 master `t_siz_sizes`에 신규 mint 인가? (마스터 쓰기 — 별도 인가) |
| **D-3** | 058~062 형상 enum 축 귀속 | 보류(축 미확정) | 도형별 치수/판당EA를 size 보조 vs plate 임포지션 메타 vs 신규 커팅옵션 테이블 중 어디에? `★사이즈선택` 분기 의미는? |
| **D-4** | 064 size 오공유 정정 | 보류(use_yn=N Low) | 80×80(헤더택)·94×94(배경지) 공유가 의도(동일 치수 재사용)인가? 전용 size 분리할지 note만 정정할지? |
| **D-5** | 반칼↔스완 코드(058~062) | 무변경(flag) | "반칼○○스티커"를 PROC_000055 스티커완칼로 매핑이 의도(판당 다조각=스완)인가, PROC_000054 반칼로 정정인가? (후니 내부) |
| **D-6** | 조각수 bundle_qty 적재 | 보류 | 조각수(052·055~057·064)·판당EA(058~062·066)를 `t_prd_product_bundle_qtys`로 적재? 적재 단위·위젯 조각수 매핑 일관성? (round-2 가격과 교차) |
| **D-7** | 빈 가변/코팅/addon | 신호0 차단(미적재) | sticker에 VDP/코팅/addon이 실제로 없는 게 맞나? (위젯 옵션에서 제외 확정용) |

> **D-1·D-2·D-4는 라이브 SELECT/master 확인으로 즉시 해소 가능**(적재 직전 라이브 export로 verify 재실행 시 stale 격차 검출).

---

## 7. stale 주의 (HARD)

- 본 설계는 `ref-*.csv`(2026-06-04 추출본, **stale 가능**)를 기적재/master 판정에 사용.
- **판정이 stale에 의존하는 지점** = 화이트별색 기적재 여부(053·054·056 PROC_000008 부재)·066 원형 master 부재(circle 6종 무매치)·064 오공유(SIZ_000036/043 note).
- **적재 직전 동일 `verify_expected.py`를 라이브 export로 재실행** → stale 격차 검출·해소(검증 권위=라이브 HARD). 특히 066 원형이 라이브에 이미 mint돼 있으면 BLOCKED 해제(link만 적재).
- 본 단계 판정은 "**추출본 기준 누락0·날조0·비활성분리·마스터부재차단**"(자기검증 PASS, `expected-vs-load.md`).
