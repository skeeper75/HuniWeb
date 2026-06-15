# WIRE 통합 배선 — 독립 실행 게이트 (R1~R6) · 판정: **GO**

> 검증 2026-06-15 · `dbm-validator`(생성자≠검증자 — 빌더 산출 비권위·라이브 읽기전용 자체 SQL 재측정).
> 대상 = `23_remediation-apply/wire-batch/`(빌더 산출). 권위 = `28_price-arbitration/_price-queue-closeout/phase-c-wire-remediation.md`·`29_readiness/_isomorphism/{silsa,photocard}-rep-5layer.md`.
> 라이브 `railway` DB 롤백전용 DRY-RUN(`BEGIN…ROLLBACK`)·실 COMMIT 0·비밀번호 미노출.
> [HARD] 돈 회귀: 기존 단가행 unit_price 변경 **0건 실증**(체크섬 byte-identical).

---

## 0. 종합 판정

| 게이트 | 판정 | 한 줄 |
|--------|:--:|------|
| R1 멱등성 | **PASS** | 라이브 2-pass: PASS1 공식3·배선14·바인딩3·복제6 / PASS2 전건 `0`(delta 0)·복제총수 6→6 |
| R2 트랜잭션·FK순 | **PASS** | apply.sql 단일 BEGIN·ON_ERROR_STOP·중간COMMIT 0·FK순 00→01→02→03 정합 |
| R3 가격사슬 완결 | **PASS** | 031/032/138/024 배선 전 단절→배선 후 JOIN 도달 독립 재현(138 BANNER 3행·024 BULK 50행) |
| R4 단가행 불변(돈) | **PASS** | 기존행(id≤5188) 체크섬 `ba65e8f4…`=byte-identical·복제 6행=원본 verbatim(신값 0) |
| R5 골든 재현 | **PASS** | 5/5 라이브 단가행 직접 룩업 일치(4,500·5,800·3,500·8,000·9,500)·하드코딩 0 |
| R6 독립성·범위 | **PASS** | 별 에이전트·실결함 적발(빌더 체크섬 stale)·범위밖 27상품 전파 미완 정직 분리 |

**전체 = GO** (실 COMMIT·DDL적용·코드행은 인간 승인 — 본 게이트는 비파괴까지).
**가격행 회귀 = 0 확인** (R4 체크섬 byte-identical·복제는 신규 IDENTITY id>5188만).

---

## 1. R1 멱등성 — 라이브 2-pass (PASS)

라이브 PK 독립 실측: formulas=`frm_cd`·formula_components=`(frm_cd,comp_cd)`·product_price_formulas=`(prd_cd,apply_bgn_ymd)`·component_prices=`comp_price_id`(자연키 UNIQUE 부재 확인→ON CONFLICT 불가·NOT EXISTS 가드 정당).

| step | PASS1 | PASS2(멱등) | 가드 |
|------|:--:|:--:|------|
| 00 공식 | INSERT 2+1=3 | `0`·`0` | `ON CONFLICT (frm_cd) DO NOTHING` |
| 01 배선 | 4+6+2+1+1=14 | `0`×5 | `ON CONFLICT (frm_cd,comp_cd) DO NOTHING` |
| 02 바인딩 | UPDATE 1+1+1=3 | `0`×3 | `WHERE frm_cd=<구공식>` |
| 03 복제 | 4+2=6 | `0`·`0` | `INSERT … WHERE NOT EXISTS`(comp+mat+min_qty+siz·NULL-safe `IS NOT DISTINCT FROM`) |

2-pass 후 복제 신규행 총수 = **6**(증가 0). delta 0 독립 재현.

## 2. R2 트랜잭션·FK순 (PASS)

- apply.sql 본문 COMMIT 0건(`grep -i commit` = 주석만)·단일 `BEGIN`·`\set ON_ERROR_STOP on`·중첩트랜잭션 0.
- FK 위상정렬: 00 공식(부모) → 01 배선(FK→공식·comp) → 02 바인딩(FK→공식·ON UPDATE CASCADE) → 03 복제(FK→comp·독립). DRY-RUN 무오류 실행으로 FK 충족 실증(14 comp·031/032/138 전건 라이브 실재).
- 로더 기본 모드 dryrun(ROLLBACK)·--commit은 인간승인+엔진동시배포 선결 명시.

## 3. R3 가격사슬 완결 — 핵심 (PASS)

배선 전 라이브 단절 독립 재측정: NAMECARD_FIXED=STD 2개만·POSTER_FIXED=인화지 1개만·PHOTOCARD_FIXED=SET/CLEAR_SET만. 배선 후 상품→공식→formula_components→comp→단가행 JOIN 도달:

| 상품 | 공식(교체후) | 배선 comp | 단가행 도달 | 배선 전 |
|------|------|------|:--:|:--:|
| 031 | PREMIUM | 본체 4(MGA/MGB×면)+박 6(FOIL 9행×4·SETUP 1행×2) | ✅ 전건 | 단절 |
| 032 | COAT | COAT_S1/S2 각 2행 | ✅ | 단절(STD로 오산) |
| 138 | BANNER_NORMAL | BANNER_NORMAL 3행(8,000~12,000) | ✅ | 인화지만 |
| 024 | PHOTOCARD_FIXED | BULK 50행(+SET/CLEAR_SET) | ✅ | BULK 단절 |

→ 배선이 실제 누락을 해소함을 JOIN으로 입증(빌더 주장 재현).

## 4. R4 단가행 불변(돈) — [HARD] (PASS)

- **사전 기준선(독립 재측정)**: 체크섬 `ba65e8f4b68395726d1f7ee0329b9150`·3,397행·max id 5188.
  ⚠ 빌더 dry-run-result는 3,488행·`3547b5e3…`·max 5161로 보고 — **시점 차이(다른 트랙 변경)**. 검증은 현재 라이브 기준선 사용(빌더 체크섬 불신 = 생성자≠검증자).
- **PASS1 후 기존행(id≤5188) 체크섬** = `ba65e8f4b68395726d1f7ee0329b9150` = 사전과 **byte-identical** → 기존 unit_price 변경 0.
- **복제 6행(id>5188) verbatim**: 081/091=3,500(S1)/4,500(S2)[074 원본]·092=3,800(S1)/4,800(S2)[082 원본]. 새 값 생성 0·하드코딩 0. MATGROUP 묶음(3,500군=074/081/091·3,800군=082/092) 정확.
- `reg_dt` DEFAULT `now()` 실측 확인 → 03이 reg_dt omit해도 NOT NULL 위반 0(round-5 함정 회피). `comp_price_id` IDENTITY BY DEFAULT(omit 자동채번).

## 5. R5 골든 재현 (PASS) — 라이브 단가행 직접 룩업·계산기 하드코딩 0

| 케이스 | 라이브 룩업값 | 기대 | 일치 |
|--------|:--:|:--:|:--:|
| 명함 PREMIUM A군 단면 100매 | 4,500 | 4,500 | ✅ |
| 명함 COAT 082 단면 100매 | 5,800 | 5,800 | ✅ |
| 명함 STD 복제 091 단면 100매 | 3,500(074 verbatim) | 3,500 | ✅ |
| 실사 현수막 BANNER_NORMAL 900x900 | 8,000(siz_nm 좌표 정합) | 8,000 | ✅ |
| 포토카드 BULK 100매 | 9,500 | 9,500 | ✅ |

COAT(081=5,500)와 STD복제(081=3,500)는 **다른 comp**라 같은 mat_cd여도 단가 격리 정확(혼동 0).

## 6. R6 독립성·범위 정직성 (PASS)

- **독립성**: 빌더(생성)≠게이트(검증) 별 에이전트. 실결함 적발 = 빌더 dry-run 체크섬·max id stale(시점 차이) → 검증은 현재 라이브 기준선으로 재측정(빌더 수치 비채택).
- **빌더 분류 정당성**: 순수배선 1(PHOTOCARD-BULK)·공식분리 2(NAMECARD PREMIUM/COAT·SILSA 대표 BANNER_NORMAL)·범위밖 4(스티커 STK-AXIS·아크릴 이중전무·SILSA 전파 26소재·SILSA 격자/CPQ) — 인벤토리 §1/§2 정합.
- **범위밖 분리 정직**: 라이브 PRF_POSTER_FIXED 바인딩 = **28상품**. 138 교체 후 27 잔존 = SILSA 완전 RESOLVED 아님. manifest §7·inventory §3가 "대표 138만 도달·27 전파=별트랙·완전 RESOLVED 아님" 명시 → **거짓 RESOLVED 위장 0**. 042 박(상품권·ddl 의존)도 본 트랙 제외(제안본 §4 ddl-proposer 라우팅).

---

## 7. 인간 승인 대기 (정직 분리·미해소 컨펌)

| 항목 | 상태 |
|------|------|
| 실 COMMIT | 인간 승인 + 엔진(evaluate_price) 동시배포 선결 |
| D-1b 동시배포 [HARD] | manifest §6 명시 — 배선 단독 적용=미정의 동작·엔진 .03/배선 규칙 동시배포 |
| WIRE-1 | 명함 ⓐ단일공식 vs ⓑ공식분리(본 빌드 가정) 최종 비준 |
| WIRE-3b | 명함 박 SETUP 별배선 동판 이중계상 우려 — 골든 미검증(PREMIUM 골든=본체만)·정직 컨펌 잔존 |
| Q-SL-PS-1 | 실사 단일공식 조건분기 vs 소재별분리(대표만 분리) |
| SILSA 전파 27상품·042 박 | 범위밖(round-16 별트랙·ddl-proposer) |

> 엔진 미구현·가격뷰어 비활성 = 실청구 위험 0. 배선·복제는 안전 큐 적재·적용 시점 인간 결정.
