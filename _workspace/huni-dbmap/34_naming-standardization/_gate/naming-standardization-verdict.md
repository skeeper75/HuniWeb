# 네이밍 표준화 적재 독립 검증 verdict (round-34 · R게이트)

> **검증자:** dbm-validator (생성자≠검증자) · 2026-06-18
> **대상:** `34_naming-standardization/_exec_naming/` (apply.sql·_naming_updates.sql·dryrun.sql·gen_naming_sql.py·manifest.md)
> **권위:** `component-naming-cleanup.md`(v2) · `standard-term-dictionary.md`(v2) · `naming-domain-refinement.md`
> **방법:** 라이브 read-only SELECT + **검증자 자작** BEGIN…ROLLBACK 독립 DRY-RUN(생성자 dryrun.sql 재실행 아님). 실 COMMIT/DDL 0. 비밀값 미출력.

## 종합: **GO** ✅ (R1~R6 전건 PASS · 결함 0)

생성자 주장(코드노출 102→2·변경 111행·가격행/use_yn 무변경·멱등)을 라이브에서 **독립 재측정으로 전건 재현**. 임의 변형·날조·과장 적발 0.

---

## R1 코드노출 제거 — **PASS**
독립 BEGIN…apply…측정:
- BEFORE `comp_nm LIKE '%[COMP_%'` = **102** (라이브 실측, 생성자 주장 일치)
- AFTER = **2** — 잔존 comp_cd 정확히 `COMP_POPT_BNR_GAKMOK_STR_900_4` · `COMP_POSTEROPT_BANNER_MESH_PROC_OPT` (제외한 빈더미 2건뿐)
- 빈더미 제외 코드노출 = **0** (목표 달성). 그 외 잔존 0.

## R2 표준 용어 정확성 — **PASS**
- 후니 고유용어 전건 반영 확인: 스탠다드명함(2)·화이트인쇄명함(4)·펄명함(스타드림)(2)·오리지널박명함(4)·떡메모지 완제품가(1)·합판도무송 완제품가(1).
- 컨펌 해소 반영: 귀돌이비(2)·큐방(2)·열재단(1)·봉미싱(1)·각목(900mm 초과/이하)+끈(2)·오시비/미싱비(각2).
- byte-match 표본 6건 cleanup-v2 표와 정확 일치(A-1·A-2·A-4·A-7·A-10·A-12). 임의 변형 0.
- `[레거시]` 태그 6건 = 라이브 `use_yn=N` 6 포스터(ADH_WATERPROOF_PVC·ARTFABRIC_GRAPHIC·LEATHER_ARTPRINT·MESH_PRINT·TYVEK_PRINT·WATERPROOF_PET)와 정확 대응. 활성(Y) 포스터에 오태깅 0.

## R3 무변경 불변식 — **PASS**
독립 측정(BEGIN…apply…before≠after diff):
- 변경 행수 = **111** (comp_nm 110 · note 2 · comp_typ_cd 1; TATTOO 1행에서 3컬럼 동시 → distinct 111)
- `use_yn` 변동 = **0행** · 그 외 컬럼 변동 0
- 가격행(`t_prc_component_prices`) 변동 = **0행** · 총 가격행 7293 → **7293**(무변경)
- comp 총행수 146 → **146** (INSERT/DELETE 0)
- `_naming_updates.sql` 정적 스캔: INSERT/DELETE/DROP/ALTER/CREATE/TRUNCATE **0** — 순수 가드형 UPDATE
- `comp_typ_cd = PRC_COMPONENT_TYPE.06`(완제품비) = 라이브 `t_cod_base_codes` 실존 코드(타 92 comp 사용)·타투=완제품가로 도메인 정합

## R4 멱등성 — **PASS**
- PASS-1: 111 UPDATE 발화 · PASS-2: 전 UPDATE `UPDATE 0` · `pass2_changed_rows = 0`
- `comp_nm/note/comp_typ_cd IS DISTINCT FROM 목표값` 가드 SQL 실재 확인. 2회차 0행 라이브 실증.

## R5 권위 정합(후니 우선) — **PASS**
라이브 note/proc 재실측으로 표준어 도출 근거 확인:
- 라이브 `t_prc_component_prices.note`: 큐방(4개)·열재단·봉미싱·양면테잎·각목(900mm 초과/이하)+끈(4개)·우드행거+면끈/A2A3A4·천정형고리·실외용배너거치대(단면용)·오리지널박명함·스탠다드명함·화이트인쇄명함(큐리어스스킨)·펄명함(스타드림) — **전건 verbatim 실재**.
- 라이브 `proc_nm`: 귀돌이(PROC_000026)·열재단(PROC_000084/096)·미싱·오시·봉제·제본 실존.
  - "봉미싱"은 proc("봉제")가 아닌 현수막 add-on note 권위에서 도출(문서화된 정당 분기·날조 아님).
- **rpmeta(RedPrinting) naming/codes 유입 0**: 제안 comp_nm 전수 토큰 스캔(QBG/LUM/ROP/SEW_DFT/CUT_ZUN/CDL/_DFT/RP_) → **LEAK 0**. 흡수만, 후니 한글 표준 채택.

## R6 라이브 DRY-RUN·독립 — **PASS**
- 검증자 자작 harness로 BEGIN…apply×2…측정…**ROLLBACK**(COMMIT 0). 생성자 dryrun.sql 미사용.
- note 빈값 보강: COROTTO(note EMPTY·use_yn=Y) · TATTOO(note EMPTY+comp_typ_cd EMPTY) pre-state 실측 → 보강 후 use_yn=Y note 빈값 **0** · comp_typ_cd 빈값 **0**.
- 빈더미 2건(price_rows=0·use_yn=Y) 적재 대상 미포함(제외) 확인 — 정당.
- ROLLBACK 후 라이브 무흔적(read-only 보장).

---

## dodge-hunt (생성자 회피/과장 적발)
- **과장 0**: 코드노출 102→2·변경 111·가격행 0·멱등 0 모두 독립 재현(부풀림 없음).
- **회피 0**: 빈더미 2건 제외를 manifest §3·§4·SQL 주석에 명시·BLOCKED 가장 없음. 레거시 [레거시] 태그도 use_yn=N으로 정직 검증됨.
- **날조 0**: 표준어 전건 라이브 note/proc에서 byte 도출. rpmeta naming 유입 0.
- 단일 결함 미발견 → NO-GO 라우팅 불요.

## 인간 승인 큐
1. `./apply.sh --commit` (백업 `./apply.sh backup` 선행 권장) — 실 COMMIT은 인간 승인.
2. 빈더미 2건(PROC_OPT·GAKMOK base) use_yn=N 정리 = 별도 트랙(이번 범위 외·정책 결정).
